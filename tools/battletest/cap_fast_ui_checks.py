#!/usr/bin/env python3
"""Native trainer-card/options screenshots, cap tiers and saved preferences.

Boots release/debug ROMs with private SRAM; no player saves are accessed.
"""
import io
import json
from pathlib import Path

from PIL import Image, ImageDraw
from pyboy import PyBoy

from gameplay_rules_checks import new_game
from probability_checks import call
from runner import Harness, ROOT
from state import Battle
from symbols import _parse_constants
from ui_checks import tile_text, wait


CAPS = [10, 16, 20, 25, 30, 34, 38, 45, 50, 54, 58, 62, 62, 62, 66, 69, 100]


def run(rom):
    h = Harness(rom_path=rom)
    m = h.battle.mem
    out = ROOT / '.tmpbuild/cap-fast-ui' / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    status = _parse_constants(ROOT / 'constants/wram_constants.asm')
    hard_mask = 1 << status['STATUSFLAGS2_HARD_MODE_F']
    dex_mask = 1 << status['STATUSFLAGS_POKEDEX_F']
    captures, checks = {}, 0

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            h.pb.screen.image.save(out / 'failure.png')
            raise AssertionError(label + '\n' + tile_text(h))

    def row(number):
        raw = m.read_bytes('wTileMap', 20, 20 * number)
        return ''.join(chr(v - 0x80 + 65) if 0x80 <= v <= 0x99 else
                       str(v - 0xF6) if 0xF6 <= v <= 0xFF else ' ' for v in raw)

    def capture(name):
        image = h.pb.screen.image.convert('RGB')
        image.save(out / (name + '.png'))
        image.resize((480, 432), Image.Resampling.NEAREST).save(out / (name + '-large.png'))
        captures[name] = image

    def open_entry(entry):
        h.press('start', hold=4, wait=70)
        wait(h, lambda: 'SAVE' in tile_text(h))
        for _ in range(15):
            if m.read('wMenuSelection') == entry:
                break
            h.press('down', hold=4, wait=20)
        check(m.read('wMenuSelection') == entry, f'Start menu entry {entry}')
        h.press('a', hold=4, wait=100)

    def card():
        open_entry(3)
        wait(h, lambda: m.read('wJumptableIndex') == 1 and 'PLAY TIME' in tile_text(h))

    def close_card():
        h.press('b', hold=4, wait=100)
        wait(h, lambda: 'SAVE' in tile_text(h))
        h.press('b', hold=4, wait=70)

    try:
        new_game(h, 0, hard=True)
        check(m.read('wOptions') & 7 == 1, 'native New Game defaults to FAST')
        check(m.read('wStatusFlags2') & hard_mask != 0, 'native Hard Mode selected')
        # Include the ordinary Dex row in the screenshots; early access
        # without the Dex is tested separately below.
        m.write('wStatusFlags', m.read('wStatusFlags') | dex_mask)
        baseline = io.BytesIO()
        h.pb.save_state(baseline)

        def reset(count=0, hard=True, dex=True):
            baseline.seek(0)
            h.pb.load_state(baseline)
            h.text_overflows.clear()
            m.write('wJohtoBadges', (1 << min(count, 8)) - 1)
            m.write('wKantoBadges', (1 << max(count - 8, 0)) - 1)
            flags = m.read('wStatusFlags2')
            m.write('wStatusFlags2', (flags | hard_mask) if hard else (flags & ~hard_mask))
            flags = m.read('wStatusFlags')
            m.write('wStatusFlags', (flags | dex_mask) if dex else (flags & ~dex_mask))
            m.write('wLevelCap', 1)  # deliberately stale, like an old cached value

        for count, cap in enumerate(CAPS):
            reset(count)
            options = m.read('wOptions')
            identity = bytes(m.read_bytes('wMoney', 3) + m.read_bytes('wPlayerID', 2))
            card()
            check(row(14)[2:11] == 'LEVEL CAP', f'{count} badges: cap label')
            check(row(14)[15:18].strip() == str(cap), f'{count} badges: displayed {cap}')
            check(bytes(h.pb.memory[0, 0x9800 + 14 * 32 + 15:0x9800 + 14 * 32 + 18])
                  == m.read_bytes('wTileMap', 3, 14 * 20 + 15), f'{count} badges: cap reaches display VRAM')
            check(m.read('wLevelCap') == cap, f'{count} badges: refreshed actual cap')
            check('BADGES' in tile_text(h), f'{count} badges: badge-page hint retained')
            if count in (0, 7, 15, 16):
                capture(f'hard-{count}-badges-cap-{cap}')
            if count == 16:
                h.press('right', hold=4, wait=100)
                check(m.read('wJumptableIndex') == 3, 'Johto badge page accessible')
                capture('johto-badges')
                h.press('right', hold=4, wait=100)
                check(m.read('wJumptableIndex') == 5, 'Kanto badge page accessible')
                capture('kanto-badges')
                h.press('left', hold=4, wait=80)
                h.press('left', hold=4, wait=100)
                check(row(14)[15:18] == '100', 'returning to page one redraws cap')
            close_card()
            check(m.read('wOptions') == options, f'{count} badges: card restores text options')
            check(bytes(m.read_bytes('wMoney', 3) + m.read_bytes('wPlayerID', 2)) == identity,
                  f'{count} badges: money and ID unchanged')
            check(not h.text_overflows, f'{count} badges: text bounds')

        reset(hard=False)
        card()
        check('LEVEL CAP' not in tile_text(h), 'Normal Mode has no Hard cap row')
        capture('normal-mode-card')
        close_card()

        reset(dex=False)
        card()
        check(row(14)[15:18].strip() == '10', 'pre-Dex Hard card still shows cap')
        close_card()

        reset()
        open_entry(5)
        wait(h, lambda: 'TEXT SPEED' in tile_text(h))
        check('FAST' in tile_text(h) and m.read('wOptions') & 7 == 1, 'Options shows FAST default')
        capture('fast-default-options')
        # Choose a nondefault speed in the real options menu, then save,
        # cold boot and Continue: changing defaults must not replace it.
        h.press('right', hold=4, wait=30)
        h.press('right', hold=4, wait=30)
        check('SLOW' in tile_text(h) and m.read('wOptions') & 7 == 5, 'native SLOW selection')
        h.press('b', hold=4, wait=120)
        wait(h, lambda: 'SAVE' in tile_text(h))
        h.press('b', hold=4, wait=80)
        open_entry(4)
        saved = []
        h.pb.hook_register(*h.sym['SavedTheGame'], lambda _: saved.append(True), None)
        for _ in range(300):
            if saved:
                break
            h.press('a', hold=4, wait=20)
        check(bool(saved), 'saved through native menu')
        h.tick(80)
        private_rom = Path(h._rom_tempdir.name) / rom.name
        h.pb.stop(save=True)
        h.pb = PyBoy(str(private_rom), window='null', cgb=True, sound_emulated=False)
        h.pb.set_emulation_speed(0)
        h.pb.hook_register(0, 0x100, lambda _: None, None)
        h.battle = Battle(h.pb, h.sym, h.con)
        h.battle.textbox_contexts = set()
        m = h.battle.mem
        for _ in range(900):
            if 'CONTINUE' in tile_text(h):
                break
            h.press('start', hold=4, wait=12)
            h.press('a', hold=4, wait=20)
        check('CONTINUE' in tile_text(h), 'cold boot offers Continue')
        for _ in range(900):
            if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (24, 7, 2):
                break
            h.press('a', hold=4, wait=20)
        check(m.read('wMapStatus') == 2, 'native Continue reaches overworld')
        check(m.read('wOptions') & 7 == 5, 'saved SLOW preference survives FAST default')
        open_entry(5)
        wait(h, lambda: 'TEXT SPEED' in tile_text(h))
        check('SLOW' in tile_text(h), 'Options shows saved SLOW after Continue')
        capture('saved-slow-preserved')

        gallery_names = ['hard-0-badges-cap-10', 'hard-7-badges-cap-45', 'hard-15-badges-cap-69',
                         'hard-16-badges-cap-100', 'normal-mode-card', 'fast-default-options']
        labels = ['Hard / 0 badges', 'Hard / 7 badges', 'Hard / 15 badges',
                  'Hard / all 16 badges', 'Normal mode', 'New-game default']
        gallery = Image.new('RGB', (480, 332), '#eef0f2')
        draw = ImageDraw.Draw(gallery)
        for i, (name, label) in enumerate(zip(gallery_names, labels)):
            x, y = i % 3 * 160, i // 3 * 166
            draw.text((x + 3, y + 4), label, fill='#17212b')
            gallery.paste(captures[name], (x, y + 22))
        gallery.resize((960, 664), Image.Resampling.NEAREST).save(out / 'gallery.png')
        result = dict(rom=rom.name, checks=checks, screenshots=len(captures), failures=0)
        (out / 'results.json').write_text(json.dumps(result, indent=2) + '\n')
        print(json.dumps(result), flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    import sys
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        run(rom)
