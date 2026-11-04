#!/usr/bin/env python3
"""Native forest intro, repeatable rivalry lunges and lower-Seviper encounter.

All fixture writes precede each run. Actual movement, dialogue and encounters
execute unchanged in a private emulator; no player save is opened or changed.
"""
import argparse
import io
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from record_lance_escort_scenes import Recording

from runner import Harness
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from probability_checks import call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/forest-rivalry')
    parser.add_argument('--record', action='store_true', help='Record the first complete sequence with game audio')
    parser.add_argument('--snapshot-only', action='store_true', help='Save a private map fixture for graphics inspection')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=args.record,
                emulator_kwargs={'sound_sample_rate': 48000} if args.record else {})
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    types = _parse_constants(ROOT / 'constants/type_constants.asm')
    checks, texts, paths = [], [], {}
    group, number = map_ids()['VIRIDIAN_FOREST']
    original_tick = h.tick
    active = False
    recording = None
    video = None
    watch_battle_hud = False
    hud_frames = 0
    hud_checks = 0
    standing_phase = False
    standing_frames = {}
    clash_phase = False
    clash_offsets = {}
    cries = []
    text_actors = []

    def check(ok, label):
        if not ok:
            pb.screen.image.save(args.output / 'failure.png')
            raise AssertionError(label + '\n' + tile_text(h))
        checks.append(label)
        print('PASS', label, flush=True)

    def event(name):
        bit = flags['EVENT_VIRIDIAN_FOREST_' + name]
        return bool(pb.memory[h.sym.addr('wEventFlags') + bit // 8] & (1 << (bit % 8)))

    def actors(): return {o['map_object']: o for o in controls.objects()}

    def tick(n=1):
        nonlocal watch_battle_hud, hud_frames, hud_checks
        for _ in range(n):
            original_tick(1)
            if watch_battle_hud:
                if m.read('wBattleMode') != 1:
                    watch_battle_hud = False
                else:
                    pair = list(m.read_bytes('wEnemyMonType1', 2)) + list(m.read_bytes('wBattleMonType1', 2))
                    gfx_bank, gfx_addr = h.sym['BattleHUDTypeGFX']
                    visible = 0
                    for slot, (x, y, tile, palette, color) in enumerate(
                            ((2, 1, 0x60, 5, 1), (3, 1, 0x61, 5, 2),
                             (10, 8, 0x62, 5, 3), (11, 8, 0x63, 4, 1))):
                        if (m.read('wTileMap', y*20+x) != tile or
                                pb.memory[0, 0x9800+y*32+x] != tile): continue
                        mask = bytes(pb.memory[gfx_bank, gfx_addr+pair[slot]*8:gfx_addr+pair[slot]*8+8])
                        if slot in (1, 3) and pair[slot] == pair[slot-1]: mask = bytes(8)
                        expected = bytes(value for row in mask for value in
                                         (row if color & 1 else 0, row if color & 2 else 0))
                        assert bytes(pb.memory[1, 0x9600+slot*16:0x9610+slot*16]) == expected, \
                            f'Live forest battle corrupted type icon {slot}'
                        assert pb.memory[1, 0x9800+y*32+x] == palette | 8, \
                            f'Live forest battle corrupted type-icon attribute {slot}'
                        hud_checks += 2
                        visible += 1
                    hud_frames += bool(visible)
            if recording:
                recording.append()
            if active and not m.read('wBattleMode') and controls.map_id() == (group, number):
                for ident, obj in actors().items():
                    if ident not in (9, 10, 11): continue
                    position = obj['next']
                    if min(position) < 0: continue
                    check_passable = controls.passable(controls.collision(*position))
                    if not check_passable:
                        with (ROOT / '.tmpbuild/forest-revision-failure.state').open('wb') as stream:
                            pb.save_state(stream)
                        raise AssertionError(f'Actor {ident} walks into a wall at {position}: '
                                             f'collision={controls.collision(*position):02x}, '
                                             f'width={m.read("wMapWidth")}, bank={m.read("wTilesetCollisionBank")}, '
                                             f'ptr={list(m.read_bytes("wTilesetCollisionAddress", 2))}, '
                                             f'PC={pb.register_file.PC:04x}, ROM={m.read("hROMBank")}, '
                                             f'player={controls.position()}')
                    path = paths.setdefault(ident, [])
                    if not path or path[-1] != position: path.append(position)
                    data = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)
                    if standing_phase:
                        standing_frames.setdefault(ident, set()).add(data[13])
                        assert obj['position'] == {9: [2, 30], 10: [2, 31], 11: [3, 30]}[ident], \
                            'Standing animation moved an actor'
                    if clash_phase and ident in (9, 11):
                        assert obj['position'] == {9: [2, 30], 11: [3, 30]}[ident] and \
                               obj['next'] == obj['position'], 'Right-side clash shoved an actor'
                        offset = data[25] if data[25] < 128 else data[25] - 256
                        clash_offsets.setdefault(ident, set()).add(offset)

    def drive(predicate, limit=12000):
        for i in range(limit):
            if predicate():
                pb.button_release('a')
                h.tick(60)  # Let the native menu initialize its cursor before input.
                return
            if i % (150 if recording else 24) == 0: pb.button('a', 2)
            h.tick(1)
        pb.screen.image.save(args.output / 'failure.png')
        raise RuntimeError('Scene did not reach target: ' + h.where() + '\n' + str({
            name: m.read(name) for name in ('wBattleMode', 'wMapStatus', 'wScriptBank', 'wScriptMode',
                                           'wScriptPos', 'wScriptPos + 1', 'wScriptVar')
            if name in h.sym.by_name}) + '\n' + str(actors()) + '\n' + tile_text(h))

    def fight_menu():
        return bool(m.read('wBattleMode')) and 'FIGHT' in tile_text(h) and 'PACK' in tile_text(h)

    def idle():
        return not m.read('wBattleMode') and not m.read('wScriptMode') and m.read('wMapStatus') == 2

    def capture():
        # Set the menu cursor through ordinary inputs, then use the ball pocket.
        h.press('left', hold=8, wait=80)
        h.press('down', hold=8, wait=80)
        h.press('a', hold=8, wait=100)
        for _ in range(6):
            if 'MASTER BALL' in tile_text(h): break
            h.press('right', hold=8, wait=80)
        check('MASTER BALL' in tile_text(h), 'native Master Ball pocket opens')
        h.press('a', hold=8, wait=80)
        h.press('a', hold=8, wait=80)
        answered = False
        for i in range(14000):
            text = tile_text(h)
            if not m.read('wBattleMode'): return
            if 'nickname' in text.lower() and 'YES' in text and not answered:
                h.tick(40)
                h.press('b', hold=4, wait=30)
                answered = True
            elif i % (120 if recording else 24) == 0:
                pb.button('a', 2)
            h.tick(1)
        raise RuntimeError('Capture did not finish: ' + tile_text(h))

    def knockout():
        nonlocal watch_battle_hud
        watch_battle_hud = True
        for _ in range(600):
            if not m.read('wBattleMode'):
                h.tick(120)
                return
            text = tile_text(h)
            if 'FIGHT' in text and 'PACK' in text:
                h.press('up', hold=8, wait=80)
                h.press('left', hold=8, wait=80)
                h.press('a', hold=8, wait=80)
            else:
                h.press('a', hold=8, wait=24)
        raise RuntimeError('Battle did not finish: ' + tile_text(h))

    def script_text(_):
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        ptr = pb.memory[bank, pos] | pb.memory[bank, pos+1] << 8
        label = h.sym.nearest(bank, ptr)
        texts.append(label)
        if label in ('ForestRivalryZangooseText', 'ForestRivalrySeviperText'):
            word = 'ZAN?' if label == 'ForestRivalryZangooseText' else 'SEVI!'
            # Text command $00, followed by the cartridge's uppercase font codes.
            encoded = bytes(ord(c) - ord('A') + 0x80 if c.isalpha() else
                            {'?': 0xe6, '!': 0xe7}[c] for c in word)
            assert bytes(pb.memory[bank, ptr + 1:ptr + 1 + len(word)]) == encoded, \
                'Pokemon speech must be uppercase: ' + word
        if label == 'ForestRivalryZangooseText':
            current = actors()
            if 9 in current:
                obj = current[9]
                facing = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)[8]
                text_actors.append((obj['position'], facing, controls.position()))

    def script_cry(_):
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        cries.append(pb.memory[bank, pos] | pb.memory[bank, pos+1] << 8)

    try:
        print('Booting private game', args.rom.name, flush=True)
        new_game(h, 0)
        m.write('wOptions', 0x41)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MEWTWO'))
        m.write('wCurPartySpecies', sid)
        m.write('wCurPartyLevel', 100)
        native_call(h, 'TryAddMonToParty')
        mids = [call(h, 'GetMoveIDFromIndex', HL=h.con.move_index(move)) for move in ('EARTH_POWER', 'AURA_SPHERE')]
        m.write_bytes('wPartyMon1Moves', mids + [0, 0])
        m.write_bytes('wPartyMon1PP', [10, 20, 0, 0])
        m.write('wRepelEffect', 255)
        m.write('wNumBalls', 1)
        m.write_bytes('wBalls', [h.con.item_id('MASTER_BALL'), 10, 255])
        for name, bit in flags.items():
            if name.startswith('EVENT_VIRIDIAN_FOREST_'):
                address = h.sym.addr('wEventFlags') + bit // 8
                pb.memory[address] &= ~(1 << (bit % 8))
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                wXCoord=7, wYCoord=30, hMapEntryMethod=0xf1).items():
            m.write(name, value)
        native_call(h, 'EnterMap')
        m.write('hOAMUpdate', 0)
        begin_native_call(h, 'OverworldLoop.loop')
        h.tick(90)
        pb.screen.image.save(args.output / 'initial.png')
        for ident, name in ((9, 'zangoose'), (10, 'seviper'), (11, 'seviper')):
            obj = actors()[ident]
            data = m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)
            tile = data[2]
            bank = 0 if tile & 0x80 else 1
            address = 0x8000 + (tile & 0x7f) * 16
            source = (ROOT / f'gfx/sprites/{name}.2bpp').read_bytes()
            check(bytes(pb.memory[bank, address:address + 192]) == source[:192],
                  f'{name}: standing facings match supplied graphics in VRAM')
        gray_red = [31 | 31 << 5 | 31 << 10, 24 | 24 << 5 | 24 << 10, 31 | 7 << 5 | 1 << 10, 0]
        check(bytes(m.read_bytes('wOBPals1', 8, 7*8)) == b''.join(v.to_bytes(2, 'little') for v in gray_red),
              'Zangoose uses Wimpod gray with its own red markings in the forest-only palette')
        obj = actors()[9]
        check(m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)[6] & 7 == 7,
              'Zangoose selects the custom gray/red palette')
        baseline = io.BytesIO()
        pb.save_state(baseline)
        if args.snapshot_only:
            (ROOT / '.tmpbuild/forest-map.state').write_bytes(baseline.getvalue())
            print('ACTORS', actors(), flush=True)
            for obj in actors().values():
                if obj['map_object'] in (9, 10, 11):
                    print('STRUCT', obj['map_object'], list(m.read_bytes('wObjectStructs', 40, obj['slot'] * 40)), flush=True)
            return
        pb.hook_register(*h.sym['Script_writetext'], script_text, None)
        pb.hook_register(*h.sym['Script_cry'], script_cry, None)
        h.tick = tick

        for entry, right_approach, right_direction, capture_seviper in (
                (30, (4, 30), 'left', False), (31, (3, 31), 'up', True)):
            active = False
            baseline.seek(0)
            pb.load_state(baseline)
            paths.clear()
            texts.clear()
            text_actors.clear()
            if entry == 31: controls.go((7, 31))
            active = True
            if args.record and video is None:
                recording = Recording(pb, args.output / 'viridian-forest-rivalry.mp4')
                h.tick(90)
            controls.go((6, entry))
            drive(lambda: event('RIVALRY_SEEN') and idle())
            current = actors()
            check(controls.position() == (6, entry), f'trigger row {entry} freezes player in place')
            check(current[9]['position'] == [2, 30] and current[10]['position'] == [2, 31]
                  and current[11]['position'] == [3, 30], 'three actors return to requested positions')
            check([4, 30] in paths[11] and paths[11][-1] == [3, 30], 'right-hand Seviper knocked right and returns')
            hardware = [bytes(pb.memory[0xfe00+i*4:0xfe04+i*4]) for i in range(40)]
            check(m.read('hOAMUpdate') == 0 and sum(12 <= (row[2] & 0x7f) < 36 and bool(row[3] & 8)
                                                  for row in hardware) >= 12,
                  'all three actors are visibly drawn in hardware OAM')
            pb.screen.image.save(args.output / f'intro-row-{entry}.png')
            standing_frames.clear()
            standing_phase = True
            h.tick(180)
            standing_phase = False
            check(all(len(standing_frames.get(ident, ())) >= 2 for ident in (9, 10, 11)),
                  'all three alternate their walking frames while standing on their own tiles')
            controls.go(right_approach)
            check(controls.position() == right_approach, 'player can approach the right-hand Seviper')
            controls.press(right_direction, hold=4, wait=25)
            for repeat in range(2 if not recording else 1):
                cries.clear()
                clash_offsets.clear()
                clash_phase = True
                controls.press('a', hold=4, wait=30)
                drive(idle)
                clash_phase = False
                current = actors()
                check(not event('SEVIPER_BEATEN') and not m.read('wBattleMode') and
                      not event('SEVIPER1_GONE') and not event('SEVIPER2_GONE'),
                      'right-hand Seviper never starts or advances an encounter')
                check(12 in clash_offsets.get(9, ()) and -12 in clash_offsets.get(11, ()) and
                      current[9]['position'] == [2, 30] and current[11]['position'] == [3, 30],
                      'Zangoose and right-hand Seviper trade 12-pixel lunges without being shoved')
                check(cries and set(cries) == {h.con.species_index('SEVIPER')},
                      'repeatable clash plays only Seviper cry')
            pb.screen.image.save(args.output / f'right-clash-{entry}.png')
            controls.go((3, 31))
            check(controls.position() == (3, 31), 'player approaches the lower Seviper from the right')
            controls.press('left', hold=4, wait=25)
            controls.press('a', hold=4, wait=30)
            drive(fight_menu)
            check(m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species_index('SEVIPER')
                  and m.read('wEnemyMonLevel') == 50, 'only the lower Seviper starts the level 50 battle')
            # Check the actual Run menu, including its return to the same battle.
            controls.press('right', hold=8, wait=80)
            controls.press('down', hold=8, wait=80)
            controls.press('a', hold=8, wait=80)
            drive(fight_menu)
            check(m.read('wBattleMode') == 1 and not m.read('wBattleEnded'), 'Run is blocked in Seviper battle')
            if capture_seviper: capture()
            else: knockout()
            drive(fight_menu)
            check(event('SEVIPER1_GONE') and event('SEVIPER2_GONE'), 'both Seviper leave after one battle')
            check(paths[9] == [[2, 30], [3, 30]] and
                  text_actors[-1] == ([3, 30], 0, (3, 31)),
                  'Zangoose moves exactly one tile right and faces down toward the stationary player')
            check(m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species_index('ZANGOOSE_SCARRED')
                  and m.read('wEnemyMonLevel') == 50, 'Zangoose approaches and starts unique level 50 battle')
            check(list(m.read_bytes('wEnemyMonType1', 2)) == [types['NORMAL'], types['POISON']],
                  'unique Zangoose has Normal/Poison battle types')
            check('DIRE_CLAW' in [h.con.moves_by_index[m.move_index_of(v)]
                                 for v in m.read_bytes('wEnemyMonMoves', 4) if v], 'unique encounter knows Dire Claw')
            check('ForestRivalryScarredText' in texts, 'full scarred-fur explanation is shown')
            pb.screen.image.save(args.output / f'zangoose-{entry}.png')
            if capture_seviper: knockout()
            else: capture()
            drive(idle)
            check(event('ZANGOOSE_GONE'), 'finished encounter stays completed')
            if not capture_seviper:
                check(m.read('wPartyCount') == 2 and
                      m.species_index_of(m.read('wPartyMon2Species')) == h.con.species_index('ZANGOOSE_SCARRED'),
                      'caught special Zangoose joins party with persistent form')
                check(h.con.moves_by_index[m.move_index_of(m.read('wPartyMon2Moves'))] == 'DIRE_CLAW',
                      'captured Zangoose retains Dire Claw')
            if recording:
                h.tick(120)
                video = recording.finish()
                recording = None
            active = False
            m.write('hMapEntryMethod', 0xf1)
            native_call(h, 'EnterMap')
            m.write('hOAMUpdate', 0)
            begin_native_call(h, 'OverworldLoop.loop')
            h.tick(90)
            check(not ({9, 10, 11} & set(actors())), 'all three remain absent after map re-entry')
            pb.screen.image.save(args.output / f'finished-{entry}.png')

        # Re-enter with the progress that a Zangoose whiteout leaves behind.
        # Run the actual map callback, including its cross-bank script return.
        baseline.seek(0)
        pb.load_state(baseline)
        for name in ('RIVALRY_SEEN', 'SEVIPER_BEATEN', 'SEVIPER1_GONE', 'SEVIPER2_GONE'):
            bit = flags['EVENT_VIRIDIAN_FOREST_' + name]
            address = h.sym.addr('wEventFlags') + bit // 8
            pb.memory[address] |= 1 << (bit % 8)
        m.write('hMapEntryMethod', 0xf1)
        native_call(h, 'EnterMap')
        m.write('hOAMUpdate', 0)
        begin_native_call(h, 'OverworldLoop.loop')
        h.tick(90)
        current = actors()
        check(9 in current and current[9]['position'] == [3, 30] and
              not ({10, 11} & set(current)),
              'unfinished Zangoose encounter restores its final tile on map re-entry')
        controls.go((3, 31))
        controls.press('up', hold=4, wait=25)
        controls.press('a', hold=4, wait=30)
        drive(fight_menu)
        check(m.species_index_of(m.read('wEnemyMonSpecies')) == h.con.species_index('ZANGOOSE_SCARRED'),
              'unfinished Zangoose can be challenged again without repeating Seviper')

        check(hud_frames > 0, 'live battle type icons checked during the actual event attacks')
        (args.output / 'checks.json').write_text(json.dumps(dict(rom=args.rom.name, checks=checks, video=video,
                                                               hud_frames=hud_frames, hud_checks=hud_checks), indent=2))
        print(f'FOREST RIVALRY UI: {len(checks)} checks passed', flush=True)
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        pb.stop(save=False)


if __name__ == '__main__': main()
