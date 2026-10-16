#!/usr/bin/env python3
"""Check the compiled Wide Lens multiplier across every accuracy byte.

Runs both battlers, no-item controls, Klutz, and Gas suppressing Klutz.
The YAML cases exercise the same hook through full native move execution.
"""
from probability_checks import call
from runner import Harness
from symbols import STATE_WAIT


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    h.load_fixture()
    checks = 0
    try:
        assert h.con.item_id('WIDE_LENS') == 0xaa
        assert h.con.item_id('PINK_BOW') == 0x68
        assert h.con.item_id('MUSCLE_BAND') == 0xab
        scenarios = [
            ('NO_ITEM', 'NO_ABILITY', 'NO_ABILITY', False),
            ('WIDE_LENS', 'NO_ABILITY', 'NO_ABILITY', True),
            ('WIDE_LENS', 'KLUTZ', 'NO_ABILITY', False),
            ('WIDE_LENS', 'KLUTZ', 'NEUTRALIZING_GAS', True),
        ]
        for direction in (0, 1):
            for item, ability, opponent_ability, boosted in scenarios:
                holder = dict(species='MEW', level=50, ability=ability,
                              item=item, moves=['FIRE_BLAST'])
                opponent = dict(species='SNORLAX', level=100,
                                ability=opponent_ability, moves=['SPLASH'])
                test = dict(player=opponent if direction else holder,
                            enemy=holder if direction else opponent,
                            rng='forced_low', turns=0)
                h.load_fixture()
                assert h.run_battle(test) == STATE_WAIT
                m = h.battle.mem
                m.write('hBattleTurn', direction)
                move = 'wCurEnemyMove' if direction else 'wCurPlayerMove'
                moves = 'wEnemyMonMoves' if direction else 'wBattleMonMoves'
                m.write(move, m.read(moves))
                call(h, 'UpdateMoveData')
                held = 'wEnemyMonItem' if direction else 'wBattleMonItem'
                for chance in range(256):
                    call(h, 'ApplyWideLensAccuracy_Core', B=chance, C=73)
                    actual = h.pb.register_file.B
                    expected = min(255, chance * 110 // 100) if boosted else chance
                    assert actual == expected, (
                        direction, item, ability, opponent_ability,
                        chance, actual, expected)
                    assert h.pb.register_file.C == 73
                    assert m.read(held) == h.con.item_id(item)
                    checks += 1
                print(f'PASS side={direction} {item} {ability}/{opponent_ability}',
                      flush=True)
        print(f'{checks} native accuracy checks passed; item IDs preserved.')
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
