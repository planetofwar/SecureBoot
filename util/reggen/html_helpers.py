# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import logging as log
import re


def expand_paras(s, rnames):
    '''Expand a description field to HTML.

    This supports a sort of simple pseudo-markdown. Supported Markdown
    features:

    - Separate paragraphs on a blank line
    - **bold** and *italicised* text

    We also generate links to registers when a name is prefixed with a double
    exclamation mark. For example, if there is a register FOO then !!FOO or
    !!FOO.field will generate a link to that register.

    Returns a list of rendered paragraphs

    '''
    # Start by splitting into paragraphs. The regex matches a newline followed
    # by one or more lines that just contain whitespace. Then render each
    # paragraph with the _expand_paragraph worker function.
    paras = [_expand_paragraph(paragraph.strip(), rnames)
             for paragraph in re.split(r'\n(?:\s*\n)+', s)]

    # There will always be at least one paragraph (splitting an empty string
    # gives [''])
    assert paras
    return paras


def _expand_paragraph(s, rnames):
    '''Expand a single paragraph, as described in _get_desc_paras'''
    def fieldsub(match):
        base = match.group(1).partition('.')[0].lower()
        if base in rnames:
            if match.group(1)[-1] == ".":
                return ('<a href="#Reg_' + base + '"><code class=\"reg\">' +
                        match.group(1)[:-1] + '</code></a>.')
            else:
                return ('<a href="#Reg_' + base + '"><code class=\"reg\">' +
                        match.group(1) + '</code></a>')
        log.warn('!!' + match.group(1).partition('.')[0] +
                 ' not found in register list.')
        return match.group(0)

    s = re.sub(r"!!([A-Za-z0-9_.]+)", fieldsub, s)
    s = re.sub(r"(?s)\*\*(.+?)\*\*", r'<B>\1</B>', s)
    s = re.sub(r"\*([^*]+?)\*", r'<I>\1</I>', s)
    return s


def render_td(s, rnames, td_class):
    '''Expand a description field and put it in a <td>.

    Returns a string. See _get_desc_paras for the format that gets expanded.

    '''
    desc_paras = expand_paras(s, rnames)
    class_attr = '' if td_class is None else ' class="{}"'.format(td_class)
    return ('<td{}><p>{}</p></td>'
            .format(class_attr, '</p><p>'.join(desc_paras)))
