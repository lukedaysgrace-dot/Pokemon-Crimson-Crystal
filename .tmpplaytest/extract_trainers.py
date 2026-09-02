import csv
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import audit_trainers as at

species_list = at.constant_list("constants/pokemon_constants.asm", "NUM_POKEMON")
moves_list = at.constant_list("constants/move_constants.asm", "NUM_ATTACKS")
items_list = at.constant_list("constants/item_constants.asm", "NUM_ITEMS")
classes, trainer_ids, aliases, owners = at.parse_trainer_constants()
groups = at.parse_parties(set(species_list), set(moves_list), set(items_list))
class_pointer = at.validate_group_pointers(classes, trainer_ids, aliases, owners, groups)

class_num = {name: i for i, name in enumerate(classes)}

def resolve(klass, ident):
    target = aliases.get(klass, {}).get(ident, ident)
    owner = owners.get(target)
    if owner is None:
        return None
    ids = trainer_ids[owner]
    try:
        number = ids.index(target) + 1
    except ValueError:
        return None
    group = class_pointer[klass]
    entries = groups[group]
    if number > len(entries):
        return None
    return number, entries[number - 1]

rows = []
pat_trainer = re.compile(r"\s*(trainer|generictrainer)\s+(\w+)\s*,\s*(\w+)\s*,\s*(\w+)")
pat_load = re.compile(r"\s*loadtrainer\s+(\w+)\s*,\s*(\w+)")
for path in sorted((ROOT / "maps").glob("*.asm")):
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    for lineno, line in enumerate(lines, 1):
        code = line.split(";", 1)[0]
        m = pat_trainer.match(code)
        if m:
            kind, klass, ident, event = m.groups()
        else:
            m = pat_load.match(code)
            if not m:
                continue
            klass, ident = m.groups()
            kind, event = "loadtrainer", ""
            # Associate nearby check/setevent with scripted battles when possible.
            for near in lines[max(0, lineno - 12): min(len(lines), lineno + 12)]:
                em = re.search(r"\b(?:checkevent|setevent)\s+(EVENT_BEAT_\w+)", near)
                if em:
                    event = em.group(1)
                    break
        resolved = resolve(klass, ident)
        if not resolved:
            continue
        number, entry = resolved
        rows.append({
            "map": path.stem, "line": lineno, "kind": kind,
            "class": klass, "class_num": class_num[klass], "id": ident,
            "id_num": number, "event": event, "name": entry.get("name", "?").rstrip("@"),
            "min_level": min(m["level"] for m in entry["mons"]),
            "max_level": max(m["level"] for m in entry["mons"]),
            "mons": entry["mons"],
        })

(ROOT / ".tmpplaytest" / "map_trainers.json").write_text(json.dumps(rows, indent=2))
with (ROOT / ".tmpplaytest" / "map_trainers.csv").open("w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["map", "line", "kind", "class", "id", "event", "name", "levels", "species"])
    for r in rows:
        w.writerow([r["map"], r["line"], r["kind"], r["class"], r["id"], r["event"], r["name"],
                    "/".join(str(m["level"]) for m in r["mons"]),
                    "/".join(m["species"] for m in r["mons"])])

print(f"{len(rows)} map references; {len({(r['class'], r['id']) for r in rows})} unique class/id pairs")
from collections import Counter
print("classes", Counter(r["class"] for r in rows).most_common(20))
print("levels", Counter(r["max_level"] // 5 * 5 for r in rows).most_common())
