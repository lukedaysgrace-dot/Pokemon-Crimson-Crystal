#!/usr/bin/env python3
"""Repeat Johto leaders with the player locked to the real Hard Mode caps."""

import json
import statistics
import sys
import csv
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import run_gauntlet as g

CAPS = [("FALKNER", 10), ("BUGSY", 16), ("WHITNEY", 21), ("MORTY", 26),
        ("CHUCK", 35), ("JASMINE", 36), ("PRYCE", 40), ("CLAIR", 45)]
SEEDS = [0x19, 0x43, 0x71, 0xA7, 0xD3]


def main():
    rows = json.loads((HERE / "map_trainers.json").read_text())
    by_key = {(r["class"], r["id_num"]): r for r in rows}
    h = g.runner.Harness(verbose=False)
    h.ensure_fixture()
    trials = []
    for klass, cap in CAPS:
        row = by_key[(klass, 1)]
        for seed in SEEDS:
            result = g.run_one(h, row, cap, seed, tactical_switching=True)
            result["seed"] = seed
            trials.append(result)
            print(f"{klass} cap {cap} vs {row['max_level']}: {result['outcome']} "
                  f"{result['turns']}t {result['faints']}f", flush=True)
    h.pb.stop(save=False)
    summary = []
    for klass, cap in CAPS:
        group = [r for r in trials if r["class"] == klass]
        summary.append({
            "leader": klass, "player_cap": cap,
            "enemy_levels": group[0]["enemy_levels"],
            "wins": sum(r["outcome"] == "win" for r in group), "trials": len(group),
            "median_turns": statistics.median(r["turns"] for r in group),
            "median_faints": statistics.median(r["faints"] for r in group),
        })
    (HERE / "boss_cap_results.json").write_text(json.dumps({"summary": summary, "trials": trials}, indent=2))
    with (HERE / "boss_cap_summary.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=summary[0].keys()); w.writeheader(); w.writerows(summary)
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
