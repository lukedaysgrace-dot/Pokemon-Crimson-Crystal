"""Challenge weak rankings with legal non-sacrificial and specialist builds."""
import json
from pathlib import Path
import sqlite3

from lab.data import PROJECT, ROOT, canonical, digest, extract, legal_pool, validate_build
from lab.policy import move_score
from lab.store import Store
from roster_audit import OUT, abilities, run_fast

DEST = ROOT / "reports/balance/2026-10-23"


def main():
    data = extract()
    tiers = json.loads((DEST / "tier-list.json").read_text())
    validation = json.loads((OUT / "validation.json").read_text())
    source = Store(OUT / "battles.sqlite")
    fixtures = source.run(validation["run"])["config"]["scenarios"][:32]
    source.close()
    selected = {r["species"] for r in tiers if any(m in r["moves"].split(" / ") for m in ("EXPLOSION", "SELFDESTRUCT"))} | {"TYRANITAR"}
    already = {r["id"] for r in json.loads((DEST / "validated-builds.json").read_text())["rows"]}
    proposals, seen = [], set()
    def add(species, ability, moves, item, strategy="tactical", opener=None):
        moves = list(dict.fromkeys(moves))[:4]
        build = validate_build(data, {"species": species, "ability": ability, "moves": moves, "item": item,
                                     "happiness": 0 if "FRUSTRATION" in moves and "RETURN" not in moves else 255})
        key = digest(canonical([build]).encode())[:16]
        if key not in already and key not in seen:
            seen.add(key)
            proposals.append({"id": key, "build": build, "strategy": strategy, "opener": opener or []})
    for species in sorted(selected):
        s = data["species"][species]
        pool = legal_pool(data, species)
        for ability in abilities(data, species):
            stats = s["stats"]
            user = {"species": species, "hp": 100, "maxhp": 100, "types": s["types"], "status": 0, "ability": ability,
                    "stages": [7]*7, "stats": {"attack": stats["attack"], "defense": stats["defense"], "speed": stats["speed"],
                    "spclatk": stats["sp_attack"], "spcldef": stats["sp_defense"]}}
            target = {**user, "species": None, "types": [], "stats": {k: 100 for k in user["stats"]}}
            attacks = [m for m in pool if data["moves"][m]["category"] != "status"
                       and data["moves"][m]["effect"] not in {"EFFECT_SELFDESTRUCT", "EFFECT_EXPLOSION"}]
            attacks.sort(key=lambda m: (-move_score(data, m, user, target), m))
            coverage = []
            for m in attacks:
                if data["moves"][m]["type"] not in {data["moves"][k]["type"] for k in coverage}:
                    coverage.append(m)
            coverage = list(dict.fromkeys(coverage + attacks))[:4]
            add(species, ability, coverage, "LIFE_ORB")
            counters = [m for m in ("COUNTER", "MIRROR_COAT") if m in pool]
            add(species, ability, counters + coverage, "FOCUS_SASH")
            if species == "TYRANITAR":
                add(species, ability, ["COUNTER", "STONE_EDGE", "CRUNCH", "IRON_HEAD"], "FOCUS_SASH")
                add(species, ability, ["STONE_EDGE", "CRUNCH", "IRON_HEAD", "LOW_KICK"], "CHOICE_SCARF")
            if species == "SMEARGLE":
                for item in ("FOCUS_SASH", "LOADED_DICE"):
                    add(species, ability, ["SPORE", "SHELL_SMASH", "ROCK_BLAST", "BULLET_SEED"], item,
                        "scripted Spore → Shell Smash, then tactical", [1, 2])
                add(species, ability, ["SPORE", "QUIVER_DANCE", "SHADOW_BALL", "FLAMETHROWER"], "FOCUS_SASH",
                    "scripted Spore → Quiver Dance twice, then tactical", [1, 2, 2])
    scenarios = []
    for proposal in proposals:
        for fixture in fixtures:
            side = fixture["name"].rsplit(";side=", 1)[-1]
            scenarios.append({**fixture, side: [proposal["build"]],
                              "scripts": {side: proposal["opener"]} if proposal["opener"] else {},
                              "name": f"outlier refinement | subject={proposal['id']};side={side}"})
    store = Store("/tmp/crimson-crystal-refinements-20261023.sqlite")
    try:
        identity = store.create(data, {"name": "Non-sacrificial and specialist outlier builds", "mode": "scenarios", "scenarios": scenarios, "repetitions": 1})
        print(f"REFINEMENTS {len(selected)} species / {len(proposals)} builds / {len(scenarios)} battles / {identity}", flush=True)
        run_fast(store, identity, data, 8)
        if store.progress(identity)["counts"].get("pending"):
            raise ValueError("refinements unfinished")
        output = {"run": identity, "base_validation_run": validation["run"], "provenance": store.run(identity)["provenance"],
                  "driver_sha256": digest(Path(__file__).read_bytes()), "subjects": [p["build"] for p in proposals],
                  "strategies": {p["id"]: p["strategy"] for p in proposals}, "selected_species": sorted(selected),
                  "rows": list(store.results(identity))}
        (OUT / "outlier-refinements.json").write_text(json.dumps(output, indent=2))
        print(json.dumps({"status": "completed", "run": identity, "battles": len(scenarios)}), flush=True)
    finally:
        target_db = sqlite3.connect(OUT / "refinements.sqlite")
        try:
            store.db.backup(target_db)
        finally:
            target_db.close()
        store.close()


if __name__ == "__main__":
    main()
