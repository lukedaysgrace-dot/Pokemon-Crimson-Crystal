#!/usr/bin/env python3
"""Restored Firebreathers: real map triggers, battles, ashes and re-entry.

Only initial location, story progress and a strong test party are staged in
private emulator state. Buttons drive the approach, dialogue and battles.
Player saves are never opened. Run after make debug.
"""
import json
from runner import Harness
from state import Request
from probability_checks import call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import ROOT, _parse_constants
from ui_checks import tile_text


def main():
    h=Harness()
    m,c=h.battle.mem,Controls(h)
    events=_parse_constants(ROOT/'constants/event_flags.asm')
    out=ROOT/'.tmpbuild/burned-tower'
    out.mkdir(parents=True,exist_ok=True)
    checks=[]

    def check(ok,message):
        if not ok:
            h.pb.screen.image.save(str(out/'failure.png'))
            raise AssertionError(message+'\n'+tile_text(h)+'\n'+'\n'.join(c.grid()))
        checks.append(message)
        print('PASS',message,flush=True)

    def event(name,value=None):
        bit=events[name]
        byte=m.read('wEventFlags',bit//8)
        mask=1<<(bit%8)
        if value is not None:
            m.write('wEventFlags',byte|mask if value else byte&~mask,bit//8)
        return bool(m.read('wEventFlags',bit//8)&mask)

    def enter(x,y):
        group,number=map_ids()['BURNED_TOWER_1F']
        for field,value in dict(wDefaultSpawnpoint=255,wMapGroup=group,wMapNumber=number,
                                wXCoord=x,wYCoord=y,hMapEntryMethod=0xf1,hOAMUpdate=0).items():
            m.write(field,value)
        begin_native_call(h,'OverworldLoop')
        h.tick(180)

    def stage(scene=1,rival=False,released=False,weak=False):
        h.load_fixture()
        event('EVENT_BEAT_FIREBREATHER_DICK',False)
        event('EVENT_BEAT_FIREBREATHER_NED',False)
        event('EVENT_RIVAL_BURNED_TOWER',rival)
        event('EVENT_HOLE_IN_BURNED_TOWER',rival)
        event('EVENT_RELEASED_THE_BEASTS',released)
        event('EVENT_BEAT_HEX_MANIAC_WINNIE',True)
        # Simulate an old save's uninitialized visibility bit.
        event('EVENT_BURNED_TOWER_FIREBREATHER_DICK_ASHES',False)
        m.write('wBurnedTower1FSceneID',scene)
        m.write('wPartyCount',0)
        m.write('wMonType',0)
        party=dict(species='MAGIKARP',level=5,hp=1,moves=['SPLASH']) if weak else dict(
            species='MEW',level=100,moves=['SURF','EARTHQUAKE','PSYCHIC_M','RECOVER'])
        data=Request(h.battle)._side_bytes(party)
        address=h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1',data)
        call(h,'DebugBuildPartyMon',B=0,D=address>>8,E=address&255)
        for field in ('wDebugState','wDebugBattleFlags','hDebugActive','hDebugRNGMode',
                      'wLinkMode','wStatusFlags2','wInBattleTowerBattle'):
            m.write(field,0)
        m.write('wOptions',0x41)
        m.write('wRepelEffect',255)
        m.write('wJohtoBadges',255)
        enter(9,14)

    def visible(index):
        return m.read('wObjectMasks',index)==0

    def roster():
        return [(h.con.species_by_index[m.species_index_of(m.read(f'wOTPartyMon{i}Species'))],
                 m.read(f'wOTPartyMon{i}Level')) for i in range(1,m.read('wOTPartyCount')+1)]

    def battle(expected):
        for _ in range(500):
            if m.read('wBattleMode')==2 and m.read('wOTPartyCount')==len(expected):
                # Wait until the party conversion has completed as well.
                try:
                    if roster()==expected:break
                except KeyError:pass
            c.press('a',hold=4,wait=20)
        else:raise AssertionError('Native trainer battle did not load: '+tile_text(h))
        check(m.read('wOtherTrainerClass')==h.con.trainer_classes['FIREBREATHER'],
              'native encounter uses the Firebreather class')
        check(roster()==expected,'original Gold/Silver party: '+str(expected))
        c.battle(limit=18000)
        for _ in range(120):
            if not m.read('wScriptMode') and m.read('wMapStatus')==2:break
            c.press('b',hold=4,wait=20)
        check(not m.read('wBattleMode') and not m.read('wScriptMode'),'battle returns to controllable overworld')

    try:
        h.ensure_fixture()
        for scene,rival,released in [(1,False,False),(2,True,False),(2,True,True)]:
            stage(scene,rival,released)
            check(visible(7) and visible(8) and not visible(9),
                  f'both trainers present, ashes hidden: rival={rival}, beasts={released}')
            check(c.passable(c.collision(8,3)) and c.passable(c.collision(16,8)),
                  'original trainer positions are walkable')

        stage()
        c.go((7,1),avoid=((11,9),(8,1)))
        check(c.position()==(7,1) and not event('EVENT_RIVAL_BURNED_TOWER'),
              'Dick can be reached from the entrance without fighting the rival')
        h.pb.screen.image.save(str(out/'01-before-dick.png'))
        c.press('right',hold=4,wait=80)
        check(c.position()==(8,1) and m.read('wScriptMode')!=0,
              'original approach tile triggers before the rival')
        battle([('CHARMELEON',17)])
        check(event('EVENT_BEAT_FIREBREATHER_DICK') and not visible(7) and visible(9),
              'winning transforms Dick into ashes immediately')
        check(not event('EVENT_RIVAL_BURNED_TOWER') and m.read('wBurnedTower1FSceneID')==1,
              'Dick does not change rival progress or tower scene')
        check(m.read_bytes('wOBPals1',8,5*8)==bytes.fromhex('ff7fff7fad350000'),
              'ashes use the original Gold/Silver white and gray palette')
        h.pb.screen.image.save(str(out/'02-dick-ashes.png'))
        c.press('down',hold=4,wait=20)
        c.press('a',hold=4,wait=100)
        for _ in range(30):
            if 'training' in tile_text(h):break
            c.press('a',hold=4,wait=20)
        check('training' in tile_text(h) and not m.read('wBattleMode'),
              'ashes speak Dick\'s original post-battle dialogue without another fight')
        for _ in range(40):
            c.press('b',hold=4,wait=20)
            if not m.read('wScriptMode'):break
        # A fresh map entry reconstructs visibility instead of depending on
        # whatever the previous scene left in its object structs.
        event('EVENT_BURNED_TOWER_FIREBREATHER_DICK_ASHES',True)
        enter(9,1)
        check(not visible(7) and visible(9) and event('EVENT_BEAT_FIREBREATHER_DICK'),
              'ashes persist and the visibility flag repairs itself on re-entry')

        stage()
        enter(16,7)
        c.press('down',hold=4,wait=20)
        c.press('a',hold=4,wait=100)
        battle([('KOFFING',15),('GROWLITHE',16),('KOFFING',15)])
        check(event('EVENT_BEAT_FIREBREATHER_NED') and not event('EVENT_RIVAL_BURNED_TOWER'),
              'Ned can be defeated before the rival')
        check(visible(8),'Ned remains for post-battle dialogue')
        h.pb.screen.image.save(str(out/'03-after-ned.png'))
        c.press('a',hold=4,wait=100)
        check('past' in tile_text(h) and not m.read('wBattleMode'),
              'Ned retains his original post-battle dialogue')

        stage(weak=True)
        enter(9,3)
        c.press('left',hold=4,wait=20)
        c.press('a',hold=4,wait=100)
        battle([('CHARMELEON',17)])
        check(not event('EVENT_BEAT_FIREBREATHER_DICK'),
              'losing a directly initiated Dick battle does not mark him defeated')
        enter(9,3)
        check(visible(7) and not visible(9),
              'Dick remains normal and available after a loss and re-entry')
        (out/'validation.json').write_text(json.dumps(dict(checks=checks),indent=2)+'\n')
        print(f'{len(checks)} checks passed',flush=True)
    finally:h.pb.stop(save=False)


if __name__=='__main__':main()
