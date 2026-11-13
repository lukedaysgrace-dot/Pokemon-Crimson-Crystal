#!/usr/bin/env python3
"""Check the native player's legal-move scan and Spite's PP-aware AI score.

Private emulator memory only. Selection checks deliberately start with either
turn holder, as the previous residual phase can leave hBattleTurn on the foe.
"""
from pathlib import Path
import io
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    con = Constants()
    h.boot()
    move_ids = {name: h.move_id(con.moves[name])
                for name in ('SPLASH', 'TACKLE', 'POUND', 'GIGA_HAMMER', 'DOOM_DESIRE')}
    checks = 0
    failures = []

    # name, held item, ability, foe ability, moves, PP, lock, Taunt,
    # Torment, last move, disabled move, must Struggle
    cases = [
        ('status-only Vest', 'ASSAULT_VEST', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH'], [40], '', 0, False, '', '', True),
        ('Vest with an attack', 'ASSAULT_VEST', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], '', 0, False, '', '', False),
        ('Vest attack exhausted with PP Ups', 'ASSAULT_VEST', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 0xc0], '', 0, False, '', '', True),
        ('Vest attack disabled', 'ASSAULT_VEST', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], '', 0, False, '', 'TACKLE', True),
        ('Klutz disables Vest', 'ASSAULT_VEST', 'KLUTZ', 'NO_ABILITY', ['SPLASH'], [40], '', 0, False, '', '', False),
        ('Gas restores Vest', 'ASSAULT_VEST', 'KLUTZ', 'NEUTRALIZING_GAS', ['SPLASH'], [40], '', 0, False, '', '', True),
        ('foe Vest has no effect', 'NO_ITEM', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH'], [40], '', 0, False, '', '', False),
        ('Choice status under Taunt', 'CHOICE_BAND', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], 'SPLASH', 2, False, '', '', True),
        ('Choice attack under Torment', 'CHOICE_SCARF', 'NO_ABILITY', 'NO_ABILITY', ['TACKLE', 'POUND'], [35, 35], 'TACKLE', 0, True, 'TACKLE', '', True),
        ('Choice exhausted lock', 'CHOICE_SPECS', 'NO_ABILITY', 'NO_ABILITY', ['TACKLE', 'POUND'], [0xc0, 35], 'TACKLE', 0, False, '', '', True),
        ('Choice disabled lock', 'CHOICE_BAND', 'NO_ABILITY', 'NO_ABILITY', ['TACKLE', 'POUND'], [35, 35], 'TACKLE', 0, False, '', 'TACKLE', True),
        ('Choice legal attack', 'CHOICE_SCARF', 'NO_ABILITY', 'NO_ABILITY', ['TACKLE', 'SPLASH'], [35, 40], 'TACKLE', 2, False, '', '', False),
        ('Choice before first lock', 'CHOICE_BAND', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], '', 2, False, '', '', False),
        ('Choice overwritten lock', 'CHOICE_BAND', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], 'POUND', 2, False, '', '', False),
        ('Klutz disables Choice', 'CHOICE_BAND', 'KLUTZ', 'NO_ABILITY', ['SPLASH', 'TACKLE'], [40, 35], 'SPLASH', 2, False, '', '', False),
        ('Gas restores Choice', 'CHOICE_BAND', 'KLUTZ', 'NEUTRALIZING_GAS', ['SPLASH', 'TACKLE'], [40, 35], 'SPLASH', 2, False, '', '', True),
        ('Taunt all status', 'NO_ITEM', 'NO_ABILITY', 'NO_ABILITY', ['SPLASH'], [40], '', 2, False, '', '', True),
        ('Torment permits another move', 'NO_ITEM', 'NO_ABILITY', 'NO_ABILITY', ['TACKLE', 'POUND'], [35, 35], '', 0, True, 'TACKLE', '', False),
    ]

    def move(name):
        return move_ids[name] if name else 0

    try:
        for turn in (0, 1):
            for name, item, ability, foe, moves, pp, lock, taunt, torment, last, disabled, expected in cases:
                for symbol, value in {
                    'hBattleTurn': turn,
                    'wPlayerAbility': con.abilities[ability],
                    'wEnemyAbility': con.abilities[foe],
                    'wBattleMonItem': con.items[item],
                    'wEnemyMonItem': con.items['ASSAULT_VEST'],
                    'wPlayerTauntCount': taunt,
                    'wPlayerSubStatus2': 2 if torment else 0,  # SUBSTATUS_TORMENTED
                    'wPlayerChoiceLockedMove': move(lock),
                    'wLastPlayerMove': move(last),
                    'wDisabledMove': move(disabled),
                    'wPlayerGigaHammerLock': 0,
                    'wGameplayRules': 0,
                }.items():
                    h.wr(h.s(symbol), value)
                for symbol in ('wBattleMonHP', 'wEnemyMonHP'):
                    h.wr(h.s(symbol), [0, 100])
                h.wr(h.s('wBattleMonMoves'), [move(m) for m in moves] + [0] * (4 - len(moves)))
                h.wr(h.s('wBattleMonPP'), pp + [0] * (4 - len(pp)))
                result = h.call('PlayerMustStruggleExtra_Core')
                actual = result['c_flag']
                checks += 1
                if actual != expected:
                    failures.append(f'{name}, turn {turn}: Struggle={actual}, expected {expected}; '
                                    f'taunt={h.rd(h.s("wPlayerTauntCount"))}, '
                                    f'moves={list(h.rd(h.s("wBattleMonMoves"), 4))}, result={result}')
                assert h.rd(h.s('hBattleTurn')) == turn, 'turn holder changed'
                assert h.rd(h.s('wPlayerChoiceLockedMove')) == move(lock), 'scan changed Choice lock'

        # A consecutive-use restriction still applies when a Choice item
        # leaves no alternative. Klutz/Gas must change the available choices.
        for turn in (0, 1):
            for attack in ('GIGA_HAMMER', 'DOOM_DESIRE'):
                for item, ability, foe, expected in (
                    ('CHOICE_BAND', 'NO_ABILITY', 'NO_ABILITY', True),
                    ('NO_ITEM', 'NO_ABILITY', 'NO_ABILITY', False),
                    ('CHOICE_BAND', 'KLUTZ', 'NO_ABILITY', False),
                    ('CHOICE_BAND', 'KLUTZ', 'NEUTRALIZING_GAS', True),
                ):
                    for symbol, value in {
                        'hBattleTurn': turn,
                        'wPlayerAbility': con.abilities[ability],
                        'wEnemyAbility': con.abilities[foe],
                        'wBattleMonItem': con.items[item],
                        'wPlayerTauntCount': 0,
                        'wPlayerSubStatus2': 0,
                        'wPlayerChoiceLockedMove': move(attack),
                        'wPlayerGigaHammerLock': move(attack),
                        'wLastPlayerMove': move(attack),
                        'wDisabledMove': 0,
                    }.items():
                        h.wr(h.s(symbol), value)
                    h.wr(h.s('wBattleMonMoves'), [move(attack), move('SPLASH'), 0, 0])
                    h.wr(h.s('wBattleMonPP'), [5, 40, 0, 0])
                    result = h.call('PlayerMustStruggleExtra_Core')
                    checks += 1
                    if result['c_flag'] != expected:
                        failures.append(f'{attack} cooldown {item}/{ability}/{foe}, turn {turn}: '
                                        f'Struggle={result["c_flag"]}, expected {expected}')
                    assert h.rd(h.s('hBattleTurn')) == turn, 'turn holder changed'

        # Spite must value the six PP bits identically for every PP-Up count.
        # A forced high roll makes each score branch deterministic.
        if 'hDebugRNGMode' in h.sym.by_name:
            h.wr(h.s('hDebugActive'), 1)
            h.wr(h.s('hDebugRNGMode'), 1)
            h.wr(h.s('hDebugRNGValue'), 255)
        else:
            # Release uses native RNG; resetting its bytes before each call
            # makes the comparisons paired, without replacing the routine.
            h.wr(h.s('wLinkMode'), 0)
        h.wr(h.s('wLastPlayerCounterMove'), move('TACKLE'))
        h.wr(h.s('wBattleMonMoves'), [move('TACKLE'), 0, 0, 0])
        for pp in (0, 1, 5, 6, 14, 15, 35):
            scores = []
            prepared = io.BytesIO()
            h.pyboy.save_state(prepared)
            for ups in (0, 0x40, 0x80, 0xc0):
                prepared.seek(0)
                h.pyboy.load_state(prepared)
                h.wr(h.s('wBattleMonPP'), pp | ups)
                h.wr(h.s('wBuffer1'), 10)
                for symbol in ('hRandomAdd', 'hRandomSub'):
                    h.wr(h.s(symbol), 0)
                h.call('AI_Smart_Spite', hl=h.s('wBuffer1'))
                scores.append(h.rd(h.s('wBuffer1')))
            checks += 1
            if len(set(scores)) != 1:
                failures.append(f'Spite PP {pp}: PP-Up scores {scores}')
    finally:
        h.pyboy.stop(save=False)
    for failure in failures:
        print('FAIL ' + failure)
    print(f'SELECTION/AI: {checks} checks, {len(failures)} failures in {rom.name}')
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
