#!/usr/bin/env python3
"""Short native Poison Fang/Surf reel, including a Surf travel comparison.

Private new-game scenes only. Fixture setup is complete before filming;
only held direction input changes the running Surf scene.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from gameplay_rules_checks import new_game
from mae_animation_checks import capture, stage, FPS
from overworld_controls import Controls
from runner import Harness, ROOT
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from symbols import _parse_constants


def ocean(rom):
    h = Harness(rom_path=rom, sound_emulated=True,
                emulator_kwargs={'sound_sample_rate': 48000})
    new_game(h, 0)
    m = h.battle.mem
    for name in ('hDebugActive', 'wDebugState', 'hDebugRNGMode'):
        m.write(name, 0)
    events = _parse_constants(ROOT/'constants/event_flags.asm')
    for event in re.findall(r'\bEVENT_BEAT_\w+', (ROOT/'maps/Route41.asm').read_text()):
        index = events[event]
        address = h.sym.addr('wEventFlags') + index//8
        h.pb.memory[address] |= 1 << (index % 8)
    group, number = map_ids()['ROUTE_41']
    for name, value in (('wMapGroup', group), ('wMapNumber', number),
                        ('wXCoord', 5), ('wYCoord', 2), ('wPlayerState', 4),
                        ('wDefaultSpawnpoint', 255), ('hMapEntryMethod', 0xf1)):
        m.write(name, value)
    begin_native_call(h, 'OverworldLoop')
    for _ in range(240):
        h.pb.tick(1, True, True)
    # Disable encounters in this private filming fixture; movement remains native.
    m.write('wScriptFlags3', m.read('wScriptFlags3') & ~16)
    assert Controls(h).position() == (5, 2) and m.read('wPlayerState') == 4
    return h


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--before-rom', type=Path, required=True)
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/poison-fang-and-surf')
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    silent = out/'preview-silent.mp4'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '1280x688', '-framerate', str(FPS/2),
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
        '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
    font = ImageFont.truetype(font_path, 23)
    small = ImageFont.truetype(font_path, 18)
    frames_written, sounds, chapters, checks = 0, [], [], []

    def canvas(left, right, title, labels, footer):
        img = Image.new('RGB', (1280, 688), '#101827')
        draw = ImageDraw.Draw(img)
        draw.text((20, 9), title, font=font, fill='white')
        for x, picture, label in ((0, left, labels[0]), (640, right, labels[1])):
            draw.text((x+20, 44), label, font=small, fill='#7de1ba')
            img.paste(Image.fromarray(picture).resize((640, 576), Image.Resampling.NEAREST), (x, 72))
        draw.text((20, 659), footer, font=small, fill='#b8c3d5')
        return img

    def audio_samples(pb):
        sound = pb.sound
        return np.frombuffer(sound.raw_buffer, dtype=np.int8,
            count=sound.raw_buffer_head).reshape(-1, 2).astype(np.int16)*256

    def pad_audio(samples, count):
        audio = np.concatenate(samples)
        target = round(count/FPS*48000)
        return np.pad(audio[:target], ((0, max(0, target-len(audio))), (0, 0)))

    h, fixture = stage(ROOT/'pokecrystal_debug.gbc', audio=True)
    try:
        for move, title in (('POISON_FANG', 'POISON FANG — restored purple teeth'),
                            ('SURF', 'SURF — battle animation')):
            print('Recording', move, flush=True)
            left, sound, result = capture(h, fixture, move, 0, audio=True)
            right, _, other = capture(h, fixture, move, 1)
            checks.extend([result, other])
            chapters.append({'title': title, 'seconds': frames_written*2/FPS})
            count = max(len(left), len(right))+60
            count += count % 2
            for i in range(0, count, 2):
                frame = canvas(left[min(i, len(left)-1)], right[min(i, len(right)-1)],
                    title, ('PLAYER USES THE MOVE', 'OPPONENT USES THE MOVE'),
                    'Native ROM footage • game audio • playback at game speed')
                encoder.stdin.write(frame.tobytes())
                frames_written += 1
            sounds.append(pad_audio(sound, count))
    finally:
        h.pb.stop(save=False)

    print('Recording Surf travel speed', flush=True)
    old, current = ocean(args.before_rom), ocean(ROOT/'pokecrystal_debug.gbc')
    old_controls, current_controls = Controls(old), Controls(current)
    chapters.append({'title': 'Surf travel speed comparison', 'seconds': frames_written*2/FPS})
    samples, positions = [], []
    try:
        for i in range(300):
            if i == 45:
                old.pb.button('right', 180)
                current.pb.button('right', 180)
            old.pb.tick(1, True, True)
            current.pb.tick(1, True, True)
            samples.append(audio_samples(current.pb))
            a, b = old_controls.position(), current_controls.position()
            positions.append([i, list(a), list(b)])
            assert not old.battle.mem.read('wBattleMode') and not current.battle.mem.read('wBattleMode')
            assert old.battle.mem.read('wPlayerState') == current.battle.mem.read('wPlayerState') == 4
            if i % 2 == 0:
                img = canvas(old.pb.screen.ndarray[:, :, :3], current.pb.screen.ndarray[:, :, :3],
                    'SURF — original overworld speed restored',
                    ('ORIGINAL OVERWORLD SURF SPEED', 'RESTORED OVERWORLD SURF SPEED'),
                    f'Same held input, same time • tiles traveled: {a[0]-5} before / {b[0]-5} now')
                if i == 248:
                    img.save(out/'surf-speed-comparison.png')
                encoder.stdin.write(img.tobytes())
                frames_written += 1
        assert b[0]-5 == a[0]-5 > 0, (a, b)
        assert a[1] == b[1] == 2
        checks.append({'surf_before_tiles': a[0]-5, 'surf_updated_tiles': b[0]-5,
                       'held_input_frames': 180, 'positions': positions})
        sounds.append(pad_audio(samples, 300))
    finally:
        old.pb.stop(save=False)
        current.pb.stop(save=False)
    encoder.stdin.close()
    assert encoder.wait() == 0
    with wave.open(str(out/'game-audio.wav'), 'wb') as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(48000)
        wav.writeframes(np.concatenate(sounds).astype('<i2').tobytes())
    target = out/'poison-fang-and-surf.mp4'
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent),
        '-i', str(out/'game-audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
        '-shortest', '-movflags', '+faststart', str(target)], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(target), '-f', 'null', '-'], check=True)
    (out/'results.json').write_text(json.dumps({'chapters': chapters, 'checks': checks,
        'seconds': frames_written*2/FPS,
        'rom_hash': hashlib.md5((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest()[:12]}, indent=2)+'\n')
    print('PASS native move cleanup, Surf distance comparison and video/audio decoding', flush=True)
    print('VIDEO', target, flush=True)


if __name__ == '__main__':
    main()
