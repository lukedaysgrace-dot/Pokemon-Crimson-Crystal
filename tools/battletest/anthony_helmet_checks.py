#!/usr/bin/env python3
"""Anthony's native victory reward, full Bag retry and phone interaction.

Uses a private New Game and button-driven battles. Never opens a player save.
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


def main():
    h = Harness()
    pb, m = h.pb, h.battle.mem
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    helmet = h.con.item_id('ROCKY_HELMET')
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def event(name):
        flag = flags[name]
        return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))

    def quantity():
        return sum(m.read('wItems', i * 2 + 1)
                   for i in range(m.read('wNumItems'))
                   if m.read('wItems', i * 2) == helmet)

    def finish_dialogue():
        for _ in range(120):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
            controls.press('a', hold=4, wait=24)
        raise AssertionError('Anthony dialogue did not finish')

    def talk():
        controls.press('up', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        finish_dialogue()

    def win():
        # Approach from the diagonal, then talk or be spotted normally.
        for _ in range(3):
            if controls.position() == (6, 14):
                break
            controls.press('right', hold=4, wait=36)
        check(controls.position() == (6, 14), 'Cannot approach Anthony')
        controls.press('up', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        controls.battle()
        finish_dialogue()
        check(event('EVENT_BEAT_HIKER_ANTHONY'), 'Native battle victory was not recorded')
        check(m.read('hDebugActive') == 0 and m.read('wBattleResult') & 15 == 0,
              'Native trainer battle did not finish in a win')

    try:
        new_game(h, 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', Request(h.battle)._side_bytes(dict(
            species='MEW', level=100, ability='SYNCHRONIZE',
            moves=['PSYCHIC_M', 'AERIAL_ACE', 'FLAMETHROWER', 'AURA_SPHERE'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 0xc1)
        group = number = 0
        for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
            if re.match(r'\s+newgroup\b', line):
                group += 1
                number = 0
            match = re.match(r'\s+map_const\s+(\w+),', line)
            if match:
                number += 1
                if match[1] == 'ROUTE_33':
                    break
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', 5)
        m.write('wYCoord', 14)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        controls = Controls(h)
        check(controls.map_id() == (group, number), 'Route 33 map entry failed')
        check(not event('EVENT_BEAT_HIKER_ANTHONY') and not quantity(),
              'Reward exists before defeating Anthony')
        prepared = io.BytesIO()
        pb.save_state(prepared)

        win()
        check(event('EVENT_GOT_ROCKY_HELMET_FROM_ANTHONY') and quantity() == 1,
              'Victory did not immediately award one Rocky Helmet')
        check(not event('EVENT_ANTHONY_ASKED_FOR_PHONE_NUMBER'),
              'Initial victory unexpectedly skipped into phone registration')
        talk()
        check(quantity() == 1 and event('EVENT_ANTHONY_ASKED_FOR_PHONE_NUMBER'),
              'Repeat conversation duplicates gift or loses phone interaction')
        print('PASS native victory reward and subsequent phone interaction', flush=True)

        prepared.seek(0)
        pb.load_state(prepared)
        bank, address = h.sym['ItemAttributes']
        stock = [item for item in range(1, 194) if item != helmet
                 and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
        check(len(stock) == 40, 'Could not prepare a full legal item pocket')
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
        win()
        check(not event('EVENT_GOT_ROCKY_HELMET_FROM_ANTHONY') and quantity() == 0,
              'Full Bag consumes reward')
        m.write('wNumItems', 0)
        m.write_bytes('wItems', b'\xff')
        talk()
        check(event('EVENT_GOT_ROCKY_HELMET_FROM_ANTHONY') and quantity() == 1,
              'Defeated trainer cannot give pending gift after making room')
        talk()
        check(quantity() == 1, 'Claiming pending gift makes it repeatable')
        check(flags['EVENT_GOT_ROCKY_HELMET_FROM_ANTHONY'] == 0x193,
              'Reward did not reuse the unused event bit')
        for name, expected in {'wEventFlags': 0xdab0, 'wCurBox': 0xdbb9,
                               'wGameDataEnd': 0xdff3, 'sSaveDataEnd': 0xac36,
                               'sBackupSaveDataEnd': 0xbe36}.items():
            check(h.sym.addr(name) == expected, f'Save layout shifted: {name}')
        print(f'ANTHONY HELMET: {checks} checks passed; two native battles won', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
