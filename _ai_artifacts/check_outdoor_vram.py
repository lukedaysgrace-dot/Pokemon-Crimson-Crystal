#!/usr/bin/env python3
"""Mirror ArrangeUsedSprites to report VRAM headroom for every outdoor map group.
See _ai_artifacts/reports/OUTDOOR_SPRITE_VRAM_AUDIT.md for the rules."""
import re, sys, collections

TYPE_ORDER = {'WALKING_SPRITE':1,'STANDING_SPRITE':2,'MON_ICON_SPRITE':3,'STILL_SPRITE':4,'BIG_SPRITE':5}
TYPE_LEN   = {1:12, 2:12, 3:8, 4:4, 5:12}

# --- ordered sprite constants -------------------------------------------------
names, mon_start = [], None
for line in open('constants/sprite_constants.asm'):
    if 'SPRITE_POKEMON EQU const_value' in line:
        mon_start = len(names)
    if re.match(r'\s*const_def\s+\$e0', line):
        break
    m = re.match(r'\s*const\s+(SPRITE_\w+)', line)
    if m and m.group(1) != 'SPRITE_NONE':   # $00 has no OverworldSprites entry
        names.append(m.group(1))

# --- sprite types -------------------------------------------------------------
types = {}
i = 0
for line in open('data/sprites/sprites.asm'):
    m = re.match(r'\s*overworld_sprite\s+\w+,\s*\d+,\s*(\w+),', line)
    if m:
        types[names[i]] = TYPE_ORDER[m.group(1)]
        i += 1
assert i == mon_start, f"sprites.asm has {i} entries, expected {mon_start}"
for n in names[mon_start:]:
    types[n] = TYPE_ORDER['MON_ICON_SPRITE']   # GetMonSprite -> mon icon
types['SPRITE_NONE'] = None
# wVariableSprites indexes ($f0+) resolve at runtime; assume the worst case
# (a 12-tile WALKING_SPRITE) so the report never under-reports pressure.
VARIABLE = ['SPRITE_CONSOLE','SPRITE_DOLL_1','SPRITE_DOLL_2','SPRITE_BIG_DOLL',
            'SPRITE_WEIRD_TREE','SPRITE_OLIVINE_RIVAL','SPRITE_AZALEA_ROCKET',
            'SPRITE_FUCHSIA_GYM_1','SPRITE_FUCHSIA_GYM_2','SPRITE_FUCHSIA_GYM_3',
            'SPRITE_FUCHSIA_GYM_4','SPRITE_COPYCAT','SPRITE_JANINE_IMPERSONATOR',
            'SPRITE_DAY_CARE_MON_1','SPRITE_DAY_CARE_MON_2']
for _v in VARIABLE:
    types.setdefault(_v, TYPE_ORDER['WALKING_SPRITE'])

# --- groups -------------------------------------------------------------------
src = open('data/maps/outdoor_sprites.asm').read()
groups = collections.OrderedDict()
for m in re.finditer(r'^(\w+GroupSprites):\n((?:(?:\t|;).*\n|\n)*)', src, re.M):
    entries = re.findall(r'^\tdb\s+(SPRITE_\w+)', m.group(2), re.M)
    groups[m.group(1)] = entries

PLAYER = 'SPRITE_GOLD'   # walking, 12 tiles (lyra/indigo are the same shape)

def pack(entries):
    used = [PLAYER]
    for s in entries[:23]:
        if s != 'SPRITE_NONE' and s not in used:
            used.append(s)
    used.sort(key=lambda s: types[s])          # stable == list order within a type
    b1 = b0 = 0
    fail = []
    for s in used:
        t = types[s]; ln = TYPE_LEN[t]
        limit1 = 116 if t <= 3 else 128
        if b1 + ln <= limit1:
            b1 += ln
        elif b0 + ln <= 128:
            b0 += ln
        else:
            fail.append(s)
    return len(entries), b1, b0, 128 - b0, fail

print(f"{'group':28} {'#':>3} {'bank1':>6} {'bank0':>6} {'headroom':>9}  status")
bad = False
for g, e in groups.items():
    n, b1, b0, head, fail = pack(e)
    status = 'OK'
    if len(e) > 23:
        status = f'ERROR: {len(e)} entries > MAX_OUTDOOR_SPRITES(23)'; bad = True
    if fail:
        status = 'ERROR: no VRAM for ' + ', '.join(fail); bad = True
    elif head == 0:
        status = 'WARNING: zero margin'
    print(f"{g:28} {n:>3} {b1:>6} {b0:>6} {head:>9}  {status}")
sys.exit(1 if bad else 0)
