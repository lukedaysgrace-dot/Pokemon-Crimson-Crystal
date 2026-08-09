#!/usr/bin/env python3
"""Rebalance trainer parties: species by class + progression, items, movesets.

Leaves gym leaders, rivals (Silver + Crystal) and the Elite Four / champion /
Red / Blue / Green untouched. No fossils, no legendaries.
Deterministic (seeded). Usage: rebalance_trainers.py <repo root>
"""
import io, os, re, sys, random, statistics, collections

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mondata import load

ROOT = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else '.')
os.chdir(ROOT)
D = load(ROOT)
META, LEARN, MOVES, MINLV, EVOAT = D['meta'], D['learn'], D['moves'], D['minlv'], D['evolves_at']
SPECIES = D['species']
IDX = D['IDX']
RNG = random.Random(20260809)

KANTO = set(SPECIES[:151])
JOHTO = set(SPECIES[151:251])
NEW   = set(SPECIES[251:])

# ---------------------------------------------------------------- exclusions
UNTOUCHED = {
    'FALKNER','BUGSY','WHITNEY','MORTY','CHUCK','JASMINE','PRYCE','CLAIR',
    'BROCK','MISTY','LT_SURGE','ERIKA','JANINE','SABRINA','BLAINE','BLUE',
    'WILL','KOGA','BRUNO','KAREN','CHAMPION','LORELEI','AGATHA',
    'RIVAL1','RIVAL2','CRYSTAL','RED','RED2','GREEN','BLUE_CLOAK',
}
LEGENDARY = {'ARTICUNO','ZAPDOS','MOLTRES','MEWTWO','MEW','RAIKOU','ENTEI','SUICUNE',
             'LUGIA','HO_OH','CELEBI'}
FOSSIL = {'OMANYTE','OMASTAR','KABUTO','KABUTOPS','AERODACTYL','LILEEP','CRADILY',
          'ANORITH','ARMALDO','CRANIDOS','RAMPARDOS','SHIELDON','BASTIODON',
          'TIRTOUGA','CARRACOSTA','ARCHEN','ARCHEOPS','TYRUNT','TYRANTRUM',
          'AMAURA','AURORUS'}
SPECIAL = ({s for s in SPECIES if s.endswith('_CLONE')} |
           {'UNOWN','DITTO','SMEARGLE','TEDDIURSABM','URSARINGBM','URSALUNABM','MESMERIA'})
STARTER_FINAL = {'VENUSAUR','CHARIZARD','BLASTOISE','MEGANIUM','TYPHLOSION','FERALIGATR'}
PSEUDO = {'DRAGONITE','TYRANITAR','SALAMENCE','HYDREIGON','HAXORUS','BAXCALIBUR',
          'DRAGAPULT','ARCHALUDON','GOLISOPOD','KINGAMBIT','ANNIHILAPE','URSALUNA',
          'PALAFIN','VOLCARONA','SNEASLER','GRIMMSNARL','CORVIKNIGHT','TINKATON'}
# whole pseudo-legendary / rare lines: elite classes only
RARE_LINE = {'LARVITAR','PUPITAR','TYRANITAR','DRATINI','DRAGONAIR','DRAGONITE',
 'BAGON','SHELGON','SALAMENCE','DEINO','ZWEILOUS','HYDREIGON','AXEW','FRAXURE',
 'HAXORUS','FRIGIBAX','ARCTIBAX','BAXCALIBUR','DREEPY','DRAKLOAK','DRAGAPULT',
 'DURALUDON','ARCHALUDON','LARVESTA','VOLCARONA','WIMPOD','GOLISOPOD',
 'SNEASLER','KLEAVOR','URSALUNA','ANNIHILAPE','KINGAMBIT','PALAFIN'}
# starter families: only the ace classes get to field these
STARTER_LINE = {'BULBASAUR','IVYSAUR','VENUSAUR','CHARMANDER','CHARMELEON','CHARIZARD',
 'SQUIRTLE','WARTORTLE','BLASTOISE','CHIKORITA','BAYLEEF','MEGANIUM','CYNDAQUIL',
 'QUILAVA','TYPHLOSION','TOTODILE','CROCONAW','FERALIGATR'}
STARTER_OK = {'COOLTRAINERM','COOLTRAINERF','CAL'}
FORM_SUFFIX = ('_ALOLAN','_GALARIAN','_HISUIAN','_PALDEAN_FIRE','_PALDEAN_WATER','_PALDEAN')
GLOBAL_BAN = LEGENDARY | FOSSIL | SPECIAL

ELITE = {'COOLTRAINERM','COOLTRAINERF','BLACKBELT_T','PSYCHIC_T','EXECUTIVEM',
         'EXECUTIVEF','PROTON','PETREL','PETREL_DIRECTOR','ARIANA','ARCHER',
         'NINJA','TAMER','BATTLE_GIRL','GUITARIST','CAL'}

# ---------------------------------------------------------------- class themes
T = lambda *a: set(a)
CLASS = {
 'BUG_CATCHER':   dict(types=T('BUG'),                                    flavor='bug'),
 'BIRD_KEEPER':   dict(types=T('FLYING'),                                 flavor='bird'),
 'FISHER':        dict(types=T('WATER'),                                  flavor='fish'),
 'SWIMMERM':      dict(types=T('WATER'),                                  flavor='swim'),
 'SWIMMERF':      dict(types=T('WATER'),                                  flavor='swim'),
 'SAILOR':        dict(types=T('WATER','FIGHTING'),                       flavor='sea'),
 'HIKER':         dict(types=T('ROCK','GROUND','STEEL','FIGHTING'),       flavor='rock'),
 'CAMPER':        dict(types=T('GRASS','GROUND','NORMAL','BUG','FIRE'),   flavor='out'),
 'PICNICKER':     dict(types=T('GRASS','NORMAL','FAIRY','BUG','WATER'),   flavor='out'),
 'LASS':          dict(types=T('NORMAL','FAIRY','GRASS','POISON','WATER'),flavor='cute'),
 'YOUNGSTER':     dict(types=T('NORMAL','GROUND','POISON','BUG'),         flavor='young'),
 'SCHOOLBOY':     dict(types=T('NORMAL','ELECTRIC','PSYCHIC','ROCK','STEEL'), flavor='school'),
 'BEAUTY':        dict(types=T('NORMAL','FAIRY','GRASS','WATER','PSYCHIC'),flavor='cute'),
 'TWINS':         dict(types=T('NORMAL','FAIRY','PSYCHIC','BUG','ELECTRIC'),flavor='cute'),
 'POKEFANM':      dict(types=T('NORMAL','FAIRY','ELECTRIC','GROUND'),     flavor='fan'),
 'POKEFANF':      dict(types=T('NORMAL','FAIRY','ELECTRIC','PSYCHIC'),    flavor='fan'),
 'POKEMANIAC':    dict(types=T('ROCK','GROUND','DRAGON','NORMAL','PSYCHIC'), flavor='maniac'),
 'SUPER_NERD':    dict(types=T('POISON','ELECTRIC','FIRE','PSYCHIC','STEEL'), flavor='nerd'),
 'SCIENTIST':     dict(types=T('ELECTRIC','STEEL','POISON','PSYCHIC'),    flavor='nerd'),
 'FIREBREATHER':  dict(types=T('FIRE'),                                   flavor='fire'),
 'BURGLAR':       dict(types=T('FIRE','DARK','POISON'),                   flavor='crook'),
 'BIKER':         dict(types=T('POISON','DARK','FIRE','ROCK'),            flavor='crook'),
 'GUITARIST':     dict(types=T('ELECTRIC','DARK','NORMAL','POISON'),      flavor='rock'),
 'JUGGLER':       dict(types=T('PSYCHIC','ELECTRIC','GHOST','FAIRY'),     flavor='psy'),
 'PSYCHIC_T':     dict(types=T('PSYCHIC','GHOST','FAIRY'),                flavor='psy'),
 'MEDIUM':        dict(types=T('GHOST','PSYCHIC','DARK'),                 flavor='ghost'),
 'HEX_MANIAC':    dict(types=T('GHOST','PSYCHIC','DARK','POISON'),        flavor='ghost'),
 'SAGE':          dict(types=T('PSYCHIC','GHOST','FIRE','FLYING','GRASS'),flavor='sage'),
 'KIMONO_GIRL':   dict(types=T('PSYCHIC','GHOST','FAIRY','FIRE','WATER','ELECTRIC'), flavor='kimono'),
 'BLACKBELT_T':   dict(types=T('FIGHTING'),                               flavor='fight'),
 'BATTLE_GIRL':   dict(types=T('FIGHTING'),                               flavor='fight'),
 'BOARDER':       dict(types=T('ICE','WATER','ROCK'),                     flavor='ice'),
 'SKIER':         dict(types=T('ICE','WATER'),                            flavor='ice'),
 'OFFICER':       dict(types=T('NORMAL','FIGHTING','DARK','FIRE'),        flavor='cop'),
 'GENTLEMAN':     dict(types=T('NORMAL','FIRE','ELECTRIC','FAIRY'),       flavor='posh'),
 'TEACHER':       dict(types=T('NORMAL','PSYCHIC','FAIRY','GRASS'),       flavor='school'),
 'COSPLAYER':     dict(types=T('FAIRY','PSYCHIC','NORMAL','GHOST','ICE'), flavor='cute'),
 'NINJA':         dict(types=T('POISON','DARK','BUG','GHOST','FLYING'),   flavor='ninja'),
 'TAMER':         dict(types=T('NORMAL','DRAGON','GROUND','FIGHTING','ROCK'), flavor='tamer'),
 'MYSTICALMAN':   dict(types=T('GHOST','PSYCHIC','ELECTRIC','WATER'),     flavor='psy'),
 'COOLTRAINERM':  dict(types=None,                                        flavor='ace'),
 'COOLTRAINERF':  dict(types=None,                                        flavor='ace'),
 'CAL':           dict(types=None,                                        flavor='ace'),
 'GRUNTM':        dict(types=T('POISON','DARK','NORMAL','GROUND','GHOST'),flavor='rocket'),
 'GRUNTF':        dict(types=T('POISON','DARK','NORMAL','PSYCHIC','GHOST'), flavor='rocket'),
 'EXECUTIVEM':    dict(types=T('POISON','DARK','GHOST','STEEL','FIGHTING'), flavor='rocket'),
 'EXECUTIVEF':    dict(types=T('POISON','DARK','GHOST','PSYCHIC','FAIRY'),flavor='rocket'),
 'PROTON':        dict(types=T('POISON','DARK','GHOST'),                  flavor='rocket'),
 'PETREL':        dict(types=T('POISON','DARK','NORMAL'),                 flavor='rocket'),
 'PETREL_DIRECTOR':dict(types=T('POISON','DARK','NORMAL','GHOST'),        flavor='rocket'),
 'ARIANA':        dict(types=T('POISON','DARK','FIGHTING','FAIRY'),       flavor='rocket'),
 'ARCHER':        dict(types=T('POISON','DARK','STEEL','GHOST','FIRE'),   flavor='rocket'),
}
DEFAULT = dict(types=None, flavor='ace')


# ---------------------------------------------------------------- location themes
# Gyms are strict: everyone inside fights with the gym's type.
GYM = {
 'Violet Gym': T('FLYING'), 'Azalea Gym': T('BUG'),
 'Goldenrod Gym': T('NORMAL','FAIRY'), 'Ecruteak Gym': T('GHOST'),
 'Cianwood Gym': T('FIGHTING'), 'Olivine Gym': T('STEEL'),
 'Olivine Gym (after Jasmine returns)': T('STEEL'), 'Mahogany Gym': T('ICE'),
 'Blackthorn Gym 1F': T('DRAGON'), 'Blackthorn Gym 2F': T('DRAGON'),
 'Dragons Den B1F': T('DRAGON'), 'Dragons Den B1F (rematch)': T('DRAGON'),
 'Wise Trios Room': T('DRAGON'),
 'Pewter Gym': T('ROCK'), 'Cerulean Gym': T('WATER'),
 'Vermilion Gym': T('ELECTRIC'), 'Celadon Gym': T('GRASS'),
 'Fuchsia Gym': T('POISON'), 'Saffron Gym': T('PSYCHIC'),
 'Seafoam Gym': T('FIRE'), 'Viridian Gym': T('GROUND'),
 'Sprout Tower 1F': T('GRASS','PSYCHIC','FLYING'),
 'Sprout Tower 2F': T('GRASS','PSYCHIC','FLYING'),
 'Sprout Tower 3F': T('GRASS','PSYCHIC','FLYING'),
}
# Dungeons and habitats are soft: they narrow the class theme where they overlap.
HABITAT = {
 'Union Cave': T('ROCK','GROUND','WATER','POISON'),
 'Slowpoke Well': T('WATER','PSYCHIC','POISON'),
 'Ilex Forest': T('BUG','GRASS','GHOST'),
 'Burned Tower': T('FIRE','GHOST','DARK'),
 'Silent Crypt': T('GHOST','DARK','PSYCHIC'),
 'GraveKeepers': T('GHOST','DARK'),
 'Mount Moon': T('ROCK','GROUND','FAIRY'),
 'Mount Mortar': T('FIGHTING','ROCK','GROUND','WATER'),
 'Ice Path': T('ICE','GROUND'),
 'Ice Island': T('ICE','WATER'),
 'Olivine Lighthouse': T('WATER','FLYING','ELECTRIC'),
 'Lake Of Rage': T('WATER','DRAGON'),
 'National Park': T('BUG','GRASS','NORMAL','FAIRY'),
 'Goldenrod Underground': T('POISON','DARK','NORMAL','GROUND'),
 'Radio Tower': T('POISON','DARK','NORMAL','ELECTRIC'),
 'Team Rocket Base': T('POISON','DARK','GHOST','STEEL'),
 'Fast Ship': T('WATER','NORMAL','FIGHTING','FLYING'),
 'Victory Road': T('ROCK','GROUND','DRAGON','FIGHTING'),
 'Silver Cave': T('ROCK','GROUND','ICE','FIGHTING'),
 'Ruins Of Alph': T('PSYCHIC','ROCK','GROUND'),
 'Cianwood City': T('FIGHTING','WATER'),
 'Route 40': T('WATER','FLYING'), 'Route 41': T('WATER','FLYING'),
 'Route 19': T('WATER','FLYING'), 'Route 20': T('WATER','FLYING'),
 'Route 21': T('WATER','FLYING'), 'Route 12': T('WATER','GRASS'),
 'Route 13': T('GRASS','NORMAL','POISON'), 'Route 14': T('GRASS','NORMAL','POISON'),
 'Route 15': T('GRASS','NORMAL','POISON'),
 'Route 45': T('ROCK','GROUND','FIGHTING','FLYING'),
 'Route 46': T('ROCK','GROUND','NORMAL','FIRE'),
 'Route 33': T('ROCK','GROUND','BUG','NORMAL'),
 'Route 9': T('ROCK','GROUND','NORMAL'), 'Route 10': T('ROCK','GROUND','ELECTRIC'),
 'Route 27': T('WATER','GROUND','NORMAL','FLYING'),
 'Route 28': T('ROCK','GROUND','ICE','FIGHTING'),
 'Route 42': T('WATER','ROCK','GROUND','NORMAL'),
 'Route 43': T('NORMAL','GRASS','ELECTRIC','FLYING'),
}

def loc_types(loc):
    if loc in GYM: return GYM[loc], True
    base = loc.split(' (')[0]
    if base in GYM: return GYM[base], True
    for k, v in HABITAT.items():
        if loc.startswith(k): return v, False
    return None, False

def theme_for(cls, loc):
    ct = CLASS.get(cls, DEFAULT)['types']
    lt, strict = loc_types(loc)
    if lt is None: return ct
    if strict:
        return (ct & lt) if (ct and (ct & lt)) else lt
    if ct is None: return lt
    inter = ct & lt
    return inter if inter else ct

# ---------------------------------------------------------------- eligibility
def bst_cap(lv):
    for hi, cap in ((10,330),(15,360),(20,405),(25,445),(30,475),(35,505),
                    (40,530),(45,550),(50,575),(60,600)):
        if lv <= hi: return cap
    return 700

def bst_floor(lv):
    if lv <= 12: return 0
    if lv <= 20: return 240
    if lv <= 30: return 300
    if lv <= 40: return 350
    if lv <= 50: return 400
    return 450

def eligible(sp, lv, elite, cls=None):
    if sp in GLOBAL_BAN: return False
    if MINLV[sp] > lv + 2: return False
    ev = EVOAT.get(sp)
    if ev is not None and lv > ev + 6: return False           # don't field an unevolved mon past its evo
    if sp in RARE_LINE and not elite: return False
    if sp in STARTER_LINE and cls not in STARTER_OK: return False
    b = META[sp]['bst']
    if b > bst_cap(lv): return False
    if b < bst_floor(lv): return False
    if sp in STARTER_FINAL and not elite: return False
    if sp in PSEUDO and (not elite or lv < 45): return False
    return True

def base_name(sp):
    for suf in FORM_SUFFIX:
        if sp.endswith(suf): return sp[:-len(suf)]
    return sp

PRE = {}
for _a, _lst in D['evo'].items():
    for _m, _p, _b in _lst: PRE.setdefault(_b, _a)
def family(sp):
    seen = set()
    cur = sp
    while cur in PRE and cur not in seen:
        seen.add(cur); cur = PRE[cur]
    return base_name(cur)

POOL = {}
def pool_for(cls, lv, elite, loc=''):
    key = (cls, lv, elite, loc)
    if key in POOL: return POOL[key]
    types = theme_for(cls, loc)
    out = []
    for sp in SPECIES:
        if types is not None and not (set(META[sp]['types']) & types): continue
        if not eligible(sp, lv, elite, cls): continue
        out.append(sp)
    POOL[key] = out
    return out

# ---------------------------------------------------------------- move picking
STATUS_VALUE = {
 'SWORDS_DANCE':70,'DRAGON_DANCE':75,'CALM_MIND':72,'NASTY_PLOT':72,'BULK_UP':65,
 'QUIVER_DANCE':78,'SHELL_SMASH':78,'AGILITY':50,'ROCK_POLISH':45,'HONE_CLAWS':55,
 'WORK_UP':50,'IRON_DEFENSE':45,'AMNESIA':50,'BARRIER':40,'ACID_ARMOR':40,
 'THUNDER_WAVE':60,'TOXIC':62,'WILL_O_WISP':62,'SPORE':80,'SLEEP_POWDER':60,
 'HYPNOSIS':45,'CONFUSE_RAY':45,'GLARE':50,'STUN_SPORE':45,'SING':30,
 'RECOVER':70,'SOFTBOILED':70,'MILK_DRINK':70,'MOONLIGHT':60,'MORNING_SUN':60,
 'SYNTHESIS':60,'REST':55,'ROOST':68,'SLACK_OFF':70,'LEECH_SEED':58,
 'SUBSTITUTE':60,'PROTECT':52,'DETECT':45,'BANEFUL_BUNKER':58,
 'LIGHT_SCREEN':48,'REFLECT':48,'SPIKES':50,'TOXIC_SPIKES':50,'STEALTH_ROCK':64,
 'TRICK_ROOM':40,'DEFOG':30,'HAZE':30,'SCREECH':38,'CHARM':38,'GROWL':10,
 'LEER':10,'TAIL_WHIP':10,'SAND_ATTACK':20,'SMOKESCREEN':20,'DOUBLE_TEAM':40,
 'FOCUS_ENERGY':35,'BELLY_DRUM':55,'CURSE':45,'PERISH_SONG':30,'ENCORE':45,
 'DISABLE':25,'SPIDER_WEB':25,'MEAN_LOOK':30,'ATTRACT':30,'SAFEGUARD':30,
 'SUNNY_DAY':35,'RAIN_DANCE':35,'SANDSTORM':35,'HAIL':35,'BATON_PASS':35,
}

def atk_bias(sp):
    m = META[sp]
    return 'PHYSICAL' if m['atk'] >= m['sat'] else 'SPECIAL'

def dmg_score(sp, mv):
    d = MOVES.get(mv)
    if not d or d['cat'] == 'STATUS': return 0.0
    s = d['power'] * (d['acc'] if d['acc'] else 100) / 100.0
    if d['type'] in META[sp]['types']: s *= 1.5
    s *= 1.15 if d['cat'] == atk_bias(sp) else 0.75
    if d['effect'] in ('EFFECT_RECHARGE','EFFECT_SKY_ATTACK','EFFECT_SOLARBEAM',
                       'EFFECT_RAZOR_WIND','EFFECT_FLY','EFFECT_BOUNCE'): s *= 0.55
    if d['effect'] == 'EFFECT_SELFDESTRUCT': s *= 0.35
    if d['effect'] in ('EFFECT_MULTI_HIT','EFFECT_DOUBLE_HIT'): s *= 1.25
    if d['effect'] == 'EFFECT_LEVEL_DAMAGE': s = 45
    return s

def choose_moves(sp, lv, headroom=0):
    cands = [m for l, m in LEARN.get(sp, []) if l <= lv + headroom]
    cands = list(dict.fromkeys(reversed(cands)))          # newest first, dedup
    cands = [m for m in cands if m in MOVES]
    if not cands: return ['TACKLE'] * 4
    dmg = sorted([m for m in cands if MOVES[m]['cat'] != 'STATUS'],
                 key=lambda m: -dmg_score(sp, m))
    picked, seen_types = [], collections.Counter()
    for m in dmg:
        t = MOVES[m]['type']
        if seen_types[t] >= 2: continue
        picked.append(m); seen_types[t] += 1
        if len(picked) == 3: break
    stat = sorted([m for m in cands if MOVES[m]['cat'] == 'STATUS'],
                  key=lambda m: -STATUS_VALUE.get(m, 15))
    if stat and STATUS_VALUE.get(stat[0], 15) >= 35 and len(picked) >= 2:
        picked.append(stat[0])
    for m in dmg + stat:
        if len(picked) >= 4: break
        if m not in picked: picked.append(m)
    while len(picked) < 4: picked.append(picked[-1] if picked else 'TACKLE')
    return picked[:4]

def moveset_is_weak(sp, lv):
    best = max([dmg_score(sp, m) for l, m in LEARN.get(sp, []) if l <= lv] or [0])
    return best < 55 and lv >= 25

# ---------------------------------------------------------------- held items
TYPE_ITEM = {'NORMAL':'PINK_BOW','FIGHTING':'BLACKBELT','FLYING':'SHARP_BEAK',
 'POISON':'POISON_BARB','GROUND':'SOFT_SAND','ROCK':'HARD_STONE','BUG':'SILVERPOWDER',
 'GHOST':'SPELL_TAG','FIRE':'CHARCOAL','WATER':'MYSTIC_WATER','GRASS':'MIRACLE_SEED',
 'ELECTRIC':'MAGNET','PSYCHIC':'TWISTEDSPOON','ICE':'NEVERMELTICE','DRAGON':'DRAGON_SCALE',
 'DARK':'BLACKGLASSES','STEEL':'METAL_COAT'}

def pick_item(sp, lv, elite, rng):
    m = META[sp]
    bulky = (m['hp'] + m['def'] + m['sdf']) >= 260
    fast  = m['spe'] >= 95
    phys  = atk_bias(sp) == 'PHYSICAL'
    if not elite:
        if lv < 22: return rng.choice(['BERRY','BERRY','NO_ITEM','PSNCUREBERRY'])
        if lv < 36: return rng.choice(['BERRY','GOLD_BERRY','QUICK_CLAW','NO_ITEM',
                                       TYPE_ITEM.get(m['types'][0],'NO_ITEM')])
        return rng.choice(['GOLD_BERRY','MIRACLEBERRY','LEFTOVERS','QUICK_CLAW',
                           'FOCUS_BAND', TYPE_ITEM.get(m['types'][0],'NO_ITEM')])
    if lv < 25:
        return rng.choice(['BERRY','GOLD_BERRY', TYPE_ITEM.get(m['types'][0],'NO_ITEM')])
    if lv < 38:
        opts = ['GOLD_BERRY','MIRACLEBERRY','QUICK_CLAW','SCOPE_LENS','LEFTOVERS',
                TYPE_ITEM.get(m['types'][0],'NO_ITEM')]
        if sp in EVOAT or sp in D['has_evo']: opts.append('EVIOLITE')
        return rng.choice(opts)
    if lv < 48:
        opts = ['LEFTOVERS','MIRACLEBERRY','SCOPE_LENS','MUSCLE_BAND' if phys else 'WISE_GLASSES',
                'EXPERT_BELT','QUICK_CLAW', TYPE_ITEM.get(m['types'][0],'NO_ITEM')]
        if sp in D['has_evo']: opts.append('EVIOLITE')
        if bulky: opts += ['LEFTOVERS','ROCKY_HELMET']
        return rng.choice(opts)
    opts = ['LIFE_ORB','EXPERT_BELT','CHOICE_BAND' if phys else 'CHOICE_SPECS',
            'MUSCLE_BAND' if phys else 'WISE_GLASSES','LEFTOVERS','WEAK_POLICY']
    if bulky: opts += ['LEFTOVERS','ROCKY_HELMET','ASSAULT_VEST']
    if fast:  opts += ['FOCUS_SASH','LIFE_ORB']
    else:     opts += ['CHOICE_SCARF']
    if 'FLYING' not in m['types'] and 'GROUND' not in m['types']: opts.append('AIR_BALLOON')
    return RNG.choice(opts) if rng is None else rng.choice(opts)

# ---------------------------------------------------------------- parse file
PATH = 'data/trainers/parties.asm'
raw = io.open(PATH, encoding='utf-8', newline='').read()
NL = '\r\n' if '\r\n' in raw else '\n'
lines = raw.split(NL)

trainers = []
i = 0
while i < len(lines):
    m = re.search(r'next_list_item ; ([A-Z_0-9]+) \((\d+)\) (\w+)(.*)', lines[i])
    if not m:
        i += 1; continue
    t = {'cls': m.group(1), 'id': m.group(3),
         'loc': m.group(4).strip().lstrip('- ').strip(), 'head': i, 'mons': []}
    j = i + 1
    hm = re.match(r'\s*db "(.*?)@", (TRAINERTYPE_\w+)', lines[j])
    t['name'], t['ttype'] = hm.group(1), hm.group(2)
    j += 1
    while not lines[j].strip().startswith('db -1'):
        lv = int(re.match(r'\s*db (\d+)', lines[j]).group(1)); j += 1
        sp = re.match(r'\s*dw (\w+)', lines[j]).group(1); j += 1
        item, mvs = None, None
        if 'ITEM' in t['ttype']:
            item = re.match(r'\s*db (\w+)', lines[j]).group(1); j += 1
        if 'MOVES' in t['ttype']:
            mvs = [x.strip() for x in re.match(r'\s*dw (.+)', lines[j]).group(1).split(',')]; j += 1
        t['mons'].append({'lv': lv, 'sp': sp, 'item': item, 'moves': mvs})
    t['end'] = j
    trainers.append(t)
    i = j + 1

live = [t for t in trainers if t['cls'] not in UNTOUCHED]
print('parsed %d trainers; rebalancing %d (%d left untouched)'
      % (len(trainers), len(live), len(trainers) - len(live)))

# ---------------------------------------------------------------- level smoothing
byloc = collections.defaultdict(list)
for t in live: byloc[t['loc']].append(t)
shifted = 0
for loc, ts in byloc.items():
    if not loc or len(ts) < 3: continue
    med = statistics.median([max(x['lv'] for x in t['mons']) for t in ts])
    for t in ts:
        top = max(x['lv'] for x in t['mons'])
        d = med - top
        if abs(d) > 3:
            s = int(max(-5, min(5, d)))
            for mon in t['mons']: mon['lv'] = max(2, min(80, mon['lv'] + s))
            shifted += 1
for t in live:
    t['mons'].sort(key=lambda x: x['lv'])
print('level-smoothed %d trainers (spikes pulled toward their area median)' % shifted)

# ---------------------------------------------------------------- party padding
padded = 0
for t in live:
    top = max(x['lv'] for x in t['mons'])
    elite = t['cls'] in ELITE
    want = 1
    if top >= 40 and len(t['mons']) == 1: want = 2
    if elite and top >= 48 and len(t['mons']) < 3: want = 3
    while len(t['mons']) < want:
        t['mons'].insert(0, {'lv': max(2, t['mons'][0]['lv'] - 2), 'sp': None,
                             'item': None, 'moves': None})
        padded += 1
    t['mons'].sort(key=lambda x: x['lv'])
print('padded %d extra Pokemon onto thin late-game parties' % padded)

# ---------------------------------------------------------------- species pass
# The game is set in Johto, so Johto leads on Johto maps and Kanto leads on
# Kanto maps; new species hold ~1/3 everywhere.
KANTO_PLACES = ('Pallet','Viridian','Pewter','Cerulean','Vermilion','Lavender','Celadon',
 'Fuchsia','Saffron','Cinnabar','Indigo','Mount Moon','Rock Tunnel','Trainer House',
 'Silver Cave','Seafoam','Diglett','Power Plant','Pokemon Tower','Victory Road')

def region(loc):
    if not loc or loc.startswith('not placed'): return 'none'
    m = re.match(r'Route (\d+)', loc)
    if m: return 'kanto' if int(m.group(1)) <= 25 else 'johto'
    for k in KANTO_PLACES:
        if loc.startswith(k): return 'kanto'
    return 'johto'

TARGETS = {
 'johto': {'johto': 0.46, 'kanto': 0.21, 'new': 0.33},
 'kanto': {'kanto': 0.46, 'johto': 0.21, 'new': 0.33},
 'none':  {'johto': 0.34, 'kanto': 0.33, 'new': 0.33},
}
reg_count = collections.defaultdict(collections.Counter)
gen_count = collections.Counter()
use_count = collections.Counter()

def bucket(sp):
    return 'new' if sp in NEW else ('kanto' if sp in KANTO else 'johto')

def pick(cls, lv, elite, taken, fams, rng, loc=''):
    base = pool_for(cls, lv, elite, loc)
    cands = [s for s in base if s not in taken and family(s) not in fams]
    if not cands:                                   # relax the power band first
        cands = [s for s in base if s not in taken]
    if not cands:                                   # then a nearby level band
        for d in (4, 8, 12):
            cands = [s for s in pool_for(cls, lv + d, elite, loc) if s not in taken
                     and family(s) not in fams]
            if cands: break
    if not cands:                                   # last resort: drop the theme
        cands = [s for s in SPECIES if eligible(s, lv, elite, cls) and s not in taken]
    if not cands: return 'RATTATA'
    reg = region(loc)
    rc = reg_count[reg]
    rtot = sum(rc.values()) + 3
    # pick the generation first, so pool size can't decide the ratio for us,
    # then pick a species inside it
    by_gen = collections.defaultdict(list)
    for sp in cands: by_gen[bucket(sp)].append(sp)
    gens = list(by_gen)
    gw = []
    for b in gens:
        share = (rc[b] + 1) / float(rtot)
        gw.append(TARGETS[reg][b] * (TARGETS[reg][b] / share) ** 1.2)
    b = rng.choices(gens, weights=gw, k=1)[0]
    def w(sp):
        x = 1.0 / (1 + use_count[sp]) ** 1.35               # spread the roster out
        fit = META[sp]['bst'] / float(bst_cap(lv))
        x *= 0.45 + 0.9 * min(fit, 1.0)                     # favour level-appropriate power
        return x
    pool = by_gen[b]
    sp = rng.choices(pool, weights=[w(s) for s in pool], k=1)[0]
    gen_count[b] += 1
    reg_count[reg][b] += 1
    use_count[sp] += 1
    return sp

changed_sp = 0
for t in live:
    rng = random.Random(hash((t['cls'], t['id'])) & 0xffffffff)
    elite = t['cls'] in ELITE
    taken, fams = set(), set()
    for mon in t['mons']:
        sp = pick(t['cls'], mon['lv'], elite, taken, fams, rng, t['loc'])
        taken.add(sp); fams.add(family(sp))
        if mon['sp'] != sp: changed_sp += 1
        mon['sp'] = sp
print('assigned species to %d slots' % changed_sp)

# ---------------------------------------------------------------- moves + items
upgraded = 0
for t in live:
    rng = random.Random((hash((t['id'], 'mv')) & 0xffffffff))
    elite = t['cls'] in ELITE
    need_help = any(moveset_is_weak(m['sp'], m['lv']) for m in t['mons'])
    if elite:
        t['ttype'] = 'TRAINERTYPE_ITEM_MOVES'
    elif need_help and 'MOVES' not in t['ttype']:
        t['ttype'] = ('TRAINERTYPE_ITEM_MOVES' if 'ITEM' in t['ttype']
                      else 'TRAINERTYPE_MOVES')
        upgraded += 1
    for mon in t['mons']:
        if 'MOVES' in t['ttype']:
            head = 6 if moveset_is_weak(mon['sp'], mon['lv']) else 0
            mon['moves'] = choose_moves(mon['sp'], mon['lv'], head)
        else:
            mon['moves'] = None
        if 'ITEM' in t['ttype']:
            mon['item'] = pick_item(mon['sp'], mon['lv'], elite, rng)
        else:
            mon['item'] = None
print('gave explicit movesets to %d extra trainers whose natural moves were weak' % upgraded)

# ---------------------------------------------------------------- emit
out = []
prev = 0
for t in trainers:
    out.extend(lines[prev:t['head'] + 1])
    prev = t['end'] + 1
    if t['cls'] in UNTOUCHED:
        out.extend(lines[t['head'] + 1:t['end'] + 1]); continue
    out.append('\tdb "%s@", %s' % (t['name'], t['ttype']))
    for mon in t['mons']:
        out.append('\tdb %d' % mon['lv'])
        out.append('\tdw %s' % mon['sp'])
        if mon['item'] is not None: out.append('\tdb %s' % mon['item'])
        if mon['moves'] is not None: out.append('\tdw %s' % ', '.join(mon['moves']))
    out.append('\tdb -1 ; end')
out.extend(lines[prev:])
io.open(PATH, 'w', encoding='utf-8', newline='').write(NL.join(out))

# ---------------------------------------------------------------- re-section
# Adding items + movesets grows the file past the 16 KiB-per-section limit, so
# lay the trainer groups out across as many sections as they need.
txt = io.open(PATH, encoding='utf-8', newline='').read()
NL2 = '\r\n' if '\r\n' in txt else '\n'
ls = txt.split(NL2)
ls = [l for l in ls if not re.match(r'SECTION "Enemy Trainer Parties \d+", ROMX', l)]
# strip blank lines left behind by removed SECTION headers
cleaned = []
for k, l in enumerate(ls):
    if l.strip() == '' and cleaned and cleaned[-1].strip() == '' : continue
    cleaned.append(l)
ls = cleaned

group_at = [k for k, l in enumerate(ls) if re.match(r'^\w+Group:', l)]
sizes = {}
k = 0
cur_group = None
for k, l in enumerate(ls):
    m = re.match(r'^(\w+Group):', l)
    if m: cur_group = m.group(1); sizes[cur_group] = 0
    if cur_group is None: continue
    m = re.match(r'\s*db "(.*?)@", ', l)
    if m: sizes[cur_group] += len(m.group(1)) + 2
    elif re.match(r'\s*db \d+$', l): sizes[cur_group] += 1
    elif re.match(r'\s*dw \w+$', l): sizes[cur_group] += 2
    elif re.match(r'\s*db [A-Z][A-Z_0-9]*$', l): sizes[cur_group] += 1
    elif re.match(r'\s*dw .+,', l): sizes[cur_group] += 8
    elif l.strip().startswith('db -1'): sizes[cur_group] += 1

# Sections 1 and 2 are pinned to specific banks in pokecrystal.link and those
# banks are nearly full, so respect their original budgets and let every later
# section float (rgblink has all of banks 144+ free).
BUDGETS = [3603, 11856]
FLOAT_LIMIT = 13000
out2, sec, run = [], 1, 0
first = True
def budget(n):
    return BUDGETS[n - 1] if n <= len(BUDGETS) else FLOAT_LIMIT
for k, l in enumerate(ls):
    m = re.match(r'^(\w+Group):', l)
    if m:
        g = m.group(1)
        if first or run + sizes[g] > budget(sec):
            if not first: sec += 1
            out2 += ['', 'SECTION "Enemy Trainer Parties %d", ROMX' % sec, '']
            run = 0; first = False
        run += sizes[g]
    out2.append(l)
io.open(PATH, 'w', encoding='utf-8', newline='').write(NL2.join(out2))
print('laid trainer groups out across %d sections (total party data %d bytes)' % (sec, sum(sizes.values())))

tot = sum(gen_count.values())
print('\nspecies mix overall: johto %d (%.0f%%)  kanto %d (%.0f%%)  new %d (%.0f%%)  of %d slots'
      % (gen_count['johto'], 100*gen_count['johto']/tot, gen_count['kanto'],
         100*gen_count['kanto']/tot, gen_count['new'], 100*gen_count['new']/tot, tot))
for r in ('johto', 'kanto', 'none'):
    rc = reg_count[r]; rt = sum(rc.values()) or 1
    print('  on %-6s maps: johto %3d (%2.0f%%)  kanto %3d (%2.0f%%)  new %3d (%2.0f%%)'
          % (r, rc['johto'], 100*rc['johto']/rt, rc['kanto'], 100*rc['kanto']/rt,
             rc['new'], 100*rc['new']/rt))
print('distinct species used: %d' % len(use_count))
