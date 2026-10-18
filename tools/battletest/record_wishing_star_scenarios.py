#!/usr/bin/env python3
"""Readable, real-time quest footage; only buttons may change a running chapter.

Main chapters retain their checkpoint state and show native walking, Fly,
doors, and map connections. Alternate scenarios have explicitly titled
checkpoint starts. Fixture edits and clock changes are forbidden while the
recorder is active. No game code is patched and no event is abbreviated.
"""
import argparse
import faulthandler
from collections import deque
import hashlib
import io
import json
import re
import subprocess
import sys
import signal
import wave

from PIL import Image, ImageDraw, ImageFont
import numpy as np

from runner import Harness
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from probability_checks import call
from overworld_controls import Controls
from safari_ui_checks import map_ids
from symbols import ROOT, _parse_constants
from state import Request
from ui_checks import tile_text

sys.path.insert(0, str(ROOT / '.tmpbuild/video-runtime'))
import imageio_ffmpeg

OUTPUT = ROOT / '_artifacts/wishing-star-full-video'
FPS = 59.7275


class Movie:
    def __init__(self, session, name, title, subtitle):
        self.s, self.name, self.frames = session, name, 0
        self.silent = OUTPUT / f'{name}-silent.mp4'
        self.wav = OUTPUT / f'{name}.wav'
        self.final = OUTPUT / f'{name}.mp4'
        self.encoder = imageio_ffmpeg.get_ffmpeg_exe()
        self.process = subprocess.Popen([self.encoder, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '640x640',
            '-framerate', str(FPS), '-i', '-', '-c:v', 'libx264', '-preset', 'veryfast',
            '-crf', '18', '-pix_fmt', 'yuv420p', str(self.silent)], stdin=subprocess.PIPE)
        self.sound = wave.open(str(self.wav), 'wb')
        self.sound.setnchannels(2)
        self.sound.setsampwidth(2)
        self.sound.setframerate(48000)
        self.header = Image.new('RGB', (640, 64), '#171b29')
        draw = ImageDraw.Draw(self.header)
        font = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
        draw.text((14, 6), title, font=ImageFont.truetype(font, 21), fill='#fff2bf')
        draw.text((14, 35), subtitle, font=ImageFont.truetype(font, 14), fill='white')
        self.pages = []

    def frame(self):
        canvas = Image.new('RGB', (640, 640))
        canvas.paste(self.header, (0, 0))
        canvas.paste(self.s.pb.screen.image.convert('RGB').resize((640, 576), Image.Resampling.NEAREST), (0, 64))
        self.process.stdin.write(canvas.tobytes())
        sound = self.s.pb.sound
        samples = np.frombuffer(sound.raw_buffer, dtype=np.int8, count=sound.raw_buffer_head)
        self.sound.writeframesraw((samples.astype(np.int16) * 256).astype('<i2').tobytes())
        self.frames += 1

    def finish(self):
        self.process.stdin.close()
        if self.process.wait():
            raise RuntimeError('Video encoding failed')
        self.sound.close()
        subprocess.run([self.encoder, '-y', '-loglevel', 'error', '-i', str(self.silent),
            '-i', str(self.wav), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '160k',
            '-af', 'highpass=f=30', '-shortest', '-movflags', '+faststart', str(self.final)], check=True)
        (OUTPUT / f'{self.name}-pages.json').write_text(json.dumps(self.pages, indent=2) + '\n')
        print('VIDEO', self.name, round(self.frames / FPS, 1), 'seconds', flush=True)


class Session:
    def __init__(self):
        faulthandler.register(signal.SIGUSR1)
        OUTPUT.mkdir(parents=True, exist_ok=True)
        self.h = Harness(sound_emulated=True, emulator_kwargs={'sound_sample_rate': 48000})
        self.pb, self.m = self.h.pb, self.h.battle.mem
        self.c = Controls(self.h)
        self.maps = map_ids()
        self.map_names = {value: key for key, value in self.maps.items()}
        self.items = _parse_constants(ROOT / 'constants/item_constants.asm')
        self.sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
        self.events = _parse_constants(ROOT / 'constants/event_flags.asm', const_value_equs=('NUM_EVENTS',))
        self.engine = _parse_constants(ROOT / 'constants/engine_flags.asm')
        self.frames, self.deadline, self.movie = 0, None, None
        self.page_signature = None
        self.pages, self.texts = [], []
        self.blocked_actions = set()
        self.warps = {}
        for name in self.maps:
            path = ROOT / 'maps' / (''.join(part.title() for part in name.split('_')) + '.asm')
            # Map source names are matched from map_attributes, avoiding title-case acronyms.
        attrs = (ROOT / 'data/maps/attributes.asm').read_text()
        self.source_names = dict((constant, label) for label, constant in re.findall(
            r'map_attributes\s+(\w+),\s*(\w+),', attrs))
        for constant, label in self.source_names.items():
            path = ROOT / 'maps' / f'{label}.asm'
            self.warps[constant] = [(int(x), int(y), target, int(number)) for x, y, target, number in
                re.findall(r'warp_event\s+(\d+),\s*(\d+),\s*(\w+),\s*(\d+)', path.read_text())] if path.exists() else []
        self.connections = {}
        self.connection_offsets = {}
        self.dimensions = {name: (int(width) * 2, int(height) * 2) for name, width, height in re.findall(
            r'map_const\s+(\w+),\s*(\d+),\s*(\d+)', (ROOT / 'constants/map_constants.asm').read_text())}
        current = None
        for line in attrs.splitlines():
            match = re.search(r'map_attributes\s+\w+,\s*(\w+),', line)
            if match:
                current = match[1]
            match = re.search(r'connection\s+(\w+),\s*\w+,\s*(\w+),\s*(-?\d+)', line)
            if match:
                self.connections[current, match[2]] = match[1]
                self.connection_offsets[current, match[2]] = int(match[3]) * 2
        self.h.tick = self.tick
        for label in ('WaitPressAorB_BlinkCursor', 'JoyWaitAorB', 'ButtonSound.wait_input'):
            if label in self.h.sym.by_name:
                bank, address = self.h.sym[label]
                self.pb.hook_register(bank, address, self.page, label)
        bank, address = self.h.sym['Script_yesorno']
        self.pb.hook_register(bank, address, lambda _: setattr(self, 'deadline', None), None)
        bank, address = self.h.sym['Script_writetext']
        self.pb.hook_register(bank, address, self.script_text, None)

    def tick(self, count=1):
        for _ in range(count):
            self.pb.tick(1, True, True)
            self.frames += 1
            if self.movie:
                self.movie.frame()
                if self.movie.frames % 3600 == 0:
                    print('PROGRESS', self.movie.name, round(self.movie.frames / FPS), self.name(),
                          self.c.position(), hex(self.pb.register_file.PC), 'page deadline', self.deadline, flush=True)
                    self.pb.screen.image.save(OUTPUT / 'current-recording.png')
                    print('SCREEN', repr(tile_text(self.h)[-85:]), flush=True)

    def page(self, context):
        text = tile_text(self.h)
        signature = context, text
        if signature == self.page_signature:
            return
        self.page_signature = signature
        # Completed text waits get a readable pause, rather than rapid A mashing.
        self.deadline = self.frames + 165
        entry = dict(seconds=round((self.movie.frames if self.movie else 0) / FPS, 2), text=text)
        self.pages.append(entry)
        if self.movie:
            self.movie.pages.append(entry)

    def script_text(self, _):
        bank = self.m.read('wScriptBank')
        pos = int.from_bytes(self.m.read_bytes('wScriptPos', 2), 'little')
        self.texts.append((bank, self.pb.memory[bank, pos] | self.pb.memory[bank, pos + 1] << 8))

    def press(self, button, hold=4, wait=24):
        self.deadline = None
        self.page_signature = None
        self.pb.button(button, hold)
        if self.movie and self.name() == 'ROUTE_3':
            self.save('route3-diagnostic')
            print('STEP', self.c.position(), button, flush=True)
        self.tick(hold + wait)

    def drive(self, predicate, limit=36000, pages=True):
        for _ in range(0, limit, 4):
            if predicate():
                return
            if pages and self.deadline is not None and self.frames >= self.deadline:
                self.deadline = None
                self.pb.button('a', 8)
            self.tick(4)
        self.pb.screen.image.save(OUTPUT / 'failure.png')
        raise RuntimeError('Timeout ' + str((self.name(), self.c.position(), self.m.read('wScriptMode'),
            self.m.read('wBattleMode'), self.pb.register_file.PC)) + '\n' + tile_text(self.h))

    def name(self):
        return self.map_names.get(self.c.map_id(), str(self.c.map_id()))

    def idle(self):
        return (not self.m.read('wBattleMode') and not self.m.read('wScriptMode')
                and not self.m.read('hInMenu') and self.m.read('wMapStatus') == 2)

    def choice(self):
        text = tile_text(self.h)
        return 'YES' in text and 'NO' in text

    def choose(self, yes):
        self.drive(self.choice)
        self.tick(90)
        self.press('a' if yes else 'b')

    def settle(self):
        self.drive(self.idle)
        self.tick(50)

    def talk(self, direction, yes=None):
        facing = {'down': 0, 'up': 4, 'left': 8, 'right': 12}[direction]
        if self.m.read('wPlayerDirection') & 12 != facing:
            self.press(direction)
        self.press('a')
        if yes is not None:
            self.choose(yes)
        self.settle()

    def event(self, name, value=None):
        index = self.events[name]
        address, mask = self.h.sym.addr('wEventFlags') + index // 8, 1 << (index % 8)
        if value is not None:
            assert self.movie is None, 'Fixture writes are forbidden during a recording'
            self.pb.memory[address] = self.pb.memory[address] | mask if value else self.pb.memory[address] & ~mask
        return bool(self.pb.memory[address] & mask)

    def write(self, name, value):
        assert self.movie is None, 'Fixture writes are forbidden during a recording'
        if isinstance(value, (bytes, bytearray, list, tuple)):
            self.m.write_bytes(name, value)
        else:
            self.m.write(name, value)

    def clock(self, day, hour):
        self.write('wStringBuffer2', [day, hour, 0, 0])
        call(self.h, '_InitTime')
        call(self.h, 'UpdateTime')

    def keys(self, names):
        self.write('wNumKeyItems', len(names))
        self.write('wKeyItems', [self.items[name] for name in names] + [255])

    def save(self, name):
        with (OUTPUT / f'{name}.state').open('wb') as stream:
            self.pb.save_state(stream)

    def load(self, name):
        assert self.movie is None
        with (OUTPUT / f'{name}.state').open('rb') as stream:
            self.pb.load_state(stream)
        self.deadline = None
        self.texts.clear()
        self.allow_travel()

    def allow_travel(self):
        self.write('wTMsHMs', [1] * (self.h.sym.addr('wTMsHMsEnd') - self.h.sym.addr('wTMsHMs')))
        for name in self.events:
            if name.startswith('EVENT_GOT_HM'):
                self.event(name, True)
        self.write('wMountMoonSceneID', 1) # Endgame fixture: the unrelated rival fight is already over.

    def stage_map(self, name, xy):
        assert self.movie is None
        for label, value in (('wMapGroup', self.maps[name][0]), ('wMapNumber', self.maps[name][1]),
                             ('wXCoord', xy[0]), ('wYCoord', xy[1]), ('wDefaultSpawnpoint', 255), ('hMapEntryMethod', 0xf1)):
            self.write(label, value)
        begin_native_call(self.h, 'OverworldLoop')
        self.tick(180)
        self.settle()

    def start(self, name, title, subtitle='Full events, normal game speed, original game audio'):
        assert self.movie is None
        self.deadline = None
        self.movie = Movie(self, name, title, subtitle)
        self.tick(90)
        print('RECORD', name, self.name(), self.c.position(), flush=True)

    def finish(self, checkpoint=None):
        self.tick(90)
        movie, self.movie = self.movie, None
        movie.finish()
        if checkpoint:
            self.save(checkpoint)

    def path(self, goal):
        start = self.c.position()
        solid = [o for o in self.c.objects() if o['sprite'] != self.sprites['SPRITE_ROCK']]
        blocked = {tuple(o['position']) for o in solid} | {tuple(o['next']) for o in solid}
        blocked |= {(x, y) for x, y, _, _ in self.warps.get(self.name(), []) if (x, y) != tuple(goal)}
        width, height = self.m.read('wMapWidth') * 2, self.m.read('wMapHeight') * 2
        parents, todo = {start: None}, deque([start])
        directions = ((0, -1, 'up'), (-1, 0, 'left'), (1, 0, 'right'), (0, 1, 'down'))
        hops = ({'right'}, {'left'}, {'up'}, {'down'}, {'down', 'right'}, {'down', 'left'}, {'up', 'right'}, {'up', 'left'})
        while todo:
            current = todo.popleft()
            if current == tuple(goal):
                result = []
                while parents[current] is not None:
                    previous, button = parents[current]
                    result.append(button)
                    current = previous
                return result[::-1]
            for dx, dy, button in directions:
                if (self.name(), current, button) in self.blocked_actions:
                    continue
                nxt = current[0] + dx, current[1] + dy
                source = self.c.collision(*current)
                if (source >> 4 == 0xa and button in hops[source & 7]
                        and not self.c.permits_step(current, nxt, button)):
                    # Native ledge jumps cross the wall tile and land two
                    # coordinates away; the intermediate wall is not a stop.
                    nxt = current[0] + dx * 2, current[1] + dy * 2
                x, y = nxt
                if not (0 <= x < width and 0 <= y < height) or nxt in blocked:
                    continue
                collision = self.c.collision(x, y)
                if collision >> 4 == 0xa:
                    # The native ledge step decides its landing. Replan from
                    # the observed position after the jump, never force it.
                    pass
                elif collision >> 4 == 2 and collision not in (0x27, 0x24, 0x26):
                    pass # Surf is initiated through its normal field prompt while walking.
                elif not self.c.permits_step(current, nxt, button):
                    continue
                if nxt not in parents:
                    parents[nxt] = current, button
                    todo.append(nxt)
        raise RuntimeError(f'No path: {self.name()} {start} -> {goal}\n' + '\n'.join(self.c.grid()))

    def walk(self, goal, expected_map=None):
        origin = self.c.map_id()
        stalled = 0
        for _ in range(1500):
            if self.c.map_id() != origin or self.c.position() == tuple(goal):
                break
            if not self.idle():
                self.drive(lambda: self.idle() or self.choice())
                if self.choice():
                    if 'another' in tile_text(self.h).lower() or 'repel' in tile_text(self.h).lower():
                        self.choose(True)
                        self.settle()
                    elif 'MOM' in tile_text(self.h) and 'money' in tile_text(self.h).lower():
                        self.choose(False)
                        self.settle()
                    else:
                        raise RuntimeError('Unexpected walking choice: ' + tile_text(self.h))
            previous = self.c.position()
            button = self.path(goal)[0]
            dx, dy = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}[button]
            next_xy = previous[0] + dx, previous[1] + dy
            if any(tuple(o['position']) == next_xy and o['sprite'] == self.sprites['SPRITE_ROCK'] for o in self.c.objects()):
                self.press(button)
                self.press('a')
                self.choose(True)
                self.drive(lambda: self.idle() or (self.m.read('wBattleMode') and 'FIGHT' in tile_text(self.h)))
                if self.m.read('wBattleMode'):
                    self.battle_end('escape')
                continue
            self.press(button, wait=28)
            stalled = stalled + 1 if previous == self.c.position() else 0
            if stalled >= 3:
                dx, dy = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}[button]
                next_collision = self.c.collision(previous[0] + dx, previous[1] + dy)
                if next_collision >> 4 == 2 and self.c.collision(*previous) >> 4 != 2:
                    self.press('a')
                    self.choose(True)
                    self.settle()
                    stalled = 0
                    continue
                self.blocked_actions.add((self.name(), previous, button))
                stalled = 0
        if expected_map:
            self.drive(lambda: self.c.map_id() == self.maps[expected_map], pages=True)
            self.settle()
        print('WALK', self.name(), self.c.position(), flush=True)

    def warp(self, target):
        origin = self.name()
        candidates = [(x, y) for x, y, dest, _ in self.warps[origin] if dest == target and (x, y) != self.c.position()]
        if not candidates:
            raise RuntimeError(f'No warp from {self.name()} to {target}')
        options = []
        for xy in candidates:
            try:
                route = self.path(xy)
                options.append((len(route), xy, route[-1]))
            except RuntimeError:
                pass
        if not options:
            raise RuntimeError(f'No reachable warp from {origin} to {target}')
        _, xy, direction = min(options)
        dx, dy = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}[direction]
        approach = xy[0] - dx, xy[1] - dy
        self.walk(approach)
        for _ in range(3):
            self.press(direction, wait=110)
            if self.c.map_id() == self.maps[target] and (origin != target or self.c.position() not in (approach, xy)):
                break
        self.drive(lambda: self.c.map_id() == self.maps[target]
                   and (origin != target or self.c.position() not in (approach, xy)))
        self.settle()

    def connect(self, target, preferred_coordinate=None):
        direction = self.connections[self.name(), target]
        offset = self.connection_offsets[self.name(), target]
        width, height = self.m.read('wMapWidth') * 2, self.m.read('wMapHeight') * 2
        if direction in ('east', 'west'):
            x = width - 1 if direction == 'east' else 0
            candidates = [(x, y) for y in range(max(0, offset), min(height, offset + self.dimensions[target][1]))]
            delta = (1 if direction == 'east' else -1, 0)
        else:
            y = height - 1 if direction == 'south' else 0
            candidates = [(x, y) for x in range(max(0, offset), min(width, offset + self.dimensions[target][0]))]
            delta = (0, 1 if direction == 'south' else -1)
        options = []
        for xy in candidates:
            try:
                if self.c.passable(self.c.collision(*xy)) and self.c.passable(self.c.collision(xy[0] + delta[0], xy[1] + delta[1])):
                    coordinate = xy[1] if direction in ('east', 'west') else xy[0]
                    preference = abs(coordinate - preferred_coordinate) if preferred_coordinate is not None else 0
                    options.append((preference, len(self.path(xy)), xy))
            except (RuntimeError, IndexError):
                pass
        if not options:
            raise RuntimeError('No connection path: ' + self.name() + ' -> ' + target)
        self.walk(min(options)[2])
        button = {'north': 'up', 'south': 'down', 'east': 'right', 'west': 'left'}[direction]
        for _ in range(4):
            self.press(button, wait=44)
            if self.c.map_id() == self.maps[target]:
                self.settle()
                print('CONNECT', target, self.c.position(), flush=True)
                return
        raise RuntimeError('Connection failed: ' + self.name() + ' -> ' + target)

    def menu(self, needle, steps=20):
        # Read the native cursor glyph, rather than writing a cursor variable.
        for _ in range(steps):
            raw = list(self.m.read_bytes('wTileMap', 360))
            rows = tile_text(self.h).splitlines()
            cursors = [index // 20 for index, value in enumerate(raw) if value == 0xed]
            if any(needle in rows[row] for row in cursors):
                self.tick(30)
                self.press('a', wait=70)
                return
            self.press('down', wait=28)
        raise RuntimeError('Menu selection failed ' + needle + '\n' + tile_text(self.h))

    def fly(self, target):
        self.press('start', wait=70)
        self.menu('MON')
        self.press('a', wait=70)
        self.menu('FLY')
        self.drive(lambda: self.m.read('wVramState') == 0 and self.m.read('wEndFlypoint') > 0, limit=3600, pages=False)
        self.tick(90)
        for _ in range(40):
            if target in tile_text(self.h):
                self.tick(60)
                self.press('a', wait=120)
                self.settle()
                print('FLY', target, self.name(), self.c.position(), flush=True)
                return
            self.press('up', wait=35)
        raise RuntimeError('Fly target not reachable: ' + target + '\n' + tile_text(self.h))

    def build_party(self, level=100, weak=False):
        assert self.movie is None
        self.write('wPartyCount', 0)
        self.write('wMonType', 0)
        moves = ['SPLASH', 'ROCK_SMASH', 'FLY', 'SURF'] if weak else ['SHADOW_BALL', 'ROCK_SMASH', 'FLY', 'SURF']
        address = self.h.sym.addr('wDebugPlayer1')
        self.write('wDebugPlayer1', Request(self.h.battle)._side_bytes(dict(species='MEW', level=level, moves=moves)))
        call(self.h, 'DebugBuildPartyMon', B=0, D=address >> 8, E=address & 255)

    def pocket_names(self, pocket):
        names = []
        attributes = (ROOT / 'data/items/attributes.asm').read_text().splitlines()
        item = None
        for line in attributes:
            if line.startswith('; '):
                item = line[2:].split()[0]
            if line.startswith('\titem_attribute ') and item in self.items:
                fields = [value.strip() for value in line.split('item_attribute ', 1)[1].split(',')]
                if len(fields) == 7 and fields[4] == pocket:
                    names.append(item)
        return names

    def full_items(self):
        names = [name for name in self.pocket_names('ITEM') if name not in ('RARE_CANDY', 'MOON_STONE')][:40]
        assert len(names) == 40
        self.write('wNumItems', 40)
        self.write('wItems', [value for name in names for value in (self.items[name], 1)] + [255])

    def full_keys(self, shard=False):
        names = [name for name in self.pocket_names('KEY_ITEM') if name not in ('STAR_SHARD', 'STAR_PIECE', 'WISHING_STAR')]
        names = (['STAR_SHARD'] + names[:24]) if shard else names[:25]
        assert len(names) == 25
        self.keys(names)

    def toss_first_item(self):
        self.press('start', wait=70)
        self.menu('PACK')
        self.tick(90)
        for _ in range(4):
            if self.m.read('wCurPocket') == 0:
                break
            self.press('left', wait=60)
        self.press('a', wait=65)
        self.menu('TOSS')
        self.tick(90)
        self.press('a', wait=60)
        self.choose(True)
        self.drive(lambda: not self.choice(), pages=True)
        for _ in range(5):
            self.tick(90)
            self.press('b', wait=70)
            if self.idle():
                return
        self.settle()

    def enter_moon(self):
        self.warp('MOUNT_MOON')
        self.warp('MOUNT_MOON')
        self.warp('MOUNT_MOON_SQUARE')

    def final_wish(self, outcome):
        self.walk((25, 9))
        self.press('up')
        self.press('a')
        self.choose(True)
        self.battle_end(outcome)

    def prepare(self):
        new_game(self.h, 0)
        self.build_party()
        for name in ('wDebugState', 'hDebugActive', 'hDebugRNGMode', 'wLinkMode', 'wStatusFlags2'):
            self.write(name, 0)
        self.write('wOptions', 1) # Readable native text speed, battle animation on.
        self.write('wDefaultSpawnpoint', 255)
        self.write('wJohtoBadges', 255)
        self.write('wKantoBadges', 255)
        self.allow_travel()
        self.write('wVisitedSpawns', [255] * 4)
        self.write('wPokegearFlags', 1)
        self.write('wEcruteakPokecenter1FSceneID', 1)
        self.write('wLastSpawnMapGroup', self.maps['ECRUTEAK_CITY'][0])
        self.write('wLastSpawnMapNumber', self.maps['ECRUTEAK_CITY'][1])
        self.write('wMoney', (10000).to_bytes(3, 'big'))
        self.write('wNumItems', 1)
        self.write('wItems', [self.items['MAX_REPEL'], 99, 255])
        self.write('wRepelEffect', 250)
        self.write('wLastRepelUsed', self.items['MAX_REPEL'])
        self.write('wNumBalls', 1)
        self.write('wBalls', [self.items['MASTER_BALL'], 10, 255])
        self.keys([])
        for name in self.events:
            if name.startswith('EVENT_BEAT_'):
                self.event(name, True)
        for name in ('EVENT_OPENED_MT_SILVER', 'EVENT_MT_MOON_RIVAL', 'EVENT_FOUGHT_SUICUNE'):
            self.event(name, True)
        self.clock(5, 18)
        self.stage_map('ECRUTEAK_CITY', (23, 28))
        self.save('base')

    def well(self, yes, side='south'):
        self.walk((25, 9) if side == 'south' else (26, 8))
        self.talk('up' if side == 'south' else 'left', yes)

    def granny(self):
        self.walk((24, 9))
        self.talk('up')

    def moon(self, loot=True):
        self.walk((7, 12))
        self.walk((7, 11))
        self.settle()
        if loot:
            self.walk((7, 8))
            self.talk('up', True) # Full Rock Smash prompt and field animation.
            self.talk('up') # The hidden Moon Stone, and the entire crash if eligible.

    def battle_end(self, outcome):
        self.drive(lambda: self.m.read('wBattleMode') and 'FIGHT' in tile_text(self.h))
        self.tick(90)
        if outcome == 'capture':
            self.press('down')
            self.press('a', wait=100)
            if 'MASTER BALL' not in tile_text(self.h):
                self.press('right', wait=60)
            self.drive(lambda: 'MASTER BALL' in tile_text(self.h), pages=False)
            self.tick(90)
            self.press('a', wait=60)
            self.press('a')
            self.drive(lambda: self.idle() or self.choice())
            if self.choice():
                self.choose(False)
            self.settle()
        elif outcome == 'escape':
            self.press('right')
            self.press('down')
            self.press('a')
            self.settle()
        else:
            for _ in range(12):
                self.press('up')
                self.press('left')
                self.press('a', wait=80)
                self.press('a')
                self.drive(lambda: not self.m.read('wBattleMode') or 'FIGHT' in tile_text(self.h), limit=30000)
                if not self.m.read('wBattleMode'):
                    break
                self.tick(90)
            self.settle()
        print('BATTLE END', outcome, self.m.read('wBattleResult'), flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--phase', default='main1')
    args = parser.parse_args()
    s = Session()
    try:
        if args.phase == 'nav-probe':
            s.load('base')
            for y in range(10, 18):
                lengths = []
                for name, xy, goal in [('ROUTE_46', (14, 5), (19, y)), ('ROUTE_45', (0, y + 72), (12, 76))]:
                    s.stage_map(name, xy)
                    try:
                        lengths.append(len(s.path(goal)))
                    except RuntimeError:
                        lengths.append(None)
                print('LAKE CONNECTION', y, lengths, flush=True)
            return
        if args.phase == 'prepare':
            s.prepare()
            return
        if not (OUTPUT / 'base.state').exists():
            s.prepare()
        if args.phase == 'prepare-final-alternates':
            s.load('base')
            for name in ('EVENT_GOT_ECRUTEAK_WELL_RARE_CANDY', 'EVENT_GOT_STAR_SHARD_FROM_ROUTE_45_GRAMPS',
                         'EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED', 'EVENT_MT_MOON_WISHING_STAR_CRASHED',
                         'EVENT_MT_MOON_STAR_PIECE_VANISHED', 'EVENT_GOT_WISHING_STAR'):
                s.event(name, True)
            s.keys(['WISHING_STAR'])
            s.clock(8, 22)
            s.stage_map('ECRUTEAK_CITY', (23, 28))
            s.save('before-final-well')
        elif args.phase == 'main1':
            s.load('base')
            s.start('01-well-and-granny', 'Main quest: the old wishing well')
            s.granny()
            s.well(False)
            s.well(True)
            s.granny()
            s.well(True)
            s.finish('main1')
        elif args.phase == 'main2':
            s.load('main1')
            s.clock(5, 20)
            begin_native_call(s.h, 'OverworldLoop')
            s.tick(60)
            s.start('02-route45-gramps', 'Main quest: Friday evening on Route 45', 'Travel is shown through the normal Fly menu and on foot')
            s.fly('BLACKTHORN')
            s.connect('ROUTE_45')
            s.walk((12, 76))
            s.talk('down')
            s.talk('down')
            assert s.event('EVENT_GOT_STAR_SHARD_FROM_ROUTE_45_GRAMPS')
            s.finish('main2')
        elif args.phase == 'main3':
            s.load('main2')
            s.start('03-star-shard-exchange', 'Main quest: a wish made with the STAR SHARD')
            s.fly('ECRUTEAK')
            s.well(False)
            s.well(True)
            s.granny()
            s.well(True)
            assert s.event('EVENT_ECRUTEAK_WELL_STAR_SHARD_OFFERED')
            s.finish('main3')
        elif args.phase == 'main4':
            s.load('main3')
            s.start('04-journey-to-mtmoon', 'Main quest: travelling to Mt. Moon', 'Normal Fly, walking, gates and cave entrances are all shown')
            s.fly('SILVER CAVE')
            s.connect('ROUTE_28')
            s.fly('PEWTER')
            s.connect('ROUTE_3')
            s.warp('MOUNT_MOON')
            s.warp('MOUNT_MOON')
            s.warp('MOUNT_MOON_SQUARE')
            s.moon(loot=False)
            s.warp('MOUNT_MOON_GIFT_SHOP')
            s.finish('main4')
        elif args.phase == 'main5':
            s.load('main4')
            s.clock(8, 22) # Monday; same location, no map or position change.
            begin_native_call(s.h, 'OverworldLoop')
            s.tick(60)
            s.start('05-monday-dance-and-crater', 'Main quest: Monday night at Mt. Moon', 'Three days later, in the same gift shop; all travel and events continue on camera')
            s.warp('MOUNT_MOON_SQUARE')
            s.moon()
            s.walk((20, 15))
            s.settle()
            s.talk('right')
            assert s.event('EVENT_GOT_WISHING_STAR')
            s.warp('MOUNT_MOON_GIFT_SHOP')
            s.warp('MOUNT_MOON_SQUARE')
            s.walk((20, 15))
            s.tick(180)
            s.finish('main5')
        elif args.phase == 'main6':
            s.load('main5')
            s.start('06-return-to-the-well', 'Main quest: returning with the WISHING STAR')
            s.warp('MOUNT_MOON')
            s.warp('MOUNT_MOON')
            s.warp('ROUTE_4')
            s.fly('VIRIDIAN')
            s.connect('ROUTE_22')
            s.warp('VICTORY_ROAD_GATE')
            s.warp('ROUTE_28')
            s.connect('SILVER_CAVE_OUTSIDE')
            s.fly('ECRUTEAK')
            s.save('before-final-well')
            s.walk((24, 9))
            s.tick(120)
            s.well(False)
            s.walk((25, 9))
            s.press('up')
            s.press('a')
            s.choose(True)
            s.battle_end('capture')
            assert s.event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED')
            s.well(True)
            s.finish('main6')
        elif args.phase == 'no-money':
            s.load('base')
            s.write('wMoney', [0, 0, 0])
            s.start('07-well-no-money', 'Alternate: not enough money', 'Separate checkpoint; the complete attempt is shown')
            s.well(True)
            s.finish()
        elif args.phase == 'bag-full':
            s.load('base')
            s.full_items()
            s.start('08-well-bag-full', 'Alternate: the Bag is full', 'Separate checkpoint; no money is charged and no reward is lost')
            s.well(True)
            s.toss_first_item()
            s.well(True)
            s.finish()
        elif args.phase == 'shard-first':
            s.load('base')
            s.full_keys(shard=True)
            s.event('EVENT_GOT_STAR_SHARD_FROM_ROUTE_45_GRAMPS', True)
            s.start('09-shard-before-candy-east-side', 'Alternate: STAR SHARD before the RARE CANDY', 'East side of the well; all 25 Key Item slots occupied at the start')
            s.well(False, side='east')
            s.well(True, side='east')
            s.granny()
            s.well(True)
            s.well(True)
            s.finish()
        elif args.phase in ('gramps-early', 'gramps-saturday', 'gramps-full'):
            s.load('base')
            if args.phase == 'gramps-early':
                s.clock(5, 17)
                title, number = 'Alternate: Friday before 6 pm', '10'
            elif args.phase == 'gramps-saturday':
                s.clock(6, 1)
                title, number = 'Alternate: Saturday after midnight', '11'
            else:
                s.full_keys()
                title, number = 'Alternate: Gramps and a full Key Item pocket', '12'
            s.stage_map('ROUTE_45', (12, 82))
            s.start(number + '-' + args.phase, title, 'Separate checkpoint; walk to the lakeside spot in full')
            s.walk((12, 76))
            s.talk('down')
            s.tick(180)
            s.walk((13, 76))
            s.tick(120)
            s.finish()
        elif args.phase in ('moon-normal', 'moon-bag-full'):
            s.load('base')
            s.clock(8, 22)
            if args.phase == 'moon-bag-full':
                s.keys(['STAR_PIECE'])
                s.full_items()
                title, number = 'Alternate: Moon Stone pickup with a full Bag', '14'
            else:
                title, number = 'Alternate: Mt. Moon without a STAR PIECE', '13'
            s.stage_map('ROUTE_3', (50, 4))
            s.start(number + '-' + args.phase, title, 'Separate Monday-night checkpoint; walk through the cave and full dance')
            s.enter_moon()
            s.moon()
            if args.phase == 'moon-bag-full':
                s.toss_first_item()
                s.talk('up')
                assert s.event('EVENT_MT_MOON_WISHING_STAR_CRASHED'), 'Crash must be filmed after the successful pickup'
                s.walk((20, 15))
                s.settle()
                s.talk('right')
                assert s.event('EVENT_GOT_WISHING_STAR')
            else:
                s.walk((20, 15))
                s.tick(180)
                s.walk((7, 12))
                s.walk((7, 11))
                s.tick(180)
            s.finish()
        elif args.phase in ('crater-full', 'crater-east', 'crater-north', 'crater-south'):
            s.load('base')
            s.clock(8, 22)
            s.event('EVENT_MT_MOON_WISHING_STAR_CRASHED', True)
            if args.phase == 'crater-full':
                s.full_keys()
                s.event('EVENT_MT_MOON_STAR_PIECE_VANISHED', True)
                title, number, approach = 'Alternate: collecting the star with full Key Items', '15', (20, 15)
            elif args.phase == 'crater-east':
                s.keys(['STAR_PIECE'])
                title, number, approach = 'Alternate: approaching the crater from the east', '16', (22, 15)
            elif args.phase == 'crater-north':
                s.keys(['STAR_PIECE'])
                title, number, approach = 'Alternate: approaching the crater from the north', '17', (21, 14)
            else:
                s.keys(['STAR_PIECE'])
                title, number, approach = 'Alternate: approaching the crater from the south', '21', (21, 16)
            s.stage_map('ROUTE_3', (50, 4))
            s.start(number + '-' + args.phase, title, 'Separate checkpoint after the crash; all cave travel and collection dialogue shown')
            s.enter_moon()
            s.walk(approach)
            s.settle()
            s.talk('right' if approach == (20, 15) else 'left' if approach == (22, 15) else 'up' if approach == (21, 16) else 'down')
            assert s.event('EVENT_GOT_WISHING_STAR') == (args.phase != 'crater-full')
            s.finish()
        elif args.phase == 'wishing-star-decline':
            s.load('before-final-well')
            s.start('23-wishing-star-decline', 'Alternate: declining the WISHING STAR offer', 'Separate checkpoint; Granny is gone, and declining preserves the item')
            s.walk((24, 9))
            s.tick(120)
            s.well(False)
            assert not s.event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED')
            s.finish()
        elif args.phase in ('jirachi-escape', 'jirachi-knockout', 'jirachi-defeat', 'jirachi-capture'):
            s.load('before-final-well')
            outcome = args.phase.split('-', 1)[1]
            number = {'escape': '18', 'knockout': '19', 'defeat': '20', 'capture': '22'}[outcome]
            if outcome == 'defeat':
                s.build_party(level=5, weak=True)
                s.write('wLastSpawnMapGroup', s.maps['ECRUTEAK_CITY'][0])
                s.write('wLastSpawnMapNumber', s.maps['ECRUTEAK_CITY'][1])
                s.stage_map('ECRUTEAK_CITY', (23, 28))
            s.start(number + '-' + args.phase, 'Alternate: Jirachi — ' + outcome, 'Separate checkpoint; full summoning, both circles, battle and aftermath')
            s.final_wish(outcome)
            assert s.event('EVENT_ECRUTEAK_WELL_JIRACHI_FINISHED')
            if s.name() == 'ECRUTEAK_POKECENTER_1F':
                s.warp('ECRUTEAK_CITY')
            if s.name() != 'ECRUTEAK_CITY':
                s.fly('ECRUTEAK')
            s.well(True)
            s.finish()
        else:
            raise ValueError('Unknown phase: ' + args.phase)
    finally:
        if s.movie:
            # Preserve partial footage for diagnosis, without calling it final.
            s.finish()
        s.pb.stop(save=False)


if __name__ == '__main__':
    main()
