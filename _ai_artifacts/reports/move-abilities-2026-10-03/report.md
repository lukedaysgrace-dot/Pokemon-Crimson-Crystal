# Octazooka and Incinerate ability verification — October 3, 2026

All 141 battle cases passed on the rebuilt debug ROM. This includes 59 additional ability/reaction regressions, the 31 Octazooka cases, and the 51 existing priority/Incinerate cases. Octazooka's 512 exhaustive chance-roll battles also passed against the same ROM build. The playable and debug ROMs, maps, and symbols were updated and their hashes match the tested build. Existing saves were unchanged.

## Octazooka

| Interaction | Verified behavior |
| --- | --- |
| Serene Grace | Doubles the paired-drop threshold from 51 to 102 out of 256 rolls. |
| Sheer Force | Removes both secondary drops, boosts damage, and prevents Life Orb recoil. |
| Shield Dust, Clear Body, White Smoke | Prevent the paired defense drops. |
| Big Pecks | Prevents only the Defense drop; Special Defense still falls. |
| Contrary | Raises both defenses instead. |
| Defiant, Competitive | Each successfully lowered stat triggers +2 Attack or Special Attack: +4 total for both defenses. If one defense is already at its minimum, the other still triggers +2. If neither can fall, neither ability triggers. |
| Mirror Armor | Reflects both drops; Clear Body blocks the reflected drops, while Defiant reacts to both reflected drops. |
| Bulletproof, Water Absorb, Storm Drain, Dry Skin | Block damage and the secondary drops. Storm Drain also raises Special Attack. |
| Mold Breaker | Bypasses the tested damage immunities, Shield Dust, Clear Body, and Mirror Armor. |
| Infiltrator | Bypasses Substitute and Mist for the drops. |
| Neutralizing Gas | Suppresses the tested Shield Dust and Contrary protections. |
| Stamina | Raises Defense on the hit before Octazooka lowers it, leaving Defense neutral and Special Defense at -1. |
| Magic Bounce, Keen Eye, Hyper Cutter, Mind's Eye, Battle Armor, Shell Armor, Unaware | Do not prevent these Defense/Special Defense drops. |

Chance is shared: one roll lowers both defenses, with no accuracy drop. The exhaustive test verified success on rolls 0–50 and failure on 51–255 (51/256 = 19.921875%, this engine's encoding of 20%). Serene Grace succeeded on 0–101 and failed on 102–255. Misses, Protect, intact/broken Substitute, knockouts, and stat-stage limits also passed.

The follow-up found and fixed two Defiant/Competitive problems in combined stat-drop messaging: only one reaction occurred for two dropped stats, and a failed second stat could incorrectly suppress the first successful stat's reaction. Reactions now use the recorded successful stat changes. Existing Close Combat, Draco Meteor, Curse, Growl, and Sticky Web reaction cases still passed. The earlier missing Sheer Force registration remains fixed.

## Incinerate

| Interaction | Verified behavior |
| --- | --- |
| Sticky Hold | Protects a surviving holder's berry; fainted holders cannot protect it. |
| Mold Breaker | Bypasses Sticky Hold and Flash Fire. |
| Flash Fire | Prevents damage and berry destruction. |
| Shield Dust, Sheer Force | Do not stop berry destruction, which is a primary move effect. Sheer Force does not boost Incinerate's damage or cancel its Life Orb recoil. |
| Serene Grace | Does not change the damage or guaranteed berry destruction. |
| Harvest | Cannot regrow the destroyed berry, including in sun and at a healing threshold. |
| Ripen, Gluttony, Cud Chew | Do not preserve the destroyed berry. Cud Chew did not restore HP or schedule a second consumption over three turns. |
| Unnerve, Klutz | A berry can still be destroyed while eating or held-item effects are suppressed. |
| Unburden | Losing the berry activates the speed boost on the next turn. An itemless control did not activate it. |
| Infiltrator | Destroys the berry through Substitute. |
| Neutralizing Gas | Suppresses Sticky Hold. |
| Thermal Exchange | Raises the holder's Attack while the berry is destroyed. |
| Thick Fat, Multiscale, Dry Skin, Fluffy | Apply their damage modifiers while berry destruction still works. |
| Pickpocket, Magic Bounce, Bulletproof, Water Veil | Do not preserve the berry from this non-contact Fire attack. |

All ten supported berry items, non-berry preservation, berry removal from the party record, misses, Protect, Substitute, knockout timing, and destruction before healing also passed. No additional Incinerate implementation bug was found in this follow-up.

This is coverage of the direct interactions listed here, not an exhaustive cross-product of every ability, item, weather, species, and battle condition.

## Evidence

Permanent added cases: `tools/battletest/tests/67-octazooka-incinerate-abilities.yaml`.
Detailed results: `results-full.json` in this folder.
Per-roll outcomes: `../octazooka-2026-10-03/chance-sweep.json`.

Modern interaction reference: [Pokémon Showdown's move definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts), [ability definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts), and [per-stat boost events](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle.ts). Octazooka's custom power, accuracy, PP, and paired 20% drops remain this project's intended behavior.
