; Overworld weather types (hCurWeather)
;
; Order matters. Several checks are range comparisons rather than equality:
; everything below OW_WEATHER_RAIN is particle-free, and RenderWeather's
; dispatch falls through to cherry blossoms for anything it does not name.
; OW_WEATHER_HARSH_SUN therefore sits between NONE and OVERCAST, where it
; inherits "no particles" from both of those tests for free. Do not append
; new particle-free weather to the end of this list.
	const_def
	const OW_WEATHER_NONE     ; plain sunny: no tint, no battle weather
	const OW_WEATHER_HARSH_SUN ; daytime only; falls back to NONE at night
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

; Set by OpenText and cleared by CloseText: the plain speech textbox is up, and
; nothing else. Bit 6 alone only says the map has been reanchored for some
; window or other, and there is no telling where that window sits on screen -
; a mart list or a yes/no box lands in the top half, right where the particles
; are. The speech textbox is the one whose shape is known: the bottom six rows,
; leaving the map visible above it. That is what lets weather keep falling
; through a conversation, clipped to SPEECH_TEXTBOX_CLIP_Y.
DEF VRAMSTATE_SPEECH_TEXTBOX_F EQU 3

; Set once the speech textbox has actually been drawn and cleared as soon as
; CloseText starts taking it away, which is several frames before the
; conversation is over. Only this one holds the particles above the box.
; Keeping the two apart is what stops the weather from either drawing over a
; box that is still on screen or, worse, deserting the bottom third of the map
; for the whole of a close that has already erased the box.
DEF VRAMSTATE_TEXTBOX_DRAWN_F EQU 4

; Each daily selection packs a weather-area id into the low six bits and
; its overcast intensity into the high two bits.
WEATHER_AREA_MASK            EQU %00111111
WEATHER_INTENSITY_MASK       EQU %11000000
WEATHER_INTENSITY_OVERCAST   EQU %00000000
WEATHER_INTENSITY_RAIN       EQU %01000000
WEATHER_INTENSITY_THUNDER    EQU %10000000
WEATHER_INTENSITY_HARSH_SUN  EQU %11000000
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
; holding each one for PETAL_SPIN_FRAMES frames.
;
; Every petal moves in single-pixel steps; what differs between them is how
; often a step lands. Each speed tier owns a shared timer that counts pixels at
; its own pace, and the tiers step on frames that never coincide, so a petal
; that reads two of them still only ever moves one pixel in a frame:
;
;   fall, slow tier   hWeatherYTimer     one pixel every PETAL_FALL_PERIOD
;                                        frames (the base pace)
;   fall, mid tier    hPetalFallTimerB   one pixel every other frame, on the
;                                        frames the slow tier skips
;   fall, fast petals read both timers, so they step on three frames out of
;                                        every four
;   drift             hWeatherXTimer     one pixel sideways on PETAL_DRIFT_STEPS
;                                        frames out of every PETAL_DRIFT_PERIOD
;   drift, wide       hPetalDriftTimerB  the same again, interleaved between
;                                        those frames
;
; The alternative - one timer per axis, read two or three times over - is what
; this replaced: reading a timer twice moves the petal two pixels at once and
; then holds it still for the rest of the window, and at these speeds that
; stutter is plainly visible. All cadences ride the free-running VBlank
; counter, whose 256-frame period is a whole multiple of each pattern, so
; nothing jolts where it wraps; PETAL_SPIN_FRAMES, PETAL_FALL_PERIOD and
; PETAL_DRIFT_PERIOD are powers of two so the counter can drive them with a
; mask.
DEF NUM_PETAL_FRAMES    EQU 4
DEF PETAL_SPIN_FRAMES   EQU 8
DEF PETAL_FALL_PERIOD   EQU 4
DEF PETAL_DRIFT_PERIOD  EQU 64
DEF PETAL_DRIFT_STEPS   EQU 7 ; per drift timer; wide petals read two of them

; Which timer a frame of PetalDriftPattern steps.
DEF PETAL_DRIFT_STEP_A_F EQU 0 ; hWeatherXTimer, read by every petal
DEF PETAL_DRIFT_STEP_B_F EQU 1 ; hPetalDriftTimerB, read only by wide drifters

; Per-petal variation, packed into the params byte of each CherryBlossomSeeds
; entry. Bits 0-1 offset the tumble so neighbours are never on the same frame.
; The speed bits pick which shared timers the petal reads, which is what gives
; the petals six different fall speeds and drift angles without a byte of
; per-petal state.
	const_def 2
	const PETAL_FALL_2_F  ; reads the mid fall timer instead of the slow one
	const PETAL_FALL_3_F  ; with FALL_2, reads both; on its own it does nothing
	const PETAL_DRIFT_2_F ; also reads the second drift timer, leaning it over
	const PETAL_REVERSE_F ; tumbles backwards

; How harsh sunlight tints the seven map BG palettes, and why it is shaped
; the way it is.
;
; The morning lighting set in the tileset .pal files differs from day in
; exactly one way: the lightest color of each palette drops its blue (27 -> 16
; in gfx/tilesets/johto.pal) while the midtones and shadows are left alone.
; That is what makes morning read as a pale, creamy, low sun. Harsh noon has
; to do the opposite or it is indistinguishable from it, so:
;
;   - the highlight (color 0 of each palette) only ever gains, moving a
;     fraction of its remaining headroom toward white. Blue is lifted along
;     with everything else, so whites blow out instead of going cream.
;   - the midtones and shadows (colors 1-3) lose blue and a little green,
;     which warms them and deepens them.
;
; Highlights up, shadows warm and down: that is contrast, which is what
; strong overhead light actually looks like, and it cannot be confused with
; morning's uniform wash. Red is never cut anywhere.
;
; All of this is built against the morning and day palettes, which is why
; harsh sun is gated to those two times of day. The night palette is dark and
; heavily blue, so taking a quarter of its blue out is taking out most of what
; the palette has, and the map lands on muddy brown instead of bright. A day
; that rolls harsh sun therefore shows as plain sun until sunrise; the roll
; itself is untouched and comes back on its own.
;
; All four are shift counts, so a SMALLER number is a STRONGER effect.
; SUN_SHADOW_BLUE_SHIFT is the one to reach for first; 3 is a gentle haze
; and 1 is aggressively orange. Bright water is the color most sensitive to
; it, so check a coastline before settling on anything below 2.
DEF SUN_HILIGHT_LIFT_SHIFT  EQU 2 ; highlights gain 1/4 of their headroom
DEF SUN_HILIGHT_RED_SHIFT   EQU 3 ; and red gains another 1/8 on top of that
DEF SUN_SHADOW_BLUE_SHIFT   EQU 2 ; midtones and shadows give up 1/4 blue
DEF SUN_SHADOW_GREEN_SHIFT  EQU 4 ; and 1/16 green

; Tiles in VRAM bank 1 reserved for the active weather particle: the rain
; drop and its splash frames, or the cherry blossom rotation frames.
; Tiles $f8-$ff are already reserved by overworld emotes.
WEATHER_TILE EQU $f4
