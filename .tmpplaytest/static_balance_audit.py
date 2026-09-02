#!/usr/bin/env python3
"""Static companion audit for the Hard Mode trainer gauntlet."""

import csv
import json
import math
import re
import glob
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / ".tmpplaytest"
ROWS = json.loads((OUT / "map_trainers.json").read_text())


def move_data():
    out = {}
    pat = re.compile(r"\s*move\s+(\w+),\s*(\d+),\s*(\w+),\s*(\w+),\s*(\d+),\s*(\d+),\s*(\d+)\s*;\s*(\w+)")
    for line in (ROOT / "data/moves/moves.asm").read_text().splitlines():
        m = pat.match(line)
        if m:
            effect, power, typ, category, accuracy, pp, chance, name = m.groups()
            out[name] = dict(effect=effect, power=int(power), type=typ, category=category,
                             accuracy=int(accuracy), pp=int(pp), chance=int(chance))
    return out


def species_data():
    out = {}
    for path in (ROOT / "data/pokemon/base_stats").glob("*.asm"):
        text = path.read_text(errors="replace")
        sm = re.search(r"^\s*abilities_for\s+(\w+),", text, re.M)
        stats = re.search(r"species ID placeholder\s*\n\s*\n?\s*db\s+([\d, ]+)\s*\n\s*;\s*hp", text, re.M)
        typ = re.search(r"^\s*db\s+(\w+),\s*(\w+)\s*; type", text, re.M)
        be = re.search(r"^\s*db\s+(\d+)\s*; base exp", text, re.M)
        growth = re.search(r"^\s*db\s+(GROWTH_\w+)\s*; growth rate", text, re.M)
        if sm and stats and typ and be and growth:
            vals = [int(x.strip()) for x in stats.group(1).split(",")]
            out[sm.group(1)] = {"stats": vals, "bst": sum(vals), "types": list(typ.groups()),
                                "base_exp": int(be.group(1)), "growth": growth.group(1)}
    return out


MOVES = move_data()
SPECIES = species_data()


def learnset_data():
    out = {}
    current = None
    for filename in glob.glob(str(ROOT / "data/pokemon/evos_attacks*.asm")):
        for line in Path(filename).read_text(errors="replace").splitlines():
            m = re.match(r"(\w+)EvosAttacks:", line)
            if m:
                current = re.sub(r"[^A-Z0-9]", "", m.group(1).upper())
                out.setdefault(current, [])
                continue
            m = re.match(r"\s*dbw\s+(\d+),\s*(\w+)", line)
            if current and m:
                out[current].append((int(m.group(1)), m.group(2)))
    return out


LEARNSETS = learnset_data()


def first_encounters():
    """Collapse rematches, duplicate references, and starter alternatives."""
    candidates = []
    for row in ROWS:
        if row["class"].endswith("_REMATCH"):
            continue
        candidates.append(row)
    unique = {}
    for row in candidates:
        unique.setdefault((row["class"], row["id_num"]), row)
    candidates = list(unique.values())

    # Phone opponents' numbered 2-5 loadtrainer entries are repeat fights,
    # not additional route NPCs. Only classify them this way when that same
    # map/class has the corresponding first entry.
    first_bases = set()
    for row in candidates:
        m = re.fullmatch(r"(.+?)1", row["id"])
        if m:
            first_bases.add((row["map"], row["class"], m.group(1)))
    filtered = []
    for row in candidates:
        m = re.fullmatch(r"(.+?)([2-5])", row["id"])
        if (m and row["kind"] == "loadtrainer" and not row["event"] and
                (row["map"], row["class"], m.group(1)) in first_bases):
            continue
        filtered.append(row)

    # One Cyndaquil-start route: Silver uses Totodile, Crystal uses Chikorita.
    routed = []
    for row in filtered:
        suffix = next((s for s in ("CHIKORITA", "CYNDAQUIL", "TOTODILE") if row["id"].endswith("_" + s)), None)
        if suffix:
            wanted = "TOTODILE" if "RIVAL" in row["class"] else "CHIKORITA"
            if suffix != wanted:
                continue
        routed.append(row)
    return routed


FIRST = first_encounters()


GROWTH = {
    "GROWTH_MEDIUM_FAST": (1, 1, 0, 0, 0),
    "GROWTH_SLIGHTLY_FAST": (3, 4, 10, 0, 30),
    "GROWTH_SLIGHTLY_SLOW": (3, 4, 20, 0, 70),
    "GROWTH_MEDIUM_SLOW": (6, 5, -15, 100, 140),
    "GROWTH_FAST": (4, 5, 0, 0, 0),
    "GROWTH_SLOW": (5, 4, 0, 0, 0),
}


def exp_at(level, growth):
    if level <= 1:
        return 0
    a, b, c, d, e = GROWTH[growth]
    return max(0, (a * level ** 3) // b + c * level ** 2 + d * level - e)


def trainer_mon_exp(mon):
    base = SPECIES.get(mon["species"], {}).get("base_exp", 0)
    raw = (base * mon["level"]) // 7
    return raw + raw // 2


def exp_cap_table():
    caps = [("Falkner", 10, "FALKNER"), ("Bugsy", 16, "BUGSY"),
            ("Whitney", 21, "WHITNEY"), ("Morty", 26, "MORTY"),
            ("Chuck", 31, "CHUCK"), ("Jasmine", 36, "JASMINE"),
            ("Pryce", 40, "PRYCE"), ("Clair", 45, "CLAIR")]
    family = ["CYNDAQUIL", "MAREEP", "BELLSPROUT", "GASTLY", "GEODUDE", "ZUBAT"]
    out = []
    for name, cap, klass in caps:
        available = [r for r in FIRST if r["max_level"] <= cap and not (r["class"] == klass and r["id_num"] == 1)]
        total = sum(trainer_mon_exp(mon) for row in available for mon in row["mons"])
        needs = [exp_at(cap, SPECIES[s]["growth"]) - exp_at(5, SPECIES[s]["growth"]) for s in family]
        need_total = sum(needs)
        out.append({"leader": name, "cap": cap, "available_first_encounters": len(available),
                    "trainer_exp_total": total,
                    "three_mon_need_from_level_5": sum(needs[:3]),
                    "four_mon_need_from_level_5": sum(needs[:4]),
                    "six_mon_need_from_level_5": need_total,
                    "surplus": total - need_total, "coverage_pct": round(100 * total / need_total, 1),
                    "average_possible_level_note": "trainer-only; wild encounters excluded"})
    return out


def anomaly_rows():
    flags = []
    seen = set()

    def add(row, mon, severity, category, detail):
        key = (row["class"], row["id_num"], mon["species"], mon["level"], category, detail)
        if key in seen:
            return
        seen.add(key)
        flags.append({"severity": severity, "category": category, "map": row["map"],
                      "trainer_class": row["class"], "trainer_id": row["id"], "trainer": row["name"],
                      "level": mon["level"], "species": mon["species"], "detail": detail})

    for row in FIRST:
        for mon in row["mons"]:
            level = mon["level"]
            custom = [m for m in mon.get("moves", []) if m and m != "NO_MOVE"]
            if not custom and mon["species"] != "TOTODILE":
                key = re.sub(r"[^A-Z0-9]", "", mon["species"])
                natural = [move for learned_level, move in LEARNSETS.get(key, []) if learned_level <= level][-4:]
                if level <= 20 and "SELFDESTRUCT" in natural:
                    add(row, mon, "medium", "moveset", "default level-up set includes Selfdestruct this early")
            data = [MOVES.get(m, {}) for m in custom]
            damaging = [(m, d) for m, d in zip(custom, data) if d.get("power", 0) > 0]
            if len(custom) != len(set(custom)):
                add(row, mon, "high", "moveset", f"duplicate move(s): {', '.join(custom)}")
            for move, d in zip(custom, data):
                power, effect = d.get("power", 0), d.get("effect", "")
                if "OHKO" in effect and level < 60:
                    add(row, mon, "high", "moveset", f"{move} is an OHKO move at level {level}")
                elif level <= 10 and power >= 80:
                    add(row, mon, "high", "moveset", f"{move} has {power} power at level {level}")
                elif level <= 20 and power >= 100:
                    add(row, mon, "medium", "moveset", f"{move} has {power} power at level {level}")
            setup = {"SWORDS_DANCE", "NASTY_PLOT", "DRAGON_DANCE", "QUIVER_DANCE", "SHELL_SMASH", "CALM_MIND", "BELLY_DRUM"}
            sleep = {"SPORE", "SLEEP_POWDER", "HYPNOSIS", "SING", "LOVELY_KISS", "YAWN"}
            recovery = {"RECOVER", "ROOST", "SOFTBOILED", "MILK_DRINK", "SYNTHESIS", "MOONLIGHT", "MORNING_SUN", "SLACK_OFF"}
            if level <= 20 and setup.intersection(custom):
                add(row, mon, "medium", "moveset", f"early setup move: {', '.join(sorted(setup.intersection(custom)))}")
            if level <= 30 and sleep.intersection(custom) and "DREAM_EATER" in custom:
                add(row, mon, "medium", "moveset", "sleep + Dream Eater package can be oppressive this early")
            if setup.intersection(custom) and recovery.intersection(custom):
                add(row, mon, "medium", "moveset", "setup plus reliable recovery can snowball")
            item = mon.get("item", "NO_ITEM")
            status_moves = [m for m, d in zip(custom, data) if d.get("category") == "CATEGORIZE_STATUS"]
            if item in {"CHOICE_BAND", "CHOICE_SPECS", "CHOICE_SCARF", "ASSAULT_VEST"} and status_moves:
                add(row, mon, "high", "item synergy", f"{item} conflicts with status move(s): {', '.join(status_moves)}")
            if item == "CHOICE_SPECS" and damaging:
                physical = [m for m, d in damaging if d.get("category") == "CATEGORIZE_PHYSICAL"]
                if len(physical) > len(damaging) / 2:
                    add(row, mon, "high", "item synergy", f"CHOICE_SPECS but mostly physical attacks: {', '.join(physical)}")
            if item == "CHOICE_BAND" and damaging:
                special = [m for m, d in damaging if d.get("category") == "CATEGORIZE_SPECIAL"]
                if len(special) > len(damaging) / 2:
                    add(row, mon, "high", "item synergy", f"CHOICE_BAND but mostly special attacks: {', '.join(special)}")
            if custom and damaging and mon["species"] in SPECIES:
                stab = [m for m, d in damaging if d.get("type") in SPECIES[mon["species"]]["types"]]
                if not stab:
                    add(row, mon, "medium", "theming", "custom set has no damaging STAB move")
            if level <= 25 and SPECIES.get(mon["species"], {}).get("bst", 0) >= 540:
                add(row, mon, "medium", "power curve", f"BST {SPECIES[mon['species']]['bst']} species appears at level {level}")

            if row["class"] == "CHUCK" and row["id_num"] == 1 and mon["species"] == "BRELOOM":
                add(row, mon, "high", "moveset/cap", "Spore is on a level-34 mon while the player is capped at 31")
            if row["class"] == "CHUCK" and row["id_num"] == 1 and mon["species"] == "POLIWRATH":
                add(row, mon, "high", "moveset/cap", "level 35 versus cap 31, with Hypnosis + Mind Reader + DynamicPunch")

    order = {"critical": 0, "high": 1, "medium": 2, "low": 3}
    return sorted(flags, key=lambda x: (order[x["severity"]], x["level"], x["map"], x["trainer_id"]))


def leader_audit():
    specialties = {"FALKNER": "FLYING", "BUGSY": "BUG", "WHITNEY": "NORMAL", "MORTY": "GHOST",
                   "CHUCK": "FIGHTING", "JASMINE": "STEEL", "PRYCE": "ICE", "CLAIR": "DRAGON",
                   "BROCK": "ROCK", "MISTY": "WATER", "LT_SURGE": "ELECTRIC", "ERIKA": "GRASS",
                   "JANINE": "POISON", "SABRINA": "PSYCHIC", "BLAINE": "FIRE", "BLUE": None}
    out = []
    hard_caps = {"FALKNER": 10, "BUGSY": 16, "WHITNEY": 21, "MORTY": 26,
                 "CHUCK": 31, "JASMINE": 36, "PRYCE": 40, "CLAIR": 45}
    by_key = {(r["class"], r["id_num"]): r for r in ROWS}
    for klass, typ in specialties.items():
        row = by_key.get((klass, 1))
        if not row:
            continue
        off = []
        if typ:
            off = [m["species"] for m in row["mons"] if typ not in SPECIES.get(m["species"], {}).get("types", [])]
        cap = hard_caps.get(klass)
        out.append({"leader": klass, "specialty": typ, "hard_cap": cap,
                    "ace_minus_cap": row["max_level"] - cap if cap is not None else None,
                    "levels": [m["level"] for m in row["mons"]],
                    "species": [m["species"] for m in row["mons"]], "off_theme": off})
    return out


def main():
    caps = exp_cap_table()
    anomalies = anomaly_rows()
    leaders = leader_audit()
    (OUT / "static_audit.json").write_text(json.dumps({
        "map_references": len(ROWS), "first_encounters_estimate": len(FIRST),
        "exp_caps": caps, "leaders": leaders, "anomalies": anomalies,
    }, indent=2))
    with (OUT / "exp_caps.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=caps[0].keys()); w.writeheader(); w.writerows(caps)
    with (OUT / "trainer_anomalies.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=anomalies[0].keys()); w.writeheader(); w.writerows(anomalies)
    print(json.dumps({"references": len(ROWS), "first_encounters": len(FIRST),
                      "anomalies": Counter(a["severity"] for a in anomalies), "exp_caps": caps}, indent=2))


if __name__ == "__main__":
    main()
