#!/usr/bin/env python3
"""Native Celadon chase, item pickup, officer battle and optional full video.

Starts a private New Game with a staged test party; ordinary buttons execute
both trigger lanes, the shove, item receipt, battle and officer departure.
"""
import argparse
import io
import sys
from pathlib import Path

import cerulean_cave_checks as video
from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from state import Request
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--record', action='store_true')
    args = parser.parse_args()
    if args.record:
        sys.path.insert(0, str(ROOT / '.tmpbuild/video-runtime'))
    output = ROOT / '_ai_artifacts/celadon-choice-specs'
    output.mkdir(parents=True, exist_ok=True)
    video.OUTPUT = output
    h = Harness(sound_emulated=args.record,
                emulator_kwargs={'sound_sample_rate': 48000} if args.record else None)
    pb, m = h.pb, h.battle.mem
    c = Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    music = _parse_constants(ROOT / 'constants/music_constants.asm')
    active = [None]
    original_tick = h.tick
    texts = []
    officer_spawns = []
    checks = 0

    def check(ok, message):
        nonlocal checks
        assert ok, message
        checks += 1

    def tick(frames):
        if not active[0]:
            return original_tick(frames)
        for _ in range(frames):
            pb.tick(1, True, True)
            active[0].frame()

    h.tick = tick
    original_press = c.press

    def press(button, hold=12, wait=36):
        if active[0] and button == 'a' and m.read('wScriptMode') and not m.read('wBattleMode'):
            wait = max(wait, 110)
        original_press(button, hold=hold, wait=wait)

    c.press = press

    def event(name, value=None):
        flag = flags[name]
        if value is None:
            return bool(m.read('wEventFlags', flag // 8) & (1 << (flag % 8)))
        call(h, 'EventFlagAction', B=int(value), D=flag >> 8, E=flag & 255)

    def quantity():
        item = h.con.item_id('CHOICE_SPECS')
        return sum(m.read('wItems', i * 2 + 1) for i in range(m.read('wNumItems'))
                   if m.read('wItems', i * 2) == item)

    def obj(index):
        return next((o for o in c.objects() if o['map_object'] == index), None)

    def enter(x, y):
        group, number = map_ids()['CELADON_CITY']
        for name, value in [('wMapGroup', group), ('wMapNumber', number),
                            ('wXCoord', x), ('wYCoord', y), ('hMapEntryMethod', 0xf1)]:
            m.write(name, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(c.map_id() == (group, number), 'Celadon entry failed')

    def dialogue():
        for _ in range(280):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
            c.press('a', hold=4, wait=24)
        raise AssertionError('Script did not finish: ' + tile_text(h))

    def until_battle():
        for _ in range(280):
            if m.read('wBattleMode') and 'FIGHT' in tile_text(h):
                return
            c.press('a', hold=4, wait=24)
        pb.screen.image.resize((640,576)).save(output / 'battle-start-failure.png')
        raise AssertionError('Officer battle did not start: ' + str((c.position(), c.objects(),
            m.read('wScriptMode'),m.read('wMapStatus'),m.read('wBattleMode'),
            pb.register_file.PC, {n: list(m.read_bytes(n, 2)) for n in
                ('wScriptPos','wScriptBank','wPartyCount','wBattleResult','wOtherTrainerClass','wOtherTrainerID')},
            [name for name in ('CeladonBurglarShoveText','CeladonBurglarDroppedText',
             'CeladonOfficerAccusationText','CeladonOfficerApologyText') if h.sym[name] in texts])) + ' ' + tile_text(h))

    def track_text(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        ptr = pb.memory[bank, address] | pb.memory[bank, address + 1] << 8
        texts.append((bank, ptr))
        if (bank, ptr) == h.sym['CeladonOfficerAccusationText']:
            check(int.from_bytes(m.read_bytes('wMusicID', 2), 'little') == music['MUSIC_OFFICER_ENCOUNTER'],
                  'Officer nighttime encounter music is not playing at his first line')

    def track_appear(_):
        bank = m.read('wScriptBank')
        address = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        if pb.memory[bank,address] == 13:
            officer_spawns.append((m.read('wMap12Object',3)-4, m.read('wMap12Object',2)-4))

    def fullbag():
        bank, address = h.sym['ItemAttributes']
        excluded = {h.con.item_id(n) for n in ('CHOICE_SPECS', 'POTION', 'SUPER_POTION',
                    'HYPER_POTION', 'MAX_POTION', 'FULL_RESTORE')}
        stock = [i for i in range(1,194) if i not in excluded
                 and pb.memory[bank, address + (i-1)*7 + 5] == 1][:40]
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for i in stock for v in (i,1)) + b'\xff')

    try:
        new_game(h, 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        req = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        for slot, species in enumerate(('MEW', 'MEWTWO', 'TOGEKISS')):
            m.write_bytes('wDebugPlayer1', req._side_bytes(dict(
                species=species, level=90, ability=h.con.species_abilities[species][0],
                item='EXPERT_BELT', moves=['PSYCHIC_M','THUNDERBOLT','FLAMETHROWER','AURA_SPHERE'])))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        for name in ('wDebugState','hDebugActive','hDebugRNGMode','wLinkMode'):
            m.write(name, 0)
        m.write('wOptions', 0xc1)
        m.write('wDefaultSpawnpoint', 255)
        event('EVENT_CLEARED_RADIO_TOWER', True)
        prepared = io.BytesIO()
        pb.save_state(prepared)
        pb.hook_register(*h.sym['Script_writetext'], track_text, None)
        pb.hook_register(*h.sym['Script_appear'], track_appear, None)

        for lane, side in ((10,'vertical'), (11,'west'), (11,'east')):
            prepared.seek(0)
            pb.load_state(prepared)
            texts.clear()
            officer_spawns.clear()
            enter(33,lane)
            check(not obj(10) and not obj(11) and not obj(12), 'Scene objects visible before chase: ' + str(c.objects()))
            if args.record and lane == 10:
                active[0] = video.Recording(h, 'celadon-choice-specs')
                h.tick(90)
            c.press('right', hold=12, wait=36)
            dialogue()
            check(event('EVENT_CELADON_SPECS_BURGLAR_FLED'), 'Trigger did not start chase')
            check(c.position() == (34, 21-lane), 'Player was not shoved into the other lane')
            check(m.read('wObjectStructs',8) == (4 if lane == 10 else 0),
                  'Player does not face up after being shoved down, or down after being shoved up')
            check(obj(10) is None and obj(11) is not None and obj(11)['position'] == [34,lane],
                  'Burglar did not leave the ball on the correct tile')
            check(obj(12) is None and quantity() == 0, 'Officer or reward appeared too soon')
            check(all(h.sym[name] in texts for name in ('CeladonBurglarShoveText','CeladonBurglarDroppedText')),
                  'Missing burglar dialogue')
            pb.screen.image.resize((640,576)).save(output / f'dropped-lane-{lane}.png')
            if lane == 11:
                enter(35,lane)
                check(obj(11) is not None and obj(11)['position'] == [34,11], 'Re-entry moved/lost lower ball')
                if side == 'west':
                    c.go((33,lane))
                fullbag()
                direction = 'right' if side == 'west' else 'left'
                c.press(direction, hold=4, wait=24)
                c.press('a', hold=4, wait=24)
                dialogue()
                check(not quantity() and not event('EVENT_GOT_CELADON_CHOICE_SPECS')
                      and obj(11) is not None and obj(12) is None, 'Full Bag consumes ball or starts confrontation')
                m.write('wNumItems',0)
                m.write_bytes('wItems',b'\xff')
            else:
                direction = 'up'
            c.press(direction, hold=4, wait=24)
            c.press('a', hold=4, wait=24)
            until_battle()
            check(officer_spawns == [(40,lane)], 'Officer did not enter from beyond the right edge: ' + str(officer_spawns))
            check(quantity() == 1 and event('EVENT_GOT_CELADON_CHOICE_SPECS'), 'Specs pickup failed')
            check(h.sym['CeladonOfficerAccusationText'] in texts, 'Missing officer confrontation')
            check(m.read('wOtherTrainerClass') == h.con.trainer_classes['OFFICER']
                  and m.read('wOtherTrainerID') == 3, 'Wrong trainer')
            check(m.read('wOTPartyCount') == 4, 'Officer does not have four Pokemon')
            for slot,(species,level) in enumerate((('ARCANINE',66),('GRANBULL',66),('NOCTOWL',67),('LUCARIO',68)),1):
                check(m.species_index_of(m.read(f'wOTPartyMon{slot}Species')) == h.con.species_index(species)
                      and m.read(f'wOTPartyMon{slot}Level') == level, 'Incorrect officer roster')
            pb.screen.image.resize((640,576)).save(output / 'officer-battle.png')
            c.battle()
            dialogue()
            check(event('EVENT_BEAT_CELADON_OFFICER') and m.read('wBattleResult') & 15 == 0,
                  'Officer victory was not recorded')
            check(h.sym['CeladonOfficerApologyText'] in texts, 'Missing apology')
            check(obj(10) is None and obj(11) is None and obj(12) is None and quantity() == 1,
                  'Scene objects remain after conclusion or reward was duplicated')
            if active[0]:
                h.tick(120)
                recording, active[0] = active[0], None
                recording.finish()
            enter(33,lane)
            c.press('right',hold=12,wait=36)
            check(not m.read('wScriptMode') and obj(10) is None and obj(11) is None and obj(12) is None
                  and quantity() == 1, 'Completed event repeats after re-entry')
            print(f'PASS Celadon lane {lane}, pickup {side}', flush=True)
        reset_flags = ('EVENT_CELADON_SPECS_BURGLAR_FLED', 'EVENT_CELADON_SPECS_DROPPED_LOWER',
                       'EVENT_GOT_CELADON_CHOICE_SPECS', 'EVENT_BEAT_CELADON_OFFICER')

        # Older saves awaiting a rematch reset once, preserving older copies.
        for older_copies in (0,2):
            prepared.seek(0)
            pb.load_state(prepared)
            for name in reset_flags[:3]:
                event(name, True)
            m.write('wNumItems', 1)
            m.write_bytes('wItems', [h.con.item_id('CHOICE_SPECS'), older_copies+1, 255])
            enter(33,11)
            check(obj(10) is None and obj(11) is None and obj(12) is None and quantity() == older_copies,
                  'Old rematch save did not remove only the encounter pickup and hide the officer')
            check(not any(event(n) for n in reset_flags), 'Old rematch save did not reset the entire event')
            enter(33,10)
            check(quantity() == older_copies, 'Re-entering removes an unrelated earlier copy')

        # Lose real battles from both lanes, white out normally, then walk
        # back into the opposite trigger lane to replay the whole chase.
        for lane,older_copies in ((10,0),(11,2)):
            prepared.seek(0)
            pb.load_state(prepared)
            m.write('wPartyCount',0)
            m.write('wMonType',0)
            m.write_bytes('wDebugPlayer1', req._side_bytes(dict(
                species='MAGIKARP', level=5, ability='SWIFT_SWIM', item='NO_ITEM', moves=['SPLASH'])))
            call(h,'DebugBuildPartyMon',B=0,D=address >> 8,E=address & 255)
            for name in ('wDebugState','hDebugActive','hDebugRNGMode','wLinkMode'):
                m.write(name,0)
            group,number = map_ids()['CELADON_CITY']
            m.write('wLastSpawnMapGroup',group)
            m.write('wLastSpawnMapNumber',number)
            m.write_bytes('wMoney',(10000).to_bytes(3,'big'))
            m.write('wNumItems',int(bool(older_copies)))
            m.write_bytes('wItems', [h.con.item_id('CHOICE_SPECS'),older_copies,255] if older_copies else [255])
            texts.clear()
            enter(33,lane)
            c.press('right',hold=12,wait=36)
            dialogue()
            c.press('up' if lane == 10 else 'down',hold=4,wait=24)
            c.press('a',hold=4,wait=24)
            until_battle()
            check(quantity() == older_copies+1, 'Loss test did not collect its event reward')
            c.battle()
            dialogue()
            check(m.read('wBattleResult') & 15 == 1 and not m.read('hDebugActive'), 'Expected a real officer loss')
            check(not any(event(n) for n in reset_flags), 'Officer loss left the encounter partially completed')
            check(quantity() == older_copies, 'Officer loss did not remove exactly the event reward')
            check(c.map_id() == (group,number) and c.position() == (29,10), 'Normal whiteout return was changed')
            check(obj(10) is None and obj(11) is None and obj(12) is None, 'Scene objects remain after defeat')
            retry_lane = 21-lane
            c.go((33,retry_lane))
            texts.clear()
            c.press('right',hold=12,wait=36)
            dialogue()
            check(all(h.sym[n] in texts for n in ('CeladonBurglarShoveText','CeladonBurglarDroppedText')),
                  'Burglar scene does not replay after losing')
            check(obj(11) is not None and obj(11)['position'] == [34,retry_lane] and obj(12) is None,
                  'Restarted encounter did not drop its ball in the new lane')
            check(quantity() == older_copies and not event('EVENT_GOT_CELADON_CHOICE_SPECS'),
                  'Restarted chase awards Specs before pickup')
            print(f'PASS native officer loss in lane {lane}, full restart in lane {retry_lane}',flush=True)
        check(h.sym.addr('wCurBox') == 0xdbb9, 'Save layout shifted')
        print(f'CELADON SPECS: {checks} checks passed', flush=True)
    finally:
        if active[0]:
            active[0].process.stdin.close()
            active[0].process.wait()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
