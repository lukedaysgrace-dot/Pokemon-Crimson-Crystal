#!/usr/bin/env python3
"""Native well exchange and palette checks with private cartridge state.

Text boxes and frame waits are skipped; inventory, script branches, flags,
and all six palette fades execute compiled game code. Each scripted walking
step is checked against the map's collision data and the player's position.
"""
from pathlib import Path
import re

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT
from test_overworld_state import patches


ROOT = Path(ROOT)


def main():
    h = Harness()
    h.boot()
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    flags = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
    names = re.findall(r'^\tenum (\w+)_command', (ROOT / 'macros/scripts/events.asm').read_text(), re.M)
    op = {name: index for index, name in enumerate(names)}
    skip = {op[name]: size for name, size in {
        'faceplayer': 1, 'opentext': 1, 'closetext': 1, 'waitbutton': 1,
        'playsound': 3, 'waitsfx': 1, 'itemnotify': 1, 'showemote': 4,
        'pause': 2, 'turnobject': 3,
    }.items()}
    specials = re.findall(r'^\s*add_special (\w+)', (ROOT / 'data/special_pointers.asm').read_text(), re.M)
    blocks = (ROOT / 'maps/EcruteakCity.ablk').read_bytes()
    collisions = [re.findall(r'\w+', line.split(';')[0])[1:]
                  for line in (ROOT / 'data/tilesets/johto_collision.asm').read_text().splitlines()
                  if line.lstrip().startswith('tilecoll ')]
    checks = 0
    trace = []
    player = (25, 9)
    granny = (24, 8)

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def event(name, value=None):
        number = flags[name]
        addr, mask = h.s('wEventFlags') + number // 8, 1 << (number % 8)
        if value is not None:
            h.wr(addr, h.rd(addr) | mask if value else h.rd(addr) & ~mask)
        return bool(h.rd(addr) & mask)

    def keys(rows):
        write('wNumKeyItems', len(rows))
        write('wKeyItems', [items[name] for name in rows] + [255])

    def count(name):
        address = h.s('wKeyItems')
        return list(h.mem[address:address + read('wNumKeyItems')]).count(items[name])

    def load(xy, rows, completed=False):
        nonlocal player, granny
        player, granny = xy, (24, 8)
        write('wMapGroup', 4)
        write('wMapNumber', 9)
        write('wXCoord', xy[0])
        write('wYCoord', xy[1])
        h.call('LoadMapAttributes')
        keys(rows)
        event('EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED', completed)
        event('EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY', False)
        write('wMoney', (1000).to_bytes(3, 'big'))
        write('wNumItems', 0)
        write('wItems', [255])
        # Use visibly distinct loaded palettes; no weather tint in this fixture.
        write('hCurWeather', 0)
        for label in ('wBGPals1', 'wOBPals1', 'wBGPals2', 'wOBPals2'):
            bank, address = h.sym[label]
            h.mem[bank, address:address + 64] = bytes([0x1f, 0x00, 0xe0, 0x03, 0x00, 0x7c, 0, 0]) * 8

    def walk(bank, pointer):
        nonlocal granny
        for offset in range(16):
            command = h.mem[bank, pointer + offset]
            if command == 0x47:
                return
            if 0x0c <= command <= 0x0f:
                dx, dy = ((0, 1), (0, -1), (-1, 0), (1, 0))[command & 3]
                granny = (granny[0] + dx, granny[1] + dy)
                block = blocks[granny[1] // 2 * 20 + granny[0] // 2]
                corner = granny[1] % 2 * 2 + granny[0] % 2
                check(collisions[block][corner] == 'FLOOR', f'Granny walks into terrain at {granny}')
                check(granny != player, 'Granny walks onto the player')
            else:
                check(command < 4, 'unexpected movement command')
        raise AssertionError('unterminated movement')

    def run(name='EcruteakCityWishingWell', accept=True):
        bank, address = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), address)
        write('wScriptMode', 1)
        write('wScriptStackSize', 0)
        trace.clear()
        for _ in range(200):
            bank, pos = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            command = h.mem[bank, pos]
            if command == op['writetext']:
                pointer = h.mem[bank, pos + 1] | h.mem[bank, pos + 2] << 8
                trace.append(('text', (bank, pointer)))
                if (bank, pointer) == h.sym['EcruteakCityWellGrannyStarPieceText'] and name == 'EcruteakCityWishingWell':
                    check(abs(granny[0] - player[0]) + abs(granny[1] - player[1]) == 1,
                          'Granny did not approach the player before speaking')
                h.wr16(h.s('wScriptPos'), pos + 3)
            elif command == op['yesorno']:
                write('wScriptVar', int(accept))
                h.wr16(h.s('wScriptPos'), pos + 1)
            elif command == op['applymovement']:
                check(h.mem[bank, pos + 1] == 10, 'cutscene moves a different actor')
                walk(bank, h.mem[bank, pos + 2] | h.mem[bank, pos + 3] << 8)
                trace.append(('walk', granny))
                h.wr16(h.s('wScriptPos'), pos + 4)
            elif command == op['special']:
                number = h.mem[bank, pos + 1] | h.mem[bank, pos + 2] << 8
                special = specials[number]
                # Direct harness calls disable interrupts at their return trap.
                # Suppress only the VBlank wait, keeping native palette math.
                with patches(h, {'_DoFadePalettes.FadeDelay': b'\xc9'}):
                    h.call('RunScriptCommand')
                palbank, paladdr = h.sym['wBGPals2']
                palette = bytes(h.mem[palbank, paladdr:paladdr + 64])
                check(palette == bytes([255, 127]) * 32 if special == 'FadeOutPalettes'
                      else palette != bytes([255, 127]) * 32, 'flash palettes did not change')
                trace.append(('special', special))
            elif command in skip:
                h.wr16(h.s('wScriptPos'), pos + skip[command])
            else:
                h.call('RunScriptCommand')
                if not read('wScriptMode'):
                    return [value for kind, value in trace if kind == 'text']
        raise AssertionError('script did not finish')

    try:
        done = 'EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED'
        candy = 'EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY'
        for xy in ((25, 9), (26, 8)):
            load(xy, ['STAR_SHARD'])
            initial = h.rd(h.s('wKeyItems'), 2)
            check(run(accept=False) == [h.sym['EcruteakCityWishingWellStarShardPromptText']], 'declining changed dialogue')
            check(h.rd(h.s('wKeyItems'), 2) == initial and not event(done), 'declining consumed the shard')
            check(not any(kind in ('special', 'walk') for kind, _ in trace), 'declining started cutscene')
            for full in (False, True):
                load(xy, ['STAR_SHARD'] + (['BICYCLE'] * 24 if full else []))
                texts = run()
                check(texts == [h.sym[n] for n in ('EcruteakCityWishingWellStarShardPromptText',
                      'EcruteakCityWishingWellStarShardTossText', 'EcruteakCityWishingWellStarPieceRisesText',
                      'EcruteakCityWishingWellStarPieceReceivedText', 'EcruteakCityWellGrannyStarPieceText')], 'wrong story order')
                check(count('STAR_SHARD') == 0 and count('STAR_PIECE') == 1 and event(done), 'exchange failed')
                check(read('wNumKeyItems') == (25 if full else 1), 'exchange changed pocket size')
                check(granny == (24, 8), 'Granny did not return to her spot')
                check(not event(candy) and h.rd(h.s('wMoney'), 3) == (1000).to_bytes(3, 'big'), 'exchange charged money or used candy reward')
                rises = trace.index(('text', h.sym['EcruteakCityWishingWellStarPieceRisesText']))
                received = trace.index(('text', h.sym['EcruteakCityWishingWellStarPieceReceivedText']))
                flashes = [value for kind, value in trace[rises + 1:received] if kind == 'special']
                check(flashes == ['FadeOutPalettes', 'FadeInPalettes'] * 3, 'three flashes did not precede reward')
                check(run('EcruteakCityWellGrannyScript') == [h.sym['EcruteakCityWellGrannyStarPieceText']], 'Granny forgot the Moon clue')
                h.call('LoadMapAttributes')
                check(event(done), 'reload forgot exchange')
                run(accept=False)
                check(not any(kind in ('special', 'walk') for kind, _ in trace), 'completed exchange repeated')
                check(count('STAR_PIECE') == 1, 'completed exchange duplicated reward')
                texts = run()
                check(texts[-1] == h.sym['EcruteakCityWishingWellRewardText'] and event(candy),
                      'unclaimed Rare Candy was lost after the shard exchange')
                check(read('wNumItems') == 1 and h.rd(h.s('wItems')) == items['RARE_CANDY'],
                      'later coin wish did not award Rare Candy')
                texts = run()
                check(texts[-1] == h.sym['EcruteakCityWishingWellNothingText'],
                      'completed candy wish did not use the original repeat dialogue')
        load((25, 9), ['STAR_SHARD'])
        event(candy, True)
        texts = run()
        check(texts[0] == h.sym['EcruteakCityWishingWellStarShardPromptText'],
              'claimed Rare Candy took priority over the shard')
        check(event(candy) and count('STAR_PIECE') == 1, 'exchange reset the prior candy state')
        check(run()[-1] == h.sym['EcruteakCityWishingWellNothingText'] and read('wNumItems') == 0,
              'previously claimed candy was awarded again after exchange')
        load((25, 9), ['STAR_SHARD', 'STAR_PIECE'])
        run()
        check(count('STAR_PIECE') == 1 and count('STAR_SHARD') == 0, 'existing piece duplicated')
        write('wCurItem', items['STAR_PIECE'])
        h.call('CheckItemPocket')
        check(read('wItemAttributeParamBuffer') == 2, 'STAR PIECE is not a Key Item')
        check(h.call('_CheckTossableItem')['c_flag'], 'STAR PIECE can be tossed or sold')
        print(f'{checks} Star Piece well checks passed')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
