"""Verify real experiment checkpointing, replay, parallelism and reporting."""
import json
from pathlib import Path
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import PROJECT, canonical, extract
from lab.engine import RomEngine
from lab.report import export_csv, rankings
from lab.store import Store, execute


def main():
    data = extract()
    (PROJECT / "output").mkdir(exist_ok=True)
    config = {"name": "Checkpoint equivalence", "repetitions": 1, "max_turns": 20, "builds": [
        {"species": "GENGAR", "ability": "LEVITATE", "moves": ["SHADOW_BALL", "THUNDERBOLT"]},
        {"species": "MACHAMP", "ability": "GUTS", "moves": ["EARTHQUAKE", "BULLET_PUNCH"]}]}
    with tempfile.TemporaryDirectory(dir=PROJECT / "output") as directory:
        store = Store(Path(directory) / "test.sqlite")
        try:
            run_id = store.create(data, config)
            def stop_after_one(progress):
                if progress["completed"] == 1:
                    store.pause(run_id)
            first = execute(store, run_id, data, progress=stop_after_one)
            assert first["paused"] and first["completed"] == 1, first
            committed = next(r for r in store.results(run_id) if r["result"])
            second = execute(store, run_id, data, jobs=2)
            assert second["completed"] == 2 and not second["counts"].get("pending"), second
            assert store.battle(run_id, committed["id"])["result"] == committed["result"]
            engine = RomEngine(data)
            try:
                for row in store.results(run_id):
                    replay = engine.run(row["spec"])
                    assert replay["status"] == row["result"]["status"] == "completed"
                    if canonical(replay["log"]) != canonical(row["result"]["log"]):
                        (PROJECT / "output/replay-mismatch.json").write_text(json.dumps({"serial": replay, "worker": row["result"]}, indent=2))
                        raise AssertionError("serial/worker replay differs; see output/replay-mismatch.json")
            finally:
                engine.close()
            assert len(rankings(store, run_id)) == 2
            assert "score_ci95" in export_csv(rankings(store, run_id))
            report = {"status": "passed", "checks": ["pause at battle boundary", "parallel resume", "committed result unchanged", "serial and parallel replay equivalence", "rank and CSV export"]}
            (PROJECT / "output/experiment-checks.json").write_text(json.dumps(report, indent=2))
            print(report)
        finally:
            store.close()


if __name__ == "__main__":
    main()
