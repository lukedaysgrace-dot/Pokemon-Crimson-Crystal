"""Read-only audit of saved action requests against the pinned final policy."""
import argparse
from collections import Counter
import json
from pathlib import Path
import sqlite3

from lab.data import PROJECT, canonical, digest, extract
from lab.policy import choose
from no_item_audit import DEST, OUT, write


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int)
    parser.add_argument("--complete", action="store_true")
    args = parser.parse_args()
    data = extract()
    files = sorted((PROJECT / "lab").glob("*.py")) + [PROJECT / "simulator.py"]
    expected_lab = digest(canonical({p.name: digest(p.read_bytes()) for p in files}).encode())
    expected_rom = json.loads((OUT / "source.json").read_text())["rom_sha256"]
    connection = sqlite3.connect("file:/tmp/crimson-no-items-20261024.sqlite?mode=ro", uri=True)
    connection.row_factory = sqlite3.Row
    problems, cases, actions = [], 0, 0
    query = "SELECT id,run_id,spec,result FROM battles WHERE status!='pending' ORDER BY rowid"
    if args.limit:
        query += f" LIMIT {int(args.limit)}"
    try:
        for row in connection.execute(query):
            spec, result = json.loads(row["spec"]), json.loads(row["result"])
            cases += 1
            if (result["metadata"]["laboratory_sha256"] != expected_lab
                    or result["metadata"]["data_sha256"] != data["data_sha256"]
                    or result["metadata"]["rom_sha256"] != expected_rom):
                problems.append({"run": row["run_id"], "battle": row["id"], "kind": "metadata"})
            for turn, state in enumerate(result["log"][1:], 1):
                before = result["log"][turn-1]
                for index, side in enumerate(("player", "enemy")):
                    scripted = spec.get("scripts", {}).get(side, [])
                    if turn <= len(scripted):
                        expected = scripted[turn-1]
                    else:
                        policy = spec["policies"][index]
                        assert policy in {"tactical", "aggressive", "random"}, policy
                        expected = choose(data, before[side], before["enemy" if side == "player" else "player"],
                                          policy, spec["seed"]+turn*17+index)
                    actions += 1
                    observed = state["requested_actions"][side]
                    if expected != observed:
                        problems.append({"run": row["run_id"], "battle": row["id"], "kind": "decision", "turn": turn,
                                         "side": side, "expected": expected, "observed": observed})
        pending = connection.execute("SELECT COUNT(*) FROM battles WHERE status='pending'").fetchone()[0]
        if args.complete and pending:
            problems.append({"kind": "pending", "count": pending})
    finally:
        connection.close()
    receipt = {"status": "passed" if not problems else "failed", "complete_required": args.complete,
               "battles_checked": cases, "action_requests_checked": actions, "problems": problems,
               "expected_laboratory_sha256": expected_lab, "expected_data_sha256": data["data_sha256"],
               "expected_rom_sha256": expected_rom}
    write(DEST / ("decision-consistency.json" if args.complete else "decision-consistency-checkpoint.json"), receipt)
    print(json.dumps({k: v for k, v in receipt.items() if k != "problems"} | {"problems": len(problems)}))
    if problems:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
