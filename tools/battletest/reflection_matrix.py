"""Assert complete reflected effects, targeting, accuracy and Substitute rules."""


def generate_reflection_matrix():
    profiles = (
        ("TOXIC", "poison", None), ("WILL_O_WISP", "burn", None),
        ("THUNDER_WAVE", "paralysis", None), ("SPORE", "sleep", None),
        ("SING", "sleep_sound", None), ("CONFUSE_RAY", "confusion", None),
        ("ATTRACT", "love", None), ("GROWL", "stat_sound", (0, 6)),
        ("SCREECH", "stat_sound", (1, 5)), ("CHARM", "stat", (0, 5)),
        ("COTTON_SPORE", "stat", (2, 5)), ("FLASH", "stat", (5, 6)),
        ("SWAGGER", "swagger", (0, 9)), ("DEFOG", "defog", (6, 6)),
    )
    tests = []
    for move, kind, stat in profiles:
        for variant in ("ordinary", "source accuracy -6", "holder Protect",
                        "holder Substitute", "source Substitute", "Prankster Dark"):
            player = {"species": "NIDORINO" if kind == "love" else "MEW",
                      "level": 30, "ability": "NO_ABILITY", "moves": [move]}
            enemy = {"species": "NIDORINA" if kind == "love" else "ESPEON",
                     "level": 100, "ability": "MAGIC_BOUNCE", "moves": ["SPLASH"]}
            test = {"name": f"Reflection matrix: {move} {variant}",
                    "player": player, "enemy": enemy, "rng": "forced",
                    "rng_value": 80, "turns": 1,
                    "assert": ["ability_seen('MAGIC_BOUNCE')",
                               "player.start_pp[0] - player.pp[0] == 1",
                               "enemy.start_pp[0] - enemy.pp[0] == 1",
                               "(wram('wDisguiseBusted', 1) & 64) == 0"],
                    "_file": "<generated reflection matrix>"}
            if variant == "source accuracy -6":
                player["stages"] = {"acc": -6}
            elif variant == "holder Protect":
                enemy["moves"] = ["PROTECT"]
            elif variant in ("holder Substitute", "source Substitute"):
                side = enemy if variant.startswith("holder") else player
                side["substatus"] = ["SUBSTITUTE"]
                test["setup_wram"] = {"wEnemySubstituteHP" if side is enemy else
                                      "wPlayerSubstituteHP": 100}
            elif variant == "Prankster Dark":
                player["ability"] = "PRANKSTER"
                enemy["species"] = "UMBREON"
                enemy["dvs"] = 0  # female, so reflected Attract remains eligible
            blocked = variant == "source Substitute" and kind not in (
                "love", "sleep_sound", "stat_sound")
            if kind in ("poison", "burn", "paralysis", "sleep", "sleep_sound"):
                mask = {"poison": 8, "burn": 16, "paralysis": 64,
                        "sleep": 7, "sleep_sound": 7}[kind]
                test["assert"] += [f"(player.status & {mask}) {'==' if blocked else '!='} 0",
                                   "enemy.status == 0"]
                if kind == "poison" and not blocked:
                    test["assert"].append("(player.substatus[4] & 1) != 0")
            elif kind in ("confusion", "swagger"):
                test["assert"] += [f"(player.substatus[2] & 128) {'==' if blocked else '!='} 0",
                                   "(enemy.substatus[2] & 128) == 0"]
            elif kind == "love":
                test["assert"] += ["(player.substatus[0] & 128) != 0",
                                   "(enemy.substatus[0] & 128) == 0"]
            if stat:
                index, level = stat
                expected = 1 if index == 5 and variant == "source accuracy -6" else 7 if blocked else level
                test["assert"] += [f"player.stat_levels[{index}] == {expected}",
                                   f"enemy.stat_levels[{index}] == 7"]
            if kind == "defog":
                test.setdefault("setup_wram", {}).update(
                    wPlayerScreens=17, wEnemyScreens=17,
                    wPlayerSpikesLayers=1, wEnemySpikesLayers=1)
                test["assert"] += ["wram('wPlayerSpikesLayers') == 0",
                                   "wram('wEnemySpikesLayers') == 0",
                                   "(player.screens & 16) == 0", "(enemy.screens & 16) != 0"]
            tests.append(test)
    return tests
