import sys, os, re, json, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lib import *

DRY = '--dry' in sys.argv
LOG = collections.defaultdict(list)
def log(c, msg): LOG[c].append(msg)

E = Evo()
INFO = {c: read_bs(c) for c in order}
LS = {c: E.get(c) for c in order}
ORIG_LS = {c: list(v) for c, v in LS.items()}
ORIG_TM = {c: list(INFO[c]['tms']) for c in order}
CLONES = [c for c in order if c.endswith('_CLONE')]
REAL = [c for c in order if c not in CLONES]
ORIG251 = set(order[:251])
ADDED = [c for c in REAL if c not in ORIG251]

PAR = {}
for c in REAL:
    for m_, a, t in E.evos(c):
        if t in REAL: PAR.setdefault(t, c)
def base(c):
    while c in PAR: c = PAR[c]
    return c
FAM = collections.defaultdict(list)
for c in REAL: FAM[base(c)].append(c)
def types(c): return set(INFO[c]['types'])
def atk(c): return INFO[c]['stats'][1]
def sat(c): return INFO[c]['stats'][4]
def has_evo(c): return bool(E.evos(c))

# ---------------- level-up helpers ----------------
def moves_of(c): return {m for l, m in LS[c]}
def rm(c, mv):
    if mv in moves_of(c):
        LS[c] = [(l, m) for l, m in LS[c] if m != mv]; log(c, f'-{mv}')
def setlv(c, mv, lv):
    assert mv in moves_of(c), (c, mv)
    LS[c] = [(lv if m == mv else l, m) for l, m in LS[c]]; log(c, f'{mv}->{lv}')
def add(c, lv, mv):
    assert mv in MOVES, mv
    if mv in moves_of(c): setlv(c, mv, lv); return
    LS[c].append((lv, mv)); log(c, f'+{mv}@{lv}')
def setls(c, pairs):
    for l, m in pairs: assert m in MOVES, (c, m)
    LS[c] = list(pairs); log(c, 'rewritten')

# ---- 1. bugs / placeholder sets ----
setls('TOTODILE', [(1,'SCRATCH'),(1,'LEER'),(5,'WATER_GUN'),(8,'MUD_SLAP'),(11,'BITE'),(14,'SCARY_FACE'),(17,'ICE_FANG'),
    (20,'FLAIL'),(23,'CRUNCH'),(26,'AQUA_TAIL'),(29,'SLASH'),(29,'NIGHT_SLASH'),(29,'LOW_KICK'),(32,'SCREECH'),(35,'THRASH'),(38,'AGILITY'),(44,'HYDRO_PUMP')])
LS['KOTORA'] = [(l, {'SLACK_OFF':'TAIL_WHIP','VOLT_TACKLE':'THUNDERSHOCK'}.get(m, m)) for l, m in LS['KOTORA']]; log('KOTORA', 'Slack Off->Tail Whip, Volt Tackle->Thundershock')
for c in ['TOGEPI', 'TOGETIC']:
    setlv(c, 'EXTRASENSORY', 20)
setlv('JYNX', 'ICE_PUNCH', 28)
setls('GOROCHU', [(1,'THUNDERSHOCK'),(1,'TAIL_WHIP'),(1,'QUICK_ATTACK'),(1,'BITE'),(1,'THUNDER_WAVE'),(1,'NUZZLE'),(1,'SPARK'),
    (1,'THUNDERPUNCH'),(1,'FIRE_PUNCH'),(1,'SWIFT'),(34,'SNARL'),(36,'CRUNCH'),(38,'EXTREMESPEED'),(40,'WILD_CHARGE'),
    (44,'SUCKER_PUNCH'),(48,'LIGHT_SCREEN'),(50,'FOUL_PLAY'),(52,'THUNDER'),(58,'VOLT_TACKLE')])

# ---- 2. evolution penalty: evolved form keeps the pre-evo's levels ----
MATCH = [('VULPIX','NINETALES'),('JIGGLYPUFF','WIGGLYTUFF'),('CLEFAIRY','CLEFABLE'),('GLOOM','VILEPLUME'),('GROWLITHE','ARCANINE'),
 ('POLIWHIRL','POLIWRATH'),('WEEPINBELL','VICTREEBEL'),('SHELLDER','CLOYSTER'),('EXEGGCUTE','EXEGGUTOR'),('EXEGGCUTE','EXEGGUTOR_ALOLAN'),
 ('STARYU','STARMIE'),('SUNKERN','SUNFLORA'),('LOMBRE','LUDICOLO'),('TOGETIC','TOGEKISS'),('MISDREAVUS','MISMAGIUS'),('PIKACHU','RAICHU'),
 ('PIKACHU','RAICHU_ALOLAN'),('VULPIX_ALOLAN','NINETALES_ALOLAN'),('GROWLITHE_HISUIAN','ARCANINE_HISUIAN'),('VOLTORB_HISUIAN','ELECTRODE_HISUIAN'),
 ('SANDSHREW_ALOLAN','SANDSLASH_ALOLAN'),('MURKROW','HONCHKROW'),('DRILBUR','EXCADRILL'),('NIDORINA','NIDOQUEEN'),('NIDORINO','NIDOKING'),
 ('FLETCHLING','FLETCHINDER'),('FLETCHINDER','TALONFLAME'),('AMAURA','AURORUS'),('GIRAFARIG','FARIGIRAF'),('DIPPLIN','FLAPPLE'),
 ('SHROOMISH','BRELOOM'),('QWILFISH','OVERQWIL'),('URSARINGBM','URSALUNABM'),('PRIMEAPE','ANNIHILAPE'),('JYNX','MESMERIA')]
NO_ADD = {'SKULL_BASH', 'APPLE_ACID', 'SOLARBEAM'}
def pw(m): return MOVEPOW.get(m, 0)
MOVEPOW = {x['const']: (x['power'] or 0) for x in json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'moves.json')))}
for pre, evo in MATCH:
    pl = {}
    for l, m in LS[pre]:
        if l > 1: pl.setdefault(m, l)
    ev = {}
    for l, m in LS[evo]:
        if l > 1: ev.setdefault(m, l)
    allev = moves_of(evo)
    for m, l in pl.items():
        if m in ev and ev[m] > l:
            LS[evo] = [(l if (mm == m and ll > 1) else ll, mm) for ll, mm in LS[evo]]; log(evo, f'{m}->{l} (match {pre})')
        elif m not in allev and pw(m) >= 70 and m not in NO_ADD:
            LS[evo].append((l, m)); log(evo, f'+{m}@{l} (from {pre})')

# ---- 3. late STAB / thin sets ----
for c in ['NIDOQUEEN', 'NIDOKING']:
    setlv(c, 'EARTHQUAKE', 50); setlv(c, 'TOXIC', 54); setlv(c, 'EARTH_POWER', 58)
setlv('NIDOQUEEN', 'SUPER_FANG', 62)
for c in ['NIDORINA', 'NIDORINO']: setlv(c, 'EARTH_POWER', 55)
for c in ['FLETCHINDER', 'TALONFLAME']: add(c, 20, 'FLAME_WHEEL')
setlv('TALONFLAME', 'BRAVE_BIRD', 60)
setlv('EXCADRILL', 'IRON_HEAD', 36)
setlv('PAWNIARD', 'IRON_HEAD', 45); setlv('PAWNIARD', 'SWORDS_DANCE', 50); setlv('PAWNIARD', 'GUILLOTINE', 60)
for c in ['BISHARP', 'KINGAMBIT']:
    setlv(c, 'IRON_HEAD', 47); setlv(c, 'SWORDS_DANCE', 52); setlv(c, 'GUILLOTINE', 66)
add('GOLETT', 28, 'BULLDOZE'); setlv('GOLETT', 'EARTHQUAKE', 46)
add('GOLURK', 28, 'BULLDOZE'); setlv('GOLURK', 'EARTHQUAKE', 50); setlv('GOLURK', 'DYNAMICPUNCH', 56)
for c in ['DURALUDON', 'ARCHALUDON']:
    add(c, 18, 'DRAGONBREATH'); add(c, 24, 'IRON_HEAD'); setlv(c, 'DRAGON_CLAW', 30); setlv(c, 'FLASH_CANNON', 36)
add('LUCARIO', 40, 'FLASH_CANNON')
add('DODUO', 24, 'TAKE_DOWN'); add('DODRIO', 26, 'TAKE_DOWN')
add('GYARADOS', 30, 'BOUNCE')
for c in ['DUNSPARCE', 'DUDUNSPARCE']: add(c, 25, 'DRAGONBREATH')
setls('DREEPY', [(1,'ASTONISH'),(1,'QUICK_ATTACK'),(1,'INFESTATION'),(1,'BITE'),(6,'TWISTER'),(12,'HEX'),(18,'DRAGONBREATH'),
    (24,'AGILITY'),(30,'DUALWINGBEAT'),(34,'SCALE_SHOT'),(36,'DRAGON_TAIL'),(40,'PHANTOMFORCE')])
for c in ['DRAKLOAK', 'DRAGAPULT']: add(c, 12, 'DRAGONBREATH')
add('CHARCADET', 28, 'HEX')
setls('ARMAROUGE', [(1,'EMBER'),(1,'LEER'),(1,'ASTONISH'),(12,'FIRE_SPIN'),(16,'WILL_O_WISP'),(20,'NIGHT_SHADE'),(24,'FLAME_CHARGE'),
    (28,'HEX'),(32,'PSYBEAM'),(36,'FLAMETHROWER'),(38,'CALM_MIND'),(42,'EXTRASENSORY'),(46,'HEAT_WAVE'),(50,'ARMOR_CANNON'),(58,'OVERHEAT')])
setls('CERULEDGE', [(1,'EMBER'),(1,'LEER'),(1,'ASTONISH'),(1,'SHADOW_SNEAK'),(1,'NIGHT_SLASH'),(1,'SOLAR_BLADE'),(12,'FIRE_SPIN'),
    (16,'WILL_O_WISP'),(20,'NIGHT_SHADE'),(24,'FLAME_CHARGE'),(28,'HEX'),(32,'SHADOW_CLAW'),(34,'FIRE_FANG'),(37,'SWORDS_DANCE'),
    (40,'PSYCHO_CUT'),(44,'PHANTOMFORCE'),(48,'BITTER_BLADE'),(52,'HEAT_WAVE'),(58,'FLARE_BLITZ')])
setls('IMPIDIMP', [(1,'FAKE_OUT'),(4,'BITE'),(8,'SWEET_KISS'),(12,'DISARMING_VOICE'),(16,'TAUNT'),(18,'LOW_SWEEP'),(20,'SUCKER_PUNCH'),
    (20,'SWAGGER'),(24,'DRAINING_KISS'),(28,'SNARL'),(34,'FOUL_PLAY'),(38,'DARK_PULSE'),(42,'NASTY_PLOT'),(46,'PLAY_ROUGH')])
setls('MORGREM', [(1,'FAKE_OUT'),(1,'BITE'),(1,'SWEET_KISS'),(1,'DISARMING_VOICE'),(16,'TAUNT'),(20,'SUCKER_PUNCH'),(20,'SWAGGER'),
    (20,'LOW_SWEEP'),(24,'DRAINING_KISS'),(32,'SNARL'),(38,'FOUL_PLAY'),(41,'DARK_PULSE'),(43,'NASTY_PLOT'),(47,'PLAY_ROUGH')])
for l, m in [(6,'BUBBLE'),(12,'FURY_CUTTER'),(18,'BUG_BITE'),(24,'AQUA_JET')]: add('WIMPOD', l, m)
for l, m in [(4,'ABSORB'),(8,'DEFENSE_CURL'),(12,'TWISTER'),(16,'MEGA_DRAIN'),(20,'ROLLOUT')]: add('APPLIN', l, m)
add('BOUNSWEET', 14, 'MAGICAL_LEAF')
add('STEENEE', 20, 'MAGICAL_LEAF'); add('STEENEE', 24, 'DOUBLESLAP')
add('TSAREENA', 40, 'LEAF_BLADE')

# ---- 4. strong moves too early ----
for c in ['LARVITAR', 'PUPITAR', 'TYRANITAR']:
    setlv(c, 'THRASH', 28); setlv(c, 'DARK_PULSE', 34)
setlv('MARILL', 'AQUA_TAIL', 24); setlv('MARILL', 'PLAY_ROUGH', 29)
setlv('AZUMARILL', 'AQUA_TAIL', 25); setlv('AZUMARILL', 'PLAY_ROUGH', 31)
for c in ['CRANIDOS', 'RAMPARDOS']: setlv(c, 'TAKE_DOWN', 21)
setlv('MANKEY', 'CROSS_CHOP', 30); setlv('PRIMEAPE', 'CROSS_CHOP', 32); setlv('ANNIHILAPE', 'CROSS_CHOP', 32)
for c in ['KRABBY', 'KINGLER']: setlv(c, 'CRABHAMMER', 28)
for c in ['SENTRET', 'FURRET']: setlv(c, 'SLAM', 15)

# ---- 5. TM moves given away too often by level-up ----
EGG_EXTRA = collections.defaultdict(list)   # base -> moves moved out of level-up into egg list
def keep_or_drop(mv, keep):
    for c in REAL:
        if mv in moves_of(c) and not keep(c):
            rm(c, mv)
            if mv == 'NASTY_PLOT' and sat(c) > atk(c) and 'CALM_MIND' not in moves_of(c):
                lv = [l for l, m in ORIG_LS[c] if m == 'NASTY_PLOT'] or [30]
                add(c, lv[0], 'CALM_MIND')
keep_or_drop('NIGHT_SLASH', lambda c: 'DARK' in types(c) or base(c) in {'SNEASEL','PAWNIARD','KABUTO','SCYTHER','FARFETCH_D','MURKROW','SEVIPER','SNEASEL_HISUIAN'} or c in {'GALLADE','CERULEDGE'})
keep_or_drop('POWER_GEM', lambda c: 'ROCK' in types(c) or base(c) in {'STARYU','CORSOLA','CORSOLA_GALARIAN','MAREEP','MISDREAVUS','SLUGMA'} or c in {'PERSIAN','PERSIAN_ALOLAN'})
keep_or_drop('ICICLE_CRASH', lambda c: base(c) in {'SWINUB','FRIGIBAX','SNOVER','SANDSHREW_ALOLAN','SNEASEL','CETODDLE'})
keep_or_drop('NASTY_PLOT', lambda c: base(c) in {'PICHU','VULPIX','VULPIX_ALOLAN','MEOWTH','MEOWTH_ALOLAN','HOUNDOUR','CROAGUNK','PORYGON','MEW','DEINO','SALANDIT','IMPIDIMP','CELEBI','AIPOM'})
keep_or_drop('PSYCHIC_M', lambda c: 'PSYCHIC' in types(c))
for b in ['TOTODILE', 'LAPRAS', 'LARVITAR']:
    for c in FAM[b]: rm(c, 'DRAGON_DANCE')
# Slowpoke family
for c in ['SLOWPOKE','SLOWBRO','SLOWKING','SLOWPOKE_GALARIAN','SLOWBRO_GALARIAN','SLOWKING_GALARIAN']:
    surf = [l for l, m in LS[c] if m == 'SURF']
    rm(c, 'SURF'); rm(c, 'SWAGGER'); rm(c, 'HIDDEN_POWER')
    if surf and not c.endswith('_GALARIAN'): add(c, surf[0], 'SCALD')
rm('SLOWPOKE_GALARIAN', 'SLUDGE_BOMB')

# ---- 6. modern staples -> egg moves ----
EGG_EXCLUDE = set('ARTICUNO ZAPDOS MOLTRES MEWTWO MEW RAIKOU ENTEI SUICUNE LUGIA HO_OH CELEBI DITTO UNOWN SMEARGLE CATERPIE WEEDLE MAGIKARP'.split())
STAPLE_KEEP = {
 'SUPERPOWER': lambda c: 'FIGHTING' in types(c),
 'BODY_PRESS': lambda c: 'FIGHTING' in types(c) or INFO[c]['stats'][2] >= 110,
 'STEALTH_ROCK': lambda c: types(c) & {'ROCK', 'STEEL', 'GROUND'},
}
for mv, keep in STAPLE_KEEP.items():
    for c in REAL:
        if mv in moves_of(c) and not keep(c) and base(c) not in EGG_EXCLUDE:
            rm(c, mv)
            if mv not in EGG_EXTRA[base(c)]: EGG_EXTRA[base(c)].append(mv)

# ---- 7. de-duplicate ----
for c in REAL:
    if c == 'SMEARGLE': continue
    seen = {}
    for m in {m for l, m in LS[c]}:
        lv = [l for l, mm in LS[c] if mm == m]
        seen[m] = min([l for l in lv if l > 1] or [1])
    new = []; done = set()
    for l, m in sorted(LS[c], key=lambda x: x[0]):
        if m in done: continue
        if l == seen[m]: new.append((l, m)); done.add(m)
    if len(new) != len(LS[c]): log(c, f'dedup {len(LS[c])}->{len(new)}')
    LS[c] = new

# clones mirror originals
for cl in CLONES:
    LS[cl] = list(LS[cl[:-6]])
if not DRY:
    for c in order: E.set(c, LS[c])

# ================= TM / HM =================
TM = {c: set(INFO[c]['tms']) for c in order}
def tadd(c, *mvs):
    if not TM[c]: return
    for m in mvs:
        assert m in TMSET, m
        if m not in TM[c]: TM[c].add(m); log(c, f'TM+{m}')
UNIVERSAL = ['TOXIC','PROTECT','RETURN','HIDDEN_POWER','REST','SWAGGER','FACADE','CURSE']
TYPE_TMS = {
 'NORMAL': ['HEADBUTT','SWIFT'], 'FIRE': ['SUNNY_DAY','FLAMETHROWER','FIRE_BLAST','WILL_O_WISP'],
 'WATER': ['RAIN_DANCE','SURF','WHIRLPOOL','ICE_BEAM'], 'GRASS': ['SUNNY_DAY','SOLARBEAM','ENERGY_BALL'],
 'ELECTRIC': ['RAIN_DANCE','THUNDERBOLT','THUNDER','ZAP_CANNON','FLASH'], 'ICE': ['ICE_BEAM','BLIZZARD'],
 'FIGHTING': ['ROCK_SMASH','DRAIN_PUNCH','BULK_UP','STRENGTH'], 'POISON': ['SLUDGE_BOMB'],
 'GROUND': ['EARTHQUAKE','DIG','MUD_SLAP','SANDSTORM','ROCK_TOMB'], 'FLYING': ['FLY','SWIFT'], 'BUG': ['BUG_BITE'],
 'ROCK': ['ROCK_TOMB','SANDSTORM','ROCK_SMASH','POWER_GEM'], 'GHOST': ['SHADOW_BALL','WILL_O_WISP'],
 'DRAGON': ['DRAGON_PULSE','DRAGON_CLAW'], 'DARK': ['KNOCK_OFF','THIEF'], 'STEEL': ['IRON_HEAD','FLASH_CANNON'],
 'PSYCHIC': ['PSYCHIC_M','ZEN_HEADBUTT','FLASH'], 'FAIRY': [],
}
HAND = {
 'RALTS': ['SHADOW_BALL','THUNDERBOLT','ENERGY_BALL'], 'GALLADE': ['DRAIN_PUNCH','KNOCK_OFF','NIGHT_SLASH'],
 'LARVESTA': ['PSYCHIC_M','ENERGY_BALL','SOLARBEAM'], 'BAGON': ['FLAMETHROWER','FIRE_BLAST','EARTHQUAKE','ROCK_SMASH'],
 'DEINO': ['FLAMETHROWER','FIRE_BLAST','SURF'], 'DREEPY': ['THUNDERBOLT','FLAMETHROWER','FIRE_BLAST'],
 'TINKATINK': ['ROCK_TOMB','STRENGTH'], 'IMPIDIMP': ['DRAIN_PUNCH','THUNDERPUNCH','FIRE_PUNCH','ICE_PUNCH'],
 'TIMBURR': ['ROCK_TOMB','ICE_PUNCH','THUNDERPUNCH','FIRE_PUNCH','KNOCK_OFF'], 'BUNEARY': ['ICE_PUNCH','THUNDERPUNCH','FIRE_PUNCH'],
 'CROAGUNK': ['ICE_PUNCH','THUNDERPUNCH','KNOCK_OFF','DIG'], 'GOLETT': ['ICE_PUNCH','THUNDERPUNCH','FIRE_PUNCH','DRAIN_PUNCH'],
 'DUSKULL': ['PSYCHIC_M','ICE_BEAM'], 'LILEEP': ['SLUDGE_BOMB','EARTHQUAKE'], 'SPOINK': ['SHADOW_BALL'],
 'MIMIKYU': ['THUNDERBOLT'], 'DRIFLOON': ['THUNDERBOLT','PSYCHIC_M'], 'TRAPINCH': ['FLAMETHROWER','FIRE_BLAST'],
 'SWABLU': ['FLAMETHROWER','FIRE_BLAST','EARTHQUAKE'], 'AXEW': ['EARTHQUAKE','ROCK_TOMB','ROCK_SMASH'],
 'SCRAGGY': ['ICE_PUNCH','THUNDERPUNCH','FIRE_PUNCH'], 'CRANIDOS': ['EARTHQUAKE','FIRE_PUNCH','THUNDERPUNCH','ICE_PUNCH'],
 'TYRUNT': ['IRON_HEAD','ROCK_SMASH'], 'AMAURA': ['THUNDERBOLT'], 'CETODDLE': ['EARTHQUAKE'],
 'FRIGIBAX': ['EARTHQUAKE','IRON_HEAD'], 'DURALUDON': ['THUNDERBOLT','THUNDER'], 'NOIBAT': ['FLAMETHROWER'],
 'LITWICK': ['ENERGY_BALL','PSYCHIC_M'], 'ARCHEN': ['EARTHQUAKE'], 'TIRTOUGA': ['EARTHQUAKE'],
 'SHUPPET': ['THUNDERBOLT','THUNDER'], 'SEVIPER': ['FLAMETHROWER','EARTHQUAKE','DIG'],
 'ARON': ['EARTHQUAKE','THUNDERBOLT','ICE_BEAM','FIRE_BLAST','ICE_PUNCH','THUNDERPUNCH','FIRE_PUNCH'],
 'GOLURK': ['FLY'], 'TOTODILE': ['DRAGON_DANCE'], 'LAPRAS': ['DRAGON_DANCE'], 'LARVITAR': ['DRAGON_DANCE'],
}
# egg moves that were TMs the family couldn't use -> make them usable
EGGTM = {'PSYDUCK': ['PSYCHIC_M'], 'KRABBY': ['DIG'], 'KABUTO': ['DIG', 'SURF'], 'NATU': ['STEEL_WING'], 'PINECO': ['SWIFT'], 'SHUCKLE': ['SWEET_SCENT']}

for c in REAL:
    if not TM[c]: continue
    tadd(c, *UNIVERSAL)
    if INFO[c]['gender'] != 'GENDER_UNKNOWN': tadd(c, 'ATTRACT')
    if 'ICE' in types(c) and atk(c) >= sat(c): tadd(c, 'ICICLE_CRASH')
    if c in ADDED:
        for t in types(c): tadd(c, *TYPE_TMS[t])
        if 'WATER' in types(c) and atk(c) >= sat(c): tadd(c, 'WATERFALL')
        if 'FLYING' in types(c) and atk(c) >= sat(c): tadd(c, 'STEEL_WING')
        if 'DARK' in types(c) and atk(c) >= sat(c): tadd(c, 'NIGHT_SLASH')
        if not has_evo(c):
            tadd(c, 'HYPER_BEAM')
            if atk(c) >= 80: tadd(c, 'STRENGTH')
for b, mvs in list(HAND.items()) + list(EGGTM.items()):
    for c in (FAM[b] if b in FAM else [b]):
        tadd(c, *mvs)
for c in ['SALAMENCE', 'GLISCOR', 'TOGEKISS']: tadd(c, 'FLY')
# moves learned by level must be usable from the TM too
for c in REAL:
    for l, m in LS[c]:
        if m in TMSET: tadd(c, m)
# evolutions keep every TM of their pre-evolution
changed = True
while changed:
    changed = False
    for c in REAL:
        if c in PAR and TM[c]:
            miss = TM[PAR[c]] - TM[c]
            if miss:
                TM[c] |= miss; changed = True; log(c, 'TM+(from pre-evo) ' + ','.join(sorted(miss)))
for c in REAL:
    if INFO[c]['gender'] == 'GENDER_UNKNOWN' and 'ATTRACT' in TM[c]:
        TM[c].discard('ATTRACT'); log(c, 'TM-ATTRACT (genderless)')
if not DRY:
    for c in REAL:
        if set(ORIG_TM[c]) != TM[c]: write_tms(c, TM[c])

# ================= EGG MOVES =================
def parse_egg(path):
    s = rd(path); tbl = []; blocks = collections.OrderedDict(); cur = None; in_tbl = False
    for l in s.splitlines():
        if re.match(r'^EggMovePointers\d::?', l): in_tbl = True; continue
        m = re.match(r'^(\w+):', l)
        if m: in_tbl = False; cur = m.group(1); blocks[cur] = []; continue
        m = re.match(r'\s*dw\s+(-?\w+)', l)
        if not m: continue
        if in_tbl: tbl.append(m.group(1))
        elif cur:
            if m.group(1) == '-1': cur = None
            else: blocks[cur].append(m.group(1))
    return tbl, blocks
KT, KB = parse_egg('data/pokemon/egg_moves_kanto.asm')
JT, JB = parse_egg('data/pokemon/egg_moves_johto.asm')
assert len(KT) == 151 and len(JT) == 344, (len(KT), len(JT))
PTR = dict(zip(order, KT + JT)); BLK = {**KB, **JB}
EGG_OLD = {c: list(BLK.get(PTR[c], [])) for c in order}
EGG = {c: [] for c in REAL}
for c in REAL:
    if EGG_OLD[c]:
        b = base(c)
        for m in EGG_OLD[c]:
            if m not in EGG[b]: EGG[b].append(m)
        if b != c: log(b, f'egg: merged dead list from {c}')

OBSOLETE = {'BIDE','RAGE','PSYWAVE','SONICBOOM','DRAGON_RAGE','MIMIC','SPLASH','PRESENT'}
NEW_EGG = {
 'MUNCHLAX': ['COUNTER','PURSUIT','FISSURE','CHARM','WHIRLWIND'],
 'BAGON': ['TWISTER','THRASH','FIRE_FANG','THUNDER_FANG','DEFENSE_CURL'],
 'RALTS': ['DESTINY_BOND','DISABLE','ENCORE','MEAN_LOOK','SHADOW_SNEAK','CONFUSE_RAY'],
 'VENIPEDE': ['TWINEEDLE','SPIKES','TOXIC_SPIKES','PIN_MISSILE','PURSUIT'],
 'LILEEP': ['BARRIER','ENDURE','STUN_SPORE','LEECH_SEED','SEED_BOMB'],
 'ANORITH': ['CROSS_POISON','RAPID_SPIN','SAND_ATTACK','SCREECH','IRON_DEFENSE'],
 'GOLETT': ['MEGA_KICK','IRON_DEFENSE','ROLLOUT','STEALTH_ROCK'],
 'DUSKULL': ['PAIN_SPLIT','SKILL_SWAP','DARK_PULSE','HAZE','NIGHTMARE'],
 'TIMBURR': ['MACH_PUNCH','COUNTER','DETECT','ENDURE','CROSS_CHOP'],
 'LARVESTA': ['ENDURE','FORESIGHT','HARDEN','MORNING_SUN','U_TURN'],
 'DEINO': ['DARK_PULSE','EARTH_POWER','FIRE_FANG','ICE_FANG','THUNDER_FANG','SCREECH'],
 'DREEPY': ['CONFUSE_RAY','DISABLE','TAUNT','DOUBLE_TEAM','SUCKER_PUNCH'],
 'IMPIDIMP': ['TORMENT','CHARM','ENCORE','MEAN_LOOK','SPITE'],
 'TINKATINK': ['ENCORE','FAKE_OUT','STEALTH_ROCK','CHARM','BULLET_PUNCH'],
 'FRIGIBAX': ['ICICLE_SPEAR','ICE_SHARD','OUTRAGE','DOUBLE_EDGE','MIST'],
 'CHARCADET': ['CONFUSE_RAY','DESTINY_BOND','SPITE','MEAN_LOOK','CALM_MIND','SWORDS_DANCE'],
 'SNOVER': ['DOUBLE_EDGE','GROWTH','LEAF_STORM','MAGICAL_LEAF','SKULL_BASH','STOMP'],
 'SWABLU': ['AGILITY','HAZE','PURSUIT','ROOST','HYPER_VOICE'],
 'APPLIN': ['GIGA_DRAIN','SUCKER_PUNCH','LEECH_SEED','DRAGON_TAIL'],
 'DURALUDON': ['STEALTH_ROCK','OUTRAGE','ROCK_SLIDE','SCREECH'],
 'SHROOMISH': ['FALSE_SWIPE','COUNTER','SWORDS_DANCE','MAGICAL_LEAF','SYNTHESIS'],
 'BUNEARY': ['FAKE_OUT','ENCORE','SWEET_KISS','LOW_KICK','CIRCLE_THROW'],
 'NUMEL': ['BODY_SLAM','HEAT_WAVE','YAWN','STOMP','ROLLOUT','SCARY_FACE'],
 'SIZZLIPEDE': ['FLAME_CHARGE','X_SCISSOR','SCARY_FACE','AGILITY'],
 'GRUBBIN': ['HARDEN','MUD_SHOT','SCREECH','THUNDER_WAVE','AGILITY'],
 'CROAGUNK': ['BULLET_PUNCH','COUNTER','DYNAMICPUNCH','MEDITATE','ACID_ARMOR'],
 'DRIFLOON': ['BODY_SLAM','DISABLE','HAZE','SPITE','PAIN_SPLIT'],
 'DRILBUR': ['CRUSH_CLAW','SKULL_BASH','SUBMISSION','THRASH'],
 'KOTORA': ['FIRE_FANG','ICE_FANG','THRASH','CRUNCH','VOLT_TACKLE'],
 'FLETCHLING': ['U_TURN','SKY_ATTACK','PURSUIT','BRAVE_BIRD','WHIRLWIND'],
 'TRAPINCH': ['FLAIL','FOCUS_ENERGY','FURY_CUTTER','GUST','QUICK_ATTACK','SIGNAL_BEAM'],
 'SNORUNT': ['SPIKES','ROLLOUT','DESTINY_BOND','CONFUSE_RAY'],
 'WIMPOD': ['HARDEN','ENDURE','COUNTER','AQUA_TAIL'],
 'SPOINK': ['AMNESIA','SKILL_SWAP','WHIRLWIND','CALM_MIND'],
 'PAWNIARD': ['MEAN_LOOK','PSYCHO_CUT','PURSUIT','SUCKER_PUNCH','FOCUS_ENERGY'],
 'LOTAD': ['COUNTER','SYNTHESIS','RAZOR_LEAF','FAKE_OUT','LEECH_SEED'],
 'SCRAGGY': ['DETECT','FAKE_OUT','FAINT_ATTACK','COUNTER','DRAGON_TAIL'],
 'SPHEAL': ['FISSURE','ROCK_SLIDE','SIGNAL_BEAM','SLEEP_TALK','YAWN'],
 'TEDDIURSABM': ['CRUNCH','TAKE_DOWN','SEISMIC_TOSS','FOCUS_ENERGY','COUNTER','METAL_CLAW'],
 'AXEW': ['COUNTER','RAZOR_WIND','REVERSAL','ENDURE','HARDEN','IRON_TAIL'],
 'CRANIDOS': ['DOUBLE_EDGE','HAMMER_ARM','IRON_TAIL','STOMP','THRASH','WHIRLWIND'],
 'SHIELDON': ['BODY_SLAM','COUNTER','FISSURE','FOCUS_ENERGY','ROCK_BLAST','SCREECH'],
 'CETODDLE': ['YAWN','ICICLE_SPEAR','BELLY_DRUM','SLACK_OFF'],
 'FEEBAS': ['CONFUSE_RAY','DRAGONBREATH','HAZE','HYPNOSIS','MIRROR_COAT','MIST'],
 'MIMIKYU': ['DESTINY_BOND','SPITE','CONFUSE_RAY','SUCKER_PUNCH'],
 'CORSOLA_GALARIAN': ['HAZE','MIST','CONFUSE_RAY','HEAD_SMASH','BARRIER'],
 'RIOLU': ['AGILITY','BULLET_PUNCH','DETECT','HI_JUMP_KICK','IRON_DEFENSE'],
 'TYRUNT': ['FIRE_FANG','ICE_FANG','POISON_FANG','THUNDER_FANG','ROCK_POLISH','OUTRAGE'],
 'AMAURA': ['BARRIER','HAZE','MIRROR_COAT','MOONBLAST','EARTH_POWER'],
 'TORKOAL': ['ENDURE','FISSURE','FLAIL','SLEEP_TALK','YAWN','SKULL_BASH'],
 'RATTATA_ALOLAN': ['COUNTER','FURY_SWIPES','SCREECH','TAUNT','BEAT_UP'],
 'SANDSHREW_ALOLAN': ['AMNESIA','COUNTER','CRUSH_CLAW','ENDURE','FLAIL'],
 'VULPIX_ALOLAN': ['AGILITY','CHARM','ENCORE','FLAIL','BATON_PASS'],
 'DIGLETT_ALOLAN': ['ANCIENTPOWER','BEAT_UP','ENDURE','PURSUIT','REVERSAL','THRASH'],
 'MEOWTH_ALOLAN': ['AMNESIA','CHARM','FLAIL','SPITE','FAKE_OUT'],
 'GEODUDE_ALOLAN': ['COUNTER','ENDURE','FLAIL','MAGNITUDE','MEGA_PUNCH'],
 'GRIMER_ALOLAN': ['MEAN_LOOK','PURSUIT','SCARY_FACE','SPITE','HAZE'],
 'MEOWTH_GALARIAN': ['DOUBLE_EDGE','FLAIL','SPITE','FAKE_OUT','IRON_DEFENSE'],
 'PONYTA_GALARIAN': ['DOUBLE_EDGE','DOUBLE_KICK','HYPNOSIS','MORNING_SUN','THRASH','LOW_KICK'],
 'SLOWPOKE_GALARIAN': ['BELLY_DRUM','SAFEGUARD','STOMP','SLEEP_TALK','YAWN'],
 'GROWLITHE_HISUIAN': ['BODY_SLAM','SAFEGUARD','THRASH','FIRE_SPIN','MORNING_SUN','HEAD_SMASH'],
 'VOLTORB_HISUIAN': ['LEECH_SEED','STUN_SPORE','MAGICAL_LEAF','GIGA_DRAIN'],
 'SNEASEL_HISUIAN': ['COUNTER','FAKE_OUT','PURSUIT','TAUNT'],
 'WOOPER_PALDEAN': ['ANCIENTPOWER','SAFEGUARD','COUNTER','SPIKES','ACID_ARMOR'],
 'TAUROS_PALDEAN_FIRE': ['REVERSAL','ENDURE','ROCK_SLIDE','BODY_SLAM','HORN_ATTACK'],
 'TAUROS_PALDEAN_WATER': ['REVERSAL','ENDURE','ROCK_SLIDE','BODY_SLAM','HORN_ATTACK'],
 'BOUNSWEET': ['CHARM','ENDURE','SYNTHESIS','LEECH_SEED','DRAINING_KISS'],
 'ARON': ['BODY_SLAM','HEAD_SMASH','REVERSAL','SCREECH'],
 'GLIMMET': ['TOXIC_SPIKES','SPIKES','MORTAL_SPIN','EARTH_POWER','ROCK_BLAST'],
 'MAREANIE': ['HAZE','INFESTATION','SPIKES','SLUDGE'],
 'ZANGOOSE': ['COUNTER','DISABLE','DOUBLE_KICK','FLAIL','FURY_SWIPES','RAZOR_WIND'],
 'SEVIPER': ['BODY_SLAM','IRON_TAIL','SCARY_FACE','SPITE','PURSUIT'],
 'SHUPPET': ['ASTONISH','DISABLE','FORESIGHT','GUNK_SHOT','PURSUIT'],
 'ARCHEN': ['BITE','EARTH_POWER','HEAD_SMASH','FOCUS_ENERGY','DEFOG'],
 'TIRTOUGA': ['BODY_SLAM','FLAIL','SLAM','HEAD_SMASH'],
 'LITWICK': ['ACID_ARMOR','ENDURE','HAZE','HEAT_WAVE'],
 'JOLTIK': ['CROSS_POISON','DISABLE','FAINT_ATTACK','PIN_MISSILE','POISON_JAB'],
 'MAWILE': ['ANCIENTPOWER','DISABLE','FIRE_FANG','ICE_FANG','POISON_FANG','THUNDER_FANG','SUCKER_PUNCH'],
 'NOIBAT': ['OUTRAGE','DOUBLE_TEAM','HYPER_VOICE','U_TURN'],
 'SALANDIT': ['FAKE_OUT','SAND_ATTACK','FLAME_CHARGE','BEAT_UP'],
 # originals that had none
 'TAUROS': ['REVERSAL','ENDURE','ROCK_SLIDE','BODY_SLAM'],
 'SUNKERN': ['ENCORE','ENDURE','SAFEGUARD','LEAF_STORM'],
 'MAGNEMITE': ['EXPLOSION','SCREECH','IRON_DEFENSE','RAIN_DANCE'],
 'VOLTORB': ['AGILITY','RECOVER','REFLECT','NUZZLE'],
 'STARYU': ['AURORA_BEAM','BARRIER','SUPERSONIC','CONFUSE_RAY'],
 'PORYGON': ['DISABLE','FORESIGHT','MIND_READER','THUNDER_WAVE'],
}
TOPUP = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'topup.json'))) if os.path.exists(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'topup.json')) else {}
famlvl_base = {b: moves_of(b) for b in FAM}
def final_stat(b, i): return max(INFO[c]['stats'][i] for c in FAM[b] if not has_evo(c)) if any(not has_evo(c) for c in FAM[b]) else INFO[b]['stats'][i]
for b in list(EGG_EXTRA):
    if 'SUPERPOWER' in EGG_EXTRA[b] and final_stat(b, 1) < 125: EGG_EXTRA[b].remove('SUPERPOWER')
    if 'BODY_PRESS' in EGG_EXTRA[b] and final_stat(b, 2) < 130: EGG_EXTRA[b].remove('BODY_PRESS')
# keep the most common breeding moves from piling up
REMOVE_EGG = {
 'MUNCHLAX': ['COUNTER','PURSUIT'], 'SHROOMISH': ['COUNTER'], 'WIMPOD': ['COUNTER'], 'LOTAD': ['COUNTER'], 'TEDDIURSABM': ['COUNTER'],
 'AXEW': ['COUNTER'], 'SHIELDON': ['COUNTER'], 'RATTATA_ALOLAN': ['COUNTER'], 'SANDSHREW_ALOLAN': ['COUNTER','FLAIL'],
 'GEODUDE_ALOLAN': ['COUNTER','FLAIL'], 'WOOPER_PALDEAN': ['COUNTER'], 'GEODUDE': ['COUNTER','FLAIL','ENDURE'], 'HAPPINY': ['COUNTER','ENDURE'],
 'WOOPER': ['COUNTER'], 'PINECO': ['COUNTER'], 'MEOWTH': ['FLAIL'], 'PICHU': ['FLAIL'], 'MEOWTH_ALOLAN': ['FLAIL'], 'MEOWTH_GALARIAN': ['FLAIL'],
 'VULPIX_ALOLAN': ['FLAIL'], 'VENIPEDE': ['PURSUIT'], 'SWABLU': ['PURSUIT'], 'SHUPPET': ['PURSUIT'], 'DIGLETT_ALOLAN': ['PURSUIT'],
 'GRIMER_ALOLAN': ['PURSUIT'], 'KRABBY': ['ENDURE'],
}
ADD_EGG2 = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'topup2.json'))) if os.path.exists(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'topup2.json')) else {}
for b in FAM:
    if b in EGG_EXCLUDE: EGG[b] = []; continue
    lst = EGG[b] + NEW_EGG.get(b, []) + TOPUP.get(b, []) + ADD_EGG2.get(b, []) + EGG_EXTRA.get(b, [])
    out = []
    for m in lst:
        if m in REMOVE_EGG.get(b, []): continue
        if m not in MOVES: log(b, f'egg: unknown {m}'); continue
        if m in OBSOLETE or m in famlvl_base[b] or m in TMSET or m in out: continue
        out.append(m)
    EGG[b] = out[:8]
for c in REAL:
    if c not in FAM: EGG[c] = []

def label(c):
    old = PTR[c]
    if old and not old.startswith('NoEggMoves') and not old.endswith('CloneEggMoves') and EGG_OLD.get(c): return old
    return ''.join(w.capitalize() for w in c.replace('__', '_').split('_') if w) + 'EggMoves'
def emit(species, sec, ptrname, noname, ptrcolon):
    lines = [f'SECTION "{sec}", ROMX', '', f'{ptrname}{ptrcolon}']
    blocks = []
    for c in species:
        src = c[:-6] if c.endswith('_CLONE') else c
        lst = EGG.get(src, [])
        if lst and src in FAM:
            lab = (label(src)[:-8] + 'CloneEggMoves') if c.endswith('_CLONE') else label(src)
            lines.append(f'\tdw {lab} ; {c}')
            blocks.append((lab, lst))
        else:
            lines.append(f'\tdw {noname} ; {c}')
    lines.append('')
    for lab, lst in blocks:
        lines.append(f'{lab}:'); lines += [f'\tdw {m}' for m in lst]; lines += ['\tdw -1 ; end', '']
    lines += [f'{noname}:', '\tdw -1 ; end', '']
    return '\n'.join(lines)
if not DRY:
    wr('data/pokemon/egg_moves_kanto.asm', emit(order[:151], 'Egg Moves 1', 'EggMovePointers1', 'NoEggMoves1', ':'))
    wr('data/pokemon/egg_moves_johto.asm', emit(order[151:], 'Egg Moves 2', 'EggMovePointers2', 'NoEggMoves2', '::'))

if not DRY: E.save()
json.dump({'log': LOG, 'egg': {b: EGG[b] for b in FAM}, 'egg_old': {b: EGG_OLD[b] for b in FAM},
           'ls': {c: LS[c] for c in REAL}, 'tm': {c: sorted(TM[c]) for c in REAL}}, open('/tmp/fix_result.json', 'w'))
print('species changed:', len(LOG))
small = {b: EGG[b] for b in FAM if b not in EGG_EXCLUDE and len(EGG[b]) < 4}
print('families with <4 egg moves:', json.dumps(small))
