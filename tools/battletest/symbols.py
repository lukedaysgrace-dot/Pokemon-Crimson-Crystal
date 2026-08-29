"""Symbol table and constants for the battle test harness.

Parses pokecrystal_debug.sym (never hardcode addresses -- they move every
time a section grows) and the constants files (species/move/item/ability
names -> numeric indexes, in file order).
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


class Symbols:
    def __init__(self, sym_path=None):
        sym_path = Path(sym_path or ROOT / "pokecrystal_debug.sym")
        self.by_name = {}
        pat = re.compile(r"^([0-9a-fA-F]{2,3}):([0-9a-fA-F]{4}) (\S+)")
        with open(sym_path) as f:
            for line in f:
                m = pat.match(line)
                if m:
                    bank, addr, name = m.groups()
                    # first definition wins (sym file is sorted; aliases share addrs)
                    self.by_name.setdefault(name, (int(bank, 16), int(addr, 16)))

    def __getitem__(self, name):
        return self.by_name[name]

    def nearest(self, bank, addr):
        """Name of the closest symbol at or below (bank, addr) - for
        symbolizing a sampled PC when a battle hangs in a reroll loop."""
        best, best_addr = None, -1
        for name, (b, a) in self.by_name.items():
            if b == bank and best_addr < a <= addr:
                best, best_addr = name, a
        if best is None:
            return f"{bank:02x}:{addr:04x}"
        off = addr - best_addr
        return f"{best}+{off:#x}" if off else best

    def addr(self, name):
        return self.by_name[name][1]

    def bank(self, name):
        return self.by_name[name][0]


def _parse_constants(path, const_re=r"^\tconst (\w+)", const_value_equs=()):
    """Return {NAME: value} honouring const_def and selected EQU markers."""
    out = {}
    value = None
    pat_def = re.compile(r"^\tconst_def(?:\s+(\d+))?")
    pat_const = re.compile(const_re)
    pat_skip = re.compile(r"^\tconst_skip(?:\s+(\d+))?")
    equ_names = "|".join(re.escape(name) for name in const_value_equs)
    pat_equ = re.compile(
        rf"^({equ_names})\s+EQU\s+const_value(?:\s*\+\s*(-?\d+))?"
    ) if equ_names else None
    with open(path) as f:
        for line in f:
            line = line.split(";")[0].rstrip()
            m = pat_def.match(line)
            if m:
                value = int(m.group(1)) if m.group(1) else 0
                continue
            m = pat_skip.match(line)
            if m and value is not None:
                value += int(m.group(1)) if m.group(1) else 1
                continue
            m = pat_const.match(line)
            if m and value is not None:
                out[m.group(1)] = value
                value += 1
                continue
            m = pat_equ.match(line) if pat_equ else None
            if m and value is not None:
                out[m.group(1)] = value + int(m.group(2) or 0)
    return out


class Constants:
    def __init__(self, root=None):
        root = Path(root or ROOT)
        c = root / "constants"
        self.species = _parse_constants(
            c / "pokemon_constants.asm", const_value_equs=("NUM_POKEMON",))
        self.moves = _parse_constants(
            c / "move_constants.asm", const_value_equs=("NUM_ATTACKS",))
        self.items = _parse_constants(c / "item_constants.asm")
        self.abilities = _parse_constants(c / "ability_constants.asm")
        # trainer classes: `trainerclass NAME ; N` (the macro restarts the
        # trainer-ID namespace, so read the index from the comment)
        self.trainer_classes = {}
        pat_tc = re.compile(r"^\ttrainerclass (\w+)\s*;\s*(\d+)")
        for line in (c / "trainer_constants.asm").open():
            m = pat_tc.match(line)
            if m:
                self.trainer_classes[m.group(1)] = int(m.group(2))
        # reverse maps. pokemon_constants.asm restarts const_def after
        # NUM_POKEMON for cosmetic forms (UNOWN_B..., PIKACHU_FLY...), whose
        # values overlap real species - first definition wins, so RAICHU (26)
        # is not shadowed by UNOWN_Z (also 26).
        # first definition wins in every reverse map: the constants files
        # restart const_def for secondary namespaces whose values overlap
        # (species forms after NUM_POKEMON, BATTLEANIM_* after the moves).
        self.species_by_index = {}
        for k, v in self.species.items():
            self.species_by_index.setdefault(v, k)
        self.moves_by_index = {}
        for k, v in self.moves.items():
            self.moves_by_index.setdefault(v, k)
        self.items_by_id = {}
        for k, v in self.items.items():
            self.items_by_id.setdefault(v, k)
        self.abilities_by_id = {}
        for k, v in self.abilities.items():
            self.abilities_by_id.setdefault(v, k)
        # species constants files list forms after NUM_POKEMON; clamp to real dex
        self.num_pokemon = self.species.get("NUM_POKEMON")
        self.num_attacks = self.moves.get("NUM_ATTACKS")
        # species -> (ability1, ability2, hidden), from base stats
        self.species_abilities = {}
        pat = re.compile(r"^\tabilities_for (\w+),\s*(\w+),\s*(\w+),\s*(\w+)")
        for f in (root / "data" / "pokemon" / "base_stats").glob("*.asm"):
            for line in f.open():
                m = pat.match(line)
                if m:
                    self.species_abilities[m.group(1)] = (
                        m.group(2), m.group(3), m.group(4))

    def ability_slot_of(self, species, ability):
        """Return 0/1/2 if the species legally has the ability, else None."""
        slots = self.species_abilities.get(species.upper())
        if not slots:
            return None
        ability = ability.upper().replace(" ", "_")
        for i, a in enumerate(slots):
            if a == ability and a != "NO_ABILITY":
                return i
        return None

    def species_index(self, name):
        return self.species[name.upper()]

    def move_index(self, name):
        return self.moves[name.upper().replace(" ", "_")]

    def item_id(self, name):
        return self.items[name.upper().replace(" ", "_")]

    def ability_id(self, name):
        return self.abilities[name.upper().replace(" ", "_")]


def parse_substatus_bits(root=None):
    """SUBSTATUS_* -> (byte_index 0-4, bit). Parsed from the enum blocks in
    constants/battle_constants.asm; the comment above each block names the
    wram byte ("wPlayerSubStatus3 or ..."). enum_start 7, -1 counts down."""
    root = Path(root or ROOT)
    out = {}
    byte_idx = None
    value = None
    step = 1
    hdr = re.compile(r"^; wPlayerSubStatus(\d)")
    start = re.compile(r"^\tenum_start\s+(-?\d+)(?:,\s*(-?\d+))?")
    entry = re.compile(r"^\tenum (SUBSTATUS_\w+)")
    for line in (root / "constants" / "battle_constants.asm").open():
        m = hdr.match(line)
        if m:
            byte_idx = int(m.group(1)) - 1
            value = None
            continue
        if byte_idx is not None:
            m = start.match(line)
            if m:
                value = int(m.group(1))
                step = int(m.group(2)) if m.group(2) else 1
                continue
            m = entry.match(line)
            if m and value is not None:
                out[m.group(1)[len("SUBSTATUS_"):]] = (byte_idx, value)
                value += step
    return out


# Status byte bits (constants/battle_constants.asm)
SLP_MASK = 0b111
PSN, BRN, FRZ, PAR = 3, 4, 5, 6

# Weather (constants/battle_constants.asm)
WEATHER = {"none": 0, "rain": 1, "sun": 2, "sandstorm": 3, "hail": 4}

# wDebugState milestones (engine/debug/battle_tester.asm)
STATE_IDLE = 0x00
STATE_MENU = 0x01
STATE_INIT = 0x02
STATE_READY = 0x03
STATE_WAIT = 0x04
STATE_DONE = 0x05
STATE_ERROR = 0xFF
