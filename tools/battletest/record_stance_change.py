#!/usr/bin/env python3
"""Record both native Aegislash form changes and King Shield, with game audio."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import subprocess
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import FPS
from runner import Harness, ROOT, apply_wram_setup
from symbols import STATE_WAIT


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--out', type=Path, default=ROOT / '_artifacts/roster/stance-change-video')
    out = parser.parse_args().out
    out.mkdir(parents=True, exist_ok=True)
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    h.bootstrap()
    menu = io.BytesIO()
    h.pb.save_state(menu)
    m = h.battle.mem
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    title = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 27)
    small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 21)
    total = 0
    written = 0
    samples, chapters, checks, snapshots = [], [], [], []
    fade_events, fade_samples = [], []
    phase = ''
    side = 0
    def fade_started(_):
        event = {'side': side, 'frame': total, 'mapping': h.pb.register_file.A,
                 'form': m.read('wPlayerBladeForm' if side == 0 else 'wEnemyBladeForm')}
        if not fade_events or event != fade_events[-1]:
            fade_events.append(event)
    h.pb.hook_register(*h.sym['SetStanceFadePalette'], fade_started, None)
    silent = out / 'silent.mp4'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '960x720', '-framerate', str(FPS/2),
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
        '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)

    def frame():
        nonlocal total, written
        h.pb.tick(1, True, True)
        sound = h.pb.sound
        raw = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                            count=sound.raw_buffer_head).reshape(-1, 2)
        samples.append(raw.astype(np.int16) * 256)
        if fade_events:
            event = fade_events[-1]
            if total-event['frame'] >= 1 and not event.get('captured'):
                event['captured'] = True
                fade_samples.append((dict(event), h.pb.screen.image.convert('RGB').copy()))
        if total % 2 == 0:
            canvas = Image.new('RGB', (960, 720), '#101827')
            draw = ImageDraw.Draw(canvas)
            draw.text((480, 15), 'AEGISLASH  |  STANCE CHANGE', font=title, anchor='mt', fill='white')
            draw.text((480, 52), phase, font=small, anchor='mt', fill='#7de1ba')
            canvas.paste(h.pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (160, 86))
            blade = m.read('wPlayerBladeForm' if side == 0 else 'wEnemyBladeForm')
            holder = h.battle.player if side == 0 else h.battle.enemy
            draw.text((480, 680), f"{'Player' if side == 0 else 'Opponent'} side  |  {'Blade' if blade else 'Shield'} Form"
                      f"  |  Attack {holder.stats['attack']} / Defense {holder.stats['defense']}",
                      font=small, anchor='mt', fill='white')
            encoder.stdin.write(canvas.tobytes())
            written += 1
        total += 1

    def hold(label, picture=None):
        nonlocal phase
        phase = label
        print(label, flush=True)
        for _ in range(105):
            frame()
        if picture:
            image = h.pb.screen.image.convert('RGB').copy()
            image.save(out / (picture+'.png'))
            snapshots.append((picture.replace('-', ' ').title(), image))

    def advance(target, label):
        nonlocal phase
        phase = label
        print(label, flush=True)
        m.write('wDebugTurnTarget', target)
        m.write('wDebugControl', 1)
        for elapsed in range(12000):
            if elapsed % 12 == 0:
                h.pb.button('a', 2)
            frame()
            if h.state() == STATE_WAIT and h.battle.turns_done == target:
                assert not h.text_overflows, h.text_overflows
                return
        raise AssertionError(('recording timeout', h.control_state()))

    try:
        for side in (0, 1):
            menu.seek(0)
            h.pb.load_state(menu)
            h.text_overflows.clear()
            m.write('wOptions', 0x41)  # normal battle animations, medium-speed text
            aegislash = {'species': 'AEGISLASH', 'level': 100, 'ability': 'STANCE_CHANGE',
                         'moves': ['IRON_HEAD', 'KINGS_SHIELD']}
            other = {'species': 'FERALIGATR', 'level': 100, 'ability': 'TORRENT', 'moves': ['BITE']}
            spec = {'player': aegislash if side == 0 else other,
                    'enemy': other if side == 0 else aegislash,
                    'rng': 'forced_high', 'turns': 0,
                    'move_script': [1, 2] if side == 0 else [1, 1]}
            assert h.run_battle(spec) == STATE_WAIT
            flag = 'wPlayerBladeForm' if side == 0 else 'wEnemyBladeForm'
            holder = h.battle.player if side == 0 else h.battle.enemy
            attacker = h.battle.enemy if side == 0 else h.battle.player
            label = 'player' if side == 0 else 'opponent'
            chapters.append({'side': label, 'seconds': total/FPS})
            assert m.read(flag) == 0
            hold('Enters battle in Shield Form', label+'-entry-shield')
            advance(1, 'Iron Head activates Stance Change: Shield -> Blade')
            assert m.read(flag) == 1 and holder.species == 'AEGISLASH'
            assert holder.stats['attack'] > holder.stats['defense']
            hold('Blade Form after attacking', label+'-blade')
            hp = holder.hp
            assert hp > 0 and attacker.hp > 0
            if side == 1:
                # Choose the opponent's next move at the turn boundary; all
                # form changes, guard checks and contact effects remain native.
                apply_wram_setup(h.battle, {'wEnemyMonMoves': {'move': 'KINGS_SHIELD'}})
            advance(2, "King Shield: Blade -> Shield, then blocks Bite")
            assert m.read(flag) == 0 and holder.species == 'AEGISLASH'
            assert holder.stats['defense'] > holder.stats['attack']
            assert holder.hp == hp, 'Guard failed to block the contact attack'
            assert attacker.stat_levels[0] == 6, 'Contact attacker did not lose one Attack stage'
            hold("Shield Form restored | Bite blocked | Attacker's Attack -1", label+'-kings-shield')
            checks.append({'side': label, 'shield_blade_shield': True, 'real_species_preserved': True,
                           'guard_hp_preserved': True, 'contact_attack_stage': attacker.stat_levels[0]-7})
            if total % 2:
                frame()
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        assert encoder.wait() == 0

    audio = np.concatenate(samples)
    assert np.abs(audio.astype(np.int32)).max() > 0, 'Recording has no game audio'
    target = round(written*2/FPS*48000)
    audio = np.pad(audio[:target], ((0, max(0, target-len(audio))), (0, 0)))
    wav_path = out / 'game-audio.wav'
    with wave.open(str(wav_path), 'wb') as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(48000)
        wav.writeframes(audio.astype('<i2').tobytes())
    video = out / 'aegislash-both-sides.mp4'
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav_path),
                    '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k', '-shortest',
                    '-movflags', '+faststart', str(video)], check=True)
    seconds = written*2/FPS
    for index, chapter in enumerate(chapters):
        start = chapter['seconds']
        end = chapters[index+1]['seconds'] if index+1 < len(chapters) else seconds
        clip = out / ('aegislash-'+chapter['side']+'.mp4')
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(video), '-ss', str(start),
                        '-t', str(end-start), '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
                        '-c:a', 'aac', '-movflags', '+faststart', str(clip)], check=True)
        subprocess.run([ffmpeg, '-v', 'error', '-i', str(clip), '-f', 'null', '-'], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(video), '-f', 'null', '-'], check=True)
    sheet = Image.new('RGB', (960, 624), '#101827')
    draw = ImageDraw.Draw(sheet)
    for index, (label, picture) in enumerate(snapshots):
        x, y = index%3*320, index//3*312
        draw.text((x+8, y+5), label, fill='white')
        sheet.paste(picture.resize((320, 288), Image.Resampling.NEAREST), (x, y+22))
    sheet.save(out / 'review.png')
    if fade_samples:
        sheet = Image.new('RGB', (1792, 1120), '#101827')
        draw = ImageDraw.Draw(sheet)
        grouped = {}
        for event, picture in fade_samples:
            grouped.setdefault((event['side'], event['form']), []).append((event, picture))
        for row, ((which, form), entries) in enumerate(grouped.items()):
            for column, (event, picture) in enumerate(entries[:7]):
                x, y = column*256, row*280
                draw.text((x+4, y+4), f"{'Player' if which == 0 else 'Opponent'} {'Blade' if form else 'Shield'}  ${event['mapping']:02x}", fill='white')
                box = (0, 48, 56, 112) if which == 0 else (96, 0, 160, 56)
                crop = picture.crop(box)
                crop = crop.resize((crop.width*4, crop.height*4), Image.Resampling.NEAREST)
                sheet.paste(crop, (x+(256-crop.width)//2, y+22))
        sheet.save(out / 'transition-review.png')
    (out / 'recording.json').write_text(json.dumps({'seconds': seconds, 'chapters': chapters,
        'checks': checks, 'fade_events': fade_events, 'game_audio': True, 'native_animations': True,
        'rom_sha256': hashlib.sha256((ROOT/'pokecrystal_debug.gbc').read_bytes()).hexdigest()}, indent=2)+'\n')
    print('PASS native Shield -> Blade -> Shield, contact block/Attack drop, both sides, audio and MP4 decode', flush=True)
    print(video, flush=True)


if __name__ == '__main__':
    main()
