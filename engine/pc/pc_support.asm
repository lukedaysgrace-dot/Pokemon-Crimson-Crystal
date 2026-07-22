; Support routines for the Polished Crystal-style storage system.

Crash::
; Fatal storage error handler. a = error code.
; Locks up to avoid corrupting the database.
	di
.loop
	jr .loop

PopBCDEHL::
	pop bc
	pop de
	pop hl
	ret

SwapHLDE::
	push de
	ld d, h
	ld e, l
	pop hl
	ret

ItemIsMail_a::
; Returns carry if item in a is mail.
	push hl
	push de
	push bc
	ld d, a
	farcall ItemIsMail
	ld a, d
	jp PopBCDEHL

ItemIsMail_d::
; Returns carry if item in d is mail. Preserves registers (except f).
; ItemIsMail itself is in another bank, so the UI can't `call` it directly.
	push hl
	push de
	push bc
	ld b, a
	farcall ItemIsMail
	ld a, b
	jp PopBCDEHL

GetBaseDataFromIndex::
; Like GetBaseData, but takes a 16-bit species index in hl directly.
; Does not update wBaseSpecies (callers set wCurSpecies themselves).
	push bc
	push de
	push hl
	ldh a, [hROMBank]
	push af
	ld b, h
	ld c, l
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	rst Bankswitch
	ld de, wCurBaseData
	ld bc, BASE_DATA_SIZE
	call CopyBytes
	ld a, [wCurSpecies]
	ld [wBaseSpecies], a
	pop af
	rst Bankswitch
	pop hl
	pop de
	pop bc
	ret

RunFunctionInWRA6::
; Call the following function in wDecompressScratch's WRAM bank. Clobbers a.
	ld a, BANK("Scratch RAM")
StackCallInWRAMBankA::
; Call the following function in WRAM bank a. Clobbers a.
	add sp, -3
	push de
	push hl

; Stack layout:
; +7 return location
; +6 nothing
; +4 nothing
; +2 saved de
; +0 saved hl

	ld hl, rSVBK
	ld e, [hl]
	ld [hl], a

	ld hl, sp + 8
	ld d, [hl]
	ld a, e
	ld [hld], a

	ld e, [hl]
	ld a, HIGH(.return)
	ld [hld], a
	ld a, LOW(.return)
	ld [hld], a

	ld a, d
	ld [hld], a
	ld [hl], e

; Stack layout:
; +8 saved wram bank
; +6 .return
; +4 target function
; +2 saved de
; +0 saved hl

	pop hl
	pop de
	ret

.return
; Restore the WRAM bank pushed onto the stack.
	push af
	push hl
	ld hl, sp + 4
	ld a, [hl]
	ldh [rSVBK], a
	pop hl
	pop af

	; Skip past the WRAM bank byte and return.
	add sp, 1
	ret

SmallFlagAction::
; Perform action b on flag c in flag array hl.
; If checking a flag, check flag array d:hl unless d is 0.
; For longer flag arrays, see FlagAction.
	push hl
	push bc

; Divide by 8 to get the byte we want.
	push bc
	srl c
	srl c
	srl c
	ld b, 0
	add hl, bc
	pop bc

; Which bit we want from the byte
	ld a, c
	and 7
	ld c, a

; Shift left until we can mask the bit
	ld a, 1
	jr z, .shifted
.shift
	add a
	dec c
	jr nz, .shift
.shifted
	ld c, a

; What are we doing to this flag?
	dec b
	jr z, .set ; 1
	dec b
	jr z, .check ; 2

.reset
	ld a, c
	cpl
	and [hl]
	ld [hl], a
	jr .done

.set
	ld a, [hl]
	or c
	ld [hl], a
	jr .done

.check
	ld a, d
	and a
	jr nz, .farcheck

	ld a, [hl]
	and c
	jr .done

.farcheck
	call GetFarByte
	and c

.done
	pop bc
	pop hl
	ld c, a
	ret

CopyRLE::
; Copy bytes from hl to de
; Format: value, count
; Terminated with $ff
.loop
	ld a, [hli]
	inc a
	ret z
	dec a
	ld c, [hl]
	inc hl
.load
	ld [de], a
	inc de
	dec c
	jr nz, .load
	jr .loop

PCJumpTable::
; Jump to entry a in the pointer table at hl.
	push de
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	pop de
IndirectHL::
	ld a, [hli]
	ld h, [hl]
	ld l, a
_hl_2::
	jp hl

ClearPCItemScreen::
	call DisableSpriteUpdates
	xor a
	ldh [hBGMapMode], a
	call ClearBGPalettes
	call ClearSprites
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	hlcoord 0, 0
	lb bc, 10, 18
	call Textbox
	hlcoord 0, 12
	lb bc, 4, 18
	call Textbox
	call WaitBGMap2
	call SetPalettes
	ret

CopyBoxmonToTempMon::
; Legacy: load box mon [wCurPartyMon] of the current box into wTempMon.
	ld a, [wCurBox]
	inc a
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	ld c, a
	call GetStorageBoxMon
	ret

StatsScreenDPad::
; Stats screen navigation for TEMPMON (storage system mons).
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON | B_BUTTON | D_RIGHT | D_LEFT
	ld [wMenuJoypad], a
	ret nz
	ld a, [hl]
	and D_DOWN | D_UP
	ld [wMenuJoypad], a
	ret z
	; Only browse if we have a valid storage slot.
	ld a, [wTempMonSlot]
	and a
	jr z, .did_nothing
	ld a, [wMenuJoypad]
	and D_UP
	jr nz, .up
	call NextStorageBoxMon
	jr .moved
.up
	call PrevStorageBoxMon
.moved
	jr z, .did_nothing
	ld a, [wTempMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ld [wTempSpecies], a
	ret

.did_nothing
	xor a
	ld [wMenuJoypad], a
	ret

BillsPC_WipeAttrMap::
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	jp ByteFill

BillsPC_DoNothing::
	ret

PCGiveItem::
PCPickItem::
; TODO: real port needs Polished's rewritten Pack engine
; (DepositSellInitPackBuffers/_GetItemToGive). Until then, return z
; ("cancelled") so the PC item menu degrades gracefully.
	xor a
	ret

; ============================================================
; Storage system palette layout (ported from Polished Crystal's
; _CGB_BillsPC). Lives here because bank2 (cgb_layouts) is full;
; GetSGBLayout reaches it through a trampoline.
; ============================================================

_CGB_BillsPC_Far::
	call GetBoxTheme
BillsPC_PreviewTheme::
; a = theme to load palettes for
	call GetBillsPCThemePalette

	ldh a, [rSVBK]
	push af
	ld a, BANK("GBC Video")
	ldh [rSVBK], a

	push hl
	ld de, wBGPals1 + 2
	ld hl, BillsPC_GenderAndExpBarPals
	ld c, 2 * 2
	call BillsPC_LoadColorBytes
	push de
	ld hl, BillsPC_ShinyAndPokerusPals
	ld de, wBillsPC_PokerusShinyPal
	ld c, 2 * 2
	call BillsPC_LoadColorBytes
	; Prevents flickering shiny+pokerus background
	ld hl, wBGPals1 palette 0
	ld de, wBGPals1 palette 3
	call BillsPC_LoadOneColor
	pop de
	pop hl
	ld c, 4 * 2
	call BillsPC_LoadColorBytes
	ld hl, BillsPC_WhitePalette
	ld de, wBGPals1 palette 1 + 3 * 2
	call BillsPC_LoadOneColor
	ld hl, wBGPals1 palette 1
	ld de, wBGPals1 palette 0
	call BillsPC_LoadOneColor

	pop af
	ldh [rSVBK], a

	ld a, [wBillsPC_ApplyThemePals]
	and a
	jr z, .ob_pals
	jp BillsPC_SetPals

.ob_pals
	ld de, wOBPals1
	ld hl, BillsPC_BaseOBPals
	ld c, 8 palettes
	call BillsPC_LoadPalettes
	ld de, wOBPals1 palette 1
	ld hl, BillsPC_CursorPal
	push hl
	call BillsPC_LoadOnePalette
	pop hl
	call BillsPC_LoadOnePalette
	ld hl, BillsPC_PackPal
	ld de, wOBPals1 palette 4
	call BillsPC_LoadOnePalette
	ld hl, BillsPC_WhitePalette
	ld de, wOBPals1 palette 6
	call BillsPC_LoadOnePalette
	; Commit to hardware next vblank.
	jp BillsPC_CommitPals

BillsPC_LoadOneColor:
; Load one color (2 bytes) from hl to de
	ld c, 2
BillsPC_LoadColorBytes:
; Load c color bytes from hl to de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, BillsPC_LoadColorBytes
	ret

BillsPC_LoadOnePalette:
; Load a single palette from hl to de in GBC Video WRAMX
	ld c, 1 palettes
	; fallthrough
BillsPC_LoadPalettes:
; Load c palette bytes from hl to de in GBC Video WRAMX
	ldh a, [rSVBK]
	push af
	ld a, BANK("GBC Video")
	ldh [rSVBK], a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

GetBillsPCThemePalette:
; hl = .ThemePals + a * 4 * 2
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, .ThemePals
	add hl, de
	add hl, de
	ret

.ThemePals:
INCLUDE "gfx/pc/themes.pal"

BillsPC_CursorPal:
; Coloring is fixed up later.
INCLUDE "gfx/pc/cursor_default.pal"

BillsPC_PackPal:
INCLUDE "gfx/pc/pack.pal"

BillsPC_ShinyAndPokerusPals:
INCLUDE "gfx/pc/pokerus_shiny.pal"

BillsPC_GenderAndExpBarPals:
INCLUDE "gfx/pc/exp_bar.pal"

BillsPC_BaseOBPals:
INCLUDE "gfx/pc/icons.pal"

BillsPC_WhitePalette:
	RGB 31, 31, 31

; ============================================================
; Graphics assets
; ============================================================

BillsPC_CursorGFX::      INCBIN "gfx/pc/cursor.2bpp"
BillsPC_TileGFX::        INCBIN "gfx/pc/pc.2bpp"
BillsPC_ObjGFX::         INCBIN "gfx/pc/obj.2bpp"
BillsPC_GenderShinyGFX:: INCBIN "gfx/pc/gender_shiny.2bpp"

; ============================================================
; Mini icon subsystem (uses Crimson's per-species icon set)
; ============================================================

GetIconPointerFromIndex::
; PC storage system icon lookup: works for every species, including
; Crimson-exclusive ones, because it takes the 16-bit index directly.
; hl = 16-bit species index (or PC_EGG_INDEX for eggs)
; Output: b = bank, hl = address of menu icon gfx
; Uses far accessors only, so it can live in this bank.
	ld a, h
	inc a ; HIGH(PC_EGG_INDEX) == $ff -> 0
	jr z, .egg
	dec hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc ; hl = (species index - 1) * 3
	ld bc, MenuIconPointers
	add hl, bc
	ld a, BANK(MenuIconPointers)
	call GetFarByte
	ld b, a ; icon gfx bank
	inc hl
	ld a, BANK(MenuIconPointers)
	call GetFarHalfword ; hl = icon gfx address
	ret

.egg
	ld b, BANK(EggMenuIcon)
	ld hl, EggMenuIcon
	ret

GetStorageMini_a::
; Load frame 1 mini graphics into VRAM starting from tile a
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld de, vTiles0
	add hl, de
	; fallthrough
GetStorageMini::
; Load the 4 frame-1 mini tiles of the icon selected by
; wCurIcon (index low) / wCurIconForm (index high) to VRAM at hl.
	push hl
	push de
	push bc
	push hl
	ld a, [wCurIcon]
	ld l, a
	ld a, [wCurIconForm]
	ld h, a
	call GetIconPointerFromIndex ; b = bank, hl = src
	ld d, h
	ld e, l
	pop hl
	ld c, 4
	call Get2bpp
	jp PopBCDEHL

GetStorageMask::
; Builds a silhouette "shadow" version of the current icon at hl + 4 tiles.
	push hl
	push de
	push bc
	ld bc, 4 tiles
	add hl, bc
	push hl
	ld a, [wCurIcon]
	ld l, a
	ld a, [wCurIconForm]
	ld h, a
	call GetIconPointerFromIndex ; b = bank, hl = src
	; Build the mask in wDecompressScratch: each row byte pair becomes
	; (plane0 | plane1) in both planes, i.e. a solid silhouette.
	ldh a, [rSVBK]
	ld d, a
	push de
	ld a, BANK("Scratch RAM")
	ldh [rSVBK], a
	ld de, wDecompressScratch
	ld c, 4 * 8 ; rows in 4 tiles
.loop
	push bc
	ld a, b
	call GetFarByte
	inc hl
	ld c, a
	ld a, b
	call GetFarByte
	inc hl
	pop bc
	or c
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop de
	ld a, d
	ldh [rSVBK], a
	pop hl
	; copy the mask to VRAM
	ld de, wDecompressScratch
	ldh a, [hROMBank]
	ld b, a
	ld c, 4
	call Get2bpp
	jp PopBCDEHL

; ============================================================
; Palette helpers
; ============================================================

GetMonPalInBCDE::
; bc = 16-bit species index (b = high; PC_EGG_INDEX for eggs)
; a = shiny/gender flags byte (MON_SHINY_FLAG set = shiny)
; Returns the mon's two middle palette colors in b,c,d,e.
	ld h, b
	ld l, c
	push af
	ld a, h
	cp HIGH(PC_EGG_INDEX)
	jr nz, .not_egg
	ld a, l
	cp LOW(PC_EGG_INDEX)
	jr z, .egg
.not_egg
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, PokemonPalettes
	add hl, bc
	pop af
	and MON_SHINY_FLAG
	jr z, .got_pal
	ld bc, 4
	add hl, bc
.got_pal
	ld a, BANK(PokemonPalettes)
	call GetFarByte
	ld c, a
	inc hl
	ld a, BANK(PokemonPalettes)
	call GetFarByte
	ld b, a
	inc hl
	ld a, BANK(PokemonPalettes)
	call GetFarByte
	ld e, a
	inc hl
	ld a, BANK(PokemonPalettes)
	call GetFarByte
	ld d, a
	ret

.egg
	pop af
	ld hl, .EggPal
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ret

.EggPal:
	RGB 23, 23, 16
	RGB 15, 14, 10

GetShininess::
; Returns nz if the mon in wTempMon is shiny.
	ld a, [wTempMonUnused]
	and MON_SHINY_FLAG
	ret

VaryBGPalByTempMonDVs::
	ret

SetDefaultBGPAndOBP::
	ld a, %11100100
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	; fallthrough
BillsPC_CommitPals::
; Copy wBGPals1/wOBPals1 to the vblank commit buffers (wBGPals2/wOBPals2)
; and request a hardware update. Polished's engine has no double buffer;
; Crimson's vblank commits wBGPals2, so skipping this leaves pals white.
	push hl
	push de
	push bc
	ld hl, wBGPals1
	ld de, wBGPals2
	ld bc, 16 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	ld a, 1
	ldh [hCGBPalUpdate], a
	jp PopBCDEHL

; ============================================================
; Menu / text helpers
; ============================================================

NoYesBox::
; TODO: cursor should default to "No" like Polished Crystal.
	jp YesNoBox

CreateBoxBorders::
; Draws a box at hl with the 9-byte tile template at de.
; b/c = inner height/width.
	ld a, SCREEN_WIDTH

	; Top
	call .PlaceRow
	jr .row

.row_loop
	dec de
	dec de
	dec de
.row
	call .PlaceRow
	dec b
	jr nz, .row_loop

	; Bottom row (fallthrough)

.PlaceRow:
	push af
	push hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	call .PlaceChars
	ld a, [de]
	inc de
	ld [hl], a
	pop hl
	pop af
	push bc
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ret

.PlaceChars:
; Place char a c times.
	push bc
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	ret

PlaceVWFString::
; Fixed-width stand-in for Polished's variable-width font renderer.
; Renders up to 10 characters of the string at de into the 2bpp tile
; buffer at hl (black text, ends at "@").
	push hl
	push de
	push bc
	ld b, 10
.char_loop
	ld a, [de]
	inc de
	cp "@"
	jr z, .done
	push de
	push bc
	push hl
	; glyph source: Font + (char - $80) * 8, 1bpp
	sub $80
	jr c, .blank_glyph
	ld l, a
	ld h, 0
rept 3
	add hl, hl
endr
	ld de, Font
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	ld c, 8
.glyph_loop
	ld a, BANK(Font)
	call GetFarByte
	inc de
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .glyph_loop
	jr .next_char
.blank_glyph
	pop hl
	push hl
	xor a
	ld c, 16
.blank_loop
	ld [hli], a
	dec c
	jr nz, .blank_loop
.next_char
	pop hl
	ld bc, 1 tiles
	add hl, bc
	pop bc
	pop de
	dec b
	jr nz, .char_loop
.done
	jp PopBCDEHL

PlaceFrontpicAtHL::
; Writes the 7x7 frontpic tilemap (tiles 0-48, column-major) at hl.
	xor a
	ld de, SCREEN_WIDTH
	ld b, 7
.row
	ld c, 7
	push af
	push hl
.col
	ld [hli], a
	add 7
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop af
	inc a
	dec b
	jr nz, .row
	ret

_OpenTempmonSummary::
; Opens the stats screen for the mon in wTempMon.
	ld a, [wTempMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ld [wTempSpecies], a
	ld a, TEMPMON
	ld [wMonType], a
	predef StatsScreenInit
	ret

BillsPC_HeldItemIcons:: INCBIN "gfx/pc/held_item_icons.2bpp"

; Sprite animation sequence handlers (called from DoAnimFrame stubs)
BillsPC_AnimSeq_PcCursor::
	; Switch frameset ID depending on item mode setting.
	call BillsPC_CheckBagDisplay
	ld a, SPRITE_ANIM_FRAMESET_PC_CURSOR_ITEM
	jr z, .pc_got_frameset
	dec a ; SPRITE_ANIM_FRAMESET_PC_CURSOR
.pc_got_frameset
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

	; Check for static cursor
	ld a, [wBillsPC_CursorAnimFlag]
	and a
	ret z

	; If we're picking up, the PC UI handles this flag.
	cp PCANIM_PICKUP
	jr c, .pc_not_picking
	sub PCANIM_PICKUP - 1
	add [hl]
	ld [hl], a
	ret
.pc_not_picking
	cp PCANIM_ANIMATE / 2 + 1
	jr c, .pc_dont_bop
	inc [hl]
	inc [hl]
.pc_dont_bop
	dec a
	ld [wBillsPC_CursorAnimFlag], a
	ret nz
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a
	ret

BillsPC_AnimSeq_PcQuick::
	; Moves a storage system mini from one destination to another.
	push de

	; Check if the animation has concluded
	ld hl, wBillsPC_QuickFrames
	inc [hl]
	dec [hl]
	jr z, .pc_finish_anim
	dec [hl]

	; Handle x movement.
	ld a, [wBillsPC_QuickFromX]
	ld d, a
	ld a, [wBillsPC_QuickToX]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	call BillsPC_AnimSeq_ShiftPos
	ld a, [wBillsPC_QuickFromY]
	ld d, a
	ld a, [wBillsPC_QuickToY]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	call BillsPC_AnimSeq_ShiftPos
	jr .pc_quick_done

.pc_finish_anim
	call BillsPC_FinishQuickAnim
	; fallthrough
.pc_quick_done
	pop de
	ret

BillsPC_AnimSeq_ShiftPos:
	; Set sprite position depending on movement frame.
	push hl
	push bc

	; Compute the difference between the coordinates
	ld a, d
	sub e

	; Load the result into bc. This sets b to $ff on a negative result.
	ld c, a
	sbc a
	ld b, a

	; Multiply by the frame number.
	xor a
	ld h, a
	ld l, a
	ld a, [wBillsPC_QuickFrames]
	inc a
.pc_shift_loop
	dec a
	jr z, .pc_got_multiplier
	add hl, bc
	jr .pc_shift_loop
.pc_got_multiplier
	; Divide by 8 and put 8bit result in a.
	ld a, l
	sra h
	rra
	sra h
	rra
	sra h
	rra

	; Get resulting coordinate.
	add e

	; Write to sprite anim coord.
	pop bc
	pop hl
	add hl, bc
	ld [hl], a
	ret

BillsPC_AnimSeq_PcMode::
	ld a, [wBillsPC_CursorMode]
	ld h, a
	add h
	add h
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

BillsPC_AnimSeq_PcPack::
	; Hide pack outside Item mode
	call BillsPC_CheckBagDisplay
	ld a, $80 ; move it out of view
	jr nz, .pc_got_pack_y
	xor a
.pc_got_pack_y
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

