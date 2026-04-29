"""Print CATEGORIZE_* per move id from PokeAPI (matches modern physical/special split)."""
import json
import urllib.request
from pathlib import Path

M = {
    "physical": "CATEGORIZE_PHYSICAL",
    "special": "CATEGORIZE_SPECIAL",
    "status": "CATEGORIZE_STATUS",
}

def main():
    lines = []
    for i in range(1, 252):
        url = f"https://pokeapi.co/api/v2/move/{i}/"
        req = urllib.request.Request(url, headers={"User-Agent": "Pokemon-Supreme-Silver-build/1.0"})
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.loads(r.read())
        dc = d["damage_class"]["name"]
        lines.append(f"\t; {i} {d['name']}")
        lines.append(f"\t{M[dc]}")
    text = "\n".join(lines) + "\n"
    out_path = Path(__file__).resolve().parent / "move_categories.txt"
    out_path.write_text(text, encoding="utf-8")
    print(out_path, "written")


if __name__ == "__main__":
    main()
