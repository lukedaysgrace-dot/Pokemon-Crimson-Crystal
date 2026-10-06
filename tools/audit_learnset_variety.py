#!/usr/bin/env python3
"""Validate approved movepool additions, source structure and tutor compatibility."""
from pathlib import Path
import json,re

ROOT=Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
def load_sources():
 species_text=read('constants/pokemon_constants.asm').split('const_def 1',1)[1].split('NUM_POKEMON',1)[0]
 order=re.findall(r'^\s*const\s+(\w+)',species_text,re.M)
 order=[c for c in order if c!='EGG']
 assert len(order)==495
 files=re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"',read('data/pokemon/base_stats.asm'))
 assert len(files)==len(order)
 tm={}
 for c,f in zip(order,files):
  m=re.search(r'^\s*tmhm([^\n]*)',read(f),re.M)
  tm[c]=[s.strip() for s in m[1].split(',') if s.strip()]
  assert len(tm[c])==len(set(tm[c])),(c,'duplicate compatibility')
 valid_tm=set(re.findall(r'^\s*add_(?:tm|hm|mt)\s+(\w+)',read('constants/item_constants.asm'),re.M))
 assert all(set(ms)<=valid_tm for ms in tm.values())
 attacks={}; tables={}
 for f in ['data/pokemon/evos_attacks_kanto.asm','data/pokemon/evos_attacks_johto.asm','data/pokemon/evos_attacks_clones.asm']:
  text=read(f)
  for m in re.finditer(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)',text,re.M|re.S):
   label,body=m.groups()
   rows=[(int(lv),move) for lv,move in re.findall(r'^\s*dbw\s+(\d+),\s*(\w+)',body,re.M)]
   edges=[]
   for line in body.splitlines():
    if re.match(r'^\s*db+b?w\s+EVOLVE_',line):edges.append(line.split(';')[0].split(',')[-1].strip())
   attacks[label]=(rows,edges)
  for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)',text,re.M):
   tables[m[1]]=re.findall(r'^\s*dw\s+(\w+)',m[2],re.M)
 sequence=[]
 for name in ['EvosAttacksPointers1','EvosAttacksPointers1C','EvosAttacksPointers1B','EvosAttacksPointers2','EvosAttacksPointers2D','EvosAttacksPointers2E','EvosAttacksPointers2B','EvosAttacksPointers2C']:sequence+=tables[name]
 assert len(sequence)==len(order)
 levels={c:attacks[label][0] for c,label in zip(order,sequence)}
 parents={c:[] for c in order}
 for c,label in zip(order,sequence):
  for child in attacks[label][1]:parents[child].append(c)
 roots=dict(zip(order,re.findall(r'^\s*dw\s+(\w+)',read('data/pokemon/first_stages.asm'),re.M)))
 assert len(roots)==len(order)
 pointers={};egg_lists={}
 for f in ['data/pokemon/egg_moves_kanto.asm','data/pokemon/egg_moves_johto.asm']:
  text=read(f)
  for label,c in re.findall(r'^\s*dw\s+(\w+)\s*;\s*(\w+)\s*$',text,re.M):pointers[c]=label
  for m in re.finditer(r'^(\w+EggMoves\d*|NoEggMoves\d+)::?\n(.*?)^\s*dw\s+-1',text,re.M|re.S):
   egg_lists[m[1]]=re.findall(r'^\s*dw\s+(\w+)\s*$',m[2],re.M)
 assert set(pointers)==set(order)
 eggs={c:egg_lists[pointers[roots[c]]] for c in order}
 utility={c:int(bits,2) for bits,c in re.findall(r'^\s*db\s+%([01]{8})\s*;\s*(\w+)',read('data/pokemon/utility_tutor.asm'),re.M)}
 assert list(utility)==order
 return order,levels,tm,eggs,parents,utility

def main():
 order,levels,tm,eggs,parents,utility=load_sources()
 moves=set(re.findall(r'^\s*move\s+.*?;\s*(\w+)\s*$',read('data/moves/moves.asm'),re.M))
 capacity=int(re.search(r'MOVE_TUTOR_LIST_CAPACITY EQU (\d+)',read('constants/wram_constants.asm'))[1])
 def ancestors(c,seen=None):
  seen=set() if seen is None else seen
  for p in parents[c]:
   if p not in seen:seen.add(p);ancestors(p,seen)
  return seen
 utility_moves=['SUBSTITUTE','SLEEP_TALK','REFLECT','LIGHT_SCREEN','THUNDER_WAVE']
 pools={}
 for c in order:
  ls=levels[c];ms=[m for lv,m in ls]
  assert [lv for lv,m in ls]==sorted(lv for lv,m in ls),(c,'out of order')
  assert all(1<=lv<=100 for lv,m in ls),(c,'invalid level')
  assert len(ms)==len(set(ms)) or (c=='SMEARGLE' and set(ms)=={'SKETCH'}),(c,'duplicate level-up move')
  assert len(set(ms))<=capacity,(c,'reminder capacity')
  assert len(eggs[c])<=capacity and len(eggs[c])==len(set(eggs[c])),(c,'egg capacity/duplicate')
  pool=set(ms+tm[c]+eggs[c])|{m for p in ancestors(c) for lv,m in levels[p]}
  if c in {'DRATINI','DRAGONAIR','DRAGONITE'}:pool.add('EXTREMESPEED')
  pool|={m for i,m in enumerate(utility_moves) if utility[c]&(1<<i)}
  assert pool<=moves,(c,pool-moves)
  pools[c]=pool
  if c.endswith('_CLONE'):
   original=c[:-6]
   assert levels[c]==levels[original] and tm[c]==tm[original] and eggs[c]==eggs[original] and utility[c]==utility[original],(c,'clone mismatch')
 for c in ['DITTO','WOBBUFFET','WYNAUT','SMEARGLE']:assert utility[c]==0,(c,'restricted identity')
 review=json.loads(read('tools/testdata/learnset_variety_review.json'))
 receipt=json.loads(read('tools/testdata/learnset_variety_implementation.json'))
 assignments=0
 for c,q in review['recommendations'].items():
  for x in q['choices']:
   assert x['move'] in pools[c],(c,x['move'],'approved addition unavailable')
   assignments+=1
 for c,ms in receipt['reminder_repairs'].items():
  for move,lv in ms.items():assert (lv,move) in levels[c],(c,move,'reminder repair missing')
 assert (32,'VOLT_SWITCH') in levels['RAICHU_ALOLAN'] and (76,'VOLT_SWITCH') not in levels['RAICHU_ALOLAN']
 assert (44,'BELLY_DRUM') in levels['MAGMAR'], 'Magby Belly Drum donor access'
 for c,ms in receipt['availability_restorations'].items():
  for move,lv in ms.items():assert (lv,move) in levels[c],(c,move,'move availability restoration')
 assert assignments==440==len(receipt['recommendations'])
 assert utility==receipt['utility_flags']
 # Preserve the review's original moves, allowing documented later curation.
 # The reviewed snapshot predates deliberate TM-slot replacements. Preserve
 # compatibility with their documented successors, not a removed TM name.
 replacements=receipt.get('tm_replacements',{})
 valid_tm=set(re.findall(r'^\s*add_(?:tm|hm|mt)\s+(\w+)',read('constants/item_constants.asm'),re.M))
 for old,new in replacements.items():
  assert old in moves and old not in valid_tm and new in valid_tm,(old,new,'invalid TM replacement')
 removals=receipt.get('level_up_removals',{})
 for c,removed in removals.items():
  assert c in review['roster'] and set(removed)<=set(review['roster'][c]['own']),(c,'invalid curated removal')
  assert not set(removed)&set(m for lv,m in levels[c]),(c,'curated removal restored')
 for c,row in review['roster'].items():
  assert set(row['own'])-set(removals.get(c,[]))<=set(m for lv,m in levels[c]),(c,'original level-up loss')
  expected={replacements.get(move,move) for move in row['tms']}
  assert expected<=set(tm[c]),(c,sorted(expected-set(tm[c])),'original compatibility loss')
 print(f'LEARNSET VARIETY AUDIT PASSED: {len(order)} entries, {assignments} approved additions, 9 clone mirrors, reminder/timing repairs and five utility compatibility columns.')
 print(f'Largest reminder list: {max(len(ls) for ls in levels.values())}/{capacity}; largest egg list: {max(len(ms) for ms in eggs.values())}/{capacity}.')
if __name__=='__main__':main()
