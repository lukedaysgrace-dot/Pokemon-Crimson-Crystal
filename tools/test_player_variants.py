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
