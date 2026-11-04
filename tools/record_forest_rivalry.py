#!/usr/bin/env python3
"""Record the Viridian Forest Zangoose/Seviper event with native game audio.

Two videos, both played with ordinary button input in a private emulator
(no player save is opened or changed):

  zangoose-full-event.mp4   before -> intro -> right-hand Seviper clash ->
                            Seviper battle -> Zangoose battle and capture ->
                            leave through the south gate and come back
  zangoose-abandoned.mp4    before -> intro -> leave before helping ->
                            come back: everything is gone; inspect the remains
"""
import argparse
import io
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent / 'battletest'))
sys.path.insert(0, str(Path(__file__).resolve().parent))
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
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/forest-rivalry-videos')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    maps = map_ids()
    forest, gate = maps['VIRIDIAN_FOREST'], maps['VIRIDIAN_FOREST_SOUTH_GATE']
    texts = []
    recording = None
    original_tick = h.tick

    def tick(n=1):
        for _ in range(n):
            original_tick(1)
            if recording:
                recording.append()
    h.tick = tick

    def flag(name):
        bit = flags[name]
        return bool(pb.memory[h.sym.addr('wEventFlags') + bit // 8] & (1 << (bit % 8)))

    def set_flag(name, value):
        bit = flags[name]
        address = h.sym.addr('wEventFlags') + bit // 8
        if value:
            pb.memory[address] |= 1 << (bit % 8)
        else:
            pb.memory[address] &= ~(1 << (bit % 8))

    def actors():
        return {o['map_object']: o for o in controls.objects()}

    def idle():
        return not m.read('wBattleMode') and not m.read('wScriptMode') and m.read('wMapStatus') == 2

    def fight_menu():
        return bool(m.read('wBattleMode')) and 'FIGHT' in tile_text(h) and 'PACK' in tile_text(h)

    def drive(predicate, limit=20000):
        # Advance text at a readable pace until the predicate holds.
        for i in range(limit):
            if predicate():
                pb.button_release('a')
                h.tick(60)
                return
            if i % 150 == 0:
                pb.button('a', 2)
            h.tick(1)
        raise RuntimeError('Scene did not reach target: ' + h.where() + '\n' + tile_text(h))

    def knockout():
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
                h.press('a', hold=8, wait=40)
        raise RuntimeError('Battle did not finish: ' + tile_text(h))

    def capture():
        h.press('left', hold=8, wait=80)
        h.press('down', hold=8, wait=80)
        h.press('a', hold=8, wait=100)
        for _ in range(6):
            if 'MASTER BALL' in tile_text(h):
                break
            h.press('right', hold=8, wait=80)
        assert 'MASTER BALL' in tile_text(h), 'Ball pocket did not open'
        h.press('a', hold=8, wait=80)
        h.press('a', hold=8, wait=80)
        answered = False
        for i in range(14000):
            text = tile_text(h)
            if not m.read('wBattleMode'):
                return
            if 'nickname' in text.lower() and 'YES' in text and not answered:
                h.tick(40)
                h.press('b', hold=4, wait=30)
                answered = True
            elif i % 120 == 0:
                pb.button('a', 2)
            h.tick(1)
        raise RuntimeError('Capture did not finish: ' + tile_text(h))

    def walk(goal):
        controls.go(goal, limit=800)
        h.tick(10)

    def leave_and_return():
        # Walk out through the south exit, turn around in the gate and walk back in.
        walk((16, 47))
        for _ in range(40):
            if controls.map_id() == gate and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                break
            if controls.map_id() == forest:
                h.press('down', hold=8, wait=30)
            else:
                h.tick(10)
        assert controls.map_id() == gate, f'did not leave the forest: at {controls.position()} map {controls.map_id()}\n' + '\n'.join(controls.grid()[40:48])
        h.tick(60)
        walk((4, 1))
        for _ in range(40):
            if controls.map_id() == forest and m.read('wMapStatus') == 2 and not m.read('wScriptMode'):
                break
            if controls.map_id() == gate:
                h.press('up', hold=8, wait=30)
            else:
                h.tick(10)
        assert controls.map_id() == forest, f'did not return to the forest: at {controls.position()} map {controls.map_id()}'
        h.tick(60)

    def script_text(_):
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        texts.append(h.sym.nearest(bank, pb.memory[bank, pos] | pb.memory[bank, pos + 1] << 8))

    try:
        print('Booting private game', args.rom.name, flush=True)
        new_game(h, 0)
        m.write('wOptions', 0x41)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        m.write('wCurPartySpecies', call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MEWTWO')))
        m.write('wCurPartyLevel', 100)
        native_call(h, 'TryAddMonToParty')
        moves = [call(h, 'GetMoveIDFromIndex', HL=h.con.move_index(name)) for name in ('EARTH_POWER', 'AURA_SPHERE')]
        m.write_bytes('wPartyMon1Moves', moves + [0, 0])
        m.write_bytes('wPartyMon1PP', [10, 20, 0, 0])
        m.write('wRepelEffect', 255)
        m.write('wNumBalls', 1)
        m.write_bytes('wBalls', [h.con.item_id('MASTER_BALL'), 10, 255])
        for name in flags:
            if name.startswith('EVENT_VIRIDIAN_FOREST_'):
                set_flag(name, False)
        for name in ('EVENT_BEAT_BUG_CATCHER_ROB', 'EVENT_BEAT_BUG_CATCHER_ED', 'EVENT_BEAT_BUG_CATCHER_DOUG'):
            set_flag(name, True)  # keep the long walks to the gate free of trainer battles
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=forest[0], wMapNumber=forest[1],
                                wXCoord=7, wYCoord=30, hMapEntryMethod=0xf1).items():
            m.write(name, value)
        native_call(h, 'EnterMap')
        m.write('hOAMUpdate', 0)
        begin_native_call(h, 'OverworldLoop.loop')
        h.tick(90)
        assert {9, 10, 11} <= set(actors()), 'event actors missing at start'
        baseline = io.BytesIO()
        pb.save_state(baseline)
        pb.hook_register(*h.sym['Script_writetext'], script_text, None)
        pb.hook_register(*h.sym['Script_jumptext'], script_text, None)

        # ---- Video 1: the whole event, then leave and come back ----
        recording = Recording(pb, args.output / 'zangoose-full-event.mp4')
        h.tick(150)                                  # before: all three in place
        walk((6, 30))                                # trigger tile
        drive(lambda: flag('EVENT_VIRIDIAN_FOREST_RIVALRY_SEEN') and idle())
        h.tick(90)
        walk((4, 30))                                # right-hand Seviper clash
        h.press('left', hold=4, wait=25)
        h.press('a', hold=4, wait=30)
        drive(idle)
        walk((3, 31))                                # lower Seviper starts the fight
        h.press('left', hold=4, wait=25)
        h.press('a', hold=4, wait=30)
        drive(fight_menu)
        knockout()
        drive(fight_menu)                            # Zangoose steps up and battles
        assert h.con.species_by_index[m.species_index_of(m.read('wEnemyMonSpecies'))] == 'ZANGOOSE_SCARRED'
        h.tick(90)
        capture()
        drive(idle)
        assert flag('EVENT_VIRIDIAN_FOREST_ZANGOOSE_GONE') and not flag('EVENT_VIRIDIAN_FOREST_ZANGOOSE_PERISHED')
        h.tick(120)                                  # after: the clearing is empty
        leave_and_return()
        walk((4, 30))
        walk((3, 30))
        h.press('a', hold=4, wait=60)
        assert not ({9, 10, 11} & set(actors())), 'actors came back after completion'
        assert 'ForestRivalryRemainsText' not in texts
        h.tick(150)
        full = recording.finish()
        recording = None

        # ---- Video 2: start it, leave before helping, come back ----
        baseline.seek(0)
        pb.load_state(baseline)
        texts.clear()
        recording = Recording(pb, args.output / 'zangoose-abandoned.mp4')
        h.tick(150)                                  # before: all three in place
        walk((6, 30))
        drive(lambda: flag('EVENT_VIRIDIAN_FOREST_RIVALRY_SEEN') and idle())
        h.tick(90)
        leave_and_return()                           # walk away without helping
        assert flag('EVENT_VIRIDIAN_FOREST_ZANGOOSE_PERISHED'), 'abandonment not recorded'
        walk((6, 30))                                # the trigger is silent now
        h.tick(60)
        walk((4, 30))
        walk((3, 30))                                # face Zangoose's old tile
        h.tick(60)
        h.press('a', hold=4, wait=30)
        drive(idle)
        assert 'ForestRivalryRemainsText' in texts, 'remains text not shown'
        assert not ({9, 10, 11} & set(actors()))
        h.tick(150)
        abandoned = recording.finish()
        recording = None
        print('DONE', full['path'], abandoned['path'], flush=True)
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
