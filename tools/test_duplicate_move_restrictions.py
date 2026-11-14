#!/usr/bin/env python3
"""Native duplicate-slot Choice/Disable/Encore controls on both ROMs.

Uses private emulator memory. Text/animations are stubbed for the direct
effect-command calls; selection and PP routines execute unchanged.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def run(rom):
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    ids = {name: h.move_id(con.moves[name]) for name in ('TACKLE', 'POUND', 'STRUGGLE', 'MIMIC', 'SKETCH')}
    failures, checks = [], 0

    def wr(name, value):
        h.wr(h.s(name), value)

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(label)

    def prepare():
        for name in ('wPlayerAbility', 'wEnemyAbility', 'wPlayerTauntCount', 'wEnemyTauntCount',
                     'wPlayerSubStatus2', 'wEnemySubStatus2', 'wPlayerSubStatus5', 'wEnemySubStatus5',
                     'wPlayerGigaHammerLock', 'wEnemyGigaHammerLock', 'wPlayerDisableCount',
                     'wEnemyDisableCount', 'wDisabledMove', 'wEnemyDisabledMove', 'wAttackMissed',
                     'wPlayerEncoreCount', 'wEnemyEncoreCount', 'wBattleWeather', 'wGameplayRules', 'wLinkMode'):
            wr(name, 0)
        for name in ('wBattleMonHP', 'wEnemyMonHP'):
            wr(name, [0, 100])
        for name in ('wBattleMonItem', 'wEnemyMonItem'):
            wr(name, con.items['CHOICE_BAND'])
        for name in ('wBattleMonMoves', 'wEnemyMonMoves'):
            wr(name, [ids['TACKLE'], ids['TACKLE'], ids['POUND'], 0])
        for name in ('wPlayerChoiceLockedMove', 'wEnemyChoiceLockedMove'):
            wr(name, ids['TACKLE'])

    try:
        # Every PP-Up encoding and both duplicate orders. An exhausted
        # first match must not force Struggle when a usable copy remains.
        for ups, pp, disabled, turn in product((0, 0x40, 0x80, 0xc0),
                ((0, 7), (7, 0), (3, 7), (0, 0)), (False, True), (0, 1)):
            prepare()
            values = [pp[0] | ups, pp[1] | ups, 35, 0]
            for name in ('wBattleMonPP', 'wEnemyMonPP'):
                wr(name, values)
            if disabled:
                wr('wDisabledMove', ids['TACKLE'])
                wr('wEnemyDisabledMove', ids['TACKLE'])
            wr('hBattleTurn', 0)
            result = h.call('CheckPlayerChoiceLock_Core', bc=ids['POUND'] << 8)
            usable = bool(any(pp) and not disabled)
            label = f'PP={pp} ups={ups:02x} disabled={disabled} initial-turn={turn}'
            check(result['c_flag'] == usable and result['bc'] >> 8 == ids['POUND' if usable else 'STRUGGLE'], 'player Choice ' + label)
            wr('hBattleTurn', turn)
            result = h.call('PlayerMustStruggleExtra_Core')
            check(result['c_flag'] != usable and h.rd(h.s('hBattleTurn')) == turn, 'player availability ' + label)
            wr('wCurEnemyMove', ids['TACKLE'])
            wr('wCurEnemyMoveNum', 1)
            h.call('HandleEnemyHeldMoveLocks_Core')
            chosen = h.rd(h.s('wCurEnemyMove'))
            slot = h.rd(h.s('wCurEnemyMoveNum'))
            check(chosen == ids['TACKLE' if usable else 'STRUGGLE'] and
                  (not usable or slot == (1 if pp[1] else 0)), 'enemy Choice/slot ' + label)

        # A stale lock releases only when the move disappeared; exhausted
        # duplicates remain a real lock, as checked above.
        prepare()
        for name in ('wBattleMonMoves', 'wEnemyMonMoves'):
            wr(name, [ids['POUND'], ids['POUND'], 0, 0])
        for name in ('wBattleMonPP', 'wEnemyMonPP'):
            wr(name, [0xc0, 7, 0, 0])
        wr('hBattleTurn', 0)
        result = h.call('CheckPlayerChoiceLock_Core', bc=ids['POUND'] << 8)
        check(not result['c_flag'] and h.rd(h.s('wPlayerChoiceLockedMove')) == ids['POUND'], 'player overwritten lock')
        wr('wCurEnemyMove', ids['POUND'])
        wr('wCurEnemyMoveNum', 1)
        h.call('HandleEnemyHeldMoveLocks_Core')
        check(h.rd(h.s('wEnemyChoiceLockedMove')) == ids['POUND'] and h.rd(h.s('wCurEnemyMoveNum')) == 1, 'enemy overwritten lock')

        for name in ('StdBattleTextbox', 'AnimateCurrentMove', 'AnimateFailedMove', 'BattleCommand_MoveDelay'):
            bank, address = h.sym[name]
            h.mem[bank, address] = 0xc9
        # Existing Encore/Disable policy looks up the first matching slot.
        # Verify it explicitly without inventing a different duplicate policy.
        for turn, first, command in product((0, 1), (0xc0, 3), ('Encore', 'Disable')):
            prepare()
            target = 'wEnemy' if turn == 0 else 'wPlayer'
            mon = 'wEnemyMon' if turn == 0 else 'wBattleMon'
            wr(mon + 'PP', [first, 7, 35, 0])
            wr('wLastEnemyMove' if turn == 0 else 'wLastPlayerMove', ids['TACKLE'])
            wr('wLastEnemyCounterMove' if turn == 0 else 'wLastPlayerCounterMove', ids['TACKLE'])
            wr('wEnemyGoesFirst', turn ^ 1)  # target has already acted
            wr('hBattleTurn', turn)
            h.call('BattleCommand_' + command)
            actual = h.rd(h.s(target + ('EncoreCount' if command == 'Encore' else 'DisableCount')))
            expected = (4 if command == 'Encore' else 0x14) if first & 63 else 0
            check(actual == expected, f'{command} first-match policy side={turn} firstPP={first:02x}: {actual} != {expected}')
            check(list(h.rd(h.s(mon + 'PP'), 4)) == [first, 7, 35, 0], f'{command} leaves duplicate PP intact side={turn}')
        # Mimic can really create duplicates and preserves its slot's PP.
        # Sketch explicitly refuses an already-known move instead.
        for turn in (0, 1):
            for command in ('Mimic', 'Sketch'):
                prepare()
                mon = 'wBattleMon' if turn == 0 else 'wEnemyMon'
                foe = 'wEnemyMon' if turn == 0 else 'wBattleMon'
                wr(mon + 'Moves', [ids[command.upper()], ids['TACKLE'], ids['POUND'], 0])
                wr(mon + 'PP', [1, 7, 35, 0])
                wr(foe + 'Moves', [ids['TACKLE']] * 4)
                wr('wCurMoveNum' if turn == 0 else 'wCurEnemyMoveNum', 0)
                wr('wLastEnemyCounterMove' if turn == 0 else 'wLastPlayerCounterMove', ids['TACKLE'])
                wr('wLinkMode', 1 if command == 'Mimic' else 0)
                wr('hBattleTurn', turn)
                h.call('BattleCommand_' + command)
                wanted = ids['TACKLE'] if command == 'Mimic' else ids['SKETCH']
                check(list(h.rd(h.s(mon + 'Moves'), 4)) == [wanted, ids['TACKLE'], ids['POUND'], 0], f'{command} duplicate behavior side={turn}')
                check(list(h.rd(h.s(mon + 'PP'), 4)) == [1, 7, 35, 0], f'{command} preserves separate PP side={turn}')
    finally:
        h.pyboy.stop(save=False)
    for failure in failures:
        print('FAIL', failure)
    print(f'{rom.name}: {checks} checks, {len(failures)} failures', flush=True)
    return len(failures)


if __name__ == '__main__':
    paths = [Path(p) for p in sys.argv[1:]] or [Path(ROOT) / 'pokecrystal.gbc', Path(ROOT) / 'pokecrystal_debug.gbc']
    raise SystemExit(bool(sum(run(path) for path in paths)))
