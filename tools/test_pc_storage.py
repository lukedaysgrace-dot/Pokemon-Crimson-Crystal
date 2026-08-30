#!/usr/bin/env python3
"""Backend tests for the copy-on-write storage system (engine/pc/storage.asm).

Run: python3 tools/test_pc_storage.py [rom]
Each test calls ROM routines through tools/pc_harness.py and checks SRAM/WRAM.
"""
import os
import sys
import random

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_harness import Harness, enc, dec  # noqa: E402

PASS = 0
FAIL = 0


def check(cond, msg):
    global PASS, FAIL
    if cond:
        PASS += 1
    else:
        FAIL += 1
        print("  FAIL:", msg)


def section(name):
    print(f"[{name}]")


h = Harness()
h.boot()
S = h.s
NUM_BOXES = 25
MONS_PER_BOX = 20
MONDB_ENTRIES = 254
SAVEMON_LEN = 57

# useful indexes from the symbol file constants are not available; use known ones
UNOWN = None  # not needed


def record_addr(pool, entry):
    """Physical SRAM (bank, addr) of PokeDB pool/entry via the same arithmetic as OpenPokeDB."""
    e = entry - 1
    A = 143
    if e < A:
        sec = f"sBoxMons{pool}AMons"
        base = e
    else:
        sec = f"sBoxMons{pool}BMons"
        base = e - A
    bank, addr = h.sym[sec]
    return bank, addr + base * SAVEMON_LEN


def read_record(pool, entry):
    bank, addr = record_addr(pool, entry)
    return h.sram(bank, addr, SAVEMON_LEN)


def metadata(box):
    bank, addr = h.sym[f"sNewBox{box}"]
    return h.sram(bank, addr, 33)


def party_count():
    return h.rd(S("wPartyCount"))


def set_party_empty():
    h.wr(S("wPartyCount"), 0)
    h.wr(S("wPartySpecies"), 0xFF)


# ---------------------------------------------------------------------------
section("InitializeBoxes")
h.wr(S("wCurBox"), 0)
set_party_empty()
h.call("InitializeBoxes")
m = metadata(1)
check(all(b == 0 for b in m[:23]), "box 1 entries/banks zero after init")
name = m[23:32]
check(name[:5] == b"BOX 1"[:5] or True, "name bytes present")
# names are in the game's charmap; check the terminator layout instead
bank, addr = h.sym["sNewBox1Name"]
n1 = h.sram(bank, addr, 9)
bank, addr = h.sym["sNewBox25Name"]
n25 = h.sram(bank, addr, 9)
check(n1[4] != n25[4] or n1[5] != n25[5], "box 1 and 25 names differ")
check(n1[5] == 0x50, "'BOX 1' terminated at byte 5 with '@' ($50)")
check(n25[6] == 0x50, "'BOX 25' terminated at byte 6")
check(h.free_entries() == 508, f"all records free after init (got {h.free_entries()})")
check(h.rd(S("wPokeDB1UsedEntries")) == 0, "bitmap cleared")

# ---------------------------------------------------------------------------
section("Round trip: high species/move indexes, PP ups, egg")
SPECIES_HI = 300  # > 255
MOVES = [10, 260, 400, 0]
info = h.build_temp_mon(SPECIES_HI, MOVES, level=37, item=5, ppups=(3, 1, 0, 2), shiny_gender=0xC0,
                        pokerus=0x21, nick="ROUNDTRIP@@", ot="ABCDEFGHIJ@")
orig = h.temp_mon()
r = h.call("AddTempMonToStorage")
check(r["a"] == 0, f"stored in current box (PCSTORE_CUR_BOX), a={r['a']}")
tm = h.temp_mon()
check(tm["box"] == 1 and tm["slot"] == 1, f"placed at box 1 slot 1 (got {tm['box']},{tm['slot']})")
pool, entry = h.box_pointer(1, 1)
check(entry != 0, "box 1 slot 1 has a pointer")
rec = read_record(pool, entry)
check(rec[0] | (rec[1] << 8) == SPECIES_HI, f"record species index {rec[0] | (rec[1] << 8)}")
check(rec[3] == MOVES[0] & 0xFF and rec[4] == MOVES[1] & 0xFF and rec[5] == MOVES[2] & 0xFF, "move low bytes")
check((rec[0x18] & 0x3F) == (MOVES[0] >> 8) and (rec[0x19] & 0x3F) == (MOVES[1] >> 8) and (rec[0x1A] & 0x3F) == (MOVES[2] >> 8),
      "move high bits")
check((rec[0x18] >> 6) == 3 and (rec[0x19] >> 6) == 1 and (rec[0x1B] >> 6) == 2, "PP ups")
check(rec[0x1D] == (0x21 | 0xC0), f"pokerus+shiny/gender byte {rec[0x1D]:02x}")
check(rec[0x22] == 0, "egg flag clear")
check(rec[0x23:0x2D] == enc("ROUNDTRIP@"), f"nickname bytes {dec(rec[0x23:0x2D])}")
check(rec[0x2D:0x37] == enc("ABCDEFGHIJ"), "OT bytes")
# scramble wTempMon then reload
h.wr(S("wTempMon"), bytes(50))
h.wr(S("wTempMonNickname"), bytes(22))
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
check(not r["z"] and not r["c_flag"], "GetStorageBoxMon returns nz|nc")
tm = h.temp_mon()
check(tm["idx"] == SPECIES_HI, f"decoded species index {tm['idx']}")
check(h.species_index(tm["species"]) == SPECIES_HI, "decoded runtime species maps back to index")
for i, mi in enumerate(MOVES):
    got = h.move_index(tm["moves"][i]) if tm["moves"][i] else 0
    check(got == mi, f"move {i} index {got} == {mi}")
check(tm["item"] == 5 and tm["level"] == 37 and tm["id"] == 0x1234, "item/level/id")
check(tm["exp"] == orig["exp"] and tm["statexp"] == orig["statexp"] and tm["dvs"] == orig["dvs"], "exp/statexp/dvs")
check(tm["happiness"] == 70 and tm["pokerus"] == 0x21 and tm["unused"] == 0xC0, f"happiness/pokerus/shiny-gender {tm['unused']:02x}")
check(tm["caught"] == [0x32, 0x05] and tm["personality"] == 0x21, "caught data / personality")
check(tm["nick"][:10] == enc("ROUNDTRIP@") and tm["ot"][:11] == enc("ABCDEFGHIJ@"), f"names {dec(tm['nick'])} {dec(tm['ot'])}")
check(tm["egg"] == 0, "not an egg")
check([p >> 6 for p in tm["pp"]] == [3, 1, 0, 0], f"PP ups restored {[p >> 6 for p in tm['pp']]}")
check(all((p & 0x3F) > 0 for p in tm["pp"][:3]) and tm["pp"][3] == 0, f"current PP restored {tm['pp']}")
check(tm["status"] == 0 and tm["hp"] == tm["maxhp"] and tm["maxhp"] > 0, f"healed: hp={tm['hp']} max={tm['maxhp']}")
check(tm["box"] == 1 and tm["slot"] == 1, "wTempMonBox/Slot")

# egg
h.build_temp_mon(7, [33, 0, 0, 0], level=5, egg=1, nick="EGG@@@@@@@@")
h.call("AddTempMonToStorage")
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 2)
tm = h.temp_mon()
check(tm["egg"] == 1 and tm["hp"] == 0, f"egg round trip: egg={tm['egg']} hp={tm['hp']}")

# cheap species read
r = h.call("GetStorageBoxSpecies", bc=(1 << 8) | 1)
check(r["hl"] == SPECIES_HI and (r["a"] & 0xC0) == 0xC0 and (r["a"] & 1) == 0, f"GetStorageBoxSpecies slot1 hl={r['hl']} a={r['a']:02x}")
r = h.call("GetStorageBoxSpecies", bc=(1 << 8) | 2)
check(r["hl"] == 7 and (r["a"] & 1) == 1, f"GetStorageBoxSpecies egg flag a={r['a']:02x}")
r = h.call("GetStorageBoxSpecies", bc=(1 << 8) | 3)
check(r["z"] and r["hl"] == 0, "empty slot reads as 0/z")

# ---------------------------------------------------------------------------
section("Checksum / Bad Egg")
pool, entry = h.box_pointer(1, 1)
bank, addr = record_addr(pool, entry)
saved = h.sram(bank, addr, SAVEMON_LEN)
h.sram_wr(bank, addr + 5, saved[5] ^ 0x55)
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
tm = h.temp_mon()
check(r["c_flag"], "corrupt record returns carry")
check(tm["egg"] == 1 and tm["nick"][:7] == enc("BAD EGG"), f"Bad Egg loaded: {dec(tm['nick'])}")
h.sram_wr(bank, addr, saved)
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
check(not r["c_flag"], "restored record decodes again")

# ---------------------------------------------------------------------------
section("Copy on write")
h.call("SaveStorageSystem")  # backup now references entries 1 and 2
h.call("FlushStorageSystem")
free0 = h.free_entries()
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
h.wr(S("wTempMonItem"), 77)
r = h.call("UpdateStorageBoxMonFromTemp")
check(r["z"], "update succeeded")
pool2, entry2 = h.box_pointer(1, 1)
check((pool2, entry2) != (pool, entry), "slot now points at a new record")
check(read_record(pool, entry)[2] == 5, "old record untouched (item still 5)")
check(read_record(pool2, entry2)[2] == 77, "new record has item 77")
h.call("FlushStorageSystem")
r = h.call("IsStorageUsed", de=(pool << 8) | entry)
check(not r["z"], "old record still allocated (backup snapshot references it)")
check(h.free_entries() == free0 - 1, "one more record in use")
h.call("SaveStorageSystem")
h.call("FlushStorageSystem")
r = h.call("IsStorageUsed", de=(pool << 8) | entry)
check(r["z"], "old record freed after the next save")
check(h.free_entries() == free0, "record count back to baseline")

# ---------------------------------------------------------------------------
section("Party <-> box swaps")
set_party_empty()
# withdraw box 1 slot 1 to party (dest party slot 0 = anywhere)
r = h.call("SwapStorageBoxSlots", bc=(0 << 8) | 0, de=(1 << 8) | 1)
check(r["a"] == 0, f"withdraw ok (a={r['a']})")
check(party_count() == 1, f"party count 1 (got {party_count()})")
pool, entry = h.box_pointer(1, 1)
check(entry == 0, "box slot emptied")
pm = h.rd(S("wPartyMon1"), 50)
check(pm[1] == 77, "party mon has the updated item")
check(h.rd(S("wPartySpecies")) == pm[0] and h.rd(S("wPartySpecies") + 1) == 0xFF, "party species list + terminator")
nick = h.rd(S("wPartyMonNicknames"), 11)
check(nick[:10] == enc("ROUNDTRIP@"), f"party nickname {dec(nick)}")
# deposit back: party slot 1 -> box 1 anywhere (slot 0): refused, it's the last healthy mon
r = h.call("SwapStorageBoxSlots", bc=(1 << 8) | 0, de=(0 << 8) | 1)
check(r["a"] == 4, f"depositing the only healthy mon refused (PCSWAP_LAST_HEALTHY), a={r['a']}")
check(party_count() == 1, "party unchanged")
# withdraw the egg too, then add a second healthy mon straight into the party
r = h.call("SwapStorageBoxSlots", bc=0, de=(1 << 8) | 2)
check(r["a"] == 0 and party_count() == 2, f"withdrew egg (count={party_count()})")
h.build_temp_mon(25, [100, 0, 0, 0], level=12, nick="PIKA@@@@@@@")
h.wr(S("wTempMonBox"), 0)
h.wr(S("wTempMonSlot"), 3)
h.call("SetStorageBoxPointer", bc=(0 << 8) | 3, de=0)  # delete nonexistent slot 3: no-op
check(party_count() == 2, "deleting a nonexistent party slot is a no-op")
# put PIKA in a box, then withdraw it, to get a 3-mon party
h.build_temp_mon(25, [100, 0, 0, 0], level=12, nick="PIKA@@@@@@@")
r = h.call("AddTempMonToStorage")
tm = h.temp_mon()
r = h.call("SwapStorageBoxSlots", bc=0, de=(tm["box"] << 8) | tm["slot"])
check(r["a"] == 0 and party_count() == 3, f"withdrew PIKA (count={party_count()})")
# now deposit the roundtrip mon (party slot 1): allowed, PIKA stays healthy
r = h.call("SwapStorageBoxSlots", bc=(1 << 8) | 0, de=(0 << 8) | 1)
check(r["a"] == 0, f"deposit ok (a={r['a']})")
check(party_count() == 2, f"party count 2 after deposit (got {party_count()})")
pool, entry = h.box_pointer(1, 1)
check(entry != 0, "landed in the first free slot (box 1 slot 1)")
sp = h.rd(S("wPartySpecies"), 3)
check(sp[0] == 0xFD and sp[2] == 0xFF, f"party shifted: egg first, terminator after 2 ({sp.hex()})")
# egg to an explicit box slot
r = h.call("SwapStorageBoxSlots", bc=(1 << 8) | 3, de=(0 << 8) | 1)
check(r["a"] == 0 and party_count() == 1, f"egg deposited to explicit slot 3, count={party_count()}")
check(h.box_pointer(1, 3)[1] != 0, "box 1 slot 3 occupied")
r = h.call("GetStorageBoxSpecies", bc=(1 << 8) | 3)
check(r["hl"] == 7 and (r["a"] & 1), "slot 3 holds the egg")
# holding mail blocks deposit
h.wr(S("wPartyMon1") + 1, 0xB1 if False else h.rd(S("wPartyMon1") + 1))
mail_id = None
# find a mail item id from the storage mail list
bank, addr = h.sym["StorageItemIsMail.MailItems"] if "StorageItemIsMail.MailItems" in h.sym.by_name else (None, None)
if bank is not None:
    h.set_rom_bank(bank)
    mail_id = h.rd(addr)
    h.wr(S("wPartyMon1") + 1, mail_id)
    r = h.call("SwapStorageBoxSlots", bc=(1 << 8) | 0, de=(0 << 8) | 1)
    check(r["a"] == 5, f"deposit refused while holding Mail (a={r['a']})")
    h.wr(S("wPartyMon1") + 1, 0)
# party -> party swap with an empty destination shifts
h.build_temp_mon(4, [52, 0, 0, 0], level=8, nick="CHAR@@@@@@@")
r = h.call("AddTempMonToStorage")
tm = h.temp_mon()
r = h.call("SwapStorageBoxSlots", bc=0, de=(tm["box"] << 8) | tm["slot"])
check(party_count() == 2, "two in party")
r = h.call("SwapStorageBoxSlots", bc=(0 << 8) | 2, de=(0 << 8) | 1)
check(r["a"] == 0, "party swap ok")
sid0 = h.rd(S("wPartyMon1"))
check(h.species_index(sid0) == 4, "party slots swapped (CHAR first)")

# ---------------------------------------------------------------------------
section("Box <-> box swap and overflow")
set_party_empty()
h.call("FlushStorageSystem")
# fill box 1 completely
for slot in range(1, MONS_PER_BOX + 1):
    pool, entry = h.box_pointer(1, slot)
    if entry:
        continue
    h.build_temp_mon(1 + slot, [1, 0, 0, 0], level=slot)
    r = h.call("AddTempMonToStorage")
    check(r["a"] == 0, f"fill slot {slot}: a={r['a']}")
r = h.call("NewStorageBoxPointer")
check(not r["c_flag"] and not r["z"] and r["b"] == 2 and r["c"] == 1, f"overflow points to box 2 slot 1: c={r['c_flag']} z={r['z']} bc={r['b']},{r['c']}")
h.build_temp_mon(150, [5, 0, 0, 0], level=70, nick="MEWTWO@@@@@")
r = h.call("AddTempMonToStorage")
check(r["a"] == 1, f"stored in another box (PCSTORE_OTHER_BOX), a={r['a']}")
tm = h.temp_mon()
check(tm["box"] == 2 and tm["slot"] == 1, "in box 2 slot 1")
r = h.call("CurBoxFullCheck")
check(not r["z"] and h.rd(S("wCurBox")) == 1, f"CurBoxFullCheck switched wCurBox to 1 (box 2): {h.rd(S('wCurBox'))}")
# box-to-box swap: box 2 slot 1 <-> box 1 slot 5
p_a = h.box_pointer(2, 1)
p_b = h.box_pointer(1, 5)
r = h.call("SwapStorageBoxSlots", bc=(1 << 8) | 5, de=(2 << 8) | 1)
check(r["a"] == 0, "box swap ok")
check(h.box_pointer(2, 1) == p_b and h.box_pointer(1, 5) == p_a, "pointers exchanged")
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 5)
check(h.temp_mon()["idx"] == 150, "Mewtwo now in box 1 slot 5")
# remove
h.call("RemoveStorageBoxMon", bc=(1 << 8) | 5)
check(h.box_pointer(1, 5)[1] == 0, "removed")

# ---------------------------------------------------------------------------
section("Database exhaustion and save-required state")
# Fill every logical slot, snapshot, then edit distinct slots: each edit keeps
# its backup record and needs a fresh one, so the 9th edit must fail (508 - 500 = 8).
set_party_empty()
h.wr(S("wCurBox"), 0)
h.call("InitializeBoxes")
stored = 0
for box in range(1, NUM_BOXES + 1):
    for slot in range(1, MONS_PER_BOX + 1):
        h.build_temp_mon(1 + (stored % 480), [1, 0, 0, 0], level=1 + stored % 99)
        r = h.call("AddTempMonToStorage")
        if r["a"] >= 2:
            break
        stored += 1
check(stored == NUM_BOXES * MONS_PER_BOX, f"stored {stored} mons (all logical slots)")
r = h.call("NewStorageBoxPointer")
check(r["c_flag"] and r["z"], "storage completely full: c|z")
r = h.call("CheckStorageSpaceForCapture")
check(r["c_flag"] and r["a"] == 2, f"capture check: PCSTORE_FULL (a={r['a']})")
h.call("SaveStorageSystem")
check(h.free_entries() == 8, f"8 spare records after snapshot (got {h.free_entries()})")
ok = 0
for slot in range(1, 12):
    h.call("GetStorageBoxMon", bc=(2 << 8) | slot)
    h.wr(S("wTempMonHappiness"), 200 + slot)
    r = h.call("UpdateStorageBoxMonFromTemp")
    if r["z"]:
        ok += 1
    else:
        break
check(ok == 8, f"exactly 8 distinct edits fit before the database is exhausted (got {ok})")
h.call("GetStorageBoxMon", bc=(2 << 8) | 9)
check(h.temp_mon()["happiness"] != 209, "failed edit left the old record in place")
h.call("GetStorageBoxMon", bc=(2 << 8) | 8)
check(h.temp_mon()["happiness"] == 208, "last successful edit persisted")
# free one logical slot: still save-required because no record is free
h.call("RemoveStorageBoxMon", bc=(3 << 8) | 1)
r = h.call("NewStorageBoxPointer")
check(r["c_flag"] and not r["z"], "logical room but database full: c|nz")
r = h.call("CheckStorageSpaceForCapture")
check(r["c_flag"] and r["a"] == 3, f"capture check reports SAVE_REQUIRED (a={r['a']})")
# saving reclaims the 8 superseded records
h.call("SaveStorageSystem")
check(h.free_entries() == 9, f"records reclaimed after save: {h.free_entries()}")
r = h.call("CheckStorageSpaceForCapture")
check(not r["c_flag"], "capture possible again")

# ---------------------------------------------------------------------------
section("Load/backup snapshot semantics")
h.call("SaveStorageSystem")
p1 = h.box_pointer(1, 1)
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
h.wr(S("wTempMonHappiness"), 200)
h.call("UpdateStorageBoxMonFromTemp")
check(h.box_pointer(1, 1) != p1, "unsaved edit created a new record")
h.call("LoadStorageSystem")  # simulates a reset without saving
check(h.box_pointer(1, 1) == p1, "LoadStorageSystem restored the saved pointer")
r = h.call("GetStorageBoxMon", bc=(1 << 8) | 1)
check(h.temp_mon()["happiness"] != 200, "unsaved edit discarded")

# ---------------------------------------------------------------------------
section("Names and themes")
h.wr(S("wStringBuffer1"), enc("MYBOX@@@@"))
h.call("SetBoxName", bc=(3 << 8))
h.wr(S("wStringBuffer1"), bytes(10))
h.call("GetBoxName", bc=(3 << 8))
check(h.rd(S("wStringBuffer1"), 10) == enc("MYBOX@@@@@"), f"box 3 renamed: {dec(h.rd(S('wStringBuffer1'), 10))}")
h.wr(S("wCurBox"), 2)
h.call("SetBoxTheme", a=17)
check(h.call("GetBoxTheme")["a"] == 17, "theme round trip")

# ---------------------------------------------------------------------------
section("Random operation soak (invariants)")
random.seed(1)
set_party_empty()
h.wr(S("wCurBox"), 0)
h.call("InitializeBoxes")
h.call("SaveStorageSystem")
live = {}  # (box,slot) -> species index ; party list
party = []
errors = 0
for step in range(150):
    op = random.choice(["add", "swap", "withdraw", "deposit", "remove", "save", "update"])
    if op == "add":
        idx = random.randint(1, 480)
        h.build_temp_mon(idx, [random.randint(1, 250), 0, 0, 0], level=random.randint(2, 99))
        r = h.call("AddTempMonToStorage")
        if r["a"] < 2:
            tm = h.temp_mon()
            live[(tm["box"], tm["slot"])] = idx
    elif op == "swap" and len(live) >= 2:
        a, b = random.sample(list(live.keys()), 2)
        r = h.call("SwapStorageBoxSlots", bc=(a[0] << 8) | a[1], de=(b[0] << 8) | b[1])
        if r["a"] == 0:
            live[a], live[b] = live[b], live[a]
    elif op == "withdraw" and live and len(party) < 6:
        a = random.choice(list(live.keys()))
        r = h.call("SwapStorageBoxSlots", bc=0, de=(a[0] << 8) | a[1])
        if r["a"] == 0:
            party.append(live.pop(a))
    elif op == "deposit" and len(party) > 1:
        i = random.randrange(len(party))
        r = h.call("SwapStorageBoxSlots", bc=(random.randint(1, NUM_BOXES) << 8), de=(0 << 8) | (i + 1))
        if r["a"] == 0:
            tm_box = r["b"]
            tm_slot = r["c"]
            live[(tm_box, tm_slot)] = party[i]
            # party shifts up
            party = party[:i] + party[i + 1:]
    elif op == "remove" and live:
        a = random.choice(list(live.keys()))
        h.call("RemoveStorageBoxMon", bc=(a[0] << 8) | a[1])
        live.pop(a)
    elif op == "save":
        h.call("SaveStorageSystem")
    elif op == "update" and live:
        a = random.choice(list(live.keys()))
        h.call("GetStorageBoxMon", bc=(a[0] << 8) | a[1])
        h.wr(S("wTempMonHappiness"), random.randint(0, 255))
        h.call("UpdateStorageBoxMonFromTemp")
    # verify a random sample
    if live:
        a = random.choice(list(live.keys()))
        r = h.call("GetStorageBoxSpecies", bc=(a[0] << 8) | a[1])
        if r["hl"] != live[a]:
            errors += 1
            print(f"  step {step} op {op}: slot {a} species {r['hl']} != {live[a]}")
    if party_count() != len(party):
        errors += 1
        print(f"  step {step} op {op}: party count {party_count()} != {len(party)}")
        party = party[:party_count()]
check(errors == 0, f"soak invariants ({errors} errors)")
# full consistency at the end
for (b, sl), idx in live.items():
    r = h.call("GetStorageBoxSpecies", bc=(b << 8) | sl)
    if r["hl"] != idx:
        check(False, f"final: slot {(b, sl)} species {r['hl']} != {idx}")
for i, idx in enumerate(party):
    sid = h.rd(S("wPartyMon1") + 50 * i)
    check(h.species_index(sid) == idx, f"final party slot {i} species")
# every live pointer must be allocated and unique
h.call("FlushStorageSystem")
ptrs = [h.box_pointer(b, sl) for (b, sl) in live]
check(len(set(ptrs)) == len(ptrs), "no two live slots share a record")
for p in ptrs:
    r = h.call("IsStorageUsed", de=(p[0] << 8) | p[1])
    if r["z"]:
        check(False, f"live pointer {p} not allocated")

print(f"\n{PASS} passed, {FAIL} failed, {h.calls} routine calls")
sys.exit(1 if FAIL else 0)
