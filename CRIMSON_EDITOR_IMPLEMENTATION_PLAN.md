# Crimson Crystal Save Editor — Technical Analysis & Implementation Plan

**Target:** adapt [Polished Editor](https://github.com/KohKaiSern/polishededitor) (SvelteKit save editor for Polished Crystal) into a save editor for [Pokémon Crimson Crystal](https://github.com/lukedaysgrace-dot/Pokemon-Crimson-Crystal).

**Audience:** an autonomous coding agent (OpenAI Codex) plus the ROM hack author (Lucas).

**Status of this document:** analysis only. Nothing in either repository has been changed.

**Snapshots analysed:**

| Repo | Commit | Date |
|---|---|---|
| polishededitor | `252d24f` ("Fix Pokerus-parsing bug") | 2026-07-13 |
| Pokemon-Crimson-Crystal | `06c4a7bb` ("3 simple QoL updates") | 2026-10-15 |

---

## 0. Ground rules for the implementing agent

1. **Crimson Crystal is not Polished Crystal.** It is a **pokecrystal (vanilla Crystal disassembly) derivative** that has added three things: a Polished-*style* pointer-based PC storage system, the **pokecrystal16** 16-bit species/move ID system, and a 64 KiB (8-bank, MBC30-style) SRAM. Almost every byte-level assumption in Polished Editor's parsers is wrong for Crimson. Do **not** port parser code line by line. Port the **architecture** and the **UI**, and rewrite the save layer against the spec in §4.
2. **Never hardcode an SRAM/WRAM address.** All addresses come from the `.sym` file of the exact ROM build that produced the save. The tables in this document show current values **for orientation only**.
3. **Never hardcode a game-data list** (species, moves, items, abilities, TMs, landmarks, themes, charmap, keyboard). These are all generated from the Crimson source by the extractor (§8).
4. **Identity is by constant/index, never by display name.** Crimson has duplicate display names: regional forms and the clone starters share base names. For example, `MEOWTH`, `MEOWTH_ALOLAN` and `MEOWTH_GALARIAN` are all named "MEOWTH".
5. **No-op round-trip invariant.** For a clean save (main copy valid, backup equal to main, both box snapshots equal, `sWritingBackup == 0`), `write(parse(file))` must be **byte-identical** to the input. Every bit the semantic model does not own must be carried over from the original bytes.
6. **Fail loudly.** Any unknown ID, bad checksum, impossible value or unknown asm pattern is shown as a visible diagnostic. It must never crash the app (`find()!`) and never be silently dropped.
7. Each phase in §11 has acceptance criteria. A phase is not done until its tests pass in CI.
8. Where this document says "verify in source", open the named Crimson file and confirm it before coding. Crimson changes often.

---

## 1. Executive summary (key findings)

1. **Different base game.** Crimson's party/box structs, bag, player data, text encoding and save container are pokecrystal-based. The only Polished-like part is the PC box metadata ("newbox") concept. Even that differs in record size (57 vs 49 bytes), checksum algorithm, pool sizes (143/111 vs 167/28/12) and box count (25 vs 20).
2. **64 KiB saves.** The ROM header advertises 8 SRAM banks (`rgbfix -r 5`, cart type `$10` MBC3+TIMER+RAM+BATTERY). Saves are **65,536 bytes**, plus an optional emulator RTC trailer: the user's `.bak` saves are 65,584 bytes, a 48-byte VBA-M-style footer. Polished Editor rejects anything outside 32,000–33,000 bytes.
3. **16-bit IDs everywhere.** There are 495 species and 421 moves (more than 255). Party mons store **8-bit runtime IDs** that are translated through **per-save conversion tables** (`sPokemonIndexTable`, `sMoveIndexTable`). Box records store **true 16-bit indexes**. Writing a raw species or move index into a party struct produces the wrong Pokémon. Writing a new species without allocating a table slot does the same.
4. **Two checksummed copies plus a separately checksummed move table.** The main copy is bank 1 and the backup is bank 0. Each copy's checksum covers its game data, its Pokémon index table and its conversion-table checksum field. That field is itself the sum of the copy's move index table. Box metadata has an active and a backup snapshot. Load-time logic (§4.3) decides which one wins.
5. **The save layout drifts without a version bump.** I built two commits of Crimson: `5dc51b77` (2026-09-09) and HEAD. Between them the saved WRAM shifted by up to 5 bytes: one more TM, more event flags and a larger Pokédex. `SAVE_FORMAT_VERSION` stayed `2` in both. **The editor cannot trust `sSaveVersion` alone.** It must fingerprint the layout and select the matching build profile by validating checksums (§9.3).
6. **Verified by execution, not just by reading.** I built the ROM with RGBDS 0.5.2 (it builds on Linux in about 1 minute), extracted the `.sym`, and checked the checksum algorithms against two of your real saves; both validated. I then ran the ROM's own `ComputeSavedMonChecksum` and `EncodeSavedMon` routines under PyBoy and confirmed the record codec spec in §4.8 bit for bit. See Appendix C.
7. **Name collisions corrupt saves.** Polished Editor maps names to indexes with `find(p => p.name === …)`. In Crimson that silently converts an Alolan Rattata into a Kanto Rattata on save.
8. **The release and debug ROMs share a save layout today.** Every saved symbol is identical between `pokecrystal.gbc` and `pokecrystal_debug.gbc`. The editor should still treat them as separate builds and verify this in CI.
9. **Licensing blocker.** `polishededitor` has **no LICENSE file**, so by default all rights are reserved. Before forking and redistributing, get written permission from the author (KohKaiSern / "Rev3lation") or treat the code as a reference and write the implementation independently. See §13.
10. **Crimson repo hygiene issues that affect this project:**
    - The committed `rgbds/` binaries and `rgbds-0.5.2-linux-x86_64.tar.xz` are corrupt. The tarball fails `xz` and `rgbasm` has missing section headers, most likely from the `* text eol=lf` rule before the binary overrides were added. CI must build RGBDS v0.5.2 from source.
    - `*.sav`, `*.bak`, `*.ram`, `*.srm` and `*.rtc` are **not** marked binary in `.gitattributes`. `pokecrystal.sav.before-lugia-wing-20260907.bak` is 65,582 bytes, 2 bytes shorter than its siblings, with zero CR/LF pairs left in it. That pattern suggests CR bytes were stripped, so treat that file as likely corrupt.
    - `docs/pc_storage_design.md` is referenced from `sram.asm`, `engine/pc/*.asm`, `macros/wram.asm` and `constants/*` but **does not exist** in the repo. §4.8 of this document is a replacement spec derived from the code.

---

## 2. How this analysis was verified

- Cloned both repositories. The local copy on Lucas's machine matches GitHub HEAD apart from two untracked `Zone.Identifier` files.
- Built RGBDS **v0.5.2** from source. This is the version named in `local.mk`, `.env.make` and `.envrc`.
- `make pokecrystal.gbc` and `make debug` at HEAD both succeeded. Took symbol addresses from `pokecrystal.sym` and `pokecrystal_debug.sym`.
- Built commit `5dc51b77` in a separate worktree. Validated all four checksums (main, main move table, backup, backup move table) on `pokecrystal.sav.before-elemental-sphere-20260909-2005.bak` and `pokecrystal.sav.before-key-item-fix-20260909-2008.bak` using that build's symbols. All matched. Decoded the party (a Lv100 Croconaw, species ID 6 → index 159 through the conversion table; moves through the move table) and the box metadata (default names "BOX 1"…, `@`-padded).
- `pokecrystal_debug.gbc.ram` is an **all-zero** 64 KiB file. It is not usable as a fixture.
- Under PyBoy, using the repo's own `tools/pc_harness.py` harness, called `ComputeSavedMonChecksum` on 20 random records (20/20 matched the Python reference) and `EncodeSavedMon` on a constructed `wTempMon` with species index 282 (MESMERIA), moves 421/300/1/256, PP Ups, Pokérus strain 5, shiny+male flags and Hidden Power DARK. Every field landed exactly where §4.8 says.

---

## 3. How Polished Editor works today

### 3.1 Stack and layout

- SvelteKit 2, Svelte 5 runes, Tailwind 4, Flowbite-Svelte, Vite 7, `@sveltejs/adapter-vercel` and `@vercel/analytics`. The app is client-only: everything runs in the browser and nothing is uploaded.
- Path aliases (`svelte.config.js`): `$data` → `src/data`, `$extractors`, `$parsers`, `$ui`, `$components`.
- `polishedcrystal/` is a **vendored copy** of the Polished Crystal source, not a submodule. `polishedcrystal.sym` is a committed symbol file.
- `npm run extract` runs `tsx src/extractors/index.ts`. It parses `polishedcrystal/` plus the `.sym` and writes `src/data/*.json`. It also renders sprites into `src/gfx/**` (committed).
- **The UI loads sprites from `https://raw.githubusercontent.com/KohKaiSern/polishededitor/refs/heads/main/src/...`**, not from local assets. A fork would keep showing upstream's sprites. The player model images even point at a different repo (`polishededitornew`).

### 3.2 Read path (`src/lib/components/main.svelte` → `src/parsers/parseSave.ts`)

1. `validateSave`: size must be 32,000–33,000 bytes. `retrieve(buf, sSaveVersion, 2)` (2-byte big-endian) must equal `versions.save`.
2. `parseSave(file, PF)` builds `Data = { party, boxes, bag, player, pokedex }`. `PF` is the Polished/Faithful toggle, chosen manually by the user.
3. **Only the backup copy is read.** `extractors/addresses.ts` converts WRAM symbols to SRAM file offsets with `addr + sBackupGameData - wGameData`. Bank math is `0x2000*bank + addr - 0xA000`.
4. `parseParty`: count at `sBackupPokémonData`; 48-byte mons at `+8 + 48*i`; OT names at `wPartyMonOTs + 11*i` (7 chars); nicknames (10 chars). Hyper-training comes from an extra party byte.
5. `parseBoxes` / `parseBoxAddresses`: 20 boxes × 33-byte newbox from `sBackupNewBox1`. Entries are 1-based. A pool bit array selects `sBoxMons1*` or `sBoxMons2*`. Section thresholds are hardcoded at 167 and 195. Records are 49 bytes. Nicknames and OT use 7-bit chars, with the checksum hidden in the MSBs.
6. `parseMon`: species is 9 bits (byte 0 plus bit 5 of byte 21), form is 5 bits, there are 6 EVs, 3 DV bytes and a 2-byte personality (shiny, ability, nature, gender, egg), and a 3-byte caught data block. Values are resolved to display **names** via `pokemon[PF].find(p => p.index === …)!.name` and similar lookups.
7. `parseBag`: four counted pockets (items/medicine/balls/berries); an 11-byte TM/HM bitfield (81 flags); 39 key-item slots, zero-terminated; coins; apricorns, wings and exp candy as fixed arrays; blue card.
8. `parsePlayer`: ID, name, rival name, money (3 bytes) and `wPlayerGender` (3 values) from player data.
9. `parsePokedex`: seen/caught bit arrays indexed by `form.dexNo - 1`.
10. Side effect bug: `readString(..., hasChecksum=true)` **mutates the input buffer** (`file[i] |= 0x80`).

### 3.3 Write path (`reverseParseSave.ts`)

1. Re-reads the original `File` from disk and overwrites only the fields it models, onto that fresh copy.
2. Writes party, boxes (both the newbox metadata and the records, then `checksumBoxMon`), bag, player and Pokédex, **only into the backup copy**.
3. Computes `sum(sBackupGameData .. sBackupGameDataEnd) & 0xFFFF` and writes it little-endian into **both** `sBackupChecksum` and `sChecksum`.

   The main copy's data is not updated, so its checksum is now (almost always) wrong. The game falls back to the backup and repairs the main copy from it. This is a deliberate trick, and it fails silently when the sums collide (about 1 in 65,536).
4. Box allocation: entries are numbered sequentially from 1 and wrap at 201. Boxes 1–10 are forced to pool 1 and boxes 11–20 to pool 2.
5. Downloads as `<name>_EDITED.<ext>`.

### 3.4 Data generation (extractors)

- `splitRead(path)` strips comments and `MACRO…ENDM` blocks, replaces `#`→`Poké`, `@`→``, `¯`→` ` and `PSYCHIC_M`→`PSYCHIC`, and splits `if DEF(FAITHFUL)` branches into two variants.
- `common.ts`:
  - `extractIDs` walks `const_def` / `const` / `const_skip` between optional start/end markers.
  - `extractNames` assigns quoted strings by position.
  - `extractDescs` follows `dw Label` pointers to `Label:` and concatenates `text`/`next` strings.
  - `extractPaths` and `extractPNGs` handle item icons and palettes.
- Each extractor (`moves.ts`, `abilities.ts`, `items.ts`, `keyItems.ts`, `pokemon.ts`, `tmhms.ts`, `locations.ts`, `natures.ts`, `growthRates.ts`, `boxThemes.ts`, `apricorns.ts`, `wings.ts`, `expCandy.ts`, `charmap.ts`, `versions.ts`, `addresses.ts`) hardcodes the **line shape and line position** of Polished's asm. Example: `pokemon.ts` reads base stats from `BASE[0]`, types from `BASE[1]` and abilities from `BASE[6]`.
- `keyboard.ts` is a hardcoded character list.
- The output JSON is keyed `{ polished: [...], faithful: [...] }`, and entries are referenced **by display name** across the app.

### 3.5 UI

- `main.svelte`: upload, PF toggle, editor tabs (Party / Boxes / Bag / Player / Pokedex), download.
- Mon editing: `mon-card` opens `mon-drawer` with tabs Basics, Stats, Moves, Caught and Misc.
- UI primitives in `lib/components/ui/*`: combobox, dropdown-select, number-input, radio-select, carousel, cycler, full-cycler, colored-card, type-icon (external SVGs from a pinned GitHub commit), healthbar, heal, item-icon, mon-sprite, text-input (an on-screen keyboard drawer).
- Known bugs to fix while adapting:
  - `heal.svelte` uses `Math.max(…, 63)`; it should be `Math.min`.
  - Stats and max HP are **never recomputed** after level, DV or species edits.
  - `move-card` has a group named "TM & HM Moves" in one place and "TMs & HMs" in another, so that filter never matches.
  - Leftover `console.log` calls in `parseBoxAddresses`.
  - `$inspect(data)` is left in production.
  - Any unknown ID throws through `find()!`.

---

## 4. Crimson Crystal save format (verified specification)

Unless noted, multi-byte **game** values (IDs, exp, HP, stats, stat exp, money, coins) are **big-endian**. Checksums and 16-bit **table** values (conversion table entries, savemon species index, savemon checksum) are **little-endian**. Both were verified.

### 4.1 Container

- 8 SRAM banks × 8 KiB = 65,536 bytes. File offset of `BB:AAAA` is `BB*0x2000 + (AAAA - 0xA000)`.
- Accept these sizes:
  - exactly 65,536;
  - 65,536 + an RTC trailer. 48 bytes is the VBA-M/mGBA style. Other lengths up to about 64 extra bytes should be accepted with a warning.
- Preserve any trailer byte-for-byte on output.
- **Reject 32,768-byte files** with a clear message: "your emulator does not support 64 KiB MBC30 SRAM; boxes in banks 3–6 are missing."
- Required emulator support: MBC30 / 8 RAM banks (mGBA, BGB, SameBoy and Gambatte-based cores support it). The repo's PyBoy tests patch the cart to MBC5 in memory for this reason.

### 4.2 SRAM map (HEAD build — orientation only, always read from `.sym`)

| Symbol | Bank:Addr | File offset |
|---|---|---|
| sPartyMail | 00:A600 | 0x00600 |
| **sMoveIndexTable** (main copy's move table) | 00:AE00 | 0x00E00 (0x200 bytes) |
| **sBackupMoveIndexTable** | 00:B000 | 0x01000 (0x200 bytes) |
| sBackupOptions | 00:B200 | 0x01200 (8 bytes) |
| sBackupCheckValue1 (=99) | 00:B208 | 0x01208 |
| **sBackupSaveData** = sBackupGameData = sBackupPlayerData | 00:B209 | 0x01209 |
| sBackupCurMapData | 00:B9AA | 0x019AA |
| sBackupPokemonData | 00:B9DC | 0x019DC |
| sBackupGameDataEnd = sBackupPokemonIndexTable | 00:BD34 | 0x01D34 (0x100 bytes) |
| sBackupConversionTableChecksum | 00:BE34 | 0x01E34 (LE16) |
| sBackupSaveDataEnd | 00:BE36 | 0x01E36 |
| **sBackupChecksum** | 00:BEBE | 0x01EBE (LE16) |
| sBackupCheckValue2 (=127) | 00:BEC0 | 0x01EC0 |
| sOptions | 01:A000 | 0x02000 |
| sCheckValue1 (=99) | 01:A008 | 0x02008 |
| **sSaveData** = sGameData = sPlayerData | 01:A009 | 0x02009 |
| sCurMapData | 01:A7AA | 0x027AA |
| sPokemonData | 01:A7DC | 0x027DC |
| sGameDataEnd = sPokemonIndexTable | 01:AB34 | 0x02B34 (0x100 bytes) |
| sConversionTableChecksum | 01:AC34 | 0x02C34 (LE16) |
| sSaveDataEnd | 01:AC36 | 0x02C36 |
| **sChecksum** | 01:ACBE | 0x02CBE (LE16) |
| sCheckValue2 (=127) | 01:ACC0 | 0x02CC0 |
| sCrystalData (byte 0 = wPlayerGender) | 01:B97C | 0x0397C (7 bytes, **not checksummed**) |
| **sSaveVersion** (=`SAVE_FORMAT_VERSION`, currently 2) | 01:B99C | 0x0399C |
| **sWritingBackup** (0/1) | 01:B99D | 0x0399D |
| sNewBox1 … sNewBox25 (active snapshot) | 02:A000 | 0x04000 (25 × 33) |
| sBackupNewBox1 … 25 (backup snapshot) | 02:A339 | 0x04339 (25 × 33) |
| sBoxMons1A (pool 1, entries 1–143) | 03:A000 | 0x06000 (143 × 57) |
| sBoxMons1B (pool 1, entries 144–254) | 04:A000 | 0x08000 (111 × 57) |
| sBoxMons2A (pool 2, entries 1–143) | 05:A000 | 0x0A000 |
| sBoxMons2B (pool 2, entries 144–254) | 06:A000 | 0x0C000 |

WRAM ↔ SRAM mapping: the saved WRAM blocks are contiguous (`wPlayerData`…`wPlayerDataEnd` = `wCurMapData`…`wCurMapDataEnd` = `wPokemonData`…`wPokemonDataEnd`). So `sram(copy, wX) = s{Backup}GameData + (wX − wPlayerData)`. Implement it per block (player / curmap / pokemon) using each block's own start symbol, and assert contiguity.

### 4.3 Load algorithm (from `engine/menus/save.asm`) — the editor must replicate it to know which copy is authoritative

```
CheckPrimarySaveFile: sSaveVersion == SAVE_FORMAT_VERSION && sCheckValue1 == 99 && sCheckValue2 == 127
TryLoadSaveFile:
  if VerifyChecksum(main):              # sum(sSaveData..sSaveDataEnd) == sChecksum
                                        #   && sum(sMoveIndexTable[0x200]) == sConversionTableChecksum
      load main player/curmap/pokemon data + main index tables
      if sWritingBackup == 1: WriteBackupSave   # active box snapshot -> backup snapshot, main -> backup
      LoadStorageSystem                  # BACKUP box snapshot -> ACTIVE (then rebuild allocation)
      WriteBackupSave                    # refresh backup copy from loaded main
  elif VerifyBackupChecksum(backup) (and backup check values / version ok):
      load backup data + backup index tables
      LoadStorageSystem                  # backup snapshot -> active
      repair main from backup; sWritingBackup = 0
  else: "The save file is corrupted!"
```

Effective view the editor must parse:

| Condition | Game data source | Box snapshot source |
|---|---|---|
| main valid, `sWritingBackup == 0` | main | **backup** snapshot |
| main valid, `sWritingBackup == 1` | main | **active** snapshot (it is copied to backup first) |
| main invalid, backup valid | backup | backup snapshot |
| neither valid | refuse to edit (show the diagnostics view only) | — |

Write strategy (§4.14): write **both** copies, **both** snapshots, **both** move tables identically, recompute all four checksums, and set `sWritingBackup = 0`.

### 4.4 Checksums

- `Checksum16(range) = (Σ bytes) & 0xFFFF`, stored **little-endian**.
- Main copy, computed in this order:
  1. `sConversionTableChecksum = Checksum16(sMoveIndexTable, 0x200)`. The table is in bank 0, but the checksum field is in bank 1.
  2. `sChecksum = Checksum16(sSaveData .. sSaveDataEnd)`. This range **includes** `sPokemonIndexTable` and `sConversionTableChecksum`, so step 1 must happen first.
- Backup copy: the same, with `sBackupMoveIndexTable`, `sBackupConversionTableChecksum`, `sBackupSaveData..sBackupSaveDataEnd` and `sBackupChecksum`.
- Not checksummed: options, check values, `sCrystalData`, mail, box metadata, PokeDB records (they have per-record checksums), Hall of Fame, `sSaveVersion` and `sWritingBackup`.
- The move table size comes from `wMoveIndexTableEnd − wMoveIndexTable` in the sym (0x200 today). The Pokémon table size comes from `wPokemonIndexTableEnd − wPokemonIndexTable` (0x100).

### 4.5 Saved game data — fields the editor uses (HEAD offsets)

| Field | Symbol | Offset | Encoding |
|---|---|---|---|
| Trainer ID | wPlayerID | wPlayerData+0x000 | BE16 |
| Player name | wPlayerName | +0x002 | 11 bytes, max 7 chars + `@` |
| Mom's name | wMomsName | +0x00D | 11 bytes |
| Rival name | wRivalName | +0x018 | 11 bytes, max 7 chars |
| Red/Green names | wRedsName / wGreensName | +0x023 / +0x02E | 11 bytes |
| Play time | wGameTimeHours… | +0x049 | hours BE16, min, sec, frames |
| Status flags | wStatusFlags / wStatusFlags2 | +0x3D1 / +0x3D2 | bit 6 HoF; flags2 bit 3 **Hard Mode** |
| Money | wMoney | +0x3D3 | 3-byte BE binary, max 999,999 |
| Mom's money | wMomsMoney | +0x3D6 | 3-byte BE |
| Coins | wCoins | +0x3DA | BE16, max 9,999 |
| Badges | wJohtoBadges / wKantoBadges | +0x3DC / +0x3DD | bitfields |
| TMs/HMs | wTMsHMs | +0x3DE | `NUM_TMS + NUM_HMS` bytes (54 + 7 = 61), **one quantity byte each** |
| Items pocket | wNumItems / wItems | +0x41B | count, then (id, qty) × 40, then `$FF` |
| Key items | wNumKeyItems / wKeyItems | +0x46D | count, then id × 25, then `$FF` |
| Balls | wNumBalls / wBalls | +0x488 | count, then (id, qty) × 12, then `$FF` |
| PC items | wNumPCItems / wPCItems | +0x4A2 | count, then (id, qty) × 50, then `$FF` |
| Event flags | wEventFlags | +0x5E8 | `flag_array NUM_EVENTS` (2,120+ flags, LSB-first) |
| Current box | wCurBox | +0x6F1 | byte |
| Blue Card points | wBlueCardBalance | +0x748 | byte |
| **Gameplay rules** | wGameplayRules | +0x76A | bit0 original types, bit1 original base stats, bit2 abilities disabled |
| Map/position | wMapGroup/wMapNumber/wYCoord/wXCoord | +0x7B1… | in wCurMapData (advanced/debug only) |
| Party count | wPartyCount | wPokemonData+0x000 | 0–6 |
| Party species list | wPartySpecies | +0x001 | 6 × **8-bit ID** (`$FD` = EGG), `$FF` terminator |
| Party mons | wPartyMon1… | +0x008 | 6 × 50 bytes (§4.7) |
| Party OT names | wPartyMonOT | +0x134 | 6 × 11 bytes |
| Party nicknames | wPartyMonNicknames | +0x176 | 6 × 11 bytes |
| Pokédex caught/seen | wPokedexCaught / wPokedexSeen | +0x1B8 / +0x1F6 | `flag_array NUM_POKEMON` (62 bytes); bit (index−1), LSB-first |
| Unown dex | wUnownDex, wUnlockedUnowns | +0x234 | 26 bytes + 1 |
| Day-care mons | wBreedMon1 / wBreedMon2 | +0x251 / +0x28C | nick (11) + OT (11) + box_struct (34); species/moves are 8-bit IDs |
| Egg mon | wEggMon | +0x2DA | box_struct |
| Contest mon | wContestMon | +0x2FD | party_struct |
| Roaming mons | wRoamMon1–3 | +0x332 … | species (8-bit ID), level, map, HP, DVs |
| Player character | wPlayerGender → **sCrystalData+0** | — | 0 = Gold, 1 = Lyra, 2 = Indigo, 3 = Mint. Bit 0 = "female" for generic checks. See `engine/menus/init_gender.asm` `CharSelectOrder` |
| Options | wOptions → sOptions / sBackupOptions | — | 8 bytes |

### 4.6 16-bit conversion tables (pokecrystal16) — `engine/16/*`, `macros/wram_16bit.asm`, `constants/16_bit_translation_constants.asm`

Table layout (saved verbatim):

```
+0                    UsedSlots              (count of non-zero entries)
+1                    LastAllocatedIndex
+2                    Entries[N]             little-endian u16 true index; entry for ID k is at +2+2*(k-1)
...pad to multiple of $100...
                      EntryCache[CACHE]      (IDs; hash = (lo ^ hi) & (CACHE-1))
                      LockedEntries[LOCKED]  (IDs)
                      LastAllocated[RECENT]  (IDs)
```

| Table | N (`*_ENTRIES`) | LOCKED | CACHE | RECENT | Reserved IDs (`*_MINIMUM_RESERVED_INDEX`) | Size |
|---|---|---|---|---|---|---|
| Pokémon | 100 | 30 | 16 | 8 | `$FD`–`$FF` ↔ `$FFFD`–`$FFFF` (`EGG EQU -3`) | 0x100 |
| Move | 230 | 18 | 16 | 16 | `$FF` ↔ `$FFFF` | 0x200 |

Parse these constants from the asm; do not hardcode them.

- `idToIndex(id)`:
  - `0` → `0`.
  - `id ≥ RESERVED` → `0xFF00 | id`.
  - `id > N` → invalid; report it.
  - otherwise the `Entries[id-1]` value.
- `indexToId(index)`:
  - `0` → `0`.
  - Reserved range → its low byte.
  - Otherwise search `Entries` for `index` and return `slot+1` if found.
  - Otherwise allocate the first zero entry: write the index LE, `UsedSlots++`. Optionally append to `LastAllocated` and update `LastAllocatedIndex` the way the game does.
  - If no free entry exists, raise an error ("conversion table full; save in-game once to let the game garbage-collect").
- **Never free entries.** These IDs are referenced from saved structures:
  - party species and moves;
  - day-care mons and the egg mon (species and moves);
  - roaming mons (species);
  - contest mon and bug contest species;
  - Locked and LastAllocated arrays.

  The game garbage-collects at every save (`ForceGarbageCollection` in `SaveIndexTables`), so tables in a real save are already compact.
- The cache needs no maintenance. The game validates cache hits against `Entries`.
- Both copies (main and backup) of **both** tables must be written identically.

### 4.7 Party struct (`party_struct`, 50 bytes; verified against sym)

| Off | Size | Field | Notes |
|---|---|---|---|
| 0 | 1 | Species | **8-bit runtime ID** → Pokémon conversion table. For eggs this is the real species; the EGG marker lives in `wPartySpecies` |
| 1 | 1 | Item | item ID (8-bit) |
| 2 | 4 | Moves | **8-bit runtime IDs** → move conversion table, 0 = none |
| 6 | 2 | OT ID | BE16 |
| 8 | 3 | Exp | BE24 |
| 11 | 10 | Stat Exp | 5 × BE16: HP, Atk, Def, Spd, Spc (Spc is used for both SpA and SpD) |
| 21 | 2 | DVs | byte 21 = Atk<<4 \| Def, byte 22 = Spd<<4 \| Spc. HP DV is derived (§4.13) |
| 23 | 4 | PP | bits 7–6 = PP Ups used, bits 5–0 = current PP |
| 27 | 1 | Happiness | egg: remaining hatch cycles |
| 28 | 1 | Pokérus | vanilla: high nibble strain, low nibble days; strain≠0 with days=0 means cured |
| 29 | 1 | Caught time/level | bits 7–6 time (0 none, 1 morn, 2 day, 3 nite), bits 5–0 level (game caps at 63) |
| 30 | 1 | Caught OT gender/location | bit 7 = OT female, bits 6–0 landmark (`$7E` GIFT_LOCATION, `$7F` EVENT_LOCATION) |
| 31 | 1 | Level | |
| 32 | 1 | **Personality** | bits 6–5 ability slot (01 = 1, 10 = 2, 11 = hidden, 00 = unset → slot 1); bits 4–0 caught ball (`CAUGHTBALL_*` index, **not** an item ID); bit 7 reserved |
| 33 | 1 | **HiddenPowerType** | type constant, 0 = default (`HIDDEN_POWER_DEFAULT_TYPE` = DARK) |
| 34 | 1 | Status | bits 2–0 sleep turns, bit 3 PSN, 4 BRN, 5 FRZ, 6 PAR (no toxic bit) |
| 35 | 1 | **"Unused" = shiny/gender flags** | bit 7 `MON_SHINY_FLAG`, bit 6 `MON_MALE_FLAG` |
| 36 | 2 | HP | BE16 |
| 38 | 2 | Max HP | BE16 |
| 40 | 10 | Atk, Def, Spd, SpA, SpD | BE16 each |

`box_struct` (day-care, egg mon) is bytes 0–33 of the above.

### 4.8 PC storage system (replacement for the missing `docs/pc_storage_design.md`)

**Box metadata** (`newbox`, 33 bytes; 25 boxes; two snapshots back-to-back):

| Off | Size | Field |
|---|---|---|
| 0 | 20 | Entries: 0 = empty, 1–254 = PokeDB entry; values > 254 are treated as empty (sanitized) |
| 20 | 3 | Pool bits, `flag_array 20`, LSB-first: bit clear → pool 1, set → pool 2 |
| 23 | 9 | Name: **no terminator**, `@`-padded (naming screen allows 8 characters) |
| 32 | 1 | Theme (`THEME_*` index, `constants/pc_constants.asm`) |

**PokeDB addressing** (`OpenPokeDB`):

```
pool p ∈ {1,2}, entry e ∈ 1..254 (MONDB_ENTRIES = A + B + C; read A/B/C from constants/pokemon_data_constants.asm)
k = e - 1
if k < A:         addr = sBoxMons{p}A + 57*k
elif k < A+B:     addr = sBoxMons{p}B + 57*(k-A)
else (C > 0):     addr = sBoxMons{p}C + 57*(k-A-B)     # C is currently 0; sections exist only if C>0
```

**Record (`savemon_struct`, `SAVEMON_STRUCT_LENGTH` = 57 = 0x39):**

| Off | Size | Field |
|---|---|---|
| 0x00 | 2 | Species: **true 16-bit index, little-endian** |
| 0x02 | 1 | Item |
| 0x03 | 4 | Moves: low 8 bits of true move index |
| 0x07 | 2 | OT ID (BE) |
| 0x09 | 3 | Exp (BE) |
| 0x0C | 10 | Stat Exp (5 × BE16) |
| 0x16 | 2 | DVs |
| 0x18 | 4 | MovesHi/PP Ups: bits 5–0 = move index bits 13–8 (`$3F` decodes as `$FF`), bits 7–6 = PP Ups |
| 0x1C | 1 | Happiness |
| 0x1D | 1 | bits 5–0 Pokérus (2-bit strain + 4-bit days), **bit 6 male flag, bit 7 shiny flag** |
| 0x1E | 2 | Caught data (same as party bytes 29–30) |
| 0x20 | 1 | Level |
| 0x21 | 1 | Personality |
| 0x22 | 1 | Flags: bit 0 is-egg, bits 5–1 HiddenPowerType |
| 0x23 | 10 | Nickname: 10 chars, `@`-padded (no stored terminator) |
| 0x2D | 10 | OT name: 10 bytes, `@`-padded |
| 0x37 | 2 | Checksum (little-endian) |

**Record checksum** (`ComputeSavedMonChecksum`; verified 20/20 against the ROM routine):

```
run = 0; acc = 0
for i in 0 .. 0x36: run = (run + r[i]) & 0xFFFF; acc = (acc + run) & 0xFFFF
checksum = (0x7F + acc) & 0xFFFF        # == 0x7F + Σ r[i]*(55-i), mod 2^16
```

A mismatched checksum is decoded **as a Bad Egg** by the game (`BadEggRecord`). The editor must flag these records and never re-checksum them silently.

**Encoding rules (`EncodeSavedMon`):**

- Pokérus folding (`fold_pokerus_strain`): `if v >= 0x40 { v &= 0x3F; if v < 0x10 { v |= 0x10 } }`, then `| (flags & 0xC0)`.
- Current PP is **not stored**. On withdraw it is restored to max (`RestoreTempMonPP`).
- Stats, HP and status are **not stored**. They are recalculated on withdraw (`CalcTempmonStats`). Status is cleared.
- Boxed mons cannot hold mail (`StorageItemIsMail`, `data/items/mail_items.asm`). The editor must block mail items in boxes.

**Snapshot semantics:** "Copy-on-write: a record referenced by either snapshot is never overwritten" is a **runtime** invariant. Offline, the editor writes both snapshots identically, so it may:

- rewrite existing records in place;
- allocate new records from entries referenced by neither snapshot (scan pool 1 entries 1..254, then pool 2, the same order as `NewStoragePointer`);
- leave orphaned records untouched. `FlushStorageSystem` frees them on the next load.

### 4.9 Text encoding

- Vanilla pokecrystal charmap (`charmap.asm` at repo root):
  - `@` = `$50` terminator;
  - space = `$7F`;
  - `A`–`Z` = `$80`–`$99`, `a`–`z` = `$A0`–`$B9`;
  - `0`–`9` = `$F6`–`$FF`;
  - `#` = `$54` ("POKé").
- The file also contains Japanese aliases for the same codes. Pick the **English** mapping (the last-defined or the `FIRST`/ASCII-range entry; verify in source) and keep a reverse map with exactly one canonical character per code.
- Naming-screen character set: `data/text/name_input_chars.asm` (`NameInputUpper` / `NameInputLower` / `BoxNameInputUpper`).
  - Upper: `A–Z - ? ! / . ,` and space.
  - Lower: `a–z × ( ) : ; [ ] <PK> <MN>`.
  - **No digits.** Offer digits and other printable charmap codes only in "debug" mode.
- Lengths (`constants/text_constants.asm`):

  | Name | Rule |
  |---|---|
  | Player / rival name | max 7 chars (`PLAYER_NAME_LENGTH` 8), stored in 11 bytes |
  | Nickname | max 10 chars (`MON_NAME_LENGTH` 11) |
  | Party OT | 11-byte field |
  | Box nickname and OT | 10 bytes with no terminator |
  | Box name | 8 chars in 9 bytes, `@`-padded, no terminator |

- Writing: string + `@` + `@`-padding to the field length. The terminator is omitted only for the no-terminator fields.

### 4.10 Bag

- Item IDs are 8-bit. `$01`–`$C1` are regular items. TM01–TM54 are `$C2`–`$F7` and HM01–HM07 are `$F8`–`$FE`; `TM01 EQU const_value` in `constants/item_constants.asm`. `$FF` is "TERU-SAMA".
- Pocket membership comes from `data/items/attributes.asm` (field 5 of `item_attribute`): `ITEM` 157, `KEY_ITEM` 25, `BALL` 13, `TM_HM` 61. There are 256 attribute rows: `$01`…`$FF` plus a trailing `$00`.
- TMs are **reusable** (`engine/items/tmhm.asm`: "ConsumeTM intentionally not called"), so the TM pocket UI is a checklist (qty 0/1). HMs are 1.
- Items and Balls quantities are 1–99, with no duplicate IDs (the game merges stacks).
- Key items are a count, then IDs, then `$FF`; max 25; no quantities.
- PC items: 50 slots.
- Move tutors MT01–MT03 (FLAMETHROWER/THUNDERBOLT/ICE_BEAM via `add_mt`) are compatibility bits only, not items.

### 4.11 Pokédex

- Bit `(speciesIndex − 1)` of `wPokedexCaught` / `wPokedexSeen`, LSB-first. `NUM_POKEMON = 495` today (62 bytes).
- Clones and regional variants have their own bits.

### 4.12 Species model

- Regional variants and clones are **separate species** with their own constants, base data, learnsets and sprites. Examples: `RATTATA_ALOLAN`, `MEOWTH_GALARIAN`, `CHARMANDER_CLONE`. There is **no form byte**; Polished's "forms" concept must be removed.
- Unown's letter is derived from DVs (vanilla `GetUnownLetter`). Display it, and offer "set DVs to letter X" as a helper.
- Mimikyu's busted form is a battle-only graphic, not a save field.

### 4.13 Field semantics the editor must replicate (all verified in source)

- **Ability** (`home/abilities.asm` `GetAbility`):
  - slot from Personality bits 6–5;
  - if the base-data ability in that slot is `NO_ABILITY`, the slot falls back to ability 1;
  - if `wGameplayRules` bit 2 is set, the effective ability is `NO_ABILITY` (`ZeroAbilityIfDisabled`).
  - Base data: `abilities_for SPECIES, A1, A2, HIDDEN` in `data/pokemon/base_stats/*.asm`.
- **Gender** (`engine/pokemon/mon_stats.asm`):
  - `GENDER_UNKNOWN` (`$FF`) → genderless;
  - `GENDER_F0` (0) → always male;
  - `GENDER_F100` (`$FE`) → always female;
  - otherwise the male flag decides.

  Gender is **not** derived from DVs. The game's own roll is 50/50 for every mixed-gender species (`RollMonGender`).
- **Shiny:** an explicit flag bit, not DVs. The party sprite palette reads `MON_SHINY_FLAG`.
- **Hidden Power:** the stored type; 0 → DARK. Base power is always 70. DVs play no part.
- **Caught ball:** Personality bits 4–0 index `CaughtBallItems` (`engine/pokemon/caught_data.asm`). There are 13 entries: POKE, GREAT, ULTRA, MASTER, HEAVY, LEVEL, LURE, FAST, FRIEND, MOON, LOVE, PARK, SAFARI. Default 0.
- **Caught data:** see the table in §4.7. Gift mons have byte 0 = 0 and location `$7E`.
- **Max PP** (`RestoreTempMonPP`): `base + min(7, floor(base/5)) * ppUps`, capped to 6 bits. This is **not** Polished's `base*(5+ups)/5`.
- **Stats** (`CalcMonStatC`):
  - `sq = clamp(ceil(sqrt(statExp)), 1, 255)` (`GetSquareRoot` table search, `NUM_SQUARE_ROOTS` 255);
  - `v = floor((((base + dv) * 2) + floor(sq / 4)) * level / 100)`;
  - HP: `v + level + 10`; other stats: `v + 5`; cap 999 (`MAX_STAT_VALUE`).
  - HP DV = `(atk&1)<<3 | (def&1)<<2 | (spd&1)<<1 | (spc&1)`. SpA and SpD both use the Special DV and Special stat exp.
- **Base stats and types depend on the save's gameplay rules** (`engine/pokemon/gameplay_rules.asm`):
  - Types: `OriginalPokemonTypes` override when bit 0 is set, otherwise the `RevampedPokemonTypes` override. Both are sparse `dw SPECIES / db T1, T2` lists falling back to the base-data types. The **revamped list applies even in normal mode.**
  - Stats: if bit 1 is set, `OriginalPokemonStats` (`data/pokemon/original_stats.asm`, sparse) overrides base stats.
- **Exp ↔ level** (`CalcExpAtLevel`):
  - level 1 → 0;
  - otherwise `floor(a*n³/b) + sign(c)*|c|*n² + d*n − e`, with integer math only;
  - growth-rate table in `data/growth_rates.asm`, index from base data.
- **Eggs:**
  - Party: `wPartySpecies[i] = $FD`, and the struct holds the real species with normally computed stats.
  - Box: flags bit 0.
  - Happiness holds hatch cycles (base data "step cycles to hatch").
- **Hard Mode:** `wStatusFlags2` bit 3; the level cap comes from `HardModeLevelCaps` by badge count (`engine/pokemon/experience.asm`). The editor should warn when a party level exceeds the cap.

### 4.14 Editor write algorithm (normative)

```
1. Start from a copy of the original bytes (never from a zeroed buffer).
2. Encode the semantic model into the *effective* game-data block (player/curmap/pokemon),
   using/allocating 8-bit IDs in the effective Pokémon/move tables.
3. Copy the resulting game-data block, Pokémon table, move table and options into BOTH copies
   (main bank 1 and backup bank 0).
4. Encode boxes: write PokeDB records (in place for existing, new free entries for new mons),
   then write the box metadata into BOTH sNewBox* and sBackupNewBox* identically.
5. Write sCrystalData[0] (player character) if changed.
6. sSaveVersion := unchanged (must already equal the profile's SAVE_FORMAT_VERSION);
   sCheckValue1/2 and sBackupCheckValue1/2 := 99/127; sWritingBackup := 0.
7. Recompute: conversion checksum (main, backup) -> sChecksum, sBackupChecksum.
8. Re-parse the output and run the full validator (§10.1). Refuse download on any ERROR.
9. Append the original RTC trailer unchanged.
```

---

## 5. Polished Crystal vs Crimson Crystal — side by side

| Aspect | Polished (as editor assumes) | Crimson (verified) |
|---|---|---|
| Base | Polished Crystal | pokecrystal + pokecrystal16 + Polished-style PC |
| SRAM size | 32 KiB (4 banks) | **64 KiB (8 banks)** + optional RTC trailer |
| Version check | `sSaveVersion` BE16 (= 10) | `sSaveVersion` byte (= 2) **plus check values; layout can change without a bump** |
| Save copies | editor writes backup only | main (bank 1) + backup (bank 0), both validated, plus `sWritingBackup` phase flag |
| Checksums | backup game data sum | 2 game-data sums + 2 move-table sums + per-record sums |
| Species ID | 9 bits in struct | party: 8-bit runtime ID via **conversion table**; box: 16-bit LE |
| Move ID | 8 bits | party: 8-bit runtime ID via table; box: 14 bits split |
| Party struct | 48 bytes | **50 bytes** |
| Box record | 49 bytes, MSB-scattered checksum, 7-bit names | **57 bytes**, explicit LE16 checksum, 8-bit names |
| Boxes | 20 | **25** |
| PokeDB pools | A/B/C = 167/28/12 | **A/B = 143/111**, C = 0 |
| EVs | 6 × 1 byte | **Stat Exp 5 × BE16** |
| DVs | 3 bytes (6 DVs) | **2 bytes (4 DVs, HP derived)** |
| Personality | 2 bytes: shiny, ability, nature, gender, egg, form | 1 byte: ability slot + caught ball; shiny/male flags elsewhere |
| Nature | yes | **no** |
| Hyper training | yes | **no** |
| Forms | 5-bit form field | **none** (separate species; Unown via DVs) |
| Hidden Power | from DVs | **stored type byte** |
| Gender | stored bit (female=1) | stored **male** flag + species ratio rules |
| Caught ball | 5-bit item index in caught-time byte | 5-bit `CAUGHTBALL_*` enum in Personality |
| Caught data | 3 bytes | 2 bytes (time 2 bits + level 6 bits, OT gender + 7-bit landmark) |
| Max PP | base*(5+ups)/5 | base + min(7, base/5)*ups |
| Egg flag | bit in struct | party: `$FD` in species list; box: flags bit 0 |
| Pockets | items/medicine/balls/berries/TM bitfield/key items/apricorns/wings/candy/blue card | **items(40)/key items(25)/balls(12)/TM quantities(61)/PC items(50)**, coins, Blue Card, Mom's money |
| Player gender | 3 values in player data | **4 characters, in un-checksummed `sCrystalData`** |
| Text terminator | `$53` (`@` in Polished's charmap) | **`$50`** |
| Display names | unique | **duplicated** (regional/clone species) |
| Per-save rules | — | **wGameplayRules** changes types, stats and abilities |

---

## 6. Incompatibilities that would corrupt saves or show wrong data

Severity: **C** = corrupts or loses data; **W** = wrong data shown or written; **U** = the editor unusable.

| # | Issue | Effect if Polished code is reused | Sev |
|---|---|---|---|
| 1 | 64 KiB size check | every Crimson save rejected | U |
| 2 | Layout drift without version bump | old saves parsed with new offsets: garbage fields, and writes into the wrong bytes | C |
| 3 | Backup-only write + forced main checksum | relies on the fallback path; ~1/65,536 silent loss of edits; main/backup move-table checksums not handled | C |
| 4 | Conversion-table checksum not recomputed | both copies fail verification: "save file is corrupted" | C |
| 5 | Party species/moves written as raw indexes | wrong species/moves, or IDs above table size → index 0 | C |
| 6 | New species/move without table allocation (`UsedSlots`) | wrong species; the game GC may later evict live IDs | C |
| 7 | 48- vs 50-byte party stride | every party mon after the first misaligned | C |
| 8 | 49-byte record + MSB checksum | every edited box mon becomes a Bad Egg | C |
| 9 | Pool thresholds 167/195 and 20 boxes | records written into the wrong banks, over other mons | C |
| 10 | Entry wrap at 201 / fixed pool per box | collisions, references beyond pool A/B layout | C |
| 11 | Only one box snapshot written | if `sWritingBackup = 1` the active snapshot overwrites the edit; otherwise the backup overwrites the active one; the two disagree | C |
| 12 | Name-based lookups | regional and clone species silently converted to base species | C |
| 13 | Charmap `$53`/`$7F`/`$FA`/`$FB`/`$FC` assumptions | names truncated or garbled | W/C |
| 14 | `readString` mutating the buffer | sets MSBs on the read buffer (download path re-reads, but any reuse corrupts) | C |
| 15 | EV/DV/personality/nature/form bitfields | writes nonsense into stat exp, DVs, PP and happiness bytes | C |
| 16 | Shiny/gender from Polished bits | shiny/gender lost; box Pokérus bits 6–7 clobbered | C |
| 17 | Caught ball as item index | wrong ball, or out-of-range enum | W |
| 18 | Caught level up to 100 | spills into the time-of-day bits (the game caps at 63) | W |
| 19 | Bag pocket layout (TM bitfield, key items zero-terminated) | bag overwritten across pocket boundaries | C |
| 20 | Player gender written to player data | wrong byte changed; gender lives in `sCrystalData` | C |
| 21 | Landmarks parsed from `landmark` lines only | index shift by one (the first row is `dbbw … SpecialMapName`) | W |
| 22 | Max PP formula | PP above the in-game max | W |
| 23 | Stats never recomputed; gameplay rules ignored | wrong stats/HP in party; illegal HP > max | W |
| 24 | Hidden Power from DVs | displays the wrong type | W |
| 25 | Mail items allowed in boxes / no mail struct for party | invalid state, the PC refuses to move the mon, or garbage mail | W |
| 26 | Unknown IDs → `find()!` throws | the editor crashes on custom or invalid data | U |
| 27 | Egg represented by a struct bit | party eggs not recognised; `wPartySpecies` not updated | C |
| 28 | Pokédex by `form.dexNo` | wrong bits | W |
| 29 | Ability slot mapping `(x+2)%3` | wrong ability slot written | W |
| 30 | Remote sprite URLs to upstream | Crimson species show broken or wrong images | W |

---

## 7. Reuse matrix

| Area | Files | Verdict | Notes |
|---|---|---|---|
| App shell, routing, Tailwind/Flowbite theme, dark mode, toast, upload/download UX | `routes/*`, `main.svelte`, `layout.css`, `app.html` | **Reuse, modify** | Remove the PF toggle and replace it with the auto-detected build profile and gameplay-rules badges. Add Diagnostics, Flags and Daycare tabs. Change the download name to `<name>.sav`, preserving the trailer |
| UI primitives | `lib/components/ui/{combobox,dropdown-select,number-input,radio-select,carousel,cycler,full-cycler,healthbar}.svelte` | **Reuse as-is** | |
| `colored-card`, `type-icon` | | **Modify** | Add `BIRD` and `CURSE_T`; vendor the icons locally; generate the type list from data |
| `text-input` (keyboard) | | **Modify** | Keyboard from generated `keyboard.json`; support `<PK>` / `<MN>` tokens; per-field max length and debug charset |
| `item-icon`, `mon-sprite` | | **Modify** | Local assets. Crimson has **no item icons**, so use a pocket glyph |
| `heal.svelte` | | **Modify** | Fix `Math.max` → `Math.min`; use Crimson's max-PP formula |
| Party/Boxes grids, mon-card, mon-drawer | `party/`, `boxes/`, `mon/mon-card`, `mon-drawer` | **Reuse, modify** | 25 boxes, theme names from data, per-slot status (Bad Egg, invalid) |
| `mon/basics` | | **Rewrite partly** | Species combobox keyed by constant; no forms (Unown letter display); ability radio showing slot semantics and "disabled by rules"; held-item filter (no key items, no mail in boxes); level updates exp; recompute stats |
| `mon/stats` | | **Rewrite** | 4 DVs + derived HP DV, Stat Exp 0–65535, Hidden Power type selector, computed stats table (enhanced/original rules), no natures, no hyper training |
| `mon/moves`, `move-card` | | **Modify** | Data by constant; PP formula; learnset groups (level/egg/TM-HM/tutor/all); fix the group-name bug |
| `mon/caught` | | **Modify** | Ball from the CaughtBall enum; time {none, morning, day, night}; level 0–63; location incl. GIFT/EVENT; OT gender |
| `mon/misc` | | **Modify** | Shiny flag, gender per ratio rules, egg (hatch cycles), Pokérus with box folding |
| Bag | `bag/*` | **Rewrite** | Pockets: Items (40), Key Items (25), Balls (12), TM/HM checklist (61), PC items (50); extras: coins, Blue Card, Mom's money |
| Player | `player/player.svelte` | **Modify** | 4 characters (local sprites), names (player, rival, mom), ID, money, coins, badges, play time, hard mode, gameplay rules (debug, with warning) |
| Pokédex | `pokedex/pokedex.svelte` | **Modify** | By species index; filters (seen/caught/regional/clone); bulk set |
| Parsers | `src/parsers/**` | **Replace** | New `src/lib/save/**` core (pure TS, unit-tested) per §4 |
| `parsers/utils.ts` `retrieve`/`insert` | | **Reuse** | Add LE helpers |
| Extractor infra | `extractors/utils.ts` (`splitRead`, `writeJSON`, `applyPalette`, `createGIF`), `common.ts` | **Reuse, modify** | Drop the FAITHFUL split; keep comment/MACRO stripping. **Add line-number provenance and strict mode** (unknown line → error). `createGIF` works with Crimson's vertical frame strips, but verify `anim.asm` frame semantics |
| `abilities.ts` | | **Reuse ~as-is** | Same const/names/descriptions shape (verify) |
| `moves.ts` | | **Modify** | `move EFFECT, power, type, CATEGORY, acc, pp, chance`; tolerate `indirect_table` headers; 421 moves |
| `items.ts` | | **Modify** | Pockets from attributes field 5; no icons/palettes |
| `growthRates.ts` | | **Modify** | No `NUM_HATCH_RATES` marker; parse `GROWTH_*` consts |
| `charmap.ts` | | **Rewrite** | Root `charmap.asm`, no `FIRST_REGULAR_TEXT_CHAR`; resolve duplicates |
| `locations.ts` | | **Modify** | Handle the `dbbw` first row; add GIFT/EVENT specials |
| `boxThemes.ts` | | **Modify** | `dw .Label` + `.Label: db "…"` |
| `pokemon.ts` | | **Rewrite** | New base-stats parser (keyword-based), `dbbw`/`dbbbw` evolutions, `dbw` learnsets, `dw` egg moves with per-file pointer lists, TM/HM/MT from `tmhm`, gameplay-rule overrides, sprite dirs from `pic_pointers` + `gfx/pics.asm` |
| `tmhms.ts` | | **Modify** | `dw MOVE` list; 54 TM / 7 HM / 3 MT via `add_tm/add_hm/add_mt` |
| `addresses.ts`, `versions.ts` | | **Rewrite** | Layout profile generator (§9.2) |
| `keyItems.ts`, `apricorns.ts`, `wings.ts`, `expCandy.ts`, `natures.ts`, `keyboard.ts` | | **Delete / replace** | Key items are pocket-derived; keyboard is generated |

---

## 8. Game-data extraction design

### 8.1 Principles

- **Source of truth:** the Crimson asm, pinned to a commit SHA.
- **Oracle:** the ROM built from that SHA. The extractor cross-checks numeric data against ROM bytes read through the `.sym` (§8.4). Any mismatch fails CI.
- **Strict parsing:** every line of the tables it consumes must match a known pattern. Otherwise it throws `ExtractError(file, line, text, expectedPattern)`. This is the opposite of `crimson-crystal-docs/generate_docs.py`, which is tolerant by design and omits clones. Do not reuse that generator as a data source; it is lossy. It may later consume the editor's JSON instead.
- Output is keyed by **constant name**, and every record carries its numeric `index`.

### 8.2 Inputs → outputs

| Output (`src/lib/gamedata/builds/<buildId>/…`) | Crimson inputs |
|---|---|
| `constants.json` (NUM_*, table sizes, lengths, MONDB_ENTRIES_*, NUM_BOXES, SAVE_FORMAT_VERSION, SAVE_CHECK_VALUE_*, 16-bit table params, gameplay-rule bits, GIFT/EVENT_LOCATION, HIDDEN_POWER_DEFAULT_TYPE, MAX_* limits, PLAYERGENDER_*) | `constants/*.asm` (pokemon_data, pc, misc, text, item_data, 16_bit_translation, type, battle, wram, landmark) |
| `species.json` [{const, index, name, baseStats{enhanced, original}, types{enhanced, original}, catchRate, baseExp, items[2], genderRatio, eggCycles, growthRate, eggGroups, abilities[3] (const), learnset.level[{level, move}], learnset.egg[move], learnset.tmhm[move], tutor{utility bits}, evolutions[{method, args, target}], spriteDir, palettes{normal[2], shiny[2]}}] | `constants/pokemon_constants.asm`, `data/pokemon/names.asm`, `base_stats.asm` + `base_stats/*.asm`, `original_stats.asm`, `engine/pokemon/gameplay_rules.asm` (Original/Revamped type lists), `evos_attacks{,_kanto,_johto,_clones}.asm`, `egg_moves{,_kanto,_johto}.asm`, `utility_tutor.asm`, `pic_pointers.asm`, `gfx/pics.asm`, `palettes.asm`, `gfx/pokemon/*/shiny.pal` |
| `moves.json` [{const, index, name, description, effect, power, type, category, accuracy, pp, effectChance}] | `constants/move_constants.asm` (to `NUM_ATTACKS`), `data/moves/{names,descriptions,moves}.asm` |
| `abilities.json` | `constants/ability_constants.asm`, `data/abilities/{names,descriptions}.asm` |
| `items.json` [{const, index, name, description, pocket, price, heldEffect, isMail, tmhm?: {kind, number, move}}] | `constants/item_constants.asm`, `data/items/{names,descriptions,attributes,mail_items}.asm`, `data/moves/tmhm_moves.asm` |
| `caughtBalls.json` | `CAUGHTBALL_*` consts + `CaughtBallItems` |
| `types.json` | `constants/type_constants.asm`, `data/types/names.asm` |
| `landmarks.json` | `constants/landmark_constants.asm`, `data/maps/landmarks.asm` (+ GIFT/EVENT) |
| `boxThemes.json`, `defaultBoxThemes` | `constants/pc_constants.asm`, `data/pc/theme_names.asm`, `data/pc/default_box_themes.asm` |
| `growthRates.json` | `data/growth_rates.asm` |
| `charmap.json`, `keyboard.json` | `charmap.asm`, `data/text/name_input_chars.asm` |
| `flags.json` (event flags by name; engine flags → (addr, mask)) | `constants/event_flags.asm`, `constants/engine_flags.asm`, `data/engine_flags.asm` (or the ROM table `EngineFlags`) |
| `levelCaps.json` | `HardModeLevelCaps` / rematch caps in `engine/pokemon/experience.asm` |
| `playerCharacters.json` | `engine/menus/init_gender.asm` (`CharSelectOrder`), trainer pics |
| `layout.json` (§9.2) | `pokecrystal.sym` + constants |
| `manifest.json` entry | git SHA, commit date, buildId, layoutHash, saveFormatVersion, ROM SHA-1, extractor version |

**Sprites:** for each species, read `gfx/pokemon/<dir>/front.png`, a vertical strip of square frames whose width equals the frame size.

- `normal.png` = first frame with the PNG's own colours. If the image is grayscale (for example `unown_*`), apply the palette pair from `palettes.asm`.
- `shiny.png` = the same frame with the two middle colours replaced by `shiny.pal`.
- Optional animated GIFs via the existing `createGIF` (`anim.asm` `frame N, dur` / `setrepeat` / `dorepeat`). Verify that frame N is the Nth square of the strip.
- Output to `static/sprites/<CONST>/{normal,shiny}.{png,gif}`. Sprites are shared across builds by content hash.

### 8.3 Parser notes per file (things that break naïve parsing)

- `pokemon_constants.asm`: species block from `const_def 1` to `NUM_POKEMON`. Later blocks (Unown letters) must not leak in. `EGG EQU -3`.
- `base_stats/*.asm`: parse by **keyword**, not line number. Patterns:
  - `db 0 ; species ID placeholder`
  - the 6-stat `db`
  - `db T1, T2 ; type`
  - catch rate, base exp, items, gender, `unknown 1`, step cycles, `unknown 2`
  - `INCBIN …front.dimensions`
  - `abilities_for MON, A1, A2, HA`
  - padding, growth, `dn` egg groups
  - `tmhm …`
- `base_stats.asm`: `INCLUDE` order gives index order across `BaseData1` / `BaseData2`. Assert count == NUM_POKEMON.
- `evos_attacks.asm`: pointer table split across files with `indirect_entries` ranges. Resolve `<Name>EvosAttacks:` labels.
  - Evolutions: `dbbw EVOLVE_X, arg, SPECIES` / `dbbbw EVOLVE_STAT|EVOLVE_HOLDING, lvl, x, SPECIES` until `db 0`.
  - Learnset: `dbw level, MOVE` until `db 0`.
- `egg_moves*.asm`: `dw <Label> ; SPECIES` pointer lists; bodies are `dw MOVE … dw -1`.
- `moves.asm`: `move` lines in order inside `Moves1:` (the header is `indirect_table`). Strip trailing `;NAME` comments.
- `names.asm` files: entries are `db "TEXT@"` (fixed-width for species, `@`-terminated otherwise). Convert `#` → `POKé` for display, but keep the raw string too.
- `landmarks.asm`: the first row is `dbbw 0, 0, SpecialMapName`. Name labels map to strings containing `¯` (soft line break) and `%`.
- `attributes.asm`: one `item_attribute` per item from `$01`, in order, through `$FF`, then `$00`.

### 8.4 ROM oracle (cross-check)

- Implement `loadIndirectPointer(rom, symBank, symAddr, index)`:
  - header `u16 = size | initial<<15`;
  - entries `{u8 count, u8 bank, u16 ptr}` until `count == 0`;
  - `i = index - initial`; walk entries, subtracting count; the target is `ptr + i*size` in `bank`.
  - ROM offset = `bank*0x4000 + (addr - 0x4000)` (bank 0: `addr`).
- Checks:
  - every species' 6 base stats, two base types, catch rate, gender, growth rate and 3 abilities (`BaseData`, entry size 0x20; field offsets from `BASE_*` and `wBase*` symbols);
  - every move's effect/power/type/category/acc/pp/chance (`Moves`, entry size 7);
  - every item's pocket (`ItemAttributes`, 7-byte rows);
  - `TMHMMoves`, `CaughtBallItems`;
  - Revamped/Original type lists and `OriginalPokemonStats`.
- Any mismatch fails CI with the species/move constant and both values.

---

## 9. Automatic update system

### 9.1 Topology

```
Pokemon-Crimson-Crystal (push to main)
   └─ .github/workflows/notify-editor.yml  ── repository_dispatch(type=crimson-updated, sha) ─┐
                                                                                             ▼
crimson-editor (editor repo)  .github/workflows/sync-game-data.yml
   ├─ checkout editor
   ├─ checkout Crimson @ sha into vendor/crimson   (shallow, LFS not needed)
   ├─ build RGBDS v0.5.2 from source (cache by version)
   ├─ make -C vendor/crimson pokecrystal.gbc  (and `debug`)  → .gbc + .sym
   ├─ npm run extract -- --crimson vendor/crimson --rom vendor/crimson/pokecrystal.gbc
   │     → src/lib/gamedata/builds/<sha7>/*.json, static/sprites/**, manifest.json
   ├─ npm run validate-data   (schema + ROM oracle + layout checks)
   ├─ npm test                (unit + golden + fixture round-trips)
   ├─ python tools/roundtrip/pyboy_check.py  (optional gate: game accepts edited fixtures)
   ├─ generate CHANGES.md (data diff vs previous build + layout diff)
   └─ open PR (or auto-merge if all gates pass and only data changed) → deploy
```

- **Fallback trigger:** a scheduled workflow (daily) that compares Crimson `main` HEAD with the newest `manifest.json` entry. This needs no secret in the ROM repo.
- **Manual trigger:** `workflow_dispatch` with an optional `sha` input.
- `repository_dispatch` needs a fine-grained PAT with `contents:write` on the editor repo, stored as a secret in the Crimson repo (for example `EDITOR_DISPATCH_TOKEN`).
- **Hosting:** switch to `@sveltejs/adapter-static` and deploy to GitHub Pages, consistent with Crimson's existing `docs/` Pages site. Alternatively keep Vercel and drop `@vercel/analytics` unless Lucas wants it.

### 9.2 Layout profile (`layout.json`)

Generated from the `.sym` plus constants:

```jsonc
{
  "layoutHash": "sha256 of canonical JSON below (excluding layoutHash itself)",
  "saveFormatVersion": 2,
  "checkValues": [99, 127],
  "sramSize": 65536,
  "regions": {
    "main":   {"options": "01:A000", "checkValue1": "01:A008", "saveData": ["01:A009","01:AC36"], "player": "01:A009", "curMap": "01:A7AA", "pokemon": "01:A7DC", "monTable": "01:AB34", "convChecksum": "01:AC34", "checksum": "01:ACBE", "checkValue2": "01:ACC0", "moveTable": "00:AE00"},
    "backup": { ...same keys... },
    "crystalData": "01:B97C", "saveVersion": "01:B99C", "writingBackup": "01:B99D",
    "newBoxActive": "02:A000", "newBoxBackup": "02:A339", "newBoxSize": 33,
    "pokeDB": {"1A": "03:A000", "1B": "04:A000", "2A": "05:A000", "2B": "06:A000"},
    "partyMail": "00:A600"
  },
  "wram": { "wPlayerData": "01:D4C8", "wCurMapData": "01:DC69", "wPokemonData": "01:DC9B", "...every field used by the editor...": "" },
  "structs": { "partymon": {"size": 50, "fields": {"Species":0, "...":0}}, "savemon": {"size": 57, "...": 0}, "newbox": {"...": 0} },
  "tables": { "mon": {"entries":100,"locked":30,"cache":16,"recent":8,"reservedMin":253,"size":256},
              "move":{"entries":230,"locked":18,"cache":16,"recent":16,"reservedMin":255,"size":512} },
  "counts": { "NUM_BOXES":25, "MONS_PER_BOX":20, "MONDB_ENTRIES_A":143, "MONDB_ENTRIES_B":111, "MONDB_ENTRIES_C":0,
              "NUM_POKEMON":495, "NUM_TMS":54, "NUM_HMS":7, "MAX_ITEMS":40, "MAX_KEY_ITEMS":25, "MAX_BALLS":12, "MAX_PC_ITEMS":50, "NUM_EVENTS":0 }
}
```

- Struct field offsets are derived from `wPartyMon1*` symbols and `SAVEMON_*` constants, not typed by hand.
- **The extractor must assert** everything `tools/audit_save.py` asserts:
  - mirrored main/backup span sizes;
  - `CheckValue2` directly follows its checksum;
  - newbox size divisible by 33;
  - the backup snapshot directly follows the active one;
  - 57-byte PokeDB sections that never cross banks;
  - table sizes 0x100 and 0x200.

### 9.3 Detecting which build produced a save

```
candidates = manifest builds, newest first (dedupe by layoutHash)
for profile in candidates:
    score = 0
    if size/trailer ok
    if sram[saveVersion] == profile.saveFormatVersion: score += 1
    if main check values ok: score += 1;  if main checksums (both) valid: score += 4
    if backup check values ok: score += 1; if backup checksums (both) valid: score += 4
    if party count ≤ 6 and party species IDs resolve through the table: score += 1
pick the highest score with at least one valid copy; tie → newest
```

Show the chosen build (SHA, date) in the header. Allow a manual override from a dropdown. If no profile has a valid copy, open the **Diagnostics** view read-only.

Keep **all distinct layout profiles forever**; they are small. Keep full game-data bundles for at least the last 10 distinct layouts, lazy-loaded with `fetch`.

### 9.4 Recommended changes in the Crimson repo (small, optional but valuable)

1. **Save-layout lock:** add `tools/save_layout_lock.py`, which writes `save_layout.lock` (the layoutHash and a readable symbol list), and a CI check. If the hash changes while `SAVE_FORMAT_VERSION` is unchanged, the check **fails**. Extend `tools/audit_save.py` rather than duplicating it. This turns finding #5 into a guarantee.
2. Add `.github/workflows/build.yml`: build the ROM with RGBDS v0.5.2 from source, run `tools/audit_save.py`, and upload `pokecrystal.gbc`, `.sym` and `.map` as artifacts. Optionally also send the dispatch from §9.1.
3. `.gitattributes`: add `*.sav binary`, `*.srm binary`, `*.ram binary`, `*.rtc binary`, `*.bak binary` and `*.state binary`. Re-commit any fixture saves.
4. Replace the corrupt `rgbds/` binaries, or remove them and document the source build.
5. Restore or write `docs/pc_storage_design.md` (§4.8 can serve as the basis).

---

## 10. Debugging and testing features

### 10.1 Validator / Diagnostics panel (highest value for ROM development)

These run on upload and before download. Each finding is ERROR, WARN or INFO, with byte offset and symbol.

- **Container:** size, trailer, all-zero banks, a 32 KiB truncation.
- **Copies:**
  - version and check values;
  - four checksums, showing stored vs computed;
  - `sWritingBackup`;
  - main vs backup diff (count of differing bytes per symbol);
  - active vs backup box-snapshot diff;
  - which copy the game will load (§4.3).
- **Conversion tables:**
  - `UsedSlots` vs the non-zero count;
  - duplicate indexes;
  - indexes above `NUM_POKEMON` / `NUM_ATTACKS`;
  - IDs referenced by saved structs that have no entry;
  - free slots remaining.
- **Party:**
  - count vs the species list and terminator;
  - EGG markers;
  - HP > max;
  - stored stats ≠ recomputed (under the save's gameplay rules);
  - exp outside the level band;
  - PP above max;
  - status on fainted mons;
  - empty ability slot;
  - mail without a mail struct;
  - level above the Hard Mode cap.
- **Boxes:**
  - entries > 254;
  - the same pointer used twice;
  - pointers to records with bad checksums (they will show as Bad Egg);
  - species index 0 or above NUM_POKEMON;
  - move index above NUM_ATTACKS;
  - mail held in a box.
- **Bag:**
  - count vs terminator;
  - items in the wrong pocket;
  - duplicate stacks;
  - qty 0 or > 99;
  - TM quantity above 1.
- **Dex:** owned species not marked caught (INFO).
- **Legality hints (INFO, never blocking):** move not in any learnset; ability slot not available; impossible caught data.

### 10.2 Developer tools

- **Hex/structure inspector:** a symbol-annotated hex view of any region (`wPartyMon1Personality` and so on), with a field decoder and a "diff vs uploaded" view. Export a diff report (JSON or Markdown) to paste into bug reports.
- **Event/engine flag editor:** search by name (from `event_flags.asm` and `engine_flags.asm`); toggle; badges; Hard Mode; gameplay rules (with a warning that it changes types and stats game-wide).
- **Warp (advanced):** set `wMapGroup` / `wMapNumber` / `wXCoord` / `wYCoord` from map constants. Behind an "I know what I'm doing" toggle.
- **Day-care and egg editor** (Phase 5+).
- **Presets:** all TMs/HMs, max money/coins, complete/clear dex, heal party, max happiness, test party templates (for example "one of every new species").
- **Export a party mon as a `tools/battletest` YAML snippet:** `{ species, level, ability, item, moves }` constants, ready to paste into `tools/battletest/tests/*.yaml`.
- **Import/export mons** as JSON (lossless, includes raw bytes) and as human-readable text.
- **Migrate save between builds** (Phase 7): parse with the old layout profile into the semantic model, then write with a new profile using a template save from the new build. Report fields that could not be mapped. This solves the "my old test save broke after a layout change" problem directly.
- **Data changelog page:** the per-build diff (new or changed species, moves, items, layout shifts), generated by CI.

### 10.3 Test assets

- `tests/fixtures/real/`: Lucas's real saves (binary-safe), each with `meta.json` (build SHA, emulator).
- `tests/fixtures/synthetic/`: generated by `tools/fixtures/make_fixture.py` (PyBoy, Crimson ROM). It boots the ROM, stages party and boxes through ROM routines (`AddStorageMon`, `EncodeSavedMon`, party copy helpers as in `tools/pc_harness.py`), calls `SaveGameData` (or uses the native menu, as `tools/battletest/save_menu_checks.py` does), and dumps all 8 SRAM banks. It covers:
  - eggs; shiny; all ability slots; HP-type variants; a mon in every box;
  - pool 1 section B and pool 2;
  - full bag;
  - `sWritingBackup = 1`; main-corrupt (backup-only) cases.

---

## 11. Phased implementation plan

> Conventions: TypeScript strict; Vitest for unit tests; pure modules under `src/lib/save/**` and `src/lib/gamedata/**` must not import Svelte. Each task lists files to create or change. A phase is complete only when its acceptance criteria pass in CI.

### Phase 0 — Project setup (no game logic)

1. **Licensing gate:** confirm permission from the Polished Editor author, or record the decision to reimplement. Add a LICENSE once settled. Preserve the credits.
2. Create the editor repo `crimson-editor` from polishededitor (or fresh SvelteKit with the same stack).
   - Remove `polishedcrystal/`, `polishedcrystal.sym`, `src/gfx/**` and `src/data/*.json`.
   - Rename the title and branding to "Crimson Editor"; rewrite `README.md`.
3. Add `vendor/crimson` as a **git submodule** pinned to a SHA, or check it out in CI only and keep it git-ignored locally. Pick one and document it.
4. `tools/toolchain/install-rgbds.sh`: clone `gbdev/rgbds` at tag `v0.5.2`, `make`, install to `.toolchain/rgbds` (cached in CI).
5. `tools/build-crimson.sh`: `make -C vendor/crimson RGBDS=<path>/ pokecrystal.gbc debug` (drop `local.mk` overrides with `RGBDS=` on the command line).
6. Switch to `@sveltejs/adapter-static` (`fallback: 'index.html'`). Remove `@vercel/analytics` unless requested.
7. Add Vitest, `npm run test`, and `npm run check` in CI (`.github/workflows/ci.yml`).

**Acceptance:** CI builds RGBDS and the Crimson ROM from a clean runner. `pokecrystal.sym` exists. The empty app builds and deploys a placeholder page.

### Phase 1 — Layout profile extractor

1. `src/extractors/sym.ts`: parse `BB:AAAA Name` lines into a map. Add `fileOffset(sym)` and `wramToSram(copy, wSym)`.
2. `src/extractors/asm/constants.ts`: a generic constant evaluator for `const_def [n]`, `const X`, `const_skip`, `X EQU expr`, `X EQUS "…"`, `enum_start` / `enum`, `const_value = …`, and simple arithmetic (`+ - * / << >> & | ( )`, hex `$`, binary `%`). It records file:line for each constant.
3. `src/extractors/layout.ts`: build `layout.json` (§9.2). Run every assertion from `tools/audit_save.py` plus contiguity of the saved WRAM blocks. Compute the `layoutHash`.
4. Write `manifest.json` entries.

**Acceptance:**
- Running on Crimson HEAD reproduces the values in §4.2 and §4.5.
- Running on commit `5dc51b77` produces a **different layoutHash** with `saveFormatVersion` 2 (a regression test of finding #5).
- Unit tests cover the constant evaluator.

### Phase 2 — Save core library (read-only first)

Create `src/lib/save/`:

- `container.ts`: size checks, trailer split and join.
- `bytes.ts`: be/le u8/u16/u24 get/set; `Checksum16`.
- `text.ts`: encode/decode with charmap and keyboard; `<PK>` / `<MN>` tokens; fixed-field writer (terminator and padding rules from §4.9).
- `tables.ts`: conversion table read, lookup and allocate (§4.6). Never frees.
- `copies.ts`: the §4.3 decision table, checksum verification, the effective-view selector and a main/backup diff.
- `party.ts`: decode/encode the 50-byte struct, species list, OT and nicknames; resolve IDs through the tables.
- `boxes.ts`: newbox decode/encode; PokeDB addressing; savemon decode/encode; record checksum; pool allocation.
- `bag.ts`, `player.ts`, `pokedex.ts`, `flags.ts`, `daycare.ts` (read-only at first).
- `model.ts`: the semantic model. Every entity keeps its `raw: Uint8Array` slice for lossless round-trip, plus `diagnostics[]`.
- `mechanics.ts`: stats, HP DV, exp↔level, max PP, ability resolution, gender rules, Hidden Power resolution, Unown letter, Pokérus fold. Gameplay rules are inputs.
- `validate.ts`: the §10.1 checks.

**Acceptance:**
- Parses `tests/fixtures/real/*.bak` that match their build profiles (keep the two 2026-09-09 saves with the `5dc51b77` profile) with zero ERRORs.
- Golden JSON snapshots.
- `mechanics.ts` unit tests cover the stats formula (including `sqrt` clamping and stat exp 0/65535), exp tables for all six growth rates (level 1 = 0), and max PP for base 5/10/35/40 with 0–3 ups.

### Phase 3 — Game-data extractors

Implement §8.2 and §8.3 with strict mode and provenance. Implement the §8.4 ROM oracle as `npm run validate-data`. Generate sprites.

**Acceptance:**
- 495 species, 421 moves, 172 abilities (including `NO_ABILITY`), 255 items plus `$00` handling, 61 TM/HM item IDs `$C2`–`$FE`, 25 key items, 13 balls (the counts must match the asm-evaluated constants, not these literals).
- The oracle reports zero mismatches.
- Sprites exist for every species.
- `MEOWTH`, `MEOWTH_ALOLAN` and `MEOWTH_GALARIAN` are distinct records.

### Phase 4 — Writer

1. `src/lib/save/write.ts`: the §4.14 algorithm, using model diffs to touch only changed entities. Unchanged entities re-emit their `raw` bytes.
2. Box record allocation and in-place rewrite. Snapshot mirroring.
3. Table allocation for new species and moves, mirrored to both copies.
4. All checksums. `sWritingBackup = 0`. Trailer preserved.
5. Post-write re-parse and validate. Refuse output on ERROR.

**Acceptance:**
- No-op round-trip is **byte-identical** for every clean fixture.
- Property tests (randomized edits: species, moves including index > 255, level, DVs, stat exp, shiny/gender, HP type, ball, nickname, box moves across pools, bag changes) all re-parse to the intended model with zero ERRORs.
- An edited fixture loads in PyBoy (Phase 7 harness, can be run locally) with the expected `wPartyCount`, party species indexes and box contents decoded by `GetStorageBoxMon` without Bad Eggs.

### Phase 5 — UI adaptation

Rewire components per §7. Specific requirements:

- Header: detected build (SHA/date) with an override; gameplay-rule badges; Hard Mode badge; a "copy loaded by game" indicator.
- Species picker shows `NAME (CONST_SUFFIX)`, for example "MEOWTH (Galarian)", with search by name or constant.
- Party mon changes recompute stats and max HP automatically. Current HP is preserved proportionally. There is an explicit "keep stored stats" debug toggle.
- Box mons show computed stats as read-only (the game recalculates on withdraw).
- Held item list excludes key items and TM/HM. In boxes it also excludes mail. In party, mail is allowed only if Phase 6 mail support exists; until then it is excluded.
- Add mon: default to a template built from data (first species, its level-1 learnset, ability slot 1, OT = player, caught at the current landmark or `GIFT_LOCATION`, Poké Ball), not a hardcoded Bulbasaur.
- Box UI: 25 boxes, theme names from data, Bad Egg slots shown with a "view raw / delete" action.
- Bag UI: per §7.
- Download is disabled while the validator has ERRORs. Warnings are shown in a modal before download.

**Acceptance:** manual test script (`docs/manual-test.md`) completed; Playwright smoke test (upload fixture → edit a nickname, level and a box mon → download → re-upload shows the edits).

### Phase 6 — Debug tools

Diagnostics panel (§10.1), hex inspector, flags editor, presets, battletest YAML export, JSON import/export, party mail (create a blank `mailmsg` struct when mail is equipped; verify `mailmsg` in `macros/`), day-care editor.

**Acceptance:** each tool covered by unit tests; diagnostics list snapshot-tested on corrupted fixtures (bad record checksum, `UsedSlots` mismatch, duplicate pointer, main checksum broken).

### Phase 7 — Automation, emulator verification, release

1. `.github/workflows/sync-game-data.yml` (§9.1): dispatch, schedule and manual triggers; PR with `CHANGES.md`.
2. `tools/roundtrip/pyboy_check.py`:
   - patch the cart header to MBC5 in memory, exactly as `tools/pc_harness.py` does;
   - write all 8 SRAM banks from the edited save;
   - boot and call `TryLoadSaveFile` (or drive Continue from the title screen);
   - assert no "corrupted" text, the `wPartyCount` and species/moves indexes via `GetPokemonIndexFromID` / `GetMoveIndexFromID`, and each box slot via `GetStorageBoxMon` (no carry).
   - Run it in CI on all synthetic fixtures after a scripted set of edits.
3. Save migration between layout profiles (§10.2).
4. Deploy to Pages. Version banner. "Report a bug" link that attaches the diagnostics JSON.
5. Documentation: `docs/save-format.md` (from §4), `docs/updating.md`, `docs/architecture.md`.

**Acceptance:**
- A push to Crimson `main` produces a PR in the editor repo within one workflow run, with regenerated data, green tests and a data changelog.
- After merge the site serves the new build. Older saves are still detected by their profile.

---

## 12. Test strategy summary

| Layer | Tests |
|---|---|
| Constants/asm parsers | unit tests on small asm snippets + full-repo strict run |
| Layout | symbol assertions; hash stability; known-drift regression (`5dc51b77` vs HEAD) |
| Codec | per-field encode/decode; record checksum vectors (Appendix A); conversion-table alloc/lookup |
| Mechanics | stats/exp/PP/gender/ability/HP-type tables vs ROM-produced values (generate expected values once with PyBoy calling `CalcMonStats`, `CalcExpAtLevel`, `RestoreTempMonPP`) |
| Round-trip | no-op byte identity; randomized edit properties; re-parse equality |
| Emulator | PyBoy load-and-inspect on edited fixtures (CI gate once stable) |
| Data | ROM oracle; count assertions; uniqueness of constants; every learnset move resolves |
| UI | Playwright smoke tests |

---

## 13. Risks and open questions for Lucas

1. **License/permission** for reusing Polished Editor code (no LICENSE upstream).
2. Hosting: GitHub Pages (recommended, matches `docs/`) or Vercel? Separate repo (recommended) or a folder in the ROM repo?
3. How far back should old builds stay editable? Recommendation: detect every layout ever published; edit only the last 10 layouts; offer migration.
4. Should the editor allow "illegal" edits (moves outside learnsets, empty ability slots) by default? Recommendation: allow, with INFO hints, since this is a dev and testing tool.
5. Will you adopt the save-layout lock (§9.4)? It is the cleanest fix for silent layout drift.
6. Should edited saves be bit-compatible with both the release and debug ROM? (They are today; CI will tell us if that changes.)
7. Which emulator(s) do you use? This affects RTC trailer handling tests (VBA-M/mGBA 48-byte footer seen in your saves).

---

## Appendix A — Reference algorithms (TypeScript)

```ts
// File offset of an SRAM symbol
export const sramOffset = (bank: number, addr: number) => bank * 0x2000 + (addr - 0xa000);

export const checksum16 = (b: Uint8Array, start: number, end: number) => {
  let s = 0; for (let i = start; i < end; i++) s += b[i]; return s & 0xffff;
};
export const setLE16 = (b: Uint8Array, o: number, v: number) => { b[o] = v & 0xff; b[o + 1] = (v >> 8) & 0xff; };
export const getLE16 = (b: Uint8Array, o: number) => b[o] | (b[o + 1] << 8);

// PokeDB record checksum (verified against ComputeSavedMonChecksum)
export function savemonChecksum(r: Uint8Array): number {
  let run = 0, acc = 0;
  for (let i = 0; i < 0x37; i++) { run = (run + r[i]) & 0xffff; acc = (acc + run) & 0xffff; }
  return (0x7f + acc) & 0xffff;
}

// Main-copy checksum update (backup identical with backup symbols)
export function fixMainChecksums(f: Uint8Array, L: Layout) {
  const conv = checksum16(f, L.main.moveTable, L.main.moveTable + L.tables.move.size);
  setLE16(f, L.main.convChecksum, conv);                       // must precede the next line
  setLE16(f, L.main.checksum, checksum16(f, L.main.saveDataStart, L.main.saveDataEnd));
}

// Conversion table
export function idToIndex(t: Uint8Array, id: number, P: TableParams): number | null {
  if (id === 0) return 0;
  if (id >= P.reservedMin) return 0xff00 | id;
  if (id > P.entries) return null;                 // invalid
  return getLE16(t, 2 + 2 * (id - 1));
}
export function indexToId(t: Uint8Array, index: number, P: TableParams): number {
  if (index === 0) return 0;
  if ((index & 0xff00) === 0xff00 && (index & 0xff) >= P.reservedMin) return index & 0xff;
  for (let k = 0; k < P.entries; k++) if (getLE16(t, 2 + 2 * k) === index) return k + 1;
  for (let k = 0; k < P.entries; k++) if (getLE16(t, 2 + 2 * k) === 0) {
    setLE16(t, 2 + 2 * k, index); t[0] = (t[0] + 1) & 0xff; return k + 1;
  }
  throw new Error('conversion table full');
}

// PokeDB entry -> file offset
export function recordOffset(L: Layout, pool: 1 | 2, entry: number): number {
  const k = entry - 1, A = L.counts.MONDB_ENTRIES_A, B = L.counts.MONDB_ENTRIES_B;
  if (k < A) return L.pokeDB[`${pool}A`] + 57 * k;
  if (k < A + B) return L.pokeDB[`${pool}B`] + 57 * (k - A);
  return L.pokeDB[`${pool}C`] + 57 * (k - A - B);
}

// Box move index decode/encode
export const decodeMove = (lo: number, hiByte: number) => { const h = hiByte & 0x3f; return ((h === 0x3f ? 0xff : h) << 8) | lo; };
export const encodeMove = (index: number, ppUps: number) => ({ lo: index & 0xff, hi: ((ppUps & 3) << 6) | ((index >> 8) & 0x3f) });

// Pokérus fold for boxing
export const foldPokerus = (v: number) => { if (v >= 0x40) { v &= 0x3f; if (v < 0x10) v |= 0x10; } return v; };

// Stats
const sqrtCeilClamped = (x: number) => { let b = 1; while (b < 255 && b * b < x) b++; return b; };
export function calcStat(base: number, dv: number, statExp: number, level: number, isHP: boolean) {
  const bonus = Math.floor(sqrtCeilClamped(statExp) / 4);
  const v = Math.floor((((base + dv) * 2) + bonus) * level / 100);
  return Math.min(999, isHP ? v + level + 10 : v + 5);
}
export const hpDV = (atk: number, def: number, spd: number, spc: number) =>
  ((atk & 1) << 3) | ((def & 1) << 2) | ((spd & 1) << 1) | (spc & 1);

// Exp at level (growth_rate a, b, c(signed), d, e)
export const expAtLevel = (g: { a: number; b: number; c: number; d: number; e: number }, n: number) =>
  n <= 1 ? 0 : Math.floor((g.a * n ** 3) / g.b) + g.c * n * n + g.d * n - g.e;

// Max PP
export const maxPP = (base: number, ups: number) => Math.min(63, base + Math.min(7, Math.floor(base / 5)) * ups);
```

Check `expAtLevel` against ROM outputs for all six rates at levels 2–100. Medium Slow uses c = −15; confirm that 24-bit wraparound never occurs within the range.

## Appendix B — Symbols the layout extractor must resolve

`sOptions sCheckValue1 sSaveData sGameData sPlayerData sCurMapData sPokemonData sGameDataEnd sPokemonIndexTable sConversionTableChecksum sSaveDataEnd sChecksum sCheckValue2 sBackupOptions sBackupCheckValue1 sBackupSaveData sBackupGameData sBackupPlayerData sBackupCurMapData sBackupPokemonData sBackupGameDataEnd sBackupPokemonIndexTable sBackupConversionTableChecksum sBackupSaveDataEnd sBackupChecksum sBackupCheckValue2 sMoveIndexTable sBackupMoveIndexTable sCrystalData sSaveVersion sWritingBackup sNewBox1 sNewBox2 sNewBoxEnd sBackupNewBox1 sBackupNewBoxEnd sBoxMons1A sBoxMons1AEnd sBoxMons1B sBoxMons1BEnd sBoxMons2A sBoxMons2AEnd sBoxMons2B sBoxMons2BEnd [sBoxMons1C sBoxMons2C if present] sPartyMail sPartyMailBackup`

`wPlayerData wPlayerDataEnd wCurMapData wCurMapDataEnd wPokemonData wPokemonDataEnd wOptions wOptionsEnd wCrystalData wPlayerGender wPokemonIndexTable wPokemonIndexTableEnd wMoveIndexTable wMoveIndexTableEnd wPlayerID wPlayerName wMomsName wRivalName wGameTimeHours wGameTimeMinutes wGameTimeSeconds wGameTimeFrames wStatusFlags wStatusFlags2 wMoney wMomsMoney wCoins wJohtoBadges wKantoBadges wTMsHMs wTMsHMsEnd wNumItems wItems wNumKeyItems wKeyItems wNumBalls wBalls wNumPCItems wPCItems wEventFlags wCurBox wBlueCardBalance wGameplayRules wMapGroup wMapNumber wXCoord wYCoord wPartyCount wPartySpecies wPartyEnd wPartyMon1 wPartyMon2 wPartyMon1Species … wPartyMon1StatsEnd (all fields) wPartyMonOT wPartyMonNicknames wPartyMonNicknamesEnd wPokedexCaught wEndPokedexCaught wPokedexSeen wEndPokedexSeen wUnownDex wUnlockedUnowns wBreedMon1 wBreedMon2 wEggMon wContestMon wRoamMon1 wRoamMon2 wRoamMon3`

ROM-oracle symbols: `BaseData Moves ItemAttributes TMHMMoves CaughtBallItems OriginalPokemonTypes RevampedPokemonTypes OriginalPokemonStats EvosAttacksPointers EggMovePointers EngineFlags HardModeLevelCaps`.

## Appendix C — Verification log (reproducible)

```
# RGBDS 0.5.2 from source (the committed rgbds/ binaries are corrupt)
git clone --depth 1 --branch v0.5.2 https://github.com/gbdev/rgbds && make -C rgbds
make RGBDS=<rgbds>/ pokecrystal.gbc && make RGBDS=<rgbds>/ debug       # ~1 min, HEAD 06c4a7bb
git worktree add ../old 5dc51b77 && make -C ../old RGBDS=<rgbds>/ pokecrystal.gbc

# Checksums (old build symbols) on the two 2026-09-09 .bak saves
main 0xd129/0xd129, moveTable 0x0bc7/0x0bc7, backup 0xd129/0xd129, backupMoveTable 0x0bc7/0x0bc7   (elemental-sphere)
main 0xd1ea/0xd1ea, moveTable 0x0bc7/0x0bc7, backup 0xd1ea/0xd1ea, backupMoveTable 0x0bc7/0x0bc7   (key-item-fix)
sSaveVersion=2, sWritingBackup=0, check values 0x63/0x7f; main==backup; active==backup snapshot

# Party decode (key-item-fix save): species ID 6 -> table entry 6 = 159 (CROCONAW), Lv100,
#   exp 1,059,860 (Medium Slow L100), moves IDs 15..18 -> indexes 242/300/163/329, flags byte 0x40 (male)

# Layout drift with the same SAVE_FORMAT_VERSION = 2 (5dc51b77 -> HEAD):
wNumItems +1, wCurBox +5, wEndPokedexCaught +4, wEndPokedexSeen +5; sSaveDataEnd 01:AC31 -> 01:AC36

# PyBoy (tools/pc_harness.py) against HEAD ROM
ComputeSavedMonChecksum vs Python reference: 20/20 random records match
EncodeSavedMon(species 282, moves 421/300/1/256, PPUps 3/1/2/0, pokerus 0x52, flags 0xC0, HPType DARK):
  record[0:2]=1a01 (LE 282), moves lo/hi -> 421,300,1,256, ups 3,1,2,0, byte 0x1d=0xd2 (fold 0x52->0x12 | 0xC0),
  flags 0x36 (DARK<<1), nickname/OT '@'-padded, checksum 0x4a4e == Python

# Release vs debug ROM: 0 differing SRAM symbols; 0 differing saved-WRAM symbols
```
