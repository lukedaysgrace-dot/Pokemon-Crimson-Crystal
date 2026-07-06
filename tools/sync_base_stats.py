#!/usr/bin/env python3
"""Fetch base stats from pokemondb.net and update Crystal base_stats/*.asm for hack-added species."""

from __future__ import annotations

import re
import sys
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_STATS = ROOT / "data" / "pokemon" / "base_stats"

UA = {"User-Agent": "Mozilla/5.0 (compatible; BaseStatSync/1.0)"}

# Filename stem -> pokemondb slug (same as dex generator)
SLUG_MAP = {
    "porygon_z": "porygon-z",
}

# Not on pokemondb — skip or manual
SKIP = {"mesmeria", "drunsparce", "rypherior"}

# Species inserted after Celebi in base_stats.asm (honchkrow … corviknight)
NEW_SPECIES = [
    "honchkrow",
    "ambipom",
    "annihilape",
    "bagon",
    "drunsparce",
    "electivire",
    "farigiraf",
    "gardevoir",
    "glaceon",
    "gliscor",
    "kirlia",
    "leafeon",
    "lickilicky",
    "magmortar",
    "magnezone",
    "mamoswine",
    "mesmeria",
    "mismagius",
    "porygon_z",
    "ralts",
    "rhyperior",
    "salamence",
    "scolipede",
    "shelgon",
    "tangrowth",
    "togekiss",
    "ursaluna",
    "venipede",
    "weavile",
    "whirlipede",
    "wyrdeer",
    "yanmega",
    "lileep",
    "cradily",
    "armaldo",
    "golett",
    "golurk",
    "duskull",
    "dusclops",
    "dusknoir",
    "timburr",
    "gurdurr",
    "conkeldurr",
    "larvesta",
    "volcarona",
    "deino",
    "zweilous",
    "hydreigon",
    "dreepy",
    "drakloak",
    "dragapult",
    "impidimp",
    "morgrem",
    "grimmsnarl",
    "tinkatink",
    "tinkatuff",
    "tinkaton",
    "frigibax",
    "arctibax",
    "baxcalibur",
    "charcadet",
    "armarouge",
    "ceruledge",
    "sylveon",
    "rookidee",
    "corvisquire",
    "corviknight",
]


def fetch_html(slug: str) -> str:
    req = urllib.request.Request(f"https://pokemondb.net/pokedex/{slug}", headers=UA)
    with urllib.request.urlopen(req, timeout=25) as r:
        return r.read().decode("utf-8", errors="replace")


def parse_base_stats(html: str) -> tuple[int, int, int, int, int, int] | None:
    """
    Return (hp, atk, def, spd, sat, sdf) matching Crystal stat order.
    Pokémondb base stats table: HP, Attack, Defense, Sp. Atk, Sp. Def, Speed
    (first cell-num in each row is the base value).
    """
    start = html.lower().find("<th>hp</th>")
    if start == -1:
        return None
    chunk = html[start : start + 4000]
    rows = re.findall(
        r"<th>\s*([^<]+?)\s*</th>\s*<td class=\"cell-num\">(\d+)</td>",
        chunk,
        re.I,
    )
    stats: dict[str, int] = {}
    for name, val in rows:
        name_clean = re.sub(r"\s+", " ", name.strip())
        stats[name_clean] = int(val)

    keys = ("HP", "Attack", "Defense", "Sp. Atk", "Sp. Def", "Speed")
    if not all(k in stats for k in keys):
        return None
    return (
        stats["HP"],
        stats["Attack"],
        stats["Defense"],
        stats["Speed"],
        stats["Sp. Atk"],
        stats["Sp. Def"],
    )


def update_base_stats_file(path: Path, stats: tuple[int, int, int, int, int, int]) -> bool:
    text = path.read_text(encoding="utf-8")
    hp, atk, de, spd, sat, sdf = stats
    new_line = f"\tdb {hp:3d}, {atk:3d}, {de:3d}, {spd:3d}, {sat:3d}, {sdf:3d}"
    pat = re.compile(
        r"^\tdb\s+\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+",
        re.M,
    )
    if not pat.search(text):
        return False
    new_text, n = pat.subn(new_line, text, count=1)
    if n != 1:
        return False
    path.write_text(new_text, encoding="utf-8")
    return True


def main() -> None:
    changed: list[str] = []
    failed: list[str] = []
    for base in NEW_SPECIES:
        if base in SKIP:
            print(f"skip {base}")
            continue
        slug = SLUG_MAP.get(base, base.replace("_", "-"))
        path = BASE_STATS / f"{base}.asm"
        if not path.exists():
            print(f"missing file {path}", file=sys.stderr)
            failed.append(base)
            continue
        try:
            html = fetch_html(slug)
            s = parse_base_stats(html)
            if not s:
                print(f"parse fail {base} ({slug})", file=sys.stderr)
                failed.append(base)
                continue
            old = path.read_text(encoding="utf-8")
            m = re.search(
                r"^\tdb\s+(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)",
                old,
                re.M,
            )
            if m:
                old_t = tuple(int(m.group(i)) for i in range(1, 7))
            else:
                old_t = None
            if old_t == s:
                print(f"ok   {base} {s}")
            else:
                if update_base_stats_file(path, s):
                    print(f"FIX  {base} {old_t} -> {s}")
                    changed.append(base)
                else:
                    failed.append(base)
        except Exception as e:
            print(f"error {base}: {e}", file=sys.stderr)
            failed.append(base)
        time.sleep(0.3)
    if failed:
        print("Failed:", ", ".join(failed), file=sys.stderr)
        sys.exit(1)
    print("Updated:", len(changed), "files")


if __name__ == "__main__":
    main()
