#!/usr/bin/env python3
"""Exercise the sixteen-badge campaign against the compiled release ROM.

Uses private cartridge state. Presentation is skipped, but badge checks,
inventory, map callbacks, scene selection and progression flags run natively.
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
    con = Constants()
    events = _parse_constants(root / 'constants/event_flags.asm')
    flags = _parse_constants(root / 'constants/engine_flags.asm')
    landmarks = _parse_constants(root / 'constants/landmark_constants.asm')
    phone = _parse_constants(root / 'constants/phone_constants.asm')
    map_data = _parse_constants(root / 'constants/map_data_constants.asm')
    map_setup = _parse_constants(root / 'constants/map_setup_constants.asm')
    maps = {}
    group = number = 0
    for line in (root / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s*newgroup\s*(?:;|$)', line):
            group, number = group + 1, 0
        match = re.match(r'\s*map_const (\w+)', line)
        if match:
            number += 1
            maps[match[1]] = group, number
    checks, failures = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)
            print('FAIL:', message, flush=True)

    # The historical EVENT_113/114 names are stale numeric comments: their
    # actual pre-change IDs are $116/$117, after earlier inserted events.
    check(events['EVENT_ELM_CALLED_AFTER_SURGE'] == 0x116
          and events['EVENT_ELM_PAID_RETURN_FARE'] == 0x117,
          'Elm progression moved existing event IDs or save layout')

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def event(name, value=None):
        result = h.call('EventFlagAction', bc=(2 if value is None else int(value)) << 8, de=events[name])
        return bool(result['c'])

    def badges(count):
        write('wJohtoBadges', (1 << min(count, 8)) - 1)
        write('wKantoBadges', (1 << max(count - 8, 0)) - 1)

    def surge(owned):
        h.call('EngineFlagAction', bc=int(owned) << 8, de=flags['ENGINE_THUNDERBADGE'])

    def load(name):
        group, number = maps[name]
        write('wMapGroup', group)
        write('wMapNumber', number)
        h.call('LoadMapAttributes')
        h.call('GetCurrentMapSceneID')

    def script(name, stops=(), stop_before_battle=False):
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        texts, movements = [], []
        for _ in range(300):
            bank, addr = read('wScriptBank'), h.rd16(h.s('wScriptPos'))
            for stop in stops:
                if (bank, addr) == h.sym[stop]:
                    return stop, texts, movements
            command = h.mem[bank, addr]
            if stop_before_battle and command == 0x5f:  # startbattle
                return 'startbattle', texts, movements
            pointer = h.mem[bank, addr + 1] | h.mem[bank, addr + 2] << 8
            if command in (0x4c, 0x51, 0x53):  # writetext / jumptextfaceplayer / jumptext
                texts.append((bank, pointer))
            elif command in (0x4b, 0x52):  # farwritetext / farjumptext
                texts.append((h.mem[bank, addr + 1], h.mem[bank, addr + 2] | h.mem[bank, addr + 3] << 8))
            elif command == 0x69:  # applymovement
                movements.append(h.mem[bank, addr + 1])
            h.call('RunScriptCommand')
            if read('wScriptMode') == 0:
                return None, texts, movements
        raise RuntimeError(f'{name}: command budget exceeded')

    byte = h.s('GetScriptByte')
    consume = lambda count: bytes([0xcd, byte & 255, byte >> 8]) * count + b'\xc9'
    presentation = {name: b'\xc9' for name in (
        'Script_faceplayer', 'Script_opentext', 'Script_closetext',
        'Script_waitbutton', 'Script_buttonsound', 'Script_waitsfx',
        'Script_itemnotify', 'Script_pocketisfull', 'Script_specialsound',
        'MapTextbox', 'PrintText', 'PlaySFX', 'WaitSFX')}
    presentation.update({
        'Script_applymovement': consume(3), 'Script_turnobject': consume(2),
        'Script_special': consume(2), 'Script_pause': consume(1),
        'Script_playsound': consume(2), 'Script_warp': consume(4),
        'Script_follow': consume(2), 'Script_stopfollow': b'\xc9',
        'Script_halloffame': b'\xc9',
    })
    special_bank, special_addr = h.sym['Script_special']
    native_special = bytes(h.mem[special_bank, special_addr:special_addr + len(presentation['Script_special'])])
    try:
        with patches(h, presentation):
            print('[Blue badge gate, other Kanto gyms without extra checks, and migrated map flags]', flush=True)
            gym_entries = (
                ('VIRIDIAN_GYM', 'ViridianGymBlueScript', 'ENGINE_EARTHBADGE', 15),
            )
            for map_name, entry, own, needed in gym_entries:
                for count in (needed - 1, needed):
                    badges(count)
                    h.call('EngineFlagAction', bc=0, de=flags[own])
                    load(map_name)
                    end, _, _ = script(entry, (entry + '.Ready',))
                    check(bool(end) == (count == needed), f'{entry}: {count} badges, needs {needed}')

            for map_name, entry, trainer in (
                    ('PEWTER_GYM', 'PewterGymBrockScript', 'BROCK'),
                    ('CERULEAN_GYM', 'CeruleanGymMistyScript', 'MISTY'),
                    ('VERMILION_GYM', 'VermilionGymSurgeScript', 'LT_SURGE'),
                    ('CELADON_GYM', 'CeladonGymErikaScript', 'ERIKA'),
                    ('SAFFRON_GYM', 'SaffronGymSabrinaScript', 'SABRINA'),
                    ('FUCHSIA_GYM', 'FuchsiaGymJanineScript', 'JANINE'),
                    ('SEAFOAM_GYM', 'SeafoamGymBlaineScript', 'BLAINE')):
                badges(0)
                load(map_name)
                end, _, _ = script(entry, stop_before_battle=True)
                check(end == 'startbattle' and read('wOtherTrainerClass') == con.trainer_classes[trainer],
                      f'{entry}: an unwanted gym prerequisite remains')

            for female in (False, True):
                badges(15)
                h.call('EngineFlagAction', bc=int(female) << 8, de=flags['ENGINE_PLAYER_IS_FEMALE'])
                load('VIRIDIAN_GYM')
                end, texts, _ = script('ViridianGymBlueScript', stop_before_battle=True)
                expected = 'LeaderBlueReadyGirlText' if female else 'LeaderBlueReadyBoyText'
                other = 'LeaderBlueReadyBoyText' if female else 'LeaderBlueReadyGirlText'
                check(end == 'startbattle' and h.sym[expected] in texts and h.sym[other] not in texts,
                      f'Blue gender greeting: female={female}')
            h.call('EngineFlagAction', bc=0, de=flags['ENGINE_PLAYER_IS_FEMALE'])

            # Every middle-badge combination, with unrelated late badges present too.
            for johto, kanto in product((0x7f, 0xff), range(256)):
                write('wJohtoBadges', johto)
                write('wKantoBadges', kanto)
                script('CheckSouthernKantoAccessScript')
                check(bool(read('wScriptVar')) == (johto == 0xff and kanto & 0x3f == 0x3f),
                      f'southern access: Johto={johto:#x}, Kanto={kanto:#x}')

            for count, returned in product(range(16), (False, True)):
                for map_name in ('CINNABAR_ISLAND', 'VIRIDIAN_GYM', 'VIRIDIAN_CITY'):
                    badges(count)
                    event('EVENT_BLUE_IN_CINNABAR', returned)
                    event('EVENT_VIRIDIAN_GYM_BLUE', not returned)
                    load(map_name)
                    h.call('RunMapCallback', a=2 if map_name != 'VIRIDIAN_CITY' else 5)
                    expected = count >= 15 and returned
                    check(event('EVENT_BLUE_IN_CINNABAR') == expected, f'{map_name}: Blue return at {count}, old={returned}')
                    check(event('EVENT_VIRIDIAN_GYM_BLUE') == (not expected), f'{map_name}: Blue gym visibility at {count}')
            for kanto in (0x80, 0xbf, 0xff):
                write('wJohtoBadges', 255)
                write('wKantoBadges', kanto)
                event('EVENT_BLUE_IN_CINNABAR', True)
                event('EVENT_VIRIDIAN_GYM_BLUE', False)
                script('UpdateBlueReturnScript')
                ready = kanto.bit_count() >= 7
                check(event('EVENT_BLUE_IN_CINNABAR') == ready, f'old Earth Badge bypassed Blue return: Kanto={kanto:#x}')
                check(read('wKantoBadges') == kanto, 'Blue migration changed an earned badge')
            # Calling the city script directly also verifies its callback-independent repair.
            for count in (14, 15):
                badges(count)
                event('EVENT_BLUE_IN_CINNABAR', False)
                event('EVENT_VIRIDIAN_GYM_BLUE', True)
                load('CINNABAR_ISLAND')
                _, texts, _ = script('CinnabarIslandBlue')
                check(event('EVENT_BLUE_IN_CINNABAR') == (count == 15), f'Blue departure at {count}')
                check(event('EVENT_VIRIDIAN_GYM_BLUE') == (count < 15), f'Blue gym unlock at {count}')
                expected_text = 'CinnabarIslandBlueReturnText' if count == 15 else 'CinnabarIslandBlueNeedBadgesText'
                check(h.sym[expected_text] in texts, f'Blue departure text at {count}')

            for hall in (False, True):
                badges(15)
                event('EVENT_BEAT_ELITE_FOUR', hall)
                event('EVENT_CRYSTAL_CAPE_CALL_PENDING', False)
                write('wSpecialPhoneCallID', [0, 0])
                load('VIRIDIAN_GYM')
                with patches(h, {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9'}):
                    _, texts, _ = script('ViridianGymBlueScript')
                expected = 'LeaderBlueRematchNextText' if hall else 'LeaderBlueLeagueNextText'
                check(h.sym[expected] in texts and read('wKantoBadges') == 255, f'Blue badge/advice: old Champion={hall}')
                check(read('wSpecialPhoneCallID') == 0 and not event('EVENT_CRYSTAL_CAPE_CALL_PENDING'),
                      'Blue still queued Crystal after her invitation moved to Erika')

            print('[Erika exit rings Crystal once and invites the player to Cerulean Cape]', flush=True)
            badges(8)
            event('EVENT_CRYSTAL_CAPE_CALL_PENDING', False)
            write('wSpecialPhoneCallID', [0, 0])
            load('CELADON_CITY')
            end, _, _ = script('CeladonCityCrystalCapeCallScript', ('Script_SpecialCrystalCall',))
            check(end is None, 'Crystal called outside Erika\'s gym before the victory')
            load('CELADON_GYM')
            script('CeladonGymErikaScript', stop_before_battle=True)
            check(not event('EVENT_CRYSTAL_CAPE_CALL_PENDING') and read('wSpecialPhoneCallID') == 0,
                  'Erika queued the cape call before being defeated')
            with patches(h, {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9'}):
                script('CeladonGymErikaScript')
            check(read('wKantoBadges') == 8 and event('EVENT_BEAT_ERIKA'), 'Erika did not award the Rainbow Badge')
            check(event('EVENT_CRYSTAL_CAPE_CALL_PENDING')
                  and read('wSpecialPhoneCallID') == phone['SPECIALCALL_CRYSTAL_CAPE'],
                  'Erika did not queue the cape invitation')
            check(not h.call('SpecialCallOnlyWhenOutside')['c_flag'], 'Crystal invitation can ring inside the gym')
            load('CELADON_CITY')
            for y in (29, 30):
                write('wPlayerStandingMapX', 14)
                write('wPlayerStandingMapY', y + 4)
                triggered = h.call('CheckCurrentMapCoordEvents')['c_flag']
                check(triggered and h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym['CeladonCityCrystalCapeCallScript'][1],
                      f'Crystal call missing on Erika gym exit tile {y}')
                end, _, _ = script('CeladonCityCrystalCapeCallScript', ('Script_SpecialCrystalCall',))
                check(end == 'Script_SpecialCrystalCall', f'Erika exit tile {y} did not ring Crystal immediately')
            end, _, _ = script('Script_SpecialCrystalCall', ('Script_ReceivePhoneCall',))
            check(end == 'Script_ReceivePhoneCall' and read('wCurCaller') == phone['PHONE_CRYSTAL'],
                  'Erika exit call selected the wrong caller')
            _, texts, _ = script('CrystalPhoneCallerScript')
            check(texts == [h.sym['CrystalPhoneCapeCallText1'], h.sym['CrystalPhoneCapeCallText2']],
                  'Crystal invitation did not use the Cerulean Cape dialogue')
            check(not event('EVENT_CRYSTAL_CAPE_CALL_PENDING') and read('wSpecialPhoneCallID') == 0,
                  'Crystal invitation did not clear its pending state')
            check(script('CeladonCityCrystalCapeCallScript')[0] is None,
                  'Erika gym exit repeated the cape call')
            load('CELADON_GYM')
            script('CeladonGymErikaScript')
            check(not event('EVENT_CRYSTAL_CAPE_CALL_PENDING') and read('wSpecialPhoneCallID') == 0,
                  'Talking to Erika again requeued the invitation')

            load('ROUTE_5')
            for powered in (False, True):
                event('EVENT_RETURNED_MACHINE_PART', powered)
                event('EVENT_BEAT_MISTY', False)
                _, texts, _ = script('Route5PokefanMScript')
                expected = 'Route5MistyNotBeatenText' if powered else 'Route5PokefanMText'
                check(texts == [h.sym[expected]], f'Route 5 blocker reason: power restored={powered}')

            write('wJohtoBadges', 0x7f)
            write('wKantoBadges', 1)
            load('VICTORY_ROAD_GATE')
            write('wVictoryRoadGateSceneID', 0)
            _, _, moves = script('VictoryRoadGateBadgeCheckScript')
            check(bool(moves) and read('wVictoryRoadGateSceneID') == 0, 'eight mixed-region badges passed the Johto guard')

            for count, hall in product((10, 11), (False, True)):
                badges(count)
                event('EVENT_BEAT_ELITE_FOUR', hall)
                for map_name, entry, y, columns in (('ROUTE_5_SAFFRON_GATE', 'Route5SaffronGateBadgeCheck', 5, range(2, 8)),
                                                    ('ROUTE_6_SAFFRON_GATE', 'Route6SaffronGateBadgeCheck', 1, (4, 5))):
                    load(map_name)
                    _, _, moves = script(entry)
                    check(bool(moves) == (count < 11), f'{entry}: {count}, old Champion={hall}')
                    for x in columns:
                        write('wPlayerStandingMapX', x + 4)
                        write('wPlayerStandingMapY', y + 4)
                        triggered = h.call('CheckCurrentMapCoordEvents')['c_flag']
                        check(triggered and h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym[entry][1],
                              f'{entry}: entrance trigger missing at {x},{y}')

            # Use compiled blocks, collisions and coord triggers to find a bypass,
            # ignoring NPCs so moving around the guard cannot hide a route.
            block_bank, block_addr = h.sym['Route5SaffronGate_Blocks']
            coll_bank, coll_addr = h.sym['TilesetGateColl']
            walkable = set()
            for y in range(8):
                for x in range(10):
                    block = h.mem[block_bank, block_addr + (y // 2) * 5 + x // 2]
                    collision = h.mem[coll_bank, coll_addr + block * 4 + (y % 2) * 2 + x % 2]
                    if collision in (0x00, 0x70, 0x71):
                        walkable.add((x, y))

            for map_name, entry, source_y, exit_y in (('ROUTE_5_SAFFRON_GATE', 'Route5SaffronGateBadgeCheck', 1, 7),
                                                      ('ROUTE_6_SAFFRON_GATE', 'Route6SaffronGateBadgeCheck', 6, 0)):
                load(map_name)
                triggers = set()
                for x, y in walkable:
                    write('wPlayerStandingMapX', x + 4)
                    write('wPlayerStandingMapY', y + 4)
                    if h.call('CheckCurrentMapCoordEvents')['c_flag']:
                        check(h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym[entry][1], f'{entry}: unexpected coord script')
                        triggers.add((x, y))
                for blocked in (set(), triggers):
                    reached = {(4, source_y), (5, source_y)}
                    frontier = list(reached)
                    while frontier:
                        x, y = frontier.pop()
                        for tile in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                            if tile in walkable and tile not in blocked and tile not in reached:
                                reached.add(tile)
                                frontier.append(tile)
                    escaped = any((x, exit_y) in reached for x in (4, 5))
                    check(escaped == (not blocked), f'{entry}: collision/coord path bypass, blocked={bool(blocked)}')

            for count in (11, 12, 13, 14):
                badges(count)
                event('EVENT_BEAT_JANINE', True)
                # Janine alone cannot remove the coast blockade or alter her win flag.
                h.call('EngineFlagAction', bc=0x100, de=flags['ENGINE_SOULBADGE'])
                load('VIRIDIAN_CITY')
                h.call('RunMapCallback', a=2)
                h.call('LoadObjectMasks')
                hidden = [bool(h.rd(h.s('wObjectMasks') + i)) for i in range(5, 9)]
                check(hidden == [count == 14] * 4, f'Viridian southern blockers at {count}: {hidden}')
                check(event('EVENT_BEAT_JANINE'), 'coast callback cleared Janine victory')

            print('[Wing gifts, regional gossip, radio and final Oak invitation]', flush=True)
            for johto, kanto in product(range(256), (0, 255)):
                event('EVENT_GOT_SILVER_WING', False)
                write('wNumKeyItems', 0)
                write('wKeyItems', [255])
                write('wJohtoBadges', johto)
                write('wKantoBadges', kanto)
                load('PEWTER_CITY')
                script('PewterCityGrampsScript')
                check(event('EVENT_GOT_SILVER_WING') == (johto == 255),
                      f'Silver Wing eligibility: Johto={johto:#x}, Kanto={kanto:#x}')
            event('EVENT_GOT_SILVER_WING', False)
            badges(8)
            write('wNumKeyItems', 25)
            write('wKeyItems', [con.items['BICYCLE']] * 25 + [255])
            script('PewterCityGrampsScript')
            check(not event('EVENT_GOT_SILVER_WING'), 'full pocket lost the Silver Wing')
            write('wNumKeyItems', 0)
            write('wKeyItems', [255])
            script('PewterCityGrampsScript')
            check(event('EVENT_GOT_SILVER_WING') and read('wNumKeyItems') == 1, 'Silver Wing retry failed')
            script('PewterCityGrampsScript')
            check(read('wNumKeyItems') == 1, 'Silver Wing duplicated')

            var = h.s('wScriptVar')
            for johto, kanto, beasts in product(range(256), (0, 255), (False, True)):
                write('wJohtoBadges', johto)
                write('wKantoBadges', kanto)
                event('EVENT_GOT_RAINBOW_WING', False)
                event('EVENT_BEAT_ELITE_FOUR', False)
                load('TIN_TOWER_1F')
                force_beasts = bytes([0x3e, int(beasts), 0xea, var & 255, var >> 8, 0xc9])
                with patches(h, {'Script_special': native_special, 'BeastsCheck': force_beasts}):
                    end, _, _ = script('TinTower1F_MapScripts.NPCsCallback',
                                       ('TinTower1F_MapScripts.FaceBeasts', 'TinTower1F_MapScripts.GotRainbowWing'))
                check(end.endswith('.GotRainbowWing') == (johto == 255 and beasts),
                      f'Rainbow Wing sage: Johto={johto:#x}, Kanto={kanto:#x}, beasts={beasts}')

            for johto in (0x7f, 0xff):
                write('wJohtoBadges', johto)
                end, _, _ = script('BuenaPhoneScript_Random2',
                                   ('BuenaPhoneScript_Random2.Kanto', 'BuenaPhoneScript_Random2.Jumptable'))
                check(end.endswith('.Kanto') == (johto == 0xff), f'Buena Kanto gossip at Johto={johto:#x}')

            for count, hall, clair, cape, opened in product((15, 16), (False, True), (False, True), (False, True), (False, True)):
                badges(count)
                event('EVENT_BEAT_ELITE_FOUR', hall)
                event('EVENT_BEAT_CLAIR_REMATCH', clair)
                event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE', cape)
                event('EVENT_OPENED_MT_SILVER', opened)
                write('wSpecialPhoneCallID', [0, 0])
                script('QueueOakMtSilverCallScript')
                ready = count == 16 and hall and clair and cape and not opened
                check(read('wSpecialPhoneCallID') == (phone['SPECIALCALL_OAK_MT_SILVER'] if ready else 0),
                      f'final Oak invitation: {count}, hall={hall}, Clair={clair}, cape={cape}, opened={opened}')

            load('ROUTE_25')
            for johto, kanto, appeared in product((0, 0xff), (0, 8, 0x80, 0xf7, 0xff), (False, True)):
                write('wJohtoBadges', johto)
                write('wKantoBadges', kanto)
                event('EVENT_ROUTE_25_MEW_APPEARED', appeared)
                end, _, _ = script('Route25MewAppearsScript',
                                   ('Route25MewAppearsScript.Done', 'Route25MewAppearsScript.Appear'))
                check(end.endswith('.Appear') == (bool(kanto & 8) and not appeared),
                      f'Mew appearance: Johto={johto:#x}, Kanto={kanto:#x}, already appeared={appeared}')

            for result in (0, 1):
                badges(16)
                event('EVENT_BEAT_ELITE_FOUR', True)
                event('EVENT_BEAT_CLAIR_REMATCH', True)
                event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE', False)
                event('EVENT_OPENED_MT_SILVER', False)
                write('wSpecialPhoneCallID', [0, 0])
                force_result = bytes([0x3e, result, 0xea, var & 255, var >> 8, 0xc9])
                with patches(h, {'Script_startbattle': force_result, 'Script_reloadmapafterbattle': b'\xc9',
                                 'Script_playmusic': consume(2), 'Script_playmapmusic': b'\xc9'}):
                    _, texts, _ = script('Route25CrystalBattle')
                won = result == 0
                check(event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE') == won, f'cape victory/retry flag, result={result}')
                check(read('wSpecialPhoneCallID') == (phone['SPECIALCALL_OAK_MT_SILVER'] if won else 0),
                      f'cape was final condition but Oak invitation was wrong, result={result}')
                expected = 'Route25CrystalAfterText' if won else 'Route25CrystalTryAgainText'
                check(h.sym[expected] in texts, f'cape win/loss after-battle text, result={result}')

            print('[Final phone rematch tiers follow the League and Falkner, independent of Kanto power]', flush=True)
            phone_entries = (
                ('NATIONAL_PARK', 'TrainerSchoolboyJack1.Fight4'),
                ('OLIVINE_LIGHTHOUSE_2F', 'TrainerSailorHuey.Fight3'),
                ('ROUTE_32', 'TrainerFisherRalph1.Fight4'),
                ('ROUTE_33', 'TrainerHikerAnthony.Fight4'),
                ('ROUTE_34', 'TrainerCamperTodd1.Fight4'), ('ROUTE_34', 'TrainerPicnickerGina1.Fight4'),
                ('ROUTE_35', 'TrainerBugCatcherArnie.Fight4'), ('ROUTE_36', 'TrainerSchoolboyAlan1.Fight4'),
                ('ROUTE_38', 'TrainerLassDana1.Fight4'), ('ROUTE_38', 'TrainerSchoolboyChad1.Fight4'),
                ('ROUTE_42', 'TrainerFisherTully.Fight3'), ('ROUTE_43', 'TrainerPokemaniacBrent.Fight3'),
                ('ROUTE_43', 'TrainerPicnickerTiffany.Fight3'), ('ROUTE_44', 'TrainerBirdKeeperVance1.Fight2'),
                ('ROUTE_44', 'TrainerFisherWilton1.Fight2'), ('ROUTE_45', 'TrainerHikerParry.Fight2'),
                ('ROUTE_46', 'TrainerPicnickerErin1.Fight2'),
            )
            battle_stub = {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9'}
            for map_name, entry in phone_entries:
                for hall, falkner, power in product((False, True), repeat=3):
                    event('EVENT_BEAT_ELITE_FOUR', hall)
                    event('EVENT_BEAT_FALKNER_REMATCH', falkner)
                    event('EVENT_RESTORED_POWER_TO_KANTO', power)
                    load(map_name)
                    with patches(h, battle_stub):
                        script(entry)
                    h.call('ReadTrainerParty')
                    levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
                    check(max(levels) == (77 if falkner else 74) if hall else max(levels) <= 45,
                          f'{entry}: hall={hall}, Falkner={falkner}, power={power}, levels={levels}')

            print('[Diglett Cave: officer removed, Route 2 blocker follows Surge rather than Mt. Moon]', flush=True)
            for defeated_surge, defeated_rival in product((False, True), repeat=2):
                event('EVENT_BEAT_LTSURGE', defeated_surge)
                event('EVENT_BEAT_RIVAL_IN_MT_MOON', defeated_rival)
                load('ROUTE_2')
                h.call('LoadObjectMasks')
                check(bool(h.rd(h.s('wObjectMasks') + 6)) == defeated_surge,
                      f'Diglett entrance blocker: Surge={defeated_surge}, rival={defeated_rival}')
            load('DIGLETTS_CAVE')
            check(read('wCurMapObjectEventCount') == 1, 'Diglett Cave officer still occupies a map slot')
            check(h.rd16(h.s('wMap1ObjectScript')) == h.sym['DiglettsCavePokefanMScript'][1],
                  'Diglett Cave regular Pokefan was removed instead of the officer')

            print('[Fuchsia shoreline: all three middle Kanto badges; old rock flags do not bypass them]', flush=True)
            with patches(h, {'BufferScreen': b'\xc9'}):
                for janine, erika, sabrina, old_rocks in product((False, True), repeat=4):
                    badges(11)
                    event('EVENT_BEAT_JANINE', janine)
                    for flag, owned in (('ENGINE_SOULBADGE', janine), ('ENGINE_RAINBOWBADGE', erika), ('ENGINE_MARSHBADGE', sabrina)):
                        h.call('EngineFlagAction', bc=int(owned) << 8, de=flags[flag])
                    event('EVENT_CINNABAR_ROCKS_CLEARED', old_rocks)
                    load('ROUTE_20')
                    h.call('RunMapCallback', a=map_setup['MAPCALLBACK_NEWMAP'])
                    check(event('EVENT_CINNABAR_ROCKS_CLEARED') == old_rocks,
                          'Route 20 still sets the old shoreline unlock')
                    load('ROUTE_19')
                    h.call('LoadBlockData')
                    for x, y in ((6, 6), (8, 6), (10, 6), (12, 8), (4, 8), (10, 10)):
                        loc = h.call('GetBlockLocation', de=((x + 4) << 8) | (y + 4))['hl']
                        check((h.rd(loc) != 0x7a) == (janine and erika and sabrina),
                              f'shoreline block {x},{y}: Janine={janine}, Erika={erika}, Sabrina={sabrina}, old={old_rocks}')

            print('[Johto rematches: League starts Falkner, then each previous leader unlocks the next]', flush=True)
            rematches = (
                ('FALKNER', 'VIOLET_GYM', 'VioletGymFalknerScript', 'EVENT_GOT_TM31_MUD_SLAP'),
                ('BUGSY', 'AZALEA_GYM', 'AzaleaGymBugsyScript', 'EVENT_GOT_TM49_FURY_CUTTER'),
                ('WHITNEY', 'GOLDENROD_GYM', 'GoldenrodGymWhitneyScript', 'EVENT_GOT_TM45_ATTRACT'),
                ('MORTY', 'ECRUTEAK_GYM', 'EcruteakGymMortyScript', 'EVENT_GOT_TM30_SHADOW_BALL'),
                ('CHUCK', 'CIANWOOD_GYM', 'CianwoodGymChuckScript', 'EVENT_GOT_TM01_DRAIN_PUNCH'),
                ('JASMINE', 'OLIVINE_GYM', 'OlivineGymJasmineScript', 'EVENT_GOT_TM23_IRON_HEAD'),
                ('PRYCE', 'MAHOGANY_GYM', 'MahoganyGymPryceScript', 'EVENT_GOT_TM16_ICICLE_CRASH'),
                ('CLAIR', 'BLACKTHORN_GYM_1F', 'BlackthornGymClairScript', 'EVENT_GOT_TM24_DRAGON_CLAW'),
            )
            var = h.s('wScriptVar')
            battle_ui = {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9',
                         'Script_yesorno': bytes([0x3e, 1, 0xea, var & 255, var >> 8, 0xc9])}
            badges(16)
            event('EVENT_BEAT_RED', False)
            event('EVENT_GOT_METAL_COAT_FROM_JASMINE', True)
            with patches(h, battle_ui):
                for index, (leader, map_name, entry, tm) in enumerate(rematches):
                    event('EVENT_BEAT_' + leader, True)
                    event(tm, True)
                    prerequisite = 'EVENT_BEAT_ELITE_FOUR' if index == 0 else f'EVENT_BEAT_{rematches[index - 1][0]}_REMATCH'
                    for ready in (False, True):
                        event(prerequisite, ready)
                        event(f'EVENT_BEAT_{leader}_REMATCH', False)
                        event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE', True)
                        event('EVENT_OPENED_MT_SILVER', False)
                        write('wSpecialPhoneCallID', [0, 0])
                        load(map_name)
                        script(entry)
                        check(event(f'EVENT_BEAT_{leader}_REMATCH') == ready,
                              f'{leader} rematch: prerequisite={ready}, Red not beaten')
                        if leader == 'CLAIR':
                            check(read('wSpecialPhoneCallID') == (phone['SPECIALCALL_OAK_MT_SILVER'] if ready else 0),
                                  'Clair rematch did not queue Oak when Mt. Silver becomes available')

                print('[Route 26/27 phone rematches: Surge tier, then League tier, independent of power]', flush=True)
                for map_name, entry, first_ace in (
                        ('ROUTE_26', 'TrainerCooltrainermGaven3.Fight2', 48),
                        ('ROUTE_26', 'TrainerCooltrainerfBeth1.Fight2', 47),
                        ('ROUTE_27', 'TrainerBirdKeeperJose2.Fight2', 46),
                        ('ROUTE_27', 'TrainerCooltrainerfReena.Fight2', 48)):
                    for hall, owned, power in product((False, True), repeat=3):
                        load(map_name)
                        event('EVENT_BEAT_ELITE_FOUR', hall)
                        event('EVENT_RESTORED_POWER_TO_KANTO', power)
                        surge(owned)
                        script(entry)
                        h.call('ReadTrainerParty')
                        levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
                        expected = 74 if hall else 58 if owned else first_ace
                        check(max(levels) == expected,
                              f'{entry}: hall={hall}, Surge={owned}, power={power}, levels={levels}')

            print('[southern officer: eight badges; northern guards and League: sixteen]', flush=True)
            for count in range(17):
                badges(count)
                load('VICTORY_ROAD_GATE')
                write('wVictoryRoadGateSceneID', 0)
                _, texts, moves = script('VictoryRoadGateBadgeCheckScript')
                check(read('wVictoryRoadGateSceneID') == int(count >= 8), f'officer scene at {count}')
                check(bool(moves) == (count < 8), f'officer access at {count}')
                event('EVENT_VICTORY_ROAD_GATE_GUARDS_MOVED', False)
                end, _, _ = script('VictoryRoadGateGuardScript', ('VictoryRoadGateGuardScript.AllSixteenBadges',))
                check(bool(end) == (count == 16), f'northern guard access at {count}')
                load('INDIGO_PLATEAU_POKECENTER_1F')
                _, _, moves = script('IndigoPlateauBadgeCheck')
                check(bool(moves) == (count < 16), f'League entrance access at {count}')
                for scene in (0, 1):
                    write('wIndigoPlateauPokecenter1FSceneID', scene)
                    write('wPlayerStandingMapX', 14 + 4)
                    write('wPlayerStandingMapY', 4 + 4)
                    triggered = h.call('CheckCurrentMapCoordEvents')['c_flag']
                    check(triggered and h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym['IndigoPlateauBadgeCheck'][1],
                          f'League entrance trigger missing in scene {scene}, badges {count}')

            print('[Elm: ticket needs Surge, independent of total badges or Hall of Fame]', flush=True)
            load('ELMS_LAB')
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', True)
            for hall, count, owned in product((False, True), (0, 7, 8, 9, 15, 16), (False, True)):
                badges(count)
                surge(owned)
                event('EVENT_BEAT_ELITE_FOUR', hall)
                event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
                end, _, _ = script('ProfElmScript', ('ElmGiveTicketScript', 'ElmCheckMasterBall'))
                check(end == ('ElmGiveTicketScript' if owned else 'ElmCheckMasterBall'),
                      f'ticket eligibility at {count}, hall={hall}, surge={owned}')
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', False)
            for count, owned in product((0, 7, 8, 16), (False, True)):
                badges(count)
                surge(owned)
                end, _, _ = script('ElmCheckMasterBall', ('ElmGiveMasterBallScript', 'ElmCheckEverstone'))
                check(end == ('ElmGiveMasterBallScript' if owned else 'ElmCheckEverstone'),
                      f'Master Ball eligibility at {count}, surge={owned}')
            badges(8)
            surge(True)
            event('EVENT_BEAT_ELITE_FOUR', False)
            event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', False)
            write('wNumKeyItems', 25)
            full = [con.items['BICYCLE']] * 25 + [255]
            write('wKeyItems', full)
            script('ProfElmScript')
            check(not event('EVENT_GOT_SS_TICKET_FROM_ELM'), 'full pocket consumed ticket reward')
            check(h.rd(h.s('wKeyItems'), 26) == bytes(full), 'full pocket changed key items')
            write('wNumKeyItems', 0)
            write('wKeyItems', [255])
            write('wNumBalls', 0)
            write('wBalls', [255])
            script('ProfElmScript')
            check(event('EVENT_GOT_SS_TICKET_FROM_ELM') and read('wNumKeyItems') == 1
                  and read('wKeyItems') == con.items['S_S_TICKET'], 'ticket retry failed')
            check(event('EVENT_GOT_MASTER_BALL_FROM_ELM') and read('wNumBalls') == 1
                  and read('wBalls') == con.items['MASTER_BALL'], 'Master Ball not given with ticket')
            script('ProfElmScript')
            check(read('wNumKeyItems') == read('wNumBalls') == 1, 'Elm duplicated a gift')

            print('[Surge exit rings Elm immediately; the gift stays a surprise and the fare is granted once]', flush=True)
            badges(10)
            load('VERMILION_GYM')
            surge(False)
            event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
            event('EVENT_ELM_CALLED_AFTER_SURGE', False)
            event('EVENT_ELM_PAID_RETURN_FARE', False)
            write('wSpecialPhoneCallID', [0, 0])
            with patches(h, {'Script_startbattle': b'\xc9', 'Script_reloadmapafterbattle': b'\xc9'}):
                script('VermilionGymSurgeScript')
            check(read('wKantoBadges') & 4, 'Surge did not award Thunder Badge')
            check(read('wSpecialPhoneCallID') == phone['SPECIALCALL_SSTICKET'], 'Surge did not queue Elm call')
            load('VERMILION_CITY')
            for y in (19, 20):
                write('wPlayerStandingMapX', 14)
                write('wPlayerStandingMapY', y + 4)
                triggered = h.call('CheckCurrentMapCoordEvents')['c_flag']
                check(triggered and h.rd16(h.s('wCurCoordEventScriptAddr')) == h.sym['VermilionCityElmCallScript'][1],
                      f'Elm call missing on gym exit tile {y}')
                end, _, _ = script('VermilionCityElmCallScript', ('Script_SpecialElmCall',))
                check(end == 'Script_SpecialElmCall', f'exit tile {y} did not ring Elm immediately')
            end, _, _ = script('Script_SpecialElmCall', ('Script_ReceivePhoneCall',))
            check(end == 'Script_ReceivePhoneCall' and read('wCurCaller') == phone['PHONE_ELM'], 'forced call selected wrong caller')
            _, texts, _ = script('ElmPhoneCallerScript')
            check(texts == [h.sym['ElmPhoneSSTicketText']], 'Elm incoming ticket call has wrong text')
            check(read('wSpecialPhoneCallID') == 0, 'ticket phone call did not clear pending call')
            check(event('EVENT_ELM_CALLED_AFTER_SURGE') and event('EVENT_ELM_PAID_RETURN_FARE'), 'invitation did not grant prepaid fare')
            check(script('VermilionCityElmCallScript')[0] is None and read('wSpecialPhoneCallID') == 0,
                  'gym exit rang twice')
            _, texts, _ = script('ElmPhoneCalleeScript')
            check(texts == [h.sym['ElmPhoneReturnReminderText']], 'Elm callback did not remind player about gift')
            event('EVENT_ELM_PAID_RETURN_FARE', False)
            script('ElmPhoneCalleeScript')
            check(not event('EVENT_ELM_PAID_RETURN_FARE'), 'calling Elm back granted another free voyage')
            load('VERMILION_GYM')
            script('VermilionGymSurgeScript')
            check(read('wSpecialPhoneCallID') == 0, 'Surge queued duplicate ticket call')

            print('[prepaid passage: no ticket, any weekday, both boarding routes, decline and one use]', flush=True)
            # Cover later-voyage states too: the invitation must bypass the
            # timetable even when this is not the first-ever sailing.
            for entry, day, accept in product(('VermilionPortWalkUpToShipScript', 'VermilionPortSailorScript'),
                                              range(7), (False, True)):
                load('VERMILION_PORT')
                surge(True)
                event('EVENT_ELM_PAID_RETURN_FARE', True)
                event('EVENT_FAST_SHIP_FIRST_TIME', True)
                event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1', False)
                event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2', False)
                write('wCurDay', day)
                write('wNumKeyItems', 0)
                write('wKeyItems', [255])
                with patches(h, {'YesNoBox': b'\xaf\xc9' if accept else b'\x37\xc9'}):
                    _, texts, _ = script(entry)
                check(event('EVENT_ELM_PAID_RETURN_FARE') != accept, f'{entry}: fare consumption, day {day}, accept={accept}')
                check((h.sym['VermilionPortElmPaidFareText'] in texts) == accept,
                      f'{entry}: prepaid boarding, day {day}, accept={accept}')
                if accept:
                    check(event('EVENT_FAST_SHIP_DESTINATION_OLIVINE'), f'{entry}: prepaid voyage went wrong way')
                    check(not event('EVENT_GOT_SS_TICKET_FROM_ELM') and read('wNumKeyItems') == 0,
                          'prepaid boarding handed out permanent ticket')
                    script('VermilionPortCheckPassageScript')
                    check(read('wScriptVar') == 0, 'spent fare still allowed ticket-free boarding')
            for owned, fare, ticket in product((False, True), repeat=3):
                surge(owned)
                event('EVENT_ELM_PAID_RETURN_FARE', fare)
                write('wNumKeyItems', int(ticket))
                write('wKeyItems', [con.items['S_S_TICKET'], 255] if ticket else [255])
                script('VermilionPortCheckPassageScript')
                check(bool(read('wScriptVar')) == (owned and (fare or ticket)),
                      f'boarding eligibility: surge={owned}, fare={fare}, ticket={ticket}')

            load('ELMS_LAB')
            badges(8)
            surge(True)
            event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', False)
            event('EVENT_ELM_PAID_RETURN_FARE', True)
            write('wNumKeyItems', 0)
            write('wKeyItems', [255])
            write('wNumBalls', 0)
            write('wBalls', [255])
            script('ProfElmScript')
            check(event('EVENT_GOT_SS_TICKET_FROM_ELM') and event('EVENT_GOT_MASTER_BALL_FROM_ELM'),
                  'returning to lab did not grant both gifts')
            check(not event('EVENT_ELM_PAID_RETURN_FARE'), 'permanent ticket left unused prepaid fare active')

            print('[Master Ball retry after full Balls pocket, without repeating the ticket]', flush=True)
            event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
            event('EVENT_GOT_MASTER_BALL_FROM_ELM', False)
            write('wNumKeyItems', 0)
            write('wKeyItems', [255])
            write('wNumBalls', 12)
            full_balls = []
            for label in ('POKE_BALL', 'GREAT_BALL', 'ULTRA_BALL', 'SAFARI_BALL', 'HEAVY_BALL', 'LEVEL_BALL',
                          'LURE_BALL', 'FAST_BALL', 'LOVE_BALL', 'FRIEND_BALL', 'MOON_BALL', 'PARK_BALL'):
                full_balls += [con.items[label], 99]
            write('wBalls', full_balls + [255])
            script('ProfElmScript')
            check(event('EVENT_GOT_SS_TICKET_FROM_ELM') and not event('EVENT_GOT_MASTER_BALL_FROM_ELM'),
                  'full Balls pocket lost or falsely completed Master Ball gift')
            write('wNumBalls', 0)
            write('wBalls', [255])
            script('ProfElmScript')
            check(event('EVENT_GOT_MASTER_BALL_FROM_ELM') and read('wNumBalls') == 1
                  and read('wNumKeyItems') == 1, 'Master Ball retry failed or duplicated ticket')

            print('[port callback: sailing needs Surge and ticket, including stale saves]', flush=True)
            event('EVENT_ELM_CALLED_AFTER_SURGE', False)
            for owned, ticket, old_state in product((False, True), repeat=3):
                surge(owned)
                load('OLIVINE_PORT')
                event('EVENT_GOT_SS_TICKET_FROM_ELM', ticket)
                event('EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME', old_state)
                event('EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME', old_state)
                h.call('RunMapCallback', a=2)
                h.call('LoadObjectMasks')
                ready = owned and ticket
                check(event('EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME') == ready,
                      f'old port blocker: surge={owned}, ticket={ticket}, old={old_state}')
                check(event('EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME') != ready,
                      f'boarding sailor: surge={owned}, ticket={ticket}, old={old_state}')
                check(bool(h.rd(h.s('wObjectMasks') + 2)) == ready
                      and bool(h.rd(h.s('wObjectMasks') + 3)) != ready,
                      f'port sailor visibility: surge={owned}, ticket={ticket}')

            print('[first ship trip works from either port and retires the rescue quest]', flush=True)
            for port, entry in (('OLIVINE_PORT', 'OlivinePortSailorAtGangwayScript'),
                                ('VERMILION_PORT', 'VermilionPortSailorAtGangwayScript')):
                load(port)
                event('EVENT_FAST_SHIP_FIRST_TIME', False)
                event('EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1', False)
                event('EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP', False)
                event('EVENT_FAST_SHIP_PASSENGERS_EASTBOUND', True)
                event('EVENT_FAST_SHIP_PASSENGERS_WESTBOUND', True)
                script(entry)
                check(not event('EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP'), f'{port}: first passengers hidden')
                check(event('EVENT_FAST_SHIP_PASSENGERS_EASTBOUND') and event('EVENT_FAST_SHIP_PASSENGERS_WESTBOUND'),
                      f'{port}: later passengers overlap first trip')
                check(event('EVENT_FAST_SHIP_DESTINATION_OLIVINE') == (port == 'VERMILION_PORT'),
                      f'{port}: wrong first-trip destination')
                load('FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN')
                event('EVENT_FAST_SHIP_HAS_ARRIVED', False)
                event('EVENT_FAST_SHIP_FOUND_GIRL', False)
                event('EVENT_GOT_METAL_COAT_FROM_GRANDPA_ON_SS_AQUA', False)
                write('wNumItems', 0)
                write('wItems', [255])
                script('SSAquaMetalCoatAndDocking')
                check(event('EVENT_FAST_SHIP_HAS_ARRIVED') and event('EVENT_FAST_SHIP_FOUND_GIRL'),
                      f'{port}: rescue quest did not permit docking')
                destination = 'VERMILION_PORT' if port == 'OLIVINE_PORT' else 'OLIVINE_PORT'
                load(destination)
                if destination == 'OLIVINE_PORT':
                    event('EVENT_GOT_SS_TICKET_FROM_ELM', False)
                    write('wNumKeyItems', 0)
                    write('wKeyItems', [255])
                    event('EVENT_ELM_CALLED_AFTER_SURGE', True)
                    event('EVENT_ELM_PAID_RETURN_FARE', False)
                    h.call('RunMapCallback', a=2)
                script(('VermilionPort' if destination == 'VERMILION_PORT' else 'OlivinePort')
                       + '_MapScripts.LeaveFastShipScript')
                if destination == 'OLIVINE_PORT':
                    # Reloading the map or a save on the dock must preserve
                    # the exit while regular boarding still needs the ticket.
                    h.call('RunMapCallback', a=2)
                    h.call('LoadObjectMasks')
                    check(h.rd(h.s('wObjectMasks') + 2) != 0,
                          'ticket-free arrival left Olivine boarding guard blocking the exit')
                    with patches(h, {'YesNoBox': b'\xaf\xc9'}):
                        end, _, _ = script('OlivinePortSailorAfterHOFScript.FirstTime',
                                           ('OlivinePortSailorAfterHOFScript.NoTicket', 'OlivinePortSailorAtGangwayScript'))
                    check(end == 'OlivinePortSailorAfterHOFScript.NoTicket',
                          'prepaid return also allowed an unpaid eastbound trip')
                check(event('EVENT_FAST_SHIP_FIRST_TIME') and event('EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP'),
                      f'{destination}: first voyage did not complete')
                check(event('EVENT_FAST_SHIP_CABINS_SE_SSE_GENTLEMAN')
                      and event('EVENT_FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN_TWIN_1'),
                      f'{destination}: rescue family remains visible')

            print('[Oak: Kanto badges, League, Johto rematches, Crystal and Mt. Silver]', flush=True)
            for count, hall, cape, rematch in product((8, 9, 15, 16), (False, True), (False, True), (False, True)):
                badges(count)
                load('OAKS_LAB')
                event('EVENT_OPENED_MT_SILVER', False)
                event('EVENT_TALKED_TO_OAK_IN_KANTO', True)
                event('EVENT_BEAT_ELITE_FOUR', hall)
                event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE', cape)
                event('EVENT_BEAT_CLAIR_REMATCH', rematch)
                _, texts, _ = script('Oak')
                ready = count == 16 and hall and cape and rematch
                check(event('EVENT_OPENED_MT_SILVER') == ready, f'Mt. Silver: {count}, hall={hall}, cape={cape}')
                expected = ('OakNoKantoBadgesText' if count == 8 else
                            'OakYesKantoBadgesText' if count < 16 else
                            'OakLeagueNextText' if not hall else
                            'OakJohtoRematchesText' if not rematch else
                            'OakOpenMtSilverText' if cape else 'OakFindCrystalText')
                check(texts[0] == h.sym[expected], f'Oak advice: {count}, hall={hall}, cape={cape}')

            print('[Clair: Kanto before sixteen badges, League afterwards]', flush=True)
            load('BLACKTHORN_GYM_1F')
            event('EVENT_GOT_TM24_DRAGON_CLAW', True)
            event('EVENT_BEAT_CLAIR_REMATCH', False)
            event('EVENT_BEAT_PRYCE_REMATCH', False)
            for count in (8, 9, 15, 16):
                badges(count)
                _, texts, _ = script('BlackthornGymClairScript')
                expected = 'BlackthornGymClairText_League' if count == 16 else 'BlackthornGymClairText_Kanto'
                check(texts == [h.sym[expected]], f'Clair advice at {count} badges')

            print('[League rematch gate remains after the first championship]', flush=True)
            load('ROUTE_23')
            for hall, rematch in product((False, True), repeat=2):
                event('EVENT_BEAT_ELITE_FOUR', hall)
                event('EVENT_BEAT_CLAIR_REMATCH', rematch)
                for entry in ('Route23GrampsLeftDoorTrigger', 'Route23GrampsRightDoorTrigger', 'Route23GrampsSideTrigger'):
                    _, _, moves = script(entry)
                    check(bool(moves) == (hall and not rematch), f'{entry}: hall={hall}, rematch={rematch}')

            print('[Hall of Fame no longer unlocks the ship; Oak calls when Mt. Silver is ready]', flush=True)
            for cape, rematch in product((False, True), repeat=2):
                load('HALL_OF_FAME')
                badges(16)
                event('EVENT_OPENED_MT_SILVER', False)
                event('EVENT_BEAT_LANCE_REMATCH', False)
                event('EVENT_BEAT_CRYSTAL_CERULEAN_CAPE', cape)
                event('EVENT_BEAT_CLAIR_REMATCH', rematch)
                event('EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME', False)
                event('EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME', True)
                write('wSpecialPhoneCallID', [0, 0])
                script('HallOfFame_MapScripts.EnterHallOfFameScript')
                check(read('wSpecialPhoneCallID') == (phone['SPECIALCALL_OAK_MT_SILVER'] if cape and rematch else 0),
                      f'Hall of Fame queued wrong call, cape={cape}')
                check(not event('EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME')
                      and event('EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME'),
                      'Hall of Fame still overrides ticket-controlled port state')

        print('[Kanto map and Pokédex areas open with Johto badges before Hall of Fame]', flush=True)
        for johto, hall in product((0, 0x7f, 0xff), (False, True)):
            write('wJohtoBadges', johto)
            write('wStatusFlags', 0x80 if hall else 0)
            result = h.call('TownMap_GetKantoLandmarkLimits')
            expected = landmarks['PALLET_TOWN'] if johto == 0xff else landmarks['VICTORY_ROAD']
            check(result['e'] == expected, f'map range: johto={johto:#x}, hall={hall}')
            write('hWY', 0x90)
            with patches(h, {'ClearSprites': b'\xc9', 'Pokedex_GetArea.GetAndPlaceNest': b'\xc9'}):
                h.call('Pokedex_GetArea.right')
            check(read('hWY') == (0 if johto == 0xff else 0x90), f'Pokédex area: johto={johto:#x}')

        print('[Radio recognizes Kanto leaders before the League and keeps story/rematch classes hidden]', flush=True)
        for johto, hall in product((0x7f, 0xff), (False, True)):
            write('wJohtoBadges', johto)
            write('wStatusFlags', 0x40 if hall else 0)
            result = h.call('GetPnPHiddenPeople')
            hidden = []
            bank = h.sym['PnP_HiddenPeople'][0]
            ptr = result['hl']
            while h.mem[bank, ptr] != 255:
                hidden.append(h.mem[bank, ptr])
                ptr += 1
            check((con.trainer_classes['BROCK'] not in hidden) == (hall or johto == 0xff), 'radio hid Kanto leaders during Kanto')
            check((con.trainer_classes['WILL'] not in hidden) == hall, 'radio Elite Four recognition milestone')
            check(con.trainer_classes['CRYSTAL3'] in hidden and con.trainer_classes['FALKNER_REMATCH'] in hidden,
                  'radio exposed custom story/rematch classes')

        print('[Rooftop sale improves with complete Johto badges, not an old Hall of Fame flag]', flush=True)
        shop_ui = {name: b'\xc9' for name in ('ReadMart', 'LoadStandardMenuHeader', 'MartTextbox', 'BuyMenu')}
        with patches(h, shop_ui):
            for johto, hall in product((0x7f, 0xff), (False, True)):
                write('wJohtoBadges', johto)
                write('wStatusFlags', 0x40 if hall else 0)
                h.call('RooftopSale')
                expected = 'RooftopSaleMart2' if johto == 0xff else 'RooftopSaleMart1'
                check(h.rd16(h.s('wMartPointer')) == h.sym[expected][1], f'rooftop inventory: Johto={johto:#x}, hall={hall}')

        print('[compiled gym and first League levels follow the new route]', flush=True)
        write('wLinkMode', 0)
        write('wInBattleTowerBattle', 0)
        for trainer, ace in (('BROCK', 50), ('MISTY', 54), ('LT_SURGE', 58), ('ERIKA', 62),
                             ('SABRINA', 62), ('JANINE', 62), ('BLAINE', 66), ('BLUE', 69),
                             ('WILL', 70), ('KOGA', 71), ('BRUNO', 72), ('KAREN', 72), ('CHAMPION', 73)):
            write('wOtherTrainerClass', con.trainer_classes[trainer])
            write('wOtherTrainerID', 1)
            h.call('ReadTrainerParty')
            levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
            check(len(levels) == 6 and max(levels) == ace, f'{trainer}: compiled levels {levels}')

        print('[compiled rematch chain, optional League rematches and Mt. Silver bosses]', flush=True)
        for trainer, ident, ace in (
                ('FALKNER_REMATCH', 2, 77), ('BUGSY_REMATCH', 2, 78),
                ('WHITNEY_REMATCH', 2, 79), ('MORTY_REMATCH', 2, 80),
                ('CHUCK_REMATCH', 2, 81), ('JASMINE_REMATCH', 2, 82),
                ('PRYCE_REMATCH', 2, 83), ('CLAIR_REMATCH', 2, 84),
                ('WILL', 2, 85), ('KOGA', 2, 85), ('BRUNO', 2, 86),
                ('KAREN', 2, 86), ('CHAMPION', 2, 87),
                ('AGATHA', 1, 87), ('LORELEI', 1, 87), ('RED', 1, 90)):
            write('wOtherTrainerClass', con.trainer_classes[trainer])
            write('wOtherTrainerID', ident)
            h.call('ReadTrainerParty')
            levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
            check(len(levels) == 6 and max(levels) == ace, f'{trainer} {ident}: compiled levels {levels}')

        print('[compiled route trainers follow their gates: Route 25, Route 1 and Johto phone tiers]', flush=True)
        trainer_ids, trainer_class = {}, None
        for line in (root / 'constants/trainer_constants.asm').read_text().splitlines():
            match = re.match(r'\s*trainerclass (\w+)', line)
            if match:
                trainer_class, trainer_ids[trainer_class] = match[1], {}
                continue
            match = re.match(r'\s*const (\w+)', line)
            if match and trainer_class:
                trainer_ids[trainer_class][match[1]] = len(trainer_ids[trainer_class]) + 1
        route_aces = [('SCHOOLBOY', name, 52) for name in ('DUDLEY', 'JOE')]
        route_aces += [('LASS', 'ELLEN', 52), ('LASS', 'LAURA', 53), ('LASS', 'SHANNON', 53),
                       ('CAMPER', 'LLOYD', 53), ('COOLTRAINERM', 'KEVIN', 54),
                       ('SCHOOLBOY', 'DANNY', 63), ('COOLTRAINERF', 'QUINN', 64)]
        # Elite Four tier, then the final tier after Falkner's rematch.
        for tier, ace in ((0, 74), (1, 77)):
            for trainer, names in (
                    ('YOUNGSTER', ('JOEY5', None)), ('SCHOOLBOY', ('JACK4', 'JACK5')),
                    ('SCHOOLBOY', ('ALAN4', 'ALAN5')), ('SCHOOLBOY', ('CHAD4', 'CHAD5')),
                    ('LASS', ('DANA4', 'DANA5')), ('BUG_CATCHER', ('WADE5', None)),
                    ('BUG_CATCHER', ('ARNIE4', 'ARNIE5')), ('FISHER', ('RALPH4', 'RALPH5')),
                    ('PICNICKER', ('LIZ5', None)), ('HIKER', ('ANTHONY4', 'ANTHONY5')),
                    ('CAMPER', ('TODD4', 'TODD5')), ('PICNICKER', ('GINA4', 'GINA5')),
                    ('FISHER', ('TULLY3', 'TULLY4')), ('POKEMANIAC', ('BRENT3', 'BRENT4')),
                    ('PICNICKER', ('TIFFANY2', 'TIFFANY4')), ('BIRD_KEEPER', ('VANCE2', 'VANCE3')),
                    ('FISHER', ('WILTON2', 'WILTON3')), ('HIKER', ('PARRY1', 'PARRY2')),
                    ('PICNICKER', ('ERIN2', 'ERIN3')), ('SAILOR', ('HUEY3', 'HUEY4'))):
                if names[tier]:
                    route_aces.append((trainer, names[tier], ace))
        for trainer, name, ace in route_aces:
            write('wOtherTrainerClass', con.trainer_classes[trainer])
            write('wOtherTrainerID', trainer_ids[trainer][name])
            h.call('ReadTrainerParty')
            levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
            check(levels and max(levels) == ace, f'{trainer} {name}: compiled levels {levels}')

        print('[Trainer House CAL picks his team tier from the player\'s highest level]', flush=True)
        stride = h.s('wPartyMon2Level') - h.s('wPartyMon1Level')
        saved_count = read('wPartyCount')
        saved_levels = [h.rd(h.s('wPartyMon1Level') + i * stride) for i in range(6)]
        starters = ['MEGANIUM', 'FERALIGATR', 'TYPHLOSION', 'CHARIZARD', 'VENUSAUR', 'BLASTOISE']
        for party, level, size in (((5,), 50, 3), ((12, 48, 30), 50, 3), ((59, 59), 50, 3),
                                   ((60, 3), 60, 4), ((55, 69, 2), 60, 4), ((70,), 70, 5),
                                   ((73, 79, 2, 61, 1, 40), 70, 5), ((80,), 80, 6), ((100, 3), 80, 6)):
            write('wPartyCount', len(party))
            for i, mon_level in enumerate(party):
                h.wr(h.s('wPartyMon1Level') + i * stride, mon_level)
            write('wOtherTrainerClass', con.trainer_classes['CAL'])
            write('wOtherTrainerID', trainer_ids['CAL']['CAL3'])
            h.call('ReadTrainerParty')
            count = read('wOTPartyCount')
            levels = [read(f'wOTPartyMon{i}Level') for i in range(1, count + 1)]
            species = [h.species_index(h.rd(h.s('wOTPartySpecies') + i)) for i in range(count)]
            check(levels == [level] * size, f'CAL3 vs party {party}: levels {levels}')
            check(species == [con.species[name] for name in starters[:size]],
                  f'CAL3 vs party {party}: species {species}')
            check(read('wOtherTrainerID') == trainer_ids['CAL']['CAL3'],
                  f'CAL3 vs party {party}: trainer ID was rewritten')
            h.call('SetTrainerBattleLevel')
            check(read('wCurPartyLevel') == level, f'CAL3 transition level vs party {party}')
            write('wOtherTrainerClass', con.trainer_classes['BROCK'])
            write('wOtherTrainerID', 1)
            h.call('ReadTrainerParty')
            levels = [read(f'wOTPartyMon{i}Level') for i in range(1, read('wOTPartyCount') + 1)]
            check(max(levels) == 50, f'BROCK picked up CAL tiers vs party {party}: {levels}')
        write('wPartyCount', saved_count)
        for i, mon_level in enumerate(saved_levels):
            h.wr(h.s('wPartyMon1Level') + i * stride, mon_level)

        print('[Kanto fishing: actual rod routing follows badge tiers; Safari and Silver stay separate]', flush=True)
        with patches(h, {'Random': b'\xaf\xc9'}):
            offsets = [0, 4, 8, 12, 12, 12, 16, 19, 23]
            for count, offset in enumerate(offsets):
                write('wKantoBadges', (1 << count) - 1)
                for group in ('OCEAN_KANTO', 'LAKE_KANTO', 'POND_KANTO'):
                    for rod, base in enumerate((40, 44, 46)):
                        result = h.call('Fish', de=(map_data['FISHGROUP_' + group] << 8) | rod)
                        check(result['e'] == base + offset and result['d'] != 0,
                              f'{group}, rod={rod}, badges={count}: level={result["e"]}')
            for rod, level in enumerate((70, 76, 80)):
                result = h.call('Fish', de=(map_data['FISHGROUP_SILVER_CAVE'] << 8) | rod)
                check(result['e'] == level, f'Silver Cave rod {rod}: level={result["e"]}')
            for rod, level in enumerate((23, 24, 26)):
                result = h.call('Fish', de=(map_data['FISHGROUP_SAFARI'] << 8) | rod)
                check(result['e'] == level, f'Safari rod {rod} picked up Kanto scaling')
            write('wJohtoBadges', 255)
            for rod, level in enumerate((37, 42, 52)):
                result = h.call('Fish', de=(map_data['FISHGROUP_SHORE'] << 8) | rod)
                check(result['e'] == level, f'Johto rod {rod} changed with the Kanto curve')

        print('[compiled encounters: early Kanto and Victory Road]', flush=True)
        ranges = {'ROUTE_22': (43, 47), 'ROUTE_1': (60, 64), 'ROUTE_2': (43, 47),
                  'VIRIDIAN_FOREST': (43, 47), 'ROUTE_3': (47, 50), 'ROUTE_4': (48, 51),
                  'MOUNT_MOON': (47, 51), 'ROUTE_21': (60, 64), 'VICTORY_ROAD': (63, 69),
                  'ROUTE_26': (43, 47), 'ROUTE_27': (43, 47), 'TOHJO_FALLS': (43, 46),
                  'DIGLETTS_CAVE': (53, 57), 'ROUTE_28': (78, 82)}
        bank, pointer = h.sym['KantoGrassWildMons']
        while h.mem[bank, pointer] != 255:
            map_id = tuple(h.mem[bank, pointer:pointer + 2])
            for name, expected in list(ranges.items()):
                if map_id == maps[name]:
                    levels = [h.mem[bank, pointer + 5 + i * 3] for i in range(21)]
                    check((min(levels), max(levels)) == expected, f'{name}: wild levels {levels}')
                    del ranges[name]
            pointer += 68
        check(not ranges, f'missing Kanto encounter tables: {list(ranges)}')

        ranges = {'ROUTE_22': (43, 47), 'ROUTE_4': (47, 51), 'VIRIDIAN_CITY': (43, 47),
                  'PALLET_TOWN': (60, 64), 'ROUTE_21': (60, 64), 'ROUTE_19': (60, 64),
                  'ROUTE_20': (61, 65), 'CINNABAR_ISLAND': (61, 65), 'ROUTE_28': (78, 82)}
        bank, pointer = h.sym['KantoWaterWildMons']
        while h.mem[bank, pointer] != 255:
            map_id = tuple(h.mem[bank, pointer:pointer + 2])
            for name, expected in list(ranges.items()):
                if map_id == maps[name]:
                    levels = [h.mem[bank, pointer + 3 + i * 3] for i in range(3)]
                    check((min(levels), max(levels)) == expected, f'{name}: water levels {levels}')
                    del ranges[name]
            pointer += 12
        check(not ranges, f'missing Kanto water tables: {list(ranges)}')

        print(f'LEAGUE PROGRESSION: {checks} checks; {len(failures)} failures', flush=True)
        return bool(failures)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())
