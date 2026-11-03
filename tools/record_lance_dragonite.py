#!/usr/bin/env python3
"""Verify and record Lance's native B3F scene, including the incoming stair warp.

Only the starting location/story flags are staged in private emulator memory.
Movement, dialogue, following and the warp run normally; no player save is used.
"""
import argparse
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
from ui_checks import tile_text

FPS = 4194304 / 70224


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/lance-dragonite')
    args = parser.parse_args()
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=True,
                emulator_kwargs={'sound_sample_rate': 48000})
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    maps = map_ids()
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    sounds = _parse_constants(ROOT / 'constants/sfx_constants.asm')
    checks, texts, trace = [], [], []
    impacts, landings, offsets, movements, asleep_frames, follow_gaps = [], [], [], [], [], []
    paths = {1: [], 2: [], 9: []}  # Lance, Dragonite, the local Rocket
    frames = simultaneous = 0
    recording = False
    encoder = audio = None
    registered = []

    def check(condition, label):
        if not condition:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(label + '\n' + tile_text(h))
        checks.append(label)
        print('PASS', label, flush=True)

    def actors():
        result = {}
        for obj in controls.objects():
            data = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)
            obj['facing'] = data[8]
            obj['tile'] = data[2]
            obj['resolved_sprite'] = (m.read('wVariableSprites', obj['sprite'] - sprites['SPRITE_CONSOLE'])
                                      if obj['sprite'] >= sprites['SPRITE_CONSOLE'] else obj['sprite'])
            obj['x_offset'] = data[25] if data[25] < 128 else data[25] - 256
            obj['y_offset'] = data[26] if data[26] < 128 else data[26] - 256
            result[obj['map_object']] = obj
        return result

    def event(name):
        bit = flags[name]
        return bool(pb.memory[h.sym.addr('wEventFlags') + bit // 8] & (1 << (bit % 8)))

    def hook(name, callback):
        address = h.sym[name]
        pb.hook_register(*address, callback, None)
        registered.append(address)

    def text(_):
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        bank = m.read('wScriptBank')
        address = pb.memory[bank, pos] | pb.memory[bank, pos + 1] << 8
        label = h.sym.nearest(bank, address)
        texts.append(dict(label=label, frame=frames, actors=actors(), player=controls.position()))
        print('TEXT', label, controls.position(), flush=True)

    def sound(_):
        if (recording and controls.map_id() == maps['TEAM_ROCKET_BASE_B3F']
                and (pb.register_file.D << 8 | pb.register_file.E) == sounds['SFX_EGG_BOMB']):
            impact = dict(frame=frames, height=actors()[9]['y_offset'])
            if not impacts or impact != impacts[-1]:
                impacts.append(impact)

    def movement(_):
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        bank = m.read('wScriptBank')
        address = pb.memory[bank, pos + 1] | pb.memory[bank, pos + 2] << 8
        label = h.sym.nearest(bank, address)
        movements.append(dict(label=label, frame=frames, actors=actors()))
        if 'LanceDragoniteReturnMovement' in label:
            pb.screen.image.save(out / 'confrontation.png')

    def sleeping_tiles_match():
        actor = actors()[9]
        tile = actor['tile']
        bank, address = (0 if tile & 128 else 1), 0x8000 + (tile & 127) * 16
        return bytes(pb.memory[bank, address:address + 64]) == (ROOT / 'gfx/sprites/rocket_asleep.2bpp').read_bytes()

    def tick(n=1):
        nonlocal frames, simultaneous
        for _ in range(n):
            pb.tick(1, True, True)
            if not recording:
                continue
            if controls.map_id() == maps['TEAM_ROCKET_BASE_B3F']:
                current = actors()
                if 9 in current and 2 in current:
                    height = current[9]['y_offset']
                    if offsets and offsets[-1]['height'] < 0 and height == 0:
                        landings.append(frames)
                    offsets.append(dict(frame=frames, height=height,
                                        lunge=current[2]['x_offset']))
                    if current[9]['resolved_sprite'] == sprites['SPRITE_ROCKET_ASLEEP']:
                        asleep_frames.append(frames)
                        if frames == asleep_frames[0] + 6:
                            pb.screen.image.save(out / 'asleep.png')
                    if height == -28 and not (out / 'slam.png').exists():
                        pb.screen.image.save(out / 'slam.png')
                changed = False
                for obj_id, path in paths.items():
                    obj = current.get(obj_id)
                    if obj and (not path or path[-1] != obj['next']):
                        path.append(obj['next'])
                        changed = True
                if changed:
                    trace.append(dict(frame=frames, actors=current,
                                      player=controls.position(),
                                      following=[m.read('wObjectFollow_Leader'),
                                                 m.read('wObjectFollow_Follower')]))
                # Map loading creates the structs before copying their standing
                # coordinates. Those (-4,-4) placeholders are not walking.
                if (1 in current and 2 in current
                        and min(current[1]['position'] + current[2]['position']) >= 0):
                    simultaneous += int(all(current[i]['position'] != current[i]['next'] for i in (1, 2)))
                    if current[1]['position'] != current[1]['next']:
                        if [m.read('wObjectFollow_Leader'), m.read('wObjectFollow_Follower')] != [
                                current[1]['slot'], current[2]['slot']]:
                            follow_gaps.append(dict(frame=frames, actors=current,
                                following=[m.read('wObjectFollow_Leader'), m.read('wObjectFollow_Follower')]))
            if frames % 2 == 0:
                encoder.stdin.write(pb.screen.image.convert('RGB').resize(
                    (640, 576), Image.Resampling.NEAREST).tobytes())
            audio.writeframesraw((pb.sound.ndarray.astype(np.int16) * 256).tobytes())
            if texts and frames == texts[-1]['frame'] + 80:
                picture = 'outrage.png' if 'Outrage' in texts[-1]['label'] else 'passwords.png'
                pb.screen.image.save(out / picture)
            frames += 1

    def press(button, hold=4, wait=30):
        pb.button(button, hold)
        tick(hold + wait)

    try:
        print('Booting private ROM:', args.rom, flush=True)
        new_game(h, 0)
        m.write('wOptions', 0x21)  # medium text and stereo audio
        m.write_bytes('wPlayerName', [0x80 + ord(c) - ord('A') for c in 'GOLD'] + [0x50] * 4)
        for name in ('EVENT_TEAM_ROCKET_BASE_B3F_LANCE_PASSWORDS',
                     'EVENT_TEAM_ROCKET_BASE_POPULATION',
                     'EVENT_OPENED_DOOR_TO_GIOVANNIS_OFFICE'):
            bit = flags[name]
            addr = h.sym.addr('wEventFlags') + bit // 8
            pb.memory[addr] &= ~(1 << (bit % 8))
        m.write('wTeamRocketBaseB3FSceneID', 0)
        m.write('wTeamRocketBaseB2FSceneID', 1)
        group, number = maps['TEAM_ROCKET_BASE_B2F']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group,
                                wMapNumber=number, wXCoord=27, wYCoord=13,
                                hMapEntryMethod=0xf1).items():
            m.write(name, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)
        check(controls.map_id() == maps['TEAM_ROCKET_BASE_B2F'], 'Starts above the B2F stair warp')
        hook('Script_writetext', text)
        hook('PlaySFX', sound)
        hook('Script_applymovement', movement)
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
            '-pixel_format', 'rgb24', '-video_size', '640x576', '-framerate', str(FPS / 2),
            '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
            '-pix_fmt', 'yuv420p', str(out / 'silent.mp4')], stdin=subprocess.PIPE)
        audio = wave.open(str(out / 'audio.wav'), 'wb')
        audio.setnchannels(2)
        audio.setsampwidth(2)
        audio.setframerate(pb.sound.sample_rate)
        recording = True
        tick(60)
        press('down', hold=8, wait=80)
        for frame in range(4200):
            if frame % 100 == 99:
                pb.button('a', 2)
            tick()
            if (controls.map_id() == maps['TEAM_ROCKET_BASE_B3F']
                    and m.read('wTeamRocketBaseB3FSceneID') == 1
                    and not m.read('wScriptRunning')):
                break
        check(controls.map_id() == maps['TEAM_ROCKET_BASE_B3F'], 'Ordinary stair warp enters B3F')
        check(m.read('wTeamRocketBaseB3FSceneID') == 1, 'Scene completes and advances to the rival encounter')
        outrage = next(t for t in texts if 'LanceDragoniteOutrageText' in t['label'])
        password = next(t for t in texts if 'LanceGetPasswordText' in t['label'])
        check(outrage['player'] == (26, 14), 'Player automatically moves one tile left before Outrage')
        check(outrage['actors'][2]['position'] == [24, 14]
              and outrage['actors'][2]['sprite'] == sprites['SPRITE_DRAGON'],
              'Dragonite begins at 24,14 using the dragon walking sprite')
        check(paths[9] == [[23, 14]], 'The Rocket never leaves his tile during the entire animation')
        check(outrage['actors'][9]['facing'] == 12
              and outrage['actors'][9]['resolved_sprite'] == sprites['SPRITE_ROCKET'],
              'The Rocket starts standing and facing right')
        print('SLAMS', landings, 'IMPACTS', impacts, 'HEIGHT', min(p['height'] for p in offsets),
              'FIRST AIRBORNE', next((p['frame'] for p in offsets if p['height'] < 0), None), flush=True)
        check(len(landings) == 1 and min(p['height'] for p in offsets) == -28
              and landings[-1] - next(p['frame'] for p in offsets if p['height'] < 0) <= 60,
              'Exactly one fast 28-pixel vertical slam')
        check(len(impacts) == 1 and all(p['height'] == 0 for p in impacts)
              and all(abs(p['frame'] - landing) <= 2 for p, landing in zip(impacts, landings)),
              'The landing has a synchronized heavy Egg Bomb explosion')
        check(asleep_frames and abs(asleep_frames[0] - impacts[0]['frame']) <= 2
              and password['actors'][9]['resolved_sprite'] == sprites['SPRITE_ROCKET_ASLEEP']
              and sleeping_tiles_match(),
              'The Rocket switches immediately to the supplied sleeping art and stays asleep')
        check(min(p['lunge'] for p in offsets) == -12
              and password['actors'][2]['x_offset'] == 0,
              'Dragonite visibly lunges at the Rocket and returns to his original tile')
        confront = next(t for t in movements if 'LanceDragoniteConfrontRocketMovement' in t['label'])
        returning = next(t for t in movements if 'LanceDragoniteReturnMovement' in t['label'])
        check(confront['actors'][2]['position'] == [24, 15]
              and returning['actors'][1]['position'] == [24, 14]
              and returning['actors'][2]['position'] == [24, 15]
              and returning['frame'] - confront['frame'] >= 60
              and len(texts) == 2,
              'Dragonite steps down once; Lance silently approaches the sleeping grunt and pauses')
        check(password['actors'][1]['position'] == [25, 14]
              and password['actors'][1]['facing'] == 12
              and password['actors'][2]['position'] == [24, 14]
              and password['player'] == (26, 14),
              'Lance returns to the player with Dragonite directly behind, then gives his dialogue')
        print('PATHS', paths, 'SIMULTANEOUS', simultaneous, flush=True)
        check(paths[2][2:] == paths[1][1:-1] and not follow_gaps,
              'Following stays active for every Lance step, trailing his return and exit one tile behind')
        check(simultaneous >= 60, 'Lance and Dragonite walk concurrently along the usual exit path')
        check(event('EVENT_TEAM_ROCKET_BASE_B3F_LANCE_PASSWORDS')
              and not ({1, 2} & actors().keys()), 'Both leave and their shared departure flag is set')
        check(controls.position() == (26, 14), 'The player stays at the viewing tile throughout the scene')
        tick(90)
        pb.screen.image.save(out / 'completed.png')
        recording = False
        encoder.stdin.close()
        check(encoder.wait() == 0, 'Video encoded')
        encoder = None
        audio.close()
        audio = None
        with wave.open(str(out / 'audio.wav'), 'rb') as source:
            samples = np.frombuffer(source.readframes(source.getnframes()), dtype='<i2')
            check(np.abs(samples.astype(np.int32)).max() > 0, 'Recording includes game audio')
            duration = frames / FPS
            rate = source.getframerate()
            corrected_rate = round(source.getnframes() / duration)
        video = out / 'lance-dragonite.mp4'
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(out / 'silent.mp4'),
            '-i', str(out / 'audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-af', f'asetrate={corrected_rate},aresample={rate}', '-t', str(duration),
            '-movflags', '+faststart', str(video)], check=True)
        # Re-enter the actual map after completion: the scene and both actors stay gone.
        count = len(texts)
        m.write('hMapEntryMethod', 0xf1)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)
        check(len(texts) == count and not ({1, 2} & actors().keys())
              and m.read('wTeamRocketBaseB3FSceneID') == 1, 'Completed scene does not repeat on re-entry')
        check(actors()[9]['resolved_sprite'] == sprites['SPRITE_ROCKET_ASLEEP']
              and sleeping_tiles_match(), 'The Rocket remains asleep with exact supplied art on map re-entry')
        check(not h.text_overflows, 'Dialogue fits the text box')
        (out / 'checks.json').write_text(json.dumps(dict(rom=h.rom_key(), checks=checks,
            paths=paths, simultaneous_frames=simultaneous, texts=texts, trace=trace,
            landings=landings, impacts=impacts, offsets=offsets,
            movements=movements, asleep_frame=asleep_frames[0], follow_gaps=follow_gaps,
            seconds=duration), indent=2) + '\n')
        print('VIDEO', video, flush=True)
    finally:
        if encoder:
            encoder.stdin.close()
            encoder.wait()
        if audio:
            audio.close()
        for address in registered:
            pb.hook_deregister(*address)
        pb.stop(save=False)


if __name__ == '__main__':
    main()
