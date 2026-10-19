#!/usr/bin/env python3
"""Render changed Pokeorange animations on both sides; optionally record comparisons.

Uses a private harness battle and calls the built ROM's PlayBattleAnim routine.
These are isolated animation previews; gameplay is covered by the move sweep.
The player's save files are never loaded or written.
"""
import argparse
import io
import json
from pathlib import Path
import subprocess
import wave

import numpy as np
from PIL import Image, ImageDraw, ImageFont

from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from symbols import STATE_WAIT

CHANGED = ['BUBBLE', 'EGG_BOMB', 'SPIKE_CANNON', 'BARRAGE', 'FLAME_WHEEL',
           'LEAF_BLADE', 'SHADOW_PUNCH', 'DRAGON_DANCE', 'SLACK_OFF',
           'VOLT_TACKLE', 'WISH', 'SELFDESTRUCT', 'POWDER_SNOW', 'PRESENT']
FPS = 262144 / 4389


def stage(rom, audio=False):
    h = Harness(rom_path=rom, sound_emulated=audio,
                emulator_kwargs={'sound_sample_rate': 48000} if audio else None)
    if audio:
        # Cached fixtures may have been saved with APU emulation disabled.
        h.bootstrap()
    else:
        h.ensure_fixture()
        h.load_fixture()
    h.battle.mem.write('wOptions', 0x41)
    assert h.run_battle({
        'player': {'species': 'MEW', 'level': 50, 'moves': ['SPLASH']},
        'enemy': {'species': 'SNORLAX', 'level': 50, 'moves': ['SPLASH']},
        'rng': 'forced_high', 'turns': 0,
    }) == STATE_WAIT
    fixture = io.BytesIO()
    h.pb.save_state(fixture)
    return h, fixture


def capture(h, fixture, move, side, audio=False, param=None, observer=None):
    fixture.seek(0)
    h.pb.load_state(fixture)
    m, pb = h.battle.mem, h.pb
    m.write('hBattleTurn', side)
    move_id = h.con.moves[move]
    m.write_bytes('wFXAnimID', [move_id & 255, move_id >> 8])
    param = (1 if move == 'SELFDESTRUCT' else 0) if param is None else param
    m.write('wBattleAnimParam', param)
    m.write('wNumHits', 0)
    palette_names = ('wBGPals1', 'wOBPals1', 'wBGPals2', 'wOBPals2')
    palettes = [m.read_bytes(name, 64) for name in palette_names]
    tilemap = m.read_bytes('wTileMap', 360)
    start = pb.screen.ndarray[:, :, :3].copy()
    frames, samples = [], []
    begin_native_call(h, 'PlayBattleAnim')
    # Disable interrupts only AFTER the routine has returned to the RAM marker.
    pb.memory[0xc0f0] = 0xf3
    for elapsed in range(1200):
        pb.tick(1, True, audio)
        frames.append(pb.screen.ndarray[:, :, :3].copy())
        if observer:
            observer(elapsed)
        if audio:
            sound = pb.sound
            buf = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                                count=sound.raw_buffer_head).reshape(-1, 2)
            samples.append(buf.astype(np.int16) * 256)
        if pb.register_file.PC in (0xc0f1, 0xc0f3):
            break
    else:
        raise AssertionError((move, side, 'animation timed out', h.control_state(), h.animation_state()))
    native_frames = len(frames)
    # The return marker disables interrupts for reliable detection. Let VBlank
    # upload the restored palettes/tilemap before holding the final video frame;
    # otherwise a preview freezes the last distorted LCD/palette frame even
    # though the engine has already requested the normal battle screen.
    pb.memory[0xc0f0:0xc0f3] = [0xfb, 0x18, 0xfe]
    pb.register_file.PC = 0xc0f0
    for _ in range(8):
        pb.tick(1, True, audio)
        frames.append(pb.screen.ndarray[:, :, :3].copy())
        if audio:
            sound = pb.sound
            buf = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                                count=sound.raw_buffer_head).reshape(-1, 2)
            samples.append(buf.astype(np.int16) * 256)
    assert len(frames) > 15, (move, side, 'animation did not execute')
    assert not m.read('hSCX') and not m.read('hSCY'), (move, side, 'screen offset leaked')
    assert not m.read('hLCDCPointer'), (move, side, 'LCD effect leaked')
    assert palettes == [m.read_bytes(name, 64) for name in palette_names], (move, side, 'palette leaked')
    assert tilemap == m.read_bytes('wTileMap', 360), (move, side, 'battle tilemap was not restored')
    changed = [int(np.any(frame != start, axis=2).sum()) for frame in frames]
    assert max(changed) > 20, (move, side, 'no visible animation')
    return frames, samples, {'move': move, 'side': side, 'param': param, 'frames': len(frames),
                            'native_frames': native_frames,
                            'final_frame_changed_pixels': int(np.any(frames[-1] != start, axis=2).sum()),
                            'changed_pixels_peak': max(changed), 'cleanup': 'passed'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal_debug.gbc')
    parser.add_argument('--before-rom', type=Path)
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/mae-animation-comparison')
    parser.add_argument('--record', action='store_true')
    parser.add_argument('--moves', nargs='+', default=CHANGED)
    args = parser.parse_args()
    if args.record and not args.before_rom:
        parser.error('--record requires --before-rom (with its matching .sym file)')
    args.output.mkdir(parents=True, exist_ok=True)
    print('Preparing current ROM animation fixture', flush=True)
    current, current_state = stage(args.rom, audio=args.record)
    before = None
    if args.before_rom:
        print('Preparing original ROM animation fixture', flush=True)
        before, before_state = stage(args.before_rom)
    results, variants, chapters, sounds = [], [], [], []
    video_frames = 0
    encoder = None
    if args.record:
        import imageio_ffmpeg
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        silent = args.output / 'comparison-silent.mp4'
        encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '1280x688',
            '-framerate', str(FPS / 2), '-i', '-', '-an', '-c:v', 'libx264',
            '-preset', 'veryfast', '-crf', '18', '-pix_fmt', 'yuv420p', str(silent)],
            stdin=subprocess.PIPE)
        font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 23)
        small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 18)
    try:
        for move in args.moves:
            for side in (0, 1):
                print('Rendering', move, 'player' if side == 0 else 'opponent', flush=True)
                frames, audio, result = capture(current, current_state, move, side, args.record)
                old = None
                if before:
                    old, _, original = capture(before, before_state, move, side)
                    result['original_frames'] = len(old)
                    common = min(len(frames), len(old))
                    result['different_frames'] = sum(not np.array_equal(frames[i], old[i]) for i in range(common))
                # A contact sheet uses evenly spaced frames plus the peak effect.
                indices = sorted(set([len(frames) * i // 5 for i in range(1, 5)]))
                sheet = Image.new('RGB', (640, 576), '#111827')
                for i, index in enumerate(indices):
                    shot = Image.fromarray(frames[index]).resize((320, 288), Image.Resampling.NEAREST)
                    sheet.paste(shot, ((i % 2) * 320, (i // 2) * 288))
                sheet.save(args.output / f'{move.lower()}-{side}.png')
                results.append(result)
                for alternate in ([0] if move == 'SELFDESTRUCT' else [3] if move == 'PRESENT' else []):
                    _, _, variant = capture(current, current_state, move, side, param=alternate)
                    variants.append(variant)
                if not encoder:
                    continue
                chapters.append({'move': move, 'side': side, 'seconds': video_frames * 2 / FPS})
                count = max(len(frames), len(old)) + 60
                count += count % 2
                for i in range(0, count, 2):
                    canvas = Image.new('RGB', (1280, 688), '#101827')
                    draw = ImageDraw.Draw(canvas)
                    title = f'{move.replace("_", " ").title()}  |  {"Player" if side == 0 else "Opponent"} uses the move'
                    draw.text((20, 9), title, font=font, fill='white')
                    draw.text((20, 44), 'BEFORE', font=small, fill='#b8c3d5')
                    draw.text((660, 44), 'UPDATED — MAE POKEORANGE ANIMATION', font=small, fill='#7de1ba')
                    for x, sequence in ((0, old), (640, frames)):
                        img = Image.fromarray(sequence[min(i, len(sequence)-1)])
                        canvas.paste(img.resize((640, 576), Image.Resampling.NEAREST), (x, 72))
                    draw.text((20, 659), 'Native ROM animation preview • audio from updated animation • playback at game speed', font=small, fill='#b8c3d5')
                    encoder.stdin.write(canvas.tobytes())
                    video_frames += 1
                samples = np.concatenate(audio)
                target = round(count / FPS * 48000)
                if len(samples) < target:
                    samples = np.pad(samples, ((0, target-len(samples)), (0, 0)))
                sounds.append(samples[:target])
    finally:
        current.pb.stop(save=False)
        if before:
            before.pb.stop(save=False)
        if encoder:
            encoder.stdin.close()
            assert encoder.wait() == 0, 'video encoder failed'
    if args.record:
        pcm = np.concatenate(sounds)
        assert np.abs(pcm.astype(np.int32)).max() > 0, 'audio is silent'
        wav_path = args.output / 'comparison-audio.wav'
        with wave.open(str(wav_path), 'wb') as wav:
            wav.setnchannels(2)
            wav.setsampwidth(2)
            wav.setframerate(48000)
            wav.writeframes(pcm.astype('<i2').tobytes())
        target = args.output / 'all-changed-moves-before-after.mp4'
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent),
            '-i', str(wav_path), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-shortest', '-movflags', '+faststart', str(target)], check=True)
        print('VIDEO', target, flush=True)
    (args.output / 'results.json').write_text(json.dumps({
        'rom_hash': current.rom_key(), 'original_rom_hash': before.rom_key() if before else None,
        'checks': results, 'variant_checks': variants, 'chapters': chapters,
        'video_seconds': video_frames * 2 / FPS}, indent=2)+'\n')
    print('PASS', len(results)+len(variants), 'native animation previews and cleanup checks', flush=True)


if __name__ == '__main__':
    main()
