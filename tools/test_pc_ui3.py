#!/usr/bin/env python3
"""Bill's PC UI: menu withdraw/deposit, GIVE from the menu, Mail, release all,
full-database forced save, party-full / last-healthy refusals."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

setup_default()
from pc_harness import dec  # noqa: E402

MAIL = 0x9E  # FLOWER_MAIL


def item_id(name):
    return {"FLOWER_MAIL": 0xB5, "BITTER_BERRY": 0x53, "POTION": 0x12}[name]


# bag: a Mail and a Potion
h.wr(S("wNumItems"), 2)
h.wr(S("wNumItems") + 1, [MAIL, 1, 0x12, 1, 0xFF])


def num_items():
    return h.rd(S("wNumItems"))


def box_entry(slot):
    r = h.rd(S("wBillsPC_BoxList") + 2 * (slot - 1), 2)
    return r[0] | (r[1] << 8)


print("[open]")
enter()
frames(180, "open")

print("[menu WITHDRAW Charizard -> party, then DEPOSIT it back]")
press("a", wait=30)                          # menu on $12 Charizard
press("a", wait=120, label="withdrawn")      # WITHDRAW
check(h.rd(S("wPartyCount")) == 3, f"party count 3 after withdraw (got {h.rd(S('wPartyCount'))})")
check(box_entry(1) == 0, "box slot 1 empty after withdraw")
press("down"); press("down"); press("down"); press("left"); press("left", wait=20, label="on_party3")  # $40 party slot 3
press("a", wait=30, label="party_menu")
press("a", wait=120, label="deposited")      # DEPOSIT
check(h.rd(S("wPartyCount")) == 2, f"party count 2 after deposit (got {h.rd(S('wPartyCount'))})")
check(box_entry(1) == 0x4006, f"shiny Charizard back in box slot 1 (entry {box_entry(1):04x})")

print("[menu ITEM > GIVE: Potion to Golurk (party slot 2)]")
press("right", wait=20)                       # $41 -> hmm: from $40 right = $41 (party slot 4, empty)
press("up", wait=20)                          # $31 Golurk
press("a", wait=30)
press("down"); press("down"); press("down", wait=10)   # ITEM
press("a", wait=40, label="item_menu")
press("a", hold=4, wait=150, label="give_pack")       # GIVE -> pack
press("down", hold=4, wait=30)                # second item: Potion
press("a", hold=4, wait=150, label="given")
check(num_items() == 1, f"one item left in the bag (got {num_items()})")
check(h.rd(S("wPartyMon2Item")) == 0x12, f"Golurk holds the Potion (item {h.rd(S('wPartyMon2Item')):02x})")

print("[menu ITEM > BAG: Eevee's Hyper Potion to the bag]")
press("left", wait=20)                        # $30 Eevee
press("a", wait=30)
press("down"); press("down"); press("down", wait=10)   # ITEM
press("a", wait=40)
press("down", wait=10)                        # BAG
press("a", wait=80, label="bagged")
press("a", wait=40)                           # dismiss "Moved ... to the BAG."
check(num_items() == 2, f"two items in the bag (got {num_items()})")
check(h.rd(S("wPartyMon1Item")) == 0, "Eevee holds nothing")

print("[item mode: give the Mail to Eevee (party slot 1): compose screen]")
press("select"); press("select", wait=20)     # ITEM mode
press("right"); press("up", wait=20)          # $31 -> $21 bag
h.wr(S("wItemsPocketCursor"), 1)             # the pack remembers its cursor: back to the Mail
h.wr(S("wItemsPocketScrollPosition"), 0)
press("a", hold=4, wait=150, label="mail_pack")
press("a", hold=4, wait=150, label="mail_picked")
check(h.rd(S("wBillsPC_CursorItem")) == MAIL, f"holding the Mail (item {h.rd(S('wBillsPC_CursorItem')):02x})")
press("down"); press("left", wait=20)         # $30 Eevee
press("a", hold=4, wait=200, label="compose")
press("start", hold=3, wait=60); press("a", hold=4, wait=200, label="mail_given")
check(h.rd(S("wPartyMon1Item")) == MAIL, f"Eevee holds the Mail (item {h.rd(S('wPartyMon1Item')):02x})")
check(num_items() == 1, "one item left in the bag")

print("[item mode: Mail can't go into a box]")
press("a", wait=60, label="mail_picked2")     # pick the Mail from Eevee ($30)
check(h.rd(S("wBillsPC_CursorItem")) == MAIL, "holding the Mail")
goto(0x13, "mail_over_pikachu")               # Pikachu (box)
press("a", wait=80, label="mail_refused")
press("a", wait=40)                           # dismiss "Can't place MAIL in storage."
check(h.rd(S("wPartyMon1Item")) == MAIL, "Mail still on Eevee")
check(h.rd(S("wBillsPC_CursorItem")) == MAIL, "still holding the Mail")
press("b", wait=80, label="mail_aborted")     # put it back
check(h.rd(S("wBillsPC_CursorHeldBox")) == 0, "nothing held after B")

print("[menu ITEM > TAKE Mail: send to PC mailbox]")
press("select", wait=20)                       # MENU mode
goto(0x30, "on_eevee")
press("a", wait=30); press("down"); press("down"); press("down", wait=10)
press("a", wait=40, label="mail_menu")         # ITEM -> MOVE/TAKE/READ/CANCEL
press("down", wait=10)
press("a", wait=60, label="take_prompt")       # TAKE -> "Send the removed MAIL to your PC?"
press("a", wait=80, label="mail_sent")         # YES
press("a", wait=40)
check(h.rd(S("wPartyMon1Item")) == 0, "Mail removed from Eevee")
check(h.sym_sram("sMailboxCount") == 1, f"mailbox count 1 (got {h.sym_sram('sMailboxCount')})")

print("[box menu: RELEASE all]")
while h.rd(S("wBillsPC_CursorMode")) != 0:
    press("select", wait=20)                   # back to MENU mode
goto(0x02, "on_title")
press("a", wait=30); press("up"); press("up", wait=10)   # RELEASE (4th of 5)
press("a", wait=60, label="releaseall_prompt")
press("up", wait=10); press("a", wait=120)     # YES
press("a", wait=60)                            # <CONT> of "You can't recall..."
press("up", wait=20); press("a", wait=150, label="released_all")   # YES again
press("a", wait=60); press("a", wait=60, label="released_all2")
check(all(box_entry(i) == 0 for i in (1, 2, 3)), f"box 1 mons released ({[box_entry(i) for i in range(1, 5)]})")
check(box_entry(4) == 0x8001, "the egg was kept")

print("[exit]")
goto(0x12)
press("b", wait=40, label="exit_prompt")
press("down", wait=10)
press("a", wait=40)
for _ in range(20):
    if frames(10):
        break
check(h.rd(MARKER) == 1, "UseBillsPC returned")
finish()
