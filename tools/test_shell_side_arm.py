#!/usr/bin/env python3
"""Check native Shell Side Arm category selection and conditional contact.

Uses private emulator memory and accepts a ROM path for before/after checks.
No player saves or cartridge sidecars are opened.
"""
from itertools import product
from pathlib import Path
import random
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import _parse_constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    cases = [
        # Physical wins before halving, but the old routine rounds to a tie.
        (257, 256, 256, 256),
        # Rounding can reverse either result, even when every stat is nonzero.
        (256, 257, 259, 260),
        (257, 256, 260, 259),
        (999, 999, 999, 999),
    ]
    cases += list(product((1, 255, 256, 257, 511, 512, 999), repeat=4))
    rng = random.Random(0x534841)
    cases += [tuple(rng.randint(1, 999) for _ in range(4)) for _ in range(512)]
    effects = _parse_constants(Path(ROOT) / 'constants/move_effect_constants.asm')
    moves = _parse_constants(Path(ROOT) / 'constants/move_constants.asm')
    failures, checks = [], 0
    try:
        for turn, (user, target) in enumerate((('wBattleMon', 'wEnemyMon'), ('wEnemyMon', 'wBattleMon'))):
            h.wr(h.s('hBattleTurn'), turn)
            for atk, spa, defense, spdef in cases:
                for name, value in ((user + 'Attack', atk), (user + 'SpclAtk', spa),
                                    (target + 'Defense', defense), (target + 'SpclDef', spdef)):
                    h.wr(h.s(name), value.to_bytes(2, 'big'))
                h.call('BattleShellSideArm_Core')
                category = h.rd(h.s('wPlayerMoveStructCategory' if turn == 0 else 'wEnemyMoveStructCategory'))
                expected = 0 if atk * spdef > spa * defense else 1
                checks += 1
                if category != expected:
                    failures.append(f'turn {turn}, stats {(atk, spa, defense, spdef)}: category {category}, expected {expected}')
                assert h.rd(h.s('wCurDamage'), 2) == b'\0\0', 'damage scratch was not cleared'
        # The AI reuses this selector while its six scores occupy the scratch
        # bytes. Verify the wrapper still returns the category and restores them.
        h.wr(h.s('hBattleTurn'), 1)
        h.wr(h.s('wEnemyMoveStructEffect'), effects['EFFECT_SHELL_SIDE_ARM'])
        for atk, spa, defense, spdef in cases[:4]:
            for name, value in (('wEnemyMonAttack', atk), ('wEnemyMonSpclAtk', spa),
                                ('wBattleMonDefense', defense), ('wBattleMonSpclDef', spdef)):
                h.wr(h.s(name), value.to_bytes(2, 'big'))
            scores = bytes([19, 23, 29, 31, 37, 41])
            h.wr(h.s('wBuffer1'), scores)
            h.call('AIPredictVariableMoveCategory_Core')
            expected = 0 if atk * spdef > spa * defense else 1
            assert h.rd(h.s('wEnemyMoveStructCategory')) == expected, 'AI category mismatch'
            assert h.rd(h.s('wBuffer1'), 6) == scores, 'AI move scores were corrupted'
            checks += 1
        for turn, category in product((0, 1), (0, 1)):
            h.wr(h.s('hBattleTurn'), turn)
            user, other = ('wEnemy', 'wPlayer') if turn else ('wPlayer', 'wEnemy')
            h.wr(h.s(user + 'MoveStructCategory'), category)
            h.wr(h.s(other + 'MoveStructCategory'), 1 - category)
            for move, expected in (('SHELLSIDEARM', category == 0), ('TACKLE', True),
                                   ('WATER_GUN', False), ('NO_MOVE', False)):
                runtime_id = h.move_id(moves[move]) if move != 'NO_MOVE' else 0
                h.wr(h.s(user + 'MoveStructAnimation'), runtime_id)
                for routine in ('CheckContactMove', 'CheckContactMoveID'):
                    registers = dict(bc=0x1200 | runtime_id, de=0x4567, hl=0xabcd)
                    result = h.call(routine, **registers)
                    assert result['c_flag'] == expected, (routine, turn, category, move)
                    assert all(result[name] == value for name, value in registers.items()), 'contact check clobbered registers'
                    checks += 1
    finally:
        h.pyboy.stop(save=False)
    for failure in failures[:12]:
        print('FAIL', failure)
    print(f'Shell Side Arm: {checks} native category/contact checks, {len(failures)} failures')
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
