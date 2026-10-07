#!/usr/bin/env python3
"""HP-item update ordering, perspective, and retail link RNG consumption."""

import io

from runner import Harness
from save_menu_checks import begin_native_call
from symbols import STATE_DONE, STATE_ERROR, STATE_WAIT


def main():
    h = Harness()
    h.ensure_fixture()
    h.load_fixture()
    test = dict(player=dict(species='MEW', level=100, ability='RIPEN', moves=['SPLASH']),
                enemy=dict(species='MEW', level=100, ability='NO_ABILITY', moves=['SPLASH']),
                rng='off', turns=0)
    if h.run_battle(test) != STATE_WAIT:
        raise RuntimeError('could not initialize item-update fixture')
    prepared = io.BytesIO()
    h.pb.save_state(prepared)
    order = []
    bank, address = h.sym['HandleHPHealingItem']
    h.pb.hook_register(bank, address, lambda _: order.append(h.battle.mem.read('hBattleTurn') ^ 1), None)
    checks = failures = cases = 0

    def check(condition, label):
        nonlocal checks, failures
        checks += 1
        if not condition:
            failures += 1
            print('FAIL ITEM UPDATE ' + label, flush=True)

    # Eligibility bits: player=1, enemy=2. Speed order reverses in Trick Room.
    for eligible in range(4):
        for turn in (0, 1):
            for speeds, trick_room in (((200, 100), 0), ((100, 200), 0),
                                       ((200, 100), 3), ((100, 200), 3), ((100, 100), 0)):
                prepared.seek(0)
                h.pb.load_state(prepared)
                m = h.battle.mem
                order.clear()
                m.write('hDebugRNGMode', 0)
                m.write('wLinkMode', 1)
                m.write('wLinkBattleRNCount', 0)
                m.write_bytes('wLinkBattleRNs', list(range(10)))
                m.write('hBattleTurn', turn)
                m.write('wTrickRoomTimer', trick_room)
                for side, prefix in enumerate(('wBattleMon', 'wEnemyMon')):
                    m.write_bytes(prefix + 'HP', [0, 1])
                    m.write_bytes(prefix + 'Speed', [speeds[side] >> 8, speeds[side] & 255])
                    m.write(prefix + 'Item', h.con.item_id('BERRY') if eligible & (1 << side) else 0)
                label = f'eligible={eligible}, turn={turn}, speeds={speeds}, TrickRoom={trick_room}'
                begin_native_call(h, 'RunHPItemUpdatesBoth')
                h.pb.memory[0xC0F0] = 0xF3
                for _ in range(1800):
                    h.pb.button('a', 2)
                    h.tick(4)
                    if h.pb.register_file.PC in (0xC0F1, 0xC0F3):
                        break
                else:
                    raise RuntimeError(label + ': helper did not return: ' + h.where())
                check(m.read('hBattleTurn') == turn, label + ': perspective restored')
                for side, prefix in enumerate(('wBattleMon', 'wEnemyMon')):
                    expected = 1 + ((20 if side == 0 else 10) if eligible & (1 << side) else 0)
                    check(m.read_u16_be(prefix + 'HP') == expected, label + f': side {side} exact healing')
                    check(m.read(prefix + 'Item') == 0, label + f': side {side} consumed eligible item')
                if eligible != 3:
                    expected_order = [side for side in (0, 1) if eligible & (1 << side)]
                elif speeds[0] == speeds[1]:
                    expected_order = [0, 1]  # First retail link byte is zero.
                else:
                    first = int(speeds[0] < speeds[1]) ^ int(bool(trick_room))
                    expected_order = [first, first ^ 1]
                check(order == expected_order, label + f': consumption order {order}')
                tie = eligible == 3 and speeds[0] == speeds[1]
                check(m.read('wLinkBattleRNCount') == int(tie), label + ': only a real two-item tie uses RNG')
                cases += 1
    print(f'{cases} item-update scenarios, {checks} checks, {failures} failures', flush=True)
    faint_events = []
    faint_context = None

    def at_faint(_, side):
        if faint_context is None or side != faint_context[0]:
            return
        m = h.battle.mem
        holder = h.battle.enemy if side == 0 else h.battle.player
        faint_events.append((holder.hp, holder.item, m.read('wNeutralizingGasActive'),
                             m.read('wSelfdestructGasTurn'), m.read('wInAbility')))

    for side, symbol in enumerate(('FaintYourPokemon', 'FaintEnemyPokemon')):
        bank, address = h.sym[symbol]
        h.pb.hook_register(bank, address, lambda context, side=side: at_faint(context, side), None)
    faint_cases = 0
    for holder_side in (0, 1):
        for suppression, species in (('UNNERVE', 'CORVISQUIRE'), ('NEUTRALIZING_GAS', 'WEEZING')):
            for ability in ('RIPEN', 'NO_ABILITY', 'KLUTZ'):
                for item in ('BERRY', 'BERRY_JUICE'):
                    h.load_fixture()
                    faint_events.clear()
                    faint_context = None
                    source = dict(species='MEW', level=100, ability=ability, item=item, moves=['AERIAL_ACE'])
                    target = dict(species=species, level=5, ability=suppression, moves=['SPLASH'])
                    case = dict(player=source if holder_side == 0 else target,
                                enemy=target if holder_side == 0 else source, rng='forced_high', turns=0)
                    if h.run_battle(case) != STATE_WAIT:
                        raise RuntimeError('could not initialize faint-update fixture')
                    m = h.battle.mem
                    m.write_bytes(('wBattleMon' if holder_side == 0 else 'wEnemyMon') + 'HP', [0, 1])
                    faint_context = (holder_side ^ 1,)
                    m.write('wDebugTurnTarget', 1)
                    m.write('wDebugControl', 1)
                    for _ in range(1800):
                        h.pb.button('a', 2)
                        h.tick(4)
                        if h.state() in (STATE_DONE, STATE_ERROR) or (h.state() == STATE_WAIT and h.battle.turns_done >= 1):
                            break
                    else:
                        raise RuntimeError('faint-update battle did not finish: ' + h.where())
                    expected_hp = 1 if ability == 'KLUTZ' else 1 + (20 if ability == 'RIPEN' or item == 'BERRY_JUICE' else 10)
                    expected_item = item if ability == 'KLUTZ' else 'NO_ITEM'
                    label = f'side={holder_side}, fainted={suppression}, holder={ability}/{item}'
                    check(faint_events == [(expected_hp, expected_item, 0, 0, 0)],
                          label + f': item and cleanup before faint animation {faint_events}')
                    check(h.state() != STATE_ERROR, label + ': no debug error')
                    check(not h.text_overflows, label + ': textbox bounds')
                    faint_cases += 1
    print(f'{faint_cases} faint-update battles; {checks} total checks, {failures} failures', flush=True)
    h.pb.stop(save=False)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
