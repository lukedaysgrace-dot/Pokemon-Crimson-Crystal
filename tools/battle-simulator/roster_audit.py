"""Reproducible, real-ROM roster search and held-out singles tier audit.

Run with the repository's WSL Python. This driver proposes builds and schedules
battles; every outcome comes from lab.engine and the compiled game.
"""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from concurrent.futures import FIRST_COMPLETED, ProcessPoolExecutor, wait
import csv
import hashlib
import json
import math
import multiprocessing
from pathlib import Path
import random
import sqlite3
import sys
import time

from lab.data import PROJECT, canonical, digest, extract, legal_pool, provenance, validate_build
from lab.engine import RomEngine
from lab.policy import candidate_builds, move_score
from lab.store import Store, close_worker, execute_worker, init_worker

OUT = PROJECT / "output/roster-2026-10-23"
SEED = 20261023
STARTERS = {"BULBASAUR", "IVYSAUR", "VENUSAUR", "CHARMANDER", "CHARMELEON", "CHARIZARD",
            "SQUIRTLE", "WARTORTLE", "BLASTOISE", "CHIKORITA", "BAYLEEF", "MEGANIUM",
            "CYNDAQUIL", "QUILAVA", "TYPHLOSION", "TOTODILE", "CROCONAW", "FERALIGATR"}
TRAIN = ["TYRANITAR", "GENGAR", "SNORLAX", "AZUMARILL"]
VALIDATE = ["MEWTWO", "DRAGONITE", "SCIZOR", "ALAKAZAM", "MACHAMP", "QUAGSIRE", "SKARMORY", "NINETALES_ALOLAN",
            "BLISSEY", "TENTACRUEL", "LANTURN", "PARASECT", "MAGCARGO", "LEDIAN", "DELIBIRD", "UNOWN"]


def save(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2), encoding="utf-8")


def eligible(data):
    return [s for s, r in data["species"].items() if r["fully_evolved"]
            and not any(s == x or s.startswith(x + "_") for x in STARTERS)]


def abilities(data, species):
    return list(dict.fromkeys(a for a in data["species"][species]["abilities"] if a != "NO_ABILITY")) or ["NO_ABILITY"]


def proposals(data, species):
    """Six distinct archetypes per ability, with identical proposals across slots."""
    record = data["species"][species]
    stats = record["stats"]
    pool = list(legal_pool(data, species))
    user = {"species": species, "hp": 100, "maxhp": 100, "types": record["types"], "status": 0,
            "stages": [7] * 7, "stats": {"attack": stats["attack"], "defense": stats["defense"],
            "speed": stats["speed"], "spclatk": stats["sp_attack"], "spcldef": stats["sp_defense"]}}
    target = {**user, "species": None, "types": [], "stats": {k: 100 for k in user["stats"]}}
    ranked = sorted(pool, key=lambda m: (-move_score(data, m, user, target), m))
    attacks = [m for m in ranked if data["moves"][m]["category"] != "status"]
    support = [m for m in ranked if m not in attacks]
    def moves(first, rest=attacks):
        return list(dict.fromkeys([m for m in first if m in pool] + rest + ranked))[:4]
    coverage = candidate_builds(data, species, 1, seed=SEED)[0]["moves"]
    stab = [m for m in attacks if data["moves"][m]["type"] in record["types"]]
    main = (stab or attacks or ranked)[0]
    physical = stats["attack"] >= stats["sp_attack"]
    setup = [m for m in ("SHELL_SMASH", "QUIVER_DANCE", "DRAGON_DANCE", "SWORDS_DANCE" if physical else "NASTY_PLOT",
                        "BULK_UP" if physical else "CALM_MIND", "WORK_UP", "HONE_CLAWS", "AGILITY") if m in pool]
    recovery = [m for m in ("RECOVER", "ROOST", "SOFTBOILED", "SLACK_OFF", "SHORE_UP", "SYNTHESIS", "MOONLIGHT", "MORNING_SUN", "REST") if m in pool]
    status = [m for m in ("SPORE", "SLEEP_POWDER", "LOVELY_KISS", "HYPNOSIS", "WILL_O_WISP", "TOXIC", "THUNDER_WAVE", "LEECH_SEED") if m in pool]
    weights = [m for m in ("LOW_KICK", "GRASS_KNOT", "HEAVY_SLAM", "HEAT_CRASH") if m in pool]
    # Counter/Mirror Coat and Transform need explicit proposals: their native
    # effects cannot be ordered by the ordinary power heuristic.
    special = [m for m in ("TRANSFORM", "COUNTER", "MIRROR_COAT", "METAL_BURST", "SPORE", "SHELL_SMASH", "BATON_PASS") if m in pool]
    rng = random.Random(SEED + record["id"])
    wide = rng.sample(attacks[:min(18, len(attacks))], min(4, len(attacks))) if attacks else support[:4]
    templates = [
        ("coverage-orb", coverage, "LIFE_ORB"),
        ("choice-offense", moves([main], [m for m in attacks if data["moves"][m]["category"] == ("physical" if physical else "special")]), "CHOICE_BAND" if physical else "CHOICE_SPECS"),
        ("setup-sustain", moves([main] + setup[:1] + recovery[:1]), "LEFTOVERS"),
        ("status-sustain", moves([main] + status[:1] + recovery[:1] + (["SLEEP_TALK"] if recovery[:1] == ["REST"] and "SLEEP_TALK" in pool else ["PROTECT"] if "PROTECT" in pool else [])), "LEFTOVERS"),
        ("weight-or-special-sash", moves(weights + special[:2]), "FOCUS_SASH"),
        ("alternative-control", moves(wide), "NO_ITEM"),
    ]
    answer = []
    seen = set()
    for ability in abilities(data, species):
        for label, move_list, item in templates:
            if label == "choice-offense" and ability in {"HUGE_POWER", "GUTS", "HUSTLE"}:
                physical_moves = [m for m in attacks if data["moves"][m]["category"] == "physical"]
                physical_stab = [m for m in physical_moves if data["moves"][m]["type"] in record["types"]]
                move_list = moves(physical_stab[:1], physical_moves)
                item = "CHOICE_BAND"
            # Activate native status synergies rather than inject pre-status.
            if ability in {"GUTS", "QUICK_FEET", "FLARE_BOOST"} and label == "coverage-orb":
                item = "FLAME_ORB"
            if ability == "POISON_HEAL" and label in {"setup-sustain", "status-sustain"}:
                item = "TOXIC_ORB"
            if species in {"MAROWAK", "MAROWAK_ALOLAN"} and label == "choice-offense":
                item = "THICK_CLUB"
            if ability == "SKILL_LINK" and label == "weight-or-special-sash":
                multi = [m for m in attacks if any(x in data["moves"][m]["effect"] for x in ("MULTI_HIT", "DOUBLE_HIT", "TRIPLE_KICK"))]
                move_list = moves(multi)
            build = validate_build(data, {"species": species, "ability": ability, "item": item, "moves": move_list,
                                         "happiness": 0 if "FRUSTRATION" in move_list and "RETURN" not in move_list else 255})
            key = digest(canonical(build).encode())[:16]
            if key not in seen:
                seen.add(key)
                answer.append({"id": key, "archetype": label, "build": build})
    return answer


def run_fast(store, identity, data, jobs):
    """Same workers/receipts as the lab; avoid reparsing a large run per battle."""
    if store.run(identity)["provenance"] != provenance():
        raise ValueError("Source/ROM changed; create a fresh audit directory")
    engine = RomEngine(data)
    engine.close()
    store.pause(identity, False)
    cursor = iter(store.db.execute("SELECT id,spec FROM battles WHERE run_id=? AND status='pending' ORDER BY rowid", (identity,)).fetchall())
    done_count = store.progress(identity)["completed"]
    total = store.progress(identity)["total"]
    started = time.monotonic()
    last_report = last_pause = started
    with ProcessPoolExecutor(max_workers=jobs, mp_context=multiprocessing.get_context("spawn"),
                             initializer=init_worker, initargs=(data, None)) as executor:
        pending, exhausted = {}, False
        while pending or not exhausted:
            now = time.monotonic()
            if now - last_pause > 10:
                exhausted = exhausted or bool(store.db.execute("SELECT paused FROM runs WHERE id=?", (identity,)).fetchone()[0])
                last_pause = now
            while not exhausted and len(pending) < jobs * 2:
                row = next(cursor, None)
                if row is None:
                    exhausted = True
                    break
                pending[executor.submit(execute_worker, json.loads(row["spec"]))] = row["id"]
            if not pending:
                break
            ready, _ = wait(pending, timeout=1, return_when=FIRST_COMPLETED)
            for future in ready:
                key = pending.pop(future)
                store.save(identity, key, future.result())
                done_count += 1
            if now - last_report >= 15 or done_count == total:
                print(f"{identity} {done_count}/{total} elapsed={time.monotonic()-started:.1f}s", flush=True)
                save("progress.json", {"run": identity, "completed": done_count, "total": total,
                                       "elapsed": round(time.monotonic() - started, 1)})
                last_report = now
    print(json.dumps({k: v for k, v in store.progress(identity).items() if k != "config"}), flush=True)


def stage(store, data, name, subjects, opponents, jobs, reps=1, seed=SEED, policies=None, screening=False):
    config = {"name": name, "mode": "cross-pool", "builds": subjects + opponents, "subject_count": len(subjects),
              "seed": seed, "repetitions": reps, "max_turns": 100, "policies": policies or ["tactical", "tactical"]}
    # Explicit subject labels prevent benchmark builds being counted again as
    # subjects when the same species/build occurs in both pools.
    scenarios = []
    for build in subjects:
        key = digest(canonical([build]).encode())[:16]
        for j, opponent in enumerate(opponents):
            for trial in range(reps):
                for swap in ([bool(j % 2)] if screening else [False, True]):
                    player, enemy = (opponent, build) if swap else (build, opponent)
                    side = "enemy" if swap else "player"
                    scenarios.append({"name": f"{name} | subject={key};side={side}", "player": player, "enemy": enemy,
                                      "seed": seed + j * 7919 + trial * 104729, "max_turns": 100,
                                      "policies": config["policies"]})
    config = {"name": name, "mode": "scenarios", "scenarios": scenarios, "seed": seed, "repetitions": 1}
    identity = store.create(data, config)
    print(f"STAGE {name} {identity} total={store.progress(identity)['total']}", flush=True)
    run_fast(store, identity, data, jobs)
    return identity


def summarize(store, identity, subjects):
    """Subjects only; fixed denominator and censored-score bounds, no free wins."""
    known = {digest(canonical([b]).encode())[:16]: b for b in subjects}
    groups = {k: {"id": k, "build": b, "wins": 0, "losses": 0, "draws": 0, "unresolved": 0, "errors": 0,
                  "blocks": defaultdict(list), "opponents": set(), "turns": []} for k, b in known.items()}
    for row in store.results(identity):
        spec, result = row["spec"], row["result"]
        if result is None:
            raise ValueError("pending results cannot produce a tier list")
        for side, other in (("player", "enemy"), ("enemy", "player")):
            key = digest(canonical(spec[side]).encode())[:16]
            if key not in groups or f"subject={key};side={side}" not in spec["name"]:
                continue
            g = groups[key]
            g["opponents"].add(spec[other][0]["species"])
            if result["status"] == "error" or result["failures"]:
                g["errors"] += 1
                continue
            if result["winner"] == "unresolved":
                g["unresolved"] += 1
                continue
            score = .5 if result["winner"] == "draw" else float(result["winner"] == side)
            g["wins" if score == 1 else "draws" if score == .5 else "losses"] += 1
            # Group both orientations and all seeds by opponent. A species is
            # the independent sample unit, not each correlated emulator game.
            g["blocks"][spec[other][0]["species"]].append(score)
            g["turns"].append(result["turns"])
    answer = []
    for g in groups.values():
        n = sum(g[k] for k in ("wins", "losses", "draws", "unresolved", "errors"))
        points = g["wins"] + g["draws"] * .5
        uncertain = g["unresolved"] + g["errors"]
        blocks = [sum(v)/len(v) for v in g["blocks"].values()]
        radius = math.sqrt(math.log(40)/(2*len(blocks))) if blocks else 1
        # These are deliberately broad reference bounds for a fixed selected
        # panel, not a claim of random sampling from competitive team play.
        answer.append({k: v for k, v in g.items() if k not in {"blocks", "opponents", "turns"}} | {
            "games": n, "score_lower": points/n if n else 0, "score_upper": (points+uncertain)/n if n else 1,
            "resolved_score": points/(n-uncertain) if n > uncertain else None,
            "opponents": len(g["opponents"]), "mean_turns": sum(g["turns"])/len(g["turns"]) if g["turns"] else None,
            "opponent_block_reference95": [max(0, (points/n if n else 0)-radius), min(1, ((points+uncertain)/n if n else 1)+radius)]})
    return sorted(answer, key=lambda r: (-r["score_lower"], r["errors"], r["unresolved"], r["build"]["species"], r["id"]))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("phase", choices=["plan", "pilot", "search", "validate", "all"])
    parser.add_argument("--jobs", type=int, default=6)
    parser.add_argument("--db", type=Path, default=Path("/tmp/crimson-crystal-roster-20261023.sqlite")
                        if sys.platform == "linux" else OUT / "battles.sqlite")
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    data = extract()
    roster = eligible(data)
    candidates = [p for s in roster for p in proposals(data, s)]
    if args.phase == "plan":
        save("plan.json", {"eligible": roster, "excluded_terminal": [s for s, r in data["species"].items() if r["fully_evolved"] and s not in roster],
                           "species": len(roster), "ability_variants": sum(len(abilities(data, s)) for s in roster),
                           "candidates": len(candidates), "training_panel": TRAIN, "validation_panel": VALIDATE,
                           "driver_sha256": digest(Path(__file__).read_bytes()), "data_sha256": data["data_sha256"]})
        save("candidates.json", candidates)
        print((OUT / "plan.json").read_text())
        return
    store = Store(args.db)
    try:
        if args.phase == "pilot":
            sample = [proposals(data, s)[0]["build"] for s in roster[::12]][:16]
            stage(store, data, "throughput pilot", sample, [proposals(data, s)[0]["build"] for s in TRAIN], args.jobs)
        if args.phase in {"search", "all"}:
            subjects = [p["build"] for p in candidates]
            identity = stage(store, data, "all abilities and six build archetypes", subjects,
                             [proposals(data, s)[0]["build"] for s in TRAIN], args.jobs, screening=True)
            rows = summarize(store, identity, subjects)
            save("search.json", {"run": identity, "rows": rows})
        if args.phase in {"validate", "all"}:
            search = json.loads((OUT / "search.json").read_text())
            chosen = []
            by_species = defaultdict(list)
            for r in search["rows"]:
                by_species[r["build"]["species"]].append(r)
            for s in roster:
                # Select two materially distinct builds on training data only.
                first = by_species[s][0]
                chosen.append(first["build"])
                alternatives = [r for r in by_species[s][1:] if set(r["build"]["moves"]) != set(first["build"]["moves"])]
                if alternatives:
                    chosen.append(alternatives[0]["build"])
            identity = stage(store, data, "fresh-opponent validation of two builds per species", chosen,
                             [by_species[s][0]["build"] for s in VALIDATE], args.jobs, seed=SEED+10000)
            save("validation.json", {"run": identity, "rows": summarize(store, identity, chosen), "subjects": chosen})
    finally:
        if args.db.resolve() != (OUT / "battles.sqlite").resolve():
            # Never open one live WAL database from Windows and WSL together.
            # Publish a complete SQLite snapshot for read-only report tooling.
            with sqlite3.connect(OUT / "battles-snapshot.sqlite") as snapshot:
                store.db.backup(snapshot)
            (OUT / "battles-snapshot.sqlite").replace(OUT / "battles.sqlite")
        store.close()


if __name__ == "__main__":
    main()
