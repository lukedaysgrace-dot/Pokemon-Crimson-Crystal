# Battle Tester — build handoff

**For:** whoever picks this up next (written for a fresh session with no prior context)
**Requested by:** Lucas
**Date:** 2026-08-09
**Baseline commit:** `ffc9c8ed` ("learnset updates") — ROM md5 `fc95706e271ad907b2b45180d1c3d546`

---

## What we're building and why

Crimson Crystal now has ~156 abilities, ~504 species, the physical/special
split, held items, and 16-bit move plumbing. The August 2026 audit
(`CODE_AUDIT_2026-08.md`) found **eleven** real battle bugs — inverted turn
perspective on contact aftermath, `-ate` abilities reading garbage out of a
7-byte indirect table, Intimidate piercing Mist off a stale move-effect byte —
and every one of them was found by a human reading assembly line by line.

That does not scale, and it does not protect against regressions. The point of
this project is to make "does this ability actually work" a **question you can
answer in one second, repeatedly, forever.**

Three consumers, all sharing one mechanism:

1. **Lucas, by hand.** A debug menu in the ROM: pick both sides' species,
   level, ability, item, moves, HP, status, stat stages — and drop straight
   into battle. No walking to a trainer, no save-state juggling.
2. **Claude, interactively.** Same menu, driven by an emulator script, with
   screenshots — for "does this look right" checks the assertions can't do.
3. **Claude, automated.** A headless runner that sets up a battle, advances N
   turns, reads WRAM, and asserts. This is the part that catches regressions.

Layer 1 is what makes the project immediately useful. Layer 3 is what makes it
worth building.

---

## Environment: verified working, do not re-derive

All of this was tested end-to-end on 2026-08-09 in a clean Linux container.
**Read this section before you touch anything — the build has three traps.**

```bash
git clone https://github.com/lukedaysgrace-dot/Pokemon-Crimson-Crystal.git
```

The repo is public, so no file staging is needed.

### Trap 1 — the checked-in rgbds binaries segfault

`rgbds/rgbasm` and friends are committed but **do not run** (segfault
immediately; wrong glibc). The `rgbds-0.5.2-linux-x86_64.tar.xz` next to them
is **also corrupt** (`xz: Compressed data is corrupt`). Build from upstream
source instead:

```bash
apt-get install -y bison flex libpng-dev
git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds.git
cd rgbds && make -j4
```

Upstream v0.5.2 builds clean and matches what the ROM expects.

### Trap 2 — `local.mk` hardcodes an absolute path

`local.mk` contains `RGBDS := /root/opt/rgbds-0.5.2/bin/`. Either copy the four
binaries there, or override on the command line. Copying is less invasive:

```bash
mkdir -p /root/opt/rgbds-0.5.2/bin
cp rgbasm rgblink rgbfix rgbgfx /root/opt/rgbds-0.5.2/bin/
```

### Trap 3 — a harmless warning that looks like an error

`gfx/pokemon/kotora/anim.asm: no newline at end of file` prints on every build.
It is cosmetic. Ignore it (or fix it, it's one byte).

Then `make -j4` produces `pokecrystal.gbc` in about 90 seconds.

### Emulator

```bash
pip install pyboy --break-system-packages
```

Verified working with this ROM:

| Capability | Status |
|---|---|
| Boot to title, CGB mode | works (`PyBoy(rom, window="null", cgb=True)`) |
| `pokecrystal.sym` parse | **59,057 symbols** |
| Read WRAM by address | works (`pb.memory[0xC62E]`) |
| Write WRAM by address | works |
| `save_state` / `load_state` to `BytesIO` | works, **200,602 bytes** per state |
| Button input | works (`pb.button("a")`) |
| Framebuffer capture | works, `(144, 160, 4)` ndarray |

**PyBoy is accurate enough for damage/status/flag logic, which is all this
project asserts on.** If sub-frame timing or audio ever matters, swap to
SameBoy — but don't start there, PyBoy's Python API is worth a lot here.

---

## Repo facts you need before writing code

These were dug out by reading the source; they are not guesses.

### Abilities are derived, not stored

There is **no** `wBattleMonAbility` symbol. Abilities work like this:

- Every mon has a **Personality byte** in its party/box/battle struct
  (`MON_PERSONALITY`, `wPartyMon1Personality`, `wBattleMonPersonality`).
- Bits 5–6 select the ability slot. Bits 0–4 are the caught ball. Bit 7 reserved.
  From `constants/pokemon_data_constants.asm`:

  ```
  ABILITY_MASK   EQU %01100000
  ABILITY_1      EQU %00100000
  ABILITY_2      EQU %01000000
  HIDDEN_ABILITY EQU %01100000
  CAUGHT_BALL_MASK EQU %00011111
  ```

- `GetAbility` (in `home/abilities.asm`) takes `b` = personality, `c` = species,
  returns the ability constant in `a`/`b`. It reads `BASE_ABILITY_1/2/HIDDEN`
  out of `BaseData` via `LoadIndirectPointer`, and **falls back to slot 1 if the
  chosen slot is empty**.
- The *live* battle values are `wPlayerAbility` (`$C6xx`) and `wEnemyAbility`,
  set at switch-in.

**Consequence for the tester:** to select an ability you set the personality
bits and let the engine derive it — you do **not** write `wPlayerAbility`
directly, because switch-in will overwrite it. For testing an ability on a
species that doesn't legally get it (useful!), provide an explicit override
that writes `wPlayerAbility`/`wEnemyAbility` *after* the entry hooks run.
Support both; they test different things.

### The battle struct

From `macros/wram.asm` — `wBattleMon` is at `$C62C`, `wEnemyMon` at `$D206`:

```
Species db | Item db | Moves ds 4 | DVs dw | PP ds 4 | Happiness db
Level db | Personality db | Status ds 2 | HP dw | MaxHP dw
Stats (big endian): Attack dw Defense dw Speed dw SpclAtk dw SpclDef dw
Type1 db | Type2 db
```

Useful anchors already confirmed: `wBattleMonHP` `$C63F`, `wBattleMonSpecies`
`$C62E`, `wPlayerStatLevels` `$C6D4`, `wEnemyMonHP` `$D202`, `wCurPlayerMove`
`$C6E3`, `wCurEnemyMove` `$C6E4`, `wBattleWeather`, `wPlayerScreens`,
`wPlayerSubStatus1..5` (`$C668`–`$C66C`), `wEnemySubStatus1..5` (`$C66D`–`$C671`).

Don't hardcode any of these — parse `pokecrystal.sym` at runtime. Addresses
move every time a section grows.

### Free ROM space

Parsed from `pokecrystal.map` (`SLACK:` lines per bank):

| Bank | Free |
|---|---|
| **$8F (143)** | **23,473 bytes** |
| $8E (142) | 4,190 |
| $8D (141) | 2,981 |
| $8C (140) | 2,323 |
| $84 (132) | 2,188 |

Only 10 of 144 banks have ≥1 KB free. Battle-adjacent banks are *full*: `$43`
and `$54` have **1 byte** each, `$01` has 2, `$0C` has 4.

**Put every byte of debug code in bank `$8F`.** It has room for the whole
feature and then some. Do not add anything to a battle bank — the audit already
noted the Battle Core bank is tight enough that a rework had to *save* 7 bytes.

### `BATTLETYPE_DEBUG` already exists — investigate before reusing

`constants/battle_constants.asm` defines `BATTLETYPE_DEBUG`, checked in three
places: `engine/battle/core.asm:59`, `:3797`, `:5066`, and
`engine/items/item_effects.asm:695`.

**Read all four sites before deciding to reuse it.** Vanilla's debug battletype
suppresses certain behaviour, and if it suppresses something we're trying to
test, the tester would silently pass on broken code. If any suppression is
relevant, define a fresh `BATTLETYPE_TESTER` instead. Write down what you found
either way.

---

## Architecture

Three layers, built in this order. Each is independently useful — do not start
layer 3 before layer 1 works.

```
  Layer 1   in-ROM debug battle menu        (Lucas uses this by hand)
              |
              +-- shares the setup routine with --+
                                                  |
  Layer 2   setup request block in WRAM + apply routine + sync markers
              |
  Layer 3   tools/battletest/ Python runner      (Claude uses this)
```

### Layer 2 is the important design decision

The naive approach is to have Python poke `wBattleMon` fields directly. **Don't.**
The engine has invariants — stats are derived from DVs, level and base stats;
party and battle structs must agree; type fields come from base data. Raw pokes
produce impossible mons and you end up debugging the tester instead of the game.

Instead: define a **request block** in WRAM (bank `$8F`'s WRAM if convenient,
or a fixed scratch region), which the harness fills in and the ROM *applies*
using the engine's own code paths.

```
DebugBattleRequest:
  .magic          db   ; $CC — harness sets, ROM clears on consume
  .playerSpecies  db
  .playerLevel    db
  .playerAbilSlot db   ; ABILITY_1 / ABILITY_2 / HIDDEN_ABILITY
  .playerAbilOverride db ; 0 = none; else force wPlayerAbility post-entry
  .playerItem     db
  .playerMoves    ds 4 ; 16-bit move IDs -> see note below
  .playerDVs      dw
  .playerHPPct    db   ; 0-100, applied after stat derivation
  .playerStatus   db
  .playerStatLvls ds 7 ; BASE_STAT_LEVEL (7) = neutral
  ... same block for enemy ...
  .weather        db
  .playerScreens  db
  .enemyScreens   db
  .turns          db   ; how many turns to auto-advance
  .rngMode        db   ; see RNG section
  .rngValue       db
```

**Moves are 16-bit in this codebase** (`NUM_ATTACKS` is checked against `$3fff`
in `constants/move_constants.asm`). Size the move fields accordingly — 8-bit
move IDs will silently truncate anything past 255 and you will lose hours.

Apply order matters and is easy to get wrong:

1. Build both mons through the **engine's own** init paths (`InitBattleMon`,
   `LoadEnemyMon` in `engine/battle/core.asm:3986` / `:6193`) so stats, types
   and PP are derived correctly.
2. Let switch-in / entry abilities run normally — Intimidate, Drizzle and Trace
   firing is often exactly what's under test.
3. **Then** apply overrides: HP percentage, status, stat stages, ability
   override, weather, screens.

Getting this backwards (overrides before entry hooks) means entry abilities
clobber your setup, and half your tests quietly test nothing.

### Sync markers — do not frame-count

The harness must know when the ROM has reached a known state. Frame-counting is
fragile and will break the first time an animation length changes.

Have the ROM write a `wDebugState` byte at defined milestones:

| Value | Meaning |
|---|---|
| `$00` | idle / not in tester |
| `$01` | menu open, awaiting request |
| `$02` | request consumed, battle initialising |
| `$03` | both mons in, entry abilities done — **pre-turn snapshot point** |
| `$04` | requested turn count complete — **assertion point** |
| `$05` | battle ended early (faint/flee) |
| `$FF` | error — request rejected as invalid |

The Python side polls this byte between ticks with a frame ceiling. Clean,
robust, and it makes failures debuggable instead of mysterious.

### RNG determinism

`BattleRandom` (`home/random.asm:31`) trampolines to `_BattleRandom` in another
bank. Add a hook: when `wDebugRNGMode` is non-zero, return `wDebugRNGValue`
instead of advancing the PRNG.

Three modes, all needed:

- **Forced-low** — every chance-based effect procs. Tests "does the proc work at all".
- **Forced-high** — nothing procs. Tests "does the *absence* path work" (this is
  where Magic Bounce bug #7 lived).
- **Seeded** — normal PRNG from a fixed seed. Tests distributions; run 1,000
  iterations and assert a 30% effect lands within a sane band.

Most tests want forced mode. Damage rolls also go through `BattleRandom`, so
forced mode gives **exact, reproducible damage numbers** — which is what makes
`assert enemy.hp == 154` a legal assertion instead of a range check.

---

## Build integration

Gate everything behind a define so the shipping ROM is untouched:

```make
debug: RGBASMFLAGS += -DDEBUG_BATTLE
debug: pokecrystal_debug.gbc
```

Requirements:

- `make` → `pokecrystal.gbc`, byte-identical to today. **Verify this with md5.**
  A tester that changes the real ROM is a liability.
- `make debug` → `pokecrystal_debug.gbc` + its own `.sym`.
- The harness always uses the debug build.

Entry point for Layer 1: add a **DEBUG** item to the start menu, present only
under `DEBUG_BATTLE`. `engine/menus/start_menu.asm` is the place; follow the
existing item pattern rather than inventing one.

---

## Test case format

Plain YAML in `tools/battletest/tests/`. Readable by Lucas, diffable in git,
and trivially loadable in Python. Keep the schema boring.

```yaml
- name: Levitate blocks Earthquake
  player: { species: GENGAR,  level: 50, ability: LEVITATE }
  enemy:  { species: MACHAMP, level: 50, moves: [EARTHQUAKE] }
  rng: forced_low
  turns: 1
  assert:
    - player.hp == player.maxhp

- name: Life Orb recoils on the attacker after a contact move
  player: { species: TAUROS,  level: 50, item: LIFE_ORB, moves: [BODY_SLAM] }
  enemy:  { species: SNORLAX, level: 50, moves: [SPLASH] }
  rng: forced_high        # no flinch, isolate the recoil
  turns: 1
  assert:
    - player.hp < player.maxhp
    - enemy.hp_lost_from_recoil == 0
```

Assertion expressions should resolve against a symbol-backed accessor
(`player.hp` → read `wBattleMonHP` big-endian, etc.), not raw addresses. Write
that accessor once, in `tools/battletest/state.py`.

**Fixture reuse is what makes this fast.** Boot once, `save_state` at
`wDebugState == $01` (menu open), then `load_state` for every case. Measured:
200,602 bytes per state, so keep it in memory. This is the difference between
~1 second per test and ~30 seconds per test — at 400 tests, it's the difference
between a coffee break and an afternoon.

---

## Phase plan

Ship each phase working. Do not build all three and then debug.

### Phase 1 — in-ROM debug battle (Lucas can use it)

- `engine/debug/battle_tester.asm`, `SECTION "Debug Battle", ROMX, BANK($8F)`
- Start menu entry under `DEBUG_BATTLE`
- Setup screen: species, level, ability slot, item, 4 moves, DVs for both sides
- Launch into battle
- `make debug` target; `make` output md5-identical to baseline

**Done when:** Lucas can pick Gengar/Levitate vs Machamp/Earthquake from the
menu and watch it fail, without touching a save state.

### Phase 2 — request block + sync markers

- `DebugBattleRequest` in WRAM, magic-byte handshake
- Apply routine using engine init paths, correct override ordering
- `wDebugState` milestones
- `wDebugRNGMode` / `wDebugRNGValue` hook in `_BattleRandom`
- Menu populates the same block, so both paths share one code path

**Done when:** a Python script writes a request, sets the magic byte, and the
ROM runs that exact battle — with no button presses at all.

### Phase 3 — the harness

- `tools/battletest/` — `symbols.py`, `state.py`, `runner.py`, `tests/`
- Fixture save-state reuse
- `make test` runs the suite, prints pass/fail, exits non-zero on failure
- On failure: dump the assertion, actual vs expected, and a screenshot

**Done when:** `make test` runs the seed suite below in under two minutes.

### Phase 4 — backfill

Port `ability_testing_checklist.csv` (already written — 12 KB of test *intent*
sitting in a spreadsheet) into real cases. This is the payoff: the list exists,
it just isn't executable yet.

---

## Seed test suite — the August audit, as regressions

Write these first. **Every one should fail on a ROM built from the commit
before its fix, and pass on current `main`.** That's the acceptance test for
the whole project — if the harness can't reproduce a known-fixed bug, it isn't
measuring anything.

| # | Test | From audit |
|---|---|---|
| 1 | Aftermath triggers when the holder is KO'd by a contact move | Bug 1 |
| 2 | Attacker's Life Orb recoils after contact; defender's does **not** | Bug 1 |
| 3 | Gale Wings gives +1 priority to Flying moves and to nothing else | Bug 2 |
| 4 | Refrigerate boosts Normal→Ice moves ×1.1875; Hidden Power excluded | Bug 2 |
| 5 | Enemy Natural Cure heals status on a voluntary AI switch | Bug 3 |
| 6 | Roar-ing in an Intimidate mon activates Intimidate | Bug 4 |
| 7 | Roar-ing out a Cloud Nine holder restores weather effects | Bug 4 |
| 8 | Intimidate does not bypass Mist | Bug 5 |
| 9 | Defiant answers Intimidate regardless of the enemy's previous move | Bug 5 |
| 10 | Shed Skin curing Toxic clears `SUBSTATUS_TOXIC` and the counter | Bug 6 |
| 11 | Magic Bounce does not reflect a Static proc back onto the holder | Bug 7 |
| 12 | Rest fails for Insomnia / Vital Spirit users | Bug 8 |
| 13 | Baton Pass resets Glaive Rush vulnerability, Rage Fist count, First Impression | Bug 9 |
| 14 | Own Tempo blocks Thrash fatigue confusion and Berserk Gene confusion | Bug 10 |

Tests 2, 8, 9 and 11 are the ones most likely to expose harness design flaws —
they depend on override ordering and RNG mode being right. Build those early,
not last.

---

## Gotchas

- **Moves are 16-bit.** Sized wrong, everything past move #255 silently breaks.
- **Big-endian stats.** The battle struct stores stats big-endian; HP too. Get
  this wrong and every damage assertion is nonsense.
- **`wStringBuffer1` lives in banked WRAM** (`$D000+`) — see the `rSVBK`
  save/restore dance at the top of `GetAbilityName`. Any debug UI printing
  names must do the same, or battle text breaks in confusing ways.
- **Don't grow a battle bank.** `$43` and `$54` have one free byte each.
- **`wDisguiseBusted+1` bit 5 is live data** (enemy 6th-slot busted-disguise
  marker). The audit already lost time to treating it as spare. Allocate real
  WRAM for debug state; don't scavenge bits.
- **Entry abilities are not noise.** Intimidate/Drizzle/Trace firing on setup is
  usually the thing under test. Apply overrides after them, never before.
- **Canon vs. Crimson Crystal.** This hack deviates deliberately — the Lumi
  stat port, Banette as Ghost/Normal, custom species like Mesmeria. When a test
  expectation depends on canon behaviour the hack has changed, **ask Lucas
  rather than assuming.** Encoding a wrong expectation is worse than no test.

---

## Definition of done

1. `make` produces a ROM md5-identical to the pre-change baseline.
2. `make debug` produces a ROM with a working in-menu battle tester.
3. `make test` runs the 14 seed tests in under two minutes, exits non-zero on
   any failure.
4. Each seed test demonstrably fails on the pre-fix commit for its bug.
5. `tools/battletest/README.md` explains how to add a test in under ten lines.

Item 4 is the one that matters. Everything else is plumbing.
