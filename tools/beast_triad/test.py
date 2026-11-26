#!/usr/bin/env python3
"""Exercise the ROM's table, placement, capture, Card Case, and save paths."""

from collections import deque
from io import BytesIO
from pathlib import Path
import re
import tempfile
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/battletest"))
from cove_sprite_checks import native_call
from gameplay_rules_checks import new_game, save_continue
from runner import Harness
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text

import build

CARD_COLS = build.CARD_WIDTH // 8
CARD_ROWS = build.CARD_HEIGHT // 8
CARD_TILES = CARD_COLS * CARD_ROWS
EMPTY = 255
CASE, HAND, HELD, RESULT, EXIT, ANIM, PICK, FOE_MOVE = range(8)
NONE = 0xFFFF
BUTTONS = ("up", "right", "down", "left")
STEPS = ((0, -1), (1, 0), (0, 1), (-1, 0))


def location(name):
    group = number = 0
    for line in (ROOT / "constants/map_constants.asm").read_text().splitlines():
        if re.match(r"\s+newgroup\b", line):
            group += 1
            number = 0
        match = re.match(r"\s+map_const\s+(\w+),", line)
        if match:
            number += 1
            if match[1] == name:
                return group, number
    raise ValueError(name)


def key(h, button, wait=6):
    h.press(button, hold=2, wait=wait)


def await_state(h, predicate, message, max_frames=900):
    for _ in range(0, max_frames, 3):
        if predicate():
            return
        h.tick(3)
    raise AssertionError(f"{message}: {h.where(15)}")


def open_case_from_bag(h):
    m = h.battle.mem
    m.write("wLastPocket", 2)
    key(h, "start", wait=40)
    for _ in range(12):
        if m.read("wMenuSelection") == 2:
            break
        key(h, "down", wait=14)
    assert m.read("wMenuSelection") == 2
    key(h, "a", wait=35)
    assert m.read("wCurPocket") == 2
    for _ in range(8):
        if m.read("wBTMode") == CASE:
            h.tick(15)
            return
        key(h, "a", wait=24)
    raise AssertionError("Card Case did not open from the bag")


def read_deck(m, symbol="wBeastTriadDeck"):
    return [int.from_bytes(m.read_bytes(symbol, 2, i * 2), "little") for i in range(5)]


def board_tile(cell):
    col = 5 + CARD_COLS * (cell % 3)
    row = 3 + CARD_ROWS * (cell // 3)
    return row * 20 + col


def neighborhood(position):
    x, y = position % 3, position // 3
    for side, (dx, dy) in enumerate(STEPS):
        nx, ny = x + dx, y + dy
        if 0 <= nx < 3 and 0 <= ny < 3:
            yield side, nx + 3 * ny


def signed(byte):
    return byte - 256 if byte > 127 else byte


def predicted_place(board, owners, ranks, card, slot, owner, mods=bytes(100)):
    """Super effective primary types add one to the attacking edge only;
    resisted or immune types take one away."""
    assert board[slot] == EMPTY
    expected_cards = bytearray(board)
    expected_owners = bytearray(owners)
    expected_cards[slot] = card
    expected_owners[slot] = owner
    for side, neighbor in neighborhood(slot):
        rival = board[neighbor]
        if rival != EMPTY and owners[neighbor] != owner:
            attack = ranks[4 * card + side] + signed(mods[10 * card + rival])
            if attack > ranks[4 * rival + (side + 2) % 4]:
                expected_owners[neighbor] = owner
    return bytes(expected_cards), bytes(expected_owners)


def seek(board, cursor, direction):
    """The held card only moves onto empty cells (BeastTriadSeekFreeCell)."""
    x0, y0 = cursor % 3, cursor // 3
    best, best_score = cursor, 255
    for cell in range(9):
        if board[cell] != EMPTY:
            continue
        x, y = cell % 3, cell // 3
        if direction in (0, 2):
            target, origin, side = y, y0, abs(x - x0)
        else:
            target, origin, side = x, x0, abs(y - y0)
        forward = (target - origin) % 3 if direction in (1, 2) else (origin - target) % 3
        if forward and forward * 4 + side < best_score:
            best, best_score = cell, forward * 4 + side
    return best


def press_direction(h, button):
    m = h.battle.mem
    board = m.read_bytes("wBTBoard", 9)
    expected = seek(board, m.read("wBTBoardCursor"), BUTTONS.index(button))
    key(h, button)
    cursor = m.read("wBTBoardCursor")
    assert cursor == expected, (button, expected, cursor)
    assert board[cursor] == EMPTY, "The held card moved onto a taken cell"


def navigate(h, target):
    m = h.battle.mem
    board = m.read_bytes("wBTBoard", 9)
    assert board[target] == EMPTY
    cursor = m.read("wBTBoardCursor")
    queue = deque([(cursor, [])])
    seen = {cursor}
    while queue:
        slot, route = queue.popleft()
        if slot == target:
            break
        for direction, button in enumerate(BUTTONS):
            next_slot = seek(board, slot, direction)
            if next_slot not in seen:
                queue.append((next_slot, [*route, button]))
                seen.add(next_slot)
    for button in route:
        press_direction(h, button)
    assert m.read("wBTBoardCursor") == target


def settled_frames(h, button, count=20):
    """Each frame after an input must be the picture before or after it.
    Anything else is a palette or tilemap flicker."""
    h.tick(8)
    before = h.pb.screen.image.convert("RGB").tobytes()
    shots = []
    h.pb.button_press(button)
    for i in range(count):
        if i == 2:
            h.pb.button_release(button)
        h.tick(1)
        shots.append(h.pb.screen.image.convert("RGB").tobytes())
    h.tick(8)
    after = h.pb.screen.image.convert("RGB").tobytes()
    bad = sum(shot not in (before, after) for shot in shots)
    assert not bad, f"{bad} flickering frames after {button}"


def steady_frames(h, button, count=60):
    """Each settled picture must hold for at least two frames.

    The opponent's moving sprite deliberately updates every frame.
    """
    m = h.battle.mem
    runs = []
    moving = m.read("wBTMode") == FOE_MOVE
    h.pb.button_press(button)
    for i in range(count):
        if i == 2:
            h.pb.button_release(button)
        h.tick(1)
        was_moving, moving = moving, m.read("wBTMode") == FOE_MOVE
        shot = h.pb.screen.image.convert("RGB").tobytes()
        if runs and runs[-1][0] == shot:
            runs[-1][1] += 1
        else:
            runs.append([shot, 1, moving or was_moving])
    short = [length for _, length, slide in runs[1:-1] if length < 2 and not slide]
    if short:
        from PIL import Image
        for i, (shot, length, _) in enumerate(runs[:8]):
            Image.frombytes("RGB", (160, 144), shot).save(f"/tmp/run{i}_{length}.png")
    assert not short, f"{len(short)} one-frame pictures after {button}"
    return len(runs)


def quit_frames(h):
    h.tick(4)
    before = h.pb.screen.image.convert("RGB").tobytes()
    h.pb.button("b", 2)
    for frame in range(1, 21):
        h.tick(1)
        image = h.pb.screen.image.convert("RGB")
        if image.getextrema() == ((248, 248),) * 3:
            h.tick(72 - frame)
            return
        assert image.tobytes() == before, "The table changed colors before it cleared"
    raise AssertionError("Exiting did not clear the table")


def word(m, symbol, offset=0):
    return int.from_bytes(m.read_bytes(symbol, 2, offset), "little")


def check_catalogue():
    cards = build.roster()
    keys = [card.key for card in cards]
    assert len(cards) == len(set(keys)) == 263
    assert keys[250:252] == ["CELEBI", "JIRACHI"]
    assert set(keys[252:]) == {"BLUE", "RED", "GREEN", "KOGA", "BRUNO", "KAREN",
                              "LORELEI", "LANCE", "OAK", "SILVER", "CRYSTAL"}
    assert all(1 <= rank <= 10 for card in cards for rank in card.ranks)
    assert all(len(card.name) <= 10 for card in cards)
    power = {card.key: card.power for card in cards}
    _, _, _, _, parents, _ = build.load_sources()
    for child in keys[:252]:
        for parent in parents[child]:
            if parent in power:
                assert power[child] > power[parent], (parent, child)
    for name, data in build.build().items():
        assert (ROOT / name).read_bytes() == data, name
    return cards


def check_linked_menu_icons(rom_path, symbols, constants, cards):
    """Verify the border and the party-menu icon on each linked card."""
    rom = rom_path.read_bytes()

    def read(bank, address, length):
        start = bank * 0x4000 + (address & 0x3fff)
        return rom[start:start + length]

    def record_art(table, index, record_size, pointer_offset, length):
        bank, address = symbols[table]
        pointer = read(bank, address + index * record_size + pointer_offset, 3)
        return read(pointer[0], int.from_bytes(pointer[1:], "little"), length)

    for index, card in enumerate(cards):
        raw_card = record_art("BeastTriadCatalog", index, 17, 14, build.CARD_BYTES)
        face = build.decode_tiles(raw_card, build.CARD_WIDTH, build.CARD_HEIGHT)
        assert face.tobytes() == build.card_image(card).tobytes(), card.key
        for x in range(build.CARD_WIDTH):
            assert all(face.getpixel(edge) == 3 for edge in (
                (x, 0), (x, build.CARD_HEIGHT - 1)
            )), (card.key, x)
        for y in range(build.CARD_HEIGHT):
            assert all(face.getpixel(edge) == 3 for edge in (
                (0, y), (build.CARD_WIDTH - 1, y)
            )), (card.key, y)
        if index < 252:
            species = constants.species_index(card.key)
            raw_icon = record_art("MenuIconPointers", species - 1, 3, 0, 64)
        else:
            raw_icon = read(*symbols[f"{card.key.title()}SpriteGFX"], 64)
        icon = build.decode_tiles(raw_icon, 16, 16)
        for y in range(16):
            for x in range(16):
                shade = icon.getpixel((x,y))
                received = face.getpixel((x+4,y+8))
                if shade:
                    assert received == shade, (card.key, x, y)
                else:
                    assert received in (0, 3), (card.key, x, y)
    print(f"PASS: all 263 borders, 252 Pokémon menu icons and 11 overworld trainers in {rom_path.name}")


def badge_image(card, ranks, edges):
    """The card art with its type-changed attacking edges shown as badges."""
    shown_ranks = [base + bonus if bonus else printed
                   for printed, base, bonus in zip(card.ranks, ranks, edges)]
    return build.card_image(card, shown_ranks)


def check_palette_frame(h, cards):
    """Compare every rendered card pixel, including accents, against its palette."""
    m = h.battle.mem
    tiles = m.read_bytes("wTileMap", 20 * 18)
    attrs = m.read_bytes("wAttrMap", 20 * 18)
    colours = m.read_bytes("wBTFaceColors", 10 * 4)
    ownership = m.read_bytes("wBTFaceOwners", 10)
    hand = [int.from_bytes(m.read_bytes("wBTDeck", 2, i * 2), "little") for i in range(10)]
    mode = m.read("wBTMode")
    selected_prize_slot = 5 + m.read("wBTPickCursor") if mode == PICK else None
    board_owners = dict(zip(m.read_bytes("wBTBoard", 9), m.read_bytes("wBTOwners", 9)))
    if mode == CASE:
        hand[m.read("wBTPreviewSlot")] = word(m, "wBTPreviewCard")
        hand[m.read("wBTHeldSlot")] = word(m, "wBTHeldCard")
    paper = [(30,30,24), (29,23,18), (25,29,30), (31,20,19)]
    image = h.pb.screen.image.convert("RGB")
    cache = {}

    def rgb_components(word):
        return tuple(word >> shift & 31 for shift in (0,5,10))

    def original_colours(index):
        if index < 252:
            bank, address = h.sym["PokemonPalettes"]
            species = h.con.species_index("JIRACHI") if index == 251 else index + 1
            address += species * 8
        else:
            bank, address = h.sym["BeastTriadTrainerColors"]
            address += (index - 252) * 3
            bank, lo, hi = (h.pb.memory[bank, address + i] for i in range(3))
            address = lo | hi << 8
        return bytes(h.pb.memory[bank, address + i] for i in range(4))

    for i, (tile, attr) in enumerate(zip(tiles, attrs)):
        if not 3 <= attr <= 7:
            continue
        slot, tile_index = divmod(tile, CARD_TILES)
        if slot not in cache:
            index = hand[slot]
            first, second = colours[4*slot:4*slot+2], colours[4*slot+2:4*slot+4]
            assert first + second == original_colours(index), (cards[index].name, first, second)
            art = build.card_image(cards[index])
            if mode != CASE and m.read("wBTTypeShown") == slot + 1:
                edges = [signed(b) for b in m.read_bytes("wBTEdgeBonus", 4)]
                art = badge_image(cards[index], m.read_bytes("wBTRanks", 4, 4 * slot), edges)
            cache[slot] = (art, (rgb_components(int.from_bytes(first, "little")),
                                 rgb_components(int.from_bytes(second, "little")), (0,0,0)))
        art, face = cache[slot]
        owner = ownership[slot]
        if mode == PICK and 4 <= attr <= 6:
            owner = 2 + board_owners[slot]
        elif attr == 7 and slot == selected_prize_slot:
            owner = 2
        palette = (paper[owner], *face)
        src_x, src_y = (tile_index % CARD_COLS) * 8, (tile_index // CARD_COLS) * 8
        dst_x, dst_y = (i % 20) * 8, (i // 20) * 8
        for y in range(8):
            for x in range(8):
                colour = art.getpixel((src_x+x,src_y+y))
                expected = palette[colour]
                received = tuple(v >> 3 for v in image.getpixel((dst_x+x,dst_y+y)))
                assert received == expected, (
                    cards[hand[slot]].name, (dst_x+x,dst_y+y), colour, expected, received
                )
    return len(cache)


def check_foe_hand(h):
    m = h.battle.mem
    used = m.read_bytes("wBTUsed", 5, 5)
    cursor = m.read("wBTFoeCursor")
    slots = [5 + slot for slot, spent in enumerate(used) if not spent]
    selected = cursor + 5 if cursor != EMPTY else None
    check_hand_layout(h, 1, 3, slots, selected)
    if selected is not None:
        assert m.read("wBTFaceOwners", selected) == 2


def check_right_hand(h):
    m = h.battle.mem
    mode = m.read("wBTMode")
    pick = mode == PICK
    cursor = m.read("wBTPickCursor" if pick else "wBTHandCursor")
    if pick:
        slots = list(range(5, 10))
        cursor += 5
    else:
        slots = [slot for slot, used in enumerate(m.read_bytes("wBTUsed", 5))
                 if not used and (mode != HELD or slot != cursor)]
    focus = pick or (mode == HAND and not m.read("wBTTurn") and m.read("wBTFoeCursor") == EMPTY)
    selected = cursor if focus and cursor in slots else None
    check_hand_layout(h, 15, 7, slots, selected)
    if selected is not None and not pick:
        assert m.read("wBTFaceOwners", selected) == 2


def check_hand_layout(h, column, palette, slots, selected):
    m = h.battle.mem
    tiles = m.read_bytes("wTileMap", 20 * 18)
    attrs = m.read_bytes("wAttrMap", 20 * 18)
    for row in range(18):
        pos = row * 20 + column
        layers = {slot: row - (3 + 2 * (slot % 5)) for slot in slots
                  if 3 + 2 * (slot % 5) <= row < 3 + 2 * (slot % 5) + CARD_ROWS}
        if not layers:
            assert palette not in attrs[pos:pos + CARD_COLS]
            continue
        slot = selected if selected in layers else max(layers)
        first_tile = slot * CARD_TILES + layers[slot] * CARD_COLS
        assert attrs[pos:pos + CARD_COLS] == bytes([palette] * CARD_COLS)
        assert tiles[pos:pos + CARD_COLS] == bytes(range(first_tile, first_tile + CARD_COLS)), (
            selected, row, slot, tiles[pos:pos + CARD_COLS])


def check_capture_edges(h):
    """Stage equality, opposing edges, diagonals, and an edge of the board."""
    m = h.battle.mem
    boost, drop = bytearray(100), bytearray(100)
    boost[5] = 1      # card 0's type is super effective against card 5's
    drop[5] = 0xFF    # ... or resisted by it
    for cell, board_cards, owners, rows, mods in (
        (4, [9, 5, EMPTY, 8, 0, 6, EMPTY, 7, EMPTY],
         [1, 1, EMPTY, 1, 0, 1, EMPTY, 1, EMPTY],
         {0: (7,5,4,8), 5: (1,1,6,1), 6: (1,1,1,5), 7: (6,1,1,1), 8: (1,7,1,1)}, None),
        (2, [EMPTY, EMPTY, 0, 5, EMPTY, 6, EMPTY, EMPTY, EMPTY],
         [EMPTY, EMPTY, 0, 1, EMPTY, 0, EMPTY, EMPTY, EMPTY],
         {0: (10,10,10,10)}, None),
        (7, [EMPTY, EMPTY, EMPTY, EMPTY, 5, EMPTY, 6, 0, 7],
         [EMPTY, EMPTY, EMPTY, EMPTY, 1, EMPTY, 1, 0, 1],
         {0: (7,8,7,1), 5: (1,1,7,1), 6: (1,2,1,1), 7: (1,1,1,7)}, None),
        # Equal ranks: a super effective type wins the tie...
        (7, [EMPTY, EMPTY, EMPTY, EMPTY, 5, EMPTY, EMPTY, 0, EMPTY],
         [EMPTY, EMPTY, EMPTY, EMPTY, 1, EMPTY, EMPTY, 0, EMPTY],
         {0: (6,1,1,1), 5: (1,1,6,1)}, bytes(boost)),
        # ...and a resisted type loses a one-point lead.
        (7, [EMPTY, EMPTY, EMPTY, EMPTY, 5, EMPTY, EMPTY, 0, EMPTY],
         [EMPTY, EMPTY, EMPTY, EMPTY, 1, EMPTY, EMPTY, 0, EMPTY],
         {0: (7,1,1,1), 5: (1,1,6,1)}, bytes(drop)),
    ):
        ranks = [1] * 40
        for i, row in rows.items():
            ranks[i*4:i*4+4] = row
        staged = mods is not None
        mods = mods if staged else bytes(100)
        m.write_bytes("wBTTypeMods", mods)
        _, expected = predicted_place(bytes(
            EMPTY if n == cell else c for n,c in enumerate(board_cards)
        ), bytes(owners), ranks, 0, cell, 0, mods)
        m.write_bytes("wBTBoard", board_cards)
        m.write_bytes("wBTOwners", owners)
        m.write_bytes("wBTRanks", ranks)
        m.write("wBTProbeCard", 0)
        m.write("wBTProbeCell", cell)
        m.write("wBTProbeOwner", 0)
        m.write("wBTCommit", 1)
        begin_native_call(h, "BeastTriadCompareNeighbors")
        # The helper has no frame waits. Park with interrupts off so a frame
        # boundary cannot leave the sampled PC inside the music interrupt.
        h.pb.memory[0xC0F0] = 0xF3
        h.pb.memory[0xFF70] = h.sym.bank("wBTMode")
        await_state(h, lambda: h.pb.register_file.PC in (0xC0F1, 0xC0F3), "capture comparison")
        assert m.read_bytes("wBTOwners", 9) == expected
        if staged:
            assert expected[4] == (0 if mods[5] == 1 else 1), "matchup decided the capture"


def main():
    cards = check_catalogue()
    keys = [card.key for card in cards]
    sfx = _parse_constants(ROOT / "constants/sfx_constants.asm")
    music = _parse_constants(ROOT / "constants/music_constants.asm")
    events = _parse_constants(ROOT / "constants/event_flags.asm")
    h = Harness(render=True)
    check_linked_menu_icons(ROOT / "pokecrystal_debug.gbc", h.sym, h.con, cards)
    m = h.battle.mem
    output = Path(tempfile.mkdtemp(prefix="beast-triad-"))
    output.mkdir(parents=True, exist_ok=True)
    captures = []
    map_before = []
    flip_phases = []
    capture_sounds = []
    flip = ((1, None), (2, 0), (2, 1), (2, 2), (4, 2), (4, 1), (4, 0),
            (3, None), (4, 0), (4, 1), (4, 2), (6, 2), (6, 1), (6, 0), (5, None))
    matchup_shows = []
    battled = []
    hits = []
    foe_selection = []
    foe_positions = []

    def map_snapshot():
        return (m.read_bytes("wOverworldMapBlocks", 1300),
                m.read_bytes("wTileMap", 360), m.read_bytes("wAttrMap", 360))

    def check_map_restored(label, expected):
        actual = map_snapshot()
        assert actual[0] == expected[0], f"{label} overwrote the live map blocks"
        assert actual[1:] == expected[1:], f"{label} redrew the wrong map"
        for bank, image in enumerate(actual[1:]):
            for row in range(18):
                address = 0x9800 + 32 * row
                assert bytes(h.pb.memory[bank, address:address + 20]) == image[row*20:(row+1)*20], (
                    label, bank, row)
        h.pb.screen.image.save(str(output / f"map-restored-{label}.png"))

    def before_place(_):
        board = m.read_bytes("wBTBoard", 9)
        owners = m.read_bytes("wBTOwners", 9)
        ranks = m.read_bytes("wBTRanks", 40)
        card = m.read("wBTProbeCard")
        slot = m.read("wBTProbeCell")
        owner = m.read("wBTProbeOwner")
        if owner == 1:
            remaining = [i for i, used in enumerate(m.read_bytes("wBTUsed", 5, 5)) if not used]
            chosen = remaining.index(card - 5) + 1
            assert foe_selection == remaining[chosen:] + remaining[:chosen]
            assert m.read("wBTFoeCursor") == EMPTY
            foe_selection.clear()
            start_y, start_x = 40 + 16 * (card - 5), 16
            end_y, end_x = 40 + 32 * (slot // 3), 48 + 24 * (slot % 3)
            foe_positions.append(tuple(m.read_bytes("wVirtualOAM", 2)))
            assert foe_positions == [
                (start_y + (end_y - start_y) * frame // 16,
                 start_x + (end_x - start_x) * frame // 16)
                for frame in range(17)
            ]
            foe_positions.clear()
        mods = m.read_bytes("wBTTypeMods", 100)
        expected = predicted_place(board, owners, ranks, card, slot, owner, mods)
        flips = {i for i in range(9) if i != slot and owners[i] != expected[1][i]}
        edges = []
        for side in range(4):
            n = dict(neighborhood(slot)).get(side)
            edges.append(signed(mods[10 * card + board[n]])
                         if n is not None and board[n] != EMPTY and owners[n] != owner else 0)
        captures.append((expected, (slot, card, owner), flips, edges))
        battled.append(any(board[n] != EMPTY and owners[n] != owner for _, n in neighborhood(slot)))

    def after_place(_):
        expected, entry, flips, edges = captures[-1]
        assert [signed(b) for b in m.read_bytes("wBTEdgeBonus", 4)] == edges
        got = m.read_bytes("wBTBoard", 9), m.read_bytes("wBTOwners", 9)
        assert expected == got, (entry, expected, got)
        score = m.read("wBTPlayerHand") + got[1].count(0)
        assert score == m.read("wBTPlayerScore")
        assert m.read("wBTMoves") == 9 - got[0].count(EMPTY)
        assert m.read("wBTPlayerHand") + m.read("wBTFoeHand") + m.read("wBTMoves") == 10
        assert m.read("wBTCaptures") == len(flips)
        assert set(i for i, marked in enumerate(m.read_bytes("wBTCapturedCells", 9)) if marked) == flips

    def foe_move_step(_):
        card = m.read("wBTProbeCard")
        slot = m.read("wBTProbeCell")
        assert m.read("wBTMode") == FOE_MOVE
        assert m.read("wBTBoard", slot) == EMPTY and m.read("wBTUsed", card) == 0
        foe_positions.append(tuple(m.read_bytes("wVirtualOAM", 2)))
        if len(foe_positions) == 1:
            # The selected face is gone from the fan, and its full art is
            # in VRAM as vertically paired tiles for the moving objects.
            face_tiles = range(card * CARD_TILES, (card + 1) * CARD_TILES)
            for row in range(3, 15):
                assert not any(tile in face_tiles and attr == 3 for tile, attr in zip(
                    m.read_bytes("wTileMap", CARD_COLS, row * 20 + 1),
                    m.read_bytes("wAttrMap", CARD_COLS, row * 20 + 1)))
            source = 0x9000 + card * CARD_TILES * 16
            first_sprite_tile = m.read("wVirtualOAM", 2)
            dest = 0x8000 + first_sprite_tile * 16
            assert h.pb.memory[0xFF40] & 0x06 == 0x06, "8x16 card objects are enabled"
            tiles = [tile for row in range(0, CARD_ROWS, 2) for col in range(CARD_COLS)
                     for tile in (row * CARD_COLS + col, (row + 1) * CARD_COLS + col)]
            for offset, tile in enumerate(tiles):
                sprite_tile = h.pb.memory[0, dest + offset * 16:dest + (offset + 1) * 16]
                card_tile = h.pb.memory[0, source + tile * 16:source + (tile + 1) * 16]
                assert sprite_tile == card_tile

    def commit_frame(_):
        foe_cursor = m.read("wBTFoeCursor")
        if m.read("wBTMode") == HAND and m.read("wBTTurn") == 1 and foe_cursor != EMPTY:
            check_foe_hand(h)
            check_right_hand(h)
            foe_selection.append(foe_cursor)
        phase = m.read("wBTAnimPhase")
        if not phase:
            return
        (board, _), (slot, card, owner), flips, edges = captures[-1]
        if phase == 7:
            # The attacking card shows the changed ranks in its owner's color.
            assert any(edges) and m.read("wBTMode") == ANIM
            assert m.read("wBTArtPatch") == card + 1
            assert m.read("wBTFaceOwners", card) == 2 + owner
            assert all(m.read("wBTFaceOwners", board[cell]) == 3 - owner for cell in flips)
            index = word(m, "wBTDeck", 2 * card)
            ranks = m.read_bytes("wBTRanks", 4, 4 * card)
            patched = build.decode_tiles(m.read_bytes("wBTArtBuffer", build.CARD_BYTES),
                                         build.CARD_WIDTH, build.CARD_HEIGHT)
            assert patched.tobytes() == badge_image(cards[index], ranks, edges).tobytes()
            matchup_shows.append(len(captures))
            flip_phases.append((len(captures), owner, phase, None))
            return
        assert flips and m.read("wBTMode") == ANIM
        narrow = phase in (2, 4, 6)
        width = m.read("wBTFlipWidth") if narrow else None
        assert m.read("wBTFlipSlot") == (len(flips) if narrow else 0)
        for index, cell in enumerate(sorted(flips)):
            at = board_tile(cell)
            for row in range(CARD_ROWS):
                attrs = m.read_bytes("wAttrMap", CARD_COLS, at + row * 20)
                card_tiles = [attr < 8 for attr in attrs]
                assert card_tiles == [not narrow and phase != 3] * CARD_COLS
            if narrow:
                y, x = 40 + (cell // 3) * 32, 52 + (cell % 3) * 24
                tile = 96 + 8 * width if phase == 4 else index * 24 + 8 * width
                palette = 6 if phase == 4 else index
                assert m.read_bytes("wVirtualOAM", 4, index * 32) == bytes((y, x, tile, palette))
                if phase != 4:
                    paper_palette = 4 + (1 - owner if phase == 2 else owner)
                    assert m.read_bytes("wVirtualOAM", 4, index * 32 + 16) == bytes((
                        y, x, 120 + 8 * width, paper_palette))
            elif phase != 3:
                paper = 3 - owner if phase == 1 else 2 + owner
                assert m.read("wBTFaceOwners", board[cell]) == paper
        flip_phases.append((len(captures), owner, phase, width))

    def play_sound(_):
        if m.read("wCurSFX") == sfx["SFX_DAMAGE"]:
            hits.append(len(captures))
        if m.read("wBTMode") == ANIM:
            capture_sounds.append((len(captures), m.read("wCurSFX")))

    def set_flag(name, value=True):
        flag = events[name]
        byte = m.read("wEventFlags", flag // 8)
        byte = byte | 1 << flag % 8 if value else byte & ~(1 << flag % 8)
        m.write("wEventFlags", byte, flag // 8)

    def warp(name, x, y):
        group, number = location(name)
        for symbol, value in (("wDefaultSpawnpoint", 255), ("wMapGroup", group),
                              ("wMapNumber", number), ("wXCoord", x), ("wYCoord", y),
                              ("hMapEntryMethod", 0xF1)):
            m.write(symbol, value)
        native_call(h, "EnterMap")
        begin_native_call(h, "OverworldLoop.loop")
        h.tick(40)

    try:
        new_game(h, 0)
        group, number = location("GOLDENROD_GAME_CORNER")
        warp("GOLDENROD_GAME_CORNER", 14, 9)
        assert m.read_bytes("wCoins", 2) == bytes(2)
        assert sum(m.read_bytes("wBeastTriadCollection", len(keys))) == 0
        starter_deck = [keys.index(name) for name in build.STARTERS]
        entry_decks = []
        songs = []

        def at_table(_):
            entry_decks.append(read_deck(m))
            map_before.append(map_snapshot())

        h.pb.hook_register(*h.sym["_BeastTriad"], at_table, None)
        h.pb.hook_register(*h.sym["PlayMusic"], lambda _: songs.append(h.pb.register_file.E), None)
        # The player is a tile below the host. A real directional input
        # and A exercise object discovery as well as the script itself.
        key(h, "up")
        for _ in range(100):
            if entry_decks:
                break
            key(h, "a", wait=12)
        else:
            raise AssertionError("The Game Corner host did not start a match")
        assert entry_decks == [starter_deck], "The deck must exist before opening the first match"

        def player_ready():
            return m.read("wBTMode") == HAND and m.read("wBTTurn") == 0

        await_state(h, player_ready, "starter match without a draft")
        h.tick(14)
        assert songs[-1] == music["MUSIC_BEAST_TRIAD_DUEL"], "Table matches play Duel Theme 1"
        assert word(m, "wBTFoeCard") == NONE
        assert read_deck(m, "wBTDeck") == starter_deck
        counts = m.read_bytes("wBeastTriadCollection", len(keys))
        assert [i for i,q in enumerate(counts) if q] == sorted(starter_deck)
        assert sum(counts) == 5
        case_item = h.con.item_id("CARD_CASE")
        keys_in_bag = m.read_bytes("wKeyItems", m.read("wNumKeyItems"))
        assert case_item in [m.item_index_of(item) for item in keys_in_bag]
        check_right_hand(h)
        for button in ("down", "down", "down", "down", "down", "up"):
            settled_frames(h, button)
            check_right_hand(h)
            check_palette_frame(h, cards)
        check_foe_hand(h)
        check_palette_frame(h, cards)
        foe_slots = [slot for slot, used in enumerate(m.read_bytes("wBTUsed", 5, 5)) if not used]
        for slot in [*foe_slots, EMPTY]:
            settled_frames(h, "select")
            assert m.read("wBTFoeCursor") == slot
            check_foe_hand(h)
            check_palette_frame(h, cards)

        quit_frames(h)
        assert m.read("wBTMode") == EXIT
        check_map_restored("quit", map_before[-1])
        before_case = map_snapshot()

        # The Card Case is one list: five deck rows, then the trunk.
        bulbasaur, charmander, squirtle, mareep, hoothoot = starter_deck
        pikachu, nidoran_f, nidoran_m, crystal = (keys.index(k) for k in
                                                  ("PIKACHU", "NIDORAN_F", "NIDORAN_M", "CRYSTAL"))
        for card in (pikachu, nidoran_f, nidoran_m, crystal):
            m.write("wBeastTriadCollection", 1, card)
        m.write("wBeastTriadCollection", 2, mareep)
        songs.clear()
        open_case_from_bag(h)
        assert not songs, "The Card Case keeps the map's music"

        def case_state():
            count = word(m, "wBTCaseCount")
            trunk = [word(m, "wBTTrunk", 2 * i) for i in range(count - 5)]
            return word(m, "wBTCasePos"), word(m, "wBTCaseHeld"), trunk

        assert case_state() == (0, NONE, [pikachu, nidoran_f, nidoran_m, mareep, crystal])
        assert word(m, "wBTPreviewCard") == bulbasaur
        assert check_palette_frame(h, cards) == 1
        h.pb.screen.image.save(str(output / "card-case.png"))
        for button in ("down", "down", "up", "right", "down", "left"):
            settled_frames(h, button)
        assert case_state()[0] == 0
        key(h, "up")
        assert case_state()[0] == 9, "Up from the first row wraps to the end of the trunk"
        key(h, "down")
        assert case_state()[0] == 0

        # Swap a deck card with a trunk card.
        key(h, "a")
        assert case_state()[1] == 0 and word(m, "wBTHeldCard") == bulbasaur
        key(h, "right")
        assert case_state()[0] == 5
        assert check_palette_frame(h, cards) == 2
        h.pb.screen.image.save(str(output / "card-case-held.png"))
        key(h, "a")
        assert read_deck(m) == [pikachu, charmander, squirtle, mareep, hoothoot]
        assert case_state() == (0, NONE, [bulbasaur, nidoran_f, nidoran_m, mareep, crystal])

        # A spare second copy can join the deck beside the first.
        key(h, "right")
        for _ in range(3):
            key(h, "down")
        assert case_state()[0] == 8 and word(m, "wBTPreviewCard") == mareep
        key(h, "a")
        key(h, "left")
        assert case_state()[0] == 0
        key(h, "down")
        key(h, "a")
        assert read_deck(m) == [pikachu, mareep, squirtle, mareep, hoothoot]
        assert case_state() == (1, NONE, [bulbasaur, charmander, nidoran_f, nidoran_m, crystal])

        # Reorder the deck, then pick up two trunk cards in turn and drop.
        key(h, "a")
        key(h, "up")
        key(h, "a")
        edited_deck = [mareep, pikachu, squirtle, mareep, hoothoot]
        assert read_deck(m) == edited_deck
        key(h, "right")
        key(h, "a")
        key(h, "down")
        key(h, "a")
        assert case_state()[:2] == (6, 6), "A on a second trunk card picks it up instead"
        key(h, "b")
        assert case_state()[1] == NONE and m.read("wBTMode") == CASE
        assert read_deck(m) == edited_deck

        for species in ("NIDORAN_F", "NIDORAN_M", "CRYSTAL"):
            target = keys.index(species)
            for _ in range(10):
                if word(m, "wBTPreviewCard") == target:
                    break
                key(h, "down")
            assert word(m, "wBTPreviewCard") == target
            h.tick(4)
            assert check_palette_frame(h, cards) == 1
            h.pb.screen.image.crop((120,24,144,56)).save(str(output / f"{species.lower()}-card.png"))
        quit_frames(h)
        assert m.read("wBTMode") == EXIT
        check_map_restored("case", before_case)

        for name, handler in (("BeastTriadPlace", before_place), ("BeastTriadAfterMove", after_place),
                              ("BeastTriadMoveFoeCard.step", foe_move_step),
                              ("BeastTriadCommitFrame", commit_frame), ("_PlaySFX", play_sound)):
            h.pb.hook_register(*h.sym[name], handler, None)

        key(h, "a", wait=30)
        await_state(h, player_ready, "repeat visit did not start with the edited deck")
        h.tick(12)
        assert entry_decks == [starter_deck, edited_deck]
        assert read_deck(m, "wBTDeck") == edited_deck
        assert m.read_bytes("wBTRanks", 4) == bytes(cards[mareep].ranks)
        assert check_palette_frame(h, cards) >= 5
        h.pb.screen.image.save(str(output / "beast-triad-gameplay.png"))

        states = m.read_bytes("wBTBoard", 9)
        key(h, "a")
        assert m.read("wBTMode") == HELD
        check_right_hand(h)
        for target in range(9):
            if states[target] == EMPTY:
                navigate(h, target)
            assert m.read_bytes("wBTBoard", 9) == states
        for button in ("right", "down", "left", "up"):
            settled_frames(h, button)
        free = states.index(EMPTY)
        navigate(h, free)
        addr = board_tile(free)
        assert m.read("wAttrMap", addr) == 4 + free % 3
        assert m.read("wTileMap", addr) == CARD_TILES * m.read("wBTHandCursor")
        h.tick(4)
        assert check_palette_frame(h, cards) >= 5
        h.pb.screen.image.save(str(output / "held-card.png"))
        key(h, "b")
        assert m.read("wBTMode") == HAND and m.read_bytes("wBTBoard", 9) == states

        # Stage clear rank gaps to exercise the real prize and save path.
        m.write_bytes("wBTRanks", [10] * 20 + [1] * 20)
        owned_before = sum(m.read_bytes("wBeastTriadCollection", len(keys)))
        tested_taken = False
        for _ in range(5):
            if m.read("wBTMode") in (PICK, RESULT):
                break
            await_state(h, player_ready, "player turn")
            h.tick(4)  # Let the turn transition reach the input loop.
            key(h, "a")
            assert m.read("wBTMode") == HELD, h.where(8)
            states = m.read_bytes("wBTBoard", 9)
            if states.count(EMPTY) < 9:
                # Every direction skips taken cells, from every free cell.
                for start in [i for i, card in enumerate(states) if card == EMPTY]:
                    navigate(h, start)
                    for button in BUTTONS:
                        press_direction(h, button)
                        navigate(h, start)
                tested_taken = True
            free = [i for i, card in enumerate(states) if card == EMPTY]
            owners = m.read_bytes("wBTOwners", 9)
            target = max(free, key=lambda i: sum(owners[n] == 1 for _, n in neighborhood(i)))
            navigate(h, target)
            if len(free) <= 2:
                steady_frames(h, "a", count=210)
            else:
                key(h, "a", wait=20)
            await_state(h, lambda: player_ready() or m.read("wBTMode") in (PICK, RESULT), "AI response")
            if player_ready():
                check_foe_hand(h)
                check_right_hand(h)
        assert m.read("wBTMode") == PICK, "A win lets the player pick a prize"
        assert songs[-1] == music["MUSIC_BEAST_TRIAD_VICTORY"]
        assert m.read("wBTMoves") == len(captures) == 9
        assert tested_taken and m.read("wBTPlayerScore") > 5
        assert sum(m.read_bytes("wBeastTriadCollection", len(keys))) == owned_before
        h.tick(12)
        assert check_palette_frame(h, cards) >= 9
        check_right_hand(h)
        h.pb.screen.image.save(str(output / "match-pick.png"))
        key(h, "down")
        key(h, "down")
        key(h, "up")
        assert m.read("wBTPickCursor") == 1
        check_palette_frame(h, cards)
        check_right_hand(h)
        prize = word(m, "wBTDeck", 2 * (5 + 1))
        prize_count = m.read("wBeastTriadCollection", prize)
        key(h, "a")
        assert m.read("wBTMode") == RESULT and word(m, "wBTReward") == prize
        owned = m.read_bytes("wBeastTriadCollection", len(keys))
        assert owned[prize] == prize_count + 1 and sum(owned) == owned_before + 1
        h.tick(12)
        assert check_palette_frame(h, cards) == 9 + m.read("wBTPlayerHand") + m.read("wBTFoeHand")
        h.pb.screen.image.save(str(output / "match-result.png"))
        saved_result = BytesIO()
        h.pb.save_state(saved_result)
        quit_frames(h)
        check_map_restored("finished-match", map_before[-1])
        saved_result.seek(0)
        h.pb.load_state(saved_result)
        assert steady_frames(h, "a") >= 3, "The rematch clears the table before dealing"
        await_state(h, player_ready, "rematch without a draft")
        h.tick(4)
        assert read_deck(m, "wBTDeck") == edited_deck
        assert songs[-1] == music["MUSIC_BEAST_TRIAD_DUEL"]
        m.write_bytes("wBTRanks", [1] * 20 + [10] * 20)
        key(h, "a")
        navigate(h, 4)
        key(h, "a", wait=0)
        await_state(h, lambda: m.read("wBTAnimPhase") == 5, "opponent capture reveal")
        h.tick(2)
        assert check_palette_frame(h, cards) >= 5
        h.pb.screen.image.save(str(output / "foe-capture.png"))
        await_state(h, player_ready, "after opponent capture")
        expected_flips = [(i, entry[2], phase, width)
                          for i, (_, entry, flips, edges) in enumerate(captures, 1)
                          for phase, width in (((7, None),) if any(edges) else ()) + (flip if flips else ())]
        assert flip_phases == expected_flips
        assert {owner for _, owner, _, _ in flip_phases} == {0, 1}
        assert hits == [i for i, ((_, _, _, edges), fought) in enumerate(zip(captures, battled), 1)
                        if fought and not any(edges)], "neutral attacks get the usual battle hit"
        reveal = (sfx["SFX_BEAST_TRIAD_CAPTURE"], sfx["SFX_BEAST_TRIAD_CAPTURED"])
        matchup_sound = lambda edges: sfx["SFX_NOT_VERY_EFFECTIVE"] if -1 in edges and 1 not in edges \
            else sfx["SFX_SUPER_EFFECTIVE"]
        assert capture_sounds == [sound for i, (_, entry, flips, edges) in enumerate(captures, 1)
                                  for sound in ([(i, matchup_sound(edges))] if any(edges) else [])
                                  + ([(i, sfx["SFX_BEAST_TRIAD_FLIP"]), (i, reveal[entry[2]])] if flips else [])]

        # Lose the rest of the match: the foe claims the strongest card.
        for _ in range(5):
            if m.read("wBTMode") == RESULT:
                break
            await_state(h, lambda: player_ready() or m.read("wBTMode") == RESULT, "player turn")
            if m.read("wBTMode") == RESULT:
                break
            h.tick(4)
            key(h, "a")
            key(h, "a", wait=20)
        await_state(h, lambda: m.read("wBTMode") == RESULT, "lost match")
        # Wait for the loss screen after the result handler repairs the deck.
        h.tick(12)
        assert m.read("wBTPlayerScore") < 5
        assert songs[-1] == music["MUSIC_BEAST_TRIAD_LOSS"]
        lost = word(m, "wBTLost")
        powers = [sum(m.read_bytes("wBTRanks", 4, 4 * i)) for i in range(5)]
        assert lost == read_deck(m, "wBTDeck")[powers.index(max(powers))]
        owned = bytearray(owned)
        owned[lost] -= 1
        assert m.read_bytes("wBeastTriadCollection", len(keys)) == bytes(owned)
        deck = read_deck(m)
        assert all(deck.count(card) <= owned[card] for card in deck), "the deck stays legal"
        h.pb.screen.image.save(str(output / "match-lost.png"))
        edited_deck = deck
        quit_frames(h)
        assert m.read("wBTMode") == EXIT
        check_map_restored("rematch", map_before[-1])

        open_case_from_bag(h)
        assert m.read_bytes("wBeastTriadCollection", len(keys)) == bytes(owned)
        assert read_deck(m) == edited_deck
        quit_frames(h)
        assert m.read("wBTMode") == EXIT

        save_continue(h, location("GOLDENROD_GAME_CORNER"))
        m = h.battle.mem
        assert m.read_bytes("wBeastTriadCollection", len(keys)) == bytes(owned)
        assert read_deck(m) == edited_deck

        # An earlier Beast Triad save had valid collection data but no
        # deck block. The starter deck should appear with every card kept.
        m.write("wBeastTriadDeckReady", 0)
        begin_native_call(h, "BeastTriadGiveStarterCards")
        h.pb.memory[0xC0F0] = 0xF3
        await_state(h, lambda: h.pb.register_file.PC in (0xC0F1, 0xC0F3), "legacy deck migration")
        assert m.read_bytes("wBeastTriadCollection", len(keys)) == bytes(owned)
        assert read_deck(m) == starter_deck
        check_capture_edges(h)
        print("PASS: zero-coin NPC entry, five starters, Card Case swaps, duplicates and reordering, "
              "settled frames while moving, foe card travel, skipping taken cells, capture sounds and the full "
              "flip, picking a prize, losing a card, restored map data and VRAM, legacy migration, "
              "and save/continue.")
    finally:
        h.pb.stop(save=False)


if __name__ == "__main__":
    main()
