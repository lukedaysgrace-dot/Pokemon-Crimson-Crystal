#!/usr/bin/env python3
"""Exercise roster rotation, shore visitors, judging identities and sprite allocation.

Uses an in-memory ROM; never opens the player's save.
"""
from pathlib import Path

from audit_trainer_sprites import sprite_metadata
from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT, dec
from test_fishing_contest import patch


def check_rom(h):
    root = Path(ROOT)
    sprites, _ = sprite_metadata()
    fields = _parse_constants(root / 'constants/map_object_constants.asm')
    roster = h.s('wFishingContestRoster')
    checks, failures = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)

    def load(number, status):
        h.wr(h.s('wMapGroup'), 1)
        h.wr(h.s('wMapNumber'), number)
        h.wr(h.s('wStatusFlags2'), status)
        h.call('LoadMapAttributes')

    def cast(first, count=5):
        base = h.s('wMap1Object') + (first - 1) * 16
        return [(h.rd(base + i * 16 + fields['MAPOBJECT_SPRITE']),
                 h.rd(base + i * 16 + fields['MAPOBJECT_COLOR']) >> 4)
                for i in range(count)]

    # Real hardware RNG: each entry gets two fishers and three unique guests.
    seen, identities = set(), set()
    for _ in range(120):
        h.call('ChooseFishingContestRoster')
        group = tuple(h.rd(roster, 5))
        seen.add(group)
        identities.update(group)
        check(len(set(group)) == 5 and all(0 <= n < 5 for n in group[:2])
              and all(5 <= n < 11 for n in group[2:]), f'Invalid lineup {group}')
    check(len(seen) > 20, f'Lineups do not rotate: {len(seen)} distinct groups')
    check(identities == set(range(11)), f'Some candidates never participate: {identities}')
    # Duplicate RNG values must still produce unique candidates without hanging.
    with patch(h, {'Random': b'\x3e\x00\xc9'}):
        h.call('GiveFishingContestBalls')
    check(h.rd(roster, 5) == bytes([0, 1, 5, 6, 7]), 'Repeated random values duplicated contestants')
    check(h.rd(h.s('wParkBallsRemaining')) == 20, 'Roster selection damaged contest balls')

    names = ['JUSTIN', 'RALPH', 'ARNOLD', 'KYLE', 'WILTON', 'SAMUEL',
             'NICK', 'GWEN', 'BARRY', 'CINDY', 'WILLIAM']
    candidate_sprites = ['FISHER'] * 5 + ['YOUNGSTER', 'COOLTRAINER_M',
                        'COOLTRAINER_F', 'CAMPER_NEW', 'PICNICKER_NEW', 'POKEFAN_M']
    palettes = [8, 9, 10, 11, 8, 9, 9, 8, 10, 10, 11]
    for candidate, name in enumerate(names):
        h.wr(roster, [candidate] * 5)
        for slot in range(5):
            h.wr(h.s('wStatusFlags2'), 32)
            h.call('LoadContestantName', a=slot + 2)
            text = dec(h.rd(h.s('wBugContestWinnerName'), 22)).split('@')[0]
            check(text.endswith(' ' + name), f'Slot {slot} announces wrong candidate: {text}')
        expected = [(sprites['SPRITE_' + candidate_sprites[candidate]], palettes[candidate])] * 5
        load(15, 36)
        h.call('FishingContestSetMapSprites')
        check(cast(4) == expected, f'Wrong shore appearance for {name}: {cast(4)}')
        load(16, 32)
        h.call('FishingContestSetMapSprites')
        check(cast(2) == expected, f'Wrong judging appearance for {name}: {cast(2)}')

    regular = ['LASS', 'COOLTRAINER_F', 'TEACHER', 'COOLTRAINER_M', 'LASS',
               'COOLTRAINER_F', 'TEACHER', 'COOLTRAINER_M']
    for day in range(7):
        load(15, 0)
        h.wr(h.s('wCurDay'), day)
        h.call('FishingContestSetMapSprites')
        h.call('RunMapCallback', a=2)
        h.call('LoadObjectMasks')
        check([s for s, _ in cast(4, 8)] == [sprites['SPRITE_' + n] for n in regular],
              f'Wrong regular visitor cast on day {day}')
        check(h.rd(h.s('wObjectMasks') + 4, 8) == bytes(8), f'Regular visitors hidden on day {day}')
    load(15, 36)
    h.wr(roster, [2, 4, 5, 8, 10])
    h.call('RunMapCallback', a=2)
    h.call('LoadObjectMasks')
    check(h.rd(h.s('wObjectMasks') + 4, 5) == bytes(5), 'Contestants hidden by object loading')
    check(h.rd(h.s('wObjectMasks') + 9, 3) == bytes([255] * 3), 'Regular visitors remain during contest')

    # Graphics must be allocated from the selected map sprites, including boats.
    # Cover every possible guest combination and both ambient and contest casts.
    from itertools import combinations
    for guests in [None] + list(combinations(range(5, 11), 3)):
        load(15, 36 if guests else 0)
        if guests:
            h.wr(roster, [1, 3, *guests])
        saved = h.rd(roster, 5)
        h.wr(h.s('wUsedSprites'), bytes(64))
        h.wr(h.s('wPlayerState'), 0)
        h.wr(h.s('wPlayerGender'), 0)
        h.call('GetPlayerSprite')
        h.call('AddMapSprites')
        first_cast = cast(4)
        h.call('LoadAndSortSprites')
        entries = h.rd(h.s('wUsedSprites'), 64)
        allocated = {entries[i]: entries[i + 1] for i in range(0, 64, 2) if entries[i]}
        needed = {s for s, _ in cast(4, 8)} | {sprites['SPRITE_FISHING_BOAT']}
        check(needed <= allocated.keys(), f'Sprite omitted from allocation for {guests}')
        check(all(allocated[s] == 0 or allocated[s] >= 7 for s in needed),
              f'Sprite lacks VRAM space for {guests}: {allocated}')
        h.call('FishingContestSetMapSprites')
        check(h.rd(roster, 5) == saved and cast(4) == first_cast,
              f'Reloading graphics rerolled the cast for {guests}')
        if guests:
            load(16, 32)
            h.wr(h.s('wFishingContestFlags'), 1)
            h.call('AddMapSprites')
            h.call('RunMapCallback', a=2)
            h.call('LoadObjectMasks')
            check(cast(2) == first_cast and h.rd(h.s('wObjectMasks') + 2, 5) == bytes(5),
                  f'Judging lineup differs from shore for {guests}')

    # Validate real map collision: each contestant is on land facing adjacent water.
    blocks = (root / 'maps/OlivineFishingCove.ablk').read_bytes()
    collisions = [line.split(';')[0].strip()[9:].replace(' ', '').split(',')
                  for line in (root / 'data/tilesets/johto_collision.asm').read_text().splitlines()
                  if line.strip().startswith('tilecoll')]

    def tile(x, y):
        return collisions[blocks[y // 2 * 20 + x // 2]][y % 2 * 2 + x % 2]

    load(15, 36)
    h.call('FishingContestSetMapSprites')
    directions = {
        fields['SPRITEMOVEDATA_STANDING_UP']: (0, -1),
        fields['SPRITEMOVEDATA_STANDING_DOWN']: (0, 1),
        fields['SPRITEMOVEDATA_STANDING_LEFT']: (-1, 0),
        fields['SPRITEMOVEDATA_STANDING_RIGHT']: (1, 0),
    }
    for i in range(5):
        obj = h.s('wMap4Object') + i * 16
        x = h.rd(obj + fields['MAPOBJECT_X_COORD']) - 4
        y = h.rd(obj + fields['MAPOBJECT_Y_COORD']) - 4
        movement = h.rd(obj + fields['MAPOBJECT_MOVEMENT'])
        dx, dy = directions[movement]
        check(tile(x, y) == 'FLOOR' and tile(x + dx, y + dy) == 'WATER'
              and h.rd(obj + fields['MAPOBJECT_RADIUS']) == 0,
              f'Contestant {i + 1} is not fishing from the shore at {x},{y}')
        # A talked-to NPC must resume facing the water, without moving.
        live = h.s('wObject1Struct')
        h.wr(live, bytes(40))
        h.wr(obj + fields['MAPOBJECT_OBJECT_STRUCT_ID'], 1)
        h.wr(live + fields['OBJECT_FACING'], 0xa0)
        h.wr(h.s('hLastTalked'), i + 4)
        with patch(h, {'UpdateSprites': b'\xc9'}):
            h.call('FishingContestFaceWater')
        expected = (movement - fields['SPRITEMOVEDATA_STANDING_DOWN']) * 4
        check(h.rd(live + fields['OBJECT_FACING']) == 0xa0 | expected,
              f'Contestant {i + 1} still faces the player after talking')
        check((h.rd(obj + fields['MAPOBJECT_X_COORD']) - 4,
               h.rd(obj + fields['MAPOBJECT_Y_COORD']) - 4) == (x, y),
              f'Contestant {i + 1} moved after talking')
    # Non-contest visitors retain their own movement and facing.
    h.wr(h.s('wStatusFlags2'), 0)
    h.wr(live + fields['OBJECT_FACING'], 8)
    h.call('FishingContestFaceWater')
    check(h.rd(live + fields['OBJECT_FACING']) == 8, 'Visitor was forced to face the water')

    load(16, 0)
    for i in range(5):
        obj = h.s('wMap2Object') + i * 16
        live = h.s('wObject1Struct') + i * 40
        h.wr(live, bytes(40))
        h.wr(obj + fields['MAPOBJECT_OBJECT_STRUCT_ID'], i + 1)
        h.wr(live + fields['OBJECT_MAP_OBJECT_INDEX'], i + 2)
        h.wr(live + fields['OBJECT_MOVEMENTTYPE'], fields['SPRITEMOVEDATA_STANDING_UP'])
    h.call('FishingContestRelaxParticipants')
    for i in range(5):
        expected = fields['SPRITEMOVEDATA_SPINRANDOM_SLOW'] if i % 2 == 0 else fields['SPRITEMOVEDATA_STANDING_UP']
        check(h.rd(h.s('wMap2Object') + i * 16 + fields['MAPOBJECT_MOVEMENT']) == expected
              and h.rd(h.s('wObject1Struct') + i * 40 + fields['OBJECT_MOVEMENTTYPE']) == expected,
              f'Participant {i + 1} did not get the correct post-judging movement')
    return checks, failures


if __name__ == '__main__':
    h = Harness()
    h.boot()
    try:
        checks, failures = check_rom(h)
        for failure in failures:
            print('FAIL:', failure)
        print(f'FISHING COVE PEOPLE: {checks} checks; {len(failures)} failures')
        raise SystemExit(bool(failures))
    finally:
        h.pyboy.stop(save=False)
