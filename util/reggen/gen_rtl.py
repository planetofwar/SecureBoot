# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Generate SystemVerilog designs from validated register JSON tree
"""

import logging as log

from mako import exceptions
from mako.template import Template
from pkg_resources import resource_filename

from .access import HwAccess, SwRdAccess, SwWrAccess
from .data import Block, Field, MultiReg, Reg, Window
from .register import Register
from .multi_register import MultiRegister


def escape_name(name):
    return name.lower().replace(' ', '_')


def check_field_bool(obj, field, default):
    if field in obj:
        return True if obj[field] == "true" else False
    else:
        return default


def parse_field(obj, reg, nfields):
    """Convert OrderedDict field into Field class
    """
    f = Field()
    f.name = escape_name(obj.name)
    # if name doesn't exist and only one field in a reg
    if f.name == "" and nfields == 1:
        f.name = reg.name

    # MSB, LSB
    f.lsb = obj.bits.lsb
    f.msb = obj.bits.msb

    f.swaccess = obj.swaccess.value[1]
    f.swwraccess = obj.swaccess.value[2]
    f.swrdaccess = obj.swaccess.value[3]
    f.hwaccess = obj.hwaccess.value[1]
    f.hwqe = obj.hwqe
    f.hwre = obj.hwre
    f.hwext = reg.hwext
    f.tags = obj.tags
    f.shadowed = reg.shadowed

    # resval handling. If obj.resval is None, the field is defined as unknown.
    # Treat it as zero here.
    f.resval = obj.resval or 0

    return f


def parse_reg(obj):
    """Convert Register into a Reg object."""
    assert isinstance(obj, Register)
    reg = Reg(escape_name(obj.name))
    reg.offset = obj.offset
    reg.fields = []

    reg.hwext = obj.hwext
    reg.hwqe = obj.hwqe
    reg.hwre = obj.hwre
    reg.resval = obj.resval
    reg.dvrights = obj.dv_rights()
    reg.regwen = (obj.regwen or '').lower()
    reg.ishomog = len(obj.fields) == 1
    reg.tags = obj.tags
    reg.shadowed = obj.shadowed
    # For DV only: TODO: any good way we can move it to gen_dv?
    reg.update_err_alert = obj.update_err_alert or ''
    reg.storage_err_alert = obj.storage_err_alert or ''

    # Parsing Fields
    for f in obj.fields:
        field = parse_field(f, reg, len(obj.fields))
        if field is not None:
            reg.fields.append(field)
            reg.width = max(reg.width, field.msb + 1)

    # TODO: Field bitfield overlapping check
    log.info("R[0x%04x]: %s ", reg.offset, reg.name)
    for f in reg.fields:
        log.info("  F[%2d:%2d]: %s", f.msb, f.lsb, f.name)

    return reg


def parse_multireg(obj):
    '''Convert MultiRegister into a MultiReg object'''
    assert isinstance(obj, MultiRegister)
    regs = [parse_reg(r) for r in obj.regs]
    # get register properties of the first register in the multireg and
    # copy them to the parent
    # since all regs in a multireg have the same props
    reg = MultiReg(regs[0].get_reg_flat(0))
    # since this is a multireg, the list of fields can
    # contain regs or multiregs
    reg.fields = regs
    # a homogenous multireg contains only one single field that is replicated
    reg.ishomog = len(obj.reg.fields) == 1
    # TODO: need to rework this once the underlying JSON has been changed
    reg.name = escape_name(obj.reg.name)
    # TODO: need to reference proper param here such that it can be used
    # in the package template for the array declaration
    # reg.param = ...
    return reg


def parse_win(obj, width):
    # Convert register window fields into Window class
    # base_addr : genoffset
    # limit_addr : genoffset + items*width
    win = Window()
    win.name = obj["name"]
    win.base_addr = obj["genoffset"]
    win.byte_write = obj["genbyte-write"]
    win.limit_addr = obj["genoffset"] + int(obj["items"]) * (width // 8)
    win.dvrights = obj["swaccess"]
    win.n_bits = obj["genvalidbits"]

    # TODO: Generate warnings of `unusual`
    return win


def json_to_reg(obj):
    """Converts JSON OrderedDict into structure having useful information for
    Template to use.

    Main purpose of this function is:
        - Add Offset value based on auto calculation
        - Prepare Systemverilog data structure to generate _pkg file
    """
    block = Block()

    # Name
    block.name = escape_name(obj["name"])
    log.info("Processing module: %s", block.name)

    block.width = int(obj["regwidth"], 0)

    if block.width != 32 and block.width != 64:
        log.error(
            "Current reggen tool doesn't support field width that is not 32 nor 64"
        )

    log.info("Data Width is set to %d bits", block.width)

    block.params = obj["param_list"] if "param_list" in obj else []

    block.hier_path = obj["hier_path"] if "hier_path" in obj else ""

    for r in obj["registers"]:
        if isinstance(r, Register):
            block.regs.append(parse_reg(r))
            continue
        if isinstance(r, MultiRegister):
            block.regs.append(parse_multireg(r))
            continue
        if isinstance(r, dict):
            if 'sameaddr' in r:
                log.error("Current tool doesn't support 'sameaddr' type")
                continue
            if 'window' in r:
                win = parse_win(r['window'], block.width)
                if win is not None:
                    block.wins.append(win)
                continue

    # Last offset and calculate space
    #  Later on, it could use block.regs[-1].genoffset
    if "space" in obj:
        block.addr_width = int(obj["space"], 0).bit_length()
    else:
        block.addr_width = (obj["gensize"] - 1).bit_length()

    return block


def gen_rtl(obj, outdir):
    # obj: OrderedDict

    block = json_to_reg(obj)

    # Read Register templates
    reg_top_tpl = Template(
        filename=resource_filename('reggen', 'reg_top.sv.tpl'))
    reg_pkg_tpl = Template(
        filename=resource_filename('reggen', 'reg_pkg.sv.tpl'))

    # Generate pkg.sv with block name
    with open(outdir + "/" + block.name + "_reg_pkg.sv", 'w',
              encoding='UTF-8') as fout:
        try:
            fout.write(
                reg_pkg_tpl.render(block=block,
                                   HwAccess=HwAccess,
                                   SwRdAccess=SwRdAccess,
                                   SwWrAccess=SwWrAccess))
        except:  # noqa: F722 for template Exception handling
            log.error(exceptions.text_error_template().render())

    # Generate top.sv
    with open(outdir + "/" + block.name + "_reg_top.sv", 'w',
              encoding='UTF-8') as fout:
        try:
            fout.write(
                reg_top_tpl.render(block=block,
                                   HwAccess=HwAccess,
                                   SwRdAccess=SwRdAccess,
                                   SwWrAccess=SwWrAccess))
        except:  # noqa: F722 for template Exception handling
            log.error(exceptions.text_error_template().render())
