; Keep custom story characters and rematches hidden at every milestone.
PnPAlwaysHidden: MACRO
	db CRYSTAL
	db CRYSTAL2
	db CRYSTAL3
	db RIVAL3
	db PETREL_DIRECTOR
	db AGATHA
	db LORELEI
	db RED2
	db BLUE_CLOAK
	db GREEN
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
	db RIVAL1
	db POKEMON_PROF
	db CAL
	db RIVAL2
	db RED
ENDM

PnP_HiddenPeople:
	PnPAlwaysHidden
	db WILL
	db BRUNO
	db KAREN
	db KOGA
	db CHAMPION
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db JANINE
	db SABRINA
	db BLAINE
	db BLUE
	db -1

PnP_HiddenPeople_Kanto:
	PnPAlwaysHidden
	db WILL
	db BRUNO
	db KAREN
	db KOGA
	db CHAMPION
	db -1

PnP_HiddenPeople_BeatKanto:
	PnPAlwaysHidden
	db -1
