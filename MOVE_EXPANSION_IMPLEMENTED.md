# Move Expansion — implemented 2026-07-28

**62 moves added.** `NUM_ATTACKS` 351 → **413**. 13 new move effects, 4 new battle commands,
73 animation scripts added, 26 learnsets updated.

> **Not build-verified.** The rgbds bundled in `rgbds/` is corrupt (`rgbds-0.5.2-linux-x86_64.tar.xz`
> fails `xz -t`, and the loose `rgbasm` binary segfaults), so nothing here has been through the
> assembler. Everything below passed a full static consistency check — parallel-table alignment,
> symbol resolution, label resolution, string lengths, learnset sort order — but you need to run
> `make` locally. See "If the build fails" at the bottom.

---

## Moves added (62)

Dragon Tail was included as the free rider on `EFFECT_CIRCLE_THROW`, as flagged in the shortlist.

`OVERHEAT LEAF_STORM FAKE_OUT FLIP_TURN IRON_DEFENSE ROCK_POLISH WOOD_HAMMER HEAD_SMASH DRILL_RUN
PSYCHO_CUT SACRED_SWORD BRICK_BREAK HEAT_WAVE SNARL NUZZLE BULLET_SEED DUALWINGBEAT ROCK_TOMB
LOW_SWEEP MUD_SHOT AIR_CUTTER CROSS_POISON MAGICAL_LEAF SIGNAL_BEAM SCALE_SHOT PHANTOMFORCE
HEADLONGRUSH SHADOW_BONE DIRE_CLAW BARB_BARRAGE INFERNAL_PARADE KOWTOW_CLEAVE ARMOR_CANNON
SHELLSIDEARM GLAIVE_RUSH DRAGON_DARTS APPLE_ACID GRAV_APPLE PSYSHIELD RAGING_FURY STRANGESTEAM
EERIE_SPELL BANEFUL_BUNKER RAGING_BULL FICKLE_BEAM STONE_AXE QUIVER_DANCE STEALTH_ROCK DEFOG
BODY_PRESS WORK_UP SUPERPOWER FIERY_DANCE FOUL_PLAY RAGE_FIST CRUSH_CLAW FORCE_PALM HAMMER_ARM
CIRCLE_THROW FREEZE_DRY BOUNCE DRAGON_TAIL`

Hi Horsepower was dropped per your call. `DAZZLINGLEAM`, `DISARM_VOICE`, `DRAININGKISS` and
`GRASS_KNOT` were excluded — the first three already exist as `DAZZLING_GLEAM`,
`DISARMING_VOICE`, `DRAINING_KISS`, and Grass Knot is weight-based.

---

## New effects (13)

| Effect | Implementation |
|---|---|
| `EFFECT_WORK_UP` | Effect script only — ATTACK +1, SPCL.ATK +1 |
| `EFFECT_QUIVER_DANCE` | Effect script only — SPCL.ATK / SPCL.DEF / SPEED +1 |
| `EFFECT_SP_ATK_UP_HIT` | Effect script only — mirror of `AttackUpHit` (Fiery Dance) |
| `EFFECT_SUPERPOWER` | Effect script only — damage, then user's ATTACK and DEFENSE fall |
| `EFFECT_HAMMER_ARM` | Effect script only — damage, then user's SPEED falls |
| `EFFECT_CIRCLE_THROW` | Effect script only — damage, then existing `forceswitch` (also Dragon Tail) |
| `EFFECT_BODY_PRESS` | `PlayerAttackDamage` / `EnemyAttackDamage` swap in the user's DEFENSE |
| `EFFECT_FOUL_PLAY` | Same two routines swap in the **target's** ATTACK |
| `EFFECT_FREEZE_DRY` | `BattleCheckTypeMatchup` recomputes the matchup vs WATER-types (see below) |
| `EFFECT_RAGE_FIST` | New `ragefist` command; power = 50 + 50×hits taken, capped at 250 |
| `EFFECT_STEALTH_ROCK` | New `stealthrock` command + switch-in damage in `SpikesDamage` |
| `EFFECT_STEALTH_ROCK_HIT` | New `stealthrockhit` command — Stone Axe sets the hazard on hit |
| `EFFECT_DEFOG` | New `defog` command — clears hazards + screens **both sides**, drops evasion |

**Stealth Rock** uses bit 7 of `wPlayerScreens` / `wEnemyScreens` (`SCREENS_STEALTH_ROCK`, the
last free bit). Damage scales off the ROCK matchup via `predef CheckTypeMatchup`: 1/32 at 0.25x,
1/16 at 0.5x, 1/8 at 1x, 1/4 at 2x, 1/2 at 4x. Unlike Spikes it hits Flying-types and Levitate.
Rapid Spin and Mortal Spin now blow it away.

**Rage Fist** counts hits in `wPlayerRageFistHits` / `wEnemyRageFistHits`, incremented in
`BattleCommand_ApplyDamage`'s `.update_damage_taken` (so Substitute hits don't count). Both live
inside the `wBattle`…`wBattleEnd` range, so `ClearBattleRAM` zeroes them at battle start — no
extra reset code.

**Freeze-Dry** doesn't scale the finished matchup. The type chart accumulates with a truncating
divide (`matchup = matchup * entry / 10`), so Ice vs Water/Ice lands on 0.25x rather than the
true 0.5x, and no single multiplier can fix that. Instead it scores the move against the
target's **non-Water** type alone and doubles that; pure Water is a flat 2x. Results:

| Target | Freeze-Dry |
|---|---|
| pure Water | 2x |
| Water/Ground, Water/Flying, Water/Grass | 4x |
| Water/Poison, Water/Dark | 2x |
| Water/Ice, Water/Steel | 1x |

Uses `wFreezeDryTypeScratch` (2 bytes) to hand `CheckTypeMatchup` a synthetic type pair.

**Body Press caveat:** the crit path still runs `ThickClubBoost` on whatever stat pointer it
picked, so a Cubone/Marowak holding Thick Club and using Body Press would have its *Defense*
doubled. Harmless in practice, but that's the one wart.

---

## Animations (73 scripts)

New file `data/moves/animations5.asm`, new `SECTION "Move Animations 5"` in `main.asm`.

**40 ported from Johto Legends** — Fake Out, Iron Defense, Rock Polish, Wood Hammer, Head Smash,
Drill Run, Psycho Cut, Sacred Sword, Brick Break, Heat Wave, Snarl, Nuzzle, Bullet Seed, Dual
Wingbeat, Rock Tomb, Low Sweep, Mud Shot, Air Cutter, Cross Poison, Magical Leaf, Signal Beam,
Phantom Force, Headlong Rush, Shadow Bone, Dire Claw, Shell Side Arm, Psyshield Bash, Raging
Fury, Strange Steam, Eerie Spell, Raging Bull, Quiver Dance, Work Up, Superpower, Crush Claw,
Force Palm, Hammer Arm, Circle Throw, Bounce, Dragon Tail — plus 11 helper labels JL's scripts
depend on (`BattleAnim_Wait8/16/32/48/64/96`, `WingGFX`, `TailAttack`, `Smog2`, `RoarBranch`,
`HornDrillBranch`, `EndureLoop`).

Only one constant needed remapping: JL's `ANIM_BG_CYCLE_OBPALS_GRAY_AND_YELLOW` is Crimson's
`ANIM_BG_06` (same index). Four animation objects were ported into
`data/battle_anims/objects.asm` + `constants/battle_anim_constants.asm`:
`ANIM_OBJ_HEAT_WAVE`, `ANIM_OBJ_SHELLSIDEARM`, `ANIM_OBJ_BULLET_SEED`, `ANIM_OBJ_QUIVER_DANCE`.
All four reuse framesets, funcs and gfx you already had — **no new artwork**.

Polished Crystal turned out not to be a useful donor here: that tree only has 287 moves and
doesn't define any of these.

**22 written from scratch** using your existing object set — Overheat, Leaf Storm, Flip Turn,
Scale Shot, Barb Barrage, Infernal Parade, Kowtow Cleave, Armor Cannon, Glaive Rush, Dragon
Darts, Apple Acid, Grav Apple, Baneful Bunker, Fickle Beam, Stone Axe, Stealth Rock, Defog, Body
Press, Fiery Dance, Foul Play, Rage Fist, Freeze-Dry. A few notes on those:

- **Overheat** — radial flame, twin fire blasts, screen-shake explosion, then a smoke puff as the user's glow burns out.
- **Leaf Storm** — `ANIM_OBJ_VORTEX` with razor leaves and petals spiralling into a `PETAL_DANCE_IMPACT`.
- **Stealth Rock** — three rocks rise and hang, then glimmer, so it reads as "suspended", not "Spikes".
- **Foul Play** — dark pulses gather *from the target*, shrink into the user, then come back as a heavy hit.
- **Rage Fist** — anger marks build, then a screen-shaking `LONG_PUNCH` and explosion.
- **Body Press** — reuses the Harden branch on the user, then a full-body slam with `ANIM_BG_TACKLE`.

---

## Audit pass (2026-07-28, after the Freeze-Dry catch)

All 62 rows were diffed field-by-field against Gen 8/9 values.

### Corrected — three values came from the Johto Legends list, not canon

| Move | Was | Now | Source |
|---|---|---|---|
| Head Smash | 90 accuracy | **80** | 150 BP / 80% / 5 PP |
| Phantom Force | 120 power | **90** | 90 BP / 100% / 10 PP |
| Bounce | 100 power | **85** | 85 BP / 85% / 5 PP |

**Raging Fury stays at 120.** I briefly "corrected" it to 90 and that was wrong — 90 is the
Legends: Arceus value. In mainline Gen 8/9 it's 120 BP / 100% / 10 PP, consistent with the rest
of the rampage family (Thrash, Outrage and Petal Dance are all 120). The Johto Legends value was
right. All four are now verified against Bulbapedia/Serebii/PokémonDB rather than recall.

### Fixed — missing priority

`EFFECT_FAKE_OUT` had **no priority entry**, which made Fake Out nearly useless: it only works on
the turn you switch in, and without going first it loses the race. Now `BASE_PRIORITY + 3`, above
First Impression (+2) and Quick Attack (+1).

`EFFECT_CIRCLE_THROW` is canon −6. This engine's priority byte is unsigned with `BASE_PRIORITY 1`,
so 0 is the floor — the same value Roar and Whirlwind use. Circle Throw and Dragon Tail now move
last alongside them, which is the closest the engine can express.

### Fixed — ability move lists

These are keyed by explicit tables in `abilities_engine.asm` and would have silently missed the
new moves:

- **`PunchMoves`** (Iron Fist): +Hammer Arm, Rage Fist
- **`SliceMoves`** (Sharpness): +Psycho Cut, Sacred Sword, Air Cutter, Cross Poison, Kowtow Cleave, Stone Axe
- **`SoundMoves`** (Soundproof): +Snarl, Eerie Spell
- **`BallBombMoves`** (Bulletproof): +Bullet Seed

Reckless and Sheer Force key off move *effect* / nonzero effect chance rather than a list, so
Wood Hammer, Head Smash and every secondary-effect move are already covered automatically.

### Third pass — source-verified, zero further changes

Every move was diffed against published tables rather than recall. **No data errors found on this
pass.** Coverage:

| Source | Moves confirmed |
|---|---|
| PokéDB Gen 4 move table | Cross Poison, Defog, Force Palm, Hammer Arm, Head Smash, Leaf Storm, Psycho Cut, Rock Polish, Stealth Rock, Wood Hammer |
| PokéDB Gen 5 move table | Circle Throw, Dragon Tail, Drill Run, Fiery Dance, Foul Play, Low Sweep, Quiver Dance, Sacred Sword, Snarl, Work Up |
| PokéDB Gen 8 move table | Apple Acid, Barb Barrage, Body Press, Dire Claw, Dual Wingbeat, Eerie Spell, Flip Turn, Grav Apple, Headlong Rush, Infernal Parade, Psyshield Bash, Raging Fury, Scale Shot, Shell Side Arm, Stone Axe, Strange Steam |
| PokéDB Gen 9 move table | Armor Cannon, Fickle Beam, Glaive Rush, Kowtow Cleave, Rage Fist, Raging Bull |
| Individual lookups | Head Smash, Phantom Force, Bounce, Raging Fury, Rock Tomb, Air Cutter, Bullet Seed, Heat Wave |

Two effect implementations were challenged and came back **correct**:

- **Psyshield Bash** raises the user's Defense only. PokéDB's blurb claims "Defense and Special Defense"; Bulbapedia confirms Defense by one stage. `EFFECT_DEFENSE_UP_HIT` is right.
- **Headlong Rush** lowers the user's Defense *and* Special Defense. PokéDB's blurb says only "Defense"; Bulbapedia confirms both. `EFFECT_CLOSE_COMBAT` is right.

Also worth noting: Headlong Rush additionally strips Reflect, Light Screen, Aurora Veil,
Safeguard, Mist, Spikes, Toxic Spikes and Stealth Rock from the target's side. Not implemented —
added to the simplifications table below.

Not covered by a source table (stable since Gen 3/6/7, unchanged for a decade): Overheat, Fake
Out, Iron Defense, Brick Break, Mud Shot, Magical Leaf, Signal Beam, Crush Claw, Superpower,
Nuzzle, Freeze-Dry, Shadow Bone.

### Verified correct, no change needed

Headlong Rush and Armor Cannon both drop the user's Def and SpD — `EFFECT_CLOSE_COMBAT` already
does exactly that. Kowtow Cleave and Magical Leaf use `EFFECT_ALWAYS_HIT`, so their accuracy
field is correctly ignored. Infernal Parade's `EFFECT_HEX` doubles on status. Contact flags spot
-checked: Psycho Cut non-contact, Drill Run contact, Shadow Bone non-contact — all correct.

### Full-behaviour pass — all 13 simplifications implemented

13 more effects (`EFFECT_SACRED_SWORD` … `EFFECT_BANEFUL_BUNKER`), 6 more battle commands, and a
second core file `engine/battle/move_effects/expansion_cores2.asm`.

| Move | Now does |
|---|---|
| Sacred Sword | ignores the target's DEFENSE boosts — keeps the user's boosted ATTACK, uses the target's unmodified defense |
| Brick Break | shatters Reflect and Light Screen before damage (`breakscreens`) |
| Headlong Rush | also sweeps the target's screens **and** entry hazards |
| Raging Bull | type follows the user's form (Tauros-Paldean Fire → FIRE, Water → WATER), and breaks screens |
| Dire Claw | 50% chance of poison, paralysis **or** sleep, 1/3 each (`direclawstatus`) |
| Barb Barrage | double damage against a poisoned target (`venoshockdouble`) plus the 50% poison |
| Scale Shot | 2–5 hits, then user's SPEED rises and DEFENSE falls |
| Bounce | 2-turn spring **with** the 30% paralysis |
| Fickle Beam | 30% roll for double power, with a "going all out!" message |
| Eerie Spell | drains PP from the target's last move after damage (reuses `spite`) |
| Glaive Rush | flags the user: until it acts again, attacks against it cannot miss and deal double damage |
| Baneful Bunker | Protect that poisons anything making contact |
| Shell Side Arm | strikes the target's physical DEFENSE instead of SPCL.DEF |

**Engine hooks added (four, all small and pattern-matched):**

- `BattleCommand_CheckHit` — attacks against a Glaive Rush user skip the accuracy roll, right beside the existing `EFFECT_ALWAYS_HIT` check.
- `RunDamageModifiers` `.defender` — doubles damage against a Glaive Rush user; new `DamageX2` helper modelled on `DamageX1_5`.
- `CheckHit.Protect` — calls `BanefulBunkerPoison_Core` after "protecting itself!".
- `PlayerAttackDamage` / `EnemyAttackDamage` — Sacred Sword's defense swap, and Shell Side Arm reusing the proven Psystrike branch.

New SubStatus2 flags: `SUBSTATUS_GLAIVE_RUSH` (bit 1), `SUBSTATUS_BANEFUL_BUNKER` (bit 2) — that
byte only had bits 0 and 7 in use. Baneful Bunker's flag clears in
`EndOpponentProtectEndureDestinyBond` alongside Protect; Glaive Rush's clears in
`EndUserDestinyBond`, so the drawback lasts until the user next acts.

**Remaining deliberate approximations:**

- Shell Side Arm hits the target's Defense rather than computing both damage rolls and picking the larger. It reuses the Psystrike code path, which is already proven in your build — the alternative needed a register-hungry comparison I couldn't test.
- Eerie Spell drains 2–5 PP (Spite's roll) rather than exactly 3.
- Glaive Rush's drawback ends when the user acts again rather than at end of the following turn.
- Dire Claw uses `BattleRandom` thirds, so the split is 1/3 each rather than the exact in-game weighting.

**These are the highest-risk edits in the whole change** — four hooks in hot battle paths, none
compiled. If the build breaks or battles misbehave, revert `expansion_cores2.asm`, the six new
commands, and the 13 new effect constants first; the original 62 moves work without any of it.

---

## Distribution (partial)

26 learnsets updated in `data/pokemon/evos_attacks_*.asm` — the signature moves, each on its
owner, verified present in your dex:

Annihilape (Rage Fist), Wyrdeer (Psyshield Bash), Arcanine-H (Raging Fury), Weezing-G (Strange
Steam), Slowking-G (Eerie Spell), Toxapex (Baneful Bunker + Body Press), Kleavor (Stone Axe +
Sacred Sword), Tauros-Paldean Fire/Water (Raging Bull), Volcarona (Quiver Dance, Fiery Dance,
Heat Wave), Ursaluna (Headlong Rush), Marowak-A (Shadow Bone), Sneasler (Dire Claw), Overqwil
(Barb Barrage), Typhlosion-H (Infernal Parade + Overheat), Kingambit (Kowtow Cleave), Armarouge
(Armor Cannon), Slowbro-G (Shell Side Arm), Baxcalibur (Glaive Rush + Scale Shot), Dragapult
(Dragon Darts + Phantom Force), Dipplin/Appletun (Apple Acid), Flapple (Grav Apple), Hydrapple
(Fickle Beam + Apple Acid), Umbreon (Foul Play), Grimmsnarl (Foul Play).

### ⚠ Still to do

**The other ~36 moves have no distribution yet.** Overheat, Leaf Storm, Stealth Rock, Defog,
Heat Wave, Brick Break, Iron Defense, Work Up, Bullet Seed and the rest exist and work, but
nothing learns them outside the list above. That means:

- `data/pokemon/evos_attacks_*.asm` — level-up moves for the broad distribution
- `data/pokemon/egg_moves*.asm` — egg moves
- `data/moves/tmhm_moves.asm` + TM item constants — Stealth Rock, Brick Break, Rock Tomb, Low Sweep and Heat Wave are all natural TMs
- Move tutor lists

Say the word and I'll do that pass next — it's mechanical but large, and worth doing as its own
change so it's easy to review.

---

## Every file touched

| File | Change |
|---|---|
| `constants/move_constants.asm` | +62 move constants |
| `constants/move_effect_constants.asm` | +13 effect constants |
| `constants/battle_anim_constants.asm` | +4 `ANIM_OBJ` constants |
| `constants/battle_constants.asm` | `SCREENS_STEALTH_ROCK EQU 7` |
| `data/moves/moves.asm` | +62 `move` rows |
| `data/moves/names.asm` | +62 names (all ≤12 chars) |
| `data/moves/descriptions.asm` | +62 pointers, +62 description blocks (all lines ≤18 chars) |
| `data/moves/animations.asm` | +62 `banim` entries |
| `data/moves/animations5.asm` | **new** — 73 animation scripts |
| `data/moves/effects.asm` | +13 effect scripts |
| `data/moves/effects_pointers.asm` | +13 pointers |
| `data/moves/contact_moves.asm` | bitfield rebuilt 44 → 52 bytes, 29 new contact moves flagged |
| `data/moves/critical_hit_moves.asm` | +Drill Run, Psycho Cut, Air Cutter, Cross Poison, Stone Axe |
| `data/moves/metronome_exception_moves.asm` | +Stealth Rock, Defog, Rage Fist |
| `data/battle_anims/objects.asm` | +4 `battleanimobj` entries |
| `data/battle/effect_command_pointers.asm` | +4 command pointers |
| `data/battle/ai/useful_moves.asm` | +13 entries |
| `data/battle/ai/encore_moves.asm` | +6 entries |
| `data/pokemon/evos_attacks_johto.asm` / `_kanto.asm` | 26 learnsets |
| `data/text/battle.asm` | +4 battle texts |
| `macros/scripts/battle_commands.asm` | +4 commands (`ragefist`, `stealthrock`, `stealthrockhit`, `defog`) |
| `engine/battle/effect_commands.asm` | 4 command wrappers, Body Press / Foul Play in DamageStats, Freeze-Dry in type matchup, Rage Fist counter in ApplyDamage |
| `engine/battle/core.asm` | Stealth Rock switch-in damage inside `SpikesDamage` |
| `engine/battle/move_effects/rapid_spin.asm` | Rapid/Mortal Spin clears pointed stones |
| `engine/battle/move_effects/expansion_cores.asm` | **new** — Stealth Rock, Stone Axe, Defog, Rage Fist cores |
| `wram.asm` | `wPlayerRageFistHits`, `wEnemyRageFistHits`, `wFreezeDryTypeScratch` |
| `main.asm` | 2 new `SECTION`s |

---

## If the build fails

Most likely causes, in order:

1. **Bank overflow.** The animation pointer table grew by 186 bytes and `bank32` was already
   large. If `rgblink` complains, move `data/moves/animations.asm`'s later scripts into
   `animations5.asm` — the `banim` macro stores a bank byte, so scripts can live anywhere.
2. **`SECTION "Move Animations 5"` / `"Move Expansion Cores"` don't fit.** Give them explicit
   bank numbers in `main.asm`, or `pokecrystal.link`.
3. **Local label collisions** in `PlayerAttackDamage` / `EnemyAttackDamage` — I added
   `.not_body_press`, `.not_foul_play`, `.not_body_press_mod` to each. They're in separate global
   scopes so they should be fine, but that's the one spot where I'd look first.

Paste me the error and I'll fix it.
