"""Swagger at every Attack stage, including ability suppression and stat caps."""


def generate_swagger_matrix():
    tests = []
    for source in ("NO_ABILITY", "MOLD_BREAKER", "NEUTRALIZING_GAS"):
        for ability in ("NO_ABILITY", "CONTRARY", "OWN_TEMPO"):
            for stage in range(-6, 7):
                effective = ability if source == "NO_ABILITY" else "NO_ABILITY"
                expected = max(1, min(13, 7 + stage + (-2 if effective == "CONTRARY" else 2)))
                # Mold Breaker bypasses the initial immunity, then Own Tempo
                # cures the confusion during the ordinary ability update.
                confused = ability != "OWN_TEMPO" or source == "NEUTRALIZING_GAS"
                test = {
                    "name": f"Swagger matrix: {source} versus {ability} at Attack {stage:+d}",
                    "player": {"species": "MEW", "level": 30,
                               "ability": source, "moves": ["SWAGGER"]},
                    "enemy": {"species": "SNORLAX", "level": 100, "ability": ability,
                              "stages": {"atk": stage}, "moves": ["SPLASH"]},
                    "rng": "forced_low", "turns": 1,
                    "assert": [f"enemy.stat_levels[0] == {expected}",
                               f"(enemy.substatus[2] & 128) {'!=' if confused else '=='} 0",
                               "player.start_pp[0] - player.pp[0] == 1",
                               "wram('wInAbility') == 0"],
                    "_file": "<generated Swagger stage matrix>",
                }
                if source == "MOLD_BREAKER" and ability == "OWN_TEMPO":
                    test["assert"] += ["textbox_seen('BecameConfusedText')",
                                       "textbox_seen('ConfusedNoMoreText')",
                                       "ability_seen('OWN_TEMPO')"]
                tests.append(test)
    return tests
