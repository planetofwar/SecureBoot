# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""
Register JSON validation
"""

import logging as log
from collections import OrderedDict
from typing import List

from .access import SWAccess, HWAccess
from .bits import Bits
from .field import Field
from .params import LocalParam, Params
from .reg_block import RegBlock
from .register import Register


# Routine that can be used for Hjson object_pairs_hook
# The baseline is dict(pairs) i.e. construct a dictonary from pairs
# The usual is OrderedDict(pairs) which is redundant in latest python
# Both of these silently allow repeated keys, which this version detects
def checking_dict(pairs):
    d = {}
    for x in pairs:
        if x[0] in d:
            repkey = 'Repeated' + x[0]
            log.warn("Repeated key " + x[0] + " added as " + repkey)
            d[repkey] = x[1]
        else:
            d[x[0]] = x[1]
    return d


# validating version of int(x, 0)
# returns int value, error flag
# if error flag is True value will be zero
def check_int(x, err_prefix, suppress_err_msg=False):
    if isinstance(x, int):
        return x, False
    if x[0] == '0' and len(x) > 2:
        if x[1] in 'bB':
            validch = '01'
        elif x[1] in 'oO':
            validch = '01234567'
        elif x[1] in 'xX':
            validch = '0123456789abcdefABCDEF'
        else:
            if not suppress_err_msg:
                log.error(err_prefix +
                          ": int must start digit, 0b, 0B, 0o, 0O, 0x or 0X")
            return 0, True
        for c in x[2:]:
            if c not in validch:
                if not suppress_err_msg:
                    log.error(err_prefix + ": Bad character " + c + " in " + x)
                return 0, True
    else:
        if not x.isdecimal():
            if not suppress_err_msg:
                log.error(err_prefix + ": Number not valid int " + x)
            return 0, True
    return int(x, 0), False


def check_bool(x, err_prefix):
    """check_bool checks if input 'x' is one of the list:
        "true", "false"

        It returns value as Bool type and Error condition.
    """
    if isinstance(x, bool):
        # if Bool returns as it is
        return x, False
    if not x.lower() in ["true", "false"]:
        log.error(err_prefix + ": Bad field value " + x)
        return False, True
    else:
        return (x.lower() == "true"), False


def check_ln(obj, x, withwidth, err_prefix):
    error = 0
    if not isinstance(obj[x], list):
        log.error(err_prefix + ' element ' + x + ' not a list')
        return 1
    for y in obj[x]:
        error += check_keys(y, ln_required, ln_optional if withwidth else {},
                            {}, err_prefix + ' element ' + x)
        if withwidth:
            if 'width' in y:
                w, err = check_int(y['width'], err_prefix + ' width in ' + x)
                if err:
                    error += 1
                    w = 1
            else:
                w = 1
            y['width'] = str(w)

    return error


def check_keys(obj, required_keys, optional_keys, added_keys, err_prefix):
    error = 0
    for x in required_keys:
        if x not in obj:
            error += 1
            log.error(err_prefix + " missing required key " + x)
    for x in obj:
        type = None
        if x in required_keys:
            type = required_keys[x][0]
        elif x in optional_keys:
            type = optional_keys[x][0]
        elif x not in added_keys:
            log.warning(err_prefix + " contains extra key " + x)
        if type is not None:
            if type[:2] == 'ln':
                error += check_ln(obj, x, type == 'lnw', err_prefix)

    return error


val_types = {
    'd': ["int", "integer (binary 0b, octal 0o, decimal, hex 0x)"],
    'x': ["xint", "x for undefined otherwise int"],
    'b': [
        "bitrange", "bit number as decimal integer, "
        "or bit-range as decimal integers msb:lsb"
    ],
    'l': ["list", "comma separated list enclosed in `[]`"],
    'ln': [
        "name list", 'comma separated list enclosed in `[]` of '
        'one or more groups that have just name and dscr keys.'
        ' e.g. `{ name: "name", desc: "description"}`'
    ],
    'lnw': ["name list+", 'name list that optionally contains a width'],
    'lp': ["parameter list", 'parameter list having default value optionally'],
    'g': ["group", "comma separated group of key:value enclosed in `{}`"],
    'lg': [
        "list of group", "comma separated group of key:value enclosed in `{}`"
        " the second entry of the list is the sub group format"
    ],
    's': ["string", "string, typically short"],
    't': [
        "text", "string, may be multi-line enclosed in `'''` "
        "may use `**bold**`, `*italic*` or `!!Reg` markup"
    ],
    'T': ["tuple", "tuple enclosed in ()"],
    'pi': ["python int", "Native Python type int (generated)"],
    'pb': ["python Bool", "Native Python type Bool (generated)"],
    'pl': ["python list", "Native Python type list (generated)"],
    'pe': ["python enum", "Native Python type enum (generated)"]
}

# Toplevel keys
top_required = {
    'name': ['s', "name of the component"],
    'clock_primary': ['s', "name of the primary clock"],
    'bus_device': ['s', "name of the bus interface for the device"],
    'registers':
    ['l', "list of register definition groups and "
     "offset control groups"]
}
top_optional = {
    'alert_list': ['lnw', "list of peripheral alerts"],
    'available_inout_list': ['lnw', "list of available peripheral inouts"],
    'available_input_list': ['lnw', "list of available peripheral inputs"],
    'available_output_list': ['lnw', "list of available peripheral outputs"],
    'bus_host': ['s', "name of the bus interface as host"],
    'hier_path': [
        None,
        'additional hierarchy path before the reg block instance'
    ],
    'interrupt_list': ['lnw', "list of peripheral interrupts"],
    'inter_signal_list': ['l', "list of inter-module signals"],
    'no_auto_alert_regs': [
        's', "Set to true to suppress automatic "
        "generation of alert test registers. "
        "Defaults to true if no alert_list is present. "
        "Otherwise this defaults to false. "
    ],
    'no_auto_intr_regs': [
        's', "Set to true to suppress automatic "
        "generation of interrupt registers. "
        "Defaults to true if no interrupt_list is present. "
        "Otherwise this defaults to false. "
    ],
    'other_clock_list': ['l', "list of other chip clocks needed"],
    'other_reset_list': ['l', "list of other resets"],
    'param_list': ['lp', "list of parameters of the IP"],
    'regwidth': ['d', "width of registers in bits (default 32)"],
    'reset_primary': ['s', "primary reset used by the module"],
    'reset_request_list': ['l', 'list of signals requesting reset'],
    'scan': ['pb', 'Indicates the module have `scanmode_i`'],
    'scan_reset': ['pb', 'Indicates the module have `test_rst_ni`'],
    'SPDX-License-Identifier': [
        's', "License ientifier (if using pure json) "
        "Only use this if unable to put this "
        "information in a comment at the top of the "
        "file."
    ],
    'wakeup_list': ['lnw', "list of peripheral wakeups"]
}
top_added = {
    'genrnames': ['pl', "list of register names"],
    'genautoregs': ['pb', "Registers were generated from config info"],
    'gensize': [
        'pi', "address space size needed for registers. "
        "Generated by tool as next power of 2."
    ]
}

# ln type has list of groups with only name and description
# (was called "subunit" in cfg_validate)
ln_required = {
    'name': ['s', "name of the item"],
    'desc': ['s', "description of the item"],
}
ln_optional = {
    'width': ['d', "bit width of the item (if not 1)"],
}

# Registers list may have embedded keys
list_optone = {
    'reserved': ['d', "number of registers to reserve space for"],
    'skipto': ['d', "set next register offset to value"],
    'window': [
        'g', "group defining an address range "
        "for something other than standard registers"
    ],
    'multireg':
    ['g', "group defining registers generated "
     "from a base instance."]
}

key_use = {'r': "required", 'o': "optional", 'a': "added by tool"}


def make_intr_alert_reg(reg_block, regs, name, swaccess, hwaccess, desc):
    if name == 'ALERT_TEST':
        signal_list = regs['alert_list']
    else:
        signal_list = regs['interrupt_list']
    # these names will be converted into test registers
    testreg_names = ['INTR_TEST', 'ALERT_TEST']

    swaccess_obj = SWAccess('make_intr_alert_reg()', swaccess)
    hwaccess_obj = HWAccess('make_intr_alert_reg()', hwaccess)

    fields = []
    cur_bit = 0
    for (field_idx, bit) in enumerate(signal_list):
        w = 1
        if 'width' in bit and bit['width'] != '1':
            w = int(bit['width'], 0)
            field_bits = Bits(cur_bit + w - 1, cur_bit)
        else:
            field_bits = Bits(cur_bit, cur_bit)
        cur_bit += w

        field_name = bit['name']
        if name == 'INTR_ENABLE':
            field_desc = ('Enable interrupt when {}!!INTR_STATE.{} is set.'
                          .format('corresponding bit in ' if w > 1 else '',
                                  field_name))
        elif name == 'INTR_TEST':
            field_desc = ('Write 1 to force {}!!INTR_STATE.{} to 1.'
                          .format('corresponding bit in ' if w > 1 else '',
                                  field_name))
        elif name == 'ALERT_TEST':
            field_desc = 'Write 1 to trigger one alert event of this kind.'
        else:
            field_desc = bit['desc']

        # Put the automatically generated information back into
        # `interrupt_list`, so that it can be used to generate C preprocessor
        # definitions if needed.
        signal_list[field_idx]['bits'] = field_bits.as_str()
        signal_list[field_idx]['bitinfo'] = (field_bits.bitmask(),
                                             field_bits.width(),
                                             field_bits.lsb)

        fields.append(Field(field_name,
                            field_desc,
                            bit.get('tags', []),
                            swaccess_obj,
                            hwaccess_obj,
                            hwqe=name in testreg_names,
                            hwre=False,
                            bits=field_bits,
                            resval=0,
                            enum=None))

    hwext = 'true' if name in testreg_names else 'false'
    if name == 'INTR_TEST':
        # intr_test csr is WO which - it reads back 0s
        reg_tags = ["excl:CsrNonInitTests:CsrExclWrite"]
    elif name == 'INTR_STATE':
        # intr_state csr is affected by writes to other csrs - skip write-check
        reg_tags = ["excl:CsrNonInitTests:CsrExclWriteCheck"]
    else:
        reg_tags = []

    bool_hwext = hwext.lower() == 'true'

    reg = Register(reg_block.offset,
                   name,
                   desc,
                   swaccess_obj,
                   hwaccess_obj,
                   hwext=bool_hwext,
                   hwqe=bool_hwext,
                   hwre=False,
                   regwen=None,
                   tags=reg_tags,
                   resval=None,
                   shadowed=False,
                   fields=fields,
                   update_err_alert=None,
                   storage_err_alert=None)
    reg_block.add_register(reg)
    return reg


def make_intr_regs(reg_block, regs, fullwidth):
    iregs = []
    intrs = regs['interrupt_list']
    num_intrs = sum([int(x.get('width', '1'), 0) for x in intrs])
    if num_intrs > fullwidth:
        log.error('More than ' + str(fullwidth) + ' interrupts in list')
        return iregs, 1

    try:
        new_reg = make_intr_alert_reg(reg_block, regs, 'INTR_STATE', 'rw1c',
                                      'hrw', 'Interrupt State Register')
        iregs.append(new_reg)
        new_reg = make_intr_alert_reg(reg_block, regs, 'INTR_ENABLE', 'rw',
                                      'hro', 'Interrupt Enable Register')
        iregs.append(new_reg)
        new_reg = make_intr_alert_reg(reg_block, regs, 'INTR_TEST',
                                      'wo', 'hro', 'Interrupt Test Register')
        iregs.append(new_reg)
    except ValueError as err:
        log.error(str(err))
        return iregs, 1

    return iregs, 0


def make_alert_regs(reg_block, regs, fullwidth):
    alert_regs = []
    alerts = regs['alert_list']
    num_alerts = sum([int(x.get('width', '1'), 0) for x in alerts])
    if num_alerts > fullwidth:
        log.error('More than ' + str(fullwidth) + ' alerts in list')
        return alert_regs, 1

    try:
        new_reg = make_intr_alert_reg(reg_block, regs, 'ALERT_TEST',
                                      'wo', 'hro', 'Alert Test Register')
        alert_regs.append(new_reg)
    except ValueError as err:
        log.error(str(err))
        return alert_regs, 1

    return alert_regs, 0


def validate(regs, params: List[str]):
    if 'name' not in regs:
        log.error("Component has no name. Aborting.")
        return 1

    component = regs['name']

    error = check_keys(regs, top_required, top_optional, top_added, component)
    if (error > 0):
        log.error("Component has top level errors. Aborting.")
        return error
    regs['genrnames'] = []
    error = 0

    if 'regwidth' in regs:
        fullwidth, ierr = check_int(regs['regwidth'], "regwidth")
        if ierr:
            fullwidth = 32
            error += 1
    else:
        fullwidth = 32
        log.warning('regwidth not specified, assuming 32.')
    regs['regwidth'] = str(fullwidth)

    if ((fullwidth % 8) != 0):
        addrsep = (fullwidth // 8) + 1
        log.warning("regwidth is not a multiple of 8 bits!")
    else:
        addrsep = fullwidth // 8

    param_list = Params.from_raw('block parameter list',
                                 regs.get('param_list', []))
    regs['param_list'] = param_list

    reg_block = RegBlock(addrsep, fullwidth, param_list)

    autoregs = []

    # auto header generation would go here and update autoregs

    if 'no_auto_intr_regs' in regs:
        no_auto_intr, err = check_bool(regs['no_auto_intr_regs'],
                                       'no_auto_intr_regs')
        if err:
            error += 1
    else:
        if 'interrupt_list' not in regs:
            no_auto_intr = True
        else:
            no_auto_intr = False

    if 'no_auto_alert_regs' in regs:
        no_auto_alerts, err = check_bool(regs['no_auto_alert_regs'],
                                         'no_auto_alert_regs')
        if err:
            error += 1
    else:
        if 'alert_list' not in regs:
            no_auto_alerts = True
        else:
            no_auto_alerts = False

    if 'interrupt_list' in regs and 'genautoregs' not in regs and not no_auto_intr:
        iregs, err = make_intr_regs(reg_block, regs, fullwidth)
        error += err
        autoregs.extend(iregs)

    # Generate a NumAlerts parameter for provided alert_list.
    if regs.setdefault('alert_list', []):
        # Generate alert test registers.
        if 'genautoregs' not in regs and not no_auto_alerts:
            aregs, err = make_alert_regs(reg_block, regs, fullwidth)
            error += err
            autoregs.extend(aregs)

        num_alerts = 0
        for alert in regs['alert_list']:
            alert_width = int(alert.get('width', '1'), 0)
            num_alerts += alert_width
            if alert_width > 1:
                log.warning(
                    "{}: Consider naming each alert individually instead of "
                    "declaring an alert signal with width > 1.".format(
                        alert['name']))

            # check alert naming scheme
            if alert['name'] == "":
                log.error("{}: Alert name cannot be empty".format(alert['name']))
                error += 1
            prefix = alert['name'].split('_')
            if prefix[0] not in ['recov', 'fatal']:
                log.error(
                    "{}: Alerts must be prefixed with either 'recov_' or "
                    "'fatal_'.".format(alert['name']))
                error += 1

        if num_alerts != 0:
            existing_param = param_list.get('NumAlerts')
            if existing_param is not None:
                if ((not isinstance(existing_param, LocalParam) or
                     existing_param.param_type != 'int' or
                     existing_param.value != str(num_alerts))):
                    log.error('Conflicting definition of NumAlerts parameter.')
                    error += 1
            else:
                param_list.add(LocalParam(name='NumAlerts',
                                          desc='Number of alerts',
                                          param_type='int',
                                          value=str(num_alerts)))

    try:
        param_list.apply_defaults(params)
    except (ValueError, KeyError) as err:
        log.error(str(err))
        return error + 1

    if "scan" in regs:
        scan, err = check_bool(regs["scan"], component + " scan")
    else:
        regs["scan"] = "false"

    reg_block.add_raw_registers(regs['registers'])

    regs['gensize'] = 1 << (reg_block.offset - 1).bit_length()

    try:
        reg_block.validate()
    except ValueError as err:
        log.error(str(err))
        error += 1

    if autoregs:
        regs['genautoregs'] = True

    regs['registers'] = reg_block
    regs['genrnames'] = list(reg_block.name_to_offset.keys())

    log.debug("Validated, size = " + hex(regs['gensize']) + " errors=" +
              str(error) + " names are " + str(regs['genrnames']))
    if (error > 0):
        log.error("Register description had " + str(error) + " error" +
                  "s" if error > 1 else "")

    regs.setdefault('inter_signal_list', [])
    regs.setdefault('bus_device', '')
    regs.setdefault('bus_host', '')

    if regs["bus_device"] == "tlul":
        # Add to inter_module_signal
        port_name = "tl" if regs["bus_host"] in ["none", ""] else "tl_d"

        regs["inter_signal_list"].append(
            OrderedDict([('struct', 'tl'), ('package', 'tlul_pkg'),
                         ('type', 'req_rsp'), ('act', 'rsp'),
                         ('name', port_name)]))

    if regs['bus_host'] == "tlul":
        port_name = "tl" if regs["bus_host"] in ["none", ""] else "tl_h"

        regs["inter_signal_list"].append(
            OrderedDict([('struct', 'tl'), ('package', 'tlul_pkg'),
                         ('type', 'req_rsp'), ('act', 'req'),
                         ('name', port_name)]))
    return error
