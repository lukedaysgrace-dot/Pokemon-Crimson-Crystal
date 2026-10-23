"""Decision heuristics. Scores propose actions; only ROM outcomes rank builds."""
from __future__ import annotations

import random

from .data import legal_pool, validate_build

POLICIES = ("tactical", "aggressive", "random", "rollout", "native")


def effectiveness(data, move_type, target_types):
    result = 1.0
    for typing in set(target_types):
        result *= data["matchups"].get(f"{move_type}/{typing}", 1)
    return result


def move_score(data, move_key, user, target, strategy="tactical"):
    """A deliberately approximate *policy* value, never a damage calculator."""
    m = data["moves"][move_key]
    effect = m["effect"]
    health = user["hp"] / max(1, user["maxhp"])
    if effect == "EFFECT_DREAM_EATER" and not (target["status"] & 7):
        return -1
    if effect == "EFFECT_FUTURE_SIGHT" and user.get("future_sight", 0):
        return -1
    if m["category"] != "status":
        physical = m["category"] == "physical"
        offense = user["stats"]["attack" if physical else "spclatk"]
        defense = target["stats"]["defense" if physical else "spcldef"]
        power = m["power"]
        # These values only order choices. Damage and all ability checks still
        # execute in the ROM. Treating power=1 effects as weak ordinary hits
        # would systematically underplay Counter users and fixed-damage walls.
        if effect in {"EFFECT_COUNTER", "EFFECT_MIRROR_COAT"}:
            category = "physical" if effect == "EFFECT_COUNTER" else "special"
            threats = [data["moves"][k] for k in target.get("moves", []) if k in data["moves"]
                       and data["moves"][k]["category"] != "status"]
            strongest = max(threats, key=lambda x: x["power"], default=None)
            return 180 if strongest and strongest["category"] == category else 0
        if effect == "EFFECT_LEVEL_DAMAGE":
            return user.get("level", 100) * effectiveness(data, m["type"], target["types"])
        if effect == "EFFECT_SUPER_FANG":
            return target["hp"] * .5 * m["accuracy"] / 100
        if effect == "EFFECT_MULTI_HIT":
            power *= 5 if user.get("ability") == "SKILL_LINK" else 3
        if effect == "EFFECT_DOUBLE_HIT":
            power *= 2
        if effect == "EFFECT_LOW_KICK":
            weight = data["species"][target["species"]]["weight_hg"] if target.get("species") else 1000
            power = next(p for threshold, p in ((2000, 120), (1000, 100), (500, 80), (250, 60), (100, 40), (0, 20)) if weight >= threshold)
        elif effect == "EFFECT_HEAVY_SLAM":
            own = data["species"][user["species"]]["weight_hg"] if user.get("species") else 1000
            other = data["species"][target["species"]]["weight_hg"] if target.get("species") else 1000
            power = next(p for factor, p in ((5, 120), (4, 100), (3, 80), (2, 60), (0, 40)) if own >= other * factor)
        elif effect in {"EFFECT_RETURN", "EFFECT_HIDDEN_POWER", "EFFECT_FRUSTRATION"}:
            power = 70  # candidate ordering only; native code resolves actual power
        typing = m["type"]
        converted = {"GALVANIZE": "ELECTRIC", "PIXILATE": "FAIRY", "REFRIGERATE": "ICE", "AERILATE": "FLYING"}.get(user.get("ability"))
        if converted and typing == "NORMAL" and move_key not in {"HIDDEN_POWER", "WEATHER_BALL", "STRUGGLE"}:
            typing = converted
            power *= 1.2
        stab = (2 if user.get("ability") == "ADAPTABILITY" else 1.5) if typing in user["types"] else 1
        if physical and user.get("ability") == "HUGE_POWER":
            power *= 2
        if physical and user.get("ability") == "GUTS" and user["status"]:
            power *= 1.5
        if user.get("ability") == "TECHNICIAN" and 0 < m["power"] <= 60:
            power *= 1.5
        value = power * offense / max(1, defense) * stab * effectiveness(data, typing, target["types"]) * m["accuracy"] / 100
        # The same table used by AbilityNullifiesType in abilities_engine.asm.
        # Awareness prevents repeatedly selecting Earthquake into Levitate or
        # feeding an absorb ability. The ROM remains responsible for blocking.
        nullifies = {"VOLT_ABSORB": "ELECTRIC", "LIGHTNING_ROD": "ELECTRIC", "MOTOR_DRIVE": "ELECTRIC",
                     "WATER_ABSORB": "WATER", "STORM_DRAIN": "WATER", "DRY_SKIN": "WATER",
                     "FLASH_FIRE": "FIRE", "SAP_SIPPER": "GRASS", "LEVITATE": "GROUND"}
        suppressed = "NEUTRALIZING_GAS" in {user.get("ability"), target.get("ability")}
        if not suppressed and user.get("ability") != "MOLD_BREAKER" and nullifies.get(target.get("ability")) == typing:
            return 0
        if effect in {"EFFECT_LEECH_HIT", "EFFECT_DRAIN_PUNCH"}:
            value *= 1 + (1 - health) * .5
        if effect in {"EFFECT_HYPER_BEAM", "EFFECT_SELFDESTRUCT", "EFFECT_EXPLOSION", "EFFECT_RECOIL_HIT"}:
            value *= .7
        if effect in {"EFFECT_FUTURE_SIGHT", "EFFECT_SKULL_BASH", "EFFECT_FLY", "EFFECT_SOLARBEAM", "EFFECT_RAZOR_WIND", "EFFECT_SKY_ATTACK"}:
            value *= .55
        if m["priority"] > 0 and target["hp"] / max(1, target["maxhp"]) < .3:
            value *= 1.7
        if effect in {"EFFECT_FAKE_OUT", "EFFECT_FIRST_IMPRESSION"} and not user.get("fresh", True):
            value = 0
        return value
    if strategy == "aggressive":
        return 1
    if any(s in effect for s in ("HEAL", "RECOVER", "MORNING_SUN", "SYNTHESIS", "MOONLIGHT", "ROOST", "REST", "SHORE_UP")):
        return (1 - health) * 250 if health < .65 else 0
    if "SLEEP" in effect and not target["status"]:
        return 90 * m["accuracy"] / 100
    if any(s in effect for s in ("TOXIC", "POISON", "BURN", "PARALYZE")):
        return 65 * m["accuracy"] / 100 if not target["status"] else 0
    if any(s in effect for s in ("ATTACK_UP", "SP_ATK_UP", "DRAGON_DANCE", "QUIVER_DANCE", "SHELL_SMASH", "BULK_UP", "CALM_MIND", "WORK_UP", "HONE_CLAWS", "GEOMANCY")):
        boosts = max(user["stages"][0], user["stages"][3]) - 7
        return 85 if boosts < 2 and health > .65 else 0
    if any(s in effect for s in ("REFLECT", "LIGHT_SCREEN", "LEECH_SEED", "SUBSTITUTE")):
        return 45 if health > .7 and not user.get("used_support") else 0
    return 5


def choose(data, user, target, strategy, seed):
    available = [(i, m) for i, m in enumerate(user["moves"]) if m and user["pp"][i] > 0 and m != user.get("disabled") and m != user.get("giga_lock")]
    if not available:
        return 1  # ROM resolves exhaustion/Struggle; never invent PP
    if strategy != "random" and user["status"] & 7:
        asleep_moves = [(i, m) for i, m in available if m in {"SLEEP_TALK", "SNORE"}]
        if asleep_moves:
            return asleep_moves[0][0] + 1
    rng = random.Random(seed)
    if strategy == "random":
        return rng.choice(available)[0] + 1
    scores = [(move_score(data, m, user, target, strategy), rng.random(), i) for i, m in available]
    return max(scores)[2] + 1


def candidate_builds(data, species, count=12, level=100, seed=1, items=None):
    """Stratified bounded proposals, including coverage, setup and sustain."""
    s = data["species"][species]
    pool = list(legal_pool(data, species, level))
    attack = s["stats"]
    user = {"species": species, "hp": 100, "maxhp": 100, "types": s["types"], "status": 0, "stages": [7] * 7,
            "stats": {"attack": attack["attack"], "defense": attack["defense"], "speed": attack["speed"], "spclatk": attack["sp_attack"], "spcldef": attack["sp_defense"]}}
    target = {**user, "species": None, "types": [], "stats": {k: 100 for k in user["stats"]}}
    ranked = sorted(pool, key=lambda m: (-move_score(data, m, user, target), m))
    attacks = [m for m in ranked if data["moves"][m]["category"] != "status"]
    supports = [m for m in ranked if data["moves"][m]["category"] == "status"]
    coverage = []
    for m in attacks:
        if data["moves"][m]["type"] not in {data["moves"][k]["type"] for k in coverage}:
            coverage.append(m)
    base = (coverage + [m for m in ranked if m not in coverage])[:4]
    abilities = list(dict.fromkeys(a for a in s["abilities"] if a != "NO_ABILITY")) or ["NO_ABILITY"]
    items = items or [i for i in ("NO_ITEM", "LEFTOVERS", "CHOICE_BAND", "CHOICE_SPECS", "CHOICE_SCARF", "LIFE_ORB", "FOCUS_SASH", "LUM_BERRY", "GOLD_BERRY") if i in data["items"]]
    if not pool or not items:
        raise ValueError(f"no candidate moves/items for {species}")
    rng = random.Random(seed)
    seen, builds = set(), []
    for index in range(max(count * 20, 50)):
        moves = list(base)
        if index >= len(abilities):
            mode = (index // len(abilities)) % 3
            if mode == 1 and supports:
                moves[-1] = supports[(index // len(abilities)) % len(supports)]
            elif mode == 2:
                moves = rng.sample(ranked[:min(len(ranked), 18)], min(4, len(ranked)))
        moves = list(dict.fromkeys(moves))
        ability = abilities[index % len(abilities)]
        item = items[(index // len(abilities)) % len(items)]
        identity = (tuple(sorted(moves)), ability, item)
        if identity in seen:
            continue
        seen.add(identity)
        builds.append(validate_build(data, {"species": species, "level": level, "moves": moves, "ability": ability, "item": item}))
        if len(builds) >= count:
            break
    return builds
