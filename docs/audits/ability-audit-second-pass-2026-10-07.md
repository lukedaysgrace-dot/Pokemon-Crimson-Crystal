# Ability system — second-pass audit and repairs (2026-10-07)

This pass re-read the whole ability engine (`engine/battle/abilities_engine.asm`)
and every battle routine that calls into it (`effect_commands*.asm`,
`core.asm`, `move_effects/`, the trainer AI), diffed the move-class data
against Pokémon Showdown (`data/moves.ts`, `data/abilities.ts`,
`sim/battle-actions.ts`, `sim/pokemon.ts`), and reproduced every suspected
defect in the debug ROM before changing code. Intentional Crimson Crystal
rules were kept (see "Intentional rules preserved").

## Summary

| | Count |
| --- | ---: |
| Abilities audited | 171 / 171 |
| Abilities with a confirmed defect, now fixed | 26 |
| Abilities verified correct (no defect found) | 139 |
| Abilities with a flagged design question (unchanged) | 6 |
| Confirmed bugs found / fixed | 17 / 17 |
| New permanent regression cases (`tests/78-ability-audit-2026-10-07.yaml`) | 71 |

Every fix has a reproduction case that **fails on the original ROM and passes
on the fixed ROM** (verified by building the pre-fix commit in a separate
worktree: 42 fix cases fail there, all controls pass on both).

## Confirmed bugs and fixes

Severity: CRITICAL (crash/corruption), HIGH (ability substantially wrong),
MEDIUM (important interaction wrong), LOW (edge case / data / cosmetic).

### B1 — Technician boosted moves whose real base power exceeds 60 (HIGH)
- **Abilities / moves:** Technician; Return, Frustration, Present, Magnitude,
  Flail, Reversal, Gyro Ball, Rage Fist, Fury Cutter, Rollout, Acrobatics,
  Avalanche, Infernal Parade, Pursuit.
- **Files / routines:** `abilities_engine.asm` `RunDamageModifiers.technician`,
  new `TechnicianBoostsCurrentHit`, `RecordDamageCalcPower_Core`;
  `effect_commands.asm` `BattleCommand_DamageCalc`; `wram.asm`.
- **Current:** Technician read the move struct's power. Variable-power moves
  compute their power in register `d` and leave the placeholder `1` in the
  struct (Flail/Reversal even reset it to 1), so Technician always applied —
  e.g. 1.5× on a 102-power Return. Moves that double damage *after* `stab`
  (Fury Cutter, Rollout, Acrobatics, Avalanche, Hex/Infernal Parade, Pursuit)
  were boosted even when doubled past 60.
- **Correct:** Technician multiplies base power ≤ 60 after base-power changes.
- **Root cause:** threshold read the wrong value at the wrong stage.
- **Repro:** Ambipom (Technician) at max friendship uses Return → 76 damage
  instead of the control's 51.
- **Change:** `damagecalc` records the power it actually uses in
  `wDamageCalcBasePower` (WRAM bank 2). Technician compares that value, first
  applying the doublings the move's own command will apply after `stab`
  (Fury Cutter count incl. Parental Bond, Rollout count + Defense Curl and
  sleep, Acrobatics item, Avalanche hit, Hex/Infernal Parade status, Pursuit
  switch). A dedicated byte (not the struct) keeps Rage Fist from double-
  counting on Parental Bond's second hit.
- **Why it works / side effects:** the AI's prediction also runs `damagecalc`,
  so it now sees the same Technician result. No other reader of move power
  changed.
- **Tests:** Return 102/40, Magnitude 90, Present 120, Flail 200/20,
  Acrobatics 110, Fury Cutter 1st/3rd use, each against a no-ability control.

### B2 — Absorb/immunity abilities reacted through Protect and against Fly/Dig users (HIGH)
- **Abilities:** Volt Absorb, Water Absorb, Dry Skin, Lightning Rod, Storm
  Drain, Motor Drive, Flash Fire, Sap Sipper, Levitate, Soundproof,
  Bulletproof, Wind Rider, Disguise (and Air Balloon).
- **Files / routines:** `abilities_engine.asm` `RunNullificationAbilities`,
  `AbilityAccuracyMods.status_class_block`, new
  `TargetEvadesTryHitAbilities`.
- **Current:** `stab` (where these hooks live) runs before `checkhit`
  (Protect, Fly/Dig). A Protecting Volt Absorb holder healed, a Protecting
  Lightning Rod holder gained +1 Sp. Atk, Flash Fire activated, Sap Sipper
  absorbed Spore, and a Volt Absorb holder mid-Fly healed from Thunderbolt;
  then "protecting itself!" / the miss was printed as well.
- **Correct (Gen V+ hit steps):** semi-invulnerability first, then TryHit with
  Protect (priority 3) before the absorbing abilities; accuracy comes later
  (so absorbing a move that would have missed is still correct).
- **Change:** the live (non-AI-prediction) hooks first ask
  `TargetEvadesTryHitAbilities` — side-effect-free: Protect with checkhit's
  bypasses (status Roar/Whirlwind, Phantom Force), semi-invulnerability with
  Lock-On and No Guard — and skip all absorbs/banners when the target is out
  of reach; `checkhit` then reports the miss as before.
- **Tests:** Protect vs Thunderbolt/Thunder Wave (Volt Absorb), Lightning Rod,
  Flash Fire, Sap Sipper; Fly vs Volt Absorb; Dig vs Water Absorb; Levitate
  banner; controls for unprotected absorb and absorb-before-accuracy.

### B3 — No Guard didn't reach semi-invulnerable targets (MEDIUM)
- **Ability:** No Guard (either side). **Files:** `effect_commands.asm`
  `BattleCommand_CheckHit.FlyDigMoves`, `CheckHiddenOpponent`;
  `abilities_engine.asm` new `SemiInvulnerableMiss_Core`, `NoGuardOnField_Core`.
- **Current:** checkhit's Fly/Dig miss ran before the No Guard always-hit, so
  No Guard never hit a Fly/Dig/Bounce/Phantom Force user; stat drops and
  status moves gated by `CheckHiddenOpponent` also failed.
- **Correct:** No Guard on either side hits semi-invulnerable targets and
  their secondary effects apply.
- **Change:** one shared reachability routine (move lists moved out of
  checkhit, so stab-time hooks and checkhit can't drift apart) that honours
  No Guard; `CheckHiddenOpponent` honours it too.
- **Tests:** No Guard attacker vs Fly and Dig, No Guard Fly user hit, Rock
  Smash's Defense drop on a Fly user; control: ordinary attack still misses.

### B4 — Baton Pass skipped Regenerator and Natural Cure (MEDIUM)
- **Files:** `move_effects/baton_pass.asm`.
- **Current:** both sides' Baton Pass switched without switch-out abilities
  (every other switch path ran them).
- **Correct:** any switch-out triggers them.
- **Change:** player path records `wLastPlayerMon` and farcalls
  `RunPlayerSwitchOutAbilities` after the party sync; enemy path farcalls
  `RunEnemySwitchOutAbilities` (the following switch code doesn't re-sync the
  outgoing mon, so the heal/cure sticks).
- **Tests:** Regenerator (player, enemy) and Natural Cure via Baton Pass.

### B5 — Transform/Imposter never started the copied ability (MEDIUM)
- **Files:** `move_effects/transform.asm`; `abilities_engine.asm`
  `TransformCopyAbility`, new `TransformedAbilityStart`; `wram.asm`.
- **Current:** the ability was copied silently; Intimidate, Drizzle, Download,
  Trace, Frisk, … never activated.
- **Correct:** Showdown's `setAbility(..., isTransform)` fires the ability's
  Start when it changed (Imposter itself is a switch-in-only trigger).
- **Change:** `TransformCopyAbility` marks a pending start only when the
  ability actually changes; after the transformation is shown the entry
  table runs for it (not for Imposter), and the Transform move then updates
  HP items (Imposter's own entry processing already does).
- **Tests:** Transform into Intimidate and Drizzle, Imposter into Intimidate,
  and "already had the ability" (no restart). The generated Transform matrix
  (`ability_matrix.py`) now expects the copied weather to start.

### B6 — A Transform user got a working Disguise (LOW)
- **Files:** `data/abilities/flags.asm` (Disguise `$1f` → `$3f`).
- **Correct:** Disguise is `notransform`; it can't work while transformed.
- **Change:** Disguise gains `ABILFLAG_NO_TRANSFORM`; the user keeps its own
  ability (the generated Transform matrix derives its expectation from this
  table).

### B7 — Pressure PP exemptions disagreed with modern targets (LOW)
- **Files:** `abilities_engine.asm` `OpponentHasPressure`,
  `PressureExemptEffects`.
- **Current:** weather moves and Trick Room were exempt; Sticky Web, Bide and a
  non-Ghost Curse cost the extra PP.
- **Correct (Showdown `getMoveTargets` pressureTargets):** field-wide moves
  (`all`) and forced-Pressure hazards cost extra; self/ally-side moves and
  Sticky Web (`foeSide` without `mustpressure`) don't; Curse only when used by
  a Ghost type.
- **Change:** list derived per effect from Showdown targets; Curse checks the
  user's typing. Conversion 2 stays exempt: this game keeps its Gen II–IV
  self-targeting implementation (and an earlier audit pinned that).
- **Tests:** Rain Dance, Trick Room, Spikes, Sticky Web, Curse (non-Ghost and
  Ghost) PP costs.

### B8 — AI dismissed every attack against an intact Disguise (MEDIUM, AI)
- **Files:** `ai/scoring.asm` `AI_Abilities`.
- **Current:** the predicted damage is 0, so damaging moves got +30 as if
  nullified; the AI preferred any status move (even Splash).
- **Change:** a zero prediction with a non-zero effectiveness (Disguise's
  marker) is not treated as a nullification.

### B9 — AI fed status moves to blocking/absorbing abilities (MEDIUM, AI)
- **Files:** `ai/scoring.asm` `AI_Abilities`; `abilities_engine.asm` new
  `AIScoredMoveFails_Core`, `AIFoeTargetedStatusEffects`.
- **Current:** no layer modelled Thunder Wave into Volt Absorb/Lightning
  Rod/Motor Drive (boosting the player), sound moves into Soundproof, powder
  into Grass/Overcoat, Whirlwind into Wind Rider, the AI's own Prankster status
  moves into Dark types, or priority moves into Armor Tail/Queenly Majesty.
- **Change:** a routine mirroring the live targeting checks (respecting Mold
  Breaker and Neutralizing Gas) dismisses moves that will certainly fail.
- **Tests:** Thunder Wave vs Lightning Rod, Sing vs Soundproof, Quick Attack
  vs Armor Tail, each with a control that picks the move.

### B10 — Unaware didn't ignore the attacker's accuracy stages (LOW)
- **Files:** `effect_commands.asm` checkhit `.StatModifiers`;
  `abilities_engine.asm` new `DefenderUnawareAccuracy_Core`.
- **Correct:** Unaware zeroes the attacker's accuracy boosts (both
  directions); Mold Breaker ignores Unaware.
- **Tests:** +6 and −6 accuracy against Unaware, Mold Breaker control.

### B11 — Weak Armor's own Mist stopped its self-inflicted Defense drop (LOW)
- **Files:** `abilities_engine.asm` `.weak_armor`, new
  `AbilityLowerOppStatSelfInflicted`.
- **Correct:** Mist only blocks drops from another source (source == target
  for Weak Armor).

### B12 — Oblivious didn't end Taunt (LOW)
- **Files:** `abilities_engine.asm` `ObliviousAbility`.
- **Correct (Gen VI+):** Oblivious also cures Taunt (Mold Breaker's Taunt,
  Oblivious gained by Skill Swap/Trace). It already blocked Taunt.

### B13 — Survival effects triggered on hits a Substitute absorbed (MEDIUM)
- **Abilities / items:** Sturdy (banner), Focus Sash (consumed), Endure,
  Focus Band. **Files:** `effect_commands_core.asm`
  `EndureFocusSashInEffect_Core`.
- **Current:** a full-HP holder behind a Substitute (Baton-Passed, or healed
  back to full) lost its Focus Sash / showed Sturdy for a hit the Substitute
  took.
- **Change:** skip survival effects when the hit lands on the Substitute
  (Infiltrator/sound moves still reach the holder — control included).

### B14–B17 — Move-class data (LOW)
- **B14:** Giga Hammer (Gen IX Gigaton Hammer) was flagged as contact
  (`data/moves/contact_moves.asm`); it makes no contact. Affects Tough Claws,
  Fluffy, Iron Barbs, Static, Rocky Helmet, … `tools/audit_moves.py`'s spot
  check updated. *If contact was a deliberate custom choice, revert this one
  bit and the audit line.*
- **B15:** Headlong Rush (a punching move) was missing from Iron Fist's list.
- **B16:** Slack Off and Wish (heal flag) were missing from Triage's list.
- **B17:** Slush Rush granted hail immunity; only Sand Rush has a weather
  immunity (all current holders are Ice types, so this mattered only for a
  transferred ability).

All move-class lists were diffed against Showdown flags: contact, punch,
slicing, pulse, sound, bullet, wind, powder, bite and heal now match for
every non-custom move in the game (Pixie Punch is custom; Sandstorm's wind
flag and Heal Bell's sound flag have no ability effect here).

## Order-of-operations reconstruction (as implemented)

`checkobedience → usedmovetext → doturn (PP, Pressure, pre-execution
targeting block) → critical → damagestats → damagecalc → stab (weather → crit
1.5× → STAB → type chart → [reachability] → powder/Air Balloon/absorb/immunity
abilities → item/ability damage modifiers) → damagevariation → checkhit
(priority blockers/Prankster/powder/status-class blocks → Protect → Lock-On →
semi-invulnerability → accuracy stages → accuracy abilities) → animation →
applydamage (Substitute → Endure/Sturdy/Sash/Band) → checkfaint (contact and
on-hit abilities, held items, recoil, Moxie, berries) → secondary effects →
endmove (Berserk, status-heal abilities, faint/Gas updates)`. The bracketed
reachability gate (B2) is the only reordering this pass needed; damage
modifiers remain final-damage multipliers, which match the modern stat/base
power multipliers within rounding.

## Verified correct (highlights)

Crit 1.5× and Sniper 2.25×; burn halving on crit/Unaware raw stats and Guts'
compensation; Facade; Analytic when the foe switches or uses an item;
Unaware's damage stat stages; Magic Guard against weather, poison, burn,
Leech Seed-style chip, Life Orb, recoil, crash, Rocky Helmet, Iron Barbs,
Aftermath, Bad Dreams, Spikes and Stealth Rock (Toxic Spikes and Sticky Web
still apply); Mirror Armor/Clear Body/Contrary/Defiant/Competitive chains;
Intimidate vs Substitute and Mist; Disguise vs fixed-damage moves; Skill Link
and Loaded Dice; Sturdy vs OHKO; Shield Dust and Serene Grace; trapping
abilities; Unburden; weather speed abilities; Early Bird; status prevention
and cures; Synchronize for move-inflicted status; all entry and end-of-turn
ability ordering; Mold Breaker scope (only the Mold Breaker user's own move).

## Intentional rules preserved

Filter/Solid Rock's 4× rule, older Gale Wings, custom Flash Fire (raises the
higher attacking stat), older Disguise damage, Mega Sol, frostbite, Poison
Puppeteer without a species check, the Gen II multi-hit distribution and
Hi Jump Kick crash, Conversion 2's older semantics, and Cud Chew's HP-Berry
scope.

## Flagged for a design decision (not changed)

1. **Cud Chew** replays only the two HP Berries (documented in code); modern
   Cud Chew re-eats any Berry.
2. **Synchronize** doesn't return statuses inflicted by contact abilities
   (Showdown does). Practically only Effect Spore holders can be affected.
3. **Keen Eye / Mind's Eye** ignore only raised evasion (documented intent);
   Showdown's `ignoreEvasion` also ignores lowered evasion.
4. **Neutralizing Gas** leaving: the foe's suppressed entry abilities fire
   after the replacement enters, so a returning Intimidate hits the
   replacement (Showdown resolves the end before the replacement arrives).
   Earlier passes built extensive lifecycle tests around the current order.
5. **Sheer Force + Mortal Spin** keeps the hazard clearing (Showdown removes
   it along with the poison). No current holder learns it.
6. **Sap Sipper vs powder on a Grass-type holder:** Grass immunity is checked
   first here (comment documents this); Showdown lets Sap Sipper absorb first.
7. Cosmetic: an Air Balloon holder that is also Flying-type prints the
   balloon message and "doesn't affect".

## Verification

- Both ROMs build with RGBDS 0.5.2; `git diff --check` is clean.
- All static audits pass (44,865 game-data invariants, 574 ability-text
  fragments, move audit, trainers, save layout, 4,670 resources, icons,
  sprites).
- Full permanent YAML suite before the AI changes: 1,318/1,318 passed; the
  new file: 71/71 passed on the final ROM; 42 fix cases fail on the pre-fix
  ROM as expected.
- Complete generated suite on the final ROM (the `make test-complete` runner
  invocation, 20,634 cases): 20,632 passed. The two failures were
  "Ability matrix: Transform versus SAND_STREAM / SNOW_WARNING", whose
  generated expectation predated B5: the copied weather now starts, so the
  Normal-type copy takes 1/16 chip damage, as in Showdown.
  `tools/battletest/ability_matrix.py` now expects that chip and asserts the
  weather for all four weather setters. With that change, all 171 Transform
  matrix cases pass.
- The rest of `make test-complete` on the final ROM, 0 failures each:
  probability (44,032 outcome checks), HP-item updates (352), UI (12
  scenarios), visual matrix (120 scenarios), Cove sprites (216), Tower
  rosters (23,299) and battles (104), link RNG (16,384 synchrony checks),
  gameplay session (8 battles, 179 checks), trainer UI (75), wild UI (21),
  save menu (23).

Release SHA-256 `07d4b754eb33034e425a21be0b873fd7cdcc729607221c940ae6146b579728e9`,
debug `d1d7c89799bf0ba5732691acd0679affdbd51085aa15916016717abee831f44b`.
