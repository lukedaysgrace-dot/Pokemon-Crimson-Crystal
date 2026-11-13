#!/usr/bin/env python3
"""Native checks and a preview of the Route 39 windmill.

Starts a private New Game, places the player on Route 39 below the windmill
and runs the game normally. Checks that:

* every one of the eight sail frames reaches VRAM bank 1 exactly as in
  gfx/tilesets/route39_windmill.png, in order, each held for one 13-VBlank
  Johto animation cycle (one upload per frame change);
* the windmill's 4x4 squares are solid;
* walking east to Route 38 and back keeps the sails turning.

Writes route39-windmill.gif (day and night) and a frame sheet to
_artifacts/route39-windmill/. Only private emulator state is used.

Usage: python3 tools/record_route39_windmill.py [rom]
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent / 'battletest'))

from PIL import Image

from runner import Harness
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from probability_checks import call
from safari_ui_checks import map_ids
from symbols import ROOT, _parse_constants

OUTPUT = ROOT / '_artifacts/route39-windmill'
RUNS = [(0x02, 18), (0x64, 12), (0x19, 2)]
SHADES = (255, 170, 85, 0)


def png_2bpp(path):
    im = Image.open(path).convert('L')
    px = im.load()
    data = bytearray()
    for ty in range(im.height // 8):
        for tx in range(im.width // 8):
            for y in range(8):
                lo = hi = 0
                for x in range(8):
                    c = min(range(4), key=lambda k: abs(px[tx * 8 + x, ty * 8 + y] - SHADES[k]))
                    lo |= (c & 1) << (7 - x)
                    hi |= (c >> 1) << (7 - x)
                data += bytes([lo, hi])
    return bytes(data)


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=rom)
    pb, m = h.pb, h.battle.mem
    maps = map_ids()
    events = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
    frames_data = png_2bpp(ROOT / 'gfx/tilesets/route39_windmill.png')
    frame_size = 32 * 16
    checks = 0

    def check(condition, label):
        nonlocal checks
        checks += 1
        if not condition:
            pb.screen.image.save(OUTPUT / 'failure.png')
            raise AssertionError(label)

    def vram1_frame():
        previous = pb.memory[0xff4f]
        pb.memory[0xff4f] = 1
        data = bytearray()
        for start, count in RUNS:
            base = 0x9000 + start * 16
            data += bytes(pb.memory[base:base + count * 16])
        pb.memory[0xff4f] = previous
        return bytes(data)

    def which_frame():
        current = vram1_frame()
        for f in range(8):
            if frames_data[f * frame_size:(f + 1) * frame_size] == current:
                return f
        return None

    def event(name, value):
        index = events[name]
        address, mask = h.sym.addr('wEventFlags') + index // 8, 1 << (index % 8)
        pb.memory[address] = pb.memory[address] | mask if value else pb.memory[address] & ~mask

    def idle():
        return (not m.read('wBattleMode') and not m.read('wScriptMode')
                and not m.read('hInMenu') and m.read('wMapStatus') == 2)

    def settle():
        for _ in range(600):
            if idle():
                break
            h.tick(4)
        h.tick(30)

    def clock(hour):
        m.write_bytes('wStringBuffer2', [0, hour, 0, 0])
        call(h, '_InitTime')
        call(h, 'UpdateTime')

    def stage(name, xy):
        for label, value in (('wMapGroup', maps[name][0]), ('wMapNumber', maps[name][1]),
                             ('wXCoord', xy[0]), ('wYCoord', xy[1]), ('wDefaultSpawnpoint', 255),
                             ('hMapEntryMethod', 0xf1)):
            m.write(label, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        settle()

    shots = []

    def film(count, every=2):
        for i in range(count):
            h.tick(1)
            if i % every == 0:
                shots.append(pb.screen.image.convert('RGB').copy())

    try:
        new_game(h, 0)
        event('EVENT_BEAT_PSYCHIC_NORMAN', True)
        clock(12)
        stage('ROUTE_39', (11, 6))
        check((m.read('wMapGroup'), m.read('wMapNumber')) == maps['ROUTE_39'], 'not on Route 39')

        # Collision: the four squares above the player belong to the windmill.
        x, y = m.read('wXCoord'), m.read('wYCoord')
        pb.button('up', 4)
        h.tick(40)
        check((m.read('wXCoord'), m.read('wYCoord')) == (x, y), 'walked into the windmill')

        # Sail frames: sample every VBlank for 8 full turns of the frame index.
        seen, changes, last, last_change, durations = [], 0, None, None, []
        for i in range(13 * 8 * 3):
            h.tick(1)
            f = which_frame()
            check(f is not None, f'VRAM holds a mixed/unknown windmill frame at sample {i}')
            if f != last:
                if last is not None:
                    check(f == (last + 1) % 8, f'frame {last} was followed by {f}')
                    if last_change is not None:
                        durations.append(i - last_change)
                    last_change = i
                    changes += 1
                last = f
                seen.append(f)
        check(set(seen) == set(range(8)), f'not every frame was shown: {sorted(set(seen))}')
        check(durations and all(d == 13 for d in durations), f'irregular frame durations {durations}')

        # Film: day, a walk to the left and back, then night.
        film(13 * 8 * 2)
        for button in ['left'] * 3 + ['right'] * 3:
            pb.button(button, 4)
            film(20)
        film(13 * 8)
        clock(22)
        stage('ROUTE_39', (11, 6))
        film(13 * 8 * 2)

        # Connection: leave east for Route 38 and come back.
        clock(12)
        stage('ROUTE_39', (17, 6))
        for _ in range(4):
            pb.button('right', 4)
            h.tick(24)
        settle()
        check((m.read('wMapGroup'), m.read('wMapNumber')) == maps['ROUTE_38'], 'did not reach Route 38')
        for _ in range(4):
            pb.button('left', 4)
            h.tick(24)
        settle()
        check((m.read('wMapGroup'), m.read('wMapNumber')) == maps['ROUTE_39'], 'did not return to Route 39')
        frames_after = set()
        for _ in range(13 * 3):
            h.tick(1)
            frames_after.add(which_frame())
        check(None not in frames_after and len(frames_after) >= 2, f'sails stopped after the connection: {frames_after}')

        scale = 3
        big = [s.resize((s.width * scale, s.height * scale), Image.NEAREST) for s in shots]
        big[0].save(OUTPUT / 'route39-windmill.gif', save_all=True, append_images=big[1:],
                    duration=33, loop=0, optimize=True)
        big[0].save(OUTPUT / 'route39-windmill-day.png')
        big[len(big) - 40].save(OUTPUT / 'route39-windmill-night.png')
        print(f'ROUTE 39 WINDMILL: {checks} checks passed in {rom.name}; frame durations {sorted(set(durations))}',
              flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
