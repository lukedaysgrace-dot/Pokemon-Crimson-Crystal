#!/usr/bin/env python3
"""Bill's PC UI: moving a held item between two party mons in item mode.

The party Mail slots must follow the items, and nothing outside sPartyMail may
be touched (a wrong slot index once swapped the source's Mail data with the
player/Mom/rival name buffers)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

setup_default()

MAIL_STRUCT_LENGTH = 47
NAMES = S("wPlayerName")
NAMES_LENGTH = S("wSavedAtLeastOnce") - NAMES
_, MAIL_ADDR = h.sym["sPartyMail"]

# Recognizable contents for the name buffers after the player's name and for
# the first party Mail slot.
h.wr(NAMES + 11, [0x80 + (i % 26) for i in range(NAMES_LENGTH - 11)])
h.sram_wr(0, MAIL_ADDR, [0xC0 + (i % 16) for i in range(MAIL_STRUCT_LENGTH)])


def names():
    return h.rd(NAMES, NAMES_LENGTH)


def mail(slot):
    return h.sym_sram("sPartyMail", MAIL_STRUCT_LENGTH * 6)[
        MAIL_STRUCT_LENGTH * slot:MAIL_STRUCT_LENGTH * (slot + 1)]


print("[open]")
enter()
frames(180, "open")

print("[item mode: party slot 1's item to party slot 2]")
press("select"); press("select", wait=20)     # ITEM mode
goto(0x30)                                    # party slot 1
item = h.rd(S("wPartyMon1Item"))
check(item != 0 and h.rd(S("wPartyMon2Item")) == 0, "slot 1 holds an item, slot 2 none")
names_before, mail1_before, mail2_before = names(), mail(0), mail(1)
press("a", wait=60, label="item_picked")
check(h.rd(S("wBillsPC_CursorItem")) == item, "holding slot 1's item")
goto(0x31)                                    # party slot 2
press("a", wait=120, label="item_placed")
check(h.rd(S("wPartyMon1Item")) == 0 and h.rd(S("wPartyMon2Item")) == item, "item moved to slot 2")
check(names() == names_before, "player/Mom/rival name buffers untouched")
check(mail(1) == mail1_before and mail(0) == mail2_before, "Mail slots swapped along with the items")

print("[item mode: and back again]")
press("a", wait=60, label="item_picked_again")
goto(0x30)
press("a", wait=120, label="item_returned")
check(h.rd(S("wPartyMon1Item")) == item and h.rd(S("wPartyMon2Item")) == 0, "item back on slot 1")
check(names() == names_before, "name buffers still untouched")
check(mail(0) == mail1_before and mail(1) == mail2_before, "Mail slots back where they started")

print("[exit]")
finish()
