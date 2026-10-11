# Crimson Crystal: full Pokémon balance review

**Reviewed October 9–10, 2026. Recommendations only; game data has not been changed.**

The current Enhanced roster is already substantially stronger and more varied than the main-game originals. I recommend a selective first pass: normalize Mew's exceptional stats, reduce a few combinations that deny counterplay, delay two unusually strong early setup/sleep tools, and make a handful of smaller role or timing improvements. Most Pokémon should retain their current design. Raising every weak-looking stat would undo the distinctions the existing buffs have created.

The accompanying searchable report contains a record for **every one of the 495 species constants**: 486 non-clone records and nine starter clones. It includes actual runtime typings, all six stats, Original-mode comparisons, the three ability slots, exact level-up moves, numbered TM/HM compatibility, elemental tutors, egg-tutor moves, utility tutors, retained pre-evolution moves, type matchups, evolution requirements, mapped wild encounters, fixed trainer appearances, and Tower builds where present. All 236 non-clone terminal species have individually written design assessments; notable evolving species also have individual assessments. The remaining intermediate stages receive source-based progression assessments, rather than being incorrectly judged against final-evolution BST targets.

## What the recommendations mean

- **Keep:** retain the current design. This is a positive recommendation, not an unreviewed entry.
- **Watch:** the combination warrants focused playtesting; do not apply the suggested fallback nerf before that evidence exists.
- **Nerf / nerf timing / nerf movepool / nerf ability:** a concrete first-pass change I favor, with the current value and proposed change in the ledger.
- **Buff / buff timing / buff role:** a small improvement candidate, mostly second-pass experiments rather than prerequisites for releasing the game.
- **Reassign ability:** improve a poorly aligned slot while preserving existing viable builds. These are lower-priority design choices, not bug fixes.

Priority 1 is the first balance pass or the first test to run. Priority 2 is a second pass after that result. Priority 3 means maintain the current design and observe ordinary play. A priority-1 Watch remains a request for evidence, not an instruction to apply its fallback.

## Changes I would make first

| Target | Current combination | Recommended change | Preserve |
|---|---|---|---|
| Mew | Six base stats of 120, 720 BST, unusually broad setup/coverage | Restore all six to 100, 600 BST | Versatility, movepool and ability choices |
| Mimikyu | Attack 100, zero-HP-cost Disguise, Swords Dance and priority | Attack 100 → 90 | Existing shield rule for the first comparison |
| Jumpluff | 110 Speed, Spore, Encore, Leech Seed and Substitute | Remove Spore; retain Sleep Powder | Fast Grass/Flying support and existing stats |
| Venomoth family | Sleep, Quiver Dance, Tinted Lens and Baton Pass | Remove Baton Pass from Venonat and Venomoth | Independent setup sweeper and recovery |
| Scolipede | Speed Boost, Swords Dance, Substitute and Baton Pass | Remove Baton Pass | Independent attacker and hazard roles |
| Espathra | Speed Boost, Calm Mind, Roost and guaranteed two-stage Sp. Def drops from Lumina Crash | Hidden Speed Boost → Forewarn | Signature attack and current stats |
| Talonflame line | Gale Wings gives Flying priority at any HP | Apply the bonus only at full HP, across holders | 126-Speed final evolution and full-HP opening pressure |
| Squirtle line | Shell Smash at 27 on Squirtle and 35 on Wartortle/Blastoise | Shell Smash → level 50 on all three stages, mirrored to clones | Stats, Water/Steel Blastoise, Drizzle and Mega Launcher alternatives |
| Shroomish line | Spore at level 19 on both Shroomish and Breloom | Spore → level 40 on both | Late-game sleep identity and both useful Breloom builds |

These are design judgments from source inspection. They are not measured win-rate conclusions. The exact numerical cutoffs—especially level 40/50 and Mimikyu's ten-point reduction—are starting values to test, not mathematically proven optima.

**Mew has an important exception:** the source contains a reserved level-100 Mew as the seventh opponent in the Tower's highest room, with maximum stat experience and an explicit Softboiled set. The 720-BST design can therefore be intentional superboss tuning. I still favor 600 BST for the shared player species; preserve an intentionally difficult superboss through that encounter's own tuning if needed. If the design goal is explicitly to make obtainable Mew a 720-BST postgame reward, keeping it exceptional is defensible. Its dedicated Tower set is not evidence that the player can learn Softboiled: that move is outside Mew's extracted player pool.

The Gale Wings recommendation deliberately changes an existing custom XY-style rule. If unconditional priority is a central design preference, keep the rule and use matchup/format tuning instead; do not describe the current behavior as an implementation bug.

## Smaller buffs and adjustments

| Target | Suggested second-pass experiment | Why this is narrow |
|---|---|---|
| Wigglytuff | Defense 55 → 65, BST 485 → 495 | Improves physical resilience without increasing Wish size, Speed or special damage |
| Alolan Dugtrio | HP 50 → 60, BST 440 → 450 | Slightly less fragile without adding trapping, Attack or Speed |
| Delibird | Ice Beam level 36 → 28 | Improves midgame reliability; preserves late-game damage ceiling |
| Bastiodon | Body Press level 44 → 34 | Makes its defensive offense function earlier; no bulk or recovery buff |
| Grumpig | Add Slack Off at level 40 | Gives support longevity instead of raw stats; test Prankster recovery carefully |
| Walrein | Add Slack Off at level 45 | Distinguishes the tank from weather-only healing builds; test hail/Drum attrition separately |
| Hisuian Electrode | Add Synthesis at level 35 | Weather-sensitive Grass recovery differentiates it from regular Electrode's Recover |
| Raitora and Gorotora | Add Volt Switch at level 30 | Creates a bulky Electric pivot role without inflating the custom tiger's already high HP |
| Bloodmoon Ursaring | Guts → Competitive in slot 1 | Aligns the slot with its 130 Sp. Atk rather than 75 Attack |
| Bloodmoon Ursaluna | Guts → Bulletproof in slot 1 | Adds a distinct defensive option without enhancing the already powerful Mind's Eye set |
| Girafarig | Contrary → Early Bird in slot 2 | Its listed pool lacks the usual strong self-dropping attacks; retain inverse-Curse only if that niche is intentional |
| Sneasler | Dire Claw status chance 50 → 30 | Reduces random disabling pressure while preserving speed and signature damage |

Grumpig and Walrein's recovery additions deserve particular caution: reliable healing is a much larger practical buff than a small BST increase. Test the proposed move as a replacement in a four-move set, and do not simultaneously raise bulk. Putting the move only behind the egg tutor changes campaign access rather than reducing the eventual competitive ceiling, because evolved Pokémon can use that tutor directly.

## Interactions that need testing before another nerf

**Kingambit:** 135 Attack, 120 Defense, Swords Dance and Sucker Punch with a snapshotted Supreme Overlord bonus can decide endgames. Test 0–5 fallen allies, switching/re-entry and priority blockers. Sharpness is an alternative; never multiply it into the Supreme Overlord set. A cap of three fallen allies, 1.3×, is a fallback if the existing maximum 1.5× proves excessive.

**Annihilape:** test Bulk Up, Drain Punch and persistent Rage Fist hit history. This engine already caps Rage Fist at **250 power**, so reducing a supposed 350-power move to 250 would not change anything. A Speed reduction 95 → 85 is a possible next intervention after tests, not part of the initial ledger.

**Kangaskhan:** Parental Bond already uses a **quarter-strength second hit**. Check duplicated secondary effects, drain, Substitute breaking and priority rather than proposing an already-implemented damage reduction. If the remaining interaction package is too strong, hidden Tough Claws is a replacement option.

**Cloyster, Omastar and Carracosta:** compare actual Shell Smash sets against special attackers and priority after defensive drops. White Herb is absent, so the classic drawback-removal set cannot be assumed. Test Skill Link and Loaded Dice with the actual hit/accuracy routines. Do not remove high Defense simply because one offensive setup set wins a battle.

**Flareon, Azumarill, Ursaluna and Mawile:** printed BST or Attack is insufficient. Flareon already has 110 HP, 130 Attack and 95 Speed; Guts plus an orb and Facade is substantial. Huge Power doubles physical damage in this engine, while low printed Attack remains intentional on Azumarill/Mawile. Evaluate recoil, status chip, obtainable Berries and the actual four attacks before giving further offense.

**Vikavolt, Salamence, Ceruledge and Hydrapple:** Speed Boost artillery, Aerilate Dragon Dance, Sharpness Bitter Blade healing and Regenerator/Nasty Plot or Sheer Force special offense are high-ceiling redesigns. Each has distinct costs. Test the actual ability-specific set first; the species records give targeted fallback changes rather than recommending every damage ability be removed.

**Bulky cores:** Slowbro/Slowking forms, Gliscor, Starmie, Suicune, Toxapex, Clefable, Umbreon, Chansey and Porygon2 should be measured for battle length, safe reset frequency and susceptibility to disruption. Most have viable offense/utility tradeoffs already. A difficult-to-break core is often a team, move-PP, AI or format issue; adding universal coverage or cutting every wall's stats is a poor substitute for testing.

## Mechanics that materially change this review

1. **Runtime type overrides are authoritative.** Sunflora is Grass/Fire in Enhanced mode although its base-stat file says Grass/Grass. The same principle applies to the redesigned birds, starters, Ghost/Fairy line, Rapidash form and others. The report resolves the engine tables, not filenames or canonical recollection. The type chart also retains **Dragon resisted by Steel**; do not import the modern chart wholesale.
2. **Abilities are alternatives and are readily selectable.** The Ability Cap key item cycles normal and hidden slots, skipping empty slots. Elm gives it after the Mystery Egg handoff when abilities are enabled. Hidden Drought, Speed Boost, Adaptability or regeneration cannot be excused as inaccessible rare rolls. A zero slot falls back to slot one; it is not a no-ability handicap or a demand for another premium ability.
3. **Original/Enhanced type and stat selections are independent, and abilities can be disabled.** Main recommendations target Enhanced types + Enhanced stats + abilities enabled. Original-stat comparisons are per species in the report. Never assume switching Original stats also changes types, learns old moves or turns abilities off. Stat changes to official BaseData should preserve the separate Original stat table. Learnset and ability-slot changes are shared unless the implementation adds rule-specific behavior.
4. **The physical/special split is per move.** Cut is a physical Bug move here, Razor Wind is special Flying, and several custom moves have dynamic behavior. The report lists source categories rather than applying Gen 2 type-based categories. Hidden Power resolves to 70 power with configurable type and a category chosen from current Attack versus Sp. Atk; its placeholder table value is not its real power. Before tuning, the default is Dark.
5. **Weather lasts five turns, eight with the matching rock.** Hail is hail, with its actual chip/recovery/Blizzard behavior; it does not automatically confer modern snow's Ice Defense boost. Weather setters contribute to an entire team. Mega Sol treats the user's moves as if in sun without changing team weather; it is not Drought plus Chlorophyll, and it is suppressed by Gas.
6. **Several abilities have custom or older behavior.** Flash Fire raises the higher attacking stat rather than simply applying the usual Fire-only boost. Filter/Solid Rock apply 0.75× to ordinary super-effective damage and 0.5× to quadruple-effective damage. Disguise blocks the first direct hit without the later-generation HP cost. Gale Wings is unconditional today. Those rules affect several species and should be treated as deliberate design choices.
7. **Status differs from both original Crystal and some modern assumptions.** Sleep lasts 1–3 turns. Confusion retains a 50% self-hit roll, and paralysis has a 25% immobilization chance while halving Speed. Freeze is replaced by frostbite, which halves Sp. Atk and deals residual damage without preventing action. Critical damage is 1.5×; Merciless and Sniper need that actual multiplier and critical stat-stage behavior considered.
8. **Named move classes are explicit lists.** Iron Fist is 1.2× for the punch list; Sharpness and Mega Launcher are 1.5× for their lists. Technician evaluates each hit's resolved power, including variable-power changes; Hidden Power is not a 1-power Technician attack. Sheer Force requires a damaging move with a nonzero removable secondary effect and suppresses that effect; it is not a universal damage bonus. Its Life Orb exception only applies to qualifying attacks.
9. **Triage includes draining attacks and healing, with +3 priority.** Meganium and Bellossom can use priority Giga Drain/Draining Kiss or recovery depending on the chosen build. They do not also receive their other ability's weather/damage benefit. Prankster targeting restrictions, Armor Tail and Queenly Majesty are real counterplay to priority-dependent sets.
10. **Items and move access are part of species strength.** Eviolite boosts both defenses of species that can still evolve; this includes newly evolving Raichu and the custom intermediates. Thick Club doubles Cubone/Marowak's attacking stat, and Light Ball supports Pikachu's offense. Orbs, Life Orb and Assault Vest are in the Mahogany held-item mart. TMs are reusable. The Goldenrod utility tutor supplies compatible Substitute, Sleep Talk, screens and Thunder Wave for ¥1,000. Blackthorn's reminder teaches only the current species' level-up moves up to its current level for ¥1,000; the egg tutor uses the lowest-stage egg list on evolved Pokémon for ¥5,000.

Heavy-Duty Boots, White Herb, Black Sludge, Sitrus Berry, Stored Power, Electro Shot, Aurora Veil, Zero to Hero and Palafin's Hero form must not be silently imported into the analysis. Some familiar strategies are therefore unavailable, while this game's custom tools provide different alternatives.

## Progression and evolution fairness

Hard Mode caps are read directly from the source. The initial sequence is **10, 16, 20, 25, 30, 34, 38, 45**, with **57** covering the Elite Four; Kanto then progresses to **73**. Normal mode has no comparable story cap. A level-64 move is relevant in Kanto, not a typical Johto gym answer. Advancing an otherwise existing move is therefore a real campaign buff even when it adds nothing to a level-100 set.

However, level thresholds alone are not proof of availability. A mapped low-level wild encounter does not establish that its location is accessible early, and absence from wild tables does not prove unobtainability: gifts, trades, scripted encounters and evolution may supply it. The report lists mapped source evidence but makes no fabricated earliest-route claim. The encounter parser covers 3,259 explicit slots across 122 locations with no unparsed rows in this snapshot. Fixed trainer records are also included; their explicit four-move sets can use moves earlier than the player learns them or outside the player's pool, so changing level-up timing alone does not automatically rebalance those fights.

For delayed/removal recommendations, inspect **every route**: the species' own level-up list, all ancestors, egg tutor, numbered TM/HM and elemental tutor compatibility, utility flags, special event tutors, and clone mirrors. Venonat currently supplies Baton Pass at 33 to an evolved Venomoth; Squirtle currently supplies Shell Smash at 27. Conversely, the current Jumpluff Spore route is its own level-64 entry, and Scolipede's Baton Pass is its own level-one entry. Removing unrelated moves from Hoppip or Venipede is unnecessary if they do not have them.

The reminder does not restore arbitrary pre-evolution moves after evolution. The aggregate pool in this report means “can obtain and retain this move with a suitable evolution path,” not “every evolved specimen can immediately relearn it.” An intermediate trained beyond its evolution level can retain a later move before evolving; doing so has an actual progression cost. Egg moves have fewer eventual breeding restrictions because the tutor teaches them directly.

Retention also includes earlier TM and tutor compatibility, not only level-up moves. Two useful exceptions in this snapshot are Flapple retaining Reflect from Dipplin, and Overqwil retaining Thunder Wave from Qwilfish. These are this game's actual evolution routes: Applin evolves into Dipplin, which branches into Flapple/Appletun/Hydrapple; Qwilfish evolves into Overqwil at level 36. The report marks those routes explicitly; the evolved species' own compatibility flags alone would miss them.

Scyther, Porygon2, Chansey, Dusclops, Galarian Corsola, Magneton, Rhydon, Piloswine, Bisharp, Duraludon, Misdreavus, Primeape, Raichu, Dunsparce, Jynx, Ursaring and custom Watu/Raitora deserve separate comparisons as Eviolite users. Evolution should offer a different advantage—offense, Speed, typing, regeneration or item freedom—not necessarily higher damage and bulk in every possible item combination. Baby and early stages do not need final-grade BST buffs simply to be viable after their intended evolution point.

Growth rate also matters for ordinary play and reaching delayed evolutions. The report preserves each source growth rate; it does not assume an equal amount of experience yields an equal level for every species. Hard Mode trainer stat experience and campaign-only badge boosts also change matchups independently of base stats. Badge stat boosts do not apply in Tower/link battles, so campaign and equal-level format results should be recorded separately.

## Validation, limits and the next test pass

This is a complete **source-based design review**, not a completed tournament simulation or a measured ranking. The extraction verifies all 495 records against actual source order/pointers, all 421 move records and their categories, acquisition routes and source matchups. Every illustrative build has exactly four distinct moves, an assigned ability and an existing item; no fifth-move sets, stacked ability combinations or absent-item assumptions are accepted. The proposed change ledger asserts current values and rejects redundant move additions. The nine clones are checked against their originals. The current game's existing learnset audit is also run.

The report separates facts, recommendations and provisional fallbacks. Source-backed “best STAB” lists are move candidates, not a damage ranking: accuracy, recoil, charging, multi-hit behavior, variable power, categories, abilities, items, targets and four-move costs can reverse their order. Type matchups are explicitly **typing only**; they do not silently include Levitate, immunities, weather, Gas or Mold Breaker.

I would validate priority-1 changes with the existing battle harness and a small, reproducible campaign pass before broadening the edits:

1. Test each concerning four-move build at the relevant cap and at level 100, with identical DVs/stat experience/items on controls. Repeat across enough ordinary RNG seeds to compare rates, and use forced RNG only for specific interaction boundaries.
2. Record setup turns, safe switching opportunities, KOs, forced defensive responses, recovery cycles and fight length—not just final wins. Compare full HP, damaged HP, hazards present/absent and after item loss.
3. Include physical/special revenge killers, priority, priority blockers, strong STAB resists/immunities, status immunities, Taunt/Encore, Haze/Unaware, phazing and Neutralizing Gas where the opponent actually has those tools. Confirm opponents' moves and ability slots in source before calling them counters.
4. Keep campaign players' access restrictions separate from explicit trainer/Tower sets. Recheck boss parties that directly specify removed/delayed moves; the source report lists those appearances for review.
5. Test the relevant Original/Enhanced and abilities-off settings. In particular, ability-off Huge Power species, fixed-form Palafin, Dragon-type starters and original weak Bugs have a different power budget; do not chase parity in every optional ruleset by globally overbuffing their strongest version.
6. Apply one targeted intervention per independent problem, then repeat the meaningful comparison. Avoid combining all fallback nerfs with the initial ledger. Recheck alternative builds after a change so a problematic set is curtailed without needlessly deleting the species' entire niche.

For ordinary roster balance, useful reference roles are the current 535-BST starter group, fast special attackers such as Alakazam/Gengar, physical bruisers such as Arcanine/Heracross, utility pivots such as Lanturn/Tentacruel, walls such as Skarmory/Quagsire, and the 600-BST pseudo-legendary class. Mewtwo/Lugia/Ho-Oh's 680-BST class belongs to deliberately exceptional acquisition/format design. Matching every species to the strongest example in every role would produce a much less interesting game.
