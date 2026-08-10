"""Generate one headless execution smoke test for every real move.

These cases complement the effect-specific YAML assertions: their job is to
prove that every move can be converted to a runtime id, loaded into a battle,
selected, and executed without rejecting the request or hanging the engine.
"""

from symbols import Constants


def generate_move_smoke_tests(constants=None):
    con = constants or Constants()
    last_move = con.moves["LUMINA_CRASH"]
    moves = []
    for index in range(1, last_move + 1):
        name = con.moves_by_index.get(index)
        if name is None:
            raise RuntimeError(f"move constants have a gap at index {index}")
        moves.append((index, name))

    tests = []
    for index, name in moves:
        tests.append({
            "name": f"Move smoke {index:03x}: {name}",
            # A bench mon lets switch moves (Baton Pass, U-turn, etc.) finish
            # without opening the party menu. The high-level foe survives most
            # attacks, while battle-ending moves are valid STATE_DONE outcomes.
            "player": {
                "species": "MEW", "level": 50, "moves": [name],
            },
            "player2": {
                "species": "SNORLAX", "level": 50, "moves": ["SPLASH"],
            },
            "enemy": {
                "species": "LUGIA", "level": 100, "moves": ["SPLASH"],
            },
            "rng": "seeded",
            "rng_value": (0x14 + index * 23) & 0xFF,
            "turns": 1,
            "snapshot": False,
            "assert": [],
            "_file": "<generated move sweep>",
        })
    return tests
