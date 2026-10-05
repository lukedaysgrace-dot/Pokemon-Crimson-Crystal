#!/usr/bin/env python3
"""Check fishing boat graphics, VRAM allocation, and stationary animation.

Run after building: python3 tools/test_fishing_boats.py
Uses an in-memory cartridge and never reads or writes the player's save.
"""
import re
from pathlib import Path

from audit_trainer_sprites import sprite_metadata
from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT


def check_rom(h):
    root = Path(ROOT)
    constants = _parse_constants(root / 'constants/map_object_constants.asm')
    ids, _ = sprite_metadata()
    boat = ids['SPRITE_FISHING_BOAT']
    failures = []
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)

    # The byte-size field wraps at 256; the loader must still copy 16 tiles.
    h.wr(h.s('wPlayerGender'), 0)
    for name, size in [('SPRITE_GOLD', 12), ('SPRITE_POKE_BALL', 4),
                       ('SPRITE_POLIWRATH_NPC', 8), ('SPRITE_FISHING_BOAT', 16)]:
        result = h.call('GetSprite', a=ids[name])
        check(result['c'] == size, f'{name} loaded {result["c"]} tiles instead of {size}')
    expected_bank, expected_address = h.sym['FishingBoatSpriteGFX']
    result = h.call('GetSprite', a=boat)
    check((result['b'], result['de']) == (expected_bank, expected_address), 'Wrong boat graphics pointer')
    check(h.call('GetSpriteLength', a=result['hl'] & 255)['a'] == 16, 'Boat allocator reserves fewer than 16 tiles')
    check(h.call('_DoesSpriteHaveFacings', a=boat)['c_flag'], 'Boat loader attempts to read a second walking sheet')

    # Exercise the actual outdoor list, including Olivine's existing NPCs.
    used = h.s('wUsedSprites')
    h.wr(used, bytes(64))
    h.wr(h.s('wMapGroup'), 1)
    h.wr(h.s('wPlayerState'), 0)
    h.call('GetPlayerSprite')
    h.call('AddOutdoorSprites')
    h.call('LoadAndSortSprites')
    entries = h.rd(used, 64)
    tiles = next((entries[i + 1] for i in range(0, 64, 2) if entries[i] == boat), None)
    check(tiles is not None and tiles >= 7, 'Boat is missing or has no outdoor VRAM allocation')
    if tiles is None or tiles < 7:
        return checks, failures
    h.wr(0xff40, 0)  # LCD off: copy graphics directly, without VBlank waits.
    h.wr(h.s('hUsedSpriteIndex'), boat)
    h.wr(h.s('hUsedSpriteTile'), tiles)
    h.wr(h.s('wSpriteFlags'), 0x20 if tiles & 0x80 else 0)
    h.call('GetUsedSprite')
    vbank = 0 if tiles & 0x80 else 1
    address = 0x8000 + (tiles & 0x7f) * 16
    expected = (root / 'gfx/sprites/fishing_boat.2bpp').read_bytes()
    check(bytes(h.mem[vbank, address:address + 256]) == expected, 'Boat graphics were truncated or loaded into the wrong VRAM bank')

    obj = h.s('wObject1Struct')
    h.wr(obj, bytes(40))
    fields = {
        'OBJECT_SPRITE': boat, 'OBJECT_MAP_OBJECT_INDEX': 255,
        'OBJECT_SPRITE_TILE': tiles,
        'OBJECT_MOVEMENTTYPE': constants['SPRITEMOVEDATA_FISHING_BOAT'],
        'OBJECT_PALETTE': 3 | 0x20,
        'OBJECT_NEXT_MAP_X': 10, 'OBJECT_NEXT_MAP_Y': 10,
        'OBJECT_MAP_X': 10, 'OBJECT_MAP_Y': 10,
        'OBJECT_INIT_X': 10, 'OBJECT_INIT_Y': 10,
        'OBJECT_SPRITE_X': 40, 'OBJECT_SPRITE_Y': 40,
    }
    for name, value in fields.items():
        h.wr(obj + constants[name], value)
    h.wr(h.s('wXCoord'), 10)
    h.wr(h.s('wYCoord'), 10)
    h.wr(h.s('wPlayerBGMapOffsetX'), 0)
    h.wr(h.s('wPlayerBGMapOffsetY'), 0)
    seen = set()
    for tick in range(96):
        h.call('Function437b', bc=obj)
        facing = h.rd(obj + constants['OBJECT_FACING_STEP'])
        seen.add(facing)
        frame = ((tick + 1) // 32) & 1
        check(facing == constants['FACING_FISHING_BOAT_0'] + frame, f'Boat animation cadence is wrong at tick {tick}')
        check(all(h.rd(obj + constants[name]) == value for name, value in fields.items()), f'Boat moved or changed its graphics at tick {tick}')
        if tick in (0, 31):
            h.wr(h.s('hUsedSpriteIndex'), 0)
            h.call('InitSprites.InitSprite', bc=obj)
            oam = h.rd(h.s('wVirtualOAM'), 32)
            check(h.rd(h.s('hUsedSpriteIndex')) == 32, 'Boat did not draw all eight hardware sprites')
            check(list(oam[2::4]) == [(tiles & 0x7f) + frame * 8 + i for i in range(8)], 'Boat frame uses the wrong source tiles')
            check(list(oam[1::4]) == [48, 56, 64, 72] * 2, 'Boat is not rendered at its full 32-pixel width')
            check(list(oam[0::4]) == [52] * 4 + [60] * 4, 'Boat is not rendered at its 16-pixel frame height')
    check(len(seen) == 2, 'Boat animation never switches frames')
    timer = h.rd(obj + constants['OBJECT_STEP_FRAME'])
    h.call('Function4440', bc=obj)
    check(h.rd(obj + constants['OBJECT_STEP_FRAME']) == timer, 'Paused boat animation advances during a frozen object update')

    # Both tiles under each 32-pixel boat must be water.
    blocks = (root / 'maps/OlivineFishingCove.ablk').read_bytes()
    collisions = {}
    for values, block in re.findall(r'tilecoll (.+) ; ([0-9a-f]+)', (root / 'data/tilesets/johto_collision.asm').read_text()):
        collisions[int(block, 16)] = values.split(', ')
    script = (root / 'maps/OlivineFishingCove.asm').read_text()
    boats = re.findall(r'object_event\s+(\d+),\s*(\d+),\s*SPRITE_FISHING_BOAT,', script)
    check(len(boats) == 3, 'Cove must contain three boats')
    for x, y in boats:
        x, y = int(x), int(y)
        for tx in (x, x + 1):
            block = blocks[(y // 2) * 20 + tx // 2]
            check(collisions[block][(y % 2) * 2 + tx % 2] == 'WATER', f'Boat at {x},{y} overlaps land')
    return checks, failures


if __name__ == '__main__':
    harness = Harness()
    harness.boot()
    try:
        checks, failures = check_rom(harness)
        for failure in failures:
            print('FAIL:', failure)
        print(f'FISHING BOATS: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        harness.pyboy.stop(save=False)
