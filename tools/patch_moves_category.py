"""Insert CATEGORIZE_* into each move line in data/moves/moves.asm (run from repo root)."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_categories():
    text = (ROOT / "tools/move_categories.txt").read_text(encoding="utf-8")
    cats = []
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("CATEGORIZE_"):
            cats.append(line)
    if len(cats) != 251:
        raise SystemExit(f"expected 251 categories, got {len(cats)}")
    return cats


def main():
    cats = load_categories()
    path = ROOT / "data/moves/moves.asm"
    lines = path.read_text(encoding="utf-8").splitlines()
    out = []
    i = 0
    for line in lines:
        stripped = line.lstrip()
        if stripped.startswith("move "):
            if i >= len(cats):
                raise SystemExit("too many move lines")
            cat = cats[i]
            i += 1
            if ";" in line:
                code, rest = line.split(";", 1)
                comment = ";" + rest
            else:
                code = line
                comment = ""
            parts = [p.strip() for p in code.split(",")]
            if len(parts) < 6:
                raise SystemExit(f"bad move line: {line!r}")
            # parts: move EFF, power, type, acc, pp, trailing last may have 0
            new_parts = parts[:3] + [cat] + parts[3:]
            # preserve leading tab
            prefix = line[: len(line) - len(line.lstrip())]
            new_line = prefix + ", ".join(new_parts) + comment
            out.append(new_line)
        else:
            out.append(line)
    if i != len(cats):
        raise SystemExit(f"used {i} categories, expected {len(cats)}")
    path.write_text("\n".join(out) + "\n", encoding="utf-8")
    print("patched", path)


if __name__ == "__main__":
    main()
