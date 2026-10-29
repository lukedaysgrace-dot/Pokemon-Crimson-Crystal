#!/usr/bin/env python3
"""Render and audit the creative move set; --record exports its audio showcase."""
import argparse
import hashlib
import io
import json
import subprocess
import wave
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import FPS, capture, stage
from october_animation_checks import AnimationAudit
from runner import ROOT, Harness
from symbols import STATE_WAIT, _parse_constants

MOVES = ['ARMOR_CANNON', 'APPLE_ACID', 'FIERY_DANCE', 'FOUL_PLAY', 'GIGA_HAMMER',
         'GRAV_APPLE', 'HEAT_CRASH', 'INFERNAL_PARADE', 'INFESTATION', 'OCTAZOOKA',
         'QUIVER_DANCE', 'SOLAR_BLADE', 'TAIL_GLOW']


def check_stat_finishes():
    """Exercise the actual battle effect, independently of preview fixtures."""
    h = Harness()
    h.ensure_fixture()
    sfx = _parse_constants(ROOT/'constants/sfx_constants.asm')
    sounds = []
    def on_sound(_):
        m = h.battle.mem
        address = m.read('wBattleAnimAddress') | m.read('wBattleAnimAddress', 1) << 8
        sounds.append(h.pb.memory[m.read('wBattleAnimScriptBank'), address+1])
    h.pb.hook_register(*h.sym['BattleAnimCmd_Sound'], on_sound, None)
    try:
        for move, rises in [('TAIL_GLOW', 3), ('NASTY_PLOT', 2)]:
            for side in ('player', 'enemy'):
                h.load_fixture(); sounds.clear()
                h.battle.mem.write('wOptions', 0x41)
                battlers = {key: {'species': 'MEW', 'level': 50, 'ability': 'NO_ABILITY', 'moves': ['SPLASH']}
                            for key in ('player', 'enemy')}
                battlers[side]['moves'] = [move]
                result = h.run_battle(dict(battlers, rng='forced_low', turns=1))
                assert result == STATE_WAIT, (move, side, result)
                assert sounds.count(sfx['SFX_STAT_UP']) == rises, (move, side, sounds)
                symbol = 'wPlayerStatLevels' if side == 'player' else 'wEnemyStatLevels'
                assert h.battle.mem.read(symbol, 3) == 7+rises, (move, side)
                print('PASS real battle', move, side, rises, 'Special Attack rises', flush=True)
    finally:
        h.pb.stop(save=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--moves', nargs='+', default=MOVES)
    parser.add_argument('--record', action='store_true')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/creative-moves')
    args = parser.parse_args()
    out = args.output.resolve(); out.mkdir(parents=True, exist_ok=True)
    h, fixture = stage(ROOT/'pokecrystal_debug.gbc', audio=args.record)
    audit = AnimationAudit(h, ROOT/'pokecrystal_debug.gbc')
    sounds = []
    def sound_hook(_):
        m = h.battle.mem
        address = m.read('wBattleAnimAddress') | m.read('wBattleAnimAddress', 1) << 8
        sounds.append(h.pb.memory[m.read('wBattleAnimScriptBank'), address+1])
    h.pb.hook_register(*h.sym['BattleAnimCmd_Sound'], sound_hook, None)
    checks, failures, chapters, recordings = [], [], [], []
    try:
        for move in args.moves:
            variants = [1, 0] if move == 'SOLAR_BLADE' else [0]
            for param in variants:
                sequences, audio = [], None
                label = move + (' / charge' if param else ' / strike') if move == 'SOLAR_BLADE' else move
                for side in (0, 1):
                    audit.current = f'{move}/{side}'
                    audit.spawns.clear(); audit.errors.clear(); audit.attempts.clear()
                    sounds.clear()
                    try:
                        frames, pcm, result = capture(h, fixture, move, side, args.record,
                                                      param=param, observer=audit.observe)
                        errors = list(audit.errors)
                        if len(audit.attempts) != len(audit.spawns):
                            errors.append(['dropped object allocation', len(audit.attempts), len(audit.spawns)])
                        assert result['final_frame_changed_pixels'] == 0, result
                        names = [p['object'] for p in audit.spawns]
                        expected = {'GRAV_APPLE':'ANIM_OBJ_APPLE_DROP',
                                    'APPLE_ACID':'ANIM_OBJ_APPLE_SHOT',
                                    'GIGA_HAMMER':'ANIM_OBJ_GIGATON_HAMMER',
                                    'INFESTATION':'ANIM_OBJ_INFESTATION_BUG',
                                    'HEAT_CRASH':'ANIM_OBJ_HEAT_COMET',
                                    'OCTAZOOKA':'ANIM_OBJ_TARGET_BURNOUT'}.get(move)
                        if expected: assert expected in names, (move, names)
                        if move in ('GRAV_APPLE', 'GIGA_HAMMER', 'HEAT_CRASH'):
                            particle = next(p for p in audit.spawns if p['object'] == expected)
                            offsets = [p[2] for p in particle['samples']]
                            assert max(offsets)-min(offsets) >= 48, (move, 'heavy object did not fall')
                        if move == 'INFESTATION':
                            assert names.count('ANIM_OBJ_INFESTATION_BUG') == 6
                        result['objects'] = names
                        result['sound_ids'] = list(sounds)
                        result['graphics_errors'] = errors
                        if errors: failures.append([label, side, errors])
                        if move == 'TAIL_GLOW':
                            # Show the real generic stat animation that follows Tail Glow.
                            h.battle.mem.write('wLoweredStat', 0x23)
                            followup = io.BytesIO(); h.pb.save_state(followup)
                            sounds.clear(); audit.current = f'TAIL_GLOW_FINISH/{side}'
                            sf, sa, sc = capture(h, followup, 'ANIM_STAT_UP', side,
                                                 args.record, param=3)
                            sfx = _parse_constants(ROOT/'constants/sfx_constants.asm')
                            assert sounds.count(sfx['SFX_STAT_UP']) == 3, sounds
                            result['special_attack_rises'] = 3
                            frames += sf
                            if args.record: pcm += sa
                        indices = np.linspace(0, len(frames)-1, 8, dtype=int)
                        sheet = Image.new('RGB', (1280, 624), '#101827'); draw = ImageDraw.Draw(sheet)
                        for n, index in enumerate(indices):
                            x, y = n%4*320, n//4*312
                            sheet.paste(Image.fromarray(frames[index]).resize((320, 288), Image.Resampling.NEAREST), (x, y+24))
                            draw.text((x+4, y+4), f'{label} / {side} / {index}', fill='white')
                        sheet.save(out/f'{move.lower()}-{param}-{side}.png')
                        np.savez_compressed(out/f'{move.lower()}-{param}-{side}.npz', frames=np.array(frames))
                        checks.append(result); sequences.append(frames)
                        if side == 0: audio = pcm
                        print('PASS' if not errors else 'FAIL', label, side, f'{len(frames)} frames', errors, flush=True)
                    except Exception as exc:
                        failures.append([label, side, repr(exc)])
                        print('FAIL', label, side, repr(exc), flush=True)
                if len(sequences) == 2:
                    recordings.append((label, sequences, audio))
    finally:
        h.pb.stop(save=False)
    report = {'rom_sha256': hashlib.sha256((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest(),
              'checks': checks, 'failures': failures}
    (out/'checks.json').write_text(json.dumps(report, indent=2)+'\n')
    assert not failures, failures
    if 'TAIL_GLOW' in args.moves:
        check_stat_finishes()
    if args.record:
        import imageio_ffmpeg
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 24)
        small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 18)
        enc = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
            '-pixel_format', 'rgb24', '-video_size', '1280x688', '-framerate', str(FPS/2),
            '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '17',
            '-pix_fmt', 'yuv420p', str(out/'showcase-silent.mp4')], stdin=subprocess.PIPE)
        count_written, sounds = 0, []
        for label, sequences, audio in recordings:
            chapters.append({'title': label, 'seconds': count_written*2/FPS})
            count = max(map(len, sequences))+40; count += count%2
            for i in range(0, count, 2):
                canvas = Image.new('RGB', (1280, 688), '#101827'); draw = ImageDraw.Draw(canvas)
                draw.text((20, 8), label.replace('_', ' ').title(), fill='white', font=font)
                for side, sequence in enumerate(sequences):
                    x = side*640
                    draw.text((x+20, 44), 'PLAYER USES THE MOVE' if side == 0 else 'OPPONENT USES THE MOVE', fill='#8de2b7', font=small)
                    canvas.paste(Image.fromarray(sequence[min(i, len(sequence)-1)]).resize((640, 576), Image.Resampling.NEAREST), (x, 72))
                draw.text((20, 659), 'Native ROM • game audio • Tail Glow includes its three Special Attack rises', fill='#b8c3d5', font=small)
                enc.stdin.write(canvas.tobytes()); count_written += 1
            pcm = np.concatenate(audio)
            assert np.abs(pcm.astype(np.int32)).max() > 0, label
            target = round(count/FPS*48000)
            sounds.append(np.pad(pcm[:target], ((0, max(0, target-len(pcm))), (0, 0))))
        enc.stdin.close(); assert enc.wait() == 0
        with wave.open(str(out/'showcase-audio.wav'), 'wb') as stream:
            stream.setnchannels(2); stream.setsampwidth(2); stream.setframerate(48000)
            stream.writeframes(np.concatenate(sounds).astype('<i2').tobytes())
        final = out/'creative-move-showcase.mp4'
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(out/'showcase-silent.mp4'),
            '-i', str(out/'showcase-audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '192k',
            '-shortest', '-movflags', '+faststart', str(final)], check=True)
        subprocess.run([ffmpeg, '-v', 'error', '-i', str(final), '-f', 'null', '-'], check=True)
        (out/'chapters.json').write_text(json.dumps(chapters, indent=2)+'\n')
        print('VIDEO', final, flush=True)


if __name__ == '__main__':
    main()
