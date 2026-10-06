#!/usr/bin/env python3
"""Drive retail battle menus with button input instead of auto moves."""

from pathlib import Path

from runner import Harness, AssertionContext, snapshot_side, apply_wram_setup
from state import Request


def tile_text(h):
    def character(value):
        if 0x80 <= value <= 0x99:
            return chr(value - 0x80 + ord("A"))
        if 0xA0 <= value <= 0xB9:
            return chr(value - 0xA0 + ord("a"))
        return " "
    raw = h.battle.mem.read_bytes("wTileMap", 360)
    return "\n".join("".join(character(v) for v in raw[i:i + 20]) for i in range(0, 360, 20))


def wait(h, predicate, advance=False):
    for _ in range(1800):
        if predicate():
            h.tick(60)
            return
        if advance:
            h.pb.button("a", 2)
        h.tick(4)
    raise RuntimeError(f"menu did not reach expected state: {h.where()}; {tile_text(h)}")


def start(h, source="NO_ABILITY", target="NO_ABILITY", setup=None, options=0x40, frame=0):
    h.load_fixture()
    h.battle.mem.write("wOptions", options)
    h.battle.mem.write("wTextboxFrame", frame)
    test = {"player": {"species": "MEW", "level": 50, "ability": source,
                       "moves": ["TACKLE", "SWAGGER", "SKILL_SWAP", "SPLASH"]},
            "player2": {"species": "PORYGON", "level": 50, "ability": "TRACE", "moves": ["TACKLE", "SPLASH"]},
            "enemy": {"species": "SNORLAX", "level": 100, "ability": target, "moves": ["SPLASH"]},
            "rng": "forced_low", "turns": 1}
    Request(h.battle).write(test)
    h.battle.mem.write("wDebugBattleFlags", 0)
    wait(h, lambda: "FIGHT" in tile_text(h), advance=True)
    apply_wram_setup(h.battle, setup)
    return {"player": snapshot_side(h.battle.player), "enemy": snapshot_side(h.battle.enemy)}


def fight(h):
    h.press("a", hold=8, wait=80)
    wait(h, lambda: "SWAGGER" in tile_text(h))


def choose(h, slot, initial_pp):
    fight(h)
    for _ in range(slot - 1):
        h.press("down", hold=8, wait=20)
    h.press("a", hold=8, wait=20)
    wait(h, lambda: h.battle.player.pp[slot - 1] < initial_pp and "FIGHT" in tile_text(h), advance=True)


def main():
    h = Harness()
    h.ensure_fixture()
    output = Path(".venv/battle-ui")
    output.mkdir(parents=True, exist_ok=True)
    passed = failed = assertions = 0
    def verify(name, snapshot, expressions):
        nonlocal passed, failed, assertions
        env = AssertionContext(h.battle, snapshot, {}).env()
        errors = list(h.text_overflows)
        for expression in expressions:
            assertions += 1
            if not eval(expression, {"__builtins__": {}}, env):
                errors.append(expression)
        h.pb.screen.image.save(str(output / (name.replace(" ", "-") + ".png")))
        if errors:
            failed += 1
            print(f"FAIL UI {name}: {errors}; player={snapshot_side(h.battle.player)}, enemy={snapshot_side(h.battle.enemy)}")
        else:
            passed += 1
            print(f"PASS UI {name}")

    snapshot = start(h)
    fight(h)
    verify("move menu", snapshot, ["player.pp == player.start_pp", "player.moves == player.start_moves"])
    h.press("b", hold=8, wait=80)
    wait(h, lambda: "FIGHT" in tile_text(h))
    verify("cancel move menu", snapshot, ["player.pp == player.start_pp", "enemy.hp == enemy.start_hp"])
    choose(h, 1, snapshot["player"]["pp"][0])
    verify("Tackle through menu", snapshot, ["enemy.hp < enemy.start_hp", "player.start_pp[0] - player.pp[0] == 1", "wram('wInAbility') == 0"])

    cases = [
        ("reflected Swagger", "NO_ABILITY", "MAGIC_BOUNCE", 2, None,
         ["player.stat_levels[0] == 9", "enemy.stat_levels[0] == 7", "(player.substatus[2] & 128) != 0", "enemy.status == 0"]),
        ("Gas disables reflection", "NEUTRALIZING_GAS", "MAGIC_BOUNCE", 2, None,
         ["enemy.stat_levels[0] == 9", "player.stat_levels[0] == 7", "(enemy.substatus[2] & 128) != 0"]),
        ("Mold bypasses Contrary", "MOLD_BREAKER", "CONTRARY", 2, None,
         ["enemy.stat_levels[0] == 9", "(enemy.substatus[2] & 128) != 0"]),
        ("Substitute blocks Swagger", "NO_ABILITY", "NO_ABILITY", 2,
         {"wEnemySubStatus4": 16, "wEnemySubstituteHP": 100},
         ["enemy.stat_levels[0] == 7", "(enemy.substatus[2] & 128) == 0", "enemy.hp == enemy.start_hp"]),
        ("Skill Swap versus Wonder Skin", "SYNCHRONIZE", "WONDER_SKIN", 3, None,
         ["player.ability == 'WONDER_SKIN'", "enemy.ability == 'SYNCHRONIZE'"]),
        ("Skill Swap versus Pressure", "SYNCHRONIZE", "PRESSURE", 3, None,
         ["player.ability == 'PRESSURE'", "enemy.ability == 'SYNCHRONIZE'", "player.start_pp[2] - player.pp[2] == 2"]),
    ]
    for name, source, target, slot, setup, expressions in cases:
        snapshot = start(h, source, target, setup)
        choose(h, slot, snapshot["player"]["pp"][slot - 1])
        verify(name, snapshot, expressions + ["wram('wInAbility') == 0", "(wram('wDisguiseBusted', 1) & 64) == 0"])

    snapshot = start(h, target="MAGIC_BOUNCE")
    h.press("right", hold=8, wait=20)
    h.press("a", hold=8, wait=80)
    wait(h, lambda: "PORYGON" in tile_text(h))
    verify("party menu", snapshot, ["player.species == 'MEW'", "player.pp == player.start_pp"])
    h.press("b", hold=8, wait=80)
    wait(h, lambda: "FIGHT" in tile_text(h))
    verify("cancel party menu", snapshot, ["player.species == 'MEW'", "player.pp == player.start_pp"])
    h.press("a", hold=8, wait=80)
    wait(h, lambda: "PORYGON" in tile_text(h))
    h.press("down", hold=8, wait=20)
    h.press("a", hold=8, wait=60)
    h.press("a", hold=8, wait=20)
    wait(h, lambda: h.battle.player.species == "PORYGON" and "FIGHT" in tile_text(h), advance=True)
    verify("switch through party menu", snapshot, ["player.species == 'PORYGON'", "player.ability == 'MAGIC_BOUNCE'", "textbox_seen('TraceActivationText')", "wram('wInAbility') == 0"])

    print(f"{passed} UI scenarios passed, {failed} failed; {assertions} assertions")
    h.pb.stop(save=False)
    return int(bool(failed))


if __name__ == "__main__":
    raise SystemExit(main())
