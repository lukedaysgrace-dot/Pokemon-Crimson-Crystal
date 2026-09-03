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


def parse_learnsets():
    out = {}
    current = None
    label = re.compile(r"^(\w+)EvosAttacks:")
    learned = re.compile(r"\s*dbw\s+(\d+),\s*(\w+)")
    for path in (ROOT / "data/pokemon").glob("evos_attacks_*.asm"):
        for line in path.read_text(errors="replace").splitlines():
            match = label.match(line)
            if match:
                current = match.group(1).upper()
                out.setdefault(current, [])
                continue
            match = learned.match(line)
            if current and match:
                out[current].append((int(match.group(1)), match.group(2)))
    return out


LEARNSETS = parse_learnsets()

# Inclusive evolution levels. This reconstructs moves a normal playthrough
# retains from earlier stages instead of treating an evolved mon as freshly
# generated at its current level.
LINEAGES = {
    "CYNDAQUIL": [("CYNDAQUIL", 1, None)],
    "QUILAVA": [("CYNDAQUIL", 1, 14), ("QUILAVA", 14, None)],
    "TYPHLOSION": [("CYNDAQUIL", 1, 14), ("QUILAVA", 14, 36), ("TYPHLOSION", 36, None)],
    "MAREEP": [("MAREEP", 1, None)],
    "FLAAFFY": [("MAREEP", 1, 15), ("FLAAFFY", 15, None)],
    "AMPHAROS": [("MAREEP", 1, 15), ("FLAAFFY", 15, 30), ("AMPHAROS", 30, None)],
    "BELLSPROUT": [("BELLSPROUT", 1, None)],
    "WEEPINBELL": [("BELLSPROUT", 1, 21), ("WEEPINBELL", 21, None)],
    "VICTREEBEL": [("BELLSPROUT", 1, 21), ("WEEPINBELL", 21, 32), ("VICTREEBEL", 32, None)],
    "GASTLY": [("GASTLY", 1, None)],
    "HAUNTER": [("GASTLY", 1, 25), ("HAUNTER", 25, None)],
    "GENGAR": [("GASTLY", 1, 25), ("HAUNTER", 25, 36), ("GENGAR", 36, None)],
    "GEODUDE": [("GEODUDE", 1, None)],
    "GRAVELER": [("GEODUDE", 1, 25), ("GRAVELER", 25, None)],
    "GOLEM": [("GEODUDE", 1, 25), ("GRAVELER", 25, 36), ("GOLEM", 36, None)],
    "ZUBAT": [("ZUBAT", 1, None)],
    "GOLBAT": [("ZUBAT", 1, 22), ("GOLBAT", 22, None)],
    "CROBAT": [("ZUBAT", 1, 22), ("GOLBAT", 22, 36), ("CROBAT", 36, None)],
}


def persistent_player_moves(species, level):
    available = {}
    for stage, first_level, final_level in LINEAGES[species]:
        ceiling = level if final_level is None else min(level, final_level)
        for learned_level, move in LEARNSETS.get(stage, []):
            if first_level <= learned_level <= ceiling:
                available[move] = learned_level
    scored = []
    own_types = SPECIES_TYPES.get(species, ())
    for move, learned_level in available.items():
        data = MOVES.get(move, {})
        power = data.get("power", 0)
        if (not power or move in {"DREAM_EATER"} or
                "SELFDESTRUCT" in data.get("effect", "")):
            continue
        score = power * data.get("accuracy", 100) / 100
        score *= 1.5 if data.get("type") in own_types else 1.0
        scored.append((score, learned_level, move, data.get("type", "NORMAL")))
    # First take the strongest attack of each type for usable coverage, then
    # fill remaining slots by raw score. This is competent but TM-free.
    scored.sort(reverse=True)
    picked = []
    used_types = set()
    for entry in scored:
        if entry[3] not in used_types:
            picked.append(entry)
            used_types.add(entry[3])
        if len(picked) == 4:
            break
    for entry in scored:
        if entry not in picked:
            picked.append(entry)
        if len(picked) == 4:
            break
    return [entry[2] for entry in picked]


def player_spec(species, level):
    return {"species": species, "level": level,
            "moves": persistent_player_moves(species, level)}


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


def party_slot_info(battle, slot):
    """Read a boxed party member directly from battle WRAM (1-based slot)."""
    m = battle.mem
    prefix = f"wPartyMon{slot}"
    rid = m.read(prefix + "Species")
    species = battle.con.species_by_index.get(m.species_index_of(rid), f"IDX_{rid}")
    moves = []
    for i in range(4):
        move_rid = m.read(prefix + "Moves", i)
        move = (battle.con.moves_by_index.get(m.move_index_of(move_rid))
                if move_rid else None)
        moves.append(move)
    return {
        "slot": slot, "species": species, "moves": moves,
        "pp": [m.read(prefix + "PP", i) & 0x3f for i in range(4)],
        "hp": m.read_u16_be(prefix + "HP"),
        "maxhp": m.read_u16_be(prefix + "MaxHP"),
    }


def best_party_attack(info, enemy_species, enemy_ability):
    own_types = SPECIES_TYPES.get(info["species"], ())
    best = 0.0
    for move, pp in zip(info["moves"], info["pp"]):
        if not move or not pp:
            continue
        data = MOVES.get(move, {})
        power = data.get("power", 0)
        if not power:
            continue
        value = power * effectiveness(data.get("type", "NORMAL"), enemy_species, enemy_ability)
        value *= 1.5 if data.get("type") in own_types else 1.0
        value *= data.get("accuracy", 100) / 100
        best = max(best, value)
    return best


def defensive_pressure(species, enemy_moves):
    """Worst expected type multiplier from the foe's authored damaging moves."""
    own_types = SPECIES_TYPES.get(species, ("NORMAL", "NORMAL"))
    worst = 1.0
    for move in enemy_moves:
        data = MOVES.get(move, {})
        if not data.get("power", 0):
            continue
        value = 1.0
        for typ in own_types:
            value *= MATCHUPS.get((data.get("type", "NORMAL"), typ), 1.0)
        worst = max(worst, value)
    return worst


def choose_tactical_switch(battle, row):
    """Choose the best legal switch-in across all six party slots."""
    current_slot = battle.mem.read("wCurBattleMon") + 1
    enemy_entry = next((x for x in row["mons"] if x["species"] == battle.enemy.species), None)
    enemy_moves = enemy_entry["moves"] if enemy_entry else []
    candidates = []
    for slot in range(1, 7):
        info = party_slot_info(battle, slot)
        if not info["hp"] or not info["maxhp"]:
            continue
        offense = best_party_attack(info, battle.enemy.species, battle.enemy.ability)
        pressure = defensive_pressure(info["species"], enemy_moves)
        hp_ratio = info["hp"] / info["maxhp"]
        score = offense * (0.65 + 0.35 * hp_ratio) / max(0.5, pressure)
        candidates.append((score, slot, offense, pressure, info["species"]))
    if not candidates:
        return None
    candidates.sort(reverse=True)
    best = candidates[0]
    current = next((x for x in candidates if x[1] == current_slot), None)
    if best[1] == current_slot or current is None:
        return None
    # Switch for a major offensive upgrade, or to escape a weakness into a
    # safer matchup. This spends a real turn and obeys the engine's trap check.
    if best[0] >= current[0] * 1.55 or (current[3] >= 2 and best[3] <= 1):
        return best
    return None


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


def run_one(h, row, level, seed, tactical_switching=False):
    h.load_fixture()
    if tactical_switching:
        # gauntlet6_debug.gbc: widen DebugChoosePlayerMove's action mask from
        # %11 to %111 so encoded switches $80..$85 reach party slots 1..6.
        # This patches emulator ROM memory only; the checked-in ROM and shipped
        # game code are untouched.
        h.pb.memory[0x8f, 0x4622] = 0x07
    m = h.battle.mem
    # STATUSFLAGS2_HARD_MODE_F = 3. This must be live before ReadTrainerParty.
    m.write("wStatusFlags2", m.read("wStatusFlags2") | (1 << 3))
    request = Request(h.battle)
    team = team_for(level)
    test = {
        "player": player_spec(team[0], level),
        "player2": player_spec(team[1], level),
        "enemy": {"species": "RATTATA", "level": row["id_num"]},
        # Write the extracted sequential class id below. The stock battletest
        # constants parser only recognizes decimal comments, while late class
        # comments are hexadecimal (and some have no numeric comment).
        "enemy_class": None, "turns": 0,
        "rng": "seeded", "rng_value": seed,
    }
    request.write(test)
    # Constants.trainer_classes reads the source's hexadecimal display comments
    # as decimal. The extracted sequential class number is the actual enum.
    m.write("wDebugEnemyClass", row["class_num"])
    for i, name in enumerate(team[2:], 3):
        m.write_bytes(f"wDebugPlayer{i}", request._side_bytes(player_spec(name, level)))

    frames = 0
    while frames < runner.FRAME_CEILING_BATTLE and h.state() not in (STATE_WAIT, STATE_DONE, STATE_ERROR):
        h.pb.button("a", 2); h.tick(4); frames += 4
    turns = 0
    last = None
    no_damage = 0
    move_log = Counter()
    seen_enemy = []
    seen_player = []
    switched_for_enemy = None
    max_faints = 0
    while h.state() == STATE_WAIT and turns < 150:
        battle = h.battle
        max_faints = max(max_faints, sum(
            party_slot_info(battle, i)["hp"] == 0 for i in range(1, 7)))
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
        switch = None
        if tactical_switching and switched_for_enemy != battle.enemy.species:
            switch = choose_tactical_switch(battle, row)
        if switch:
            slot, scored = 0x80 + switch[1] - 1, None
            move_log[f"SWITCH:{battle.player.species}->{switch[4]}"] += 1
            switched_for_enemy = battle.enemy.species
        else:
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
        "faints": 6 if result == 1 else max_faints,
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
    batch, total, forced_seed, tactical_switching = payload
    h = runner.Harness(verbose=False)
    h.ensure_fixture()
    results = []
    for index, row in batch:
        level = row["max_level"]
        result = run_one(h, row, level,
                         forced_seed if forced_seed is not None else (0x31 + index * 29) & 0xFF,
                         tactical_switching=tactical_switching)
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
    ap.add_argument("--seed", type=lambda x: int(x, 0))
    ap.add_argument("--tactical-switching", action="store_true")
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
            nested = pool.map(run_batch, [(batch, len(rows), args.seed, args.tactical_switching) for batch in batches])
        results = sorted((r for batch in nested for r in batch), key=lambda r: r["index"])
    else:
        results = run_batch((indexed, len(rows), args.seed, args.tactical_switching))
    single_dir = "tactical_single_results" if args.tactical_switching else "single_results"
    out = (HERE / single_dir / f"{args.single_index:03}.json"
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
