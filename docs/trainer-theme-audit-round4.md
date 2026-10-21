# Trainer thematic review — fourth pass

**Implemented:** all thirteen recommended move substitutions have been applied. [See the applied fixes](trainer-theme-fixes-round4.md) and [current rosters](trainer-theme-coverage.md). The review below preserves the pre-change evidence.

Reviewed 20 October 2026 after the third set of fixes. **The original review snapshot is retained below; subsequent move fixes are linked above.**

**Result:** no further species replacements or main-character dialogue changes are recommended. There is one clear moveset problem repeated across **12 Pokémon in 12 parties**, plus **one optional Snore improvement**. These Pokémon already fit their trainer classes and settings; the new recommendations concern how their selected moves function.

## Scope and method

- Fresh source inventory: **594 authored parties, 1,819 Pokémon slots, 87 populated groups**; rematches and starter branches included.
- Rechecked the **378 ordinary trainer-dialogue records** and **354 additional text blocks reachable through trainer scripts**, including post-battle and generically named text labels. These are source text records, not 732 different trainers.
- Revisited the 35 named special-trainer families listed below, alongside the Wise Trio, Kimono Girls, and the 70 Battle Tower identities/shared team system.
- Resolved actual selected moves for every party, including automatic level-up sets; resolved trainer-class ability defaults and empty-slot fallback. Used this game's **498 species definitions**, including clones, and **440 move definitions** rather than assuming official-series types, abilities, or move categories.
- Checked setup/attack compatibility, sleep dependencies, item/move conflicts, status items, Attract on genderless users, Stockpile dependencies, and selected advertised techniques. Checked proposed replacements against local learnsets, TMs, egg moves, tutors and pre-evolution access.

The existing [complete roster checklist](trainer-theme-coverage.md) remains the roster reference. The fresh group-by-group coverage below records this pass's outcome. A direct map reference confirms source selection, not reachability in every save.

## 1. Ineffective setup moves — 12 Pokémon / 12 parties

**Eleven sets use Nasty Plot without a special attack; Spencer's Abomasnow uses Swords Dance without a physical attack.** This engine uses individual physical/special move categories. These sets also lack Baton Pass, Stored Power, or Power Trip to give the otherwise unused boost another purpose. Their setup move can consume a turn without improving their selected attacks.

Keep every species, level, party size and existing ability. The following are the actual effective sets, including automatic moves:

| Trainer / party | Location | Pokémon | Current selected moves |
|---|---|---|---|
| Scientist Ross — [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) | [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:158) | Croagunk 36 | Acid Armor / Drain Punch / Nasty Plot / Toxic |
| Schoolboy Jack (JACK4 rematch) — [JACK4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1547) | [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:150) | Farigiraf 71 | Calm Mind / Nasty Plot / Double-Edge / Giga Impact |
| Cooltrainer Reena (final rematch) — [REENA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2772) | [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:254) | Crobat 70 | Cross Poison / Wing Attack / Crunch / Nasty Plot |
| Rocket Grunt M 25 — [GRUNTM_25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3138) | [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:223) | Toxicroak 39 | Brick Break / Nasty Plot / Toxic / Sucker Punch |
| Gentleman Gregory — [GREGORY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3229) | [VermilionGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:50) | Raichu 57 | ThunderPunch / Spark / Iron Tail / Nasty Plot |
| Psychic Franklin — [FRANKLIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5224) | [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:59) | Hypno 61 | Zen Headbutt / Psycho Cut / Drain Punch / Nasty Plot |
| Boarder Spencer — [BOARDER_SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6087) | [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:309) | Abomasnow 40 | Giga Drain / Swords Dance / Mist / Freeze Dry |
| Pokefan Joshua — [JOSHUA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6127) | [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:25) | Raichu 61 | ThunderPunch / Wild Charge / Iron Tail / Nasty Plot |
| Ninja Kane — [NINJA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6986) | [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:76) | Golbat 61 | Brave Bird / Cross Poison / Wing Attack / Nasty Plot |
| Ninja Shiro — [NINJA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6999) | [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:110) | Golbat 61 | Brave Bird / Cross Poison / Wing Attack / Nasty Plot |
| Ninja Kaede — [NINJA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7012) | [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:144) | Crobat 61 | Brave Bird / Cross Poison / Wing Attack / Nasty Plot |
| Tamer Rigby — [TAMER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7313) | [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:58) | Persian 61 | Double-Edge / Crush Claw / Play Rough / Nasty Plot |

**Suggested corrections:** all replacement moves below are legal in the local game data. Several are fixes to normal-format automatic sets: author the trainer's moves explicitly rather than changing the player-facing species learnset. When converting a party format, preserve the other party members' effective moves and abilities.

| Trainer | Move change | Reason |
|---|---|---|
| Scientist Ross | Nasty Plot → **Sludge Bomb** | Adds special Poison offense to the scientist's chemical/poison set; replaces the unused boost. |
| Schoolboy Jack (JACK4 rematch) | Nasty Plot → **Psychic** | Adds Psychic offense and gives the retained Calm Mind an attacking benefit too. |
| Cooltrainer Reena (final rematch) | Nasty Plot → **Roost** | Keeps the physical bat set and adds reliable recovery for an experienced rematch trainer. |
| Rocket Grunt M 25 | Nasty Plot → **Sludge Bomb** | Adds direct Poison offense while retaining disruptive Toxic and Sucker Punch. |
| Gentleman Gregory | Spark → **Thunderbolt** | Keeps Nasty Plot and gives the Electric Gym veteran a special Electric attack. |
| Psychic Franklin | Psycho Cut → **Psychic** | Keeps Nasty Plot and gives the Psychic Gym trainer a special Psychic attack. |
| Boarder Spencer | Swords Dance → **Blizzard** | Adds special Ice offense that benefits from his now-correct Snow Warning. |
| Pokefan Joshua | Wild Charge → **Thunderbolt** | Keeps Nasty Plot and adds a special Electric attack to benefit from it. |
| Ninja Kane | Nasty Plot → **Confuse Ray** | Preserves the physical bat; confusion supports the gym's deception theme. |
| Ninja Shiro | Nasty Plot → **Confuse Ray** | Preserves the physical bat; confusion supports the gym's deception theme. |
| Ninja Kaede | Nasty Plot → **Confuse Ray** | Preserves the physical bat; confusion supports the gym's deception theme. |
| Tamer Rigby | Nasty Plot → **Hone Claws** | Boosts the physical attacks and improves Play Rough accuracy; fits controlled beast training. |

Spencer's previous Snow Warning fix remains correct. Swords Dance was already present in the preserved automatic set; this is a separate pre-existing moveset issue, not a reason to revert his weather ability. Jack's Calm Mind still raises Special Defense in the present set, so it is not wholly useless; replacing Nasty Plot with Psychic makes its Special Attack increase useful as well.

**Engine evidence:** [move categories and setup effects](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:34), [Attack +2 and Special Attack +2 commands](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/effect_commands.asm:4366), and [damage-category selection](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/effect_commands_core.asm:2491).

## 2. Optional: Camper Ted's Ursaluna relies on enemy-induced sleep

[TED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5733) — [Route 46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:15) — Ursaluna 44, Bulletproof, no held item. Its selected moves are **Brick Break / Snore / Crunch / Body Press**.

Snore requires its user to be asleep, and this set has no Rest. It can still work if the opponent puts Ursaluna to sleep, so this is **conditional anti-sleep coverage, not an entirely unusable move**. The species fits the outdoors/camping class already.

**Optional improvement:** Snore → **Body Slam**, a legal reliable physical Normal attack. This is lower priority than the twelve setup fixes. Keeping Snore is defensible if the conditional behavior is intentional; no species replacement is needed. [Actual Snore sleep check](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/snore.asm:1).

## Special trainers — current verdicts

No additional species or dialogue mismatch was found in these families. Their earlier accepted changes remain coherent. The new setup findings in Vermilion, Saffron and Fuchsia concern gym staff, not Lt. Surge, Sabrina or Janine.

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
| Erika | Keep. Grass/botany theme; rain-supported Ludicolo is a valid botanical partner. | 1; [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1182) |
| Janine | Keep. Poison ninja with traps, sleep, poison and deceptive techniques. | 1; [JANINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2092) |
| Sabrina | Keep. Psychic identity; both Dream Eater users have their own sleep move. | 1; [SABRINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3316) |
| Blaine | Keep. Fire/volcano theme and burn techniques are represented. | 1; [BLAINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4651) |
| Blue | Keep. Generalist teams; changed rematch strategy is explicitly established. | 2; [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6526) |
| Will | Keep. All Psychic; the varied world-trained collection fits his introduction. | 2; [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530) |
| Koga | Keep. Both fights now have sleep. Initial confusion comes from Poison Puppeteer; rematch confusion from Crobat. | 2; [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885) |
| Bruno | Keep. Physical Fighting discipline; current species and techniques fit. | 2; [BRUNO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744) |
| Karen | Keep. Dark favorites with a wild, tough image; no beauty-only rule. | 2; [KAREN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814) |
| Lance | Keep. Dragon master with signature Dragonite; all current species fit. | 2; [LANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956) |
| Silver | Keep. All 21 variants checked. Zubat/Golbat continuity and final Crobat give the trust arc a visible payoff. Mount Moon occurs before Victory Road in this game, so the 49 → 68 level progression is coherent. | 21; [RIVAL1_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7509) |
| Crystal | Keep. All 15 variants checked. Marowak now returns at the Cape; Xatu and the custom legal apple branches retain continuity. Xatu supplies capture-relevant paralysis. | 15; [CRYSTAL_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8081) |
| Red | Keep. Both generalist/iconic collections fit; Galvanize keeps Pikachu’s Normal-named attacks Electric. | 2; [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6489) |
| Green | Keep. Seasoned mixed-team challenger; no source-imposed monotype restriction. | 1; [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7189) |
| Agatha | Keep. Ghost/Poison veteran collection; Haunter has Hypnosis for Dream Eater, and the unevolved partners are deliberate favorites. | 1; [AGATHA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7041) |
| Lorelei | Keep. Glaceon fits the nonlegendary option; Slowbro now demonstrates Ice Beam. No further replacement needed. | 1; [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7078) |
| Eusine | Keep. The rematch now has Hypnosis on both Hypno and Gengar; the dream-hunter technique works. | 2; [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6605) |
| Ariana | Keep. Milotic now remains across both fights; the elegant/dangerous core and new Toxapex fit. | 2; [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6722) |
| Archer | Keep. Krookodile sharpens intimidation and command-team identity in both stored variants. | 2; [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6778) |
| Proton | Keep. Clawed, bullying and disruptive partners fit his threats. | 2; [PROTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6646) |
| Petrel | Keep. Both identities retain Ditto and the disguise/artificial/deceptive collection. | 2; [PETREL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6692) |
| Kiyo | Keep. His variety of Fighting Pokémon directly supports the dojo-master introduction. | 1; [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8691) |
| Li | Keep. Plant growth and bond-testing theme; selected Poison Puppeteer is intentional. | 1; [LI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8459) |
| Cal | Keep. Generalist training opponent and starter scaling fit. Runtime Mystery Gift data can replace the CAL2 placeholder. | 6; [CAL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601) |

The Wise Trio's Fire/Electric/Water cores and spiritual birds remain coherent. The Kimono Girls retain their Eevee-family motif. Naoko's previously unsupported Dream Eater has already been replaced. Neither group needs a further species change.

## Candidates excluded and earlier issues kept separate

- **Imposter Ditto with Choice Scarf:** the automatic scan flags Transform as a status move, but Imposter copies an opposing set on entry and Scarf supports that role. This is not a new moveset error. The particular COSPLAYER1 record also has no direct map reference.
- **Battle Tower off-class teams:** the 70 identities intentionally use shared generated teams. They are not 70 authored themed rosters; random pairings do not warrant forced species replacements. The structural audit also checks 321 Tower builds.
- **Abilities without a selected trigger:** an ability being unused in one set is not enough by itself to declare a thematic defect. Empty optional ability slots correctly fall back to slot 1; occupied slots do not.
- **Known phone issues:** Beverly's Snubbull/Granbull naming, the optional ability-byte stride in RandomPhoneMon, and generic fixed-base-party species references remain the separately documented [round-two phone findings](trainer-theme-audit-round2.md#finding-3). They are not counted as new discoveries here.
- **Earlier third-pass fixes:** Wayne's Headbutt partner, supported Dream Eater sets, Spencer's Snow Warning, Kelly's controlled attacks/Rock Head, Adrian's type coverage, and Raymond's Magikarp remain in the verified state. No new dialogue changes are proposed for main characters.

## Fresh coverage by populated trainer group

“Keep” means no additional supported thematic/species change recommended in this pass, not a claim that every move is competitively optimal. Setup and optional findings are labeled separately.

| Group | Parties | Pokémon | New result |
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
| ScientistGroup | 5 | 8 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| ErikaGroup | 1 | 6 | Keep |
| YoungsterGroup | 14 | 32 | Keep |
| SchoolboyGroup | 24 | 69 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| BirdKeeperGroup | 19 | 51 | Keep |
| LassGroup | 19 | 53 | Keep |
| JanineGroup | 1 | 6 | Keep |
| CooltrainerMGroup | 21 | 80 | Keep |
| CooltrainerFGroup | 22 | 80 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| BeautyGroup | 6 | 11 | Keep |
| PokemaniacGroup | 15 | 36 | Keep |
| GruntMGroup | 18 | 52 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| GentlemanGroup | 4 | 7 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
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
| PsychicGroup | 12 | 31 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| PicnickerGroup | 19 | 59 | Keep |
| SchoolGirlGroup | 8 | 16 | Keep |
| CamperGroup | 16 | 43 | [Optional Snore improvement](#2-optional-camper-teds-ursaluna-relies-on-enemy-induced-sleep) |
| ExecutiveFGroup | 2 | 9 | Keep |
| SageGroup | 11 | 26 | Keep |
| MediumGroup | 5 | 13 | Keep |
| BoarderGroup | 6 | 15 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| PokefanMGroup | 15 | 34 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| KimonoGirlGroup | 9 | 11 | Keep |
| TwinsGroup | 10 | 24 | Keep |
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
| NinjaGroup | 4 | 12 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| AgathaGroup | 1 | 6 | Keep |
| LoreleiGroup | 1 | 6 | Keep |
| Red2Group | 1 | 6 | Keep |
| BlueCloakGroup | 1 | 6 | Keep |
| GreenGroup | 1 | 6 | Keep |
| BattleGirlGroup | 4 | 12 | Keep |
| TamerGroup | 5 | 15 | [Setup move correction](#1-ineffective-setup-moves--12-pokémon--12-parties) |
| GruntFGroup | 16 | 34 | Keep |
| Rival1Group | 15 | 60 | Keep |
| Rival2Group | 6 | 36 | Keep |
| CrystalGroup | 15 | 63 | Keep |
| ElderGroup | 1 | 3 | Keep |
| AromaLadyGroup | 3 | 11 | Keep |
| BikerGroup | 9 | 26 | Keep |
| CueballGroup | 1 | 6 | Keep |
| KarateKingGroup | 1 | 5 | Keep |

## Verification and limits

- The full source audit passed: **594 parties, 734 trainer references, 104 class-table rows and 321 Battle Tower builds**.
- The existing release ROM's native **ReadTrainerParty** loaded all **13 reviewed parties** and passed **484 checks** for species, levels, held items, explicit ability slots, exact effective moves and nonzero PP. This confirms the current data described above, including the automatic moves that are easy to miss in the party source.
- The preceding implementation's exact-state verifier still passed. All thirteen proposed replacement moves passed the local move-access check.
- No additional Assault Vest/status conflict, Black Sludge/type mismatch, checked status-orb immunity conflict, genderless Attract user, unsupported Stockpile dependency, or unsupported Dream Eater set was found in the fixed authored teams.
- This is a source/data review with native party loading, not a playthrough of every encounter or proof of every AI decision. No new game build was required because this pass changed documentation only.
