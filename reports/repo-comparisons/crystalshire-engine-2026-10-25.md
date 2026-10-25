# CrystalShireEngine opportunities for Crimson Crystal

Source comparison: October 25, 2026. This is a recommendation and source-history audit; no game code was changed and no new ROM tests were run.

## Result

The best immediate candidates are running shoes, a battle-weather indicator, FAST default text, showing the current level cap, instant Kurt crafting, text compression, and additional bank/space analysis tools. Following Pokémon and doubles are the largest new gameplay opportunities. Dynamic overworld palettes, larger tilesets and character customization offer substantial presentation improvements. Team EXP and level scaling need deliberate balance decisions.

Crimson already has many headline CSE improvements and, in several areas, a substantially more customized implementation. Port individual ideas into Crimson; replacing the engine would discard or conflict with existing work.

## Sources and scope

The downloaded repository is [aaronjeter/CrystalShireEngine](https://github.com/aaronjeter/CrystalShireEngine). Its README is incomplete for the feature branches. I inspected the default source tree, its CSE development history, the branch histories, and selected implementation files and patches from the other branches. This is broad coverage of identifiable improvements, not a proof that every line-level difference is useful or that every historical fix is absent from Crimson.

| Branch | Reviewed revision | What it contributes |
| --- | --- | --- |
| core | `5c747bf0bf925d1d38cff569d39d8cdd3eb076e4` | General engine, graphics, storage, inventory and legacy bug fixes. 5,661 total history commits; 457 first-parent commits after the CSE/pokecrystal16 preparation boundary `7123dd72`. |
| LevelScaling | `d9e2aca05ed71d737d6a4eacbb34478317549ab1` | Most extensive game branch: progression, regional content, followers, doubles, customization, text compression and testing. |
| Crystal_Lattice | `8b5eb01a0865b432a8901f52d7ab2b47923e17a2` | Alternate game content, custom species/forms/abilities and regional expansion. |
| gen3 | `f62fab72c16072d149d5b1aaf66090f92991cb58` | Gen 3 data, IV/personality/nature work, breeding, balls and animations. |
| gen3-abilities | `5bdc64119d4f639ffb97011b85e43c955e8c19a4` | Additional ability implementation, including entrance effects and Trace state reset. |
| weather-test | `504cde8c8bc0070266af83e9e6e590aaa3a7236a` | Weather experiments, including particles, lightning, transitions and battle weather. |
| broke-effects | `28488561af608cdcf50ca065297eb3c40282e2ee` | Experimental move effects/animations. Treat as reference material requiring validation. |
| SnowflakePort | `0ae2f7b3aa881cdd5df9feaf23b5ebdeb5c5095c` | Ancestor of the reviewed core head; no unique commits relative to core. |

Crimson baseline: local working tree at `0b43b0b6`, initially clean. Relevant existing implementation evidence includes `docs/engine-optimizations.md`, `docs/pc_storage_design.md`, `crimson-crystal-docs/qol-audit.md`, and the actual assembly files. Previous test results mentioned in those documents were not rerun during this comparison.

Status meanings: **Add** = a concrete gap identified in the reviewed Crimson source; **Adapt** = a useful candidate whose behavior or architecture needs redesign; **Keep** = Crimson already has an equivalent; **Audit** = a source of fixes or tests, without a claim Crimson currently has the bug. Effort is relative, not an estimate in days.

## 1. Player-facing changes

| ID | Candidate | Benefit and Crimson-specific assessment | Priority / effort | Source |
| --- | --- | --- | --- | --- |
| P01 | Hold B to run | **Add.** Crimson has walking, cycling, skating and 60 FPS scheduling, but its ordinary movement path has no B-button running check. Reduce travel time while preserving ledges, ice, forced movement, Surf and indoor rules. Autorun would be a separate Crimson extension. | High / medium | [running implementation](https://github.com/aaronjeter/CrystalShireEngine/commit/1cfe672ac) |
| P02 | Running alerts spinning trainers | **Adapt, optional.** Running near spinners can make them face the player. Adds a stealth tradeoff; adopt only if that is desirable for Crimson's difficulty. | Low / medium | [trainer detection](https://github.com/aaronjeter/CrystalShireEngine/commit/f1cdcb2ad) |
| P03 | Battle weather icon | **Add.** Persistent weather information while choosing moves is especially useful with Crimson's weather abilities. Core's icon covers rain/sun/sand; adapt for Hail and suppressed weather. A remaining-turn counter would be a new extension. Avoid the occupied ability-banner/HUD tiles and OAM. | High / medium | [core implementation](https://github.com/aaronjeter/CrystalShireEngine/commit/a866f7834), [Hail branch change](https://github.com/aaronjeter/CrystalShireEngine/commit/797091a44) |
| P04 | FAST text as the default | **Add.** Crimson's default options still select MED. This is a small, useful change for new saves. Instant text is an additional design, not established by this donor change. | High / small | [default text change](https://github.com/aaronjeter/CrystalShireEngine/commit/aa2dd2ef7) |
| P05 | Display the active level cap on the trainer card | **Add/adapt.** Crimson already enforces Hard Mode caps; making the current cap visible explains blocked EXP/candies. Keep Crimson's progression schedule. | High / small-medium | [cap display](https://github.com/aaronjeter/CrystalShireEngine/commit/ef9a58ac8) |
| P06 | Instant Apricorn crafting | **Adapt.** Removes Kurt's real-time wait. Keep Crimson's existing harvest quantities and reward scripts. A throughput decision, rather than a battle rebalance. | High / small-medium | [Kurt crafting](https://github.com/aaronjeter/CrystalShireEngine/commit/a2ad971b1) |
| P07 | Team EXP for nonparticipants | **Adapt.** Reduces replacement-team grinding. CSE history contains different nonparticipant shares and a progression-dependent adjustment; choose a Crimson toggle and cap behavior rather than adopting a historical percentage blindly. Exclude eggs and define fainted-member behavior. | High / large | [shared EXP](https://github.com/aaronjeter/CrystalShireEngine/commit/8f22b3bb7), [progression adjustment](https://github.com/aaronjeter/CrystalShireEngine/commit/17aaa0abc) |
| P08 | EXP for catching Pokémon | **Adapt.** Rewards collection. Reuse Crimson's EXP, level-up, evolution and cap paths; account for captures sent directly to storage and contest battles. | Medium / medium-large | [catch EXP](https://github.com/aaronjeter/CrystalShireEngine/commit/386cc8869) |
| P09 | Clearer bag pocket graphics | **Adapt.** CSE draws pocket indicators and changes the bag layout. Improve pocket recognition; retain Crimson's repeated-use item flow, 16-bit IDs and cursor behavior. | Medium / medium | [bag display](https://github.com/aaronjeter/CrystalShireEngine/commit/f133a2f14) |
| P10 | Generalized bag pocket expansion | **Adapt.** Useful for more item categories or larger pockets. Current capacities are already identical: 40 item stacks, 12 Ball stacks, 25 Key Items and 50 PC stacks. A size increase alone offers no new benefit unless deliberately raised. | Medium / large if save layout changes | [newbag source](https://github.com/aaronjeter/CrystalShireEngine/tree/core/engine/items) |
| P11 | Following party Pokémon | **Adapt.** Strong visual/personality addition. The branch chooses the first conscious non-egg party member and uses following logic across maps. Requires art for Crimson's roster and rules for Surf, bike, ledges, cutscenes and crowded maps. | Medium-high / very large | [follower implementation](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/engine/overworld/follower.asm) |
| P12 | Species-colored walking Pokémon and menu icons | **Adapt.** Reuse follower artwork as overworld/menu graphics; shared art can give a consistent identity. Compare against Crimson's already colored PC and party icons. | Medium / large art integration | [icon refactor](https://github.com/aaronjeter/CrystalShireEngine/commit/c100cecbc), [follower colors](https://github.com/aaronjeter/CrystalShireEngine/commit/709e1bc59) |
| P13 | Playable character selection | **Adapt.** More protagonist options and an explicit selection screen. Integrate naming, fishing, bike/Surf sprites, back pictures, trainer card and linked appearance. | Medium / large | [selection menu](https://github.com/aaronjeter/CrystalShireEngine/commit/58f72aac3), [Green character](https://github.com/aaronjeter/CrystalShireEngine/commit/69e66dcb7) |
| P14 | Player colors independent of gender | **Adapt.** Separates palette choice from protagonist identity. Can be a smaller first step than adding whole characters. | Medium / medium | [player colors](https://github.com/aaronjeter/CrystalShireEngine/commit/489f98c4c) |
| P15 | Wardrobe / appearance-changing service | **Adapt.** Lets players change appearance after starting. Keep saved selection and all sprite modes consistent. | Medium-low / medium | [wardrobe menu](https://github.com/aaronjeter/CrystalShireEngine/commit/39db473f3) |
| P16 | Scrolling setup menus | **Adapt.** Useful if Crimson's intro gains more rule, origin or character choices. Preserve its existing Original/Enhanced, difficulty and abilities choices. | Medium / medium | [intro menus](https://github.com/aaronjeter/CrystalShireEngine/commit/4fa0e566c) |
| P17 | Type icons | **Adapt.** Faster recognition in summaries and move information. Crimson already provides detailed type/category text; icons are presentation polish. | Medium / medium | [type icons](https://github.com/aaronjeter/CrystalShireEngine/commit/c83ef3ec9) |
| P18 | Mixed-case Pokémon/trainer/interface text | **Adapt.** Improves readability and gives a more modern presentation. Broad text, naming and font review is needed; do not damage nicknames or text control codes. | Medium-low / large content pass | [decapitalization](https://github.com/aaronjeter/CrystalShireEngine/commit/ea6ec2c1f) |
| P19 | Hall of Fame splash/presentation | **Adapt.** Makes a major milestone more satisfying. Preserve Crimson's Hall of Fame/save format and custom League progression. | Medium-low / medium | [Hall of Fame page](https://github.com/aaronjeter/CrystalShireEngine/commit/32d21faac) |
| P20 | Colored Pokémon picture popups | **Audit/adapt.** Improve event presentations where pictures currently use generic palettes. Check existing Crimson popup behavior before adding anything. | Medium-low / small-medium | [colored popups](https://github.com/aaronjeter/CrystalShireEngine/commit/aa5363baf) |
| P21 | Field tools: Hatchet, Pickaxe, Flippers, Lantern, Bird Whistle | **Optional adapt.** Provide Cut/Rock Smash/Surf/Flash/Fly-style access through tools. Crimson already supports HM field actions without occupying move slots and Fly from the map; this would change party-compatibility/badge requirements, not fix missing HM relief. | Low unless a design goal / medium-large | [tools](https://github.com/aaronjeter/CrystalShireEngine/commit/dd8744412), [Flippers](https://github.com/aaronjeter/CrystalShireEngine/commit/25d972e60) |
| P22 | Freely overwrite HM moves | **Audit/adapt.** Prevents a learned HM from trapping a moveslot. Check against Crimson's existing move-deletion behavior and field-HM rules. | Medium-low / small | [HM overwriting](https://github.com/aaronjeter/CrystalShireEngine/commit/e3a4e3362) |
| P23 | Earlier/multiple Move Reminder locations | **Adapt.** Crimson already has ancestor-aware reminder/tutors, but Blackthorn access is late. Borrow the distributed-service idea, not CSE's reminder logic. | High / small-medium | [additional reminder](https://github.com/aaronjeter/CrystalShireEngine/commit/a76e3e297) |
| P24 | More available evolution items and utility tutors | **Adapt content.** Reduce travel/grinding where Crimson's item catalog reveals a genuine availability gap. No need to replace existing offline evolution routes. | Medium / small-medium | [stone shop](https://github.com/aaronjeter/CrystalShireEngine/commit/a51a96b48), [tutor availability](https://github.com/aaronjeter/CrystalShireEngine/commit/6111de4a8) |
| P25 | Revised blackout money loss | **Optional adapt.** Gen 3 branch computes loss from progression and level. Potentially less punishing than a flat fraction, but changes the economy. | Low / medium | [money loss](https://github.com/aaronjeter/CrystalShireEngine/commit/d64794d10) |
| P26 | Remove traded-mon disobedience | **Optional adapt.** Makes gifted/traded teams easier to use. Coordinate with Hard caps; it is a rules decision. | Low / small-medium | [obedience change](https://github.com/aaronjeter/CrystalShireEngine/commit/dd0e59691) |
| P27 | Less random phone interruption | **Optional adapt.** LevelScaling removes ordinary random callers. For Crimson, a filter is likely more compatible than deleting rematch/reward/story phone behavior. | Medium-low / medium-large | [phone removal](https://github.com/aaronjeter/CrystalShireEngine/commit/6bd5738ee) |

## 2. Larger battle and progression systems

| ID | Candidate | Benefit and limits | Priority / effort | Source |
| --- | --- | --- | --- | --- |
| B01 | Two-versus-two battles | **Adapt.** Enables paired trainers, foe selection and new encounter design. The inspected version does not support ally targeting or ally damage from spread moves. The branch has four battler slots, action/target handling, replacement logic, a doubles screen, animations and AI. This is a substantial architecture project around Crimson's custom effects, abilities, RNG and tests. Recent phase/fix commits are evidence of active development, not proof of production readiness. | High if desired / very large | [doubles](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/engine/battle/doubles.asm), [doubles AI](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/engine/battle/ai/doubles_ai.asm) |
| B02 | Explicit battler-state save/swap helpers | **Adapt with B01.** Isolating per-battler data can make doubles and effect ownership easier to reason about. Do not refactor a stable singles engine solely for similarity. | Conditional / very large | [pre-doubles refactor](https://github.com/aaronjeter/CrystalShireEngine/commit/1abe7bd61) |
| B03 | Badge/story-based wild level scaling | **Adapt.** Keeps optional routes relevant. Branch source adds a world-derived level value; cap and variance/clamping must be checked at all encounter sources. Crimson's fixed balance and custom areas need a dedicated curve. | Medium / large | [wild scaling](https://github.com/aaronjeter/CrystalShireEngine/commit/176797382), [world progression script](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/engine/events/std_scripts.asm) |
| B04 | Trainer scaling and centralized world progression | **Adapt.** Reduces duplicated progression checks and supports flexible gym order. Preserve bespoke bosses and Crimson's 16-badge/League logic; avoid global scaling erasing intentional difficulty spikes. | Medium / large | [centralization](https://github.com/aaronjeter/CrystalShireEngine/commit/c543cab35) |
| B05 | Optional region/origin starts | **Adapt.** Johto/Kanto/Hoenn-style starts offer replay value. Requires complete start-specific story gates, transport, starter availability, shops and tutorial behavior. | Low until planned / very large | [region menu](https://github.com/aaronjeter/CrystalShireEngine/commit/d2b64b2cf), [Hoenn start](https://github.com/aaronjeter/CrystalShireEngine/commit/ba0d348d1) |
| B06 | Random trainer teams from curated pools | **Adapt.** Useful for repeatable challenges and testing. Constrain move legality, roles, species duplication and difficulty rather than sampling blindly. | Medium / large | [party pools](https://github.com/aaronjeter/CrystalShireEngine/commit/d34b6b724) |
| B07 | Cup/tournament battle types | **Adapt.** Little Cup, themed pools, qualifiers and a World Cup-style structure can extend Crimson's postgame. Reference concepts and scripts; do not import the donor's progression assumptions. | Medium / large-very large | [Cup battle type](https://github.com/aaronjeter/CrystalShireEngine/commit/e06b79fae), [qualifiers](https://github.com/aaronjeter/CrystalShireEngine/commit/8dd777668) |
| B08 | New trial/gauntlet formats | **Adapt content.** Treetop Trial/Ashen Gauntlet drafts suggest themed endurance challenges and reward loops. Historical drafts require checking before reuse. | Medium-low / large | [trial drafts](https://github.com/aaronjeter/CrystalShireEngine/commit/687ea11bc) |
| B09 | Mega species and transformation artwork | **Adapt content.** There are ordinary and custom Mega designs. In the checked branch, Venusaur/Charizard/etc. use `EVOLVE_ITEM` entries with regional Mega stones: this is stone evolution data, not a verified temporary once-per-battle Mega implementation. | Optional / very large for modern Megas | [evolution data](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/data/pokemon/evos_attacks_kanto.asm), [Mega stats](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling/data/pokemon/base_stats/mega) |
| B10 | Modern bounded EVs | **Optional adapt.** Core replaces five 16-bit stat-experience values with six EV stats; it defines 252 per stat and 510 total. Crimson intentionally uses stat experience, including trainer bonuses and editor support. A migration affects balance, saves, breeding, storage, summaries, link data and the editor. Branch history also contains EV-limit experiments; verify final behavior. | Low unless chosen / very large | [EV conversion](https://github.com/aaronjeter/CrystalShireEngine/commit/5e2da5d9a) |
| B11 | Six individual 0–31 IVs | **Optional adapt.** More modern stat granularity. Crimson's perfect-DV acquisition already removes much of the associated grind; migrate only for a clear design reason. | Low / very large | [Gen 3 mon structure](https://github.com/aaronjeter/CrystalShireEngine/blob/gen3/constants/pokemon_data_constants.asm) |
| B12 | Personality data and independent shiny/gender/form fields | **Adapt when expanding mon data.** Removes dependencies between unrelated traits and supports additional forms/evolution behavior. Requires a versioned save and editor migration. | Conditional / very large | [Gen 3 mon structure](https://github.com/aaronjeter/CrystalShireEngine/blob/gen3/constants/pokemon_data_constants.asm) |
| B13 | Nature system and summary indicators | **Optional adapt.** Adds stat customization and readable up/down indicators. Do not confuse the presence of nature display/data with validation of the whole stat pipeline. Would require a full Crimson rules and migration design. | Low / very large | [nature work](https://github.com/aaronjeter/CrystalShireEngine/commit/08352bef8), [nature display](https://github.com/aaronjeter/CrystalShireEngine/blob/gen3/engine/pokemon/natures.asm) |
| B14 | Modern breeding/IV inheritance | **Optional adapt with B11–B13.** Useful only after choosing a new mon-data model. Crimson already has fast production/hatching and either-parent egg moves; preserve those improvements. | Conditional / very large | [breeding rework](https://github.com/aaronjeter/CrystalShireEngine/commit/b62dde755) |
| B15 | Personality-dependent evolution | **Adapt if needed.** Adds Wurmple-like branching logic without inventing unrelated item routes. Crimson can alternatively keep deterministic custom methods. | Low-medium / medium-large | [personality evolution](https://github.com/aaronjeter/CrystalShireEngine/commit/4d689747c) |
| B16 | Nincada spawning Shedinja on evolution | **Adapt if roster expands.** Includes one-HP Shedinja handling. Needs party-space, Ball consumption, storage, nickname and copied-data checks. | Conditional / medium-large | [Shedinja evolution](https://github.com/aaronjeter/CrystalShireEngine/commit/ccafc12b9) |
| B17 | Erratic and Fluctuating growth rates | **Adapt.** Allows accurate growth curves for more species. Core's initial attempt was reverted; use the Gen 3 implementation as the reference. | Medium if adding affected species / medium | [Gen 3 growth rates](https://github.com/aaronjeter/CrystalShireEngine/commit/9ac31cb2a) |
| B18 | Modern capture Balls | **Adapt.** Net, Dive, Nest, Repeat and Timer Ball implementations provide collection tools. Audit environment, seen/caught flags, turn count, catch-multiplier overflow and new item availability. Compare Level/Fast multiplier changes with Crimson's intended rules. | Medium / medium-large | [Net](https://github.com/aaronjeter/CrystalShireEngine/commit/b4aac1a19), [Dive](https://github.com/aaronjeter/CrystalShireEngine/commit/8397a9d65), [Nest](https://github.com/aaronjeter/CrystalShireEngine/commit/49ce106a0), [Repeat](https://github.com/aaronjeter/CrystalShireEngine/commit/ea92d0c5b), [Timer](https://github.com/aaronjeter/CrystalShireEngine/commit/9713e579a) |
| B19 | Ability effects outside battle | **Audit/adapt.** Gen 3 wild encounter code includes ability-based encounter rate, level suppression/selection and type attraction. Check Crimson's existing field ability behavior individually; do not replace its battle ability engine. | Medium / medium-large | [field abilities](https://github.com/aaronjeter/CrystalShireEngine/commit/d81909595) |
| B20 | AI ability-awareness and modern status checks | **Audit.** Useful comparison cases for type immunity, ability immunity, weather, priority and double-target selection. Crimson already has a larger custom AI and ability suite; source tests and missed cases are more valuable than wholesale replacement. | High audit / medium | [ability scoring layer](https://github.com/aaronjeter/CrystalShireEngine/commit/c1309a1ad), [status scoring](https://github.com/aaronjeter/CrystalShireEngine/commit/f655d8405) |
| B21 | Additional move effects and animations | **Adapt selectively.** Gen 3 and game branches contain many attacks plus reusable radial effects, subanimations, HUD clearing, palette changes and animation deduplication. Crimson already has extensive modern animation work; select missing effects/art rather than replacing working scripts. | Medium / varies | [Gen 3 animations](https://github.com/aaronjeter/CrystalShireEngine/tree/gen3/engine/battle_anims), [experimental effects](https://github.com/aaronjeter/CrystalShireEngine/tree/broke-effects/engine/battle) |
| B22 | Modern battle-rule comparison cases | **Audit.** Type-based status immunities, halved paralysis Speed, altered sleep/confusion, weather defenses, Hidden Power information, no badge boosts and hard rematches appear in branch history. Several are already present or deliberately different in Crimson. Use them to check intended behavior, not silently change rules. | Medium / varies | [LevelScaling history](https://github.com/aaronjeter/CrystalShireEngine/commits/LevelScaling) |

## 3. Graphics, maps and engine capacity

| ID | Candidate | Benefit and Crimson-specific assessment | Source |
| --- | --- | --- | --- |
| E01 | Dynamic overworld OBJ palette allocation | **Adapt, substantial.** Assigns active NPC/object colors as needed, supporting a wider authored palette catalog while retaining the hardware's simultaneous palette limits. Crimson currently uses fixed NPC palette assignments. Important for unique trainers and overworld species; coordinate with weather, portraits, map banners and menus. | [dynamic palettes](https://github.com/aaronjeter/CrystalShireEngine/blob/core/engine/gfx/dynamic_pals.asm), [palette loading](https://github.com/aaronjeter/CrystalShireEngine/blob/core/engine/gfx/sprite_palettes.asm) |
| E02 | Dynamic sprite reload | **Adapt.** More focused sprite refresh after appearance/variable-sprite changes. Useful for followers, contests and scripted transformations. Crimson has custom graphics reservation and sprite recovery behavior that must survive. | [reload change](https://github.com/aaronjeter/CrystalShireEngine/commit/9464849d5) |
| E03 | Additional tileset graphics capacity | **Adapt if needed.** Core history's later “384 tilesets” commit actually loads additional groups of tiles within a tileset; it should not be advertised as 384 distinct map tileset definitions. Crimson already loads 255 graphics tiles, so the further expansion is the potential gain. VRAM is already shared with weather/portraits/signs. | [capacity implementation](https://github.com/aaronjeter/CrystalShireEngine/commit/e353628c4) |
| E04 | Per-block tile palette, bank and flip attributes | **Keep/audit.** Crimson already has `wTilesetAttributesBank`, `LoadMetatileAttributes` and surrounding attribute buffers. Use donor fixes only for a demonstrated defect. Supports different colors/flip states without duplicate tile artwork. | [attribute system](https://github.com/aaronjeter/CrystalShireEngine/commit/165e4aba1) |
| E05 | Deferred graphics uploads at map connections | **Audit/adapt.** Reduces connection pauses and avoids unnecessary reloads when the tileset is unchanged. Crimson already has its own staged decompression/connection logic; benchmark before adopting. | [deferred loading](https://github.com/aaronjeter/CrystalShireEngine/commit/629532955), [tileset change test](https://github.com/aaronjeter/CrystalShireEngine/commit/1ea6f18c) |
| E06 | Evening as a distinct time period | **Adapt.** Provides dusk palettes and explicit evening scheduling. CSE uses 5–8 PM evening and later night. Crimson currently changes to night at 6 PM. Audit encounters, trainers, phone calls, evolution times and dark-map behavior before selecting boundaries. | [evening system](https://github.com/aaronjeter/CrystalShireEngine/commit/84aa37005) |
| E07 | Weather zones and ashfall | **Adapt.** Regional climates and volcanic ash can distinguish new areas. Crimson already has a substantial weather engine; extend its data/types instead of importing a second particle scheduler. | [weather zones/ash](https://github.com/aaronjeter/CrystalShireEngine/commit/3e78dec8a) |
| E08 | Weather transition and presentation refinements | **Audit.** Random transitions, movement-aware particles, rain splashes, lightning, indoor restrictions and menu/Fly cleanup are useful cases. Crimson already implements many of these; `weather-test` is experimental. | [weather branch](https://github.com/aaronjeter/CrystalShireEngine/tree/weather-test) |
| E09 | Distinct lake/ocean water and wave animations | **Adapt artwork.** Makes shorelines and regions less repetitive. More variation can come from data/art without reworking map logic. | [water animation work](https://github.com/aaronjeter/CrystalShireEngine/commit/bf81ba09a), [lake tiles](https://github.com/aaronjeter/CrystalShireEngine/commit/177aca31d) |
| E10 | Regional/town roof palettes, trees, grass and terrain | **Adapt artwork.** Hoenn, jungle, desert, cave, city and ocean tilesets offer references for stronger area identity. Check asset credits and fit them to Crimson's visual style. | [regional tilesets](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling/gfx/tilesets) |
| E11 | Faster LZ decoder | **Adapt after measurement.** Potential benefit for graphics loads and map/menu transitions. Crimson still has its own older decompression code. Match input format, buffer boundaries, overlap semantics and register behavior. | [decoder optimization](https://github.com/aaronjeter/CrystalShireEngine/commit/6b7cd22e) |
| E12 | Better LZ encoder and explicit command definitions | **Adapt as a matched pipeline.** Could reduce ROM usage. CSE history changes long-count handling and encoding heuristics; measure current assets and validate every recompressed output against the decoder. Smaller files are not guaranteed for every asset. | [compression work](https://github.com/aaronjeter/CrystalShireEngine/commit/df7be87cc), [count changes](https://github.com/aaronjeter/CrystalShireEngine/commit/542aea442) |
| E13 | Faster Multiply/Divide/GetSquareRoot | **Audit/adapt.** Potential speedup in stat, damage and rendering math. Crimson already uses an efficient AddNTimes and custom math paths. Preserve exact integer rounding, carry, width and zero-input contracts. | [math changes](https://github.com/aaronjeter/CrystalShireEngine/commit/79ae3e05), [square root](https://github.com/aaronjeter/CrystalShireEngine/commit/d5c1a879) |
| E14 | Map connection / LoadMapPart / BG upload optimizations | **Audit.** Useful benchmarks and implementation references. Crimson already has substantial VBlank, copy/fill and connection changes. Timing improvements can break LCD-sensitive effects if ported blindly. | [map loading](https://github.com/aaronjeter/CrystalShireEngine/commit/3c1c311d9), [connection optimization](https://github.com/aaronjeter/CrystalShireEngine/commit/141a471a) |
| E15 | Register-preserving farcall family | **Adapt selectively.** CSE supplies stack/pointer/bank calls and preserves argument registers. Crimson already preserves important return values and has `farcall_a`. The CSE code inspected masks ROM bank IDs with `$7f`; Crimson uses banks above `$7f`, so a literal port would be inappropriate. | [farcall code](https://github.com/aaronjeter/CrystalShireEngine/blob/core/home/farcall.asm) |
| E16 | RST calls for common hot helpers | **Optional audit.** Shorter calls to copy/fill/AddNTimes/script-byte helpers can save ROM. Crimson already uses its vector/header space for optimized routines; there may be no worthwhile free vector. | [RST changes](https://github.com/aaronjeter/CrystalShireEngine/commit/4c8ecf474) |
| E17 | Split map headers and attributes into separate sections | **Audit/adapt.** Makes bank placement more flexible as map data grows. Crimson already separates map-related data in its custom layout; adopt only if current packing creates a problem. | [map sections](https://github.com/aaronjeter/CrystalShireEngine/commit/fac22f871) |
| E18 | Bankable trainer tables and animation functions | **Audit/adapt.** Helps large rosters/move libraries fit without fixed-bank assumptions. Preserve pointer widths and far calls, especially sine/cosine helpers. | [trainer structure](https://github.com/aaronjeter/CrystalShireEngine/commit/648c822bd), [animation sections](https://github.com/aaronjeter/CrystalShireEngine/commit/ef5373fec) |
| E19 | Wider animation object/frameset/OAM identifiers | **Keep/audit.** Crimson already has a high-object animation command and many expanded framesets. Compare actual remaining limits before migrating to CSE's full-word format. | [objects](https://github.com/aaronjeter/CrystalShireEngine/commit/381f2daf2), [framesets](https://github.com/aaronjeter/CrystalShireEngine/commit/fcc4f5069) |
| E20 | Indirect/bank-independent animation, bitmask, picture and Dex tables | **Audit.** Removes accidental relationships between species numbering and bank placement. Crimson already supports a large 16-bit roster; check residual limits as it expands. | [Gen 3 table changes](https://github.com/aaronjeter/CrystalShireEngine/commit/37f182f88) |
| E21 | Remove unused mobile code/data | **Optional audit.** Reclaims ROM/WRAM/SRAM if the functionality is intentionally unsupported. Verify no Battle Tower, link, save or script dependency remains. CSE history includes restoring code after such removals, so removal alone is not a safe optimization. | [core history](https://github.com/aaronjeter/CrystalShireEngine/commits/core) |
| E22 | Clear all relevant WRAM banks on startup | **Audit.** Prevents stale state in additional banks. Especially relevant to weather, storage and debug features. Check Crimson's current initialization rather than replacing it. | [WRAM initialization](https://github.com/aaronjeter/CrystalShireEngine/commit/fd1e89212) |
| E23 | Consolidate repeated sine/tree-frame/music-ID special cases | **Audit.** Potential ROM savings and fewer expansion traps. Music-ID assumptions matter as custom tracks grow. | [sine consolidation](https://github.com/aaronjeter/CrystalShireEngine/commit/8728c631d), [tree-frame change](https://github.com/aaronjeter/CrystalShireEngine/commit/2140b70e3), [music IDs](https://github.com/aaronjeter/CrystalShireEngine/commit/265ceb705) |

## 4. Development workflow and content

| ID | Candidate | Why it could benefit Crimson | Source |
| --- | --- | --- | --- |
| D01 | Dictionary text compression | **High-value adapt.** The LevelScaling branch generates a dictionary, emits tokenized text and expands it in the text engine. Could free ROM space for dialogue and new areas. Preserve control codes, font encoding, line wrapping and extraction used by Crimson's docs/tests/editor. Benchmark savings on Crimson's own text. | [compression implementation](https://github.com/aaronjeter/CrystalShireEngine/commit/a08688d64) |
| D02 | `farcheck.py` | **High-value adapt.** Finds suspicious cross-bank calls/pointers and unnecessary farcalls. Extend it for Crimson's macro names, `.sym` bank range and generated assembly; exclude the downloaded audit tree. | [bank checker](https://github.com/aaronjeter/CrystalShireEngine/blob/core/utils/farcheck.py) |
| D03 | `optimize.py` | **Adapt.** Suggests shorter/faster assembly patterns. Use as a review tool and preserve flag-dependent or timing-sensitive sequences. CSE's own history contains overoptimization fixes. | [optimizer](https://github.com/aaronjeter/CrystalShireEngine/blob/core/utils/optimize.py) |
| D04 | `unreferenced.py` | **Adapt.** Helps find dead labels/code/data and recover space. Teach it Crimson's pointer tables, script callbacks and custom macros before deleting anything it flags. | [reference analysis](https://github.com/aaronjeter/CrystalShireEngine/blob/core/utils/unreferenced.py) |
| D05 | Bank-end and free-space reporting | **Adapt.** Identifies bank packing waste/overflow and guides placement of new assets. Integrate with Crimson's existing resource audits rather than duplicate them. | [bank-end support](https://github.com/aaronjeter/CrystalShireEngine/commit/260ba7c7f) |
| D06 | ROM build CI | **High-value adapt.** Crimson's checked workflows cover the editor/data sync; CSE has ROM build CI. Add release/debug builds and selected existing Crimson audits/tests using its supported compiler. CSE's old Actions versions are not the part to copy. | [CSE workflow](https://github.com/aaronjeter/CrystalShireEngine/blob/core/.github/workflows/main.yml) |
| D07 | Build leaves source clean | **Adapt.** CI checks for tracked files unexpectedly changed by a build. Useful for generated tables/docs where reproducibility matters. | [build workflow](https://github.com/aaronjeter/CrystalShireEngine/blob/core/.github/workflows/main.yml) |
| D08 | Modern RGBDS compatibility | **Optional modernization.** CSE core uses 0.9.0; Crimson's documented validated toolchain is 0.5.2. Newer compiler support may improve maintenance, but requires syntax/tooling work and should be separate from gameplay changes. Do not call 0.9.0 the latest compiler. | [compiler update](https://github.com/aaronjeter/CrystalShireEngine/commit/61c9ba5f) |
| D09 | More assembly assertions | **Adapt.** Guard table sizes, structure lengths, animation limits, bank relationships and item/species pointer formats at build time. Particularly useful for future roster additions. | [assertion work](https://github.com/aaronjeter/CrystalShireEngine/commit/4432df05) |
| D10 | Donor emulator test corpus | **Adapt selected cases.** LevelScaling has singles/abilities/doubles/party-swap tests and screenshot support. Crimson already has extensive tests; add missing scenarios to its harness instead of installing a competing one. | [test tools](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling/tools) |
| D11 | Whole-move animation previewing | **Adapt workflow.** Batch animation testing and contact-sheet generation help inspect palette, timing and object-limit errors. Especially valuable when importing more sprites/moves. | [animation testing](https://github.com/aaronjeter/CrystalShireEngine/commit/be2e92a04) |
| D12 | Debug map-edge bounce/test facilities | **Optional adapt.** Easier manual map/event testing. Crimson already builds a debug ROM with a battle tester; borrow only missing facilities. Some earlier CSE debug rooms were subsequently removed. | [edge testing](https://github.com/aaronjeter/CrystalShireEngine/commit/9bb72ad18) |
| D13 | More compact/expressive trainer macros | **Adapt.** Reduces repetitive party definitions and makes level/role/pool data easier to review. Needs updates to Crimson's documentation and balance parsers. | [trainer macros](https://github.com/aaronjeter/CrystalShireEngine/commit/8bff3dff0) |
| D14 | Trainer dialogue callbacks | **Adapt.** `trainerafter` and dialogue-box commands centralize approach and after-battle presentation. Crimson already has portraits; compare scripting ergonomics without replacing the portrait system. | [trainerafter](https://github.com/aaronjeter/CrystalShireEngine/commit/2c81ba5f1) |
| D15 | Gen 3 species asset/data library | **Adapt content.** Additional sprites, backsprites, icons, cries, footprints, Dex entries, stats, evolutions, learnsets, egg moves and TM compatibility provide a starting point for expanding Crimson's roster. Each species needs Crimson-specific balance, ability and encounter choices. | [species data](https://github.com/aaronjeter/CrystalShireEngine/tree/gen3/data/pokemon), [graphics](https://github.com/aaronjeter/CrystalShireEngine/tree/gen3/gfx/pokemon) |
| D16 | Regional forms, beta species and custom species | **Optional content.** Lattice/LevelScaling include alternate starter lines, regional variants, beta designs and four elemental Djinn. Useful art/design references if they fit Crimson's theme; do not presume all are polished or canon-balanced. | [branch species constants](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/constants/pokemon_constants.asm) |
| D17 | Regional maps and additional dungeons | **Optional content.** Hoenn cities/routes, desert/jungle areas, islands/harbors, trials and legendary lairs offer map, tileset and script references. This is a content expansion, not an isolated engine patch. | [branch maps](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling/maps) |
| D18 | Expanded fossil acquisition/revival content | **Adapt.** Fossils in maps/held-item tables, museum content and additional fossil species can make collection more interesting. Compare against Crimson's existing fossil/items catalog. | [fossil distribution](https://github.com/aaronjeter/CrystalShireEngine/commit/d7c1d4fe4) |
| D19 | More trainer classes and artwork | **Adapt assets.** Ranger/Battle Girl/Hoenn leaders and Elite Four sprites can add variety to custom regions and postgame bosses. Match palettes, dimensions and portrait conventions. | [trainer sprites](https://github.com/aaronjeter/CrystalShireEngine/commit/c14f9fb67) |
| D20 | Additional music, title, intro and Hall of Fame assets | **Optional asset audit.** Assess branch-added art/music for fit; do not assume every inherited asset is new or suitable. Timing fixes are separately useful for existing custom intros. | [LevelScaling tree](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling) |
| D21 | New berries, held items and shop/prize distributions | **Optional content.** More tactical rewards and acquisition routes. Existing items may have different names/IDs/effects in Crimson; compare effects rather than constant names alone. | [branch item data](https://github.com/aaronjeter/CrystalShireEngine/tree/LevelScaling/data/items) |
| D22 | Virtual Console patch target | **Conditional.** Useful if a compatible VC distribution target is intended. Does not automatically provide modern emulator/link compatibility. | [VC support](https://github.com/aaronjeter/CrystalShireEngine/commit/a6a576a1a) |

## 5. Custom ability ideas worth assessing individually

These are donor concepts, not automatic recommendations to add more power. Crimson already has analogous or overlapping abilities, and its abilities-off mode must remain respected. Names such as CSE's `IMPOSTOR` versus Crimson's `IMPOSTER` are spelling differences, not missing features. Several below overlap modern abilities already in Crimson. The descriptive source is [LevelScaling's ability descriptions](https://github.com/aaronjeter/CrystalShireEngine/blob/LevelScaling/data/abilities/descriptions.asm); actual numerical behavior needs an engine-level check before adoption.

| Candidate | Donor concept / potential use |
| --- | --- |
| Mystify | Lowers the opposing Special Attack on entry; special counterpart to Intimidate. |
| Snare | Entry Speed reduction; useful for control-oriented species. |
| Daunt | Entry Defense reduction. |
| Enervate | Entry Special Defense reduction. |
| Haste | Raises the holder's Speed on entry. |
| Aim | Raises the holder's accuracy on entry. |
| Focus | Raises critical-hit ratio. Compare with Crimson's existing crit abilities. |
| Veiled | Safeguard on entry; strong team support. |
| Invisible Wall | Reflect on entry; balance duration and repeat entry carefully. |
| Debris | Spikes on entry. This is a major hazard-economy change. |
| Leech | Seed effect on entry; branch history includes soft removal, so do not assume final activation. |
| Waterproof | Water immunity. Compare with existing absorb/immunity abilities. |
| Elemental Fist | Boosts off-type punching coverage; differs conceptually from a universal punch boost. |
| Elemental Fang | Same idea for biting/fang attacks. |
| Elemental Blade | Same idea for slicing attacks. |
| Stability | Stronger same-type attacks. Compare with Adaptability-like existing behavior. |
| Regeneration | Passive per-turn recovery, distinct from switch-out Regenerator. |
| Sunbask | Recovery in sunlight. |
| Sand Body | Recovery in sandstorm. |
| Durable | Reduces super-effective damage; compare with Filter/Solid Rock-like behavior. |
| Frigid | Contact-triggered cold status. The branch's text calls it frostbite; this would need an explicit status-system decision for Crimson. |

## 6. Additional moves to evaluate

A constant-name comparison identified these substantive candidate moves in LevelScaling that do not have matching identifiers in Crimson's move list: **Uproar, Focus Punch, Nature Power, Charge, Arm Thrust, Luster Purge, Mist Ball, Ice Ball, Needle Arm, Blast Burn, Hydro Cannon, Silver Wind, Muddy Water, Frenzy Plant, Shock Wave, Sludge Wave and Shadow Force**. Assess effects, animation, learners and role before adding each; history containing an animation/description does not prove a complete battle effect.

**Pixie Dust, Fae Voice and ShockSlam** are custom move candidates. Their exact intended balance and overlap with Crimson attacks need review.

Do not count `WILLOWISP`, `DRAININGKISS`, `FLASHCANNON`, `FAERIEGLEAM`, `SHADOWSNEAK`, `RAZORSHELL` or `EARTHPOWER` as confirmed missing moves: spelling/rename differences can match Crimson's existing Will-O-Wisp, Draining Kiss, Flash Cannon, Dazzling Gleam, Shadow Sneak, Razor Shell and Earth Power implementations.

The Gen 3 and broke-effects branches provide additional effects/animation reference material beyond that name comparison. The supplemental commit inventory lists their move-level changes, including reversions; inspect final source before selecting a version.

## 7. Improvements Crimson already has

These can still supply edge-case fixes, but they should not be presented as new feature additions.

| Feature | Crimson evidence / assessment |
| --- | --- |
| 16-bit species and move indexes | `engine/16/`, indirect data tables and the expanded roster/move set. |
| 16-bit item handling | Existing item conversion/storage machinery; do not migrate to CSE's save format. |
| Graphical PC, themes, party access and held-item management | `engine/pc/bills_pc_ui.asm` and `storage.asm`; Crimson already provides 25 boxes / 500 slots with custom recovery/migration behavior. |
| PC LCD code in WRAM0 | Explicitly documented and implemented in Crimson's PC UI. |
| 60 FPS overworld and CGB double speed | `home/init.asm`, `home/vblank.asm`, `engine/overworld/events.asm` and adjusted movement timing. |
| Bounded low-HP alarm | Already has a three-cycle limit plus SFX-interference fixes. |
| Kanto trainer-card page and colored badges | `engine/menus/trainer_card.asm`, `engine/gfx/cgb_layouts.asm`; Johto/Kanto palette tables present. |
| Colored thrown Balls and caught-Ball display | `data/battle_anims/ball_colors.asm`, capture metadata and summary palette logic. |
| Smooth fades and sliding map-name signs | Existing custom fade and map-sign systems. |
| 255-tile maps and per-block attributes | Existing tileset and attribute buffers; assess only the later capacity expansion. |
| Copy/fill and VBlank scheduling improvements | `docs/engine-optimizations.md` documents measured routines and integration checks. |
| Modern physical/special categories and detailed move information | Existing custom move and battle information systems. |
| Large ability library, three slots, ability descriptions and reusable changer | Existing battle/summary/item implementation. CSE's smaller system is not a replacement. |
| Reusable TMs, solo evolutions and field HM moveslot relief | Existing item/evolution/field-action systems. |
| Fast breeding/hatching and either-parent egg moves | Existing QoL work is more tailored to Crimson. |
| Reminder and utility tutors | Already present; access location is the improvement opportunity. |
| Difficulty options, caps and custom rematches | Existing custom progression. Borrow cap visibility or specific challenge ideas. |
| In-game clock correction | Relic Clock already exists. A startup shortcut would be an optional second access path. |
| Expanded weather and overworld effects | Existing rain/snow/sand/cherry blossom logic, palette tints, weather abilities and battle integration. |
| Debug ROM and emulator-based regression testing | Existing Makefile targets and extensive `tools/battletest` coverage. |
| Script stack and map-object overflow guards | Current `ScriptCall` checks five entries; `ReadObjectEvents` uses `NUM_OBJECTS - 1` with zero/carry checks. These two historical CSE fixes are already represented. |

## 8. Bug-fix catalogue: how to use it

The generated appendix below enumerates the explicitly labeled vanilla bug/flaw fixes from the CSE development history. **Every entry is an audit opportunity, not a diagnosis of Crimson.** Many have been fixed independently or superseded by Crimson's modern mechanics. Beat Up, ability interactions, stat math, capture and HP animation especially need comparison against Crimson's custom implementation.

Also inspect these CSE-specific regression families when porting related systems:

| Family | Historical fixes / cases to preserve | Example source |
| --- | --- | --- |
| Save and buffer safety | Graphics decompression scratch overflowing into SRAM Mail; storage struct labels; NPC trade structure length; conversion-table saving/GC; Hall of Fame held-item corruption. | [scratch overflow](https://github.com/aaronjeter/CrystalShireEngine/commit/2e0925250), [Hall of Fame](https://github.com/aaronjeter/CrystalShireEngine/commit/1fa536232) |
| Storage operations | Give item with correct bag context, swap last usable party member with a healthy stored one, non-full boxes beyond box 1, Unown form pictures, item/palette restoration. | [item giving](https://github.com/aaronjeter/CrystalShireEngine/commit/0ae2f7b3a), [last-party swap](https://github.com/aaronjeter/CrystalShireEngine/commit/9cae0139a), [box-full logic](https://github.com/aaronjeter/CrystalShireEngine/commit/d415b8740) |
| Inventory correctness | Wrong item withdrawn from PC, pocket reordering corruption, Ether/Elixir PP restoration, Revive healing half HP, Mom's purchases, Kurt item conversion and Zinc naming. | [PC withdrawal](https://github.com/aaronjeter/CrystalShireEngine/commit/24f20a320), [reordering](https://github.com/aaronjeter/CrystalShireEngine/commit/c16543009), [PP restoration](https://github.com/aaronjeter/CrystalShireEngine/commit/4e0e52949) |
| Evolution parsing | Byte versus word evolution parameters, skipping ineligible branches, level-up crashes, learnset scanning, mixed stat/item evolution and larger candidate buffers. | [evolution skips](https://github.com/aaronjeter/CrystalShireEngine/commit/cfd30fdd0), [level evolution](https://github.com/aaronjeter/CrystalShireEngine/commit/aa32563b8), [mixed methods](https://github.com/aaronjeter/CrystalShireEngine/commit/a337f1f04) |
| 16-bit integration | Dex cry selection, tutorial species/items, high move lists, link payloads, trade icon palettes, wild/party/trainer conversion and name/picture indirection. | [Dex cry](https://github.com/aaronjeter/CrystalShireEngine/commit/afa8287a3), [tutorial](https://github.com/aaronjeter/CrystalShireEngine/commit/ccae2765b) |
| Movement | Post-wild-battle unintended turns, jump Y vectors, walk/bonk/step-end timing, connection NPC disappearance, player sprite reload, fishing VRAM bank. | [turn fix](https://github.com/aaronjeter/CrystalShireEngine/commit/05df4b962), [jump vectors](https://github.com/aaronjeter/CrystalShireEngine/commit/c0c9e04cd), [connection NPC](https://github.com/aaronjeter/CrystalShireEngine/commit/956e2841f) |
| LCD / double-speed timing | Battle-slide judder, scanline trickery, sage flicker, script pauses, tileset animation cadence, intro/music synchronization, LCD STAT enablement, safe HDMA interrupt flags. | [battle slide](https://github.com/aaronjeter/CrystalShireEngine/commit/983318950), [script pause](https://github.com/aaronjeter/CrystalShireEngine/commit/2e6d5f214), [HDMA](https://github.com/aaronjeter/CrystalShireEngine/commit/4feeff3cc) |
| Palettes | Pool exhaustion must not loop forever; restore menu/shop/Pokegear/PC palettes; retain Ball colors after captures; use correct legendary icons. | [palette exhaustion](https://github.com/aaronjeter/CrystalShireEngine/commit/1d7f3fd32), [capture color](https://github.com/aaronjeter/CrystalShireEngine/commit/d56b98fb5) |
| Audio/UI | Restore music volume after summary, avoid max-volume summary, wait for confirmation sounds, correct Lucky Number comparisons/display, reset input on menu entry. | [summary volume](https://github.com/aaronjeter/CrystalShireEngine/commit/3ff23d1a7), [Lucky Number](https://github.com/aaronjeter/CrystalShireEngine/commit/6625db7b9) |
| Battle animations | Tackle object limit, endless Ball wobble after optimization, far calls to moved animation helpers, correct Unown forms, HUD/palette restoration. | [Ball wobble](https://github.com/aaronjeter/CrystalShireEngine/commit/2950e1e0e), [Tackle limit](https://github.com/aaronjeter/CrystalShireEngine/commit/119087128) |
| Link appearance/state | Preserve protagonist gender in trade/battle rooms and ensure correct payload/handshake behavior after optimization. Crimson has link tests but the gender behavior still deserves a targeted comparison. | [link gender](https://github.com/aaronjeter/CrystalShireEngine/commit/8a8365876) |
| Ability ownership/state | Trace resetting after switches/KOs, current battler species lookup, entry effect ordering, doubles ally/enemy targeting and switch decisions. | [Trace reset](https://github.com/aaronjeter/CrystalShireEngine/commit/1e54b479d) |
| Followers | Stale follow queues after doors, script hide/show, bridge handling, lead changes and freezing. | [follower fixes](https://github.com/aaronjeter/CrystalShireEngine/commit/2a30657a8) |
| Content graphics | Tohjo Falls blocks, Slowpoke Well/port/Ruins of Alph visuals, missing tops of trainer-card heads and wrong sprite palettes. Compare Crimson's edited maps first. | [Tohjo Falls](https://github.com/aaronjeter/CrystalShireEngine/commit/239083d43) |

## 9. Suggested order for Crimson

1. Small visible improvements: B-running, FAST default text, cap display, Kurt crafting and a properly integrated weather indicator.
2. Development capacity: text compression, adapted farcheck/reference analysis and ROM build CI using the existing test suite.
3. Graphics infrastructure: dynamic palettes/reload, then character colors, more map art and any needed tileset expansion.
4. Separate balance decisions: team EXP, catch EXP, scaling, new Balls and additional attacks/species.
5. Major optional projects: following Pokémon, doubles, region starts and tournament content.
6. Consider IVs/EVs/natures only if changing Crimson's training model is an explicit objective. They have much higher migration cost than the first groups.

Do not merge donor branches wholesale. The follower code explicitly reserves the last object slot and can replace that slot's NPC on a full map. Donor farcall code assumes a smaller bank range than Crimson uses. Donor mon formats differ from Crimson's saved data, storage codec and save editor. Keep these dependencies visible when choosing a port.

The supplemental commit inventory preserves branch-by-branch source history for future implementation work. Some entries are experiments, reversions, renamed constants, inherited refactors or donor-specific content edits; their appearance there is not a recommendation to import them.

## Appendix A. Explicit vanilla fix inventory

Historical CSE patches, all marked **Audit**. Current Crimson behavior must be checked before porting.

| # | Fix or flaw addressed | Source |
| --- | --- | --- |
| 1 | SFX_RUN does not play correctly when a wild Pokémon flees from battle | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/a80875a5894a065349be3aec5879368efcf5bcc1) |
| 2 | Identical sine wave code and data is repeated five times | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/8728c631d7b16054fddbcb599a6352f0f9bccf00) |
| 3 | GetForestTreeFrame works, but it's still bad | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/2140b70e32d143f56c27f9c7ebe3317aac8063f3) |
| 4 | Music IDs $64 and $80 or above have special behavior | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/265ceb705a6b7ecf66ccea80e048be1c3010c23d) |
| 5 | Options menu fails to clear joypad state on initialization | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/8ecb37d8471b98fb50d5490c582cafe64729ec8e) |
| 6 | ReadObjectEvents overflows into wObjectMasks | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/16b7f1773c72f12a6419004931a1040f30a8f48d) |
| 7 | ScriptCall can overflow wScriptStack and crash | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/8d6c1d69c83388d8dc79670d81afe2e704a89192) |
| 8 | Magikarp lengths can be miscalculated | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ffe35cb0cfb420d887848abaf621bd9ab7f60c77) |
| 9 | Magikarp length limits have a unit conversion error | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/87fca6884d66ffaf5f71673fe2b42061d4df06cd) |
| 10 | Magikarp in Lake of Rage are shorter, not longer | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ab4915e0a73a1aa3adc163d597e0ec39f1a47b88) |
| 11 | Daisy's grooming doesn't always increase happiness | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/4c546bb0f1c908b7bff433410307724e023f85b4) |
| 12 | Clair can give TM24 Dragonbreath twice | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/f1d6d77411a3c66643f9f7da69c462274818c304) |
| 13 | A "HOF Master!" title for 200-Time Famers is defined but inaccessible | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/c59f0c26dcbf436c3dd7f43eba40a603d4edcf1b) |
| 14 | Five-digit experience gain is printed incorrectly | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/b2f78e5b6a1cad38cbcf65977ea9aecf22f60929) |
| 15 | Playing Entei's Pokédex cry can distort Raikou's and Suicune's | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/90bab16ce1e4162f9b21230e8d14e6c06e576a7d) |
| 16 | No bump noise if standing on tile $3E | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/3d6eda93ad03202f02ab5467cfea1f3c45b922f2) |
| 17 | Team Rocket battle music is not used for Executives or Scientists | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/960e7d9ef13a5bb316328402a51442138e9cd11e) |
| 18 | Slot machine payout sound effects cut each other off | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/5d6ace24d232f819dbea98597d432e9bb5cde0f9) |
| 19 | Some trainer NPCs have inconsistent overworld sprites | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/e6037d0a923ace1a21b8462b52c9892bfac495f0) |
| 20 | Battle transitions fail to account for the enemy's level | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/205657bfb5f91b7ab421a00f9b9773fc46655b85) |
| 21 | Using a Park Ball in non-Contest battles has a corrupt animation | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/7268b005097503002fa4b5adfa3fd90450275499) |
| 22 | A hatching Unown egg would not show the right letter | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/88ed531c370fe3942161baf4ea1bf22943d26c50) |
| 23 | The Ruins of Alph research center's roof color at night looks wrong | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/3824b30d1c1c461939b882425f14bf98adfedfea) |
| 24 | Two tiles in the port tileset are drawn incorrectly | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/9f2329e86b5fad8deb5e29065f0734db74d7729d) |
| 25 | In-battle “…” ellipsis is too high | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/7a5c34ceda4c671cda441f0b5b57bbf392e4a41d) |
| 26 | Pokémon deposited in the Day-Care might lose experience | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/eab8dc064c8b36b5bb540262ff87631007e49626) |
| 27 | You can fish on top of NPCs | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/167c098a31bb2a049b927f4ce1d04ae3674b6280) |
| 28 | Swimming NPCs aren't limited by their movement radius | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/88ee8b652ad8972228d702f7d0a3a0941f678352) |
| 29 | Surfing directly across a map connection does not load the new map | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/4d8fb7aaf2722e0b53498830718e7f78bfe42362) |
| 30 | LoadMetatiles wraps around past 128 blocks | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/5ccb95b703842e3fa11d12e1484a52c2be7aff2d) |
| 31 | Credits sequence changes move selection menu behavior | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ab6b0cec7b3d32a44a597007d850588c942260c9) |
| 32 | HELD_CATCH_CHANCE has no effect | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/1ef10656de54a18adbfcca7f56cd1cc78be7c753) |
| 33 | RIVAL2 has lower DVs than RIVAL1 | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/c54e1fd2c0c74da1060afea1cd8e3a9ce146f741) |
| 34 | Wild Pokémon can always Teleport regardless of level difference | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ed3707e1d656c672b3df6bdcb29e43f73bb21252) |
| 35 | AI might use its base reward value as an item | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/0bde60378a3c98c39249d346cd263ed9ae004a45) |
| 36 | AI use of Full Heal does not cure confusion status | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/31219792ef01aaaad40cd9d38b4d51cb680058be) |
| 37 | AI use of Full Heal or Full Restore does not cure Nightmare status | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/94df9bd289b92ad2b464d3736ad6b8d39ee1fb0d) |
| 38 | AI makes a false assumption about CheckTypeMatchup | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/e3945d5318aafa56ed1d29519dd8f14c64cc5d89) |
| 39 | AI does not discourage Future Sight when it's already been used | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/6271ee53f9a426fec961c89311aaf2867d6814b5) |
| 40 | "Smart" AI does not encourage Solar Beam, Flame Wheel, or Moonlight during Sunny Day | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/6769bb1add1b59dd15216c85e2c57018e04397f7) |
| 41 | "Smart" AI discourages Conversion2 after the first turn | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/1b65c3acf8b8a74b8b5218efd0cfd5875ebbe3b6) |
| 42 | "Smart" AI encourages Mean Look if its own Pokémon is badly poisoned | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/8352406d9d1df22f7dfe47eecc3d6cbab264e827) |
| 43 | Glacier Badge may not boost Special Defense depending on the value of Special Attack | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/61c611bf98b80da02c901aa958a537cf682f6300) |
| 44 | PRZ and BRN stat reductions don't apply to switched Pokémon | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/95ec09a05de8fa5ac9d731d80c0844e769bfd8b6) |
| 45 | Love Ball boosts catch rate for the wrong gender | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/80df8b3f5c760984b500c4cb726f162dc5fc685b) |
| 46 | BRN/PSN/PAR do not affect catch rate | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/0d37c9406fda2e0d0a1eeebc613d32e6f04baec9) |
| 47 | The Dude's catching tutorial may crash if his Poké Ball can't be used | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/d8b69fbf0ce60530c678daf79fc27dee98ec8db6) |
| 48 | Experience underflow for level 1 Pokémon with Medium-Slow growth rate | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/18ada5a0569bf7fb6921e85fb8ba3807b178f7a2) |
| 49 | A Transformed Pokémon can use Sketch and learn otherwise unobtainable moves | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/a36e88e366abc94dbd0b334dd0a52e98a1496a3b) |
| 50 | HP bar animation off-by-one error for low HP | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/40efa4f04f9d21b90d38314451900db9ead69b9c) |
| 51 | HP bar animation is slow for high HP | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ef23cd5acacda2676fed209956a670286b233366) |
| 52 | Moves that do damage and increase your stats do not increase stats after a KO | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/62857de57d079a4968874f3f115b9ea538dfca75) |
| 53 | Switching out or switching against a Pokémon with max HP below 4 freezes the game | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/e4ff941d7bd64522bba4037a8ebb3004170b2f12) |
| 54 | Dragon Scale, not Dragon Fang, boosts Dragon-type moves | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/c9ae7766902c66ccdad10fe6ac4cc00aa9ce0f58) |
| 55 | Return and Frustration deal no damage when the user's happiness is low or high, respectively | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/1e7f06531f2be9c1ee8609356db40461d08be441) |
| 56 | Present damage is incorrect in link battles | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/dbde76b49935f9a503c9e760e3530f31a8b8a797) |
| 57 | Beat Up may trigger King's Rock even if it failed | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/2b8c2d1060e656ac449d63b18e2f1a870c974ae8) |
| 58 | Beat Up may fail to raise Substitute | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/523909c739a4b17110a134454dd9ec9d6200f0ae) |
| 59 | Beat Up works incorrectly with only one Pokémon in the party | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/be67fbb842122cd6c889f7579217be2f3f2b9c27) |
| 60 | Beat Up can desynchronize link battles | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/9e4f84e28fdc17ef12bf490b4169736b79a31005) |
| 61 | Lock-On and Mind Reader don't always bypass Fly and Dig | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/3ba0c859f57b8aa3f817c198a731b280b728ed53) |
| 62 | A Pokemon that fainted from Pursuit will have its old status condition when revived | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/232cc43931a0411102e3ad9c12ae72698d049292) |
| 63 | A Disabled by PP Up-enhanced move may not trigger Struggle | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/8b1c4429448b7441335d839fe2c0a02468b880ad) |
| 64 | Counter and Mirror Coat still work if the opponent uses an item | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/4c4fe57ef5a9d0db58c12874f010195ea058562c) |
| 65 | Moves that lower Defense can do so after breaking Substitute | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/ab57225df66c9f49078da7bfeb6a084f6f29c637) |
| 66 | Confusion damage is affected by type-boosting items and Explosion/Self-Destruct doubling | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/37251ba807a5321c81c210d95d2f16562892932a) |
| 67 | Berserk Gene's confusion lasts for 256 turns or the previous Pokemon's confusion count | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/adc23e73576b11e731dbfa56a8e2b867bf91e682) |
| 68 | Belly Drum sharply boosts Attack even with under 50% HP | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/26fa7ef2c62e071bb6f961915011f418960a38dc) |
| 69 | Moves with a 100% secondary effect chance will not trigger it in 1/256 uses | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/104ceb9596c9dceb7794dc977e16100b279dbf0b) |
| 70 | Reflect and Light Screen can make (Special) Defense wrap around 1024 | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/5a150a6c0efb3f70ac1ad9901e7aae3c695f921e) |
| 71 | Metal Powder can increase damage taken with boosted (Special) Defense | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/d260b366d38c537397fa49e6e236d40b27259070) |
| 72 | Thick Club and Light Ball can make (Special) Attack wrap around above 1024 | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/4266c4f81b4a84b2b085fda0e74d358ca3c01da5) |
| 73 | Perish Song and Spikes can leave a Pokemon with 0 HP and not faint | [patch](https://github.com/aaronjeter/CrystalShireEngine/commit/afaacb30653d70c87a718efda09f4323346c1e24) |

## Appendix B. Full development history

See [the supplemental commit inventory](crystalshire-engine-commit-inventory-2026-10-25.md) for the core development sequence and all feature-branch commits absent from core.


## Follow-up: weather indicator and doubles readiness

Closer source review of LevelScaling at the revision above changes the doubles assessment from a general feature opportunity to an explicitly incomplete implementation. This review did not run the donor ROM or test suite.

- Weather icon: straightforward drawing path with rain, sun, sandstorm and Hail, plus separate singles/doubles placement. Called when the move-selection information box is drawn; it is not a continuously visible all-screen weather HUD. No obvious defect was established in this source review. Crimson-specific suppression, tile/OAM use and cleanup still need runtime checks.
- Doubles: initial phases were added October 22–24, 2026, with AI-switch fixes on October 24. It has meaningful implementation and automated cases, but no independent passing results were established here.
- Confirmed limits in `DoublesSpreadSetup` / `DoublesLoadTarget`: spread moves do not hit allies; ally selection is unsupported; called moves such as Metronome hit only the current target rather than gaining spread targeting.
- Front-picture animation has a tile-budget check and skips animations that do not fit. The phase-4 commit explicitly documents that some Pokémon entry animations will not play.
- The phase-5 commit says move animation targeting still needs manual review. Source remapping is useful, but does not establish that every move looks right.
- The main doubles test runner starts battles with `SCENE_OFF` and generally disables rendering. Separate animation-sheet tooling exists, but functional cases alone do not establish visual correctness.

Recommendation: weather indicator is a reasonable small port candidate; doubles should be treated as an experimental foundation requiring completion, visual review and broad Crimson-specific regression coverage.
