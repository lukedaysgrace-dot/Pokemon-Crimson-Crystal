"""Every ability on both sides, plus field suppression and ability copying.

The existing YAML cases supply effect-specific assertions. This sweep checks
broader move execution, Gas equivalence to a no-ability control, and Trace's
copy restrictions for every ability constant, including custom abilities.
"""

import re

from symbols import Constants, ROOT


def generate_ability_tests(constants=None):
    con = constants or Constants()
    flags = {}
    for line in (ROOT / "data/abilities/flags.asm").read_text().splitlines():
        match = re.match(r"\s*db \$([0-9a-f]+) ; (\w+)", line)
        if match:
            flags[match[2]] = int(match[1], 16)

    def scenario(ability, defending=False, gas=False):
        holder = {"species": "SNORLAX" if defending else "MEW",
                  "level": 100 if defending else 30, "ability": ability,
                  "moves": ["SPLASH"] if defending else
                           ["TACKLE", "WATER_PULSE", "QUICK_ATTACK"]}
        foe = {"species": "MEW" if defending else "SNORLAX",
               "level": 30 if defending else 100,
               "ability": "NEUTRALIZING_GAS" if gas else "NO_ABILITY",
               "moves": ["THUNDERPUNCH"] if defending else ["SPLASH"]}
        return {"player": holder if not defending else foe,
                "enemy": foe if not defending else holder,
                "move_script": [1, 2, 3] if not defending else [1, 1, 1],
                "rng": "forced_high", "turns": 3,
                "assert": ["0 < player.hp <= player.maxhp",
                           "0 < enemy.hp <= enemy.maxhp",
                           "wram('wInAbility') == 0"],
                "_file": "<generated ability sweep>"}

    tests = []
    for defending in (False, True):
        label = "defense" if defending else "offense"
        control = scenario("NO_ABILITY", defending, gas=True)
        control.update(name=f"Ability sweep: Gas {label} control",
                       id=f"gas_{label}_control")
        tests.append(control)

    for _, ability in sorted(con.abilities_by_id.items()):
        if ability in ("NO_ABILITY", "NUM_ABILITIES"):
            continue
        for defending in (False, True):
            label = "defense" if defending else "offense"
            test = scenario(ability, defending)
            test["name"] = f"Ability sweep: {ability} {label} move execution"
            tests.append(test)
            if not flags[ability] & 8:  # ABILFLAG_NO_SUPPRESS
                test = scenario(ability, defending, gas=True)
                test["name"] = f"Ability sweep: Gas suppresses {ability} {label}"
                test["assert"] += [
                    f"player.hp == result('gas_{label}_control')['player']['hp']",
                    f"enemy.hp == result('gas_{label}_control')['enemy']['hp']",
                    f"player.stat_levels == result('gas_{label}_control')['player']['stat_levels']",
                    f"enemy.stat_levels == result('gas_{label}_control')['enemy']['stat_levels']",
                    f"weather_raw == result('gas_{label}_control')['weather']",
                ]
                tests.append(test)
        # Use legal species so both entry abilities run before the snapshot.
        enemy_species = next((species for species, slots in con.species_abilities.items()
                              if ability in slots and species in con.species), "SNORLAX")
        test = {"name": f"Ability sweep: Trace versus {ability}",
                "player": {"species": "PORYGON", "level": 50,
                           "ability": "TRACE", "moves": ["SPLASH"]},
                "enemy": {"species": enemy_species, "level": 100,
                          "ability": ability, "moves": ["SPLASH"]},
                "rng": "forced_high", "turns": 0,
                "assert": [f"player.ability == '{'TRACE' if flags[ability] & 2 else ability}'",
                           "wram('wInAbility') == 0"],
                "_file": "<generated ability sweep>"}
        tests.append(test)
    return tests
