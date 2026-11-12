#!/usr/bin/env python3
"""Native Fight-menu checks for the player's Choice-item lock.

Auto-mode YAML battles pick the player's move in DebugChoosePlayerMove and
never open MoveSelectionScreen, so they cannot reach the player's
selection-time refusals. These scenarios disable the debug automatic actions
and press buttons in the real Fight and move menus instead.

The enemy-item control matters: CheckPlayerChoiceLock_Core reads the "user"
item through hBattleTurn, which the previous end-of-turn handler usually
leaves on the enemy. MoveInfoBox sets the player's turn before the check; a
regression there would make the opponent's item decide the player's lock.

Fixtures are private emulator state; no player save is opened.
"""

from runner import Harness
from probability_checks import call
from save_menu_checks import begin_native_call
from state import Request
from symbols import STATE_ERROR
from ui_checks import tile_text


def main():
    h = Harness()
    h.ensure_fixture()
    checks = failures = 0
    pending = [False]
    lock_turns = []

    def fight_menu(_):
        pending[0] = True
        h.pb.button_release('a')

    def lock_check(_):
        lock_turns.append(h.battle.mem.read('hBattleTurn'))

    for symbol, callback in (('BattleMenu', fight_menu),
                             ('CheckPlayerChoiceLock_Core', lock_check)):
        bank, address = h.sym[symbol]
        h.pb.hook_register(bank, address, callback, None)

    def check(condition, label):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL CHOICE ' + label, flush=True)

    def mon(species, level, moves, **kwargs):
        return dict(species=species, level=level, ability='NO_ABILITY',
                    moves=moves, **kwargs)

    def play(teams, slots):
        """Open the Fight menu once per entry in `slots` and pick that move.

        Returns the state seen when each Fight menu opened, plus the state
        after the last pick has had time to resolve or be refused.
        """
        h.load_fixture()
        pending[0] = False
        lock_turns.clear()
        m = h.battle.mem
        m.write('wOptions', 0x41)  # Set mode, animations off
        Request(h.battle).write(dict(**teams, rng='off', turns=1))
        m.write('wDebugBattleFlags', 0)
        call(h, 'DebugBattleSetup')
        text_bank, text_address = h.sym['FalknerWinLossText']
        m.write('wMapScriptsBank', text_bank)
        for pointer in ('wWinTextPointer', 'wLossTextPointer'):
            m.write_bytes(pointer, [text_address & 255, text_address >> 8])
        begin_native_call(h, 'StartBattle')
        h.pb.memory[0xC0F0] = 0xF3
        seen = []
        picks = 0
        settle = None
        for _ in range(6000):
            if h.pb.register_file.PC in (0xC0F1, 0xC0F3) or h.state() == STATE_ERROR:
                break
            if settle is not None:
                # Keep pressing A: an accepted move advances its text (and may
                # be picked again on a later turn), a refused one is simply
                # offered and refused again.
                settle -= 1
                if settle == 0:
                    break
                h.pb.button('a', 2)
                h.tick(4)
                continue
            if pending[0]:
                if 'FIGHT' not in tile_text(h):
                    h.pb.button('a', 2)
                    h.tick(4)
                    continue
                pending[0] = False
                h.tick(60)
                seen.append(dict(pp=list(h.battle.player.pp),
                                 lock=m.read('wPlayerChoiceLockedMove'),
                                 turn=m.read('hBattleTurn')))
                h.press('a', hold=8, wait=80)
                target = slots[picks]
                for _ in range((target - m.read('wMenuCursorY')) % 4):
                    h.press('down', hold=8, wait=20)
                h.press('a', hold=8, wait=20)
                picks += 1
                if picks == len(slots):
                    settle = 150
            else:
                h.pb.button('a', 2)
            h.tick(4)
        final = dict(pp=list(h.battle.player.pp),
                     lock=m.read('wPlayerChoiceLockedMove'),
                     moves=m.read_bytes('wBattleMonMoves', 4),
                     picks=picks, native=m.read('hDebugActive') == 0,
                     lock_turns=list(lock_turns))
        return seen, final

    snorlax = mon('SNORLAX', 100, ['SPLASH'])
    reserve = mon('SNORLAX', 100, ['SPLASH'])

    # 1. A Choice Band locks the first selected move; another is refused.
    for label, player in (('faster holder', mon('MEW', 50, ['TACKLE', 'SPLASH'], item='CHOICE_BAND')),
                          ('slower holder', mon('SHUCKLE', 50, ['TACKLE', 'SPLASH'], item='CHOICE_BAND'))):
        seen, final = play(dict(player=player, enemy=snorlax, enemy2=reserve), [1, 2])
        name = 'Choice Band, ' + label
        check(final['native'] and final['picks'] == 2, name + ': two native selections')
        check(len(seen) == 2 and seen[1]['turn'] == 1,
              name + ': the second turn starts with the enemy as turn holder')
        check(bool(final['lock_turns']) and not any(final['lock_turns']),
              name + ': every lock check runs as the player')
        check(final['lock'] == final['moves'][0] != 0, name + ': locked into the first move')
        check(final['pp'][0] == 34, name + ': the locked move was used once')
        check(final['pp'][1] == 40, name + ': the other move is refused and keeps its PP')

    # 2. Control: without the item the second move is accepted.
    seen, final = play(dict(player=mon('MEW', 50, ['TACKLE', 'SPLASH']),
                            enemy=snorlax, enemy2=reserve), [1, 2])
    check(final['native'] and final['picks'] == 2, 'no item: two native selections')
    check(final['lock'] == 0, 'no item: no lock')
    check(final['pp'][0] == 34 and final['pp'][1] < 40, 'no item: the second move is accepted')

    # 3. Control: the opponent's Choice item never locks the player.
    seen, final = play(dict(player=mon('MEW', 50, ['TACKLE', 'SPLASH']),
                            enemy=mon('SNORLAX', 100, ['SPLASH'], item='CHOICE_BAND'),
                            enemy2=reserve), [1, 2])
    check(len(seen) == 2 and seen[1]['turn'] == 1,
          'enemy item: the second turn starts with the enemy as turn holder')
    check(final['lock'] == 0, 'enemy item: the player is not locked')
    check(final['pp'][0] == 34 and final['pp'][1] < 40, 'enemy item: the player may change moves')

    # 4. Klutz disables the lock without removing the item.
    seen, final = play(dict(player=dict(mon('MEW', 50, ['TACKLE', 'SPLASH'], item='CHOICE_BAND'),
                                        ability='KLUTZ'),
                            enemy=snorlax, enemy2=reserve), [1, 2])
    check(final['lock'] == 0, 'Klutz: no lock')
    check(final['pp'][0] == 34 and final['pp'][1] < 40, 'Klutz: the second move is accepted')
    check(h.battle.player.item == 'CHOICE_BAND', 'Klutz: the item stays held')

    print(f'CHOICE LOCK MENU: {checks} checks, {failures} failures', flush=True)
    h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
