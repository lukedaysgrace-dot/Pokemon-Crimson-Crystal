"""Read-only progress from the WSL-native audit database; no emulator work."""
from collections import Counter, defaultdict
import json
from pathlib import Path
import re
import sqlite3


def main():
    path = Path("/tmp/crimson-crystal-roster-20261023.sqlite")
    db = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
    run = db.execute("SELECT id FROM runs ORDER BY rowid DESC LIMIT 1").fetchone()[0]
    counts = dict(db.execute("SELECT status,count(*) FROM battles WHERE run_id=? GROUP BY status", (run,)))
    rows = db.execute("""SELECT json_extract(spec,'$.name'),json_extract(spec,'$.player[0].species'),
                     json_extract(spec,'$.enemy[0].species'),json_extract(result,'$.winner'),
                     json_array_length(result,'$.failures'),status FROM battles
                     WHERE run_id=? AND result IS NOT NULL""", (run,)).fetchall()
    by_species = Counter()
    flags = 0
    for name, player, enemy, winner, failures, status in rows:
        side = name.rsplit(";side=", 1)[-1]
        if side not in {"player", "enemy"}:
            continue
        by_species[player if side == "player" else enemy] += 1
        flags += int(bool(failures) or status != "completed")
    output = {"run": run, "counts": counts, "completed": len(rows), "flagged": flags,
              "species_started": len(by_species), "recent_species": list(by_species.items())[-5:]}
    print(json.dumps(output))
    db.close()


if __name__ == "__main__":
    main()
