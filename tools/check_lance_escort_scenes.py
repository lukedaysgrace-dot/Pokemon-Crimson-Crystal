#!/usr/bin/env python3
"""Exercise Lance's mart procession and both B2F healing approaches in PyBoy.

Only starting maps, story flags and an injured party are staged in private
emulator memory. Scene movement, healing and subsequent map entry are native.
"""
import argparse
import io
import json
from pathlib import Path
import sys

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants
from ui_checks import tile_text
from probability_checks import call


def run(rom, output):
    output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=rom)
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    maps = map_ids()
    checks, results, texts, departures, trace, pictures = [], {}, [], [], [], []
    frame = 0

    def check(ok, label):
        if not ok:
            pb.screen.image.save(output / 'failure.png')
            print('PARTY', dict(count=m.read('wPartyCount'), hp=m.read_u16_be('wPartyMon1HP'),
                              maximum=m.read_u16_be('wPartyMon1MaxHP'), status=m.read('wPartyMon1Status'),
                              pp=list(m.read_bytes('wPartyMon1PP', 4)), moves=list(m.read_bytes('wPartyMon1Moves', 4))), flush=True)
            (output / 'failure.json').write_text(json.dumps(dict(texts=texts, departures=departures, trace=trace), indent=2))
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
        lo, hi = script_bytes(2)
        label = h.sym.nearest(m.read('wScriptBank'), lo | hi << 8)
        texts.append(dict(label=label, frame=frame, actors=actors(), player=c.position()))

    def disappear(_):
        obj = script_bytes(1)[0] - 1
        departures.append(dict(object=obj, frame=frame, actor=actors().get(obj)))

    def tick(count=1):
        nonlocal frame
        for _ in range(count):
            pb.tick(1, True, False)
            current = actors()
            trace.append(dict(frame=frame, player=c.position(), actors=current))
            if texts and m.read('wPortraitShown'):
                texts[-1]['portrait_seen'] = m.read('wPortraitShown')
            if texts and frame == texts[-1]['frame'] + 65:
                texts[-1]['portrait'] = m.read('wPortraitShown')
                pic = pb.screen.image.copy()
                pictures.append(pic)
                pic.save(output / f'text-{len(pictures):02}.png')
            frame += 1

    def enter(name, x, y):
        group, number = maps[name]
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                               wMapNumber=number, wXCoord=x, wYCoord=y,
                               hMapEntryMethod=0xf1).items():
            m.write(key, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')

    def finish(scene, value, limit=3600):
        for i in range(limit):
            if i % 85 == 84:
                pb.button('a', 2)
            tick()
            if m.read(scene) == value and not m.read('wScriptRunning'):
                tick(50)
                return
        check(False, 'Scene did not finish')

    def reset():
        nonlocal frame
        pb.load_state(io.BytesIO(base.getvalue()))
        texts.clear()
        departures.clear()
        trace.clear()
        frame = 0

    try:
        new_game(h, 0)
        m.write('wOptions', 0x21)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        species = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('TOTODILE'))
        m.write('wCurPartySpecies', species)
        m.write('wCurPartyLevel', 20)
        native_call(h, 'TryAddMonToParty')
        check(m.read('wPartyCount') == 1, 'Private native party created')
        base = io.BytesIO()
        pb.save_state(base)
        pb.hook_register(*h.sym['Script_writetext'], text, None)
        pb.hook_register(*h.sym['Script_disappear'], disappear, None)

        for x in (3, 4):
            reset()
            for flag in ('EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE',
                         'EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART',
                         'EVENT_CLEARED_ROCKET_HIDEOUT'):
                event(flag, False)
            event('EVENT_DECIDED_TO_HELP_LANCE', True)
            m.write('wMahoganyMart1FSceneID', 1)
            enter('MAHOGANY_MART_1F', x, 7)
            finish('wMahoganyMart1FSceneID', 0)
            greeting = next(t for t in texts if 'UnknownText_0x6c549' in t['label'])
            stairs = next(t for t in texts if 'UnknownText_0x6c5ba' in t['label'])
            reveal = next(t for t in texts if 'UnknownText_0x6c59e' in t['label'])
            check(4 in greeting['actors'], f'Mart entry {x}: Dragonite stays after Hyper Beam')
            check(stairs['actors'][3]['position'] == [6, 3]
                  and stairs['actors'][4]['position'] == [5, 2]
                  and stairs['player'] == (5, 3), f'Mart entry {x}: Dragonite yields for Lance to address player')
            check(all(t['actors'][4]['position'] == [5, 2] and t['actors'][4]['facing'] == 0
                      for t in (reveal, stairs)), f'Mart entry {x}: Dragonite waits above the player facing down')
            check(reveal['actors'][3]['facing'] == 8 and reveal.get('portrait_seen', 0)
                  and stairs.get('portrait_seen', 0), f'Mart entry {x}: Lance faces player and keeps his dialogue portrait')
            trio = {t['frame'] for t in trace if all(i in t['actors'] for i in (3, 4))
                    and all(t['actors'][i]['position'] != t['actors'][i]['next'] for i in (3, 4))}
            player_moving = any(a['player'] != b['player'] and a['frame'] in trio for a, b in zip(trace, trace[1:]))
            check(player_moving, f'Mart entry {x}: all three move during the procession')
            for obj in (3, 4):
                exit_ = next(d for d in departures if d['object'] == obj)
                check(exit_['actor']['position'] == [7, 3], f'Mart entry {x}: actor {obj} uses the stair tile')
            dragon_route = {tuple(t['actors'][4]['next']) for t in trace
                            if 4 in t['actors'] and min(t['actors'][4]['next']) >= 0}
            check(all(c.passable(c.collision(*pos)) for pos in dragon_route),
                  f'Mart entry {x}: Dragonite never walks through blocked furniture')
            check(not ({3, 4} & actors().keys()) and event('EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART'),
                  f'Mart entry {x}: stairs open and both companions leave')
            results[f'mart-{x}'] = dict(texts=list(texts), departures=list(departures), trace=list(trace))
            c.go((7, 3))
            tick(90)
            check(c.map_id() == maps['TEAM_ROCKET_BASE_B1F'], f'Mart entry {x}: player can use the revealed stairs')
            enter('MAHOGANY_MART_1F', 5, 5)
            tick(90)
            check(not ({3, 4} & actors().keys()), f'Mart entry {x}: companions stay gone on re-entry')

        for approach, start, button in (('south', (5, 15), 'up'), ('west', (3, 14), 'up')):
            reset()
            event('EVENT_LANCE_HEALED_YOU_IN_TEAM_ROCKET_BASE', False)
            event('EVENT_TEAM_ROCKET_BASE_B2F_LANCE', False)
            event('EVENT_TEAM_ROCKET_BASE_B2F_DRAGONITE', True)
            m.write('wTeamRocketBaseB2FSceneID', 0)
            m.write_bytes('wPartyMon1HP', [0, 1])
            m.write('wPartyMon1Status', 0x40)
            m.write('wPartyMon1PP', 0)
            enter('TEAM_ROCKET_BASE_B2F', *start)
            tick(80)
            check(actors()[15]['position'] == [4, 13] and actors()[3]['position'] == [5, 13],
                  f'Healing {approach}: Dragonite stands one tile left of Lance')
            pb.button(button, 16)
            finish('wTeamRocketBaseB2FSceneID', 1)
            check(m.read_u16_be('wPartyMon1HP') == m.read_u16_be('wPartyMon1MaxHP')
                  and not m.read('wPartyMon1Status') and m.read('wPartyMon1PP') > 0,
                  f'Healing {approach}: native healing restores HP, status and PP')
            check(any(all(i in t['actors'] and t['actors'][i]['position'] != t['actors'][i]['next']
                          for i in (3, 15)) for t in trace), f'Healing {approach}: Dragonite walks behind Lance')
            check(not ({3, 15} & actors().keys()), f'Healing {approach}: both companions leave')
            results[f'healing-{approach}'] = dict(texts=list(texts), departures=list(departures), trace=list(trace))
            enter('TEAM_ROCKET_BASE_B2F', *start)
            tick(90)
            check(not ({3, 15} & actors().keys()) and 4 not in actors(),
                  f'Healing {approach}: companions stay gone; later-scene Dragonite stays hidden')
        check(not h.text_overflows, 'Dialogue fits the text box')
        if pictures:
            sheet = Image.new('RGB', (160 * 4, 144 * ((len(pictures) + 3) // 4)))
            for i, pic in enumerate(pictures):
                sheet.paste(pic, (i % 4 * 160, i // 4 * 144))
            sheet.resize((1280, sheet.height * 2), Image.Resampling.NEAREST).save(output / 'scenes.png')
        (output / 'checks.json').write_text(json.dumps(dict(rom=h.rom_key(), checks=checks, scenes=results), indent=2) + '\n')
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/lance-escort-scenes')
    args = parser.parse_args()
    run(args.rom, args.output)
