# General game-code audit

Follow-up findings and validation are recorded in [the second sweep](second-code-audit.md).

Starting revision: `907fe9c0`. Scope: battle/move logic, map events and
transitions, sprite allocation/animation, player graphics, progression,
inventory, storage/save handling, evolutions and learnsets.

## Fixes

### Shell Side Arm could choose its weaker category

`BattleShellSideArm_Core` repeatedly halved all four stats until they fit in
one byte before comparing Attack × target Special Defense with Special
Attack × target Defense. Truncation could reverse the comparison or create
a false tie.

For example, stats `(257, 256, 256, 256)` should select physical:
`257 × 256 > 256 × 256`. The old implementation reduced every stat to 128
and selected special. Stats `(256, 257, 259, 260)` produced the opposite
error: `66560 < 66563`, but the old implementation selected physical.

The selector now compares exact 32-bit products. Equal products still
select special. It uses existing scratch memory and changes no save layout.
The AI shares the selector through its existing score-preserving wrapper.

Before the fix, the native regression sweep found 204 wrong selections in
5,834 player/enemy cases. Both rebuilt ROMs pass all cases, plus four AI
category and score-preservation checks: 5,838 per ROM.

### Cerulean Cave was incompletely covered by the map audit

The checker required `tilecoll` source and could not read the imported cave's
binary collision table. It now decodes those bytes through the project's
collision constants, rejects unknown bytes and incomplete rows, and reports
short tables without crashing during map traversal.

The cave's event-count comments now follow the repository's audit convention.
Its second floor also has the missing fourth object constant for the Dusk
Stone. These changes do not alter the event bytes or item placement.

Route 4's return anchor is deliberately one tile below its scripted cave
entrance. The audit now accepts that specific arrangement only while the
corresponding entrance coordinate event exists. Native tests confirm the
party gate, exit, internal warps and relocated Mewtwo encounter work.

### Portrait coverage had an obsolete dialogue count

The Route 25 Crystal portrait test expected five shared dialogue blocks,
although the map now uses six. All six already had correct portrait mappings.
The test now checks every discovered block without fixing their count.

New map-audit and Shell Side Arm regressions are included in
`make test-audit-state`.

## Verification

| Area | Result |
| --- | --- |
| Release and debug builds | Both assembled and linked successfully |
| Existing battle cases + every move/effect/ability sweeps | 3,331 passed; zero failures, errors or skips |
| Shell Side Arm | 5,838 checks passed in each ROM |
| Game-data audit | 45,418 invariants; 405 maps, 37 tilesets, 498 species, 168 wild tables |
| Move data | 442 moves, 233 effects, 218 battle commands; passed |
| Trainer data | 595 parties, 735 references, 321 Battle Tower mons; passed |
| NPC native graphics/facings | 35,603 checks; 106 walking and 13 standing sheets; passed |
| Trainer map sprite loading | 106 maps, 417 checks; passed |
| Outdoor sprite packing | All groups and 463 fishing-cove rosters passed |
| Playable characters | 400 checks passed |
| Variable sprites, weather and portrait colors | 979 checks passed |
| Portrait speaker coverage | 10 tests passed |
| Cerulean Cave native interactions | 128 checks passed |
| General overworld state | 3,278 checks passed |
| HP, friendship, party filters and Poke Seer | 37,824 checks passed |
| Usable-party handling | 6,040 checks passed |
| Capture and field-move gates | 13,413 checks passed |
| Inventory boundaries and save/load | 26,208 checks passed |
| Evolution sweep | 280 evolution rows, 1,920 checks passed |
| Breeding moves | 12,002 checks passed |
| Trainer move access | 190 checks passed |
| League progression | 3,974 checks passed |
| Route 9 blockers | 28 checks passed |
| PC storage and saves | 122 storage tests and 25 save tests passed |
| Map-audit negative controls | Removed gate, truncated collision tables and invalid collision bytes rejected |

Ability text, move expansion, learnset variety, save-layout, ROM resource,
Pokemon icon and map/trainer sprite static audits also passed.

Detailed logs and sprite captures are under `.tmpbuild/general-audit/`.
The baseline reproduction uses `.tmpbuild/general-audit/baseline.gbc` with its
matching symbol file. Generated ROMs and logs are ignored build artifacts.

This was automated source/data and emulator coverage with a small visual
spot-check, not a complete manual campaign playthrough or hardware test.
Emulator fixtures used private memory and did not load or modify player saves.
