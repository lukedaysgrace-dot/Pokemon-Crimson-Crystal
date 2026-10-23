#!/usr/bin/env python3
"""Exercise ability inheritance and actual Day-Care egg generation in a ROM.

Usage: python tools/test_daycare_abilities.py path/to/pokecrystal_debug.gbc
The RNG is overridden in memory so every probability outcome is checked;
neither the ROM nor any emulator save on disk is changed.
"""
from collections import Counter
from pathlib import Path
import sys

from pc_harness import Harness

sys.path.insert(0, str(Path(__file__).resolve().parent / "battletest"))
from symbols import Constants


SLOT1, SLOT2, SLOT3 = 0x20, 0x40, 0x60
PASS = FAIL = 0


def check(condition, message):
    global PASS, FAIL
    if condition:
        PASS += 1
    else:
        FAIL += 1
        print("  FAIL:", message)


rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / "pokecrystal.gbc"
h = Harness(rom=str(rom), sym=str(rom.with_suffix(".sym")))
h.boot()
constants = Constants()


def force_random(name, value):
    bank, addr = h.sym[name]
    # ld a, value / ret. This overrides cartridge bytes in memory only.
    for offset, byte in enumerate((0x3E, value, 0xC9)):
        h.mem[bank, addr + offset] = byte


def samples(parent1, parent2, selected=0, second=True, third=True):
    h.wr(h.s("wBreedMotherOrNonDitto"), selected)
    h.wr(h.s("wBreedMon1Personality"), parent1)
    h.wr(h.s("wBreedMon2Personality"), parent2)
    h.wr(h.s("wBaseAbility2"), int(second))
    h.wr(h.s("wBaseAbility3"), int(third))
    output = []
    preserved = True
    for roll in range(100):
        force_random("RandomRange", roll)
        force_random("Random", roll & 1)
        result = h.call("DayCare_GetEggAbilitySlot", bc=0xABCD, de=0x1357, hl=0x2468)
        output.append(result["a"])
        preserved &= (result["bc"], result["de"], result["hl"]) == (0xABCD, 0x1357, 0x2468)
    check(preserved, "inheritance preserves caller registers")
    return Counter(output)


print("[ability inheritance probabilities and supported slots]")
check(samples(SLOT1, SLOT3) == {SLOT1: 80, SLOT2: 20}, "slot 1 mother: 80% slot 1, 20% slot 2; father ability 3 ignored")
check(samples(SLOT3, SLOT2, selected=1) == {SLOT2: 80, SLOT1: 20}, "slot 2 mother selected from second Day-Care slot")
check(samples(SLOT3, SLOT1) == {SLOT3: 60, SLOT1: 20, SLOT2: 20}, "ability 3 parent: 60% ability 3, 20% each regular slot")
check(samples(SLOT1, SLOT3, selected=1) == {SLOT3: 60, SLOT1: 20, SLOT2: 20}, "second species parent supplies ability 3 slot")
check(samples(SLOT3, SLOT1, second=False) == {SLOT3: 60, SLOT1: 40}, "single regular slot: failed ability 3 rolls use slot 1")
check(samples(SLOT3, SLOT1, third=False) == {SLOT1: 50, SLOT2: 50}, "unsupported ability 3 slot falls back to regular slots")
check(samples(SLOT2, SLOT3, second=False) == {SLOT1: 100}, "offspring without second slot always gets slot 1")
check(samples(0x0C, SLOT3) == {SLOT1: 80, SLOT2: 20}, "legacy unset slot normalizes to slot 1, ignoring caught-ball bits")


def generate(first_species, first_slot, first_male, second_species, second_slot, second_male):
    # Both mons are deposited. Same IDs are valid here; parent gender is kept
    # in the box-form PokerusStatus byte by the Day-Care.
    h.wr(h.s("wDayCareMan"), 1)
    h.wr(h.s("wDayCareLady"), 1)
    for number, species, slot, male in (
        (1, first_species, first_slot, first_male),
        (2, second_species, second_slot, second_male),
    ):
        h.wr(h.s(f"wBreedMon{number}Species"), h.species_id(constants.species_index(species)))
        h.wr(h.s(f"wBreedMon{number}Personality"), slot | 0x0C)
        h.wr(h.s(f"wBreedMon{number}PokerusStatus"), 0x40 if male else 0)
        h.wr(h.s(f"wBreedMon{number}Moves"), [0, 0, 0, 0])
        h.wr(h.s(f"wBreedMon{number}DVs"), [0xFF, 0xFF])
    # 200 passes the egg-step rejection loop; 0 selects inheritance.
    force_random("Random", 200)
    force_random("RandomRange", 0)
    h.call("DayCare_InitBreeding", max_frames=120)
    return h.species_index(h.rd(h.s("wEggMonSpecies"))), h.rd(h.s("wEggMonPersonality"))


print("[full egg creation chooses the correct ability parent]")
eevee = constants.species_index("EEVEE")
check(generate("EEVEE", SLOT3, False, "EEVEE", SLOT1, True) == (eevee, SLOT3), "female first parent passes ability 3 slot to Eevee egg")
check(generate("EEVEE", SLOT3, True, "EEVEE", SLOT2, False) == (eevee, SLOT2), "female second parent supplies slot; ability 3 father ignored")
check(generate("DITTO", SLOT3, False, "EEVEE", SLOT2, True) == (eevee, SLOT2), "Ditto first: male non-Ditto supplies ordinary slot")
check(generate("EEVEE", SLOT3, True, "DITTO", SLOT1, False) == (eevee, SLOT3), "Ditto second: male non-Ditto can pass ability 3 slot")
check(generate("BRELOOM", SLOT2, False, "BRELOOM", SLOT1, True) == (constants.species_index("SHROOMISH"), SLOT2), "expanded species evolves to different ability names while inheriting the slot")

print(f"Day-Care ability tests: {PASS} passed, {FAIL} failed ({h.calls} routine calls)")
h.pyboy.stop(save=False)
sys.exit(bool(FAIL))
