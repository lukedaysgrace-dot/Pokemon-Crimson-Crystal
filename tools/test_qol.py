#!/usr/bin/env python3
"""Compiled-ROM regressions for the health alarm and short breeding waits.

Uses private emulator memory; never loads or writes a player's save.
Run against either release or debug ROM with its matching symbol file.
"""
from contextlib import contextmanager
from pathlib import Path
import sys

from pc_harness import Harness
from battletest.symbols import Constants

ROOT = Path(__file__).resolve().parents[1]


@contextmanager
def stub(h, names):
    """Silence unrelated map services while exercising native CountStep."""
    original = {}
    try:
        for name in names:
            bank, address = h.sym[name]
            original[name] = bytes(h.mem[bank, address:address + 2])
            h.mem[bank, address] = 0xAF  # xor a (clear carry)
            h.mem[bank, address + 1] = 0xC9  # ret
        yield
    finally:
        for name, data in original.items():
            bank, address = h.sym[name]
            for offset, value in enumerate(data):
                h.mem[bank, address + offset] = value


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        assert condition, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    try:
        print('[health alarm: three audible cycles, SFX pauses, rearming]', flush=True)
        for channel in range(5, 9):
            write(f'wChannel{channel}Flags1', 0)
        tones = []
        for label in ('PlayDanger.begin', 'PlayDanger.halfway'):
            h.pyboy.hook_register(*h.sym[label], lambda label: tones.append(label), label)
        try:
            for sfx_channel in range(5, 9):
                write('wDangerBeepCount', 0)
                write('wLowHealthAlarm', 0x80)
                write(f'wChannel{sfx_channel}Flags1', 1)
                for _ in range(100):
                    h.call('PlayDanger')
                check(read('wDangerBeepCount') == 0 and read('wLowHealthAlarm') == 0x80,
                      f'SFX channel {sfx_channel} consumed unheard beeps')
                check(not tones, 'alarm overwrote an active sound effect')
                write(f'wChannel{sfx_channel}Flags1', 0)
            for frame in range(1, 92):
                h.call('PlayDanger')
                check(read('wDangerBeepCount') == min(frame // 30, 3), f'beep count at frame {frame}')
            check(tones == ['PlayDanger.begin', 'PlayDanger.halfway'] * 3,
                  f'expected exactly three high/low beep pairs, got {tones}')
            check(read('wLowHealthAlarm') == 0, 'alarm did not release music channel')
            write('wBattleLowHealthAlarm', 0)
            write('wBattleMonHP', [0, 1])
            write('wPlayerHPPal', 2)
            for _ in range(20):
                h.call('CheckDanger')
                h.call('PlayDanger')
            check(len(tones) == 6 and read('wLowHealthAlarm') == 0, 'continued red HP restarted alarm')
            # Healing midway through a beep must reset its phase as well as its budget.
            write('wLowHealthAlarm', 0x80 | 19)
            write('wDangerBeepCount', 1)
            write('wPlayerHPPal', 1)
            h.call('CheckDanger')
            check(read('wLowHealthAlarm') == read('wDangerBeepCount') == 0, 'healing did not fully rearm alarm')
            write('wPlayerHPPal', 2)
            h.call('CheckDanger')
            h.call('PlayDanger')
            check(tones[-1] == 'PlayDanger.begin' and len(tones) == 7, 'new red-HP entry missed first tone')
            write('wBattleMonHP', [0, 0])
            h.call('CheckDanger')
            check(read('wLowHealthAlarm') == read('wDangerBeepCount') == 0, 'fainted mon kept alarm')
            write('wLowHealthAlarm', 0x80)
            write('wDangerBeepCount', 2)
            h.call('StopDangerSound')
            check(read('wLowHealthAlarm') == read('wDangerBeepCount') == 0, 'battle stop retained alarm state')
        finally:
            for label in ('PlayDanger.begin', 'PlayDanger.halfway'):
                h.pyboy.hook_deregister(*h.sym[label])

        print('[Day-Care: fixed 64 steps for every compatible parent class]', flush=True)

        def parents(first, second, same_id=True, both_male=False):
            write('wDayCareMan', 1)
            write('wDayCareLady', 1)
            for slot, species in enumerate((first, second), 1):
                write(f'wBreedMon{slot}Species', h.species_id(con.species_index(species)))
                write(f'wBreedMon{slot}PokerusStatus', 0x40 if slot == 2 or both_male else 0)
                write(f'wBreedMon{slot}DVs', [0xFF, 0xFF])
                write(f'wBreedMon{slot}ID', [0x12, 0x34] if slot == 1 or same_id else [0x56, 0x78])
                write(f'wBreedMon{slot}Level', 20)
                write(f'wBreedMon{slot}Moves', [0] * 4)
                write(f'wBreedMon{slot}Personality', 0x20)
                write(f'wBreedMon{slot}Exp', [0, 1, 0])
            write('wPlayerID', [0x12, 0x34])
            h.call('DayCare_InitBreeding')

        for first, second, same_id in [('EEVEE', 'EEVEE', True), ('EEVEE', 'EEVEE', False),
                                       ('EEVEE', 'GROWLITHE', True), ('EEVEE', 'GROWLITHE', False),
                                       ('EEVEE', 'DITTO', True), ('DITTO', 'EEVEE', True)]:
            parents(first, second, same_id)
            check(read('wDayCareMan') & 32 and read('wStepsToEgg') == 64, 'compatible pair not armed for 64 steps')
            for step in range(1, 65):
                h.call('DayCareStep')
                check(bool(read('wDayCareMan') & 64) == (step == 64), f'{first}/{second}: egg timing at step {step}')
            check(not read('wDayCareMan') & 32, 'pending egg restarted production')
            check(h.rd(h.s('wBreedMon1Exp'), 3) == bytes([0, 1, 64]), 'parent EXP timing changed')
            before = h.rd(h.s('wEggMon'), h.s('wEggMonEnd') - h.s('wEggMon'))
            for _ in range(65):
                h.call('DayCareStep')
            check(h.rd(h.s('wEggMon'), len(before)) == before, 'pending egg was overwritten')
        for countdown in (0, 65, 150, 255):
            parents('EEVEE', 'EEVEE')
            write('wStepsToEgg', countdown)
            for _ in range(63):
                h.call('DayCareStep')
            check(not read('wDayCareMan') & 64, 'legacy countdown produced egg early')
            h.call('DayCareStep')
            check(read('wDayCareMan') & 64, f'legacy countdown {countdown} exceeded 64 steps')
        for first, second, both_male in [('EEVEE', 'EEVEE', True), ('EEVEE', 'MAGIKARP', False),
                                        ('DITTO', 'DITTO', False), ('TOGEPI', 'DITTO', False)]:
            parents(first, second, both_male=both_male)
            check(not read('wDayCareMan') & 32, 'incompatible parents armed breeding')
            for _ in range(65):
                h.call('DayCareStep')
            check(not read('wDayCareMan') & 64, 'incompatible parents made egg')

        print('[hatching: every party slot, zero guards and native step timing]', flush=True)
        for counters in ([1, 2, 3, 4, 5, 6], [0, 1, 0, 2, 1, 255], [255] * 6):
            write('wPartyCount', 6)
            write('wPartySpecies', [253] * 6 + [255])
            for slot, counter in enumerate(counters, 1):
                write(f'wPartyMon{slot}Happiness', counter)
            result = h.call('DoEggStep')
            check([read(f'wPartyMon{slot}Happiness') for slot in range(1, 7)] == [max(0, c - 1) for c in counters],
                  f'egg cycle stalled a later egg or underflowed: {counters}')
            check((not result['z']) == any(c <= 1 for c in counters), 'wrong hatch-ready result')
        write('wPartySpecies', [1, 253, 1, 255])
        for slot, value in enumerate((70, 2, 120, 1), 1):
            write(f'wPartyMon{slot}Happiness', value)
        result = h.call('DoEggStep')
        check(result['z'] and [read(f'wPartyMon{s}Happiness') for s in range(1, 5)] == [70, 1, 120, 1],
              'egg cycles changed ordinary friendship or read past party terminator')
        write('wPartySpecies', [255])
        check(h.call('DoEggStep')['z'], 'empty party reported a hatch')

        write('wPartyCount', 1)
        write('wPartySpecies', [253, 255])
        write('wPartyMon1Happiness', 35)  # Eevee: at most 560 counted steps
        write('wStepCount', 0)
        write('wPoisonStepCount', 0)
        write('wLinkMode', 0)
        write('wRepelEffect', 0)
        with stub(h, ['CheckSpecialPhoneCall', 'DoSafariStep', 'DayCareStep', 'DoPoisonStep', 'DoBikeStep', 'StepHappiness']):
            for step in range(1, 561):
                result = h.call('CountStep')
                check(read('wPartyMon1Happiness') == 35 - step // 16, f'hatch cycle at native step {step}')
                check(result['c_flag'] == (step == 560), f'hatch event timing at native step {step}')
            check(result['a'] == 8, 'native step did not request hatch event')
            write('wLinkMode', 1)
            before = read('wStepCount')
            h.call('CountStep')
            check(read('wStepCount') == before, 'link room advanced breeding steps')
        print(f'QOL ROM TESTS PASSED: {checks} checks, {h.calls} routine calls.', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
