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

; wVramState
; Keep the current weather available for palettes and battle initialization
; while temporarily preventing its overworld OAM particles from being drawn.
DEF VRAMSTATE_SUPPRESS_WEATHER_F EQU 2

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
	const WEATHER_DAILY_ROUTE_38_SAND_F
	const WEATHER_DAILY_ROUTE_3_SAND_F
	const WEATHER_DAILY_ROUTE_9_SAND_F
	const WEATHER_DAILY_ROUTE_22_SAND_F

; Cherry blossom petals tumble through NUM_PETAL_FRAMES rotation frames,
; holding each one for PETAL_SPIN_FRAMES frames. The two shared timers they
; read run at the SLOWEST petal's pace - one pixel down every
; PETAL_FALL_PERIOD frames, one pixel left on PETAL_DRIFT_STEPS frames out of
; every PETAL_DRIFT_PERIOD - and each petal folds a timer in more than once to
; go faster (see CherryBlossomSeeds). PETAL_SPIN_FRAMES, PETAL_FALL_PERIOD and
; PETAL_DRIFT_PERIOD are powers of two so the free-running VBlank counter can
; drive every cadence without stuttering where it wraps.
DEF NUM_PETAL_FRAMES    EQU 4
DEF PETAL_SPIN_FRAMES   EQU 8
DEF PETAL_FALL_PERIOD   EQU 4
DEF PETAL_DRIFT_PERIOD  EQU 64
DEF PETAL_DRIFT_STEPS   EQU 7

; Per-petal variation, packed into the params byte of each CherryBlossomSeeds
; entry. Bits 0-1 offset the tumble so neighbours are never on the same frame.
; Each of the three speed bits folds a shared timer in one more time, which is
; what gives sixteen petals six different fall speeds and drift angles without
; a byte of per-petal state; multiplying a timer that wraps at the screen
; dimension stays seamless, since any whole number of screens is still zero.
	const_def 2
	const PETAL_FALL_2_F  ; drops at twice the base speed
	const PETAL_FALL_3_F  ; with FALL_2, three times
	const PETAL_DRIFT_2_F ; slides sideways twice as far per pixel fallen
	const PETAL_REVERSE_F ; tumbles backwards

; Tiles in VRAM bank 1 reserved for the active weather particle: the rain
; drop and its splash frames, or the cherry blossom rotation frames.
; Tiles $f8-$ff are already reserved by overworld emotes.
WEATHER_TILE EQU $f4
