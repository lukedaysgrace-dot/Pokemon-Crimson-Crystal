# Independent review and follow-up battle audit

Work in this repository:

`C:\Users\luked\OneDrive\Documents\GitHub\Pokemon-Crimson-Crystal`

Independently analyze the previous agent's changes, then perform a focused
follow-up audit of move/ability/item interactions. Treat the previous report as
claims to verify. Look for incorrect assumptions, incomplete fixes, regressions,
and missing behavioral assertions. Fix confirmed code defects with focused
regression coverage, and report uncertain rules separately.

If your environment cannot access the repository, obtain the actual diff,
referenced source files and audit report before claiming an independent code
review. If ignored logs or historical ROMs are unavailable, state that limit
and reconstruct evidence where practical; do not invent baseline results.

## Read first and establish the current state

Read `AGENTS.md` completely before changing the game. All paths below are
relative to the repository root above.

Start with:

- `reports/bug-audit-2026-11-12.md` — the completed audit and evidence.
- `reports/interaction-audit-2026-11-10.md`.
- `reports/battle-audit-2026-11-10.md`.
- `reports/moves-abilities-audit.md`.
- `tools/battletest/README.md` and the relevant harness implementation.

Inspect current Git status, history and diffs. The previous audit started at
`7ea05c0435f23a278d441b53d53702df4eec41f7`; its edits were left in the working
tree. Verify how they relate to the current checkout rather than assuming HEAD
or all uncommitted changes still belong to that audit.

Preexisting changes observed before the audit were:

- Modified `audio/ded/axew.ded`.
- Untracked `gfx/title/suicune.png:Zone.Identifier`.
- Untracked `gfx/title/suicune_run.png:Zone.Identifier`.

Preserve unrelated user changes. Do not toggle fixes or restore whole files in
the shared working tree to obtain a baseline. Use isolated copies if before/after
reproduction requires rebuilding older source. Keep matching ROM, symbol and
map files and record their hashes.

## Part 1: independently review the nine reported fixes

The previous agent classified eight battle defects as P2 and one defensive
storage API defect as P3. Verify the classification and intended mechanics.
Challenge both the source fix and the tests.

1. **Baneful Bunker ignored the consecutive guard penalty.**
   - File: `engine/battle/core.asm`.
   - Move selection retained `w*ProtectCount` for `EFFECT_PROTECT` and
     `EFFECT_ENDURE`, but reset it for `EFFECT_BANEFUL_BUNKER`.
   - The fix adds Bunker to normal player selection, enemy selection and the
     player Giga Hammer reselection path.
   - Check repeated use, alternating guard moves, intervening non-guard actions,
     failed attempts, switching, and called/continuing actions where applicable.
     Verify that the counter resets and persists at the correct events.

2. **Baton Pass erased the incoming mon's own bad poison.**
   - File: `engine/battle/move_effects/baton_pass.asm`.
   - Entry restored the replacement's individual Toxic history, then
     `ResetBatonPassStatus` cleared the active Toxic flag.
   - The fix clears outgoing state and calls `ToxicRestorePlayer_Core` or
     `ToxicRestoreEnemy_Core` for the incoming slot.
   - Check individual ownership, counter reset, ordinary poison, a healthy
     reserve, outgoing bad poison, status cures and repeated switches. The
     passer's poison must not transfer to its replacement.

3. **Disable treated PP-Up metadata as remaining PP.**
   - File: `engine/battle/move_effects/disable.asm`.
   - Raw PP `$40` has zero PP plus PP-Up metadata. The old check tested the
     entire byte; the fix uses `and PP_MASK`.
   - Verify exhausted and non-exhausted moves with all PP-Up values, move-slot
     lookup bounds, last-move history, Struggle, transformed/copied moves and
     both battler directions.

4. **Non-Ghost Curse failed despite an available stat change.**
   - File: `engine/battle/move_effects/curse.asm`.
   - The old precheck only considered raising Attack and Defense. It ignored
     an available Speed drop and Contrary's reversed directions.
   - The fix considers all three caps using the effective ability.
   - Check partial and complete caps, both sides, normal/Contrary/Simple where
     implemented, and Neutralizing Gas suppression. Independently establish
     the intended rules rather than assuming a modern reference settles every
     legacy behavior.

5. **Contrary Curse changed Speed in the wrong direction.**
   - Same file.
   - Curse called raw `LowerStat` for Speed, bypassing the ability-aware path.
   - It now uses the shared `BattleCommand_SpeedDown` path with self-drop
     context and turn switching.
   - Check neutral stages, capped Speed, subsequent Attack/Defense changes,
     actual recalculated stats, failure flags, deferred messages, turn
     restoration and temporary inversion markers. There was a review suspicion
     about a stale marker after a capped raise; it was ruled out by tracing
     `RaiseStatWithoutContrary`. Verify the trace rather than repeating the
     suspicion as a confirmed bug.

6. **Poison Touch bypassed Covert Cloak.**
   - File: `engine/battle/abilities_engine.asm`, `PoisonTouchAbility`.
   - The old code checked Shield Dust but omitted Covert Cloak.
   - The fix uses `ModernCloakOpp_Core` to check the effective held item.
   - Check both directions, Shield Dust, Klutz, suppression ending, Substitute,
     contact qualification and RNG consumption. Item identity and item effect
     availability are different questions.

7. **Delayed Yawn incorrectly retained Mold Breaker's bypass.**
   - Files: `engine/battle/abilities_engine.asm` and
     `engine/battle/move_effects/new_move_cores.asm`.
   - A new `AbilityPreventsSleepResidual` helper uses the effective, unignored
     opponent ability when pending sleep resolves.
   - The originating move's initial drowsiness gate still uses its appropriate
     move-time rules.
   - Check Leaf Guard in/out of sun, other sleep immunities, Gas suppression,
     ability/weather changes between application and resolution, source
     switching/fainting and existing status. Verify register, flag and status
     pointer preservation across the banked call.

8. **Safeguard raised after Yawn canceled pending sleep.**
   - File: `engine/battle/move_effects/new_move_cores.asm`, `.yawn_apply`.
   - The fix removes the late Safeguard recheck while preserving its initial
     drowsiness check.
   - Verify Safeguard before versus after application, both directions,
     reflection and immunity changes without accidentally treating delayed
     sleep as a newly executed move.

9. **An unloaded PC update reported success.**
   - File: `engine/pc/storage.asm`, `UpdateStorageBoxMonFromTemp`.
   - `wTempMonSlot = 0` returned Z from `and a` despite the failure contract.
   - It now returns NZ without writes.
   - Verify callers and the Z/NZ contract, party/box metadata, allocation state
     and preservation. No ordinary UI data-loss reproduction was found; do not
     inflate this into a demonstrated save-corruption defect.

Review shared helpers for side effects: `hBattleTurn`, effective versus raw
abilities/items, carry/Z return contracts, register preservation, WRAM bank
selection, `wAttackMissed`, `wEffectFailed`, `wFailedMessage`, `wLoweredStat`,
saved miss context and per-action/per-party-slot cleanup.

## Tests and additional changes to review

New battle regression files contain 45 cases:

- `tools/battletest/tests/102-ability-audit-2026-11-12.yaml`: 16.
- `tools/battletest/tests/103-move-audit-2026-11-12.yaml`: 20.
- `tools/battletest/tests/104-ordering-audit-2026-11-12.yaml`: 9.

Other edits:

- `tools/test_pc_storage.py`: eight unloaded-update assertions.
- `tools/test_battle_picture_tiles.py`: Entei added to native frame checks.
- `tools/test_trainer_portraits.py`: permits deliberately inactive Agatha/Will
  portrait assets, checks their presence, and retains active portrait coverage.
  Check that this exemption is appropriately narrow.
- `AGENTS.md`: corrected invariants documented.
- `reports/bug-audit-2026-11-12.md`: findings, validation and limitations.

Normal builds also regenerated these tracked outputs:

- `data/maps/portrait_texts.asm`.
- `gfx/pokemon/entei/bitmask.asm`.
- `gfx/pokemon/entei/frames.asm`.
- `gfx/pokemon/entei/front.animated.tilemap`.

The prior review independently reconstructed all 15,680 Entei source pixel
indexes with zero differences. Restoring only the old tracked tables would
mismatch newly generated tile graphics. The portrait change sorts Lorelei's
rows and removes a redundant explicit no-portrait row for the Mt. Silver sign;
the sign itself remains. Verify generated consistency rather than editing
generated data by hand or dismissing it automatically as noise.

## Part 2: priority follow-up audit

### A. Item lifecycle, suppression and history

Trace held runtime ID -> item index/effect lookup -> eligibility -> activation
-> consumption/removal -> live and party update -> historical records ->
recovery. Check each transition independently.

Prioritize:

- Klutz and Neutralizing Gas: a disabled effect must not lose or misidentify
  its held item. Check suppression beginning and ending, including switching,
  fainting, Transform and ability changes where supported.
- Recycle, Harvest, Cud Chew, consumed-item records and Unburden together.
  Distinguish eating, consuming, stealing, swapping, dropping, destroying and
  recovering. Determine which events populate or invalidate each history.
- Thief/Covet, Trick/Switcheroo, Knock Off, Incinerate and berry consumption,
  limited to mechanics actually implemented in this repository.
- Empty/occupied item slots, failed recovery, repeated recovery, intervening
  items, another party slot, switching and re-entry. Look for duplication,
  history inherited by replacements, incorrect item resurrection and one-use
  effects being rearmed unintentionally.
- Dynamic item IDs and garbage collection. Item indexes are 16-bit while
  live held IDs are 8-bit runtime IDs. Review conversion helpers and collector
  roots, including `wPlayerRecycleItems`, `wEnemyRecycleItems` and
  `w*ConsumedItem` while `wBattleMode` is nonzero. Extended items such as Power
  Herb, White Herb and Throat Spray must survive required history operations.
  A low-byte comparison is insufficient for an extended item index.

Use meaningful controls: no item, inert item, eligible item, suppressed item,
no ability, applicable suppression/bypass, both battler directions and at least
one negative case for each claimed rule.

### B. Switching/fainting during multi-hit, recoil and reactions

Audit ordering and ownership when an action changes which battler is alive or
on the field. Prioritize combinations of:

- Multi-hit moves, healing/resist berries, Stamina, Weak Armor, Berserk,
  Disguise and Illusion.
- Rocky Helmet, contact abilities, recoil and Life Orb.
- A Neutralizing Gas holder fainting or leaving during those sequences.
- Attacker fainting between hits, defender fainting before a reaction,
  simultaneous KOs, phazing and U-turn/Volt Switch where applicable.

Assert exact hit counts, HP changes, stages, consumed items, historical records,
current party slots, active abilities and queued-action cancellation. Check
which effects legitimately occur after a holder faints. Pending effects must
remain attached to the correct individual and must not affect a replacement.
Check synchronization between battle structs and party records on all outcomes.

### C. Called moves, move locks, priority and immunity

Cross supported callers such as Sleep Talk, Metronome and Mirror Move with:

- Choice-item locks, Encore, Disable, PP exhaustion, Struggle and move replacement.
- Prankster/Dark immunity, Queenly Majesty/Armor Tail, Triage, Gale Wings and
  Mold Breaker where applicable.
- Sleep/status prevention, Substitute, reflection and failed execution.

Assert the selected action versus the executed/called move, which move gets
locked, which PP changes, last-move/type history, and whether selected-action
priority and Prankster origin are retained correctly. Check state after failure,
the next turn, switching and re-entry. Delayed effects such as Future Sight and
Yawn require reasoning separate from an actively resolving move.

## Evidence standards and project-specific rules

Use primary move/ability definitions and simulator tests as external references,
then reconcile them with this game's documented rules. Verify local exceptions
before changing behavior. The prior review used:

- https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts
- https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts
- https://github.com/smogon/pokemon-showdown/blob/master/data/mods/gen4/moves.ts

Preserve documented custom/legacy mechanics, including fixed 70-power Hidden
Power, Gen 6 Gale Wings, Gen 1 Mimic, custom Flash Fire, Illusion's Speed reward,
the existing Metronome policy and Hyper Beam's KO recharge exception. Read the
actual local documentation before relying on this abbreviated list.

Two notes remain from the previous audit:

- Fully capped Curse prints “ABILITY won't rise anymore!” This was reported
  without changing dialogue, as `AGENTS.md` requires.
- Ghost Curse is blocked by Substitute under the legacy Gen II–IV rule.
  Modern rules differ; no local instruction clearly chooses a generation for
  this interaction. Treat it as a design question unless new evidence resolves
  intent. `docs/trainer-theme-audit-round5.md` also explicitly warns against
  assuming modern Growth behavior.

The previous Imposter/Gas hypothesis was resolved without a change: Imposter
does not activate merely because Neutralizing Gas ends. The old missing
Hisuian Arcanine source-art warning is stale; both PNGs are already tracked.

For every suspected bug, define expected and actual behavior, locate the source
cause, and build the smallest native reproduction with appropriate controls.
Test player and enemy directions. Check failure paths and the following turn,
not only immediate output. Distinguish confirmed game bugs, harness problems,
expected custom rules and unresolved design choices.

Important harness caveats:

- Entry tests need legal species/ability pairs. Arbitrary ability overrides
  are applied after entry; a post-entry assertion does not establish entry-time
  activation.
- `forced_high` does not universally prevent procs. Modulo-based contact rolls
  can still trigger; choose controlled or seeded RNG appropriate to the routine.
- Fixed RNG can stall trainer AI/replacement loops. Use seeded RNG there.
- A hook may fire twice if an interrupt lands on its instruction. Interpret
  observations using the documented harness behavior.
- Stale ROMs or mismatched symbols invalidate conclusions. Verify build identity
  and per-ROM fixture cache keys.
- Execution completion and bounded-state checks do not establish every mechanic.
  Add explicit expected outcomes, negative controls and state ownership checks.
- Use private emulator fixtures only; never open or overwrite player saves.
- Label routine-level checks separately from complete native battle outcomes.

## Previous validation: verify its meaning and reuse evidence appropriately

All final runs below passed:

- Both release/debug ROMs built with RGBDS 0.5.2; a second build was up to date.
- Debug battle suite: 32,613 cases, zero failures/errors/skips, eight workers.
- New regression files at ordinary timing: 45 passed. These overlap the broad
  suite; do not sum them as independent coverage.
- `make audit-static`: all targets, including 44,394 game-data invariants,
  444 moves, 503 species/forms, 185 save-layout/recovery checks and 11,148
  linked-resource/audio checks.
- Per ROM: storage 130; capture/PC/Day-Care followups 40; inventory boundaries
  29,942; item expansion 1,300; Gyro Ball 18,372; native picture checks 1,259;
  HP/friendship/filter/Seer state checks 37,824.
- Secondary-effect/critical probabilities: 172 groups, 44,032 outcomes.
- HP-item/faint updates: 352 checks.
- AI dynamic typing: four native two-turn checks.
- Native Metronome priority: 24 cases, both sides.
- Both native Imposter entry action-context checks.
- Presentation equivalence: 54 battles matched with ordinary letters,
  instant letters and shortened fixed pauses.
- Trainer portrait coverage: ten checks.

Final ROM SHA-256 values from that audit:

- Release: `a82fdca13e8f7f64d466690533ac868fb6507fc9e1f4f2b57d744bcdc3c0a2e9`.
- Debug: `d58d6c0870e8a6cbf084ffdee1cf624537af476aa299074d499286b6b838730b`.

ROM0 slack was 97 bytes release / 91 debug. Preserve the cartridge header
reservation; use banked code or reduce code if needed. Keep save offsets and
stable species/item identifiers unchanged. Follow all other `AGENTS.md` bank,
WRAM, item-ID and rendering constraints.

Logs:

- `.tmpbuild/bug-audit-2026-11-12/build-final.log`.
- `.tmpbuild/bug-audit-2026-11-12/build-verified.log`.
- `.tmpbuild/bug-audit-2026-11-12/static-final.log`.
- `.tmpbuild/bug-audit-2026-11-12/full-battles.log`.
- `.tmpbuild/bug-audit-2026-11-12/validation-results.json`.
- `.tmpbuild/battletest-660dad2a0f2e-1794504746575716686/` worker logs.

Baseline caveat: preexisting ROMs were stale relative to the starting source.
Some pre-fix evidence came from those ROMs; the source cause was separately
verified. Do not claim every baseline result reproduces the entire starting
revision. The uncapped Contrary Speed defect also has direct source evidence
and final neutral-stage tests; do not invent a missing pre-fix run.

Useful commands from the repository root, using the working Linux/WSL Python
environment where appropriate:

```sh
make -j8 pokecrystal.gbc pokecrystal_debug.gbc
make audit-static
.venv/bin/python tools/battletest/runner.py --no-render \
  tools/battletest/tests/102-ability-audit-2026-11-12.yaml \
  tools/battletest/tests/103-move-audit-2026-11-12.yaml \
  tools/battletest/tests/104-ordering-audit-2026-11-12.yaml
```

The previous broad run used:

```sh
.venv/bin/python tools/battletest/runner.py \
  --no-render --instant-text --short-delays --jobs 8 \
  --all-moves --all-effects --move-semantics --dynamic-type-matrix \
  --all-abilities --ability-matrix --reflection-matrix --class-matrix \
  --textbox-matrix --swagger-matrix --outcome-matrix --item-matrix \
  --reaction-matrix --complex-matrix --long-battles --interactions 512
```

Build both ROMs after code changes and run focused meaningful regressions first.
Broaden validation when the change, a failure or an unresolved concern warrants
it. Repeating the same large sweep is not a substitute for new targeted
behavioral assertions. The separate every-move/every-ability Cartesian audit,
a full campaign playthrough and physical-hardware validation were not performed.

## Deliverables

1. An independent assessment of the nine fixes and their tests: correct,
   incomplete, regressive or dependent on an unresolved rules assumption.
2. Confirmed additional defects, fixed with focused native regressions.
3. A report with severity, current file/line, reproduction, expected/actual
   behavior, code cause, fix, controls, tested build identity and exact results.
   Explain which previous coverage missed each issue.
4. Separate lists for unconfirmed hypotheses, retained custom/legacy behavior,
   harness issues and text issues that remain report-only under `AGENTS.md`.
5. Updated relevant project notes and a concise final account of changes,
   validation and remaining uncertainties. Record what was not tested. Avoid
   claiming passing matrices prove that every interaction is correct.

Proceed autonomously on confirmed, reversible fixes within this scope. Preserve
unrelated work and report genuine rules ambiguities without blocking independent
audit work.
