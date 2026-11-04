#!/usr/bin/env python3
"""Check palette permutations and native move animations; optionally record.

Uses private emulator state only. The native animation interpreter, HUD clearing,
palette effects and HUD restoration execute from the actual release/debug ROM.
"""
import argparse
import io
import json
from pathlib import Path
import subprocess
import sys
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from record_lance_escort_scenes import Recording, FPS
from gameplay_rules_checks import new_game
from probability_checks import call
from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text, wait

CELLS = [(2, 1, 0x60, 5, 1, 2), (3, 1, 0x61, 5, 2, 2),
         (10, 8, 0x62, 5, 3, 3), (11, 8, 0x63, 4, 1, 3)]
SHOWCASE = ['EARTH_POWER', 'SUCKER_PUNCH', 'DARK_PULSE', 'NIGHT_SHADE',
            'FLASH', 'THUNDERBOLT', 'PSYCHIC_M', 'DAZZLING_GLEAM',
            'MOONBLAST', 'COSMIC_POWER']


class TestRecording(Recording):
    def __init__(self, pb, path):
        self.pb, self.path, self.frames = pb, path, 0
        self.ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        self.silent, self.wav = path.with_suffix('.silent.mp4'), path.with_suffix('.wav')
        self.encoder = subprocess.Popen([self.ffmpeg, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '960x752',
            '-framerate', str(FPS / 2), '-i', '-', '-an', '-c:v', 'libx264',
            '-threads', '2', '-preset', 'veryfast', '-crf', '18', '-pix_fmt', 'yuv420p',
            str(self.silent)], stdin=subprocess.PIPE)
        self.audio = wave.open(str(self.wav), 'wb')
        self.audio.setnchannels(2)
        self.audio.setsampwidth(2)
        self.audio.setframerate(pb.sound.sample_rate)
        self.font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 27)
        self.small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 20)
        self.label = ''

    def append(self):
        if self.frames % 2 == 0:
            canvas = Image.new('RGB', (960, 752), '#101827')
            draw = ImageDraw.Draw(canvas)
            draw.text((28, 18), self.label, font=self.font, fill='white')
            draw.text((28, 59), 'Test types: Mewtwo Psychic/Dark | Seviper Poison/Dark | game audio',
                      font=self.small, fill='#b8c3d5')
            canvas.paste(self.pb.screen.image.convert('RGB').resize(
                (640, 576), Image.Resampling.NEAREST), (160, 96))
            draw.text((28, 691), 'Icons follow their HP display. Hidden HUDs leave no colored boxes.',
                      font=self.small, fill='#7de1ba')
            draw.text((28, 722), 'Dark uses purple on black; its ordinary color returns afterward.',
                      font=self.small, fill='#b8c3d5')
            self.encoder.stdin.write(canvas.tobytes())
        self.audio.writeframesraw((self.pb.sound.ndarray.astype(np.int16) * 256).tobytes())
        self.frames += 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--all-moves', action='store_true')
    parser.add_argument('--moves', nargs='+', help='Run named animation scripts instead of the default showcase')
    parser.add_argument('--record', action='store_true')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/type-icon-animation-fix')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=args.record,
                emulator_kwargs={'sound_sample_rate': 48000} if args.record else {})
    pb, m = h.pb, h.battle.mem
    types = _parse_constants(ROOT / 'constants/type_constants.asm')
    checks, frames, current = 0, 0, 'setup'
    seen = set()
    video = None
    recording = None
    chapters, results, hook_errors = [], [], []
    observed = False
    patterns = set()
    captured = set()
    colors = {}
    masks = {}
    hidden = set()

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            pb.screen.image.save(args.output / 'failure.png')
            raise AssertionError(current + ': ' + message)

    def palette(slot):
        data = m.read_bytes('wBGPals2', 8, slot * 8)
        return [int.from_bytes(data[i:i+2], 'little') for i in range(0, 8, 2)]

    def inspect(_=None):
        if not observed or hook_errors:
            return
        try:
            palettes = {p: palette(p) for p in (2, 3, 4, 5)}
            patterns.add(m.read('wBGP'))
            # Both HP backgrounds are affected together by current move scripts.
            check(palettes[5][0] == palettes[2][0] == palettes[3][0],
                  'shared icon background matches both HP displays')
            check(palettes[4][0] == palettes[3][0], 'second player icon has the HP background')
            for slot, (x, y, tile, pal, ink, hp) in enumerate(CELLS):
                bg = palettes[hp][0]
                show = any(v != bg for v in palettes[hp][1:])
                expected = colors[slot] if show else bg
                if show and assigned[slot] == types['DARK'] and bg == 0:
                    expected = 18 | 10 << 5 | 25 << 10
                    seen.add('purple-dark')
                check(palettes[pal][ink] == expected,
                      f'slot {slot}: canonical visible color or matching hidden color')
                if bg == 0: seen.add('black-background')
                if not show: seen.add('flat-hud')
                tile_in_ram = m.read('wTileMap', y*20+x)
                tile_in_vram = pb.memory[0, 0x9800+y*32+x]
                attr = pb.memory[1, 0x9800+y*32+x]
                if tile_in_ram == tile and tile_in_vram == tile:
                    check(attr == pal | 8, f'slot {slot}: visible symbol uses its own bank and palette')
                    check(bytes(pb.memory[1, 0x9600+slot*16:0x9610+slot*16]) == masks[slot],
                          f'slot {slot}: symbol art survives the animation')
                    seen.add('visible-hud')
                elif tile_in_ram == 0x7f and tile_in_vram == 0x7f:
                    check(attr == hp, f'slot {slot}: hidden HUD uses a bank-0 blank in its HP palette')
                    hx, hy = (2, 2) if slot < 2 else (10, 9)
                    if m.read('wTileMap', hy*20+hx) == 0x7f:
                        check(pb.memory[0, 0x9800+hy*32+hx] == 0x7f,
                              f'slot {slot}: HP display clears together with its icons')
                    hidden.add(slot // 2)
        except AssertionError as error:
            hook_errors.append(str(error))

    def native(symbol, limit=1800, monitor=False):
        nonlocal frames, observed
        observed = monitor
        begin_native_call(h, symbol)
        pb.memory[0xc0f0] = 0xf3
        for _ in range(limit):
            h.tick(1)
            frames += 1
            if recording: recording.append()
            if hook_errors: raise AssertionError(hook_errors[0])
            if monitor and current not in captured and palette(2)[0] == 0 and \
                    max(pb.screen.ndarray[50, 159, :3]) == 0:
                pb.screen.image.save(args.output / (current.replace(' / ', '-').lower() + '-black.png'))
                captured.add(current)
            if pb.register_file.PC in (0xc0f1, 0xc0f3): break
        else:
            raise AssertionError(current + ': native routine did not return: ' + symbol)
        observed = False
        pb.memory[0xc0f0:0xc0f3] = [0xfb, 0x18, 0xfe]
        pb.register_file.PC = 0xc0f0
        for _ in range(8):
            h.tick(1)
            if recording: recording.append()

    def hold(count):
        for _ in range(count):
            h.tick(1)
            if recording: recording.append()

    try:
        new_game(h, 0)
        m.write('wOptions', 0x41)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MEWTWO'))
        m.write('wCurPartySpecies', sid)
        m.write('wCurPartyLevel', 50)
        call(h, 'TryAddMonToParty')
        move = call(h, 'GetMoveIDFromIndex', HL=h.con.moves['SPLASH'])
        m.write_bytes('wPartyMon1Moves', [move, 0, 0, 0])
        m.write_bytes('wPartyMon1PP', [40, 0, 0, 0])
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('SEVIPER'))
        for name, value in dict(wTempWildMonSpecies=sid, wCurPartyLevel=50,
                                wOtherTrainerClass=0, wBattleType=0, wBattleMode=0,
                                hCurWeather=0).items():
            m.write(name, value)
        begin_native_call(h, 'StartBattle')
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        # Four distinct colors, including Dark on either side. Species graphics
        # stay the same as the user's forest screenshots for easy comparison.
        assigned = [types[t] for t in ('POISON', 'DARK', 'PSYCHIC', 'DARK')]
        for symbol, typ in zip(('wEnemyMonType1', 'wEnemyMonType2',
                                'wBattleMonType1', 'wBattleMonType2'), assigned):
            m.write(symbol, typ)
        native('RefreshBattleTypeIcons')
        bank, addr = h.sym['BattleHUDTypeColors']
        for slot, typ in enumerate(assigned):
            colors[slot] = int.from_bytes(bytes(pb.memory[bank, addr+typ*2:addr+typ*2+2]), 'little')
            masks[slot] = bytes(pb.memory[1, 0x9600+slot*16:0x9610+slot*16])
        baseline = io.BytesIO()
        pb.save_state(baseline)
        # Sample only completed palette updates, rather than an interrupt that
        # could split the animation's palette remap and our repair across ticks.
        pb.hook_register(*h.sym['BattleAnimRequestPals.typeicons_ready'], inspect, None)

        # Every possible DMG BG mapping, including flat black and white fades.
        for mapping in range(256):
            current = f'palette permutation {mapping:02x}'
            baseline.seek(0)
            pb.load_state(baseline)
            begin_native_call(h, 'DmgToCgbBGPals')
            pb.register_file.A = mapping
            for _ in range(40):
                h.tick(1)
                if pb.register_file.PC in (0xc0f1, 0xc0f3): break
            base = bytes(m.read_bytes('wBGPals1', 64))
            mapped = bytes(m.read_bytes('wBGPals2', 64))
            native('UpdateBattleTypeIconAnimPals')
            check(bytes(m.read_bytes('wBGPals1', 64)) == base,
                  'animation repair leaves all base palettes unchanged')
            repaired = bytes(m.read_bytes('wBGPals2', 64))
            allowed = set(range(5*8, 6*8)) | set(range(4*8, 4*8+4))
            check(all(before == after for i, (before, after) in enumerate(zip(mapped, repaired))
                      if i not in allowed), 'HP, Pokemon, EXP ink and text colors stay unchanged')
            observed = True
            inspect()
            observed = False
            if hook_errors: raise AssertionError(hook_errors[0])

        moves = args.moves or ([h.con.moves_by_index[i] for i in range(1, h.con.num_attacks + 1)]
                               if args.all_moves else SHOWCASE)
        for move in moves:
            for side in (0, 1):
                current = f'{move} / {"player" if side == 0 else "opponent"}'
                baseline.seek(0)
                pb.load_state(baseline)
                m.write('hBattleTurn', side)
                ident = h.con.moves[move]
                m.write_bytes('wFXAnimID', [ident & 255, ident >> 8])
                m.write('wBattleAnimParam', 1 if move in ('SELFDESTRUCT', 'EXPLOSION') else 0)
                m.write('wNumHits', 0)
                if args.record:
                    if recording is None:
                        recording = TestRecording(pb, args.output / 'type-icon-animation-tests.mp4')
                    recording.label = move.replace('_', ' ').replace('PSYCHIC M', 'PSYCHIC') + \
                        ('  |  PLAYER attacks' if side == 0 else '  |  OPPONENT attacks')
                    chapters.append(dict(move=move, side=side, seconds=recording.frames / FPS))
                    hold(45)
                before = frames
                native('PlayBattleAnim', monitor=True)
                observed = True
                inspect()
                observed = False
                if hook_errors: raise AssertionError(hook_errors[0])
                for slot, (_, _, _, pal, ink, _) in enumerate(CELLS):
                    check(palette(pal)[ink] == colors[slot],
                          f'slot {slot}: ordinary color restored after animation')
                result = dict(move=move, side=side, frames=frames-before)
                results.append(result)
                if recording:
                    hold(60)
                if move in SHOWCASE:
                    pb.screen.image.save(args.output / f'{move.lower()}-{side}-return.png')
                print('PASS', current, result['frames'], 'native frames', flush=True)
        check({'purple-dark', 'black-background', 'flat-hud', 'visible-hud'} <= seen,
              'black, white, hidden, visible and purple Dark coverage executed')
        check(hidden == {0, 1}, 'both attacker HUDs were hidden without bank-1 spaces')
        if recording:
            video = recording.finish()
            recording = None
        (args.output / 'failure.png').unlink(missing_ok=True)
        (args.output / 'checks.json').write_text(json.dumps(dict(rom=args.rom.name, rom_hash=h.rom_key(),
            checks=checks, frames=frames, permutations=256, animations=results,
            bg_mappings=sorted(patterns), coverage=sorted(seen), video=video, chapters=chapters), indent=2))
        print(f'TYPE ICON ANIMATIONS: {checks} checks, {len(results)} native animations, 256 mappings', flush=True)
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        pb.stop(save=False)


if __name__ == '__main__': main()
