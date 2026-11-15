# Cerulean Gym source artwork

Cerulean Gym is an indoor swimming pool drawn with Pokémon Trading Card Game
tiles. `tools/build_cerulean_gym.py` reads only the pinned copies in this
folder, so later edits to the project's live tilesets cannot change the gym.

- `tcg1_water_club.png`: Pokémon Trading Card Game (GBC) Water Club tileset,
  copied from [pret/poketcg](https://github.com/pret/poketcg)
  `src/gfx/tilesets/waterclub.png` (commit 3054a446). Pool water and sparkles,
  pool curb, pool ladders, wooden deck parquet and the back wall.
- `tcg2_water_club.png`: Pokémon Card GB2 Water Club tileset, copied from
  [pret/poketcg2](https://github.com/pret/poketcg2)
  `src/gfx/tilesets/water_club.png` (commit 9c82f1de). The blue entrance mat.
- `crystal_port.*`: this project's Port tileset (copied 2026-11-14), for the
  two gym statues (block $32).

Palettes are the TCG games' own (`WaterClubPal` in poketcg and `Palette01A` in
poketcg2), recorded in the builder. Each input's SHA-256 is recorded in
`maps/CeruleanGym.validation.json`; the preview is written to
`_artifacts/cerulean-gym/preview.png`.

Original art by Hudson Soft / Creatures / Game Freak; these are Pokémon
fan-project assets.
