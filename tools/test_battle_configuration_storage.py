#!/usr/bin/env python3
"""Native PC/party integrity for stored ability slots and Hidden Power types.

All tests use private emulator SRAM. Seedot legally has three distinct
abilities, so the decoded slot is checked through the real ability lookup.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def run(rom):
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    failures, checks = [], 0

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(label)

    def inspect(location, expected):
        personality, kind, appearance = expected
        result = h.call('GetStorageBoxMon', bc=location)
        mon = h.temp_mon()
        label = f'location={location:04x} personality={personality:02x} HP-type={kind} appearance={appearance:02x}'
        check(not result['z'] and not result['c_flag'], label + ' valid record')
        check(mon['hidden_power'] == kind and mon['personality'] == personality, label + ' independent configuration')
        check(mon['unused'] == appearance and mon['idx'] == con.species['SEEDOT'], label + ' identity/appearance')
        result = h.call('GetAbility', bc=(personality << 8) | mon['species'], de=0x5678, hl=0x9abc)
        expected_ability = ('PRANKSTER', 'WIND_RIDER', 'TECHNICIAN')[(personality >> 5) - 1]
        check(result['b'] == con.abilities[expected_ability], label + ' effective ability')
        check(result['de'] == 0x5678 and result['hl'] == 0x9abc and h.rd(0xff70) & 7 == 1, label + ' registers/bank')

    try:
        for name in ('wPartyCount', 'wCurBox', 'wGameplayRules'):
            h.wr(h.s(name), 0)
        h.wr(h.s('wPartySpecies'), 255)
        h.call('InitializeBoxes')
        records = []
        kinds = (0, 1, 2, 3, 4, 5, 7, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28)
        for slot, kind, appearance in product((0x20, 0x40, 0x60), kinds, (0, 0x40, 0x80, 0xc0)):
            personality = slot | 17  # also preserve the independent caught-ball bits
            h.build_temp_mon(con.species['SEEDOT'], [con.moves['HIDDEN_POWER'], con.moves['TACKLE'], 0, 0],
                             personality=personality, hidden_power=kind, shiny_gender=appearance)
            result = h.call('AddTempMonToStorage')
            check(result['a'] < 2, 'stored configuration record')
            mon = h.temp_mon()
            location = mon['box'] * 256 + mon['slot']
            records.append((location, (personality, kind, appearance)))
            h.wr(h.s('wTempMon'), bytes(50))
            inspect(location, records[-1][1])
        # Recall two deliberately different configurations, reorder them,
        # and deposit again. The species alone cannot distinguish these mons.
        for location, _ in (records[0], records[-1]):
            check(h.call('SwapStorageBoxSlots', bc=0, de=location)['a'] == 0, 'withdraw configuration')
        inspect(1, records[0][1])
        inspect(2, records[-1][1])
        check(h.call('SwapStorageBoxSlots', bc=1, de=2)['a'] == 0, 'party reorder')
        inspect(1, records[-1][1])
        inspect(2, records[0][1])
        result = h.call('SwapStorageBoxSlots', bc=25 * 256, de=1)
        check(result['a'] == 0, 'redeposit configuration')
        inspect(result['bc'], records[-1][1])
        for failure in failures:
            print('FAIL', failure)
        print(f'{rom}: {len(records)} configuration combinations, {checks} checks, {len(failures)} failures', flush=True)
    finally:
        h.pyboy.stop(save=False)
    return len(failures)


if __name__ == '__main__':
    paths = [Path(p) for p in sys.argv[1:]] or [Path(ROOT) / 'pokecrystal.gbc', Path(ROOT) / 'pokecrystal_debug.gbc']
    raise SystemExit(bool(sum(run(path) for path in paths)))
