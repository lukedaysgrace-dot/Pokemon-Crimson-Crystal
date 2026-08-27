# Crimson Crystal — Polished-style PC storage system (design & implementation record)

Status: implemented (backend, save integration, gameplay rewiring and the
graphical PC). This document is the Phase 0 deliverable required by
`POLISHED_PC_DEEP_DIVE.md` §24 and was kept current as phases landed; §8-§10
describe the UI port and the test tooling.

Decisions taken (Luke, 2026-08-26):

| Decision | Choice |
|---|---|
| Capacity | **25 boxes × 20 slots = 500 logical slots** (game has 488 species). `NUM_BOXES` is compile-time parametric; the SRAM layout below supports up to 33 boxes without moving anything. |
| Cartridge | **64 KiB SRAM** (`rgbfix -r 5`, MBC3 header type unchanged; behaves as MBC30 on emulators). Emulator-only target. |
| Old saves | **Clean break.** New save-format version byte; old saves are rejected at boot and treated as "no save". |
| Printer | The Change Box → PRINT path is **removed** (with the old UI). |
| Mobile | Mobile SRAM sections relocated to bank 7 / bank 1; the JP-mobile hard-coded bank-4/7 SRAM writes are redirected to an out-of-range bank so they stay no-ops as today. |
| HM release rule | Reproduce Polished's *actual* behaviour (no HM scan). |
| Items | Full item mode (give/take/bag/move/Mail) in the first release. |
| Roamer respawn on release | Not ported (Polished-specific). |

## 1. Saved record (`savemon_struct`) — 57 bytes, versioned

All species and moves are stored as **true 16-bit indexes**; no runtime
(8-bit translation-table) IDs ever touch SRAM. Field order chosen so the
first 24 bytes are byte-identical to the live `box_struct` except species/moves.

| Off | Size | Field | Notes |
|---:|---:|---|---|
| `$00` | 2 | `SpeciesIndex` | true index, little endian |
| `$02` | 1 | `Item` | |
| `$03` | 4 | `Moves` | low 8 bits of each true move index |
| `$07` | 2 | `ID` | OT ID |
| `$09` | 3 | `Exp` | |
| `$0c` | 10 | `StatExp` | five 16-bit values (HP/Atk/Def/Spd/Spc) |
| `$16` | 2 | `DVs` | |
| `$18` | 4 | `MovesHiPPUps` | bits 0-5 = move index bits 8-13, bits 6-7 = PP Ups (same packing as Crimson's old inactive boxes; current PP is restored on decode) |
| `$1c` | 1 | `Happiness` | |
| `$1d` | 1 | `PokerusStatus` | bits 0-5 Pokérus, bit 6 = MON_MALE_FLAG, bit 7 = MON_SHINY_FLAG (old box convention) |
| `$1e` | 2 | `CaughtData` | time/level, gender/location |
| `$20` | 1 | `Level` | |
| `$21` | 1 | `Personality` | ability slot + caught ball |
| `$22` | 1 | `Flags` | bit 0 = IS_EGG; others reserved (0) |
| `$23` | 10 | `Nickname` | no terminator |
| `$2d` | 10 | `OT` | no terminator |
| `$37` | 2 | `Checksum` | 16-bit, see §1.1 |
| `$39` | | end | `SAVEMON_STRUCT_LENGTH = 57` |

(`SAVEMON_STRUCT_LENGTH` is asserted in code; the table above is the source of truth.)

Not stored (recomputed on decode): Status (cleared), current HP (= max, 0 for Eggs),
MaxHP/stats (recalculated from Stat Exp/DVs/level), current PP (restored to max
for the move's PP-Ups), Unused shiny/gender byte (rebuilt from `PokerusStatus` bits 6-7).

### 1.1 Checksum
`sum = 0x7f + Σ_{i=0}^{54} (i+1) * byte[i]` (16-bit, wraps). The nonzero seed makes an
all-zero record invalid. Stored little endian at `$37`. Any mismatch on decode
produces the Bad Egg record (`data/pc/bad_egg.asm`) and returns carry.

## 2. SRAM map (64 KiB, 8 banks)

| Bank | Contents |
|---|---|
| 0 | unchanged: Scratch, mail/mystery gift, saved move index tables, Backup Save |
| 1 | Save, Link Battle Data, Hall of Fame, Crystal Data, Battle Tower, **sSaveVersion + sWritingBackup**, `s4_a013` (36-byte former mobile block) |
| 2 | **Box metadata**: `sNewBox1..N` (active) and `sBackupNewBox1..N` (backup), 33 bytes each; then PokeDB sections **1C / 2C** (overflow pools, 0 entries at 25 boxes) |
| 3 | PokeDB **1A** (143 records) |
| 4 | PokeDB **1B** (111 records) |
| 5 | PokeDB **2A** (143 records) |
| 6 | PokeDB **2B** (111 records) |
| 7 | "SRAM Mobile 2" (trainer rankings etc., unchanged content) |

Arithmetic (25 boxes): logical 500; physical 2 × 254 = 508 (entry numbers are one byte, so 254 per pool is the ceiling; the copy-on-write reserve is therefore 8 records, only relevant when ≥ 492 mons are stored);
143 × 57 = 8,151 ≤ 8,192; metadata 25 × 33 × 2 = 1,650. Bank 2 keeps ~6.5 KiB free,
which is what makes 26–33 boxes possible by growing section C only.

`newbox` (33 bytes): 20 entry bytes (0 = empty, 1..MONDB_ENTRIES = record), 3 pool-bit
bytes (flag_array 20; clear = pool 1, set = pool 2), 9-byte name (no terminator), 1 theme.

## 3. WRAM

* `wTempMon` (existing, WRAM1) keeps the live `party_struct` with **runtime** IDs, so all
  existing consumers (stats screen, gender, base data, item code) work unchanged.
  New: `wTempMonNickname` (11), `wTempMonOT` (11), `wTempMonBox`, `wTempMonSlot`,
  `wTempMonSpeciesIndex` (true 16-bit), `wTempMonIsEgg`.
  `wEncodedTempMon` (58) is separate (not a union) so encode/decode are simple.
* `wPokeDB1UsedEntries`/`wPokeDB2UsedEntries` allocation bitmaps: 2 × 33 bytes, WRAMX.
* PC UI workspace replaces the old `wBillsPCData` (`NEXTU` in the 1300-byte
  "Overworld Map" WRAM0 union at `$c800`): copied HBlank code (size asserted from
  `End - Start`), current/staged row palettes, palette list, species-index lists
  (2 bytes per slot), cursor/held/quick-move state. Everything the interrupt touches
  lives in WRAM0 so it is bank-independent.
* `wBoxNames` (126 bytes of wPlayerData) is removed — names live in box metadata.

## 4. ROM
New code lives in floating `ROMX` sections (`"PC Storage"`, `"PC UI"`, `"PC Data"`);
the linker places them in the unused banks ≥ $92. All cross-bank entry is via
`farcall`; every routine below documents its register contract.

## 5. Storage API (engine/pc/storage.asm) — register/bank contracts

**ABI (verified in `macros/rst.asm` / `home/farcall.asm`):** Crimson's `farcall`
is vanilla-style — `ld a, BANK(x); ld hl, x; rst FarCall` — so it **clobbers `a` and
`hl` on entry**. Vanilla's `ReturnFarCall` also returned `a = c`; that is fixed:
`ReturnFarCall` now parks the callee's `a` in `hFarCallReturnA`, so **`a`, `bc`, `de`
and the flags come back intact** (the storage API returns results in `a`). To pass an
argument *in* `a` across banks use the new `farcall_a` macro (stashes `a` in
`hFarCallReturnA`, which `FarCall_hl` reloads before jumping) — used for
`EnsureStorageSpace`, `SetBoxTheme`, `StorageItemIsMail`. Same-bank calls use plain
`call`; the storage backend, UI and data all live in separate floating sections and
only ever talk through `farcall`.

Slot convention: `b` = box (0 = party, 1..NUM_BOXES = storage; bit 7 = OT party),
`c` = slot (1-based; party 1..6, box 1..20). PokeDB pointer: `d` = pool (1/2),
`e` = entry (0 = null, 1..MONDB_ENTRIES).

| Routine | In | Out | Clobbers | SRAM |
|---|---|---|---|---|
| `GetStorageBoxPointer` | bc | de | a | opened+closed |
| `SetStorageBoxPointer` | bc, de | – | a | opened+closed |
| `RemoveStorageBoxMon` | bc | – | a | opened+closed |
| `GetStorageBoxMon` | bc | wTempMon*, z = empty, c = Bad Egg | af | closed |
| `GetStorageMon` | de | same | af | closed |
| `GetStorageBoxSpecies` | bc | hl = species index (0 = empty), a = flags (egg/shiny/gender) | af, hl | closed |
| `NewStorageBoxPointer` | – | bcde; nc\|z / nc\|nz / c\|z / c\|nz (see Polished) | af | closed |
| `NewStoragePointer` | – | de; c = none free | af | closed |
| `AddStorageMon` | de (+wTempMon) | – | af | closed |
| `UpdateStorageBoxMonFromTemp` | wTempMonBox/Slot | z = ok | af, bc, de | closed |
| `SwapStorageBoxSlots` | bc = dest, de = src | a = PCSWAP_* | af, bc (if c was 0) | closed |
| `FlushStorageSystem` | – | – | af | closed |
| `CheckFreeDatabaseEntries` | – | a = free (255 cap) | af, bc, hl | closed |
| `EncodeTempMon` / `DecodeTempMon` | wTempMon* ↔ wEncodedTempMon | – | all | none |
| `InitializeBoxes` | – | – | all | closed |
| `Get/SetBoxName` | b = box, wStringBuffer1 | | | closed |
| `Get/SetBoxTheme` | wCurBox (0-based) | a | | closed |
| `SaveStorageSystem` / `LoadStorageSystem` | – | – | all | closed |

All routines require `rSVBK` = 1 on entry unless noted; none wait for VBlank; none are
interrupt-safe (the LCD interrupt never touches SRAM or these buffers).

## 6. Save sequence
```
SaveGameData:
  ValidateSave, SaveOptions, SavePlayerData, SavePokemonData, SaveIndexTables
  sWritingBackup := 1            ; "backup in progress"
  SaveChecksum                   ; main copy now valid
  WriteBackupSave:
     BackupPartyMonMail
     SaveStorageSystem           ; active metadata -> backup metadata
     ValidateBackupSave ... SaveBackupChecksum
     sWritingBackup := 0
```
Load: valid main + `sWritingBackup == 1` → rerun `WriteBackupSave`; invalid main +
valid backup → load backup, `SaveGameData`; then `LoadStorageSystem` (backup → active,
flush). Records are immutable while referenced by either snapshot, so no PokeDB bytes
are copied on save.

## 7. Gameplay callers (all direct box access removed)
`SendMonIntoBox` / catch / gifts / Bug Contest / Day-Care egg / Odd Egg / Shiny Ditto →
`AddTempMonToStorage` (encode `wTempMon`, `NewStorageBoxPointer`, place; returns the
four-state result; `CurBoxFullCheck` reports auto-overflow and switches `wCurBox`).
`VAR_BOXSPACE` → free logical slots in the current box (and 0 if the database needs a save).
Search / Lucky Number / 16-bit GC / stats screen BOXMON paths → rewritten on the API
(the GC no longer scans boxes at all: SRAM holds true indexes).


## 8. Graphical PC (engine/pc/bills_pc_ui.asm) — port notes

A native port of Polished's `engine/pc/bills_pc_ui.asm` (same layout, cursor
positions, modes, menus, quick-move animation, themes) on Crimson's engine:

* **VRAM copies.** Polished uses HDMA-backed `Get2bpp`. Crimson's `Get2bpp` queues
  8 tiles per frame for VBlank, so bulk copies go through `BillsPC_DMACopy`: a
  general-purpose DMA run by the VBlank handler (`hDMATransfer`), ≤ 49 blocks per
  frame, from a 16-byte-aligned WRAM source. Minis are staged in `wDecompressScratch`
  (20 box minis = 2 frames), the frontpic is padded to 7×7 at
  `wDecompressScratch + $800` by `PrepareFrontpicInScratch` (load_pics.asm) and copied
  in one frame, alternating VRAM bank 0/1 so the picture and its attributes flip
  together.
* **Tilemap + attribute pushes.** `CopyTilemapAtOnce` disables interrupts for more
  than a frame, which starves the HBlank palette code. `BillsPC_CopyTilemapAtOnce`
  instead pads both maps into `wScratchTileMap`/`wScratchAttrMap` and pushes them in a
  single VBlank with two DMAs (`hDMATransfer` + the new `hDMATransfer2` second transfer from
  `wScratchAttrMap` in `home/video.asm`). The engine's menus/textboxes only push tiles
  (`hBGMapMode` 1), so `BillsPC_MenuTextbox`, `BillsPC_PrintTextbox`,
  `BillsPC_YesNoBox`/`NoYesBox`, `BillsPC_Menu` and `BillsPC_CloseWindow` push the
  attribute map explicitly before a box is drawn and after a window closes
  (`wSpriteUpdatesEnabled` is forced to 0 while the PC is open so `ApplyTilemap` never
  falls back to `CopyTilemapAtOnce`).
* **HBlank palettes.** `BillsPC_LCDCode` (copied to `wLCDBillsPC`, WRAM0) runs from the
  STAT interrupt through `hLCDCPointer = LCD_CUSTOM_HANDLER` /
  `hLCDInterruptFunctionTarget` (home/lcd.asm). While the PC is open `rSTAT` is set to
  the **LYC interrupt only** (`BillsPC_EnableHBlank`; `BillsPC_DisableHBlank` restores
  the game's HBlank-interrupt setting), so each phase starts at the top of scanline
  `rLYC`, busy-waits for that line's HBlank and writes its palettes right at the start
  of the HBlank + OAM-scan window. Two phases per icon row (LYC 71, 87, 103, 119, 135):
  box columns 2-4 (12 bytes, then LYC+1); BG palette 3 colour 0 + party columns + box
  column 1 (14 bytes), then the next LYC, the next row's palettes and its colour 0
  (`wBillsPC_CurColor0`: white inside the boxes, the theme background from LYC 135 so
  the shiny/Pokérus symbols at the top of the next frame sit on the background). A
  phase that finds `rLY != rLYC` (interrupts were off for over a line) does nothing
  and the row is picked up next frame. The last row restages row 0, which restores the
  top-of-screen palettes for the next frame, exactly as in Polished.
  Why not Polished's HBlank-interrupt version: Crimson's LCD dispatch is ~17 cycles
  slower, and a line with the cursor, a held mini and the mode icon on it shortens
  HBlank enough that the last writes landed in mode 3, where the CGB drops them — rows
  or the symbol cells then showed the wrong colours for a frame (the reported "blink" /
  "white box"). The bare cursor now also uses a 4-sprite frameset
  (`SPRITE_ANIM_FRAMESET_PC_CURSOR_EMPTY`) so idle lines carry fewer sprites.
* **Fonts/tiles.** VRAM bank 0: frontpic $00-$30, frame/“PARTY”/Pokérus $31-$41,
  shiny star $42, coloured ♂/♀ $43-$44 (built from the 1bpp font), battle-extra font at
  $60+ (`<LV>`, ◀). Bank 1: object tiles $00-$3e, party minis $80+, box minis $98+,
  blank $7f. Item names use the normal font (no VWF): the hovered mon's item at (8,3)
  with its category icon as sprite 30 at column 7; the held item at (8,2) with the
  marker sprite 31.
* **Summary.** `predef StatsScreenInit` with `wMonType = TEMPMON` (wBufferMon);
  `StatsScreenDPad::` (exported from the UI bank) steps through the party/box with
  `Prev/NextStorageBoxMon` and the cursor follows (`BillsPC_MoveCursorAfterStatScreen`).
* **Items.** GIVE opens the pack in deposit/sell mode (`DepositSellPack`) with the
  party menu's holdability rule; bag/take/move/Mail follow Polished, with Mail composed
  through `_ComposeMailMessage` and taken through the party-menu flow (mailbox or bag).
* **Not ported:** the Mewtwo form refresh and roaming-beast respawn on release
  (Polished-specific).
* **Link script:** `"Overworld Weather"` was unpinned from bank $23 (the sprite-anim
  additions no longer fit next to it); it floats like the PC sections.

## 9. Emulator notes
Icons, palettes and the HBlank effect were verified in PyBoy (rebuilt with 8 SRAM
banks and 8-bit MBC30 ROM banks: stock PyBoy masks ROM banks to 7 bits, so anything in
banks ≥ $80 read garbage). PyBoy is not cycle-accurate for STAT timing and does not
model the CGB ignoring palette writes during mode 3, which is why the original
HBlank-interrupt version looked fine there but blinked in accurate emulators; the
LYC + wait-for-HBlank version (§8) starts writing within ~15 double-speed cycles of
HBlank, well inside the worst-case (10 sprites on the line) window.
`tools/blink_probe.py` records every frame of a swap/deposit/idle sequence and reports
frames that differ from both neighbours.

## 10. Tests (tools/)
* `pc_harness.py` — PyBoy harness; calls ROM routines by symbol (parks on a
  `di / jr @` sentinel so registers survive the frame boundary).
* `test_pc_storage.py` (122 checks), `test_pc_save.py` (25), `audit_save.py` (185).
* `pc_ui_harness.py` + `test_pc_ui.py` / `test_pc_ui2.py` / `test_pc_ui3.py` /
  `test_pc_ui4.py` — drive `UseBillsPC` with joypad input and screenshots: cursor,
  box switching, summary, swap mode, party deposit, item mode (bag/pack/give/Mail),
  release, release-all, rename, theme preview, change box, and the forced save when
  the database is exhausted.
