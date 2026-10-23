"""Loopback-only dashboard; experiment execution uses the same CLI as agents."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import secrets
import subprocess
import sys
import threading
from urllib.parse import parse_qs, urlparse

from .data import PROJECT, check_rom_data, extract
from .policy import candidate_builds
from .report import compare_runs, export_csv, rankings
from .store import Store


def serve(db_path, rom_path, port=8765):
    token = secrets.token_urlsafe(32)
    processes, lock = {}, threading.Lock()

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *_):
            pass

        def reply(self, value, status=200, content_type="application/json; charset=utf-8"):
            body = json.dumps(value, ensure_ascii=False).encode() if content_type.startswith("application/json") else (value.encode() if isinstance(value, str) else value)
            self.send_response(status)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.send_header("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self'; img-src 'self' data:; frame-ancestors 'none'")
            self.end_headers()
            self.wfile.write(body)

        def valid_host(self):
            return self.headers.get("Host") in {f"127.0.0.1:{port}", f"localhost:{port}"}

        def do_GET(self):
            if not self.valid_host():
                return self.reply({"error": "invalid host"}, 403)
            parsed = urlparse(self.path)
            q = {k: v[0] for k, v in parse_qs(parsed.query).items()}
            store = Store(db_path)
            try:
                if parsed.path in {"/", "/app.js", "/style.css"}:
                    asset = {"/": ("index.html", "text/html; charset=utf-8"), "/app.js": ("app.js", "application/javascript; charset=utf-8"), "/style.css": ("style.css", "text/css; charset=utf-8")}[parsed.path]
                    return self.reply((PROJECT / "web" / asset[0]).read_bytes(), content_type=asset[1])
                if parsed.path == "/api/catalogue":
                    data = extract()
                    return self.reply({"data": data, "token": token})
                if parsed.path == "/api/candidates":
                    return self.reply(candidate_builds(extract(), q["species"], int(q.get("count", 1)), int(q.get("level", 100))))
                if parsed.path == "/api/runs":
                    return self.reply(store.runs())
                if parsed.path == "/api/run":
                    info = store.progress(q["id"])
                    proc = processes.get(q["id"])
                    return self.reply({**info, "active": proc is not None and proc.poll() is None,
                                       "exit_code": proc.poll() if proc else None,
                                       "rankings": rankings(store, q["id"], q.get("group", "species")),
                                       "battles": store.battles(q["id"], 100, int(q.get("offset", 0)))})
                if parsed.path == "/api/battle":
                    return self.reply(store.battle(q["run"], q["id"]))
                if parsed.path == "/api/export":
                    if q.get("format") == "csv":
                        return self.reply(export_csv(rankings(store, q["run"], "build")), content_type="text/csv; charset=utf-8")
                    return self.reply({"run": store.run(q["run"]), "rankings": rankings(store, q["run"], "build"), "battles": list(store.results(q["run"]))})
                if parsed.path == "/api/compare":
                    return self.reply(compare_runs(store, q["first"], q["second"]))
                return self.reply({"error": "not found"}, 404)
            except (ValueError, KeyError, OSError) as error:
                return self.reply({"error": str(error)}, 400)
            finally:
                store.close()

        def do_POST(self):
            if not self.valid_host() or self.headers.get("X-Lab-Token") != token or self.headers.get("Origin") not in {None, f"http://127.0.0.1:{port}", f"http://localhost:{port}"}:
                return self.reply({"error": "same-origin token required"}, 403)
            try:
                length = int(self.headers.get("Content-Length", 0))
                if not 0 < length <= 2_000_000:
                    raise ValueError("invalid request size")
                payload = json.loads(self.rfile.read(length))
                store = Store(db_path)
                try:
                    if self.path == "/api/refresh":
                        data = extract()
                        return self.reply({"checks": check_rom_data(data, rom_path), "data": data})
                    if self.path == "/api/pause":
                        store.pause(payload["id"])
                        return self.reply(store.progress(payload["id"]))
                    if self.path not in {"/api/start", "/api/resume"}:
                        return self.reply({"error": "not found"}, 404)
                    data = extract()
                    check_rom_data(data, rom_path)
                    run_id = store.create(data, payload["config"], rom_path) if self.path == "/api/start" else payload["id"]
                    jobs = int(payload.get("jobs", 1))
                    if not 1 <= jobs <= 64:
                        raise ValueError("workers must be 1..64")
                    with lock:
                        proc = processes.get(run_id)
                        if self.path == "/api/resume" and proc is not None and proc.poll() is None:
                            store.pause(run_id, False)
                        if proc is None or proc.poll() is not None:
                            folder = PROJECT / "output/logs"
                            folder.mkdir(parents=True, exist_ok=True)
                            with (folder / f"{run_id}.log").open("ab") as log:
                                processes[run_id] = subprocess.Popen([sys.executable, str(PROJECT / "simulator.py"), "--db", str(db_path), "--rom", str(rom_path), "resume", run_id, "--jobs", str(jobs)], cwd=PROJECT, stdout=log, stderr=log)
                    return self.reply(store.progress(run_id), 202)
                finally:
                    store.close()
            except (ValueError, KeyError, OSError) as error:
                return self.reply({"error": str(error)}, 400)

    server = ThreadingHTTPServer(("127.0.0.1", port), Handler)
    print(f"Crimson Crystal Battle Laboratory: http://127.0.0.1:{port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
