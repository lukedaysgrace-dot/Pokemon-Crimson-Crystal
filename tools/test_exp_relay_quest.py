#!/usr/bin/env python3
"""Native six-badge phone/gift regression checks, using private cartridge RAM."""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    events = _parse_constants(root / 'constants/event_flags.asm')
    phone = _parse_constants(root / 'constants/phone_constants.asm')
    called, received = 'EVENT_ELM_CALLED_ABOUT_EXP_RELAY', 'EVENT_GOT_EXP_RELAY_FROM_ELM'
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name, size=1):
        return h.rd(h.s(name), size)

    def event(name, value=None):
        result = h.call('EventFlagAction', bc=(2 if value is None else int(value)) << 8,
                        de=events[name])
        return bool(result['c'])

    def script(name, stops=()):
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        texts = []
        for _ in range(150):
            bank, addr = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            for stop in stops:
                if (bank, addr) == h.sym[stop]:
                    return stop, texts
            command = h.mem[bank, addr]
            if command == 0x4c:
                texts.append((bank, h.mem[bank, addr + 1] | h.mem[bank, addr + 2] << 8))
            elif command == 0x4b:
                texts.append((h.mem[bank, addr + 1],
                              h.mem[bank, addr + 2] | h.mem[bank, addr + 3] << 8))
            h.call('RunScriptCommand')
            if not read('wScriptMode'):
                return None, texts
        raise AssertionError(name + ': script did not finish')

    presentation = {name: b'\xc9' for name in (
        'Script_faceplayer', 'Script_opentext', 'Script_closetext',
        'Script_waitbutton', 'Script_buttonsound', 'Script_waitsfx',
        'Script_itemnotify', 'Script_pocketisfull', 'Script_specialsound',
        'MapTextbox', 'PrintText', 'PlaySFX', 'WaitSFX')}
    try:
        h.call('InitializeItemIndexTable')
        relay = h.call('GetItemIDFromIndex', hl=con.items['EXP_RELAY'])['a']
        bicycle = h.call('GetItemIDFromIndex', hl=con.items['BICYCLE'])['a']
        event(called, False)
        event(received, False)
        print('[all Johto badge subsets; mixed-region totals and existing saves]', flush=True)
        masks = {(mask, 0) for mask in range(256)}
        masks.update((mask, other) for mask, other in product((0, 1, 0x15, 0xaa, 0xff), range(256)))
        for johto, kanto in sorted(masks):
            write('wJohtoBadges', johto)
            write('wKantoBadges', kanto)
            write('wSpecialPhoneCallID', [0, 0])
            h.call('QueueElmExpRelayCall')
            eligible = johto.bit_count() + kanto.bit_count() >= 6
            check(read('wSpecialPhoneCallID', 2) == bytes([phone['SPECIALCALL_EXP_RELAY'] if eligible else 0, 0]),
                  f'badge count/order: {johto:#04x}/{kanto:#04x}')

        write('wJohtoBadges', 0x3f)
        write('wKantoBadges', 0)
        for pending in range(1, phone['SPECIALCALL_EXP_RELAY']):
            write('wSpecialPhoneCallID', [pending, 0])
            h.call('QueueElmExpRelayCall')
            check(read('wSpecialPhoneCallID') == pending, 'overwrote another story call')
        for done_flag in (called, received):
            event(done_flag, True)
            write('wSpecialPhoneCallID', [0, 0])
            h.call('QueueElmExpRelayCall')
            check(read('wSpecialPhoneCallID') == 0, 'called again after ' + done_flag)
            event(done_flag, False)

        with patches(h, presentation):
            print('[incoming call, callback reminder and unchanged Rocket call]', flush=True)
            write('wSpecialPhoneCallID', [phone['SPECIALCALL_EXP_RELAY'], 0])
            _, texts = script('ElmPhoneCallerScript')
            check(texts == [h.sym['ElmPhoneExpRelayText']], 'wrong incoming call')
            check(event(called) and read('wSpecialPhoneCallID') == 0, 'call not marked complete')
            _, texts = script('ElmPhoneCalleeScript')
            check(texts == [h.sym['ElmPhoneExpRelayReminderText']], 'missing gift reminder')
            write('wSpecialPhoneCallID', [phone['SPECIALCALL_WEIRDBROADCAST'], 0])
            _, texts = script('ElmPhoneCallerScript')
            check(texts == [h.sym['ElmPhoneRocketText']] and not read('wSpecialPhoneCallID'),
                  'Radio Tower call changed')

            print('[lab eligibility, full-pocket retry, one-time gift and pre-call pickup]', flush=True)
            for count in range(6):
                write('wJohtoBadges', (1 << count) - 1)
                end, _ = script('ProfElmScript', ('ElmCheckTicket', 'ElmGiveExpRelayScript'))
                check(end == 'ElmCheckTicket', 'gift before six badges')
            write('wJohtoBadges', 0xa5)
            write('wKantoBadges', 0x42)
            write('wNumKeyItems', 25)
            write('wKeyItems', [bicycle] * 25 + [255])
            full = read('wNumKeyItems', 27)
            script('ProfElmScript')
            check(not event(received) and read('wNumKeyItems', 27) == full,
                  'full pocket consumed reward or changed inventory')
            event(called, False)
            write('wSpecialPhoneCallID', [phone['SPECIALCALL_EXP_RELAY'], 0])
            write('wNumKeyItems', [0, 255])
            _, texts = script('ProfElmScript')
            check(event(received), 'gift flag missing')
            check(read('wNumKeyItems', 3) == bytes([1, relay, 255]), 'wrong 16-bit Key Item')
            check(texts[0] == h.sym['ElmExpRelayGiftText'] and texts[-1] == h.sym['ElmExpRelayExplainText'],
                  'gift explanation missing')
            check(not read('wSpecialPhoneCallID'), 'pre-call visit left a stale invitation')
            end, _ = script('ProfElmScript', ('ElmCheckTicket', 'ElmGiveExpRelayScript'))
            check(end == 'ElmCheckTicket' and read('wNumKeyItems') == 1, 'duplicate gift')
            _, texts = script('ElmScript_CallYou')
            check(texts == [h.sym['ElmExpRelayReminderText']], 'missing lab instructions after pickup')
            # Claiming the gift must only clear its own call, never a different one.
            event(received, False)
            write('wNumKeyItems', [0, 255])
            write('wSpecialPhoneCallID', [phone['SPECIALCALL_SSTICKET'], 0])
            script('ProfElmScript')
            check(read('wSpecialPhoneCallID') == phone['SPECIALCALL_SSTICKET'],
                  'gift erased another pending call')
        print(f'{rom.name}: {checks} EXP RELAY quest checks passed', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
