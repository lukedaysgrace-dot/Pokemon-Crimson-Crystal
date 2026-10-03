#!/usr/bin/env python3
"""ROM regressions for portrait colors and variable NPC walking facings.

Requires PyBoy, like the storage tests. Does not load or write a player save.
"""
from pathlib import Path
from pc_harness import Harness, ROOT
from audit_trainer_sprites import sprite_metadata


def check_rom(h):
    failures = []
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)

    # A variable NPC must animate exactly like the underlying sprite, while
    # true two-frame Pokemon icons must retain their bounce animation.
    obj = h.s('wObjectStructs') + 40
    sprite_ids, _ = sprite_metadata()
    for slot in [5, 6, 7, 8, 9, 10, 11, 12]:
        for sprite in [sprite_ids[name] for name in ['SPRITE_SILVER', 'SPRITE_JANINE', 'SPRITE_ROCKET', 'SPRITE_UNOWN', 'SPRITE_POKE_BALL', 'SPRITE_BIG_SNORLAX']]:
            h.wr(h.s('wVariableSprites') + slot, sprite)
            direct = h.call('_DoesSpriteHaveFacings', a=sprite, bc=0x1234, de=0x5678, hl=0x4321)
            variable = h.call('_DoesSpriteHaveFacings', a=0xf0 + slot, bc=0x1234, de=0x5678, hl=0x4321)
            check(variable['c_flag'] == direct['c_flag'], f'Variable {slot} graphics facings differ from sprite {sprite}')
            check(variable['bc'] == 0x1234 and variable['de'] == 0x5678 and variable['hl'] == 0x4321, 'Facing resolution clobbered registers')
            for direction in [0, 4, 8, 12]:
                facings = []
                for sid in [sprite, 0xf0 + slot]:
                    h.wr(obj, bytes(40))
                    h.wr(obj, sid)
                    h.wr(obj + 8, direction)
                    h.wr(obj + 12, 16)
                    result = h.call('SetFacingStepAction', bc=obj)
                    facings.append(h.rd(obj + 13))
                    check(result['bc'] == obj, 'Walking animation lost object pointer')
                check(facings[0] == facings[1], f'Variable {slot} walking facing differs: sprite {sprite}, direction {direction}, {facings}')

    header_bank, header_addr = h.sym['wPortraitHeader']
    pal_bank, pal_addr = h.sym['wBGPals2']
    # The current portrait occupies the seven-by-seven cells above the box.
    constants = (Path(ROOT) / 'constants/gfx_constants.asm').read_text()
    import re
    def number(name):
        raw = re.search(r'^' + name + r'\s+EQU\s+(\$[0-9a-fA-F]+|\d+)', constants, re.M)[1]
        return int(raw[1:], 16) if raw.startswith('$') else int(raw)
    width = number('PORTRAIT_WIDTH')
    height = number('PORTRAIT_HEIGHT')
    cell = (18 - 6 - height) * 20 + 20 - width
    tile = 0xf4 - width * height - number('PORTRAIT_MAX_MOUTH')
    h.wr(h.s('wTileMap') + cell, tile)
    h.wr(h.s('wAttrMap') + cell, 7 | 8)
    h.wr(h.s('wVramState'), 1 | 8 | 16)
    for portrait in sorted((Path(ROOT) / 'gfx/trainer_portraits').glob('*.portrait')):
        colors = portrait.read_bytes()[1:5]
        h.mem[header_bank, header_addr + 1:header_addr + 5] = colors
        h.wr(h.s('wPortraitShown'), 1)
        for weather in range(8):
            h.wr(h.s('hCurWeather'), weather)
            h.call('_UpdateTimePals')
            active = bytes(h.mem[pal_bank, pal_addr + 7 * 8 + 2:pal_addr + 7 * 8 + 6])
            check(active == colors, f'{portrait.stem} colors changed in weather {weather}: {active.hex()} vs {colors.hex()}')
    # An erased portrait or a closed conversation must give the normal text
    # palette back; preserving portraits must not recolor unrelated interfaces.
    for shown, tile_value in [(0, tile), (1, 0)]:
        h.wr(h.s('wPortraitShown'), shown)
        h.wr(h.s('wTileMap') + cell, tile_value)
        h.call('_UpdateTimePals')
        active = bytes(h.mem[pal_bank, pal_addr + 7 * 8 + 2:pal_addr + 7 * 8 + 6])
        check(active != colors, 'Portrait colors leaked after the portrait was removed')
    check((Path(ROOT) / 'gfx/sprites/fishing_guru.2bpp').stat().st_size == 24 * 16, 'Fishing Guru walking graphics are incomplete')
    return {'checks': checks, 'failures': failures}


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        result = check_rom(h)
        for failure in result['failures']:
            print(failure)
        print(f"{result['checks']} checks; {len(result['failures'])} failures")
        raise SystemExit(bool(result['failures']))
    finally:
        h.pyboy.stop(save=False)
