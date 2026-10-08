#!/usr/bin/env python3
"""Check Azalea's weekday rain schedule through the real ROM routine.

wCurDay accumulates (Friday is day 5, 12, 19, ...), so the Sunday/Tuesday/
Thursday/Saturday rain rule must reduce it to a weekday first. This calls
CheckAzaleaWeather for every calendar-byte value on an Azalea-area map and
on a map outside the area.

Usage: python3 tools/test_azalea_weather.py [pokecrystal.gbc]
"""
from pathlib import Path

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT

ROOT = Path(ROOT)
RAINY_WEEKDAYS = {0, 2, 4, 6}  # Sunday, Tuesday, Thursday, Saturday


def map_pairs(h, label):
    bank, addr = h.sym[label]
    pairs = []
    while True:
        group = h.mem[bank, addr]
        if group == 0xFF:
            return pairs
        pairs.append((group, h.mem[bank, addr + 1]))
        addr += 2


def check_rom(h):
    weather = _parse_constants(ROOT / 'constants/weather_constants.asm')
    rain = weather['OW_WEATHER_RAIN']
    azalea = map_pairs(h, 'AzaleaWeatherMaps')
    outside = [p for p in map_pairs(h, 'LakeOfRageWeatherMaps') if p not in azalea][:1]
    if not azalea or not outside:
        raise RuntimeError('could not read the weather area tables')
    checks, failures = 0, []
    for group, number in azalea + outside:
        in_area = (group, number) in azalea
        for day in range(256):
            h.wr(h.s('wMapGroup'), group)
            h.wr(h.s('wMapNumber'), number)
            h.wr(h.s('wCurDay'), day)
            result = h.call('CheckAzaleaWeather')
            expected = in_area and (day % 7) in RAINY_WEEKDAYS
            checks += 1
            if result['c_flag'] != expected:
                failures.append(f'map {group}:{number} day {day} (weekday {day % 7}): '
                                f'rain={result["c_flag"]}, expected {expected}')
            elif expected and result['a'] != rain:
                failures.append(f'map {group}:{number} day {day}: weather {result["a"]}, expected rain')
    return checks, failures


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        checks, failures = check_rom(h)
        for message in failures[:40]:
            print(message)
        print(f'AZALEA WEATHER: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        h.pyboy.stop(save=False)
