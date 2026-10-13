#!/usr/bin/env python3
"""Execute HP, friendship and Poke Seer regressions on a compiled ROM.

Uses private in-memory SRAM. The Seer checks suppress its formatting helpers;
the ownership branch itself and all HP/friendship writes execute unchanged.
Pass a ROM path with matching .sym to reproduce the pre-fix failures.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    happiness = _parse_constants(Path(ROOT) / 'constants/pokemon_data_constants.asm')
    checks, failures = 0, []

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)
            if len(failures) <= 20:
                print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    print('[test constants: explicit decimal and signed hexadecimal resets]', flush=True)
    check(happiness['HAPPINESS_FAINTED'] == 6, 'friendship constants ignore const_value = 1')
    check(con.moves['ANIM_INTRO_RAIN'] == -0x1b, 'animation constants ignore const_value = -$1b')
    for filename, name, expected in (
            ('wram_constants.asm', 'STANDING', -1),
            ('wram_constants.asm', 'DOWN', 0),
            ('script_constants.asm', 'PLAYEREVENT_NONE', 0),
            ('map_setup_constants.asm', 'MAPSETUP_WARP', 0xf1),
            ('menu_constants.asm', 'PARTYMENUTEXT_HEAL_HP', 0xf5),
            ('sprite_data_constants.asm', 'PAL_NPC_RED', 8)):
        parsed = _parse_constants(Path(ROOT) / 'constants' / filename)
        check(parsed[name] == expected, f'{filename}: {name} parsed as {parsed[name]}, expected {expected}')

    print('[HP subtraction: saturation, borrow and permanent flag guards]', flush=True)
    for slot, flags, hp, damage in product(range(6), (0, 0x40, 0x80, 0xc0),
                                         (0, 1, 20, 255, 256, 511, 714),
                                         (0, 1, 20, 254, 255, 256, 512, 715)):
        write('wCurPartyMon', slot)
        prefix = f'wPartyMon{slot + 1}'
        write(prefix + 'Status', 8)
        write(prefix + 'Unused', flags)
        write(prefix + 'HP', [hp >> 8, hp & 255])
        write(prefix + 'MaxHP', [2, 202])
        h.call('RemoveHP', de=damage)
        result = (read(prefix + 'HP') << 8) | h.rd(h.s(prefix + 'HP') + 1)
        label = f'party {slot + 1}, flags {flags:#x}, HP {hp}, damage {damage}'
        check(result == max(0, hp - damage), label + f': HP became {result}')
        check(read(prefix + 'Unused') == flags, label + ': shiny/gender flags changed')
        check(read(prefix + 'Status') == 8, label + ': status changed')
        check(h.rd(h.s(prefix + 'MaxHP'), 2) == bytes([2, 202]), label + ': max HP changed')
        check((read('wBuffer6') << 8) | read('wBuffer5') == result, label + ': HUD HP buffer mismatch')

    print('[friendship: active Pokemon, every party slot and menu cursor]', flush=True)
    species = h.species_id(con.species_index('PIKACHU'))
    write('wPartyCount', 6)
    write('wPartySpecies', [species] * 6 + [255])
    for mode, active, target, cursor in product((0, 1, 2), range(6), range(6), range(8)):
        for slot in range(6):
            write(f'wPartyMon{slot + 1}Happiness', 100)
        write('wBattleMode', mode)
        write('wCurBattleMon', active)
        write('wCurPartyMon', target)
        write('wPartyMenuCursor', cursor)
        write('wBattleMonHappiness', 177)
        h.call('ChangeHappiness', bc=happiness['HAPPINESS_FAINTED'])
        label = f'mode {mode}, active {active}, target {target}, cursor {cursor}'
        check(read(f'wPartyMon{target + 1}Happiness') == 99, label + ': party friendship not updated')
        expected = 99 if mode and active == target else 177
        check(read('wBattleMonHappiness') == expected, label + ': wrong live friendship')
        check(all(read(f'wPartyMon{slot + 1}Happiness') == 100 for slot in range(6) if slot != target),
              label + ': another party member changed')
    write('wBattleMode', 0)

    print('[party-filter masks: every egg/non-egg layout, including empty parties]', flush=True)
    for count in range(7):
        for egg_mask in range(1 << count):
            write('wPartyCount', count)
            write('wPartySpecies', [253 if egg_mask & (1 << slot) else species
                                   for slot in range(count)] + [255])  # EGG = -3
            for slot in range(6):
                write(f'wPartyMon{slot + 1}Level', 100)
                write(f'wPartyMon{slot + 1}Happiness', 100)
            expected = ((1 << count) - 1) & ~egg_mask
            for routine in ('_FindPartyMonAtLeastThatHappy', '_FindPartyMonAboveLevel'):
                threshold = 99 if routine == '_FindPartyMonAboveLevel' else 100
                result = h.call(routine, bc=threshold << 8)
                label = f'{routine}, size {count}, eggs {egg_mask:#x}'
                check(result['c'] == expected, label + f': mask {result["c"]:#x} != {expected:#x}')
                check(result['z'] == (expected == 0), label + ': incorrect found/none result')

    print('[party-filter masks: independently eligible slots and Egg exclusions]', flush=True)
    for count in range(1, 7):
        for selected, eggs in product(range(1 << count), repeat=2):
            write('wPartyCount', count)
            write('wPartySpecies', [253 if eggs & (1 << slot) else species
                                   for slot in range(count)] + [255])
            for slot in range(count):
                eligible = bool(selected & (1 << slot))
                write(f'wPartyMon{slot + 1}Level', 51 if eligible else 50)
                write(f'wPartyMon{slot + 1}Happiness', 150 if eligible else 149)
            expected = selected & ~eggs
            for routine, threshold in (('_FindPartyMonAtLeastThatHappy', 150),
                                       ('_FindPartyMonAboveLevel', 50)):
                result = h.call(routine, bc=threshold << 8)
                label = f'{routine}, size {count}, selected {selected:#x}, eggs {eggs:#x}'
                check(result['c'] == expected, label + ': incorrect slot mask')
                check(result['z'] == (expected == 0), label + ': incorrect found/none result')

    write('wPartyCount', 1)
    write('wPartySpecies', [species, 255])
    for level in (49, 50, 51):
        write('wPartyMon1Level', level)
        result = h.call('_FindPartyMonAboveLevel', bc=50 << 8)
        check(result['c'] == int(level > 50), f'above-level filter: level {level}, cutoff 50')
        check(result['z'] == (level <= 50), f'above-level filter: found/none at level {level}')

    print('[Poke Seer: both trainer-ID bytes, all low bytes and every party slot]', flush=True)
    helpers = {name: [0xc9] for name in ('GetCaughtLevel', 'GetCaughtOT', 'GetCaughtName',
                                        'GetCaughtTime', 'GetCaughtLocation')}
    with patches(h, helpers):
        for slot, low, same_high, same_low in product(range(6), range(256), (False, True), (False, True)):
            write('wCurPartyMon', slot)
            write('wPlayerID', [0x12, low])
            write(f'wPartyMon{slot + 1}ID', [0x12 if same_high else 0x34, low if same_low else low ^ 1])
            write(f'wPartyMon{slot + 1}CaughtLevel', [0x8a, 1])
            h.call('ReadCaughtData')
            expected = 0 if same_high and same_low else 1  # SEERACTION_MET / TRADED
            check(read('wSeerAction') == expected,
                  f'Seer slot {slot}, low {low}, same high/low {same_high}/{same_low}: action {read("wSeerAction")}')
        for slot in range(6):
            write('wCurPartyMon', slot)
            write(f'wPartyMon{slot + 1}CaughtLevel', [0, 0])
            h.call('ReadCaughtData')
            check(read('wSeerAction') == 2, f'Seer slot {slot}: unknown origin should remain unknown')

    h.pyboy.stop(save=False)
    print(f'AUDIT STATE REGRESSIONS: {checks} checks, {len(failures)} failures; {h.calls} routine calls')
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
