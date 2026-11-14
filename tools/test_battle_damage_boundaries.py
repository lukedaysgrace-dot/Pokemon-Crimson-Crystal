#!/usr/bin/env python3
"""Independent integer oracles against native damage arithmetic on both ROMs.

Private emulator memory only. No damage routine is replaced or simulated.
Inputs to the base formula are its already-truncated byte-sized stats.
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
        h.wr(h.s(name), value)

    def damage():
        return int.from_bytes(h.rd(h.s('wCurDamage'), 2), 'big')

    def check(actual, expected, label):
        nonlocal checks
        checks += 1
        if actual != expected:
            failures.append(f'{label}: got {actual}, expected {expected}')

    try:
        for name in ('wPlayerAbility', 'wEnemyAbility', 'wBattleMonItem', 'wEnemyMonItem',
                     'wPlayerGlaiveRush', 'wEnemyGlaiveRush', 'wBattleWeather',
                     'wSelfdestructGasTurn', 'wAIDamagePrediction'):
            wr(name, 0)
        h.call('InitializeItemIndexTable')
        for name in ('wBattleMonHP', 'wEnemyMonHP'):
            wr(name, [0, 100])
        bank, address = h.sym['wParentalBondState']
        h.mem[bank, address] = 0
        # All combinations of these boundary values, not a second copy of
        # the assembly's multiplication/division sequence.
        for turn, level, power, attack, defense in product(
                (0, 1), (1, 50, 100), (1, 40, 150, 250), (1, 2, 127, 255), (1, 2, 127, 255)):
            wr('hBattleTurn', turn)
            wr('wPlayerMoveStructEffect' if turn == 0 else 'wEnemyMoveStructEffect', effects['EFFECT_NORMAL_HIT'])
            wr('wCurDamage', [0, 0])
            h.call('BattleCommand_DamageCalc', bc=attack * 256 + defense, de=power * 256 + level)
            expected = min(997, ((2 * level // 5 + 2) * power * attack // defense) // 50) + 2
            check(damage(), expected, f'base side={turn} L/P/A/D={level}/{power}/{attack}/{defense}')
            check(h.rd(0xff70) & 7, 1, 'base WRAM bank')
        # A sequence of boosts may exceed 16 bits before HP application.
        # Every increasing damage helper must saturate, rather than wrap.
        for turn, value, percent in product(
                (0, 1), (0, 1, 2, 255, 256, 999, 26968, 32767, 32768, 43690, 50412, 53936, 65535),
                (33, 100, 110, 120, 130, 133, 150, 200)):
            wr('hBattleTurn', turn)
            wr('wCurDamage', value.to_bytes(2, 'big'))
            result = h.call('DamagePercent', a=percent, bc=0x1234, de=0x5678, hl=0xabcd)
            expected = min(65535, max(1, value * percent // 100)) if value else 0
            check(damage(), expected, f'percent side={turn} {value}*{percent}%')
            check((result['bc'], result['de'], result['hl']), (0x1234, 0x5678, 0xabcd), 'percent registers')
            check(h.rd(h.s('hBattleTurn')), turn, 'percent turn')
        # Full native modifier dispatch, rather than only arithmetic helpers.
        # 26968 is the capped base after Glaive Rush, sun, crit, STAB and 4x
        # effectiveness. Metronome x2 followed by Tough Claws x1.3 overflows.
        fire_punch = h.move_id(con.moves['FIRE_PUNCH'])
        water_gun = h.move_id(con.moves['WATER_GUN'])
        metronome = h.call('GetItemIDFromIndex', hl=con.items['METRONOME_ITEM'])['a']
        for turn in (0, 1):
            actor = 'wPlayer' if turn == 0 else 'wEnemy'
            target = 'wEnemy' if turn == 0 else 'wPlayer'
            user = 'wBattleMon' if turn == 0 else 'wEnemyMon'
            wr('hBattleTurn', turn)
            wr(actor + 'Ability', con.abilities['TOUGH_CLAWS'])
            wr(target + 'Ability', 0)
            wr(user + 'Item', metronome)
            wr(actor + 'MetronomeCount', 5)
            wr(actor + 'MoveStructAnimation', fire_punch)
            wr(actor + 'MoveStructCategory', 0)
            wr(actor + 'MoveStructType', 20)
            wr('wTypeModifier', 40)
            wr('wCurDamage', (26968).to_bytes(2, 'big'))
            h.call('RunDamageModifiers')
            check(damage(), 65535, f'stacked Metronome/Tough Claws side={turn}')
            wr(user + 'Item', 0)
            wr(actor + 'Ability', con.abilities['MEGA_SOL'])
            wr(actor + 'MoveStructAnimation', water_gun)
            wr(actor + 'MoveStructCategory', 1)
            wr(actor + 'MoveStructType', 21)
            wr('wBattleWeather', 1)
            wr('wTypeModifier', 10)
            wr('wCurDamage', [0, 3])
            h.call('RunDamageModifiers')
            check(damage(), 1, f'Mega Sol low-power Water in rain side={turn}')
            wr('wBattleWeather', 0)
        # Long chains are possible with PP recovery. The third-use power
        # remains capped thereafter; neither the counter nor Technician may
        # restart on use 256. Execute the real command for every use.
        for turn in (0, 1):
            side = 'wPlayer' if turn == 0 else 'wEnemy'
            wr('hBattleTurn', turn)
            wr(side + 'MoveStructEffect', effects['EFFECT_FURY_CUTTER'])
            wr(side + 'FuryCutterCount', 0)
            wr('wAttackMissed', 0)
            h.mem[h.sym['wDamageCalcBasePower'][0], h.s('wDamageCalcBasePower')] = 40
            for use in range(1, 301):
                wr('wCurDamage', [0, 10])
                result = h.call('TechnicianBoostsCurrentHit')
                check(result['c_flag'], use == 1, f'Fury Cutter Technician side={turn} use={use}')
                h.call('BattleCommand_FuryCutter')
                check(damage(), 10 * (1 << min(use - 1, 2)), f'Fury Cutter power side={turn} use={use}')
        print(f'{rom}: {checks} checks, {len(failures)} failures', flush=True)
        for failure in failures:
            print('FAIL', failure)
    finally:
        h.pyboy.stop(save=False)
    return len(failures)


if __name__ == '__main__':
    paths = [Path(p) for p in sys.argv[1:]] or [Path(ROOT) / 'pokecrystal.gbc', Path(ROOT) / 'pokecrystal_debug.gbc']
    raise SystemExit(bool(sum(run(path) for path in paths)))
