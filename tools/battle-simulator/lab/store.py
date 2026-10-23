"""Incremental, version-pinned experiments."""
from __future__ import annotations

from concurrent.futures import FIRST_COMPLETED, ProcessPoolExecutor, wait
from datetime import datetime, timezone
import json
import multiprocessing
import sqlite3

from .data import canonical, digest, provenance
from .engine import RomEngine, validate_scenario
from .policy import candidate_builds


class Store:
    def __init__(self, path):
        self.path = str(path)
        self.db = sqlite3.connect(self.path, timeout=30)
        self.db.row_factory = sqlite3.Row
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.executescript("""
        CREATE TABLE IF NOT EXISTS runs (
          id TEXT PRIMARY KEY, created TEXT NOT NULL, config TEXT NOT NULL,
          provenance TEXT NOT NULL, paused INTEGER NOT NULL DEFAULT 0);
        CREATE TABLE IF NOT EXISTS battles (
          run_id TEXT NOT NULL, id TEXT NOT NULL, block_id TEXT NOT NULL,
          spec TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending', result TEXT,
          PRIMARY KEY (run_id,id));
        CREATE INDEX IF NOT EXISTS battle_status ON battles(run_id,status);
        """)

    def close(self):
        self.db.close()

    def create(self, data, config, rom_path=None):
        config = normalize_config(data, config)
        receipt = provenance(rom_path)
        identity = digest(canonical({"config": config, "provenance": receipt}).encode())[:20]
        with self.db:
            self.db.execute("INSERT OR IGNORE INTO runs(id,created,config,provenance) VALUES(?,?,?,?)",
                            (identity, datetime.now(timezone.utc).isoformat(), canonical(config), canonical(receipt)))
            for block, spec in experiment_scenarios(data, config):
                key = digest(canonical(spec).encode())
                self.db.execute("INSERT OR IGNORE INTO battles(run_id,id,block_id,spec) VALUES(?,?,?,?)",
                                (identity, key, block, canonical(spec)))
        return identity

    def runs(self):
        return [self.progress(row["id"]) for row in self.db.execute("SELECT id FROM runs ORDER BY created DESC")]

    def run(self, identity):
        row = self.db.execute("SELECT * FROM runs WHERE id=?", (identity,)).fetchone()
        if row is None:
            raise ValueError(f"unknown run: {identity}")
        return {**dict(row), "config": json.loads(row["config"]), "provenance": json.loads(row["provenance"])}

    def progress(self, identity):
        run = self.run(identity)
        counts = dict(self.db.execute("SELECT status,COUNT(*) FROM battles WHERE run_id=? GROUP BY status", (identity,)))
        return {"id": identity, "created": run["created"], "name": run["config"]["name"],
                "paused": bool(run["paused"]), "counts": counts, "total": sum(counts.values()),
                "completed": sum(v for k, v in counts.items() if k != "pending"), "config": run["config"],
                "source_sha256": run["provenance"]["source_sha256"], "rom_sha256": run["provenance"]["rom_sha256"]}

    def pause(self, identity, paused=True):
        self.run(identity)
        with self.db:
            self.db.execute("UPDATE runs SET paused=? WHERE id=?", (int(paused), identity))

    def save(self, run_id, identity, result):
        status = "assertion-failed" if result["failures"] and result["status"] != "error" else result["status"]
        with self.db:
            self.db.execute("UPDATE battles SET status=?,result=? WHERE run_id=? AND id=?",
                            (status, canonical(result), run_id, identity))

    def battle(self, run_id, identity):
        row = self.db.execute("SELECT * FROM battles WHERE run_id=? AND id=?", (run_id, identity)).fetchone()
        if not row:
            raise ValueError("unknown battle")
        return {**dict(row), "spec": json.loads(row["spec"]), "result": json.loads(row["result"]) if row["result"] else None}

    def battles(self, run_id, limit=100, offset=0):
        return [dict(r) for r in self.db.execute("SELECT id,block_id,status,json_extract(spec,'$.name') AS name FROM battles WHERE run_id=? ORDER BY rowid LIMIT ? OFFSET ?", (run_id, limit, offset))]

    def results(self, run_id):
        for row in self.db.execute("SELECT id,block_id,status,result,spec FROM battles WHERE run_id=? ORDER BY rowid", (run_id,)):
            yield {**dict(row), "result": json.loads(row["result"]) if row["result"] else None, "spec": json.loads(row["spec"])}


def normalize_config(data, config):
    allowed = {"name", "builds", "species", "repetitions", "seed", "level", "policies", "max_turns", "mode", "scenarios", "weather", "subject_count"}
    if not isinstance(config, dict) or config.keys() - allowed:
        raise ValueError("unknown experiment fields")
    config = {"name": "Balance experiment", "repetitions": 4, "seed": 1, "level": 100,
              "policies": ["tactical", "tactical"], "max_turns": 100, "mode": "round-robin", **config}
    if type(config["repetitions"]) is not int or not 1 <= config["repetitions"] <= 1000000:
        raise ValueError("repetitions must be 1..1000000")
    if config["mode"] not in {"round-robin", "scenarios", "cross-pool"}:
        raise ValueError("mode must be round-robin, cross-pool or scenarios")
    if config["mode"] == "scenarios":
        config["scenarios"] = [validate_scenario(data, s) for s in config.get("scenarios", [])]
        if not config["scenarios"]:
            raise ValueError("supply scenarios")
        return config
    builds = config.get("builds")
    if builds is None:
        species = config.get("species", [])
        if species == "fully-evolved":
            species = [k for k, s in data["species"].items() if s["fully_evolved"]]
        if not isinstance(species, list) or any(s not in data["species"] for s in species):
            raise ValueError("species must be a list of source constants or fully-evolved")
        builds = [candidate_builds(data, s, 1, config["level"], config["seed"])[0] for s in species]
    if not isinstance(builds, list) or len(builds) < 2:
        raise ValueError("an experiment needs at least two builds or teams")
    teams = [b if isinstance(b, list) else [b] for b in builds]
    validated = []
    for team in teams:
        scenario = validate_scenario(data, {"player": team, "enemy": team, "seed": config["seed"], "policies": config["policies"], "max_turns": config["max_turns"]})
        if any(set(m) & {"hp", "status_byte", "stages", "substatus"} for m in team):
            raise ValueError("ranked experiments need fresh builds; use scenario mode for injected states")
        validated.append(scenario["player"])
    if len({len(t) for t in validated}) != 1 or len({m["level"] for t in validated for m in t}) != 1:
        raise ValueError("ranked builds must use common team size and level")
    config["builds"] = validated
    if config["mode"] == "cross-pool" and (type(config.get("subject_count")) is not int or not 1 <= config["subject_count"] < len(validated)):
        raise ValueError("cross-pool needs subject_count between 1 and the build count minus 1")
    return config


def experiment_scenarios(data, config):
    if config["mode"] == "scenarios":
        for index, scenario in enumerate(config["scenarios"]):
            for trial in range(config["repetitions"]):
                block = digest(canonical([index, trial, config["seed"]]).encode())[:24]
                yield block, {**scenario, "seed": scenario["seed"] if trial == 0 else int(digest(block.encode())[:8], 16)}
        return
    builds = config["builds"]
    for i, player in enumerate(builds):
        if config["mode"] == "cross-pool" and i >= config["subject_count"]:
            break
        opponents = range(config["subject_count"], len(builds)) if config["mode"] == "cross-pool" else range(i + 1, len(builds))
        for j in opponents:
            for trial in range(config["repetitions"]):
                block = digest(canonical([i, j, trial, config["seed"]]).encode())[:24]
                # Cross-pool candidates face the SAME opponent seeds, enabling
                # controlled ability/item/moveset comparisons.
                seed_key = [j - config.get("subject_count", 0), trial, config["seed"]] if config["mode"] == "cross-pool" else [i, j, trial, config["seed"]]
                seed = int(digest(canonical(seed_key).encode())[:8], 16)
                for swap in (False, True):
                    a, b = (builds[j], player) if swap else (player, builds[j])
                    yield block, {"name": f"{'+'.join(m['species'] for m in a)} vs {'+'.join(m['species'] for m in b)} / trial {trial + 1}",
                                  "player": a, "enemy": b, "policies": config["policies"],
                                  "seed": seed, "max_turns": config["max_turns"],
                                  **({"weather": config["weather"]} if "weather" in config else {})}


_ENGINE = None


def init_worker(data, rom_path):
    global _ENGINE
    _ENGINE = RomEngine(data, rom_path)
    from multiprocessing.util import Finalize
    Finalize(None, close_worker, exitpriority=10)


def close_worker():
    global _ENGINE
    engine, _ENGINE = _ENGINE, None
    if engine is not None:
        engine.close()
    del engine
    import gc
    gc.collect()


def execute_worker(spec):
    return _ENGINE.run(spec)


def execute(store, run_id, data, jobs=1, rom_path=None, progress=None, retry_errors=False):
    if not 1 <= jobs <= 64:
        raise ValueError("jobs must be 1..64")
    if store.run(run_id)["provenance"] != provenance(rom_path):
        raise ValueError("Source, ROM, symbols or laboratory changed. Create a new run; old results remain available.")
    engine = RomEngine(data, rom_path)
    engine.close()  # warm fixture once before concurrent bootstrap
    if retry_errors:
        with store.db:
            store.db.execute("UPDATE battles SET status='pending',result=NULL WHERE run_id=? AND status='error'", (run_id,))
    store.pause(run_id, False)
    # Do not keep a SELECT transaction open across result writes. A pause from
    # another connection would invalidate that WAL snapshot and make save()
    # fail with SQLITE_BUSY_SNAPSHOT instead of pausing cleanly.
    cursor = iter(store.db.execute("SELECT id,spec FROM battles WHERE run_id=? AND status='pending' ORDER BY rowid", (run_id,)).fetchall())
    if jobs == 1:
        engine = RomEngine(data, rom_path)
        try:
            while not store.run(run_id)["paused"]:
                row = next(cursor, None)
                if row is None:
                    break
                store.save(run_id, row["id"], engine.run(json.loads(row["spec"])))
                if progress:
                    progress(store.progress(run_id))
        except KeyboardInterrupt:
            store.pause(run_id)
        finally:
            engine.close()
        return store.progress(run_id)
    with ProcessPoolExecutor(max_workers=jobs, mp_context=multiprocessing.get_context("spawn"), initializer=init_worker, initargs=(data, rom_path)) as pool:
        pending, exhausted = {}, False
        try:
            while pending or not exhausted:
                paused = store.run(run_id)["paused"]
                while not paused and not exhausted and len(pending) < jobs:
                    row = next(cursor, None)
                    if row is None:
                        exhausted = True
                        break
                    pending[pool.submit(execute_worker, json.loads(row["spec"]))] = row["id"]
                if not pending:
                    break
                done, _ = wait(pending, timeout=1, return_when=FIRST_COMPLETED)
                for future in done:
                    identity = pending.pop(future)
                    store.save(run_id, identity, future.result())
                    if progress:
                        progress(store.progress(run_id))
                if paused:
                    exhausted = True
        except KeyboardInterrupt:
            store.pause(run_id)
            for future in pending:
                future.cancel()
    return store.progress(run_id)
