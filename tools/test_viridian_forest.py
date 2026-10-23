#!/usr/bin/env python3
"""Native forest palette, daily rain and banked tree-animation regressions.

Uses private emulator memory; no player saves are opened or changed.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import _parse_constants

ROOT = Path(ROOT)


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    weather = _parse_constants(ROOT / 'constants/weather_constants.asm')
    constants = _parse_constants(ROOT / 'constants/map_data_constants.asm')
    tilesets = _parse_constants(ROOT / 'constants/tileset_constants.asm')
    checks = 0

    def check(condition, label):
        nonlocal checks
        checks += 1
        assert condition, label

    def write(name, value):
        h.wr(h.s(name), value)

    def read_bank(bank, address, size):
        previous = h.mem[0xff70]
        h.mem[0xff70] = bank
        data = bytes(h.mem[address:address + size])
        h.mem[0xff70] = previous
        return data

    def source(name, size):
        bank, address = h.sym[name]
        return bytes(h.mem[bank, address:address + size])

    maps = {}
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group, number = group + 1, 0
        match = re.match(r'\s*map_const\s+(\w+)', line)
        if match:
            number += 1
            maps[match[1]] = group, number
    forest, outside = maps['VIRIDIAN_FOREST'], maps['VIRIDIAN_CITY']
    try:
        print('[daily rain: exactly half the uniform Kanto choices; no rerolls]', flush=True)
        write('wMapGroup', forest[0])
        write('wMapNumber', forest[1])
        write('wEnvironment', constants['ROUTE'])
        write('wCurDay', 19)
        write('wWeatherRandomDay', 19)
        write('wWeatherDailyFlags', 128)
        for intensity in range(4):
            rainy = 0
            for area in range(10, 22):
                write('wWeatherDailyKanto1', area | intensity << 6)
                for daytime in range(4):
                    write('wTimeOfDay', daytime)
                    result = h.call('SelectCurrentWeather')
                    expected = weather['OW_WEATHER_RAIN'] if area & 1 else weather['OW_WEATHER_NONE']
                    check(result['a'] == expected, f'forest weather: area={area}, intensity={intensity}, time={daytime}')
                rainy += bool(area & 1)
            check(rainy == 6, 'daily forest rain is not exactly 50%')
        write('wMapGroup', outside[0])
        write('wMapNumber', outside[1])
        check(not h.call('CheckViridianForestWeather')['c_flag'], 'forest weather leaked to Viridian City')

        print('[custom BG palette: all four times; ordinary Kanto maps unchanged]', flush=True)
        write('wMapTileset', tilesets['TILESET_KANTO'])
        expected = source('ViridianForestPalette', 64)
        palbank = h.sym.bank('wBGPals1')
        for location in (forest, outside):
            write('wMapGroup', location[0])
            write('wMapNumber', location[1])
            for daytime in range(4):
                write('wTimeOfDayPal', daytime)
                result = h.call('LoadSpecialMapPalette')
                standard = source('KantoTilesetPalette', 256)[daytime * 64:(daytime + 1) * 64]
                check(result['c_flag'], 'Kanto custom palette was not selected')
                check(read_bank(palbank, h.s('wBGPals1'), 64) == (expected if location == forest else standard),
                      f'custom palette: map={location}, time={daytime}')
                if location == forest:
                    h.call('LoadMapPals')
                    check(read_bank(palbank, h.s('wBGPals1'), 64) == expected, 'roof overlay changed forest custom palette')

        print('[tree VRAM: rain-only frames, bank isolation and original Celebi behavior]', flush=True)
        h.mem[0xff40] = 0  # Routine fixtures write VRAM with the LCD disabled.
        frames = {name: source(name, 32) for name in ('ForestTreeLeftFrames', 'ForestTreeRightFrames')}
        variants = [('Left', 0x0a, 0), ('Right', 0x0d, 0), ('Left2', 0x0a, 2), ('Right2', 0x0d, 2)]
        for location in (forest, outside):
            write('wMapGroup', location[0])
            write('wMapNumber', location[1])
            for current in range(weather['OW_WEATHER_CHERRY_BLOSSOMS'] + 1):
                write('hCurWeather', current)
                for timer in range(8):
                    write('wTileAnimationTimer', timer)
                    for name, tile, phase in variants:
                        address = 0x9000 + tile * 16
                        h.mem[0xff4f] = 0
                        h.mem[address:address + 16] = bytes([0xa5] * 16)
                        h.mem[0xff4f] = 1
                        h.mem[address:address + 16] = bytes([0x5a] * 16)
                        h.mem[0xff4f] = 0
                        h.call('AnimateViridianForestTree', de=h.s('ViridianForestTree' + name))
                        check(h.mem[0xff4f] & 1 == 0, 'tree animation did not restore VRAM bank')
                        check(bytes(h.mem[address:address + 16]) == bytes([0xa5] * 16), 'tree animation changed bank 0')
                        h.mem[0xff4f] = 1
                        actual = bytes(h.mem[address:address + 16])
                        index = ((timer & 1) * 2 ^ phase) if current in (weather['OW_WEATHER_RAIN'], weather['OW_WEATHER_THUNDERSTORM']) else 0
                        frame = frames['ForestTree' + ('Left' if name.startswith('Left') else 'Right') + 'Frames']
                        expected_tile = frame[index * 8:index * 8 + 16] if location == forest else bytes([0x5a] * 16)
                        check(actual == expected_tile, f'tree frame: map={location}, weather={current}, timer={timer}, phase={name}')
                        h.mem[0xff4f] = 0
        restless_bit = int(re.search(r'^CELEBIEVENT_FOREST_IS_RESTLESS_F EQU (\d+)',
                                    (ROOT / 'constants/wram_constants.asm').read_text(), re.M)[1])
        for active in (False, True):
            write('wCelebiEvent', int(active) << restless_bit)
            write('wTileAnimationTimer', 1)
            h.call('ForestTreeLeftAnimation')
            check(bytes(h.mem[0x90c0:0x90d0]) == frames['ForestTreeLeftFrames'][16 if active else 0:32 if active else 16],
                  'original Celebi tree animation changed')
        print(f'VIRIDIAN FOREST: {checks} checks passed in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
