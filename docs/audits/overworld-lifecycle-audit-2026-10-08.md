# Overworld, lifecycle, inventory and progression audit — 2026-10-08

Reference commit: `5e9d0c9d` (latest ability fixes). This pass prioritizes
progression and persistent state, then evolution/breeding/storage, map travel,
inventory boundaries and EXP screening. It found three player-facing defects,
one defective unused timer helper, and an EXP audit-tool omission.

## Corrections

### Traded party members hiding the player's egg offspring

`_FindPartyMonThatSpeciesYourTrainerID` checked the owner of only the first
matching species. A traded Togepi/Togetic ahead of the player's own matching
Pokémon caused Elm to reject the party. The lookup now continues through all
matching party members and succeeds when any has the player's trainer ID.
All 1,093 foreign/owned/other-species configurations in parties of size 0–6
are exercised through the compiled routine.

### Elm rejecting Togekiss

Both Elm egg-check routes accepted Togepi and Togetic, but omitted Togekiss.
Evolving the offspring fully before returning could prevent the Everstone
reward route. Both compiled script branches now recognize owned Togekiss;
foreign offspring alone still fail the ownership check.

### Daily weather cache collisions

The saved weather key used `wCurDay | $B0`. This erased calendar bits and made
different days share a cache key. The cache now stores the full day byte and
uses previously unused bit 7 of `wWeatherDailyFlags` for validity. Daily resets
and timer initialization clear that bit, including on day zero.

Old saves have the validity bit clear and regenerate the cache once. The save
layout is unchanged. Regression coverage includes all 256 same-day keys,
formerly colliding transitions, legacy-cache migration, distinct regional
weather selections, day-zero invalidation, and native SRAM save/load.

### Elapsed-seconds helper ignoring minutes

`GetSecondsSinceIfLessThan60` loaded minutes without updating CPU flags before
its conditional jump. It could report seconds alone after one or more minutes
had elapsed. An `and a` restores the intended unit-limit check. **This helper
currently has no callers**; this is a latent routine defect, not evidence that
an active contest or phone timer was failing.

### EXP audit omitting clone species

`audit_exp_economy.py` keyed stats by filenames, missing the three clone species
whose compiled entries reuse original-species files. It now joins canonical
species order to the actual base-stat include order. All 495 species resolve,
and the trainer estimate has no unresolved clone warnings. The final-cap
label and live 2x trainer-multiplier documentation are also corrected.

The tool now explicitly labels its results as estimates: it buckets trainer
definitions by level and includes rematches/unused teams. Its late-Kanto
deficits do not prove a campaign grinding requirement. No speculative EXP or
availability balancing changes were made.

## Validation

Release MD5: `d5719710035d6aa60932d9157dc6d36b`.
Debug MD5: `f73e8f418f058f8b0d218ac9759a16a2`.
Both ROMs build successfully. The final progression/calendar suite gives
**686 failures on the preserved original ROM** and **2,235 checks with zero
failures on the corrected release ROM**.

| Pass | Result |
| --- | --- |
| Progression, daily flags, weather, elapsed calendar, fruit trees, level caps and Save/load | 2,235 checks, zero failures |
| Every compiled evolution row | 279 rows across 495 species tables; 1,913 checks, zero failures |
| Bag and PC item boundaries | 254 item IDs; 26,337 checks, zero failures |
| Native Safari fees, travel, exit, expiry and Save/Continue | 30 checks, zero failures |
| PC save/recovery | 25 checks, zero failures |
| PC storage and random operation soak | 122 checks; 2,021 routine calls, zero failures |
| Day-Care ability inheritance and egg creation | 21 checks; 820 routine calls, zero failures |
| Learnsets, reminder, family/utility tutors and compatibility | 4,114 checks; 2,198 routine calls, passed |
| NPC walking/runtime allocations | 112 sheets, 1,206 map objects; 33,637 checks, zero failures |
| Permanent battle regressions | 1,503 cases, zero failures/errors/skips |
| Static game-data audit | 44,865 invariants across 402 maps, 495 species and other tables, passed |
| Save layout/recovery audit | 185 checks, passed |
| Resources/audio/bank layout | 4,675 checks and 2,106 binary assets, passed |
| Remaining `make audit-static` audits | Ability text, moves, learnsets, trainers, icons, map and trainer sprites passed |

Progression checks execute all seven gym Rocket activation scripts at badge
counts 0–8, both Elm recognition routes, Everstone/Metal Coat full-pack retries
and duplicate-reward guards, every fruit tree's failure/retry/repeat/daily
renewal, midnight and 140-day calendar rollover, and level caps for both
difficulties at every badge count with/without Hall of Fame.

Evolution checks cover all implemented level, item, happiness, held-item,
stat-comparison and gender rows, including regional prerequisites. They verify
species, permanent personality, shiny/gender fields, item consumption, party
count and HP bounds, plus Everstone and held-item cancellation. No compiled
evolution rows currently use the generic trade/move/party methods.

Inventory checks cover capacity, 99-item stacks, stack splitting, full-pocket
failure, partial/final removal at first/middle/last positions, compaction,
adjacent-byte guards, and exact SRAM persistence of all pocket formats.

Safari checks use normal buttons and unpatched ROM routines. They verify
decline, insufficient funds, the exact fee, entry allowance, walking, fresh
Save/Continue without refills, voluntary exit through the lobby to Route 38,
exhausted balls, last-step expiry, unpaid re-entry refusal and party preservation.

## Repeatable checks and coverage limits

Run `make test-overworld BATTLE_TEST_PYTHON=python3`. Individual targets are
`test-overworld-state`, `test-evolutions`, `test-inventory`, and `test-safari-ui`.
The first three accept an optional ROM filename with matching `.sym` for
before/after reproduction. Test logs, baseline cartridges, Safari screenshots
and JSON results are under `.tmpbuild/overworld-audit/`.

Routine/script tests suppress presentation; evolution tests also suppress
post-evolution move-learning menus. Their core eligibility, flags, inventory,
species/stat and save routines execute normally. Safari stages initial
party/location/money and exhaustion boundaries, then uses native movement,
menus and scripts. All SRAM fixtures are private; player save/RTC files are
not loaded or modified.

The remaining highest-value pass is a complete button-only campaign using a
naturally obtained team, including rival/Elder/gym/Rocket gates, all HM travel,
blackouts, and Save/Continue during story transitions. Static map consistency
and the focused native travel checks do not prove every map is free of a
softlock. Balance/availability needs a verified one-time trainer and encounter
route before adjusting rewards or EXP from the screening estimate. The large
generated battle matrices, native fishing RTC, cable and release audio suites
from the preceding audits were not repeated here.
