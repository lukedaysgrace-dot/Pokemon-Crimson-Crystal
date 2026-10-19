#!/usr/bin/env python3
"""Check the species' compiled data, Dex bits, and level-32 evolution."""
import json
from pathlib import Path
import sys
from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    rom = Path(sys.argv[1]) if len(sys.argv)>1 else root/'pokecrystal.gbc'
    h = Harness(rom=str(rom),sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    items = _parse_constants(root/'constants/item_constants.asm')
    reference = json.loads((root/'tools/testdata/phantump_trevenant.json').read_text())['species']
    checks = 0

    def check(ok, message):
        nonlocal checks
        checks += 1
        assert ok, message

    def write(name,value): h.wr(h.s(name),value)

    def party(level=32,known=('TACKLE',),slot=0,item=0):
        info=h.build_temp_mon(con.species_index('PHANTUMP'),
            [con.move_index(m) for m in known]+[0]*(4-len(known)),
            level=level,item=item,statexp=bytes(10),nick='TESTMON@@@@')
        write('wTempMonHP',[0,100]);write('wTempMonMaxHP',[0,100])
        write('wPartyCount',slot+1)
        write('wPartySpecies',[info['sid']]*(slot+1)+[255])
        start=h.s('wPartyMon1')+slot*50
        h.wr(start,h.rd(h.s('wTempMon'),50))
        h.wr(h.s('wPartyMonNicknames')+slot*11,h.rd(h.s('wTempMonNickname'),11))
        h.wr(h.s('wPartyMonOT')+slot*11,h.rd(h.s('wTempMonOT'),11))
        write('wCurPartyMon',slot);write('wCurPartyLevel',level)
        write('wCurPartySpecies',info['sid']);write('wTempSpecies',info['sid'])
        write('wLinkMode',0);write('wForceEvolution',0);write('wBattleMode',0)
        return start

    def moves(start):
        return [con.moves_by_index[h.move_index(m)] for m in h.rd(start+2,4) if m]

    presentation={name:b'\xc9' for name in (
        'PrintText','PrintTextboxText','DelayFrames','ClearSprites','ClearTileMap',
        'PlayMusic','PlaySFX','WaitSFX','RestartMapMusic','LearnLevelMoves')}
    presentation['EvolutionAnimation']=b'\xaf\xc9'
    try:
        for species,row in reference.items():
            sid=h.species_id(con.species_index(species))
            write('wCurSpecies',sid);h.call('GetBaseData')
            check(list(h.rd(h.s('wBaseStats'),6))==row['stats'],species+': base stats')
            check(h.rd(h.s('wBaseCatchRate'))==row['catch_rate'],species+': catch rate')
            check(h.rd(h.s('wBaseEggSteps'))==20,species+': hatch cycles')
            check(list(h.rd(h.s('wBaseAbilities'),3))==[con.abilities[a] for a in ('NATURAL_CURE','FRISK','HARVEST')],species+': ability slots')
            regional=h.call('GetRegionalDexNumber_DE',de=con.species_index(species))['hl']
            check(regional=={'PHANTUMP':287,'TREVENANT':288}[species],species+': regional Dex number')
            # New high-index flags must occupy the newly inserted bytes.
            flag_bytes=(len(con.species_by_index)+7)//8
            write('wPokedexCaught',bytes(flag_bytes));write('wPokedexSeen',bytes(flag_bytes))
            h.call('SetSeenAndCaughtMon',a=sid)
            bit=con.species_index(species)-1
            for table in ['wPokedexCaught','wPokedexSeen']:
                flags=h.rd(h.s(table),flag_bytes)
                check(flags[bit//8]==1<<(bit%8) and sum(v.bit_count() for v in flags)==1,species+': '+table)
        with patches(h,presentation):
            for level,slot in [(32,0),(33,0),(60,2),(100,0)]:
                start=party(level=level,slot=slot)
                h.call('EvolvePokemon',max_frames=300)
                check(h.species_index(h.rd(start))==con.species_index('TREVENANT'),'Level evolution at '+str(level))
                check(moves(start)==['TACKLE','SHADOW_CLAW'],'Evolution move at '+str(level))
                check(h.rd(start+24)>0,'Shadow Claw PP')
            start=party(known=('TACKLE','SHADOW_CLAW'))
            h.call('EvolvePokemon',max_frames=300)
            check(moves(start)==['TACKLE','SHADOW_CLAW'],'Known evolution move duplicated')
            full=('TACKLE','GROWL','CONFUSION','PECK')
            start=party(known=full)
            selected=start+3
            choose=bytes([0x21,selected&255,selected>>8,0x7e,0xa7,0xc9])
            with patches(h,{'ForgetMove':choose}):h.call('EvolvePokemon',max_frames=300)
            check(moves(start)==['TACKLE','SHADOW_CLAW','CONFUSION','PECK'],'Full moveset replacement')
            start=party(known=full)
            with patches(h,{'ForgetMove':b'\x37\xc9','YesNoBox':b'\xa7\xc9'}):h.call('EvolvePokemon',max_frames=300)
            check(moves(start)==list(full),'Declining evolution move')
            for level,item,cancel in [(31,0,False),(32,items['EVERSTONE'],False),(32,0,True)]:
                start=party(level=level,item=item)
                with patches(h,{'EvolutionAnimation':b'\x37\xc9'} if cancel else {}):h.call('EvolvePokemon',max_frames=300)
                check(h.species_index(h.rd(start))==con.species_index('PHANTUMP'),'Blocked evolution changed species')
                check(moves(start)==['TACKLE'],'Blocked evolution taught a move')
        # At level 32, offer Shadow Claw on evolution and then the ordinary
        # level-32 Curse entry, without losing either move or duplicating it.
        with patches(h,{name:data for name,data in presentation.items() if name!='LearnLevelMoves'}):
            start=party(level=32)
            h.call('EvolvePokemon',max_frames=300)
            check(moves(start)==['TACKLE','SHADOW_CLAW','CURSE'],'Level-32 evolution and level-up moves')
            check(h.rd(start+24)>0 and h.rd(start+25)>0,'Evolution/level-up move PP')
        print(f'PHANTUMP/TREVENANT PASSED: {checks} checks in {rom.name}',flush=True)
    finally:
        h.pyboy.stop(save=False)


if __name__=='__main__':main()
