#!/usr/bin/env python3
"""Audit shared move animations against a local, pinned mae-pokeorange checkout.

Usage: python tools/audit_mae_animations.py --upstream PATH [--write]
Without --upstream, verify the saved audit's move mapping and script hashes.
This is a script/dependency audit, not an assertion of pixel identity between
two engines; preserved upgraded graphics and engine adaptations are documented.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'tools/battletest/mae_animation_manifest.json'
UPSTREAM_SHA = '41a44630a3f712f3f45a157874361234e13e68ca'
SUPPORT_FILES = [
    'constants/battle_anim_constants.asm', 'macros/scripts/battle_anims.asm',
    'data/battle_anims/objects.asm', 'data/battle_anims/framesets.asm',
    'data/battle_anims/oam.asm', 'data/battle_anims/object_gfx.asm',
    'engine/battle_anims/anim_commands.asm', 'engine/battle_anims/core.asm',
    'engine/battle_anims/functions.asm', 'engine/battle_anims/helpers.asm',
    'engine/battle_anims/data_readers.asm', 'engine/battle_anims/object_readers.asm',
    'gfx/battle_anims.asm', 'gfx/battle_anims2.asm', 'gfx/battle_anims/custom.pal',
    'gfx/battle_anims/cosmicpower.png',
    *[p.relative_to(ROOT).as_posix() for p in sorted((ROOT/'gfx/battle_anims').glob('*_sour_apple.png'))],
    *[f'data/moves/animations{suffix}.asm' for suffix in ('', '2', '3', '4', '5', '6', '7')],
]
CHANGED = {'BUBBLE', 'EGG_BOMB', 'SPIKE_CANNON', 'BARRAGE', 'FLAME_WHEEL',
           'LEAF_BLADE', 'SHADOW_PUNCH', 'DRAGON_DANCE', 'SLACK_OFF', 'VOLT_TACKLE', 'WISH',
           'SELFDESTRUCT', 'POWDER_SNOW', 'PRESENT'}
SOUR_APPLE = {'WHIRLWIND', 'TWISTER', 'FIRE_FANG', 'ICE_FANG', 'THUNDER_FANG',
    'BRAVE_BIRD', 'VOLT_TACKLE', 'LEAF_STORM', 'ROCK_POLISH',
    'HEAD_SMASH', 'PSYCHO_CUT', 'CROSS_POISON', 'STEALTH_ROCK', 'DEFOG',
    'GUST', 'TACKLE', 'SHADOW_BALL', 'SHADOW_SNEAK', 'POISON_FANG',
    'BUG_BUZZ', 'POISON_JAB', 'VACUUM_WAVE', 'DISCHARGE', 'LAVA_PLUME',
    'WISH'}
CHANGED |= SOUR_APPLE
ADAPTATIONS = {
    'POISON_FANG': 'Use a dedicated purple bite object; preserve the source impact colors and poison-splash sequence.',
    'SHADOW_SNEAK': 'Pack the exact three shadow tiles so HIT graphics and battler tiles do not overlap.',
    'HEAD_SMASH': 'Clear the first debris group before the second impact to avoid dropped rocks.',
    'LAVA_PLUME': 'Space spawns three frames apart and use short flame-pair crackles so particles fit and no long sound tail delays the finish.',
}

# Each exception describes the visible improvement or the required engine fix.
PRESERVE = {
    'SMOG': 'Retain the existing poison-purple palette enhancement.',
    'SLUDGE': 'Retain poison-purple palette handling and its automatic reset.',
    'POISON_GAS': 'Retain the existing poison-purple palette enhancement.',
    'ACID_ARMOR': 'Retain the existing poison-purple palette enhancement.',
    'SPIDER_WEB': 'Custom purple web and poison bubbles express this game\'s redesigned hazard.',
    'MOONLIGHT': 'Keep the rising moon globe and added glimmer sequence.',
    'BEAT_UP': 'Keep actual party-member sprite substitutions between hits.',
    'POISON_FANG': 'Keep the bite, purple poison splash and extra impact.',
    'SHADOW_SNEAK': 'Keep the darkened field, disappearing user and fast shadow strike.',
    'DRACO_METEOR': 'Keep separate small/big meteors, dragon palettes and corrected impacts.',
    'AERIAL_ACE': 'Keep the shared speed lines and earlier user restoration, preventing sprite loss.',
    'AQUA_TAIL': 'Keep safe initial GFX loading and the corrected impact graphics set.',
    'ASTONISH': 'Keep object cleanup instead of reloading battler graphics over active objects.',
    'DRAGON_PULSE': 'Keep the bank-local palette helper and corrected macro syntax.',
    'EARTH_POWER': 'Keep the added fire-colored eruption palette.',
    'GYRO_BALL': 'Keep corrected object index, palette restoration and valid macro syntax.',
    'NASTY_PLOT': 'Keep dedicated thought/hand/surprise graphics instead of reused Amnesia icons.',
    'NIGHT_SLASH': 'Keep the dedicated horizontal slash object and its orientation parameter.',
    'WATER_PULSE': 'Keep explicit user restoration using the correct fourth object.',
    'OVERHEAT': 'Keep the red flame object; the shared radial flame has a different palette here.',
    'BRICK_BREAK': 'Keep the visible screen, chop, shattering fragments and impact.',
    'BULLET_SEED': 'Keep one short volley per native multi-hit iteration, avoiding repeated volleys.',
    'MAGICAL_LEAF': 'Keep the Aurora palette on the actual green leaf slot in this engine.',
    'BOUNCE': 'Keep the complete charge, hit and miss paths and restored user sprite.',
    'WEATHER_BALL': 'Keep corrected 120-pixel travel, dedicated ice burst and removed transition flash.',
    'IRON_HEAD': 'Keep the metallic user palette and explicit palette restoration instead of a black silhouette.',
    'COSMIC_POWER': 'Keep Coral starfield positioning and immediate palette cycling, with both complete HUDs hidden.',
    'ERUPTION': 'Same source sequence; the dedicated falling-rock object uses the loaded lava-rock graphics instead of unloaded ROCKS.',
    'OMINOUS_WIND': 'Same source sequence; dedicated Coral mist object retains its correct palette and priority.',
    'BLAZE_KICK': 'Keep six-frame flame spacing; the source one-frame burst drops flames from the ten-object pool.',
    'TRICK_ROOM': 'User requested the original repeated SFX_UNKNOWN_66 sound sequence; visual effects and timing are retained.',
}


def constants(path):
    result, value = {}, 0
    aliases = []
    for raw in path.read_text(encoding='utf-8-sig').splitlines():
        line = raw.split(';')[0].strip()
        m = re.fullmatch(r'const_def(?:\s+(\$[\da-fA-F]+|\d+))?', line)
        if m:
            value = int(m[1].replace('$', '0x'), 0) if m[1] else 0
        m = re.fullmatch(r'const (\w+)', line)
        if m:
            result[m[1]] = value
            value += 1
        m = re.fullmatch(r'(\w+)\s+EQU\s+(\w+)', line)
        if m:
            aliases.append(m.groups())
    for _ in range(3):
        for a, b in aliases:
            if b in result:
                result[a] = result[b]
    return result


class Scripts:
    def __init__(self, root, upstream=False):
        self.root = root
        self.upstream = upstream
        names = [p.name for p in sorted((root / 'data/moves').glob('animations_*.asm'))]
        names = names + ['special_animations.asm'] if upstream else [
            'animations.asm', 'animations2.asm', 'animations3.asm', 'animations4.asm',
            'animations5.asm', 'animations6.asm', 'animations7.asm']
        self.blocks, self.next, self.files = {}, {}, {}
        pointers = []
        for name in names:
            path = root / 'data/moves' / name
            text = path.read_text(encoding='utf-8-sig')
            labels = list(re.finditer(r'^(\w+)::?[ \t]*$', text, re.M))
            for i, label in enumerate(labels):
                end = labels[i+1].start() if i+1 < len(labels) else len(text)
                self.blocks[label[1]] = text[label.end():end]
                self.files[label[1]] = path.relative_to(root).as_posix()
                if i+1 < len(labels):
                    self.next[label[1]] = labels[i+1][1]
            if upstream and name != 'special_animations.asm':
                pointers += re.findall(r'^\s*dw (BattleAnim_\w+)', text[:labels[1].start()], re.M)
            elif name == 'animations.asm':
                pointers = re.findall(r'^\s*banim (\w+)', text.split('BattleAnimations::')[1], re.M)
        moves_text = (root / 'constants/move_constants.asm').read_text().split('NUM_ATTACKS EQU')[0]
        moves = re.findall(r'^\s*const (\w+)', moves_text, re.M)
        self.moves = dict(zip(moves, pointers))
        assert len(self.moves) == len(moves), (len(moves), len(pointers))
        self.con = constants(root / 'constants/battle_anim_constants.asm')
        self.reference_objects = None
        self.reference_bgs = None

    def raw(self, label):
        return [s for line in self.blocks[label].splitlines()
                if (s := line.split(';')[0].strip())]

    def expanded(self, label, depth=0):
        assert depth < 30, ('script recursion', label)
        result = []
        lines = self.raw(label)
        for line in lines:
            m = re.fullmatch(r'anim_(call|jump) (\w+)', line)
            if m and m[2] in self.blocks:
                child = self.expanded(m[2], depth+1)
                result.extend(child[:-1] if m[1] == 'call' and child[-1:] == ['anim_ret'] else child)
            else:
                result.append(line)
        if not lines or not re.match(r'anim_(ret|jump)\b', lines[-1]):
            if label in self.next:
                result.extend(self.expanded(self.next[label], depth+1))
        return result

    def canonical(self, label, move, depth=0):
        assert depth < 30, ('conditional recursion', label)
        lines = self.expanded(label)
        out = []
        for line in lines:
            branch = re.fullmatch(r'(anim_if_param_equal\s+[^,]+,\s*)(\w+)', line)
            if branch and branch[2] in self.blocks:
                body = self.canonical(branch[2], move, depth+1)
                fingerprint = hashlib.sha256(json.dumps(body).encode()).hexdigest()
                line = branch[1]+'branch_'+fingerprint
            line = re.sub(r'\$([\da-fA-F]+)', lambda m: str(int(m[1], 16)), line)
            if not self.upstream:
                line = re.sub(r'ANIM_OBJ_([\dA-F]{2})\b',
                    lambda m: self.reference_objects[self.con[m[0]]], line)
                line = line.replace('ANIM_OBJ_LIGHTNING_BOLT', 'ANIM_OBJ_THUNDERBOLT_CORE')
                line = re.sub(r'(ANIM_GFX_\w+)_SA\b', r'\1', line)
                line = line.replace('ANIM_GFX_SHADOW_SNEAK', 'ANIM_GFX_ANGELS')
                line = re.sub(r'(ANIM_OBJ_\w+)_SOUR\b', r'\1', line)
                if move == 'LAVA_PLUME':
                    line = line.replace('ANIM_OBJ_RADIAL_FLAME_RED', 'ANIM_OBJ_RADIAL_FLAME')
                line = re.sub(r'ANIM_BG_\w+',
                    lambda m: self.reference_bgs.get(self.con.get(m[0]), m[0]), line)
            line = line.replace('anim_clearenemyhud', 'anim_clearopponenthud')
            line = line.replace('SFX_BUBBLEBEAM', 'SFX_BUBBLE_BEAM')
            if move == 'SPIKE_CANNON':
                # MediumHorn is BLUE in Crimson and YELLOW in Pokeorange.
                line = line.replace('PAL_BATTLE_OB_YELLOW', 'PAL_BATTLE_OB_BLUE')
            if move == 'TWINEEDLE' and line.startswith('anim_setobjpal '):
                continue  # Legacy needle already uses the neutral gray slot.
            if move == 'ICICLE_SPEAR' and line.startswith('anim_setobjpal PAL_BATTLE_OB_YELLOW'):
                continue  # Crimson's medium horn/ice objects both use BLUE.
            # Legacy scripts use tile+offset coordinates; newer ones use pixels.
            if line.startswith('anim_obj '):
                args = [a.strip() for a in line[9:].split(',')]
                if len(args) == 6:
                    args = [args[0], str(int(args[1])*8+int(args[2])),
                            str(int(args[3])*8+int(args[4])), args[5]]
                line = 'anim_obj '+','.join(args)
            line = re.sub(r'\s*,\s*', ',', ' '.join(line.split())).rstrip(',')
            # Labels are scoped to this script; bank suffixes carry no meaning.
            line = re.sub(r'(BattleAnim_\w+)_branch_c[\da-f]+', r'\1_branch', line)
            out.append(line)
        if self.upstream and move == 'LAVA_PLUME':
            out = ['anim_wait 3' if line == 'anim_wait 2' else line for line in out]
            out.remove('anim_sound 6,2,SFX_EMBER')
            pairs = [i for i,line in enumerate(out) if line.startswith('anim_obj ANIM_OBJ_RADIAL_FLAME,')][::2]
            for index in reversed(pairs):
                out.insert(index, 'anim_sound 0,0,SFX_BURN')
        if self.upstream and move == 'HEAD_SMASH':
            index = next(i for i,line in enumerate(out)
                         if line == 'anim_sound 0,1,SFX_EGG_BOMB' and out[i-1] == 'anim_wait 6')
            out.insert(index, 'anim_clearobjs')
        if self.upstream and move == 'POISON_FANG':
            out.insert(1, 'anim_setobjpal PAL_BATTLE_OB_BLUE,PAL_BTLCUSTOM_PURPLE')
            out = [line.replace('ANIM_OBJ_BITE,', 'ANIM_OBJ_POISON_FANG_BITE,') for line in out]
        return [line for i, line in enumerate(out)
                if not (line == 'anim_ret' and i and out[i-1] == 'anim_ret')]

    def digest(self, label):
        return hashlib.sha256('\n'.join(self.expanded(label)).encode()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upstream', type=Path)
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    local = Scripts(ROOT)
    if not args.upstream:
        saved = json.loads(MANIFEST.read_text())
        for row in saved['moves']:
            assert local.moves[row['move']] == row['local_label'], row['move']
            assert local.digest(row['local_label']) == row['script_sha256'], row['move']
        for name, expected in saved['support_file_sha256'].items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest() == expected, name
        print('PASS', len(saved['moves']), 'saved shared-move mappings and animation dependency hashes')
        return
    revision = subprocess.check_output(['git', '-C', str(args.upstream), 'rev-parse', 'HEAD'], text=True).strip()
    assert revision == UPSTREAM_SHA, ('wrong upstream revision', revision, UPSTREAM_SHA)
    source = Scripts(args.upstream.resolve(), upstream=True)
    local.reference_objects = {v: n for n, v in source.con.items() if n.startswith('ANIM_OBJ_')}
    # Pokeorange inserted WITHDRAW_ALL into its BG enum; later numeric ids
    # differ. Compare semantic aliases from Crimson's own dispatch table.
    local.reference_bgs = {local.con[n]: n for n in source.con
                           if n.startswith('ANIM_BG_') and n in local.con}
    rows, unresolved = [], []
    for move, label in local.moves.items():
        if move == 'NO_MOVE' or move not in source.moves:
            continue
        reference = source.moves[move]
        a, b = local.canonical(label, move), source.canonical(reference, move)
        if move in CHANGED and a != b:
            unresolved.append(move)
            status, reason = 'unresolved', 'Updated animation does not match reference commands.'
            print(move, '\n  crimson:', a, '\n  orange:', b)
        elif move in CHANGED:
            status, reason = 'updated', ADAPTATIONS.get(move,
                'Completed Pokeorange animation; retain compatible upgraded engine graphics.')
        elif source.expanded(reference) == ['anim_ret'] or reference == 'BattleAnim_0':
            status, reason = 'preserved', 'Upstream has an empty placeholder; retain the implemented animation.'
        elif a == b:
            status, reason = 'matching', 'Same normalized animation commands and reachable helper bodies.'
        elif '_PC' in label:
            status, reason = 'preserved', 'Existing Polished Crystal upgrade with its graphics, palettes and timing.'
        elif move in PRESERVE:
            status, reason = 'preserved', PRESERVE[move]
        else:
            unresolved.append(move)
            status, reason = 'unresolved', 'Manual review required.'
            print(move, '\n  crimson:', a, '\n  orange:', b)
        rows.append({'move': move, 'local_label': label, 'local_file': local.files[label],
                     'reference_label': reference, 'status': status, 'reason': reason,
                     'script_sha256': local.digest(label)})
    print(Counter(row['status'] for row in rows), 'shared:', len(rows))
    if unresolved:
        raise SystemExit('Unreviewed differences: '+', '.join(unresolved))
    result = {'upstream_repository': 'https://github.com/PiaCarrot/mae-pokeorange',
              'upstream_branch': 'sour-apple',
              'upstream_commit': UPSTREAM_SHA, 'date': '2026-10-27',
              'scope': 'Shared move scripts and reachable helper bodies; engine adaptations and upgraded assets retained.',
              'counts': dict(Counter(row['status'] for row in rows)), 'moves': rows,
              'absent_from_upstream': sorted(set(local.moves)-set(source.moves)-{'NO_MOVE'}),
              'support_file_sha256': {name: hashlib.sha256((ROOT/name).read_bytes()).hexdigest()
                                      for name in SUPPORT_FILES}}
    if args.write:
        MANIFEST.write_text(json.dumps(result, indent=2)+'\n')


if __name__ == '__main__':
    main()
