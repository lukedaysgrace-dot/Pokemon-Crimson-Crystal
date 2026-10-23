"""A UI pause during a running battle must not invalidate result commits."""
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from lab.data import PROJECT, extract
from lab.store import Store, execute


class LivePauseTests(unittest.TestCase):
    def test_another_connection_can_pause_while_battle_is_in_flight(self):
        data = extract()
        build = {"species": "GENGAR", "moves": ["SHADOW_BALL"]}
        (PROJECT / "output").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=PROJECT / "output") as directory:
            worker = Store(Path(directory)/"lab.sqlite")
            ui = Store(Path(directory)/"lab.sqlite")
            try:
                with patch("lab.store.provenance", return_value={"source_sha256": "test", "rom_sha256": "test"}):
                    identity = worker.create(data, {"name": "live pause", "builds": [build, {"species": "MACHAMP", "moves": ["LOW_KICK"]}]})
                    def finish_in_flight(_):
                        ui.pause(identity)
                        return {"status": "completed", "failures": []}
                    with patch("lab.store.RomEngine") as engine:
                        engine.return_value.run.side_effect = finish_in_flight
                        result = execute(worker, identity, data)
                    self.assertTrue(result["paused"])
                    self.assertEqual(result["completed"], 1)
                    self.assertEqual(result["counts"]["pending"], result["total"]-1)
            finally:
                worker.close()
                ui.close()


if __name__ == "__main__":
    unittest.main()
