; Overworld weather types (hCurWeather)
	const_def
	const OW_WEATHER_NONE
	const OW_WEATHER_OVERCAST
	const OW_WEATHER_RAIN
	const OW_WEATHER_THUNDERSTORM
	const OW_WEATHER_SNOW
	const OW_WEATHER_SANDSTORM
	const OW_WEATHER_CHERRY_BLOSSOMS
NUM_OW_WEATHERS EQU const_value

; Each daily selection packs a weather-area id into the low six bits and
; its overcast intensity into the high two bits.
WEATHER_AREA_MASK            EQU %00111111
WEATHER_INTENSITY_MASK       EQU %11000000
WEATHER_INTENSITY_OVERCAST   EQU %00000000
WEATHER_INTENSITY_RAIN       EQU %01000000
WEATHER_INTENSITY_THUNDER    EQU %10000000
NUM_DAILY_WEATHER_AREAS_PER_REGION EQU 4

; wWeatherDailyFlags
	const_def
	const WEATHER_DAILY_ROUTE_45_SAND_F
	const WEATHER_DAILY_RUINS_SAND_F
	const WEATHER_DAILY_CHERRYGROVE_BLOSSOMS_F

; One tile in VRAM bank 1 is reserved for the active weather particle.
; Tiles $f8-$ff are already reserved by overworld emotes.
WEATHER_TILE EQU $f4
