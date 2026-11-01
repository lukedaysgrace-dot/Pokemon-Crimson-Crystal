# Mienfoo and Mienshao implementation and validation

**Follow-up:** The November 1 customization adds Crimson Fighting/Fairy typing,
Serene Grace, Mienshao's Enhanced 115 Speed / 85 Special Attack, and requested
Fairy/coverage moves. Original typing and stats are preserved. See
[the current follow-up](mienfoo-mienshao-fairy-2026-11-01.md).

Implemented the complete family as regional Pokédex **#262–263**, following
Lucario. Internal species indexes **499–500** preserve every existing species
index. Save format 5 and the 63-byte seen/caught fields remain the same size.

## Game data and availability

- Pure Fighting typing; official base stats, experience yields, catch rates,
  equal gender ratio, Medium Slow growth and 25 egg cycles.
- Field / Human-Like egg groups; Inner Focus, Regenerator and Reckless slots.
- Mienfoo evolves at level 50, with normal Everstone/cancellation behavior.
- Mienfoo: Mt. Mortar 1F Inside, level 30, 10% slot at every time of day.
- Mienshao: Mt. Mortar 2F Inside, level 50, 1% daytime slot.
- Two-page dex descriptions, proper height/weight and imported footprints.
- Supplied animated front/back sprites, normal/shiny palettes and menu icons.
- Dedicated Game Boy cries imported from Polished Coral.
- All species-indexed graphics, name, cry, dex, ancestry, egg and tutor tables;
  alphabetic sorting and EZChat's correct Japanese-name group. The latter avoids
  overflowing the existing miscellaneous bucket's 8-bit word count.

Learnsets combine supported Scarlet/Violet natural progression with older
Meditate, DoubleSlap, Swift and Jump Kick. Low Kick at level 12 gives an early,
reliable STAB attack. Force Palm, U-turn, Drain Punch and Aura Sphere arrive at
25, 30, 35 and 45. High Jump Kick remains level 60 for Mienfoo and 66 for Mienshao.
Historical egg moves are Baton Pass, Endure, Knock Off, Low Kick and Vital Throw.
Machines and existing tutors provide every other implemented reference move;
Mienshao's evolved-only options include Blaze Kick, Triple Axel and Vacuum Wave.
Unimplemented reference moves are recorded rather than assigned invalid IDs.

See [the player/developer notes](../docs/mienfoo-mienshao.md) and the independently
source-backed [family receipt](../tools/testdata/mienfoo_mienshao.json).
The full-roster historical and attacking-review receipts include both species.
Generated dex pages, move learners, encounter pages, indexes and Game Updates
include the additions. Documentation generation reports no warnings or unparsed
rows.

## Validation

| Check | Result |
| --- | --- |
| RGBDS 0.5.2 release and debug builds | Pass |
| New family native regression | 180 checks per ROM; pass |
| Focused family battles | 8/8 pass |
| Full battle suite | 2,095/2,099 pass; four baseline failures below |
| Native full-roster reminder, machine and tutor checks | 10,597 checks; pass |
| Native egg inheritance | 11,576 checks; pass |
| Native evolution sweep | 281 evolution rows, 1,927 checks; pass |
| Save upgrade | 43 checks per ROM; pass |
| Existing Phantump/Trevenant regression | 61 checks per ROM; pass |
| Historical source and breeding audits | All 500 species; pass |
| Game-data audit | 45,743 checks; pass |
| Save-layout audit | 185 checks; pass |
| Front/back palette audit | 530 pairs; no mismatches or repairs |
| Compiled normal/shiny palette and back graphics audit | Both ROMs pass |
| Real release-ROM cry playback | Both emit audio, terminate and release channels |
| Rendered battle presentation | Both species inspected as player and opponent |
| Native Bill's PC | Normal/shiny icons and storage inspected for both species |
| Whitespace validation | `git diff --check` passes |

The new native regression tests all eight gameplay-rules combinations,
high-index dex flags, proper Low Kick/Grass Knot weights, evolution boundaries,
blocked evolution, preserved moves, correct tutor separation, machine access,
reminder timing and egg inheritance from either parent slot. `make test-mienfoo`
runs the permanent family regression and focused battle cases.

## Existing failures and tooling limits

An isolated build of the original `HEAD`, without this addition, reproduces:

- The same four battle failures: player/enemy **KLUTZ** and **TRACE_KLUTZ**
  entry-item Berry checks. The baseline filtered run has 94 passes and the same
  four failures.
- The same six Hydrapple resource errors: its animation references frames 4–7,
  while its generated front graphics provide only three non-base frame pointers.
  This causes `make audit-static` to stop at `audit_resources.py`. The preceding
  static checks pass; the subsequent icon/map/trainer sprite audits also pass
  when run individually.

Two optional animation audits also have existing setup/receipt limits:
`audit_mae_animations.py` rejects the saved dependency hash for the unchanged
`constants/battle_anim_constants.asm`; `audit_sour_apple_completeness.py` expects
the absent `.tmpbuild/mae-sour-apple` upstream checkout. No unrelated animation
code or game dialogue was changed.

The save-editor extractor was also attempted. It currently stops on the existing
item expression `ITEM_FIXED_MAIL_RUNTIME + 0`, before exporting a profile.
Existing editor profiles were therefore not regenerated as part of this change.

Detailed local logs, the two cry recordings and rendered battle/PC captures are
in `.tmpbuild/mienfoo-validation/`. Full-suite and required-static logs are
`.tmpbuild/mienfoo-battles.log` and `.tmpbuild/mienfoo-static-final.log`.

## Online references

- [Mienfoo stats, evolution, egg groups and moves](https://pokemondb.net/pokedex/mienfoo)
- [Mienshao stats, evolution, egg groups and moves](https://pokemondb.net/pokedex/mienshao)
- [Mienfoo Scarlet/Violet data cross-check](https://www.serebii.net/pokedex-sv/mienfoo/)
- [Pinned Pokémon Showdown learnsets](https://github.com/smogon/pokemon-showdown/blob/f7d73fdb20909885b70c4463f3878cf37875068d/data/learnsets.ts)
- [Dedicated cry source](https://github.com/pkmncoraldev/polishedcoral/blob/2191e0eaad134b4cf006709be82f7362cf70248c/audio/cries_2.asm)
- [Footprint source](https://github.com/rh-hideout/pokeemerald-expansion/tree/master/graphics/pokemon)
