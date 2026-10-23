"""Isolated native-ROM reproduction for the audit's depleted-player-PP bug.

Loads a private candidate transport without changing the running audit's pinned
laboratory. The candidate delegates Struggle ID allocation and execution to ROM.
"""
import hashlib
import json
from pathlib import Path
import types

from lab.data import PROJECT, extract
from lab.engine import RomEngine


def candidate_module():
    archive = PROJECT / "output/roster-2026-10-23/engine-pre-pp-fix.py"
    source = (archive if archive.exists() else PROJECT / "lab/engine.py").read_text()
    original_source = source
    replacements = [
        ('("PlayerSwitch", self._switch)):', '("PlayerSwitch", self._switch),\n                                 ("DebugChoosePlayerMove.move_ok", self._player_choice)):'),
        ('    def _enemy_choice(self, _):', '''    def _player_choice(self, _):
        if self._struggle_id is not None and not any(self.mem.read("wBattleMonPP", i) & 63 for i in range(4)):
            self.pb.register_file.B = self._struggle_id

    def _enemy_choice(self, _):'''),
        ('        self.selected_enemy = None\n', '        self.selected_enemy = None\n        self._struggle_id = None\n'),
        ('                raise RuntimeError(f"native party construction failed: {symbol}, PC={r.PC:04x}")\n        finally:',
         '                raise RuntimeError(f"native party construction failed: {symbol}, PC={r.PC:04x}")\n            return {k: getattr(r, k) for k in saved}\n        finally:'),
        ('    def _step(self, action, enemy_action, turn):\n        self.events = []', '''    def _step(self, action, enemy_action, turn):
        self._struggle_id = None
        if not isinstance(action, str) and not any(self.mem.read("wBattleMonPP", i) & 63 for i in range(4)):
            self._struggle_id = self._call_native("GetMoveIDFromIndex", HL=self.h.con.moves["STRUGGLE"])["A"]
        self.events = []''')]
    for before, after in replacements:
        if source.count(before) != 1:
            raise ValueError(f"candidate patch anchor changed: {before[:80]}")
        source = source.replace(before, after)
    module = types.ModuleType("lab.engine_pp_candidate")
    module.__package__ = "lab"
    module.__file__ = str(PROJECT / "lab/engine.py")
    exec(compile(source, "engine_pp_candidate", "exec"), module.__dict__)
    module.patch_sha256 = hashlib.sha256(source.encode()).hexdigest()
    module.patched_source = source
    original = types.ModuleType("lab.engine_pp_original")
    original.__package__, original.__file__ = "lab", str(PROJECT / "lab/engine.py")
    exec(compile(original_source, "engine_pp_original", "exec"), original.__dict__)
    module.original_engine = original.RomEngine
    return module


def main():
    data = extract()
    patched = candidate_module()
    output = {}
    for label, engine_class in (("original", patched.original_engine), ("candidate", patched.RomEngine)):
        engine = engine_class(data)
        original_stage = engine._stage_teams
        def stage_empty():
            original_stage()
            engine.mem.write_bytes("wBattleMonPP", [0]*4)
            engine.mem.write_bytes("wPartyMon1PP", [0]*4)
        engine._stage_teams = stage_empty
        try:
            result = engine.run({"name": "Player four-move exhaustion", "player": {"species": "MEW", "moves": ["POUND", "CONFUSION", "SWIFT", "FLAMETHROWER"]},
                                 "enemy": {"species": "BLISSEY", "moves": ["DEFENSE_CURL"]}, "max_turns": 2, "seed": 1234})
            output[label] = result
            actual = [e["move"] for s in result["log"] for e in s.get("actions", []) if e["side"] == "player"]
            print(label, result["status"], actual, result.get("error"), flush=True)
            if label == "candidate":
                assert "STRUGGLE" in actual and not result["failures"] and result["status"] != "error"
            else:
                assert "STRUGGLE" not in actual, "the historical defect must reproduce"
        finally:
            engine.close()
    engine = patched.RomEngine(data)
    try:
        spec = json.loads((PROJECT / "output/tier-turn-limits.json").read_text())[0]["spec"]
        spec["max_turns"] = 200
        output["observed_matchup"] = engine.run(spec)
        r = output["observed_matchup"]
        print("observed_matchup", r["status"], r["winner"], r["turns"], r.get("error"), flush=True)
        assert any(e["move"] == "STRUGGLE" and e["side"] == "player" for s in r["log"] for e in s.get("actions", []))
        assert r["status"] != "error" and not r["failures"]
    finally:
        engine.close()
    output["candidate_sha256"] = patched.patch_sha256
    (PROJECT / "output/pp-transport-probe.json").write_text(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
