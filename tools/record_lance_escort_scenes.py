#!/usr/bin/env python3
"""Record the mart, B2F healing and Ariana arrival scenes with native audio.

Only starting story flags, location and party are staged in private emulator
memory. All recorded walking, dialogue, arrivals and healing run normally.
"""
import argparse
import io
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
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants
from probability_checks import call

FPS = 4194304 / 70224


class Recording:
    def __init__(self, pb, path):
        self.pb, self.path, self.frames = pb, path, 0
        self.ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        self.silent, self.wav = path.with_suffix('.silent.mp4'), path.with_suffix('.wav')
        self.encoder = subprocess.Popen([self.ffmpeg, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '640x576',
            '-framerate', str(FPS / 2), '-i', '-', '-an', '-c:v', 'libx264',
            '-threads', '2', '-preset', 'veryfast', '-crf', '18',
            '-pix_fmt', 'yuv420p', str(self.silent)], stdin=subprocess.PIPE)
        self.audio = wave.open(str(self.wav), 'wb')
        self.audio.setnchannels(2)
        self.audio.setsampwidth(2)
        self.audio.setframerate(pb.sound.sample_rate)

    def append(self):
        if self.frames % 2 == 0:
            self.encoder.stdin.write(self.pb.screen.image.convert('RGB').resize(
                (640, 576), Image.Resampling.NEAREST).tobytes())
        self.audio.writeframesraw((self.pb.sound.ndarray.astype(np.int16) * 256).tobytes())
        self.frames += 1

    def finish(self):
        self.encoder.stdin.close()
        if self.encoder.wait():
            raise RuntimeError('Video encoding failed')
        self.audio.close()
        with wave.open(str(self.wav), 'rb') as source:
            samples = np.frombuffer(source.readframes(source.getnframes()), dtype='<i2')
            if not np.abs(samples.astype(np.int32)).max():
                raise AssertionError('Recording has no game audio')
            duration = self.frames / FPS
            corrected_rate = round(source.getnframes() / duration)
            rate = source.getframerate()
        subprocess.run([self.ffmpeg, '-y', '-loglevel', 'error', '-i', str(self.silent),
            '-i', str(self.wav), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-af', f'asetrate={corrected_rate},aresample={rate}', '-t', str(duration),
            '-movflags', '+faststart', str(self.path)], check=True)
        # Decode both tracks to verify the delivered container, not just its inputs.
        subprocess.run([self.ffmpeg, '-v', 'error', '-i', str(self.path),
                        '-map', '0:v:0', '-map', '0:a:0', '-f', 'null', '-'], check=True)
        print('VIDEO', self.path, f'({duration:.1f}s, game audio)', flush=True)
        return dict(path=str(self.path), seconds=duration, frames=self.frames)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/lance-escort-videos')
    parser.add_argument('--scene', choices=('mahogany-mart', 'lance-healing', 'ariana-encounter'))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=True,
                emulator_kwargs={'sound_sample_rate': 48000})
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    maps = map_ids()
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    recording, frame, battle_started = None, 0, False
    texts, movements, results = [], [], {}

    def event(name, value):
        bit = flags[name]
        old, mask = m.read('wEventFlags', bit // 8), 1 << (bit % 8)
        m.write('wEventFlags', old | mask if value else old & ~mask, bit // 8)

    def actors():
        return {o['map_object']: o for o in controls.objects()}

    def script_bytes(count):
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        return [pb.memory[m.read('wScriptBank'), pos + i] for i in range(count)]

    def text(_):
        lo, hi = script_bytes(2)
        label = h.sym.nearest(m.read('wScriptBank'), lo | hi << 8)
        texts.append(dict(label=label, frame=frame, actors=actors(), player=controls.position()))
        print('TEXT', label, flush=True)

    def movement(_):
        obj, lo, hi = script_bytes(3)
        movements.append(dict(object=obj - 1, frame=frame,
            label=h.sym.nearest(m.read('wScriptBank'), lo | hi << 8), actors=actors()))

    def battle(_):
        nonlocal battle_started
        battle_started = True

    def tick(count=1):
        nonlocal frame
        for _ in range(count):
            pb.tick(1, True, True)
            if recording:
                recording.append()
                if texts and frame == texts[-1]['frame'] + 90:
                    pb.screen.image.save(args.output / f'{scene}-text-{len(texts):02}.png')
            frame += 1

    def enter(name, x, y):
        group, number = maps[name]
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                               wMapNumber=number, wXCoord=x, wYCoord=y,
                               hMapEntryMethod=0xf1).items():
            m.write(key, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)

    def complete(scene_id=None, value=None):
        for i in range(9000):
            if i % 150 == 149:
                pb.button('a', 2)
            tick()
            if (battle_started if scene_id is None else
                    m.read(scene_id) == value and not m.read('wScriptRunning')):
                return
        pb.screen.image.save(args.output / 'failure.png')
        raise AssertionError('Scene did not finish')

    try:
        new_game(h, 0)
        m.write('wOptions', 0x21)
        m.write_bytes('wPlayerName', [0x86, 0x8e, 0x8b, 0x83] + [0x50] * 7)  # GOLD
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        species = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('TOTODILE'))
        m.write('wCurPartySpecies', species)
        m.write('wCurPartyLevel', 20)
        native_call(h, 'TryAddMonToParty')
        base = io.BytesIO()
        pb.save_state(base)
        for name, callback in (('Script_writetext', text), ('Script_applymovement', movement),
                               ('Script_startbattle', battle)):
            pb.hook_register(*h.sym[name], callback, None)

        scenes = (args.scene,) if args.scene else ('mahogany-mart', 'lance-healing', 'ariana-encounter')
        for scene in scenes:
            pb.load_state(io.BytesIO(base.getvalue()))
            texts.clear()
            movements.clear()
            frame, battle_started = 0, False
            if scene == 'mahogany-mart':
                for flag in ('EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE',
                             'EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART',
                             'EVENT_CLEARED_ROCKET_HIDEOUT'):
                    event(flag, False)
                event('EVENT_DECIDED_TO_HELP_LANCE', True)
                event('EVENT_MAHOGANY_TOWN_LANCE_AND_DRAGONITE', True)
                m.write('wMahoganyMart1FSceneID', 1)
                enter('MAHOGANY_TOWN', 11, 8)
            else:
                event('EVENT_TEAM_ROCKET_BASE_B2F_DRAGONITE', True)
                event('EVENT_TEAM_ROCKET_BASE_B2F_EXECUTIVE', True)
                event('EVENT_TEAM_ROCKET_BASE_B2F_GRUNT_WITH_EXECUTIVE', True)
                if scene == 'lance-healing':
                    event('EVENT_LANCE_HEALED_YOU_IN_TEAM_ROCKET_BASE', False)
                    event('EVENT_TEAM_ROCKET_BASE_B2F_LANCE', False)
                    m.write('wTeamRocketBaseB2FSceneID', 0)
                    m.write_bytes('wPartyMon1HP', [0, 1])
                    m.write('wPartyMon1Status', 0x40)
                    m.write('wPartyMon1PP', 0)
                    enter('TEAM_ROCKET_BASE_B2F', 5, 15)
                else:
                    event('EVENT_LANCE_HEALED_YOU_IN_TEAM_ROCKET_BASE', True)
                    event('EVENT_TEAM_ROCKET_BASE_B2F_LANCE', True)
                    event('EVENT_TEAM_ROCKET_BASE_POPULATION', False)
                    event('EVENT_OPENED_DOOR_TO_ROCKET_HIDEOUT_TRANSMITTER', True)
                    m.write('wTeamRocketBaseB2FSceneID', 1)
                    enter('TEAM_ROCKET_BASE_B2F', 14, 10)
            recording = Recording(pb, args.output / f'{scene}.mp4')
            frame = 0
            tick(60)
            pb.button('down' if scene == 'ariana-encounter' else 'up', 16)
            if scene == 'mahogany-mart':
                complete('wMahoganyMart1FSceneID', 0)
                assert controls.map_id() == maps['MAHOGANY_MART_1F']
                assert not ({3, 4} & actors().keys())
                assert any('UnknownText_0x6c5ba' in t['label'] for t in texts)
                tick(90)
            elif scene == 'lance-healing':
                complete('wTeamRocketBaseB2FSceneID', 1)
                assert m.read_u16_be('wPartyMon1HP') == m.read_u16_be('wPartyMon1MaxHP')
                assert not ({3, 15} & actors().keys())
                tick(90)
            else:
                complete()
                arrival = next(t for t in texts if 'UnknownText_0x6d38c' in t['label'])
                assert {1, 2, 3, 4} <= arrival['actors'].keys()
                assert arrival['actors'][3]['position'] == [12, 13]
                assert arrival['actors'][4]['position'] == [13, 13]
                assert any('MovementData_0x6d236' in move['label'] for move in movements)
                assert any('UnknownText_0x6d3bd' in t['label'] for t in texts)
            info = recording.finish()
            recording = None
            info.update(texts=list(texts), movements=list(movements))
            results[scene] = info
        (args.output / 'recordings.json').write_text(json.dumps(dict(rom=h.rom_key(), scenes=results), indent=2) + '\n')
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
