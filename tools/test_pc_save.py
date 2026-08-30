#!/usr/bin/env python3
"""Save/load/recovery tests for the storage snapshot integration (engine/menus/save.asm)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_harness import Harness, enc  # noqa: E402

PASS = FAIL = 0
SAVE_FORMAT_VERSION = 2


def check(cond, msg):
    global PASS, FAIL
    if cond:
        PASS += 1
    else:
        FAIL += 1
        print("  FAIL:", msg)


h = Harness()
h.boot()
S = h.s


def sram_sym(name, n=1):
    return h.sym_sram(name, n)


def set_sram_sym(name, data):
    bank, addr = h.sym[name]
    h.sram_wr(bank, addr, data)


def active_metadata():
    bank, addr = h.sym["sNewBox1"]
    end = h.sym["sNewBoxEnd"][1]
    return h.sram(bank, addr, end - addr)


def backup_metadata():
    bank, addr = h.sym["sBackupNewBox1"]
    end = h.sym["sBackupNewBoxEnd"][1]
    return h.sram(bank, addr, end - addr)


print("[new game state]")
h.wr(S("wPartyCount"), 0)
h.wr(S("wPartySpecies"), 0xFF)
h.wr(S("wCurBox"), 0)
h.wr(S("wPlayerID"), [0x12, 0x34])
h.wr(S("wPlayerName"), enc("LUKE@@@@"))
h.call("InitializeBoxes")
h.call("ClearBackupBoxes")
for i in range(3):
    h.build_temp_mon(10 + i, [1, 0, 0, 0], level=5 + i)
    h.call("AddTempMonToStorage")
h.wr(S("wSavedAtLeastOnce"), 1)

print("[SaveGameData writes both copies and the snapshot]")
h.call("SaveGameData", max_frames=600)
check(
    sram_sym("sSaveVersion") == SAVE_FORMAT_VERSION,
    f"save version byte = {SAVE_FORMAT_VERSION} (got {sram_sym('sSaveVersion')})",
)
check(sram_sym("sWritingBackup") == 0, "save phase cleared after a complete save")
check(sram_sym("sCheckValue1") == 0x63 and sram_sym("sBackupCheckValue1") == 0x63, "check values written")
check(active_metadata() == backup_metadata(), "backup snapshot equals active metadata")
r = h.call("CheckPrimarySaveFile", max_frames=60)
check(h.rd(S("wSaveFileExists")) == 1, "CheckPrimarySaveFile accepts the save")

print("[version gate rejects other layouts]")
set_sram_sym("sSaveVersion", 0)
h.wr(S("wSaveFileExists"), 0)
h.call("CheckPrimarySaveFile", max_frames=60)
check(h.rd(S("wSaveFileExists")) == 0, "old/unknown version is rejected")
h.wr(S("wSaveFileExists"), 0)
h.call("CheckBackupSaveFile", max_frames=60)
check(h.rd(S("wSaveFileExists")) == 0, "backup also rejected on version mismatch")
set_sram_sym("sSaveVersion", SAVE_FORMAT_VERSION)

print("[unsaved edits are discarded on load]")
h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
p_before = h.box_pointer(1, 1)
h.wr(S("wTempMonHappiness"), 123)
h.call("UpdateStorageBoxMonFromTemp")
check(h.box_pointer(1, 1) != p_before, "edit produced a new record")
r = h.call("TryLoadSaveFile", max_frames=600)
check(not r["c_flag"], "TryLoadSaveFile succeeded")
check(h.box_pointer(1, 1) == p_before, "pointer restored from the snapshot")
h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
check(h.temp_mon()["happiness"] != 123, "edit discarded")

print("[reset during backup write is repaired]")
# Simulate: main copy valid, active metadata newer than backup, phase = 1.
h.call("GetStorageBoxMon", bc=(1 << 8) | 2)
h.wr(S("wTempMonHappiness"), 77)
h.call("UpdateStorageBoxMonFromTemp")
new_ptr = h.box_pointer(1, 2)
set_sram_sym("sWritingBackup", 1)
# corrupt the backup checksum to prove WriteBackupSave reruns
set_sram_sym("sBackupChecksum", [0, 0])
r = h.call("TryLoadSaveFile", max_frames=600)
check(not r["c_flag"], "load ok")
check(sram_sym("sWritingBackup") == 0, "phase cleared by the finished backup write")
check(h.box_pointer(1, 2) == new_ptr, "the active metadata was committed to the snapshot (edit kept)")
check(active_metadata() == backup_metadata(), "snapshots equal after repair")
r = h.call("VerifyBackupChecksum", max_frames=60)
check(r["z"], "backup checksum valid again")

print("[corrupt main, valid backup]")
set_sram_sym("sChecksum", [0xFF, 0xFF])
h.call("GetStorageBoxMon", bc=(1 << 8) | 3)
h.wr(S("wTempMonHappiness"), 99)
h.call("UpdateStorageBoxMonFromTemp")  # unsaved active edit that must be dropped
r = h.call("TryLoadSaveFile", max_frames=600)
check(not r["c_flag"], "loaded from backup")
r = h.call("VerifyChecksum", max_frames=60)
check(r["z"], "main copy repaired")
h.call("GetStorageBoxMon", bc=(1 << 8) | 3)
check(h.temp_mon()["happiness"] != 99, "active edit not resurrected")
check(active_metadata() == backup_metadata(), "snapshots equal")

print("[records referenced by the snapshot survive a new game that isn't saved]")
saved_active = active_metadata()
h.call("InitializeBoxes")  # new game: active cleared, backup untouched
check(backup_metadata() == saved_active, "backup snapshot untouched by InitializeBoxes")
h.call("FlushStorageSystem")
for slot in range(1, 4):
    # entries referenced only by the backup must still be allocated
    b = saved_active[slot - 1]
    pool = 2 if (saved_active[20 + (slot - 1) // 8] >> ((slot - 1) % 8)) & 1 else 1
    r = h.call("IsStorageUsed", de=(pool << 8) | b)
    check(not r["z"], f"backup-only record {pool}:{b} still allocated")
r = h.call("TryLoadSaveFile", max_frames=600)
check(active_metadata() == saved_active, "abandoning the new game restores the old boxes")

print(f"\n{PASS} passed, {FAIL} failed")
sys.exit(1 if FAIL else 0)
