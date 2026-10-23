# Crimson Crystal Documentation Generator

This creates a searchable, mobile-friendly website from the `Pokemon-Crimson-Crystal` source files.

## Install and generate

Copy this folder into the root of your repository, then run in WSL:

```bash
cd ~/romhacks/Pokemon-Crimson-Crystal
python3 -m pip install -r crimson-crystal-docs/requirements.txt
python3 crimson-crystal-docs/generate_docs.py .
```

The website is generated in `docs/`.

Preview it:

```bash
cd docs
python3 -m http.server 8000
```

Open `http://localhost:8000`.

## GitHub Pages

Commit the `docs` folder, then go to **GitHub → Settings → Pages**. Select **Deploy from a branch**, choose `main`, and choose `/docs`.

The top navigation includes **Save Editor**, served from `docs/editor/`.
Build it with `pnpm build:website` in `crimson-editor/` and verify it with
`pnpm test:website`. Commit and push that output with the documentation pages.
The documentation generator preserves the editor output. Keep `docs/.nojekyll`
so Pages serves the editor's `_app` directory.

The initial site generates:

- Pokémon index with sprites pulled from `gfx/pokemon/*/front.png`
- Individual Pokémon pages
- Types, abilities, stats, BST, evolutions and level-up learnsets
- Move index and move detail pages
- Search and type filtering
- Wild encounter index for recognized pokecrystal-style encounter lines
- JSON exports and a build report
- A searchable Items page with all 254 items, including 54 TMs, seven HMs,
  acquisition locations, shop prices, wild held items and availability exceptions

Abilities are labeled **Ability 1**, **Ability 2** and **Ability 3** throughout
the Pokémon pages, change guide and save editor. Elm's reusable Ability Cap
lets players freely swap between a Pokémon's available ability slots.

Because your project has substantial custom engine work, the parser is intentionally tolerant. The first real run may expose a few custom data formats that need an additional parser rule; it will still generate the rest of the site.


## Pokédex ordering and forms

- Regional Pokédex numbers follow `data/pokemon/dex_order_new.asm`; internal species indexes remain tied to `constants/pokemon_constants.asm`.
- Phantump and Trevenant are regional #287 and #288, before the Duskull family. Their pages include supported level-up, machine, breeding and tutor moves, Phantump's level-32 evolution, abilities and nighttime Route 43 encounters. Horn Leech has its own move page and learner links.
- Enhanced Trevenant has 90 HP / 110 Attack / 95 Defense / 65 Sp. Atk / 84 Sp. Def / 56 Speed (500 BST); Original retains 85 / 110 / 76 / 65 / 82 / 56 (474 BST). Stantler and Wyrdeer learn Horn Leech at level 28 in both rules modes.
- `EGG` and the three `?????` engine records are ignored.
- The nine clone starter constants are omitted from the Pokédex grid and appear through a **Normal / Clone** toggle on the corresponding starter page.
- Animated or multi-frame PNGs are cropped to the first complete static front frame.

## October 20 balance adjustments

- Enhanced Mew has 100 in every base stat (600 BST), reduced from 720 BST.
- Enhanced Wigglytuff has 115 HP / 60 Attack / 75 Defense / 88 Sp. Atk /
  80 Sp. Def / 55 Speed. Its total remains 473; Original stats are unchanged.
- Ninetales learns Dazzling Gleam at level 32 and retains Moonblast at 60.
- Recover has 10 base PP, reduced from 20.
- Sizzlipede learns Leech Life at 36 instead of 56; Centiskorch at 40 instead
  of 60. The ancestor-aware reminder can also teach Centiskorch its family's
  level-36 placement.
- Wyrdeer learns Psyshield at 31 instead of 50, matching its evolution level.
- Venomoth learns Psychic at 38 instead of 55.
- Meganium learns Giga Drain directly at 40 instead of 60.
- Magmortar learns Dark Pulse at 46, adding a second Mega Launcher attack
  alongside Aura Sphere at 49.

Learnsets and move PP are shared by Original and Enhanced rules. The two
stat adjustments above change Enhanced BaseData only.

## Front and back sprite colors

Backsprites use the front sprite's exact authored colors and palette slots,
including alternate forms, starter clones, Unown letters and player artwork.
Finizen and Palafin retain separate dorsal blue palettes because their
front-only pink/red markings are absent from the back view. Their shared blue
colors still match the fronts. Normal and shiny battles use the corresponding
palette slots; the docs show the normal PNG artwork.

Check all sprite pairs with Pillow and the project's RGBDS 0.5.2 compiler:

```bash
make audit-pokemon-back-colors BATTLE_TEST_PYTHON=.venv/bin/python
```

After building, verify that both ROMs contain the updated compressed artwork
and every normal/shiny palette record:

```bash
.venv/bin/python tools/audit_pokemon_back_colors.py --rom pokecrystal.gbc --rom pokecrystal_debug.gbc
```

To repair mismatched colors or palette indices after replacing artwork:

```bash
.venv/bin/python tools/audit_pokemon_back_colors.py --fix
make
.venv/bin/python crimson-crystal-docs/generate_docs.py .
```

The audit preserves poses, dimensions and transparency. It also repairs a
front image if its embedded palette puts black or white in a middle slot,
which would otherwise make both battle views display incorrect colors.


## Encounter coverage and safety

The generator parses:

- Johto and Kanto grass/cave tables
- Johto and Kanto Surf tables
- Bug-Catching Contest tables
- Headbutt and Rock Smash sets through `treemon_maps.asm`
- Fishing groups only where an explicit map-to-`FISHGROUP_*` link is found
- Grass and water swarm tables
- Morning, day and night slots
- Slot chances and encounter rates where the source format provides them

It never pairs Pokémon and locations by Pokédex number, file position, or a guessed
filename. Unknown species, unknown shared groups, and malformed rows are written
to `docs/data/build-report.json`.

After any game-data change, rerun:

```bash
source .venv/bin/activate
python crimson-crystal-docs/generate_docs.py .
git add crimson-crystal-docs docs
git commit -m "Update documentation"
git push
```

## Original / Enhanced rules and the Changes page

Each Pokémon page compares the Original and Enhanced typings and six base stats,
including numerical differences and total stats. These values come from the same
tables the game loads for its new-game choices: `original_stats.asm` and the two
typing tables in `engine/pokemon/gameplay_rules.asm`. Custom species keep their
game-specific baselines, and starter clone comparisons appear in the existing
Normal / Clone panels.

The Changes tab lists all current stat and type differences from the modern
main games. Every stat redesign includes Original → Enhanced totals and a
table comparing all six base stats. Ability, move and evolution notes come
from `balance_changes.json`; stat notes use the Original baseline and current
Enhanced values. Record `before_level` for a move whose learning level changed.
The generator validates the resulting stats, ability slots and learnsets.
Abilities, moves and evolution changes apply to both rules choices.

Generation replaces generated files in place and preserves downloadable
files in `docs/`.

## Game Updates guide

`updates.html` is the separate Game Updates tab. It groups the game’s changes
from original Crystal by topic, with one entry per rule and explicit labels
for modern rules, custom changes and special exceptions. Search and filters
also search the collapsible move, ability and added-Pokémon directories.

`game_updates.json` contains the reviewed gameplay notes and their source paths.
Update the appropriate note whenever its game behavior changes. The generator
checks that every referenced source exists and that entry IDs are unique.
`gen2_baseline.json` contains the original Crystal move table and species list,
derived from pret/pokecrystal. Move comparisons are computed from that historical
baseline and the current ROM source, including changes to move effect classes.
Ability descriptions and holders, added Pokémon, and all directory links are
generated from the current game data. Builds do not require network access.

Keep Pokémon-specific redesigns in the Pokémon Changes tab; keep general game
rules, modernization and custom exceptions in Game Updates. Both pages link
to each other, and every generated page includes both navigation tabs.

## Item locations

The Items navigation tab opens `items.html`. It covers every named item,
including TMs, HMs, berries, fossils, evolution items, balls and key items.
Search by item, Pokémon, place or method, and filter by category or availability.
Each item has a direct anchor such as `items.html#muscle_band`.
The complete machine-readable catalog is exported to `docs/data/items.json`.

The catalog reuses `tools/generate_item_locations.py` for reviewed TM and
held-item sources, then adds other acquisition systems in `item_catalog.py`.
It distinguishes Mystery Gift connectivity, trainer theft, wild held-item
hunting, temporary activity balls, and ordinary world sources. Refund scripts
are not counted as fresh sources. Placement and item IDs come from the ROM
source; player-facing notes describe where to go and what to do.

The website build also refreshes the [TM and held-item list](../ITEM_LOCATIONS.md).
Run `python tools/generate_item_locations.py` to refresh just that list without
rebuilding the site. Validate item coverage with
`python tools/test_item_catalog.py`.
