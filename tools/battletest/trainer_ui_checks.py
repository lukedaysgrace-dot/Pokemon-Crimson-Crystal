#!/usr/bin/env python3
"""Native trainer menus: reserves, mandatory replacement, double KO, loss.

Request fixtures stage the teams; all moves and party choices use normal
menus with debug automatic actions disabled. This is a UI regression suite,
not a trainer/story playthrough.
"""

from pathlib import Path

from runner import Harness
from probability_checks import call
from save_menu_checks import begin_native_call
from state import Request
from symbols import STATE_ERROR
from ui_checks import tile_text, wait


def main():
    h = Harness()
    h.ensure_fixture()
    output = Path('.venv/trainer-ui')
    output.mkdir(parents=True, exist_ok=True)
    checks = failures = completed = 0
    pending_fight = False
    pending_party = False
    entrants = []
    final = {}

    def fight_menu(_):
        nonlocal pending_fight
        pending_fight = True
        h.pb.button_release('a')

    def party_menu(_):
        nonlocal pending_party
        pending_party = True
        h.pb.button_release('a')

    def entry(_):
        side = h.battle.enemy if h.battle.mem.read('hBattleTurn') else h.battle.player
        entrants.append((h.battle.mem.read('hBattleTurn'), side.species))

    def finished(_):
        # The debug wrapper restores its original party during teardown.
        # Capture native battle results before that fixture-only restoration.
        m = h.battle.mem
        final.update(result=m.read('wBattleResult') & 15,
                     in_ability=m.read('wInAbility'), gas=m.read('wSelfdestructGasTurn'),
                     species=h.battle.player.species, ability=h.battle.player.ability,
                     hp1=m.read_u16_be('wPartyMon1HP'),
                     personalities=[m.read_bytes(f'wPartyMon{i}Personality', 2) for i in range(1, m.read('wPartyCount') + 1)],
                     overflows=list(h.text_overflows))

    for symbol, callback in [('BattleMenu', fight_menu), ('SelectBattleMon', party_menu), ('RunEntryAbilities', entry), ('DebugBattleTeardown', finished)]:
        bank, address = h.sym[symbol]
        h.pb.hook_register(bank, address, callback, None)

    def check(condition, label):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL TRAINER ' + label, flush=True)

    mon = lambda species, level, ability, move, **kwargs: dict(species=species, level=level, ability=ability, moves=[move], **kwargs)
    cases = [
        ('two-enemy-reserves', dict(
            player=mon('MEW', 100, 'SYNCHRONIZE', 'AERIAL_ACE'),
            enemy=mon('ESPEON', 5, 'MAGIC_BOUNCE', 'SPLASH'),
            enemy2=mon('WEEZING', 5, 'NEUTRALIZING_GAS', 'SPLASH')), 0, False),
        ('mandatory-replacement', dict(
            player=mon('MAGIKARP', 5, 'SWIFT_SWIM', 'SPLASH', hp=1),
            player2=mon('PORYGON', 100, 'TRACE', 'AERIAL_ACE'),
            enemy=mon('WEEZING', 30, 'NEUTRALIZING_GAS', 'TACKLE'),
            enemy2=mon('ESPEON', 5, 'MAGIC_BOUNCE', 'SPLASH')), 0, True),
        ('double-KO-replacement', dict(
            player=mon('WEEZING', 100, 'NEUTRALIZING_GAS', 'EXPLOSION'),
            player2=mon('PORYGON', 100, 'TRACE', 'AERIAL_ACE'),
            enemy=mon('MAGIKARP', 5, 'SWIFT_SWIM', 'SPLASH'),
            enemy2=mon('POLITOED', 5, 'DRIZZLE', 'SPLASH')), 0, True),
        ('no-player-reserves', dict(
            player=mon('MAGIKARP', 5, 'SWIFT_SWIM', 'SPLASH', hp=1),
            enemy=mon('SNORLAX', 100, 'THICK_FAT', 'TACKLE'),
            enemy2=mon('ESPEON', 5, 'MAGIC_BOUNCE', 'SPLASH')), 1, False),
        ('shift-accept', dict(
            player=mon('MEW', 100, 'SYNCHRONIZE', 'AERIAL_ACE'),
            player2=mon('PORYGON', 100, 'TRACE', 'AERIAL_ACE'),
            enemy=mon('ESPEON', 5, 'MAGIC_BOUNCE', 'SPLASH'),
            enemy2=mon('POLITOED', 5, 'DRIZZLE', 'SPLASH')), 0, True),
        ('shift-cancel', dict(
            player=mon('MEW', 100, 'SYNCHRONIZE', 'AERIAL_ACE'),
            player2=mon('PORYGON', 100, 'TRACE', 'AERIAL_ACE'),
            enemy=mon('ESPEON', 5, 'MAGIC_BOUNCE', 'SPLASH'),
            enemy2=mon('POLITOED', 5, 'DRIZZLE', 'SPLASH')), 0, False),
    ]
    for name, teams, expected, requires_party in cases:
        try:
            h.load_fixture()
            pending_fight = pending_party = False
            entrants.clear()
            final.clear()
            m = h.battle.mem
            m.write('wOptions', 0x01 if name.startswith('shift-') else 0x41)
            Request(h.battle).write(dict(**teams, rng='off', turns=1))
            m.write('wDebugBattleFlags', 0)
            call(h, 'DebugBattleSetup')
            # A staged trainer needs the map-script victory text normally
            # provided by winlosstext. Native input disables the debug bypass.
            text_bank, text_address = h.sym['FalknerWinLossText']
            m.write('wMapScriptsBank', text_bank)
            for pointer in ('wWinTextPointer', 'wLossTextPointer'):
                m.write_bytes(pointer, [text_address & 255, text_address >> 8])
            begin_native_call(h, 'StartBattle')
            h.pb.memory[0xC0F0] = 0xF3  # Stop interrupting after the native return.
            fights = replacements = 0
            original_personalities = None
            cancelled = False
            for _ in range(6000):
                if h.pb.register_file.PC in (0xC0F1, 0xC0F3):
                    finished(None)
                    break
                if h.state() == STATE_ERROR:
                    break
                if pending_party:
                    pending_party = False
                    h.pb.button_release('a')
                    h.tick(60)
                    if name == 'shift-cancel':
                        h.press('b', hold=8, wait=40)
                        check(h.battle.player.species == 'MEW' and h.battle.player.hp > 0,
                              name + ': B retains the live active mon')
                        cancelled = True
                        continue
                    if not cancelled and not name.startswith('shift-'):
                        # A mandatory replacement cannot be cancelled into a
                        # turn with a fainted active mon.
                        h.press('b', hold=8, wait=40)
                        check(h.battle.player.hp == 0, name + ': B cannot resume a fainted active mon')
                        h.pb.screen.image.save(str(output / (name + '-cancel.png')))
                        cancelled = True
                        continue
                    slot = next(i for i in range(1, m.read('wPartyCount') + 1)
                                if m.read_u16_be(f'wPartyMon{i}HP') and i != m.read('wCurBattleMon') + 1)
                    for _ in range((slot - m.read('wMenuCursorY')) % (m.read('wPartyCount') + 1)):
                        h.press('down', hold=8, wait=20)
                    h.press('a', hold=8, wait=60)
                    h.press('a', hold=8, wait=20)
                    replacements += 1
                elif pending_fight:
                    if 'FIGHT' not in tile_text(h):
                        h.pb.button('a', 2)
                        h.tick(4)
                        continue
                    pending_fight = False
                    h.tick(60)
                    if original_personalities is None:
                        original_personalities = [m.read_bytes(f'wPartyMon{i}Personality', 2) for i in range(1, m.read('wPartyCount') + 1)]
                        check(m.read('hDebugActive') == 0, name + ': native battle input')
                        check(m.read('wBattleMode') == 2, name + ': trainer battle')
                    h.press('a', hold=8, wait=80)
                    move = h.battle.player.moves[0].replace('_', ' ')
                    wait(h, lambda: move in tile_text(h))
                    h.press('a', hold=8, wait=20)
                    fights += 1
                else:
                    h.pb.button('a', 2)
                h.tick(4)
            else:
                raise RuntimeError(f'timed out: {h.where()}; {h.control_state()}; moves={fights}, replacements={replacements}; {tile_text(h)}')
            check(bool(final), name + ': native battle finished')
            check(final['result'] == expected, name + ': battle result')
            check(fights > 0, name + ': native Fight menu used')
            check(bool(replacements) == requires_party, name + ': mandatory party menu')
            check(final['in_ability'] == 0, name + ': banner cleanup')
            check(final['gas'] == 0, name + ': Gas-explosion cleanup')
            check(not final['overflows'], name + ': textbox bounds')
            for slot, personality in enumerate(original_personalities or [], 1):
                check(final['personalities'][slot - 1] == personality, name + f': slot {slot} permanent ability')
            if name == 'two-enemy-reserves':
                check({species for side, species in entrants if side} >= {'ESPEON', 'WEEZING'}, name + ': all enemy reserves entered')
            if requires_party and not name.startswith('shift-'):
                check(final['hp1'] == 0, name + ': faint persists in party')
                check(final['species'] == 'PORYGON', name + ': selected replacement')
            if name == 'double-KO-replacement':
                check(final['ability'] == 'DRIZZLE', name + ': delayed Trace copies returning weather')
            if name == 'shift-accept':
                check(final['species'] == 'PORYGON' and final['ability'] == 'DRIZZLE',
                      name + ': selected live Trace replacement')
            if name == 'shift-cancel':
                check(cancelled and final['species'] == 'MEW', name + ': cancelled optional replacement')
            h.pb.screen.image.save(str(output / (name + '-finished.png')))
            completed += 1
            print(f'PASS TRAINER {name}: {fights} native moves, {replacements} replacements', flush=True)
        except Exception as error:
            failures += 1
            print(f'ERROR TRAINER {name}: {error}', flush=True)
            h.pb.screen.image.save(str(output / (name + '-error.png')))
    print(f'{completed} native trainer chains, {checks} checks, {failures} failures', flush=True)
    h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
