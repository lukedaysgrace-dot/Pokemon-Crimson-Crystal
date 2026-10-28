#!/usr/bin/env python3
"""Render Sour Apple ports on both sides and validate native graphics/cleanup.

Checks object graphics against VRAM and OAM tile bounds, including objects
whose graphics must remain live across a later upload. No player save is used.
"""
import argparse
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

from mae_animation_checks import capture, stage
from october_animation_checks import AnimationAudit
from runner import ROOT

sys.path.insert(0, str(ROOT/'tools'))
from audit_mae_animations import SOUR_APPLE


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal_debug.gbc')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/sour-apple-animation-update/validation')
    parser.add_argument('--moves', nargs='+', default=sorted(SOUR_APPLE))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    assert (ROOT/'gfx/battle_anims/shadow_sneak_sour_apple.2bpp').read_bytes() == \
        (ROOT/'gfx/battle_anims/angels.2bpp').read_bytes()[32*16:35*16], \
        'packed Shadow Sneak graphics differ from the exact source tiles'
    results, errors = [], []
    h, fixture = stage(args.rom)
    audit = AnimationAudit(h, args.rom)
    try:
        for move in args.moves:
            for side in (0, 1):
                print('Auditing', move, side, flush=True)
                audit.current = f'{move}/{side}'
                audit.spawns, audit.slots, audit.attempts = [], {}, []
                frames, _, result = capture(h, fixture, move, side, observer=audit.observe)
                if move in ('VACUUM_WAVE','DISCHARGE','LAVA_PLUME'):
                    audit.motion_checks(move,side)
                result['attempted_objects'] = len(audit.attempts)
                result['dropped_objects'] = len(audit.attempts)-len(audit.spawns)
                if result['dropped_objects']:
                    errors.append([move, side, 'object pool overflow', result['dropped_objects']])
                if result['final_frame_changed_pixels']:
                    errors.append([move, side, 'rendered battle screen not fully restored', result['final_frame_changed_pixels']])
                result['objects'] = audit.spawns.copy()
                sheet = Image.new('RGB', (6*320, 3*312), '#141820')
                for i, index in enumerate(np.linspace(0,len(frames)-1,18,dtype=int)):
                    x,y = i%6*320, i//6*312
                    sheet.paste(Image.fromarray(frames[index]).resize((320,288),Image.Resampling.NEAREST),(x,y+24))
                    ImageDraw.Draw(sheet).text((x+6,y+4),f'{move} / {side} / frame {index}',fill='white')
                sheet.save(args.output/f'{move.lower()}-{side}.png')
                results.append(result)
    finally:
        h.pb.stop(save=False)
    errors.extend(audit.errors)
    errors = [json.loads(e) for e in sorted(set(map(json.dumps,errors)))]
    (args.output/'audit.json').write_text(json.dumps({'rom_hash':h.rom_key(),'checks':results,'errors':errors},indent=2)+'\n')
    print(json.dumps(errors,indent=2))
    print(f'{len(results)} native captures; {len(errors)} errors',flush=True)
    raise SystemExit(bool(errors))


if __name__ == '__main__':
    main()
