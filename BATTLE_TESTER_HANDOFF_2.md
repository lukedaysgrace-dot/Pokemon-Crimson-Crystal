# Battle Tester — status handoff #2

**For:** the next Claude (Fable) session
**From:** the session of 2026-08-09 (work PC), updated same evening, then
**completed at home 2026-08-09 night**

> **Update, home session (2026-08-09 night): the suite is COMPLETE.**
> `make test` = **74 passed / 0 failed / 0 skipped in ~26s**: 7 smoke +
> 20 audit regressions (every seed test from the August audit now runs,
> none skipped) + 47 ability-checklist cases (Phase 4). Along the way the
> tester caught its **second real engine bug**: `BattleCheckRampage_Core`'s
> fatigue path used `hl` after three `callfar`s — but the callfar/farcall
> macros load their *target address* into hl, so `set SUBSTATUS_CONFUSED,
> [hl]` wrote bit 7 into a ROM address (an MBC register poke) and **Thrash
> fatigue confusion never landed for ANY user** (the suspicious lead from
> the evening session, confirmed and fixed). New features: substatus setup,
> auto party-pick (faint switch / Baton Pass / U-turn in auto mode),
> trainer battles with a switching AI, no-flee for tester wilds, a `wram()`
> assertion accessor, and PC-symbolized timeout errors. Acceptance pass
> verified on three fixes (StatDown clobber, rampage clobber, Rest/
> Insomnia): reverting each fix makes exactly its guarding tests fail.
> **New release ROM baseline md5: `d2b124fefd068fe48b5006ca267a747a`**
> (the rampage fix legitimately changed it; with only that fix reverted a
> clean rebuild reproduces the previous `d9142604...` baseline exactly).

**Supersedes:** the build plan in `BATTLE_TESTER_HANDOFF.md` — that doc's
architecture was implemented with deviations noted below. Read this one
first; read the original for background and the full seed-test rationale.

---

## Where things stand: Phases 1–4 all built and verified

`make test` on this commit: **74 passed, 0 failed, 0 errored, 0 skipped**.

- `tests/00-smoke.yaml` — 7 harness-mechanics cases (Levitate, forced/
  seeded RNG, golden damage, Intimidate + Growl stat-drop canaries,
  weather override).
- `tests/10-audit-seeds.yaml` — the August audit as regressions, **all 20
  unskipped** (2a-i/ii Gale Wings order, 3 Natural Cure on a real AI
  switch in a trainer battle, 4a/4b/5a via the post-faint switch flow,
  6 Shed Skin/Toxic via substatus setup, 9 Baton Pass + control,
  10 Thrash/Berserk Gene × Own Tempo with controls).
- `tests/20-abilities.yaml` — Phase 4 backfill: 47 cases covering the
  checklist's HIGH section and every MEDIUM entry with a clean WRAM
  observable (absorbs, contact procs, stat-drop protects/reactions,
  status prevention, end-of-turn/weather, turn order). The not-covered
  tail (visual-only, golden-damage, gender-dependent) is listed with
  reasons in a comment block at the bottom of that file and in the csv.

Two real engine bugs found by the tester so far, both fixed:

1. **StatDown hl clobber** (evening session): `BattleCommand_StatDown`'s
   ability-drop marker (`.ComputerMiss`, wDisguiseBusted bit 6) clobbered
   `hl`, so every stat drop wrote its new stage into wDisguiseBusted.
   Fixed with push/pop in `effect_commands.asm`.
2. **Rampage-fatigue hl clobber** (home session): same disease, different
   organ — in `BattleCheckRampage_Core` (Battle Effect Overflow bank) the
   `callfar BattleCommand_SwitchTurn` / `SafeCheckSafeguard` sequence
   destroys the SUBSTATUS3 pointer (the macros do `ld hl, target`), so
   the fatigue `set SUBSTATUS_CONFUSED, [hl]` hit ROM. wPlayerConfuseCount
   was still written (de survives), which is what gave it away. Fixed by
   re-fetching the address after the calls; `Audit 10-control` is the
   regression. **Grep candidate for more of these:** any routine that
   holds a WRAM pointer in hl across a `callfar`/`farcall`.

## The landmines (do not re-derive)

1. **PyBoy masks MBC3 banks to 7 bits.** 4MB ROM (MBC30), tester lives in
   bank $8F → stock PyBoy maps it to $0F garbage. 4-line patch to
   `pyboy/core/cartridge/mbc3.py` + `pip install .` from the PyBoy source
   tree — exact diff in `tools/battletest/README.md`. Verified against
   PyBoy v2.7.0 (clone the tag, patch, build; the wheel is Cython-compiled
   so editing the installed .py does nothing).
2. **Forced RNG hangs reroll loops.** ~19 "roll until in range" loops in
   the engine. forced_low=$14 / forced_high=$B4 satisfy all of them;
   damage variation is pinned to max roll in forced mode; Metronome/
   multi-hit need seeded mode. Timeouts now SELF-DIAGNOSE: the runner
   samples the PC and prints the symbolized loop it is stuck in.
3. **`BATTLETYPE_DEBUG` is unusable** (skips InitBattleMon and entry
   abilities). Wild tester battles use `BATTLETYPE_NORMAL`; trainer
   tester battles use a SCHOOLBOY class shell (SWITCH_OFTEN AI, no items)
   with the OT party rebuilt from the request.
4. **Wild mons FLEE.** Anything in Always/Often/SometimesFleeMons
   (Quagsire! all roaming beasts) can end a wild tester battle on turn 1
   under forced RNG. The tester now suppresses wild flee when
   `hDebugActive` is set (`TryEnemyFlee` hook, core.asm).
5. **Constants files reuse values.** pokemon_constants restarts const_def
   after NUM_POKEMON for cosmetic forms (UNOWN_Z = 26 = RAICHU), and
   move_constants has BATTLEANIM_* overlapping real move ids. Every
   reverse map in `symbols.py` is first-definition-wins; keep it that way
   or species/move name assertions lie to you.
6. **Committed gfx vs regenerated gfx.** In a fresh container `make`
   regenerates `gfx/pokemon/tsareena/*` differently from the committed
   copies and the release md5 shifts. For baseline comparisons:
   `git checkout -- gfx/pokemon/tsareena/ && touch gfx/pokemon/tsareena/*`
   before the clean build (that is how the baselines above were produced;
   finizen/palafin outputs are untracked and regenerate consistently).

## Architecture as actually built

ROM side, all gated `IF DEF(DEBUG_BATTLE)` (release verified unaffected):

- `engine/debug/battle_tester.asm` — bank $8F. Request block consumption,
  party build (player AND trainer OT party via `wMonType`), post-entry
  overrides (stages, weather, screens, **substatus masks**, ability
  overrides), per-turn hook/state machine, auto party-pick, debug menu UI.
- `wram.asm` — request block in WRAMX bank 2: per-side blocks are now
  **30 bytes** (`dbg_SUBSTATUS` = 5 mask bytes at offset 25) and there are
  four of them (`wDebugPlayer1/2`, `wDebugEnemy`, **`wDebugEnemy2`** —
  nonzero enemy2 species = trainer battle).
- `engine/battle/core.asm` — 8 small hooks now: the original 5
  (_BattleRandom, BattleTurn loop, BattleMenu skip, ParsePlayerAction,
  InitEnemyWildmon) plus **PickPartyMonInBattle** (auto party-pick: faint
  switch, Baton Pass, U-turn), **InitEnemyTrainer** (farcall
  DebugModifyOTParty after ReadTrainerParty), **TryEnemyFlee** (no flee).
- `effect_commands.asm` — damage variation pin (landmine 2) + the
  StatDown push/pop fix (not gated - real engine fix).
- `effect_commands_core.asm` — the rampage-fatigue fix (not gated - real
  engine fix; this is what moved the release baseline).
- `start_menu.asm` — DEBUG item (release indexes untouched).

Protocol unchanged: `wDebugState` $01 menu → $02 init → $03 post-entry →
$04 parked at turn target → $05 done; `wDebugControl` 1 = continue,
2 = end battle.

Python side: `tools/battletest/{symbols,state,runner}.py` + `tests/` +
`README.md` (schema + all accessors documented there). New since the
evening: `substatus:` side field, `enemy2:` trainer mode, `wram('sym')`
and `weather_raw` in assertions, `Symbols.nearest()` PC symbolization,
first-wins reverse maps.

## Open items, in priority order

1. **Golden-damage backfill**: Merciless, Serene Grace, Sheer Force,
   Skill Link, Guts, Quick Feet, Dry Skin's fire +25% — each needs one
   verified damage number, the way audit 1b/2b were done. Mechanics all
   have working machinery; this is patience work with the calculator.
2. **True Roar drag-in tests** (audit 4's original shape): a wild enemy's
   Roar ends the battle by design, so these need the trainer-mode enemy
   to Roar — doable now that trainer battles exist, but enemy move
   scripting doesn't (the AI picks moves). Sketch: give the trainer mon
   ONLY Roar, or add an enemy move script analogous to wDebugMoveScript.
3. **Voluntary player switch in auto mode** (Regenerator, player-side
   Natural Cure): auto mode can only script moves, not "switch to slot
   N". Sketch: reserve move_script value $80+N as a switch command in
   DebugChoosePlayerMove.
4. **Acceptance pass for the 8 historic audit fixes**: done for 3 bugs
   (StatDown, rampage, Rest/Insomnia — revert fix → exactly the guarding
   tests fail). The remaining audit fixes live inside the big `2a7025ab`
   commit; reverting each hunk individually is the method, it is just
   tedious. The suite demonstrably measures, so this is due diligence,
   not doubt.
5. **hl-across-farcall audit** (from bug 2 above): grep the overflow
   banks for WRAM pointers held across callfar/farcall. Two of the same
   bug in one day says there is a third.
6. Checklist LOW section + "NOT IMPLEMENTED" entries: port as tests only
   when someone implements the abilities; do not chase (csv's words).

## How to resume anywhere

```bash
git clone https://github.com/lukedaysgrace-dot/Pokemon-Crimson-Crystal.git
apt-get install -y bison flex libpng-dev
git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds.git
cd rgbds && make -j4
mkdir -p ~/opt/rgbds-0.5.2/bin && cp rgbasm rgblink rgbfix rgbgfx ~/opt/rgbds-0.5.2/bin/
# local.mk points RGBDS at $(HOME)/opt/rgbds-0.5.2/bin/
git clone --depth 1 --branch v2.7.0 https://github.com/Baekalfen/PyBoy.git
# apply the MBC30 patch from tools/battletest/README.md, then:
cd PyBoy && pip install . --break-system-packages
pip install pyyaml --break-system-packages
make debug && make test   # fixture bootstraps itself, keyed on ROM hash
```

A note on committing from a Claude session on the work PC: git through
the OneDrive-mounted folder is slow enough that plain `git commit` times
out the bridge; `git add` first (it survives), then `git write-tree` /
`git commit-tree` / `git update-ref` in separate calls worked. Stale
`.lock` files from timed-out attempts were moved to `_to_delete/`.
