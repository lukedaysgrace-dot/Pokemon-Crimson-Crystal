#!/usr/bin/env python3
"""Two emulator instances exercise retail link RNG and outcome synchrony.

This does not emulate the cable handshake or a complete two-player battle.
Debug RNG overrides are disabled while the actual link-mode routines run.
"""

import io
import json

from probability_checks import call
from runner import Harness
from state import Request
from symbols import STATE_WAIT


def main():
    machines = [Harness(), Harness()]
    for h in machines:
        h.ensure_fixture()
        h.load_fixture()
        test = {"player": {"species": "MEW", "level": 100, "ability": "SERENE_GRACE", "moves": ["THUNDERPUNCH"]},
                "enemy": {"species": "MEW", "level": 100, "ability": "NO_ABILITY", "moves": ["THUNDERPUNCH"]},
                "rng": "forced_low", "turns": 0}
        if h.run_battle(test) != STATE_WAIT:
            raise RuntimeError("could not initialize link RNG fixture")
        for direction, mon, current in ((0, "wBattleMonMoves", "wCurPlayerMove"), (1, "wEnemyMonMoves", "wCurEnemyMove")):
            h.battle.mem.write("hBattleTurn", direction)
            h.battle.mem.write(current, h.battle.mem.read(mon))
            call(h, "UpdateMoveData")
    initial = []
    for h in machines:
        state = io.BytesIO()
        h.pb.save_state(state)
        initial.append(state)
    checks = failures = 0
    for seed in range(0, 256, 8):
        for h, state in zip(machines, initial):
            state.seek(0)
            h.pb.load_state(state)
            m = h.battle.mem
            m.write("hDebugRNGMode", 0)
            m.write("wLinkMode", 1)
            m.write("wLinkBattleRNCount", 0)
            m.write_bytes("wLinkBattleRNs", [(seed + 23 * i) & 255 for i in range(10)])
        for step in range(512):
            symbol = ("BattleRandom", "BattleCommand_EffectChance_Core", "BattleCommand_Critical")[step % 3]
            results = []
            for h in machines:
                m = h.battle.mem
                m.write("hBattleTurn", step & 1)
                result = call(h, symbol)
                results.append((result if symbol == "BattleRandom" else
                                m.read("wEffectFailed" if symbol == "BattleCommand_EffectChance_Core" else "wCriticalHit"),
                                m.read("wLinkBattleRNCount"), m.read_bytes("wLinkBattleRNs", 10)))
            checks += 1
            if results[0] != results[1]:
                failures += 1
                print(f"FAIL link RNG seed={seed} step={step} {symbol}: {results}")
        print(f"CHECK link RNG seed {seed}: 512 matched routine calls")
    print(json.dumps({"seeds": 32, "synchrony_checks": checks, "failures": failures}))
    for h in machines:
        h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == "__main__":
    raise SystemExit(main())
