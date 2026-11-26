#!/usr/bin/env python3
"""Paint the two Beast Triad card clubs and write their tilesets and maps.

* GoldenrodTriadLounge (TILESET_TRIAD_LOUNGE): through the open doorway in
  the back wall of the Goldenrod Game Corner. A dim card shop lounge:
  burgundy carpet, wood panelling, binders and booster-box racks, a chalk
  board, leather chesterfield and armchairs, green banker's floor lamps and
  felt card tables with Beast Triad games in progress.
* CeladonTriadVault (TILESET_TRIAD_VAULT): behind the poster switch in the
  Celadon Game Corner. The Grand Masters' room: violet carpet, damask walls
  with champions' portraits and gold sconces, trophy cabinets, red velvet
  armchairs, a red runner up to a grand emerald table.

    python3 tools/triad_club/rooms.py

Writes gfx/tilesets/triad_{lounge,vault}.{png,pal}, data/tilesets/triad_*,
maps/{GoldenrodTriadLounge,CeladonTriadVault}.ablk and previews (with
collision outlines) in _artifacts/triad_club/.
"""

import math
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from kit import (ROOT, Canvas, encode_room, write_tileset, write_palette,  # noqa: E402
                 WALL, FLOOR, WARP_DOWN)

OUT = ROOT / '_artifacts/triad_club'
TEXT = [(31, 31, 16), (31, 31, 16), (14, 9, 0), (0, 0, 0)]

FONT = {  # 3x5 chalk letters
    'A': ['.#.', '#.#', '###', '#.#', '#.#'], 'B': ['##.', '#.#', '##.', '#.#', '##.'],
    'D': ['##.', '#.#', '#.#', '#.#', '##.'], 'E': ['###', '#..', '##.', '#..', '###'],
    'I': ['###', '.#.', '.#.', '.#.', '###'], 'R': ['##.', '#.#', '##.', '#.#', '#.#'],
    'S': ['.##', '#..', '.#.', '..#', '##.'], 'T': ['###', '.#.', '.#.', '.#.', '.#.'],
    'N': ['#.#', '##.', '#.#', '#.#', '#.#'], 'G': ['.##', '#..', '#.#', '#.#', '.##'],
    'H': ['#.#', '#.#', '###', '#.#', '#.#'], 'O': ['.#.', '#.#', '#.#', '#.#', '.#.'],
    'M': ['#.#', '###', '###', '#.#', '#.#'], 'C': ['.##', '#..', '#..', '#..', '.##'],
    ' ': ['...', '...', '...', '...', '...'],
}


class Room:
    def __init__(self, name, colours, wsteps=16, hsteps=12, seed=1):
        self.name = name
        self.c = colours
        self.cv = Canvas(wsteps, hsteps)
        self.rng = random.Random(seed)
        c = colours
        self.carpet_shades = {c['carpetHi'], c['carpetBase'], c['carpetLo']}
        self.flatten = {c['carpetHi']: c['carpetBase'], c['carpetLo']: c['carpetBase'],
                        c['wallHi']: c['wallMid'], c['wallLo']: c['wallMid']}

    @property
    def palettes(self):
        c = self.c
        return [
            [c['carpetHi'], c['carpetBase'], c['carpetLo'], c['K']],   # 0 floor
            [c['wallHi'], c['wallMid'], c['wallLo'], c['K']],         # 1 wall
            [c['woodHi'], c['woodMid'], c['carpetBase'], c['K']],     # 2 wood & leather
            [c['feltHi'], c['feltBase'], c['woodMid'], c['K']],       # 3 felt table tops
            [c['paper'], c['red'], c['feltHi'], c['K']],              # 4 cards on lit felt
            [c['accentHi'], c['accent'], c['carpetBase'], c['K']],    # 5 plants / velvet
            [c['lampHi'], c['gold'], c['wallMid'], c['K']],           # 6 wall brass & frames
            TEXT,
        ]

    # -- structure -----------------------------------------------------------------
    def wall(self, rows=2):
        """Back wall in 3/4 view: ceiling ledge, wallpaper, a chair rail that
        stands out from the wall, bevelled wainscot panels and a baseboard."""
        c, cv = self.c, self.cv
        h = rows * 16
        Hi, Mid, Lo, K = c['wallHi'], c['wallMid'], c['wallLo'], c['K']
        cv.rect(0, 0, cv.w, h, Mid)
        # wallpaper stripes, lit from above (fade towards the rail)
        for x in range(0, cv.w, 4):
            cv.vline(x, 3, 11, Lo)
        for x in range(2, cv.w, 8):
            for y in (5, 10):
                cv.set(x, y, Hi)
        # ceiling edge and crown moulding: underside in shadow
        cv.hline(0, 0, cv.w, K)
        cv.hline(0, 1, cv.w, Hi)
        cv.hline(0, 2, cv.w, Lo)
        # chair rail: lit top, front face, shadow cast below it
        cv.hline(0, 14, cv.w, Hi)
        cv.hline(0, 15, cv.w, Mid)
        cv.hline(0, 16, cv.w, K)
        for x in range(0, cv.w, 2):
            cv.set(x, 17, Lo)
        # raised wainscot panels: lit top/left bevel, shaded bottom/right
        for x in range(0, cv.w, 16):
            cv.hline(x + 1, 19, 13, Hi)
            cv.vline(x + 1, 19, 8, Hi)
            cv.hline(x + 2, 27, 13, Lo)
            cv.vline(x + 14, 20, 8, Lo)
            cv.vline(x + 15, 18, 11, K)
        # baseboard: lit top edge, dark face, then the floor line
        cv.hline(0, 28, cv.w, Hi)
        cv.rect(0, 29, cv.w, 2, Lo)
        cv.hline(0, 31, cv.w, K)
        cv.block_coll(0, 0, cv.ws, rows, WALL)

    def wall_shadow(self, top):
        """The wall shades the first rows of carpet."""
        c, cv = self.c, self.cv
        for x in range(cv.w):
            for y, every in ((top, 1), (top + 1, 2), (top + 2, 4)):
                if cv.get(x, y) in self.carpet_shades and (x + y) % every == 0:
                    cv.set(x, y, c['carpetLo'])

    def shadow(self, x, y, w, h, solid_rows=0):
        """Drop shadow on the carpet: black dither (survives in furniture tiles)."""
        c, cv = self.c, self.cv
        for yy in range(y, y + h):
            for xx in range(x, x + w):
                if 0 <= xx < cv.w and 0 <= yy < cv.h and cv.get(xx, yy) in self.carpet_shades and ((xx + yy) % 2 == 0 or yy - y < solid_rows):
                    cv.set(xx, yy, c['K'])

    def carpet(self, top):
        c, cv = self.c, self.cv
        for y in range(top, cv.h):
            for x in range(cv.w):
                lx, ly = x % 16, (y - top) % 16
                d = abs(lx - 8) + abs(ly - 8)
                col = c['carpetBase']
                if d == 5:
                    col = c['carpetLo']
                elif d == 0:
                    col = c['carpetHi']
                elif (lx == 0 or ly == 0) and (lx + ly) % 2 == 0:
                    col = c['carpetLo']
                cv.set(x, y, col)

    def lighting(self, top, lights, dark=0.55):
        """Dim the carpet away from the lamps and brighten pools under them.

        Light is set per 16x16 step (four levels with fixed dither patterns)
        so the floor needs only a few distinct tiles.
        """
        c, cv = self.c, self.cv
        bayer = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]
        for sy in range(top // 16, cv.hs):
            for sx in range(cv.ws):
                cx, cy = sx * 16 + 8, sy * 16 + 8
                glow = max([1 - math.hypot(cx - lx, (cy - ly) * 1.3) / r for lx, ly, r in lights] + [0])
                edge = min(sx, cv.ws - 1 - sx, cv.hs - 1 - sy)
                if glow > 0.55:
                    level = 3
                elif glow > 0.2:
                    level = 2
                elif glow == 0 and edge == 0:
                    level = 0
                else:
                    level = 1
                for y in range(sy * 16, sy * 16 + 16):
                    for x in range(sx * 16, sx * 16 + 16):
                        col = cv.get(x, y)
                        if col != c['carpetBase']:
                            continue
                        t = bayer[y % 4][x % 4]
                        if level == 3 and t < 3:
                            cv.set(x, y, c['carpetHi'])
                        elif level == 2 and t < 1:
                            cv.set(x, y, c['carpetHi'])
                        elif level == 0 and t < 4 * dark:
                            cv.set(x, y, c['carpetLo'])

    def doormat(self, sx, sy, w=2):
        c, cv = self.c, self.cv
        x, y = sx * 16, sy * 16
        cv.rect(x + 1, y + 3, w * 16 - 2, 12, c['K'])
        cv.rect(x + 2, y + 4, w * 16 - 4, 10, c['carpetLo'])
        for yy in range(y + 5, y + 13, 2):
            cv.hline(x + 3, yy, w * 16 - 6, c['carpetHi'])
        cv.block_coll(sx, sy, w, 1, WARP_DOWN)

    # -- wall pieces (palette 6: lampHi, gold, wallMid, K) ---------------------------
    def sconce(self, px):
        c, cv = self.c, self.cv
        # warm halo on the wallpaper
        for y in range(2, 15):
            for x in range(px - 3, px + 11):
                if abs(x - (px + 3.5)) + abs(y - 5) * 0.8 < 7 and (x + y) % 2 == 0:
                    cv.set(x, y, c['wallMid'])
        cv.stamp(px - 1, 2, [
            '...KKKK...',
            '..KHHHHK..',
            '.KHHHHHHK.',
            'KHHHHHHHHK',
            'KKKKKKKKKK',
            '....GG....',
            '...KGGK...',
            '..KGKKGK..',
            '..KGGGGK..',
            '..KGKKGK..',
            '...KGGK...',
            '....KK....',
        ], {'K': c['K'], 'H': c['lampHi'], 'G': c['gold']})

    def frame(self, px, w, art, art_key, top=2, h=12):
        c, cv = self.c, self.cv
        cv.rect(px, top, w, h, c['K'])
        cv.frame(px + 1, top + 1, w - 2, h - 2, c['gold'])
        cv.rect(px + 2, top + 2, w - 4, h - 4, art_key.get('bg', c['K']))
        cv.stamp(px + 2, top + 2, art, art_key)

    def chalkboard(self, px, w, text):
        c, cv = self.c, self.cv
        cv.rect(px, 2, w, 13, c['gold'])
        cv.frame(px, 2, w, 13, c['K'])
        cv.rect(px + 2, 4, w - 4, 9, c['K'])
        tw = len(text) * 4 - 1
        x = px + (w - tw) // 2
        for ch in text:
            cv.stamp(x, 6, FONT[ch], {'#': c['lampHi']})
            x += 4
        # chalk tray
        cv.hline(px + 3, 14, w - 6, c['lampHi'])

    # -- furniture on the floor --------------------------------------------------
    def shelf(self, sx, kind, h_steps=3):
        """Rack against the wall: lit top surface, deep shadowed cubbies."""
        c, cv = self.c, self.cv
        x, w, h = sx * 16, 32, h_steps * 16 - 2
        W, M, B, K = c['woodHi'], c['woodMid'], c['carpetBase'], c['K']
        cv.rect(x, 0, w, h, K)
        # top surface seen from above
        cv.rect(x + 1, 1, w - 2, 3, W)
        cv.hline(x + 1, 4, w - 2, M)
        # front frame: lit left post, shaded right post
        cv.rect(x + 1, 5, w - 2, h - 6, M)
        cv.vline(x + 1, 5, h - 6, W)
        cv.vline(x + w - 2, 5, h - 6, K)
        for sy in range(7, h - 8, 10):
            # cubby: back panel in shadow under the board above
            cv.rect(x + 3, sy, w - 6, 8, K)
            for xx in range(x + 3, x + w - 3):
                if (xx + sy) % 2:
                    cv.set(xx, sy + 7, M)
            # board: lit top edge and front face
            cv.hline(x + 2, sy + 8, w - 4, W)
            cv.hline(x + 2, sy + 9, w - 4, M)
            xx = x + 4
            while xx < x + w - 4:
                if kind == 'books':
                    bw = self.rng.choice((2, 2, 3))
                    bh = self.rng.choice((5, 6, 7))
                    col = self.rng.choice((W, M, B, B))
                    if xx + bw > x + w - 4:
                        break
                    top = sy + 8 - bh
                    cv.rect(xx, top, bw, bh, col)
                    cv.hline(xx, top, bw, W if col != W else M)   # lit tops
                    cv.vline(xx + bw - 1, top + 1, bh - 1, K if bw == 3 else col)
                    xx += bw
                elif kind == 'boxes':
                    if xx + 7 > x + w - 4:
                        break
                    # booster box: lid seen from above, label on the front
                    cv.rect(xx, sy + 2, 7, 6, K)
                    cv.rect(xx + 1, sy + 2, 5, 2, W)
                    cv.rect(xx + 1, sy + 4, 5, 3, B)
                    cv.set(xx + 3, sy + 5, W)
                    xx += 8
                elif kind == 'trophies':
                    if xx + 7 > x + w - 4:
                        break
                    cv.stamp(xx, sy + 1, ['.KWWWK.', 'KWWWWMK', '.KWWMK.', '..KWK..', '..KMK..', '.KWWMK.', '.KKKKK.'],
                             {'W': W, 'M': M, 'K': K})
                    xx += 8
        # plinth with a lit top edge
        cv.rect(x, h - 4, w, 4, K)
        cv.hline(x + 1, h - 4, w - 2, W)
        cv.rect(x + 1, h - 3, w - 2, 2, M)
        self.shadow(x + 2, h, w - 1, 2)
        cv.block_coll(sx, 0, 2, h_steps, WALL)

    def plant(self, sx, sy):
        """Potted palm: fronds over a pot with a visible rim and soil."""
        c, cv = self.c, self.cv
        x, y = sx * 16, sy * 16
        cv.stamp(x, y + 16, [
            '....KKKKKKKK....',
            '..KKWWWWWWWWKK..',
            '.KWWKKKKKKKKWMK.',
            '.KWKMMMMMMMMKMK.',
            '..KWWKKKKKKMMK..',
            '..KWWMMMMMMMMK..',
            '...KWMMMMMMMK...',
            '...KWMMMMMMKK...',
            '...KWWMMMMMMK...',
            '....KWMMMMMK....',
            '....KKKKKKKK....',
        ], {'W': c['woodHi'], 'M': c['woodMid'], 'K': c['K']})
        cv.stamp(x, y, [
            '.......L........',
            '..L...LLL..L....',
            '..LL.LLMLLLL.L..',
            '.LLMLLLMMLLMLLL.',
            'LLMMMLLMLMMMMML.',
            'LMMKKMLMMLKKMMLL',
            'LMK.KMMLMK.KMMML',
            '.LK..KMLMK..KML.',
            '.LMK.LLMLLK.KML.',
            'LLMMKLMLMMLKMMML',
            'LMMKKMLLMLMKKMML',
            '.LK.KMMLMML.KML.',
            '.K..KMKLMMMK.KK.',
            '....KMKLLMKK....',
            '.....KMLMMK.....',
            '.....KMMMMK.....',
        ], {'L': c['accentHi'], 'M': c['accent'], 'K': c['K']})
        self.shadow(x + 4, y + 27, 11, 3)
        cv.block_coll(sx, sy, 1, 2, WALL)

    def floor_lamp(self, sx, sy):
        """Banker's floor lamp: a lit cone of a shade on a brass pole."""
        c, cv = self.c, self.cv
        x, y = sx * 16, sy * 16
        cv.stamp(x, y, [
            '................',
            '.....KKKKKK.....',
            '....KLLLLLLK....',
            '...KLKKKKKKLK...',
            '...KLLLLLLLLK...',
            '..KLLMMMMMMMMK..',
            '..KLMMMMMMMMMK..',
            '.KLMMMMMMMMMMMK.',
            '.KLLLLLLLLLLLLK.',
            '.KKKKKKKKKKKKKK.',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
        ], {'L': c['accentHi'], 'M': c['accent'], 'K': c['K']})
        cv.stamp(x, y + 16, [
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '.......KK.......',
            '......KKKK......',
            '....KKWWWWKK....',
            '...KWWWWWWMMK...',
            '...KMMMMMMMMK...',
            '....KKKKKKKK....',
        ], {'W': c['woodHi'], 'M': c['woodMid'], 'K': c['K']})
        self.shadow(x + 5, y + 26, 10, 3)
        cv.block_coll(sx, sy, 1, 2, WALL)

    def sofa(self, sx, sy, steps=4, upholstery='wood'):
        """Chesterfield seen from the front and above: the tops of the back,
        arms and cushions catch the light, their fronts fall into shade."""
        c, cv = self.c, self.cv
        x, y, w = sx * 16, sy * 16 + 4, steps * 16
        H, M = (c['woodHi'], c['woodMid']) if upholstery == 'wood' else (c['accentHi'], c['accent'])
        K = c['K']
        cv.rect(x + 1, y, w - 2, 26, K)
        # back: rolled top seen from above, buttoned face below
        cv.rect(x + 2, y + 1, w - 4, 3, H)
        cv.rect(x + 2, y + 4, w - 4, 7, M)
        for bx in range(x + 7, x + w - 6, 6):
            cv.set(bx, y + 6, K)
            cv.set(bx + 3, y + 9, K)
            cv.set(bx + 1, y + 5, H)
        # arms: top surface, then the scrolled front face
        for ax in (x + 1, x + w - 9):
            cv.rect(ax, y + 5, 8, 18, K)
            cv.rect(ax + 1, y + 6, 6, 4, H)
            cv.rect(ax + 1, y + 10, 6, 12, M)
            cv.hline(ax + 1, y + 10, 6, K)
            cv.set(ax + 3, y + 14, H)
            cv.set(ax + 4, y + 15, K)
        # seat cushions: deep lit tops, short shaded fronts
        sx0, sw = x + 9, w - 18
        cv.rect(sx0, y + 11, sw, 7, H)
        cv.rect(sx0, y + 18, sw, 4, M)
        cv.hline(sx0, y + 11, sw, K)
        cv.hline(sx0, y + 18, sw, K)
        n = max(1, sw // 16)
        for i in range(1, n):
            cv.vline(sx0 + i * sw // n, y + 11, 11, K)
        # base and feet
        cv.hline(x + 2, y + 22, w - 4, M)
        cv.hline(x + 1, y + 23, w - 2, K)
        for lx in (x + 3, x + w - 6):
            cv.rect(lx, y + 24, 3, 2, K)
        self.shadow(x + 3, y + 25, w - 4, 2)
        cv.block_coll(sx, sy, steps, 2, WALL)

    def armchair(self, sx, sy, facing='right', upholstery='wood'):
        """Club armchair in 3/4 view: tall back, far arm, seat and near arm."""
        c, cv = self.c, self.cv
        H, M = (c['woodHi'], c['woodMid']) if upholstery == 'wood' else (c['accentHi'], c['accent'])
        cv.stamp(sx * 16, sy * 16, [
            '.KKKKK..........',
            'KHHHHMK.........',
            'KHMMMMKKKKKKKKK.',
            'KHMMMMKHHHHHHHMK',
            'KHMMMMKMMMMMMMMK',
            'KHMMMMKKKKKKKKKK',
            'KHMMMMHHHHHHHHHK',
            'KHMMMMHHHHHHHHMK',
            'KHMMMMKKKKKKKKKK',
            'KHMMMKHHHHHHHHHK',
            'KHMMKHHHHHHHHHMK',
            'KMMMKMMMMMMMMMMK',
            'KMMMKMMMMMMMMMMK',
            'KKKKKKKKKKKKKKKK',
            '.KK.........KK..',
            '.S.S.S.S.S.S.S.S',
        ], {'K': c['K'], 'H': H, 'M': M, 'S': c['K']}, flip=(facing == 'left'))
        cv.block_coll(sx, sy, 1, 1, WALL)

    def chair(self, sx, sy, facing='right'):
        """Wooden card-table chair in 3/4 view."""
        c, cv = self.c, self.cv
        cv.stamp(sx * 16, sy * 16, [
            '..KKK...........',
            '.KHHMK..........',
            '.KHMMK..........',
            '.KHKMK..........',
            '.KHMMK..........',
            '.KHKMK..........',
            '.KHMMKKKKKKKKK..',
            '.KHMHHHHHHHHHMK.',
            '.KHMHHHHHHHHMMK.',
            '.KMMKKKKKKKKKKK.',
            '.KMMMMMMMMMMMMK.',
            '.KKKKKKKKKKKKKK.',
            '.KMK.......KMK..',
            '.KMK.......KMK..',
            '.KKK.......KKK..',
            '..S.S.S.S.S.S...',
        ], {'K': c['K'], 'H': c['woodHi'], 'M': c['woodMid'], 'S': c['K']}, flip=(facing == 'left'))
        cv.block_coll(sx, sy, 1, 1, WALL)

    def side_table(self, sx, sy, with_deck=True):
        """Round pedestal table: lit oval top, the thickness of its edge, a
        pedestal and an oval shadow."""
        c, cv = self.c, self.cv
        cv.stamp(sx * 16, sy * 16, [
            '................',
            '....KKKKKKKK....',
            '..KKHHHHHHHHKK..',
            '.KHHHHHHHHHHHMK.',
            '.KHHHHHHHHHHMMK.',
            '..KHHHHHHHHMMK..',
            '..KMMMMMMMMMMK..',
            '....KKKKKKKK....',
            '......KHMK......',
            '......KHMK......',
            '......KHMK......',
            '.....KKHMKK.....',
            '....KHHHMMMK....',
            '....KMMMMMMK....',
            '.....KKKKKK.....',
            '....S.S.S.S.S...',
        ], {'K': c['K'], 'H': c['woodHi'], 'M': c['woodMid'], 'S': c['K']})
        if with_deck:  # a deck of cards and a dark mug on the top
            cv.stamp(sx * 16 + 4, sy * 16 + 2, ['KKKK', 'KMMK', 'KMMK', 'KKKK'], {'K': c['K'], 'M': c['woodMid']})
            cv.stamp(sx * 16 + 9, sy * 16 + 2, ['.KK.', 'KBBK', 'KBBK', '.KK.'], {'K': c['K'], 'B': c['carpetBase']})
        cv.block_coll(sx, sy, 1, 1, WALL)

    def coffee_table(self, sx, sy, steps=2):
        """Low table: lit top with grain, a front face, stubby legs, shadow."""
        c, cv = self.c, self.cv
        x, y, w = sx * 16 + 1, sy * 16 + 1, steps * 16 - 2
        K, H, M = c['K'], c['woodHi'], c['woodMid']
        cv.rect(x, y, w, 11, K)
        cv.rect(x + 1, y + 1, w - 2, 6, H)
        for gx in range(x + 3, x + w - 3, 7):
            cv.hline(gx, y + 3, 3, M)
        cv.rect(x + 1, y + 7, w - 2, 3, M)
        cv.hline(x + 1, y + 7, w - 2, K)
        for lx in (x + 1, x + w - 3):
            cv.rect(lx, y + 11, 2, 2, K)
        self.shadow(x + 2, y + 12, w - 1, 2)
        # scattered cards (backs) and a card box on the top
        for i, cx in enumerate(range(x + 4, x + w - 9, 6)):
            cv.rect(cx, y + 2 + (i % 2), 4, 3, K)
            cv.rect(cx + 1, y + 3 + (i % 2), 2, 1, c['carpetBase'])
        cv.stamp(x + w - 8, y + 1, ['KKKKK', 'KMMMK', 'KKKKK'], {'K': K, 'M': M})
        cv.block_coll(sx, sy, steps, 1, WALL)

    def card_table(self, sx, sy, ws, hs=3, board=True, hands=True, seed=0):
        """Felt card table: lit felt (palettes 3/4), wooden rail and skirt.

        The rail fills whole tiles, so no felt tile touches the carpet; the
        card faces sit inside the lamp-lit felt, which fills whole tiles too.
        """
        c, cv = self.c, self.cv
        rng = random.Random(seed)
        x, y, w, h = sx * 16, sy * 16, ws * 16, hs * 16
        K, Wm, Wh = c['K'], c['woodMid'], c['woodHi']
        F, Fh = c['feltBase'], c['feltHi']
        top_h = h - 16  # tabletop height; the last 16 px are rail front, skirt, legs
        cv.rect(x, y, w, top_h, Wm)
        cv.hline(x + 1, y, w - 2, K)
        cv.vline(x, y + 1, top_h - 1, K)
        cv.vline(x + w - 1, y + 1, top_h - 1, K)
        cv.set(x, y, K)
        cv.set(x + w - 1, y, K)
        # felt with a dark lip
        fx0, fy0, fx1, fy1 = x + 3, y + 3, x + w - 4, y + top_h - 1
        cv.rect(fx0, fy0, fx1 - fx0 + 1, fy1 - fy0 + 1, K)
        cv.rect(fx0 + 1, fy0 + 1, fx1 - fx0 - 1, fy1 - fy0 - 1, F)
        # lamp-lit centre (whole tiles), dithered fall-off around it
        lx0, ly0, lx1, ly1 = x + 8, y + 8, x + w - 9, y + top_h - 1
        for yy in range(fy0 + 1, fy1):
            for xx in range(fx0 + 1, fx1):
                inside = lx0 <= xx <= lx1 and ly0 <= yy <= ly1
                if inside:
                    cv.set(xx, yy, Fh)
                elif (xx + yy) % 2 == 0 and (lx0 - 3 <= xx <= lx1 + 3) and (ly0 - 3 <= yy <= ly1 + 3):
                    cv.set(xx, yy, Fh)
        cv.hline(lx0, fy1, lx1 - lx0 + 1, K)
        # front rail, skirt and legs (wood palette: whole tile rows)
        ry = y + top_h
        cv.rect(x, ry, w, 4, Wm)
        cv.hline(x, ry, w, Wh)
        cv.vline(x, ry, 4, K)
        cv.vline(x + w - 1, ry, 4, K)
        cv.hline(x, ry + 4, w, K)
        cv.rect(x + 2, ry + 5, w - 4, 4, Wm)
        cv.hline(x + 2, ry + 5, w - 4, Wh)
        cv.vline(x + 1, ry + 5, 4, K)
        cv.vline(x + w - 2, ry + 5, 4, K)
        cv.hline(x + 1, ry + 9, w - 2, K)
        for lx in (x + 3, x + w - 7):
            cv.rect(lx, ry + 10, 4, 5, K)
            cv.vline(lx + 1, ry + 10, 4, Wh)
            cv.vline(lx + 2, ry + 10, 4, Wm)
        # the table's shadow on the carpet between and behind the legs
        self.shadow(x + 7, ry + 10, w - 14, 5, solid_rows=1)
        self.shadow(x + 2, ry + 15, w - 1, 1)
        # cards on the lit felt (palette 4)
        P, R = c['paper'], c['red']

        def card(cx, cy, red, back=False, cw=6, ch=8):
            cv.rect(cx, cy, cw, ch, K)
            cv.rect(cx + 1, cy + 1, cw - 2, ch - 2, R if (red or back) else P)
            if back:
                cv.rect(cx + 2, cy + 2, cw - 4, ch - 4, P)
                cv.rect(cx + 2, cy + 3, cw - 4, ch - 6, R)
            else:
                # tiny beast silhouette and rank pips
                cv.set(cx + cw // 2 - 1, cy + 3, K)
                cv.set(cx + cw // 2, cy + 3, K)
                cv.set(cx + cw // 2 - 1, cy + 4, K)
                cv.set(cx + 1, cy + 1, P if red else R)
                cv.set(cx + cw - 2, cy + ch - 2, P if red else R)

        lw, lh = lx1 - lx0 + 1, ly1 - ly0
        if board:
            cw, ch, gap = (6, 7, 1) if lh < 26 else (7, 8, 1)
            gw, gh = 3 * cw + 2 * gap, 3 * ch + 2 * gap
            bx = lx0 + (lw - gw) // 2
            by = ly0 + max(1, (lh - gh) // 2)
            for row in range(3):
                for col in range(3):
                    r = rng.random()
                    if r < 0.2:
                        continue
                    card(bx + col * (cw + gap), by + row * (ch + gap), r < 0.6, cw=cw, ch=ch)
            if hands:
                hx = (bx - lx0 - 6) // 2
                for i in range(rng.choice((2, 3))):
                    card(lx0 + hx, ly0 + 1 + i * 5, False, back=False, cw=6, ch=7)
                for i in range(rng.choice((2, 3))):
                    card(lx1 - 5 - hx, ly0 + 1 + i * 5, True, back=True, cw=6, ch=7)
        else:
            # a casual game: two hands and a couple of cards in the middle
            cx = lx0 + lw // 2
            card(cx - 7, ly0 + 1, True, cw=6, ch=7)
            card(cx + 1, ly0 + 1, False, cw=6, ch=7)
            card(lx0 + 1, ly0 + 1, False, back=True, cw=5, ch=6)
            card(lx1 - 5, ly0 + 1, False, back=True, cw=5, ch=6)
        cv.block_coll(sx, sy, ws, hs, WALL)

    def runner(self, sx, sy, ws, hs):
        """Red velvet runner (palette 5) with dark edges."""
        c, cv = self.c, self.cv
        x, y, w, h = sx * 16, sy * 16, ws * 16, hs * 16
        cv.rect(x + 2, y, w - 4, h, c['accent'])
        cv.vline(x + 2, y, h, c['K'])
        cv.vline(x + w - 3, y, h, c['K'])
        cv.vline(x + 4, y, h, c['accentHi'])
        cv.vline(x + w - 5, y, h, c['accentHi'])
        for yy in range(y + 4, y + h, 8):
            cx = x + w // 2
            cv.stamp(cx - 3, yy, ['...H...', '..HKH..', '.HK.KH.', '..HKH..', '...H...'],
                     {'H': c['accentHi'], 'K': c['K']})

    def stanchion(self, sx, sy, rope_to=None):
        c, cv = self.c, self.cv
        x, y = sx * 16, sy * 16
        cv.stamp(x + 5, y + 1, [
            '.KKKK.',
            'KHHMMK',
            '.KKKK.',
            '..KK..',
            '..KK..',
            '..KK..',
            '..KK..',
            '..KK..',
            '..KK..',
            '..KK..',
            '.KKKK.',
            'KKKKKK',
        ], {'K': c['K'], 'H': c['accentHi'], 'M': c['accent']})
        if rope_to is not None:
            x2 = rope_to * 16 + 8
            x1 = x + 8
            lo, hi = sorted((x1, x2))
            for xx in range(lo + 3, hi - 2):
                sag = int(3 * math.sin(math.pi * (xx - lo) / max(1, hi - lo)))
                cv.set(xx, y + 3 + sag, c['accent'])
                cv.set(xx, y + 4 + sag, c['K'])
        cv.block_coll(sx, sy, 1, 1, WALL)

    def build(self):
        # Block $00 is solid black: indoor maps draw it beyond their edges.
        border = Canvas(2, 2, fill=self.c['K'])
        border.block_coll(0, 0, 2, 2, WALL)
        store, blocks, _ = encode_room(border, self.palettes, self.flatten)
        store, blocks, blk = encode_room(self.cv, self.palettes, self.flatten, store, blocks)
        return store, blocks, blk


# -- the rooms ------------------------------------------------------------------------

LOUNGE = dict(
    K=(1, 1, 2),
    carpetHi=(14, 6, 7), carpetBase=(10, 3, 5), carpetLo=(6, 2, 3),
    wallHi=(17, 12, 7), wallMid=(11, 7, 4), wallLo=(7, 4, 3),
    woodHi=(22, 15, 8), woodMid=(14, 8, 4),
    feltHi=(9, 19, 11), feltBase=(3, 10, 6),
    paper=(29, 28, 24), red=(25, 5, 6),
    accentHi=(11, 19, 8), accent=(4, 11, 5),          # plants, lamp shades
    lampHi=(31, 29, 18), gold=(25, 18, 6),
)

VAULT = dict(
    K=(1, 0, 2),
    carpetHi=(12, 6, 16), carpetBase=(7, 3, 11), carpetLo=(4, 1, 7),
    wallHi=(10, 9, 17), wallMid=(5, 5, 11), wallLo=(3, 2, 7),
    woodHi=(26, 19, 7), woodMid=(12, 4, 4),           # brass, mahogany
    feltHi=(6, 17, 12), feltBase=(1, 9, 7),
    paper=(30, 29, 25), red=(26, 4, 7),
    accentHi=(26, 7, 9), accent=(16, 2, 6),           # red velvet
    lampHi=(31, 29, 17), gold=(26, 19, 4),
)


def portrait(room, px, figure_colour):
    c = room.c
    art = [
        '..........',
        '....KK....',
        '...KHHK...',
        '...KHHK...',
        '....KK....',
        '..KGGGGK..',
        '.KGGGGGGK.',
        '.KGGGGGGK.',
    ]
    room.frame(px, 14, art, {'K': c['K'], 'H': c['lampHi'], 'G': figure_colour, 'bg': c['wallMid']})


def card_poster(room, px):
    c = room.c
    art = [
        'KKKKK.......',
        'KHHHKKKKK...',
        'KHGHKHHHK...',
        'KHHHKHGHK...',
        'KHGHKHHHK...',
        'KKKKKHGHK...',
        '....KHHHK...',
        '....KKKKK...',
    ]
    art = [('..' + r)[:12] for r in art]
    room.frame(px, 16, art, {'K': c['K'], 'H': c['lampHi'], 'G': c['gold'], 'bg': c['K']})


def lounge():
    r = Room('triad_lounge', LOUNGE, seed=7)
    cv = r.cv
    r.wall()
    r.carpet(32)
    # lamps: sofa floor lamps, the two big tables and the small one
    r.lighting(32, [(88, 40, 46), (168, 40, 46), (40, 104, 60), (216, 104, 60), (128, 128, 44),
                    (56, 168, 34), (200, 168, 34)])
    r.wall_shadow(32)
    # wall
    r.shelf(0, 'books')
    r.shelf(14, 'boxes')
    card_poster(r, 40)
    card_poster(r, 200)
    r.sconce(60)
    r.sconce(188)
    r.chalkboard(80, 96, 'BEAST TRIAD')
    # lounge under the board
    r.floor_lamp(5, 2)
    r.sofa(6, 2, 4)
    r.floor_lamp(10, 2)
    r.coffee_table(7, 4)
    r.plant(2, 2)
    r.plant(13, 2)
    # the two big tables and a small one
    r.card_table(1, 5, 3, seed=3)
    r.card_table(12, 5, 3, seed=8)
    r.card_table(7, 7, 2, 2, board=False, seed=5)
    r.chair(9, 8, 'left')
    r.chair(0, 6, 'right')
    r.chair(15, 6, 'left')
    # reading corners by the door
    r.armchair(2, 10, 'right')
    r.side_table(3, 10)
    r.armchair(4, 10, 'left')
    r.armchair(11, 10, 'right')
    r.side_table(12, 10)
    r.armchair(13, 10, 'left')
    r.plant(0, 10)
    r.plant(15, 10)
    r.doormat(7, 11)
    return r


def vault():
    r = Room('triad_vault', VAULT, seed=11)
    cv = r.cv
    r.wall()
    r.carpet(32)
    r.lighting(32, [(128, 88, 62), (40, 136, 46), (216, 136, 46), (128, 176, 30)], dark=0.75)
    r.wall_shadow(32)
    r.runner(7, 6, 2, 6)
    # wall: trophy cabinets, champions' portraits, sconces, the crest
    r.shelf(0, 'trophies')
    r.shelf(14, 'trophies')
    portrait(r, 36, r.c['gold'])
    portrait(r, 206, r.c['gold'])
    portrait(r, 68, r.c['lampHi'])
    portrait(r, 174, r.c['lampHi'])
    r.sconce(56)
    r.sconce(192)
    c = r.c
    r.frame(98, 60, [], {'K': c['K'], 'bg': c['K']}, top=2, h=13)
    x = 98 + (60 - (len('GRAND MASTER') * 4 - 1)) // 2
    for ch in 'GRAND MASTER':
        cv.stamp(x, 6, FONT[ch], {'#': c['gold']})
        x += 4
    # seating
    r.armchair(2, 2, 'right', upholstery='velvet')
    r.side_table(3, 2, with_deck=True)
    r.armchair(4, 2, 'left', upholstery='velvet')
    r.armchair(11, 2, 'right', upholstery='velvet')
    r.side_table(12, 2, with_deck=True)
    r.armchair(13, 2, 'left', upholstery='velvet')
    # the grand table and two challenge tables
    r.card_table(6, 3, 4, seed=21)
    r.card_table(1, 7, 3, seed=22)
    r.card_table(12, 7, 3, seed=23)
    r.chair(0, 8, 'right')
    r.chair(15, 8, 'left')
    # conversation nooks by the door: armchairs turned towards each other
    r.armchair(1, 10, 'right', upholstery='velvet')
    r.side_table(2, 10)
    r.armchair(3, 10, 'left', upholstery='velvet')
    r.armchair(12, 10, 'right', upholstery='velvet')
    r.side_table(13, 10)
    r.armchair(14, 10, 'left', upholstery='velvet')
    r.doormat(7, 11)
    return r


def main():
    for room, mapname, comment in (
            (lounge(), 'GoldenrodTriadLounge', 'Goldenrod Triad Lounge: dim card-shop lounge'),
            (vault(), 'CeladonTriadVault', 'Celadon Grand Master room: dim velvet and gold')):
        store, blocks, blk = room.build()
        write_tileset(room.name, store, blocks)
        write_palette(room.name, room.palettes, comment + ' (tools/triad_club/rooms.py)')
        (ROOT / f'maps/{mapname}.ablk').write_bytes(blk)
        room.cv.save_preview(OUT / f'{room.name}.png', scale=3)
        room.cv.save_preview(OUT / f'{room.name}_collision.png', scale=3, grid=True)
        print(f'{room.name}: {len(store.slots)} tiles, {len(blocks)} blocks')


if __name__ == '__main__':
    main()
