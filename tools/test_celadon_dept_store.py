#!/usr/bin/env python3
"""Exercise Celadon's drink trades, vending purchases and PP MAX in the ROM.

Inventory, money, event checks and PP calculations execute native ROM code.
Only script presentation and party/move selection are bypassed. Player saves
and their emulator sidecars are never loaded or written.
"""
from contextlib import contextmanager
from pathlib import Path
import re

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT


ROOT = Path(ROOT)


@contextmanager
def patch(h, replacements):
    originals = []
    try:
        for name, code in replacements.items():
            bank, address = h.sym[name]
            originals.append((bank, address, bytes(h.mem[bank, address:address + len(code)])))
            h.mem[bank, address:address + len(code)] = code
        yield
    finally:
        for bank, address, code in reversed(originals):
            h.mem[bank, address:address + len(code)] = code


def main():
    h = Harness()
    h.boot()
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    moves = _parse_constants(ROOT / 'constants/move_constants.asm')
    events = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
    names = re.findall(r'^\tenum (\w+)_command', (ROOT / 'macros/scripts/events.asm').read_text(), re.M)
    opcodes = {name: index for index, name in enumerate(names)}
    skip = {opcodes[name]: length for name, length in {
        'faceplayer': 1, 'opentext': 1, 'closetext': 1, 'waitbutton': 1,
        'buttonsound': 1, 'itemnotify': 1, 'loadmenu': 3, 'closewindow': 1,
        'playsound': 3, 'waitsfx': 1, 'pause': 2, 'special': 3,
    }.items()}
    trades = [('FRESH_WATER', 'MAX_ELIXER'), ('SODA_POP', 'RARE_CANDY'), ('LEMONADE', 'PP_MAX')]
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def bag(rows):
        write('wNumItems', len(rows))
        write('wItems', [value for name, quantity in rows for value in (items[name], quantity)] + [255])

    def quantity(name):
        return sum(h.rd(h.s('wItems') + index * 2 + 1) for index in range(read('wNumItems'))
                   if h.rd(h.s('wItems') + index * 2) == items[name])

    def flag(drink, value=None):
        index = events['EVENT_CELADON_GIRL_GOT_' + drink]
        address, mask = h.s('wEventFlags') + index // 8, 1 << (index % 8)
        if value is None:
            return bool(h.rd(address) & mask)
        h.wr(address, h.rd(address) | mask if value else h.rd(address) & ~mask)

    def reset():
        for drink, _ in trades:
            flag(drink, False)
        bag([])

    def script(name, choices=(), accept=True):
        bank, address = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), address)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        choices, texts = iter(choices), []
        for _ in range(250):
            bank, pos = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            opcode = h.mem[bank, pos]
            if opcode == opcodes['writetext']:
                texts.append((bank, h.mem[bank, pos + 1] | h.mem[bank, pos + 2] << 8))
                h.wr16(h.s('wScriptPos'), pos + 3)
            elif opcode in (opcodes['yesorno'], opcodes['verticalmenu']):
                write('wScriptVar', int(accept) if opcode == opcodes['yesorno'] else next(choices, 4))
                h.wr16(h.s('wScriptPos'), pos + 1)
            elif opcode in skip:
                h.wr16(h.s('wScriptPos'), pos + skip[opcode])
            else:
                h.call('RunScriptCommand')
                if not read('wScriptMode'):
                    return texts
        raise AssertionError(f'{name} did not finish')

    girl = 'CeladonDeptStore6FLittleGirlScript'
    machine = 'CeladonDeptStore6FVendingMachine'
    # Forty real item slots, excluding drinks and their gifts, for Bag limits.
    filler = ['ANTIDOTE', 'BURN_HEAL', 'ICE_HEAL', 'AWAKENING', 'PARLYZ_HEAL',
              'FULL_RESTORE', 'MAX_POTION', 'HYPER_POTION', 'SUPER_POTION', 'POTION',
              'ESCAPE_ROPE', 'REPEL', 'FIRE_STONE', 'THUNDERSTONE', 'WATER_STONE',
              'HP_UP', 'PROTEIN', 'IRON', 'CARBOS', 'CALCIUM', 'X_ACCURACY',
              'LEAF_STONE', 'NUGGET', 'POKE_DOLL', 'FULL_HEAL', 'REVIVE', 'MAX_REVIVE',
              'GUARD_SPEC', 'SUPER_REPEL', 'MAX_REPEL', 'DIRE_HIT', 'X_ATTACK',
              'X_DEFEND', 'X_SPEED', 'X_SPECIAL', 'ETHER', 'MAX_ETHER', 'ELIXER',
              'PP_UP', 'MOOMOO_MILK']
    try:
        reset()
        for choice, (drink, reward) in enumerate(trades, 1):
            bag([(drink, 2)])
            script(girl, [choice])
            check(quantity(drink) == 1 and quantity(reward) == 1 and flag(drink), drink + ' gift')
            script(girl, [choice])
            check(quantity(drink) == 1 and quantity(reward) == 1, drink + ' duplicate gift')
        check(h.sym['CeladonDeptStore6FLittleGirlHadAllDrinksText'] in script(girl), 'all drinks completed')

        for choice, (drink, reward) in enumerate(trades, 1):
            reset()
            script(girl, [choice])
            check(not flag(drink) and read('wNumItems') == 0, drink + ' missing drink')
            bag([(drink, 1)])
            for option, accept in [(choice, False), (4, True), (0, True)]:
                script(girl, [option], accept)
                check(quantity(drink) == 1 and not flag(drink), 'decline/cancel consumed drink')
            bag([(drink, 2)] + [(name, 1) for name in filler[:39]])
            script(girl, [choice])
            check(quantity(drink) == 2 and quantity(reward) == 0 and not flag(drink), drink + ' full Bag rollback')
            bag([(drink, 1)] + [(name, 1) for name in filler[:39]])
            script(girl, [choice])
            check(quantity(drink) == 0 and quantity(reward) == 1 and flag(drink), drink + ' final drink frees slot')

        def money(value=None):
            if value is not None:
                write('wMoney', list(value.to_bytes(3, 'big')))
            return int.from_bytes(h.rd(h.s('wMoney'), 3), 'big')

        for choice, (drink, price) in enumerate([('FRESH_WATER', 2000), ('SODA_POP', 3000), ('LEMONADE', 4000)], 1):
            bag([])
            money(price)
            texts = script(machine, [choice, 4])
            check(quantity(drink) == 1 and money() == 0, drink + ' purchase price')
            check(texts[0] == h.sym['CeladonVendingText'], 'missing expensive drinks message')
            bag([])
            money(price - 1)
            script(machine, [choice, 4])
            check(quantity(drink) == 0 and money() == price - 1, drink + ' insufficient money')
            bag([(name, 1) for name in filler])
            money(10000)
            script(machine, [choice, 4])
            check(quantity(drink) == 0 and money() == 10000, drink + ' full Bag purchase')
            bag([])
            script(machine, [0])
            check(read('wNumItems') == 0 and money() == 10000, 'cancel purchase')

        # Drive PP MAX through its real effect, keeping PP math and consumption.
        presentation = {name: b'\xc9' for name in ['PrintText', 'ClearPalettes', 'Play_SFX_FULL_HEAL']}
        presentation.update(UseItem_SelectMon=b'\xaf\xc9', MoveSelectionScreen=b'\xaf\xc9')
        tackle = h.call('GetMoveIDFromIndex', hl=moves['TACKLE'])['a']
        sketch = h.call('GetMoveIDFromIndex', hl=moves['SKETCH'])['a']
        for starting_boost in range(3):
            for current_pp in (0, 5, 35):
                write('wPartyMon1Moves', [tackle, 0, 0, 0])
                write('wPartyMon1PP', [starting_boost * 64 + current_pp, 0, 0, 0])
                write('wCurPartyMon', 0)
                write('wMenuCursorY', 0)
                write('wCurItem', items['PP_MAX'])
                write('wCurItemQuantity', 255)
                write('wMonType', 0)
                bag([('PP_MAX', 2)])
                with patch(h, presentation):
                    h.call('RestorePPEffect')
                expected = current_pp + (3 - starting_boost) * 7
                check(read('wPartyMon1PP') == 192 + expected, f'PP MAX boost {starting_boost}, PP {current_pp}')
                check(quantity('PP_MAX') == 1, 'PP MAX consumed wrong quantity')

        # Invalid moves return to selection, then cancel, retaining the item.
        invalid_ui = dict(presentation, UseItem_SelectMon=b'\x37\xc9', MoveSelectionScreen=b'\x3e\x01\xb7\xc9')
        for move, pp in [(tackle, 192 + 56), (sketch, 1)]:
            write('wPartyMon1Moves', [move, 0, 0, 0])
            write('wPartyMon1PP', [pp, 0, 0, 0])
            write('wd002', items['PP_MAX'])
            write('wItemEffectSucceeded', 1)
            bag([('PP_MAX', 1)])
            with patch(h, invalid_ui):
                h.call('RestorePPEffect.raise_pp', hl=h.s('wPartyMon1Moves'))
            check(read('wPartyMon1PP') == pp and quantity('PP_MAX') == 1, 'PP MAX used on invalid move')
            check(read('wItemEffectSucceeded') == 0, 'invalid PP MAX reported success')

        # Preserve PP UP's single-boost behavior.
        write('wPartyMon1Moves', [tackle, 0, 0, 0])
        write('wPartyMon1PP', [35, 0, 0, 0])
        write('wCurItem', items['PP_UP'])
        bag([('PP_UP', 2)])
        with patch(h, presentation):
            h.call('RestorePPEffect')
        check(read('wPartyMon1PP') == 64 + 42 and quantity('PP_UP') == 1, 'PP UP single boost regression')
        # Scratch before wGameData may move without changing serialized data.
        check(h.s('wCurBox') - h.s('wGameData') == 0x6f3, 'current-box save offset shifted')
        check((events['NUM_EVENTS'] + 7) // 8 <= h.s('wCurBox') - h.s('wEventFlags'),
              'event flags overlap the current box')
        check(h.sym['GoldenrodDeptStore6F_Blocks'] != h.sym['CeladonDeptStore6F_Blocks'], 'shared sixth floor blocks')
        bank, start = h.sym['SilphWorkerMSpriteGFX']
        check(h.sym['SilphWorkerMSpriteGFXEnd'][1] - start == 192, 'dad sprite size')
        print(f'CELADON DEPT STORE: {checks} checks passed')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
