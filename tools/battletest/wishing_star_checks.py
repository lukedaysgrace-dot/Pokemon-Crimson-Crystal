#!/usr/bin/env python3
"""Native dance, Moon Stone pickup, persistent crater, and wishing-well quest.

Only private New Game clock, party, and inventory fixtures are staged.
Buttons run the event scripts, Rock Smash, pickups, and battle endings.
"""
import io
import json

from runner import Harness
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from probability_checks import call
from overworld_controls import Controls
from safari_ui_checks import map_ids
from symbols import ROOT, _parse_constants
from state import Request
from ui_checks import tile_text


def main():
    output = ROOT / '_artifacts/wishing-star'
    output.mkdir(parents=True, exist_ok=True)
    h = Harness()
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    maps = map_ids()
    flags = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
    items = _parse_constants(ROOT / 'constants/item_constants.asm')
    sfx = _parse_constants(ROOT / 'constants/sfx_constants.asm')
    checks, star_positions, rise_offsets, texts, cries, sounds = [], [], [], [], [], []
    rise_oam_positions = set()
    circle_frames, well_sequence, circle_screen_positions = [], [], set()
    dialogue_visible = []
    star_priority, star_map_oam = [], []

    def check(ok, message):
        if not ok:
            pb.screen.image.save(output / 'failure.png')
            raise AssertionError(message + '\n' + tile_text(h) + '\n' + str(c.objects()))
        checks.append(message)
        print('PASS', message, flush=True)

    def event(name, value=None):
        index = flags[name]
        address, mask = h.sym.addr('wEventFlags') + index // 8, 1 << (index % 8)
        if value is not None:
            pb.memory[address] = pb.memory[address] | mask if value else pb.memory[address] & ~mask
        return bool(pb.memory[address] & mask)

    def keys(*names):
        m.write('wNumKeyItems', len(names))
        m.write_bytes('wKeyItems', [items[name] for name in names] + [255])

    def has_key(name):
        return items[name] in m.read_bytes('wKeyItems', m.read('wNumKeyItems'))

    def snapshot():
        buf = io.BytesIO()
        pb.save_state(buf)
        return buf.getvalue()

    def restore(data):
        pb.load_state(io.BytesIO(data))
        h.text_overflows.clear()
        h.battle.textbox_contexts.clear()
        texts.clear()

    def until(predicate, limit=12000, advance=False):
        for frame in range(0, limit, 4):
            if predicate():
                return
            if advance and frame % 24 == 0:
                pb.button('a', 2)
            h.tick(4)
        raise RuntimeError('Timeout: ' + tile_text(h) + '\n' + str((c.map_id(), c.position(),
            m.read('wScriptMode'), m.read('wBattleMode'), m.read('wMapStatus'), pb.register_file.PC)))

    def idle():
        return not m.read('wBattleMode') and not m.read('wScriptMode') and m.read('wMapStatus') == 2

    def enter(map_name, xy):
        for name, value in (('wMapGroup', maps[map_name][0]), ('wMapNumber', maps[map_name][1]),
                            ('wXCoord', xy[0]), ('wYCoord', xy[1]), ('hMapEntryMethod', 0xf1)):
            m.write(name, value)
        begin_native_call(h, 'OverworldLoop')
        h.tick(180)
        until(idle)

    def block(x, y):
        return m.read('wOverworldMapBlocks', (y // 2 + 3) * (m.read('wMapWidth') + 6) + x // 2 + 3)

    def hook(label, callback):
        bank, address = h.sym[label]
        pb.hook_register(bank, address, callback, None)

    def star(_):
        star_positions.append((pb.register_file.B, pb.register_file.C))
        star_map_oam[:] = m.read_bytes('wVirtualOAM', 128)
        if pb.register_file.D == 34:
            pb.screen.image.resize((640, 576)).save(output / 'shooting-star-midflight.png')

    def star_ready(_):
        oam = m.read_bytes('wVirtualOAM', 160)
        star_priority.append(oam[2:16:4] == bytes([0xfc, 0xfd, 0xfe, 0xff])
                             and set(oam[18:32:4]) <= {0xfa, 0xfb}
                             and all(not attr & 0x80 for attr in oam[3:32:4])
                             and oam[32:] == bytes(star_map_oam))

    def rise(_):
        address = pb.register_file.B * 256 + pb.register_file.C
        rise_offsets.append(pb.memory[address + 0x1a])
        encoded_tile = pb.memory[address + 2]
        tile = encoded_tile & 127
        bank = 0 if encoded_tile & 128 else 8
        oam = list(m.read_bytes('wVirtualOAM', 160))
        for index in range(0, 160, 4):
            y, x, graphic, attr = oam[index:index + 4]
            if y and tile <= graphic < tile + 4 and attr & 8 == bank:
                rise_oam_positions.add((x, y))
        if rise_offsets[-1] == 248:
            pb.screen.image.resize((640, 576)).save(output / 'jirachi-rising.png')
            (output / 'rise-object.json').write_text(json.dumps(dict(objects=c.objects(),
                raw=list(pb.memory[address:address + 40]), oam=list(m.read_bytes('wVirtualOAM', 160))), indent=2))

    def text(_):
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        pointer = pb.memory[bank, pos] | pb.memory[bank, pos + 1] << 8
        texts.append((bank, pointer))
        if (bank, pointer) == h.sym['EcruteakCityJirachiText']:
            well_sequence.append('dialogue')
            obj = next(o for o in c.objects() if o['map_object'] == 10)
            raw = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)
            (output / 'jirachi-dialogue-object.json').write_text(json.dumps(dict(raw=list(raw),
                tilemap=list(m.read_bytes('wTileMap', 360)), x=m.read('wXCoord'), y=m.read('wYCoord'),
                bgx=m.read('wPlayerBGMapOffsetX'), bgy=m.read('wPlayerBGMapOffsetY')), indent=2))
            check(raw[0x19:0x1b] == bytes([0, 240]), 'Jirachi returns to its spawn position before speaking')
            check(raw[0x0d] != 255, 'Jirachi remains visible after facing the player before its dialogue')
            check(raw[6] & 7 == 1, 'Well Jirachi uses the blue overworld palette')
            pb.screen.image.resize((640, 576)).save(output / 'jirachi-before-dialogue.png')

    def circle(_):
        address = pb.register_file.B * 256 + pb.register_file.C
        raw = bytes(pb.memory[address:address + 40])
        phase = pb.register_file.E
        circle_frames.append((phase, raw[0x19], raw[0x1a], raw[0x0d]))
        if phase == 0:
            well_sequence.append('circles')
        tile, bank = raw[2] & 127, 0 if raw[2] & 128 else 8
        oam = list(m.read_bytes('wVirtualOAM', 160))
        for index in range(0, 160, 4):
            y, x, graphic, attr = oam[index:index + 4]
            if y and attr & 8 == bank and (tile <= graphic < tile + 12 or tile + 128 <= graphic < tile + 140):
                circle_screen_positions.add((x, y))
        if phase in (16, 32, 48):
            pb.screen.image.resize((640, 576)).save(output / f'jirachi-circle-{phase}.png')

    hook('MtMoonOverworldWishingStar.DrawStar', star)
    hook('MtMoonOverworldWishingStar.SpritesReady', star_ready)
    hook('EcruteakWellJirachiRise.Rise', rise)
    hook('EcruteakWellJirachiCircle.CircleFrame', circle)
    hook('EcruteakWellJirachiCircle.CirclesDone', lambda _: well_sequence.append('circles_done'))
    hook('Script_startbattle', lambda _: well_sequence.append('battle'))
    hook('Script_writetext', text)
    def dialogue_wait(_):
        if dialogue_visible or not texts or texts[-1] != h.sym['EcruteakCityJirachiText']:
            return
        obj = next(o for o in c.objects() if o['map_object'] == 10)
        raw = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)
        tile, bank = raw[2] & 127, 0 if raw[2] & 128 else 8
        oam = list(m.read_bytes('wVirtualOAM', 160))
        visible = any(8 <= x <= 160 and 16 <= y <= 152 and attr & 8 == bank
                      and (tile <= graphic < tile + 12 or tile + 128 <= graphic < tile + 140)
                      for y, x, graphic, attr in zip(oam[::4], oam[1::4], oam[2::4], oam[3::4]))
        check(visible, 'Jirachi stays rendered while CHI dialogue waits before battle')
        dialogue_visible.append(True)
        pb.screen.image.resize((640, 576)).save(output / 'jirachi-chi-dialogue.png')
    hook('JoyWaitAorB', dialogue_wait)
    def cry(_):
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        species = pb.memory[bank, pos] | pb.memory[bank, pos + 1] << 8
        cries.append(species)
        if species == h.con.species_index('JIRACHI'):
            well_sequence.append('cry')
    hook('Script_cry', cry)
    hook('PlaySFX', lambda _: sounds.append(pb.register_file.D * 256 + pb.register_file.E))

    def dance_and_smash():
        enter('MOUNT_MOON_SQUARE', (7, 12))
        check(not any(o['map_object'] == 4 for o in c.objects()), 'No fossil exists before the crash')
        c.press('up', hold=4, wait=36)
        if c.position() == (7, 12):
            c.press('up', hold=4, wait=36)
        until(idle, advance=True)
        check(c.position() == (7, 10), 'Original Clefairy dance advances the player to (7,10)')
        check(not event('EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE'), 'Dance reveals the original Moon Stone')
        c.go((7, 8))
        c.press('up', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)
        check(not any(o['map_object'] == 3 for o in c.objects()), 'Native Rock Smash clears the Moon Stone rock')

    def loot_stone():
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)

    try:
        new_game(h, 0)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        address = h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', Request(h.battle)._side_bytes(dict(species='MEW', level=100,
                        moves=['AERIAL_ACE', 'ROCK_SMASH', 'SPLASH'])))
        call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wStatusFlags2'):
            m.write(name, 0)
        m.write_bytes('wStringBuffer2', [1, 22, 0, 0])
        call(h, '_InitTime')
        call(h, 'UpdateTime')
        m.write('wOptions', 0x41)
        m.write('wRepelEffect', 255)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wNumItems', 0)
        m.write_bytes('wItems', [255])
        m.write('wNumBalls', 1)
        m.write_bytes('wBalls', [items['MASTER_BALL'], 5, 255])
        m.write('wCurItem', items['WISHING_STAR'])
        call(h, 'CheckItemPocket')
        check(m.read('wItemAttributeParamBuffer') == 2, 'WISHING STAR uses the Key Item pocket')
        keys()
        base = snapshot()
        check(m.read('wCurDay') == 1 and m.read('hHours') == 22, 'Monday-night clock fixture')

        dance_and_smash()
        loot_stone()
        check(event('EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE') and not event('EVENT_MT_MOON_WISHING_STAR_CRASHED'),
              'Without STAR PIECE, the Moon Stone pickup and dance stay normal')
        check(not star_positions, 'No shooting star without STAR PIECE')

        restore(base)
        keys('STAR_PIECE')
        dance_and_smash()
        check(not event('EVENT_MT_MOON_WISHING_STAR_CRASHED'), 'Dance alone does not trigger the meteor')
        before_loot = snapshot()
        m.write('wNumItems', 40)
        m.write_bytes('wItems', [value for _ in range(40) for value in (items['POTION'], 99)] + [255])
        loot_stone()
        check(not event('EVENT_MT_MOON_WISHING_STAR_CRASHED')
              and not event('EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE'), 'Full Bag neither spends the pickup nor triggers a crash')
        restore(before_loot)
        palettes_before_crash = m.read_bytes('wOBPals1', 64)
        loot_stone()
        check(event('EVENT_MT_MOON_WISHING_STAR_CRASHED'), 'Successful Moon Stone pickup triggers the crash')
        check(sfx['SFX_EGG_BOMB'] in sounds, 'Crash plays the explosion sound')
        check(m.read_bytes('wOBPals1', 64) == palettes_before_crash, 'Shooting star restores the overworld object palettes')
        check(event('EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE') and m.read('wItems') == items['MOON_STONE'], 'Moon Stone is awarded before the crash')
        check(len(star_positions) == 56 and star_positions[0] == (0, 8) and star_positions[-1] == (220, 200),
              'Faster shooting star and its tail leave the bottom-right in 56 frames')
        check(len(star_priority) == 56 and all(star_priority),
              'Star and four sparkling trail sprites take OAM priority over the unchanged player/map sprites')
        check((m.read('wPlayerDirection') & 0xc) == 0, 'Player faces down after watching the star')
        check(block(20, 14) == 0x9f, 'Crash replaces the entire (20,14)-(21,15) metatile with $9F')
        check(has_key('STAR_PIECE'), 'STAR PIECE remains in the Bag until the crater is approached')
        check(h.sym['MountMoonSquareStarCrashedText'] in texts, 'Crash notice is shown after the star leaves')
        crashed = snapshot()
        for origin, goal in (((19, 15), (20, 15)), ((23, 15), (22, 15)),
                             ((21, 13), (21, 14)), ((21, 17), (21, 16))):
            restore(crashed)
            enter('MOUNT_MOON_SQUARE', origin)
            if c.passable(c.collision(*origin)) and c.passable(c.collision(*goal)):
                c.go(goal)
                until(idle, advance=True)
                check(not has_key('STAR_PIECE'), f'Crater approach from {origin} consumes STAR PIECE')
        restore(crashed)
        enter('MOUNT_MOON_SQUARE', (19, 15))
        check(block(20, 14) == 0x9f, 'Crater survives map reload')
        check(not any(o['map_object'] == 4 for o in c.objects()), 'Meteor uses the tileset boulder without a fossil sprite')
        pb.screen.image.resize((640, 576)).save(output / 'crater-meteor.png')
        c.go((20, 15))
        until(idle, advance=True)
        check(not has_key('STAR_PIECE') and event('EVENT_MT_MOON_STAR_PIECE_VANISHED'), 'Approaching the meteor consumes STAR PIECE once')
        check(h.sym['MountMoonSquareStarPieceVanishesText'] in texts, 'Approach explains the vanishing key item')
        if m.read('wPlayerDirection') & 12 != 12:
            c.press('right', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)
        check(has_key('WISHING_STAR') and event('EVENT_GOT_WISHING_STAR'), 'Hidden meteor interaction awards WISHING STAR')
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)
        check(m.read('wNumKeyItems') == 1, 'Hidden WISHING STAR cannot be collected twice')
        pb.screen.image.resize((640, 576)).save(output / 'crater-collected.png')
        enter('MOUNT_MOON_SQUARE', (19, 15))
        check(block(20, 14) == 0x9f and not any(o['map_object'] == 4 for o in c.objects()), 'Crater boulder stays permanently after hidden item collection')

        enter('ECRUTEAK_CITY', (25, 9))
        check(not any(o['map_object'] == 9 for o in c.objects()), 'Well granny disappears once WISHING STAR is collected')
        c.press('up', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(lambda: 'YES' in tile_text(h) and 'NO' in tile_text(h), advance=True)
        c.press('b', hold=4, wait=24)
        until(idle, advance=True)
        check(has_key('WISHING_STAR') and not event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED'), 'Declining the wish preserves the key item and encounter')
        before_wish = snapshot()
        enter('ECRUTEAK_CITY', (26, 8))
        c.press('left', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(lambda: m.read('wBattleMode') and 'FIGHT' in tile_text(h), advance=True)
        check(event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED') and not has_key('WISHING_STAR'), 'Well wish also works from the east side')
        restore(before_wish)
        rise_offsets.clear()
        rise_oam_positions.clear()
        circle_frames.clear()
        circle_screen_positions.clear()
        cries.clear()
        well_sequence.clear()
        c.press('a', hold=4, wait=24)
        until(lambda: m.read('wBattleMode') and 'FIGHT' in tile_text(h), advance=True)
        pb.button_release('a')
        h.tick(90) # Let the native battle menu finish drawing before choosing PACK.
        check(m.read('wBattleMode') == 1 and m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species_index('JIRACHI')
              and m.read('wEnemyMonLevel') == 50, 'Well starts a catchable wild level 50 Jirachi battle')
        check(not has_key('WISHING_STAR') and event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED'), 'Wish consumes its key item and marks encounter complete before battle')
        check(rise_offsets == [value & 255 for value in range(0, -16, -1)], 'Jirachi first appears one tile higher and rises above the well')
        check(len(rise_oam_positions) >= 16, 'Jirachi graphics render at distinct screen positions throughout the rise')
        check(cries == [h.con.species_index('JIRACHI')] * 2, 'Jirachi cries once on appearing and again before battle')
        check(bool(dialogue_visible), 'The final Jirachi dialogue visibility check ran')
        check(well_sequence == ['cry', 'circles', 'circles_done', 'dialogue', 'cry', 'battle'],
              'Two circles separate the appearance cry from the final CHI dialogue and cry')
        check([frame[0] for frame in circle_frames] == list(range(128)), 'Jirachi performs exactly two complete 64-frame circles')
        check([circle_frames[index][1:3] for index in (1, 17, 33, 49, 65)]
              == [(0, 240), (244, 228), (0, 216), (12, 228), (0, 240)],
              'Circular flight reaches all four sides and returns to its starting point')
        check([frame[1:] for frame in circle_frames[1:64]] == [frame[1:] for frame in circle_frames[65:128]],
              'Both circles follow the same path and walking poses')
        (output / 'circle-data.json').write_text(json.dumps(dict(frames=circle_frames,
            screen_positions=sorted(circle_screen_positions)), indent=2))
        check(len({frame[1:3] for frame in circle_frames}) >= 48 and len(circle_screen_positions) >= 64,
              'The circles render smoothly across the overworld')
        check(all(8 <= x <= 160 and 16 <= y <= 152 for x, y in circle_screen_positions),
              'Jirachi remains fully visible throughout both circles')
        check(len({frame[3] for frame in circle_frames}) >= 8, 'Jirachi uses walking poses facing along the circle')
        sprite_ids = _parse_constants(ROOT / 'constants/sprite_constants.asm', const_value_equs=('SPRITE_POKEMON',))
        obj = (ROOT / 'data/sprites/sprites.asm').read_text()
        check(sprite_ids['SPRITE_JIRACHI'] < sprite_ids['SPRITE_POKEMON']
              and 'JirachiSpriteGFX, 12, WALKING_SPRITE' in obj, 'Well Jirachi uses the supplied walking sheet rather than its menu icon')
        pb.screen.image.save(output / 'jirachi-battle.png')
        battle = snapshot()
        c.press('down', hold=4, wait=24)
        c.press('a', hold=4, wait=100)
        if 'MASTER BALL' not in tile_text(h):
            c.press('right', hold=4, wait=60)
        until(lambda: 'MASTER BALL' in tile_text(h), advance=False)
        c.press('a', hold=4, wait=60)
        c.press('a', hold=4, wait=24)
        nickname = False
        for frame in range(15000):
            if idle():
                break
            if not nickname and 'YES' in tile_text(h) and any(name.startswith('Text_AskNicknameNewlyCaughtMon') for name in h.battle.textbox_contexts):
                c.press('b', hold=4, wait=40)
                nickname = True
            elif frame % 6 == 0:
                pb.button('a', 2)
            h.tick(4)
        else:
            raise RuntimeError('Capture did not finish: ' + tile_text(h))
        check(m.read('wPartyCount') == 2 and m.species_index_of(m.read('wPartyMon2Species')) == h.con.species_index('JIRACHI'), 'Jirachi can be caught and joins the party')
        check(c.map_id() == maps['ECRUTEAK_CITY'] and not any(o['map_object'] == 10 for o in c.objects()), 'Jirachi disappears from the well after capture')
        c.press('a', hold=4, wait=24)
        until(lambda: 'YES' in tile_text(h) and 'NO' in tile_text(h), advance=True)
        check(h.sym['EcruteakCityWishingWellPromptText'] in texts, 'Well returns to independent coin wishes after the encounter')
        c.press('b', hold=4, wait=24)
        until(idle, advance=True)
        restore(battle)
        c.press('right', hold=4, wait=24)
        c.press('down', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)
        check(event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED') and not has_key('WISHING_STAR') and c.map_id() == maps['ECRUTEAK_CITY'], 'Escaping also ends the encounter permanently')
        restore(battle)
        m.write_bytes('wEnemyMonHP', [0, 1])
        c.press('a', hold=4, wait=80)
        c.press('a', hold=4, wait=24)
        until(idle, advance=True)
        check(event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED') and c.map_id() == maps['ECRUTEAK_CITY']
              and m.read('wPartyCount') == 1, 'Knocking out Jirachi also ends the encounter permanently')
        restore(battle)
        m.write_bytes('wBattleMonHP', [0, 1])
        m.write_bytes('wPartyMon1HP', [0, 1])
        # The private fixture has a single weakened Pokemon; native turns
        # resolve its defeat and the normal whiteout.
        c.press('a', hold=4, wait=80)
        c.press('down', hold=4, wait=24)
        c.press('down', hold=4, wait=24)
        c.press('a', hold=4, wait=24)
        until(lambda: not m.read('wBattleMode') and not m.read('wScriptMode'), advance=True)
        check(m.read('wBattleResult') & 15 == 1 and event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED')
              and not has_key('WISHING_STAR'), 'Player defeat cannot replay the spent wishing-star encounter')
        check(not h.text_overflows, 'Quest dialogue stays inside the textbox')
        (output / 'checks.json').write_text(json.dumps(checks, indent=2) + '\n')
        print(f'{len(checks)} wishing-star checks passed', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
