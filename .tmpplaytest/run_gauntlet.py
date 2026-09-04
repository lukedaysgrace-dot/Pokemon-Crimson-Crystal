#!/usr/bin/env python3
"""Run authored trainer parties in the ROM's Hard Mode battle engine.

This uses a temporary DEBUG_BATTLE + PLAYTHROUGH_TEST ROM.  The temporary
build accepts six player request blocks and loads the enemy by real trainer
class/id, so enemy party data, AI, abilities, held items, and Hard Mode stat
experience all come from the game itself.
"""

import argparse
import csv
import json
import multiprocessing as mp
import re
import sys
import time
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE / "pydeps_local"))
sys.path.insert(0, str(ROOT / "tools" / "battletest"))

from pyboy import PyBoy as RealPyBoy
import runner
from state import Request
from symbols import Symbols as RealSymbols, STATE_MENU, STATE_WAIT, STATE_DONE, STATE_ERROR

ROM = HERE / "gauntlet6_debug.gbc"
SYM = HERE / "gauntlet6_debug.sym"
runner.ROM = ROM
runner.FIXTURES = HERE / "fixtures6"
runner.Symbols = lambda: RealSymbols(SYM)
runner.FRAME_CEILING_BATTLE = 60 * 60 * 3


def parse_moves():
    out = {}
    pat = re.compile(
        r"\s*move\s+(\w+),\s*(\d+),\s*(\w+),\s*(\w+),\s*(\d+),\s*(\d+),\s*(\d+)\s*;\s*(\w+)"
    )
    for line in (ROOT / "data/moves/moves.asm").read_text().splitlines():
        m = pat.match(line)
        if m:
            effect, power, typ, category, accuracy, pp, chance, name = m.groups()
            out[name] = {
                "effect": effect, "power": int(power), "type": typ,
                "category": category, "accuracy": int(accuracy), "pp": int(pp),
                "chance": int(chance),
            }
    return out


def parse_species_types():
    out = {}
    for path in (ROOT / "data/pokemon/base_stats").glob("*.asm"):
        text = path.read_text(errors="replace")
        sm = re.search(r"^\s*dw\s+(\w+)\s*; species", text, re.M)
        tm = re.search(r"^\s*db\s+(\w+),\s*(\w+)\s*; type", text, re.M)
        if sm and tm:
            out[sm.group(1)] = tm.groups()
    return out


def parse_matchups():
    out = {}
    pat = re.compile(r"\s*db\s+(\w+),\s*(\w+),\s*(\w+)")
    for line in (ROOT / "data/types/type_matchups.asm").read_text().splitlines():
        m = pat.match(line)
        if not m:
            continue
        atk, defender, result = m.groups()
        out[(atk, defender)] = {
            "SUPER_EFFECTIVE": 2.0,
            "NOT_VERY_EFFECTIVE": 0.5,
            "NO_EFFECT": 0.0,
        }.get(result, 1.0)
    return out


MOVES = parse_moves()
SPECIES_TYPES = parse_species_types()
MATCHUPS = parse_matchups()


def team_for(level):
    return [
        "CYNDAQUIL" if level < 14 else "QUILAVA" if level < 36 else "TYPHLOSION",
        "MAREEP" if level < 15 else "FLAAFFY" if level < 30 else "AMPHAROS",
        "BELLSPROUT" if level < 21 else "WEEPINBELL" if level < 32 else "VICTREEBEL",
        "GASTLY" if level < 25 else "HAUNTER" if level < 36 else "GENGAR",
        "GEODUDE" if level < 25 else "GRAVELER" if level < 36 else "GOLEM",
        "ZUBAT" if level < 22 else "GOLBAT" if level < 36 else "CROBAT",
    ]


IMMUNE_ABILITIES = {
    "LEVITATE": "GROUND", "FLASH_FIRE": "FIRE", "VOLT_ABSORB": "ELECTRIC",
    "LIGHTNING_ROD": "ELECTRIC", "MOTOR_DRIVE": "ELECTRIC",
    "WATER_ABSORB": "WATER", "STORM_DRAIN": "WATER", "DRY_SKIN": "WATER",
    "SAP_SIPPER": "GRASS",
}


def effectiveness(move_type, enemy_species, enemy_ability):
    if IMMUNE_ABILITIES.get(enemy_ability) == move_type:
        return 0.0
    value = 1.0
    for typ in SPECIES_TYPES.get(enemy_species, ("NORMAL", "NORMAL")):
        value *= MATCHUPS.get((move_type, typ), 1.0)
    return value


def choose_move(battle, blocked_slots):
    species = battle.player.species
    enemy = battle.enemy.species
    ability = battle.enemy.ability
    own_types = SPECIES_TYPES.get(species, ())
    scored = []
    for i, name in enumerate(battle.player.moves):
        if not name or battle.player.pp[i] == 0 or i in blocked_slots:
            continue
        data = MOVES.get(name, {})
        power = data.get("power", 0)
        mult = effectiveness(data.get("type", "NORMAL"), enemy, ability)
        # Prefer reliable direct damage. Status moves are a last resort; the
        # goal is a consistent route-balance probe, not puzzle-perfect play.
        score = power * mult * (1.5 if data.get("type") in own_types else 1.0)
        score *= data.get("accuracy", 100) / 100
        if power == 0:
            score = 1
        scored.append((score, i + 1, name, mult))
    if not scored:
        return 1, None
    scored.sort(reverse=True)
    return scored[0][1], scored[0]


def reopen_debug(h):
    h.tick(180)
    for _ in range(20):
        h.press("b", wait=8)
        h.press("start", hold=4, wait=12)
        for _ in range(12):
            if h.battle.mem.read("wMenuSelection") == 9:
                break
            h.press("down", hold=4, wait=12)
        h.press("a", hold=4, wait=30)
        h.tick(80)
        if h.state() == STATE_MENU:
            return True
    return False


def run_one(h, row, level, seed):
    h.load_fixture()
    m = h.battle.mem
    # STATUSFLAGS2_HARD_MODE_F = 3. This must be live before ReadTrainerParty.
    m.write("wStatusFlags2", m.read("wStatusFlags2") | (1 << 3))
    request = Request(h.battle)
    team = team_for(level)
    test = {
        "player": {"species": team[0], "level": level},
        "player2": {"species": team[1], "level": level},
        "enemy": {"species": "RATTATA", "level": row["id_num"]},
        "enemy_class": row["class"], "turns": 0,
        "rng": "seeded", "rng_value": seed,
    }
    request.write(test)
    # Constants.trainer_classes reads the source's hexadecimal display comments
    # as decimal. The extracted sequential class number is the actual enum.
    m.write("wDebugEnemyClass", row["class_num"])
    for i, name in enumerate(team[2:], 3):
        m.write_bytes(f"wDebugPlayer{i}", request._side_bytes({"species": name, "level": level}))

    frames = 0
    while frames < runner.FRAME_CEILING_BATTLE and h.state() not in (STATE_WAIT, STATE_DONE, STATE_ERROR):
        h.pb.button("a", 2); h.tick(4); frames += 4
    turns = 0
    last = None
    no_damage = 0
    move_log = Counter()
    seen_enemy = []
    seen_player = []
    while h.state() == STATE_WAIT and turns < 150:
        battle = h.battle
        snapshot = (battle.player.species, battle.enemy.species, battle.enemy.hp)
        if not seen_player or seen_player[-1] != battle.player.species:
            seen_player.append(battle.player.species)
        if not seen_enemy or seen_enemy[-1] != battle.enemy.species:
            seen_enemy.append(battle.enemy.species)
            no_damage = 0
        if last and snapshot == last:
            no_damage += 1
        else:
            no_damage = 0
        blocked = set()
        # If a direct attack has failed to change HP repeatedly, try another
        # slot (covers ability immunities and unusual type/form interactions).
        if no_damage >= 2:
            prev = m.read("wDebugMoveScript", (turns - 1) & 7)
            if 1 <= prev <= 4:
                blocked.add(prev - 1)
        slot, scored = choose_move(battle, blocked)
        if scored:
            move_log[f"{battle.player.species}:{scored[2]}"] += 1
        m.write("wDebugMoveScript", slot, turns & 7)
        m.write("wDebugTurnTarget", (turns + 1) & 0xFF)
        m.write("wDebugControl", 1)
        last = snapshot
        prior_done = battle.turns_done
        inner = 0
        while inner < 60 * 60 and h.state() not in (STATE_DONE, STATE_ERROR):
            if h.state() == STATE_WAIT and h.battle.turns_done != prior_done:
                break
            h.pb.button("a", 2); h.tick(4); inner += 4; frames += 4
        turns += 1

    state = h.state()
    result = m.read("wBattleResult") if state == STATE_DONE else 255
    return {
        "class": row["class"], "id": row["id"], "id_num": row["id_num"],
        "name": row["name"], "map": row["map"], "event": row["event"],
        "enemy_levels": [x["level"] for x in row["mons"]],
        "enemy_species": [x["species"] for x in row["mons"]],
        "player_level": level, "player_team": team, "hard_mode": True,
        "state": state, "result": result,
        "outcome": "win" if result == 0 else "loss" if result == 1 else "error",
        "turns": h.battle.turns_done,
        "faints": 6 if result == 1 else max(0, len(seen_player) - 1),
        "seen_enemy": seen_enemy, "seen_player": seen_player,
        "move_log": dict(move_log), "frames": frames,
    }


def selected_rows(smoke=False):
    rows = json.loads((HERE / "map_trainers.json").read_text())
    if smoke:
        return [next(r for r in rows if r["id"] == "FALKNER1")]
    # Each trainer party is executed once. Multiple map references to the same
    # class/id are one authored battle; alternate rival-starter branches choose
    # the Totodile branch for a Cyndaquil-led test party.
    chosen = {}
    for row in rows:
        ident = row["id"]
        if "_REMATCH" in row["class"]:
            continue
        if ("_CHIKORITA" in ident or "_CYNDAQUIL" in ident) and "RIVAL" in row["class"]:
            continue
        key = (row["class"], row["id_num"])
        chosen.setdefault(key, row)
    return sorted(chosen.values(), key=lambda r: (r["max_level"], r["map"], r["class"], r["id_num"]))


def run_batch(payload):
    batch, total = payload
    h = runner.Harness(verbose=False)
    h.ensure_fixture()
    results = []
    for index, row in batch:
        level = row["max_level"]
        result = run_one(h, row, level, (0x31 + index * 29) & 0xFF)
        result["index"] = index
        results.append(result)
        print(f"{index:03}/{total} {row['map']} {row['class']} {row['id']} "
              f"L{level}: {result['outcome']} {result['turns']}t {result['faints']}f", flush=True)
    h.pb.stop(save=False)
    return results


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smoke", action="store_true")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--workers", type=int, default=1)
    ap.add_argument("--single-index", type=int)
    args = ap.parse_args()
    rows = selected_rows(args.smoke)
    if args.single_index is not None:
        rows = [rows[args.single_index - 1]]
    if args.limit:
        rows = rows[:args.limit]
    started = time.time()
    indexed = list(enumerate(rows, 1))
    if args.workers > 1:
        batches = [indexed[i::args.workers] for i in range(args.workers)]
        with mp.Pool(args.workers) as pool:
            nested = pool.map(run_batch, [(batch, len(rows)) for batch in batches])
        results = sorted((r for batch in nested for r in batch), key=lambda r: r["index"])
    else:
        results = run_batch((indexed, len(rows)))
    out = (HERE / "single_results" / f"{args.single_index:03}.json"
           if args.single_index is not None else
           HERE / ("gauntlet_smoke.json" if args.smoke else "gauntlet_results.json"))
    out.parent.mkdir(exist_ok=True)
    out.write_text(json.dumps(results, indent=2))
    with (HERE / ("gauntlet_smoke.csv" if args.smoke else "gauntlet_results.csv")).open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["map", "class", "id", "name", "levels", "player_level", "outcome", "turns", "faints"])
        for r in results:
            w.writerow([r["map"], r["class"], r["id"], r["name"], "/".join(map(str, r["enemy_levels"])),
                        r["player_level"], r["outcome"], r["turns"], r["faints"]])
    print(json.dumps({"completed": len(results), "requested": len(rows), "seconds": round(time.time()-started, 1),
                      "outcomes": Counter(r["outcome"] for r in results)}))


if __name__ == "__main__":
    main()
