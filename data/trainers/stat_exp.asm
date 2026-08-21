TrainerClassStatExp:
; Stat exp given to every Pokemon belonging to a trainer of this class.
; Entries correspond to trainer classes (see constants/trainer_constants.asm),
; in the same order as data/trainers/dvs.asm. Keep all three files in step.
; Hard Mode only: GetTrainerStatExp returns 0 for every class in Normal mode.
;
; The stat formula uses sqrt(stat exp) / 4, so the value below translates to a
; bonus of 0-63 "points", and the actual stat gain is points * level / 100.
; Because of that level term, the same value is worth far more late than early,
; so the table is tuned on the real bonus at the level the class is fought at,
; shown in each comment as "+N @Lx".
;
; Tiers:  0 = ordinary route trainer
;      5,000 = minor named / themed trainer (flat, self-scaling with level)
;      7,744 = elite generic (Cooltrainers)
;  6,400- 20,736 = Johto bosses, Rocket admins, rivals
;  25,600- 38,416 = Elite Four and Champion
;  43,264- 55,696 = Kanto gyms
;  57,600- 65,535 = Silver Cave / Pallet Town superbosses
;
; Reference:   2,304 -> 12 pts    20,736 -> 36 pts    50,176 -> 56 pts
;              6,400 -> 20 pts    25,600 -> 40 pts    55,696 -> 59 pts
;             12,544 -> 28 pts    38,416 -> 49 pts    60,000 -> 61 pts
;             16,384 -> 32 pts    43,264 -> 52 pts    65,535 -> 63 pts (max)

	dw  6400 ; FALKNER          ; 20 pts, +2 @L10
	dw  6400 ; WHITNEY          ; 20 pts, +4 @L21
	dw  6400 ; BUGSY            ; 20 pts, +3 @L16
	dw  6400 ; MORTY            ; 20 pts, +5 @L25
	dw 14400 ; PRYCE            ; 30 pts, +11 @L38
	dw 11664 ; JASMINE          ; 27 pts, +9 @L36
	dw  7744 ; CHUCK            ; 22 pts, +6 @L31
	dw 18496 ; CLAIR            ; 34 pts, +15 @L45
	dw 26896 ; RIVAL1           ; 41 pts, +23 @L57
	dw     0 ; POKEMON_PROF
	dw 24336 ; WILL             ; 39 pts, +22 @L57
	dw 41616 ; CAL              ; 51 pts, +46 @L92
	dw 24336 ; BRUNO            ; 39 pts, +22 @L58
	dw 24336 ; KAREN            ; 39 pts, +23 @L59
	dw 24336 ; KOGA             ; 39 pts, +22 @L58
	dw 24336 ; CHAMPION         ; 39 pts, +23 @L59
	dw 41616 ; BROCK            ; 51 pts, +45 @L90
	dw 40000 ; MISTY            ; 50 pts, +43 @L87
	dw 36864 ; LT_SURGE         ; 48 pts, +38 @L81
	dw     0 ; SCIENTIST
	dw 38416 ; ERIKA            ; 49 pts, +42 @L86
	dw     0 ; YOUNGSTER
	dw     0 ; SCHOOLBOY
	dw     0 ; BIRD_KEEPER
	dw     0 ; LASS
	dw 40000 ; JANINE           ; 50 pts, +44 @L88
	dw  7744 ; COOLTRAINERM     ; 22 pts, +3 @L15 / +14 @L66
	dw  7744 ; COOLTRAINERF     ; 22 pts, +5 @L24 / +13 @L61
	dw     0 ; BEAUTY
	dw     0 ; POKEMANIAC
	dw     0 ; GRUNTM
	dw  5000 ; GENTLEMAN        ; 17 pts, +3 @L20 / +10 @L63
	dw     0 ; SKIER
	dw     0 ; TEACHER
	dw 41616 ; SABRINA          ; 51 pts, +46 @L91
	dw     0 ; BUG_CATCHER
	dw     0 ; FISHER
	dw  5000 ; SWIMMERM         ; 17 pts, +3 @L18 / +10 @L64
	dw  5000 ; SWIMMERF         ; 17 pts, +3 @L20 / +10 @L63
	dw     0 ; SAILOR
	dw     0 ; SUPER_NERD
	dw 40000 ; RIVAL2           ; 50 pts, +44 @L89
	dw     0 ; GUITARIST
	dw     0 ; HIKER
	dw     0 ; BIKER
	dw 41616 ; BLAINE           ; 51 pts, +46 @L91
	dw     0 ; BURGLAR
	dw     0 ; FIREBREATHER
	dw  5000 ; JUGGLER          ; 17 pts, +2 @L16 / +10 @L59
	dw  5000 ; BLACKBELT_T      ; 17 pts, +4 @L24 / +10 @L60
	dw 17424 ; EXECUTIVEM       ; 33 pts, +11 @L35
	dw  5000 ; PSYCHIC_T        ; 17 pts, +3 @L18 / +10 @L60
	dw     0 ; PICNICKER
	dw     0 ; CAMPER
	dw 17424 ; EXECUTIVEF       ; 33 pts, +11 @L35
	dw     0 ; SAGE
	dw     0 ; MEDIUM
	dw     0 ; BOARDER
	dw     0 ; POKEFANM
	dw  4096 ; KIMONO_GIRL      ; 16 pts, +3 @L20 / +3 @L21
	dw     0 ; TWINS
	dw     0 ; POKEFANF
	dw 43264 ; RED              ; 52 pts, +48 @L94
	dw 41616 ; BLUE             ; 51 pts, +46 @L92
	dw     0 ; OFFICER
	dw     0 ; GRUNTF
	dw  7056 ; MYSTICALMAN      ; 21 pts, +5 @L27
	dw  7744 ; CRYSTAL          ; 22 pts, +6 @L31
	dw 18496 ; CRYSTAL2         ; 34 pts, +15 @L45
	dw 14400 ; PROTON           ; 30 pts, +11 @L39
	dw 12544 ; PETREL           ; 28 pts, +10 @L37
	dw 15376 ; ARIANA           ; 31 pts, +12 @L40
	dw 15376 ; ARCHER           ; 31 pts, +12 @L40
	dw 13456 ; PETREL_DIRECTOR  ; 29 pts, +11 @L38
	dw  5000 ; HEX_MANIAC       ; 17 pts, +2 @L17 / +3 @L22
	dw  5000 ; COSPLAYER        ; 17 pts, +3 @L23 / +10 @L61
	dw  4096 ; NINJA            ; 16 pts, +9 @L58 / +9 @L60
	dw 43264 ; AGATHA           ; 52 pts, +48 @L93
	dw 43264 ; LORELEI          ; 52 pts, +48 @L94
	dw 46656 ; RED2             ; 54 pts, +54 @L100
	dw 46656 ; BLUE_CLOAK       ; 54 pts, +53 @L99
	dw 46656 ; GREEN            ; 54 pts, +53 @L99
	dw  5000 ; BATTLE_GIRL      ; 17 pts, +10 @L59 / +10 @L60
	dw  5000 ; TAMER            ; 17 pts, +10 @L60 / +10 @L61
	dw  5000 ; THUG             ; 17 pts, +2 @L16 / +3 @L19
	dw     0 ; AROMA_LADY
	dw 43264 ; CRYSTAL3         ; 52 pts, +47 @L92
	dw 44944 ; RIVAL3           ; 53 pts, +50 @L96
	dw 43264 ; FALKNER_REMATCH  ; 52 pts, +48 @L94
	dw 43264 ; BUGSY_REMATCH    ; 52 pts, +48 @L94
	dw 43264 ; WHITNEY_REMATCH  ; 52 pts, +49 @L95
	dw 44944 ; MORTY_REMATCH    ; 53 pts, +50 @L95
	dw 44944 ; CHUCK_REMATCH    ; 53 pts, +50 @L95
	dw 44944 ; JASMINE_REMATCH  ; 53 pts, +50 @L95
	dw 44944 ; PRYCE_REMATCH    ; 53 pts, +50 @L96
	dw 44944 ; CLAIR_REMATCH    ; 53 pts, +50 @L96
	dw 44944 ; WILL_REMATCH     ; 53 pts, +51 @L97
	dw 46656 ; KOGA_REMATCH     ; 54 pts, +52 @L97
	dw 46656 ; BRUNO_REMATCH    ; 54 pts, +52 @L98
	dw 46656 ; KAREN_REMATCH    ; 54 pts, +52 @L98
	dw 46656 ; CHAMPION_REMATCH ; 54 pts, +52 @L98
