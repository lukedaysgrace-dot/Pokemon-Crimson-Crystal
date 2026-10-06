"""Long battles with state checks at every completed turn."""

from copy import deepcopy

from symbols import Constants
from interaction_sweep import generate_interaction_tests


INVARIANTS = ["0 <= player.hp <= player.maxhp", "0 <= enemy.hp <= enemy.maxhp",
              "wram('wInAbility') == 0", "(wram('wDisguiseBusted', 1) & 64) == 0",
              "(player.status & 7) == 0 or (player.status & 120) == 0",
              "(enemy.status & 7) == 0 or (enemy.status & 120) == 0"] + [
    f"1 <= {side}.stat_levels[{i}] <= 13" for side in ("player", "enemy") for i in range(7)]


def generate_long_tests():
    con = Constants()
    tests = []
    abilities = [name for _, name in sorted(con.abilities_by_id.items())
                 if name not in ("NO_ABILITY", "NUM_ABILITIES")]
    for index, ability in enumerate(abilities):
        species = next((species for species, slots in con.species_abilities.items()
                        if ability in slots and species in con.species), "MEW")
        for reverse in (False, True):
            holder = {"species": species, "level": 100, "ability": ability, "moves": ["SPLASH"]}
            other = {"species": "MEW", "level": 100, "ability": "NO_ABILITY", "moves": ["SPLASH"]}
            tests.append({"name": f"Long passive: {ability} {'enemy' if reverse else 'player'}",
                          "player": other if reverse else holder,
                          "enemy": holder if reverse else other,
                          "turns": 16, "rng": "seeded", "rng_value": (index * 17 + 53) & 255,
                          "weather": ("none", "rain", "sun", "sandstorm", "hail")[index % 5],
                          "turn_assert": list(INVARIANTS), "assert": list(INVARIANTS),
                          "_file": "<generated long battle sweep>"})

    for ability, species in (("NATURAL_CURE", "CHANSEY"), ("REGENERATOR", "SLOWBRO"),
                             ("INTIMIDATE", "GYARADOS"), ("DRIZZLE", "POLITOED"),
                             ("DROUGHT", "NINETALES"), ("SAND_STREAM", "TYRANITAR"),
                             ("SNOW_WARNING", "ABOMASNOW"), ("NEUTRALIZING_GAS", "WEEZING"),
                             ("CLOUD_NINE", "GOLDUCK"), ("TRACE", "PORYGON"),
                             ("IMPOSTER", "DITTO"), ("UNBURDEN", "DRIFBLIM")):
        for suppress in (False, True):
            test = {"name": f"Long switches: {ability} {'Gas' if suppress else 'ordinary'}",
                    "player": {"species": species, "level": 100, "ability": ability,
                               "moves": ["SPLASH"], "hp": 50 if ability == "REGENERATOR" else 100},
                    "player2": {"species": "MEW", "level": 100, "item": "LEFTOVERS", "moves": ["SPLASH"]},
                    "enemy": {"species": "WEEZING" if suppress else "MEW", "level": 100,
                              "ability": "NEUTRALIZING_GAS" if suppress else "NO_ABILITY", "item": "LEFTOVERS", "moves": ["SPLASH"]},
                    "turns": 24, "move_script": ["switch:2", "switch:1"] * 12,
                    "rng": "seeded", "rng_value": 151, "turn_assert": list(INVARIANTS),
                    "assert": list(INVARIANTS) + ["turns_done == 24"],
                    "_file": "<generated long battle sweep>"}
            if ability == "REGENERATOR":
                test["assert"].append("player.hp == player.start_hp" if suppress else "player.hp == player.maxhp")
            if ability == "INTIMIDATE" and not suppress:
                test["assert"].append("enemy.stat_levels[0] == 1")
            tests.append(test)

    for case in generate_interaction_tests(192, con):
        case = deepcopy(case)
        case["name"] = case["name"].replace("Interaction stress", "Long mixed:")
        case["snapshot"] = True
        case["turns"] = 32
        original = case["move_script"]
        case["move_script"] = (original * (32 // len(original) + 1))[:32]
        case["turn_assert"] = list(INVARIANTS)
        case["assert"] = list(INVARIANTS)
        case["_file"] = "<generated long battle sweep>"
        tests.append(case)
    return tests
