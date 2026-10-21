#!/usr/bin/env python3
"""Test new move timing, tutor filtering and compatible breeding in the ROM."""
from pathlib import Path
import sys

from audit_trainer_move_access import audit
from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def main():
    receipt = audit()
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT)/'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        assert condition, message

    def party(species, level=100, known=()):
        sid = h.species_id(con.species_index(species))
        h.wr(h.s('wPartyCount'), 1)
        h.wr(h.s('wCurPartyMon'), 0)
        h.wr(h.s('wPartySpecies'), [sid, 255])
        h.wr(h.s('wPartyMon1Species'), sid)
        h.wr(h.s('wPartyMon1Level'), level)
        h.wr(h.s('wCurPartyLevel'), level)
        h.wr(h.s('wCurPartySpecies'), sid)
        h.wr(h.s('wEvolutionOldSpecies'), 0)
        ids = [h.move_id(con.move_index(m)) for m in known]
        h.wr(h.s('wPartyMon1Moves'), ids+[0]*(4-len(ids)))

    def menu(routine):
        h.call(routine)
        base = h.s('wMoveReminderMoveList')
        n = h.rd(base)
        raw = h.rd(base+1, n*2+2)
        check(raw[-2:] == b'\xff\x00', routine+' terminator')
        return [con.moves_by_index[(raw[i*2]<<8)|raw[i*2+1]] for i in range(n)]

    try:
        for species, moves in receipt['level_up'].items():
            for move, level in moves.items():
                for lv, wanted in [(level-1, False), (level, True)]:
                    party(species, lv)
                    h.call('FillMoves', de=h.s('wPartyMon1Moves'))
                    actual = [con.moves_by_index[h.move_index(mid)]
                              for mid in h.rd(h.s('wPartyMon1Moves'), 4) if mid]
                    check((move in actual) == wanted, f'{species} {move}: natural timing at {lv}')
                party(species, level)
                check(move in menu('MoveReminder_GetRemindableMoves'), species+' reminder '+move)
        print('New natural moves: exact unlock levels and reminder recovery passed.', flush=True)

        for species, moves in receipt['technical_tutor'].items():
            for move in moves:
                party(species, 1)
                check(move in menu('EggMoveTutor_GetTeachableMoves'), species+' Blackthorn '+move)
                check(move not in menu('UtilityMoveTutor_GetTeachableMoves'), species+' Goldenrod isolation')
                party(species, 1, (move,))
                check(move not in menu('EggMoveTutor_GetTeachableMoves'), species+' known tutor move omitted')
        print('Custom tutor moves: Blackthorn access and known-move filtering passed.', flush=True)

        for baby, moves in receipt['egg_moves'].items():
            for move, donor in moves.items():
                for mother_slot in [0, 1]:
                    parents = [donor['mother'], donor['father']]
                    if mother_slot:
                        parents.reverse()
                    ids = [h.species_id(con.species_index(c)) for c in [baby]+parents]
                    mid = h.move_id(con.move_index(move))
                    h.wr(h.s('wBreedMotherOrNonDitto'), mother_slot)
                    for slot in [0, 1]:
                        p = f'wBreedMon{slot+1}'
                        h.wr(h.s(p+'Species'), ids[slot+1])
                        h.wr(h.s(p+'PokerusStatus'), 0 if slot == mother_slot else 0x40)
                        h.wr(h.s(p+'Moves'), [0]*4 if slot == mother_slot else [mid, 0, 0, 0])
                    h.call('CheckBreedmonCompatibility')
                    check(h.rd(h.s('wBreedingCompatibility')) > 0, baby+' real compatible parents')
                    h.wr(h.s('wEggMonSpecies'), ids[0])
                    h.wr(h.s('wCurPartySpecies'), ids[0])
                    h.wr(h.s('wEggMonMoves'), [0]*4)
                    h.wr(h.s('wEggMonPP'), [0]*4)
                    h.call('InitEggMoves')
                    check(h.rd(h.s('wEggMonMoves'), 4) == bytes([mid, 0, 0, 0]), baby+' donor inheritance')
                    check(h.rd(h.s('wEggMonPP')) > 0, baby+' inherited move PP')
                party(baby, 1)
                check(move in menu('EggMoveTutor_GetTeachableMoves'), baby+' family egg tutor access')
        print(f'TRAINER MOVE ACCESS ROM TESTS PASSED: {checks} checks, {h.calls} routine calls.', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
