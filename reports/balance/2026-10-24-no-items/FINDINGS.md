# No-item balance findings

Completed October 27, 2026 using the pinned October 24 game build. Newer game-source changes are outside this audit; see [resume provenance](RESUMED-2026-10-27.md).
Internal report — October 24, 2026.

Tested **231 eligible Pokémon/forms**, **664 species/ability combinations**, **6,621 screened builds/strategies**, and **148,562 native battles**. Both sides held no item. The complete final league contributes 53,130 battles, 460 per species.

The [full tier list](TIER-LIST.md) ranks the selected builds by their final-roster league scores. These use Enhanced rules, level-100 singles and an automated policy; team roles and perfect play can differ. The trainer profile has empty item slots, and the player policy cannot request bag items.

Tier counts: `{"A":6,"B":28,"C":73,"D":92,"E":28,"F":3,"S":1}`.

## Strongest measured builds

| Pokémon | Tier | Score | Ability | Moves |
|---|:---:|---:|---|---|
| WOBBUFFET | S | 90.2% | SHADOW_TAG | COUNTER / MIRROR_COAT / AMNESIA / CHARM |
| MEWTWO | A | 82.2% | UNNERVE | NASTY_PLOT / PSYSTRIKE / FIRE_BLAST / GRASS_KNOT |
| LUGIA | A | 77.6% | PRESSURE | ACROBATICS / REST / SLEEP_TALK / PSYCHIC_M |
| URSALUNABM | A | 76.7% | BERSERK | COUNTER / BLOOD_MOON / EARTH_POWER / MOONBLAST |
| ARCHALUDON | A | 76.1% | STURDY | DRACO_METEOR / FLASH_CANNON / THUNDERBOLT / RETURN |
| JIRACHI | A | 75.0% | SERENE_GRACE | DOOM_DESIRE / REST / SLEEP_TALK / PSYCHIC_M |
| ZAPDOS | A | 75.0% | PRESSURE | THUNDERBOLT / ACROBATICS / HYPER_BEAM / HEAT_WAVE |
| HO_OH | B | 73.7% | PRESSURE | SACRED_FIRE / BRAVE_BIRD / FRUSTRATION / EARTHQUAKE |
| RAIKOU | B | 71.3% | COMPETITIVE | THUNDERBOLT / AURA_SPHERE / EXTRASENSORY / SCALD |
| BAXCALIBUR | B | 71.1% | ICE_BODY | OUTRAGE / IRON_HEAD / STRENGTH / BODY_SLAM |

Wobbuffet’s result is especially sensitive to this format: the policy knows the opponent’s moves and chooses Counter or Mirror Coat accordingly. Shadow Tag receives no trapping test in a duel without switching. Likewise, weather-, switching-, item- or ally-dependent abilities can have few opportunities here. A selected ability can win a validation tie through the deterministic selection order; its label does not prove that ability caused the league score. The report ranks tested builds, and the per-ability CSV retains the alternatives.

## Lowest measured builds

| Pokémon | Tier | Score | Ability | Moves |
|---|:---:|---:|---|---|
| BLISSEY | E | 30.2% | NATURAL_CURE | HYPER_VOICE / SEISMIC_TOSS / FIRE_BLAST / GRASS_KNOT |
| DUGTRIO | E | 30.2% | ARENA_TRAP | EARTHQUAKE / SUCKER_PUNCH / FRUSTRATION / FOUL_PLAY |
| ARIADOS | E | 29.6% | MERCILESS | MEGAHORN / SUCKER_PUNCH / POISON_JAB / FRUSTRATION |
| XATU | E | 27.8% | MAGIC_BOUNCE | PSYCHIC_M / SUCKER_PUNCH / HURRICANE / NIGHT_SHADE |
| DITTO | E | 27.0% | IMPOSTER | TRANSFORM |
| VENOMOTH | E | 26.3% | COMPOUND_EYES | SLEEP_POWDER / BUG_BUZZ / ROOST / SLUDGE_BOMB |
| ZANGOOSE | E | 25.9% | IMMUNITY | FRUSTRATION / CLOSE_COMBAT / GUNK_SHOT / SEED_BOMB |
| BRELOOM | F | 22.6% | QUICK_FEET | CLOSE_COMBAT / MACH_PUNCH / WOOD_HAMMER / FRUSTRATION |
| LUDICOLO | F | 17.0% | SWIFT_SWIM | SEISMIC_TOSS / WATERFALL / WOOD_HAMMER / FRUSTRATION |
| SMEARGLE | F | 12.6% | OWN_TEMPO | COUNTER / MIRROR_COAT / SUPER_FANG / NIGHT_SHADE |

## Moveset differences under the same ability

These differences use the separate 16-opponent validation panel (32 games per set), not league scores. Both sets have the same species, ability, item rule, opponent builds and seeds. Opening strategy can differ; see the CSV for exact opening slots. These are better/weaker *tested sets*, not proofs of global optima.

| Pokémon / ability | Better score | Weaker score | Better set | Weaker set |
|---|---:|---:|---|---|
| WOBBUFFET / SHADOW_TAG | 75.0% | 18.8% | COUNTER / MIRROR_COAT / AMNESIA / CHARM | AMNESIA / CHARM / DESTINY_BOND / ENCORE |
| EXCADRILL / SAND_RUSH | 75.0% | 28.1% | EARTHQUAKE / REST / SLEEP_TALK / IRON_HEAD | SWORDS_DANCE / EARTHQUAKE / IRON_HEAD / SUPERPOWER |
| DRAGAPULT / CLEAR_BODY | 71.9% | 31.2% | OUTRAGE / ACROBATICS / RETURN / SHADOW_BALL | WILL_O_WISP / OUTRAGE / ACROBATICS / RETURN |
| EXCADRILL / MOLD_BREAKER | 75.0% | 34.4% | EARTHQUAKE / REST / SLEEP_TALK / IRON_HEAD | SWORDS_DANCE / EARTHQUAKE / IRON_HEAD / SUPERPOWER |
| ARBOK / SHED_SKIN | 50.0% | 12.5% | SUCKER_PUNCH / DOUBLE_EDGE / CRUNCH / SEED_BOMB | POISON_JAB / SEED_BOMB / BITE / SKULL_BASH |
| OVERQWIL / POISON_POINT | 71.9% | 34.4% | GUNK_SHOT / FOUL_PLAY / FRUSTRATION / LIQUIDATION | SLUDGE_BOMB / DARK_PULSE / HYDRO_PUMP / ICE_BEAM |
| OVERQWIL / SWIFT_SWIM | 68.8% | 31.2% | GUNK_SHOT / FOUL_PLAY / FRUSTRATION / LIQUIDATION | SLUDGE_BOMB / DARK_PULSE / HYDRO_PUMP / ICE_BEAM |
| DRAGAPULT / CURSED_BODY | 65.6% | 31.2% | OUTRAGE / REST / SLEEP_TALK / ACROBATICS | WILL_O_WISP / OUTRAGE / ACROBATICS / RETURN |
| GRUMPIG / OWN_TEMPO | 50.0% | 15.6% | COUNTER / MIRROR_COAT / PSYCHIC_M / GRASS_KNOT | PSYCHIC_M / LUNGE / GRASS_KNOT / NIGHT_SHADE |
| WYRDEER / FRISK | 56.2% | 21.9% | THRASH / SUCKER_PUNCH / ZEN_HEADBUTT / MEGAHORN | HORN_LEECH / EXTRASENSORY / HIDDEN_POWER / TAKE_DOWN |
| ARBOK / STRONG_JAW | 59.4% | 28.1% | SUCKER_PUNCH / DOUBLE_EDGE / CRUNCH / SEED_BOMB | POISON_JAB / SEED_BOMB / BITE / SKULL_BASH |
| DUGTRIO_ALOLAN / SAND_FORCE | 43.8% | 12.5% | EARTHQUAKE / SUCKER_PUNCH / IRON_HEAD / THRASH | EARTH_POWER / FLASH_CANNON / HYPER_BEAM / SLUDGE_BOMB |
| SCIZOR / HYPER_CUTTER | 37.5% | 6.2% | COUNTER / IRON_HEAD / CLOSE_COMBAT / X_SCISSOR | U_TURN / CUT / SLASH / HEADBUTT |
| SCIZOR / SWARM | 37.5% | 6.2% | COUNTER / IRON_HEAD / CLOSE_COMBAT / X_SCISSOR | U_TURN / CUT / SLASH / HEADBUTT |
| TENTACRUEL / CLEAR_BODY | 53.1% | 21.9% | DAZZLING_GLEAM / SCALD / GUNK_SHOT / ICE_BEAM | MIRROR_COAT / HYDRO_PUMP / SLUDGE_BOMB / ICE_BEAM |
| TENTACRUEL / MERCILESS | 53.1% | 21.9% | DAZZLING_GLEAM / SCALD / GUNK_SHOT / ICE_BEAM | MIRROR_COAT / HYDRO_PUMP / SLUDGE_BOMB / ICE_BEAM |
| ARBOK / INTIMIDATE | 56.2% | 28.1% | CRUNCH / BITE / GUNK_SHOT / FRUSTRATION | POISON_JAB / SEED_BOMB / BITE / SKULL_BASH |
| CARRACOSTA / STURDY | 68.8% | 40.6% | SHELL_SMASH / LIQUIDATION / STONE_EDGE / SUPERPOWER | ROCK_BLAST / ROCK_TOMB / SUPERPOWER / STONE_EDGE |
| CLEFABLE / MAGIC_GUARD | 62.5% | 37.5% | MOONBLAST / NIGHT_SHADE / FIRE_BLAST / GRASS_KNOT | TOXIC / MOONBLAST / SOFTBOILED / NIGHT_SHADE |
| CLODSIRE / POISON_POINT | 50.0% | 25.0% | COUNTER / EARTHQUAKE / GUNK_SHOT / MEGAHORN | EARTHQUAKE / GUNK_SHOT / MEGAHORN / RETURN |

## Ceruledge

All three legal abilities — Flash Fire, Weak Armor and Sharpness — received the same 11 screening moveset/strategy variants. Each ability advanced two distinct movesets to validation. The native Sharpness control independently ran 72 one-turn probes (12 seeds, both orientations, three abilities); Bitter Blade damage increased by approximately 1.5× with Sharpness. These probes do not contribute to the tier scores.

The table below shows the full Ceruledge validation pass. An ability's best score here can use a different moveset from another ability; consult the controlled screening CSV for identical-moveset ability comparisons.

| Ability | Score | W–L–D | Moves | Opening |
|---|---:|---|---|---|
| SHARPNESS | 59.4% | 19–13–0 | BITTER_BLADE / REST / SLEEP_TALK / CLOSE_COMBAT | tactical |
| WEAK_ARMOR | 56.2% | 18–14–0 | BITTER_BLADE / SHADOW_SNEAK / CLOSE_COMBAT / SHADOW_CLAW | tactical |
| WEAK_ARMOR | 56.2% | 18–14–0 | BITTER_BLADE / CLOSE_COMBAT / SHADOW_CLAW / RETURN | tactical |
| SHARPNESS | 50.0% | 16–16–0 | BITTER_BLADE / SHADOW_CLAW / SWORDS_DANCE / CLOSE_COMBAT | tactical |
| FLASH_FIRE | 50.0% | 16–16–0 | BITTER_BLADE / CLOSE_COMBAT / SHADOW_CLAW / RETURN | tactical |
| FLASH_FIRE | 50.0% | 16–16–0 | BITTER_BLADE / SHADOW_SNEAK / CLOSE_COMBAT / SHADOW_CLAW | tactical |

## Native checks and limits

- 31 unit tests and 10 native integration scenarios passed, including PP exhaustion/Struggle, deterministic replay, Low Kick's native weight power, both rollout sides and native party handling.
- The source/compiled check matched all 498 species and 442 moves. The exact game, source and runtime hashes are in `receipt.json`.
- 64 additional native mechanics probes checked empty-hand Acrobatics, No Guard's accuracy and hail Blizzard on both sides. An inert held POTION appears only in Acrobatics' control cases, never in ranked battles.
- Native item observations: `{"NO_ITEM":900842}`.
- Weight move attempts: `{"GRASS_KNOT":7133,"HEAT_CRASH":288,"HEAVY_SLAM":1086,"LOW_KICK":2303}`.
- Battle status counts: `{"completed":148562}`; flagged records: **0**. A turn limit is unresolved, not automatically a draw, loss or game bug. Its lower-bound score earns no points.
- No game mechanics were replaced with another generation's implementation. Selection heuristics and scripted openings can still misplay some situations. Bugs without an applicable assertion can remain undetected.

## Files

- `TIER-LIST.md`: complete ranking and methods.
- `matchup-matrix.csv`: every final-league pairing; cells are points over two side-swapped games; blank diagonal.
- `moveset-comparisons.csv`: stronger/weaker validated sets under each ability.
- `ability-best-builds.csv`: each ability's best validated moveset.
- `controlled-ability-comparisons.csv`: screening comparisons holding moves/openings/opponents/seeds fixed.
- `ceruledge-screened-builds.csv` / `ceruledge-validated-builds.csv`: all Ceruledge evidence.
- `sharpness-native-checks.json`: full controlled native damage logs.

- `native-choice-checks.json`: Acrobatics and guaranteed-accuracy mechanics controls.

- `decision-consistency.json`: every saved action request and engine/data/ROM hash checked against the final policy.

The simulator and all these reports remain internal development tools, off the public website.
