"""Bounded build search with disjoint validation opponents and seed cohorts."""
from .data import canonical, digest
from .policy import candidate_builds
from .report import rankings
from .store import execute


def optimize(store, data, species, opponents, count=12, repetitions=2, seed=1, level=100, jobs=1, rom_path=None, progress=None):
    if not 2 <= count <= 256:
        raise ValueError("candidate count must be 2..256")
    opponents = list(dict.fromkeys(opponents))
    if len(opponents) < 4 or species in opponents:
        raise ValueError("supply at least four distinct opponents excluding the subject for a disjoint holdout")
    proposals = candidate_builds(data, species, count, level, seed)
    opponent_builds = [candidate_builds(data, key, 1, level, seed + 1)[0] for key in opponents]
    split = max(2, len(opponents) * 2 // 3)
    training, holdout = opponent_builds[:split], opponent_builds[split:]
    def stage(name, candidates, enemies, trial_seed, reps):
        config = {"name": f"{species} / {name}", "mode": "cross-pool", "subject_count": len(candidates),
                  "builds": candidates + enemies, "seed": trial_seed, "repetitions": reps,
                  "level": level, "max_turns": 100, "policies": ["tactical", "tactical"]}
        run_id = store.create(data, config, rom_path)
        execute(store, run_id, data, jobs, rom_path, progress)
        ids = {digest(canonical([c]).encode())[:16] for c in candidates}
        ranked = [r for r in rankings(store, run_id, "build") if r["id"] in ids]
        return run_id, ranked
    training_id, training_rank = stage("candidate screening", proposals, training, seed, repetitions)
    eligible = [r for r in training_rank if r["score"] is not None and not r["errors"] and not r["assertion_failures"]]
    if not eligible:
        return {"status": "no-verified-candidates", "training_run": training_id, "training": training_rank}
    finalists = [r["build"][0] for r in eligible[:max(2, len(eligible) // 3)]]
    holdout_id, validation_rank = stage("held-out opponents", finalists, holdout, seed + 1000003, max(2, repetitions * 2))
    return {"status": "completed", "species": species, "method": "bounded proposals, training selection, disjoint opponent and seed validation",
            "candidate_count": len(proposals), "training_run": training_id, "holdout_run": holdout_id,
            "training_opponents": opponents[:split], "holdout_opponents": opponents[split:],
            "training": training_rank, "validation": validation_rank,
            "limitation": "Best observed candidates under these policies; not a proof of the globally optimal build."}
