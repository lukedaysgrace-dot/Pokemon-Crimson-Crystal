#!/usr/bin/env python3
"""Compiled GS Ball quest regressions, using private emulator cartridge state.

Presentation is suppressed; the ROM executes eligibility, inventory, event,
scene, daily-reset and wild encounter setup code. No player save is loaded.
"""
from itertools import product
from pathlib import Path
import re
import sys

from battletest.symbols import Constants, _parse_constants
from pc_harness import Harness, ROOT
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    events = _parse_constants(root / 'constants/event_flags.asm')
    flags = _parse_constants(root / 'constants/engine_flags.asm')
    con = Constants()
    phone = _parse_constants(root / 'constants/phone_constants.asm')
    sprites = _parse_constants(root / 'constants/sprite_constants.asm')
    environments = _parse_constants(root / 'constants/map_data_constants.asm')
    maps = {}
    group = number = 0
    for line in (root / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s*newgroup\s*(?:;|$)', line):
            group, number = group + 1, 0
        match = re.match(r'\s*map_const (\w+)', line)
        if match:
            number += 1
            maps[match[1]] = group, number
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def event(name, value=None):
        return bool(h.call('EventFlagAction', bc=(2 if value is None else int(value)) << 8,
                           de=events[name])['c'])

    def flag(name, value=None):
        return bool(h.call('EngineFlagAction', bc=(2 if value is None else int(value)) << 8,
                           de=flags[name])['c'])

    def load(name):
        group, number = maps[name]
        write('wMapGroup', group)
        write('wMapNumber', number)
        h.call('LoadMapAttributes')
        h.call('GetCurrentMapSceneID')

    def key_items(items):
        write('wNumKeyItems', len(items))
        write('wKeyItems', [*items, 255])

    def script(name, stop_battle=False, stops=()):
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        texts = []
        for _ in range(350):
            bank, addr = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            for stop in stops:
                if (bank, addr) == h.sym[stop]:
                    return stop, texts
            command = h.mem[bank, addr]
            if command == 0x5f and stop_battle:
                return 'battle', texts
            if command in (0x4c, 0x51, 0x53):
                texts.append((bank, h.mem[bank, addr + 1] | h.mem[bank, addr + 2] << 8))
            elif command in (0x4b, 0x52):
                texts.append((h.mem[bank, addr + 1], h.mem[bank, addr + 2] | h.mem[bank, addr + 3] << 8))
            h.call('RunScriptCommand')
            if read('wScriptMode') == 0:
                return None, texts
        raise RuntimeError(f'{name}: script command budget exceeded')

    byte = h.s('GetScriptByte')
    consume = lambda n: bytes([0xcd, byte & 255, byte >> 8]) * n + b'\xc9'
    presentation = {name: b'\xc9' for name in (
        'Script_faceplayer', 'Script_opentext', 'Script_closetext',
        'Script_waitbutton', 'Script_buttonsound', 'Script_waitsfx',
        'Script_itemnotify', 'Script_pocketisfull', 'Script_specialsound',
        'MapTextbox', 'PrintText', '_UpdateSprites')}
    for name, count in (
        ('Script_applymovement', 3), ('Script_turnobject', 2),
        ('Script_showemote', 3), ('Script_pause', 1), ('Script_cry', 2),
        ('Script_special', 2), ('Script_playmusic', 2), ('Script_playsound', 2)):
        presentation[name] = consume(count)
    received = 'EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER'
    eligible = 'EVENT_CAN_GIVE_GS_BALL_TO_KURT'
    ball = con.item_id('GS_BALL')
    try:
        with patches(h, presentation):
            # The victory queues Bill once, without waiting for the Rising Badge.
            load('BLACKTHORN_GYM_1F')
            write('wJohtoBadges', 0x7f)
            event('EVENT_BEAT_CLAIR', False)
            write('wSpecialPhoneCallID', 0)
            check(script('BlackthornGymClairScript', stop_battle=True)[0] == 'battle'
                  and read('wSpecialPhoneCallID') == 0, 'Bill called before winning')
            with patches(h, {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9'}):
                script('BlackthornGymClairScript')
            check(event('EVENT_BEAT_CLAIR')
                  and read('wSpecialPhoneCallID') == phone['SPECIALCALL_BILL_GS_BALL']
                  and read('wJohtoBadges') == 0x7f, 'Clair victory did not queue Bill immediately')
            write('wEnvironment', environments['INDOOR'])
            check(not h.call('CheckSpecialPhoneCall')['c_flag'], 'Bill call rings inside the gym')
            load('BLACKTHORN_CITY')
            write('wEnvironment', environments['TOWN'])
            check(h.call('CheckSpecialPhoneCall')['c_flag'], 'Bill call cannot ring outside')
            for y in (11, 12):
                write('wPlayerStandingMapX', 22)
                write('wPlayerStandingMapY', y + 4)
                check(h.call('CheckCurrentMapCoordEvents')['c_flag']
                      and h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym['BlackthornCityBillGSBallCallScript'][1],
                      f'Bill immediate call missing on gym exit tile {y}')
            end, _ = script('BlackthornCityBillGSBallCallScript', stops=('Script_SpecialBillCall',))
            check(end == 'Script_SpecialBillCall', 'gym exit did not route to Bill')
            end, _ = script('Script_SpecialBillCall', stops=('Script_ReceivePhoneCall',))
            check(end == 'Script_ReceivePhoneCall' and read('wCurCaller') == phone['PHONE_BILL'],
                  'invitation uses the wrong caller')
            _, texts = script('BillPhoneCallerScript')
            check(texts == [h.sym['BillPhoneGSBallInvitationText']] and read('wSpecialPhoneCallID') == 0,
                  'Bill did not deliver/clear the one-time invitation')
            check(script('BlackthornCityBillGSBallCallScript', stops=('Script_SpecialBillCall',))[0] is None,
                  'gym exit repeats the invitation')
            load('BLACKTHORN_GYM_1F')
            script('BlackthornGymClairScript')
            check(read('wSpecialPhoneCallID') == 0, 'talking to Clair again repeats the call')
            _, texts = script('BillPhoneCallerScript')
            check(texts == [h.sym['BillPhoneNewlyFullText']], 'ordinary Bill storage call changed')

            for side, clair, mobile, badge in product(('Left', 'Right'), (False, True), (0, 11), (0x7f, 0xff)):
                load('GOLDENROD_POKECENTER_1F')
                write('wGoldenrodPokecenter1FSceneID', 0)
                event('EVENT_BEAT_CLAIR', clair)
                event(received, False)
                event(eligible, False)
                write('wJohtoBadges', badge)
                key_items([])
                h.sram_wr(*h.sym['sMobileEventIndex'], mobile)
                x = 3 if side == 'Left' else 4
                write('wPlayerStandingMapX', x + 4)
                write('wPlayerStandingMapY', 10)
                check(h.call('CheckCurrentMapCoordEvents')['c_flag'], f'{side}: doorway trigger missing')
                entry = f'GoldenrodPokecenter1F_GSBallScene{side}'
                check(h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym[entry][1], f'{side}: wrong doorway script')
                _, texts = script(entry)
                check(read('wNumKeyItems') == int(clair), f'{side}: wrong Clair gate (mobile={mobile}, badges={badge})')
                check(event(received) == clair and event(eligible) == clair, f'{side}: reward flags incorrect')
                script(entry)
                check(read('wNumKeyItems') == int(clair), f'{side}: duplicate reward')
                if clair:
                    check(read('wKeyItems') == ball, f'{side}: wrong key item')
                    check(h.sym['GoldenrodPokeCenter1FBillPleaseAcceptGSBallText'] in texts,
                          f'{side}: Bill handoff dialogue missing')
                    check(texts[-1] == h.sym['GoldenrodPokeCenter1FBillAfterGSBallText'],
                          f'{side}: Bill farewell missing after the item handoff')
                    check(read('wMap2ObjectSprite') == sprites['SPRITE_BILL'], f'{side}: handoff NPC is not Bill')

            for side in ('Left', 'Right'):
                event('EVENT_BEAT_CLAIR', True)
                event(received, False)
                event(eligible, False)
                key_items([con.item_id('BICYCLE')] * 25)
                entry = f'GoldenrodPokecenter1F_GSBallScene{side}'
                _, texts = script(entry)
                check(read('wNumKeyItems') == 25 and not event(received) and not event(eligible), f'{side}: full pocket loses reward')
                check(h.sym['GoldenrodPokeCenter1FBillAfterGSBallText'] not in texts,
                      f'{side}: farewell plays without receiving GS Ball')
                key_items([])
                script(entry)
                check(read('wNumKeyItems') == 1 and event(received) and event(eligible), f'{side}: retry failed')

            # Continue the successful reward through Kurt and the shrine.
            load('KURTS_HOUSE')
            event('EVENT_CLEARED_SLOWPOKE_WELL', True)
            event('EVENT_KURT_GAVE_YOU_LURE_BALL', True)
            write('wDailyFlags1', 0)
            script('Kurt1')
            check(read('wNumKeyItems') == 0 and event('EVENT_GAVE_GS_BALL_TO_KURT'), 'Kurt did not take GS Ball')
            check(flag('ENGINE_KURT_MAKING_BALLS'), 'Kurt did not start daily wait')
            _, texts = script('Kurt1')
            check(h.sym['KurtsHouseKurtImCheckingItNowText'] in texts and not event('EVENT_FOREST_IS_RESTLESS'), 'Kurt skipped same-day wait')
            # Exercise the actual daily reset with an elapsed day.
            write('wDailyResetTimer', [1, 10])
            write('wCurDay', 11)
            with patches(h, {'UpdateTime': b'\xc9'}):
                h.call('CheckDailyResetTimer')
            check(not flag('ENGINE_KURT_MAKING_BALLS'), 'next-day reset did not finish Kurt inspection')
            script('Kurt1')
            check(event('EVENT_FOREST_IS_RESTLESS') and not event(eligible), 'Kurt did not activate shrine')
            check(read('wAzaleaTownSceneID') == 2, 'Kurt return scene not queued')
            load('AZALEA_TOWN')
            script('AzaleaTownCelebiScene')
            check(read('wNumKeyItems') == 1 and read('wKeyItems') == ball, 'Kurt did not return GS Ball')
            check(read('wAzaleaTownSceneID') == 0, 'Kurt return scene can repeat')
            load('ILEX_FOREST')
            with patches(h, {'YesNoBox': b'\x37\xc9'}):
                end, _ = script('IlexForestShrineScript', stop_battle=True)
            check(end is None and read('wNumKeyItems') == 1 and event('EVENT_FOREST_IS_RESTLESS'), 'declining shrine consumed event')
            with patches(h, {'YesNoBox': b'\xaf\xc9'}):
                end, _ = script('IlexForestShrineScript', stop_battle=True)
            check(end == 'battle' and read('wCurPartyLevel') == 30, 'shrine did not start level 30 encounter')
            check(h.species_index(read('wTempWildMonSpecies')) == con.species_index('CELEBI'), 'shrine selected wrong Pokemon')
            check(read('wNumKeyItems') == 0 and not event('EVENT_FOREST_IS_RESTLESS'), 'shrine did not consume GS Ball and quest flag')
            check(script('GoldenrodPokecenter1F_GSBallSceneLeft')[0] is None and read('wNumKeyItems') == 0, 'completed quest awards another GS Ball')
        print(f'GS BALL: {checks} checks passed', flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    main()
