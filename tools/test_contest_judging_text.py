#!/usr/bin/env python3
"""Run real contest judging text, with only UI waits and sound skipped.

Unlike the contest script-flow checks, this executes PrintText, text_far,
text_ram and text_decimal. It never reads or writes a player's save.
"""
from pathlib import Path

from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT, dec, enc
from test_fishing_contest import patch


def check_rom(h):
    species = _parse_constants(Path(ROOT) / 'constants/pokemon_constants.asm')
    checks = 0
    failures = []
    h.wr(h.s('wFishingContestRoster'), [0, 1, 2, 3, 4])

    def check(condition, message):
        nonlocal checks
        checks += 1
        if not condition:
            failures.append(message)

    # Keep the text interpreter, string substitution, numeric rendering,
    # winner announcements, and ranking routines intact.
    ui = {name: b'\xc9' for name in [
        'SetUpTextbox', 'ButtonSound', 'WaitBGMap', 'DelayFrame',
        'UpdateWeatherSprites', 'PrintLetterDelay', 'PlaySFX', 'WaitSFX']}
    h.wr(h.s('wLinkMode'), 0)
    h.wr(h.s('wPlayerName'), enc('TEST@@@@@@@'))
    h.wr(h.s('wTextboxFlags'), 0)
    with patch(h, ui):
        for mode, name in [(32, 'KRABBY'), (32, 'FEEBAS'), (0, 'CATERPIE')]:
            h.wr(h.s('wStatusFlags2'), mode)
            sid = h.species_id(species[name])
            h.wr(h.s('wContestMonSpecies'), sid)
            h.wr(h.s('wBugContestPlayerScore'), [0, 175])
            h.wr(h.s('wTileMap'), bytes([0x7f]) * 360)
            h.call('BugContest_PrintPlayerScore', max_frames=30)
            top = h.rd(h.s('wTileMap') + 14 * 20 + 1, 18)
            bottom = h.rd(h.s('wTileMap') + 16 * 20 + 1, 18)
            check(top.startswith(enc('Your ' + name)), f'{name}: player catch name was not printed: {dec(top)}')
            check(bottom.startswith(enc('scored 175 points')), f'{name}: player points were not printed: {dec(bottom)}')

        # A losing Krabby must finish all NPC announcements, print its points,
        # return the player's placement, and allow the prize script to resume.
        h.wr(h.s('wStatusFlags2'), 32)
        h.wr(h.s('wContestMonSpecies'), h.species_id(species['KRABBY']))
        h.wr(h.s('wContestMonLevel'), 20)
        h.wr(h.s('wContestMonBallsUsed'), 1)
        printed = []
        print_bank, print_addr = h.sym['PrintText']
        h.pyboy.hook_register(print_bank, print_addr, lambda log: log.append(h.reg.HL), printed)
        try:
            with patch(h, {'Random': b'\x3e\x00\xc9'}):
                result = h.call('BugContestJudging', max_frames=60)
            check(h.s('FishingContest_FirstPlaceText') in printed
                  and h.s('BugContest_FirstPlaceText') not in printed,
                  'Fishing judging used the Bug-Catching Contest winner announcement')
            printed.clear()
            h.wr(h.s('wStatusFlags2'), 0)
            with patch(h, {'Random': b'\x3e\x00\xc9'}):
                h.call('BugContestJudging', max_frames=60)
            check(h.s('BugContest_FirstPlaceText') in printed
                  and h.s('FishingContest_FirstPlaceText') not in printed,
                  'Bug contest lost its own winner announcement')
        finally:
            h.pyboy.hook_deregister(print_bank, print_addr)
        # Restore the fishing results being checked below after the bug-mode run.
        h.wr(h.s('wStatusFlags2'), 32)
        with patch(h, {'Random': b'\x3e\x00\xc9'}):
            result = h.call('BugContestJudging', max_frames=60)
        check(h.rd(h.s('wScriptVar')) == 0, 'Losing Krabby did not return a consolation placement')
        check(h.rd(h.s('wBugContestPlayerScore'), 2) == bytes([0, 130]), 'Krabby points changed during announcements')
        check(h.rd(h.s('wTileMap') + 16 * 20 + 1, 18).startswith(enc('scored 130 points')),
              'Judging did not finish on the Krabby points message')
        check(result['b'] == 0, 'Judging did not return after printing the player score')

        # Run the entire fishing results script with MapTextbox and PrintText
        # intact: all NPC results, the player's score, prize, kept catch, and
        # final goodbye must execute, rather than just the ranking routine.
        script_ui = {name: b'\xc9' for name in [
            'Script_opentext', 'Script_closetext', 'Script_waitbutton',
            'Script_buttonsound', 'Script_itemnotify', 'Script_pocketisfull',
            'SpeechTextbox', 'TrainerPortrait_Draw', 'SafeUpdateSprites',
            'ApplyTilemap', 'ClearBGPalettes', 'PlayMapMusic']}
        script_ui['GiveANickname_YesNo'] = b'\x37\xc9'
        items = _parse_constants(Path(ROOT) / 'constants/item_constants.asm')
        events = _parse_constants(Path(ROOT) / 'constants/event_flags.asm')
        held = events['EVENT_LEFT_MONS_WITH_CONTEST_OFFICER']
        flag_addr = h.s('wEventFlags') + held // 8
        h.wr(flag_addr, h.rd(flag_addr) & ~(1 << (held % 8)))
        with patch(h, script_ui), patch(h, {'Random': b'\x3e\x00\xc9'}):
            for level, expected_prize in [(20, 'LURE_BALL'), (30, 'WATER_STONE')]:
                h.wr(h.s('wStatusFlags2'), 32 | 4)
                h.wr(h.s('wFishingContestPrize'), 0)
                h.wr(h.s('wFishingContestDailyFlags'), 0)
                h.wr(h.s('wMapGroup'), 1)
                h.wr(h.s('wMapNumber'), 15)
                h.wr(h.s('wPartyCount'), 1)
                h.wr(h.s('wPartySpecies'), [1, 255])
                h.build_temp_mon(species['KRABBY'], [1, 0, 0, 0], level=level, personality=6)
                krabby = h.rd(h.s('wTempMonSpecies'))
                h.wr(h.s('wContestMon'), h.rd(h.s('wTempMon'), 50))
                h.wr(h.s('wContestMonBallsUsed'), 1)
                h.wr(h.s('wNumItems'), 0)
                h.wr(h.s('wItems'), [255])
                h.wr(h.s('wNumBalls'), 0)
                h.wr(h.s('wBalls'), [255])
                bank, addr = h.sym['FishingContestResultsWarpScript']
                h.wr(h.s('wScriptBank'), bank)
                h.wr16(h.s('wScriptPos'), addr)
                h.wr(h.s('wScriptStackSize'), 0)
                h.wr(h.s('wScriptMode'), 1)
                visited = set()
                for _ in range(180):
                    visited.add((h.rd(h.s('wScriptBank')), h.rd16(h.s('wScriptPos'))))
                    h.call('RunScriptCommand', max_frames=60)
                    if h.rd(h.s('wScriptMode')) == 0:
                        break
                else:
                    raise AssertionError(f'Level {level} Krabby results did not finish')
                check(h.sym['FishingContestResultsWarpScript.received'] in visited,
                      f'Level {level} Krabby results did not reach prize delivery')
                pocket = 'wBalls' if expected_prize == 'LURE_BALL' else 'wItems'
                check(h.rd(h.s(pocket), 2) == bytes([items[expected_prize], 1]),
                      f'Level {level} Krabby did not receive {expected_prize}')
                check(h.rd(h.s('wPartyCount')) == 2 and h.rd(h.s('wPartySpecies') + 1) == krabby,
                      f'Level {level} Krabby was not kept after judging')
                check(h.rd(h.s('wStatusFlags2')) & (32 | 4) == 0,
                      f'Level {level} Krabby results left the contest running')
                check((h.rd(h.s('wXCoord')), h.rd(h.s('wYCoord'))) == (7, 5),
                      f'Level {level} Krabby judging did not place the player beside the trainers')
    return checks, failures


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        checks, failures = check_rom(h)
        for failure in failures:
            print(failure)
        print(f'CONTEST JUDGING TEXT: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        h.pyboy.stop(save=False)
