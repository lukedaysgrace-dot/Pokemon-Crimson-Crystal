; Menu weather icons adapted from CrystalShireEngine (aaronjeter),
; GetWeatherImage and gfx/battle/weather. Only menu-time OBJ tiles/OAM
; are used: ability banners and the battle background remain untouched.

DrawBattleWeatherIndicator::
; The lower-left space beside the command/move list is free in the ordinary
; battle menus. Show effective weather; Cloud Nine keeps the underlying
; weather/timer, but suppresses its effects and therefore hides its icon.
; Uses OBJ tiles 0-3 and OAM entries 0-3 until the menu closes.
	call ClearBattleWeatherIndicatorOAM
	ld a, [wBattleWeather]
	bit WEATHER_SUPPRESSED_F, a
	jp nz, CommitBattleWeatherIndicator
	and WEATHER_TYPE_MASK
	dec a
	cp WEATHER_HAIL
	jp nc, CommitBattleWeatherIndicator ; no weather, or an end-message value
	ld hl, .Images
	ld bc, 3
	call AddNTimes
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	push af ; OBJ palette
	ld hl, vTiles0
	lb bc, BANK(BattleWeatherImages), 4
	call Request2bpp
	pop af
	ld b, a
	ld hl, wVirtualOAM
	ld de, .Positions
	ld c, 4
.sprite
	ld a, [de]
	inc de
	ld [hli], a ; y
	ld a, [de]
	inc de
	ld [hli], a ; x
	dec c
	ld a, c
	ld [hli], a ; tile 3, 2, 1, 0 (reverse positions below)
	ld a, b
	ld [hli], a ; default battle OBJ palette, VRAM bank 0
	jr nz, .sprite
	jp CommitBattleWeatherIndicator

.Images:
	dw BattleRainIcon
	db PAL_BATTLE_OB_BLUE
	dw BattleSunIcon
	db PAL_BATTLE_OB_YELLOW
	dw BattleSandIcon
	db PAL_BATTLE_OB_BROWN
	dw BattleHailIcon
	db PAL_BATTLE_OB_BLUE

.Positions:
; OAM coordinates: screen (12, 112), 16x16 pixels. No overlap with the
; move info box above, the move list to the right, or the menu cursor.
	db 136, 28 ; bottom right
	db 136, 20 ; bottom left
	db 128, 28 ; top right
	db 128, 20 ; top left

ClearBattleWeatherIndicator::
; Battle menus normally freeze hardware OAM (hOAMUpdate = 1). Commit both
; drawing and clearing for one VBlank, restoring that flag immediately.
	call ClearBattleWeatherIndicatorOAM
CommitBattleWeatherIndicator:
	ldh a, [hOAMUpdate]
	push af
	xor a
	ldh [hOAMUpdate], a
	call DelayFrame
	pop af
	ldh [hOAMUpdate], a
	ret

ClearBattleWeatherIndicatorOAM:
; Leave every other OAM entry intact; also clears stale/expired weather.
	ld hl, wVirtualOAM
	ld b, 4 * SPRITEOAMSTRUCT_LENGTH
	xor a
.clear
	ld [hli], a
	dec b
	jr nz, .clear
	ret

BattleWeatherImages:
BattleRainIcon:
	INCBIN "gfx/battle/weather/rain_icon.2bpp"
	assert @ - BattleRainIcon == 4 tiles
BattleSunIcon:
	INCBIN "gfx/battle/weather/sun_icon.2bpp"
	assert @ - BattleSunIcon == 4 tiles
BattleSandIcon:
	INCBIN "gfx/battle/weather/sand_icon.2bpp"
	assert @ - BattleSandIcon == 4 tiles
BattleHailIcon:
	INCBIN "gfx/battle/weather/hail_icon.2bpp"
	assert @ - BattleHailIcon == 4 tiles
