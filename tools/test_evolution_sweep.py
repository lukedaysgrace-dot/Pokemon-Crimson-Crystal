#!/usr/bin/env python3
"""Every compiled evolution row through native eligibility/stat/species code.

Presentation, animations and post-evolution move-learning UI are suppressed;
this checks lifecycle state rather than rendering or move-learning menus.
Fixtures use private SRAM and explicit time/map/gender/item prerequisites.
"""
from pathlib import Path
from collections import Counter
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches

ROOT = Path(ROOT)


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    data = _parse_constants(ROOT / 'constants/pokemon_data_constants.asm')
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    methods = {data[name]: name for name in data if name.startswith('EVOLVE_')}
    bank, address = h.sym['EvosAttacksPointers']
    rows = []
    for index in sorted(con.species_by_index):
        result = h.call('LoadDoubleIndirectPointer', a=bank, bc=index, hl=address)
        ptr, row_bank = result['hl'], result['a']
        while h.mem[row_bank, ptr]:
            method = h.mem[row_bank, ptr]
            length = 5 if method in (data['EVOLVE_STAT'], data['EVOLVE_HOLDING']) else 4
            blob = bytes(h.mem[row_bank, ptr:ptr + length])
            rows.append((index, method, list(blob[1:-2]), blob[-2] | blob[-1] << 8))
            ptr += length
    print('Evolution rows:', len(rows), dict(Counter(methods[row[1]] for row in rows)), flush=True)
    checks, failures = 0, []

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)
            print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    def party(source, method, args, target):
        name, evolved = con.species_by_index[source], con.species_by_index[target]
        level = args[0] if method in (data['EVOLVE_LEVEL'], data['EVOLVE_LEVEL_MALE'], data['EVOLVE_LEVEL_FEMALE'], data['EVOLVE_STAT'], data['EVOLVE_HOLDING']) else 50
        if name == 'DIPPLIN':
            level = 36
        held = args[1] if method == data['EVOLVE_HOLDING'] else (args[0] if method == data['EVOLVE_TRADE'] and args[0] != 255 else 0)
        gender = 0 if method == data['EVOLVE_LEVEL_FEMALE'] else 0x40
        info = h.build_temp_mon(source, [con.move_index('TACKLE'), 0, 0, 0], level=level, item=held,
                                statexp=bytes(10), personality=0x6D, hidden_power=12,
                                happiness=255, shiny_gender=gender | 0x80)
        write('wCurSpecies', info['sid'])
        h.call('GetBaseData')
        bases = h.rd(h.s('wBaseStats'), 6)
        stats = [(base + 15) * 2 * level // 100 + (level + 10 if i == 0 else 5) for i, base in enumerate(bases)]
        for i, value in enumerate(stats):
            h.wr(h.s('wTempMonMaxHP') + i * 2, [value >> 8, value & 255])
        write('wTempMonHP', [stats[0] >> 8, stats[0] & 255])
        write('wPartyCount', 1)
        write('wPartySpecies', [info['sid'], 255])
        write('wPartyMon1', h.rd(h.s('wTempMon'), 50))
        write('wPartyMonNicknames', h.rd(h.s('wTempMonNickname'), 11))
        write('wPartyMonOT', h.rd(h.s('wTempMonOT'), 11))
        write('wCurPartyMon', 0)
        write('wCurPartyLevel', level)
        write('wLinkMode', 1 if method == data['EVOLVE_TRADE'] else 0)
        write('wForceEvolution', 1 if method == data['EVOLVE_ITEM'] else 0)
        write('wCurItem', args[0] if method == data['EVOLVE_ITEM'] else 0)
        write('wBattleMode', 1)
        write('wTimeOfDay', 2 if (method == data['EVOLVE_HAPPINESS'] and args[0] == data['TR_NITE']) or evolved in ('CERULEDGE', 'URSALUNABM') else 1)
        write('wMapGroup', 0)
        write('wMapNumber', 0)
        if evolved in ('TYPHLOSION_HISUIAN', 'MAROWAK_ALOLAN'):
            # GROUP_BURNED_TOWER_1F = Ecruteak's group, map 1F is first.
            group = number = 0
            import re
            for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
                if re.match(r'\s+newgroup\b', line):
                    group += 1
                    number = 0
                match = re.match(r'\s+map_const\s+(\w+)', line)
                if match:
                    number += 1
                    if match.group(1) == 'BURNED_TOWER_1F':
                        write('wMapGroup', group)
                        write('wMapNumber', number)
                        break
        if evolved == 'WEEZING_GALARIAN':
            write('wPartyMon1Moves', [h.move_id(con.move_index('FAIRY_WIND')), 0, 0, 0])
        if method == data['EVOLVE_STAT']:
            atk, defense = (100, 101) if args[1] == data['ATK_LT_DEF'] else ((101, 100) if args[1] == data['ATK_GT_DEF'] else (100, 100))
            write('wPartyMon1Attack', [atk >> 8, atk & 255])
            write('wPartyMon1Defense', [defense >> 8, defense & 255])
        return info['sid'], held

    presentation = {name: b'\xc9' for name in ('PrintText', 'PrintTextboxText', 'DelayFrames', 'ClearSprites',
                      'ClearTileMap', 'PlayMusic', 'PlaySFX', 'WaitSFX', 'LearnLevelMoves')}
    presentation['EvolutionAnimation'] = b'\xaf\xc9'
    with patches(h, presentation):
        for source, method, args, target in rows:
            name, evolved = con.species_by_index[source], con.species_by_index[target]
            sid, held = party(source, method, args, target)
            personality = h.rd(h.s('wPartyMon1Personality'), 2)
            permanent_flags = h.rd(h.s('wPartyMon1') + 35)
            h.call('EvolvePokemon', max_frames=300)
            actual = h.species_index(h.rd(h.s('wPartyMon1Species')))
            label = f'{name}->{evolved} ({methods[method]})'
            check(actual == target, label + ': wrong species ' + con.species_by_index.get(actual, str(actual)))
            check(h.rd(h.s('wPartyMon1Personality'), 2) == personality, label + ': changed permanent personality')
            check(h.rd(h.s('wPartyMon1') + 35) == permanent_flags, label + ': changed shiny/gender')
            expected_item = 0 if method == data['EVOLVE_HOLDING'] or (method == data['EVOLVE_TRADE'] and held) else held
            check(h.rd(h.s('wPartyMon1Item')) == expected_item, label + ': wrong held-item consumption')
            check(h.rd(h.s('wPartyCount')) == 1, label + ': changed party count')
            hp = int.from_bytes(h.rd(h.s('wPartyMon1HP'), 2), 'big')
            maxhp = int.from_bytes(h.rd(h.s('wPartyMon1MaxHP'), 2), 'big')
            check(0 < hp <= maxhp, label + ': evolved HP out of bounds')
            if method not in (data['EVOLVE_ITEM'], data['EVOLVE_HOLDING']):
                party(source, method, args, target)
                write('wPartyMon1Item', items['EVERSTONE'])
                h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == source, label + ': ignored Everstone')
            if method == data['EVOLVE_HOLDING']:
                party(source, method, args, target)
                with patches(h, {'EvolutionAnimation': b'\x37\xc9'}):
                    h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == source, label + ': cancellation changed species')
                check(h.rd(h.s('wPartyMon1Item')) == held, label + ': cancellation consumed item')
    h.pyboy.stop(save=False)
    print(f'EVOLUTION SWEEP: {len(rows)} rows, {checks} checks; {len(failures)} failures', flush=True)
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
