# Shucks source artwork

Pinned online source: [Rangi42/polishedcrystal](https://github.com/Rangi42/polishedcrystal)
at commit `435bb9061592246dec0c5c5cf813389e7d17de4a`.

The three PNGs and their matching block/attribute files were downloaded from
that repository, not copied from this project's existing tilesets:

- `gfx/tilesets/game_corner.png`: counter, stools, round tables, cabinet.
- `gfx/tilesets/hotel.png`: wall and extra cabinet.
- `gfx/tilesets/traditional_house.png`: wood floor.
- Matching `data/tilesets/*_metatiles.bin` and `*_attributes.bin` files identify
  the original graphic arrangement, colors, and flips.

Credit the Polished Crystal team, Rangi42, and the original Pokémon Gold,
Silver, and Crystal artists at Game Freak. The upstream credit list is retained
as `CREDITS.md`; it additionally credits JaceDeane and Luna for overworld tiles.
These are Pokémon fan-project assets, not an independently licensed CC0 pack.
No new permission or ownership claim is made for the upstream art.

The pool table, cue rack, bottle details, taps, curtain, speakers, stage fascia,
stairs, dance floor and entrance mat are additions made for this map. They are
encoded in `tools/build_shucks.py` and use the same four-shade pixel grid.
The rejected generic Game Boy tavern pack is not used in this map.

Each exact downloaded input's SHA-256 is recorded in
`maps/Shucks.validation.json`. `commit.txt` records the upstream revision.
