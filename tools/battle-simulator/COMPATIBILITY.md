# Mechanics and verification boundaries

The backend executes the compiled Crimson Crystal debug ROM. No move, ability
or item effect is substituted with a standard-generation implementation.

Initial verification on 2026-10-23: **3,459 semantic regression cases passed,
zero failures/errors/skips** (1,096.3 seconds). This includes generated move,
effect and ability sweeps and 128 mixed interaction cases. Separate native
weight checks covered 498 species and 5,698 power results with zero mismatches.
The analyzer also passed 12 source/unit tests, nine native scenarios, checkpoint
and serial/parallel equivalence checks, and loopback HTTP workflow checks.
These are case-specific results, not certification of every possible battle.

| Area | Implementation | Independent evidence / limits |
| --- | --- | --- |
| Species, expanded indices, forms, stats, typing, ability slots | Extracted from current source; native construction and translation | Compiled comparisons for all 498 current slots |
| Moves and physical/special/status split | Extracted records; native effect scripts | Compiled comparisons for all 442 current moves; broad semantic sweeps available through `verify --suite deep` |
| Held items | Source attributes; native effect routines | Selection validates holdable IDs; not every interaction newly certified |
| Damage, accuracy, critical hits, STAB, immunities, statuses, stat stages, speed and priority | Native routines | Smoke regression checks and reproducible native scenarios; exhaustive combinations not certified |
| Abilities, entry effects, weather, switch/faint hooks | Native routines and original slot selection, including clones | Levitate and native entry regressions tested; every ability pair not independently verified by this release |
| Weight-based moves | Native `weight_power.asm`; dex weight data | 38 existing semantic scenarios; 498 native species weights; 5,698 power checks, zero mismatches in initial validation |
| Low Kick / Grass Knot | Native target-weight power | Boundary checks, target-side reversal, immunity, Transform and former flinch behavior covered by existing weight suite |
| Heavy Slam / Heat Crash | Native user/target weight ratio | Ratio boundaries, both sides, former secondary effects and AI preference covered by existing weight suite |
| One-versus-one | Native trainer battle, one real member per side | Completed battles, deterministic replay, ability immunity and exhausted-PP Struggle checked |
| Six-versus-six | Native six-member party structures in one continuing battle | Full battle completed; sixth-slot voluntary switch checked; added bench members use native debug construction before the first action |
| Hazards, switching, trapping and replacements | Native routines | Scenario transport supports explicit player switches; AI policy does not optimize player switching |
| Build legality | ROM source tables, ancestor access and tutors | Conservative move-route validation; exact encounter/evolution availability at a normalized low combat level is not proven |
| DVs / happiness / Hidden Power | Explicit native fields | Max DVs / zero stat experience default; selectable Hidden Power types supported; no invented natures or modern EVs |
| RNG | Actual seeded battle stream, initialized from the experiment seed | Full ten-byte initial state permits more than 256 seed variants; not certification of hardware RNG distribution |
| Bug detection | Native observations, HP bounds, safe structured assertions, existing semantic suites | Bugs without an applicable assertion/invariant can pass unnoticed |
| Build optimization | Bounded legal proposals, screening and disjoint opponent/seed validation | Heuristic search, no proof of globally optimal sets, no learned self-play or team composition search |
| Rankings | Actual resolved outcomes; separate formats and explicit exclusions | Conditional on tested builds, policies and opponents; conservative seed-pair uncertainty bounds |
| Pause / resume / workers | Battle-boundary SQLite checkpoints and isolated processes | Serial/parallel replay and committed-result preservation checked by `tests/experiments_checks.py` |

The debug transport creates two initial native trainer members and appends up to
four more with the ROM's own `DebugBuildPartyMon` routine at the initial pause.
It then sets the true party sizes and native personality/field settings. It does
not patch battle formulas, effect scripts, abilities, items or power routines.
The first active member's entry effects execute during normal battle setup;
bench construction happens afterwards. Mechanics that might inspect the entire
party during that first entry need an explicit scenario before relying on a
team ranking. A requested first-entry injected status/boost uses the existing
harness's post-entry overrides.

The harness runs an in-memory MBC5 header surrogate to access this ROM's expanded
banks under PyBoy 2.7. This is the existing harness behavior. Cartridge RTC,
cable multiplayer, presentation/audio quality, battle animations and save-file
gameplay are outside this analyzer's verification. The release ROM on disk is
not modified. The compiled debug ROM must be rebuilt when source changes.

Current evidence is saved in `output/native-checks.json`,
`output/verification-smoke.json`, `output/verification-weight.json` and
`output/verification-deep.json`, `output/experiment-checks.json` and
`output/http-checks.json`. Each semantic receipt pins the relevant source
and ROM hashes. Generated receipts and sample rankings are intentionally ignored
by Git, but remain available locally. Re-run verification after mechanics changes.
