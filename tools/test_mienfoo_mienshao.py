#!/usr/bin/env python3
"""Native family integration checks using a private in-memory cartridge.

Exercise the high species indexes, rules options, evolution boundary, breeding,
reminder and tutor gates, Pokédex flags and weight-based move lookup.
"""
import json
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    types = _parse_constants(root / 'constants/type_constants.asm')
    items = _parse_constants(root / 'constants/item_constants.asm')
    reference = json.loads((root / 'tools/testdata/mienfoo_mienshao.json').read_text())['species']
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def party(species='MIENFOO', level=50, known=('POUND',), item=0, slot=0):
        info = h.build_temp_mon(con.species_index(species),
                                [con.move_index(m) for m in known] + [0] * (4-len(known)),
                                level=level, item=item, statexp=bytes(10), nick='TESTMON@@@@')
        write('wTempMonHP', [0, 100])
        write('wTempMonMaxHP', [0, 100])
        write('wPartyCount', slot+1)
        write('wPartySpecies', [info['sid']] * (slot+1) + [255])
        start = h.s('wPartyMon1') + slot*50
        h.wr(start, h.rd(h.s('wTempMon'), 50))
        for target, source in [('wPartyMonNicknames', 'wTempMonNickname'), ('wPartyMonOT', 'wTempMonOT')]:
            h.wr(h.s(target) + slot*11, h.rd(h.s(source), 11))
        write('wCurPartyMon', slot)
        write('wCurPartyLevel', level)
        write('wCurPartySpecies', info['sid'])
        write('wTempSpecies', info['sid'])
        for name in ('wLinkMode', 'wForceEvolution', 'wBattleMode'):
            write(name, 0)
        return start

    def moves(start):
        return [con.moves_by_index[h.move_index(m)] for m in h.rd(start+2, 4) if m]

    def menu(routine):
        guard = h.s('wMoveReminderMoveListEnd')
        h.wr(guard, 0xa5)
        h.call(routine)
        base = h.s('wMoveReminderMoveList')
        n = h.rd(base)
        data = h.rd(base+1, 2*n+2)
        check(data[-2:] == b'\xff\x00', routine + ': terminator')
        check(h.rd(guard) == 0xa5, routine + ': buffer overrun')
        return [con.moves_by_index[(data[2*i] << 8) | data[2*i+1]] for i in range(n)]

    presentation = {name: b'\xc9' for name in (
        'PrintText', 'PrintTextboxText', 'DelayFrames', 'ClearSprites', 'ClearTileMap',
        'PlayMusic', 'PlaySFX', 'WaitSFX', 'RestartMapMusic', 'LearnLevelMoves')}
    presentation['EvolutionAnimation'] = b'\xaf\xc9'
    try:
        for species, row in reference.items():
            sid = h.species_id(con.species_index(species))
            check(con.species_index(species) == row['internal_index'], species + ': stable internal ID')
            for rules in range(8):
                write('wGameplayRules', rules)
                write('wCurSpecies', sid)
                h.call('GetBaseData')
                expected_stats = row['stats'] if rules & 2 else row['enhanced_stats']
                expected_types = row['original_types'] if rules & 1 else row['enhanced_types']
                check(list(h.rd(h.s('wBaseStats'), 6)) == expected_stats, species + ': rules stats')
                check(list(h.rd(h.s('wBaseType1'), 2)) == [types[t] for t in expected_types], species + ': rules typing')
                check(list(h.rd(h.s('wBaseAbilities'), 3)) ==
                      [con.abilities[a] for a in ('SERENE_GRACE', 'REGENERATOR', 'RECKLESS')], species + ': ability slots')
            check(h.rd(h.s('wBaseCatchRate')) == row['catch_rate'], species + ': catch rate')
            check(h.rd(h.s('wBaseExp')) == row['base_exp'], species + ': experience yield')
            check(h.rd(h.s('wBaseGender')) == 127, species + ': equal gender ratio')
            check(h.rd(h.s('wBaseEggGroups')) == 0x58, species + ': Field/Human-Like egg groups')
            check(h.rd(h.s('wBaseGrowthRate')) == 3, species + ': Medium Slow growth')
            check(h.rd(h.s('wBaseEggSteps')) == 25, species + ': hatch cycles')
            check(h.call('GetRegionalDexNumber_DE', de=con.species_index(species))['hl'] == row['regional_dex'],
                  species + ': regional number')
            check(h.call('GetSpeciesWeightHG', a=sid)['hl'] == (200 if species == 'MIENFOO' else 355),
                  species + ': Low Kick/Grass Knot weight')
            # The two species fit in the existing 63-byte flags: no save-layout change.
            for table in ('wPokedexCaught', 'wPokedexSeen'):
                write(table, bytes(63))
            h.call('SetSeenAndCaughtMon', a=sid)
            bit = con.species_index(species)-1
            for table in ('wPokedexCaught', 'wPokedexSeen'):
                flags = h.rd(h.s(table), 63)
                check(flags[bit//8] == 1 << (bit%8) and sum(v.bit_count() for v in flags) == 1,
                      species + ': high-index ' + table)
            party(species, level=100)
            taught = menu('EggMoveTutor_GetTeachableMoves')
            check(set(taught) == set(row['egg_moves']) | set(row['technical_tutor']), species + ': family tutor')
            check('CLOSE_COMBAT' in taught and 'GRASS_KNOT' in taught, species + ': coverage access')
            check(('BLAZE_KICK' in taught) == (species == 'MIENSHAO'), species + ': evolved-only coverage')
            for move in row['tmhm']:
                write('wPutativeTMHMMove', h.move_id(con.move_index(move)))
                check(h.call('CanLearnTMHMMove')['c'] != 0, species + ': machine ' + move)
        write('wGameplayRules', 0)
        # Fairy progression is shared by both forms and both typing modes.
        for rules in (0, 1):
            write('wGameplayRules', rules)
            for species in reference:
                for level in (6, 7, 31, 32, 47, 48):
                    party(species, level=level)
                    reminders = menu('MoveReminder_GetRemindableMoves')
                    for move, gate in [('PIXIE_PUNCH', 7), ('PLAY_ROUGH', 32), ('SPIRIT_BREAK', 48)]:
                        check((move in reminders) == (level >= gate), f'{species}: {move} level {level}, rules {rules}')
        write('wGameplayRules', 0)
        for level in (11, 12, 24, 25, 29, 30, 34, 35):
            party(level=level)
            reminders = menu('MoveReminder_GetRemindableMoves')
            for move, gate in [('LOW_KICK', 12), ('FORCE_PALM', 25), ('U_TURN', 30), ('DRAIN_PUNCH', 35)]:
                check((move in reminders) == (level >= gate), f'{move}: reminder level {level}')
        # The mature parent must produce Mienfoo and use its root egg list.
        for parent_slot in (0, 1):
            baby = h.species_id(con.species_index('MIENFOO'))
            grown = h.species_id(con.species_index('MIENSHAO'))
            ditto = h.species_id(con.species_index('DITTO'))
            write('wEggMonSpecies', baby)
            write('wCurPartySpecies', baby)
            write('wBreedMon1Species', grown if parent_slot == 0 else ditto)
            write('wBreedMon2Species', ditto if parent_slot == 0 else grown)
            write('wBreedMotherOrNonDitto', parent_slot)
            write('wEggMonMoves', [0]*4)
            write('wEggMonPP', [0]*4)
            for slot in (0, 1):
                write(f'wBreedMon{slot+1}Moves',
                      [h.move_id(con.move_index('VITAL_THROW')), 0, 0, 0] if slot == parent_slot else [0]*4)
            h.call('InitEggMoves')
            check([con.moves_by_index[h.move_index(m)] for m in h.rd(h.s('wEggMonMoves'), 4) if m] == ['VITAL_THROW'],
                  'Mienshao family egg inheritance in parent slot ' + str(parent_slot))
        with patches(h, presentation):
            for level, slot in [(50, 0), (51, 0), (70, 2), (100, 0)]:
                start = party(level=level, slot=slot, known=('U_TURN', 'DRAIN_PUNCH'))
                h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(start)) == con.species_index('MIENSHAO'), f'evolution at {level}')
                check(moves(start) == ['U_TURN', 'DRAIN_PUNCH'], 'evolution preserves known moves')
            for level, item, cancel in [(49, 0, False), (50, items['EVERSTONE'], False), (50, 0, True)]:
                start = party(level=level, item=item)
                with patches(h, {'EvolutionAnimation': b'\x37\xc9'} if cancel else {}):
                    h.call('EvolvePokemon', max_frames=300)
                check(h.species_index(h.rd(start)) == con.species_index('MIENFOO'), 'blocked evolution')
        print(f'MIENFOO/MIENSHAO PASSED: {checks} native checks in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
