TrainerClassStatExp:
; Authored fallback training in trainer-constant/DV-table order.
; Hard Mode only; Normal Mode always returns zero.
; Matching classes have zero placeholders here because their five words are
; computed by ApplyTrainerStatExpCore from stat_exp_matching.asm instead.
; Themed generic values remain bounded by stat_exp_limits.asm.
;

	dw     0 ; FALKNER          ; party match + 2 points
	dw     0 ; WHITNEY          ; party match + 2 points
	dw     0 ; BUGSY            ; party match + 2 points
	dw     0 ; MORTY            ; party match + 2 points
	dw     0 ; PRYCE            ; party match + 2 points
	dw     0 ; JASMINE          ; party match + 2 points
	dw     0 ; CHUCK            ; party match + 2 points
	dw     0 ; CLAIR            ; party match + 2 points
	dw     0 ; RIVAL1           ; party match + 2 points
	dw     0 ; POKEMON_PROF
	dw     0 ; WILL             ; party match + 2 points
	dw     0 ; CAL              ; party match + 2 points
	dw     0 ; BRUNO            ; party match + 2 points
	dw     0 ; KAREN            ; party match + 2 points
	dw     0 ; KOGA             ; party match + 2 points
	dw     0 ; CHAMPION         ; party match + 2 points
	dw     0 ; BROCK            ; party match + 2 points
	dw     0 ; MISTY            ; party match + 2 points
	dw     0 ; LT_SURGE         ; party match + 2 points
	dw     0 ; SCIENTIST
	dw     0 ; ERIKA            ; party match + 2 points
	dw     0 ; YOUNGSTER
	dw     0 ; SCHOOLBOY
	dw     0 ; BIRD_KEEPER
	dw     0 ; LASS
	dw     0 ; JANINE           ; party match + 2 points
	dw     0 ; COOLTRAINERM     ; exact party match
	dw     0 ; COOLTRAINERF     ; exact party match
	dw     0 ; BEAUTY
	dw     0 ; POKEMANIAC
	dw     0 ; GRUNTM
	dw  5000 ; GENTLEMAN        ; up to 17 points (level-limited)
	dw     0 ; SKIER
	dw     0 ; TEACHER
	dw     0 ; SABRINA          ; party match + 2 points
	dw     0 ; BUG_CATCHER
	dw     0 ; FISHER
	dw  5000 ; SWIMMERM         ; up to 17 points (level-limited)
	dw  5000 ; SWIMMERF         ; up to 17 points (level-limited)
	dw     0 ; SAILOR
	dw     0 ; SUPER_NERD
	dw     0 ; RIVAL2           ; party match + 2 points
	dw     0 ; GUITARIST
	dw     0 ; HIKER
	dw     0 ; BIKER
	dw     0 ; BLAINE           ; party match + 2 points
	dw     0 ; BURGLAR
	dw     0 ; FIREBREATHER
	dw  5000 ; JUGGLER          ; up to 17 points (level-limited)
	dw  5000 ; BLACKBELT_T      ; up to 17 points (level-limited)
	dw     0 ; EXECUTIVEM       ; party match + 2 points
	dw  5000 ; PSYCHIC_T        ; up to 17 points (level-limited)
	dw     0 ; PICNICKER
	dw     0 ; CAMPER
	dw     0 ; EXECUTIVEF       ; party match + 2 points
	dw     0 ; SAGE
	dw     0 ; MEDIUM
	dw     0 ; BOARDER
	dw     0 ; POKEFANM
	dw     0 ; KIMONO_GIRL      ; party match + 2 points
	dw     0 ; TWINS
	dw     0 ; POKEFANF
	dw     0 ; RED              ; party match + 2 points
	dw     0 ; BLUE             ; party match + 2 points
	dw     0 ; OFFICER
	dw     0 ; GRUNTF
	dw     0 ; MYSTICALMAN      ; party match + 2 points
	dw     0 ; CRYSTAL          ; party match + 2 points
	dw     0 ; CRYSTAL2         ; party match + 2 points
	dw     0 ; PROTON           ; party match + 2 points
	dw     0 ; PETREL           ; party match + 2 points
	dw     0 ; ARIANA           ; party match + 2 points
	dw     0 ; ARCHER           ; party match + 2 points
	dw     0 ; PETREL_DIRECTOR  ; party match + 2 points
	dw  5000 ; HEX_MANIAC       ; up to 17 points (level-limited)
	dw  5000 ; COSPLAYER        ; up to 17 points (level-limited)
	dw  4096 ; NINJA            ; up to 16 points (level-limited)
	dw     0 ; AGATHA           ; party match + 2 points
	dw     0 ; LORELEI          ; party match + 2 points
	dw     0 ; RED2             ; party match + 2 points
	dw     0 ; BLUE_CLOAK       ; party match + 2 points
	dw     0 ; GREEN            ; party match + 2 points
	dw  5000 ; BATTLE_GIRL      ; up to 17 points (level-limited)
	dw  5000 ; TAMER            ; up to 17 points (level-limited)
	dw     0 ; SCHOOL_GIRL
	dw     0 ; CRYSTAL3         ; party match + 2 points
	dw     0 ; RIVAL3           ; party match + 2 points
	dw     0 ; FALKNER_REMATCH  ; party match + 2 points
	dw     0 ; BUGSY_REMATCH    ; party match + 2 points
	dw     0 ; WHITNEY_REMATCH  ; party match + 2 points
	dw     0 ; MORTY_REMATCH    ; party match + 2 points
	dw     0 ; CHUCK_REMATCH    ; party match + 2 points
	dw     0 ; JASMINE_REMATCH  ; party match + 2 points
	dw     0 ; PRYCE_REMATCH    ; party match + 2 points
	dw     0 ; CLAIR_REMATCH    ; party match + 2 points
	dw     0 ; LORELEI_REMATCH  ; party match + 2 points
	dw     0 ; KOGA_REMATCH     ; party match + 2 points
	dw     0 ; BRUNO_REMATCH    ; party match + 2 points
	dw     0 ; KAREN_REMATCH    ; party match + 2 points
	dw     0 ; CHAMPION_REMATCH ; party match + 2 points
	dw     0 ; ELDER            ; party match + 2 points
	dw     0 ; AROMA_LADY
	dw  6400 ; CUEBALL          ; up to 20 points (level-limited)
	dw     0 ; KARATE_KING      ; party match + 2 points
	dw     0 ; SLOT_MANIAC
	dw     0 ; HOSTESS
	dw     0 ; DUELIST          ; exact party match
