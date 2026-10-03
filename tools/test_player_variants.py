#!/usr/bin/env python3
"""Runtime checks for all four playable-character graphics and palettes.

Run: python3 tools/test_player_variants.py [rom]
"""

import re
import sys
from pathlib import Path

from pc_harness import Harness


PASS = 0
FAIL = 0


def check(condition, message):
    global PASS, FAIL
    if condition:
        PASS += 1
    else:
        FAIL += 1
        print("FAIL:", message)


rom = sys.argv[1] if len(sys.argv) > 1 else None
h = Harness(rom=rom) if rom else Harness()
h.boot()

variants = (
    ("Gold", 0, "GoldSpriteGFX", "PlayerPalette"),
    ("Lyra", 1, "LyraSpriteGFX", "PlayerPalette"),
    ("Indigo", 2, "IndigoSpriteGFX", "IndigoPlayerPalette"),
    ("Mint", 3, "MintSpriteGFX", "MintPlayerPalette"),
)

for name, gender, sprite_label, palette_label in variants:
    h.wr(h.s("wPlayerGender"), gender)
    h.wr(h.s("wPlayerSpriteSetupFlags"), 0)
    h.wr(h.s("wPlayerState"), 0)  # PLAYER_NORMAL

    icon = h.call("GetPlayerIcon")
    expected_bank, expected_addr = h.sym[sprite_label]
    check(icon["de"] == expected_addr, f"{name} icon points to ${icon['de']:04x}, expected {sprite_label}")
    check(icon["b"] == expected_bank, f"{name} icon bank is ${icon['b']:02x}, expected ${expected_bank:02x}")

    h.call("GetPlayerSprite")
    sprite_id = h.rd(h.s("wPlayerSprite"))
    sprite = h.call("GetSprite", a=sprite_id)
    check(sprite["de"] == expected_addr, f"{name} overworld sprite does not resolve to {sprite_label}")
    check(sprite["b"] == expected_bank, f"{name} overworld sprite uses the wrong ROM bank")

    palette = h.call("GetPlayerOrMonPalettePointer", a=0)
    expected_palette = h.s(palette_label)
    check(palette["hl"] == expected_palette, f"{name} player palette does not resolve to {palette_label}")

# The map and party Fly picker use different icon initialization paths.
# Check actual rendered OAM through the full standing/walking/flipped cycle.
for name, gender, _, _ in variants:
    expected_palette = 7  # dedicated map-player OBJ slot
    h.wr(h.s("wPlayerGender"), gender)
    h.wr(h.s("wPlayerSpriteSetupFlags"), 0)
    for entry in ("PokegearMap_InitPlayerIcon", "TownMapPlayerIcon"):
        h.call("ClearSpriteAnims")
        # Request2bpp needs VBlank interrupts; the harness's return trap uses DI.
        bank, address = h.sym[entry]
        h.wr(0xc0fa, [0xfb, 0xc3, address & 0xff, address >> 8])  # EI; JP entry
        h.sym.by_name["MapIconTestEntry"] = (bank, 0xc0fa)
        h.call("MapIconTestEntry", a=1)  # New Bark Town landmark
        seen_tiles, seen_flips = set(), set()
        for frame in range(40):
            h.call("PlaySpriteAnimations")
            oam = h.rd(h.s("wVirtualOAM"), 16)
            check(all((attr & 7) == expected_palette for attr in oam[3::4]),
                  f"{name} {entry} frame {frame} uses the wrong OBJ palette")
            seen_tiles.add(oam[2])
            seen_flips.add(oam[3] & 0x20)
        check(seen_tiles == {0x10, 0x14}, f"{name} {entry} lost its walking frames")
        check(seen_flips == {0, 0x20}, f"{name} {entry} lost its flipped walking frame")

# The Pokedex area map writes the standing player directly instead of using
# sprite animations; it must use the same dedicated character palette.
for name, gender, _, _ in variants:
    h.wr(h.s("wPlayerGender"), gender)
    h.wr(h.s("wTownMapPlayerIconLandmark"), 1)
    h.wr(h.s("wTownMapCursorLandmark"), 0)  # Johto
    h.call("Pokedex_GetArea.HideNestsShowPlayer")
    oam = h.rd(h.s("wVirtualOAM"), 16)
    check(all((attr & 7) == 7 for attr in oam[3::4]), f"{name} Pokedex map player uses the wrong palette")
    check(list(oam[2::4]) == [0x78, 0x79, 0x7a, 0x7b], f"{name} Pokedex map player tiles changed")

# The player slot must match the overworld at every time of day, even after
# party palettes were loaded. Other OBJ slots (Fly Pokemon/cursor) must survive.
rom_data = Path(rom or Path(__file__).resolve().parents[1] / "pokecrystal.gbc").read_bytes()
pal_bank, pal_addr = h.sym["MapObjectPals"]
for name, gender, _, _ in variants:
    h.wr(h.s("wPlayerGender"), gender)
    for time in range(4):
        h.wr(h.s("wTimeOfDayPal"), time)
        h.mem[0xff70] = h.sym["wOBPals1"][0]
        h.wr(h.s("wOBPals1"), bytes([0x55] * 64))
        h.mem[0xff70] = 1
        h.call("_CGB_PokegearPals")
        h.mem[0xff70] = h.sym["wOBPals1"][0]
        actual = h.rd(h.s("wOBPals1"), 64)
        h.mem[0xff70] = 1
        color = (0, 0, 4, 1)[gender]
        offset = pal_bank * 0x4000 + (pal_addr & 0x3fff) + time * 64 + color * 8
        check(actual[56:] == rom_data[offset:offset + 8], f"{name} map colors wrong at time {time}")
        check(actual[:56] == bytes([0x55] * 56), f"{name} map overwrote Fly Pokemon/cursor colors")

layout_path = Path(__file__).resolve().parents[1] / "engine/gfx/cgb_layouts.asm"
layout = layout_path.read_text(encoding="utf-8")
pack_block = layout.split("_CGB_PackPals:", 1)[1].split("_CGB_Pokepic:", 1)[0]
check(
    re.search(r"bit PLAYERGENDER_FEMALE_F, a\s+jr z, \.tutorial_male\s+ld hl, \.LyraPackPals", pack_block),
    "female characters do not select the Lyra pack palette",
)
check("ld bc, 6 palettes" in pack_block, "pack palette loader must copy exactly its six source palettes")
gold_bank, gold_addr = h.sym["_CGB_PackPals.GoldPackPals"]
lyra_bank, lyra_addr = h.sym["_CGB_PackPals.LyraPackPals"]
check(gold_bank == lyra_bank, "male and female pack palettes should share a ROM bank")
check(lyra_addr - gold_addr == 6 * 8, "male pack palette source is not exactly six palettes")

try:
    h.pyboy.stop(save=False)
except TypeError:
    h.pyboy.stop()

print(f"PLAYER VARIANT TESTS: {PASS} passed, {FAIL} failed")
raise SystemExit(1 if FAIL else 0)
