#!/usr/bin/env python3
"""Record every active battle animation alphabetically, with both sides/audio.

The plan is generated from the live move table and reachable parameter branches.
Per-entry native captures are cached under the ROM hash for resumable encoding.
No player save is loaded. Inactive/legacy script alternatives are not move entries.
"""
import argparse
from collections import Counter
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import sys
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

from mae_animation_checks import FPS, stage
from runner import ROOT
from save_menu_checks import begin_native_call
from symbols import _parse_constants

sys.path.insert(0, str(ROOT/'tools'))
from audit_mae_animations import Scripts
from audit_sour_apple_completeness import Program

CHARGE = {'FLY', 'DIG', 'DIVE', 'BOUNCE', 'PHANTOM_FORCE', 'PHANTOMFORCE', 'SKY_DROP',
          'SKY_ATTACK', 'SKULL_BASH', 'SOLARBEAM', 'SOLAR_BLADE', 'RAZOR_WIND'}
SPECIAL_NAMES = {
    'ANIM_THROW_POKE_BALL': 'Ball Throw', 'ANIM_SEND_OUT_MON': 'Send Out Pokemon',
    'ANIM_RETURN_MON': 'Return Pokemon', 'ANIM_CONFUSED': 'Confusion Status',
    'ANIM_SLP': 'Sleep Status', 'ANIM_BRN': 'Burn Status', 'ANIM_PSN': 'Poison Status',
    'ANIM_SAP': 'Leech Seed Drain', 'ANIM_FRZ': 'Freeze Status',
    'ANIM_PAR': 'Paralysis Status', 'ANIM_IN_LOVE': 'Infatuation Status',
    'ANIM_IN_HAIL': 'Hail Damage', 'ANIM_IN_SANDSTORM': 'Sandstorm Damage',
    'ANIM_IN_NIGHTMARE': 'Nightmare Damage', 'ANIM_IN_WHIRLPOOL': 'Whirlpool Damage',
    'ANIM_MISS': 'Miss', 'ANIM_ENEMY_DAMAGE': 'Enemy Damage',
    'ANIM_ENEMY_STAT_DOWN': 'Enemy Stat Down', 'ANIM_PLAYER_STAT_DOWN': 'Player Stat Down',
    'ANIM_PLAYER_DAMAGE': 'Player Damage', 'ANIM_WOBBLE': 'Battler Wobble',
    'ANIM_SHAKE': 'Battler Shake', 'ANIM_HIT_CONFUSION': 'Confusion Self Hit',
    'ANIM_INTRO_RAIN': 'Weather Intro - Rain', 'ANIM_INTRO_SUN': 'Weather Intro - Sun',
    'ANIM_INTRO_HAIL': 'Weather Intro - Hail',
    'ANIM_INTRO_SANDSTORM': 'Weather Intro - Sandstorm',
    'ANIM_SWEET_SCENT_2': 'Sweet Scent - Field Follow Up',
    'ANIM_STAT_UP': 'Stat Up', 'ANIM_STAT_DOWN': 'Stat Down',
}


def number(token, constants):
    if token.startswith('$'):
        return int(token[1:], 16)
    if token.startswith('%'):
        return int(token[1:], 2)
    if token.isdigit():
        return int(token)
    return constants[token]


def plan():
    scripts, program = Scripts(ROOT), Program(ROOT)
    constants = _parse_constants(ROOT/'constants/item_constants.asm')
    constants.update(_parse_constants(ROOT/'constants/battle_constants.asm'))
    constants.update(_parse_constants(ROOT/'constants/move_constants.asm'))
    names = re.findall(r'^\s*db "([^"@]*)@"', (ROOT/'data/moves/names.asm').read_text(), re.M)
    moves = [(move, label) for move, label in scripts.moves.items() if move != 'NO_MOVE']
    assert len(names) == len(moves), (len(names), len(moves))
    entries = []
    for (move, label), name in zip(moves, names):
        params, targets = {0}, {}
        for line in program.reachable(label)['commands']:
            branch = re.match(r'anim_if_param_(?:equal|and) ([^,]+),\s*(.+)', line)
            if branch:
                value = number(branch[1], constants)
                params.add(value)
                targets[value] = branch[2]
        if targets and params == set(targets):
            # Dig branches explicitly on 0 and 2; its charge path is the
            # fallthrough at 1. Include a value that takes no equality branch.
            params.add(next(p for p in range(256) if p not in targets))
        order = sorted(params, key=lambda p: (0 if p == 1 else 1 if p == 0 else 2, p)) if move in CHARGE else sorted(params)
        for param in order:
            variant = ''
            if len(order) > 1:
                if move in CHARGE:
                    variant = {0: 'Strike', 1: 'Charge', 2: 'Miss / return'}.get(param, f'Variant {param}')
                elif move == 'WEATHER_BALL':
                    variant = {0: 'Normal', 1: 'Water / rain', 2: 'Fire / sun', 3: 'Rock / sandstorm', 4: 'Ice / hail'}[param]
                elif move == 'CURSE':
                    variant = 'Ghost' if param == 0 else 'Non-ghost'
                elif move == 'PRESENT':
                    variant = 'Healing gift' if param == 3 else 'Damaging gift'
                elif move == 'SUBSTITUTE':
                    variant = {0: 'Create', 1: 'Hide', 2: 'Show', 3: 'Remove'}[param]
                elif move == 'BIDE':
                    variant = 'Release' if param == 0 else 'Store energy'
                elif move == 'PURSUIT':
                    variant = 'Switching target' if param else 'Normal target'
                elif move == 'BEAT_UP':
                    variant = 'Party member' if param else 'Current battler'
                else:
                    variant = f'Variant {param}'
            if move == 'BEAT_UP' and param:
                # anim_beatup takes a species ID, not a party-slot index.
                param, variant = 6, 'Party member / Charizard'
            entries.append(dict(key=move, name=name.title(), kind='Move', label=label,
                                param=param, variant=variant, stage_count=1))
    move_text = (ROOT/'constants/move_constants.asm').read_text()
    special_names = re.findall(r'^\s*const (ANIM_\w+)', move_text.split('const_value = -$1b')[1].split('if const_value')[0], re.M)
    special_names += ['ANIM_SWEET_SCENT_2', 'ANIM_STAT_UP', 'ANIM_STAT_DOWN']
    for key in special_names:
        variants = [(0, '', 1)]
        if key == 'ANIM_THROW_POKE_BALL':
            variants = [(constants[k], k.replace('_', ' ').title(), 1) for k in ('POKE_BALL', 'GREAT_BALL', 'ULTRA_BALL', 'MASTER_BALL')]
            variants += [(0, 'Trainer blocks the ball', 1)]
        elif key == 'ANIM_SEND_OUT_MON':
            variants = [(0, 'Normal', 1), (1, 'Shiny', 1), (2, 'Unknown encounter', 1)]
        elif key in ('ANIM_STAT_UP', 'ANIM_STAT_DOWN'):
            variants = [(p, n+' / '+str(stages)+' stage'+('s' if stages > 1 else ''), stages)
                        for p, n in enumerate(('Attack', 'Defense', 'Speed', 'Sp. Attack', 'Sp. Defense', 'Accuracy', 'Evasion'))
                        for stages in (1, 2)] + [(15, 'Multiple stats / gray', 1)]
        for param, variant, stages in variants:
            entries.append(dict(key=key, name=SPECIAL_NAMES[key], kind='Special',
                                param=param, variant=variant, stage_count=stages))
    entries.sort(key=lambda r: (r['name'].casefold(), 0 if r['kind'] == 'Move' else 1))
    return entries


def capture_entry(h, fixture, entry, side):
    fixture.seek(0)
    h.pb.load_state(fixture)
    m, pb = h.battle.mem, h.pb
    key = entry['key']
    animation = h.con.moves[key] & 0xffff
    m.write('hBattleTurn', side)
    m.write_bytes('wFXAnimID', [animation & 255, animation >> 8])
    m.write('wBattleAnimParam', entry['param'])
    m.write('wLoweredStat', (entry['stage_count']-1) << 4 | (entry['param'] & 15))
    m.write('wNumHits', 0)
    m.write('wKickCounter', entry['param'])
    start = pb.screen.ndarray[:, :, :3].copy()
    frames, sound = [start], []
    begin_native_call(h, 'PlayBattleAnim')
    pb.memory[0xc0f0] = 0xf3
    for elapsed in range(1800):
        pb.tick(1, True, True)
        frames.append(pb.screen.ndarray[:, :, :3].copy())
        channel = pb.sound
        sound.append(np.frombuffer(channel.raw_buffer, dtype=np.int8,
                                  count=channel.raw_buffer_head).reshape(-1, 2).copy().astype(np.int16)*256)
        if pb.register_file.PC in (0xc0f1, 0xc0f3):
            break
    else:
        raise AssertionError((entry, side, 'animation did not return'))
    pb.memory[0xc0f0:0xc0f3] = [0xfb, 0x18, 0xfe]
    pb.register_file.PC = 0xc0f0
    for _ in range(10):
        pb.tick(1, True, True)
        frames.append(pb.screen.ndarray[:, :, :3].copy())
        channel = pb.sound
        sound.append(np.frombuffer(channel.raw_buffer, dtype=np.int8,
                                  count=channel.raw_buffer_head).reshape(-1, 2).copy().astype(np.int16)*256)
    assert not m.read('hLCDCPointer'), (entry, side, 'LCD effect left active')
    peak = max(int(np.any(frame != start, axis=2).sum()) for frame in frames)
    return np.stack(frames), np.concatenate(sound), dict(side=side, frames=len(frames), changed_pixels_peak=peak)


def stamp(seconds):
    milliseconds = round(seconds*1000)
    h, milliseconds = divmod(milliseconds, 3600000)
    m, milliseconds = divmod(milliseconds, 60000)
    s, milliseconds = divmod(milliseconds, 1000)
    return f'{h:02}:{m:02}:{s:02}.{milliseconds:03}'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/animation-catalog')
    parser.add_argument('--moves', nargs='+')
    parser.add_argument('--plan-only', action='store_true')
    parser.add_argument('--capture-only', action='store_true')
    parser.add_argument('--encode-only', action='store_true')
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    entries = plan()
    if args.moves:
        entries = [e for e in entries if e['key'] in args.moves]
    rom = ROOT/'pokecrystal_debug.gbc'
    rom_hash = hashlib.md5(rom.read_bytes()).hexdigest()[:12]
    for index, entry in enumerate(entries):
        entry['index'] = index+1
    (out/'plan.json').write_text(json.dumps(dict(rom_hash=rom_hash, entries=entries), indent=2)+'\n')
    print(f'{len(entries)} chapters; {len(set(e["key"] for e in entries if e["kind"] == "Move"))} moves; '
          f'{len(set(e["key"] for e in entries if e["kind"] == "Special"))} special entries', flush=True)
    if args.plan_only:
        return
    cache = out/'captures'/rom_hash
    cache.mkdir(parents=True, exist_ok=True)
    def cache_path(e):
        return cache/f'{e["key"]}-{e["param"]}-{e["stage_count"]}.npz'
    failures = []
    if not args.encode_only:
        h, fixture = stage(rom, audio=True)
        try:
            for i, entry in enumerate(entries):
                path = cache_path(entry)
                if path.exists():
                    continue
                print(f'CAPTURE {i+1}/{len(entries)} {entry["name"]} {entry["variant"]}', flush=True)
                try:
                    left, audio, a = capture_entry(h, fixture, entry, 0)
                    right, _, b = capture_entry(h, fixture, entry, 1)
                    np.savez_compressed(path, left=left, right=right, audio=audio,
                                        checks=json.dumps([a, b]))
                except Exception as error:
                    failures.append(dict(entry=entry, error=str(error)))
                    print('FAILED', failures[-1], flush=True)
        finally:
            h.pb.stop(save=False)
    (out/'capture-failures.json').write_text(json.dumps(failures, indent=2)+'\n')
    if failures:
        raise SystemExit(f'{len(failures)} captures failed; successful entries are cached')
    if args.capture_only:
        return
    assert all(cache_path(e).exists() for e in entries), 'capture cache is incomplete'
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    silent, wav_path = out/'catalog-silent.mp4', out/'catalog-audio.wav'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '640x360', '-framerate', str(FPS/2),
        '-i', '-', '-an', '-vf', 'scale=1280:720:flags=neighbor', '-c:v', 'libx264',
        '-preset', 'veryfast', '-crf', '18', '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
    title_font = ImageFont.truetype(font_path, 14)
    small_font = ImageFont.truetype(font_path, 10)
    chapters, checks, count_written = [], [], 0
    waveform = wave.open(str(wav_path), 'wb')
    waveform.setnchannels(2); waveform.setsampwidth(2); waveform.setframerate(48000)
    try:
        for i, entry in enumerate(entries):
            print(f'ENCODE {i+1}/{len(entries)} {entry["name"]} {entry["variant"]}', flush=True)
            with np.load(cache_path(entry)) as data:
                left, right, pcm = data['left'], data['right'], data['audio']
                checks.append(dict(entry=entry, checks=json.loads(str(data['checks']))))
            title = entry['name'] + (' - '+entry['variant'] if entry['variant'] else '')
            chapters.append(dict(title=title, key=entry['key'], kind=entry['kind'],
                                 param=entry['param'], seconds=count_written*2/FPS))
            lead, tail = 30, 60
            length = max(len(left), len(right))+lead+tail
            length += length % 2
            base = Image.new('RGB', (640, 360), '#111a28')
            draw = ImageDraw.Draw(base)
            draw.text((10, 5), title, font=title_font, fill='white')
            draw.text((10, 25), 'PLAYER USES THE ANIMATION', font=small_font, fill='#85e5c1')
            draw.text((330, 25), 'OPPONENT USES THE ANIMATION', font=small_font, fill='#85e5c1')
            draw.text((10, 340), f'{i+1:03}/{len(entries)}  |  Alphabetical catalog  |  Game speed + game audio', font=small_font, fill='#b6c4d6')
            for frame in range(0, length, 2):
                canvas = base.copy()
                for x, sequence in ((0, left), (320, right)):
                    at = max(0, min(frame-lead, len(sequence)-1))
                    canvas.paste(Image.fromarray(sequence[at]).resize((320, 288), Image.Resampling.NEAREST), (x, 44))
                encoder.stdin.write(canvas.tobytes())
                count_written += 1
                if i in (0, len(entries)//2, len(entries)-1) and frame == min(lead+40, length-2)//2*2:
                    canvas.resize((1280,720), Image.Resampling.NEAREST).save(out/f'preview-{i+1:03}.png')
            target = round(length/FPS*48000)
            pre = round((lead+1)/FPS*48000)
            pcm = np.pad(pcm, ((pre, 0), (0, 0)))
            pcm = np.pad(pcm[:target], ((0, max(0, target-len(pcm))), (0, 0)))
            waveform.writeframes(pcm.astype('<i2').tobytes())
    finally:
        waveform.close()
        encoder.stdin.close()
        assert encoder.wait() == 0, 'video encoder failed'
    seconds = count_written*2/FPS
    metadata = [';FFMETADATA1', 'title=Crimson Crystal - Complete Alphabetical Battle Animation Catalog']
    for i, chapter in enumerate(chapters):
        end = chapters[i+1]['seconds'] if i+1 < len(chapters) else seconds
        title = chapter['title'].replace('=', '\\=').replace(';', '\\;').replace('#', '\\#')
        metadata += ['[CHAPTER]', 'TIMEBASE=1/1000', f'START={round(chapter["seconds"]*1000)}',
                     f'END={round(end*1000)}', 'title='+title]
    (out/'chapters.ffmetadata').write_text('\n'.join(metadata)+'\n')
    video = out/'crimson-crystal-all-battle-animations-a-z.mp4'
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav_path),
        '-i', str(out/'chapters.ffmetadata'), '-map', '0:v', '-map', '1:a', '-map_metadata', '2',
        '-map_chapters', '2', '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k', '-shortest',
        '-movflags', '+faststart', str(video)], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(video), '-f', 'null', '-'], check=True)
    (out/'chapters.txt').write_text('\n'.join(stamp(c['seconds'])+' '+c['title'] for c in chapters)+'\n')
    with wave.open(str(wav_path), 'rb') as audio:
        audio_duration = audio.getnframes()/audio.getframerate()
        assert abs(audio_duration-seconds) < .03
    assert rom_hash == hashlib.md5(rom.read_bytes()).hexdigest()[:12], 'ROM changed during recording'
    result = dict(rom_hash=rom_hash, video=str(video), seconds=seconds, chapters=chapters, checks=checks,
                  total_moves=len(set(e['key'] for e in entries if e['kind']=='Move')),
                  special_entries=len(set(e['key'] for e in entries if e['kind']=='Special')),
                  validation='Full video/audio decode passed; ROM hash unchanged')
    (out/'results.json').write_text(json.dumps(result, indent=2)+'\n')
    print('VIDEO', video, stamp(seconds), flush=True)


if __name__ == '__main__':
    main()
