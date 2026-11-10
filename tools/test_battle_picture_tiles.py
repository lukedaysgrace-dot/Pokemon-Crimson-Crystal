#!/usr/bin/env python3
"""Native picture uploads and every animation frame versus the source data.

Checks real and shared-form pointers, reserved HUD tiles, the $80 VRAM split,
and the largest animation. Only private emulator state is used.
"""
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
    h.mem[0xff40] = 0
    con = Constants()
    checks = 0

    def check(ok, label):
        nonlocal checks
        checks += 1
        assert ok, label

    def write(name, value): h.wr(h.s(name), value)
    def anim_write(name, value):
        bank, addr = h.sym[name]
        if isinstance(value, int): value = bytes([value])
        for i, byte in enumerate(value): h.mem[bank, addr+i] = byte
    def anim_read(name, size=1):
        bank, addr = h.sym[name]
        return bytes(h.mem[bank, addr:addr+size])
    def mapped(tile): return tile + (4 if tile >= 0x60 else 0)
    def address(tile): return (0x9000 if tile < 0x80 else 0x8000) + tile * 16

    hooked = h.sym['PokeAnim_GetFrame']
    # The frame routine is normally entered with the animation WRAM selected.
    h.pyboy.hook_register(*hooked, lambda _: setattr_bank(), None)
    def setattr_bank(): h.mem[0xff70] = h.sym.bank('wPokeAnimStruct')

    try:
        cases = [('ZANGOOSE', 'zangoose', 'Zangoose'),
                 ('ZANGOOSE_SCARRED', 'zangoose', 'Zangoose'),
                 ('SEVIPER', 'seviper', 'Seviper'),
                 ('MIENFOO', 'mienfoo', 'Mienfoo'), ('MIENSHAO', 'mienshao', 'Mienshao'),
                 ('HIPPOPOTAS', 'hippopotas', 'Hippopotas'), ('HIPPOWDON', 'hippowdon', 'Hippowdon'),
                 ('DUSKNOIR', 'dusknoir', 'Dusknoir'), ('FURRET', 'furret', 'Furret'),
                 ('FINIZEN', 'finizen', 'Finizen'),
                 ('BUTTERFREE', 'butterfree', 'Butterfree'),
                 # Gender appearance form: same species, its own graphics rows.
                 ('BUTTERFREE', 'butterfreef', 'ButterfreeFemale', 1)]
        for species, art, label, *female in cases:
            h.mem[h.s('hMonPicFemaleForm')] = female[0] if female else 0
            sid = h.species_id(con.species_index(species))
            write('wCurPartySpecies', sid)
            write('wCurSpecies', sid)
            write('wBoxAlignment', 0)
            source = (root / f'gfx/pokemon/{art}/front.animated.2bpp').read_bytes()
            side = (root / f'gfx/pokemon/{art}/front.dimensions').read_bytes()[0] & 15
            padding = 49 - side * side
            markers = bytes(range(64))
            for i, byte in enumerate(markers): h.mem[1, 0x9600+i] = byte
            h.call('GetAnimatedFrontpic', de=0x9000)
            check(bytes(h.mem[1, 0x9600:0x9640]) == markers, species + ': upload preserves HUD tiles')
            for original in range(side*side, len(source)//16):
                tile = mapped(original + padding)
                expected = source[original*16:(original+1)*16]
                dest = address(tile)
                check(bytes(h.mem[1, dest:dest+16]) == expected,
                      f'{species}: exact uploaded animation tile {original} at {tile:02x}')

            coordinate = h.s('wTileMap') + 12
            h.call('PokeAnim_InitPicAttributes', hl=coordinate)
            h.call('PokeAnim_InitAnim')
            expected_bank, expected_addr = h.sym[label + 'Bitmasks']
            check(anim_read('wPokeAnimBitmaskBank')[0] == expected_bank and
                  int.from_bytes(anim_read('wPokeAnimBitmaskAddr', 2), 'little') == expected_addr,
                  species + ': exact native bitmask pointer')
            frames = (root / f'gfx/pokemon/{art}/frames.asm').read_text()
            bodies = re.findall(r'^\.frame\d+\n(.*?)(?=^\.frame|\Z)', frames, re.M | re.S)
            masks = (root / f'gfx/pokemon/{art}/bitmask.asm').read_text()
            mask_data = [int(bits, 2) for bits in re.findall(r'^\s*db %([01]+)', masks, re.M)]
            mask_size = (side * side + 7) // 8
            for number, body in enumerate(bodies, 1):
                values = [int(v, 16) for v in re.findall(r'\$([0-9a-fA-F]+)',
                          '\n'.join(line.split(';')[0] for line in body.splitlines()))]
                bits = mask_data[values[0]*mask_size:(values[0]+1)*mask_size]
                expected = [[x*7+y for x in range(7)] for y in range(7)]
                changes = iter(values[1:])
                for x in range(side):
                    for y in range(side):
                        bit = x*side+y
                        if bits[bit//8] >> (bit%8) & 1:
                            original = next(changes)
                            if original >= side*side:
                                tile = original + padding
                            elif side == 7:
                                tile = original
                            else:
                                tile = (original//side)*7 + original%side + 14-side
                            expected[y+7-side][x+(0 if side == 7 else 1)] = mapped(tile)
                anim_write('wPokeAnimCommand', number)
                h.call('PokeAnim_GetFrame')
                actual = [[h.mem[coordinate+y*20+x] for x in range(7)] for y in range(7)]
                check(actual == expected, f'{species}: exact native animation frame {number}')
        print(f'BATTLE PICTURE TILES: {checks} checks passed in {rom.name}', flush=True)
    finally:
        h.pyboy.hook_deregister(*hooked)
        h.pyboy.stop(save=False)


if __name__ == '__main__': main()
