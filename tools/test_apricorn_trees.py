#!/usr/bin/env python3
"""Exercise apricorn map rendering, collection and regrowth in a private ROM.

Uses a fresh emulator fixture; never opens player saves. Presentation is
suppressed only for script checks; inventory and daily flags execute the ROM.
"""
from contextlib import contextmanager
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from trainer_sprite_checks import map_ids, native_call
from probability_checks import call
from symbols import _parse_constants


@contextmanager
def quiet_text(h):
    originals = {}
    try:
        for name in ('Script_opentext', 'Script_closetext', 'Script_waitbutton',
                     'Script_buttonsound', 'Script_itemnotify', 'Script_specialsound',
                     'MapTextbox', 'PrintText', 'PlaySFX', 'WaitSFX'):
            bank, address = h.sym[name]
            originals[name] = h.pb.memory[bank, address]
            h.pb.memory[bank, address] = 0xc9
        yield
    finally:
        for name, opcode in originals.items():
            bank, address = h.sym[name]
            h.pb.memory[bank, address] = opcode


def main():
    h = Harness(rom_path=Path(sys.argv[1]) if len(sys.argv) > 1 else None)
    h.ensure_fixture()
    m, pb = h.battle.mem, h.pb
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    trees = _parse_constants(ROOT / 'constants/script_constants.asm')
    checks = 0
    output = ROOT / '.tmpbuild/apricorn-checks'
    output.mkdir(exist_ok=True)

    def check(condition, message):
        nonlocal checks
        checks += 1
        assert condition, message

    def flag(name, value):
        index = events[name]
        byte, bit = divmod(index, 8)
        old = m.read('wEventFlags', byte)
        m.write('wEventFlags', old | (1 << bit) if value else old & ~(1 << bit), byte)

    def flag_set(name):
        byte, bit = divmod(events[name], 8)
        return bool(m.read('wEventFlags', byte) & (1 << bit))

    def enter(name, x, y, reset=True):
        if reset:
            h.load_fixture()
        flag('EVENT_SAW_SUICUNE_ON_ROUTE_42', False)
        group, number, _, _ = map_ids()[name]
        for key, value in dict(hDebugActive=0, wDebugState=0, wDefaultSpawnpoint=255,
                               wMapGroup=group, wMapNumber=number, wXCoord=x,
                               wYCoord=y, hMapEntryMethod=0xf1).items():
            m.write(key, value)
        native_call(h, 'EnterMap')
        native_call(h, 'UpdateSprites')
        h.tick(2)

    def script(name):
        bank, addr = h.sym[name]
        m.write('wScriptBank', bank)
        m.write_bytes('wScriptPos', addr.to_bytes(2, 'little'))
        m.write('wScriptStackSize', 0)
        m.write('wScriptMode', 1)
        for _ in range(200):
            call(h, 'RunScriptCommand')
            if not m.read('wScriptMode'):
                return
        raise AssertionError(name + ': script did not finish')

    def picked(tree):
        m.write('wScriptVar', trees[tree])
        call(h, 'CheckApricornTreePicked')
        return bool(m.read('wScriptVar'))

    def quantity(item):
        bag = m.read_bytes('wItems', 81)
        return sum(bag[i*2+1] for i in range(m.read('wNumItems')) if bag[i*2] == items[item])

    def object_present(object_id):
        base = h.sym.addr('wObjectStructs')
        return any(pb.memory[base+i*40] and pb.memory[base+i*40+1] == object_id for i in range(1,13))

    try:
        enter('ROUTE_42', 25, 16)
        check(m.read('wCurMapObjectEventCount') == 8, 'Route 42 has redundant map sprites')
        check(object_present(4), 'Entei must be present for the scanline regression')
        check(all(object_present(i) for i in (6,7,8)), 'all Route 42 apricorns must load beside Entei')
        # Route 42's background trees must use the original round fruit-tree
        # art, byte-for-byte, just like Azalea and Route 37's sprite objects.
        tree_art = (ROOT / 'gfx/sprites/fruit_tree.2bpp').read_bytes()
        bg_art = bytes(pb.memory[1,0x9200:0x9220]) + bytes(pb.memory[1,0x9300:0x9320])
        check(bg_art == tree_art, 'Route 42 must use the same apricorn-tree artwork as the other maps')
        bg_colors = m.read_bytes('wBGPals1',6,4*8+2)
        obj_colors = m.read_bytes('wOBPals1',6,6*8+2)
        check(bg_colors == obj_colors, 'Route 42 apricorn-tree colors must match the fruit-tree sprites')
        check(m.read_bytes('wBGPals1',2,4*8) == m.read_bytes('wBGPals1',2,3*8),
              'Route 42 tree corners must match the surrounding ground')
        raw = m.read_bytes('wVirtualOAM', 160)
        entries = [raw[i:i+4] for i in range(0,160,4) if raw[i] and raw[i+1]]
        peak = max(sum(y <= line < y+8 for y,x,t,a in entries) for line in range(16,160))
        check(peak <= 10, f'Route 42 exceeds the hardware scanline limit: {peak}')
        pb.screen.image.resize((640,576)).save(output / 'route42-entei-apricorns.png')
        print(f'PASS Route 42: Entei, player and all apricorns; peak {peak}/10 sprites per row', flush=True)

        bg_pointer = int.from_bytes(m.read_bytes('wCurMapBGEventsPointer',2),'little')
        bank, _ = h.sym['Route42_MapEvents']
        bg_events = [bytes(pb.memory[bank, bg_pointer+i*5:bg_pointer+(i+1)*5])
                     for i in range(m.read('wCurMapBGEventCount'))]
        for label, item, event, x,y in [('Route42HiddenCarbos', 'CARBOS', 'EVENT_ROUTE_42_HIDDEN_CARBOS',6,4),
                                      ('Route42HiddenPPUp', 'PP_UP', 'EVENT_ROUTE_42_HIDDEN_PP_UP',33,8)]:
            bank, address = h.sym[label]
            data = bytes(pb.memory[bank, address:address+3])
            check(data == events[event].to_bytes(2,'little') + bytes([items[item]]), label + ': incorrect hidden-item data')
            check(bytes([y,x,7]) + address.to_bytes(2,'little') in bg_events, label + ': missing hidden BG event at original item tile')
            flag(event,False)
            m.write('wNumItems',0)
            m.write('wItems',255)
            m.write_bytes('wHiddenItemData',data)
            with quiet_text(h):
                script('HiddenItemScript')
            check(quantity(item) == 1 and flag_set(event), label + ': pickup did not award item and set collection flag')
            flag(event,False)
            m.write('wNumItems',40)
            m.write_bytes('wItems',bytes([items['POTION'],99]*40 + [255]))
            with quiet_text(h):
                script('HiddenItemScript')
            check(quantity(item) == 0 and not flag_set(event), label + ': full bag consumed hidden item')
        for x, label in [(27,'Route42FruitTree1'),(28,'Route42FruitTree2'),(29,'Route42FruitTree3')]:
            _,address = h.sym[label]
            check(bytes([16,x,0]) + address.to_bytes(2,'little') in bg_events, label + ': empty background tree cannot be examined')
        print('PASS Route 42 hidden Carbos and PP Up: placement, pickup flags and full bag',flush=True)

        cases = [
            ('ROUTE_42', 28,17, [('Route42FruitTree1','FRUITTREE_ROUTE_42_1','PNK_APRICORN',6),
                                ('Route42FruitTree2','FRUITTREE_ROUTE_42_2','GRN_APRICORN',7),
                                ('Route42FruitTree3','FRUITTREE_ROUTE_42_3','YLW_APRICORN',8)]),
            ('ROUTE_37', 13,11, [('Route37FruitTree1','FRUITTREE_ROUTE_37_1','RED_APRICORN',8),
                                ('Route37FruitTree2','FRUITTREE_ROUTE_37_2','BLU_APRICORN',9),
                                ('Route37FruitTree3','FRUITTREE_ROUTE_37_3','BLK_APRICORN',10)]),
            ('AZALEA_TOWN', 8,3, [('WhiteApricornTree','FRUITTREE_AZALEA_TOWN','WHT_APRICORN',13)]),
        ]
        for location, x,y, group in cases:
            enter(location,x,y)
            if location != 'ROUTE_42':
                # The map-specific replacement must not change other maps'
                # cut-tree tiles, even when they share the Johto tileset.
                path = 'johto_modern' if location == 'AZALEA_TOWN' else 'johto'
                original = (ROOT / f'gfx/tilesets/{path}.2bpp').read_bytes()
                check(bytes(pb.memory[1,0x9200:0x9220]) == original[0xa0*16:0xa2*16],
                      location + ': Route 42 graphics replacement leaked to another map')
                base = h.sym.addr('wObjectStructs')
                for object_id in ([9] if location == 'AZALEA_TOWN' else [4,6,7]):
                    slots = [base+i*40 for i in range(1,13)
                             if pb.memory[base+i*40] and pb.memory[base+i*40+1] == object_id]
                    check(len(slots) == 1, location + ': missing original fruit-tree object')
                    tile = pb.memory[slots[0]+2]
                    bank = 0 if tile & 128 else 1
                    address = 0x8000 + (tile & 127)*16
                    check(bytes(pb.memory[bank,address:address+64]) == tree_art,
                          location + ': tree body must use the shared original artwork')
            pb.screen.image.resize((640,576)).save(output / (location.lower() + '.png'))
            for label, tree, item, obj in group:
                check(not picked(tree), tree + ': unpicked tree flagged as picked')
                m.write('wNumItems',0)
                m.write('wItems',255)
                with quiet_text(h):
                    script(label)
                check(quantity(item) == 3, tree + ': must give three matching apricorns')
                check(picked(tree), tree + ': collection did not set daily flag')
                check(not object_present(obj), tree + ': collected apricorn still visible')
                with quiet_text(h):
                    script(label)
                check(quantity(item) == 3, tree + ': duplicate collection allowed')
            enter(location,x,y,reset=False)
            for _, tree, _,obj in group:
                check(picked(tree) and not object_present(obj), tree + ': picked fruit reappeared on same-day re-entry')
            call(h,'ClearDailyTimers')
            call(h,'CheckDailyResetTimer')
            enter(location,x,y,reset=False)
            for label, tree, item,obj in group:
                check(not picked(tree) and object_present(obj), tree + ': fruit did not regrow after daily reset')
                # A full pocket with only one free space in this stack cannot
                # accept three fruit; otherwise the game opens another stack.
                m.write('wNumItems',40)
                m.write_bytes('wItems',bytes([items[item],98] + [items['POTION'],99]*39 + [255]))
                with quiet_text(h):
                    script(label)
                check(quantity(item) == 98 and not picked(tree) and object_present(obj), tree + ': failed harvest consumed fruit')
            print(f'PASS {location}: collection, no duplicates, re-entry, daily regrowth, full stack',flush=True)
        print(f'PASS {checks} apricorn and hidden-item checks',flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
