#!/usr/bin/env python3
"""Summarize completed emulator results against the first-encounter route."""

import csv
import argparse
import json
import statistics
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import static_balance_audit as audit


def band(level):
    for hi, name in [(10, "to Falkner"), (16, "to Bugsy"), (21, "to Whitney"),
                     (26, "to Morty"), (35, "to Chuck"), (36, "to Jasmine"),
                     (40, "to Pryce"), (45, "to Clair"), (57, "League"),
                     (70, "early Kanto"), (88, "late Kanto"), (100, "postgame")]:
        if level <= hi:
            return name
    return "other"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default="gauntlet_results.json")
    ap.add_argument("--prefix", default="gauntlet")
    args = ap.parse_args()
    results = json.loads((HERE / args.input).read_text())
    first_keys = {(r["class"], r["id_num"]): r for r in audit.FIRST}
    route = [r for r in results if (r.get("class"), r.get("id_num")) in first_keys]
    # Totodile's deliberately temporary tester learnset contaminates its one
    # unevolved opponent battle, so retain it in the raw log but not balance rates.
    clean = [r for r in route if "TOTODILE" not in r.get("enemy_species", [])]
    summaries = []
    for name in ["to Falkner", "to Bugsy", "to Whitney", "to Morty", "to Chuck",
                 "to Jasmine", "to Pryce", "to Clair", "League", "early Kanto",
                 "late Kanto", "postgame"]:
        group = [r for r in clean if band(max(r.get("enemy_levels", [0]))) == name]
        if not group:
            continue
        finished = [r for r in group if r["outcome"] in {"win", "loss"}]
        summaries.append({
            "segment": name, "battles": len(group),
            "wins": sum(r["outcome"] == "win" for r in finished),
            "losses": sum(r["outcome"] == "loss" for r in finished),
            "timeouts": sum(r["outcome"] == "technical_timeout" for r in group),
            "win_pct": round(100 * sum(r["outcome"] == "win" for r in finished) / len(finished), 1) if finished else None,
            "median_faints_on_wins": statistics.median([r["faints"] for r in finished if r["outcome"] == "win"]) if any(r["outcome"] == "win" for r in finished) else None,
        })
    losses = sorted([r for r in clean if r["outcome"] == "loss"],
                    key=lambda r: (max(r["enemy_levels"]), r["map"], r["class"]))
    timeouts = [r for r in results if r["outcome"] == "technical_timeout"]
    leaders = [r for r in clean if r["class"] in {"FALKNER", "BUGSY", "WHITNEY", "MORTY", "CHUCK", "JASMINE", "PRYCE", "CLAIR", "WILL", "KOGA", "BRUNO", "KAREN", "CHAMPION", "LT_SURGE", "MISTY", "ERIKA", "SABRINA", "JANINE", "BLAINE", "BROCK", "BLUE", "RED"} and r["id_num"] == 1]
    out = {"raw_variants": len(results), "route_first_encounters": len(route),
           "clean_balance_encounters": len(clean), "outcomes": Counter(r["outcome"] for r in clean),
           "segments": summaries, "leaders": leaders, "losses": losses, "technical_timeouts": timeouts}
    (HERE / f"{args.prefix}_summary.json").write_text(json.dumps(out, indent=2))
    with (HERE / f"{args.prefix}_battle_log.csv").open("w", newline="", encoding="utf-8") as f:
        fields = ["index", "map", "class", "id", "name", "enemy_levels", "enemy_species",
                  "player_level", "outcome", "turns", "faints", "state", "detail"]
        w = csv.DictWriter(f, fieldnames=fields); w.writeheader()
        for r in results:
            w.writerow({"index": r.get("index"), "map": r.get("map"), "class": r.get("class"),
                        "id": r.get("id"), "name": r.get("name"),
                        "enemy_levels": "/".join(map(str, r.get("enemy_levels", []))),
                        "enemy_species": "/".join(r.get("enemy_species", [])),
                        "player_level": r.get("player_level"), "outcome": r.get("outcome"),
                        "turns": r.get("turns"), "faints": r.get("faints"),
                        "state": r.get("state"), "detail": r.get("detail", "")})
    with (HERE / f"{args.prefix}_segment_summary.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=summaries[0].keys()); w.writeheader(); w.writerows(summaries)
    print(json.dumps({k: out[k] for k in ("raw_variants", "route_first_encounters", "clean_balance_encounters", "outcomes", "segments")}, indent=2))


if __name__ == "__main__":
    main()
