#!/usr/bin/env python3
"""Verify native Illusion graphics and record switches/reveals with game audio.

All battles use private emulator fixtures, legal Illusion Totodile, native
damage, stat changes, graphics and switch routines. No player save is opened.
"""
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
from state import encode_action
from symbols import STATE_WAIT, _parse_constants

OUT = ROOT / '_artifacts/illusion'


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    h.bootstrap()  # sound-enabled boot; silent cached APU states are unsuitable
    menu = io.BytesIO()
    h.pb.save_state(menu)
    m = h.battle.mem
    checks, samples, chapters = [], [], []
    total = 0
    encoder = None
    title = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 26)
    small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 19)
    side, phase = 0, ''
    entry_flags = None
    warp = None
    warp_checks = []
    hook_errors = []
    spite = _parse_constants(ROOT / 'constants/sfx_constants.asm')['SFX_SPITE']

    def begin_warp(_):
        nonlocal warp
        which = m.read('hBattleTurn')
        warp = {'side': which, 'before': appearance(which), 'samples': set(),
                'before_samples': 0, 'after_samples': 0, 'sounds': 0,
                'swapped': False, 'captured_before': False, 'captured_after': False}

    def sound_started(_):
        if warp is not None:
            regs = h.pb.register_file
            if regs.D * 256 + regs.E == spite:
                warp['sounds'] += 1

    def sample_warp(_):
        if warp is None:
            return
        which = warp['side']
        slot = m.read('wPlayerIllusionSlot' if which == 0 else 'wEnemyIllusionSlot')
        wave = m.read_bytes('wLYOverridesBackup', 128)
        warp['samples'].add(wave)
        if slot:
            warp['before_samples'] += 1
            assert appearance(which) == warp['before'], 'disguise changed before the swap cue'
            if warp['before_samples'] == 20:
                h.pb.screen.image.save(OUT / f'warp-before-{which}.png')
                warp['captured_before'] = True
        else:
            warp['after_samples'] += 1
            assert appearance(which)[1] == normal[which, 'TOTODILE'][1], 'wrong palette after the clean swap'
            if warp['after_samples'] == 12:
                h.pb.screen.image.save(OUT / f'warp-after-{which}.png')
                warp['captured_after'] = True

    def swap_cue(_):
        if warp is None or warp['swapped']:
            return
        which = warp['side']
        assert m.read('wPlayerIllusionSlot' if which == 0 else 'wEnemyIllusionSlot') > 0
        assert warp['before_samples'] >= 30, 'sprite swapped before its wobble'
        assert warp['sounds'] >= 1, 'Dark Pulse sound missing during wobble'
        warp['swapped'] = True

    def finish_warp(_):
        nonlocal warp
        if warp is None:
            return
        assert warp['swapped'] and warp['after_samples'] >= 25, 'wave did not settle around the real sprite'
        assert len(warp['samples']) > 10, 'wave scanlines did not animate'
        assert m.read('hLCDCPointer') == 0, 'LCD distortion leaked after the animation'
        warp_checks.append({'side': warp['side'], 'copied_sprite_wave_samples': warp['before_samples'],
                            'real_sprite_wave_samples': warp['after_samples'],
                            'distinct_wave_patterns': len(warp['samples']), 'dark_pulse_sounds': warp['sounds']})
        warp = None

    def observe(callback):
        def guarded(context):
            if hook_errors:
                return
            try:
                callback(context)
            except AssertionError as error:
                hook_errors.append(str(error))
        return guarded

    h.pb.hook_register(*h.sym['PlayIllusionBreakAnimation'], observe(begin_warp), None)
    h.pb.hook_register(*h.sym['PlayStereoSFX'], observe(sound_started), None)
    h.pb.hook_register(*h.sym['BattleBGEffect_28.one'], observe(sample_warp), None)
    h.pb.hook_register(*h.sym['BattleBGEffect_28.two'], observe(sample_warp), None)
    h.pb.hook_register(*h.sym['IllusionRevealDuringWarp.swap'], observe(swap_cue), None)
    h.pb.hook_register(*h.sym['RevealUserIllusion.animation_done'], observe(finish_warp), None)

    def set_entry_flags(which):
        if entry_flags is None:
            return
        prefix = 'wPartyMon' if which == 0 else 'wOTPartyMon'
        for slot, flags in enumerate(entry_flags[which], 1):
            m.write(prefix + str(slot) + 'Unused', flags)
        if which == 1:
            m.write('wEnemyMonShinyGenderFlags', entry_flags[1][0])
            # NPC lead DVs are normally selected by trainer class; the debug
            # request replaces them after entry. Install the requested DVs
            # before graphics as well, so Unown controls use the same letter.
            m.write_bytes('wEnemyMonDVs', m.read_bytes('wOTPartyMon1DVs', 2))

    h.pb.hook_register(*h.sym['InitPlayerIllusion'], lambda _: set_entry_flags(0), None)
    h.pb.hook_register(*h.sym['InitEnemyIllusion'], lambda _: set_entry_flags(1), None)

    def stage(test):
        menu.seek(0)
        h.pb.load_state(menu)
        h.text_overflows.clear()
        m.write('wOptions', 0x41)
        assert h.run_battle(dict(test, rng='forced_high', turns=0)) == STATE_WAIT
        assert not hook_errors, hook_errors

    def appearance(which):
        start, count = (0x9310, 36 * 16) if which == 0 else (0x9000, 49 * 16)
        palette_offset = 0 if which == 0 else 8
        return (bytes(h.pb.memory[0, start:start + count]),
                m.read_bytes('wBGPals1', 8, palette_offset))

    def hud(which):
        gender, star = (8 * 20 + 17, 8 * 20 + 12) if which == 0 else (20 + 9, 20 + 4)
        return m.read('wTileMap', gender), m.read('wTileMap', star)

    def frame():
        nonlocal total
        h.pb.tick(1, True, True)
        assert not hook_errors, hook_errors
        if warp is not None:
            palette = appearance(warp['side'])[1]
            assert palette in (warp['before'][1], normal[warp['side'], 'TOTODILE'][1]), 'palette flash during reveal'
        canvas = Image.new('RGB', (960, 720), '#101827')
        draw = ImageDraw.Draw(canvas)
        draw.text((480, 15), 'ILLUSION  |  WARP REVEAL', font=title, anchor='mt', fill='white')
        draw.text((480, 51), phase, font=small, anchor='mt', fill='#7de1ba')
        canvas.paste(h.pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (160, 86))
        holder = h.battle.player if side == 0 else h.battle.enemy
        slot = m.read('wPlayerIllusionSlot' if side == 0 else 'wEnemyIllusionSlot')
        draw.text((480, 681), f"{'Player' if side == 0 else 'Opponent'}  |  Disguise: {'active' if slot else 'off'}"
                  f"  |  Speed stage: {holder.stat_levels[2] - 7:+d}",
                  font=small, anchor='mt', fill='white')
        encoder.stdin.write(canvas.tobytes())
        sound = h.pb.sound
        raw = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                            count=sound.raw_buffer_head).reshape(-1, 2)
        samples.append(raw.astype(np.int16) * 256)
        total += 1

    def hold(label, filename=None):
        nonlocal phase
        phase = label
        print(label, flush=True)
        for _ in range(75):
            frame()
        if filename:
            h.pb.screen.image.save(OUT / (filename + '.png'))

    def advance(target, label):
        nonlocal phase
        phase = label
        print(label, flush=True)
        m.write('wDebugTurnTarget', target)
        m.write('wDebugControl', 1)
        for elapsed in range(12000):
            if elapsed % 8 == 0:
                h.pb.button('a', 2)
            frame()
            if h.state() == STATE_WAIT and h.battle.turns_done == target:
                assert not h.text_overflows, h.text_overflows
                return
        raise AssertionError(('recording timeout', h.control_state()))

    # Obtain normal sprites/palettes from native battles for exact comparison.
    normal = {}
    for which in (0, 1):
        for species in ('GENGAR', 'TOTODILE'):
            print('Normal appearance control', which, species, flush=True)
            mon = {'species': species, 'level': 100, 'moves': ['SPLASH']}
            if species == 'TOTODILE':
                mon['ability'] = 'TORRENT'
            other = {'species': 'MEW', 'level': 10, 'moves': ['SPLASH']}
            stage({'player': mon if which == 0 else other,
                   'enemy': other if which == 0 else mon,
                   **({'enemy2': other} if which == 1 else {})})
            normal[which, species] = appearance(which)

    # Independently verify shiny palettes, HUD gender/star, high species IDs,
    # and Unown's form graphics. These are private pre-entry party fixtures;
    # every graphic and reveal still runs through the native battle engine.
    for which in (0, 1):
        for species in ('MAGNEMITE', 'NIDORAN_F', 'TAUROS', 'MIENSHAO', 'UNOWN'):
            print('Shiny/gender/form appearance check', which, species, flush=True)
            entry_flags = ((0x80, 0x80), (0x80, 0x80))
            mon = {'species': species, 'level': 100, 'moves': ['SPLASH']}
            other = {'species': 'MEW', 'level': 10, 'moves': ['TACKLE']}
            stage({'player': mon if which == 0 else other,
                   'enemy': other if which == 0 else mon,
                   **({'enemy2': other} if which == 1 else {})})
            expected, expected_hud = appearance(which), hud(which)
            h.pb.screen.image.save(OUT / f'control-{which}-{species.lower()}.png')
            entry_flags = ((0x40, 0x80), (0x40, 0x80))
            holder = {'species': 'TOTODILE', 'level': 100, 'ability': 'ILLUSION', 'moves': ['SPLASH']}
            partner = {'species': species, 'level': 100, 'moves': ['SPLASH']}
            stage({'player': holder if which == 0 else other,
                   'enemy': other if which == 0 else holder,
                   ('player2' if which == 0 else 'enemy2'): partner})
            h.pb.screen.image.save(OUT / f'disguise-{which}-{species.lower()}.png')
            assert appearance(which) == expected, ('copied shiny/form graphics', which, species)
            assert hud(which) == expected_hud, ('copied gender/shiny HUD', which, species, hud(which), expected_hud)
            m.write('wDebugTurnTarget', 1)
            m.write('wDebugControl', 1)
            for elapsed in range(10000):
                h.pb.button('a', 2)
                h.tick(4)
                assert not hook_errors, hook_errors
                if h.state() == STATE_WAIT and h.battle.turns_done == 1:
                    break
            else:
                raise AssertionError(('appearance reveal timeout', which, species))
            assert appearance(which) == normal[which, 'TOTODILE'], ('restore real graphics', which, species)
            assert not h.text_overflows, h.text_overflows
            h.pb.screen.image.save(OUT / f'appearance-{which}-{species.lower()}.png')
    entry_flags = None
    checks.append('Both sides: shiny palettes/HUD star, genderless/female-only/male-only/mixed gender, species 500 and Unown graphics')

    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    silent = OUT / 'silent-warp.mp4'
    encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '960x720', '-framerate', str(FPS),
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
        '-pix_fmt', 'yuv420p', str(silent)], stdin=subprocess.PIPE)
    try:
        stage({'player': {'species': 'TOTODILE', 'level': 100, 'ability': 'ILLUSION', 'moves': ['SPLASH']},
               'player2': {'species': 'GENGAR', 'level': 100, 'moves': ['SPLASH']},
               'enemy': {'species': 'MEW', 'level': 10, 'moves': ['TACKLE', 'SPLASH']},
               'move_script': [1, 1, 'switch:2', 'switch:1', 1]})
        assert m.read('wPlayerIllusionSlot') == 2
        assert appearance(0) == normal[0, 'GENGAR'], 'initial backpic/palette is not Gengar'
        chapters.append({'label': 'Player: reveal, second hit, switch and restore', 'seconds': total / FPS})
        hold('Totodile enters disguised as the last party member: Gengar', 'player-disguised')
        advance(1, 'Dark Pulse sound + wobble, then a clean reveal and Speed +1')
        assert m.read('wPlayerIllusionSlot') == 0 and h.battle.player.stat_levels[2] == 8
        assert appearance(0) == normal[0, 'TOTODILE'], 'revealed backpic/palette is not Totodile'
        hold('Original Totodile sprite restored  |  Speed +1', 'player-revealed')
        advance(2, 'A second hit: no additional Speed boost')
        assert h.battle.player.stat_levels[2] == 8
        hold('Speed remains +1 after the second hit', 'second-hit')
        advance(3, 'Switch out to the real Gengar')
        assert h.battle.player.species == 'GENGAR'
        tackle = m.read('wEnemyMonMoves')
        m.write('wEnemyMonMoves', m.read('wEnemyMonMoves', 1))
        advance(4, 'Switch Totodile back in: Illusion is restored')
        assert h.battle.player.species == 'TOTODILE'
        assert m.read('wPlayerIllusionSlot') == 2 and h.battle.player.stat_levels[2] == 7
        assert appearance(0) == normal[0, 'GENGAR']
        hold('Disguise restored on re-entry  |  Speed reset on switching', 'player-restored')
        m.write('wEnemyMonMoves', tackle)
        advance(5, 'The restored Illusion breaks: a fresh, single Speed boost')
        assert m.read('wPlayerIllusionSlot') == 0 and h.battle.player.stat_levels[2] == 8
        assert appearance(0) == normal[0, 'TOTODILE']
        hold('Totodile revealed again  |  Speed +1', 'player-revealed-again')
        checks.append('Player exact backpic/palette disguise, reveal, no repeat boost, native switch reset and second reveal')

        side = 1
        stage({'player': {'species': 'MEW', 'level': 10, 'moves': ['TACKLE']},
               'enemy': {'species': 'TOTODILE', 'level': 100, 'ability': 'ILLUSION', 'moves': ['SPLASH']},
               'enemy2': {'species': 'GENGAR', 'level': 100, 'moves': ['SPLASH']}})
        assert m.read('wEnemyIllusionSlot') == 2
        assert appearance(1) == normal[1, 'GENGAR'], 'initial frontpic/palette is not Gengar'
        chapters.append({'label': 'Opponent: front sprite reveal', 'seconds': total / FPS})
        hold('Opponent Totodile also uses the copied front sprite', 'enemy-disguised')
        advance(1, 'Opponent takes a direct hit: front sprite returns to Totodile')
        assert m.read('wEnemyIllusionSlot') == 0 and h.battle.enemy.stat_levels[2] == 8
        assert appearance(1) == normal[1, 'TOTODILE'], 'revealed frontpic/palette is not Totodile'
        hold('Original front sprite and palette restored  |  Speed +1', 'enemy-revealed')
        checks.append('Enemy exact frontpic/palette disguise and reveal with one Speed stage')
    finally:
        h.pb.stop(save=False)
        encoder.stdin.close()
        assert encoder.wait() == 0

    audio = np.concatenate(samples)
    assert np.abs(audio.astype(np.int32)).max() > 0, 'silent recording'
    target_samples = round(total / FPS * 48000)
    audio = np.pad(audio[:target_samples], ((0, max(0, target_samples - len(audio))), (0, 0)))
    wav_path = OUT / 'game-audio-warp.wav'
    with wave.open(str(wav_path), 'wb') as wav:
        wav.setnchannels(2)
        wav.setsampwidth(2)
        wav.setframerate(48000)
        wav.writeframes(audio.astype('<i2').tobytes())
    video = OUT / 'illusion-warp-showcase.mp4'
    subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(silent), '-i', str(wav_path),
                    '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k', '-shortest',
                    '-movflags', '+faststart', str(video)], check=True)
    subprocess.run([ffmpeg, '-v', 'error', '-i', str(video), '-f', 'null', '-'], check=True)
    (OUT / 'recording-warp.json').write_text(json.dumps({'seconds': total / FPS, 'chapters': chapters,
        'checks': checks, 'warp_checks': warp_checks,
        'rom_sha256': hashlib.sha256((ROOT / 'pokecrystal_debug.gbc').read_bytes()).hexdigest()}, indent=2) + '\n')
    print('PASS exact native sprites/palettes, switch restoration, one boost per break, audio and full MP4 decode', flush=True)
    print(video, flush=True)


if __name__ == '__main__':
    main()
