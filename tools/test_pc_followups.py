#!/usr/bin/env python3
"""Follow-up checks for the storage audit: Bill's phone box-space variable,
boxed gifts needing two database records, Eggs coming out of the PC, and the
Day-Care under the Hard Mode level cap.

Run: python3 tools/test_pc_followups.py [rom]
Uses tools/pc_harness.py (private emulator state; no save file is touched).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_harness import Harness, enc  # noqa: E402

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
MONS_PER_BOX = 20
PARTYMON_LEN = 48
HARD_MODE_BIT = 3  # STATUSFLAGS2_HARD_MODE_F


def set_party_empty():
    h.wr(S("wPartyCount"), 0)
    h.wr(S("wPartySpecies"), 0xFF)


def exp_at_level(species_id, level):
    h.wr(S("wCurSpecies"), species_id)
    h.call("GetBaseData")
    h.call("CalcExpAtLevel", de=level << 8)
    p = h.rd(S("hProduct") + 1, 3)
    return (p[0] << 16) | (p[1] << 8) | p[2]


def box_free_var():
    """What VAR_BOXSPACE hands to scripts."""
    r = h.call("CheckStorageSpaceForCapture")
    if r["c_flag"]:
        return 0
    return h.call("CountFreeSlotsInReceivingBox")["a"]


# ---------------------------------------------------------------------------
section("VAR_BOXSPACE counts the receiving box's free slots")
h.wr(S("wCurBox"), 0)
set_party_empty()
h.call("InitializeBoxes")
check(box_free_var() == MONS_PER_BOX, f"empty box: {MONS_PER_BOX} free (got {box_free_var()})")
for i in range(3):
    h.build_temp_mon(1 + i, [33, 0, 0, 0], level=5)
    h.call("AddTempMonToStorage")
check(box_free_var() == MONS_PER_BOX - 3, f"three stored: 17 free (got {box_free_var()})")
for i in range(MONS_PER_BOX - 4):
    h.build_temp_mon(10 + i, [33, 0, 0, 0], level=5)
    h.call("AddTempMonToStorage")
check(box_free_var() == 1, f"nineteen stored: 1 free (got {box_free_var()})")
h.build_temp_mon(40, [33, 0, 0, 0], level=5)
h.call("AddTempMonToStorage")
check(box_free_var() == MONS_PER_BOX, f"current box full: reports the next box, 20 free (got {box_free_var()})")
r = h.call("CountFreeSlotsInReceivingBox")
check(h.rd(S("wCurBox")) == 0, "counting does not switch the current box")

# ---------------------------------------------------------------------------
section("Catch with a full party: stored, edited and rolled into the next box")
h.wr(S("wCurBox"), 0)
h.call("InitializeBoxes")
for i in range(MONS_PER_BOX):
    h.build_temp_mon(1 + i, [33, 0, 0, 0], level=5)
    h.call("AddTempMonToStorage")
CAUGHT_INDEX = 300
caught_sid = h.species_id(CAUGHT_INDEX)
h.wr(S("wPlayerID"), [0xBE, 0xEF])
h.wr(S("wPlayerName"), enc("LUKE@@@@@@@"))
h.wr(S("wEnemyMon"), bytes(48))
h.wr(S("wEnemyMonSpecies"), caught_sid)
h.wr(S("wEnemyMonMoves"), [h.move_id(33), h.move_id(260), 0, 0])
h.wr(S("wEnemyMonDVs"), [0x12, 0x34])
h.wr(S("wEnemyMonPersonality"), 0x20)
h.wr(S("wEnemyMonHiddenPowerType"), 9)
h.wr(S("wEnemyMonShinyGenderFlags"), 0x80)
h.wr(S("wCurPartySpecies"), caught_sid)
h.wr(S("wCurPartyLevel"), 23)
r = h.call("CheckStorageSpaceForCapture")
check(not r["c_flag"], "capture allowed: another box has room")
r = h.call("SendMonIntoBox", max_frames=600)
check(r["c_flag"] and r["a"] == 1, f"stored in another box (carry, PCSTORE_OTHER_BOX): c={r['c_flag']} a={r['a']}")
check(h.rd(S("wTempMonBox")) == 2 and h.rd(S("wTempMonSlot")) == 1, "went to box 2 slot 1")
h.call("SetBoxMonCaughtData")
h.wr(S("wCurItem"), 2)  # ULTRA_BALL (CAUGHTBALL index 2)
h.call("SetCaughtBall", bc=S("wTempMonPersonality"))
h.wr(S("wTempMonNickname"), enc("CATCH@@@@@@"))
old_ptr = h.box_pointer(2, 1)
r = h.call("UpdateStorageBoxMonFromTemp")
check(r["z"], "caught data and nickname committed")
check(h.box_pointer(2, 1) != old_ptr and h.box_pointer(2, 1)[1] != 0, "commit wrote a fresh record (copy on write)")
r = h.call("NewStorageBoxPointer")
check(not r["c_flag"], "storage not reported full")
r = h.call("CurBoxFullCheck")
check(not r["z"] and h.rd(S("wCurBox")) == 1, f"current box switched to box 2 ({h.rd(S('wCurBox'))})")
check(h.rd(S("wStringBuffer1"), 6) == enc("BOX 1@"), "old box name ready for the '<BOX> is full.' text")
h.wr(S("wTempMon"), bytes(50))
r = h.call("GetStorageBoxMon", bc=0x0201)
tm = h.temp_mon()
check(not r["z"] and not r["c_flag"], "stored catch decodes cleanly")
check(tm["idx"] == CAUGHT_INDEX and tm["level"] == 23, f"species/level kept ({tm['idx']}, {tm['level']})")
check(tm["nick"][:6] == enc("CATCH@") and tm["ot"][:5] == enc("LUKE@"), "nickname and OT kept")
check(tm["id"] == 0xEFBE, f"OT ID kept ({tm['id']:04x})")
check(tm["unused"] == 0x80 and tm["hidden_power"] == 9, "shiny/gender flags and Hidden Power type kept")
check(tm["personality"] & 0x1F == 2 and tm["personality"] & 0xE0 == 0x20, f"ball and ability bits kept ({tm['personality']:02x})")
check(tm["caught"][0] & 0x3F == 23, f"caught level recorded ({tm['caught'][0] & 0x3F})")
exp = (tm["exp"][0] << 16) | (tm["exp"][1] << 8) | tm["exp"][2]
check(exp == exp_at_level(caught_sid, 23), "EXP matches the caught level")
check(tm["hp"] == tm["maxhp"] and tm["maxhp"] > 0, "stored catch is healthy")
check(box_free_var() == MONS_PER_BOX - 1, f"Bill's count follows the new current box (got {box_free_var()})")

# ---------------------------------------------------------------------------
section("Egg withdrawn from the PC has 0 HP and can't count as a fighter")
h.wr(S("wCurBox"), 1)
h.build_temp_mon(7, [33, 0, 0, 0], level=5, egg=1, nick="EGG@@@@@@@@")
h.call("AddTempMonToStorage")
egg_box, egg_slot = h.rd(S("wTempMonBox")), h.rd(S("wTempMonSlot"))
# party: one fainted mon
h.build_temp_mon(4, [33, 0, 0, 0], level=12)
set_party_empty()
h.wr(S("wPartyCount"), 1)
h.wr(S("wPartySpecies"), [h.rd(S("wTempMon")), 0xFF])
h.wr(S("wPartyMon1"), h.rd(S("wTempMon"), PARTYMON_LEN))
h.wr(S("wPartyMon1HP"), [0, 0])
# withdraw the egg into the party
r = h.call("SwapStorageBoxSlots", bc=0x0000, de=(egg_box << 8) | egg_slot)
check(r["a"] == 0, f"withdraw succeeded (a={r['a']})")
check(h.rd(S("wPartyCount")) == 2, "party has two members")
check(h.rd(S("wPartySpecies") + 1) == 0xFD, f"second party species is EGG ({h.rd(S('wPartySpecies') + 1):02x})")
hp = h.rd(S("wPartyMon2HP"), 2)
check(hp == b"\x00\x00", f"withdrawn Egg has 0 HP (got {hp.hex()})")
r = h.call("CheckPlayerPartyForFitMon")
check(r["d"] == 0, "a fainted mon plus a PC Egg is not a usable party")

# ---------------------------------------------------------------------------
section("Day-Care under the Hard Mode level cap")
flags = h.rd(S("wStatusFlags2"))
h.wr(S("wStatusFlags2"), flags | (1 << HARD_MODE_BIT))
h.wr(S("wBadges"), [0, 0])  # no badges: cap 10
sid = h.species_id(1)  # Bulbasaur
set_party_empty()
cap_exp = exp_at_level(sid, 10)
big_exp = exp_at_level(sid, 30)


def put_breedmon1(level, exp):
    d = bytearray(32)
    d[0] = sid
    d[2] = h.move_id(33)
    d[8:11] = [(exp >> 16) & 0xFF, (exp >> 8) & 0xFF, exp & 0xFF]
    d[21:23] = [0xFF, 0xFF]
    d[27] = 70
    d[31] = level
    h.wr(S("wBreedMon1Stats"), d)
    h.wr(S("wBreedMon1Nick"), enc("BULBA@@@@@@"))
    h.wr(S("wBreedMon1Nick") + 11, enc("LUKE@@@@@@@"))
    h.wr(S("wDayCareMan"), h.rd(S("wDayCareMan")) | 1)  # DAYCAREMAN_HAS_MON_F


def retrieve_from_man():
    """RetrieveMonFromDayCareMan without its SFX wait (no sound in the harness)."""
    h.wr(S("wCurPartySpecies"), h.rd(S("wBreedMon1Stats")))
    r = h.call("GetBreedMon1LevelGrowth")
    h.wr(S("wd002"), r["b"])
    h.wr(S("wCurPartyLevel"), r["e"])
    h.wr(S("wPokemonWithdrawDepositParameter"), 0)
    h.call("RetrieveBreedmon", max_frames=600)


def breed_exp():
    e = h.rd(S("wBreedMon1Stats") + 8, 3)
    return (e[0] << 16) | (e[1] << 8) | e[2]


# a mon left below the cap still gains a point per counted step
h.wr(S("wDayCareMan"), 0)
h.wr(S("wDayCareLady"), 0)
put_breedmon1(5, exp_at_level(sid, 5))
before = breed_exp()
h.call("DayCareStep")
check(breed_exp() == before + 1, f"below the cap: +1 EXP per step ({before} -> {breed_exp()})")
check(h.rd(S("wLevelCap")) == 10, f"cap refreshed to 10 (got {h.rd(S('wLevelCap'))})")

# one left at the cap gains nothing
put_breedmon1(10, cap_exp)
h.call("DayCareStep")
check(breed_exp() == cap_exp, f"at the cap: no EXP ({cap_exp} -> {breed_exp()})")

# one left above the cap gains nothing either, and isn't lowered
put_breedmon1(14, exp_at_level(sid, 14))
h.call("DayCareStep")
check(breed_exp() == exp_at_level(sid, 14), "above the cap: no EXP")
r = h.call("GetBreedMon1LevelGrowth")
check(r["e"] == 14 and r["d"] == 0, f"above the cap: level kept, no growth (level {r['e']}, +{r['d']})")

# taking back a mon whose total ran past the cap clamps the total
put_breedmon1(5, big_exp)
h.wr(S("wLevelCap"), 3)  # stale value: must be refreshed
r = h.call("GetBreedMon1LevelGrowth")
check(r["e"] == 10 and r["d"] == 5, f"growth stops at the cap (level {r['e']}, +{r['d']})")
set_party_empty()
retrieve_from_man()
check(h.rd(S("wPartyCount")) == 1, "mon returned to the party")
check(h.rd(S("wPartyMon1Level")) == 10, f"returned at level 10 (got {h.rd(S('wPartyMon1Level'))})")
e = h.rd(S("wPartyMon1Exp"), 3)
got = (e[0] << 16) | (e[1] << 8) | e[2]
check(got == cap_exp, f"EXP clamped to the cap level's total ({got} vs {cap_exp}; banked was {big_exp})")

# below the cap nothing is clamped
mid_exp = exp_at_level(sid, 8) + 7
put_breedmon1(5, mid_exp)
set_party_empty()
retrieve_from_man()
e = h.rd(S("wPartyMon1Exp"), 3)
got = (e[0] << 16) | (e[1] << 8) | e[2]
check(h.rd(S("wPartyMon1Level")) == 8 and got == mid_exp, f"below the cap: level 8, EXP untouched ({got} vs {mid_exp})")

# Normal Mode: unchanged behaviour (cap 100)
h.wr(S("wStatusFlags2"), flags & ~(1 << HARD_MODE_BIT) & 0xFF)
put_breedmon1(5, big_exp)
set_party_empty()
retrieve_from_man()
e = h.rd(S("wPartyMon1Exp"), 3)
got = (e[0] << 16) | (e[1] << 8) | e[2]
check(h.rd(S("wPartyMon1Level")) == 30 and got == big_exp, f"Normal Mode: level 30, EXP kept (level {h.rd(S('wPartyMon1Level'))})")
put_breedmon1(30, big_exp)
h.call("DayCareStep")
check(breed_exp() == big_exp + 1, "Normal Mode: steps still give EXP")
h.wr(S("wStatusFlags2"), flags)

print(f"\n{PASS} passed, {FAIL} failed, {h.calls} routine calls")
sys.exit(1 if FAIL else 0)
