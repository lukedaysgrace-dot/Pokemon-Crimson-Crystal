#!/usr/bin/env python3
"""Agent-friendly CLI for reproducible Crimson Crystal battle experiments."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

from lab.data import PROJECT, ROOT, canonical, check_rom_data, extract, provenance
from lab.engine import RomEngine
from lab.policy import candidate_builds
from lab.report import compare_runs, export_csv, rankings
from lab.store import Store, execute


def emit(value, path=None):
    text = value if isinstance(value, str) else json.dumps(value, indent=2, ensure_ascii=False)
    if path:
        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text + ("" if text.endswith("\n") else "\n"), encoding="utf-8")
    else:
        print(text)


def load(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--db", type=Path, default=PROJECT / "output/lab.sqlite")
    parser.add_argument("--rom", type=Path, default=ROOT / "pokecrystal_debug.gbc")
    sub = parser.add_subparsers(dest="command", required=True)
    p = sub.add_parser("extract", help="refresh the full source catalogue")
    p.add_argument("--out", type=Path, default=PROJECT / "output/catalogue.json")
    sub.add_parser("doctor", help="check compiled records, weights, source freshness and environment")
    p = sub.add_parser("scenario", help="run a legal scripted or autonomous scenario")
    p.add_argument("file", type=Path)
    p.add_argument("--out", type=Path)
    p = sub.add_parser("batch", help="create and execute a version-pinned experiment")
    p.add_argument("file", type=Path)
    p.add_argument("--jobs", type=int, default=1)
    p.add_argument("--plan-only", action="store_true")
    p = sub.add_parser("resume")
    p.add_argument("run")
    p.add_argument("--jobs", type=int, default=1)
    p.add_argument("--retry-errors", action="store_true")
    p = sub.add_parser("pause")
    p.add_argument("run")
    sub.add_parser("runs")
    p = sub.add_parser("rank")
    p.add_argument("run")
    p.add_argument("--group", choices=("species", "build"), default="species")
    p.add_argument("--out", type=Path)
    p = sub.add_parser("export")
    p.add_argument("run")
    p.add_argument("--format", choices=("csv", "json"), default="json")
    p.add_argument("--out", type=Path, required=True)
    p = sub.add_parser("compare-runs")
    p.add_argument("first")
    p.add_argument("second")
    p = sub.add_parser("candidates")
    p.add_argument("species")
    p.add_argument("--count", type=int, default=12)
    p.add_argument("--level", type=int, default=100)
    p.add_argument("--seed", type=int, default=1)
    p.add_argument("--out", type=Path)
    p = sub.add_parser("optimize")
    p.add_argument("species")
    p.add_argument("--opponents", nargs="+", required=True)
    p.add_argument("--count", type=int, default=12)
    p.add_argument("--repetitions", type=int, default=2)
    p.add_argument("--seed", type=int, default=1)
    p.add_argument("--level", type=int, default=100)
    p.add_argument("--jobs", type=int, default=1)
    p.add_argument("--out", type=Path)
    p = sub.add_parser("verify", help="run existing semantic harness suites and preserve receipts")
    p.add_argument("--suite", choices=("smoke", "weight", "deep"), default="smoke")
    p = sub.add_parser("serve")
    p.add_argument("--port", type=int, default=8765)
    args = parser.parse_args(argv)
    data = extract()
    if args.command == "extract":
        emit({**data, "provenance": provenance(args.rom)}, args.out)
        emit({"written": str(args.out), "species": len(data["species"]), "moves": len(data["moves"])})
        return 0
    if args.command == "doctor":
        checks = check_rom_data(data, args.rom)
        import importlib.metadata
        emit({"status": "ready", "checks": checks, "pyboy": importlib.metadata.version("pyboy"),
              "species": len(data["species"]), "moves": len(data["moves"]), "abilities": len(data["abilities"]),
              "weights": len(data["species"]), "data_sha256": data["data_sha256"]})
        return 0
    if args.command == "candidates":
        emit(candidate_builds(data, args.species.upper(), args.count, args.level, args.seed), args.out)
        return 0
    if args.command == "scenario":
        engine = RomEngine(data, args.rom)
        try:
            result = engine.run(load(args.file))
            result["provenance"] = provenance(args.rom)
            output = args.out or PROJECT / "output/scenarios" / (result["replay_id"] + ".json")
            emit(result, output)
            emit({"output": str(output), **{k: result[k] for k in ("status", "winner", "turns", "seconds", "failures")}, **({"error": result["error"]} if "error" in result else {})})
            return int(result["status"] == "error" or bool(result["failures"]))
        finally:
            engine.close()
    if args.command == "verify":
        check_rom_data(data, args.rom)
        commands = [[sys.executable, str(ROOT / "tools/battletest/runner.py"), "--no-render"]]
        if args.suite == "smoke":
            commands[0].append(str(ROOT / "tools/battletest/tests/00-smoke.yaml"))
        elif args.suite == "weight":
            commands[0].append(str(ROOT / "tools/battletest/tests/92-weight-moves.yaml"))
            commands.append([sys.executable, str(ROOT / "tools/battletest/weight_checks.py"), "--rom", str(args.rom)])
        else:
            commands[0] += ["--all-moves", "--all-effects", "--all-abilities", "--interactions", "128"]
        if args.rom.resolve() != (ROOT / "pokecrystal_debug.gbc").resolve():
            raise ValueError("semantic runner uses the default debug ROM; use that ROM for verify")
        receipts = []
        for command in commands:
            run = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
            print(run.stdout, end="")
            if run.stderr:
                print(run.stderr, file=sys.stderr, end="")
            receipts.append({"command": command, "exit_code": run.returncode, "stdout": run.stdout, "stderr": run.stderr})
        emit({"suite": args.suite, "provenance": provenance(args.rom), "checks": receipts}, PROJECT / f"output/verification-{args.suite}.json")
        return int(any(r["exit_code"] for r in receipts))
    args.db.parent.mkdir(parents=True, exist_ok=True)
    if args.command == "serve":
        from lab.server import serve
        serve(args.db, args.rom, args.port)
        return 0
    store = Store(args.db)
    progress = lambda p: print(f"{p['id']}: {p['completed']}/{p['total']} {p['counts']}", file=sys.stderr, flush=True)
    try:
        if args.command == "batch":
            check_rom_data(data, args.rom)
            run_id = store.create(data, load(args.file), args.rom)
            emit(store.progress(run_id))
            if not args.plan_only:
                emit(execute(store, run_id, data, args.jobs, args.rom, progress))
        elif args.command == "resume":
            emit(execute(store, args.run, data, args.jobs, args.rom, progress, args.retry_errors))
        elif args.command == "pause":
            store.pause(args.run)
            emit(store.progress(args.run))
        elif args.command == "runs":
            emit(store.runs())
        elif args.command == "rank":
            emit(rankings(store, args.run, args.group), args.out)
        elif args.command == "export":
            if args.format == "csv":
                emit(export_csv(rankings(store, args.run, "build")), args.out)
            else:
                emit({"run": store.run(args.run), "rankings": rankings(store, args.run, "build"), "battles": list(store.results(args.run))}, args.out)
        elif args.command == "compare-runs":
            emit(compare_runs(store, args.first, args.second))
        elif args.command == "optimize":
            from lab.optimize import optimize
            result = optimize(store, data, args.species.upper(), [s.upper() for s in args.opponents], args.count, args.repetitions, args.seed, args.level, args.jobs, args.rom, progress)
            emit(result, args.out or PROJECT / f"output/optimization-{args.species.lower()}.json")
            emit({k: result[k] for k in ("status", "training_run", "holdout_run") if k in result})
        return 0
    finally:
        store.close()


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (ValueError, OSError, KeyError, ImportError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(2)
