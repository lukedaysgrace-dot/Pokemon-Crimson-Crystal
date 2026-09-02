#!/usr/bin/env python3
"""Run each gauntlet battle in its own timeout-isolated emulator process."""

import concurrent.futures
import json
import subprocess
import sys
import time
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
RUNNER = HERE / "run_gauntlet.py"
SINGLE = HERE / "single_results"


def one(index):
    path = SINGLE / f"{index:03}.json"
    if path.exists():
        return index, "cached", ""
    try:
        done = subprocess.run([sys.executable, str(RUNNER), "--single-index", str(index)],
                              cwd=HERE.parent, capture_output=True, text=True, timeout=45)
        return index, "ok" if done.returncode == 0 and path.exists() else "failed", done.stderr[-500:]
    except subprocess.TimeoutExpired:
        return index, "timeout", "emulator process exceeded 45 seconds"


def main():
    SINGLE.mkdir(exist_ok=True)
    started = time.time()
    statuses = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        futures = {pool.submit(one, i): i for i in range(1, 514)}
        for future in concurrent.futures.as_completed(futures):
            index, status, detail = future.result()
            statuses[index] = {"status": status, "detail": detail}
            print(f"{len(statuses):03}/513 battle {index:03}: {status}", flush=True)
    results = []
    for index in range(1, 514):
        path = SINGLE / f"{index:03}.json"
        if path.exists():
            item = json.loads(path.read_text())[0]
            item["index"] = index
            results.append(item)
        else:
            results.append({"index": index, "outcome": "technical_timeout", **statuses[index]})
    (HERE / "gauntlet_results.json").write_text(json.dumps(results, indent=2))
    print(json.dumps({"seconds": round(time.time() - started, 1),
                      "outcomes": Counter(r["outcome"] for r in results),
                      "process_status": Counter(v["status"] for v in statuses.values())}))


if __name__ == "__main__":
    main()
