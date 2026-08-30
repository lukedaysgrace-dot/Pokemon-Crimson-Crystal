ContestMons:
; Yanma, Scyther, Pinsir and Heracross are exclusive to the Bug Catching
; Contest.
; They appear in no other wild table anywhere in the game.
;
; ChooseWildEncounter_BugContest rolls 0-99 and subtracts each percentage in
; turn, so the listed rates MUST sum to less than 100 or the -1 entry can never
; be reached. (Vanilla summed to exactly 100, which is why its Venomoth slot was
; unreachable.) These sum to 96, leaving Heracross the remaining 4%.
;
; Every species tops out at level 18 on purpose. ContestScore grades a catch on
; where its level falls inside its own species' range, so a shared ceiling makes
; "a big one" mean the same thing for a Caterpie as it does for a Heracross, and
; stops the rare mons collecting free level points on top of their rarity points.
; Keep these ranges in sync with ContestMonScoreData in bug_contest/judging.asm.
	;      %, species,   min, max
	dbwbb 15, CATERPIE,    7, 18
	dbwbb 15, WEEDLE,      7, 18
	dbwbb 10, METAPOD,     9, 18
	dbwbb 10, KAKUNA,      9, 18
	dbwbb  9, PARAS,      10, 18
	dbwbb  9, VENONAT,    10, 18
	dbwbb  5, BUTTERFREE, 11, 18
	dbwbb  5, BEEDRILL,   11, 18
	dbwbb  6, YANMA,      11, 18
	dbwbb  6, SCYTHER,    12, 18
	dbwbb  6, PINSIR,     12, 18
	dbwbb -1, HERACROSS,  12, 18
