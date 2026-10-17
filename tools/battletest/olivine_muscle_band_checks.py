#!/usr/bin/env python3
"""Native Olivine Port gift, full-Bag retry, repeat text and icon animation.

Uses a private New Game; the player's save is never opened or written.
"""
import io
import json

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from runner import Harness
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    h = Harness()
    pb, m = h.pb, h.battle.mem
    c = Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    fields = _parse_constants(ROOT / 'constants/map_object_constants.asm')
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    flag = flags['EVENT_GOT_MUSCLE_BAND_FROM_OLIVINE_SAILOR']
    band = h.con.item_id('MUSCLE_BAND')
    output = ROOT / '.tmpbuild/olivine-muscle-band'
    output.mkdir(parents=True, exist_ok=True)
    texts = []
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def event():
        return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))

    def quantity():
        return sum(m.read('wItems', i*2+1) for i in range(m.read('wNumItems'))
                   if m.read('wItems', i*2) == band)

    def obj(index):
        return next((o for o in c.objects() if o['map_object'] == index), None)

    def machamp_graphics():
        used = m.read_bytes('wUsedSprites', 64)
        matches = [used[i+1] for i in range(0, len(used), 2)
                   if used[i] == sprites['SPRITE_MACHAMP']]
        check(len(matches) == 1, 'Machamp missing from the outdoor graphics allocation list')
        tile = matches[0]
        check(tile > 6, 'Machamp graphics were not assigned VRAM space')
        live_tile = m.read('wObjectStructs', obj(9)['slot']*40+fields['OBJECT_SPRITE_TILE'])
        check(live_tile == tile, 'Machamp object is using fallback/player tiles')
        check(live_tile != m.read('wPlayerStruct', fields['OBJECT_SPRITE_TILE']),
              'Machamp shares the player graphics allocation')
        vbank = 0 if tile & 0x80 else 1
        address = 0x8000+(tile & 0x7f)*16
        expected = (ROOT/'gfx/icons/machamp.2bpp').read_bytes()
        check(bytes(pb.memory[vbank, address:address+len(expected)]) == expected,
              'Machamp VRAM pixels do not match both frames of gfx/icons/machamp')
        return tile

    def text(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        texts.append((bank, pb.memory[bank, address] | pb.memory[bank, address+1] << 8))

    def enter():
        group, number = map_ids()['OLIVINE_PORT']
        for name, value in [('wMapGroup', group), ('wMapNumber', number),
                            ('wXCoord', 8), ('wYCoord', 10), ('hMapEntryMethod', 0xf1)]:
            m.write(name, value)
        # Staging bypasses the opening dialogue's return path. Release its
        # OAM lock so this private fixture enters ordinary overworld drawing.
        m.write('hOAMUpdate', 0)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(c.map_id() == (group, number), 'Olivine Port entry failed')

    def talk():
        texts.clear()
        c.press('up', hold=4, wait=24)
        check(c.position() == (8, 10), 'Sailor does not block his own tile')
        c.press('a', hold=4, wait=40)
        for _ in range(220):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                break
            c.press('a', hold=4, wait=24)
        else:
            raise AssertionError('Sailor dialogue did not finish: '+tile_text(h))
        check(m.read('wObjectStructs', obj(8)['slot']*40+fields['OBJECT_FACING'])
              == fields['FACING_STEP_RIGHT_0'], 'Sailor did not return to facing right')
        return texts.copy()

    try:
        new_game(h, 0)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 0xc1)
        enter()
        check(obj(8) is not None and obj(8)['position'] == [8, 9]
              and obj(8)['sprite'] == sprites['SPRITE_SAILOR'], 'Sailor is missing or misplaced')
        check(obj(9) is not None and obj(9)['position'] == [9, 9]
              and obj(9)['sprite'] == sprites['SPRITE_MACHAMP'], 'Machamp is missing or misplaced')
        tile = machamp_graphics()
        check(m.read('wObjectStructs', obj(8)['slot']*40+fields['OBJECT_FACING'])
              == fields['FACING_STEP_RIGHT_0'], 'Sailor initially faces the wrong direction')
        frames = set()
        drawn_frames = set()
        rendered = {}
        screen_frames = []
        last_phase, stable = None, 0
        slot = obj(9)['slot']
        for tick in range(120):
            h.tick(1)
            if tick % 4 == 0:
                screen_frames.append(pb.screen.image.copy())
            frames.add(m.read('wObjectStructs', slot*40+fields['OBJECT_FACING_STEP']))
            oam = m.read_bytes('wVirtualOAM', 160)
            tiles = {oam[i+2]-(tile & 0x7f) for i in range(0, 160, 4)
                     if (oam[i+3] & 8) == (0 if tile & 0x80 else 8)
                     and (tile & 0x7f) <= oam[i+2] < (tile & 0x7f)+8}
            if tiles == {0, 1, 2, 3}:
                drawn_frames.add(0)
                phase = 0
            elif tiles == {4, 5, 6, 7}:
                drawn_frames.add(1)
                phase = 1
            else:
                phase = None
            stable = stable+1 if phase == last_phase else 1
            last_phase = phase
            # Screen pixels can trail virtual OAM by a frame; capture only
            # after the same tile frame has been selected for four ticks.
            if phase is not None and stable >= 4 and phase not in rendered:
                rendered[phase] = pb.screen.image.copy()
        check(frames == {fields['FACING_STEP_DOWN_0'], fields['FACING_STEP_UP_0']},
              f'Machamp does not alternate its icon frames: {frames}')
        check(obj(9)['position'] == [9, 9], 'Machamp moves off its tile while animating')
        check(drawn_frames == {0, 1}, f'Machamp icon frames are not actually drawn: {drawn_frames}')
        check(len({picture.crop((76, 36, 100, 64)).tobytes() for picture in screen_frames}) > 1,
              'Machamp displayed pixels never change')
        for frame, picture in rendered.items():
            picture.resize((640, 576)).save(output/f'machamp-frame-{frame}.png')
        animation = [picture.resize((640, 576)) for picture in screen_frames]
        animation[0].save(output/'machamp-icon-fixed.gif', save_all=True,
                          append_images=animation[1:], duration=67, loop=0)
        pb.screen.image.resize((640, 576)).save(output / 'port-sailor-machamp-fixed.png')
        prepared = io.BytesIO()
        pb.save_state(prepared)
        pb.hook_register(*h.sym['Script_writetext'], text, None)
        try:
            bank, address = h.sym['ItemAttributes']
            stock = [item for item in range(1, 194) if item != band
                     and pb.memory[bank, address+(item-1)*7+5] == 1][:40]
            check(len(stock) == 40, 'Cannot construct full item pocket')
            m.write('wNumItems', 40)
            m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1))+b'\xff')
            talk()
            check(not event() and quantity() == 0, 'Full Bag consumes or grants the one-time gift')
            machamp_graphics()
            print('PASS full Bag leaves the gift available', flush=True)

            prepared.seek(0)
            pb.load_state(prepared)
            m.write('wNumItems', 0)
            m.write_bytes('wItems', [255])
            said = talk()
            check(event() and quantity() == 1, 'First conversation does not award exactly one Muscle Band')
            check(h.sym['OlivinePortMuscleBandSailorGiftText'] in said
                  and h.sym['OlivinePortMuscleBandSailorReceivedText'] in said
                  and h.sym['OlivinePortMuscleBandSailorAfterText'] not in said,
                  'First conversation uses the wrong text sequence')
            said = talk()
            check(said == [h.sym['OlivinePortMuscleBandSailorAfterText']] and quantity() == 1,
                  'Repeat conversation repeats the gift or uses the wrong text')
            machamp_graphics()
            enter()
            said = talk()
            check(event() and quantity() == 1
                  and said == [h.sym['OlivinePortMuscleBandSailorAfterText']],
                  'Map re-entry loses the gift flag or duplicates the reward')
            check(obj(8) is not None and obj(9) is not None, 'Sailor or Machamp disappears after the gift')
            machamp_graphics()
            print('PASS first gift, follow-up dialogue and map re-entry', flush=True)
        finally:
            pb.hook_deregister(*h.sym['Script_writetext'])
        check(flag == 0x1ab, 'Gift did not reuse the unused saved event bit')
        for name, expected in {'wEventFlags': 0xdab0, 'wCurBox': 0xdbb9,
                               'wGameDataEnd': 0xdff3, 'sSaveDataEnd': 0xac36}.items():
            check(h.sym.addr(name) == expected, 'Save layout shifted: '+name)
        (output / 'results.json').write_text(json.dumps({'checks': checks, 'animation_frames': sorted(frames)}, indent=2)+'\n')
        print(f'OLIVINE MUSCLE BAND: {checks} checks passed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
