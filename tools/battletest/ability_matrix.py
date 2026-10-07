"""Move-class, suppression, bypass, and ability-transfer interaction matrices.

Gas controls compare observable mechanics, not just successful execution.
Mold Breaker controls isolate direct hits and stat drops: an unsuppressed
ability may cure a bypassed status after the move, so those are separate tests.
"""

import re

from symbols import Constants, ROOT


MOVES = ("TACKLE", "FLAMETHROWER", "WATER_PULSE", "THUNDERPUNCH",
         "EARTHQUAKE", "AIR_SLASH", "SPORE", "TOXIC", "SCREECH",
         "YAWN", "LEECH_SEED", "QUICK_ATTACK")
MOLD_MOVES = MOVES[:6] + ("SCREECH", "LEECH_SEED", "QUICK_ATTACK")


def generate_ability_matrix(constants=None):
    con = constants or Constants()
    flags = {}
    for line in (ROOT / "data/abilities/flags.asm").read_text().splitlines():
        match = re.match(r"\s*db \$([0-9a-f]+) ; (\w+)", line)
        if match:
            flags[match[2]] = int(match[1], 16)
    abilities = [ability for _, ability in sorted(con.abilities_by_id.items())
                 if ability not in ("NO_ABILITY", "NUM_ABILITIES")]

    def battle(move, ability, source="NO_ABILITY", rng="forced_low"):
        return {"player": {"species": "MEW", "level": 30,
                           "ability": source, "moves": [move, "SPLASH"]},
                "enemy": {"species": "SNORLAX", "level": 100,
                          "ability": ability, "moves": ["SPLASH"]},
                "rng": rng, "weather": "none" if source == "MOLD_BREAKER" else "rain",
                "turns": 2 if move == "YAWN" else 1,
                "move_script": [1, 2] if move == "YAWN" else [1],
                "assert": ["0 < player.hp <= player.maxhp",
                           "0 < enemy.hp <= enemy.maxhp",
                           "wram('wInAbility') == 0",
                           "(wram('wDisguiseBusted', 1) & 64) == 0"],
                "_file": "<generated ability matrix>"}

    tests = []
    for family, source, moves, rng in (
            ("execution", "NO_ABILITY", MOVES, "forced_low"),
            ("Gas", "NEUTRALIZING_GAS", MOVES, "forced_low"),
            ("Mold", "MOLD_BREAKER", MOLD_MOVES, "forced_high")):
        for move in moves:
            control = battle(move, "NO_ABILITY", source, rng)
            control.update(name=f"Ability matrix: {family} {move} control",
                           id=f"matrix_{family}_{move}")
            tests.append(control)
            for ability in abilities:
                if family == "Gas" and flags[ability] & 8:
                    continue
                if family == "Mold" and not flags[ability] & 16:
                    continue
                test = battle(move, ability, source, rng)
                test["name"] = f"Ability matrix: {family} {move} versus {ability}"
                if family in ("Gas", "Mold"):
                    for side in ("player", "enemy"):
                        for field in ("hp", "stat_levels", "pp", "item", "screens"):
                            # Mold Breaker bypasses burn protection, while
                            # Thermal Exchange still raises Attack after a hit.
                            if (family == "Mold" and ability == "THERMAL_EXCHANGE"
                                    and move == "FLAMETHROWER" and side == "enemy"
                                    and field == "stat_levels"):
                                continue
                            test["assert"].append(
                                f"{side}.{field} == result('matrix_{family}_{move}')['{side}']['{field}']")
                        if family == "Gas":
                            for field in ("status", "substatus"):
                                test["assert"].append(
                                    f"{side}.{field} == result('matrix_{family}_{move}')['{side}']['{field}']")
                    test["assert"].append(f"weather_raw == result('matrix_{family}_{move}')['weather']")
                    if family == "Mold" and ability == "THERMAL_EXCHANGE" and move == "FLAMETHROWER":
                        test["assert"].append("enemy.stat_levels == [8, 7, 7, 7, 7, 7, 7]")
                tests.append(test)

    for ability in abilities:
        swap = battle("SKILL_SWAP", ability, "SYNCHRONIZE", "forced_high")
        swap["weather"] = "none"
        swap["name"] = f"Ability matrix: Skill Swap versus {ability}"
        swap["assert"] += [
            f"player.ability == '{'SYNCHRONIZE' if flags[ability] & 4 or ability in ('TRACE', 'IMPOSTER') else ability}'",
            f"enemy.ability == '{ability if flags[ability] & 4 else 'SYNCHRONIZE'}'",
            ("player.moves[0] == 'SPLASH' and player.pp[0] == 5"
             if ability == "IMPOSTER" else
             f"player.start_pp[0] - player.pp[0] == {2 if ability == 'PRESSURE' else 1}"),
        ]
        tests.append(swap)
        transform = battle("TRANSFORM", ability, "SYNCHRONIZE", "forced_high")
        transform["weather"] = "none"
        transform["name"] = f"Ability matrix: Transform versus {ability}"
        # A copied ability starts as if it had just entered, so the
        # transformed (Normal-type) user takes its own weather's chip damage.
        chip = " - player.maxhp // 16" if ability in ("SAND_STREAM", "SNOW_WARNING") else ""
        transform["assert"] += [
            f"player.ability == '{'SYNCHRONIZE' if flags[ability] & 32 else ability}'",
            "player.species == 'SNORLAX'", f"player.hp == player.start_hp{chip}",
            "player.moves[0] == 'SPLASH'", "player.pp[0] == 5",
            "(player.substatus[4] & 8) != 0",
        ]
        weather = {"DRIZZLE": 1, "DROUGHT": 2, "SAND_STREAM": 3, "SNOW_WARNING": 4}
        if ability in weather:
            transform["assert"].append(f"weather_raw == {weather[ability]}")
        tests.append(transform)
    return tests
