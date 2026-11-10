#!/usr/bin/env python3
"""Compare move classifications to an independently supplied Showdown source.

This is a data audit; native class/reaction matrices provide battle checks.
Custom move names are reported separately, never silently treated as matches.
"""
import argparse
import json
import re
from pathlib import Path

from outcome_matrix import move_records
from symbols import Constants, ROOT

ALIASES = dict(PSYCHIC_M='psychic', HI_JUMP_KICK='highjumpkick',
               VICEGRIP='visegrip', FAINT_ATTACK='feintattack',
               ANCIENTPOWER='ancientpower', DYNAMICPUNCH='dynamicpunch',
               SOLARBEAM='solarbeam', THUNDERPUNCH='thunderpunch',
               POISONPOWDER='poisonpowder', SLEEP_POWDER='sleeppowder',
               GIGA_HAMMER='gigatonhammer', PSYSHIELD='psyshieldbash',
               HEADLONGRUSH='headlongrush', PHANTOMFORCE='phantomforce',
               DUALWINGBEAT='dualwingbeat', KINGS_SHIELD='kingsshield', ACCELROCK='accelerock')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('reference', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    source = args.reference.read_text()
    reference = {}
    for match in re.finditer(r'^\t([a-z0-9]+): \{\n(.*?)(?=^\t[a-z0-9]+: \{|^};)', source, re.M | re.S):
        flags = re.search(r'\bflags: \{([^}]+)\}', match[2])
        reference[match[1]] = set(re.findall(r'(\w+): 1', flags[1])) if flags else set()
    assembly = (ROOT / 'engine/battle/abilities_engine.asm').read_text()
    classes = {}
    for label, flag in (('PunchMoves', 'punch'), ('SliceMoves', 'slicing'), ('PulseMoves', 'pulse'),
                        ('BiteMoves', 'bite'), ('SoundMoves', 'sound'), ('BallBombMoves', 'bullet'),
                        ('WindMoves', 'wind'), ('PowderMoves', 'powder'), ('TriageMoves', 'heal')):
        body = assembly.split(label + ':', 1)[1].split('\tdw -1', 1)[0]
        classes[flag] = set(re.findall(r'^\s*dw (\w+)\s*$', body, re.M))
    contact_source = (ROOT / 'data/moves/contact_moves.asm').read_text()
    bits = []
    for line in contact_source.splitlines():
        if line.strip().startswith('db '):
            bits.extend(int(value, 16) for value in re.findall(r'\$([0-9a-fA-F]+)', line.split(';')[0]))
    con = Constants()
    differences, unmapped, mapped = [], [], []
    for move in move_records():
        name = move['name']
        key = ALIASES.get(name, name.lower().replace('_', ''))
        if key not in reference:
            unmapped.append(name)
            continue
        mapped.append(name)
        for flag, members in classes.items():
            local = name in members
            expected = flag in reference[key]
            if local != expected:
                differences.append(dict(move=name, flag=flag, local=local, reference=expected))
        index = con.move_index(name)
        local = bool(bits[index // 8] & 1 << (index % 8))
        expected = 'contact' in reference[key]
        # Shell Side Arm resolves contact dynamically with its category.
        if name != 'SHELL_SIDE_ARM' and local != expected:
            differences.append(dict(move=name, flag='contact', local=local, reference=expected))
    result = dict(mapped=len(mapped), unmapped=unmapped, differences=differences)
    args.output.write_text(json.dumps(result, indent=2))
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
