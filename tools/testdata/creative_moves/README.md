# Creative move sprite source

`tart-apple.png` is the Tart Apple inventory sprite from
[msikma/pokesprite](https://github.com/msikma/pokesprite), downloaded from
[items/evo-item/tart-apple.png](https://raw.githubusercontent.com/msikma/pokesprite/master/items/evo-item/tart-apple.png).
The Pokémon game artwork belongs to its respective rights holders; this is
source attribution, not a claim of an original or public-domain sprite.

`python3 tools/build_creative_move_assets.py` converts this source into
24px and 32px, three-color apple frames. It also draws a native 48px steel
mallet with a beveled head, rivets and wrapped grip, and creates two native
16px beetle frames for Infestation. Generated PNGs stay in native tile-column
format under `gfx/battle_anims/`; the normal build creates their 2bpp data.
