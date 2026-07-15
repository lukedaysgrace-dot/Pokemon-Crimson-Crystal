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
def disp(s):
    return ' '.join(x.capitalize() for x in s.strip().strip(',"').replace('@','').lower().split('_'))
def slug(s):
    return re.sub(r'[^a-z0-9]+','-',s.lower()).strip('-')
def num(s):
    try:return int(s.strip().replace('$','0x'),0)
    except:return None

class Builder:
  def __init__(self, repo):
    self.r=repo; self.o=repo/'docs'; self.a=self.o/'assets'; self.report={'warnings':[],'unparsed':[]}
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
        names[c]=disp(found[i]) if i<len(found) else disp(c)
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
      if am:
        abilities=[disp(x) for x in am.groups() if x.upper() not in {'NO_ABILITY','NONE'}]
      else:
        # Fallback for forks that store abilities on a normal db line.
        am=re.search(r'abilit(?:y|ies).*?(?:db\s+)?([A-Z][A-Z0-9_]*(?:\s*,\s*[A-Z][A-Z0-9_]*){0,2})',txt(p),re.I)
        if am: abilities=[disp(x) for x in am.group(1).split(',')]
      out[c]={'const':c,'name':names[c],'number':i,'stats':stats,'types':types,'abilities':abilities,'learnset':[],'evolutions':[],'egg_moves':[],'sprite':None}
    return out
  def learnsets(self, mons):
    look={re.sub('[^a-z0-9]','',k.lower()):k for k in mons}
    look.update({re.sub('[^a-z0-9]','',v['name'].lower()):k for k,v in mons.items()})
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
        if mode=='evo' and 'EVOLVE_' in l.upper(): mons[cur]['evolutions'].append(l.replace('db ','',1))
        elif mode=='move':
          # This 16-bit engine uses dbw for level + move ID. Accept db too.
          m=re.search(r'\bdbw?\s+(\d+)\s*,\s*([A-Z0-9_]+)',l,re.I)
          if m:
            mons[cur]['learnset'].append({
              'level':int(m.group(1)),
              'const':m.group(2).upper(),
              'move':disp(m.group(2))})
  def moves(self):
    p=self.r/'data/moves/moves.asm'; n=self.r/'data/moves/names.asm'; out=[]
    names=[x.replace('@','') for x in re.findall(r'db\s+"([^"]+)',txt(n))] if n.exists() else []
    if not p.exists(): return out
    for raw in txt(p).splitlines():
      m=re.search(r'\bmove\s+(.+)',strip(raw),re.I)
      if not m: continue
      v=[x.strip() for x in m.group(1).split(',')]
      if len(v)<7: continue
      idx=len(out); name=names[idx] if idx<len(names) else (disp(raw.split(';',1)[1]) if ';' in raw else f'Move {idx+1}')
      out.append({'const':re.sub('[^A-Z0-9]+','_',name.upper()).strip('_'),'name':name,'effect':disp(v[0]),'power':num(v[1]),'type':disp(v[2]),'category':disp(v[3]),'accuracy':num(v[4]),'pp':num(v[5]),'chance':num(v[6])})
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
  def sprites(self, mons):
    src=self.r/'gfx/pokemon'; dst=self.a/'pokemon'; dst.mkdir(parents=True,exist_ok=True)
    if not src.exists(): return
    dirs={re.sub('[^a-z0-9]','',p.name.lower()):p for p in src.iterdir() if p.is_dir()}
    for m in mons.values():
      d=dirs.get(re.sub('[^a-z0-9]','',m['const'].lower())) or dirs.get(re.sub('[^a-z0-9]','',m['name'].lower()))
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

  def wild(self):
    out=[]; root=self.r/'data/wild'
    if not root.exists(): return out
    for p in root.rglob('*.asm'):
      loc=disp(p.stem); tod='Any'
      for raw in txt(p).splitlines():
        l=strip(raw); lm=re.match(r'^([A-Za-z0-9_]+):',l)
        if lm: loc=disp(lm.group(1))
        q=l.lower()
        if 'morning' in q:tod='Morning'
        elif re.search(r'\bday\b',q):tod='Day'
        elif 'night' in q:tod='Night'
        m=re.search(r'(?:db|wildmon)\s+(\d+)\s*,\s*([A-Z0-9_]+)',l,re.I)
        if m: out.append({'location':loc,'time':tod,'level':int(m.group(1)),'pokemon':disp(m.group(2))})
    return out
  def badge(self,t): return f'<span class="badge type-{slug(t)}">{html.escape(t)}</span>' if t else '—'
  def nav(self,p=''): return f'<header><a class="brand" href="{p}index.html">◆ Crimson Crystal</a><nav><a href="{p}pokedex.html">Pokédex</a><a href="{p}moves.html">Moves</a><a href="{p}encounters.html">Encounters</a></nav></header>'
  def shell(self,title,body,p=''): return f'<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>{html.escape(title)} · Crimson Crystal</title><link rel="stylesheet" href="{p}assets/style.css"></head><body>{self.nav(p)}<main>{body}</main><footer>Crimson Crystal documentation generated from source</footer><script src="{p}assets/app.js"></script></body></html>'
  def card(self,m,p=''):
    im=f'<img src="{p}{m["sprite"]}" alt="{html.escape(m["name"])}">' if m['sprite'] else '<div class="placeholder">◆</div>'
    search=' '.join([m['name']]+m['types']+m['abilities']).lower()
    return f'<a class="card searchable" data-search="{html.escape(search)}" data-type="{" ".join(slug(x) for x in m["types"])}" href="{p}pokemon/{slug(m["name"])}.html"><small>#{m["number"]:03}</small>{im}<h3>{html.escape(m["name"])}</h3><div>{"".join(self.badge(x) for x in m["types"])}</div></a>'
  def attach_clone_forms(self, mons):
    clone_pairs={
      'BULBASAUR':'BULBASAUR_CLONE','IVYSAUR':'IVYSAUR_CLONE','VENUSAUR':'VENUSAUR_CLONE',
      'CHARMANDER':'CHARMANDER_CLONE','CHARMELEON':'CHARMELEON_CLONE','CHARIZARD':'CHARIZARD_CLONE',
      'SQUIRTLE':'SQUIRTLE_CLONE','WARTORTLE':'WARTORTLE_CLONE','BLASTOISE':'BLASTOISE_CLONE'}
    for base,clone in clone_pairs.items():
      if base in mons and clone in mons:
        mons[base]['forms']={'normal':mons[base], 'clone':mons[clone]}
    return set(clone_pairs.values())
  def render(self,mons,moves,wild):
    clone_consts=self.attach_clone_forms(mons)
    ms=sorted((m for c,m in mons.items() if c not in clone_consts),key=lambda x:x['number']); move_map={m['const']:m for m in moves}
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
      stats=''.join(f'<div class="stat"><span>{k}</span><i><b style="width:{min(100,v/2.55)}%"></b></i><strong>{v}</strong></div>' for k,v in m['stats'].items())
      learn=''.join(f'<div class="learn"><span>Lv. {x["level"]}</span><span>{html.escape(x["move"])}</span><span>{self.badge(move_map.get(x["const"],{}).get("type"))}</span></div>' for x in sorted(m['learnset'],key=lambda x:x['level']))
      sprite=f'<img class="big" src="../{m["sprite"]}">' if m['sprite'] else '<div class="big placeholder">◆</div>'
      toggle=''
      clone_panel=''
      if 'forms' in m:
        c=m['forms']['clone']
        csprite=f'<img class="big" src="../{c["sprite"]}">' if c.get('sprite') else '<div class="big placeholder">◆</div>'
        cstats=''.join(f'<div class="stat"><span>{k}</span><i><b style="width:{min(100,v/2.55)}%"></b></i><strong>{v}</strong></div>' for k,v in c['stats'].items())
        clearn=''.join(f'<div class="learn"><span>Lv. {x["level"]}</span><span>{html.escape(x["move"])}</span><span>{self.badge(move_map.get(x["const"],{}).get("type"))}</span></div>' for x in sorted(c['learnset'],key=lambda x:x['level']))
        toggle='<div class="form-toggle"><button class="active" data-form="normal">Normal</button><button data-form="clone">Clone</button></div>'
        clone_panel=f'<div class="form-view" data-form-view="clone" hidden><section class="monhero">{csprite}<div><p class="eyebrow">CLONE FORM</p><h1>{html.escape(m["name"])}</h1><div>{"".join(self.badge(t) for t in c["types"])}</div><p><b>Abilities:</b> {html.escape(", ".join(c["abilities"]) or "Not detected")}</p></div></section><div class="twocol"><section class="panel"><h2>Base stats <em>BST {sum(c["stats"].values())}</em></h2>{cstats or "<p>Not parsed.</p>"}</section><section class="panel"><h2>Evolution</h2><div class="chips">{"".join(f"<code>{html.escape(e)}</code>" for e in c["evolutions"]) or "None detected."}</div></section></div><section class="panel"><h2>Level-up learnset</h2><div class="learn header"><span>Level</span><span>Move</span><span>Type</span></div>{clearn or "<p>No moves detected.</p>"}</section></div>'
      normal=f'<div class="form-view" data-form-view="normal"><section class="monhero">{sprite}<div><p class="eyebrow">#{m["number"]:03}</p><h1>{html.escape(m["name"])}</h1><div>{"".join(self.badge(t) for t in m["types"])}</div><p><b>Abilities:</b> {html.escape(", ".join(m["abilities"]) or "Not detected")}</p></div></section><div class="twocol"><section class="panel"><h2>Base stats <em>BST {sum(m["stats"].values())}</em></h2>{stats or "<p>Not parsed.</p>"}</section><section class="panel"><h2>Evolution</h2><div class="chips">{"".join(f"<code>{html.escape(e)}</code>" for e in m["evolutions"]) or "None detected."}</div></section></div><section class="panel"><h2>Level-up learnset</h2><div class="learn header"><span>Level</span><span>Move</span><span>Type</span></div>{learn or "<p>No moves detected.</p>"}</section></div>'
      body=f'<a class="back" href="../pokedex.html">← Pokédex</a>{toggle}{normal}{clone_panel}'
      p=self.o/'pokemon'/f'{slug(m["name"])}.html';p.parent.mkdir(exist_ok=True);p.write_text(self.shell(m['name'],body,'../'))
    rows=''.join(f'<a class="row searchable" data-search="{html.escape((m["name"]+" "+m["type"]+" "+m["category"]).lower())}" href="moves/{slug(m["name"])}.html"><b>{html.escape(m["name"])}</b><span>{self.badge(m["type"])}</span><span>{m["category"]}</span><span>{m["power"] if m["power"] is not None else "—"}</span><span>{m["accuracy"] if m["accuracy"] is not None else "—"}</span><span>{m["pp"] if m["pp"] is not None else "—"}</span></a>' for m in moves)
    (self.o/'moves.html').write_text(self.shell('Moves',f'<section class="head"><p class="eyebrow">BATTLE DATA</p><h1>Moves</h1></section><div class="toolbar"><input id="tableSearch" placeholder="Search moves"></div><div class="table"><div class="row labels"><span>Move</span><span>Type</span><span>Category</span><span>Power</span><span>Accuracy</span><span>PP</span></div>{rows}</div>'))
    for m in moves:
      b=f'<a class="back" href="../moves.html">← Moves</a><section class="head"><p class="eyebrow">{m["type"]} MOVE</p><h1>{html.escape(m["name"])}</h1></section><section class="panel"><dl><div><dt>Type</dt><dd>{self.badge(m["type"])}</dd></div><div><dt>Category</dt><dd>{m["category"]}</dd></div><div><dt>Power</dt><dd>{m["power"]}</dd></div><div><dt>Accuracy</dt><dd>{m["accuracy"]}</dd></div><div><dt>PP</dt><dd>{m["pp"]}</dd></div><div><dt>Effect</dt><dd>{m["effect"]}</dd></div></dl></section>'
      p=self.o/'moves'/f'{slug(m["name"])}.html';p.parent.mkdir(exist_ok=True);p.write_text(self.shell(m['name'],b,'../'))
    er=''.join(f'<div class="erow searchable" data-search="{html.escape((e["location"]+" "+e["pokemon"]+" "+e["time"]).lower())}"><b>{html.escape(e["location"])}</b><span>{e["time"]}</span><span>{e["pokemon"]}</span><span>Lv. {e["level"]}</span></div>' for e in wild)
    (self.o/'encounters.html').write_text(self.shell('Encounters',f'<section class="head"><p class="eyebrow">WORLD DATA</p><h1>Wild encounters</h1></section><div class="toolbar"><input id="tableSearch" placeholder="Search locations or Pokémon"></div><div class="table"><div class="erow labels"><span>Location</span><span>Time</span><span>Pokémon</span><span>Level</span></div>{er or "<p class=empty>No supported encounter rows detected.</p>"}</div>'))
  def run(self):
    if self.o.exists(): shutil.rmtree(self.o)
    self.a.mkdir(parents=True); base=Path(__file__).parent/'static'; shutil.copy2(base/'style.css',self.a/'style.css'); shutil.copy2(base/'app.js',self.a/'app.js')
    order,names=self.species(); mons=self.base_stats(order,names); self.learnsets(mons); moves=self.moves(); self.sprites(mons); wild=self.wild(); self.render(mons,moves,wild)
    print(f'Generated {len(mons)} Pokémon, {len(moves)} moves, {len(wild)} encounter slots -> {self.o}')

def main():
  ap=argparse.ArgumentParser();ap.add_argument('repo',nargs='?',default='.');a=ap.parse_args();r=Path(a.repo).resolve()
  if not (r/'data').exists(): raise SystemExit('Run this against the repository root; data/ was not found.')
  Builder(r).run()
if __name__=='__main__':main()
