# Shucks source artwork

Shucks is drawn in Gold/Silver/Crystal style. `tools/build_shucks.py` reads only
the pinned `crystal_*` copies in this folder; it never reads or modifies the
project's live tilesets, so later edits to those tilesets cannot change Shucks.

Vanilla Crystal pieces (copied from this project's `gfx/tilesets/` and
`data/tilesets/` on 2026-11-12):

- `crystal_game_corner.*`: Goldenrod Game Corner's inset floor tiles.
- `crystal_players_house.*`: wood wall panelling, fridge, stove/sink unit
  and radio.
- `crystal_traditional_house.*`: the Ecruteak Dance Theater stage boards.
- `crystal_house.*`: potted-palm fronds and the red exit rug.

Hand-pixelled in `tools/build_shucks.py` to match (4 shades, black outlines):
bottle shelves, beer taps and mugs, bar counter, shell sign, chalk menu, velvet
curtain, speaker stacks, marquee footlights and steps, dance floor,
pool table, cue rack, cloth-topped cafe tables, side-on cafe chairs (sized so
a seated NPC sprite fits on them), bar stools and terracotta plant pots.

Colour works like Crystal's interiors: every palette that touches the floor
shares the floor's two colours and black, and the builder assigns each 8x8
tile whichever palette holds all of its colours (it stops with an error naming
the cell if none does). Each input's SHA-256 is recorded in
`maps/Shucks.validation.json`; previews are written to `_artifacts/shucks/`.

Original art by Game Freak; these are Pokémon fan-project assets.
