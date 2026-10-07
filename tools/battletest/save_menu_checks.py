#!/usr/bin/env python3
"""Save through the native start menu, reboot PyBoy, and use Continue.

The party/map are staged in private test SRAM. This exercises the save UI and
a fresh emulator boot, rather than substituting serialization routine calls.
It does not constitute an overworld story playthrough.
"""

from pathlib import Path

from pyboy import PyBoy

from cove_sprite_checks import native_call
from probability_checks import call
from runner import Harness
from state import Battle, Request
from ui_checks import tile_text


def begin_native_call(h, symbol):
    bank, address = h.sym[symbol]
    pb, m = h.pb, h.battle.mem
    if bank:
        pb.memory[0x2000] = bank
        m.write('hROMBank', bank)
    pb.memory[0xFF70] = 1
    pb.memory[0xC0EC:0xC0EE] = [0xF0, 0xC0]
    pb.memory[0xC0F0:0xC0F3] = [0xFB, 0x18, 0xFE]
    pb.memory[0xC0F6:0xC0FA] = [0xFB, 0xC3, address & 255, address >> 8]
    pb.register_file.SP, pb.register_file.PC = 0xC0EC, 0xC0F6


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    output = Path('.venv/save-menu')
    output.mkdir(parents=True, exist_ok=True)
    checks = failures = 0

    def check(condition, label):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL SAVE ' + label, flush=True)

    try:
        m = h.battle.mem
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        request = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        party = [dict(species='PORYGON', level=35, ability='TRACE', item='BERRY', hp=45,
                      moves=['TACKLE', 'RECOVER', 'SKILL_SWAP', 'SPLASH']),
                 dict(species='WEEZING', level=35, ability='NEUTRALIZING_GAS',
                      moves=['EXPLOSION', 'TACKLE', 'SPLASH']),
                 dict(species='APPLIN', level=35, ability='RIPEN', item='BERRY', moves=['SPLASH'])]
        for slot, mon in enumerate(party):
            m.write_bytes('wDebugPlayer1', request._side_bytes(mon))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        m.write('wPartyMon1PP', 17)
        for symbol in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wInBattleTowerBattle'):
            m.write(symbol, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wMapGroup', 1)
        m.write('wMapNumber', 15)
        m.write('wXCoord', 32)
        m.write('wYCoord', 4)
        m.write('hMapEntryMethod', 0xF1)
        native_call(h, 'EnterMap')
        size = h.sym.addr('wPokemonDataEnd') - h.sym.addr('wPokemonData')
        expected = m.read_bytes('wPokemonData', size)
        expected_party = [(m.read_u16_be(f'wPartyMon{i}HP'), m.read(f'wPartyMon{i}Item'),
                           m.read_bytes(f'wPartyMon{i}PP', 4), m.read_bytes(f'wPartyMon{i}Personality', 2))
                          for i in range(1, 4)]
        saved = []
        bank, address = h.sym['SavedTheGame']
        h.pb.hook_register(bank, address, lambda _: saved.append(True), None)
        begin_native_call(h, 'StartMenu')
        h.tick(90)
        for _ in range(12):
            if m.read('wMenuSelection') == 4:
                break
            h.press('down', hold=4, wait=20)
        check(m.read('wMenuSelection') == 4, 'native start menu selected SAVE')
        h.pb.screen.image.save(str(output / 'save-selected.png'))
        h.press('a', hold=6, wait=30)
        for _ in range(1800):
            h.pb.button('a', 2)
            h.tick(4)
            if saved and h.pb.register_file.PC in (0xC0F1, 0xC0F3):
                break
        else:
            raise RuntimeError('save menu did not finish: ' + tile_text(h))
        check(bool(saved), 'native Save menu reached SavedTheGame')
        check(m.read_bytes('wPokemonData', size) == expected, 'saving preserved exact Pokemon data')
        h.pb.screen.image.save(str(output / 'saved.png'))
        clean_rom = Path(h._rom_tempdir.name) / 'pokecrystal_debug.gbc'
        h.pb.stop(save=True)
        ram_files = list(Path(h._rom_tempdir.name).glob('*.ram'))
        check(len(ram_files) == 1 and ram_files[0].stat().st_size > 0, 'emulator persisted private SRAM')
        if failures:
            return 1

        # A new emulator reads its cartridge RAM from disk; no save-state load.
        h.pb = PyBoy(str(clean_rom), window='null', cgb=True, sound_emulated=False)
        h.pb.set_emulation_speed(0)
        h.pb.hook_register(0, 0x100, lambda _: None, None)
        h.battle = Battle(h.pb, h.sym, h.con)
        h.battle.textbox_contexts = set()
        h.text_context = None
        m = h.battle.mem
        continued = []
        bank, address = h.sym['MainMenu_Continue']
        h.pb.hook_register(bank, address, lambda _: continued.append(True), None)
        h.tick(400)
        for _ in range(80):
            if 'CONTINUE' in tile_text(h):
                break
            h.press('start', hold=4, wait=16)
            h.press('a', hold=4, wait=16)
        check('CONTINUE' in tile_text(h), 'fresh boot offers CONTINUE')
        # Let the main-menu fade/drawing finish before accepting Continue.
        h.pb.button_release('a')
        h.pb.button_release('start')
        h.tick(120)
        h.pb.screen.image.save(str(output / 'continue.png'))
        for _ in range(300):
            h.press('a', hold=8, wait=24)
            if continued and m.read('wPartyCount') == 3 and m.read_bytes('wPokemonData', size) == expected:
                break
        check(bool(continued), 'native CONTINUE was chosen')
        if not continued:
            print(f'Continue input diagnostic: {h.where()}; {h.control_state()}', flush=True)
        check(m.read_bytes('wPokemonData', size) == expected, 'fresh Continue restored exact Pokemon data')
        for i, (hp, item, pp, personality) in enumerate(expected_party, 1):
            check(m.read_u16_be(f'wPartyMon{i}HP') == hp, f'party {i}: HP')
            check(m.read(f'wPartyMon{i}Item') == item, f'party {i}: item')
            check(m.read_bytes(f'wPartyMon{i}PP', 4) == pp, f'party {i}: PP')
            check(m.read_bytes(f'wPartyMon{i}Personality', 2) == personality, f'party {i}: permanent ability/personality')
        for _ in range(300):
            if m.read('wMapStatus') == 2 and m.read('wMapGroup') == 1 and m.read('wMapNumber') == 15:
                break
            h.press('a', hold=4, wait=16)
        h.pb.button_release('a')
        h.tick(120)
        check(m.read('wMapStatus') == 2 and m.read('wMapGroup') == 1 and m.read('wMapNumber') == 15,
              'Continue returned to the saved overworld map')
        # Entering the map updates roaming bookkeeping inside PokemonData.
        # Every other saved byte must still match exactly.
        expected_map = bytearray(expected)
        for symbol, value in (('wRoamMons_CurMapNumber', 15), ('wRoamMons_CurMapGroup', 1)):
            expected_map[h.sym.addr(symbol) - h.sym.addr('wPokemonData')] = value
        check(m.read_bytes('wPokemonData', size) == bytes(expected_map),
              'overworld return preserved data except the expected roaming map update')
        positions = {(m.read('wXCoord'), m.read('wYCoord'))}
        for direction in ('left', 'up', 'right', 'down'):
            h.press(direction, hold=12, wait=36)
            positions.add((m.read('wXCoord'), m.read('wYCoord')))
        check(len(positions) > 1, 'native movement works after fresh Continue')
        party_size = h.sym.addr('wPartyMonNicknamesEnd') - h.sym.addr('wPokemonData')
        check(m.read_bytes('wPokemonData', party_size) == expected[:party_size],
              'native walking preserves exact party data')
        h.pb.screen.image.save(str(output / 'reloaded.png'))
    except Exception as error:
        failures += 1
        print(f'ERROR SAVE {error}', flush=True)
        h.pb.screen.image.save(str(output / 'error.png'))
    finally:
        h.pb.stop(save=False)
    print(f'{checks} save-menu/reboot checks, {failures} failures', flush=True)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
