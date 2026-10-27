#!/usr/bin/env python3
"""Check Sacred Fire's blue flames on both sides and record a native battle.

Uses private emulator fixtures; never opens the player's save.
"""
import argparse
import hashlib
import json
import subprocess
import wave
from pathlib import Path

import numpy as np
from PIL import Image

from mae_animation_checks import capture, stage, FPS
from runner import Harness, ROOT
from symbols import STATE_WAIT, STATE_DONE, _parse_constants


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=Path, default=ROOT / '_artifacts/sacred-fire')
    ap.add_argument('--record', action='store_true')
    args = ap.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    rom = ROOT / 'pokecrystal_debug.gbc'
    h, fixture = stage(rom)
    results = []
    try:
        con = _parse_constants(ROOT / 'constants/battle_anim_constants.asm')
        bank, address = h.sym['BattleAnimFrameData.Frameset_SACRED_FIRE_REFERENCE']
        sequence = bytes(h.pb.memory[bank, address:address + 6])
        assert sequence == bytes((con['BATTLEANIMOAMSET_0E'], 0, 4,
                                  con['BATTLEANIMOAMSET_0A'], 0, 4)), sequence
        for side in (0, 1):
            spawns = []
            def spawned(_):
                m = h.battle.mem
                spawns.append((m.read('wBattleObjectTempID') |
                               m.read('wBattleObjectTempIDHi') << 8,
                               m.read('wBattleObjectTempParam')))
            h.pb.hook_register(*h.sym['InitBattleAnimation'], spawned, None)
            frames, _, result = capture(h, fixture, 'SACRED_FIRE', side)
            h.pb.hook_deregister(*h.sym['InitBattleAnimation'])
            assert sum(obj == con['ANIM_OBJ_SACRED_FIRE_BLUE'] for obj, _ in spawns) == 8
            assert [param for obj, param in spawns
                    if obj == con['ANIM_OBJ_SACRED_FIRE_BLUE_BURST']] == [
                        0x38, 0x10, 0x2a, 0x04, 0x3b, 0x18, 0x1a, 0x0a, 0x1e, 0x30] * 2
            assert sum(obj == con['ANIM_OBJ_SACRED_FIRE_CENTER'] for obj, _ in spawns) == 1
            # Actual PPU output uses the GBC's five-bit channels shifted left 3.
            pixels = np.array(frames)
            for color in ((16, 112, 200), (64, 160, 248)):
                count = int(np.all(pixels == color, axis=3).sum())
                assert count > 1000, (side, color, count)
            blue = (np.all(pixels == (16, 112, 200), axis=3) |
                    np.all(pixels == (64, 160, 248), axis=3)).sum(axis=(1, 2))
            visible = np.flatnonzero(blue)
            assert 270 <= visible[-1] - visible[0] <= 290, (side, visible[[0, -1]])
            assert blue[visible[-1]] in (32, 112), (side, 'center spark silhouette', blue[visible[-1]])
            assert result['final_frame_changed_pixels'] == 0, result
            result['rising_flames'] = 8
            result['burst_pairs'] = 10
            result['center_spark'] = True
            result['visible_effect_frames'] = [int(visible[0]), int(visible[-1])]
            result['flame_sequence'] = 'small, large; four-tick frame durations'
            results.append(result)
            sheet = Image.new('RGB', (1280, 576))
            for cell, index in enumerate((30, 65, 110, 195, 225, 250, 275, 290)):
                shot = Image.fromarray(frames[index]).resize((320, 288), Image.Resampling.NEAREST)
                sheet.paste(shot, (cell % 4 * 320, cell // 4 * 288))
            sheet.save(args.output / f'sacred-fire-{side}.png')
            if side == 0:
                np.save(args.output / 'player-frames.npy', pixels)
    finally:
        h.pb.stop(save=False)
    report = {'rom_sha256': hashlib.sha256(rom.read_bytes()).hexdigest(), 'checks': results}
    print('PASS both sides: blue colors, eight rising flames, ten burst pairs, pulsing center, cleanup', flush=True)
    if args.record:
        record_battle(args.output, report)
    (args.output / 'results.json').write_text(json.dumps(report, indent=2) + '\n')


def record_battle(output, report):
    import imageio_ffmpeg
    ff = imageio_ffmpeg.get_ffmpeg_exe()
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    h.bootstrap()
    h.battle.mem.write('wOptions', 0x41)
    frames, samples, starts = [], [], []
    def tick(count=1):
        for _ in range(count):
            h.pb.tick(1, True, True)
            frames.append(h.pb.screen.ndarray[:, :, :3].copy())
            sound = h.pb.sound
            sample = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                                   count=sound.raw_buffer_head).reshape(-1, 2)
            samples.append(sample.astype(np.int16) * 256)
    def animation(_):
        m = h.battle.mem
        ident = m.read('wFXAnimID') | m.read('wFXAnimID', 1) << 8
        if ident == h.con.moves['SACRED_FIRE']:
            starts.append(len(frames))
    h.tick = tick
    h.pb.hook_register(*h.sym['PlayBattleAnim'], animation, None)
    try:
        assert h.run_battle({
            'player': {'species': 'HO_OH', 'level': 50, 'dvs': 0xaaaa,
                       'ability': 'NO_ABILITY', 'moves': ['SACRED_FIRE']},
            'enemy': {'species': 'SPEAROW', 'level': 50,
                      'ability': 'NO_ABILITY', 'moves': ['SPLASH']},
            'rng': 'forced_low', 'turns': 1,
        }) in (STATE_WAIT, STATE_DONE)
        tick(45)
        assert starts, 'Sacred Fire never executed'
        first = max(0, starts[0] - 75)
        last = min(len(frames), starts[0] + 500)
        sheet = Image.new('RGB', (960, 576))
        for cell, offset in enumerate((30, 65, 110, 225, 250, 280)):
            shot = Image.fromarray(frames[min(starts[0] + offset, last - 1)])
            sheet.paste(shot.resize((320, 288), Image.Resampling.NEAREST),
                        (cell % 3 * 320, cell // 3 * 288))
        sheet.save(output / 'ingame-frames.png')
        pcm = np.concatenate(samples[first:last])
        assert np.abs(pcm.astype(np.int32)).max() > 0, 'silent recording'
        silent = output / 'sacred-fire-silent.mp4'
        encoder = subprocess.Popen([ff, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '160x144',
            '-framerate', str(FPS), '-i', '-', '-an', '-vf', 'scale=640:576:flags=neighbor',
            '-c:v', 'libx264', '-crf', '16', '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
        for frame in frames[first:last]:
            encoder.stdin.write(frame.tobytes())
        encoder.stdin.close()
        assert encoder.wait() == 0
        wav = output / 'sacred-fire-audio.wav'
        with wave.open(str(wav), 'wb') as stream:
            stream.setnchannels(2)
            stream.setsampwidth(2)
            stream.setframerate(48000)
            stream.writeframes(pcm.astype('<i2').tobytes())
        video = output / 'sacred-fire-ingame.mp4'
        subprocess.run([ff, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav),
            '-c:v', 'copy', '-c:a', 'aac', '-b:a', '192k', '-shortest',
            '-movflags', '+faststart', str(video)], check=True)
        subprocess.run([ff, '-v', 'error', '-i', str(video), '-f', 'null', '-'], check=True)
        report['recording'] = {'video': video.name, 'frames': last - first,
                               'seconds': (last - first) / FPS, 'audio': 'native game audio',
                               'battle': 'shiny Ho-Oh uses Sacred Fire against Spearow'}
        print('VIDEO', video, flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
