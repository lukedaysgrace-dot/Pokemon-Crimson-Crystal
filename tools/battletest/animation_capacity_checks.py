#!/usr/bin/env python3
"""Check native object allocation and Rapid Spin's live impact tiles on both sides."""
import argparse
from collections import Counter
import json
from pathlib import Path

from mae_animation_checks import capture, stage
from october_animation_checks import AnimationAudit
from runner import ROOT

FIXED_MOVES = ['RAPID_SPIN', 'WATERFALL', 'SPORE', 'STONE_EDGE', 'HAIL',
               'CLOSE_COMBAT', 'FLARE_BLITZ', 'FLASH_CANNON', 'GUNK_SHOT',
               'IRON_HEAD', 'OVERHEAT']
EXPECTED = {
    'RAPID_SPIN': {'RAPID_SPIN': 5, 'HIT': 1},
    'WATERFALL': {'HIT_YFIX': 5, 'BUBBLE_SPLASH': 10},
    'SPORE': {'MUSHROOM': 1, 'POWDER_SHOOT': 4, 'POWDER': 10},
    'STONE_EDGE': {'STONE_EDGE_STILL': 10, 'STONE_EDGE': 10, 'HIT_SMALL_YFIX': 3},
    'HAIL': {'HAIL': 10},
    'CLOSE_COMBAT': {'PUNCH': 20, 'HIT_YFIX': 20},
    'FLARE_BLITZ': {'FLARE_BLITZ': 21, 'RADIAL_FLAME': 13},
    'FLASH_CANNON': {'FLASH_CANNON_CHARGE': 10, 'FLASH_CANNON_SPARKS_WHITE': 7,
                     'FLASH_CANNON_SPARKS_RED': 6},
    'GUNK_SHOT': {'GUNK_SHOT_BUBBLES': 24, 'MUD_SHOT': 16, 'INK_SPLASH': 20},
    'IRON_HEAD': {'ROCK_SMASH': 10},
    'OVERHEAT': {'RADIAL_FLAME_RED': 65, 'RADIAL_FLAME_SLOW': 5, 'OVERHEAT_SMOKE': 24},
}


class CapacityAudit(AnimationAudit):
    def on_queue(self, _):
        super().on_queue(_)
        if self.current is None:
            return
        objects = self.m.read_bytes('wActiveAnimObjects', 24 * 10)
        if all(objects[i * 24] for i in range(10)):
            obj = self.m.read('wBattleObjectTempID') | self.m.read('wBattleObjectTempIDHi') << 8
            self.full.append(dict(frame=self.elapsed, object=self.names.get(obj, str(obj))))

    def observe(self, elapsed):
        self.elapsed = elapsed
        super().observe(elapsed)

    def reset(self, move, side):
        self.current = f'{move}/{side}'
        self.spawns, self.attempts, self.slots, self.expected_tiles = [], [], {}, {}
        self.full, self.elapsed = [], 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal_debug.gbc')
    parser.add_argument('--moves', nargs='+', default=FIXED_MOVES)
    parser.add_argument('--output', type=Path, default=ROOT/'.tmpbuild/animation-capacity')
    parser.add_argument('--diagnose', action='store_true')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    h, fixture = stage(args.rom)
    audit, results, failures = CapacityAudit(h, args.rom), [], []
    try:
        for move in args.moves:
            for side in (0, 1):
                audit.reset(move, side)
                frames, _, result = capture(h, fixture, move, side, observer=audit.observe)
                result.update(attempts=len(audit.attempts), spawned=len(audit.spawns),
                              full_pool=audit.full, objects=dict(Counter(p['object'] for p in audit.spawns)))
                if audit.full or len(audit.attempts) != len(audit.spawns):
                    failures.append(f'{move}/{side}: dropped {len(audit.attempts)-len(audit.spawns)} objects')
                if not args.diagnose:
                    for obj, count in EXPECTED.get(move, {}).items():
                        actual = result['objects'].get('ANIM_OBJ_'+obj, 0)
                        if actual != count:
                            failures.append(f'{move}/{side}: {obj}: expected {count}, got {actual}')
                results.append(result)
                print(move, side, result['objects'], 'FULL', audit.full, flush=True)
        # Other moves intentionally reuse compatible replacement sheets at
        # tile offset zero. Rapid Spin uses exact HIT tiles, so no remap applies.
        failures.extend(str(e) for e in audit.errors if str(e[0]).startswith('RAPID_SPIN/'))
    finally:
        h.pb.stop(save=False)
    data = dict(rom_hash=h.rom_key(), results=results, failures=failures)
    (args.output/'results.json').write_text(json.dumps(data, indent=2)+'\n')
    print(f'{len(results)} native previews; {len(failures)} failures', flush=True)
    if failures and not args.diagnose:
        raise SystemExit('\n'.join(failures))


if __name__ == '__main__':
    main()
