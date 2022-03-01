# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Callable, Dict, List, Sequence

from reggen.field import Field
from reggen.register import Register
from reggen.reg_block import RegBlock

from shared.otbn_reggen import load_registers

from .trace import Trace


class ExtRegChange(Trace):
    def __init__(self, op: str, written: int, from_hw: bool, new_value: int):
        self.op = op
        self.written = written
        self.from_hw = from_hw
        self.new_value = new_value


class TraceExtRegChange(Trace):
    def __init__(self, name: str, erc: ExtRegChange):
        self.name = name
        self.erc = erc

    def trace(self) -> str:
        suff = (''
                if self.erc.new_value == self.erc.written
                else ' (now {:#010x})'.format(self.erc.new_value))
        return ("otbn.{} {} {:#010x}{}{}"
                .format(self.name,
                        self.erc.op,
                        self.erc.written,
                        ' (from SW)' if not self.erc.from_hw else '',
                        suff))

    def rtl_trace(self) -> str:
        return '! otbn.{}: {:#010x}'.format(self.name, self.erc.new_value)


class RGField:
    '''A wrapper around a field in a register as parsed by reggen'''
    def __init__(self,
                 name: str,
                 width: int,
                 lsb: int,
                 reset_value: int,
                 swaccess: str):
        # We only support some values of swaccess (the ones we need)
        assert swaccess in ['rw1c', 'rw', 'wo', 'r0w1c', 'ro']
        assert width > 0
        assert lsb >= 0

        self.name = name
        self.width = width
        self.lsb = lsb
        self.value = reset_value

        # swaccess
        self.w1c = swaccess in ['rw1c', 'r0w1c']
        self.read_only = swaccess == 'ro'
        self.read_zero = swaccess in ['wo', 'r0w1c']

        self.next_value = reset_value

    @staticmethod
    def from_field(field: Field) -> 'RGField':
        name = field.name
        assert isinstance(name, str)

        width = field.bits.width()
        assert isinstance(width, int)

        lsb = field.bits.lsb
        assert isinstance(lsb, int)

        reset_value = field.resval or 0
        assert isinstance(reset_value, int)

        swaccess = field.swaccess.key
        assert isinstance(swaccess, str)

        return RGField(name, width, lsb, reset_value, swaccess)

    def _next_sw_read(self) -> int:
        return 0 if self.read_zero else self.next_value

    def write(self, value: int, from_hw: bool) -> int:
        '''Stage the effects of writing a value (see RGReg.write)'''
        assert value >= 0
        masked = value & ((1 << self.width) - 1)

        if self.read_only and not from_hw:
            pass
        elif self.w1c and not from_hw:
            self.next_value &= ~masked
        else:
            self.next_value = masked

        return self._next_sw_read()

    def set_bits(self, value: int) -> int:
        '''Like write, but |=.'''
        masked = value & ((1 << self.width) - 1)
        self.next_value |= masked
        return self._next_sw_read()

    def clear_bits(self, value: int) -> int:
        '''Like write, but &= ~.'''
        self.next_value &= ~value
        return self._next_sw_read()

    def read(self, from_hw: bool) -> int:
        return 0 if (self.read_zero and not from_hw) else self.value

    def commit(self) -> None:
        self.value = self.next_value

    def abort(self) -> None:
        self.next_value = self.value


class RGReg:
    '''A wrapper around a register as parsed by reggen'''
    def __init__(self, fields: List[RGField], double_flopped: bool):
        self.fields = fields
        self.double_flopped = double_flopped
        self._trace = []  # type: List[ExtRegChange]
        self._next_trace = []  # type: List[ExtRegChange]

    @staticmethod
    def from_register(reg: Register, double_flopped: bool) -> 'RGReg':
        return RGReg([RGField.from_field(fd) for fd in reg.fields],
                     double_flopped)

    def _apply_fields(self,
                      func: Callable[[RGField, int], int],
                      value: int) -> int:
        new_val = 0
        for field in self.fields:
            field_new_val = func(field, value >> field.lsb)
            new_val |= field_new_val << field.lsb
        return new_val

    def write(self, value: int, from_hw: bool) -> None:
        '''Stage the effects of writing a value.

        If from_hw is true, this write is from OTBN hardware (rather than the
        bus).

        '''
        assert value >= 0
        now = self._apply_fields(lambda fld, fv: fld.write(fv, from_hw), value)
        trace = self._next_trace if self.double_flopped else self._trace
        trace.append(ExtRegChange('=', value, from_hw, now))

    def set_bits(self, value: int) -> None:
        assert value >= 0
        now = self._apply_fields(lambda fld, fv: fld.set_bits(fv), value)
        trace = self._next_trace if self.double_flopped else self._trace
        trace.append(ExtRegChange('=', value, False, now))

    def read(self, from_hw: bool) -> int:
        value = 0
        for field in self.fields:
            value |= field.read(from_hw) << field.lsb
        return value

    def commit(self) -> None:
        for field in self.fields:
            field.commit()
        self._trace = self._next_trace
        self._next_trace = []

    def abort(self) -> None:
        for field in self.fields:
            field.abort()
        self._trace = []
        self._next_trace = []

    def changes(self) -> List[ExtRegChange]:
        return self._trace


def make_flag_reg(name: str, double_flopped: bool) -> RGReg:
    return RGReg([RGField(name, 32, 0, 0, 'ro')], double_flopped)


class OTBNExtRegs:
    '''A class representing OTBN's externally visible CSRs

    This models an extra flop between the core and some of the externally
    visible registers by ensuring that a write only becomes visible after an
    intervening commit.

    '''
    double_flopped_regs = ['STATUS']

    def __init__(self) -> None:
        _, reg_block = load_registers()

        self.regs = {}  # type: Dict[str, RGReg]
        self._dirty = 0

        assert isinstance(reg_block, RegBlock)
        for entry in reg_block.flat_regs:
            assert isinstance(entry.name, str)

            # reggen's validation should have checked that we have no
            # duplicates.
            assert entry.name not in self.regs
            double_flopped = entry.name in self.double_flopped_regs
            self.regs[entry.name] = RGReg.from_register(entry, double_flopped)

        # Add a fake "STOP_PC" register.
        #
        # TODO: We might well add something like this to the actual design in
        # the future (see issue #4327) but, for now, it's just used in
        # simulation to help track whether RIG-generated binaries finished
        # where they expected to finish.
        self.regs['STOP_PC'] = make_flag_reg('STOP_PC', True)

        # Add a fake "RND_REQ" register to allow us to tell otbn_core_model to
        # generate an EDN request.
        self.regs['RND_REQ'] = make_flag_reg('RND_REQ', True)

        # Add a fake "WIPE_START" register. We set this for a single cycle when
        # starting secure wipe and the C++ model can use this to trigger a dump
        # of internal state before it gets zeroed out.
        self.regs['WIPE_START'] = make_flag_reg('WIPE_START', False)

    def _get_reg(self, reg_name: str) -> RGReg:
        reg = self.regs.get(reg_name)
        if reg is None:
            raise ValueError('Unknown register name: {!r}.'.format(reg_name))
        return reg

    def write(self, reg_name: str, value: int, from_hw: bool) -> None:
        '''Stage the effects of writing a value to a register'''
        assert value >= 0
        self._get_reg(reg_name).write(value, from_hw)
        self._dirty = 2

    def set_bits(self, reg_name: str, value: int) -> None:
        '''Set some bits of a register (HW access only)'''
        assert value >= 0
        self._get_reg(reg_name).set_bits(value)
        self._dirty = 2

    def increment_insn_cnt(self) -> None:
        '''Increment the INSN_CNT register'''
        reg = self._get_reg('INSN_CNT')
        assert len(reg.fields) == 1
        fld = reg.fields[0]
        reg.write(min(fld.value + 1, (1 << 32) - 1), True)
        self._dirty = 2

    def read(self, reg_name: str, from_hw: bool) -> int:
        reg = self.regs.get(reg_name)
        if reg is None:
            raise ValueError('Unknown register name: {!r}.'.format(reg_name))
        return reg.read(from_hw)

    def changes(self) -> Sequence[Trace]:
        if self._dirty == 0:
            return []

        trace = []
        for name, reg in self.regs.items():
            trace += [TraceExtRegChange(name, erc) for erc in reg.changes()]
        return trace

    def commit(self) -> None:
        # We know that we'll only have any pending changes if self._dirty is
        # positive, so needn't bother calling commit on each register if not.
        if self._dirty > 0:
            for reg in self.regs.values():
                reg.commit()
            self._dirty = max(0, self._dirty - 1)

    def abort(self) -> None:
        for reg in self.regs.values():
            reg.abort()
        self._dirty = 0
