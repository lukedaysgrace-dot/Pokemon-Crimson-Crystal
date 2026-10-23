"""Scenario transport for the existing real-ROM battle harness.

No damage, move effect, ability effect or held-item effect is implemented here.
The only injections are requests, parties, player/AI choices and seeded RNG.
"""
from __future__ import annotations

import copy
import io
import random
import sys
import time
from importlib.metadata import version
from pathlib import Path

from .data import PROJECT, ROOT, canonical, check_rom_data, digest, validate_build
from .policy import POLICIES, choose

sys.path.insert(0, str(ROOT / "tools/battletest"))


def validate_scenario(data, spec):
    allowed = {"name", "player", "enemy", "seed", "max_turns", "policies", "weather", "scripts", "assertions"}
    if not isinstance(spec, dict) or spec.keys() - allowed:
        raise ValueError("unknown scenario fields")
    result = copy.deepcopy(spec)
    for side in ("player", "enemy"):
        team = result.get(side)
        if isinstance(team, dict):
            team = [team]
        if not isinstance(team, list) or not 1 <= len(team) <= 6:
            raise ValueError(f"{side} must have one to six builds")
        result[side] = [validate_build(data, m) for m in team]
    result.setdefault("name", "Custom scenario")
    result.setdefault("seed", 1)
    result.setdefault("max_turns", 100)
    result.setdefault("policies", ["tactical", "tactical"])
    result.setdefault("scripts", {})
    if type(result["seed"]) is not int or not 0 <= result["seed"] < 2 ** 64:
        raise ValueError("seed must be a 64-bit unsigned integer")
    if type(result["max_turns"]) is not int or not 1 <= result["max_turns"] <= 200:
        raise ValueError("max_turns must be 1..200 (native counter is one byte)")
    if not isinstance(result["policies"], list) or len(result["policies"]) != 2 or any(p not in POLICIES for p in result["policies"]) or result["policies"][0] == "native":
        raise ValueError("choose two supported policies; native is enemy-only")
    if result.get("weather") not in (None, "none", "rain", "sun", "sandstorm", "hail"):
        raise ValueError("unknown weather")
    if not isinstance(result["scripts"], dict) or result["scripts"].keys() - {"player", "enemy"}:
        raise ValueError("scripts must name player/enemy")
    for side, actions in result["scripts"].items():
        if not isinstance(actions, list) or len(actions) > 200:
            raise ValueError("scripts must be action lists up to 200 turns")
        for action in actions:
            if type(action) is int and 1 <= action <= 4:
                continue
            if side == "player" and isinstance(action, str) and action.startswith("switch:") and action[7:].isdigit() and 1 <= int(action[7:]) <= len(result[side]):
                continue
            raise ValueError("script actions are move slots 1..4 or player switch:1..6")
    for check in result.get("assertions", []):
        if not isinstance(check, dict) or check.keys() - {"turn", "path", "op", "value", "message"} or check.get("op") not in {"eq", "ne", "lt", "le", "gt", "ge", "contains"} or not isinstance(check.get("path"), str):
            raise ValueError("assertions need path, op, value and optional turn/message")
    return result


def evaluate_assertions(result, assertions):
    import operator
    ops = {"eq": operator.eq, "ne": operator.ne, "lt": operator.lt, "le": operator.le, "gt": operator.gt, "ge": operator.ge, "contains": lambda a, b: b in a}
    failures = []
    for check in assertions:
        try:
            value = result if "turn" not in check else next(t for t in result["log"] if t["turn"] == check["turn"])
            for part in check["path"].split("."):
                value = value[int(part)] if isinstance(value, list) else value[part]
            if not ops[check["op"]](value, check["value"]):
                failures.append({"assertion": check, "observed": value})
        except (KeyError, IndexError, StopIteration, TypeError, ValueError) as error:
            failures.append({"assertion": check, "error": str(error) or "checkpoint not reached"})
    return failures


class RomEngine:
    def __init__(self, data, rom_path=None, verify=True):
        from runner import Harness
        self.data = data
        self.rom_path = Path(rom_path or ROOT / "pokecrystal_debug.gbc")
        self.verification = check_rom_data(data, self.rom_path) if verify else {}
        self.h = Harness(rom_path=self.rom_path, render=False)
        self.h.ensure_fixture()
        self.pb, self.mem = self.h.pb, self.h.battle.mem
        self.spec = None
        self.events = []
        self.finished = None
        self.selected_enemy = None
        self.switch_target = None
        self.in_turn = False
        self.turn_frames = 0
        self.calling = False
        self.setup_rng = random.Random(1)
        self.hooks = []
        for symbol, callback in (("DebugBattleSetup.no_seed", self._seed),
                                 ("ParseEnemyAction.skip_load", self._enemy_choice),
                                 ("DoTurn", self._action),
                                 ("BattleCommand_ApplyDamage", self._damage),
                                 ("BattleCommand_DamageCalc", self._damage_calc),
                                 ("DebugBattleTeardown", self._finish),
                                 ("PlayerSwitch", self._switch)):
            if symbol == "DoTurn":
                # Harness already owns this hook; replace it below.
                continue
            bank, addr = self.h.sym[symbol]
            self.pb.hook_register(bank, addr, callback, None)
            self.hooks.append((bank, addr))
        # Harness registers a bound callback at construction; replace it explicitly.
        bank, addr = self.h.sym["DoTurn"]
        self.pb.hook_deregister(bank, addr)
        self.pb.hook_register(bank, addr, self._action, None)
        self.hooks.append((bank, addr))
        lab_files = sorted((PROJECT / "lab").glob("*.py")) + [PROJECT / "simulator.py"]
        self.metadata = {"engine": "native-rom", "pyboy": version("pyboy"), "rom_key": self.h.rom_key(),
                         "rom_sha256": digest(self.rom_path.read_bytes()),
                         "laboratory_sha256": digest(canonical({p.name: digest(p.read_bytes()) for p in lab_files}).encode()),
                         "transport": "lab-v1", "data_sha256": data["data_sha256"]}

    def close(self):
        for bank, address in self.hooks:
            self.pb.hook_deregister(bank, address)
        self.hooks.clear()
        self.pb.stop(save=False)
        self.h._rom_tempdir.cleanup()

    def _seed(self, _):
        if self.spec is not None:
            self.mem.write_bytes("wLinkBattleRNs", self.setup_rng.randbytes(10))
            self.mem.write("wLinkBattleRNCount", 0)

    def _switch(self, _):
        if self.switch_target is not None:
            self.mem.write("wCurPartyMon", self.switch_target)
            self.mem.write("wCurBattleMon", self.switch_target)
            self.switch_target = None

    def _enemy_choice(self, _):
        if self.selected_enemy is None or not self.in_turn:
            return
        # Preserve native lock-in and Encore. The ROM handles held move locks
        # and Taunt/Disable after this point, exactly as for normal selection.
        sub = self.h.battle.enemy.substatus
        from state import SUBSTATUS_BITS
        for key in ("ROLLOUT", "RAMPAGE", "BIDE", "CHARGED", "ENCORED", "RECHARGE"):
            byte, bit = SUBSTATUS_BITS[key]
            if sub[byte] & (1 << bit):
                return
        slot = self.selected_enemy - 1
        if self.mem.read("wEnemyMonMoves", slot) and (self.mem.read("wEnemyMonPP", slot) & 63):
            self.mem.write("wCurEnemyMoveNum", slot)
            self.mem.write("wCurEnemyMove", self.mem.read("wEnemyMonMoves", slot))

    def _action(self, _):
        if not self.in_turn or self.calling:
            return
        side = "enemy" if self.mem.read("hBattleTurn") else "player"
        prefix = "wCurEnemyMove" if side == "enemy" else "wCurPlayerMove"
        idx = self.mem.move_index_of(self.mem.read(prefix))
        self.events.append({"side": side, "move": self.h.con.moves_by_index.get(idx, f"MOVE_{idx}"),
                            "hp_before": self.h.battle.enemy.hp if side == "enemy" else self.h.battle.player.hp})

    def _finish(self, _):
        if self.spec is not None and not self.calling:
            code = self.mem.read("wBattleResult") & 63
            self.finished = {"winner": {0: "player", 1: "enemy", 2: "draw"}.get(code, "unresolved"),
                             "native_result": code, "state": self.snapshot()}

    def _damage(self, _):
        if not self.in_turn or not self.events:
            return
        side = "enemy" if self.mem.read("hBattleTurn") else "player"
        event = next((e for e in reversed(self.events) if e["side"] == side), None)
        if event is not None:
            event.setdefault("damage_attempts", []).append({
                "base_power": self.mem.read("wDamageCalcBasePower") if event.get("damage_formula") else None,
                "damage": self.mem.read_u16_be("wCurDamage"),
                "critical": bool(self.mem.read("wCriticalHit")),
                "missed": bool(self.mem.read("wAttackMissed"))})

    def _damage_calc(self, _):
        if self.in_turn and self.events:
            self.events[-1]["damage_formula"] = True

    def _transport(self, build):
        spec = dict(build)
        ability = spec.pop("ability")
        slot = self.data["species"][spec["species"]]["abilities"].index(ability)
        spec["ability_slot"] = {0: 1, 1: 2, 2: "hidden"}[slot]
        return spec

    def _call_native(self, symbol, **registers):
        """Call a party-construction routine and return to the paused ROM.

        Restore CPU context, stack, bank, scratch sentinel and interrupt state;
        the native routine's party/table writes intentionally remain.
        """
        r = self.pb.register_file
        saved = {k: getattr(r, k) for k in ("A", "F", "B", "C", "D", "E", "HL", "SP", "PC")}
        bank, address = self.h.sym[symbol]
        old_bank, old_svbk = self.mem.read("hROMBank"), self.pb.memory[0xff70]
        sentinel = 0xc0f0
        original = bytes(self.pb.memory[sentinel:sentinel + 8])
        stack = saved["SP"] - 2
        stack_bytes = bytes(self.pb.memory[stack:stack + 2])
        self.pb.memory[sentinel:sentinel + 2] = [0x18, 0xfe]  # return loop; keep interrupts as-is
        self.pb.memory[stack:stack + 2] = [sentinel & 255, sentinel >> 8]
        self.pb.memory[0xff70] = 1
        self.pb.memory[0x2000] = bank
        self.mem.write("hROMBank", bank)
        r.SP, r.PC = stack, address
        for name, value in registers.items():
            if name in {"BC", "DE", "AF"}:
                setattr(r, name[0], value >> 8)
                setattr(r, name[1], value & 255)
            else:
                setattr(r, name, value)
        self.calling = True
        try:
            for _ in range(180):
                self.pb.tick(1, False)
                if r.PC == sentinel:
                    break
            else:
                raise RuntimeError(f"native party construction failed: {symbol}, PC={r.PC:04x}")
        finally:
            self.calling = False
            self.pb.memory[sentinel:sentinel + 8] = original
            self.pb.memory[stack:stack + 2] = stack_bytes
            self.pb.memory[0x2000] = old_bank
            self.mem.write("hROMBank", old_bank)
            self.pb.memory[0xff70] = old_svbk
            for name, value in saved.items():
                setattr(r, name, value)

    def _stage_teams(self):
        # Native party construction borrows global base-data and selection
        # scratch. Preserve the initialized battle's context around bench setup.
        fields = {"wCurSpecies": 1, "wCurPartySpecies": 1, "wCurPartyLevel": 1,
                  "wCurPartyMon": 1, "wMonType": 1, "wNamedObjectIndexBuffer": 1,
                  "wCurBaseData": self.h.sym.addr("wCurBaseDataEnd") - self.h.sym.addr("wCurBaseData"),
                  "hDebugPtr": 2, "hDebugNum": 2, "hMoveMon": 1}
        saved = {name: self.mem.read_bytes(name, length) for name, length in fields.items()}
        try:
            self._build_teams()
        finally:
            for name, raw in saved.items():
                self.mem.write_bytes(name, raw)

    def _build_teams(self):
        from state import Request
        request = Request(self.h.battle)
        for side, prefix, count in (("player", "wPartyMon", "wPartyCount"), ("enemy", "wOTPartyMon", "wOTPartyCount")):
            team = self.spec[side]
            for slot in range(2, len(team)):
                self.mem.write_bytes("wDebugPlayer2", request._side_bytes(self._transport(team[slot])))
                self.mem.write("wMonType", 0 if side == "player" else 1)
                self._call_native("DebugBuildPartyMon", DE=self.h.sym.addr("wDebugPlayer2"), B=slot)
            self.mem.write(count, len(team))
            self.mem.write("wPartySpecies" if side == "player" else "wOTPartySpecies", 255, len(team))
            for slot, build in enumerate(team, 1):
                self.mem.write(f"{prefix}{slot}Happiness", build["happiness"])
                self.mem.write(f"{prefix}{slot}HiddenPowerType", self.data["type_ids"].get(build.get("hidden_power_type"), 0))
            active = "wBattleMon" if side == "player" else "wEnemyMon"
            self.mem.write(active + "Happiness", team[0]["happiness"])
            self.mem.write(active + "HiddenPowerType", self.data["type_ids"].get(team[0].get("hidden_power_type"), 0))
        self.mem.write("wMonType", 0)

    def snapshot(self):
        result = {"turn": self.h.battle.turns_done, "weather": self.h.battle.weather}
        reverse_types = {v: k for k, v in self.data["type_ids"].items()}
        for key, side, prefix, party, current, count in (
                ("player", self.h.battle.player, "wBattleMon", "wPartyMon", "wCurBattleMon", "wPartyCount"),
                ("enemy", self.h.battle.enemy, "wEnemyMon", "wOTPartyMon", "wCurOTMon", "wOTPartyCount")):
            active = self.mem.read(current)
            team = []
            for slot in range(self.mem.read(count)):
                hp = side.hp if slot == active else self.mem.read_u16_be(f"{party}{slot + 1}HP")
                maxhp = side.maxhp if slot == active else self.mem.read_u16_be(f"{party}{slot + 1}MaxHP")
                idx = self.mem.species_index_of(self.mem.read(f"{party}{slot + 1}Species"))
                team.append({"species": self.h.con.species_by_index.get(idx), "hp": hp, "maxhp": maxhp,
                             "level": self.mem.read(f"{party}{slot + 1}Level")})
            disabled = self.mem.read("wDisabledMove" if key == "player" else "wEnemyDisabledMove")
            lock = self.mem.read("wPlayerGigaHammerLock" if key == "player" else "wEnemyGigaHammerLock")
            result[key] = {"species": side.species, "level": side.level, "hp": side.hp, "maxhp": side.maxhp,
                           "weight_hg": self.data["species"].get(side.species, {}).get("weight_hg"),
                           "status": side.status, "ability": side.ability, "item": side.item,
                           "moves": side.moves, "pp": side.pp, "stats": side.stats,
                           "stages": side.stat_levels, "substatus": side.substatus, "screens": side.screens,
                           "types": list(dict.fromkeys(reverse_types.get(self.mem.read(prefix + f"Type{i}"), "UNKNOWN") for i in (1, 2))),
                           "active": active, "team": team,
                           "future_sight": self.mem.read("wPlayerFutureSightCount" if key == "player" else "wEnemyFutureSightCount"),
                           "fresh": bool(self.mem.read("wPlayerFirstImpressionFresh" if key == "player" else "wEnemyFirstImpressionFresh")),
                           "disabled": self.h.con.moves_by_index.get(self.mem.move_index_of(disabled)),
                           "giga_lock": self.h.con.moves_by_index.get(self.mem.move_index_of(lock))}
        return result

    def _wait(self, target=None):
        from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR
        for _ in range(4500):
            state = self.h.state()
            if state == STATE_ERROR:
                raise RuntimeError("ROM rejected the scenario")
            if self.finished or state == STATE_DONE:
                return
            if state == STATE_WAIT and (target is None or self.h.battle.turns_done >= target):
                return
            self.pb.button("a", 2)
            self.h.tick(4)
            self.turn_frames += 4
        raise RuntimeError(f"ROM timeout: {self.h.control_state()}")

    def _step(self, action, enemy_action, turn):
        self.events = []
        self.selected_enemy = enemy_action
        self.switch_target = None
        if isinstance(action, str):
            self.switch_target = int(action.split(":")[1]) - 1
            if self.switch_target == self.mem.read("wCurBattleMon") or self.mem.read_u16_be(f"wPartyMon{self.switch_target + 1}HP") == 0:
                raise ValueError("script requested a fainted or already active switch target")
            # The original debug transport encodes four switch slots. PlayerSwitch
            # hook supplies the full party index; retail switch logic is unchanged.
            encoded = 0x80 | (self.switch_target & 3)
        else:
            encoded = action
        self.mem.write("wDebugMoveScript", encoded, min(turn - 1, 7))
        self.mem.write("wDebugTurnTarget", turn)
        self.mem.write("wDebugControl", 1)
        self.in_turn = True
        try:
            self._wait(turn)
        finally:
            self.in_turn = False
        snapshot = self.finished["state"] if self.finished else self.snapshot()
        snapshot = copy.deepcopy(snapshot)
        snapshot["actions"] = list(self.events)
        snapshot["requested_actions"] = {"player": action, "enemy": enemy_action or "native"}
        snapshot["abilities_seen"] = [self.h.con.abilities_by_id.get(a, str(a)) for a in self.h.battle.activated_abilities]
        snapshot["text_contexts"] = sorted(self.h.battle.textbox_contexts)
        return snapshot

    def _rollout(self, snapshot, turn, side="player"):
        """Two-turn native lookahead with a sampled RNG stream, not seed peeking."""
        buffer = io.BytesIO()
        self.pb.save_state(buffer)
        saved_finished = self.finished
        saved_text_context = self.h.text_context
        saved_overflows = list(self.h.text_overflows)
        saved_contexts = set(self.h.battle.textbox_contexts)
        moves = [i + 1 for i, m in enumerate(snapshot[side]["moves"]) if m and snapshot[side]["pp"][i]] or [1]
        scores = []
        for action in moves:
            buffer.seek(0)
            self.pb.load_state(buffer)
            self.finished = None
            # Every action faces the same independent sample. Restoring the
            # original state later preserves the actual battle's RNG stream.
            self.mem.write_bytes("wLinkBattleRNs", random.Random(turn * 7919).randbytes(10))
            self.mem.write("wLinkBattleRNCount", 0)
            state = snapshot
            try:
                for depth in range(min(2, self.spec["max_turns"] - turn + 1)):
                    own = action if depth == 0 and side == "player" else choose(self.data, state["player"], state["enemy"], "tactical", turn + depth)
                    other = action if depth == 0 and side == "enemy" else choose(self.data, state["enemy"], state["player"], "tactical", turn + depth)
                    state = self._step(own, other, turn + depth)
                    if self.finished:
                        break
                score = sum(m["hp"] / max(1, m["maxhp"]) for m in state["player"]["team"]) - sum(m["hp"] / max(1, m["maxhp"]) for m in state["enemy"]["team"])
                score += (10 if self.finished["winner"] == "player" else -10) if self.finished else 0
                if side == "enemy":
                    score = -score
                scores.append((score, -action, action))
            except RuntimeError:
                scores.append((-1000, -action, action))
        buffer.seek(0)
        self.pb.load_state(buffer)
        self.finished = saved_finished
        self.h.text_context = saved_text_context
        self.h.text_overflows = saved_overflows
        self.h.battle.textbox_contexts = saved_contexts
        return max(scores)[2]

    def run(self, scenario):
        spec = validate_scenario(self.data, scenario)
        self.spec = spec
        self.finished = None
        self.setup_rng = random.Random(spec["seed"])
        self.h.load_fixture()
        self.in_turn = False
        self.turn_frames = 0
        result = {"scenario": spec, "format": "1v1" if len(spec["player"]) == len(spec["enemy"]) == 1 else ("6v6" if len(spec["player"]) == len(spec["enemy"]) == 6 else "custom-team"),
                  "metadata": self.metadata, "winner": "unresolved", "status": "running", "log": [], "failures": []}
        started = time.monotonic()
        try:
            request = {"player": self._transport(spec["player"][0]),
                       "player2": self._transport(spec["player"][1]) if len(spec["player"]) > 1 else None,
                       "enemy": self._transport(spec["enemy"][0]),
                       "enemy2": self._transport(spec["enemy"][min(1, len(spec["enemy"]) - 1)]),
                       "enemy_class": "FALKNER", "rng": "seeded", "rng_value": spec["seed"] & 255, "turns": 0}
            if spec.get("weather") is not None:
                request["weather"] = spec["weather"]
            from state import Request
            Request(self.h.battle).write(request)
            self._wait()
            if self.finished:
                raise RuntimeError("battle ended before the initial checkpoint")
            self._stage_teams()
            initial = self.snapshot()
            result["log"].append(initial)
            state = initial
            for turn in range(1, spec["max_turns"] + 1):
                actions = []
                for index, side in enumerate(("player", "enemy")):
                    script = spec["scripts"].get(side, [])
                    policy = spec["policies"][index]
                    if turn <= len(script):
                        action = script[turn - 1]
                    elif policy == "native":
                        action = None
                    elif policy == "rollout":
                        action = self._rollout(state, turn, side)
                    else:
                        action = choose(self.data, state[side], state["enemy" if side == "player" else "player"], policy, spec["seed"] + turn * 17 + index)
                    actions.append(action)
                state = self._step(*actions, turn)
                result["log"].append(state)
                for side in ("player", "enemy"):
                    for member in state[side]["team"]:
                        if member["maxhp"] <= 0 or not 0 <= member["hp"] <= member["maxhp"]:
                            result["failures"].append({"kind": "invariant", "turn": turn, "side": side, "message": "HP outside native bounds", "member": member})
                if self.finished:
                    result["winner"] = self.finished["winner"]
                    result["native_result"] = self.finished["native_result"]
                    result["status"] = "completed"
                    break
            else:
                result["status"] = "turn-limit"
            result["failures"] += evaluate_assertions(result, spec.get("assertions", []))
            if self.h.text_overflows:
                result["failures"].append({"kind": "textbox-overflow", "details": list(self.h.text_overflows)})
        except Exception as error:
            result["status"] = "error"
            result["error"] = f"{type(error).__name__}: {error}"
            try:
                result["control"] = self.h.control_state()
            except Exception:
                pass
        result["turns"] = result["log"][-1]["turn"] if result["log"] else 0
        result["seconds"] = round(time.monotonic() - started, 3)
        result["emulated_frames"] = self.turn_frames
        result["replay_id"] = digest(canonical({"scenario": spec, "metadata": self.metadata}).encode())
        return result
