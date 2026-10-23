"""Outcome-based rankings; failed or unfinished battles never become wins."""
from collections import defaultdict
import csv
import io
import math

from .data import canonical, digest


def interval(blocks):
    """Conservative 95% bounds for independent bounded seed-pair scores."""
    values = [sum(v) / len(v) for v in blocks.values()]
    if len(values) < 2:
        return None
    mean = sum(values) / len(values)
    radius = math.sqrt(math.log(40) / (2 * len(values)))
    return [round(max(0, mean - radius), 4), round(min(1, mean + radius), 4)]


def rankings(store, run_id, group="species"):
    if group not in {"species", "build"}:
        raise ValueError("ranking group must be species or build")
    store.run(run_id)
    groups = {}
    for row in store.results(run_id):
        spec, result = row["spec"], row["result"]
        fmt = "1v1" if len(spec["player"]) == len(spec["enemy"]) == 1 else ("6v6" if len(spec["player"]) == len(spec["enemy"]) == 6 else "custom-team")
        for side, opponent in (("player", "enemy"), ("enemy", "player")):
            team = spec[side]
            label = "+".join(m["species"] for m in team)
            identity = digest(canonical(team).encode())[:16] if group == "build" or len(team) > 1 else label
            key = fmt, identity
            g = groups.setdefault(key, {"id": identity, "name": label, "format": fmt,
                                       "build": team if group == "build" or len(team) > 1 else None,
                                       "wins": 0, "losses": 0, "draws": 0, "unresolved": 0, "errors": 0,
                                       "assertion_failures": 0, "pending": 0, "blocks": defaultdict(list),
                                       "offense": [], "survival": [], "win_turns": [], "opponents": set()})
            g["opponents"].add("+".join(m["species"] for m in spec[opponent]))
            if result is None:
                g["pending"] += 1
                continue
            if result["failures"]:
                g["assertion_failures"] += 1
                continue
            if result["status"] == "error":
                g["errors"] += 1
                continue
            if result["winner"] == "unresolved":
                g["unresolved"] += 1
                continue
            score = .5 if result["winner"] == "draw" else float(result["winner"] == side)
            g["wins" if score == 1 else "losses" if score == 0 else "draws"] += 1
            # Controlled variants share opponent seeds. When pooling variants
            # into a species row, keep those correlated outcomes in ONE block.
            block = row["block_id"] if group == "build" or len(team) > 1 else digest(canonical([spec["seed"], spec[opponent], label]).encode())
            g["blocks"][block].append(score)
            if result["log"]:
                start, end = result["log"][0], result["log"][-1]
                surviving = sum(m["hp"] / max(1, m["maxhp"]) for m in end[side]["team"]) / len(team)
                removed = sum(m["hp"] / max(1, m["maxhp"]) for m in start[opponent]["team"]) - sum(m["hp"] / max(1, m["maxhp"]) for m in end[opponent]["team"])
                g["survival"].append(surviving)
                g["offense"].append(removed / max(1, len(spec[opponent]) * result["turns"]))
                if score == 1:
                    g["win_turns"].append(result["turns"])
    output = []
    for g in groups.values():
        games = g["wins"] + g["losses"] + g["draws"]
        mean = lambda xs: round(sum(xs) / len(xs), 4) if xs else None
        score = (g["wins"] + .5 * g["draws"]) / games if games else None
        output.append({k: v for k, v in g.items() if k not in {"blocks", "offense", "survival", "win_turns", "opponents"}} | {
            "resolved": games, "score": round(score, 4) if score is not None else None,
            "score_ci95": interval(g["blocks"]), "independent_blocks": len(g["blocks"]),
            "opponent_count": len(g["opponents"]), "offense_per_turn": mean(g["offense"]),
            "remaining_hp_fraction": mean(g["survival"]), "mean_winning_turns": mean(g["win_turns"])})
    return sorted(output, key=lambda r: (r["format"], -(r["score"] if r["score"] is not None else -1), r["name"], r["id"]))


def export_csv(rows):
    out = io.StringIO(newline="")
    if rows:
        writer = csv.DictWriter(out, fieldnames=list(rows[0]))
        writer.writeheader()
        for row in rows:
            writer.writerow({k: canonical(v) if isinstance(v, (list, dict)) else v for k, v in row.items()})
    return out.getvalue()


def compare_runs(store, first, second):
    a = {(r["format"], r["name"]): r for r in rankings(store, first)}
    b = {(r["format"], r["name"]): r for r in rankings(store, second)}
    return {"first": store.progress(first), "second": store.progress(second),
            "note": "Descriptive changes; builds, policies and opponents can change rankings. Not a causal estimate.",
            "changes": [{"format": fmt, "name": name, "before": a[(fmt, name)]["score"], "after": b[(fmt, name)]["score"],
                         "delta": round(b[(fmt, name)]["score"] - a[(fmt, name)]["score"], 4)
                         if a[(fmt, name)]["score"] is not None and b[(fmt, name)]["score"] is not None else None}
                        for fmt, name in sorted(a.keys() & b.keys())]}
