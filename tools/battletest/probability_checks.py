#!/usr/bin/env python3
"""Enumerate every RNG byte through actual ROM chance/critical routines.

These are routine-level outcome checks. They prove probability thresholds
and suppression/bypass behavior, not the hardware RNG's distribution.
"""

import io
import json
from pathlib import Path

from runner import Harness
from state import Request
from symbols import STATE_WAIT


def call(harness, symbol, **registers):
    pb, memory = harness.pb, harness.battle.mem
    bank, address = harness.sym[symbol]
    # Execute the real ROM routine with a return sentinel in the spare stack.
    sentinel, sp = 0xC0F0, 0xC0EC
    pb.memory[sentinel:sentinel + 3] = [0xF3, 0x18, 0xFE]
    pb.memory[sp:sp + 2] = [sentinel & 255, sentinel >> 8]
    pb.memory[0xFF70] = 1
    if bank:
        pb.memory[0x2000] = bank
        memory.write("hROMBank", bank)
    pb.register_file.SP = sp
    for name, value in registers.items():
        setattr(pb.register_file, name, value)
    pb.register_file.PC = address
    for _ in range(120):
        pb.tick(1, False)
        if pb.register_file.PC in (sentinel + 1, sentinel + 3):
            return pb.register_file.A
    raise RuntimeError(f"{symbol} failed to return: PC={pb.register_file.PC:04x}")


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    test = {"player": {"species": "MEW", "level": 100, "ability": "NO_ABILITY", "moves": ["THUNDERPUNCH"]},
            "enemy": {"species": "MEW", "level": 100, "ability": "NO_ABILITY", "moves": ["THUNDERPUNCH"]},
            "rng": "forced_low", "turns": 0}
    if h.run_battle(test) != STATE_WAIT:
        raise RuntimeError("could not pause the initialized battle")
    # The pre-turn pause precedes move selection. Populate the real move
    # structures before calling routines that inspect power/effect/animation.
    m = h.battle.mem
    for direction, mon, current in ((0, "wBattleMonMoves", "wCurPlayerMove"),
                                    (1, "wEnemyMonMoves", "wCurEnemyMove")):
        m.write("hBattleTurn", direction)
        m.write(current, m.read(mon))
        call(h, "UpdateMoveData")
    if m.read("wPlayerMoveStruct", 2) != 75 or m.read("wEnemyMoveStruct", 2) != 75:
        raise RuntimeError("ThunderPunch's move structures were not populated")
    prepared = io.BytesIO()
    h.pb.save_state(prepared)
    checks = failures = groups = 0

    configurations = [("NO_ABILITY", "NO_ABILITY", 1), ("SERENE_GRACE", "NO_ABILITY", 2),
                      ("SHEER_FORCE", "NO_ABILITY", 0), ("NO_ABILITY", "SHIELD_DUST", 0),
                      ("MOLD_BREAKER", "SHIELD_DUST", 1), ("NEUTRALIZING_GAS", "SHIELD_DUST", 1),
                      ("SERENE_GRACE", "NEUTRALIZING_GAS", 1), ("SHEER_FORCE", "NEUTRALIZING_GAS", 1)]
    for direction in (0, 1):
        for source, target, multiplier in configurations:
            for chance in (0, 1, 25, 51, 76, 127, 128, 254, 255):
                prepared.seek(0)
                h.pb.load_state(prepared)
                m.write("hBattleTurn", direction)
                m.write("wPlayerAbility", h.con.ability_id(target if direction else source))
                m.write("wEnemyAbility", h.con.ability_id(source if direction else target))
                m.write("wEnemyMoveStruct" if direction else "wPlayerMoveStruct", chance, 7)
                m.write("hDebugRNGMode", 1)
                threshold = min(255, chance * multiplier)
                successes = 0
                for roll in range(256):
                    m.write("hDebugRNGValue", roll)
                    call(h, "BattleCommand_EffectChance_Core")
                    success = m.read("wEffectFailed") == 0
                    expected = threshold == 255 or roll < threshold
                    # Suppressing a zero-chance move returns normally, then
                    # the ordinary threshold of zero still fails every roll.
                    checks += 1
                    successes += success
                    if success != expected:
                        failures += 1
                        print(f"FAIL secondary {direction} {source}/{target} chance={chance} roll={roll}: {success} != {expected}")
                groups += 1
                print(f"CHECK secondary {direction} {source}/{target} chance={chance}: {successes}/256")

    critical = [("ordinary", "NO_ABILITY", "NO_ABILITY", "NO_ITEM", 0, 0, 11),
                ("Super Luck", "SUPER_LUCK", "NO_ABILITY", "NO_ITEM", 0, 0, 32),
                ("Focus Energy", "NO_ABILITY", "NO_ABILITY", "NO_ITEM", 4, 0, 128),
                ("Scope Lens", "NO_ABILITY", "NO_ABILITY", "SCOPE_LENS", 0, 0, 32),
                ("Scope plus Super Luck", "SUPER_LUCK", "NO_ABILITY", "SCOPE_LENS", 0, 0, 128),
                ("guaranteed critical", "NO_ABILITY", "NO_ABILITY", "SCOPE_LENS", 4, 0, 256),
                ("Klutz item", "KLUTZ", "NO_ABILITY", "SCOPE_LENS", 0, 0, 11),
                ("Gas suppresses Super Luck", "SUPER_LUCK", "NEUTRALIZING_GAS", "NO_ITEM", 0, 0, 11),
                ("Battle Armor", "NO_ABILITY", "BATTLE_ARMOR", "SCOPE_LENS", 4, 0, 0),
                ("Shell Armor", "NO_ABILITY", "SHELL_ARMOR", "SCOPE_LENS", 4, 0, 0),
                ("Mold bypasses armor", "MOLD_BREAKER", "BATTLE_ARMOR", "SCOPE_LENS", 4, 0, 256),
                ("Gas suppresses armor", "NEUTRALIZING_GAS", "SHELL_ARMOR", "SCOPE_LENS", 4, 0, 256),
                ("Merciless", "MERCILESS", "NO_ABILITY", "NO_ITEM", 0, 8, 256),
                ("armor blocks Merciless", "MERCILESS", "BATTLE_ARMOR", "NO_ITEM", 0, 8, 0)]
    for direction in (0, 1):
        for name, source, target, item, substatus, status, expected_count in critical:
            prepared.seek(0)
            h.pb.load_state(prepared)
            m.write("hBattleTurn", direction)
            m.write("hDebugRNGMode", 1)
            m.write("wPlayerAbility", h.con.ability_id(target if direction else source))
            m.write("wEnemyAbility", h.con.ability_id(source if direction else target))
            m.write("wEnemyMonItem" if direction else "wBattleMonItem", h.con.item_id(item))
            m.write("wEnemySubStatus4" if direction else "wPlayerSubStatus4", substatus)
            m.write("wBattleMonStatus" if direction else "wEnemyMonStatus", status)
            count = 0
            for roll in range(256):
                m.write("hDebugRNGValue", roll)
                call(h, "BattleCommand_Critical")
                outcome = m.read("wCriticalHit") != 0
                checks += 1
                count += outcome
                expected = roll < expected_count
                if outcome != expected:
                    failures += 1
                    print(f"FAIL critical {direction} {name} roll={roll}: {outcome} != {expected}")
            groups += 1
            print(f"CHECK critical {direction} {name}: {count}/256")

    summary = {"groups": groups, "outcome_checks": checks, "failures": failures}
    print(json.dumps(summary))
    h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == "__main__":
    raise SystemExit(main())
