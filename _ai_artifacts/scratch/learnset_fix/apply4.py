"""Pass 4: every TM/HM/tutor move a Pokemon learns by level-up in Scarlet/Violet, Sword/Shield or BDSP is also in its level-up learnset here (modern level; evolved forms use the pre-evolution level instead of a level-1 relearn slot).
Original note: make sure every Pokemon has a usable, stat-appropriate attack at every
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

PLAN = {"VENONAT": [[47, "PSYCHIC_M"]], "VENOMOTH": [[55, "PSYCHIC_M"]], "DUGTRIO": [[1, "NIGHT_SLASH"]], "SLOWPOKE": [[30, "SURF"]], "SLOWBRO": [[30, "SURF"]], "CLOYSTER": [[1, "ICICLE_CRASH"]], "DROWZEE": [[41, "NASTY_PLOT"]], "HYPNO": [[41, "NASTY_PLOT"]], "STARYU": [[40, "PSYCHIC_M"]], "SPINARAK": [[36, "PSYCHIC_M"]], "ARIADOS": [[41, "PSYCHIC_M"]], "SLOWKING": [[1, "NASTY_PLOT"], [1, "POWER_GEM"], [1, "SWAGGER"], [30, "SURF"]], "GIRAFARIG": [[46, "NASTY_PLOT"]], "DONPHAN": [[30, "ROCK_TOMB"]], "HONCHKROW": [[35, "NASTY_PLOT"]], "FARIGIRAF": [[46, "NASTY_PLOT"]], "GLISCOR": [[1, "NIGHT_SLASH"]], "WEAVILE": [[48, "NASTY_PLOT"]], "YANMEGA": [[1, "NIGHT_SLASH"]], "DEINO": [[24, "WORK_UP"]], "ZWEILOUS": [[24, "WORK_UP"]], "HYDREIGON": [[24, "WORK_UP"]], "FLYGON": [[1, "DIG"]], "SNORUNT": [[50, "WEATHER_BALL"]], "SPOINK": [[29, "POWER_GEM"]], "GRUMPIG": [[29, "POWER_GEM"]], "RIOLU": [[16, "WORK_UP"], [24, "NASTY_PLOT"]], "LUCARIO": [[24, "NASTY_PLOT"], [16, "WORK_UP"]], "NINETALES_ALOLAN": [[1, "NASTY_PLOT"]], "DUGTRIO_ALOLAN": [[1, "NIGHT_SLASH"]], "PONYTA_GALARIAN": [[50, "PSYCHIC_M"]], "RAPIDASH_GALARIAN": [[56, "PSYCHIC_M"]], "SLOWPOKE_GALARIAN": [[30, "SURF"]], "SLOWBRO_GALARIAN": [[30, "SURF"]], "SLOWKING_GALARIAN": [[1, "NASTY_PLOT"], [1, "POWER_GEM"], [1, "SWAGGER"], [30, "SURF"]], "ARCANINE_HISUIAN": [[1, "ROAR"]], "SNEASEL_HISUIAN": [[36, "HONE_CLAWS"]], "TAUROS_PALDEAN_FIRE": [[5, "WORK_UP"]], "TAUROS_PALDEAN_WATER": [[5, "WORK_UP"]], "ARON": [[8, "ROCK_TOMB"]], "LAIRON": [[8, "ROCK_TOMB"]], "AGGRON": [[8, "ROCK_TOMB"]], "ARCHEN": [[39, "DRAGON_CLAW"]], "TIRTOUGA": [[30, "CURSE"]], "CARRACOSTA": [[30, "CURSE"], [41, "RAIN_DANCE"]], "CHANDELURE": [[35, "CURSE"]], "SALANDIT": [[20, "SWEET_SCENT"], [40, "DRAGON_PULSE"]], "SALAZZLE": [[1, "KNOCK_OFF"], [1, "SWAGGER"], [20, "SWEET_SCENT"]], "BONSLY": [[20, "ROCK_TOMB"]]}
for c, lst in PLAN.items():
    for lvl, mv in lst: put(c, lvl, mv)
# Slowpoke family gets Surf back (modern level 30), so the Scald stand-in goes
for c in ['SLOWPOKE', 'SLOWBRO', 'SLOWKING']: rm(c, 'SCALD')
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
json.dump(LOG, open('/tmp/pass4_log.json', 'w'), indent=1)
print('species changed', len(LOG))
