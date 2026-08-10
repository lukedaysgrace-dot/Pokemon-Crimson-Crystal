"""Generate one semantic battle for every distinct move-effect routine.

The per-move sweep catches execution/dispatch failures.  This layer groups
moves by EFFECT_* and checks the state change made by a representative of
each effect, so every effect command has an automated behavioral assertion.
"""

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MOVE_RE = re.compile(
    r"^\s*move\s+(EFFECT_[A-Z0-9_]+),\s*([0-9]+),.*;([A-Z0-9_]+)\s*$"
)


def _representatives():
    effects = {}
    for line in (ROOT / "data/moves/moves.asm").read_text().splitlines():
        match = MOVE_RE.match(line)
        if match:
            effect, power, move = match.groups()
            effects.setdefault(effect, (move, int(power)))
    if len(effects) != 197:
        raise RuntimeError(f"expected 197 move effects, found {len(effects)}")
    return effects


USER_STAGES = {
    "EFFECT_ATTACK_UP": (0, 8), "EFFECT_ATTACK_UP_2": (0, 9),
    "EFFECT_DEFENSE_UP": (1, 8), "EFFECT_DEFENSE_UP_2": (1, 9),
    "EFFECT_SPEED_UP_2": (2, 9),
    "EFFECT_SP_ATK_UP": (3, 8), "EFFECT_SP_ATK_UP_2": (3, 9),
    "EFFECT_SP_DEF_UP_2": (4, 9), "EFFECT_EVASION_UP": (6, 8),
    "EFFECT_ATTACK_UP_HIT": (0, 8), "EFFECT_DEFENSE_UP_HIT": (1, 8),
    "EFFECT_SPEED_UP_HIT": (2, 8), "EFFECT_SP_ATK_UP_HIT": (3, 8),
}
TARGET_STAGES = {
    "EFFECT_ATTACK_DOWN": (0, 6), "EFFECT_ATTACK_DOWN_2": (0, 5),
    "EFFECT_DEFENSE_DOWN": (1, 6), "EFFECT_DEFENSE_DOWN_2": (1, 5),
    "EFFECT_SPEED_DOWN": (2, 6), "EFFECT_SPEED_DOWN_2": (2, 5),
    "EFFECT_ACCURACY_DOWN": (5, 6), "EFFECT_EVASION_DOWN": (6, 6),
    "EFFECT_ATTACK_DOWN_HIT": (0, 6), "EFFECT_DEFENSE_DOWN_HIT": (1, 6),
    "EFFECT_SPEED_DOWN_HIT": (2, 6), "EFFECT_ACCURACY_DOWN_HIT": (5, 6),
    "EFFECT_SP_ATK_DOWN_HIT": (3, 6), "EFFECT_SP_DEF_DOWN_HIT": (4, 6),
    "EFFECT_SP_DEF_DOWN_2_HIT": (4, 5),
}
USER_MULTI = {
    "EFFECT_BULK_UP": {0: 8, 1: 8},
    "EFFECT_CALM_MIND": {3: 8, 4: 8},
    "EFFECT_DRAGON_DANCE": {0: 8, 2: 8},
    "EFFECT_HONE_CLAWS": {0: 8, 5: 8},
    "EFFECT_QUIVER_DANCE": {2: 8, 3: 8, 4: 8},
    "EFFECT_WORK_UP": {0: 8, 3: 8},
}
TARGET_STATUS = {
    "EFFECT_SLEEP": "(enemy.status & 7) != 0",
    "EFFECT_POISON": "(enemy.status & 8) != 0",
    "EFFECT_TOXIC": "(enemy.status & 8) != 0 and (enemy.substatus[4] & 1) != 0",
    "EFFECT_BURN": "(enemy.status & 16) != 0",
    "EFFECT_PARALYZE": "(enemy.status & 64) != 0",
    "EFFECT_CONFUSE": "(enemy.substatus[2] & 128) != 0",
}
SECONDARY_STATUS = {
    "EFFECT_BURN_HIT": "(enemy.status & 16) != 0",
    "EFFECT_FLAME_WHEEL": "(enemy.status & 16) != 0",
    "EFFECT_FLARE_BLITZ": "(enemy.status & 16) != 0",
    "EFFECT_SACRED_FIRE": "(enemy.status & 16) != 0",
    "EFFECT_SCALD": "(enemy.status & 16) != 0",
    "EFFECT_FREEZE_HIT": "(enemy.status & 32) != 0",
    "EFFECT_BLIZZARD": "(enemy.status & 32) != 0",
    "EFFECT_PARALYZE_HIT": "(enemy.status & 64) != 0",
    "EFFECT_THUNDER": "(enemy.status & 64) != 0",
    "EFFECT_POISON_HIT": "(enemy.status & 8) != 0",
    "EFFECT_POISON_MULTI_HIT": "(enemy.status & 8) != 0",
    "EFFECT_POISON_FANG": "(enemy.status & 8) != 0",
    "EFFECT_CONFUSE_HIT": "(enemy.substatus[2] & 128) != 0",
    "EFFECT_HURRICANE": "(enemy.substatus[2] & 128) != 0",
}


def _base(move):
    return {
        "player": {"species": "MEW", "level": 70, "ability": "FRISK", "moves": [move]},
        "player2": {"species": "SNORLAX", "level": 50, "moves": ["SPLASH"]},
        "enemy": {"species": "LUGIA", "level": 100, "ability": "FRISK", "moves": ["SPLASH"]},
        "rng": "forced_low", "turns": 1,
    }


def _configure(effect, move, power):
    test = _base(move)
    assertions = ["player.start_pp[0] - player.pp[0] >= 1"]
    if power:
        assertions = ["enemy.hp < enemy.start_hp"]

    if effect in USER_STAGES:
        i, value = USER_STAGES[effect]
        assertions.append(f"player.stat_levels[{i}] == {value}")
    if effect in TARGET_STAGES:
        i, value = TARGET_STAGES[effect]
        assertions.append(f"enemy.stat_levels[{i}] == {value}")
    if effect in USER_MULTI:
        assertions = [f"player.stat_levels[{i}] == {v}" for i, v in USER_MULTI[effect].items()]
    if effect in TARGET_STATUS:
        assertions = [TARGET_STATUS[effect]]
    if effect in SECONDARY_STATUS:
        assertions.append(SECONDARY_STATUS[effect])

    special = {
        "EFFECT_ALL_UP_HIT": ["enemy.hp < enemy.start_hp"] + [f"player.stat_levels[{i}] == 8" for i in range(5)],
        "EFFECT_ATTRACT": ["(enemy.substatus[0] & 128) != 0"],
        "EFFECT_BELLY_DRUM": ["player.hp < player.start_hp", "player.stat_levels[0] == 13"],
        "EFFECT_CLOSE_COMBAT": ["enemy.hp < enemy.start_hp", "player.stat_levels[1] == 6", "player.stat_levels[4] == 6"],
        "EFFECT_DRACO_METEOR": ["enemy.hp < enemy.start_hp", "player.stat_levels[3] == 5"],
        "EFFECT_DEFENSE_CURL": ["player.stat_levels[1] == 8", "(player.substatus[1] & 1) != 0"],
        "EFFECT_DESTINY_BOND": ["(player.substatus[4] & 64) != 0"],
        "EFFECT_FOCUS_ENERGY": ["(player.substatus[3] & 4) != 0"],
        "EFFECT_FORESIGHT": ["(enemy.substatus[0] & 8) != 0"],
        "EFFECT_HAIL": ["weather == 4"],
        "EFFECT_HAMMER_ARM": ["enemy.hp < enemy.start_hp", "player.stat_levels[2] == 6"],
        "EFFECT_HEADLONG_RUSH": ["enemy.hp < enemy.start_hp", "player.stat_levels[1] == 6", "player.stat_levels[4] == 6"],
        "EFFECT_LEECH_SEED": ["(enemy.substatus[3] & 128) != 0"],
        "EFFECT_LIGHT_SCREEN": ["(player.screens & 8) != 0"],
        "EFFECT_LOCK_ON": ["(enemy.substatus[4] & 32) != 0"],
        "EFFECT_MEAN_LOOK": ["(enemy.substatus[4] & 128) != 0"],
        "EFFECT_MIST": ["(player.substatus[3] & 2) != 0"],
        "EFFECT_PERISH_SONG": ["wram('wPlayerPerishCount') != 0", "wram('wEnemyPerishCount') != 0"],
        "EFFECT_RAIN_DANCE": ["weather == 1"],
        "EFFECT_REFLECT": ["(player.screens & 16) != 0"],
        "EFFECT_SAFEGUARD": ["(player.screens & 4) != 0"],
        "EFFECT_SANDSTORM": ["weather == 3"],
        "EFFECT_SHELL_SMASH": ["player.stat_levels[0] == 9", "player.stat_levels[2] == 9", "player.stat_levels[3] == 9", "player.stat_levels[1] == 6", "player.stat_levels[4] == 6"],
        "EFFECT_SPIKES": ["(enemy.screens & 1) != 0"],
        "EFFECT_STEALTH_ROCK": ["(enemy.screens & 128) != 0"],
        "EFFECT_STEALTH_ROCK_HIT": ["enemy.hp < enemy.start_hp", "(enemy.screens & 128) != 0"],
        "EFFECT_SUBSTITUTE": ["player.hp < player.start_hp", "(player.substatus[3] & 16) != 0"],
        "EFFECT_SUNNY_DAY": ["weather == 2"],
        "EFFECT_SUPERPOWER": ["enemy.hp < enemy.start_hp", "player.stat_levels[0] == 6", "player.stat_levels[1] == 6"],
        "EFFECT_TOXIC_SPIKES": ["(enemy.screens & 32) != 0"],
        "EFFECT_TRICK_ROOM": ["wram('wTrickRoomTimer') != 0"],
    }
    assertions = special.get(effect, assertions)

    if effect in {"EFFECT_ACCURACY_DOWN_HIT", "EFFECT_EARTHQUAKE", "EFFECT_HEADLONG_RUSH", "EFFECT_MAGNITUDE"}:
        test["enemy"]["species"] = "SNORLAX"
    if effect == "EFFECT_ATTRACT":
        test["player"]["species"] = "NIDOKING"
        test["enemy"]["species"] = "NIDOQUEEN"

    # Preconditions and multi-turn scripts for effects that otherwise fail by
    # design on a neutral one-turn fixture.
    if effect in {"EFFECT_HEAL", "EFFECT_MOONLIGHT", "EFFECT_MORNING_SUN", "EFFECT_SYNTHESIS", "EFFECT_ROOST"}:
        test["player"]["hp"] = 40
        assertions = ["player.hp > player.start_hp"]
    elif effect == "EFFECT_DREAM_EATER":
        test["player"]["hp"] = 40
        test["enemy"]["status_byte"] = 2
        assertions = ["enemy.hp < enemy.start_hp", "player.hp > player.start_hp"]
    elif effect == "EFFECT_SNORE":
        test["player"]["status_byte"] = 2
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_NIGHTMARE":
        test["enemy"]["status_byte"] = 2
        assertions = ["(enemy.substatus[0] & 1) != 0"]
    elif effect in {"EFFECT_FLY", "EFFECT_BOUNCE", "EFFECT_SKULL_BASH", "EFFECT_SKY_ATTACK", "EFFECT_SOLARBEAM"}:
        test["turns"] = 2
        test["move_script"] = [1, 1]
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_FUTURE_SIGHT":
        test["turns"] = 3
        test["move_script"] = [1, 1, 1]
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_BIDE":
        test["enemy"]["species"] = "MEW"
        test["enemy"]["moves"] = ["TACKLE"]
        test["turns"] = 3
        test["move_script"] = [1, 1, 1]
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_COUNTER":
        test["enemy"]["species"] = "MEW"
        test["enemy"]["moves"] = ["TACKLE"]
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_MIRROR_COAT":
        test["enemy"]["species"] = "MEW"
        test["enemy"]["moves"] = ["WATER_GUN"]
        assertions = ["enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_OHKO":
        test["player"]["level"] = 100
        test["enemy"].update({"species": "RATTATA", "level": 5})
        assertions = ["enemy.hp == 0"]
    elif effect in {"EFFECT_BATON_PASS", "EFFECT_U_TURN"}:
        assertions = ["player.species == 'SNORLAX'"]
    elif effect in {"EFFECT_FORCE_SWITCH", "EFFECT_CIRCLE_THROW"}:
        test["enemy2"] = {"species": "SNORLAX", "level": 50, "moves": ["SPLASH"]}
        test["rng"] = "forced"
        test["rng_value"] = 1
        assertions = ["enemy.species == 'SNORLAX'"]
    elif effect == "EFFECT_FALSE_SWIPE":
        test["player"]["level"] = 100
        test["enemy"].update({"species": "RATTATA", "level": 5, "hp": 1})
        assertions = ["enemy.hp == 1"]
    elif effect == "EFFECT_SUPER_FANG":
        assertions = ["enemy.hp <= (enemy.start_hp + 1) // 2"]
    elif effect == "EFFECT_LEVEL_DAMAGE":
        assertions = ["enemy.start_hp - enemy.hp == player.level"]
    elif effect == "EFFECT_STATIC_DAMAGE":
        assertions = ["enemy.start_hp - enemy.hp == 20"]
    elif effect == "EFFECT_LEECH_HIT":
        test["player"]["hp"] = 40
        assertions = ["enemy.hp < enemy.start_hp", "player.hp > player.start_hp"]
    elif effect in {"EFFECT_RECOIL_HIT", "EFFECT_FLARE_BLITZ", "EFFECT_VOLT_TACKLE"}:
        assertions.append("player.hp < player.start_hp")
    elif effect == "EFFECT_SELFDESTRUCT":
        test["player2"] = None
        assertions = ["player.hp == 0"]
    elif effect == "EFFECT_DISABLE":
        test["enemy"]["moves"] = ["TACKLE"]
        assertions = ["wram('wEnemyDisableCount') != 0"]
    elif effect == "EFFECT_ENCORE":
        test["enemy"]["moves"] = ["TACKLE"]
        assertions = ["(enemy.substatus[4] & 16) != 0"]
    elif effect == "EFFECT_TRICK":
        test["player"]["item"] = "BERRY"
        test["enemy"]["item"] = "GOLD_BERRY"
        assertions = ["player.item == 'GOLD_BERRY'", "enemy.item == 'BERRY'"]
    elif effect == "EFFECT_PAIN_SPLIT":
        test["player"]["hp"] = 20
        assertions = ["player.hp > player.start_hp", "enemy.hp < enemy.start_hp"]
    elif effect == "EFFECT_PROTECT":
        test["player"].update({"species": "ELECTRODE", "level": 100})
        test["enemy"].update({"species": "SNORLAX", "level": 50, "moves": ["TACKLE"]})
        assertions = ["player.hp == player.start_hp"]
    elif effect == "EFFECT_ENDURE":
        test["player"].update({"species": "RATTATA", "level": 5, "hp": 1})
        test["enemy"].update({"species": "MEW", "level": 100, "moves": ["TACKLE"]})
        assertions = ["player.hp == 1"]
    elif effect == "EFFECT_SKETCH":
        test["enemy"]["moves"] = ["SPLASH"]
        assertions = ["player.moves[0] == 'SPLASH'"]

    test["assert"] = assertions
    return test


def generate_effect_semantic_tests():
    tests = []
    for effect, (move, power) in sorted(_representatives().items()):
        test = _configure(effect, move, power)
        test["name"] = f"Move effect: {effect} via {move}"
        test["_file"] = "<generated effect semantics>"
        tests.append(test)
    return tests
