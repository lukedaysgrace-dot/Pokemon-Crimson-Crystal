#!/usr/bin/env python3
"""Check Riolu's actual rendered OAM poses, including front/back face marks.

Stages one NPC in a private emulator fixture and exercises the native facing
routine for all sixteen direction/animation phases. Does not use player saves.
"""
import json
from pathlib import Path
import sys

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from symbols import _parse_constants
from probability_checks import call
from trainer_sprite_checks import enter_map, map_ids, native_call


def tile_pixels(data):
    return [[((data[y * 2] >> (7-x)) & 1) | (((data[y * 2 + 1] >> (7-x)) & 1) << 1)
             for x in range(8)] for y in range(8)]


def main():
    output = ROOT / '_ai_artifacts/goldenrod-riolu-vertical-fixed'
    output.mkdir(parents=True, exist_ok=True)
    h = Harness()
    h.ensure_fixture()
    pb, m = h.pb, h.battle.mem
    checks = []
    sheet = Image.new('RGB', (560, 448), '#151a24')
    draw = ImageDraw.Draw(sheet)
    sprites = _parse_constants(ROOT / 'constants/sprite_constants.asm')
    try:
        enter_map(h, map_ids()['CHERRYGROVE_EVOLUTION_SPEECH_HOUSE'], 3, 6)
        obj = h.sym.addr('wObjectStructs') + 40
        for slot in range(2, 16):
            m.write(f'wMap{slot}ObjectSprite', 0)
        pb.memory[obj + 40:obj + 40 * 12] = bytes(40 * 11)
        m.write('wMap1ObjectSprite', sprites['SPRITE_RIOLU'])
        m.write('wMap1ObjectColor', 0x90)
        pb.memory[obj] = sprites['SPRITE_RIOLU']
        pb.memory[obj + 6] = 1
        pb.memory[obj + 23] = 80
        pb.memory[obj + 24] = 40
        native_call(h, 'RefreshSprites')
        for row, (name, direction) in enumerate((('Down', 0), ('Up', 4), ('Left', 8), ('Right', 12))):
            poses = []
            for phase in range(4):
                pb.memory[obj + 8] = direction
                pb.memory[obj + 12] = phase * 8
                call(h, 'SetFacingStepAction', B=obj >> 8, C=obj & 255)
                # Render the phase just computed by SetFacingStepAction.
                # UpdateSprites also advances the staged NPC's idle action.
                native_call(h, '_UpdateSprites')
                h.tick(2)
                assert pb.memory[obj + 13] == direction + phase, (name, phase, pb.memory[obj + 13],
                                                                 list(pb.memory[obj:obj + 16]))
                pixels = [[0] * 16 for _ in range(16)]
                raw = m.read_bytes('wVirtualOAM', 160)
                entries = [raw[i:i + 4] for i in range(0, 160, 4)
                           if raw[i + 1] in (88, 96) and raw[i] in (52, 60)]
                assert len(entries) == 4, (name, phase, entries)
                for y, x, tile, attr in entries:
                    bank = (attr >> 3) & 1
                    address = 0x8000 + tile * 16
                    decoded = tile_pixels(bytes(pb.memory[bank, address:address + 16]))
                    for dy in range(8):
                        for dx in range(8):
                            source_y = 7-dy if attr & 64 else dy
                            source_x = 7-dx if attr & 32 else dx
                            pixels[y-52+dy][x-88+dx] = decoded[source_y][source_x]
                # Color 1 contains Riolu's face marks; hands are below row 9.
                # A downward pose has both eyes, an upward pose has neither,
                # and a profile has one eye on the matching side of the head.
                marks = [(x, y) for y in range(10) for x in range(16) if pixels[y][x] == 1]
                expected = 4 if name == 'Down' else 0 if name == 'Up' else 2
                assert len(marks) == expected, (name, phase, 'wrong facing pose', marks)
                if name in ('Left', 'Right'):
                    expected_x = 6 if name == 'Left' else 9
                    assert all(x == expected_x for x, y in marks), (name, phase, marks)
                checks.append(dict(direction=name, phase=phase, face_marks=marks))
                poses.append(pixels)
                screenshot = pb.screen.image.copy()
                screenshot.save(output / f'{name.lower()}-phase-{phase}.png')
                crop = screenshot.crop((80, 36, 96, 52)).resize((80, 80), Image.Resampling.NEAREST)
                x, y = 120 + phase * 108, row * 112 + 20
                sheet.paste(crop.convert('RGB'), (x, y))
                draw.text((x, row * 112 + 3), f'Phase {phase}', fill='white')
            assert poses[0] != poses[1], name + ' must use a distinct walking pose'
            draw.text((12, row * 112 + 50), name, fill='white')
            print('PASS', name, ': all four OAM phases keep the correct facing', flush=True)
        sheet.save(output / 'riolu-four-directions.png')
        (output / 'direction-checks.json').write_text(json.dumps(checks, indent=2) + '\n')
        print('PASS all 16 direction/animation phase checks', flush=True)
    finally:
        pb.stop(save=False)


if __name__ == '__main__':
    main()
