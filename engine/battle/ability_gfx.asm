; Ability slideout banner.
; Fixed-width port of Polished Crystal's engine/battle/ability_gfx.asm.
; The banner is a 2-row band that slides across the battler's side of the
; screen, then reveals "<MON>'s" / "<ABILITY>" cut out of the band.
; Banner tile graphics live in VRAM bank 1, so they never conflict with
; the battle scene tiles; the tilemap cells select them via attrmap bits.

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
	; Point the tilemap at the banner tiles, keeping current palettes
	call .WriteTilemap
	call WaitBGMap2

	ld de, SFX_ABILITYSLIDEOUT
	call WaitPlaySFX

	; Slide the band across, one column per frame
	call .OverlaySlideout

	; Switch the banner to the text palette
	ld b, PAL_BATTLE_BG_TEXT
	call SetUserAbilityOverlayAttributes
	call WaitBGMap2

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

.WriteTilemap:
	ldh a, [hBattleTurn]
	and a
	hlcoord 0, 8
	ld b, SLIDEOUT_START_TILE + SLIDEOUT_WIDTH * 2
	jr z, .got_tilemap_data
	hlcoord 4, 3
	ld b, SLIDEOUT_START_TILE
.got_tilemap_data
	call SetAbilityTilemap
	; matching attrmap region: keep palette, set vram bank 1 + priority
	ld bc, wAttrMap - wTileMap - SLIDEOUT_WIDTH - SCREEN_WIDTH
	add hl, bc
	ld b, -1 ; keep current palette
	jp SetAbilityOverlayAttributes

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
	; redraw and upload the whole row
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

SetAbilityTilemap:
; Write banner tile ids starting at b to the 2-row region at hl.
	call .do_tilemap_loop
	push bc
	ld bc, SCREEN_WIDTH - SLIDEOUT_WIDTH
	add hl, bc
	pop bc
.do_tilemap_loop
	ld c, SLIDEOUT_WIDTH
.tilemap_loop
	ld [hl], b
	inc hl
	inc b
	dec c
	jr nz, .tilemap_loop
	ret

SetUserAbilityOverlayAttributes::
; b = palette, or -1 to keep the current palette
	ldh a, [hBattleTurn]
	and a
	hlcoord 0, 8, wAttrMap
	jr z, SetAbilityOverlayAttributes
	hlcoord 4, 3, wAttrMap
	; fallthrough
SetAbilityOverlayAttributes:
; Set attributes for the 2-row banner region at hl: use VRAM bank 1,
; BG priority, and palette b (-1 = keep).
	call .do_attrmap_loop
	push bc
	ld bc, SCREEN_WIDTH - SLIDEOUT_WIDTH
	add hl, bc
	pop bc
.do_attrmap_loop
	ld c, SLIDEOUT_WIDTH
.attrmap_loop
	ld a, b
	inc a
	jr z, .no_pal_change
	ld a, [hl]
	and ~%111 ; clear palette bits
	or b
	ld [hl], a
.no_pal_change
	ld a, [hl]
	or VRAM_BANK_1 | PRIORITY
	ld [hl], a
	inc hl
	dec c
	jr nz, .attrmap_loop
	ret

ResetAbilityTilemap::
; Re-apply banner tilemap data for any active overlays (call after battle
; code redraws the tilemap, e.g. after a move animation).
	hlcoord 0, 8, wAttrMap
	ld a, [hl]
	and VRAM_BANK_1
	jr z, .check_enemy
	hlcoord 0, 8
	ld b, SLIDEOUT_START_TILE + SLIDEOUT_WIDTH * 2
	call SetAbilityTilemap
.check_enemy
	hlcoord 4, 3, wAttrMap
	ld a, [hl]
	and VRAM_BANK_1
	ret z
	hlcoord 4, 3
	ld b, SLIDEOUT_START_TILE
	jp SetAbilityTilemap

DismissAbilityOverlays::
; Dismiss the ability overlays on both sides and restore the scene.
	push hl
	push de
	push bc

	; restore the tilemap under both banner regions from wTempTileMap
	ldh a, [rSVBK]
	push af
	ld a, BANK(wTempTileMap)
	ldh [rSVBK], a
	hlcoord 0, 8
	call .reset_rows
	hlcoord 4, 3
	call .reset_rows
	pop af
	ldh [rSVBK], a

	; push the restored tiles first so the banner ids are gone from the
	; map before the attrs drop the bank-1 bit (avoids a garbage flash)
	call WaitBGMap
	; rebuild the battle attrmap (clears bank 1 + priority bits)
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	call WaitBGMap2

	pop bc
	pop de
	pop hl
	ret

.reset_rows
	call .reset_row
.reset_row
	ld d, h
	ld e, l
	push hl
	ld bc, wTempTileMap - wTileMap
	add hl, bc
	ld bc, SLIDEOUT_WIDTH
	call CopyBytes
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ret
