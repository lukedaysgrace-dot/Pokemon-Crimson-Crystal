#!/usr/bin/env python3
"""Check native Surf selection, collision and pixel travel in private memory."""
import sys
import re
from pathlib import Path

from pc_harness import Harness, ROOT
from battletest.symbols import _parse_constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv)>1 else Path(ROOT)/'pokecrystal.gbc'
    h = Harness(rom=str(rom),sym=str(rom.with_suffix('.sym')))
    constants = {}
    for name in ('map_object','wram','collision','direction'):
        path = Path(ROOT)/f'constants/{name}_constants.asm'
        if path.exists():
            constants.update(_parse_constants(path))
            for key,value in re.findall(r'^(\w+)\s+EQU\s+(\$[\da-fA-F]+|\d+)\s*(?:;[^\n]*)?$',path.read_text(),re.M):
                constants[key] = int(value[1:],16) if value.startswith('$') else int(value)
    h.boot()
    def write(name,value): h.wr(h.s(name),value)
    def read(name): return h.rd(h.s(name))
    obj = h.s('wPlayerStruct')
    checks = 0
    try:
        for state in (constants['PLAYER_SURF'],constants['PLAYER_SURF_PIKA']):
            for direction,(dx,dy) in enumerate(((0,1),(0,-1),(-1,0),(1,0))):
                write('wObjectStructs',[0]*constants['OBJECT_STRUCT_LENGTH']*constants['NUM_OBJECT_STRUCTS'])
                write('wPlayerState',state)
                write('wWalkingDirection',direction)
                write('wFacingDirection',0)
                write('wTilePermissions',0)
                write('wPlayerStandingMapX',100)
                write('wPlayerStandingMapY',100)
                write('wWalkingX',dx&255)
                write('wWalkingY',dy&255)
                write('wWalkingTile',constants['COLL_WATER'])
                result = h.call('DoPlayerMovement.TrySurf')
                assert result['c_flag'] and read('wMovementAnimation') == 0x0c+direction,(state,direction,result)
                checks += 1
                # Execute the selected movement command, then read its native
                # step vector: original overworld Surf is 1 px, 16 frames.
                h.wr(obj+constants['OBJECT_DIRECTION_WALKING'],constants['STEP_WALK']*4+direction)
                result = h.call('GetStepVector',bc=obj)
                assert (result['d'],result['e'],result['a']) == (dx&255,dy&255,16),result
                h.wr(obj+constants['OBJECT_STEP_DURATION'],16)
                write('wPlayerStepVectorX',0)
                write('wPlayerStepVectorY',0)
                for _ in range(16): h.call('PlayerStep.step',bc=obj)
                assert h.rd(obj+constants['OBJECT_STEP_DURATION']) == 0
                assert (read('wPlayerStepVectorX'),read('wPlayerStepVectorY')) == (dx*16&255,dy*16&255)
                checks += 1
                # Forbidden tiles and directional permissions still block Surf.
                for tile,permissions,facing in ((constants['COLL_WALL'],0,0),(constants['COLL_WATER'],1,1)):
                    write('wWalkingTile',tile)
                    write('wTilePermissions',permissions)
                    write('wFacingDirection',facing)
                    assert not h.call('DoPlayerMovement.TrySurf')['c_flag']
                    checks += 1
        # Land exit continues to select the normal 16-frame step.
        bank, address = h.sym['DoPlayerMovement.ExitWater']
        h.wr(0xc0fa,[0xfb,0xc3,address&255,address>>8])
        h.sym.by_name['SurfShoreTest'] = (bank,0xc0fa)
        for direction in range(4):
            write('wWalkingDirection',direction)
            h.call('SurfShoreTest')
            assert read('wPlayerState') == constants['PLAYER_NORMAL']
            assert read('wMovementAnimation') == 0x0c+direction
            checks += 1
        print(f'PASS {checks} Surf checks: both riders, four directions, collision, restored 16px/16 frames and normal-speed shore exit')
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__': main()
