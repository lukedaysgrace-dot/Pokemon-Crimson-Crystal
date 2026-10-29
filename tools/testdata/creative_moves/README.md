# Creative move sprite source

`tart-apple.png` is the Tart Apple inventory sprite from
[msikma/pokesprite](https://github.com/msikma/pokesprite), downloaded from
[items/evo-item/tart-apple.png](https://raw.githubusercontent.com/msikma/pokesprite/master/items/evo-item/tart-apple.png).
The Pokémon game artwork belongs to its respective rights holders; this is
source attribution, not a claim of an original or public-domain sprite.

`python3 tools/build_creative_move_assets.py` draws the creative sprites at
native resolution. The apple is generated as a 24px and a 32px shaded body
(soft highlight, red body, maroon outline and dithered shadow) plus separate
leaf-and-stem tiles that the OAM data draws with the next object palette
(`BATTLEANIM_OAM_NEXT_PAL`), so the leaf stays green over the red body.
`tart-apple.png` is no longer used by the build and is kept only as the
original reference. The script also draws the 48px steel mallet, two 16px
beetle frames for Infestation and Apple Acid's acid bubbles (small, medium,
large and burst). Generated PNGs stay in native tile-column format under
`gfx/battle_anims/`; the normal build creates their 2bpp data.
