# Trainer thematic review — consolidated fifth pass

**Implemented:** all four recommended issue groups are resolved for thirteen Pokémon in twelve parties. [See the applied fixes](trainer-theme-fixes-round5.md) and [current rosters](trainer-theme-coverage.md). The review below preserves the pre-change evidence and decisions.

Reviewed 20 October 2026 after the fourth implementation. **The original review snapshot is retained below; subsequent move fixes are linked above.** A reusable read-only moveset audit was added to make the mechanical checks repeatable.

**Conclusion:** no additional species replacement or main-character dialogue change is recommended. There are **four new issue patterns affecting 13 Pokémon slots in 12 parties**: eleven slots with nonfunctional setup/Teleport, and two Recycle dependencies. Keep the species, levels, abilities, items and encounter selections. The recommended move corrections are below.

## Coverage and completion criteria

| Area | Coverage | Result |
|---|---|---|
| Authored fixed parties | **594 parties / 1,819 Pokémon / 87 populated groups** | Every record inventoried; rematches, starter branches, legacy/unplaced records and eight clone species included. |
| Actual loaded parties | **593 source-backed records; 24,155 native ROM checks** | All match source for species, levels, items, explicit/class-default ability slots, exact selected moves and PP. CAL2 is the exception described below. |
| Selected moves | **7,230 occupied move slots; 396 distinct moves** | Inspected against all 440 local move definitions, including all selected status moves and dependency cases. |
| Stat-boosting sets | **430 Pokémon sets** | Effect-based check covers pure Attack/Special Attack boosts, Belly Drum, Growth and Tail Glow; mixed Speed/defensive boosts are assessed by their remaining benefits. Body Press and Foul Play do not count as using the user's Attack. |
| Held items | **449 holders**, including **95 type-boost item users** and **10 Eviolite users** | No additional type-boost mismatch after ability conversion, invalid Eviolite evolution, physical/special boost-item mismatch, species-specific boost mismatch, Assault Vest/status conflict or checked orb-immunity conflict. |
| Abilities | All 1,819 effective ability selections; all **498 species definitions** | Applied class defaults and empty-slot fallback. Checked relevant sleep blockers, Contrary, Damp, Klutz, type conversion, weather and item interactions. Unused ability triggers alone are not defects. |
| Ordinary trainer dialogue | **378 dialogue records** | Checked roster identity, class, setting, named partners, technique claims and after-battle context. |
| Additional script-linked dialogue | **354 additional exported text blocks** | Includes custom/boss scripts and generically named UnknownText labels; these are not 354 more distinct trainers. |
| Special characters | **35 named families**, plus Wise Trio and Kimono Girls | No new species/theme contradiction recommended; full verdicts below. |
| Battle Tower | **70 identities; 321 generated-build source records** | Shared random-team model remains intentional; full structural audit passed. |
| Player move access | All selected moves cross-checked with local level/TM/egg/tutor and pre-evolution access | 50 Pokémon rows require authored-exception context; all are listed in the appendix. Three are Smeargle/Sketch cases. These are not automatically thematic errors. |
| Previous implementation | Exact-state comparison of all 594 parties | The thirteen fourth-pass substitutions and all untargeted effective data remain intact. |

CAL2's live party is read from **Mystery Gift SRAM**, not the stored CAL2 placeholder. Its placeholder was source-reviewed, but it would be misleading to claim its source roster was loaded through the normal reader. CAL3's scaling path was exercised with an empty player party to select the documented low-level tier; the other stored Cal tiers were also loaded individually. Link/imported player teams cannot be assigned a fixed authored theme from repository data.

The complete current [species/level roster checklist](trainer-theme-coverage.md) complements this report. A direct map reference confirms a source selection, not reachability in every save.

## 1. Teleport fails in trainer battles — four Pokémon in three parties

**Highest priority: Psychic Mark's Kadabra 21 knows only Teleport, with three NO_MOVE slots.** It has no useful selected move for this encounter. Eventual Struggle after PP exhaustion does not make that an appropriate fighting set for his evolved Psychic partner. Mark's Natu and the two Sprout Tower Ralts also carry Teleport.

This engine's Teleport is an escape move and explicitly fails in trainer battles for the enemy as well as the player. It is not the later-series switching version; adding more teammates cannot make it work. The other three Pokémon still have useful moves, so their cleanup is less urgent than Kadabra's.

| Party / trainer | Location | Pokémon | Current selected moves | Suggested correction |
|---|---|---|---|---|
| [MARK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5288) — MARK | [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:311) | Natu 20 | Peck / Night Shade / Confusion / Teleport | Teleport → **Reflect**. |
| [MARK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5288) — MARK | [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:311) | Kadabra 21 | Teleport | Explicit **Psybeam / Disable / Kinesis / Reflect**. |
| [TROY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5918) — TROY | [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:105) | Ralts 7 | Growl / Teleport / Double Team / Disarming Voice | Teleport → **Reflect**. |
| [NEAL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5957) — NEAL | [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:116) | Ralts 6 | Confusion / Growl / Teleport / Double Team | Teleport → **Flash**. |

All proposed moves are legal locally. Mark's Kadabra receives an actual Psychic attack plus mind-reading/disruption support. Reflect supports the sages' bond/trust theme without replacing their partners. Neal specifically talks about the Elder's HM lighting darkness; **Flash** reinforces that existing line without rewriting it.

Evidence: [Teleport implementation](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/teleport.asm:1); [Kadabra's explicit one-move set](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5297); [Neal's existing light dialogue](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:301).

## 2. Belly Drum pays HP without benefiting any selected attack — six Pokémon

These four Politoed and two Walrein have only special attacks beside Belly Drum. The engine subtracts half maximum HP and raises **Attack**, so the payment has no offensive benefit in these particular sets. They have no Baton Pass or other selected way to use the boost. This is the same underlying design category as the earlier Nasty Plot issue, but these six sets were not included in that previous twelve-slot list.

| Party / trainer | Location | Pokémon | Current selected moves | Suggested correction |
|---|---|---|---|---|
| [GAVEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2203) — GAVEN | [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:78) | Politoed 58 | Hydro Pump / Bubblebeam / Earth Power / Belly Drum | Belly Drum → **Ice Beam**. |
| [GAVEN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2222) — GAVEN | [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:86) | Politoed 74 | Hydro Pump / Bubblebeam / Earth Power / Belly Drum | Belly Drum → **Ice Beam**. |
| [GAVEN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2273) — GAVEN | [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:28) | Politoed 48 | Hydro Pump / Bubblebeam / Earth Power / Belly Drum | Belly Drum → **Ice Beam**. |
| [GINA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5557) — GINA | [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:304) | Politoed 77 | Hydro Pump / Bubblebeam / Earth Power / Belly Drum | Belly Drum → **Ice Beam**. |
| [BLAKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2292) — BLAKE | [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:174) | Walrein 46 | Ice Beam / Freeze Dry / Water Pulse / Belly Drum | Belly Drum → **Body Slam**. |
| [MEGAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2649) — MEGAN | [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:289) | Walrein 47 | Ice Beam / Freeze Dry / Water Pulse / Belly Drum | Belly Drum → **Body Slam**. |

Ice Beam gives Politoed useful special coverage; Body Slam gives Walrein a reliable physical option with paralysis potential. Gina's Politoed must retain **Drizzle**, and all other existing abilities stay as selected. Author affected automatic sets explicitly, preserving every unaffected teammate's actual moves and ability. Do not alter the species learnsets merely to change these NPCs.

Evidence: [Belly Drum HP/stat implementation](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/belly_drum.asm:1); [move definition](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:207). All six current sets were confirmed by native ROM loading.

## 3. Jo & Zoe's Parasect uses Growth with entirely physical attacks

In this game, Growth is still **Special Attack +1 only**. Its move effect is EFFECT_SP_ATK_UP, whose command selects SP_ATTACK. Assuming the modern Attack-and-Special-Attack version would miss this problem. Parasect's X-Scissor, Seed Bomb and Slash all use Attack here.

| Party / trainer | Location | Pokémon | Current selected moves | Suggested correction |
|---|---|---|---|---|
| [JOANDZOE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6374) — JO & ZOE | [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:86) | Parasect 61 | X Scissor / Seed Bomb / Slash / Growth | Growth → **Swords Dance**. |

Swords Dance is locally legal and supports the existing physical Grass/Bug set. Parasect already fits Erika's Grass Gym and the twins' class; a species replacement is unnecessary. The other Jo & Zoe record's Victreebel has Leaf Storm and Sludge Bomb, so its Growth remains functional and should stay.

Evidence: [Growth definition](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:94); [SpecialAttackUp effect](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/effects.asm:308); [SP_ATTACK command](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/effect_commands.asm:4346).

## 4. Two Recycle sets have no starting consumable — dependency cleanup

Both start with **NO_ITEM**. Recycle needs a consumed-item history entry, and battle initialization clears that history. Neither can supply its own starting item. They therefore require unusual outside assistance, such as the player first providing a consumable. This is an unsupported dependency, not a claim that success is impossible under every player-created situation. Smart AI discourages Recycle without history, but that still leaves a wasted moveslot.

| Party / trainer | Location | Pokémon | Current selected moves | Suggested correction |
|---|---|---|---|---|
| [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) — ROSS | [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:158) | Porygon2 36 | Recycle / Foul Play / Discharge / Lock On | Recycle → **Recover**. |
| [ELLIOT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5694) — ELLIOT | [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:97) | Munchlax 21 | Recycle / Bite / Screech / Body Slam | Recycle → **Defense Curl**. |

**Preferred correction:** the move substitutions above, preserving held items. An alternative is to provide an appropriate starting Berry and retain Recycle; that changes the battle's item/recovery plan more substantially. Munchlax's Pickup does not repair its starting condition: this implementation's post-battle Pickup loop operates on the player's party, not an opposing trainer's mid-battle Munchlax.

Evidence: [Recycle history initialization](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/october_move_cores.asm:88); [Recycle failure conditions](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/october_move_cores.asm:146); [post-battle Pickup loop](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/abilities_engine.asm:1700); [Recycle AI discouragement](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/ai/scoring.asm:4957).

## Special trainers — all current verdicts

The new recommendations affect ordinary trainers and gym staff. No Gym Leader, Elite Four member, champion, rival or Rocket executive needs another species/theme replacement in this pass. All 21 Silver variants and 15 Crystal variants retain coherent evolution/partner progression. Their nonstandard player-access moves are transparently listed in the appendix rather than treated as new character-theme failures.

| Character / family | Current verdict | Authored records checked |
|---|---|---|
| Falkner | Keep. Bird identity and inherited partners remain clear. | 2; [FALKNER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:20) |
| Whitney | Keep. Lopunny now continues Buneary; the other Normal favorites still fit. | 2; [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) |
| Bugsy | Keep. Insect researcher; Scyther actually demonstrates Fury Cutter in the first fight. | 2; [BUGSY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:137) |
| Morty | Keep. Ghost/mystic collection; no missing advertised status technique. | 2; [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193) |
| Chuck | Keep. Fighting discipline and punches; the first team already demonstrates Drain Punch through Breloom. | 2; [CHUCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:391) |
| Jasmine | Keep. Steel specialist and Steelix continuity; no new species conflict. | 2; [JASMINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325) |
| Pryce | Keep. Winter specialist with real Snow Warning, freezing attacks and Ice offense. | 2; [PRYCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:254) |
| Clair | Keep. All actual local Dragon types, including modified Flygon and Altaria. | 2; [CLAIR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:457) |
| Brock | Keep. Bastiodon strengthens defense while retaining varied fossil/geology partners. | 1; [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) |
| Misty | Keep. Water specialist with recognizable Starmie and strong aquatic partners. | 1; [MISTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1064) |
| Lt. Surge | Keep. Electric specialist; Raichu’s Galvanize attacks count as Electric. | 1; [LT_SURGE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101) |
| Erika | Keep. Grass/botany theme; rain-supported Ludicolo is a valid botanical partner. | 1; [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1184) |
| Janine | Keep. Poison ninja with traps, sleep, poison and deceptive techniques. | 1; [JANINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2098) |
| Sabrina | Keep. Psychic identity; both Dream Eater users have their own sleep move. | 1; [SABRINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3324) |
| Blaine | Keep. Fire/volcano theme and burn techniques are represented. | 1; [BLAINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4659) |
| Blue | Keep. Generalist teams; changed rematch strategy is explicitly established. | 2; [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6540) |
| Will | Keep. All Psychic; the varied world-trained collection fits his introduction. | 2; [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530) |
| Koga | Keep. Both fights now have sleep. Initial confusion comes from Poison Puppeteer; rematch confusion from Crobat. | 2; [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885) |
| Bruno | Keep. Physical Fighting discipline; current species and techniques fit. | 2; [BRUNO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744) |
| Karen | Keep. Dark favorites with a wild, tough image; no beauty-only rule. | 2; [KAREN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814) |
| Lance | Keep. Dragon master with signature Dragonite; all current species fit. | 2; [LANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956) |
| Silver | Keep. All 21 variants checked. Zubat/Golbat continuity and final Crobat give the trust arc a visible payoff. Mount Moon occurs before Victory Road in this game, so the 49 → 68 level progression is coherent. | 21; [RIVAL1_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7523) |
| Crystal | Keep. All 15 variants checked. Marowak now returns at the Cape; Xatu and the custom apple evolution branches retain continuity. Xatu supplies capture-relevant paralysis. | 15; [CRYSTAL_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8095) |
| Red | Keep. Both generalist/iconic collections fit; Galvanize keeps Pikachu’s Normal-named attacks Electric. | 2; [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6503) |
| Green | Keep. Seasoned mixed-team challenger; no source-imposed monotype restriction. | 1; [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7203) |
| Agatha | Keep. Ghost/Poison veteran collection; Haunter has Hypnosis for Dream Eater, and the unevolved partners are deliberate favorites. | 1; [AGATHA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7055) |
| Lorelei | Keep. Glaceon fits the nonlegendary option; Slowbro now demonstrates Ice Beam. No further replacement needed. | 1; [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7092) |
| Eusine | Keep. The rematch now has Hypnosis on both Hypno and Gengar; the dream-hunter technique works. | 2; [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6619) |
| Ariana | Keep. Milotic now remains across both fights; the elegant/dangerous core and new Toxapex fit. | 2; [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6736) |
| Archer | Keep. Krookodile sharpens intimidation and command-team identity in both stored variants. | 2; [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6792) |
| Proton | Keep. Clawed, bullying and disruptive partners fit his threats. | 2; [PROTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6660) |
| Petrel | Keep. Both identities retain Ditto and the disguise/artificial/deceptive collection. | 2; [PETREL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6706) |
| Kiyo | Keep. His variety of Fighting Pokémon directly supports the dojo-master introduction. | 1; [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8705) |
| Li | Keep. Plant growth and bond-testing theme; selected Poison Puppeteer is intentional. | 1; [LI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8473) |
| Cal | Keep. Generalist training opponent and starter scaling fit. Runtime Mystery Gift data can replace the CAL2 placeholder. | 6; [CAL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601) |

The Wise Trio's Fire/Electric/Water cores, spiritual birds, and the Kimono Girls' Eevee-family motif also remain coherent. Cal is a mixed-team training opponent, with the dynamic Mystery Gift limitation documented above.

## Explicit decisions — considered, not recommended as fixes

These decisions close off weak candidates rather than turning ordinary design choices into more required changes:

- **Kakuna 13 with Harden only:** the remaining non-attacking set is a normal cocoon-stage weakness in an early grunt battle. It fits the species/class and is not comparable to Mark's evolved Kadabra carrying only an escape move.
- **Miller's Graveler / WADE3's Forretress using Rock Polish and Gyro Ball:** the Speed boost reduces Gyro Ball's power, but those sets retain other benefits and moves. This is a tradeoff, not an entirely wasted setup move or a trainer-theme contradiction. No compulsory correction is recommended.
- **Lock-On on Ross/Marc's Porygon2:** their attacks have 100% base accuracy, but Lock-On can still answer opposing evasion or accuracy changes. It is not categorically useless. Keep it unless intentionally redesigning the battle strategy.
- **Quiver Dance, Calm Mind, Bulk Up and Dragon Dance without matching offense:** their defensive and/or Speed benefits can still matter. The audit does not incorrectly classify them as wholly nonfunctional just because one boosted stat is unused.
- **Baton Pass with no accumulated boost:** switching can still function. Berke's lone Seel's Flip Turn still deals damage, even without a teammate to switch to.
- **Choice Scarf / Imposter Ditto:** copied offense makes this valid. The audit excludes the false positive of treating its pre-transformation Transform as an ordinary choice-locked status set.
- **Weather overlap in mixed protagonist teams and held-item Acrobatics:** these can have strategy tradeoffs without breaking species identity or causing a move to fail. No additional main-character change is recommended on that basis alone.
- **Named Pokémon absent from a team:** observation, aspiration, passwords and comparisons are not ownership claims. Existing Bellsprout-movement, starter-family, shiny Butterfree, and lost-fish lines were not turned into forced roster changes.
- **The three previously documented phone issues:** Beverly's hardcoded Snubbull/Granbull naming, RandomPhoneMon's optional ability-byte stride, and generic fixed-base-party naming remain in the [round-two report](trainer-theme-audit-round2.md#finding-3). They are pre-existing unresolved items, not newly counted discoveries.

## Repeatable checks added

Run `python3 tools/audit_trainer_movesets.py` alongside `python3 tools/audit_trainers.py`. Use `--json` for structured output. The new tool reads current sources directly and does not depend on ignored review snapshots.

The moveset audit currently reports **11 errors and 2 dependency warnings**, corresponding exactly to the thirteen slots above. It covers local stat effects/categories, automatic moves, ability defaults/fallback, relevant sleep/item dependencies, Teleport, item/category/species conflicts, and selected ability conflicts. Warnings require context; they are not automatically called impossible moves. Its nonzero exit status is expected until the newly reported errors are corrected.

The proposed replacements were applied **only in memory** to all 594 records: the full audit then returned no actionable findings. Each replacement passed the local player move-access check. The auditor also catches all thirteen old fourth-pass cases from the pre-fix snapshot, while retaining the intentional Ditto set. This makes the identified failure patterns repeatable checks rather than relying on another manual spot pass.

## Complete populated-group checklist

“Keep” means no additional supported species/theme correction recommended. It does not mean every set is competitively optimal. Source access exceptions in the appendix are tracked separately.

| Group | Parties | Pokémon | New actionable result |
|---|---:|---:|---|
| FalknerGroup | 2 | 9 | Keep |
| WhitneyGroup | 2 | 10 | Keep |
| BugsyGroup | 2 | 9 | Keep |
| MortyGroup | 2 | 10 | Keep |
| PryceGroup | 2 | 12 | Keep |
| JasmineGroup | 2 | 11 | Keep |
| ChuckGroup | 2 | 11 | Keep |
| ClairGroup | 2 | 12 | Keep |
| WillGroup | 2 | 12 | Keep |
| PKMNTrainerGroup | 6 | 24 | Keep |
| BrunoGroup | 2 | 12 | Keep |
| KarenGroup | 2 | 12 | Keep |
| KogaGroup | 2 | 12 | Keep |
| ChampionGroup | 2 | 12 | Keep |
| BrockGroup | 1 | 6 | Keep |
| MistyGroup | 1 | 6 | Keep |
| LtSurgeGroup | 1 | 6 | Keep |
| ScientistGroup | 5 | 8 | Recycle dependency |
| ErikaGroup | 1 | 6 | Keep |
| YoungsterGroup | 14 | 32 | Keep |
| SchoolboyGroup | 24 | 69 | Keep |
| BirdKeeperGroup | 19 | 51 | Keep |
| LassGroup | 19 | 53 | Keep |
| JanineGroup | 1 | 6 | Keep |
| CooltrainerMGroup | 21 | 80 | Belly Drum cleanup |
| CooltrainerFGroup | 22 | 80 | Belly Drum cleanup |
| BeautyGroup | 6 | 11 | Keep |
| PokemaniacGroup | 15 | 36 | Keep |
| GruntMGroup | 18 | 52 | Keep |
| GentlemanGroup | 4 | 7 | Keep |
| SkierGroup | 4 | 8 | Keep |
| TeacherGroup | 3 | 6 | Keep |
| SabrinaGroup | 1 | 6 | Keep |
| BugCatcherGroup | 19 | 57 | Keep |
| FisherGroup | 25 | 70 | Keep |
| SwimmerMGroup | 13 | 29 | Keep |
| SwimmerFGroup | 13 | 28 | Keep |
| SailorGroup | 13 | 31 | Keep |
| SuperNerdGroup | 9 | 19 | Keep |
| GuitaristGroup | 2 | 7 | Keep |
| HikerGroup | 22 | 72 | Keep |
| BlaineGroup | 1 | 6 | Keep |
| BurglarGroup | 5 | 14 | Keep |
| FirebreatherGroup | 8 | 20 | Keep |
| JugglerGroup | 9 | 29 | Keep |
| BlackbeltGroup | 11 | 32 | Keep |
| ExecutiveMGroup | 4 | 18 | Keep |
| PsychicGroup | 12 | 31 | Teleport cleanup |
| PicnickerGroup | 19 | 59 | Belly Drum cleanup |
| SchoolGirlGroup | 8 | 16 | Keep |
| CamperGroup | 16 | 43 | Recycle dependency |
| ExecutiveFGroup | 2 | 9 | Keep |
| SageGroup | 11 | 26 | Teleport cleanup |
| MediumGroup | 5 | 13 | Keep |
| BoarderGroup | 6 | 15 | Keep |
| PokefanMGroup | 15 | 34 | Keep |
| KimonoGirlGroup | 9 | 11 | Keep |
| TwinsGroup | 10 | 24 | Growth cleanup |
| PokefanFGroup | 6 | 11 | Keep |
| RedGroup | 1 | 6 | Keep |
| BlueGroup | 1 | 6 | Keep |
| OfficerGroup | 3 | 7 | Keep |
| MysticalmanGroup | 2 | 8 | Keep |
| ProtonGroup | 2 | 7 | Keep |
| PetrelGroup | 1 | 4 | Keep |
| ArianaGroup | 2 | 9 | Keep |
| ArcherGroup | 2 | 10 | Keep |
| PetrelDirectorGroup | 1 | 4 | Keep |
| HexManiacGroup | 3 | 10 | Keep |
| CosplayerGroup | 6 | 14 | Keep |
| NinjaGroup | 4 | 12 | Keep |
| AgathaGroup | 1 | 6 | Keep |
| LoreleiGroup | 1 | 6 | Keep |
| Red2Group | 1 | 6 | Keep |
| BlueCloakGroup | 1 | 6 | Keep |
| GreenGroup | 1 | 6 | Keep |
| BattleGirlGroup | 4 | 12 | Keep |
| TamerGroup | 5 | 15 | Keep |
| GruntFGroup | 16 | 34 | Keep |
| Rival1Group | 15 | 60 | Keep |
| Rival2Group | 6 | 36 | Keep |
| CrystalGroup | 15 | 63 | Keep |
| ElderGroup | 1 | 3 | Keep |
| AromaLadyGroup | 3 | 11 | Keep |
| BikerGroup | 9 | 26 | Keep |
| CueballGroup | 1 | 6 | Keep |
| KarateKingGroup | 1 | 5 | Keep |

## Appendix — NPC sets outside standard player-access pools

The cross-check found **50 Pokémon rows**, of which **three are Smeargle with expected Sketch access**. The other **47 are authored move-access exceptions to assess under the game's design policy**, not 47 newly proven thematic bugs. This review's established rubric does not treat move/evolution legality by itself as a thematic error. The engine permits authored NPC sets; several differences support an obvious existing role, such as Galvanize Hyper Voice, Rock Head Head Smash, or a singing bird. Their actual use in the ROM is verified.

The complete list is included so these cases are not hidden or rediscovered piecemeal. **No blanket replacement is recommended solely because a move is absent from the standard static player pool.** If strict player/NPC learnset parity is later required, this is the complete current exception list to resolve as a separate design change. Recommended fixes earlier in this report all use locally accessible moves regardless.

| Party | Pokémon | Outside the checked ordinary player-access pool | Context |
|---|---|---|---|
| [FALKNER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:39) | Pidgeot 77 | Hyper Voice | Authored NPC move-access exception; no theme-only change recommended. |
| [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) | Clefairy 18 | Fairy Wind | Authored NPC move-access exception; no theme-only change recommended. |
| [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) | Buneary 19 | Karate Chop | Authored NPC move-access exception; no theme-only change recommended. |
| [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193) | Misdreavus 24 | Fairy Wind | Authored NPC move-access exception; no theme-only change recommended. |
| [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193) | Gengar 25 | Sludge | Authored NPC move-access exception; no theme-only change recommended. |
| [JASMINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325) | Skarmory 31 | U Turn | Authored NPC move-access exception; no theme-only change recommended. |
| [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530) | Grumpig 69 | Thunderbolt | Authored NPC move-access exception; no theme-only change recommended. |
| [WILL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:564) | Grumpig 85 | Thunderbolt | Authored NPC move-access exception; no theme-only change recommended. |
| [LANCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:990) | Dragapult 87 | Crunch | Authored NPC move-access exception; no theme-only change recommended. |
| [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) | Aerodactyl 47 | Head Smash | Authored NPC move-access exception; no theme-only change recommended. |
| [LT_SURGE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101) | Raichu 58 | Hyper Voice | Authored NPC move-access exception; no theme-only change recommended. |
| [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1184) | Tsareena 62 | Swords Dance | Authored NPC move-access exception; no theme-only change recommended. |
| [HANK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1715) | Archeops 51 | X Scissor | Authored NPC move-access exception; no theme-only change recommended. |
| [BORIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1735) | Pidgeot 60 | Hyper Voice | Authored NPC move-access exception; no theme-only change recommended. |
| [JULIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2861) | Tsareena 61 | Iron Tail | Authored NPC move-access exception; no theme-only change recommended. |
| [BRENT4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3008) | Tauros 77 | Superpower | Authored NPC move-access exception; no theme-only change recommended. |
| [LYLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4804) | Tauros Paldean Fire 58 | Aqua Jet | Authored NPC move-access exception; no theme-only change recommended. |
| [IRWIN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4901) | Rapidash Galarian 56 | Moonblast | Authored NPC move-access exception; no theme-only change recommended. |
| [IRWIN4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4917) | Rapidash Galarian 63 | Moonblast | Authored NPC move-access exception; no theme-only change recommended. |
| [SHARON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5606) | Smeargle 51 | Baton Pass / Extremespeed / Shell Smash / Spore | Expected Sketch access; keep. |
| [SID](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5728) | Ambipom 55 | Dizzy Punch | Authored NPC move-access exception; no theme-only change recommended. |
| [JEREMY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6186) | Milotic 57 | Calm Mind | Authored NPC move-access exception; no theme-only change recommended. |
| [ANNANDANNE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6356) | Kotora 25 | Slack Off | Authored NPC move-access exception; no theme-only change recommended. |
| [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6503) | Pikachu 88 | Hyper Voice | Authored NPC move-access exception; no theme-only change recommended. |
| [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6540) | Pidgeot 66 | Signal Beam | Authored NPC move-access exception; no theme-only change recommended. |
| [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6540) | Electivire 69 | Crunch | Authored NPC move-access exception; no theme-only change recommended. |
| [COSPLAYER5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6974) | Smeargle 51 | Baton Pass / Body Slam / Substitute / Transform | Expected Sketch access; keep. |
| [COSPLAYER6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6984) | Smeargle 51 | Baton Pass / Body Slam / Spikes / Spore | Expected Sketch access; keep. |
| [RED2_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7129) | Pikachu 83 | Hyper Voice | Authored NPC move-access exception; no theme-only change recommended. |
| [RED2_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7129) | Charizard 85 | Draco Meteor | Authored NPC move-access exception; no theme-only change recommended. |
| [BLUE_CLOAK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7166) | Electivire 84 | Crunch | Authored NPC move-access exception; no theme-only change recommended. |
| [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7203) | Lanturn 82 | Flash Cannon | Authored NPC move-access exception; no theme-only change recommended. |
| [TAMER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7327) | Tauros 59 | Superpower | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_3_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7607) | Bayleef 24 | Mega Drain | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7679) | Slowking 41 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7713) | Slowking 41 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7747) | Slowking Galarian 41 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7781) | Slowking 69 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7815) | Slowking 69 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL1_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7849) | Slowking Galarian 69 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7886) | Slowking 51 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7920) | Slowking 51 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7954) | Slowking Galarian 51 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7988) | Slowking 83 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8022) | Slowking 83 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [RIVAL2_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8056) | Slowking Galarian 83 | Recover | Authored NPC move-access exception; no theme-only change recommended. |
| [CRYSTAL_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8137) | Applin 17 | Growth | Authored NPC move-access exception; no theme-only change recommended. |
| [CRYSTAL_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8161) | Applin 17 | Growth | Authored NPC move-access exception; no theme-only change recommended. |
| [CRYSTAL_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8185) | Applin 17 | Growth | Authored NPC move-access exception; no theme-only change recommended. |
| [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8705) | Sneasler 67 | Triple Axel | Authored NPC move-access exception; no theme-only change recommended. |

## Verification and limits

The structural audit passed for all **594 parties / 734 references / 104 class rows / 321 Tower builds**. The existing release ROM's native reader passed **24,155 checks across all 593 source-backed fixed parties**. CAL2 is the documented save-data exception. No build was needed because this pass did not alter game data.

This review combines source/dialogue analysis, effective-data checks and native party loading. It does not claim a playthrough of every encounter, proof of every AI decision, or a guarantee against every future thematic interpretation. The reusable checks cover the mechanical failure patterns found across the previous passes and this one; they complement human character/theme review rather than replacing it.
