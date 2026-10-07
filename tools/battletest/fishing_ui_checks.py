#!/usr/bin/env python3
"""Native fishing-contest dialogue, warps, judging, restoration, and RTC.

Stages a private Friday save, party, and gate location. After setup each case
uses buttons, including real script/menu/text/sound code. Clock cases advance
the emulator's RTC epoch; they neither patch time routines nor set wCurDay.
Bag/egg/fainted/prize edge cases explicitly stage those fixture fields.
Run prepare_mbc30.py first. Screenshots and results are temporary artifacts.
"""

import io
import json
import re
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
ADAPTER = ROOT / '.tmpbuild/pyboy-mbc30'
if not (ADAPTER / 'pyboy').exists():
    raise SystemExit('Run tools/battletest/prepare_mbc30.py first')
sys.path.insert(0, str(ADAPTER))

from pyboy.core.cartridge.mbc3 import advance_clock

from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from gameplay_rules_checks import new_game, save_continue
from symbols import _parse_constants
from overworld_controls import Controls
from ui_checks import tile_text


OUTPUT = ROOT / '.tmpbuild/fishing-ui'
FISHING, TIMER = 32, 4


class ContestUI:
    def __init__(self):
        self.h = Harness(cartridge='mbc30')
        self.c = Controls(self.h)
        self.pending = False
        self.questions = 0
        self.snapshots = []
        self.prizes = []
        self.checks = 0
        self.failures = []
        self.label = 'setup'
        OUTPUT.mkdir(parents=True, exist_ok=True)

    @property
    def m(self):
        return self.h.battle.mem

    def check(self, ok, description):
        self.checks += 1
        if not ok:
            message = self.label + ': ' + description
            self.failures.append(message)
            print('FAIL ' + message, flush=True)

    def capture(self, label):
        m = self.m
        data = dict(label=label, map=self.c.map_id(), position=self.c.position(),
                    day=m.read('wCurDay'), hour=m.read('hHours'), minute=m.read('hMinutes'),
                    weekday=m.read('wCurDay') % 7,
                    flags=m.read('wStatusFlags2'), daily=m.read('wFishingContestDailyFlags'),
                    party=m.read('wPartyCount'), balls=m.read('wParkBallsRemaining'),
                    remaining=[m.read('wBugContestMinsRemaining'), m.read('wBugContestSecsRemaining')],
                    prize=m.read('wFishingContestPrize'), text=tile_text(self.h))
        self.snapshots.append(data)
        self.h.pb.screen.image.save(str(OUTPUT / (label + '.png')))
        print(json.dumps(data), flush=True)

    def prepare(self):
        h, m = self.h, self.m
        new_game(h, 0)
        request, address = Request(h.battle), h.sym.addr('wDebugPlayer1')
        m.write('wMonType', 0)
        for slot, species in enumerate(('MEW', 'PIDGEOT', 'LEDIAN')):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species=species, level=35,
                          moves=['TACKLE', 'SPLASH'], item='BERRY')))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        self.party = m.read_bytes('wPartyMons', 3 * (h.sym.addr('wPartyMon2') - h.sym.addr('wPartyMon1')))
        self.names = m.read_bytes('wPartyMonNicknames', 33)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write_bytes('wStringBuffer2', [5, 12, 0, 0])
        call(h, '_InitTime')
        call(h, 'UpdateTime')
        self.check(m.read('wCurDay') == 5, 'RTC-derived Friday fixture')
        m.write('wDefaultSpawnpoint', 255)
        m.write('wMapGroup', 1)
        m.write('wMapNumber', 16)
        m.write('wXCoord', 2)
        m.write('wYCoord', 2)
        m.write('hMapEntryMethod', 0xF1)
        begin_native_call(h, 'OverworldLoop')
        self.c.wait(400)
        self.check(self.c.map_id() == (1, 16), 'gate loaded')
        bank, address = h.sym['YesNoBox']
        h.pb.hook_register(bank, address, lambda _: setattr(self, 'pending', True), None)
        bank, address = h.sym['FishingContestPreparePrize']
        h.pb.hook_register(bank, address, lambda _: self.prizes.append(m.read('wScriptVar')), None)
        self.fixture = io.BytesIO()
        h.pb.save_state(self.fixture)
        self.capture('friday-gate')

    def load(self, label):
        self.label = label
        self.fixture.seek(0)
        self.h.pb.load_state(self.fixture)
        self.pending = False
        self.questions = 0
        self.prizes.clear()
        self.h.text_overflows.clear()

    def dialogue(self, answers=(), expected_map=None, limit=30000):
        answers = list(answers)
        start = self.c.frames
        while self.c.frames - start < limit:
            text = tile_text(self.h)
            if self.pending:
                if 'YES' in text and 'NO' in text:
                    self.c.wait(30)
                    answer = answers.pop(0) if answers else False
                    if self.m.read('wMenuCursorY') != (1 if answer else 2):
                        self.c.press('down', hold=4, wait=20)
                    self.pending = False
                    self.questions += 1
                    self.c.press('a', hold=4, wait=24)
                else:
                    self.c.wait(20)
            else:
                self.c.press('b', hold=4, wait=24)
            if (self.m.read('wScriptMode') == 0 and self.m.read('wMapStatus') == 2
                    and not self.m.read('wBattleMode')
                    and (expected_map is None or self.c.map_id() == expected_map)):
                self.c.wait(180)
                if self.m.read('wScriptMode') == 0 and not self.m.read('wBattleMode'):
                    self.check(not answers, 'all intended confirmation answers were consumed')
                    return
        raise RuntimeError('Dialogue timeout: ' + str(self.h.control_state()) + '; ' + tile_text(self.h))

    def officer(self, answers, expected_map=None):
        self.c.press('up', hold=4, wait=20)
        self.c.press('a', hold=4, wait=30)
        self.dialogue(answers, expected_map)

    def enter(self):
        self.officer([True, True], (1, 15))
        self.check(self.m.read('wPartyCount') == 1, 'entry temporarily keeps only the first Pokemon')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == FISHING | TIMER, 'entry starts both contest flags')
        self.check(self.m.read('wParkBallsRemaining') == 20, 'entry gives 20 balls')
        roster = list(self.m.read_bytes('wFishingContestRoster', 5))
        self.check(len(set(roster)) == 5, 'entry chooses five distinct contestants')
        self.capture(self.label + '-entered')

    def exit_cove(self, finish):
        self.c.go([19, 33])
        self.c.press('down', hold=12, wait=180)
        self.dialogue([finish], (1, 16) if finish else (1, 15))

    def restored(self):
        self.check(self.m.read('wPartyCount') == 3, 'all three original Pokemon returned')
        self.check(self.m.read_bytes('wPartyMons', len(self.party)) == self.party, 'exact original party data restored')
        self.check(self.m.read_bytes('wPartyMonNicknames', 33) == self.names, 'original nicknames restored')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'contest flags cleared')
        expected_daily = 1 if self.m.read('wCurDay') % 7 == 5 else 0
        self.check(self.m.read('wFishingContestDailyFlags') & 1 == expected_daily,
                   'daily participation flag agrees with the current calendar day')
        self.check(self.m.read('wParkBallsRemaining') == 0, 'contest balls cleared')
        self.check(self.m.read('wFishingContestPrize') == 0, 'prize delivered with available bag space')
        self.check(not self.h.text_overflows, 'native textbox glyphs stay inside the text area')
        self.capture(self.label + '-finished')

    def inventory(self, item):
        item_id = self.h.con.item_id(item)
        total = 0
        for count, entries in [('wNumItems', 'wItems'), ('wNumBalls', 'wBalls')]:
            for slot in range(self.m.read(count)):
                if self.m.read(entries, slot * 2) == item_id:
                    total += self.m.read(entries, slot * 2 + 1)
        return total

    def fish_and_catch(self):
        bank, table = self.h.sym['TileCollisionTable']
        candidates = []
        for y in range(self.m.read('wMapHeight') * 2):
            for x in range(self.m.read('wMapWidth') * 2):
                if not self.c.passable(self.c.collision(x, y)):
                    continue
                for dx, dy, direction in ((0, -1, 'up'), (1, 0, 'right'), (-1, 0, 'left'), (0, 1, 'down')):
                    if x + dx < 0 or y + dy < 0:
                        continue
                    collision = self.c.collision(x + dx, y + dy)
                    if self.h.pb.memory[bank, table + collision] & 15 == 1:
                        candidates.append((abs(x - 19) + abs(y - 32), (x, y), direction))
        for _, point, direction in sorted(candidates):
            try:
                self.c.path(point)
            except RuntimeError:
                continue
            self.c.go(point)
            self.c.press(direction, hold=4, wait=20)
            break
        else:
            raise RuntimeError('No reachable shore tile')
        self.capture(self.label + '-shore')
        for _ in range(600):
            self.c.press('a', hold=4, wait=20)
            if self.m.read('wBattleMode'):
                break
        else:
            raise RuntimeError('Button fishing did not produce a bite')
        contest_type = _parse_constants(ROOT / 'constants/battle_constants.asm')['BATTLETYPE_CONTEST']
        self.c.wait(120)
        self.check(self.m.read('wBattleType') == contest_type, 'rod-free cast starts a native contest encounter')
        before = self.m.read('wParkBallsRemaining')
        for _ in range(1200):
            text = tile_text(self.h)
            if 'LUREBALL' in text and 'RUN' in text:
                self.c.press('down', hold=4, wait=12)
                self.c.press('left', hold=4, wait=12)
                self.c.press('a', hold=4, wait=24)
            else:
                self.c.press('a', hold=4, wait=24)
            if not self.m.read('wBattleMode'):
                break
        else:
            raise RuntimeError('Native Lure Ball capture did not finish')
        self.dialogue([], (1, 15))
        self.check(self.m.read('wParkBallsRemaining') < before, 'native throwing consumes contest balls')
        self.check(self.m.read('wContestMonSpecies') != 0, 'native throwing caught a contest Pokemon')
        self.check(self.m.read('wContestMonBallsUsed') == before - self.m.read('wParkBallsRemaining'),
                   'caught-mon score remembers the real number of throws')
        self.capture(self.label + '-caught')

    def run(self):
        self.prepare()
        for label, answers in [('decline-entry', [False]), ('decline-first-mon', [True, False])]:
            self.load(label)
            self.officer(answers, (1, 16))
            self.check(self.m.read('wPartyCount') == 3, 'declining leaves the full party intact')
            self.check(self.m.read_bytes('wPartyMons', len(self.party)) == self.party, 'declining preserves exact party data')
            self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'declining starts no timer')
            self.capture(label)

        self.load('early-finish')
        self.enter()
        self.exit_cove(False)
        self.check(self.m.read('wPartyCount') == 1 and self.m.read('wParkBallsRemaining') == 20,
                   'declining early finish resumes the same contest')
        self.exit_cove(True)
        self.restored()
        self.check(self.prizes == [0], 'no catch awards consolation placement')
        self.c.go([3, 3])
        self.officer([], (1, 16))
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'same-day entry rejected after finishing')
        advance_clock(7 * 86400)
        self.c.wait(120)
        self.check(self.m.read('wCurDay') == 12 and self.m.read('wFishingContestDailyFlags') == 0,
                   'next Friday clears the previous daily participation through native RTC processing')
        self.enter()
        self.exit_cove(True)
        self.restored()

        self.load('one-mon-entry')
        self.m.write('wPartyCount', 1)
        self.m.write('wPartySpecies', 255, 1)
        self.officer([True], (1, 15))
        self.check(self.questions == 1 and self.m.read('wPartyCount') == 1,
                   'single-mon entry skips the drop-off confirmation')
        self.exit_cove(True)
        self.check(self.m.read('wPartyCount') == 1, 'single-mon finish does not unmask leftover party slots')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'single-mon finish clears contest state')

        self.load('rtc-timeout')
        self.enter()
        advance_clock(20 * 60 + 2)
        self.c.wait(120)
        self.dialogue([], (1, 16))
        self.restored()
        self.check(self.m.read('wBugContestMinsRemaining') == 0, 'actual RTC timer expired')

        self.load('midnight-rollover')
        advance_clock(11 * 3600 + 58 * 60)
        self.c.wait(120)
        self.check(self.m.read('wCurDay') == 5 and self.m.read('hHours') == 23, 'late-Friday clock observed by overworld')
        self.enter()
        advance_clock(2 * 60 + 2)
        self.c.wait(120)
        self.dialogue([], (1, 16))
        self.restored()
        self.check(self.m.read('wCurDay') == 6, 'RTC-derived Saturday ends the Friday contest')
        self.check(self.m.read('wBugContestMinsRemaining') > 0, 'midnight ended the contest before the 20-minute timeout')

        self.load('not-friday')
        advance_clock(86400)
        self.c.wait(120)
        self.officer([], (1, 16))
        self.check(self.questions == 0, 'Saturday offers no entry confirmation')
        self.check(self.m.read('wPartyCount') == 3, 'Saturday leaves party intact')
        self.capture('not-friday')

        self.load('egg-rejection')
        self.m.write('wPartySpecies', 253)
        self.officer([True], (1, 16))
        self.check(self.questions == 1 and self.m.read('wPartyCount') == 3, 'first-slot egg rejected before party drop-off')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'egg rejection starts no timer')

        self.load('fainted-rejection')
        self.m.write_bytes('wPartyMon1HP', [0, 0])
        self.officer([True, True], (1, 16))
        self.check(self.m.read('wPartyCount') == 3, 'fainted lead rejected without losing other Pokemon')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'fainted rejection starts no timer')

        self.load('native-catch')
        self.enter()
        self.fish_and_catch()
        caught = self.m.species_index_of(self.m.read('wContestMonSpecies'))
        rewards = ['LURE_BALL', 'WATER_STONE', 'MYSTIC_WATER', 'NUGGET']
        before_rewards = {name: self.inventory(name) for name in rewards}
        self.exit_cove(True)
        self.check(self.m.read('wPartyCount') == 4, 'judging returns the party and adds the caught Pokemon')
        self.check(self.m.species_index_of(self.m.read('wPartyMon4Species')) == caught, 'the actual caught species joins the party')
        mon_size = self.h.sym.addr('wPartyMon2') - self.h.sym.addr('wPartyMon1')
        self.check(self.m.read_bytes('wPartyMon2', 2 * mon_size) == self.party[mon_size:],
                   'fishing battle and judging preserve exact held-party data')
        self.check(self.m.read_bytes('wPartyMonNicknames', 33) == self.names, 'catching preserves existing nicknames')
        self.check(len(self.prizes) == 1, 'judging selected one placement')
        if self.prizes:
            reward = rewards[self.prizes[0]]
            self.check(self.inventory(reward) == before_rewards[reward] + 1, 'actual placement award appears in the correct pocket')
        self.check(self.m.read('wStatusFlags2') & (FISHING | TIMER) == 0, 'catching clears contest state after judging')
        self.check(not self.h.text_overflows, 'fishing/capture/judging text stays inside the textbox')
        self.capture('native-catch-finished')

        self.load('full-party-catch')
        species = list(self.m.read_bytes('wPartySpecies', 3))
        self.m.write('wPartyCount', 6)
        self.m.write_bytes('wPartySpecies', species * 2 + [255])
        self.m.write_bytes('wPartyMons', self.party * 2)
        self.m.write_bytes('wPartyMonNicknames', self.names * 2)
        original_ot = self.m.read_bytes('wPartyMonOT', 33)
        self.m.write_bytes('wPartyMonOT', original_ot * 2)
        self.enter()
        self.fish_and_catch()
        caught = self.m.species_index_of(self.m.read('wContestMonSpecies'))
        self.exit_cove(True)
        self.check(self.m.read('wPartyCount') == 6, 'full party returns all six Pokemon')
        self.check(self.m.read_bytes('wPartyMon2', 5 * mon_size) == (self.party * 2)[mon_size:],
                   'full-party catch preserves every held Pokemon')
        self.check(self.m.read_bytes('wPartyMonNicknames', 66) == self.names * 2,
                   'full-party finish preserves all original nicknames')
        self.check(not self.h.text_overflows, 'full-party/boxed-catch messages fit the native textbox')
        self.capture('full-party-catch-finished')
        call(self.h, 'GetStorageBoxMon', B=1, C=1)
        self.check(self.m.species_index_of(self.m.read('wTempMonSpecies')) == caught,
                   'native judging sends the actual caught Pokemon into PokeDB when the party is full')

        self.load('held-prize')
        capacity = int(re.search(r'MAX_ITEMS\s+EQU\s+(\d+)',
                       (ROOT / 'constants/item_data_constants.asm').read_text())[1])
        bank, table = self.h.sym['ItemAttributes']
        items = [name for item_id, name in sorted(self.h.con.items_by_id.items())
                 if 0 < item_id < 0xfd and name != 'WATER_STONE'
                 and self.h.pb.memory[bank, table + (item_id - 1) * 7 + 5] == 1][:capacity]
        self.check(len(items) == capacity, 'full-bag fixture uses the actual bag capacity and item pocket')
        self.m.write('wNumItems', len(items))
        self.m.write_bytes('wItems', [v for item in items for v in (self.h.con.item_id(item), 1)] + [255])
        self.m.write('wFishingContestPrize', self.h.con.item_id('WATER_STONE'))
        self.officer([], (1, 16))
        self.check(self.m.read('wFishingContestPrize') == self.h.con.item_id('WATER_STONE'), 'full bag retains pending prize')
        save_continue(self.h, map_id=(1, 16))
        self.pending = False
        self.check(self.m.read('wFishingContestPrize') == self.h.con.item_id('WATER_STONE'),
                   'native Save/fresh boot/Continue preserves the held prize')
        self.check(self.m.read('wNumItems') == capacity, 'native Continue preserves the full bag')
        self.m.write('wNumItems', len(items) - 1)
        self.m.write('wItems', 255, (len(items) - 1) * 2)
        self.officer([], (1, 16))
        self.check(self.m.read('wFishingContestPrize') == 0, 'claim succeeds after making room')
        self.check(self.m.read('wNumItems') == len(items) and self.m.read('wItems', (len(items) - 1) * 2) == self.h.con.item_id('WATER_STONE'),
                   'native claim placed Water Stone in the freed slot')
        self.capture('held-prize-claimed')


def main():
    ui = ContestUI()
    try:
        ui.run()
    except Exception as error:
        ui.failures.append(f'{ui.label}: {error}')
        print('ERROR ' + ui.failures[-1], flush=True)
        ui.capture('error')
        with (OUTPUT / 'error.state').open('wb') as stream:
            ui.h.pb.save_state(stream)
    finally:
        ui.h.pb.stop(save=False)
    report = dict(checks=ui.checks, failures=ui.failures, snapshots=ui.snapshots)
    (OUTPUT / 'results.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'FISHING UI: {ui.checks} checks; {len(ui.failures)} failures', flush=True)
    return int(bool(ui.failures))


if __name__ == '__main__':
    raise SystemExit(main())
