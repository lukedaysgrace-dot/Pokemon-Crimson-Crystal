#!/usr/bin/env python3
"""Native summary/PC regression checks; only private emulator state is used.

Usage: PC_UI_OUT=_artifacts/summary-review .venv/bin/python tools/test_summary_ui.py ROM
"""
import hashlib
import json
import os
import sys
from pathlib import Path

from PIL import Image, ImageDraw
import pc_harness

record_video = bool(os.environ.get('SUMMARY_RECORD'))
if record_video:
    original_pyboy = pc_harness.PyBoy

    def audio_pyboy(*args, **kwargs):
        kwargs.update(sound_emulated=True, sound_sample_rate=48000)
        return original_pyboy(*args, **kwargs)

    pc_harness.PyBoy = audio_pyboy

import pc_ui_harness as u
from pc_harness import dec
sys.path.insert(0, str(Path(__file__).resolve().parent / 'battletest'))
from symbols import _parse_constants

out = Path(u.OUT)
checks = 0
transitions = []
commit_scanlines = []


def observe_commit(_):
    commit_scanlines.append(u.h.rd(0xff44))


u.py.hook_register(*u.h.sym['StatsScreen_CommitPage.complete'], observe_commit, None)


def read(name, n=1):
    # A frame can end inside the animation/HDMA helpers with WRAM3 selected.
    bank, addr = u.h.sym[name]
    old = u.h.rd(0xff70)
    if 0xd000 <= addr < 0xe000:
        u.h.wr(0xff70, bank)
    value = u.h.rd(addr, n)
    u.h.wr(0xff70, old)
    return value


def check(ok, label):
    global checks
    checks += 1
    if not ok:
        u.py.screen.image.save(out / 'failure.png')
        raise AssertionError(f'{label}; PC={u.h.reg.PC:04x}')


def text(x, y, n):
    return dec(u.h.rd(u.S('wTileMap') + y * 20 + x, n))


def capture(label):
    u.py.screen.image.convert('RGB').resize((480, 432)).save(out / f'{label}.png')


def check_category_background():
    pals = read('wBGPals1', 64)
    check(pals[7 * 8:7 * 8 + 2] == pals[3 * 8:3 * 8 + 2], 'category background matches green box')
    check(pals[6 * 8:6 * 8 + 2] == pals[3 * 8:3 * 8 + 2], 'type pill padding matches green box')
    check(pals[:8] == header_palette, 'move details preserve header and HP palette')
    tile = read('wTileMap', 360)[13 * 20 + 1]
    category = (0x5d, 0x79, 0x7d).index(tile)
    art = (Path(pc_harness.ROOT) / 'gfx/battle/categories.2bpp').read_bytes()[category * 32:(category + 1) * 32]
    frame = u.py.screen.image.convert('RGB')
    green = frame.getpixel((8, 96))
    for x in range(16):
        for y in range(8):
            offset = (x // 8) * 16 + y * 2
            mask = 1 << (7 - x % 8)
            if not ((art[offset] | art[offset + 1]) & mask):
                check(frame.getpixel((8 + x, 104 + y)) == green,
                      f'category {category} padding pixel {x},{y} renders green')
    capture(f'move-detail-category-{category}')


def press(button, wait=80):
    u.press(button, hold=2, wait=wait)


def transition(button, label, wait=48):
    """Keep every distinct native frame, including intermediate palette shifts."""
    images = []
    previous = None
    def panels(im):
        return im.crop((56, 0, 160, 56)).tobytes() + im.crop((0, 56, 160, 144)).tobytes()
    old_panels = panels(u.py.screen.image.convert('RGB'))
    u.py.button_press(button)
    for frame in range(wait):
        if frame == 2:
            u.py.button_release(button)
        u.frames(1)
        im = u.py.screen.image.convert('RGB').copy()
        digest = hashlib.sha256(im.tobytes()).hexdigest()
        if digest != previous:
            images.append((frame, im))
            previous = digest
    sheet = Image.new('RGB', (160 * min(6, len(images)), 160 * ((len(images) + 5) // 6)), 'white')
    draw = ImageDraw.Draw(sheet)
    for i, (frame, im) in enumerate(images):
        x, y = (i % 6) * 160, (i // 6) * 160
        sheet.paste(im, (x, y + 16))
        draw.text((x + 2, y + 2), f'{label}: frame {frame}', fill='black')
    sheet.save(out / f'transition-{label}.png')
    new_panels = panels(images[-1][1])
    mixed = [f for f, im in images if panels(im) not in (old_panels, new_panels)]
    transitions.append({'label': label, 'distinct_frames': [f for f, _ in images], 'mixed_frames': mixed})
    check(not mixed, f'{label}: no mixed palettes, maps, graphics or sprites (frames {mixed})')


def page(n):
    check(u.h.rd(u.S('wcf64')) & 7 == n, f'page {n} selected')
    check(text(2, 7, len(['INFO', 'STATS', 'MOVES', 'MEMO'][n - 1])) ==
          ['INFO', 'STATS', 'MOVES', 'MEMO'][n - 1], f'page {n} title')
    for y in range(8, 17):
        check(u.h.rd(u.S('wTileMap') + y * 20) == 0x39, f'page {n} left border row {y}')
        check(u.h.rd(u.S('wTileMap') + y * 20 + 19) == 0x3a, f'page {n} right border row {y}')
    check(u.h.rd(u.S('wVirtualOAMSprite08')) == (96 if n == 4 else 0), 'memo ball visibility')


def open_summary(pos):
    u.goto(pos)
    press('a', 30)
    press('down', 10)
    press('a', 150)
    check(u.h.rd(u.S('wJumptableIndex')) == 6, 'summary accepts input')


def close_summary(pos):
    press('b', 150)
    check(u.pos() == pos, f'PC cursor restored to {pos:02x}')
    check(u.h.rd(u.S('hLCDCPointer')) == 0xff, 'PC raster handler restored')
    check(u.h.rd(u.S('hOAMUpdate')) == 0, 'PC OAM updates restored')
    check(u.h.rd(u.S('hBGMapMode')) == 1, 'PC background updates restored')
    capture(f'pc-return-{pos:02x}')


u.setup_default()
move_indexes = _parse_constants(Path(pc_harness.ROOT) / 'constants/move_constants.asm')
u.h.call('GetStorageBoxMon', bc=0x101)
for i, name in enumerate(('FLAMETHROWER', 'THUNDERBOLT', 'DRAGON_CLAW', 'RECOVER')):
    move_id = u.h.move_id(move_indexes[name])
    u.h.wr(u.S('wTempMonMoves') + i, move_id)
u.h.call('UpdateStorageBoxMonFromTemp')
party_before = read('wPartyMon1', 2 * 50)
u.enter()
u.frames(180)
recording = None
if record_video:
    from record_lance_escort_scenes import Recording
    recording = Recording(u.py, out / 'summary-pc-showcase.mp4')
    base_frames = u.frames

    def recording_frames(n, label=None):
        done = False
        for _ in range(n):
            done = base_frames(1)
            recording.append()
        if label:
            u.py.screen.image.save(out / f'{label}.png')
        return done

    u.frames = recording_frames
box_before = read('wBillsPC_BoxList', 40)
open_summary(0x12)
page(1)
capture('box-info')
for n in (2, 3, 4, 1):
    transition('right', f'box-to-{n}')
    page(n)
    capture(f'box-page-{n}')
transition('left', 'wrap-left')
page(4)
press('left'); page(3)
check([read('wAttrMap', 360)[(9 + 2 * i) * 20 + 2] for i in range(4)] == [5, 6, 7, 2],
      'four distinct move types use four independent palettes')
header_palette = read('wBGPals1', 8)
press('a')
check_category_background()
check(u.h.rd(u.S('wVirtualOAMSprite05')) == 80, 'move detail cursor begins at move 1')
for i in (1, 2, 3, 0):
    transition('down', f'move-detail-{i}')
    check(u.h.rd(u.S('wMenuCursorY')) == i, 'move detail wraps')
    check(u.h.rd(u.S('wVirtualOAMSprite05')) == 80 + 8 * i, 'move detail cursor row')
    check_category_background()
capture('move-detail')
press('b'); page(3)
check(u.h.rd(u.S('wVirtualOAMSprite05')) == 0, 'move cursor cleared')
press('left'); page(2)
capture('hp-after-move-detail')
for slot in (2, 3):
    press('down', 160)
    page(2)
    check(read('wTempMonSlot') == slot, f'box summary browses slot {slot}')
press('down', 160)
check(text(8, 1, 3) == 'EGG', 'box egg identity')
check(text(2, 7, 6) == 'STATUS', 'egg title')
capture('box-egg')
press('up', 160); page(2)
close_summary(0x14)
check(read('wBillsPC_BoxList', 40) == box_before, 'summary preserves box entries')
check(read('wPartyMon1', 2 * 50) == party_before, 'box summary preserves party data')

open_summary(0x30)
for n in (1, 2, 3, 4):
    page(n)
    capture(f'party-page-{n}')
    if n < 4:
        press('right')
press('down', 160); page(4)
check(read('wTempMonSlot') == 2, 'party summary browses next member')
press('up', 160); page(4)
close_summary(0x30)
check(read('wPartyMon1', 2 * 50) == party_before, 'party summary preserves party data')

press('b', 40); press('down', 10); press('a', 100)
check(u.h.rd(u.MARKER) == 1, 'PC exits normally after summaries')
check(u.h.rd(u.S('hLCDCPointer')) == 0, 'PC raster handler removed on exit')

# PARTYMON is a different entry path from the PC's TEMPMON summaries.
def native_summary():
    u.h.wr(0xff70, 1)
    u.h.wr(u.S('wMonType'), 0)
    u.h.wr(u.S('wCurPartyMon'), 0)
    u.h.wr(u.MARKER, 0)
    bank, addr = u.h.sym['StatsScreenInit']
    u.h.set_rom_bank(bank)
    u.h.wr16(0xc0ec, 0xc0f0)
    u.h.reg.SP = 0xc0ec
    u.h.wr(u.STUB, [0xfb, 0xc3, addr & 255, addr >> 8])
    u.h.reg.PC = u.STUB
    u.frames(180)


for status, label in [(0, 'OK'), (8, 'PSN'), (16, 'BRN'), (32, 'FSB'), (64, 'PAR'), (2, 'SLP'), (0, 'FNT')]:
    u.h.wr(0xff70, 1)
    u.h.wr(u.S('wPartyMon1Status'), status)
    hp = 0 if label == 'FNT' else int.from_bytes(read('wPartyMon1MaxHP', 2), 'big')
    u.h.wr(u.S('wPartyMon1HP'), hp.to_bytes(2, 'big'))
    before = read('wPartyMon1', 100)
    native_summary()
    page(1)
    press('right'); page(2)
    check(text(15, 3, len(label)) == label, f'party status {label}')
    press('right'); page(3)
    press('a'); press('b'); page(3)
    press('left'); page(2)
    check(text(15, 3, len(label)) == label, f'party status {label} after move details')
    capture(f'native-party-{label}')
    press('b', 100)
    check(u.h.rd(u.MARKER) == 1, f'party {label} summary returned')
    check(read('wPartyMon1', 100) == before, f'party {label} data unchanged')

check(len(commit_scanlines) > 20, 'atomic page commits observed')
check(all(144 <= line <= 153 for line in commit_scanlines), f'complete commits fit VBlank: {commit_scanlines}')
video = recording.finish() if recording else None
(out / 'results.json').write_text(json.dumps({'checks': checks, 'transitions': transitions, 'commit_scanlines': commit_scanlines, 'video': video}, indent=2) + '\n')
print(f'{checks} summary/PC checks passed; captures: {out}')
