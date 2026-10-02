# Crimson Crystal — implemented learnset variety pass

All **440 reviewed species–move additions** are applied, including P1, P2, P3 and deliberate custom additions. The original review remains the design rationale; this document records the current acquisition routes.

Changed **245 level-up lists**, **34 TM/HM/elemental tutor compatibility lists**, and **17 egg-list blocks** (including the Squirtle clone mirror). The source roster still has 495 entries, including nine starter clones.

## Utility tutor

An always-available tutor now stands at **(6, 5) in Goldenrod’s PP Speech House**, charging **¥1000 per successful lesson**. It teaches Substitute, Sleep Talk, Reflect, Light Screen and Thunder Wave with explicit species compatibility. Cancelling, choosing a known move, or having no teachable moves does not charge money. Compatibility is separate from the TM/HM bitfields; item numbering and save structure are unchanged.

| Move | Eligible unique Pokémon |
|---|---:|
| Substitute | 475 |
| Sleep Talk | 475 |
| Reflect | 127 |
| Light Screen | 155 |
| Thunder Wave | 143 |

The tutor keeps Ditto, Wobbuffet, Wynaut and Smeargle’s restricted identities. Existing level-up access remains useful for the defining support moves, so those builds do not require a paid tutor.

## Access and timing repairs

All eight Eeveelutions can re-obtain Heal Bell at level 37. Direct reminder entries preserve Mach Punch on Hitmonlee, Hitmontop and Electivire; Aqua Jet on Golisopod, Overqwil and Mantine; Ice Shard on Alolan Ninetales; Giga Drain on Breloom; Reflect/Light Screen on Xatu; Recover/Substitute on Flapple; and Wish on Togekiss.

Alolan Raichu now learns Volt Switch at **32 rather than 76**. Magmar learns Belly Drum at **44**, providing a natural Magby donor in this roster; Magby also receives Belly Drum and Mach Punch in its family list. The listed later payoff moves were retained where the review found them intentional.

Mesmeria retains Jynx’s new Focus Blast/Encore access, Gorochu retains regular Raichu’s Volt Switch/Focus Blast, and the developed custom Bloodmoon bear stage receives Calm Mind/Hyper Voice. These prevent the new independent-stage options from disappearing after evolution.

The broader audit found three pre-existing availability gaps, also repaired: **Bide on Shuckle at 12**, **Psywave on Grumpig at 1**, and **SonicBoom on Voltorb at 15**. These have ordinary older-game precedent in the downloaded comparison data.

## Family list changes

The highlighted lists were curated for useful choices. The added machine/tutor moves in family lists are intentional Crimson Crystal distribution choices. Every original level-up move and compatibility flag was preserved. Removed low-impact or redundant egg choices are listed below; the tutor still has ample capacity.

| Root | Added | Removed |
|---|---|---|
| Chinchou | Heal Bell, Scald, Volt Switch | Mist, Psybeam, Screech |
| Eevee | Heal Bell | None |
| Girafarig | Wish | None |
| Growlithe | Morning Sun | None |
| Grubbin | Sticky Web, Volt Switch | Harden, Screech |
| Impidimp | Light Screen, Reflect, Thunder Wave | Spite |
| Joltik | Giga Drain, Sticky Web | Cross Poison, Faint Attack, Pin Missile |
| Magby | Belly Drum, Mach Punch | None |
| Mareep | Agility | None |
| Onix | Head Smash | None |
| Shuckle | Sticky Web | Acid Armor, Defense Curl, Sand Attack |
| Shuppet | Encore, Swords Dance, Taunt | Astonish, Foresight |
| Spinarak | Lunge | None |
| Squirtle | Dark Pulse, Flip Turn | Confusion, Flail, Foresight |
| Tangela | Leech Seed | None |
| Trapinch | Roost, U-turn | Flail, Fury Cutter, Gust |
| Squirtle Clone | Dark Pulse, Flip Turn | Confusion, Flail, Foresight |

## Every reviewed addition

“Level” indicates the current form’s direct reminder/level-up route. A family route is available to all forms mapped to that root; an additional direct level route is shown where useful. Compatibility flags use the existing TM/HM or elemental tutor. The broad utility distribution above extends beyond the 440 specifically selected assignments.

| Pokémon | Priority | Move | Applied route | Current source |
|---|---|---|---|
| Grimmsnarl | P1 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4935) |
| Grimmsnarl | P1 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4935) |
| Grimmsnarl | P1 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4935) |
| Lanturn | P1 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:567) |
| Lanturn | P1 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:567) |
| Lanturn | P1 | Heal Bell | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:567) |
| Beedrill | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:381) |
| Beedrill | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:381) |
| Nidoking | P1 | Sludge Bomb | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/nidoking.asm) |
| Nidoqueen | P1 | Sludge Bomb | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/nidoqueen.asm) |
| Vikavolt | P1 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6416) |
| Vikavolt | P1 | Energy Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/vikavolt.asm) |
| Vikavolt | P1 | Sticky Web | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6416) |
| Galvantula | P1 | Sticky Web | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2984) |
| Galvantula | P1 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2984) |
| Shuckle | P1 | Sticky Web | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1525) |
| Scizor | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1495) |
| Scizor | P1 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1495) |
| Scizor | P1 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1495) |
| Crobat | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:519) |
| Crobat | P1 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:519) |
| Crobat | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:519) |
| Corviknight | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5191) |
| Corviknight | P1 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5191) |
| Corviknight | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5191) |
| Espeon | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1107) |
| Espeon | P1 | Dazzling Gleam | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1107) |
| Espeon | P1 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1107) |
| Espeon | P1 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1107) |
| Sylveon | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5130) |
| Sylveon | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5130) |
| Sylveon | P1 | Psychic | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/sylveon.asm) |
| Gardevoir | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3804) |
| Gardevoir | P1 | Wish | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3804) |
| Glaceon | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3827) |
| Glaceon | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3827) |
| Aurorus | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7075) |
| Aurorus | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7075) |
| Pidgeot | P1 | Heat Wave | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:453) |
| Pidgeot | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:453) |
| Noctowl | P1 | Heat Wave | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:385) |
| Noctowl | P1 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/noctowl.asm) |
| Staraptor | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3352) |
| Weavile | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4346) |
| Weavile | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4346) |
| Weavile | P1 | Triple Axel | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4346) |
| Feraligatr | P1 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:292) |
| Feraligatr | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:292) |
| Ursalunabm | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6363) |
| Ursalunabm | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6363) |
| Ursalunabm | P1 | Moonlight | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6363) |
| Porygon Z | P1 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/porygon_z.asm) |
| Porygon Z | P1 | Dark Pulse | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4094) |
| Blastoise | P1 | Dark Pulse | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:303) |
| Blastoise | P1 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:303) |
| Blastoise | P1 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:303) |
| Blastoise | P1 | Iron Defense | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:303) |
| Magmortar | P1 | Thunderbolt | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/magmortar.asm) |
| Octillery | P1 | Energy Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/octillery.asm) |
| Octillery | P1 | Psychic | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/octillery.asm) |
| Octillery | P1 | Sludge Bomb | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/octillery.asm) |
| Grumpig | P1 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5806) |
| Grumpig | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5806) |
| Grumpig | P1 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5806) |
| Grumpig | P1 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5806) |
| Grumpig | P1 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5806) |
| Armarouge | P1 | Aura Sphere | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5085) |
| Armarouge | P1 | Energy Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/armarouge.asm) |
| Armarouge | P1 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5085) |
| Hydrapple | P1 | Earth Power | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5834) |
| Hydrapple | P1 | Draco Meteor | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5834) |
| Mimikyu | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6800) |
| Mimikyu | P1 | Drain Punch | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/mimikyu.asm) |
| Mimikyu | P1 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6800) |
| Chandelure | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2940) |
| Chandelure | P1 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2940) |
| Scolipede | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4195) |
| Scolipede | P1 | Rock Slide | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4195) |
| Scolipede | P1 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4195) |
| Flygon | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5708) |
| Flygon | P1 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5708) |
| Persian Alolan | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7393) |
| Persian Alolan | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7393) |
| Persian Alolan | P1 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7393) |
| Hypno | P1 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2305) |
| Hypno | P1 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2305) |
| Hypno | P1 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2305) |
| Banette | P1 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2768) |
| Banette | P1 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2768) |
| Banette | P1 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2768) |
| Togekiss | P1 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4265) |
| Togekiss | P1 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4265) |
| Arcanine | P1 | Morning Sun | Family list: Growlithe; direct level 36 | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1404) |
| Arcanine | P1 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1404) |
| Venusaur | P2 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:166) |
| Venusaur | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:166) |
| Charizard | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:235) |
| Charizard | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:235) |
| Parasect | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1121) |
| Parasect | P2 | Synthesis | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1121) |
| Sandslash | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:692) |
| Sandslash | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:692) |
| Persian | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1262) |
| Persian | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1262) |
| Persian | P2 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1262) |
| Golduck | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1306) |
| Golduck | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1306) |
| Poliwrath | P2 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1468) |
| Slowbro | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1905) |
| Slowbro | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1905) |
| Slowbro | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1905) |
| Dodrio | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2017) |
| Dodrio | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2017) |
| Dewgong | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2065) |
| Dewgong | P2 | Haze | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2065) |
| Gengar | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2228) |
| Gengar | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2228) |
| Gengar | P2 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2228) |
| Electrode | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2399) |
| Electrode | P2 | Foul Play | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2399) |
| Exeggutor | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2444) |
| Exeggutor | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2444) |
| Hitmonlee | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2522) |
| Hitmonchan | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2548) |
| Hitmontop | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2112) |
| Weezing | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2616) |
| Seaking | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2841) |
| Seaking | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2841) |
| Starmie | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2885) |
| Starmie | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2885) |
| Vaporeon | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3209) |
| Vaporeon | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3209) |
| Jolteon | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3236) |
| Jolteon | P2 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3236) |
| Kabutops | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3394) |
| Kabutops | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3394) |
| Zapdos | P2 | Hurricane | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3502) |
| Zapdos | P2 | Heat Wave | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3502) |
| Zapdos | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3502) |
| Meganium | P2 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:152) |
| Meganium | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:152) |
| Furret | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:340) |
| Ledian | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:435) |
| Xatu | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:691) |
| Xatu | P2 | Heat Wave | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:691) |
| Ampharos | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:754) |
| Ampharos | P2 | Agility | Family list: Mareep | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:754) |
| Ampharos | P2 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:754) |
| Sudowoodo | P2 | Head Smash | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:855) |
| Sudowoodo | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:855) |
| Sudowoodo | P2 | Iron Defense | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:855) |
| Quagsire | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1084) |
| Quagsire | P2 | Yawn | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1084) |
| Quagsire | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1084) |
| Forretress | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1308) |
| Steelix | P2 | Gyro Ball | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1385) |
| Donphan | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1993) |
| Donphan | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1993) |
| Miltank | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2201) |
| Miltank | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2201) |
| Miltank | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2201) |
| Blissey | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2223) |
| Blissey | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2223) |
| Raikou | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2247) |
| Raikou | P2 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/raikou.asm) |
| Raikou | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2247) |
| Suicune | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2294) |
| Suicune | P2 | Sleep Talk | Goldenrod utility tutor | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/utility_tutor.asm) |
| Celebi | P2 | Earth Power | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2439) |
| Celebi | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2439) |
| Honchkrow | P2 | Heat Wave | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3631) |
| Honchkrow | P2 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3631) |
| Honchkrow | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3631) |
| Ambipom | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3657) |
| Ambipom | P2 | Triple Axel | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3657) |
| Salamence | P2 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4166) |
| Electivire | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3759) |
| Electivire | P2 | Flamethrower | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/electivire.asm) |
| Farigiraf | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3782) |
| Farigiraf | P2 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3782) |
| Farigiraf | P2 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3782) |
| Gliscor | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3857) |
| Gliscor | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3857) |
| Gliscor | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3857) |
| Tangrowth | P2 | Synthesis | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4241) |
| Tangrowth | P2 | Leech Seed | Family list: Tangela | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4241) |
| Tangrowth | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4241) |
| Rhyperior | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4136) |
| Rhyperior | P2 | Ice Punch | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/rhyperior.asm) |
| Wyrdeer | P2 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4395) |
| Wyrdeer | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4395) |
| Wyrdeer | P2 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/wyrdeer.asm) |
| Yanmega | P2 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4420) |
| Yanmega | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4420) |
| Armaldo | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4496) |
| Armaldo | P2 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4496) |
| Dusknoir | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4613) |
| Dusknoir | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4613) |
| Hydreigon | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4802) |
| Hydreigon | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4802) |
| Tinkaton | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4989) |
| Tinkaton | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4989) |
| Ceruledge | P2 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5106) |
| Appletun | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5286) |
| Appletun | P2 | Iron Defense | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5286) |
| Lopunny | P2 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5903) |
| Lopunny | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5903) |
| Camerupt | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5395) |
| Toxicroak | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6316) |
| Toxicroak | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6316) |
| Drifblim | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5508) |
| Drifblim | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5508) |
| Froslass | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5740) |
| Froslass | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5740) |
| Scrafty | P2 | Poison Jab | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6075) |
| Scrafty | P2 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6075) |
| Milotic | P2 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6772) |
| Milotic | P2 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6772) |
| Mr  Rime | P2 | Slack Off | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6886) |
| Mr  Rime | P2 | Freeze Dry | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6886) |
| Mr  Rime | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6886) |
| Torkoal | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7117) |
| Torkoal | P2 | Iron Defense | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7117) |
| Torkoal | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7117) |
| Perrserker | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7622) |
| Perrserker | P2 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7622) |
| Slowbro Galarian | P2 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7720) |
| Slowbro Galarian | P2 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7720) |
| Weezing Galarian | P2 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7748) |
| Weezing Galarian | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7748) |
| Electrode Hisuian | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7901) |
| Electrode Hisuian | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7901) |
| Tsareena | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8165) |
| Tsareena | P2 | Play Rough | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8165) |
| Noivern | P2 | Draco Meteor | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3051) |
| Noivern | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3051) |
| Salazzle | P2 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3099) |
| Salazzle | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3099) |
| Krookodile | P2 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3409) |
| Krookodile | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3409) |
| Krookodile | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3409) |
| Butterfree | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:341) |
| Butterfree | P3 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:341) |
| Fearow | P2 | Drill Run | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:543) |
| Fearow | P2 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:543) |
| Arbok | P3 | Toxic Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:586) |
| Arbok | P3 | Rock Slide | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:586) |
| Clefable | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:864) |
| Clefable | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:864) |
| Ninetales | P3 | Energy Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/ninetales.asm) |
| Ninetales | P3 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:911) |
| Wigglytuff | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:960) |
| Wigglytuff | P3 | Reflect | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:960) |
| Wigglytuff | P3 | Light Screen | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:960) |
| Venomoth | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1169) |
| Dugtrio | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1219) |
| Dugtrio | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1219) |
| Dugtrio Alolan | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7346) |
| Dugtrio Alolan | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7346) |
| Alakazam | P3 | Dazzling Gleam | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1524) |
| Alakazam | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1524) |
| Machamp | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1600) |
| Victreebel | P3 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1672) |
| Tentacruel | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1721) |
| Tentacruel | P3 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1721) |
| Golem | P3 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1797) |
| Rapidash | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1850) |
| Rapidash | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1850) |
| Muk | P3 | Toxic Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2110) |
| Muk | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2110) |
| Cloyster | P3 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2155) |
| Kingler | P3 | Rock Slide | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2355) |
| Marowak | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2496) |
| Marowak | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2496) |
| Kangaskhan | P3 | Rock Slide | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2737) |
| Pinsir | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3070) |
| Tauros | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3092) |
| Tauros | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3092) |
| Gyarados | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3127) |
| Lapras | P3 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3155) |
| Lapras | P3 | Heal Bell | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3155) |
| Flareon | P3 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3265) |
| Omastar | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3340) |
| Aerodactyl | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3422) |
| Snorlax | P3 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3452) |
| Articuno | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3479) |
| Articuno | P3 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3479) |
| Moltres | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3522) |
| Dragonite | P3 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3593) |
| Mewtwo | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3624) |
| Mewtwo | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3624) |
| Mew | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3647) |
| Mew | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3647) |
| Mew | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3647) |
| Mew | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3647) |
| Typhlosion | P3 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:222) |
| Typhlosion | P3 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/typhlosion.asm) |
| Ariados | P3 | Lunge | Family list: Spinarak | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:490) |
| Ariados | P3 | Toxic Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:490) |
| Bellossom | P3 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:779) |
| Bellossom | P3 | Draining Kiss | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:779) |
| Azumarill | P3 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:828) |
| Azumarill | P3 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:828) |
| Politoed | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:880) |
| Jumpluff | P3 | Substitute | Goldenrod utility tutor | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/utility_tutor.asm) |
| Sunflora | P3 | Dazzling Gleam | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1014) |
| Umbreon | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1137) |
| Slowking | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1190) |
| Granbull | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1443) |
| Heracross | P3 | Bullet Seed | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1552) |
| Heracross | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1552) |
| Magcargo | P3 | Iron Defense | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1678) |
| Corsola | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1752) |
| Corsola | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1752) |
| Delibird | P3 | Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1817) |
| Delibird | P3 | Haze | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1817) |
| Mantine | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1843) |
| Skarmory | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1868) |
| Houndoom | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1916) |
| Kingdra | P3 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1942) |
| Kingdra | P3 | Flip Turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1942) |
| Entei | P3 | Stone Edge | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2269) |
| Tyranitar | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2367) |
| Lugia | P3 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2398) |
| Lugia | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2398) |
| Ho Oh | P3 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2419) |
| Annihilape | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3677) |
| Dudunsparce | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3731) |
| Gallade | P3 | Triple Axel | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6851) |
| Leafeon | P3 | X Scissor | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3913) |
| Lickilicky | P3 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3941) |
| Lickilicky | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3941) |
| Magnezone | P3 | Substitute | Goldenrod utility tutor | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/utility_tutor.asm) |
| Mamoswine | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4015) |
| Mismagius | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4069) |
| Ursaluna | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4297) |
| Cradily | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4470) |
| Golurk | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4543) |
| Conkeldurr | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4682) |
| Volcarona | P3 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4725) |
| Dragapult | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4872) |
| Baxcalibur | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5048) |
| Abomasnow | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5213) |
| Abomasnow | P3 | Giga Drain | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5213) |
| Altaria | P3 | Heal Bell | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5236) |
| Flapple | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5645) |
| Archaludon | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5325) |
| Breloom | P3 | Rock Slide | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5346) |
| Centiskorch | P3 | Thunder Fang | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5422) |
| Excadrill | P3 | Shadow Claw | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5622) |
| Talonflame | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6293) |
| Golisopod | P3 | Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5769) |
| Kingambit | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5857) |
| Ludicolo | P3 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5951) |
| Overqwil | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6044) |
| Walrein | P3 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6439) |
| Haxorus | P3 | Poison Jab | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6566) |
| Haxorus | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6566) |
| Rampardos | P3 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6615) |
| Bastiodon | P3 | Flamethrower | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/bastiodon.asm) |
| Bastiodon | P3 | Foul Play | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6660) |
| Cetitan | P3 | Liquidation | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6741) |
| Cetitan | P3 | Play Rough | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6741) |
| Cursola | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6821) |
| Sirfetch D | P3 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6920) |
| Lucario | P3 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/lucario.asm) |
| Tyrantrum | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7030) |
| Raticate | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:497) |
| Raticate Alolan | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7162) |
| Raichu Alolan | P3 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7185) |
| Sandslash Alolan | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7239) |
| Ninetales Alolan | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7297) |
| Golem Alolan | P3 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7467) |
| Muk Alolan | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7518) |
| Exeggutor Alolan | P3 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7542) |
| Marowak Alolan | P3 | Pain Split | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7571) |
| Rapidash Galarian | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7669) |
| Rapidash Galarian | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7669) |
| Slowking Galarian | P3 | Toxic Spikes | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7773) |
| Arcanine Hisuian | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7854) |
| Typhlosion Hisuian | P3 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7925) |
| Sneasler | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7982) |
| Clodsire | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8041) |
| Clodsire | P3 | Yawn | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8041) |
| Tauros Paldean Fire | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8063) |
| Tauros Paldean Water | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:8093) |
| Aggron | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2477) |
| Kleavor | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2500) |
| Kleavor | P3 | Close Combat | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2500) |
| Glimmora | P3 | Energy Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/glimmora.asm) |
| Toxapex | P3 | Scald | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2569) |
| Zangoose | P3 | Fire Punch | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/zangoose.asm) |
| Seviper | P3 | Ice Fang | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2610) |
| Seviper | P3 | Dark Pulse | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2610) |
| Archeops | P3 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2817) |
| Carracosta | P3 | Superpower | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2869) |
| Mawile | P3 | Knock Off | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/mawile.asm) |
| Mawile | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3008) |
| Espathra | P3 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3144) |
| Palafin | P3 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:3183) |
| Gorochu | P3 | Dark Pulse | Level 34 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2721) |
| Unown | P1 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1245) |
| Unown | P1 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/unown.asm) |
| Scyther | P1 | U-turn | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2967) |
| Scyther | P1 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2967) |
| Chansey | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2691) |
| Chansey | P2 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2691) |
| Porygon2 | P2 | Foul Play | Level 28 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2027) |
| Porygon2 | P2 | Shadow Ball | TM/HM/elemental tutor compatibility | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/porygon2.asm) |
| Dusclops | P2 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4585) |
| Dusclops | P2 | Taunt | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:4585) |
| Corsola Galarian | P3 | Calm Mind | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:7805) |
| Raichu | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:637) |
| Raichu | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:637) |
| Jynx | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2994) |
| Jynx | P2 | Encore | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2994) |
| Murkrow | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1166) |
| Murkrow | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1166) |
| Girafarig | P3 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1266) |
| Girafarig | P3 | Wish | Family list: Girafarig; direct level 36 | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1266) |
| Stantler | P3 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2049) |
| Stantler | P3 | Trick Room | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:2049) |
| Piloswine | P3 | Stealth Rock | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1724) |
| Charjabug | P2 | Sticky Web | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5446) |
| Charjabug | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5446) |
| Charjabug | P2 | Wild Charge | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5446) |
| Duraludon | P3 | Draco Meteor | Level 44 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5577) |
| Duraludon | P3 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:5577) |
| Magneton | P3 | Substitute | Goldenrod utility tutor | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/utility_tutor.asm) |
| Togetic | P2 | Thunder Wave | Level 20 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:649) |
| Togetic | P2 | Hyper Voice | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:649) |
| Onix | P3 | Head Smash | Family list: Onix | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2255) |
| Gligar | P2 | Roost | Level 36 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1355) |
| Gligar | P2 | Defog | Level 24 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:1355) |
| Rhydon | P3 | Swords Dance | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2662) |
| Rhydon | P3 | Body Press | Level 32 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2662) |
| Electabuzz | P2 | Volt Switch | Level 30 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3021) |
| Electabuzz | P2 | Focus Blast | Level 40 / reminder | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3021) |
| Magmar | P2 | Belly Drum | Family list: Magby; direct level 44 | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3044) |
| Magmar | P2 | Mach Punch | Family list: Magby | [Source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:3044) |

## Validation

- Release and debug ROMs assembled and linked successfully. Updated playable files are at the repository root.
- Static learnset checks cover all 495 species entries, all 440 selected additions, clone mirroring, all compatibility flags, timing and reminder repairs.
- Game-data audit: **44,762 checks passed**. Move audit passed: **419 player-available moves** plus Struggle.
- Compiled-ROM tests: **4,114 checks passed on each build**, covering every species’ utility menu and reminder list, known-move filtering, added TM flags, family mappings, and compatible breeding/inheritance paths.
- Linked resource audit: **4,633 checks passed**. Map sprite audit passed with no VRAM overflow.
- Largest reminder list is **32/36**; largest egg list is **7/36**.
- Battle effects and damage formulas were not changed. These checks verify acquisition and data integrity; they do not establish competitive balance for every optional build.

[Full implementation receipt](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/_ai_artifacts/reports/learnset_variety_implementation_2026-10-02.json) · [Static audit](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/tools/audit_learnset_variety.py) · [ROM tests](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/tools/test_learnset_variety.py)
