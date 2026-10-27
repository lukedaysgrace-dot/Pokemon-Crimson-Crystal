"""No-item, all-ability roster audit using the game's compiled battle engine.

Screen shared moveset portfolios; validate two sets PER ABILITY on disjoint
opponents; select before a complete side-swapped final-roster league.
No public website files are generated or edited.
"""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from concurrent.futures import FIRST_COMPLETED, ProcessPoolExecutor, wait
import csv
from datetime import datetime, timezone
import json
import multiprocessing
from pathlib import Path
import random
import sqlite3
import time

from lab.data import PROJECT, ROOT, canonical, digest, extract, legal_pool, provenance, validate_build
from lab.engine import RomEngine
from lab.policy import move_score
from lab.store import Store, execute_worker, init_worker
from roster_audit import abilities, eligible

OUT = PROJECT / "output/no-items-2026-10-24"
DEST = ROOT / "reports/balance/2026-10-24-no-items"
SEED = 20261024
SCREEN = ["TYRANITAR", "GENGAR", "SNORLAX", "AZUMARILL", "SCIZOR", "ALAKAZAM", "QUAGSIRE", "DRAGONITE"]
VALIDATE = ["MEWTWO", "ARTICUNO", "MACHAMP", "SKARMORY", "NINETALES_ALOLAN", "BLISSEY", "TENTACRUEL", "LANTURN",
            "PARASECT", "MAGCARGO", "LEDIAN", "DELIBIRD", "UNOWN", "CERULEDGE", "HERACROSS", "DRAGAPULT"]
WEIGHTS = {"LOW_KICK", "GRASS_KNOT", "HEAVY_SLAM", "HEAT_CRASH"}
RECOIL = {"EFFECT_RECOIL_HIT", "EFFECT_FLARE_BLITZ", "EFFECT_VOLT_TACKLE", "EFFECT_JUMP_KICK"}
SACRIFICE = {"EXPLOSION", "SELFDESTRUCT", "MISTY_EXPLOSION"}


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=2), encoding="utf-8")
    temporary.replace(path)


def identity(value):
    return digest(canonical(value).encode())[:20]


def proposals(data, species):
    """The UNION of ability-aware portfolios is tested under EVERY ability.

    A slicing or multi-hit proposal therefore cannot be reserved for just its
    favored ability. Setup/sleep openings are ordinary legal native turns.
    """
    s = data["species"][species]
    pool = legal_pool(data, species)
    stats = s["stats"]
    user = {"species": species, "hp": 100, "maxhp": 100, "level": 100, "types": s["types"], "status": 0, "item": "NO_ITEM",
            "stages": [7]*7, "stats": {"attack": stats["attack"], "defense": stats["defense"], "speed": stats["speed"],
                                       "spclatk": stats["sp_attack"], "spcldef": stats["sp_defense"]}}
    target = {**user, "species": None, "types": [], "moves": [], "stats": {k: 100 for k in user["stats"]}}
    ranked = sorted(pool, key=lambda m: (-move_score(data, m, user, target), m))
    attacks = [m for m in ranked if data["moves"][m]["category"] != "status" and m not in SACRIFICE
               and data["moves"][m]["effect"] not in {"EFFECT_COUNTER", "EFFECT_MIRROR_COAT"}]
    safe = [m for m in attacks if data["moves"][m]["effect"] not in RECOIL | {"EFFECT_HYPER_BEAM"}
            and m not in {"SOLARBEAM", "SOLAR_BLADE", "FLY", "SKY_ATTACK", "RAZOR_WIND", "DIG", "DIVE", "BOUNCE"}]

    def coverage(moves):
        first = []
        for m in moves:
            if data["moves"][m]["type"] not in {data["moves"][k]["type"] for k in first}:
                first.append(m)
        return list(dict.fromkeys(first + moves))

    def fill(first, rest=None):
        return list(dict.fromkeys([m for m in first if m in pool] + (coverage(attacks) if rest is None else rest) + ranked))[:4]

    portfolio = []
    seen = set()

    def add(label, first, rest=None, opener=()):
        moves = fill(first, rest)
        if not moves:
            return
        # Ignore move order for identity, but preserve actual script semantics.
        opening_moves = tuple(moves[i-1] for i in opener)
        key = (tuple(sorted(moves)), opening_moves)
        if key not in seen:
            seen.add(key)
            portfolio.append((label, moves, list(opener)))

    add("mixed-coverage", [])
    physical = [m for m in attacks if data["moves"][m]["category"] == "physical"]
    special = [m for m in attacks if data["moves"][m]["category"] == "special"]
    if physical:
        add("physical-coverage", [], coverage(physical))
    if special:
        add("special-coverage", [], coverage(special))
    if safe:
        add("sustainable-attacks", [], coverage(safe))
    stabs = [m for m in attacks if data["moves"][m]["type"] in s["types"]]
    main = (stabs or attacks or ranked)[:1]
    priority = [m for m in attacks if data["moves"][m]["priority"] > 0
                and m not in {"FAKE_OUT", "FIRST_IMPRESSION"}]
    if priority:
        add("priority-finisher", main + priority[:1])
    weights = [m for m in ranked if m in WEIGHTS]
    if weights:
        add("weight-coverage", weights + main)
    counters = [m for m in ("COUNTER", "MIRROR_COAT", "METAL_BURST") if m in pool]
    if counters:
        add("counter-attacks", counters + main)
    recovery = [m for m in ("RECOVER", "ROOST", "SOFTBOILED", "SLACK_OFF", "SHORE_UP", "SYNTHESIS", "MOONLIGHT", "MORNING_SUN") if m in pool]
    status = [m for m in ("SPORE", "SLEEP_POWDER", "LOVELY_KISS", "HYPNOSIS", "WILL_O_WISP", "TOXIC", "THUNDER_WAVE", "LEECH_SEED") if m in pool]
    if recovery:
        add("recovery-control", main + recovery[:1] + status[:1])
    if "REST" in pool and "SLEEP_TALK" in pool:
        add("rest-talk", main + ["REST", "SLEEP_TALK"])
    if status:
        add("status-opening", status[:1] + main + recovery[:1], opener=[1])
    for label, category, setups in (
        ("physical-setup", physical, ("SHELL_SMASH", "DRAGON_DANCE", "SWORDS_DANCE", "BULK_UP", "HONE_CLAWS")),
        ("special-setup", special, ("SHELL_SMASH", "QUIVER_DANCE", "NASTY_PLOT", "CALM_MIND"))):
        setup = next((m for m in setups if m in pool), None)
        if setup and category:
            add(label, [setup], coverage(category), opener=[1])
    # These movesets are shared across ALL source ability slots, even when a
    # specific ability supplied the reason to propose them.
    for ability in abilities(data, species):
        aware_user = {**user, "ability": ability}
        entry_weather = {"DRIZZLE": "WEATHER_RAIN", "DROUGHT": "WEATHER_SUN", "SNOW_WARNING": "WEATHER_HAIL"}.get(ability)
        if entry_weather:
            aware_user["weather"] = data["weather_ids"][entry_weather]
        aware = sorted(attacks, key=lambda m: (-move_score(data, m, aware_user, target), m))
        add("ability-aware-coverage", [], coverage(aware))
        trait = {"SHARPNESS": "slice", "IRON_FIST": "punch", "MEGA_LAUNCHER": "pulse", "STRONG_JAW": "bite"}.get(ability)
        boosted = [m for m in aware if trait and trait in data["moves"][m].get("traits", [])]
        if ability == "SKILL_LINK":
            boosted = [m for m in aware if data["moves"][m]["effect"] == "EFFECT_MULTI_HIT"]
        if ability in {"HUGE_POWER", "HUSTLE", "GUTS"}:
            boosted = physical
        if boosted:
            add("ability-specialist", boosted[:2], coverage(aware))
    # Broad alternatives expose weaknesses and reduce dependence on a single
    # power heuristic. Fixed local seed, identical portfolio across abilities.
    rng = random.Random(SEED + s["id"])
    if len(attacks) > 4:
        for n in range(2):
            add(f"alternative-{n+1}", rng.sample(attacks[:min(24, len(attacks))], min(4, len(attacks))))
    if species == "CERULEDGE":
        add("ceruledge-slicing", ["BITTER_BLADE", "SHADOW_CLAW", "SACRED_SWORD", "SWORDS_DANCE"])
        add("ceruledge-slicing-setup", ["SWORDS_DANCE", "BITTER_BLADE", "SHADOW_CLAW", "SACRED_SWORD"], opener=[1])
    if species == "SMEARGLE":
        add("smeargle-sleep-smash", ["SPORE", "SHELL_SMASH", "ROCK_BLAST", "BULLET_SEED"], opener=[1, 2])
        add("smeargle-sleep-quiver", ["SPORE", "QUIVER_DANCE", "SHADOW_BALL", "FLAMETHROWER"], opener=[1, 2])
    answer = []
    for ability in abilities(data, species):
        for label, moves, opener in portfolio:
            build = validate_build(data, {"species": species, "ability": ability, "item": "NO_ITEM", "moves": moves,
                                         "happiness": 0 if "FRUSTRATION" in moves and "RETURN" not in moves else 255})
            payload = {"build": build, "opener": opener}
            answer.append({"id": identity(payload), "archetype": label, **payload})
    return answer


def guard_no_items(scenarios):
    for spec in scenarios:
        for side in ("player", "enemy"):
            builds = spec[side] if isinstance(spec[side], list) else [spec[side]]
            if any(b.get("item") != "NO_ITEM" or set(b) & {"hp", "status_byte", "stages", "substatus"} for b in builds):
                raise ValueError("No-item rankings require explicit NO_ITEM and fresh native states on BOTH sides")


def fixture(a, b, seed, swap=False, name="audit", max_turns=120, policies=None):
    player, enemy = (b, a) if swap else (a, b)
    return {"name": f"{name} | subject_side={'enemy' if swap else 'player'};p={player['id']};e={enemy['id']}",
            "player": player["build"], "enemy": enemy["build"], "seed": seed, "max_turns": max_turns,
            "policies": policies or ["tactical", "tactical"],
            "scripts": {side: candidate["opener"] for side, candidate in (("player", player), ("enemy", enemy)) if candidate["opener"]}}


def execute(store, data, name, scenarios, pool, source):
    guard_no_items(scenarios)
    run = store.create(data, {"name": name, "mode": "scenarios", "scenarios": scenarios, "repetitions": 1})
    if store.run(run)["provenance"] != source:
        raise ValueError("Source/ROM/runtime changed: do not mix versions in this audit")
    total = store.db.execute("SELECT COUNT(*) FROM battles WHERE run_id=?", (run,)).fetchone()[0]
    pending_rows = iter(store.db.execute("SELECT id,spec FROM battles WHERE run_id=? AND status='pending' ORDER BY rowid", (run,)).fetchall())
    completed = store.db.execute("SELECT COUNT(*) FROM battles WHERE run_id=? AND status!='pending'", (run,)).fetchone()[0]
    print(f"STAGE {name} {run} {completed}/{total}", flush=True)
    started = last_report = time.monotonic()
    futures, exhausted = {}, False
    while futures or not exhausted:
        while not exhausted and len(futures) < pool._max_workers * 2:
            row = next(pending_rows, None)
            if row is None:
                exhausted = True
                break
            futures[pool.submit(execute_worker, json.loads(row["spec"]))] = row["id"]
        if not futures:
            break
        ready, _ = wait(futures, timeout=1, return_when=FIRST_COMPLETED)
        for future in ready:
            key = futures.pop(future)
            result = future.result()
            # Do not silently count a harness failure as a loss. Stop promptly;
            # the saved evidence remains available for a targeted diagnosis.
            store.save(run, key, result)
            completed += 1
            if result["status"] == "error" or result["failures"]:
                write(OUT / "failure.json", {"run": run, "battle": key, "result": result})
                raise RuntimeError(f"Native audit failure; see {OUT / 'failure.json'}")
        now = time.monotonic()
        if now - last_report >= 20 or completed == total:
            elapsed = round(now-started, 1)
            counts = dict(store.db.execute("SELECT status,COUNT(*) FROM battles GROUP BY status"))
            receipt = {"stage": name, "run": run, "stage_completed": completed, "stage_total": total,
                       "stage_seconds": elapsed, "database_counts": counts,
                       "updated": datetime.now(timezone.utc).isoformat()}
            write(OUT / "progress.json", receipt)
            print(canonical(receipt), flush=True)
            last_report = now
    return run


def summarize(store, run, candidates, both=False):
    groups = {c["id"]: {"candidate": c, "wins": 0, "losses": 0, "draws": 0, "unresolved": 0,
                         "errors": 0, "games": 0, "opponents": set(), "turns": 0} for c in candidates}
    for row in store.results(run):
        spec, r = row["spec"], row["result"]
        if r is None:
            raise ValueError("Cannot rank pending battles")
        labels = dict(x.split("=", 1) for x in spec["name"].split(" | ")[-1].split(";"))
        for side, label, other in (("player", "p", "enemy"), ("enemy", "e", "player")):
            key = labels[label]
            if key not in groups:
                continue
            # Panel builds are also candidate IDs. Only the explicitly scheduled
            # subject is credited in panel stages (p/e subject encoded below).
            if not both and (side != labels["subject_side"] or not spec["name"].split(" | ")[0].endswith("subject=" + key)):
                continue
            g = groups[key]
            g["games"] += 1
            g["opponents"].add(spec[other][0]["species"])
            g["turns"] += r["turns"]
            if r["status"] == "error" or r["failures"]:
                g["errors"] += 1
            elif r["winner"] == "unresolved":
                g["unresolved"] += 1
            elif r["winner"] == "draw":
                g["draws"] += 1
            elif r["winner"] == side:
                g["wins"] += 1
            else:
                g["losses"] += 1
    rows = []
    for g in groups.values():
        n = g["games"]
        points = g["wins"] + g["draws"]*.5
        rows.append({**g, "opponents": len(g["opponents"]), "mean_turns": g["turns"]/n if n else None,
                     "score": points/n if n else 0, "score_upper": (points+g["unresolved"]+g["errors"])/n if n else 1})
    return sorted(rows, key=lambda r: (-r["score"], r["unresolved"], r["errors"], r["candidate"]["id"]))


def panel_stage(store, data, candidates, opponents, phase, seed, pool, source, swapped=True, chunk_species=12):
    roster = list(dict.fromkeys(c["build"]["species"] for c in candidates))
    rows, runs = [], []
    for offset in range(0, len(roster), chunk_species):
        species = set(roster[offset:offset+chunk_species])
        subjects = [c for c in candidates if c["build"]["species"] in species]
        scenarios = []
        for a in subjects:
            for j, b in enumerate(opponents):
                for swap in ([False, True] if swapped else [bool(j % 2)]):
                    scenarios.append(fixture(a, b, seed+j*7919, swap, name=f"{phase} subject={a['id']}"))
        run = execute(store, data, f"no-items {phase} species {offset+1}-{offset+len(species)}", scenarios, pool, source)
        rows.extend(summarize(store, run, subjects))
        runs.append(run)
        write(OUT / f"{phase}-partial.json", {"runs": runs, "rows": rows})
    rows.sort(key=lambda r: (-r["score"], r["unresolved"], r["errors"], r["candidate"]["id"]))
    answer = {"runs": runs, "rows": rows}
    write(OUT / f"{phase}.json", answer)
    return answer


def finalists_by_ability(rows, roster):
    grouped = defaultdict(list)
    for r in rows:
        b = r["candidate"]["build"]
        grouped[b["species"], b["ability"]].append(r["candidate"])
    selected = []
    for (species, ability), choices in grouped.items():
        selected.append(choices[0])
        first = set(choices[0]["build"]["moves"])
        different = next((c for c in choices[1:] if set(c["build"]["moves"]) != first), None)
        if different:
            selected.append(different)
    if set(c["build"]["species"] for c in selected) != set(roster):
        raise ValueError("Missing eligible species")
    return selected


def select_species(rows):
    best = {}
    for r in rows:
        best.setdefault(r["candidate"]["build"]["species"], r["candidate"])
    return [best[s] for s in sorted(best)]


def csv_file(path, rows):
    if rows:
        with path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)


def flat(row):
    c, b = row["candidate"], row["candidate"]["build"]
    return {"species": b["species"], "ability": b["ability"], "item": b["item"],
            "moves": " / ".join(b["moves"]), "opening": " / ".join(b["moves"][i-1] for i in c["opener"]),
            "archetype": c["archetype"], "score": round(row["score"], 6), "score_upper": round(row["score_upper"], 6),
            **{k: row[k] for k in ("wins", "losses", "draws", "unresolved", "errors", "games", "opponents")},
            "candidate_id": c["id"]}


def publish(store, plan, screen, validation, league, source):
    DEST.mkdir(parents=True, exist_ok=True)
    rows = sorted(league["rows"], key=lambda r: (-r["score"], r["candidate"]["build"]["species"]))
    if {r["candidate"]["build"]["species"] for r in rows} != set(plan["eligible"]):
        raise ValueError("Incomplete roster league")
    if any(r["games"] != 2*(len(rows)-1) for r in rows):
        raise ValueError("Unequal league schedule")
    ranking = []
    previous = None
    for index, r in enumerate(rows, 1):
        if r["score"] != previous:
            rank, previous = index, r["score"]
        tier = next((t for t, minimum in (("S", .875), ("A", .75), ("B", .625), ("C", .5), ("D", .375), ("E", .25)) if r["score"] >= minimum), "F")
        ranking.append({"rank": rank, "tier": tier, **flat(r)})
    counts = dict(store.db.execute("SELECT status,COUNT(*) FROM battles GROUP BY status"))
    flags, uses = [], Counter()
    items = Counter()
    for record in store.db.execute("SELECT run_id,id,status,result FROM battles"):
        r = json.loads(record["result"]) if record["result"] else None
        if not r:
            raise ValueError("Do not publish pending results")
        if r["status"] != "completed" or r["failures"]:
            flags.append({"run": record["run_id"], "battle": record["id"], "status": r["status"], "winner": r["winner"],
                          "failures": r["failures"], "replay_id": r["replay_id"]})
        for state in r["log"]:
            for side in ("player", "enemy"):
                items[state[side]["item"]] += 1
            for event in state.get("actions", []):
                if event["move"] in WEIGHTS:
                    uses[event["move"]] += 1
    if any(k not in {"NO_ITEM", None} and v for k, v in items.items()):
        raise ValueError(f"Unexpected native held item observations: {items}")
    receipt = {"plan": plan, "provenance": source, "counts": counts,
               "ranked_battles": sum(counts.values()), "tier_counts": dict(Counter(r["tier"] for r in ranking)),
               "screening_runs": screen["runs"], "validation_runs": validation["runs"], "league_runs": league["runs"],
               "validated_candidates": len(validation["rows"]), "league_builds": len(rows),
               "native_item_observations": dict(items), "weight_move_attempts": dict(uses),
               "flags": len(flags), "generated": datetime.now(timezone.utc).isoformat()}
    write(DEST / "tier-list.json", ranking)
    csv_file(DEST / "tier-list.csv", ranking)
    for name, stage in (("screened-builds", screen), ("validated-builds", validation)):
        csv_file(DEST / f"{name}.csv", [flat(r) for r in stage["rows"]])
    best_ability = {}
    for r in validation["rows"]:
        b = r["candidate"]["build"]
        best_ability.setdefault((b["species"], b["ability"]), r)
    csv_file(DEST / "ability-best-builds.csv", [flat(r) for r in best_ability.values()])
    contrasts = []
    buckets = defaultdict(list)
    for r in screen["rows"]:
        c, b = r["candidate"], r["candidate"]["build"]
        buckets[b["species"], tuple(b["moves"]), tuple(c["opener"])].append(r)
    for (species, moves, opener), group in buckets.items():
        for i, a in enumerate(group):
            for b in group[i+1:]:
                contrasts.append({"species": species, "moves": " / ".join(moves), "opening_slots": canonical(opener),
                                  "ability_a": a["candidate"]["build"]["ability"], "ability_b": b["candidate"]["build"]["ability"],
                                  "score_a": a["score"], "score_b": b["score"], "games_each": a["games"]})
    csv_file(DEST / "controlled-ability-comparisons.csv", contrasts)
    write(DEST / "receipt.json", receipt)
    write(DEST / "flagged-battles.json", flags)
    (DEST / "audit-driver.py").write_bytes(Path(__file__).read_bytes())
    lines = ["# Crimson Crystal — no-item tier list", "", "Internal development report — October 24, 2026.", "",
             f"**{len(rows)} final-stage/single-stage species/forms; {plan['ability_variants']} legal species/ability variants; "
             f"{plan['candidates']} screened build/strategy variants; {sum(counts.values()):,} native-ROM battles.**", "",
             "Both sides use **NO_ITEM**. Level 100, perfect DVs, zero stat experience, fresh HP/status, native entry effects and weather. "
             "Starter families and all unevolved/middle stages are excluded; legendaries are included.", "",
             "## Method", "",
             "1. Each species gets a shared portfolio of legal coverage, physical, special, recovery, status, priority, weight, "
             "setup, ability-aware and alternative movesets. Every legal ability is tested with the same portfolio. "
             "Setup/status openings are performed as real battle turns; no free boosts or pre-status are injected.",
             "2. Screen against eight varied opponents, alternating player/enemy positions. "
             "Advance two genuinely different movesets **per ability**, wherever the legal pool permits.",
             "3. Validate these on sixteen different opponents, playing **both sides** for 32 games per build. "
             "All abilities retain representation regardless of screening rank. The ability winners CSV contains this pass.",
             "4. Select each species' best validated build before the final league. Every selected build then fights every other "
             f"selected species twice with sides swapped: **{2*(len(rows)-1)} games per Pokémon**. The tier list uses only this league.", "",
             "Move legality and ability slots come from this game's source; damage, move effects, weights and ability effects "
             "execute in the compiled game through PyBoy. Native logs and scenario seeds are retained in the audit database.", "",
             "## Limits", "",
             "This is a measured singles benchmark under automated move selection, not an exhaustive solution of every legal moveset, "
             "perfect play, or a team-building tier list. The final league evaluates one selected build per species. "
             "Ability differences can depend on the moveset and opponent. Ties share rank; alphabetical order within ties has no strength meaning. "
             "Turn limits are unresolved and contribute no wins; score_upper includes their possible points. "
             "S/A/B/C/D/E thresholds are 87.5/75/62.5/50/37.5/25%; F is below 25%.", "",
             f"Native status counts: `{canonical(counts)}`. Flagged records: **{len(flags)}**. "
             f"Weight move attempts: `{canonical(dict(uses))}`.", "",
             "## Ranking", "", "| Rank | Tier | Pokémon | Score | W–L–D | Ability | Moves | Opening |",
             "|---:|:---:|---|---:|---|---|---|---|"]
    for r in ranking:
        lines.append(f"| {r['rank']} | {r['tier']} | {r['species']} | {r['score']:.1%} | {r['wins']}–{r['losses']}–{r['draws']} "
                     f"| {r['ability']} | {r['moves']} | {r['opening'] or 'tactical'} |")
    lines += ["", "## Evidence", "", "- `tier-list.csv` / `tier-list.json`: all ranked species and selected builds.",
              "- `validated-builds.csv`: stronger/weaker finalist sets for every ability.",
              "- `screened-builds.csv`: complete screened portfolios.", "- `ability-best-builds.csv`: best validated set per ability.",
              "- `controlled-ability-comparisons.csv`: identical moves/openings across abilities in screening.",
              "- `receipt.json`: exact ROM/source/runtime hashes, run IDs, counts and native item checks.",
              "- `flagged-battles.json`: unresolved or failed records for investigation.", "",
              "These reports are local development artifacts and are not part of the public website.", ""]
    (DEST / "TIER-LIST.md").write_text("\n".join(lines), encoding="utf-8")
    print(canonical({"report": str(DEST), "counts": counts, "tier_counts": receipt["tier_counts"], "top": ranking[:10]}), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("phase", choices=["plan", "pilot", "all", "report"])
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--db", type=Path, default=Path("/tmp/crimson-no-items-20261024.sqlite"))
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    data = extract()
    candidates = [c for s in eligible(data) for c in proposals(data, s)]
    roster = eligible(data)
    source = provenance()
    plan = {"eligible": roster, "species": len(roster), "ability_variants": sum(len(abilities(data, s)) for s in roster),
            "candidates": len(candidates), "screen_panel": SCREEN, "validation_panel": VALIDATE,
            "seed": SEED, "driver_sha256": digest(Path(__file__).read_bytes()), "data_sha256": data["data_sha256"],
            "item_rule": "NO_ITEM on both sides; no pre-damage, pre-status or pre-boosts"}
    plan_path = OUT / "plan.json"
    if plan_path.exists() and json.loads(plan_path.read_text()) != plan:
        raise ValueError("Audit plan changed: use a fresh output directory/database")
    write(plan_path, plan)
    write(OUT / "candidates.json", candidates)
    if args.phase == "plan":
        print(json.dumps(plan, indent=2))
        return
    # Pin code before workers begin. Keep database entirely in WSL until closed.
    receipt_path = OUT / "source.json"
    if receipt_path.exists() and json.loads(receipt_path.read_text()) != source:
        raise ValueError("Source/ROM changed since the audit was planned")
    write(receipt_path, source)
    store = Store(args.db)
    try:
        if args.phase == "report":
            publish(store, plan, *(json.loads((OUT / f"{p}.json").read_text()) for p in ("screen", "validation", "league")), source)
            return
        RomEngine(data).close()
        with ProcessPoolExecutor(max_workers=args.jobs, mp_context=multiprocessing.get_context("spawn"),
                                 initializer=init_worker, initargs=(data, None)) as pool:
            if args.phase == "pilot":
                sample = [proposals(data, s)[0] for s in roster[::15]][:16]
                scenarios = [fixture(a, proposals(data, s)[0], SEED+j*7919, name=f"pilot subject={a['id']}")
                             for a in sample for j, s in enumerate(SCREEN)]
                execute(store, data, "pilot no-items", scenarios, pool, source)
                return
            screen_path = OUT / "screen.json"
            if screen_path.exists():
                screen = json.loads(screen_path.read_text())
            else:
                opponents = [proposals(data, s)[0] for s in SCREEN]
                screen = panel_stage(store, data, candidates, opponents, "screen", SEED, pool, source, swapped=False)
            finalists = finalists_by_ability(screen["rows"], roster)
            validation_path = OUT / "validation.json"
            if validation_path.exists():
                validation = json.loads(validation_path.read_text())
            else:
                best_screen = {c["build"]["species"]: c for c in reversed(select_species(screen["rows"]))}
                opponents = [best_screen[s] for s in VALIDATE]
                validation = panel_stage(store, data, finalists, opponents, "validation", SEED+1000000, pool, source)
            league_path = OUT / "league.json"
            if league_path.exists():
                league = json.loads(league_path.read_text())
            else:
                selected = select_species(validation["rows"])
                scenarios = []
                for i, a in enumerate(selected):
                    for j, b in enumerate(selected[i+1:], i+1):
                        for swap in (False, True):
                            scenarios.append(fixture(a, b, SEED+2000000+i*104729+j*7919, swap, "final-league"))
                run = execute(store, data, "Complete no-item final-roster league", scenarios, pool, source)
                league = {"runs": [run], "rows": summarize(store, run, selected, both=True)}
                write(league_path, league)
        publish(store, plan, screen, validation, league, source)
    finally:
        # A completed checkpoint is usable from either OS only after backup.
        store.db.execute("PRAGMA wal_checkpoint(TRUNCATE)")
        store.close()


if __name__ == "__main__":
    main()
