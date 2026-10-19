# Phantump, Trevenant and Horn Leech

Phantump and Trevenant are regional Pokédex **#287 and #288**, immediately
before the Duskull family. Their internal indexes are 497 and 498 so existing
species indexes stay unchanged. Jirachi remains the last regional entry.

Both appear on **Route 43 at night**: Phantump at level 35 in the 10% slot,
and Trevenant at level 36 in the 1% slot. Phantump evolves into Trevenant at
**level 32**. An Everstone prevents evolution. Trevenant is offered Shadow Claw on evolution,
including the usual replacement/decline choices for a full moveset.

Both use their main-series Ghost/Grass typing, stats, catch rates, gender
ratio, Medium Fast growth, 20 hatch cycles, Grass/Amorphous egg groups, and
Natural Cure / Frisk / Harvest ability slots. Supported historical main-series
moves are distributed between level-up, machines, breeding, the reminder and
the existing tutors. Phantump's implemented egg moves are Disable and Sucker
Punch. Unimplemented reference moves are recorded in the canonical receipt.

Front/back animations, normal/shiny palettes and menu icons use the supplied
artwork. Trevenant's backsprite palette slots were normalized to its front
palette. Dedicated cries are imported from Polished Coral, rather than reusing
another species' cry. Footprints come from
[pokeemerald-expansion](https://github.com/rh-hideout/pokeemerald-expansion/tree/master/graphics/pokemon).

Horn Leech is a 75-power physical Grass contact move, with 100% accuracy and
10 PP. It restores half the damage dealt, rounded up, using the existing
draining-move engine. Both species learn it at level 28. Triage recognizes it.
The script and graphics are ported from
[Polished Coral](https://github.com/pkmncoraldev/polishedcoral/blob/2191e0eaad134b4cf006709be82f7362cf70248c/data/moves/animations.asm#L555),
with local object IDs and palette adapted to this engine. Its dedicated graphic
is `gfx/battle_anims/horn_leech.png`; the script is in `animations6.asm`.

The two added species grow the caught/seen bitfields by one byte each. Save
format 4 automatically upgrades valid version-3 primary and backup saves,
inserting zero flags while preserving party, Day-Care, roamer and conversion
data. Two unused portrait-state bytes were removed to fit WRAM bank 1; SRAM
padding keeps the checksum and later save sections at their former addresses.

Main-series movepool provenance is pinned to Pokémon Showdown revision
`f7d73fdb20909885b70c4463f3878cf37875068d`, matching the project's existing
pre-Z-A reference. The import receipt is `tools/testdata/phantump_trevenant.json`.
The animation and cries use Polished Coral revision
`2191e0eaad134b4cf006709be82f7362cf70248c`.

The generated documentation includes both species pages, Horn Leech's move
page, Route 43 encounters and the Game Updates guide. The save editor's current
profile contains all 498 species and 440 moves, normal/shiny sprites, family
egg moves and the full Blackthorn tutor lists. Previous save profiles remain
available. Editor round-trip checks cover both new species, Horn Leech,
all three ability slots and the expanded caught/seen flags.

Run `make test-phantump BATTLE_TEST_PYTHON=python3` for compiled species,
evolution-move, save-upgrade and Horn Leech battle regressions. The existing
learnset/breeding audits, evolution sweep and palette audit cover the additions.
`tools/battletest/mae_animation_checks.py --moves HORN_LEECH` checks both
animation directions and screen/palette restoration.

The full game-data audit currently reports unrelated existing Cerulean Cave
map/count/collision issues. Its species, EZChat and text checks pass.
