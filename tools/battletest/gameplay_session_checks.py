#!/usr/bin/env python3
"""Consecutive native wild battles with one persistent party and real menus.

Set up a legal party once, stage wild encounters, and exercise StartBattle,
map reload, healing, and save/load routines. This is an integration session,
not a complete story playthrough. No debug auto actions or party restoration.
"""

from pathlib import Path

from runner import Harness
from state import Request
from probability_checks import call
from cove_sprite_checks import native_call
from ui_checks import tile_text, wait


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()  # The sole emulator fixture reset for this whole session.
    pb, m = h.pb, h.battle.mem
    output = Path('.venv/gameplay-session')
    output.mkdir(parents=True, exist_ok=True)
    checks = failures = battles = 0

    def check(condition, name):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL SESSION ' + name, flush=True)

    party = [
        dict(species='WEEZING', level=60, ability='NEUTRALIZING_GAS', moves=['EXPLOSION', 'TACKLE', 'RAIN_DANCE', 'SPLASH']),
        dict(species='PORYGON', level=60, ability='TRACE', item='BERRY', hp=45, moves=['THUNDERBOLT', 'TACKLE', 'RECOVER', 'SPLASH']),
        dict(species='POLITOED', level=60, ability='DRIZZLE', item='LEFTOVERS', moves=['WATER_GUN', 'ICE_BEAM', 'RECOVER', 'SPLASH']),
    ]
    m.write('wPartyCount', 0)
    m.write('wMonType', 0)
    address = h.sym.addr('wDebugPlayer1')
    request = Request(h.battle)
    for slot, mon in enumerate(party):
        m.write_bytes('wDebugPlayer1', request._side_bytes(mon))
        call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
    for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wInBattleTowerBattle'):
        m.write(name, 0)
    m.write('wOptions', 0x41)  # Set, fast text, animations on.
    # Load a real overworld scene before/after battles.
    m.write('wDefaultSpawnpoint', 255)
    m.write('wMapGroup', 1)
    m.write('wMapNumber', 15)
    m.write('wXCoord', 32)
    m.write('wYCoord', 4)
    m.write('hMapEntryMethod', 0xF1)
    native_call(h, 'EnterMap')
    original_moves = [m.read_bytes(f'wPartyMon{i}Moves', 4) for i in range(1, 4)]
    original_personalities = [m.read_bytes(f'wPartyMon{i}Personality', 2) for i in range(1, 4)]
    selections = []
    menu_pending = False
    menu_wait = 0

    def fight_menu(_):
        nonlocal menu_pending, menu_wait
        menu_pending = True
        menu_wait = 0
        pb.button_release('a')

    bank, address = h.sym['BattleMenu']
    pb.hook_register(bank, address, fight_menu, None)

    def forced_party(_):
        selections[:] = [next(i for i in range(1, 4) if m.read_u16_be(f'wPartyMon{i}HP'))]

    bank, address = h.sym['SelectBattleMon']
    pb.hook_register(bank, address, forced_party, None)

    def pick_party(slot):
        pb.button_release('a')
        h.tick(20)
        for _ in range((slot - m.read('wMenuCursorY')) % 4):
            h.press('down', hold=8, wait=16)
        h.press('a', hold=8, wait=60)
        h.press('a', hold=8, wait=20)

    def save_reload(label):
        # Use the game's actual SRAM serialization and index-table reload.
        call(h, 'SavePokemonData')
        call(h, 'SaveIndexTables')
        size = h.sym.addr('wPokemonDataEnd') - h.sym.addr('wPokemonData')
        before = m.read_bytes('wPokemonData', size)
        m.write('wPartyMon2Item', h.con.item_id('FLOWER_MAIL'))
        call(h, 'LoadPokemonData')
        call(h, 'LoadIndexTables')
        check(m.read_bytes('wPokemonData', size) == before, label + ': exact saved Pokemon data restored')

    encounters = ['NINETALES', 'POLITOED', 'SNORLAX', 'ABOMASNOW',
                  'GYARADOS', 'NINETALES', 'POLITOED', 'SNORLAX']
    try:
        for index, species in enumerate(encounters):
            pp_before = [m.read_bytes(f'wPartyMon{i}PP', 4) for i in range(1, 4)]
            hp_before = [m.read_u16_be(f'wPartyMon{i}HP') for i in range(1, 4)]
            items_before = [m.read(f'wPartyMon{i}Item') for i in range(1, 4)]
            runtime_species = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index(species))
            m.write('wTempWildMonSpecies', runtime_species)
            m.write('wCurPartyLevel', 25)
            m.write('wOtherTrainerClass', 0)
            m.write('wBattleType', 0)
            h.text_overflows.clear()
            selections.clear()
            bank, address = h.sym['StartBattle']
            pb.memory[0x2000] = bank
            m.write('hROMBank', bank)
            pb.memory[0xFF70] = 1
            pb.memory[0xC0EC:0xC0EE] = [0xF0, 0xC0]
            pb.memory[0xC0F0:0xC0F3] = [0xF3, 0x18, 0xFE]
            pb.memory[0xC0F6:0xC0FA] = [0xFB, 0xC3, address & 255, address >> 8]
            pb.register_file.SP, pb.register_file.PC = 0xC0EC, 0xC0F6
            entered = switched = False
            menu_pending = False
            for frame in range(12000):
                if selections:
                    pick_party(selections.pop())
                elif menu_pending:
                    if 'FIGHT' not in tile_text(h):
                        menu_wait += 1
                        if menu_wait < 120:
                            h.tick(4)
                            continue
                        menu_pending = False
                        pb.button('a', 2)
                        h.tick(4)
                        continue
                    h.tick(60)  # Let menu drawing finish before button input.
                    if not entered:
                        entered = True
                        check(m.read('hDebugActive') == 0, f'battle {index + 1}: native menus')
                        active = m.read('wCurBattleMon')
                        entry_heal = 10 if items_before[active] == h.con.item_id('BERRY') and m.read(f'wPartyMon{active + 1}Item') == 0 else 0
                        # Account for the one native switch-in Berry activation.
                        check(h.battle.player.hp == hp_before[active] + entry_heal, f'battle {index + 1}: HP carries into battle')
                        h.pb.screen.image.save(str(output / f'battle-{index + 1}-entry.png'))
                    if index == 2 and not switched:
                        # Switch Porygon to Politoed through the actual menus.
                        pb.button_release('a')
                        h.press('right', hold=8, wait=20)
                        h.press('a', hold=8, wait=80)
                        wait(h, lambda: 'PORYGON' in tile_text(h))
                        pick_party(3)
                        wait(h, lambda: h.battle.player.species == 'POLITOED' and 'FIGHT' in tile_text(h), advance=True)
                        check(m.read('wBattleWeather') == 1, 'manual switch: Drizzle activates rain')
                        switched = True
                    menu_pending = False
                    h.press('a', hold=8, wait=80)
                    first_move = h.battle.player.moves[0].replace('_', ' ')
                    wait(h, lambda: first_move in tile_text(h))
                    h.press('a', hold=8, wait=20)
                else:
                    pb.button('a', 2)
                h.tick(4)
                if pb.register_file.PC in (0xC0F1, 0xC0F3):
                    break
            else:
                raise RuntimeError(f'battle {index + 1} timed out: menu={menu_pending}, ended={m.read("wBattleEnded")}, mode={m.read("wBattleMode")}, HP={h.battle.player.hp}/{h.battle.enemy.hp}, SP={pb.register_file.SP:04x}; {h.where()}')
            battles += 1
            check(entered, f'battle {index + 1}: native fight menu reached')
            check((m.read('wBattleResult') & 15) == 0, f'battle {index + 1}: win')
            check(m.read('wBattleMode') == 0, f'battle {index + 1}: exited battle')
            check(m.read('wInAbility') == 0, f'battle {index + 1}: banner cleanup')
            check(m.read('wSelfdestructGasTurn') == 0, f'battle {index + 1}: explosion cleanup')
            check(not h.text_overflows, f'battle {index + 1}: text bounds')
            check(m.read('wPartyCount') == 3, f'battle {index + 1}: party retained')
            check(any(m.read_bytes(f'wPartyMon{i}PP', 4) != pp_before[i - 1] for i in range(1, 4)), f'battle {index + 1}: PP usage persisted')
            for slot in range(1, 4):
                check(m.read_bytes(f'wPartyMon{slot}Moves', 4) == original_moves[slot - 1], f'battle {index + 1}: slot {slot} moves intact')
                check(m.read_bytes(f'wPartyMon{slot}Personality', 2) == original_personalities[slot - 1], f'battle {index + 1}: slot {slot} permanent ability intact')
                check(0 <= m.read_u16_be(f'wPartyMon{slot}HP') <= m.read_u16_be(f'wPartyMon{slot}MaxHP'), f'battle {index + 1}: slot {slot} HP bounds')
            if index == 0:
                check(m.read_u16_be('wPartyMon1HP') == 0, 'Gas user faint persists after Explosion')
            if index >= 1:
                check(m.read('wPartyMon2Item') == 0, 'consumed Berry remains consumed between battles')
            m.write('hMapEntryMethod', 0xF3)
            native_call(h, 'EnterMap')
            h.tick(60)
            h.pb.screen.image.save(str(output / f'battle-{index + 1}-overworld.png'))
            check(m.read('wMapGroup') == 1 and m.read('wMapNumber') == 15, 'overworld returns to same map')
            if index in (1, 5, 7):
                save_reload(f'after battle {index + 1}')
            if index == 3:
                native_call(h, 'HealParty')
                for slot in range(1, 4):
                    check(m.read_u16_be(f'wPartyMon{slot}HP') == m.read_u16_be(f'wPartyMon{slot}MaxHP'), 'healing restores HP')
                    check(m.read(f'wPartyMon{slot}Status') == 0, 'healing clears status')
                check(m.read('wPartyMon2Item') == 0, 'healing does not restore consumed Berry')
            print(f'PASS SESSION battle {index + 1} versus {species}; party retained', flush=True)
    except Exception as error:
        failures += 1
        print(f'ERROR SESSION {error}', flush=True)
        h.pb.screen.image.save(str(output / 'error.png'))
    print(f'{battles} consecutive native battles, {checks} checks, {failures} failures', flush=True)
    pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
