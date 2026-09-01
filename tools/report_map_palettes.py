#!/usr/bin/env python3
"""Report used and unused overworld OBJ palette slots for every map."""

from pathlib import Path
import re


ROOT = Path(__file__).resolve().parent.parent

PALETTES = ("red", "blue", "green", "brown", "purple", "silver", "tree", "rock")
PLAYER_AND_ENGINE_RESERVED = {"red", "blue", "purple", "silver"}


def normalize_palette(name):
    name = name.removeprefix("PAL_NPC_").removeprefix("PAL_OW_").lower()
    return "purple" if name == "pink" else name


def parse_sprite_defaults():
    sprite_names = []
    for raw_line in (ROOT / "constants/sprite_constants.asm").read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";")[0].strip()
        if line.startswith("SPRITE_POKEMON EQU"):
            break
        match = re.match(r"const (SPRITE_[A-Z0-9_]+)$", line)
        if match and match.group(1) != "SPRITE_NONE":
            sprite_names.append(match.group(1))

    sprite_palettes = []
    for raw_line in (ROOT / "data/sprites/sprites.asm").read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";")[0]
        match = re.search(r"overworld_sprite\s+[^,]+,\s*[^,]+,\s*[^,]+,\s*(PAL_OW_[A-Z_]+)", line)
        if match:
            sprite_palettes.append(normalize_palette(match.group(1)))

    if len(sprite_names) != len(sprite_palettes):
        raise RuntimeError(
            f"sprite constant/data mismatch: {len(sprite_names)} names, "
            f"{len(sprite_palettes)} palette entries"
        )

    return dict(zip(sprite_names, sprite_palettes))


def parse_pokemon_sprite_names():
    names = set()
    in_pokemon_sprites = False
    for raw_line in (ROOT / "constants/sprite_constants.asm").read_text(encoding="utf-8").splitlines():
        line = raw_line.split(";")[0].strip()
        if line.startswith("SPRITE_POKEMON EQU"):
            in_pokemon_sprites = True
            continue
        if in_pokemon_sprites and line.startswith("const_def"):
            break
        if in_pokemon_sprites:
            match = re.match(r"const (SPRITE_[A-Z0-9_]+)$", line)
            if match:
                names.add(match.group(1))
    return names


def parse_map_names():
    text = (ROOT / "data/maps/scripts.asm").read_text(encoding="utf-8")
    names = re.findall(r'INCLUDE "maps/([A-Za-z0-9_]+)\.asm"', text)
    if len(names) != len(set(names)):
        raise RuntimeError("duplicate map include found in data/maps/scripts.asm")
    return sorted(names, key=str.casefold)


def analyze_map(map_name, sprite_defaults, pokemon_sprites):
    path = ROOT / "maps" / f"{map_name}.asm"
    used = set()
    dynamic = set()
    object_count = 0

    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.split(";")[0].strip()
        if not line.startswith("object_event"):
            continue
        parts = [part.strip() for part in line.split(",")]
        if len(parts) < 9:
            continue
        object_count += 1
        sprite = parts[2]
        palette = parts[8]

        explicit = re.search(r"PAL_(?:NPC|OW)_([A-Z_]+)", palette)
        if explicit:
            used.add(normalize_palette(explicit.group(0)))
            continue

        if palette != "0":
            dynamic.add(f"palette:{palette}")
            used.update(PALETTES)
            continue

        if sprite in sprite_defaults:
            used.add(sprite_defaults[sprite])
        elif sprite.startswith("SPRITE_"):
            # Pokemon sprite IDs default to red. Variable sprite IDs can resolve
            # to several NPC palettes, so keep the report conservative for them.
            if sprite in pokemon_sprites or sprite.startswith("SPRITE_DAY_CARE_MON_"):
                used.add("red")
            else:
                dynamic.add(sprite)
                used.update(("red", "blue", "green", "brown", "purple"))
        else:
            dynamic.add(sprite)
            used.update(PALETTES)

    unused = set(PALETTES) - used
    candidates = unused - PLAYER_AND_ENGINE_RESERVED
    return object_count, used, unused, candidates, sorted(dynamic)


def palette_list(values, map_name=None, used=False):
    labels = []
    for palette in PALETTES:
        if palette not in values:
            continue
        if map_name == "DanceTheatre" and used and palette == "rock":
            labels.append("pink* (rock slot)")
        else:
            labels.append(palette)
    return ", ".join(labels) if labels else "(none)"


def build_report():
    sprite_defaults = parse_sprite_defaults()
    pokemon_sprites = parse_pokemon_sprite_names()
    map_names = parse_map_names()
    rows = []
    dynamic_maps = []

    for map_name in map_names:
        object_count, used, unused, candidates, dynamic = analyze_map(
            map_name, sprite_defaults, pokemon_sprites
        )
        rows.append(
            "| {name} | {count} | {used} | {unused} | {candidates} |".format(
                name=map_name,
                count=object_count,
                used=palette_list(used, map_name, used=True),
                unused=palette_list(unused),
                candidates=palette_list(candidates),
            )
        )
        if dynamic:
            dynamic_maps.append((map_name, dynamic))

    lines = [
        "# Map overworld OBJ palette availability",
        "",
        "Generated from `maps/*.asm`, `constants/sprite_constants.asm`, and ",
        "`data/sprites/sprites.asm` by `tools/report_map_palettes.py`.",
        "",
        "The eight hardware OBJ palette slots are **red, blue, green, brown, "
        "purple, silver, tree, and rock**. In this project, the old pink slot "
        "is the purple slot. The Dance Theatre locally turns its rock slot into "
        "pink; it is marked `pink* (rock slot)` below.",
        "",
        "- **Used by objects** includes explicit object palettes and sprite defaults.",
        "- **Object-unused** is a literal static-map result. It does not guarantee "
        "that an engine effect will never use the slot.",
        "- **Best candidates** removes red, blue, and purple (possible player "
        "palettes) and silver (shadows, emotes, weather, and other temporary effects).",
        "- Before reusing **tree**, check for grass/tree effects. Before reusing "
        "**rock**, check for rocks, Strength boulders, and boulder dust.",
        "- A map-specific replacement changes the slot's color for every object or "
        "effect using that slot on that map.",
        "",
        f"Maps listed: **{len(map_names)}**.",
        "",
        "| Map | Objects | Used by objects | Object-unused | Best candidates |",
        "|---|---:|---|---|---|",
        *rows,
    ]

    if dynamic_maps:
        lines.extend(
            [
                "",
                "## Conservative dynamic-sprite entries",
                "",
                "For these maps, one or more zero-override sprite identifiers could "
                "not be resolved as a fixed normal NPC sprite. The report conservatively "
                "marks red, blue, green, brown, and purple as used for those entries.",
                "",
            ]
        )
        for map_name, dynamic in dynamic_maps:
            lines.append(f"- `{map_name}`: {', '.join(f'`{item}`' for item in dynamic)}")

    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    print(build_report(), end="")
