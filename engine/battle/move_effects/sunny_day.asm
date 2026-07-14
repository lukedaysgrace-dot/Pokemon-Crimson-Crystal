BattleCommand_StartSun:
; startsun
	ld b, WEATHER_SUN
	farcall SetBattleWeatherFromB
	ld a, 5
	ld [wWeatherCount], a
	call AnimateCurrentMove
	ld hl, SunGotBrightText
	jp StdBattleTextbox
