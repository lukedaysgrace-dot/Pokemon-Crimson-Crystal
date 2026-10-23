"""Immutable, explicitly versioned corrective replays for player PP exhaustion."""
from pathlib import Path
import json

from lab.data import PROJECT, canonical, digest, extract
from roster_audit import OUT, summarize


class CorrectedStore:
    def __init__(self, base, corrections):
        self.base, self.corrections = base, corrections

    def __getattr__(self, name):
        return getattr(self.base, name)

    def results(self, identity):
        for row in self.base.results(identity):
            if row["id"] in self.corrections:
                result = self.corrections[row["id"]]["result"]
                row = {**row, "status": result["status"], "result": result}
            yield row


def needs_pp_replay(result):
    from state import SUBSTATUS_BITS
    for before, after in zip(result["log"], result["log"][1:]):
        user = before["player"]
        if any(user["pp"]) or user["hp"] <= 0:
            continue
        # A recharge or a native multi-turn lock can legitimately precede
        # selection. Do not classify those observations as transport defects.
        if any(user["substatus"][byte] & (1 << bit) for byte, bit in
               (SUBSTATUS_BITS[k] for k in ("ROLLOUT", "RAMPAGE", "BIDE", "CHARGED", "ENCORED", "RECHARGE"))):
            continue
        actions = [a for a in after.get("actions", []) if a["side"] == "player"]
        if actions and actions[0]["move"] != "STRUGGLE":
            return True
    return False


def corrected_audit(store, search, validation, candidates):
    path = OUT / "pp-corrections.json"
    run_ids = [search["run"], validation["run"]]
    affected, controls = [], []
    for run in run_ids:
        for row in store.results(run):
            if row["result"] is None:
                raise ValueError("corrective replays require a finished audit")
            if needs_pp_replay(row["result"]):
                affected.append({"run": run, **row})
            elif row["result"]["status"] == "completed" and not row["result"]["failures"] and len(controls) < 6:
                # Include different builds/abilities, not just the first six
                # orientations from one build.
                side = row["spec"]["name"].rsplit(";side=", 1)[-1]
                key = row["spec"][side][0]["species"]
                if key not in {"BUTTERFREE", "RATICATE", "MACHAMP", "WOBBUFFET", "URSALUNABM", "CLOYSTER"}:
                    continue
                if key not in {r["subject"] for r in controls}:
                    controls.append({"subject": key, "run": run, **row})
    existing = json.loads(path.read_text()) if path.exists() else None
    if existing and existing["base_runs"] == run_ids and set(existing["corrections"]) == {r["id"] for r in affected}:
        correction_receipt = existing
    else:
        from pp_transport_probe import candidate_module
        patched = candidate_module()
        data = extract()
        engine = patched.RomEngine(data)
        engine.metadata.update({"transport": "lab-v2-pp-guard", "transport_patch_sha256": patched.patch_sha256})
        correction_receipt = {"base_runs": run_ids, "original_engine_sha256": digest((PROJECT / "lab/engine.py").read_bytes()),
                              "candidate_engine_sha256": patched.patch_sha256, "corrections": {}, "control_replays": []}
        try:
            for row in affected:
                result = engine.run(row["spec"])
                if result["status"] == "error" or result["failures"] or needs_pp_replay(result):
                    raise ValueError(f"PP corrective replay failed: {row['id']}: {result.get('error')}")
                correction_receipt["corrections"][row["id"]] = {
                    "run": row["run"], "original_replay_id": row["result"]["replay_id"],
                    "original_status": row["result"]["status"], "original_winner": row["result"]["winner"],
                    "matching_prefix_snapshots": next((i for i, (a, b) in enumerate(zip(row["result"]["log"], result["log"]))
                                                       if canonical(a) != canonical(b)), min(len(row["result"]["log"]), len(result["log"]))),
                    "result": result}
                print(f"Corrected PP replay {row['id']}: {result['status']} / {result['winner']} / {result['turns']} turns", flush=True)
            for row in controls:
                result = engine.run(row["spec"])
                equal = (canonical(result["log"]) == canonical(row["result"]["log"])
                         and result["winner"] == row["result"]["winner"] and result["status"] == row["result"]["status"])
                if not equal:
                    raise ValueError(f"PP guard changed an unaffected control: {row['id']}")
                correction_receipt["control_replays"].append({"run": row["run"], "battle": row["id"], "exact_log_match": equal,
                                                               "original_replay_id": row["result"]["replay_id"], "new_replay_id": result["replay_id"]})
        finally:
            engine.close()
        (OUT / "engine-pre-pp-fix.py").write_bytes((PROJECT / "lab/engine.py").read_bytes())
        (OUT / "engine-pp-candidate.py").write_text(patched.patched_source)
        path.write_text(json.dumps(correction_receipt, indent=2))
    proxy = CorrectedStore(store, correction_receipt["corrections"])
    # The finalist shortlist is intentionally retained as originally selected;
    # correcting a screening result does not silently claim a new search pass.
    search = {**search, "rows": summarize(proxy, search["run"], [p["build"] for p in candidates])}
    validation = {**validation, "rows": summarize(proxy, validation["run"], validation["subjects"])}
    return proxy, search, validation, correction_receipt
