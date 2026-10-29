#!/usr/bin/env python3
"""Inventory every Sour Apple move against active Crimson animation pointers.

Read-only comparison; writes reports, never changes animation scripts or the
previous import manifest. Follows scoped labels, branches, helpers and fallthrough.
Feature-name differences are review evidence, not proof of missing pixels.
"""
import argparse
from collections import Counter
import csv
import hashlib
import json
from pathlib import Path
import re
import subprocess

from audit_mae_animations import ROOT, Scripts


class Program:
    def __init__(self, root):
        self.blocks, self.next, self.locations = {}, {}, {}
        paths = sorted((root / 'data/moves').glob('animations*.asm'))
        special = root / 'data/moves/special_animations.asm'
        if special.exists():
            paths.append(special)
        for path in paths:
            scope, current, previous = '', None, None
            for number, raw in enumerate(path.read_text(encoding='utf-8-sig').splitlines(), 1):
                line = raw.split(';', 1)[0].strip()
                label = re.fullmatch(r'(\w+|\.\w+)(?:::?)?', line)
                if label and (':' in line or line.startswith('.')):
                    name = label[1]
                    if name.startswith('.'):
                        name = scope + name
                    else:
                        scope = name
                    if previous:
                        self.next[previous] = name
                    self.blocks[name] = []
                    self.locations[name] = (path.relative_to(root).as_posix(), number)
                    current = previous = name
                elif current and line.startswith('anim_'):
                    self.blocks[current].append((scope, line))

    def reachable(self, entry):
        visited, pending, commands, unresolved = set(), [entry], [], []
        while pending:
            label = pending.pop()
            if label in visited:
                continue
            visited.add(label)
            if label not in self.blocks:
                unresolved.append(label)
                continue
            lines = self.blocks[label]
            terminal = False
            for scope, line in lines:
                commands.append(line)
                command, _, args = line.partition(' ')
                if command in ('anim_call', 'anim_jump', 'anim_loop', 'anim_jumpuntil',
                               'anim_if_param_equal', 'anim_if_param_and', 'anim_if_var_equal'):
                    target = args.split(',')[-1].strip()
                    if target.startswith('.'):
                        target = scope + target
                    pending.append(target)
                if command in ('anim_ret', 'anim_jump'):
                    terminal = True
                    break
            if not terminal and label in self.next:
                pending.append(self.next[label])
        return dict(labels=sorted(visited), commands=commands, unresolved=sorted(set(unresolved)))


def revision(path):
    return subprocess.check_output(['git', '-C', str(path), 'rev-parse', 'HEAD'], text=True).strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upstream', type=Path, default=ROOT / '.tmpbuild/mae-sour-apple')
    parser.add_argument('--output', type=Path, default=ROOT / 'reports/sour-apple-animation-completeness-2026-10-28')
    args = parser.parse_args()
    upstream = args.upstream.resolve()
    local, source = Scripts(ROOT), Scripts(upstream, upstream=True)
    lp, sp = Program(ROOT), Program(upstream)
    local.reference_objects = {v: n for n, v in source.con.items() if n.startswith('ANIM_OBJ_')}
    local.reference_bgs = {local.con[n]: n for n in source.con if n.startswith('ANIM_BG_') and n in local.con}
    saved = json.loads((ROOT / 'tools/battletest/mae_animation_manifest.json').read_text())
    decisions = {row['move']: row for row in saved['moves']}

    def features(graph, is_local):
        text = '\n'.join(graph['commands'])
        if is_local:
            text = re.sub(r'ANIM_OBJ_[\dA-F]{2}\b',
                          lambda m: local.reference_objects.get(local.con.get(m[0]), m[0]), text)
            text = re.sub(r'ANIM_BG_\w+', lambda m: local.reference_bgs.get(local.con.get(m[0]), m[0]), text)
            text = re.sub(r'(ANIM_GFX_\w+)_SA\b', r'\1', text)
            text = re.sub(r'(ANIM_OBJ_\w+)_SOUR\b', r'\1', text)
        return sorted(set(re.findall(r'\b(?:ANIM_(?:OBJ|GFX|BG)_\w+|PAL_BTLCUSTOM_\w+|SFX_\w+)', text)))

    rows = []
    for move in sorted((set(local.moves) | set(source.moves)) - {'NO_MOVE'}):
        a, b = local.moves.get(move), source.moves.get(move)
        lg, sg = lp.reachable(a) if a else None, sp.reachable(b) if b else None
        lf, sf = features(lg, True) if lg else [], features(sg, False) if sg else []
        old = decisions.get(move, {})
        if a and b:
            status = old.get('status', 'new shared move')
        else:
            status = 'source move absent from local roster' if b else 'local move absent from source roster'
        rows.append(dict(move=move, status=status,
                         prior_reason=old.get('reason', ''),
                         local_label=a, source_label=b,
                         local_location=lp.locations.get(a), source_location=sp.locations.get(b),
                         local_graph=lg, source_graph=sg,
                         local_features=lf, source_features=sf,
                         source_only_features=sorted(set(sf)-set(lf)),
                         local_only_features=sorted(set(lf)-set(sf)),
                         source_has_effects=bool(sf)))
    support_changes = [name for name, digest in saved['support_file_sha256'].items()
                       if hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest]
    shared = [r for r in rows if r['local_label'] and r['source_label']]
    source_only = [r for r in rows if not r['local_label']]
    local_only = [r for r in rows if not r['source_label']]
    source_special = re.findall(r'^\s*dw (BattleAnim_\w+)',
                               (upstream/'data/moves/special_animations.asm').read_text().split('.IndirectEnd::')[0], re.M)
    source_special_names = re.findall(r'^\s*const (ANIM_\w+)',
                                     (upstream/'constants/move_constants.asm').read_text().split('const_value = -NUM_SPECIAL_ANIMS')[1].split('if const_value')[0], re.M)
    local_special = re.findall(r'^\s*banim (BattleAnim_\w+)',
                              (ROOT/'data/moves/animations.asm').read_text().split('BattleAnimations::')[0], re.M)
    local_special_names = re.findall(r'^\s*const (ANIM_\w+)',
                                    (ROOT/'constants/move_constants.asm').read_text().split('const_value = -$1b')[1].split('if const_value')[0], re.M)
    assert len(source_special_names) == len(source_special)
    assert len(local_special_names) == len(local_special)
    sa, la = dict(zip(source_special_names, source_special)), dict(zip(local_special_names, local_special))
    specials = []
    for name in sorted(set(sa) | set(la)):
        a, b = la.get(name), sa.get(name)
        specials.append(dict(animation=name, local_label=a, source_label=b,
                             local_graph=lp.reachable(a) if a else None,
                             source_graph=sp.reachable(b) if b else None))
    unresolved = [(r['move'], side, graph['unresolved']) for r in rows
                  for side in ('local', 'source') if (graph := r[f'{side}_graph']) and graph['unresolved']]
    unresolved += [(r['animation'], side, graph['unresolved']) for r in specials
                   for side in ('local', 'source') if (graph := r[f'{side}_graph']) and graph['unresolved']]
    summary = dict(upstream_repository='https://github.com/PiaCarrot/mae-pokeorange',
                   upstream_branch='sour-apple', upstream_commit=revision(upstream),
                   local_commit=revision(ROOT), date='2026-10-28',
                   local_moves=len(local.moves)-1, source_moves=len(source.moves)-1,
                   shared_moves=len(shared), source_only_moves=len(source_only), local_only_moves=len(local_only),
                   prior_classifications=dict(Counter(r['status'] for r in shared)),
                   source_only_with_effects=sum(r['source_has_effects'] for r in source_only),
                   source_special_animations=len(sa), local_special_animations=len(la),
                   source_only_special_animations=sorted(set(sa)-set(la)),
                   local_only_special_animations=sorted(set(la)-set(sa)),
                   unresolved_script_targets=unresolved, prior_support_hash_changes=support_changes)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'audit.json').write_text(json.dumps(dict(summary=summary, moves=rows, special_animations=specials), indent=2)+'\n')
    fields = ['move', 'status', 'local_label', 'source_label', 'local_location', 'source_location',
              'source_only_features', 'local_only_features', 'prior_reason']
    with (args.output / 'all-moves.csv').open('w', newline='', encoding='utf-8') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: '; '.join(map(str, row[key])) if isinstance(row.get(key), list) else row.get(key)
                             for key in fields})
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
