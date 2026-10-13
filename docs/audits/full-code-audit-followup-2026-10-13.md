# Full audit follow-up — 2026-10-13

Starting commit: `035515c9` (`general fixes from audit`), following
`73b261de` (`new song to be used and a handful of small fixes`). The
checkout was clean before this pass. The earlier audit report was reviewed;
its ignored run logs were absent from this checkout. Its largest battle
matrix used the pre-fix build, and the ROMs initially on disk did not match
the report's final hashes. This pass rebuilds and tests the current source.

## Corrections

### Generated sprite assets

The committed frame tables did not match the current sprite sheets and
animation scripts. Across nine Pokemon, 157 animation instructions referenced
frames beyond the generated pointer table. Affected species: Amaura, Aurorus,
Fletchling, Fletchinder, Tinkaton, and the Squirtle/Charmander/Charmeleon/
Blastoise clones. Several tables contained no animation frame pointers at all.

The release/debug build regenerated frame tables, bitmasks, tilemaps and two
dimensions from the existing PNG sources. Related stale Gyarados/Milotic
data, four trainer portraits and their affected palettes were also refreshed
by the build. No PNG artwork or authored animation sequences were edited.

`tools/audit_resources.py` now checks ordinary and idle animation frame
references. The preserved committed tables reproduce 157 failures; the
regenerated current tables pass. Frame zero is the base picture, with the
remaining frames indexed through the generated pointer table.

### Last usable party-member guard

`CheckCurPartyMonFainted` previously accepted a reserve Egg with nonzero HP
as battle-ready and walked beyond the party for an empty party. It now checks
the species list, skips Eggs and returns immediately for an empty party.
Its callers include PC deposit/release, Day-Care, the Shuckie/mail hand-ins
and the optional between-opponents battle switch prompt.

This is a latent routine defect: ordinary Egg creation and storage decoding
set Egg HP to zero. The regression deliberately stages nonzero Egg HP;
it does not demonstrate an ordinary-play route that gives Eggs HP.

The original compiled routine reproduced 921 failures across the initial
6,036 checks. The fixed expanded regression passes 6,040 checks, including
every healthy/fainted/Egg party layout and selected slot, atomic PC refusals,
healthy versus Egg box replacements, and an empty party.

### Test constant parser

Last night's numeric `const_value` reset fix did not cover `const_def`.
Signed and hexadecimal starts were read as zero, and `1 << 3` was read as
one. For example, `DOWN` became 1 instead of 0, `MAPSETUP_WARP` became 0
instead of $f1, and `PAL_NPC_RED` became 1 instead of 8.

The parser now reads signed decimal/hexadecimal/binary literals and the
left-shift expression used by these files. Unsupported `const_def`/`const_skip`
expressions raise an error instead of silently accepting a prefix. Six real assembly
constants and a synthetic counter/skip fixture cover these cases.

### Emulator fixture identity

The harness keyed every fixture to the default debug ROM on disk, even when
an explicit alternate/release ROM had been loaded. Rebuilding that default
file while an emulator was running could also change its fixture identity.
Native and surrogate cartridges shared a cache prefix despite incompatible
controller state formats.

Fixture keys now use the original ROM bytes loaded by that emulator, and
the native cartridge has a separate prefix. A real alternate-ROM regression
checks its hash, distinct cache path, and stable identity after rewriting a
private copy of the file. The default debug-ROM key used by the full matrix
is unchanged.

## Additional permanent checks

- Expanded last night's party filters to every independently eligible slot
  mask crossed with every Egg mask, rather than only all-eligible parties.
  HP/friendship/Seer/parser/filter regressions: 37,824 checks, zero failures.
- Added release-ROM Level/Moon/Love Ball and HM gate tests: 13,413 checks,
  zero failures. These make the earlier report's uncommitted focused checks
  reproducible, including strict level-ratio boundaries, rate saturation,
  stored genders, all badge masks, pocket/story ownership, and party eligibility.
- Added `test-party-usable` and `test-capture-field` to `test-overworld`.
- Added native playback coverage for last night's Hudson Hawk track: all
  four channels stay active and repeat together every 2,688 audio-driver
  updates across two loops. The initial probe used video-frame timestamps;
  one audio update can cross that boundary, so synchronization is checked
  at the audio driver's own update counter instead. No music patch was needed.
- Added an optional `--no-render` automatic battle mode. CPU/PPU timing,
  interrupts, glyph destination hooks and gameplay assertions remain active.
  Native graphical suites continue using rendering. A paired smoke regression
  compares CPU PC, three WRAM regions, HRAM and observed text contexts between
  rendering modes; all eight cases are identical. This option reduces the
  lengthy matrix's runtime.

## Validation

Release and debug builds succeeded. All 59 standalone audit/test scripts
passed, with the two required native
emulator reruns described below. The final fixed-ROM battle matrix passed
20,748 cases with zero failures, errors or skips across six isolated workers.

Current ROM MD5 hashes:

- Release: `24e14bc3d45f218ba943f924890a19c6`
- Debug: `4d297461d64d699b54ea63800fd6fe4f`

| Coverage | Result |
| --- | --- |
| Full permanent/generated battle matrix on the fixed ROM | 20,748 passed; zero failures/errors/skips |
| Game-data audit | 44,910 invariants; 495 species, 402 maps, 256 items, 163 wild tables; passed |
| Linked resources, audio and animation references | 10,078 checks; passed |
| Save layout/recovery | 185 checks; passed |
| All other static audits | Ability text, moves, EXP economy, learnsets, trainers, sprites, icons, NPC walking; passed |
| HP/friendship/Seer/party masks/constants | 37,824 checks; passed |
| Last usable party guard and PC callers | 6,040 checks; passed |
| Capture modifiers and field HM gates | 13,413 checks; passed |
| Overworld progression/calendar state | 2,235 checks; passed |
| Every compiled evolution row | 279 rows; 1,913 checks; passed |
| Inventory boundaries/persistence | 254 item IDs; 26,337 checks; passed |
| PC storage/save and four graphical suites | 122 storage checks/2,021 calls, 25 save checks, 73 UI assertions; passed |
| Learnsets/tutors and Day-Care inheritance | 4,114 learnset checks; 21 inheritance checks/820 calls; passed |
| Battle probability boundaries | 44,032 outcomes in 172 groups; passed |
| Held-item and faint-update timing | 352 checks; passed |
| Native battle/session/trainer/wild menus | All passed; eight consecutive native battles |
| Save menu/reboot/Continue | 23 checks; passed |
| New Game rules | Eight configurations, 232 checks; passed |
| Battle Tower roster/battles/frontend | 23,233 roster checks, 104 battle checks, 72 frontend checks; passed |
| Fishing backend/boats/roster/dialogue/judging/native UI | All passed; 133 native UI checks |
| Safari native UI | 30 checks; passed |
| Release cries/audio/real RTC paths | 495 species; 1,517 checks; passed |
| New Hudson Hawk track and repeated audio/RTC checks | 42 focused checks; passed; includes ten new track checks |
| Link RNG and functional cable sessions | 16,384 synchrony checks; 63 trade/battle checks; passed |
| Stat animations and visual matrix | 56 stat scenarios; 120 visual scenarios/912 assertions; passed |
| Player variants/portraits/weather | All passed |
| Jasmine medicine quest | 98 checks; passed |
| Rocket toll gates and Mahogany shops | Both gate routes, losses, payments and all purchases; passed |

The shop/gate scripts initially failed before execution because the default
PyBoy installation lacked their required native MBC30 emulator. Both passed
with `PYTHONPATH=.tmpbuild/pyboy-link`. This was a test-environment issue.

Build logs, baseline ROM/symbols, old frame tables, reproduction outputs,
individual suite logs and result manifests are under
`.tmpbuild/audit-followup-20261013/`. Matrix worker logs are in the directory
identified by `battle-complete-final.log`; `final-results.json` lists the
59 completed standalone scripts and final matrix counts. An earlier rendered matrix was
interrupted when switching to the faster automatic mode; it is not counted
as a completed matrix. Tests use private SRAM/RTC state and do not replace
the player's saves.

## Scope and limits

Source review covers the two recent commits and surrounding persistent
Pokemon state, party/storage guards, capture/item routines, field gates,
breeding/evolution, scripts, battle entry/exit, and graphics/audio references.
Static audits cover the linked data/resources; generated battles cover
move/effect/ability/item classes, suppression, reflection, reactions,
long/mixed battles and text boundaries.

This is not a complete naturally played campaign through every story branch,
a proof of every state combination, or physical Game Boy/link certification.
Audio checks establish signal and termination, not subjective sound quality.
No save-layout, balance, species stats or story changes were made.
