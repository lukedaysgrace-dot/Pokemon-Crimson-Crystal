"""Read-only emulator validation. Run with WSL Python/PyBoy, -B.

Uses a private in-memory cartridge; never saves the user's game or patches files.
"""
import hashlib
import json
import re
import sys
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from pc_harness import Harness
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches

def main():
    data=json.loads((HERE/'extracted.json').read_text())
    con=Constants()
    h=Harness(rom=str(ROOT/'pokecrystal.gbc'),sym=str(ROOT/'pokecrystal.sym'))
    h.boot()
    checks=[]
    def check(name,actual,expected):
        checks.append(dict(check=name,actual=actual,expected=expected,passed=actual==expected))
    def wr(name,v): h.wr(h.s(name),v)
    def rd(name): return h.rd(h.s(name))
    def val24(name): return int.from_bytes(h.rd(h.s(name),3),'big')
    try:
        flags=_parse_constants(ROOT/'constants/engine_flags.asm')
        h.call('EngineFlagAction',bc=1<<8,de=flags['ENGINE_HARD_MODE'])
        for n in range(17):
            wr('wJohtoBadges',(1<<min(n,8))-1)
            wr('wKantoBadges',(1<<max(n-8,0))-1)
            h.call('UpdateLevelCap')
            check(f'hard_cap_{n}',rd('wLevelCap'),data['caps'][n]['cap'] if n<16 else 100)
        h.call('EngineFlagAction',bc=0,de=flags['ENGINE_HARD_MODE'])
        wr('wJohtoBadges',0); wr('wKantoBadges',0)
        h.call('UpdateLevelCap'); check('normal_cap',rd('wLevelCap'),100)
        growth=[(1,1,0,0,0),(3,4,10,0,30),(3,4,20,0,70),(6,5,-15,100,140),(4,5,0,0,0),(5,4,0,0,0)]
        for rate,(a,b,c,d,e) in enumerate(growth):
            for level in range(1,101):
                wr('wBaseGrowthRate',rate)
                h.call('CalcExpAtLevel',de=level<<8)
                expected=0 if level==1 else (a*level**3//b+c*level**2+d*level-e)&0xffffff
                check(f'growth_{rate}_L{level}',val24('hMultiplicand'),expected)
        for hard in (0,1):
            h.call('EngineFlagAction',bc=hard<<8,de=flags['ENGINE_HARD_MODE'])
            for value in (1,3,35,100,255,1000,32767,40000,65535):
                h.wr(h.s('hProduct')+2,list(value.to_bytes(2,'big')))
                h.call('TrainerBoostExp')
                actual=int.from_bytes(h.rd(h.s('hProduct')+2,2),'big')
                expected=min(65535,2*value) if hard else (value+value//2)&65535
                check(f'trainer_boost_hard{hard}_{value}',actual,expected)
        # Base yield is divided before multiplication. Capped participants are
        # excluded from the divisor, but still get stat EXP in the outer routine.
        for cap in (10,62,100):
            for count in range(1,7):
                for capped in (0,1):
                    wr('wLevelCap',cap)
                    for i in range(6): wr(f'wPartyMon{i+1}Level',cap if capped and i==0 else cap-1)
                    wr('wBattleParticipantsNotFainted',(1<<count)-1)
                    size=h.s('wEnemyMonShinyGenderFlags')-h.s('wEnemyMonBaseStats')
                    h.wr(h.s('wEnemyMonBaseStats'),[127]*size)
                    h.call('GiveExperiencePoints.EvenlyDivideExpAmongParticipants')
                    divisor=max(1,count-capped)
                    check(f'participant_split_cap{cap}_n{count}_capped{capped}',rd('wEnemyMonBaseExp'),127//divisor)
        # Check every static party against the compiled cartridge, including
        # records not reachable in the campaign. CAL2 is external SRAM data.
        h.call('EngineFlagAction',bc=1<<8,de=flags['ENGINE_HARD_MODE'])
        wr('wLinkMode',0); wr('wInBattleTowerBattle',0)
        wr('wPartyCount',1); wr('wPartyMon1Level',5)
        verified=[]
        classes=list(data['class_group'])
        for p in data['parties'].values():
            cl=next(x for x in classes if data['class_group'][x]==p['group'])
            if cl=='CAL' and p['id']==2:
                verified.append(dict(party_key=p['key'],status='external_SRAM_record_not_comparable'))
                continue
            wr('wOtherTrainerClass',con.trainer_classes[cl]); wr('wOtherTrainerID',p['id'])
            h.call('ReadTrainerParty')
            mons=[]
            for i in range(rd('wOTPartyCount')):
                sp=h.species_index(h.rd(h.s('wOTPartySpecies')+i))
                name=next((k for k,v in con.species.items() if v==sp),'UNKNOWN')
                mons.append([name,rd(f'wOTPartyMon{i+1}Level')])
            expected=[[m['species'],m['level']] for m in p['mons']]
            check(f'party_{p["key"]}',mons,expected)
            verified.append(dict(party_key=p['key'],status='match' if mons==expected else 'MISMATCH',mons=mons))
        # Confirm all 498 base EXP / growth bytes in the cartridge.
        for sp,info in data['species'].items():
            sid=h.species_id(con.species[sp]); wr('wCurSpecies',sid)
            h.call('GetBaseData')
            check(f'base_exp_{sp}',rd('wBaseExp'),info['base_exp'])
            names=['GROWTH_MEDIUM_FAST','GROWTH_SLIGHTLY_FAST','GROWTH_SLIGHTLY_SLOW','GROWTH_MEDIUM_SLOW','GROWTH_FAST','GROWTH_SLOW']
            check(f'growth_id_{sp}',rd('wBaseGrowthRate'),names.index(info['growth']))
        # Execute the real EXP grant routine with presentation disabled in the
        # private ROM image. All cases stay below the next level threshold.
        # This checks the arithmetic in context, not merely helper routines.
        h.call('EngineFlagAction',bc=1<<8,de=flags['ENGINE_HARD_MODE'])
        wr('wJohtoBadges',255);wr('wKantoBadges',7) # 11 badges, cap 62
        wr('wDebugFlags',0);wr('wBattleMode',2);wr('wLinkMode',0);wr('wInBattleTowerBattle',0)
        wr('wPlayerID',[0x34,0x12]);wr('wCurBattleMon',0)
        sid=h.species_id(con.species['RATTATA'])
        from model import exp_at, exp_award
        with patches(h,{'BattleTextbox':b'\xc9','AnimateExpBar':b'\xc9'}):
            for count,capped,traded,lucky in [(1,0,False,False),(2,0,False,False),(6,0,False,False),(3,1,False,False),(1,0,True,True)]:
                wr('wPartyCount',count);wr('wPartySpecies',[sid]*count+[255]);wr('wBattleParticipantsNotFainted',(1<<count)-1)
                for i in range(count):
                    h.build_temp_mon(con.species['RATTATA'],[0,0,0,0],level=62 if i<capped else 40,item=con.items['LUCKY_EGG'] if lucky else 0,ot_id=0x9999 if traded else 0x1234,statexp=[0]*10)
                    stride=h.s('wPartyMon2')-h.s('wPartyMon1')
                    h.wr(h.s(f'wPartyMon{i+1}'),h.rd(h.s('wTempMon'),stride))
                    wr(f'wPartyMon{i+1}HP',[0,100]);wr(f'wPartyMon{i+1}Exp',list(exp_at(62 if i<capped else 40,'GROWTH_MEDIUM_FAST').to_bytes(3,'big')))
                size=h.s('wEnemyMonShinyGenderFlags')-h.s('wEnemyMonBaseStats')
                h.wr(h.s('wEnemyMonBaseStats'),[0]*size)
                wr('wEnemyMonBaseExp',127);wr('wEnemyMonLevel',10)
                h.call('GiveExperiencePoints')
                for i in range(count):
                    initial=exp_at(62 if i<capped else 40,'GROWTH_MEDIUM_FAST')
                    expected=initial if i<capped else initial+exp_award(127,10,count-capped,traded=traded,lucky=lucky)
                    check(f'actual_grant_n{count}_capped{capped}_trade{traded}_egg{lucky}_slot{i}',val24(f'wPartyMon{i+1}Exp'),expected)
        # Day Care deposits bank EXP even while CalcLevel returns the cap.
        wr('wJohtoBadges',0);wr('wKantoBadges',0);h.call('UpdateLevelCap')
        h.build_temp_mon(con.species['RATTATA'],[0,0,0,0],level=10,statexp=[0]*10)
        h.wr(h.s('wBreedMon1Stats'),h.rd(h.s('wTempMon'),34))
        wr('wBreedMon1Level',10);wr('wBreedMon1Exp',list((exp_at(16,'GROWTH_MEDIUM_FAST')+7).to_bytes(3,'big')))
        bit=int(re.search(r'^DAYCAREMAN_HAS_MON_F\s+EQU (\d+)',(ROOT/'constants/wram_constants.asm').read_text(),re.M)[1])
        wr('wDayCareMan',1<<bit);wr('wDayCareLady',0)
        h.call('DayCareStep')
        check('daycare_banks_above_cap',val24('wBreedMon1Exp'),exp_at(16,'GROWTH_MEDIUM_FAST')+8)
        result=h.call('GetBreedMon1LevelGrowth');check('daycare_level_clamped',result['e'],10)
        wr('wJohtoBadges',1);h.call('UpdateLevelCap')
        result=h.call('GetBreedMon1LevelGrowth');check('daycare_banked_exp_available_at_next_cap',result['e'],16)
        # New catches are initialized at the encountered level, above the cap
        # if necessary. The cap controls gains, not the level of acquired mons.
        wr('wPartyCount',0);wr('wMonType',0);wr('wBattleMode',1)
        wr('wCurPartySpecies',sid);wr('wCurPartyLevel',30)
        wr('wEnemyMonHP',[0,100]);wr('wEnemyMonMaxHP',[0,100])
        h.call('TryAddMonToParty')
        check('caught_mon_preserves_overcap_level',rd('wPartyMon1Level'),30)
        check('caught_mon_preserves_overcap_exp',val24('wPartyMon1Exp'),exp_at(30,'GROWTH_MEDIUM_FAST'))
        # Native script evidence for the early Ecruteak difficulty hazard.
        # No battle, movement, sound, or text UI runs: actual event tests and
        # loadtrainer execute, then we stop immediately before startbattle.
        events=_parse_constants(ROOT/'constants/event_flags.asm')
        for event in ['EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY','EVENT_FOUGHT_SUICUNE']:
            h.call('EventFlagAction',bc=0,de=events[event])
        wr('wJohtoBadges',7);wr('wKantoBadges',0);h.call('UpdateLevelCap')
        byte=h.s('GetScriptByte')
        consume=lambda n:bytes([0xcd,byte&255,byte>>8])*n+b'\xc9'
        presentation={name:consume(n) for name,n in [('Script_applymovement',3),('Script_turnobject',2),('Script_special',2),('Script_pause',1),('Script_showemote',3),('Script_playmusic',2),('Script_appear',1)]}
        presentation.update({name:b'\xc9' for name in ['Script_opentext','Script_waitbutton','Script_closetext','MapTextbox','PrintText']})
        with patches(h,presentation):
            bank,addr=h.sym['EcruteakCityEusineTrigger']
            wr('wScriptBank',bank);h.wr16(h.s('wScriptPos'),addr);wr('wScriptStackSize',0);wr('wScriptMode',1)
            reached=False
            for _ in range(80):
                bank=rd('wScriptBank');addr=h.rd16(h.s('wScriptPos'))
                if h.mem[bank,addr]==0x5f:reached=True;break
                h.call('RunScriptCommand')
                if rd('wScriptMode')==0:break
            check('early_eusine_battle_reachable_at_three_badges',reached,True)
            check('early_eusine_cap',rd('wLevelCap'),25)
            check('early_eusine_party_id',rd('wOtherTrainerID'),2)
            check('early_eusine_class',rd('wOtherTrainerClass'),con.trainer_classes['MYSTICALMAN'])
        result=dict(check_count=len(checks),failures=[c for c in checks if not c['passed']],rom_sha256=hashlib.sha256((ROOT/'pokecrystal.gbc').read_bytes()).hexdigest(),checks=checks,parties=verified)
        (HERE/'native_verification.json').write_text(json.dumps(result,indent=2))
        print(json.dumps({k:v for k,v in result.items() if k not in ['checks','parties']},indent=2))
        return bool(result['failures'])
    finally:
        h.pyboy.stop(save=False)

if __name__=='__main__': raise SystemExit(main())
