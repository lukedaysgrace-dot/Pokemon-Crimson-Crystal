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

    def addr(self, name):
        return self.by_name[name][1]

    def bank(self, name):
        return self.by_name[name][0]


def _parse_constants(path, const_re=r"^\tconst (\w+)"):
    """Return {NAME: value} honouring const_def [start] directives."""
    out = {}
    value = None
    pat_def = re.compile(r"^\tconst_def(?:\s+(\d+))?")
    pat_const = re.compile(const_re)
    pat_skip = re.compile(r"^\tconst_skip(?:\s+(\d+))?")
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
    return out


class Constants:
    def __init__(self, root=None):
        root = Path(root or ROOT)
        c = root / "constants"
        self.species = _parse_constants(c / "pokemon_constants.asm")
        self.moves = _parse_constants(c / "move_constants.asm")
        self.items = _parse_constants(c / "item_constants.asm")
        self.abilities = _parse_constants(c / "ability_constants.asm")
        # reverse maps
        self.species_by_index = {v: k for k, v in self.species.items()}
        self.moves_by_index = {v: k for k, v in self.moves.items()}
        self.items_by_id = {v: k for k, v in self.items.items()}
        self.abilities_by_id = {v: k for k, v in self.abilities.items()}
        # species constants files list forms after NUM_POKEMON; clamp to real dex
        self.num_pokemon = self.species.get("NUM_POKEMON")
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
