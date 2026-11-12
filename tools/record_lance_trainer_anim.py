#!/usr/bin/env python3
"""Record Lance's first Champion battle intro with his animated battle picture.

A private New Game (shared with record_league_walkthrough.py's lobby fixture)
is staged at Lance's room entrance. While recording, only ordinary buttons are
pressed: the native door-lock scene, the walk to Lance's approach trigger, his
dialogue, the battle transition, the animated picture and his first send-out.
Every recorded frame's opponent-picture area is matched against the frames of
gfx/trainers/animated/champion/front.png to prove the native animation order.
Writes lance-first-battle.mp4, a frame sheet and results.json to --output.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from record_league_walkthrough import Tour, Movie, FPS  # noqa: E402
from ui_checks import tile_text  # noqa: E402

STRIP = ROOT / 'gfx/trainers/animated/champion/front.png'
ANIM = ROOT / 'gfx/trainers/animated/champion/anim.asm'
PIC_BOX = (96, 0, 152, 56)  # hlcoord 12, 0; 7x7 tiles


def strip_frames():
    strip = Image.open(STRIP)
    assert strip.mode == 'P' and strip.width == 56 and strip.height % 56 == 0
    return [list(strip.crop((0, 56 * k, 56, 56 * k + 56)).getdata()) for k in range(strip.height // 56)]


def script():
    steps = []
    for line in ANIM.read_text().splitlines():
        line = line.split(';')[0].strip()
        if line.startswith('frame'):
            index, duration = (int(x) for x in line.split(None, 1)[1].split(','))
            steps.append((index, duration))
    return steps


def identify(image, frames):
    """Return the strip frame shown in the opponent picture box, if any.

    The screen uses the CGB palette, so accept a frame when a one-to-one
    mapping exists between its four indices and the displayed colors."""
    pixels = list(image.crop(PIC_BOX).getdata())
    matches = []
    for k, frame in enumerate(frames):
        forward, backward = {}, {}
        for index, color in zip(frame, pixels):
            if forward.setdefault(index, color) != color or backward.setdefault(color, index) != index:
                break
        else:
            matches.append(k)
    return matches[0] if len(matches) == 1 else None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal_debug.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/lance-trainer-anim')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    frames, steps = strip_frames(), script()

    s = Tour(args.rom, args.output)
    try:
        s.setup()
        group, number = s.maps['LANCES_ROOM']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                wXCoord=4, wYCoord=23, hMapEntryMethod=0xf1).items():
            s.m.write(name, value)
        s.invoke('EnterMap')
        s.m.write('hOAMUpdate', 0)
        s.begin('OverworldLoop.loop')

        seen = []  # (recorded frame, strip frame) at each change
        latest = {}  # strip frame -> last screen showing it (after palette fades)
        last = None
        original_tick = s.tick

        def tick(count=1, keys=0):
            nonlocal last
            for _ in range(count):
                original_tick(1, keys)
                image = s.image() if s.m.read('wBattleMode') else None
                shown = identify(image, frames) if image else None
                if shown is not None:
                    latest[shown] = image
                if shown is not None and shown != last:
                    seen.append((s.frames, shown))
                    image.save(args.output / f'pic-{len(seen):02d}-frame{shown}.png')
                last = shown
        s.tick = tick

        s.movie = Movie(s, args.output / 'lance-first-battle.mp4')
        s.until(lambda: s.event('EVENT_LANCES_ROOM_ENTRANCE_CLOSED') and not s.m.read('wScriptMode'))
        s.tick(60)
        s.c.go((4, 5))  # Native approach trigger.
        s.until(lambda: bool(s.m.read('wBattleMode')), limit=18000, dialogue=True)
        battle_start = s.frames
        # Watch the whole intro before pressing anything in battle.
        s.tick(420)
        s.until(lambda: 'FIGHT' in tile_text(s), limit=3000, dialogue=True)
        s.tick(90)
        record = s.movie.finish()
        s.movie = None
    except Exception:
        s.image().save(args.output / 'failure.png')
        (args.output / 'failure.txt').write_text(tile_text(s))
        if s.movie:
            s.movie.finish()
        raise
    finally:
        s.close()

    # The intro must show every scripted step, in order, with native timing.
    intro = [(f, k) for f, k in seen if f >= battle_start]
    order = [k for _, k in intro]
    expected = [k for k, _ in steps]
    start = next(i for i in range(len(order)) if order[i:i + len(expected)] == expected)
    timed = intro[start:start + len(expected)]
    durations = [b[0] - a[0] for a, b in zip(timed, timed[1:])]
    # Frame 0 is already on screen from the slide-in, so its first step only
    # starts the script; every later change must follow the scripted duration.
    for (index, duration), measured in list(zip(steps, durations))[1:]:
        assert abs(measured - duration) <= 1, (index, duration, measured)

    sheet = Image.new('RGB', (56 * 4 * len(frames) + 8 * (len(frames) - 1), 56 * 4), 'white')
    for k in range(len(frames)):
        shot = latest[k].crop(PIC_BOX)
        sheet.paste(shot.resize((224, 224), Image.Resampling.NEAREST), (k * 232, 0))
    sheet.save(args.output / 'lance-native-frames.png')

    result = dict(rom=args.rom.name, sha256=hashlib.sha256(args.rom.read_bytes()).hexdigest(),
                  emulator='SameBoy', native_game_audio=True, buttons_only_during_recording=True,
                  expected_steps=steps, observed_changes=intro, scripted_durations_measured=durations,
                  video=record)
    (args.output / 'results.json').write_text(json.dumps(result, indent=2))
    print('OK', order, durations, round(record['seconds'], 1), 'seconds', flush=True)


if __name__ == '__main__':
    main()
