BattleCommand_StartSandstorm:
; startsandstorm

	ld a, [wBattleWeather]
	and WEATHER_TYPE_MASK
	cp WEATHER_SANDSTORM
	jr z, .failed

	ld a, WEATHER_SANDSTORM
	farcall SetBattleWeatherPreservingSuppression
	ld a, 5
	ld [wWeatherCount], a
	call AnimateCurrentMove
	ld hl, SandstormBrewedText
	jp StdBattleTextbox

.failed
	call AnimateFailedMove
	jp PrintButItFailed
