# Octazooka verification — October 3, 2026

Rebuilt the current source and ran actual battles in the debug ROM. The playable and debug ROMs in the project root now contain this tested change, with matching symbol and map files. Existing save files were unchanged.

Octazooka has one secondary-effect roll that lowers Defense and Special Defense by one stage together. It does not lower accuracy. All 31 focused battle regressions passed.

Exhaustively tested every possible secondary-effect roll, while keeping unrelated battle rolls fixed so the attack hits. Both defenses dropped for rolls 0–50 and neither dropped for rolls 51–255: 51/256 (19.921875%), the engine's standard encoding of 20%. Exactly one secondary roll occurred in each battle. Serene Grace doubled the threshold: rolls 0–101 succeeded, 102–255 failed (102/256). All 512 sweep battles matched their expected results.

Verified player and enemy attacks, misses, Protect, Water Absorb, intact and broken Substitute, Mist, Shield Dust, Clear Body, White Smoke, Contrary, Mold Breaker, Infiltrator, stat-stage minimums and maximums, and knockout behavior. Dire Claw's shared command retained its existing status effect.

Found and fixed a missing Sheer Force registration for the new effect. Sheer Force now removes both drops, boosts damage, and prevents Life Orb recoil as expected. The relevant cases failed before the fix and passed after rebuilding.

Permanent regressions: `tools/battletest/tests/66-octazooka.yaml`.
Detailed battle results: `results.json`.
Per-roll outcomes: `chance-sweep.json`.
ROM checks: `rom-verification.json` and `rebuild-verification.json`.

Follow-up: expanded ability tests found and fixed Defiant/Competitive reactions. All 141 expanded regressions and 512 chance-roll battles passed on the updated build. See [expanded ability report](../move-abilities-2026-10-03/report.md).
