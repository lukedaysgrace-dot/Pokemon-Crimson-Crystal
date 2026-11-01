# Mienfoo and Mienshao

Mienfoo and Mienshao are regional Pokédex **#262 and #263**, immediately
after Lucario. Internal indexes **499 and 500** append to the roster, preserving
existing species IDs. Both fit in the existing 63-byte seen/caught fields;
the save format and SRAM layout are unchanged.

**Mienfoo appears at level 30 in Mt. Mortar 1F Inside**, in the 10% slot
morning, day and night. **Mienshao appears at level 50 in Mt. Mortar 2F Inside**,
in the 1% daytime slot. Mienfoo evolves at **level 50**; Everstone and cancelling
the evolution work normally.

Both are **Fighting/Fairy in Crimson's Enhanced typing**, and pure Fighting
with Original typing. Their ability slots are **Serene Grace / Regenerator /
Reckless**. Mienshao has **115 Speed and 85 Special Attack** with Enhanced stats;
Original stats retain **105 Speed and 95 Special Attack**. Its base-stat total
remains 510. Mienfoo's stats remain canonical. Catch rates, experience yields,
Medium Slow growth, equal gender ratio, 25 hatch cycles and **Field / Human-Like**
egg groups follow the main series.
The Pokédex includes custom two-page descriptions based on their mountain
training and rapid martial arts, correct height/weight, and species footprints.

The level-up progression follows Scarlet/Violet's supported moves, with older
natural Meditate, DoubleSlap, Swift and Jump Kick retained for variety. Low Kick
at level 12 is an authored timing choice for reliable early Fighting STAB;
it is an official machine move for both species. Force Palm arrives at 25,
U-turn at 30, Drain Punch at 35 and Aura Sphere at 45. Mienfoo learns High Jump
Kick at 60 and Mienshao at 66. The reminder retains pre-evolution access.

Both learn **Pixie Punch at 7, Play Rough at 32 and Spirit Break at 48**, providing
physical Fairy progression from early STAB to stronger martial/spiritual attacks.
**Iron Head and Zen Headbutt** are additional TM options. **Rock Slide and Poison
Jab** remain Blackthorn tutor options; **Force Palm** remains natural at level 25.
These requested custom additions are recorded separately from canonical history.
Move powers, categories and secondary-effect percentages are unchanged; Serene
Grace uses the existing ability engine to double eligible effect chances.

Supported historical egg moves are **Baton Pass, Endure, Knock Off, Low Kick
and Vital Throw**. Real donor routes are verified without treating the egg tutor
as a breeding source. Existing TMs/HMs, Goldenrod utility tutoring and Blackthorn
teaching supply all remaining implemented main-series and Lumi moves, including
Close Combat, Acrobatics, Stone Edge and Grass Knot. Mienshao also gains its
supported Blaze Kick, Triple Axel and Vacuum Wave through Blackthorn. Moves
the engine does not implement are listed in the import receipt.

Supplied front/back sprites, animation frames, normal/shiny palettes and menu
icons are used directly. Dedicated cries come from
[Polished Coral](https://github.com/pkmncoraldev/polishedcoral/blob/2191e0eaad134b4cf006709be82f7362cf70248c/audio/cries_2.asm).
Footprints come from
[pokeemerald-expansion](https://github.com/rh-hideout/pokeemerald-expansion/tree/master/graphics/pokemon).
Main-series data was checked against [Mienfoo](https://pokemondb.net/pokedex/mienfoo)
and [Mienshao](https://pokemondb.net/pokedex/mienshao). Move provenance uses the
project's pinned Pokémon Showdown and Lumi sources. The family receipt is
`tools/testdata/mienfoo_mienshao.json`; the roster-wide historical receipt also
includes both species.

`make test-mienfoo` builds both ROMs and checks native species lookup, all eight
gameplay-rules combinations, evolution and its blockers, weight lookup, dex
flags, move reminder timing, machine access, tutor separation and egg inheritance.
The battle cases cover both species and their three abilities. Existing
full-roster learnset, breeding, evolution, save and graphics checks also include
the new family.
