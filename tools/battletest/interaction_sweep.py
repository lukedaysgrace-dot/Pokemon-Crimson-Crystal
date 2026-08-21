"""Generate deterministic mixed-mechanic battle stress scenarios."""

import random

from symbols import Constants


HELD_ITEMS = [
    "NO_ITEM",
    "BERRY",
    "GOLD_BERRY",
    "MYSTERYBERRY",
    "LEFTOVERS",
    "LIFE_ORB",
    "CHOICE_BAND",
    "CHOICE_SCARF",
    "FOCUS_SASH",
    "AIR_BALLOON",
    "ROCKY_HELMET",
    "TOXIC_ORB",
    "FLAME_ORB",
    "KINGS_ROCK",
    "SCOPE_LENS",
    "BERSERK_GENE",
]


def generate_interaction_tests(count=128, constants=None):
    con = constants or Constants()
    rng = random.Random(0xC11A0)
    last_species = con.num_pokemon or max(con.species_by_index)
    species = [con.species_by_index[index] for index in range(1, last_species + 1)]
    last_move = con.moves["LUMINA_CRASH"]
    moves = [con.moves_by_index[index] for index in range(1, last_move + 1)]
    abilities = [
        name
        for index, name in sorted(con.abilities_by_id.items())
        if index and name != "NO_ABILITY"
    ]
    items = [name for name in HELD_ITEMS if name in con.items]
    statuses = [0, 0, 0, 2, 8, 16, 64]
    weather = ["none", "rain", "sun", "sandstorm", "hail"]

    def mon(level=None):
        return {
            "species": rng.choice(species),
            "level": level or rng.randint(20, 100),
            "ability": rng.choice(abilities),
            "item": rng.choice(items),
            "moves": rng.sample(moves, 4),
            "status_byte": rng.choice(statuses),
        }

    tests = []
    for index in range(count):
        turns = rng.randint(2, 4)
        move_script = [rng.randint(1, 4) for _ in range(turns)]
        if rng.randrange(3) == 0:
            move_script[rng.randrange(turns)] = "switch:2"
        tests.append(
            {
                "name": f"Interaction stress {index + 1:03d}",
                "player": mon(),
                "player2": mon(),
                "enemy": mon(),
                "enemy2": mon(),
                "enemy_class": "FALKNER",
                "weather": rng.choice(weather),
                "rng": "seeded",
                "rng_value": rng.randrange(256),
                "turns": turns,
                "move_script": move_script,
                "snapshot": False,
                "assert": [],
                "_file": "<generated interaction sweep>",
            }
        )
    return tests
