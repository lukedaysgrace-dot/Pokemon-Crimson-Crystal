# Interaction audit, November 10, 2026 (second pass)

Status: complete. Nine defects were confirmed in native battles and fixed. Both
ROMs build, and the validation runs listed at the end passed on the final build.

This pass starts at `1c95e7c33a5484146228dce665f73577caedd34e`, the commit the
first November 10 audit (`battle-audit-2026-11-10.md`) validated. Its two ROM
hashes were reproduced byte for byte before any change. The scope was Illusion,
Stance Change, action priority, called moves, Transform/Imposter and ability
suppression, followed by a wider sweep of moves and abilities against modern
rules. Documented custom rules (Flash Fire, Gen 6 Gale Wings, Disguise, Gen 1
Mimic, 70-power Hidden Power, the Illusion Speed reward) were left alone.

Method: each suspicion was first written as a native battle case and run on
the unmodified debug ROM. Only cases that failed there, and whose cause was
then located in the source, are listed as confirmed. Several early probes
"failed" because of the harness rather than the game; those are listed under
harness notes so the next agent does not repeat them.

## The five most consequential findings

All five are fixed. Line numbers refer to the tree after this change.

### 1. A defender's on-hit reaction made the attacker's secondary effect certain

- Where: `RunContactAbilitiesHook`, `engine/battle/abilities_engine.asm:4631`,
  called from `BattleCommand_CheckFaint`, `engine/battle/effect_commands.asm:2842`.
- Cause: every secondary-effect script runs `effectchance` before `applydamage`
  and applies the effect after `checkfaint` (for example `ParalyzeHit`,
  `data/moves/effects.asm:203`). `effectchance` records a failed roll in
  `wEffectFailed`. The reactions inside the hook cleared `wEffectFailed` so that
  their own capped stat change would not leak (`StatUpAbility` at line 1045,
  `.on_hit_stat_up` at 4767, Weak Armor, Toxic Debris, Tangling Hair,
  `WeaknessPolicyBoost` at 4544, and `IllusionDirectHit` in
  `engine/battle/illusion.asm:332`). That also erased the failed roll.
- Reproduce (pre-fix ROM): Mew L50 uses Body Slam on Snorlax L50 with Stamina,
  `rng: forced_high` (no secondary effect may proc).
- Expected: Snorlax takes damage, gains +1 Defense and is not paralyzed.
- Actual: Snorlax was paralyzed every time. The same happened with Weak Armor,
  Toxic Debris and Tangling Hair; Bite always flinched Justified and Rattled
  holders; and the hit that broke an Illusion always applied its secondary
  (Body Slam paralysis, Psychic's Sp. Def drop, Flamethrower's burn).
- Fix: the hook now saves `wEffectFailed` on entry and restores it on exit, so
  the roll survives whatever the reactions do. A successful roll still applies.
- Coverage that was missing: no existing case paired a reacting ability with a
  move whose secondary roll fails. The every-move/every-ability Cartesian run
  only asserts integrity, so a paralysis that "should not" happen passed.

### 2. A Neutralizing Gas holder that transformed kept suppressing entry abilities

- Where: `TransformedAbilityStart`, `engine/battle/abilities_engine.asm:6820`;
  `CheckNeutralizingGasEnded`, line 446.
- Cause: Gas ending was only detected on an entry or a faint. Transform replaces
  the holder's ability (`TransformCopyAbility`), so the Gas was gone but
  `wNeutralizingGasActive` stayed set and the foe's blocked entry ability never
  resumed until some later switch.
- Reproduce: Weezing (Neutralizing Gas) uses Transform on Gyarados (Intimidate).
- Expected: Gas ends; Gyarados's Intimidate lowers the transformed Weezing's
  Attack, and Weezing's copied Intimidate lowers Gyarados's.
- Actual: only the copied Intimidate fired; Weezing's Attack stayed neutral.
- Fix: `TransformedAbilityStart` calls `CheckNeutralizingGasEnded` first. It is
  a no-op while a Gas holder is still on the field (transforming *into* a Gas
  holder copies nothing, by `ABILFLAG_NO_TRANSFORM`).

### 3. Negative priority was a single bracket, and phazing failed for the first mover

- Where: `data/moves/effects_priorities.asm`; `GetMovePriority`,
  `engine/battle/core.asm:842`; `BattleCommand_ForceSwitch`,
  `engine/battle/effect_commands.asm:5388`.
- Cause: `BASE_PRIORITY` was 1, so Vital Throw (-1), Avalanche (-4), Counter and
  Mirror Coat (-5), Roar/Whirlwind/Circle Throw/Dragon Tail (-6) and Trick Room
  (-7) all stored 0 and were ordered by Speed alone. Separately, the Gen 2 rule
  "phazing fails if its user acts first" was still present for trainer battles.
- Reproduce: Arcanine uses Counter against a slower Shuckle using Vital Throw.
- Expected: Vital Throw strikes first, then Counter returns double damage.
- Actual: the faster Counter went first and failed. Likewise a faster Roar
  acted before Avalanche, and any phazing move that did act first failed.
- Fix: `BASE_PRIORITY` is 7 and the table stores `BASE_PRIORITY + n` / `- n`
  with the modern brackets. Phazing now works when its user acts first; the
  dragged-in replacement has move `$ff` written to its `wCur*Move`, which
  `CheckTurn` already treats as "end this turn", so it cannot perform the
  action its predecessor queued. A Magic Bounce reflection is excluded from the
  cancel because it drags the original user, whose action is already running.
  `tools/battle-simulator/lab/data.py` parsed the old table format and was
  updated to the new one.

### 4. Transform and Imposter ignored a Substitute and an existing transformation

- Where: `BattleCommand_Transform` and the new `CheckTransformFails`,
  `engine/battle/move_effects/transform.asm:1` and `:71`; `ImposterAbility`,
  `engine/battle/abilities_engine.asm:750`.
- Reproduce: Blissey uses Substitute; Mew then uses Transform. Or Pikachu
  switches to a Ditto with Imposter while the foe is behind a Substitute.
- Expected (Gen V onward): both fail. Transform also fails if its user is
  already transformed.
- Actual: both copied the target through its Substitute, and a transformed mon
  could transform again.
- Fix: one shared guard, `CheckTransformFails` (Illusion on either side, either
  battler transformed, semi-invulnerable target, Substitute). Imposter checks it
  before showing its banner and now stays silent instead of printing
  "But it failed!".

### 5. Circle Throw and Dragon Tail dragged a target out through its Substitute

- Where: `BattleCommand_ForceSwitch`, `engine/battle/effect_commands.asm:5388`.
- Reproduce: Blissey uses Substitute; Dragonite uses Dragon Tail; the trainer
  has a second Pokemon.
- Expected: the Substitute takes the hit and Blissey stays in.
- Actual: Blissey was dragged out and replaced.
- Fix: for `EFFECT_CIRCLE_THROW` the command returns when `wHitSubstitute` is
  set (it is cleared per hit by `critical`, and set when the Substitute takes or
  is broken by the hit). Roar and Whirlwind still ignore the Substitute.

## Other confirmed defects, fixed

- Rest called by Sleep Talk restored all HP and restarted the sleep counter
  (`BattleCommand_Heal`, `engine/battle/effect_commands.asm:6473`). It now fails
  because the user is already asleep, as from Gen III. Reproduce: Snorlax at
  50% HP, asleep, with Sleep Talk and Rest only.
- Metronome could call King's Shield. `MetronomeExcepts` listed Protect, Detect,
  Endure and Baneful Bunker but not the newer guard that reuses
  `EFFECT_PROTECT`. `tools/audit_metronome_exceptions.py` (now part of
  `make audit-static`) fails on the old table and checks every guard move.

## Hypotheses (not changed)

- Imposter is not in `GasEndedAbilities` (`abilities_engine.asm:489`), so a
  Ditto that entered under Neutralizing Gas does not transform when the Gas
  later ends. Other entry abilities do resume. I believe modern games activate
  Imposter here, but I could not confirm it from the sources at hand, and the
  comment in `TransformedAbilityStart` calls Imposter "a switch-in-only
  trigger", which reads as a deliberate choice. Test to write if you change it:
  Weezing (Gas) faces Ditto (Imposter); Weezing switches out; Ditto should copy
  the replacement.
- Metronome's exclusion list is otherwise the Gen 2 list. Modern games also
  exclude Mirror Move, Transform, Trick, Snore, Snarl and a few of the newer
  signature moves. Nothing breaks when these are called, so this is a design
  question rather than a defect.
- `GetOpponentIgnorableAbility` treats the turn holder's Mold Breaker as active
  for any lookup made on its turn, not only while its move is resolving. I found
  no caller where that changes an outcome (the residual and entry paths read the
  plain ability), so there is no reproduction; keep it in mind when adding a new
  caller outside a move.

## Intentional mechanics (do not "fix")

- Hyper Beam and Giga Impact skip the recharge turn after a KO
  (`data/moves/effects.asm`, `HyperBeam`: the comment states it).
- Morning Sun, Synthesis and Moonlight depend on the time of day; their
  descriptions say "varies by time".
- Illusion's reveal grants +1 Speed, residual/recoil/contact damage and
  confusion self-hits do not reveal, and Neutralizing Gas reveals without the
  reward. All were re-checked and behave as documented.
- Stance Change is not suppressed by Neutralizing Gas, cannot be traced or
  swapped, is copied by Transform together with the current form, and a
  confusion self-hit leaves Aegislash in Shield.
- Wild battles keep the level-based flee rule for Roar and Whirlwind.

## Checked and found correct

Prankster against Dark types for foe-targeted status only; Queenly Majesty and
Armor Tail blocking raised-priority moves that target the holder but not
Protect, self-target or side-target Prankster moves, and not when the attacker
has Mold Breaker; Sucker Punch against status moves and against a target that
already moved; Triage and Gale Wings ordering; Trick Room inside and across
brackets; Fake Out on a later turn; Phantom Force through Protect; Toxic
persisting across a switch with its counter reset; type-based status
immunities (Electric, Grass powder and Leech Seed, Fire, Steel with and without
Corrosion, Ground against Thunder Wave, Glare against Ghost); Ghost types
escaping Mean Look and Shadow Tag; Volt Switch into a Ground type; Dragon Tail
against Fairy; Suction Cups with and without Mold Breaker; Counter against
Ghost and Mirror Coat against Dark; Substitute and Mist blocking Intimidate;
Gas leaving through a switch or faint re-triggering Intimidate; drain and
recoil amounts unchanged by defender reactions.

## Harness notes for the next agent

- Ditto's only legal ability is Imposter, so `ability: LIMBER` on Ditto is a
  post-entry override and Ditto still transforms on entry. Use Mew or Smeargle
  to test the move Transform.
- `ContactChance` is `BattleRandomRange(10) < 3`. Both forced RNG values give 0,
  so Static, Flame Body, Poison Point and Poison Touch always proc in forced
  modes, contrary to the README's "nothing procs" for `forced_high`. An attacker
  with Synchronize then passes the status back and can look like a forced
  secondary effect.
- Trainer battles (`enemy2`) under a forced RNG value can stall in an AI or
  replacement roll; use `rng: seeded`. The symptom is "battle timed out" with
  the sampled PC inside `_UpdateSound`.
- An enemy that faints during the last requested turn needs `turns` to extend
  one further, or `seeded` RNG, before the replacement can be asserted.
- A fresh clone does not build: `gfx/pokemon/arcanine_hisuian/` has no
  `front.png` or `back.png` in the repository, only generated tables. The local
  working tree builds because ignored `.2bpp`/`.lz` intermediates are still on
  disk. The `rgbds/` executables in the repository are also damaged (they were
  committed before `.gitattributes` marked them binary); use the release
  archive from gbdev instead.

## Regression coverage added

`tools/battletest/tests/101-interaction-audit-2026-11-10.yaml` holds 44 native
cases: the Transform/Imposter guards with controls, Gas lost through Transform
on both sides, Dragon Tail and Roar against a Substitute, Rest through Sleep
Talk with an awake control, the negative priority brackets, Queenly Majesty
against negative and self-target moves, first-acting phazing on both sides with
the following turn and the Magic Bounce exception, and the secondary-roll cases
for six abilities, Weakness Policy and Illusion with a successful-roll control.
`tools/audit_metronome_exceptions.py` covers the Metronome table statically.

## Handoff: reproducing from scratch

```sh
git checkout 1c95e7c3            # pre-fix tree
make -j8 pokecrystal_debug.gbc   # RGBDS 0.5.2
python3 tools/battletest/runner.py --no-render \
    tools/battletest/tests/101-interaction-audit-2026-11-10.yaml   # copy the file in
```

On the pre-fix ROM the cases named "secondary", "Gas holder", "Transform
fails", "Imposter does not copy", "absorbed by a Substitute", "Rest called by
Sleep Talk", "priority: Vital Throw", "priority: Avalanche", "priority: Counter"
and "phazing: ... acts first" fail; the controls pass. On the fixed tree all 44
pass. `python3 tools/audit_metronome_exceptions.py` fails before and passes
after.

Files changed: `constants/battle_constants.asm`,
`data/moves/effects_priorities.asm`, `data/moves/metronome_exception_moves.asm`,
`engine/battle/abilities_engine.asm`, `engine/battle/core.asm`,
`engine/battle/effect_commands.asm`, `engine/battle/move_effects/transform.asm`,
`tools/battle-simulator/lab/data.py`, `Makefile`, `AGENTS.md`, plus the new test
file, audit script and this report. No dialogue, save layout or WRAM layout
changed. ROM0 slack is unchanged (109 bytes release, 103 debug).

## Validation

All runs used PyBoy against the final build with two workers. Battle runs use
the debug ROM's native engine; the release ROM received the build and static
checks.

| ROM | SHA-256 |
| --- | --- |
| Release | `a0278b4a2fe6766d48860885cf97f413c894d8a0b86a9145c07a50a9ac6a8657` |
| Debug | `ca0aed5e99a2469bcb7060718370603887bd79f2d9111d80ae41c7f17746adc7` |

| Check | Result |
| --- | --- |
| Pre-fix ROM reproduced (`b2f65070...`), new test file | 24 failed, 20 controls passed |
| Final ROM, new test file | 44 passed |
| YAML suite plus every move, effect and ability, reflection and complex matrices, long battles, 256 mixed battles | 6,157 passed, 0 failed |
| Illusion against every move (444) and every opposing ability (173), called-move priority (440), status-target priority (300), per-move semantics, reaction matrix | 4,900 passed, 0 failed |
| `stance_change_checks.py` | 532 native checks passed |
| `metronome_priority_checks.py` | 24 passed, both sides |
| `test_battle_action_context.py`, `ai_dynamic_type_checks.py` | passed |
| `test_battle_instant_text.py` | 54 battles matched |
| `audit_moves.py`, `audit_ability_text.py`, `audit_metronome_exceptions.py` | passed |

Not run in this pass: the 309,024-case every-move by every-ability Cartesian
run, the ability/class/textbox/swagger/outcome/item matrices, the remaining
`make audit-static` scripts unrelated to battle code, and the graphical,
overworld and audio suites. The first three groups are worth a run on a
machine with more cores (`make test-moves-abilities BATTLE_TEST_JOBS=8`).
