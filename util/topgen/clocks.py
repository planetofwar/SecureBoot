# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Dict, List, NamedTuple, Tuple


def _yn_to_bool(yn: object) -> bool:
    yn_str = str(yn)
    if yn_str.lower() == 'yes':
        return True
    if yn_str.lower() == 'no':
        return False
    raise ValueError('Unknown yes/no value: {!r}.'.format(yn))


def _bool_to_yn(val: bool) -> str:
    return 'yes' if val else 'no'


def _to_int(val: object) -> int:
    if isinstance(val, int):
        return val
    return int(str(val))


def _check_choices(val: str, what: str, choices: List[str]) -> str:
    if val in choices:
        return val
    raise ValueError('{} is {!r}, which is not one of the expected values: {}.'
                     .format(what, val, choices))


class SourceClock:
    '''A clock source (input to the top-level)'''
    def __init__(self, raw: Dict[str, object]):
        self.name = str(raw['name'])
        self.aon = _yn_to_bool(raw['aon'])
        self.freq = _to_int(raw['freq'])

    def _asdict(self) -> Dict[str, object]:
        return {
            'name': self.name,
            'aon': _bool_to_yn(self.aon),
            'freq': str(self.freq)
        }


class DerivedSourceClock(SourceClock):
    '''A derived source clock (divided down from some other clock)'''
    def __init__(self,
                 raw: Dict[str, object],
                 sources: Dict[str, SourceClock]):
        super().__init__(raw)
        self.div = _to_int(raw['div'])
        self.src = sources[str(raw['src'])]

    def _asdict(self) -> Dict[str, object]:
        ret = super()._asdict()
        ret['div'] = str(self.div)
        ret['src'] = self.src.name
        return ret


class ClockSignal:
    '''A clock signal in the design'''
    def __init__(self, name: str, src: SourceClock):
        self.name = name
        self.src = src
        self.endpoints = []  # type: List[Tuple[str, str]]

    def add_endpoint(self, ep_name: str, ep_port: str) -> None:
        self.endpoints.append((ep_name, ep_port))


class Group:
    def __init__(self,
                 raw: Dict[str, object],
                 sources: Dict[str, SourceClock],
                 what: str):
        self.name = str(raw['name'])
        self.src = str(raw['src'])
        self.sw_cg = _check_choices(str(raw['sw_cg']), 'sw_cg for ' + what,
                                    ['yes', 'no', 'hint'])
        if self.src == 'yes' and self.sw_cg != 'no':
            raise ValueError(f'Clock group {self.name} has an invalid '
                             f'combination of src and sw_cg: {self.src} and '
                             f'{self.sw_cg}, respectively.')

        self.unique = _yn_to_bool(raw.get('unique', 'no'))
        if self.sw_cg == 'no' and self.unique:
            raise ValueError(f'Clock group {self.name} has an invalid '
                             f'combination with sw_cg of {self.sw_cg} and '
                             f'unique set.')

        self.clocks = {}  # type: Dict[str, ClockSignal]
        raw_clocks = raw.get('clocks', {})
        if not isinstance(raw_clocks, dict):
            raise ValueError(f'clocks for {what} is not a dictionary')
        for clk_name, src_name in raw_clocks.items():
            src = sources.get(src_name)
            if src is None:
                raise ValueError(f'The {clk_name} entry of clocks for {what} '
                                 f'has source {src_name}, which is not a '
                                 f'known clock source.')
            self.add_clock(clk_name, src)

    def add_clock(self, clk_name: str, src: SourceClock) -> ClockSignal:
        # Duplicates are ok, so long as they have the same source.
        sig = self.clocks.get(clk_name)
        if sig is not None:
            if sig.src is not src:
                raise ValueError(f'Cannot add clock {clk_name} to group '
                                 f'{self.name} with source {src.name}: the '
                                 f'clock is there already with source '
                                 f'{sig.src.name}.')
        else:
            sig = ClockSignal(clk_name, src)
            self.clocks[clk_name] = sig

        return sig

    def _asdict(self) -> Dict[str, object]:
        return {
            'name': self.name,
            'src': self.src,
            'sw_cg': self.sw_cg,
            'unique': _bool_to_yn(self.unique),
            'clocks': {name: sig.src.name
                       for name, sig in self.clocks.items()}
        }


class TypedClocks(NamedTuple):
    # Clocks fed through clkmgr but not disturbed in any way. This maintains
    # the clocking structure consistency. This includes two groups of clocks:
    #
    #   - Clocks fed from the always-on source
    #   - Clocks fed to the powerup group
    ft_clks: Dict[str, ClockSignal]

    # Non-feedthrough clocks that have no software control. These clocks are
    # root-gated and the root-gated clock is then exposed directly in clocks_o.
    rg_clks: Dict[str, ClockSignal]

    # Non-feedthrough clocks that have direct software control. These are
    # root-gated, but (unlike rg_clks) then go through a second clock gate
    # which is controlled by software.
    sw_clks: Dict[str, ClockSignal]

    # Non-feedthrough clocks that have "hint" software control (with a feedback
    # mechanism to allow blocks to avoid being suspended when they are not
    # idle).
    hint_clks: Dict[str, ClockSignal]

    # A list of the of non-always-on clock sources that are exposed without
    # division, sorted by name. This doesn't include clock sources that are
    # only used to derive divided clocks (we might gate the divided clocks, but
    # don't bother gating the upstream source).
    rg_srcs: List[str]


class Clocks:
    '''Clock connections for the chip'''
    def __init__(self, raw: Dict[str, object]):
        self.hier_paths = {}
        assert isinstance(raw['hier_paths'], dict)
        for grp_src, path in raw['hier_paths'].items():
            self.hier_paths[str(grp_src)] = str(path)

        assert isinstance(raw['srcs'], list)
        self.srcs = {}
        for r in raw['srcs']:
            clk = SourceClock(r)
            self.srcs[clk.name] = clk

        self.derived_srcs = {}
        assert isinstance(raw['derived_srcs'], list)
        for r in raw['derived_srcs']:
            clk = DerivedSourceClock(r, self.srcs)
            self.derived_srcs[clk.name] = clk

        self.all_srcs = self.srcs.copy()
        self.all_srcs.update(self.derived_srcs)

        self.groups = {}
        assert isinstance(raw['groups'], list)
        for idx, raw_grp in enumerate(raw['groups']):
            assert isinstance(raw_grp, dict)
            grp = Group(raw_grp, self.srcs, f'clocks.groups[{idx}]')
            self.groups[grp.name] = grp

    def _asdict(self) -> Dict[str, object]:
        return {
            'hier_paths': self.hier_paths,
            'srcs': list(self.srcs.values()),
            'derived_srcs': list(self.derived_srcs.values()),
            'groups': list(self.groups.values())
        }

    def add_clock_to_group(self,
                           grp: Group,
                           clk_name: str,
                           src_name: str) -> ClockSignal:
        src = self.all_srcs.get(src_name)
        if src is None:
            raise ValueError(f'Cannot add clock {clk_name} to group '
                             f'{grp.name}: the given source name is '
                             f'{src_name}, which is unknown.')
        return grp.add_clock(clk_name, src)

    def get_clock_by_name(self, name: str) -> object:
        ret = self.all_srcs.get(name)
        if ret is None:
            raise ValueError(f'{name} is not a valid clock')
        return ret

    def reset_signals(self) -> List[str]:
        '''Return the list of clock reset signal names

        These signals are inputs to the clock manager (from the reset
        manager)

        '''
        ret = []
        for src in self.srcs.values():
            if not src.aon:
                ret.append(f'rst_{src.name}_ni')
        for src in self.derived_srcs.values():
            ret.append(f'rst_{src.name}_ni')
        return ret

    def typed_clocks(self) -> TypedClocks:
        '''Split the clocks by type'''
        ft_clks = {}
        rg_clks = {}
        sw_clks = {}
        hint_clks = {}
        rg_srcs_set = set()

        for grp in self.groups.values():
            if grp.name == 'powerup':
                # All clocks in the "powerup" group are considered feed-throughs.
                ft_clks.update(grp.clocks)
                continue

            for clk, sig in grp.clocks.items():
                if sig.src.aon:
                    # Any always-on clock is a feedthrough
                    ft_clks[clk] = sig
                    continue

                rg_srcs_set.add(sig.src.name)

                if grp.sw_cg == 'no':
                    # A non-feedthrough clock with no software control
                    rg_clks[clk] = sig
                    continue

                if grp.sw_cg == 'yes':
                    # A non-feedthrough clock with direct software control
                    sw_clks[clk] = sig
                    continue

                # The only other valid value for the sw_cg field is "hint", which
                # means a non-feedthrough clock with "hint" software control.
                assert grp.sw_cg == 'hint'
                hint_clks[clk] = sig
                continue

        # Define a canonical ordering for rg_srcs
        rg_srcs = list(sorted(rg_srcs_set))

        return TypedClocks(ft_clks=ft_clks,
                           rg_clks=rg_clks,
                           sw_clks=sw_clks,
                           hint_clks=hint_clks,
                           rg_srcs=rg_srcs)

    def make_clock_to_group(self) -> Dict[str, Group]:
        '''Return a map from clock name to the group containing the clock'''
        c2g = {}
        for grp in self.groups.values():
            for clk_name in grp.clocks.keys():
                c2g[clk_name] = grp
        return c2g
