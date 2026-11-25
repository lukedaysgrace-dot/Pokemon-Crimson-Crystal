#!/usr/bin/env python3
"""Build the Beast Triad catalogue and CGB tiles from Crimson Crystal art."""

import argparse
from dataclasses import dataclass
from pathlib import Path
import re
import sys
import zlib

from PIL import Image, ImageDraw, ImageOps

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from audit_learnset_variety import load_sources

# Character cards are the game's rarest prizes, like Triple Triad's level 10
# player cards: about 28-30 points with one or two dominant edges.
TRAINERS = {
    "BLUE": ((9, 4, 7, 9), "BLUE"),
    "RED": ((10, 8, 3, 9), "RED"),
    "GREEN": ((8, 9, 7, 5), "GREEN"),
    "LORELEI": ((9, 3, 8, 8), "RED"),
    "KOGA": ((7, 9, 3, 8), "BLUE"),
    "BRUNO": ((5, 10, 8, 4), "BROWN"),
    "KAREN": ((8, 6, 9, 5), None),
    "LANCE": ((10, 7, 4, 8), "RED"),
    "OAK": ((7, 7, 9, 5), "BROWN"),
    "SILVER": ((9, 7, 4, 8), "RED"),
    "CRYSTAL": ((8, 8, 6, 6), "BLUE"),
}
STARTERS = ("BULBASAUR", "CHARMANDER", "SQUIRTLE", "MAREEP", "HOOTHOOT")
DIGITS = {
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "010", "010", "010"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
    "A": ("010", "101", "111", "101", "101"),
}
# gfx/beast_triad/type_icons.png, top to bottom, with the symbol colors the
# battle HUD used (Normal light gray, Fire red, Fighting orange...).
TYPE_ICONS = (
    ("NORMAL", (21, 21, 21)), ("FIRE", (29, 4, 4)), ("FIGHTING", (30, 15, 3)),
    ("WATER", (5, 15, 28)), ("FLYING", (12, 23, 29)), ("GRASS", (5, 17, 7)),
    ("POISON", (15, 5, 21)), ("ELECTRIC", (30, 24, 2)), ("GROUND", (24, 18, 11)),
    ("PSYCHIC", (27, 6, 16)), ("ROCK", (23, 19, 12)), ("ICE", (15, 26, 29)),
    ("BUG", (19, 25, 8)), ("DRAGON", (5, 9, 23)), ("GHOST", (21, 15, 26)),
    ("DARK", (6, 4, 3)), ("STEEL", (7, 20, 21)), ("FAIRY", (30, 19, 25)),
)
TYPE_INDEX = {name: i for i, (name, _) in enumerate(TYPE_ICONS)}
# Rank positions on a card face: north, east, south, west.
RANK_POSITIONS = ((10, 2), (20, 13), (10, 25), (1, 13))
# Type matchups can push an attacking edge to 0 or 11 for a moment.
BADGE_GLYPHS = {
    0: ("111", "101", "101", "101", "111"),
    11: ("101", "101", "101", "101", "101"),
}
CARD_WIDTH = 24
CARD_HEIGHT = 32
CARD_BYTES = CARD_WIDTH * CARD_HEIGHT // 4
CARDS_PER_BANK = 0x4000 // CARD_BYTES
SOURCE_SHADES = {255: 0, 170: 1, 85: 2, 0: 3}


@dataclass(frozen=True)
class Card:
    key: str
    name: str
    ranks: tuple
    picture: Image.Image
    type: str = None  # primary type constant; character cards have none

    @property
    def power(self):
        return sum(self.ranks)


def read(path):
    return (ROOT / path).read_text(encoding="utf-8")


def decode_tiles(data, width, height):
    """Read row-major Game Boy tiles without changing their color indices."""
    assert len(data) == width * height // 4
    pixels = bytearray(width * height)
    for tile_y in range(height // 8):
        for tile_x in range(width // 8):
            tile = (tile_y * (width // 8) + tile_x) * 16
            for row in range(8):
                lo, hi = data[tile + row * 2:tile + row * 2 + 2]
                offset = (tile_y * 8 + row) * width + tile_x * 8
                for x in range(8):
                    bit = 7 - x
                    pixels[offset + x] = (lo >> bit & 1) | ((hi >> bit & 1) << 1)
    return Image.frombytes("L", (width, height), bytes(pixels))


def first_sprite_frame(path):
    # The party menu and the standing overworld pose both start with
    # these four tiles in row-major order.
    frame = (ROOT / path).read_bytes()[:64]
    return decode_tiles(frame, 16, 16).point(lambda index: 255 - index * 85)


def stats_ranks(key, stats, total):
    # Weight each edge differently. The cap keeps weak cards from carrying
    # a dominant edge, as Triple Triad keeps 9s and 10s for high levels.
    if key in {"ENTEI", "RAIKOU", "SUICUNE"}:
        return {"ENTEI": (9, 7, 4, 6), "RAIKOU": (6, 9, 7, 4), "SUICUNE": (4, 6, 9, 7)}[key]
    cap = min(10, (total + 3) // 4 + 3)
    hp, attack, defense, speed, special, resistance = stats
    weights = (special * 3 + speed, attack * 3 + speed, defense * 2 + hp * 2, resistance * 3 + hp)
    rng = zlib.crc32(key.encode("ascii"))
    ranked = sorted(range(4), key=lambda i: (weights[i], (rng >> (i * 6)) & 63))
    profile = (3, 1, -1, -3) if rng & 1 else (2, 2, 0, -4)
    order = {index: offset for index, offset in zip(ranked, reversed(profile))}
    result = [max(1, min(cap, total // 4 + order[i])) for i in range(4)]
    while sum(result) != total:
        step = 1 if sum(result) < total else -1
        for index in (ranked[::-1] if step > 0 else ranked):
            if 1 <= result[index] + step <= cap:
                result[index] += step
                if sum(result) == total:
                    break
    return tuple(result)


# Rank totals by evolution stage, scaled within each band by base stat total.
# Triple Triad's level 1 monsters total about 10-13 and its level 10
# character cards about 28-30; Beast Triad follows the same curve.
BABIES = {"PICHU", "CLEFFA", "IGGLYBUFF", "TYROGUE", "SMOOCHUM", "ELEKID", "MAGBY"}
LEGENDS = {"ARTICUNO": 26, "ZAPDOS": 26, "MOLTRES": 26, "RAIKOU": 26, "ENTEI": 26, "SUICUNE": 26,
           "MEWTWO": 28, "LUGIA": 28, "HO_OH": 28, "MEW": 26, "CELEBI": 26, "JIRACHI": 26,
           "DRAGONITE": 25, "TYRANITAR": 25}
BANDS = {
    "baby": (9, 11),
    "basic3": (10, 13),
    "middle3": (15, 18),
    "final3": (20, 24),
    "basic2": (11, 15),
    "final2": (18, 23),
    "single": (14, 22),
}


def stage_categories(keys, parents):
    """Classify each card as baby, single stage, or a stage of a 2/3 stage line."""
    # Use the whole species graph: a line keeps its stage count even when a
    # later-generation member has no card of its own.
    up = {key: [p for p in parents[key] if p not in BABIES] for key in parents}
    down = {key: [] for key in parents}
    for key in parents:
        for parent in up[key]:
            down[parent].append(key)

    def depth_up(key):
        return 0 if not up[key] else 1 + max(map(depth_up, up[key]))

    def depth_down(key):
        return 0 if not down[key] else 1 + max(map(depth_down, down[key]))

    categories = {}
    for key in keys:
        if key in BABIES:
            categories[key] = "baby"
            continue
        stage, length = depth_up(key), depth_up(key) + depth_down(key) + 1
        if length == 1:
            categories[key] = "single"
        elif length == 2:
            categories[key] = ("basic2", "final2")[stage]
        else:
            categories[key] = ("basic3", "middle3", "final3")[min(stage, 2)]
    return categories


def rank_totals(keys, stats, parents):
    categories = stage_categories(keys, parents)
    totals = {}
    for band, (low, high) in BANDS.items():
        members = [key for key in keys if categories[key] == band and key not in LEGENDS]
        if not members:
            continue
        bst = {key: sum(stats[key]) for key in members}
        lo, hi = min(bst.values()), max(bst.values())
        for key in members:
            position = (bst[key] - lo) / (hi - lo) if hi > lo else 0.5
            totals[key] = round(low + position * (high - low))
    totals.update({key: value for key, value in LEGENDS.items() if key in keys})
    return totals, categories


def roster():
    order, _, _, _, parents, _ = load_sources()
    base_paths = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^"]+)"', read("data/pokemon/base_stats.asm"))
    paths = dict(zip(order, base_paths, strict=True))
    names = re.findall(r'^\s*db "([^"]+)"', read("data/pokemon/names.asm").split("PokemonNames::", 1)[1], re.M)
    icon_paths = dict(re.findall(r'^(\w+):\s+INCBIN "(gfx/menu_icons/[^"]+\.2bpp)"', read("gfx/menu_icons.asm"), re.M))
    icons = re.findall(r'^\s*dba\s+(\w+)', read("data/menu_icon_pointers.asm"), re.M)
    keys = order[:order.index("CELEBI") + 1] + ["JIRACHI"]
    assert len(keys) == 252

    stats = {key: tuple(map(int, re.search(
        r"^\s*db\s+(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)",
        read(paths[key]), re.M).groups())) for key in keys}
    totals, _ = rank_totals(keys, stats, parents)
    types = {key: re.search(r"^\s*db\s+(\w+)\s*,\s*(\w+)\s*;\s*type", read(paths[key]), re.M)[1]
             for key in keys}
    assert set(types.values()) <= set(TYPE_INDEX), set(types.values()) - set(TYPE_INDEX)

    cards = []
    for key in keys:
        index = order.index(key)
        picture = first_sprite_frame(icon_paths[icons[index]])
        cards.append(Card(key, names[index].rstrip("@"), stats_ranks(key, stats[key], totals[key]), picture,
                          types[key]))

    for name, (ranks, _) in TRAINERS.items():
        cards.append(Card(name, name, ranks, first_sprite_frame(f"gfx/sprites/{name.lower()}.2bpp")))
    return cards


def card_image(card):
    image = Image.new("L", (CARD_WIDTH, CARD_HEIGHT), 0)
    draw = ImageDraw.Draw(image)
    histogram = card.picture.histogram()
    primary = 1 if histogram[170] >= histogram[85] else 2
    for x in (1, 22):
        draw.line((x, 6, x, 10), fill=primary)
        draw.line((x, 21, x, 25), fill=primary)
    for y in (1, 30):
        draw.line((3, y, 7, y), fill=primary)
        draw.line((16, y, 20, y), fill=primary)
    for rank, (left, top) in zip(card.ranks, RANK_POSITIONS):
        glyph = DIGITS["A" if rank == 10 else str(rank)]
        pixels = [(x, y) for y, row in enumerate(glyph, top)
                  for x, pixel in enumerate(row, left) if pixel == "1"]
        for x, y in pixels:
            draw.point([(x-1,y), (x+1,y), (x,y-1), (x,y+1)], fill=3)
        draw.point(pixels, fill=0)
    draw.rectangle((0, 0, CARD_WIDTH - 1, CARD_HEIGHT - 1), outline=3)
    # As in the party menu, color 0 is transparent. Put the menu icon
    # above the outline so all foreground pixels keep their original indices.
    icon = card.picture.point(lambda shade: (255 - shade) // 85)
    image.paste(icon, (4,8), icon.point(lambda index: 255 if index else 0))
    # The palette switch relies on both ends of each card being solid ink.
    assert all(image.getpixel((x,y)) == 3 for y in (0,CARD_HEIGHT-1) for x in range(CARD_WIDTH))
    return image


def encode_tile(indexes):
    packed = bytearray()
    for y in range(8):
        row = indexes[y*8:y*8+8]
        for plane in range(2):
            packed.append(sum(((pixel >> plane) & 1) << (7-x) for x,pixel in enumerate(row)))
    return bytes(packed)


def encode_card(card):
    image = card_image(card)
    return b"".join(encode_tile(image.crop((x,y,x+8,y+8)).get_flattened_data())
                    for y in range(0,CARD_HEIGHT,8) for x in range(0,CARD_WIDTH,8))


def palette_color(value):
    return tuple(round(v*31/255) for v in bytes.fromhex(value))


def screen_assets():
    # Each tuple is in tile-index order, so index 0 is the HUD paper color.
    palettes = [tuple(map(palette_color, values.split())) for values in (
        "f6e8ce d7bd84 a98146 352a26",  # table and paper
        "e2bd7e c9944f ab5944 744335",  # Entei portrait
        "d7bd84 7f9eaa 435a68 352a26",  # Suicune frame
        "d7bd84 a65945 ebcf95 352a26",  # hidden cards
        "f7f7c6 42ce5a ef3973 000000",  # face colors replace indices 0 through 2
        "f7f7c6 42ce5a ef3973 000000",
        "f7f7c6 42ce5a ef3973 000000",
        "f7f7c6 42ce5a ef3973 000000",
    )]
    expanded = [tuple(tuple((v*255+15)//31 for v in color) for color in p) for p in palettes]
    cream, table, grain, ink = expanded[0]
    gold, ochre, ember, sepia = expanded[1]
    _, blue, blue_dark, _ = expanded[2]
    _, clay, card_paper, _ = expanded[3]
    image = Image.new("RGB", (160,144), table)
    draw = ImageDraw.Draw(image)
    bold = Image.open(ROOT/"gfx/font/unused_bold_font.png").convert("L")
    regular = Image.open(ROOT/"gfx/font/font.png").convert("L")
    logo = Image.open(ROOT/"gfx/menu_icons/entei.png").convert("L").crop((1,0,15,13))
    ball = ImageOps.invert(Image.open(ROOT/"gfx/mail/small_pokeball.png").convert("L"))

    def glyph(sheet, index):
        cols = sheet.width // 8
        x,y = (index % cols)*8,(index // cols)*8
        return ImageOps.invert(sheet.crop((x,y,x+8,y+8)))

    def label(value,x,y,font):
        for i,c in enumerate(value):
            if c != " ":
                image.paste(ink,(x+i*8,y),glyph(font,ord(c)-ord("A")))

    for y in (23,47,71,95,119):
        draw.line((0,y,159,y), fill=grain)
    draw.rectangle((32,16,119,127), fill=table)
    draw.rectangle((38,22,113,121), outline=blue_dark)
    draw.rectangle((39,23,112,120), outline=blue)
    draw.rectangle((40,24,111,119), fill=gold)
    portrait=Image.new("RGB",logo.size)
    portrait.putdata([(gold,ochre,ember,sepia)[SOURCE_SHADES[v]] for v in logo.get_flattened_data()])
    image.paste(portrait.resize((70,65),Image.Resampling.NEAREST),(41,39))
    draw.rectangle((8,24,31,119), fill=table)
    draw.rectangle((120,24,151,119), fill=table)
    draw.rectangle((0,0,159,15), fill=cream)
    label("BEAST TRIAD",36,0,bold)
    label("FOE",8,8,regular)
    draw.line((76,12,82,12), fill=grain)
    label("YOU",120,8,regular)
    draw.rectangle((0,128,159,143), fill=cream)
    draw.line((1,127,158,127), fill=ink)

    # Reserve native tile IDs only for the characters used by this screen.
    char_ids = {*range(0x80,0x9a), *range(0xf6,0x100), 0xc0, 0xe0, 0xe3, 0xe6, 0xe7, 0xe8, 0xef, 0xf5}
    tiles = [bytes(16)] * 256
    for char in char_ids:
        tiles[char^128] = encode_tile([3 if p else 0 for p in glyph(regular,char-128).get_flattened_data()])
    # "+" ($c0) is drawn outside font.png in the main game; draw it here.
    plus=Image.new("L",(8,8))
    ImageDraw.Draw(plus).rectangle((3,1,4,6), fill=3)
    ImageDraw.Draw(plus).rectangle((1,3,6,4), fill=3)
    tiles[0xc0^128] = encode_tile(list(plus.get_flattened_data()))
    indexes = {tiles[char^128]:char for char in sorted(char_ids)}
    free_ids = iter(i^128 for i in range(256) if i^128 not in char_ids)

    def tile_id(index_data):
        tile=encode_tile(index_data)
        if tile not in indexes:
            index=next(free_ids)
            indexes[tile]=index
            tiles[index^128]=tile
        return indexes[tile]

    def convert_tile(tile, candidates):
        pixels=tile.get_flattened_data()
        colors=set(pixels)
        attr=next(i for i in candidates if colors.issubset(expanded[i]))
        return tile_id([expanded[attr].index(p) for p in pixels]),8|attr

    tilemap, attrs = [], []
    for y in range(0,144,8):
        for x in range(0,160,8):
            ti,at=convert_tile(image.crop((x,y,x+8,y+8)),range(4))
            tilemap.append(ti)
            attrs.append(at)

    foe_maps=[]
    for count in range(6):
        stack=Image.new("RGB",(CARD_WIDTH,96),table)
        back=ImageDraw.Draw(stack)
        for i in range(count):
            y=96-CARD_HEIGHT-16*(count-1-i)
            back.rounded_rectangle((0,y,23,y+31), radius=2, fill=ink)
            back.rectangle((1,y+1,22,y+30),fill=card_paper)
            back.rectangle((2,y+2,21,y+29),fill=clay)
            stack.paste(ink,(8,y+12),ball)
        for y in range(0,96,8):
            for x in range(0,CARD_WIDTH,8):
                tile,_=convert_tile(stack.crop((x,y,x+8,y+8)),[3])
                foe_maps.append(tile)

    empty=tile_id([0]*64)
    arrow=Image.new("L",(8,8))
    ImageDraw.Draw(arrow).polygon(((1,3),(5,0),(5,6)), fill=3)
    arrow_tile=tile_id(arrow.get_flattened_data())
    # Card Case markers: a cursor pointing at the row, and a held card.
    cursor=Image.new("L",(8,8))
    ImageDraw.Draw(cursor).polygon(((2,0),(6,3),(2,6)), fill=3)
    cursor_tile=tile_id(cursor.get_flattened_data())
    held=Image.new("L",(8,8))
    ImageDraw.Draw(held).rectangle((1,0,6,6), fill=3)
    ImageDraw.Draw(held).rectangle((2,1,5,5), fill=0)
    ImageDraw.Draw(held).point((3,3), fill=3)
    held_tile=tile_id(held.get_flattened_data())
    # Type symbols use color 1, recolored per type on the label row.
    sheet=Image.open(ROOT/"gfx/beast_triad/type_icons.png").convert("L")
    assert sheet.size==(8,8*len(TYPE_ICONS))
    type_tiles=[tile_id([1 if v<128 else 0 for v in sheet.crop((0,8*i,8,8*i+8)).get_flattened_data()])
                for i in range(len(TYPE_ICONS))]
    palette_data=b"".join((r | g<<5 | b<<10).to_bytes(2,"little") for p in palettes for r,g,b in p)
    return (bytes(tilemap),bytes(attrs),bytes(foe_maps),palette_data,b"".join(tiles),empty,arrow_tile,
            cursor_tile,held_tile,type_tiles)


def build():
    cards=roster()
    labels={card.key:i for i,card in enumerate(cards)}
    tiles,attrs,backs,palettes,gfx,blank,arrow,cursor,held,type_tiles=screen_assets()
    constants=[
        "; Generated by tools/beast_triad/build.py.",
        "BEAST_CARD_ITEM_BASE EQU $200",
        f"BEAST_TRIAD_DECK_SIZE EQU {len(STARTERS)}",
        "\tconst_def BEAST_CARD_ITEM_BASE",
        *(f"\tconst BEAST_CARD_{card.key}" for card in cards),
        "NUM_BEAST_CARDS EQU const_value - BEAST_CARD_ITEM_BASE",
        "",
    ]
    lines=[
        "; Generated by tools/beast_triad/build.py.",
        "BeastTriadCatalog:",
    ]
    for i,card in enumerate(cards):
        lines.append(f'\tdb {", ".join(map(str,card.ranks))}, "{card.name.ljust(10)}"')
        lines.append(f"\tdb BANK(BeastTriadArt{i//CARDS_PER_BANK})")
        lines.append(f"\tdw BeastTriadArt{i//CARDS_PER_BANK} + {(i%CARDS_PER_BANK)*CARD_BYTES}")
    lines.extend([
        "\tassert @ - BeastTriadCatalog == NUM_BEAST_CARDS * 17",
    ])
    lines += ["BeastTriadStarters:", "\tdw " + ", ".join(str(labels[key]) for key in STARTERS),
        f"BEAST_BLANK_TILE EQU ${blank:02x}", f"BEAST_ARROW_TILE EQU ${arrow:02x}",
        f"BEAST_CURSOR_TILE EQU ${cursor:02x}", f"BEAST_HELD_TILE EQU ${held:02x}"]
    # Primary types only: the game's type constant for matchups, and the
    # symbol shown on the label row. Character cards have neither.
    lines.append("BeastTriadCardTypes:")
    for i in range(0, len(cards), 8):
        lines.append("\tdb " + ", ".join(card.type or "-1" for card in cards[i:i+8]))
    lines.append("BeastTriadCardIcons:")
    for i in range(0, len(cards), 16):
        lines.append("\tdb " + ", ".join(str(TYPE_INDEX[card.type]) if card.type else "-1"
                                         for card in cards[i:i+16]))
    lines.append("BeastTriadTypeIconTiles:")
    lines.append("\tdb " + ", ".join(f"${tile:02x}" for tile in type_tiles))
    lines.append("BeastTriadTypeColors:")
    lines += [f"\tRGB {r}, {g}, {b} ; {name.title()}" for name, (r, g, b) in TYPE_ICONS]
    lines.append("BeastTriadBadgeGlyphs:")
    for value in range(12):
        glyph = BADGE_GLYPHS.get(value) or DIGITS["A" if value == 10 else str(value)]
        lines.append("\tdb " + ", ".join(f"%{row}" for row in glyph))
    lines.append("BeastTriadRankPositions:")
    lines.append("\tdb " + ", ".join(f"{x}, {y}" for x, y in RANK_POSITIONS))
    lines.append("BeastTriadTrainerColors:")
    for _, palette in TRAINERS.values():
        if palette is None:
            label = "LoadKarensRoomObjectPalette.KarenLightBlueHair"
            lines += [f"\tdb BANK({label})", f"\tdw {label} + PAL_COLOR_SIZE"]
        else:
            label = "MapObjectPals"
            lines += [f"\tdb BANK({label})",
                      f"\tdw {label} + DAY_F * 8 palettes + PAL_OW_{palette} palettes + PAL_COLOR_SIZE"]
    lines.append("\tassert @ - BeastTriadTrainerColors == (NUM_BEAST_CARDS - 252) * 3")
    offset=0
    for label,data in (("ScreenTiles",tiles),("ScreenAttrs",attrs),("FoeMaps",backs),
                       ("Palettes",palettes)):
        lines += [f"BeastTriad{label}:", f'\tINCBIN "gfx/beast_triad/screen.bin", {offset}, {len(data)}']
        offset += len(data)
    lines.append("")
    # Foe hands are dealt from each card's eight nearest peers. Character
    # cards only come from their owners, so they are nobody's peer.
    playable=[j for j,card in enumerate(cards) if card.key not in TRAINERS]
    art_labels=['SECTION "Beast Triad Peers", ROMX', "BeastTriadPeers:"]
    for i,card in enumerate(cards):
        peers=sorted((j for j in playable if j!=i),
                     key=lambda j:(abs(cards[j].power-card.power),
                                   zlib.crc32(f"{i}:{j}".encode("ascii"))))[:8]
        art_labels.append("\tdw " + ", ".join(str(j) for j in peers))
    art_labels += [
        "",
        'SECTION "Beast Triad Board Tiles", ROMX',
        "BeastTriadStaticGFX:",
        f'\tINCBIN "gfx/beast_triad/screen.bin", {offset}, {len(gfx)}',
        "BeastTriadStaticGFXEnd:",
        "",
    ]
    for i in range(0,len(cards),CARDS_PER_BANK):
        count=min(CARDS_PER_BANK,len(cards)-i)
        art_labels += [f'SECTION "Beast Triad Card Art {i//CARDS_PER_BANK}", ROMX',
                       f"BeastTriadArt{i//CARDS_PER_BANK}:",
                       f'\tINCBIN "gfx/beast_triad/card_art.bin", {i*CARD_BYTES}, {count*CARD_BYTES}',""]
    return {
        "constants/beast_triad_constants.asm": "\n".join(constants).encode("utf-8"),
        "data/beast_triad/catalog.asm": "\n".join(lines).encode("utf-8"),
        "data/beast_triad/card_art.asm": "\n".join(art_labels).encode("utf-8"),
        "gfx/beast_triad/screen.bin": tiles+attrs+backs+palettes+gfx,
        "gfx/beast_triad/card_art.bin": b"".join(map(encode_card,cards)),
    }


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check",action="store_true")
    args=parser.parse_args()
    for name,data in build().items():
        path=ROOT/name
        if args.check:
            assert path.read_bytes()==data, f"Regenerate {name}"
        elif not path.exists() or path.read_bytes() != data:
            path.parent.mkdir(parents=True,exist_ok=True)
            path.write_bytes(data)
    print(f"Beast Triad: 263 cards, {CARD_WIDTH}×{CARD_HEIGHT} pixels each.")


if __name__ == "__main__":
    main()
