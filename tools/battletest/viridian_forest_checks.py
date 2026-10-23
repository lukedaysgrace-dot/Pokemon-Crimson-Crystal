#!/usr/bin/env python3
"""Native forest rain/tree presentation, with an optional gameplay recording.

Stages only a private party, location and saved daily weather selection. The
actual map loader, weather selector, tile animation and button walking run.
"""
import argparse
import json
import subprocess
import wave
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

from runner import Harness
from probability_checks import call
from state import Request
from save_menu_checks import begin_native_call
from overworld_controls import Controls
from safari_ui_checks import map_ids
from symbols import ROOT

OUTPUT = ROOT / '_ai_artifacts/viridian-forest'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--record', action='store_true')
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness(sound_emulated=args.record)
    h.ensure_fixture()
    h.load_fixture()
    m, controls = h.battle.mem, Controls(h)
    checks = []
    encoder = None
    audio = []
    recorded = 0
    chapter = 'Custom forest palette | clear weather'
    snapshots = set()
    oam_snapshots = set()
    original_tick = h.tick

    def check(condition, description):
        assert condition, description
        checks.append(description)
        print('PASS', description, flush=True)

    def tree_tiles():
        bank = h.pb.memory[0xff4f]
        h.pb.memory[0xff4f] = 1
        data = bytes(h.pb.memory[0x90a0:0x90b0]) + bytes(h.pb.memory[0x90d0:0x90e0])
        h.pb.memory[0xff4f] = bank
        return data

    font_path = Path('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf')
    font = ImageFont.truetype(str(font_path), 21) if font_path.exists() else ImageFont.load_default()

    def tick(frames=1):
        nonlocal recorded
        for _ in range(frames):
            original_tick(1)
            snapshots.add(tree_tiles())
            oam_snapshots.add(bytes(m.read_bytes('wVirtualOAM', 160)))
            if encoder:
                canvas = Image.new('RGB', (640, 640), '#101b1a')
                canvas.paste(h.pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (0, 64))
                draw = ImageDraw.Draw(canvas)
                draw.text((18, 8), 'VIRIDIAN FOREST', font=font, fill='#d8f0ce')
                draw.text((18, 35), chapter, font=font, fill='white')
                encoder.stdin.write(canvas.tobytes())
                sound = h.pb.sound
                values = np.frombuffer(sound.raw_buffer, dtype=np.int8, count=sound.raw_buffer_head)
                audio.append(values.astype(np.int16) * 256)
                recorded += 1

    def native(name):
        begin_native_call(h, name)
        for _ in range(600):
            h.tick(1)
            if h.pb.register_file.PC in (0xc0f1, 0xc0f3):
                return
        raise RuntimeError(name + ' did not return')

    def refresh(rain):
        day = m.read('wCurDay')
        m.write('wWeatherRandomDay', day)
        m.write('wWeatherDailyFlags', 128)
        m.write('wWeatherDailyKanto1', 11 if rain else 10)
        native('_SetCurrentWeather')
        native('LoadMapPalettes')
        begin_native_call(h, 'OverworldLoop')
        m.write('wMapStatus', 2)
        h.tick(90)

    try:
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        request = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species='MEW', level=100, moves=['TACKLE', 'SURF'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wStatusFlags2', 'wInBattleTowerBattle', 'wCelebiEvent'):
            m.write(name, 0)
        # The cached fixture is paused in the debug Start menu. Leaving it
        # through a staged map load also needs its menu-only weather lock cleared.
        m.write('wVramState', m.read('wVramState') & ~4)
        m.write('wRepelEffect', 255)
        m.write('wOptions', 1)
        day = m.read('wCurDay')
        m.write('wWeatherRandomDay', day)
        m.write('wWeatherDailyFlags', 128)
        m.write('wWeatherDailyKanto1', 10)
        group, number = map_ids()['VIRIDIAN_FOREST']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                wXCoord=16, wYCoord=13, hMapEntryMethod=0xf1, hOAMUpdate=0).items():
            m.write(name, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(controls.map_id() == (group, number) and controls.position() == (16, 13), 'native forest map loaded')
        refresh(False)
        h.tick = tick
        snapshots.clear()
        h.tick(100)
        check(m.read('hCurWeather') == 0 and len(snapshots) == 1, 'clear weather keeps the trees still')
        h.pb.screen.image.save(str(OUTPUT / 'forest-clear.png'))
        if args.record:
            import imageio_ffmpeg
            ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
            encoder = subprocess.Popen([
                ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo', '-pixel_format', 'rgb24',
                '-video_size', '640x640', '-framerate', '59.7275', '-i', '-', '-c:v', 'libx264',
                '-preset', 'veryfast', '-crf', '18', '-pix_fmt', 'yuv420p', str(OUTPUT / 'forest-silent.mp4')
            ], stdin=subprocess.PIPE)
        h.tick(240)
        chapter = 'Daily rain | Celebi-style tree animation'
        refresh(True)
        snapshots.clear()
        oam_snapshots.clear()
        h.tick(180)
        check(m.read('hCurWeather') == 3, 'saved rainy selection produces native forest rain')
        check(len(snapshots) > 1, 'bank-1 tree graphics animate during rain')
        h.pb.screen.image.save(str(OUTPUT / 'forest-rain.png'))
        check(len(oam_snapshots) > 1, 'rain particles animate')
        check(m.read('wCelebiEvent') == 0, 'rain animation does not change Celebi event flags')
        h.pb.screen.image.save(str(OUTPUT / 'forest-rain.png'))
        controls.go((16, 17))
        check(controls.position() == (16, 17), 'normal button walking works during rain')
        controls.go((16, 13))
        h.tick(450)
        if encoder:
            encoder.stdin.close()
            assert encoder.wait() == 0, 'video encoding failed'
            encoder = None
            samples = np.concatenate(audio).reshape(-1, 2)
            sample_rate = h.pb.sound.sample_rate
            target = round(recorded / 59.7275 * sample_rate)
            if len(samples) < target:
                samples = np.pad(samples, ((0, target-len(samples)), (0, 0)))
            with wave.open(str(OUTPUT / 'forest.wav'), 'wb') as sound:
                sound.setnchannels(2)
                sound.setsampwidth(2)
                sound.setframerate(sample_rate)
                sound.writeframes(samples[:target].astype('<i2').tobytes())
            final = OUTPUT / 'viridian-forest-rain.mp4'
            subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(OUTPUT / 'forest-silent.mp4'),
                            '-i', str(OUTPUT / 'forest.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
                            '-af', 'highpass=f=30', '-shortest', '-movflags', '+faststart', str(final)], check=True)
            print('VIDEO', final, flush=True)
        (OUTPUT / 'checks.json').write_text(json.dumps(dict(checks=checks, count=len(checks), video_frames=recorded), indent=2))
        print(f'VIRIDIAN FOREST UI: {len(checks)} checks passed', flush=True)
    finally:
        if encoder:
            encoder.stdin.close()
            encoder.wait()
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
