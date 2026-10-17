#!/usr/bin/env python3
"""Win Archer's native Radio Tower finale, then loot his Weakness Policy.

Private New Game with staged story prerequisites and a strong test party.
Battle, director dialogue/movement, object reveal and pickup run unmodified.
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
    engine = _parse_constants(ROOT / 'constants/engine_flags.asm')
    policy = h.con.item_id('WEAK_POLICY')
    collected = 'EVENT_RADIO_TOWER_5F_WEAK_POLICY'
    output = ROOT / '.tmpbuild/archer-policy'
    output.mkdir(parents=True, exist_ok=True)
    checks = 0
    reveals = []
    battles = []
    fade_ins = []
    director_entries = []
    archer_finished_speaking = False
    blackout_started = False
    director_walk_started = False
    director_described_bell = False

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
                   if m.read('wItems', i * 2) == policy)

    def obj(index):
        return next((o for o in controls.objects() if o['map_object'] == index), None)

    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),', line)
        if match:
            number += 1
            if match[1] == 'RADIO_TOWER_5F':
                break

    def enter(x=14, y=5):
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', x)
        m.write('wYCoord', y)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(controls.map_id() == (group, number), 'Radio Tower 5F entry failed')

    def finish_dialogue():
        for _ in range(240):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
            controls.press('a', hold=4, wait=32)
        raise AssertionError('Radio Tower finale/pickup dialogue did not finish')

    def loot():
        controls.press('left', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        finish_dialogue()

    def text(_):
        nonlocal director_described_bell, archer_finished_speaking
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        pointer = pb.memory[bank, address] | pb.memory[bank, address + 1] << 8
        if (bank, pointer) == h.sym['RadioTower5FDirectorDescribeClearBellText']:
            director_described_bell = True
        if (bank, pointer) == h.sym['RadioTower5FRocketBossAfterText']:
            archer_finished_speaking = True

    def appear(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        if pb.memory[bank, address] == 7:  # Script object IDs include the player offset.
            reveals.append(dict(director_spoke=director_described_bell,
                                director_walked_in=director_walk_started,
                                archer_gone=obj(2) is None,
                                black=blackout_started and not any(m.read_bytes('wBGPals2', 128)),
                                cleared=event('EVENT_CLEARED_RADIO_TOWER'),
                                bell=event('EVENT_GOT_CLEAR_BELL')))

    def blackout(_):
        nonlocal blackout_started
        if archer_finished_speaking:
            blackout_started = True

    def fade_in(_):
        if blackout_started and not director_walk_started:
            fade_ins.append(obj(6) is not None and obj(6)['position'] == [13, 5])

    def movement(_):
        nonlocal director_walk_started
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        pointer = pb.memory[bank, address + 1] | pb.memory[bank, address + 2] << 8
        if (bank, pointer) == h.sym['RadioTower5FDirectorWalksIn']:
            director_walk_started = True
            director_entries.append(obj(6) is not None and obj(6)['position'] == [13, 5])
            pb.screen.image.resize((480, 432)).save(output / 'before-director.png')

    def battle(_):
        battles.append((m.read('wOtherTrainerClass'), m.read('wOtherTrainerID')))

    try:
        new_game(h, 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        request = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        for slot, species in enumerate(('MEW', 'MEWTWO', 'TOGEKISS')):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
                species=species, level=100, ability=h.con.species_abilities[species][0],
                moves=['PSYCHIC_M', 'AERIAL_ACE', 'FLAMETHROWER', 'AURA_SPHERE'])))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        for name, value in (('EVENT_CLEARED_RADIO_TOWER', False), ('EVENT_GOT_CLEAR_BELL', False),
                            ('EVENT_TEAM_ROCKET_DISBANDED', False),
                            ('EVENT_RADIO_TOWER_ROCKET_TAKEOVER', False),
                            ('EVENT_RADIO_TOWER_CIVILIANS_AFTER', True)):
            event(name, value)
        flag = engine['ENGINE_ROCKETS_IN_RADIO_TOWER']
        call(h, 'EngineFlagAction', B=1, D=flag >> 8, E=flag & 255)
        m.write('wRadioTower5FSceneID', 1)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 0xc1)
        controls = Controls(h)
        enter(16, 6)
        check(obj(6) is None and obj(2) is not None and not quantity(),
              'Reward is visible before Archer defeat')
        enter(16, 6)
        check(obj(6) is None, 'Re-entering the occupied tower reveals the reward early')
        hooks = (('Script_writetext', text), ('Script_appear', appear), ('StartBattle', battle),
                 ('FadeBlackQuickly', blackout), ('FadeInQuickly', fade_in),
                 ('Script_applymovement', movement))
        for symbol, callback in hooks:
            pb.hook_register(*h.sym[symbol], callback, None)
        try:
            for _ in range(3):
                controls.press('up', hold=4, wait=36)
                if m.read('wScriptMode'):
                    break
            check(bool(m.read('wScriptMode')), 'Archer coordinate encounter did not start')
            controls.battle()
            finish_dialogue()
        finally:
            for symbol, _ in hooks:
                pb.hook_deregister(*h.sym[symbol])
        check(battles == [(h.con.trainer_classes['ARCHER'], 2)]
              and m.read('wBattleResult') & 15 == 0,
              'Archer finale did not finish in a native win')
        check(reveals == [dict(director_spoke=False, director_walked_in=False, archer_gone=True,
                              black=True, cleared=False, bell=False)],
              f'Reward reveal {reveals}; director dialogue={director_described_bell}; '
              f'scene={m.read("wRadioTower5FSceneID")}, script={m.read("wScriptMode")}, '
              f'cleared={event("EVENT_CLEARED_RADIO_TOWER")}, '
              f'bell={event("EVENT_GOT_CLEAR_BELL")}; {tile_text(h)}')
        check(fade_ins == [True], f'Ball visibility at fade-in: {fade_ins}; director entries: {director_entries}')
        check(director_entries == [True] and director_described_bell,
              'Ball was not already visible before the director walked in and spoke')
        check(event('EVENT_TEAM_ROCKET_DISBANDED') and m.read('wRadioTower5FSceneID') == 2,
              'Finale did not preserve normal story progression')
        check(obj(6) is not None and obj(6)['position'] == [13, 5]
              and not event(collected), 'Item ball missing from Archer former tile')
        pb.screen.image.resize((480, 432)).save(output / 'after-director.png')
        prepared = io.BytesIO()
        pb.save_state(prepared)

        bank, address = h.sym['ItemAttributes']
        stock = [item for item in range(1, 194) if item != policy
                 and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
        loot()
        check(obj(6) is not None and not event(collected) and quantity() == 0,
              'Full Bag consumes the item ball')
        prepared.seek(0)
        pb.load_state(prepared)
        loot()
        check(quantity() == 1 and event(collected) and obj(6) is None,
              'Native pickup did not give one Weakness Policy and remove the ball')
        enter()
        check(obj(6) is None and quantity() == 1, 'Collected reward respawns on re-entry')
        check(obj(4) is not None and obj(4)['position'] == [13, 6]
              and controls.passable(controls.collision(13, 6)),
              'Ben overlaps the reward tile or was moved onto a wall')
        # An existing completed save has the new unused bit clear.
        prepared.seek(0)
        pb.load_state(prepared)
        enter()
        check(obj(6) is not None and obj(6)['position'] == [13, 5],
              'Completed saves cannot collect the newly added reward')
        check(flags[collected] == 0x19a, 'Reward did not reuse the unused event bit')
        for name, expected in {'wEventFlags': 0xdab0, 'wCurBox': 0xdbb9,
                               'wGameDataEnd': 0xdff3, 'sSaveDataEnd': 0xac36}.items():
            check(h.sym.addr(name) == expected, f'Save layout shifted: {name}')
        print(f'ARCHER POLICY: {checks} checks passed; native Archer finale and pickup completed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
