"""Every eligible damaging move against abilities reacting to incoming hits."""

from outcome_matrix import base, move_records


def generate_reaction_matrix():
    tests = []
    excluded = {"EFFECT_OHKO", "EFFECT_COUNTER", "EFFECT_MIRROR_COAT", "EFFECT_BIDE",
                "EFFECT_DREAM_EATER", "EFFECT_SUCKER_PUNCH", "EFFECT_FUTURE_SIGHT",
                "EFFECT_CIRCLE_THROW", "EFFECT_FORCE_SWITCH", "EFFECT_U_TURN"}
    for move in move_records():
        if not move["power"] or move["effect"] in excluded:
            continue
        reactions = [("STAMINA", {1: 1})]
        if move["category"] == "PHYSICAL":
            reactions.append(("WEAK_ARMOR", {1: -1, 2: 2}))
        if move["type"] == "DARK":
            reactions.append(("JUSTIFIED", {0: 1}))
        if move["type"] in ("DARK", "GHOST", "BUG"):
            reactions.append(("RATTLED", {2: 1}))
        if move["type"] == "FIRE":
            reactions.append(("THERMAL_EXCHANGE", {0: 1}))
        for source in ("NO_ABILITY", "MOLD_BREAKER", "NEUTRALIZING_GAS"):
            control_id = f"reaction_{move['name']}_{source}"
            control = base(move, source)
            if move["effect"] == "EFFECT_SNORE":
                control["player"]["status_byte"] = 3
            control.update(name=f"Reaction matrix: {move['name']} {source} control", id=control_id)
            tests.append(control)
            for ability, changes in reactions:
                test = base(move, source, ability)
                if move["effect"] == "EFFECT_SNORE":
                    test["player"]["status_byte"] = 3
                test["name"] = f"Reaction matrix: {move['name']} {source} versus {ability}"
                test["assert"].append("enemy.hp > 0")
                # Gas ends after the committed hit's defender reactions,
                # including Explosion/Selfdestruct, whose user already has 0 HP.
                suppressed = source == "NEUTRALIZING_GAS"
                for i in range(7):
                    delta = 0 if suppressed else changes.get(i, 0)
                    expected = f"min(13, max(1, result('{control_id}')['enemy']['stat_levels'][{i}] + {delta} * wram('wEnemyRageFistHits')))"
                    test["assert"].append(f"enemy.stat_levels[{i}] == {expected}")
                if suppressed:
                    test["assert"] += [f"enemy.hp == result('{control_id}')['enemy']['hp']",
                                       f"enemy.status == result('{control_id}')['enemy']['status']"]
                tests.append(test)
    return tests
