#!/usr/bin/env python3
"""Sound-enabled release-ROM cry/music/SFX and cartridge-clock checks.

Uses the isolated MBC30 adapter. Cries run through PlayCry and WaitSFX with
interrupts and sound emulation enabled. Waveform/termination checks cannot
replace a person's listening review. RTC changes go to cartridge registers;
the game derives calendar fields with its actual UpdateTime code.
"""

import argparse
import io
import json
from pathlib import Path
import sys
import wave

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / '.tmpbuild/pyboy-mbc30'))
from pyboy.core.cartridge.mbc3 import advance_clock
from pyboy.core.cartridge.rtc import probe_register_writes
from pyboy import PyBoy
import numpy as np
from runner import Harness
from state import Battle
from gameplay_rules_checks import new_game
from probability_checks import call
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text

OUTPUT = ROOT / '.tmpbuild/release-audio-rtc'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--skip-cries', action='store_true', help='focus on music/SFX/RTC without the cry sweep')
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness(cartridge='mbc30', rom_path=ROOT / 'pokecrystal.gbc', sound_emulated=True)
    m, pb = h.battle.mem, h.pb
    checks, failures, recordings, cry_count = 0, [], [], 0

    def check(ok, name):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(name)
            print('FAIL ' + name, flush=True)

    def invoke(symbol, **registers):
        begin_native_call(h, symbol)
        for name, value in registers.items():
            setattr(pb.register_file, name, value)

    def record_until_return(limit=1200):
        samples = []
        for frame in range(limit):
            pb.tick(1, False, True)
            samples.append(pb.sound.ndarray.copy())
            if pb.register_file.PC in (0xc0f1, 0xc0f3):
                return np.concatenate(samples), frame + 1, True
        return np.concatenate(samples), limit, False

    def wav(name, samples):
        path = OUTPUT / (name + '.wav')
        with wave.open(str(path), 'wb') as stream:
            stream.setnchannels(2)
            stream.setsampwidth(2)
            stream.setframerate(pb.sound.sample_rate)
            stream.writeframes((samples.astype('<i2') * 128).tobytes())
        return str(path.relative_to(ROOT))

    try:
        for actual, expected in zip(probe_register_writes(), ((7, 34, 12, 139, 0),
                (7, 8, 12, 139, 0), (7, 8, 9, 139, 0), (7, 8, 9, 2, 0),
                (7, 8, 9, 2, 1), (7, 8, 9, 2, 1))):
            check(actual == expected, f'emulator RTC register write/persistence {actual} == {expected}')
        new_game(h, 0)
        fixture = io.BytesIO()
        pb.save_state(fixture)
        recent = {'EXEGGUTOR', 'EXEGGUTOR_ALOLAN', 'ESPEON', 'LEAFEON', 'GLACEON', 'SYLVEON', 'PORYGON_Z'}
        for index in (() if args.skip_cries else range(1, h.con.num_pokemon + 1)):
            name = h.con.species_by_index.get(index, str(index))
            if name.startswith('UNUSED') or name.startswith('QUESTION') or name == 'EGG':
                continue
            cry_count += 1
            fixture.seek(0)
            pb.load_state(fixture)
            invoke('PlayMusic', D=0, E=0)
            record_until_return()
            # Initialization takes one native frame, then WaitSFX waits for
            # the real cry channels to finish. Include both in the recording.
            invoke('PlayCry', D=(index - 1) >> 8, E=(index - 1) & 255)
            first, _, returned = record_until_return()
            invoke('WaitSFX')
            rest, frames, done = record_until_return()
            samples = np.concatenate((first, rest))
            check(returned and done, name + ': cry and WaitSFX terminate')
            check(np.any(samples != 0), name + ': non-silent sound samples')
            check(not any(m.read(f'wChannel{channel}Flags1') & 1 for channel in range(5, 9)),
                  name + ': all cry channels released')
            if name in recent:
                path = wav(name.lower(), samples)
                recordings.append(dict(species=name, frames=frames, file=path,
                                       peak=int(np.max(np.abs(samples.astype('int16'))))))
            if index % 50 == 0:
                print('CHECK release cries through species ' + str(index), flush=True)

        # Music after a cry and item/save/warp effects must still emit audio.
        music = _parse_constants(ROOT / 'constants/music_constants.asm')['MUSIC_NEW_BARK_TOWN']
        effects = _parse_constants(ROOT / 'constants/sfx_constants.asm')
        fixture.seek(0)
        pb.load_state(fixture)
        invoke('PlayMusic', D=music >> 8, E=music & 255)
        first, _, done = record_until_return()
        samples = []
        for _ in range(120):
            pb.tick(1, False, True)
            samples.append(pb.sound.ndarray.copy())
        music_audio = np.concatenate(samples)
        check(done and np.any(music_audio), 'release map music emits audio')
        wav('new-bark-music', music_audio)
        for name in ('SFX_SAVE', 'SFX_ITEM', 'SFX_EXIT_BUILDING'):
            effect = effects[name]
            invoke('PlaySFX', D=effect >> 8, E=effect & 255)
            first, _, started = record_until_return()
            invoke('WaitSFX')
            rest, _, done = record_until_return()
            samples = np.concatenate((first, rest))
            check(started and done and np.any(samples), name + ': native sound effect emits audio and returns')

        fixture.seek(0)
        pb.load_state(fixture)
        for raw_day in (5, 12, 19, 138, 139):
            m.write_bytes('wStringBuffer2', [raw_day, 23, 59, 58])
            call(h, '_InitTime')
            call(h, 'UpdateTime')
            check(m.read('wCurDay') == raw_day and m.read('hHours') == 23,
                  f'RTC initial day {raw_day} derived by release UpdateTime')
            advance_clock(4)
            call(h, 'UpdateTime')
            next_day = raw_day + 1
            check(m.read('wCurDay') == next_day and m.read('hHours') == 0
                  and m.read('hMinutes') == 0, f'RTC midnight rolls day {raw_day} forward')
            call(h, 'GetWeekday')
            check(pb.register_file.A == next_day % 7, f'RTC weekday follows rolled day {next_day}')
        # The hardware day counter wraps by 140 independently of the New
        # Game weekday offset. A complete 20-week cycle retains Friday.
        m.write_bytes('wStringBuffer2', [5, 12, 0, 0])
        call(h, '_InitTime')
        advance_clock(139 * 86400)
        call(h, 'UpdateTime')
        check(m.read('hRTCDayLo') == 139 and m.read('wCurDay') == 144,
              'RTC hardware day 139 retains the New Game weekday offset')
        advance_clock(86400)
        call(h, 'UpdateTime')
        call(h, 'GetWeekday')
        check(m.read('hRTCDayLo') == 0 and m.read('wCurDay') == 5 and pb.register_file.A == 5,
              'RTC hardware 140-day rollover retains Friday')
        # Seven days off and a save/reload retain the actual hardware clock.
        m.write_bytes('wStringBuffer2', [12, 12, 0, 0])
        call(h, '_InitTime')
        call(h, 'UpdateTime')
        advance_clock(7 * 86400)
        call(h, 'UpdateTime')
        check(m.read('wCurDay') == 19 and m.read('hHours') == 12 and m.read('hMinutes') == 0,
              'RTC seven-day advancement retains noon')
        call(h, 'GetWeekday')
        check(pb.register_file.A == 5, 'RTC later Friday')
        call(h, 'AskOverwriteSaveFile')
        call(h, 'SaveGameData')
        print('RTC BEFORE SAVE ' + json.dumps(dict(day=m.read('wCurDay'), hour=m.read('hHours'),
              raw_day=m.read('hRTCDayLo'), start=m.read('wStartDay'), rtc=list(m.read_bytes('wRTC', 4)))), flush=True)
        private_rom = Path(h._rom_tempdir.name) / 'pokecrystal.gbc'
        pb.stop(save=True)
        check(private_rom.with_name(private_rom.name + '.rtc').exists(), 'private release RTC sidecar persisted')
        h.pb = pb = PyBoy(str(private_rom), window='null', cgb=True, sound_emulated=True)
        pb.set_emulation_speed(0)
        pb.hook_register(0, 0x100, lambda _: None, None)
        h.battle = Battle(pb, h.sym, h.con)
        m = h.battle.mem
        h.battle.textbox_contexts = set()
        pb.tick(400)
        for _ in range(700):
            if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (24, 7, 2):
                h.tick(120)
                break
            h.press('start', hold=4, wait=16)
            h.press('a', hold=4, wait=20)
        else:
            raise RuntimeError('Release RTC Continue failed: ' + tile_text(h))
        call(h, 'UpdateTime')
        print('RTC AFTER CONTINUE ' + json.dumps(dict(day=m.read('wCurDay'), hour=m.read('hHours'),
              raw_day=m.read('hRTCDayLo'), start=m.read('wStartDay'), rtc=list(m.read_bytes('wRTC', 4)))), flush=True)
        check(m.read('wCurDay') == 19 and m.read('hHours') == 12 and m.read('hMinutes') == 0,
              'fresh release boot/Continue retains RTC calendar')
        call(h, 'GetWeekday')
        check(pb.register_file.A == 5, 'fresh release RTC remains Friday')
        report = dict(checks=checks, failures=failures, cry_species=cry_count, recordings=recordings,
                      scope='release ROM; signal and termination, not subjective listening or physical hardware')
        (OUTPUT / 'results.json').write_text(json.dumps(report, indent=2))
        print(json.dumps(report), flush=True)
        return int(bool(failures))
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())
