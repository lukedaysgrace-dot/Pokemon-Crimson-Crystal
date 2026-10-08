#!/usr/bin/env python3
"""Interactive, logged button-only story playthrough in private test SRAM.

Starts through New Game menus, a cached fresh boot, or this driver's checkpoint.
After that, commands only press buttons, advance frames, or read/capture state.
No party/encounter staging, native routine calls, or gameplay WRAM edits.
"""

import argparse
import hashlib
import json
import shutil
import sys
from pathlib import Path

from runner import Harness
from symbols import ROOT
from symbols import _parse_constants
from ui_checks import tile_text
from overworld_controls import Controls
from gameplay_rules_checks import new_game, save_continue


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', default='.tmpbuild/story-playthrough')
    parser.add_argument('--resume', help='Resume a button-only playthrough snapshot')
    parser.add_argument('--fresh', action='store_true', help='Use the actual New Game menus instead of the cached boot')
    parser.add_argument('--rules', type=int, default=0, choices=range(8))
    parser.add_argument('--hard', action='store_true')
    args = parser.parse_args()
    output = ROOT / args.output
    output.mkdir(parents=True, exist_ok=True)
    h = Harness()
    if args.resume:
        with Path(args.resume).open('rb') as stream:
            h.pb.load_state(stream)
    elif args.fresh:
        new_game(h, args.rules, hard=args.hard)
    else:
        h.ensure_fixture()
        # The fixture was created through the new-game menus, before the starter.
        # Leave DEBUG and the start menu through their normal cancel inputs.
        h.press('b', hold=4, wait=30)
        h.press('b', hold=4, wait=30)
    controls = Controls(h)
    frames = commands = 0
    if args.resume and (output / 'journal.jsonl').exists():
        for line in (output / 'journal.jsonl').read_text().splitlines():
            previous = json.loads(line)
            if 'frames' in previous:
                frames, commands = previous['frames'], previous['command']
    journal = (output / 'journal.jsonl').open('a', buffering=1)
    battle_journal = (output / 'battle-actions.jsonl').open('a', buffering=1)
    event_ids = _parse_constants(ROOT / 'constants/event_flags.asm')

    def observe_action(side):
        m = h.battle.mem
        data = dict(command=commands, side=side)
        for label, prefix in (('player', 'wBattleMon'), ('enemy', 'wEnemyMon')):
            data[label] = dict(species=h.con.species_by_index.get(m.species_index_of(m.read(prefix + 'Species')), ''),
                               level=m.read(prefix + 'Level'), hp=m.read_u16_be(prefix + 'HP'),
                               status=m.read(prefix + 'Status'), pp=list(m.read_bytes(prefix + 'PP', 4)),
                               ability=h.con.abilities_by_id.get(m.read('wPlayerAbility' if label == 'player' else 'wEnemyAbility'), ''),
                               stats={stat: m.read_u16_be(prefix + stat) for stat in ('Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef')})
        data['move'] = h.con.moves_by_index.get(m.move_index_of(m.read('wCurPlayerMove' if side == 'player' else 'wCurEnemyMove')), '')
        data['weather'] = m.read('wBattleWeather')
        battle_journal.write(json.dumps(data) + '\n')

    def install_observers():
        for symbol, side in (('DoPlayerTurn', 'player'), ('DoEnemyTurn', 'enemy')):
            bank, address = h.sym[symbol]
            h.pb.hook_register(bank, address, lambda _, side=side: observe_action(side), None)

    install_observers()

    def dialogue():
        for _ in range(2400):
            if h.battle.mem.read('wBattleMode'):
                controls.battle()
            elif not h.battle.mem.read('wScriptMode') and not h.battle.mem.read('hInMenu'):
                controls.wait(60)
                if not h.battle.mem.read('wScriptMode') and not h.battle.mem.read('hInMenu'):
                    return
            else:
                if not controls.learn_move_input(tile_text(h)):
                    controls.press('a', hold=4, wait=40)
        raise RuntimeError('Dialogue command budget exhausted')

    def capture():
        initial = h.battle.mem.read('wPartyCount')
        for _ in range(2400):
            m, text = h.battle.mem, tile_text(h)
            if m.read('wPartyCount') > initial:
                for _ in range(400):
                    controls.press('b', hold=4, wait=40)
                    if not m.read('wBattleMode') and not m.read('wScriptMode'):
                        return
                raise RuntimeError('Capture ending did not finish')
            if not m.read('wBattleMode'):
                raise RuntimeError('Capture ended without adding a party member')
            if 'FIGHT' in text and 'PACK' in text:
                controls.press('up', hold=4, wait=12)
                controls.press('left', hold=4, wait=12)
                controls.press('down', hold=4, wait=12)
                controls.press('a', hold=8, wait=80)
            elif 'CANCEL' in text and m.read('hInMenu'):
                if m.read('wCurPocket') != 1:
                    controls.press('right', hold=8, wait=80)
                elif 'BALL' in text:
                    controls.press('a', hold=8, wait=60)
                    controls.press('a', hold=8, wait=600)
                else:
                    raise RuntimeError('No usable ball in the Ball pocket')
            else:
                controls.press('a', hold=4, wait=40)
        raise RuntimeError('Capture command budget exhausted')

    def travel(goal, avoid=()):
        origin = controls.map_id()
        for _ in range(120):
            if controls.map_id() != origin:
                return
            if h.battle.mem.read('wBattleMode'):
                controls.battle()
                if h.battle.mem.read('wBattleResult') & 15 == 1:
                    dialogue()
                    return
                continue
            if h.battle.mem.read('wScriptMode'):
                controls.press('a', hold=4, wait=40)
                continue
            if controls.position() == tuple(goal):
                return
            previous = controls.position()
            controls.go(goal, avoid=avoid)
            if controls.position() == previous and not h.battle.mem.read('wBattleMode') and not h.battle.mem.read('wScriptMode'):
                raise RuntimeError(f'Native walking stalled at {previous}, goal {tuple(goal)}')
        raise RuntimeError('Travel command budget exhausted')

    def lead(slot):
        """Reorder the party using the ordinary Start/Pokemon/Switch menus."""
        if not h.battle.mem.read('wBattleMode') and h.battle.mem.read('wScriptMode'):
            dialogue()
        if h.battle.mem.read('wBattleMode') or h.battle.mem.read('wScriptMode'):
            raise RuntimeError('Party reordering requires the idle overworld')
        controls.press('start', hold=4, wait=80)
        for _ in range(12):
            if h.battle.mem.read('wMenuCursorY') == 2:
                break
            controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=100)
        for _ in range(8):
            if h.battle.mem.read('wMenuCursorY') == slot:
                break
            controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=100)
        text = tile_text(h)
        options = ('CUT', 'FLY', 'SURF', 'STRENGTH', 'FLASH', 'WHIRLPOOL', 'DIG',
                   'TELEPORT', 'SOFTBOILED', 'MILK DRINK', 'HEADBUTT', 'WATERFALL',
                   'ROCK SMASH', 'SWEET SCENT', 'STATS', 'SWITCH', 'ITEM', 'CANCEL')
        visible = [line.strip() for line in text.splitlines() if line.strip() in options]
        target = visible.index('SWITCH') + 1
        for _ in range(16):
            if h.battle.mem.read('wMenuCursorY') == target:
                break
            controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=80)
        for _ in range(8):
            if h.battle.mem.read('wMenuCursorY') == 1:
                break
            controls.press('up', hold=4, wait=24)
        controls.press('a', hold=4, wait=80)
        for _ in range(4):
            controls.press('b', hold=4, wait=40)

    def interact(at, directions):
        """Approach an observed NPC through a reachable adjacent tile."""
        x, y = at
        offsets = {'up': (0, 1), 'down': (0, -1), 'left': (1, 0), 'right': (-1, 0)}
        origin = controls.map_id()
        for direction in directions:
            dx, dy = offsets[direction]
            goal = (x + dx, y + dy)
            try:
                controls.path(goal)
            except RuntimeError:
                continue
            travel(goal)
            if controls.map_id() != origin or controls.position() != goal:
                raise RuntimeError('Interaction approach interrupted before reaching the NPC')
            controls.press(direction, hold=4, wait=24)
            controls.press('a', hold=4, wait=40)
            dialogue()
            return
        raise RuntimeError(f'No reachable approach to {at} from the requested directions')

    def switch_battle(slot):
        """Share battle experience by switching through the Pokemon command."""
        for _ in range(400):
            if 'FIGHT' in tile_text(h) and 'PACK' in tile_text(h):
                break
            controls.press('a', hold=4, wait=24)
        else:
            raise RuntimeError('Battle switch did not reach command menu')
        controls.press('up', hold=4, wait=24)
        controls.press('right', hold=4, wait=24)
        controls.press('a', hold=4, wait=100)
        for _ in range(8):
            if h.battle.mem.read('wMenuCursorY') == slot:
                break
            controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=80)
        controls.press('a', hold=4, wait=100)
        for _ in range(400):
            if h.battle.mem.read('wCurBattleMon') == slot - 1:
                return
            controls.press('a', hold=4, wait=24)
        raise RuntimeError('Battle switch did not select requested party slot')

    def choose_move(slot):
        for _ in range(400):
            text = tile_text(h)
            names = [h.con.moves_by_index.get(h.battle.mem.move_index_of(value), '')
                     for value in h.battle.mem.read_bytes('wBattleMonMoves', 4)]
            if sum(name.replace('_', ' ') in text for name in names if name and name != 'NO_MOVE') >= 2:
                break
            if 'FIGHT' in text and 'PACK' in text:
                controls.press('up', hold=4, wait=24)
                controls.press('left', hold=4, wait=24)
            controls.press('a', hold=4, wait=40)
        else:
            raise RuntimeError('Move selection did not reach moves menu')
        for _ in range(8):
            if h.battle.mem.read('wMenuCursorY') == slot:
                break
            controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=100)

    def snapshot(label):
        m = h.battle.mem
        party = []
        for slot in range(1, min(6, m.read('wPartyCount')) + 1):
            prefix = f'wPartyMon{slot}'
            index = m.species_index_of(m.read(prefix + 'Species'))
            party.append(dict(species=h.con.species_by_index.get(index, str(index)),
                              is_egg=m.read('wPartySpecies', slot - 1) == 253,
                              level=m.read(prefix + 'Level'), hp=m.read_u16_be(prefix + 'HP'),
                              maxhp=m.read_u16_be(prefix + 'MaxHP'), item=m.read(prefix + 'Item'),
                              moves=[h.con.moves_by_index.get(m.move_index_of(value), str(value))
                                     for value in m.read_bytes(prefix + 'Moves', 4)],
                              pp=list(m.read_bytes(prefix + 'PP', 4)),
                              status=m.read(prefix + 'Status'),
                              personality=list(m.read_bytes(prefix + 'Personality', 2))))
        data = dict(command=commands, frames=frames, emulated_minutes=round(frames / 3600, 2),
                    label=label, map=[m.read('wMapGroup'), m.read('wMapNumber')],
                    position=[m.read('wXCoord'), m.read('wYCoord')],
                    map_status=m.read('wMapStatus'), battle_mode=m.read('wBattleMode'),
                    party=party, text=tile_text(h), text_overflows=list(h.text_overflows),
                    pc=f'{h.pb.register_file.PC:04x}')
        data['gameplay_rules'] = m.read('wGameplayRules')
        data['badges'] = [m.read('wJohtoBadges'), m.read('wKantoBadges')]
        data['level_cap'] = m.read('wLevelCap')
        data['money'] = int.from_bytes(m.read_bytes('wMoney', 3), 'big')
        data['rom_md5'] = hashlib.md5((ROOT / 'pokecrystal_debug.gbc').read_bytes()).hexdigest()
        data['script_mode'] = m.read('wScriptMode')
        data['in_menu'] = m.read('hInMenu')
        data['farfetchd_position'] = m.read('wFarfetchdPosition')
        data['balls'] = [(h.con.items_by_id.get(m.read('wBalls', i * 2), ''), m.read('wBalls', i * 2 + 1))
                         for i in range(m.read('wNumBalls'))]
        data['event_flags_hex'] = m.read_bytes('wEventFlags', (max(event_ids.values()) + 8) // 8).hex()
        data['enemy_species'] = h.con.species_by_index.get(m.species_index_of(m.read('wEnemyMonSpecies')), '') if m.read('wBattleMode') else ''
        data['enemy_level'] = m.read('wEnemyMonLevel') if m.read('wBattleMode') else 0
        data['enemy_hp'] = m.read_u16_be('wEnemyMonHP') if m.read('wBattleMode') else 0
        data['inventory'] = [(h.con.items_by_id.get(m.read('wItems', i * 2), ''), m.read('wItems', i * 2 + 1))
                             for i in range(m.read('wNumItems'))]
        data['events'] = {name: bool(m.read('wEventFlags', event_ids[name] // 8) & (1 << (event_ids[name] % 8)))
                          for name in ('EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON', 'EVENT_GAVE_MYSTERY_EGG_TO_ELM',
                                       'EVENT_BEAT_SAGE_LI', 'EVENT_BEAT_FALKNER', 'EVENT_BEAT_BUGSY',
                                       'EVENT_BEAT_WHITNEY', 'EVENT_BEAT_MORTY', 'EVENT_BEAT_CHUCK',
                                       'EVENT_BEAT_JASMINE', 'EVENT_BEAT_PRYCE', 'EVENT_BEAT_CLAIR',
                                       'EVENT_BEAT_ELITE_FOUR', 'EVENT_BEAT_RED',
                                       'EVENT_BEAT_CRYSTAL_VIOLET_CITY', 'EVENT_CLEARED_SLOWPOKE_WELL',
                                       'EVENT_RIVAL_AZALEA_TOWN', 'EVENT_HERDED_FARFETCHD', 'EVENT_GOT_HM01_CUT')}
        h.pb.screen.image.save(str(output / 'latest.png'))
        h.pb.screen.image.save(str(output / f'{commands:04d}.png'))
        with (output / 'latest.state').open('wb') as stream:
            h.pb.save_state(stream)
        journal.write(json.dumps(data) + '\n')
        print(json.dumps({**{key: data[key] for key in ('command', 'label', 'map', 'position', 'battle_mode',
                                                        'script_mode', 'badges', 'level_cap', 'farfetchd_position')},
                          'party': [(mon['species'], mon['level'], mon['hp']) for mon in party]}), flush=True)

    snapshot('resumed button-only playthrough' if args.resume else 'fresh game, no starter')
    try:
        for line in sys.stdin:
            try:
                command = json.loads(line)
                commands += 1
                journal.write(json.dumps(dict(input=command, command=commands)) + '\n')
                if command.get('quit'):
                    break
                if 'go' in command:
                    controls.go(command['go'], avoid=command.get('avoid', []))
                if 'travel' in command:
                    travel(command['travel'], avoid=command.get('avoid', []))
                if command.get('seek'):
                    targets = command['seek']['species']
                    waypoints = command['seek']['waypoints']
                    for attempt in range(command['seek'].get('limit', 200)):
                        if command['seek'].get('train_level') and h.battle.mem.read('wPartyMon1Level') >= command['seek']['train_level']:
                            break
                        if command['seek'].get('train_level') and not h.battle.mem.read_u16_be('wPartyMon1HP'):
                            break
                        if h.battle.mem.read('wBattleMode'):
                            # BattleMode is set before the encounter's species is
                            # loaded. Observe the actual command menu before
                            # deciding whether to catch or defeat this encounter.
                            for _ in range(400):
                                text = tile_text(h)
                                if 'FIGHT' in text and 'PACK' in text:
                                    break
                                controls.press('a', hold=4, wait=24)
                            name = h.con.species_by_index.get(h.battle.mem.species_index_of(h.battle.mem.read('wEnemyMonSpecies')), '')
                            if h.battle.mem.read('wBattleMode') == 1 and name in targets:
                                break
                            if command['seek'].get('train_best'):
                                current = h.battle.mem.read('wCurBattleMon')
                                partners = [slot for slot in range(h.battle.mem.read('wPartyCount'))
                                            if slot != current and controls.party_score(slot) > 0]
                                if partners:
                                    switch_battle(max(partners, key=controls.party_score) + 1)
                            elif command['seek'].get('train_slot'):
                                if not h.battle.mem.read_u16_be(f"wPartyMon{command['seek']['train_slot']}HP"):
                                    break
                                switch_battle(command['seek']['train_slot'])
                            controls.battle()
                        elif h.battle.mem.read('wScriptMode'):
                            # Encounter scripts set ScriptMode before BattleMode.
                            # Do not delegate to dialogue(), which would finish
                            # the battle before the requested species is checked.
                            controls.press('a', hold=4, wait=24)
                        else:
                            controls.go(waypoints[attempt % len(waypoints)])
                    else:
                        raise RuntimeError('Natural encounter search budget exhausted')
                if command.get('lead'):
                    lead(command['lead'])
                if command.get('interact'):
                    interact(command['interact']['at'], command['interact'].get('directions', ['up', 'down', 'left', 'right']))
                if command.get('edge'):
                    direction = command['edge']
                    width, height = h.battle.mem.read('wMapWidth') * 2, h.battle.mem.read('wMapHeight') * 2
                    if direction in ('up', 'down'):
                        goals = [(x, 0 if direction == 'up' else height - 1) for x in range(width)]
                    else:
                        goals = [(0 if direction == 'left' else width - 1, y) for y in range(height)]
                    reachable = []
                    for goal in goals:
                        if not controls.passable(controls.collision(*goal)):
                            continue
                        try:
                            reachable.append((len(controls.path(goal)), goal))
                        except RuntimeError:
                            pass
                    if not reachable:
                        raise RuntimeError('No currently walkable map connection in requested direction')
                    origin = controls.map_id()
                    travel(min(reachable)[1])
                    for _ in range(3):
                        if controls.map_id() != origin:
                            break
                        controls.press(direction, hold=12, wait=100)
                if command.get('switch_battle'):
                    switch_battle(command['switch_battle'])
                if command.get('move'):
                    choose_move(command['move'])
                if 'mash' in command:
                    controls.mash(command['mash'])
                if command.get('battle'):
                    controls.battle()
                if command.get('battle_frames'):
                    controls.battle(command['battle_frames'], partial=True)
                if command.get('scores'):
                    names = [h.con.moves_by_index.get(h.battle.mem.move_index_of(value), '')
                             for value in h.battle.mem.read_bytes('wBattleMonMoves', 4)]
                    print(json.dumps(dict(scores={name: controls.move_score(name) for name in names},
                                          cursor=h.battle.mem.read('wMenuCursorY'))), flush=True)
                if command.get('talk'):
                    controls.press(command['talk'], hold=24, wait=20)
                    controls.press('a', hold=4, wait=40)
                    dialogue()
                if command.get('dialogue'):
                    dialogue()
                if command.get('capture'):
                    capture()
                if command.get('door'):
                    origin = controls.map_id()
                    for _ in range(3):
                        if controls.map_id() != origin:
                            break
                        controls.press(command['door'], hold=48, wait=180)
                if command.get('save_continue'):
                    save_continue(h, controls.map_id())
                    install_observers()
                    dialogue()
                if command.get('grid'):
                    print(json.dumps(dict(grid=controls.grid(), objects=controls.objects())), flush=True)
                if command.get('inspect'):
                    x, y = controls.position()
                    print(json.dumps(dict(objects=controls.objects(), tiles={button: dict(
                        observed=h.battle.mem.read(symbol), predicted=controls.collision(x + dx, y + dy))
                        for button, symbol, dx, dy in (('up', 'wTileUp', 0, -1), ('down', 'wTileDown', 0, 1),
                                                     ('left', 'wTileLeft', -1, 0), ('right', 'wTileRight', 1, 0))},
                        paths={str(goal): controls.path(tuple(goal)) for goal in command['inspect'].get('paths', [])})), flush=True)
                if 'read' in command:
                    print(json.dumps({name: h.battle.mem.read(name) for name in command['read']}), flush=True)
                frames += controls.frames
                controls.frames = 0
                for action in command.get('actions', []):
                    button = action.get('button')
                    hold, wait = action.get('hold', 8), action.get('wait', 24)
                    repeats = action.get('repeat', 1)
                    for _ in range(repeats):
                        if button:
                            h.press(button, hold=hold, wait=wait)
                            frames += hold + wait
                        else:
                            h.tick(wait)
                            frames += wait
                snapshot(command.get('label', 'buttons'))
            except Exception as error:
                frames += controls.frames
                controls.frames = 0
                print(json.dumps(dict(error=repr(error))), flush=True)
                snapshot('command error: ' + repr(error))
    finally:
        private_rom = Path(h._rom_tempdir.name) / 'pokecrystal_debug.gbc'
        h.pb.stop(save=True)
        for suffix in ('.ram', '.rtc'):
            source = Path(str(private_rom) + suffix)
            if source.exists():
                shutil.copy2(source, output / source.name)
        journal.close()
        battle_journal.close()


if __name__ == '__main__':
    main()
