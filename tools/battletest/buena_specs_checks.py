#!/usr/bin/env python3
"""Buena's native post-rescue gift, full Bag retry and Blue Card introduction.

Story preconditions are staged on a private New Game. Map interaction,
dialogue, inventory and reward flags execute the real game through buttons.
"""
import io
from itertools import product
import re

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness
from save_menu_checks import begin_native_call
from symbols import ROOT, _parse_constants


def main():
    h = Harness()
    pb, m = h.pb, h.battle.mem
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    engine = _parse_constants(ROOT / 'constants/engine_flags.asm')
    glasses = h.con.item_id('WISE_GLASSES')
    received = 'EVENT_GOT_WISE_GLASSES_FROM_BUENA'
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def event(name, value=None):
        flag = flags[name]
        if value is None:
            return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))
        call(h, 'EventFlagAction', B=int(value), D=flag >> 8, E=flag & 255)

    def engine_flag(name, value):
        flag = engine[name]
        call(h, 'EngineFlagAction', B=int(value), D=flag >> 8, E=flag & 255)

    def quantity():
        return sum(m.read('wItems', i * 2 + 1)
                   for i in range(m.read('wNumItems'))
                   if m.read('wItems', i * 2) == glasses)

    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),', line)
        if match:
            number += 1
            if match[1] == 'RADIO_TOWER_2F':
                break

    def enter():
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', 14)
        m.write('wYCoord', 6)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(controls.map_id() == (group, number), 'Radio Tower 2F entry failed')

    def talk():
        controls.press('up', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        for _ in range(150):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
            controls.press('a', hold=4, wait=24)
        raise AssertionError('Buena dialogue did not finish')

    try:
        new_game(h, 0)
        m.write('wOptions', 0xc1)
        m.write('wDefaultSpawnpoint', 255)
        controls = Controls(h)
        prepared = io.BytesIO()
        pb.save_state(prepared)

        for cleared, bell, rockets in product((False, True), repeat=3):
            prepared.seek(0)
            pb.load_state(prepared)
            event('EVENT_CLEARED_RADIO_TOWER', cleared)
            event('EVENT_GOT_CLEAR_BELL', bell)
            engine_flag('ENGINE_ROCKETS_IN_RADIO_TOWER', rockets)
            enter()
            check(quantity() == 0 and not event(received), 'Gift exists before talking')
            talk()
            eligible = cleared and bell and not rockets
            check(quantity() == int(eligible) and event(received) == eligible,
                  f'Incorrect rescue gate: cleared={cleared}, bell={bell}, rockets={rockets}')
            if eligible:
                check(not event('EVENT_MET_BUENA'), 'Rescue gift skips into unrelated introduction')
                talk()
                check(quantity() == 1 and event('EVENT_MET_BUENA'),
                      'Follow-up duplicates gift or loses Blue Card introduction')
                blue_card = h.con.item_id('BLUE_CARD')
                check(blue_card in m.read_bytes('wKeyItems', m.read('wNumKeyItems')),
                      'Normal Blue Card gift no longer works after Wise Glasses')

        prepared.seek(0)
        pb.load_state(prepared)
        event('EVENT_CLEARED_RADIO_TOWER', True)
        event('EVENT_GOT_CLEAR_BELL', True)
        engine_flag('ENGINE_ROCKETS_IN_RADIO_TOWER', False)
        # A completed daily show must not block the rescue reward.
        engine_flag('ENGINE_BUENAS_PASSWORD_2', True)
        bank, address = h.sym['ItemAttributes']
        stock = [item for item in range(1, 194) if item != glasses
                 and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
        check(len(stock) == 40, 'Could not prepare a full legal item pocket')
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
        enter()
        talk()
        check(not event(received) and quantity() == 0, 'Full Bag consumes rescue gift')
        m.write('wNumItems', 0)
        m.write_bytes('wItems', b'\xff')
        talk()
        check(event(received) and quantity() == 1, 'Could not retry gift after making room')
        enter()
        talk()
        check(quantity() == 1, 'Map reload makes rescue gift repeatable')
        check(flags[received] == 0x194, 'Reward did not reuse the unused event bit')
        print(f'BUENA WISE GLASSES: {checks} checks passed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
