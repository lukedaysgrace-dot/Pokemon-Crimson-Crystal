#!/usr/bin/env python3
"""Choose Fight through native menus with intersecting move restrictions.

The party and restriction state are private emulator fixtures. After the first
Fight menu appears, ordinary buttons must execute Struggle or the selected
legal move. No automatic debug action or direct move call is used.
"""

import argparse
import json
from pathlib import Path

from probability_checks import call
from runner import Harness
from save_menu_checks import begin_native_call
from state import Request
from symbols import ROOT, STATE_ERROR
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--rom', type=Path)
    parser.add_argument('--duplicates-only', action='store_true')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/move-restriction-menu')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom)
    h.ensure_fixture()
    state = {}

    def fight_menu(_):
        h.pb.button_release('a')
        state['pending'] = True
        state['menus'] += 1
        if state['menus'] != 1:
            return
        m, case = h.battle.mem, state['case']
        # Apply fixture state after entry, before the native Fight selection.
        m.write('wPlayerAbility', h.con.ability_id(case.get('ability', 'NO_ABILITY')))
        m.write('wEnemyAbility', h.con.ability_id('NO_ABILITY'))
        m.write('wPlayerTauntCount', 3 if case.get('taunt') else 0)
        if case.get('lock'):
            m.write('wPlayerChoiceLockedMove', m.read('wBattleMonMoves', case['lock'] - 1))
        if case.get('giga_lock'):
            m.write('wPlayerGigaHammerLock', m.read('wBattleMonMoves', case['giga_lock'] - 1))
        if case.get('torment'):
            m.write('wPlayerSubStatus2', m.read('wPlayerSubStatus2') | 2)
            m.write('wLastPlayerMove', m.read('wBattleMonMoves', case['torment'] - 1))
        if case.get('pp'):
            m.write_bytes('wBattleMonPP', case['pp'] + [0] * (4 - len(case['pp'])))
        if case.get('disabled'):
            m.write('wDisabledMove', m.read('wBattleMonMoves', case['disabled'] - 1))
            m.write('wPlayerDisableCount', (case['disabled'] << 4) | 4)
        m.write('hBattleTurn', 1)  # menu entry can inherit the enemy perspective
        state['pp'] = list(h.battle.player.pp)

    def used_move(_):
        m = h.battle.mem
        if m.read('hBattleTurn') == 0:
            state['used'].append(m.move_index_of(m.read('wCurPlayerMove')))

    def move_menu(_):
        state['move_menus'] += 1

    for symbol, callback in (('BattleMenu', fight_menu), ('BattleCommand_UsedMoveText', used_move),
                              ('MoveSelectionScreen', move_menu)):
        bank, address = h.sym[symbol]
        h.pb.hook_register(bank, address, callback, None)

    cases = [
        dict(name='choice-giga-hammer', moves=['GIGA_HAMMER', 'SPLASH'], item='CHOICE_BAND',
             lock=1, giga_lock=1, expected='STRUGGLE'),
        dict(name='choice-doom-desire', moves=['DOOM_DESIRE', 'SPLASH'], item='CHOICE_SPECS',
             lock=1, giga_lock=1, expected='STRUGGLE'),
        dict(name='giga-hammer-legal-alternate', moves=['GIGA_HAMMER', 'SPLASH'],
             giga_lock=1, slot=2, expected='SPLASH'),
        dict(name='vest-status-only', moves=['SPLASH'], item='ASSAULT_VEST', expected='STRUGGLE'),
        dict(name='choice-taunt', moves=['SPLASH', 'TACKLE'], item='CHOICE_BAND', lock=1,
             taunt=True, expected='STRUGGLE'),
        dict(name='choice-torment', moves=['TACKLE', 'SPLASH'], item='CHOICE_BAND', lock=1,
             torment=1, expected='STRUGGLE'),
        dict(name='vest-torment', moves=['TACKLE', 'SPLASH'], item='ASSAULT_VEST', torment=1,
             expected='STRUGGLE'),
        dict(name='no-item-status', moves=['SPLASH'], expected='SPLASH'),
        dict(name='klutz-vest-status', moves=['SPLASH'], item='ASSAULT_VEST', ability='KLUTZ',
             expected='SPLASH'),
        dict(name='vest-legal-alternate', moves=['SPLASH', 'TACKLE'], item='ASSAULT_VEST',
             slot=2, expected='TACKLE'),
        dict(name='choice-taunt-legal', moves=['TACKLE', 'SPLASH'], item='CHOICE_BAND', lock=1,
             taunt=True, expected='TACKLE'),
        dict(name='choice-torment-legal', moves=['TACKLE', 'SPLASH'], item='CHOICE_BAND', lock=1,
             torment=2, expected='TACKLE'),
    ]
    cases += [
        dict(name='duplicate-second-copy', moves=['TACKLE', 'TACKLE', 'POUND'],
             pp=[3, 7, 35], slot=2, expected='TACKLE'),
        dict(name='duplicate-choice-second-copy', moves=['TACKLE', 'TACKLE', 'POUND'],
             pp=[0xc0, 7, 35], item='CHOICE_BAND', lock=1, slot=2, expected='TACKLE'),
        dict(name='duplicate-choice-reject-other', moves=['TACKLE', 'TACKLE', 'POUND'],
             pp=[0xc0, 7, 35], item='CHOICE_BAND', lock=1, rejected_slot=3, slot=2, expected='TACKLE'),
        dict(name='duplicate-disable-reject-copy', moves=['TACKLE', 'TACKLE', 'POUND'],
             pp=[3, 7, 35], disabled=1, rejected_slot=2, slot=3, expected='POUND'),
        dict(name='duplicate-disable-all', moves=['TACKLE', 'TACKLE'],
             pp=[3, 7], disabled=1, expected='STRUGGLE'),
        dict(name='duplicate-choice-exhausted', moves=['TACKLE', 'TACKLE', 'POUND'],
             pp=[0xc0, 0x80, 35], item='CHOICE_BAND', lock=1, expected='STRUGGLE'),
    ]
    if args.duplicates_only:
        cases = [case for case in cases if case['name'].startswith('duplicate-')]
    checks = failures = 0
    results = []
    try:
        for case in cases:
            h.load_fixture()
            state.clear()
            state.update(case=case, pending=False, menus=0, move_menus=0, used=[], rejected=False)
            m = h.battle.mem
            m.write('wOptions', 0x41)  # Set mode, animations off
            player = dict(species='MEW', level=50, ability='NO_ABILITY', moves=case['moves'])
            if case.get('item'):
                player['item'] = case['item']
            foe = dict(species='SNORLAX', level=100, ability='NO_ABILITY', moves=['SPLASH'])
            Request(h.battle).write(dict(player=player, enemy=foe, enemy2=foe, rng='off', turns=1))
            m.write('wDebugBattleFlags', 0)
            call(h, 'DebugBattleSetup')
            text_bank, text_address = h.sym['FalknerWinLossText']
            m.write('wMapScriptsBank', text_bank)
            for pointer in ('wWinTextPointer', 'wLossTextPointer'):
                m.write_bytes(pointer, [text_address & 255, text_address >> 8])
            begin_native_call(h, 'StartBattle')
            h.pb.memory[0xC0F0] = 0xF3
            clicked = False
            elapsed = 0
            for _ in range(6000):
                if h.pb.register_file.PC in (0xC0F1, 0xC0F3) or h.state() == STATE_ERROR:
                    break
                if state['pending'] and 'FIGHT' in tile_text(h):
                    if clicked:
                        break
                    state['pending'] = False
                    h.tick(60)
                    h.pb.screen.image.save(str(args.output / (case['name'] + '-fight.png')))
                    h.press('a', hold=8, wait=80)
                    if case.get('rejected_slot'):
                        for _ in range((case['rejected_slot'] - m.read('wMenuCursorY')) % len(case['moves'])):
                            h.press('down', hold=8, wait=20)
                        h.press('a', hold=8, wait=20)
                        for _ in range(100):
                            if state['move_menus'] >= 2 or state['used'] or state['menus'] >= 2:
                                break
                            h.pb.button('a', 2)
                            h.tick(4)
                        state['rejected'] = state['move_menus'] >= 2 and not state['used'] and state['menus'] == 1
                        h.tick(60)
                    if case.get('slot', 1) != 1:
                        for _ in range((case['slot'] - m.read('wMenuCursorY')) % len(case['moves'])):
                            h.press('down', hold=8, wait=20)
                    h.press('a', hold=8, wait=20)
                    clicked = True
                else:
                    h.pb.button('a', 2)
                h.tick(4)
                if clicked:
                    elapsed += 4
                    if elapsed >= 1400:
                        break
            h.pb.screen.image.save(str(args.output / (case['name'] + '-result.png')))
            expected = h.con.move_index(case['expected'])
            native = m.read('hDebugActive') == 0
            used = state['used']
            actual_pp = list(h.battle.player.pp)
            assertions = [
                (clicked and native, 'selected Fight with native automatic mode disabled'),
                (bool(used) and used[0] == expected, 'executed ' + case['expected']),
                (state['menus'] >= 2, 'returned to Fight after one completed turn'),
            ]
            if case['expected'] == 'STRUGGLE':
                assertions.append((actual_pp == state.get('pp'), 'Struggle preserved the blocked moves PP'))
            else:
                slot = case.get('slot', 1) - 1
                assertions.append((actual_pp[slot] == state['pp'][slot] - 1, 'legal move spent one PP'))
                if case['name'].startswith('duplicate-'):
                    assertions.append((all(value == state['pp'][i] for i, value in enumerate(actual_pp) if i != slot),
                                       'other duplicate slots preserved PP'))
            if case.get('rejected_slot'):
                assertions.append((state['rejected'], 'rejected illegal copy/Choice move without spending the turn'))
            messages = []
            for passed, message in assertions:
                checks += 1
                if not passed:
                    failures += 1
                    messages.append(message)
                    print('FAIL ' + case['name'] + ': ' + message, flush=True)
            results.append(dict(case=case['name'], used=used, pp=actual_pp,
                                menu_entries=state['menus'], failures=messages))
            if not messages:
                print('PASS ' + case['name'], flush=True)
        (args.output / 'results.json').write_text(json.dumps(dict(checks=checks, failures=failures,
                                                                 cases=results), indent=2) + '\n')
        print(f'MOVE RESTRICTION MENU: {checks} checks, {failures} failures', flush=True)
    finally:
        h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
