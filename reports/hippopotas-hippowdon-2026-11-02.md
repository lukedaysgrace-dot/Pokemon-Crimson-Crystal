# Hippopotas and Hippowdon integration

Added the family at regional Dex **#235–236**, after Donphan. Internal indexes
**501/502** append without changing existing species indexes, save format 5,
or the 63-byte seen/caught fields. There are now 502 internal records and 501
visible entries. Shifted regional-number receipts and the affected existing
family regressions/documentation were updated.

## Game data

- Ground typing, official base stats in both stats modes, Slow growth, equal
  gender ratio, Field egg groups, 30 hatch cycles, catch rates 140/60, and
  experience yields 66/184.
- Sand Stream / Sand Force / Strong Jaw follow Lumi 3.0's PersonalTable slots.
- Hippopotas evolves at level 34, respecting Everstone and cancellation.
- Route 45: Hippopotas in the 10% morning/day slot at levels 28/30; Hippowdon
  in the 5% daytime slot at level 38. Replaced slots remain available elsewhere.
- Names, both Dex pages, heights, weights, footprints, ancestry, egg lists,
  machines, both tutors, alphabetical/regional sorting, and EZChat registration.
  Hippowdon's category is shortened to HEAVY to fit the ten-cell category field.

Learnsets use the pinned Luminescent Platinum **3.0** progression plus natural
Amnesia from Legends: Z-A. Other implemented historical moves use the existing
machine, breeding, utility tutor and Blackthorn tutor routes. All **51/56**
supported moves are obtainable; unimplemented source moves are recorded in
`tools/testdata/hippopotas_hippowdon.json`. The full historical receipt includes
both species and exact upstream move provenance. Every existing species' final
level-up, machine, egg, utility, tutor and obtainable-move routes were compared
with the working tree captured before this task and remain unchanged.

## Presentation

Used the supplied front/back pictures and two-frame menu sprites. Front sprites
have one supplied frame, so animation scripts reference only frame zero. The
extra `hippowdon/back 2.png` is preserved; the regular supplied `back.png` is used.
The normal front/back palettes share consistent slot ordering. Three stray
fifth-color Hippopotas front pixels were merged into its existing brown shade
to meet the four-color hardware limit. Original/normalized hashes are recorded.

Shiny palettes adapt official male shiny sprite references to pale yellow/olive
for Hippopotas and olive/dark green for Hippowdon. Each has an authored,
three-channel Game Boy PSG cry; these are adaptations, not sampled official audio.

The palette bank needed two more bytes. Two nearby palette-dispatch jumps were
shortened from `jp` to `jr`, retaining their targets and all data. `bank2` is now
exactly full. ROM0 and the cartridge-header reservation are unchanged. Both new
learnset records share the bank of their 16-bit evolution/attack pointers.

Native battle pictures are in `_artifacts/hippos/battle-sprites.png`; release-ROM
cry recordings are `_artifacts/hippos/hippopotas.wav` and `hippowdon.wav`.

## Validation

| Check | Result |
| --- | --- |
| RGBDS 0.5.2 release and debug ROM builds | Pass |
| Required `make audit-static` | Pass |
| Full battles plus all-move/effect/ability sweeps | **3,754/3,754 pass** |
| New family native regression | **300 checks per ROM; pass** |
| Focused family battles | **8/8 pass** |
| Exact native normal/shiny front/back tile and palette checks | **16/16 pass** |
| Release-ROM cries | Both produce audio, return, and release channels |
| Full-roster compiled learnsets/tutor menus | 10,540 checks; pass |
| Full-roster compiled breeding | 11,558 checks; pass |
| Native evolution sweep | 281 rows, 1,926 checks; pass |
| Existing Mienfoo/Mienshao and roster replacement regressions | Both ROMs pass |
| Existing Phantump/Trevenant regression | 61 checks; pass |
| Dex save upgrade | 43 checks per ROM; pass |
| Game-data audit | 45,828 checks; pass |
| Save-layout audit | 185 checks; pass |
| New front/back source palettes | No mismatches or repairs required |
| Both compiled ROMs' complete palettes and live backsprite data | Pass |
| Documentation generation | 501 entries; zero warnings/unparsed rows |
| Whitespace validation | `git diff --check` passes |

`make test-hippos` runs both native family regressions, focused battles, and the
native graphics comparisons. General logs are `.tmpbuild/hippo-*.log`; the
full initial audit collection is `.tmpbuild/hippo-validation/`. The initial
collection's hippo/Dex-layout/shifted-number failures were corrected and the
affected checks rerun successfully, as recorded above.

Three pre-existing broader-audit limitations remain: Jirachi's source backsprite
palette differs from its front palette; `audit_mae_animations.py` rejects its
saved animation-constants dependency hash; and `audit_sour_apple_completeness.py`
requires the absent `.tmpbuild/mae-sour-apple` checkout. They were also recorded
in the pre-task `.tmpbuild/roster/` audit logs. No unrelated artwork or game
dialogue was changed.

## References

- [Lumi 3.0 data, pinned revision](https://github.com/TeamLumi/luminescent-team/tree/943b9efb70e4ead902603d3572982dcd9bcce6b2/__gamedata/gamedata3.0)
- [Mainline move history, pinned revision](https://github.com/smogon/pokemon-showdown/tree/1242c1e2d9763ba5b85d33f13aecb89bae19ae3d/data)
- [Hippopotas data](https://pokemondb.net/pokedex/hippopotas)
- [Hippowdon data](https://pokemondb.net/pokedex/hippowdon)
- [Official-color sprite references](https://github.com/PokeAPI/sprites/tree/master/sprites/pokemon/shiny)
- [Footprint source](https://github.com/rh-hideout/pokeemerald-expansion/tree/master/graphics/pokemon)
