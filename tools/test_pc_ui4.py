#!/usr/bin/env python3
"""Bill's PC UI: a full database forces a save before an edit can proceed."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

# Fill every box (500 mons; slot 1 of box 1 holds an item), withdraw two into
# the party, save, then burn the 8 spare records with edits.
h.wr(S("wPartyCount"), 0)
h.wr(S("wPartySpecies"), 0xFF)
h.wr(S("wCurBox"), 0)
h.wr(S("wPlayerID"), [0x12, 0x34])
h.wr(S("wPlayerName"), enc("LUKE@@@@"))
h.wr(S("wPlayerGender"), 0)
h.wr(S("wOptions"), 0)
h.wr(S("wNumItems"), 0)
h.wr(S("wNumItems") + 1, 0xFF)
h.call("InitializeBoxes")
h.call("ClearBackupBoxes")
for i in range(500):
    h.build_temp_mon(species_index=1 + (i % 250), moves_index=[1, 0, 0, 0], level=10,
                     item=0x53 if i == 0 else 0, nick="TESTMON@@@@")
    r = h.call("AddTempMonToStorage")
    if r["a"] >= 2:
        check(False, f"could not store mon {i}: a={r['a']}")
        break
h.wr(S("wCurBox"), 0)
for slot in (19, 20):
    r = h.call("SwapStorageBoxSlots", bc=0, de=(1 << 8) | slot)
    check(r["a"] == 0, f"withdraw slot {slot} (got {r['a']})")
h.wr(S("wSavedAtLeastOnce"), 1)
h.call("SaveGameData", max_frames=900)
free = h.free_entries()
check(free == 10, f"10 free records after the save (got {free})")
for slot in range(2, 12):
    h.call("GetStorageBoxMon", bc=(1 << 8) | slot)
    h.wr(S("wTempMonHappiness"), 200)
    r = h.call("UpdateStorageBoxMonFromTemp")
    check(r["z"], f"edit {slot} ok")
free = h.free_entries()
check(free == 0, f"database exhausted (free {free})")

print("[open]")
enter()
frames(180, "open")

print("[item mode: picking Charizard's item needs a record -> save prompt]")
press("select"); press("select", wait=20)
press("a", wait=80, label="save_prompt")
check(h.rd(S("wBillsPC_CursorHeldBox")) == 0, "nothing picked up yet")
press("a", wait=600, label="saved")            # YES -> ForceGameSave ("Saving…" / "saved the game")
check(h.sym_sram("sWritingBackup") == 0, "save completed")
check(h.sym_sram("sSaveVersion") == 2, "save file valid")
check(h.rd(S("wBillsPC_CursorHeldBox")) & 0x80, "item picked up after the save")
press("b", wait=80, label="put_back")
check(h.rd(S("wBillsPC_CursorHeldBox")) == 0, "item put back")

print("[exit]")
press("select", wait=20)
press("b", wait=40, label="exit_prompt")
press("down", wait=10)
press("a", wait=40)
for _ in range(20):
    if frames(10):
        break
check(h.rd(MARKER) == 1, "UseBillsPC returned")
finish()
