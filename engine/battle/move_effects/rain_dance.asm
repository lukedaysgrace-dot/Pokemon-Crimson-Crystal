BattleCommand_StartRain:
; startrain
	ld b, WEATHER_RAIN
	farcall SetBattleWeatherFromB
	ld a, 5
	ld [wWeatherCount], a
	call AnimateCurrentMove
	ld hl, DownpourText
	jp StdBattleTextbox
