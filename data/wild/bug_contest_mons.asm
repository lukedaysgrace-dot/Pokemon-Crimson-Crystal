ContestMons:
; Scyther, Pinsir and Heracross are exclusive to the Bug Catching Contest.
; They appear in no other wild table anywhere in the game.
;
; ChooseWildEncounter_BugContest rolls 0-99 and subtracts each percentage in
; turn, so the listed rates MUST sum to less than 100 or the -1 entry can never
; be reached. (Vanilla summed to exactly 100, which is why its Venomoth slot was
; unreachable.) These sum to 96, leaving Heracross the remaining 4%.
	;      %, species,   min, max
	dbwbb 17, CATERPIE,    7, 18
	dbwbb 17, WEEDLE,      7, 18
	dbwbb 10, METAPOD,     9, 18
	dbwbb 10, KAKUNA,      9, 18
	dbwbb  5, BUTTERFREE, 12, 15
	dbwbb  5, BEEDRILL,   12, 15
	dbwbb 10, VENONAT,    10, 16
	dbwbb 10, PARAS,      10, 17
	dbwbb  6, SCYTHER,    13, 16
	dbwbb  6, PINSIR,     13, 16
	dbwbb -1, HERACROSS,  14, 16
