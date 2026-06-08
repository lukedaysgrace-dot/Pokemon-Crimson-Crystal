#!/usr/bin/env python3
"""Import Gold/Silver front sprites from pokegold into Supreme Silver."""

import os
import re
import shutil
from pathlib import Path

LIST_FILE = Path("/mnt/c/Users/luked/Desktop/ALL THE SPRITES ME AND KYLE WANT FOR THE GEN 2 GAME.txt")
GOLD_ROOT = Path("/mnt/c/Users/luked/Desktop/pokegold-master/gfx/pokemon")
CRYSTAL_ROOT = Path("/home/luke/romhacks/Pokemon-Supreme-Silver/gfx/pokemon")

DERIVED_SUFFIXES = (
    ".2bpp",
    ".2bpp.lz",
    ".animated.2bpp",
    ".animated.2bpp.lz",
    ".animated.tilemap",
    ".dimensions",
    ".tilemap",
)

NAME_MAP = {
    "nidoran♀": "nidoran_f",
    "nidoran♂": "nidoran_m",
    "mr. mime": "mr__mime",
    "farfetch'd": "farfetch_d",
    "ho-oh": "ho_oh",
}


def normalize_name(name: str) -> str:
    key = name.strip().lower()
    return NAME_MAP.get(key, key.replace(" ", "_").replace(".", ""))


def skip_reason(row: dict) -> str | None:
    notes = row["notes"].lower()
    has_gs = row["gold"] or row["silver"]

    if row["crystal"] and not has_gs:
        return "Crystal only (not in pokegold)"

    if not has_gs:
        if "who gives" in notes:
            return "skipped in list"
        if any(
            p in notes
            for p in (
                "new sprite",
                "new art",
                "use new sprite",
                "look for new sprite",
                "find new artwork",
            )
        ):
            return row["notes"] or "needs new sprite"
        if notes:
            return row["notes"]
        return "no Gold/Silver selection"

    return None


def source_file(folder: Path, version: str) -> Path | None:
    if version == "gold":
        candidates = [folder / "front_gold.png", folder / "front.png"]
    elif version == "silver":
        candidates = [folder / "front_silver.png", folder / "front.png"]
    else:
        return None

    for path in candidates:
        if path.is_file():
            return path
    return None


def clean_derived(dest_dir: Path) -> None:
    for item in dest_dir.iterdir():
        if item.name == "front.png":
            continue
        if item.name in ("back.png", "shiny.pal", "anim.asm", "anim_idle.asm"):
            continue
        if item.name.endswith(DERIVED_SUFFIXES) or item.name in (
            "bitmask.asm",
            "frames.asm",
        ):
            item.unlink(missing_ok=True)


def parse_list(text: str):
    rows = []
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        m = re.match(
            r"^\d{3}\s+(.+?)\s+\[(.)\]\s+\[(.)\]\s+\[(.)\](?:\s+(.*))?$",
            line,
        )
        if not m:
            continue
        name, g, s, c, notes = m.groups()
        rows.append(
            {
                "name": name.strip(),
                "gold": g.upper() == "X",
                "silver": s.upper() == "X",
                "crystal": c.upper() == "X",
                "notes": (notes or "").strip(),
            }
        )
    return rows


def main():
    rows = parse_list(LIST_FILE.read_text(encoding="utf-8"))

    done = []
    skipped = []
    failed = []
    not_done = []

    for row in rows:
        folder = normalize_name(row["name"])
        notes = row["notes"]

        reason = skip_reason(row)
        if reason:
            if row["crystal"] and not (row["gold"] or row["silver"]):
                not_done.append(f"{row['name']} ({reason})")
            else:
                skipped.append(f"{row['name']} ({reason})")
            continue

        version = "gold" if row["gold"] else "silver"
        src_dir = GOLD_ROOT / folder
        dest_dir = CRYSTAL_ROOT / folder

        if not src_dir.is_dir():
            failed.append(f"{row['name']} -> missing pokegold folder '{folder}'")
            continue

        src = source_file(src_dir, version)
        if src is None:
            failed.append(
                f"{row['name']} -> no {version} front sprite in pokegold ({folder})"
            )
            continue

        if not dest_dir.is_dir():
            failed.append(f"{row['name']} -> missing crystal folder '{folder}'")
            continue

        clean_derived(dest_dir)
        shutil.copy2(src, dest_dir / "front.png")
        done.append(f"{row['name']} ({version} from {src.name})")

    print("DONE", len(done))
    for item in done:
        print(f"  + {item}")

    print("\nSKIPPED", len(skipped))
    for item in skipped:
        print(f"  - {item}")

    print("\nFAILED", len(failed))
    for item in failed:
        print(f"  ! {item}")

    print("\nNOT DONE (Crystal-only / no pokegold source)", len(not_done))
    for item in not_done:
        print(f"  ? {item}")

    report = CRYSTAL_ROOT.parent.parent / "sprite_import_report.txt"
    with report.open("w", encoding="utf-8") as f:
        f.write("IMPORTED\n")
        f.write("\n".join(done))
        f.write("\n\nSKIPPED\n")
        f.write("\n".join(skipped))
        f.write("\n\nFAILED\n")
        f.write("\n".join(failed))
        f.write("\n\nNOT DONE\n")
        f.write("\n".join(not_done))
    print(f"\nReport written to {report}")


if __name__ == "__main__":
    main()
