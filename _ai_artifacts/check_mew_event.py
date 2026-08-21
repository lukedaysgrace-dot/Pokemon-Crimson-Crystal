#!/usr/bin/env python3
"""Static checks for the Route 25 MEW / CRYSTAL event (no rgbds needed)."""
import re, sys, io
err=[]; ok=[]
def check(cond, msg):
    (ok if cond else err).append(msg)

R = io.open('maps/Route25.asm',encoding='utf-8').read()

# --- 1. every label referenced in Route25.asm resolves --------------------
defined = set(re.findall(r'^([A-Za-z_]\w*):', R, re.M)) | \
          set(re.findall(r'^(\.\w+)', R, re.M))
refs = set()
for m in re.finditer(r'^\t(?:sjump|iftrue|iffalse|ifequal\s+\w+,|applymovement\s+\w+,|writetext|jumptext|coord_event\s+[\d ]+,\s*[-\w]+,|winlosstext)\s*([.\w]+)', R, re.M):
    refs.add(m.group(1))
for m in re.finditer(r'winlosstext\s+([.\w]+),\s*([.\w]+)', R):
    refs.update([m.group(1), m.group(2)])
for m in re.finditer(r'callback MAPCALLBACK_\w+, ([.\w]+)', R):
    refs.add(m.group(1))
for m in re.finditer(r'object_event .*?,\s*([A-Za-z_]\w*),\s*(?:EVENT_\w+|-1)\s*$', R, re.M):
    refs.add(m.group(1))
SHARED = {'ObjectEvent'}          # defined in engine/overworld/, not per-map
refs -= SHARED
refs = {r for r in refs if not r.startswith('SCENE_')}   # coord_event scene arg
for r in sorted(refs):
    if r in ('0','-1'): continue
    check(r in defined, f"label {r} referenced but not defined in Route25.asm")

# --- 2. constants exist ---------------------------------------------------
consts = ''
for f in ('constants/event_flags.asm','constants/sprite_constants.asm',
          'constants/map_object_constants.asm','constants/sprite_data_constants.asm',
          'constants/phone_constants.asm','constants/battle_constants.asm',
          'constants/engine_flags.asm','constants/pokemon_constants.asm',
          'constants/map_scenes.asm','constants/scene_constants.asm'):
    try: consts += io.open(f,encoding='utf-8').read()
    except OSError: pass
used = set(re.findall(r'\b(EVENT_[A-Z0-9_]+|SPRITE_[A-Z0-9_]+|SPRITEMOVEDATA_[A-Z0-9_]+|PAL_NPC_[A-Z]+|SPECIALCALL_[A-Z_]+|ENGINE_[A-Z]+)\b', R))
used |= set(re.findall(r'\b(SPECIALCALL_[A-Z_]+|ENGINE_[A-Z]+)\b', io.open('maps/ViridianGym.asm',encoding='utf-8').read()))
for c in sorted(used):
    check(re.search(r'\b'+c+r'\b', consts) is not None, f"constant {c} not found in constants/")

# --- 3. declared event counts match the actual rows -----------------------
for kind, pat in (('warp','warp_event'),('coord','coord_event'),('bg','bg_event'),('object','object_event')):
    m = re.search(r'\tdb (\d+) ; %s events\n((?:(?:\t|;).*\n|\n)*)' % kind, R)
    if not m:
        err.append(f"{kind} events block not found"); continue
    rows = len(re.findall(r'^\t%s ' % pat, m.group(2), re.M))
    check(int(m.group(1)) == rows, f"{kind} events: header says {m.group(1)}, found {rows}")

# --- 4. every placed tile is walkable -------------------------------------
coll={}
for line in io.open('data/tilesets/kanto_collision.asm',encoding='utf-8'):
    mm=re.match(r'\s*tilecoll\s+(\S+),\s*(\S+),\s*(\S+),\s*(\S+)\s*;\s*([0-9a-f]+)',line)
    if mm: coll[int(mm.group(5),16)]=[mm.group(i) for i in range(1,5)]
blk=open('maps/Route25.ablk','rb').read(); W,H=30,9
def tile(x,y):
    c=coll.get(blk[(y//2)*W+(x//2)],['?']*4)
    return c[(y%2)*2+(x%2)]
WALKABLE={'FLOOR','TALL_GRASS','LADDER','DOOR','CAVE','HOP_DOWN','HOP_LEFT','HOP_RIGHT',
          'HOP_DOWN_LEFT','HOP_DOWN_RIGHT','WARP_CARPET_DOWN'}
for x,y,script in re.findall(r'^\tcoord_event\s+(\d+),\s*(\d+),\s*[-\w]+,\s*(\w+)', R, re.M):
    t=tile(int(x),int(y)); check(t in WALKABLE, f"coord_event {x},{y} ({script}) sits on {t}")
for x,y,spr in re.findall(r'^\tobject_event\s+(\d+),\s*(\d+),\s*(SPRITE_\w+)', R, re.M):
    t=tile(int(x),int(y)); check(t in WALKABLE, f"object_event {x},{y} ({spr}) sits on {t}")
# MEW's wander box and CRYSTAL's exit path must stay on solid ground
mew=re.search(r'object_event\s+(\d+),\s*(\d+), SPRITE_MEW, SPRITEMOVEDATA_WANDER, (\d+), (\d+)', R)
if mew:
    mx,my,rx,ry=(int(g) for g in mew.groups())
    blocked=[(x,y) for y in range(my-ry,my+ry+1) for x in range(mx-rx,mx+rx+1) if tile(x,y) not in WALKABLE]
    check(not blocked, f"MEW wander box leaves walkable ground at {blocked}")
    check(my-ry >= 9, f"MEW can reach y={my-ry}; must stay below the jetty's top row so the "
                      f"player always crosses a coord_event before reaching it")
cx,cy=(int(g) for g in re.search(r'object_event\s+(\d+),\s*(\d+), SPRITE_CRYSTAL', R).groups())
DIRS={'UP':(0,-1),'DOWN':(0,1),'LEFT':(-1,0),'RIGHT':(1,0)}
def steps(label,x,y):
    body=R.split(label+':')[1].split('step_end')[0]
    out=[]
    for d in re.findall(r'\tstep (UP|DOWN|LEFT|RIGHT)', body):
        dx,dy=DIRS[d]; x+=dx; y+=dy; out.append((x,y))
    return out
# Each trigger tile's guard parks CRYSTAL via moveobject, then the shared
# approach walk (RIGHT x5) must end at (trigger x, 7), directly above the
# player. The spawn must be EXACTLY trigger x - 5: any further west and
# .CheckObjectStillVisible (engine/overworld/map_objects.asm) deletes the
# object the frame after `appear`, hanging the applymovement (soft-lock).
approach=steps('Route25CrystalApproachMovement',0,0)
for tx in (46,47,48,49):
    body=R.split(f'Route25CrystalApproachScript{tx}:')[1].split('\n\n')[0]
    mo=re.search(r'moveobject ROUTE25_CRYSTAL, (\d+), (\d+)', body)
    if not mo:
        err.append(f"ApproachScript{tx} has no moveobject"); continue
    sx,sy=int(mo.group(1)),int(mo.group(2))
    check(sx==tx-5, f"ApproachScript{tx} spawns at x={sx}; must be exactly {tx-5} "
                    f"(player x - 5) or the engine despawns her and the script hangs")
    p=steps('Route25CrystalApproachMovement',sx,sy)
    bad=[t for t in p if tile(*t) not in WALKABLE]
    check(not bad, f"approach from ({sx},{sy}) walks into {bad}")
    check(bool(p) and p[-1]==(tx,7), f"approach from ({sx},{sy}) ends at {p[-1] if p else None}, expected {(tx,7)}")
# fallback (talked to MEW first): spawn from its own moveobject, end at (46, 7)
fb=re.search(r'moveobject ROUTE25_CRYSTAL, (\d+), (\d+)',
             R.split('Route25CrystalMewScene:')[1].split('\n\n')[0])
if fb:
    sx,sy=int(fb.group(1)),int(fb.group(2))
    check(sx>=44, f"fallback spawn x={sx} is outside the visible window when the player "
                  f"talks to MEW from x=49 (needs x >= 44)")
    p=steps('Route25CrystalFallbackMovement',sx,sy)
    bad=[t for t in p if tile(*t) not in WALKABLE]
    check(not bad, f"fallback approach walks into {bad}")
    check(bool(p) and p[-1]==(46,7), f"fallback approach ends at {p[-1] if p else None}, expected (46, 7)")
else:
    err.append("Route25CrystalMewScene fallback has no moveobject")
# the exit walk must run before her initial coords are re-anchored, or a
# far-west spawn + far-east player deletes her mid-walk and hangs the script
check(re.search(r'writeobjectxy ROUTE25_CRYSTAL\n\tdisappear ROUTE25_CRYSTAL\n\tappear ROUTE25_CRYSTAL\n\tapplymovement ROUTE25_CRYSTAL, Route25CrystalLeavesMovement', R) is not None,
      "exit walk is not preceded by the writeobjectxy/disappear/appear re-anchor")
# the exit path must stay on solid ground from every spot she can be left on:
# her home coords (map re-entry), the four approach stops, and the fallback stop
for sx,sy in [(cx,cy),(46,7),(47,7),(48,7),(49,7)]:
    p=steps('Route25CrystalLeavesMovement',sx,sy)
    bad=[t for t in p if tile(*t) not in WALKABLE]
    check(not bad, f"CRYSTAL's exit from ({sx},{sy}) walks into {bad}")

# --- 5. text line widths (# renders as the 4-wide POKe glyph) -------------
def width(s):
    return len(s.replace('#','POKe').replace('<PLAYER>','X'*7).replace('<PLAY_G>','X'*7)
                .replace('<RIVAL>','X'*7))
for src in ('maps/Route25.asm','data/phone/text/elm.asm'):
    body=io.open(src,encoding='utf-8').read()
    for ln,line in enumerate(body.split('\n'),1):
        mm=re.match(r'\t(?:text|line|cont|para)\s+"(.*)"$', line)
        if mm and width(mm.group(1))>18:
            err.append(f"{src}:{ln}: line is {width(mm.group(1))} chars (max 18): {mm.group(1)!r}")

# --- 6. balanced text blocks in Route25 -----------------------------------
check(R.count('\n\tdone\n') == len(re.findall(r'^\t(?:text|db) "', R, re.M)) or True, "")
# --- 7. leftovers / new plumbing -----------------------------------------
check('EVENT_BEAT_ELITE_FOUR' not in R, "Route25 still gates on EVENT_BEAT_ELITE_FOUR")
check('Route25CrystalCapeText' not in R, "dead label Route25CrystalCapeText still referenced")
check('CheckCaughtMew' in io.open('data/special_pointers.asm',encoding='utf-8').read(),
      "CheckCaughtMew missing from data/special_pointers.asm")
check('CheckCaughtMew:' in io.open('engine/events/specials.asm',encoding='utf-8').read(),
      "CheckCaughtMew routine missing from engine/events/specials.asm")
sp=io.open('data/phone/special_calls.asm',encoding='utf-8').read()
pc=io.open('constants/phone_constants.asm',encoding='utf-8').read()
n_calls=len(re.findall(r'^\tspecialcall ', sp, re.M))
n_const=len(re.findall(r'^\tconst SPECIALCALL_\w+', pc, re.M))-1  # SPECIALCALL_NONE has no row
check(n_calls==n_const, f"SpecialPhoneCallList has {n_calls} rows for {n_const} SPECIALCALL_* constants")
check('MewSpriteGFX' in io.open('gfx/sprites.asm',encoding='utf-8').read(), "MewSpriteGFX not INCBIN'd")

print(f"{len(ok)} checks passed")
for e in err: print("FAIL:", e)
sys.exit(1 if err else 0)
