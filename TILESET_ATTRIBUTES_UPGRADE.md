# Tileset engine upgrade — Polished Crystal block attributes

This project now uses Polished Crystal's tileset system instead of vanilla
pokecrystal's. Every Polished Crystal tileset has been re-imported **1:1,
pixel-perfect** (colors, X/Y flips, and priority included) and all 36
original tilesets were migrated automatically with identical appearance.

## What changed

- **Per-block attributes.** Each block now has `data/tilesets/*_attributes.bin`
  alongside `*_metatiles.bin`: 16 attribute bytes per block (palette, VRAM
  bank, X flip, Y flip, priority). Palette maps (`*_palette_map.asm`) are gone.
- **Up to 352 tiles per tileset.** Graphics load in three chunks:
  - `<name>.vram0.png` → VRAM $0:00–5F (96 tiles; $60–7F stays reserved for the font)
  - `<name>.vram1.png` → VRAM $1:00–7F (128 tiles)
  - `<name>.vram2.png` → VRAM $1:80–FF (128 tiles)
- **Maps renamed** `maps/*.blk` → `maps/*.ablk` (same data, new extension).
- Engine changes live in `home/map.asm` (LoadTilesetGFX, LoadMetatiles /
  LoadMetatileAttributes, scroll paths), `engine/overworld/load_map_part.asm`,
  `engine/overworld/map_objects.asm` (sprites are no longer hidden behind
  bank-1 tiles), `engine/tilesets/mapgroup_roofs.asm` (roof tilesets are now a
  list that includes the Polished johto outdoor tilesets), `wram.asm`,
  `data/tilesets.asm`, `gfx/tilesets.asm`, and `pokecrystal.link`.

## Editing maps and tilesets

Use **Polished Map++** (not regular Polished Map):
https://github.com/Rangi42/polished-map/tree/plusplus

In Options, enable **512 Tiles** (default order: $1:80-FF before $0:80-FF).
Open maps via the `.ablk` files. Each tileset's full image is
`gfx/tilesets/<name>.png`; in Edit Block mode you can set each tile's palette,
X/Y flip, bank, and priority.

**Do not place tiles in positions $60–$7F of the first 128 tiles** (rows 13–16
of the image) — that VRAM range still belongs to the text font.

## After editing a tileset image

Run:

    python3 tools/split_tileset_gfx.py <tileset_name>
    make

The script regenerates the `vram0/1/2` chunk PNGs the build actually compiles.
(If you add tiles to a chunk that used to be empty, also update the tileset's
`GFX1`/`GFX2` entry in `gfx/tilesets.asm` + `data/tilesets.asm` — it will be
pointing at a shared `TilesetEmpty*GFX` placeholder.)

## Animations

Water ($0:14) and flowers ($0:03) animate in the imported tilesets, matching
Polished Crystal's tile positions. Polished Crystal's extra animations
(waterfalls, whirlpools, forest trees, game-corner lights, rain) are not yet
ported — those tiles show their static art.
