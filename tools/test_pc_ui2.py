#!/usr/bin/env python3
"""Bill's PC UI: item mode, release, rename, theme and change-box menus."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

setup_default()

# empty bag
h.wr(S("wNumItems"), 0)
h.wr(S("wNumItems") + 1, 0xFF)


def num_items():
    return h.rd(S("wNumItems"))


def bag():
    n = num_items()
    return [(h.rd(S("wNumItems") + 1 + 2 * i), h.rd(S("wNumItems") + 2 + 2 * i)) for i in range(n)]


print("[open]")
enter()
frames(180, "open")

print("[item mode: take Charizard's Bitter Berry to the bag]")
press("select"); press("select", wait=20, label="item_mode")
press("a", wait=60, label="item_picked")            # pick up the item (cursor on $12 Charizard)
check(h.rd(S("wBillsPC_CursorHeldBox")) & 0x80, "cursor holds an item")
press("down"); press("down"); press("left")          # -> $31 (party slot 2)
press("up", wait=20, label="item_on_bag")            # -> $21 bag (valid while holding an item)
check(h.rd(S("wBillsPC_CursorPos")) == 0x21, f"cursor on the bag (pos {h.rd(S('wBillsPC_CursorPos')):02x})")
press("a", wait=80, label="item_bagged")
check(num_items() == 1 and bag()[0] == (0x53, 1), f"Bitter Berry in the bag: {bag()}")

r = h.rd(S("wBillsPC_CursorHeldBox"))
check(r == 0, "nothing held after bagging")

print("[item mode: give the berry back from the bag]")
press("a", wait=150, label="pack_open")              # pack opens with the berry
press("a", wait=150, label="pack_picked")            # pick the first item
check(h.rd(S("wBillsPC_CursorHeldBox")) & 0x80, f"holding the item from the bag (held {h.rd(S('wBillsPC_CursorHeldBox')):02x}/{h.rd(S('wBillsPC_CursorHeldSlot')):02x})")
press("right"); press("right", wait=20)              # $23 (box slot 6, empty)
press("up", wait=20, label="item_carry")             # $13 Pikachu
press("a", wait=80, label="item_given")
check(num_items() == 0, f"bag empty again: {bag()}")

print("  pikachu item:", hex(h.rd(S("wTempMonItem"))))

print("[menu mode: release Mewtwo (slot 3)]")
press("select", wait=20)                              # -> MENU mode
press("right", wait=20)                               # $14 Mewtwo
press("a", wait=30, label="menu_mewtwo")
press("up", wait=10)                                  # wrap to CANCEL? items: WITHDRAW SUMMARY SWITCH ITEM RELEASE CANCEL
press("up", wait=10, label="menu_release")            # RELEASE
press("a", wait=40, label="release_prompt")
press("up", wait=10)                                  # NO -> YES
press("a", wait=120, label="released")
press("a", wait=60, label="released2")               # <CONT>
press("a", wait=60, label="released3")               # <PROMPT>
r = h.rd(S("wBillsPC_BoxList"), 8)
check(r[4] | (r[5] << 8) == 0, f"box slot 3 empty after release (entry {r[4:6].hex()})")

print("[box menu: rename, theme, change]")
press("start", wait=20, label="on_title")
press("a", wait=30, label="box_menu")
press("down", wait=10)                                # RENAME
press("a", wait=150, label="naming_screen")
press("start", wait=60)                               # cursor to END
press("a", wait=150, label="renamed")
check(h.rd(S("hLCDCPointer")) == 0xFF, "HBlank handler restored after the naming screen")
press("a", wait=30)
press("down"); press("down", wait=10)                 # THEME
press("a", wait=60, label="theme_menu")
press("down", hold=2, wait=30, label="theme_preview")
press("a", wait=60, label="theme_set")
r = h.sym_sram("sNewBox1Theme")
check(r == 27, f"box 1 theme = ELECTRIC (got {r})")
press("a", wait=30)
press("a", wait=60, label="change_menu")              # CHANGE (first item)
press("down"); press("down", wait=10)
press("a", wait=80, label="changed_box")
check(h.rd(S("wCurBox")) == 2, f"changed to box 3 (wCurBox {h.rd(S('wCurBox'))})")

print("[exit]")
press("down", wait=20)
press("b", wait=40, label="exit_prompt")
press("down", wait=10)                                # NO = leave the PC
press("a", wait=40)
for _ in range(20):
    if frames(10):
        break
check(h.rd(MARKER) == 1, "UseBillsPC returned")
finish()
