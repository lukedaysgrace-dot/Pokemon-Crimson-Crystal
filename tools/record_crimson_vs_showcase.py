#!/usr/bin/env python3
"""Record the Crimson VS intro for a gallery of important trainers.

Each case loads a private New Game into the trainer's own map, stands the
player beside them, then starts the battle through the game's script engine
(`loadtrainer` + `startbattle`, exactly what the map scripts run after their
dialogue). Everything that follows is native: trainer music selection, the
skipped overworld wipe, the VS interstitial, the entrance and the send-out.
Recording stops 90 frames after the Fight menu appears. Every frame before
the trainer slide is checked: the three native trainer flashes, no white
frame before the VS, and VS sound cues only on the noise channel, never over
a theme that has its own drums. SameBoy supplies the
video and game audio; no player save is opened.

    python3 tools/record_crimson_vs_showcase.py [--rom pokecrystal.gbc]
        [--only CLAIR,ARCHER] [--output _artifacts/vs-intro/showcase]
"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys

import imageio_ffmpeg

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from record_league_walkthrough import Tour, Movie, FPS
from ui_checks import tile_text
from symbols import _parse_constants

MUSIC = _parse_constants(ROOT/'constants/music_constants.asm')
CHARMAP = {ch: int(value, 16) for ch, value in re.findall(r'charmap "([^"\n]+)",\s*\$([0-9a-fA-F]+)',
                                                        (ROOT/'charmap.asm').read_text())}
LOADTRAINER, STARTBATTLE, END = 0x5e, 0x5f, 0x91
RGB = lambda r, g, b: (r | g << 5 | b << 10).to_bytes(2, 'little')
VS_RAILS = b''.join(RGB(*c) for c in [(2, 1, 3), (5, 5, 8), (13, 14, 17), (28, 28, 30)])  # BG palette 1

# name, class, trainer id, map, player x/y, event flags that hide the trainer,
# and the battle theme PlayBattleMusic must pick.
CASES = [
    ('lance', 'CHAMPION', 'LANCE', 'LANCES_ROOM', (5, 4), [], 'MUSIC_CHAMPION_BATTLE'),
    ('clair', 'CLAIR', 'CLAIR1', 'BLACKTHORN_GYM_1F', (5, 4), [], 'MUSIC_JOHTO_GYM_LEADER_BATTLE'),
    ('crystal', 'CRYSTAL3', 'CRYSTAL3_CYNDAQUIL', 'ROUTE_25', (48, 8),
     ['EVENT_ROUTE_25_CRYSTAL'], 'MUSIC_CRYSTAL_BATTLE'),
    ('archer', 'ARCHER', 'ARCHER2', 'RADIO_TOWER_5F', (12, 5),
     ['EVENT_RADIO_TOWER_ROCKET_TAKEOVER'], 'MUSIC_ROCKET_EXECUTIVE_BATTLE'),
    ('rival', 'RIVAL1', 'RIVAL1_5_TOTODILE', 'VICTORY_ROAD', (18, 14),
     ['EVENT_RIVAL_VICTORY_ROAD'], 'MUSIC_RIVAL_BATTLE'),
    ('eusine', 'MYSTICALMAN', 'EUSINE2', 'ECRUTEAK_CITY', (32, 5),
     ['EVENT_ECRUTEAK_CITY_EUSINE'], None),
]


def trainer_ids():
    """{CLASS: {TRAINER_CONST: id}} from constants/trainer_constants.asm,
    including `NAME EQU OTHER` aliases (CRYSTAL3 reuses Crystal's parties)."""
    result, current, number, every = {}, None, 0, {}
    for line in (ROOT/'constants/trainer_constants.asm').read_text().splitlines():
        line = line.split(';')[0]
        match = re.match(r'\s*trainerclass\s+(\w+)', line)
        if match:
            current, number = match.group(1), 0
            result[current] = {}
            continue
        match = re.match(r'\s*const\s+(\w+)', line)
        if match and current:
            number += 1
            result[current][match.group(1)] = every[match.group(1)] = number
            continue
        match = re.match(r'(\w+)\s+EQU\s+(\w+)\s*$', line)
        if match and current and match.group(2) in every:
            result[current][match.group(1)] = every[match.group(2)]
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/vs-intro/showcase')
    parser.add_argument('--only', default='')
    parser.add_argument('--name', default='Luke', help="player name shown under the portrait")
    parser.add_argument('--rival', default='SILVER', help='rival name (a fresh New Game has none)')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    ids = trainer_ids()
    wanted = {name.strip().lower() for name in args.only.split(',') if name.strip()}
    s = Tour(args.rom, args.output)
    results = []
    try:
        s.setup()
        base = bytes(s.save())
        classes = s.con.trainer_classes
        for name, cls, trainer, map_name, (x, y), hidden, theme in CASES:
            if wanted and name not in wanted:
                continue
            s.load(base)
            for flag in hidden:
                bit = s.events[flag]
                value = s.m.read('wEventFlags', bit//8) & ~(1 << (bit % 8))
                s.m.write('wEventFlags', value, bit//8)
            group, number = s.maps[map_name]
            for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                   wXCoord=x, wYCoord=y, hMapEntryMethod=0xf1).items():
                s.m.write(key, value)
            s.m.write_bytes('wPlayerName', bytes(CHARMAP[ch] for ch in args.name)+b'\x50')
            s.m.write_bytes('wRivalName', bytes(CHARMAP[ch] for ch in args.rival)+b'\x50')
            s.invoke('EnterMap')
            s.m.write('hOAMUpdate', 0)
            s.begin('OverworldLoop.loop')
            s.tick(150)  # let the map-name sign close before recording
            path = args.output/f'{name}.mp4'
            s.movie = Movie(s, path)
            start = s.frames
            s.tick(60)  # a moment of the map and its music first
            # Hand the map a two-command script, as its own battle script would.
            script = bytes([LOADTRAINER, classes[cls], ids[cls][trainer], STARTBATTLE, END])
            s.m.write_bytes('wStringBuffer5', script)
            bank, address = s.sym['wStringBuffer5']
            s.m.write('wScriptBank', s.m.read('hROMBank'))
            s.m.write_bytes('wScriptPos', bytes([address & 0xff, address >> 8]))
            s.m.write('wScriptMode', 1)  # SCRIPT_READ
            movie, s.movie = s.movie, None
            s.begin('ScriptEvents')
            s.movie = movie
            # Until the ordinary trainer slide begins, watch every frame: the VS
            # cues may only use the noise channel, and only when the theme has
            # no drums of its own; the overworld flashes three times (the native
            # trainer flash) and no white LCD-off frame appears before the VS.
            watch = dict(active=True, bright=False, flashes=0, cues=0, drums=False, vs=False, white=0)
            original_tick = s.tick

            def tick(count=1, keys=0):
                for _ in range(count):
                    original_tick(1, keys)
                    if not watch['active']:
                        continue
                    if s.m.read('hLCDCPointer') == 0x43:
                        watch['active'] = False
                        continue
                    for channel in (5, 6, 7):
                        assert not s.m.read(f'wChannel{channel}Flags1') & 1, (name, 'VS cue took music voice', channel)
                    drums = bool(s.m.read('wChannel4Flags1') & 1)
                    watch['drums'] |= drums
                    if s.m.read('wChannel8Flags1') & 1:
                        assert not drums, (name, 'VS cue over the theme\'s drums')
                        watch['cues'] += 1
                    if not watch['vs']:
                        # Count the flash's brightest step (wBGP 0), once the first
                        # flash step (3,3,2,1) has replaced the overworld's own value.
                        bgp = s.m.read('wBGP')
                        watch['started'] = watch.get('started') or bgp == 0b11111001
                        bright = watch['started'] and bgp == 0
                        watch['flashes'] += bright and not watch['bright']
                        watch['bright'] = bright
                        low, high = s.image().convert('L').getextrema()
                        watch['white'] += low == 255
                        # The VS has begun once its gunmetal rail palette is shown.
                        watch['vs'] = (s.m.read_bytes('wBGPals2', 8, 8) == VS_RAILS
                                       and not s.m.read('hCGBPalUpdate') and high > 0)
            s.tick = tick
            try:
                s.until(lambda: 'FIGHT' in tile_text(s), limit=9000, dialogue=True)
            finally:
                s.tick = original_tick
            assert watch['flashes'] == 3, (name, 'trainer flashes', watch['flashes'])
            assert watch['vs'] and not watch['white'], (name, 'white frames before the VS', watch['white'])
            assert watch['cues'] or watch['drums'], (name, 'drumless theme should carry the VS cues')
            song = int.from_bytes(s.m.read_bytes('wChannel1MusicID', 2), 'little')
            s.tick(90)
            record = s.movie.finish()
            s.movie = None
            if theme:
                assert song == MUSIC[theme], (name, song, MUSIC[theme])
            results.append(dict(case=name, trainer_class=cls, trainer=trainer, map=map_name,
                                music=next((k for k, v in MUSIC.items() if v == song), song),
                                video=record, start_frame=start, trainer_flashes=watch['flashes'], white_frames_before_vs=watch['white'],
                                theme_has_drums=watch['drums'], noise_cue_frames=watch['cues'],
                                vs_cues_never_take_a_music_voice=True))
            print('RECORDED', name, flush=True)
        (args.output/'results.json').write_text(json.dumps(results, indent=2)+'\n')
    except Exception:
        s.image().save(args.output/'failure.png')
        (args.output/'failure.txt').write_text(tile_text(s))
        if s.movie:
            s.movie.finish()
        raise
    finally:
        s.close()


if __name__ == '__main__':
    main()
