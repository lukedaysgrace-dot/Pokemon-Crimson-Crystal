#!/usr/bin/env python3
"""Audit overworld sprite VRAM usage per map."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Parse sprite constants
sprite_ids = {}
current = 0
for line in open(ROOT / "constants/sprite_constants.asm", encoding="utf-8"):
    line = line.split(";")[0].strip()
    m = re.match(r"const_def(?:\s+\$(\w+))?", line)
    if m:
        current = int(m.group(1), 16) if m.group(1) else 0
        continue
    m = re.match(r"(SPRITE_\w+)\s+EQU\s+const_value", line)
    if m:
        sprite_ids[m.group(1)] = current
        continue
    m = re.match(r"const\s+(SPRITE_\w+)", line)
    if m:
        sprite_ids[m.group(1)] = current
        current += 1

# Parse overworld sprite types from sprites.asm
overworld_types = {}
idx = 1
for line in open(ROOT / "data/sprites/sprites.asm", encoding="utf-8"):
    if "overworld_sprite" not in line:
        continue
    m = re.search(r"overworld_sprite\s+\w+,\s+(\d+),\s+(\w+)", line)
    if m:
        overworld_types[idx] = (m.group(2), int(m.group(1)))
        idx += 1

TYPE_TILES = {
    "WALKING_SPRITE": 12,
    "STANDING_SPRITE": 12,
    "STILL_SPRITE": 4,
}

SPRITE_POKEMON = sprite_ids.get("SPRITE_POKEMON", 0x80)
SPRITE_VARS = sprite_ids.get("SPRITE_VARS", 0xF0)


def get_tiles(sprite_name):
    if sprite_name == "SPRITE_NONE":
        return 0
    sid = sprite_ids.get(sprite_name)
    if sid is None:
        return 12
    if sid == 0:
        return 0
    if sid >= SPRITE_VARS:
        return 12
    if sid >= 0xE0:
        return 8
    if sid >= SPRITE_POKEMON:
        return 8
    if sid in overworld_types:
        stype, tiles = overworld_types[sid]
        return TYPE_TILES.get(stype, tiles)
    return 12


def type_priority(sprite_name):
    sid = sprite_ids.get(sprite_name, 0)
    if sid >= SPRITE_POKEMON and sid < 0xE0:
        return 4
    if sid >= SPRITE_VARS:
        return 1
    if sid in overworld_types:
        st = overworld_types[sid][0]
        return {"WALKING_SPRITE": 1, "STANDING_SPRITE": 2, "STILL_SPRITE": 3}.get(st, 1)
    return 1


def analyze_map(path):
    text = path.read_text(encoding="utf-8", errors="replace")
    sprites = []
    for line in text.splitlines():
        if not line.strip().startswith("object_event"):
            continue
        parts = [p.strip() for p in line.split(",")]
        if len(parts) < 3:
            continue
        sp = parts[2]
        if sp.startswith("SPRITE_"):
            sprites.append(sp)

    unique = sorted(set(s for s in sprites if s != "SPRITE_NONE"))
    unique_sorted = sorted(unique, key=lambda s: (type_priority(s), s))
    packed = [12] + [get_tiles(s) for s in unique_sorted]
    total = sum(packed)

    return {
        "objects": len(sprites),
        "unique": len(unique),
        "unique_sprites": unique,
        "tiles": total,
        "fits": total <= 0x100,
        "list_ok": len(unique) + 1 <= 32,
    }


def main():
    results = []
    for f in sorted((ROOT / "maps").glob("*.asm")):
        r = analyze_map(f)
        if r["objects"] == 0:
            continue
        r["map"] = f.stem
        results.append(r)

    results.sort(key=lambda x: (-x["tiles"], -x["unique"], x["map"]))

    print("=== MAPS EXCEEDING 256 TILES (VRAM OVERFLOW) ===")
    overflow = [r for r in results if not r["fits"]]
    if overflow:
        for r in overflow:
            sprites = ", ".join(r["unique_sprites"])
            print(f"  {r['map']}: {r['unique'] + 1} types, {r['tiles']} tiles")
            print(f"    {sprites}")
    else:
        print("  None")

    print("\n=== MAPS WITH 11+ UNIQUE TYPES (player + 10 NPC types) ===")
    many_types = [r for r in results if r["unique"] + 1 >= 11]
    for r in many_types:
        risk = " *** HIGH TILE COUNT" if r["tiles"] >= 180 else ""
        print(f"  {r['map']}: {r['unique'] + 1} types, {r['tiles']} tiles{risk}")

    print("\n=== MAPS WITH 200+ TILES (getting tight) ===")
    tight = [r for r in results if r["tiles"] >= 200 and r["fits"]]
    for r in tight:
        print(f"  {r['map']}: {r['unique'] + 1} types, {r['tiles']} tiles")

    print("\n=== MAPS EXCEEDING 32-ENTRY SPRITE LIST ===")
    list_full = [r for r in results if not r["list_ok"]]
    if list_full:
        for r in list_full:
            print(f"  {r['map']}: {r['unique'] + 1} entries")
    else:
        print("  None")

    print("\n=== SUMMARY ===")
    print(f"Total maps with objects: {len(results)}")
    max_types = max(results, key=lambda x: x["unique"])
    max_tiles = max(results, key=lambda x: x["tiles"])
    print(f"Max types on a map: {max_types['unique'] + 1} ({max_types['map']})")
    print(f"Max tiles on a map: {max_tiles['tiles']} ({max_tiles['map']})")
    print(f"Maps with 11+ types: {len(many_types)}")
    print(f"Maps with 200+ tiles: {len(tight) + len(overflow)}")
    print(f"Maps overflowing VRAM: {len(overflow)}")

    print("\n=== TOP 30 HEAVIEST MAPS ===")
    for r in results[:30]:
        print(f"  {r['map']:42} {r['unique'] + 1:2} types  {r['tiles']:3} tiles")

    print("\n=== ALL MAPS WITH 10+ TYPES ===")
    for r in results:
        if r["unique"] + 1 >= 10:
            print(f"  {r['map']}: {r['unique'] + 1} types, {r['tiles']} tiles")
            print(f"    {', '.join(r['unique_sprites'])}")

    key_routes = [
        "Route35", "Route38", "Route39", "Route40", "Route41", "Route34",
        "OlivineCity", "VioletCity", "Route36", "Route32", "Route43",
    ]
    print("\n=== KEY ROUTES (previously reported) ===")
    by_name = {r["map"]: r for r in results}
    for name in key_routes:
        r = by_name.get(name)
        if not r:
            print(f"  {name}: (no objects)")
            continue
        print(f"  {name}: {r['unique'] + 1} types, {r['tiles']} tiles")


if __name__ == "__main__":
    main()
