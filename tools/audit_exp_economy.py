#!/usr/bin/env python3
"""Audit first-clear trainer EXP and Hard Mode Stat EXP by accessible area.

Source data is read directly; phone rematches, mutually exclusive starter
variants and both halves of a Twins battle must never inflate the budget.
"""

import argparse
import math
import re
from itertools import permutations
from pathlib import Path
from functools import lru_cache

import audit_trainers as trainers

ROOT = Path(__file__).resolve().parent.parent


@lru_cache(None)
def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def load_data():
    species = trainers.constant_list("constants/pokemon_constants.asm", "NUM_POKEMON")
    moves = trainers.constant_list("constants/move_constants.asm", "NUM_ATTACKS")
    items = trainers.constant_list("constants/item_constants.asm", "NUM_ITEMS")
    classes, ids, aliases, owners = trainers.parse_trainer_constants()
    groups = trainers.parse_parties(set(species), set(moves), set(items))
    pointers = trainers.validate_group_pointers(classes, ids, aliases, owners, groups)
    parties = {}
    for cls, group in pointers.items():
        for tid in ids[cls]:
            parties[cls, tid] = groups[group][ids[cls].index(tid)]
        for tid, target in aliases[cls].items():
            original = owners[target]
            parties[cls, tid] = groups[group][ids[original].index(target)]
        # Rematch classes share a group but intentionally have no own IDs.
        if not ids[cls] and not aliases[cls]:
            for original, original_group in pointers.items():
                if original_group == group and ids[original]:
                    for i, tid in enumerate(ids[original]):
                        parties[cls, tid] = groups[group][i]
                    break
    stats = trainers.parse_base_stats(species)
    includes = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^"]+)"', read("data/pokemon/base_stats.asm"))
    base_exp = {}
    for mon, path in zip(species, includes):
        base_exp[mon] = int(re.search(r"db\s+(\d+)\s*; base exp", read(path))[1])
    stat_exp_values = [int(n) for n in re.findall(r"^\s*dw\s+(\d+)", read("data/trainers/stat_exp.asm"), re.M)]
    assert len(stat_exp_values) == len(classes) - 1
    assert all(0 <= n <= 65535 for n in stat_exp_values)
    stat_exp = dict(zip(classes[1:], stat_exp_values))
    caps = [int(n) for n in re.findall(r"^\s*db\s+(\d+)", read("engine/pokemon/experience.asm").split("HardModeLevelCaps:")[1].split("CalcExpAtLevel:")[0], re.M)]
    assert not trainers.ERRORS, "\n".join(trainers.ERRORS)
    return parties, stats, base_exp, stat_exp, caps


def map_trainers(parties):
    result = {}
    for path in sorted((ROOT / "maps").glob("*.asm")):
        seen = set()
        rows = []
        for match in re.finditer(r"^\s*trainer\s+(\w+),\s*(\w+),\s*(\w+)", path.read_text(encoding="utf-8"), re.M):
            cls, tid, event = match.groups()
            if event in seen:
                continue
            seen.add(event)
            assert (cls, tid) in parties, (path, cls, tid)
            rows.append((cls, tid, event))
        if rows:
            result[path.stem] = rows
    return result


def open_parties(parties):
    """Read the actual bounded overrides, including trainer/map identity."""
    text = read("data/trainers/open_progression.asm")
    records = {}
    for match in re.finditer(r"^(OpenParty_\w+):\n(.*?)(?=^\w+:|\Z)", text, re.M | re.S):
        directives = [(m[1], m[2].strip(), i) for i, m in enumerate(re.finditer(r"^\s*(db|dw)\s+([^;\n]+)", match[2], re.M), 1)]
        entry = {"directives": directives}
        trainers.parse_party_entry(ROOT / "data/trainers/open_progression.asm", entry,
                                   {m["species"] for p in parties.values() for m in p["mons"]},
                                   set(trainers.constant_list("constants/move_constants.asm", "NUM_ATTACKS")),
                                   set(trainers.constant_list("constants/item_constants.asm", "NUM_ITEMS")))
        records[match[1]] = entry
    selected = {}
    pattern = r"db GROUP_(\w+), MAP_\w+, (\w+), (\w+)\n\s*dw [^\n]+\n\s*dba (\w+)\n\s*dba (\w+)\n\s*dba (\w+)"
    # Map constants can be matched to filenames through data/maps/maps.asm.
    for match in re.finditer(pattern, text):
        map_const, cls, tid, *labels = match.groups()
        for tier, label in enumerate(labels):
            selected[map_const, cls, tid, tier] = records[label]
    return selected


@lru_cache(None)
def map_constant(name):
    names = dict(re.findall(r"^\s*map_attributes\s+(\w+),\s*(\w+)", read("data/maps/attributes.asm"), re.M))
    return names[name]


def build_campaign(parties, placements, overrides, order, kanto_order=("Erika", "Sabrina", "Janine"), early_lighthouse=False):
    """Conservative planned traversal, each first-clear event spent once.

    Optional off-path trainers are listed separately, never used to make a
    mainline checkpoint pass. Boss rewards do not fund their own preparation.
    """
    spent = set()
    def area(name, only=None, exclude=(), tier=None):
        result = []
        for cls, tid, event in placements.get(name, []):
            if event in spent or tid in exclude or (only is not None and tid not in only):
                continue
            spent.add(event)
            entry = overrides.get((map_constant(name), cls, tid, tier), parties[cls, tid])
            result.append((name, cls, tid, entry))
        return result
    def script(name, cls, tid, tier=None):
        assert re.search(rf"(?:loadtrainer|trainer)\s+{cls},\s*{tid}\b", read(f"maps/{name}.asm")), (name, cls, tid)
        entry = overrides.get((map_constant(name), cls, tid, tier), parties[cls, tid])
        return [(name, cls, tid, entry)]
    def areas(*names, **kwargs):
        return [row for name in names for row in area(name, **kwargs)]
    campaign = []
    def phase(name, badges, start, target, rows, boss):
        campaign.append(dict(name=name, badges=badges, start=start, target=target,
                             size=(2, 3, 4, 4, 5)[badges] if badges < 5 else 6,
                             rows=rows, boss=boss))
    # No Route 46 upper ledges, pre-Surf sisters, or Strength-side B1F hikers.
    phase("Falkner", 0, 5, 10,
          script("CherrygroveCity", "RIVAL1", "RIVAL1_1_CHIKORITA")
          + areas("Route30", "Route31", "SproutTower1F", "SproutTower2F", "SproutTower3F")
          + script("SproutTower3F", "ELDER", "LI")
          + script("VioletCity", "CRYSTAL", "CRYSTAL_1_CHIKORITA") + area("VioletGym"),
          script("VioletGym", "FALKNER", "FALKNER1"))
    phase("Bugsy", 1, 10, 16,
          areas("Route32", "UnionCave1F")
          + area("UnionCaveB1F", only={"ANDREW", "CALVIN"})
          + areas("Route33", "SlowpokeWellB1F", "AzaleaGym"),
          script("AzaleaGym", "BUGSY", "BUGSY1"))
    phase("Whitney", 2, 16, 20,
          script("AzaleaTown", "RIVAL1", "RIVAL1_2_CHIKORITA")
          + script("IlexForest", "CRYSTAL", "CRYSTAL_2_CHIKORITA")
          + area("IlexForest") + area("Route34", exclude={"IRENE", "JENN", "KATE"})
          + areas("GoldenrodUnderground", "GoldenrodGym"),
          script("GoldenrodGym", "WHITNEY", "WHITNEY1"))
    phase("Morty", 3, 20, 25,
          areas("Route35", "NationalPark", "Route36", "Route37", "BurnedTower1F")
          + script("BurnedTower1F", "RIVAL1", "RIVAL1_3_CHIKORITA")
          + area("EcruteakGym"), script("EcruteakGym", "MORTY", "MORTY1"))
    # Kimono challenge and Surf are available before Morty but are budgeted
    # after him, where Surf routes open. Leaving early EXP unspent is optional.
    kimono = [script("DanceTheatre", "KIMONO_GIRL", tid)[0]
              for tid in ("NAOKO2", "SAYO", "ZUKI", "KUNI", "MIKI", "FUYU", "HANA", "YUMI")]
    for tier, leader in enumerate(order):
        rows = kimono if tier == 0 else []
        if leader in {"Chuck", "Jasmine"}:
            rows = rows + areas("Route38", "Route39", tier=tier)
            if early_lighthouse:
                rows += areas("OlivineLighthouse2F", "OlivineLighthouse3F", "OlivineLighthouse4F", "OlivineLighthouse5F", tier=tier)
        if leader == "Chuck":
            rows += areas("Route40", "Route41", "CianwoodGym", tier=tier)
            rows += script("CianwoodCity", "CRYSTAL", "CRYSTAL_3_CHIKORITA", tier)
            # Eusine requires the legendary-beast side quest; excluded.
            boss = script("CianwoodGym", "CHUCK", "CHUCK1", tier)
        elif leader == "Jasmine":
            rows += areas("OlivineLighthouse2F", "OlivineLighthouse3F", "OlivineLighthouse4F", "OlivineLighthouse5F", "OlivineGym", tier=tier)
            boss = script("OlivineGym", "JASMINE", "JASMINE1", tier)
        else:
            rows += areas("Route42", "Route43", "TeamRocketBaseB1F", "TeamRocketBaseB2F", "TeamRocketBaseB3F", "MahoganyGym", tier=tier)
            rows += script("TeamRocketBaseB2F", "ARIANA", "ARIANA1", tier)
            rows += script("TeamRocketBaseB3F", "PETREL", "PETREL1", tier)
            boss = script("MahoganyGym", "PRYCE", "PRYCE1", tier)
        phase(f"{leader} ({tier + 1})", 4 + tier, (25, 30, 34)[tier], (30, 34, 38)[tier], rows, boss)
    phase("Clair", 7, 38, 45,
          areas("RadioTower1F", "RadioTower2F", "RadioTower3F", "RadioTower4F", "RadioTower5F", "GoldenrodUndergroundSwitchRoomEntrances", "GoldenrodUndergroundWarehouse", "Route44")
          + script("RadioTower5F", "PETREL_DIRECTOR", "PETREL_DIRECTOR1")
          + script("RadioTower5F", "ARCHER", "ARCHER2")
          + script("GoldenrodUndergroundSwitchRoomEntrances", "RIVAL1", "RIVAL1_4_CHIKORITA")
          + script("IcePath1F", "CRYSTAL2", "CRYSTAL2_4_CHIKORITA")
          + areas("BlackthornGym1F", "BlackthornGym2F"),
          script("BlackthornGym1F", "CLAIR", "CLAIR1"))
    phase("Brock", 8, 45, 50,
          areas("Route27", "Route26", "ViridianForest", "PewterGym"),
          script("PewterGym", "BROCK", "BROCK1"))
    phase("Misty", 9, 50, 54,
          areas("Route3", "Route4", "Route9", "Route25", "CeruleanGym")
          + script("MountMoon", "RIVAL2", "RIVAL2_1_CHIKORITA")
          + script("Route24", "GRUNTM", "GRUNTM_31")
          + script("Route25", "COOLTRAINERM", "KEVIN"),
          script("CeruleanGym", "MISTY", "MISTY1"))
    phase("Surge", 10, 54, 58, areas("Route6", "VermilionGym"),
          script("VermilionGym", "LT_SURGE", "LT_SURGE1"))
    # Test all six orders, including going directly into Sabrina's gym after
    # Surge. Do not fund preparation by sweeping the other two gyms first.
    for i, leader in enumerate(kanto_order):
        if leader == "Erika":
            rows = areas("Route7", "CeladonGym")
            boss = script("CeladonGym", "ERIKA", "ERIKA1")
        elif leader == "Sabrina":
            rows = area("SaffronGym")
            boss = script("SaffronGym", "SABRINA", "SABRINA1")
        else:
            rows = areas("Route12", "Route13", "Route14", "Route15")
            rows += [script("FuchsiaGym", "NINJA", f"NINJA{j}")[0] for j in range(1, 5)]
            boss = script("FuchsiaGym", "JANINE", "JANINE1")
        phase(leader, 11 + i, 58 if i == 0 else 62, 62, rows, boss)
    phase("Blaine", 14, 62, 66, areas("Route19", "Route20", "SeafoamGym"),
          script("SeafoamGym", "BLAINE", "BLAINE1"))
    phase("Blue", 15, 66, 69, areas("Route21", "Route1", "ViridianGym"),
          script("ViridianGym", "BLUE", "BLUE1"))
    phase("League", 16, 69, 73, area("VictoryRoad")
          + script("VictoryRoad", "RIVAL1", "RIVAL1_5_CHIKORITA"),
          script("LoreleisRoom", "LORELEI", "LORELEI1") + script("KogasRoom", "KOGA", "KOGA1")
          + script("BrunosRoom", "BRUNO", "BRUNO1") + script("KarensRoom", "KAREN", "KAREN1")
          + script("LancesRoom", "CHAMPION", "LANCE"))
    return campaign


def exp_at(level, growth="slow"):
    if level == 1:
        return 0
    if growth == "slow":
        return 5 * level ** 3 // 4
    if growth == "medium_slow":
        return 6 * level ** 3 // 5 - 15 * level ** 2 + 100 * level - 140
    return level ** 3


def policies():
    table = read("engine/pokemon/experience.asm").split("HardModeTrainerExpMultipliers:")[1].split("assert")[0]
    factors = [int(n) for line in table.splitlines() if line.strip().startswith("db ")
               for n in line.split(";", 1)[0].strip()[3:].split(",")]
    limits = [(int(a), int(b)) for a, b in re.findall(r"db\s+(\d+)\s*\n\s*dw\s+(\d+)", read("data/trainers/stat_exp_limits.asm"))]
    assert len(factors) == 17 and all(1 <= f <= 32 for f in factors)
    assert limits[-1][0] == 255
    assert all(a[0] < b[0] and a[1] <= b[1] for a, b in zip(limits, limits[1:]))
    return factors, limits


def stat_points(value):
    return min(255, math.isqrt(value) + (math.isqrt(value) ** 2 != value)) // 4


@lru_cache(None)
def matching_policies():
    rows = re.findall(r"^\s*db\s+(\w+),\s*(\d+)", read("data/trainers/stat_exp_matching.asm"), re.M)
    assert len(rows) == len(dict(rows)), "Duplicate matching class"
    policies = {cls: int(bonus) for cls, bonus in rows}
    assert all(bonus in (0, 2) for bonus in policies.values())
    assert all(policies[cls] == 0 for cls in ("COOLTRAINERM", "COOLTRAINERF", "DUELIST"))
    return policies


def matched_stat_exp(value, bonus):
    if bonus == 0:
        return value
    points = min(63, stat_points(value) + bonus)
    return 65535 if points == 63 else (4 * points) ** 2


def level_at(experience, growth):
    return max(n for n in range(1, 101) if exp_at(n, growth) <= experience)


def trainer_multiplier(badges, map_name, factors):
    if map_name == "OlivineGym" and badges in (5, 6):
        local = re.search(r"HardModeJasmineGymExpMultipliers:.*?db\s+(\d+),\s*(\d+)", read("engine/pokemon/experience.asm"), re.S)
        return int(local[badges - 4])
    return factors[badges]


def projection(campaign, base_exp, stats, factors, growth="slow", yield_fraction=1, observer=None):
    """Rotate a single living recipient to the lowest-EXP slot after each KO.

    The 80% run is a reward haircut, not a claim that every arbitrary set of
    80% of trainers is accessible. Split participation/Share round differently.
    Recruits join at the prior checkpoint; no trades, Egg, vitamins or Pokerus.
    """
    experience = []
    training = []
    results = []
    for phase in campaign:
        while len(experience) < phase["size"]:
            experience.append(exp_at(phase["start"], growth))
            training.append([0] * 5)
        cap = phase["target"] if phase["badges"] < 16 else 100
        def fight(rows):
            for map_name, trainer_class, trainer_id, entry in rows:
                if observer is not None:
                    observer(phase, map_name, trainer_class, trainer_id, entry, training)
                for mon in entry["mons"]:
                    slot = min(range(len(experience)), key=lambda i: (experience[i], sum(training[i])))
                    bs = stats[mon["species"]]
                    for j, value in enumerate(bs[:5]):
                        training[slot][j] = min(65535, training[slot][j] + int(value * yield_fraction))
                    if experience[slot] >= exp_at(cap, growth):
                        continue
                    reward = base_exp[mon["species"]] * mon["level"] // 7
                    reward = min(65535, reward * trainer_multiplier(phase["badges"], map_name, factors))
                    experience[slot] = min(exp_at(cap, growth), experience[slot] + int(reward * yield_fraction))
        fight(phase["rows"])
        levels = [level_at(x, growth) for x in experience]
        points = [stat_points(x) for member in training for x in member]
        results.append(dict(name=phase["name"], badges=phase["badges"], size=phase["size"],
                            target=phase["target"], trainers=len(phase["rows"]),
                            level_min=min(levels), level_max=max(levels),
                            points_min=min(points), points_max=max(points),
                            training=[list(member) for member in training]))
        fight(phase["boss"])
    return results


def report(parties, stats, base_exp, class_exp, caps, placements, overrides):
    factors, limits = policies()
    campaigns = []
    for order in permutations(("Chuck", "Jasmine", "Pryce")):
        for kanto in permutations(("Erika", "Sabrina", "Janine")):
            for early_lighthouse in (False, True):
                campaign = build_campaign(parties, placements, overrides, order, kanto, early_lighthouse)
                for phase in campaign:
                    if phase["badges"] < 16:
                        assert phase["target"] == caps[phase["badges"]]
                campaigns.append(campaign)
    results = {}
    failures = []
    for growth in ("slow", "medium_slow", "medium_fast"):
        for haircut in (1, .8):
            for campaign in campaigns:
                projected = projection(campaign, base_exp, stats, factors, growth, haircut)
                for phase, value in zip(campaign, projected):
                    results.setdefault(phase["name"], []).append(value)
                    if value["level_min"] < phase["target"] - 1:
                        failures.append(f"{growth}/{haircut}: {phase['name']} {value['level_min']} vs {phase['target']}")
    lines = ["# Experience and trainer Stat EXP balance", "",
             "This audit preserves the Kanto access flags and the cap schedule. Kanto is Brock, Misty, Surge, then Erika/Janine/Sabrina in any order, Blaine (badge 15), Blue (badge 16).",
             "", "## Assumptions and access", "",
             "Party size is 2 for Falkner, 3 for Bugsy, 4 for Whitney/Morty, 5 for gym 5, and 6 from gym 6. Recruits join near the previous checkpoint. The projections rotate the lowest-EXP living member into battle. They cover all six Johto branch orders and all six central Kanto orders, both early and delayed Lighthouse clears, across Slow, Medium Slow, and Medium Fast growth, at full rewards and with a 20% reward haircut. They do not guarantee arbitrary teams, skipped routes, fainted recipients, or late low-level replacements.", "",
             "Only first clears count. Twins share one defeated flag; only one starter variant counts. Phone rematches, Trainer House, lottery rewards, night-only officers, wild encounters, vitamins, trades, Lucky Egg, and Rare Candies contribute nothing to the mainline budget. Boss rewards do not fund preparation for that boss. Level caps discard surplus EXP rather than carrying it into the next checkpoint.", "",
             "Route 45/46's optional downhill trainers do not fund Brock. Dragon's Den trainers are excluded from Brock's budget because they can be fought before the shrine actually awards Clair's badge (still cap 45). Union Cave B1F only supplies the two southern Pokemaniacs before Surf/Strength; northern hikers and B2F are optional. Route 34's Surf sisters are excluded before Morty. Lighthouse and Rocket Hideout parties use the actual open-tier overrides; west-route and Lighthouse flags are spent once. In the early-clear case, the Lighthouse is already exhausted before Chuck, so a later Jasmine only has her gym trainers left. The S.S. Aqua is unavailable until Surge and never funds Brock or Misty. Victory Road is unavailable until sixteen badges and never funds Blue.", "",
             "Surge's budget uses Route 6 and his gym alone. Route 10 South, Route 11, Lavender's EXPN Card detour, and Snorlax are available alternatives, but do not have to be cleared before his gym.", "",
             "The three central Kanto gyms are checked separately in all six orders. In particular, Sabrina can be challenged directly after Surge without first clearing Erika's or Janine's approach. Southern sea routes only fund Blaine after all three central badges. Route 21/1 and Viridian Gym fund Blue.", "",
             "## Mainline projections", "",
             "Ranges below combine all orders, growth rates and reward scenarios. These are source-driven projections, not an end-to-end emulator playthrough. The level-73 League row is a preparation target; the progression cap has ended at sixteen badges (maximum 100).", "",
             "| Checkpoint | Party | Target | Projected levels | Hard trainer multiplier |",
             "|---|---:|---:|---:|---:|"]
    ordered = sorted(results.items(), key=lambda item: min(v['badges'] for v in item[1]))
    for name, values in ordered:
        sample = values[0]
        phase_factors = [trainer_multiplier(v['badges'], "OlivineGym" if name.startswith("Jasmine") else "", factors) for v in values]
        factor_range = str(min(phase_factors)) if min(phase_factors) == max(phase_factors) else f"{min(phase_factors)}–{max(phase_factors)}"
        lines.append(f"| {name} | {sample['size']} | {sample['target']} | {min(v['level_min'] for v in values)}–{max(v['level_max'] for v in values)} | {factor_range}× |")
    lines += ["", "Jasmine's second/third-position gym has a local reward allowance because its three trainers may be the only unspent training left after an early Lighthouse clear. The rest of open Johto retains its 4×/6×/8× progression. Surplus EXP stops at the current cap; it does not carry into later badges."]
    lines += ["", "## Trainer Stat EXP", "",
              "Two restored Burned Tower trainers still had their old level-15–17 parties on the level-20–25 Ecruteak approach. Ned now uses levels 21/22/21, and Dick's Charmeleon is 23. Species, party sizes, and scripts are preserved; Dick's optional encounter is not needed for the EXP projection.", "",
              "Player Stat EXP comes from the defeated species' base stats, not from the opponent's own training. EXP multipliers do not multiply Stat EXP. The engine uses ceil(sqrt(Stat EXP)), capped at 255, then divides by four; its contribution scales with level. All comparisons here use those training points, not a promise of an exact final-stat difference (the full formula rounds together).", "",
              "The final policy replaces fixed training on important characters with party matching. At battle initialization, each of the five Stat EXP words uses the highest corresponding word among the player's non-Egg party, including fainted members. Leaders, rivals, Rocket admins, League members, rematches and superbosses get exactly two additional training points, saturating at 63. Kimono Girls, Eusine, Cal, Sprout Tower's Elder and the Karate King use that same small advantage. Levels, species, moves, DVs, access flags and the cap schedule never scale.", "",
              "Both Cooltrainer classes and Duelist copy those five maximum words exactly, with no rounding or bonus. No party average or estimated campaign amount is used: a focused starter, vitamins, optional battles, Pokerus, and EXP Relay are reflected in the actual values. A low-training replacement or Egg cannot dilute the match. Changing the party changes the next battle's snapshot; later switches inside a battle do not rebuild the opposing party.", "",
              "For every player word from 0 through 65,535, the major-character result is never lower than the player, and its training-point advantage is exactly min(2, 63 - player_points). At equal levels this adds at most two actual stat points, depending on formula rounding. Fully trained players are matched at the maximum. This guarantees parity against the most-trained party member in each stat; members with less training can still trail that benchmark. Different species, levels, DVs, abilities and items still affect battle strength separately.", "",
              "Normal Mode retains zero trainer Stat EXP. Other ordinary classes remain zero; themed generics retain authored level-bounded amounts. Link and Battle Tower parties are not overwritten. Matching values are written before the ordinary stat calculation, so both initial stats and later recalculation/Transform paths see the same training words.", "",
              "| Class | Hard Mode training policy |", "|---|---|"]
    for cls, bonus in matching_policies().items():
        lines.append(f"| {cls} | {'Exact party match' if bonus == 0 else 'Party maximum + 2 training points'} |")
    lines += ["", "The earlier fixed Blaine value of 18,496 is no longer used. For example, a maximum player word of 10,000 (25 training points) produces 11,664 (27 points) for Blaine. A word of 25,000 (39 points) produces 26,896 (41 points). Thus he remains just above both a rotating team and a more heavily trained starter instead of assuming they have the same training.", "",
              "The rotation-only estimates below remain useful context, but no longer determine boss fairness. They exclude optional encounters, wild training and vitamins, so they are not measured real-playthrough averages. A starter-focused distribution can exceed them substantially. Newly recruited team members start with zero training in the projection.", "",
              "| Checkpoint | Player training points |", "|---|---:|"]
    for name, values in ordered:
        lines.append(f"| {name} | {min(v['points_min'] for v in values)}–{max(v['points_max'] for v in values)} |")
    lines += ["", "## Optional areas and postgame", "",
              "Optional trainers were inventoried but are extra headroom: Lake of Rage's Surf side, Shiver Isle, Surf-side Union Cave, Mount Mortar, Ruins of Alph, Silent Crypt, Wise Trio, the Fighting Dojo, the Riolu rescue, time-dependent officers and Jaime, S.S. Aqua sailing rosters, the Route 25 Crystal finale (requires Erika), and the Snorlax/Chantz challenge. None is required to make the mainline EXP screen pass.", "",
              "After the first League, all eight Johto rematches unlock; all eight must be won before the League rematch and the Plateau Silver ambush. Rematches run approximately levels 75–87; Mt. Silver Red is 88–90. Green requires Red, Blue Cloak requires Red plus Green, and Pallet's Red requires Blue Cloak. Every one of these important characters uses the same party-maximum-plus-two rule; no large fixed endgame training bonus remains.", "",
              "There is no progression cap after badge sixteen: 100 is the system maximum, not a requirement before the level-70s League or level-80s rematches. Forcing a full party to 100 there would erase the intended difficulty. Optional first clears and the party-level-scaled Trainer House provide postgame preparation. Hard Mode champions can now repeat the Trainer House immediately; its once-per-day restriction remains in Normal Mode and before the first League. This adds no flags and changes no Kanto access gates. The report below measures that repeatable fallback explicitly; it does not pretend unused optional trainers are guaranteed to remain. These are aggregate estimates; uneven recipients and rewards lost at target levels can require an extra battle.", "",
              "| Six Slow-growth mons | Trainer House fallback battles (8×, no Egg/trade) |",
              "|---|---:|"]
    for start, target in ((73, 77), (77, 84), (84, 87), (87, 90), (90, 100)):
        tid = "CAL6" if start >= 80 else "CAL5" if start >= 70 else "CAL4" if start >= 60 else "CAL3"
        entry = parties["CAL", tid]
        reward = sum(min(65535, base_exp[m["species"]] * m["level"] // 7 * factors[16]) for m in entry["mons"])
        required = 6 * (exp_at(target) - exp_at(start))
        lines.append(f"| {start} → {target} | {math.ceil(required / reward)} |")
    lines += ["", "## Verification", "",
              f"Source screen: 36 badge-order combinations × 2 Lighthouse timings × 3 growth rates × 2 reward scenarios; {len(failures)} checkpoints more than one level below target.", "",
              "The capped-participant Stat EXP duplication bug is fixed: stat awards divide among all living participants, while regular EXP only divides among participants still below cap. Previously, capped participants were omitted from both divisors but still awarded Stat EXP, so switching could multiply training. EXP Share's separate half-award passes retain the same rule and normal integer truncation.", "",
              "Run `python3 tools/audit_exp_economy.py --check` to reproduce the projection, or add `--write` to refresh this report. `--inventory` lists placed and scripted rosters. ROM arithmetic and party-loading regression checks are in `tools/battletest/exp_economy_checks.py`.", ""]
    return "\n".join(lines), failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", action="store_true")
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    parties, stats, base_exp, stat_exp, caps = load_data()
    maps = map_trainers(parties)
    if not args.inventory:
        overrides = open_parties(parties)
        text, failures = report(parties, stats, base_exp, stat_exp, caps, maps, overrides)
        if args.write:
            (ROOT / "docs/experience-balance.md").write_text(text, encoding="utf-8")
        print(text if not args.check else text.split("## Verification")[1])
        for failure in failures[:30]:
            print("FAIL:", failure)
        return bool(failures)
    for name, rows in maps.items():
        mons = [m for cls, tid, _ in rows for m in parties[cls, tid]["mons"]]
        exp = sum(base_exp[m["species"]] * m["level"] // 7 * 2 for m in mons)
        print(f"{name:32} {len(rows):2} trainers {min(m['level'] for m in mons):2}-{max(m['level'] for m in mons):2} 2x reference EXP {exp:6}")
    print("SCRIPTED")
    for path in sorted((ROOT / "maps").glob("*.asm")):
        text = path.read_text(encoding="utf-8")
        placed = {(c, t) for c, t, _ in maps.get(path.stem, [])}
        loads = list(dict.fromkeys(re.findall(r"^\s*loadtrainer\s+(\w+),\s*(\w+)", text, re.M)))
        loads = [(c, t) for c, t in loads if (c, t) not in placed]
        if loads:
            print(path.stem, ", ".join(f"{c}/{t}:{min(m['level'] for m in parties[c,t]['mons'])}-{max(m['level'] for m in parties[c,t]['mons'])}" for c,t in loads))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
