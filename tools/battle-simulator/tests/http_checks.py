"""End-to-end loopback API checks using the same server as the dashboard."""
import csv
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import PROJECT, ROOT


def main():
    (PROJECT / "output").mkdir(exist_ok=True)
    base = "http://127.0.0.1:8766"
    with tempfile.TemporaryDirectory(dir=PROJECT / "output") as directory:
        server = subprocess.Popen([sys.executable, str(PROJECT / "simulator.py"), "--db", str(Path(directory) / "test.sqlite"), "serve", "--port", "8766"], cwd=ROOT, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        token = None
        def request(path, payload=None, authenticated=True):
            headers = {"Content-Type": "application/json"}
            if authenticated and token:
                headers["X-Lab-Token"] = token
            req = Request(base + path, data=json.dumps(payload).encode() if payload is not None else None, headers=headers)
            with urlopen(req, timeout=30) as response:
                raw = response.read().decode()
                return json.loads(raw) if response.headers.get_content_type() == "application/json" else raw
        try:
            deadline = time.monotonic() + 90
            while True:
                try:
                    catalogue = request("/api/catalogue")
                    break
                except URLError:
                    if time.monotonic() >= deadline:
                        raise
                    time.sleep(.2)
            token = catalogue["token"]
            assert len(catalogue["data"]["species"]) == 498
            assert "Battle Laboratory" in request("/")
            try:
                request("/api/start", {}, authenticated=False)
                raise AssertionError("unauthenticated mutation accepted")
            except HTTPError as error:
                assert error.code == 403
            a = request("/api/candidates?species=GENGAR")[0]
            b = request("/api/candidates?species=MACHAMP")[0]
            created = request("/api/start", {"config": {"name": "HTTP scenario", "mode": "scenarios", "repetitions": 1,
                              "scenarios": [{"player": a, "enemy": b, "seed": 1729, "max_turns": 20}]}})
            run_id = created["id"]
            deadline = time.monotonic() + 180
            while True:
                run = request(f"/api/run?id={run_id}")
                if run["completed"] == 1 and not run["active"]:
                    break
                if time.monotonic() >= deadline:
                    raise AssertionError(run)
                time.sleep(.3)
            record = request(f"/api/battle?run={run_id}&id={run['battles'][0]['id']}")
            assert record["result"]["status"] == "completed", record["result"]
            assert record["result"]["scenario"]["seed"] == 1729
            assert len(list(csv.DictReader(io.StringIO(request(f"/api/export?run={run_id}&format=csv"))))) == 2
            assert request(f"/api/export?run={run_id}")["run"]["id"] == run_id
            assert all(r["delta"] == 0 for r in request(f"/api/compare?first={run_id}&second={run_id}")["changes"])
            report = {"status": "passed", "checks": ["catalogue and assets", "mutation token", "candidate API", "scenario submission", "native outcome and exact seed", "battle records", "CSV and JSON export", "run comparison"]}
            (PROJECT / "output/http-checks.json").write_text(json.dumps(report, indent=2))
            print(report)
        finally:
            server.terminate()
            server.wait(timeout=20)


if __name__ == "__main__":
    main()
