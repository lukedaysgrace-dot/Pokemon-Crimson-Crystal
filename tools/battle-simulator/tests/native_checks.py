"""Real-ROM integration checks; run separately from fast source tests."""
import copy
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import PROJECT, canonical, extract
from lab.engine import RomEngine
from lab.policy import candidate_builds


def main():
    data = extract()
    engine = RomEngine(data)
    results = []
    def run(name, spec):
        result = engine.run({"name": name, **spec})
        results.append(result)
        assert result["status"] != "error", (name, result.get("error"))
        assert not result["failures"], (name, result["failures"])
        print(f"PASS {name}: {result['status']} / {result['winner']} / {result['turns']} turns", flush=True)
        return result
    try:
        a = {"species": "GENGAR", "ability": "LEVITATE", "moves": ["SHADOW_BALL", "PROTECT"]}
        b = {"species": "MACHAMP", "ability": "GUTS", "moves": ["EARTHQUAKE", "BULLET_PUNCH"]}
        scenario = {"player": a, "enemy": b, "max_turns": 10, "scripts": {"player": [1], "enemy": [1]}}
        first = run("Levitate native immunity", scenario)
        assert first["log"][1]["player"]["hp"] == first["log"][0]["player"]["hp"]
        second = run("Reproducible replay", scenario)
        assert canonical(first["log"]) == canonical(second["log"])
        weight = run("Native weight-derived Low Kick", {"player": {"species": "MACHAMP", "moves": ["LOW_KICK"], "ability": "GUTS"},
                    "enemy": {"species": "SNORLAX", "moves": ["DEFENSE_CURL"], "ability": "IMMUNITY"}, "max_turns": 1,
                    "scripts": {"player": [1], "enemy": [1]}})
        event = next(e for e in weight["log"][1]["actions"] if e["side"] == "player")
        assert event["damage_attempts"][0]["base_power"] == 120, event
        team_a = [candidate_builds(data, s, 1)[0] for s in ("GENGAR", "SNORLAX", "MACHAMP", "ALAKAZAM", "TYRANITAR", "DRAGONITE")]
        team_b = [candidate_builds(data, s, 1)[0] for s in ("MEW", "BLISSEY", "SALAMENCE", "SKARMORY", "GYARADOS", "FORRETRESS")]
        teams = run("Six native party members and switch slot six", {"player": team_a, "enemy": team_b, "max_turns": 3, "scripts": {"player": ["switch:6", 1, 1]}})
        assert len(teams["log"][0]["player"]["team"]) == len(teams["log"][0]["enemy"]["team"]) == 6
        assert teams["log"][1]["player"]["species"] == "DRAGONITE", teams["log"][1]["player"]
        full = run("Complete six versus six", {"player": team_a, "enemy": team_b, "max_turns": 100})
        assert full["status"] == "completed", full["status"]
        run("Two-turn native rollout", {"player": a, "enemy": b, "max_turns": 2, "policies": ["rollout", "tactical"]})
        run("Enemy native rollout", {"player": a, "enemy": b, "max_turns": 2, "policies": ["tactical", "rollout"]})
        depleted = run("Exhausted PP", {"player": {"species": "MEW", "moves": ["PROTECT"]},
                       "enemy": {"species": "BLISSEY", "moves": ["PROTECT"]}, "max_turns": 30})
        for side in ("player", "enemy"):
            assert any(e["move"] == "STRUGGLE" and e["side"] == side for t in depleted["log"] for e in t.get("actions", [])), f"{side} must use native Struggle when PP is exhausted"
        original_stage = engine._stage_teams
        def empty_player_pp():
            original_stage()
            engine.mem.write_bytes("wBattleMonPP", [0] * 4)
            engine.mem.write_bytes("wPartyMon1PP", [0] * 4)
        engine._stage_teams = empty_player_pp
        try:
            empty = run("All four player moves exhausted", {"player": {"species": "MEW", "moves": ["POUND", "CONFUSION", "SWIFT", "FLAMETHROWER"]},
                        "enemy": {"species": "BLISSEY", "moves": ["DEFENSE_CURL"]}, "max_turns": 2})
            assert all(e["move"] == "STRUGGLE" for t in empty["log"] for e in t.get("actions", []) if e["side"] == "player")
            assert any(e["side"] == "player" for t in empty["log"] for e in t.get("actions", []))
        finally:
            engine._stage_teams = original_stage
        future = run("Policy avoids pending Future Sight", {"player": {"species": "ALAKAZAM", "moves": ["FUTURE_SIGHT", "PSYCHIC_M"]},
                     "enemy": {"species": "SNORLAX", "moves": ["DEFENSE_CURL"]}, "max_turns": 2,
                     "scripts": {"player": [1], "enemy": [1, 1]}})
        assert next(e for e in future["log"][2]["actions"] if e["side"] == "player")["move"] == "PSYCHIC_M"
    finally:
        engine.close()
        out = PROJECT / "output/native-checks.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(results, indent=2), encoding="utf-8")
    print(f"{len(results)} native integration scenarios passed")


if __name__ == "__main__":
    main()
