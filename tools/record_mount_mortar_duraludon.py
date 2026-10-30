#!/usr/bin/env python3
"""Check and record native Duraludon wandering, dialogue, cry and battle.

Stages location and a test party in a private PyBoy fixture. Wandering,
interaction and battle run normally; no player save is read or changed.
"""
import argparse
from collections import Counter
import json
from pathlib import Path
import subprocess
import sys
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from state import Request
from symbols import _parse_constants
from probability_checks import call
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from ui_checks import tile_text


class RecordingHarness(Harness):
    def fixture_path(self):
        path = super().fixture_path()
        return path.with_name(path.stem + '-audio-48000.state')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/mount-mortar-duraludon')
    args = parser.parse_args()
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    h = RecordingHarness(verbose=True, sound_emulated=True,
                         emulator_kwargs={'sound_sample_rate': 48000})
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    checks, positions, phases, interactions = [], set(), set(), []
    frames = 0
    recording = False
    encoder = audio = None
    wandering = True
    asset = (ROOT / 'gfx/sprites/duraludon.2bpp').read_bytes()

    def check(ok, label):
        if not ok:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(label + '\n' + tile_text(h))
        checks.append(label)
        print('PASS', label, flush=True)

    def event(value=None):
        bit = flags['EVENT_MOUNT_MORTAR_DURALUDON']
        address = h.sym.addr('wEventFlags') + bit // 8
        mask = 1 << (bit % 8)
        if value is not None:
            pb.memory[address] = pb.memory[address] | mask if value else pb.memory[address] & ~mask
        return bool(pb.memory[address] & mask)

    def actor():
        for slot in range(1, 13):
            address = h.sym.addr('wObjectStructs') + slot * 40
            if pb.memory[address] == sprites['SPRITE_DURALUDON']:
                return address
        return None

    def xy():
        address = actor()
        return (pb.memory[address+18]-4, pb.memory[address+19]-4) if address else None

    def tick(n=1):
        nonlocal frames
        for _ in range(n):
            pb.tick(1, True, True)
            address = actor()
            if wandering and address:
                positions.add(xy())
                phases.add(pb.memory[address+13])
            if recording:
                if frames % 2 == 0:
                    encoder.stdin.write(pb.screen.image.convert('RGB').resize(
                        (640, 576), Image.Resampling.NEAREST).tobytes())
                audio.writeframesraw((pb.sound.ndarray.astype(np.int16) * 256).tobytes())
                frames += 1

    def hook(label):
        entry = dict(label=label, seconds=round(frames * 4389 / 262144, 3))
        if label == 'Script_cry':
            bank = m.read('wScriptBank')
            pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
            entry['species'] = pb.memory[bank, pos] | pb.memory[bank, pos+1] << 8
        interactions.append(entry)

    def stage(finished=False):
        h.load_fixture()
        event(finished)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', Request(h.battle)._side_bytes(dict(
            species='MEW', level=100, moves=['AURA_SPHERE', 'SURF', 'ICE_BEAM', 'RECOVER'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wInBattleTowerBattle'):
            m.write(name, 0)
        m.write('wOptions', 0x41)
        m.write('wRepelEffect', 250)
        group, number = map_ids()['MOUNT_MORTAR_B1F']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                                wMapNumber=number, wXCoord=18, wYCoord=5,
                                hMapEntryMethod=0xf1).items():
            m.write(name, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(60)

    def approach():
        # Chase the naturally wandering actor using only ordinary directional
        # input; inspect both tiles so we do not talk to a vacated square.
        directions = {(0, -1): 'up', (0, 1): 'down', (-1, 0): 'left', (1, 0): 'right'}
        for _ in range(80):
            target = xy()
            x, y = controls.position()
            delta = target[0]-x, target[1]-y
            if delta in directions:
                controls.press(directions[delta], hold=1, wait=8)
                controls.press('a', hold=4, wait=10)
                if m.read('wScriptRunning') or m.read('wScriptMode'):
                    return
            candidates = []
            for dx, dy in directions:
                goal = target[0]+dx, target[1]+dy
                try:
                    path = controls.path(goal)
                    if path:
                        candidates.append(path)
                except RuntimeError:
                    pass
            if candidates:
                controls.press(min(candidates, key=len)[0], hold=4, wait=24)
            else:
                tick(10)
        raise RuntimeError('Could not approach Duraludon')

    h.tick = tick
    for label in ('Script_writetext', 'Script_cry', 'Script_startbattle'):
        pb.hook_register(*h.sym[label], hook, label)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    try:
        h.ensure_fixture()
        stage()
        interactions.clear()
        check(actor() is not None, 'Duraludon appears in Mt. Mortar B1F')
        check(m.read('wMap7ObjectXCoord') == 20 and m.read('wMap7ObjectYCoord') == 8,
              'Spawn origin is Kiyo\'s original (16,4) training spot')
        counts = Counter(((asset[i] >> bit) & 1) | (((asset[i+1] >> bit) & 1) << 1)
                         for i in range(0, len(asset), 2) for bit in range(8))
        check(counts == {0: 658, 1: 347, 2: 83, 3: 448},
              'Every gray source pixel compiles as opaque color 1')
        check(m.read_bytes('wOBPals1', 8, 8) == bytes.fromhex('ff7f39672a7d0000'),
              'Dedicated palette contains neutral gray, blue and black')
        address = actor()
        tile = pb.memory[address+2]
        bank = 0 if tile & 128 else 1
        vram = 0x8000 + (tile & 127) * 16
        check(bytes(pb.memory[bank, vram:vram+192]) == asset[:192]
              and bytes(pb.memory[bank, vram+0x800:vram+0x800+192]) == asset[192:],
              'Standing and walking graphics are intact in actual map VRAM')
        check(not any('DURALUDON' in p.read_text() for p in (ROOT / 'data/wild').glob('*.asm')),
              'Duraludon is absent from every random encounter table')
        positions.clear()
        phases.clear()
        encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
            '-pixel_format', 'rgb24', '-video_size', '640x576', '-framerate', '131072/4389',
            '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
            '-pix_fmt', 'yuv420p', str(out / 'silent.mp4')], stdin=subprocess.PIPE)
        audio = wave.open(str(out / 'audio.wav'), 'wb')
        audio.setnchannels(2)
        audio.setsampwidth(2)
        audio.setframerate(pb.sound.sample_rate)
        recording = True
        tick(600)
        pb.screen.image.save(out / 'wandering.png')
        check(len(positions) >= 3 and any(p & 3 in (1, 3) for p in phases),
              'Native wandering visits multiple tiles and uses walking poses')
        check(all(15 <= x <= 17 and 3 <= y <= 5 for x, y in positions),
              'Wandering stays within the training area')
        wandering = False
        approach()
        # tile_text intentionally discards punctuation; inspect the actual
        # tile bytes to verify the question mark as well as the uppercase text.
        dialogue = bytes((0x83, 0x94, 0x91, 0x80, 0xe6))
        for _ in range(300):
            if dialogue in m.read_bytes('wTileMap', 360):
                break
            tick()
        check(dialogue in m.read_bytes('wTileMap', 360), 'Talking displays exactly DURA?')
        tick(120)
        pb.screen.image.save(out / 'dura-dialogue.png')
        check(any(e['label'] == 'Script_cry' and e['species'] == h.con.species_index('DURALUDON')
                  for e in interactions), 'Talking plays Duraludon\'s species cry')
        controls.press('a', hold=4, wait=30)
        for _ in range(600):
            if m.read('wBattleMode') and m.read('wEnemyMonSpecies'):
                break
            tick()
        check(m.read('wBattleMode') == 1
              and m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species_index('DURALUDON')
              and m.read('wEnemyMonLevel') == 40, 'Interaction starts a catchable level-40 Duraludon battle')
        # Let the normal introduction run and show its name and battle sprite.
        for _ in range(18):
            if 'FIGHT' in tile_text(h):
                break
            tick(30)
            controls.press('a', hold=4, wait=20)
        tick(120)
        pb.screen.image.save(out / 'battle.png')
        recording = False
        encoder.stdin.close()
        check(encoder.wait() == 0, 'Video encoded')
        encoder = None
        audio.close()
        audio = None
        with wave.open(str(out / 'audio.wav'), 'rb') as source:
            audio_seconds = source.getnframes() / source.getframerate()
            audio_rate = source.getframerate()
        video_seconds = frames * 4389 / 262144
        corrected_rate = round(audio_rate * audio_seconds / video_seconds)
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(out / 'silent.mp4'),
            '-i', str(out / 'audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-af', f'asetrate={corrected_rate},aresample={audio_rate}', '-t', str(video_seconds),
            '-movflags', '+faststart', str(out / 'duraludon-mount-mortar.mp4')], check=True)
        controls.battle(limit=18000)
        tick(120)
        check(event() and actor() is None, 'Completed encounter removes Duraludon')
        # Reload from the completed native flag, without loading another fixture.
        m.write('wXCoord', 18)
        m.write('wYCoord', 5)
        m.write('hMapEntryMethod', 0xf1)
        native_call(h, 'EnterMap')
        check(actor() is None, 'Completed encounter remains gone after map reload')
        check(not h.text_overflows, 'Dialogue has no text overflow')
        (out / 'checks.json').write_text(json.dumps(dict(checks=checks,
            positions=sorted(positions), phases=sorted(phases), interactions=interactions,
            seconds=video_seconds, rom=h.rom_key()), indent=2) + '\n')
        print('VIDEO', out / 'duraludon-mount-mortar.mp4', flush=True)
    finally:
        if encoder:
            encoder.stdin.close()
            encoder.wait()
        if audio:
            audio.close()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
