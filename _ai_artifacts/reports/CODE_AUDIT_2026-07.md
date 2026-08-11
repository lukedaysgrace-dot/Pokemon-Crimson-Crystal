# Code audit — July 2026

Scope agreed with Luke: custom code vs. vanilla pokecrystal, the ability system, and
the open items in the existing handoff docs. Fix policy: apply low-risk fixes, report
anything ambiguous.

Toolchain note: the repo's bundled `rgbds/` binaries are corrupt (see finding 3), so the
audit built with a clean upstream rgbds 0.5.2. Baseline ROM built clean before any
changes; final ROM builds clean with all fixes applied.

---

## Bugs found and fixed

### 1. Egg move pointer table was 16 entries short — **the significant one**

`data/pokemon/egg_moves.asm` declares:

```
EggMovePointers::
	indirect_table 2, 1
	indirect_entries MEW, EggMovePointers1          ; species 1-151
	indirect_entries NUM_POKEMON, EggMovePointers2  ; species 152-477
```

`EggMovePointers2` must therefore hold 326 pointers. It held **310**. Species 462–477
had no entry at all, so the lookup read past the end of the table into the
`ChikoritaEggMoves` move data that immediately follows and interpreted it as pointers.

Affected species — the most recently added batch:

> Shuppet, Banette, Archen, Archeops, Tirtouga, Carracosta, Litwick, Lampent,
> Chandelure, Joltik, Galvantula, Mawile, Noibat, Noivern, Salandit, Salazzle

Consumers are `engine/pokemon/breeding.asm:528` (hatching an egg) and
`engine/events/move_deleter.asm:548` (the egg-move reminder), so the symptom would be
garbage or invalid moves on hatched mons of these species, with a decent chance of a
hang or crash rather than just a wrong move.

**Fixed** in `data/pokemon/egg_moves_johto.asm`: appended 16 `dw NoEggMoves2` entries,
one per species, each labelled with its species name. Table now measures 326/326.

This is a data-entry gap, not a design problem — worth noting that if any of those 16
*should* have real egg moves, the entries are now in place and just need their pointers
swapped from `NoEggMoves2` to a real list.

### 2. Eighteen Pokémon animate frames that don't exist

The front-sprite animation system generates `frames.asm` per species at build time from
the sprite sheet. For 18 species, `anim.asm` / `anim_idle.asm` still reference frame
indices that the generated table doesn't contain, so the animation walks off the end of
that species' frame table into the next species' data.

Seventeen of them have a **completely empty** `frames.asm` (their `front.png` is a
single frame) while their animation scripts still reference up to frame 8 — leftover
vanilla animation data that wasn't updated when the sprites were replaced:

> ampharos, appletun, corvisquire, dragonite, flapple, gyarados, houndoom, ledian,
> mesmeria, octillery, remoraid, rookidee, sirfetch_d, teddiursabm, tyranitar,
> ursaringbm, weavile

**Fixed** by writing the same static animation that 31 other single-frame species in the
repo already use:

```
	frame 0, 16
	endanim
```

(frame 0 is the base picture and is always valid; only indices ≥1 come from the table.)

The eighteenth, **magnezone**, is a genuine off-by-one: its sheet has 3 extra frames but
`anim.asm` referenced `frame 4`. **Fixed** by clamping those two references to `frame 3`.
Flagging this one as a judgement call — the animation was clearly authored for 4 extra
frames, so the better long-term fix is to add a 4th frame to
`gfx/pokemon/magnezone/front.png` and revert the clamp.

### 3. `.gitattributes` silently corrupts binary files

Line 2 is `* text eol=lf`, which applies newline normalization to **every** file. The
`binary` rules further down only cover files with specific extensions, so anything
extensionless or with an unlisted extension gets mangled on commit.

This already happened: `rgbds/rgbasm`, `rgblink`, `rgbfix`, `rgbgfx` (no extension) and
`rgbds/rgbds-0.5.2-linux-x86_64.tar.xz` are corrupt **in git history**, not just in the
working tree. The tarball is 885,947 bytes against the official 885,960 — 13 bytes lost
to CRLF stripping. `rgbasm` segfaults immediately and reports "missing section headers".

**Partially fixed** — `.gitattributes` now declares `*.xz`, `*.zip`, `*.dll`, `*.exe`,
`*.gbc`, the `rgbds/*` executables and similar as `binary`, so this can't recur.

**Needs one manual step from you:** the committed blobs are already damaged and the new
rules don't repair them. Re-download rgbds 0.5.2 and re-commit those five files, or drop
them from the repo entirely and document the dependency in `INSTALL.md`. Anyone cloning
this repo today gets a non-functional toolchain.

---

## Verified correct — no changes needed

These were checked mechanically rather than by eye, so the "clean" results are meaningful.

**Ability system (151 abilities).** Constants, `data/abilities/names.asm`,
`data/abilities/flags.asm` and `descriptions.asm` are all exactly 151 entries and
index-aligned; every flags entry's trailing comment matches the constant occupying that
slot. Every ability assigned to a species is reachable from battle code. `GetAbility` in
`home/abilities.asm` traces correctly, including the slot-2 / hidden-ability fallthrough
and the empty-slot fallback to ability 1. The `dbw`-terminated dispatch tables are
key-value rather than positional, so they can't desync — good design choice.

Four constants are defined but on no species: `BERSERK`, `WIND_RIDER`, `IRON_BARBS`,
`POISON_PUPPETEER`. Harmless; presumably staged for future use.

**Species data tables (477 species).** Base stats include list, cries, dex entry
pointers, pic pointers, and both dex order tables all verified against the constant list.
Both `AlphabeticalPokedexOrder` and `NewPokedexOrder` are exact permutations of all 477
species — no duplicates, no omissions.

**Indirect tables.** Every sub-table range checked against its declared span:
`BaseData` (151 + 326), `EvosAttacksPointers` (117 + 4 + 30 + 301 + 9 + 16), `Moves` and
`MoveDescriptions` (349 each) all measure exactly right. `EggMovePointers2` was the sole
failure.

**Sprite dimensions.** All 477 `front.dimensions` values agree with the actual PNG
dimensions.

**Outdoor sprite VRAM (the Cerulean handoff doc's item 4).** I simulated
`ArrangeUsedSprites` exactly — the two-bank cursor, the type sort, the 116-tile animated
ceiling in bank 1, the 128-tile bank 0, and the player sprite in slot 0 — against all 26
outdoor sprite groups. **Every group packs successfully; no sprite fails assignment.**
The Cerulean fix held. Tightest groups are Cerulean and Saffron at 212/244 animated
tiles, roughly two spare walkers each. Nothing else is near the cliff.

I also verified the doc's item 2, the exactly-full-bank sentinel: `e = 0` is only
reachable via the exact-`$100` path, the `jr nc` / `and a` / `jr nz` sequence
distinguishes "lands exactly on $100" from "wrapped past it" correctly, and both paths
record the start tile before marking the bank full. The logic is sound.

**Held items.** `HELD_ITEM_AUDIT.md` is a completed piece of work; its only open item
(Flame Orb / Toxic Orb not placed in any mart or itemball) is deliberate.

---

## Observations worth acting on later

**No table-length assertions anywhere.** This is the root cause of finding 1, and it's
structural. Upstream pokecrystal has `macros/asserts.asm` with `assert_table_length` and
uses it in 213 places; this repo predates that file and has zero. Every parallel table —
and there are a lot of them, indexed by species, move, ability and item — can silently
desync and still build. Finding 1 sat in a shipped build for exactly this reason.

The upstream macros need rgbds 0.6+ (`DEF`, `REDEF`, `__SCOPE__`), so they can't be
dropped in as-is on 0.5.2. Two options: write 0.5.2-compatible equivalents, or keep a
checker script in `tools/` that validates table lengths and run it from the Makefile. I'd
lean toward the script — it's less invasive than instrumenting the data files and it can
cover the indirect tables too, which assertions don't reach. Happy to build it if you want.

**Bank pressure is real but not urgent.** 92 of 141 allocated banks have under 256 bytes
free. The battle code specifically: Battle Core 29 bytes free, Abilities Engine 27,
Battle Core Overflow 12. The existing advice in `HELD_ITEM_AUDIT.md` — put new battle
code in Battle Effect Overflow (710 bytes free) and `farcall` it — is correct and worth
continuing to follow. Ample room overall though: **114 banks are entirely unused**, so
new sections in fresh banks are cheap.

**Two dead files**, safe to delete:
- `data/pokemon/base_stats/rypherior.asm` — misspelled duplicate of `rhyperior.asm`,
  not included in the build, and its `gfx/pokemon/rypherior/` directory doesn't exist.
  It would fail to build if anyone ever added the include.
- The corrupt `rgbds/rgbds-0.5.2-linux-x86_64.tar.xz`, per finding 3.

**Clone species reuse originals' base stats** — `BULBASAUR_CLONE` and the other seven
`INCLUDE` the original species' base stat file rather than having their own. I checked
whether this causes problems and it doesn't: `abilities_for` ignores its first argument
(it's documentation only), and the clone sprite dimensions are identical to the originals
in every case except Charmeleon, which is precisely the one that already has its own
`charmeleon_clone.asm`. Working as intended, just worth knowing if you ever want a clone
to diverge statistically — it'll need its own file first.

**`UNANIMATED_FRONT_SPRITES.md` is stale.** It lists Aggron as unanimated, but
`gfx/pokemon/aggron/` has a populated `frames.asm` and a multi-frame sheet. Its detection
method (reading `anim.asm` frame references) measures what the animation *asks for*, not
what the sheet *contains* — which is why it missed the 18 species in finding 2. If you
regenerate that list, key it off the generated `frames.asm` instead.

---

## Verification performed

- Baseline build before changes: clean, `db053dfd6a2b063b9f87c388f02ab0b5`.
- Final build with all fixes: clean, no errors or warnings,
  `b919cf1bae1f549c48e912a36d38f412`.
- All mechanical checks re-run against the fixed tree: egg move table 326/326,
  zero out-of-range animation frame references, dex orders still exact permutations,
  base stats still 477.

Not verified: actual in-game behaviour. Both gameplay fixes are worth a quick emulator
check — hatch a Shuppet or Salazzle egg, and look at Ampharos, Dragonite, Tyranitar and
Magnezone in battle or the Pokédex.
