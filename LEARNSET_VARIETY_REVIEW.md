# Crimson Crystal — movepool variety review

**Implemented October 2, 2026:** All 440 reviewed additions and the access fixes are applied. This review is retained as the original audit snapshot; see the [implementation log](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/LEARNSET_VARIETY_IMPLEMENTED.md) for current acquisition routes and validation.

_October 2, 2026. Source commit `a3c945df` — “new learnsets for all, still working on it”._

The overhaul is a substantial improvement. Most Pokémon already have viable attacks, relevant STAB, and a recognizable role. The strongest remaining work is **distributing build-enabling moves**: pivots, appropriate setup, screens, disruption, recovery, and a few important coverage moves. Large move counts alone conceal these gaps.

I would start with the high-priority table below, then selectively apply the worthwhile alternatives. **A listed optional addition is not a finding that the Pokémon is weak.** Many already strong Pokémon can learn more moves in the official games; giving every such move to every eligible species would erase useful differences between them.

Full coverage: **495 source entries / 486 unique species**, **213 family egg-tutor lists**, and **236 terminal evolution outcomes**. All source entries were parsed and compared; final outcomes received individual role recommendations, with **20 additional unevolved reviews** for distinct endgame/Eviolite choices. The nine clone entries were checked separately and mirror the corresponding starter plans.

[Complete roster, every final evolution, and the 20 unevolved reviews](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/_ai_artifacts/reports/LEARNSET_VARIETY_ROSTER_2026-10-02.md) · [Machine-readable evidence](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/_ai_artifacts/reports/learnset_variety_review_2026-10-02.json)

## How the review treats your game

The baseline is your actual stats, typing, abilities, physical/special split and move definitions. For example, Ledian is Bug/Fighting with 105 Attack and 35 Sp. Atk; Pidgeot has 115 Sp. Atk and No Guard; Seaking is special-leaning; Flygon is Bug/Dragon; Bloodmoon Ursaluna has 135 Sp. Atk. Official-game roles are useful inspiration, but those changes take precedence.

Move definitions matter too: Water Pulse is 80 power here, Wild Charge is 95 power with a paralysis effect rather than the official recoil design, and Cut is Bug-type. Coverage and ability comments therefore use the ROM definitions. For example, Wild Charge is not being recommended as a Reckless/Rock Head interaction.

The accessible pool includes the current form’s level-up moves, its TM/HM/tutor flags, the egg list selected by `FirstEvoStages`, retained moves from actual pre-evolutions in this ROM, and the Dratini-line Extreme Speed tutor. Retained moves are counted as obtainable, but are marked separately because the current Move Reminder does not restore pre-evolution moves. Hidden Power, Return, Rest, or a pile of weak attacks are not treated as substitutes for a distinct build.

Modern evidence comes from [Pokémon Showdown’s maintained learnset data](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/learnsets.ts), supplemented with [Brilliant Diamond/Shining Pearl learnsets](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/mods/gen8bdsp/learnsets.ts). [Its Pokédex data](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/pokedex.ts) supplies official pre-evolution access. Gen 8/9 normal level-up, machine, tutor and egg sources were prioritized. Gen 4–7 normal sources are explicitly marked older options, especially for Pokémon absent from the newer games. Event-only and Virtual Console-only access was excluded. This is a design comparison across games, not a claim that every combination is legal in one current official format. The evidence is community-maintained simulator data, not a Nintendo-published learnset catalog.

All proposed moves already exist in Crimson Crystal. Official evidence establishes that the species/family can learn the move; the suggested **ROM acquisition route** may intentionally differ. In particular, a modern TM move placed in your family tutor list is a custom distribution decision, not a claim that it is an official egg move.

## 1. Highest-priority gaps

These 39 final outcomes are missing a defining role, an important ability interaction, or particularly relevant coverage. Scyther has a separate high-priority review in the appendix. Some are already powerful; the goal is to enable a different build, not make every existing build stronger.

| Pokémon | Suggested additions | What the additions accomplish |
|---|---|---|
| [Blastoise](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/blastoise.asm) | **Dark Pulse**, **Flip Turn**, **Body Press**, **Iron Defense** | Already has boosted Water Pulse, Aura Sphere and Dragon Pulse for Mega Launcher. Dark Pulse completes the natural launcher coverage; Flip Turn and Iron Defense/Body Press add separate bulky builds alongside Shell Smash. |
| [Beedrill](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/beedrill.asm) | **U-turn**, **Swords Dance** | Adaptability U-turn gives it a fast offensive pivot; Swords Dance gives it a separate cleaner. These matter much more than another special attack on its 40 Sp. Atk. |
| [Pidgeot](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/pidgeot.asm) | **Heat Wave**, **U-turn** | Custom Pidgeot has 115 Sp. Atk and No Guard. Heat Wave covers Steel-types that wall its Flying/Normal attacks; U-turn adds a distinct pivot role. |
| [Nidoqueen](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/nidoqueen.asm) | **Sludge Bomb** | Both have Sheer Force and Earth Power plus elemental special coverage, but cannot use the existing Sludge Bomb TM. This is a same-type special coverage omission, not a request for more random coverage. |
| [Nidoking](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/nidoking.asm) | **Sludge Bomb** | Both have Sheer Force and Earth Power plus elemental special coverage, but cannot use the existing Sludge Bomb TM. This is a same-type special coverage omission, not a request for more random coverage. |
| [Arcanine](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/arcanine.asm) | **Morning Sun**, **Wild Charge** | Already has extensive Fire/Fighting/Dragon coverage. Morning Sun creates a sustainable Intimidate utility build; Wild Charge fills the meaningful Water coverage gap. |
| [Hypno](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/hypno.asm) | **Encore**, **Thunder Wave**, **Reflect** | It already has Hypnosis, with No Guard or Bad Dreams supporting alternative sleep builds. Encore, paralysis and the missing screen provide separate reliable support choices instead of more low-impact physical punches. |
| [Feraligatr](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/feraligatr.asm) | **Liquidation**, **Swords Dance** | Already has Dragon Dance and Aqua Tail. Liquidation is an accurate Water option with a Sheer Force interaction; Swords Dance creates a separate Aqua Jet breaker build. |
| [Noctowl](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/noctowl.asm) | **Heat Wave**, **Shadow Ball** | Custom Psychic/Flying typing and 106 Sp. Atk make special coverage useful. It already has Nasty Plot, Roost and Defog; Steel and Psychic/Ghost coverage are the remaining offensive gaps. |
| [Crobat](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/crobat.asm) | **U-turn**, **Roost**, **Taunt** | It has Defog and physical STAB, but lacks the pivot, recovery and disruption combination that makes a fast utility bat work. |
| [Lanturn](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/lanturn.asm) | **Volt Switch**, **Scald**, **Heal Bell** | A bulky Water/Electric should be able to pivot and support. Its current pool has both attacking types but misses the moves that distinguish it from a generic Surf/Thunderbolt user. |
| [Espeon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/espeon.asm) | **Calm Mind**, **Dazzling Gleam**, **Reflect**, **Light Screen** | 130 Sp. Atk and Magic Bounce should support both a Calm Mind attacker and a screen setter. Fairy coverage also answers Dark-types; Power Gem does not fill that role. |
| [Unown](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/unown.asm) | **Calm Mind** (custom), **Shadow Ball** (custom) | The only genuinely tiny conventional offensive pool: four total accessible moves despite 108 Attack and 108 Sp. Atk. If all mons must offer multiple builds, deliberately expand its psychic-symbol theme with setup and Ghost coverage. Both additions are custom design, not official Unown learnability. |
| [Scizor](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/scizor.asm) | **U-turn**, **Roost**, **Close Combat** | Bullet Punch/Swords Dance is already good. U-turn and Roost open bulky pivot builds; Close Combat gives an alternative to being walled by Steel-types. |
| [Shuckle](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/shuckle.asm) | **Sticky Web** | Already has Stealth Rock and Encore, but lacks its defining second hazard. Body Press/Iron Defense and Contrary Shell Smash already cover other builds. |
| [Octillery](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/octillery.asm) | **Energy Ball**, **Psychic**, **Sludge Bomb** | Custom Water/Fire and 120 Sp. Atk favor special coverage. It currently has physical Seed Bomb/Gunk Shot but lacks three existing special coverage TMs that modern Octillery can learn. |
| [Gardevoir](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/gardevoir.asm) | **Hyper Voice**, **Wish** | Its coverage/setup is already strong, but Pixilate has no Hyper Voice and the support build lacks its normal Wish option. This is an ability/support identity gap, not a generally weak pool. |
| [Glaceon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/glaceon.asm) | **Hyper Voice**, **Calm Mind** | Refrigerate currently has physical Normal attacks on a 130 Sp. Atk / 60 Attack mon. Hyper Voice makes the ability useful; Calm Mind opens a durable special build. |
| [Sylveon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/sylveon.asm) | **Hyper Voice**, **Calm Mind**, **Psychic** | Pixilate lacks its natural special Normal attack. Calm Mind separates the offensive build from Wish support; the existing Psychic TM adds Poison coverage. |
| [Magmortar](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/magmortar.asm) | **Thunderbolt** | It gets Thunderpunch on a 125 Sp. Atk special attacker but lacks Thunderbolt compatibility. The existing tutor flag is the simplest fix for Water coverage. |
| [Porygon-Z](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/porygon_z.asm) | **Shadow Ball**, **Dark Pulse** | Nasty Plot and Adaptability Normal STAB are already present, but its actual special coverage omits the existing Shadow Ball TM and a natural Dark option. Start with Shadow Ball; Dark Pulse is an alternative, not a required extra slot. |
| [Scolipede](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/scolipede.asm) | **Swords Dance**, **Rock Slide**, **Superpower** | Speed Boost and Baton Pass are present, but physical boosting and relevant coverage are thin. Swords Dance is the first addition; Rock/Fighting coverage makes an independent sweeper viable. |
| [Togekiss](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/togekiss.asm) | **Thunder Wave**, **Hyper Voice** | Already has strong special setup and direct Soft-Boiled recovery, plus Wish through Togepi. Paralysis opens the Serene Grace support build; Hyper Voice gives the custom Pixilate ability a natural special attack. Roost is not needed to fix a recovery shortage. |
| [Weavile](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/weavile.asm) | **Swords Dance**, **Taunt**, **Triple Axel** | It currently gets Nasty Plot despite 45 Sp. Atk, but lacks Swords Dance for 120 Attack. Triple Axel is an alternate multi-hit Ice STAB; Taunt gives its speed utility. |
| [Grimmsnarl](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/grimmsnarl.asm) | **Reflect**, **Light Screen**, **Thunder Wave** | Prankster screens and speed control are a defining alternative to its already good physical attacker. The current pool cannot make the standard screen-support build. |
| [Armarouge](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/armarouge.asm) | **Aura Sphere**, **Energy Ball**, **Trick Room** | Mega Launcher currently boosts Dragon Pulse but not its missing Aura Sphere. Grass coverage and Trick Room add a coverage attacker and a support/slow-team option. |
| [Corviknight](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/corviknight.asm) | **U-turn**, **Body Press**, **Taunt** | It already has Roost, Defog and Iron Defense. Body Press completes the defensive setup build; U-turn makes it a team pivot rather than a passive wall. |
| [Hydrapple](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/hydrapple.asm) | **Earth Power**, **Draco Meteor** | Nasty Plot plus Grass/Dragon is present, but Earth Power provides the important Steel/Poison coverage and uses Sheer Force. Draco Meteor is an alternative immediate-power Dragon build. |
| [Vikavolt](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/vikavolt.asm) | **Volt Switch**, **Energy Ball**, **Sticky Web** | 145 Sp. Atk needs special Grass coverage and an Electric pivot; Sticky Web gives it a separate lead/support job even when Speed Boost is not selected. |
| [Flygon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/flygon.asm) | **U-turn**, **Roost** | Custom Bug/Dragon has strong physical and special attacks already. STAB U-turn would give it an especially clear pivot identity; Roost adds a durable alternative to Dragon Dance offense. |
| [Grumpig](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/grumpig.asm) | **Encore**, **Taunt**, **Thunder Wave**, **Reflect**, **Light Screen** | Its attack/setup options are already adequate. Custom Prankster has very little premium utility; these moves open disruptive and screen-support builds. |
| [Ursaluna (Bloodmoon)](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/ursalunabm.asm) | **Calm Mind**, **Hyper Voice**, **Moonlight** | 135 Sp. Atk is still supported by a mostly physical inherited bear learnset. Hyper Voice supplies strong repeatable special Normal STAB instead of relying on Swift, recharge from Hyper Beam, or nonconsecutive Blood Moon at 70; Calm Mind/Moonlight creates the defining special tank. |
| [Mimikyu](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/mimikyu.asm) | **Swords Dance**, **Drain Punch**, **Trick Room** | Disguise and physical STAB are present, but the standard Swords Dance cleaner is missing. Drain Punch and Trick Room enable distinct bulky and support variants. |
| [Aurorus](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/aurorus.asm) | **Hyper Voice**, **Calm Mind** | Refrigerate has the same special Normal attack gap. Calm Mind gives its large HP and special bulk a role beyond weather setting; its elemental coverage is already good. |
| [Persian-Alola](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/persian_alolan.asm) | **U-turn**, **Taunt**, **Thunder Wave** | Fur Coat/Prankster should support a fast disruptive pivot. Its current pool is disproportionately attacking moves and Nasty Plot, despite these natural support abilities. |
| [Banette](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/banette.asm) | **Encore**, **Taunt**, **Swords Dance** | Custom Prankster currently has little high-value utility beyond Will-O-Wisp. Encore/Taunt open disruption; Swords Dance uses 125 Attack instead of its existing Nasty Plot. |
| [Chandelure](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/chandelure.asm) | **Calm Mind**, **Trick Room** | Its special attacks are already broad. It lacks meaningful special setup and the signature slow-team support option, leaving most builds as the same four attacks. |
| [Galvantula](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/galvantula.asm) | **Sticky Web**, **Giga Drain** | Sticky Web is its defining lead tool; Giga Drain adds recovery to the Grass-coverage slot it already has through Energy Ball. |
| [Staraptor](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/staraptor.asm) | **U-turn** | Brave Bird/Close Combat already make it a breaker. U-turn opens the distinct Intimidate pivot/scout build without increasing raw attacking power. |

Unown is the deliberate custom identity expansion. It currently has only Ancient Power, Earth Power, Hidden Power and Psychic. Calm Mind + Shadow Ball would create a coherent symbol/psychic-themed setup versus coverage choice. If its deliberately restricted official identity matters more than the “all mons have varied builds” goal, keep the four-move design instead. Ditto, Wobbuffet and Smeargle are different: Transform, counter-trapping, and Sketch already define their roles. Optional custom-ability additions for Ampharos, Bellossom and Gorochu are separately identified in the appendix.

## 2. The largest distribution gaps

Counts below cover the 486 unique source species, not evolution families. “Missing G8/9” is the number with ordinary Gen 8/9 evidence but no access in this ROM; “older” is additional Gen 4–7 precedent. Current access includes retained pre-evolution moves. These are a search inventory, not a recommendation to fill every cell.

| Move | Current users | Missing G8/9 access | Additional older access | Best first targets |
|---|---:|---:|---:|---|
| U-turn | 23 | 49 | 4 | Beedrill, Scizor, Crobat, Corviknight, Staraptor, Flygon, Persian forms |
| Volt Switch | 11 | 21 | 0 | Lanturn, Vikavolt, Forretress, regular Raichu, Hisuian Electrode |
| Flip Turn | 2 | 26 | 0 | Blastoise, Milotic, Vaporeon, Starmie, Golduck, Seaking |
| Calm Mind | 40 | 67 | 0 | Espeon, Sylveon, Glaceon, Aurorus, Bloodmoon Ursaluna, Chandelure |
| Swords Dance | 58 | 82 | 1 | Beedrill, Ledian, Scolipede, Weavile, Mimikyu, Feraligatr |
| Reflect | 48 | 77 | 0 | Grimmsnarl, Espeon, Grumpig, Hypno, Wigglytuff |
| Light Screen | 62 | 92 | 0 | Grimmsnarl, Espeon, Grumpig, Farigiraf |
| Thunder Wave | 36 | 106 | 0 | Grimmsnarl, Alolan Persian, Grumpig, Hypno, Togekiss |
| Sticky Web | 2 | 5 | 0 | Galvantula, Grubbin line, Shuckle |
| Substitute | 11 | 454 | 2 | Eligible species through a general utility tutor; prioritize seed/setup users |
| Sleep Talk | 30 | 435 | 2 | Eligible species through a general utility tutor; prioritize Rest users |
| Scald | 1 | 67 | 0 | Lanturn, Milotic, Suicune, Slowbro, Quagsire; Toxapex is optional |
| Hyper Voice | 22 | 71 | 0 | Sylveon, Gardevoir, Glaceon, Aurorus, Togekiss, Salamence |

**Sticky Web is especially clear:** only the Spinarak/Ariados family currently has it. Galvantula, Charjabug/Vikavolt and Shuckle are natural additions. This creates team-building alternatives without expanding everybody’s damage coverage.

**The special Normal move gap is an ability gap.** Gardevoir/Sylveon/Togekiss have Pixilate; Glaceon/Aurorus have Refrigerate; Salamence has Aerilate. All lack Hyper Voice. Altaria already has it and needs no such fix. Your Weather Ball implementation keeps its own typing rules, so Weather Ball is not a substitute for an ability-converted Hyper Voice.

**Setup should follow the actual offensive stat.** Ledian’s Quiver Dance, Weavile’s Nasty Plot, Banette’s Nasty Plot and Perrserker’s Nasty Plot are accessible, but none substitutes for physical boosting on those stat spreads. Keeping novelty special builds is fine; add the natural physical alternative rather than treating the presence of any boost as sufficient.

**Three optional custom synergies:** Ampharos could receive Hyper Voice for its new Galvanize ability; Bellossom could receive Draining Kiss for its new Fairy typing and Triage; Gorochu could receive Dark Pulse so its Nasty Plot build is not relying on 55-power Snarl for special Dark STAB. These are intentional ROM design proposals without ordinary official learnability evidence for that species, and are marked custom. Meganium already has Draining Kiss, so it does not need this addition.

**Scald distribution is unusually narrow:** only Vaporeon currently gets it. Surf is good damage, but does not create the same burn-support role. A curated selection of natural Water users would help. Toxapex, already well supplied with recovery, Haze, Knock Off and hazards, is a lower-priority and more substantial balance change.

## 3. Low-effort compatibility fixes

These additions use a TM or tutor that already has a compatibility flag. Start here: they improve several important pools without introducing another acquisition system. Keep the appropriate evolving forms compatible as well; the full appendix lists the species-specific recommendations.

| Existing move | Recommended P1/P2 targets |
|---|---|
| Goldenrod tutor — Thunderbolt | Magmortar |
| Goldenrod tutor — Flamethrower | Electivire |
| TM01 — Drain Punch | Mimikyu |
| TM19 — Energy Ball | Vikavolt, Octillery, Armarouge |
| TM29 — Psychic | Sylveon, Octillery |
| TM30 — Shadow Ball | Noctowl, Porygon-Z, Raikou, Wyrdeer, Unown, Porygon2 |
| TM33 — Ice Punch | Rhyperior |
| TM36 — Sludge Bomb | Nidoking, Nidoqueen, Octillery |

Sludge Bomb is obtainable from the Route 43 gate officer, so Nidoking/Nidoqueen compatibility can matter during Johto. Energy Ball, Psychic and Nasty Plot are at Celadon Gym, Celadon’s prize room and Viridian respectively. The Goldenrod elemental tutor requires beating the Elite Four and appears Wednesday/Saturday. Compatibility improves the eventual pool; it does not automatically solve an earlier story-game coverage gap.

For Pidgeot/Noctowl’s Heat Wave, Bloodmoon Ursaluna’s Hyper Voice, and the defining pivots/setup moves, prefer useful level-up placement or a tutor available during Johto. Avoid making every new build depend on Kanto TMs plus the Blackthorn family tutor.

Some optional Stealth Rock choices for Miltank, Blissey, Clefable and Mew broaden the earlier audit’s Rock/Steel/Ground-only policy. Their official learnability is real, but this is a deliberate distribution-policy expansion. If that restriction is intentional, keep it and use their other support recommendations instead.

## 4. Improve the family lists by usefulness, not length

The current egg lists now exist for most eligible families, but several are padded with defensive filler, obsolete scouting moves, or attacks that do not support the final form’s stats. Four useful choices can be better than seven nominal choices. Below are targeted replacements/expansions; they are suggestions, not wholesale rewrites.

| Family | Current list issue | Suggested direction |
|---|---|---|
| Squirtle | Confusion, Flail, Foresight, Haze, Mirror Coat, Mist. Haze/Mirror Coat have real purpose; the rest do little for its special Water/Steel final form. | Keep the counter/support options. Use a proper special/pivot tutor for Dark Pulse and Flip Turn, or intentionally add them to the family tutor. |
| Chinchou | Agility, Amnesia, Mist, Psybeam, Screech, Water Pulse. The 80-power Water Pulse is useful; Screech/Mist are much less central to Lanturn. | Add Volt Switch and Heal Bell access; Scald is a separate level-up/tutor choice. Preserve a clear special tank or support theme. |
| Grubbin | Agility, Harden, Mud Shot, Screech, Thunder Wave. Agility and paralysis are useful, but it misses Webs and the pivot role. | Sticky Web and Volt Switch should be core options. Energy Ball uses its existing TM flag on Vikavolt. Charjabug deserves the same support tools. |
| Joltik | Cross Poison, Disable, Feint Attack, Pin Missile, Poison Jab. Many choices target its weaker physical offense. | Put Sticky Web into the evolution/reminder path, and give Giga Drain through a level-up or appropriate tutor. Keep Disable as real utility; physical novelty moves can be secondary. |
| Shuckle | Acid Armor, Defense Curl, Endure, Sand Attack. Iron Defense already supplies defense boosting; this list adds few distinct endgame decisions. | Sticky Web by level-up is the main fix. Keep Endure if its specific interaction is desired; a short meaningful list is acceptable. |
| Impidimp | Charm, Encore, Mean Look, Spite, Torment. Encore is valuable, but the family lacks its defining screens. | Add Reflect/Light Screen and Thunder Wave through level-up or a support tutor. Preserve Encore; screens need not be relabeled as official egg moves. |
| Eevee | Detect, Endure, Flail, Wish, Yawn. Wish/Yawn are excellent, but Heal Bell is locked behind Eevee level 37 before evolving. | Make Heal Bell re-obtainable by the family. Give Calm Mind/Hyper Voice only where appropriate, through evolved-form learnsets or a compatibility tutor, so every branch does not inherit irrelevant choices. |
| Trapinch | Flail, Focus Energy, Fury Cutter, Gust, Quick Attack, Signal Beam. The list does not carry Flygon’s key pivot/recovery choices. | U-turn and Roost access matter much more. Its custom physical Bug/Dragon final form already has X-Scissor/Megahorn; do not add more filler Bug attacks. |
| Shuppet | Astonish, Disable, Foresight, Gunk Shot. Disable and Gunk Shot have purpose, but custom Prankster Banette wants disruption. | Encore/Taunt and physical Swords Dance are useful level-up/tutor additions. Foresight is a lower-value slot for this goal. |
| Bloodmoon bear line | Crunch, Focus Energy, Metal Claw, Seismic Toss, Take Down. Most options reinforce physical attacks on a special final form. | Prefer Calm Mind/Hyper Voice access for the developed stages; Moonlight should be an actual recovery option on Bloodmoon Ursaluna. |

A family egg-tutor entry applies to **every species mapped to that root**, including branched and regional evolutions. For branch-specific additions, use the evolved form’s own learnset or a compatible tutor. Caterpie/Weedle have no normal egg-move precedent: give Butterfree/Beedrill their missing moves directly instead of teaching the entire baby/cocoon line advanced evolved attacks.

Actual breeding still needs a compatible donor that knows the egg move. Your ¥5000 family tutor can supply a listed move directly, so a new tutor choice can be reachable even when a natural donor chain is awkward. A later implementation pass should separately check donor chains if natural breeding is intended to be the primary route. Existing TM/HM-compatible moves can also be inherited through the breeding engine; duplicating them into egg lists does not add a new eventual option.

## 5. Fix access to existing moves

These are not absent from the total pool. They can currently be carried through evolution, but the Move Reminder looks only at the current species’ own level-up list. A caught evolved Pokémon, an early-evolved Pokémon, or a Pokémon that forgot the move may lose practical access.

| Pokémon | Existing source | Access fix worth considering |
|---|---|---|
| All eight Eeveelutions | Eevee learns Heal Bell at 37; their own lists and family egg list do not include it. | Add a recoverable family option, or the same-level entry on each evolved form. This is more useful than another generic attack. |
| Hitmonlee / Hitmontop | Tyrogue’s level-1 Mach Punch. | Add a reminder entry on the evolved forms, while retaining Tyrogue access. |
| Electivire | Electabuzz’s level-1 Mach Punch. | Preserve the custom Fighting/priority build with an evolved-form reminder entry. |
| Golisopod | Wimpod learns Aqua Jet at 24. | Add a direct reminder entry on Golisopod. Its First Impression + Aqua Jet choice should survive forgetting or capture. |
| Overqwil | Qwilfish learns Aqua Jet at 15. | Add direct reminder access if this inherited custom Water coverage is intended to remain part of Overqwil’s identity. |
| Flapple | Dipplin learns Recover at 36 and Substitute at 44 in the ROM’s custom evolution path. | Decide deliberately whether Flapple should keep these strong custom options. If yes, make them recoverable; if no, the current inheritance path still grants them. |
| Xatu | Custom Watu learns Reflect and Light Screen at 20. | Preserve those screens in Xatu’s own reminder list or a support tutor. Natu itself does not learn these by level. |
| Mantine / Alolan Ninetales | Mantyke’s Aqua Jet at 23 / Alolan Vulpix’s Ice Shard at 8. | Lower priority, but direct reminder access would preserve these existing priority options. |
| Breloom | Shroomish’s Giga Drain at 25. | Lower priority with 60 Sp. Atk and existing Synthesis; preserve it if special novelty builds are intended. Spore itself is already directly present, so it is not missing. |

The sharpest timing outlier is **Alolan Raichu’s Volt Switch at 76**. It is present in the eventual pool, but neither the family egg list nor another pre-evolution provides an earlier route. Moving it into the roughly 26–35 range, or providing an earlier compatible tutor, would make the pivot build usable during ordinary progression. Regular Raichu lacks Volt Switch altogether.

Bloodmoon Ursaluna already has **Swift**, so the issue is not literally zero repeatable Normal damage. The issue is strong special STAB: Hyper Beam recharges and Blood Moon arrives at 70 and cannot be used on consecutive turns. Hyper Voice is the useful intermediate/repeatable option. Calm Mind and Moonlight add its more important special-tank identity.

Some other build tools arrive around or after 50: Heracross/Kingambit Swords Dance 50, Mawile Swords Dance 51, Volcarona Quiver Dance 50, and the Slowpoke evolutions’ Slack Off 49. Those are not automatically errors. Bring a defining tool earlier only if you want that build playable during Johto; leave late payoff moves late when another meaningful build already exists. Alolan Ninetales’ level-73 Encore is not an equivalent total-access problem because Encore is already on the Alolan Vulpix family tutor list.

## 6. Examples of genuinely different builds

A **+** marks a proposed addition; all unmarked moves are currently obtainable. These are four-slot examples, not optimized competitive prescriptions. The tutor and retained-move timing notes above still apply.

| Pokémon | Build | Four moves |
|---|---|---|
| Grimmsnarl | Prankster screens | Reflect **+**, Light Screen **+**, Taunt, Spirit Break |
| Grimmsnarl | Physical setup | Bulk Up, Play Rough, Drain Punch, Sucker Punch |
| Lanturn | Bulky pivot | Volt Switch **+**, Scald **+**, Ice Beam, Thunder Wave |
| Lanturn | Cleric | Surf, Heal Bell **+**, Thunder Wave, Protect |
| Beedrill | Adaptability pivot | U-turn **+**, Poison Jab, Knock Off, Protect |
| Beedrill | Physical cleaner | Swords Dance **+**, Poison Jab, Bug Bite, Knock Off |
| Blastoise | Mega Launcher offense | Shell Smash, Water Pulse, Dark Pulse **+**, Aura Sphere |
| Blastoise | Defensive spinner | Iron Defense **+**, Body Press **+**, Rapid Spin, Water Pulse |
| Scizor | Bulky pivot | U-turn **+**, Bullet Punch, Roost **+**, Knock Off |
| Scizor | Setup cleaner | Swords Dance, Bullet Punch, X Scissor, Close Combat **+** |
| Espeon | Calm Mind attacker | Calm Mind **+**, Psychic, Dazzling Gleam **+**, Morning Sun |
| Espeon | Magic Bounce screens | Reflect **+**, Light Screen **+**, Psychic, Baton Pass |
| Sylveon | Pixilate attacker | Calm Mind **+**, Hyper Voice **+**, Psychic **+**, Wish |
| Sylveon | Wish support | Wish, Protect, Moonblast, Shadow Ball |
| Gardevoir | Pixilate offense | Calm Mind, Hyper Voice **+**, Psychic, Focus Blast |
| Gardevoir | Support | Wish **+**, Protect, Will O Wisp, Moonblast |
| Ursaluna (Bloodmoon) | Special tank | Calm Mind **+**, Hyper Voice **+**, Earth Power, Moonlight **+** |
| Ursaluna (Bloodmoon) | Immediate coverage | Blood Moon, Hyper Voice **+**, Earth Power, Moonblast |
| Porygon-Z | Special breaker | Nasty Plot, Tri Attack, Ice Beam, Shadow Ball **+** |
| Porygon-Z | Speed cleaner | Agility, Tri Attack, Thunderbolt, Dark Pulse **+** |
| Armarouge | Launcher coverage | Armor Cannon, Psychic, Aura Sphere **+**, Dragon Pulse |
| Armarouge | Slow-team offense | Trick Room **+**, Armor Cannon, Psychic, Energy Ball **+** |
| Vikavolt | Web lead / pivot | Sticky Web **+**, Volt Switch **+**, Bug Buzz, Energy Ball **+** |
| Charjabug | Eviolite support | Sticky Web **+**, Volt Switch **+**, Thunder Wave, Crunch |
| Charjabug | Physical Hustle setup | Agility, Wild Charge **+**, X Scissor, Crunch |
| Togetic | Existing Eviolite tank | Calm Mind, Moonblast, Aura Sphere, Soft-Boiled |
| Unown | Custom setup build | Calm Mind **+**, Psychic, Earth Power, Shadow Ball **+** |

A physical booster, a bulky pivot and a cleric are different builds. Adding three more interchangeable attacks of the same type usually is not. Use that distinction when choosing which optional suggestions to apply.

## 7. Recommended implementation order

1. **Existing compatibility:** Sludge Bomb on the Nidos; Thunderbolt on Magmortar; Shadow Ball on Porygon-Z/Noctowl; Energy Ball on Vikavolt/Octillery/Armarouge; Psychic on Sylveon/Octillery. These are straightforward, high-value data edits.
2. **Defining utility and ability moves:** Grimmsnarl screens; Lanturn/Vikavolt Volt Switch; the Web users; Hyper Voice on the missing ability-conversion users; the priority physical/special setup gaps. Choose useful level-up/tutor timing rather than putting everything behind the same late NPC.
3. **Recovery/pivot identity:** Crobat, Scizor, Corviknight, Flygon, the Persian forms and Blastoise; Arcanine Morning Sun; Bloodmoon Ursaluna Moonlight. Then repair the retained-move reminder gaps.
4. **A general utility tutor:** Substitute and Sleep Talk first; optionally screens and Thunder Wave with explicit compatibility. This scales better than packing near-universal modern machine moves into hundreds of level-up/egg lists. Keep Ditto/Wobbuffet/other genuinely restricted cases curated.
5. **Selective P2 refinements:** apply the ones that create a distinct role you want. P3 suggestions are a menu of optional polish. The 119 P3 outcomes already have healthy pools; they are not a mandatory 119-mon buff pass.

For new level-up moves, a useful starting policy is basic support/low-power attacks around 10–25, pivots/ordinary setup around 25–40, and defining strong attacks/recovery around 30–45 where the species’ balance warrants it. Treat these as design ranges, not copied official levels. Preserve each Pokémon’s pacing and evolution requirements. Modern `L0` evolution moves need an actual evolution-teaching hook or level-1 reminder entry; the current `dbw 0` format is a terminator.

The family tutor menu currently has a 36-move capacity. Small targeted lists fit comfortably. Avoid filling it indiscriminately: keep the interesting choices visible and keep family-wide distribution intentional.

## Verification and evidence

Every recommended addition was checked to be missing from that species’ combined pool and present among the game’s 420 move definitions. All non-custom additions have ordinary Gen 4–9 learnset evidence, including official pre-evolution access. Every one of the 236 final outcomes has an individual review, all 486 unique entries appear in the roster table, and the 27 four-move examples were checked against current access plus the proposed additions. Game learnset/stat/TM/egg and relevant engine inputs match commit `a3c945df`. This section records the original review checks; current implementation and compiled-ROM validation are documented in the implementation log linked above.

The optional menu contains 440 species–move assignments: 420 with ordinary Gen 8/9 evidence, 15 with ordinary Gen 4–7 evidence, and five deliberate custom assignments across Unown, Ampharos, Bellossom and Gorochu. The appendix also inventories all 213 mapped family lists with existing choices, alternative access and breeding eligibility notes. Counts describe suggestions, not an instruction to apply every addition.

Sources for ROM behavior: [Move Reminder](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/move_deleter.asm:204), [family egg tutor](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/move_deleter.asm:556), [first-stage mapping](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/first_stages.asm:1), [breeding inheritance](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/breeding.asm:492), [Goldenrod tutor gate](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodCity.asm:34), and [move categories/power](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:1).

Comparison data were downloaded on October 2, 2026 from [Showdown learnsets](https://play.pokemonshowdown.com/data/learnsets.json), [BDSP learnsets](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/mods/gen8bdsp/learnsets.ts) and [Showdown Pokédex](https://play.pokemonshowdown.com/data/pokedex.json). SHA-256 learnsets: `cedbe661968e2d69abe9f317e9a3f5d4f2dcf989e1f937cb0cdd72e7af29ab8f`; BDSP: `afb10262f89445592ab7a2cf8dd5e6b7cebeafdce30d28092a1f92110faf54bb`; Pokédex: `078693cec920d8a573acc5bf030d4f7feaa0f5f1eddfec2d3e0753a296fa1b14`. The local analysis inputs/scripts are retained under `.tmpbuild/movepool-variety-2026-10-02/` for reproduction.
