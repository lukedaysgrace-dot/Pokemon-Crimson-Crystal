#!/usr/bin/env python3
"""Both-ROM native interrupted-action clocks and independent Scale Shot stats.

Only text, ability banners, sleep animation and presentation delays are
replaced with RET in private emulator memory. The real turn, stat, item and
bank-switching code executes; full battles separately verify presentation.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants


def run(rom):
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    effects = _parse_constants(Path(ROOT) / 'constants/move_effect_constants.asm')
    failures, checks = [], 0

    def wr(name, value):
        if name == 'wPlayerDisabledMove':
            name = 'wDisabledMove'
        h.wr(h.s(name), value)

    def disabled_address(side):
        return h.s('wDisabledMove' if side == 'wPlayer' else 'wEnemyDisabledMove')

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(label)

    def prepare(turn):
        wr('wBattleMode', 2)
        wr('wOptions', 0x80)
        for name in ('wPlayerAbility', 'wEnemyAbility', 'wPlayerTauntCount', 'wEnemyTauntCount',
                     'wAttackMissed', 'wEffectFailed', 'wFailedMessage', 'wStatMsgDefer',
                     'wLoweredStat', 'wCurBattleMon', 'wCurOTMon', 'wLinkMode', 'wBattleWeather',
                     'wAIDamagePrediction'):
            wr(name, 0)
        for side in ('wPlayer', 'wEnemy'):
            for index in range(1, 6):
                wr(side + f'SubStatus{index}', 0)
            wr(side + 'StatLevels', [7] * 7)
            wr(side + 'Stats', [0, 100] * 5)
            wr(side + 'DisableCount', 0)
            wr(side + 'DisabledMove', 0)
        for prefix in ('wBattleMon', 'wEnemyMon'):
            wr(prefix + 'Status', 0)
            wr(prefix + 'HP', [0, 100])
            wr(prefix + 'MaxHP', [0, 100])
            wr(prefix + 'Stats', [0, 100] * 5)
            wr(prefix + 'Item', 0)
        wr('hBattleTurn', turn)

    try:
        for name in ('StdBattleTextbox', 'BattleTextbox', 'FarPlayBattleAnimation', 'ShowEnemyAbilityBannerBrief',
                     'ShowAbilityBannerBrief', 'DelayFrames', 'PlayStatChangeAnim_Core'):
            bank, address = h.sym[name]
            h.mem[bank, address] = 0xc9
        tackle = h.move_id(con.moves['TACKLE'])
        splash = h.move_id(con.moves['SPLASH'])
        for turn, interruption, counter in product((0, 1), ('none', 'sleep', 'flinch', 'recharge'), (1, 4)):
            prepare(turn)
            side = 'wPlayer' if turn == 0 else 'wEnemy'
            prefix = 'wBattleMon' if turn == 0 else 'wEnemyMon'
            wr(side + 'DisableCount', 0x20 + counter)
            wr(side + 'DisabledMove', tackle)
            wr('wCurPlayerMove' if turn == 0 else 'wCurEnemyMove', splash)
            if interruption == 'sleep':
                wr(prefix + 'Status', 7)
            elif interruption == 'flinch':
                wr(side + 'SubStatus3', 8)
            elif interruption == 'recharge':
                wr(side + 'SubStatus4', 32)
            h.call('CheckPlayerTurn' if turn == 0 else 'CheckEnemyTurn')
            label = f'Disable side={turn} {interruption} count={counter}'
            expected = 0x20 + counter - 1 if counter > 1 else 0
            check(h.rd(h.s(side + 'DisableCount')) == expected, label + ' duration')
            check(h.rd(disabled_address(side)) == (tackle if counter > 1 else 0), label + ' move')
            check(h.rd(h.s('hBattleTurn')) == turn and h.rd(0xff70) & 7 == 1, label + ' turn/bank')
        growl = h.move_id(con.moves['GROWL'])
        tackle = h.move_id(con.moves['TACKLE'])
        contexts = [('NO_ABILITY', 'PRANKSTER', growl, True, False),
                    ('PRANKSTER', 'PRANKSTER', growl, True, True),
                    ('PRANKSTER', 'NO_ABILITY', growl, True, False),
                    ('PRANKSTER', 'PRANKSTER', tackle, True, False),
                    ('NO_ABILITY', 'PRANKSTER', growl, False, False)]
        for turn, (current, original, selected, dark, blocked) in product((0, 1), contexts):
            prepare(turn)
            side = 'wPlayer' if turn == 0 else 'wEnemy'
            target = 'wEnemyMon' if turn == 0 else 'wBattleMon'
            wr(side + 'Ability', con.abilities[current])
            wr(side + 'MoveStructAnimation', growl)
            wr(side + 'MoveStructCategory', 2)
            wr(side + 'MoveStructType', 0)
            wr(side + 'MoveStructEffect', effects['EFFECT_ATTACK_DOWN'])
            wr(target + 'Type1', 27 if dark else 24)
            wr(target + 'Type2', 27 if dark else 24)
            for suffix, value in (('ActionMove', selected), ('ActionAbility', con.abilities[original])):
                bank, address = h.sym[side + suffix]
                h.mem[bank, address] = value
            result = h.call('AbilityPreHitTargetBlock')
            label = f'Prankster origin side={turn} {original}->{current} selected={selected} Dark={dark}'
            check(result['c_flag'] == blocked, label + ' target immunity')
            check(h.rd(h.s('hBattleTurn')) == turn and h.rd(0xff70) & 7 == 1, label + ' turn/bank')
        for turn, contrary, defense in product((0, 1), (False, True), (1, 7, 13)):
            prepare(turn)
            side = 'wPlayer' if turn == 0 else 'wEnemy'
            wr(side + 'MoveStructEffect', effects['EFFECT_SCALE_SHOT'])
            wr(side + 'Ability', con.abilities['CONTRARY'] if contrary else 0)
            wr(side + 'StatLevels', [7, defense, 7, 7, 7, 7, 7])
            h.call('BattleScaleShotKO_Core')
            actual = list(h.rd(h.s(side + 'StatLevels'), 7))
            expected = [7, min(13, max(1, defense + (1 if contrary else -1))), 6 if contrary else 8, 7, 7, 7, 7]
            label = f'Scale Shot KO side={turn} contrary={contrary} defense={defense}'
            check(actual == expected, label + f' stages={actual}')
            check(h.rd(h.s('wAttackMissed')) == 0 and h.rd(h.s('wEffectFailed')) == 0, label + ' flags')
            check(h.rd(h.s('hBattleTurn')) == turn and h.rd(0xff70) & 7 == 1, label + ' turn/bank')
        for failure in failures:
            print('FAIL', failure)
        print(f'{rom}: {checks} checks, {len(failures)} failures', flush=True)
    finally:
        h.pyboy.stop(save=False)
    return len(failures)


if __name__ == '__main__':
    paths = [Path(p) for p in sys.argv[1:]] or [Path(ROOT) / 'pokecrystal.gbc', Path(ROOT) / 'pokecrystal_debug.gbc']
    raise SystemExit(bool(sum(run(path) for path in paths)))
