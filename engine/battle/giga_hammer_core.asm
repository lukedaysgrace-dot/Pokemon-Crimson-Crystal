; Giga Hammer-style battle commands (Battle Core bank) - keeps Effect Commands bank under its limit.

BattleGigaHammer_CheckCore:
	ldh a, [hBattleTurn]
	ld b, a
	and a
	ld hl, wPlayerGigaHammerLock
	jr z, .got_lock
	ld hl, wEnemyGigaHammerLock
.got_lock
	ld a, [hl]
	and a
	ret z
	ld c, a
	ld a, b
	and a
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	jr z, .got_move
	ld a, [wEnemyMoveStruct + MOVE_ANIM]
.got_move
	cp c
	ret nz
	ld a, b
	and a
	jr nz, .no_repick
	ld a, 1
	ld [wPlayerMustRechooseMove], a
.no_repick
	call BattleGigaHammer_ApplyFailAnimAndText
	callfar EndMoveEffect
	ret

BattleGigaHammer_ApplyFailAnimAndText:
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleGigaHammer_SetLockCore:
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld hl, wPlayerGigaHammerLock
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	jr .set
.enemy
	ld hl, wEnemyGigaHammerLock
	ld a, [wEnemyMoveStruct + MOVE_ANIM]
.set
	ld [hl], a
	ret

ApplyOverworldBattleWeather:
; Carry the current overworld weather into the battle, Gen 3-style.
; Rain and thunderstorms rain, sandstorms rage, snow becomes hail, and
; clear daytime skies outdoors bring strong sunlight. Weather-summoning
; abilities on send-out still override this, as they should.
; Farcalled from BattleIntro; lives here because the Battle Core bank
; is full.
	ld a, [wLinkMode]
	and a
	ret nz
	ldh a, [hCurWeather]
	cp OW_WEATHER_RAIN
	jr z, .rain
	cp OW_WEATHER_THUNDERSTORM
	jr z, .rain
	cp OW_WEATHER_SNOW
	jr z, .hail
	cp OW_WEATHER_SANDSTORM
	jr z, .sandstorm
	cp OW_WEATHER_OVERCAST
	ret z
; No particle weather (or cherry blossoms) means clear skies:
; strong sunlight, but only outdoors during the day.
	ld a, [wEnvironment]
	cp TOWN
	jr z, .clear_skies
	cp ROUTE
	ret nz
.clear_skies
	ld a, [wTimeOfDay]
	cp NITE_F
	ret nc ; no bright sun at night or in darkness
	ld a, WEATHER_SUN
	ld de, SUNNY_DAY
	ld hl, SunGotBrightText
	jr .apply
.rain
	ld a, WEATHER_RAIN
	ld de, RAIN_DANCE
	ld hl, DownpourText
	jr .apply
.hail
	ld a, WEATHER_HAIL
	ld de, HAIL
	ld hl, ItStartedToHailText
	jr .apply
.sandstorm
	ld a, WEATHER_SANDSTORM
	ld de, SANDSTORM
	ld hl, SandstormBrewedText
.apply
	ld [wBattleWeather], a
	ld a, 255 ; effectively lasts the whole battle
	ld [wWeatherCount], a
	push de
	call StdBattleTextbox
	pop de
	; Play the matching move animation (de) so the weather visibly sweeps
	; the field right after its message, before any send-out.
	xor a
	ldh [hBattleTurn], a
	ld [wNumHits], a
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	call WaitBGMap
	predef PlayBattleAnim
	ret
