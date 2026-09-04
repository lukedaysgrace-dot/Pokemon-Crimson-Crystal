#!/usr/bin/env python3
"""Solve the Hard Mode level curve as a fixed point.

Walks the real trainer roster in progression order, Monte-Carlos over which
trainers a player skips, and reports the level each player profile actually
reaches at every gym. Use --solve to print caps/aces that put those profiles
at parity, and --apply to write them into the game data.
"""

import argparse
import random
import re
import statistics
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from audit_exp_economy import load_base_stats, load_trainers, exp_at  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
PARTIES = ROOT / "data/trainers/parties.asm"

# Progression gates, in order. Each is (label fragment, display name).
GATES = [
    ("FALKNER (1)", "Falkner"), ("BUGSY (1)", "Bugsy"),
    ("WHITNEY (1)", "Whitney"), ("MORTY (1)", "Morty"),
    ("CHUCK (1)", "Chuck"), ("JASMINE (1)", "Jasmine"),
    ("PRYCE (1)", "Pryce"), ("CLAIR (1)", "Clair"),
    ("WILL (1)", "Will"), ("KOGA (1)", "Koga"), ("BRUNO (1)", "Bruno"),
    ("KAREN (1)", "Karen"), ("CHAMPION (1)", "Lance"),
    ("LT_SURGE (1)", "Surge"), ("MISTY (1)", "Misty"), ("ERIKA (1)", "Erika"),
    ("SABRINA (1)", "Sabrina"), ("JANINE (1)", "Janine"),
    ("BLAINE (1)", "Blaine"), ("BROCK (1)", "Brock"), ("BLUE (1)", "Blue"),
    ("RED (1)", "Red"),
]
# Beating one of these lifts the cap to the next entry. The whole Elite Four
# run shares one cap: no badge is earned until the Hall of Fame after Lance.
CAP_STEPS = ["Falkner", "Bugsy", "Whitney", "Morty", "Chuck", "Jasmine",
             "Pryce", "Clair", "Lance", "Surge", "Misty", "Erika", "Sabrina",
             "Janine", "Blaine", "Brock", "Blue"]
# Display names for the 18 cap slots (slot 8 covers Will through Lance).
CAP_GATES = ["Falkner", "Bugsy", "Whitney", "Morty", "Chuck", "Jasmine",
             "Pryce", "Clair", "EliteFour", "Surge", "Misty", "Erika",
             "Sabrina", "Janine", "Blaine", "Brock", "Blue", "Red"]

IMPORTANT = re.compile(
    r"\b(FALKNER|BUGSY|WHITNEY|MORTY|CHUCK|JASMINE|PRYCE|CLAIR|WILL|KOGA|"
    r"BRUNO|KAREN|CHAMPION|LANCE|BROCK|MISTY|LT_SURGE|ERIKA|SABRINA|JANINE|"
    r"BLAINE|BLUE|RED|RIVAL1|RIVAL2|CRYSTAL|EXECUTIVEM|EXECUTIVEF|PROTON|"
    r"PETREL|PETRELDIRECTOR|ARIANA|ARCHER)\b")

PROFILES = [("4 mons, completionist", 4, 0.00),
            ("4 mons, normal", 4, 0.25),
            ("6 mons, completionist", 6, 0.00),
            ("6 mons, normal", 6, 0.25),
            ("6 mons, rushes", 6, 0.40)]


def level_of(exp):
    lo = 5
    while lo < 100 and exp_at(lo + 1) <= exp:
        lo += 1
    return lo


def load_parties(base, max_level=92):
    out = []
    for _, label, mons in load_trainers():
        top = max(l for l, _ in mons)
        if top > max_level:
            continue          # post-Red rematch content, not on the main path
        name = label.split(" - ")[0].strip().upper()
        out.append({
            "label": label, "name": name, "top": top, "mons": mons,
            "raw": sum(base[s][0] * lv // 7 for lv, s in mons if s in base),
            "important": bool(IMPORTANT.search(name)),
        })
    out.sort(key=lambda d: (d["top"], d["label"]))
    return out


def walk(parties, caps, team, skip, rng, boost=2.0):
    """One playthrough. Returns {gate name: level on arrival}."""
    exp, gate, arrive = exp_at(5), 0, {}
    for d in parties:
        cap = caps[min(gate, len(caps) - 1)] if gate < len(caps) else 100
        hit = next((n for f, n in GATES if f in d["label"]), None)
        if d["important"] or rng.random() >= skip:
            if level_of(exp) < cap:
                exp = min(exp + int(d["raw"] * boost / team), exp_at(cap))
        if hit and hit not in arrive:
            arrive[hit] = level_of(exp)
            if hit in CAP_STEPS:
                gate = CAP_STEPS.index(hit) + 1
    return arrive


def montecarlo(parties, caps, team, skip, trials=150, seed=1):
    rng = random.Random(seed)
    runs = [walk(parties, caps, team, skip, rng) for _ in range(trials)]
    return {n: int(statistics.median(r.get(n, 0) for r in runs))
            for _, n in GATES}


def current_caps():
    src = (ROOT / "engine/pokemon/experience.asm").read_text(errors="replace")
    body = src.split("HardModeLevelCaps:", 1)[1]
    out = []
    for line in body.splitlines()[1:]:
        m = re.match(r"\s*db\s+(\d+)", line)
        if m:
            out.append(int(m.group(1)))
        elif line.strip().startswith("db "):
            break
    return out


def current_aces(parties):
    return {n: next((d["top"] for d in parties if f in d["label"]), None)
            for f, n in GATES}


def report(parties, caps):
    aces = current_aces(parties)
    print(f"{'gate':<10}{'ace':>5}", end="")
    for lab, _, _ in PROFILES:
        print(f"{lab.replace(' mons,', 'm'):>22}", end="")
    print()
    results = {lab: montecarlo(parties, caps, t, s)
               for lab, t, s in PROFILES}
    for _, n in GATES:
        ace = aces[n] or 0
        print(f"{n:<10}{ace:>5}", end="")
        for lab, _, _ in PROFILES:
            v = results[lab][n]
            print(f"{v:>17}{v - ace:>+5}", end="")
        print()
    return results


def solve(parties, target=("6 mons, normal",), rounds=25):
    """Fixed point: cap = level the target profile reaches under that cap."""
    caps = current_caps() or [10, 14, 20, 25, 31, 34, 38, 45]
    caps = caps + list(range(caps[-1] + 4, caps[-1] + 4 + 40, 4))
    caps = caps[:len(CAP_GATES)]
    for _ in range(rounds):
        res = {lab: montecarlo(parties, caps, t, s)
               for lab, t, s in PROFILES if lab in target}
        new, prev = [], 0
        for n in CAP_GATES:
            key = "Lance" if n == "EliteFour" else n
            v = max(int(statistics.median(r[key] for r in res.values())), prev + 1)
            new.append(v)
            prev = v
        if new == caps:
            break
        caps = new
    return caps


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--solve", action="store_true")
    args = ap.parse_args()
    base = load_base_stats()
    parties = load_parties(base)
    caps = current_caps()
    print("=== Arrival level vs the fight's ace, current data ===")
    print("(Johto is capped; past Clair the cap lifts and EXP alone sets the pace)\n")
    report(parties, caps)
    if args.solve:
        print("\n=== Fixed-point solve, targeting '6 mons, normal' ===")
        s = solve(parties)
        print(f"{'gate':<10}{'now':>6}{'solved':>8}")
        aces = current_aces(parties)
        for n, v in zip(CAP_GATES, s):
            print(f"{n:<10}{aces.get(n) or 0:>6}{v:>8}")


if __name__ == "__main__":
    main()
