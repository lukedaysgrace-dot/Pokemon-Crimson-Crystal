#!/usr/bin/env python3
"""Smoke test for the graphical Bill's PC (engine/pc/bills_pc_ui.asm).

Drives UseBillsPC with joypad input and saves screenshots to /tmp/pc_ui_*.png.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

setup_default()

print("[open]")
enter()
frames(180, "open")
check(h.rd(S("hLCDCPointer")) == 0xFF, "HBlank handler installed")
check(h.rd(0xFF45) in (71, 87, 103, 119, 135), f"LYC in icon rows (got {h.rd(0xFF45)})")
# VRAM bank must be 0 while idle with hBGMapMode set
check(h.rd(0xFF4F) & 1 == 0, "rVBK is 0 while idle")
check(h.rd(S("hBGMapMode")) == 1, "hBGMapMode = 1 in the main loop")

print("[move cursor]")
press("right", label="right")       # $13 (Pikachu)
press("down", label="down")         # $23 (empty)
press("down")                       # $33
press("left")                       # $32
press("left", label="party")        # $31 (party slot 3, empty)
press("up", wait=20, label="party2")  # $21 invalid -> wraps: stays? CursorPosValid
press("start", wait=20, label="boxname")
press("right", wait=40, label="box2")
press("left", wait=40, label="box1")
press("down", wait=20, label="back")  # $12 Charizard

print("[menu on a box mon -> summary]")
press("a", wait=30, label="menu")
press("down", wait=10)
press("a", wait=150, label="summary")
press("down", hold=8, wait=160, label="summary_next")
press("b", hold=8, wait=150, label="summary_closed")
check(h.rd(S("hLCDCPointer")) == 0xFF, "HBlank handler restored after the summary")

print("[switch mode: pick up Charizard, swap with the egg]")
press("left", wait=20)                     # the summary scrolled to Pikachu; back to $12
press("select", wait=20, label="swap_mode")
press("a", wait=40, label="picked")
press("right"); press("right"); press("right", wait=20, label="carry")   # $15 (egg)
press("a", wait=60, label="placed")
r = h.rd(S("wBillsPC_BoxList"), 8)
check(r[6] | (r[7] << 8) == 6, f"Charizard now in box slot 4 (entry {r[6:8].hex()})")
check(r[0] | (r[1] << 8) == 0x8001, f"egg now in box slot 1 (entry {r[0:2].hex()})")

print("[deposit to party via swap mode]")
press("a", wait=40, label="picked2")           # pick up Charizard from slot 4
press("down"); press("down"); press("down")    # $45
press("left"); press("left"); press("left"); press("left", wait=20, label="carry_party")  # $41 party slot 4
press("a", wait=80, label="placed_party")
check(h.rd(S("wPartyCount")) == 3, f"party count 3 after placing (got {h.rd(S('wPartyCount'))})")

print("[menu: release prompt then cancel]")
press("select", wait=20)   # back to menu mode
press("a", wait=30, label="party_menu")
press("b", wait=30, label="party_menu_closed")

print("[change box with left/right on the title]")
press("start", wait=20)
press("right", wait=60, label="box2")
press("left", wait=60, label="box1_again")
press("down", wait=20)

print("[item mode]")
press("select", wait=20)
press("select", wait=20, label="item_mode")
press("up", wait=20, label="on_bag")

print("[exit]")
press("select", wait=20)  # back to menu mode
done = press("b", wait=40, label="exit_prompt")
press("down", wait=10)                                # NO = leave the PC
press("a", wait=40)
for _ in range(20):
    if frames(10):
        break
check(h.rd(MARKER) == 1, f"UseBillsPC returned (PC={h.reg.PC:04x})")
check(h.rd(S("hLCDCPointer")) == 0, "HBlank handler removed on exit")

finish()
