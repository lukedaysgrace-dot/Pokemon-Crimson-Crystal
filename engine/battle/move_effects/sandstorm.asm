BattleCommand_StartSandstorm:
; startsandstorm

	ld a, [wBattleWeather]
	and WEATHER_TYPE_MASK
	cp WEATHER_SANDSTORM
	jr z, .failed

	ld b, WEATHER_SANDSTORM
	farcall SetBattleWeatherFromB
	ld b, WEATHER_SANDSTORM
	farcall SetWeatherDurationFromUserItem
	call AnimateCurrentMove
	ld hl, SandstormBrewedText
	jp StdBattleTextbox

.failed
	call AnimateFailedMove
	jp PrintButItFailed
