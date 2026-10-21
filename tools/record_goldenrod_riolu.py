#!/usr/bin/env python3
"""Record and check the native Goldenrod Underground Riolu scene.

Uses private emulator fixtures: location and a level-100 test party are staged
before filming. Movement, dialogue, cries, three battles and rewards then run
through the game's scripts and button input. The player's save is never used.
"""
import argparse
import io
import json
from pathlib import Path
import subprocess
import sys
import wave

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from state import Request
from symbols import _parse_constants
from probability_checks import call
from cove_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from ui_checks import tile_text


class RecordingHarness(Harness):
    def fixture_path(self):
        # Sound-disabled test states also disable audio when loaded into a
        # recording session. Keep a separate cache for the recording format.
        path = super().fixture_path()
        return path.with_name(path.stem + '-audio-48000.state')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/goldenrod-riolu')
    args = parser.parse_args()
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    h = RecordingHarness(verbose=True, sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
    h.ensure_fixture()
    pb, m, c = h.pb, h.battle.mem, Controls(h)
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    scene_events = ('EVENT_GOLDENROD_UNDERGROUND_THUGS_BEATEN',
                    'EVENT_GOLDENROD_UNDERGROUND_GIRL_LEFT',
                    'EVENT_GOT_RIOLU_FROM_GOLDENROD_UNDERGROUND_GIRL')
    maps = map_ids()
    frames = movie_frames = 0
    deadline = None
    signature = None
    recording = False
    encoder = audio = None
    seen, pages, checks = [], [], []
    reward_checkpoint = None
    party_species = None
    last_battle = False
    battle_count = 0
    cry_count = 0
    trainer_starts = 0
    giving_pokemon = False
    movement_probe = None
    movements = []
    riolu_asset = (ROOT / 'gfx/sprites/riolu.2bpp').read_bytes()

    def event(name, value=None):
        bit = events[name]
        addr = h.sym.addr('wEventFlags') + bit // 8
        mask = 1 << (bit % 8)
        if value is not None:
            pb.memory[addr] = pb.memory[addr] | mask if value else pb.memory[addr] & ~mask
        return bool(pb.memory[addr] & mask)

    def check(condition, label):
        checks.append(label)
        assert condition, label
        print('PASS', label, flush=True)

    def actors():
        result = {}
        for slot in range(1, 13):
            data = m.read_bytes('wObjectStructs', 40, slot * 40)
            if data[0] and data[1] in range(10, 15):
                result[data[1]] = dict(x=data[0x12] - 4, y=data[0x13] - 4,
                                      facing=data[8], sprite=data[0], tile=data[2], phase=data[13],
                                      y_offset=data[26] - 256 if data[26] > 127 else data[26])
        return result

    def xy(index):
        actor = actors().get(index)
        return (actor['x'], actor['y']) if actor else None

    def shot(label):
        pb.screen.image.save(out / (label + '.png'))
        print('STATE', label, c.position(), actors(), '\n' + tile_text(h), flush=True)

    def page(context):
        nonlocal deadline, signature
        text = tile_text(h)
        key = context, text
        if key != signature:
            signature = key
            deadline = frames + 140
            if recording:
                pages.append(dict(seconds=round(movie_frames * 4389 / 262144, 2), text=text))
                if 'RIOLU  RIO' in text:
                    pb.screen.image.save(out / 'riolu-guard.png')

    def finish_movement():
        nonlocal movement_probe
        if movement_probe is None:
            return
        probe = movement_probe
        movement_probe = None
        probe['end_seconds'] = movie_frames * 4389 / 262144
        expected = {
            'GoldenrodUndergroundThugPaulieApproachMovement': [(23, 17), (22, 17), (22, 18), (21, 18)],
            'GoldenrodUndergroundRioluProtectMovement': [(25, 17), (24, 17), (24, 18)],
            'GoldenrodUndergroundRioluApproachMovement': [(24, 18), (23, 18), (22, 18)],
        }
        check(probe['positions'] == expected[probe['name']], probe['name'] + ': exact tile route')
        if probe['object'] == 14:
            check(any(phase in probe['phases'] for phase in (9, 11)), probe['name'] + ': animated leftward walking')
            if 'Protect' in probe['name']:
                check(any(phase in probe['phases'] for phase in (1, 3)), probe['name'] + ': animated downward walking')
                check(len(probe['hops']) == 2, 'Riolu hops exactly twice before speaking')
                for index, hop in enumerate(probe['hops'], 1):
                    check(min(hop['offsets']) == -12 and hop['offsets'][-1] == 0,
                          f'Riolu hop {index} rises and lands completely')
        if recording:
            movements.append(probe)

    def movement_start(_):
        nonlocal movement_probe
        finish_movement()
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        obj = pb.memory[bank, pos] - 1
        pointer = pb.memory[bank, pos + 1] | pb.memory[bank, pos + 2] << 8
        name = h.sym.nearest(bank, pointer)
        if name in ('GoldenrodUndergroundThugPaulieApproachMovement',
                    'GoldenrodUndergroundRioluProtectMovement', 'GoldenrodUndergroundRioluApproachMovement'):
            movement_probe = dict(name=name, object=obj, positions=[xy(obj)], phases=[], hops=[],
                                  start_seconds=movie_frames * 4389 / 262144)

    def hop_start(_):
        pointer = pb.register_file.B * 256 + pb.register_file.C
        if pb.memory[pointer + 1] != 14:
            return
        check(movement_probe is not None and 'Protect' in movement_probe['name'], 'Riolu hops during the protection movement')
        check(xy(14) == (24, 18) and actors()[14]['facing'] == 8, 'Riolu starts each hop in place facing left')
        movement_probe['hops'].append(dict(start_seconds=movie_frames * 4389 / 262144, offsets=[]))

    def observe_movement():
        if movement_probe is None:
            return
        actor = actors().get(movement_probe['object'])
        if actor is None:
            return
        position = actor['x'], actor['y']
        if movement_probe['hops']:
            assert position == (24, 18) and actor['facing'] == 8, 'Hop must not move or turn Riolu'
            movement_probe['hops'][-1]['offsets'].append(actor['y_offset'])
        if movement_probe['positions'][-1] != position:
            movement_probe['positions'].append(position)
        phase = actor['phase']
        if movement_probe['object'] == 14 and phase in (1, 3, 9, 11) and phase not in movement_probe['phases']:
            movement_probe['phases'].append(phase)
            tile = actor['tile']
            bank = 0 if tile & 128 else 1
            address = 0x8000 + (tile & 127) * 16
            check(bytes(pb.memory[bank, address:address + 192]) == riolu_asset[:192],
                  movement_probe['name'] + f': standing VRAM intact during phase {phase}')
            check(bytes(pb.memory[bank, address + 0x800:address + 0x800 + 192]) == riolu_asset[192:],
                  movement_probe['name'] + f': all 12 walking tiles intact during phase {phase}')
            if recording:
                pb.screen.image.save(out / (movement_probe['name'] + f'-phase-{phase}.png'))

    def script_text(_):
        finish_movement()
        bank = m.read('wScriptBank')
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        addr = pb.memory[bank, pos] | pb.memory[bank, pos + 1] << 8
        name = h.sym.nearest(bank, addr)
        seen.append(name)
        if name == 'GoldenrodUndergroundRioluText':
            check(xy(14) == (24, 18), 'Riolu guards at (24,18)')
            check(actors()[14]['facing'] == 8, 'Riolu faces left while guarding')
            check(xy(10) == (25, 18), 'Schoolgirl stays at (25,18) during confrontation')
            check(actors()[14]['y_offset'] == 0, 'Riolu lands before his dialogue and cry')
        if name == 'GoldenrodUndergroundGirlThanksText':
            check(xy(10) == (21, 18), 'Schoolgirl reaches the player from her new position')
            check(xy(14) == (22, 18), 'Riolu joins the reward conversation')
            check(all(xy(i) is None for i in (11, 12, 13)), 'All three grunts leave')

    def cry(_):
        nonlocal cry_count
        if xy(14) == (24, 18) and not m.read('wBattleMode'):
            cry_count += 1

    def trainer_start(_):
        nonlocal trainer_starts
        finish_movement()
        number = trainer_starts % 3
        trainer_starts += 1
        if number == 0:
            check(xy(11) == (21, 18), 'Paulie approaches above the player')
        elif number == 1:
            check(xy(12) == (22, 19), 'Bobby approaches to the right of the player')
        else:
            check(xy(12) == (22, 18) and xy(13) == (22, 19), 'Tony shoves Bobby aside and takes his place')

    def give_pokemon(_):
        nonlocal giving_pokemon
        giving_pokemon = True

    def tick(n=1):
        nonlocal frames, movie_frames, last_battle, battle_count
        for _ in range(n):
            pb.tick(1, True, True)
            frames += 1
            observe_movement()
            battle = bool(m.read('wBattleMode'))
            if battle and not last_battle:
                battle_count += 1
                print('BATTLE', battle_count, flush=True)
            last_battle = battle
            if recording:
                if movie_frames % 2 == 0:
                    canvas = Image.new('RGB', (640, 624), '#151a24')
                    canvas.paste(pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (0, 48))
                    ImageDraw.Draw(canvas).text((12, 12), 'Goldenrod Underground - Riolu protects the Schoolgirl',
                                               font=font, fill='white')
                    encoder.stdin.write(canvas.tobytes())
                samples = np.frombuffer(pb.sound.raw_buffer, dtype=np.int8, count=pb.sound.raw_buffer_head)
                audio.writeframesraw((samples.astype(np.int16) * 256).astype('<i2').tobytes())
                movie_frames += 1
                if movie_frames % 3600 == 0:
                    print('RECORDING', round(movie_frames * 4389 / 262144), 'seconds', repr(tile_text(h)), flush=True)
                    pb.screen.image.save(out / 'current-recording.png')

    def press(button, hold=4, wait=24):
        nonlocal deadline, signature
        if button == 'a' and deadline is not None and frames < deadline:
            tick(deadline - frames)
        deadline, signature = None, None
        pb.button(button, hold)
        tick(hold + wait)

    def idle():
        return not any(m.read(s) for s in ('wScriptRunning', 'wScriptMode', 'wBattleMode'))

    def run_until(predicate, limit=72000, choice='a', checkpoint=False):
        nonlocal deadline, signature, reward_checkpoint
        for _ in range(limit):
            if predicate():
                return
            text = tile_text(h)
            if 'NICKNAME' in text:
                press('start', wait=12)
                press('a', wait=40)
            elif 'nickname' in text:
                press('b', wait=40)
            elif 'YES' in text and 'NO' in text:
                if giving_pokemon:
                    press('b', wait=40)
                    continue
                if checkpoint and reward_checkpoint is None:
                    tick(60)
                    reward_checkpoint = io.BytesIO()
                    pb.save_state(reward_checkpoint)
                    (out / 'reward-choice.state').write_bytes(reward_checkpoint.getvalue())
                    print('CHECKPOINT reward choice', flush=True)
                press(choice, wait=40)
            elif m.read('wBattleMode'):
                c.battle()
            elif deadline is not None and frames >= deadline:
                press('a')
            else:
                tick()
        shot('error-timeout')
        raise RuntimeError('Scene timed out: ' + h.where())

    def stage(row):
        nonlocal deadline, signature, party_species, last_battle, giving_pokemon
        giving_pokemon = False
        h.load_fixture()
        request = Request(h.battle)
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        address = h.sym.addr('wDebugPlayer1')
        for slot in range(6):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
                species='MEW', level=100, moves=['SURF', 'THUNDERBOLT', 'ICE_BEAM', 'AURA_SPHERE'])))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        party_species = m.read_bytes('wPartySpecies', 7)
        m.write('wPartyCount', 1)
        m.write('wPartySpecies', 255, 1)
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wInBattleTowerBattle'):
            m.write(name, 0)
        m.write('wOptions', 0x41)
        for name in scene_events:
            event(name, False)
        m.write('wDefaultSpawnpoint', 255)
        m.write('wMapGroup', maps['GOLDENROD_UNDERGROUND'][0])
        m.write('wMapNumber', maps['GOLDENROD_UNDERGROUND'][1])
        m.write('wXCoord', 20)
        m.write('wYCoord', row)
        m.write('hMapEntryMethod', 0xf1)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)
        check(pb.sound.raw_buffer_head > 0, 'Recording fixture produces audio samples')
        deadline, signature, last_battle = None, None, False
        check(xy(14) == (25, 17), 'Riolu starts at (25,17)')
        check(actors()[14]['sprite'] == sprites['SPRITE_RIOLU'], 'Riolu uses the walking sprite')
        check(actors()[10]['sprite'] == sprites['SPRITE_SCHOOL_GIRL'], 'Girl uses Schoolgirl sprite')
        check(m.read('wMap10ObjectColor') >> 4 == 12, 'Schoolgirl uses purple palette')
        check(actors()[10]['facing'] == 8, 'Schoolgirl starts facing left')
        paths = [((25, 17), ['left', 'down']),
                 ((23, 17), ['left', 'down', 'left']),
                 ((23, 18), ['down', 'left']),
                 ((24, 19), ['left', 'left']),
                 ((25, 18), ['up', 'left', 'left', 'left', 'down', 'left']),
                 ((22, 18), ['left'] * 10)]
        directions = dict(left=(-1, 0), right=(1, 0), up=(0, -1), down=(0, 1))
        for start, path in paths:
            current = start
            for button in path:
                dx, dy = directions[button]
                nxt = current[0] + dx, current[1] + dy
                check(c.permits_step(current, nxt, button), f'Walkable scene step {current} -> {nxt}')
                current = nxt

    def restore_choice():
        nonlocal deadline, signature, last_battle, giving_pokemon
        reward_checkpoint.seek(0)
        pb.load_state(reward_checkpoint)
        deadline, signature, last_battle = None, None, False
        giving_pokemon = False
        for button in ('a', 'b', 'up', 'down', 'left', 'right'):
            pb.button_release(button)

    h.tick, h.press = tick, press
    for label in ('WaitPressAorB_BlinkCursor', 'JoyWaitAorB', 'ButtonSound.wait_input'):
        bank, addr = h.sym[label]
        pb.hook_register(bank, addr, page, label)
    for label, callback in (('Script_writetext', script_text), ('Script_cry', cry),
                            ('Script_startbattle', trainer_start), ('Script_givepoke', give_pokemon),
                            ('Script_applymovement', movement_start), ('Movement_jump_in_place', hop_start)):
        bank, addr = h.sym[label]
        pb.hook_register(bank, addr, callback, None)
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 19)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    try:
        stage(19)
        shot('01-starting-positions')
        encoder = subprocess.Popen([ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
            '-pixel_format', 'rgb24', '-video_size', '640x624', '-framerate', '131072/4389',
            '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '18',
            '-pix_fmt', 'yuv420p', str(out / 'scene-silent.mp4')], stdin=subprocess.PIPE)
        audio = wave.open(str(out / 'scene.wav'), 'wb')
        audio.setnchannels(2)
        audio.setsampwidth(2)
        audio.setframerate(pb.sound.sample_rate)
        recording = True
        tick(120)
        press('right', hold=8, wait=30)
        run_until(lambda: event(scene_events[1]) and idle(), checkpoint=True)
        tick(180)
        shot('02-riolu-received')
        recording = False
        encoder.stdin.close()
        check(encoder.wait() == 0, 'Video encoded')
        encoder = None
        audio.close()
        audio = None
        # PyBoy emits audio in 60-Hz buffers; the CGB display runs at
        # 59.7275 Hz. Stretch that small difference to keep cries in sync.
        with wave.open(str(out / 'scene.wav'), 'rb') as recorded_audio:
            audio_seconds = recorded_audio.getnframes() / recorded_audio.getframerate()
            audio_rate = recorded_audio.getframerate()
        video_seconds = movie_frames * 4389 / 262144
        corrected_rate = round(audio_rate * audio_seconds / video_seconds)
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', str(out / 'scene-silent.mp4'),
            '-i', str(out / 'scene.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-af', f'asetrate={corrected_rate},aresample={audio_rate}',
            '-t', str(video_seconds), '-movflags', '+faststart', str(out / 'goldenrod-riolu-scene.mp4')], check=True)
        check(battle_count == 3, 'Three native trainer battles complete')
        check(cry_count >= 1, 'Riolu cry executes in the scene')
        check(event(scene_events[2]) and m.read('wPartyCount') == 2, 'Riolu reward received')
        check(m.species_index_of(m.read('wPartyMon2Species')) == h.con.species_index('RIOLU'), 'Reward is Riolu')
        check(m.read('wPartyMon2Level') == 15, 'Reward remains level 15')
        check(not actors(), 'Girl, Riolu and grunts all disappear after acceptance')
        check(not h.text_overflows, 'No dialogue overflows')
        check(reward_checkpoint is not None, 'Reward checkpoint captured')

        restore_choice()
        run_until(lambda: event(scene_events[1]) and idle(), choice='b')
        check(not event(scene_events[2]) and m.read('wPartyCount') == 1, 'Declining gives no Riolu')
        check(not actors(), 'Riolu leaves with the Schoolgirl when declined')
        shot('03-declined')

        restore_choice()
        m.write('wPartyCount', 6)
        m.write_bytes('wPartySpecies', party_species)
        run_until(lambda: 'GoldenrodUndergroundGirlPartyFullText' in seen and idle())
        check(not event(scene_events[1]) and not event(scene_events[2]), 'Full party keeps reward pending')
        check(xy(10) == (21, 18) and xy(14) == (22, 18), 'Girl and Riolu remain for a full party')
        shot('04-party-full')
        m.write('wPartyCount', 1)
        m.write('wPartySpecies', 255, 1)
        press('a')
        run_until(lambda: event(scene_events[1]) and idle())
        check(event(scene_events[2]) and m.read('wPartyCount') == 2, 'Pending reward can be collected later')
        check(not actors(), 'Pending reward clears both sprites')

        stage(18)
        press('right', hold=8, wait=30)
        run_until(lambda: bool(m.read('wBattleMode')))
        check(c.position() == (21, 19), 'Row-18 trigger moves the player to (21,19)')
        check(xy(11) == (21, 18), 'Paulie approaches correctly from the row-18 trigger')
        check(xy(14) == (24, 18), 'Row-18 trigger also places Riolu in front of the girl')
        (out / 'verification.json').write_text(json.dumps(dict(checks=checks, pages=pages, movements=movements,
            duration_seconds=movie_frames * 4389 / 262144, battle_count=3,
            setup='Private fixture, level-100 Mew; native scene, battles, movement and audio'), indent=2) + '\n')
        print('VIDEO', out / 'goldenrod-riolu-scene.mp4', flush=True)
    finally:
        recording = False
        if encoder:
            encoder.stdin.close()
            encoder.wait()
        if audio:
            audio.close()
        pb.stop(save=False)


if __name__ == '__main__':
    main()
