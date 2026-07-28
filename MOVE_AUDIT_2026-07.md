# Move Expansion Audit — July 2026

Audit of the 115 moves added in `acad5baa` ("ton of new moves") and `bc5caca6`
("fixing moves in progress"), plus the engine changes that shipped with them.

Everything under **Fixed** has been applied to the tree. `make` completes clean
and links to a 4 MB ROM with rgbds 0.5.2.

---

## 1. The tree did not build (fixed)

This is the headline finding. `rgbasm` was happy, but **`rgblink` failed with 14
errors** — six helper routines were called but never defined anywhere in the
project:

| Symbol | Called from |
|---|---|
| `BattleAlwaysHitChecks_Core` | `effect_commands.asm` — `BattleCommand_CheckHit.XAccuracy` |
| `BattleMoveBypassesSubstitute_Core` | `effect_commands.asm` — `DoEnemyDamage`, `DoPlayerDamage` |
| `BattleTrapTarget_Core` | `effect_commands.asm` — `BattleCommand_TrapTarget` |
| `CheckSubstituteOpp_Core` | `effect_commands.asm` — `CheckSubstituteOpp` |
| `HandleWrap_Core` | `core.asm` — `HandleWrap` |
| `BattleRecoil_Core` | `effect_commands.asm` — `BattleCommand_Recoil` |

Two distinct causes:

* **Five were never written.** `bc5caca6` replaced five inline bodies with
  `farcall`s to `*_Core` helpers — a bank-pressure refactor — but the commit
  ended before the helper bodies were authored.
* **One was deleted by accident.** `BattleRecoil_Core` had existed in
  `abilities_engine.asm` since `8d13299a`. In `bc5caca6` the new
  `.ApplySheerColdRules` helper was written *over* it rather than inserted
  beside it, so the whole 65-line body vanished. Recoil moves — Wood Hammer,
  Head Smash, Wave Crash, Double-Edge, Take Down, Submission, Volt Tackle —
  would not have worked even if the ROM had linked.

**Fixed by:** restoring `BattleRecoil_Core` verbatim from `8d13299a`, and
reverting the other five `farcall`s to the inline bodies they replaced (taken
verbatim from `acad5baa`). This puts the tree back on code that previously
shipped and worked, rather than on newly hand-written cross-bank assembly.

See §6 for the bank-pressure consequence of that choice.

---

## 2. Duplicate moves (fixed)

Three of the 115 "new" moves already existed in the base table with **byte-for-byte
identical stats**:

| New constant | Duplicate of | Move index |
|---|---|---|
| `DRAININGKISS` | `DRAINING_KISS` (`$ff`) | 358 |
| `DAZZLINGLEAM` | `DAZZLING_GLEAM` (`$fd`) | 465 |
| `DISARM_VOICE` | `DISARMING_VOICE` (`$fe`) | 466 |

The duplicates were not inert. `DAZZLINGLEAM` and `DISARM_VOICE` were the copies
actually distributed — seven level-up entries across
`evos_attacks_johto.asm` / `evos_attacks_kanto.asm` taught the duplicate, so the
originals at `$fd`/`$fe` were dead entries with real learnsets pointing past them.
`DISARM_VOICE` and `DISARMING_VOICE` were *both* in `SoundMoves`, and
`DRAININGKISS`/`DRAINING_KISS` were both in the Triage list.

The name table gave it away: index 254 read `DISARM VOICE` and index 466 read
`Disarm Voice`.

**Fixed by:** deleting the three constants and their rows from `move_constants.asm`,
`moves2.asm`, `names.asm`, `descriptions2.asm` and the `BattleAnimations` table;
repointing all seven learnset entries and the AI/ability list entries at the
original constants; and regenerating `contact_moves.asm` for the new indices.

Move count: **466 → 463.** All six parallel tables verified at 463 entries in
matching order.

---

## 2b. The animation table was misaligned (fixed)

Worse than the duplicates, and invisible at compile time.

`BattleAnimations` is indexed by move ID. Three entries in it are *not* moves —
`ANIM_SWEET_SCENT_2`, `ANIM_STAT_UP`, `ANIM_STAT_DOWN` — and their constants
continue the `const` run *after* `NUM_ATTACKS`, so they must sit at the very end
of the table. Back when the game had 351 moves they were correctly at rows
352–354.

When the 115 new moves were appended, those three rows were left where they
were and the new animations were added *after* them. Everything from move 352
onward was therefore shifted by three:

* Rock Tomb played Sweet Scent, Featherdance played the generic stat-up flash,
  Mirror Shot played the generic stat-down flash.
* Every other new move played the animation belonging to the move three slots
  earlier — Silver Wind played Rock Tomb, Dragon Rush played Featherdance, and
  so on down the list.
* **`ANIM_STAT_UP` and `ANIM_STAT_DOWN` resolved to 465 and 466**, which held
  Snarl and Air Cutter. Those two IDs are used for *every* stat change in the
  game, so Growl, Swords Dance, Leer, Sand-Attack and all their relatives were
  firing move animations too. This one was not confined to the new moves.

**Fixed by:** moving the three non-move rows to the end of the table, with a
comment explaining why they have to stay there.

Verified afterwards: all 464 table rows line up with their move constants (every
`banim` comment now matches its index), the three animation IDs resolve to their
own entries, and all 452 referenced `BattleAnim_*` labels are defined.

The 22 new moves that still share an animation with another move are deliberate
reskins from the handoff's map — Glaive Rush uses Dragon Rush, Body Press uses
Brick Break, Defog uses Whirlwind, Overheat uses Draco Meteor, and so on.

---

## 3. Canonical data corrections (fixed)

Every one of the 115 rows was checked against canonical type / category / power /
accuracy / PP / secondary-effect chance. Three were wrong:

| Move | Was | Now | Source |
|---|---|---|---|
| Bounce | 100 BP | **85 BP** | Showdown `moves.ts` |
| Phantom Force | 120 BP | **90 BP** | Bulbapedia / veekun |
| Belch | `EFFECT_POISON_HIT`, 30% | **`EFFECT_NORMAL_HIT`, 0%** | Showdown `moves.ts` — Belch has no secondary |

The other 112 rows match canon.

Note: `MOVE_EXPANSION_REPORT.md` is stale in places — it lists Belch as 120/80/5
and Head Smash at 90 accuracy, where the actual tables (correctly) say 120/90/10
and 80. Trust the tables, not that report.

---

## 4. Flag tables

The flag work was in better shape than expected. The contact bitfield in
particular is accurate — I spot-verified the suspicious entries against
pokemondb and the file was right and my assumptions were wrong on Shadow Bone,
Petal Blizzard and Scale Shot (all correctly flagged as **not** making contact).

**Fixed:**

* **Grass Knot** was missing its contact bit. It makes contact; bit now set.
* **Acid Spray** was missing from `BallBombMoves`. It has the bullet flag, so
  Bulletproof should block it. Added.

**Verified correct, no change needed:**

* `CriticalHitMoves` — Drill Run, Psycho Cut, Blaze Kick, Air Cutter, Cross
  Poison, Stone Axe and Poison Tail are all present.
* `SliceMoves` — Psycho Cut, Sacred Sword, Stone Axe, Kowtow Cleave, Cross
  Poison, Air Cutter all present for Sharpness.
* `PunchMoves` — Headlong Rush, Meteor Mash, Sky Uppercut, Power-Up Punch,
  Hammer Arm, Rage Fist all present for Iron Fist.
* `SoundMoves` — Echoed Voice, Grass Whistle, Metal Sound, Eerie Spell, Snarl
  all present.
* `WindMoves` — Air Cutter, Heat Wave, Petal Blizzard present.
* `BiteMoves`, `PulseMoves` — none of the 115 qualify. Correct as-is.

**Noted, not changed (pre-existing, cosmetic):**

* `Razor Wind` is in `SliceMoves`; it is not a slicing move in canon.
* `Aeroblast` is in `WindMoves`; it is not wind-flagged in canon.
* `Sandstorm` is missing from `WindMoves` and `Heal Bell` from `SoundMoves`.
* `Howl` is canonically sound-based, but it only ever targets the user, and
  Soundproof never blocks it — leaving it out of `SoundMoves` is correct here.

---

## 5. Name casing (fixed)

Every move name in the game is ALL CAPS. 89 of the new names were written in
Title Case — `Rock Tomb`, `Quiver Dance`, `PowerUpPunch` — so the battle menu
would have shown a visibly mixed-case list. Curiously the batch was inconsistent
with itself: indices 438–460 (`OVERHEAT` through `FICKLE BEAM`) were already
uppercase.

All 89 uppercased. No name exceeds the 12-character limit and there are no
duplicate display names.

---

## 6. Engine review

**Correct as implemented:**

* Stealth Rock and Sticky Web screen bits (3 and 7) do not collide with the
  Toxic Spikes 2-bit counter at 5–6.
* `StealthRockDamage_Core` and `StickyWebSpeedDrop_Core` are both hooked into
  `SpikesDamage`, which runs for either side via `hBattleTurn`.
* Sticky Web reuses `CheckSpikesUngrounded_Core`, so Flying / Levitate / Air
  Balloon are exempt as they should be.
* Defog clears hazards and screens from both sides — Gen 8+ behaviour.
* Body Press / Foul Play route through `GetPhysicalAttackSource`, wired into
  both `PlayerAttackDamage` and `EnemyAttackDamage`.
* Freeze-Dry's `wTypeModifier` override is applied before the deferred
  nullification pass, not after.
* Every `EFFECT_*` referenced by `moves.asm` / `moves2.asm` is defined.

**Fixed:**

* **Hazard order on switch-in.** `SpikesDamage` ran Spikes → Toxic Spikes →
  Stealth Rock → Sticky Web. Canonical order is Stealth Rock first. Reordered.
  Only affects message order and which hazard lands the KO, but it is free to
  get right.

**Flagged — needs a decision, not fixed:**

* **Bank headroom is now effectively zero.** Restoring the five inline bodies
  (§1) put those bytes back into the banks the refactor was trying to relieve:

  | Section | Free |
  |---|---|
  | Effect Commands | **9 bytes** |
  | Battle Core Overflow | **12 bytes** |
  | Battle Core | **17 bytes** |
  | Move Animations 5 | 30 bytes |
  | Handoff Move Effects | 216 bytes |
  | Battle Effect Overflow | 7,568 bytes |

  It links, but the next line you add to `effect_commands.asm` or `core.asm`
  will break the build. The clean way forward is to finish the refactor the
  interrupted commit started: move `BattleCommand_TrapTarget`'s body (~62 lines)
  and `HandleWrap`'s body (~69 lines) into `effect_commands_core.asm`, which has
  7.5 KB free. Both are safe to relocate — `StdBattleTextbox` bankswitches to
  `BANK(BattleText)` itself, so their text pointers are bank-independent. The
  only care needed is that `SwitchTurnCore`, `GetSixteenthMaxHP` and
  `SubtractHPFromUser` live in the Battle Core bank and would need `farcall`.
  I left this alone because it is new cross-bank code that can only really be
  validated in-game.

---

## 7. Approximations still in place

Unchanged from `MOVE_EXPANSION_REPORT.md`, listed so they do not get mistaken
for regressions: Aqua Ring heals once instead of per-turn; Strength Sap does not
heal; Grass Knot is fixed 60 BP; Bounce and Phantom Force lose their secondary
effects to `EFFECT_FLY`; Sacred Sword and Chip Away do not ignore stat boosts;
Brick Break and Raging Bull do not shatter screens; Eerie Spell does not cut PP;
Flatter raises Attack; Rage Fist is fixed 90 BP; Infernal Parade's burn is not
wired; Stone Axe does not set Stealth Rock; Draining Kiss drains 50% rather than
75%; Belch does not require having eaten a Berry.

---

## 8. Still needs you

The table alignment is verified programmatically, but as the original handoff
warned, misalignment shows up in-game rather than at compile time. Worth opening
the ROM and checking:

1. Move names and descriptions in a battle menu, especially around indices
   357–360 and 462–463 — the rows immediately after each deleted duplicate.
   Also confirm animations now match: use Rock Tomb, Silver Wind and Air Cutter,
   and check that a plain Growl/Leer plays the generic stat-drop flash rather
   than a move animation (§2b).
2. That the seven Pokémon whose learnsets were repointed still learn Dazzling
   Gleam / Disarming Voice at the right level.
3. Recoil damage actually applies now (Wood Hammer, Head Smash, Volt Tackle),
   and that Rock Head and Magic Guard suppress it.
4. Wrap / Bind / Fire Spin / Clamp / Whirlpool residual damage and release
   messages, since `HandleWrap` and `BattleCommand_TrapTarget` were restored.
