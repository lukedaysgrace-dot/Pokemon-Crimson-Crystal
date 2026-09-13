TreeMons:
; entries correspond to TREEMON_SET_* constants
	dw TreeMonSet_City
	dw TreeMonSet_Canyon
	dw TreeMonSet_Town
	dw TreeMonSet_Route
	dw TreeMonSet_Kanto
	dw TreeMonSet_Lake
	dw TreeMonSet_Forest
	dw TreeMonSet_Rock
	dw TreeMonSet_RockCave
	dw TreeMonSet_CityMid
	dw TreeMonSet_CityLate
	dw TreeMonSet_RouteMid
	dw TreeMonSet_TownMid
	dw TreeMonSet_CanyonLate
	dw TreeMonSet_KantoLate
	dw TreeMonSet_RockWell

; Two tables each (common, rare).
; Structure:
;	db  %, species, level

TreeMonSet_City:
TreeMonSet_Canyon:
; common
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, SPEAROW
	dbbw 15, 10, SPEAROW
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, AIPOM
	db -1
; rare
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, PINECO
	dbbw 15, 10, PINECO
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, AIPOM
	db -1

TreeMonSet_Town:
; common
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, EKANS
	dbbw 15, 10, SPEAROW
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, AIPOM
	db -1
; rare
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, PINECO
	dbbw 15, 10, PINECO
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, AIPOM
	db -1

TreeMonSet_Route:
; common
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, SPINARAK
	dbbw 15, 10, LEDYBA
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	db -1
; rare
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, PINECO
	dbbw 15, 10, PINECO
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	db -1

TreeMonSet_Kanto:
; common
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, EKANS
	dbbw 15, 10, HOOTHOOT
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	db -1
; rare
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, PINECO
	dbbw 15, 10, PINECO
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	db -1

TreeMonSet_Lake:
; common
	dbbw 50, 32, NOCTOWL
	dbbw 15, 32, VENOMOTH
	dbbw 15, 32, NOCTOWL
	dbbw 10, 32, EXEGGCUTE
	dbbw  5, 32, EXEGGUTOR
	dbbw  5, 32, EXEGGCUTE
	db -1
; rare
	dbbw 50, 32, NOCTOWL
	dbbw 15, 32, FORRETRESS
	dbbw 15, 32, PINECO
	dbbw 10, 32, EXEGGCUTE
	dbbw  5, 32, EXEGGUTOR
	dbbw  5, 32, EXEGGCUTE
	db -1

TreeMonSet_Forest:
; common
	dbbw 50, 14, HOOTHOOT
	dbbw 15, 10, CATERPIE
	dbbw 15, 10, WEEDLE
	dbbw 10, 14, APPLIN
	dbbw  5, 12, METAPOD
	dbbw  5, 12, KAKUNA
	db -1
; rare
	dbbw 50, 14, HOOTHOOT
	dbbw 15, 16, PINECO
	dbbw 15, 16, PINECO
	dbbw 10, 14, APPLIN
	dbbw  5, 16, BUTTERFREE
	dbbw  5, 16, BEEDRILL
	db -1

TreeMonSet_CityMid:
; common
	dbbw 50, 24, FEAROW
	dbbw 15, 24, SPEAROW
	dbbw 15, 24, AIPOM
	dbbw 10, 24, AIPOM
	dbbw  5, 24, AMBIPOM
	dbbw  5, 24, AIPOM
	db -1
; rare
	dbbw 50, 24, FEAROW
	dbbw 15, 24, PINECO
	dbbw 15, 24, PINECO
	dbbw 10, 24, AIPOM
	dbbw  5, 24, AMBIPOM
	dbbw  5, 24, AIPOM
	db -1

TreeMonSet_CityLate:
; common
	dbbw 50, 50, FEAROW
	dbbw 15, 50, AMBIPOM
	dbbw 15, 50, FEAROW
	dbbw 10, 50, AMBIPOM
	dbbw  5, 50, FORRETRESS
	dbbw  5, 50, NOCTOWL
	db -1
; rare
	dbbw 50, 50, FEAROW
	dbbw 15, 50, FORRETRESS
	dbbw 15, 50, FORRETRESS
	dbbw 10, 50, AMBIPOM
	dbbw  5, 50, HONCHKROW
	dbbw  5, 50, NOCTOWL
	db -1

TreeMonSet_RouteMid:
; common
	dbbw 50, 24, NOCTOWL
	dbbw 15, 24, ARIADOS
	dbbw 15, 24, LEDIAN
	dbbw 10, 24, EXEGGCUTE
	dbbw  5, 24, EXEGGCUTE
	dbbw  5, 24, AIPOM
	db -1
; rare
	dbbw 50, 24, NOCTOWL
	dbbw 15, 24, PINECO
	dbbw 15, 24, PINECO
	dbbw 10, 24, EXEGGCUTE
	dbbw  5, 24, FORRETRESS
	dbbw  5, 24, AIPOM
	db -1

TreeMonSet_TownMid:
; common
	dbbw 50, 28, FEAROW
	dbbw 15, 28, ARBOK
	dbbw 15, 28, FEAROW
	dbbw 10, 28, AIPOM
	dbbw  5, 28, AMBIPOM
	dbbw  5, 28, AIPOM
	db -1
; rare
	dbbw 50, 28, FEAROW
	dbbw 15, 28, FORRETRESS
	dbbw 15, 28, PINECO
	dbbw 10, 28, AIPOM
	dbbw  5, 28, AMBIPOM
	dbbw  5, 28, AIPOM
	db -1

TreeMonSet_CanyonLate:
; common
	dbbw 50, 38, FEAROW
	dbbw 15, 38, NOCTOWL
	dbbw 15, 38, ARBOK
	dbbw 10, 38, AMBIPOM
	dbbw  5, 38, FORRETRESS
	dbbw  5, 38, EXEGGUTOR
	db -1
; rare
	dbbw 50, 38, FEAROW
	dbbw 15, 38, FORRETRESS
	dbbw 15, 38, FORRETRESS
	dbbw 10, 38, AMBIPOM
	dbbw  5, 38, HONCHKROW
	dbbw  5, 38, EXEGGUTOR
	db -1

TreeMonSet_KantoLate:
; common
	dbbw 50, 45, NOCTOWL
	dbbw 15, 45, ARBOK
	dbbw 15, 45, NOCTOWL
	dbbw 10, 45, EXEGGUTOR
	dbbw  5, 45, AMBIPOM
	dbbw  5, 45, EXEGGUTOR
	db -1
; rare
	dbbw 50, 45, NOCTOWL
	dbbw 15, 45, FORRETRESS
	dbbw 15, 45, FORRETRESS
	dbbw 10, 45, EXEGGUTOR
	dbbw  5, 45, HONCHKROW
	dbbw  5, 45, AMBIPOM
	db -1

TreeMonSet_Rock:
; Coastal rocks only - Krabby is a shore crab.
	dbbw 90, 25, KRABBY
	dbbw 10, 27, GEODUDE
	db -1

TreeMonSet_RockCave:
; Inland caves. Krabby has no business here, and Dark Cave's Violet side is a
; level 4-6 area, so a level 15 encounter was an 11-level spike over everything
; around it.
	dbbw 90,  6, GEODUDE
	dbbw 10,  6, ONIX
	db -1

TreeMonSet_RockWell:
; Slowpoke Well is revisited after Rock Smash, well beyond early Dark Cave.
	dbbw 90, 17, GEODUDE
	dbbw 10, 19, ONIX
	db -1
