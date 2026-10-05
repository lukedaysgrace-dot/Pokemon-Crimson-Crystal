#!/usr/bin/env python3
"""Check every cove speaker's dialogue selection and actual text rendering.

Loads an in-memory cartridge, never the player's save. Only input, animation
waits, and presentation setup are skipped; the script and text interpreters run.
"""
from pc_harness import Harness
from test_fishing_contest import patch


def check_rom(h):
    checks, failures = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)

    visitors = ['Lass1', 'CooltrainerF1', 'Teacher1', 'CooltrainerM1',
                'Lass2', 'CooltrainerF2', 'Teacher2', 'CooltrainerM2']
    candidates = ['Justin', 'Ralph', 'Arnold', 'Kyle', 'Wilton', 'Samuel',
                  'Nick', 'Gwen', 'Barry', 'Cindy', 'William']
    ui = {name: b'\xc9' for name in [
        'Script_faceplayer', 'Script_opentext', 'Script_closetext', 'Script_waitbutton',
        'SpeechTextbox', 'TrainerPortrait_Draw', 'SetUpTextbox', 'ButtonSound',
        'WaitBGMap', 'DelayFrame', 'UpdateWeatherSprites', 'PrintLetterDelay',
        'PlaySFX', 'WaitSFX', 'SafeUpdateSprites', 'ApplyTilemap']}
    h.wr(h.s('wLinkMode'), 0)
    h.wr(h.s('wTextboxFlags'), 0)

    def speak(script, selector, label, object_id, status):
        h.wr(h.s('wStatusFlags2'), status)
        h.wr(h.s('hLastTalked'), object_id)
        h.call(selector)
        selected = (h.rd(h.s('wScriptTextBank')), h.rd16(h.s('wScriptTextAddr')))
        check(selected == h.sym[label], f'{label}: selected {selected}, expected {h.sym[label]}')
        bank, addr = h.sym[script]
        h.wr(h.s('wScriptBank'), bank)
        h.wr16(h.s('wScriptPos'), addr)
        h.wr(h.s('wScriptStackSize'), 0)
        h.wr(h.s('wScriptMode'), 1)
        h.wr(h.s('wTileMap'), bytes([0x7f]) * 360)
        for _ in range(12):
            h.call('RunScriptCommand', max_frames=60)
            if h.rd(h.s('wScriptMode')) == 0:
                break
        check(h.rd(h.s('wScriptMode')) == 0, f'{label}: conversation did not finish')
        check(any(t != 0x7f for t in h.rd(h.s('wTileMap') + 16 * 20 + 1, 18)),
              f'{label}: text was not rendered')

    with patch(h, ui):
        for i, name in enumerate(visitors):
            speak('OlivineFishingCoveVisitorScript', 'FishingCoveSelectDialogue',
                  'FishingCove' + name + 'Text', i + 4, 0)
        # Fishing mode alone (after finishing) and an unrelated bug contest
        # timer must still select normal visitor chatter.
        for status in [4, 32]:
            for i, name in enumerate(visitors):
                h.wr(h.s('wStatusFlags2'), status)
                h.wr(h.s('hLastTalked'), i + 4)
                h.call('FishingCoveSelectDialogue')
                check(h.rd16(h.s('wScriptTextAddr')) == h.s('FishingCove' + name + 'Text'),
                      f'Visitor {i} incorrectly used contest dialogue with flags {status}')
        for candidate, name in enumerate(candidates):
            # Every identity must work in every roster slot, at both maps.
            for slot in range(5):
                h.wr(h.s('wFishingContestRoster'), [0, 1, 5, 6, 10])
                h.wr(h.s('wFishingContestRoster') + slot, candidate)
                speak('OlivineFishingCoveContestantScript', 'FishingCoveSelectDialogue',
                      'FishingContest' + name + 'Text', slot + 4, 36)
                speak('OlivineFishingCoveGateFisherScript', 'FishingContestSelectResultDialogue',
                      'FishingContest' + name + 'ResultText', slot + 2, 0)
    return checks, failures


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        checks, failures = check_rom(h)
        for message in failures:
            print('FAIL:', message)
        print(f'FISHING COVE DIALOGUE: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        h.pyboy.stop(save=False)
