# Code and runtime audit — 2026-10-12–13

Starting commit: `73b261de`. The checkout was clean before the audit.

Four groups of assembly defects were reproduced and corrected. A defect in
the test constant parser was corrected while building the regressions.
Release and debug ROMs both build successfully; no save-layout fields changed.

## Corrections

| Area | Before | After |
| --- | --- | --- |
| Battle friendship | `ChangeHappiness` compared the target's zero-based party slot with the party-menu cursor. Updating an active Pokemon could leave its live friendship stale; updating a reserve could overwrite the active Pokemon's friendship, affecting Return/Frustration. | Synchronize `wBattleMonHappiness` only when the target matches `wCurBattleMon`. |
| Poke Seer | `ReadCaughtData` compared only the first trainer-ID byte. A foreign Pokemon whose first ID byte matched the player was described as personally caught. | Compare both ID bytes before selecting the origin dialogue. |
| HP subtraction | When damage exceeded current HP, `RemoveHP` zeroed the high HP byte and the preceding permanent shiny/gender-flags byte, leaving wrapped low HP. | Saturate both HP bytes to zero and preserve status, permanent flags and maximum HP. |
| Party-filter helpers | Happiness/level filters shifted every result bit one position too far, so the following egg exclusion masked the wrong slots. An empty party underflowed the loop counter. The above-level filter selected levels at or below its cutoff. | Align the slot bits, reject empty parties, exclude eggs correctly, and select levels strictly above the cutoff. |
| Test constants | `_parse_constants` ignored explicit numeric `const_value = ...` resets, misreading friendship arguments and negative animation indexes. | Honor decimal, hexadecimal, binary and signed numeric resets. |

The HP underflow is a **latent helper defect**: the ordinary Softboiled/Milk
Drink menu currently rejects a donor with insufficient HP. The tests exercise
the actual helper's boundary behavior; they do not establish that normal menu
use could reach that underflow.

The two party-filter helpers also currently have no callers in map scripts;
their public special-command wrappers remain available. These are latent
routine defects, not evidence of an active campaign gate failing.

`tools/test_audit_state_regressions.py` executes all six party slots, HP borrow
and saturation boundaries, four shiny/gender flag combinations, active/reserve
friendship changes with every menu cursor, and all 256 low trainer-ID bytes
with matching and nonmatching high bytes. Seer formatting helpers alone are
suppressed for the origin-branch checks. HP and friendship writes run unchanged.

The final regression script reports **15,978 checks, zero failures** on the
fixed release ROM and **3,082 failures** on the preserved original release ROM.
Both runs use the corrected parser. Reproduce with:

```sh
make test-audit-state BATTLE_TEST_PYTHON=python3
python3 tools/test_audit_state_regressions.py path/to/original.gbc
```

The target is also included in `make test-overworld`.

## Validation

Final ROM MD5 hashes:

- Release: `48a108cada63a3d5e4a2382efb7e3f42`
- Debug: `787741b86d0296a5215ec0cb28f504de`

| Suite | Result |
| --- | --- |
| Fixed-ROM permanent battle cases plus every move/effect/ability sweep | 2,982 passed, zero failures/errors/skips |
| Complete initial battle matrix, including 1,024 mixed battles | 20,748 passed, zero failures/errors/skips |
| New HP/friendship/party-filter/Seer/parser regressions | 15,978 checks, zero failures |
| Static game-data audit | 44,910 invariants; 402 maps, 495 species, 256 items, 163 wild tables |
| Save layout and recovery audit | 185 checks, passed |
| Linked resources and audio | 4,692 checks; 2,107 binary assets, passed |
| Other static audits | Ability text, moves, learnsets, trainers, icons, map/trainer sprites and NPC walking passed |
| Progression, calendar, weather and save state | 2,235 checks, zero failures |
| Every compiled evolution row | 279 rows; 1,913 checks, zero failures |
| Bag/PC inventory boundaries and persistence | 254 item IDs; 26,337 checks, zero failures |
| PC storage and save/recovery | 122 storage checks, 2,021 routine calls; 25 save checks, passed |
| All four graphical PC suites | 73 assertions, zero failures |
| Day-Care ability inheritance | 21 checks; 820 routine calls, passed |
| Learnsets and tutors | 4,114 checks; 2,198 routine calls, passed |
| Capture modifiers: Moon/Level/Love Ball boundaries | 6,056 checks, zero failures |
| Field HM gates | All seven HMs, 256 badge masks, pocket/story ownership and egg/empty-party boundaries; 5,397 checks, zero failures |
| Battle probability thresholds | 44,032 outcomes in 172 groups, zero failures |
| Held-item timing and faint updates | 352 checks, zero failures |
| Native gameplay session | Eight consecutive battles; 179 checks, zero failures |
| Native battle/trainer/wild menus | 12 battle-menu scenarios/44 assertions; 75 trainer and 21 wild checks, passed |
| Save menu, reboot and Continue | 23 checks, zero failures |
| New Game rules/evolution/storage | Eight configurations; 232 checks, zero failures |
| Battle Tower roster, battles and frontend | 321 builds/23,233 checks; 104 battle and 72 frontend checks, passed |
| Native Safari and fishing | 30 Safari and 133 fishing checks, passed |
| Fishing backend and judging, boats, cove NPCs/dialogue | All suites passed |
| Release sound and real cartridge-clock paths | 495 cries; 1,517 checks, zero failures |
| Link RNG synchronization | 16,384 checks across 32 seeds, zero failures |
| Functional emulator cable trade/battle | Two release-ROM sessions; 63 checks, zero failures |
| Stat animations and visual matrices | 56 stat scenarios; 120 visual scenarios/912 assertions, passed |
| Player variants, portraits and portrait/weather interaction | All suites passed |
| Rocket toll gates and Mahogany shops | Both entrance/payment/battle/loss routes and every purchase passed |

Static/focused routine suites and native integration suites were repeated
after the fixes, including the party-filter mask correction. The 2,982-case
battle rerun uses that corrected build. The last level-cutoff correction
changed only one branch opcode in the unused helper (`$38` to `$30`) and the
ROM-header checksum bytes; a binary comparison confirmed every other byte
was identical. The expanded state regressions and save/resource audits were
then repeated on the final ROM hashes above. The larger initial battle matrix
uses the ROM loaded before the fixes.

Build logs, baseline ROMs, worker logs and per-suite outputs are in
`.tmpbuild/full-audit-*`. Test compiler dependencies and RTC/link adapters
were installed only in ignored workspace directories. Emulator tests use
private SRAM/RTC fixtures; they do not read or replace the player's saves.

## Coverage and remaining limits

Source review concentrated on persistent Pokemon state, battle/overworld
transitions, item and capture routines, conversion tables, map rewards,
evolution/breeding, storage, clocks, and recent Safari/audio/script changes.
Static audits cover the full linked data/resource tables. Generated battles
cover move effects, abilities, suppression, reflection, move classes, held
items, hit reactions, text limits, long battles and mixed interactions.

The checks do not constitute a complete naturally played campaign through
every story branch, a proof that every possible state combination is correct,
or physical Game Boy/link-cable certification. Audio checks verify signal
and termination, not subjective sound quality. No speculative balance or
story changes were made.

One screened reward concern did not warrant a patch: the key-item pocket
holds 25 entries, and there are exactly 25 supported unique key-item IDs.
A valid full pocket therefore already contains any offered key item.
