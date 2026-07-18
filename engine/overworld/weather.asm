; Daily overworld weather for vanilla Johto and Kanto.
;
; A new in-game day chooses four Johto areas and four Kanto areas. Each
; selection receives a 20% overcast / 65% rain / 15% thunderstorm intensity.
; Nearby maps are grouped into areas so crossing
; a connection does not reroll or abruptly change the day's regional weather.

_SetCurrentWeather::
	xor a
	ldh [hCurWeather], a
	; Keep the motion phase across map connections and reloads. HRAM is cleared
	; at boot, and the render timers wrap themselves into range.

	; Weather is an outdoor effect only.
	ld a, [wEnvironment]
	cp TOWN
	jr z, .outdoors
	cp ROUTE
	ret nz

.outdoors
	call EnsureDailyWeather

	call CheckCherrygroveWeather
	jr c, .set
	call CheckLakeOfRageWeather
	jr c, .set
	call CheckOlivineWeather
	jr c, .set
	call CheckAzaleaWeather
	jr c, .set
	call CheckSnowWeather
	jr c, .set
	call CheckSandstormWeather
	jr c, .set
	call CheckGenericDailyWeather
	jr c, .set

	xor a ; OW_WEATHER_NONE
.set
	ldh [hCurWeather], a
	jp LoadWeatherGraphics

EnsureDailyWeather:
	ld a, [wCurDay]
	or $90 ; versioned key distinguishes this larger pool from old save data
	ld b, a
	ld a, [wWeatherRandomDay]
	cp b
	ret z
	; fallthrough

GenerateDailyWeather:
	ld a, [wCurDay]
	or $90
	ld [wWeatherRandomDay], a

	ld hl, wWeatherDailySelections

	; Four distinct Johto areas.
	ld a, NUM_JOHTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	ld [hli], a
.roll_second_johto
	ld a, NUM_JOHTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyJohto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_second_johto
	ld a, b
	ld [hli], a

.roll_third_johto
	ld a, NUM_JOHTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyJohto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_third_johto
	ld a, [wWeatherDailyJohto2]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_third_johto
	ld a, b
	ld [hli], a

.roll_fourth_johto
	ld a, NUM_JOHTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyJohto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_johto
	ld a, [wWeatherDailyJohto2]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_johto
	ld a, [wWeatherDailyJohto3]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_johto
	ld a, b
	ld [hli], a

	; Four distinct Kanto areas. Kanto ids follow the Johto ids in the
	; shared pointer table.
	ld a, NUM_KANTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	add NUM_JOHTO_WEATHER_AREAS
	ld [hli], a
.roll_second_kanto
	ld a, NUM_KANTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	add NUM_JOHTO_WEATHER_AREAS
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyKanto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_second_kanto
	ld a, b
	ld [hli], a

.roll_third_kanto
	ld a, NUM_KANTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	add NUM_JOHTO_WEATHER_AREAS
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyKanto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_third_kanto
	ld a, [wWeatherDailyKanto2]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_third_kanto
	ld a, b
	ld [hli], a

.roll_fourth_kanto
	ld a, NUM_KANTO_WEATHER_AREAS
	call .RollAreaAndIntensity
	add NUM_JOHTO_WEATHER_AREAS
	ld b, a
	and WEATHER_AREA_MASK
	ld c, a
	ld a, [wWeatherDailyKanto1]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_kanto
	ld a, [wWeatherDailyKanto2]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_kanto
	ld a, [wWeatherDailyKanto3]
	and WEATHER_AREA_MASK
	cp c
	jr z, .roll_fourth_kanto
	ld a, b
	ld [hl], a

	; Climate-specific conditions are also rolled once for the whole day,
	; never when entering an individual map.
	ld b, 0
	call Random
	cp 26 ; 10% sand at the Ruins of Alph
	jr c, .ruins_sand
	cp 64 ; another 15% on rocky Routes 45 and 46
	jr c, .route_45_sand
	cp 102 ; another 15% on the dusty farmland of Routes 38 and 39
	jr nc, .no_sand
	set WEATHER_DAILY_ROUTE_38_SAND_F, b
	jr .no_sand
.route_45_sand
	set WEATHER_DAILY_ROUTE_45_SAND_F, b
	jr .no_sand
.ruins_sand
	set WEATHER_DAILY_RUINS_SAND_F, b
.no_sand

	; Kanto sand mirrors the Johto roll on its own exposed rocky terrain.
	call Random
	cp 26 ; 10% on the Mt. Moon pass (Routes 3 and 4)
	jr c, .route_3_sand
	cp 64 ; another 15% on the Rock Tunnel ledges (Routes 9 and 10)
	jr c, .route_9_sand
	cp 102 ; another 15% on the dry Victory Road approach (Routes 22 and 23)
	jr nc, .no_kanto_sand
	set WEATHER_DAILY_ROUTE_22_SAND_F, b
	jr .no_kanto_sand
.route_9_sand
	set WEATHER_DAILY_ROUTE_9_SAND_F, b
	jr .no_kanto_sand
.route_3_sand
	set WEATHER_DAILY_ROUTE_3_SAND_F, b
.no_kanto_sand

	call Random
	cp 26 ; 10% cherry blossoms after the early-game guarantee
	jr nc, .no_blossoms
	set WEATHER_DAILY_CHERRYGROVE_BLOSSOMS_F, b
.no_blossoms
	ld a, b
	ld [wWeatherDailyFlags], a
	ret

.RollAreaAndIntensity:
; Input:  a = number of areas
; Output: a = area id in bits 0-5, intensity in bits 6-7
	push hl
	call RandomRange
	ld e, a
	ld d, WEATHER_INTENSITY_OVERCAST
	call Random
	cp 51 ; about 20%
	jr c, .got_intensity
	ld d, WEATHER_INTENSITY_RAIN
	cp 217 ; next 65%
	jr c, .got_intensity
	ld d, WEATHER_INTENSITY_THUNDER ; remaining 15%
.got_intensity
	ld a, e
	or d
	pop hl
	ret

CheckCherrygroveWeather:
	ld hl, CherrygroveWeatherMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no

	; Blossoms are guaranteed until the Mystery Egg is delivered to Elm.
	ld de, EVENT_GAVE_MYSTERY_EGG_TO_ELM
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr z, .blossoms

	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_CHERRYGROVE_BLOSSOMS_F, [hl]
	jr z, .no
.blossoms
	ld a, OW_WEATHER_CHERRY_BLOSSOMS
	scf
	ret
.no
	and a
	ret

CheckLakeOfRageWeather:
	ld hl, LakeOfRageWeatherMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no

	; The entire Lake of Rage area is permanently stormy.
	ld a, OW_WEATHER_THUNDERSTORM
	scf
	ret
.no
	and a
	ret

CheckOlivineWeather:
	ld hl, OlivineWeatherMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no
	; Olivine City is permanently stormy.
	ld a, OW_WEATHER_THUNDERSTORM
	scf
	ret
.no
	and a
	ret

CheckAzaleaWeather:
	ld hl, AzaleaWeatherMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no
	; Sunday, Tuesday, Thursday, and Saturday are rainy.
	ld a, [wCurDay]
	and 1
	jr nz, .no
	ld a, OW_WEATHER_RAIN
	scf
	ret
.no
	and a
	ret

CheckSnowWeather:
	; The high approach to Mt. Silver is permanently snowy.
	ld hl, SilverCaveSnowMaps
	call IsCurrentMapInWeatherArea
	jr z, .snow

	; Mahogany, Route 42, and Route 44 are permanently snowy.
	ld hl, MahoganySnowMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no
.snow
	ld a, OW_WEATHER_SNOW
	scf
	ret
.no
	and a
	ret

CheckSandstormWeather:
	; Sand is restricted to exposed rocky/dirt terrain.
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_ROUTE_45_SAND_F, [hl]
	jr z, .check_route_38
	ld hl, Route45SandMaps
	call IsCurrentMapInWeatherArea
	jr z, .sand
.check_route_38
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_ROUTE_38_SAND_F, [hl]
	jr z, .check_ruins
	ld hl, Route38SandMaps
	call IsCurrentMapInWeatherArea
	jr z, .sand
.check_ruins
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_RUINS_SAND_F, [hl]
	jr z, .check_route_3
	ld hl, RuinsSandMaps
	call IsCurrentMapInWeatherArea
	jr z, .sand
.check_route_3
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_ROUTE_3_SAND_F, [hl]
	jr z, .check_route_9
	ld hl, Route3SandMaps
	call IsCurrentMapInWeatherArea
	jr z, .sand
.check_route_9
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_ROUTE_9_SAND_F, [hl]
	jr z, .check_route_22
	ld hl, Route9SandMaps
	call IsCurrentMapInWeatherArea
	jr z, .sand
.check_route_22
	ld hl, wWeatherDailyFlags
	bit WEATHER_DAILY_ROUTE_22_SAND_F, [hl]
	jr z, .no
	ld hl, Route22SandMaps
	call IsCurrentMapInWeatherArea
	jr nz, .no
.sand
	ld a, OW_WEATHER_SANDSTORM
	scf
	ret
.no
	and a
	ret

CheckGenericDailyWeather:
	ld hl, wWeatherDailySelections
	ld e, NUM_DAILY_WEATHER_AREAS_PER_REGION * 2
.loop
	ld a, [hli]
	ld d, a
	and WEATHER_AREA_MASK
	push hl
	call GetWeatherAreaPointer
	call IsCurrentMapInWeatherArea
	pop hl
	jr z, .found
	dec e
	jr nz, .loop
	and a
	ret

.found
	ld a, d
	and WEATHER_INTENSITY_MASK
	jr z, .overcast
	cp WEATHER_INTENSITY_RAIN
	jr z, .rain
	ld a, OW_WEATHER_THUNDERSTORM
	scf
	ret
.rain
	ld a, OW_WEATHER_RAIN
	scf
	ret
.overcast
	ld a, OW_WEATHER_OVERCAST
	scf
	ret

GetWeatherAreaPointer:
	add a
	ld c, a
	ld b, 0
	ld hl, WeatherAreaPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

IsCurrentMapInWeatherArea:
; Input: hl = group/map pairs terminated by -1
; Output: z if the current map is in the area
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
.loop
	ld a, [hli]
	cp -1
	jr z, .not_found
	cp b
	jr nz, .next
	ld a, [hli]
	cp c
	ret z
	jr .loop
.next
	inc hl
	jr .loop
.not_found
	ld a, 1
	and a
	ret


; Particle graphics and animation

LoadWeatherGraphics::
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	jr z, .rain
	cp OW_WEATHER_THUNDERSTORM
	jr z, .rain
	cp OW_WEATHER_SNOW
	jr z, .snow
	cp OW_WEATHER_SANDSTORM
	jr z, .sand
	cp OW_WEATHER_CHERRY_BLOSSOMS
	jr z, .blossoms
	ret

.rain
	ld de, RainWeatherGFX
	ld c, 1 + (RainSplashGFXEnd - RainSplashGFX) / LEN_2BPP_TILE ; drop + splash frames
	jr .load
.snow
	ld de, SnowWeatherGFX
	ld c, 1
	jr .load
.sand
	ld de, SandWeatherGFX
	ld c, 1
	jr .load
.blossoms
	ld de, CherryBlossomWeatherGFX
	ld c, 1
.load
	ldh a, [rVBK]
	push af
	ld a, 1
	ldh [rVBK], a
	ld hl, vTiles0 tile WEATHER_TILE
	ld b, BANK(RainWeatherGFX)
	call Get2bpp
	pop af
	ldh [rVBK], a
	ret

AnimateWeatherOnIdle::
; Redraw overworld sprites so weather particles keep animating while
; the game idles in a textbox or a window menu (farcalled from the
; UpdateWeatherSprites stub in home). Full-screen interfaces (Pokedex,
; party, Pack, Trainer Card, battles, ...) clear wVramState bit 0,
; which turns this into a no-op there. Runs at most once per frame no
; matter how often the caller's input loop spins.
; The caller preserves af and hl; bc and de are preserved here.
	push bc
	push de
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	jr c, .done ; OW_WEATHER_NONE and OW_WEATHER_OVERCAST have no particles
	ld a, [wVramState]
	bit 0, a
	jr z, .done
	; A caller-owned OAM lock is only overridden while the overworld is in its
	; reanchored text/window mode. Other interfaces keep ownership of OAM.
	bit 6, a
	jr nz, .check_frame
	ldh a, [hOAMUpdate]
	and a
	jr nz, .done
.check_frame
	ldh a, [hVBlankCounter]
	ld b, a
	ldh a, [hWeatherIdleFrame]
	cp b
	jr z, .done ; already ran this frame
	ld a, b
	ldh [hWeatherIdleFrame], a
; WaitPressAorB_BlinkCursor keeps its state in these two, and
; Function55e0 uses them as scratch, so preserve them.
	ldh a, [hMapObjectIndexBuffer]
	push af
	ldh a, [hObjectStructIndexBuffer]
	push af
	; Sprite graphics loaders keep these values live across frame waits. Do not
	; let an idle weather redraw replace them with its temporary OAM cursor.
	ldh a, [hUsedSpriteIndex]
	push af
	ldh a, [hUsedSpriteTile]
	push af
	call UpdateSprites
	pop af
	ldh [hUsedSpriteTile], a
	pop af
	ldh [hUsedSpriteIndex], a
	pop af
	ldh [hObjectStructIndexBuffer], a
	pop af
	ldh [hMapObjectIndexBuffer], a
; Text and menu waits hold hOAMUpdate at 1, which blocks the OAM DMA
; in VBlank; release it so the freshly built frame is displayed.
	xor a
	ldh [hOAMUpdate], a
.done
	pop de
	pop bc
	ret

DoOverworldWeather::
	ld a, [wVramState]
	bit VRAMSTATE_SUPPRESS_WEATHER_F, a
	jr z, .weather_enabled
	; Battle and menu transitions suppress weather before rebuilding OAM. Return
	; rain's borrowed palette first so no transition frame inherits its colors.
	ldh a, [hWeatherPalette]
	bit 7, a
	ret z
	farcall RestoreRainPalette
	ret
.weather_enabled

	; Rain uses Polished Crystal's persistent, randomly spawned OAM particles.
	; Handle it before advancing the phase counters used by the other weather
	; effects; hWeatherXTimer is the rain routine's 30-fps rolling counter.
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	jp z, DoOverworldRain
	cp OW_WEATHER_THUNDERSTORM
	jp z, DoOverworldRain

	; Give back the dynamically borrowed OBJ palette as soon as rain ends.
	ldh a, [hWeatherPalette]
	bit 7, a
	jr z, .rain_palette_restored
	farcall RestoreRainPalette
.rain_palette_restored

	; Independent screen-width and screen-height timers avoid positional
	; jumps while particles wrap around the display.
	ldh a, [hWeatherXTimer]
	inc a
	cp SCREEN_WIDTH_PX
	jr c, .store_x
	xor a
.store_x
	ldh [hWeatherXTimer], a

	ldh a, [hWeatherYTimer]
	inc a
	cp SCREEN_HEIGHT_PX
	jr c, .store_y
	xor a
.store_y
	ldh [hWeatherYTimer], a

	ldh a, [hCurWeather]
	cp OW_WEATHER_SNOW
	ret c ; none and overcast have no particles
	jp z, RenderSnow
	cp OW_WEATHER_SANDSTORM
	jp z, RenderSandstorm
	jp RenderCherryBlossoms


; Polished Crystal-style rain

DEF RAIN_DROP_TILE       EQU WEATHER_TILE
DEF RAIN_SPLASH_TILE     EQU WEATHER_TILE + 1
DEF WEATHER_OAM_HIDDEN   EQU SCREEN_HEIGHT_PX + 2 * TILE_WIDTH
DEF WEATHER_OAM_LIMIT    EQU NUM_SPRITE_OAM_STRUCTS * SPRITEOAMSTRUCT_LENGTH
DEF WEATHER_OAM_FX_LIMIT EQU 28 * SPRITEOAMSTRUCT_LENGTH

DoOverworldRain:
	; Pick a physical OBJ palette not used by this frame's objects and install
	; Polished Crystal's two rain shades there.
	farcall SelectRainPalette
	; Object sprites are rebuilt at the front of wVirtualOAM every frame. Keep
	; the surviving rain entries after them, and discard anything the new object
	; layout has displaced. This gives the older OAM engine the persistent rain
	; state that Polished Crystal's split object/weather allocator provides.
	call PrepareRainOAM

	; Polished Crystal updates weather on every odd display frame (30 fps).
	ldh a, [hWeatherXTimer]
	and 1
	jr z, .done

	ldh a, [hCurWeather]
	cp OW_WEATHER_THUNDERSTORM
	jr nz, .no_lightning
	; Match Polished Crystal's nested ~1% * 50% lightning roll.
	call Random
	cp 1 percent
	jr nc, .no_lightning
	call Random
	cp 50 percent
	call c, WeatherLightning
.no_lightning

	rept 3
	; Try to spawn three new drops from the top or right edge each update.
	call ScanForEmptyRainOAM
	call nc, SpawnRainDrop
	endr
	call DoRainFall

.done
	ldh a, [hWeatherXTimer]
	inc a
	ldh [hWeatherXTimer], a
	ret

PrepareRainOAM:
; Preserve valid rain particles after the current object OAM, clear stale
; object slots inside the weather budget, and remember the object boundary in
; hWeatherYTimer. The latter is otherwise only a motion phase for non-rain
; weather.
	assert LOW(wVirtualOAM) == 0
	ldh a, [hUsedSpriteIndex]
	ldh [hWeatherYTimer], a
	ld e, a
	ld d, HIGH(wVirtualOAM)
	call GetRainOAMLimit
	ld c, a
	cp e
	jr c, .outside_budget
	jr z, .outside_budget

.inside_loop
	ld a, [de]
	cp WEATHER_OAM_HIDDEN
	jr nc, .clear_inside
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld a, [hli]
	cp RAIN_DROP_TILE
	jr z, .check_attributes
	cp RAIN_SPLASH_TILE
	jr nz, .clear_inside
.check_attributes
	ld a, [hl]
	and VRAM_BANK_1
	jr z, .clear_inside
	; The unused palette can change as objects appear or disappear. Move every
	; surviving particle to this frame's selected weather palette.
	ldh a, [hWeatherPalette]
	and PALETTE_MASK
	or VRAM_BANK_1
	ld [hl], a

	; The scan is ascending, so this is the end of the last live weather slot.
	ld a, e
	add SPRITEOAMSTRUCT_LENGTH
	ldh [hUsedSpriteIndex], a
	jr .next_inside

.clear_inside
	call ClearRainOAMSlot
.next_inside
	ld a, e
	add SPRITEOAMSTRUCT_LENGTH
	ld e, a
	cp c
	jr c, .inside_loop

.outside_budget
	; Slots reserved by field-move OAM are left alone. Only remove unmistakable
	; rain entries left over from a frame with the larger normal budget.
	ldh a, [hWeatherYTimer]
	cp c
	jr nc, .got_outside_start
	ld e, c
.got_outside_start
	ld a, e
	cp WEATHER_OAM_LIMIT
	ret nc
.outside_loop
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld a, [hli]
	cp RAIN_DROP_TILE
	jr z, .outside_attributes
	cp RAIN_SPLASH_TILE
	jr nz, .next_outside
.outside_attributes
	ld a, [hl]
	and VRAM_BANK_1
	jr z, .next_outside
	call ClearRainOAMSlot
.next_outside
	ld a, e
	add SPRITEOAMSTRUCT_LENGTH
	ld e, a
	cp WEATHER_OAM_LIMIT
	jr c, .outside_loop
	ret

GetRainOAMLimit:
; Last byte offset available to ordinary overworld sprites. Some field-move
; effects reserve the final twelve OAM entries via wVramState bit 1.
	ld a, [wVramState]
	bit 1, a
	ld a, WEATHER_OAM_LIMIT
	ret z
	ld a, WEATHER_OAM_FX_LIMIT
	ret

ClearRainOAMSlot:
; Input: de = OAM slot. Preserve de and bc.
	ld h, d
	ld l, e
	ld [hl], WEATHER_OAM_HIDDEN
	inc hl
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

ScanForEmptyRainOAM:
; Return an empty weather-budget OAM slot in hl, or carry if none is free.
	push bc
	call GetRainOAMLimit
	ld c, a
	ldh a, [hWeatherYTimer]
	cp c
	jr nc, .full
	ld l, a
	ld h, HIGH(wVirtualOAM)
.loop
	ld a, [hl]
	cp WEATHER_OAM_HIDDEN
	jr nc, .found
	ld a, l
	add SPRITEOAMSTRUCT_LENGTH
	ld l, a
	cp c
	jr c, .loop
.full
	pop bc
	scf
	ret
.found
	pop bc
	and a
	ret

SpawnRainDrop:
; Input: hl = empty OAM slot. Spawn from the top or right edge with the same
; 50/50 distribution and coordinate ranges as Polished Crystal.
	call Random
	and 1
	jr z, .spawn_on_right

	; (y, x) = (0, RandomRange(0, 167) + 8)
	xor a
	ld [hli], a
	ld a, SCREEN_WIDTH_PX + 7
	call RandomRange
	add TILE_WIDTH
	ld [hli], a
	jr .finish

.spawn_on_right
	; (y, x) = (RandomRange(0, 160), 168)
	ld a, WEATHER_OAM_HIDDEN
	call RandomRange
	ld [hli], a
	ld a, SCREEN_WIDTH_PX + TILE_WIDTH
	ld [hli], a
.finish
	ld a, RAIN_DROP_TILE
	ld [hli], a
	ldh a, [hWeatherPalette]
	and PALETTE_MASK
	or VRAM_BANK_1
	ld [hli], a
	; fallthrough

RecordRainOAMEnd:
; Input: hl = byte immediately after a newly written OAM entry.
	ldh a, [hUsedSpriteIndex]
	cp l
	ret nc
	ld a, l
	ldh [hUsedSpriteIndex], a
	ret

DoRainFall:
	call GetRainOAMLimit
	ld c, a
	ldh a, [hWeatherYTimer]
	cp c
	ret nc
	ld e, a
	ld d, HIGH(wVirtualOAM)
	ld a, c
	sub e
	srl a
	srl a
	ld b, a

.loop
	ld a, [de]
	cp WEATHER_OAM_HIDDEN
	jp nc, .next
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld a, [hli]
	cp RAIN_SPLASH_TILE
	jp z, .update_splash
	cp RAIN_DROP_TILE
	jp nz, .next

	; Each live drop has a 5% chance per 30-fps update to become a splash.
	call Random
	cp 5 percent
	jp c, .splash

	; y -= 4 * player step y; y += 8 (+2 on alternating OAM slots).
	ld a, [wPlayerStepVectorY]
	add a
	add a
	ld c, a
	ld h, d
	ld l, e
	ld a, [hl]
	sub c
	ld c, a
	call IsEvenRainSpriteIndex
	add a
	add c
	add 8
	ld h, d
	ld l, e
	cp WEATHER_OAM_HIDDEN
	ld [hl], a
	jp nc, .despawn

	; x -= 4 * player step x; x -= 4 (+2 on alternating OAM slots).
	ld a, [wPlayerStepVectorX]
	add a
	add a
	ld c, a
	ld h, d
	ld l, e
	inc hl
	ld a, [hl]
	sub c
	ld c, a
	call IsEvenRainSpriteIndex
	cpl
	inc a
	add a
	add c
	sub 4
	ld h, d
	ld l, e
	inc hl
	ld [hl], a
	jp c, .despawn

.next
	ld a, e
	add SPRITEOAMSTRUCT_LENGTH
	ld e, a
	dec b
	jp nz, .loop

	; Splashes persist until the same 16-display-frame cadence used by
	; Polished Crystal. Rain itself only updates on odd display frames.
	ldh a, [hWeatherXTimer]
	and %1110
	ret nz
	call GetRainOAMLimit
	ld c, a
	ldh a, [hWeatherYTimer]
	cp c
	ret nc
	ld e, a
	ld d, HIGH(wVirtualOAM)
.splash_loop
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld a, [hli]
	cp RAIN_SPLASH_TILE
	jr nz, .splash_next
	ld h, d
	ld l, e
	ld [hl], WEATHER_OAM_HIDDEN
.splash_next
	ld a, e
	add SPRITEOAMSTRUCT_LENGTH
	ld e, a
	cp c
	jr c, .splash_loop
	ret

.despawn
	call ClearRainOAMSlot
	jp .next

.update_splash
	; A splash is fixed to the ground, so only compensate for camera movement.
	ld a, [wPlayerStepVectorY]
	add a
	ld c, a
	ld h, d
	ld l, e
	ld a, [hl]
	sub c
	cp WEATHER_OAM_HIDDEN
	jp nc, .despawn
	ld [hli], a
	ld a, [wPlayerStepVectorX]
	add a
	ld c, a
	ld a, [hl]
	sub c
	ld [hl], a
	jp .next

.splash
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld [hl], RAIN_SPLASH_TILE
	jp .next

IsEvenRainSpriteIndex:
; Input: e = low byte of a four-byte OAM entry. Output: slot index & 1.
	ld a, e
	rra
	rra
	and 1
	ret

RenderSnow:
	ld hl, WeatherParticleSeeds
	ld e, 16
.loop
	; Small eight-pixel horizontal drift, one-pixel vertical fall.
	ld a, [hli]
	ld c, a
	ldh a, [hWeatherXTimer]
	and 7
	add c
	call WrapWeatherX
	add TILE_WIDTH
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hWeatherYTimer]
	add b
	call WrapWeatherY
	add 2 * TILE_WIDTH
	ld b, a
	ld d, VRAM_BANK_1 | PAL_OW_SILVER
	ld a, WEATHER_TILE
	call AppendWeatherParticle
	ret c
	dec e
	jr nz, .loop
	ret

RenderSandstorm:
	ld hl, WeatherParticleSeeds
	ld e, 16
.loop
	; Fast diagonal movement across exposed rocky ground.
	ld a, [hli]
	ld c, a
	rept 4
	ldh a, [hWeatherXTimer]
	add c
	call WrapWeatherX
	ld c, a
	endr
	ld a, c
	add TILE_WIDTH
	ld c, a
	ld a, [hli]
	ld b, a
	rept 2
	ldh a, [hWeatherYTimer]
	add b
	call WrapWeatherY
	ld b, a
	endr
	ld a, b
	add 2 * TILE_WIDTH
	ld b, a
	ld d, VRAM_BANK_1 | PAL_OW_BROWN
	ld a, WEATHER_TILE
	call AppendWeatherParticle
	ret c
	dec e
	jr nz, .loop
	ret

RenderCherryBlossoms:
	ld hl, WeatherParticleSeeds
	ld e, 16
.loop
	; Petals drift gently down and right.
	ld a, [hli]
	ld c, a
	ldh a, [hWeatherXTimer]
	add c
	call WrapWeatherX
	add TILE_WIDTH
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hWeatherYTimer]
	add b
	call WrapWeatherY
	add 2 * TILE_WIDTH
	ld b, a
	ld d, VRAM_BANK_1 | PAL_OW_RED
	ld a, WEATHER_TILE
	call AppendWeatherParticle
	ret c
	dec e
	jr nz, .loop
	ret

WrapWeatherX:
; Correct the discarded 256 when the caller's addition overflowed.
	jr nc, .in_range
	add 256 - SCREEN_WIDTH_PX
.in_range
	cp SCREEN_WIDTH_PX
	ret c
	sub SCREEN_WIDTH_PX
	ret

WrapWeatherY:
	jr nc, .in_range
	add 256 - SCREEN_HEIGHT_PX
.in_range
	cp SCREEN_HEIGHT_PX
	ret c
	sub SCREEN_HEIGHT_PX
	ret

AppendWeatherParticle:
; Input: a = tile id, b = OAM y, c = OAM x, d = attributes
; Output: carry if the object OAM budget is full
; Preserves hl.
	push hl
	push af ; stash the tile id for the write below
	ld a, [wVramState]
	bit 1, a
	jr z, .full_budget
	ldh a, [hUsedSpriteIndex]
	cp 28 * SPRITEOAMSTRUCT_LENGTH
	jr nc, .full
	jr .append
.full_budget
	ldh a, [hUsedSpriteIndex]
	cp LOW(wVirtualOAMEnd)
	jr nc, .full
.append
	ld l, a
	ld h, HIGH(wVirtualOAM)
	ld [hl], b
	inc l
	ld [hl], c
	inc l
	pop af ; a = tile id
	ld [hl], a
	inc l
	ld [hl], d
	inc l
	ld a, l
	ldh [hUsedSpriteIndex], a
	pop hl
	and a
	ret
.full
	pop af ; discard stashed tile id
	pop hl
	scf
	ret

WeatherLightning:
	push af
	push bc
	push de
	push hl

	ld de, SFX_THUNDER_OW
	call PlaySFX

	ldh a, [hCGB]
	and a
	jr z, .dmg

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals2)
	ldh [rSVBK], a
	ld hl, wBGPals2
	ld c, 8 palettes ; BG and OBJ buffers are contiguous
.white_loop
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hli], a
	dec c
	jr nz, .white_loop
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	jr .show

.dmg
	xor a ; all four shades map to white
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
.show
	call DelayFrame
	farcall _UpdateTimePals
	; _UpdateTimePals rebuilds every OBJ palette, so reinstall the dedicated
	; rain shades before the first post-flash frame is displayed.
	farcall SelectRainPalette

	pop hl
	pop de
	pop bc
	pop af
	ret

ApplyWeatherTint::
; Darken the seven map BG palettes to 75% brightness for overcast, rain,
; and thunderstorms. Palette 7 is text/UI and is intentionally untouched.
	push af
	push bc
	push de
	push hl

	ldh a, [hCGB]
	and a
	jp z, .done
	ldh a, [hCurWeather]
	cp OW_WEATHER_OVERCAST
	jp c, .done
	cp OW_WEATHER_SNOW
	jp nc, .done

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals2)
	ldh [rSVBK], a
	ld hl, wBGPals2
	ld c, 7 * NUM_PAL_COLORS
.color_loop
	ld a, [hli]
	ld e, a ; RGB555 low byte
	ld a, [hl]
	ld d, a ; RGB555 high byte
	push bc

	; Extract green before reusing d and e.
	ld a, e
	and %11100000
	swap a
	srl a
	ld c, a
	ld a, d
	and %00000011
	add a
	add a
	add a
	or c
	push af ; raw green component

	; blue = blue - blue / 4
	ld a, d
	srl a
	srl a
	and %00011111
	ld c, a
	srl a
	srl a
	ld d, a
	ld a, c
	sub d
	ld c, a

	; red = red - red / 4
	ld a, e
	and %00011111
	ld b, a
	srl a
	srl a
	ld d, a
	ld a, b
	sub d
	ld b, a

	; green = green - green / 4
	pop af
	ld e, a
	srl a
	srl a
	ld d, a
	ld a, e
	sub d
	ld e, a

	; Reassemble the RGB555 color.
	ld a, e
	and %00000111
	swap a
	add a
	or b
	dec hl
	ld [hli], a
	ld a, e
	srl a
	srl a
	srl a
	ld b, a
	ld a, c
	add a
	add a
	or b
	ld [hli], a

	pop bc
	dec c
	jr nz, .color_loop

	pop af
	ldh [rSVBK], a
.done
	pop hl
	pop de
	pop bc
	pop af
	ret


INCLUDE "data/maps/overcast_maps.asm"

; Seed coordinates (screen pixels, before OAM bias) scattered across the
; screen. All weather types use the full set of sixteen seeds.
WeatherParticleSeeds:
	db   4,  12
	db  24,  96
	db  43,  38
	db  62, 126
	db  81,  68
	db 101,  22
	db 123, 110
	db 146,  52
	db  15,  74
	db  34, 132
	db  55,   6
	db  72,  46
	db  92, 102
	db 113,  60
	db 135,  18
	db 152, 118

; Weather particles. Rain uses Polished Crystal's exact two-tile, two-shade
; drop/splash art; SelectRainPalette supplies its dedicated colors without
; disturbing NPC or emote palettes. The other effects use color 2.
RainWeatherGFX:
	db $00, $00
	db $00, $08
	db $00, $08
	db $00, $10
	db $00, $10
	db $20, $00
	db $20, $00
	db $00, $00
; It must directly follow RainWeatherGFX so both tiles load as one fetch.
RainSplashGFX:
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $82, $00
	db $00, $00
	db $44, $00
RainSplashGFXEnd:
; The drop tile plus every splash frame must fit between WEATHER_TILE
; and the emote tiles at $f8, or loading rain graphics corrupts emotes.
	assert RainSplashGFXEnd - RainSplashGFX <= ($f8 - WEATHER_TILE - 1) * LEN_2BPP_TILE, "Rain splash frames overflow into the emote tiles at $f8"
SnowWeatherGFX:
	db $00, $00
	db $00, $00
	db $00, $10
	db $00, $38
	db $00, $10
	db $00, $00
	db $00, $00
	db $00, $00
SandWeatherGFX:
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $00
	db $00, $10
	db $00, $38
	db $00, $10
	db $00, $00
; Cherry blossom petal from gfx/overworld/cherry_blossom.png. Its darkest
; shade builds as color 2, matching the PAL_OW_RED color used by
; RenderCherryBlossoms, so the petal reads pink without any palette change.
CherryBlossomWeatherGFX:
	INCBIN "gfx/overworld/cherry_blossom.2bpp"
CherryBlossomWeatherGFXEnd:
	assert CherryBlossomWeatherGFXEnd - CherryBlossomWeatherGFX == LEN_2BPP_TILE, "cherry_blossom.png must be a single 8x8 tile"


SECTION "Overworld Rain Palette", ROMX

RestoreRainPalette::
; Return the physical OBJ palette borrowed by rain to the map palette buffer.
	ldh a, [hWeatherPalette]
	bit 7, a
	ret z
	and PALETTE_MASK
	ldh [hWeatherPalette], a ; clear the active flag but retain the slot index

	ldh a, [hCGB]
	and a
	ret z
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1
	ld bc, PALETTE_SIZE
	ldh a, [hWeatherPalette]
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, wOBPals2 - wOBPals1
	add hl, bc
	ld b, PALETTE_SIZE
.restore_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .restore_loop
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

SelectRainPalette::
; Pick a physical OBJ palette that no visible non-weather sprite is using.
; Polished Crystal has a dynamic palette slot for weather; this supplies the
; same isolation without changing Crimson Crystal's fixed NPC palette indexes.
	; First restore the slot weather owned last frame from the untinted map OBJ
	; palette buffer. An NPC that starts using that slot this frame must see its
	; normal colors before rain moves to a different free slot.
	call RestoreRainPalette

.scan
	xor a
	ld c, a ; used-palette bitmask
	; Current map objects occupy the OAM prefix ending at hUsedSpriteIndex.
	; Scan only that live range, not stale entries that PrepareRainOAM will clear.
	ld hl, wVirtualOAM
	ldh a, [hUsedSpriteIndex]
	srl a
	srl a
	ld b, a
	call .scan_range

	; Field-move effects can reserve and populate the final twelve OAM entries.
	ld a, [wVramState]
	bit 1, a
	jr z, .choose_palette
	ld hl, wVirtualOAM + WEATHER_OAM_FX_LIMIT
	ld b, NUM_SPRITE_OAM_STRUCTS - 28
	call .scan_range

.choose_palette
	; Prefer silver because weather historically used it, then take any other
	; free slot. The final silver fallback is only reachable if all eight
	; palettes are simultaneously visible; it avoids recoloring the player.
	bit PAL_OW_SILVER, c
	ld a, PAL_OW_SILVER
	jr z, .selected
	bit PAL_OW_ROCK, c
	ld a, PAL_OW_ROCK
	jr z, .selected
	bit PAL_OW_TREE, c
	ld a, PAL_OW_TREE
	jr z, .selected
	bit PAL_OW_PINK, c
	ld a, PAL_OW_PINK
	jr z, .selected
	bit PAL_OW_BROWN, c
	ld a, PAL_OW_BROWN
	jr z, .selected
	bit PAL_OW_GREEN, c
	ld a, PAL_OW_GREEN
	jr z, .selected
	bit PAL_OW_BLUE, c
	ld a, PAL_OW_BLUE
	jr z, .selected
	ld a, PAL_OW_SILVER
.selected
	or 1 << 7 ; this slot must be restored when rain releases it
	ldh [hWeatherPalette], a

	; DMG uses OBP shades rather than CGB OBJ palettes.
	ldh a, [hCGB]
	and a
	ret z

	; Save time-of-day before selecting the palette-buffer WRAM bank.
	ld a, [wTimeOfDay]
	ld e, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals2)
	ldh [rSVBK], a

	ld hl, wOBPals2 + PAL_COLOR_SIZE ; transparent color 0 is irrelevant
	ld bc, PALETTE_SIZE
	ldh a, [hWeatherPalette]
	and PALETTE_MASK
	call AddNTimes

	ld a, e
	cp NITE
	jr z, .night
	; Polished Crystal's morning/day rain palette.
	ld de, palred 21 + palgreen 21 + palblue 31
	ld bc, palred 16 + palgreen 22 + palblue 31
	jr .write_colors
.night
	; Polished Crystal's night/evening rain palette.
	ld de, palred 16 + palgreen 14 + palblue 19
	ld bc, palred 16 + palgreen 16 + palblue 31
.write_colors
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a ; color 3 is black
	ld [hli], a
	ld [hl], a

	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

.scan_range
	ld a, b
	and a
	ret z
.scan_oam
	ld a, [hli]
	cp WEATHER_OAM_HIDDEN
	jr nc, .hidden
	inc hl ; x
	ld a, [hli] ; tile
	ld e, a
	ld a, [hli] ; attributes
	ld d, a

	; Do not count persistent rain from the previous frame as an owner of its
	; old palette, or the selection would unnecessarily bounce between slots.
	ld a, e
	cp RAIN_DROP_TILE
	jr z, .maybe_weather
	cp RAIN_SPLASH_TILE
	jr nz, .mark_palette
.maybe_weather
	bit 3, d ; VRAM bank 1 is reserved for these weather tiles
	jr nz, .next

.mark_palette
	ld a, d
	and PALETTE_MASK
	ld e, a
	ld d, 0
	push hl
	ld hl, .PaletteBits
	add hl, de
	ld a, [hl]
	pop hl
	or c
	ld c, a
	jr .next

.hidden
	inc hl ; x
	inc hl ; tile
	inc hl ; attributes
.next
	dec b
	jr nz, .scan_oam
	ret

.PaletteBits:
	db 1 << PAL_OW_RED
	db 1 << PAL_OW_BLUE
	db 1 << PAL_OW_GREEN
	db 1 << PAL_OW_BROWN
	db 1 << PAL_OW_PINK
	db 1 << PAL_OW_SILVER
	db 1 << PAL_OW_TREE
	db 1 << PAL_OW_ROCK
