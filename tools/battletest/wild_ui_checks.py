#!/usr/bin/env python3
"""Native Run/Bag/capture endings with staged private wild encounters."""

from pathlib import Path

from probability_checks import call
from runner import Harness
from save_menu_checks import begin_native_call
from state import Request
from ui_checks import tile_text, wait


def main():
    h = Harness()
    h.ensure_fixture()
    output = Path('.venv/wild-ui')
    output.mkdir(parents=True, exist_ok=True)
    checks = failures = completed = 0

    def check(condition, label):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL WILD UI ' + label, flush=True)

    for name, species, ability in [('escape', 'MAGIKARP', 'SWIFT_SWIM'),
                                    ('trapped-escape', 'DIGLETT', 'ARENA_TRAP'),
                                    ('capture', 'ROOKIDEE', 'KEEN_EYE')]:
        try:
            h.load_fixture()
            nickname_answered = False
            m = h.battle.mem
            m.write('wOptions', 0x41)
            Request(h.battle).write(dict(
                player=dict(species='MEW', level=100, ability='SYNCHRONIZE', moves=['AERIAL_ACE']),
                enemy=dict(species=species, level=5, ability=ability, moves=['SPLASH']),
                rng='off', turns=1))
            m.write('wDebugBattleFlags', 0)
            call(h, 'DebugBattleSetup')
            m.write('wNumBalls', 1)
            m.write_bytes('wBalls', [h.con.item_id('MASTER_BALL'), 1, 255])
            m.write('wCurPocket', 1)  # Ball pocket.
            begin_native_call(h, 'StartBattle')
            h.pb.memory[0xC0F0] = 0xF3
            wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
            check(m.read('hDebugActive') == 0 and m.read('wBattleMode') == 1, name + ': native wild menu')
            personality = m.read_bytes('wPartyMon1Personality', 2)
            original_pp = h.battle.player.pp
            if name == 'capture':
                h.press('down', hold=8, wait=20)  # PACK
                h.press('a', hold=8, wait=80)
                h.press('right', hold=8, wait=60)  # Native pack starts in Items.
                wait(h, lambda: 'MASTER BALL' in tile_text(h))
                h.pb.screen.image.save(str(output / 'capture-bag.png'))
                h.press('a', hold=8, wait=60)
                h.press('a', hold=8, wait=20)  # USE
            else:
                h.press('right', hold=8, wait=20)
                h.press('down', hold=8, wait=20)  # RUN
                h.press('a', hold=8, wait=20)
                if name == 'trapped-escape':
                    wait(h, lambda: any(context.startswith('BattleText_CantEscape') for context in h.battle.textbox_contexts)
                         and 'FIGHT' in tile_text(h), advance=True)
                    check(h.battle.player.pp == original_pp and m.read('wBattleEnded') == 0,
                          name + ': Arena Trap blocks Run without spending move PP')
                    h.pb.screen.image.save(str(output / 'trapped-menu.png'))
                    # Run was selected; return the cursor to FIGHT.
                    h.press('up', hold=8, wait=20)
                    h.press('left', hold=8, wait=20)
                    h.press('a', hold=8, wait=80)
                    wait(h, lambda: 'AERIAL ACE' in tile_text(h))
                    h.press('a', hold=8, wait=20)
            for _ in range(6000):
                if h.pb.register_file.PC in (0xC0F1, 0xC0F3):
                    break
                if (not nickname_answered and 'YES' in tile_text(h)
                        and any(context.startswith('Text_AskNicknameNewlyCaughtMon')
                                for context in h.battle.textbox_contexts)):
                    h.pb.button_release('a')
                    h.tick(60)
                    h.press('down', hold=8, wait=20)
                    h.press('a', hold=8, wait=40)
                    nickname_answered = True
                else:
                    h.pb.button('a', 2)
                    h.tick(4)
            else:
                raise RuntimeError('ending did not return: ' + tile_text(h))
            check(m.read('wInAbility') == 0 and m.read('wSelfdestructGasTurn') == 0, name + ': cleanup')
            check(m.read_bytes('wPartyMon1Personality', 2) == personality, name + ': permanent ability preserved')
            check(not h.text_overflows, name + ': textbox bounds')
            if name == 'capture':
                check(m.read('wPartyCount') == 2, name + ': caught mon joined party')
                runtime_species = m.read('wPartyMon2Species')
                check(m.species_index_of(runtime_species) == h.con.species_index(species), name + ': exact caught species')
                check(m.read_u16_be('wPartyMon2HP') > 0 and m.read('wPartyMon2Level') == 5, name + ': caught HP/level')
                check(m.read('wNumBalls') == 0, name + ': Master Ball consumed')
                check(any(context.startswith('Text_GotchaMonWasCaught') for context in h.battle.textbox_contexts),
                      name + ': capture ending')
            elif name == 'escape':
                check(h.battle.player.pp == original_pp, name + ': escape spends no move PP')
                check(m.read('wPartyCount') == 1, name + ': no capture')
            else:
                check(m.read('wBattleResult') & 15 == 0 and h.battle.player.pp[0] == original_pp[0] - 1,
                      name + ': normal win after blocked escape')
            h.pb.screen.image.save(str(output / (name + '-finished.png')))
            completed += 1
            print('PASS WILD UI ' + name, flush=True)
        except Exception as error:
            failures += 1
            print(f'ERROR WILD UI {name}: {error}', flush=True)
            h.pb.screen.image.save(str(output / (name + '-error.png')))
    print(f'{completed} wild UI endings, {checks} checks, {failures} failures', flush=True)
    h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
