#!/usr/bin/env python3
"""Native unique-form, breeding, escape and v5 PC codec regressions.

Uses an in-memory cartridge; no player saves or emulator sidecars are read.
"""
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
    battle = _parse_constants(root / 'constants/battle_constants.asm')
    checks = 0

    def check(ok, label):
        nonlocal checks
        checks += 1
        assert ok, label

    def write(name, value): h.wr(h.s(name), value)
    def read(name, size=1): return h.rd(h.s(name), size)
    def move_names(values):
        return [con.moves_by_index[h.move_index(v)] for v in values if v]

    try:
        ordinary = h.species_id(con.species_index('ZANGOOSE'))
        scarred = h.species_id(con.species_index('ZANGOOSE_SCARRED'))
        ditto = h.species_id(con.species_index('DITTO'))
        dire = h.move_id(con.move_index('DIRE_CLAW'))
        for rules in range(8):
            write('wGameplayRules', rules)
            for sid, expected in [(ordinary, [types['NORMAL']] * 2),
                                  (scarred, [types['NORMAL'], types['POISON']])]:
                write('wCurSpecies', sid)
                h.call('GetBaseData')
                check(list(read('wBaseType1', 2)) == expected, f'typing: {sid}, rules {rules}')
                stats = read('wBaseStats', 6)
                if sid == ordinary:
                    ordinary_stats = stats
                else:
                    check(stats == ordinary_stats, 'form changes typing without changing stats')
        check(h.call('NormalizeRetiredRosterIndexDE', de=con.species_index('ZANGOOSE_SCARRED'))['de'] ==
              con.species_index('ZANGOOSE_SCARRED'), 'save ingress preserves special form')
        check(h.call('ValidateTempWildMonSpecies', hl=con.species_index('ZANGOOSE_SCARRED'))['c_flag'],
              'form excluded from ordinary wild selection')
        check(not h.call('ValidateTempWildMonSpecies', hl=con.species_index('ZANGOOSE'))['c_flag'],
              'ordinary Zangoose remains a valid wild species')

        for sid in (ordinary, scarred):
            for level in (1, 49, 50, 100):
                write('wCurPartySpecies', sid)
                write('wCurPartyLevel', level)
                write('wEvolutionOldSpecies', 0)
                write('wEnemyMonMoves', [0] * 4)
                write('wBuffer1', 0)
                h.call('FillMoves', de=h.s('wEnemyMonMoves'))
                check('DIRE_CLAW' not in move_names(read('wEnemyMonMoves', 4)),
                      'Dire Claw excluded from natural move generation')
            before = read('wEnemyMonMoves', 4)
            write('wEnemyMonSpecies', sid)
            h.call('SetScarredZangooseEncounterMove')
            moves = read('wEnemyMonMoves', 4)
            check(moves == (bytes([dire]) + before[1:] if sid == scarred else before),
                  'encounter move applied only to special individual')

        for sid in (ordinary, scarred):
            h.build_temp_mon(h.species_index(sid), [con.move_index('SCRATCH'), 0, 0, 0], level=100)
            write('wPartyCount', 1)
            write('wPartySpecies', [sid, 255])
            write('wPartyMon1', read('wTempMon', 50))
            write('wCurPartyMon', 0)
            write('wCurPartySpecies', sid)
            write('wCurPartyLevel', 100)
            for routine in ('MoveReminder_GetRemindableMoves', 'EggMoveTutor_GetTeachableMoves'):
                h.call(routine)
                count = read('wMoveReminderMoveList')
                data = h.rd(h.s('wMoveReminderMoveList') + 1, count * 2)
                check(con.move_index('DIRE_CLAW') not in
                      [int.from_bytes(data[i:i+2], 'big') for i in range(0, len(data), 2)],
                      routine + ': Dire Claw unavailable')

        write('wCurPartySpecies', scarred)
        h.call('GetLowestEvolutionStage')
        check(read('wCurPartySpecies') == ordinary, 'special form produces ordinary offspring')
        for other in (ordinary, ditto, scarred):
            for parent in (0, 1):
                write('wBreedMon1Species', scarred if parent == 0 else other)
                write('wBreedMon2Species', other if parent == 0 else scarred)
                write('wBreedMon1Moves', [dire, 0, 0, 0])
                write('wBreedMon2Moves', [dire, 0, 0, 0])
                write('wBreedMotherOrNonDitto', parent)
                write('wEggMonSpecies', ordinary)
                write('wEggMonMoves', [0] * 4)
                h.call('InitEggMoves')
                check(dire not in read('wEggMonMoves', 4), 'Dire Claw cannot pass through either parent')

        write('wCurBox', 0)
        h.call('InitializeBoxes')
        h.call('ClearBackupBoxes')
        for slot, species in enumerate(('ZANGOOSE', 'ZANGOOSE_SCARRED'), 1):
            index = con.species_index(species)
            h.build_temp_mon(index, [con.move_index('DIRE_CLAW'), con.move_index('CRUSH_CLAW'), 0, 0],
                             level=50, shiny_gender=0xc0)
            check(h.call('AddTempMonToStorage')['a'] == 0, 'form can be boxed')
            write('wTempMon', bytes(50))
            check(not h.call('GetStorageBoxMon', bc=0x100 | slot)['c_flag'], 'form decodes from PC')
            mon = h.temp_mon()
            check(mon['idx'] == index and h.species_index(mon['species']) == index,
                  'PC round trip preserves exact species/form')
            check(h.move_index(mon['moves'][0]) == con.move_index('DIRE_CLAW'), 'PC preserves encounter move')
            check(mon['unused'] == 0xc0, 'PC preserves shiny and gender')

        for table in ('wPokedexCaught', 'wPokedexSeen'): write(table, bytes(63))
        h.call('SetSeenAndCaughtMon', a=scarred)
        bit = con.species_index('ZANGOOSE') - 1
        for table in ('wPokedexCaught', 'wPokedexSeen'):
            flags = read(table, 63)
            check(flags[bit // 8] == 1 << (bit % 8) and sum(x.bit_count() for x in flags) == 1,
                  'form registers only ordinary Zangoose Dex identity')
        expected = h.call('GetRegionalDexNumber_DE', de=con.species_index('ZANGOOSE'))['hl']
        check(h.call('GetRegionalDexNumber_DE', de=con.species_index('ZANGOOSE_SCARRED'))['hl'] == expected,
              'form shares regional Dex number')
        check(h.s('wCurBox') - h.s('wGameData') == 0x6f3, 'v5 save offsets preserved')
        with patches(h, {'StdBattleTextbox': b'\xc9', 'WontHaveAnyEffect_NotUsedMessage': b'\xc9'}):
            write('wBattleType', battle['BATTLETYPE_FOREST_RIVALRY'])
            write('wBattleMode', 1)
            write('wBattleMonType1', types['GHOST'])
            write('wBattleMonType2', types['GHOST'])
            write('wFailedToFlee', 0)
            check(not h.call('DebugTryToRunAwayFromBattle')['c_flag'] and read('wFailedToFlee'),
                  'even Ghost cannot run')
            write('wItemEffectSucceeded', 1)
            write('wForcedSwitch', 0)
            h.call('PokeDollEffect')
            check(read('wForcedSwitch') == 0, 'Poke Doll cannot escape')

        print(f'FOREST RIVALRY: {checks} native checks passed in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__': main()
