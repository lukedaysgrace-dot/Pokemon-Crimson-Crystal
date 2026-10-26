#!/usr/bin/env python3
"""Native Avalanche hit-history, bank restoration and damage-boundary checks."""
from itertools import product
from pathlib import Path
import sys

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    effects = _parse_constants(Path(ROOT) / 'constants/move_effect_constants.asm')
    checks = 0
    try:
        for turn, opponent_first, category, other_category, damage in product(
                (0, 1), (False, True), (0, 1, 2), (0, 2), (1, 60, 255, 300, 32767, 32768, 65535)):
            h.wr(0xff70, 1)
            h.wr(h.s('hBattleTurn'), turn)
            h.wr(h.s('wEnemyGoesFirst'), turn ^ int(opponent_first))
            user, other = ('wEnemy', 'wPlayer') if turn else ('wPlayer', 'wEnemy')
            h.wr(h.s(user + 'MoveStructEffect'), effects['EFFECT_AVALANCHE'])
            h.mem[2, h.s(user + 'CounterHitCategory')] = category
            h.mem[2, h.s(other + 'CounterHitCategory')] = other_category
            # A last-used move is insufficient evidence of damage.
            h.wr(h.s('wLastPlayerCounterMove'), 1)
            h.wr(h.s('wLastEnemyCounterMove'), 1)
            h.wr(h.s('wCurDamage'), damage.to_bytes(2, 'big'))
            h.call('BattleConditionalBoost_Core')
            expected = min(65535, damage * 2) if opponent_first and category else damage
            actual = int.from_bytes(h.rd(h.s('wCurDamage'), 2), 'big')
            assert actual == expected, (turn, opponent_first, category, other_category, damage, actual, expected)
            assert h.rd(0xff70) & 7 == 1, 'WRAM bank was not restored'
            assert h.mem[2, h.s(user + 'CounterHitCategory')] == category, 'hit history was modified'
            checks += 1
    finally:
        h.pyboy.stop(save=False)
    print(f'AVALANCHE: {checks} native hit-history and damage-boundary cases passed in {rom.name}')


if __name__ == '__main__':
    main()
