#!/usr/bin/env python3
"""All eight rules choices via New Game, Save, fresh boot, and Continue.

Evolution/storage cases then stage a level-ready party in that private save.
They execute the real routines (and evolution animation), with no UI patches.
"""

import json
from pathlib import Path

from pyboy import PyBoy

from runner import Harness
from state import Battle, Request
from probability_checks import call
from save_menu_checks import begin_native_call
from ui_checks import tile_text


OUTPUT = Path('.tmpbuild/gameplay-rules')


def hook(h, name, fn):
    bank, address = h.sym[name]
    h.pb.hook_register(bank, address, fn, None)


def new_game(h, rules, hard=False):
    stage = [None]
    completed = []
    choices = {'InitPokemonTyping': 1 if rules & 1 else 2,
               'InitPokemonStats': 1 if rules & 2 else 2,
               'InitPokemonAbilities': 2 if rules & 4 else 1}
    for name in ['InitDifficulty', *choices]:
        hook(h, name, lambda _, name=name: stage.__setitem__(0, name))
        hook(h, name + '.done', lambda _, name=name:
             (completed.append((name, h.battle.mem.read('wGameplayRules'))), stage.__setitem__(0, None)))
    h.tick(400)
    for iteration in range(2400):
        m, text = h.battle.mem, tile_text(h)
        if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (24, 7, 2):
            h.tick(120)
            return completed
        name = stage[0]
        if name in choices and (('Original' in text and 'Enhanced' in text)
                                or ('On' in text and 'Off' in text)):
            # Menu drawing and its default cursor must finish before input.
            h.tick(40)
            if m.read('wMenuCursorY') != choices[name]:
                h.press('down', hold=4, wait=24)
            h.press('a', hold=4, wait=24)
        elif name == 'InitDifficulty':
            if 'Normal' in text and 'Hard' in text and not ('YES' in text and 'NO' in text):
                h.tick(40)
                if m.read('wMenuCursorY') != (2 if hard else 1):
                    h.press('down', hold=4, wait=24)
                h.press('a', hold=4, wait=24)
            elif 'YES' in text and 'NO' in text:
                h.press('up', hold=4, wait=16)
                h.press('a', hold=4, wait=20)
            else:
                h.press('a', hold=4, wait=20)
        else:
            if iteration % 12 == 11:
                h.press('start', hold=4, wait=12)
            h.press('a', hold=4, wait=20)
    raise RuntimeError('New Game did not finish: ' + tile_text(h))


def save_continue(h, map_id=(24, 7)):
    saved = []
    hook(h, 'SavedTheGame', lambda _: saved.append(True))
    h.press('start', hold=4, wait=80)
    for _ in range(15):
        if h.battle.mem.read('wMenuSelection') == 4:
            break
        h.press('down', hold=4, wait=20)
    if h.battle.mem.read('wMenuSelection') != 4:
        raise RuntimeError('Could not select SAVE')
    h.press('a', hold=4, wait=30)
    for _ in range(600):
        h.press('a', hold=4, wait=20)
        if saved:
            h.tick(120)
            break
    if not saved:
        raise RuntimeError('SAVE did not finish: ' + tile_text(h))
    private_rom = Path(h._rom_tempdir.name) / 'pokecrystal_debug.gbc'
    h.pb.stop(save=True)
    h.pb = PyBoy(str(private_rom), window='null', cgb=True, sound_emulated=False)
    h.pb.set_emulation_speed(0)
    h.pb.hook_register(0, 0x100, lambda _: None, None)
    h.battle = Battle(h.pb, h.sym, h.con)
    h.battle.textbox_contexts = set()
    h.text_context = None
    h.text_overflows.clear()
    for symbol, callback in (('PrintTextboxText', h._begin_text),
                             ('PrintTextboxText.done', h._end_text),
                             ('CheckDict.place', h._check_text_glyph)):
        hook(h, symbol, callback)
    h.tick(400)
    for _ in range(100):
        if 'CONTINUE' in tile_text(h):
            h.tick(120)
            break
        h.press('start', hold=4, wait=16)
        h.press('a', hold=4, wait=16)
    else:
        raise RuntimeError('Fresh boot did not offer CONTINUE')
    for _ in range(500):
        h.press('a', hold=4, wait=20)
        m = h.battle.mem
        if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (*map_id, 2):
            h.tick(120)
            return
    raise RuntimeError('CONTINUE did not return to the overworld')


def feature_cases(h, rules, check):
    m = h.battle.mem
    address = h.sym.addr('wDebugPlayer1')
    request = Request(h.battle)
    m.write('wPartyCount', 0)
    m.write('wPartySpecies', 255)
    m.write('wMonType', 0)
    for slot, species in enumerate(('LEDYBA', 'PIDGEOTTO', 'MEW')):
        m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species=species,
                      level=40, moves=['TACKLE'], dvs=0xffff)))
        call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
    for original, evolved, expected_stats, original_stats in (
            ('LEDYBA', 'LEDIAN', [80, 105, 70, 95, 35, 110], [55, 35, 50, 85, 55, 110]),
            ('PIDGEOTTO', 'PIDGEOT', [83, 60, 70, 101, 115, 70], [83, 80, 75, 101, 70, 70])):
        slot = next(i for i in range(m.read('wPartyCount'))
                    if m.species_index_of(m.read(f'wPartyMon{i + 1}Species')) == h.con.species_index(original))
        prefix = f'wPartyMon{slot + 1}'
        personality = m.read_bytes(prefix + 'Personality', 2)
        m.write('wCurPartyMon', slot)
        m.write('wLinkMode', 0)
        m.write('wForceEvolution', 0)
        # Evolution normally runs before battle teardown. Retain that context
        # so the isolated routine does not restart overworld music on return.
        m.write('wBattleMode', 1)
        begin_native_call(h, 'EvolvePokemon')
        for _ in range(2400):
            h.press('a', hold=4, wait=20)
            if h.pb.register_file.PC in (0xC0F1, 0xC0F3):
                break
        else:
            with (OUTPUT / 'evolution-error.state').open('wb') as stream:
                h.pb.save_state(stream)
            raise RuntimeError('Evolution did not finish: ' + h.where() + '; ' + str(h.control_state()) + '; ' + tile_text(h))
        m.write('wBattleMode', 0)
        index = m.species_index_of(m.read(prefix + 'Species'))
        check(index == h.con.species_index(evolved), f'{evolved}: evolution species')
        check(m.read_bytes(prefix + 'Personality', 2) == personality, f'{evolved}: personality survives evolution')
        m.write('wCurSpecies', m.read(prefix + 'Species'))
        call(h, 'GetBaseData')
        base_stats = list(m.read_bytes('wBaseStats', 6))
        expected = original_stats if rules & 2 else expected_stats
        check(base_stats == expected, f'{evolved}: selected base stats {base_stats}')
        # Staged mons have perfect DVs and zero stat experience. This checks
        # evolution's calculated party stats independently of its base table.
        level = m.read(prefix + 'Level')
        calculated = [(base + 15) * 2 * level // 100 + (level + 10 if i == 0 else 5)
                      for i, base in enumerate(expected)]
        actual = [m.read_u16_be(prefix + 'MaxHP', i * 2) for i in range(6)]
        check(actual == calculated, f'{evolved}: calculated evolved stats {actual}, expected {calculated}')
        if evolved == 'LEDIAN':
            # BUG=7, FLYING=2, FIGHTING=1 in this ROM.
            check(list(m.read_bytes('wBaseType1', 2)) == [7, 2 if rules & 1 else 1],
                  'Ledian: selected typing after evolution')
        call(h, 'GetAbility', B=personality[0], C=m.read(prefix + 'Species'))
        check((h.pb.register_file.A == 0) == bool(rules & 4), f'{evolved}: abilities On/Off after evolution')
        # Actual party <-> PokeDB transfer, retaining one healthy party member.
        expected_stats_words = m.read_bytes(prefix + 'MaxHP', 12)
        result = call(h, 'SwapStorageBoxSlots', B=1, C=1, D=0, E=slot + 1)
        check(result == 0, f'{evolved}: deposit succeeded')
        result = call(h, 'SwapStorageBoxSlots', B=0, C=0, D=1, E=1)
        check(result == 0, f'{evolved}: withdrawal succeeded')
        prefix = f'wPartyMon{m.read("wPartyCount")}'
        check(m.species_index_of(m.read(prefix + 'Species')) == index, f'{evolved}: storage species')
        check(m.read_bytes(prefix + 'Personality', 2) == personality, f'{evolved}: storage personality')
        check(m.read_bytes(prefix + 'MaxHP', 12) == expected_stats_words, f'{evolved}: storage recalculated selected stats')
        check(m.read('wGameplayRules') == rules, f'{evolved}: storage preserved rules')
    size = h.sym.addr('wPartyMonNicknamesEnd') - h.sym.addr('wPokemonData')
    expected_party = m.read_bytes('wPokemonData', size)
    call(h, 'SaveGameData')
    m.write('wGameplayRules', rules ^ 7)
    m.write('wPartyCount', 0)
    call(h, 'TryLoadSaveFile')
    check(m.read('wGameplayRules') == rules, 'post-evolution/storage save restored selected rules')
    check(m.read_bytes('wPokemonData', size) == expected_party,
          'post-evolution/storage save restored exact party, moves, stats and personalities')


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    checks, failures, results = 0, [], []
    for rules in range(8):
        h = Harness()
        def check(ok, label):
            nonlocal checks
            checks += 1
            if not ok:
                failures.append(f'rules {rules}: {label}')
                print('FAIL ' + failures[-1], flush=True)
        try:
            completed = new_game(h, rules)
            check(len(completed) == 4, 'all four choice screens completed')
            check(h.battle.mem.read('wGameplayRules') == rules, 'New Game applied chosen rules')
            check(h.battle.mem.read('wPartyCount') == 0, 'fresh game has no staged party')
            h.pb.screen.image.save(str(OUTPUT / f'{rules}-new.png'))
            save_continue(h)
            check(h.battle.mem.read('wGameplayRules') == rules, 'Save/fresh boot/Continue preserved rules')
            h.pb.screen.image.save(str(OUTPUT / f'{rules}-continued.png'))
            feature_cases(h, rules, check)
            results.append(dict(rules=rules, selections=completed))
            print(f'RULES {rules}: completed menu/save/reboot/evolution/storage checks', flush=True)
        except Exception as error:
            failures.append(f'rules {rules}: {error}')
            print('ERROR ' + failures[-1], flush=True)
            h.pb.screen.image.save(str(OUTPUT / f'{rules}-error.png'))
            # A broken driver should be diagnosed before repeating eight times.
            break
        finally:
            h.pb.stop(save=False)
    report = dict(checks=checks, failures=failures, configurations=results)
    (OUTPUT / 'results.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'GAMEPLAY RULES: {checks} checks; {len(failures)} failures; {len(results)}/8 configurations', flush=True)
    return int(bool(failures) or len(results) != 8)


if __name__ == '__main__':
    raise SystemExit(main())
