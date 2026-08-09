#!/usr/bin/env python3
"""Wire FINIZEN and PALAFIN into the Pokemon Crimson Crystal disassembly.

Idempotent: running it twice is a no-op. Run from the repo root.
"""
import os
import sys
import io

ROOT = os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
if len(sys.argv) > 1:
    ROOT = os.path.abspath(sys.argv[1])
os.chdir(ROOT)

changed = []
skipped = []


def read(path):
    with io.open(path, encoding='utf-8', newline='') as f:
        return f.read()


def write(path, text):
    with io.open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(text)


def nl_of(text):
    return '\r\n' if '\r\n' in text else '\n'


def insert_after(path, anchor, addition, marker=None):
    """Insert `addition` right after the line containing `anchor`."""
    text = read(path)
    nl = nl_of(text)
    probe = marker if marker is not None else addition.strip().splitlines()[0].strip()
    if probe.replace('\n', nl) in text:
        skipped.append(path)
        return
    anchor_n = anchor.replace('\n', nl)
    if anchor_n not in text:
        raise SystemExit('ANCHOR NOT FOUND in %s: %r' % (path, anchor))
    add = addition.replace('\n', nl)
    text = text.replace(anchor_n, anchor_n + add, 1)
    write(path, text)
    changed.append(path)


def insert_before(path, anchor, addition, marker):
    text = read(path)
    nl = nl_of(text)
    if marker.replace('\n', nl) in text:
        skipped.append(path)
        return
    anchor_n = anchor.replace('\n', nl)
    if anchor_n not in text:
        raise SystemExit('ANCHOR NOT FOUND in %s: %r' % (path, anchor))
    add = addition.replace('\n', nl)
    write(path, text.replace(anchor_n, add + anchor_n, 1))
    changed.append(path)


def replace_once(path, old, new, marker=None):
    text = read(path)
    nl = nl_of(text)
    old_n = old.replace('\n', nl)
    new_n = new.replace('\n', nl)
    if old_n not in text:
        if new_n in text:
            skipped.append(path)
            return
        raise SystemExit('ANCHOR NOT FOUND in %s: %r' % (path, old))
    write(path, text.replace(old_n, new_n, 1))
    changed.append(path)


def new_file(path, body):
    if os.path.exists(path):
        skipped.append(path)
        return
    d = os.path.dirname(path)
    if d and not os.path.isdir(d):
        os.makedirs(d)
    write(path, body.replace('\n', os.linesep) if False else body)
    changed.append(path)


# ---------------------------------------------------------------- constants
insert_after(
    'constants/pokemon_constants.asm',
    '\tconst ESPATHRA          ;',
    '\n\tconst FINIZEN           ;\n\tconst PALAFIN           ;',
    marker='const FINIZEN',
)

# ---------------------------------------------------------------- names
insert_after('data/pokemon/names.asm', '\tdb "ESPATHRA@@"',
             '\n\tdb "FINIZEN@@@"\n\tdb "PALAFIN@@@"', marker='"FINIZEN@@@"')

# ---------------------------------------------------------------- base stats
insert_after('data/pokemon/base_stats.asm',
             'INCLUDE "data/pokemon/base_stats/espathra.asm"',
             '\nINCLUDE "data/pokemon/base_stats/finizen.asm"'
             '\nINCLUDE "data/pokemon/base_stats/palafin.asm"',
             marker='base_stats/finizen.asm')

new_file('data/pokemon/base_stats/finizen.asm', '''\tdb 0 ; species ID placeholder

\tdb  70,  45,  40,  75,  45,  40
\t;   hp  atk  def  spd  sat  sdf

\tdb WATER, WATER ; type
\tdb 200 ; catch rate
\tdb 63 ; base exp
\tdb NO_ITEM, NO_ITEM ; items
\tdb GENDER_F50 ; gender ratio
\tdb 100 ; unknown 1
\tdb 20 ; step cycles to hatch
\tdb 5 ; unknown 2
\tINCBIN "gfx/pokemon/finizen/front.dimensions"
\tabilities_for FINIZEN, WATER_VEIL, WATER_VEIL, SWIFT_SWIM
\tdb 0 ; padding
\tdb GROWTH_SLOW ; growth rate
\tdn EGG_WATER_2, EGG_GROUND ; egg groups

\t; tm/hm learnset
\ttmhm HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SNORE, BLIZZARD, ICY_WIND, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, RETURN, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SWIFT, DETECT, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
\t; end
''')

new_file('data/pokemon/base_stats/palafin.asm', '''\tdb 0 ; species ID placeholder

\tdb 100, 140, 100,  90,  95,  75
\t;   hp  atk  def  spd  sat  sdf

\tdb WATER, FIGHTING ; type
\tdb 45 ; catch rate
\tdb 180 ; base exp
\tdb NO_ITEM, NO_ITEM ; items
\tdb GENDER_F50 ; gender ratio
\tdb 100 ; unknown 1
\tdb 20 ; step cycles to hatch
\tdb 5 ; unknown 2
\tINCBIN "gfx/pokemon/palafin/front.dimensions"
\tabilities_for PALAFIN, IRON_FIST, DEFIANT, SWIFT_SWIM
\tdb 0 ; padding
\tdb GROWTH_SLOW ; growth rate
\tdn EGG_WATER_2, EGG_GROUND ; egg groups

\t; tm/hm learnset
\ttmhm DYNAMICPUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SNORE, BLIZZARD, HYPER_BEAM, ICY_WIND, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, IRON_TAIL, EARTHQUAKE, RETURN, DIG, MUD_SLAP, DOUBLE_TEAM, ICE_PUNCH, SWAGGER, SLEEP_TALK, SWIFT, THUNDERPUNCH, DETECT, REST, ATTRACT, THIEF, FIRE_PUNCH, SURF, STRENGTH, WHIRLPOOL, WATERFALL, ICE_BEAM
\t; end
''')

# ---------------------------------------------------------------- cries
insert_after('data/pokemon/cries.asm',
             '\tmon_cry CRY_FEAROW,     -$040,  $160 ; ESPATHRA',
             '\n\tmon_cry CRY_SEEL,        $0c0,  $0e0 ; FINIZEN'
             '\n\tmon_cry CRY_SEEL,       -$050,  $190 ; PALAFIN',
             marker='; FINIZEN')

# ---------------------------------------------------------------- dex entries
insert_after('data/pokemon/dex_entries.asm',
             'EspathraPokedexEntry::  INCLUDE "data/pokemon/dex_entries/espathra.asm"',
             '\nFinizenPokedexEntry::  INCLUDE "data/pokemon/dex_entries/finizen.asm"'
             '\nPalafinPokedexEntry::  INCLUDE "data/pokemon/dex_entries/palafin.asm"',
             marker='FinizenPokedexEntry')

new_file('data/pokemon/dex_entries/finizen.asm', '''\tdb "DOLPHIN@" ; species name
\tdw 403, 1327 ; height, weight

\t   db "It swims in pods"
\tnext "and rushes to a"
\tnext "friend in need."

\tpage "The ring on its"
\tnext "snout is made of"
\tnext "sea foam.@"
''')

new_file('data/pokemon/dex_entries/palafin.asm', '''\tdb "DOLPHIN@" ; species name
\tdw 511, 2147 ; height, weight

\t   db "When a comrade is"
\tnext "in danger, its"
\tnext "body bulks up."

\tpage "Its punches can"
\tnext "shatter a hull"
\tnext "in one blow.@"
''')

insert_after('data/pokemon/dex_entry_pointers.asm', '\tdba EspathraPokedexEntry',
             '\n\tdba FinizenPokedexEntry\n\tdba PalafinPokedexEntry',
             marker='dba FinizenPokedexEntry')

# ---------------------------------------------------------------- dex orders
insert_after('data/pokemon/dex_order_new.asm', '\tdw ESPATHRA',
             '\n\tdw FINIZEN\n\tdw PALAFIN', marker='dw FINIZEN')

# alphabetical: FERALIGATR < FINIZEN < FLAAFFY ; PAWNIARD ... PALAFIN < PARAS
insert_before('data/pokemon/dex_order_alpha.asm', '\tdw FLAAFFY',
              '\tdw FINIZEN\n', marker='\tdw FINIZEN')
insert_before('data/pokemon/dex_order_alpha.asm', '\tdw PARAS',
              '\tdw PALAFIN\n', marker='\tdw PALAFIN')

# ---------------------------------------------------------------- first stages
insert_after('data/pokemon/first_stages.asm', '\tdw FLITTLE\n\tdw FLITTLE',
             '\n\tdw FINIZEN\n\tdw FINIZEN', marker='dw FINIZEN')

# ---------------------------------------------------------------- ez chat
replace_once('data/pokemon/ezchat_order.asm',
             '\tdw SALANDIT, SALAZZLE, KOTORA, RAITORA, GOROTORA, FLITTLE, ESPATHRA, -1',
             '\tdw SALANDIT, SALAZZLE, KOTORA, RAITORA, GOROTORA, FLITTLE, ESPATHRA\n'
             '\tdw FINIZEN, PALAFIN, -1',
             marker='FINIZEN, PALAFIN')

# ---------------------------------------------------------------- evos/attacks
insert_after('data/pokemon/evos_attacks_johto.asm', '\tdw EspathraEvosAttacks',
             '\n\tdw FinizenEvosAttacks\n\tdw PalafinEvosAttacks',
             marker='dw FinizenEvosAttacks')

evos = '''

FinizenEvosAttacks:
\tdbbw EVOLVE_LEVEL, 36, PALAFIN
\tdb 0 ; no more evolutions
\tdbw 1, TACKLE
\tdbw 1, WATER_GUN
\tdbw 5, SUPERSONIC
\tdbw 10, FOCUS_ENERGY
\tdbw 15, AQUA_JET
\tdbw 20, CHARM
\tdbw 25, DOUBLESLAP
\tdbw 30, WHIRLPOOL
\tdbw 35, HAZE
\tdbw 40, FLIP_TURN
\tdbw 45, SURF
\tdbw 50, PLAY_ROUGH
\tdb 0 ; no more level-up moves

PalafinEvosAttacks:
\tdb 0 ; no more evolutions
\tdbw 1, TACKLE
\tdbw 1, WATER_GUN
\tdbw 1, AQUA_JET
\tdbw 1, MACH_PUNCH
\tdbw 5, SUPERSONIC
\tdbw 10, FOCUS_ENERGY
\tdbw 15, AQUA_JET
\tdbw 20, CHARM
\tdbw 25, BULK_UP
\tdbw 30, WHIRLPOOL
\tdbw 35, HAZE
\tdbw 36, DRAIN_PUNCH
\tdbw 40, FLIP_TURN
\tdbw 45, SURF
\tdbw 50, CROSS_CHOP
\tdbw 56, LIQUIDATION
\tdbw 62, CLOSE_COMBAT
\tdb 0 ; no more level-up moves
'''

text = read('data/pokemon/evos_attacks_johto.asm')
if 'FinizenEvosAttacks:' not in text:
    nl = nl_of(text)
    write('data/pokemon/evos_attacks_johto.asm', text.rstrip(nl.join(['', ''])).rstrip('\r\n') + nl + evos.replace('\n', nl))
    changed.append('data/pokemon/evos_attacks_johto.asm (data)')
else:
    skipped.append('data/pokemon/evos_attacks_johto.asm (data)')

# ---------------------------------------------------------------- egg moves
insert_after('data/pokemon/egg_moves_johto.asm', '\tdw NoEggMoves2 ; ESPATHRA',
             '\n\tdw FinizenEggMoves ; FINIZEN\n\tdw NoEggMoves2 ; PALAFIN',
             marker='FinizenEggMoves ; FINIZEN')

text = read('data/pokemon/egg_moves_johto.asm')
if 'FinizenEggMoves:' not in text:
    nl = nl_of(text)
    egg = ('\n\nFinizenEggMoves:\n\tdw AQUA_JET\n\tdw HAZE\n\tdw MIST\n'
           '\tdw FAKE_OUT\n\tdw SUPER_FANG\n\tdw -1 ; end\n')
    write('data/pokemon/egg_moves_johto.asm', text.rstrip('\r\n') + egg.replace('\n', nl))
    changed.append('data/pokemon/egg_moves_johto.asm (data)')
else:
    skipped.append('data/pokemon/egg_moves_johto.asm (data)')

# ---------------------------------------------------------------- menu icon pals
insert_after('data/pokemon/menu_icon_pals.asm',
             '\ticon_pals BROWN,  PURPLE ; ESPATHRA',
             '\n\ticon_pals BLUE,   TEAL   ; FINIZEN'
             '\n\ticon_pals BLUE,   PINK   ; PALAFIN',
             marker='; FINIZEN')

# ---------------------------------------------------------------- palettes
insert_after('data/pokemon/palettes.asm',
             'INCLUDE "gfx/pokemon/espathra/shiny.pal"',
             '\nINCBIN "gfx/pokemon/finizen/front.gbcpal", middle_colors'
             '\nINCLUDE "gfx/pokemon/finizen/shiny.pal"'
             '\nINCBIN "gfx/pokemon/palafin/front.gbcpal", middle_colors'
             '\nINCLUDE "gfx/pokemon/palafin/shiny.pal"',
             marker='gfx/pokemon/finizen/front.gbcpal')

# ---------------------------------------------------------------- pic pointers
insert_after('data/pokemon/pic_pointers.asm', '\tdba EspathraBackpic',
             '\n\tdba FinizenFrontpic\n\tdba FinizenBackpic'
             '\n\tdba PalafinFrontpic\n\tdba PalafinBackpic',
             marker='dba FinizenFrontpic')

# ---------------------------------------------------------------- icons
insert_after('data/icon_pointers.asm', '\tdba EspathraIcon',
             '\n\tdba FinizenIcon\n\tdba PalafinIcon', marker='dba FinizenIcon')
insert_after('data/menu_icon_pointers.asm', '\tdba EspathraMenuIcon',
             '\n\tdba FinizenMenuIcon\n\tdba PalafinMenuIcon',
             marker='dba FinizenMenuIcon')
insert_after('gfx/icons.asm',
             'EspathraIcon: INCBIN "gfx/icons/espathra.2bpp"',
             '\nFinizenIcon: INCBIN "gfx/icons/fish.2bpp" ; TODO: gfx/icons/finizen.png'
             '\nPalafinIcon: INCBIN "gfx/icons/dewgong.2bpp" ; TODO: gfx/icons/palafin.png',
             marker='FinizenIcon:')
insert_after('gfx/menu_icons.asm',
             'EspathraMenuIcon: INCBIN "gfx/menu_icons/espathra.2bpp"',
             '\nFinizenMenuIcon: INCBIN "gfx/menu_icons/fish.2bpp" ; TODO: gfx/menu_icons/finizen.png'
             '\nPalafinMenuIcon: INCBIN "gfx/menu_icons/dewgong.2bpp" ; TODO: gfx/menu_icons/palafin.png',
             marker='FinizenMenuIcon:')

# ---------------------------------------------------------------- footprints
insert_after('gfx/footprints.asm', 'INCBIN "gfx/footprints/252.1bpp" ; ESPATHRA',
             '\nINCBIN "gfx/footprints/252.1bpp" ; FINIZEN'
             '\nINCBIN "gfx/footprints/252.1bpp" ; PALAFIN',
             marker='; FINIZEN')

# ---------------------------------------------------------------- pics
insert_after('gfx/pics.asm',
             'EspathraBackpic:  INCBIN "gfx/pokemon/espathra/back.2bpp.lz"',
             '\n\nSECTION "Pics 75", ROMX\n\n'
             'FinizenFrontpic: INCBIN "gfx/pokemon/finizen/front.animated.2bpp.lz"\n'
             'FinizenBackpic:  INCBIN "gfx/pokemon/finizen/back.2bpp.lz"\n'
             'PalafinFrontpic: INCBIN "gfx/pokemon/palafin/front.animated.2bpp.lz"\n'
             'PalafinBackpic:  INCBIN "gfx/pokemon/palafin/back.2bpp.lz"',
             marker='FinizenFrontpic:')

# ---------------------------------------------------------------- animations
insert_after('gfx/pokemon/anim_pointers.asm', '\tdba EspathraAnimation',
             '\n\tdba FinizenAnimation\n\tdba PalafinAnimation',
             marker='dba FinizenAnimation')
insert_after('gfx/pokemon/anims.asm',
             'EspathraAnimation:  INCLUDE "gfx/pokemon/espathra/anim.asm"',
             '\nFinizenAnimation:  INCLUDE "gfx/pokemon/finizen/anim.asm"'
             '\nPalafinAnimation:  INCLUDE "gfx/pokemon/palafin/anim.asm"',
             marker='FinizenAnimation:')
insert_after('gfx/pokemon/idle_pointers.asm', '\tdba EspathraAnimationIdle',
             '\n\tdba FinizenAnimationIdle\n\tdba PalafinAnimationIdle',
             marker='dba FinizenAnimationIdle')
insert_after('gfx/pokemon/idles.asm',
             'EspathraAnimationIdle:  INCLUDE "gfx/pokemon/espathra/anim_idle.asm"',
             '\nFinizenAnimationIdle:  INCLUDE "gfx/pokemon/finizen/anim_idle.asm"'
             '\nPalafinAnimationIdle:  INCLUDE "gfx/pokemon/palafin/anim_idle.asm"',
             marker='FinizenAnimationIdle:')
insert_after('gfx/pokemon/bitmask_pointers.asm', '\tdw EspathraBitmasks',
             '\n\tdw FinizenBitmasks\n\tdw PalafinBitmasks',
             marker='dw FinizenBitmasks')
insert_after('gfx/pokemon/bitmasks.asm',
             'EspathraBitmasks:  INCLUDE "gfx/pokemon/espathra/bitmask.asm"',
             '\nFinizenBitmasks:  INCLUDE "gfx/pokemon/finizen/bitmask.asm"'
             '\nPalafinBitmasks:  INCLUDE "gfx/pokemon/palafin/bitmask.asm"',
             marker='FinizenBitmasks:')
insert_after('gfx/pokemon/frame_pointers.asm', '\tdba EspathraFrames',
             '\n\tdba FinizenFrames\n\tdba PalafinFrames',
             marker='dba FinizenFrames')
insert_after('gfx/pokemon/johto_frames.asm',
             'EspathraFrames:  INCLUDE "gfx/pokemon/espathra/frames.asm"',
             '\nFinizenFrames:  INCLUDE "gfx/pokemon/finizen/frames.asm"'
             '\nPalafinFrames:  INCLUDE "gfx/pokemon/palafin/frames.asm"',
             marker='FinizenFrames:')

# ---------------------------------------------------------------- gfx source files
new_file('gfx/pokemon/finizen/anim.asm', '\tframe 0, 16\n\tendanim\n')
new_file('gfx/pokemon/finizen/anim_idle.asm', '\tframe 0, 16\n\tendanim\n')
new_file('gfx/pokemon/finizen/shiny.pal', '\n\tRGB 14, 28, 24\n\tRGB 04, 13, 17\n')
new_file('gfx/pokemon/palafin/anim.asm', '\tframe 0, 16\n\tendanim\n')
new_file('gfx/pokemon/palafin/anim_idle.asm', '\tframe 0, 16\n\tendanim\n')
new_file('gfx/pokemon/palafin/shiny.pal', '\n\tRGB 31, 21, 18\n\tRGB 16, 05, 09\n')

# ---------------------------------------------------------------- wild encounters
replace_once('data/wild/johto_water.asm',
             '\tmap_id ROUTE_40\n'
             '\tdb 6 percent ; encounter rate\n'
             '\tdbw 20, TENTACOOL\n'
             '\tdbw 15, CHINCHOU\n'
             '\tdbw 20, MANTINE',
             '\tmap_id ROUTE_40\n'
             '\tdb 6 percent ; encounter rate\n'
             '\tdbw 20, TENTACOOL\n'
             '\tdbw 15, CHINCHOU\n'
             '\tdbw 20, FINIZEN')
replace_once('data/wild/johto_water.asm',
             '\tmap_id ROUTE_41\n'
             '\tdb 6 percent ; encounter rate\n'
             '\tdbw 20, TENTACOOL\n'
             '\tdbw 20, MANTINE\n'
             '\tdbw 20, WIMPOD',
             '\tmap_id ROUTE_41\n'
             '\tdb 6 percent ; encounter rate\n'
             '\tdbw 20, TENTACOOL\n'
             '\tdbw 20, MANTINE\n'
             '\tdbw 20, FINIZEN')

# --------------------------------------------------- WRAM headroom for 2 more species
# wPokedexCaught / wPokedexSeen each grow by one byte at 481+ species, and WRAMX
# bank 1 had only 1 byte of slack. Reclaim 2 bytes of vanilla unused padding.
replace_once('wram.asm',
             'wUnusedTwoDayTimerStartDate:: db\n\tds 4\n',
             'wUnusedTwoDayTimerStartDate:: db\n\tds 2 ; was 4; 2 bytes reclaimed for the expanded Pokedex flag arrays\n')


# --------------------------------------------------- pre-existing build blocker
# gfx/pokemon/tsareena/anim.asm carries a stray "TsareenaAnimation:" label, which
# collides with the one gfx/pokemon/anims.asm already emits before the INCLUDE.
_t = 'gfx/pokemon/tsareena/anim.asm'
_txt = read(_t)
if 'TsareenaAnimation:' in _txt:
    _nl = nl_of(_txt)
    write(_t, _txt.replace('TsareenaAnimation:' + _nl, '', 1))
    changed.append(_t)
else:
    skipped.append(_t)


print('CHANGED (%d):' % len(changed))
for c in sorted(set(changed)):
    print('  ' + c)
if skipped:
    print('ALREADY DONE (%d): %s' % (len(set(skipped)), ', '.join(sorted(set(skipped)))))
