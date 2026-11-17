TrainerStatExpMatchingPolicy:
; Hard Mode only. Class, bonus in sqrt(Stat EXP)/4 training points.
; Each stat matches the highest word in the player's non-Egg party. Include
; fainted members so fainting the strongest mon cannot weaken the opponent.
; +2 points adds at most two final stat points at levels 1-100, with rounding.
; Cooltrainers and Duelists match the exact raw words, without a bonus.
	db FALKNER, 2
	db WHITNEY, 2
	db BUGSY, 2
	db MORTY, 2
	db PRYCE, 2
	db JASMINE, 2
	db CHUCK, 2
	db CLAIR, 2
	db RIVAL1, 2
	db WILL, 2
	db CAL, 2
	db BRUNO, 2
	db KAREN, 2
	db KOGA, 2
	db CHAMPION, 2
	db BROCK, 2
	db MISTY, 2
	db LT_SURGE, 2
	db ERIKA, 2
	db JANINE, 2
	db SABRINA, 2
	db BLAINE, 2
	db BLUE, 2
	db RIVAL2, 2
	db RIVAL3, 2
	db CRYSTAL, 2
	db CRYSTAL2, 2
	db CRYSTAL3, 2
	db PROTON, 2
	db PETREL, 2
	db ARIANA, 2
	db ARCHER, 2
	db PETREL_DIRECTOR, 2
	db EXECUTIVEM, 2
	db EXECUTIVEF, 2
	db MYSTICALMAN, 2
	db RED, 2
	db AGATHA, 2
	db LORELEI, 2
	db RED2, 2
	db BLUE_CLOAK, 2
	db GREEN, 2
	db FALKNER_REMATCH, 2
	db BUGSY_REMATCH, 2
	db WHITNEY_REMATCH, 2
	db MORTY_REMATCH, 2
	db CHUCK_REMATCH, 2
	db JASMINE_REMATCH, 2
	db PRYCE_REMATCH, 2
	db CLAIR_REMATCH, 2
	db LORELEI_REMATCH, 2
	db KOGA_REMATCH, 2
	db BRUNO_REMATCH, 2
	db KAREN_REMATCH, 2
	db CHAMPION_REMATCH, 2
	db ELDER, 2
	db KIMONO_GIRL, 2
	db KARATE_KING, 2
	db COOLTRAINERM, 0
	db COOLTRAINERF, 0
	db DUELIST, 0
	db -1
