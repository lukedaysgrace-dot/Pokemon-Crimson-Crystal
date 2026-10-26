#!/usr/bin/env python3
"""Run the wishing well's money, inventory and persistent branches in the ROM.

Only presentation and the YES/NO selection are skipped. All item, money,
event and branch commands execute native code, using private cartridge state.
"""
from pathlib import Path
import re

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT


ROOT = Path(ROOT)


def main():
    h = Harness()
    h.boot()
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    events = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
    names = re.findall(r'^\tenum (\w+)_command', (ROOT / 'macros/scripts/events.asm').read_text(), re.M)
    opcodes = {name: index for index, name in enumerate(names)}
    skip = {opcodes[name]: size for name, size in {
        'faceplayer': 1, 'opentext': 1, 'closetext': 1, 'waitbutton': 1,
        'playsound': 3, 'waitsfx': 1, 'itemnotify': 1,
    }.items()}
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def flag(value=None):
        index = events['EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY']
        address, mask = h.s('wEventFlags') + index // 8, 1 << (index % 8)
        if value is not None:
            h.wr(address, h.rd(address) | mask if value else h.rd(address) & ~mask)
        return bool(h.rd(address) & mask)

    def money(value=None):
        if value is not None:
            write('wMoney', value.to_bytes(3, 'big'))
        return int.from_bytes(h.rd(h.s('wMoney'), 3), 'big')

    def bag(rows):
        write('wNumItems', len(rows))
        write('wItems', [v for name, count in rows for v in (items[name], count)] + [255])

    def candy_count():
        return sum(h.rd(h.s('wItems') + i * 2 + 1) for i in range(read('wNumItems'))
                   if h.rd(h.s('wItems') + i * 2) == items['RARE_CANDY'])

    def script(name, accept=True):
        bank, address = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), address)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        texts = []
        for _ in range(100):
            bank, pos = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            opcode = h.mem[bank, pos]
            if opcode == opcodes['writetext']:
                texts.append((bank, h.mem[bank, pos + 1] | h.mem[bank, pos + 2] << 8))
                h.wr16(h.s('wScriptPos'), pos + 3)
            elif opcode == opcodes['yesorno']:
                write('wScriptVar', int(accept))
                h.wr16(h.s('wScriptPos'), pos + 1)
            elif opcode in skip:
                h.wr16(h.s('wScriptPos'), pos + skip[opcode])
            else:
                h.call('RunScriptCommand')
                if not read('wScriptMode'):
                    return texts
        raise AssertionError(name + ' did not finish')

    def well(accept=True):
        return script('EcruteakCityWishingWell', accept)

    try:
        # The coin-wish fixture must not contain either quest item; the well
        # now prioritizes those branches, covered by their own native tests.
        write('wNumKeyItems', 0)
        write('wKeyItems', [255])
        for claimed in (False, True):
            for funds in (0, 99, 100, 101, 1000):
                for accept in (False, True):
                    flag(claimed)
                    bag([])
                    money(funds)
                    texts = well(accept)
                    success = accept and funds >= 100
                    check(money() == funds - (100 if success else 0), 'incorrect charge')
                    check(candy_count() == int(success and not claimed), 'incorrect reward')
                    check(flag() == (claimed or success), 'incorrect completion state')
                    check(texts[0] == h.sym['EcruteakCityWishingWellPromptText'], 'missing prompt')
                    ending = ('Nothing' if claimed else 'Reward') if success else 'NoMoney' if accept else 'Prompt'
                    check(texts[-1] == h.sym['EcruteakCityWishingWell' + ending + 'Text'], 'wrong outcome text')

        # Fill all forty item slots with distinct real items.
        filler = ['ANTIDOTE', 'BURN_HEAL', 'ICE_HEAL', 'AWAKENING', 'PARLYZ_HEAL',
                  'FULL_RESTORE', 'MAX_POTION', 'HYPER_POTION', 'SUPER_POTION', 'POTION',
                  'ESCAPE_ROPE', 'REPEL', 'FIRE_STONE', 'THUNDERSTONE', 'WATER_STONE',
                  'HP_UP', 'PROTEIN', 'IRON', 'CARBOS', 'CALCIUM', 'X_ACCURACY',
                  'LEAF_STONE', 'NUGGET', 'POKE_DOLL', 'FULL_HEAL', 'REVIVE', 'MAX_REVIVE',
                  'GUARD_SPEC', 'SUPER_REPEL', 'MAX_REPEL', 'DIRE_HIT', 'X_ATTACK',
                  'X_DEFEND', 'X_SPEED', 'X_SPECIAL', 'PP_UP', 'ETHER', 'MAX_ETHER',
                  'ELIXER', 'MAX_ELIXER']
        flag(False)
        bag([(name, 1) for name in filler])
        money(1000)
        check(well()[-1] == h.sym['EcruteakCityWishingWellBagFullText'], 'missing full Bag message')
        check(money() == 1000 and not flag() and candy_count() == 0, 'full Bag consumed wish')
        check(script('EcruteakCityWellGrannyScript') == [h.sym['EcruteakCityWellGrannyText']],
              'granny reacted before receiving candy')
        # An existing candy stack accepts a reward even when all slots are used.
        bag([('RARE_CANDY', 1)] + [(name, 1) for name in filler[:39]])
        well()
        check(money() == 900 and flag() and candy_count() == 2, 'stacked reward failed')
        for _ in range(3):
            well()
        check(money() == 600 and candy_count() == 2, 'repeat wishes duplicated candy')

        # Reload the map through real routines; the persistent bit and granny remain.
        write('wMapGroup', 4)
        write('wMapNumber', 9)
        h.call('LoadMapAttributes')
        check(flag(), 'map reload reset the reward')
        check(script('EcruteakCityWellGrannyScript') == [h.sym['EcruteakCityWellGrannyAfterText']],
              'granny did not remember receiving candy')
        write('wUsedSprites', bytes(64))
        h.call('GetPlayerSprite')
        h.call('AddMapSprites')
        h.call('LoadAndSortSprites')
        used = h.rd(h.s('wUsedSprites'), 64)
        index = used[::2].index(sprites['SPRITE_GRANNY'])
        check(used[index * 2 + 1] >= 7, 'granny could not be assigned VRAM')

        # Text must fit the eighteen-character dialogue area.
        source = (ROOT / 'maps/EcruteakCity.asm').read_text()
        new_text = source.split('EcruteakCityWishingWellPromptText:', 1)[1].split('EcruteakCity_MapEvents:')[0]
        for text in re.findall(r'^\s*(?:text|line|cont|para) "([^"]*)"', new_text, re.M):
            check(len(text) <= 18, 'text too wide: ' + text)
        print(f'{checks} wishing-well checks passed')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
