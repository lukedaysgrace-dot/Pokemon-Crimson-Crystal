BattleCommand_StartRain:
; startrain
	ld b, WEATHER_RAIN
	farcall SetBattleWeatherFromB
	ld b, WEATHER_RAIN
	farcall SetWeatherDurationFromUserItem
	call AnimateCurrentMove
	ld hl, DownpourText
	jp StdBattleTextbox
