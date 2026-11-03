#!/usr/bin/env python3
"""Verify and record the native transmitter briefing, three KOs and departure.

Only the initial party, location and story flags are staged in private memory.
Ariana and all three Electrode are defeated through ordinary battle menus.
"""
import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants
from probability_checks import call
from ui_checks import tile_text
from record_lance_escort_scenes import Recording


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/rocket-transmitter')
    parser.add_argument('--entry', choices=('left', 'right'), default='left')
    parser.add_argument('--order', default='1,2,3')
    parser.add_argument('--no-video', action='store_true')
    parser.add_argument('--skip-electrode-battles', action='store_true',
                        help='Omit the three native Electrode battles from the recording')
    args = parser.parse_args()
    order = [int(n) for n in args.order.split(',')]
    if sorted(order) != [1, 2, 3]:
        parser.error('--order must contain each of 1,2,3 once')
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=not args.no_video,
                emulator_kwargs={'sound_sample_rate': 48000} if not args.no_video else {})
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    maps = map_ids()
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    recording, frame, last_a = None, 0, 0
    texts, moves, battles, departures, checks = [], [], [], [], []
    paths, previous, blocked, overlaps = {3: [], 4: []}, {}, [], []
    simultaneous = 0
    side_faults = []
    omit_battle = False

    def check(ok, label):
        if not ok:
            pb.screen.image.save(args.output / 'failure.png')
            (args.output / 'failure.json').write_text(json.dumps(dict(
                texts=texts, moves=moves, battles=battles, departures=departures,
                paths=paths, blocked=blocked, overlaps=overlaps, side_faults=side_faults), indent=2))
            raise AssertionError(label + '\n' + tile_text(h))
        checks.append(label)
        print('PASS', label, flush=True)

    def event(name, value=None):
        bit = flags[name]
        old, mask = m.read('wEventFlags', bit // 8), 1 << (bit % 8)
        if value is None:
            return bool(old & mask)
        m.write('wEventFlags', old | mask if value else old & ~mask, bit // 8)

    def actors():
        result = {}
        for obj in c.objects():
            obj['facing'] = m.read('wObjectStructs', obj['slot'] * 40 + 8)
            result[obj['map_object']] = obj
        return result

    def script_bytes(count):
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        return [pb.memory[m.read('wScriptBank'), pos + i] for i in range(count)]

    def text(_):
        nonlocal recording
        lo, hi = script_bytes(2)
        label = h.sym.nearest(m.read('wScriptBank'), lo | hi << 8)
        texts.append(dict(label=label, frame=frame, actors=actors(), player=c.position()))
        print('TEXT', label, c.position(), flush=True)
        if 'UnknownText_0x6d5d8' in label and not args.no_video and recording is None:
            recording = Recording(pb, args.output / 'transmitter-sequence.mp4')

    def movement(_):
        nonlocal omit_battle
        obj, lo, hi = script_bytes(3)
        label = h.sym.nearest(m.read('wScriptBank'), lo | hi << 8)
        moves.append(dict(object=obj - 1, frame=frame, label=label, actors=actors()))
        if any(name in label for name in ('MovementData_0x6d28c', 'MovementData_0x6d299', 'MovementData_0x6d2a4')):
            omit_battle = False

    def battle(_):
        battles.append(dict(frame=frame, trainer=m.read('wOtherTrainerClass'),
                            species=m.read('wTempWildMonSpecies')))

    def disappear(_):
        obj = script_bytes(1)[0] - 1
        if obj in (3, 4):
            departures.append(dict(object=obj, frame=frame, actor=actors().get(obj)))

    def tick(count=1):
        nonlocal frame, simultaneous
        for _ in range(count):
            pb.tick(1, True, not args.no_video)
            if recording and not omit_battle:
                recording.append()
            if texts and m.read('wPortraitShown'):
                texts[-1]['portrait_seen'] = m.read('wPortraitShown')
            if texts and frame == texts[-1]['frame'] + 90 and not m.read('wBattleMode'):
                pb.screen.image.save(args.output / f'text-{len(texts):02}.png')
            if c.map_id() == maps['TEAM_ROCKET_BASE_B2F'] and not m.read('wBattleMode'):
                current = actors()
                for obj in (3, 4):
                    actor = current.get(obj)
                    if not actor or min(actor['position'] + actor['next']) < 0:
                        previous.pop(obj, None)
                        continue
                    nxt = tuple(actor['next'])
                    old = previous.get(obj)
                    if old != nxt:
                        paths[obj].append(dict(frame=frame, position=nxt))
                        if not c.passable(c.collision(*nxt)):
                            blocked.append(dict(frame=frame, object=obj, position=nxt))
                        if old and sum(abs(a-b) for a, b in zip(old, nxt)) == 1:
                            delta = (nxt[0] - old[0], nxt[1] - old[1])
                            direction = {(0, 1): 'down', (0, -1): 'up', (1, 0): 'right', (-1, 0): 'left'}[delta]
                            if not c.permits_step(old, nxt, direction):
                                blocked.append(dict(frame=frame, object=obj, origin=old, position=nxt))
                        previous[obj] = nxt
                if 3 in current and 4 in current:
                    lance, dragon = current[3], current[4]
                    if (any('UnknownText_0x6d5d8' in t['label'] for t in texts)
                            and min(lance['position'] + dragon['position']) >= 0
                            and any(current[i]['position'] != current[i]['next'] for i in (3, 4))):
                        if (lance['next'][1] != dragon['next'][1]
                                or abs(lance['next'][0] - dragon['next'][0]) != 1
                                or lance['facing'] != dragon['facing']):
                            side_faults.append(dict(frame=frame, actors=current))
                    if (min(lance['position'] + dragon['position']) >= 0
                            and dragon['position'] != dragon['next']
                            and dragon['next'] == lance['next']):
                        overlaps.append(dict(frame=frame, actors=current))
                    simultaneous += int(all(current[i]['position'] != current[i]['next'] for i in (3, 4)))
            else:
                previous.clear()
            frame += 1

    def until(predicate, limit=45000):
        nonlocal last_a
        start = frame
        while frame - start < limit:
            if predicate():
                return
            if m.read('wBattleMode'):
                c.battle(limit=24000)
            else:
                if frame - last_a >= 150:
                    pb.button('a', 2)
                    last_a = frame
                tick()
        check(False, 'Native scene completes within the frame ceiling')

    def enter():
        group, number = maps['TEAM_ROCKET_BASE_B2F']
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                               wMapNumber=number, wXCoord=14 if args.entry == 'left' else 15,
                               wYCoord=10, hMapEntryMethod=0xf1).items():
            m.write(key, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)

    try:
        new_game(h, 0)
        m.write('wOptions', 0x21)
        m.write_bytes('wPlayerName', [0x86, 0x8e, 0x8b, 0x83] + [0x50] * 7)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        species = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MEWTWO'))
        m.write('wCurPartySpecies', species)
        m.write('wCurPartyLevel', 100)
        native_call(h, 'TryAddMonToParty')
        move_ids = [call(h, 'GetMoveIDFromIndex', HL=h.con.moves[name])
                    for name in ('PSYCHIC_M', 'EARTHQUAKE', 'THUNDERBOLT', 'SURF')]
        m.write_bytes('wPartyMon1Moves', move_ids)
        native_call(h, 'HealParty')
        check(m.read('wPartyCount') == 1 and m.read('wPartyMon1PP') > 0, 'Legal private party prepared')
        for name in ('EVENT_TEAM_ROCKET_BASE_B2F_DRAGONITE', 'EVENT_TEAM_ROCKET_BASE_B2F_EXECUTIVE',
                     'EVENT_TEAM_ROCKET_BASE_B2F_GRUNT_WITH_EXECUTIVE', 'EVENT_TEAM_ROCKET_BASE_B2F_LANCE',
                     'EVENT_LANCE_HEALED_YOU_IN_TEAM_ROCKET_BASE', 'EVENT_OPENED_DOOR_TO_ROCKET_HIDEOUT_TRANSMITTER'):
            event(name, True)
        for name in ('EVENT_CLEARED_ROCKET_HIDEOUT', 'EVENT_BEAT_ROCKET_EXECUTIVEF_2',
                     'EVENT_TEAM_ROCKET_BASE_POPULATION', 'EVENT_GOT_HM06_WHIRLPOOL',
                     'EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_1', 'EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_2',
                     'EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_3'):
            event(name, False)
        m.write('wTeamRocketBaseB2FSceneID', 1)
        # Controls uses the same tick path, so navigation and battle menus are
        # recorded frame for frame with audio rather than stitched afterwards.
        h.tick = tick
        for name, callback in (('Script_writetext', text), ('Script_applymovement', movement),
                               ('Script_startbattle', battle), ('Script_disappear', disappear)):
            pb.hook_register(*h.sym[name], callback, None)
        enter()
        pb.button('down', 16)
        tick(30)
        until(lambda: m.read('wTeamRocketBaseB2FSceneID') == 2
              and not m.read('wScriptRunning') and not ({3, 4} & actors().keys()))
        tick(60)
        check(event('EVENT_BEAT_ROCKET_EXECUTIVEF_2'), 'Ariana defeated through native battle menus')
        for label in ('UnknownText_0x6d5d8', 'UnknownText_0x6d64e', 'UnknownText_0x6d6cf'):
            speech = next(t for t in texts if label in t['label'])
            lance, dragon = speech['actors'][3], speech['actors'][4]
            check(dragon['position'][1] == lance['position'][1]
                  and abs(dragon['position'][0] - lance['position'][0]) == 1
                  and dragon['facing'] == (12 if label == 'UnknownText_0x6d64e' else lance['facing'])
                  and lance['facing'] == 0,
                  label + ': Dragonite stands beside Lance with the requested facing')
            check(speech.get('portrait_seen', 0), label + ': Lance keeps his portrait')
        first = next(t for t in texts if 'UnknownText_0x6d5d8' in t['label'])
        second = next(t for t in texts if 'UnknownText_0x6d64e' in t['label'])
        start_x, start_y = first['actors'][3]['position']
        between = [list(p['position']) for p in paths[3] if first['frame'] < p['frame'] < second['frame']]
        check(between == [[start_x + 1, start_y], [start_x + 2, start_y]],
              'After the young-guy line Lance takes exactly two rightward steps before addressing the player')
        machine = next(t for t in texts if 'UnknownText_0x6d6cf' in t['label'])
        x, y = second['actors'][3]['position']
        inspection = [list(p['position']) for p in paths[3] if second['frame'] < p['frame'] < machine['frame']]
        expected_inspection = [[x, y-1], [x, y-2], [x, y-3]]
        expected_inspection += [[x-i, y-3] for i in range(1, 5)]
        expected_inspection += [[x-4+i, y-3] for i in range(1, 9)]
        expected_inspection += [[x+4-i, y-3] for i in range(1, 5)]
        check(inspection == expected_inspection, 'Inspection reaches two tiles farther down each hall and returns to the starting spot')
        check(simultaneous >= 90, 'Lance and Dragonite walk together during the briefing sequence')
        check(c.position() == ((10 if args.entry == 'left' else 11), 10), 'Player reaches the usual Electrode approach')
        for index, electrode in enumerate(order):
            y = {1: 5, 2: 7, 3: 9}[electrode]
            c.go((8, y))
            check(c.position() == (8, y), f'Walks to Electrode {electrode} through the open floor')
            c.press('left', hold=4, wait=16)
            omit_battle = args.skip_electrode_battles
            c.press('a', hold=4, wait=30)
            if index == 2:
                until(lambda: event('EVENT_CLEARED_ROCKET_HIDEOUT') and not m.read('wScriptRunning'))
            else:
                until(lambda: event(f'EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_{electrode}')
                      and not m.read('wScriptRunning'))
                omit_battle = False
                tick(30)
            check(event(f'EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_{electrode}'), f'Electrode {electrode} defeated natively')
        tick(120)
        check(len(battles) == 4, 'One Ariana battle and exactly three Electrode battles')
        check(event('EVENT_GOT_HM06_WHIRLPOOL') and event('EVENT_CLEARED_ROCKET_HIDEOUT'), 'HM06 awarded and hideout cleared')
        check(not ({3, 4} & actors().keys()), 'Lance and Dragonite both depart after the Electrode are done')
        check(any('UnknownText_0x6d994' in t['label'] and {3, 4} <= t['actors'].keys() for t in texts),
              'Both companions remain visible for the final farewell')
        farewell = next(t for t in texts if 'UnknownText_0x6d994' in t['label'])
        check(farewell['actors'][4]['position'] == [15, 11]
              and farewell['actors'][3]['position'] == [14, 11]
              and farewell['actors'][4]['facing'] == farewell['actors'][3]['facing']
              and farewell['player'] == (13, 11), 'Final farewell keeps Dragonite beside Lance facing the same way')
        check(all(next(t for t in texts if label in t['label']).get('portrait_seen', 0)
                  for label in ('UnknownText_0x6d809', 'UnknownText_0x6d8f8', 'UnknownText_0x6d994')),
              'Lance keeps his portrait throughout the reward and farewell')
        exit_lance = next(d['actor'] for d in reversed(departures) if d['object'] == 3)
        exit_dragon = next(d['actor'] for d in reversed(departures) if d['object'] == 4)
        check(exit_lance and exit_dragon
              and exit_dragon['position'] == [exit_lance['position'][0] + 1, exit_lance['position'][1]]
              and all(c.position()[0] - actor['position'][0] > 5 for actor in (exit_lance, exit_dragon)),
              'Dragonite stays beside Lance until both walk off screen')
        check(not side_faults, 'Dragonite walks beside Lance facing the same way throughout every paired route')
        check(not blocked, 'Every Lance and Dragonite step stays on walkable tiles and respects wall edges')
        check(not overlaps, 'Dragonite never walks onto Lance during the escort')
        check(not h.text_overflows, 'Dialogue fits the text box')
        video = recording.finish() if recording else None
        recording = None
        # A normal map reload after completion must not restore either actor.
        m.write('hMapEntryMethod', 0xf1)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)
        check(not ({3, 4, 15} & actors().keys()), 'All Lance/Dragonite scene objects stay gone on re-entry')
        (args.output / 'checks.json').write_text(json.dumps(dict(rom=h.rom_key(), entry=args.entry,
            order=order, checks=checks, video=video, texts=texts, movements=moves, battles=battles,
            departures=departures, paths=paths, simultaneous_frames=simultaneous,
            blocked=blocked, overlaps=overlaps, side_faults=side_faults,
            electrode_battles_omitted=args.skip_electrode_battles), indent=2) + '\n')
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
