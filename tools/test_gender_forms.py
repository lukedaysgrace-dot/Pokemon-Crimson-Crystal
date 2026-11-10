#!/usr/bin/env python3
"""Native checks for gender appearance forms (female Butterfree).

A female BUTTERFREE keeps the BUTTERFREE species everywhere; only its front
and back pictures, animation rows and palette rows change. This checks:

- GetUnownLetter reads the gender flag from every DV source the game passes
  (party/OT/wTempMon layouts, enemy, battle mon, wild backup, both trade mons)
- front/back picture uploads match the female or male source art exactly
- animation, idle, frame and bitmask rows resolve to the female form only for
  female Butterfree, never for other species with the same flag
- normal/shiny, front/back and enemy/player palettes pick the right rows

Only private emulator state is used.
"""
from pathlib import Path
import re
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants

MALE, FEMALE, SHINY = 0x40, 0x00, 0x80


def gbcpal_middle(path):
    data = Path(path).read_bytes()
    return data[2:6]


def pal_file(path):
    out = bytearray()
    for r, g, b in re.findall(r'RGB\s+(\d+),\s*(\d+),\s*(\d+)', Path(path).read_text()):
        value = int(r) | int(g) << 5 | int(b) << 10
        out += value.to_bytes(2, 'little')
    return bytes(out)


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    h.mem[0xff40] = 0  # LCD off: VRAM uploads land immediately
    con = Constants()
    checks = 0

    def check(ok, label):
        nonlocal checks
        checks += 1
        assert ok, label

    s = h.s
    flag = lambda: h.mem[s('hMonPicFemaleForm')]
    struct_length = s('wPartyMon2') - s('wPartyMon1')
    butterfree = h.species_id(con.species_index('BUTTERFREE'))
    caterpie = h.species_id(con.species_index('CATERPIE'))
    h.build_temp_mon(con.species_index('BUTTERFREE'), [0, 0, 0, 0], shiny_gender=MALE)

    # --- gender flag from every DV source ---------------------------------
    def letter(hl):
        h.mem[s('hMonPicFemaleForm')] = 0x55  # poison: must be rewritten
        h.call('GetUnownLetter', hl=hl)
        return flag()

    for flags, female in ((MALE, 0), (FEMALE, 1), (MALE | SHINY, 0), (FEMALE | SHINY, 1)):
        name = ('female' if female else 'male') + (' shiny' if flags & SHINY else '')
        h.wr(s('wTempMonUnused'), flags)
        check(letter(s('wTempMonDVs')) == female, f'wTempMon {name}')
        h.wr(s('wPartyMon1Unused') + 3 * struct_length, flags)
        check(letter(s('wPartyMon1DVs') + 3 * struct_length) == female, f'party slot 4 {name}')
        h.wr(s('wOTPartyMon1Unused') + 2 * struct_length, flags)
        check(letter(s('wOTPartyMon1DVs') + 2 * struct_length) == female, f'OT party slot 3 {name}')
        h.wr(s('wEnemyMonShinyGenderFlags'), flags)
        check(letter(s('wEnemyMonDVs')) == female, f'enemy {name}')
        check(letter(s('wEnemyBackupDVs')) == female, f'wild backup DVs {name}')
        h.wr(s('wCurBattleMon'), 4)
        h.wr(s('wPartyMon1Unused') + 4 * struct_length, flags)
        h.wr(s('wPartyMon1Unused'), flags ^ MALE)  # a different slot must not leak in
        check(letter(s('wBattleMonDVs')) == female, f'battle mon (slot 5) {name}')
        h.wr(s('wPlayerTrademonShinyGender'), flags)
        check(letter(s('wPlayerTrademonDVs')) == female, f'player trademon {name}')
        h.wr(s('wOTTrademonShinyGender'), flags)
        check(letter(s('wOTTrademonDVs')) == female, f'OT trademon {name}')

    # GetUnownLetter still computes the same letter as before.
    h.wr(s('wTempMonDVs'), [0x5a, 0xc3])
    h.wr(s('wTempMonUnused'), FEMALE)
    h.call('GetUnownLetter', hl=s('wTempMonDVs'))
    atk, defense, spd, spc = 0x5, 0xa, 0xc, 0x3
    raw = ((atk >> 1 & 3) << 6) | ((defense >> 1 & 3) << 4) | ((spd >> 1 & 3) << 2) | (spc >> 1 & 3)
    check(h.mem[s('wUnownLetter')] == raw // (0xff // 26 + 1) + 1, 'Unown letter unchanged')
    h.wr(s('wTempMonDVs'), [0xff, 0xff])

    # --- pictures ---------------------------------------------------------
    def pics(species, flags):
        h.wr(s('wTempMonUnused'), flags)
        h.call('GetUnownLetter', hl=s('wTempMonDVs'))
        h.wr(s('wCurPartySpecies'), species)
        h.wr(s('wCurSpecies'), species)
        h.wr(s('wBoxAlignment'), 0)
        h.mem[0xff4f] = 0
        h.call('GetMonFrontpic', de=0x9000)
        front = bytes(h.mem[0, 0x9000:0x9000 + 49 * 16])
        h.call('GetMonBackpic', de=0x8000)
        back = bytes(h.mem[0, 0x8000:0x8000 + 36 * 16])
        return front, back

    def source(art):
        animated = (root / f'gfx/pokemon/{art}/front.animated.2bpp').read_bytes()
        side = (root / f'gfx/pokemon/{art}/front.dimensions').read_bytes()[0] & 15
        assert side == 7, art
        return animated[:49 * 16], (root / f'gfx/pokemon/{art}/back.2bpp').read_bytes()[:36 * 16]

    female_art, male_art = source('butterfreef'), source('butterfree')
    check(female_art != male_art, 'female and male art differ')
    for flags in (FEMALE, FEMALE | SHINY):
        check(pics(butterfree, flags) == female_art, f'female front/back pics {flags:02x}')
    for flags in (MALE, MALE | SHINY):
        check(pics(butterfree, flags) == male_art, f'male front/back pics {flags:02x}')
    check(pics(caterpie, FEMALE) == pics(caterpie, MALE), 'other species ignore the flag')

    # --- animation rows ---------------------------------------------------
    def anim_rows(species, flags):
        h.wr(s('wTempMonUnused'), flags)
        h.call('GetUnownLetter', hl=s('wTempMonDVs'))
        h.wr(s('wCurPartySpecies'), species)
        h.call('PokeAnim_InitPicAttributes', hl=s('wTileMap') + 12)
        rows = []
        for idle in (0, 1):
            h.call('PokeAnim_InitAnim', bc=idle)
            bank = h.sym.bank('wPokeAnimStruct')
            def rd(name, n):
                addr = h.sym.addr(name)
                return bytes(h.mem[bank, addr:addr + n])
            rows.append((rd('wPokeAnimPointerBank', 1)[0], int.from_bytes(rd('wPokeAnimPointerAddr', 2), 'little'),
                         rd('wPokeAnimFramesBank', 1)[0], int.from_bytes(rd('wPokeAnimFramesAddr', 2), 'little'),
                         rd('wPokeAnimBitmaskBank', 1)[0], int.from_bytes(rd('wPokeAnimBitmaskAddr', 2), 'little')))
        return rows

    def expected_rows(label):
        return [h.sym[label + 'Animation'] + h.sym[label + 'Frames'] + h.sym[label + 'Bitmasks'],
                h.sym[label + 'AnimationIdle'] + h.sym[label + 'Frames'] + h.sym[label + 'Bitmasks']]

    check(anim_rows(butterfree, FEMALE) == expected_rows('ButterfreeFemale'), 'female animation rows')
    check(anim_rows(butterfree, FEMALE | SHINY) == expected_rows('ButterfreeFemale'), 'female shiny animation rows')
    check(anim_rows(butterfree, MALE) == expected_rows('Butterfree'), 'male animation rows')
    check(anim_rows(caterpie, FEMALE) == expected_rows('Caterpie'), 'female Caterpie keeps its rows')

    # --- palettes ---------------------------------------------------------
    pal_bank, pal_base = h.sym['PokemonPalettes']
    female_row = h.sym.addr('ButterfreeFemalePalette')
    male_row = pal_base + con.species_index('BUTTERFREE') * 8
    check(bytes(h.mem[pal_bank, female_row:female_row + 8]) ==
          gbcpal_middle(root / 'gfx/pokemon/butterfreef/front.gbcpal') +
          pal_file(root / 'gfx/pokemon/butterfreef/shiny.pal'), 'female palette row contents')

    def palette(routine, species, dvs):
        h.set_rom_bank(pal_bank)
        return h.call(routine, a=species, bc=dvs)['hl']

    for routine in ('GetMonNormalOrShinyPalettePointer', 'GetBackpicPalettePointer',
                    'GetFrontpicPalettePointer', 'GetPlayerOrMonPalettePointer'):
        for flags, row in ((MALE, male_row), (MALE | SHINY, male_row + 4),
                           (FEMALE, female_row), (FEMALE | SHINY, female_row + 4)):
            h.wr(s('wTempMonUnused'), flags)
            check(palette(routine, butterfree, s('wTempMonDVs')) == row, f'{routine} tempmon {flags:02x}')
            h.wr(s('wEnemyMonShinyGenderFlags'), flags)
            check(palette(routine, butterfree, s('wEnemyMonDVs')) == row, f'{routine} enemy {flags:02x}')
            h.wr(s('wCurBattleMon'), 1)
            h.wr(s('wPartyMon1Unused') + struct_length, flags)
            check(palette(routine, butterfree, s('wBattleMonDVs')) == row, f'{routine} battle mon {flags:02x}')
        h.wr(s('wTempMonUnused'), FEMALE)
        check(palette(routine, caterpie, s('wTempMonDVs')) ==
              pal_base + con.species_index('CATERPIE') * 8, f'{routine}: female Caterpie row')
    # Species-only lookups (Pokedex, Pokepic, menu) always show the default form.
    check(palette('GetMonPalettePointer', butterfree, 0) == male_row, 'species-only palette is default')
    h.wr(s('wTempMonUnused'), FEMALE | SHINY)
    check(h.call('CheckShininess', bc=s('wTempMonDVs'))['c_flag'], 'CheckShininess shiny')
    h.wr(s('wTempMonUnused'), MALE)
    check(not h.call('CheckShininess', bc=s('wTempMonDVs'))['c_flag'], 'CheckShininess not shiny')

    print(f'GENDER FORMS: {checks} checks passed in {rom.name}', flush=True)
    h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
