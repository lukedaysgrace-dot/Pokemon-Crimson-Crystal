#!/usr/bin/env python3
"""Exercise the Friday contest in a built ROM without reading a player save.

Uses PyBoy and pc_harness. Presentation/input routines are stubbed only for
script-flow checks; encounters, battles' ball accounting, scoring, inventory,
party restoration, object masks and script commands run actual ROM code.
"""
from collections import Counter
from contextlib import contextmanager
from pathlib import Path

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT, dec, enc


ROOT = Path(ROOT)
FISHING = 1 << 5
TIMER = 1 << 2
FRIDAY = 5
COVE = 15
GATE = 16


@contextmanager
def patch(h, replacements):
    originals = []
    try:
        for name, code in replacements.items():
            bank, addr = h.sym[name]
            originals.append((bank, addr, bytes(h.mem[bank, addr:addr + len(code)])))
            h.mem[bank, addr:addr + len(code)] = code
        yield
    finally:
        for bank, addr, data in reversed(originals):
            h.mem[bank, addr:addr + len(data)] = data


def check_rom(h):
    checks = 0
    failures = []
    species = _parse_constants(ROOT / 'constants/pokemon_constants.asm')
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    battles = _parse_constants(ROOT / 'constants/battle_constants.asm')
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    # Fixed identities isolate the existing score/name regression fixtures.
    h.wr(h.s('wFishingContestRoster'), [0, 1, 2, 3, 4])

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)

    def write(name, value):
        h.wr(h.s(name), value)

    def read(name):
        return h.rd(h.s(name))

    def flags(value):
        write('wStatusFlags2', value)

    def load_map(number):
        write('wMapGroup', 1)
        write('wMapNumber', number)
        h.call('LoadMapAttributes')

    def event(name, value):
        index = events[name]
        addr = h.s('wEventFlags') + index // 8
        old = h.rd(addr)
        h.wr(addr, (old | (1 << (index % 8))) if value else (old & ~(1 << (index % 8))))

    def party(count=3, hp=50):
        write('wPartyCount', count)
        write('wPartySpecies', list(range(1, count + 1)) + [255])
        write('wPartyMon1Species', 1)
        write('wPartyMon1HP', [hp >> 8, hp & 255])
        write('wPartyMon1Level', 30)

    # Friday plus entry is required; other maps retain their normal fishing.
    load_map(COVE)
    for day in range(7):
        write('wCurDay', day)
        for status in (0, FISHING, TIMER, FISHING | TIMER):
            flags(status)
            write('wParkBallsRemaining', 20)
            expected = 0 if day != FRIDAY else (1 if status == FISHING | TIMER else 2)
            check(h.call('FishingContestAccess')['a'] == expected,
                  f'Fishing access wrong: day {day}, flags {status}')
    write('wCurDay', FRIDAY)
    flags(FISHING | TIMER)
    write('wParkBallsRemaining', 0)
    check(h.call('FishingContestAccess')['a'] == 2, 'Fishing allowed with no contest balls')
    load_map(14)
    write('wCurDay', 0)
    flags(0)
    check(h.call('FishingContestAccess')['a'] == 1, 'Fishing restriction leaked outside the cove')
    load_map(COVE)
    result = h.call('FishingContestCheckRod', de=0x1234)
    check(result['c_flag'] and result['de'] == 0x1234, 'Denied rod request lost rod registers')
    check(h.rd16(h.s('wQueuedScriptAddr')) == h.s('FishingContestFridayOnlyScript'),
          'Wrong weekday did not queue the fishing restriction message')

    # The cove never permits Surf, via either the party menu or water prompt.
    # Make every other requirement valid so rejection must come from the map.
    surf_requirements = {name: b'\xaf\xc9' for name in [
        'CheckBadge', 'CheckFieldHMAllowForMenu', 'CheckFieldHMAllow', 'CheckFacingObject']}
    surf_requirements.update({name: b'\xc9' for name in ['MenuTextboxBackup', 'GetPartyNick']})
    surf_requirements['GetSurfType'] = b'\x3e\x04\xc9'
    with patch(h, surf_requirements):
        write('wBikeFlags', 0)
        write('wTilePermissions', 0)
        write('wPlayerDirection', 0)
        write('wTileDown', 0x29)  # COLL_WATER
        write('wFacingTileID', 0x29)
        for day in range(7):
            write('wCurDay', day)
            for status in [0, TIMER, FISHING, FISHING | TIMER]:
                load_map(COVE)
                flags(status)
                write('wPlayerState', 0)
                h.wr16(h.s('wScriptPos'), 0)
                check(h.call('SurfFunction.TrySurf')['a'] == 2,
                      f'Party Surf allowed in the cove on day {day}, flags {status}')
                check(not h.call('TrySurfOW')['c_flag'] and h.rd16(h.s('wScriptPos')) == 0,
                      f'Cove offered a Surf prompt on day {day}, flags {status}')
        h.call('SurfFunction')
        check(read('wFieldMoveSucceeded') == 0 and read('wPlayerState') == 0,
              'Failed Surf menu request changed the player movement state')
        for group, number in [(1, 14), (2, COVE)]:
            write('wMapGroup', group)
            write('wMapNumber', number)
            check(h.call('SurfFunction.TrySurf')['a'] == 1,
                  f'Cove Surf restriction leaked onto map {group},{number}')
            check(h.call('TrySurfOW')['c_flag'] and h.rd16(h.s('wScriptPos')) == h.s('AskSurfScript'),
                  f'Normal Surf prompt was blocked on map {group},{number}')
    load_map(COVE)

    # Pressing A at the water uses the shared rod without owning/registering one.
    a_fishing = {name: b'\xaf\xc9' for name in ['CheckFacingObject', 'TryBGEvent']}
    a_fishing.update({name: b'\xc9' for name in ['PlayClickSFX']})
    with patch(h, a_fishing), patch(h, {'Random': b'\x3e\x00\xc9'}):
        write('wNumKeyItems', 0)
        write('wKeyItems', [255])
        write('wRegisteredItem', 0)
        write('wWhichRegisteredItem', 0)
        write('wPlayerState', 0)
        write('wPlayerDirection', 0)
        write('wTileDown', 0x29)
        write('hJoyPressed', 1)  # A_BUTTON
        write('wParkBallsRemaining', 20)
        for day in range(7):
            write('wCurDay', day)
            for status in [0, TIMER, FISHING, FISHING | TIMER]:
                flags(status)
                h.wr16(h.s('wScriptPos'), 0)
                result = h.call('CheckAPressOW')
                expected = ('FishingContestFridayOnlyScript' if day != FRIDAY else
                            'Script_GotABite' if status == FISHING | TIMER else
                            'FishingContestEnterFirstScript')
                check(result['c_flag'] and h.rd16(h.s('wScriptPos')) == h.s(expected)
                      and read('wScriptBank') == h.sym[expected][0],
                      f'A-button fishing selected wrong script on day {day}, flags {status}')
                check(read('wNumKeyItems') == 0 and read('wRegisteredItem') == 0
                      and read('wWhichRegisteredItem') == 0,
                      'Automatic fishing added or registered a rod')
                if expected == 'Script_GotABite':
                    check(read('wBuffer2') == 2 and read('wBattleType') == battles['BATTLETYPE_CONTEST']
                          and h.species_index(read('wTempWildMonSpecies')) == species['MAGIKARP'],
                          'A-button fishing bypassed the contest rod/encounter rules')
        flags(FISHING | TIMER)
        write('wCurDay', FRIDAY)
        # A cast with no bite must still run the ordinary casting animation.
        with patch(h, {'Random': b'\x3e\xff\xc9'}):
            h.call('CheckAPressOW')
        check(h.rd16(h.s('wScriptPos')) == h.s('Script_NotEvenANibble'),
              'A-button fishing skipped the no-bite casting script')
        write('wTileDown', 0)
        write('wFacingTileID', 0)
        h.wr16(h.s('wScriptPos'), 0)
        check(not h.call('TryFishingCoveOW')['c_flag'] and h.rd16(h.s('wScriptPos')) == 0,
              'Cove fished while facing dry land')
        write('wFacingTileID', 0x29)
        write('hJoyPressed', 0)
        check(not h.call('CheckAPressOW')['c_flag'], 'Cove fished without pressing A')
        for group, number in [(1, GATE), (1, 14), (2, COVE)]:
            write('wMapGroup', group)
            write('wMapNumber', number)
            check(not h.call('TryFishingCoveOW')['c_flag'], f'Automatic rod affected map {group},{number}')
    load_map(COVE)

    # Exhaust every equiprobable species roll, including high-index species.
    counts = Counter()
    for roll in range(200):
        with patch(h, {'Random': bytes([0x3e, roll, 0xc9])}):
            write('wContestBallsThisMon', 9)
            h.call('ChooseFishingContestEncounter')
        index = h.species_index(read('wTempWildMonSpecies'))
        counts[index] += 1
        check(10 <= read('wCurPartyLevel') <= 30, f'Invalid fish level for roll {roll}')
        check(read('wContestBallsThisMon') == 0, 'New fish retained the previous ball count')
    weights = {'MAGIKARP': 30, 'KRABBY': 14, 'QWILFISH': 12, 'HORSEA': 12,
               'CHINCHOU': 10, 'SHELLDER': 10, 'REMORAID': 4, 'CORSOLA': 3,
               'MAREANIE': 4, 'FEEBAS': 1}
    check(counts == Counter({species[name]: weight * 2 for name, weight in weights.items()}),
          f'Contest encounter distribution differs: {counts}')
    for roll, bite in [(0, True), (190, True), (191, False), (255, False)]:
        with patch(h, {'Random': bytes([0x3e, roll, 0xc9])}):
            result = h.call('FishingContestFish')
        check(bool(result['d']) == bite, f'Incorrect bite chance for roll {roll}')
        if bite:
            check(10 <= result['e'] <= 30, 'Fish returned level/species in wrong registers')

    # Shared scoring rewards rarity, relative size and fewer balls, with the
    # original Bug-Catching Contest still selecting its original score table.
    flags(FISHING | TIMER)
    rarity = {'MAGIKARP': 0, 'KRABBY': 25, 'QWILFISH': 25, 'HORSEA': 25,
              'CHINCHOU': 25, 'SHELLDER': 25, 'REMORAID': 55, 'CORSOLA': 60,
              'MAREANIE': 55, 'FEEBAS': 70}
    for name, points in rarity.items():
        sid = h.species_id(species[name])
        write('wContestMonSpecies', sid)
        for level, level_points in [(10, 0), (20, 75), (30, 150)]:
            write('wContestMonLevel', level)
            for balls, bonus in [(1, 30), (3, 20), (6, 10), (10, 0)]:
                write('wContestMonBallsUsed', balls)
                h.call('ContestScore')
                score = int.from_bytes(h.rd(h.s('hProduct'), 2), 'big')
                check(score == points + level_points + bonus,
                      f'{name} level {level}, {balls} balls scored {score}')
            result = h.call('GetContestMonLevelPercent', bc=(sid << 8) | level)
            check(result['a'] == level_points, f'{name} caught-mon comparison uses wrong range')
    flags(TIMER)
    write('wContestMonSpecies', h.species_id(species['CATERPIE']))
    write('wContestMonLevel', 18)
    write('wContestMonBallsUsed', 1)
    h.call('ContestScore')
    check(int.from_bytes(h.rd(h.s('hProduct'), 2), 'big') == 180, 'Bug contest scoring changed')

    flags(FISHING | TIMER)
    write('wCurDay', FRIDAY)
    for rod in range(3):
        write('wBuffer2', rod)
        with patch(h, {'Random': bytes([0x3e, 0, 0xc9])}):
            result = h.call('FishFunction.goodtofish', a=1)
        check(result['a'] == 2 and read('wBattleType') == battles['BATTLETYPE_CONTEST'],
              f'Rod {rod} did not start a catchable contest battle')
        check(h.species_index(read('wTempWildMonSpecies')) == species['MAGIKARP'],
              f'Rod {rod} bypassed the contest encounter pool')
    for variant in range(3):
        with patch(h, {'Random': bytes([0x3e, variant, 0xc9])}):
            h.call('ClearContestResults')
            h.call('ComputeAIContestantScores')
        for place in ['First', 'Second', 'Third']:
            winner = read(f'wBugContest{place}PlaceWinnerID')
            mon = h.species_index(read(f'wBugContest{place}PlaceMon'))
            check(2 <= winner <= 6 and mon in counts, 'Judging included a non-fishing contestant')
    for winner, name in enumerate(['JUSTIN', 'RALPH', 'ARNOLD', 'KYLE', 'WILTON'], 2):
        h.call('LoadContestantName', a=winner)
        text = dec(h.rd(h.s('wBugContestWinnerName'), 22)).split('@')[0]
        check(text == 'FISHER ' + name, f'Contestant {winner} has wrong name: {text!r}')
    for score, rank in [(250, 1), (179, 2), (177, 3), (0, 0)]:
        write('wBugContestPlayerScore', score.to_bytes(2, 'big'))
        with patch(h, {'Random': bytes([0x3e, 0, 0xc9])}):
            h.call('BugContest_JudgeContestants')
        check(h.call('BugContest_GetPlayersResult')['b'] == rank, f'{score} points got wrong placement')

    for mode, battle, rate in [(FISHING, 'BATTLETYPE_CONTEST', 135),
                               (0, 'BATTLETYPE_CONTEST', 45),
                               (0, 'BATTLETYPE_FISH', 135),
                               (0, 'BATTLETYPE_NORMAL', 45)]:
        flags(mode)
        write('wBattleType', battles[battle])
        check(h.call('LureBallMultiplier', bc=45 << 8)['b'] == rate,
              f'Lure Ball multiplier changed incorrectly in {battle}, flags {mode}')
    flags(FISHING | TIMER)
    write('wBattleType', battles['BATTLETYPE_CONTEST'])
    write('wParkBallsRemaining', 20)
    write('wContestBallsThisMon', 0)
    write('wNumBalls', 1)
    write('wBalls', [items['LURE_BALL'], 7, 255])
    h.call('PokeBallEffect.return_from_capture')
    check(read('wParkBallsRemaining') == 19 and read('wContestBallsThisMon') == 1,
          'Contest ball use was not counted')
    check(h.rd(h.s('wBalls'), 3) == bytes([items['LURE_BALL'], 7, 255]),
          'Contest consumed the player\'s own Lure Balls')

    # Exercise the actual battle-menu item choice while omitting its graphics
    # and the separately tested capture effect.
    menu_stubs = {name: b'\xc9' for name in [
        'DoItemEffect', 'LoadStandardMenuHeader', 'ClearWindowData', 'SetPalettes']}
    for status, item in [(FISHING, 'LURE_BALL'), (0, 'PARK_BALL')]:
        flags(status)
        write('wWildMon', 1)
        write('wInBattleTowerBattle', 0)
        write('wLinkMode', 0)
        write('wItemEffectSucceeded', 1)
        with patch(h, menu_stubs):
            h.call('BattleMenu_Pack')
        check(read('wCurItem') == items[item], f'Battle menu selected the wrong ball with flags {status}')

    write('wBattleMode', 0)
    flags(FISHING | TIMER)
    for item in ['OLD_ROD', 'GOOD_ROD', 'SUPER_ROD', 'POTION', 'BICYCLE']:
        write('wCurItem', items[item])
        check(h.call('FishingContestCanUseItem')['c_flag'] == (item not in ['OLD_ROD', 'GOOD_ROD', 'SUPER_ROD']),
              f'Wrong field item permission for {item}')
    for status, has_pack, has_quit in [(0, True, False), (TIMER, False, True),
                                       (TIMER | FISHING, True, True)]:
        flags(status)
        write('wLinkMode', 0)
        party()
        h.call('StartMenu.SetUpMenuItems')
        menu = h.rd(h.s('wMenuItemsList') + 1, read('wMenuItemsList'))
        check((2 in menu) == has_pack and (8 in menu) == has_quit,
              f'Wrong Pack/QUIT visibility with flags {status}: {menu.hex()}')
    for day in range(7):
        write('wCurDay', day)
        flags(FISHING | TIMER)
        check(h.call('FishingContestCheckDay')['c_flag'] == (day != FRIDAY), 'Midnight contest expiry failed')
    flags(FISHING | TIMER)
    write('wLinkMode', 0)
    with patch(h, {'CheckBugContestTimer': b'\x37\xc9'}):
        result = h.call('CheckTimeEvents')
    check(result['c_flag'] and h.rd16(h.s('wScriptPos')) == h.s('BugCatchingContestOverScript'),
          'Timer expiry did not start the contest-ending announcement')
    write('wFishingContestDailyFlags', 1)
    with patch(h, {'CheckDayDependentEventHL': b'\x37\xc9'}):
        h.call('CheckDailyResetTimer')
    check(read('wFishingContestDailyFlags') == 0, 'Friday participation did not reset with daily events')

    # Both the Pack and registered-item use reach this item dispatcher.
    # A clock request must never queue the calendar-reset script in a contest.
    with patch(h, {name: b'\xc9' for name in ['PrintText', 'RefreshScreen', 'CloseText', 'MenuTextboxWaitButton']}):
        for status in [TIMER, FISHING | TIMER, FISHING, 0]:
            for using_select in [0, 1]:
                flags(status)
                write('wCurItem', items['RELIC_CLOCK'])
                write('wUsingItemWithSelect', using_select)
                write('wBattleMode', 0)
                write('wCurDay', FRIDAY)
                h.wr16(h.s('wQueuedScriptAddr'), 0)
                h.call('_DoItemEffect')
                if status:
                    check(read('wItemEffectSucceeded') == 0 and h.rd16(h.s('wQueuedScriptAddr')) == 0,
                          f'Relic Clock was usable during contest flags {status}, select {using_select}')
                    check(read('wCurDay') == FRIDAY, 'Blocked Relic Clock changed the weekday')
                else:
                    check(read('wItemEffectSucceeded') == 1
                          and h.rd16(h.s('wQueuedScriptAddr')) == h.s('RelicClockScript'),
                          'Relic Clock was incorrectly blocked outside a contest')
        for status in [TIMER, FISHING | TIMER]:
            flags(status)
            write('wCurItem', items['RELIC_CLOCK'])
            write('wRegisteredItem', items['RELIC_CLOCK'])
            write('wWhichRegisteredItem', 0x81)  # KEY_ITEM pocket, first entry
            write('wNumKeyItems', 1)
            write('wKeyItems', [items['RELIC_CLOCK'], 255])
            h.wr16(h.s('wQueuedScriptAddr'), 0)
            h.call('SelectMenu')
            check(read('wItemEffectSucceeded') == 0 and h.rd16(h.s('wQueuedScriptAddr')) == 0,
                  f'Registered Relic Clock bypassed contest flags {status}')
            check(read('wUsingItemWithSelect') == 0 and read('wRegisteredItem') == items['RELIC_CLOCK'],
                  'Blocking the registered clock removed its registration or left use active')

    # Drive the game's compiled scripts one command at a time, removing only
    # text, sound and interactive presentation. Inventory/flags/specials stay real.
    presentation = {name: b'\xc9' for name in [
        'Script_opentext', 'Script_closetext', 'Script_waitbutton', 'Script_buttonsound',
        'Script_itemnotify', 'Script_pocketisfull', 'MapTextbox', 'PrintText',
        'PlaySFX', 'WaitSFX', 'ClearBGPalettes', 'PlayMapMusic', '_UpdateSprites']}
    presentation['YesNoBox'] = b'\xaf\xc9'  # accept contest entry
    presentation['GiveANickname_YesNo'] = b'\x37\xc9'  # retain default name

    def script(name, stop_at=None):
        bank, addr = h.sym[name]
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        visited = set()
        for _ in range(350):
            pos = h.rd16(h.s('wScriptPos'))
            bank = read('wScriptBank')
            visited.add((bank, pos))
            if stop_at and (bank, pos) == h.sym[stop_at]:
                return visited
            opcode = h.mem[bank, pos]
            try:
                h.call('RunScriptCommand')
            except RuntimeError as error:
                raise RuntimeError(f'{name}: command {opcode:02x} at {bank:02x}:{pos:04x}') from error
            if opcode in (0x90, 0x91) and read('wScriptStackSize') == 0 and read('wScriptMode') == 0:
                return visited
            if opcode == 0x90:  # callbacks' return command
                return visited
        raise AssertionError(f'{name} did not finish at {bank:02x}:{pos:04x}')

    def fresh_gate(day=FRIDAY, rod='OLD_ROD', hp=50):
        flags(0)
        write('wFishingContestDailyFlags', 0)
        write('wFishingContestFlags', 0)
        write('wFishingContestPrize', 0)
        write('wCurDay', day)
        write('wNumKeyItems', 1 if rod else 0)
        write('wKeyItems', [items[rod], 255] if rod else [255])
        write('wPlayerName', enc('TEST@@@@@@@'))
        write('wYCoord', 4)
        write('hLastTalked', 0)
        write('wBattleMode', 0)
        write('wNumItems', 0)
        write('wItems', [255])
        write('wNumBalls', 0)
        write('wBalls', [255])
        event('EVENT_LEFT_MONS_WITH_CONTEST_OFFICER', False)
        party(hp=hp)
        load_map(GATE)

    with patch(h, presentation):
        fresh_gate()
        script('OlivineFishingCoveGateFridayDoor')
        check(read('wStatusFlags2') & FISHING and read('hLastTalked') == 1,
              'Friday doorway did not have the guard start entry')
        for day in range(7):
            fresh_gate(day=day)
            script('OlivineFishingCoveGateOfficerScript')
            check(bool(read('wStatusFlags2') & FISHING) == (day == FRIDAY), f'Guard admitted entry on day {day}')
        for rod, hp, allowed in [(None, 50, True), ('OLD_ROD', 0, False),
                                  ('GOOD_ROD', 50, True), ('SUPER_ROD', 50, True)]:
            fresh_gate(rod=rod, hp=hp)
            script('OlivineFishingCoveGateOfficerScript')
            check(bool(read('wStatusFlags2') & FISHING) == allowed, f'Entry requirement failed: {rod}, HP {hp}')
            check(read('wPartyCount') == (1 if allowed else 3), 'Rejected entry changed the party')
            check(read('wNumKeyItems') == (1 if rod else 0)
                  and (h.rd(h.s('wKeyItems'), 2) == bytes([items[rod], 255]) if rod
                       else read('wKeyItems') == 255),
                  f'Contest entry changed key items for {rod}: count {read("wNumKeyItems")}, '
                  f'data {h.rd(h.s("wKeyItems"), 4).hex()}')
        fresh_gate()
        write('wPartySpecies', 253)  # EGG EQU -3
        script('OlivineFishingCoveGateOfficerScript')
        check(not read('wStatusFlags2') & FISHING, 'Guard accepted an Egg as the first Pokemon')
        for rank, prize in [(1, 'WATER_STONE'), (2, 'MYSTIC_WATER'), (3, 'NUGGET'), (0, 'LURE_BALL')]:
            fresh_gate()
            script('OlivineFishingCoveGateOfficerScript')
            check(read('wParkBallsRemaining') == 20 and read('wBugContestMinsRemaining') == 20,
                  'Gate did not supply twenty balls and twenty minutes')
            check((read('wMapNumber'), read('wXCoord'), read('wYCoord')) == (COVE, 19, 32),
                  'Entry warp did not arrive inside the cove')
            # Keep judging real in the other tests; force placements here so
            # every compiled prize branch is covered deterministically.
            force_rank = bytes([0x3e, rank, 0xea, h.s('wScriptVar') & 255, h.s('wScriptVar') >> 8, 0xc9])
            write('wContestMonSpecies', 0)
            with patch(h, {'BugContestJudging': force_rank}):
                script('FishingContestResultsWarpScript')
            check(read('wPartyCount') == 3 and h.rd(h.s('wPartySpecies'), 4) == bytes([1, 2, 3, 255]),
                  'Judging failed to restore the held party')
            check(read('wFishingContestDailyFlags') & 1 and not read('wStatusFlags2') & (FISHING | TIMER),
                  'Judging did not end the contest and mark Friday entry used')
            check(read('wFishingContestPrize') == 0, 'Delivered prize remained pending')
            pocket = 'wBalls' if rank == 0 else 'wItems'
            check(h.rd(h.s(pocket), 2) == bytes([items[prize], 1]), f'Wrong prize for placement {rank}')
            check(read('wMapNumber') == GATE, 'Results returned to the wrong gate')
            check((read('wXCoord'), read('wYCoord')) == (7, 5),
                  'Player did not stand at the right end of the judging lineup')
            script('OlivineFishingCoveGateOfficerScript')
            check(not read('wStatusFlags2') & FISHING, 'Allowed a second Friday entry')

        # Full inventory must retain the prize until the guard can deliver it.
        fresh_gate()
        script('OlivineFishingCoveGateOfficerScript')
        full = []
        for item in range(1, items['LURE_BALL']):
            write('wCurItem', item)
            h.call('CheckItemPocket')
            if read('wItemAttributeParamBuffer') == 1 and item != items['WATER_STONE']:
                full.extend([item, 99])
                if len(full) == 80:
                    break
        write('wNumItems', 40)
        write('wItems', full + [255])
        force_first = bytes([0x3e, 1, 0xea, h.s('wScriptVar') & 255, h.s('wScriptVar') >> 8, 0xc9])
        with patch(h, {'BugContestJudging': force_first}):
            script('FishingContestResultsWarpScript')
        check(read('wFishingContestPrize') == items['WATER_STONE'], 'Full Bag discarded the prize')
        script('OlivineFishingCoveGateOfficerScript')
        check(read('wFishingContestPrize') == items['WATER_STONE'], 'Failed prize claim discarded the prize')
        write('wNumItems', 0)
        write('wItems', [255])
        script('OlivineFishingCoveGateOfficerScript')
        check(read('wFishingContestPrize') == 0 and h.rd(h.s('wItems'), 2) == bytes([items['WATER_STONE'], 1]),
              'Guard did not deliver the held prize after making Bag space')

        for exit_script in ['BugCatchingContestReturnToGateScript', 'BugCatchingContestOverScript',
                            'FishingContestOutOfBallsScript', 'OlivineFishingCoveGateLeaveEarly']:
            fresh_gate()
            script('OlivineFishingCoveGateOfficerScript')
            with patch(h, {'Random': bytes([0x3e, 0, 0xc9])}):
                script(exit_script)
            check(read('wMapNumber') == GATE and read('wPartyCount') == 3,
                  f'{exit_script} did not judge at the cove gate and return the party')
            check(not read('wStatusFlags2') & (FISHING | TIMER) and read('wFishingContestDailyFlags') & 1,
                  f'{exit_script} did not finish Friday participation')
        fresh_gate()
        script('OlivineFishingCoveGateOfficerScript')
        with patch(h, {'YesNoBox': b'\x37\xc9'}):
            script('OlivineFishingCoveGateLeaveEarly')
        check(read('wMapNumber') == COVE and read('wPartyCount') == 1 and read('wStatusFlags2') & TIMER,
              'Declining early finish did not resume the same contest')

        # Actual capture generation, replacement choice, Lure Ball metadata,
        # final party insertion and the scored count of throws.
        fresh_gate()
        script('OlivineFishingCoveGateOfficerScript')
        write('wBattleMode', 1)
        write('wCurItem', items['LURE_BALL'])
        write('wEnemyMonMoves', [1, 0, 0, 0])
        write('wEnemyMonPP', [35, 0, 0, 0])
        write('wEnemyMonDVs', [0xff, 0xff])
        write('wCurPartyLevel', 30)
        write('wContestBallsThisMon', 2)
        sid = h.species_id(species['FEEBAS'])
        write('wTempEnemyMonSpecies', sid)
        h.call('BugContest_SetCaughtContestMon')
        check(read('wContestMonSpecies') == sid and read('wContestMonBallsUsed') == 3,
              'Captured fish or final throw was not recorded correctly')
        check(read('wContestMonPersonality') & 31 == 6, 'Contest fish did not record a Lure Ball capture')
        replacement = h.species_id(species['MAREANIE'])
        write('wTempEnemyMonSpecies', replacement)
        replacements = {'DisplayAlreadyCaughtText': b'\xc9', 'DisplayCaughtContestMonStats': b'\xc9'}
        with patch(h, {**replacements, 'PlaceYesNoBox': b'\x37\xc9'}):
            h.call('BugContest_SetCaughtContestMon')
        check(read('wContestMonSpecies') == sid, 'Declining fish replacement lost the stored catch')
        write('wContestBallsThisMon', 0)
        with patch(h, {**replacements, 'PlaceYesNoBox': b'\xaf\xc9'}):
            h.call('BugContest_SetCaughtContestMon')
        check(read('wContestMonSpecies') == replacement and read('wContestMonBallsUsed') == 1,
              'Accepting fish replacement did not store the new catch and its ball count')
        write('wBattleMode', 0)
        with patch(h, {'Random': bytes([0x3e, 0, 0xc9])}):
            script('FishingContestResultsWarpScript')
        check(read('wPartyCount') == 4 and h.rd(h.s('wPartySpecies'), 5) == bytes([1, 2, 3, replacement, 255]),
              'Player did not keep the chosen fish after their held party returned')
        check(h.rd(h.s('wPartyMon1CaughtLocation') + 3 * 50) & 127 == 28,
              'Fishing catch was incorrectly marked as caught at National Park')
        check(h.rd(h.s('wPartyMon1Personality') + 3 * 50) & 31 == 6,
              'Kept fish lost its Lure Ball metadata')

        # With six held party members, keep the fish in storage instead.
        h.call('InitializeBoxes')
        write('wCurBox', 0)
        flags(FISHING)
        party(count=6)
        h.build_temp_mon(species['FEEBAS'], [1, 0, 0, 0], level=30, personality=6)
        write('wContestMon', h.rd(h.s('wTempMon'), 50))
        write('wContestMonSpecies', h.species_id(species['FEEBAS']))
        h.call('CheckPartyFullAfterContest')
        check(read('wPartyCount') == 6 and read('wScriptVar') == 1,
              'Full party did not send the caught fish to a box')
        h.call('GetStorageBoxMon', bc=0x0101)
        check(h.rd16(h.s('wTempMonSpeciesIndex')) == species['FEEBAS'], 'Boxed contest fish has wrong species')
        check(read('wTempMonCaughtLocation') & 127 == 28 and read('wTempMonPersonality') & 31 == 6,
              'Boxed fish lost the cove location or Lure Ball metadata')

        fresh_gate()
        script('OlivineFishingCoveGateOfficerScript')
        script('Script_AbortBugContest')
        check(read('wPartyCount') == 3 and not read('wStatusFlags2') & (FISHING | TIMER),
              'Leaving by a field move did not restore the held party')
        check(read('wFishingContestDailyFlags') & 1, 'Aborting allowed repeat Friday entry')

        # The contestants must survive the post-callback object mask loader.
        for results in [0, 1]:
            load_map(GATE)
            write('wFishingContestFlags', results)
            script('OlivineFishingCoveGate_MapScripts.SetUpRoom')
            h.call('LoadObjectMasks')
            masks = h.rd(h.s('wObjectMasks') + 2, 5)
            check(all(mask == (0 if results else 255) for mask in masks),
                  f'Results contestant visibility wrong: {results}, {masks.hex()}')
            check((read('wMap1ObjectXCoord'), read('wMap1ObjectYCoord')) == ((7, 6) if results else (6, 5)),
                  'Judge did not move beside the results lineup')
            check(read('wMap1ObjectColor') >> 4 == 12, 'Fishing guard did not use the purple palette')
        for bank in [0x10, 0x74, 0x90, 0xfe]:
            write('wScriptBank', bank)
            h.wr16(h.s('wScriptPos'), 0x4567)
            write('wScriptStackSize', 0)
            h.call('RunMapCallback', a=2)
            check(read('wScriptBank') == bank and h.rd16(h.s('wScriptPos')) == 0x4567,
                  f'Map callback corrupted return bank {bank:02x}')
            check(read('wScriptStackSize') == 0, 'Map callback leaked a script stack entry')

    # New saved fields occupy reserved bytes; test their save/load round trip.
    write('wSavedAtLeastOnce', 1)
    write('wFishingContestPrize', items['NUGGET'])
    write('wFishingContestDailyFlags', 1)
    write('wFishingContestFlags', 1)
    write('wFishingContestRoster', [3, 1, 6, 8, 10])
    flags(FISHING)
    h.call('SaveGameData', max_frames=600)
    for name in ['wFishingContestPrize', 'wFishingContestDailyFlags', 'wFishingContestFlags', 'wStatusFlags2']:
        write(name, 0)
    write('wFishingContestRoster', bytes(5))
    h.call('TryLoadSaveFile', max_frames=600)
    check(read('wFishingContestPrize') == items['NUGGET'], 'Held prize was lost after saving and loading')
    check(h.rd(h.s('wFishingContestRoster'), 5) == bytes([3, 1, 6, 8, 10]),
          'Saved contestant identities were not restored')
    check(read('wFishingContestDailyFlags') == 1 and read('wFishingContestFlags') == 1 and read('wStatusFlags2') & FISHING,
          'Saved fishing contest flags were not restored')

    return checks, failures


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        checks, failures = check_rom(h)
        for message in failures:
            print(message)
        print(f'FISHING CONTEST: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        h.pyboy.stop(save=False)
