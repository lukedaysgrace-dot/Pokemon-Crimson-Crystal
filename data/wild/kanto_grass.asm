; Kanto Pokémon in grass
; Reworked: post-Elite Four catch-up curve, thematic habitats and type variety.
; Kanto encounters sit below their local route trainers, but close enough that
; a newly caught Pokemon can join the team without dozens of dead levels.
; Route 26/27 remain on the first-League curve; Route 28 is late postgame.
; Slot rates are 30/30/20/10/5/4/1 percent, so slots 6 and 7 are the rare ones.
; Evolved forms never appear below the level at which they would have evolved.
; Scyther, Pinsir and Heracross are Bug Contest exclusives; ice types are
; Ice Island / Ice Path only; ghost types are Silent Crypt only.

KantoGrassWildMons:

	map_id DIGLETTS_CAVE
	db 4 percent, 2 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	dbw 65, DIGLETT
	dbw 65, GEODUDE
	dbw 66, DIGLETT
	dbw 66, ONIX
	dbw 67, DUGTRIO
	dbw 67, DRILBUR
	dbw 69, EXCADRILL
	; day
	dbw 65, DIGLETT
	dbw 65, SANDSHREW
	dbw 66, DIGLETT
	dbw 66, GEODUDE
	dbw 67, DUGTRIO
	dbw 67, TRAPINCH
	dbw 69, SANDSLASH
	; nite
	dbw 65, DIGLETT
	dbw 65, ZUBAT
	dbw 66, DIGLETT
	dbw 66, GOLBAT
	dbw 67, DUGTRIO
	dbw 67, PAWNIARD
	dbw 69, EXCADRILL

	map_id MOUNT_MOON
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 68, GEODUDE
	dbw 68, ZUBAT
	dbw 69, PARAS
	dbw 69, SANDSHREW
	dbw 70, CLEFAIRY
	dbw 71, GRAVELER
	dbw 72, ONIX
	; day
	dbw 68, GEODUDE
	dbw 68, SANDSHREW
	dbw 69, PARASECT
	dbw 69, GEODUDE
	dbw 70, CLEFAIRY
	dbw 71, GRAVELER
	dbw 72, GLIMMET
	; nite
	dbw 68, ZUBAT
	dbw 68, GEODUDE
	dbw 69, GOLBAT
	dbw 69, CLEFAIRY
	dbw 70, CLEFAIRY
	dbw 71, GRAVELER
	dbw 72, MAWILE

	map_id ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 58, GEODUDE
	dbw 58, ZUBAT
	dbw 59, CUBONE
	dbw 59, MACHOP
	dbw 60, ONIX
	dbw 61, GRAVELER
	dbw 62, MACHOKE
	; day
	dbw 58, GEODUDE
	dbw 58, CUBONE
	dbw 59, ONIX
	dbw 59, MACHOP
	dbw 60, GRAVELER
	dbw 61, MAROWAK
	dbw 62, RHYHORN
	; nite
	dbw 58, ZUBAT
	dbw 58, GEODUDE
	dbw 59, GOLBAT
	dbw 59, CUBONE
	dbw 60, ONIX
	dbw 61, GRAVELER
	dbw 62, MAROWAK

	map_id ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 59, GEODUDE
	dbw 59, MACHOP
	dbw 60, ONIX
	dbw 60, CUBONE
	dbw 61, GRAVELER
	dbw 62, RHYHORN
	dbw 63, MACHOKE
	; day
	dbw 59, GEODUDE
	dbw 59, CUBONE
	dbw 60, MACHOP
	dbw 60, ONIX
	dbw 61, GRAVELER
	dbw 62, MAROWAK
	dbw 63, RHYDON
	; nite
	dbw 59, ZUBAT
	dbw 59, GEODUDE
	dbw 60, GOLBAT
	dbw 60, ONIX
	dbw 61, GRAVELER
	dbw 62, MAROWAK
	dbw 63, GURDURR

	map_id VICTORY_ROAD
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 48, GEODUDE
	dbw 49, ONIX
	dbw 50, MACHOP
	dbw 51, GRAVELER
	dbw 52, RHYHORN
	dbw 54, MACHOKE
	dbw 56, SANDSLASH
	; day
	dbw 48, GEODUDE
	dbw 49, ONIX
	dbw 50, SANDSLASH
	dbw 51, GRAVELER
	dbw 52, RHYHORN
	dbw 54, MACHOKE
	dbw 56, RHYDON
	; nite
	dbw 48, ZUBAT
	dbw 49, GEODUDE
	dbw 50, GOLBAT
	dbw 51, GRAVELER
	dbw 52, ONIX
	dbw 54, CROBAT
	dbw 56, DONPHAN

	map_id TOHJO_FALLS
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 44, ZUBAT
	dbw 44, SLOWPOKE
	dbw 45, PSYDUCK
	dbw 45, MARILL
	dbw 46, GOLBAT
	dbw 47, AZUMARILL
	dbw 48, QUAGSIRE
	; day
	dbw 44, SLOWPOKE
	dbw 44, PSYDUCK
	dbw 45, MARILL
	dbw 45, ZUBAT
	dbw 46, QUAGSIRE
	dbw 47, AZUMARILL
	dbw 48, GOLDUCK
	; nite
	dbw 44, ZUBAT
	dbw 44, SLOWPOKE
	dbw 45, GOLBAT
	dbw 45, WOOPER
	dbw 46, QUAGSIRE
	dbw 47, CROBAT
	dbw 48, CROAGUNK

	map_id ROUTE_1
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 70, PIDGEY
	dbw 70, SENTRET
	dbw 71, RATTATA
	dbw 71, HOPPIP
	dbw 72, FURRET
	dbw 72, PIDGEOTTO
	dbw 73, BUNEARY
	; day
	dbw 70, PIDGEY
	dbw 70, SENTRET
	dbw 71, RATTATA
	dbw 71, LOTAD
	dbw 72, FURRET
	dbw 72, PIDGEOTTO
	dbw 73, MILTANK
	; nite
	dbw 70, HOOTHOOT
	dbw 70, RATTATA
	dbw 71, SPINARAK
	dbw 71, MEOWTH
	dbw 72, RATICATE
	dbw 72, NOCTOWL
	dbw 73, PERSIAN

	map_id ROUTE_2
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 72, CATERPIE
	dbw 72, LEDYBA
	dbw 73, PIDGEY
	dbw 73, METAPOD
	dbw 74, BUTTERFREE
	dbw 74, LEDIAN
	dbw 75, PIKACHU
	; day
	dbw 72, CATERPIE
	dbw 72, PIDGEY
	dbw 73, ODDISH
	dbw 73, METAPOD
	dbw 74, BUTTERFREE
	dbw 74, PIDGEOTTO
	dbw 75, PIKACHU
	; nite
	dbw 72, HOOTHOOT
	dbw 72, SPINARAK
	dbw 73, VENONAT
	dbw 73, ODDISH
	dbw 74, ARIADOS
	dbw 74, NOCTOWL
	dbw 75, GLOOM

	map_id VIRIDIAN_FOREST
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 71, CATERPIE
	dbw 71, WEEDLE
	dbw 72, METAPOD
	dbw 72, KAKUNA
	dbw 73, BUTTERFREE
	dbw 74, GRUBBIN
	dbw 75, PIKACHU
	; day
	dbw 71, CATERPIE
	dbw 71, WEEDLE
	dbw 72, METAPOD
	dbw 72, KAKUNA
	dbw 73, BEEDRILL
	dbw 74, SHROOMISH
	dbw 75, PIKACHU
	; nite
	dbw 71, VENONAT
	dbw 71, SPINARAK
	dbw 72, PARAS
	dbw 72, WEEDLE
	dbw 73, VENOMOTH
	dbw 74, JOLTIK
	dbw 75, ARIADOS

	map_id ROUTE_3
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 66, SPEAROW
	dbw 66, RATTATA
	dbw 67, EKANS
	dbw 67, SANDSHREW
	dbw 68, FEAROW
	dbw 68, ARBOK
	dbw 69, MANKEY
	; day
	dbw 66, SPEAROW
	dbw 66, RATTATA
	dbw 67, EKANS
	dbw 67, SANDSHREW
	dbw 68, FEAROW
	dbw 68, JIGGLYPUFF
	dbw 69, MANKEY
	; nite
	dbw 66, RATTATA
	dbw 66, ZUBAT
	dbw 67, EKANS
	dbw 67, MEOWTH
	dbw 68, RATICATE
	dbw 68, GOLBAT
	dbw 69, ARBOK

	map_id ROUTE_4
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 67, SPEAROW
	dbw 67, SANDSHREW
	dbw 68, GEODUDE
	dbw 68, EKANS
	dbw 69, FEAROW
	dbw 69, SANDSLASH
	dbw 70, CLEFAIRY
	; day
	dbw 67, SPEAROW
	dbw 67, SANDSHREW
	dbw 68, GEODUDE
	dbw 68, JIGGLYPUFF
	dbw 69, FEAROW
	dbw 69, SANDSLASH
	dbw 70, CLEFAIRY
	; nite
	dbw 67, RATTATA
	dbw 67, ZUBAT
	dbw 68, GEODUDE
	dbw 68, EKANS
	dbw 69, RATICATE
	dbw 69, GOLBAT
	dbw 70, CLEFAIRY

	map_id ROUTE_5
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, PIDGEY
	dbw 56, SNUBBULL
	dbw 57, ABRA
	dbw 57, MAREEP
	dbw 58, PIDGEOTTO
	dbw 58, GRANBULL
	dbw 59, KADABRA
	; day
	dbw 56, PIDGEY
	dbw 56, SNUBBULL
	dbw 57, ABRA
	dbw 57, JIGGLYPUFF
	dbw 58, PIDGEOTTO
	dbw 58, GRANBULL
	dbw 59, KADABRA
	; nite
	dbw 56, HOOTHOOT
	dbw 56, MEOWTH
	dbw 57, DROWZEE
	dbw 57, ABRA
	dbw 58, NOCTOWL
	dbw 58, HYPNO
	dbw 59, PERSIAN

	map_id ROUTE_6
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 55, MAGNEMITE
	dbw 55, SNUBBULL
	dbw 56, RATTATA
	dbw 56, VOLTORB
	dbw 57, MAGNETON
	dbw 57, GRANBULL
	dbw 58, ELEKID
	; day
	dbw 55, MAGNEMITE
	dbw 55, SNUBBULL
	dbw 56, JIGGLYPUFF
	dbw 56, VOLTORB
	dbw 57, MAGNETON
	dbw 57, GRANBULL
	dbw 58, ELECTABUZZ
	; nite
	dbw 55, MEOWTH
	dbw 55, DROWZEE
	dbw 56, MAGNEMITE
	dbw 56, RATICATE
	dbw 57, HYPNO
	dbw 57, PERSIAN
	dbw 58, ELECTABUZZ

	map_id ROUTE_7
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 62, RATTATA
	dbw 62, SPEAROW
	dbw 63, SNUBBULL
	dbw 63, ABRA
	dbw 64, RATICATE
	dbw 64, JIGGLYPUFF
	dbw 65, KADABRA
	; day
	dbw 62, RATTATA
	dbw 62, SPEAROW
	dbw 63, SNUBBULL
	dbw 63, MEOWTH
	dbw 64, RATICATE
	dbw 64, GRANBULL
	dbw 65, KADABRA
	; nite
	dbw 62, MEOWTH
	dbw 62, MURKROW
	dbw 63, HOUNDOUR
	dbw 63, DROWZEE
	dbw 64, PERSIAN
	dbw 64, HOUNDOOM
	dbw 65, HYPNO

	map_id ROUTE_8
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 65, PIDGEY
	dbw 65, SNUBBULL
	dbw 66, ABRA
	dbw 66, GROWLITHE
	dbw 67, PIDGEOTTO
	dbw 67, JIGGLYPUFF
	dbw 68, KADABRA
	; day
	dbw 65, PIDGEY
	dbw 65, GROWLITHE
	dbw 66, ABRA
	dbw 66, SNUBBULL
	dbw 67, PIDGEOTTO
	dbw 67, GRANBULL
	dbw 68, KADABRA
	; nite
	dbw 65, HOOTHOOT
	dbw 65, MEOWTH
	dbw 66, MURKROW
	dbw 66, DROWZEE
	dbw 67, NOCTOWL
	dbw 67, PERSIAN
	dbw 68, HOUNDOOM

	map_id ROUTE_9
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, SPEAROW
	dbw 56, RATTATA
	dbw 57, SANDSHREW
	dbw 57, GEODUDE
	dbw 58, FEAROW
	dbw 58, SANDSLASH
	dbw 59, RHYHORN
	; day
	dbw 56, SPEAROW
	dbw 56, RATTATA
	dbw 57, SANDSHREW
	dbw 57, DODUO
	dbw 58, FEAROW
	dbw 58, SANDSLASH
	dbw 59, DODRIO
	; nite
	dbw 56, RATTATA
	dbw 56, VENONAT
	dbw 57, ZUBAT
	dbw 57, GEODUDE
	dbw 58, RATICATE
	dbw 58, VENOMOTH
	dbw 59, GOLBAT

	map_id ROUTE_10_NORTH
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 57, VOLTORB
	dbw 57, SPEAROW
	dbw 58, MAGNEMITE
	dbw 58, SANDSHREW
	dbw 59, FEAROW
	dbw 59, MAGNETON
	dbw 60, ELECTABUZZ
	; day
	dbw 57, VOLTORB
	dbw 57, SPEAROW
	dbw 58, MAGNEMITE
	dbw 58, DODUO
	dbw 59, ELECTRODE
	dbw 59, MAGNETON
	dbw 60, ELECTABUZZ
	; nite
	dbw 57, VOLTORB
	dbw 57, ZUBAT
	dbw 58, MAGNEMITE
	dbw 58, VENONAT
	dbw 59, ELECTRODE
	dbw 59, GOLBAT
	dbw 60, ELECTABUZZ

	map_id ROUTE_11
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 52, PIDGEY
	dbw 52, HOPPIP
	dbw 53, RATTATA
	dbw 53, SANDSHREW
	dbw 54, PIDGEOTTO
	dbw 54, SKIPLOOM
	dbw 55, KANGASKHAN
	; day
	dbw 52, PIDGEY
	dbw 52, HOPPIP
	dbw 53, RATTATA
	dbw 53, DODUO
	dbw 54, PIDGEOTTO
	dbw 54, SKIPLOOM
	dbw 55, KANGASKHAN
	; nite
	dbw 52, HOOTHOOT
	dbw 52, MEOWTH
	dbw 53, DROWZEE
	dbw 53, RATTATA
	dbw 54, NOCTOWL
	dbw 54, HYPNO
	dbw 55, RATICATE

	map_id ROUTE_13
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 64, NIDORAN_M
	dbw 64, NIDORAN_F
	dbw 65, HOPPIP
	dbw 65, ODDISH
	dbw 66, NIDORINO
	dbw 66, SKIPLOOM
	dbw 67, JUMPLUFF
	; day
	dbw 64, NIDORAN_M
	dbw 64, NIDORAN_F
	dbw 65, HOPPIP
	dbw 65, SUNKERN
	dbw 66, NIDORINA
	dbw 66, SKIPLOOM
	dbw 67, JUMPLUFF
	; nite
	dbw 64, VENONAT
	dbw 64, ODDISH
	dbw 65, QUAGSIRE
	dbw 65, HOOTHOOT
	dbw 66, VENOMOTH
	dbw 66, GLOOM
	dbw 67, NOCTOWL

	map_id ROUTE_14
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 67, NIDORAN_M
	dbw 67, NIDORAN_F
	dbw 68, HOPPIP
	dbw 68, ODDISH
	dbw 69, NIDORINO
	dbw 69, SKIPLOOM
	dbw 70, JUMPLUFF
	; day
	dbw 67, NIDORINO
	dbw 67, NIDORINA
	dbw 68, SKIPLOOM
	dbw 68, SUNFLORA
	dbw 69, NIDOKING
	dbw 69, NIDOQUEEN
	dbw 70, JUMPLUFF
	; nite
	dbw 67, VENONAT
	dbw 67, GLOOM
	dbw 68, QUAGSIRE
	dbw 68, MURKROW
	dbw 69, VENOMOTH
	dbw 69, VILEPLUME
	dbw 70, NOCTOWL

	map_id ROUTE_15
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 69, NIDORAN_F
	dbw 69, NIDORAN_M
	dbw 70, PIDGEY
	dbw 70, HOPPIP
	dbw 71, NIDORINA
	dbw 71, PIDGEOTTO
	dbw 72, CHANSEY
	; day
	dbw 69, NIDORINA
	dbw 69, NIDORINO
	dbw 70, SKIPLOOM
	dbw 70, TANGELA
	dbw 71, NIDOQUEEN
	dbw 71, NIDOKING
	dbw 72, CHANSEY
	; nite
	dbw 69, VENONAT
	dbw 69, QUAGSIRE
	dbw 70, HOOTHOOT
	dbw 70, GLOOM
	dbw 71, VENOMOTH
	dbw 71, NOCTOWL
	dbw 72, CHANSEY

	map_id ROUTE_16
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 68, GRIMER
	dbw 68, FEAROW
	dbw 69, KOFFING
	dbw 69, VOLTORB
	dbw 70, GRIMER
	dbw 70, WEEZING
	dbw 71, MUK
	; day
	dbw 68, GRIMER
	dbw 68, FEAROW
	dbw 69, KOFFING
	dbw 69, SLUGMA
	dbw 70, MAGCARGO
	dbw 70, WEEZING
	dbw 71, MUK
	; nite
	dbw 68, GRIMER
	dbw 68, KOFFING
	dbw 69, MURKROW
	dbw 69, GRIMER
	dbw 70, WEEZING
	dbw 70, HOUNDOOM
	dbw 71, MUK

	map_id ROUTE_17
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 69, GRIMER
	dbw 69, FEAROW
	dbw 70, KOFFING
	dbw 70, SLUGMA
	dbw 71, WEEZING
	dbw 71, MAGCARGO
	dbw 72, MUK
	; day
	dbw 69, GRIMER
	dbw 69, DODUO
	dbw 70, KOFFING
	dbw 70, SEVIPER
	dbw 71, WEEZING
	dbw 71, MAGCARGO
	dbw 72, MUK
	; nite
	dbw 69, GRIMER
	dbw 69, KOFFING
	dbw 70, MURKROW
	dbw 70, HOUNDOUR
	dbw 71, WEEZING
	dbw 71, HOUNDOOM
	dbw 72, MUK

	map_id ROUTE_18
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 70, GRIMER
	dbw 70, FEAROW
	dbw 71, KOFFING
	dbw 71, DODUO
	dbw 72, WEEZING
	dbw 72, DODRIO
	dbw 73, MUK
	; day
	dbw 70, GRIMER
	dbw 70, FEAROW
	dbw 71, KOFFING
	dbw 71, ZANGOOSE
	dbw 72, WEEZING
	dbw 72, DODRIO
	dbw 73, MUK
	; nite
	dbw 70, GRIMER
	dbw 70, KOFFING
	dbw 71, MURKROW
	dbw 71, SEVIPER
	dbw 72, WEEZING
	dbw 72, HOUNDOOM
	dbw 73, MUK

	map_id ROUTE_21
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 69, TANGELA
	dbw 69, KRABBY
	dbw 70, PSYDUCK
	dbw 70, MARILL
	dbw 71, TANGELA
	dbw 71, AZUMARILL
	dbw 72, KINGLER
	; day
	dbw 69, TANGELA
	dbw 69, KRABBY
	dbw 70, PSYDUCK
	dbw 70, SLOWPOKE
	dbw 71, GOLDUCK
	dbw 71, MR__MIME
	dbw 72, KINGLER
	; nite
	dbw 69, TANGELA
	dbw 69, KRABBY
	dbw 70, QUAGSIRE
	dbw 70, SLOWPOKE
	dbw 71, GOLBAT
	dbw 71, KINGLER
	dbw 72, SLOWBRO

	map_id ROUTE_22
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 72, RATTATA
	dbw 72, SPEAROW
	dbw 73, MANKEY
	dbw 73, DODUO
	dbw 74, RATICATE
	dbw 74, FEAROW
	dbw 75, PONYTA
	; day
	dbw 72, SENTRET
	dbw 72, SPEAROW
	dbw 73, MANKEY
	dbw 73, PONYTA
	dbw 74, FURRET
	dbw 74, FEAROW
	dbw 75, PRIMEAPE
	; nite
	dbw 72, RATTATA
	dbw 72, ZUBAT
	dbw 73, MEOWTH
	dbw 73, HOUNDOUR
	dbw 74, RATICATE
	dbw 74, GOLBAT
	dbw 75, HOUNDOOM

	map_id ROUTE_24
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 58, CATERPIE
	dbw 58, BELLSPROUT
	dbw 59, ABRA
	dbw 59, ODDISH
	dbw 60, BUTTERFREE
	dbw 60, WEEPINBELL
	dbw 61, KADABRA
	; day
	dbw 58, CATERPIE
	dbw 58, BELLSPROUT
	dbw 59, ABRA
	dbw 59, SUNKERN
	dbw 60, BUTTERFREE
	dbw 60, WEEPINBELL
	dbw 61, SUNFLORA
	; nite
	dbw 58, VENONAT
	dbw 58, ODDISH
	dbw 59, BELLSPROUT
	dbw 59, ABRA
	dbw 60, GLOOM
	dbw 60, VENOMOTH
	dbw 61, WEEPINBELL

	map_id ROUTE_25
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 60, CATERPIE
	dbw 60, PIDGEY
	dbw 61, BELLSPROUT
	dbw 61, ODDISH
	dbw 62, BUTTERFREE
	dbw 62, PIDGEOTTO
	dbw 63, KADABRA
	; day
	dbw 60, CATERPIE
	dbw 60, PIDGEY
	dbw 61, BELLSPROUT
	dbw 61, SLOWPOKE
	dbw 62, BUTTERFREE
	dbw 62, PIDGEOTTO
	dbw 63, WEEPINBELL
	; nite
	dbw 60, ODDISH
	dbw 60, HOOTHOOT
	dbw 61, VENONAT
	dbw 61, ZUBAT
	dbw 62, GLOOM
	dbw 62, NOCTOWL
	dbw 63, VENOMOTH

	map_id ROUTE_26
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 45, DODUO
	dbw 45, SANDSHREW
	dbw 46, PONYTA
	dbw 46, SPEAROW
	dbw 47, SANDSLASH
	dbw 47, FEAROW
	dbw 49, DODRIO
	; day
	dbw 45, DODUO
	dbw 45, SANDSHREW
	dbw 46, PONYTA
	dbw 46, TAUROS
	dbw 47, SANDSLASH
	dbw 47, MILTANK
	dbw 49, DODRIO
	; nite
	dbw 45, QUAGSIRE
	dbw 45, NOCTOWL
	dbw 46, RATICATE
	dbw 46, ZUBAT
	dbw 47, GOLBAT
	dbw 47, MURKROW
	dbw 49, HOUNDOOM

	map_id ROUTE_27
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 45, DODUO
	dbw 45, RATTATA
	dbw 46, ARBOK
	dbw 46, SANDSHREW
	dbw 47, RATICATE
	dbw 47, SANDSLASH
	dbw 49, PONYTA
	; day
	dbw 45, DODUO
	dbw 45, EKANS
	dbw 46, ARBOK
	dbw 46, PONYTA
	dbw 47, SANDSLASH
	dbw 47, TAUROS
	dbw 49, DODRIO
	; nite
	dbw 45, QUAGSIRE
	dbw 45, ZUBAT
	dbw 46, NOCTOWL
	dbw 46, RATICATE
	dbw 47, GOLBAT
	dbw 47, ARBOK
	dbw 49, HOUNDOOM

	map_id ROUTE_28
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 75, TANGELA
	dbw 75, PONYTA
	dbw 76, ARBOK
	dbw 76, DODUO
	dbw 77, RAPIDASH
	dbw 78, DODRIO
	dbw 80, URSARING
	; day
	dbw 75, TANGELA
	dbw 75, PONYTA
	dbw 76, ARBOK
	dbw 76, TAUROS
	dbw 77, RAPIDASH
	dbw 78, DODRIO
	dbw 80, KANGASKHAN
	; nite
	dbw 75, GOLBAT
	dbw 75, QUAGSIRE
	dbw 76, NOCTOWL
	dbw 76, MURKROW
	dbw 77, CROBAT
	dbw 78, HOUNDOOM
	dbw 80, URSARING

	db -1 ; end
