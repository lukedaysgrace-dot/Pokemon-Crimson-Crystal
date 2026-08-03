# Polished-style Type Icons + Stats-Screen Move Info — HANDOFF (2026-08-03)

**STATUS: implemented and assembling clean. Pink and green pages confirmed
rendering on a real save. Round-2 polish (padding color + page-switch flash) is
built but NOT yet playtested — see §2h.**

Test build: **`crimson_type_icons.gbc`** (in the repo root).

**Still to playtest:** the pill padding now taking the panel color on both pages,
no palette flash when cycling pages, and the A-button move info view
(category icon, power/accuracy, description, Up/Down, exit).

### Verified working
The pink page's type pill renders exactly like Polished — rounded colored box,
baked-in small white lettering, correct per-type color, white backing:

```
  ┌──────────────┐
  │ N O R M A L  │   <- khaki NORMAL pill, white lettering, 4 tiles wide
  └──────────────┘
```

This confirms the whole pipeline: `TypeIconGFX` slot allocation, the inverted
`.SetBadgePal` (white in color 0, type color in color 3), the attrmap palette
assignment, and `Get1bpp_2` under LCD-on.

### Not yet verified
The **green (moves) page** and the **A-button move info view**. See §3 — an
earlier apparent hang there could not be reproduced or ruled out, because the
test harness could not construct a legitimate party mon (details in §4). Please
playtest these two on a real save before trusting them.

Goal (from the user): make type displays everywhere look like Polished Crystal —
the small baked-in lettering on a colored pill — instead of the current 4-character
text abbreviations (`PSYC`, `WATR`) drawn in the normal font on a colored cell.
Also: press **A** on the stats screen's move page to see move info, like Polished.
Scope decisions the user confirmed:
- Type icons: **everywhere types are shown**.
- Press-A move info: **stats screen only** (not battle).
- Base: pokecrystal (pret) with **16-bit move/species IDs** ("16bit" fork).

---

## 1. What already existed before this work

`MOVE_INFO_FRAMES_PORT.md` (2026-08-02) already ported Polished's **battle** move
info box. That port brought in the assets we reuse here, so **no new art was needed**:

- `gfx/battle/types.png` — 32x232, **4 tiles wide x 29 rows**, 1bpp.
  One pill per **raw type constant** (0-28), including the BIRD/unused gap rows
  (they use the "???" art), so **no runtime index remapping is ever required**.
  Compiled to `gfx/battle/types.1bpp`, exposed as `TypeIconGFX::` in `gfx/font.asm:31`.
- `gfx/battle/types.pal` — one RGB per type constant, 29 entries. Exposed as
  `TypeIconPals` in `engine/gfx/color.asm`.
- `gfx/battle/categories.png/.pal` — physical/special/status badges, 2 tiles 2bpp
  each. `CategoryIconGFX::` in `gfx/font.asm:36`, `CategoryIconPals` in `color.asm`.
- `engine/battle/move_info_box.asm` — `BattleMoveInfoStats`, the battle-side drawer.

**Important pixel-format fact:** the 1bpp pill art expands so that the pill body
is **color 3** and the punched-out lettering + rounded corners are **color 0**.
So a pill palette must be `[0]=white, [3]=type color`. (The old text badges were
the opposite: type color in 0-2, white glyph in 3. This is why `.SetBadgePal` in
`summary_screen_pals.asm` had to be inverted — see below.)

Type constants: `constants/type_constants.asm`. 19 real types but **29 index slots**
(0-28), because of BIRD (6), TYPE_10..TYPE_18, CURSE_T (19). Every type-indexed
table in this repo is 29 entries. Keep it that way.

---

## 2. Changes made (all already saved in the working tree)

### 2a. `engine/battle/hidden_power.asm`
`GetHiddenPowerDisplayStats` used to hardcode `ld hl, wBattleMonDVs`. It now takes
**`hl` = pointer to the DVs**, so non-battle screens can call it with `wTempMonDVs`.
Returns `b`=category, `c`=type, `d`=power. (Callers outside battle should ignore `b`,
which is still read from `wPlayerMoveStructCategory`.)

Updated its two existing callers to pass `hl` first:
- `engine/battle/move_info_box.asm` (`ld hl, wBattleMonDVs` before the call)
- `engine/gfx/color.asm` `LoadBattleCategoryAndTypePals` (same)

### 2b. `engine/gfx/color.asm` — three new helpers (all `::`, near `CategoryIconPals`)
- `LoadStatsCategoryPal::` — `a` = category. Writes the 2 category colors into
  **colors 1-2 of BG palette 0** and uploads. Palette 0 on the stats screen is the
  HP-bar palette, whose colors 1-2 are unused on the green page (no HP bar there).
- `RestoreStatsHPPal::` — undoes the above from `wCurHPPal` + `HPBarPals`.
- `LoadMoveScreenCategoryTypePals::` — `b`=category, `c`=type. Builds **BG palette 2**
  as `white / cat1 / cat2 / typecolor` for the party-menu move screen.

All three tail into the existing `_ApplyMoveInfoPals` (ApplyPals + `hCGBPalUpdate`).

### 2c. `engine/pokemon/mon_menu.asm` — party menu MOVE screen (Polished-style panel)
`PlaceMoveData` was rewritten. It used to draw a `┌─────┐ / │TYPE/└` ASCII box plus
`predef PrintMoveType` text. Now it:
1. `GetMoveData` into `wStringBuffer2`; if the move is Hidden Power, substitutes the
   computed type/power via `GetHiddenPowerDisplayStats` with `wTempMonDVs`.
2. `farcall LoadMoveScreenCategoryTypePals` (palette 2).
3. Loads category icon -> `vTiles2 $79-$7a`, type pill -> `$7b-$7e`.
4. Places the 6 tiles at `hlcoord 1, 12`, then `call MoveScreen_SetIconAttrs` with `a=$2`.
5. Prints `ATK/` + power at (12,12)/(16,12) and the description at (1,14) as before.

New helper **`MoveScreen_SetIconAttrs`** points those 6 cells at palette `a` by writing
both `wAttrMap` **and VRAM bank 1 directly** (LCD-safe, rSTAT-polled) — the move screen
never pushes the full attr map after setup, so the direct write is required.
It is also called with `a=0` in `.moving_move` so the "Where?" prompt isn't tinted.

Deleted now-unused strings `String_MoveType_Top` / `String_MoveType_Bottom`.

> Note: `PrintMoveType`, `PrintType`, `PrintMonTypes` (in `engine/pokemon/types.asm`,
> reachable via the predef table) are now **completely unreferenced**. `GetTypeName` is
> still used by the Hidden Power Guy and Conversion/Conversion2 battle text — leave that.
> The Pokédex search screen uses its own `PokedexTypeSearchStrings` and was intentionally
> **not** converted (it's a 9-char text list, not a badge).

### 2d. `engine/pokemon/stats_screen.asm`
- **Deleted** the whole `TypeAbbreviations` table (29 x 5 bytes) and
  `PlaceTypeAbbreviation`. Nothing references them any more.
- **New `StatsScreen_LoadTypeIcon`**: `a`=type, `c`=VRAM slot 0-3. Copies the 4 pill
  tiles to `vTiles2 tile ($4b + c*4)` via `Get1bpp_2`; returns the first tile id in `a`.
- **New `StatsScreen_PlaceTypeIcon`**: writes `a, a+1, a+2, a+3` at `hl`.
- **New `StatsScreen_GetMoveDisplayType`**: returns the display type for the move
  struct in `wStringBuffer2`, honoring Hidden Power (uses `wTempMonDVs`).
- **New `StatsScreenArrowGFX`** (8x8 1bpp "▶") loaded to `vTiles0 tile $03` in
  `LoadSummaryScreenGFX`, used as the move-info selection cursor (OAM sprite 5).
- **Pink page**: the two type badges now use slots 0 and 1 -> tiles `$4b-$52`.
- **Green page**: each move's type pill uses slot = move index -> tiles `$4b-$5a`.
- **Green page refactor**: the held-item name+description block was extracted into
  `.PlaceItemInfo` so the move-info view can restore it on exit.
- `StatsScreen_LoadGFX` now **reloads `ExpBarGFX` to `vTiles2 $55` (8 tiles) on every
  page load**, because the green page's icons overwrite `$55-$5c`. `gfx/font.asm`'s
  `ExpBarGFX` was made exported (`ExpBarGFX::`) for this.
- `StatsScreen_JoypadAction.a_button` now does `cp GREEN_PAGE / jp z, StatsScreen_MoveInfo`
  before the old "advance page" behavior.
- **New `StatsScreen_MoveInfo`** — a self-contained modal loop (does NOT add a
  jumptable state; it just loops and returns, so `wJumptableIndex` stays at the
  joypad state). Up/Down change the selected move (with wraparound, clamped to the
  known-move count), A or B exits. It draws:
  - tab label "Move"
  - selection arrow OAM sprite 5 at `y = 32 + 16*index`, `x = 60`
  - category icon (2 tiles 2bpp) -> `vTiles2 $5b-$5c` at `hlcoord 1,13`, palette 0
  - `"   <BOLD_P>/   <PCT>"` template, power at (4,13), accuracy at (9,13)
    ("---" when power < 2; accuracy is stored 0-255 `percent`-scaled and is
    converted back to 0-100 with the same Multiply/Divide rounding the battle box uses)
  - move description at `hlcoord 1,15` via `predef PrintMoveDesc`
  Exit restores the arrow to blank, the (1,13)-(2,13) attrs to the bottom-panel
  palette `$4`, `farcall RestoreStatsHPPal`, and redraws the item view.

### 2e. `engine/gfx/summary_screen_pals.asm`
- **`.SetBadgePal` inverted** to `white, color, color, color` (was `color, color, color, white`)
  to match the 1bpp pill format described in §1.
- **`.GreenSetup` rewritten**: previously only 3 BG palettes (5/6/7) were available for
  move badges, so a 4th distinct type fell back to the panel color. It now also uses
  **palette 2** (the exp-bar palette, which is unused on the green page), giving
  **4 distinct move types**. Slots are assigned in order 5, 6, 7, 2 via
  `wBuffer1..wBuffer4`.
- Icon row is now computed arithmetically as `2*index + 3` instead of via the
  `.GreenSpacedRows`/`.GreenFourRows` tables (both were `db 2,4,6,8` anyway). **Those
  two tables were deleted from this file**; the identically-named ones still exist in
  `stats_screen.asm` and still drive the name rows. The old "keep in sync" comment in
  `stats_screen.asm` is now stale — worth cleaning up.
- **New `.GetDisplayType`** mirrors `StatsScreen_GetMoveDisplayType` so the palette
  matches the pill for Hidden Power.

### 2f. VRAM budget on the stats screen (this is tight — read before changing anything)
Loaded by `StatsScreen_LoadFont` + `LoadSummaryScreenGFX`:
```
$31-$41  StatsScreenPageTilesGFX (17)   ($3f overwritten by ShinyStarGFX)
$42-$4a  SummaryScreenTilesGFX (9)
$55-$5c  ExpBarGFX (8)            <- pink page only
$60-$78  battle-extra font (25)
$6c-$6f  EnemyHPBarBorderGFX
$76-$78  HPExpBarBorderGFX pieces
```
Free: **`$4b-$54`**, `$5d-$5f`, `$79-$7e`.

The port uses **`$4b-$5a` for four type pills and `$5b-$5c` for the category icon** —
i.e. it deliberately spills past `$54` into the exp-bar block. That is safe *only*
because the exp bar is pink-page-only and is reloaded on every page switch. The pink
page itself only uses slots 0-1 (`$4b-$52`), which stays clear of `$55`.

---

## 2h. Round 2 fixes (2026-08-03, after playtest feedback)

Playtest confirmed the green page and move list render correctly — **the hang in §3
did not reproduce on a real save**, so the §2g restructure either fixed it or it was
always a harness artifact. Two visual problems were reported and fixed:

### White padding around the pills
The 1bpp art has only two colors, and color 0 was doing double duty: the pill's
**lettering** *and* the padding around its rounded corners. With color 0 = white,
that padding showed as a white block on the pink/green panel.

Fixed by generating a **3-color 2bpp variant for the summary screen only**:
- **`gfx/stats/type_icons.png`** (new, 32x232, indexed, exactly 4 palette entries —
  rgbgfx rejects more). Produced from `gfx/battle/types.png` by flood-filling the
  light pixels reachable from each 8-row band's border: those become the padding
  index, enclosed light pixels stay as lettering, dark pixels are the pill body.
  The generator is small enough to redo in Python if the source art ever changes.
  - index 0 = padding, index 1 = lettering, index 3 = pill body
- **`SummaryTypeIconGFX::`** in `gfx/font.asm`.
- `StatsScreen_LoadTypeIcon` now uses `Get2bpp_2` and a `4 tiles` stride.
- `.SetBadgePal` builds: color 0 = **side panel fill** (read from `wSGBPals + 8`,
  which the caller has already staged with the page's panel palette), color 1-2 =
  white, color 3 = the type color.

The **battle move info box and the party-menu move screen still use the 1bpp
`TypeIconGFX`** — they sit on white textboxes, so white padding is invisible there
and no change was needed.

### Palette flash on page switch
`StatsScreen_LoadGFX.LoadPals` called `DelayFrame` between flagging the palette
upload and flagging the page transfer. `LoadSummaryScreenPals` only *flags*
`hCGBPalUpdate`, so that wait let the **new page's palettes reach the screen while
the old page's tilemap and attributes were still displayed** — one frame of pills in
the wrong colors on every switch. The `DelayFrame` was removed so the palettes and
both maps land in the same vblank.

## 2g. Green page restructure (the fix applied after the first hang report)

The type-icon code was originally spliced into the middle of
`StatsScreen_GreenPage.move_loop`, which already juggles three stacked values
(`[1]` de = row table, `[2]` bc = move index, `[3]` af = move id) and now also did
four LCD-on VRAM copies from inside that nesting.

It was split into two passes:
- **`.LoadMoveTypeIcons`** (new, runs once before the move loop) does all four
  `Get1bpp_2` copies. One `push bc`/`pop bc` pair per iteration, nothing else live
  across the calls.
- The move loop now only writes tile ids (`$4b + slot*4`), which needs no move data
  and no VRAM traffic — so `GetMoveData` was dropped from the loop entirely.

This removes both leading suspects (deep-stack splice, and VRAM copies inside the
nesting) at once. The pink page was already structured this way and works.

## 3. THE ORIGINAL HANG REPORT (status: unreproduced, cause unresolved)

**Symptom:** from the stats screen, pressing Right twice (Pink -> Blue -> Green) leaves
the screen frozen showing the *blue* page. All further input is ignored. Music keeps
playing.

**Diagnosis so far (via PyBoy):**
- `wcf64 & STAT_PAGE_MASK` == `3` (GREEN_PAGE) — so the page switch was accepted.
- `wJumptableIndex` == **4** forever (= `StatsScreen_LoadPage`). It never reaches 5.
- PC sampling over thousands of frames lands **exclusively in bank `$3a`**
  (`_UpdateSound` / `UpdateChannels`), i.e. the main thread is **halted**, not spinning.

**Ruled out:** a spin inside `CopyScratchToVRAM` (`engine/gfx/dma_transfer.asm:494`).
Its `.wait_busy`/`.wait_free` LCD-sync loops run under `di`, so if it were stuck there
the sound IRQ could not fire — but the sound IRQ is demonstrably still running every
frame. Same reasoning rules out `_Get1bpp`'s chunk loop.

**Top hypothesis now: stack corruption / a bad return, landing the CPU in an idle
`halt`.** The evidence fits this better than a wait-loop: the CPU executes *nothing*
in the main thread (100% of non-IRQ samples are idle), yet `wJumptableIndex` is frozen
at a value that the code should have incremented. A `ret` to a garbage address that
happens to reach a `halt`, or an unbalanced stack inside the green-page loop, produces
exactly this.

`StatsScreen_GreenPage.move_loop` juggles three stacked values (`[1]` de = row table,
`[2]` bc = move index, `[3]` af = move id) and the new type-icon block was spliced into
the middle of that. I hand-checked it and it *looks* balanced (`pop af` [3], then
`pop bc`/`push bc` [2] around `StatsScreen_LoadTypeIcon`, which is itself balanced;
`AddNTimes` here is the shift-add variant and does preserve `bc`) — but this is
still the most likely place for the fault, and hand-checking has clearly missed
something.

**Important caveat on all of the above:** the hang was only ever observed with a
**hand-injected party mon**, and that injection was later found to be corrupting the
16-bit index tables (see §4). Every observation in this section is therefore suspect.
After the §2g restructure the failure could not be reproduced *or* confirmed, because
the harness never managed to produce a mon that was simultaneously valid and
navigable. **Playtest on a real save first — the bug may not exist.**

### If it does still hang, next steps in order
1. **Trace the stack pointer.** In PyBoy, sample `p.register_file.SP` while switching
   to the green page. A drifting SP confirms an imbalance immediately and points at
   the exact call — much faster than re-reading the assembly.
2. **Bisect.** Comment out the `call .LoadMoveTypeIcons` (leaving tile-id placement,
   which will just show whatever is in those tiles). If the hang clears, it is the
   VRAM copies; if not, look at `.GreenSetup` in `summary_screen_pals.asm`.
3. If it is the copies, **batch all four pills into a single `Get1bpp_2`** by
   assembling the 16 tiles contiguously in a WRAM scratch buffer first.
4. **Longer-term, consider Polished's actual approach**: it bulk-loads all 19 icons
   once into VRAM bank 1 and draws them as OAM sprites
   (`engine/pokemon/summary_screen.asm:150-157`, `SummaryScreen_PlaceTypeOBJ` at `:996`),
   avoiding per-page VRAM traffic entirely. Bigger refactor, needs a tile-budget
   rethink, but it is the design upstream settled on.

---

## 4. How to build and test (already set up)

The mounted Windows path is very slow for `make`; **build from a local copy**:
```bash
rsync -a --exclude=.git --exclude='*.gbc' --exclude=_to_delete \
  /path/to/Pokemon-Crimson-Crystal/ /tmp/crimson/
cd /tmp/crimson && make -j8       # ~2.5 min
```
`local.mk` points at `$(HOME)/opt/rgbds-0.5.2/bin/`. **rgbds 0.5.2** was built from
source at `/tmp/rgbds` and installed to `~/opt/rgbds-0.5.2/bin/` and `~/.local/bin/`.
The tree currently **assembles and links with zero errors or warnings**.

Emulator harness (PyBoy, `pip install pyboy --break-system-packages`) — note PyBoy
cannot write into `/tmp` directly here; use `/tmp/emu`. Save states from the debug
session are in `/tmp/emu/state*.sav` (these are ROM-specific and will be invalidated
by a rebuild).

**Harness lessons — read these before writing another test, they cost hours.**

- **Background processes do not survive between tool calls** (each call is an isolated
  sandbox). Everything must finish inside one call. `/tmp` files *do* persist, so
  chunk long runs by saving PyBoy states between calls.
- **`p.tick(n, False)` (render off) is ~300x faster** than looping `p.tick()`. The
  whole intro runs in well under a second. Turn rendering back on for ~100 frames
  before any screenshot, or you capture a blank frame.
- **PyBoy save states are invalidated by a rebuild.** Re-drive from boot after `make`.
- **Screenshot only once the screen is idle.** Poll `wJumptableIndex` (`00:cf63`)
  until it reads `6` (`MonStatsJoypad`); `4` means it is still mid-page-load.

Injecting a party (this is a **16-bit-ID fork**, so the index tables matter):
```python
m[0xFF70] = 2   # WRAM bank 2 = "16-bit WRAM tables"
# Lookup is (HIGH(Entries) << 8) | id*2  ->  effectively 0xd400 + id*2 for mons
# and 0xd500 + id*2 for moves. It is PAGE-INDEXED: do NOT use the d402/d502
# `...Entries` label as an array base, and do NOT write UsedSlots/LastAllocated
# at d400/d401 and d500/d501 (ids 0 and 1 are reserved for exactly that reason).
m[0xFF70] = 1
# party @ dcb5 count, dcb6 species list, dcbd wPartyMon1, moves @ dcbf,
# DVs @ dcd2, PP @ dcd4, level @ dcdc, HP @ dce0, maxHP @ dce2,
# OT name @ dde3, nicknames @ de25 (11 bytes/entry, 0x50 terminator, 'A' = 0x80)
```
Clobbering `UsedSlots` produced heavy corruption (garbled nickname, garbage frontpic,
nonsense exp) that looked exactly like a rendering bug but was not.

**Unsolved harness problem:** even with correct table addressing and with the entries
locked (`wPokemonIndexTableLockedEntries` @ `02:d4da`,
`wMoveIndexTableLockedEntries` @ `02:d6de`), a hand-built mon renders the pink page
fine but reliably drops `wJumptableIndex` to 0 on the first page switch — the
`.load_mon` path, reached when `StatsScreen_GetJoypad` returns carry. Suspect
`wMonType` / breedmon (`StatsScreenDPad`) handling, or that the GC still reclaims the
ID. **Recommend abandoning memory injection and testing against a real save file
instead** — it is far cheaper than making a synthetic mon fully legitimate.

Useful symbols: `wJumptableIndex 00:cf63`, `wcf64 00:cf64`, `wCurHPPal 00:cda1`,
`hROMBank ff9d`. `pokecrystal.sym` is regenerated by every build.

---

## 5. Remaining work after the bug is fixed

- **Verify visually**: pink page (1 and 2 types), green page with 4 distinct types
  (checks the new palette-2 slot), move info view on all 4 moves, exit/re-enter,
  page cycling both directions, the party-menu MOVE screen, a Hidden Power mon
  (pill + power should follow the computed type, and the Hidden Power Guy's choice).
- **Egg stats screen** — `EggStatsScreen` is a separate path; confirm it is unaffected.
- Battle move info box should be unchanged — re-verify since `GetHiddenPowerDisplayStats`
  changed signature.
- Consider deleting the now-dead `PrintMoveType` / `PrintType` / `PrintMonTypes` and
  their `data/predef_pointers.asm` entries (slots must stay aligned — replace with
  padding rather than removing lines, or renumber every predef).
- Fix the stale "keep the row tables in sync" comment in `stats_screen.asm`.
- The pink page's shiny-star palette (7) and the green page's 3rd type pill share
  slot 7; the star is pink-page-only so this is fine, but do not add a shiny
  indicator to the green page.
