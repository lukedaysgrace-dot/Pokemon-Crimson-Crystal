#!/usr/bin/env python3
"""Sync local Pokemon base stats from Luminescent Platinum game data."""

from __future__ import annotations

import argparse
import json
import os
import re
import unicodedata
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_STATS = ROOT / "data" / "pokemon" / "base_stats"
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


def load_luminescent_stats(source_dir: Path) -> dict[str, tuple[str, tuple[int, int, int, int, int, int]]]:
    data_path = source_dir / "LumiMons.json"
    data = json.loads(data_path.read_text(encoding="utf-8-sig"))
    stats_by_normalized_name = {}
    for name, entry in data.items():
        base_stats = entry.get("bs")
        if not base_stats:
            continue
        stats_by_normalized_name[normalize_name(name)] = (
            name,
            (
                int(base_stats["hp"]),
                int(base_stats["at"]),
                int(base_stats["df"]),
                int(base_stats["sp"]),
                int(base_stats["sa"]),
                int(base_stats["sd"]),
            ),
        )
    return stats_by_normalized_name


def read_local_stats(text: str) -> tuple[int, int, int, int, int, int] | None:
    match = re.search(
        r"^\tdb\s+(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)",
        text,
        re.M,
    )
    if not match:
        return None
    return tuple(int(match.group(i)) for i in range(1, 7))


def replace_local_stats(text: str, stats: tuple[int, int, int, int, int, int]) -> str:
    hp, atk, defense, speed, spatk, spdef = stats
    line = f"\tdb {hp:3d}, {atk:3d}, {defense:3d}, {speed:3d}, {spatk:3d}, {spdef:3d}"
    return re.sub(
        r"^\tdb\s+\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+",
        line,
        text,
        count=1,
        flags=re.M,
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", type=Path, default=DEFAULT_SOURCE_DIR)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    source_stats = load_luminescent_stats(args.source_dir)
    matched: list[tuple[str, str]] = []
    changed: list[tuple[str, tuple[int, int, int, int, int, int], tuple[int, int, int, int, int, int]]] = []
    unchanged: list[str] = []
    unmatched: list[str] = []
    unreadable: list[str] = []

    for path in sorted(BASE_STATS.glob("*.asm")):
        source = None
        for candidate in candidate_names(path.stem):
            source = source_stats.get(normalize_name(candidate))
            if source:
                break

        if not source:
            unmatched.append(path.stem)
            continue

        source_name, desired_stats = source
        matched.append((path.stem, source_name))
        text = path.read_text(encoding="utf-8")
        local_stats = read_local_stats(text)
        if local_stats is None:
            unreadable.append(path.stem)
            continue
        if local_stats == desired_stats:
            unchanged.append(path.stem)
            continue

        changed.append((path.stem, local_stats, desired_stats))
        if not args.dry_run:
            path.write_text(replace_local_stats(text, desired_stats), encoding="utf-8")

    print(f"Source species: {len(source_stats)}")
    print(f"Matched local files: {len(matched)}")
    print(f"Changed: {len(changed)}")
    print(f"Already same: {len(unchanged)}")
    print(f"Unmatched: {len(unmatched)}")
    if unreadable:
        print(f"Unreadable stat rows: {', '.join(unreadable)}")
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
