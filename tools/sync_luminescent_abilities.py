#!/usr/bin/env python3
"""Sync local Pokemon abilities from Luminescent Platinum game data."""

from __future__ import annotations

import argparse
import json
import os
import re
import unicodedata
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_STATS = ROOT / "data" / "pokemon" / "base_stats"
ABILITY_CONSTANTS = ROOT / "constants" / "ability_constants.asm"
DEFAULT_SOURCE_DIR = Path(os.environ.get("TEMP", ".")) / "codex-luminescent-data"

FORM_SUFFIXES = {
    "alolan": "Alolan",
    "galarian": "Galarian",
    "hisuian": "Hisuian",
    "paldean": "Paldean",
}


def normalize_name(name: str) -> str:
    name = name.replace("\u2640", "f").replace("\u2642", "m")
    name = name.replace("'", "").replace("\u2019", "")
    name = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"[^a-z0-9]+", "", name.lower())


def ability_constant_name(name: str) -> str:
    if name == "\u2014":
        return "NO_ABILITY"
    name = name.replace("\u2019", "")
    name = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"[^A-Z0-9]+", "_", name.upper()).strip("_")


def humanize_stem(stem: str) -> str:
    return " ".join(part.title() for part in stem.split("_") if part)


def candidate_names(stem: str) -> list[str]:
    names = [humanize_stem(stem)]
    parts = stem.split("_")

    if len(parts) > 1 and parts[-1] in FORM_SUFFIXES:
        base = "_".join(parts[:-1])
        names.insert(0, f"{FORM_SUFFIXES[parts[-1]]} {humanize_stem(base)}")

    if len(parts) > 2 and parts[-2] in FORM_SUFFIXES:
        base = "_".join(parts[:-2])
        form = f"{FORM_SUFFIXES[parts[-2]]} {parts[-1].title()} {humanize_stem(base)}"
        names.insert(0, form)

    return names


def read_word(entry: dict) -> str:
    return "".join(part.get("str", "") for part in entry.get("wordDataArray", []))


def load_mon_names(source_dir: Path) -> dict[int, str]:
    data = json.loads((source_dir / "english_ss_monsname.json").read_text(encoding="utf-8-sig"))
    return {entry["arrayIndex"]: read_word(entry) for entry in data["labelDataArray"]}


def load_ability_names(source_dir: Path) -> dict[int, str]:
    data = json.loads((source_dir / "english_ss_tokusei.json").read_text(encoding="utf-8-sig"))
    return {entry["arrayIndex"]: read_word(entry) for entry in data["labelDataArray"]}


def load_lumi_mon_order(source_dir: Path) -> list[str]:
    data = json.loads((source_dir / "LumiMons.json").read_text(encoding="utf-8-sig"))
    return [name for name, entry in data.items() if entry.get("abilities")]


def load_local_abilities() -> set[str]:
    text = ABILITY_CONSTANTS.read_text(encoding="utf-8")
    return set(re.findall(r"^\s*const\s+([A-Z0-9_]+)\b", text, re.M))


def load_personal_abilities(source_dir: Path) -> dict[str, tuple[str, tuple[str, str, str]]]:
    mon_names = load_mon_names(source_dir)
    ability_names = load_ability_names(source_dir)
    lumi_names = load_lumi_mon_order(source_dir)
    personal = json.loads((source_dir / "PersonalTable.json").read_text(encoding="utf-8-sig"))["Personal"]

    by_name: dict[str, tuple[str, tuple[str, str, str]]] = {}
    rows_by_monsno: dict[int, list[dict]] = {}
    for entry in personal:
        rows_by_monsno.setdefault(entry["monsno"], []).append(entry)

    for monsno, rows in rows_by_monsno.items():
        if monsno not in mon_names:
            continue

        base_name = mon_names[monsno]
        normalized_base_name = normalize_name(base_name)
        source_names = [
            name
            for name in lumi_names
            if normalize_name(name) == normalized_base_name
            or normalize_name(name).endswith(normalized_base_name)
        ]
        if not source_names:
            continue
        source_names.sort(key=lambda name: (normalize_name(name) != normalized_base_name, lumi_names.index(name)))

        sorted_rows = sorted(rows, key=lambda entry: (entry["id"] != monsno, entry["id"]))
        for source_name, entry in zip(source_names, sorted_rows):
            ability_ids = (entry["tokusei1"], entry["tokusei2"], entry["tokusei3"])
            ability_constants = tuple(ability_constant_name(ability_names.get(i, "\u2014")) for i in ability_ids)
            by_name[normalize_name(source_name)] = (source_name, ability_constants)

    return by_name


def replace_abilities(text: str, abilities: tuple[str, str, str]) -> str:
    match = re.search(
        r"^\tabilities_for\s+([A-Z0-9_]+)\s*,\s*[A-Z0-9_]+\s*,\s*[A-Z0-9_]+\s*,\s*[A-Z0-9_]+",
        text,
        re.M,
    )
    if not match:
        raise ValueError("missing abilities_for row")
    line = f"\tabilities_for {match.group(1)}, {abilities[0]}, {abilities[1]}, {abilities[2]}"
    return text[: match.start()] + line + text[match.end() :]


def read_local_abilities(text: str) -> tuple[str, str, str] | None:
    match = re.search(
        r"^\tabilities_for\s+[A-Z0-9_]+\s*,\s*([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)",
        text,
        re.M,
    )
    if not match:
        return None
    return match.group(1), match.group(2), match.group(3)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", type=Path, default=DEFAULT_SOURCE_DIR)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    source_abilities = load_personal_abilities(args.source_dir)
    local_ability_constants = load_local_abilities()
    changed: list[tuple[str, tuple[str, str, str], tuple[str, str, str]]] = []
    unchanged: list[str] = []
    skipped_missing_abilities: dict[str, list[str]] = {}
    unmatched: list[str] = []
    unreadable: list[str] = []

    for path in sorted(BASE_STATS.glob("*.asm")):
        source = None
        for candidate in candidate_names(path.stem):
            source = source_abilities.get(normalize_name(candidate))
            if source:
                break

        if not source:
            unmatched.append(path.stem)
            continue

        _source_name, desired = source
        missing = sorted(set(desired) - local_ability_constants)
        if missing:
            skipped_missing_abilities[path.stem] = missing
            continue

        text = path.read_text(encoding="utf-8")
        local = read_local_abilities(text)
        if local is None:
            unreadable.append(path.stem)
            continue
        if local == desired:
            unchanged.append(path.stem)
            continue

        changed.append((path.stem, local, desired))
        if not args.dry_run:
            path.write_text(replace_abilities(text, desired), encoding="utf-8")

    print(f"Source species/forms: {len(source_abilities)}")
    print(f"Changed: {len(changed)}")
    print(f"Already same: {len(unchanged)}")
    print(f"Skipped for missing ability constants: {len(skipped_missing_abilities)}")
    print(f"Unmatched files: {len(unmatched)}")
    if skipped_missing_abilities:
        print("Missing ability constants by file:")
        for stem, missing in skipped_missing_abilities.items():
            print(f"  {stem}: {', '.join(missing)}")
    if unmatched:
        print("Unmatched files:")
        for stem in unmatched:
            print(f"  {stem}")
    if changed:
        print("Changes:")
        for stem, old, new in changed:
            print(f"  {stem}: {old} -> {new}")

    return 1 if unreadable else 0


if __name__ == "__main__":
    raise SystemExit(main())
