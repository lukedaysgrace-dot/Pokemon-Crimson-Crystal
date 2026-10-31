#!/usr/bin/env python3
"""Record complete native Twin Beam turns from both sides with game audio."""

import hashlib
import io
import json
import subprocess
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import FPS
from runner import Harness, ROOT
from symbols import STATE_WAIT, _parse_constants


def main():
    output = ROOT / '_artifacts/twin-beam'
    output.mkdir(parents=True, exist_ok=True)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    silent = output / 'silent.mp4'
    video = output / 'twin-beam-showcase.mp4'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '960x720', '-framerate', str(FPS),
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '17',
        '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
    font_dir = '/usr/share/fonts/truetype/dejavu/'
    title = ImageFont.truetype(font_dir + 'DejaVuSans-Bold.ttf', 27)
    small = ImageFont.truetype(font_dir + 'DejaVuSans.ttf', 18)
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    h.bootstrap()
    menu = io.BytesIO()
    h.pb.save_state(menu)
    effect = _parse_constants(ROOT / 'constants/move_effect_constants.asm')['EFFECT_SP_DEF_DOWN_DOUBLE_HIT']
    active = None
    samples, chapters, checks = [], [], []
    total = 0
    proc_count = 0
    leer_count = 0
    leer_sfx = _parse_constants(ROOT / 'constants/sfx_constants.asm')['SFX_LEER']

    def sound_started(_):
        nonlocal leer_count
        regs = h.pb.register_file
        if active is not None and regs.D * 256 + regs.E == leer_sfx:
            leer_count += 1

    def is_twin_beam():
        m = h.battle.mem
        turn = m.read('hBattleTurn')
        struct = 'wEnemyMoveStruct' if turn else 'wPlayerMoveStruct'
        return active is not None and turn == active and m.read(struct, 1) == effect

    def secondary(_):
        nonlocal proc_count
        if is_twin_beam():
            # Show the optional effect deliberately while retaining real damage
            # calculation and all native battle/animation/sound routines.
            proc_count += 1
            h.battle.mem.write('hDebugRNGValue', 20)

    def restore_rng(_):
        if is_twin_beam():
            h.battle.mem.write('hDebugRNGValue', 180)

    h.pb.hook_register(*h.sym['BattleCommand_EffectChance_Core'], secondary, None)
    h.pb.hook_register(*h.sym['BattleCommand_MoveAnimNoSub'], restore_rng, None)
    h.pb.hook_register(*h.sym['PlayStereoSFX'], sound_started, None)

    def write_frame(side):
        nonlocal total
        canvas = Image.new('RGB', (960, 720), '#101827')
        draw = ImageDraw.Draw(canvas)
        draw.text((480, 20), 'TWIN BEAM  |  Crimson Crystal', font=title, anchor='mt', fill='white')
        draw.text((480, 58), 'Player uses Twin Beam' if side == 0 else 'Opponent uses Twin Beam',
                  font=small, anchor='mt', fill='#b9a5ff')
        canvas.paste(h.pb.screen.image.resize((640, 576), Image.Resampling.NEAREST), (160, 88))
        draw.text((480, 676), '45 power per hit  /  10% chance per hit to lower Special Defense',
                  font=small, anchor='mt', fill='#e2e8f0')
        draw.text((480, 700), 'Native game audio. Both optional drops selected for this demonstration.',
                  font=small, anchor='mt', fill='#a4b0c4')
        encoder.stdin.write(canvas.tobytes())
        sound = h.pb.sound
        raw = np.frombuffer(sound.raw_buffer, dtype=np.int8, count=sound.raw_buffer_head).reshape(-1, 2)
        samples.append(raw.astype(np.int16) * 256)
        if total == 30:
            canvas.save(output / 'preview.png')
        total += 1

    try:
        for side in (0, 1):
            menu.seek(0)
            h.pb.load_state(menu)
            m = h.battle.mem
            m.write('wOptions', 0x41)
            user = {'species': 'GIRAFARIG', 'level': 50, 'ability': 'NO_ABILITY', 'moves': ['TWIN_BEAM']}
            target = {'species': 'SNORLAX', 'level': 100, 'ability': 'NO_ABILITY', 'moves': ['SPLASH']}
            assert h.run_battle({'player': target if side else user,
                                 'enemy': user if side else target,
                                 'rng': 'forced_high', 'turns': 0}) == STATE_WAIT
            active = side
            proc_count = 0
            leer_count = 0
            chapters.append({'side': side, 'seconds': total / FPS})
            m.write('wDebugTurnTarget', 1)
            m.write('wDebugControl', 1)
            print('Recording full turn', side, flush=True)
            start = total
            for frame in range(10000):
                if frame % 6 == 0:
                    h.pb.button('a', 2)
                h.pb.tick(1, True, True)
                write_frame(side)
                if h.state() == STATE_WAIT and h.battle.turns_done == 1:
                    break
            else:
                raise AssertionError(('recording timeout', h.control_state()))
            active = None
            defender = h.battle.player if side else h.battle.enemy
            assert proc_count == 2 and defender.stat_levels[4] == 5
            assert leer_count == 4, ('expected two Leer sounds per hit', leer_count)
            assert m.read('wPlayerRageFistHits' if side else 'wEnemyRageFistHits') == 2
            assert not h.text_overflows, h.text_overflows
            for _ in range(60):
                h.pb.tick(1, True, True)
                write_frame(side)
            checks.append({'side': side, 'frames': total - start, 'hits': 2,
                           'secondary_rolls': proc_count, 'beam_sound_effects': leer_count,
                           'final_sp_def_stage': defender.stat_levels[4]})
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        assert encoder.wait() == 0

    audio = np.concatenate(samples)
    assert np.abs(audio.astype(np.int32)).max() > 0, 'silent recording'
    target_samples = round(total / FPS * 48000)
    audio = np.pad(audio[:target_samples], ((0, max(0, target_samples - len(audio))), (0, 0)))
    wav_path = output / 'game-audio.wav'
    with wave.open(str(wav_path), 'wb') as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(48000)
        wav.writeframes(audio.astype('<i2').tobytes())
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav_path),
                    '-c:v', 'copy', '-c:a', 'aac', '-b:a', '192k', '-shortest',
                    '-movflags', '+faststart', str(video)], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(video), '-f', 'null', '-'], check=True)
    (output / 'recording.json').write_text(json.dumps({'seconds': total/FPS, 'chapters': chapters,
        'checks': checks, 'rom_sha256': hashlib.sha256((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest(),
        'secondary_rolls_forced_for_demonstration': True, 'audio_samples': len(audio)}, indent=2) + '\n')
    print('PASS both native turns, two hits and drops per side, audible audio and complete MP4 decoding', flush=True)
    print(video, flush=True)


if __name__ == '__main__':
    main()
