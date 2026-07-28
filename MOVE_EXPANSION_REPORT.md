# Move Expansion — Implementation Report

Executes `MOVE_EXPANSION_HANDOFF.md`. Everything below is built and verified with
rgbds 0.5.2; `pokecrystal_movexpansion_test.gbc` in the repo root is the resulting ROM.

**Move count: 351 -> 466 (+115).**

## What was done

* All 97 moves present in Johto Legends but missing from Crimson Crystal were ported —
  data, names, descriptions and full battle animations.
* All 25 non-JL moves from handoff sections 4, 5 and 6 were written from scratch using the
  reskin map in section 8.
* 7 of those 122 were then removed at your request (see *Excluded* below), leaving 115.

## Excluded on request

* **Sludge Wave.**
* **The nine Johto Legends originals** (Draco Fang, Steel Slice, Stone Bash, Thunder Kick,
  Pincir Flurry, Jurassic Beam, Signal Wave, Catastrophe, Infernablast). Their *animations*
  were still reused where the handoff's reskin map called for it — Stone Bash's animation
  drives Stone Axe, for example.
* **Ally-support and multi-hit-the-field moves**, since Gen 2 has no double battles:
  Discharge, Lava Plume, Muddy Water, Round, Flame Burst, Aurora Veil, Tailwind. Removed
  cleanly — no dangling references remain anywhere in the tree.

  **Heat Wave, Petal Blizzard, Snarl, Air Cutter, Dazzling Gleam and Disarming Voice were kept**,
  implemented as ordinary single-target moves with their secondary effects intact:

  | Move | Type | Cat | Pwr | Acc | PP | Behaviour |
  |---|---|---|---|---|---|---|
  | Heat Wave | Fire | Special | 95 | 90 | 10 | 10% burn |
  | Petal Blizzard | Grass | Physical | 90 | 100 | 15 | plain damage |
  | Snarl | Dark | Special | 55 | 95 | 15 | always cuts Sp.Atk; sound-based |
  | Air Cutter | Flying | Special | 60 | 95 | 25 | high critical-hit ratio |
  | Dazzling Gleam | Fairy | Special | 80 | 100 | 10 | plain damage |
  | Disarming Voice | Fairy | Special | 40 | 100 | 15 | never misses; sound-based |

## Files added

| File | Purpose |
|---|---|
| `data/moves/moves2.asm` | `move` rows for the new moves (own bank; `Moves` is now a two-chunk indirect table) |
| `data/moves/descriptions2.asm` | Description pointers + text for the new moves (own bank) |
| `data/moves/animations5.asm` | 117 battle-animation scripts ported from Johto Legends |
| `engine/battle/move_effects/handoff_moves.asm` | New battle commands and switch-in hazard cores |

`names.asm` was extended in place — `GetMoveName` reads it as one flat table, so it cannot be split.

## Engine changes

* **`SCREENS_UNUSED` (bit 3) is now `SCREENS_STEALTH_ROCK`**; bit 7 is `SCREENS_STICKY_WEB`.
* **Stealth Rock** — `StealthRockDamage_Core`, hooked into the switch-in path next to Spikes.
  Damage scales 1/32..1/2 max HP off Rock's effectiveness against the incoming mon's types.
  Respects Magic Guard.
* **Sticky Web** — `StickyWebSpeedDrop_Core`, -1 Speed on switch-in, skipped for ungrounded mons
  (reuses `CheckSpikesUngrounded_Core`, so Flying / Levitate / Air Balloon are exempt).
* **Defog** — clears hazards *and* screens from both sides.
* **Body Press / Foul Play** — `PlayerAttackDamage` and `EnemyAttackDamage` now route the
  physical attack stat through `GetPhysicalAttackSource` / `...Boosted`, which substitutes the
  user's Defense (Body Press) or the target's Attack (Foul Play).
* **Freeze-Dry** — `freezedry` command multiplies `wTypeModifier` x4 against Water types,
  turning Ice's normal 1/2 into 2x.
* **19 new move effects** in total. The multi-stat ones (Quiver Dance, Coil, Cosmic Power,
  Work Up) are pure effect scripts built on Crimson's existing
  `deferstatmessages`/`flushstatmessages` idiom — no new engine code, same pattern as Bulk Up.

## Deliberate approximations

These moves are in and usable, but do not model their modern mechanics exactly. Flagged so you
can decide whether to deepen them later:

| Move | Uses | Note |
|---|---|---|
| Aqua Ring | `EFFECT_HEAL` | Heals 50% once instead of 6.25%/turn; needs a residual substatus bit |
| Strength Sap | `EFFECT_ATTACK_DOWN_2` | Drops Attack but does not heal the user |
| Grass Knot | `EFFECT_NORMAL_HIT` @ 60 BP | Fixed power; no weight lookup |
| Bounce / Phantom Force | `EFFECT_FLY` | Two-turn semi-invulnerable; loses the secondary effect |
| Sacred Sword / Chip Away | `EFFECT_NORMAL_HIT` | Does not ignore the target's stat boosts |
| Brick Break / Raging Bull | `EFFECT_NORMAL_HIT` | Does not shatter screens |
| Eerie Spell | `EFFECT_NORMAL_HIT` | No PP reduction |
| Flatter | `EFFECT_SWAGGER` | Raises Attack rather than Sp.Atk |
| Rage Fist | 90 BP fixed | Does not scale with hits taken |
| Infernal Parade | `EFFECT_HEX` | Doubles vs. status, but the 30% burn is not wired |
| Stone Axe | `EFFECT_NORMAL_HIT` | Does not set Stealth Rock on hit |

Nine Johto Legends animation objects had no Crimson equivalent (`ANIM_OBJ_QUIVER_DANCE`,
`ANIM_OBJ_BULLET_SEED`, `ANIM_OBJ_COIL`, `ANIM_OBJ_AQUA_RING`, `ANIM_OBJ_MOON`,
`ANIM_OBJ_DRAININGKISS`, `ANIM_OBJ_FEATHER_DANCE`, `ANIM_OBJ_SHELLSIDEARM`, plus
`ANIM_GFX_POKE_BALL_BG` and `SFX_PUDDLE`). Rather than port the frameset/OAM chain — JL uses
8-bit frameset ids where Crimson uses 16-bit, so the tables are not compatible — each was
substituted with the nearest Crimson object. Those animations play correctly but look slightly
different from Johto Legends.

## Tables updated

`contact_moves.asm` was regenerated as a 59-byte bitfield covering all 466 moves.
`CriticalHitMoves` gained Drill Run, Psycho Cut, Air Cutter and Cross Poison — the handoff calls
out the first two explicitly. Snarl and Disarming Voice were added to `SoundMoves` (Soundproof).
`PunchMoves`, `SliceMoves`, `PulseMoves` and `SoundMoves` in `abilities_engine.asm` were
extended — Sharpness in particular now picks up Psycho Cut, Sacred Sword, Stone Axe, Kowtow
Cleave and Cross Poison. AI tables `useful_moves`, `residual_moves`, `encore_moves` and
`stall_moves` were extended. Reckless and Sheer Force need no list work: both are driven by
move effect / effect-chance, so the new recoil and secondary-effect moves are picked up for free.

## Distribution

206 level-up entries were added across `evos_attacks_kanto/johto/clones.asm`, covering every
species the handoff names plus the obvious additional users — Rampardos finally gets Head Smash,
Volcarona gets Quiver Dance and Fiery Dance, the Applin family gets Apple Acid / Grav Apple /
Fickle Beam, and the hazard setters (Skarmory, Forretress, Tyranitar, Steelix, Torkoal, Golem,
Donphan, Onix, Cradily, Magcargo, Bastiodon) get Stealth Rock.

**Still open:** TM/HM and move-tutor distribution. Adding TMs means adding `TM_*` item constants
and touching every species' `tmhm` line in `data/pokemon/base_stats/`, which is a separate pass.
Egg moves were also left alone. Everything is obtainable by level-up as it stands.

## Bank pressure — worth knowing

Two banks hit their 16 KB ceiling during this work, each overflowing by a single byte:

* **`Effect Commands`.** Fixed properly rather than by trimming content: `CriticalHitMoves` was
  moved out of that bank into the new `Handoff Move Effects` section, and the lookup in
  `.CheckCritical` now goes through `CheckCriticalHitMove_Core` via `farcall`. This is safe
  because `ReturnFarCall` deliberately pops to `bc` rather than `af` to preserve flags, so the
  carry result from `IsInHalfwordArray` survives the bank switch. Net effect: ~34 bytes freed.
* **`Evolutions and Attacks 2`.** Freed 3 bytes by dropping one added level-up entry
  (Volcarona's Heat Wave — it already learns Quiver Dance and Fiery Dance).

Both banks are now nearly full again. If you add much more to either, you will need to split a
section rather than trim. The ROM itself has plenty of room — 114 of 256 banks are still unused —
so new content should go into fresh floating `SECTION`s.

## Verification

`make` completes clean. A checker confirms `move_constants.asm`, `moves.asm` + `moves2.asm`,
`names.asm`, the description pointer tables and the `BattleAnimations` table all hold 466 entries
in matching order, that no move name exceeds 12 characters, that there are no duplicate move
constants, and that the effect and battle-command pointer tables match their constant lists.

As the handoff warns, misalignment shows up in-game rather than at compile time — so please still
open the ROM and spot-check a few of the new moves' names and descriptions in a battle menu.

## New moves

| Move | Type | Cat | Pwr | Acc | PP | Effect |
|---|---|---|---|---|---|---|
| Rock Tomb          | ROCK     | Physical |  60 |  95 | 15 | `EFFECT_SPEED_DOWN_HIT` |
| Featherdance       | FLYING   | Status   |   0 | 100 | 15 | `EFFECT_ATTACK_DOWN_2` |
| Mirror Shot        | STEEL    | Special  |  65 |  85 | 10 | `EFFECT_ACCURACY_DOWN_HIT` |
| Silver Wind        | BUG      | Special  |  60 | 100 |  5 | `EFFECT_ALL_UP_HIT` |
| Dragon Rush        | DRAGON   | Physical | 100 |  75 | 10 | `EFFECT_STOMP` |
| Drill Run          | GROUND   | Physical |  80 |  95 | 10 | `EFFECT_NORMAL_HIT` |
| Drainingkiss       | FAIRY    | Special  |  50 | 100 | 10 | `EFFECT_LEECH_HIT` |
| Metal Sound        | STEEL    | Status   |   0 |  85 | 40 | `EFFECT_SP_DEF_DOWN_2` |
| Signal Beam        | BUG      | Special  |  75 | 100 | 15 | `EFFECT_CONFUSE_HIT` |
| Magical Leaf       | GRASS    | Special  |  60 | 100 | 20 | `EFFECT_ALWAYS_HIT` |
| Mud Bomb           | GROUND   | Special  |  65 |  85 | 10 | `EFFECT_ACCURACY_DOWN_HIT` |
| Revenge            | FIGHTING | Physical |  60 | 100 | 10 | `EFFECT_AVALANCHE` |
| Rock Wrecker       | ROCK     | Physical | 150 |  90 |  5 | `EFFECT_HYPER_BEAM` |
| Iron Defense       | STEEL    | Status   |   0 | 100 | 15 | `EFFECT_DEFENSE_UP_2` |
| Bullet Seed        | GRASS    | Physical |  25 | 100 | 30 | `EFFECT_MULTI_HIT` |
| Inferno            | FIRE     | Special  | 100 |  50 |  5 | `EFFECT_BURN_HIT` |
| Wood Hammer        | GRASS    | Physical | 120 | 100 | 15 | `EFFECT_RECOIL_HIT` |
| Payback            | DARK     | Physical |  50 | 100 | 10 | `EFFECT_AVALANCHE` |
| Hihorsepower       | GROUND   | Physical |  95 |  95 | 10 | `EFFECT_NORMAL_HIT` |
| Mud Shot           | GROUND   | Special  |  55 |  95 | 15 | `EFFECT_SPEED_DOWN_HIT` |
| Sand Tomb          | GROUND   | Physical |  35 |  85 | 15 | `EFFECT_TRAP_TARGET` |
| Low Sweep          | FIGHTING | Physical |  65 | 100 | 20 | `EFFECT_SPEED_DOWN_HIT` |
| Cross Poison       | POISON   | Physical |  70 | 100 | 20 | `EFFECT_POISON_HIT` |
| Smart Strike       | STEEL    | Physical |  70 | 100 | 10 | `EFFECT_ALWAYS_HIT` |
| Belch              | POISON   | Special  | 120 |  80 |  5 | `EFFECT_POISON_HIT` |
| Nuzzle             | ELECTRIC | Physical |  20 | 100 | 20 | `EFFECT_PARALYZE_HIT` |
| Crush Claw         | NORMAL   | Physical |  75 |  95 | 10 | `EFFECT_DEFENSE_DOWN_HIT` |
| Odor Sleuth        | NORMAL   | Status   |   0 | 100 | 40 | `EFFECT_FORESIGHT` |
| Howl               | NORMAL   | Status   |   0 | 100 | 40 | `EFFECT_ATTACK_UP` |
| Psycho Cut         | PSYCHIC  | Physical |  70 | 100 | 20 | `EFFECT_NORMAL_HIT` |
| Dual Chop          | DRAGON   | Physical |  40 |  90 | 15 | `EFFECT_DOUBLE_HIT` |
| Rock Polish        | ROCK     | Status   |   0 | 100 | 20 | `EFFECT_SPEED_UP_2` |
| Double Hit M       | NORMAL   | Physical |  35 |  90 | 10 | `EFFECT_DOUBLE_HIT` |
| Blaze Kick         | FIRE     | Physical |  85 |  90 | 10 | `EFFECT_BURN_HIT` |
| Sheer Cold         | ICE      | Special  |   0 |  30 |  5 | `EFFECT_OHKO` |
| Echoed Voice       | NORMAL   | Special  |  40 | 100 | 15 | `EFFECT_FURY_CUTTER` |
| Needle Arm         | GRASS    | Physical |  60 | 100 | 15 | `EFFECT_STOMP` |
| Grasswhistle       | GRASS    | Status   |   0 |  55 | 15 | `EFFECT_SLEEP` |
| Ominous Wind       | GHOST    | Special  |  60 | 100 |  5 | `EFFECT_ALL_UP_HIT` |
| Frenzy Plant       | GRASS    | Special  | 150 |  90 |  5 | `EFFECT_HYPER_BEAM` |
| Blast Burn         | FIRE     | Special  | 150 |  90 |  5 | `EFFECT_HYPER_BEAM` |
| Hydro Cannon       | WATER    | Special  | 150 |  90 |  5 | `EFFECT_HYPER_BEAM` |
| Wave Crash         | WATER    | Physical | 120 | 100 | 10 | `EFFECT_RECOIL_HIT` |
| Fake Out           | NORMAL   | Physical |  40 | 100 | 10 | `EFFECT_FAKE_OUT` |
| Headlongrush       | GROUND   | Physical | 120 | 100 |  5 | `EFFECT_CLOSE_COMBAT` |
| Dualwingbeat       | FLYING   | Physical |  40 |  90 | 10 | `EFFECT_DOUBLE_HIT` |
| Twin Beam          | PSYCHIC  | Special  |  40 | 100 | 10 | `EFFECT_DOUBLE_HIT` |
| Psyshield          | PSYCHIC  | Physical |  70 |  90 | 10 | `EFFECT_DEFENSE_UP_HIT` |
| Meteor Mash        | STEEL    | Physical |  90 |  90 | 10 | `EFFECT_ATTACK_UP_HIT` |
| Force Palm         | FIGHTING | Physical |  60 | 100 | 10 | `EFFECT_PARALYZE_HIT` |
| Sky Uppercut       | FIGHTING | Physical |  85 |  90 | 15 | `EFFECT_NORMAL_HIT` |
| Head Smash         | ROCK     | Physical | 150 |  90 |  5 | `EFFECT_RECOIL_HIT` |
| Raging Fury        | FIRE     | Physical | 120 | 100 | 10 | `EFFECT_RAMPAGE` |
| Strangesteam       | FAIRY    | Special  |  90 |  95 | 10 | `EFFECT_CONFUSE_HIT` |
| Shadow Bone        | GHOST    | Physical |  85 | 100 | 10 | `EFFECT_DEFENSE_DOWN_HIT` |
| Poison Tail        | POISON   | Physical |  50 | 100 | 25 | `EFFECT_POISON_HIT` |
| Freeze Glare       | PSYCHIC  | Special  |  90 | 100 | 10 | `EFFECT_FREEZE_HIT` |
| Fiery Wrath        | DARK     | Special  |  90 | 100 | 10 | `EFFECT_FLINCH_HIT` |
| Shellsidearm       | POISON   | Special  |  90 | 100 | 10 | `EFFECT_POISON_HIT` |
| Meteoassault       | FIGHTING | Physical | 150 | 100 |  5 | `EFFECT_HYPER_BEAM` |
| Cosmic Power       | PSYCHIC  | Status   |   0 | 100 | 20 | `EFFECT_COSMIC_POWER` |
| Strength Sap       | GRASS    | Status   |   0 | 100 | 10 | `EFFECT_ATTACK_DOWN_2` |
| Hammer Arm         | FIGHTING | Physical | 100 |  90 | 10 | `EFFECT_HAMMER_ARM` |
| Superpower         | FIGHTING | Physical | 120 | 100 |  5 | `EFFECT_SUPERPOWER` |
| Poweruppunch       | FIGHTING | Physical |  40 | 100 | 20 | `EFFECT_ATTACK_UP_HIT` |
| Brick Break        | FIGHTING | Physical |  75 | 100 | 15 | `EFFECT_NORMAL_HIT` |
| Quiver Dance       | BUG      | Status   |   0 | 100 | 20 | `EFFECT_QUIVER_DANCE` |
| Acid Spray         | POISON   | Special  |  40 | 100 | 20 | `EFFECT_SP_DEF_DOWN_2_HIT` |
| Play Nice          | NORMAL   | Status   |   0 | 100 | 20 | `EFFECT_ATTACK_DOWN` |
| Circle Throw       | FIGHTING | Physical |  60 |  90 | 10 | `EFFECT_CIRCLE_THROW` |
| Bounce             | FLYING   | Physical | 100 |  85 |  5 | `EFFECT_FLY` |
| Charge Beam        | ELECTRIC | Special  |  50 |  90 | 10 | `EFFECT_SP_ATK_UP_HIT` |
| Dragon Tail        | DRAGON   | Physical |  60 |  90 | 10 | `EFFECT_CIRCLE_THROW` |
| Grass Knot         | GRASS    | Special  |  60 | 100 | 20 | `EFFECT_NORMAL_HIT` |
| Work Up            | NORMAL   | Status   |   0 | 100 | 30 | `EFFECT_WORK_UP` |
| Flatter            | DARK     | Status   |   0 | 100 | 15 | `EFFECT_SWAGGER` |
| Aqua Ring          | WATER    | Status   |   0 | 100 | 20 | `EFFECT_HEAL` |
| Coil               | POISON   | Status   |   0 | 100 | 20 | `EFFECT_COIL` |
| Psycho Boost       | PSYCHIC  | Special  | 140 |  90 |  5 | `EFFECT_PSYCHO_BOOST` |
| Eerie Spell        | PSYCHIC  | Special  |  80 | 100 |  5 | `EFFECT_NORMAL_HIT` |
| Clear Smog         | POISON   | Special  |  50 | 100 | 15 | `EFFECT_CLEAR_SMOG` |
| Raging Bull        | NORMAL   | Physical |  90 | 100 | 10 | `EFFECT_NORMAL_HIT` |
| Dire Claw          | POISON   | Physical |  80 | 100 | 15 | `EFFECT_POISON_HIT` |
| Phantomforce       | GHOST    | Physical | 120 | 100 | 10 | `EFFECT_FLY` |
| Sacred Sword       | FIGHTING | Physical |  90 | 100 | 15 | `EFFECT_NORMAL_HIT` |
| Chip Away          | NORMAL   | Physical |  70 | 100 | 20 | `EFFECT_NORMAL_HIT` |
| Overheat           | FIRE     | Special  | 130 |  90 |  5 | `EFFECT_DRACO_METEOR` |
| Leaf Storm         | GRASS    | Special  | 130 |  90 |  5 | `EFFECT_DRACO_METEOR` |
| Flip Turn          | WATER    | Physical |  60 | 100 | 20 | `EFFECT_U_TURN` |
| Scale Shot         | DRAGON   | Physical |  25 |  90 | 20 | `EFFECT_MULTI_HIT` |
| Stealth Rock       | ROCK     | Status   |   0 | 100 | 20 | `EFFECT_STEALTH_ROCK` |
| Defog              | FLYING   | Status   |   0 | 100 | 15 | `EFFECT_DEFOG` |
| Body Press         | FIGHTING | Physical |  80 | 100 | 10 | `EFFECT_BODY_PRESS` |
| Freeze Dry         | ICE      | Special  |  70 | 100 | 20 | `EFFECT_FREEZE_DRY` |
| Foul Play          | DARK     | Physical |  95 | 100 | 15 | `EFFECT_FOUL_PLAY` |
| Sticky Web         | BUG      | Status   |   0 | 100 | 20 | `EFFECT_STICKY_WEB` |
| Dragon Darts       | DRAGON   | Physical |  50 | 100 | 10 | `EFFECT_DOUBLE_HIT` |
| Glaive Rush        | DRAGON   | Physical | 120 | 100 |  5 | `EFFECT_NORMAL_HIT` |
| Baneful Bunker     | POISON   | Status   |   0 | 100 | 10 | `EFFECT_PROTECT` |
| Rage Fist          | GHOST    | Physical |  90 | 100 | 10 | `EFFECT_NORMAL_HIT` |
| Armor Cannon       | FIRE     | Special  | 120 | 100 |  5 | `EFFECT_CLOSE_COMBAT` |
| Fiery Dance        | FIRE     | Special  |  80 | 100 | 10 | `EFFECT_SP_ATK_UP_HIT` |
| Kowtow Cleave      | DARK     | Physical |  85 | 100 | 10 | `EFFECT_ALWAYS_HIT` |
| Infernal Parade    | GHOST    | Special  |  60 | 100 | 15 | `EFFECT_HEX` |
| Barb Barrage       | POISON   | Physical |  60 | 100 | 10 | `EFFECT_POISON_HIT` |
| Stone Axe          | ROCK     | Physical |  65 |  90 | 15 | `EFFECT_NORMAL_HIT` |
| Apple Acid         | GRASS    | Special  |  80 | 100 | 10 | `EFFECT_SP_DEF_DOWN_HIT` |
| Grav Apple         | GRASS    | Physical |  80 | 100 | 10 | `EFFECT_DEFENSE_DOWN_HIT` |
| Fickle Beam        | DRAGON   | Special  |  80 | 100 |  5 | `EFFECT_NORMAL_HIT` |
| Heat Wave          | FIRE     | Special  |  95 |  90 | 10 | `EFFECT_BURN_HIT` |
| Petal Blizz        | GRASS    | Physical |  90 | 100 | 15 | `EFFECT_NORMAL_HIT` |
| Snarl              | DARK     | Special  |  55 |  95 | 15 | `EFFECT_SP_ATK_DOWN_HIT` |
| Air Cutter         | FLYING   | Special  |  60 |  95 | 25 | `EFFECT_NORMAL_HIT` |
| Dazzlingleam       | FAIRY    | Special  |  80 | 100 | 10 | `EFFECT_NORMAL_HIT` |
| Disarm Voice       | FAIRY    | Special  |  40 | 100 | 15 | `EFFECT_ALWAYS_HIT` |
