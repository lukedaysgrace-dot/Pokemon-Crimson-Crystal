#!/usr/bin/env python3
"""Native consumption and displayed palette checks for every Gen II Berry."""
import json
from pathlib import Path

from PIL import Image, ImageDraw
from runner import Harness
from symbols import ROOT, STATE_WAIT, _parse_constants, parse_substatus_bits


CASES = [
    ('BERRY', 'Blue', 'PAL_BTLCUSTOM_BLUE', 0),
    ('GOLD_BERRY', 'Gold', 'PAL_BTLCUSTOM_BERRY_GOLD', 0),
    ('PSNCUREBERRY', 'Pink', 'PAL_BTLCUSTOM_PINK', 8),
    ('PRZCUREBERRY', 'Red', 'PAL_BTLCUSTOM_RED', 64),
    ('BURNT_BERRY', 'Yellow-green', 'PAL_BTLCUSTOM_BERRY_YELLOW_GREEN', 32),
    ('ICE_BERRY', 'Light blue', 'PAL_BTLCUSTOM_BERRY_LIGHT_BLUE', 16),
    ('BITTER_BERRY', 'Pink', 'PAL_BTLCUSTOM_PINK', 0),
    ('MINT_BERRY', 'Blue', 'PAL_BTLCUSTOM_BLUE', 3),
    ('MIRACLEBERRY', 'Green', 'PAL_BTLCUSTOM_GREEN', 8),
    ('MYSTERYBERRY', 'Red', 'PAL_BTLCUSTOM_RED', 0),
]


def main():
    h=Harness()
    h.ensure_fixture()
    m=h.battle.mem
    colors=_parse_constants(ROOT/'constants/battle_anim_constants.asm')
    output=ROOT/'_artifacts/held-items/berry-palettes'
    output.mkdir(parents=True,exist_ok=True)
    rom=(ROOT/'pokecrystal_debug.gbc').read_bytes()
    bank,address=h.sym['CustomBattlePalettes']
    base=bank*0x4000+address-0x4000
    current=None
    samples=[]
    screenshot=None
    count=0

    def at_berry(_):
        nonlocal count,screenshot
        if current is None: return
        samples.append(m.read_bytes('wOBPals2',8,7*8))
        count+=1
        if count==24:screenshot=h.pb.screen.image.copy().convert('RGB')
    h.pb.hook_register(*h.sym['BattleAnimFunction_41'],at_berry,None)
    results=[];shots=[]
    try:
        for side in ('player','enemy'):
            for item,label,palette,status in CASES:
                current=None
                h.load_fixture()
                m.write('wOptions',1)
                mon=dict(species='MEW',level=50,ability='NO_ABILITY',moves=['SPLASH'])
                test=dict(player=dict(mon),enemy=dict(mon),rng='forced_high',turns=0)
                test[side]['item']=item
                assert h.run_battle(test)==STATE_WAIT
                prefix='wBattleMon' if side=='player' else 'wEnemyMon'
                party='wPartyMon1' if side=='player' else 'wOTPartyMon1'
                if item in ('BERRY','GOLD_BERRY'):
                    m.write_bytes(prefix+'HP',[0,87]);m.write_bytes(party+'HP',[0,87])
                if status:
                    m.write(prefix+'Status',status);m.write(party+'Status',status)
                if item=='BITTER_BERRY':
                    byte,bit=parse_substatus_bits()['CONFUSED']
                    who='wPlayer' if side=='player' else 'wEnemy'
                    m.write(who+'SubStatus'+str(byte+1),1<<bit)
                    m.write(who+'ConfuseCount',3)
                if item=='MYSTERYBERRY':
                    for field in [prefix+'PP',party+'PP']+(['wWildMonPP'] if side=='enemy' else []):
                        m.write_bytes(field,[1,0,0,0])
                samples=[];screenshot=None;count=0;current=item
                m.write('wDebugTurnTarget',1);m.write('wDebugControl',1)
                for frame in range(2400):
                    if frame%12==0:h.pb.button('a',2)
                    h.tick(1)
                    if h.state()==STATE_WAIT and h.battle.turns_done==1:break
                else:raise AssertionError((side,item,'turn timeout',h.control_state()))
                current=None
                holder=h.battle.player if side=='player' else h.battle.enemy
                assert holder.item=='NO_ITEM',(side,item,'not consumed',holder.item)
                assert count>=40 and screenshot is not None,(side,item,'Berry not rendered',count)
                expected=rom[base+colors[palette]*8:base+colors[palette]*8+8]
                assert samples and all(sample==expected for sample in samples),(side,item,'display palette mismatch',expected.hex(),{s.hex() for s in samples})
                if status:assert holder.status==0,(side,item,'status not cured')
                if item=='GOLD_BERRY':assert holder.hp==130,(side,item,'quarter HP healing')
                if item=='BERRY':assert holder.hp==97,(side,item,'10 HP healing')
                if item=='MYSTERYBERRY':assert holder.pp[0]>0,(side,item,'PP not restored')
                screenshot.save(output/(side+'-'+item.lower()+'.png'))
                shots.append((side,item,label,screenshot))
                results.append(dict(side=side,item=item,color=label,palette=expected.hex(),frames=count))
                print('PASS',side,item,label,flush=True)
    finally:h.pb.stop(save=False)
    sheet=Image.new('RGB',(5*320,4*320),'#eeeeee');draw=ImageDraw.Draw(sheet)
    for index,(side,item,label,shot) in enumerate(shots):
        x=index%5*320;y=index//5*320
        sheet.paste(shot.resize((320,288),Image.Resampling.NEAREST),(x,y))
        draw.text((x+5,y+291),f'{side}: {item} / {label}',fill='#111111')
    sheet.save(output/'all-berry-colors.png')
    (output/'results.json').write_text(json.dumps(dict(rom_hash=h.rom_key(),passed=len(results),results=results),indent=2)+'\n')
    print('BERRY PALETTES: all 10 Berries passed on both battle sides')


if __name__=='__main__':main()
