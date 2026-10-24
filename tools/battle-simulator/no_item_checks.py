"""Controlled native no-item checks for Ceruledge's slicing ability.

These one-turn probes are mechanics checks, not games added to tier scores.
"""
from collections import defaultdict
import json

from lab.data import ROOT, extract, provenance
from lab.engine import RomEngine
from no_item_audit import DEST, guard_no_items, write


def main():
    data = extract()
    engine = RomEngine(data)
    records, observations = [], defaultdict(dict)
    try:
        for seed in range(20261024, 20261036):
            for side in ("player", "enemy"):
                for ability in ("FLASH_FIRE", "WEAK_ARMOR", "SHARPNESS"):
                    user = {"species": "CERULEDGE", "ability": ability, "item": "NO_ITEM", "moves": ["BITTER_BLADE"]}
                    target = {"species": "SNORLAX", "ability": "IMMUNITY", "item": "NO_ITEM", "moves": ["AMNESIA"]}
                    spec = {"name": f"No-item Bitter Blade {ability} {side} {seed}", "seed": seed, "max_turns": 1,
                            "player": user if side == "player" else target, "enemy": target if side == "player" else user,
                            "scripts": {"player": [1], "enemy": [1]}}
                    guard_no_items([spec])
                    r = engine.run(spec)
                    assert r["status"] != "error" and not r["failures"], r
                    assert all(t[s]["item"] == "NO_ITEM" for t in r["log"] for s in ("player", "enemy"))
                    event = next(e for e in r["log"][1]["actions"] if e["side"] == side and e["move"] == "BITTER_BLADE")
                    damage = event["damage_attempts"][-1]["damage"]
                    observations[seed, side][ability] = damage
                    records.append(r)
        pairs = []
        for (seed, side), values in observations.items():
            assert values["FLASH_FIRE"] == values["WEAK_ARMOR"], (seed, side, values)
            ratio = values["SHARPNESS"] / values["WEAK_ARMOR"]
            assert 1.45 <= ratio <= 1.55, (seed, side, values, ratio)
            pairs.append({"seed": seed, "side": side, "native_damage": values, "sharpness_ratio": ratio})
        write(DEST / "sharpness-native-checks.json", {"status": "passed", "checks": len(records),
                                                     "provenance": provenance(), "paired_results": pairs, "records": records})
        extra, acro = [], defaultdict(dict)
        for seed in range(20261024, 20261028):
            for side in ("player", "enemy"):
                for item in ("NO_ITEM", "POTION"):
                    user = {"species": "CROBAT", "item": item, "moves": ["ACROBATICS"]}
                    target = {"species": "SNORLAX", "ability": "IMMUNITY", "item": "NO_ITEM", "moves": ["AMNESIA"]}
                    # POTION is an inert held control for the native doubling
                    # check. These mechanics probes never enter tier scores.
                    r = engine.run({"name": f"Acrobatics native control {seed} {side} {item}", "seed": seed, "max_turns": 1,
                                    "player": user if side == "player" else target, "enemy": target if side == "player" else user,
                                    "scripts": {"player": [1], "enemy": [1]}})
                    assert r["status"] != "error" and not r["failures"], r
                    event = next(e for e in r["log"][1]["actions"] if e["side"] == side and e["move"] == "ACROBATICS")
                    acro[seed, side][item] = event["damage_attempts"][-1]["damage"]
                    extra.append(r)
        for key, damage in acro.items():
            assert 1.9 <= damage["NO_ITEM"]/damage["POTION"] <= 2.1, (key, damage)
        for species, ability, move, weather in (("MACHAMP", "NO_GUARD", "DYNAMICPUNCH", None),
                                                 ("ARTICUNO", "SNOW_WARNING", "BLIZZARD", data["weather_ids"]["WEATHER_HAIL"])):
            for seed in range(20261024, 20261036):
                for side in ("player", "enemy"):
                    user = {"species": species, "ability": ability, "item": "NO_ITEM", "moves": [move]}
                    target = {"species": "SNORLAX", "ability": "IMMUNITY", "item": "NO_ITEM", "moves": ["AMNESIA"]}
                    spec = {"name": f"Native accuracy {ability} {side} {seed}", "seed": seed, "max_turns": 1,
                            "player": user if side == "player" else target, "enemy": target if side == "player" else user,
                            "scripts": {"player": [1], "enemy": [1]}}
                    guard_no_items([spec])
                    r = engine.run(spec)
                    assert r["status"] != "error" and not r["failures"], r
                    if weather is not None:
                        assert r["log"][0]["weather"] == weather, r["log"][0]
                    event = next(e for e in r["log"][1]["actions"] if e["side"] == side and e["move"] == move)
                    assert event.get("damage_attempts") and all(not a["missed"] for a in event["damage_attempts"]), event
                    assert all(t[s]["item"] == "NO_ITEM" for t in r["log"] for s in ("player", "enemy"))
                    extra.append(r)
        write(DEST / "native-choice-checks.json", {"status": "passed", "checks": len(extra), "provenance": provenance(),
                                                  "note": "POTION appears only in the inert Acrobatics control; no probe is ranked.", "records": extra})
        print(json.dumps({"status": "passed", "native_checks": len(records), "paired_comparisons": len(pairs),
                          "extra_choice_checks": len(extra),
                          "ratios": [min(r["sharpness_ratio"] for r in pairs), max(r["sharpness_ratio"] for r in pairs)]}))
    finally:
        engine.close()


if __name__ == "__main__":
    main()
