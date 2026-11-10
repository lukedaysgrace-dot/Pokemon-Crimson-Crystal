#!/usr/bin/env python3
"""Record changed non-regional cries in native battles with real video/audio.

Private new game + native debug battle requests. No injected PlayCry calls,
audio replacements, player saves, or rendered mock battles are used.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path
import subprocess
import wave

import imageio_ffmpeg
from PIL import Image, ImageDraw

from sameboy_session import Session
from state import Request
from symbols import STATE_WAIT, STATE_ERROR, STATE_DONE

ROOT = Path(__file__).resolve().parents[2]
FPS = 4194304 / 70224
SPECIES = ['BAGON', 'GARDEVOIR', 'LILEEP', 'TRAPINCH', 'FLYGON', 'DUSKNOIR',
           'HONEDGE', 'AEGISLASH', 'ZANGOOSE', 'SEVIPER', 'TINKATON', 'JIRACHI', 'HIPPOPOTAS']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--species', nargs='*')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/cry-battles')
    parser.add_argument('--fixture', type=Path)
    args = parser.parse_args()
    names = args.species or SPECIES
    manifest = json.loads((ROOT/'tools/testdata/sampled_cries.json').read_text())
    assert all(name in manifest['replacements'] for name in names), 'Only remaining changed cries belong in this video'
    rom = ROOT/'pokecrystal_debug.gbc'
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    s = Session(rom)
    m = s.battle.mem
    if args.fixture:
        s.load(args.fixture.read_bytes())
    else:
        s.bootstrap()
    menu = s.save()
    assert m.read('wDebugState') == 1
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    results, snapshots = [], []
    try:
        for number, name in enumerate(names, 1):
            animation_path = ROOT/f'gfx/pokemon/{name.lower()}/anim.asm'
            has_motion_art = any(int(n) > 0 for n in re.findall(
                r'^\s*frame\s+(\d+)', animation_path.read_text(), re.M))
            s.load(menu)
            m.write('wOptions', 0x41)
            spec = dict(player=dict(species='PIKACHU', level=60, moves=['TAIL_WHIP', 'THUNDERSHOCK']),
                        enemy=dict(species=name, level=30), turns=0, rng='forced_high', move_script=[1])
            Request(s.battle).write(spec)
            silent = out/f'{number:02d}-{name.lower()}-silent.mp4'
            target = out/f'{number:02d}-{name.lower()}.mp4'
            encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
                '-pixel_format', 'rgb24', '-video_size', '640x576', '-framerate', str(FPS/2),
                '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '17',
                '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
            audio, frames, video_frames, cry_frames = [], 0, 0, 0
            started, entry_done, resumed = False, False, False
            entry_at, after_at = None, None
            moving_during_cry, cry_poses, pose_first_frames = False, set(), []
            animation_steps = set()

            def record():
                nonlocal frames, video_frames, cry_frames, moving_during_cry
                if frames % 2 == 0:
                    encoder.stdin.write(s.image().resize((640, 576), Image.Resampling.NEAREST).tobytes())
                    video_frames += 1
                audio.append(s.sound)
                if m.read('hSoundKeepaliveOn') & 128:
                    cry_frames += 1
                    animation_steps.add(m.read('wPokeAnimFrame'))
                    pose = hashlib.sha256(s.image().crop((96, 0, 152, 56)).tobytes()).hexdigest()
                    if pose not in cry_poses:
                        cry_poses.add(pose)
                        pose_first_frames.append(frames)
                    if len(cry_poses) >= 2: moving_during_cry = True
                frames += 1

            try:
                for elapsed in range(3600):
                    # Press A only to advance the game's own text boxes.
                    s.tick(16 if elapsed % 20 < 2 else 0)
                    state = m.read('wDebugState')
                    if state == STATE_ERROR: raise RuntimeError(f'{name}: rejected native battle request')
                    if not started and m.read('wBattleMode'):
                        started = True
                    if not started: continue
                    record()
                    if state == STATE_WAIT and not entry_done:
                        assert s.battle.enemy.species == name, (name, s.battle.enemy.species)
                        assert cry_frames > 0, f'{name}: sampled cry did not execute during the battle entrance'
                        assert m.read('wDEDUnderruns') == 0, f'{name}: audio buffer underrun'
                        if has_motion_art:
                            assert moving_during_cry, f'{name}: picture did not move while its cry played'
                            assert len(animation_steps) > 1, f'{name}: animation script did not advance during its cry'
                        entry_done, entry_at = True, frames
                        picture = s.image()
                        picture.save(out/f'{number:02d}-{name.lower()}-entry.png')
                        snapshots.append((name, picture))
                    if entry_done and not resumed and frames-entry_at >= 60:
                        m.write('wDebugTurnTarget', 1)
                        m.write('wDebugControl', 1)
                        resumed = True
                    if resumed and state == STATE_WAIT and m.read('wDebugTurnsDone') >= 1 and after_at is None:
                        after_at = frames
                    if resumed and state == STATE_DONE and after_at is None:
                        after_at = frames
                    if after_at is not None and frames-after_at >= 75: break
                else:
                    raise RuntimeError(f'{name}: battle video timed out, state={m.read("wDebugState")}')
                assert entry_done and resumed
                if frames % 2:
                    s.tick()
                    record()
            finally:
                encoder.stdin.close()
                if encoder.wait(): raise RuntimeError('Video encoder failed')
            raw = b''.join(audio)
            wanted = round(video_frames*2/FPS*48000)*4
            raw = raw[:wanted] + bytes(max(0, wanted-len(raw)))
            wav_path = out/f'{number:02d}-{name.lower()}-game-audio.wav'
            with wave.open(str(wav_path), 'wb') as stream:
                stream.setnchannels(2); stream.setsampwidth(2); stream.setframerate(48000); stream.writeframes(raw)
            subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav_path),
                '-c:v', 'copy', '-c:a', 'aac', '-b:a', '256k', '-shortest', '-movflags', '+faststart', str(target)], check=True)
            subprocess.run([ffmpeg, '-v', 'error', '-i', str(target), '-f', 'null', '-'], check=True)
            results.append(dict(species=name, file=target.name, frames=frames, seconds=frames/FPS,
                                native_entrance=True, sampled_cry_frames=cry_frames, combat_turns=m.read('wDebugTurnsDone'),
                                animated_art=has_motion_art,
                                animation_overlaps_cry=moving_during_cry, distinct_poses_during_cry=len(cry_poses),
                                pose_first_frames=pose_first_frames, animation_steps_during_cry=sorted(animation_steps),
                                audio_underruns=m.read('wDEDUnderruns')))
            print(f'{number}/{len(names)} {name}: {frames/FPS:.1f}s, cry visible for {cry_frames} frames', flush=True)
        playlist = out/'concat.txt'
        playlist.write_text(''.join("file '"+r['file']+"'\n" for r in results))
        compilation = out/'changed-cries-native-battles.mp4'
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-f', 'concat', '-safe', '0', '-i', str(playlist),
                        '-c', 'copy', '-movflags', '+faststart', str(compilation)], check=True)
        subprocess.run([ffmpeg, '-v', 'error', '-i', str(compilation), '-f', 'null', '-'], check=True)
        sheet = Image.new('RGB', (320*4, 312*4), '#101827')
        draw = ImageDraw.Draw(sheet)
        for i, (name, picture) in enumerate(snapshots):
            x, y = i%4*320, i//4*312
            draw.text((x+8, y+5), name, fill='white')
            sheet.paste(picture.resize((320, 288), Image.Resampling.NEAREST), (x, y+24))
        sheet.save(out/'battle-entrances.png')
        report = dict(rom=rom.name, rom_sha256=hashlib.sha256(rom.read_bytes()).hexdigest(), engine='SameBoy',
                      native_audio=True, regional_examples=False, battles=results, compilation=compilation.name)
        (out/'results.json').write_text(json.dumps(report, indent=2))
        print(f'Finished {len(results)} native battle clips', flush=True)
    finally:
        s.close()


if __name__ == '__main__':
    main()
