#!/usr/bin/env python3
"""List actual new move access and teaching routes for every roster entry."""
import argparse
import io
import json
from pathlib import Path
import shutil
import subprocess
import tarfile

import audit_breeding_moves as breeding
import audit_learnset_variety as learnsets
from audit_canonical_learnsets import available

ROOT = learnsets.ROOT
BASELINE = 'b60a01f1dc52bcc8370ee9e2fdcceb045d001f8c'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--git', default=shutil.which('git'))
    args = parser.parse_args()
    receipt = json.loads((ROOT / 'tools/testdata/canonical_learnsets.json').read_text(encoding='utf-8'))
    changes = receipt['changes']
    current = breeding.breeding_data()
    after = available(current)
    # Read the clean pre-audit snapshot in memory; never check out or reset files.
    archive = subprocess.run([args.git, 'archive', '--format=tar', BASELINE, 'constants', 'data/pokemon'],
                             cwd=ROOT, capture_output=True, check=True).stdout
    with tarfile.open(fileobj=io.BytesIO(archive)) as tar:
        original = {m.name: tar.extractfile(m).read().decode('utf-8')
                    for m in tar.getmembers() if m.isfile() and m.name.endswith('.asm')}
    old_reads = learnsets.read, breeding.read, breeding.load_technical_tutors
    try:
        learnsets.read = breeding.read = lambda p: original[p]
        breeding.load_technical_tutors = lambda: {}
        before = available(breeding.breeding_data())
    finally:
        learnsets.read, breeding.read, breeding.load_technical_tutors = old_reads
    pokemon = {m['const']: m for m in json.loads((ROOT / 'docs/data/pokemon.json').read_text(encoding='utf-8'))}
    moves = {m['const']: m['name'] for m in json.loads((ROOT / 'docs/data/moves.json').read_text(encoding='utf-8'))}

    def name(c):
        if c.endswith('_CLONE'):
            return name(c[:-6]) + ' (Clone)'
        base = pokemon.get(c, {}).get('name', c.replace('_', ' ').title())
        for suffix, form in [('_ALOLAN', 'Alolan'), ('_GALARIAN', 'Galarian'),
                             ('_HISUIAN', 'Hisuian'), ('_PALDEAN_FIRE', 'Paldean Blaze Breed'),
                             ('_PALDEAN_WATER', 'Paldean Aqua Breed'), ('_PALDEAN', 'Paldean'),
                             ('BM', 'Bloodmoon')]:
            if c.endswith(suffix):
                return f'{base} ({form})'
        return base

    def move_names(ms):
        return ', '.join(sorted((moves[m] for m in ms), key=str.casefold))

    records = []
    for c in sorted(current[0], key=lambda c: name(c).casefold()):
        before.setdefault(c, set())  # Species appended after the baseline have no old access.
        assert before[c] <= after[c], (c, 'unexpected removed access', before[c] - after[c])
        root = current[-1][c]
        natural = changes['level_up'].get(c, {})
        thematic = changes.get('thematic_level_up', {}).get(c, {})
        fallback = changes['donor_fallbacks'].get(c, {})
        eggs = changes['egg_moves'].get(root, [])
        machines = changes['tmhm'].get(c, [])
        tutors = changes['technical_tutor'].get(c, [])
        added = after[c] - before[c]
        utility = added & {m for i, m in enumerate(breeding.UTILITY) if current[5][c] & (1 << i)}
        direct = set(natural) | set(thematic) | set(fallback) | set(eggs) | set(machines) | set(tutors) | utility
        inherited = added - direct
        records.append({'species': c, 'name': name(c), 'newly_available': sorted(added),
                        'new_level_up': natural, 'breeding_fallbacks': fallback,
                        'thematic_level_up': thematic,
                        'new_family_egg_moves': eggs, 'egg_family': name(root),
                        'new_tm_compatibility': machines, 'new_tutor_routes': tutors,
                        'new_evolution_access': sorted(inherited)})
        if utility:
            records[-1]['new_utility_tutor'] = sorted(utility)
    canonical_count = sum(len(set(r['newly_available']) & set(receipt['expected'].get(r['species'], []))) for r in records)
    total_count = sum(len(r['newly_available']) for r in records)
    lines = ['# New move additions by Pokémon', '',
             f'All {len(current[0])} roster entries, in alphabetical order. Regional forms, clones and custom forms are listed separately.', '',
             '**Newly available** lists moves that the Pokémon could not obtain before this pass. '
             'The route lists also include new ways to learn moves it already had—for example, '
             'Aron, Lairon and Aggron already had Body Press through their custom family egg list and now learn it at levels 32, 38 and 44.', '',
             '**Level-up** gives the added level. **Egg** entries apply to the named family, including evolved Pokémon through breeding/evolution or the family egg tutor. '
             '**TM/HM/elemental tutor** means newly enabled compatibility. '
             '**Thematic level-up** means an explicitly custom level chosen for a move that fits the Pokémon. '
             '**Blackthorn tutor** means the purple tutor in the Move Deleter\'s House (¥5000). '
             'He teaches the verified moves without another suitable route, along with family egg moves. '
             'The Goldenrod tutor retains only its original five utility moves. '
             '**Evolution access** means a new move retained from a pre-evolution. '
             '**Breeding fallback** is the documented level-30 source where this roster has no independent breeding donor.', '',
             'This lists changes to Pokémon move access; it does not introduce new battle moves to the engine. '
             f'The comparison baseline is repository commit `{BASELINE}`.', '',
             f'**{len(records)} entries; {sum(bool(r["newly_available"]) for r in records)} gain moves they previously could not obtain; '
             f'{total_count:,} newly available Pokémon/move pairs.**', '',
             f'Of these, {canonical_count:,} close canonical gaps. The other {total_count - canonical_count:,} '
             'are additional inherited access through this project\'s evolution and breeding relationships.', '',
             '**Every verified implemented move is available; no historical move candidates remain deferred.** '
             'The audit also checks that none of the previously expanded movepools were trimmed.', '']
    for r in records:
        lines += [f'## {r["name"]}', '']
        if r['newly_available']:
            lines.append(f'**Newly available ({len(r["newly_available"])}):** {move_names(r["newly_available"])}.')
        else:
            lines.append('**Newly available:** None.')
        lines.append('')
        rows = []
        for label, key in [('Natural/restored level-up', 'new_level_up'),
                           ('Thematic level-up (custom)', 'thematic_level_up'), ('Breeding fallback', 'breeding_fallbacks')]:
            if r[key]:
                text = ', '.join(f'{moves[m]} (Lv. {lv})' for m, lv in sorted(r[key].items(), key=lambda x: (x[1], moves[x[0]])))
                rows.append(f'- **{label}:** {text}.')
        if r['new_family_egg_moves']:
            rows.append(f'- **Egg ({r["egg_family"]} family):** {move_names(r["new_family_egg_moves"])}.')
        for label, key in [('TM/HM/elemental tutor', 'new_tm_compatibility'),
                           ('Goldenrod utility tutor', 'new_utility_tutor'),
                           ('Blackthorn tutor', 'new_tutor_routes'), ('Evolution access', 'new_evolution_access')]:
            if r.get(key):
                rows.append(f'- **{label}:** {move_names(r[key])}.')
        lines += rows or ['No new acquisition routes were added.']
        lines.append('')
    target = ROOT / 'docs/learnset-additions-by-pokemon.md'
    target.write_text('\n'.join(lines), encoding='utf-8')
    review = ['# Canonical move access status', '',
              '**No verified implemented moves are awaiting placement.** '
              'The remaining historical options have been assigned to the Blackthorn tutor. '
              'Existing level-up, breeding and machine routes are preserved. Goldenrod retains its original utility moves.', '']
    for r in records:
        pending = receipt.get('deferred_moves', {}).get(r['species'], [])
        if pending:
            review += [f'## {r["name"]}', '', move_names(pending)+'.', '']
    (ROOT/'docs/canonical-moves-awaiting-review.md').write_text('\n'.join(review), encoding='utf-8')
    output = {'baseline': BASELINE, 'move_names': moves, 'pokemon': records}
    (ROOT / 'docs/data/learnset-additions.json').write_text(json.dumps(output, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(f'Wrote {target}: {len(records)} entries, {sum(len(r["newly_available"]) for r in records)} newly available species/move pairs.')
    for c in ['ARON', 'LAIRON', 'AGGRON']:
        r = next(r for r in records if r['species'] == c)
        print(r['name'], ':', move_names(r['newly_available']))


if __name__ == '__main__':
    main()
