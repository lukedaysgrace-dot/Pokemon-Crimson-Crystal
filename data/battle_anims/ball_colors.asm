; Full palettes shared by battle throws/send-outs and both summary balls.
; Entries: runtime item ID, white, lower/highlight color, upper color, black.
; Coral's exact color pairs, except the retained Master/Heavy/Safari colors
; and the authored yellow-over-white Park Ball. No saved item IDs change.

BallColors:
	db MASTER_BALL
MasterBallPurplePal:
	RGB 31, 31, 31
	RGB 24, 14, 31
	RGB 14, 6, 22
	RGB 0, 0, 0
	db ULTRA_BALL
	RGB 31, 31, 31
	RGB 31, 31, 7
	RGB 31, 16, 1
	RGB 0, 0, 0
	db GREAT_BALL
	RGB 31, 31, 31
	RGB 8, 12, 31
	RGB 1, 4, 31
	RGB 0, 0, 0
	db POKE_BALL
PokeBallPal:
	RGB 31, 31, 31
	RGB 31, 19, 24
	RGB 30, 10, 6
	RGB 0, 0, 0
	db HEAVY_BALL
	RGB 31, 31, 31
	RGB 25, 25, 25
	RGB 13, 13, 13
	RGB 0, 0, 0
	db LEVEL_BALL
	RGB 31, 31, 31
	RGB 31, 31, 7
	RGB 7, 7, 7
	RGB 0, 0, 0
	db LURE_BALL
	RGB 31, 31, 31
	RGB 30, 12, 8
	RGB 8, 12, 31
	RGB 0, 0, 0
	db FAST_BALL
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 31, 7, 0
	RGB 0, 0, 0
	db FRIEND_BALL
	RGB 31, 31, 31
	RGB 30, 10, 6
	RGB 5, 14, 0
	RGB 0, 0, 0
	db MOON_BALL
	RGB 31, 31, 31
	RGB 31, 31, 7
	RGB 8, 12, 31
	RGB 0, 0, 0
	db LOVE_BALL
	RGB 31, 31, 31
	RGB 31, 22, 29
	RGB 31, 12, 20
	RGB 0, 0, 0
	db PARK_BALL
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 7
	RGB 0, 0, 0
	db SAFARI_BALL
	RGB 31, 31, 31
	RGB 12, 25, 1
	RGB 5, 14, 0
	RGB 0, 0, 0
	db -1
.end
	assert .end - BallColors == NUM_CAUGHT_BALLS * (1 + 1 palettes) + 1
