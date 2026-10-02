"""Pass 2: make sure every Pokemon has a usable, stat-appropriate attack at every
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

# --- the soft spots called out last time ---------------------------------
fam(['MAREEP', 'FLAAFFY', 'AMPHAROS'], 17, 'VOLT_SWITCH')          # special Electric, not Spark
fam(['FLAAFFY', 'AMPHAROS'], 36, 'THUNDERBOLT')
fam(['PAWNIARD', 'BISHARP', 'KINGAMBIT'], 30, 'NIGHT_SLASH')
put('PAWNIARD', 40, 'IRON_HEAD'); fam(['BISHARP', 'KINGAMBIT'], 42, 'IRON_HEAD')
fam(['ROOKIDEE', 'CORVISQUIRE', 'CORVIKNIGHT'], 16, 'WING_ATTACK')
put('ROOKIDEE', 28, 'DRILL_PECK'); fam(['CORVISQUIRE', 'CORVIKNIGHT'], 30, 'DRILL_PECK')
put('MIMIKYU', 20, 'SHADOW_CLAW'); put('MIMIKYU', 34, 'PLAY_ROUGH'); put('MIMIKYU', 40, 'PHANTOMFORCE')
put('MAWILE', 15, 'FAIRY_WIND'); put('MAWILE', 20, 'METAL_CLAW'); put('MAWILE', 31, 'IRON_HEAD')
put('CHARCADET', 18, 'FLAME_CHARGE'); fam(['CHARCADET', 'CERULEDGE'], 28, 'FIRE_FANG')
put('CERULEDGE', 40, 'PHANTOMFORCE')
put('QWILFISH', 21, 'POISON_JAB'); put('OVERQWIL', 21, 'POISON_JAB'); put('QWILFISH', 29, 'AQUA_TAIL')
put('SHIELDON', 5, 'TAUNT'); fam(['SHIELDON', 'BASTIODON'], 10, 'ANCIENTPOWER')
put('SPOINK', 5, 'CONFUSION'); put('GRUMPIG', 5, 'CONFUSION')
put('BOUNSWEET', 6, 'RAZOR_LEAF')

# --- early game (something real to attack with by ~Lv12) -----------------
fam(['GASTLY', 'HAUNTER', 'GENGAR'], 12, 'HEX')
fam(['LICKITUNG', 'LICKILICKY'], 12, 'STOMP')
fam(['KOFFING', 'WEEZING', 'WEEZING_GALARIAN'], 12, 'SLUDGE')
fam(['DUNSPARCE', 'DUDUNSPARCE'], 9, 'MUD_SLAP')
put('DUSKULL', 12, 'SHADOW_SNEAK')
for c in ['SANDILE', 'KROKOROK', 'KROOKODILE']: put(c, 1, 'SCRATCH'); put(c, 9, 'BITE')
put('TYROGUE', 6, 'FAKE_OUT'); put('TYROGUE', 11, 'ENDURE')

# --- around Lv20: a same-type attack of the right kind ---------------------
fam(['MEOWTH', 'PERSIAN'], 20, 'SLASH')
put('SEEL', 17, 'BUBBLEBEAM')
fam(['TANGELA', 'TANGROWTH'], 20, 'GIGA_DRAIN'); fam(['TANGELA', 'TANGROWTH'], 34, 'SEED_BOMB')
fam(['PORYGON', 'PORYGON2', 'PORYGON_Z'], 20, 'TRI_ATTACK')
fam(['HOPPIP', 'SKIPLOOM', 'JUMPLUFF'], 20, 'GIGA_DRAIN')
fam(['AIPOM', 'AMBIPOM'], 20, 'SLAM'); put('AMBIPOM', 1, 'FAKE_OUT'); put('AMBIPOM', 38, 'BODY_SLAM')
fam(['SNUBBULL', 'GRANBULL'], 22, 'PLAY_ROUGH')
fam(['TEDDIURSA', 'URSARING', 'URSALUNA'], 20, 'SLASH')
fam(['SWABLU', 'ALTARIA'], 18, 'DRAINING_KISS')
put('APPLIN', 18, 'DRAGONBREATH')
fam(['BUNEARY', 'LOPUNNY'], 18, 'DIZZY_PUNCH'); put('LOPUNNY', 44, 'HI_JUMP_KICK')
fam(['CETODDLE', 'CETITAN'], 20, 'AVALANCHE'); fam(['CETODDLE', 'CETITAN'], 34, 'ICICLE_CRASH')
put('TAUROS_PALDEAN_WATER', 22, 'LIQUIDATION')
fam(['JOLTIK', 'GALVANTULA'], 20, 'STRUGGLE_BUG'); fam(['JOLTIK', 'GALVANTULA'], 29, 'SIGNAL_BEAM')
fam(['FINIZEN', 'PALAFIN'], 24, 'FLIP_TURN'); fam(['FINIZEN', 'PALAFIN'], 32, 'AQUA_TAIL')
put('DUSKULL', 21, 'SHADOW_PUNCH'); fam(['DUSCLOPS', 'DUSKNOIR'], 21, 'SHADOW_PUNCH')
fam(['DUSCLOPS', 'DUSKNOIR'], 30, 'SHADOW_CLAW')
for c in ['SHUPPET', 'BANETTE']: put(c, 14, 'SHADOW_SNEAK'); put(c, 22, 'SHADOW_CLAW')

# --- around Lv30: a ~65-80 power same-type attack of the right kind --------
fam(['SANDSLASH'], 31, 'DRILL_RUN')
fam(['DUGTRIO', 'DUGTRIO_ALOLAN'], 31, 'DRILL_RUN')
fam(['MAGNEMITE', 'MAGNETON', 'MAGNEZONE'], 22, 'VOLT_SWITCH')
fam(['VOLTORB', 'ELECTRODE'], 27, 'VOLT_SWITCH')
put('JOLTEON', 25, 'VOLT_SWITCH')
fam(['SCYTHER', 'SCIZOR', 'KLEAVOR'], 30, 'X_SCISSOR')
put('MAGBY', 32, 'FLAMETHROWER'); fam(['MAGMAR', 'MAGMORTAR'], 33, 'FLAMETHROWER')
fam(['DRATINI', 'DRAGONAIR', 'DRAGONITE'], 28, 'DRAGON_TAIL')
fam(['DRATINI', 'DRAGONAIR', 'DRAGONITE'], 42, 'OUTRAGE')
fam(['GOLBAT', 'CROBAT'], 30, 'CROSS_POISON'); fam(['GOLBAT', 'CROBAT'], 40, 'POISON_JAB')
fam(['SNEASEL', 'WEAVILE'], 28, 'ICE_FANG')
fam(['SLUGMA', 'MAGCARGO'], 29, 'FLAMETHROWER')
put('SWINUB', 22, 'ICE_FANG')
put('PINECO', 28, 'GYRO_BALL'); put('FORRETRESS', 31, 'GYRO_BALL')
put('GOLETT', 34, 'PHANTOMFORCE'); put('GOLURK', 36, 'PHANTOMFORCE')
put('LARVESTA', 30, 'SIGNAL_BEAM')
fam(['ZWEILOUS', 'HYDREIGON'], 32, 'DARK_PULSE')
fam(['DREEPY', 'DRAKLOAK', 'DRAGAPULT'], 30, 'DRAGON_TAIL')
put('MORGREM', 32, 'FOUL_PLAY'); put('GRIMMSNARL', 36, 'FOUL_PLAY')
put('FLAPPLE', 30, 'SEED_BOMB'); put('FLAPPLE', 36, 'GRAV_APPLE')
fam(['DURALUDON', 'ARCHALUDON'], 30, 'FLASH_CANNON')
put('CHARJABUG', 29, 'SIGNAL_BEAM')
fam(['VIBRAVA', 'FLYGON'], 30, 'DRAGON_TAIL'); fam(['VIBRAVA', 'FLYGON'], 38, 'X_SCISSOR')
fam(['SNORUNT', 'FROSLASS'], 28, 'FREEZE_DRY')
fam(['URSARINGBM', 'URSALUNABM'], 32, 'EARTH_POWER')
fam(['MEOWTH_ALOLAN', 'PERSIAN_ALOLAN'], 32, 'DARK_PULSE')
fam(['PONYTA_GALARIAN', 'RAPIDASH_GALARIAN'], 32, 'PLAY_ROUGH')
rm('TAUROS_PALDEAN_FIRE', 'AQUA_JET'); rm('TAUROS_PALDEAN_FIRE', 'LIQUIDATION')   # water moves on the fire breed
put('TAUROS_PALDEAN_FIRE', 28, 'FLAME_WHEEL')
fam(['TAUROS_PALDEAN_FIRE', 'TAUROS_PALDEAN_WATER'], 32, 'BRICK_BREAK')
fam(['TAUROS_PALDEAN_FIRE', 'TAUROS_PALDEAN_WATER'], 36, 'RAGING_BULL')
fam(['ARCHEN', 'ARCHEOPS'], 27, 'ROCK_SLIDE')
fam(['TIRTOUGA', 'CARRACOSTA'], 29, 'ROCK_SLIDE')
fam(['EXEGGUTOR_ALOLAN'], 32, 'DRAGON_TAIL'); put('EXEGGUTOR_ALOLAN', 44, 'OUTRAGE')

# --- around Lv40-50 ------------------------------------------------------
put('PARASECT', 50, 'X_SCISSOR')
put('FLAREON', 40, 'FLARE_BLITZ')
fam(['WHIRLIPEDE', 'SCOLIPEDE'], 39, 'POISON_JAB'); put('SCOLIPEDE', 50, 'MEGAHORN')
put('CENTISKORCH', 42, 'HEAT_CRASH')
fam(['SALANDIT', 'SALAZZLE'], 40, 'FLAMETHROWER')

# --- dead stretches (no new move for 12+ levels) ---------------------------
fam(['EKANS', 'ARBOK'], 28, 'POISON_JAB')
fam(['NIDORINA', 'NIDORINO'], 43, 'EARTH_POWER')
fam(['CLEFAIRY', 'CLEFABLE'], 36, 'CALM_MIND'); fam(['CLEFAIRY', 'CLEFABLE'], 44, 'WISH')
put('VULPIX', 39, 'HEAT_WAVE'); put('NINETALES', 39, 'HEAT_WAVE')
put('EXEGGUTOR', 44, 'LEAF_STORM')
fam(['GOLDEEN', 'SEAKING'], 43, 'HYDRO_PUMP')
put('TOGETIC', 40, 'AURA_SPHERE'); put('TOGEKISS', 40, 'AURA_SPHERE')
put('BELLOSSOM', 35, 'QUIVER_DANCE'); put('BELLOSSOM', 41, 'DAZZLING_GLEAM')
put('POLITOED', 36, 'WATER_PULSE')
put('MILTANK', 35, 'HEAL_BELL')
put('GARDEVOIR', 45, 'DREAM_EATER'); put('GARDEVOIR', 48, 'FUTURE_SIGHT')
put('GRUMPIG', 41, 'CALM_MIND'); put('GRUMPIG', 45, 'FUTURE_SIGHT')
put('NINETALES_ALOLAN', 42, 'MOONBLAST')

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
json.dump(LOG, open('/tmp/pass2_log.json', 'w'), indent=1)
print('species changed', len(LOG))
