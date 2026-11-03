; Four independent HUD colors without borrowing move-info or Pokemon palettes:
; enemy types = palette 5 colors 1/2, player types = palette 5 color 3 and
; EXP palette color 1 (unused by the EXP bar and shiny star).
; Bank-1 BG tiles $60-$63 do not overlap battle pictures or ability banners.

DrawPlayerHUDBorderWithTypes::
	farcall DrawPlayerHUDBorder
	hlcoord 10, 8
	ld a, $62
	ld [hli], a
	inc a
	ld [hl], a
	jp RefreshBattleTypeIcons

DrawEnemyHUDBorderWithTypes::
	farcall DrawEnemyHUDBorder
	hlcoord 2, 1
	ld a, $60
	ld [hli], a
	inc a
	ld [hl], a
	jp RefreshBattleTypeIcons

GetPlayerHUDTypes:
	farcall GetPlayerIllusionSlot
	jr z, .real
	ld a, [wBattleMonSpecies]
	ld b, a
	farcall OverridePlayerIllusionAppearance
	jr GetDisguisedHUDTypes
.real
	ld a, [wBattleMonType1]
	ld b, a
	ld a, [wBattleMonType2]
	ld c, a
	ret

GetEnemyHUDTypes:
	farcall GetEnemyIllusionSlot
	jr z, .real
	ld a, [wEnemyMonSpecies]
	ld b, a
	farcall OverrideEnemyIllusionAppearance
	jr GetDisguisedHUDTypes
.real
	ld a, [wEnemyMonType1]
	ld b, a
	ld a, [wEnemyMonType2]
	ld c, a
	ret

GetDisguisedHUDTypes:
; Respect this save's typing selection without altering the real base data.
	ld a, b
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	farcall GetGameplayTypesByIndex
	ld b, l
	ld c, h
	ret

RefreshBattleTypeIcons::
	ldh a, [hCGB]
	and a
	ret z
	call GetEnemyHUDTypes
	ld de, vTiles2 tile $60
	ld a, 1
	call LoadHUDTypePair
	call GetPlayerHUDTypes
	ld de, vTiles2 tile $62
	ld a, 3
	call LoadHUDTypePair
	call RefreshBattleTypeIconPals
	jp RestoreBattleTypeIconAttrs

LoadHUDTypePair:
; b/c = type pair, a = primary pixel color, de = first bank-1 tile.
	push bc
	push af
	ld c, a
	ld a, b
	call LoadHUDTypeTile
	pop af
	pop bc
	; A single type has an empty second slot, including after a switch.
	push af
	ld a, b
	cp c
	ld a, c
	jr nz, .second
	ld a, BIRD ; reserved blank art
.second
	ld b, a
	pop af
	inc a
	and 3 ; player secondary uses color 1, not color 0
	jr nz, .color
	inc a
.color
	ld c, a
	ld a, b
	; fall through

LoadHUDTypeTile:
; a = type, c = color index, de = bank-1 tile; returns de += 16.
	cp TYPES_END
	jr c, .valid
	ld a, BIRD
.valid
	ld hl, BattleHUDTypeGFX
	ld b, 0
	push bc
	ld bc, LEN_1BPP_TILE
	call AddNTimes
	pop bc
	ld b, 8
.row
	ld a, [hli]
	push hl
	ld l, a
	bit 0, c
	jr nz, .low
	xor a
.low
	call WriteHUDTypeTileByte
	ld a, l
	bit 1, c
	jr nz, .high
	xor a
.high
	call WriteHUDTypeTileByte
	pop hl
	dec b
	jr nz, .row
	ret

WriteHUDTypeTileByte:
; Keep VRAM bank 1 confined to an atomic safe write. VBlank always sees bank 0.
	push af
	di
.wait
	ldh a, [rSTAT]
	and 1 << 1 ; mode 2/3: VRAM may be inaccessible
	jr nz, .wait
	ld a, 1
	ldh [rVBK], a
	pop af
	ld [de], a
	xor a
	ldh [rVBK], a
	ei
	inc de
	ret

RefreshBattleTypeIconPals::
; Also called after default animation palettes are reloaded. Copy only our
; four colors to both buffers; never reset a Pokemon or move-info palette.
	ldh a, [hCGB]
	and a
	ret z
	call GetEnemyHUDTypes
	push bc
	ld a, b
	ld de, wBGPals1 palette PAL_BATTLE_BG_5 color 1
	call CopyHUDTypeColor
	pop bc
	ld a, c
	ld de, wBGPals1 palette PAL_BATTLE_BG_5 color 2
	call CopyHUDTypeColor
	call GetPlayerHUDTypes
	push bc
	ld a, b
	ld de, wBGPals1 palette PAL_BATTLE_BG_5 color 3
	call CopyHUDTypeColor
	pop bc
	ld a, c
	ld de, wBGPals1 palette PAL_BATTLE_BG_EXP color 1
	call CopyHUDTypeColor
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

CopyHUDTypeColor:
	cp TYPES_END
	jr c, .valid
	ld a, BIRD
.valid
	ld hl, BattleHUDTypeColors
	ld bc, PAL_COLOR_SIZE
	call AddNTimes
	push hl
	push de
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	pop hl
	ld bc, wBGPals2 - wBGPals1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, PAL_COLOR_SIZE
	ld a, BANK(wBGPals2)
	jp FarCopyWRAM

RestoreBattleTypeIconAttrs::
; Check tile IDs so pre-entry trainer/party HUDs are left alone. Repair both
; buffers and VRAM after ability banners, full layouts and menu returns.
	ld hl, .Cells
	ld b, 4
.cell
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	ld c, a
	ld a, [hli]
	cp c
	ld a, [hli]
	jr nz, .next
	push hl
	push af
	ld hl, wAttrMap - wTileMap
	add hl, de
	pop af
	ld [hl], a
	ld c, a
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, c
	call WriteHUDTypeTileByte
	jr .done_cell
.next
	inc hl
	inc hl
.done_cell
	pop bc
	dec b
	jr nz, .cell
	ret
.Cells
	dw wTileMap + 1 * SCREEN_WIDTH + 2
	db $60, PAL_BATTLE_BG_5 | VRAM_BANK_1
	dw vBGMap0 + 1 * BG_MAP_WIDTH + 2
	dw wTileMap + 1 * SCREEN_WIDTH + 3
	db $61, PAL_BATTLE_BG_5 | VRAM_BANK_1
	dw vBGMap0 + 1 * BG_MAP_WIDTH + 3
	dw wTileMap + 8 * SCREEN_WIDTH + 10
	db $62, PAL_BATTLE_BG_5 | VRAM_BANK_1
	dw vBGMap0 + 8 * BG_MAP_WIDTH + 10
	dw wTileMap + 8 * SCREEN_WIDTH + 11
	db $63, PAL_BATTLE_BG_EXP | VRAM_BANK_1
	dw vBGMap0 + 8 * BG_MAP_WIDTH + 11

BattleHUDTypeGFX:
	INCBIN "gfx/battle_type_icons/normal.1bpp"
	INCBIN "gfx/battle_type_icons/fighting.1bpp"
	INCBIN "gfx/battle_type_icons/flying.1bpp"
	INCBIN "gfx/battle_type_icons/poison.1bpp"
	INCBIN "gfx/battle_type_icons/ground.1bpp"
	INCBIN "gfx/battle_type_icons/rock.1bpp"
	ds LEN_1BPP_TILE, 0 ; BIRD
	INCBIN "gfx/battle_type_icons/bug.1bpp"
	INCBIN "gfx/battle_type_icons/ghost.1bpp"
	INCBIN "gfx/battle_type_icons/steel.1bpp"
	ds (UNUSED_TYPES_END - UNUSED_TYPES) * LEN_1BPP_TILE, 0
	INCBIN "gfx/battle_type_icons/fire.1bpp"
	INCBIN "gfx/battle_type_icons/water.1bpp"
	INCBIN "gfx/battle_type_icons/grass.1bpp"
	INCBIN "gfx/battle_type_icons/electric.1bpp"
	INCBIN "gfx/battle_type_icons/psychic.1bpp"
	INCBIN "gfx/battle_type_icons/ice.1bpp"
	INCBIN "gfx/battle_type_icons/dragon.1bpp"
	INCBIN "gfx/battle_type_icons/dark.1bpp"
	INCBIN "gfx/battle_type_icons/fairy.1bpp"
	assert @ - BattleHUDTypeGFX == TYPES_END * LEN_1BPP_TILE

BattleHUDTypeColors:
INCLUDE "gfx/battle_type_icons/colors.pal"
	assert @ - BattleHUDTypeColors == TYPES_END * PAL_COLOR_SIZE

; Relocated from the full graphics bank to leave room for palette hooks.
BattleScreenLayoutWithTypes::
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, PAL_BATTLE_BG_ENEMY_HP
	call ByteFill
	hlcoord 0, 4, wAttrMap
	lb bc, 8, 10
	ld a, PAL_BATTLE_BG_PLAYER
	call FillBoxWithByte
	hlcoord 10, 0, wAttrMap
	lb bc, 7, 10
	ld a, PAL_BATTLE_BG_ENEMY
	call FillBoxWithByte
	; (Removed a redundant re-fill of rows 0-3, cols 0-9 with PAL_BATTLE_BG_ENEMY_HP;
	;  the full-screen ByteFill above already set that region to ENEMY_HP, and nothing
	;  overwrites it in between. Freed space keeps bank2 within its 0x4000 limit.)
	hlcoord 10, 7, wAttrMap
	lb bc, 5, 10
	ld a, PAL_BATTLE_BG_PLAYER_HP
	call FillBoxWithByte
	hlcoord 10, 11, wAttrMap
	lb bc, 1, 9
	ld a, PAL_BATTLE_BG_EXP
	call FillBoxWithByte
	hlcoord 1, 9, wAttrMap
	lb bc, 1, 6
	ld a, PAL_BATTLE_BG_TYPE_CAT
	call FillBoxWithByte
	hlcoord 0, 12, wAttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, PAL_BATTLE_BG_TEXT
	call ByteFill
	; Recolor the two shiny star icon tiles blue (exp bar palette). These tiles
	; are blank unless the mon is shiny, so this is invisible for normal mons.
	ld a, PAL_BATTLE_BG_EXP
	ld [wAttrMap + 1 * SCREEN_WIDTH + 4], a
	ld [wAttrMap + 8 * SCREEN_WIDTH + 12], a
	call RefreshBattleTypeIcons
	farcall ApplyAttrMap
	ret
