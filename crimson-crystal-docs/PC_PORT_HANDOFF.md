# Polished Crystal PC / Storage System Port — Handoff

> **UPDATE (2026-07-21): PORT COMPLETE — ROM BUILDS CLEAN.** All 28 link errors in §4
> are resolved; the second wave (bank2 overflow + WRAM0 overflow) is also resolved.
> `pokecrystal.gbc` builds, boots in an emulator, and a new game runs through
> Oak's intro (i.e. `InitializeBoxes` + new SRAM layout survive new-game init).
> See §9 at the bottom for exactly what was done, what was stubbed, and what
> in-game testing remains.

**For:** the next agent continuing this work
**Status (historical):** ~85% done. Storage backend fully ported and building. UI (`bills_pc_ui.asm`)
assembles; **28 link-time "unknown symbol" errors remain** — all small shims/constants.
**Goal (from Luke):** copy Polished Crystal's Bill's PC box system into Crimson Crystal
*exactly*, including a graphical box grid that shows **menu (mini) sprites for every
Pokémon — including Crimson-exclusive species that don't exist in Polished.**

---

## 0. Decisions already locked with the user

- **Full port** of both the storage *backend* (mon database in SRAM) and the graphical *UI*.
- **Saves may break** (agreed). No migration routine needed.
- **20 boxes of 20** (matches Polished exactly).
- SRAM grown 32KB → **64KB (MBC30, `rgbfix -r 5`)** to fit the mon database.

Do **not** re-litigate these. Just finish the build.

---

## 1. How to build (critical — read this first)

The user's real folder is the **mount**:
`/sessions/<session>/mnt/Pokemon-Crimson-Crystal/`
(Windows: `C:\Users\luked\OneDrive\Documents\GitHub\Pokemon-Crimson-Crystal`)

**Background shell processes die between calls in this sandbox.** You cannot `make` in the
mount reliably (large tree, rsync/make time out at 45s). The working pattern is a
**build mirror** at `/tmp/cc`:

```bash
# rgbds 0.5.2 was hand-built (the repo's prebuilt binary segfaults). It lives at:
/tmp/rgbds-src/rgbasm   # + rgblink, rgbfix, rgbgfx
export PATH=/tmp/rgbds-src:$PATH

# If /tmp/cc or /tmp/rgbds-src were wiped (new session), rebuild them — see §7.

# Fast incremental build (only re-assembles changed .asm):
cd /tmp/cc && make main.o 2>&1 | tail
cd /tmp/cc && make 2>&1 | tail        # full link
```

**IMPORTANT WORKFLOW:** edit files in the **mount** (so Luke keeps them), then copy the
changed file into `/tmp/cc` before building. I already synced everything mount↔mirror at
the end of my session, so they currently match. Keep them in sync as you go, e.g.:

```bash
M=/sessions/<session>/mnt/Pokemon-Crimson-Crystal
cp "$M/engine/pc/pc_support.asm" /tmp/cc/engine/pc/pc_support.asm
```

Baseline (before my changes) built cleanly, so the toolchain is known-good.

---

## 2. Architecture of the port (how Polished's PC works)

Polished does **not** store box mons as fixed per-box structs. Instead:

- A **Pokémon database** ("PokeDB") of `MONDB_ENTRIES` slots lives in SRAM. Each stored
  mon is a **`savemon_struct`** (checksummed, ~54 bytes: 16-bit species index, 14-bit
  move indexes packed into move+PP bytes, unterminated nick/OT, 2-byte checksum).
- Two full copies of the DB exist (active "1" + backup "2"), each split into 3 sections
  (A/B/C) tucked into leftover SRAM banks.
- A **box** is just metadata: a list of 20 entry-indexes + a bank-select bitfield + name
  + theme (`newbox` macro). Boxes point into the PokeDB.
- Free-slot tracking = `wPokeDB{1,2}UsedEntries` bitmaps, rebuilt by `FlushStorageSystem`.

**Crimson adaptation that matters:** Crimson uses **16-bit species indexes** (484 mons)
via `GetPokemonIndexFromID` / `GetPokemonIDFromIndex` (see `home/16bit.asm`). Stored mons
keep the **16-bit index** directly (`SAVEMON_SPECIES` is a word), so all Crimson-exclusive
mons work and boxed mons no longer touch the ID-conversion tables at all. This *removed*
the old per-box index tables + box-load garbage collection.

---

## 3. What's DONE and building

### Constants / layout
- `constants/pokemon_data_constants.asm`: `MONS_PER_BOX=20`, `MONDB_ENTRIES_A/B/C`
  (143/53/10), `MONDB_ENTRIES`, `NUM_BOXES` (=20), and the full **`savemon_struct` rsreset
  block**. Note `SAVEMON_CAUGHTDATA rb 2` and `SAVEMON_IS_EGG_F EQU 6` (bit 6 so egg checks
  on the species-index high byte work — see §5 egg marker).
- `constants/pc_constants.asm` (NEW, included in `constants.asm` before phone_constants):
  themes, PCSWAP_* return codes, `ERR_PC_BOX_*`, sprite-anim PCANIM_* values,
  `PC_EGG_INDEX EQU $fffd`, `MON_IS_EGG_F EQU 6`, `BGPI_AUTOINC`, `OAM_BANK1`,
  `HELDTYPE_*` + `NUM_HELD_ITEM_TYPES`, `FIRST_BERRY`/`NUM_BERRIES` (stubbed to 1 — see §5).
- `macros/wram.asm`: added `savemon_struct`, `pokedb`, `newbox` macros.
- `sram.asm`: replaced old `sBox1..14` with `Box metadata` section (`sNewBox1..20` +
  `sBackupNewBox1..20`) and 6 `PokeDB bank` sections. Kept a **legacy overlay union** at
  the top (`sBox`, `sBox1..14`, `sBoxNEnd`, `sBoxNPokemonIndexes`) purely so dead
  mobile/link code still assembles — these overlap scratch and are never really used.
- `pokecrystal.link`: SRAM banks 0–7 remapped (Box metadata in bank 1; PokeDB in 2,3,6,7),
  `Used Storage` added to WRAMX 4.
- `Makefile`: `rgbfix ... -r 5` (64KB SRAM). **Comment on that line uses `;` — keep it.**

### WRAM / HRAM
- `wram.asm`: `wEncodedTempMon` (savemon_struct) + `wTempMonBox/Slot/Index/IsEgg/
  Nickname/OT` overlaid on the tail of the OT-party area (never live simultaneously).
  Full `wBillsPC_*` UI block (palettes, lists, cursor, quick-anim, LCD code buffer,
  `wSwitchMonBuffer`) placed in a `NEXTU` of the `wBoxPartialData` union. `Used Storage`
  WRAMX section (`wPokeDB1/2UsedEntries`). Removed old `wBoxNames` (names now in SRAM).
- `hram.asm`: added `hLCDInterruptFunction` trampoline (`jp` + target lo/hi).
- `home/interrupts.asm`, `home/lcd.asm`, `home/init.asm`: the `lcd` vector now
  `push af; jp hLCDInterruptFunction`; `LCDGeneric::` is an alias of `LCD::`; init installs
  the `jp LCDGeneric` trampoline. This lets the PC UI install a custom hblank pal handler.

### Backend engine — fully rewritten/ported
- `engine/pc/bills_pc.asm` — the whole backend: `SwapStorageBoxSlots`, `AddStorageMon`,
  `OpenPokeDB`, `Encode/Decode/ChecksumTempMon` (rewritten for Crimson's 16-bit species +
  14-bit moves + shiny/gender in Unused↔Pokerus byte), `SetTempPartyMonData` (uses
  `predef CalcMonStats`), `NewStorageBoxPointer`, `FlushStorageSystem`, `GetStorageBoxMon`,
  `InitializeBoxes`, box name/theme helpers, `MakeBadEgg`, etc.
- `engine/pc/pc_support.asm` (NEW) — shims Polished relied on: `Crash`, `PopBCDEHL`,
  `SwapHLDE`, `ItemIsMail_a`, `GetBaseDataFromIndex`, `StackCallInWRAMBankA`/`RunFunctionInWRA6`,
  `SmallFlagAction`, `CopyRLE`, `PCJumpTable`, `ClearPCItemScreen`, `CopyBoxmonToTempMon`,
  `StatsScreenDPad`, `BillsPC_WipeAttrMap`, `BillsPC_DoNothing`, GFX incbins, mini-icon
  loaders (`GetStorageMini*`, `GetStorageMask`), palette helpers (`GetMonPalInBCDE`,
  `GetShininess`, `SetDefaultBGPAndOBP`), `NoYesBox`, `CreateBoxBorders`, `PlaceVWFString`
  (fixed-width fallback), `PlaceFrontpicAtHL`, `_OpenTempmonSummary`, `BillsPC_HeldItemIcons`,
  and the 4 `BillsPC_AnimSeq_Pc*` sprite handlers.

### Callers rewired to the new backend
`engine/pokemon/move_mon.asm` (`SendMonIntoBox`, `GivePoke`, `RemoveMonFromParty`),
`engine/pokemon/move_mon_wo_mail.asm` (`InsertPokemonIntoBox`),
`engine/pokemon/caught_data.asm` (`SetBoxMonCaughtData`, bug-contest deposit),
`engine/items/item_effects.asm` (ball catch → box path),
`engine/menus/save.asm` (`SaveBox`/`LoadBox`/`EraseBoxes` → `Save/LoadStorageSystem`,
deleted `BoxAddresses` table + index-table plumbing),
`engine/menus/intro_menu.asm` (new-game → `InitializeBoxes`),
`engine/16/table_functions.asm` (GC no longer scans box mons),
`engine/pokemon/search.asm` + `engine/events/lucky_number.asm` (scan via `GetStorageBoxMon`),
`engine/printer/printer.asm` (box name via `GetBoxName`),
`engine/pokemon/tempmon.asm` (invalidate `wTempMonSlot` for non-storage mons).

### UI + graphics
- `engine/pc/bills_pc_ui.asm` — 3800-line UI, mechanically converted (jmp→jp, rst→call,
  rWBK→rSVBK, `DEF`/`MACRO` syntax, `LOAD UNION` LCD block → ROM code copied to
  `wBillsPC_LCDCodeBuffer`, single→double quote chars, `text_farend`→`text_far`+`text_end`).
  Wired into `main.asm` under `SECTION "Bills PC", ROMX`.
- `gfx/pc/`: `pc.2bpp`, `cursor.2bpp`, `obj.2bpp` (=modes+bags), `gender_shiny.2bpp` and
  `held_item_icons.2bpp` (hand-generated placeholders), copied from Polished + generated.
- Sprite anims: added PC_CURSOR/QUICK/MODE/MODE2/PACK across
  `constants/sprite_anim_constants.asm`, `data/sprite_anims/{sequences,framesets,oam}.asm`,
  and handlers in `engine/gfx/sprite_anims.asm` (thin stubs → `farcall BillsPC_AnimSeq_*`
  in `pc_support.asm`, to keep bank 23 from overflowing).

---

## 4. REMAINING WORK — the 28 link errors

Run `cd /tmp/cc && make 2>&1 | grep -i "unknown symbol" | sort | uniq -c`. Current list
and the intended fix for each:

| Missing symbol | Where | Fix |
|---|---|---|
| `wCurIconForm` (×5) | ui + pc_support | Crimson's `wCurIcon` has no matching form byte. Add `wCurIconForm:: db` next to `wCurIcon::` in `wram.asm` (c3b6 area), OR repoint these to a spare byte. It holds the **high byte of the 16-bit species index** for icon lookup. |
| `wCurForm` (×1) | ui:995 | Same idea — Crimson has no `wCurForm`. It's only used to stash the index high byte before `GetBaseData`; safe to delete that line (base data comes from `wCurSpecies`). |
| `wBillsPC_ItemVWF` (×4) | ui | I dropped this buffer from the WRAM block during a rewrite. Re-add `wBillsPC_ItemVWF:: ds 10 tiles` inside the `wBillsPC_*` union block in `wram.asm`. |
| `GetIconPointerFromIndex` (×2) | pc_support | **This is the key icon shim.** Add to `mon_icons.asm`: like `GetIconPointer` but input `hl` = 16-bit index (skip `GetPokemonIndexFromID`), and handle `hl==PC_EGG_INDEX`→`EggIcon`. Body: `dec hl; ld b,h; ld c,l; add hl,hl; add hl,bc; ld bc,IconPointers; add hl,bc; ld a,[hli]; ld b,a; ld a,[hli]; ld h,[hl]; ld l,a; ret`. **This is what makes Crimson-exclusive menu sprites show in the box grid.** |
| `GetCGBLayout` / `CGB_BILLS_PC` (×1 each) | ui:176-177 | Crimson uses `GetSGBLayout`/`SCGB_*`. Either add a `SCGB_BILLS_PC` layout entry + palette routine, or (fastest) stub `_BillsPC_GetCGBLayout` to set palettes directly. Needs a real palette load eventually. |
| `BillsPC_LCDCodeEnd` (×1) | ui:301 | Label got mangled in the `LOAD UNION`→ROM conversion. Add `BillsPC_LCDCodeEnd:` right after the 3rd LCD sub-block (`BillsPC_LCDCode_3`) so the copy length `BillsPC_LCDCodeEnd - BillsPC_LCDCode` resolves. |
| `POKERUS_MASK` / `POKERUS_CURED` (×1) | ui:1174,1178 | Add to `constants/pokemon_data_constants.asm` (Polished values: `POKERUS_MASK EQU $0f` for days-left nibble, `POKERUS_CURED` check is `and $f0`/nonzero-strain-zero-days). Used only to draw the Pokérus dot. |
| `TakeMail` (×1) | ui:2256 | Crimson has mail in `engine/pokemon/mail*.asm`. Find the equivalent (removes mail from a mon) or stub to no-op initially. |
| `PCGiveItem` / `PCPickItem` (×1) | ui:2199,2282 | Item-mode give/take. Port from Polished `bills_pc_ui.asm` tail, or stub to `ret` for a first playable build (item mode disabled). |
| `BillsPC_PreviewTheme` (×1) | ui:3037 | Theme-preview helper. Port from Polished or stub. |
| `DoNothing` (×1) | ui:1541 | Replace with the existing `BillsPC_DoNothing::` (in pc_support) — I missed one call site. |

**None are architectural** — they're leaf helpers/constants/one WRAM buffer. After these
resolve, expect a **second wave**: possible bank/section overflow (watch ROMX and SRAM
sizes; I already moved anim handlers out of bank 23 once) and WRAM union size asserts.

---

## 5. Sharp edges / gotchas (things that already bit me)

- **Egg marker:** boxed eggs use species index `PC_EGG_INDEX = $fffd`. Bit 6 of the high
  byte ($fd) is set, which is why `SAVEMON_IS_EGG_F`/`MON_IS_EGG_F = 6` — egg checks read
  the index high byte. Keep these consistent if you touch either.
- **Shiny/gender byte:** party mons store flags in the `Unused` byte; stored mons store
  them in the top 2 bits of `PokerusStatus`. `Encode/DecodeTempMon` already move them.
- **`wTempMon` is the universal scratch mon.** The catch/deposit paths now build into
  `wTempMon` + `wTempMonNickname/OT/IsEgg/Index`, then call
  `UpdateStorageBoxMonFromTemp`. Post-catch tweaks (nickname, caught ball, friend ball)
  must happen **before** the final `UpdateStorageBoxMonFromTemp` commit.
- **`FIRST_BERRY`/`NUM_BERRIES` are stubbed** (`BERRY`/1). Only affects which held-item
  icon shows. Fix to real berry range when convenient.
- **`held_item_icons.2bpp` and `gender_shiny.2bpp` are hand-drawn placeholders.** Replace
  with real art later; they're the right size so they'll build.
- **Do not delete the legacy `sBox` overlay union** in `sram.asm` unless you also purge
  every dead reference in `mobile/` and `engine/events/lucky_number.asm`-style code.
- **rgbds 0.5.2 only.** Polished targets 0.9 syntax; that's why the mechanical conversions
  exist. Don't paste raw Polished code without converting.

---

## 6. Suggested order of attack

1. Add `wCurIconForm`, `wBillsPC_ItemVWF` to `wram.asm`; delete the stray `wCurForm` line.
2. Add `GetIconPointerFromIndex` to `mon_icons.asm` (icons for all species — the headline feature).
3. Add `POKERUS_MASK`/`POKERUS_CURED`; fix `BillsPC_LCDCodeEnd` label; swap `DoNothing`→`BillsPC_DoNothing`.
4. Stub `PCGiveItem`/`PCPickItem`/`TakeMail`/`BillsPC_PreviewTheme`/CGB-layout to `ret`/no-op
   to get a **first linking ROM**, then iterate on real behavior.
5. `make` → resolve the second wave (overflows/asserts).
6. Then §7 verification.

---

## 7. Rebuilding the environment if the sandbox was reset

```bash
# rgbds 0.5.2 (repo's prebuilt binary segfaults; build from source):
apt-get download bison flex libfl-dev libbison-dev m4   # then dpkg -x each into /tmp/local
git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds /tmp/rgbds-src
cd /tmp/rgbds-src && PATH=/tmp/local/usr/bin:$PATH M4=/tmp/local/usr/bin/m4 make -j4 BISON=bison
# -> /tmp/rgbds-src/{rgbasm,rgblink,rgbfix,rgbgfx}

# Build mirror: rsync mount -> /tmp/cc in <40s timeout-safe chunks (dirs individually),
# rm /tmp/cc/local.mk, then: cd /tmp/cc && PATH=/tmp/rgbds-src:$PATH make
```

Regenerate the pc gfx if missing:
`cd /tmp/cc/gfx/pc && for f in pc cursor modes bags; do /tmp/rgbds-src/rgbgfx -o $f.2bpp $f.png; done && cat modes.2bpp bags.2bpp > obj.2bpp`

---

## 8. Verification (task #7, not yet started)

- `make` clean, check `pokecrystal.map` for SRAM/WRAM/ROMX overflow slack.
- Boot in an emulator (mGBA/BGB). New game → PC should open the graphical grid.
- Test: deposit, withdraw, move between boxes, release, box change/save, item mode,
  and — the headline — confirm **Crimson-exclusive species show correct menu sprites**
  in the grid and cursor.
- Round-trip a save (deposit, save, reset, reload) to confirm the checksum/DB survives.

---

*Backend + wiring: done and building. UI: assembles, needs the 28 leaf symbols in §4.
The icon shim in §4 (`GetIconPointerFromIndex`) is the piece that delivers Luke's explicit
ask about Crimson-exclusive menu sprites — prioritize it.*

---

## 9. COMPLETION LOG (2026-07-21 session)

All §4 symbols resolved. The ROM builds clean (`make` → `pokecrystal.gbc`, rgbfix -r 5).
Boot-tested in PyBoy: Game Freak logo → title → main menu → New Game → Oak intro →
naming screen, no crashes.

### How each §4 item was actually fixed

- **`wCurIconForm`** — added in `wram.asm`, but NOT next to `wCurIcon`: the
  `wSpriteAnims` WRAM0 section is exactly $100 and WRAM0 is packed to the byte
  ($c000–$cfff, zero slack), so it claims one of the `ds 11` padding bytes after
  `wSpriteAnimsEnd` (section size unchanged; now `db` + `ds 10`). Lands at $c3c1.
- **`wBillsPC_ItemVWF`** — could NOT go in the WRAM0 union (160 bytes would overflow
  WRAM0 — the "Miscellaneous" union's battle member caps it at $1f8). It lives in the
  **"Used Storage" section (WRAMX bank 4)**, after the PokeDB bitmaps. The 4 access
  sites in `bills_pc_ui.asm` now wrap accesses in
  `ld a, BANK(wBillsPC_ItemVWF) / ldh [rSVBK], a` … `ld a, 1 / ldh [rSVBK], a`.
  (Safe: vblank pal-copy and the hblank LCD code save/restore rSVBK.)
- **`GetIconPointerFromIndex`** — added to `engine/gfx/mon_icons.asm`, but pointing at
  **`MenuIconPointers`** (menu/mini icons, far accessors) rather than `IconPointers` as
  §4 suggested — the box grid shows *menu* sprites, and this delivers them for all 484
  species incl. Crimson exclusives. Egg check: `h == $ff` (HIGH(PC_EGG_INDEX)) → `EggMenuIcon`.
- **`GetCGBLayout`/`CGB_BILLS_PC`** — ui now does `ld a, SCGB_BILLS_PC / jp GetSGBLayout`.
  The old orange `_CGB_BillsPC` in `engine/gfx/cgb_layouts.asm` was **replaced with the
  real Polished themed layout** (not a stub): `_CGB_BillsPC` → farcall trampoline to
  `_CGB_BillsPC_Far` in `engine/pc/pc_support.asm` (bank2 was 1 byte from full, so the
  ~600 bytes of code+pals live in the "Bills PC" bank). Ported with prefixed helper names
  (`BillsPC_LoadColorBytes/LoadOnePalette/LoadPalettes`, `GetBillsPCThemePalette`) and
  pal includes `gfx/pc/{themes,cursor_default,pack,pokerus_shiny,exp_bar,icons}.pal`
  (last two copied from Polished `gfx/battle/exp_bar.pal` + `gfx/icons/icons.pal`).
  `BillsPC_PreviewTheme` is therefore REAL (theme preview works), lives in the PC bank.
- **`POKERUS_MASK`/`POKERUS_CURED`** — added to `constants/pokemon_data_constants.asm`
  (Polished values `%00001111` / `%1101`).
- **`BillsPC_LCDCodeEnd`** — label added after LCDCode_3's `reti`.
- **`TakeMail`** — real port: `TakeMail::` added to `engine/pokemon/mon_menu.asm`,
  duplicated from `MonMailAction.take` with Polished's carry contract (carry = taken).
  Note: `MonMailAction`'s own `.sentmailtopctext` (text_far `UnknownText_0x1c1cc4`) had
  to stay above `TakeMail::` for local-label scoping.
- **`DoNothing`** → `BillsPC_DoNothing` in the menu jumptable.
- **`PCGiveItem`/`PCPickItem`** — **STUBS** (`xor a / ret`, in pc_support.asm). A real
  port needs Polished's rewritten Pack engine (`DepositSellInitPackBuffers` /
  `_GetItemToGive`). Effect: in item mode, give/pick-from-pack silently cancels;
  taking/moving a held mon item still works.
- ui's stray `ld [wCurForm], a` deleted.

### Still to do (in-game verification — §8)

- Walk to a Pokécenter PC in-game and exercise: deposit, withdraw, move between
  boxes, release, box rename/theme (theme preview should show real palettes),
  **confirm Crimson-exclusive species show correct menu sprites in the grid**.
- Save round-trip (deposit → save → reset → reload).
- The two known placeholder art files (`held_item_icons.2bpp`, `gender_shiny.2bpp`)
  and the `FIRST_BERRY`/`NUM_BERRIES` stub from §5 still stand.
- `PCGiveItem`/`PCPickItem` real port if item-mode give/pick is wanted.

### Crash-fix addendum (same day, after Luke's in-game test)

Opening the PC in-game caused a silent reset (wild jump → boot → "GBC only"
screen, since `a` no longer holds $11 on a warm reset). Reproduced in PyBoy with
a debug build (StartMenu hook → `_BillsPC`, memory-poked party) and execution
hooks. FIVE distinct bugs, all mechanical-conversion fallout — worth reading
before porting anything else from Polished:

1. **Cross-bank `call`s.** The UI plain-`call`ed `InitSpriteAnimStruct` /
   `ClearSpriteAnims` (bank 23) and `ItemIsMail` (bank 2e) — executes garbage
   in the caller's bank. Fixed: `call _InitSpriteAnimStruct` (home wrapper),
   `callfar ClearSpriteAnims`, new `ItemIsMail_d` shim in pc_support (item in
   d, preserves regs; ItemIsMail reads d).
2. **`farcall` clobbers `a` AND `hl`** (Crimson's macro is
   `ld a, BANK / ld hl, target / rst FarCall`). The converted code farcalled
   same-bank helpers passing args in a/hl (`GetStorageMini_a`,
   `GetMonPalInBCDE`, `BillsPC_PreviewTheme`, `GetStorageMini/Mask`, …) — all
   now plain `call` (marked "; same bank"). `GetIconPointerFromIndex` (hl arg)
   moved from mon_icons.asm into pc_support.asm (it only uses far accessors,
   so it's bank-agnostic) and is `call`ed. `GetMonFrontpic` (hl arg, bank 14)
   → `predef GetMonFrontpic` (predef preserves hl). The pokepic palette site
   was rewritten to use `GetMonPalInBCDE` (16-bit index + wTempMonUnused
   shiny flag) instead of `GetMonNormalOrShinyPalettePointer`.
3. **OAM pointer table corruption** (the actual reset): the six PC `dbw`
   entries in `data/sprite_anims/oam.asm` had been inserted in the middle of
   the OAM *data blobs*, not appended to the pointer *table* at the top. Icon
   OAMSET $8e resolved to garbage → OAM count $100 → runaway writes marched
   through WRAM into the MBC registers → bank switch under the running code →
   reset. Entries moved to the real table end (after PARTY_MON_2).
4. **LCD code buffer 2 bytes short**: the rst→call conversion grew
   `BillsPC_LCDCode` to $d1 bytes; `wBillsPC_LCDCodeBuffer` was `ds $cf`, so
   the trailing `pop af / reti` landed in `wBillsPC_CurPartyPals` and was
   overwritten by palette data → hblank handler ran off into garbage. Buffer
   is now `ds $d4` + a link-time assert at the copy site.
5. **Palettes stayed white** after the crashes were fixed:
   (a) Crimson's `GetSGBLayout` takes the layout in **b**, not a
   (`ld b, SCGB_BILLS_PC`); (b) Crimson double-buffers palettes — vblank
   commits `wBGPals2`, so pc_support now has `BillsPC_CommitPals`
   (Pals1→Pals2 FarCopyWRAM + `hCGBPalUpdate`), reached from
   `SetDefaultBGPAndOBP` (i.e. every `BillsPC_SetPals`) and the `_CGB` layout.

**Verified in PyBoy:** PC opens from a real in-game context: box grid + Party
panel render with theme palettes, mini sprite shows for the party mon, cursor
moves, B-exit shows "Continue Box operations?" and returns cleanly. Zero
resets across the whole interaction. (Deposit/withdraw/release still need
human testing — the emulated party was memory-poked.)

**Debugging recipe that worked** (for the next agent): PyBoy
(`pip install pyboy`) + `hook_register(bank, addr, cb, None)` on symbols from
pokecrystal.sym, `register_file` for regs, save_state right before the repro,
and on a wild reset hook $0100 — SP is preserved, so dumping the stack there
reconstructs the crash call chain.

### Files touched this session

`wram.asm`, `constants/pokemon_data_constants.asm`, `engine/gfx/mon_icons.asm`,
`engine/gfx/cgb_layouts.asm`, `engine/pokemon/mon_menu.asm`,
`engine/pc/bills_pc_ui.asm`, `engine/pc/pc_support.asm`,
`gfx/pc/exp_bar.pal` (new), `gfx/pc/icons.pal` (new).
Mount and `/tmp/cc` mirror verified in sync; built `pokecrystal.gbc`/`.map`/`.sym`
copied to the repo root.
