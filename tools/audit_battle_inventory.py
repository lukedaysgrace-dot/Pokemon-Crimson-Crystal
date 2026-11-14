#!/usr/bin/env python3
"""Write a source-derived battle catalog and dependency index for audit review.

This inventories definitions and references; it does not certify their behavior.
Run from any directory. Output defaults to reports/battle-audit-2026-11-13/.
"""
import argparse
import csv
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools' / 'battletest'))
from outcome_matrix import move_records
from symbols import Constants, _parse_constants


def write_csv(path, rows):
    with path.open('w', newline='', encoding='utf-8') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=Path, default=ROOT / 'reports/battle-audit-2026-11-13')
    args = ap.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    con = Constants()
    effects = _parse_constants(ROOT / 'constants/move_effect_constants.asm')
    pointers = re.findall(r'^\s*dw\s+(\w+)', (ROOT / 'data/moves/effects_pointers.asm').read_text(), re.M)
    scripts, label = {}, None
    for raw in (ROOT / 'data/moves/effects.asm').read_text().splitlines():
        line = raw.split(';')[0].strip()
        if re.fullmatch(r'\w+:', line):
            label = line[:-1]
            scripts[label] = []
        elif line and label:
            scripts[label].append(line)
    sources = sorted(set((ROOT / 'engine/battle').rglob('*.asm')) |
                     set((ROOT / 'data/moves').glob('*.asm')) |
                     set((ROOT / 'data/battle').glob('*.asm')) |
                     set((ROOT / 'data/abilities').glob('*.asm')) | {
        ROOT / 'home/battle.asm', ROOT / 'home/16bit.asm', ROOT / 'wram.asm',
        ROOT / 'home/abilities.asm', ROOT / 'home/battle_vars.asm',
        ROOT / 'engine/pc/storage_codec.asm', ROOT / 'engine/events/hidden_power_type.asm',
        ROOT / 'hram.asm', ROOT / 'macros/scripts/battle_commands.asm',
        ROOT / 'data/types/type_boost_items.asm', ROOT / 'data/items/attributes.asm',
        ROOT / 'constants/move_constants.asm', ROOT / 'constants/ability_constants.asm',
        ROOT / 'constants/item_constants.asm', ROOT / 'constants/battle_constants.asm',
    })
    sources = [path for path in sources if path.is_file()]
    texts = {path.relative_to(ROOT).as_posix(): path.read_text() for path in sources}
    moves = []
    for move in move_records():
        pointer = pointers[effects[move['effect']]]
        moves.append(dict(index=con.moves[move['name']], **move, script=pointer,
                          commands='; '.join(scripts[pointer])))
    flags = re.findall(r'^\s*db\s+\$([0-9a-fA-F]+)', (ROOT / 'data/abilities/flags.asm').read_text(), re.M)
    abilities = []
    for index, name in sorted(con.abilities_by_id.items()):
        abilities.append(dict(index=index, name=name, flags=flags[index],
                              source_references='; '.join(path for path, body in texts.items()
                                                         if re.search(rf'\b{re.escape(name)}\b', body))))
    # These four items are read by species-specific raw-ID checks rather
    # than GetItemHeldEffect. Metal Powder has a real held effect already.
    held, special = [], {'LIGHT_BALL', 'THICK_CLUB', 'LUCKY_PUNCH', 'STICK'}
    index = 0
    for line in (ROOT / 'data/items/attributes.asm').read_text().splitlines():
        match = re.match(r'\s*item_attribute\s+(.+)', line)
        if not match:
            continue
        index += 1
        parts = [part.strip() for part in match[1].split(';')[0].split(',')]
        name = con.items_by_id.get(index, f'RESERVED_{index:04X}')
        if parts[1] == 'HELD_NONE' and name not in special:
            continue
        held.append(dict(index=index, name=name, effect=parts[1], parameter=parts[2],
                         source_references='; '.join(path for path, body in texts.items()
                                                    if re.search(rf'\b(?:{re.escape(name)}|{re.escape(parts[1])})\b', body))))
    write_csv(args.output / 'moves.csv', moves)
    write_csv(args.output / 'abilities.csv', abilities)
    write_csv(args.output / 'held-items.csv', held)
    # Include direct calls, banked calls and jumps. Indirect dispatch and
    # data tables still require tracing and are explicitly separate above.
    edges = []
    for path, body in texts.items():
        owner = '<file>'
        for number, line in enumerate(body.splitlines(), 1):
            code = line.split(';')[0]
            match = re.match(r'^(\w+):', code)
            if match:
                owner = match[1]
            match = re.match(r'\s*(call|callfar|farcall|farcall_a|homecall|jp|jr)\s+(?:(?:nz|z|nc|c),\s*)?([\w.]+)', code)
            if match:
                edges.append(dict(file=path, line=number, caller=owner, instruction=match[1], target=match[2]))
    write_csv(args.output / 'call-sites.csv', edges)
    summary = dict(moves=len(moves), distinct_move_effects=len({move['effect'] for move in moves}),
                   effect_pointer_rows=len(pointers), script_labels=len(scripts),
                   distinct_dispatch_scripts=len(set(pointers)),
                   longest_script_commands=max(map(len, scripts.values())),
                   abilities_including_no_ability=len(abilities), held_item_records=len(held),
                   source_files=list(texts), direct_call_and_jump_sites=len(edges),
                   limitations='Catalog and call-site index only; no claim of behavioral correctness or exhaustive runtime coverage.')
    (args.output / 'inventory.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(json.dumps({key: value for key, value in summary.items() if key != 'source_files'}, indent=2))


if __name__ == '__main__':
    main()
