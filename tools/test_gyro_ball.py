#!/usr/bin/env python3
"""Check native Gyro Ball against exact speed-ratio powers on both sides."""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    constants = Constants()
    failures, checks = [], 0
    try:
        for name in ('wPlayerAbility', 'wEnemyAbility', 'wBattleMonItem', 'wEnemyMonItem',
                     'wBattleMonStatus', 'wEnemyMonStatus',
                     'wBattleWeather', 'wTrickRoomTimer'):
            h.wr(h.s(name), 0)
        for name in ('wBattleMonHP', 'wEnemyMonHP'):
            h.wr(h.s(name), [0, 100])
        samples = (0, 1, 2, 17, 50, 100, 150, 255, 256, 257, 511, 999, 65535)
        pairs = set(product(samples, repeat=2))
        for speed in range(1, 1000):
            for quotient in (1, 25, 149):
                boundary = (quotient * speed + 24) // 25
                pairs.update((speed, max(0, boundary + delta)) for delta in (-1, 0, 1))
        for turn, (speed, target) in product((0, 1), sorted(pairs)):
            user, other = ('wEnemyMon', 'wBattleMon') if turn else ('wBattleMon', 'wEnemyMon')
            h.wr(h.s('hBattleTurn'), turn)
            h.wr(h.s(user + 'Speed'), speed.to_bytes(2, 'big'))
            h.wr(h.s(other + 'Speed'), target.to_bytes(2, 'big'))
            result = h.call('BattleGyroBall_Core', bc=0x1234, de=0x5678)
            actual = result['de'] >> 8
            expected = min(150, 25 * target // speed + 1) if speed else 1
            if actual != expected:
                failures.append(f'turn {turn}, speeds {speed}/{target}: power {actual}, expected {expected}')
            assert result['bc'] == 0x1234 and result['de'] & 255 == 0x78, 'damage-stat registers corrupted'
            checks += 1
        # Ability/item multipliers apply to the speeds, while Trick Room only
        # changes action order. A paralyzed Quick Feet holder's stored speed
        # has already been halved by the normal status-stat loader.
        scenarios = [
            ('SWIFT_SWIM', 0, 'NO_ITEM', 0, 1, 'NO_ABILITY', 200),
            ('CHLOROPHYLL', 0, 'NO_ITEM', 0, 2, 'NO_ABILITY', 200),
            ('SAND_RUSH', 0, 'NO_ITEM', 0, 3, 'NO_ABILITY', 200),
            ('SLUSH_RUSH', 0, 'NO_ITEM', 0, 4, 'NO_ABILITY', 200),
            ('QUICK_FEET', 16, 'NO_ITEM', 0, 0, 'NO_ABILITY', 150),
            ('QUICK_FEET', 64, 'NO_ITEM', 0, 0, 'NO_ABILITY', 300),
            ('NO_ABILITY', 0, 'CHOICE_SCARF', 0, 0, 'NO_ABILITY', 150),
            ('KLUTZ', 0, 'CHOICE_SCARF', 0, 0, 'NO_ABILITY', 100),
            ('UNBURDEN', 0, 'NO_ITEM', 1, 0, 'NO_ABILITY', 200),
            ('UNBURDEN', 0, 'NO_ITEM', 0, 0, 'NO_ABILITY', 100),
            ('SWIFT_SWIM', 0, 'CHOICE_SCARF', 0, 1, 'NO_ABILITY', 300),
            ('SWIFT_SWIM', 0, 'NO_ITEM', 0, 1, 'NEUTRALIZING_GAS', 100),
            ('SWIFT_SWIM', 0, 'NO_ITEM', 0, 0x81, 'CLOUD_NINE', 100),
            ('SWIFT_SWIM', 0, 'NO_ITEM', 0, 1, 'MOLD_BREAKER', 200),
        ]
        for turn, changed_side, trick_room, scenario in product((0, 1), (0, 1), (0, 5), scenarios):
            ability, status, item, consumed, weather, opponent, effective = scenario
            for side, prefix in enumerate(('wBattleMon', 'wEnemyMon')):
                h.wr(h.s(prefix + 'Speed'), [0, 100])
                h.wr(h.s(prefix + 'Status'), status if side == changed_side else 0)
                h.wr(h.s(prefix + 'Item'), constants.items[item] if side == changed_side else 0)
                side_name = 'wPlayer' if side == 0 else 'wEnemy'
                h.wr(h.s(side_name + 'Ability'), constants.abilities[ability if side == changed_side else opponent])
                h.mem[2, h.s(side_name + 'ItemStateFlags')] = consumed if side == changed_side else 0
            h.wr(h.s('hBattleTurn'), turn)
            h.wr(h.s('wBattleWeather'), weather)
            h.wr(h.s('wTrickRoomTimer'), trick_room)
            user_speed, target_speed = (effective, 100) if changed_side == turn else (100, effective)
            expected = min(150, 25 * target_speed // user_speed + 1)
            result = h.call('BattleGyroBall_Core', bc=0x1234, de=0x5678)
            assert result['de'] >> 8 == expected, (turn, changed_side, trick_room, scenario, result)
            assert result['bc'] == 0x1234 and result['de'] & 255 == 0x78, 'damage-stat registers corrupted'
            assert h.rd(h.s('hBattleTurn')) == turn and h.rd(0xff70) & 7 == 1, 'turn or bank not restored'
            checks += 1
    finally:
        h.pyboy.stop(save=False)
    for failure in failures[:12]:
        print('FAIL', failure)
    print(f'GYRO BALL: {checks} speed-ratio checks, {len(failures)} failures in {rom.name}')
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
