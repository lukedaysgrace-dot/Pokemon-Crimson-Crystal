; These lists determine the battle music and victory music, and whether to
; award HAPPINESS_GYMBATTLE for winning.

; Note: CHAMPION and RED are unused for battle music checks, since they are
; accounted for prior to the list check.

GymLeaders:
	db FALKNER
	db WHITNEY
	db BUGSY
	db MORTY
	db PRYCE
	db JASMINE
	db CHUCK
	db CLAIR
	db WILL
	db BRUNO
	db KAREN
	db KOGA
	db CHAMPION
	db FALKNER_REMATCH
	db BUGSY_REMATCH
	db WHITNEY_REMATCH
	db MORTY_REMATCH
	db CHUCK_REMATCH
	db JASMINE_REMATCH
	db PRYCE_REMATCH
	db CLAIR_REMATCH
	db WILL_REMATCH
	db KOGA_REMATCH
	db BRUNO_REMATCH
	db KAREN_REMATCH
	db CHAMPION_REMATCH
	db RED
	db RED2
	db AGATHA
	db LORELEI
; fallthrough
KantoGymLeaders:
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db JANINE
	db SABRINA
	db BLAINE
	db BLUE
	db BLUE_CLOAK
	db GREEN
	db -1
