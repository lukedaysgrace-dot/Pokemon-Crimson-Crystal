#!/usr/bin/env python3
"""Execute EXP arithmetic, trainer training and cap checks in both ROMs.

Uses private emulator state/SRAM only. No player saves are opened.
"""

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import audit_exp_economy as economy
from runner import Harness
from probability_checks import call
from symbols import _parse_constants


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", default="pokecrystal_debug.gbc")
    args = parser.parse_args()
    parties, stats, base_exp, classes, caps = economy.load_data()
    factors = economy.policies()
    h = Harness(rom_path=Path(args.rom).resolve(), render=False)
    # These routines only need WRAM, the bank register and a private stack.
    # No debug fixture or patched EXP/stat routine is used.
    m = h.battle.mem
    h.tick(400)  # Finish the CGB boot ROM before calling cartridge code.
    h.pb.memory[0xffff] = 0
    h.pb.memory[0xff0f] = 0
    checks = 0
    math_checks = 0
    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            raise AssertionError(label)
    def mode(hard):
        m.write("wStatusFlags2", 8 if hard else 0)
    def badges(n):
        bits = (1 << n) - 1
        m.write("wJohtoBadges", bits & 255)
        m.write("wKantoBadges", bits >> 8)
    def product(value):
        m.write_bytes("hProduct", value.to_bytes(4, "big"))
    def result():
        return m.read_u16_be("hProduct", 2)
    try:
        m.write("wMapGroup", 0)
        m.write("wMapNumber", 0)
        # Stat EXP is shared by all living participants, including capped
        # ones. Only regular EXP omits capped participants from its divisor.
        for mask in range(1, 64):
            slots = [i for i in range(6) if mask & (1 << i)]
            for eligible_count in range(len(slots) + 1):
                eligible = set(slots[:eligible_count])
                for i in range(6):
                    m.write(f"wPartyMon{i + 1}Level", 49 if i in eligible else 50)
                m.write("wLevelCap", 50)
                m.write("wBattleParticipantsNotFainted", mask)
                source = [91, 111, 135, 83, 109, 77, 200]
                m.write_bytes("wEnemyMonBaseStats", source)
                call(h, "DivideExperienceAndStatExp")
                expected = [v // len(slots) for v in source[:-1]] + [source[-1] // max(1, eligible_count)]
                actual = list(m.read_bytes("wEnemyMonBaseStats", 7))
                check(actual == expected, f"division mask={mask:06b} uncapped={eligible_count}: {actual} != {expected}")
        # Badge-indexed multiplication, exact truncation, saturation and the
        # real traded/Lucky Egg 1.5x helper, including its overflow boundary.
        for hard in (False, True):
            mode(hard)
            for n in range(17):
                badges(n)
                for value in (0, 1, 7, 255, 1000, 32767, 43690, 43691, 65535):
                    product(value)
                    call(h, "TrainerBoostExp", B=0x12, C=0x34, D=0x56, E=0x78, HL=0x9abc)
                    expected = min(65535, value * factors[n] if hard else value + value // 2)
                    check(result() == expected, f"bonus hard={hard} badges={n} value={value}: {result()} != {expected}")
                    r = h.pb.register_file
                    check((r.B, r.C, r.D, r.E, r.HL) == (0x12, 0x34, 0x56, 0x78, 0x9abc), f"bonus register preservation hard={hard} badges={n}: {(r.B, r.C, r.D, r.E, r.HL)}")
                    call(h, "BoostExp")
                    check(result() == min(65535, expected + expected // 2), "Lucky Egg saturation")
                call(h, "UpdateLevelCap")
                check(m.read("wLevelCap") == (caps[n] if hard and n < 16 else 100), f"cap {hard}/{n}")
        # CalcLevel must enforce the absolute ceiling even with a bad cached
        # cap and more EXP than a Pokémon can normally acquire.
        species = call(h, "GetPokemonIDFromIndex", HL=h.con.species_index("TOTODILE"))
        m.write("wTempMonSpecies", species)
        for cap, expected in ((0, 100), (1, 1), (10, 10), (100, 100), (101, 100), (130, 100), (255, 100)):
            m.write("wLevelCap", cap)
            m.write_bytes("wTempMonExp", bytes([0xff] * 3))
            call(h, "CalcLevel")
            actual = h.pb.register_file.D
            check(actual == expected, f"CalcLevel with cached cap {cap}: {actual} != {expected}")
        m.write_bytes("wTempMonExp", (179).to_bytes(3, "big"))  # Totodile's level-6 threshold.
        call(h, "CalcLevel")
        check(h.pb.register_file.D == 6, "CalcLevel still uses the EXP threshold with an invalid cap")
        m.write("wMapGroup", 0)
        m.write("wMapNumber", 0)
        m.write("wOtherTrainerID", 1)
        badges(0)
        # Native point-bonus arithmetic across every sqrt-table boundary.
        boundary_words = sorted({max(0, min(65535, root * root + delta))
                                 for root in range(257) for delta in (-1, 0, 1)})
        for first in boundary_words:
            for second in (first, 65535 - first):
                call(h, "CalculateTrainerStatExp", B=2, C=8, D=first >> 8, E=first & 255, HL=second)
                r = h.pb.register_file
                expected = economy.matched_stat_exp(first, second, 2)
                check((r.D << 8 | r.E) == expected, f"native matching arithmetic {first}/{second}: {r.D << 8 | r.E} != {expected}")
                check((r.B, r.C) == (2, 8), "matching arithmetic preserves counter/bonus")
        # Every percentage at all possible training-point averages, plus
        # uneven parties where the raw average would give a larger baseline.
        for policy in sorted(set(classes.values()) - {2}):
            equal_words = [((4 * points) ** 2,) * 2 for points in range(64)]
            for first, second in equal_words + [(10000, 0), (10000, 2500), (65535, 65535)]:
                call(h, "CalculateTrainerStatExp", B=policy, C=8, D=first >> 8, E=first & 255, HL=second)
                r = h.pb.register_file
                expected = economy.matched_stat_exp(first, second, policy)
                check((r.D << 8 | r.E) == expected, f"{policy}% native matching {first}/{second}: {r.D << 8 | r.E} != {expected}")
                check((r.B, r.C) == (policy, 8), "percentage arithmetic preserves counter/policy")
        # Exhaust every possible player word for the mathematical invariants.
        for value in range(65536):
            result_value = economy.matched_stat_exp(value, value, 2)
            assert result_value >= value, f"identical training words must retain the bonus at {value}"
            assert economy.stat_points(result_value) - economy.stat_points(value) == min(2, 63 - economy.stat_points(value)), f"matching advantage bounded at word {value}"
            math_checks += 2
        party_species = [1, 2, 3, 0xfd]
        m.write("wPartyMon1Species", 1)
        m.write("wPartyMon2Species", 2)
        m.write("wPartyMon3Species", 3)
        m.write("wPartyMon4Species", 0xfd)
        m.write_bytes("wPartyMon2HP", [0, 0])  # Fainted high-training member still counts.
        player_words = [[0, 10001, 37, 60000, 65535], [4098, 5, 12000, 65535, 0],
                        [4098, 100, 15000, 0, 65535], [65535] * 5]
        for i, words in enumerate(player_words, 1):
            m.write_bytes(f"wPartyMon{i}StatExp", b"".join(value.to_bytes(2, "big") for value in words))
        for species, expected in (([0xfd, 0], 0), ([0xfd, 0, 3], 4098)):
            m.write("wPartyCount", len(species))
            m.write_bytes("wPartySpecies", species)
            call(h, "GetPlayerTopTwoStatExp", C=0)
            r = h.pb.register_file
            check((r.D << 8 | r.E, r.HL) == (expected, expected), f"top two with zero or one eligible member: {species}")
        m.write("wPartyCount", len(party_species))
        m.write_bytes("wPartySpecies", party_species)
        top_two = [sorted(words, reverse=True)[:2] for words in zip(*player_words[:-1])]
        target_address = h.sym.addr("wOTPartyMon1")
        m.write("wLinkMode", 0)
        m.write("wInBattleTowerBattle", 0)
        m.write("wMonType", 1)
        m.write("wCurPartyLevel", 66)
        # Every class, Normal and Hard, using the actual party-loading hook.
        for cls, policy in classes.items():
            for hard in (False, True):
                mode(hard)
                m.write("wOtherTrainerClass", h.con.trainer_classes[cls])
                m.write_bytes("wOTPartyMon1StatExp", bytes([0xa5] * 10))
                call(h, "ApplyTrainerStatExpCore", D=target_address >> 8, E=target_address & 255)
                actual = [m.read_u16_be("wOTPartyMon1StatExp", j * 2) for j in range(5)]
                if not hard:
                    expected = [0] * 5
                else:
                    expected = [economy.matched_stat_exp(first, second, policy) for first, second in top_two]
                check(actual == expected, f"actual training words class={cls} hard={hard}: {actual} != {expected}")
        # External parties and player-owned mons are never rewritten.
        mode(True)
        m.write("wOtherTrainerClass", h.con.trainer_classes["BLAINE"])
        for mon_type, link, tower in ((0, 0, 0), (1, 1, 0), (1, 0, 1)):
            m.write("wMonType", mon_type)
            m.write("wLinkMode", link)
            m.write("wInBattleTowerBattle", tower)
            original = bytes(range(10))
            m.write_bytes("wOTPartyMon1StatExp", original)
            call(h, "ApplyTrainerStatExpCore", D=target_address >> 8, E=target_address & 255)
            check(m.read_bytes("wOTPartyMon1StatExp", 10) == original, "matching scope guard")
        # Exercise the entire real award path, not just division. Every mon
        # is capped, so there are no text/level-up UI calls to bypass.
        mode(True)
        badges(0)
        m.write("wLinkMode", 0)
        m.write("wInBattleTowerBattle", 0)
        m.write("wDebugFlags", 0)
        m.write("wPartyCount", 6)
        m.write("wCurBattleMon", 0)
        for infected in (False, True):
            m.write("wBattleParticipantsNotFainted", 63)
            m.write("wPendingStatExpRecalcs", 0)
            source = [90, 110, 130, 80, 100, 77, 200]
            m.write_bytes("wEnemyMonBaseStats", source)
            for i in range(1, 7):
                m.write(f"wPartyMon{i}Level", 10)
                m.write_bytes(f"wPartyMon{i}HP", [0, 20])
                m.write_bytes(f"wPartyMon{i}StatExp", bytes(10))
                m.write(f"wPartyMon{i}PokerusStatus", int(infected))
            call(h, "GiveExperiencePoints")
            expected_words = [v // 6 * (2 if infected else 1) for v in source[:5]]
            for i in range(1, 7):
                actual = [m.read_u16_be(f"wPartyMon{i}StatExp", j * 2) for j in range(5)]
                check(actual == expected_words, f"full capped award slot={i} Pokerus={infected}: {actual}")
            check(m.read("wPendingStatExpRecalcs") == 63, "all actual recipients marked for stat recalculation")
        # Restore the deliberately uneven party for loading
        # opponent rosters below (Egg is excluded; fainted member is included).
        m.write("wPartyCount", len(party_species))
        m.write_bytes("wPartySpecies", party_species)
        m.write_bytes("wPartyMon2HP", [0, 0])
        for i, words in enumerate(player_words, 1):
            m.write_bytes(f"wPartyMon{i}StatExp", b"".join(value.to_bytes(2, "big") for value in words))
        # Verify actual party construction and map-specific Johto overrides,
        # not only the lookup routine. Stage 0/1/2 uses any prior branch badges.
        map_ids = {}
        group = 0
        number = 0
        for line in economy.read("constants/map_constants.asm").splitlines():
            if economy.re.fullmatch(r"\s*newgroup\s*(?:;.*)?", line):
                group += 1
                number = 0
            if match := economy.re.match(r"\s*map_const\s+(\w+)", line):
                number += 1
                map_ids[match[1]] = group, number
        # The large late-Jasmine allowance applies to her gym only, and only
        # at five/six badges. It must not leak to its neighbors or rematches.
        gym_group, gym_number = map_ids["OLIVINE_GYM"]
        for n in (4, 5, 6, 7, 16):
            badges(n)
            for group_value, number_value in ((gym_group, gym_number), (gym_group + 1, gym_number), (gym_group, gym_number + 1)):
                m.write("wMapGroup", group_value)
                m.write("wMapNumber", number_value)
                for hard in (False, True):
                    mode(hard)
                    product(1234)
                    call(h, "TrainerBoostExp")
                    in_gym = (group_value, number_value) == (gym_group, gym_number)
                    factor = economy.trainer_multiplier(n, "OlivineGym" if in_gym else "", factors)
                    expected = 1234 * factor if hard else 1851
                    check(result() == expected, f"scoped Jasmine EXP badges={n} map={group_value}/{number_value} hard={hard}")
        overrides = economy.open_parties(parties)
        mode(True)
        m.write("wLinkMode", 0)
        m.write("wInBattleTowerBattle", 0)
        m.write("wBattleMode", 2)
        for cls, tid, map_name, own_bit in (("CHUCK", "CHUCK1", "CIANWOOD_GYM", 5),
                                            ("JASMINE", "JASMINE1", "OLIVINE_GYM", 4),
                                            ("PRYCE", "PRYCE1", "MAHOGANY_GYM", 6)):
            other_bits = [b for b in (4, 5, 6) if b != own_bit]
            for tier in range(3):
                mask = 15 | sum(1 << b for b in other_bits[:tier])
                m.write("wJohtoBadges", mask)
                m.write("wKantoBadges", 0)
                m.write("wMapGroup", map_ids[map_name][0])
                m.write("wMapNumber", map_ids[map_name][1])
                m.write("wOtherTrainerClass", h.con.trainer_classes[cls])
                m.write("wOtherTrainerID", 1)
                check(call(h, "GetOpenProgressionStage") == tier, f"{cls}/{tier} detected stage")
                call(h, "SelectOpenProgressionParty")
                selected = h.pb.register_file.HL
                check(selected == h.sym.addr(f"OpenParty_{cls}_{tid}_{tier}"), f"{cls}/{tier} selected pointer {selected:04x}, expected {h.sym.addr(f'OpenParty_{cls}_{tid}_{tier}'):04x}")
                call(h, "ReadTrainerParty")
                expected = overrides[map_name, cls, tid, tier]["mons"]
                check(m.read("wOTPartyCount") == len(expected), f"{cls}/{tier} party count")
                for i, mon in enumerate(expected, 1):
                    prefix = f"wOTPartyMon{i}"
                    check(m.read(prefix + "Level") == mon["level"], f"{cls}/{tier}/{i} level {m.read(prefix + 'Level')} expected {mon['level']}; badges {m.read('wJohtoBadges'):02x}/{m.read('wKantoBadges'):02x}")
                    actual = [m.read_u16_be(prefix + "StatExp", j * 2) for j in range(5)]
                    expected_words = [economy.matched_stat_exp(first, second, classes[cls]) for first, second in top_two]
                    check(actual == expected_words, f"{cls}/{tier}/{i} all five matched training words: {actual}")
        # Execute the actual script branch through the native interpreter,
        # stopping before its first text command (no UI emulation required).
        engine_ids = _parse_constants(economy.ROOT / "constants/engine_flags.asm")
        event_ids = _parse_constants(economy.ROOT / "constants/event_flags.asm")
        daily_id = engine_ids["ENGINE_FOUGHT_IN_TRAINER_HALL_TODAY"]
        league_id = event_ids["EVENT_BEAT_ELITE_FOUR"]
        bank, address = h.sym["TrainerHouseReceptionistScript.TrainingAccess"]
        for hard in (False, True):
            for champion in (False, True):
                for fought in (False, True):
                    mode(hard)
                    call(h, "EngineFlagAction", B=int(fought), D=daily_id >> 8, E=daily_id & 255)
                    call(h, "EventFlagAction", B=int(champion), D=league_id >> 8, E=league_id & 255)
                    m.write("wScriptBank", bank)
                    m.write_bytes("wScriptPos", address.to_bytes(2, "little"))
                    for _ in range(16):
                        pos = int.from_bytes(m.read_bytes("wScriptPos", 2), "little")
                        opcode = h.pb.memory[bank, pos]
                        if opcode == 0x4c:  # writetext; observe its target without executing UI
                            target = h.pb.memory[bank, pos + 1] | h.pb.memory[bank, pos + 2] << 8
                            label = ("TrainerHouseB1FPostgameTrainingText" if hard and champion else
                                     "TrainerHouseB1FSecondChallengeDeniedText" if fought else "TrainerHouseB1FIntroText")
                            check(target == h.sym.addr(label), f"Hall access hard={hard} champion={champion} fought={fought}")
                            break
                        check(opcode in (0x34, 0x31, 0x08, 0x09), f"unexpected Hall access opcode {opcode:02x}")
                        call(h, "RunScriptCommand")
                    else:
                        raise AssertionError("Training Hall access branch did not reach a text")
        output = Path(".tmpbuild/exp-economy")
        output.mkdir(parents=True, exist_ok=True)
        (output / (Path(args.rom).stem + ".json")).write_text(json.dumps(dict(checks=checks, math_checks=math_checks, failures=0), indent=2) + "\n")
        print(f"{args.rom}: {checks} ROM checks and {math_checks} mathematical checks passed.")
    finally:
        h.pb.stop(save=False)


if __name__ == "__main__":
    main()
