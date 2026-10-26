"""Targeted source collision probes. These prove found floor/water paths only.

Not a complete movement/script interpreter: failure does NOT prove a hard gate.
Every accepted path is emitted for manual review. No game files are written.
"""
import json
import re
import sys
from collections import deque
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
sys.path.insert(0,str(ROOT/'tools'))
import audit_game_data as gd

def run():
    a=gd.Audit(); maps=gd.map_definitions(a);sets=gd.tileset_files(a)
    lines=gd.read(ROOT/'data/maps/blocks.asm').splitlines()
    positions={m[1]:i for i,line in enumerate(lines) if (m:=re.match(r'^(\w+_Blocks):',line))}
    all_grids={};warps={};blocked={}
    for key,info in maps.items():
        blob=gd.parse_block_data(a,info['name']+'_Blocks',positions,lines)
        coll=sets[info['tileset']][2]
        grid={(x,y):coll[blob[y//2*info['width']+x//2]][y%2*2+x%2] for y in range(info['height']*2) for x in range(info['width']*2)}
        all_grids[key]=grid
        src=gd.read(ROOT/'maps'/(info['name']+'.asm'))
        warps[key]=[tuple([int(x),int(y),dest,int(n)]) for x,y,dest,n in re.findall(r'^\s*warp_event\s+(\d+),\s*(\d+),\s*(\w+),\s*(\d+)',src,re.M)]
        blocked[key]={(int(x),int(y)) for x,y,sprite in re.findall(r'^\s*object_event\s+(\d+),\s*(\d+),\s*(SPRITE_BOULDER|SPRITE_ROCK)',src,re.M)}
    selected=['ROUTE_42','MOUNT_MORTAR_1F_OUTSIDE','MOUNT_MORTAR_1F_INSIDE','MOUNT_MORTAR_B1F','MOUNT_MORTAR_2F_INSIDE','ROUTE_3','ROUTE_9','ROUTE_46','UNION_CAVE_B1F','RUINS_OF_ALPH_OUTSIDE']
    for key in selected:
        info=maps[key];grid=all_grids[key];chars=[]
        for y in range(info['height']*2):
            chars.append(''.join('.' if c in ['FLOOR','TALL_GRASS','LONG_GRASS'] else '~' if c=='WATER' else 'o' if c in ['CAVE','LADDER','DOOR','STAIRCASE'] or c.startswith('WARP') else 'v' if c=='HOP_DOWN' else '^' if c=='WATERFALL' else '#' for x in range(info['width']*2) for c in [grid[x,y]]))
        (HERE/(info['name']+'_collision.txt')).write_text('\n'.join(f'{i:02d} {row}' for i,row in enumerate(chars)))
    def probe(start,goal,allow_maps,surf=False,extra_blocked=None):
        extra_blocked=extra_blocked or {}
        queue=deque([start]);prior={start:None}
        def allowed(state):
            mp,x,y=state;c=all_grids[mp].get((x,y),'WALL')
            return (x,y) not in blocked[mp] and (x,y) not in extra_blocked.get(mp,set()) and (c in ['FLOOR','TALL_GRASS','LONG_GRASS','CAVE','LADDER','DOOR','STAIRCASE','ICE','PUDDLE','CUT_TREE'] or c.startswith('WARP') or surf and c=='WATER')
        end=None
        while queue:
            at=queue.popleft()
            if goal(at):end=at;break
            mp,x,y=at
            nxt=[(mp,x+dx,y+dy) for dx,dy in [(-1,0),(1,0),(0,-1),(0,1)]]
            for dx,dy,ledge in [(0,1,'HOP_DOWN'),(0,-1,'HOP_UP'),(1,0,'HOP_RIGHT'),(-1,0,'HOP_LEFT')]:
                if all_grids[mp].get((x+dx,y+dy))==ledge:nxt.append((mp,x+2*dx,y+2*dy))
            for wx,wy,dst,num in warps[mp]:
                if (x,y)==(wx,wy) and dst in allow_maps and num<=len(warps.get(dst,[])):
                    tx,ty,_,_=warps[dst][num-1];nxt.append((dst,tx,ty))
            # Entering a warp on foot must transition; do not let a path walk
            # through a cave/ladder as ordinary floor. A newly arrived player
            # can step off the destination warp. Start positions are arrivals.
            at_warp=any((x,y)==(wx,wy) for wx,wy,_,_ in warps[mp])
            parent=prior[at]
            if at_warp and parent is not None and parent[0]==mp:
                nxt=[ns for ns in nxt if ns[0]!=mp]
            for ns in nxt:
                if ns not in prior and allowed(ns):prior[ns]=at;queue.append(ns)
        path=[]
        if end:
            while end is not None:path.append(end);end=prior[end]
            path.reverse()
        return dict(found=bool(path),steps=len(path)-1,path=path,visited=len(prior))
    mortar=set(selected[:5])
    result={}
    for surf in (False,True):
        result[f'route42_fisher_blocked_surf{surf}']=probe(('ROUTE_42',1,8),lambda s:s[0]=='ROUTE_42' and s[1]>=58,mortar,surf,{'ROUTE_42':{(10,6),(10,7),(10,8),(10,9)}})
    result['route42_fisher_gone_surf']=probe(('ROUTE_42',1,8),lambda s:s[0]=='ROUTE_42' and s[1]>=58,mortar,True)
    # Route3 access has no Brock-dependent script. A found simple floor path
    # establishes the terrain portion of the route to Mt Moon.
    result['route3_west_to_moon']=probe(('ROUTE_3',0,8),lambda s:s[0]=='ROUTE_3' and (s[1],s[2])==(52,1),{'ROUTE_3'})
    result['route9_to_power_river_before_Misty']=probe(('ROUTE_9',0,4),lambda s:s[0]=='ROUTE_9' and s[1]>=58 and all_grids['ROUTE_9'].get((s[1],s[2]))=='WATER',{'ROUTE_9'},True,{'ROUTE_9':{(48,16),(49,16)}})
    result['route9_to_tunnel_before_Misty']=probe(('ROUTE_9',0,4),lambda s:s[0]=='ROUTE_9' and (s[1],s[2])==(48,15),{'ROUTE_9'},True,{'ROUTE_9':{(48,16),(49,16)}})
    result['route46_bottom_to_trainers']=probe(('ROUTE_46',7,33),lambda s:s[0]=='ROUTE_46' and s[2]<=19,{'ROUTE_46'})
    for surf in [False,True]:
        result[f'union_b1f_hiker_phillip_surf{surf}']=probe(('UNION_CAVE_B1F',7,19),lambda s:abs(s[1]-9)+abs(s[2]-4)<=1,{'UNION_CAVE_B1F'},surf)
        result[f'union_b1f_hiker_leonard_surf{surf}']=probe(('UNION_CAVE_B1F',7,19),lambda s:abs(s[1]-16)+abs(s[2]-7)<=1,{'UNION_CAVE_B1F'},surf)
        result[f'ruins_nathan_surf{surf}']=probe(('RUINS_OF_ALPH_OUTSIDE',13,20),lambda s:abs(s[1]-4)+abs(s[2]-20)<=1,{'RUINS_OF_ALPH_OUTSIDE'},surf)
        result[f'ruins_grass_surf{surf}']=probe(('RUINS_OF_ALPH_OUTSIDE',13,20),lambda s:all_grids['RUINS_OF_ALPH_OUTSIDE'].get((s[1],s[2]))=='TALL_GRASS',{'RUINS_OF_ALPH_OUTSIDE'},surf)
    result['map_parse_errors']=a.errors
    (HERE/'collision_probes.json').write_text(json.dumps(result,indent=2))
    print(json.dumps({k:{kk:vv for kk,vv in v.items() if kk!='path'} if isinstance(v,dict) else v for k,v in result.items()},indent=2))
    return result
if __name__=='__main__':run()
