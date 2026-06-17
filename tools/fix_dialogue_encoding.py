#!/usr/bin/env python3
"""Fix UTF-8 mojibake in map dialogue (â€¦ -> proper ellipsis char)."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# UTF-8 ellipsis bytes misread as Latin-1/Windows-1252
FIXES = {
    "â€¦": "…",  # U+2026, charmap $75
}

def fix_file(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    original = text
    for bad, good in FIXES.items():
        text = text.replace(bad, good)
    if text != original:
        path.write_text(text, encoding="utf-8", newline="\n")
        return original.count("â€¦")
    return 0


def main():
    total = 0
    files = 0
    for path in sorted(ROOT.rglob("*.asm")):
        if "maps" not in path.parts:
            continue
        n = fix_file(path)
        if n:
            print(f"  {path.relative_to(ROOT)}: {n} fix(es)")
            total += n
            files += 1
    print(f"\nFixed {total} occurrence(s) in {files} file(s)")


if __name__ == "__main__":
    main()
