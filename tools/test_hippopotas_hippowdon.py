#!/usr/bin/env python3
"""Native hippo-family data, high-index Dex, evolution and acquisition checks."""
import json
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT, enc
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    items = _parse_constants(root / 'constants/item_constants.asm')
    types = _parse_constants(root / 'constants/type_constants.asm')
    rows = json.loads((root / 'tools/testdata/hippopotas_hippowdon.json').read_text())['species']
    charmap = {text: int(value, 16) for text, value in re.findall(
        r'^\s*charmap "([^"\n]+)",\s*\$([0-9a-fA-F]+)', (root / 'charmap.asm').read_text(), re.M)}
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def party(species='HIPPOPOTAS', level=34, item=0):
        info = h.build_temp_mon(con.species_index(species),
                                [con.move_index('BITE'), con.move_index('DIG'), 0, 0],
                                level=level, item=item, statexp=bytes(10), nick='TESTMON@@@@')
        write('wTempMonHP', [0, 100])
        write('wTempMonMaxHP', [0, 100])
        write('wPartyCount', 1)
        write('wPartySpecies', [info['sid'], 255])
        write('wPartyMon1', h.rd(h.s('wTempMon'), 50))
        write('wPartyMonNicknames', h.rd(h.s('wTempMonNickname'), 11))
        write('wPartyMonOT', h.rd(h.s('wTempMonOT'), 11))
        write('wCurPartyMon', 0)
        write('wCurPartyLevel', level)
        for field in ('wCurPartySpecies', 'wTempSpecies'):
            write(field, info['sid'])
        for field in ('wLinkMode', 'wForceEvolution', 'wBattleMode'):
            write(field, 0)

    def menu(routine):
        guard = h.s('wMoveReminderMoveListEnd')
        h.wr(guard, 0xa5)
        h.call(routine)
        start = h.s('wMoveReminderMoveList')
        count = h.rd(start)
        data = h.rd(start + 1, count * 2 + 2)
        check(data[-2:] == b'\xff\x00', routine + ': terminator')
        check(h.rd(guard) == 0xa5, routine + ': buffer bounds')
        return [con.moves_by_index[int.from_bytes(data[i:i+2], 'big')]
                for i in range(0, count * 2, 2)]

    try:
        h.call('Pokedex_LoadGFX')
        for species, row in rows.items():
            sid = h.species_id(con.species_index(species))
            check(con.species_index(species) == row['internal_index'], species + ': appended index')
            for rules in range(8):
                write('wGameplayRules', rules)
                write('wCurSpecies', sid)
                h.call('GetBaseData')
                check(list(h.rd(h.s('wBaseStats'), 6)) == row['stats'], species + ': rules stats')
                check(list(h.rd(h.s('wBaseType1'), 2)) == [types['GROUND']] * 2, species + ': typing')
                check(list(h.rd(h.s('wBaseAbilities'), 3)) ==
                      [con.abilities[a] for a in row['abilities']], species + ': Lumi ability slots')
            for field, value in [('wBaseCatchRate', row['catch_rate']), ('wBaseExp', row['base_exp']),
                                 ('wBaseGender', 127), ('wBaseEggSteps', 30),
                                 ('wBaseEggGroups', 0x55), ('wBaseGrowthRate', 5)]:
                check(h.rd(h.s(field)) == value, species + ': ' + field)
            check(h.call('GetSpeciesWeightHG', a=sid)['hl'] == row['weight_hg'], species + ': weight power')
            check(h.call('GetRegionalDexNumber_DE', de=row['internal_index'])['hl'] == row['regional_dex'],
                  species + ': middle regional position')
            check(h.call('NormalizeRetiredRosterIndexDE', de=row['internal_index'])['de'] == row['internal_index'],
                  species + ': save ingress preserves index')
            check(not h.call('ValidateTempWildMonSpecies', hl=row['internal_index'])['c_flag'],
                  species + ': valid encounter species')
            for table in ('wPokedexCaught', 'wPokedexSeen'):
                write(table, bytes(63))
            h.call('SetSeenAndCaughtMon', a=sid)
            bit = row['internal_index'] - 1
            for table in ('wPokedexCaught', 'wPokedexSeen'):
                flags = h.rd(h.s(table), 63)
                check(flags[bit // 8] == 1 << (bit % 8) and sum(v.bit_count() for v in flags) == 1,
                      species + ': high-index ' + table)
            payload = (root / f'gfx/menu_icons/{species.lower()}.2bpp').read_bytes()
            check(len(payload) == 128, species + ': complete supplied menu frames')
            for routine in ('GetMenuIconPointer', 'GetIconPointer'):
                pointer = h.call(routine, a=sid)
                check(bytes(h.mem[pointer['b'], pointer['hl']:pointer['hl'] + 128]) == payload,
                      species + ': ' + routine)
            party(species, 100)
            check(set(menu('EggMoveTutor_GetTeachableMoves')) == set(row['egg_moves']) | set(row['technical_tutor']),
                  species + ': exact Blackthorn menu')
            for move in row['tmhm']:
                write('wPutativeTMHMMove', h.move_id(con.move_index(move)))
                check(h.call('CanLearnTMHMMove')['c'] != 0, species + ': machine ' + move)
            for move in ('THUNDERBOLT', 'ICE_BEAM', 'SURF'):
                write('wPutativeTMHMMove', h.move_id(con.move_index(move)))
                check(h.call('CanLearnTMHMMove')['c'] == 0, species + ': rejected machine ' + move)
            for level in (1, 10, 11, 34, 35, 36, 38, 39, 41, 100):
                party(species, level)
                check(h.rd(h.s('wPartyMon1Level')) == level, species + ': staged party level')
                check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == row['internal_index'],
                      species + ': staged party species')
                actual = set(menu('MoveReminder_GetRemindableMoves'))
                expected_moves = {m for lv, m in row['level_up'] if lv <= level} - {'BITE', 'DIG'}
                if species == 'HIPPOWDON':
                    expected_moves |= {m for lv, m in rows['HIPPOPOTAS']['level_up']
                                       if lv <= level} - {'BITE', 'DIG'}
                check(actual == expected_moves,
                      f'{species}: exact reminder at level {level}: {actual} != {expected_moves}; '
                      f'curlevel={h.rd(h.s("wCurPartyLevel"))}, curspecies={h.rd(h.s("wCurPartySpecies"))}')

            source = (root / f'data/pokemon/dex_entries/{species.lower()}.asm').read_text()
            category = re.search(r'db "([^"@]+)@"', source)[1]
            lines = re.findall(r'^\s*(?:db\s+|next\s+|page\s+)"([^"\n]*)"', source, re.M)[1:]
            lines = [line.rstrip('@') for line in lines]
            check(len(category) <= 10 and len(lines) == 6 and all(len(s) <= 18 for s in lines),
                  species + ': Dex text fits both pages')
            pointer = h.call('GetDexEntryPointer', bc=sid << 8)
            size = len(category) + 1
            raw = bytes(h.mem[pointer['b'], pointer['de']:pointer['de'] + size + 4])
            check(raw[:size] == enc(category + '@'), species + ': compiled category')
            check(int.from_bytes(raw[size:size+2], 'little') == row['height'], species + ': compiled height')
            check(int.from_bytes(raw[size+2:size+4], 'little') == row['weight_lbs_x10'], species + ': compiled weight')
            for field in ('wTempSpecies', 'wCurPartySpecies', 'wNamedObjectIndexBuffer'):
                write(field, sid)
            write('wPokedexCaught', bytes([255] * 63))
            for page in (0, 1):
                write('wPokedexStatus', page)
                h.call('Pokedex_DrawDexEntryScreenBG')
                h.call('DisplayDexEntry')
                tiles = h.rd(h.s('wTileMap'), 360)
                check(tiles[8*20+4:8*20+7] == enc(f"{row['regional_dex']:03d}"), species + ': displayed Dex number')
                for line_no, line in enumerate(lines[page*3:page*3+3]):
                    start = (11+line_no*2)*20+2
                    check(tiles[start:start+len(line)] == bytes(charmap[c] for c in line),
                          species + ': rendered Dex line')

        # A mature hippo produces Hippopotas and inherits from either parent slot.
        for parent_slot in (0, 1):
            baby = h.species_id(con.species_index('HIPPOPOTAS'))
            grown = h.species_id(con.species_index('HIPPOWDON'))
            ditto = h.species_id(con.species_index('DITTO'))
            for move in rows['HIPPOPOTAS']['egg_moves']:
                write('wEggMonSpecies', baby)
                write('wCurPartySpecies', baby)
                write('wBreedMon1Species', grown if parent_slot == 0 else ditto)
                write('wBreedMon2Species', ditto if parent_slot == 0 else grown)
                write('wBreedMotherOrNonDitto', parent_slot)
                write('wEggMonMoves', [0]*4)
                write('wEggMonPP', [0]*4)
                for slot in (0, 1):
                    write(f'wBreedMon{slot+1}Moves',
                          [h.move_id(con.move_index(move)), 0, 0, 0] if slot == parent_slot else [0]*4)
                h.call('InitEggMoves')
                inherited = [con.moves_by_index[h.move_index(m)] for m in h.rd(h.s('wEggMonMoves'), 4) if m]
                check(move in inherited, move + ': inheritance in parent slot ' + str(parent_slot))
        presentation = {name: b'\xc9' for name in (
            'PrintText', 'PrintTextboxText', 'DelayFrames', 'ClearSprites', 'ClearTileMap',
            'PlayMusic', 'PlaySFX', 'WaitSFX', 'RestartMapMusic', 'LearnLevelMoves')}
        presentation['EvolutionAnimation'] = b'\xaf\xc9'
        with patches(h, presentation):
            for level, item, cancel in [(33, 0, False), (34, 0, False), (35, 0, False),
                                        (100, 0, False), (34, items['EVERSTONE'], False), (34, 0, True)]:
                party(level=level, item=item)
                before = h.rd(h.s('wPartyMon1Moves'), 4)
                with patches(h, {'EvolutionAnimation': b'\x37\xc9'} if cancel else {}):
                    h.call('EvolvePokemon', max_frames=300)
                expected = 'HIPPOWDON' if level >= 34 and not (item or cancel) else 'HIPPOPOTAS'
                check(h.species_index(h.rd(h.s('wPartyMon1Species'))) == con.species_index(expected),
                      f'evolution at {level}, item {item}, cancel {cancel}')
                check(h.rd(h.s('wPartyMon1Moves'), 4) == before, 'evolution preserves moves')
        # Exercise the v5 box codec with both high indexes and the shiny flag.
        write('wCurBox', 0)
        write('wPlayerID', [0x12, 0x34])
        write('wPlayerName', enc('LUKE@@@@'))
        h.call('InitializeBoxes')
        h.call('ClearBackupBoxes')
        slot = 0
        for species, row in rows.items():
            for shiny_gender in (0x40, 0xc0):
                slot += 1
                h.build_temp_mon(row['internal_index'],
                                 [con.move_index('EARTHQUAKE'), con.move_index('SLACK_OFF'), 0, 0],
                                 level=50, shiny_gender=shiny_gender)
                check(h.call('AddTempMonToStorage')['a'] == 0, species + ': boxed successfully')
                write('wTempMon', bytes(50))
                result = h.call('GetStorageBoxMon', bc=0x100 | slot)
                check(not result['c_flag'], species + ': stored record decoded')
                mon = h.temp_mon()
                check(mon['idx'] == row['internal_index'] and h.species_index(mon['species']) == row['internal_index'],
                      species + ': high-index storage round trip')
                check(mon['unused'] == shiny_gender, species + ': stored shiny/gender flags')
                check([h.move_index(v) for v in mon['moves'][:2]] ==
                      [con.move_index('EARTHQUAKE'), con.move_index('SLACK_OFF')], species + ': stored moves')
        print(f'HIPPOPOTAS/HIPPOWDON PASSED: {checks} native checks in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
