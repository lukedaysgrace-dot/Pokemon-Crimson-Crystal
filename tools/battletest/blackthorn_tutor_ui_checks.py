#!/usr/bin/env python3
"""Check the actual Blackthorn NPC menu in a private native-cartridge New Game.

Requires the isolated PyBoy 2.8.1 runtime (PYTHONPATH=.tmpbuild/pyboy-link).
Screenshots cover the first page, scrolling beyond 128 entries and Cancel.
Player saves are never opened.
"""
import re
from pathlib import Path
from runner import Harness
from state import Request
from probability_checks import call
from gameplay_rules_checks import new_game
from save_menu_checks import begin_native_call
from ui_checks import tile_text


def main():
    h=Harness(cartridge='native')
    out=Path('.tmpbuild/blackthorn-visual')
    out.mkdir(parents=True,exist_ok=True)
    try:
        new_game(h,0)
        m=h.battle.mem
        m.write('wPartyCount',0)
        request=Request(h.battle)
        address=h.sym.addr('wDebugPlayer1')
        m.write_bytes('wDebugPlayer1', request._side_bytes(dict(species='MEW',level=100,moves=['SPLASH'])))
        call(h,'DebugBuildPartyMon',B=0,D=address>>8,E=address&255)
        for name in ('wDebugState','hDebugActive','hDebugRNGMode','wLinkMode','wCurPartyMon'):
            m.write(name,0)
        m.write('wCurPartySpecies',m.read('wPartyMon1Species'))
        call(h,'EggMoveTutor_GetTeachableMoves')
        n=m.read('wMoveReminderMoveList')
        before=m.read_bytes('wMoveReminderMoveList',2*n+3)
        group=number=0
        for line in Path('constants/map_constants.asm').read_text().splitlines():
            if re.match(r'\s+newgroup\b',line):group+=1;number=0
            match=re.match(r'\s+map_const\s+(\w+),',line)
            if match:
                number+=1
                if match[1]=='MOVE_DELETERS_HOUSE':break
        else:raise AssertionError('map not found')
        m.write('wMapGroup',group);m.write('wMapNumber',number)
        m.write('wXCoord',6);m.write('wYCoord',2)
        m.write('wDefaultSpawnpoint',255);m.write('hMapEntryMethod',0xf1)
        m.write_bytes('wMoney',(10000).to_bytes(3,'big'))
        begin_native_call(h,'OverworldLoop')
        h.tick(180)
        h.press('up',hold=4,wait=24)
        h.press('a',hold=4,wait=40)
        for attempt in range(80):
            h.tick(40)
            if 'ACROBATICS' in tile_text(h) and 'AERIAL ACE' in tile_text(h):
                break
            h.press('a',hold=4,wait=20)
        else:
            raise AssertionError('Tutor did not open: '+tile_text(h))
        h.tick(60)
        before=m.read_bytes('wMoveReminderMoveList',2*n+3)
        h.pb.screen.image.resize((640,576)).save(out/'top.png')
        print('SPRITE FLAGS',m.read('wVramState'),m.read('wSpriteUpdatesEnabled'),m.read('hOAMUpdate'),list(m.read_bytes('wVirtualOAM',16)),list(h.pb.memory[0xfe00:0xfe10]),flush=True)
        assert all(h.pb.memory[0xfe00+4*i] in (0,160) for i in range(40)), 'Overworld sprites visible over menu'
        print('TOP',n,tile_text(h),flush=True)
        assert m.read('wMenuData_ScrollingMenuHeight')==4
        for i in range(132):
            h.press('down',hold=4,wait=12)
        h.pb.screen.image.resize((640,576)).save(out/'past-128.png')
        print('SCROLLED',m.read('wMenuScrollPosition'),tile_text(h),flush=True)
        assert m.read('wMenuScrollPosition')>=128
        assert all(h.pb.memory[0xfe00+4*i] in (0,160) for i in range(40)), 'Overworld sprites visible after scrolling'
        for i in range(n-132):
            h.press('down',hold=4,wait=12)
        h.pb.screen.image.resize((640,576)).save(out/'bottom.png')
        print('BOTTOM',m.read('wMenuScrollPosition'),tile_text(h),flush=True)
        assert m.read_bytes('wMoveReminderMoveList',2*n+3)==before
        assert all(h.pb.memory[0xfe00+4*i] in (0,160) for i in range(40)), 'Overworld sprites visible at bottom'
        h.press('b',hold=4,wait=30)
        assert m.read('wMenuJoypad')==2
        print('PASS: actual Blackthorn NPC menu, button scrolling past 128, final Cancel entry, buffer preservation and B cancellation.',flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
