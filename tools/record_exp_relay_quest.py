#!/usr/bin/env python3
"""Record Elm's sixth-badge call and lab gift with native input and game audio.

The starting six-badge story state is staged in private RAM in New Bark Town.
The step-triggered call, walk into the lab, dialogue and gift run unmodified.
No player save is loaded or written.
"""
import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants
from probability_checks import call
from ui_checks import tile_text
from record_lance_escort_scenes import Recording


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/exp-relay-quest')
    parser.add_argument('--no-video', action='store_true')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom, sound_emulated=True,
                emulator_kwargs={'sound_sample_rate': 48000})
    pb, m = h.pb, h.battle.mem
    controls, maps = Controls(h), map_ids()
    events = _parse_constants(ROOT / 'constants/event_flags.asm')
    scenes = _parse_constants(ROOT / 'constants/scene_constants.asm')
    recording, frame, capturing = None, 0, False
    texts, checks, registered = [], [], []

    def check(ok, label):
        if not ok:
            pb.screen.image.save(args.output / 'failure.png')
            raise AssertionError(label + '\n' + tile_text(h))
        checks.append(label)
        print('PASS', label, flush=True)

    def event(name, value=None):
        bit = events[name]
        old = m.read('wEventFlags', bit // 8)
        mask = 1 << (bit % 8)
        if value is not None:
            m.write('wEventFlags', old | mask if value else old & ~mask, bit // 8)
        return bool(old & mask)

    def tick(count=1):
        nonlocal frame
        for _ in range(count):
            pb.tick(1, True, True)
            if recording:
                recording.append()
            if capturing and texts and frame == texts[-1]['frame'] + 85:
                pb.screen.image.save(args.output / f'text-{len(texts):02}.png')
            frame += 1

    def text(far):
        pos = int.from_bytes(m.read_bytes('wScriptPos', 2), 'little')
        bank = m.read('wScriptBank')
        if far:
            target_bank, lo, hi = [pb.memory[bank, pos + i] for i in range(3)]
        else:
            target_bank = bank
            lo, hi = [pb.memory[bank, pos + i] for i in range(2)]
        label = h.sym.nearest(target_bank, lo | hi << 8)
        texts.append(dict(label=label, frame=frame))
        print('TEXT', label, flush=True)

    def finish_dialogue(label):
        for elapsed in range(16000):
            if elapsed % 125 == 124:
                pb.button('a', 2)
            tick()
            if elapsed > 60 and not m.read('wScriptMode') and not m.read('wScriptRunning'):
                tick(60)
                return
        check(False, label + ' did not finish')

    try:
        new_game(h, 0)
        # Only the fixture setup is staged. From recording start onward, all
        # phone dispatch, movement, text, portrait and inventory code is native.
        h.tick = tick
        m.write('wOptions', 0x41)
        m.write_bytes('wPlayerName', [0x86, 0x8e, 0x8b, 0x83] + [0x50] * 7)
        for name in ('EVENT_GOT_A_POKEMON_FROM_ELM', 'EVENT_GAVE_MYSTERY_EGG_TO_ELM',
                     'EVENT_ELM_CALLED_ABOUT_STOLEN_POKEMON', 'EVENT_COP_IN_ELMS_LAB',
                     'EVENT_RIVAL_NEW_BARK_TOWN', 'EVENT_GOT_EVERSTONE_FROM_ELM',
                     'EVENT_GOT_SS_TICKET_FROM_ELM', 'EVENT_GOT_MASTER_BALL_FROM_ELM'):
            event(name, True)
        for name in ('EVENT_ELM_CALLED_ABOUT_EXP_RELAY', 'EVENT_GOT_EXP_RELAY_FROM_ELM'):
            event(name, False)
        m.write('wElmsLabSceneID', scenes['SCENE_ELMSLAB_NOTHING'])
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        for species in ('TOTODILE', 'PIDGEOT'):
            sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index(species))
            m.write('wCurPartySpecies', sid)
            m.write('wCurPartyLevel', 30)
            native_call(h, 'TryAddMonToParty')
        group, number = maps['NEW_BARK_TOWN']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                wXCoord=7, wYCoord=5, hMapEntryMethod=0xf1).items():
            m.write(name, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')
        tick(90)
        m.write('wJohtoBadges', 0x3f)
        m.write('wKantoBadges', 0)
        m.write_bytes('wSpecialPhoneCallID', [0, 0])
        for symbol, far in (('Script_writetext', False), ('Script_farwritetext', True)):
            address = h.sym[symbol]
            pb.hook_register(*address, lambda _, far=far: text(far), None)
            registered.append(address)
        if not args.no_video:
            recording = Recording(pb, args.output / 'elm-exp-relay.mp4')
        h.text_overflows.clear()
        capturing = True
        tick(60)
        controls.press('left', hold=4, wait=50)
        # A turn-only tap may precede the first actual step.
        if not m.read('wScriptMode'):
            controls.press('left', hold=4, wait=50)
        finish_dialogue('Elm call')
        check(event('EVENT_ELM_CALLED_ABOUT_EXP_RELAY'), 'sixth-badge call triggered by native walking')
        check(any(t['label'].startswith('ElmPhoneExpRelayText') for t in texts), 'invitation dialogue shown')
        check(not m.read('wSpecialPhoneCallID'), 'invitation cleared its pending call')

        controls.go((6, 3))
        for _ in range(8):
            if controls.map_id() == maps['ELMS_LAB']:
                break
            controls.press('up', hold=4, wait=40)
        tick(90)
        check(controls.map_id() == maps['ELMS_LAB'], 'walked through the lab door')
        controls.go((5, 5))
        check(controls.position() == (5, 5), 'walked to Professor Elm')
        controls.press('up', hold=3, wait=20)
        controls.press('a', hold=3, wait=30)
        finish_dialogue('Elm gift')
        check(event('EVENT_GOT_EXP_RELAY_FROM_ELM'), 'native talk granted the gift')
        inventory = list(m.read_bytes('wKeyItems', m.read('wNumKeyItems')))
        relay = call(h, 'GetItemIDFromIndex', HL=h.con.items['EXP_RELAY'])
        check(inventory.count(relay) == 1, 'exactly one EXP RELAY in Key Items')
        # Routine calls use a sentinel, so resume the overworld before input.
        begin_native_call(h, 'OverworldLoop.loop')
        check(any(t['label'].startswith('ElmExpRelayExplainText') for t in texts), 'full item explanation shown')
        controls.press('a', hold=3, wait=30)
        finish_dialogue('Elm reminder')
        check(any(t['label'].startswith('ElmExpRelayReminderText') for t in texts), 'repeat visit gives instructions')
        check(list(m.read_bytes('wKeyItems', m.read('wNumKeyItems'))).count(relay) == 1,
              'repeat visit did not duplicate the item')
        check(not h.text_overflows, 'no text overflow during the call or lab dialogue: '
              + repr(h.text_overflows))
        tick(90)
        info = recording.finish() if recording else None
        recording = None
        (args.output / 'checks.json').write_text(json.dumps(dict(
            rom=h.rom_key(), checks=checks, texts=texts, video=info,
            fixture='Six badges staged in private RAM; native walking, phone call and lab gift.'), indent=2) + '\n')
    finally:
        if recording:
            recording.encoder.stdin.close()
            recording.encoder.wait()
            recording.audio.close()
        for address in registered:
            pb.hook_deregister(*address)
        pb.stop(save=False)


if __name__ == '__main__':
    main()
