; Ability slideout banner.
; Fixed-width port of Polished Crystal's engine/battle/ability_gfx.asm.
;
; The banner is a 2-row band that slides across the battler's side of the
; screen, then reveals "<MON>'s" / "<ABILITY>" cut out of the band.
; Banner tile graphics live in VRAM bank 1 (enemy $c0-$df, player $e0-$ff),
; so they never conflict with the battle scene tiles.
;
; All BGMap engagement/dismissal is done with per-cell ATOMIC writes: a
; cell's tile id and its attribute are written inside the same hblank, so
; there is never a visible frame where the tile id and the bank attribute
; mismatch (that mismatch was the source of the old garbage flash, because
; WaitBGMap2 pushed the attr map and the tilemap on different frames).
; Dismissal restores the scene tiles from wTempTileMap and the exact
; original attributes from a backup taken at engagement - no palette
; reloads, no full-map pushes, no flash.

PerformAbilityGFX::
; b = ability constant to display. hBattleTurn = which side.
	push bc
	call GetAbilityName ; ability name -> wStringBuffer1
	call GetAbilityGFXPkmnName ; "<MON>'s" -> wStringBuffer2
	pop bc

	ldh a, [rSVBK]
	push af

	; wStringBuffer1/2 are in WRAM bank 1; copy them into our bank
	ld hl, wStringBuffer2
	ld de, wAbilityPkmn
	call CopyStringToAbilityBank
	ld hl, wStringBuffer1
	ld de, wAbilityName
	call CopyStringToAbilityBank

	ld a, BANK(wAbilityTiles)
	ldh [rSVBK], a

	; Copy the scene graphics under the banner into wAbilityTiles
	call .CopyTilesToWRAM
	; Upload them to the banner tiles (no visible change yet)
	call ApplyAbilityTiles
	; Point the cells at the banner tiles - atomic, invisible
	call EngageBannerCells

	ld de, SFX_ABILITYSLIDEOUT
	call WaitPlaySFX

	; Slide the band across, one column per frame
	call .OverlaySlideout

	; Switch the banner cells to the text palette
	ld b, PAL_BATTLE_BG_TEXT
	call SetBannerCellsPalette

	; Carve the text out of the band
	call .DrawBannerText

	pop af
	ldh [rSVBK], a
	ret

.CopyTilesToWRAM:
; Read the tile graphics currently shown in the banner area into wAbilityTiles.
	ldh a, [hBattleTurn]
	and a
	decoord 0, 8
	jr z, .got_start_coord
	decoord 4, 3
.got_start_coord
	ld hl, wAbilityTiles
	ld b, 2
.copy_outer
	ld c, SLIDEOUT_WIDTH
.copy_inner
	push bc
	ld a, [de] ; tile id from wTilemap
	inc de
	push de
	; src VRAM address = vTiles1 + (id ^ $80) * LEN_2BPP_TILE
	xor $80
	push hl
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld bc, vTiles1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	; copy one tile VRAM -> WRAM (bank 0)
	ld c, LEN_2BPP_TILE
	call SafeCopyVRAMToWRAM
	pop de
	pop bc
	dec c
	jr nz, .copy_inner
	push hl
	ld hl, SCREEN_WIDTH - SLIDEOUT_WIDTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	dec b
	jr nz, .copy_outer
	ret
.OverlaySlideout:
	ld d, 0 ; column step
.slide_loop
	; player slides left to right; enemy right to left
	ldh a, [hBattleTurn]
	and a
	ld a, d
	jr z, .got_column
	ld a, SLIDEOUT_WIDTH - 1
	sub d
.got_column
	push de
	push af
	; fill buffer column a (both rows) with the solid band
	call .FillColumn
	pop af
	; upload the two changed tiles
	call UploadBannerColumn
	call DelayFrame
	pop de
	inc d
	ld a, d
	cp SLIDEOUT_WIDTH
	jr c, .slide_loop
	ret

.FillColumn:
; a = column; fill tiles a and a+SLIDEOUT_WIDTH of wAbilityTiles with $ff
	push af
	call .fill_one
	pop af
	add SLIDEOUT_WIDTH
.fill_one
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld bc, wAbilityTiles
	add hl, bc
	ld c, LEN_2BPP_TILE
	ld a, $ff
.fill_loop
	ld [hli], a
	dec c
	jr nz, .fill_loop
	ret

.DrawBannerText:
	ld de, wAbilityPkmn
	ld b, 0 ; row 0: pokemon name
	call .DrawRow
	ld de, wAbilityName
	ld b, 1 ; row 1: ability name
.DrawRow:
	; count length (capped at SLIDEOUT_WIDTH)
	push de
	ld c, 0
.len_loop
	ld a, [de]
	inc de
	cp "@"
	jr z, .got_len
	inc c
	ld a, c
	cp SLIDEOUT_WIDTH
	jr c, .len_loop
.got_len
	pop de
	; center: start tile = row * SLIDEOUT_WIDTH + (SLIDEOUT_WIDTH - len) / 2
	ld a, SLIDEOUT_WIDTH
	sub c
	srl a
	bit 0, b
	jr z, .got_offset
	add SLIDEOUT_WIDTH
.got_offset
	ld b, a ; b = tile index within banner
.char_loop
	ld a, c
	and a
	ret z
	ld a, [de]
	inc de
	cp "@"
	ret z
	push bc
	push de
	; dest = wAbilityTiles + b * 16
	push af
	ld l, b
	ld h, 0
rept 4
	add hl, hl
endr
	push hl
	ld bc, wAbilityTiles
	add hl, bc
	ld d, h
	ld e, l
	pop hl ; unused
	pop af
	call RenderBannerChar
	pop de
	pop bc
	; upload this tile
	push bc
	push de
	ld a, b
	call UploadBannerTile
	pop de
	pop bc
	; small reveal delay every other character
	ld a, c
	and %1
	push bc
	push de
	call z, DelayFrame
	pop de
	pop bc
	inc b
	dec c
	jr .char_loop

PerformAbilityReplacementGFX::
; Replace the ability name on the user's banner with ability b (Trace etc).
	push bc
	ld de, SFX_SWEET_KISS
	call PlaySFX
	pop bc
	call GetAbilityName ; -> wStringBuffer1
	ldh a, [rSVBK]
	push af
	ld hl, wStringBuffer1
	ld de, wAbilityName
	call CopyStringToAbilityBank
	ld a, BANK(wAbilityTiles)
	ldh [rSVBK], a
	; wipe the ability row (row 1) back to the solid band
	ld hl, wAbilityTiles + SLIDEOUT_WIDTH * LEN_2BPP_TILE
	ld bc, SLIDEOUT_WIDTH * LEN_2BPP_TILE
	ld a, $ff
.wipe_loop
	ld [hli], a
	dec bc
	ld a, b
	or c
	ld a, $ff
	jr nz, .wipe_loop
	; push the wiped band to VRAM first - DrawRow only uploads the tiles
	; it carves text into, so without this, glyphs of the old (longer)
	; name would linger on the flanks of the new one
	ld a, SLIDEOUT_WIDTH
.upload_loop
	push af
	call UploadBannerTile
	pop af
	inc a
	cp SLIDEOUT_WIDTH * 2
	jr c, .upload_loop
	; redraw and upload the row's text
	ld de, wAbilityName
	ld b, 1
	call PerformAbilityGFX.DrawRow
	call WaitSFX
	pop af
	ldh [rSVBK], a
	ret

CopyStringToAbilityBank:
; Copy an "@"-terminated string (max 17 chars) from hl in WRAM bank 1
; to de in the wAbilityTiles bank, toggling rSVBK per byte.
; Leaves rSVBK on WRAM bank 1.
	push bc
	ld c, 17 + 1
.loop
	ld a, 1
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, BANK(wAbilityTiles)
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	cp "@"
	jr z, .done
	dec c
	jr nz, .loop
	; unterminated: force-terminate
	dec de
	ld a, "@"
	ld [de], a
.done
	ld a, 1
	ldh [rSVBK], a
	pop bc
	ret

GetAbilityGFXPkmnName:
; Copy the user's nickname plus "'s" into wStringBuffer2.
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonNick
	jr z, .got_nick
	ld hl, wEnemyMonNick
.got_nick
	ld de, wStringBuffer2
	ld c, MON_NAME_LENGTH
.copy_loop
	ld a, [hli]
	cp "@"
	jr z, .append
	ld [de], a
	inc de
	dec c
	jr nz, .copy_loop
.append
	ld a, "'s"
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
	ret

RenderBannerChar:
; a = character, de = dest tile (16 bytes) in wAbilityTiles.
; Text is carved out of the solid band: glyph pixels become color 0.
	cp $80
	ret c ; space and control chars leave the band solid
	sub $80
	ld l, a
	ld h, 0
rept 3
	add hl, hl
endr
	ld bc, Font
	add hl, bc
	ld c, LEN_1BPP_TILE
.row_loop
	ld a, BANK(Font)
	call GetFarByte
	inc hl
	cpl
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .row_loop
	ret

UploadBannerColumn:
; a = column; upload buffer tiles a and a+SLIDEOUT_WIDTH to VRAM bank 1.
	push af
	call UploadBannerTile
	pop af
	add SLIDEOUT_WIDTH
	; fallthrough
UploadBannerTile:
; a = tile index within the banner (0-31); upload it to VRAM bank 1.
	push hl
	; offset = a * 16
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	push hl
	ld bc, wAbilityTiles
	add hl, bc
	ld d, h
	ld e, l ; de = src in WRAM
	pop hl
	ld bc, vTiles1 tile (SLIDEOUT_START_TILE ^ $80)
	add hl, bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_dest
	ld bc, SLIDEOUT_WIDTH * 2 * LEN_2BPP_TILE
	add hl, bc
.got_dest
	ld c, LEN_2BPP_TILE
	call SafeCopyWRAMToVRAM
	pop hl
	ret

ApplyAbilityTiles:
; Upload the whole banner buffer (32 tiles) for the current side.
	ld a, 0
.tile_loop
	push af
	call UploadBannerTile
	pop af
	inc a
	cp SLIDEOUT_WIDTH * 2
	jr c, .tile_loop
	ret

SafeCopyVRAMToWRAM:
; de = VRAM src, hl = WRAM dest, c = byte count. LCD-safe.
.loop
	di
	call WaitFreshHBlank
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr z, .done
	ld a, [de]
	ld [hli], a
	inc de
	ei
	dec c
	jr nz, .loop
	ret
.done
	ei
	ret

SafeCopyWRAMToVRAM:
; de = WRAM src, hl = VRAM dest in bank 1, c = byte count. LCD-safe.
; rVBK is only set inside the di window so interrupt handlers never run
; with the wrong VRAM bank selected.
.loop
	di
	call WaitFreshHBlank
	ld a, 1
	ldh [rVBK], a
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr z, .done
	ld a, [de]
	ld [hli], a
	inc de
	xor a
	ldh [rVBK], a
	ei
	dec c
	jr nz, .loop
	ret
.done
	xor a
	ldh [rVBK], a
	ei
	ret

WaitFreshHBlank:
; Return at the very start of an hblank (or during vblank's final lines).
	ldh a, [rLY]
	cp 144
	ret nc ; vblank: VRAM is free
.wait_busy
	ldh a, [rSTAT]
	and %11
	cp 3
	jr nz, .wait_busy
.wait_hblank
	ldh a, [rSTAT]
	and %11
	jr nz, .wait_hblank
	ret

; ==== Atomic BGMap banner cell management ================================

GetBannerLayout:
; For the current side: hl = wTilemap anchor, de = BGMap anchor,
; b = first banner tile id. Points wAbilityBackupPtr at this side's
; attribute backup. Assumes rSVBK = BANK(wAbilityTiles).
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	hlcoord 0, 8
	ld de, vBGMap0 + 8 * BG_MAP_WIDTH + 0
	ld a, LOW(wAbilityAttrBackup)
	ld [wAbilityBackupPtr], a
	ld a, HIGH(wAbilityAttrBackup)
	ld [wAbilityBackupPtr + 1], a
	ld b, SLIDEOUT_START_TILE + SLIDEOUT_WIDTH * 2
	ret
.enemy
	hlcoord 4, 3
	ld de, vBGMap0 + 3 * BG_MAP_WIDTH + 4
	ld a, LOW(wAbilityAttrBackup + SLIDEOUT_WIDTH * 2)
	ld [wAbilityBackupPtr], a
	ld a, HIGH(wAbilityAttrBackup + SLIDEOUT_WIDTH * 2)
	ld [wAbilityBackupPtr + 1], a
	ld b, SLIDEOUT_START_TILE
	ret

EngageBannerCells:
; Back up each banner cell's attribute, then point the cells at the
; banner tiles (VRAM bank 1) with per-cell atomic BGMap writes. The
; banner tiles hold a copy of the scene, so nothing changes on screen.
; Assumes rSVBK = BANK(wAbilityTiles).
	call GetBannerLayout
	; already engaged? then the backup is live - leave everything alone
	push hl
	push de
	ld de, wAttrMap - wTileMap
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	and VRAM_BANK_1
	ret nz
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	ld c, SLIDEOUT_WIDTH * 2
.cell_loop
	push bc
	; wTilemap cell <- banner tile id
	ld [hl], b
	; wAttrMap cell: back up the original, then set bank 1 + priority
	push hl
	push de
	ld de, wAttrMap - wTileMap
	add hl, de
	ld a, [hl]
	call BannerBackupPut
	or VRAM_BANK_1 | PRIORITY
	ld [hl], a
	pop de
	pop hl
	ld c, a
	; BGMap cell <- (tile id, attribute) in one hblank
	call WriteBGCellAtomic
	inc hl
	inc de
	pop bc
	inc b
	dec c
	jr z, .done
	ld a, c
	cp SLIDEOUT_WIDTH
	jr nz, .cell_loop
	call BannerAdvanceRowGap
	jr .cell_loop
.done
	pop af
	ldh [hBGMapMode], a
	ret

SetBannerCellsPalette:
; b = palette. Rewrite every banner cell's attribute with palette b,
; keeping VRAM bank 1 + priority. Atomic per-cell attribute writes.
; Assumes rSVBK = BANK(wAbilityTiles).
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	push bc
	call GetBannerLayout
	pop bc
	push bc
	ld bc, wAttrMap - wTileMap
	add hl, bc
	pop bc
	ld c, SLIDEOUT_WIDTH * 2
.cell_loop
	push bc
	ld a, [hl]
	and ~%111 ; clear palette bits
	or b
	or VRAM_BANK_1 | PRIORITY
	ld [hl], a
	ld c, a
	call WriteBGAttrAtomic
	inc hl
	inc de
	pop bc
	dec c
	jr z, .done
	ld a, c
	cp SLIDEOUT_WIDTH
	jr nz, .cell_loop
	call BannerAdvanceRowGap
	jr .cell_loop
.done
	pop af
	ldh [hBGMapMode], a
	ret

DismissAbilityOverlays::
; Retire the ability banners on both sides: restore the scene tiles
; (from wTempTileMap, saved at BeginAbility) and the original attributes
; (from the engagement backup) with per-cell atomic BGMap writes.
	push hl
	push de
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wAbilityTiles)
	ldh [rSVBK], a
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	call .DismissSide
	ld a, 1
	ldh [hBattleTurn], a
	call .DismissSide
	pop af
	ldh [hBattleTurn], a
	pop af
	ldh [hBGMapMode], a
	pop af
	ldh [rSVBK], a
	pop bc
	pop de
	pop hl
	ret

.DismissSide:
	; only if this side's banner is engaged (bank-1 bit at the anchor)
	ldh a, [hBattleTurn]
	and a
	hlcoord 0, 8, wAttrMap
	jr z, .got_anchor
	hlcoord 4, 3, wAttrMap
.got_anchor
	ld a, [hl]
	and VRAM_BANK_1
	ret z
	call GetBannerLayout
	ld c, SLIDEOUT_WIDTH * 2
.cell_loop
	push bc
	; scene tile from wTempTileMap -> wTilemap (and b)
	push hl
	push de
	ld de, wTempTileMap - wTileMap
	add hl, de
	ld b, [hl]
	pop de
	pop hl
	ld [hl], b
	; original attribute from the backup -> wAttrMap (and c)
	call BannerBackupGet
	ld c, a
	push hl
	push de
	ld de, wAttrMap - wTileMap
	add hl, de
	ld [hl], a
	pop de
	pop hl
	; BGMap cell <- (tile, attribute) in one hblank
	call WriteBGCellAtomic
	inc hl
	inc de
	pop bc
	dec c
	ret z
	ld a, c
	cp SLIDEOUT_WIDTH
	jr nz, .cell_loop
	call BannerAdvanceRowGap
	jr .cell_loop

BannerBackupPut:
; Append a to the attribute backup (advances wAbilityBackupPtr).
; Preserves all registers.
	push hl
	push af
	ld hl, wAbilityBackupPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld [hli], a
	push af
	ld a, l
	ld [wAbilityBackupPtr], a
	ld a, h
	ld [wAbilityBackupPtr + 1], a
	pop af
	pop hl
	ret

BannerBackupGet:
; a <- next byte from the attribute backup (advances wAbilityBackupPtr).
; Preserves all other registers.
	push hl
	ld hl, wAbilityBackupPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	push af
	ld a, l
	ld [wAbilityBackupPtr], a
	ld a, h
	ld [wAbilityBackupPtr + 1], a
	pop af
	pop hl
	ret

WriteBGCellAtomic:
; Write tile id b, then attribute c, to BGMap address de - both inside
; one hblank (or during vblank), so the cell never shows a tile id with
; a mismatched bank attribute. Preserves all registers.
	push af
	di
	call WaitFreshHBlank
	ld a, b
	ld [de], a
	ld a, 1
	ldh [rVBK], a
	ld a, c
	ld [de], a
	xor a
	ldh [rVBK], a
	ei
	pop af
	ret

WriteBGAttrAtomic:
; Write attribute c to BGMap address de. Preserves all registers.
	push af
	di
	call WaitFreshHBlank
	ld a, 1
	ldh [rVBK], a
	ld a, c
	ld [de], a
	xor a
	ldh [rVBK], a
	ei
	pop af
	ret

BannerAdvanceRowGap:
; Step hl (a 20-wide WRAM map pointer) and de (a 32-wide BGMap pointer)
; from the end of one banner row to the start of the next.
	ld a, SCREEN_WIDTH - SLIDEOUT_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, BG_MAP_WIDTH - SLIDEOUT_WIDTH
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	ret
