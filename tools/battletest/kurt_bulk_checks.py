#!/usr/bin/env python3
"""Bulk Kurt inventory, save compatibility and native leave/re-enter tests.

Fresh private cartridge state only. Native cases use real menus, movement,
door warps, NPC scripts and rendering; routine cases inspect large batches.
"""
import io
import json
from pathlib import Path

from PIL import Image, ImageDraw

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness, ROOT
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text


COLORS = [('RED', 'LEVEL'), ('BLU', 'LURE'), ('YLW', 'MOON'), ('GRN', 'FRIEND'),
          ('WHT', 'FAST'), ('BLK', 'HEAVY'), ('PNK', 'LOVE')]


def run(rom):
    h = Harness(rom_path=rom)
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    maps = map_ids()
    out = ROOT / '.tmpbuild/kurt-bulk' / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    checks, photos = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(message + '\n' + tile_text(h) + '\n' + '\n'.join(c.grid()))

    def event(name, value=None):
        bit = events[name]
        address = h.sym.addr('wEventFlags') + bit // 8
        if value is not None:
            pb.memory[address] = (pb.memory[address] | 1 << (bit % 8)) if value else (pb.memory[address] & ~(1 << (bit % 8)))
        return bool(pb.memory[address] & 1 << (bit % 8))

    def bag(pocket, stacks):
        m.write('wNum' + pocket, len(stacks))
        m.write_bytes('w' + pocket, [v for kind, n in stacks for v in ((kind >> 8, kind & 255, n) if pocket == "Items" else (kind, n))] + [255])

    def contents(pocket):
        width = 3 if pocket == 'Items' else 2
        return [((m.read('w' + pocket, width * i) << 8 | m.read('w' + pocket, width * i + 1)) if width == 3 else m.read('w' + pocket, width * i), m.read('w' + pocket, width * i + width - 1))
                for i in range(m.read('wNum' + pocket))]

    def quantity(pocket, item):
        return sum(n for kind, n in contents(pocket) if kind == item)

    def pending():
        return m.read('wKurtApricornQuantity') + (m.read('wKurtApricornQuantityHi') << 8
               if m.read('wKurtBatchMarker') == 0xA7 else 0)

    def photo(name):
        image = pb.screen.image.convert('RGB')
        image.save(out / (name + '.png'))
        photos.append((name, image))

    def reset():
        base.seek(0)
        pb.load_state(base)
        h.text_overflows.clear()

    def enter(x=3, y=3):
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=maps['KURTS_HOUSE'][0],
                               wMapNumber=maps['KURTS_HOUSE'][1], wXCoord=x, wYCoord=y,
                               hMapEntryMethod=0xF1, hOAMUpdate=0).items():
            m.write(key, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(200)

    def idle():
        return m.read('wMapStatus') == 2 and not m.read('wScriptMode') and not m.read('wScriptRunning')

    def kurt_position():
        return next((tuple(o['position']) for o in c.objects() if o['map_object'] == 1), None)

    def finish(label, cancel_picker=False):
        for _ in range(2000):
            if idle():
                h.tick(12)
                return
            # Collecting a completed batch offers the next color immediately.
            # Decline that optional new batch so this case can inspect pickup.
            text = tile_text(h) if cancel_picker else ''
            if 'CANCEL' in text and 'APRICORN' in text:
                h.press('b', hold=8, wait=32)
                h.press('a', hold=4, wait=32)
                continue
            pb.button('a', 2)
            h.tick(4)
        pc = pb.register_file.PC
        bank = m.read('hROMBank') if pc >= 0x4000 else 0
        raise RuntimeError(label + ' did not finish at ' + str(h.sym.nearest(bank, pc)) +
                           f' joy={m.read("hJoyPressed")}/{m.read("hJoyDown")} menu={m.read("wMenuJoypad")} script={m.read("wScriptMode")}/{m.read("wScriptRunning")}: ' + tile_text(h))

    def choose_apricorn(item, facing='up', cancel=False):
        h.press(facing, hold=4, wait=24)
        h.press('a', hold=4, wait=20)
        for _ in range(1400):
            text = tile_text(h)
            if 'CANCEL' in text and 'APRICORN' in text:
                break
            pb.button('a', 2)
            h.tick(4)
        else:
            raise RuntimeError('Apricorn picker did not open: ' + tile_text(h))
        h.tick(60)  # finish drawing before choosing from the live cursor
        def highlighted():
            index = m.read('wMenuScrollPosition') + m.read('wMenuCursorY') - 1
            return m.read('wBuffer1', 1 + index)
        for _ in range(8):
            if highlighted() == item:
                break
            h.press('down', hold=4, wait=20)
        check(highlighted() == item, 'selected requested color in native picker')
        tiles = m.read_bytes('wTileMap', 360)
        check(m.read('wMenuBorderRightCoord') == 17, 'Apricorn menu fits full names and four-digit totals')
        total = quantity('Items', item)
        digits = bytes(0xF6 + int(digit) for digit in str(total))
        row = 3 + 2 * (m.read('wMenuCursorY') - 1)
        check(bytes(tiles[row * 20 + 13:row * 20 + 17]).endswith(digits),
              'native menu shows complete total inside its border')
        if not cancel and not photos:
            photo('01-select-full-stack')
        h.press('b' if cancel else 'a', hold=4, wait=20)
        finish('Apricorn handoff')

    try:
        new_game(h, 0)
        event('EVENT_CLEARED_SLOWPOKE_WELL', True)
        event('EVENT_KURT_GAVE_YOU_LURE_BALL', True)
        for name in ('EVENT_GAVE_GS_BALL_TO_KURT', 'EVENT_CAN_GIVE_GS_BALL_TO_KURT', 'EVENT_FOREST_IS_RESTLESS'):
            event(name, False)
        m.write('wDailyFlags1', 0)
        base = io.BytesIO()
        pb.save_state(base)

        # All colors and count boundaries, including the bag's largest batch.
        for color, ball_name in COLORS:
            item = h.con.item_id(color + '_APRICORN')
            ball_id = h.con.item_id(ball_name + '_BALL')
            for total in (1, 99, 100, 255, 256, 999, 3960):
                reset()
                chunks = [(item, min(99, total - i)) for i in range(0, total, 99)]
                others = [(h.con.item_id('POTION'), 3)] if len(chunks) < 40 else []
                stacks = chunks[:1] + others + chunks[1:]
                bag('Items', stacks)
                m.write('wCurItem', item)
                call(h, 'Kurt_CountAllApricorns')
                check((pb.register_file.B << 8 | pb.register_file.C) == total, f'{color}/{total}: full menu count')
                call(h, 'Kurt_TakeAllApricorns')
                check(pending() == total, f'{color}/{total}: complete pending batch')
                check(contents('Items') == others, f'{color}/{total}: stable bag compaction')
                check(m.read('wItems', 3 * len(others)) == 255, f'{color}/{total}: terminator')
                check(m.read('wScriptVar') == item, f'{color}/{total}: selected color returned')

                for pocket in ([], [(h.con.item_id('POKE_BALL'), 99)] * 12,
                               [(ball_id, 98)] * 12,
                               [(ball_id, 1)] + [(h.con.item_id('POKE_BALL'), 99)] * 11):
                    bag('Balls', pocket)
                    m.write('wKurtApricornQuantity', total & 255)
                    m.write('wKurtApricornQuantityHi', total >> 8)
                    m.write('wKurtBatchMarker', 0xA7)
                    m.write('wScriptVar', ball_id)
                    available = (12 - len(pocket)) * 99 + sum(99 - n for k, n in pocket if k == ball_id)
                    received = min(total, available)
                    before = quantity('Balls', ball_id)
                    other_balls = [(k, n) for k, n in pocket if k != ball_id]
                    call(h, 'Kurt_CollectCraftedBalls')
                    check(quantity('Balls', ball_id) == before + received, f'{color}/{total}: exact pickup')
                    check(pending() == total - received, f'{color}/{total}: remainder retained')
                    check(m.read('wScriptVar') == (1 if received == total else 2 if received else 0),
                          f'{color}/{total}: full/partial/no-room result')
                    check(len(contents('Balls')) <= 12 and all(0 < n <= 99 for _, n in contents('Balls')),
                          f'{color}/{total}: legal Ball stacks')
                    check([(k, n) for k, n in contents('Balls') if k != ball_id] == other_balls,
                          f'{color}/{total}: other Balls unchanged')

        reset()
        bag('Balls', [])
        m.write('wKurtBatchMarker', 0)
        m.write('wKurtApricornQuantityHi', 255)
        m.write('wKurtApricornQuantity', 17)
        m.write('wScriptVar', h.con.item_id('LEVEL_BALL'))
        call(h, 'Kurt_CollectCraftedBalls')
        check(quantity('Balls', h.con.item_id('LEVEL_BALL')) == 17 and pending() == 0,
              'legacy single-byte batch ignores old padding')

        # A saved >255 batch must survive the ordinary save/load pipeline.
        reset()
        item = h.con.item_id('RED_APRICORN')
        bag('Items', [(item, 99)] * 3)
        m.write('wCurItem', item)
        call(h, 'Kurt_TakeAllApricorns')
        event('EVENT_GAVE_KURT_RED_APRICORN', True)
        call(h, 'SaveGameData')
        for field in ('wKurtApricornQuantity', 'wKurtApricornQuantityHi', 'wKurtBatchMarker'):
            m.write(field, 0)
        event('EVENT_GAVE_KURT_RED_APRICORN', False)
        call(h, 'TryLoadSaveFile')
        check(pending() == 297 and event('EVENT_GAVE_KURT_RED_APRICORN'), 'saved 297-Ball batch restored')
        print(rom.name + ': routine inventory/save checks passed', flush=True)

        # Cancel leaves the chosen color and NPC untouched.
        reset()
        red, blue = h.con.item_id('RED_APRICORN'), h.con.item_id('BLU_APRICORN')
        bag('Items', [(red, 9), (blue, 4)])
        bag('Balls', [])
        enter()
        choose_apricorn(red, cancel=True)
        check(contents('Items') == [(red, 9), (blue, 4)] and pending() == 0,
              'cancel consumes nothing and creates no batch')
        check(not event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1'), 'cancel does not start work')

        reset()
        bag('Items', [(red, 99)] * 40)
        enter()
        choose_apricorn(red, cancel=True)
        check(quantity('Items', red) == 3960, 'cancel maximum displayed batch preserves all Apricorns')

        # Every color uses the native picker, workbench walk, real door exit
        # and re-entry, and actual pickup. Rotate all legal approach sides.
        for i, (color, ball_name) in enumerate(COLORS):
            reset()
            item, ball_id = h.con.item_id(color + '_APRICORN'), h.con.item_id(ball_name + '_BALL')
            other = blue if color != 'BLU' else red
            bag('Items', [(item, 40), (other, 7), (item, 60)])
            bag('Balls', [])
            x, y, facing = [(3, 3, 'up'), (2, 2, 'right'), (4, 2, 'left')][i % 3]
            enter(x, y)
            choose_apricorn(item, facing)
            check(quantity('Items', item) == 0 and quantity('Items', other) == 7,
                  color + ': all selected stacks handed over; other color untouched')
            check(pending() == 100 and event('EVENT_GAVE_KURT_' + color + '_APRICORN'), color + ': 100 owed')
            check(quantity('Balls', ball_id) == 0, color + ': no same-visit reward')
            check(event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1'), color + ': work lasts until map exit')
            check(kurt_position() == (14, 3),
                  color + ': Kurt walked to actual workbench')
            if i == 0:
                c.go((14, 4))
                h.press('up', hold=4, wait=20)
                photo('02-kurt-at-workbench')
                h.press('a', hold=4, wait=20)
                finish('workbench busy dialogue')
                check(pending() == 100 and quantity('Balls', ball_id) == 0, 'same-visit workbench stays busy')
            c.go((3, 6))
            for _ in range(20):
                if c.map_id() != maps['KURTS_HOUSE']:
                    break
                h.press('down', hold=4, wait=36)
            check(c.map_id() == maps['AZALEA_TOWN'], color + ': walked through exit')
            h.tick(100)
            for _ in range(20):
                if c.map_id() == maps['KURTS_HOUSE']:
                    break
                h.press('up', hold=4, wait=36)
            h.tick(160)
            check(c.map_id() == maps['KURTS_HOUSE'] and not event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1'),
                  color + ': re-entry ends work without a daily wait')
            check(kurt_position() == (3, 2),
                  color + ': Kurt returned to usual spot')
            c.go((3, 3))
            h.press('up', hold=4, wait=20)
            if i == 0:
                photo('03-back-at-usual-spot')
                bag('Balls', [(h.con.item_id('POKE_BALL'), 99)] * 12)
                h.press('a', hold=4, wait=20)
                finish('full pocket pickup')
                check(pending() == 100 and event('EVENT_GAVE_KURT_RED_APRICORN'), 'full pocket retains entire batch')
                bag('Balls', [])
            h.press('a', hold=4, wait=20)
            finish('finished Ball pickup', cancel_picker=True)
            check(quantity('Balls', ball_id) == 100 and pending() == 0, color + ': correct 100 crafted Balls')
            check(not event('EVENT_GAVE_KURT_' + color + '_APRICORN'), color + ': reward cannot repeat')
            check(not h.text_overflows, color + ': native dialogue stays in bounds ' + repr(h.text_overflows[:8]))
            if i == 0:
                h.press('start', hold=4, wait=80)
                for _ in range(12):
                    if m.read('wMenuSelection') == 2:
                        break
                    h.press('down', hold=4, wait=20)
                h.press('a', hold=4, wait=120)
                for _ in range(4):
                    if m.read('wCurPocket') == 1:
                        break
                    h.press('right', hold=4, wait=80)
                photo('04-batch-collected')
            print(rom.name + ': native ' + color + ' handoff/walk/exit/re-entry/pickup passed', flush=True)

        gallery = Image.new('RGB', (160 * len(photos), 166), '#eef0f2')
        draw = ImageDraw.Draw(gallery)
        for i, (name, image) in enumerate(photos):
            draw.text((i * 160 + 3, 4), name[3:].replace('-', ' '), fill='#17212b')
            gallery.paste(image, (i * 160, 22))
        gallery.resize((gallery.width * 2, 332), Image.Resampling.NEAREST).save(out / 'gallery.png')
        result = dict(rom=rom.name, checks=checks, native_colors=7, failures=0)
        (out / 'results.json').write_text(json.dumps(result, indent=2) + '\n')
        print(json.dumps(result), flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    import sys
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        run(rom)
