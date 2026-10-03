#!/usr/bin/env python3
"""Check NPC walking assets, compiled animation and VRAM loading.

Run with --runtime to exercise the ROM. --output DIR saves the detailed
catalog and contact sheets. No player save is loaded or written.
"""
import argparse
import json
import re
from pathlib import Path
from audit_trainer_sprites import sprite_metadata, parse_map

ROOT = Path(__file__).resolve().parent.parent
POKEMON_NPCS = {
    'SPRITE_BIG_SNORLAX', 'SPRITE_SURFING_PIKACHU', 'SPRITE_AMPY_SICK',
    'SPRITE_BIG_LAPRAS', 'SPRITE_MONSTER', 'SPRITE_FAIRY', 'SPRITE_BIRD',
    'SPRITE_DRAGON', 'SPRITE_BIG_ONIX', 'SPRITE_SLOWPOKE_NOTAIL',
    'SPRITE_ENTEI_NPC', 'SPRITE_RATTATA_UP', 'SPRITE_POLIWRATH_NPC',
    'SPRITE_FARFETCH_D_NPC', 'SPRITE_SLOWBRO_NPC', 'SPRITE_RAIKOU_NPC',
    'SPRITE_SUICUNE_NPC', 'SPRITE_MEW', 'SPRITE_FINIZEN',
}
TYPE_IDS = {'WALKING_SPRITE': 1, 'STANDING_SPRITE': 2, 'MON_ICON_SPRITE': 3, 'STILL_SPRITE': 4, 'BIG_SPRITE': 5}


def catalog():
    ids, _ = sprite_metadata()
    for name, target in re.findall(r'^(SPRITE_\w+)\s+EQU\s+(SPRITE_\w+)', (ROOT / 'constants/sprite_constants.asm').read_text(), re.M):
        if target in ids:
            ids[name] = ids[target]
    names = {value: name for name, value in ids.items() if value < ids['SPRITE_POKEMON'] and name not in ['SPRITE_NONE', 'SPRITE_FOSSIL']}
    refs = dict(re.findall(r'^(\w+)::?\s+INCBIN "([^"]+)"', (ROOT / 'gfx/sprites.asm').read_text(), re.M))
    rows = []
    for i, (label, length, kind) in enumerate(re.findall(r'^\s*overworld_sprite\s+(\w+),\s+(\d+),\s+(\w+)', (ROOT / 'data/sprites/sprites.asm').read_text(), re.M), 1):
        rows.append(dict(id=i, name=names[i], label=label, tiles=int(length), kind=kind, file=refs.get(label), pokemon=names[i] in POKEMON_NPCS, map_objects=[]))
    by_name = {row['name']: row for row in rows}
    variables = set()
    for path in list((ROOT / 'maps').glob('*.asm')) + [ROOT / 'engine/events/std_scripts.asm']:
        for variable, sprite in re.findall(r'\bvariablesprite\s+(SPRITE_\w+),\s*(SPRITE_\w+)', path.read_text()):
            variables.add((variable, sprite))
        if path.parent.name == 'maps':
            for obj in parse_map(path):
                if obj['sprite'] in by_name:
                    by_name[obj['sprite']]['map_objects'].append(dict(map=path.stem, line=obj['line'], movement=obj['movement'], script=obj['script']))
    return ids, rows, sorted(variables)


def audit(runtime=False):
    ids, rows, variables = catalog()
    result = dict(definitions=len(rows), non_pokemon_definitions=sum(not r['pokemon'] for r in rows), checks=0, failures=[], sprites=rows, variable_assignments=variables)
    def check(condition, message):
        result['checks'] += 1
        if not condition:
            result['failures'].append(message)
    humans = [r for r in rows if not r['pokemon'] and r['kind'] in ['WALKING_SPRITE', 'STANDING_SPRITE']]
    result['walking_definitions'] = sum(r['kind'] == 'WALKING_SPRITE' for r in humans)
    result['standing_definitions'] = sum(r['kind'] == 'STANDING_SPRITE' for r in humans)
    result['map_object_instances'] = sum(len(r['map_objects']) for r in humans)
    for row in [r for r in rows if not r['pokemon']]:
        check(bool(row['file']), f"{row['name']}: missing graphics reference")
        if not row['file']:
            continue
        size = (ROOT / row['file']).stat().st_size
        expected = row['tiles'] * 16 * (2 if row['kind'] == 'WALKING_SPRITE' else 1)
        row['asset_bytes'] = size
        check(size >= expected, f"{row['name']}: {size} graphics bytes, needs {expected}")
    if not runtime:
        return result

    from pc_harness import Harness
    h = Harness(str(ROOT / 'pokecrystal.gbc'), str(ROOT / 'pokecrystal.sym'))
    h.boot()
    # LCD-off transfers exercise the actual loader without requiring a map or
    # waiting for VBlank. Test each graphics bank, including the second table.
    h.call('DisableLCD')
    h.wr(h.s('wPlayerGender'), 0)
    h.wr(h.s('wLandmarkSignTimer'), 0)
    obj = h.s('wObjectStructs') + 40
    variable_ids = [ids[name] for name in ids if name.startswith('SPRITE_') and ids[name] >= 0xf0 and name != 'SPRITE_VARS']
    try:
        for index, row in enumerate(humans, 1):
            kind = TYPE_IDS[row['kind']]
            check(h.call('GetOverworldSpriteType', a=row['id'])['a'] == kind, f"{row['name']}: wrong compiled type")
            row['animation_facings'] = {}
            for direction in [0, 4, 8, 12]:
                observed = set()
                for step_frame in range(32):
                    h.wr(obj, bytes(40)); h.wr(obj, row['id'])
                    h.wr(obj + 8, direction); h.wr(obj + 12, step_frame)
                    regs = h.call('SetFacingStepAction', bc=obj)
                    facing = h.rd(obj + 13); observed.add(facing)
                    check(facing & 12 == direction, f"{row['name']}: changed direction during walking phase {step_frame}")
                    check(regs['bc'] == obj, f"{row['name']}: lost object pointer")
                expected = {direction + phase for phase in range(4)} if kind == 1 else {direction}
                check(observed == expected, f"{row['name']}: invalid animation phases for direction {direction}: {observed}")
                row['animation_facings'][direction] = sorted(observed)

            asset = (ROOT / row['file']).read_bytes()
            length = row['tiles'] * 16
            first = asset[:length]
            second = asset[length:2 * length] if kind == 1 else first
            for bank in [0, 1]:
                h.mem[bank, 0x8200:0x8200 + length] = b'\xdb' * length
                h.mem[bank, 0x8a00:0x8a00 + length] = b'\xdb' * length
                h.wr(h.s('wSpriteFlags'), 0x20 if bank == 0 else 0)
                h.wr(h.s('hUsedSpriteIndex'), row['id'])
                h.wr(h.s('hUsedSpriteTile'), 0xa0 if bank == 0 else 0x20)
                h.call('GetUsedSprite')
                check(bytes(h.mem[bank, 0x8200:0x8200 + length]) == first, f"{row['name']}: incorrect standing graphics in VRAM bank {bank}")
                check(bytes(h.mem[bank, 0x8a00:0x8a00 + length]) == second, f"{row['name']}: another sprite's animation graphics in VRAM bank {bank}")

            for variable_id in variable_ids:
                h.wr(h.s('wVariableSprites') + variable_id - 0xf0, row['id'])
                regs = h.call('GetOverworldSpriteType', a=variable_id, bc=0x1234, de=0x5678)
                check(regs['a'] == kind and regs['bc'] == 0x1234 and regs['de'] == 0x5678, f"{row['name']}: variable {variable_id:02x} resolved incorrectly")
            if index % 16 == 0:
                print(f'Checked {index}/{len(humans)} NPC sheets', flush=True)

        by_name = {r['name']: r for r in humans}
        applicable = [(v, s) for v, s in variables if s in by_name]
        result['human_variable_assignments'] = len(applicable)
        for variable, sprite in applicable:
            h.wr(h.s('wVariableSprites') + ids[variable] - 0xf0, ids[sprite])
            row = by_name[sprite]
            length = row['tiles'] * 16
            asset = (ROOT / row['file']).read_bytes()
            first = asset[:length]
            second = asset[length:2 * length] if row['kind'] == 'WALKING_SPRITE' else first
            for bank in [0, 1]:
                h.mem[bank, 0x8200:0x8200 + length] = b'\xdb' * length
                h.mem[bank, 0x8a00:0x8a00 + length] = b'\xdb' * length
                h.wr(h.s('wSpriteFlags'), 0x20 if bank == 0 else 0)
                h.wr(h.s('hUsedSpriteIndex'), ids[variable])
                h.wr(h.s('hUsedSpriteTile'), 0xa0 if bank == 0 else 0x20)
                h.call('GetUsedSprite')
                check(bytes(h.mem[bank, 0x8200:0x8200 + length]) == first, f'{variable} -> {sprite}: wrong standing graphics in bank {bank}')
                check(bytes(h.mem[bank, 0x8a00:0x8a00 + length]) == second, f'{variable} -> {sprite}: wrong walking graphics in bank {bank}')
            for direction in [0, 4, 8, 12]:
                for phase in range(32):
                    facings = []
                    for sid in [ids[sprite], ids[variable]]:
                        h.wr(obj, bytes(40)); h.wr(obj, sid)
                        h.wr(obj + 8, direction); h.wr(obj + 12, phase)
                        h.call('SetFacingStepAction', bc=obj)
                        facings.append(h.rd(obj + 13))
                    check(facings[0] == facings[1], f'{variable} -> {sprite}: walking differs at direction {direction}, phase {phase}')
        # Negative controls use the current numeric ids, not stale hex comments
        # in sprite_constants.asm, whose Pokemon ids moved as NPCs were added.
        for sprite in ['SPRITE_UNOWN', 'SPRITE_LUGIA', 'SPRITE_HO_OH']:
            h.wr(obj, bytes(40)); h.wr(obj, ids[sprite])
            faces = set()
            for phase in range(32):
                h.wr(obj + 12, phase)
                h.call('SetFacingStepAction', bc=obj)
                faces.add(h.rd(obj + 13))
            check(faces == {0, 4}, f'{sprite}: icon animation changed')
    finally:
        h.pyboy.stop(save=False)
    return result


def contact_sheets(result, output):
    from PIL import Image, ImageDraw
    rows = [r for r in result['sprites'] if not r['pokemon'] and r['kind'] in ['WALKING_SPRITE', 'STANDING_SPRITE']]
    for start in range(0, len(rows), 24):
        page = Image.new('RGB', (840, 920), 'white'); draw = ImageDraw.Draw(page)
        for i, row in enumerate(rows[start:start + 24]):
            x, y = (i // 12) * 420, (i % 12) * 76
            draw.text((x + 4, y + 3), row['name'], fill='black')
            source = (ROOT / row['file']).read_bytes()
            for j in range(6):
                frame = j if row['kind'] == 'WALKING_SPRITE' else j % 3
                picture = Image.new('RGB', (16, 16), 'white')
                for tile in range(4):
                    chunk = source[frame * 64 + tile * 16:frame * 64 + tile * 16 + 16]
                    for py in range(8):
                        for px in range(8):
                            color = ((chunk[py * 2] >> (7 - px)) & 1) | (((chunk[py * 2 + 1] >> (7 - px)) & 1) << 1)
                            shade = [255, 170, 85, 0][color]
                            picture.putpixel((tile % 2 * 8 + px, tile // 2 * 8 + py), (shade, shade, shade))
                page.paste(picture.resize((48, 48), Image.Resampling.NEAREST), (x + 5 + j * 65, y + 19))
        page.save(output / f'npc-frames-{start // 24 + 1:02}.png')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime', action='store_true')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = audit(args.runtime)
    if args.output:
        args.output.mkdir(parents=True, exist_ok=True)
        (args.output / 'npc-walking-audit.json').write_text(json.dumps(result, indent=2))
        contact_sheets(result, args.output)
    for failure in result['failures'][:30]:
        print('FAIL', failure)
    print(f"{result['walking_definitions']} walking and {result['standing_definitions']} standing NPC sheets; {result['map_object_instances']} map object instances; {result['checks']} checks; {len(result['failures'])} failures")
    raise SystemExit(bool(result['failures']))
