"""Direct native-ROM round robin among the measured S-tier finalists."""
import argparse
import json
from pathlib import Path
import sqlite3

from lab.data import ROOT, canonical, digest, extract
from lab.report import export_csv, rankings
from lab.store import Store
from roster_audit import OUT, SEED, run_fast

DEST = ROOT / "reports/balance/2026-10-23"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--jobs", type=int, default=8)
    args = parser.parse_args()
    tiers = json.loads((DEST / "tier-list.json").read_text())
    finalists = json.loads((DEST / "validated-builds.json").read_text())["rows"]
    builds = {r["id"]: r["build"] for r in finalists}
    participants = [r for r in tiers if r["tier"] == "S"]
    if len(participants) < 2:
        print("Fewer than two S-tier entries; no elite round robin needed", flush=True)
        return
    receipt = json.loads((DEST / "receipt.json").read_text())
    rom = ROOT / "pokecrystal_debug.gbc"
    if digest(rom.read_bytes()) != receipt["rom_sha256"]:
        raise ValueError("game ROM changed since the broad audit")
    if '"transport": "lab-v2"' not in (ROOT / "tools/battle-simulator/lab/engine.py").read_text():
        raise ValueError("persist the verified PP guard before running the elite league")
    data = extract()
    store = Store("/tmp/crimson-crystal-elite-20261023.sqlite")
    try:
        config = {"name": "S-tier direct head-to-head league", "mode": "round-robin", "builds": [builds[r["build_id"]] for r in participants],
                  "seed": SEED + 20000, "repetitions": 2 if len(participants) <= 16 else 1,
                  "max_turns": 100, "policies": ["tactical", "tactical"]}
        identity = store.create(data, config)
        print(f"ELITE {len(participants)} species / {store.progress(identity)['total']} native battles / {identity}", flush=True)
        run_fast(store, identity, data, args.jobs)
        if store.progress(identity)["counts"].get("pending"):
            raise ValueError("elite league is paused or unfinished")
        rows = rankings(store, identity, "build")
        for r in rows:
            total = r["resolved"] + r["unresolved"] + r["errors"] + r["assertion_failures"]
            points = r["wins"] + .5*r["draws"]
            r["scheduled"] = total
            r["league_score_lower"] = points / total
            r["league_score_upper"] = (points + total - r["resolved"]) / total
        rows.sort(key=lambda r: (-r["league_score_lower"], r["name"]))
        for r in rows:
            r["rank"] = 1 + sum(x["league_score_lower"] > r["league_score_lower"] for x in rows)
        output = {"run": identity, "provenance": store.run(identity)["provenance"], "driver_sha256": digest(Path(__file__).read_bytes()),
                  "participants": [r["species"] for r in participants], "counts": store.progress(identity)["counts"],
                  "battles": store.progress(identity)["total"], "rows": rows}
        (DEST / "elite-league.json").write_text(json.dumps(output, indent=2))
        (DEST / "elite-league.csv").write_text(export_csv(rows))
        lines = ["# S-tier direct head-to-head league", "",
                 f"All {len(participants)} S-tier best tested builds from the broad audit fought every other entrant, "
                 f"with both battle sides and {config['repetitions']} seed pair(s) per matchup: {output['battles']:,} additional native-ROM battles.", "",
                 "These scores are relative to this S-tier field under the same level-100 tactical policy. They do not replace the broad-panel tiers or establish a universal metagame optimum. Ties share a rank; unresolved/error outcomes produce score bounds. The verified player-PP guard is active, and the ROM SHA-256 matches the broad audit.", "",
                 "| Rank | Pokémon/form | League score | W–L–D | Ability | Item | Moves |", "|---:|---|---:|---:|---|---|---|"]
        for r in rows:
            b = r["build"][0]
            score = f"{r['league_score_lower']:.1%}" + (f"–{r['league_score_upper']:.1%}" if r["league_score_upper"] > r["league_score_lower"] else "")
            lines.append(f"| {r['rank']} | {r['name']} | {score} | {r['wins']}–{r['losses']}–{r['draws']} | {b['ability']} | {b['item']} | {' / '.join(b['moves'])} |")
        lines += ["", f"Battle statuses: `{output['counts']}`. Full provenance and build data are in `elite-league.json`; full turn logs remain in `tools/battle-simulator/output/roster-2026-10-23/elite.sqlite`.", ""]
        (DEST / "ELITE-LEAGUE.md").write_text("\n".join(lines), encoding="utf-8")
        print(json.dumps({"report": str(DEST / "ELITE-LEAGUE.md"), "battles": output["battles"], "leaders": [r["name"] for r in rows if r["rank"] == 1]}), flush=True)
    finally:
        target = sqlite3.connect(OUT / "elite-snapshot.sqlite")
        try:
            store.db.backup(target)
        finally:
            target.close()
        (OUT / "elite-snapshot.sqlite").replace(OUT / "elite.sqlite")
        store.close()


if __name__ == "__main__":
    main()
