BattleCommand_StartSun:
; startsun
	ld a, WEATHER_SUN
	farcall SetBattleWeatherPreservingSuppression
	ld a, 5
	ld [wWeatherCount], a
	call AnimateCurrentMove
	ld hl, SunGotBrightText
	jp StdBattleTextbox
