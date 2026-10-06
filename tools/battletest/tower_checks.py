#!/usr/bin/env python3
"""Exercise Battle Tower's real roster loader, conversion and stat refill."""

import io
import json

from probability_checks import call
from runner import Harness
from outcome_matrix import move_records


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    prepared = io.BytesIO()
    h.pb.save_state(prepared)
    m = h.battle.mem
    move_pp = {record["name"]: record["pp"] for record in move_records()}
    checked = errors = 0
    covered = set()

    def source_record(symbol, index=0):
        bank, address = h.sym[symbol]
        address += index * 66
        data = bytes(h.pb.memory[bank, address + i] for i in range(66))
        species = data[0] | data[1] << 8
        moves = tuple(data[i] | data[i + 1] << 8 for i in (3, 5, 7, 9))
        return species, data[2], moves, data[36], data[37]

    expected = {}
    for group in range(1, 11):
        for index in range(32):
            expected[group, index] = source_record(f"BattleTowerMons{group}", index)
    expected[10, 32] = source_record("BattleTowerMew")

    def check(condition, description):
        nonlocal checked, errors
        checked += 1
        if not condition:
            errors += 1
            print("FAIL " + description)

    for group in range(1, 11):
        for seed in range(256):
            prepared.seek(0)
            h.pb.load_state(prepared)
            m.write("wBTChoiceOfLvlGroup", group)
            m.write("hRandomAdd", seed)
            m.write("hRandomSub", seed ^ 173)
            # New challenge history, using the real SRAM and loader protocol.
            for symbol, length in (("sBTTrainers", 7), ("sBTMonOfTrainers", 12)):
                bank, address = h.sym[symbol]
                h.pb.memory[0] = 10
                h.pb.memory[0x4000] = bank
                h.pb.memory[address:address + length] = [255] * length
            bank, address = h.sym["sNrOfBeatenBattleTowerTrainers"]
            h.pb.memory[0x4000] = bank
            # The fixed Mew is a separate seventh-opponent case.
            h.pb.memory[address] = 6 if group == 10 and seed == 255 else 0
            h.pb.memory[0] = 0
            call(h, "Function_LoadOpponentTrainerAndPokemons")
            call(h, "ReadBTTrainerParty")
            species_seen, items_seen = set(), set()
            for slot in (1, 2, 3):
                prefix = f"wBT_OTTempMon{slot}"
                data = m.read_bytes(prefix, 61)
                species = m.species_index_of(data[0])
                moves = tuple(m.move_index_of(data[i]) for i in (2, 3, 4, 5))
                record = (species, data[1], moves, data[31], data[32])
                matches = [key for key, value in expected.items() if key[0] == group and value == record]
                check(bool(matches), f"pool {group} seed {seed} slot {slot}: unexpected roster {record}")
                covered.update(matches)
                check(species not in species_seen, f"pool {group} seed {seed}: duplicate species")
                check(data[1] not in items_seen, f"pool {group} seed {seed}: duplicate held item")
                species_seen.add(species)
                items_seen.add(data[1])
                check(data[21:23] == b"\xff\xff", f"pool {group} seed {seed} slot {slot}: DVs")
                hp, maxhp = data[36] * 256 + data[37], data[38] * 256 + data[39]
                check(hp == maxhp and hp > 0, f"pool {group} seed {seed} slot {slot}: HP refill")
                check(all(data[i] * 256 + data[i + 1] > 0 for i in range(40, 50, 2)),
                      f"pool {group} seed {seed} slot {slot}: stat recalculation")
                for i, index in enumerate(moves):
                    name = h.con.moves_by_index.get(index)
                    check(data[23 + i] == 0 if index == 0 else name in move_pp and data[23 + i] == move_pp[name],
                          f"pool {group} seed {seed} slot {slot}: PP for {name}")
                check(data[60] == 0x50, f"pool {group} seed {seed} slot {slot}: nickname terminator")
            # Continue to seed 255 for the separate fixed-Mew test in L100.
            if group != 10 and all((group, i) in covered for i in range(32)):
                break
        print(f"CHECK Tower pool {group}: {sum(key[0] == group for key in covered)} source builds loaded")
    missing = sorted(set(expected) - covered)
    check(not missing, f"untested Battle Tower source builds: {missing}")
    print(json.dumps({"roster_builds": len(covered), "checks": checked, "failures": errors, "missing": missing}))
    h.pb.stop(save=False)
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
