#!/usr/bin/env python3
"""Check native Dex navigation, registration and clean header tiles in both ROMs.

Only private emulator state is staged. Native routines and buttons render every
capture; party data and the player's save files are never modified.
"""
import io
import json
from pathlib import Path

from PIL import Image

from runner import Harness, ROOT
from gameplay_rules_checks import new_game
from probability_checks import call
from save_menu_checks import begin_native_call
from ui_checks import tile_text


def run(rom):
    h = Harness(rom_path=rom)
    pb, m = h.pb, h.battle.mem
    output = ROOT / '_artifacts/dex-ui' / rom.stem
    output.mkdir(parents=True, exist_ok=True)
    checks, captures = [], []

    def check(condition, label):
        assert condition, f'{rom.name}: {label}\n{tile_text(h)}'
        checks.append(label)

    def wait_for(predicate, label):
        for _ in range(600):
            if predicate():
                h.tick(30)
                return
            h.tick(4)
        raise AssertionError(f'{rom.name}: timeout: {label}: PC={pb.register_file.PC:04x} '
                             f'SP={pb.register_file.SP:04x}: {h.where()}\n{tile_text(h)}')

    def capture(label):
        pb.screen.image.save(output / (label + '.png'))
        captures.append(label)

    def header(label):
        tiles = m.read_bytes('wTileMap', 360)
        for row in (1, 2):
            for column in (18, 19):
                offset = row * 20 + column
                check(tiles[offset] == 0x7f, f'{label}: clear header ({column},{row})')
                # Verify the actual uploaded BG map as well as its WRAM source.
                base = 0x9c00 if pb.memory[0xff40] & 8 else 0x9800
                check(pb.memory[0, base + row * 32 + column] == 0x7f,
                      f'{label}: visible header ({column},{row})')
        check('HT' in tile_text(h) and 'WT' in tile_text(h), label + ': measurements present')
        check(all(pb.memory[0xfe00 + i * 4] == 0 or pb.memory[0xfe00 + i * 4] >= 160
                  for i in range(40)), label + ': no stray hardware sprites')
        return tiles[:200]

    def press(button, delay=100):
        h.press(button, hold=4, wait=delay)

    def returned():
        # A frame can end inside the audio ISR after the routine returned.
        # Its outer interrupt return address still proves the native caller
        # reached our sentinel; begin_native_call resets this slot each time.
        interrupted_pc = pb.memory[0xc0ec] | pb.memory[0xc0ed] << 8
        return pb.register_file.PC in (0xc0f1, 0xc0f3) or interrupted_pc in (0xc0f1, 0xc0f3)

    def party():
        length = h.sym.addr('wPartyMonNicknamesEnd') - h.sym.addr('wPartyCount')
        return m.read_bytes('wPartyCount', length)

    try:
        new_game(h, 0)
        # A real party makes data-preservation checks meaningful.
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('TOTODILE'))
        for key, value in dict(wPartyCount=0, wMonType=0, wCurPartySpecies=sid,
                               wCurPartyLevel=20).items():
            m.write(key, value)
        call(h, 'TryAddMonToParty')
        m.write_bytes('wPokedexSeen', bytes([255] * 63))
        m.write_bytes('wPokedexCaught', bytes([255] * 63))
        m.write('wStatusFlags', m.read('wStatusFlags') | 1)
        # Isolated calls abandon the map loader's stack; finish its temporary
        # OAM suppression before handing control to a native menu.
        m.write('hOAMUpdate', 0)
        baseline = io.BytesIO()
        pb.save_state(baseline)

        # Old/new/alphabetical ordering, original and appended species, and
        # indexes across the 8-bit boundary all enter through the native list.
        cases = [('BULBASAUR', 1), ('PIKACHU', 1), ('MEW', 1),
                 ('MIENSHAO', 2), ('HIPPOWDON', 0)]
        for name, mode in cases:
            baseline.seek(0)
            pb.load_state(baseline)
            expected_party = party()
            m.write('wLastDexMode', mode)
            m.write_bytes('wPrevDexEntry', h.con.species_index(name).to_bytes(2, 'little'))
            begin_native_call(h, 'StartMenu')
            wait_for(lambda: 'SAVE' in tile_text(h), name + ' start menu')
            for _ in range(12):
                if m.read('wMenuSelection') == 0:
                    break
                press('down', 20)
            check(m.read('wMenuSelection') == 0, name + ': Dex selected from Start menu')
            press('a', 150)
            wait_for(lambda: m.read('wJumptableIndex') == 1, name + ' listing')
            press('a')
            wait_for(lambda: m.read('wJumptableIndex') == 3, name + ' entry cry finishes')
            check(m.read('wJumptableIndex') == 3, name + ': entry opens')
            check(m.species_index_of(m.read('wCurPartySpecies')) == h.con.species_index(name),
                  name + ': correct species selected')
            first = header(name + ' page 1')
            capture(name.lower() + '-page-1')
            press('a')
            check(m.read('wPokedexStatus') == 1, name + ': PAGE opens second text page')
            check(header(name + ' page 2') == first, name + ': header stable on second page')
            capture(name.lower() + '-page-2')
            press('a')
            check(m.read('wPokedexStatus') == 0, name + ': PAGE returns to first page')
            press('right')  # AREA
            press('a')
            capture(name.lower() + '-area')
            press('b', 160)
            check(m.read('wJumptableIndex') == 3, name + ': AREA returns to entry')
            check(header(name + ' area return') == first, name + ': AREA restores header')
            press('right')  # CRY
            press('a', 180)
            check(header(name + ' cry') == first, name + ': CRY preserves header')
            if name == 'PIKACHU':
                press('right')  # PRNT
                press('a', 180)
                capture('printer-disconnected')
                for _ in range(12):
                    press('b', 120)
                    if m.read('wJumptableIndex') == 3 and 'HT' in tile_text(h):
                        break
                check(m.read('wJumptableIndex') == 3, 'printer cancel returns to entry')
                check(header('printer return') == first, 'printer cancel restores header')
                capture('printer-return')
            press('down', 160)
            wait_for(lambda: m.read('wJumptableIndex') == 3, name + ' next species cry finishes')
            check(m.read('wJumptableIndex') == 3, name + ': next species opens')
            header(name + ' next species')
            press('up', 160)
            wait_for(lambda: m.read('wJumptableIndex') == 3, name + ' previous species cry finishes')
            check(header(name + ' previous species') == first, name + ': previous species restored')
            press('b')
            check(m.read('wJumptableIndex') == 1, name + ': entry returns to list')
            press('b')
            wait_for(lambda: 'SAVE' in tile_text(h), name + ' return to Start menu')
            press('b')
            wait_for(returned, name + ' exit')
            check(party() == expected_party, name + ': party preserved exactly')
            begin_native_call(h, 'OverworldLoop.loop')
            h.tick(120)
            check(m.read('wMapStatus') == 2, name + ': overworld resumes after Dex')
            capture(name.lower() + '-overworld-return')

        # The registration flow has a separate entry point and two text pages.
        baseline.seek(0)
        pb.load_state(baseline)
        expected_party = party()
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('HIPPOWDON'))
        m.write('wTempSpecies', sid)
        m.write('wBattleMode', 1)
        m.write('wEnemySubStatus5', 0)
        begin_native_call(h, 'FadeToMenu')
        wait_for(returned, 'registration screen preparation')
        begin_native_call(h, 'NewPokedexEntry')
        wait_for(lambda: 'HT' in tile_text(h) and 'WT' in tile_text(h), 'registration page 1')
        h.tick(180)
        first = header('registration page 1')
        capture('registration-page-1')
        press('a')
        check(m.read('wPokedexStatus') == 1, 'registration advances to second page')
        check(header('registration page 2') == first, 'registration header stable')
        capture('registration-page-2')
        press('a')
        wait_for(returned, 'registration exit')
        check(party() == expected_party, 'registration preserves party')

        (output / 'results.json').write_text(json.dumps(dict(
            rom=rom.name, checks=len(checks), passed=checks, captures=captures), indent=2) + '\n')
        # Enlarged preview is the actual rendered emulator frame with nearest
        # neighbor scaling, not a reconstruction from extracted game assets.
        with Image.open(output / 'pikachu-page-1.png') as image:
            image.resize((640, 576), Image.Resampling.NEAREST).save(output / 'preview.png')
        print(f'DEX UI PASSED: {len(checks)} checks in {rom.name}', flush=True)
    except Exception:
        capture('failure')
        raise
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    import sys
    for rom in ([Path(sys.argv[1])] if len(sys.argv) > 1 else
                [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']):
        run(rom)
