#!/usr/bin/env python3
"""Compiled Jasmine quest regression, using private in-memory cartridge state.

Text, sound, emotes and timed movement are recorded with presentation skipped.
Directional movement updates the live object coordinates so the real
writeobjectxy command can be tested. Map callbacks, script branches, inventory,
object visibility and progression events execute the ROM's native routines.
"""
from itertools import product
from pathlib import Path

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    h = Harness(rom=str(root / 'pokecrystal.gbc'), sym=str(root / 'pokecrystal.sym'))
    h.boot()
    events = _parse_constants(root / 'constants/event_flags.asm')
    items = _parse_constants(root / 'constants/item_constants.asm')
    fields = _parse_constants(root / 'constants/map_object_constants.asm')
    checks, failures = 0, []
    explained = 'EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS'
    delivered = 'EVENT_JASMINE_RECEIVED_SECRETPOTION'
    healed = 'EVENT_JASMINE_RETURNED_TO_GYM'

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)
            print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def event(name, value=None):
        result = h.call('EventFlagAction', bc=(2 if value is None else int(value)) << 8, de=events[name])
        return bool(result['c'])

    def load(group, number):
        write('wMapGroup', group)
        write('wMapNumber', number)
        write('wXCoord', 28 if group == 1 else 8)
        write('wYCoord', 28 if group == 1 else 9)
        for flag in ('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1', 'EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2'):
            event(flag, False)
        h.call('LoadMapAttributes')
        write('wObjectStructs', bytes(13 * 40))
        h.call('RunMapCallback', a=5)
        h.call('RunMapCallback', a=2)
        h.call('LoadObjectMasks')
        write('wUsedSprites', bytes(64))
        h.call('GetPlayerSprite')
        h.call('AddMapSprites')
        h.call('LoadAndSortSprites')
        h.call('InitializeVisibleSprites')

    def visible(index):
        return h.rd(h.s('wObjectMasks') + index) == 0

    def key_item(present):
        write('wNumKeyItems', int(present))
        write('wKeyItems', [items['SECRETPOTION'], 255] if present else [255])

    byte = h.s('GetScriptByte')
    consume = lambda count: bytes([0xcd, byte & 255, byte >> 8]) * count + b'\xc9'
    presentation = {name: b'\xc9' for name in (
        'Script_faceplayer', 'Script_opentext', 'Script_closetext',
        'Script_waitbutton', 'Script_buttonsound', 'Script_waitsfx',
        'MapTextbox', '_UpdateSprites', 'Script_itemnotify')}
    for name, count in (
        ('Script_applymovement', 3), ('Script_showemote', 3),
        ('Script_pause', 1), ('Script_cry', 2), ('Script_special', 2),
        ('Script_playmusic', 2), ('Script_playsound', 2)):
        presentation[name] = consume(count)

    def script(name, yes=True):
        texts, movements, emotes = [], [], []
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        with patches(h, {'YesNoBox': b'\xaf\xc9' if yes else b'\x37\xc9'}):
            for _ in range(300):
                bank = read('wScriptBank')
                addr = h.rd16(h.s('wScriptPos'))
                command = h.mem[bank, addr]
                if command == 0x4c:  # writetext
                    pointer = h.mem[bank, addr + 1] | h.mem[bank, addr + 2] << 8
                    texts.append((bank, pointer))
                elif command == 0x69:  # applymovement
                    obj = h.mem[bank, addr + 1] - 1
                    pointer = h.mem[bank, addr + 2] | h.mem[bank, addr + 3] << 8
                    movements.append((obj, bank, pointer))
                    # Execute the short outdoor step's effect on live coords.
                    if read('wMapGroup') == 1 and read('wMapNumber') == 14:
                        step = h.mem[bank, pointer]
                        if step in (0x0c, 0x0d):
                            obj_addr = h.s('wMapObjects') + obj * 16
                            live_id = h.rd(obj_addr + fields['MAPOBJECT_OBJECT_STRUCT_ID'])
                            live = h.s('wObjectStructs') + live_id * 40
                            if live_id >= 13 or not h.rd(live + fields['OBJECT_NEXT_MAP_Y']):
                                raise RuntimeError(f'{name}: object {obj}, live id {live_id}, map data {h.rd(obj_addr, 16).hex()}')
                            next_y = h.rd(live + fields['OBJECT_NEXT_MAP_Y']) + (1 if step == 0x0c else -1)
                            for member in ('OBJECT_MAP_Y', 'OBJECT_NEXT_MAP_Y'):
                                address = live + fields[member]
                                h.wr(address, next_y)
                elif command == 0x75:  # showemote
                    emotes.append(tuple(h.mem[bank, addr + offset] for offset in (1, 2, 3)))
                h.call('RunScriptCommand')
                if read('wScriptMode') == 0:
                    return texts, movements, emotes
        raise RuntimeError(f'{name}: script command budget exceeded')

    try:
        with patches(h, presentation):
            # Every quest stage, including old completed saves without the new bit.
            for requested, received, complete in product((False, True), repeat=3):
                for name, value in ((explained, requested), (delivered, received), (healed, complete)):
                    event(name, value)
                load(1, 14)
                check(visible(5) == (requested and not received and not complete),
                      f'Outdoor visibility: {requested, received, complete}')
                load(3, 47)
                check(visible(1) == (received and not complete),
                      f'Upstairs visibility: {requested, received, complete}')
                check(visible(2) == (not complete) and visible(3) == complete,
                      f'Amphy visibility: {requested, received, complete}')
                load(1, 14)
                check(visible(5) == (requested and not received and not complete),
                      f'Returning from upstairs changes outdoor visibility: {requested, received, complete}')

            for entry, xy in (('OlivineCityJasmineSceneLeft', (28, 28)),
                              ('OlivineCityJasmineSceneBelow', (29, 29))):
                for scene in (0, 1):
                    for name in (explained, delivered, healed):
                        event(name, False)
                    key_item(False)
                    load(1, 14)
                    write('wOlivineCitySceneID', scene)
                    write('wXCoord', xy[0])
                    write('wYCoord', xy[1])
                    write('wPlayerStandingMapX', xy[0] + 4)
                    write('wPlayerStandingMapY', xy[1] + 4)
                    check(h.call('CheckCurrentMapCoordEvents')['c_flag'], f'{entry}: no trigger in scene {scene}')
                    check(h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym[entry][1], f'{entry}: wrong trigger')
                    texts, moves, emotes = script(entry)
                    check(event(explained) and not event(delivered), f'{entry}: pharmacy request not activated')
                    # The first meeting is one speech that ends with the request; the
                    # shorter reminder is only for talking to her again afterwards.
                    check(texts == [h.sym['JasmineCianwoodPharmacyText']],
                          f'{entry}: introduction changed')
                    check(moves == [(5, *h.sym['OlivineCityJasmineExitLighthouseMovement'])], f'{entry}: wrong entrance movement')
                    check(emotes == [(0, 6, 15)], f'{entry}: Jasmine lacks exclamation emote')
                    obj = h.s('wMap5Object')
                    check((h.rd(obj + fields['MAPOBJECT_X_COORD']), h.rd(obj + fields['MAPOBJECT_Y_COORD'])) == (33, 32),
                          f'{entry}: waiting coordinates not persisted')
                    check(read('wOlivineCitySceneID') == scene, f'{entry}: rival scene changed')
                    check(script(entry) == ([], [], []), f'{entry}: intro repeats')
                    load(1, 14)
                    check(visible(5), f'{entry}: waiting Jasmine disappears on map reload')
                    check(script('OlivineCityJasmineScript')[0] == [h.sym['JasmineGetSomeMedicineText']],
                          f'{entry}: medicine reminder incorrect')

            # Declining preserves both the item and Jasmine's outdoor location.
            key_item(True)
            texts, moves, _ = script('OlivineCityJasmineScript', yes=False)
            check(read('wNumKeyItems') == 1 and not event(delivered) and not moves, 'Declined handoff consumed medicine or moved Jasmine')
            check(texts == [h.sym['JasmineCureAmphyText'], h.sym['JasmineISeeText']], 'Declined dialogue changed')
            texts, moves, _ = script('OlivineCityJasmineScript')
            check(read('wNumKeyItems') == 0 and event(delivered) and not event(healed), 'Accepted handoff did not consume exactly one medicine')
            check(moves == [(5, *h.sym['OlivineCityJasmineEnterLighthouseMovement'])], 'Jasmine did not walk one tile north')
            load(1, 14)
            check(not visible(5), 'Jasmine reappears outdoors after medicine handoff')
            load(3, 47)
            check(visible(1) and visible(2) and not visible(3), 'Handoff does not leave Jasmine beside sick Amphy')
            event('EVENT_OLIVINE_GYM_JASMINE', True)
            script('OlivineLighthouseJasmine')
            check(event(healed) and not event('EVENT_OLIVINE_GYM_JASMINE'), 'Healing scene does not unlock Jasmine in the Gym')
            load(3, 47)
            check(not visible(1) and not visible(2) and visible(3), 'Healing scene does not leave healthy Amphy')
            load(1, 14)
            check(not visible(5), 'Completed quest duplicates Jasmine outdoors')

            # A pre-update save with Jasmine still loaded upstairs cannot heal for free.
            event(delivered, False)
            event(healed, False)
            script('OlivineLighthouseJasmine')
            check(not event(healed), 'Old upstairs save skips the medicine requirement')

            # Appended event fits the existing flag bytes, preserving save layout.
            check((events[delivered] + 8) // 8 == 265, 'New event changes the saved event-array size')
            for name, first in (('OlivineCityJasmineExitLighthouseMovement', 0x0c),
                                ('OlivineCityJasmineEnterLighthouseMovement', 0x0d)):
                bank, addr = h.sym[name]
                check(bytes(h.mem[bank, addr:addr + 2]) == bytes([first, 0x47]), f'{name}: not exactly one step')

            # Check compiled graphics and portrait registration, including narration.
            gfx = _parse_constants(root / 'constants/gfx_constants.asm')
            bank, addr = h.sym['PortraitTexts']
            portraits = {}
            while h.mem[bank, addr] != 255:
                text_bank, lo, hi, who = h.mem[bank, addr:addr + 4]
                portraits[text_bank, lo | hi << 8] = who
                addr += 4
            for label in ('JasmineCianwoodPharmacyText', 'JasmineGetSomeMedicineText',
                          'JasmineCureAmphyText', 'JasmineISeeText',
                          'JasmineDontBeOffendedText', 'JasmineAmphyHowAreYouFeelingText',
                          'JasmineThankYouText'):
                check(portraits.get(h.sym[label]) == gfx['PORTRAIT_JASMINE'], f'{label}: Jasmine portrait missing')
            check(portraits.get(h.sym['PlayerHandedSecretpotionText']) == 0, 'Item narration retains Jasmine portrait')
            load(1, 14)
            sprite = h.rd(h.s('wMap5Object') + fields['MAPOBJECT_SPRITE'])
            used = h.rd(h.s('wUsedSprites'), 64)
            tiles = {used[i]: used[i + 1] for i in range(0, 64, 2) if used[i]}
            check(sprite in tiles and (tiles[sprite] == 0 or 7 <= tiles[sprite] < 0x80),
                  'Jasmine graphics missing or assigned to font-shared animation tiles')
        print(f'JASMINE MEDICINE: {checks} checks; {len(failures)} failures')
        return bool(failures)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())
