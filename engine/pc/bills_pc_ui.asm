; Graphical Bill's PC (Polished Crystal-style storage interface), written for
; Crimson Crystal's engine on top of engine/pc/storage.asm.
;
; Conventions (see docs/pc_storage_design.md):
; - slot bc: b = 0 party / 1-NUM_BOXES box, c = 1-based slot. c = 0 = box title.
; - The cursor position wBillsPC_CursorPos is $yx: y = 0 title row, 1-5 icon
;   rows; x = 0-1 party columns (rows 3-5 only), 2-5 box columns.
; - VRAM bank 1 holds every icon/sprite tile; the font and PC frame tiles are
;   in bank 0. Any code that leaves rVBK = 1 must keep hBGMapMode = 0 so the
;   VBlank tilemap copy never lands in the attribute map.
; - HBlank palette writes come from BillsPC_LCDCode copied into WRAM0.
;
; Cross-bank calls: this file only reaches other banks with farcall; every
; plain call targets home or this file.

; BillsPC_MenuStrings / BillsPC_MenuJumptable indexes
	const_def
	const BOXMENU_CANCEL
	const BOXMENU_WITHDRAW
	const BOXMENU_DEPOSIT
	const BOXMENU_STATS
	const BOXMENU_SWITCH
	const BOXMENU_ITEM
	const BOXMENU_RELEASE
	const BOXMENU_CHANGE
	const BOXMENU_RENAME
	const BOXMENU_THEME
	const BOXMENU_RELEASEALL
	const BOXMENU_TAKEMAIL
	const BOXMENU_READMAIL
	const BOXMENU_MOVEITEM
	const BOXMENU_BAGITEM
	const BOXMENU_GIVEITEM

; VRAM bank 1 object tiles (vTiles3)
PCTILE_BLANK       EQU $00 ; 4 blank tiles
PCTILE_CURSOR      EQU $04 ; 3 tiles
PCTILE_HELD_MINI   EQU $08 ; 4 tiles (also the held item icon)
PCTILE_HELD_MASK   EQU $0c ; 4 tiles
PCTILE_QUICK_MINI  EQU $14 ; 4 tiles
PCTILE_QUICK_MASK  EQU $18 ; 4 tiles
PCTILE_ITEM_ICONS  EQU $1c ; NUM_HELD_ITEM_TYPES tiles
PCTILE_HOVER_ITEM  EQU $20 ; 1 tile: icon of the item held by the hovered mon
PCTILE_OBJ_GFX     EQU $24 ; modes (11) + bags (16)
; VRAM bank 1 BG tiles (vTiles4 = $80.., vTiles5 = $00..)
PCTILE_PARTY_MINIS EQU $80 ; 6 x 4 tiles
PCTILE_BOX_MINIS   EQU $98 ; 20 x 4 tiles
; VRAM bank 0 BG tiles (vTiles2)
PCTILE_FRONTPIC    EQU $00 ; 7 x 7 (alternates between bank 0 and 1)
PCTILE_FRAME       EQU $31 ; 17 tiles: gfx/pc/pc.png
PCTILE_SHINY       EQU $42 ; 1 tile: gfx/pc/shiny.png
PCTILE_MALE        EQU $43 ; colored "♂" (built from the font)
PCTILE_FEMALE      EQU $44 ; colored "♀"
PCTILE_POKERUS     EQU $40 ; infected (in gfx/pc/pc.png)
PCTILE_POKERUS_CURED EQU $41

; BG palettes
PAL_PC_BG      EQU 0 ; background, female, male, text
PAL_PC_FRAME   EQU 1 ; background, border, window, white
PAL_PC_POKEPIC EQU 2 ; frontpic (colors 1-2) - also party row icon 1 via HBlank
PAL_PC_SYMBOLS EQU 3 ; shiny/pokerus symbols - also party row icon 2 via HBlank
PAL_PC_BOXMON  EQU 4 ; box icon columns use 4-7

PC_LYC_FIRST_ROW EQU 71 ; scanline of the first icon row palette switch
PC_ICON_ROW_HEIGHT EQU 16

_BillsPC::
	call .CheckCanUsePC
	ret c
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a
	ld a, [wVramState]
	push af
	xor a
	ld [wVramState], a
	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a
	; ApplyTilemap must not use CopyTilemapAtOnce (it disables interrupts for
	; over a frame, starving the HBlank palette code); the PC pushes
	; attributes itself.
	ld a, [wSpriteUpdatesEnabled]
	push af
	xor a
	ld [wSpriteUpdatesEnabled], a
	call LoadStandardMenuHeader
	call UseBillsPC
	call BillsPC_DisableHBlank
	call ClearSprites
	farcall ClearSpriteAnims
	pop af
	ld [wSpriteUpdatesEnabled], a
	pop af
	ldh [hInMenu], a
	pop af
	ld [wVramState], a
	call ReturnToMapFromSubmenu
	pop af
	ldh [hMapAnims], a
	pop af
	ld [wOptions], a
	jp CloseSubmenu

.CheckCanUsePC:
	ld a, [wPartyCount]
	and a
	ret nz
	ld hl, .Text_GottaHavePokemon
	call MenuTextboxBackup
	scf
	ret

.Text_GottaHavePokemon:
	; You gotta have #MON to call!
	text_far UnknownText_0x1c1006
	text_end

BillsPC_DisableHBlank:
; Stops the HBlank palette code and puts the STAT interrupt back to the
; game's default (HBlank, for hLCDCPointer users). Safe to call repeatedly.
	xor a
	ldh [hLCDCPointer], a
	ld a, 1 << 3 ; HBlank interrupt (home/init.asm)
	ldh [rSTAT], a
	ret

BillsPC_EnableHBlank:
; (Re)installs the HBlank palette code: recopies it to WRAM0, resets the
; phase and scanline so a restore after another screen never resumes a stale
; phase, then points the LCD interrupt at it.
	call BillsPC_DisableHBlank
	ld hl, BillsPC_LCDCode
	ld de, wLCDBillsPC
	ld bc, BillsPC_LCDCode.End - BillsPC_LCDCode
	call CopyBytes
	; Stage row 1 (and a white BG 3 colour 0) so the very first scanline
	; switch doesn't show garbage
	ld hl, wBillsPC_PalList + (wBillsPC_MonPals2 - wBillsPC_MonPals1)
	ld de, wBillsPC_CurPals
	ld bc, wBillsPC_MonPals2 - wBillsPC_MonPals1
	call CopyBytes
	ld hl, wBillsPC_CurColor0
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hl], a
	ld a, LOW(wLCDBillsPC)
	ldh [hLCDInterruptFunctionTargetLo], a
	ld a, HIGH(wLCDBillsPC)
	ldh [hLCDInterruptFunctionTargetHi], a
	; LYC interrupt only (the code waits for HBlank itself); set LYC last so
	; a match can't fire before the handler is in place.
	ld a, 1 << 6
	ldh [rSTAT], a
	ld a, LCD_CUSTOM_HANDLER
	ldh [hLCDCPointer], a
	ld a, PC_LYC_FIRST_ROW
	ldh [rLYC], a
	ret

BillsPC_LoadUI:
; Loads every graphic the screen needs into VRAM.
	xor a
	ldh [hBGMapMode], a
	ld a, 1
	ldh [rVBK], a

	; 4 blank tiles for empty sprite slots (explicit zeros; never assume VRAM is clear)
	ld hl, vTiles3 tile PCTILE_BLANK
	ld de, BillsPC_BlankTileGFX
	lb bc, BANK(BillsPC_BlankTileGFX), 4
	call Get2bpp

	; Bank-1 tile $7f: the blank interior of both boxes (attribute bank 1)
	ld hl, vTiles5 tile $7f
	ld de, BillsPC_BlankTileGFX
	lb bc, BANK(BillsPC_BlankTileGFX), 1
	call Get2bpp

	; Cursor
	ld hl, vTiles3 tile PCTILE_CURSOR
	ld de, BillsPC_CursorGFX
	lb bc, BANK(BillsPC_CursorGFX), 3
	call Get2bpp

	; Blank held cursor mini + mask, quick mini + mask, item icons, hover icon
	ld hl, vTiles3 tile PCTILE_HELD_MINI
	ld a, 7
	call BillsPC_BlankTiles
	call BillsPC_BlankCursorItem

	; Held item category icons
	ld hl, vTiles3 tile PCTILE_ITEM_ICONS
	ld de, BillsPC_HeldItemIcons
	lb bc, BANK(BillsPC_HeldItemIcons), NUM_HELD_ITEM_TYPES
	call Get2bpp

	; Cursor mode and bag sprites
	ld hl, BillsPC_ObjGFX
	ld de, vTiles3 tile PCTILE_OBJ_GFX
	lb bc, BANK(BillsPC_ObjGFX), 27
	call DecompressRequest2bpp

	xor a
	ldh [rVBK], a

	; "<LV>", "◀" and friends live in the battle-extra font (vTiles2 $60+)
	call LoadFontsBattleExtra

	; Box frame, "PARTY" label and Pokérus symbols (bank 0)
	ld hl, BillsPC_TileGFX
	ld de, vTiles2 tile PCTILE_FRAME
	lb bc, BANK(BillsPC_TileGFX), 17
	call DecompressRequest2bpp
	ld hl, vTiles2 tile PCTILE_SHINY
	ld de, BillsPC_ShinyGFX
	lb bc, BANK(BillsPC_ShinyGFX), 1
	call Get2bpp
	call BillsPC_LoadGenderTiles

	; Theme palettes are (re)loaded in full by BillsPC_LoadPalettes
	xor a
	ld [wBillsPC_ApplyThemePals], a

	; Sprite anim structs
	farcall ClearSpriteAnims
	; dict key 0 -> tile base 0 (all PC OAM data uses absolute bank-1 tiles)
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], a
	; Cursor
	lb de, -18, 0 ; y, x (fixed up by the animseq code)
	ld a, SPRITE_ANIM_INDEX_PC_CURSOR
	call _InitSpriteAnimStruct
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a
	; Cursor mode icon (two sprites share the position), bottom left
	lb de, $98, $10
	ld a, SPRITE_ANIM_INDEX_PC_MODE
	push de
	call _InitSpriteAnimStruct
	pop de
	ld a, SPRITE_ANIM_INDEX_PC_MODE2
	call _InitSpriteAnimStruct
	; Reserve the 4th struct for the quick-move animation, then add the pack
	ld hl, wSpriteAnim4
	inc [hl]
	push hl
	lb de, $58, $30 ; y, x: top right of the party box
	ld a, SPRITE_ANIM_INDEX_PC_PACK
	call _InitSpriteAnimStruct
	pop hl
	dec [hl]
	ret

BillsPC_BlankTiles:
; Blanks a * 4 tiles at hl (VRAM bank 1 selected by the caller) in a single
; VBlank: zeros in wDecompressScratch pushed with one DMA. This must not be
; split over frames - the held/quick sprite is mini + white mask, and
; blanking the mini a frame before the mask leaves the mask covering the
; icon that just landed underneath: a one-frame blink on every drop.
	add a
	add a
	ld c, a ; tiles
	push hl
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld b, 0
rept 4
	sla c
	rl b
endr
	ld hl, wDecompressScratch
	xor a
	call ByteFill
	pop af
	ldh [rSVBK], a
	pop bc
	pop hl
	jp BillsPC_DMAFromScratch

BillsPC_SafeGet2bpp:
; Get2bpp for small ROM copies. With the LCD on, Crimson's Get2bpp queues the
; tiles for the VBlank handler (8 per frame), which never overlaps the HBlank
; palette window, so nothing else is needed here. Bulk copies use
; BillsPC_DMACopy instead.
	jp Get2bpp

PC_DMA_CHUNK EQU 49 ; tiles per VBlank general-purpose DMA (~400us; a frontpic)

BillsPC_DMACopy:
; Copies c tiles from de to VRAM hl with general-purpose DMA run by the
; VBlank handler (hDMATransfer), in chunks of PC_DMA_CHUNK tiles per frame.
; de must be 16-byte aligned and reachable at VBlank time: the caller keeps
; its ROM bank / SRAM / rSVBK / rVBK selected until this returns.
	ld a, c
	dec a
	jr nz, .more_than_one
	; a single tile: hDMATransfer can't express one block (0 = none)
	ldh a, [hROMBank]
	ld b, a
	jp Get2bpp
.more_than_one
	ld a, c
	cp PC_DMA_CHUNK + 1
	jr c, .got_chunk
	ld a, PC_DMA_CHUNK
	; never leave a remainder of one block either
	cp c
	jr z, .got_chunk
	inc a
	cp c
	jr nz, .not_one_left
	ld a, PC_DMA_CHUNK - 1
	jr .got_chunk
.not_one_left
	ld a, PC_DMA_CHUNK
.got_chunk
	ld b, a
	ld a, d
	ldh [rHDMA1], a
	ld a, e
	ldh [rHDMA2], a
	ld a, h
	and $1f
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ld a, b
	dec a ; blocks - 1, bit 7 clear = general-purpose
	ldh [hDMATransfer], a
.wait
	call DelayFrame
	ldh a, [hDMATransfer]
	and a
	jr nz, .wait
	ld a, c
	sub b
	ret z
	ld c, a
	; advance both pointers by b tiles
	push bc
	ld c, b
	ld b, 0
rept 4
	sla c
	rl b
endr
	add hl, bc
	ld a, e
	add c
	ld e, a
	ld a, d
	adc b
	ld d, a
	pop bc
	jr BillsPC_DMACopy

BillsPC_DMAFromScratch:
; Copies c tiles from wDecompressScratch to VRAM hl (current rVBK).
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld de, wDecompressScratch
	call BillsPC_DMACopy
	pop af
	ldh [rSVBK], a
	ret

UseBillsPC:
	call ClearTileMap
	call ClearPalettes
	farcall WipeAttrMap
	call ClearSprites
	farcall ClearSpriteAnims
	xor a
	ldh [hBGMapMode], a

	call BillsPC_LoadUI

	xor a ; PC_MENU_MODE
	call _BillsPC_SetCursorMode

	; Default cursor: first box slot, nothing held
	ld a, $12
	ld [wBillsPC_CursorPos], a
	xor a
	ld [wBillsPC_CursorHeldBox], a
	ld [wBillsPC_CursorHeldSlot], a
	ld [wBillsPC_CursorItem], a
	ld [wBillsPC_QuickFrames], a
	ld [wBillsPC_ApplyThemePals], a

	call BillsPC_DrawStaticLayout
	call BillsPC_LoadPalettes ; theme, symbols, object palettes

	; Icons and their palettes (tilemaps were set up by the layout)
	ld a, 1
	ldh [rVBK], a
	call SetPartyIcons
	call SetBoxIconsAndName
	xor a
	ldh [rVBK], a

	; Push tiles + attributes
	call CopyTilemapAtOnce
	call BillsPC_ApplyPals
	call BillsPC_CommitPals

	call BillsPC_EnableHBlank

	; Data about the Pokémon under the cursor
	call GetCursorMon

	ld a, 1
	ldh [hBGMapMode], a
	call ManageBoxes

	call BillsPC_DisableHBlank
	call ClearTileMap
	jp ClearPalettes

BillsPC_DrawStaticLayout:
; Draws the frames, labels and icon tilemaps into wTileMap/wAttrMap.
	; Pokepic attributes
	hlcoord 0, 0, wAttrMap
	lb bc, 7, 7
	ld a, PAL_PC_POKEPIC
	call BillsPC_FillBoxWithByte

	; Shiny and Pokérus symbols
	hlcoord 5, 8, wAttrMap
	ld a, PAL_PC_SYMBOLS
	ld [hli], a
	ld [hl], a

	; Storage box
	hlcoord 7, 4
	lb bc, 12, 11
	ld de, .BoxTiles
	call .Box

	; Separator between box name and contents
	hlcoord 7, 6
	lb bc, $3e, 11
	call .SpecialRow

	; Box title row uses palette 7 (text) in bank 0
	hlcoord 8, 5, wAttrMap
	ld bc, 11
	ld a, 7
	call ByteFill

	; Party box
	hlcoord 0, 9
	lb bc, 7, 5
	ld de, .PartyTiles
	call .Box

	; Party label borders
	hlcoord 0, 10
	lb bc, $36, 5
	call .SpecialRow

	; Party label text tiles
	hlcoord 2, 9
	ld a, $38
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	hlcoord 2, 10
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a

	; Icon tilemaps: party (3 rows x 2 columns), box (5 rows x 4 columns)
	hlcoord 1, 11
	lb bc, 3, 2
	lb de, PCTILE_PARTY_MINIS, PAL_PC_POKEPIC | VRAM_BANK_1
	call .WriteIconTilemap
	hlcoord 8, 7
	lb bc, 5, 4
	lb de, PCTILE_BOX_MINIS, PAL_PC_BOXMON | VRAM_BANK_1
	call .WriteIconTilemap
	ret

.Box:
; Draws a box with tiles and attributes. hl = top-left, b = inner height,
; c = inner width, de = 9 tile bytes (top/middle/bottom rows, 3 each).
	push bc
	push hl
	call BillsPC_CreateBoxBorders
	pop hl
	ld bc, wAttrMap - wTileMap
	add hl, bc
	pop bc
	ld de, .BoxAttr
	jp BillsPC_CreateBoxBorders

.BoxTiles:
	db $33, $32, $33 ; top
	db $31, $7f, $31 ; middle
	db $33, $32, $33 ; bottom
.PartyTiles:
	db $35, $34, $35 ; top
	db $31, $7f, $31 ; middle
	db $33, $32, $33 ; bottom
.BoxAttr:
	db 1, 1, 1 | X_FLIP ; top
	db 1, PAL_PC_POKEPIC | VRAM_BANK_1, 1 | X_FLIP ; middle
	db 1 | Y_FLIP, 1 | Y_FLIP, 1 | X_FLIP | Y_FLIP ; bottom

.SpecialRow:
; A separator row: tile b at the left edge, b+1 across c tiles, b again at
; the right edge; all with attribute 1.
	ld a, b
	ld [hli], a
	inc a
	ld b, 0
	push bc
	push hl
	call ByteFill
	dec a
	ld [hl], a
	pop hl
	ld bc, wAttrMap - wTileMap
	add hl, bc
	pop bc
	ld a, 1
	jp ByteFill

.WriteIconTilemap:
; Writes 2x2 icon tiles + attributes for b rows of c icons starting at
; hlcoord, first tile d, attribute e. Icons are 3 tiles apart.
	ld a, d
.tile_row
	push bc
	push de
	push hl
.tile_col
	call .icon
	dec c
	jr nz, .tile_col
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop de
	pop bc
	dec b
	jr nz, .tile_row
	ret

.icon
	push bc
	ld [hli], a
	inc a
	ld [hld], a
	inc a
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hli], a
	inc a
	ld [hld], a
	inc a
	ld bc, -SCREEN_WIDTH + (wAttrMap - wTileMap)
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], e
	ld bc, SCREEN_WIDTH - 1
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], e
	inc e
	ld bc, -SCREEN_WIDTH + 2 + (wTileMap - wAttrMap)
	add hl, bc
	pop bc
	ret

BillsPC_CreateBoxBorders:
; hl = top-left corner, b = inner height, c = inner width, de = 3x3 tiles.
	push bc
	push de
	call .Row
	pop de
	pop bc
	inc de
	inc de
	inc de
.middle_loop
	push bc
	push de
	call .Row
	pop de
	pop bc
	dec b
	jr nz, .middle_loop
	inc de
	inc de
	inc de
	; fallthrough
.Row:
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	push bc
	ld b, 0
	call ByteFill
	pop bc
	ld a, [de]
	ld [hl], a
	push de
	ld de, SCREEN_WIDTH - 1
	ld a, l
	sub c
	ld l, a
	jr nc, .no_borrow
	dec h
.no_borrow
	add hl, de
	pop de
	ret

BillsPC_FillBoxWithByte:
; Fills b rows x c columns at hl with a.
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

BillsPC_SetCursorMode:
	call _BillsPC_SetCursorMode
BillsPC_SetPals:
	call BillsPC_ApplyPals
	jp BillsPC_CommitPals

BillsPC_CommitPals:
; wBGPals1/wOBPals1 -> wBGPals2/wOBPals2, then let VBlank push them.
	farcall ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_BillsPC_SetCursorMode:
; Switches cursor mode and updates the cursor object palette colors in
; wOBPals1 (not committed here). Also updates the mode icon via its animseq.
	ld [wBillsPC_CursorMode], a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld a, [wBillsPC_CursorMode]
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, .CursorPals
	add hl, de
	ld de, wOBPals1 palette PAL_PC_CURSOR_MODE1 + 4
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wOBPals1 palette PAL_PC_CURSOR_MODE2 + 4
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop af
	ldh [rSVBK], a
	ret

.CursorPals:
INCLUDE "gfx/pc/cursor.pal"

BillsPC_LoadPalettes::
; Loads the theme (BG 0/1), symbol (BG 3), and object palettes into
; wBGPals1/wOBPals1 and commits them. Also called through the SCGB_BILLS_PC
; layout entry. Preserves the HBlank staging list unless
; wBillsPC_ApplyThemePals is set, in which case the icon pals are re-staged.
	call GetBoxTheme_far
BillsPC_PreviewTheme:
; a = theme. Same as above but with an explicit theme (theme picker preview).
	call BillsPC_GetThemePalette ; hl = text, background, border, window
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	; BG 0 colors 1-2: female (red), male (blue)
	push hl
	ld hl, BillsPC_GenderPals
	ld de, wBGPals1 + 2
	ld bc, 2 * 2
	call CopyBytes
	pop hl
	; then the four theme colors land in BG 0 color 3 (text) and
	; BG 1 colors 0-2 (background, border, window)
	ld bc, 4 * 2
	call CopyBytes
	; BG 1 color 3: white
	ld a, LOW(PALRGB_WHITE)
	ld [de], a
	inc de
	ld a, HIGH(PALRGB_WHITE)
	ld [de], a
	; BG 0 color 0 = BG 1 color 0 (theme background)
	ld hl, wBGPals1 palette 1
	ld de, wBGPals1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	; symbol colors: shiny, pokerus (staged for the HBlank list)
	ld hl, BillsPC_ShinyAndPokerusPals
	ld de, wBillsPC_PokerusShinyPal
	ld bc, 2 * 2
	call CopyBytes
	pop af
	ldh [rSVBK], a

	ld a, [wBillsPC_ApplyThemePals]
	and a
	jp nz, BillsPC_SetPals

	; Object palettes
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, BillsPC_ObjectPals
	ld de, wOBPals1
	ld bc, 8 palettes
	call CopyBytes
	pop af
	ldh [rSVBK], a
	; cursor mode colors on top of the defaults
	ld a, [wBillsPC_CursorMode]
	call _BillsPC_SetCursorMode
	jp BillsPC_SetPals

BillsPC_GenderPals:
	RGB 31, 12, 06 ; female (red)
	RGB 04, 17, 31 ; male (blue)

GetBoxTheme_far:
	farcall GetBoxTheme
	ret

BillsPC_GetThemePalette:
; a = theme -> hl = 4 colors (8 bytes)
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, BillsPC_ThemePals
	add hl, de
	add hl, de
	ret

BillsPC_ThemePals:
INCLUDE "gfx/pc/themes.pal"

BillsPC_ShinyAndPokerusPals:
INCLUDE "gfx/pc/pokerus_shiny.pal"

BillsPC_ObjectPals:
; entries correspond to PAL_PC_* constants (palette 0 is unused)
	RGB 27, 31, 27, 31, 19, 10, 31, 07, 01, 00, 00, 00 ; 0: item icons
INCLUDE "gfx/pc/cursor_default.pal" ; PAL_PC_CURSOR_MODE1
INCLUDE "gfx/pc/cursor_default.pal" ; PAL_PC_CURSOR_MODE2
	RGB 31, 31, 31, 31, 31, 31, 00, 00, 00, 00, 00, 00 ; PAL_PC_MINI_ICON (set per mon)
INCLUDE "gfx/pc/pack.pal" ; PAL_PC_PACK
	RGB 31, 31, 31, 31, 31, 31, 00, 00, 00, 00, 00, 00 ; PAL_PC_QUICK (set per mon)
	RGB 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31 ; PAL_PC_SHADOW (white; mask tiles are transparent)
	RGB 31, 31, 31, 31, 31, 31, 00, 00, 00, 00, 00, 00 ; 7

BillsPC_ApplyPals:
; Writes the first-row HBlank colors into wBGPals1 palettes 2-7 (colors 1-2)
; so the frame's top rows already show the right colors before the HBlank
; code takes over, and fixes BG 3 color 0 to the theme background.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld de, wBillsPC_PalList
	ld hl, wBGPals1 palette 2
	ld c, 6
.loop
	; color 0: white
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hli], a
	; colors 1-2 from the staged list
	ld b, 4
.inner_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .inner_loop
	; color 3: black
	xor a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .loop
	; BG 3 color 0 is shared with the main background (the HBlank code
	; restores it after the last icon row from wBillsPC_BGColor0)
	ld hl, wBGPals1
	ld de, wBGPals1 palette 3
	ld a, [hli]
	ld [de], a
	ld [wBillsPC_BGColor0], a
	inc de
	ld a, [hl]
	ld [de], a
	ld [wBillsPC_BGColor0 + 1], a
	pop af
	ldh [rSVBK], a
	ret

BillsPC_RefreshTheme:
; Reloads the theme palettes after a box change or theme pick.
	ld a, 1
	ld [wBillsPC_ApplyThemePals], a
	call BillsPC_LoadPalettes
	xor a
	ld [wBillsPC_ApplyThemePals], a
	ret

; ---------------------------------------------------------------------------
; Icons
; ---------------------------------------------------------------------------

BillsPC_PrintBoxName:
; Writes the current box's name, centered, into the title row.
	hlcoord 9, 5
	ld a, " "
	ld bc, 9
	call ByteFill
	ld a, [wCurBox]
	ld b, a
	inc b
	farcall GetBoxName
	ld hl, wStringBuffer1
	ld b, 0
.loop
	ld a, [hli]
	inc b
	cp "@"
	jr nz, .loop
	srl b
	ld a, 5
	sub b
	ld c, a
	ld b, 0
	hlcoord 9, 5
	add hl, bc
	ld de, wStringBuffer1
	call PlaceString
	ret

SetPartyIcons:
; Loads the party minis (tiles + palettes) and the species list. rVBK = 1.
	ld b, 0
	ld hl, wBillsPC_PartyList
	call PCIconLoop
	ld hl, vTiles4 tile (PCTILE_PARTY_MINIS - $80)
	ld c, PARTY_LENGTH * 4
	jp BillsPC_DMAFromScratch

SetBoxIconsAndName:
	call BillsPC_PrintBoxName
	; fallthrough
SetBoxIcons:
; Loads the current box's minis and species list. rVBK = 1.
	ld a, [wCurBox]
	inc a
	ld b, a
	ld hl, wBillsPC_BoxList
	call PCIconLoop
	ld hl, vTiles4 tile (PCTILE_BOX_MINIS - $80)
	ld c, MONS_PER_BOX * 4
	jp BillsPC_DMAFromScratch

PCIconLoop:
; b = box (0 = party), hl = species list. Fills the list (2 bytes per slot:
; species index, bit 14 shiny, bit 15 egg; 0 = empty), stages every mini's
; tiles in slot order in wDecompressScratch (blank for empty slots) and
; writes the palettes into the HBlank list. The mon held by the cursor is
; drawn blank. The caller copies the staged tiles to VRAM afterwards.
	ld c, 1
.loop
	push hl
	ld a, [wBillsPC_CursorHeldBox]
	cp b
	jr nz, .load
	ld a, [wBillsPC_CursorHeldSlot]
	cp c
	jr z, .blank
.load
	farcall GetStorageBoxSpecies ; hl = index, a = flags, z = empty
	jr z, .blank
	ld d, h
	ld e, l
	bit SAVEMON_IS_EGG_F, a
	jr z, .not_egg
	set 7, d
.not_egg
	bit 7, a ; MON_SHINY_FLAG
	jr z, .got_entry
	set 6, d
	jr .got_entry

.blank
	ld de, 0
.got_entry
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	push hl
	push bc
	push de
	call .GetStagingAddr
	call BillsPC_StageMini
	pop de
	pop bc
	push bc
	ld a, d
	or e
	jr z, .no_pal
	push de
	call BillsPC_GetMonPalAddr ; hl = staged palette (4 bytes)
	pop de
	call BillsPC_WriteSpeciesPalette
.no_pal
	pop bc
	pop hl
	inc c
	ld a, b
	and a
	ld a, PARTY_LENGTH
	jr z, .got_count
	ld a, MONS_PER_BOX
.got_count
	inc a
	cp c
	jr nz, .loop
	ret

.GetStagingAddr:
; hl = wDecompressScratch + (c - 1) * 4 tiles
	ld hl, wDecompressScratch
	ld a, c
	dec a
	push bc
	ld bc, 4 tiles
	call AddNTimes
	pop bc
	ret

BillsPC_StageMini:
; Copies the 4 mini tiles of encoded species de (0 = blank) to hl in
; wDecompressScratch. Switches rSVBK for the copy only. Clobbers all.
	ld a, d
	or e
	jr z, .blank
	push hl
	bit 7, d
	jr z, .not_egg
	ld hl, EggMenuIcon
	ld b, BANK(EggMenuIcon)
	jr .got_pointer
.not_egg
	call BillsPC_GetMenuIconPointer ; b:hl
.got_pointer
	pop de
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld a, b
	ld bc, 4 tiles
	call FarCopyBytes
	pop af
	ldh [rSVBK], a
	ret

.blank
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	xor a
	ld bc, 4 tiles
	call ByteFill
	pop af
	ldh [rSVBK], a
	ret

BillsPC_StageMask:
; Builds a silhouette (every set pixel -> color 3) of the 4 staged tiles at
; hl into de, both in wDecompressScratch.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld c, 4 * 8
.loop
	ld a, [hli]
	or [hl]
	inc hl
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

BillsPC_LoadIconForSlot:
; Loads the mini tiles and stages the palette for slot bc showing encoded
; species de (0 = blank). rVBK = 1. Clobbers everything.
	push bc
	push de
	ld hl, wDecompressScratch
	call BillsPC_StageMini
	pop de
	pop bc
	push bc
	push de
	call BillsPC_GetMonPalAddr ; hl = staged palette (4 bytes)
	pop de
	push de
	ld a, d
	or e
	call nz, BillsPC_WriteSpeciesPalette
	pop de
	pop bc
	call BillsPC_GetMonTileAddr ; hl = VRAM tiles
	ld c, 4
	jp BillsPC_DMAFromScratch

BillsPC_LoadHeldIcon:
; Loads encoded species de (0 = blank) plus its silhouette into the held
; (a = 0) or quick-move (a = 1) sprite tiles. rVBK = 1.
	push af
	ld hl, wDecompressScratch
	call BillsPC_StageMini
	ld hl, wDecompressScratch
	ld de, wDecompressScratch + 4 tiles
	call BillsPC_StageMask
	pop af
	ld hl, vTiles3 tile PCTILE_HELD_MINI
	and a
	jr z, .got_dest
	ld hl, vTiles3 tile PCTILE_QUICK_MINI
.got_dest
	ld c, 8
	jp BillsPC_DMAFromScratch

BillsPC_GetMonTileAddr:
; hl = VRAM address of slot bc's mini tiles (bank 1).
	ld hl, vTiles4 tile (PCTILE_PARTY_MINIS - $80)
	ld a, b
	and a
	jr z, .got_base
	ld hl, vTiles4 tile (PCTILE_BOX_MINIS - $80)
.got_base
	ld a, c
	dec a
	ld bc, 4 tiles
	jp AddNTimes

BillsPC_GetMonIconAddr:
; hl = species list entry of slot bc.
	ld hl, wBillsPC_PartyList
	ld a, b
	and a
	jr z, .got_base
	ld hl, wBillsPC_BoxList
.got_base
	ld a, c
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ret

BillsPC_GetMonPalAddr:
; hl = staged HBlank palette (4 bytes) for slot bc. The list is laid out per
; icon row (24 bytes: 2 party + 4 box palettes): row 0 = pokepic/symbols +
; box row 1, rows 1-4 = party rows (from row 2) + box rows.
	ld a, c
	dec a
	ld d, 4
	ld hl, wBillsPC_MonPals1 ; row 0, box column 0
	inc b
	dec b
	jr nz, .loop
	ld d, 2
	ld hl, wBillsPC_PartyPals3 ; row 2, party column 0
.loop
	sub d
	jr c, .found_row
	push de
	ld de, wBillsPC_MonPals2 - wBillsPC_MonPals1 ; 24 bytes per row
	add hl, de
	pop de
	jr .loop
.found_row
	add d
	add a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ret

BillsPC_GetMenuIconPointer:
; de = encoded species (index in bits 0-9) -> b:hl = menu icon graphics.
	ld a, d
	and $03
	ld h, a
	ld l, e ; hl = index
	dec hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc ; (index - 1) * 3
	ld bc, MenuIconPointers
	add hl, bc
	ld a, BANK(MenuIconPointers)
	call GetFarByte
	ld b, a
	inc hl
	ld a, BANK(MenuIconPointers)
	call GetFarHalfword
	ret

BillsPC_WriteSpeciesPalette:
; Writes the two middle colors (4 bytes) of encoded species de's palette to hl.
	push hl
	bit 7, d
	jr z, .not_egg
	ld hl, EGG ; negative index: the palette table has an egg entry before it
	jr .got_index
.not_egg
	ld a, d
	and $03
	ld h, a
	ld l, e
.got_index
	add hl, hl
	add hl, hl
	add hl, hl ; index * 8
	bit 6, d
	jr z, .not_shiny
	inc hl
	inc hl
	inc hl
	inc hl
.not_shiny
	ld bc, PokemonPalettes
	add hl, bc
	pop de ; destination
	ld c, 4
.loop
	ld a, BANK(PokemonPalettes)
	call GetFarByte
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

BillsPC_LoadGenderTiles:
; Builds a dark (color 2, male blue) "♂" and a light (color 1, female red)
; "♀" from the 1bpp font and loads them at PCTILE_MALE/PCTILE_FEMALE (bank 0).
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld de, wDecompressScratch
	ld hl, Font + ("♂" - $80) * LEN_1BPP_TILE
	ld c, 8
.male_loop
	xor a
	ld [de], a ; plane 0 clear
	inc de
	ld a, BANK(Font)
	call GetFarByte
	inc hl
	ld [de], a ; plane 1 = glyph
	inc de
	dec c
	jr nz, .male_loop
	ld hl, Font + ("♀" - $80) * LEN_1BPP_TILE
	ld c, 8
.female_loop
	ld a, BANK(Font)
	call GetFarByte
	inc hl
	ld [de], a ; plane 0 = glyph
	inc de
	xor a
	ld [de], a
	inc de
	dec c
	jr nz, .female_loop
	ld hl, vTiles2 tile PCTILE_MALE
	ld de, wDecompressScratch
	ldh a, [hROMBank]
	ld b, a
	ld c, 2
	call Get2bpp
	pop af
	ldh [rSVBK], a
	ret

; ---------------------------------------------------------------------------
; Cursor
; ---------------------------------------------------------------------------

BillsPC_HideCursorAndMode:
	call BillsPC_HideCursor
	; fallthrough
BillsPC_HideModeIcon:
; The mode icon's 5 sprites follow the cursor's.
	call BillsPC_GetCursorSpriteBytes
	ld hl, wVirtualOAM
	add hl, bc
	ld bc, 5 * SPRITEOAMSTRUCT_LENGTH
	xor a
	jp ByteFill

BillsPC_HideCursor:
	call BillsPC_GetCursorSpriteBytes
	ld hl, wVirtualOAM
	xor a
	jp ByteFill

BillsPC_GetCursorFrameset:
; Returns a = the cursor's frameset and c = its sprite count: cursor + held
; item with the bag shown, cursor + held mini + shadow while carrying a mon,
; the bare cursor otherwise (fewer sprites on a line = more HBlank time for
; the palette code, see BillsPC_LCDCode).
	call BillsPC_CheckBagDisplay
	ld c, 5
	ld a, SPRITE_ANIM_FRAMESET_PC_CURSOR_ITEM
	ret z
	ld a, [wBillsPC_CursorHeldSlot]
	and a
	ld c, 12
	ld a, SPRITE_ANIM_FRAMESET_PC_CURSOR
	ret nz
	ld c, 4
	ld a, SPRITE_ANIM_FRAMESET_PC_CURSOR_EMPTY
	ret

BillsPC_GetCursorSpriteBytes:
; bc = size of the cursor's sprites in wVirtualOAM
	call BillsPC_GetCursorFrameset
	ld a, c
	add a
	add a
	ld c, a
	ld b, 0
	ret

BillsPC_UpdateCursorLocation:
; Runs the sprite animations (cursor bop, mode icon, pack, quick move) while
; keeping the raw item icon sprites 30-31, which the anim engine would wipe.
	push hl
	push de
	push bc
	ldh a, [rLY]
	cp $60
	call nc, DelayFrame
	ld hl, wVirtualOAMSprite30
	ld de, wStringBuffer3
	ld bc, 2 * SPRITEOAMSTRUCT_LENGTH
	call CopyBytes
	farcall PlaySpriteAnimations
	ld hl, wStringBuffer3
	ld de, wVirtualOAMSprite30
	ld bc, 2 * SPRITEOAMSTRUCT_LENGTH
	call CopyBytes
	pop bc
	pop de
	pop hl
	ret

BillsPC_GetCursorHeldSlot:
; Returns the held box+slot in bc. Returns z if nothing is held. Bit 7 of b
; is set when the held thing is an item rather than a mon.
	ld a, [wBillsPC_CursorHeldBox]
	ld b, a
	ld a, [wBillsPC_CursorHeldSlot]
	ld c, a
	and a
	ret

BillsPC_GetCursorSlot:
; Converts the cursor position to slot bc. Returns carry if hovering the box
; name. b = 0 party / 1-NUM_BOXES box, c = 1-20 slot, 0 = box name.
; If b is 0 and c is -1, the cursor is on the bag.
	ld c, 0
	ld a, [wCurBox]
	inc a
	ld b, a
	ld a, [wBillsPC_CursorPos]
	sub $10
	ret c

	ld b, a
	and $f
	; Columns 0-1 are the party
	cp 2
	jr c, .party

	; Storage: $yx with row 0-4 and column 2-5 -> y*4 + x - 1
	ld c, a
	ld a, b
	swap a
	and $f
	add a
	add a
	add c
	dec a
	ld c, a
	ld a, [wCurBox]
	inc a
	ld b, a
	ret
.party
	; Party: $yx with row 2-4 and column 0-1 -> y*2 + x - 3
	ld c, a
	ld a, b
	swap a
	and $f
	add a
	add c
	sub 3
	ld c, a
	ld b, 0
	ret nz

	; c = 0 means the bag position: return -1 instead
	ld c, -1
	ret

BillsPC_Withdraw:
	ld b, 0
	jr MoveCurMonToBox

BillsPC_Deposit:
	ld a, [wCurBox]
	inc a
	ld b, a
	; fallthrough
MoveCurMonToBox:
	push bc
	call BillsPC_GetCursorSlot
	ld d, b
	ld e, c
	pop bc
	ld c, 0
	call BillsPC_SwapStorage
	ret nz ; failed

	; Movement animation
	ld c, a
	push de
	ld d, b
	ld e, c
	pop bc
	push bc
	call BillsPC_PerformQuickAnim
	pop bc
	; fallthrough
CheckPartyShift:
; Shifts party icons up so there are no blank party entries. Purely visual:
; the storage code already compacted the party.
	xor a
	ld e, a
	ld d, a
	ld b, a
.outer_loop
	ld a, e
	inc e
	cp PARTY_LENGTH - 1
	ret z
	call .CheckBlankIcon
	jr nz, .outer_loop
	ld c, e
.inner_loop
	ld a, c
	inc c
	cp PARTY_LENGTH
	ret z
	call .CheckBlankIcon
	jr z, .inner_loop

	; Found an icon to move up
	push de
	push bc
	call BillsPC_PerformQuickAnim
	pop bc
	pop de
	jr .outer_loop

.CheckBlankIcon:
; z if party list entry a (0-based) is empty
	add a
	add LOW(wBillsPC_PartyList)
	ld l, a
	adc HIGH(wBillsPC_PartyList)
	sub l
	ld h, a
	ld a, [hl]
	and a
	ret

GetCursorMon:
; Prints data about the Pokémon under the cursor if nothing is held
; (_GetCursorMon forces it). Returns z if the cursor is on an empty slot.
	; Only handle box arrows if we're holding a mon
	call BillsPC_GetCursorHeldSlot
	bit 7, b
	jr nz, _GetCursorMon
	inc c
	dec c
	jr z, _GetCursorMon

	call BillsPC_UpdateCursorLocation
	; fallthrough
BillsPC_SetBoxArrows:
	ld a, [wBillsPC_CursorPos]
	cp $10
	jr c, .box_cursors

	; Clear box switch arrows
	ld a, " "
	hlcoord 8, 5
	ld [hl], a
	hlcoord 18, 5
	ld [hl], a
	xor a
	ret

.box_cursors
	hlcoord 8, 5
	ld [hl], "◀"
	hlcoord 18, 5
	ld [hl], "▶"
	ret

_GetCursorMon:
	call BillsPC_UpdateCursorLocation

	; Is the cursor hovering a mon?
	call BillsPC_GetCursorSlot
	jr c, .clear
	ld a, c
	inc a
	or b
	jr z, .clear

	farcall GetStorageBoxMon
	jr nz, .not_clear
	ld a, -1
	ld [wVirtualOAMSprite30], a
	; fallthrough
.clear
	; Clear nickname + species + icon. Leave the 3rd row (held item) alone.
	hlcoord 7, 0
	lb bc, 2, 13
	call ClearBox
	hlcoord 7, 3
	lb bc, 1, 13
	call ClearBox

	; Clear pokepic + level/gender
	hlcoord 0, 0
	lb bc, 9, 7
	call ClearBox
	call BillsPC_SetBoxArrows
	ld a, [wBillsPC_CursorPos]
	cp $10
	jr c, .reset_item
	cp $21
	jr z, .reset_item
	xor a
	ret
.reset_item
	ld a, -1
	ld [wVirtualOAMSprite30], a
	or 1
	ret

.not_clear
	; Frontpic: decompress and pad first, copy later, so the picture and its
	; palette land in the same frame.
	ld a, [wTempMonIsEgg]
	and a
	ld a, EGG
	jr nz, .got_species
	ld a, [wTempMonSpecies]
	cp UNOWN
	jr nz, .got_species
	push af
	ld hl, wTempMonDVs
	predef GetUnownLetter
	pop af
.got_species
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ldh a, [rSVBK]
	push af
	farcall PrepareFrontpicInScratch
	pop af
	ldh [rSVBK], a

	; Item name of the hovered mon (unless the cursor is holding it)
	ld a, "@"
	ld [wStringBuffer2], a
	call GetMonItemUnlessCursor
	jr z, .got_item_name
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
	ld bc, ITEM_NAME_LENGTH
	call CopyBytes
.got_item_name

	; Copy the frontpic to the VRAM bank the attribute map isn't using, so the
	; switch happens atomically with the attribute update.
	xor a
	ldh [hBGMapMode], a
	ld a, [wAttrMap]
	and VRAM_BANK_1
	push af
	ld a, 0
	jr nz, .dont_switch_vbk
	inc a
.dont_switch_vbk
	ldh [rVBK], a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld hl, vTiles2 tile PCTILE_FRONTPIC
	ld de, wDecompressScratch + $800
	ld c, 7 * 7
	call BillsPC_DMACopy
	pop af
	ldh [rSVBK], a

	; Hovered item icon tile (sprite 30)
	ld a, 1
	ldh [rVBK], a
	call GetMonItemUnlessCursor
	push af
	ld de, vTiles3 tile PCTILE_BLANK ; no item
	jr z, .got_item_tile
	call BillsPC_GetItemIconOffset
	ld hl, vTiles3 tile PCTILE_ITEM_ICONS
	add hl, de
	ld d, h
	ld e, l
.got_item_tile
	ld hl, vTiles3 tile PCTILE_HOVER_ITEM
	ldh a, [hROMBank]
	ld b, a
	ld c, 1
	call BillsPC_SafeGet2bpp
	xor a
	ldh [rVBK], a
	inc a
	ldh [hBGMapMode], a ; VRAM bank 0 again: let VBlank push the tilemap

	pop af ; item (flags)
	pop af ; old frontpic bank flag
	ld a, PAL_PC_POKEPIC
	jr nz, .got_new_tile_bank
	ld a, PAL_PC_POKEPIC | VRAM_BANK_1
.got_new_tile_bank
	hlcoord 0, 0, wAttrMap
	lb bc, 7, 7
	call BillsPC_FillBoxWithByte

	; Frontpic colors into the HBlank list (row 0, palette 2)
	ld a, [wTempMonIsEgg]
	and a
	ld hl, EGG
	jr nz, .got_pal_index
	ld a, [wTempMonSpecies]
	call GetPokemonIndexFromID
.got_pal_index
	ld d, h
	ld e, l
	ld a, [wTempMonUnused]
	and MON_SHINY_FLAG
	jr z, .not_shiny_pal
	set 6, d
.not_shiny_pal
	res 7, d
	ld a, [wTempMonIsEgg]
	and a
	jr z, .pal_ok
	set 7, d
.pal_ok
	ld hl, wBillsPC_PokepicPal
	call BillsPC_WriteSpeciesPalette

	; Show or hide the item icon sprite
	ld hl, wVirtualOAMSprite30
	call GetMonItemUnlessCursor
	ld [hl], -1
	jr z, .item_icon_done
	ld a, 3 * 8 + 16 ; y: row 3
	ld [hli], a
	ld a, 7 * 8 + 8 ; x: column 7
	ld [hli], a
	ld a, PCTILE_HOVER_ITEM
	ld [hli], a
	ld [hl], VRAM_BANK_1 | PAL_PC_PACK
.item_icon_done

	; Push the attribute map (frontpic bank) together with the palettes
	call BillsPC_SetPals
	call BillsPC_CopyTilemapAtOnce

	; Clear text
	call .clear

	; Frontpic tilemap
	hlcoord 0, 0
	call BillsPC_PlaceFrontpic

	; Nickname
	hlcoord 8, 0
	ld de, wTempMonNickname
	call PlaceString

	; Eggs show nothing else
	ld a, [wTempMonIsEgg]
	and a
	jr z, .not_egg_text
	call BillsPC_PlaceItemName
	jr .ret_nz
.not_egg_text

	; Species name
	ld a, [wTempMonSpecies]
	ld [wNamedObjectIndexBuffer], a
	hlcoord 8, 1
	ld a, "/"
	ld [hli], a
	call GetPokemonName
	ld de, wStringBuffer1
	call PlaceString

	; Level
	hlcoord 0, 8
	call PrintLevel

	; Gender
	ld a, TEMPMON
	ld [wMonType], a
	farcall GetGender
	hlcoord 4, 8
	jr c, .genderless
	ld a, PCTILE_MALE
	jr nz, .male
	ld a, PCTILE_FEMALE
.male
	ld [hl], a
.genderless

	; Shiny
	inc hl
	ld a, [wTempMonUnused]
	and MON_SHINY_FLAG
	jr z, .not_shiny
	ld [hl], PCTILE_SHINY
.not_shiny
	; Pokérus: high nybble = strain, low nybble = days left (0 = cured)
	ld a, [wTempMonPokerusStatus]
	and a
	inc hl
	jr z, .did_pokerus
	ld [hl], PCTILE_POKERUS_CURED
	and $0f
	jr z, .did_pokerus
	ld [hl], PCTILE_POKERUS
.did_pokerus

	call BillsPC_PlaceItemName
.ret_nz
	or 1
	ret

BillsPC_PlaceItemName:
; Prints wStringBuffer2 (the hovered mon's item name, "@" if none) at (8, 3).
	hlcoord 8, 3
	ld de, wStringBuffer2
	jp PlaceString

BillsPC_PlaceCursorItemName:
; Prints the name of the item the cursor is holding at (8, 2).
	hlcoord 8, 2
	ld bc, 12
	ld a, " "
	call ByteFill
	ld a, [wBillsPC_CursorItem]
	and a
	ret z
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	hlcoord 8, 2
	ld de, wStringBuffer1
	jp PlaceString

BillsPC_PlaceFrontpic:
; Writes the 7x7 frontpic tilemap (tiles 0-48, column-major) at hl.
	xor a
	ld c, 7
.col
	push hl
	ld b, 7
.row
	ld [hl], a
	inc a
	push bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	pop hl
	inc hl
	dec c
	jr nz, .col
	ret

BillsPC_CopyTilemapAtOnce:
; Pushes wTileMap and wAttrMap to VRAM in a single VBlank with two
; general-purpose DMAs (attributes, then tiles), so the HBlank palette code
; keeps running: CopyTilemapAtOnce disables interrupts for over a frame.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wScratchTileMap)
	ldh [rSVBK], a
	hlcoord 0, 0, wAttrMap
	ld de, wScratchAttrMap
	call .Pad
	hlcoord 0, 0
	ld de, wScratchTileMap
	call .Pad
	; transfer 1: tiles into bank 0; transfer 2 (same VBlank): the attribute
	; map from wScratchAttrMap into bank 1
	xor a
	ldh [rVBK], a
	ld a, HIGH(wScratchTileMap)
	ldh [rHDMA1], a
	ld a, LOW(wScratchTileMap)
	ldh [rHDMA2], a
	ldh a, [hBGMapAddress + 1]
	and $1f
	ldh [rHDMA3], a
	ldh a, [hBGMapAddress]
	ldh [rHDMA4], a
	ld a, (BG_MAP_WIDTH * SCREEN_HEIGHT) / 16 - 1
	ldh [hDMATransfer2], a
	ldh [hDMATransfer], a
.wait
	call DelayFrame
	ldh a, [hDMATransfer]
	and a
	jr nz, .wait
	pop af
	ldh [rSVBK], a
	ret

.Pad:
; 20x18 map at hl -> 32-wide rows at de
	ld c, SCREEN_HEIGHT
.row
	ld b, SCREEN_WIDTH
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .col
	ld a, e
	add BG_MAP_WIDTH - SCREEN_WIDTH
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	dec c
	jr nz, .row
	ret

; Textboxes and menus over the PC screen: the engine only pushes tiles
; (hBGMapMode 1), so every attribute change is pushed here explicitly.

BillsPC_MenuTextbox:
; hl = text. MenuTextbox with the textbox attributes pushed before printing.
	push hl
	call LoadMenuTextbox
	pop hl
	; fallthrough
BillsPC_PrintTextbox:
; hl = text. Draws the speech textbox, pushes it, then prints.
	push hl
	call SpeechTextbox
	call BillsPC_CopyTilemapAtOnce
	pop hl
	jp PrintText

BillsPC_YesNoBox:
; YesNoBox (carry = NO) with the box pushed before the menu runs.
	ld a, 1
	jr BillsPC_TwoOptionBox

BillsPC_NoYesBox:
; YesNoBox with the cursor starting on NO. Returns carry for NO.
	ld a, 2
	; fallthrough
BillsPC_TwoOptionBox:
	push af
	ld hl, YesNoMenuHeader
	call CopyMenuHeader
	ld a, SCREEN_WIDTH - 6
	ld [wMenuBorderLeftCoord], a
	add 5
	ld [wMenuBorderRightCoord], a
	ld a, 7
	ld [wMenuBorderTopCoord], a
	add 4
	ld [wMenuBorderBottomCoord], a
	pop af
	ld [wMenuCursorBuffer], a
	call PushWindow
	call MenuBox
	call BillsPC_CopyTilemapAtOnce
	call VerticalMenu
	push af
	ld c, $f
	call DelayFrames
	call BillsPC_CloseWindow
	pop af
	jr c, .no
	ld a, [wMenuCursorY]
	cp 2 ; no
	jr z, .no
	and a
	ret
.no
	ld a, 2
	ld [wMenuCursorY], a
	scf
	ret

BillsPC_CloseWindow:
; CloseWindow: restores the tiles and attributes under the window and
; pushes both at once.
	push af
	call ExitMenu
	call BillsPC_CopyTilemapAtOnce
	ld a, 1
	ldh [hBGMapMode], a
	pop af
	ret

BillsPC_GetItemIconOffset:
; a = item -> de = tile offset of its category icon (a preserved).
	ld d, 0
	push af
	ld c, a
	farcall_a StorageItemIsMail ; a = item, carry if mail
	ld e, HELDTYPE_MAIL tiles
	jr c, .done
	; held effect
	ld hl, ItemAttributes + ITEMATTR_EFFECT
	ld a, c
	dec a
	ld b, 0
	ld c, a
	ld a, ITEMATTR_STRUCT_LENGTH
	call AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarByte
	ld e, HELDTYPE_INERT_ITEM tiles
	and a
	jr z, .done
	ld e, HELDTYPE_ITEM tiles
	cp HELD_LEFTOVERS
	jr z, .done
	cp HELD_CLEANSE_TAG
	jr z, .done
	cp HELD_HEAL_CONFUSION + 1
	jr nc, .done
	ld e, HELDTYPE_BERRY tiles
.done
	pop af
	ret

BillsPC_CheckBagDisplay:
; Returns z if the bag should be shown: always when the cursor hovers it.
	ld a, [wBillsPC_CursorPos]
	cp $21
	ret z
	; fallthrough
_BillsPC_CheckBagDisplay:
	call BillsPC_IsHoldingItem
	jr z, .check_cursor_mode
	xor a
	ret

.check_cursor_mode
	; Always in item mode
	ld a, [wBillsPC_CursorMode]
	cp PC_ITEM_MODE
	ret

; ---------------------------------------------------------------------------
; Main loop
; ---------------------------------------------------------------------------

ManageBoxes:
.loop
	call BillsPC_UpdateCursorLocation
	call DelayFrame
	call JoyTextDelay
.redo_input
	ldh a, [hJoyPressed]
	rrca
	jr c, .pressed_a
	rrca
	jr c, .pressed_b
	rrca
	jp c, .pressed_select
	rrca
	jp c, .pressed_start
	rrca
	jp c, .pressed_right
	rrca
	jp c, .pressed_left
	rrca
	jp c, .pressed_up
	rrca
	jp c, .pressed_down
	jr .loop
.pressed_a
	; Holding something: try to place it here
	ld a, [wBillsPC_CursorHeldSlot]
	and a
	jr z, .nothing_held_a
	call BillsPC_PlaceHeldMon
	jr .loop

.nothing_held_a
	; Empty slot?
	call GetCursorMon
	jr z, .loop

	; In item mode a mon must hold an item to be selected
	ld a, [wBillsPC_CursorMode]
	cp PC_ITEM_MODE
	jr nz, .confirm_ok
	ld a, [wBillsPC_CursorPos]
	cp $10 ; box name
	jr c, .confirm_ok
	cp $21 ; bag
	jr z, .confirm_ok
	ld a, [wTempMonItem]
	and a
	jr z, .loop

.confirm_ok
	ld de, SFX_READ_TEXT_2
	call PlaySFX

	; Box name?
	ld a, [wBillsPC_CursorPos]
	cp $10
	ld hl, .BoxMenu
	jr c, .got_menu

	; Menu mode opens a menu
	ld a, [wBillsPC_CursorMode]
	and a ; PC_MENU_MODE?
	jr z, .prepare_menu

	; Swap mode picks the mon up, item mode picks up the item
	dec a
	push af
	call z, BillsPC_Switch
	pop af
	call nz, BillsPC_MoveItem
	jr .loop

.prepare_menu
	ld a, [wBillsPC_CursorPos]
	and $f
	cp $2
	ld hl, .PartyMonMenu
	jr c, .got_menu

	call BillsPC_HideCursor
	ld hl, .StorageMonMenu
.got_menu
	ld b, 1
	call BillsPC_Menu
	jp .loop

.pressed_b
	; Holding something: put it back
	ld a, [wBillsPC_CursorHeldSlot]
	and a
	jr z, .nothing_held_b
	call BillsPC_AbortSelection
	jp .loop

.nothing_held_b
	call BillsPC_HideCursorAndMode
	ld hl, .ContinueBoxUse
	call BillsPC_MenuTextbox
	call BillsPC_YesNoBox
	push af
	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow
	pop af
	ret c
	jp .loop

.pressed_select
	; No mode switch on the pack
	ld a, [wBillsPC_CursorPos]
	cp $21
	jp z, .loop

	; No switch from/to item mode while holding something
	ld a, [wBillsPC_CursorHeldSlot]
	and a
	ld a, [wBillsPC_CursorMode]
	jr z, .not_holding_anything
	cp PC_ITEM_MODE
	jp z, .loop
	xor PC_MENU_MODE ^ PC_SWAP_MODE
	jr .got_new_mode
.not_holding_anything
	inc a
	cp NUM_PC_MODES
	jr nz, .got_new_mode
	xor a ; PC_MENU_MODE
.got_new_mode
	call BillsPC_SetCursorMode
	jp .loop

.pressed_right
	ld a, [wBillsPC_CursorPos]
	cp $10
	jr nc, .regular_right
	ld a, [wCurBox]
	inc a
	jr .new_box

.regular_right
	inc a ; CursorPosValid wraps column 6+
	and ~$8
	jr .new_cursor_pos

.pressed_left
	ld a, [wBillsPC_CursorPos]
	cp $10
	jr nc, .regular_left
	ld a, [wCurBox]
	add NUM_BOXES - 1
	; fallthrough
.new_box
	cp NUM_BOXES
	jr c, .valid_box
	sub NUM_BOXES
.valid_box
	call BillsPC_ChangeBox
	jp .loop

.regular_left
	or $8
	dec a
	and ~$8
	jr .new_cursor_pos

.pressed_start
	; Jump to the box name
	ld a, [wBillsPC_CursorPos]
	and $f
	cp 2
	jr nc, .new_cursor_pos
	ld a, 2
	jr .new_cursor_pos

.pressed_up
	ld a, [wBillsPC_CursorPos]
	sub $10
	jr .new_cursor_pos
.pressed_down
	ld a, [wBillsPC_CursorPos]
	add $10
	; fallthrough
.new_cursor_pos
	ld [wBillsPC_CursorPos], a
	call BillsPC_CursorPosValid
	jp nz, .redo_input
	call GetCursorMon
	jp .loop

.ContinueBoxUse:
	text "Continue Box"
	line "operations?"
	done

.StorageMonMenu:
	db MENU_BACKUP_TILES
	menu_coords 9, 4, 19, 17
	dw .StorageMenuData
	db 1 ; default option

.StorageMenuData:
	db STATICMENU_WRAP ; flags
	db 0 ; items
	dw .storageitems
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.PartyMonMenu:
	db MENU_BACKUP_TILES
	menu_coords 10, 4, 19, 17
	dw .PartyMenuData
	db 1 ; default option

.PartyMenuData:
	db STATICMENU_WRAP ; flags
	db 0 ; items
	dw .partyitems
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.BoxMenu:
	db MENU_BACKUP_TILES
	menu_coords 10, 6, 19, 17
	dw .BoxMenuData
	db 1 ; default option

.BoxMenuData:
	db STATICMENU_WRAP ; flags
	db 0 ; items
	dw .boxitems
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.storageitems
	db 6
	db BOXMENU_WITHDRAW
	db BOXMENU_STATS
	db BOXMENU_SWITCH
	db BOXMENU_ITEM
	db BOXMENU_RELEASE
	db BOXMENU_CANCEL
	db -1

.partyitems
	db 6
	db BOXMENU_DEPOSIT
	db BOXMENU_STATS
	db BOXMENU_SWITCH
	db BOXMENU_ITEM
	db BOXMENU_RELEASE
	db BOXMENU_CANCEL
	db -1

.boxitems
	db 5
	db BOXMENU_CHANGE
	db BOXMENU_RENAME
	db BOXMENU_THEME
	db BOXMENU_RELEASEALL
	db BOXMENU_CANCEL
	db -1

BillsPC_MenuStrings:
	db "CANCEL@"
	; Pokémon options
	db "WITHDRAW@"
	db "DEPOSIT@"
	db "SUMMARY@"
	db "SWITCH@"
	db "ITEM@"
	db "RELEASE@"
	; box options
	db "CHANGE@"
	db "RENAME@"
	db "THEME@"
	db "RELEASE@"
	; holding Mail
	db "TAKE@"
	db "READ@"
	; holding an item
	db "MOVE@"
	db "BAG@"
	; no item
	db "GIVE@"

BillsPC_MenuJumptable:
	dw BillsPC_DoNothing
	dw BillsPC_Withdraw
	dw BillsPC_Deposit
	dw BillsPC_Stats
	dw BillsPC_Switch
	dw BillsPC_Item
	dw BillsPC_Release
	dw BillsPC_Change
	dw BillsPC_Rename
	dw BillsPC_Theme
	dw BillsPC_ReleaseAll
	dw BillsPC_TakeMail
	dw BillsPC_ReadMail
	dw BillsPC_MoveItem
	dw BillsPC_BagItem
	dw BillsPC_GiveItem

BillsPC_DoNothing:
	ret

BillsPC_Stats:
	call BillsPC_PrepareTransition
	ld a, TEMPMON
	ld [wMonType], a
	call BillsPC_TempMonToBuffer
	xor a
	ld [wCurPartyMon], a
	predef StatsScreenInit
	call BillsPC_MoveCursorAfterStatScreen
	jp BillsPC_ReturnFromTransition

StatsScreenDPad::
; Called by the stats screen (wMonType = TEMPMON) on every joypad poll.
; Up/down step through the party or box (wTempMonBox/Slot); the stats screen
; reloads from wBufferMon when wMenuJoypad has a D-pad bit set.
	ldh a, [hJoyPressed]
	ld [wMenuJoypad], a
	and D_UP | D_DOWN
	ret z
	cp D_UP
	jr z, .prev
	farcall NextStorageBoxMon
	jr .check
.prev
	farcall PrevStorageBoxMon
.check
	jr nz, BillsPC_TempMonToBuffer
	; nothing there: swallow the input
	xor a
	ld [wMenuJoypad], a
	ret

BillsPC_TempMonToBuffer:
; Copies wTempMon (+ nickname/OT) to wBufferMon for the stats screen.
	ld hl, wTempMon
	ld de, wBufferMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	ld hl, wTempMonNickname
	ld de, wBufferMonNick
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld hl, wTempMonOT
	ld de, wBufferMonOT
	ld bc, NAME_LENGTH
	jp CopyBytes

BillsPC_MoveCursorAfterStatScreen:
; Moves the cursor to wTempMonBox/wTempMonSlot (the summary can scroll).
	ld a, [wTempMonBox]
	and a
	push af
	ld c, 4 ; box columns
	jr nz, .got_divisor
	ld c, 2 ; party columns
.got_divisor
	ld a, [wTempMonSlot]
	dec a
	call SimpleDivide ; b = quotient, a = remainder
	swap b
	add b
	ld b, a
	pop af
	ld a, $12 ; box baseline y, x
	jr nz, .got_baseline
	ld a, $30 ; party baseline y, x
.got_baseline
	add b
	ld [wBillsPC_CursorPos], a
	ret

BillsPC_CursorPick1:
; First half of the pickup animation: the cursor moves down onto the icon.
	ld hl, wBillsPC_CursorAnimFlag
	ld a, [hl]
	cp PCANIM_ANIMATE / 2 + 1
	ld a, PCANIM_PICKUP + 1
	sbc 0
	ld [hl], a
.pick_loop
	call BillsPC_UpdateCursorLocation
	call DelayFrame
	ld a, [hl]
	cp PCANIM_PICKUP_NEXT
	ret z
	inc [hl]
	jr .pick_loop

BillsPC_CursorPick2:
; Second half: the cursor lifts back up. Ends at the regular bop; write
; PCANIM_STATIC to [hl] afterwards to freeze it.
	ld hl, wBillsPC_CursorAnimFlag
	jr .start_loop
.pick_loop2
	call BillsPC_UpdateCursorLocation
	call DelayFrame
.start_loop
	dec [hl]
	ld a, [hl]
	cp PCANIM_PICKUP
	jr nc, .pick_loop2
	ret ; [hl] is now PCANIM_ANIMATE

BillsPC_MoveIconData:
; Copies icon data (palette, species entry, tiles) from slot bc to slot de,
; then blanks slot bc. Box -1 is a sentinel for the held (slot 0) or quick
; (slot 1) sprite tiles. de = -1/-1 only blanks bc.
	xor a
	ldh [hBGMapMode], a

	; Palette data
	xor a
	call .Copy

	ld a, 1
	ldh [rVBK], a

	; Held items are handled separately from here
	call BillsPC_IsHoldingItem
	jr z, .not_holding_item

	; Loading or unloading the quick icon?
	ld a, [wBillsPC_QuickFrames]
	and a
	ld de, vTiles3 tile PCTILE_BLANK
	jr z, .got_item_tile
	cp PCANIM_QUICKFRAMES - 1
	jr nz, .quick_ok
	ld a, b
	inc a
	ld de, vTiles3 tile PCTILE_HOVER_ITEM ; item of the hovered mon
	jr nz, .got_item_tile
	ld de, vTiles3 tile PCTILE_HELD_MINI ; item the cursor holds
.got_item_tile
	; VRAM -> VRAM: stage through WRAM (DMA can't read VRAM)
	push bc
	call BillsPC_CopyVRAMTileToScratch
	ld hl, vTiles3 tile PCTILE_QUICK_MINI
	ld c, 1
	call BillsPC_DMAFromScratch
	call BillsPC_SetPals
	pop bc

.quick_ok
	; Blank the cursor tile?
	inc b
	ld a, c
	or b
	ld hl, vTiles3 tile PCTILE_HELD_MINI
	ld a, 1
	call z, BillsPC_BlankTiles
	jr .done

.not_holding_item
	; Species entry
	ld a, 1
	call .Copy

	; Load the new icon unless we're only blanking
	ld a, d
	and e
	inc a
	jr z, .blank_old

	push bc
	push de
	ld b, d
	ld c, e
	ld a, 1
	call .GetAddr ; hl = species entry of the destination
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l ; de = encoded species
	pop bc ; destination slot
	push bc
	push de
	call BillsPC_SetPals ; commit the copied palette (clobbers bc, de, hl)
	pop de
	pop bc
	inc b
	jr z, .to_held
	dec b
	call BillsPC_LoadIconForSlot
	jr .loaded
.to_held
	; held (c = 0) or quick (c = 1) sprite tiles
	ld a, c
	call BillsPC_LoadHeldIcon
.loaded
	pop bc

.blank_old
	; Blank the old icon's species entry and tiles
	ld a, 1
	call .GetAddr
	xor a
	ld [hli], a
	ld [hli], a
	inc b
	dec b
	jr z, .blank_party_or_box
	ld a, b
	inc a
	jr nz, .blank_party_or_box
	; held/quick: blank 2x4 tiles to include the mask
	ld a, 2
	call .GetAddr
	ld a, 2
	call BillsPC_BlankTiles
	jr .done
.blank_party_or_box
	ld a, 2
	call .GetAddr
	ld a, 1
	call BillsPC_BlankTiles

.done
	xor a
	ldh [rVBK], a
	inc a
	ldh [hBGMapMode], a
	ret

.Copy:
; Copies data type a (0 = palette, 1 = species entry) from slot bc to slot de.
	; Blanking only?
	push af
	ld a, d
	and e
	inc a
	jr nz, .not_blanking
	pop af
	ret

.not_blanking
	pop af
	call .GetAddr ; hl = source (a and bc preserved)
	push bc
	push de
	push hl
	ld b, d
	ld c, e
	call .GetAddr ; hl = destination
	ld d, h
	ld e, l
	pop hl
	and a
	ld bc, 2
	jr nz, .got_len

	call BillsPC_IsHoldingItem
	ld c, 4
	jr z, .got_len

	; Holding an item: the quick sprite borrows the item icon palette
	ld hl, wOBPals1 palette 0 + 2
	ld de, wOBPals1 palette PAL_PC_QUICK + 2
.got_len
	call .CopyBankAware
	pop de
	pop bc
	ret

.CopyBankAware:
; Copies bc bytes hl -> de; object palettes live in WRAM bank 5.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	call CopyBytes
	pop af
	ldh [rSVBK], a
	ret

.GetAddr:
; hl = address of data type a (0 = palette, 1 = species entry, 2 = tiles)
; for box b slot c. Preserves a, bc and de.
	push de
	push bc
	push af
	inc b
	jr z, .held
	dec b
	jr z, .party

	; Box
	and a
	jr z, .box_party_pal
	dec a
	jr z, .box_extspecies

	; Box tiles
	ld hl, vTiles4 tile (PCTILE_BOX_MINIS - $80)
	jr .get_tile_addr

.box_extspecies
	ld hl, wBillsPC_BoxList
	jr .get_ext_addr

.party
	and a
	jr z, .box_party_pal
	dec a
	jr z, .party_extspecies

	; Party tiles
	ld hl, vTiles4 tile (PCTILE_PARTY_MINIS - $80)
	; fallthrough
.get_tile_addr
	ld b, 4 tiles
	jr .addntimes

.box_party_pal
	call BillsPC_GetMonPalAddr
	jr .got_addr

.party_extspecies
	ld hl, wBillsPC_PartyList
	; fallthrough
.get_ext_addr
	ld b, 2
	; fallthrough
.addntimes
	ld a, c
	ld c, b
	ld b, 0
	dec a
	call AddNTimes
	jr .got_addr

.held
	and a
	jr z, .held_pal
	dec a
	jr z, .held_extspecies

	; Held tiles
	ld hl, vTiles3 tile PCTILE_QUICK_MINI
	dec c
	jr z, .got_addr
	ld hl, vTiles3 tile PCTILE_HELD_MINI
	jr .got_addr

.held_pal
	ld hl, wOBPals1 palette PAL_PC_QUICK + 2
	dec c
	jr z, .got_addr
	ld hl, wOBPals1 palette PAL_PC_MINI_ICON + 2
	jr .got_addr

.held_extspecies
	ld hl, wBillsPC_QuickIcon
	dec c
	jr z, .got_addr
	ld hl, wBillsPC_HeldIcon
	; fallthrough
.got_addr
	pop af
	pop bc
	pop de
	ret

BillsPC_CopyVRAMTileToScratch:
; Copies one tile from VRAM de (bank 1, LCD on: waits for VBlank) to
; wDecompressScratch.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld hl, wDecompressScratch
	ld c, LEN_2BPP_TILE
.wait
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .wait
	cp LY_VBLANK + 8 ; leave room for the copy before the frame restarts
	jr nc, .wait
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

; ---------------------------------------------------------------------------
; Picking up and moving
; ---------------------------------------------------------------------------

BillsPC_Switch:
; Pick up the hovered mon.
	call BillsPC_GetCursorSlot
	ld a, b
	ld [wBillsPC_CursorHeldBox], a
	ld a, c
	ld [wBillsPC_CursorHeldSlot], a

	push bc
	call BillsPC_CursorPick1
	pop bc

	; Move the icon (tiles + palette) to the cursor
	lb de, -1, 0
	call BillsPC_MoveIconData

	call BillsPC_CursorPick2
	ld [hl], PCANIM_STATIC
	ret

BillsPC_PrepareQuickAnim:
; Sets up a quick-move animation from bc to de.
	ld hl, wBillsPC_QuickFrom
	push bc
	push de
	call .SetQuickStruct
	pop bc
	ld hl, wBillsPC_QuickTo
	call .SetQuickStruct
	ld a, PCANIM_QUICKFRAMES
	ld [wBillsPC_QuickFrames], a

	lb de, 0, 0
	ld a, SPRITE_ANIM_INDEX_PC_QUICK
	call _InitSpriteAnimStruct

	call BillsPC_UpdateCursorLocation
	pop bc
	lb de, -1, 1
	jp BillsPC_MoveIconData

.SetQuickStruct:
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	push bc
	call BillsPC_GetXYFromStorageBox
	pop bc

	; Items sit slightly offset; the cursor slot uses a different y offset
	inc b
	ld b, 0
	jr nz, .not_cursor
	ld b, 2
.not_cursor
	call BillsPC_IsHoldingItem
	ld c, 4
	jr nz, .got_offset
	lb bc, 0, 0
.got_offset
	ld a, d
	add c
	ld [hli], a
	ld a, e
	add b
	add c
	ld [hli], a
	ret

BillsPC_GetXYFromStorageBox:
; Returns the icon position of box b slot c in de (d = x, e = y), including
; the +8 sprite offset. Box -1 means held by the cursor.
	inc b
	jr nz, .not_cursor

	; Held mons hover a bit above the cursor slot
	dec b
	push bc
	call BillsPC_GetCursorSlot
	call BillsPC_GetXYFromStorageBox
	pop bc
	ld a, e
	sub PCANIM_PICKUP_NEXT - PCANIM_PICKUP + 1
	ld e, a
	ret

.not_cursor
	res 7, b
	dec b
	jr z, .party
	ld a, c
	and a
	jr nz, .not_on_boxname
	; fallthrough
.boxname_pos
	lb de, $6c, $38
	ret

.not_on_boxname
	; Slots in other boxes animate towards the box name
	ld a, [wCurBox]
	inc a
	cp b
	jr nz, .boxname_pos

	ld a, 4
	lb de, $48, $48
	jr .fix_xy

.party
	ld a, c
	inc a
	lb de, $30, $58 ; bag
	ret z
	ld a, 2
	lb de, $10, $68
	; fallthrough
.fix_xy
	; Every a slots, y moves by 16; the remainder moves x by 24
	push bc
	ld b, a
	ld a, c
	dec a
.loop
	sub b
	jr c, .got_y
	push af
	ld a, e
	add 16
	ld e, a
	pop af
	jr .loop
.got_y
	add b

	; remainder * 24
	add a
	add a
	add a
	ld b, a
	add b
	add b
	add d
	ld d, a
	pop bc
	ret

BillsPC_PerformQuickAnim:
; Synchronous quick-move animation (used when aborting a selection or when
; shifting the party; otherwise it runs asynchronously).
	call BillsPC_PrepareQuickAnim
.loop
	call BillsPC_UpdateCursorLocation
	call DelayFrame
	ld a, [wBillsPC_QuickFrames]
	and a
	jr nz, .loop
	jp BillsPC_UpdateCursorLocation

BillsPC_FinishQuickAnim::
; Called from the quick-move animseq when the animation ends.
	push hl
	push de
	push bc

	; Only land the icon if the destination is the party or the current box;
	; otherwise just vanish the sprite.
	ld a, [wBillsPC_QuickToSlot]
	ld e, a
	ld a, [wBillsPC_QuickToBox]
	ld d, a
	and a
	jr z, .ok
	ld a, [wCurBox]
	inc a
	cp d
.ok
	lb bc, -1, 1
	call z, BillsPC_MoveIconData

	; Blank the quick icon (MoveIconData may have done it already)
	ldh a, [rVBK]
	ld b, a
	ldh a, [hBGMapMode]
	ld c, a
	push bc
	xor a
	ldh [hBGMapMode], a
	inc a
	ldh [rVBK], a
	ld hl, vTiles3 tile PCTILE_QUICK_MINI
	ld a, 2
	call BillsPC_BlankTiles
	pop bc
	ld a, b
	ldh [rVBK], a
	ld a, c
	ldh [hBGMapMode], a
	pop bc
	pop de
	pop hl
	ret

BillsPC_AbortSelection:
; Puts the held mon/item back where it came from.
	ld a, 1
	ldh [rVBK], a

	; Items don't need their tiles reloaded
	call BillsPC_GetCursorHeldSlot
	bit 7, b
	push bc
	call nz, BillsPC_BlankCursorItem
	pop bc

	; Return the icon if it belongs to the party or the current box
	ld d, b
	ld e, c
	lb bc, -1, 0
	call BillsPC_PerformQuickAnim

	xor a
	ld [wBillsPC_CursorHeldBox], a
	ld [wBillsPC_CursorHeldSlot], a

	; The bag icon might vanish from under the cursor
	call BillsPC_MaybeMoveCursor
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a

	xor a
	ldh [rVBK], a
	jp GetCursorMon

BillsPC_MaybeMoveCursor:
; If the cursor is on the bag and the bag is gone, move it. z if moved.
	ld a, [wBillsPC_CursorPos]
	cp $21
	ret nz

	call _BillsPC_CheckBagDisplay
	jr nz, .move_cursor
	or 1
	ret

.move_cursor
	ld a, $31 ; right below it
	ld [wBillsPC_CursorPos], a
	xor a
	ret

BillsPC_PrepareTransition:
; Prepares for another screen: saves the tilemap, clears palettes and
; sprites and stops the HBlank palette code.
	call LoadStandardMenuHeader
	call BillsPC_DisableHBlank
	call ClearPalettes
.busyloop
	ldh a, [hCGBPalUpdate]
	and a
	jr nz, .busyloop
	jp ClearSprites

BillsPC_GetStorageSpace:
; Forces a game save until at least a free database records are left.
; Returns nz if the player refused (insufficient space).
	ld b, a
.loop
	ld a, b
	push bc
	farcall_a EnsureStorageSpace ; z if enough
	pop bc
	ret z

	push bc
	ld hl, BillsPC_MustSaveToContinue
	call BillsPC_MenuTextbox
	call BillsPC_YesNoBox
	push af
	jr c, .menutext_abort
	call BillsPC_ForceSave
	; fallthrough
.menutext_abort
	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow
	pop af
	pop bc
	jr nc, .loop
	or 1
	ret

BillsPC_ForceSave:
; Saves the game (with the usual "Saving…" / "saved the game" text and SFX).
	farcall ForceGameSave
	ret

BillsPC_GiveItem:
	; A box mon needs a free database record for the change
	call BillsPC_GetCursorSlot
	ld a, b
	and a
	jr z, .entries_not_full

	ld a, 1
	call BillsPC_GetStorageSpace
	ret nz

.entries_not_full
	call BillsPC_PrepareTransition
	call BillsPC_PickItemFromPack ; a = item, z if cancelled
	push af
	call BillsPC_ReturnFromTransition
	pop af
	ret z

	; Give the picked item (it's in wCurItem); bag quantity is adjusted by
	; BillsPC_SwapStorage's bag path, so emulate a bag -> mon move.
	ld a, [wCurItem]
	ld [wBillsPC_CursorItem], a
	ld a, $80
	ld [wBillsPC_CursorHeldBox], a
	ld a, -1
	ld [wBillsPC_CursorHeldSlot], a
	call BillsPC_GetCursorFromTo
	call BillsPC_SwapStorage
	xor a
	ld [wBillsPC_CursorHeldBox], a
	ld [wBillsPC_CursorHeldSlot], a
	ld [wBillsPC_CursorItem], a
	jp GetCursorMon

BillsPC_PickItemFromPack:
; Opens the pack in "pick an item" mode (same rules as the party menu's
; GIVE). Returns nz with the item in wCurItem, z if cancelled.
	farcall DepositSellInitPackBuffers
.loop
	farcall DepositSellPack
	ld a, [wPackUsedItem]
	and a
	ret z
	ld a, [wCurPocket]
	cp KEY_ITEM_POCKET
	jr z, .cant_hold
	call CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .cant_hold
	ld a, [wCurItem]
	and a
	ret

.cant_hold
	ld a, [wCurItem]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, .CantBeHeldText
	call MenuTextboxBackup
	jr .loop

.CantBeHeldText:
	; <ITEM> can't be held.
	text_far UnknownText_0x1c1c09
	text_end

BillsPC_ReturnFromTransition:
	call ExitMenu
	jp BillsPC_RestoreUI

GetMonItemUnlessCursor:
; Returns the hovered mon's item in a, unless the cursor is holding it (z).
	push de
	push bc
	call .do_it
	pop bc
	pop de
	ret z
	ld a, [wTempMonItem]
	and a
	ret

.do_it
	call BillsPC_GetCursorFromTo
	; d is $80 | b if the cursor holds an item from this very slot
	ld a, d
	sub b
	xor $80
	ret nz
	ld a, e
	sub c
	ret

BillsPC_BlankCursorItem:
; Removes the cursor's item icon and name. rVBK = 1 is fine.
	ld a, -1
	ld [wVirtualOAMSprite31], a
	hlcoord 8, 2
	ld bc, 12
	ld a, " "
	jp ByteFill

BillsPC_IsHoldingItem:
; Returns nz if the cursor holds an item.
	push bc
	call BillsPC_GetCursorHeldSlot
	bit 7, b
	pop bc
	ret

BillsPC_TakeMail:
; Takes the Mail from the party mon in wTempMonSlot. Returns carry if taken.
	ld a, [wTempMonSlot]
	dec a
	ld [wCurPartyMon], a
	call BillsPC_HideCursorAndMode
	call .TakeMail
	push af
	call GetCursorMon
	pop af
	ret

.TakeMail:
	ld hl, .SendMailToPCText
	call BillsPC_MenuTextbox
	call BillsPC_YesNoBox
	jr c, .remove_to_bag
	farcall SendMailToPC
	jr c, .mailbox_full
	ld hl, .SentMailToPCText
	call .PrintAndClose
	scf
	ret

.mailbox_full
	ld hl, .MailboxFullText
	jr .fail

.remove_to_bag
	ld hl, .MailWillLoseMessageText
	call BillsPC_MenuTextbox
	call BillsPC_YesNoBox
	jr c, .cancel
	ld a, [wTempMonItem]
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	jr nc, .bag_full
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld [hl], NO_ITEM
	ld hl, wTempMonNickname
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld hl, .TookMailFromMonText
	call .PrintAndClose
	scf
	ret

.bag_full
	ld hl, .BagFullText
.fail
	call .PrintAndClose
.cancel
	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow
	and a
	ret

.PrintAndClose:
	call PrintText
	call BillsPC_UpdateCursorLocation
	jp BillsPC_CloseWindow

.SendMailToPCText:
	; Send the removed MAIL to your PC?
	text_far UnknownText_0x1c1c86
	text_end

.SentMailToPCText:
	; The MAIL was sent to your PC.
	text_far UnknownText_0x1c1cc4
	text_end

.MailboxFullText:
	; Your PC's MAILBOX is full.
	text_far UnknownText_0x1c1ca9
	text_end

.MailWillLoseMessageText:
	; The MAIL will lose its message. OK?
	text_far UnknownText_0x1c1c22
	text_end

.TookMailFromMonText:
	; MAIL detached from <POKEMON>.
	text_far UnknownText_0x1c1c47
	text_end

.BagFullText:
	; There's no space for removing MAIL.
	text_far UnknownText_0x1c1c62
	text_end

BillsPC_ReadMail:
	ld a, [wTempMonSlot]
	dec a
	ld [wCurPartyMon], a
	call BillsPC_PrepareTransition
	farcall ReadPartyMonMail
	jp BillsPC_ReturnFromTransition

BillsPC_MoveItem:
; Pick up an item for movement.
	; On the pack?
	call BillsPC_GetCursorSlot
	ld a, c
	inc a
	or b
	jr nz, .not_on_pack

	call BillsPC_PrepareTransition
	call BillsPC_PickItemFromPack
	push af
	call BillsPC_ReturnFromTransition
	pop af
	ret z

	ld a, [wCurItem]
	ld [wBillsPC_CursorItem], a
	lb bc, 0, -1
	jr .got_cursor_item

.not_on_pack
	; Removing an item reallocates a box mon's record
	and b
	jr z, .entries_not_full

	ld a, 1
	push bc
	call BillsPC_GetStorageSpace
	pop bc
	ret nz

.entries_not_full
	farcall GetStorageBoxMon
	ld a, [wTempMonItem]
	ld [wBillsPC_CursorItem], a
	; fallthrough
.got_cursor_item
	ld a, b
	or $80 ; holding an item, not a mon
	ld [wBillsPC_CursorHeldBox], a
	ld a, c
	ld [wBillsPC_CursorHeldSlot], a

	push bc
	call BillsPC_CursorPick1
	pop bc

	ld a, 1
	ldh [rVBK], a
	dec a
	ldh [hBGMapMode], a

	; Held item marker sprite, name and icon
	call BillsPC_ShowCursorItem

	xor a
	ldh [rVBK], a
	inc a
	ldh [hBGMapMode], a

	call GetCursorMon

	call BillsPC_CursorPick2
	ld [hl], PCANIM_STATIC
	ret

BillsPC_ShowCursorItem:
; Shows the marker sprite, the name and the icon of the item the cursor
; holds. rVBK = 1.
	ld hl, wVirtualOAMSprite31
	ld a, 2 * 8 + 16
	ld [hli], a
	ld a, 7 * 8 + 8
	ld [hli], a
	ld a, PCTILE_CURSOR + 2
	ld [hli], a
	ld [hl], VRAM_BANK_1 | PAL_PC_CURSOR_MODE2
	call BillsPC_PlaceCursorItemName
	; fallthrough
BillsPC_LoadCursorItemIcon:
; Loads the held item's category icon into the cursor's mini tile. rVBK = 1.
	ld a, [wBillsPC_CursorItem]
	call BillsPC_GetItemIconOffset
	ld hl, BillsPC_HeldItemIcons
	add hl, de
	ld d, h
	ld e, l
	ld hl, vTiles3 tile PCTILE_HELD_MINI
	lb bc, BANK(BillsPC_HeldItemIcons), 1
	jp BillsPC_SafeGet2bpp

BillsPC_BagItem:
; Moves the hovered mon's item into the bag.
	ld a, [wTempMonItem]
	ld b, a
	push bc
	call BillsPC_GetCursorSlot
	call _BillsPC_BagItem
	pop bc
	ret nz
	ld a, b
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, BillsPC_MovedToPackText
	; fallthrough
BillsPC_PrintText:
	push hl
	call BillsPC_HideCursorAndMode
	pop hl
	call BillsPC_MenuTextbox
	call BillsPC_UpdateCursorLocation
	jp BillsPC_CloseWindow

_BillsPC_BagItem:
; Moves box b slot c's item to the bag. Returns z on success.
	ld a, b
	and a
	jr z, .entries_not_full

	ld a, 1
	push bc
	call BillsPC_GetStorageSpace
	pop bc
	ret nz

.entries_not_full
	farcall GetStorageBoxMon
	call .do_it
	ld a, [wTempMonItem]
	and a
	ret

.do_it
	ld a, [wTempMonItem]
	ld [wCurItem], a

	; Mail is taken through the Mail flow (only party mons can hold it)
	ld d, a
	farcall_a StorageItemIsMail
	jr nc, .put_in_pack

	call BillsPC_TakeMail
	push af
	call BillsPC_CopyTilemapAtOnce
	pop af
	sbc a
	inc a
	ret nz

	; taken: tell the caller the item is gone
	ld [wTempMonItem], a
	ret

.put_in_pack
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	ld hl, BillsPC_PackFullText
	jr nc, BillsPC_PrintText
	xor a
	ld [wTempMonItem], a
	call BillsPC_UpdateStorage
	jp GetCursorMon

BillsPC_UpdateStorage:
; Commits wTempMon (item change) to storage.
	push hl
	push de
	push bc
	farcall UpdateStorageBoxMonFromTemp
	pop bc
	pop de
	pop hl
	ret

BillsPC_CantPutMailIntoPackText:
	text "The MAIL would"
	line "lose its message."
	prompt

BillsPC_PackFullText:
	text "The BAG is full…"
	prompt

BillsPC_MovedToPackText:
	text "Moved @"
	text_ram wStringBuffer1
	text_start
	line "to the BAG."
	prompt

BillsPC_Menu:
; hl = menu header, b = number of menus to close afterwards
	inc b
	push bc
	call LoadMenuHeader
	xor a
	ld [wWhichIndexSet], a
	ldh [hBGMapMode], a ; restored to 1 by BillsPC_CloseWindow
	call DrawVariableLengthMenuBox
	call BillsPC_CopyTilemapAtOnce
	call DoNthMenu
	pop bc
	push af
	push bc
	call BillsPC_UpdateCursorLocation
.closemenu_loop
	pop bc
	dec b
	jr z, .menus_closed
	push bc
	call ExitMenu
	jr .closemenu_loop
.menus_closed
	call BillsPC_CopyTilemapAtOnce
	ld a, 1
	ldh [hBGMapMode], a
	pop af
	ret c
	ld a, [wMenuSelection]
	ld hl, BillsPC_MenuJumptable
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

BillsPC_Item:
	call BillsPC_HideCursorAndMode

	; Eggs can't hold items
	ld a, [wTempMonIsEgg]
	and a
	ld hl, BillsPC_EggsCantHoldItemsText
	jp nz, BillsPC_PrintText

	; Different menus depending on the held item (none / item / Mail)
	ld a, [wTempMonItem]
	and a
	ld hl, .ItCanHoldAnItem
	ld de, .NoItemMenu
	jr z, .got_menu
	ld d, a
	farcall_a StorageItemIsMail
	ld hl, .ItemIsSelected
	ld de, .ItemMenu
	jr nc, .got_menu
	ld de, .MailMenu
.got_menu
	push de
	call BillsPC_MenuTextbox
	pop hl
	ld b, 2
	jr BillsPC_Menu

.ItemIsSelected:
	text_ram wStringBuffer2
	text " is"
	line "selected."
	done

.ItCanHoldAnItem:
	text_ram wTempMonNickname
	text " can"
	line "hold an item."
	done

.MailMenu:
	db MENU_BACKUP_TILES
	menu_coords 11, 3, 19, 12
	dw .MailMenuData
	db 1 ; default option

.MailMenuData:
	db STATICMENU_WRAP ; flags
	db 4 ; items
	dw .mail
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.ItemMenu:
	db MENU_BACKUP_TILES
	menu_coords 11, 5, 19, 12
	dw .ItemMenuData
	db 1 ; default option

.ItemMenuData:
	db STATICMENU_WRAP ; flags
	db 3 ; items
	dw .items
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.NoItemMenu:
	db MENU_BACKUP_TILES
	menu_coords 11, 7, 19, 12
	dw .NoItemMenuData
	db 1 ; default option

.NoItemMenuData:
	db STATICMENU_WRAP ; flags
	db 2 ; items
	dw .noitems
	dw PlaceMenuStrings
	dw BillsPC_MenuStrings

.mail
	db 4
	db BOXMENU_MOVEITEM
	db BOXMENU_TAKEMAIL
	db BOXMENU_READMAIL
	db BOXMENU_CANCEL
	db -1

.items
	db 3
	db BOXMENU_MOVEITEM
	db BOXMENU_BAGITEM
	db BOXMENU_CANCEL
	db -1

.noitems
	db 2
	db BOXMENU_GIVEITEM
	db BOXMENU_CANCEL
	db -1

BillsPC_EggsCantHoldItemsText:
	text "Eggs can't hold"
	line "items."
	prompt

; ---------------------------------------------------------------------------
; Releasing, renaming, themes, box changes
; ---------------------------------------------------------------------------

BillsPC_CanReleaseMon:
; Checks whether box b slot c can be released. Loads wTempMon. Returns
; RELEASE_* in a (z if RELEASE_OK). Like Polished, moves are not checked.
	farcall GetStorageBoxMon
	ld a, RELEASE_EMPTY
	jr z, .done

	; Never release the last healthy party mon
	ld a, b
	and a
	jr nz, .not_last_healthy
	ld a, c
	dec a
	ld [wCurPartyMon], a
	push hl
	push de
	push bc
	farcall CheckCurPartyMonFainted ; carry if it's the last healthy one
	pop bc
	pop de
	pop hl
	ld a, RELEASE_LAST_HEALTHY
	jr c, .done
	; fallthrough
.not_last_healthy
	; Eggs can't be released (Bad Eggs can)
	ld a, [wTempMonIsEgg]
	and a
	jr z, .not_egg
	ld a, [wTempMonNickname]
	cp "B" ; "BAD EGG" rather than "EGG"
	ld a, RELEASE_EGG
	ret nz

.not_egg
	xor a ; RELEASE_OK
.done
	and a
	ret

BillsPC_RemoveStorageBoxMon:
	push hl
	push de
	push bc
	farcall RemoveStorageBoxMon
	pop bc
	pop de
	pop hl
	ret

BillsPC_ReleaseAll:
	call BillsPC_HideModeIcon

	; Double confirmation
	ld hl, .ReallyReleaseBox
	call BillsPC_MenuTextbox
	call BillsPC_NoYesBox
	jr c, .done

	ld hl, .CantRecallReleasedMons
	call PrintText
	call BillsPC_NoYesBox
	jr c, .done

	; d = released, e = refused
	lb de, 0, 0
	call BillsPC_GetCursorSlot
.loop
	ld a, c
	inc c
	cp MONS_PER_BOX
	jr z, .releases_done

	call BillsPC_CanReleaseMon
	jr nz, .failed_release
	inc d
	push de
	call BillsPC_RemoveStorageBoxMon
	lb de, -1, -1
	push bc
	call BillsPC_MoveIconData
	pop bc
	pop de
	jr .loop
.failed_release
	cp RELEASE_EMPTY
	jr z, .loop
	inc e
	jr .loop
.releases_done
	ld a, d
	ld [wTextDecimalByte], a
	or e
	ld hl, .NothingThere
	jr z, .print
	and d
	ld hl, .NothingReleased
	jr z, .print2
	ld hl, .ReleasedXMon
.print
	push de
	call PrintText
	pop de
	ld a, e
	and a
	ld hl, .TheRestWasnt
	jr z, .done
.print2
	call PrintText
.done
	call BillsPC_UpdateCursorLocation
	jp BillsPC_CloseWindow

.ReallyReleaseBox:
	text "Really release the"
	line "entire BOX?"
	done

.CantRecallReleasedMons:
	text "You can't recall"
	line "released #MON."
	cont "Are you sure?"
	done

.NothingThere:
	text "The BOX is empty."
	prompt

.NothingReleased:
	text "You can't release"
	line "EGGS."
	prompt

.ReleasedXMon:
	text "Released @"
	text_decimal wTextDecimalByte, 1, 2
	text_start
	line "#MON."
	prompt

.TheRestWasnt:
	text "The rest are"
	line "EGGS."
	prompt

BillsPC_Release:
	call BillsPC_GetCursorSlot
	call BillsPC_CanReleaseMon
	ld hl, BillsPC_LastPartyMon
	dec a ; RELEASE_LAST_HEALTHY
	jr z, .print
	ld hl, .CantReleaseEgg
	dec a ; RELEASE_EGG
	jr z, .print

	; The slot can't be empty: the menu wouldn't have opened
	call BillsPC_HideCursorAndMode
	ld hl, .ReallyReleaseMon
	call BillsPC_MenuTextbox
	call BillsPC_NoYesBox
	jr c, .done

	; Keep the nickname: removing the mon may rewrite wTempMon
	ld hl, wTempMonNickname
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	call CopyBytes

	call BillsPC_GetCursorSlot
	push bc
	call BillsPC_RemoveStorageBoxMon

	ld hl, .WasReleasedOutside
	call PrintText

	call .done
	pop bc
	lb de, -1, -1
	call BillsPC_MoveIconData
	call CheckPartyShift
	jp GetCursorMon

.done
	call BillsPC_UpdateCursorLocation
	jp BillsPC_CloseWindow

.print
	jp BillsPC_PrintText

.CantReleaseEgg:
	text "You can't release"
	line "an EGG!"
	prompt

.ReallyReleaseMon:
	text "Really release"
	line "@"
	text_ram wTempMonNickname
	text "?"
	done

.WasReleasedOutside:
	text_ram wStringBuffer1
	text " was"
	line "released outside."
	cont "Bye, @"
	text_ram wStringBuffer1
	text "!"
	prompt

BillsPC_Rename:
	call BillsPC_PrepareTransition
	ld b, NAME_BOX
	ld de, wStringBuffer2
	farcall NamingScreen
	ld hl, wStringBuffer2

	; Abort on an empty name
	ld a, "@"
	cp [hl]
	jr z, .abort
	ld de, wStringBuffer1
	ld bc, BOX_NAME_LENGTH
	call CopyBytes
	ld a, [wCurBox]
	inc a
	ld b, a
	farcall SetBoxName
.abort
	jp BillsPC_ReturnFromTransition

BillsPC_Theme:
	call BillsPC_HideCursorAndMode

	call LoadStandardMenuHeader
	ld hl, .PickAThemeText
	call BillsPC_PrintTextbox

	ld hl, .ThemeMenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	call BillsPC_CopyTilemapAtOnce
	call GetBoxTheme_far
	ld [wMenuScrollPosition], a
	call ScrollingMenu

	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow

	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .refresh_theme ; revert to the current theme

	ld a, [wMenuSelection] ; theme + 1
	dec a
	farcall_a SetBoxTheme

.refresh_theme
	jp BillsPC_RefreshTheme

.PickAThemeText:
	text "Please"
	line "pick a theme."
	done

.ThemeMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 8, 1, 18, 13
	dw .ThemeMenuData
	db 1 ; default option

.ThemeMenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS | SCROLLINGMENU_ENABLE_FUNCTION3 ; flags
	db 6, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dba .ThemeList
	dba .GetThemeString
	dba NULL
	dba .PreviewTheme

.ThemeList:
	db NUM_BILLS_PC_THEMES
for x, 1, NUM_BILLS_PC_THEMES + 1
	db x
endr
	db -1

.GetThemeString:
	ld a, [wMenuSelection]
	dec a
	push de
	ld e, a
	ld d, 0
	ld hl, BillsPC_ThemeNames
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString

.PreviewTheme:
	ld a, 1
	ld [wBillsPC_ApplyThemePals], a
	ld a, [wMenuSelection]
	cp -1
	jr z, .current_theme
	dec a
	jp BillsPC_PreviewTheme
.current_theme
	jp BillsPC_LoadPalettes

INCLUDE "data/pc/theme_names.asm"

BillsPC_Change:
	call BillsPC_HideCursorAndMode

	call LoadStandardMenuHeader
	ld hl, .PickABoxToChangeToText
	call BillsPC_PrintTextbox

	ld hl, .ChangeMenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	call BillsPC_CopyTilemapAtOnce
	ld a, [wCurBox]
	ld [wMenuScrollPosition], a
	call ScrollingMenu

	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow

	ld a, [wMenuJoypad]
	cp B_BUTTON
	ret z

	ld a, [wMenuSelection] ; box number, 1-based
	dec a
	jr BillsPC_ChangeBox

.PickABoxToChangeToText:
	text "Pick a"
	line "BOX to change to."
	done

.ChangeMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 8, 1, 18, 13
	dw .ChangeMenuData
	db 1 ; default option

.ChangeMenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 6, 0 ; rows, columns
	db SCROLLINGMENU_ITEMS_NORMAL ; item format
	dba .BoxList
	dba .GetBoxString
	dba NULL

.BoxList:
	db NUM_BOXES
for x, 1, NUM_BOXES + 1
	db x
endr
	db -1

.GetBoxString:
	ld a, [wMenuSelection]
	ld b, a
	push de
	farcall GetBoxName
	ld de, wStringBuffer1
	pop hl
	jp PlaceString

BillsPC_ChangeBox:
; a = new box (0-based)
	ld [wCurBox], a
	call BillsPC_RefreshTheme
	call DelayFrame ; avoid tearing
	call BillsPC_PrintBoxName
	call BillsPC_CopyTilemapAtOnce
	xor a
	ldh [hBGMapMode], a
	inc a
	ldh [rVBK], a
	call SetBoxIcons
	call BillsPC_SetPals
	xor a
	ldh [rVBK], a
	inc a
	ldh [hBGMapMode], a
	ret

BillsPC_GetCursorFromTo:
; Source (held) in de, destination (cursor) in bc.
	call BillsPC_GetCursorHeldSlot
	ld d, b
	ld e, c
	jp BillsPC_GetCursorSlot

BillsPC_SwapStorage:
; Swaps slots bc and de (mons, or the held item). Returns z on success with
; the effective slot in a.
	call BillsPC_UpdateCursorLocation
	push de
	push bc

	; Items are handled separately
	call BillsPC_IsHoldingItem
	jp z, .holding_mon

	; On the pack?
	ld a, c
	inc a
	jr nz, .not_on_pack

	; Move the mon's item there (nothing to do if it came from the pack)
	ld b, d
	res 7, b
	ld c, e
	inc e
	call nz, _BillsPC_BagItem
	pop bc
	pop de
	ret

.not_on_pack
	; Empty slot or box name: nothing happens
	dec a
	jp z, .abort
	farcall GetStorageBoxMon
	jp z, .abort

	; Moving to a box may need database space (box -> party is always safe;
	; the bag shares the party's box id)
	ld a, b
	and a
	jr z, .entries_not_full
	ld a, d
	and $7f
	ld a, 1
	jr z, .got_space_req
	inc a
.got_space_req
	call BillsPC_GetStorageSpace
	jp nz, .abort
	pop bc
	pop de
	push de
	push bc
	farcall GetStorageBoxMon
	; fallthrough
.entries_not_full
	; Eggs can't hold items
	ld a, [wTempMonIsEgg]
	and a
	ld a, PCSWAP_EGGS_CANT_HOLD
	jp nz, .failed

	; From the bag?
	ld a, e
	inc a
	jp nz, .moving_between_mon

	; No Mail into storage
	ld a, b
	and a
	jr z, .mail_ok
	ld a, [wBillsPC_CursorItem]
	ld d, a
	farcall_a StorageItemIsMail
	ld a, PCSWAP_CANT_STORE_MAIL
	jp c, .failed

.mail_ok
	; If the mon already holds something, it goes to the bag (never Mail:
	; its message would be lost)
	ld a, [wTempMonItem]
	and a
	ld [wCurItem], a
	jr z, .dest_is_itemless

	ld d, a
	farcall_a StorageItemIsMail
	ld a, PCSWAP_CANT_POCKET_MAIL
	jp c, .failed

	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	ld a, PCSWAP_PACK_FULL
	jp nc, .failed
	; fallthrough
.dest_is_itemless
	; Giving Mail composes a message
	ld a, [wBillsPC_CursorItem]
	ld [wCurItem], a
	ld d, a
	farcall_a StorageItemIsMail ; a is not preserved
	ld a, [wBillsPC_CursorItem]
	jr nc, .compose_check_done

	push af
	ld a, [wTempMonSlot]
	dec a
	ld [wCurPartyMon], a
	ld a, [wTempMonSpecies]
	ld [wCurPartySpecies], a
	call BillsPC_PrepareTransition
	call BillsPC_ComposeMail
	call BillsPC_ReturnFromTransition

	; reload the cursor item icon
	ld a, 1
	ldh [rVBK], a
	call BillsPC_LoadCursorItemIcon
	xor a
	ldh [rVBK], a
	pop af

.compose_check_done
	ld [wTempMonItem], a
	ld [wCurItem], a
	call BillsPC_UpdateStorage
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call TossItem
	xor a
	jp .done

.moving_between_mon
	; Drop the "is item" flag
	ld a, d
	and $7f
	ld d, a
	; Both in the party: their Mail moves along
	or b
	call z, BillsPC_SwapPartyMonMail

	; Swap the items
	push de
	push bc
	ld b, d
	ld c, e
	farcall GetStorageBoxMon
	ld a, [wTempMonItem]
	ld e, a
	ld a, b
	pop bc
	push af
	farcall GetStorageBoxMon
	pop af
	ld hl, wTempMonItem
	ld d, [hl]

	; Item d (going to the source mon) mustn't be Mail into storage
	and a ; a = source box: 0 = party
	jr z, .d_ok
	ld a, d
	farcall_a StorageItemIsMail ; a = item, carry if Mail; preserves de
.d_ok
	ld a, PCSWAP_CANT_STORE_MAIL
	jr c, .item_failed
	push de

	; Item e (going to the destination mon) likewise
	ld a, b
	and a
	jr z, .e_ok
	ld a, e
	farcall_a StorageItemIsMail
.e_ok
	ld a, PCSWAP_CANT_STORE_MAIL
	jr c, .pop_de_item_failed

	; No Mail enters storage: do the move
	ld hl, wTempMonItem
	ld [hl], e
	call BillsPC_UpdateStorage
	pop de
	pop bc
	push de
	ld b, d
	ld c, e
	farcall GetStorageBoxMon
	pop de
	ld hl, wTempMonItem
	ld [hl], d
	call BillsPC_UpdateStorage
	xor a
	jr .done

.pop_de_item_failed
	pop de
	; fallthrough
.item_failed
	pop bc
	jr .failed

.holding_mon
	; Swap slots bc and de and interpret the result
	farcall SwapStorageBoxSlots
	and a
	jr nz, .failed
	ld a, c
	jr .done

.failed
	push af
	push hl
	push bc
	call BillsPC_HideCursorAndMode
	pop bc
	pop hl
	pop af
	sub 2
	ld hl, BillsPC_MustSaveToContinue
	jr c, .swap_failed
	ld hl, .PartyIsFull
	jr z, .swap_failed
	ld hl, .BoxIsFull
	dec a
	jr z, .swap_failed
	ld hl, BillsPC_LastPartyMon
	dec a
	jr z, .swap_failed
	ld hl, .IsHoldingMail
	dec a
	jr z, .swap_failed

	; Item move failures
	ld hl, .CantStoreMail
	dec a
	jr z, .swap_failed
	ld hl, BillsPC_EggsCantHoldItemsText
	dec a
	jr z, .swap_failed
	ld hl, BillsPC_CantPutMailIntoPackText
	dec a
	jr z, .swap_failed
	ld hl, BillsPC_PackFullText
	; fallthrough
.swap_failed
	push af
	call BillsPC_MenuTextbox
	pop af

	; Carry means "save the game?": on yes, save and retry
	jr nc, .menutext_abort

	call BillsPC_YesNoBox
	jr c, .menutext_abort

	call BillsPC_ForceSave
	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow
	pop bc
	pop de
	jp BillsPC_SwapStorage
.menutext_abort
	call BillsPC_UpdateCursorLocation
	call BillsPC_CloseWindow
.abort
	or 1
.done
	pop bc
	pop de
	ret

.PartyIsFull:
	text "The party is full."
	prompt

.BoxIsFull:
	text "The BOX is full."
	prompt

.IsHoldingMail:
	text "Held MAIL must be"
	line "removed first."
	prompt

.CantStoreMail:
	text "Can't place MAIL"
	line "in storage."
	prompt

BillsPC_LastPartyMon:
	text "That's your last"
	line "healthy #MON!"
	prompt

BillsPC_MustSaveToContinue:
	text "Save the game to"
	line "do this?"
	done

BillsPC_SwapPartyMonMail:
; Swaps the Mail data of party slots d and e (1-based).
	push hl
	push de
	push bc
	ld a, BANK(sPartyMail)
	call GetSRAMBank
	ld a, d
	dec a
	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	call AddNTimes
	push hl
	ld a, e
	dec a
	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	call AddNTimes
	pop de
	ld c, MAIL_STRUCT_LENGTH
.loop
	ld a, [de]
	ld b, [hl]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call CloseSRAM
	pop bc
	pop de
	pop hl
	ret

BillsPC_ComposeMail:
; Writes a Mail message for wCurPartyMon holding wCurItem (same as the
; party menu's ComposeMailMessage).
	ld de, wTempMailMessage
	farcall _ComposeMailMessage
	ld hl, wPlayerName
	ld de, wTempMailAuthor
	ld bc, NAME_LENGTH - 1
	call CopyBytes
	ld hl, wPlayerID
	ld bc, 2
	call CopyBytes
	ld a, [wCurPartySpecies]
	ld [de], a
	inc de
	ld a, [wCurItem]
	ld [de], a
	ld a, [wCurPartyMon]
	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wTempMail
	ld bc, MAIL_STRUCT_LENGTH
	ld a, BANK(sPartyMail)
	call GetSRAMBank
	call CopyBytes
	jp CloseSRAM

BillsPC_PlaceHeldMon:
; Places the held mon/item at the cursor. May swap, or be refused.
	call BillsPC_GetCursorFromTo

	call BillsPC_SwapStorage
	ret nz ; failed

	inc c
	jr nz, .not_on_pack
	dec c

	; Avoid pack icon flicker
	call DelayFrame

	; No quick anim
	xor a
	jr .place_icon

.not_on_pack
	dec c
	jr nz, .not_on_boxname

	; Onto a box name: the sprite just travels there, no placing animation
	push de
	ld e, a
	ld d, b
	lb bc, -1, 0
	call BillsPC_PerformQuickAnim
	pop bc
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a
	jr .partyshift

.not_on_boxname
	; Is the slot blank?
	ld a, c
	dec a
	add a
	inc b
	dec b
	ld hl, wBillsPC_PartyList
	jr z, .got_monlist
	ld hl, wBillsPC_BoxList
.got_monlist
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	and a
.place_icon
	push af
	push de
	push bc
	call nz, BillsPC_PrepareQuickAnim

	call BillsPC_CursorPick1
	pop de
	lb bc, -1, 0
	call BillsPC_MoveIconData
	call BillsPC_IsHoldingItem
	jr z, .holding_mon

	ld a, 1
	ldh [rVBK], a
	call BillsPC_BlankCursorItem
	xor a
	ldh [rVBK], a

	; Redundant, but fixes the display when placing back on the same mon
	call .blankcursor

	call GetCursorMon

.holding_mon
	call BillsPC_CursorPick2
	pop bc
	pop af
.partyshift
	call CheckPartyShift
	call BillsPC_MaybeMoveCursor
	call z, GetCursorMon
	; fallthrough
.blankcursor
	xor a
	ld [wBillsPC_CursorHeldBox], a
	ld [wBillsPC_CursorHeldSlot], a
	ret

BillsPC_RestoreUI:
; Rebuilds the screen after another screen (summary, naming, pack, mail).
	call ClearPalettes
	call ClearSprites
	farcall ClearSpriteAnims

	; Another screen may have overwritten the icon tiles
	ld a, 1
	ldh [rVBK], a
	xor a
	ldh [hBGMapMode], a
	call SetPartyIcons
	call SetBoxIconsAndName
	xor a
	ldh [rVBK], a

	call BillsPC_LoadUI

	; Cursor palettes
	ld a, [wBillsPC_CursorMode]
	call _BillsPC_SetCursorMode
	call BillsPC_LoadPalettes
	call BillsPC_ApplyPals
	call BillsPC_CommitPals
	call _GetCursorMon
	; A held item's marker/name/icon were wiped with the sprites
	call BillsPC_IsHoldingItem
	jr z, .no_item
	ld a, 1
	ldh [rVBK], a
	call BillsPC_ShowCursorItem
	xor a
	ldh [rVBK], a
.no_item
	call BillsPC_CopyTilemapAtOnce

	call BillsPC_EnableHBlank

	ld a, 1
	ldh [hBGMapMode], a
	ret

BillsPC_CursorPosValid:
; Returns z if cursor position a is valid.
	; columns beyond 5
	ld b, a
	and $f
	cp 6
	jr nc, .invalid

	; party rows below 2
	cp 2
	jr nc, .not_party
	ld a, b
	cp $20
	jr c, .invalid

	; rows 3-5 are always valid
	cp $30
	jr nc, .not_party

	; the bag location only sometimes
	cp $21
	jr nz, .invalid

	call _BillsPC_CheckBagDisplay
	jr nz, .invalid

.not_party
	; rows beyond 5
	ld a, b
	cp $60
	jr c, .valid
.invalid
	or 1
	ld a, b
	ret
.valid
	xor a
	ld a, b
	ret

; ---------------------------------------------------------------------------
; Sprite animation sequences (called from engine/gfx/sprite_anims.asm)
; ---------------------------------------------------------------------------

BillsPC_AnimSeq_Cursor::
; bc = sprite anim struct
	; Frameset depends on the bag and on what the cursor carries
	push bc
	call BillsPC_GetCursorFrameset
	pop bc
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	push de
	push bc
	call BillsPC_GetCursorSlot
	call BillsPC_GetXYFromStorageBox
	pop bc
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], d
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], e
	pop de

	; Static cursor?
	ld a, [wBillsPC_CursorAnimFlag]
	and a
	ret z

	; Picking up: the UI drives the flag
	cp PCANIM_PICKUP
	jr c, .not_picking
	sub PCANIM_PICKUP - 1
	add [hl]
	ld [hl], a
	ret
.not_picking
	cp PCANIM_ANIMATE / 2 + 1
	jr c, .dont_bop
	inc [hl]
	inc [hl]
.dont_bop
	dec a
	ld [wBillsPC_CursorAnimFlag], a
	ret nz
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a
	ret

BillsPC_AnimSeq_Quick::
; Moves a mini from one slot to another.
	push de

	; Done?
	ld hl, wBillsPC_QuickFrames
	inc [hl]
	dec [hl]
	jr z, .finish_anim
	dec [hl]

	ld a, [wBillsPC_QuickFromX]
	ld d, a
	ld a, [wBillsPC_QuickToX]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	call .ShiftPos
	ld a, [wBillsPC_QuickFromY]
	ld d, a
	ld a, [wBillsPC_QuickToY]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	call .ShiftPos
	jr .done

.finish_anim
	call BillsPC_FinishQuickAnim
	; fallthrough
.done
	pop de
	ret

.ShiftPos:
; Position along the way depending on the frame number.
	push hl
	push bc

	; difference between the coordinates (sign-extended into bc)
	ld a, d
	sub e
	ld c, a
	sbc a
	ld b, a

	; times the frame number
	xor a
	ld h, a
	ld l, a
	ld a, [wBillsPC_QuickFrames]
	inc a
.loop
	dec a
	jr z, .got_multiplier
	add hl, bc
	jr .loop
.got_multiplier
	; divided by 8
	ld a, l
	sra h
	rra
	sra h
	rra
	sra h
	rra

	add e

	pop bc
	pop hl
	add hl, bc
	ld [hl], a
	ret

BillsPC_AnimSeq_Mode::
	ld a, [wBillsPC_CursorMode]
	ld h, a
	add h
	add h
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

BillsPC_AnimSeq_Pack::
	; $00 = male, $04 = female
	ld a, [wPlayerGender]
	and 1
	add a
	add a
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a

	; Hide the pack outside item mode
	call BillsPC_CheckBagDisplay
	ld a, $80 ; off screen
	jr nz, .got_pack_y
	xor a
.got_pack_y
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

; ---------------------------------------------------------------------------
; HBlank palette code (copied to WRAM0; runs from the STAT interrupt)
; ---------------------------------------------------------------------------

; The STAT interrupt is set to LYC only (rSTAT = $40) while the PC is open,
; so it fires at the *start* of scanline rLYC (rows at lines 71, 87, 103, 119,
; 135). Each phase then waits for that line's HBlank and writes its palettes
; right at the top of the window (HBlank + the next line's OAM scan), so a
; sprite-heavy line can't push the writes into mode 3, where the CGB ignores
; palette writes. (Taking the HBlank interrupt instead - as vanilla and
; Polished do - starts the writes 40-50 cycles into the window; with the
; cursor, held mini and mode icon on one line that overran, and rows or the
; symbol cells showed the wrong colours for a frame: the "blink".)
; Phase 1 writes box columns 2-4 for the next icon row; phase 2 (LYC + 1)
; writes BG palette 3 colour 0, the party columns and box column 1, sets the
; next LYC and stages that row's palettes + colour 0. A phase that finds
; rLY != rLYC (interrupts were disabled for over a scanline) leaves everything
; alone for the next frame. Both phases end "pop hl / pop af / reti".

; Phase labels are ROM addresses; the WRAM copy lives at
; wLCDBillsPC + (label - BillsPC_LCDCode).
BillsPC_LCDCode:
.Phase1:
	; Late?
	ldh a, [rLYC]
	ld l, a
	ldh a, [rLY]
	cp l
	jr nz, .donepc
	push bc
	ld c, LOW(rBGPD)
	ld hl, wBillsPC_CurMonPals + 4
	; second box mon (the index register can be set at any time)
	ld a, %10000000 | (5 palettes + 2) ; autoinc, palette 5 color 1
	ldh [rBGPI], a
.wait1
	ldh a, [rSTAT]
	and %11
	jr nz, .wait1
	; HBlank: 12 palette bytes, ~65 cycles
rept 4
	ld a, [hli]
	ldh [c], a
endr

	; third box mon
	ld a, %10000000 | (6 palettes + 2)
	ldh [rBGPI], a
rept 4
	ld a, [hli]
	ldh [c], a
endr

	; fourth box mon
	ld a, %10000000 | (7 palettes + 2)
	ldh [rBGPI], a
rept 4
	ld a, [hli]
	ldh [c], a
endr

	; phase 2 on the next scanline
	ld hl, rLYC
	inc [hl]
	ld a, LOW(wLCDBillsPC + (BillsPC_LCDCode.Phase2 - BillsPC_LCDCode))
	ldh [hLCDInterruptFunctionTargetLo], a
	ld a, HIGH(wLCDBillsPC + (BillsPC_LCDCode.Phase2 - BillsPC_LCDCode))
	ldh [hLCDInterruptFunctionTargetHi], a
	pop bc
.donepc
	pop hl
	pop af
	reti

.Phase2:
	; Late?
	ldh a, [rLYC]
	ld l, a
	ldh a, [rLY]
	cp l
	jr nz, .donepc
	push bc
	push de
	ld c, LOW(rBGPD)
	ld hl, wBillsPC_CurColor0
	; BG palette 3 colour 0 first: white inside the boxes (party column 2),
	; the theme background below the last row so the shiny/Pokérus symbols
	; at the top of the next frame sit on the background.
	ld a, %10000000 | (3 palettes) ; autoinc, palette 3 color 0
	ldh [rBGPI], a
.wait2
	ldh a, [rSTAT]
	and %11
	jr nz, .wait2
	; HBlank: 14 palette bytes, ~76 cycles
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a

	; first party mon (hl = wBillsPC_CurPartyPals)
	ld a, %10000000 | (2 palettes + 2)
	ldh [rBGPI], a
rept 4
	ld a, [hli]
	ldh [c], a
endr

	; second party mon
	ld a, %10000000 | (3 palettes + 2)
	ldh [rBGPI], a
rept 4
	ld a, [hli]
	ldh [c], a
endr

	; first box mon
	ld a, %10000000 | (4 palettes + 2)
	ldh [rBGPI], a
rept 4
	ld a, [hli]
	ldh [c], a
endr
	; end of the time-critical part

	; next row's scanline (rLYC is the row line + 1 here)
	ldh a, [rLYC]
	dec a
	cp PC_LYC_FIRST_ROW + 4 * PC_ICON_ROW_HEIGHT
	jr nz, .increase_lyc
	sub 5 * PC_ICON_ROW_HEIGHT
.increase_lyc
	add PC_ICON_ROW_HEIGHT
	ldh [rLYC], a

	; Colour 0 for the next phase 2
	ld hl, wBillsPC_CurColor0
	cp PC_LYC_FIRST_ROW + 4 * PC_ICON_ROW_HEIGHT
	jr z, .bottom
	ld [hl], LOW(PALRGB_WHITE)
	inc hl
	ld [hl], HIGH(PALRGB_WHITE)
	jr .stage
.bottom
	ld a, [wBillsPC_BGColor0]
	ld [hli], a
	ld a, [wBillsPC_BGColor0 + 1]
	ld [hl], a
	ldh a, [rLYC]

.stage
	; Stage the palettes for the next row (LYC 135 stages row 0, which
	; restores the top of the screen for the next frame).
	sub 55
	cp $50
	jr c, .got_result
	xor a
.got_result
	rrca
	ld c, a
	add a
	add c
	ld c, a
	ld b, 0

	ld hl, wBillsPC_PalList
	add hl, bc
	ld de, wBillsPC_CurPals
	ld c, 24
.copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy
	ld a, LOW(wLCDBillsPC)
	ldh [hLCDInterruptFunctionTargetLo], a
	ld a, HIGH(wLCDBillsPC)
	ldh [hLCDInterruptFunctionTargetHi], a
	pop de
	pop bc
	pop hl
	pop af
	reti
.End:
	assert BillsPC_LCDCode.End - BillsPC_LCDCode <= wLCDBillsPCEnd - wLCDBillsPC, \
		"BillsPC_LCDCode doesn't fit in wLCDBillsPC"

; ---------------------------------------------------------------------------
; Graphics
; ---------------------------------------------------------------------------

BillsPC_BlankTileGFX:
	ds 4 tiles, 0

BillsPC_CursorGFX:
INCBIN "gfx/pc/cursor.2bpp"

BillsPC_HeldItemIcons:
INCBIN "gfx/pc/held_item_icons.2bpp"

BillsPC_ShinyGFX:
INCBIN "gfx/pc/shiny.2bpp"

BillsPC_ObjGFX:
INCBIN "gfx/pc/obj.2bpp.lz"

BillsPC_TileGFX:
INCBIN "gfx/pc/pc.2bpp.lz"
