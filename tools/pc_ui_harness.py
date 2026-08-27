#!/usr/bin/env python3
"""Shared setup for the Bill's PC UI tests: boots the ROM, builds a party and
box contents, enters UseBillsPC and provides press()/frames() helpers.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_harness import Harness, enc, SENTINEL, SCRATCH_SP  # noqa: E402

OUT = os.environ.get("PC_UI_OUT", "/tmp")
PASS = FAIL = 0


def check(cond, msg):
    global PASS, FAIL
    if cond:
        PASS += 1
    else:
        FAIL += 1
        print("  FAIL:", msg)


h = Harness()
h.boot(600)
S = h.s
py = h.pyboy

def setup_default():
    """Party of 2 (Eevee, Golurk) and box 1 with Charizard(+item), shiny
    Pikachu, Mewtwo, an Egg."""
    # --- game state -------------------------------------------------------------
    h.wr(S("wPartyCount"), 0)
    h.wr(S("wPartySpecies"), 0xFF)
    h.wr(S("wCurBox"), 0)
    h.wr(S("wPlayerID"), [0x12, 0x34])
    h.wr(S("wPlayerName"), enc("LUKE@@@@"))
    h.wr(S("wPlayerGender"), 0)
    h.wr(S("wOptions"), 0)
    h.call("InitializeBoxes")
    h.call("ClearBackupBoxes")

    # Box 1: a handful of species, one shiny, one holding an item, one egg
    mons = [
        dict(species_index=6, moves_index=[1, 2, 3, 4], level=36, item=0x53, nick="CHARIZARD@@"),
        dict(species_index=25, moves_index=[1, 0, 0, 0], level=12, shiny_gender=0xC0, nick="PIKACHU@@@@"),
        dict(species_index=150, moves_index=[5, 6, 7, 8], level=70, nick="MEWTWO@@@@@"),
        dict(species_index=1, moves_index=[1, 0, 0, 0], level=5, egg=1, nick="EGG@@@@@@@@"),
        dict(species_index=133, moves_index=[1, 2, 0, 0], level=20, item=0x10, nick="EEVEE@@@@@@"),
        dict(species_index=300, moves_index=[1, 2, 0, 0], level=33, nick="TESTMON@@@@"),
    ]
    for m in mons:
        h.build_temp_mon(**m)
        h.call("AddTempMonToStorage")
    # Withdraw slots 5 and 6 into the party (box slots 1-4 stay occupied)
    for slot in (5, 6):
        r = h.call("SwapStorageBoxSlots", bc=0, de=(1 << 8) | slot)
        check(r["a"] == 0, f"withdraw {slot} ok (got {r['a']})")
    check(h.rd(S("wPartyCount")) == 2, "party count 2")



def enter():
    """Sets up the video state and starts UseBillsPC (call frames() next)."""
    global MARKER, STUB
    # --- video state: fonts, no map animations, normal vblank --------------------
    h.wr(0xFF00 | (S("hVBlank") & 0xFF), 0)
    h.wr(S("hLCDCPointer"), 0)
    h.wr(S("hMapAnims"), 0)
    h.wr(S("hInMenu"), 1)
    h.wr(S("hSCX"), 0)
    h.wr(S("hSCY"), 0)
    h.wr(S("hWY"), 0x90)
    h.wr(S("hWX"), 7)
    h.wr(S("wVramState"), 0)
    h.wr(S("hOAMUpdate"), 0)
    h.call("ClearSpriteAnims")
    h.call("LoadStandardFont", max_frames=120)
    h.call("LoadFontsExtra", max_frames=120)
    # make sure the LCD is on with BG/OBJ/window enabled the way the game runs it
    h.wr(0xFF40, 0xE3)  # LCDC: on, win map 9C00, bg map 9800, obj 8x8 on, bg on
    h.wr(0xFF41, 0x08)  # STAT: hblank interrupt
    h.wr(0xFFFF, 0x0B)  # IE: vblank, stat, timer

    # --- enter the PC -----------------------------------------------------------
    bank, addr = h.sym["UseBillsPC"]
    # return marker: ld a, 1 / ld [MARKER], a / jr @
    MARKER = SENTINEL + 8
    h.wr(SENTINEL, [0x3E, 0x01, 0xEA, MARKER & 0xFF, MARKER >> 8, 0x18, 0xFE])
    h.wr(MARKER, 0)
    h.mem[0xFF70] = 1
    h.set_rom_bank(bank)
    sp = SCRATCH_SP - 2
    h.wr16(sp, SENTINEL)
    h.reg.SP = sp
    # entry stub: ei / jp UseBillsPC (the harness parks routines with di)
    STUB = SENTINEL + 10  # above the sentinel and marker, below wStackTop
    h.wr(STUB, [0xFB, 0xC3, addr & 0xFF, addr >> 8])
    h.reg.PC = STUB


MARKER = SENTINEL + 8
STUB = SENTINEL + 10
shots = 0


def sane():
    pc = h.reg.PC
    sp = h.reg.SP
    return (pc < 0x8000 or 0xC000 <= pc < 0xE000) and 0xC000 <= sp < 0xE000


def frames(n, label=None):
    global shots
    for _ in range(n):
        py.tick(1, True)
        if not sane():
            raise RuntimeError(f"CPU went off the rails: PC={h.reg.PC:04x} SP={h.reg.SP:04x}")
        if h.rd(MARKER):
            return True
    if label:
        py.screen.image.convert("RGB").save(f"{OUT}/pc_ui_{shots:02d}_{label}.png")
        shots += 1
    return False


def press(btn, hold=8, wait=16, label=None):
    py.button_press(btn)
    frames(hold)
    py.button_release(btn)
    return frames(wait, label)




def pos():
    return h.rd(S("wBillsPC_CursorPos"))


def goto(target, label=None):
    """Move the cursor to position $yx (y = 0 title, 1-5 rows; x = 0-1 party, 2-5 box)."""
    for _ in range(24):
        cur = pos()
        if cur == target:
            break
        ty, tx = target >> 4, target & 0xF
        cy, cx = cur >> 4, cur & 0xF
        if ty == 0:
            if cy != 0:
                press("start")
            elif cx < tx:
                press("right")
            else:
                press("left")
        elif cy == 0:
            press("down")
        elif tx >= 2 and cx < 2:
            press("right")       # leave the party columns first
        elif tx < 2 and cy < 3:
            press("down")        # party rows start at 3
        elif cy < ty:
            press("down")
        elif cy > ty:
            press("up")
        elif cx < tx:
            press("right")
        else:
            press("left")
    else:
        check(False, f"goto {target:02x}: stuck at {pos():02x}")
    frames(20, label)


def finish():
    print(f"\n{PASS} passed, {FAIL} failed; {shots} screenshots in {OUT}")
    sys.exit(1 if FAIL else 0)
