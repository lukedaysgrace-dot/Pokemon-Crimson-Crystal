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

	; Fill the banner tiles with the solid band and upload them. The BGMap
	; cells still point at the scene, so nothing shows yet.
	call FillBannerSolid
	call ApplyAbilityTiles
	; Back up the original attributes under the banner (for dismissal).
	call BackupBannerAttrs

	ld de, SFX_ABILITYSLIDEOUT
	call WaitPlaySFX

	; Slide the solid band in, one column per frame. Each column is engaged
	; with a single atomic BGMap write - the cell flips straight from the
	; real scene to (solid banner tile + text palette) in one hblank, so it
	; is never shown as a solid tile under the battler's own (blue) palette.
	call SlideInBanner

	; Carve the text out of the band
	call .DrawBannerText

	pop af
	ldh [rSVBK], a
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

FillBannerSolid:
; Fill the whole banner buffer (32 tiles) with the solid band.
; Assumes rSVBK = BANK(wAbilityTiles).
	ld hl, wAbilityTiles
	ld bc, SLIDEOUT_WIDTH * 2 * LEN_2BPP_TILE
	ld a, $ff
.loop
	ld [hli], a
	dec bc
	ld a, b
	or c
	ld a, $ff
	jr nz, .loop
	ret

BackupBannerAttrs:
; Save the original attribute of every cell under the banner, row-major, to
; match DismissAbilityOverlays' read order, so dismissal can restore the
; scene's palette. Does NOT change the cells. rSVBK = BANK(wAbilityTiles).
	call GetBannerLayout ; hl = wTilemap anchor; resets the backup cursor
	ld c, SLIDEOUT_WIDTH * 2
.loop
	push bc
	push hl
	ld de, wAttrMap - wTileMap
	add hl, de
	ld a, [hl]
	call BannerBackupPut
	pop hl
	pop bc
	inc hl
	dec c
	jr z, .done
	ld a, c
	cp SLIDEOUT_WIDTH
	jr nz, .loop
	; step hl from the end of row 0 to the start of row 1 (20-wide map)
	ld a, SCREEN_WIDTH - SLIDEOUT_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	jr .loop
.done
	ret

SlideInBanner:
; Reveal the solid band one column per frame, engaging each column with a
; single atomic BGMap write. Player wipes left-to-right, enemy right-to-left.
; rSVBK = BANK(wAbilityTiles).
	ld d, 0 ; column step
.loop
	ldh a, [hBattleTurn]
	and a
	ld a, d
	jr z, .got_col
	ld a, SLIDEOUT_WIDTH - 1
	sub d
.got_col
	push de
	call EngageBannerColumn
	call DelayFrame
	pop de
	inc d
	ld a, d
	cp SLIDEOUT_WIDTH
	jr c, .loop
	ret

EngageBannerColumn:
; a = column (0..SLIDEOUT_WIDTH-1). Atomically engage both banner rows of
; this column: point the BGMap cell at the solid banner tile with the text
; palette (one hblank per cell) and mirror the change into wTilemap/wAttrMap.
; Preserves all registers. rSVBK = BANK(wAbilityTiles).
	push af
	push bc
	push de
	push hl
	ld c, a ; column
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	hlcoord 0, 8
	ld de, vBGMap0 + 8 * BG_MAP_WIDTH + 0
	ld a, SLIDEOUT_START_TILE + SLIDEOUT_WIDTH * 2
	jr .got_anchor
.enemy
	hlcoord 4, 3
	ld de, vBGMap0 + 3 * BG_MAP_WIDTH + 4
	ld a, SLIDEOUT_START_TILE
.got_anchor
	add c
	ld b, a ; b = row-0 banner tile id for this column
	; hl += column (wTilemap cell), de += column (BGMap cell)
	ld a, l
	add c
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, e
	add c
	ld e, a
	adc d
	sub e
	ld d, a
	; row 0
	call .cell
	; advance to row 1: tile += 16, wTilemap += 20, BGMap += 32
	ld a, b
	add SLIDEOUT_WIDTH
	ld b, a
	ld a, l
	add SCREEN_WIDTH
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, e
	add BG_MAP_WIDTH
	ld e, a
	adc d
	sub e
	ld d, a
	call .cell
	pop hl
	pop de
	pop bc
	pop af
	ret

.cell:
; hl = wTilemap cell, de = BGMap cell, b = banner tile id.
	ld [hl], b ; wTilemap -> banner tile id
	push hl
	push de
	push bc
	ld bc, wAttrMap - wTileMap
	add hl, bc
	ld a, PAL_BATTLE_BG_TEXT | VRAM_BANK_1 | PRIORITY
	ld [hl], a ; wAttrMap -> text attr
	pop bc
	ld c, a ; attr for the atomic write
	pop de
	pop hl
	call WriteBGCellAtomic ; BGMap <- (tile b, attr c) in one hblank
	ret

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
	call DismissAbilityOverlaySide
	ld a, 1
	ldh [hBattleTurn], a
	call DismissAbilityOverlaySide
	pop af
	ldh [hBattleTurn], a
	pop af
	ldh [hBGMapMode], a
	; Scene tiles are restored above. Rebuild only the battle BG attribute
	; map so stale banner attrs do not tint the HUD/sprites; do not run
	; SCGB_BATTLE_COLORS here, since it also reloads mon palettes from temp
	; species slots that can be stale during ability/move handoff.
	call RestoreBattleAttrMapNoPalettes
	pop af
	ldh [rSVBK], a
	pop bc
	pop de
	pop hl
	ret

RestoreBattleAttrMapNoPalettes:
	ldh a, [hCGB]
	and a
	ret z
	; Same battle regions as _CGB_FinishBattleScreenLayout, minus palette data.
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, PAL_BATTLE_BG_ENEMY_HP
	call ByteFill
	hlcoord 0, 4, wAttrMap
	lb bc, 8, 10
	ld a, PAL_BATTLE_BG_PLAYER
	call .FillBox
	hlcoord 10, 0, wAttrMap
	lb bc, 7, 10
	ld a, PAL_BATTLE_BG_ENEMY
	call .FillBox
	hlcoord 0, 0, wAttrMap
	lb bc, 4, 10
	ld a, PAL_BATTLE_BG_ENEMY_HP
	call .FillBox
	hlcoord 10, 7, wAttrMap
	lb bc, 5, 10
	ld a, PAL_BATTLE_BG_PLAYER_HP
	call .FillBox
	hlcoord 10, 11, wAttrMap
	lb bc, 1, 9
	ld a, PAL_BATTLE_BG_EXP
	call .FillBox
	hlcoord 0, 12, wAttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, PAL_BATTLE_BG_TEXT
	call ByteFill
	farcall ApplyAttrMap
	ret

.FillBox:
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
DismissAbilityOverlaySide:
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
