#!/usr/bin/env python3
"""Native ROM checks for decoration stock, money, ownership and daily rotation.

Uses a private in-memory cartridge and never loads or writes a player save.
"""
from pathlib import Path

from pc_harness import Harness, ROOT, dec


ROOT = Path(ROOT)


def main():
    h = Harness()
    h.boot()
    checks = 0

    def check(condition, message):
        nonlocal checks
        checks += 1
        assert condition, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def table(label, count=None):
        bank, address = h.sym[label]
        if count is not None:
            return list(h.mem[bank, address:address + count])
        result = []
        for index in range(32):
            value = h.mem[bank, address + index]
            if value == 255:
                return result
            result.append(value)
        raise AssertionError(label + ' missing terminator')

    furniture = table('CeladonFurnitureStock')
    moon = table('MountMoonDollStock')
    daily = table('GoldenrodDailyDollStock', 11)
    all_decos = furniture + moon + daily

    def owned(deco, value=None):
        result = h.call('DecorationFlagAction', a=deco, bc=(2 if value is None else int(value)) << 8)
        return bool(result['c'])

    def clear():
        for deco in all_decos:
            owned(deco, False)

    def stock(shop, day=0):
        write('wDecorationShopID', shop)
        write('wCurDay', day)
        h.call('BuildDecorationShopStock')
        count = read('wDecorationShopStock')
        check(count <= 16 and h.rd(h.s('wDecorationShopStock') + count + 1) == 255, 'stock size/terminator')
        return list(h.rd(h.s('wDecorationShopStock') + 1, count)) if count else []

    def name(deco):
        h.call('GetDecorationName', a=deco, hl=h.s('wStringBuffer3'))
        return dec(h.rd(h.s('wStringBuffer3'), 19)).split('@')[0]

    def price(deco):
        result = h.call('GetDecorationShopPrice', a=deco)
        check(not result['c_flag'], 'missing price')
        return int.from_bytes(h.rd(h.s('wDecorationShopPrice'), 3), 'big')

    def money(value=None):
        if value is not None:
            write('wMoney', list(value.to_bytes(3, 'big')))
        return int.from_bytes(h.rd(h.s('wMoney'), 3), 'big')

    try:
        expected = [
            ['PINK BED', 'POLKADOT BED', 'RED CARPET', 'BLUE CARPET', 'YELLOW CARPET', 'GREEN CARPET',
             'MAGNAPLANT', 'TROPICPLANT', 'JUMBOPLANT', 'PIKACHU POSTER', 'CLEFAIRY POSTER',
             'JIGGLYPUFF POSTER', 'NES', 'SUPER NES', 'NINTENDO 64', 'VIRTUAL BOY'],
            ['BULBASAUR DOLL', 'SQUIRTLE DOLL', 'JIGGLYPUFF DOLL', 'SURF PIKACHU DOLL', 'BIG ONIX', 'BIG LAPRAS'],
            ['POLIWAG DOLL', 'DIGLETT DOLL', 'STARYU DOLL', 'MAGIKARP DOLL', 'ODDISH DOLL',
             'GENGAR DOLL', 'SHELLDER DOLL', 'GRIMER DOLL', 'VOLTORB DOLL', 'WEEDLE DOLL', 'GEODUDE DOLL'],
        ]
        check(len(set(all_decos)) == 33, 'missing/duplicate requested decorations')
        for rows, names in zip((furniture, moon, daily), expected):
            check([name(deco) for deco in rows] == names, 'requested stock/name mismatch')
        clear()
        check(stock(0) == furniture and stock(1) == moon, 'fixed stock mismatch')

        # The accumulated calendar day is not an already-reduced weekday.
        for day in range(256):
            expected_stock = [daily[((day % 4) * 3 + index) % 11] for index in range(3)]
            check(stock(2, day) == expected_stock, f'daily stock on day {day}')
            check(stock(2, day) == expected_stock, f'day {day} changed on reopening')
        for day in range(11):
            collected = set()
            for offset in range(4):
                collected.update(stock(2, day + offset))
            check(collected == set(daily), 'not all dolls rotate through within four days')
        for day in range(137, 140):
            collected = set()
            for offset in range(4):
                collected.update(stock(2, (day + offset) % 140))
            check(collected == set(daily), 'RTC wrap broke the four-day stock cycle')

        uncommon = {'PINK BED', 'POLKADOT BED', 'MAGNAPLANT', 'TROPICPLANT', 'NES', 'NINTENDO 64',
                    'BULBASAUR DOLL', 'SQUIRTLE DOLL'}
        rare = {'RED CARPET', 'BLUE CARPET', 'YELLOW CARPET', 'GREEN CARPET', 'JUMBOPLANT',
                'PIKACHU POSTER', 'BIG ONIX'}
        very_rare = {'VIRTUAL BOY', 'SURF PIKACHU DOLL', 'BIG LAPRAS'}
        for shop, rows in enumerate((furniture, moon, daily)):
            for deco in rows:
                clear()
                day = 0
                if shop == 2:
                    day = next(day for day in range(4) if deco in stock(2, day))
                stock(shop, day)
                label = name(deco)
                cost = 20000 if label in very_rare else 10000 if label in rare else 5000 if label in uncommon else 3000
                check(price(deco) == cost, label + ' price')
                money(cost - 1)
                result = h.call('TryBuyDecoration', a=deco)
                check(result['a'] == 2 and not owned(deco) and money() == cost - 1,
                      f'{label} insufficient money: result={result}, owned={owned(deco)}, money={money()}, '
                      f'stock={list(h.rd(h.s("wDecorationShopStock"), 18))}')
                money(cost)
                result = h.call('TryBuyDecoration', a=deco)
                check(result['a'] == 0 and owned(deco) and money() == 0, label + ' exact-price purchase')
                check(sum(owned(other) for other in all_decos) == 1, label + ' changed another decoration flag')
                if deco in furniture:
                    category = ('FindOwnedBeds' if deco in furniture[:2] else
                                'FindOwnedCarpets' if deco in furniture[2:6] else
                                'FindOwnedPlants' if deco in furniture[6:9] else
                                'FindOwnedPosters' if deco in furniture[9:12] else 'FindOwnedConsoles')
                else:
                    category = 'FindOwnedBigDolls' if deco in moon[4:] else 'FindOwnedOrnaments'
                h.call(category)
                pc_list = list(h.rd(h.s('wd002') + 1, h.rd(h.s('wd002'))))
                check(deco in pc_list, label + ' missing from bedroom PC decoration list')
                check(deco not in stock(shop, day), label + ' still in owned stock')
                money(50000)
                result = h.call('TryBuyDecoration', a=deco)
                check(result['a'] == 1 and money() == 50000, label + ' duplicate charged')

        clear()
        stock(0)
        money(50000)
        check(h.call('TryBuyDecoration', a=moon[0])['a'] == 3 and money() == 50000, 'bought unstocked decoration')
        # Furniture unlocks directly, even when the ordinary Items pocket is full.
        write('wNumItems', 40)
        inventory = bytes(value for item in range(1, 41) for value in (item, 1)) + b'\xff'
        write('wItems', inventory)
        check(h.call('TryBuyDecoration', a=furniture[0])['a'] == 0 and owned(furniture[0]), 'full Bag blocked decoration')
        check(read('wNumItems') == 40 and h.rd(h.s('wItems'), 81) == inventory, 'decoration changed the Bag')
        clear()
        for deco in furniture:
            owned(deco, True)
        check(stock(0) == [], 'owned furniture not sold out')
        clear()
        for deco in stock(2, 7):
            owned(deco, True)
        check(stock(2, 7) == [] and stock(2, 8), 'daily sellout did not refresh tomorrow')

        # Save offsets stay fixed even if scratch before wGameData moves.
        check(h.s('wCurBox') - h.s('wGameData') == 0x6f3, 'current-box save offset shifted')
        check(h.s('wDecorationShopStock') == h.s('wMartItem1BCD'), 'shop scratch no longer aliases mart scratch')
        print(f'DECORATION SHOPS: {checks} checks passed')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
