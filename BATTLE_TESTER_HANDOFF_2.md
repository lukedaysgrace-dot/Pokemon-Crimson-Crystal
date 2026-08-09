# Battle Tester — status handoff #2

**For:** the next Claude (Fable) session
**From:** the session of 2026-08-09 (work PC), updated same evening

> **Update, evening session:** `make test` is now **14 passed / 0 failed
> in ~5s** — the 7-test smoke suite plus audit regressions 1a, 1b, 2b(x2),
> 5b, 7 and 8, all verified green. The skipped Intimidate case is UNSKIPPED
> and passing: it exposed a real engine regression —
> `BattleCommand_StatDown`'s ability-drop marker (`.ComputerMiss`,
> wDisguiseBusted bit 6) clobbered `hl`, so **every stat drop wrote its new
> stage into wDisguiseBusted instead of the stat-level array** (and
> corrupted disguise state). Fixed with a push/pop in
> `effect_commands.asm`; `Growl lowers attack` added as the move-path
> canary. **This legitimately changed the release ROM** — new `make`
> baseline md5: `d9142604b53563d98c94df927c2590da`.
> New suspicious lead: **Thrash never fatigues** (7 turns, seeded RNG,
> SUBSTATUS_RAMPAGE stays set, no confusion for Own Tempo OR the Oblivious
> control) — see audit test 10's skip note. Sections below updated where
> marked; the "Open items" list is current.
**Supersedes:** the build plan in `BATTLE_TESTER_HANDOFF.md` — that doc's
architecture was implemented with deviations noted below. Read this one
first; read the original for background and the full seed-test rationale.

---

## Where things stand: Phases 1–3 are built and verified end-to-end

`make test` output on this commit:

```
PASS Levitate blocks Earthquake (0.4s)
PASS Lick paralyzes under forced_low (0.4s)
PASS Lick does not paralyze under forced_high (0.4s)
PASS Forced RNG gives exact reproducible damage (0.4s)
SKIP Intimidate fires on entry (under investigation - see below)
PASS Weather override applies (0.4s)
5 passed, 0 failed, 0 errored, 1 skipped in ~4s
```

That is: a request written from Python, consumed by the ROM, a full wild
battle fought with zero button-driven menus, deterministic damage
(Machamp takes exactly 13 from L50 Gengar's Lick, every run), proc/no-proc
isolation via forced RNG, and WRAM assertions at a parked, stable state.
Per-test cost ~0.4s thanks to save-state fixture reuse.

- `make` → release ROM **verified md5-identical** to baseline
  `a103957009bf4ab66dc9594d7b0e9217` (commit `cb2638b5`, clean object
  rebuild — do `rm -f *.o` etc. before comparing; stale objects produce
  false mismatches).
- `make debug` → `pokecrystal_debug.gbc` + own `.sym`/`.map`.
- Lucas's manual path works too: START → DEBUG opens a 3-page editor
  (player / enemy / options: species, level, ability slot+override, item,
  4 moves, DVs, HP%, status, weather, RNG). SELECT switches pages, arrows
  edit, A = +10, START launches the battle, B exits.

## The three landmines I hit (do not re-derive)

1. **PyBoy masks MBC3 banks to 7 bits.** This ROM is 4MB (MBC30) and the
   tester + PokemonNames live in bank $8F, which stock PyBoy silently maps
   to bank $0F. Symptom: farcalls to the tester land in Battle Core
   garbage. Fix is a 4-line patch to `pyboy/core/cartridge/mbc3.py` +
   `pip install .` — exact diff in `tools/battletest/README.md`. Any fresh
   machine (i.e. the home PC) needs this patch before anything works.
   The container had PyBoy 2.7.0; patch applies cleanly to that tag.

2. **Forced RNG hangs reroll loops.** The engine has ~19 loops of the form
   "roll BattleRandom until in range" (damage variation needs ≥217, wild
   enemy move selection needs `&3` to hit a non-empty slot, sleep turns
   need `&7≠0`, tri-status needs `swap&3≠0`, Metronome needs a valid move
   index...). A fixed return value that violates any reachable one is an
   infinite loop. Resolution: damage variation is pinned to max roll in
   forced mode by a gated patch in `effect_commands.asm`; forced_low=$14 /
   forced_high=$B4 satisfy the rest; Metronome/multi-hit tests must use
   seeded mode. If a future test hangs at state $03, sample the PC — it is
   almost certainly a reroll loop, and PyBoy's `register_file.PC` +
   the .sym file finds it in minutes.

3. **`BATTLETYPE_DEBUG` is unusable** (as the original handoff suspected):
   it skips InitBattleMon, player send-out AND all entry abilities —
   vanilla uses it for the catch tutorial. The tester uses
   `BATTLETYPE_NORMAL` wild battles and needed no battletype at all.

## Architecture as actually built

ROM side, all gated `IF DEF(DEBUG_BATTLE)`:

- `engine/debug/battle_tester.asm` — everything, in `SECTION ROMX,
  BANK[$8F]` (~2KB used of 6.5KB free; note bank $8F had 6,576 free, not
  the 23KB in the old handoff — the repo moved).
- `wram.asm` — request block + state in `WRAMX BANK[2]` (`wDebugMagic` at
  02:d700 area; parse the sym, addresses move). Party+dex backup blob
  lives here too; the real party is restored after every battle.
- `hram.asm` — `hDebugActive/RNGMode/RNGValue` + scratch (hot flags for
  battle-bank hooks; WRAM0 had zero slack).
- `engine/battle/core.asm` — 5 small hooks (~50 bytes of bank $0F's 109
  free): `_BattleRandom` (forced/seeded modes), `BattleTurn` loop top
  (farcall `DebugBattleTurnHook`: applies post-entry overrides once,
  counts turns, parks at target in a DelayFrame poll loop), `.loop1`
  (skip BattleMenu in auto mode), `ParsePlayerAction` (scripted move via
  the `.encored` path), `InitEnemyWildmon` (farcall `DebugModifyWildMon`
  rebuilds the wild mon's item/DVs/moves/personality/status/HP from the
  request, then re-derives stats + `wEnemyStats` mirror — before entry
  abilities, which is what makes entry-ability tests meaningful).
- `effect_commands.asm` — damage variation pin (landmine 2).
- `start_menu.asm` — DEBUG item (STARTMENUITEM_DEBUG=9, appended last so
  release indexes are untouched).

Protocol: state machine in `wDebugState` — $01 menu/fixture point, $02
init, $03 post-entry snapshot, $04 parked at turn target (assert here;
write `wDebugControl`=1 with a higher `wDebugTurnTarget` to continue, =2
to end the battle), $05 done. All verified including
continue-and-end-battle.

Python side: `tools/battletest/{symbols,state,runner}.py` + `tests/*.yaml`
+ `README.md` (the README documents the YAML schema and accessors).
Species/moves cross the 8-bit-ID boundary via the WRAMX-2 conversion
tables (`engine/16/`) — `state.py` mirrors `___conversion_table_load`
exactly. The harness auto-resolves `ability:` to the species' legal slot
(parsed from `abilities_for` in base stats) so entry hooks run the real
ability; illegal pairs become post-entry `wPlayerAbility` overrides.

## Open items, in priority order (updated)

1. ~~The skipped Intimidate test~~ **RESOLVED — it was a real engine bug**
   (StatDown hl clobber, see the update note at the top). The debugging
   recipe that cracked it, for reuse: hook the `.Hit`/`.Failed` exits of
   `StatDownSkipProtect` with PyBoy `hook_register`, then dump
   `register_file.HL` at `.Hit` — HL pointed at wDisguiseBusted ($C687)
   instead of wEnemyStatLevels ($C6DC).
2. **Thrash fatigue never triggers** — new suspicious lead, same shape as
   the Intimidate find. Seeded RNG, 7 turns of Thrash: SUBSTATUS_RAMPAGE
   never clears and no fatigue confusion for Own Tempo OR the Oblivious
   control. Check the rampage turn counter (wPlayerRolloutCount-family)
   decrement path. If real, audit test 10 unblocks after the fix.
3. **Player2 forced-switch flow** — unlocks audit 4a/4b/5a/9. Auto mode
   currently hangs on the "use next mon?" switch menu after a faint. Add
   a hook (or extend DebugChoosePlayerMove's approach) so a faint in auto
   mode auto-confirms the next party slot.
4. **Trainer-battle support** for audit test 3 (AI switch / Natural Cure)
   — wild mons never switch. Sketch: `Script_loadtrainer`-style setup vs
   a 2-mon trainer, then override `wOTPartyMon` structs post-init.
5. **Toxic/substatus setup** for audit test 6: add a substatus field to
   the request block (post-entry apply, like stages) or poke
   `wPlayerSubStatus*` from Python at the $03 snapshot.
6. **Acceptance pass**: for each green audit test, check out the pre-fix
   commit for its bug, `make debug`, and confirm the test fails there
   (original handoff's item 4 — the bar for the whole suite).
7. **Phase 4 backfill**: port `ability_testing_checklist.csv` (~150
   abilities of test intent) into YAML.
8. Quality-of-life: `wEnemyGoesFirst` accessor for move-order tests
   (audit 2a); an in-ROM watchdog that flips `wDebugState` to $FF on
   stuck battles would make reroll-loop hangs self-diagnosing.

## How to resume at home

```bash
git pull                       # or however the work PC's commit gets home
git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds.git
cd rgbds && make -j4           # checked-in rgbds binaries still segfault
# local.mk expects RGBDS at /root/opt/rgbds-0.5.2/bin/ - copy or override
make debug && make test        # first run bootstraps the fixture (~1 min)
```

Plus the PyBoy MBC30 patch (landmine 1) before `make test` — it fails
loudly without it (bootstrap never reaches the DEBUG menu).

A note on committing from a Claude session on the work PC: git through
the OneDrive-mounted folder is slow enough that plain `git commit` times
out the bridge; `git add` first (it survives), then `git write-tree` /
`git commit-tree` / `git update-ref` in separate calls worked. Stale
`.lock` files from timed-out attempts were moved to `_to_delete/`.
