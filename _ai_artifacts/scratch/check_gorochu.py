"""Exercise Gorochu's compiled game data, evolution decisions and PC storage."""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from pc_harness import Harness, SENTINEL, enc

h = Harness(str(ROOT / "pokecrystal.gbc"), str(ROOT / "pokecrystal.sym"))
h.boot()
checks = 0


def check(actual, expected, label):
    global checks
    assert actual == expected, f"{label}: {actual!r} != {expected!r}"
    checks += 1
    print(f"PASS: {label}")


species = re.findall(r"^\s*const\s+(\w+)", (ROOT / "constants/pokemon_constants.asm").read_text().split("NUM_POKEMON EQU", 1)[0], re.M)
gorochu = species.index("GOROCHU") + 1
sid = h.species_id(gorochu)
check(h.species_index(sid), gorochu, "16-bit species index round trip")
h.wr(h.s("wCurSpecies"), sid)
for rules in (0, 3):
    h.wr(h.s("wGameplayRules"), rules)
    h.call("GetBaseData")
    check(list(h.rd(h.s("wBaseStats"), 6)), [70, 90, 65, 115, 100, 100], f"stats in gameplay mode {rules}")
    check(list(h.rd(h.s("wBaseType1"), 2)), [23, 27], f"Electric/Dark typing in gameplay mode {rules}")
check(h.rd(h.s("wBaseCatchRate")), 45, "catch rate")
check(h.rd(h.s("wBaseExp")), 190, "base experience")
check(h.rd(h.s("wBasePicSize")), 0x77, "7x7 battle sprite dimensions")
for slot, ability_sym in ((0x20, "wBaseAbility1"), (0x40, "wBaseAbility2"), (0x60, "wBaseHiddenAbility")):
    expected = h.rd(h.s(ability_sym))
    check(h.call("GetAbility", bc=(slot << 8) | sid)["b"], expected, f"ability slot {slot:#x}")
h.wr(h.s("wNamedObjectIndexBuffer"), sid)
h.call("GetPokemonName")
check(h.rd(h.s("wStringBuffer1"), 10), enc("GOROCHU@@@"), "species name")
h.call("LoadCry", a=sid)
check(h.rd16(h.s("wCryPitch")), 0xe0, "Rage Blue cry pitch")
check(h.rd16(h.s("wCryLength")), 0x17f, "Rage Blue cry tempo conversion")
h.wr(h.s("wCurPartySpecies"), sid)
h.call("GetLowestEvolutionStage")
check(h.species_index(h.rd(h.s("wCurPartySpecies"))), species.index("PICHU") + 1, "breeding produces Pichu")

# FillMoves runs the game's actual move selection, including expanded move IDs.
move_names = re.findall(r"^\s*const\s+(\w+)", (ROOT / "constants/move_constants.asm").read_text(), re.M)
move_index = {name: i for i, name in enumerate(move_names)}
for level, expected in (
    (1, ["THUNDERSHOCK", "TAIL_WHIP", "QUICK_ATTACK"]),
    (38, ["THUNDERPUNCH", "FIRE_PUNCH", "CRUNCH", "EXTREMESPEED"]),
    (50, ["CRUNCH", "EXTREMESPEED", "THUNDER", "LIGHT_SCREEN"]),
):
    h.wr(h.s("wCurPartySpecies"), sid)
    h.wr(h.s("wCurPartyLevel"), level)
    h.wr(h.s("wEvolutionOldSpecies"), 0)
    h.wr(h.s("wTempMonMoves"), [0] * 4)
    h.call("FillMoves", de=h.s("wTempMonMoves"))
    actual = [h.move_index(m) for m in h.rd(h.s("wTempMonMoves"), 4) if m]
    check(actual, [move_index[m] for m in expected], f"generated moves at level {level}")

# Run the real evolution decision loop. Stop just before its animation/UI so
# threshold, force-evolution and Everstone behavior can be checked headlessly.
# This changes only PyBoy's in-memory ROM; the built .gbc stays untouched.
bank, proceed = h.sym["EvolveAfterBattle_MasterLoop.proceed"]
for i, value in enumerate([0xc3, SENTINEL & 0xff, SENTINEL >> 8]):
    h.mem[bank, proceed + i] = value


def evolution(source, level, item=0, forced=0, held=0):
    mon_id = h.species_id(species.index(source) + 1)
    h.wr(h.s("wPartyCount"), 1)
    h.wr(h.s("wPartySpecies"), [mon_id, 0xff])
    h.wr(h.s("wPartyMon1"), [0] * 50)
    h.wr(h.s("wPartyMon1Species"), mon_id)
    h.wr(h.s("wPartyMon1Level"), level)
    h.wr(h.s("wPartyMon1Item"), held)
    h.wr(h.s("wCurPartyMon"), 0)
    h.wr(h.s("wCurItem"), item)
    h.wr(h.s("wForceEvolution"), forced)
    h.wr(h.s("wLinkMode"), 0)
    h.wr(h.s("wBattleMode"), 1)
    result = h.call("EvolvePokemon")
    if h.reg.SP != 0xc0e4:
        return 0
    evo_bank = h.rd(h.s("hTemp"))
    ptr = result["hl"]
    return h.mem[evo_bank, ptr] | (h.mem[evo_bank, ptr + 1] << 8)


check(evolution("PIKACHU", 29), 0, "Pikachu stays Pikachu below level 30")
check(evolution("PIKACHU", 30), species.index("RAICHU") + 1, "Pikachu evolves at level 30")
check(evolution("PIKACHU", 31, held=0x70), 0, "Everstone blocks level evolution")
check(evolution("PIKACHU", 30, item=0x17, forced=1), 0, "Thunder Stone no longer evolves Pikachu")
check(evolution("PIKACHU", 20, item=0xa9, forced=1), species.index("RAICHU_ALOLAN") + 1, "Sun Stone retains Alolan Raichu branch")
check(evolution("RAICHU", 30), 0, "Raichu requires a stone")
check(evolution("RAICHU", 30, item=6, forced=1), gorochu, "Dusk Stone evolves Raichu to Gorochu")
check(evolution("RAICHU", 30, item=0x17, forced=1), 0, "wrong stone does not evolve Raichu")

# Decode the real ROM's frontpic through the engine used by the PC viewer.
h.wr(h.s("wCurPartySpecies"), sid)
h.call("PrepareFrontpicInScratch")
scratch_bank = h.sym.bank("wDecompressScratch")
h.mem[0xff70] = scratch_bank
front = bytes(h.mem[h.s("wDecompressScratch") + 0x800:h.s("wDecompressScratch") + 0x800 + 49 * 16])
check(front, (ROOT / "gfx/pokemon/gorochu/front.animated.2bpp").read_bytes()[:49 * 16], "engine decompresses correct Gorochu front sprite")
h.mem[0xff70] = 1

h.call("InitializeBoxes")
h.wr(h.s("wPartyCount"), 0)
h.wr(h.s("wPartySpecies"), 0xff)
h.build_temp_mon(gorochu, [move_index["CRUNCH"], move_index["EXTREMESPEED"], 0, 0], level=38, nick="GOROCHU@@@@")
h.call("AddTempMonToStorage")
check(h.call("SwapStorageBoxSlots", bc=0, de=0x0101)["a"], 0, "withdraw Gorochu from PC")
check(h.species_index(h.rd(h.s("wPartyMon1Species"))), gorochu, "PC preserves Gorochu's expanded species ID")

# Check both dex orderings and their cutoff when only an early species is seen.
for mode in (0, 1):
    seen_bank = h.sym.bank("wPokedexSeen")
    order_bank = h.sym.bank("wPokedexOrder")
    h.mem[0xff70] = seen_bank
    h.wr(h.s("wPokedexSeen"), [0xff] * ((len(species) + 7) // 8))
    h.wr(h.s("wCurDexMode"), mode)
    h.call("Pokedex_OrderMonsByMode")
    check(h.rd16(h.s("wDexListingEnd")), len(species), f"dex mode {mode} has all species")
    h.mem[0xff70] = order_bank
    order = [h.rd16(h.s("wPokedexOrder") + 2 * i) for i in range(len(species))]
    check(sorted(order), list(range(1, len(species) + 1)), f"dex mode {mode} includes every species once")
    check(order[order.index(26) + 1], gorochu, f"dex mode {mode} places Gorochu immediately after Raichu")
    for seen in (26, gorochu):
        h.mem[0xff70] = seen_bank
        h.wr(h.s("wPokedexSeen"), [0] * ((len(species) + 7) // 8))
        flag_addr = h.s("wPokedexSeen") + (seen - 1) // 8
        h.wr(flag_addr, 1 << ((seen - 1) % 8))
        h.call("Pokedex_OrderMonsByMode")
        check(h.rd16(h.s("wDexListingEnd")), order.index(seen) + 1, f"dex mode {mode} ends at the last seen displayed entry ({seen})")
    h.mem[0xff70] = seen_bank
    h.wr(h.s("wPokedexSeen"), [0] * ((len(species) + 7) // 8))
    h.call("Pokedex_OrderMonsByMode")
    check(h.rd16(h.s("wDexListingEnd")), 0, f"dex mode {mode} handles an empty dex")
h.mem[0xff70] = 1
check(h.call("GetRegionalDexNumber", hl=gorochu)["hl"], h.call("GetRegionalDexNumber", hl=26)["hl"] + 1, "displayed Gorochu dex number follows Raichu")

import json
website = json.loads((ROOT / "docs/data/pokemon.json").read_text())
website_species = [mon["const"] for mon in website]
check(website_species[website_species.index("RAICHU") + 1], "GOROCHU", "website dex puts Gorochu directly after Raichu")
web_gorochu = next(mon for mon in website if mon["const"] == "GOROCHU")
check(web_gorochu["number"], h.call("GetRegionalDexNumber", hl=gorochu)["hl"], "website and in-game Gorochu dex numbers agree")
check(web_gorochu["evolves_from"]["const"], "RAICHU", "website links Raichu as the pre-evolution")
assert "Dusk Stone" in web_gorochu["evolves_from"]["text"]
assert (ROOT / "docs/pokemon/gorochu.html").is_file()
print("PASS: generated Gorochu website page, sprite and Dusk Stone evolution")
print(f"GOROCHU CHECK PASSED: {checks} engine checks")
h.pyboy.stop(save=False)
