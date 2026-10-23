import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import PROJECT, ROOT, check_rom_data, extract, legal_pool, validate_build
from lab.engine import evaluate_assertions, validate_scenario
from lab.policy import candidate_builds
from lab.report import interval, rankings
from lab.store import Store, experiment_scenarios, normalize_config


class LabTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = extract()
        cls.gengar = {"species": "GENGAR", "moves": ["SHADOW_BALL", "THUNDERBOLT", "TOXIC", "PROTECT"], "ability": "LEVITATE"}
        cls.machamp = {"species": "MACHAMP", "moves": ["LOW_KICK"], "ability": "NO_GUARD"}

    def test_complete_roster(self):
        self.assertEqual(len(self.data["species"]), 498)
        self.assertEqual(len(self.data["moves"]), 442)
        for key, s in self.data["species"].items():
            self.assertTrue(set(s["legal_moves"]) <= self.data["moves"].keys(), key)

    def test_weights_from_dex(self):
        reference = json.loads((ROOT / "tools/testdata/species_weights.json").read_text())["species"]
        for key, entry in reference.items():
            expected = entry["weight_hg"]
            if expected is not None:
                self.assertEqual(self.data["species"][key]["weight_hg"], expected, key)
        for move in ("LOW_KICK", "GRASS_KNOT"):
            self.assertEqual(self.data["moves"][move]["effect"], "EFFECT_LOW_KICK")
        for move in ("HEAVY_SLAM", "HEAT_CRASH"):
            self.assertEqual(self.data["moves"][move]["effect"], "EFFECT_HEAVY_SLAM")

    def test_compiled_data(self):
        if (ROOT / "pokecrystal_debug.gbc").exists():
            self.assertEqual(check_rom_data(self.data, ROOT / "pokecrystal_debug.gbc")["compiled_species"], 498)

    def test_legal_abilities_and_moves(self):
        self.assertEqual(validate_build(self.data, self.gengar)["ability"], "LEVITATE")
        for bad in ({**self.gengar, "ability": "HUGE_POWER"}, {**self.gengar, "moves": ["SACRED_FIRE"]},
                    {**self.gengar, "moves": ["SHADOW_BALL"] * 2}, {**self.gengar, "item": "BICYCLE"},
                    {**self.gengar, "level": 101}, {**self.gengar, "dvs": -1}, {**self.gengar, "evs": [252]},
                    {**self.gengar, "stages": {"attack": 2}}, {**self.gengar, "substatus": ["MADE_UP"]}):
            with self.assertRaises(ValueError):
                validate_build(self.data, bad)

    def test_level_limits_and_tutors(self):
        for key, record in self.data["species"].items():
            self.assertTrue(legal_pool(self.data, key, 5).keys() <= legal_pool(self.data, key, 100).keys())
            self.assertTrue(set(record["tutor_moves"]) <= legal_pool(self.data, key).keys())
        self.assertIn("THUNDERBOLT", legal_pool(self.data, "GENGAR"))

    def test_candidates_legal(self):
        for species in ("GENGAR", "DITTO", "SMEARGLE", "CHARMANDER_CLONE", "WOBBUFFET", "SNORLAX"):
            for build in candidate_builds(self.data, species, 12):
                validate_build(self.data, build)

    def test_input_validation(self):
        for spec in ({"player": [], "enemy": self.gengar}, {"player": self.gengar, "enemy": self.gengar, "max_turns": 256},
                     {"player": self.gengar, "enemy": self.gengar, "scripts": {"enemy": ["switch:2"]}},
                     {"player": self.gengar, "enemy": self.gengar, "policies": ["made-up", "native"]}):
            with self.assertRaises(ValueError):
                validate_scenario(self.data, spec)

    def test_safe_assertions(self):
        result = {"winner": "player", "log": [{"turn": 1, "player": {"hp": 10}}]}
        checks = [{"path": "winner", "op": "eq", "value": "player"}, {"turn": 1, "path": "player.hp", "op": "gt", "value": 0}]
        self.assertFalse(evaluate_assertions(result, checks))
        self.assertEqual(len(evaluate_assertions(result, [{"turn": 2, "path": "player.hp", "op": "eq", "value": 0}])), 1)

    def test_uncertainty_is_not_zero_after_a_win_streak(self):
        low, high = interval({str(i): [1, 1] for i in range(8)})
        self.assertLess(low, 1)
        self.assertEqual(high, 1)
        self.assertIsNone(interval({"single-pair": [1, 1]}))

    def test_scenario_seed_preserved(self):
        config = normalize_config(self.data, {"mode": "scenarios", "scenarios": [{"player": self.gengar, "enemy": self.machamp, "seed": 1729}]})
        first = next(experiment_scenarios(self.data, config))[1]
        self.assertEqual(first["seed"], 1729)

    def test_side_swap_and_matched_seeds(self):
        config = normalize_config(self.data, {"mode": "cross-pool", "subject_count": 2,
                    "builds": [self.gengar, {**self.gengar, "ability": "MERCILESS"}, self.machamp], "repetitions": 2})
        scenarios = list(experiment_scenarios(self.data, config))
        self.assertEqual(len(scenarios), 8)
        self.assertEqual(scenarios[0][1]["seed"], scenarios[1][1]["seed"])
        self.assertEqual(scenarios[0][1]["seed"], scenarios[4][1]["seed"])
        self.assertEqual(scenarios[0][1]["player"], scenarios[1][1]["enemy"])

    def test_rankings_exclude_failures(self):
        (PROJECT / "output").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=PROJECT / "output") as directory:
            store = Store(Path(directory) / "test.sqlite")
            try:
                run = store.create(self.data, {"builds": [self.gengar, self.machamp], "repetitions": 2})
                self.assertEqual(store.progress(run)["total"], 4)
                self.assertEqual(store.create(self.data, {"builds": [self.gengar, self.machamp], "repetitions": 2}), run)
                rows = list(store.results(run))
                for row, status in zip(rows, ("completed", "turn-limit", "error", "assertion-failed")):
                    store.save(run, row["id"], {"status": "completed" if status == "assertion-failed" else status,
                               "winner": "player" if status == "completed" else "unresolved", "log": [], "turns": 1,
                               "failures": ["bad"] if status == "assertion-failed" else []})
                ranked = rankings(store, run)
                self.assertTrue(all(r["resolved"] == 1 and r["unresolved"] == 1 and r["errors"] == 1 and r["assertion_failures"] == 1 for r in ranked))
                store.pause(run)
                self.assertTrue(store.progress(run)["paused"])
            finally:
                store.close()


if __name__ == "__main__":
    unittest.main()
