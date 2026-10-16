#!/usr/bin/env python3
"""Check the rooftop balloon through real map rendering and A-button pickup.

Uses a fresh private New Game; never opens the player's save. Optionally
record the native animation and pickup with --record path/to/demo.mp4.
"""
import argparse
import io
import json
from pathlib import Path
import re
import subprocess
import wave

import numpy as np

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from runner import Harness
from save_menu_checks import begin_native_call
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--record', type=Path)
    parser.add_argument('--ffmpeg', type=Path, default=ROOT / '.tmpbuild/video-runtime/imageio_ffmpeg/binaries/ffmpeg-linux-x86_64-v7.0.2')
    args = parser.parse_args()
    output = args.record.parent if args.record else ROOT / '.tmpbuild/rooftop-balloon'
    output.mkdir(parents=True, exist_ok=True)
    h = Harness(sound_emulated=bool(args.record),
                emulator_kwargs={'sound_sample_rate': 48000} if args.record else None)
    pb, m = h.pb, h.battle.mem
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    fields = _parse_constants(ROOT / 'constants/map_object_constants.asm')
    flag = flags['EVENT_GOT_AIR_BALLOON_ON_ROOF']
    air = h.con.item_id('AIR_BALLOON')
    frames, audio = [], []
    recording = False
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def tick(count):
        for _ in range(count):
            pb.tick(1, True, bool(args.record))
            if recording:
                frames.append(pb.screen.image.convert('RGB').tobytes())
                audio.append(pb.sound.ndarray.copy().astype(np.int16) * 128)

    def press(button, hold=4, wait=24):
        pb.button(button, hold)
        tick(hold + wait)

    def event():
        return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))

    def quantity():
        return sum(m.read('wItems', i * 2 + 1)
                   for i in range(m.read('wNumItems'))
                   if m.read('wItems', i * 2) == air)

    def balloon():
        return next((obj for obj in controls.objects() if obj['map_object'] == 9), None)

    def enter(x=14, y=1):
        m.write('wMapGroup', roof[0])
        m.write('wMapNumber', roof[1])
        m.write('wXCoord', x)
        m.write('wYCoord', y)
        m.write('hMapEntryMethod', 0xF1)
        begin_native_call(h, 'OverworldLoop')
        tick(180)
        check(controls.map_id() == roof, 'Did not enter the real rooftop map')

    def approach():
        # The first tap can turn the player without taking a step.
        for _ in range(3):
            if controls.position() == (14, 0):
                break
            press('up', wait=36)
        check(controls.position() == (14, 0),
              f'Balloon cannot be approached normally: {controls.position()}')
        press('right', wait=18)
        check(controls.position() == (14, 0), 'Player walked through the balloon')

    def close_text():
        for _ in range(12):
            press('a', wait=32)
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
        raise AssertionError('Pickup dialogue did not finish: ' + tile_text(h))

    try:
        new_game(h, 0)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 0x41)
        m.write_bytes('wPlayerName', bytes([0x86, 0x8e, 0x8b, 0x83] + [0x50] * 7))  # GOLD
        controls = Controls(h)
        maps = {}
        group = number = 0
        for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
            if re.match(r'\s+newgroup\b', line):
                group += 1
                number = 0
            match = re.match(r'\s+map_const\s+(\w+),', line)
            if match:
                number += 1
                maps[match[1]] = (group, number)
        roof = maps['GOLDENROD_DEPT_STORE_ROOF']
        enter()
        obj = balloon()
        check(obj is not None and obj['position'] == [15, 0], 'Balloon missing or misplaced')
        base = obj['slot'] * 40
        check(m.read('wObjectStructs', base + fields['OBJECT_PALETTE']) & 7 == 0,
              'Balloon does not use the red NPC palette')
        seen = set()
        for _ in range(96):
            tick(1)
            seen.add(m.read('wObjectStructs', base + fields['OBJECT_FACING_STEP']))
        check(seen == {fields['FACING_STEP_DOWN_0'], fields['FACING_STEP_UP_0']},
              f'Balloon does not alternate its two frames: {seen}')
        check(balloon()['position'] == [15, 0], 'Animation moved the balloon off its tile')
        pb.screen.image.resize((480, 432)).save(output / 'roof-before.png')
        prepared = io.BytesIO()
        pb.save_state(prepared)

        # Fill the item pocket with legal, distinct item IDs, excluding the reward.
        bank, address = h.sym['ItemAttributes']
        stock = [item for item in range(1, 194) if item != air
                 and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
        check(len(stock) == 40, 'Could not construct a full item pocket')
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
        approach()
        press('a', wait=90)
        close_text()
        check(not event() and balloon() is not None and quantity() == 0,
              'Full Bag consumed the balloon or awarded the item')
        print('PASS full Bag leaves the balloon available', flush=True)

        prepared.seek(0)
        pb.load_state(prepared)
        check(not event() and quantity() == 0, 'Unclaimed fixture contains the reward')
        recording = bool(args.record)
        tick(180)
        approach()
        tick(60)
        press('a', wait=100)
        check(quantity() == 1, 'A-button interaction did not award one Air Balloon')
        pb.screen.image.resize((480, 432)).save(output / 'roof-received.png')
        tick(90)
        close_text()
        tick(120)
        recording = False
        check(event() and balloon() is None, 'Successful pickup did not hide the balloon')
        pb.screen.image.resize((480, 432)).save(output / 'roof-after.png')
        enter()
        check(balloon() is None and quantity() == 1 and event(),
              'Map re-entry respawned the balloon or duplicated the reward')
        check(flag == 0x18d, 'Pickup moved existing saved event IDs')
        print(f'PASS {checks} rooftop animation/pickup checks; one-time flag survives re-entry', flush=True)
    finally:
        pb.stop(save=False)

    if args.record:
        check(args.ffmpeg.is_file(), 'FFmpeg is unavailable for the requested recording')
        silent = output / 'roof-silent.mp4'
        command = [str(args.ffmpeg), '-y', '-v', 'error', '-f', 'rawvideo',
                   '-pixel_format', 'rgb24', '-video_size', '160x144', '-framerate', '60',
                   '-i', 'pipe:0', '-vf', 'scale=480:432:flags=neighbor', '-an',
                   '-c:v', 'libx264', '-pix_fmt', 'yuv420p', str(silent)]
        process = subprocess.Popen(command, stdin=subprocess.PIPE)
        for frame in frames:
            process.stdin.write(frame)
        process.stdin.close()
        check(process.wait() == 0, 'Video encoding failed')
        audio_path = output / 'roof-audio.wav'
        with wave.open(str(audio_path), 'wb') as stream:
            stream.setnchannels(2)
            stream.setsampwidth(2)
            stream.setframerate(48000)
            stream.writeframes(np.concatenate(audio).astype('<i2').tobytes())
        subprocess.run([str(args.ffmpeg), '-y', '-v', 'error', '-i', str(silent),
                        '-i', str(audio_path), '-c:v', 'copy', '-c:a', 'aac',
                        '-movflags', '+faststart', '-shortest', str(args.record)], check=True)
        (output / 'results.json').write_text(json.dumps(dict(checks=checks, frames=len(frames),
                                                           seconds=len(frames) / 60), indent=2))
        print('VIDEO', args.record, len(frames) / 60, 'seconds', flush=True)


if __name__ == '__main__':
    main()
