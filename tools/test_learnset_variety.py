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
from audit_learnset_variety import load_sources

rom=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'pokecrystal.gbc'
h=Harness(rom=str(rom),sym=str(rom.with_suffix('.sym')))
h.boot()
con=Constants()
order,levels,tms,eggs,parents,flags=load_sources()
utility=['SUBSTITUTE','SLEEP_TALK','REFLECT','LIGHT_SCREEN','THUNDER_WAVE']
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
 result=h.call(routine)
 base=h.s('wMoveReminderMoveList');n=h.rd(base)
 data=h.rd(base+1,2*n+2)
 check(data[-2:]==b'\xff\x00',routine+' list terminator')
 entries=[con.moves_by_index[(data[2*i]<<8)|data[2*i+1]] for i in range(n)]
 check(len(set(entries))==n,routine+' list duplicates')
 check(result['z']==(n==0),routine+' empty flag')
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
 print('Utility tutor: every species, restricted identities and known-move filtering passed.',flush=True)

 # Full current-form lists must not truncate or confuse 16-bit move indices.
 for c in order:
  party(c)
  expected=list(dict.fromkeys(m for lv,m in levels[c]))
  check(menu('MoveReminder_GetRemindableMoves')==expected,c+' reminder level-100 list')
 for c,lv,wanted in [('RAICHU_ALOLAN',31,'VOLT_SWITCH'),('RAICHU_ALOLAN',32,'VOLT_SWITCH'),('URSALUNABM',36,'HYPER_VOICE'),('ELECTIVIRE',1,'MACH_PUNCH'),('FLAPPLE',36,'RECOVER'),('XATU',20,'REFLECT')]:
  party(c,lv)
  result=menu('MoveReminder_GetRemindableMoves')
  check((wanted in result)==(c!='RAICHU_ALOLAN' or lv>=32),c+' reminder timing '+wanted)
 print('Move Reminder: every species plus timing/recovery/priority repairs passed.',flush=True)

 # Family mapping must select the root list on evolved, regional and clone forms.
 for c in ['BLASTOISE','BLASTOISE_CLONE','LANTURN','VIKAVOLT','CHARJABUG','GRIMMSNARL','SYLVEON','GLACEON','FLYGON','BANETTE','ARCANINE','TANGROWTH','MAGMAR','MAGMORTAR','ONIX','FARIGIRAF']:
  party(c)
  check(menu('EggMoveTutor_GetTeachableMoves')==eggs[c],c+' family tutor')

 receipt=json.loads((ROOT/'tools/testdata/learnset_variety_implementation.json').read_text())
 for c,row in receipt['tm_changes'].items():
  sid=party(c)
  for move in set(row['after'])-set(row['before']):
   mid=h.move_id(con.move_index(move))
   h.wr(h.s('wCurPartySpecies'),sid)
   h.wr(h.s('wPutativeTMHMMove'),mid)
   check(h.call('CanLearnTMHMMove')['c']!=0,c+' compatibility '+move)
 print('Family tutors and every added TM/elemental tutor flag passed.',flush=True)

 # Exercise the actual 16-bit egg-list inheritance scan, not only the tutor.
 # Father/other-parent move pointers are selected exactly as normal breeding.
 for hatchling,mother,father,move in [('GROWLITHE','ARCANINE','ESPEON','MORNING_SUN'),('MAGBY','MAGMAR','MAGMAR','BELLY_DRUM'),('MAGBY','MAGMAR','HITMONCHAN','MACH_PUNCH'),('GIRAFARIG','GIRAFARIG','GARDEVOIR','WISH'),('SQUIRTLE','WARTORTLE','GOLDUCK','FLIP_TURN'),('ONIX','ONIX','GOLEM','HEAD_SMASH'),('TANGELA','TANGELA','BULBASAUR','LEECH_SEED'),('MAREEP','AMPHAROS','RAICHU','AGILITY'),('SPINARAK','ARIADOS','CENTISKORCH','LUNGE')]:
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
