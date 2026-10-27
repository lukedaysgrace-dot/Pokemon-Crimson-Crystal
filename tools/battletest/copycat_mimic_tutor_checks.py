#!/usr/bin/env python3
"""Native Copycat MIMIC tutor in Saffron (button input through the dialogue).

Private New Game; story flags and a one-Pokemon party are staged in emulator
memory. Checks: no offer before the lost doll is returned, YES -> party menu
(every non-Egg Pokemon shows ABLE) -> learns MIMIC, NO -> declined speech,
and the offer repeats on every visit.
"""
import io
import re

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness
from save_menu_checks import begin_native_call
from state import Request
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    h = Harness()
    pb, m = h.pb, h.battle.mem
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    out = ROOT / '.tmpbuild/copycat-mimic'
    out.mkdir(parents=True, exist_ok=True)
    texts = []
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def event(name, value):
        flag = flags[name]
        call(h, 'EventFlagAction', B=int(value), D=flag >> 8, E=flag & 255)

    def text(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        texts.append((bank, pb.memory[bank, address] | pb.memory[bank, address + 1] << 8))

    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),', line)
        if match:
            number += 1
            if match[1] == 'COPYCATS_HOUSE_2F':
                break

    def enter():
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', 4)
        m.write('wYCoord', 2)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)

    def idle():
        return not m.read('wScriptMode') and m.read('wMapStatus') == 2

    def talk(answer_yes=None, pick_mon=False):
        """Talk to the Copycat; answer the MIMIC offer if it appears."""
        texts.clear()
        controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        answered = picked = False
        for _ in range(400):
            screen = tile_text(h)
            if idle() and _ > 2:
                return answered, picked
            if not answered and h.sym['CopycatText_OfferMimic'] in texts \
                    and 'YES' in screen and 'NO' in screen:
                h.tick(30)
                pb.screen.image.resize((640, 576)).save(out / 'offer.png')
                if not answer_yes:
                    controls.press('down', hold=4, wait=24)
                controls.press('a', hold=4, wait=40)
                answered = True
                continue
            if pick_mon and not picked and 'ABLE' in screen:
                h.tick(30)
                pb.screen.image.resize((640, 576)).save(out / 'party-menu.png')
                check('NOT ABLE' not in screen, 'Party menu says NOT ABLE for MIMIC')
                controls.press('a', hold=4, wait=60)
                picked = True
                continue
            if picked and 'ABLE' in screen and 'Teach' in screen:
                # Back at the party menu (e.g. it already knew MIMIC): cancel.
                controls.press('b', hold=4, wait=40)
                continue
            controls.press('a', hold=4, wait=24)
        raise AssertionError('Copycat dialogue did not finish: ' + tile_text(h))

    def party_moves():
        return [m.read('wPartyMon1Moves', i) for i in range(4)]

    try:
        new_game(h, 0)
        m.write('wOptions', 0xc1)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wPartyCount', 0)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', Request(h.battle)._side_bytes(
            dict(species='MEW', level=50, moves=['SPLASH', 'TACKLE'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        check(m.read('wPartyCount') == 1, 'Could not stage party')
        controls = Controls(h)
        prepared = io.BytesIO()
        pb.save_state(prepared)
        pb.hook_register(*h.sym['Script_writetext'], text, None)

        # Before the doll is returned: no MIMIC offer.
        event('EVENT_RETURNED_MACHINE_PART', True)
        event('EVENT_COPYCATS_HOUSE_2F_DOLL', True)
        enter()
        answered, _ = talk()
        check(not answered and h.sym['CopycatText_OfferMimic'] not in texts,
              'MIMIC offered before the doll was returned')
        print('PASS no MIMIC offer before the quest', flush=True)

        # After the quest: YES -> party menu -> learn.
        pb.load_state(io.BytesIO(prepared.getvalue()))
        for name in ('EVENT_RETURNED_MACHINE_PART', 'EVENT_RETURNED_LOST_ITEM_TO_COPYCAT',
                     'EVENT_GOT_PASS_FROM_COPYCAT', 'EVENT_COPYCAT_SCARF_PERMISSION'):
            event(name, True)
        m.write('wNumKeyItems', 1)
        m.write_bytes('wKeyItems', [h.con.item_id('PASS'), 255])
        enter()
        before = party_moves()
        answered, picked = talk(answer_yes=True, pick_mon=True)
        after = party_moves()
        check(answered and picked, 'MIMIC offer / party menu not reached')
        check(h.sym['CopycatText_MimicTaught'] in texts, 'Taught text missing')
        check(after[:2] == before[:2] and after[2] != 0 and before[2] == 0,
              f'MIMIC not learned into the free slot: {before} -> {after}')
        check(m.move_index_of(after[2]) == h.con.move_index('MIMIC'), 'Learned move is not MIMIC')
        print('PASS Copycat taught MIMIC through the party menu', flush=True)

        # Again: declining works and the offer repeats.
        answered, _ = talk(answer_yes=False)
        check(answered and h.sym['CopycatText_MimicDeclined'] in texts, 'Decline path broken')
        check(party_moves() == after, 'Declining changed moves')
        print('PASS offer repeats; NO declines', flush=True)

        # Already knows MIMIC: no duplicate.
        answered, picked = talk(answer_yes=True, pick_mon=True)
        check(picked and party_moves() == after, 'MIMIC learned twice')
        check(h.sym['CopycatText_MimicDeclined'] in texts, 'Cancelling the party menu did not decline')
        print(f'COPYCAT MIMIC: {checks} checks passed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
