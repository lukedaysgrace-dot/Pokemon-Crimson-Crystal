#!/usr/bin/env python3
"""EXP RELAY arithmetic and real party/confirmation UI on private PyBoy RAM.

Runs on either ROM; never reads or writes player save files.
"""
import io
import math
from pathlib import Path
import sys

from pc_harness import Harness, enc, dec
from battletest.symbols import Constants

ROOT = Path(__file__).resolve().parents[1]


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    checks = 0
    output = ROOT / '_artifacts/exp-relay' / rom.stem
    output.mkdir(parents=True, exist_ok=True)

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name, size=1):
        return h.rd(h.s(name), size)

    def words(values):
        return b''.join(v.to_bytes(2, 'big') for v in values)

    def party(count=2, species=('MEW', 'MIENSHAO'), level=50):
        write('wBattleMode', 0)
        write('wPartyCount', count)
        for slot in range(6):
            info = h.build_temp_mon(con.species_index(species[slot % len(species)]),
                                    [con.move_index('SPLASH'), 0, 0, 0], level=level,
                                    dvs=(0x96, 0x3a), statexp=[0] * 10,
                                    personality=0x61, happiness=123, pokerus=0x23)
            write(f'wPartyMon{slot + 1}', read('wTempMon', 50))
            h.wr(h.s('wPartySpecies') + slot, info['sid'])
            h.wr(h.s('wPartyMonNicknames') + slot * 11, enc(f'MON{slot + 1}@@@@@@@'))
            write(f'wPartyMon{slot + 1}Status', 8)
            write(f'wPartyMon{slot + 1}HP', [0, 1])
        h.wr(h.s('wPartySpecies') + count, 255)
        write('wCurPartyMon', 0)
        write('wCurPartySpecies', read('wPartyMon1Species'))
        write('wPartyMenuCursor', 1)

    def expected_stats(slot, values):
        prefix = f'wPartyMon{slot + 1}'
        write('wCurSpecies', read(prefix + 'Species'))
        h.call('GetBaseData')
        base = read('wBaseStats', 6)
        a, b = read(prefix + 'DVs', 2)
        dv = [((a >> 4 & 1) << 3) | ((a & 1) << 2) | ((b >> 4 & 1) << 1) | (b & 1),
              a >> 4, a & 15, b >> 4, b & 15, b & 15]
        level = read(prefix + 'Level')
        result = []
        for i in range(6):
            value = values[min(i, 4)]
            root = min(255, math.isqrt(value) + (math.isqrt(value) ** 2 < value))
            result.append(min(999, ((base[i] + dv[i]) * 2 + root // 4) * level // 100
                              + (level + 10 if i == 0 else 5)))
        return words(result)

    def snapshot():
        return read('wPartyMons', 6 * 50)

    try:
        h.call('InitializeItemIndexTable')
        relay = h.call('GetItemIDFromIndex', hl=con.items['EXP_RELAY'])['a']
        write('wCurItem', relay)
        write('wNumKeyItems', [1, relay, 255])
        check(h.call('GetItemIndexFromID', a=relay)['hl'] == 0x130, '16-bit item round trip')
        check(not h.call('IsRepeatableConsumable')['c_flag'], 'Key Item is not a consumable')

        print('[five-word addition, saturation, stat formula and unrelated data]', flush=True)
        for count in range(2, 7):
            for donor, recipient in ((0, count - 1), (count - 1, 0)):
                for source, target in (([1, 255, 256, 32768, 65535], [2, 1, 65535, 32767, 1]),
                                       ([65535] * 5, [65535] * 5), ([0] * 5, [1234] * 5)):
                    party(count)
                    write(f'wPartyMon{donor + 1}StatExp', words(source))
                    write(f'wPartyMon{recipient + 1}StatExp', words(target))
                    result = [min(65535, a + b) for a, b in zip(source, target)]
                    expected = {donor: expected_stats(donor, [0] * 5),
                                recipient: expected_stats(recipient, result)}
                    before = snapshot()
                    check(not h.call('ExpRelayTransfer', bc=donor << 8 | recipient)['c_flag'], 'valid pair rejected')
                    after = snapshot()
                    for slot, values in ((donor, [0] * 5), (recipient, result)):
                        check(read(f'wPartyMon{slot + 1}StatExp', 10) == words(values), 'five Stat EXP words')
                        check(read(f'wPartyMon{slot + 1}MaxHP', 12) == expected[slot], 'all six calculated stats')
                    allowed = {slot * 50 + offset for slot in (donor, recipient)
                               for offset in list(range(11, 21)) + list(range(38, 50))}
                    check(all(a == b for i, (a, b) in enumerate(zip(before, after)) if i not in allowed),
                          'regular EXP, HP, DVs, personality, moves, happiness or other party data changed')
                    check(not h.call('ExpRelayTransfer', bc=donor << 8 | recipient)['c_flag'], 'repeated use rejected')
                    check(snapshot() == after, 'repeated empty donor changed data')

        print('[species, forms, levels and both stat rules]', flush=True)
        for mode in (0, 1):
            write('wGameplayRules', mode << 1)
            for species in ('AEGISLASH', 'ZORUA', 'ZOROARK', 'MIENFOO', 'MIENSHAO',
                            'HIPPOPOTAS', 'HIPPOWDON', 'PONYTA', 'DIPPLIN', 'SHUCKLE', 'MEW'):
                for level in (1, 50, 100):
                    party(species=(species,), level=level)
                    source, target = [65535, 1, 12345, 20000, 50000], [0, 255, 30000, 50000, 10000]
                    write('wPartyMon1StatExp', words(source))
                    write('wPartyMon2StatExp', words(target))
                    expected = [expected_stats(0, [0] * 5), expected_stats(1, [min(65535, a+b) for a,b in zip(source, target)])]
                    check(not h.call('ExpRelayTransfer', bc=1)['c_flag'], species + ' transfer')
                    for slot in range(2):
                        check(read(f'wPartyMon{slot + 1}MaxHP', 12) == expected[slot], species + ' stat mode formula')

        party()
        write('wPartyMon1HP', [3, 231])
        write('wPartyMon2HP', [0, 0])
        h.call('ExpRelayTransfer', bc=1)
        check(read('wPartyMon1HP', 2) == read('wPartyMon1MaxHP', 2), 'donor HP clamped')
        check(read('wPartyMon2HP', 2) == bytes(2), 'fainted recipient revived')

        print('[invalid pairs, Eggs and party counts]', flush=True)
        for count in (0, 1, 2, 6, 7, 255):
            party(min(count, 6))
            write('wPartyCount', count)
            for donor, recipient in ((0, 0), (0, 6), (6, 0), (255, 1), (1, 255), (0, 1)):
                before = snapshot()
                result = h.call('ExpRelayTransfer', bc=donor << 8 | recipient)
                invalid = count not in range(2, 7) or donor == recipient or max(donor, recipient) >= count
                check(result['c_flag'] == invalid, 'invalid pair guard')
                if invalid:
                    check(snapshot() == before, 'rejected pair mutated party')
        for side in (0, 1):
            for value in (0, 253, 255):
                party()
                h.wr(h.s('wPartySpecies') + side, value)
                before = snapshot()
                check(h.call('ExpRelayTransfer', bc=1)['c_flag'], 'invalid species or Egg accepted')
                check(snapshot() == before, 'invalid species changed party')
        party()
        write('wBattleMode', 1)
        before = snapshot()
        check(h.call('ExpRelayTransfer', bc=1)['c_flag'] and snapshot() == before, 'battle allowed transfer')

        print('[native item dispatch, party menus and confirmation buttons]', flush=True)
        party()
        write('wPartyMon1StatExp', words([10000] * 5))
        # Ensure the party graphics display meaningful, legal initial stats.
        h.call('ExpRelayRecalculate', a=0)
        h.call('ExpRelayRecalculate', a=1)
        # A real Bag opens from the overworld with these fonts already loaded.
        # This direct-call fixture starts at the title screen instead.
        lcdc = h.mem[0xFF40]
        h.mem[0xFF40] = lcdc & 0x7f
        h.call('LoadStandardFont')
        h.call('LoadFontsExtra')
        h.mem[0xFF40] = lcdc
        write('wCurItem', relay)
        write('wOptions', 3)  # instant text
        saved = io.BytesIO()
        h.pyboy.save_state(saved)

        def tick(n=1):
            h.pyboy.tick(n, False)

        def screenshot(name):
            h.pyboy.tick(1, True)
            h.pyboy.screen.image.save(output / name)

        def text():
            return dec(read('wTileMap', 360))

        def done():
            return h.reg.PC in (0xC0F1, 0xC0F3)

        def until(predicate, label):
            for _ in range(500):
                if predicate():
                    return
                tick()
            raise AssertionError(label + ': PC=' + hex(h.reg.PC) + '\n' + text())

        def press(button):
            h.pyboy.button_press(button)
            tick(4)
            h.pyboy.button_release(button)
            tick(20)

        def begin():
            saved.seek(0)
            h.pyboy.load_state(saved)
            bank, address = h.sym['DoItemEffect']
            if bank:
                h.set_rom_bank(bank)
            h.wr(0xC0F0, [0xF3, 0x18, 0xFE])
            h.wr(0xC0F6, [0xFB, 0xC3, address & 255, address >> 8])
            h.wr16(0xC0EC, 0xC0F0)
            h.reg.SP, h.reg.PC = 0xC0EC, 0xC0F6
            until(lambda: 'Donate from whom?' in text(), 'donor menu')
            tick(30)

        for stage in ('donor', 'recipient', 'same', 'no', 'confirm_b', 'success'):
            begin()
            if stage == 'donor':
                screenshot('donor.png')
            before = snapshot()
            if stage == 'donor':
                press('b')
            else:
                press('a')
                until(lambda: 'Receive on whom?' in text(), 'recipient menu')
                tick(40)
                if stage == 'recipient':
                    press('b')
                elif stage == 'same':
                    press('a')
                    until(lambda: 'Choose a different' in text(), 'same-Pokemon rejection')
                    tick(40)
                    press('a')
                    until(lambda: 'Receive on whom?' in text(), 'recipient retry')
                    tick(40)
                    press('b')
                else:
                    press('down')
                    press('a')
                    pages = []
                    tick(40)
                    for _ in range(8):
                        pages.append(text())
                        if 'max is lost' in text():
                            break
                        press('a')
                        tick(30)
                    check('max is lost' in text(), 'confirmation warns about overflow')
                    tick(40)
                    check(all(name in ''.join(pages) for name in ('MON1', 'MON2')), 'confirmation identifies both mons')
                    if stage == 'success':
                        screenshot('confirmation.png')
                    if stage == 'no':
                        press('down')
                        press('a')
                    elif stage == 'confirm_b':
                        press('b')
                    else:
                        press('a')
                        until(lambda: 'Stat EXP relayed' in text(), 'success message')
                        tick(120)
                        screenshot('success.png')
                        press('a')
            until(done, stage + ' return')
            if stage == 'success':
                check(read('wPartyMon1StatExp', 10) == bytes(10), 'UI donor cleared')
                check(read('wPartyMon2StatExp', 10) == words([10000] * 5), 'UI recipient increased')
                check(read('wItemEffectSucceeded') == 1, 'UI success flag')
            else:
                check(snapshot() == before, stage + ' cancellation mutated party')
                check(read('wItemEffectSucceeded') == 0, stage + ' cancellation success flag')
            check(read('wNumKeyItems', 3) == bytes([1, relay, 255]), 'Key Item consumed')
        print(f'{rom.name}: {checks} EXP RELAY checks passed', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
