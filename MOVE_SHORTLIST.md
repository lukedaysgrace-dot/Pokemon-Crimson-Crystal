# Move Expansion — FINAL LIST (61 moves)

Locked in. Hi Horsepower dropped. No weight-based moves. Six D-tier picks pulled up.

**Already in your game under a different name — do NOT add:**
`DAZZLINGLEAM` → `DAZZLING_GLEAM` · `DISARM_VOICE` → `DISARMING_VOICE` · `DRAININGKISS` → `DRAINING_KISS`

---

## Summary of work

| | Count | New effect code? |
|---|---|---|
| Group A — core | 17 | No |
| Group A — coverage/speed control | 9 | No |
| Group B — signature | 12 | No |
| Group B2 — signature | 4 | No |
| Group B3 — signature (flavor) | 4 | No |
| Group C — structural | 6 | **Yes — 6 effects** |
| Group C2 — signature | 3 | **Yes — 3 effects** |
| D-tier picks | 6 | **Yes — 3 effects** |
| **Total** | **61** | **12 new effects** |

**49 of 61 are pure data entry.** Only 12 need engine work.

---

## The `move` lines — paste-ready, in order

Append to `Moves1:` in `data/moves/moves.asm`, and add the matching `const` to
`constants/move_constants.asm` **in the exact same order**.

### Group A — core (17)

```
	move EFFECT_DRACO_METEOR, 130, FIRE, CATEGORIZE_SPECIAL, 90, 5, 100;OVERHEAT
	move EFFECT_DRACO_METEOR, 130, GRASS, CATEGORIZE_SPECIAL, 90, 5, 100;LEAF_STORM
	move EFFECT_FAKE_OUT, 40, NORMAL, CATEGORIZE_PHYSICAL, 100, 10, 100;FAKE_OUT
	move EFFECT_U_TURN, 60, WATER, CATEGORIZE_PHYSICAL, 100, 20, 0;FLIP_TURN
	move EFFECT_DEFENSE_UP_2, 0, STEEL, CATEGORIZE_STATUS, 100, 15, 0;IRON_DEFENSE
	move EFFECT_SPEED_UP_2, 0, ROCK, CATEGORIZE_STATUS, 100, 20, 0;ROCK_POLISH
	move EFFECT_RECOIL_HIT, 120, GRASS, CATEGORIZE_PHYSICAL, 100, 15, 0;WOOD_HAMMER
	move EFFECT_RECOIL_HIT, 150, ROCK, CATEGORIZE_PHYSICAL, 90, 5, 0;HEAD_SMASH
	move EFFECT_NORMAL_HIT, 80, GROUND, CATEGORIZE_PHYSICAL, 95, 10, 0;DRILL_RUN
	move EFFECT_NORMAL_HIT, 70, PSYCHIC, CATEGORIZE_PHYSICAL, 100, 20, 0;PSYCHO_CUT
	move EFFECT_NORMAL_HIT, 90, FIGHTING, CATEGORIZE_PHYSICAL, 100, 15, 0;SACRED_SWORD
	move EFFECT_NORMAL_HIT, 75, FIGHTING, CATEGORIZE_PHYSICAL, 100, 15, 0;BRICK_BREAK
	move EFFECT_BURN_HIT, 95, FIRE, CATEGORIZE_SPECIAL, 90, 10, 10;HEAT_WAVE
	move EFFECT_SP_ATK_DOWN_HIT, 55, DARK, CATEGORIZE_SPECIAL, 95, 15, 100;SNARL
	move EFFECT_PARALYZE_HIT, 20, ELECTRIC, CATEGORIZE_PHYSICAL, 100, 20, 100;NUZZLE
	move EFFECT_MULTI_HIT, 25, GRASS, CATEGORIZE_PHYSICAL, 100, 30, 0;BULLET_SEED
	move EFFECT_DOUBLE_HIT, 40, FLYING, CATEGORIZE_PHYSICAL, 90, 10, 0;DUALWINGBEAT
```

### Group A — coverage & speed control (9)

```
	move EFFECT_SPEED_DOWN_HIT, 60, ROCK, CATEGORIZE_PHYSICAL, 95, 15, 100;ROCK_TOMB
	move EFFECT_SPEED_DOWN_HIT, 65, FIGHTING, CATEGORIZE_PHYSICAL, 100, 20, 100;LOW_SWEEP
	move EFFECT_SPEED_DOWN_HIT, 55, GROUND, CATEGORIZE_SPECIAL, 95, 15, 100;MUD_SHOT
	move EFFECT_NORMAL_HIT, 60, FLYING, CATEGORIZE_SPECIAL, 95, 25, 0;AIR_CUTTER
	move EFFECT_POISON_HIT, 70, POISON, CATEGORIZE_PHYSICAL, 100, 20, 10;CROSS_POISON
	move EFFECT_ALWAYS_HIT, 60, GRASS, CATEGORIZE_SPECIAL, 100, 20, 0;MAGICAL_LEAF
	move EFFECT_CONFUSE_HIT, 75, BUG, CATEGORIZE_SPECIAL, 100, 15, 10;SIGNAL_BEAM
	move EFFECT_MULTI_HIT, 25, DRAGON, CATEGORIZE_PHYSICAL, 90, 20, 0;SCALE_SHOT
	move EFFECT_FLY, 120, GHOST, CATEGORIZE_PHYSICAL, 100, 10, 0;PHANTOMFORCE
```

### Group B — signature (12)

```
	move EFFECT_CLOSE_COMBAT, 120, GROUND, CATEGORIZE_PHYSICAL, 100, 5, 100;HEADLONGRUSH
	move EFFECT_DEFENSE_DOWN_HIT, 85, GHOST, CATEGORIZE_PHYSICAL, 100, 10, 20;SHADOW_BONE
	move EFFECT_POISON_HIT, 80, POISON, CATEGORIZE_PHYSICAL, 100, 15, 50;DIRE_CLAW
	move EFFECT_POISON_HIT, 60, POISON, CATEGORIZE_PHYSICAL, 100, 10, 50;BARB_BARRAGE
	move EFFECT_HEX, 60, GHOST, CATEGORIZE_SPECIAL, 100, 15, 30;INFERNAL_PARADE
	move EFFECT_ALWAYS_HIT, 85, DARK, CATEGORIZE_PHYSICAL, 100, 10, 0;KOWTOW_CLEAVE
	move EFFECT_CLOSE_COMBAT, 120, FIRE, CATEGORIZE_SPECIAL, 100, 5, 100;ARMOR_CANNON
	move EFFECT_POISON_HIT, 90, POISON, CATEGORIZE_SPECIAL, 100, 10, 20;SHELLSIDEARM
	move EFFECT_NORMAL_HIT, 120, DRAGON, CATEGORIZE_PHYSICAL, 100, 5, 0;GLAIVE_RUSH
	move EFFECT_DOUBLE_HIT, 50, DRAGON, CATEGORIZE_PHYSICAL, 100, 10, 0;DRAGON_DARTS
	move EFFECT_SP_DEF_DOWN_HIT, 80, GRASS, CATEGORIZE_SPECIAL, 100, 10, 100;APPLE_ACID
	move EFFECT_DEFENSE_DOWN_HIT, 80, GRASS, CATEGORIZE_PHYSICAL, 100, 10, 100;GRAV_APPLE
```

Owners: Ursaluna / Ursaluna-BM · Marowak-A · Sneasler · Overqwil · Typhlosion-H · Kingambit ·
Armarouge · Slowbro-G · Baxcalibur · Dragapult · Dipplin, Appletun, Flapple, Hydrapple

### Group B2 — signature (4)

```
	move EFFECT_DEFENSE_UP_HIT, 70, PSYCHIC, CATEGORIZE_PHYSICAL, 90, 10, 100;PSYSHIELD
	move EFFECT_RAMPAGE, 120, FIRE, CATEGORIZE_PHYSICAL, 100, 10, 0;RAGING_FURY
	move EFFECT_CONFUSE_HIT, 90, FAIRY, CATEGORIZE_SPECIAL, 95, 10, 20;STRANGESTEAM
	move EFFECT_NORMAL_HIT, 80, PSYCHIC, CATEGORIZE_SPECIAL, 100, 5, 0;EERIE_SPELL
```

Owners: Wyrdeer · Arcanine-Hisuian · Weezing-Galarian · Slowking-Galarian

### Group B3 — signature, flavor-accurate but mechanically simplified (4)

```
	move EFFECT_PROTECT, 0, POISON, CATEGORIZE_STATUS, 100, 10, 0;BANEFUL_BUNKER
	move EFFECT_NORMAL_HIT, 90, NORMAL, CATEGORIZE_PHYSICAL, 100, 10, 0;RAGING_BULL
	move EFFECT_NORMAL_HIT, 80, DRAGON, CATEGORIZE_SPECIAL, 100, 5, 0;FICKLE_BEAM
	move EFFECT_NORMAL_HIT, 65, ROCK, CATEGORIZE_PHYSICAL, 90, 15, 0;STONE_AXE
```

Owners: Toxapex · Tauros-Paldean Fire/Water · Applin line + Hydrapple · Kleavor

> **Stone Axe:** once `EFFECT_STEALTH_ROCK` exists (Group C), give Stone Axe a
> set-hazard-on-hit variant instead of leaving it a plain 65 BP. That's the whole move.

### Group C — structural, needs new effects (6)

```
	move EFFECT_QUIVER_DANCE, 0, BUG, CATEGORIZE_STATUS, 100, 20, 0;QUIVER_DANCE
	move EFFECT_STEALTH_ROCK, 0, ROCK, CATEGORIZE_STATUS, 100, 20, 0;STEALTH_ROCK
	move EFFECT_DEFOG, 0, FLYING, CATEGORIZE_STATUS, 100, 15, 0;DEFOG
	move EFFECT_BODY_PRESS, 80, FIGHTING, CATEGORIZE_PHYSICAL, 100, 10, 0;BODY_PRESS
	move EFFECT_WORK_UP, 0, NORMAL, CATEGORIZE_STATUS, 100, 30, 0;WORK_UP
	move EFFECT_SUPERPOWER, 120, FIGHTING, CATEGORIZE_PHYSICAL, 100, 5, 100;SUPERPOWER
```

### Group C2 — signature, needs new effects (3)

```
	move EFFECT_SP_ATK_UP_HIT, 80, FIRE, CATEGORIZE_SPECIAL, 100, 10, 50;FIERY_DANCE
	move EFFECT_FOUL_PLAY, 95, DARK, CATEGORIZE_PHYSICAL, 100, 15, 0;FOUL_PLAY
	move EFFECT_RAGE_FIST, 90, GHOST, CATEGORIZE_PHYSICAL, 100, 10, 0;RAGE_FIST
```

Owners: Volcarona · Umbreon, Grimmsnarl · Annihilape

### D-tier picks (6)

```
	move EFFECT_DEFENSE_DOWN_HIT, 75, NORMAL, CATEGORIZE_PHYSICAL, 95, 10, 50;CRUSH_CLAW
	move EFFECT_PARALYZE_HIT, 60, FIGHTING, CATEGORIZE_PHYSICAL, 100, 10, 30;FORCE_PALM
	move EFFECT_HAMMER_ARM, 100, FIGHTING, CATEGORIZE_PHYSICAL, 90, 10, 100;HAMMER_ARM
	move EFFECT_CIRCLE_THROW, 60, FIGHTING, CATEGORIZE_PHYSICAL, 90, 10, 0;CIRCLE_THROW
	move EFFECT_FREEZE_DRY, 70, ICE, CATEGORIZE_SPECIAL, 100, 20, 10;FREEZE_DRY
	move EFFECT_FLY, 100, FLYING, CATEGORIZE_PHYSICAL, 85, 5, 30;BOUNCE
```

> **Free rider:** once `EFFECT_CIRCLE_THROW` (phazing damage) is written, `DRAGON_TAIL`
> costs one more data row —
> `move EFFECT_CIRCLE_THROW, 60, DRAGON, CATEGORIZE_PHYSICAL, 90, 10, 0;DRAGON_TAIL`.
> Strongly recommended; Dragon Tail has far better distribution than Circle Throw.

---

## New effects to write (12)

Add to `constants/move_effect_constants.asm` + `data/moves/effects_pointers.asm` + `data/moves/effects.asm`.
Ordered easiest → hardest.

| # | Effect | Implementation |
|---|---|---|
| 1 | `EFFECT_WORK_UP` | Atk +1, SpA +1. Chain two existing stat-up calls. Trivial. |
| 2 | `EFFECT_SP_ATK_UP_HIT` | Direct mirror of `EFFECT_ATTACK_UP_HIT` — copy it, swap the stat index. Unlocks Fiery Dance **and** Charge Beam. |
| 3 | `EFFECT_QUIVER_DANCE` | SpA +1, SpD +1, Spe +1. Same pattern as Work Up, three stats. |
| 4 | `EFFECT_SUPERPOWER` | Damage, then self Atk −1 / Def −1. Model on `EFFECT_CLOSE_COMBAT`. |
| 5 | `EFFECT_HAMMER_ARM` | Damage, then self Spe −1. Same shape as above. |
| 6 | `EFFECT_BODY_PRESS` | In damage calc, substitute the user's Defense for Attack. One-branch change. |
| 7 | `EFFECT_FOUL_PLAY` | In damage calc, read the **target's** Attack. Same branch point as Body Press — do these two together. |
| 8 | `EFFECT_FREEZE_DRY` | Type-effectiveness override: force super-effective vs Water before the normal chart lookup. |
| 9 | `EFFECT_CIRCLE_THROW` | Damage, then force switch. Reuse Whirlwind/Roar's switch routine, gated on the target not being a trapper/Suction Cups. |
| 10 | `EFFECT_RAGE_FIST` | Needs a WRAM byte per battler counting hits taken; power = 50 + 50×hits, cap 350. Reset on switch. |
| 11 | `EFFECT_STEALTH_ROCK` | Model on `EFFECT_SPIKES` (already built and tested). Adds a type-chart lookup vs Rock on switch-in for the damage fraction. |
| 12 | `EFFECT_DEFOG` | Clears hazards **both** sides + screens + target evasion −1. Needs to touch every hazard/screen timer you have. Do this last, after Stealth Rock. |

**Suggested order:** 1–5 in one sitting (all stat-stage chains), then 6+7 together (shared calc
branch), then 8–10, then 11+12 together (hazard pair).

---

## Flag tables to update

| Table | Add |
|---|---|
| `critical_hit_moves.asm` | DRILL_RUN, PSYCHO_CUT, AIR_CUTTER, CROSS_POISON, STONE_AXE |
| `contact_moves.asm` | all physical entries except DRILL_RUN\*, plus BODY_PRESS, RAGE_FIST, HAMMER_ARM, CIRCLE_THROW, CRUSH_CLAW, FORCE_PALM, BOUNCE |
| `punching_moves.asm` | HAMMER_ARM, RAGE_FIST |
| `sound_moves.asm` | SNARL, EERIE_SPELL |
| `substitute_moves.asm` | SNARL, EERIE_SPELL (sound bypasses Substitute) |
| `data/abilities/sheer_force_moves.asm` | every entry with a nonzero effect chance |
| `metronome_exception_moves.asm` | STEALTH_ROCK, DEFOG, RAGE_FIST |
| `data/battle/ai/useful_moves.asm` | STEALTH_ROCK, DEFOG, QUIVER_DANCE, IRON_DEFENSE, BODY_PRESS, WORK_UP, ROCK_POLISH |
| `data/battle/ai/residual_moves.asm` | STEALTH_ROCK |
| `data/battle/ai/encore_moves.asm` | QUIVER_DANCE, WORK_UP, IRON_DEFENSE, ROCK_POLISH |

\* Drill Run is contact in canon — include it; the asterisk is only a reminder to double-check
your table's existing convention for drill/horn moves.

---

## Animations

Per the earlier audit, **Crimson Crystal's `gfx/battle_anims/` is a strict superset of Johto
Legends'** — no new artwork needed for anything on this list. For each ported
`BattleAnim_<Name>` block, verify its `ANIM_OBJ_*` / `ANIM_GFX_*` constants exist in
`constants/battle_anim_constants.asm` and add them plus the object-table entry if missing.

Confirmed present in JL: BrickBreak, Nuzzle, SacredSword, Psyshield, HeadSmash, HeadlongRush,
DrillRun, IronDefense, RockPolish, ShadowBone, WoodHammer, PhantomForce (+2 branch labels),
FakeOut, QuiverDance, BulletSeed, Superpower, CrossPoison, DireClaw, PsychoCut, Snarl.

Needs a reskin: Overheat & Leaf Storm (Draco Meteor), Flip Turn (your `uturn.png`),
Body Press (Superpower/Brick Break), Stealth Rock (Spikes + `rocks.png`), Defog (Gust),
Freeze-Dry (Ice Beam), Foul Play (Faint Attack), Rage Fist (Shadow Punch),
Circle Throw (Vital Throw), Bounce (Fly), Scale Shot (Pin Missile).
