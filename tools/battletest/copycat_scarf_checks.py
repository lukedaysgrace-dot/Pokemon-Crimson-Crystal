#!/usr/bin/env python3
"""Native guarded scarf, both permission speeches and Copycat quest recovery.

Private New Game; story inventory and gender prerequisites are staged. Map
interaction, dialogue, doll handoff, Pass receipt and scarf pickup use buttons.
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
    scarf = h.con.item_id('CHOICE_SCARF')
    attempted = 'EVENT_TRIED_TAKING_COPYCAT_SCARF'
    permission = 'EVENT_COPYCAT_SCARF_PERMISSION'
    collected = 'EVENT_GOT_CHOICE_SCARF_FROM_COPYCAT'
    checks = 0
    texts = []
    output = ROOT / '.tmpbuild/copycat-scarf'
    output.mkdir(parents=True, exist_ok=True)

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def event(name, value=None):
        flag = flags[name]
        if value is None:
            return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))
        call(h, 'EventFlagAction', B=int(value), D=flag >> 8, E=flag & 255)

    def quantity():
        return sum(m.read('wItems', i * 2 + 1)
                   for i in range(m.read('wNumItems'))
                   if m.read('wItems', i * 2) == scarf)

    def keys():
        return list(m.read_bytes('wKeyItems', m.read('wNumKeyItems')))

    def obj(index):
        return next((o for o in controls.objects() if o['map_object'] == index), None)

    def text(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        pointer = pb.memory[bank, address] | pb.memory[bank, address + 1] << 8
        texts.append(((bank, pointer), event('EVENT_GOT_PASS_FROM_COPYCAT'), event(permission), quantity()))

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

    def enter(x=3, y=2):
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', x)
        m.write('wYCoord', y)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(controls.map_id() == (group, number), 'Copycat house entry failed')

    def talk_below():
        texts.clear()
        controls.press('down', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        for _ in range(240):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return [entry[0] for entry in texts]
            controls.press('a', hold=4, wait=24)
        raise AssertionError('Copycat dialogue did not finish')

    try:
        new_game(h, 0)
        m.write('wOptions', 0xc1)
        m.write('wDefaultSpawnpoint', 255)
        controls = Controls(h)
        prepared = io.BytesIO()
        pb.save_state(prepared)
        pb.hook_register(*h.sym['Script_writetext'], text, None)
        try:
            for female, tried in product((False, True), repeat=2):
                prepared.seek(0)
                pb.load_state(prepared)
                flag = engine['ENGINE_PLAYER_IS_FEMALE']
                call(h, 'EngineFlagAction', B=int(female), D=flag >> 8, E=flag & 255)
                event('EVENT_RETURNED_MACHINE_PART', True)
                event('EVENT_COPYCATS_HOUSE_2F_DOLL', True)
                enter()
                active = 6 if female else 1
                inactive = 1 if female else 6
                check(obj(active) is not None and obj(inactive) is None, 'Wrong gender Copycat is active')
                check(obj(7) is not None and obj(7)['position'] == [3, 3], 'Scarf ball missing or misplaced')
                check(not event(permission) and not quantity(), 'Scarf already granted before quest')
                if tried:
                    for _ in range(2):
                        said = talk_below()
                        check(h.sym['CopycatText_NoStealingScarf'] in said,
                              'Attempted theft does not trigger Copycat scolding')
                        check(event(attempted) and not event(permission) and not quantity()
                              and obj(7) is not None, 'Blocked theft changed ownership or removed the scarf')
                    enter()
                    check(event(attempted), 'House re-entry forgets attempted theft')

                m.write('wNumKeyItems', 1)
                m.write_bytes('wKeyItems', [h.con.item_id('LOST_ITEM'), 255])
                controls.go((4, 2))
                check(controls.position() == (4, 2), 'Cannot approach Copycat with doll')
                said = talk_below()
                offered = 'CopycatText_RememberScarf' if tried else 'CopycatText_OfferScarf'
                other = 'CopycatText_OfferScarf' if tried else 'CopycatText_RememberScarf'
                check(h.sym[offered] in said and h.sym[other] not in said, 'Wrong permission speech selected')
                check(said.index(h.sym['CopycatText_ExplainPass']) < said.index(h.sym[offered]),
                      'Scarf speech happens before the Pass explanation')
                check((h.sym[offered], True, False, 0) in texts,
                      'Permission is given before the Pass or automatically grants the scarf')
                check(event('EVENT_RETURNED_LOST_ITEM_TO_COPYCAT') and event('EVENT_GOT_PASS_FROM_COPYCAT')
                      and event(permission), 'Doll/Pass quest or scarf permission was not recorded')
                check(keys().count(h.con.item_id('PASS')) == 1 and h.con.item_id('LOST_ITEM') not in keys(),
                      'Doll handoff did not exchange exactly one Lost Item for the Pass')
                check(obj(7) is not None and not quantity() and not event(collected),
                      'Permission consumed or automatically delivered the item ball')

                controls.go((3, 2))
                if female and tried:
                    bank, address = h.sym['ItemAttributes']
                    stock = [item for item in range(1, 194) if item != scarf
                             and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
                    check(len(stock) == 40, 'Could not prepare full legal item pocket')
                    m.write('wNumItems', 40)
                    m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
                    talk_below()
                    check(not event(collected) and quantity() == 0 and obj(7) is not None,
                          'Full Bag consumes the scarf or its permission')
                    m.write('wNumItems', 0)
                    m.write_bytes('wItems', b'\xff')
                said = talk_below()
                check(quantity() == 1 and event(collected) and obj(7) is None,
                      'Permitted native pickup did not give one scarf and remove the ball')
                check(h.sym['CopycatText_NoStealingScarf'] not in said and event(attempted) == tried,
                      'Permitted pickup is treated as theft')
                enter(4, 2)
                check(obj(7) is None and quantity() == 1, 'Scarf respawns on house re-entry')
                said = talk_below()
                check(h.sym[offered] not in said and quantity() == 1, 'Permission speech or gift repeats')
                print(f'PASS native Copycat: female={female}, attempted={tried}', flush=True)

            for already_has_pass in (False, True):
                prepared.seek(0)
                pb.load_state(prepared)
                event('EVENT_RETURNED_LOST_ITEM_TO_COPYCAT', True)
                event('EVENT_GOT_PASS_FROM_COPYCAT', already_has_pass)
                m.write('wNumKeyItems', int(already_has_pass))
                m.write_bytes('wKeyItems', [h.con.item_id('PASS'), 255] if already_has_pass else [255])
                enter(4, 2)
                said = talk_below()
                check(h.sym['CopycatText_OfferScarf'] in said and event(permission),
                      'Existing Pass/retry save cannot receive scarf permission')
                check(keys().count(h.con.item_id('PASS')) == 1 and event('EVENT_GOT_PASS_FROM_COPYCAT'),
                      'Existing quest recovery duplicates or loses Pass')
            check([flags[n] for n in (attempted, permission, collected)] == list(range(0x19b, 0x19e)),
                  'Scarf flags did not reuse the three unused save bits')
            for name, expected in {'wEventFlags': 0xdab0, 'wCurBox': 0xdbb9,
                                   'wGameDataEnd': 0xdff3, 'sSaveDataEnd': 0xac36}.items():
                check(h.sym.addr(name) == expected, f'Save layout shifted: {name}')
            print(f'COPYCAT SCARF: {checks} checks passed', flush=True)
        finally:
            pb.hook_deregister(*h.sym['Script_writetext'])
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
