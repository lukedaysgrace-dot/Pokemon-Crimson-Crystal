#!/usr/bin/env python3
"""Check native species items and item-triggered boosts in both ROMs.

Only textbox presentation is stubbed in private emulator ROM memory; the
real getters, consumption, ability and capped-stat routines still execute.
"""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from pc_harness import Harness
from battletest.symbols import Constants, _parse_constants

con = Constants()
effects = _parse_constants(ROOT / "constants/move_effect_constants.asm")

def run(rom):
    h = Harness(str(rom), str(rom.with_suffix(".sym")))
    h.boot()
    h.call("InitializeItemIndexTable")
    sound_move = h.move_id(con.moves["SNORE"])
    # Presentation is outside the assertions; real item getters, consumption,
    # ability checks, capped stat code and bank/turn restoration still execute.
    bank, address = h.sym["StdBattleTextbox"]
    h.mem[bank, address] = 0xc9
    checks, failures = 0, []
    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(label)
    def wr(name, value):
        h.wr(h.s(name), value)
    def item(name):
        return h.call("GetItemIDFromIndex", hl=con.items[name])["a"]
    def prepare(turn):
        for name in ("wCurBattleMon", "wCurOTMon", "wPlayerAbility", "wEnemyAbility",
                     "wAttackMissed", "wEffectFailed", "wSelfdestructGasTurn", "wLinkMode"):
            wr(name, 0)
        wr("wBattleMode", 2)
        wr("wPlayerStatLevels", [13] * 7)
        wr("wEnemyStatLevels", [13] * 7)
        for prefix in ("wBattleMon", "wEnemyMon"):
            wr(prefix + "HP", [0, 100])
            wr(prefix + "MaxHP", [0, 100])
            wr(prefix + "Item", 0)
        h.call("InitAbilityItemState")
        wr("hBattleTurn", turn)
    try:
        for side in (0, 1):
            for species, held in (("PIKACHU", "LIGHT_BALL"), ("CUBONE", "THICK_CLUB"),
                                  ("MAROWAK", "THICK_CLUB"), ("MAROWAK_ALOLAN", "THICK_CLUB")):
                sid = h.species_id(con.species[species])
                iid = item(held)
                for ability, foe in (("NO_ABILITY", "NO_ABILITY"), ("KLUTZ", "NO_ABILITY"),
                                     ("KLUTZ", "NEUTRALIZING_GAS"), ("KLUTZ", "MOLD_BREAKER")):
                    prepare(side)
                    wr("wPartyMon1Species", sid)
                    wr("wTempEnemyMonSpecies", sid)
                    wr(("wBattleMon" if side == 0 else "wEnemyMon") + "Item", iid)
                    wr("wPlayerAbility" if side == 0 else "wEnemyAbility", con.abilities[ability])
                    wr("wEnemyAbility" if side == 0 else "wPlayerAbility", con.abilities[foe])
                    result = h.call("DoubleStatIfSpeciesHoldingItem", bc=con.species[species], de=iid << 8, hl=100)
                    expected = 100 if ability == "KLUTZ" and foe != "NEUTRALIZING_GAS" else 200
                    label = f"{species}/{held} side={side} {ability}/{foe}"
                    check(result["hl"] == expected, label + f" stat={result['hl']} expected={expected}")
                    check(h.rd(h.s("hBattleTurn")) == side and h.rd(0xff70) & 7 == 1, label + " turn/bank")
        for side in (0, 1):
            for missed, failed in ((0, 0), (1, 0), (0, 1), (1, 1)):
                prepare(side)
                iid = item("POWER_HERB")
                wr(("wBattleMon" if side == 0 else "wEnemyMon") + "Item", iid)
                wr("wPartyMon1Item" if side == 0 else "wOTPartyMon1Item", iid)
                wr("wPlayerMoveStructEffect" if side == 0 else "wEnemyMoveStructEffect", effects["EFFECT_SKULL_BASH"])
                wr("wAttackMissed", missed)
                wr("wEffectFailed", failed)
                h.call("ModernPowerHerbUse_Core")
                prefix = "wBattleMon" if side == 0 else "wEnemyMon"
                label = f"Power Herb side={side} flags={missed}/{failed}"
                check(h.rd(h.s("wAttackMissed")) == missed and h.rd(h.s("wEffectFailed")) == failed, label + " move flags")
                check(h.rd(h.s(prefix + "Item")) == 0, label + " consumed")
                check(h.rd(h.s("hBattleTurn")) == side and h.rd(0xff70) & 7 == 1, label + " turn/bank")
        for turn in (0, 1):
            prepare(turn)
            iid = item("WEAK_POLICY")
            prefix = "wEnemyMon" if turn == 0 else "wBattleMon"
            wr(prefix + "Item", iid)
            wr("wOTPartyMon1Item" if turn == 0 else "wPartyMon1Item", iid)
            wr("wTypeModifier", 20)
            h.call("WeaknessPolicyBoost")
            label = f"Weakness Policy turn={turn}"
            check(h.rd(h.s("wAttackMissed")) == 0, label + " no false miss")
            check(h.rd(h.s(prefix + "Item")) == 0, label + " consumed")
            check(h.rd(h.s("hBattleTurn")) == turn and h.rd(0xff70) & 7 == 1, label + " turn/bank")
        for side in (0, 1):
            for ability, stage in (("NO_ABILITY", 13), ("CONTRARY", 1)):
                for missed, failed in ((0, 0), (1, 0), (0, 1), (1, 1)):
                    prepare(side)
                    iid = item("THROAT_SPRAY")
                    prefix = "wBattleMon" if side == 0 else "wEnemyMon"
                    party_item = "wPartyMon1Item" if side == 0 else "wOTPartyMon1Item"
                    levels = "wPlayerStatLevels" if side == 0 else "wEnemyStatLevels"
                    wr(prefix + "Item", iid)
                    wr(party_item, iid)
                    wr(levels, [stage] * 7)
                    wr("wPlayerAbility" if side == 0 else "wEnemyAbility", con.abilities[ability])
                    # Resolve Snore's dynamic runtime ID before testing. A
                    # recorded successful use remains successful when its
                    # secondary subsequently sets either failure flag.
                    wr("wPlayerMoveStructAnimation" if side == 0 else "wEnemyMoveStructAnimation", sound_move)
                    bank, address = h.sym["wAfterMoveAbilitiesPending"]
                    h.mem[0xff70] = bank
                    h.mem[address] = 1
                    h.mem[0xff70] = 1
                    wr("wAttackMissed", missed)
                    wr("wEffectFailed", failed)
                    h.call("ModernThroatSpray_Core")
                    label = f"Throat Spray side={side} {ability} cap={stage} flags={missed}/{failed}"
                    check(h.rd(h.s("wAttackMissed")) == missed and h.rd(h.s("wEffectFailed")) == failed, label + " move flags")
                    check(h.rd(h.s(prefix + "Item")) == 0, label + " consumed")
                    check(h.rd(h.s(party_item)) == 0, label + " party synchronized")
                    check(h.rd(h.s(levels) + 3) == stage, label + " stage capped")
                    check(h.rd(h.s("hBattleTurn")) == side and h.rd(0xff70) & 7 == 1, label + " turn/bank")
                    bank, address = h.sym["wPlayerRecycleItems" if side == 0 else "wEnemyRecycleItems"]
                    h.mem[0xff70] = bank
                    check(h.mem[address] == iid, label + " Recycle history")
                    h.mem[0xff70] = 1
    finally:
        h.pyboy.stop(save=False)
    for failure in failures:
        print("FAIL", failure)
    print(f"{rom}: {checks} checks, {len(failures)} failures", flush=True)
    return len(failures)

if __name__ == "__main__":
    paths = sys.argv[1:] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']
    failures = sum(run(Path(p)) for p in paths)
    raise SystemExit(bool(failures))
