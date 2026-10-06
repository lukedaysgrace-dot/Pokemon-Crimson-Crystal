"""Move-specific absorption, stat-boundary, and secondary-effect outcomes.

The move table supplies eligible moves. Expectations below describe outcomes,
not copies of the assembly implementation, and retain custom Flash Fire.
"""

import re
from symbols import ROOT
from effect_sweep import USER_STAGES, USER_MULTI, TARGET_STAGES, SECONDARY_STATUS


def move_records():
    pattern = re.compile(r"^\s*move\s+(EFFECT_\w+),\s*(\d+),\s*(\w+),\s*CATEGORIZE_(\w+),\s*(\d+),\s*(\d+),\s*(\d+);(\w+)\s*$")
    records = []
    for line in (ROOT / "data/moves/moves.asm").read_text().splitlines():
        match = pattern.match(line)
        if match:
            effect, power, kind, category, accuracy, pp, chance, name = match.groups()
            records.append(dict(effect=effect, power=int(power), type=kind,
                                category=category, accuracy=int(accuracy), pp=int(pp),
                                chance=int(chance), name=name))
    if len(records) != 421:
        raise RuntimeError(f"expected the complete move table, parsed {len(records)}")
    return records


def base(move, source="NO_ABILITY", target="NO_ABILITY", reverse=False):
    attacker = {"species": "MEW", "level": 30, "ability": source, "moves": [move["name"]]}
    defender = {"species": "MEW", "level": 100, "ability": target, "moves": ["SPLASH"]}
    test = {"player": defender if reverse else attacker,
            "enemy": attacker if reverse else defender,
            "rng": "forced_low", "weather": "none", "turns": 1,
            "assert": ["0 <= player.hp <= player.maxhp", "0 <= enemy.hp <= enemy.maxhp",
                       "wram('wInAbility') == 0", "(wram('wDisguiseBusted', 1) & 64) == 0"],
            "_file": "<generated move outcome matrix>"}
    if move["effect"] in {"EFFECT_FLY", "EFFECT_BOUNCE", "EFFECT_SKULL_BASH",
                           "EFFECT_SKY_ATTACK", "EFFECT_SOLARBEAM"}:
        test["turns"] = 2
    if move["name"] == "SOLAR_BLADE":
        test["weather"] = "sun"
        test["turns"] = 1
    return test


def generate_outcome_matrix():
    records = move_records()
    tests = []
    absorb = {"VOLT_ABSORB": ("ELECTRIC", "heal"),
              "LIGHTNING_ROD": ("ELECTRIC", 3), "MOTOR_DRIVE": ("ELECTRIC", 2),
              "WATER_ABSORB": ("WATER", "heal"), "STORM_DRAIN": ("WATER", 3),
              "DRY_SKIN": ("WATER", "heal"), "FLASH_FIRE": ("FIRE", 3),
              "SAP_SIPPER": ("GRASS", 0), "LEVITATE": ("GROUND", None)}
    for ability, (kind, reaction) in absorb.items():
        for move in records:
            if move["type"] != kind or not move["power"] or move["effect"] == "EFFECT_OHKO":
                continue
            for reverse in (False, True):
                side = "player" if reverse else "enemy"
                direction = "enemy" if reverse else "player"
                for source in ("NO_ABILITY", "MOLD_BREAKER", "NEUTRALIZING_GAS"):
                    control_id = f"outcome_absorb_{ability}_{move['name']}_{direction}_{source}"
                    control = base(move, source, reverse=reverse)
                    control[side]["hp"] = 50
                    control.update(name=f"Outcome absorb: {ability} {move['name']} {direction} {source} control", id=control_id)
                    control["assert"].append(f"{side}.hp < {side}.start_hp")
                    tests.append(control)
                    test = base(move, source, ability, reverse)
                    test[side]["hp"] = 50
                    test["name"] = f"Outcome absorb: {ability} {move['name']} {direction} {source}"
                    if source == "NO_ABILITY":
                        hp = f"min({side}.maxhp, {side}.start_hp + {side}.maxhp // 4)" if reaction == "heal" else f"{side}.start_hp"
                        test["assert"].append(f"{side}.hp == {hp}")
                        stages = [7] * 7
                        if isinstance(reaction, int):
                            stages[reaction] = 8
                        test["assert"] += [f"{side}.stat_levels == {stages}", f"{side}.status == 0"]
                    else:
                        # Flash Fire is a custom higher-offensive-stat boost;
                        # Gas/Mold comparisons still use the ordinary control.
                        for field in ("hp", "status", "stat_levels", "pp", "substatus"):
                            test["assert"].append(f"{side}.{field} == result('{control_id}')['{side}']['{field}']")
                    tests.append(test)

    # Pure stat moves: every move, every stage, both battle directions.
    for move in records:
        if move["category"] != "STATUS":
            continue
        changes = USER_MULTI.get(move["effect"])
        if move["effect"] in USER_STAGES:
            index, destination = USER_STAGES[move["effect"]]
            changes = {index: destination}
        target_change = TARGET_STAGES.get(move["effect"])
        if not changes and not target_change:
            continue
        for reverse in (False, True):
            actor = "enemy" if reverse else "player"
            recipient = ("player" if reverse else "enemy") if target_change else actor
            delta = {i: destination - 7 for i, destination in changes.items()} if changes else {target_change[0]: target_change[1] - 7}
            for stage in range(-6, 7):
                for ability in ("NO_ABILITY", "CONTRARY"):
                    test = base(move, reverse=reverse)
                    test[recipient]["ability"] = ability
                    # Set only affected stages so the fixture's accuracy is
                    # not accidentally reduced while testing another stat.
                    labels = ["atk", "def", "spd", "satk", "sdef", "acc", "eva"]
                    test[recipient]["stages"] = {labels[i]: stage for i in delta}
                    expected = [7] * 7
                    for i, amount in delta.items():
                        expected[i] = min(13, max(1, 7 + stage + (amount if ability == "NO_ABILITY" else -amount)))
                    test["name"] = f"Outcome stages: {move['name']} {actor} {ability} {stage:+d}"
                    test["assert"].append(f"{recipient}.stat_levels == {expected}")
                    tests.append(test)

    # Observable secondaries: every status/stat secondary represented in the
    # semantic effect map, with Sheer Force, Shield Dust, and bypass controls.
    for move in records:
        if not move["power"] or not move["chance"]:
            continue
        effect = move["effect"]
        status = SECONDARY_STATUS.get(effect)
        stage = TARGET_STAGES.get(effect) or USER_STAGES.get(effect)
        if not status and not stage:
            continue
        for source, target in (("NO_ABILITY", "NO_ABILITY"), ("NO_ABILITY", "SHIELD_DUST"),
                               ("MOLD_BREAKER", "SHIELD_DUST"), ("NEUTRALIZING_GAS", "SHIELD_DUST"),
                               ("SHEER_FORCE", "NO_ABILITY"), ("SHEER_FORCE", "NEUTRALIZING_GAS")):
            test = base(move, source, target)
            test["player"]["level"] = 50
            test["player"]["item"] = "LIFE_ORB"
            self_boost = effect in USER_STAGES
            blocked = source == "SHEER_FORCE" and target != "NEUTRALIZING_GAS"
            blocked |= target == "SHIELD_DUST" and source == "NO_ABILITY" and not self_boost
            test["name"] = f"Outcome secondary: {move['name']} {source} versus {target}"
            test["assert"].append("enemy.hp < enemy.start_hp")
            if status:
                test["assert"].append("enemy.status == 0 and (enemy.substatus[2] & 128) == 0" if blocked else status)
            if stage:
                side = "player" if self_boost else "enemy"
                expected = [7] * 7
                if not blocked:
                    expected[stage[0]] = stage[1]
                test["assert"].append(f"{side}.stat_levels == {expected}")
            # Sheer Force's Life Orb exception is checked against actual HP.
            if effect not in {"EFFECT_FLARE_BLITZ", "EFFECT_FLAME_WHEEL", "EFFECT_SACRED_FIRE"}:
                test["assert"].append("player.hp == player.start_hp" if source == "SHEER_FORCE" and target != "NEUTRALIZING_GAS" else "player.hp < player.start_hp")
            tests.append(test)
    return tests
