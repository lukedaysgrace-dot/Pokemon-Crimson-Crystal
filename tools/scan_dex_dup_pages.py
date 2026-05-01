"""Report dex .asm files where page 1 or 2 has duplicate text lines (BRIEF species)."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from dex_brief_text import BRIEF_DEX  # noqa: E402


def main() -> None:
    bad: list[str] = []
    for name in sorted(BRIEF_DEX):
        p = ROOT / "data" / "pokemon" / "dex_entries" / f"{name}.asm"
        t = p.read_text(encoding="utf-8")
        q: list[str] = []
        for ln in t.splitlines():
            s = ln.strip()
            if s.startswith(("db ", "next ", "page ")) and '"' in s:
                q.append(s.split('"', 2)[1].rstrip("@"))
        if len(q) < 7:
            bad.append(f"{name}: not enough quoted fields {q!r}")
            continue
        p1, p2, p3, p4, p5, p6 = q[1:7]
        if len({p1, p2, p3}) < 3 or len({p4, p5, p6}) < 3:
            bad.append(f"{name}: p1=[{p1}|{p2}|{p3}] p2=[{p4}|{p5}|{p6}]")
    if bad:
        print("\n".join(bad))
        sys.exit(1)
    print("ok", len(BRIEF_DEX), "species")


if __name__ == "__main__":
    main()
