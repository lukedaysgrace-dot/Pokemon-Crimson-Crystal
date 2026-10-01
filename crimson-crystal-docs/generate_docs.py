#!/usr/bin/env python3
from pathlib import Path
import re, json, shutil, html, argparse
try:
    from PIL import Image
except ImportError:
    Image = None

def txt(p):
    return p.read_text(encoding='utf-8', errors='ignore')
def strip(line):
    return line.split(';',1)[0].strip()
# ---------------------------------------------------------------------------
# Front-pic animations (gfx/pokemon/<mon>/anim.asm + anim_idle.asm)
#
# Mirrors engine/gfx/pic_animation.asm. The stats screen plays ANIM_MON_MENU:
#   pokeanim CryNoWait, Setup, Play, SetWait, Wait, Idle, Play
# i.e. run anim.asm once, hold 18 frames (PokeAnim_SetWait), run anim_idle.asm
# once, then settle back on the static frame.
#
# front.png is authored as the static frame followed by each animation frame,
# stacked vertically in blocks of <width> x <width> pixels, so frame index N in
# the scripts is simply block N of the sheet.
# ---------------------------------------------------------------------------
ANIM_GAP_FRAMES = 18      # PokeAnim_SetWait
ANIM_MAX_STEPS = 600      # guard against malformed / cyclic scripts

def parse_pic_anim(path):
  """Flatten an anim.asm script into [(frame, duration), ...].

  Supports the pic-animation command set: `frame`, `setrepeat`, `dorepeat`,
  `endanim`. `dorepeat`'s operand is a command index (wPokeAnimFrame), matching
  PokeAnim_GetPointer. Returns (steps, warning_or_None).
  """
  cmds=[]
  for raw in txt(path).splitlines():
    line=strip(raw)
    if not line: continue
    parts=line.replace(',',' ').split()
    op=parts[0].lower(); args=parts[1:]
    def val(s):
      s=s.strip()
      try:
        if s.startswith('$'): return int(s[1:],16)
        if s.startswith('%'): return int(s[1:],2)
        return int(s,10)
      except ValueError:
        return None
    if op=='frame' and len(args)>=2:
      f,d=val(args[0]),val(args[1])
      if f is None or d is None: return [],f'unreadable frame command in {path}'
      cmds.append(('frame',f,d))
    elif op=='setrepeat' and args:
      cmds.append(('setrepeat',val(args[0]),0))
    elif op=='dorepeat' and args:
      cmds.append(('dorepeat',val(args[0]),0))
    elif op=='endanim':
      cmds.append(('endanim',0,0))
    elif op in ('dowait','dorestart','delanim'):
      # OAM-animation commands; not used by pic animations.
      return [],f'unsupported pic-anim command "{op}" in {path}'
    else:
      return [],f'unrecognised line "{line}" in {path}'
  steps=[]; pc=0; repeat=0; guard=0
  while 0<=pc<len(cmds):
    guard+=1
    if guard>ANIM_MAX_STEPS: return steps,f'animation script did not terminate: {path}'
    op,a,b=cmds[pc]; pc+=1
    if op=='endanim': break
    if op=='frame':
      if a is None or b is None or b<=0: continue
      steps.append((a,b))
    elif op=='setrepeat':
      repeat=a or 0
    elif op=='dorepeat':
      # PokeAnim .DoRepeat: fall through on 0, else decrement and jump while non-zero.
      if repeat:
        repeat-=1
        if repeat: pc=a or 0
  return steps,None

SPECIAL_DISPLAY_NAMES = {
    # Internal constants whose code-safe names differ from their proper display names.
    'PSYCHIC_M': 'Psychic',
    'FARFETCH_D': "Farfetch'd",
    'SIRFETCH_D': "Sirfetch'd",
    'MR__MIME': 'Mr. Mime',
    'MR__RIME': 'Mr. Rime',
    'HO_OH': 'Ho-Oh',
    'PORYGON_Z': 'Porygon-Z',
    'TYPE_NULL': 'Type: Null',
    'JANGMO_O': 'Jangmo-o',
    'HAKAMO_O': 'Hakamo-o',
    'KOMMO_O': 'Kommo-o',
    'NIDORAN_F': 'Nidoran♀',
    'NIDORAN_M': 'Nidoran♂',
    'DUDUNSPARCE': 'Dudunsparce',
    'CORVISQUIRE': 'Corvisquire',
    'CORVIKNIGHT': 'Corviknight',
    'CENTISKORCH': 'Centiskorch',
    'FLETCHINDER': 'Fletchinder',
    'DOUBLE_EDGE': 'Double-Edge',
    'SOFTBOILED': 'Soft-Boiled',
    'WILL_O_WISP': 'Will-O-Wisp',
    'U_TURN': 'U-turn',
    'X_SCISSOR': 'X-Scissor',
    'V_CREATE': 'V-create',
    'FREEZE_DRY': 'Freeze-Dry',
    'TRI_ATTACK': 'Tri Attack',
    'CURSE_T': '???',
    'MINDS_EYE': "Mind's Eye",
}

# Move names. The ROM's move-name table is ALL CAPS and squeezed into 12
# characters (DAZZLE GLEAM, PHANTOMFORCE...), so the site uses each move's
# constant and fixes the handful that do not read correctly on their own.
MOVE_DISPLAY_NAMES = {
    'THUNDERPUNCH': 'Thunder Punch', 'VICEGRIP': 'Vise Grip', 'SAND_ATTACK': 'Sand Attack',
    'SONICBOOM': 'Sonic Boom', 'BUBBLEBEAM': 'Bubble Beam', 'SOLARBEAM': 'Solar Beam',
    'POISONPOWDER': 'Poison Powder', 'THUNDERSHOCK': 'Thunder Shock', 'SMOKESCREEN': 'Smokescreen',
    'SELFDESTRUCT': 'Self-Destruct', 'HI_JUMP_KICK': 'High Jump Kick', 'DOUBLESLAP': 'Double Slap',
    'CONVERSION2': 'Conversion 2', 'FAINT_ATTACK': 'Feint Attack', 'MUD_SLAP': 'Mud-Slap',
    'LOCK_ON': 'Lock-On', 'DYNAMICPUNCH': 'Dynamic Punch', 'DRAGONBREATH': 'Dragon Breath',
    'EXTREMESPEED': 'Extreme Speed', 'ANCIENTPOWER': 'Ancient Power', 'ACCELROCK': 'Accelerock',
    'DUALWINGBEAT': 'Dual Wingbeat', 'PHANTOMFORCE': 'Phantom Force', 'HEADLONGRUSH': 'Headlong Rush',
    'SHELLSIDEARM': 'Shell Side Arm', 'PSYSHIELD': 'Psyshield Bash', 'STRANGESTEAM': 'Strange Steam',
    'BANEFUL_BUNKER': 'Baneful Bunker', 'KOWTOW_CLEAVE': 'Kowtow Cleave',
}
def move_disp(const):
    c=(const or '').strip().upper()
    return MOVE_DISPLAY_NAMES.get(c) or disp(c)

# Plain-English labels for base-data constants.
GENDER_TEXT = {
    'GENDER_F0': '100% male', 'GENDER_F12_5': '87.5% male, 12.5% female',
    'GENDER_F25': '75% male, 25% female', 'GENDER_F50': '50% male, 50% female',
    'GENDER_F75': '25% male, 75% female', 'GENDER_F100': '100% female',
    'GENDER_UNKNOWN': 'Genderless',
}
EGG_GROUP_TEXT = {
    'EGG_MONSTER': 'Monster', 'EGG_WATER_1': 'Water 1', 'EGG_BUG': 'Bug', 'EGG_FLYING': 'Flying',
    'EGG_GROUND': 'Field', 'EGG_FAIRY': 'Fairy', 'EGG_PLANT': 'Grass', 'EGG_HUMANSHAPE': 'Human-Like',
    'EGG_WATER_3': 'Water 3', 'EGG_MINERAL': 'Mineral', 'EGG_INDETERMINATE': 'Amorphous',
    'EGG_WATER_2': 'Water 2', 'EGG_DITTO': 'Ditto', 'EGG_DRAGON': 'Dragon',
    'EGG_NONE': 'Undiscovered (cannot breed)',
}
GROWTH_TEXT = {
    'GROWTH_MEDIUM_FAST': 'Medium Fast', 'GROWTH_SLIGHTLY_FAST': 'Slightly Fast',
    'GROWTH_SLIGHTLY_SLOW': 'Slightly Slow', 'GROWTH_MEDIUM_SLOW': 'Medium Slow',
    'GROWTH_FAST': 'Fast', 'GROWTH_SLOW': 'Slow',
}
def clean_game_text(t):
    """In-game text uses Game Boy shorthand (ATTACK, SPCL.ATK, POKéMON).
    Make it read naturally on the web."""
    for a,b in (('SPCL.ATK','Sp. Atk'),('SPCL.DEF','Sp. Def'),('SPCL. ATK','Sp. Atk'),
                ('SPCL. DEF','Sp. Def'),('SP.ATK','Sp. Atk'),('SP.DEF','Sp. Def'),
                ('ATTACK','Attack'),('DEFENSE','Defense'),('SPEED','Speed'),('ACCURACY','Accuracy'),
                ('EVASION','Evasion'),('POKéMON','Pokémon'),('#MON','Pokémon'),('#','Poké'),
                ('STATUS','status'),('PP','PP'),('HP','HP')):
        t=t.replace(a,b)
    t=re.sub(r'\s+',' ',t).strip()
    return t
def read_text_blocks(path):
    """label -> joined text for blocks written as db/text/next/line/cont lines."""
    out={}; cur=None; parts=[]
    def flush():
        if cur is not None:
            txt_=''
            for x in parts:
                if txt_.endswith('-') and x[:1].islower(): txt_=txt_[:-1]+x
                else: txt_=(txt_+' '+x) if txt_ else x
            out[cur]=clean_game_text(txt_)
    for raw in txt(path).splitlines():
        l=strip(raw)
        m=re.match(r'^([A-Za-z0-9_]+):',l)
        if m:
            flush(); cur=m.group(1); parts=[]; continue
        if cur is None: continue
        for q in re.findall(r'"([^"]*)"',l):
            q=q.replace('@','').strip()
            if q: parts.append(q)
    flush()
    return out

def disp(s):
    raw=s.strip().strip(',"').replace('@','')
    key=raw.upper()
    if key in SPECIAL_DISPLAY_NAMES:
        return SPECIAL_DISPLAY_NAMES[key]
    return ' '.join(part.capitalize() for part in raw.lower().split('_') if part)
def form_label(const, name):
  suffixes=(
    ('_ALOLAN','Alolan'),
    ('_GALARIAN','Galarian'),
    ('_HISUIAN','Hisuian'),
    ('_PALDEAN_FIRE','Paldean Blaze Breed'),
    ('_PALDEAN_WATER','Paldean Aqua Breed'),
    ('_PALDEAN','Paldean'),
    ('_BLOODMOON','Bloodmoon'),
    ('BM','Bloodmoon'),       # TEDDIURSABM / URSARINGBM / URSALUNABM
  )
  for suffix,label in suffixes:
    if const.endswith(suffix):
      return f'{name} ({label})'
  return name

def pretty_location(const):
    """Map constants -> readable place names: BURNED_TOWER_1F -> Burned Tower 1F,
    RUINS_OF_ALPH_OUTSIDE -> Ruins of Alph Outside, DIGLETTS_CAVE -> Diglett's Cave."""
    t=disp(const)
    t=re.sub(r'\b(B?\d+)f\b',lambda m:m.group(1).upper()+'F',t)
    t=re.sub(r'\b(Ne|Nw|Se|Sw)\b',lambda m:m.group(1).upper(),t)
    for a,b in ((' Of ',' of '),('Digletts',"Diglett's"),('Dragons Den',"Dragon's Den"),
                ('Mount Moon','Mt. Moon'),('Mount Mortar','Mt. Mortar'),
                ('Whirl Island','Whirl Islands')):
        t=t.replace(a,b)
    return t

def slug(s):
    return re.sub(r'[^a-z0-9]+','-',s.lower()).strip('-')

def titlecase(s):
    """ROM name tables are ALL CAPS. Capitalise words without mangling
    apostrophes or hyphens: KING'S ROCK -> King's Rock, UP-GRADE -> Up-Grade."""
    return re.sub(r"(^|[\s\-])([a-z])", lambda m: m.group(1)+m.group(2).upper(), s.lower())

def pretty_group(const):
    """FISHGROUP_QWILFISH_NO_SWARM -> Qwilfish (no swarm)"""
    if not const: return None
    name=re.sub(r'^FISHGROUP_','',const.upper())
    if name.endswith('_NO_SWARM'): return disp(name[:-9])+' (no swarm)'
    if name.endswith('_SWARM'):    return disp(name[:-6])+' (swarm)'
    return disp(name)

# Plain-English rendering of the evolution methods in
# data/pokemon/evos_attacks_*.asm. Nothing on the site should show raw assembly.
HAPPINESS_WHEN={'TR_ANYTIME':'','TR_MORNDAY':' during the day','TR_NITE':' at night'}
STAT_COMPARE={
    'ATK_GT_DEF':'Attack is higher than Defense',
    'ATK_LT_DEF':'Attack is lower than Defense',
    'ATK_EQ_DEF':'Attack and Defense are equal',
}
NO_HELD_ITEM={'-1','$FF','255','NO_ITEM','NONE'}

def describe_evolution(method, args, item, species):
    """method: EVOLVE_* constant. args: the parameters before the target species.
    item/species: callables turning a constant into a display name."""
    # Argument layouts match engine/pokemon/evolve.asm and the format notes at
    # the top of data/pokemon/evos_attacks.asm.
    a0=args[0] if args else ''
    a1=args[1] if len(args)>1 else ''
    _item=item
    item=lambda c: (lambda n: ('an ' if n[:1].upper() in 'AEIOU' else 'a ')+n)(_item(c))
    if method=='EVOLVE_LEVEL':        return f'Level {a0}'
    if method=='EVOLVE_LEVEL_MALE':   return f'Level {a0} (male only)'
    if method=='EVOLVE_LEVEL_FEMALE': return f'Level {a0} (female only)'
    if method=='EVOLVE_ITEM':         return f'Use {item(a0)}'
    if method=='EVOLVE_TRADE':
        return 'Trade' if a0.upper() in NO_HELD_ITEM else f'Trade while holding {item(a0)}'
    if method=='EVOLVE_HAPPINESS':
        return 'Level up with high friendship'+HAPPINESS_WHEN.get(a0.upper(),'')
    if method=='EVOLVE_STAT':
        return f'Level {a0} when '+STAT_COMPARE.get(a1.upper(),disp(a1))
    if method=='EVOLVE_MOVE':    return f'Level up knowing {move_disp(a0)}'
    # dbbbw EVOLVE_HOLDING, level, held item, species. The engine checks the
    # level and the held item only (no time-of-day check) and uses up the item.
    if method=='EVOLVE_HOLDING': return f'Level {a0} while holding {item(a1)}'
    if method=='EVOLVE_PARTY':   return f'Level up with {species(a0)} in the party'
    return ' '.join(x for x in [disp(method.replace('EVOLVE_',''))]+[disp(x) for x in args] if x)
def fmt_power(m):
    v=m.get('power')
    if v is None or v==0: return '—'
    if v==1: return 'Varies'   # fixed-damage / OHKO / variable-power moves
    return str(v)
def fmt_acc(m):
    v=m.get('accuracy')
    if v is None: return '—'
    return f'{v}%'
def num(s):
    try:return int(s.strip().replace('$','0x'),0)
    except:return None

class Builder:
  def __init__(self, repo):
    self.r=repo; self.o=repo/'docs'; self.a=self.o/'assets'; self.report={'warnings':[],'unparsed':[]}
    self.dex_numbers={}
    self.tm_index={}; self.ability_desc={}; self._items={}
  def dex_order(self, order):
    """Regional dex numbering from data/pokemon/dex_order_new.asm.

    Internal species IDs (constants/pokemon_constants.asm) stay untouched, so
    names.asm / base_stats / pics keep working. This table is what the game
    itself uses for the New Pokedex order, with evolution families grouped
    together, and it is what GetRegionalDexNumber prints in-game. The docs must
    use the same numbering or the site disagrees with the ROM.
    """
    p=self.r/'data/pokemon/dex_order_new.asm'
    nums={}
    if p.exists():
      known=set(order)
      n=0
      for raw in txt(p).splitlines():
        l=strip(raw)
        m=re.match(r'^dw\s+([A-Z0-9_]+)',l,re.I)
        if not m: continue
        c=m.group(1).upper()
        if c in nums:
          self.report['warnings'].append(f'dex_order_new.asm lists {c} more than once')
          continue
        if c not in known:
          self.report['warnings'].append(f'dex_order_new.asm lists unknown species {c}')
          continue
        n+=1; nums[c]=n
      missing=[c for c in order if c not in nums]
      if missing:
        self.report['warnings'].append(
          f'{len(missing)} species missing from dex_order_new.asm, appended in declared order: '
          +', '.join(missing[:20])+('…' if len(missing)>20 else ''))
        for c in missing:
          n+=1; nums[c]=n
    else:
      self.report['warnings'].append('Missing data/pokemon/dex_order_new.asm; falling back to internal species IDs')
      nums={c:i for i,c in enumerate(order,1)}
    return nums
  def species(self):
    """Use only the main Pokémon const block, in its exact declared order."""
    p=self.r/'constants/pokemon_constants.asm'; order=[]
    if p.exists():
      in_main=False
      for raw in txt(p).splitlines():
        l=strip(raw)
        if re.match(r'^const_def\s+1\b',l,re.I) and not in_main:
          in_main=True
          continue
        if in_main and re.match(r'^NUM_POKEMON\b',l,re.I):
          break
        if not in_main:
          continue
        m=re.match(r'^const\s+([A-Z0-9_]+)',l,re.I)
        if m:
          c=m.group(1).upper()
          if c != 'EGG': order.append(c)
    np=self.r/'data/pokemon/names.asm'; names={}
    if np.exists():
      raw=txt(np)
      # Ignore EGG and the three ????? engine records before PokemonNames::.
      raw=raw.split('PokemonNames::',1)[1] if 'PokemonNames::' in raw else raw
      found=[x.replace('@','') for x in re.findall(r'db\s+"([^"]+)"',raw)]
      for i,c in enumerate(order):
        # Prefer the hand-written display name keyed by constant; disp() on the
        # raw ROM string mangles punctuation (PORYGON-Z -> "Porygon-z").
        if c in SPECIAL_DISPLAY_NAMES: names[c]=SPECIAL_DISPLAY_NAMES[c]
        elif i<len(found):             names[c]=titlecase(found[i])
        else:                          names[c]=disp(c)
    else:
      names={c:disp(c) for c in order}
    return order,names

  def base_stats(self, order, names):
    root=self.r/'data/pokemon/base_stats'; out={}
    if not root.exists(): self.report['warnings'].append('Missing data/pokemon/base_stats'); return out
    files={re.sub('[^a-z0-9]','',p.stem.lower()):p for p in root.glob('*.asm')}
    for i,c in enumerate(order,1):
      p=files.get(re.sub('[^a-z0-9]','',c.lower())) or files.get(re.sub('[^a-z0-9]','',names[c].lower()))
      if not p: continue
      lines=[strip(x) for x in txt(p).splitlines() if strip(x)]
      db=[]
      for l in lines:
        m=re.match(r'db\s+(.+)',l,re.I)
        if m: db.append([v.strip() for v in m.group(1).split(',')])
      stats={}; types=[]; abilities=[]
      for vals in db:
        ns=[num(v) for v in vals[:6]]
        if len(vals)>=6 and all(v is not None for v in ns):
          stats=dict(zip(['HP','Attack','Defense','Speed','Sp. Atk','Sp. Def'],ns)); break
      valid={'NORMAL','FIRE','WATER','ELECTRIC','GRASS','ICE','FIGHTING','POISON','GROUND','FLYING','PSYCHIC','BUG','ROCK','GHOST','DRAGON','DARK','STEEL','FAIRY'}
      for vals in db:
        if len(vals)>=2 and vals[0].upper() in valid and vals[1].upper() in valid:
          types=[disp(vals[0]),disp(vals[1])]
          if types[0]==types[1]: types=types[:1]
          break
      # Crimson Crystal assigns abilities with:
      # abilities_for SPECIES, ABILITY_1, ABILITY_2, HIDDEN_ABILITY
      am=re.search(
        r'\babilities_for\s+[A-Z0-9_]+\s*,\s*([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)',
        txt(p), re.I)
      ability_slots=[]
      if am:
        abilities=[disp(x) for x in am.groups() if x.upper() not in {'NO_ABILITY','NONE'}]
        seen=set()
        for slot,x in enumerate(am.groups()):
          if x.upper() in {'NO_ABILITY','NONE'}: continue
          name=disp(x)
          if name in seen: continue
          seen.add(name)
          ability_slots.append({'name':name,'hidden':slot==2})
        abilities=list(dict.fromkeys(abilities))
      else:
        # Fallback for forks that store abilities on a normal db line.
        am=re.search(r'abilit(?:y|ies).*?(?:db\s+)?([A-Z][A-Z0-9_]*(?:\s*,\s*[A-Z][A-Z0-9_]*){0,2})',txt(p),re.I)
        if am: abilities=[disp(x) for x in am.group(1).split(',')]
      out[c]={'const':c,'name':names[c],'number':self.dex_numbers.get(c,i),'stats':stats,'types':types,'abilities':abilities,'ability_slots':ability_slots,'learnset':[],'evolutions':[],'egg_moves':[],'tmhm':[],'info':self.base_info(p,c),'sprite':None}
      # TM / HM / move tutor compatibility: `tmhm MOVE, MOVE, ...`
      tm=re.search(r'^\s*tmhm\b(.*)$',txt(p),re.M)
      if tm:
        for mv in [x.strip().upper() for x in strip(tm.group(1)).split(',') if x.strip()]:
          if mv in self.tm_index:
            out[c]['tmhm'].append(mv)
          else:
            self.report['warnings'].append(f'{c}: tmhm lists {mv}, which is not a TM, HM or tutor move')
        order={k:i for i,k in enumerate(self.tm_index)}
        out[c]['tmhm']=sorted(dict.fromkeys(out[c]['tmhm']),key=lambda x:order[x])
    return out

  def base_info(self, p, c):
    """Catch rate, held items, gender, breeding and growth from a base_stats file,
    already converted to display text."""
    info={}
    for raw in txt(p).splitlines():
      comment=raw.split(';',1)[1].strip().lower() if ';' in raw else ''
      l=strip(raw)
      vals=[v.strip() for v in re.sub(r'^(db|dn|dw)\s+','',l,flags=re.I).split(',')] if l else []
      if comment.startswith('catch rate') and vals: info['catch_rate']=num(vals[0])
      elif comment.startswith('base exp') and vals: info['base_exp']=num(vals[0])
      elif comment.startswith('items') and len(vals)>=2:
        info['items']=[x.upper() for x in vals[:2]]
      elif comment.startswith('gender ratio') and vals:
        info['gender']=GENDER_TEXT.get(vals[0].upper(),disp(vals[0]))
      elif comment.startswith('step cycles') and vals: info['egg_cycles']=num(vals[0])
      elif comment.startswith('growth rate') and vals:
        info['growth']=GROWTH_TEXT.get(vals[0].upper(),disp(vals[0].upper().replace('GROWTH_','')))
      elif comment.startswith('egg groups') and vals:
        groups=[EGG_GROUP_TEXT.get(x.upper(),disp(x)) for x in vals[:2]]
        info['egg_groups']=list(dict.fromkeys(groups))
    return info

  def tm_table(self):
    """Ordered TM01.., HM01.., tutor moves from constants/item_constants.asm,
    exactly as the tmhm macro numbers them."""
    p=self.r/'constants/item_constants.asm'; out={}
    if not p.exists():
      self.report['warnings'].append('constants/item_constants.asm not found; TM/HM learnsets skipped')
      return out
    tm=hm=mt=0
    for raw in txt(p).splitlines():
      m=re.match(r'^\s*(add_tm|add_hm|add_mt)\s+([A-Z0-9_]+)',strip(raw),re.I)
      if not m: continue
      kind,mv=m.group(1).lower(),m.group(2).upper()
      if kind=='add_tm': tm+=1; out[mv]=f'TM{tm:02}'
      elif kind=='add_hm': hm+=1; out[mv]=f'HM{hm:02}'
      else: mt+=1; out[mv]='Tutor'
    return out

  def egg_moves(self, mons):
    look={re.sub('[^a-z0-9]','',k.lower()):k for k in mons}
    for p in sorted((self.r/'data/pokemon').glob('egg_moves*.asm')):
      cur=None
      for raw in txt(p).splitlines():
        l=strip(raw)
        m=re.match(r'^([A-Za-z0-9_]+)EggMoves:',l)
        if m:
          cur=look.get(re.sub('[^a-z0-9]','',m.group(1).lower()))
          if cur is None and not m.group(1).startswith('No'):
            self.report['warnings'].append(f'{p.name}: egg-move label {m.group(1)}EggMoves matches no species')
          continue
        if not cur: continue
        mm=re.match(r'^dw\s+([A-Z0-9_]+)\s*$',l,re.I)
        if mm:
          mons[cur]['egg_moves'].append(mm.group(1).upper())
        elif re.match(r'^dw\s+-1',l): cur=None

  def ability_descriptions(self):
    """Ability display name -> in-game description."""
    np=self.r/'data/abilities/names.asm'; dp=self.r/'data/abilities/descriptions.asm'
    if not (np.exists() and dp.exists()): return {}
    names=[x.replace('@','') for x in re.findall(r'db\s+"([^"]*)"',txt(np))]
    labels=re.findall(r'^\s*dw\s+([A-Za-z0-9_]+)',txt(dp).split('AbilityDescriptions::',1)[-1],re.M)
    blocks=read_text_blocks(dp); out={}
    for n,lab in zip(names,labels):
      key=re.sub('[^a-z0-9]','',n.lower())
      if key and lab in blocks: out[key]=blocks[lab]
    return out
  def learnsets(self, mons):
    look={re.sub('[^a-z0-9]','',k.lower()):k for k in mons}
    for p in [self.r/'data/pokemon/evos_attacks.asm',self.r/'data/pokemon/evos_attacks_johto.asm',self.r/'data/pokemon/evos_attacks_kanto.asm',self.r/'data/pokemon/evos_attacks_clones.asm']:
      if not p.exists(): continue
      cur=None; mode='evo'
      for raw in txt(p).splitlines():
        l=strip(raw)
        m=re.match(r'^([A-Za-z0-9_]+):',l)
        if m:
          label=m.group(1)
          # Labels are normally BulbasaurEvosAttacks, not merely Bulbasaur.
          label=re.sub(r'(?:EvosAttacks|EvosAndAttacks|Attacks|Learnset)$','',label,flags=re.I)
          cur=look.get(re.sub('[^a-z0-9]','',label.lower()))
          mode='evo'
          continue
        if not cur: continue
        if re.match(r'db\s+0\b',l,re.I):
          if mode=='evo': mode='move'
          continue
        if mode=='evo' and 'EVOLVE_' in l.upper():
          # dbbw / dbbbw METHOD, param[, param], TARGET_SPECIES
          m=re.match(r'^db+w\s+(EVOLVE_[A-Z_]+)\s*,\s*(.+)$',l,re.I)
          if not m:
            self.report['warnings'].append(f'Unparsed evolution for {cur}: {l}')
            continue
          parts=[x.strip() for x in m.group(2).split(',')]
          mons[cur]['evolutions'].append({
            'method':m.group(1).upper(),
            'args':parts[:-1],
            'target':parts[-1].upper()})
        elif mode=='move':
          # This 16-bit engine uses dbw for level + move ID. Accept db too.
          m=re.search(r'\bdbw?\s+(\d+)\s*,\s*([A-Z0-9_]+)',l,re.I)
          if m:
            mons[cur]['learnset'].append({
              'level':int(m.group(1)),
              'const':m.group(2).upper(),
              'move':disp(m.group(2))})
  def item_names(self):
    """Map item constants to their in-game names (data/items/names.asm is
    indexed by the item const block in constants/item_constants.asm)."""
    cp=self.r/'constants/item_constants.asm'; np=self.r/'data/items/names.asm'
    out={}
    if not (cp.exists() and np.exists()):
      self.report['warnings'].append('Item name tables not found; using constant names')
      return out
    ids={}; started=False; nxt=0
    for raw in txt(cp).splitlines():
      l=strip(raw)
      m=re.match(r'^const_def(?:\s+(-?\w+))?\s*$',l,re.I)
      if m:
        if started: break  # a second const_def block (TMs) is not in ItemNames
        started=True; nxt=int(m.group(1)) if m.group(1) else 0
        continue
      if not started: continue
      if re.match(r'^\w+\s+EQU\b',l,re.I) and 'const_value' in l: break
      m=re.match(r'^const\s+([A-Z0-9_]+)',l,re.I)
      if m:
        ids[m.group(1).upper()]=nxt; nxt+=1
      elif re.match(r'^const_skip(?:\s+(\d+))?',l,re.I):
        s=re.match(r'^const_skip(?:\s+(\d+))?',l,re.I)
        nxt+=int(s.group(1)) if s.group(1) else 1
    # ItemNames has no record for NO_ITEM (id 0), so item N is names[N - 1].
    names=[x.replace('@','') for x in re.findall(r'db\s+"([^"]*)"',txt(np))]
    for c,i in ids.items():
      if 1<=i<=len(names): out[c]=titlecase(names[i-1])
    return out

  def finish_evolutions(self, mons):
    """Turn the parsed evolution records into display text, and give every
    Pokemon a back-reference to what it evolves from."""
    items=self.item_names()
    def item(c):
      c=c.strip().upper()
      return items.get(c, disp(c))
    def species(c):
      c=c.strip().upper()
      return form_label(c, mons[c]['name']) if c in mons else disp(c)
    for c,m in mons.items():
      m.setdefault('evolves_from',None)
    for c,m in mons.items():
      for e in m['evolutions']:
        e['text']=describe_evolution(e['method'],e['args'],item,species)
        e['target_name']=species(e['target'])
        e['target_slug']=slug(e['target'])
        tgt=mons.get(e['target'])
        if tgt is not None and not tgt.get('evolves_from'):
          tgt['evolves_from']={'const':c,'name':species(c),'slug':slug(c),'text':e['text']}
        elif tgt is None:
          self.report['warnings'].append(f'{c} evolves into unknown species {e["target"]}')

  def evo_html(self, m, p=''):
    parts=[]
    src=m.get('evolves_from')
    if src:
      parts.append(f'<p class="evofrom">Evolves from <a href="{p}pokemon/{src["slug"]}.html">'
                   f'{html.escape(src["name"])}</a> — {html.escape(src["text"])}</p>')
    if m['evolutions']:
      rows=''.join(
        f'<div class="evorow"><span class="cond">{html.escape(e["text"])}</span>'
        f'<span class="arrow">→</span>'
        f'<a href="{p}pokemon/{e["target_slug"]}.html">{html.escape(e["target_name"])}</a></div>'
        for e in m['evolutions'])
      parts.append(f'<div class="evolist">{rows}</div>')
    elif not src:
      parts.append('<p class="noevo">Does not evolve.</p>')
    return ''.join(parts)

  def moves(self):
    p=self.r/'data/moves/moves.asm'; n=self.r/'data/moves/names.asm'; out=[]
    names=[x.replace('@','') for x in re.findall(r'db\s+"([^"]+)',txt(n))] if n.exists() else []
    if not p.exists(): return out
    dp=self.r/'data/moves/descriptions.asm'
    desc_blocks=read_text_blocks(dp) if dp.exists() else {}
    desc_labels=re.findall(r'^\s*dw\s+([A-Za-z0-9_]+)',txt(dp).split('MoveDescriptions1:',1)[-1].split('\n\n',1)[0],re.M) if dp.exists() else []
    for raw in txt(p).splitlines():
      m=re.search(r'\bmove\s+(.+)',strip(raw),re.I)
      if not m: continue
      v=[x.strip() for x in m.group(1).split(',')]
      if len(v)<7: continue
      idx=len(out)
      comment=raw.split(';',1)[1].strip() if ';' in raw else ''
      # Crimson Crystal's move table comments contain the actual code constant
      # (for example PSYCHIC_M). Keep that constant for cross-referencing while
      # using the names table / display formatter for the user-facing name.
      const_match=re.search(r'\b([A-Z][A-Z0-9_]*)\b',comment.upper()) if comment else None
      move_const=const_match.group(1) if const_match else None
      name=names[idx] if idx<len(names) else (disp(move_const) if move_const else f'Move {idx+1}')
      if move_const in SPECIAL_DISPLAY_NAMES:
        name=SPECIAL_DISPLAY_NAMES[move_const]
      if not move_const:
        move_const=re.sub('[^A-Z0-9]+','_',name.upper()).strip('_')
      rom_name=name
      name=move_disp(move_const)
      desc=desc_blocks.get(desc_labels[idx]) if idx<len(desc_labels) else None
      out.append({'const':move_const,'name':name,'rom_name':rom_name,'description':desc,
                  'power':num(v[1]),'type':disp(v[2]),
                  'category':disp(re.sub(r'^CATEGORIZE_','',v[3].upper())),
                  'accuracy':num(v[4]),'pp':num(v[5]),'chance':num(v[6])})
    return out
  def export_static_sprite(self, src, dst):
    """Copy a square static sprite, or crop the first frame from a sprite sheet."""
    if Image is None:
      raise SystemExit('Sprite cropping requires Pillow. Run: python3 -m pip install Pillow')
    try:
      with Image.open(src) as im:
        im.load()
        w,h=im.size
        # Reject tiny frame/bitmask strips; they caused the narrow vertical images.
        if w < 32 or h < 32:
          return False
        frame=min(w,h)
        # Gen II front frames are normally 40, 48, or 56 pixels square. For a
        # horizontal/vertical animation sheet, the first frame is top-left.
        for size in (56,48,40):
          if w >= size and h >= size and (w==size or h==size or w%size==0 or h%size==0):
            frame=size; break
        crop=im.crop((0,0,frame,frame))
        crop.save(dst,'PNG')
        return True
    except Exception as e:
      self.report['warnings'].append(f'Could not process sprite {src}: {e}')
      return False
  def export_pic_animation(self, m, d, dst):
    """Export the front-pic sheet and the flattened anim/anim_idle timelines."""
    src=d/'front.png'
    if Image is None or not src.exists(): return
    try:
      with Image.open(src) as im:
        im.load(); w,h=im.size
    except Exception as e:
      self.report['warnings'].append(f'Could not read animation sheet {src}: {e}'); return
    if w<8 or h<=w or h%w: return          # single static frame, nothing to animate
    frames=h//w
    main,warn=parse_pic_anim(d/'anim.asm') if (d/'anim.asm').exists() else ([],None)
    if warn: self.report['warnings'].append(warn)
    idle,warn=parse_pic_anim(d/'anim_idle.asm') if (d/'anim_idle.asm').exists() else ([],None)
    if warn: self.report['warnings'].append(warn)
    steps=main+idle
    if not steps: return
    bad=[f for f,_ in steps if not 0<=f<frames]
    if bad:
      self.report['warnings'].append(f'{m["const"]}: animation references frame(s) {sorted(set(bad))} but front.png only has {frames}')
      return
    sheet=dst/(slug(m['const'])+'.sheet.png')
    try:
      shutil.copy2(src,sheet)
    except Exception as e:
      self.report['warnings'].append(f'Could not copy animation sheet {src}: {e}'); return
    m['anim']={'sheet':'assets/pokemon/'+sheet.name,'size':w,'frames':frames,
               'main':[list(x) for x in main],'idle':[list(x) for x in idle],
               'gap':ANIM_GAP_FRAMES if (main and idle) else 0}
  def anim_attrs(self, m, p=''):
    """data-* attributes consumed by the sprite player in app.js."""
    a=m.get('anim')
    if not a: return ''
    seq=lambda xs: ','.join(f'{f}:{d}' for f,d in xs)
    return (f' data-anim-sheet="{p}{a["sheet"]}" data-anim-size="{a["size"]}"'
            f' data-anim-frames="{a["frames"]}" data-anim-gap="{a["gap"]}"'
            f' data-anim-main="{seq(a["main"])}" data-anim-idle="{seq(a["idle"])}"')
  def sprites(self, mons):
    src=self.r/'gfx/pokemon'; dst=self.a/'pokemon'; dst.mkdir(parents=True,exist_ok=True)
    if not src.exists(): return
    dirs={re.sub('[^a-z0-9]','',p.name.lower()):p for p in src.iterdir() if p.is_dir()}
    for m in mons.values():
      const_key=re.sub('[^a-z0-9]','',m['const'].lower())
      d=dirs.get(const_key)
      if not d:
        same_name=[x for x in mons.values() if x['name'].lower()==m['name'].lower()]
        if len(same_name)==1:
          d=dirs.get(re.sub('[^a-z0-9]','',m['name'].lower()))
      if not d: continue
      # Prefer the dedicated static front image. Other PNGs are only fallbacks,
      # and must be large enough to contain a complete front frame.
      candidates=[]
      for name in ('front.png','front.animated.png','front_idle.png','icon.png'):
        q=d/name
        if q.exists(): candidates.append(q)
      candidates += [q for q in sorted(d.glob('*.png')) if q not in candidates]
      target=dst/(slug(m['const'])+'.png')
      for q in candidates:
        if self.export_static_sprite(q,target):
          m['sprite']='assets/pokemon/'+target.name
          break
      self.export_pic_animation(m,d,dst)

  def wild(self, valid_species):
    """Parse every explicitly mapped wild-encounter source used by Crimson Crystal.

    Shared fishing and Headbutt tables are expanded onto real maps only when the
    repository contains an explicit map-to-group mapping. Unknown constants and
    unparsed rows are reported instead of being silently guessed.
    """
    out=[]; root=self.r/'data/wild'
    if not root.exists(): return out

    grass_slot_chances=(30,30,20,10,5,4,1)
    surf_slot_chances=(60,30,10)

    def source_name(path):
      try: return str(path.relative_to(self.r))
      except ValueError: return str(path)

    def add(location, method, time, level, species, source, rate=None,
            chance=None, condition=None, group=None):
      species=species.upper()
      if species in {'TIME_GROUP','NO_POKEMON','NONE'}:
        return
      if species not in valid_species:
        self.report['warnings'].append(
          f'Unknown species {species} in {source_name(source)} for {location}')
        return
      out.append({
        'location_const':location.upper(),
        'location':pretty_location(location),
        'method':method,
        'time':time,
        'level':int(level),
        'pokemon':disp(species),
        'const':species,
        'rate':rate,
        'chance':chance,
        'condition':condition,
        'group':pretty_group(group),
        'source':source_name(source),
      })

    def parse_percent(expr):
      m=re.search(r'(\d+)\s*percent',expr,re.I)
      if m: return int(m.group(1))
      return num(expr)

    # Exact map grass/cave tables.
    for filename in ('johto_grass.asm','kanto_grass.asm'):
      p=root/filename
      if not p.exists(): continue
      location=None; time=None; rates={}; slot=0
      for line_no,raw in enumerate(txt(p).splitlines(),1):
        clean=strip(raw)
        mm=re.match(r'^map_id\s+([A-Z0-9_]+)',clean,re.I)
        if mm:
          location=mm.group(1).upper(); time=None; rates={}; slot=0
          continue
        if not location: continue
        comment=raw.split(';',1)[1].strip().lower() if ';' in raw else ''
        if comment in {'morn','morning'}:
          time='Morning'; slot=0; continue
        if comment=='day':
          time='Day'; slot=0; continue
        if comment in {'nite','night'}:
          time='Night'; slot=0; continue
        rm=re.match(r'^db\s+(.+)',clean,re.I)
        if rm and 'percent' in rm.group(1).lower() and not rates:
          vals=[int(x) for x in re.findall(r'(\d+)\s*percent',rm.group(1),re.I)]
          if len(vals)>=3: rates=dict(zip(('Morning','Day','Night'),vals[:3]))
          continue
        em=re.match(r'^dbw\s+(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
        if em:
          if not time:
            self.report['unparsed'].append(
              f'{source_name(p)}:{line_no}: encounter before time marker: {clean}')
            continue
          chance=grass_slot_chances[slot] if slot<len(grass_slot_chances) else None
          add(location,'Grass / Cave',time,em.group(1),em.group(2),p,
              rates.get(time),chance)
          slot+=1

    # Exact map Surf tables.
    for filename in ('johto_water.asm','kanto_water.asm'):
      p=root/filename
      if not p.exists(): continue
      location=None; rate=None; slot=0
      for raw in txt(p).splitlines():
        clean=strip(raw)
        mm=re.match(r'^map_id\s+([A-Z0-9_]+)',clean,re.I)
        if mm:
          location=mm.group(1).upper(); rate=None; slot=0
          continue
        if not location: continue
        rm=re.match(r'^db\s+(.+)',clean,re.I)
        if rm and rate is None and 'percent' in rm.group(1).lower():
          rate=parse_percent(rm.group(1)); continue
        em=re.match(r'^dbw\s+(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
        if em:
          chance=surf_slot_chances[slot] if slot<len(surf_slot_chances) else None
          add(location,'Surf','Any',em.group(1),em.group(2),p,rate,chance)
          slot+=1

    # Bug-Catching Contest. Entries are probability, species, min level, max level.
    p=root/'bug_contest_mons.asm'
    if p.exists():
      for line_no,raw in enumerate(txt(p).splitlines(),1):
        clean=strip(raw)
        m=re.match(
          r'^(?:dbbw|dbbbw|dbw)\s+([^,]+)\s*,\s*([A-Z0-9_]+)\s*,\s*(\d+)(?:\s*,\s*(\d+))?',
          clean,re.I)
        if not m: continue
        chance=parse_percent(m.group(1))
        min_level=int(m.group(3)); max_level=int(m.group(4) or min_level)
        for level in sorted(set((min_level,max_level))):
          add('NATIONAL_PARK','Bug-Catching Contest','Any',level,m.group(2),p,
              chance=chance,condition='Contest')

    # Parse Headbutt/Rock Smash sets.
    tree_sets={}; psets=root/'treemons.asm'
    if psets.exists():
      label=None; variant='Common Tree'; pending=[]
      for raw in txt(psets).splitlines():
        clean=strip(raw)
        lm=re.match(r'^(TreeMonSet_[A-Za-z0-9_]+):',clean)
        if lm:
          # TreeMonSet_KantoLate -> TREEMON_SET_KANTO_LATE
          tail=lm.group(1)[len('TreeMonSet_'):]
          label='TREEMON_SET_'+re.sub(r'(?<=[a-z0-9])(?=[A-Z])','_',tail).upper()
          # Back-to-back labels with no rows between them share one table.
          if label not in tree_sets:
            tree_sets[label]=tree_sets[pending[-1]] if pending and not tree_sets[pending[-1]] else []
          pending.append(label)
          variant='Common Tree'
          continue
        comment=raw.split(';',1)[1].strip().lower() if ';' in raw else ''
        if comment=='common': variant='Common Tree'
        elif comment=='rare': variant='Rare Tree'
        if not label: continue
        em=re.match(r'^dbbw\s+([^,]+)\s*,\s*(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
        if em:
          tree_sets[label].append({
            'variant':variant,'chance':parse_percent(em.group(1)),
            'level':int(em.group(2)),'species':em.group(3).upper()})

    # Expand Headbutt and Rock Smash sets only through explicit map mappings.
    pmap=root/'treemon_maps.asm'
    if pmap.exists():
      section='Headbutt'
      for line_no,raw in enumerate(txt(pmap).splitlines(),1):
        clean=strip(raw)
        if clean.startswith('RockMonMaps:'): section='Rock Smash'; continue
        if clean.startswith('TreeMonMaps:'): section='Headbutt'; continue
        mm=re.match(r'^treemon_map\s+([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
        if not mm: continue
        location,set_const=mm.group(1).upper(),mm.group(2).upper()
        entries=tree_sets.get(set_const)
        if entries is None:
          self.report['warnings'].append(
            f'Unknown treemon set {set_const} at {source_name(pmap)}:{line_no}')
          continue
        for e in entries:
          method=section if section=='Rock Smash' else f'Headbutt ({e["variant"]})'
          add(location,method,'Any',e['level'],e['species'],pmap,
              chance=e['chance'],group=set_const)

    # Parse fish-group constants in declared order.
    fish_const_order=[]
    for cp in (self.r/'constants').rglob('*.asm'):
      for raw in txt(cp).splitlines():
        m=re.match(r'^\s*const\s+(FISHGROUP_[A-Z0-9_]+)',strip(raw),re.I)
        # FISHGROUP_NONE (0) means "no fishing here" and has no FishGroups row;
        # FishGroups starts at FISHGROUP_SHORE (the engine does `dec d`).
        if m and m.group(1).upper() not in fish_const_order and m.group(1).upper()!='FISHGROUP_NONE':
          fish_const_order.append(m.group(1).upper())

    pfish=root/'fish.asm'
    fish_groups={}; time_groups={}
    if pfish.exists():
      fish_text=txt(pfish)
      group_rows=[]
      in_groups=False
      for raw in fish_text.splitlines():
        clean=strip(raw)
        if clean.startswith('FishGroups:'):
          in_groups=True; continue
        if in_groups and clean.startswith('.'):
          break
        gm=re.match(
          r'^fishgroup\s+[^,]+,\s*\.([A-Za-z0-9_]+)\s*,\s*\.([A-Za-z0-9_]+)\s*,\s*\.([A-Za-z0-9_]+)',
          clean,re.I)
        if in_groups and gm:
          group_rows.append(gm.groups())

      # Parse all local fishing labels into cumulative-probability rows.
      label_rows={}; current=None
      in_time=False; time_index=0
      for raw in fish_text.splitlines():
        clean=strip(raw)
        if clean.startswith('TimeFishGroups:'):
          in_time=True; current=None; continue
        lm=re.match(r'^\.([A-Za-z0-9_]+):',clean)
        if lm and not in_time:
          current=lm.group(1); label_rows.setdefault(current,[]); continue
        if in_time:
          # dbwbw day_level, DAY_SPECIES, nite_level, NITE_SPECIES
          tm=re.match(r'^dbwbw\s+(\d+)\s*,\s*([A-Z0-9_]+)\s*,\s*(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
          if tm:
            time_groups[time_index]=[('Morning/Day',int(tm.group(1)),tm.group(2).upper()),
                                     ('Night',int(tm.group(3)),tm.group(4).upper())]
            time_index+=1
          continue
        if current:
          em=re.match(r'^dbbw\s+([^,]+)\s*,\s*(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
          if em:
            label_rows[current].append({
              'threshold':parse_percent(em.group(1)),
              'level':int(em.group(2)),
              'species':em.group(3).upper()})

      for idx,labels in enumerate(group_rows):
        const=fish_const_order[idx] if idx<len(fish_const_order) else f'FISHGROUP_{idx+1}'
        fish_groups[const]={}
        for rod,label in zip(('Old Rod','Good Rod','Super Rod'),labels):
          rows=label_rows.get(label,[])
          previous=0; expanded=[]
          for row in rows:
            threshold=row['threshold']
            chance=(threshold-previous) if threshold is not None else None
            previous=threshold if threshold is not None else previous
            if row['species']=='TIME_GROUP':
              # Level field is an index into TimeFishGroups.
              tg=time_groups.get(row['level'])
              if tg:
                for when,lvl,sp in tg:
                  expanded.append({'time':when,'level':lvl,'species':sp,'chance':chance})
              else:
                self.report['warnings'].append(
                  f'Unresolved TIME_GROUP index {row["level"]} in {label}')
            else:
              expanded.append({'time':'Any','level':row['level'],
                               'species':row['species'],'chance':chance})
          fish_groups[const][rod]=expanded

    # Map -> fishing group, from the 8th argument of each `map` line in
    # data/maps/maps.asm. Only the map's own name (argument 1) identifies it;
    # the landmark column is shared by every building in a town, so it is
    # never used.
    fish_map_links={}
    known_maps={e['location_const'] for e in out}
    water_maps={e['location_const'] for e in out if e['method']=='Surf'}
    pmaps=self.r/'data/maps/maps.asm'
    if pmaps.exists():
      for raw in txt(pmaps).splitlines():
        mm=re.match(r'^map\s+([A-Za-z0-9_]+)\s*,(.*)$',strip(raw))
        if not mm: continue
        args=[x.strip().upper() for x in mm.group(2).split(',')]
        if len(args)<7: continue
        env,group=args[1],args[6]
        if not group.startswith('FISHGROUP_') or group=='FISHGROUP_NONE': continue
        # Route32 -> ROUTE_32, DragonsDenB1F -> DRAGONS_DEN_B1F
        name=mm.group(1)
        const=re.sub(r'(?<=[a-z])(?=[A-Z0-9])|(?<=[0-9])(?=[A-Z][a-z])','_',name).upper()
        if const not in known_maps:
          squashed={k.replace('_',''):k for k in known_maps}
          const=squashed.get(name.upper(),const)
        # Outdoor maps get a default fishing group even with no water (e.g.
        # Lavender Town), so only maps with Surf data count as fishable.
        if const in water_maps:
          fish_map_links.setdefault(const,set()).add(group)

    for location,groups in fish_map_links.items():
      for group in groups:
        rods=fish_groups.get(group)
        if rods is None:
          self.report['warnings'].append(
            f'Map {location} references unknown fishing group {group}')
          continue
        condition='Swarm' if 'SWARM' in group else None
        for rod,entries in rods.items():
          for e in entries:
            add(location,rod,e['time'],e['level'],e['species'],pfish,
                chance=e['chance'],condition=condition,group=group)

    # Swarm grass/water tables have real map_id records; parse them separately.
    for filename,method,slots in (
      ('swarm_grass.asm','Grass Swarm',grass_slot_chances),
      ('swarm_water.asm','Surf Swarm',surf_slot_chances)):
      p=root/filename
      if not p.exists(): continue
      location=None; time='Any'; slot=0
      for raw in txt(p).splitlines():
        clean=strip(raw)
        mm=re.match(r'^map_id\s+([A-Z0-9_]+)',clean,re.I)
        if mm:
          location=mm.group(1).upper(); time='Any'; slot=0; continue
        comment=raw.split(';',1)[1].strip().lower() if ';' in raw else ''
        if comment in {'morn','morning'}: time='Morning'; slot=0; continue
        if comment=='day': time='Day'; slot=0; continue
        if comment in {'nite','night'}: time='Night'; slot=0; continue
        em=re.match(r'^dbw\s+(\d+)\s*,\s*([A-Z0-9_]+)',clean,re.I)
        if location and em:
          add(location,method,time,em.group(1),em.group(2),p,
              chance=slots[slot] if slot<len(slots) else None,
              condition='Swarm')
          slot+=1

    # Stable output and duplicate protection.
    # The same Pokémon often fills several slots of one table (e.g. Magikarp
    # 70% + 15%). Show it once with the combined chance.
    unique={}
    for e in out:
      key=(e['location_const'],e['method'],e['time'],e['level'],e['const'],
           e.get('condition'),e.get('group'))
      if key in unique:
        u=unique[key]
        if u.get('chance') is not None and e.get('chance') is not None:
          u['chance']+=e['chance']
      else:
        unique[key]=dict(e)
    result=sorted(unique.values(),key=lambda e:(
      e['location'],e['method'],e['time'],e['level'],e['pokemon']))

    self.report['encounter_summary']={
      'total_slots':len(result),
      'locations':len({e['location_const'] for e in result}),
      'pokemon_found':len({e['const'] for e in result}),
      'methods':sorted({e['method'] for e in result}),
      'explicit_fishing_map_links':sum(len(v) for v in fish_map_links.values()),
    }
    return result
  def badge(self,t): return f'<span class="badge type-{slug(t)}">{html.escape(t)}</span>' if t else '—'
  def nav(self,p=''): return f'<header><a class="brand" href="{p}index.html">◆ Crimson Crystal</a><nav><a href="{p}pokedex.html">Pokédex</a><a href="{p}moves.html">Moves</a><a href="{p}encounters.html">Encounters</a><a href="{p}locations.html">Locations</a></nav></header>'
  def shell(self,title,body,p=''): return f'<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>{html.escape(title)} · Crimson Crystal</title><link rel="stylesheet" href="{p}assets/style.css"></head><body>{self.nav(p)}<main>{body}</main><footer>Crimson Crystal documentation generated from source</footer><script src="{p}assets/app.js"></script></body></html>'
  def card(self,m,p=''):
    shown=form_label(m["const"],m["name"])
    im=f'<img src="{p}{m["sprite"]}" alt="{html.escape(shown)}">' if m['sprite'] else '<div class="placeholder">◆</div>'
    search=' '.join([shown,m["const"]]+m['types']+m['abilities']).lower()
    return f'<a class="card searchable" data-search="{html.escape(search)}" data-type="{" ".join(slug(x) for x in m["types"])}" href="{p}pokemon/{slug(m["const"])}.html"><small>#{m["number"]:03}</small>{im}<h3>{html.escape(shown)}</h3><div>{"".join(self.badge(x) for x in m["types"])}</div></a>'
  def attach_clone_forms(self, mons):
    clone_pairs={
      'BULBASAUR':'BULBASAUR_CLONE','IVYSAUR':'IVYSAUR_CLONE','VENUSAUR':'VENUSAUR_CLONE',
      'CHARMANDER':'CHARMANDER_CLONE','CHARMELEON':'CHARMELEON_CLONE','CHARIZARD':'CHARIZARD_CLONE',
      'SQUIRTLE':'SQUIRTLE_CLONE','WARTORTLE':'WARTORTLE_CLONE','BLASTOISE':'BLASTOISE_CLONE'}
    for base,clone in clone_pairs.items():
      if base in mons and clone in mons:
        mons[base]['forms']={'normal':mons[base], 'clone':mons[clone]}
    return set(clone_pairs.values())
  def move_table(self, entries, move_map, first, empty, p='../'):
    """entries: [(first-column text, MOVE_CONST)] -> one learnset table."""
    if not entries: return f'<p class="muted">{empty}</p>'
    head=f'<div class="mv header"><span>{first}</span><span>Move</span><span>Type</span><span>Cat.</span><span>Power</span><span>Acc.</span></div>'
    rows=''
    for label,const in entries:
      mv=move_map.get(const)
      if mv:
        rows+=(f'<div class="mv"><span class="lv">{html.escape(str(label))}</span>'
               f'<a href="{p}moves/{slug(mv["name"])}.html">{html.escape(mv["name"])}</a>'
               f'<span>{self.badge(mv["type"])}</span><span class="cat cat-{slug(mv["category"])}">{html.escape(mv["category"])}</span>'
               f'<span>{fmt_power(mv)}</span><span>{fmt_acc(mv)}</span></div>')
      else:
        self.report['warnings'].append(f'Learnset references unknown move {const}')
        rows+=f'<div class="mv"><span class="lv">{html.escape(str(label))}</span><span>{html.escape(move_disp(const))}</span><span></span><span></span><span></span><span></span></div>'
    return f'<div class="mvtable">{head}{rows}</div>'

  def info_html(self, m):
    i=m.get('info') or {}
    items=self._items if hasattr(self,'_items') else {}
    def item(c): return items.get(c, disp(c))
    held=[]
    its=i.get('items') or []
    real=[x for x in its if x not in NO_HELD_ITEM]
    if len(its)>=2 and its[0]==its[1] and real: held=[item(its[0])]
    else:
      if its and its[0] not in NO_HELD_ITEM: held.append(f'{item(its[0])} (common)')
      if len(its)>1 and its[1] not in NO_HELD_ITEM: held.append(f'{item(its[1])} (rare)')
    rows=[]
    if i.get('catch_rate') is not None: rows.append(('Catch rate',f'{i["catch_rate"]} / 255'))
    if i.get('base_exp') is not None: rows.append(('Base experience',i['base_exp']))
    rows.append(('Wild held items',', '.join(held) if held else 'None'))
    if i.get('gender'): rows.append(('Gender ratio',i['gender']))
    if i.get('egg_groups'): rows.append(('Egg groups',', '.join(i['egg_groups'])))
    if i.get('egg_cycles') is not None and 'Undiscovered (cannot breed)' not in (i.get('egg_groups') or []):
      rows.append(('Hatch time',f'{i["egg_cycles"]} egg cycles (~{i["egg_cycles"]*256:,} steps)'))
    if i.get('growth'): rows.append(('Growth rate',i['growth']))
    return '<dl class="info">'+''.join(f'<div><dt>{k}</dt><dd>{html.escape(str(v))}</dd></div>' for k,v in rows)+'</dl>'

  def abilities_html(self, m):
    slots=m.get('ability_slots') or [{'name':a,'hidden':False} for a in m['abilities']]
    if not slots: return '<p class="muted">No abilities.</p>'
    out=''
    for a in slots:
      d=self.ability_desc.get(re.sub('[^a-z0-9]','',a['name'].lower()),'')
      tag='<span class="hidden-tag">Hidden ability</span>' if a['hidden'] else ''
      out+=f'<div class="ability"><b>{html.escape(a["name"])}</b>{tag}{f"<span>{html.escape(d)}</span>" if d else ""}</div>'
    return f'<div class="abilities">{out}</div>'

  def mon_view(self, m, move_map, eyebrow, page_mon):
    sprite=f'<img class="big" src="../{m["sprite"]}"{self.anim_attrs(m,"../")}>' if m.get('sprite') else '<div class="big placeholder">◆</div>'
    stats=''.join(f'<div class="stat"><span>{k}</span><i><b style="width:{min(100,v/2.55)}%"></b></i><strong>{v}</strong></div>' for k,v in m['stats'].items())
    level=[(x['level'],x['const']) for x in sorted(m['learnset'],key=lambda x:x['level'])]
    tms=[(self.tm_index[c],c) for c in m['tmhm']]
    egg=[('Egg',c) for c in m['egg_moves']]
    name=form_label(page_mon["const"],page_mon["name"])
    return (f'<section class="monhero">{sprite}<div><p class="eyebrow">{html.escape(eyebrow)}</p><h1>{html.escape(name)}</h1>'
            f'<div>{"".join(self.badge(t) for t in m["types"])}</div>{self.abilities_html(m)}</div></section>'
            f'<div class="twocol"><section class="panel"><h2>Base stats <em>Total {sum(m["stats"].values())}</em></h2>{stats or "<p class=muted>No stats.</p>"}</section>'
            f'<section class="panel"><h2>Evolution</h2>{self.evo_html(m,"../")}</section></div>'
            f'<section class="panel"><h2>Training &amp; breeding</h2>{self.info_html(m)}</section>'
            f'<section class="panel"><h2>Level-up moves</h2>{self.move_table(level,move_map,"Level","Learns no moves by level-up.")}</section>'
            f'<section class="panel"><h2>TM / HM moves <em>{len(tms)}</em></h2>{self.move_table(tms,move_map,"TM / HM","Cannot learn any TMs or HMs.")}</section>'
            + (f'<section class="panel"><h2>Egg moves <em>{len(egg)}</em></h2>{self.move_table(egg,move_map,"Learned","")}</section>' if egg else ''))

  def render(self,mons,moves,wild):
    clone_consts=self.attach_clone_forms(mons)
    ms=sorted((m for c,m in mons.items() if c not in clone_consts),key=lambda x:x['number']); move_map={m['const']:m for m in moves}
    wild_by_const={}
    for encounter in wild: wild_by_const.setdefault(encounter.get('const'),[]).append(encounter)
    (self.o/'data').mkdir(parents=True,exist_ok=True)
    clean_ms=[]
    for m in ms:
      q={k:v for k,v in m.items() if k!='forms'}
      if 'forms' in m:
        q['forms']={name:{k:v for k,v in form.items() if k!='forms'} for name,form in m['forms'].items()}
      clean_ms.append(q)
    for name,obj in [('pokemon',clean_ms),('moves',moves),('encounters',wild),('build-report',self.report)]: (self.o/'data'/f'{name}.json').write_text(json.dumps(obj,indent=2))
    cards=''.join(self.card(x) for x in ms)
    home=f'<section class="hero"><div><p class="eyebrow">POKÉMON CRYSTAL ROM HACK</p><h1>Crimson Crystal</h1><p>A searchable guide generated directly from the game source.</p><a class="button" href="pokedex.html">Explore the Pokédex</a></div><div class="gem">◆</div></section><section class="counts"><div><b>{len(ms)}</b> Pokémon</div><div><b>{len(moves)}</b> Moves</div><div><b>{len(wild)}</b> Encounter slots</div></section><h2>Pokédex preview</h2><div class="grid">{cards}</div>'
    (self.o/'index.html').write_text(self.shell('Home',home))
    types=sorted({t for m in ms for t in m['types']}); opts=''.join(f'<option value="{slug(t)}">{t}</option>' for t in types)
    (self.o/'pokedex.html').write_text(self.shell('Pokédex',f'<section class="head"><p class="eyebrow">DATABASE</p><h1>Pokédex</h1></section><div class="toolbar"><input id="search" placeholder="Search Pokémon, type or ability"><select id="typeFilter"><option value="">All types</option>{opts}</select></div><div class="grid">{cards}</div>'))
    for m in ms:
      toggle=''
      clone_panel=''
      if 'forms' in m:
        c=m['forms']['clone']
        toggle='<div class="form-toggle"><button class="active" data-form="normal">Normal</button><button data-form="clone">Clone</button></div>'
        clone_panel=f'<div class="form-view" data-form-view="clone" hidden>{self.mon_view(c,move_map,"CLONE FORM",m)}</div>'
      dexno=f'#{m["number"]:03}'
      normal=f'<div class="form-view" data-form-view="normal">{self.mon_view(m,move_map,dexno,m)}</div>'
      loc_entries=wild_by_const.get(m['const'],[])
      loc_html=''.join(f'<div class="location-row"><b><a href="../locations/{slug(e["location_const"])}.html">{html.escape(e["location"])}</a></b><span>{html.escape(e["method"])}</span><span>{html.escape(e["time"])}</span><span>Lv. {e["level"]}</span></div>' for e in loc_entries)
      locations=f'<section class="panel"><h2>Wild locations</h2><div class="locations">{loc_html or "<p class=muted>Not found in the wild.</p>"}</div></section>'
      body=f'<a class="back" href="../pokedex.html">← Pokédex</a>{toggle}{normal}{clone_panel}{locations}'
      page_title=form_label(m["const"],m["name"])
      p=self.o/'pokemon'/f'{slug(m["const"])}.html';p.parent.mkdir(exist_ok=True);p.write_text(self.shell(page_title,body,'../'))
    rows=''.join(f'<a class="row searchable" data-search="{html.escape((m["name"]+" "+m.get("rom_name","")+" "+m["type"]+" "+m["category"]+" "+self.tm_index.get(m["const"],"")).lower())}" href="moves/{slug(m["name"])}.html"><b>{html.escape(m["name"])}</b><span>{self.badge(m["type"])}</span><span>{m["category"]}</span><span>{fmt_power(m)}</span><span>{fmt_acc(m)}</span><span>{m["pp"] if m["pp"] is not None else "—"}</span></a>' for m in moves)
    (self.o/'moves.html').write_text(self.shell('Moves',f'<section class="head"><p class="eyebrow">BATTLE DATA</p><h1>Moves</h1></section><div class="toolbar"><input id="tableSearch" placeholder="Search moves, types, or TM number"></div><div class="table"><div class="row labels"><span>Move</span><span>Type</span><span>Category</span><span>Power</span><span>Accuracy</span><span>PP</span></div>{rows}</div>'))
    # Reverse index: which Pokémon learn each move, and how.
    learners={}
    for mon in ms:
      label=form_label(mon['const'],mon['name']); href=f'../pokemon/{slug(mon["const"])}.html'
      for x in mon['learnset']:
        learners.setdefault(x['const'],{}).setdefault('Level up',[]).append((label,href,f'Lv. {x["level"]}'))
      for mv in mon['tmhm']:
        learners.setdefault(mv,{}).setdefault('TM / HM / Tutor',[]).append((label,href,''))
      for mv in mon['egg_moves']:
        learners.setdefault(mv,{}).setdefault('Egg move',[]).append((label,href,''))
    for m in moves:
      details=[('Type',self.badge(m["type"])),('Category',html.escape(m["category"])),
               ('Power',fmt_power(m)),('Accuracy',fmt_acc(m)),('PP',m["pp"] if m["pp"] is not None else "—")]
      if m.get('chance'): details.append(('Effect chance',f'{m["chance"]}%'))
      if m['const'] in self.tm_index:
        t=self.tm_index[m['const']]
        details.append(('Taught by','Move Tutor' if t=='Tutor' else t))
      dl=''.join(f'<div><dt>{k}</dt><dd>{v}</dd></div>' for k,v in details)
      desc=f'<p class="movedesc">{html.escape(m["description"])}</p>' if m.get('description') else ''
      groups=learners.get(m['const'],{})
      lb=''
      for how in ('Level up','TM / HM / Tutor','Egg move'):
        if how not in groups: continue
        chips=''.join(f'<a class="learner" href="{h}">{html.escape(n)}{f" <small>{html.escape(extra)}</small>" if extra else ""}</a>' for n,h,extra in sorted(groups[how],key=lambda x:x[0]))
        lb+=f'<h3>{how} <em>{len(groups[how])}</em></h3><div class="learners">{chips}</div>'
      learned=f'<section class="panel"><h2>Pokémon that learn {html.escape(m["name"])}</h2>{lb or "<p class=muted>No Pokémon learn this move by level-up, TM/HM or breeding.</p>"}</section>'
      b=f'<a class="back" href="../moves.html">← Moves</a><section class="head"><p class="eyebrow">{html.escape(m["type"].upper())} MOVE</p><h1>{html.escape(m["name"])}</h1>{desc}</section><section class="panel"><dl>{dl}</dl></section>{learned}'
      p=self.o/'moves'/f'{slug(m["name"])}.html';p.parent.mkdir(exist_ok=True);p.write_text(self.shell(m['name'],b,'../'))
    # Dedicated location index and pages.
    by_location={}
    for e in wild: by_location.setdefault(e['location_const'],[]).append(e)
    location_cards=''.join(
      f'<a class="location-card searchable" data-search="{html.escape(items[0]["location"].lower())}" href="locations/{slug(loc)}.html"><h3>{html.escape(items[0]["location"])}</h3><p>{len(items)} encounter slots · {len(set(x["const"] for x in items))} Pokémon</p><div class="chips">{"".join(f"<span>{html.escape(x)}</span>" for x in sorted(set(e["method"] for e in items)))}</div></a>'
      for loc,items in sorted(by_location.items(),key=lambda x:x[1][0]['location']))
    (self.o/'locations.html').write_text(self.shell(
      'Locations',
      f'<section class="head"><p class="eyebrow">LOCATION DATABASE</p><h1>Locations</h1><p>Every location explicitly found in Crimson Crystal’s encounter tables.</p></section><div class="toolbar"><input id="tableSearch" placeholder="Search locations"></div><div class="location-grid">{location_cards}</div>'))
    for loc,items in by_location.items():
      title=items[0]['location']
      methods={}
      for e in items: methods.setdefault(e['method'],[]).append(e)
      sections=''
      for method,entries in sorted(methods.items()):
        rows=''.join(
          f'<div class="encounter-card"><a href="../pokemon/{slug(e["const"])}.html"><b>{html.escape(e["pokemon"])}</b></a><span>{html.escape(e["time"])}</span><span>Lv. {e["level"]}</span><span>{str(e["chance"])+"%" if e.get("chance") is not None else "—"}</span><span>{html.escape(e.get("condition") or "")}</span></div>'
          for e in entries)
        sections+=f'<section class="panel"><h2>{html.escape(method)}</h2><div class="encounter-card labels"><span>Pokémon</span><span>Time</span><span>Level</span><span>Chance</span><span>Condition</span></div>{rows}</section>'
      lp=self.o/'locations'/f'{slug(loc)}.html'; lp.parent.mkdir(exist_ok=True)
      lp.write_text(self.shell(title,f'<a class="back" href="../locations.html">← Locations</a><section class="head"><p class="eyebrow">WILD ENCOUNTERS</p><h1>{html.escape(title)}</h1></section>{sections}','../'))
    er=''.join(f'<div class="erow searchable" data-search="{html.escape((e["location"]+" "+e["pokemon"]+" "+e["time"]+" "+e["method"]).lower())}"><b>{html.escape(e["location"])}</b><span>{html.escape(e["method"])}</span><span>{e["time"]}</span><span>{e["pokemon"]}</span><span>Lv. {e["level"]}</span><span>{str(e["chance"])+"%" if e.get("chance") is not None else "—"}</span></div>' for e in wild)
    (self.o/'encounters.html').write_text(self.shell('Encounters',f'<section class="head"><p class="eyebrow">WORLD DATA</p><h1>Wild encounters</h1></section><div class="toolbar"><input id="tableSearch" placeholder="Search locations or Pokémon"></div><div class="table"><div class="erow labels"><span>Location</span><span>Method</span><span>Time</span><span>Pokémon</span><span>Level</span><span>Chance</span></div>{er or "<p class=empty>No supported encounter rows detected.</p>"}</div>'))
  def run(self):
    if self.o.exists(): shutil.rmtree(self.o)
    self.a.mkdir(parents=True); base=Path(__file__).parent/'static'; shutil.copy2(base/'style.css',self.a/'style.css'); shutil.copy2(base/'app.js',self.a/'app.js')
    self.tm_index=self.tm_table(); self.ability_desc=self.ability_descriptions(); self._items=self.item_names()
    order,names=self.species(); self.dex_numbers=self.dex_order(order); mons=self.base_stats(order,names); self.learnsets(mons); self.egg_moves(mons); self.finish_evolutions(mons); moves=self.moves(); self.sprites(mons); wild=self.wild(set(mons))
    for e in wild:
      mon=mons.get(e['const'])
      if mon: e['pokemon']=form_label(mon['const'],mon['name'])
    move_names={m['const']:m['name'] for m in moves}
    for mon in mons.values():
      for x in mon['learnset']: x['move']=move_names.get(x['const'],move_disp(x['const']))
      mon['tmhm_labeled']=[{'tm':self.tm_index[c],'const':c,'move':move_names.get(c,move_disp(c))} for c in mon['tmhm']]
    self.render(mons,moves,wild)
    summary=self.report.get('encounter_summary',{})
    print(f'Generated {len(mons)} Pokémon, {len(moves)} moves, {len(wild)} encounter slots across {summary.get("locations",0)} locations -> {self.o}')
    print(f'Validation: {len(self.report["warnings"])} warning(s), {len(self.report["unparsed"])} unparsed row(s). See docs/data/build-report.json.')

def main():
  ap=argparse.ArgumentParser();ap.add_argument('repo',nargs='?',default='.');a=ap.parse_args();r=Path(a.repo).resolve()
  if not (r/'data').exists(): raise SystemExit('Run this against the repository root; data/ was not found.')
  Builder(r).run()
if __name__=='__main__':main()
