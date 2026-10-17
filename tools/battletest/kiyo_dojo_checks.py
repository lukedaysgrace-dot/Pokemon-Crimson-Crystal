#!/usr/bin/env python3
"""Native dojo trainer approaches, Karate King class, reward and pass triggers.

Uses a private New Game and staged test party. Buttons execute the trainer
approaches, actual battles, item reward, repeat conversations and pickups.
"""
import io

from gameplay_rules_checks import new_game
from overworld_controls import Controls
from probability_checks import call
from runner import Harness
from safari_ui_checks import map_ids
from save_menu_checks import begin_native_call
from state import Request
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    h=Harness()
    pb,m=h.pb,h.battle.mem
    c=Controls(h)
    flags=_parse_constants(ROOT / 'constants/event_flags.asm')
    fields=_parse_constants(ROOT / 'constants/map_object_constants.asm')
    sprites=_parse_constants(ROOT / 'constants/sprite_constants.asm')
    output=ROOT / '.tmpbuild/kiyo-dojo'
    output.mkdir(parents=True,exist_ok=True)
    checks=0
    starts=[]
    portrait=False
    band=h.con.item_id('CHOICE_BAND')

    def check(ok,message):
        nonlocal checks
        assert ok,message
        checks+=1

    def event(name,value=None):
        flag=flags[name]
        if value is None:
            return bool(m.read('wEventFlags',flag//8) & (1<<(flag%8)))
        call(h,'EventFlagAction',B=int(value),D=flag>>8,E=flag&255)

    def quantity(item=band):
        return sum(m.read('wItems',i*2+1) for i in range(m.read('wNumItems')) if m.read('wItems',i*2)==item)

    def obj(index):
        return next((o for o in c.objects() if o['map_object']==index),None)

    def enter(x,y,mapname='FIGHTING_DOJO'):
        group,number=map_ids()[mapname]
        for name,value in [('wMapGroup',group),('wMapNumber',number),('wXCoord',x),('wYCoord',y),('hMapEntryMethod',0xf1)]:
            m.write(name,value)
        begin_native_call(h,'OverworldLoop')
        h.tick(180)
        check(c.map_id()==(group,number),'Map entry failed: '+mapname)

    def dialogue():
        for _ in range(180):
            if not m.read('wScriptMode') and m.read('wMapStatus')==2:
                return
            c.press('a',hold=4,wait=24)
        raise AssertionError('Dialogue did not finish: '+tile_text(h))

    def until_battle():
        nonlocal portrait
        for _ in range(220):
            text=tile_text(h)
            if not portrait and m.read('wBattleMode') and 'KARATE KING' in text and 'KIYO' in text:
                h.tick(30)
                pb.screen.image.resize((640,576)).save(output / 'karate-king-intro.png')
                portrait=True
            if m.read('wBattleMode') and 'FIGHT' in text:
                return
            c.press('a',hold=4,wait=24)
        pb.screen.image.resize((640,576)).save(output / 'battle-failure.png')
        raise AssertionError('No battle menu: '+str((c.position(),c.objects(),m.read('wScriptMode'),
            m.read('wBattleMode'),m.read('wOtherTrainerClass'),m.read('wOtherTrainerID'),
            m.read('wScriptBank'),list(m.read_bytes('wScriptPos',2)),pb.register_file.PC))+' '+tile_text(h))

    def roster(trainer,trainer_id,team):
        check(m.read('wOtherTrainerClass')==h.con.trainer_classes[trainer]
              and m.read('wOtherTrainerID')==trainer_id,'Wrong trainer class/ID')
        check(m.read('wOTPartyCount')==len(team),'Wrong team size')
        for slot,(species,level,ability) in enumerate(team,1):
            check(m.species_index_of(m.read(f'wOTPartyMon{slot}Species'))==h.con.species_index(species)
                  and m.read(f'wOTPartyMon{slot}Level')==level,'Wrong species/level: '+species)
            check(m.read(f'wOTPartyMon{slot}Personality')&0x60==ability,'Wrong ability slot: '+species)
            check(0 not in m.read_bytes(f'wOTPartyMon{slot}Moves',4),'Missing moves: '+species)

    kiyo=[('SIRFETCH_D',67,0x40),('SNEASLER',67,0x60),('BRELOOM',68,0x20),
          ('SCRAFTY',68,0x60),('HITMONTOP',70,0x20)]
    try:
        new_game(h,0)
        m.write('wPartyCount',0)
        m.write('wMonType',0)
        request=Request(h.battle)
        address=h.sym.addr('wDebugPlayer1')
        for slot,species in enumerate(('MEW','MEWTWO','TOGEKISS')):
            m.write_bytes('wDebugPlayer1',request._side_bytes(dict(species=species,level=100,
                ability=h.con.species_abilities[species][0],item='EXPERT_BELT',
                moves=['PSYCHIC_M','AERIAL_ACE','FLAMETHROWER','AURA_SPHERE'])))
            call(h,'DebugBuildPartyMon',B=slot,D=address>>8,E=address&255)
        for name in ('wDebugState','hDebugActive','hDebugRNGMode','wLinkMode'):
            m.write(name,0)
        m.write('wDefaultSpawnpoint',255)
        m.write('wOptions',0xc1)
        prepared=io.BytesIO()
        pb.save_state(prepared)
        pb.hook_register(*h.sym['Script_startbattle'],lambda _: starts.append((m.read('wOtherTrainerClass'),m.read('wOtherTrainerID'))),None)

        enter(16,5,'MOUNT_MORTAR_B1F')
        check(all(m.read(f'wMap{i}Object',fields['MAPOBJECT_SPRITE'])!=sprites['SPRITE_BLACK_BELT']
                  for i in range(1,7)),'Kiyo still occupies Mt. Mortar')
        enter(5,8)
        check({(i,(m.read(f'wMap{i}Object',fields['MAPOBJECT_X_COORD'])-4,
                   m.read(f'wMap{i}Object',fields['MAPOBJECT_Y_COORD'])-4)) for i in range(1,5)}
              == {(1,(4,3)),(2,(3,1)),(3,(3,7)),(4,(6,5))},'Dojo objects are misplaced')
        for index,direction in ((3,'RIGHT'),(4,'LEFT')):
            check(m.read(f'wMap{index}Object',fields['MAPOBJECT_MOVEMENT'])
                  ==fields['SPRITEMOVEDATA_STANDING_'+direction],'Student faces the wrong way')

        c.press('up',hold=12,wait=36)
        until_battle()
        roster('BLACKBELT_T',10,[('PRIMEAPE',61,0x60),('BRELOOM',62,0x20),('HITMONLEE',63,0x20)])
        check(obj(3)['position']==[4,7],'Riku did not walk forward from (3,7)')
        c.battle()
        dialogue()
        check(event('EVENT_BEAT_DOJO_RIKU'),'Riku victory not saved')
        call(h,'HealParty')
        enter(4,6)
        c.press('up',hold=12,wait=36)
        until_battle()
        roster('BLACKBELT_T',11,[('POLIWRATH',62,0x60),('HERACROSS',62,0x60),('HITMONCHAN',63,0x20)])
        check(obj(4)['position']==[5,5],'Masaru did not walk forward from (6,5)')
        c.battle()
        dialogue()
        check(event('EVENT_BEAT_DOJO_MASARU'),'Masaru victory not saved')

        call(h,'HealParty')
        enter(4,4)
        bank,address=h.sym['ItemAttributes']
        excluded={h.con.item_id(n) for n in ('CHOICE_BAND','POTION','SUPER_POTION','HYPER_POTION','MAX_POTION','FULL_RESTORE')}
        stock=[i for i in range(1,194) if i not in excluded and pb.memory[bank,address+(i-1)*7+5]==1][:40]
        m.write('wNumItems',40)
        m.write_bytes('wItems',bytes(v for i in stock for v in (i,1))+b'\xff')
        c.press('up',hold=4,wait=24)
        c.press('a',hold=4,wait=24)
        until_battle()
        roster('KARATE_KING',1,kiyo)
        for slot,item in enumerate(('STICK','LIFE_ORB','FOCUS_SASH','LEFTOVERS','WIDE_LENS'),1):
            check(m.read(f'wOTPartyMon{slot}Item')==h.con.item_id(item),'Wrong Kiyo held item: '+item)
        for slot,expected in ((1,('CLOSE_COMBAT','BRAVE_BIRD','LEAF_BLADE','NIGHT_SLASH')),
                              (2,('FAKE_OUT','DIRE_CLAW','CLOSE_COMBAT','TRIPLE_AXEL')),
                              (3,('SPORE','BULLET_SEED','MACH_PUNCH','ROCK_TOMB')),
                              (4,('DRAGON_DANCE','DRAIN_PUNCH','KNOCK_OFF','ICE_PUNCH')),
                              (5,('TRIPLE_KICK','TRIPLE_AXEL','MACH_PUNCH','BULLET_PUNCH'))):
            actual=[h.con.moves_by_index[m.move_index_of(value)] for value in m.read_bytes(f'wOTPartyMon{slot}Moves',4)]
            check(actual==list(expected),'Wrong Kiyo moveset: '+str(actual))
        pointer_bank,pointer_addr=h.sym['TrainerPicPointers']
        king=h.con.trainer_classes['KARATE_KING']
        blackbelt=h.con.trainer_classes['BLACKBELT_T']
        check(bytes(pb.memory[pointer_bank,pointer_addr+(king-1)*3:pointer_addr+king*3])
              ==bytes(pb.memory[pointer_bank,pointer_addr+(blackbelt-1)*3:pointer_addr+blackbelt*3]),
              'Karate King does not share the Black Belt battle portrait')
        c.battle()
        dialogue()
        check(event('EVENT_BEAT_DOJO_KIYO') and not event('EVENT_GOT_CHOICE_BAND_FROM_KIYO') and not quantity(),
              'Full Bag loses reward or battle victory')
        m.write('wNumItems',0)
        m.write_bytes('wItems',b'\xff')
        before=len(starts)
        c.press('a',hold=4,wait=24)
        dialogue()
        check(quantity()==1 and event('EVENT_GOT_CHOICE_BAND_FROM_KIYO') and len(starts)==before,
              'Reward retry requires another battle or fails to give one Choice Band')
        c.press('a',hold=4,wait=24)
        dialogue()
        check(quantity()==1 and len(starts)==before,'Repeat talk duplicates reward or rematches')
        c.go((5,4))
        c.press('up',hold=12,wait=36)
        check(not m.read('wScriptMode') and len(starts)==before,'Kiyo blocks passage after defeat')
        c.go((4,1))
        c.press('left',hold=4,wait=24)
        c.press('a',hold=4,wait=24)
        dialogue()
        check(quantity(h.con.item_id('FOCUS_BAND'))==1 and event('EVENT_PICKED_UP_FOCUS_BAND'),
              'Existing Focus Band pickup was lost or inaccessible')
        enter(4,4)
        c.press('up',hold=4,wait=24)
        c.press('a',hold=4,wait=24)
        dialogue()
        check(quantity()==1 and len(starts)==before,'Map re-entry resets Kiyo reward')
        print('PASS dojo student approaches, real battles, Karate King class and full-Bag reward retry',flush=True)

        # Every path past Kiyo must start his new battle, even on a save that
        # already defeated the old Black Belt in Mt. Mortar and got Tyrogue.
        for x in (0,1,2,5,7,8,9):
            prepared.seek(0)
            pb.load_state(prepared)
            event('EVENT_BEAT_BLACKBELT_KIYO',True)
            event('EVENT_GOT_TYROGUE_FROM_KIYO',True)
            enter(x,4)
            c.press('up',hold=12,wait=36)
            until_battle()
            check(c.position()==(x,3) and m.read('wOtherTrainerClass')==king
                  and m.read('wOtherTrainerID')==1 and m.read('wOTPartyCount')==5,
                  f'Pass trigger {x},3 does not start Karate King Kiyo battle')
            if x==5:
                c.battle()
                dialogue()
                check(event('EVENT_BEAT_DOJO_KIYO') and event('EVENT_GOT_CHOICE_BAND_FROM_KIYO') and quantity()==1,
                      'Pass-triggered victory does not award Choice Band')
            else:
                check(not quantity() and not event('EVENT_BEAT_DOJO_KIYO'),'Reward given before winning')
        check(king==104 and h.con.trainer_classes['CUEBALL']==103,'Existing trainer class IDs shifted')
        check(portrait,'Karate King Kiyo battle introduction did not render')
        check(h.sym.addr('wCurBox')==0xdbb9,'Save layout shifted')
        print(f'KIYO DOJO: {checks} checks passed',flush=True)
    finally:
        pb.stop(save=False)


if __name__=='__main__':
    main()
