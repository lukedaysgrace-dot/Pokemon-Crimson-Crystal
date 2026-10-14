#!/usr/bin/env python3
"""Native Cerulean Cave entrance, party gate, palette, exit and video checks.

Only the initial party, caught flag, active Repel and starting position are
staged in private emulator memory. Ordinary buttons run the map scripts.
"""
import argparse
import json
import re
import subprocess
import wave
from pathlib import Path

import numpy as np

from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from overworld_controls import Controls
from ui_checks import tile_text
from symbols import ROOT, _parse_constants
from safari_ui_checks import map_ids

OUTPUT = ROOT / '_artifacts/cerulean-cave'


class Recording:
    def __init__(self, h, name):
        import imageio_ffmpeg
        self.h, self.name = h, name
        self.frames, self.audio = 0, []
        self.raw = OUTPUT / (name + '-silent.mp4')
        self.encoder = imageio_ffmpeg.get_ffmpeg_exe()
        self.process = subprocess.Popen([
            self.encoder, '-y', '-loglevel', 'error', '-f', 'rawvideo',
            '-pixel_format', 'rgb24', '-video_size', '160x144', '-framerate', '59.7275',
            '-i', '-', '-vf', 'scale=640:576:flags=neighbor', '-c:v', 'libx264',
            '-preset', 'veryfast', '-crf', '18', '-pix_fmt', 'yuv420p', str(self.raw),
        ], stdin=subprocess.PIPE)

    def frame(self):
        self.process.stdin.write(self.h.pb.screen.image.convert('RGB').tobytes())
        self.frames += 1
        sound = self.h.pb.sound
        # raw_buffer_head counts interleaved values, not stereo sample pairs.
        # PyBoy's ndarray accessor in this version can include stale samples.
        samples = np.frombuffer(sound.raw_buffer, dtype=np.int8,
                                count=sound.raw_buffer_head).reshape(-1, 2)
        self.audio.append(samples.astype(np.int16) * 256)

    def finish(self):
        self.process.stdin.close()
        if self.process.wait():
            raise RuntimeError('video encoding failed')
        samples = np.concatenate(self.audio)
        rate = self.h.pb.sound.sample_rate
        target = round(self.frames / 59.7275 * rate)
        if len(samples) < target:
            samples = np.pad(samples, ((0, target-len(samples)), (0,0)))
        wav = OUTPUT / (self.name + '.wav')
        with wave.open(str(wav), 'wb') as sound:
            sound.setnchannels(2)
            sound.setsampwidth(2)
            sound.setframerate(rate)
            sound.writeframes(samples[:target].astype('<i2').tobytes())
        final = OUTPUT / (self.name + '.mp4')
        subprocess.run([
            self.encoder, '-y', '-loglevel', 'error', '-i', str(self.raw), '-i', str(wav),
            '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k', '-af', 'highpass=f=30',
            '-shortest', '-movflags', '+faststart', str(final),
        ], check=True)
        print('VIDEO', final, f'{self.frames / 59.7275:.1f}s', flush=True)
        return final


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-video',action='store_true',help='Run checks without encoding the two demonstration videos.')
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness(sound_emulated=True)
    h.ensure_fixture()
    m, c, maps = h.battle.mem, Controls(h), map_ids()
    active = [None]
    original_tick = h.tick
    checks = []
    palette_trace, sounds, airborne_frames = [], [], []

    def tick(frames=1):
        for _ in range(frames):
            original_tick(1)
            if c.map_id() == maps['ROUTE_4'] and m.read('wScriptMode'):
                offset = m.read('wObjectStructs',0x1a) # player's signed jump Y offset
                if offset >= 128:
                    airborne_frames.append(offset)
                    if offset == 244: # peak of the native -12px jump arc
                        h.pb.screen.image.save(str(OUTPUT / 'blocked-kickback-midair.png'))
            if active[0]:
                active[0].frame()
    h.tick = tick

    def palette(_):
        palette_trace.append(m.read_bytes('wOBPals1', 8, 7*8))

    def sound(_):
        registers = h.pb.register_file
        sounds.append(registers.D * 256 + registers.E)

    for label, callback in [('CeruleanCaveMewPinkFlash.UpdateObjects', palette), ('PlaySFX', sound)]:
        bank, address = h.sym[label]
        h.pb.hook_register(bank, address, callback, None)

    def check(condition, message):
        if not condition:
            h.pb.screen.image.save(str(OUTPUT / 'failure.png'))
            raise AssertionError(message + '\n' + tile_text(h) + '\n' + str(c.position()))
        checks.append(message)
        print('PASS', message, flush=True)

    def wait_for(predicate, limit=1200, advance=False):
        for _ in range(limit):
            if predicate():
                return
            if advance:
                h.pb.button('a',2)
            h.tick(4)
        raise RuntimeError('Map event timeout: ' + h.where() + '\n' + tile_text(h))

    def stage(species, caught, position=(34,5), map_name='ROUTE_4', mewtwo_gone=False):
        h.load_fixture()
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        request, address = Request(h.battle), h.sym.addr('wDebugPlayer1')
        for slot, name in enumerate(species):
            m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species=name, level=70, moves=['SPLASH','SURF'])))
            call(h, 'DebugBuildPartyMon', B=slot, D=address >> 8, E=address & 255)
        index = h.con.species_index('MEW') - 1
        byte = m.read('wPokedexCaught', index // 8)
        mask = 1 << (index & 7)
        m.write('wPokedexCaught', (byte | mask) if caught else (byte & ~mask), index // 8)
        event = _parse_constants(ROOT / 'constants/event_flags.asm')['EVENT_SILVER_CAVE_ROOM_2_MEWTWO']
        byte = m.read('wEventFlags',event//8)
        m.write('wEventFlags',(byte | (1<<(event&7))) if mewtwo_gone else (byte & ~(1<<(event&7))),event//8)
        for name in ('wDebugState','hDebugActive','hDebugRNGMode','wLinkMode','wStatusFlags2','wInBattleTowerBattle'):
            m.write(name,0)
        m.write('wOptions',1)
        m.write('wRepelEffect',255)
        m.write('wDefaultSpawnpoint',255)
        m.write('wMapGroup',maps[map_name][0])
        m.write('wMapNumber',maps[map_name][1])
        m.write('wXCoord',position[0])
        m.write('wYCoord',position[1])
        m.write('hMapEntryMethod',0xF1)
        begin_native_call(h,'OverworldLoop')
        h.tick(180)
        wait_for(lambda: m.read('wScriptMode') == 0 and m.read('wMapStatus') == 2)
        palette_trace.clear()
        sounds.clear()
        airborne_frames.clear()
        check(c.map_id() == maps[map_name] and c.position() == position, 'initial native map load: '+map_name)

    def approach():
        c.press('up',hold=4,wait=36)
        if c.position() == (34,5):
            c.press('up',hold=4,wait=36)
        check(c.position() == (34,4), 'approach tile does not warp through the gate')
        c.press('up',hold=4,wait=36)

    def blocked(name, record=False):
        if record:
            active[0] = Recording(h,name)
            h.tick(90)
        approach()
        wait_for(lambda: 'a barrier blocking' in tile_text(h))
        h.tick(120)
        h.pb.screen.image.save(str(OUTPUT / (name+'-barrier.png')))
        check(c.map_id() == maps['ROUTE_4'] and c.position() == (34,5), 'barrier kicks the player two tiles back to Route 4')
        check(bool(airborne_frames),'knockback visibly lifts the player into the air')
        # Continue the scrolling text and close the native textbox.
        c.press('a',hold=4,wait=60)
        h.tick(120)
        for _ in range(8):
            if m.read('wScriptMode') == 0:
                break
            c.press('b',hold=4,wait=36)
        check('Route4CaveBarrierText' in h.battle.textbox_contexts, 'requested barrier text displayed')
        sound_id = h.con.sfx['SFX_GEN1_GLARE'] if hasattr(h.con,'sfx') else None
        if sound_id is None:
            sound_id = _parse_constants(ROOT / 'constants/sfx_constants.asm')['SFX_GEN1_GLARE']
        check(sound_id in sounds, 'Gen 1 Glare SFX played during knockback')
        check(not palette_trace, 'blocked entry does not show the Mew flash')
        check(not h.text_overflows,'barrier dialogue fits the textbox')
        h.tick(90)
        if record:
            video, active[0] = active[0], None
            video.finish()

    def admitted(name, record=False):
        before_palette = m.read_bytes('wOBPals1',8,7*8)
        if record:
            active[0] = Recording(h,name)
            h.tick(90)
        approach()
        wait_for(lambda: 'MEW' in tile_text(h))
        h.tick(90)
        h.pb.screen.image.save(str(OUTPUT / (name+'-mew.png')))
        check(c.position() == (34,5) and bool(airborne_frames),'Mew appears after the same airborne kickback')
        check(any(obj['map_object'] == 7 and obj['next'] == [33,5] for obj in c.objects()), 'party Mew appears beside the player')
        check('Route4CaveMewText' in h.battle.textbox_contexts, 'Mew says MEW!')
        c.press('a',hold=4,wait=20)
        # A pressed while the cry is playing is deliberately ignored by
        # waitsfx; keep giving ordinary button taps until waitbutton accepts.
        wait_for(lambda: bool(palette_trace),advance=True)
        h.tick(3)
        h.pb.screen.image.save(str(OUTPUT / (name+'-pink-flash.png')))
        wait_for(lambda: 'MEW broke the' in tile_text(h) and 'barrier' in tile_text(h))
        h.tick(120)
        h.pb.screen.image.save(str(OUTPUT / (name+'-barrier-broken.png')))
        check(len(palette_trace) == 7,'the barrier-broken message follows all three pink pulses')
        check(c.map_id() == maps['ROUTE_4'] and 'Route4CaveBarrierBrokenText' in h.battle.textbox_contexts,'MEW broke the barrier! is displayed before entry')
        c.press('a',hold=4,wait=24)
        wait_for(lambda: c.map_id() == maps['CERULEAN_CAVE_1F'] and m.read('wMapStatus') == 2)
        h.tick(120)
        h.pb.screen.image.save(str(OUTPUT / (name+'-inside.png')))
        check(c.map_id() == maps['CERULEAN_CAVE_1F'], 'Mew opens the way into restored Cerulean Cave 1F')
        check(len(palette_trace) == 7 and palette_trace[-1] == before_palette, 'three pink pulses restore the original OBJ palette')
        check('Route4CaveBarrierText' not in h.battle.textbox_contexts, 'successful entry does not show barrier text')
        check(not h.text_overflows,'Mew and barrier-broken dialogue fit the textbox')
        if record:
            video, active[0] = active[0], None
            video.finish()
        # The actual cave exit must return safely to the floor anchor outside.
        for _ in range(4):
            if c.map_id() == maps['ROUTE_4']:
                break
            c.press('down',hold=4,wait=60)
        wait_for(lambda: c.map_id() == maps['ROUTE_4'] and m.read('wMapStatus') == 2)
        h.tick(60)
        check(c.position() == (34,4), 'cave exit returns to Route 4 at (34,4)')
        check(not any(obj['map_object'] == 7 for obj in c.objects()), 'party Mew is hidden again after exiting')

    try:
        stage(['PIDGEOT'],False)
        blocked('blocked-kickback',record=not args.no_video)
        stage(['PIDGEOT','MEW'],True)
        admitted('mew-breaks-barrier',record=not args.no_video)
        stage(['PIDGEOT'],True)
        blocked('caught-mew-in-box')
        stage(['MEW'],False)
        blocked('party-mew-not-caught')

        # Walk onto every restored ladder and verify its native destination.
        floors = ['CERULEAN_CAVE_1F','CERULEAN_CAVE_2F','CERULEAN_CAVE_B1F']
        sources = {name:'CeruleanCave'+name.removeprefix('CERULEAN_CAVE_') for name in floors}
        warps = {}
        for name,filename in sources.items():
            text = (ROOT / f'maps/{filename}.asm').read_text()
            warps[name] = [(int(x),int(y),target,int(number)) for x,y,target,number in
                           re.findall(r'warp_event\s+(\d+),\s*(\d+),\s*(\w+),\s*(\d+)',text)]
        collisions = (ROOT / 'data/tilesets/cerulean_cave_collision.bin').read_bytes()
        for name in floors:
            blocks = (ROOT / f'maps/{sources[name]}.ablk').read_bytes()
            def collision(x,y):
                if not (0 <= x < 34 and 0 <= y < 22):
                    return 7
                block = blocks[(y//2)*17+x//2]
                return collisions[block*4+(y&1)*2+(x&1)]
            for number,(x,y,target,destination) in enumerate(warps[name],1):
                if target not in floors:
                    continue # Route 4 exit was exercised above.
                check(collision(x,y) >> 4 == 7,f'{name} warp {number} is on a warp collision')
                candidates = [(x,y+1,'up'),(x-1,y,'right'),(x+1,y,'left'),(x,y-1,'down')]
                adjacent = next((entry for entry in candidates if collision(entry[0],entry[1]) in (0,0x18)),None)
                check(adjacent is not None,f'{name} warp {number} has a walkable approach')
                sx,sy,button = adjacent
                stage(['MEW'],True,position=(sx,sy),map_name=name)
                check(m.read('wCurMapWarpCount') == len(warps[name]),f'{name} compiled warp count matches its restored floor')
                for _ in range(4):
                    if c.map_id() != maps[name]:
                        break
                    c.press(button,hold=4,wait=60)
                wait_for(lambda: c.map_id() == maps[target] and m.read('wMapStatus') == 2)
                tx,ty,back,back_number = warps[target][destination-1]
                check(back == name and back_number == number,f'{name} warp {number} has a reciprocal destination')
                check(c.position() == (tx,ty),f'{name} warp {number} reaches {target} at ({tx},{ty})')
                h.pb.screen.image.save(str(OUTPUT / f'{name.lower()}-warp-{number}.png'))
        stage(['MEW'],True,position=(7,14),map_name='CERULEAN_CAVE_B1F')
        check(any(obj['map_object'] == 1 and obj['next'] == [7,13] for obj in c.objects()),'existing Mewtwo encounter is visible on the bottom floor')
        h.pb.screen.image.save(str(OUTPUT / 'mewtwo-bottom-floor.png'))
        c.press('up',hold=4,wait=36)
        c.press('a',hold=4,wait=36)
        phrases = ['That power','it is familiar','MEW','You have brought','the one from which',
                   'I was created','But we are not','the same']
        seen = set()
        for frame in range(3000):
            text = tile_text(h)
            if 'CeruleanCaveMewtwoBeforeBattleText' in h.battle.textbox_contexts:
                seen.update(phrase for phrase in phrases if phrase in text)
            if m.read('wBattleMode') and 'FIGHT' in text:
                break
            if frame % 30 == 29:
                h.pb.button('a',2)
            h.tick(4)
        else:
            raise RuntimeError('Mewtwo dialogue did not reach battle: '+h.where()+'\n'+tile_text(h))
        check(seen == set(phrases),'Mewtwo delivers all four requested lines before attacking')
        check(h.battle.enemy.species == 'MEWTWO' and m.read('wEnemyMonLevel') == 70,'Mewtwo dialogue starts the existing level-70 battle')
        check(not h.text_overflows,'Mewtwo dialogue fits the textbox')
        h.pb.screen.image.save(str(OUTPUT / 'mewtwo-battle-after-dialogue.png'))
        stage(['MEW'],True,position=(7,14),map_name='CERULEAN_CAVE_B1F',mewtwo_gone=True)
        check(not any(obj['map_object'] == 1 for obj in c.objects()),'an existing save with Mewtwo gone keeps it gone after relocation')
        (OUTPUT / 'checks.json').write_text(json.dumps(dict(checks=checks, count=len(checks)),indent=2))
        print(f'CERULEAN CAVE: {len(checks)} checks passed',flush=True)
    finally:
        if active[0]:
            video,active[0] = active[0],None
            video.finish()
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
