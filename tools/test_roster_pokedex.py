#!/usr/bin/env python3
"""Exercise replacement Dex pointers and both native text pages, including bounds."""
import json
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    constants = Constants()
    roster = json.loads((root / 'tools/testdata/roster_replacements.json').read_text())['species']
    charmap = {text: int(value, 16) for text, value in re.findall(
        r'^\s*charmap "([^"\n]+)",\s*\$([0-9a-fA-F]+)', (root / 'charmap.asm').read_text(), re.M)}
    checks = 0
    pictures = [[], []]

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def encode(text):
        return bytes(charmap[c] for c in text)

    try:
        h.call('Pokedex_LoadGFX')
        for name, expected in roster.items():
            if name == 'AEGISLASH_BLADE':
                continue
            source = (root / f'data/pokemon/dex_entries/{name.lower()}.asm').read_text()
            category = re.search(r'db "([^"@]+)@"', source)[1]
            lines = re.findall(r'^\s*(?:db\s+|next\s+|page\s+)"([^"\n]*)"', source, re.M)[1:]
            lines = [line.rstrip('@') for line in lines]
            check(len(category) <= 10, name + ': category exceeds its ten-tile field')
            check(len(lines) == 6 and all(len(line) <= 18 for line in lines), name + ': two complete text pages fit')
            sid = h.species_id(constants.species_index(name))
            pointer = h.call('GetDexEntryPointer', bc=sid << 8)
            size = len(category) + 1
            raw = bytes(h.mem[pointer['b'], pointer['de']:pointer['de'] + size + 4])
            check(raw[:size] == encode(category + '@'), name + ': category pointer')
            check(int.from_bytes(raw[size:size+2], 'little') == expected['height'], name + ': compiled height')
            check(int.from_bytes(raw[size+2:size+4], 'little') == expected['weight_lbs_x10'], name + ': compiled weight')
            for field in ['wTempSpecies', 'wCurPartySpecies', 'wNamedObjectIndexBuffer']:
                h.wr(h.s(field), sid)
            h.wr(h.s('wPokedexCaught'), bytes([255] * 63))
            if '--render' in sys.argv:
                h.wr(h.s('wPokedexSeen'), bytes([255] * 63))
                h.wr(h.s('wDexListingScrollOffset'), [0, 0])
                h.wr(h.s('wDexListingCursor'), 0)
                bank, address = h.sym['wPokedexOrder']
                h.mem[0xff70] = bank
                h.wr16(address, constants.species_index(name))
                h.mem[0xff70] = 1
                h.wr(h.s('wCurSpecies'), sid)
                # Picture requests need VBlank; Harness.call deliberately
                # parks with interrupts disabled between isolated routines.
                bank, address = h.sym['Pokedex_LoadSelectedMonTiles']
                h.wr(0xc0fa, [0xfb, 0xcd, address & 255, address >> 8, 0xc9])
                h.sym.by_name['RosterDexPicture'] = (bank, 0xc0fa)
                h.call('RosterDexPicture')
            first_header = None
            for page in (0, 1):
                h.wr(h.s('wPokedexStatus'), page)
                h.call('Pokedex_DrawDexEntryScreenBG')
                before = h.rd(h.s('wTileMap'), 360)
                h.call('DisplayDexEntry')
                tiles = h.rd(h.s('wTileMap'), 360)
                if first_header is None:
                    first_header = tiles[:200]
                else:
                    check(tiles[:200] == first_header, name + ': name/category/measurements stable on page two')
                check(tiles[5*20+9:5*20+9+len(category)] == encode(category), name + ': visible category')
                check(tiles[6*20:6*20+9] == before[6*20:6*20+9], name + ': category must not wrap into next row')
                check(tiles[8*20+4:8*20+7] == encode(f"{expected['regional_dex']:03d}"), name + ': displayed regional number')
                for row, line in enumerate(lines[page*3:page*3+3]):
                    start = (11+row*2)*20+2
                    check(tiles[start:start+len(line)] == encode(line), name + f': page {page+1}, line {row+1}')
                if '--render' in sys.argv:
                    from PIL import Image
                    picture = Image.new('RGB', (160, 144))
                    colors = [(248, 248, 248), (168, 168, 168), (80, 80, 80), (8, 8, 8)]
                    for index, tile in enumerate(tiles):
                        address = 0x9000 + (tile if tile < 128 else tile-256)*16
                        data = bytes(h.mem[0, address:address+16])
                        for y in range(8):
                            for x in range(8):
                                shift = 7-x
                                color = ((data[y*2] >> shift) & 1) | (((data[y*2+1] >> shift) & 1) << 1)
                                picture.putpixel((index%20*8+x, index//20*8+y), colors[color])
                    pictures[page].append(('HISUIAN '+name if name in {'ZORUA', 'ZOROARK'} else name, picture))
        if '--render' in sys.argv:
            from PIL import Image, ImageDraw
            out = root / '_artifacts/roster'
            out.mkdir(parents=True, exist_ok=True)
            for page, entries in enumerate(pictures):
                sheet = Image.new('RGB', (960, 936), '#16202d')
                draw = ImageDraw.Draw(sheet)
                for index, (name, picture) in enumerate(entries):
                    x, y = index%3*320, index//3*312
                    draw.text((x+8, y+5), name, fill='white')
                    sheet.paste(picture.resize((320, 288), Image.Resampling.NEAREST), (x, y+22))
                sheet.save(out / f'dex-page-{page+1}.png')
        print(f'ROSTER DEX PASSED: {checks} native pointer/text/layout checks in {rom.name}', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
