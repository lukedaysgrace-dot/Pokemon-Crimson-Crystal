#!/usr/bin/env python3
"""Record the native Clair -> GS Ball -> Kurt -> Celebi scenario.

Uses a private, freshly bootstrapped test save and a level 100 test party.
Map travel is staged between chapters; the next-day wait uses the native
daily reset. Battles, movement, dialogue and quest flags execute normally.
Requires the debug ROM, PyBoy, Pillow, numpy and an ffmpeg executable.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys
import wave

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from symbols import _parse_constants
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from cove_sprite_checks import native_call
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ffmpeg', default=str(ROOT / '.tmpbuild/video-runtime/imageio_ffmpeg/binaries/ffmpeg-linux-x86_64-v7.0.2'))
    parser.add_argument('--output', type=Path, default=ROOT / '_ai_artifacts/gs-ball/gs-ball-full-scenario.mp4')
    parser.add_argument('--pokecenter-only', action='store_true', help='Record Bill calling and giving the GS Ball; stage Clair as defeated.')
    args = parser.parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    out = args.output.parent
    h = Harness(verbose=True, sound_emulated=True)
    h.ensure_fixture()
    h.load_fixture()
    pb, m = h.pb, h.battle.mem
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    phone = _parse_constants(ROOT / 'constants/phone_constants.asm')
    maps = {}
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s*newgroup\s*(?:;|$)', line):
            group, number = group + 1, 0
        match = re.match(r'\s*map_const (\w+)', line)
        if match:
            number += 1
            maps[match[1]] = group, number

    def event(name, value=None):
        bit = events[name]
        addr = h.sym.addr('wEventFlags') + bit // 8
        old = pb.memory[addr]
        if value is not None:
            pb.memory[addr] = old | (1 << (bit % 8)) if value else old & ~(1 << (bit % 8))
        return bool(pb.memory[addr] & (1 << (bit % 8)))

    # Stage a legal test party before filming, then disable all debug automation.
    request = Request(h.battle)
    m.write('wPartyCount', 0)
    m.write('wMonType', 0)
    address = h.sym.addr('wDebugPlayer1')
    m.write_bytes('wDebugPlayer1', request._side_bytes(dict(
        species='MEW', level=100, moves=['ICE_BEAM', 'THUNDERBOLT', 'SURF', 'FALSE_SWIPE'])))
    call(h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)
    for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wInBattleTowerBattle'):
        m.write(name, 0)
    m.write('wOptions', 0x41)
    m.write('wJohtoBadges', 0x7f)
    m.write('wKantoBadges', 0)
    m.write('wNumKeyItems', 0)
    m.write('wKeyItems', 255)
    m.write('wNumItems', 0)
    m.write('wItems', 255)
    m.write('wNumBalls', 1)
    m.write_bytes('wBalls', [h.con.item_id('MASTER_BALL'), 1, 255])
    for name in ('EVENT_BEAT_CLAIR', 'EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER',
                 'EVENT_CAN_GIVE_GS_BALL_TO_KURT', 'EVENT_GAVE_GS_BALL_TO_KURT',
                 'EVENT_FOREST_IS_RESTLESS'):
        event(name, False)
    for name in ('EVENT_CLEARED_SLOWPOKE_WELL', 'EVENT_KURT_GAVE_YOU_LURE_BALL',
                 'EVENT_GOT_HM01_CUT', 'EVENT_ILEX_FOREST_FARFETCHD',
                 'EVENT_ILEX_FOREST_APPRENTICE', 'EVENT_ILEX_FOREST_CHARCOAL_MASTER'):
        event(name, True)
    m.write('wDailyFlags1', 0)
    m.write('wGoldenrodPokecenter1FSceneID', 0)
    m.write('wAzaleaTownSceneID', 0)

    capture = False
    frames = 0
    heading = footer = ''
    chapters = []
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
    font = ImageFont.truetype(font_path, 18)
    small = ImageFont.truetype(font_path, 14)
    encoder = subprocess.Popen([args.ffmpeg, '-y', '-loglevel', 'error', '-f', 'rawvideo',
        '-pixel_format', 'rgb24', '-video_size', '640x672', '-framerate', '131072/4389',
        '-i', '-', '-an', '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '19',
        '-pix_fmt', 'yuv420p', str(out / 'video-silent.mp4')], stdin=subprocess.PIPE)
    audio = wave.open(str(out / 'audio.wav'), 'wb')
    audio.setnchannels(2)
    audio.setsampwidth(2)
    audio.setframerate(pb.sound.sample_rate)
    def tick(n=1):
        nonlocal frames
        for _ in range(n):
            pb.tick(1, True)
            if capture:
                if frames % 2 == 0:
                    canvas = Image.new('RGB', (640, 672), '#10131b')
                    canvas.paste(pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (0, 48))
                    draw = ImageDraw.Draw(canvas)
                    draw.text((14, 13), heading, font=font, fill='#ffffff')
                    draw.text((14, 635), footer, font=small, fill='#c6d0e8')
                    encoder.stdin.write(canvas.tobytes())
                samples = pb.sound.ndarray.astype(np.int16) * 256
                audio.writeframesraw(samples.tobytes())
                frames += 1
    h.tick = tick

    def chapter(title, detail):
        nonlocal heading, footer
        heading, footer = title, detail
        chapters.append(dict(title=title, seconds=frames * 4389 / 262144))
        print('CHAPTER', title, flush=True)

    def shot(name):
        pb.screen.image.save(str(out / (name + '.png')))
        print('STATE', name, 'map', m.read('wMapGroup'), m.read('wMapNumber'),
              'xy', m.read('wXCoord'), m.read('wYCoord'),
              'script', m.read('wScriptRunning'), m.read('wScriptMode'),
              'PC', hex(pb.register_file.PC), '\n' + tile_text(h), flush=True)

    def stage(name, x, y):
        nonlocal capture
        capture = False
        for key in ('a', 'b', 'up', 'down', 'left', 'right', 'start'):
            pb.button_release(key)
        def prepare(_=None):
            m.write('wDefaultSpawnpoint', 255)
            m.write('wMapGroup', maps[name][0])
            m.write('wMapNumber', maps[name][1])
            m.write('wXCoord', x)
            m.write('wYCoord', y)
            m.write('wScriptRunning', 0)
            m.write('wScriptMode', 0)
            m.write('wScriptStackSize', 0)
            m.write('wMapEventStatus', 0)
            m.write('hMapEntryMethod', 0xf1)
            m.write('wMapStatus', 1)
        if not chapters or frames == 0:
            prepare()
            native_call(h, 'EnterMap')
            begin_native_call(h, 'OverworldLoop.loop')
        else:
            # Change maps at a safe loop boundary, preserving the live CPU stack.
            pending = [True]
            def transition(_):
                if pending[0]:
                    prepare()
                    pending[0] = False
            bank, addr = h.sym['OverworldLoop.loop']
            pb.hook_register(bank, addr, transition, None)
            try:
                for _ in range(120):
                    tick(1)
                    if not pending[0]:
                        break
                assert not pending[0], 'could not reach safe map transition'
            finally:
                pb.hook_deregister(bank, addr)
        tick(90)
        shot('staged-' + name.lower())
        capture = True

    def wait_for(predicate, label, maximum=6000, advance=True, every=36):
        for i in range(maximum):
            if predicate():
                pb.button_release('a')
                tick(60)
                shot(label)
                return
            if advance and i % every == 0:
                pb.button('a', 2)
            tick(1)
        shot('error-' + label)
        raise RuntimeError(f'{label}: timed out; {h.where()}')

    def idle():
        return m.read('wScriptRunning') == 0 and m.read('wScriptMode') == 0 and m.read('wBattleMode') == 0

    def checkpoint(label):
        with open(out / (label + '.state'), 'wb') as f:
            pb.save_state(f)

    try:
        if args.pokecenter_only:
            # Stage the earned victory and its pending call; do not film a battle.
            event('EVENT_BEAT_CLAIR', True)
            m.write('wSpecialPhoneCallID', phone['SPECIALCALL_BILL_GS_BALL'])
            chapter('Bill calls after Clair has been defeated', 'Private test save | Clair victory staged | Invitation and handoff run natively')
            stage('GOLDENROD_CITY', 15, 29)
            h.press('up', hold=8, wait=40)
            wait_for(lambda: m.read('wSpecialPhoneCallID') == 0 and idle(), '01-bill-invitation', every=90)
            assert m.read('wCurCaller') == phone['PHONE_BILL']
            checkpoint('01-bill-invitation')
            chapter('Goldenrod: Bill has an unusual Poké Ball', 'Bill explains the old collection and asks you to take the GS Ball to Kurt')
            h.press('up', hold=8, wait=120)
            h.press('up', hold=8, wait=90)
            wait_for(lambda: event('EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER') and idle(), '02-bill-gs-ball-handoff', every=90)
            assert event('EVENT_CAN_GIVE_GS_BALL_TO_KURT')
            assert m.read('wNumKeyItems') == 1 and m.read('wKeyItems') == h.con.item_id('GS_BALL')
            assert not h.text_overflows, h.text_overflows
            checkpoint('02-bill-gs-ball-handoff')
            chapter('GS Ball received: take it to Kurt in Azalea Town', 'Bill invitation and Pokémon Center handoff verified')
            tick(150)
            (out / 'chapters.json').write_text(json.dumps(chapters, indent=2))
            print('PASS: Bill invitation and native GS Ball handoff', frames, 'frames', flush=True)
            return

        chapter('Before Clair: GS Ball is unavailable', 'Private test save | Travel between chapters is skipped')
        stage('GOLDENROD_CITY', 15, 28)
        tick(90)
        h.press('up', hold=16, wait=120)
        h.press('up', hold=8, wait=90)
        tick(120)
        assert not event('EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER')
        shot('01-before-clair')
        checkpoint('01-before-clair')

        chapter('Defeat Clair in Blackthorn Gym', 'Native battle | Level 100 test party | Battle automation disabled')
        stage('BLACKTHORN_GYM_1F', 5, 4)
        h.press('up', hold=8, wait=24)
        h.press('a', hold=2, wait=30)
        wait_for(lambda: event('EVENT_BEAT_CLAIR') and idle(), '02-clair-defeated', maximum=30000)
        assert m.read('wJohtoBadges') == 0x7f, 'must unlock before Rising Badge ceremony'
        checkpoint('02-clair-defeated')

        chapter('Bill calls outside Blackthorn Gym', 'Native invitation after Clair victory | Travel skipped')
        stage('BLACKTHORN_CITY', 18, 13)
        h.press('up', hold=8, wait=40)
        wait_for(lambda: m.read('wSpecialPhoneCallID') == 0 and idle(), '02-bill-invitation', every=90)
        assert m.read('wCurCaller') == phone['PHONE_BILL']

        chapter('Goldenrod: receive the GS Ball from Bill', 'Unlocked by defeating Clair | Travel skipped')
        stage('GOLDENROD_CITY', 15, 28)
        h.press('up', hold=16, wait=120)
        h.press('up', hold=8, wait=90)
        wait_for(lambda: event('EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER') and idle(), '03-gs-ball-received')
        assert event('EVENT_CAN_GIVE_GS_BALL_TO_KURT')
        checkpoint('03-gs-ball-received')

        chapter('Azalea Town: give the GS Ball to Kurt', 'Native dialogue and item handoff | Travel skipped')
        stage('KURTS_HOUSE', 3, 3)
        h.press('up', hold=8, wait=24)
        h.press('a', hold=2, wait=30)
        wait_for(lambda: event('EVENT_GAVE_GS_BALL_TO_KURT') and idle(), '04-kurt-takes-ball')
        assert m.read('wNumKeyItems') == 0
        checkpoint('04-kurt-takes-ball')

        chapter('Kurt needs until tomorrow', 'Same-day check: he is still examining the GS Ball')
        stage('KURTS_HOUSE', 14, 4)
        h.press('up', hold=8, wait=24)
        h.press('a', hold=2, wait=30)
        wait_for(idle, '05-kurt-still-checking')
        assert not event('EVENT_FOREST_IS_RESTLESS')
        shot('05-same-day-wait')

        chapter('The next day: Kurt notices the forest', 'Overnight wait skipped using the native daily reset')
        capture = False
        # Expire the existing one-day countdown; run the actual reset routine.
        m.write('wDailyResetTimer', 0)
        tick(90)  # The live overworld calls CheckDailyResetTimer itself.
        stage('KURTS_HOUSE', 3, 3)
        h.press('up', hold=8, wait=24)
        h.press('a', hold=2, wait=30)
        wait_for(lambda: event('EVENT_FOREST_IS_RESTLESS') and idle(), '06-kurt-runs-out')
        checkpoint('06-kurt-runs-out')
        # Walk to the house exit. The outdoor return scene must fire naturally.
        h.press('down', hold=8, wait=20)
        h.press('down', hold=8, wait=20)
        h.press('down', hold=8, wait=20)
        h.press('down', hold=8, wait=100)
        h.press('down', hold=8, wait=100)
        wait_for(lambda: m.read('wNumKeyItems') == 1 and idle(), '07-kurt-returns-ball')
        checkpoint('07-kurt-returns-ball')

        chapter('Ilex Forest: place the GS Ball in the shrine', 'Native shrine animation and level 30 Celebi encounter | Travel skipped')
        stage('ILEX_FOREST', 8, 23)
        h.press('up', hold=8, wait=24)
        h.press('a', hold=2, wait=30)
        wait_for(lambda: 'FIGHT' in tile_text(h) and m.read('wBattleMode') == 1, '08-celebi-encounter', maximum=10000)
        assert h.battle.enemy.species == 'CELEBI' and h.battle.enemy.level == 30
        assert m.read('wNumKeyItems') == 0 and not event('EVENT_FOREST_IS_RESTLESS')
        checkpoint('08-celebi-encounter')

        chapter('Catch Celebi and speak with Kurt', 'Native bag menu and Master Ball capture')
        # FIGHT/PKMN above PACK/RUN in the retail battle menu.
        h.press('down', hold=8, wait=24)
        h.press('a', hold=8, wait=90)
        shot('09-pack')
        # A new save opens the Items pocket. Move to Balls.
        for _ in range(2):
            if 'MASTER BALL' in tile_text(h):
                break
            h.press('right', hold=8, wait=40)
        shot('10-master-ball')
        assert 'MASTER BALL' in tile_text(h)
        h.press('a', hold=8, wait=36)
        h.press('a', hold=8, wait=36)
        # Advance capture messages, then decline the nickname prompt.
        for i in range(12000):
            text = tile_text(h)
            if 'nickname' in text or 'Give a' in text:
                h.press('b', hold=8, wait=40)
            elif i % 36 == 0:
                pb.button('a', 2)
            tick(1)
            if m.read('wPartyCount') == 2 and idle():
                break
        else:
            raise RuntimeError('capture/Kurt conclusion timed out')
        assert h.con.species_index('CELEBI') == m.species_index_of(m.read('wPartyMon2Species'))
        tick(120)
        shot('11-celebi-caught')
        checkpoint('11-celebi-caught')
        chapter('Complete: Celebi caught', 'Clair -> Goldenrod -> Kurt -> next day -> shrine -> Celebi')
        tick(180)
        (out / 'chapters.json').write_text(json.dumps(chapters, indent=2))
        print('PASS: full native event and capture', frames, 'frames', flush=True)
    finally:
        capture = False
        audio.close()
        encoder.stdin.close()
        encoder.wait()
        pb.stop(save=False)
        subprocess.run([args.ffmpeg, '-y', '-loglevel', 'error', '-i', str(out / 'video-silent.mp4'),
            '-i', str(out / 'audio.wav'), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '128k',
            '-shortest', '-movflags', '+faststart', str(args.output)], check=True)
        print('VIDEO', args.output, flush=True)


if __name__ == '__main__':
    main()
