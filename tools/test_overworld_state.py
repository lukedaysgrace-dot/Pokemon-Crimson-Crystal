#!/usr/bin/env python3
"""Routine and compiled-script regressions for calendar and progression state.

Private in-memory SRAM; no player saves are loaded. Script checks suppress
presentation only. Inventory, ownership, flags, script branches and daily
weather generation execute the compiled ROM. Optional ROM path supports
before/after reproductions.
"""
from contextlib import contextmanager
from itertools import product
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants

ROOT = Path(ROOT)


@contextmanager
def patches(h, replacements):
    original = {}
    try:
        for name, data in replacements.items():
            bank, addr = h.sym[name]
            original[name] = bytes(h.mem[bank, addr:addr + len(data)])
            for offset, value in enumerate(data):
                h.mem[bank, addr + offset] = value
        yield
    finally:
        for name, data in original.items():
            bank, addr = h.sym[name]
            for offset, value in enumerate(data):
                h.mem[bank, addr + offset] = value


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks, failures = 0, []

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)
            if len(failures) <= 25:
                print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    print('[party ownership: all foreign/owned/other configurations, 0-6 members]', flush=True)
    target = h.species_id(con.species_index('TOGEPI'))
    other = h.species_id(con.species_index('PIKACHU'))
    write('wPlayerID', [0x12, 0x34])
    for count in range(7):
        for states in product(range(3), repeat=count):
            write('wPartyCount', count)
            write('wPartySpecies', [other if s == 2 else target for s in states] + [255])
            for slot, state in enumerate(states):
                write(f'wPartyMon{slot + 1}Species', other if state == 2 else target)
                write(f'wPartyMon{slot + 1}ID', [0x12, 0x34] if state == 1 else [0x56, 0x78])
            result = h.call('_FindPartyMonThatSpeciesYourTrainerID', bc=target << 8)
            expected = 1 in states
            check((not result['z']) == expected, f'ownership {states}: found={not result["z"]}, expected={expected}')
    write('wPartyCount', 0)
    write('wPartySpecies', [255])

    print('[daily weather: exact day identity, day zero, legacy cache and resets]', flush=True)
    generated = []
    bank, addr = h.sym['GenerateDailyWeather']
    h.pyboy.hook_register(bank, addr, lambda _: generated.append(read('wCurDay')), None)
    try:
        for day in range(256):
            write('wCurDay', day)
            write('wWeatherRandomDay', day)
            write('wWeatherDailyFlags', 0x80)
            before = len(generated)
            h.call('EnsureDailyWeather')
            check(len(generated) == before, f'weather day {day}: valid same-day cache rerolled')
        for old, day in [(0, 16), (5, 21), (12, 44), (19, 147), (128, 0), (139, 0), (255, 0)]:
            write('wCurDay', old)
            h.call('GenerateDailyWeather')
            before = len(generated)
            write('wCurDay', day)
            h.call('EnsureDailyWeather')
            check(len(generated) == before + 1, f'weather {old}->{day}: stale day reused')
            check(read('wWeatherRandomDay') == day, f'weather {old}->{day}: cached day loses bits')
            check(read('wWeatherDailyFlags') & 128, f'weather {old}->{day}: no valid-cache marker')
            selections = h.rd(h.s('wWeatherDailySelections'), 8)
            check(len(set(v & 63 for v in selections[:4])) == 4, 'Johto weather areas are not distinct')
            check(len(set(v & 63 for v in selections[4:])) == 4, 'Kanto weather areas are not distinct')
            before = len(generated)
            h.call('EnsureDailyWeather')
            check(len(generated) == before, f'weather {day}: repeated map lookup rerolls')
        for day in (0, 5, 16, 139, 255):
            write('wCurDay', day)
            write('wWeatherRandomDay', day | 0xB0)
            write('wWeatherDailyFlags', 0x7F)
            before = len(generated)
            h.call('EnsureDailyWeather')
            check(len(generated) == before + 1, f'weather legacy day {day}: did not migrate cache')
        write('wCurDay', 0)
        write('wWeatherDailyFlags', 0xFF)
        h.call('ClearDailyTimers')
        before = len(generated)
        h.call('EnsureDailyWeather')
        check(len(generated) == before + 1, 'weather day-zero cache survives timer reset')
    finally:
        h.pyboy.hook_deregister(bank, addr)

    print('[elapsed-time helper boundaries]', flush=True)
    for days, hours, minutes, seconds in product((0, 1), (0, 1), (0, 1, 59), (0, 1, 59)):
        for name, value in [('wDaysSince', days), ('wHoursSince', hours), ('wMinutesSince', minutes), ('wSecondsSince', seconds)]:
            write(name, value)
        expected = 255 if days or hours or minutes else seconds
        result = h.call('GetSecondsSinceIfLessThan60')['a']
        check(result == expected, f'seconds limit {days}:{hours}:{minutes}:{seconds}: {result} != {expected}')

    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    flags = _parse_constants(ROOT / 'constants/engine_flags.asm')
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    status_flags = _parse_constants(ROOT / 'constants/wram_constants.asm')

    def event(name, value=None):
        result = h.call('EventFlagAction', bc=(2 if value is None else int(value)) << 8, de=events[name])
        return bool(result['c'])

    def engine_flag(name, value):
        h.call('EngineFlagAction', bc=int(value) << 8, de=flags[name])

    def script(name, stops=()):
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        for _ in range(300):
            position = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            for stop in stops:
                if position == h.sym[stop]:
                    return stop
            h.call('RunScriptCommand')
            if read('wScriptMode') == 0:
                return None
        raise RuntimeError(f'{name}: script command budget exceeded')

    presentation = {name: b'\xc9' for name in (
        'Script_faceplayer', 'Script_opentext', 'Script_closetext',
        'Script_waitbutton', 'Script_buttonsound', 'Script_itemnotify',
        'Script_pocketisfull', 'Script_specialsound', 'MapTextbox', 'PrintText', 'PlaySFX', 'WaitSFX')}
    with patches(h, presentation):
        print('[compiled gym scripts: sixth/seventh badge Rocket activation]', flush=True)
        for gym in ('Violet', 'Azalea', 'Goldenrod', 'Ecruteak', 'Cianwood', 'Olivine', 'Mahogany'):
            for badges in range(9):
                event('EVENT_GOLDENROD_CITY_ROCKET_TAKEOVER', True)
                event('EVENT_RADIO_TOWER_ROCKET_TAKEOVER', True)
                event('EVENT_GOLDENROD_CITY_CIVILIANS', False)
                engine_flag('ENGINE_ROCKETS_IN_RADIO_TOWER', False)
                write('wScriptVar', badges)
                script(gym + 'GymActivateRockets')
                check(event('EVENT_GOLDENROD_CITY_ROCKET_TAKEOVER') == (badges != 6), f'{gym}, {badges} badges: street takeover')
                check(event('EVENT_RADIO_TOWER_ROCKET_TAKEOVER') == (badges != 7), f'{gym}, {badges} badges: tower takeover')
                check(event('EVENT_GOLDENROD_CITY_CIVILIANS') == (badges == 7), f'{gym}, {badges} badges: civilian visibility')

        print('[compiled Elm egg checks: owned, traded and evolved offspring]', flush=True)
        write('wPlayerID', [0x12, 0x34])
        event('EVENT_GOT_EVERSTONE_FROM_ELM', False)
        event('EVENT_SHOWED_TOGEPI_TO_ELM', False)
        event('EVENT_TOLD_ELM_ABOUT_TOGEPI_OVER_THE_PHONE', True)
        for offspring in ('TOGEPI', 'TOGETIC', 'TOGEKISS'):
            sid = h.species_id(con.species_index(offspring))
            for owner in (False, True):
                write('wPartyCount', 2)
                write('wPartySpecies', [sid, sid, 255])
                for slot, owned in ((1, False), (2, owner)):
                    write(f'wPartyMon{slot}Species', sid)
                    write(f'wPartyMon{slot}ID', [0x12, 0x34] if owned else [0x56, 0x78])
                end = script('ElmEggHatchedScript', ('ShowElmTogepiScript', 'ElmCheckGotEggAgain'))
                check(end == ('ShowElmTogepiScript' if owner else 'ElmCheckGotEggAgain'), f'Elm {offspring}, owner={owner}: wrong branch')
                end = script('ElmCheckEverstone', ('ShowElmTogepiScript',))
                check(end == ('ShowElmTogepiScript' if owner else None), f'Elm phone route {offspring}, owner={owner}: wrong branch')

        print('[compiled one-time item rewards: full pack, retry and exactly once]', flush=True)
        full = []
        for value in range(1, 256):
            label = con.items_by_id.get(value)
            if label in ('EVERSTONE', 'METAL_COAT') or label is None:
                continue
            write('wCurItem', value)
            h.call('CheckItemPocket')
            if read('wItemAttributeParamBuffer') == 1:
                full += [value, 99]
                if len(full) == 80:
                    break
        if len(full) != 80:
            raise RuntimeError('could not construct full item pocket')
        for entry, reward, event_name in (
                ('ElmGiveEverstoneScript', 'EVERSTONE', 'EVENT_GOT_EVERSTONE_FROM_ELM'),
                ('OlivineGymJasmineScript', 'METAL_COAT', 'EVENT_GOT_METAL_COAT_FROM_JASMINE')):
            event('EVENT_BEAT_JASMINE', True)
            event('EVENT_GOT_TM23_IRON_HEAD', True)
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', True)
            event('EVENT_GOT_SS_TICKET_FROM_ELM', True)
            event('EVENT_SHOWED_TOGEPI_TO_ELM', True)
            event(event_name, False)
            write('wNumItems', 40)
            write('wItems', full + [255])
            script(entry)
            check(not event(event_name), f'{reward}: full pack lost pending reward')
            check(read('wNumItems') == 40 and h.rd(h.s('wItems'), 81) == bytes(full + [255]), f'{reward}: failed gift changed inventory')
            write('wNumItems', 0)
            write('wItems', [255])
            script(entry)
            check(event(event_name), f'{reward}: retry did not complete')
            check(read('wNumItems') == 1 and h.rd(h.s('wItems'), 3) == bytes([items[reward], 1, 255]), f'{reward}: retry inventory incorrect')
            if reward == 'EVERSTONE':
                entry = 'ProfElmScript'
            script(entry)
            check(read('wNumItems') == 1 and h.rd(h.s('wItems'), 3) == bytes([items[reward], 1, 255]), f'{reward}: duplicate reward on next conversation')

        print('[all fruit trees: full pack, retry, same-day repeat and daily renewal]', flush=True)
        fruits = re.findall(r'^\s*db\s+(\w+)', (ROOT / 'data/items/fruit_trees.asm').read_text(), re.MULTILINE)
        daily = _parse_constants(ROOT / 'constants/wram_constants.asm')
        reset_mask = 1 << daily['DAILYFLAGS1_ALL_FRUIT_TREES_F']
        for tree, fruit in enumerate(fruits, 1):
            write('wCurFruitTree', tree)
            write('wFruitTreeFlags', bytes(4))
            write('wDailyFlags1', reset_mask)
            write('wNumItems', 40)
            write('wItems', full + [255])
            script('FruitTreeScript')
            check(h.rd(h.s('wFruitTreeFlags'), 4) == bytes(4), f'tree {tree}: full pack consumed fruit')
            check(h.rd(h.s('wItems'), 81) == bytes(full + [255]), f'tree {tree}: failed gift changed pack')
            write('wNumItems', 0)
            write('wItems', [255])
            quantity = 3 if fruit.endswith('_APRICORN') else 1
            script('FruitTreeScript')
            expected_flags = (1 << (tree - 1)).to_bytes(4, 'little')
            check(h.rd(h.s('wFruitTreeFlags'), 4) == expected_flags, f'tree {tree}: wrong picked flag')
            check(read('wNumItems') == 1 and h.rd(h.s('wItems'), 3) == bytes([items[fruit], quantity, 255]), f'tree {tree}: wrong fruit/quantity')
            script('FruitTreeScript')
            check(h.rd(h.s('wItems'), 3) == bytes([items[fruit], quantity, 255]), f'tree {tree}: duplicate same-day gift')
            # Daily timer clearing is tested separately below. Exercise the
            # first tree interaction after that clear through its real script.
            write('wDailyFlags1', 0)
            script('FruitTreeScript')
            check(h.rd(h.s('wFruitTreeFlags'), 4) == expected_flags, f'tree {tree}: renewal flag incorrect')
            check(h.rd(h.s('wItems'), 3) == bytes([items[fruit], quantity * 2, 255]), f'tree {tree}: next-day renewal failed')

    print('[elapsed calendar arithmetic and daily flags]', flush=True)
    for day, hour, minute, second in product((0, 5, 139, 145), (0, 23), (0, 59), (0, 59)):
        start = (day, hour, minute, second)
        for elapsed in (0, 1, 59, 60, 3599, 3600, 86399, 86400, 172801):
            total = (hour * 3600 + minute * 60 + second) + elapsed
            now_day = day + total // 86400
            if day < 140:
                now_day %= 140
            rem = total % 86400
            now_hour, rem = divmod(rem, 3600)
            now_minute, now_second = divmod(rem, 60)
            write('wCurDay', now_day)
            write('hHours', now_hour)
            write('hMinutes', now_minute)
            write('hSeconds', now_second)
            write('wBugContestStartTime', start)
            h.call('CalcSecsMinsHoursDaysSince', hl=h.s('wBugContestStartTime'))
            observed = read('wDaysSince') * 86400 + read('wHoursSince') * 3600 + read('wMinutesSince') * 60 + read('wSecondsSince')
            check(observed == elapsed, f'timer {start} + {elapsed}s: got {observed}s')
    with patches(h, {'UpdateTime': b'\xc9'}):
        for old, day in ((0, 0), (0, 1), (5, 12), (139, 0)):
            write('wCurDay', day)
            write('wDailyResetTimer', [1, old])
            for name, size in [('wDailyFlags1', 4), ('wDailyRematchFlags', 4), ('wDailyPhoneItemFlags', 4), ('wDailyPhoneTimeOfDayFlags', 4)]:
                write(name, bytes([255] * size))
            write('wWeatherDailyFlags', 255)
            h.call('CheckDailyResetTimer')
            for name, size in [('wDailyFlags1', 4), ('wDailyRematchFlags', 4), ('wDailyPhoneItemFlags', 4), ('wDailyPhoneTimeOfDayFlags', 4)]:
                check(h.rd(h.s(name), size) == bytes([255 if old == day else 0] * size), f'daily {old}->{day}: {name}')
            check(bool(read('wWeatherDailyFlags') & 128) == (old == day), f'daily {old}->{day}: weather validity')

    print('[level caps: both difficulties, every badge count, Hall of Fame]', flush=True)
    caps = [10, 16, 20, 25, 30, 34, 38, 45, 57, 58, 63, 65, 67, 68, 69, 70, 71, 73]
    for hard, hall, badge_count in product((False, True), (False, True), range(17)):
        engine_flag('ENGINE_HARD_MODE', hard)
        hall_mask = 1 << status_flags['STATUSFLAGS_HALL_OF_FAME_F']
        write('wStatusFlags', (read('wStatusFlags') & ~hall_mask) | (hall_mask if hall else 0))
        write('wJohtoBadges', min((1 << min(badge_count, 8)) - 1, 255))
        write('wKantoBadges', (1 << max(badge_count - 8, 0)) - 1)
        h.call('UpdateLevelCap')
        expected = caps[badge_count + int(hall and badge_count >= 8)] if hard else 100
        check(read('wLevelCap') == expected, f'cap hard={hard}, hall={hall}, badges={badge_count}')

    print('[Save/load: weather cache and daily-state fields]', flush=True)
    write('wPartyCount', 0)
    write('wPartySpecies', [255])
    write('wCurBox', 0)
    h.call('InitializeBoxes')
    h.call('ClearBackupBoxes')
    write('wSavedAtLeastOnce', 1)
    expected = {'wWeatherRandomDay': 0, 'wWeatherDailyFlags': 0xD5, 'wDailyFlags1': 0xA5}
    for name, value in expected.items():
        write(name, value)
    selections = bytes([0, 65, 130, 195, 20, 85, 150, 215])
    write('wWeatherDailySelections', selections)
    h.call('SaveGameData', max_frames=600)
    for name in expected:
        write(name, 0)
    write('wWeatherDailySelections', bytes(8))
    loaded = h.call('TryLoadSaveFile', max_frames=600)
    check(not loaded['c_flag'], 'weather save could not reload')
    for name, value in expected.items():
        check(read(name) == value, f'{name} changed on Save/load')
    check(h.rd(h.s('wWeatherDailySelections'), 8) == selections, 'weather areas changed on Save/load')

    print(f'OVERWORLD STATE: {checks} checks; {len(failures)} failures', flush=True)
    h.pyboy.stop(save=False)
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
