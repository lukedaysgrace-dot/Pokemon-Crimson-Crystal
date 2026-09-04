#!/usr/bin/env python3
"""Audit the Hard Mode exp economy: is there enough EXP in the game to
actually reach each badge's level cap without grinding wild Pokemon?

Compares, per badge segment, the one-time EXP available from trainer battles
against the EXP a team of N Pokemon needs to climb from the previous cap to
the current one.
"""

import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

def _load_caps():
    """Read the live caps out of the engine so this tool cannot drift."""
    src = (ROOT / "engine/pokemon/experience.asm").read_text(errors="replace")
    body = src.split("HardModeLevelCaps:", 1)[1]
    out = []
    for line in body.splitlines()[1:]:
        m = re.match(r"\s*db\s+(\d+)", line)
        if not m:
            if line.strip().startswith("db "):
                break          # MAX_LEVEL: end of the capped run
            continue
        out.append(int(m.group(1)))
    return out


CAPS = _load_caps()
LEADERS = ["Falkner", "Bugsy", "Whitney", "Morty", "Chuck", "Jasmine", "Pryce", "Clair"]

# (a, b, c, d, e) -> (a/b)*n^3 + c*n^2 + d*n - e
GROWTH = {
    "GROWTH_MEDIUM_FAST":    (1, 1,   0,   0,   0),
    "GROWTH_SLIGHTLY_FAST":  (3, 4,  10,   0,  30),
    "GROWTH_SLIGHTLY_SLOW":  (3, 4,  20,   0,  70),
    "GROWTH_MEDIUM_SLOW":    (6, 5, -15, 100, 140),
    "GROWTH_FAST":           (4, 5,   0,   0,   0),
    "GROWTH_SLOW":           (5, 4,   0,   0,   0),
}


def exp_at(level, rate="GROWTH_MEDIUM_SLOW"):
    a, b, c, d, e = GROWTH[rate]
    if level <= 1:
        return 0
    n = level
    return int((a * n**3) // b + c * n**2 + d * n - e)


def load_base_stats():
    """species name -> (base_exp, growth_rate)"""
    out = {}
    for f in sorted((ROOT / "data/pokemon/base_stats").glob("*.asm")):
        text = f.read_text(errors="replace")
        m_exp = re.search(r"db\s+(\d+)\s*;\s*base exp", text)
        m_gr = re.search(r"db\s+(GROWTH_\w+)\s*;\s*growth rate", text)
        if m_exp:
            out[f.stem.upper()] = (
                int(m_exp.group(1)),
                m_gr.group(1) if m_gr else "GROWTH_MEDIUM_SLOW",
            )
    return out


def load_trainers():
    """-> list of (group, label, [(level, species), ...])"""
    text = (ROOT / "data/trainers/parties.asm").read_text(errors="replace")
    lines = text.splitlines()
    trainers, cur = [], None
    group = "?"
    for i, line in enumerate(lines):
        s = line.strip()
        gm = re.match(r"^(\w+)Group:", s)
        if gm:
            group = gm.group(1)
            continue
        if s.startswith("next_list_item"):
            if cur:
                trainers.append(cur)
            label = s.split(";", 1)[1].strip() if ";" in s else "?"
            cur = (group, label, [])
            continue
        if cur is None:
            continue
        lm = re.match(r"^db\s+(\d+)\s*(;.*)?$", s)
        if lm:
            nxt = lines[i + 1].strip() if i + 1 < len(lines) else ""
            sm = re.match(r"^dw\s+([A-Z][A-Z0-9_]*)\s*(;.*)?$", nxt)
            if sm:
                cur[2].append((int(lm.group(1)), sm.group(1)))
    if cur:
        trainers.append(cur)
    return [t for t in trainers if t[2]]


def load_wild_yields():
    """level -> list of raw EXP yields for wild mons around that level."""
    base = load_base_stats()
    out = {}
    for name in ("johto_grass.asm", "johto_water.asm"):
        f = ROOT / "data/wild" / name
        if not f.exists():
            continue
        for lvl, spc in re.findall(r"dbw\s+(\d+),\s*([A-Z][A-Z0-9_]*)",
                                   f.read_text(errors="replace")):
            lvl, spc = int(lvl), spc
            if spc in base:
                out.setdefault(lvl, []).append(base[spc][0] * lvl // 7)
    return out


def main():
    base = load_base_stats()
    trainers = load_trainers()
    wild = load_wild_yields()
    unknown = set()

    def yield_for(party):
        """Total EXP a party hands over, gen-2 formula with the trainer 1.5x."""
        total = 0
        for lvl, spc in party:
            if spc not in base:
                unknown.add(spc)
                continue
            base_exp = base[spc][0]
            total += (base_exp * lvl // 7) * 2
        return total

    # Bucket trainers into badge segments by their highest party level.
    seg_exp = defaultdict(int)
    seg_count = defaultdict(int)
    postgame = 0
    for group, label, party in trainers:
        top = max(l for l, _ in party)
        if top > CAPS[-1]:
            postgame += 1
            continue
        seg = next(i for i, c in enumerate(CAPS) if top <= c)
        seg_exp[seg] += yield_for(party)
        seg_count[seg] += 1

    print(f"Parsed {len(trainers)} trainer parties "
          f"({postgame} above the Clair cap, treated as post-game/rematch).")
    if unknown:
        print(f"WARNING: {len(unknown)} unresolved species: "
              f"{sorted(unknown)[:8]}")
    print()

    for team_size in (4, 6):
        print(f"=== Team of {team_size} ===")
        print(f"{'Segment':<22}{'trn':>5}{'EXP avail':>12}"
              f"{'EXP needed':>12}{'ratio':>8}")
        cumulative_avail = 0
        cumulative_need = 0
        for i, cap in enumerate(CAPS):
            prev = CAPS[i - 1] if i else 5   # assume ~level 5 start
            need = team_size * (exp_at(cap) - exp_at(prev))
            avail = seg_exp[i]
            cumulative_avail += avail
            cumulative_need += need
            ratio = avail / need if need else float("inf")
            flag = ""
            if ratio < 1.0:
                band = [y for lv, ys in wild.items()
                        if prev <= lv <= cap for y in ys]
                avg = sum(band) / len(band) if band else 0
                grind = int((need - avail) / avg) if avg else 0
                flag = f"  <-- SHORT, ~{grind} wild battles to close"
            print(f"{LEADERS[i]:<22}{seg_count[i]:>5}{avail:>12,}"
                  f"{need:>12,}{ratio:>7.2f}x{flag}")
        cum = cumulative_avail / cumulative_need
        print(f"{'CUMULATIVE':<22}{sum(seg_count.values()):>5}"
              f"{cumulative_avail:>12,}{cumulative_need:>12,}{cum:>7.2f}x")
        print()

    print("Notes:")
    print(" - EXP needed uses the Medium Slow curve (the common case for")
    print("   fully-evolved starters and most mid-game lines).")
    print(" - EXP available counts trainer battles only. Wild encounters are")
    print("   unbounded, so a ratio below 1.00x means 'the player must grind")
    print("   wild Pokemon to reach this cap', not 'the cap is unreachable'.")
    print(" - Segments are assigned by a party's top level, a proxy for where")
    print("   the trainer is actually fought.")
    print(" - The per-segment ratio treats segments as independent. They are")
    print("   not: a deficit carries forward into the next segment. See the")
    print("   simulation below for the truer picture.")
    print()
    report_simulation(trainers, base)
    print(" - Participant division does NOT change these totals: the pool is")
    print("   split among participants, and mons already at cap are excluded")
    print("   from the divisor, so no EXP is wasted. Only distribution shifts.")


def simulate(seg_parties, team=6, boost="flat15", skip=0.0):
    """Walk the game in order, tracking the team's level. More truthful than
    the per-segment ratio: a deficit carries forward, a surplus does not
    (EXP is clamped at the cap), so segments are not independent."""
    def level_of(e):
        l = 5
        while l < 100 and exp_at(l + 1) <= e:
            l += 1
        return l

    exp = exp_at(5)
    out = []
    for i, cap in enumerate(CAPS):
        for top, raw in sorted(seg_parties[i]):
            if skip and (hash((i, top, raw)) % 100) / 100 < skip:
                continue
            lvl = level_of(exp)
            if lvl >= cap:
                continue
            if boost == "flat15":
                m = 1.5
            elif boost == "flat20":
                m = 2.0
            elif boost == "catchup":
                d = cap - lvl
                m = 1.5 if d <= 2 else (2.0 if d <= 5 else 3.0)
            exp = min(exp + int(raw * m / team), exp_at(cap))
        out.append(level_of(exp))
    return out


def report_simulation(trainers, base):
    seg = defaultdict(list)
    for _, _, party in trainers:
        top = max(l for l, _ in party)
        if top > CAPS[-1]:
            continue
        i = next(k for k, c in enumerate(CAPS) if top <= c)
        seg[i].append((top, sum(base[s][0] * lv // 7
                                for lv, s in party if s in base)))

    print("=== Simulated team level on arrival at each gym ===")
    print("(deficit vs cap in parentheses; negative = arrives underleveled)")
    for team in (4, 6):
        for skip in (0.0, 0.25):
            print(f"\n  team of {team}, {int(skip * 100)}% of trainers skipped")
            print(f"    {'':<11}" + "".join(f"{n[:5]:>9}" for n in LEADERS))
            print(f"    {'cap':<11}" + "".join(f"{c:>9}" for c in CAPS))
            for mode, lab in (("flat15", "1.5x (old)"),
                              ("flat20", "2x (LIVE)"),
                              ("catchup", "catch-up")):
                r = simulate(seg, team, mode, skip)
                cells = "".join(f"{v:>5}{v - c:>+4}" for v, c in zip(r, CAPS))
                print(f"    {lab:<11}" + cells)
    print("\n  catch-up curve: 1.5x within 2 levels of cap, 2x at 3-5 under,")
    print("  3x at 6+ under. Spends the bonus only where the player is behind.")
    print()


if __name__ == "__main__":
    sys.exit(main())
