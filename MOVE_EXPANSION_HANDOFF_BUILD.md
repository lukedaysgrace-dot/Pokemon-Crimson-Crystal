# Move Expansion — build handoff (2026-07-28)

**Status: the ROM builds.** `make` runs to completion, links, and `rgbasm -Weverything main.asm`
is silent. Both blockers from the previous pass are closed, and the `predef CheckTypeMatchup`
bug is fixed everywhere it appeared.

`MOVE_EXPANSION_IMPLEMENTED.md` = what the change does. This file = how it was finished and
what's left to test.

---

## Toolchain

The Linux rgbds 0.5.2 in `tools/` is the good one (ELF, `rgbasm v0.5.2`; `rgblink`, `rgbfix`
and `rgbgfx` are all there and all report 0.5.2). Build with:

```
make RGBDS=/path/to/dir/containing/rgbds/binaries/     # trailing slash matters
```

- `local.mk` points at `$(HOME)/opt/rgbds-0.5.2/bin/`. Override `RGBDS=` on the command line
  or edit `local.mk`.
- `make tools` must succeed first (gcc builds `scan_includes`, `lzcomp`, `pokemon_animation`).
- The loose `rgbds/` folder in the repo root is **corrupt** — the tarball fails `xz -t` and the
  loose `rgbasm` has no section headers. Safe to delete; use `tools/` instead.
- A cold build regenerates ~2900 `.2bpp` files. That's the slow part; it's cached afterwards.

Reference: a full rebuild of every `.o` from the current tree produces
`pokecrystal.gbc`, md5 `536dce75b6a573d569d61f6619ac5ead`, 4 MB.

---

## Fixed in the earlier pass

| Problem | Fix |
|---|---|
| **Raging Bull compared an 8-bit species constant** — `cp TAUROS_PALDEAN_FIRE` truncated, since the dex is 501 species. | `BattleRagingBull_Core` uses `GetPokemonIndexFromID` + `LOW()/HIGH()`, matching the Mimikyu check in `abilities_engine.asm`. |
| **`Section 'Battle Core' grew too big`** | Stealth Rock's switch-in damage moved to `expansion_cores.asm` as `StealthRockDamage_Core`; `SpikesDamage` farcalls it. |
| **Dire Claw's jump table crossed banks** | `BattleDireClawStatus_Core` moved to `expansion_cores2.asm`, three farcalls instead of `rst JumpTable`. |
| **Freeze-Dry override bloated Effect Commands** | Moved to `FreezeDryOverride_Core` in `expansion_cores2.asm`. |

---

## Blocker 1 — `bankB` overflow (move descriptions) — FIXED

`MoveDescriptions` is now a two-chunk indirect table:

```
	indirect_table 2, 1
	indirect_entries VOLT_TACKLE, MoveDescriptions1
	indirect_entries NUM_ATTACKS, MoveDescriptions2
	indirect_table_end
```

- Moves 1–351 (through `VOLT_TACKLE`) stay in `data/moves/descriptions.asm`.
- Moves 352–413 (`OVERHEAT` → `DRAGON_TAIL`, the 62 new ones) moved to
  **`data/moves/descriptions2.asm`**, pointers and text together.
- `main.asm` gained `SECTION "Move Descriptions 2", ROMX`.

The pointers and the text they point at *must* stay in the same bank —
`LoadDoubleIndirectPointer` returns the chunk's bank in `b` and `PrintMoveDesc` uses it as the
text's bank. No description label was shared across the split, so nothing had to be duplicated.

Verified by walking the shipped ROM's indirect table by hand: index 351 resolves to
`0b:5459 VoltTackleDescription`, index 352 to `5c:7433 OverheatDescription`, index 413 to
`5c:7c36 DragonTailDescription` — all matching the symbol file.

`bankB` now ends at `$7f85`: **122 bytes free.**

---

## Blocker 2 — `Section 'Effect Commands' grew too big` — FIXED

`engine/battle/ai/switch.asm` (~1.5 KB) moved out into its own `SECTION "AI Switch", ROMX`
in `main.asm`. The `INCLUDE` in `effect_commands.asm` is replaced by a comment explaining why.

Two things had to change to make the move safe — both were found by scanning every identifier
in the file against the labels defined in the Effect Commands bank, not by eyeball:

1. **`switch.asm` → Effect Commands:** the only bank-local reference was the 9
   `call CheckTypeMatchup` sites. They now go through `AICheckTypeMatchup` (see below).
2. **Effect Commands → `switch.asm`:** `effect_commands.asm` had exactly one bank-local
   `call FindAliveEnemyMons`, in the Roar/Whirlwind `.trainer` path. It's now `farcall`.
   That's safe because the result comes back in the carry flag and `ReturnFarCall` pops to `bc`
   specifically so `f` survives.

`Effect Commands` now ends at `$7d46`: **697 bytes free.**

---

## The `predef CheckTypeMatchup` bug — FIXED

`Predef` preserves `bc`, `de`, `hl` and `f` — but **not `a`**, because `a` is the predef ID.
The target actually receives `a` = the low byte of the `hl` that was passed in. So
`ld a, ROCK` / `predef CheckTypeMatchup` scored a garbage attacking type, silently.

The replacement is a macro, `farcheckmatchup` (in `macros/rst.asm`), plus a 6-byte entry point
`CheckTypeMatchupFar` next to `CheckTypeMatchup` in the Effect Commands bank:

```
CheckTypeMatchupFar::
	ld h, d
	ld l, e
	ld a, b
	jp CheckTypeMatchup
```

The macro pushes `hl`/`de`/`bc`, moves the arguments into `b` and `de` (the pair `farcall`
*doesn't* clobber), farcalls, then restores. It is a drop-in for the old bank-local
`call CheckTypeMatchup`: same inputs in `a`/`hl`, same registers preserved. No new WRAM.

Call sites converted:

- `StealthRockDamage_Core` (`expansion_cores.asm`) — the Rock matchup that drives the
  1/32 … 1/2 damage tiering. **This one was live and wrong.**
- `FreezeDryOverride_Core` (`expansion_cores2.asm`) — the recompute against the target's
  non-Water type.
- `ai/scoring.asm:1423` (`AI_Smart_Encore`) — **pre-existing bug**, not introduced by the move
  expansion. The AI was reading a garbage type when deciding whether to Encore. Fixed too,
  since it's the same one-line change. `hl` was already push/popped around it, so nothing else moved.
- The 9 sites in `ai/switch.asm`, via a local `AICheckTypeMatchup:` wrapper (macro + `ret`) at
  the end of that file — cheaper than inlining 15 bytes nine times. `.unknown_moves` there
  relies on **both `hl` and `b`** surviving the call, which the wrapper honours.

`add_predef CheckTypeMatchup` is still in `data/predef_pointers.asm` (removing it would
renumber every predef after it) but is now commented as unusable.

Shim verified against the ROM bytes: `CheckTypeMatchupFar` at `0d:489d` assembles to
`62 6b 78 c3 38 48`, and `AICheckTypeMatchup` at `77:7fd1` to
`e5 d5 c5 47 54 5d 3e 0d 21 9d 48 cf c1 d1 e1 c9`.

---

## Link errors in the new battle animations — FIXED

Once the banks fit, `rgblink` surfaced the next layer: `BattleAnim_PhantomForce` referenced
`BattleAnim_PhantomForceBranch` and `...Branch2`, which were never written.

`PHANTOMFORCE` is `EFFECT_FLY`, so it takes the same three-way param split as `BattleAnim_Fly`
(`$1` = vanish on the charge turn, `$2` = reappear, anything else = the hit). Both branches
are now written, reusing `BattleAnim_Fly_branch_cbb12` for the sparkle and `ANIM_BG_1D` for
the ghostly fade.

While in there, four new animations were falling through into each other because they had no
`anim_ret`/`anim_jump` — `HeadlongRush`, `ShadowBone` and `DireClaw` all ended up playing
**Shell Side Arm's** animation, and `MagicalLeaf` played Signal Beam's with its palette
overwritten one instruction later. Each now jumps to a sensible existing body:

| Move | now plays |
|---|---|
| Magical Leaf | `BattleAnim_RazorLeaf`, green palette |
| Headlong Rush | `BattleAnim_DoubleEdge`, brown palette |
| Shadow Bone | `BattleAnim_BoneClub`, purple palette |
| Dire Claw | `BattleAnim_Slash`, purple palette |

Note the *empty* labels in `animations5.asm` (`IronDefense`, `HeadSmash`, `Nuzzle`,
`RagingFury`, `ForcePalm`, `Bounce`) are deliberate aliases and were left alone, as was
`EerieSpell`, which sets a palette and falls into `RagingBull` — that one works, because
`RagingBull` doesn't set a palette of its own.

---

## What to test first

Nothing here has been run on hardware or an emulator — it assembles, links and the data
layout checks out, but the behaviour is unverified.

1. **Overheat** — cheapest proof the description split works. Open the move summary text for
   any move at or past `OVERHEAT`; if the bank math were wrong you'd get garbage, not silence.
2. **Stealth Rock** — set it, then switch in a Fire type (should take 1/2), a Steel type
   (1/8 … 1/32) and a neutral type. This is the path the `predef` bug was breaking.
3. **Freeze-Dry** on a pure Water and on a Water/Ground target.
4. **Phantom Force** — both turns, plus what happens when the charge turn is interrupted.
5. **Enemy AI switching** — any trainer battle where the AI has a bad matchup. That exercises
   all nine `AICheckTypeMatchup` sites and the new bank boundary.
6. **Roar / Whirlwind against a trainer** — the one `farcall FindAliveEnemyMons` conversion.
7. Magical Leaf, Headlong Rush, Shadow Bone, Dire Claw — just look at them.

## Bank headroom, for the next feature

| Section | free |
|---|---|
| `Battle Core` | **5 bytes** — effectively full |
| `bankB` | 122 bytes |
| `Effect Commands` | 697 bytes |

`Battle Core` is the one to watch. The next thing added there will need the
`expansion_cores.asm` treatment.
