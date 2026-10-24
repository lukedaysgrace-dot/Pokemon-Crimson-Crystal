"""Audit schedule properties that affect validity of no-item comparisons."""
import json
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import canonical, extract
from no_item_audit import abilities, eligible, fixture, guard_no_items, proposals, summarize


class NoItemAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = extract()

    def test_every_ability_gets_identical_moves_and_opening_portfolio(self):
        for species in ("CERULEDGE", "AZUMARILL", "CLOYSTER", "WOBBUFFET", "UNOWN", "SMEARGLE"):
            candidates = proposals(self.data, species)
            portfolios = {}
            for c in candidates:
                self.assertEqual(c["build"]["item"], "NO_ITEM")
                portfolios.setdefault(c["build"]["ability"], set()).add(canonical([c["build"]["moves"], c["opener"]]))
            self.assertEqual(set(portfolios), set(abilities(self.data, species)))
            self.assertTrue(all(v == next(iter(portfolios.values())) for v in portfolios.values()))

    def test_item_guard_checks_opponents_and_forbids_injected_states(self):
        a = proposals(self.data, "CERULEDGE")[0]
        b = proposals(self.data, "MEWTWO")[0]
        s = fixture(a, b, 1)
        guard_no_items([s])
        bad = json.loads(json.dumps(s))
        bad["enemy"]["item"] = "FOCUS_SASH"
        with self.assertRaises(ValueError):
            guard_no_items([bad])
        bad = json.loads(json.dumps(s))
        bad["player"]["stages"] = {"atk": 2}
        with self.assertRaises(ValueError):
            guard_no_items([bad])

    def test_sides_swap_builds_and_actual_openings_together(self):
        a = next(c for c in proposals(self.data, "CERULEDGE") if c["opener"])
        b = proposals(self.data, "MEWTWO")[0]
        first, second = fixture(a, b, 19), fixture(a, b, 19, swap=True)
        self.assertEqual(first["seed"], second["seed"])
        self.assertEqual(first["player"], second["enemy"])
        self.assertEqual(first["scripts"]["player"], second["scripts"]["enemy"])

    def test_eligibility_remains_final_stages_and_excludes_starter_families(self):
        roster = eligible(self.data)
        self.assertEqual(len(roster), 231)
        self.assertIn("CERULEDGE", roster)
        self.assertIn("MEWTWO", roster)
        for s in ("CHARIZARD", "CHARMELEON", "CHARMANDER", "TYPHLOSION_HISUIAN", "RAICHU"):
            self.assertNotIn(s, roster)

    def test_mirror_opponents_count_once_and_keep_both_orientations(self):
        a = proposals(self.data, "CERULEDGE")[0]
        specs = [fixture(a, a, 9, swap=swap, name=f"check subject={a['id']}") for swap in (False, True)]
        self.assertNotEqual(specs[0]["name"], specs[1]["name"])
        records = [{"spec": {**s, "player": [s["player"]], "enemy": [s["enemy"]]},
                    "result": {"status": "completed", "failures": [], "winner": "player", "turns": 1}} for s in specs]
        class FakeStore:
            def results(self, run):
                return iter(records)
        rows = summarize(FakeStore(), "mirror", [a])
        self.assertEqual(rows[0]["games"], 2)
        self.assertEqual(rows[0]["wins"], 1)
        self.assertEqual(rows[0]["losses"], 1)


if __name__ == "__main__":
    unittest.main()
