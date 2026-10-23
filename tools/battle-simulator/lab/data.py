"""Extract authoritative assembly records and validate experiment builds."""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import sys
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from battletest.symbols import Constants, Symbols, _parse_constants, parse_substatus_bits
from audit_learnset_variety import load_sources, load_technical_tutors


def digest(value):
    return hashlib.sha256(value).hexdigest()


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def read(path):
    return (ROOT / path).read_text(encoding="utf-8")


def rows(path, directive):
    return [(n, [a.strip() for a in m[1].split(",")])
            for n, line in enumerate(read(path).splitlines(), 1)
            if (m := re.match(rf"^\s*{directive}\s+(.+)", line.split(";", 1)[0]))]


def names(path, marker=None):
    text = read(path)
    if marker:
        text = text.split(marker, 1)[1]
    return [s.split("@")[0] for s in re.findall(r'^\s*db\s+"([^"]*)"', text, re.M)]


def number(token):
    token = token.strip()
    return int(token[1:], 16) if token.startswith("$") else (
        int(token[1:], 2) if token.startswith("%") else int(token))


def provenance(rom_path=None):
    """Content hashes include working-tree edits, never just the commit name."""
    paths = set()
    for directory in ("constants", "data", "engine", "home", "macros"):
        paths.update((ROOT / directory).rglob("*.asm"))
    paths.update(ROOT.glob("*.asm"))
    paths.update((ROOT / "tools/battletest").glob("*.py"))
    paths.update((ROOT / "tools/battletest/tests").glob("*.yaml"))
    paths.update((PROJECT / "lab").rglob("*.py"))
    paths.add(PROJECT / "simulator.py")
    for name in ("audit_learnset_variety.py", "audit_breeding_moves.py", "attacking_learnsets.py"):
        paths.add(ROOT / "tools" / name)
    manifest = {p.relative_to(ROOT).as_posix(): digest(p.read_bytes()) for p in sorted(paths)}
    try:
        commit = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT,
                                         stderr=subprocess.DEVNULL, timeout=10).decode().strip()
    except (OSError, subprocess.SubprocessError):
        commit = None
    rom_path = Path(rom_path or ROOT / "pokecrystal_debug.gbc")
    try:
        pyboy_version = version("pyboy")
    except PackageNotFoundError:
        pyboy_version = None
    return {"commit": commit, "source_sha256": digest(canonical(manifest).encode()),
            "runtime": {"python": sys.version.split()[0], "pyboy": pyboy_version, "platform": sys.platform},
            "files": manifest, "rom_sha256": digest(rom_path.read_bytes()) if rom_path.exists() else None,
            "symbols_sha256": digest(rom_path.with_suffix(".sym").read_bytes())
            if rom_path.with_suffix(".sym").exists() else None}


def extract():
    con = Constants()
    order, levels, tms, eggs, parents, utility = load_sources()
    technical = load_technical_tutors()
    species_names = names("data/pokemon/names.asm", "PokemonNames::")
    move_names = names("data/moves/names.asm")
    ability_names = names("data/abilities/names.asm")
    item_names = names("data/items/names.asm")
    ability_ids = _parse_constants(ROOT / "constants/ability_constants.asm")
    type_ids = _parse_constants(ROOT / "constants/type_constants.asm")
    effects = _parse_constants(ROOT / "constants/move_effect_constants.asm")
    priorities = {}
    for _, row in rows("data/moves/effects_priorities.asm", "db"):
        if len(row) == 2:
            priorities[row[0]] = int(row[1].replace("BASE_PRIORITY", "1").replace(" ", "").split("+")[-1]) + (1 if "+" in row[1] else 0)
    moves = {}
    for index, (line, row) in enumerate(rows("data/moves/moves.asm", "move"), 1):
        if len(row) != 7:
            raise ValueError(f"moves.asm:{line}: expected seven move fields")
        key = con.moves_by_index[index]
        effect, power, typing, category, accuracy, pp, chance = row
        moves[key] = {"id": index, "name": move_names[index - 1], "effect": effect,
                      "effect_id": effects[effect], "power": number(power), "type": typing,
                      "type_id": type_ids[typing], "category": category.removeprefix("CATEGORIZE_").lower(),
                      "accuracy": number(accuracy), "pp": number(pp), "chance": number(chance),
                      "accuracy_byte": number(accuracy) * 255 // 100,
                      "chance_byte": number(chance) * 255 // 100,
                      "priority": priorities.get(effect, 1) - 1,
                      "source": f"data/moves/moves.asm:{line}"}
    if len(moves) != con.num_attacks:
        raise ValueError("move table and NUM_ATTACKS disagree")
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^"]+)"', read("data/pokemon/base_stats.asm"))
    dex_files = dict(re.findall(r'^(\w+)::\s*INCLUDE "([^"]+)"', read("data/pokemon/dex_entries.asm"), re.M))
    dex_labels = [r[0] for _, r in rows("data/pokemon/dex_entry_pointers.asm", "dba")]
    species = {}
    for key, path in zip(order, files):
        text = read(path)
        stats = re.search(r'^\s*db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)', text, re.M)
        types = re.search(r'\bdb\s+(\w+),\s*(\w+)\s*;\s*type', text)
        abilities = re.search(r'abilities_for\s+(\w+),\s*(\w+),\s*(\w+),\s*(\w+)', text)
        if not stats or not types or not abilities or abilities[1] not in {key, key.removesuffix("_CLONE")}:
            raise ValueError(f"unrecognized base data: {path}")
        idx = con.species_index(key)
        dex_label = dex_labels[idx - 1]
        dex_path = dex_files[dex_label]
        dimensions = rows(dex_path, "dw")[0][1]
        lbs10 = number(dimensions[1])
        weight_hg = max(1, (lbs10 * 29727 + 32768) >> 16)
        tutors = [m for bit, m in enumerate(["SUBSTITUTE", "SLEEP_TALK", "REFLECT", "LIGHT_SCREEN", "THUNDER_WAVE"]) if utility[key] & (1 << bit)]
        species[key] = {"id": idx, "name": species_names[idx - 1],
                        "stats": dict(zip(["hp", "attack", "defense", "speed", "sp_attack", "sp_defense"], map(int, stats.groups()))),
                        "types": list(dict.fromkeys(types.groups())),
                        "abilities": list(abilities.groups()[1:]), "level_moves": levels[key],
                        "tm_moves": tms[key], "egg_moves": eggs[key],
                        "tutor_moves": sorted(set(tutors + technical.get(key, []))),
                        "parents": parents[key], "evolutions": [], "source": path,
                        "weight_hg": weight_hg, "weight_kg": weight_hg / 10,
                        "dex_lbs_x10": lbs10, "weight_source": dex_path, "dex_label": dex_label}
    for child, ps in parents.items():
        for parent in ps:
            species[parent]["evolutions"].append(child)
    # The Blackthorn egg tutor directly teaches the root family's listed egg
    # moves. There is no cross-generation egg-move incompatibility in this ROM.
    for key, record in species.items():
        record["fully_evolved"] = not record["evolutions"]
    items = {"NO_ITEM": {"id": 0, "name": "No item", "held_effect": "HELD_NONE", "parameter": "0", "selectable": True}}
    for index, (line, row) in enumerate(rows("data/items/attributes.asm", "item_attribute"), 1):
        key = con.items_by_id.get(index, item_names[index - 1].replace(" ", "_") + f"_{index}")
        items[key] = {"id": index, "name": item_names[index - 1], "held_effect": row[1],
                      "parameter": row[2], "pocket": row[4], "source": f"data/items/attributes.asm:{line}",
                      "selectable": index in con.items_by_id and row[4] in {"ITEM", "BERRIES"}}
    matchups = {}
    for _, row in rows("data/types/type_matchups.asm", "db"):
        if len(row) == 3:
            matchups[f"{row[0]}/{row[1]}"] = {"SUPER_EFFECTIVE": 2, "NOT_VERY_EFFECTIVE": .5, "NO_EFFECT": 0, "MORE_EFFECTIVE": 1.5}[row[2]]
    result = {"schema": 1, "species": species, "moves": moves, "items": items,
              "abilities": {k: {"id": i, "name": ability_names[i]} for k, i in ability_ids.items()},
              "type_ids": type_ids, "matchups": matchups,
              "legality": "Conservative level/evolution access; TM/HM, utility and Blackthorn egg/technical tutors; no unproven event moves."}
    for key in species:
        species[key]["legal_moves"] = legal_pool(result, key, 100)
        if not set(species[key]["legal_moves"]) <= moves.keys():
            raise ValueError(f"unknown legal move in {key}")
    result["data_sha256"] = digest(canonical(result).encode())
    return result


def legal_pool(data, key, level=100, seen=None):
    record = data["species"][key]
    seen = set() if seen is None else seen
    if key in seen:
        return {}
    seen.add(key)
    pool = {m: [f"{key}: level {lv}"] for lv, m in record["level_moves"] if lv <= level}
    for kind in ("tm_moves", "egg_moves", "tutor_moves"):
        for move in record[kind]:
            pool.setdefault(move, []).append(f"{key}: {kind}")
    for parent in record["parents"]:
        for move, route in legal_pool(data, parent, level, seen.copy()).items():
            pool.setdefault(move, []).extend(route + [f"{parent} -> {key}: evolution"])
    if key == "SMEARGLE":
        # Sketch requires an independently available donor move.
        for donor in data["species"].values():
            available = [m for lv, m in donor["level_moves"] if lv <= level] + donor["tm_moves"] + donor["tutor_moves"] + donor["egg_moves"]
            for move in available:
                if move not in {"SKETCH", "STRUGGLE"}:
                    pool.setdefault(move, [f"Sketch from {donor['name']}"])
    return {m: sorted(set(route)) for m, route in sorted(pool.items())}


def validate_build(data, spec):
    if not isinstance(spec, dict):
        raise ValueError("a build must be an object")
    allowed = {"species", "moves", "ability", "item", "level", "dvs", "happiness", "hidden_power_type", "hp", "status_byte", "stages", "substatus"}
    unknown = spec.keys() - allowed
    if unknown:
        raise ValueError(f"unsupported build fields: {sorted(unknown)}")
    key = str(spec.get("species", "")).upper().replace(" ", "_")
    if key not in data["species"]:
        raise ValueError(f"unknown species: {key}")
    result = {"species": key, "level": 100, "dvs": 65535, "happiness": 255,
              "item": "NO_ITEM", "ability": next((a for a in data["species"][key]["abilities"] if a != "NO_ABILITY"), "NO_ABILITY"), **spec}
    result["species"] = key
    for field in ("ability", "item"):
        result[field] = str(result[field]).upper().replace(" ", "_")
    for field, low, high in (("level", 2, 100), ("dvs", 0, 65535), ("happiness", 0, 255), ("hp", 1, 100), ("status_byte", 0, 127)):
        value = result.get(field, 100 if field == "hp" else 0)
        if type(value) is not int or not low <= value <= high:
            raise ValueError(f"{field} must be {low}..{high}")
    if result["ability"] not in data["species"][key]["abilities"]:
        raise ValueError(f"{key} cannot have {result['ability']}")
    if result["ability"] == "NO_ABILITY" and any(a != "NO_ABILITY" for a in data["species"][key]["abilities"]):
        raise ValueError("an empty ability slot is not a selectable ability")
    if "hidden_power_type" in result and result["hidden_power_type"] not in {"FIGHTING", "FLYING", "POISON", "GROUND", "ROCK", "BUG", "GHOST", "STEEL", "FIRE", "WATER", "GRASS", "ELECTRIC", "PSYCHIC", "ICE", "DRAGON", "DARK", "FAIRY"}:
        raise ValueError("unsupported Hidden Power type")
    item = data["items"].get(result["item"])
    if not item or not item["selectable"]:
        raise ValueError(f"not a holdable item: {result['item']}")
    moves = result.get("moves", [])
    if not isinstance(moves, list) or not 1 <= len(moves) <= 4:
        raise ValueError("supply one to four moves")
    moves = [str(m).upper().replace(" ", "_") for m in moves]
    pool = legal_pool(data, key, result["level"])
    if len(set(moves)) != len(moves) or any(m not in pool for m in moves):
        raise ValueError(f"duplicate or unavailable moves for {key}: {moves}")
    result["moves"] = moves
    stages = result.get("stages", {})
    if not isinstance(stages, dict) or set(stages) - {"atk", "def", "spd", "satk", "sdef", "acc", "eva"} or any(type(x) is not int or not -6 <= x <= 6 for x in stages.values()):
        raise ValueError("stat stages must be named boosts in -6..6")
    SUBSTATUS_BITS = parse_substatus_bits()
    if not isinstance(result.get("substatus", []), list) or any(x not in SUBSTATUS_BITS for x in result.get("substatus", [])):
        raise ValueError("unknown substatus")
    return result


def check_rom_data(data, rom_path):
    """Compare compiled records, rather than trusting a recent file timestamp."""
    sym = Symbols(Path(rom_path).with_suffix(".sym"))
    rom = Path(rom_path).read_bytes()
    def at(name, offset, count):
        bank, address = sym[name]
        start = bank * 0x4000 + (address & 0x3fff) + offset
        return rom[start:start + count]
    mismatches = []
    for key, m in data["moves"].items():
        expected = bytes([m["effect_id"], m["power"], m["type_id"], {"physical": 0, "special": 1, "status": 2}[m["category"]], m["accuracy_byte"], m["pp"], m["chance_byte"]])
        if at("Moves1", (m["id"] - 1) * 7, 7) != expected:
            mismatches.append(f"move {key}")
    for key, s in data["species"].items():
        block, offset = ("BaseData1", s["id"] - 1) if s["id"] <= 151 else ("BaseData2", s["id"] - 152)
        raw = at(block, offset * 32, 32)
        expected_stats = bytes(s["stats"].values())
        expected_types = bytes(data["type_ids"][t] for t in [s["types"][0], s["types"][-1]])
        expected_abilities = bytes(data["abilities"][a]["id"] for a in s["abilities"])
        if raw[1:7] != expected_stats or raw[7:9] != expected_types or raw[18:21] != expected_abilities:
            mismatches.append(f"species {key}")
        dex = at(s["dex_label"], 0, 48)
        weight_offset = dex.index(0x50) + 3
        if int.from_bytes(dex[weight_offset:weight_offset + 2], "little") != s["dex_lbs_x10"]:
            mismatches.append(f"weight {key}")
    if mismatches:
        raise ValueError("Compiled ROM data differs from source; rebuild with make debug: " + ", ".join(mismatches[:12]))
    # Records can agree while a changed assembly mechanic is unbuilt.
    built = Path(rom_path).stat().st_mtime
    stale = [p.relative_to(ROOT).as_posix() for folder in ("engine", "home", "constants", "data", "macros")
             for p in (ROOT / folder).rglob("*.asm") if p.stat().st_mtime > built + 1]
    if stale:
        raise ValueError("Assembly newer than ROM; run make debug: " + ", ".join(stale[:8]))
    return {"compiled_moves": len(data["moves"]), "compiled_species": len(data["species"]), "newer_assembly_files": 0}
