#!/usr/bin/env python3
"""PyBoy-based harness for exercising the storage backend directly.

Calls ROM routines by symbol with chosen registers, using a planted
`jr @` sentinel in WRAM as the return address, and inspects WRAM/SRAM.
Requires PyBoy patched for 8 SRAM banks (see docs/pc_storage_design.md).

Usage: python3 tools/pc_harness.py [pokecrystal.gbc]
"""
import re
import sys
import os

from pyboy import PyBoy

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "pokecrystal.gbc")
SYM = os.path.splitext(ROM)[0] + ".sym"

SENTINEL = 0xC0F0  # inside wStack area: we plant "ld a, 1 / ld [MARKER], a / jr @" there
MARKER = 0xC0F8    # set to 1 when the sentinel is reached
SCRATCH_SP = 0xC0EE


def enc(text):
    """Encode ASCII text in the game's charmap (A-Z, a-z, 0-9, space, '@' terminator)."""
    out = bytearray()
    for ch in text:
        if "A" <= ch <= "Z":
            out.append(0x80 + ord(ch) - ord("A"))
        elif "a" <= ch <= "z":
            out.append(0xA0 + ord(ch) - ord("a"))
        elif "0" <= ch <= "9":
            out.append(0xF6 + ord(ch) - ord("0"))
        elif ch == " ":
            out.append(0x7F)
        elif ch == "@":
            out.append(0x50)
        elif ch == "?":
            out.append(0xE6)
        else:
            raise ValueError(ch)
    return bytes(out)


def dec(data):
    inv = {}
    for i in range(26):
        inv[0x80 + i] = chr(ord("A") + i)
        inv[0xA0 + i] = chr(ord("a") + i)
    for i in range(10):
        inv[0xF6 + i] = chr(ord("0") + i)
    inv[0x7F] = " "
    inv[0x50] = "@"
    inv[0xE6] = "?"
    return "".join(inv.get(b, "#") for b in data)


class Sym:
    def __init__(self, path):
        self.by_name = {}
        for line in open(path, encoding="utf-8"):
            m = re.match(r"^([0-9a-fA-F]{2}):([0-9a-fA-F]{4})\s+(\S+)", line)
            if m:
                self.by_name[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))

    def __getitem__(self, name):
        return self.by_name[name]

    def addr(self, name):
        return self.by_name[name][1]

    def bank(self, name):
        return self.by_name[name][0]


class Harness:
    def __init__(self, rom=ROM, sym=SYM, headless=True):
        # File-like ROM input prevents PyBoy from silently loading adjacent
        # emulator .ram/.rtc sidecars. Every harness run needs a clean cartridge
        # so a developer's last play session cannot change test outcomes.
        with open(rom, "rb") as rom_file:
            self.pyboy = PyBoy(rom_file, window="null" if headless else "SDL2", sound_emulated=False)
        self.pyboy.set_emulation_speed(0)
        self.sym = Sym(sym)
        self.mem = self.pyboy.memory
        self.reg = self.pyboy.register_file
        self.calls = 0

    # --- memory helpers -------------------------------------------------
    def rd(self, addr, n=1):
        if n == 1:
            return self.mem[addr]
        return bytes(self.mem[addr:addr + n])

    def wr(self, addr, data):
        if isinstance(data, int):
            self.mem[addr] = data
        else:
            for i, b in enumerate(data):
                self.mem[addr + i] = b

    def rd16(self, addr):
        return self.mem[addr] | (self.mem[addr + 1] << 8)

    def wr16(self, addr, v):
        self.mem[addr] = v & 0xFF
        self.mem[addr + 1] = (v >> 8) & 0xFF

    def s(self, name):
        return self.sym.addr(name)

    # --- SRAM access (direct, via the cartridge object) -------------------
    def sram(self, bank, addr, n=1):
        """Read SRAM directly (enables SRAM, selects the bank, then disables it again)."""
        self.mem[0x0000] = 0x0A
        self.mem[0x4000] = bank
        if n == 1:
            v = self.mem[addr]
        else:
            v = bytes(self.mem[addr:addr + n])
        self.mem[0x0000] = 0
        return v

    def sram_wr(self, bank, addr, data):
        self.mem[0x0000] = 0x0A
        self.mem[0x4000] = bank
        if isinstance(data, int):
            data = [data]
        for i, b in enumerate(data):
            self.mem[addr + i] = b
        self.mem[0x0000] = 0

    def sym_sram(self, name, n=1):
        bank, addr = self.sym[name]
        return self.sram(bank, addr, n)

    # --- calling ROM routines -----------------------------------------------
    def boot(self, frames=400):
        for _ in range(frames):
            self.pyboy.tick(1, False)

    def set_rom_bank(self, bank):
        self.mem[0x2000] = bank
        self.mem[self.s("hROMBank")] = bank

    def call(self, name, a=0, bc=0, de=0, hl=0, f=0, max_frames=240):
        """Call routine `name` with the given registers; returns dict of registers."""
        bank, addr = self.sym[name]
        # plant sentinel: di / jr @ (di so the frame ends parked here with the
        # routine's registers intact even when interrupts are enabled)
        self.wr(SENTINEL, [0xF3, 0x18, 0xFE])
        # WRAM bank 1, SRAM closed, ROM bank
        self.mem[0xFF70] = 1
        if bank != 0:
            self.set_rom_bank(bank)
        sp = SCRATCH_SP
        sp -= 2
        self.wr16(sp, SENTINEL)
        self.reg.SP = sp
        self.reg.A = a & 0xFF
        self.reg.F = f & 0xF0
        self.reg.B = (bc >> 8) & 0xFF
        self.reg.C = bc & 0xFF
        self.reg.D = (de >> 8) & 0xFF
        self.reg.E = de & 0xFF
        self.reg.HL = hl & 0xFFFF
        self.reg.PC = addr
        # run until PC parks on the sentinel
        for _ in range(max_frames):
            self.pyboy.tick(1, False)
            if self.reg.PC in (SENTINEL + 1, SENTINEL + 3):
                break
        else:
            raise RuntimeError(f"{name} did not return within {max_frames} frames (PC={self.reg.PC:04x})")
        self.calls += 1
        f = self.reg.F
        return dict(a=self.reg.A, b=self.reg.B, c=self.reg.C, d=self.reg.D, e=self.reg.E,
                    hl=self.reg.HL, z=bool(f & 0x80), c_flag=bool(f & 0x10),
                    bc=(self.reg.B << 8) | self.reg.C, de=(self.reg.D << 8) | self.reg.E)

    # --- domain helpers -------------------------------------------------------
    def temp_mon(self):
        base = self.s("wTempMon")
        d = self.rd(base, 50)
        return {
            "species": d[0], "item": d[1], "moves": list(d[2:6]), "id": d[6] | (d[7] << 8),
            "exp": list(d[8:11]), "statexp": list(d[11:21]), "dvs": list(d[21:23]),
            "pp": list(d[23:27]), "happiness": d[27], "pokerus": d[28], "caught": list(d[29:31]),
            "level": d[31], "personality": d[32], "hidden_power": d[33],
            "status": d[34], "unused": d[35],
            "hp": (d[36] << 8) | d[37], "maxhp": (d[38] << 8) | d[39],
            "nick": self.rd(self.s("wTempMonNickname"), 11),
            "ot": self.rd(self.s("wTempMonOT"), 11),
            "idx": self.rd16(self.s("wTempMonSpeciesIndex")),
            "egg": self.rd(self.s("wTempMonIsEgg")),
            "box": self.rd(self.s("wTempMonBox")), "slot": self.rd(self.s("wTempMonSlot")),
        }

    def species_id(self, index):
        return self.call("GetPokemonIDFromIndex", hl=index)["a"]

    def move_id(self, index):
        return self.call("GetMoveIDFromIndex", hl=index)["a"]

    def species_index(self, id_):
        return self.call("GetPokemonIndexFromID", a=id_)["hl"]

    def move_index(self, id_):
        return self.call("GetMoveIndexFromID", a=id_)["hl"]

    def build_temp_mon(self, species_index, moves_index, level=50, item=0, ot_id=0x1234,
                       nick="TESTMON@@@@", ot="LUKE@@@@@@@", dvs=(0xFF, 0xFF), ppups=(0, 0, 0, 0),
                       statexp=None, happiness=70, pokerus=0, shiny_gender=0x40, caught=(0x32, 0x05),
                       personality=0x21, hidden_power=0, egg=0):
        base = self.s("wTempMon")
        sid = self.species_id(species_index)
        mids = [self.move_id(m) if m else 0 for m in moves_index]
        d = bytearray(50)
        d[0] = sid
        d[1] = item
        d[2:6] = mids
        d[6] = ot_id & 0xFF
        d[7] = ot_id >> 8
        d[8:11] = [0x01, 0x23, 0x45]
        d[11:21] = statexp or [0x12, 0x34] * 5
        d[21:23] = dvs
        d[23:27] = [(p << 6) | 5 for p in ppups]
        d[27] = happiness
        d[28] = pokerus
        d[29:31] = caught
        d[31] = level
        d[32] = personality
        d[33] = hidden_power
        d[34] = 0
        d[35] = shiny_gender
        self.wr(base, d)
        self.wr(self.s("wTempMonNickname"), enc(nick) if isinstance(nick, str) else nick)
        self.wr(self.s("wTempMonOT"), enc(ot) if isinstance(ot, str) else ot)
        self.wr(self.s("wTempMonIsEgg"), egg)
        self.wr16(self.s("wTempMonSpeciesIndex"), species_index)
        return dict(sid=sid, mids=mids)

    def box_pointer(self, box, slot):
        r = self.call("GetStorageBoxPointer", bc=(box << 8) | slot)
        return r["d"], r["e"]

    def free_entries(self):
        """Free PokeDB records after a flush (exact count from the bitmaps)."""
        self.call("FlushStorageSystem")
        used = 0
        for name in ("wPokeDB1UsedEntries", "wPokeDB2UsedEntries"):
            for b in self.rd(self.s(name), 32):
                used += bin(b).count("1")
        return 2 * 254 - used


if __name__ == "__main__":
    h = Harness()
    h.boot()
    print("booted; PC =", hex(h.reg.PC))
    print("NUM_BOXES symbols:", h.sym["sNewBox1"], h.sym["sBoxMons1A"])
