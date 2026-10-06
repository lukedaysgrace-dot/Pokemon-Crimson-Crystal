"""Paired semantic controls for every move in the ability classification lists."""

import re

from symbols import ROOT


def generate_class_matrix():
    source = (ROOT / "engine/battle/abilities_engine.asm").read_text()

    def moves(label):
        body = source.split(label + ":", 1)[1].split("\tdw -1", 1)[0]
        return re.findall(r"^\s*dw (\w+)\s*$", body, re.M)

    def battle(move, attack="NO_ABILITY", defense="NO_ABILITY"):
        test = {"player": {"species": "MEW", "level": 50,
                           "ability": attack, "moves": [move]},
                "enemy": {"species": "MEW", "level": 100,
                          "ability": defense, "moves": ["SPLASH"]},
                "rng": "forced_low", "turns": 1,
                "weather": "sun" if move == "SOLAR_BLADE" else "none",
                "assert": ["0 < player.hp <= player.maxhp",
                           "0 < enemy.hp <= enemy.maxhp", "wram('wInAbility') == 0"],
                "_file": "<generated classified move matrix>"}
        if move == "SNORE":
            test["player"]["status_byte"] = 3
        if move in ("ROAR", "WHIRLWIND"):
            test["rng"] = "forced"
            test["rng_value"] = 1
            test["enemy2"] = {"species": "NIDOKING", "level": 100,
                              "ability": "NO_ABILITY", "moves": ["SPLASH"]}
            test["enemy_class"] = "FALKNER"
        return test

    tests = []
    for label, ability in (("PunchMoves", "IRON_FIST"), ("SliceMoves", "SHARPNESS"),
                           ("PulseMoves", "MEGA_LAUNCHER"), ("BiteMoves", "STRONG_JAW")):
        for move in moves(label) + ["TACKLE"]:
            control_id = f"class_{ability}_{move}"
            control = battle(move)
            control.update(name=f"Class matrix: {ability} {move} control", id=control_id)
            control["assert"].append("enemy.hp < enemy.start_hp")
            tests.append(control)
            for defense in ("NO_ABILITY", "NEUTRALIZING_GAS", "MOLD_BREAKER"):
                test = battle(move, ability, defense)
                test["name"] = f"Class matrix: {ability} {move} against {defense}"
                boosted = move != "TACKLE" and defense != "NEUTRALIZING_GAS"
                test["assert"].append(
                    f"enemy.start_hp - enemy.hp {'>' if boosted else '=='} result('{control_id}')['enemy']['damage']")
                tests.append(test)

    for label, ability in (("BallBombMoves", "BULLETPROOF"),
                           ("WindMoves", "WIND_RIDER"), ("SoundMoves", "SOUNDPROOF")):
        for move in moves(label) + ["TACKLE"]:
            control_id = f"class_{ability}_{move}"
            control = battle(move)
            control.update(name=f"Class matrix: {ability} {move} control", id=control_id)
            if move in ("ROAR", "WHIRLWIND"):
                control["assert"].append("enemy.species == 'NIDOKING'")
            elif move in ("GROWL", "SCREECH"):
                control["assert"].append(f"enemy.stat_levels[{0 if move == 'GROWL' else 1}] == {6 if move == 'GROWL' else 5}")
            elif move == "SING":
                control["assert"].append("(enemy.status & 7) != 0")
            elif move == "SUPERSONIC":
                control["assert"].append("(enemy.substatus[2] & 128) != 0")
            elif move == "PERISH_SONG":
                control["assert"].append("wram('wEnemyPerishCount') == 3")
            else:
                control["assert"].append("enemy.hp < enemy.start_hp")
            tests.append(control)
            for attack in ("NO_ABILITY", "NEUTRALIZING_GAS", "MOLD_BREAKER"):
                test = battle(move, attack, ability)
                test["name"] = f"Class matrix: {ability} {move} from {attack}"
                blocked = move != "TACKLE" and attack == "NO_ABILITY"
                if blocked:
                    test["assert"] += ["enemy.hp == enemy.start_hp", "enemy.species == 'MEW'",
                                       "enemy.status == 0", "(enemy.substatus[2] & 128) == 0",
                                       "wram('wEnemyPerishCount') == 0",
                                       f"enemy.stat_levels == [{8 if ability == 'WIND_RIDER' else 7}, 7, 7, 7, 7, 7, 7]"]
                else:
                    for field in ("hp", "status", "stat_levels", "species", "substatus"):
                        test["assert"].append(
                            f"enemy.{field} == result('{control_id}')['enemy']['{field}']")
                tests.append(test)
    return tests
