TrainerClassStatExp:
; Stat exp given to every Pokemon belonging to a trainer of this class.
; Entries correspond to trainer classes (see constants/trainer_constants.asm),
; in the same order as data/trainers/dvs.asm. Keep all three files in step.
;
; The stat formula uses sqrt(stat exp) / 4, so the value below translates to a
; bonus of 0-63 "points", and the actual stat gain is points * level / 100:
;
;       0 ->  0 pts        10,000 -> 25 pts        36,864 -> 48 pts
;   2,304 -> 12 pts        12,544 -> 28 pts        40,000 -> 50 pts
;   4,096 -> 16 pts        20,736 -> 36 pts        43,264 -> 52 pts
;   5,000 -> 17 pts        25,600 -> 40 pts        50,176 -> 56 pts
;   6,400 -> 20 pts        30,976 -> 44 pts        55,000 -> 58 pts
;   7,744 -> 22 pts        33,856 -> 46 pts        60,000 -> 61 pts
;   9,216 -> 24 pts                                65,535 -> 63 pts (max)

	dw  6400 ; FALKNER
	dw  7744 ; WHITNEY
	dw  6400 ; BUGSY
	dw  9216 ; MORTY
	dw 10816 ; PRYCE
	dw 10816 ; JASMINE
	dw  9216 ; CHUCK
	dw 12544 ; CLAIR
	dw  9216 ; RIVAL1
	dw     0 ; POKEMON_PROF
	dw 20736 ; WILL
	dw 12544 ; CAL
	dw 25600 ; BRUNO
	dw 30976 ; KAREN
	dw 25600 ; KOGA
	dw 36864 ; CHAMPION
	dw 36864 ; BROCK
	dw 30976 ; MISTY
	dw 25600 ; LT_SURGE
	dw     0 ; SCIENTIST
	dw 30976 ; ERIKA
	dw     0 ; YOUNGSTER
	dw     0 ; SCHOOLBOY
	dw     0 ; BIRD_KEEPER
	dw     0 ; LASS
	dw 33856 ; JANINE
	dw 10000 ; COOLTRAINERM
	dw 10000 ; COOLTRAINERF
	dw     0 ; BEAUTY
	dw     0 ; POKEMANIAC
	dw     0 ; GRUNTM
	dw  5000 ; GENTLEMAN
	dw     0 ; SKIER
	dw     0 ; TEACHER
	dw 36864 ; SABRINA
	dw     0 ; BUG_CATCHER
	dw     0 ; FISHER
	dw  5000 ; SWIMMERM
	dw  5000 ; SWIMMERF
	dw     0 ; SAILOR
	dw     0 ; SUPER_NERD
	dw 30976 ; RIVAL2
	dw     0 ; GUITARIST
	dw     0 ; HIKER
	dw     0 ; BIKER
	dw 40000 ; BLAINE
	dw     0 ; BURGLAR
	dw     0 ; FIREBREATHER
	dw  5000 ; JUGGLER
	dw  5000 ; BLACKBELT_T
	dw  2304 ; EXECUTIVEM
	dw  5000 ; PSYCHIC_T
	dw     0 ; PICNICKER
	dw     0 ; CAMPER
	dw  2304 ; EXECUTIVEF
	dw     0 ; SAGE
	dw     0 ; MEDIUM
	dw     0 ; BOARDER
	dw     0 ; POKEFANM
	dw  4096 ; KIMONO_GIRL
	dw     0 ; TWINS
	dw     0 ; POKEFANF
	dw 55000 ; RED
	dw 50176 ; BLUE
	dw     0 ; OFFICER
	dw     0 ; GRUNTF
	dw  9216 ; MYSTICALMAN
	dw 12544 ; CRYSTAL
	dw 36864 ; CRYSTAL2
	dw  6400 ; PROTON
	dw  6400 ; PETREL
	dw  7744 ; ARIANA
	dw 25600 ; ARCHER
	dw  9216 ; PETREL_DIRECTOR
	dw  5000 ; HEX_MANIAC
	dw  5000 ; COSPLAYER
	dw  4096 ; NINJA
	dw 43264 ; AGATHA
	dw 43264 ; LORELEI
	dw 65535 ; RED2
	dw 60000 ; BLUE_CLOAK
	dw 60000 ; GREEN
	dw  5000 ; BATTLE_GIRL
	dw  5000 ; TAMER
	dw  5000 ; THUG
	dw     0 ; AROMA_LADY
