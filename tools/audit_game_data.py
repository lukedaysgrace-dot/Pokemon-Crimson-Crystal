#!/usr/bin/env python3
"""Validate species, map, item, encounter, tileset, EZChat, and text data invariants."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent


class Audit:
    def __init__(self) -> None:
        self.checks = 0
        self.errors: list[str] = []
        self.counts: dict[str, int] = {}

    def expect(self, condition: bool, message: str) -> None:
        self.checks += 1
        if not condition:
            self.errors.append(message)

    def count(self, name: str, value: int) -> None:
        self.counts[name] = value

    def finish(self) -> int:
        if self.errors:
            print("GAME DATA AUDIT FAILED")
            for error in self.errors:
                print(f"- {error}")
            print(f"{len(self.errors)} error(s) across {self.checks} checks")
            return 1
        summary = ", ".join(f"{value} {name}" for name, value in self.counts.items())
        print(f"GAME DATA AUDIT PASSED: {summary}")
        print(f"{self.checks} invariant checks")
        return 0


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def source(line: str) -> str:
    return line.split(";", 1)[0].strip()


def args(text: str) -> list[str]:
    return [part.strip() for part in text.split(",")]


def number(token: str) -> int:
    token = token.strip()
    if token.startswith("$"):
        return int(token[1:], 16)
    if token.startswith("%"):
        return int(token[1:], 2)
    return int(token, 10)


def directive_rows(text: str, directive: str) -> list[tuple[int, list[str]]]:
    rows = []
    pattern = re.compile(rf"^\s*{re.escape(directive)}\s+(.+?)(?:\s*;.*)?$")
    for line_number, line in enumerate(text.splitlines(), 1):
        match = pattern.match(line)
        if match:
            rows.append((line_number, args(match.group(1))))
    return rows


def parse_charmap() -> list[str]:
    tokens = []
    for line in read(ROOT / "charmap.asm").splitlines():
        match = re.match(r'^\s*charmap\s+"((?:[^"\\]|\\.)*)"\s*,', line)
        if match:
            token = match.group(1).replace(r'\"', '"').replace(r"\\", "\\")
            if token:
                tokens.append(token)
    return sorted(set(tokens), key=len, reverse=True)


def encoded_length(value: str, tokens: list[str]) -> int | None:
    length = 0
    offset = 0
    while offset < len(value):
        token = next((entry for entry in tokens if value.startswith(entry, offset)), None)
        if token is None:
            return None
        offset += len(token)
        length += 1
    return length


def audit_items(audit: Audit, charmap: list[str]) -> None:
    names_text = read(ROOT / "data/items/names.asm")
    names = []
    for line_number, row in directive_rows(names_text, "db"):
        match = re.fullmatch(r'"(.*)@"', row[0]) if len(row) == 1 else None
        if match:
            names.append((line_number, match.group(1)))

    attributes = [
        (line_number, row)
        for line_number, row in directive_rows(read(ROOT / "data/items/attributes.asm"), "item_attribute")
    ]

    description_text = read(ROOT / "data/items/descriptions.asm")
    description_header = description_text.split("MasterBallDesc:", 1)[0]
    descriptions = directive_rows(description_header, "dw")

    effects_header = read(ROOT / "engine/items/item_effects.asm").split("PokeBallEffect:", 1)[0]
    effects = directive_rows(effects_header, "dw")

    audit.expect(len(names) == 256, f"item name table has {len(names)} rows; expected 256")
    audit.expect(len(attributes) == 256, f"item attribute table has {len(attributes)} rows; expected 256")
    audit.expect(len(descriptions) == 255, f"item description table has {len(descriptions)} rows; expected 255")

    for item_id, (line_number, name) in enumerate(names, 1):
        width = encoded_length(name, charmap)
        audit.expect(width is not None, f"data/items/names.asm:{line_number}: unencodable item name {name!r}")
        if width is not None:
            audit.expect(width <= 12, f"data/items/names.asm:{line_number}: {name!r} exceeds 12 visible bytes")
        if item_id <= 0xC1 and name not in {"TERU-SAMA", "?"}:
            pointer = descriptions[item_id - 1][1][0]
            audit.expect(
                pointer != "QuestionMarkDesc",
                f"item {name} (id ${item_id:02x}) still uses the placeholder description",
            )

    highest_usable = 0
    for item_id, (line_number, row) in enumerate(attributes, 1):
        audit.expect(len(row) == 7, f"data/items/attributes.asm:{line_number}: expected 7 arguments")
        if (
            item_id < 0xC2
            and len(row) == 7
            and (row[5] != "ITEMMENU_NOUSE" or row[6] != "ITEMMENU_NOUSE")
        ):
            highest_usable = item_id
    audit.expect(
        len(effects) >= highest_usable,
        f"ItemEffects has {len(effects)} rows but selectable item ${highest_usable:02x} can index it",
    )

    mart_text = read(ROOT / "data/items/marts.asm")
    mart_lines = mart_text.splitlines()
    mart_labels = [
        (index, match.group(1))
        for index, line in enumerate(mart_lines)
        if (match := re.match(r"^(Mart\w+):", line)) and match.group(1) != "Marts"
    ]
    for label_index, (start, label) in enumerate(mart_labels):
        end = next(
            (
                index
                for index in range(start + 1, len(mart_lines))
                if re.match(r"^[A-Za-z_]\w*(?::|::)", mart_lines[index])
            ),
            len(mart_lines),
        )
        rows = directive_rows("\n".join(mart_lines[start + 1 : end]), "db")
        if not rows:
            audit.errors.append(f"{label}: no inventory rows")
            continue
        try:
            declared = number(rows[0][1][0])
        except (ValueError, IndexError):
            audit.errors.append(f"{label}: invalid declared item count")
            continue
        inventory = [row[1][0] for row in rows[1:] if row[1] and row[1][0] != "-1"]
        terminated = any(row[1] and row[1][0] == "-1" for row in rows[1:])
        audit.expect(len(inventory) == declared, f"{label}: declares {declared} items but has {len(inventory)}")
        audit.expect(terminated, f"{label}: missing -1 terminator")

    fruit_constants = re.findall(
        r"^\s*const\s+(FRUITTREE_\w+)", read(ROOT / "constants/script_constants.asm"), re.MULTILINE
    )
    fruit_rows = directive_rows(read(ROOT / "data/items/fruit_trees.asm"), "db")
    audit.expect(
        len(fruit_rows) == len(fruit_constants),
        f"fruit-tree item table has {len(fruit_rows)} rows for {len(fruit_constants)} constants",
    )
    audit.count("items", len(names))
    audit.count("marts", len(mart_labels))


def audit_abilities(audit: Audit, charmap: list[str]) -> None:
    constants_text = read(ROOT / "constants/ability_constants.asm").split("NUM_ABILITIES", 1)[0]
    constants = re.findall(r"^\s*const\s+(\w+)", constants_text, re.MULTILINE)

    names = []
    for line_number, row in directive_rows(read(ROOT / "data/abilities/names.asm"), "db"):
        match = re.fullmatch(r'"(.*)@"', row[0]) if len(row) == 1 else None
        if match:
            names.append((line_number, match.group(1)))

    description_text = read(ROOT / "data/abilities/descriptions.asm")
    descriptions = directive_rows(description_text.split("NoAbilityDescription:", 1)[0], "dw")
    labels = set(re.findall(r"^(\w+Description)(?::|::)", description_text, re.MULTILINE))
    flag_text = read(ROOT / "data/abilities/flags.asm")
    flags = directive_rows(flag_text, "db")

    audit.expect(len(names) == len(constants), f"{len(names)} ability names for {len(constants)} constants")
    audit.expect(
        len(descriptions) == len(constants),
        f"{len(descriptions)} ability descriptions for {len(constants)} constants",
    )
    audit.expect(len(flags) == len(constants), f"{len(flags)} ability flags for {len(constants)} constants")

    for line_number, name in names:
        width = encoded_length(name, charmap)
        audit.expect(width is not None, f"data/abilities/names.asm:{line_number}: unencodable ability name")
        if width is not None:
            audit.expect(width <= 18, f"data/abilities/names.asm:{line_number}: {name!r} exceeds 18 cells")
    for line_number, row in descriptions:
        if row:
            audit.expect(
                row[0] in labels,
                f"data/abilities/descriptions.asm:{line_number}: missing label {row[0]}",
            )

    flag_comments = []
    for line_number, line in enumerate(flag_text.splitlines(), 1):
        match = re.match(r"\s*db\s+[^;]+;\s*(\w+)", line)
        if match:
            flag_comments.append((line_number, match.group(1)))
    for index, (line_number, comment) in enumerate(flag_comments):
        if index < len(constants):
            audit.expect(
                comment == constants[index],
                f"data/abilities/flags.asm:{line_number}: row says {comment}, expected {constants[index]}",
            )
    audit.count("abilities", len(constants))


def audit_species(audit: Audit) -> None:
    pokemon_header = read(ROOT / "constants/pokemon_constants.asm").split("NUM_POKEMON", 1)[0]
    species = re.findall(r"^\s*const\s+(\w+)", pokemon_header, re.MULTILINE)
    ability_header = read(ROOT / "constants/ability_constants.asm").split("NUM_ABILITIES", 1)[0]
    abilities = set(re.findall(r"^\s*const\s+(\w+)", ability_header, re.MULTILINE))
    # The introductory comments mention TYPES_END before the actual definition,
    # so splitting on that token silently discarded every real type constant.
    type_header = read(ROOT / "constants/type_constants.asm")
    types = set(re.findall(r"^\s*const\s+(\w+)", type_header, re.MULTILINE))
    data_constants = read(ROOT / "constants/pokemon_data_constants.asm")
    genders = set(re.findall(r"^(GENDER_\w+)\s+EQU", data_constants, re.MULTILINE))
    growth_rates = set(re.findall(r"^\s*const\s+(GROWTH_\w+)", data_constants, re.MULTILINE))
    egg_groups = set(re.findall(r"^\s*const\s+(EGG_\w+)", data_constants, re.MULTILINE))

    name_text = read(ROOT / "data/pokemon/names.asm").split("PokemonNames::", 1)[1]
    display_names = [
        match.group(1).rstrip("@")
        for match in re.finditer(r'^\s*db\s+"([^"]+)"', name_text, re.MULTILINE)
    ]
    audit.expect(
        len(display_names) == len(species),
        f"Pokemon name table has {len(display_names)} records for {len(species)} species",
    )

    alpha_order = [
        row[0]
        for _, row in directive_rows(read(ROOT / "data/pokemon/dex_order_alpha.asm"), "dw")
        if len(row) == 1
    ]
    audit.expect(
        len(alpha_order) == len(species),
        f"alphabetical Pokedex order has {len(alpha_order)} records for {len(species)} species",
    )
    audit.expect(
        len(set(alpha_order)) == len(alpha_order),
        "alphabetical Pokedex order contains duplicate species",
    )
    audit.expect(
        set(alpha_order) == set(species),
        "alphabetical Pokedex order is not a one-to-one species permutation",
    )
    if len(display_names) == len(species):
        species_index = {name: index for index, name in enumerate(species)}
        names_by_species = dict(zip(species, display_names))
        expected_alpha = sorted(
            species,
            key=lambda name: (names_by_species[name].casefold(), species_index[name]),
        )
        mismatch = next(
            (
                index
                for index, (actual, expected) in enumerate(zip(alpha_order, expected_alpha), 1)
                if actual != expected
            ),
            None,
        )
        audit.expect(
            alpha_order == expected_alpha,
            "alphabetical Pokedex order differs from displayed-name order"
            + (f" at position {mismatch}" if mismatch is not None else ""),
        )

    footprint_rows = directive_rows(read(ROOT / "gfx/footprints.asm"), "INCBIN")
    audit.expect(
        len(footprint_rows) == len(species),
        f"footprint table has {len(footprint_rows)} records for {len(species)} species",
    )
    for line_number, row in footprint_rows:
        match = re.fullmatch(r'"([^"]+)"', row[0]) if len(row) == 1 else None
        audit.expect(match is not None, f"gfx/footprints.asm:{line_number}: malformed footprint include")
        if match is None:
            continue
        footprint = ROOT / match.group(1)
        audit.expect(footprint.is_file(), f"gfx/footprints.asm:{line_number}: missing {match.group(1)}")
        if footprint.is_file():
            audit.expect(
                footprint.stat().st_size == 32,
                f"gfx/footprints.asm:{line_number}: {match.group(1)} is not a four-tile 1bpp footprint",
            )

    evolution_files = (
        ROOT / "data/pokemon/evos_attacks_kanto.asm",
        ROOT / "data/pokemon/evos_attacks_johto.asm",
        ROOT / "data/pokemon/evos_attacks_clones.asm",
    )
    evolution_text = "\n".join(read(path) for path in evolution_files)
    evolution_pointers = re.findall(
        r"^\s*dw\s+(\w+EvosAttacks)\s*(?:;.*)?$",
        evolution_text,
        re.MULTILINE,
    )
    audit.expect(
        len(evolution_pointers) == len(species),
        f"evolution pointer table has {len(evolution_pointers)} records for {len(species)} species",
    )
    evolution_labels = {
        match.group(1): match.start()
        for match in re.finditer(r"^(\w+EvosAttacks):", evolution_text, re.MULTILINE)
    }
    parents = {name: set() for name in species}
    for source_species, label in zip(species, evolution_pointers):
        audit.expect(label in evolution_labels, f"evolution table points to missing label {label}")
        if label not in evolution_labels:
            continue
        chunk = evolution_text[evolution_labels[label] :]
        terminator = re.search(
            r"^\s*db\s+0\s*;\s*no more evolutions",
            chunk,
            re.MULTILINE,
        )
        audit.expect(terminator is not None, f"{label} has no evolution terminator")
        if terminator is None:
            continue
        evolution_rows = chunk[: terminator.start()]
        for match in re.finditer(
            r"^\s*db+w\s+EVOLVE_\w+\s*,\s*(.+?)(?:\s*;.*)?$",
            evolution_rows,
            re.MULTILINE,
        ):
            target = args(match.group(1))[-1]
            audit.expect(target in parents, f"{label} evolves into unknown species {target}")
            if target in parents:
                parents[target].add(source_species)

    first_stages = [
        row[0]
        for _, row in directive_rows(read(ROOT / "data/pokemon/first_stages.asm"), "dw")
        if len(row) == 1
    ]
    audit.expect(
        len(first_stages) == len(species),
        f"first-stage table has {len(first_stages)} records for {len(species)} species",
    )
    for first_stage in first_stages:
        audit.expect(first_stage in parents, f"first-stage table uses unknown species {first_stage}")

    def evolution_roots(name: str, trail: frozenset[str] = frozenset()) -> set[str]:
        audit.expect(name not in trail, f"evolution graph contains a cycle through {name}")
        if name in trail or not parents[name]:
            return {name}
        roots = set()
        for parent in parents[name]:
            roots.update(evolution_roots(parent, trail | {name}))
        return roots

    # Full Incense is not implemented, so Snorlax breeding intentionally keeps
    # Snorlax as the egg species instead of following its Munchlax pre-evolution.
    first_stage_exceptions = {"SNORLAX": "SNORLAX"}
    for name, first_stage in zip(species, first_stages):
        if name in first_stage_exceptions:
            audit.expect(
                first_stage == first_stage_exceptions[name],
                f"{name} no longer matches its documented breeding exception",
            )
            continue
        roots = evolution_roots(name)
        audit.expect(
            first_stage in roots,
            f"{name} maps to first stage {first_stage}; evolution roots are {sorted(roots)}",
        )

    table_text = read(ROOT / "data/pokemon/base_stats.asm")
    includes = re.findall(r'^INCLUDE\s+"(data/pokemon/base_stats/[^"\r\n]+\.asm)"', table_text, re.MULTILINE)
    audit.expect(
        len(includes) == len(species),
        f"base-stat table has {len(includes)} records for {len(species)} species",
    )

    for index, relative in enumerate(includes):
        expected_species = species[index] if index < len(species) else f"record_{index + 1}"
        path = ROOT / relative
        audit.expect(path.is_file(), f"missing base-stat include {relative}")
        if not path.is_file():
            continue
        text = read(path)

        stat_rows = []
        for line_number, row in directive_rows(text, "db"):
            if len(row) != 6:
                continue
            try:
                values = [number(value) for value in row]
            except ValueError:
                continue
            stat_rows.append((line_number, values))
        audit.expect(len(stat_rows) == 1, f"{relative}: expected one six-stat row, found {len(stat_rows)}")
        if stat_rows:
            line_number, values = stat_rows[0]
            for value in values:
                audit.expect(1 <= value <= 255, f"{relative}:{line_number}: invalid base stat {value}")

        type_match = re.search(r"^\s*db\s+(\w+)\s*,\s*(\w+)\s*;\s*type\b", text, re.MULTILINE)
        audit.expect(type_match is not None, f"{relative}: missing type row")
        if type_match:
            for value in type_match.groups():
                audit.expect(value in types, f"{relative}: unknown type {value}")

        for label, low, allow_zero in (("catch rate", 1, False), ("base exp", 0, True), ("step cycles to hatch", 1, False)):
            match = re.search(rf"^\s*db\s+([^;,]+)\s*;\s*{re.escape(label)}\b", text, re.MULTILINE)
            audit.expect(match is not None, f"{relative}: missing {label}")
            if match:
                try:
                    value = number(match.group(1))
                except ValueError:
                    audit.expect(False, f"{relative}: non-numeric {label} {match.group(1).strip()}")
                else:
                    minimum = 0 if allow_zero else low
                    audit.expect(minimum <= value <= 255, f"{relative}: invalid {label} {value}")

        gender_match = re.search(r"^\s*db\s+(GENDER_\w+)\s*;\s*gender ratio", text, re.MULTILINE)
        audit.expect(gender_match is not None, f"{relative}: missing gender ratio")
        if gender_match:
            audit.expect(gender_match.group(1) in genders, f"{relative}: unknown gender ratio {gender_match.group(1)}")

        ability_match = re.search(r"^\s*abilities_for\s+([^;\r\n]+)", text, re.MULTILINE)
        audit.expect(ability_match is not None, f"{relative}: missing abilities_for row")
        if ability_match:
            row = args(ability_match.group(1))
            audit.expect(len(row) == 4, f"{relative}: abilities_for expects species and three abilities")
            if len(row) == 4:
                declared_species = row[0]
                base_species = expected_species.removesuffix("_CLONE")
                audit.expect(
                    declared_species in {expected_species, base_species},
                    f"{relative}: ability row says {declared_species}, expected {expected_species}",
                )
                for ability in row[1:]:
                    audit.expect(ability in abilities, f"{relative}: unknown ability {ability}")

        growth_match = re.search(r"^\s*db\s+(GROWTH_\w+)\s*;\s*growth rate", text, re.MULTILINE)
        audit.expect(growth_match is not None, f"{relative}: missing growth rate")
        if growth_match:
            audit.expect(growth_match.group(1) in growth_rates, f"{relative}: unknown growth rate {growth_match.group(1)}")

        egg_match = re.search(r"^\s*dn\s+(EGG_\w+)\s*,\s*(EGG_\w+)\s*;\s*egg groups", text, re.MULTILINE)
        audit.expect(egg_match is not None, f"{relative}: missing egg groups")
        if egg_match:
            for group in egg_match.groups():
                audit.expect(group in egg_groups, f"{relative}: unknown egg group {group}")

        audit.expect(
            len(re.findall(r"^\s*tmhm(?:\s|$)", text, re.MULTILINE)) == 1,
            f"{relative}: expected exactly one tmhm row",
        )

    audit.count("species records", len(includes))


def map_definitions(audit: Audit):
    constants = []
    for line_number, line in enumerate(read(ROOT / "constants/map_constants.asm").splitlines(), 1):
        match = re.match(r"\s*map_const\s+(\w+),\s*(\d+),\s*(\d+)", line)
        if match:
            constants.append((match.group(1), int(match.group(2)), int(match.group(3)), line_number))

    maps = []
    for line_number, line in enumerate(read(ROOT / "data/maps/maps.asm").splitlines(), 1):
        match = re.match(r"\s*map\s+(\w+),\s*(TILESET_\w+),", line)
        if match:
            maps.append((match.group(1), match.group(2), line_number))

    attributes = {}
    for line_number, line in enumerate(read(ROOT / "data/maps/attributes.asm").splitlines(), 1):
        match = re.match(r"\s*map_attributes\s+(\w+),\s*(\w+),\s*([^,]+),\s*(.+?)(?:\s*;.*)?$", line)
        if match:
            attributes[match.group(2)] = {
                "name": match.group(1),
                "flags": match.group(4).strip(),
                "line": line_number,
                "connections": [],
            }
            current = match.group(2)
            continue
        match = re.match(r"\s*connection\s+(north|south|west|east),\s*(\w+),\s*(\w+),\s*([^,;]+)", line)
        if match and "current" in locals():
            attributes[current]["connections"].append(
                (match.group(1), match.group(2), match.group(3), match.group(4).strip(), line_number)
            )

    audit.expect(len(constants) == len(maps), f"{len(constants)} map constants but {len(maps)} map headers")
    audit.expect(len(constants) == len(attributes), f"{len(constants)} map constants but {len(attributes)} attributes")

    result = {}
    for index, (constant, width, height, line_number) in enumerate(constants):
        audit.expect(constant in attributes, f"map {constant} has no map_attributes row")
        if constant not in attributes or index >= len(maps):
            continue
        map_name, tileset, map_line = maps[index]
        attr = attributes[constant]
        audit.expect(
            map_name == attr["name"],
            f"data/maps/maps.asm:{map_line}: {map_name} is out of order; expected {attr['name']} for {constant}",
        )
        result[constant] = {
            "name": attr["name"],
            "width": width,
            "height": height,
            "tileset": tileset,
            "flags": attr["flags"],
            "connections": attr["connections"],
        }
    return result


def parse_map_events(audit: Audit, maps: dict[str, dict]) -> dict[str, int]:
    counts = {}
    warp_rows = {}
    object_exceptions = {
        ("GoldenrodPokecenter1F", 16, 8): "hidden GS Ball receptionist staging position",
    }
    macro_names = {
        "warp": "warp_event",
        "coord": "coord_event",
        "bg": "bg_event",
        "object": "object_event",
    }

    for constant, info in maps.items():
        path = ROOT / "maps" / f"{info['name']}.asm"
        audit.expect(path.is_file(), f"missing map event file {path.relative_to(ROOT)}")
        if not path.is_file():
            continue
        text = read(path)
        audit.expect(f"{info['name']}_MapEvents:" in text, f"{path.relative_to(ROOT)} has no MapEvents label")
        declarations = {
            match.group(2): int(match.group(1))
            for match in re.finditer(r"^\s*db\s+(\d+)\s*;\s*(warp|coord|bg|object) events\s*$", text, re.MULTILINE)
        }
        for kind, macro in macro_names.items():
            actual = len(re.findall(rf"^\s*{macro}\b", text, re.MULTILINE))
            audit.expect(kind in declarations, f"{path.relative_to(ROOT)}: missing {kind}-event count")
            if kind in declarations:
                audit.expect(
                    actual == declarations[kind],
                    f"{path.relative_to(ROOT)}: declares {declarations[kind]} {kind} events but has {actual}",
                )
        counts[constant] = declarations.get("warp", 0)

        width = info["width"] * 2
        height = info["height"] * 2
        for kind, macro in macro_names.items():
            for line_number, row in directive_rows(text, macro):
                if len(row) < 2:
                    continue
                try:
                    x, y = number(row[0]), number(row[1])
                except ValueError:
                    continue
                allowed = kind == "object" and (info["name"], x, y) in object_exceptions
                audit.expect(
                    allowed or (0 <= x < width and 0 <= y < height),
                    f"{path.relative_to(ROOT)}:{line_number}: {kind} event ({x}, {y}) is outside {width}x{height}",
                )
                if kind == "warp" and len(row) >= 4:
                    warp_rows.setdefault(constant, []).append((line_number, row[2], row[3]))

    for constant, rows in warp_rows.items():
        path = ROOT / "maps" / f"{maps[constant]['name']}.asm"
        for line_number, destination, warp_token in rows:
            audit.expect(destination in maps, f"{path.relative_to(ROOT)}:{line_number}: unknown warp map {destination}")
            try:
                warp_id = number(warp_token)
            except ValueError:
                continue
            if destination in counts and warp_id != -1:
                audit.expect(
                    1 <= warp_id <= counts[destination],
                    f"{path.relative_to(ROOT)}:{line_number}: warp {warp_id} exceeds {destination}'s {counts[destination]} warps",
                )
    return counts


def parse_block_data(audit: Audit, label: str, positions: dict[str, int], lines: list[str]) -> bytes:
    if label not in positions:
        audit.errors.append(f"data/maps/blocks.asm: missing {label}")
        return b""
    data = bytearray()
    started = False
    for line_number in range(positions[label] + 1, len(lines)):
        line = lines[line_number]
        if re.match(r"^[A-Za-z_]\w*(?::|::)", line):
            if started:
                break
            continue
        incbin = re.match(r'^\s*INCBIN\s+"([^"]+)"(?:\s*,\s*([^,;]+)(?:\s*,\s*([^;]+))?)?', line)
        if incbin:
            started = True
            path = ROOT / incbin.group(1)
            if not path.is_file():
                audit.errors.append(f"data/maps/blocks.asm:{line_number + 1}: missing {incbin.group(1)}")
                continue
            blob = path.read_bytes()
            try:
                offset = number(incbin.group(2)) if incbin.group(2) else 0
                length = number(incbin.group(3)) if incbin.group(3) else len(blob) - offset
            except ValueError:
                audit.errors.append(f"data/maps/blocks.asm:{line_number + 1}: non-numeric INCBIN slice")
                continue
            audit.expect(0 <= offset <= len(blob), f"data/maps/blocks.asm:{line_number + 1}: invalid INCBIN offset")
            audit.expect(0 <= length <= len(blob) - offset, f"data/maps/blocks.asm:{line_number + 1}: invalid INCBIN length")
            data.extend(blob[offset : offset + length])
            continue
        db = re.match(r"^\s*db\s+(.+?)(?:\s*;.*)?$", line)
        if db:
            started = True
            for token in args(db.group(1)):
                try:
                    data.append(number(token) & 0xFF)
                except ValueError:
                    audit.errors.append(f"data/maps/blocks.asm:{line_number + 1}: non-numeric block byte {token}")
    return bytes(data)


def tileset_files(audit: Audit):
    constants = []
    for line in read(ROOT / "constants/tileset_constants.asm").split("; bg palette values", 1)[0].splitlines():
        match = re.match(r"\s*const\s+(TILESET_\w+)", line)
        if match:
            constants.append(match.group(1))
    table = re.findall(r"^\s*tileset\s+(Tileset\w+)", read(ROOT / "data/tilesets.asm"), re.MULTILINE)
    audit.expect(len(table) == len(constants) + 1, "tileset pointer table does not match tileset constants")
    prefixes = dict(zip(constants, table[1:]))

    lines = read(ROOT / "gfx/tilesets.asm").splitlines()
    positions = {
        match.group(1): index
        for index, line in enumerate(lines)
        if (match := re.match(r"^(Tileset\w+)(?::|::)", line))
    }

    def find_file(label: str, directive: str) -> Path | None:
        if label not in positions:
            audit.errors.append(f"gfx/tilesets.asm: missing {label}")
            return None
        started = False
        for index in range(positions[label] + 1, len(lines)):
            line = lines[index]
            if re.match(r"^[A-Za-z_]\w*(?::|::)", line):
                if started:
                    break
                continue
            match = re.match(rf'^\s*{directive}\s+"([^"]+)"', line)
            if match:
                return ROOT / match.group(1)
            if source(line):
                started = True
        audit.errors.append(f"gfx/tilesets.asm: {label} has no {directive}")
        return None

    result = {}
    for constant, prefix in prefixes.items():
        meta = find_file(prefix + "Meta", "INCBIN")
        attr = find_file(prefix + "Attr", "INCBIN")
        collision = find_file(prefix + "Coll", "INCLUDE")
        if not meta or not attr or not collision:
            continue
        audit.expect(meta.is_file(), f"missing metatile file {meta.relative_to(ROOT)}")
        audit.expect(attr.is_file(), f"missing attribute file {attr.relative_to(ROOT)}")
        audit.expect(collision.is_file(), f"missing collision file {collision.relative_to(ROOT)}")
        if not (meta.is_file() and attr.is_file() and collision.is_file()):
            continue
        audit.expect(meta.stat().st_size % 16 == 0, f"{meta.relative_to(ROOT)} is not a whole number of metatiles")
        audit.expect(
            attr.stat().st_size == meta.stat().st_size,
            f"{attr.relative_to(ROOT)} length does not match {meta.relative_to(ROOT)}",
        )
        metatiles = meta.stat().st_size // 16
        collision_rows = len(re.findall(r"^\s*tilecoll\b", read(collision), re.MULTILINE))
        audit.expect(
            collision_rows >= metatiles,
            f"{collision.relative_to(ROOT)} has {collision_rows} rows for {metatiles} metatiles",
        )
        result[constant] = (metatiles, meta)
    audit.count("tilesets", len(result))
    return result


def audit_maps(audit: Audit) -> dict[str, dict]:
    maps = map_definitions(audit)
    parse_map_events(audit, maps)
    blocks_lines = read(ROOT / "data/maps/blocks.asm").splitlines()
    positions = {
        match.group(1): index
        for index, line in enumerate(blocks_lines)
        if (match := re.match(r"^(\w+_Blocks)(?::|::)", line))
    }
    tilesets = tileset_files(audit)
    for constant, info in maps.items():
        block_data = parse_block_data(audit, info["name"] + "_Blocks", positions, blocks_lines)
        expected = info["width"] * info["height"]
        audit.expect(
            len(block_data) == expected,
            f"{info['name']} has {len(block_data)} assembled block bytes; expected {expected}",
        )
        if info["tileset"] in tilesets:
            metatiles, meta_path = tilesets[info["tileset"]]
            invalid = [(index, value) for index, value in enumerate(block_data) if value >= metatiles]
            audit.expect(
                not invalid,
                f"{info['name']} uses block ${invalid[0][1]:02x} at offset {invalid[0][0]}, beyond "
                f"{meta_path.name}'s {metatiles} blocks" if invalid else "",
            )

        directions = [row[0] for row in info["connections"]]
        expected_directions = [
            direction.lower()
            for direction in ("NORTH", "SOUTH", "WEST", "EAST")
            if re.search(rf"\b{direction}\b", info["flags"])
        ]
        audit.expect(
            directions == expected_directions,
            f"{info['name']}: connection flags {expected_directions} but rows are {directions}",
        )
        audit.expect(len(directions) == len(set(directions)), f"{info['name']}: duplicate connection direction")
        for direction, target_name, target_constant, offset_token, line_number in info["connections"]:
            audit.expect(target_constant in maps, f"data/maps/attributes.asm:{line_number}: unknown map {target_constant}")
            if target_constant not in maps:
                continue
            target = maps[target_constant]
            audit.expect(
                target_name == target["name"],
                f"data/maps/attributes.asm:{line_number}: target label {target_name} does not match {target['name']}",
            )
            try:
                offset = number(offset_token)
            except ValueError:
                audit.errors.append(f"data/maps/attributes.asm:{line_number}: non-numeric connection offset {offset_token}")
                continue
            source_skip = max(-(offset + 3), 0)
            if direction in {"north", "south"}:
                length = min(info["width"] + 3 - offset, target["width"]) - source_skip
            else:
                length = min(info["height"] + 3 - offset, target["height"]) - source_skip
            audit.expect(length > 0, f"data/maps/attributes.asm:{line_number}: connection has no overlap")

    audit.count("maps", len(maps))
    return maps


def pokemon_constants() -> set[str]:
    header = read(ROOT / "constants/pokemon_constants.asm").split("NUM_POKEMON", 1)[0]
    return set(re.findall(r"^\s*const\s+(\w+)", header, re.MULTILINE))


def audit_wild_table(audit: Audit, path: Path, expected_rows: int, maps: set[str], species: set[str]) -> int:
    text = read(path)
    rows = list(re.finditer(r"^\s*map_id\s+(\w+)", text, re.MULTILINE))
    seen = set()
    for index, match in enumerate(rows):
        map_name = match.group(1)
        audit.expect(map_name in maps, f"{path.relative_to(ROOT)}:{text[:match.start()].count(chr(10)) + 1}: unknown map {map_name}")
        audit.expect(map_name not in seen, f"{path.relative_to(ROOT)}: duplicate map {map_name}")
        seen.add(map_name)
        end = rows[index + 1].start() if index + 1 < len(rows) else len(text)
        entries = directive_rows(text[match.end() : end], "dbw")
        audit.expect(
            len(entries) == expected_rows,
            f"{path.relative_to(ROOT)}: {map_name} has {len(entries)} encounter rows; expected {expected_rows}",
        )
        for line_number, row in entries:
            if len(row) != 2:
                audit.errors.append(f"{path.relative_to(ROOT)}: malformed dbw encounter row")
                continue
            try:
                level = number(row[0])
            except ValueError:
                continue
            audit.expect(1 <= level <= 100, f"{path.relative_to(ROOT)}: {map_name} has invalid level {level}")
            audit.expect(row[1] in species, f"{path.relative_to(ROOT)}: {map_name} uses unknown species {row[1]}")
    audit.expect(re.search(r"^\s*db\s+-1\s*;\s*end", text, re.MULTILINE) is not None, f"{path.relative_to(ROOT)}: missing end sentinel")
    return len(rows)


def audit_encounters(audit: Audit, maps: dict[str, dict]) -> None:
    species = pokemon_constants()
    map_names = set(maps)
    total = 0
    for filename in ("johto_grass.asm", "kanto_grass.asm", "swarm_grass.asm"):
        total += audit_wild_table(audit, ROOT / "data/wild" / filename, 21, map_names, species)
    for filename in ("johto_water.asm", "kanto_water.asm", "swarm_water.asm"):
        total += audit_wild_table(audit, ROOT / "data/wild" / filename, 3, map_names, species)

    fish_text = read(ROOT / "data/wild/fish.asm")
    fish_header = fish_text.split(".Shore_Old:", 1)[0]
    groups = directive_rows(fish_header, "fishgroup")
    fish_constants = re.findall(
        r"^\s*const\s+FISHGROUP_(?!NONE)(\w+)",
        read(ROOT / "constants/map_data_constants.asm"),
        re.MULTILINE,
    )
    audit.expect(len(groups) == len(fish_constants), f"fish table has {len(groups)} groups for {len(fish_constants)} constants")
    time_rows = directive_rows(fish_text.split("TimeFishGroups:", 1)[1], "dbwbw")
    labels = {
        match.group(1): match.start()
        for match in re.finditer(r"^\.(\w+):", fish_text, re.MULTILINE)
    }
    def fish_entries(label: str):
        started = False
        collected = []
        for line in fish_text[labels[label] :].splitlines()[1:]:
            if re.match(r"^\.\w+:", line):
                if started:
                    break
                continue
            match = re.match(r"\s*dbbw\s+(.+?)(?:\s*;.*)?$", line)
            if match:
                started = True
                collected.append((0, args(match.group(1))))
            elif started and source(line):
                break
        return collected

    for _, row in groups:
        audit.expect(len(row) == 4, "fishgroup row does not have chance plus three rod tables")
        for pointer_index, pointer in enumerate(row[1:], 1):
            label = pointer.lstrip(".")
            audit.expect(label in labels, f"fishgroup points to missing .{label}")
            if label not in labels:
                continue
            entries = fish_entries(label)
            expected = 3 if pointer_index == 1 else 4
            audit.expect(len(entries) == expected, f".{label} has {len(entries)} rows; expected {expected}")
            thresholds = []
            for _, entry in entries:
                match = re.match(r"(-?\d+)", entry[0]) if entry else None
                if match:
                    thresholds.append(int(match.group(1)))
                if len(entry) == 3 and entry[2] == "TIME_GROUP":
                    try:
                        time_index = number(entry[1])
                    except ValueError:
                        continue
                    audit.expect(0 <= time_index < len(time_rows), f".{label} uses invalid time-fish group {time_index}")
            audit.expect(thresholds == sorted(thresholds), f".{label} fish thresholds are not monotonic")
            audit.expect(bool(thresholds) and thresholds[-1] == 100, f".{label} fish thresholds do not end at 100%")

    tree_text = read(ROOT / "data/wild/treemons.asm")
    pointer_header = tree_text.split("; Two tables each", 1)[0]
    tree_pointers = directive_rows(pointer_header, "dw")
    tree_constants = re.findall(
        r"^\s*const\s+TREEMON_SET_\w+",
        read(ROOT / "constants/pokemon_data_constants.asm").split("; treemon scores", 1)[0].split("; treemon sets", 1)[1],
        re.MULTILINE,
    )
    audit.expect(
        len(tree_pointers) == len(tree_constants),
        f"TreeMons has {len(tree_pointers)} pointers for {len(tree_constants)} sets",
    )
    tree_sequences = []
    weights = []
    for line in tree_text.splitlines():
        match = re.match(r"\s*dbbw\s+(-?\d+)\s*,", line)
        if match:
            weights.append(int(match.group(1)))
        elif re.match(r"\s*db\s+-1\b", line):
            tree_sequences.append(weights)
            weights = []
    for index, sequence in enumerate(tree_sequences, 1):
        audit.expect(sum(sequence) == 100, f"treemon probability table {index} sums to {sum(sequence)}, not 100")

    contest_rows = directive_rows(read(ROOT / "data/wild/bug_contest_mons.asm"), "dbwbb")
    contest_weight = 0
    found_default = False
    for _, row in contest_rows:
        weight = number(row[0])
        if weight < 0:
            found_default = True
            continue
        contest_weight += weight
        audit.expect(row[1] in species, f"bug contest uses unknown species {row[1]}")
        audit.expect(1 <= number(row[2]) <= number(row[3]) <= 100, f"invalid bug-contest level range {row[2]}-{row[3]}")
    audit.expect(contest_weight == 100, f"bug-contest weights sum to {contest_weight}, not 100")
    audit.expect(found_default, "bug-contest table has no default row")
    audit.count("wild tables", total)


def audit_text_lines(audit: Audit, charmap: list[str]) -> None:
    files = (
        list((ROOT / "maps").glob("*.asm"))
        + list((ROOT / "data/text").rglob("*.asm"))
        + list((ROOT / "data/phone/text").rglob("*.asm"))
        + [
            ROOT / "data/abilities/descriptions.asm",
            ROOT / "data/battle_tower/trainer_text.asm",
        ]
    )
    overflows = []
    checked = 0
    pattern = re.compile(r'^\s*(?:text|line|cont|para|next)\s+"((?:[^"\\]|\\.)*)"')
    for path in files:
        for line_number, line in enumerate(read(path).splitlines(), 1):
            match = pattern.match(line)
            if not match:
                continue
            checked += 1
            width = encoded_length(match.group(1).removesuffix("@"), charmap)
            if width is not None and width > 18:
                overflows.append(f"{path.relative_to(ROOT)}:{line_number} ({width} cells)")

    string_files = [ROOT / "data/items/descriptions.asm"] + list(
        (ROOT / "data/pokemon/dex_entries").glob("*.asm")
    )
    string_pattern = re.compile(r'^\s*(?:db|next)\s+"((?:[^"\\]|\\.)*)"')
    for path in string_files:
        for line_number, line in enumerate(read(path).splitlines(), 1):
            match = string_pattern.match(line)
            if not match:
                continue
            checked += 1
            value = match.group(1)
            if value.endswith("@"):
                value = value[:-1]
            width = encoded_length(value, charmap)
            if width is not None and width > 18:
                overflows.append(f"{path.relative_to(ROOT)}:{line_number} ({width} cells)")
    audit.expect(not overflows, "text lines exceed the 18-cell textbox width: " + ", ".join(overflows[:20]))
    audit.count("text lines", checked)


def audit_ezchat(audit: Audit) -> None:
    pokemon_header = read(ROOT / "constants/pokemon_constants.asm").split("NUM_POKEMON", 1)[0]
    species = re.findall(r"^\s*const\s+(\w+)", pokemon_header, re.MULTILINE)

    order_path = ROOT / "data/pokemon/ezchat_order.asm"
    order_text = read(order_path)
    label_matches = list(re.finditer(r"^\.(\w+):[^\r\n]*", order_text, re.MULTILINE))
    labels = {match.group(1): index for index, match in enumerate(label_matches)}
    pointer_header = order_text[: label_matches[0].start()] if label_matches else order_text
    pointers = [
        row[0].removeprefix(".")
        for _, row in directive_rows(pointer_header, "dw")
        if len(row) == 1 and row[0].startswith(".")
    ]
    audit.expect(bool(label_matches), "EZChat species table has no kana rows")
    audit.expect(len(pointers) == 45, f"EZChat has {len(pointers)} kana pointers; expected 45")
    audit.expect(len(pointers) == len(set(pointers)), "EZChat kana pointer table contains duplicates")
    audit.expect(set(pointers) == set(labels), "EZChat kana pointers and row labels do not match")

    rows: dict[str, list[str]] = {}
    for index, match in enumerate(label_matches):
        end = label_matches[index + 1].start() if index + 1 < len(label_matches) else len(order_text)
        block = order_text[match.start() : end]
        body = re.sub(r"^\.\w+:\s*", "", block, count=1)
        tokens = [token for _, row in directive_rows(body, "dw") for token in row]
        label = match.group(1)
        audit.expect(bool(tokens), f"EZChat .{label} row is empty")
        audit.expect(tokens[-1:] == ["-1"], f"EZChat .{label} row lacks a 16-bit -1 terminator")
        audit.expect("-1" not in tokens[:-1], f"EZChat .{label} row has an early terminator")
        rows[label] = tokens[:-1] if tokens[-1:] == ["-1"] else tokens

    ordered_species = [entry for pointer in pointers for entry in rows.get(pointer, [])]
    audit.expect(
        len(ordered_species) == len(species),
        f"EZChat has {len(ordered_species)} species entries for {len(species)} species",
    )
    audit.expect(
        len(ordered_species) == len(set(ordered_species)),
        "EZChat species order contains duplicate entries",
    )
    audit.expect(
        set(ordered_species) == set(species),
        "EZChat species order is not a one-to-one species permutation",
    )

    fixed_words = read(ROOT / "mobile/fixed_words.asm")
    sorted_words = fixed_words.split("EZChat_SortedWords:", 1)[-1].split(".End", 1)[0]
    capacities = [int(value, 16) for value in re.findall(r"macro_11f23c\s+\$([0-9a-fA-F]+)", sorted_words)]
    audit.expect(
        len(capacities) == len(pointers),
        f"EZChat has {len(capacities)} WRAM row capacities for {len(pointers)} kana rows",
    )
    for pointer, capacity in zip(pointers, capacities):
        row_count = capacity + len(rows.get(pointer, []))
        audit.expect(row_count <= 0xFF, f"EZChat .{pointer} can grow to {row_count} words; 8-bit count overflows")
    total_bytes = 2 * (sum(capacities) + len(ordered_species))
    audit.expect(
        total_bytes <= 0xB00,
        f"EZChat all-seen list needs ${total_bytes:x} bytes; bank-5 $d500-$dfff provides $b00",
    )

    audit.expect("bit 7, d" in fixed_words, "EZChat printer does not recognize tagged 16-bit species words")
    audit.expect(
        "call GetPokemonIDFromIndex" in fixed_words,
        "EZChat printer does not translate true species indexes to runtime IDs",
    )
    audit.expect(
        "call .CheckSeenMonIndex" in fixed_words and "call CheckSeenMonIndex" in fixed_words,
        "EZChat reader does not check the full 16-bit Pokedex seen index",
    )
    audit.expect("or $80" in fixed_words, "EZChat reader does not tag 16-bit species words")
    audit.count("EZChat species", len(ordered_species))


def main() -> int:
    audit = Audit()
    charmap = parse_charmap()
    audit_items(audit, charmap)
    audit_abilities(audit, charmap)
    audit_species(audit)
    maps = audit_maps(audit)
    audit_encounters(audit, maps)
    audit_ezchat(audit)
    audit_text_lines(audit, charmap)
    return audit.finish()


if __name__ == "__main__":
    sys.exit(main())
