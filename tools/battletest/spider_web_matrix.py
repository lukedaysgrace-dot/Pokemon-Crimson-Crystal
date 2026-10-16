"""Generate real switch-in battles for Spider Web against every ability.

Write YAML to stdout, then pass it to runner.py. Each incoming mon is Mew
so type immunities cannot conceal an ability interaction. Both directions
exercise the normal switch/forced-switch, hazard and entry-ability routines.
"""

import sys

import yaml

from symbols import Constants


def generate_spider_web_matrix():
    tests = []
    for ability in Constants().abilities_by_id.values():
        if ability == "NUM_ABILITIES":
            continue
        for side in ("player", "enemy"):
            incoming = {"species": "MEW", "level": 50, "ability": ability,
                        "moves": ["SPLASH"]}
            quiet = {"species": "MAGIKARP", "level": 50,
                     "ability": "NO_ABILITY", "moves": ["SPLASH"]}
            test = {"name": f"Spider Web ability matrix: {side} {ability}",
                    "player": dict(quiet), "enemy": dict(quiet),
                    f"{side}2": incoming, "rng": "forced_high", "turns": 1,
                    "weather": "none",
                    "setup_wram": {f"w{'Player' if side == 'player' else 'Enemy'}SpiderWeb": 1},
                    "assert": ["wram('wEntryWebStatDrop') == 0",
                               "wram('wAbilityStatDropFlag') == 0",
                               "wram('wInAbility') == 0",
                               f"({side}.substatus[4] & 1) == 0"]}
            if side == "player":
                test["move_script"] = ["switch:2"]
            else:
                # Knock out the lead so the real faint/replacement path runs.
                # Pinned RNG can loop forever while Roar selects a party slot.
                test["player"]["moves"] = ["DRAGON_RAGE"]
                test["enemy"].update(level=5, hp=1)
            speed = 7 if ability in ("LEVITATE", "CLEAR_BODY", "WHITE_SMOKE",
                                     "MIRROR_ARMOR", "IMPOSTER") else 8 if ability == "CONTRARY" else 6
            # $b4 % 3 == 0: the pinned random byte makes Shed Skin cure it.
            poisoned = ability not in ("LEVITATE", "IMMUNITY", "PASTEL_VEIL", "SHED_SKIN")
            test["assert"] += [f"{side}.stat_levels[2] == {speed}",
                               f"{side}.status == {8 if poisoned else 0}"]
            if ability not in ("TRACE", "IMPOSTER"):
                test["assert"].append(f"{side}.ability == '{ability}'")
            if ability == "DEFIANT":
                test["assert"].append(f"{side}.stat_levels[0] == 9")
            if ability == "COMPETITIVE":
                test["assert"].append(f"{side}.stat_levels[3] == 9")
            if ability in ("MAGIC_GUARD", "POISON_HEAL"):
                test["assert"].append(f"{side}.hp == {side}.maxhp")
            tests.append(test)
    return tests


if __name__ == "__main__":
    yaml.safe_dump(generate_spider_web_matrix(), sys.stdout, sort_keys=False)
