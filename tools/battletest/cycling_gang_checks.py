#!/usr/bin/env python3
"""Cycle into three native gang battles and collect Chopper's one-time vest.

Private New Game with a strong test party. Battle results, trainer approach,
graphics, inventory and reward flags use native routines and button input.
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
    fields = _parse_constants(ROOT / 'constants/map_object_constants.asm')
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    output = ROOT / '.tmpbuild/cycling-gang'
    output.mkdir(parents=True, exist_ok=True)
    vest = h.con.item_id('ASSAULT_VEST')
    received = 'EVENT_GOT_ASSAULT_VEST_FROM_CHOPPER'
    checks = 0
    portrait_saved = False

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
                   if m.read('wItems', i * 2) == vest)

    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),', line)
        if match:
            number += 1
            if match[1] == 'ROUTE_16':
                break

    def enter(x, y):
        m.write('wMapGroup', group)
        m.write('wMapNumber', number)
        m.write('wXCoord', x)
        m.write('wYCoord', y)
        m.write('hMapEntryMethod', 0xf1)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        check(controls.map_id() == (group, number), 'Route 16 map entry failed')

    def finish_dialogue():
        for _ in range(150):
            if not m.read('wScriptMode') and m.read('wMapStatus') == 2:
                return
            controls.press('a', hold=4, wait=24)
        raise AssertionError('Gang dialogue did not finish: ' + tile_text(h))

    def talk_to_chopper():
        controls.press('left', hold=4, wait=24)
        controls.press('a', hold=4, wait=24)
        finish_dialogue()

    def encounter(name, target, trainer_class, trainer_id, roster):
        nonlocal portrait_saved
        for _ in range(3):
            controls.press('down', hold=4, wait=36)
            if m.read('wScriptMode') or controls.position() == target:
                break
        check(controls.position() == target and bool(m.read('wScriptMode')),
              f'{name}: cycling in front did not trigger a sight battle')
        # Stop at the first native Fight menu to inspect the actual loaded party.
        for _ in range(180):
            text = tile_text(h)
            if name == 'CHOPPER' and not portrait_saved and 'CUEBALL' in text and 'CHOPPER' in text:
                h.tick(60)
                pb.screen.image.resize((480, 432)).save(output / 'chopper-intro.png')
                portrait_saved = True
            if 'FIGHT' in text and 'PACK' in text:
                break
            controls.press('a', hold=4, wait=24)
        else:
            raise AssertionError(f'{name}: native Fight menu did not appear: ' + tile_text(h))
        check(m.read('wOtherTrainerClass') == h.con.trainer_classes[trainer_class]
              and m.read('wOtherTrainerID') == trainer_id, f'{name}: wrong trainer loaded')
        check(m.read('wOTPartyCount') == len(roster), f'{name}: wrong team size')
        for slot, (species, level) in enumerate(roster, 1):
            check(m.species_index_of(m.read(f'wOTPartyMon{slot}Species')) == h.con.species_index(species)
                  and m.read(f'wOTPartyMon{slot}Level') == level,
                  f'{name}: wrong roster member in slot {slot}')
            check(0 not in m.read_bytes(f'wOTPartyMon{slot}Moves', 4),
                  f'{name}: missing move in slot {slot}')
        if name == 'CHOPPER':
            check(m.read('wOTPartyMon6Item') == vest
                  and m.read('wOTPartyMon6Personality') & 0x60 == 0x40,
                  'Chopper Machamp must have Assault Vest and No Guard')
        controls.battle()
        finish_dialogue()
        flag = 'EVENT_BEAT_CUEBALL_CHOPPER' if name == 'CHOPPER' else 'EVENT_BEAT_ROUTE16_BIKER_' + name
        check(event(flag), f'{name}: native win was not recorded')
        check(m.read('hDebugActive') == 0 and m.read('wBattleResult') & 15 == 0,
              f'{name}: battle was not a native victory')
        print(f'PASS native gang battle: {name}', flush=True)

    chopper = [('WEEZING', 64), ('ARBOK', 64), ('HOUNDOOM', 65),
               ('KROOKODILE', 65), ('MUK_ALOLAN', 66), ('MACHAMP', 67)]
    try:
        new_game(h, 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        request = Request(h.battle)
        address = h.sym.addr('wDebugPlayer1')
        for slot, species in enumerate(('MEW', 'MEWTWO', 'TOGEKISS')):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
                species=species, level=100, ability=h.con.species_abilities[species][0],
                item='EXPERT_BELT', moves=['PSYCHIC_M', 'AERIAL_ACE', 'FLAMETHROWER', 'AURA_SPHERE'])))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode'):
            m.write(name, 0)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wOptions', 0xc1)
        controls = Controls(h)
        enter(7, 15)
        check({(obj['map_object'], tuple(obj['position'])) for obj in controls.objects()}
              >= {(1, (6, 12)), (2, (9, 14)), (3, (6, 17))},
              'Gang did not load at the requested coordinates')
        check(next(obj for obj in controls.objects() if obj['map_object'] == 3)['sprite']
              == sprites['SPRITE_CUEBALL'], 'Chopper is not using the Cueball overworld sprite')
        for obj, direction in ((1, 'RIGHT'), (2, 'LEFT'), (3, 'RIGHT')):
            check(m.read(f'wMap{obj}Object', fields['MAPOBJECT_MOVEMENT'])
                  == fields['SPRITEMOVEDATA_STANDING_' + direction], f'Wrong facing for gang member {obj}')
        pb.screen.image.resize((480, 432)).save(output / 'gang-before.png')

        for name, start, target, trainer_id, roster in (
                ('AXLE', (8, 11), (8, 12), 8,
                 [('WEEZING', 60), ('HOUNDOOM', 61), ('CROBAT', 61), ('GOLEM_ALOLAN', 62)]),
                ('RUSTY', (7, 13), (7, 14), 9,
                 [('ARBOK', 60), ('MAGMORTAR', 61), ('MUK', 61), ('SCRAFTY', 62)])):
            call(h, 'HealParty')
            enter(*start)
            encounter(name, target, 'BIKER', trainer_id, roster)
            check(not event(received) and quantity() == 0, 'Regular biker gives boss reward')

        call(h, 'HealParty')
        enter(8, 16)
        prepared = io.BytesIO()
        pb.save_state(prepared)
        encounter('CHOPPER', (8, 17), 'CUEBALL', 1, chopper)
        check(event(received) and quantity() == 1, 'Chopper victory did not award exactly one vest')
        talk_to_chopper()
        check(quantity() == 1, 'Chopper repeats his reward')

        prepared.seek(0)
        pb.load_state(prepared)
        bank, address = h.sym['ItemAttributes']
        # Keep the generic menu driver out of its optional potion-selection path.
        excluded = {vest} | {h.con.item_id(name) for name in
                            ('POTION', 'SUPER_POTION', 'HYPER_POTION', 'MAX_POTION', 'FULL_RESTORE')}
        stock = [item for item in range(1, 194) if item not in excluded
                 and pb.memory[bank, address + (item - 1) * 7 + 5] == 1][:40]
        check(len(stock) == 40, 'Could not prepare a full legal item pocket')
        m.write('wNumItems', 40)
        m.write_bytes('wItems', bytes(v for item in stock for v in (item, 1)) + b'\xff')
        encounter('CHOPPER', (8, 17), 'CUEBALL', 1, chopper)
        check(not event(received) and quantity() == 0, 'Full Bag consumes Chopper reward')
        m.write('wNumItems', 0)
        m.write_bytes('wItems', b'\xff')
        talk_to_chopper()
        check(event(received) and quantity() == 1, 'Cannot claim vest after making room')
        enter(7, 16)
        controls.press('down', hold=4, wait=36)
        check(not m.read('wBattleMode') and not m.read('wScriptMode'), 'Defeated Chopper challenges on reload')
        check([flags[n] for n in ('EVENT_BEAT_ROUTE16_BIKER_AXLE', 'EVENT_BEAT_ROUTE16_BIKER_RUSTY',
                                 'EVENT_BEAT_CUEBALL_CHOPPER', received)] == list(range(0x196, 0x19a)),
              'Gang flags did not reuse unused event bits')
        for name, expected in {'wEventFlags': 0xdab0, 'wCurBox': 0xdbb9,
                               'wGameDataEnd': 0xdff3, 'sSaveDataEnd': 0xac36}.items():
            check(h.sym.addr(name) == expected, f'Save layout shifted: {name}')
        check(portrait_saved, 'Cueball Chopper battle introduction was not displayed')
        print(f'CYCLING GANG: {checks} checks passed; four native battles won', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
