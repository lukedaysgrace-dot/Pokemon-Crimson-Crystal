TrainerStatExpMatchingPolicy:
; Hard Mode class, percent of the raw baseline from the top-two point average.
; A policy of 2 retains the legacy two-point bonus for select classes.
; Regular classes use TRAINER_STAT_EXP_DEFAULT_PERCENT.

; First Johto Gym battles
	db FALKNER, 50
	db WHITNEY, 50
	db BUGSY, 50
	db MORTY, 50
	db PRYCE, 50
	db JASMINE, 50
	db CHUCK, 50
	db CLAIR, 50

; Kanto Gym battles
	db BROCK, 65
	db MISTY, 65
	db LT_SURGE, 65
	db ERIKA, 65
	db JANINE, 65
	db SABRINA, 65
	db BLAINE, 65
	db BLUE, 65

; First League battles, including Lance
	db LORELEI, 80
	db KOGA, 80
	db BRUNO, 80
	db KAREN, 80
	db CHAMPION, 80

; Johto Gym and League rematches
	db FALKNER_REMATCH, 90
	db BUGSY_REMATCH, 90
	db WHITNEY_REMATCH, 90
	db MORTY_REMATCH, 90
	db CHUCK_REMATCH, 90
	db JASMINE_REMATCH, 90
	db PRYCE_REMATCH, 90
	db CLAIR_REMATCH, 90
	db LORELEI_REMATCH, 90
	db KOGA_REMATCH, 90
	db BRUNO_REMATCH, 90
	db KAREN_REMATCH, 90
	db CHAMPION_REMATCH, 90

; Superbosses
	db GREEN, 100
	db RED, 100
	db RED2, 100
	db BLUE_CLOAK, 100

; Cooltrainers, Duelists, and Eusine
	db COOLTRAINERM, 65
	db COOLTRAINERF, 65
	db DUELIST, 65
	db MYSTICALMAN, 65

; Crystal and Silver before their final battles
	db CRYSTAL, 75
	db CRYSTAL2, 75
	db RIVAL1, 75
	db RIVAL2, 75

; Crystal and Silver's final battles
	db CRYSTAL3, 90
	db RIVAL3, 90

; Shucks' Hostesses and Team Rocket admins
	db HOSTESS, 75
	db PROTON, 50
	db PETREL, 50
	db PETREL_DIRECTOR, 50
	db ARIANA, 50
	db ARCHER, 75

; Other special encounters
	db SLOT_MANIAC, 50
	db ELDER, 50
	db KIMONO_GIRL, 50
	db KARATE_KING, 75

; Legacy training point bonus for other special and retired classes
	db CAL, 2
	db EXECUTIVEM, 2
	db EXECUTIVEF, 2
	db WILL, 2
	db AGATHA, 2

	db -1
