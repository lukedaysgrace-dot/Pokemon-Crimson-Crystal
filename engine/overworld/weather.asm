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

	; A few interior maps are permanently snowy despite being caves. Check them
	; before the outdoor-only gate so their snow is not skipped.
	ld hl, SilverCaveIndoorSnowMaps
	call IsCurrentMapInWeatherArea
	jr nz, .not_indoor_snow
	ld a, OW_WEATHER_SNOW
	ldh [hCurWeather], a
	jp LoadWeatherGraphics
.not_indoor_snow

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
	ld c, NUM_PETAL_FRAMES
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
; Redraw overworld sprites so weather stays consistent while the game
; idles in a textbox or a window menu (farcalled from the
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
	; The start menu (and anything else that sets the suppress bit) pauses
	; weather completely: no idle particle redraws on top of the menu window,
	; and no per-frame sprite rebuilds dragging down the menu input loop.
	bit VRAMSTATE_SUPPRESS_WEATHER_F, a
	jr nz, .done
	bit 0, a
	jr z, .done
	; Which windows the particles may fall over is DoOverworldWeather's decision
	; (a conversation yes, a mart list no); this only has to get the sprite
	; rebuild there.
	;
	; hOAMUpdate is the VBlank handler's "don't DMA OAM this frame" lock, and the
	; wait-for-A loop at the end of every line of dialogue holds it at 1 for its
	; whole duration - which is most of a conversation. Honouring it there is what
	; leaves the particles sitting frozen on screen until the player presses A:
	; the loop is spinning, the timers want to advance, and the finished frame
	; never reaches OAM. So for the speech textbox the lock is deliberately taken
	; over, and released at the bottom of this routine so the rebuild is displayed;
	; the waiting loop restores its own saved value when it exits. Every other
	; caller still gets the lock respected, and is skipped while it holds it.
	ldh a, [hOAMUpdate]
	and a
	jr z, .oam_free
	ld a, [wVramState]
	bit VRAMSTATE_SPEECH_TEXTBOX_F, a
	jr z, .done
.oam_free
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

PetalsDrawInFront:
; Carry if this frame's weather is cherry blossoms AND they are the copy drawn
; ahead of the map objects. Petals are the one weather that belongs in front of
; the player and NPCs, so they are built into the lowest OAM indices before
; InitSprites fills the rest - on CGB the lower index wins. Reduced-budget mode
; (wVramState bit 1) gives the whole overworld only 28 objects; there the
; petals go back to layering behind the map so a crowded scripted scene cannot
; lose an NPC to them.
	ldh a, [hCurWeather]
	cp OW_WEATHER_CHERRY_BLOSSOMS
	jr nz, .behind
	ld a, [wVramState]
	bit 1, a
	jr nz, .behind
	scf
	ret
.behind
	and a
	ret

DoOverworldWeatherInFront::
; Called from _UpdateSprites before InitSprites. Only the petals answer here;
; whichever of the two passes owns the current weather is also the one that
; advances its timers, so they still tick exactly once a frame.
	call PetalsDrawInFront
	ret nc
	jr _DoOverworldWeather

DoOverworldWeather::
; Called after InitSprites, for every weather that layers behind the map.
	call PetalsDrawInFront
	ret c
_DoOverworldWeather:
	ld a, [wVramState]
	bit VRAMSTATE_SUPPRESS_WEATHER_F, a
	ret nz
	; Weather particles are OAM sprites, so they are drawn on top of whatever
	; window is up. Bit 6 says the overworld has been reanchored for one, but not
	; where it sits, and most of them - marts, yes/no boxes, the Pokegear - land
	; in the top half of the screen where the particles are. So bit 6 on its own
	; still means stop; only the speech textbox, whose shape is known, lets the
	; weather carry on, and only while nothing is stacked over it. Particles are
	; then held above the box by SPEECH_TEXTBOX_CLIP_Y in AppendWeatherParticle.
	bit 6, a
	jr z, .visible
	bit VRAMSTATE_SPEECH_TEXTBOX_F, a
	ret z
	ld a, [wWindowStackSize]
	and a
	ret nz ; a menu is open over the textbox, and it could be anywhere
.visible

	; Independent screen-width and screen-height timers avoid positional
	; jumps while particles wrap around the display.
	ldh a, [hCurWeather]
	cp OW_WEATHER_CHERRY_BLOSSOMS
	jr z, .petal_timers

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
	jr .particles

.petal_timers
; Petals fall far more slowly than rain or snow, and each speed tier gets a
; timer of its own rather than one timer counted twice over: every tier steps a
; single pixel at a time, and no two of them step on the same frame, so a petal
; that reads two timers still never jumps. The slow fall timer steps once every
; PETAL_FALL_PERIOD frames and the mid one on the odd frames in between, which
; is two steps in the same window; a petal reading both moves on three frames
; out of every four. Sideways, PetalDriftPattern says which of the two drift
; timers steps on this frame, PETAL_DRIFT_STEPS frames apiece out of every
; PETAL_DRIFT_PERIOD, interleaved so a wide drifter also slides one pixel at a
; time. Every cadence comes off the free-running VBlank counter, so the timers
; stay plain pixel offsets; the counter's 256-frame period is a whole multiple
; of each pattern, so none of them stutters where it wraps.
	ldh a, [hVBlankCounter]
	ld b, a
	and PETAL_FALL_PERIOD - 1
	jr nz, .no_slow_fall_step
	ldh a, [hWeatherYTimer]
	inc a
	cp SCREEN_HEIGHT_PX
	jr c, .store_slow_fall
	xor a
.store_slow_fall
	ldh [hWeatherYTimer], a
.no_slow_fall_step
	bit 0, b ; the odd frames, which the slow timer always skips
	jr z, .no_mid_fall_step
	ldh a, [hPetalFallTimerB]
	inc a
	cp SCREEN_HEIGHT_PX
	jr c, .store_mid_fall
	xor a
.store_mid_fall
	ldh [hPetalFallTimerB], a
.no_mid_fall_step
	ld a, b
	and PETAL_DRIFT_PERIOD - 1
	ld e, a
	ld d, 0
	ld hl, PetalDriftPattern
	add hl, de
	ld b, [hl]
	bit PETAL_DRIFT_STEP_A_F, b
	jr z, .no_drift_step
	ldh a, [hWeatherXTimer]
	inc a
	cp SCREEN_WIDTH_PX
	jr c, .store_drift
	xor a
.store_drift
	ldh [hWeatherXTimer], a
.no_drift_step
	bit PETAL_DRIFT_STEP_B_F, b
	jr z, .particles
	ldh a, [hPetalDriftTimerB]
	inc a
	cp SCREEN_WIDTH_PX
	jr c, .store_wide_drift
	xor a
.store_wide_drift
	ldh [hPetalDriftTimerB], a

.particles
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	ret c ; none and overcast have no particles
	jr z, RenderRain
	cp OW_WEATHER_THUNDERSTORM
	jr z, .thunderstorm
	cp OW_WEATHER_SNOW
	jr z, RenderSnow
	cp OW_WEATHER_SANDSTORM
	jp z, RenderSandstorm
	jp RenderCherryBlossoms

.thunderstorm
	; Check for lightning whenever the vertical timer wraps. 12.5% per
	; wrap averages one flash roughly every nineteen seconds at 60 fps.
	ldh a, [hWeatherYTimer]
	and a
	jr nz, RenderRain
	call Random
	cp 32
	call c, WeatherLightning
	jr RenderRain

; Each particle salts these 32-pixel cells with its X seed, staggering impacts
; without consuming the global RNG. Within each cell a drop falls, splashes on
; the salted impact line, then stays gone until the cell wraps and it re-seeds
; as a fresh drop.
DEF RAIN_SPLASH_CELL EQU 32
DEF RAIN_SPEED EQU 2
; Phases advance RAIN_SPEED per frame through the cell. Each splash frame is
; shown for RAIN_SPLASH_FRAME_PHASES phases, then the spent drop spends
; RAIN_GONE_PHASES invisible before re-seeding.
DEF RAIN_SPLASH_FRAME_PHASES EQU 8
DEF RAIN_GONE_PHASES EQU 8

RenderRain:
	ld hl, WeatherParticleSeeds
	ld e, 20 ; rain alone also reads the four extra seeds past the shared sixteen
.loop
	; x = seed - RAIN_SPEED * horizontal timer (mod screen width). The drop drifts left
	; (top-right to bottom-left); horizontal and vertical speed are matched so a
	; splash can be pinned exactly to the spot where the drop landed.
	ldh a, [hWeatherXTimer]
	ld b, a
	ld a, SCREEN_WIDTH_PX
	sub b
	ld b, a ; b = SCREEN_WIDTH_PX - horizontal timer
	ld a, [hli] ; seed x
	ld d, a ; fixed per-particle salt for splash position and timing
	rept RAIN_SPEED
	add b
	call WrapWeatherX
	endr
	add TILE_WIDTH
	ld c, a ; c = moving OAM x

	; y = seed + RAIN_SPEED * vertical timer (mod screen height)
	ld a, [hli] ; seed y
	ld b, a
	rept RAIN_SPEED
	ldh a, [hWeatherYTimer]
	add b
	call WrapWeatherY
	ld b, a
	endr
	; b = on-screen y (0 .. SCREEN_HEIGHT_PX - 1)

	; Salt the impact row with the particle's X seed so the cells splash at
	; staggered, irregular times. Phase 0 is the moment of impact.
	ld a, b
	add d
	and RAIN_SPLASH_CELL - 1
	cp (RainSplashGFXEnd - RainSplashGFX) / LEN_2BPP_TILE * RAIN_SPLASH_FRAME_PHASES
	jr c, .splash
	cp (RainSplashGFXEnd - RainSplashGFX) / LEN_2BPP_TILE * RAIN_SPLASH_FRAME_PHASES + RAIN_GONE_PHASES
	jr c, .next ; already splashed: the drop is spent until it re-seeds
	jr .falling

.splash
	; Animate frame = phase / RAIN_SPLASH_FRAME_PHASES and pin it to the salted
	; impact line so it holds still on the ground while the animation plays.
	ld d, a ; d = phase
	srl a
	srl a
	srl a
	add WEATHER_TILE + 1 ; splash tile for this frame
	push af ; save splash tile
	ld a, c
	add d
	ld c, a ; pinned OAM x = moving x + phase
	ld a, b
	sub d
	add 2 * TILE_WIDTH
	ld b, a ; pinned OAM y = band's top line
	ld d, VRAM_BANK_1 | PAL_OW_SILVER
	pop af ; restore splash tile
	call AppendWeatherParticle
	ret c
	jr .next

.falling
	; Still on its way down: draw the streak at its moving position.
	ld a, b
	add 2 * TILE_WIDTH
	ld b, a ; OAM y
	ld d, VRAM_BANK_1 | PAL_OW_SILVER
	ld a, WEATHER_TILE
	call AppendWeatherParticle
	ret c
.next
	dec e
	jr nz, .loop
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
; A petal's params byte says which of the shared timers it reads, and that is
; where the whole variety comes from: three fall speeds and two drift angles
; over four tumble phases and two spin directions, without a single petal
; storing a byte of its own. Each timer is a plain pixel offset that wraps at a
; screen dimension, and adding two of them is still seamless, because a whole
; number of screens is no movement at all.
	ld hl, CherryBlossomSeeds
.loop
	ld a, [hli] ; params
	ld c, a

	; y = seed + the fall timers this petal reads (mod screen height). The slow
	; and mid timers step on different frames and each step is one pixel, so
	; reading both makes the petal fall faster without ever moving it two pixels
	; in a frame.
	ld a, [hli] ; seed y
	ld b, a
	bit PETAL_FALL_2_F, c
	jr z, .add_slow_fall
	ldh a, [hPetalFallTimerB]
	add b
	call WrapWeatherY
	ld b, a
	bit PETAL_FALL_3_F, c
	jr z, .fall_done
.add_slow_fall
	ldh a, [hWeatherYTimer]
	add b
	call WrapWeatherY
	ld b, a
.fall_done
	ld a, b
	add 2 * TILE_WIDTH
	ld b, a

	; Rotation frame. Bits 0-1 of the params offset the tumble and the reverse
	; bit turns it the other way, so neighbouring petals never spin in step.
	ldh a, [hVBlankCounter]
rept 3 ; / PETAL_SPIN_FRAMES; the rotated-in high bits are masked off below
	rrca
endr
	bit PETAL_REVERSE_F, c
	jr z, .tumble_forward
	cpl ; walks the frames backwards through the cycle
.tumble_forward
	add c ; only the phase bits survive the mask below
	and NUM_PETAL_FRAMES - 1
	add WEATHER_TILE
	push af ; the tile, while c is still the params byte

	; x = seed - the drift timers this petal reads (mod screen width): petals
	; slide left as they fall, and the ones that lean furthest read the second
	; drift timer as well, again a pixel at a time. Subtracting is done by
	; adding the timer's distance from the right edge.
	ld a, [hli] ; seed x
	ld e, a
	ldh a, [hWeatherXTimer]
	ld d, a
	ld a, SCREEN_WIDTH_PX
	sub d
	add e
	call WrapWeatherX
	ld e, a
	bit PETAL_DRIFT_2_F, c
	jr z, .no_wider_drift
	ldh a, [hPetalDriftTimerB]
	ld d, a
	ld a, SCREEN_WIDTH_PX
	sub d
	add e
	call WrapWeatherX
	ld e, a
.no_wider_drift
	ld a, e
	add TILE_WIDTH
	ld c, a

	pop af ; tile
	ld d, VRAM_BANK_1 | PAL_OW_PINK
	call AppendWeatherParticle
	ret c
	ld a, l
	cp LOW(CherryBlossomSeedsEnd)
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

; While a conversation is up the map only owns the rows above the speech
; textbox, so a particle that has fallen far enough to touch the box is
; dropped rather than drawn over the text. It disappears at the box's top
; edge, which reads as falling behind it. Dropping one particle is not the
; same as running out of OAM: return without carry so the caller keeps going
; through the rest of them, and the ones still in open sky are unaffected.
	ld a, [wVramState]
	bit VRAMSTATE_SPEECH_TEXTBOX_F, a
	jr z, .not_behind_textbox
	ld a, b
	cp SPEECH_TEXTBOX_CLIP_Y
	jr nc, .clipped
.not_behind_textbox

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

.clipped
	pop af ; discard stashed tile id
	pop hl
	and a ; there is still room in OAM; this one just had nowhere to go
	ret

WeatherLightning:
	push af
	push bc
	push de
	push hl

	ld de, SFX_THUNDER
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
	cp OW_WEATHER_CHERRY_BLOSSOMS
	jr z, .petal_pink
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

	; Rain and thunderstorms recolor the silver OBJ palette's color 2 to
	; Polished Crystal's raindrop blue. wOBPals2 shares this WRAM bank with
	; wBGPals2, so the rSVBK set above still holds. Emotes use only colors 1
	; and 3, so the exclamation point above trainers keeps its white and black.
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	jr z, .rain_blue
	cp OW_WEATHER_THUNDERSTORM
	jr nz, .no_rain_blue
.rain_blue
	ld hl, wOBPals2 + PAL_OW_SILVER * PALETTE_SIZE + 2 * PAL_COLOR_SIZE
	ld bc, palred 16 + palgreen 22 + palblue 31 ; Polished raindrop blue
	ld a, c
	ld [hli], a
	ld [hl], b
.no_rain_blue

	pop af
	ldh [rSVBK], a
	jr .done

.petal_pink
; Cherry blossoms leave the map's own palettes alone - the sky is clear -
; and instead hand the petals all three colors of the pink OBJ palette, which
; the petal tiles are drawn in. That palette is free to borrow: the only
; sprite that asks for it is Mew, and the only map blossoms fall on is
; Cherrygrove City, so nothing else on screen can be wearing it. Petals need
; the full ramp because a flat one-color petal reads as a chunk of confetti;
; the lit rim and the shaded trailing edge are what make it a petal.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals2)
	ldh [rSVBK], a
	ld hl, wOBPals2 + PAL_OW_PINK * PALETTE_SIZE + 1 * PAL_COLOR_SIZE
	ld de, CherryBlossomPals
	ld c, 3 * PAL_COLOR_SIZE
.petal_color_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .petal_color_loop
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
; screen. All weather types use the shared set of sixteen seeds; rain also
; reads the four extras beyond it for a denser shower.
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
; Extra seeds read only while it rains.
	db  10,  84
	db  47,  16
	db  88, 138
	db 140,  34

; Cherry blossoms get their own scatter instead of the shared weather seeds,
; whose x values climb in even steps - fine for rain, but petals linger long
; enough for that regularity to read as falling columns. Each entry is a params
; byte (see the PETAL_*_F constants), then the petal's starting y and x.
; Ten petals is a drift rather than a shower: enough to keep something moving
; in every part of the screen without the map disappearing behind them. Adding
; or removing entries needs nothing else changed. Set FALL_3 only alongside
; FALL_2 - on its own the render loop ignores it.
CherryBlossomSeeds:
	db $02,  38,  82 ; fall x1, drift x1, forward, phase 2
	db $14,  12, 101 ; fall x2, drift x2, forward, phase 0
	db $0d, 137,  18 ; fall x3, drift x1, forward, phase 1
	db $25,  93,  40 ; fall x2, drift x1, reverse, phase 1
	db $3f,  54, 129 ; fall x3, drift x2, reverse, phase 3
	db $20,  15,  57 ; fall x1, drift x1, reverse, phase 0
	db $26, 136, 143 ; fall x2, drift x1, reverse, phase 2
	db $0f,  80, 109 ; fall x3, drift x1, forward, phase 3
	db $16,  23, 148 ; fall x2, drift x2, forward, phase 2
	db $30,  73,   5 ; fall x1, drift x2, reverse, phase 0
CherryBlossomSeedsEnd:
	assert CherryBlossomSeedsEnd - CherryBlossomSeeds < $100, "RenderCherryBlossoms ends its loop on the low byte of the table's end"

; Frames inside each PETAL_DRIFT_PERIOD-frame window on which a drift timer
; takes its single pixel step to the left, spread as evenly as the window
; allows so the slide reads as steady rather than as a stutter. Bit 0 steps the
; timer every petal reads, bit 1 the second one that only the wide drifters
; add; the two sets are interleaved and never share a frame, so a wide drifter
; leans twice as far while still moving a pixel at a time. Each timer gets
; PETAL_DRIFT_STEPS of the sixty-four frames - raising that count leans every
; petal further over, lowering it straightens them all up.
DEF DRIFT_A EQU 1 << PETAL_DRIFT_STEP_A_F
DEF DRIFT_B EQU 1 << PETAL_DRIFT_STEP_B_F
PetalDriftPattern:
	db DRIFT_A, 0, 0, 0, DRIFT_B, 0, 0, 0, 0, DRIFT_A, 0, 0, 0, DRIFT_B, 0, 0
	db 0, 0, DRIFT_A, 0, 0, 0, DRIFT_B, 0, 0, 0, 0, DRIFT_A, 0, 0, 0, DRIFT_B
	db 0, 0, 0, 0, DRIFT_A, 0, 0, 0, DRIFT_B, 0, 0, 0, 0, DRIFT_A, 0, 0
	db 0, DRIFT_B, 0, 0, 0, 0, DRIFT_A, 0, 0, 0, DRIFT_B, 0, 0, 0, 0, 0
PetalDriftPatternEnd:
	PURGE DRIFT_A, DRIFT_B
	assert PetalDriftPatternEnd - PetalDriftPattern == PETAL_DRIFT_PERIOD, "PetalDriftPattern must have one entry per frame of PETAL_DRIFT_PERIOD"
; RenderCherryBlossoms divides the VBlank counter by PETAL_SPIN_FRAMES with
; a fixed three-bit rotate, and both cadences ride the counter's 256-frame
; wrap, so these two must stay powers of two.
	assert PETAL_SPIN_FRAMES == 8, "RenderCherryBlossoms' rotate count must match PETAL_SPIN_FRAMES"
	assert PETAL_DRIFT_PERIOD & (PETAL_DRIFT_PERIOD - 1) == 0, "PETAL_DRIFT_PERIOD must be a power of two"
	assert NUM_PETAL_FRAMES & (NUM_PETAL_FRAMES - 1) == 0, "NUM_PETAL_FRAMES must be a power of two"

; Colors 1-3 of the pink OBJ palette while blossoms are falling, matching the
; shades the petal tiles are drawn in. ApplyWeatherTint copies them in whole.
; Red stays high and blue stays under green's neighborhood: let blue climb past
; green and the petals slide from pink into purple.
CherryBlossomPals:
	RGB 31, 20, 23 ; lit rim
	RGB 30, 14, 18 ; body
	RGB 21, 05, 10 ; shaded trailing edge
CherryBlossomPalsEnd:
	assert CherryBlossomPalsEnd - CherryBlossomPals == 3 * PAL_COLOR_SIZE, "CherryBlossomPals must fill colors 1-3"

; Weather particles. Color 0 is always transparent. On the silver palette the
; rain drop and its splash now use color 2, which ApplyWeatherTint recolors to
; rain blue only while it is raining. Emotes use only colors 1 and 3, so the "!"
; above trainers keeps its normal white/black. Snow also uses color 2, which
; stays snow-white because ApplyWeatherTint leaves it alone during snow, and
; cherry blossom petals use that slot recolored to blossom pink. Sand uses
; color 2 of its own palette.

; Falling raindrop streak from gfx/overworld/rain.png. The Makefile normalizes
; every non-transparent pixel to color 2, the slot ApplyWeatherTint recolors
; to rain blue, so the PNG may be drawn in any shade. If the PNG is missing,
; the Makefile bootstraps it with the original streak art via
; tools/rain_png.py; edit the PNG to restyle the drop.
RainWeatherGFX:
	INCBIN "gfx/overworld/rain.2bpp"
; Ground splash frames from gfx/overworld/rain_splash.png, normalized to
; color 2 like the drop so the splash always matches the rain color. It must
; directly follow RainWeatherGFX so the drop tile and the splash frames load
; together as one contiguous fetch. Widen the PNG by 8 pixels to add a second
; animation frame; the loader and RenderRain adapt to the frame count
; automatically.
RainSplashGFX:
	INCBIN "gfx/overworld/rain_splash.2bpp"
RainSplashGFXEnd:
	assert RainSplashGFX - RainWeatherGFX == LEN_2BPP_TILE, "rain.png must be a single 8x8 tile"
; Splash frames plus the gone window must leave falling time in each cell.
	assert (RainSplashGFXEnd - RainSplashGFX) / LEN_2BPP_TILE * RAIN_SPLASH_FRAME_PHASES + RAIN_GONE_PHASES + 8 <= RAIN_SPLASH_CELL, "Too many rain_splash.png frames: drops need falling time inside each splash cell"
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
; Cherry blossom petal rotation from gfx/overworld/cherry_blossom.png: four
; 8x8 frames side by side in tumble order - broad face, three-quarter, edge
; on, the other three-quarter - which RenderCherryBlossoms cycles through.
; The three lit shades build as colors 1-3, which ApplyWeatherTint fills with
; CherryBlossomPals while petals are falling: lightest pixel is the rim, then
; the body, then the shaded trailing edge. Add frames by widening the PNG and
; raising NUM_PETAL_FRAMES; they must still fit between WEATHER_TILE and the
; emote tiles at $f8.
CherryBlossomWeatherGFX:
	INCBIN "gfx/overworld/cherry_blossom.2bpp"
CherryBlossomWeatherGFXEnd:
	assert CherryBlossomWeatherGFXEnd - CherryBlossomWeatherGFX == NUM_PETAL_FRAMES * LEN_2BPP_TILE, "cherry_blossom.png must be NUM_PETAL_FRAMES 8x8 tiles wide"
	assert NUM_PETAL_FRAMES <= $f8 - WEATHER_TILE, "Cherry blossom frames overflow into the emote tiles at $f8"


; Music keepalive for long LCD-off graphics loads, and the tileset loader
; that uses it. These live in their own floating section (instead of ROM0
; or the packed weather bank) purely for space; the LoadTilesetGFX stub in
; home/map.asm preserves the old ROM0 entry point.
SECTION "Sound Keepalive", ROMX

_StartSoundKeepalive::
; Keep music playing across a stretch of LCD-off graphics loading.
; The VBlank interrupt normally drives UpdateSound; with the LCD disabled
; it never fires, so long loads audibly froze the sequencer (the current
; notes hang, then the song jumps). Program the free-running timer to
; 4096 Hz as a real-time clock; _PollSoundKeepalive converts elapsed ticks
; into UpdateSound calls at the right tempo. The timer interrupt is a
; no-op outside mobile (see Timer in home/mobile.asm), and the previous
; TAC value is restored by _StopSoundKeepalive.
	push af
	ldh a, [rTAC]
	ldh [hSoundKeepaliveTac], a
	xor a
	ldh [rTMA], a
	ldh [rTIMA], a
	ldh [hSoundKeepaliveTima], a
	ldh [hSoundKeepaliveAccLo], a
	ldh [hSoundKeepaliveAccHi], a
	ld a, (1 << rTAC_ON) | rTAC_4096_HZ
	ldh [rTAC], a
	ld a, 1
	ldh [hSoundKeepaliveOn], a
	pop af
	ret

_PollSoundKeepalive::
; Run queued music frames while the LCD is off. One frame is 4096 / ~59.73
; = ~68.6 timer ticks; the remainder carries over in a 16-bit accumulator,
; so timing self-corrects no matter how unevenly this gets polled. Call it
; at least every ~60ms (TIMA wraps at 62ms) during LCD-off work.
; A no-op unless _StartSoundKeepalive is active, so it is safe to sprinkle
; into loaders that are also used with the LCD on. Preserves all registers.
	push af
	ldh a, [hSoundKeepaliveOn]
	and a
	jr z, .off
	push bc
	ldh a, [rTIMA]
	ld b, a
	ldh a, [hSoundKeepaliveTima]
	ld c, a
	ld a, b
	ldh [hSoundKeepaliveTima], a
	sub c ; a = elapsed 4096 Hz ticks since the last poll (mod 256)
	ld c, a
	ldh a, [hSoundKeepaliveAccLo]
	add c
	ldh [hSoundKeepaliveAccLo], a
	ldh a, [hSoundKeepaliveAccHi]
	adc 0
	ldh [hSoundKeepaliveAccHi], a
	; One music frame is 4096 / ~59.73 = ~69 timer ticks. The timer is clocked
	; off the CPU, so in CGB double speed it runs at 8192 Hz and a music frame
	; costs ~137 ticks instead. Pick the threshold from the current speed, or
	; the song plays at double tempo during LCD-off loads.
	ld b, 69
	ldh a, [hCGB]
	and a
	jr z, .loop
	ldh a, [rKEY1]
	bit 7, a
	jr z, .loop
	ld b, 137
.loop
	ldh a, [hSoundKeepaliveAccHi]
	and a
	jr nz, .tick
	ldh a, [hSoundKeepaliveAccLo]
	cp b
	jr c, .caught_up
.tick
	ldh a, [hSoundKeepaliveAccLo]
	sub b
	ldh [hSoundKeepaliveAccLo], a
	ldh a, [hSoundKeepaliveAccHi]
	sbc 0
	ldh [hSoundKeepaliveAccHi], a
	push bc
	call UpdateSound
	pop bc
	jr .loop
.caught_up
	pop bc
.off
	pop af
	ret

_StopSoundKeepalive::
; Final catch-up tick, then hand sound updates back to the VBlank interrupt.
	call _PollSoundKeepalive
	push af
	xor a
	ldh [hSoundKeepaliveOn], a
	ldh a, [hSoundKeepaliveTac]
	ldh [rTAC], a
	pop af
	ret

_DecompressTilesetGFX::
; Decompress the current map's tileset into wDecompressScratch.
; Safe with the LCD on; does not touch VRAM.
	ld hl, wTilesetAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTilesetBank]
	ld e, a

	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a

	ld a, e
	ld de, wDecompressScratch
	call FarDecompress

	pop af
	ldh [rSVBK], a
	ret

_CopyTilesetGFX::
; Copy the decompressed tileset from wDecompressScratch into VRAM.
; Requires the LCD to be off. Split from the decompression step so
; ReloadTilesetAndPalettes can decompress before turning the LCD off.
; With the LCD off, general-purpose DMA runs immediately and moves each
; 2KB half in a fraction of a frame, where the old CopyBytes loops took
; about two frames each - this shortens the white flash when leaving
; the Pack, party and other submenus. (The ROM is CGB-only, so HDMA
; hardware is always present.)
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a

	ld a, HIGH(wDecompressScratch)
	ldh [rHDMA1], a
	ld a, LOW(wDecompressScratch)
	ldh [rHDMA2], a
	ld a, HIGH(vTiles2 - $8000)
	ldh [rHDMA3], a
	ld a, LOW(vTiles2)
	ldh [rHDMA4], a
	ld a, $7f tiles / 16 - 1 ; 127 blocks of 16 bytes
	ldh [rHDMA5], a ; general DMA: blocks until the copy completes

	ldh a, [rVBK]
	push af
	ld a, BANK(vTiles5)
	ldh [rVBK], a

	ld a, HIGH(wDecompressScratch + $80 tiles)
	ldh [rHDMA1], a
	ld a, LOW(wDecompressScratch + $80 tiles)
	ldh [rHDMA2], a
	ld a, HIGH(vTiles5 - $8000)
	ldh [rHDMA3], a
	ld a, LOW(vTiles5)
	ldh [rHDMA4], a
	ld a, $80 tiles / 16 - 1 ; 128 blocks of 16 bytes
	ldh [rHDMA5], a

	pop af
	ldh [rVBK], a

	pop af
	ldh [rSVBK], a

	call _PollSoundKeepalive

; These tilesets support dynamic per-mapgroup roof tiles.
	ld a, [wMapTileset]
	cp TILESET_JOHTO
	jr z, .load_roof
	cp TILESET_JOHTO_MODERN
	jr z, .load_roof
	cp TILESET_BATTLE_TOWER_OUTSIDE
	jr z, .load_roof
	jr .skip_roof

.load_roof
	farcall LoadMapGroupRoof

.skip_roof
	xor a
	ldh [hTileAnimFrame], a
	ret

_RebuildTimePalBuffers::
; CGB only; farcalled from DmgToCgbTimePals with bc/de/hl saved.
; Rebuild wBGPals2/wOBPals2 from the loaded palettes using the orders
; already written to rBGP/rOBP0, reapply the weather tint, and only then
; request the VBlank palette upload.
;
; Cancelling the request up front and re-raising it only after the tint
; is in place makes the whole rebuild atomic as far as VBlank's palette
; upload is concerned: it can never push the intermediate untinted
; buffers to the hardware. That race was visible as a one-frame bright
; flash - or a screen stuck at full brightness - when the start menu
; opened or closed during overcast, rain, or thunderstorm weather.
	xor a
	ldh [hCGBPalUpdate], a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals2)
	ldh [rSVBK], a
	ld hl, wBGPals2
	ld de, wBGPals1
	ldh a, [rBGP]
	ld b, a
	ld c, 8
	call CopyPals
	ld hl, wOBPals2
	ld de, wOBPals1
	ldh a, [rOBP0]
	ld b, a
	ld c, 8
	call CopyPals
	pop af
	ldh [rSVBK], a
	farcall ApplyWeatherTint
	; The buffers are consistent again; let VBlank push them.
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret
