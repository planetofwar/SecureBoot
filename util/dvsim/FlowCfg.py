# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import datetime
import logging as log
import os
import pprint
from shutil import which
import subprocess
import sys

import hjson

from CfgJson import set_target_attribute
import Scheduler
from utils import (VERBOSE, md_results_to_html,
                   subst_wildcards, find_and_substitute_wildcards)


# Interface class for extensions.
class FlowCfg():
    '''Base class for the different flows supported by dvsim.py

    The constructor expects some parsed hjson data. Create these objects with
    the factory function in CfgFactory.py, which loads the hjson data and picks
    a subclass of FlowCfg based on its contents.

    '''

    # Set in subclasses. This is the key that must be used in an hjson file to
    # tell dvsim.py which subclass to use.
    flow = None

    # Can be overridden in subclasses to configure which wildcards to ignore
    # when expanding hjson.
    ignored_wildcards = []

    def __str__(self):
        return pprint.pformat(self.__dict__)

    def __init__(self, flow_cfg_file, hjson_data, args, mk_config):
        # Options set from command line
        self.items = args.items
        self.list_items = args.list
        self.select_cfgs = args.select_cfgs
        self.flow_cfg_file = flow_cfg_file
        self.args = args
        self.scratch_root = args.scratch_root
        self.branch = args.branch
        self.job_prefix = args.job_prefix

        # Options set from hjson cfg.
        self.project = ""
        self.scratch_path = ""

        # Add exports using 'exports' keyword - these are exported to the child
        # process' environment.
        self.exports = []

        # Add overrides using the overrides keyword - existing attributes
        # are overridden with the override values.
        self.overrides = []

        # List of cfgs if the parsed cfg is a primary cfg list
        self.cfgs = []

        # Add a notion of "primary" cfg - this is indicated using
        # a special key 'use_cfgs' within the hjson cfg.
        self.is_primary_cfg = False

        # For a primary cfg, it is the aggregated list of all deploy objects under self.cfgs.
        # For a non-primary cfg, it is the list of items slated for dispatch.
        self.deploy = []

        # Timestamp
        self.ts_format_long = args.ts_format_long
        self.timestamp_long = args.timestamp_long
        self.ts_format = args.ts_format
        self.timestamp = args.timestamp

        # Results
        self.errors_seen = False
        self.rel_path = ""
        self.results_title = ""
        self.revision = ""
        self.results_server_prefix = ""
        self.results_server_url_prefix = ""
        self.results_server_cmd = ""
        self.css_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), "style.css")
        self.results_server_path = ""
        self.results_server_dir = ""
        self.results_server_html = ""
        self.results_server_page = ""
        self.results_summary_server_html = ""
        self.results_summary_server_page = ""

        # Full results in md text
        self.results_md = ""
        # Selectively sanitized md results to be mailed out or published
        self.email_results_md = ""
        self.publish_results_md = ""
        self.sanitize_email_results = False
        self.sanitize_publish_results = False
        # Summary results, generated by over-arching cfg
        self.email_summary_md = ""
        self.results_summary_md = ""

        # Merge in the values from the loaded hjson file. If subclasses want to
        # add other default parameters that depend on the parameters above,
        # they can override _merge_hjson and add their parameters at the start
        # of that.
        self._merge_hjson(hjson_data)

        # Is this a primary config? If so, we need to load up all the child
        # configurations at this point. If not, we place ourselves into
        # self.cfgs and consider ourselves a sort of "degenerate primary
        # configuration".
        self.is_primary_cfg = 'use_cfgs' in hjson_data

        if not self.is_primary_cfg:
            self.cfgs.append(self)
        else:
            for entry in self.use_cfgs:
                self._load_child_cfg(entry, mk_config)

        if self.rel_path == "":
            self.rel_path = os.path.dirname(self.flow_cfg_file).replace(
                self.proj_root + '/', '')

        # Process overrides before substituting wildcards
        self._process_overrides()

        # Expand wildcards. If subclasses need to mess around with parameters
        # after merging the hjson but before expansion, they can override
        # _expand and add the code at the start.
        self._expand()

        # Run any final checks
        self._post_init()

    def _merge_hjson(self, hjson_data):
        '''Take hjson data and merge it into self.__dict__

        Subclasses that need to do something just before the merge should
        override this method and call super()._merge_hjson(..) at the end.

        '''
        for key, value in hjson_data.items():
            set_target_attribute(self.flow_cfg_file,
                                 self.__dict__,
                                 key,
                                 value)

    def _expand(self):
        '''Called to expand wildcards after merging hjson

        Subclasses can override this to do something just before expansion.

        '''
        # If this is a primary configuration, it doesn't matter if we don't
        # manage to expand everything.
        partial = self.is_primary_cfg

        self.__dict__ = find_and_substitute_wildcards(self.__dict__,
                                                      self.__dict__,
                                                      self.ignored_wildcards,
                                                      ignore_error=partial)

    def _post_init(self):
        # Run some post init checks
        if not self.is_primary_cfg:
            # Check if self.cfgs is a list of exactly 1 item (self)
            if not (len(self.cfgs) == 1 and self.cfgs[0].name == self.name):
                log.error("Parse error!\n%s", self.cfgs)
                sys.exit(1)

    def create_instance(self, mk_config, flow_cfg_file):
        '''Create a new instance of this class for the given config file.

        mk_config is a factory method (passed explicitly to avoid a circular
        dependency between this file and CfgFactory.py).

        '''
        new_instance = mk_config(flow_cfg_file)

        # Sanity check to make sure the new object is the same class as us: we
        # don't yet support heterogeneous primary configurations.
        if type(self) is not type(new_instance):
            log.error("{}: Loading child configuration at {!r}, but the "
                      "resulting flow types don't match: ({} vs. {})."
                      .format(self.flow_cfg_file,
                              flow_cfg_file,
                              type(self).__name__,
                              type(new_instance).__name__))
            sys.exit(1)

        return new_instance

    def kill(self):
        '''kill running processes and jobs gracefully
        '''
        for item in self.deploy:
            item.kill()

    def _load_child_cfg(self, entry, mk_config):
        '''Load a child configuration for a primary cfg'''
        if type(entry) is str:
            # Treat this as a file entry. Substitute wildcards in cfg_file
            # files since we need to process them right away.
            cfg_file = subst_wildcards(entry,
                                       self.__dict__,
                                       ignore_error=True)
            self.cfgs.append(self.create_instance(mk_config, cfg_file))

        elif type(entry) is dict:
            # Treat this as a cfg expanded in-line
            temp_cfg_file = self._conv_inline_cfg_to_hjson(entry)
            if not temp_cfg_file:
                return
            self.cfgs.append(self.create_instance(mk_config, temp_cfg_file))

            # Delete the temp_cfg_file once the instance is created
            try:
                log.log(VERBOSE, "Deleting temp cfg file:\n%s",
                        temp_cfg_file)
                os.system("/bin/rm -rf " + temp_cfg_file)
            except IOError:
                log.error("Failed to remove temp cfg file:\n%s",
                          temp_cfg_file)

        else:
            log.error(
                "Type of entry \"%s\" in the \"use_cfgs\" key is invalid: %s",
                entry, str(type(entry)))
            sys.exit(1)

    def _conv_inline_cfg_to_hjson(self, idict):
        '''Dump a temp hjson file in the scratch space from input dict.
        This method is to be called only by a primary cfg'''

        if not self.is_primary_cfg:
            log.fatal("This method can only be called by a primary cfg")
            sys.exit(1)

        name = idict["name"] if "name" in idict.keys() else None
        if not name:
            log.error("In-line entry in use_cfgs list does not contain "
                      "a \"name\" key (will be skipped!):\n%s",
                      idict)
            return None

        # Check if temp cfg file already exists
        temp_cfg_file = (self.scratch_root + "/." + self.branch + "__" +
                         name + "_cfg.hjson")

        # Create the file and dump the dict as hjson
        log.log(VERBOSE, "Dumping inline cfg \"%s\" in hjson to:\n%s", name,
                temp_cfg_file)
        try:
            with open(temp_cfg_file, "w") as f:
                f.write(hjson.dumps(idict, for_json=True))
        except Exception as e:
            log.error("Failed to hjson-dump temp cfg file\"%s\" for \"%s\""
                      "(will be skipped!) due to:\n%s",
                      temp_cfg_file, name, e)
            return None

        # Return the temp cfg file created
        return temp_cfg_file

    def _process_overrides(self):
        # Look through the dict and find available overrides.
        # If override is available, check if the type of the value for existing
        # and the overridden keys are the same.
        overrides_dict = {}
        if hasattr(self, "overrides"):
            overrides = getattr(self, "overrides")
            if type(overrides) is not list:
                log.error(
                    "The type of key \"overrides\" is %s - it should be a list",
                    type(overrides))
                sys.exit(1)

            # Process override one by one
            for item in overrides:
                if type(item) is dict and set(item.keys()) == {"name", "value"}:
                    ov_name = item["name"]
                    ov_value = item["value"]
                    if ov_name not in overrides_dict.keys():
                        overrides_dict[ov_name] = ov_value
                        self._do_override(ov_name, ov_value)
                    else:
                        log.error(
                            "Override for key \"%s\" already exists!\nOld: %s\nNew: %s",
                            ov_name, overrides_dict[ov_name], ov_value)
                        sys.exit(1)
                else:
                    log.error("\"overrides\" is a list of dicts with {\"name\": <name>, "
                              "\"value\": <value>} pairs. Found this instead:\n%s",
                              str(item))
                    sys.exit(1)

    def _do_override(self, ov_name, ov_value):
        # Go through self attributes and replace with overrides
        if hasattr(self, ov_name):
            orig_value = getattr(self, ov_name)
            if type(orig_value) == type(ov_value):
                log.debug("Overriding \"%s\" value \"%s\" with \"%s\"",
                          ov_name, orig_value, ov_value)
                setattr(self, ov_name, ov_value)
            else:
                log.error("The type of override value \"%s\" for \"%s\" mismatches "
                          "the type of original value \"%s\"",
                          ov_value, ov_name, orig_value)
                sys.exit(1)
        else:
            log.error("Override key \"%s\" not found in the cfg!", ov_name)
            sys.exit(1)

    def _purge(self):
        '''Purge the existing scratch areas in preperation for the new run.'''
        return

    def purge(self):
        '''Public facing API for _purge().
        '''
        for item in self.cfgs:
            item._purge()

    def _print_list(self):
        '''Print the list of available items that can be kicked off.
        '''
        return

    def print_list(self):
        '''Public facing API for _print_list().
        '''
        for item in self.cfgs:
            item._print_list()

    def prune_selected_cfgs(self):
        '''Prune the list of configs for a primary config file'''

        # This should run after self.cfgs has been set
        assert self.cfgs

        # If the user didn't pass --select-cfgs, we don't do anything.
        if self.select_cfgs is None:
            return

        # If the user passed --select-cfgs, but this isn't a primary config
        # file, we should probably complain.
        if not self.is_primary_cfg:
            log.error('The configuration file at {!r} is not a primary config, '
                      'but --select-cfgs was passed on the command line.'
                      .format(self.flow_cfg_file))
            sys.exit(1)

        # Filter configurations
        self.cfgs = [c for c in self.cfgs if c.name in self.select_cfgs]

    def _create_deploy_objects(self):
        '''Create deploy objects from items that were passed on for being run.
        The deploy objects for build and run are created from the objects that were
        created from the create_objects() method.
        '''
        return

    def create_deploy_objects(self):
        '''Public facing API for _create_deploy_objects().
        '''
        self.prune_selected_cfgs()
        if self.is_primary_cfg:
            self.deploy = []
            for item in self.cfgs:
                item._create_deploy_objects()
                self.deploy.extend(item.deploy)
        else:
            self._create_deploy_objects()

    def deploy_objects(self):
        '''Public facing API for deploying all available objects.

        Runs each job and returns a map from item to status.

        '''
        return Scheduler.run(self.deploy)

    def _gen_results(self, results):
        '''
        The function is called after the regression has completed. It collates the
        status of all run targets and generates a dict. It parses the testplan and
        maps the generated result to the testplan entries to generate a final table
        (list). It also prints the full list of failures for debug / triage. The
        final result is in markdown format.

        results should be a dictionary mapping deployed item to result.

        '''
        return

    def gen_results(self, results):
        '''Public facing API for _gen_results().

        results should be a dictionary mapping deployed item to result.

        '''
        for item in self.cfgs:
            result = item._gen_results(results)
            log.info("[results]: [%s]:\n%s\n", item.name, result)
            log.info("[scratch_path]: [%s] [%s]", item.name, item.scratch_path)
            self.errors_seen |= item.errors_seen

        if self.is_primary_cfg:
            self.gen_results_summary()
        self.gen_email_html_summary()

    def gen_results_summary(self):
        '''Public facing API to generate summary results for each IP/cfg file
        '''
        return

    def _get_results_page_link(self, link_text):
        if not self.args.publish:
            return link_text
        results_page_url = self.results_server_page.replace(
            self.results_server_prefix, self.results_server_url_prefix)
        return "[%s](%s)" % (link_text, results_page_url)

    def gen_email_html_summary(self):
        if self.is_primary_cfg:
            # user can customize email content by using email_summary_md,
            # otherwise default to send out results_summary_md
            gen_results = self.email_summary_md or self.results_summary_md
        else:
            gen_results = self.email_results_md or self.results_md
        results_html = md_results_to_html(self.results_title, self.css_file, gen_results)
        results_html_file = self.scratch_root + "/email.html"
        f = open(results_html_file, 'w')
        f.write(results_html)
        f.close()
        log.info("[results:email]: [%s]", results_html_file)

    def _publish_results(self):
        '''Publish results to the opentitan web server.
        Results are uploaded to {results_server_path}/latest/results.
        If the 'latest' directory exists, then it is renamed to its 'timestamp' directory.
        If the list of directories in this area is > 14, then the oldest entry is removed.
        Links to the last 7 regression results are appended at the end if the results page.
        '''
        if which('gsutil') is None or which('gcloud') is None:
            log.error(
                "Google cloud SDK not installed! Cannot access the results server"
            )
            return

        # Construct the paths
        results_page_url = self.results_server_page.replace(
            self.results_server_prefix, self.results_server_url_prefix)

        # Timeformat for moving the dir
        tf = "%Y.%m.%d_%H.%M.%S"

        # Extract the timestamp of the existing self.results_server_page
        cmd = self.results_server_cmd + " ls -L " + self.results_server_page + \
            " | grep \'Creation time:\'"

        log.log(VERBOSE, cmd)
        cmd_output = subprocess.run(cmd,
                                    shell=True,
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.DEVNULL)
        log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        old_results_ts = cmd_output.stdout.decode("utf-8")
        old_results_ts = old_results_ts.replace("Creation time:", "")
        old_results_ts = old_results_ts.strip()

        # Move the 'latest' to its timestamp directory if lookup succeeded
        if cmd_output.returncode == 0:
            try:
                if old_results_ts != "":
                    ts = datetime.datetime.strptime(
                        old_results_ts, "%a, %d %b %Y %H:%M:%S %Z")
                    old_results_ts = ts.strftime(tf)
            except ValueError as e:
                log.error(
                    "%s: \'%s\' Timestamp conversion value error raised!", e)
                old_results_ts = ""

            # If the timestamp conversion failed - then create a dummy one with
            # yesterday's date.
            if old_results_ts == "":
                log.log(VERBOSE,
                        "Creating dummy timestamp with yesterday's date")
                ts = datetime.datetime.now(
                    datetime.timezone.utc) - datetime.timedelta(days=1)
                old_results_ts = ts.strftime(tf)

            old_results_dir = self.results_server_path + "/" + old_results_ts
            cmd = (self.results_server_cmd + " mv " + self.results_server_dir +
                   " " + old_results_dir)
            log.log(VERBOSE, cmd)
            cmd_output = subprocess.run(cmd,
                                        shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.DEVNULL)
            log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
            if cmd_output.returncode != 0:
                log.error("Failed to mv old results page \"%s\" to \"%s\"!",
                          self.results_server_dir, old_results_dir)

        # Do an ls in the results root dir to check what directories exist.
        results_dirs = []
        cmd = self.results_server_cmd + " ls " + self.results_server_path
        log.log(VERBOSE, cmd)
        cmd_output = subprocess.run(args=cmd,
                                    shell=True,
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.DEVNULL)
        log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        if cmd_output.returncode == 0:
            # Some directories exist. Check if 'latest' is one of them
            results_dirs = cmd_output.stdout.decode("utf-8").strip()
            results_dirs = results_dirs.split("\n")
        else:
            log.log(VERBOSE, "Failed to run \"%s\"!", cmd)

        # Start pruning
        log.log(VERBOSE, "Pruning %s area to limit last 7 results",
                self.results_server_path)

        rdirs = []
        for rdir in results_dirs:
            dirname = rdir.replace(self.results_server_path, '')
            dirname = dirname.replace('/', '')
            if dirname == "latest":
                continue
            rdirs.append(dirname)
        rdirs.sort(reverse=True)

        rm_cmd = ""
        history_txt = "\n## Past Results\n"
        history_txt += "- [Latest](" + results_page_url + ")\n"
        if len(rdirs) > 0:
            for i in range(len(rdirs)):
                if i < 7:
                    rdir_url = self.results_server_path + '/' + rdirs[
                        i] + "/" + self.results_server_html
                    rdir_url = rdir_url.replace(self.results_server_prefix,
                                                self.results_server_url_prefix)
                    history_txt += "- [{}]({})\n".format(rdirs[i], rdir_url)
                elif i > 14:
                    rm_cmd += self.results_server_path + '/' + rdirs[i] + " "

        if rm_cmd != "":
            rm_cmd = self.results_server_cmd + " -m rm -r " + rm_cmd + "; "

        # Append the history to the results.
        publish_results_md = self.publish_results_md or self.results_md
        publish_results_md = publish_results_md + history_txt

        # Publish the results page.
        # First, write the results html file temporarily to the scratch area.
        results_html_file = self.scratch_path + "/results_" + self.timestamp + ".html"
        f = open(results_html_file, 'w')
        f.write(
            md_results_to_html(self.results_title, self.css_file, publish_results_md))
        f.close()
        rm_cmd += "/bin/rm -rf " + results_html_file + "; "

        log.info("Publishing results to %s", results_page_url)
        cmd = (self.results_server_cmd + " cp " + results_html_file + " " +
               self.results_server_page + "; " + rm_cmd)
        log.log(VERBOSE, cmd)
        try:
            cmd_output = subprocess.run(args=cmd,
                                        shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT)
            log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        except Exception as e:
            log.error("%s: Failed to publish results:\n\"%s\"", e, str(cmd))

    def publish_results(self):
        '''Public facing API for publishing results to the opentitan web server.
        '''
        for item in self.cfgs:
            item._publish_results()

        if self.is_primary_cfg:
            self.publish_results_summary()

    def publish_results_summary(self):
        '''Public facing API for publishing md format results to the opentitan web server.
        '''
        results_html_file = "summary_" + self.timestamp + ".html"
        results_page_url = self.results_summary_server_page.replace(
            self.results_server_prefix, self.results_server_url_prefix)

        # Publish the results page.
        # First, write the results html file temporarily to the scratch area.
        f = open(results_html_file, 'w')
        f.write(
            md_results_to_html(self.results_title, self.css_file, self.results_summary_md))
        f.close()
        rm_cmd = "/bin/rm -rf " + results_html_file + "; "

        log.info("Publishing results summary to %s", results_page_url)
        cmd = (self.results_server_cmd + " cp " + results_html_file + " " +
               self.results_summary_server_page + "; " + rm_cmd)
        log.log(VERBOSE, cmd)
        try:
            cmd_output = subprocess.run(args=cmd,
                                        shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT)
            log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        except Exception as e:
            log.error("%s: Failed to publish results:\n\"%s\"", e, str(cmd))

    def has_errors(self):
        return self.errors_seen
