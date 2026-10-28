#!/usr/bin/env python3
"""Audit actual animation objects, tiles and motion, and render all 18 moves.

Unlike a changed-pixel check, the native object hook checks the graphics each
object requests against the bytes actually uploaded to VRAM. ROM framesets and
OAM layouts are decoded too, so a wrong tile offset cannot pass unnoticed.
"""
import argparse
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

from mae_animation_checks import capture, stage
from runner import ROOT
from symbols import _parse_constants


class AnimationAudit:
    def __init__(self, h, rom):
        self.h, self.m, self.pb = h, h.battle.mem, h.pb
        self.rom = rom.read_bytes()
        self.constants = _parse_constants(ROOT/'constants/battle_anim_constants.asm')
        self.names = {v: k for k, v in self.constants.items() if k.startswith('ANIM_OBJ_')}
        self.gfx_names = {v: k for k, v in self.constants.items() if k.startswith('ANIM_GFX_')}
        graphics = '\n'.join(p.read_text() for p in (ROOT/'gfx').glob('battle_anims*.asm'))
        self.gfx_paths = dict(re.findall(r'^(\w+):\s*INCBIN "([^"]+)"', graphics, re.M))
        self.gfx_labels = re.findall(r'^\s*anim_obj_gfx\s+\d+,\s*(\w+)',
                                    (ROOT/'data/battle_anims/object_gfx.asm').read_text(), re.M)
        self.errors, self.spawns, self.tracks = [], [], {}
        self.slots, self.attempts, self.expected_tiles = {}, [], {}
        self.hidden_hud_frames = 0
        self.discharge_black_frames = []
        self.current = None
        manifest = json.loads((ROOT/'tools/battletest/mae_animation_manifest.json').read_text())
        self.sour_apple = {row['move'] for row in manifest['moves']
                           if row['local_file'] == 'data/moves/animations7.asm'}
        self.h.pb.hook_register(*h.sym['InitBattleAnimation'], self.on_object, None)
        self.h.pb.hook_register(*h.sym['QueueBattleAnimation'], self.on_queue, None)

    def on_queue(self, _):
        if self.current is not None:
            obj = self.m.read('wBattleObjectTempID') | self.m.read('wBattleObjectTempIDHi') << 8
            self.attempts.append(self.names.get(obj, str(obj)))

    def read(self, bank, addr, count):
        offset = bank*0x4000 + addr-0x4000 if addr >= 0x4000 else addr
        return self.rom[offset:offset+count]

    def table(self, symbol, index, width):
        bank, addr = self.h.sym[symbol]
        return bank, self.read(bank, addr+index*width, width)

    def layouts(self, frameset):
        bank, row = self.table('BattleAnimFrameData', frameset, 2)
        pointer = int.from_bytes(row, 'little')
        result = []
        for _ in range(100):
            data = self.read(bank, pointer, 3)
            oam = int.from_bytes(data[:2], 'little')
            if oam in (0xffff, 0xfeff, 0xfcff):
                return result
            pointer += 3
            if oam == 0xfdff:
                continue
            obank, entry = self.table('BattleAnimOAMData', oam, 4)
            offset, count = entry[:2]
            ptr = int.from_bytes(entry[2:], 'little')
            sprites = self.read(obank, ptr, count*4)
            result.append((oam, offset, sprites, data[2]))
        raise AssertionError(('unterminated frameset', frameset))

    def on_object(self, _):
        if self.current is None:
            return
        obj = self.m.read('wBattleObjectTempID') | self.m.read('wBattleObjectTempIDHi') << 8
        _, row = self.table('BattleAnimObjects', obj, 7)
        gfx = row[6]
        name = self.names[obj]
        dictionary = dict(zip(self.m.read_bytes('wBattleAnimTileDict', 10)[::2],
                              self.m.read_bytes('wBattleAnimTileDict', 10)[1::2]))
        label = (self.current, name)
        spawn = {'object': name, 'gfx': self.gfx_names.get(gfx, gfx),
                            'x': self.m.read('wBattleObjectTempXCoord'),
                            'y': self.m.read('wBattleObjectTempYCoord'),
                            'param': self.m.read('wBattleObjectTempParam'), 'samples': []}
        self.spawns.append(spawn)
        self.slots[self.pb.register_file.B*256+self.pb.register_file.C] = (spawn, gfx)
        if gfx not in dictionary:
            self.errors.append([*label, 'graphics not loaded', self.gfx_names.get(gfx, gfx)])
            return
        if gfx in (self.constants['ANIM_GFX_PLAYERHEAD'], self.constants['ANIM_GFX_ENEMYFEET']):
            return
        _, gfxrow = self.table('AnimObjGFX', gfx, 4)
        tile_count = gfxrow[0]
        expected = (ROOT/self.gfx_paths[self.gfx_labels[gfx]].replace('.lz', '')).read_bytes()[:tile_count*16]
        self.expected_tiles[gfx] = expected
        begin = 0x8000 + (49+dictionary[gfx])*16
        actual = bytes(self.pb.memory[0, begin:begin+len(expected)])
        if actual != expected:
            self.errors.append([*label, 'VRAM differs from requested graphics'])
        frameset = int.from_bytes(row[2:4], 'little')
        for oam, offset, sprites, _duration in self.layouts(frameset):
            if sprites and offset+max(sprites[2::4]) >= tile_count:
                self.errors.append([*label, 'OAM indexes beyond graphics', oam, offset,
                                    max(sprites[2::4]), tile_count])

    def observe(self, elapsed):
        if self.current.startswith('DISCHARGE/') and max(self.pb.screen.ndarray[0,0,:3]) < 40:
            self.discharge_black_frames.append(elapsed)
        if self.current.startswith('COSMIC_POWER/'):
            tiles = self.m.read_bytes('wTileMap', 360)
            # Both actor/opponent HUDs must be entirely blank during the
            # starfield, including the expanded HP borders used by this fork.
            enemy = [tiles[y*20+x] for y in range(4) for x in range(1,12)]
            player = [tiles[y*20+x] for y in range(7,12) for x in range(9,20)]
            if set(enemy+player) == {0x7f}: self.hidden_hud_frames += 1
        base = self.h.sym.addr('wActiveAnimObjects')
        for address, (spawn, gfx) in self.slots.items():
            data = self.m.read_bytes('wActiveAnimObjects', 24, address-base)
            if not data[0]:
                continue
            expected = self.expected_tiles.get(gfx)
            if expected:
                begin = 0x8000 + (49+data[6])*16
                if bytes(self.pb.memory[0, begin:begin+len(expected)]) != expected:
                    self.errors.append([self.current, spawn['object'], 'live object graphics overwritten'])
            signed = lambda v: v if v < 128 else v-256
            spawn['samples'].append([elapsed, data[7]+signed(data[9]), data[8]+signed(data[10]),
                                     data[15], data[13]])

    def motion_checks(self, move, side):
        def tracks(name):
            return [p['samples'] for p in self.spawns if p['object'] == 'ANIM_OBJ_'+name and p['samples']]
        def check(ok, message):
            if not ok: self.errors.append([move, side, message])
        if move in self.sour_apple and move == 'VACUUM_WAVE':
            check([p['object'] for p in self.spawns] ==
                  ['ANIM_OBJ_PUNCH','ANIM_OBJ_VACUUM_SHRINKING','ANIM_OBJ_HIT'],
                  'Sour Apple fist, shrinking pressure sphere and impact must appear in order')
            check(all((p['x'],p['y']) == (136,52) for p in self.spawns),
                  'vacuum pressure effect must stay on the target')
            return
        if move in self.sour_apple and move == 'DISCHARGE':
            rays = ['DISCHARGE_SPARKS_'+d for d in ('N','NE','E','SE','S','SW','W','NW')]
            check(all(len(tracks(n)) == 8 for n in rays),
                  'all eight directional spark sprites must appear in every discharge wave')
            check(all(max(abs(p[1]-48)+abs(p[2]-88) for p in t) >= 40
                      for n in rays for t in tracks(n)),
                  'discharge sparks must expand outward from the user')
            check(len(tracks('LIGHTNING_BOLT')) == 3 and len(tracks('DISCHARGE_SPARKS_SMALL')) == 1,
                  'Sour Apple small-to-large lightning buildup must precede the spark waves')
            return
        if move in self.sour_apple and move == 'LAVA_PLUME':
            check(len(tracks('RADIAL_FLAME_RED')) == 24 and
                  len(tracks('ERUPTION_SMALL_FLAME')) == 12 and
                  len(tracks('LAVA_PLUME_SMOKE_SOUR')) == 12,
                  'all source flame pairs, embers and large smoke puffs must render')
            check(len({p['param'] for p in self.spawns if p['object']=='ANIM_OBJ_RADIAL_FLAME_RED'}) == 12,
                  'source flames must spread around the user in twelve directions')
            return
        if move == 'VACUUM_WAVE':
            phases = ('PUNCH','SHRINKING_RING_BIG','SHRINKING_RING_SMALL','HIT_YFIX')
            check([p['object'] for p in self.spawns] == ['ANIM_OBJ_'+n for n in phases],
                  'reference sequence must be fist, big ring, small ring, impact')
            check(all((p['x'],p['y']) == (136,52) for p in self.spawns),
                  'reference pressure rings and fist must stay on the target')
            starts = [tracks(n)[0][0][0] for n in phases if tracks(n)]
            check(len(starts) == 4 and starts == sorted(starts) and starts[-1]-starts[0] <= 20,
                  'reference pressure-ring sequence must be a quick, ordered hit')
        if move == 'DISCHARGE':
            rays = ('DISCHARGE_RADIAL','DISCHARGE_VERTICAL','DISCHARGE_DIAGONAL','DISCHARGE_DIAGONAL_REVERSE')
            check(sum(len(tracks(n)) for n in rays) == 64 and
                  all(max(p[3] for p in t) >= 60 for n in rays for t in tracks(n)),
                  'eight reference pulses must send sparks in all eight directions')
            check(len(tracks('THUNDERSHOCK_BALL')) == 2 and len(tracks('THUNDERBOLT_BALL')) == 6,
                  'reference must build from small blinking orb to large blinking orb')
            check(all((p['x'],p['y']) == (48,88) for p in self.spawns),
                  'reference discharge must originate entirely around the user')
            pulses = tracks('THUNDERSHOCK_BALL')+tracks('THUNDERBOLT_BALL')
            starts = [t[0][0] for t in pulses]
            # Mirrored palette/OAM uploads can consume extra VBlanks; retain
            # a four-frame tolerance across the complete eight-pulse sequence.
            check(38 <= starts[2]-starts[0] <= 42 and 108 <= starts[-1]-starts[0] <= 115,
                  'reference orb buildup and pulse duration must retain their timing')
            check(self.discharge_black_frames and
                  52 <= min(self.discharge_black_frames)-starts[0] <= 64,
                  'reference field flash must occur near the middle of the discharge')
        if move == 'LAVA_PLUME':
            check(len(tracks('LAVA_PLUME_FLAME')) == 24 and len(tracks('LAVA_PLUME_SMOKE')) == 12,
                  'reference inferno must contain interleaved flames and smoke')
            check(len(tracks('LAVA_PLUME_EMBER')) == 6,
                  'small embers must trail behind the larger flames')
            check(all((p['x'],p['y']) == (48,96) for p in self.spawns),
                  'reference lava plume must erupt around the user, not stream across the field')
            check(len({p['param'] for p in self.spawns if p['object']=='ANIM_OBJ_LAVA_PLUME_FLAME'}) == 12,
                  'reference flames must spread around the user')
            starts = [t[0][0] for t in tracks('LAVA_PLUME_FLAME')][::2]
            check(all(6 <= b-a <= 7 for a,b in zip(starts,starts[1:])),
                  'reference flame pairs must be staggered six frames apart')
        if move == 'SKY_UPPERCUT':
            check(len(tracks('SKY_UPPERCUT')) == 6 and all(len(t) >= 35 for t in tracks('SKY_UPPERCUT')),
                  'six wind columns must persist throughout the windup')
            check(all(max(p[2] for p in t)-min(p[2] for p in t) >= 24 for t in tracks('UPPERCUT_PUNCH')),
                  'uppercut fist must rise through the target')
        if move == 'RECYCLE':
            check(any(set(range(8)) <= {p[4] for p in t} for t in tracks('RECYCLE')),
                  'rotation must display all eight phases')
        if move == 'COSMIC_POWER':
            check(self.hidden_hud_frames >= 100, 'complete HUDs must be hidden throughout the starfield')

    def recycle_sheet(self, output):
        obj = self.constants['ANIM_OBJ_RECYCLE']
        _, row = self.table('BattleAnimObjects', obj, 7)
        gfx = (ROOT/'gfx/battle_anims/recycle.2bpp').read_bytes()
        source = Image.open(ROOT/'gfx/battle_anims/recycle.png').convert('RGB')
        # Compare tile color indexes, avoiding any palette/rendering differences.
        palette = sorted(set(map(tuple, np.array(source).reshape(-1,3))), reverse=True)
        source_index = np.array([[palette.index(tuple(p)) for p in line] for line in np.array(source)])
        sheet = Image.new('RGB', (8*128, 160), '#141820')
        for i, (_oam, offset, sprites, duration) in enumerate(self.layouts(int.from_bytes(row[2:4], 'little'))):
            canvas = np.zeros((32, 32), dtype=np.uint8)
            for y, x, tile, flags in zip(*[sprites[k::4] for k in range(4)]):
                y = y if y < 128 else y-256
                x = x if x < 128 else x-256
                raw = gfx[(offset+tile)*16:(offset+tile+1)*16]
                pixels = np.array([[(raw[r*2] >> (7-c) & 1) + 2*(raw[r*2+1] >> (7-c) & 1)
                                    for c in range(8)] for r in range(8)], dtype=np.uint8)
                if flags & 32: pixels = pixels[:, ::-1]
                if flags & 64: pixels = pixels[::-1]
                canvas[16+y:24+y, 16+x:24+x] = pixels
            # Frame attributes flip both position and tiles around the center.
            if duration & 64: canvas = canvas[:, ::-1]
            if duration & 128: canvas = canvas[::-1]
            expected = source_index[(i%4)*32:(i%4+1)*32]
            if i >= 4: expected = expected[::-1, ::-1]
            if not np.array_equal(canvas, expected):
                self.errors.append(['RECYCLE', 'assembled frame differs from full source sprite', i])
            image = Image.fromarray(np.array(palette, dtype=np.uint8)[canvas])
            sheet.paste(image.resize((128,128), Image.Resampling.NEAREST), (i*128, 24))
            ImageDraw.Draw(sheet).text((i*128+8,4), f'Phase {i+1}', fill='white')
        sheet.save(output/'recycle-rotation.png')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal_debug.gbc')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/october-animation-review')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    moves = json.loads((ROOT/'tools/testdata/move_expansion_20261019.json').read_text())['moves']
    results, errors = [], []
    for move in moves:
        # Give each move its own emulator as well as a clean battle fixture,
        # keeping independent comparisons isolated from preceding effects.
        h, fixture = stage(args.rom)
        audit = AnimationAudit(h, args.rom)
        try:
            if move == 'RECYCLE': audit.recycle_sheet(args.output)
            for side in (0,1):
                print('Auditing', move, side, flush=True)
                audit.current, audit.spawns = f'{move}/{side}', []
                audit.slots, audit.attempts = {}, []
                audit.hidden_hud_frames = 0
                audit.discharge_black_frames = []
                frames, _, result = capture(h, fixture, move, side, observer=audit.observe)
                audit.motion_checks(move, side)
                result['attempted_objects'] = len(audit.attempts)
                result['dropped_objects'] = len(audit.attempts)-len(audit.spawns)
                if result['dropped_objects']:
                    audit.errors.append([move, side, 'object pool overflow', result['dropped_objects']])
                if result['final_frame_changed_pixels']:
                    audit.errors.append([move, side, 'rendered battle screen not fully restored',
                                         result['final_frame_changed_pixels']])
                if move == 'LAVA_PLUME':
                    last = max(p['samples'][-1][0] for p in audit.spawns if p['samples'])
                    if result['native_frames']-last > 24:
                        audit.errors.append([move, side, 'sound tail delays the end of the plume'])
                result['objects'] = audit.spawns.copy()
                # Dense timelines include early/late phases missed by four snapshots.
                sheet = Image.new('RGB', (6*320, 3*312), '#141820')
                for i, index in enumerate(np.linspace(0, len(frames)-1, 18, dtype=int)):
                    x,y = i%6*320, i//6*312
                    sheet.paste(Image.fromarray(frames[index]).resize((320,288), Image.Resampling.NEAREST), (x,y+24))
                    ImageDraw.Draw(sheet).text((x+6,y+4), f'{move} / {side} / frame {index}', fill='white')
                sheet.save(args.output/f'{move.lower()}-{side}.png')
                results.append(result)
        finally:
            h.pb.stop(save=False)
        errors.extend(audit.errors)
    unique_errors = sorted(set(map(lambda e: json.dumps(e), errors)))
    report = {'rom_hash':h.rom_key(), 'checks':results, 'errors':[json.loads(e) for e in unique_errors]}
    (args.output/'audit.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report['errors'], indent=2))
    print(f'{len(results)} captures; {len(unique_errors)} graphics/layout errors')
    raise SystemExit(bool(unique_errors))


if __name__ == '__main__':
    main()
