#!/usr/bin/env python3
"""Test Tower battle/restore paths and entry rules in the real ROM.

The seven wins use overleveled fixtures to exercise the battle wrapper,
not the room's level-selection UI or reward script. The loss uses normal
button input, including forced party selection after fainting.
"""

import io
from pathlib import Path

from probability_checks import call
from runner import Harness
from state import Request


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    m, pb = h.battle.mem, h.pb
    initial = io.BytesIO()
    pb.save_state(initial)
    checks = errors = battles = 0
    pending_selection = []
    output = Path(".venv/tower-battles")
    output.mkdir(parents=True, exist_ok=True)

    def check(condition, description):
        nonlocal checks, errors
        checks += 1
        if not condition:
            errors += 1
            print("FAIL " + description)

    def sram_write(symbol, values):
        bank, address = h.sym[symbol]
        pb.memory[0] = 10
        pb.memory[0x4000] = bank
        pb.memory[address:address + len(values)] = values
        pb.memory[0] = 0

    def prepare(species, level, move):
        initial.seek(0)
        pb.load_state(initial)
        m.write("wPartyCount", 0)
        m.write("wMonType", 0)
        address = h.sym.addr("wDebugPlayer1")
        request = Request(h.battle)
        for slot, mon in enumerate(species):
            m.write_bytes("wDebugPlayer1", request._side_bytes(
                {"species": mon, "level": level, "moves": [move]}))
            call(h, "DebugBuildPartyMon", B=slot, D=address >> 8, E=address & 255)
        # Tower legitimately reloads the saved party after each battle.
        # Its frontend saves these data before starting a challenge.
        call(h, "SavePokemonData")
        call(h, "SaveIndexTables")
        m.write("wDebugState", 0)
        m.write("hDebugActive", 0)
        m.write("hDebugRNGMode", 0)
        m.write("wOptions", 0)  # animations on; wrapper temporarily forces Set
        m.write("wBTChoiceOfLvlGroup", 1)
        sram_write("sBTTrainers", [255] * 7)
        sram_write("sBTMonOfTrainers", [255] * 12)
        sram_write("sNrOfBeatenBattleTowerTrainers", [0])
        size = h.sym.addr("wPartyMon2Species") - h.sym.addr("wPartyMon1Species")
        return m.read_bytes("wPartyMon1Species", size * 3)

    def party_selection(_):
        # Observe the native menu entry, then select a fit mon with buttons.
        for slot in range(1, 4):
            if m.read_u16_be(f"wPartyMon{slot}HP"):
                pending_selection[:] = [slot]
                break

    bank, address = h.sym["SelectBattleMon"]
    pb.hook_register(bank, address, party_selection, None)

    def battle(name, expected_result, original):
        nonlocal battles
        pending_selection.clear()
        h.text_overflows.clear()
        m.write("wBattleTowerBattleEnded", 0)
        call(h, "Function_LoadOpponentTrainerAndPokemons")
        bank, address = h.sym["RunBattleTowerTrainer"]
        pb.memory[0x2000] = bank
        m.write("hROMBank", bank)
        # Enable interrupts for normal animation/menu frame waits, then call.
        pb.memory[0xC0EC:0xC0EE] = [0xF0, 0xC0]
        pb.memory[0xC0F0:0xC0F3] = [0xF3, 0x18, 0xFE]
        pb.memory[0xC0F6:0xC0FA] = [0xFB, 0xC3, address & 255, address >> 8]
        pb.register_file.SP, pb.register_file.PC = 0xC0EC, 0xC0F6
        returned = False
        for _ in range(12000):
            if pending_selection:
                desired = pending_selection.pop()
                pb.button_release("a")
                h.tick(20)
                for _ in range((desired - m.read("wMenuCursorY")) % 4):
                    h.press("down", hold=8, wait=16)
                h.press("a", hold=8, wait=20)
            else:
                pb.button("a", 2)
                h.tick(4)
            if pb.register_file.PC in (0xC0F1, 0xC0F3):
                returned = True
                break
        check(returned, name + ": wrapper returned")
        if not returned:
            raise RuntimeError(f"Tower battle timed out: {h.where()}")
        check(m.read("wBattleResult") == expected_result, name + ": battle result")
        check(m.read("wBattleTowerBattleEnded") == 1, name + ": ended flag")
        check(m.read("wInBattleTowerBattle") == 0, name + ": Tower mode restored")
        check(m.read("wOptions") == 0, name + ": battle style restored")
        check(m.read("wPartyCount") == 3, name + ": party count restored")
        check(m.read_bytes("wPartyMon1Species", len(original)) == original,
              name + ": saved species/items/moves/PP/personality/stats restored")
        check(m.read("wSelfdestructGasTurn") == 0, name + ": no pending explosion")
        check(not h.text_overflows, name + ": textbox bounds")
        for slot in range(1, 4):
            check(m.read_u16_be(f"wPartyMon{slot}HP") == m.read_u16_be(f"wPartyMon{slot}MaxHP"),
                  name + f": slot {slot} fully healed")
        pb.screen.image.save(str(output / (name.replace(" ", "-") + ".png")))
        battles += 1
        print("CHECK " + name)

    original = prepare(("DRAGONITE", "GYARADOS", "LUGIA"), 100, "AERIAL_ACE")
    prepared_party = io.BytesIO()
    pb.save_state(prepared_party)
    rule_cases = [
        ("three party members", "Function_PartyCountEq3", {}, False),
        ("two party members", "Function_PartyCountEq3", {"wPartyCount": 2}, True),
        ("unique species", "Function_PartySpeciesAreUnique", {}, False),
        ("duplicate species", "Function_PartySpeciesAreUnique",
         {"wPartyMon2Species": m.read("wPartyMon1Species")}, True),
        ("repeated empty item slots", "Function_PartyItemsAreUnique", {}, False),
        ("duplicate held items", "Function_PartyItemsAreUnique",
         {"wPartyMon1Item": h.con.item_id("BERRY"), "wPartyMon2Item": h.con.item_id("BERRY")}, True),
        ("no eggs", "Function_HasPartyAnEgg", {}, False),
        ("egg in party", "Function_HasPartyAnEgg", {"wPartySpecies": (1, 253)}, True),
    ]
    for name, symbol, changes, carry in rule_cases:
        prepared_party.seek(0)
        pb.load_state(prepared_party)
        for field, value in changes.items():
            if isinstance(value, tuple):
                m.write(field, value[1], value[0])
            else:
                m.write(field, value)
        call(h, symbol)
        check(bool(pb.register_file.F & 16) == carry, "entry rule: " + name)
    prepared_party.seek(0)
    pb.load_state(prepared_party)
    for opponent in range(7):
        sram_write("sNrOfBeatenBattleTowerTrainers", [opponent])
        battle(f"Tower win {opponent + 1}", 0, original)

    original = prepare(("MAGIKARP", "WEEDLE", "CATERPIE"), 5, "SPLASH")
    m.write("wBTChoiceOfLvlGroup", 10)
    battle("Tower loss", 1, original)
    print(f"{battles} Tower battles, {checks} checks, {errors} failures")
    pb.stop(save=False)
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
