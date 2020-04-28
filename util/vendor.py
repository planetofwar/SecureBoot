#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse
import fnmatch
import logging as log
import os
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path

import hjson

DESC = """vendor, copy source code from upstream into this repository"""

EXCLUDE_ALWAYS = ['.git']

LOCK_FILE_HEADER = """// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This file is generated by the util/vendor script. Please do not modify it
// manually.

"""

verbose = False


def git_is_clean_workdir(git_workdir):
    """Check if the git working directory is clean (no unstaged or staged changes)"""
    cmd = ['git', 'status', '--untracked-files=no', '--porcelain']
    modified_files = subprocess.run(cmd,
                                    cwd=str(git_workdir),
                                    check=True,
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE).stdout.strip()
    return not modified_files


def path_resolve(path, base_dir=Path.cwd()):
    """Create an absolute path. Relative paths are resolved using base_dir as base."""

    if isinstance(path, str):
        path = Path(path)

    if path.is_absolute():
        return path

    return (base_dir / path).resolve()


def github_qualify_references(log, repo_userorg, repo_name):
    """ Replace "unqualified" GitHub references with "fully qualified" one

    GitHub automatically links issues and pull requests if they have a specific
    format. Links can be qualified with the user/org name and the repository
    name, or unqualified, if they only contain the issue or pull request number.

    This function converts all unqualified references to qualified ones.

    See https://help.github.com/en/articles/autolinked-references-and-urls#issues-and-pull-requests
    for a documentation of all supported formats.
    """

    r = re.compile(r"(^|[^\w])(?:#|[gG][hH]-)(\d+)\b")
    repl_str = r'\1%s/%s#\2' % (repo_userorg, repo_name)
    return [r.sub(repl_str, l) for l in log]


def test_github_qualify_references():
    repo_userorg = 'lowRISC'
    repo_name = 'ibex'

    # Unqualified references, should be replaced
    items_unqualified = [
        '#28',
        'GH-27',
        'klaus #27',
        'Fixes #27',
        'Fixes #27 and #28',
        '(#27)',
        'something (#27) done',
        '#27 and (GH-38)',
    ]
    exp_items_unqualified = [
        'lowRISC/ibex#28',
        'lowRISC/ibex#27',
        'klaus lowRISC/ibex#27',
        'Fixes lowRISC/ibex#27',
        'Fixes lowRISC/ibex#27 and lowRISC/ibex#28',
        '(lowRISC/ibex#27)',
        'something (lowRISC/ibex#27) done',
        'lowRISC/ibex#27 and (lowRISC/ibex#38)',
    ]
    assert github_qualify_references(items_unqualified, repo_userorg,
                                     repo_name) == exp_items_unqualified

    # Qualified references, should stay as they are
    items_qualified = [
        'Fixes lowrisc/ibex#27',
        'lowrisc/ibex#2',
    ]
    assert github_qualify_references(items_qualified, repo_userorg,
                                     repo_name) == items_qualified

    # Invalid references, should stay as they are
    items_invalid = [
        'something#27',
        'lowrisc/ibex#',
    ]
    assert github_qualify_references(items_invalid, repo_userorg,
                                     repo_name) == items_invalid


def test_github_parse_url():
    assert github_parse_url('https://example.com/something/asdf.git') is None
    assert github_parse_url('https://github.com/lowRISC/ibex.git') == (
        'lowRISC', 'ibex')
    assert github_parse_url('https://github.com/lowRISC/ibex') == ('lowRISC',
                                                                   'ibex')
    assert github_parse_url('git@github.com:lowRISC/ibex.git') == ('lowRISC',
                                                                   'ibex')


def github_parse_url(github_repo_url):
    """Parse a GitHub repository URL into its parts.

    Return a tuple (userorg, name), or None if the parsing failed.
    """

    regex = r"(?:@github\.com\:|\/github\.com\/)([a-zA-Z\d-]+)\/([a-zA-Z\d-]+)(?:\.git)?$"
    m = re.search(regex, github_repo_url)
    if m is None:
        return None
    return (m.group(1), m.group(2))


def produce_shortlog(clone_dir, old_rev, new_rev):
    """ Produce a list of changes between two revisions, one revision per line

    Merges are excluded"""
    cmd = [
        'git', '-C',
        str(clone_dir), 'log', '--pretty=format:%s (%aN)', '--no-merges',
        old_rev + '..' + new_rev, '.'
    ]
    try:
        proc = subprocess.run(cmd,
                              cwd=str(clone_dir),
                              check=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE,
                              universal_newlines=True)
        return proc.stdout.splitlines()
    except subprocess.CalledProcessError as e:
        log.error("Unable to capture shortlog: %s", e.stderr)
        return ""


def format_list_to_str(list, width=70):
    """ Create Markdown-style formatted string from a list of strings """
    wrapper = textwrap.TextWrapper(initial_indent="* ",
                                   subsequent_indent="  ",
                                   width=width)
    return '\n'.join([wrapper.fill(s) for s in list])


def refresh_patches(desc):
    if 'patch_repo' not in desc:
        log.fatal('Unable to refresh patches, patch_repo not set in config.')
        sys.exit(1)

    patch_dir_abs = path_resolve(desc['patch_dir'], desc['_base_dir'])
    log.info('Refreshing patches in %s' % (str(patch_dir_abs), ))

    # remove existing patches
    for patch in patch_dir_abs.glob('*.patch'):
        os.unlink(str(patch))

    # get current patches
    _export_patches(desc['patch_repo']['url'], patch_dir_abs,
                    desc['patch_repo']['rev_base'],
                    desc['patch_repo']['rev_patched'])


def _export_patches(patchrepo_clone_url, target_patch_dir, upstream_rev,
                    patched_rev):
    clone_dir = Path(tempfile.mkdtemp())
    try:
        clone_git_repo(patchrepo_clone_url, clone_dir, patched_rev)
        rev_range = 'origin/' + upstream_rev + '..' + 'origin/' + patched_rev
        cmd = ['git', 'format-patch', '-o', str(target_patch_dir), rev_range]
        if not verbose:
            cmd += ['-q']
        subprocess.run(cmd, cwd=str(clone_dir), check=True)

    finally:
        shutil.rmtree(str(clone_dir), ignore_errors=True)


def import_from_upstream(upstream_path, target_path, exclude_files=[]):
    log.info('Copying upstream sources to %s', target_path)
    # remove existing directories before importing them again
    shutil.rmtree(str(target_path), ignore_errors=True)

    # import new contents for rtl directory
    _cp_from_upstream(upstream_path, target_path, exclude_files)


def apply_patch(basedir, patchfile, strip_level=1):
    cmd = ['git', 'apply', '-p' + str(strip_level), str(patchfile)]
    if verbose:
        cmd += ['--verbose']
    subprocess.run(cmd, cwd=str(basedir), check=True)


def clone_git_repo(repo_url, clone_dir, rev='master'):
    log.info('Cloning upstream repository %s @ %s', repo_url, rev)

    # Clone the whole repository
    cmd = ['git', 'clone', '--no-single-branch']
    if not verbose:
        cmd += ['-q']
    cmd += [repo_url, str(clone_dir)]
    subprocess.run(cmd, check=True)

    # Check out exactly the revision requested
    cmd = ['git', '-C', str(clone_dir), 'checkout', '--force', rev]
    if not verbose:
        cmd += ['-q']
    subprocess.run(cmd, check=True)

    # Get revision information
    cmd = ['git', '-C', str(clone_dir), 'rev-parse', 'HEAD']
    rev = subprocess.run(cmd,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         check=True,
                         universal_newlines=True).stdout.strip()
    log.info('Cloned at revision %s', rev)
    return rev


def git_get_short_rev(clone_dir, rev):
    """ Get the shortened SHA-1 hash for a revision """
    cmd = ['git', '-C', str(clone_dir), 'rev-parse', '--short', rev]
    short_rev = subprocess.run(cmd,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE,
                               check=True,
                               universal_newlines=True).stdout.strip()
    return short_rev


def git_add_commit(repo_base, paths, commit_msg):
    """ Stage and commit all changes in paths"""

    # Stage all changes
    for p in paths:
        cmd_add = ['git', '-C', str(repo_base), 'add', str(p)]
        subprocess.run(cmd_add, check=True)

    cmd_commit = ['git', '-C', str(repo_base), 'commit', '-s', '-F', '-']
    try:
        subprocess.run(cmd_commit,
                       check=True,
                       universal_newlines=True,
                       input=commit_msg)
    except subprocess.CalledProcessError:
        log.warning("Unable to create commit. Are there no changes?")


def ignore_patterns(base_dir, *patterns):
    """Similar to shutil.ignore_patterns, but with support for directory excludes."""
    def _rel_to_base(path, name):
        return os.path.relpath(os.path.join(path, name), base_dir)

    def _ignore_patterns(path, names):
        ignored_names = []
        for pattern in patterns:
            pattern_matches = [
                n for n in names
                if fnmatch.fnmatch(_rel_to_base(path, n), pattern)
            ]
            ignored_names.extend(pattern_matches)
        return set(ignored_names)

    return _ignore_patterns


def _cp_from_upstream(src, dest, exclude=[]):
    shutil.copytree(str(src),
                    str(dest),
                    ignore=ignore_patterns(str(src), *exclude))


def main(argv):
    parser = argparse.ArgumentParser(prog="vendor", description=DESC)
    parser.add_argument(
        '--update',
        '-U',
        dest='update',
        action='store_true',
        help='Update locked version of repository with upstream changes')
    parser.add_argument('--refresh-patches',
                        action='store_true',
                        help='Refresh the patches from the patch repository')
    parser.add_argument('--commit',
                        '-c',
                        action='store_true',
                        help='Commit the changes')
    parser.add_argument('desc_file',
                        metavar='file',
                        type=argparse.FileType('r', encoding='UTF-8'),
                        help='vendoring description file (*.vendor.hjson)')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose')
    args = parser.parse_args()

    global verbose
    verbose = args.verbose
    if (verbose):
        log.basicConfig(format="%(levelname)s: %(message)s", level=log.DEBUG)
    else:
        log.basicConfig(format="%(levelname)s: %(message)s")

    desc_file_path = Path(args.desc_file.name).resolve()
    vendor_file_base_dir = desc_file_path.parent

    # Precondition: Ensure description file matches our naming rules
    if not str(desc_file_path).endswith('.vendor.hjson'):
        log.fatal("Description file names must have a .vendor.hjson suffix.")
        raise SystemExit(1)

    # Precondition: Check for a clean working directory when commit is requested
    if args.commit:
        if not git_is_clean_workdir(vendor_file_base_dir):
            log.fatal("A clean git working directory is required for "
                      "--commit/-c. git stash your changes and try again.")
            raise SystemExit(1)

    # Load description file
    try:
        desc = hjson.loads(args.desc_file.read(), use_decimal=True)
    except ValueError:
        raise SystemExit(sys.exc_info()[1])
    desc['_base_dir'] = vendor_file_base_dir

    desc_file_stem = desc_file_path.name.rsplit('.', 2)[0]
    lock_file_path = desc_file_path.with_name(desc_file_stem + '.lock.hjson')

    # Importing may use lock file upstream, information, so make a copy now
    # which we can overwrite with the upstream information from the lock file.
    import_desc = desc.copy()

    # Load lock file contents (if possible)
    try:
        with open(str(lock_file_path), 'r') as f:
            lock = hjson.loads(f.read(), use_decimal=True)

        # Use lock file information for import
        if not args.update:
            import_desc['upstream'] = lock['upstream'].copy()
    except FileNotFoundError:
        lock = None
        if not args.update:
            log.warning("Updating upstream repo as lock file %s not found.",
                        str(lock_file_path))
            args.update = True

    if args.refresh_patches:
        refresh_patches(import_desc)

    clone_dir = Path(tempfile.mkdtemp())
    try:
        # clone upstream repository
        upstream_new_rev = clone_git_repo(import_desc['upstream']['url'],
                                          clone_dir,
                                          rev=import_desc['upstream']['rev'])

        if not args.update:
            if upstream_new_rev != lock['upstream']['rev']:
                log.fatal(
                    "Revision mismatch. Unable to re-clone locked version of repository."
                )
                log.fatal("Attempted revision: %s", import_desc['upstream']['rev'])
                log.fatal("Re-cloned revision: %s", upstream_new_rev)
                raise SystemExit(1)

        upstream_only_subdir = ''
        clone_subdir = clone_dir
        if 'only_subdir' in import_desc['upstream']:
            upstream_only_subdir = import_desc['upstream']['only_subdir']
            clone_subdir = clone_dir / upstream_only_subdir
            if not clone_subdir.is_dir():
                log.fatal("subdir '%s' does not exist in repo",
                          upstream_only_subdir)
                raise SystemExit(1)

        # apply patches to upstream sources
        if 'patch_dir' in import_desc:
            patches = path_resolve(import_desc['patch_dir'],
                                   vendor_file_base_dir).glob('*.patch')
            for patch in sorted(patches):
                log.info("Applying patch %s" % str(patch))
                apply_patch(clone_subdir, patch)

        # import selected (patched) files from upstream repo
        exclude_files = []
        if 'exclude_from_upstream' in import_desc:
            exclude_files += import_desc['exclude_from_upstream']
        exclude_files += EXCLUDE_ALWAYS

        import_from_upstream(
            clone_subdir, path_resolve(import_desc['target_dir'],
                                       vendor_file_base_dir), exclude_files)

        # get shortlog
        get_shortlog = bool(args.update)
        if lock is None:
            get_shortlog = False
            log.warning("No lock file %s: unable to summarize changes.", str(lock_file_path))
        elif lock['upstream']['url'] != import_desc['upstream']['url']:
            get_shortlog = False
            log.warning(
                "The repository URL changed since the last run. Unable to get log of changes."
            )

        shortlog = None
        if get_shortlog:
            shortlog = produce_shortlog(clone_subdir, lock['upstream']['rev'],
                                        upstream_new_rev)

            # Ensure fully-qualified issue/PR references for GitHub repos
            gh_repo_info = github_parse_url(import_desc['upstream']['url'])
            if gh_repo_info:
                shortlog = github_qualify_references(shortlog, gh_repo_info[0],
                                                     gh_repo_info[1])

            log.info("Changes since the last import:\n" +
                     format_list_to_str(shortlog))

        # write lock file
        if args.update:
            lock = {}
            lock['upstream'] = import_desc['upstream'].copy()
            lock['upstream']['rev'] = upstream_new_rev
            with open(str(lock_file_path), 'w', encoding='UTF-8') as f:
                f.write(LOCK_FILE_HEADER)
                hjson.dump(lock, f)
                f.write("\n")
                log.info("Wrote lock file %s", str(lock_file_path))

        # Commit changes
        if args.commit:
            sha_short = git_get_short_rev(clone_subdir, upstream_new_rev)

            repo_info = github_parse_url(import_desc['upstream']['url'])
            if repo_info is not None:
                sha_short = "%s/%s@%s" % (repo_info[0], repo_info[1],
                                          sha_short)

            commit_msg_subject = 'Update %s to %s' % (import_desc['name'], sha_short)
            subdir_msg = ' '
            if upstream_only_subdir:
                subdir_msg = ' subdir %s in ' % upstream_only_subdir
            intro = 'Update code from%supstream repository %s to revision %s' % (
                subdir_msg, import_desc['upstream']['url'], upstream_new_rev)
            commit_msg_body = textwrap.fill(intro, width=70)

            if shortlog:
                commit_msg_body += "\n\n"
                commit_msg_body += format_list_to_str(shortlog, width=70)

            commit_msg = commit_msg_subject + "\n\n" + commit_msg_body

            commit_paths = []
            commit_paths.append(
                path_resolve(import_desc['target_dir'], vendor_file_base_dir))
            if args.refresh_patches:
                commit_paths.append(
                    path_resolve(import_desc['patch_dir'], vendor_file_base_dir))
            commit_paths.append(lock_file_path)

            git_add_commit(vendor_file_base_dir, commit_paths, commit_msg)

    finally:
        shutil.rmtree(str(clone_dir), ignore_errors=True)

    log.info('Import finished')


if __name__ == '__main__':
    try:
        main(sys.argv)
    except subprocess.CalledProcessError as e:
        log.fatal("Called program '%s' returned with %d.\n"
                  "STDOUT:\n%s\n"
                  "STDERR:\n%s\n" %
                  (" ".join(e.cmd), e.returncode, e.stdout, e.stderr))
        raise
