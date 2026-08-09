# Battle Tester — status handoff #2

**For:** the next Claude (Fable) session, continuing at home
**From:** the session of 2026-08-09 (work PC)
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

## Open items, in priority order

1. **The skipped Intimidate test — possibly a real engine bug.** With
   player Gyarados/Intimidate entering a wild battle, PC hooks show
   `IntimidateAbility.intimidate_ok` IS reached during player entry, but
   `wEnemyStatLevels[ATTACK]` stays 7 at the $03/$04 snapshots. Either
   `AbilityLowerOppStat` fails at battle start vs wilds (check
   `wFailedMessage` and whatever gen-2 "can't lower yet" condition might
   apply), or something re-inits enemy stat levels after player entry in
   the wild flow, or the harness reads the wrong moment. Hook
   `AbilityLowerOppStat`/`LowerStat` and step it. Given the August audit
   fixed two Intimidate bugs already, do not assume the harness is wrong.
2. **Verify the audit seed tests** (`tests/10-audit-seeds.yaml` — all 14
   written, all skipped). Unskip one at a time; the acceptance bar is the
   original handoff's item 4: each should fail on its bug's pre-fix
   commit and pass on main. Tests tagged "needs player2 switch flow"
   need the second party mon path exercised first (built but unverified).
3. **Trainer-battle support** for audit test 3 (AI switch / Natural Cure)
   — wild mons never switch. Sketch: `Script_loadtrainer`-style setup vs
   a 2-mon trainer, then override `wOTPartyMon` structs post-init.
4. **Toxic/substatus setup** for audit test 6: the request block has no
   substatus field; either add one (post-entry apply, like stages) or
   poke `wPlayerSubStatus*` from Python at the $03 snapshot.
5. **Phase 4 backfill**: port `ability_testing_checklist.csv` (~150
   abilities of test intent) into YAML once the seed suite is green.
6. Quality-of-life: `wEnemyGoesFirst` accessor for move-order tests
   (audit 2a); an in-ROM "watchdog" that flips `wDebugState` to $FF on
   obviously-stuck battles would make hangs self-diagnosing.

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
