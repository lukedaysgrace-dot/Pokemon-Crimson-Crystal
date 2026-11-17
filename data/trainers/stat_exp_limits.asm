TrainerStatExpLevelLimits:
; Maximum level, then maximum authored fallback training in each stat.
; Applies to generic classes only. Important characters and exact-match
; classes bypass this table and use stat_exp_matching.asm instead.
; Level 255 is a sentinel for malformed external parties as well as L100.
	db 10
	dw 1024  ;  8 points
	db 16
	dw 2304  ; 12 points
	db 20
	dw 3136  ; 14 points
	db 25
	dw 4096  ; 16 points
	db 30
	dw 5184  ; 18 points
	db 34
	dw 6400  ; 20 points
	db 38
	dw 7744  ; 22 points
	db 45
	dw 10816 ; 26 points
	db 50
	dw 12544 ; 28 points
	db 54
	dw 14400 ; 30 points
	db 58
	dw 15376 ; 31 points
	db 62
	dw 17424 ; 33 points
	db 66
	dw 18496 ; 34 points
	db 70
	dw 19600 ; 35 points
	db 74
	dw 20736 ; 36 points
	db 78
	dw 21904 ; 37 points
	db 82
	dw 23104 ; 38 points
	db 86
	dw 25600 ; 40 points
	db 90
	dw 30976 ; 44 points
	db 255
	dw 36864 ; 48 points
