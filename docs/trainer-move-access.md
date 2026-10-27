> Historical design record: the [full-history source correction](historical-move-access.md) supersedes unsupported additions below. Current Pok�mon pages and that report show the final move access.

# Player access to reviewed trainer moves

Implemented 20 October 2026. All **29 distinct species/move combinations across the 47 flagged trainer slots** now have a player acquisition route. These are deliberate project additions; they are recorded separately from the pinned historical canonical compatibility reference.

Seventeen combinations use level-up, two use compatible egg inheritance, and ten use the existing Blackthorn tutor. No existing move or acquisition route was removed.

## Natural level-up additions

| Pokémon | Move | Level | Placement rationale |
|---|---|---:|---|
| Pidgeot | Hyper Voice | 44 | A mature bird's powerful cry; late special Normal STAB before Hurricane. |
| Clefairy | Fairy Wind | 5 | Basic Fairy STAB before Disarming Voice and Draining Kiss. |
| Misdreavus | Fairy Wind | 7 | Early STAB for its local Ghost/Fairy typing. |
| Gengar | Sludge | 16 | Poison progression between Smog and Sludge Bomb. |
| Dragapult | Crunch | 48 | A late upgrade to its existing Bite. |
| Aerodactyl | Head Smash | 60 | High-risk Rock finisher after Stone Edge and Brave Bird; compatible with Rock Head. |
| Tsareena | Swords Dance | 46 | Physical battle dance before its strongest late attacks. |
| Tauros | Superpower | 50 | Late brute-force Fighting coverage after Close Combat and Raging Bull. |
| Galarian Rapidash | Moonblast | 48 | Late Fairy STAB for its local Fairy/Fire typing. |
| Ambipom | Dizzy Punch | 36 | Evolved tail-hand technique between Bounce and Body Slam. |
| Milotic | Calm Mind | 44 | Its calming nature supports special setup in the later learnset. |
| Kotora | Slack Off | 24 | Resting feline recovery before its later Rest option. |
| Charizard | Draco Meteor | 64 | Final high-power Dragon move for its local Fire/Dragon typing. |
| Bayleef | Mega Drain | 16 | Early draining Grass STAB, well before Giga Drain. |
| Slowking | Recover | 50 | Late psychic regeneration alongside its existing recovery options. |
| Galarian Slowking | Recover | 50 | The same late regeneration placement, before Slack Off. |
| Applin | Growth | 10 | Plant growth setup between Defense Curl and Twister, supporting its draining attacks. |

Family consistency: Cleffa and Clefable also gain Fairy Wind at 5; Mismagius gains it at 7; Gastly and Haunter gain Sludge at 16; Chikorita gains Mega Drain at 14 and Meganium at 16; Raitora and Gorotora gain Slack Off at 24. Clone Charizard mirrors Draco Meteor at 64. Including these supporting placements, there are **27 new level-up rows**. The Move Reminder includes the new moves when the relevant level is reached and retains normal pre-evolution access.

## Egg moves

| Target | Egg placement | Compatible route |
|---|---|---|
| Buneary — Karate Chop | Buneary egg list | Female Buneary × male Machop knowing Karate Chop, learned at level 4. Both share the Humanlike egg group. |
| Electivire — Crunch | Elekid family egg list | Female Electabuzz × male Lucario knowing Crunch, learned at level 25. Both share the Humanlike egg group; hatch Elekid and evolve it. |

Both routes have independent natural donors and work with either parent deposit order. The existing Blackthorn egg-move tutor also exposes these family moves. These are project breeding compatibility additions, not claims about an official game's egg lists.

## Blackthorn tutor additions

| Pokémon | Move | Placement rationale |
|---|---|---|
| Skarmory | U-turn | Trained pivoting coverage. |
| Grumpig | Thunderbolt | Electrical coverage outside its natural psychic progression. |
| Archeops | X-Scissor | Trained cutting coverage. |
| Tsareena | Iron Tail | Unusual Steel coverage outside its natural kicking and plant progression. |
| Paldean Tauros, Fire form | Aqua Jet | Unusual Water coverage; its male-only family cannot import an unrelated father's egg move through breeding. |
| Pikachu | Hyper Voice | Trained vocal coverage. |
| Raichu | Hyper Voice | Direct access after evolution; Alolan Raichu receives matching access. |
| Pidgeot | Signal Beam | Unusual beam coverage. |
| Lanturn | Flash Cannon | Trained Steel coverage rather than a natural aquatic attack. |
| Sneasler | Triple Axel | A trained Ice technique outside its natural Poison/Fighting progression. |

These use the existing purple tutor in the Move Deleter's House in Blackthorn City, with its existing ¥5,000 fee. Alolan Raichu's supporting assignment brings the new direct technical-tutor entries to **11**. Goldenrod's five utility moves and compatibility flags are unchanged.

## Trainer preservation and validation

New natural rows would alter the automatic last-four moves of 12 trainer parties. Those parties now explicitly store their previous moves: ALAN4, LAURA, ELLEN, BRENT1, BRENT2, GRUNTM_31, IRWIN2, ERIN1, JEFFREY, GRACE, WINNIE and LILITH. Every teammate's moves, species, level, item and ability selection are preserved. No dialogue was edited in this change.

The project manifest is `tools/testdata/trainer_move_access.json`. Level-up regeneration and Blackthorn regeneration preserve these assignments. The canonical audit allows only the explicitly recorded custom tutor combinations without modifying the historical reference's expected compatibility.

Validation includes exact-level ROM checks, Move Reminder availability, Blackthorn filtering, compatible breeding in both deposit orders, all-species learnset tests, and the trainer reader across all 593 source-backed parties. CAL2's Mystery Gift party is read from SRAM at runtime; its stored placeholder is covered by the source audits. A separate before/after comparison covers all 594 authored parties and 1,819 slots.
