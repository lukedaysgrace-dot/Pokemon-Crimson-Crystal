#!/usr/bin/env python3
"""Use native party/move menus with button input, without player saves."""
from io import BytesIO
from pathlib import Path
import sys

from pc_harness import Harness, enc, dec
from battletest.symbols import Constants, _parse_constants

ROOT = Path(__file__).resolve().parents[1]


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    baseline = BytesIO()
    h.pyboy.save_state(baseline)
    con = Constants()
    engine_flags = _parse_constants(ROOT / 'constants/engine_flags.asm')
    output = ROOT / '.tmpbuild/qol-consumables-ui' / rom.stem
    output.mkdir(parents=True, exist_ok=True)
    checks = 0

    def write(name, value):
        h.wr(h.s(name), value)

    def quantity():
        return sum(h.rd(h.s('wItems') + 2 * i + 1) for i in range(h.rd(h.s('wNumItems')))
                   if h.rd(h.s('wItems') + 2 * i) == h.rd(h.s('wCurItem')))

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    try:
        for name, item, amount, species, level, hp, cancel in [
            ('potions', 'POTION', 2, 'MEW', 20, 1, False),
            ('cancel-after-one', 'POTION', 3, 'MEW', 20, 1, True),
            ('full-hp', 'POTION', 3, 'MEW', 20, 200, False),
            ('vitamins', 'PROTEIN', 2, 'MEW', 20, 100, False),
            ('pp-ups', 'PP_UP', 3, 'MEW', 20, 100, False),
            ('pp-max', 'PP_MAX', 1, 'MEW', 20, 100, False),
            ('candies', 'RARE_CANDY', 2, 'MAGIKARP', 10, 20, False),
            ('hard-cap', 'RARE_CANDY', 3, 'MAGIKARP', 9, 20, False),
            ('before-blue-cap', 'RARE_CANDY', 3, 'MAGIKARP', 68, 20, False),
            ('after-blue-candies', 'RARE_CANDY', 2, 'MAGIKARP', 73, 20, False),
            ('after-blue-high', 'RARE_CANDY', 2, 'MAGIKARP', 90, 20, False),
        ]:
            baseline.seek(0)
            h.pyboy.load_state(baseline)
            info = h.build_temp_mon(con.species_index(species), [con.move_index('TACKLE'), 0, 0, 0],
                                    level=level, statexp=[0] * 10, happiness=100)
            write('wPartyCount', 1)
            write('wPartySpecies', [info['sid'], 255])
            write('wPartyMon1', h.rd(h.s('wTempMon'), 50))
            write('wPartyMonNicknames', enc('TESTMON@@@@'))
            write('wPartyMon1HP', [hp >> 8, hp & 255])
            write('wPartyMon1MaxHP', [0, 200])
            write('wPartyMenuCursor', 1)
            write('wNumItems', [1, con.item_id(item), amount, 255])
            write('wCurItem', con.item_id(item))
            write('wCurItemQuantity', 0)
            write('wBattleMode', 0)
            write('wLinkMode', 0)
            write('wOptions', 1)
            write('wTextboxFlags', 1)
            write('wTextboxFrame', 0)
            # Direct calls begin from a private boot state, before the normal
            # overworld has loaded its alphabet into VRAM.
            h.call('LoadStandardFont')
            h.call('LoadFontsExtra')
            if name in ('hard-cap', 'before-blue-cap', 'after-blue-candies', 'after-blue-high'):
                write('wJohtoBadges', 0 if name == 'hard-cap' else 255)
                write('wKantoBadges', 0 if name == 'hard-cap' else 127 if name == 'before-blue-cap' else 255)
                write('wStatusFlags', 0)
                h.call('EngineFlagAction', bc=1 << 8, de=engine_flags['ENGINE_HARD_MODE'])
            menus = []

            def at_picker(_):
                row = h.rd(h.s('wTileMap') + 15 * 20 + 1, 18)
                menus.append((quantity(), row))

            h.pyboy.hook_register(*h.sym['PartyMenuSelect'], at_picker, None)
            bank, address = h.sym['UsePartyItemRepeatedly']
            h.set_rom_bank(bank)
            h.wr(0xC0EC, [0xF0, 0xC0])
            h.wr(0xC0F0, [0xF3, 0x18, 0xFE])
            h.wr(0xC0F6, [0xFB, 0xC3, address & 255, address >> 8])
            h.reg.SP, h.reg.PC = 0xC0EC, 0xC0F6
            observed_menus, capture_at = 0, -1
            try:
                for frame in range(3600):
                    if frame % 16 == 0 and not frame <= capture_at:
                        h.pyboy.button('b' if cancel and len(menus) > 1 else 'a', 2)
                    h.pyboy.tick(1, True)
                    if len(menus) > observed_menus:
                        observed_menus, capture_at = len(menus), frame + 3
                    if frame == capture_at:
                        h.pyboy.screen.image.save(output / f'{name}-picker-{observed_menus}.png')
                    if h.reg.PC in (0xC0F1, 0xC0F3):
                        break
                else:
                    tilemap = h.rd(h.s('wTileMap'), 360)
                    text = '\n'.join(dec(tilemap[i:i + 20]) for i in range(0, 360, 20))
                    raise RuntimeError(f'{name} did not return; menus={menus}, PC={h.reg.PC:04x}\n{text}')
            finally:
                h.pyboy.hook_deregister(*h.sym['PartyMenuSelect'])
            capped = name in ('hard-cap', 'before-blue-cap')
            expected_menus = 2 if cancel or capped else (1 if name == 'full-hp' else amount)
            check(len(menus) == expected_menus, f'{name}: expected {expected_menus} pickers, got {menus}')
            check([qty for qty, _ in menus] == list(range(amount, amount - expected_menus, -1)), f'{name}: picker counts')
            for qty, row in menus:
                check(enc(str(qty)) in row and 0xF1 in row, f'{name}: visible remaining count missing: {dec(row)}')
            check(quantity() == (amount - 1 if cancel or capped else amount if name == 'full-hp' else 0), f'{name}: wrong consumption')
            if name == 'potions':
                check(h.rd(h.s('wPartyMon1HP'), 2) == bytes([0, 41]), 'native repeated Potion healing')
            elif name == 'vitamins':
                check(h.rd(h.s('wPartyMon1AtkExp')) == 20, 'native repeated vitamins')
            elif name in ('pp-ups', 'pp-max'):
                check(h.rd(h.s('wPartyMon1PP')) >> 6 == 3, 'native repeated PP Ups')
            elif name in ('candies', 'after-blue-candies', 'after-blue-high'):
                check(h.rd(h.s('wPartyMon1Level')) == level + amount, 'native repeated Rare Candies')
            elif name == 'hard-cap':
                check(h.rd(h.s('wPartyMon1Level')) == 10, 'repeated Rare Candies bypassed Hard cap')
            elif name == 'before-blue-cap':
                check(h.rd(h.s('wPartyMon1Level')) == 69, 'Rare Candies bypassed Blue\'s pre-battle cap')
            print(f'{name}: native menus passed ({len(menus)} party selections).', flush=True)
        print(f'CONSUMABLE UI TESTS PASSED: {checks} checks.', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
