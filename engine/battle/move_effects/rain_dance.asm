BattleCommand_StartRain:
; startrain
	ld a, WEATHER_RAIN
	farcall SetBattleWeatherPreservingSuppression
	ld a, 5
	ld [wWeatherCount], a
	call AnimateCurrentMove
	ld hl, DownpourText
	jp StdBattleTextbox
