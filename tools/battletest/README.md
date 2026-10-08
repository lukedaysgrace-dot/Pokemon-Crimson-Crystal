# Battle test harness

Automated battle testing for Crimson Crystal. The debug ROM
(`make debug` → `pokecrystal_debug.gbc`) contains an in-ROM battle tester;
this directory drives it headlessly with PyBoy and asserts on WRAM.

## Quick start

```bash
make debug          # build pokecrystal_debug.gbc (release ROM untouched)
make test           # run every YAML case in tools/battletest/tests/
make test-all       # YAML + every effect/move/ability + expanded ability text
make test-deep      # also ability/class/reflection matrices + 1,024 mixed battles
make BATTLE_TEST_JOBS=8 test-complete  # full suite with isolated emulator workers
python3 tools/battletest/runner.py --all-abilities -k "Ability sweep"
python3 tools/battletest/runner.py --interactions 128 -k "Interaction stress"
python3 tools/battletest/runner.py tests/00-smoke.yaml -k levitate -v
```

Requires: `pip install pyboy pyyaml pillow` (tested with PyBoy 2.7).

Parallel workers retain paired `result(...)` controls with their dependents
and cover every selected case exactly once. Worker logs are under `.tmpbuild/`.
The default remains one emulator. YAML `before_action` checkpoints can assert
state before a specified side's native move begins, e.g. `side: enemy`,
`turn: 1`, and an `assert` list. Missing checkpoints fail the case, so a skipped
or fainted action cannot silently satisfy a timing assertion.

First run bootstraps a fresh save into the DEBUG start-menu entry
(~1 minute) and caches it as a save state in `fixtures/`, keyed on the ROM
hash. Every test after that costs ~0.4s.

`make test-all` adds a generated smoke battle for every real move constant and
a behavioral scenario for every distinct `EFFECT_*` routine. The former catches
conversion-table gaps, rejected requests, crashes, and hangs; the latter and
the YAML cases assert damage, status, stat stages, switching, weather, priority,
post-battle effects, and move/ability interactions. `--all-abilities` adds
offense and defense execution for every ability, comparison with no-ability
controls under Neutralizing Gas, and Trace's copying restrictions against
every ability. These representative battles complement the targeted YAML
assertions; they do not enumerate every ability/move/opposing-ability triple.

`--ability-matrix` executes every ability against twelve common move classes,
compares suppressible abilities with no-ability controls under Neutralizing
Gas, checks Mold Breaker's bypass of ignorable defenses, and tests Skill Swap
and Transform against every ability. Gas comparisons include both battlers'
HP, status, stat stages, PP, items, screens, substatus, and the weather. Mold
comparisons isolate immediate hit mechanics; passive effects remain active.

`--class-matrix` asserts every listed punch, slice, pulse, and bite damage
boost, with Gas and opposing Mold Breaker controls, and every ball/bomb,
wind, and sound immunity with Gas/Mold bypass controls. Tackle serves as a
nonmember control for each class. `--reflection-matrix` tests complete
reflected status effects against accuracy, Protect, both Substitutes, and
Prankster/Dark boundaries. Targeted YAML cases also check reacting abilities,
two bouncers, forced switches, PP, scheduled actions, and following turns.

`--textbox-matrix` repeats every move and the offense/defense execution
scenarios for every ability with ten-character nicknames on both battlers.
The move scenarios use trainer battles for the longest enemy-name prefix.
The live glyph monitor checks the text as it appears, including scrolling.

`--swagger-matrix` tests all thirteen Attack stages against Contrary and
Own Tempo with ordinary, Mold Breaker, and Gas sources. Confusion still
applies when the boost is capped. Own Tempo's later cure under Mold Breaker
is distinguished from initial immunity by checking both rendered messages.

All battles monitor each rendered textbox glyph, including expanded names
and messages that scroll away before assertions run. A glyph outside either
18-cell textbox line fails the case. `tools/audit_ability_text.py` also checks
ability banners, descriptions, and expanded battle messages with maximum
nickname/name widths. Intentional custom ability rules remain the expected
behavior in this game's tests.

`--interactions N` adds a deterministic generated sweep that mixes random
species, four-move sets, abilities, held items, status, weather, trainer AI,
benches, knockouts, and voluntary switches. It is intended as a broader
state-transition/crash sweep after the exhaustive single-move checks.
Every mixed battle also asserts HP bounds, valid stat stages, exclusive
major status, and a cleared ability execution guard.

## Emulator bank handling

The runner creates a private MBC5-header surrogate so stock PyBoy can access
all of this MBC30 ROM's banks. It maps the game's SRAM bank selections and
steps the emulated CPU at the debug RNG hook. The original ROM is unchanged;
no PyBoy source patch is required.

For RTC-driven integration, `prepare_mbc30.py` compiles a separate copy of
PyBoy under `.tmpbuild/pyboy-mbc30/`. It extends MBC3 to eight-bit ROM banks
and SRAM banks 4-7, and provides a test clock-advance helper. The installed
emulator and the game ROM remain unchanged. This optional workflow needs
Cython, setuptools, and a C compiler; the standard battle tests do not.

`make test-gameplay-rules BATTLE_TEST_PYTHON=.venv/bin/python` runs all eight
New Game combinations through actual choice menus, Save, fresh emulator
boot, and Continue. Staged level-ready Pokemon then exercise native
evolution, stat calculation, ability lookup, PokeDB transfer, and save/load.

`make test-fishing BATTLE_TEST_PYTHON=.venv/bin/python` runs the contest
backend/text regressions and native dialogue/button integration. The latter
stages a private Friday party at the gate, then checks refusal, entry,
early-finish cancellation, rod-free casting, capture, judging, party return,
full-party boxing, and held-prize Save/Continue/claim. It advances the
emulator RTC to check timeout, Saturday midnight, and the following Friday;
it does not patch the game's time/event routines or write `wCurDay`.
Temporary results and captures are under `.tmpbuild/`.

`make test-weather BATTLE_TEST_PYTHON=.venv/bin/python` calls the release
ROM's `CheckAzaleaWeather` for all 256 calendar-byte values, on each Azalea
weather map and on one map outside it, and checks the Sunday/Tuesday/
Thursday/Saturday rain schedule against the weekday.

## Writing a test

```yaml
- name: Levitate blocks Earthquake
  player: { species: GENGAR,  level: 50, ability: LEVITATE, moves: [LICK] }
  enemy:  { species: MACHAMP, level: 50, moves: [EARTHQUAKE] }
  rng: forced_low
  turns: 1
  assert:
    - player.hp == player.maxhp
```

Side fields: `species` (constant name), `level`, `ability` (auto-resolves
to the species' legal slot so entry hooks fire; falls back to a post-entry
override for illegal pairs; `NO_ABILITY` explicitly forces none),
`ability_slot` (1/2/hidden), `item`, `moves`
(up to 4; omit to keep the level-up learnset), `dvs` (16-bit, default
$FFFF), `hp` (percent), `status_byte`, `stages` (`{atk: -1, spd: +2}`,
applied after entry abilities), `substatus` (list of SUBSTATUS_* names
without the prefix, e.g. `[MIST, TOXIC]` - ORed into the active mon's
SubStatus1-5 after entry; player1/enemy only). `player2` adds a second
party mon. `enemy2` makes it a TRAINER battle with a 2-mon enemy party
(vs a SCHOOLBOY shell - SWITCH_OFTEN AI, no items - so the AI will
actually use its bench; wild-mode rules like never-switching don't apply).
`enemy_class` (a `trainerclass` constant, e.g. `FALKNER`) swaps that shell
for another class, so its AI flags apply - FALKNER carries AI_SMART,
AI_ABILITIES and AI_ELITE, which is how `48-ai-new-abilities.yaml` tests
move scoring. The party is still replaced from the request.

Test fields: `turns` (pause for assertions after N turns), `rng`
(`forced_low` / `forced_high` / `seeded` / `off`), `rng_value`, `weather`,
`player_screens` / `enemy_screens` (raw screens byte, ORed in post-entry),
`move_script` (player move slot per turn, e.g. `[1, 2, 1]`), `setup_wram`
(post-entry raw symbol/value fixtures), `skip`.
Use `switch:N` in that list for a voluntary switch to one-based party slot
N (for example, `["switch:2"]`); normal trapping and switch-out hooks run.
Use `run` to attempt to flee through the normal battle escape path.
For a WRAM field that stores a runtime move ID, use `{move: WRAP}` rather
than its two-byte constant index. The named move must be loaded in a party
member's move set, for example `setup_wram: {wPlayerTrappingMove: {move: WRAP}}`.

Assertions are Python expressions over: `player` / `enemy` (`.hp`,
`.maxhp`, `.status`, `.item`, `.ability`, `.species`, `.moves`, `.pp`,
`.stats['attack'|'defense'|'speed'|'spclatk'|'spcldef']`, `.stat_levels`
(7 = neutral), `.screens`, `.substatus`), plus `weather` (0-4),
`weather_raw` (the full wBattleWeather byte - bit 7 = Cloud Nine
suppression), `turns_done`, and `wram('wAnySymbol')` for any byte the
sym file knows (e.g. `wram('wEnemyGoesFirst') == 0` = player moved first,
`wram('wPlayerRageFistHits')`). `wram16('wAnyBigEndianWord')` reads a
two-byte battle or party value such as `wPartyMon1HP`.
`player.start_hp` etc. give the pre-turn-1 snapshot (after entry
abilities, before any move).
`ability_seen('ANTICIPATION')` checks the debug-only semantic trace of
ability banners that were actually presented; `text_seen('NAME')` checks
dynamic `text_ram` strings rendered by battle text.
`textbox_seen('BecameConfusedText')` checks whether a static textbox template
was actually entered, which can establish an effect that is later cured.
`enemy_move()` names the move the AI picked on the last turn (wCurEnemyMove).

For paired control cases, give an earlier case an `id:` and read its retained
result with `result('id')`. For example, an ability damage case can assert
`enemy.start_hp - enemy.hp > result('control')['enemy']['damage']`. Retained
side data includes `damage`, `healing`, HP, status, item, ability, species,
moves, PP, stats, stat levels, screens, and substatus.
The top-level retained result also includes `weather`, `turns_done`, and the
seeded stream's `rng_count`, which can expose an unintended extra RNG roll,
plus `text_ram_count` for paired entry-message checks.

Auto-mode notes: a fainted player mon auto-switches to the next fit party
slot (no menu), which also covers Baton Pass and U-turn - so multi-mon
flows run unattended. Wild enemies never flee in tester battles (Quagsire
and everything else in the flee tables would otherwise end forced-RNG
tests on turn 1). The optional Shift-mode prompt and map trainer win/loss
text are skipped because generated tests have no interactive response or
map-script text pointers. If a battle times out, the error names the code the ROM
is spinning in (PC sampled and symbolized) - it is almost always one of
the BattleRandom reroll loops; switch that test to seeded mode.

## RNG modes

- `forced_low` (value $14): every chance-based effect procs, no crits,
  damage pinned to the maximum roll → assert exact numbers.
- `forced_high` (value $B4): nothing procs, moves still hit → isolates
  the no-proc path.
- The trainer AI's scoring rolls (AI_50_50, AI_80_20, the `cp N percent`
  chances) and its move tie-break go through `BattleRandom` (2026-08-19;
  identical to `Random` outside link battles), so forced modes pin AI move
  choice too: the smart branches are always taken under `forced_high`
  (always skipped under `forced_low`), and a tie is always broken in favour
  of the LOWEST move slot (`& 3 == 0`). A tie that does not include slot 1
  hangs the pick loop, so build AI cases around slot 1.
- `seeded`: deterministic PRNG stream from `rng_value` → same battle every
  run; use for multi-hit counts, Metronome, and anything with a
  pick-random-until-valid loop (those hang under a fixed forced value).

The forced defaults were chosen against the engine's reroll loops (enemy
move slot needs `&3==0`, sleep turns need `&7!=0`, tri-status needs
`swap&3!=0`); override with `rng_value` only if you know the loop budget.

## Complete interaction sweep

`make test-complete` runs the deep sweep plus the move outcome, held-item,
incoming-hit reaction, and long-battle matrices. It also runs the separate
probability, normal-menu, Tower-roster, Tower-battle, and link-RNG checks.
This is a lengthy emulator run; individual matrices can be selected with
`--outcome-matrix`, `--item-matrix`, `--reaction-matrix`, `--complex-matrix`, or `--long-battles`.
`-k` matches a literal name substring and automatically includes earlier
paired controls required by `result('id')` assertions.

`turn_assert` expressions are checked after each completed turn, including
HP/stat limits and presentation guards. Scripts longer than eight actions
are streamed into the ROM's final script slot while it is paused. This lets
the 24-switch and 32-turn cases execute their full action sequences.

Ability overrides for a species without that ability take effect after
entry. Use a legal holder, or explicitly set the relevant entry state, when
testing switch-in effects or Gas's faint-reactivation lifecycle.

The probability script enumerates all 256 RNG bytes through the actual ROM
routines; it tests thresholds rather than the distribution of hardware RNG.
The menu script uses normal button input with animations enabled. Tower
checks cover all 321 roster builds, entry rules, seven complete battle-wrapper
wins, a loss with forced party selection, and saved-party restoration. The
winning Tower fixtures are overleveled; the separate `test-tower-ui` target
tests the frontend's level selection and rewards. Link-RNG checks compare two independent
emulators using the retail link random stream; they do not emulate a cable
handshake or complete two-player battle.

## Tower frontend, release audio/RTC, and cable sessions

These are separate integration targets. Use `BATTLE_TEST_PYTHON=.venv/bin/python`
with `make` when dependencies live in the local virtual environment.

`make test-tower-ui` runs registration/refusals, all ten level rooms, a native
seven-battle streak, loss/retry, quitting, suspension/resumption, five reward
choices, full-bag recovery, and Save/fresh Continue. Private party/location
fixtures use boosted stats; battle wins and frontend routines are not stubbed.

`make test-release-av` prepares the private MBC30/RTC adapter and runs the
unmodified release ROM with sound enabled. It checks each playable species'
cry, channel cleanup, music/SFX, cartridge-clock midnight/week rollover, and
fresh boot/Continue, including midnight and the hardware 140-day rollover.
The private adapter corrects the old emulator's clock-register write signs
and time units; independent register-write/persistence probes check it.
Requires the normal PyBoy 2.7.0 dependency, NumPy,
Cython, setuptools, and a C compiler. Signal/termination checks do not certify
subjective sound quality. Seven recently changed cries and map music are
recorded as WAV files under `.tmpbuild/release-audio-rtc/` for listening.

`make test-link-session` needs a separate PyBoy 2.8.1 installation:

```sh
.venv/bin/python -m pip install --no-deps --target .tmpbuild/pyboy-link pyboy==2.8.1
make test-link-session BATTLE_TEST_PYTHON=.venv/bin/python
```

The preparer compiles a clock-driven serial module in that private copy
(Cython/setuptools/C compiler required). The installed emulator is unchanged.
The adapter only shifts when an internal clock is present; both external-clock
ports cannot complete a transfer. It synchronizes two processes at bit periods
during transfers and at coarser intervals while idle. Byte exchange and clock
gating are checked before the game sessions. This is a functional emulator
cable test, not physical-hardware or cycle-accurate cable certification.

Two unmodified release cartridges boot private debug-generated save fixtures,
then use ordinary reception/console controls. Logs, JSON results, and screenshots
are under `.tmpbuild/link-session/`. The fixtures include species and moves
above index 255, separate trainers, held items, and a deterministic winner.
No link, RNG, trade, or battle routine is stubbed. All new targets use private
SRAM/RTC files and do not write the player's cartridge save.

`make test-complex` runs 44 exact berry/ability-transfer chain regressions and
the added 1,008 combinations of Parental Bond/Skill
Link, seven attacks, both directions, six defender abilities, four defender
items, and three attacker items. It checks hit counts, exact stat stages,
item consumption, and exact Life Orb/contact recoil. Another 512 mixed cases
use a new seed, extra held items, and 12-turn scripts with checks each turn.
These mixed cases test state boundaries; they do not assert the complete
expected outcome of every randomly selected move.

`visual_matrix.py` uses native menus at all 20 textbox frames, three text
speeds, and animations on/off (120 scenarios). It captures active banners,
live and completed messages, and restored menus with ten-character names.
`--shard N --shards M` partitions this run without repeating cases. The
glyph monitor remains active throughout each scenario. Images are saved to
`.venv/visual-matrix/` for visual inspection.

`cove_sprite_checks.py` loads the real fishing cove at four viewpoints in
visitor and two contest-roster states (12 views, 216 map/roster/allocation checks).
The sprite audit also checks all 462 possible contest candidate rosters
plus the ordinary visitor roster. The cove uses its actual map objects for
allocation rather than the shared Olivine outdoor list.

## How it works (ROM side)

`make test-session` runs 32 Gas/faint/replacement/Trace/weather/item chains,
18 pre-move entry-item cases, and an eight-battle native-menu session. The
session keeps one party throughout, checks HP/PP/item/permanent-ability
persistence, switches through the party menu, reloads the overworld after
each battle, heals once, and verifies exact Pokemon SRAM save/load data three
times. Encounters are staged; this is not a complete story playthrough.
Captures are saved under `.venv/gameplay-session/`. Only the initial party
is built through the debug helper; automatic battle actions and debug party
restoration remain disabled throughout the session.

The session and complete targets also run `hp_item_update_checks.py`
(40 Speed/Trick Room/link-RNG scenarios and 24 suppression-ending faint
battles), `trainer_ui_checks.py` (native Set/Shift menus, simultaneous KOs,
mandatory/optional cancellation, and no reserves), `wild_ui_checks.py`
(escape, Arena Trap, and Master Ball capture through the Bag), and
`save_menu_checks.py` (native Save, a fresh emulator boot, Continue, and
walking on the reloaded map). These stage private fixtures and do not replace
a longer story playthrough. Each emulator uses temporary SRAM; the player's
cartridge save is untouched. New captures are under `.venv/trainer-ui/`,
`.venv/wild-ui/`, and `.venv/save-menu/`.

`engine/debug/battle_tester.asm` (bank $8F, `DEBUG_BATTLE` builds only).
The harness writes a request block in WRAMX bank 2 (`wDebugMagic`...)
describing both sides by true 16-bit species/move indexes, then sets the
magic byte. The in-ROM debug menu poll loop consumes it, builds the party
through `TryAddMonToParty`, stages a wild battle, and rebuilds the wild
mon from the request inside `InitEnemyWildmon` — before entry abilities,
so overridden abilities fire like real ones. `wDebugState` milestones
($01 menu, $02 init, $03 ready, $04 turn target reached, $05 done) are the
sync protocol; never frame-count. In auto mode the battle menu is skipped
and player moves come from `wDebugMoveScript`.

The player's real party and pokédex flags are backed up before the battle
and restored afterwards.
