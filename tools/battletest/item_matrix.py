"""Held-item and contact interactions across eligible damaging moves."""

from copy import deepcopy

from outcome_matrix import base, move_records


def generate_item_matrix():
    tests = []
    for move in move_records():
        if not move["power"] or move["effect"] in {"EFFECT_OHKO", "EFFECT_COUNTER", "EFFECT_MIRROR_COAT", "EFFECT_BIDE", "EFFECT_DREAM_EATER", "EFFECT_SUCKER_PUNCH", "EFFECT_FUTURE_SIGHT"}:
            continue
        # Fixed damage has its own item rules and is asserted by the existing
        # YAML suite. Here we compare ordinary hit/item activation outcomes.
        control_id = f"items_klutz_{move['name']}"
        control = base(move)
        if move["name"] == "ACROBATICS":
            # An inactive held item remains held; Klutz does not grant the
            # empty-item Acrobatics bonus. Compare with an inert held item.
            control["player"]["item"] = "FLOWER_MAIL"
        if move["effect"] == "EFFECT_SNORE":
            control["player"]["status_byte"] = 3
        if move["effect"] == "EFFECT_U_TURN":
            control["player2"] = {"species": "SNORLAX", "level": 100, "moves": ["SPLASH"]}
        control.update(name=f"Item matrix: {move['name']} Klutz control", id=control_id)
        tests.append(control)
        test = base(move, "KLUTZ")
        if move["effect"] == "EFFECT_SNORE":
            test["player"]["status_byte"] = 3
        if move["effect"] == "EFFECT_U_TURN":
            test["player2"] = {"species": "SNORLAX", "level": 100, "moves": ["SPLASH"]}
        test["player"]["item"] = "LIFE_ORB"
        test["name"] = f"Item matrix: {move['name']} Klutz disables Life Orb"
        for side in ("player", "enemy"):
            for field in ("hp", "status", "stat_levels", "species", "pp"):
                test["assert"].append(f"{side}.{field} == result('{control_id}')['{side}']['{field}']")
        tests.append(test)

        if move["effect"] == "EFFECT_SELFDESTRUCT":
            continue
        control_id = f"items_magic_guard_{move['name']}"
        control = base(move, "MAGIC_GUARD")
        if move["effect"] == "EFFECT_SNORE":
            control["player"]["status_byte"] = 3
        if move["effect"] == "EFFECT_U_TURN":
            control["player2"] = {"species": "SNORLAX", "level": 100, "moves": ["SPLASH"]}
        control.update(name=f"Item matrix: {move['name']} Magic Guard control", id=control_id)
        tests.append(control)
        held_control_id = control_id
        if move["name"] == "KNOCK_OFF":
            # Knock Off gains power against a held item independently of the
            # item's active effect, including when Klutz suppresses it.
            held_control = deepcopy(control)
            held_control_id += "_held"
            held_control["enemy"]["item"] = "BERRY"
            held_control.update(name="Item matrix: KNOCK_OFF Magic Guard held-item control", id=held_control_id)
            tests.append(held_control)
        for ability, item in (("IRON_BARBS", "NO_ITEM"), ("NO_ABILITY", "ROCKY_HELMET"),
                              ("IRON_BARBS", "ROCKY_HELMET"), ("KLUTZ", "ROCKY_HELMET")):
            test = base(move, "MAGIC_GUARD", ability)
            if move["effect"] == "EFFECT_SNORE":
                test["player"]["status_byte"] = 3
            if move["effect"] == "EFFECT_U_TURN":
                test["player2"] = {"species": "SNORLAX", "level": 100, "moves": ["SPLASH"]}
            test["enemy"]["item"] = item
            test["name"] = f"Item matrix: {move['name']} Magic Guard versus {ability}/{item}"
            expected_control = held_control_id if item != "NO_ITEM" else control_id
            for side in ("player", "enemy"):
                for field in ("hp", "status", "stat_levels", "species"):
                    test["assert"].append(f"{side}.{field} == result('{expected_control}')['{side}']['{field}']")
            tests.append(test)
    return tests
