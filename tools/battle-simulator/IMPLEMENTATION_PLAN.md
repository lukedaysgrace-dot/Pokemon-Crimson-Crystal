# Crimson Crystal balance laboratory

## Architecture decision

Use `tools/battletest` and the compiled debug ROM as the battle engine. The
repository already provides deterministic RNG, native species/move index
translation, real stat construction, entry effects, scripted actions, turn
checkpoints, and semantic regression assertions. Reimplementing these in
Showdown would introduce a second interpretation of thousands of lines of
custom assembly. Showdown remains a useful UI reference, not a mechanics source.

Primary references: https://github.com/smogon/pokemon-showdown and
https://docs.pyboy.dk/ . No external species database supplies game data.

## Repository investigation

* Species order: `constants/pokemon_constants.asm`; base stats, types and three
  ability slots: `data/pokemon/base_stats.asm` and its included files.
* Move records: `data/moves/moves.asm`; effects and script pointers:
  `data/moves/effects*.asm`; execution: `engine/battle/effect_commands*.asm`
  and `engine/battle/move_effects/`.
* Custom abilities: `engine/battle/abilities_engine.asm`, including Gas,
  entry/switch/faint hooks, immunity, stat, damage and priority modifiers.
* Items: `data/items/attributes.asm`, battle core and ability item hooks.
* Type chart: `data/types/type_matchups.asm`; contact/critical lists and priority
  tables: `data/moves/`. Physical/special/status is explicit per move.
* Level/evolution tables: `data/pokemon/evos_attacks*.asm`; breeding, TM/HM,
  utility and technical tutor access: existing `tools/audit_learnset_variety.py`
  and `tools/audit_breeding_moves.py` parse these sources and donor routes.
* Native mechanics: `engine/battle/core.asm`, `effect_commands.asm`,
  `abilities_engine.asm`, `hidden_power.asm`, `home/battle.asm` and RNG routines.
  Enhanced types/stats, Fairy, expanded species/move indices, custom abilities,
  modern move categories and bespoke move effects rule out vanilla Crystal
  or modern-generation defaults.
* Harness boundary: debug request supports two members per side and eight
  streamed player actions; production party structures support six. New code
  must not represent independent duels as a 6v6 battle.

## Phases and acceptance gates

1. Extract current source with provenance, acquisition paths and fail-closed
   build validation. Record ROM, symbols, source hashes, emulator version and
   seed. Detect stale compiled data. Test roster/move completeness and legality.
2. Wrap native turn checkpoints in a reproducible scenario API. Record actual
   actions, HP, PP, statuses, boosts and ability events. Check invariants and
   preserve failures. Verify deterministic replay against direct harness runs.
3. Add multiple policies, bounded build search, paired ability/item/move
   comparisons, side-swapped matchups and opponent holdouts. Evaluate outcomes
   in the ROM; proposal heuristics never count as simulated performance.
4. Add incremental SQLite jobs, deterministic seeds, isolated workers, pause /
   resume, run comparisons, exports, confidence intervals and separately named
   offense/survival/tempo diagnostics. Unresolved and errored battles must remain
   visible and cannot be silently counted as losses or wins.
5. Add a local-only dashboard and CLI for agents and humans. Browse data, edit
   scenarios, inspect battle logs, run batches, compare builds and export.
6. Run unit and real-ROM integration checks, write a compatibility report and
   measured throughput. Scale only after correctness gates pass. Do not claim
   exhaustive optimality, exhaustive bug detection or million-battle performance
   without evidence.

## Accuracy boundaries

Executing the ROM reproduces its behavior, including its bugs. Assertions,
invariants, paired controls and the existing semantic suites provide separate
bug-detection evidence. A passed battle is not proof every interaction is correct.
No unsupported mechanic may be replaced with standard Pokémon behavior.
Ranking strength is conditional on policy, legal candidate pool, level, opponents,
format and sample size. Reports must include those conditions.

## Progress

* Source catalogue, compiled-record/weight checks and legal build validation implemented.
* Real-ROM scenario transport implemented: full teams, sixth-slot switching,
  scripts, weather/state setup, move/power observations, invariants and assertions.
* Tactical/aggressive/random policies, native enemy AI and two-sided two-turn
  native rollout implemented. Bounded build search and disjoint holdout validation
  implemented. Player heuristic switch planning and learned self-play deferred;
  explicit switches and native replacement/AI switching remain available.
* Version-pinned SQLite experiments, seed-paired side swaps, controlled variant
  comparisons, isolated workers, battle-boundary pause/resume, rankings, run
  comparisons and JSON/CSV export implemented.
* Loopback dashboard and agent CLI implemented. No dependencies added to ROM build.
* Source/unit checks, native scenario checks, a completed 6v6, pause/resume and
  serial/parallel replay checks passed in initial validation. Existing smoke and
  weight suites passed; the broader semantic sweep passed 3,459 cases with no
  failures/errors/skips. The separate native weight sweep passed 5,698 power checks.
* Million-battle scalability is an available workload, not a measured performance
  claim. Detailed logs are not compressed. Exhaustive mechanic certification,
  global build optimality and team-composition optimization are not claimed.
