"""Regression cases for strategic blind spots exposed by the roster audit."""
import copy
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import extract
from lab.policy import choose, move_score


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

    def test_awake_rest_talk_user_does_not_request_sleep_only_moves(self):
        user = self.combatant("SNORLAX", ["LICK", "SLEEP_TALK", "SNORE", "REST"])
        foe = self.combatant("MEW", ["PSYCHIC_M"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)

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

    def test_sharpness_recognizes_the_games_bitter_blade_membership(self):
        user = self.combatant("CERULEDGE", ["FIRE_BLAST", "BITTER_BLADE"], "SHARPNESS")
        foe = self.combatant("MEW", ["PSYCHIC_M"])
        self.assertIn("slice", self.data["moves"]["BITTER_BLADE"]["traits"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)
        user["ability"] = "WEAK_ARMOR"
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)

    def test_soundproof_does_not_receive_repeated_sound_attack_requests(self):
        user = self.combatant("MEW", ["HYPER_VOICE", "PSYCHIC_M"])
        foe = self.combatant("ELECTRODE", ["THUNDERBOLT"], "SOUNDPROOF")
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_empty_hands_change_acrobatics_choice(self):
        user = self.combatant("CROBAT", ["ACROBATICS", "WING_ATTACK"])
        foe = self.combatant("MEW", ["PSYCHIC_M"])
        user["item"] = "NO_ITEM"
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)
        user["item"] = "LEFTOVERS"
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_no_guard_exposes_dynamic_punch_instead_of_discounting_its_accuracy(self):
        user = self.combatant("MACHAMP", ["DYNAMICPUNCH", "CROSS_CHOP"], "NO_GUARD")
        foe = self.combatant("MEW", ["PSYCHIC_M"])
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)
        user["ability"] = "GUTS"
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_hail_changes_blizzard_choice(self):
        user = self.combatant("ARTICUNO", ["BLIZZARD", "ICE_BEAM"], "SNOW_WARNING")
        foe = self.combatant("MEW", ["PSYCHIC_M"])
        user["weather"] = self.data["weather_ids"]["WEATHER_HAIL"]
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 1)
        user["weather"] = 0
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_gas_removes_no_guards_selection_advantage(self):
        user = self.combatant("MACHAMP", ["DYNAMICPUNCH", "CROSS_CHOP"], "NO_GUARD")
        foe = self.combatant("MEW", ["PSYCHIC_M"], "NEUTRALIZING_GAS")
        self.assertEqual(choose(self.data, user, foe, "tactical", 1), 2)

    def test_heavy_target_does_not_receive_a_fictitious_technician_weight_boost(self):
        user = self.combatant("SCIZOR", ["GRASS_KNOT"], "TECHNICIAN")
        foe = self.combatant("SNORLAX", ["BODY_SLAM"])
        technician = move_score(self.data, "GRASS_KNOT", user, foe)
        user["ability"] = "SWARM"
        self.assertEqual(technician, move_score(self.data, "GRASS_KNOT", user, foe))


if __name__ == "__main__":
    unittest.main()
