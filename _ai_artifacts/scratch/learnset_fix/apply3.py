"""Pass 3 (small follow-up to pass 2): make sure every Pokemon has a usable, stat-appropriate attack at every
stage of the game. Levels and moves are based on the Gen 8/9 learnsets where the
move exists in Crimson Crystal; special attackers get special moves.
Run once on top of apply.py's output."""
import sys, os, re, json, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lib import *

DRY = '--dry' in sys.argv
E = Evo()
LS = {c: E.get(c) for c in order}
LOG = collections.defaultdict(list)

def has(c, mv): return any(m == mv for l, m in LS[c])
def put(c, lvl, mv):
    """Learn `mv` at `lvl` (moves an existing entry, otherwise adds one)."""
    assert mv in MOVES, mv
    if has(c, mv):
        old = [l for l, m in LS[c] if m == mv]
        LS[c] = [(l, m) for l, m in LS[c] if m != mv] + [(lvl, mv)]
        LOG[c].append(f'{mv} {old[0]}->{lvl}')
    else:
        LS[c].append((lvl, mv)); LOG[c].append(f'+{mv}@{lvl}')
def rm(c, mv):
    assert has(c, mv), (c, mv)
    LS[c] = [(l, m) for l, m in LS[c] if m != mv]; LOG[c].append(f'-{mv}')
def fam(cs, lvl, mv):
    for c in cs: put(c, lvl, mv)


fam(['VULPIX', 'NINETALES'], 22, 'FLAMETHROWER')
fam(['TANGELA', 'TANGROWTH'], 30, 'SEED_BOMB')
put('AMPHAROS', 42, 'DAZZLING_GLEAM')
put('GOLETT', 31, 'PHANTOMFORCE')
fam(['DRAKLOAK', 'DRAGAPULT'], 34, 'PHANTOMFORCE')
fam(['CETODDLE', 'CETITAN'], 32, 'ICICLE_CRASH')
put('TAUROS_PALDEAN_FIRE', 10, 'FLAME_CHARGE')
fam(['FINIZEN', 'PALAFIN'], 20, 'FLIP_TURN')
# ---------------------------------------------------------------------------
REAL = [c for c in order if not c.endswith('_CLONE')]
for c in REAL:  # one entry per move
    seen = {}
    for l, m in sorted(LS[c]):
        if m not in seen or (seen[m] == 1 and l > 1 and c != 'SMEARGLE'): seen[m] = l
    if c != 'SMEARGLE': LS[c] = sorted(((l, m) for m, l in seen.items()), key=lambda x: x[0])
for cl in [c for c in order if c.endswith('_CLONE')]: LS[cl] = list(LS[cl[:-6]])
if not DRY:
    for c in order: E.set(c, LS[c]); E.save()

# TM moves now learned by level must be TM-compatible
for c in REAL:
    tms = set(read_bs(c)['tms'])
    if not tms: continue
    need = {m for l, m in LS[c] if m in TMSET} - tms
    if need:
        LOG[c].append('TM+' + ','.join(sorted(need)))
        if not DRY: write_tms(c, tms | need)

# egg lists: drop anything the base form now learns by level
for path in ['data/pokemon/egg_moves_kanto.asm', 'data/pokemon/egg_moves_johto.asm']:
    s = rd(path); out = []; cur = None
    ptr = dict(re.findall(r'^\s*dw (\w+EggMoves) ; (\w+)', s, re.M))
    lab2sp = {lab: sp for lab, sp in ptr.items()}
    for line in s.split('\n'):
        mm = re.match(r'^(\w+EggMoves):', line)
        if mm: cur = lab2sp.get(mm.group(1)); out.append(line); continue
        mm = re.match(r'^\s*dw (\w+)$', line)
        if mm and cur and mm.group(1) != '-1':
            sp = cur[:-6] if cur.endswith('_CLONE') else cur
            if has(sp, mm.group(1)):
                LOG[sp].append(f'egg-{mm.group(1)}'); continue
        out.append(line)
    if not DRY: wr(path, '\n'.join(out))
json.dump(LOG, open('/tmp/pass3_log.json', 'w'), indent=1)
print('species changed', len(LOG))
