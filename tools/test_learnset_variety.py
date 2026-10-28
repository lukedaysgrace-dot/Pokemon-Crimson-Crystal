#!/usr/bin/env python3
"""Run compiled tutor, reminder, compatibility and inheritance checks with PyBoy.

Usage: python tools/test_learnset_variety.py path/to/pokecrystal.gbc
Uses a private in-memory cartridge; no player save or ROM is modified.
"""
from pathlib import Path
import json,sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
sys.path.insert(0,str(ROOT/'tools/battletest'))
from pc_harness import Harness
from symbols import Constants
from audit_learnset_variety import load_sources, load_technical_tutors

rom=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'pokecrystal.gbc'
h=Harness(rom=str(rom),sym=str(rom.with_suffix('.sym')))
h.boot()
con=Constants()
order,levels,tms,eggs,parents,flags=load_sources()
utility=['SUBSTITUTE','SLEEP_TALK','REFLECT','LIGHT_SCREEN','THUNDER_WAVE']
technical=load_technical_tutors()
checks=0
def check(condition,message):
 global checks
 checks+=1
 if not condition:raise AssertionError(message)
def party(c,lv=100,known=()):
 h.wr(h.s('wPartyCount'),1)
 h.wr(h.s('wCurPartyMon'),0)
 h.wr(h.s('wPartyMon1Moves'),[0]*4)
 sid=h.species_id(con.species_index(c))
 h.wr(h.s('wPartySpecies'),[sid,255])
 h.wr(h.s('wPartyMon1Species'),sid)
 h.wr(h.s('wPartyMon1Level'),lv)
 mids=[h.move_id(con.move_index(m)) for m in known]
 h.wr(h.s('wPartyMon1Moves'),mids+[0]*(4-len(mids)))
 h.wr(h.s('wCurPartySpecies'),sid)
 return sid
def menu(routine):
 guard=h.s('wMoveReminderMoveListEnd')
 h.wr(guard,0xa5)
 result=h.call(routine)
 base=h.s('wMoveReminderMoveList');n=h.rd(base)
 data=h.rd(base+1,2*n+2)
 check(data[-2:]==b'\xff\x00',routine+' list terminator')
 entries=[con.moves_by_index[(data[2*i]<<8)|data[2*i+1]] for i in range(n)]
 check(len(set(entries))==n,routine+' list duplicates')
 check(result['z']==(n==0),routine+' empty flag')
 check(h.rd(guard)==0xa5,routine+' scratch-buffer overflow')
 return entries

try:
 # Exhaustive table lookup exercises all runtime species IDs, including >255.
 for c in order:
  party(c)
  expected=[m for i,m in enumerate(utility) if flags[c]&(1<<i)]
  check(menu('UtilityMoveTutor_GetTeachableMoves')==expected,c+' utility compatibility')
 for c,known in [('GRIMMSNARL',('REFLECT','LIGHT_SCREEN','THUNDER_WAVE')),('SYLVEON',('SUBSTITUTE',)),('MEW',tuple(utility[:4]))]:
  party(c,known=known)
  expected=[m for i,m in enumerate(utility) if flags[c]&(1<<i) and m not in known]
  check(menu('UtilityMoveTutor_GetTeachableMoves')==expected,c+' known moves omitted')
 print('Utility tutor: all species retain only their original five-move compatibility and known-move filtering.',flush=True)

 for c,level in [('ARON',32),('LAIRON',38),('AGGRON',44)]:
  party(c,level-1)
  check('BODY_PRESS' not in menu('UtilityMoveTutor_GetTeachableMoves'),c+' Body Press leaked into Goldenrod tutor')
  for lv,wanted in [(level-1,False),(level,True)]:
   party(c,lv)
   # Pre-evolutions can legitimately supply Body Press earlier on evolved
   # forms. Inspect the exact current-species placement separately below.
   actual=menu('MoveReminder_GetRemindableMoves')
   if c=='ARON':check(('BODY_PRESS' in actual)==wanted,c+' Body Press unlock timing')
  check((level,'BODY_PRESS') in levels[c],c+' direct Body Press level')

 # Full current-form lists must not truncate or confuse 16-bit move indices.
 for c in order:
  party(c)
  def reminder_moves(species):
   return [m for lv,m in levels[species]]+[m for p in parents[species] for m in reminder_moves(p)]
  expected=list(dict.fromkeys(reminder_moves(c)))
  check(menu('MoveReminder_GetRemindableMoves')==expected,c+' reminder level-100 list')
 for c,lv,wanted in [('RAICHU_ALOLAN',31,'VOLT_SWITCH'),('RAICHU_ALOLAN',32,'VOLT_SWITCH'),('URSALUNABM',36,'HYPER_VOICE'),('ELECTIVIRE',1,'MACH_PUNCH'),('FLAPPLE',36,'RECOVER'),('XATU',20,'REFLECT')]:
  party(c,lv)
  result=menu('MoveReminder_GetRemindableMoves')
  check((wanted in result)==(c!='RAICHU_ALOLAN' or lv>=32),c+' reminder timing '+wanted)
 print('Move Reminder: every species plus timing/recovery/priority repairs passed.',flush=True)

 # A delayed move must not leak through an ancestor's earlier reminder row.
 for c,move,gate in [('FERALIGATR','SWORDS_DANCE',38),('FERALIGATR','LIQUIDATION',40),
                     ('BLASTOISE','SHELL_SMASH',36),('CARRACOSTA','SHELL_SMASH',38),
                     ('FLAREON','CLOSE_COMBAT',44),('FLAREON','SUPERPOWER',48)]:
  for lv in [gate-1,gate]:
   party(c,lv)
   check((move in menu('MoveReminder_GetRemindableMoves'))==(lv==gate),f'{c} {move} reminder gate at {lv}')

 # Blackthorn combines the family's egg list with only this selected species'
 # fallback list. Exhaust all species, including indices >255 and clone forms.
 for c in order:
  sid=party(c)
  expected=list(dict.fromkeys(eggs[c]+technical[c]))
  check(menu('EggMoveTutor_GetTeachableMoves')==expected,c+' Blackthorn compatibility')
  check(h.rd(h.s('wCurPartySpecies'))==sid,c+' Blackthorn changed selected species')
 for c in ['MEW','AGGRON','RAICHU_ALOLAN','BLASTOISE_CLONE']:
  expected=list(dict.fromkeys(eggs[c]+technical[c]))
  known=tuple(expected[:4])
  party(c,lv=1,known=known)
  check(menu('EggMoveTutor_GetTeachableMoves')==[m for m in expected if m not in known],c+' Blackthorn known-move filtering')
 party('MEW')
 long_list=menu('EggMoveTutor_GetTeachableMoves')
 check(len(long_list)>128,'Mew must exercise Blackthorn offsets over 128')
 h.wr(h.s('wMenuData_ItemsPointerAddr'),[h.s('wMoveReminderMoveList')&255,h.s('wMoveReminderMoveList')>>8])
 h.wr(h.s('wMenuData_ItemsPointerBank'),0)
 h.wr(h.s('wMenuData_ScrollingMenuItemFormat'),2)
 for offset in [0,127,128,len(long_list)-1]:
  h.wr(h.s('wMenuScrollPosition'),offset)
  h.call('ScrollingMenu_GetListItemCoordAndFunctionArgs',a=0)
  actual=(h.rd(h.s('wMenuSelection'))<<8)|h.rd(h.s('wMenuSelectionQuantity'))
  check(actual==con.move_index(long_list[offset]),f'Blackthorn scrolling entry {offset}')
 print('Blackthorn tutor: all species, known-move filtering and scrolling beyond 128 entries passed.',flush=True)

 receipt=json.loads((ROOT/'tools/testdata/learnset_variety_implementation.json').read_text())
 for c,row in receipt['tm_changes'].items():
  sid=party(c)
  for move in set(row['after'])-set(row['before']):
   if move not in tms[c]:continue # Superseded unsupported TM-slot assignments.
   mid=h.move_id(con.move_index(move))
   h.wr(h.s('wCurPartySpecies'),sid)
   h.wr(h.s('wPutativeTMHMMove'),mid)
   check(h.call('CanLearnTMHMMove')['c']!=0,c+' compatibility '+move)
 from historical_move_access import review as historical_review
 for c,moves in historical_review().get('changes',{}).get('tmhm_removals',{}).items():
  sid=party(c)
  for move in moves:
   h.wr(h.s('wCurPartySpecies'),sid)
   h.wr(h.s('wPutativeTMHMMove'),h.move_id(con.move_index(move)))
   check(h.call('CanLearnTMHMMove')['c']==0,c+' removed unsupported compatibility '+move)
 canonical=json.loads((ROOT/'tools/testdata/canonical_learnsets.json').read_text())
 for c,moves in canonical['changes']['tmhm'].items():
  sid=party(c)
  for move in moves:
   mid=h.move_id(con.move_index(move))
   h.wr(h.s('wCurPartySpecies'),sid)
   h.wr(h.s('wPutativeTMHMMove'),mid)
   check(h.call('CanLearnTMHMMove')['c']!=0,c+' canonical compatibility '+move)
 restoration_path=ROOT/'tools/testdata/authored_move_restorations.json'
 if restoration_path.exists():
  restorations=json.loads(restoration_path.read_text())
  for c,moves in restorations['tmhm'].items():
   sid=party(c)
   for move in moves:
    h.wr(h.s('wCurPartySpecies'),sid)
    h.wr(h.s('wPutativeTMHMMove'),h.move_id(con.move_index(move)))
    check(h.call('CanLearnTMHMMove')['c']!=0,c+' restored compatibility '+move)
 print('Family tutors and every added TM/elemental tutor flag passed.',flush=True)

 # Exercise the actual 16-bit egg-list inheritance scan, not only the tutor.
 # Father/other-parent move pointers are selected exactly as normal breeding.
 for hatchling,mother,father,move in [('GROWLITHE','ARCANINE','ESPEON','MORNING_SUN'),('MAGBY','MAGMAR','MAGMAR','BELLY_DRUM'),('MAGBY','MAGMAR','HITMONCHAN','MACH_PUNCH'),('GIRAFARIG','GIRAFARIG','GARDEVOIR','WISH'),('SQUIRTLE','WARTORTLE','GOLDUCK','FLIP_TURN'),('ONIX','ONIX','GOLEM','HEAD_SMASH'),('TANGELA','TANGELA','BULBASAUR','LEECH_SEED'),('MAREEP','AMPHAROS','RAICHU','AGILITY'),('SPINARAK','ARIADOS','CENTISKORCH','LUNGE'),('ARON','AGGRON','RHYPERIOR','HEAD_SMASH'),('ARON','AGGRON','NIDOKING','SUPERPOWER'),('ARON','AGGRON','LICKITUNG','STOMP')]:
  mom=party(mother,known=())
  dad=h.species_id(con.species_index(father));mid=h.move_id(con.move_index(move))
  h.wr(h.s('wBreedMotherOrNonDitto'),0)
  h.wr(h.s('wBreedMon1Species'),mom)
  h.wr(h.s('wBreedMon2Species'),dad)
  h.wr(h.s('wBreedMon1Moves'),[0,0,0,0])
  h.wr(h.s('wBreedMon2Moves'),[mid,0,0,0])
  h.wr(h.s('wBreedMon1PokerusStatus'),0)
  h.wr(h.s('wBreedMon2PokerusStatus'),0x40)
  h.call('CheckBreedmonCompatibility')
  check(h.rd(h.s('wBreedingCompatibility'))>0,mother+' / '+father+' compatible breeding pair')
  baby=h.species_id(con.species_index(hatchling))
  h.wr(h.s('wEggMonSpecies'),baby)
  h.wr(h.s('wCurPartySpecies'),baby)
  h.wr(h.s('wEggMonMoves'),[0,0,0,0])
  h.call('InitEggMoves')
  check(h.rd(h.s('wEggMonMoves'))==mid,hatchling+' actual egg inheritance '+move)
 print(f'LEARNSET ROM TESTS PASSED: {checks} checks, {h.calls} routine calls.',flush=True)
finally:
 h.pyboy.stop(save=False)
