import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE / "pydeps_local"))
sys.path.insert(0, str(ROOT / "tools" / "battletest"))
from pyboy import PyBoy as RealPyBoy
import runner
from state import Request

runner.PyBoy = lambda _f, **kw: RealPyBoy(str(HERE / "fresh_debug_mbc5.gbc"), **kw)
h = runner.Harness(verbose=False)
h.ensure_fixture()

species = ["TOTODILE", "MAREEP", "BELLSPROUT", "GASTLY", "GEODUDE", "ZUBAT"]
templates = []
struct_len = h.sym.addr("wPartyMon2") - h.sym.addr("wPartyMon1")
name_len = (h.sym.addr("wPartyMonNicknamesEnd") - h.sym.addr("wPartyMonNicknames")) // 6

for i in range(0, len(species), 2):
    h.load_fixture()
    test = {
        "player": {"species": species[i], "level": 5},
        "player2": {"species": species[i + 1], "level": 5},
        "enemy": {"species": "RATTATA", "level": 2},
        "turns": 0,
        "rng": "seeded",
    }
    st = h.run_battle(test)
    if st != runner.STATE_WAIT:
        raise RuntimeError((species[i:i+2], st))
    m = h.battle.mem
    for slot in range(2):
        templates.append({
            "species": species[i + slot],
            "struct": m.read_bytes("wPartyMon1", struct_len, slot * struct_len).hex(),
            "ot": m.read_bytes("wPartyMonOT", name_len, slot * name_len).hex(),
            "nickname": m.read_bytes("wPartyMonNicknames", name_len, slot * name_len).hex(),
        })

out = {"struct_len": struct_len, "name_len": name_len, "mons": templates}
(HERE / "party_templates.json").write_text(json.dumps(out, indent=2))
print(json.dumps({"struct_len": struct_len, "name_len": name_len, "species": species}))
h.pb.stop(save=False)
