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
	dbw 79, GEODUDE
	dbw 79, ZUBAT
	dbw 80, PARAS
	dbw 80, SANDSHREW
	dbw 81, CLEFAIRY
	dbw 82, GRAVELER
	dbw 83, ONIX
	; day
	dbw 79, GEODUDE
	dbw 79, SANDSHREW
	dbw 80, PARASECT
	dbw 80, GEODUDE
	dbw 81, CLEFAIRY
	dbw 82, GRAVELER
	dbw 83, GLIMMET
	; nite
	dbw 79, ZUBAT
	dbw 79, GEODUDE
	dbw 80, GOLBAT
	dbw 80, CLEFAIRY
	dbw 81, CLEFAIRY
	dbw 82, GRAVELER
	dbw 83, MAWILE

	map_id ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 59, GEODUDE
	dbw 59, ZUBAT
	dbw 60, CUBONE
	dbw 60, MACHOP
	dbw 61, ONIX
	dbw 62, GRAVELER
	dbw 63, MACHOKE
	; day
	dbw 59, GEODUDE
	dbw 59, CUBONE
	dbw 60, ONIX
	dbw 60, MACHOP
	dbw 61, GRAVELER
	dbw 62, MAROWAK
	dbw 63, RHYHORN
	; nite
	dbw 59, ZUBAT
	dbw 59, GEODUDE
	dbw 60, GOLBAT
	dbw 60, CUBONE
	dbw 61, ONIX
	dbw 62, GRAVELER
	dbw 63, MAROWAK

	map_id ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 60, GEODUDE
	dbw 60, MACHOP
	dbw 61, ONIX
	dbw 61, CUBONE
	dbw 62, GRAVELER
	dbw 63, RHYHORN
	dbw 64, MACHOKE
	; day
	dbw 60, GEODUDE
	dbw 60, CUBONE
	dbw 61, MACHOP
	dbw 61, ONIX
	dbw 62, GRAVELER
	dbw 63, MAROWAK
	dbw 64, RHYDON
	; nite
	dbw 60, ZUBAT
	dbw 60, GEODUDE
	dbw 61, GOLBAT
	dbw 61, ONIX
	dbw 62, GRAVELER
	dbw 63, MAROWAK
	dbw 64, GURDURR

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
	dbw 80, PIDGEY
	dbw 80, SENTRET
	dbw 81, RATTATA
	dbw 81, HOPPIP
	dbw 82, FURRET
	dbw 82, PIDGEOTTO
	dbw 83, BUNEARY
	; day
	dbw 80, PIDGEY
	dbw 80, SENTRET
	dbw 81, RATTATA
	dbw 81, LOTAD
	dbw 82, FURRET
	dbw 82, PIDGEOTTO
	dbw 83, MILTANK
	; nite
	dbw 80, HOOTHOOT
	dbw 80, RATTATA
	dbw 81, SPINARAK
	dbw 81, MEOWTH
	dbw 82, RATICATE
	dbw 82, NOCTOWL
	dbw 83, PERSIAN

	map_id ROUTE_2
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 77, CATERPIE
	dbw 77, LEDYBA
	dbw 78, PIDGEY
	dbw 78, METAPOD
	dbw 79, BUTTERFREE
	dbw 79, LEDIAN
	dbw 80, PIKACHU
	; day
	dbw 77, CATERPIE
	dbw 77, PIDGEY
	dbw 78, ODDISH
	dbw 78, METAPOD
	dbw 79, BUTTERFREE
	dbw 79, PIDGEOTTO
	dbw 80, PIKACHU
	; nite
	dbw 77, HOOTHOOT
	dbw 77, SPINARAK
	dbw 78, VENONAT
	dbw 78, ODDISH
	dbw 79, ARIADOS
	dbw 79, NOCTOWL
	dbw 80, GLOOM

	map_id VIRIDIAN_FOREST
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 76, CATERPIE
	dbw 76, WEEDLE
	dbw 77, METAPOD
	dbw 77, KAKUNA
	dbw 78, BUTTERFREE
	dbw 79, GRUBBIN
	dbw 80, PIKACHU
	; day
	dbw 76, CATERPIE
	dbw 76, WEEDLE
	dbw 77, METAPOD
	dbw 77, KAKUNA
	dbw 78, BEEDRILL
	dbw 79, SHROOMISH
	dbw 80, PIKACHU
	; nite
	dbw 76, VENONAT
	dbw 76, SPINARAK
	dbw 77, PARAS
	dbw 77, WEEDLE
	dbw 78, VENOMOTH
	dbw 79, JOLTIK
	dbw 80, ARIADOS

	map_id ROUTE_3
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 78, SPEAROW
	dbw 78, RATTATA
	dbw 79, EKANS
	dbw 79, SANDSHREW
	dbw 80, FEAROW
	dbw 80, ARBOK
	dbw 81, MANKEY
	; day
	dbw 78, SPEAROW
	dbw 78, RATTATA
	dbw 79, EKANS
	dbw 79, SANDSHREW
	dbw 80, FEAROW
	dbw 80, JIGGLYPUFF
	dbw 81, MANKEY
	; nite
	dbw 78, RATTATA
	dbw 78, ZUBAT
	dbw 79, EKANS
	dbw 79, MEOWTH
	dbw 80, RATICATE
	dbw 80, GOLBAT
	dbw 81, ARBOK

	map_id ROUTE_4
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 78, SPEAROW
	dbw 78, SANDSHREW
	dbw 79, GEODUDE
	dbw 79, EKANS
	dbw 80, FEAROW
	dbw 80, SANDSLASH
	dbw 81, CLEFAIRY
	; day
	dbw 78, SPEAROW
	dbw 78, SANDSHREW
	dbw 79, GEODUDE
	dbw 79, JIGGLYPUFF
	dbw 80, FEAROW
	dbw 80, SANDSLASH
	dbw 81, CLEFAIRY
	; nite
	dbw 78, RATTATA
	dbw 78, ZUBAT
	dbw 79, GEODUDE
	dbw 79, EKANS
	dbw 80, RATICATE
	dbw 80, GOLBAT
	dbw 81, CLEFAIRY

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
	dbw 63, RATTATA
	dbw 63, SPEAROW
	dbw 64, SNUBBULL
	dbw 64, ABRA
	dbw 65, RATICATE
	dbw 65, JIGGLYPUFF
	dbw 66, KADABRA
	; day
	dbw 63, RATTATA
	dbw 63, SPEAROW
	dbw 64, SNUBBULL
	dbw 64, MEOWTH
	dbw 65, RATICATE
	dbw 65, GRANBULL
	dbw 66, KADABRA
	; nite
	dbw 63, MEOWTH
	dbw 63, MURKROW
	dbw 64, HOUNDOUR
	dbw 64, DROWZEE
	dbw 65, PERSIAN
	dbw 65, HOUNDOOM
	dbw 66, HYPNO

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
	dbw 58, SPEAROW
	dbw 58, RATTATA
	dbw 59, SANDSHREW
	dbw 59, GEODUDE
	dbw 60, FEAROW
	dbw 60, SANDSLASH
	dbw 61, RHYHORN
	; day
	dbw 58, SPEAROW
	dbw 58, RATTATA
	dbw 59, SANDSHREW
	dbw 59, DODUO
	dbw 60, FEAROW
	dbw 60, SANDSLASH
	dbw 61, DODRIO
	; nite
	dbw 58, RATTATA
	dbw 58, VENONAT
	dbw 59, ZUBAT
	dbw 59, GEODUDE
	dbw 60, RATICATE
	dbw 60, VENOMOTH
	dbw 61, GOLBAT

	map_id ROUTE_10_NORTH
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 61, VOLTORB
	dbw 61, SPEAROW
	dbw 62, MAGNEMITE
	dbw 62, SANDSHREW
	dbw 63, FEAROW
	dbw 63, MAGNETON
	dbw 64, ELECTABUZZ
	; day
	dbw 61, VOLTORB
	dbw 61, SPEAROW
	dbw 62, MAGNEMITE
	dbw 62, DODUO
	dbw 63, ELECTRODE
	dbw 63, MAGNETON
	dbw 64, ELECTABUZZ
	; nite
	dbw 61, VOLTORB
	dbw 61, ZUBAT
	dbw 62, MAGNEMITE
	dbw 62, VENONAT
	dbw 63, ELECTRODE
	dbw 63, GOLBAT
	dbw 64, ELECTABUZZ

	map_id ROUTE_11
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 55, PIDGEY
	dbw 55, HOPPIP
	dbw 56, RATTATA
	dbw 56, SANDSHREW
	dbw 57, PIDGEOTTO
	dbw 57, SKIPLOOM
	dbw 58, KANGASKHAN
	; day
	dbw 55, PIDGEY
	dbw 55, HOPPIP
	dbw 56, RATTATA
	dbw 56, DODUO
	dbw 57, PIDGEOTTO
	dbw 57, SKIPLOOM
	dbw 58, KANGASKHAN
	; nite
	dbw 55, HOOTHOOT
	dbw 55, MEOWTH
	dbw 56, DROWZEE
	dbw 56, RATTATA
	dbw 57, NOCTOWL
	dbw 57, HYPNO
	dbw 58, RATICATE

	map_id ROUTE_13
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 66, NIDORAN_M
	dbw 66, NIDORAN_F
	dbw 67, HOPPIP
	dbw 67, ODDISH
	dbw 68, NIDORINO
	dbw 68, SKIPLOOM
	dbw 69, JUMPLUFF
	; day
	dbw 66, NIDORAN_M
	dbw 66, NIDORAN_F
	dbw 67, HOPPIP
	dbw 67, SUNKERN
	dbw 68, NIDORINA
	dbw 68, SKIPLOOM
	dbw 69, JUMPLUFF
	; nite
	dbw 66, VENONAT
	dbw 66, ODDISH
	dbw 67, QUAGSIRE
	dbw 67, HOOTHOOT
	dbw 68, VENOMOTH
	dbw 68, GLOOM
	dbw 69, NOCTOWL

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
	dbw 69, GRIMER
	dbw 69, FEAROW
	dbw 70, KOFFING
	dbw 70, VOLTORB
	dbw 71, GRIMER
	dbw 71, WEEZING
	dbw 72, MUK
	; day
	dbw 69, GRIMER
	dbw 69, FEAROW
	dbw 70, KOFFING
	dbw 70, SLUGMA
	dbw 71, MAGCARGO
	dbw 71, WEEZING
	dbw 72, MUK
	; nite
	dbw 69, GRIMER
	dbw 69, KOFFING
	dbw 70, MURKROW
	dbw 70, GRIMER
	dbw 71, WEEZING
	dbw 71, HOUNDOOM
	dbw 72, MUK

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
	dbw 75, TANGELA
	dbw 75, KRABBY
	dbw 76, PSYDUCK
	dbw 76, MARILL
	dbw 77, TANGELA
	dbw 77, AZUMARILL
	dbw 78, KINGLER
	; day
	dbw 75, TANGELA
	dbw 75, KRABBY
	dbw 76, PSYDUCK
	dbw 76, SLOWPOKE
	dbw 77, GOLDUCK
	dbw 77, MR__MIME
	dbw 78, KINGLER
	; nite
	dbw 75, TANGELA
	dbw 75, KRABBY
	dbw 76, QUAGSIRE
	dbw 76, SLOWPOKE
	dbw 77, GOLBAT
	dbw 77, KINGLER
	dbw 78, SLOWBRO

	map_id ROUTE_22
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 82, RATTATA
	dbw 82, SPEAROW
	dbw 83, MANKEY
	dbw 83, DODUO
	dbw 84, RATICATE
	dbw 84, FEAROW
	dbw 85, PONYTA
	; day
	dbw 82, SENTRET
	dbw 82, SPEAROW
	dbw 83, MANKEY
	dbw 83, PONYTA
	dbw 84, FURRET
	dbw 84, FEAROW
	dbw 85, PRIMEAPE
	; nite
	dbw 82, RATTATA
	dbw 82, ZUBAT
	dbw 83, MEOWTH
	dbw 83, HOUNDOUR
	dbw 84, RATICATE
	dbw 84, GOLBAT
	dbw 85, HOUNDOOM

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
	dbw 83, TANGELA
	dbw 83, PONYTA
	dbw 84, ARBOK
	dbw 84, DODUO
	dbw 85, RAPIDASH
	dbw 86, DODRIO
	dbw 88, URSARING
	; day
	dbw 83, TANGELA
	dbw 83, PONYTA
	dbw 84, ARBOK
	dbw 84, TAUROS
	dbw 85, RAPIDASH
	dbw 86, DODRIO
	dbw 88, KANGASKHAN
	; nite
	dbw 83, GOLBAT
	dbw 83, QUAGSIRE
	dbw 84, NOCTOWL
	dbw 84, MURKROW
	dbw 85, CROBAT
	dbw 86, HOUNDOOM
	dbw 88, URSARING

	db -1 ; end
