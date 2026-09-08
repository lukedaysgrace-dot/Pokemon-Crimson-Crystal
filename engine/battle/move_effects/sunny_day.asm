BattleCommand_StartSun:
; startsun
	ld b, WEATHER_SUN
	farcall SetBattleWeatherFromB
	ld b, WEATHER_SUN
	farcall SetWeatherDurationFromUserItem
	call AnimateCurrentMove
	ld hl, SunGotBrightText
	jp StdBattleTextbox
