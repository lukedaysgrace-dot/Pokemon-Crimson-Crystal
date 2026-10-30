#!/usr/bin/env python3
"""Real turns with expanded held items, using private post-entry fixtures.

The existing debug request has a byte item field. These cases deliberately
seed an allocated runtime slot and its true index after entry, then let the
retail battle engine run the entire turn and consume/update the held item.
"""
from runner import Harness, FRAME_CEILING_BATTLE
from symbols import STATE_WAIT, STATE_DONE, parse_substatus_bits


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    checks = 0
    confused_byte, confused_bit = parse_substatus_bits()['CONFUSED']
    confusion = 'wPlayerSubStatus' + str(confused_byte + 1)

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def start(item='NO_ITEM', move='SPLASH', ability='NO_ABILITY'):
        h.load_fixture()
        test = dict(player=dict(species='MEW', level=100, ability=ability, item=item, moves=[move]),
                    enemy=dict(species='MEW', level=100, ability='NO_ABILITY', moves=['SPLASH']),
                    rng='forced_low', turns=0)
        check(h.run_battle(test) == STATE_WAIT, 'battle did not reach pre-turn pause')

    def equip(name, retired=None):
        m = h.battle.mem
        index = retired if retired is not None else h.con.item_id(name)
        slot = 202  # beyond all fixed legacy/Mail slots
        offset = 2 * (slot - 1)
        previous = m.read_bytes('wItemIndexTableEntries', 2, offset)
        m.write_bytes('wItemIndexTableEntries', [index & 255, index >> 8], offset)
        if previous == b'\0\0':
            m.write('wItemIndexTableUsedSlots', m.read('wItemIndexTableUsedSlots') + 1)
        m.write('wBattleMonItem', slot)
        m.write('wPartyMon1Item', slot)
        expected = f'ITEM_{retired}' if retired is not None else name
        check(h.battle.player.item == expected, name + ': fixture index')

    def turn():
        m = h.battle.mem
        m.write('wDebugTurnTarget', 1)
        m.write('wDebugControl', 1)
        for _ in range(FRAME_CEILING_BATTLE // 4):
            h.pb.button('a', 2)
            h.tick(4)
            if h.state() in (STATE_WAIT, STATE_DONE) and h.battle.turns_done >= 1:
                return
        raise AssertionError('battle turn did not finish')

    try:
        for retired, (name, status, confuse) in enumerate([
                ('PSNCUREBERRY', 8, False), ('ICE_BERRY', 16, False),
                ('BURNT_BERRY', 32, False), ('MINT_BERRY', 3, False),
                ('PRZCUREBERRY', 64, False), ('BITTER_BERRY', 0, True),
                ('MIRACLEBERRY', 8, True)], 0x111):
            start()
            equip(name, retired)
            m = h.battle.mem
            m.write('wBattleMonStatus', status)
            m.write('wPartyMon1Status', status)
            if confuse:
                m.write(confusion, m.read(confusion) | 1 << confused_bit)
                m.write('wPlayerConfuseCount', 3)
            turn()
            check(h.battle.player.status == 0, name + ': status not cured')
            check(not m.read(confusion) & (1 << confused_bit), name + ': confusion not cured')
            check(h.battle.player.item == 'NO_ITEM' and m.read('wPartyMon1Item') == 0,
                  name + ': consumed item not synchronized to party')
            print(name + ': native cure and consumption passed', flush=True)
        start(ability='KLUTZ')
        equip('PSNCUREBERRY', 0x111)
        h.battle.mem.write('wBattleMonStatus', 8)
        h.battle.mem.write('wPartyMon1Status', 8)
        turn()
        check(h.battle.player.status == 8 and h.battle.player.item == 'ITEM_273', 'Klutz failed to suppress converted Berry')
        damage = []
        for expanded in (False, True):
            start(item='PINK_BOW', move='TACKLE')
            if expanded:
                equip('POLKADOT_BOW')
            before = h.battle.enemy.hp
            turn()
            damage.append(before - h.battle.enemy.hp)
        check(damage[0] > 0 and damage[0] == damage[1], 'Polkadot Bow differs from the existing 10% Normal boost')
        print(f'EXPANDED HELD ITEMS PASSED: {checks} checks', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
