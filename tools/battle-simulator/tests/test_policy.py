"""Regression cases for strategic blind spots exposed by the roster audit."""
import copy
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import extract
from lab.policy import choose


class AuditChoiceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = extract()

    def combatant(self, species, moves, ability="NO_ABILITY"):
        return {"species": species, "moves": moves, "pp": [10]*len(moves), "hp": 200, "maxhp": 200,
                "level": 100, "status": 0, "types": self.data["species"][species]["types"],
                "ability": ability, "stages": [7]*7, "stats": {"attack": 150, "defense": 150,
                "speed": 150, "spclatk": 150, "spcldef": 150}}

    def test_counter_user_reads_physical_or_special_threat(self):
        user = self.combatant("WOBBUFFET", ["COUNTER", "MIRROR_COAT", "DESTINY_BOND"])
        foe = self.combatant("MACHAMP", ["CROSS_CHOP"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)
        foe = self.combatant("ALAKAZAM", ["PSYCHIC_M"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_sleep_talk_user_does_not_keep_requesting_sleep_blocked_attacks(self):
        user = self.combatant("SNORLAX", ["BODY_SLAM", "SLEEP_TALK", "REST"])
        user["status"] = 3
        foe = self.combatant("MACHAMP", ["CROSS_CHOP"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)
        user["pp"][1] = 0
        self.assertNotEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_skill_link_can_choose_native_multi_hit_attack(self):
        user = self.combatant("CLOYSTER", ["ICICLE_SPEAR", "ICE_BEAM"], "SKILL_LINK")
        foe = self.combatant("DRAGONITE", ["OUTRAGE"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)

    def test_fixed_damage_is_not_treated_as_one_power(self):
        user = self.combatant("BLISSEY", ["SEISMIC_TOSS", "POUND"])
        foe = self.combatant("SNORLAX", ["BODY_SLAM"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)

    def test_ground_coverage_avoids_levitate_but_respects_mold_breaker(self):
        user = self.combatant("EXCADRILL", ["EARTHQUAKE", "SHADOW_CLAW"])
        foe = self.combatant("GENGAR", ["SHADOW_BALL"], "LEVITATE")
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)
        user["ability"] = "MOLD_BREAKER"
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)


if __name__ == "__main__":
    unittest.main()
