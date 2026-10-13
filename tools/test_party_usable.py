#!/usr/bin/env python3
"""Keep a usable Pokemon when depositing/releasing with Eggs in the party.

Executes the compiled storage guard and callers with private SRAM. An optional
ROM path and matching symbols support before/after reproduction.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    pc = _parse_constants(Path(ROOT) / 'constants/pc_constants.asm')
    species = h.species_id(con.species_index('PIKACHU'))
    checks, failures = 0, []

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)
            if len(failures) <= 20:
                print('FAIL:', message, flush=True)

    def party(states):
        h.wr(h.s('wPartyCount'), len(states))
        h.wr(h.s('wPartySpecies'), [253 if state == 2 else species for state in states] + [255])
        for slot, state in enumerate(states):
            prefix = f'wPartyMon{slot + 1}'
            h.wr(h.s(prefix + 'Species'), species)
            h.wr(h.s(prefix + 'Item'), 0)
            # Stage nonzero Egg HP to ensure the guard checks species too.
            # Normal egg creation/storage decoding sets this HP to zero.
            h.wr(h.s(prefix + 'HP'), [0, 0 if state == 0 else 20])
            h.wr(h.s(prefix + 'MaxHP'), [0, 20])

    print('[usable reserve guard: healthy/fainted/Egg layouts in every slot]', flush=True)
    for count in range(1, 7):
        for states in product(range(3), repeat=count):
            party(states)
            for target in range(count):
                h.wr(h.s('wCurPartyMon'), target)
                result = h.call('CheckCurPartyMonFainted')
                expected = not any(state == 1 for slot, state in enumerate(states) if slot != target)
                check(result['c_flag'] == expected, f'party {states}, target {target}: wrong usable reserve result')

    print('[PC deposit/release: last healthy Pokemon with Eggs and fainted reserves]', flush=True)
    for states in ((1, 2), (2, 1), (1, 0, 2), (2, 0, 1), (2, 2, 1, 2, 0, 2)):
        h.call('InitializeBoxes')
        h.call('ClearBackupBoxes')
        party(states)
        target = states.index(1)
        original = h.rd(h.s('wPartyCount'), h.s('wPartyMonOT') - h.s('wPartyCount'))
        result = h.call('BillsPC_CanReleaseMon', bc=target + 1)
        check(result['a'] == pc['RELEASE_LAST_HEALTHY'], f'release accepted last healthy mon: {states}')
        result = h.call('SwapStorageBoxSlots', bc=target + 1, de=0x101)
        check(result['a'] == pc['PCSWAP_LAST_HEALTHY'], f'deposit accepted last healthy mon: {states}')
        check(h.rd(h.s('wPartyCount'), len(original)) == original, f'refused deposit changed party: {states}')
        check(h.box_pointer(1, 1)[1] == 0, f'refused deposit changed box: {states}')

    print('[PC swap: a healthy box replacement is allowed, an Egg is refused]', flush=True)
    for egg in (0, 1):
        h.call('InitializeBoxes')
        h.call('ClearBackupBoxes')
        party((1, 2))
        h.build_temp_mon(con.species_index('EEVEE'), [con.move_index('TACKLE'), 0, 0, 0],
                         level=20, egg=egg)
        h.call('AddTempMonToStorage')
        result = h.call('SwapStorageBoxSlots', bc=1, de=0x101)
        check(result['a'] == pc['PCSWAP_LAST_HEALTHY' if egg else 'PCSWAP_OK'],
              f'box replacement egg={egg}: wrong swap result')
        check(h.rd(h.s('wPartySpecies')) != 253 and h.rd(h.s('wPartyMon1HP'), 2) != bytes(2),
              f'box replacement egg={egg}: lost battle-ready party member')

    print('[empty party: guard returns instead of walking beyond party data]', flush=True)
    party(())
    h.wr(h.s('wCurPartyMon'), 0)
    try:
        result = h.call('CheckCurPartyMonFainted', max_frames=10)
        check(result['c_flag'], 'empty party should have no usable reserve')
    except RuntimeError:
        check(False, 'empty party guard does not return')

    h.pyboy.stop(save=False)
    print(f'PARTY USABLE: {checks} checks, {len(failures)} failures; {h.calls} routine calls')
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
