#!/usr/bin/env python3
"""Exercise native Tower registration, rooms, streaks, prizes, and suspension.

The initial private New Game receives a staged party/location/Hall of Fame
flag. Battles use boosted fixture stats to finish quickly. Subsequent menus,
save/reset, map movement, battle outcomes, and rewards use ordinary buttons.
Hooks observe execution; they do not replace game routines.
"""

import io
import json
from pathlib import Path
import threading

from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from gameplay_rules_checks import new_game, hook, save_continue
from overworld_controls import Controls
from ui_checks import tile_text

OUTPUT = Path('.tmpbuild/tower-ui')
LOBBY, ROOM = (22, 11), (22, 12)


class TowerUI:
    def __init__(self):
        self.h = Harness()
        self.c = Controls(self.h)
        self.checks, self.failures = 0, []
        self.label = 'setup'
        self.yesno = False
        self.level_menu = False
        self.battles = []
        self.maps = set()
        self.reset_seen = False
        self.selection = False
        OUTPUT.mkdir(parents=True, exist_ok=True)
        self.monitor_stop = threading.Event()

        def monitor():
            while not self.monitor_stop.wait(30):
                try:
                    pb = self.h.pb
                    print('PROGRESS ' + json.dumps(dict(label=self.label, pc=pb.register_file.PC,
                          symbol=self.h.sym.nearest(self.m.read('hROMBank'), pb.register_file.PC),
                          map=self.c.map_id(), text=tile_text(self.h))), flush=True)
                except Exception:
                    pass
        threading.Thread(target=monitor, daemon=True).start()

    @property
    def m(self):
        return self.h.battle.mem

    def check(self, ok, description):
        self.checks += 1
        if not ok:
            self.failures.append(self.label + ': ' + description)
            print('FAIL ' + self.failures[-1], flush=True)

    def sram(self, name):
        bank, address = self.h.sym[name]
        self.h.pb.memory[0] = 10
        self.h.pb.memory[0x4000] = bank
        value = self.h.pb.memory[address]
        self.h.pb.memory[0] = 0
        return value

    def observe_battle(self, _):
        self.level_menu = False
        self.battles.append(dict(group=self.m.read('wBTChoiceOfLvlGroup'),
                                 opponent=self.sram('sNrOfBeatenBattleTowerTrainers')))
        print('BATTLE ' + json.dumps(self.battles[-1]), flush=True)

    def prepare(self):
        new_game(self.h, 0)
        m, h = self.m, self.h
        request, address = Request(h.battle), h.sym.addr('wDebugPlayer1')
        m.write('wMonType', 0)
        for slot, species in enumerate(('DRAGONITE', 'GYARADOS', 'CROBAT')):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
                species=species, level=10, moves=['AERIAL_ACE'], dvs=0xffff)))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
            # Explicitly staged, fast-win stats, retained by the native save.
            for field in ('HP', 'MaxHP', 'Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef'):
                m.write_bytes(f'wPartyMon{slot + 1}' + field, (1000).to_bytes(2, 'big'))
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wOptions', 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wMapGroup', LOBBY[0])
        m.write('wMapNumber', LOBBY[1])
        m.write('wXCoord', 7)
        m.write('wYCoord', 7)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        self.c.wait(400)
        self.check(self.c.map_id() == LOBBY, 'native lobby loaded')
        hook(h, 'YesNoBox', lambda _: setattr(self, 'yesno', True))
        hook(h, '_BattleTowerRoomMenu', lambda _: setattr(self, 'level_menu', True))
        hook(h, 'RunBattleTowerTrainer', self.observe_battle)
        hook(h, 'Reset', lambda _: setattr(self, 'reset_seen', True))
        hook(h, 'SelectBattleMon', lambda _: setattr(self, 'selection', True))
        self.party = m.read_bytes('wPartyMons', 3 * (h.sym.addr('wPartyMon2') - h.sym.addr('wPartyMon1')))
        self.fixture = io.BytesIO()
        h.pb.save_state(self.fixture)
        self.capture('lobby')

    def load(self, label, hof=True):
        self.fixture.seek(0)
        self.h.pb.load_state(self.fixture)
        self.label = label
        self.yesno = self.level_menu = self.reset_seen = False
        self.battles.clear()
        self.selection = False
        self.maps.clear()
        self.h.text_overflows.clear()
        # Hall of Fame flag unlocks level brackets 50 through 100.
        if hof:
            self.m.write('wStatusFlags', self.m.read('wStatusFlags') | 64)

    def capture(self, label):
        data = dict(label=self.label + '/' + label, map=self.c.map_id(),
                    position=self.c.position(), state=self.sram('sBattleTowerChallengeState'),
                    beaten=self.sram('sNrOfBeatenBattleTowerTrainers'),
                    group=self.m.read('wBTChoiceOfLvlGroup'),
                    menu_state=self.m.read('wcf66'), level_cursor=self.m.read('wcd4f'),
                    level_count=self.m.read('wcd4a'), text=tile_text(self.h))
        self.h.pb.screen.image.save(str(OUTPUT / (self.label + '-' + label + '.png')))
        print(json.dumps(data), flush=True)

    def talk(self):
        self.c.press('up', hold=4, wait=20)
        self.c.press('a', hold=4, wait=24)

    def drive(self, until, answers=(), group=1, prize=1, challenge=1, limit=240000):
        answers = list(answers)
        start = self.c.frames
        while self.c.frames - start < limit:
            self.maps.add(self.c.map_id())
            if until():
                return answers
            text = tile_text(self.h)
            if self.selection and 'CANCEL' in text and 'Which' in text:
                self.c.wait(30)
                fit = next((slot for slot in range(1, 4)
                            if self.m.read_u16_be(f'wPartyMon{slot}HP')), None)
                if fit is not None and self.m.read('wMenuCursorY') != fit:
                    self.c.press('down', hold=4, wait=24)
                else:
                    self.selection = False
                    self.c.press('a', hold=4, wait=24)
            elif self.yesno and 'YES' in text and 'NO' in text:
                self.c.wait(30)
                answer = answers.pop(0) if answers else True
                desired = 1 if answer else 2
                if self.m.read('wMenuCursorY') != desired:
                    self.c.press('down', hold=4, wait=20)
                self.yesno = False
                self.c.press('a', hold=4, wait=24)
            elif all(word in text.upper() for word in ('CHALLENGE', 'EXPLANATION', 'CANCEL')):
                self.c.wait(30)
                desired = challenge
                if self.m.read('wMenuCursorY') != desired:
                    self.c.press('down', hold=4, wait=20)
                else:
                    self.c.press('a', hold=4, wait=24)
            elif self.level_menu and self.m.read('wcf66') == 2:
                self.c.wait(30)
                if group is None:
                    self.c.press('b', hold=4, wait=24)
                elif self.m.read('wcd4f') != group:
                    # This original menu uses UP to increase the level.
                    self.c.press('up', hold=4, wait=24)
                else:
                    self.c.press('a', hold=4, wait=24)
            elif 'CHOICE BAND' in text and 'CHOICE SPECS' in text and 'CANCEL' in text:
                self.c.wait(30)
                if self.m.read('wMenuCursorY') != prize:
                    self.c.press('down', hold=4, wait=20)
                else:
                    self.c.press('a', hold=4, wait=24)
            else:
                self.c.press('a', hold=4, wait=20)
        self.capture('timeout')
        raise RuntimeError(self.label + ': native UI timeout: ' + self.h.where())

    def idle(self):
        return (self.c.map_id() == LOBBY and self.m.read('wMapStatus') == 2
                and self.m.read('wScriptMode') == 0 and not self.m.read('wBattleMode'))


def main():
    t = TowerUI()
    try:
        t.prepare()
        t.load('registration-cancel', hof=False)
        t.talk()
        t.drive(t.idle, answers=[False], challenge=3)
        t.check(not t.battles, 'cancel stays in lobby without a battle')
        t.capture('done')

        t.load('pre-hof-level-menu', hof=False)
        t.talk()
        t.drive(lambda: t.level_menu and t.m.read('wcf66') == 2, answers=[False, True])
        t.check(t.m.read('wcd4a') == 5, 'before Hall of Fame only L10 through L40 plus Cancel')
        t.capture('levels')

        for group in range(1, 11):
            t.load('level-' + str(group * 10))
            t.talk()
            t.drive(lambda: bool(t.battles), answers=[False, True], group=group)
            t.check(t.battles[0]['group'] == group, 'chosen level reaches native battle loader')
            t.check({(22, 13), (22, 14), ROOM} <= t.maps, 'elevator, hallway and room reached through scripted walks')
            t.check(t.battles[0]['opponent'] == 0, 'new challenge begins with the first opponent')
            t.capture('battle-start')

        for label, stage in (
            ('two-mon-refusal', lambda: t.m.write('wPartyCount', 2)),
            ('duplicate-species-refusal', lambda: t.m.write('wPartyMon2Species', t.m.read('wPartyMon1Species'))),
            ('duplicate-item-refusal', lambda: (t.m.write('wPartyMon1Item', t.h.con.item_id('BERRY')),
                                               t.m.write('wPartyMon2Item', t.h.con.item_id('BERRY')))),
            ('egg-refusal', lambda: t.m.write('wPartySpecies', 253, 1)),
        ):
            t.load(label)
            stage()
            t.talk()
            t.drive(t.idle, answers=[False])
            t.check(not t.battles and not t.m.read('wSaveFileExists'), 'native rules refuse before registration/save')
            t.capture('refused')

        t.load('over-level-refusal')
        t.m.write('wPartyMon1Level', 11)
        t.talk()
        t.drive(lambda: t.level_menu and t.m.read('wcf66') == 5,
                answers=[False, True], group=1)
        t.check(not t.battles, 'level selection rejects an overleveled party')
        t.capture('refused')

        for label, answers, suspended in (
            ('quit-challenge', [False, True, False, False, True], False),
            ('suspend-challenge', [False, True, False, True], True),
        ):
            t.load(label)
            for slot in range(1, 4):
                t.m.write(f'wPartyMon{slot}Level', 100)
                t.m.write_bytes(f'wPartyMon{slot}Attack', (10000).to_bytes(2, 'big'))
            expected = t.m.read_bytes('wPartyMons', len(t.party))
            t.talk()
            t.drive(lambda: t.reset_seen if suspended else t.idle(), answers=answers, group=10)
            t.check(len(t.battles) == 1, 'one actual win before quitting/suspending')
            t.check(t.sram('sBattleTowerChallengeState') == (1 if suspended else 0), 'native challenge state')
            t.check(t.m.read_bytes('wPartyMons', len(expected)) == expected, 'party restored after win')
            t.capture('ended')
            if suspended:
                t.yesno = t.level_menu = False
                t.c.wait(400)
                t.drive(lambda: len(t.battles) == 2, group=10)
                t.check(t.battles[1] == dict(group=10, opponent=1), 'Continue resumes the next opponent and saved level')
                t.capture('resumed')

        t.load('lose-and-retry')
        for slot in range(1, 4):
            for field in ('HP', 'MaxHP', 'Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef'):
                t.m.write_bytes(f'wPartyMon{slot}' + field, (1).to_bytes(2, 'big'))
        expected = t.m.read_bytes('wPartyMons', len(t.party))
        t.talk()
        t.drive(t.idle, answers=[False, True], group=10)
        t.check(len(t.battles) == 1 and t.m.read('wBattleResult') == 1, 'native Tower loss returns to lobby')
        t.check(t.sram('sBattleTowerChallengeState') == 0, 'loss cancels the challenge')
        t.check(t.m.read_bytes('wPartyMons', len(expected)) == expected, 'loss restores and heals the saved party')
        t.talk()
        t.drive(lambda: len(t.battles) == 2, answers=[True], group=10)
        t.check(t.battles[1]['opponent'] == 0, 'retry begins a fresh streak')
        t.capture('retry')

        t.load('full-streak')
        for slot in range(1, 4):
            t.m.write(f'wPartyMon{slot}Level', 100)
            t.m.write_bytes(f'wPartyMon{slot}Attack', (10000).to_bytes(2, 'big'))
        streak_party = t.m.read_bytes('wPartyMons', len(t.party))
        t.talk()
        t.drive(t.idle, answers=[False, True] + [True] * 6, group=10, prize=6)
        t.check(len(t.battles) == 7, 'seven actual battles in a complete streak')
        t.check(t.sram('sNrOfBeatenBattleTowerTrainers') == 7, 'seven opponents recorded')
        t.check(t.sram('sBattleTowerChallengeState') == 3, 'canceled prize remains available')
        t.check(t.m.read('wNumItems') == 0, 'cancel awards no item')
        t.check(t.m.read_bytes('wPartyMons', len(streak_party)) == streak_party, 'party restored after the complete streak')
        t.check(not t.h.text_overflows, 'dialogue bounds throughout streak')
        t.capture('reward')
        with (OUTPUT / 'after-streak.state').open('wb') as stream:
            t.h.pb.save_state(stream)
        won = io.BytesIO()
        t.h.pb.save_state(won)
        for choice, item in enumerate(('CHOICE_BAND', 'CHOICE_SPECS', 'CHOICE_SCARF', 'FOCUS_SASH', 'WEAK_POLICY'), 1):
            won.seek(0)
            t.h.pb.load_state(won)
            t.label = 'prize-' + item.lower()
            t.talk()
            t.drive(t.idle, prize=choice)
            t.check(t.sram('sBattleTowerChallengeState') == 4, 'prize marked received')
            t.check(t.m.read('wNumItems') == 1 and t.m.read('wItems') == t.h.con.item_id(item)
                    and t.m.read('wItems', 1) == 1, 'one selected prize awarded')
            t.capture('claimed')

        won.seek(0)
        t.h.pb.load_state(won)
        t.label = 'prize-full-bag'
        t.m.write('wNumItems', 40)
        t.m.write_bytes('wItems', [v for item in range(1, 41) for v in (item, 1)] + [255])
        full_bag = t.m.read_bytes('wItems', 81)
        t.talk()
        t.drive(t.idle, prize=4)
        t.check(t.sram('sBattleTowerChallengeState') == 3, 'full bag preserves unclaimed prize')
        t.check(t.m.read_bytes('wItems', 81) == full_bag, 'full bag unchanged')
        t.capture('held')
        # Make room as an explicit fixture, then claim with normal controls.
        t.m.write('wNumItems', 0)
        t.m.write('wItems', 255)
        t.talk()
        t.drive(t.idle, prize=4)
        t.check(t.m.read('wItems') == t.h.con.item_id('FOCUS_SASH'), 'held prize can be claimed after making room')
        t.check(t.sram('sBattleTowerChallengeState') == 4, 'held-prize claim completes')
        t.capture('claimed')

        save_continue(t.h, map_id=LOBBY)
        t.label = 'prize-save-continue'
        t.check(t.m.read('wNumItems') == 1 and t.m.read('wItems') == t.h.con.item_id('FOCUS_SASH')
                and t.m.read('wItems', 1) == 1, 'native Save/fresh Continue retains exactly one prize')
        t.check(t.sram('sBattleTowerChallengeState') == 0, 'saving commits the received reward')
        hook(t.h, 'YesNoBox', lambda _: setattr(t, 'yesno', True))
        t.yesno = t.level_menu = False
        t.talk()
        t.drive(t.idle, challenge=3)
        t.check(t.m.read('wNumItems') == 1 and t.m.read('wItems', 1) == 1, 'receptionist cannot award a second prize after saved claim')
        t.capture('done')

        report = dict(checks=t.checks, failures=t.failures)
        (OUTPUT / 'results.json').write_text(json.dumps(report, indent=2))
        print(json.dumps(report), flush=True)
        return int(bool(t.failures))
    finally:
        t.monitor_stop.set()
        t.h.pb.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())
