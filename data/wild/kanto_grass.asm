; Kanto Pokémon in grass
; Reworked: post-Elite Four level curve, thematic habitats and type variety.
; Slot rates are 30/30/20/10/5/4/1 percent, so slots 6 and 7 are the rare ones.
; Evolved forms never appear below the level at which they would have evolved.
; Scyther, Pinsir and Heracross are Bug Contest exclusives; ice types are
; Ice Island / Ice Path only; ghost types are Silent Crypt only.

KantoGrassWildMons:

	map_id DIGLETTS_CAVE
	db 4 percent, 2 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	dbw 38, DIGLETT
	dbw 38, GEODUDE
	dbw 39, DIGLETT
	dbw 39, ONIX
	dbw 40, DUGTRIO
	dbw 40, DRILBUR
	dbw 42, EXCADRILL
	; day
	dbw 38, DIGLETT
	dbw 38, SANDSHREW
	dbw 39, DIGLETT
	dbw 39, GEODUDE
	dbw 40, DUGTRIO
	dbw 40, TRAPINCH
	dbw 42, SANDSLASH
	; nite
	dbw 38, DIGLETT
	dbw 38, ZUBAT
	dbw 39, DIGLETT
	dbw 39, GOLBAT
	dbw 40, DUGTRIO
	dbw 40, PAWNIARD
	dbw 42, EXCADRILL

	map_id MOUNT_MOON
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 35, GEODUDE
	dbw 35, ZUBAT
	dbw 36, PARAS
	dbw 36, SANDSHREW
	dbw 37, CLEFAIRY
	dbw 38, GRAVELER
	dbw 39, ONIX
	; day
	dbw 35, GEODUDE
	dbw 35, SANDSHREW
	dbw 36, PARASECT
	dbw 36, GEODUDE
	dbw 37, CLEFAIRY
	dbw 38, GRAVELER
	dbw 39, GLIMMET
	; nite
	dbw 35, ZUBAT
	dbw 35, GEODUDE
	dbw 36, GOLBAT
	dbw 36, CLEFAIRY
	dbw 37, CLEFAIRY
	dbw 38, GRAVELER
	dbw 39, MAWILE

	map_id ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 40, GEODUDE
	dbw 40, ZUBAT
	dbw 41, CUBONE
	dbw 41, MACHOP
	dbw 42, ONIX
	dbw 43, GRAVELER
	dbw 44, MACHOKE
	; day
	dbw 40, GEODUDE
	dbw 40, CUBONE
	dbw 41, ONIX
	dbw 41, MACHOP
	dbw 42, GRAVELER
	dbw 43, MAROWAK
	dbw 44, RHYHORN
	; nite
	dbw 40, ZUBAT
	dbw 40, GEODUDE
	dbw 41, GOLBAT
	dbw 41, CUBONE
	dbw 42, ONIX
	dbw 43, GRAVELER
	dbw 44, MAROWAK

	map_id ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 41, GEODUDE
	dbw 41, MACHOP
	dbw 42, ONIX
	dbw 42, CUBONE
	dbw 43, GRAVELER
	dbw 44, RHYHORN
	dbw 45, MACHOKE
	; day
	dbw 41, GEODUDE
	dbw 41, CUBONE
	dbw 42, MACHOP
	dbw 42, ONIX
	dbw 43, GRAVELER
	dbw 44, MAROWAK
	dbw 45, RHYDON
	; nite
	dbw 41, ZUBAT
	dbw 41, GEODUDE
	dbw 42, GOLBAT
	dbw 42, ONIX
	dbw 43, GRAVELER
	dbw 44, MAROWAK
	dbw 45, GURDURR

	map_id VICTORY_ROAD
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 34, GEODUDE
	dbw 35, ONIX
	dbw 36, MACHOP
	dbw 37, GRAVELER
	dbw 38, RHYHORN
	dbw 40, MACHOKE
	dbw 42, SANDSLASH
	; day
	dbw 34, GEODUDE
	dbw 35, ONIX
	dbw 36, SANDSLASH
	dbw 37, GRAVELER
	dbw 38, RHYHORN
	dbw 40, MACHOKE
	dbw 42, RHYDON
	; nite
	dbw 34, ZUBAT
	dbw 35, GEODUDE
	dbw 36, GOLBAT
	dbw 37, GRAVELER
	dbw 38, ONIX
	dbw 40, CROBAT
	dbw 42, DONPHAN

	map_id TOHJO_FALLS
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 30, ZUBAT
	dbw 30, SLOWPOKE
	dbw 31, PSYDUCK
	dbw 31, MARILL
	dbw 32, GOLBAT
	dbw 33, AZUMARILL
	dbw 34, QUAGSIRE
	; day
	dbw 30, SLOWPOKE
	dbw 30, PSYDUCK
	dbw 31, MARILL
	dbw 31, ZUBAT
	dbw 32, QUAGSIRE
	dbw 33, AZUMARILL
	dbw 34, GOLDUCK
	; nite
	dbw 30, ZUBAT
	dbw 30, SLOWPOKE
	dbw 31, GOLBAT
	dbw 31, WOOPER
	dbw 32, QUAGSIRE
	dbw 33, CROBAT
	dbw 34, CROAGUNK

	map_id ROUTE_1
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 33, PIDGEY
	dbw 33, SENTRET
	dbw 34, RATTATA
	dbw 34, HOPPIP
	dbw 35, FURRET
	dbw 35, PIDGEOTTO
	dbw 36, BUNEARY
	; day
	dbw 33, PIDGEY
	dbw 33, SENTRET
	dbw 34, RATTATA
	dbw 34, LOTAD
	dbw 35, FURRET
	dbw 35, PIDGEOTTO
	dbw 36, MILTANK
	; nite
	dbw 33, HOOTHOOT
	dbw 33, RATTATA
	dbw 34, SPINARAK
	dbw 34, MEOWTH
	dbw 35, RATICATE
	dbw 35, NOCTOWL
	dbw 36, PERSIAN

	map_id ROUTE_2
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 34, CATERPIE
	dbw 34, LEDYBA
	dbw 35, PIDGEY
	dbw 35, METAPOD
	dbw 36, BUTTERFREE
	dbw 36, LEDIAN
	dbw 37, PIKACHU
	; day
	dbw 34, CATERPIE
	dbw 34, PIDGEY
	dbw 35, ODDISH
	dbw 35, METAPOD
	dbw 36, BUTTERFREE
	dbw 36, PIDGEOTTO
	dbw 37, PIKACHU
	; nite
	dbw 34, HOOTHOOT
	dbw 34, SPINARAK
	dbw 35, VENONAT
	dbw 35, ODDISH
	dbw 36, ARIADOS
	dbw 36, NOCTOWL
	dbw 37, GLOOM

	map_id VIRIDIAN_FOREST
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 34, CATERPIE
	dbw 34, WEEDLE
	dbw 35, METAPOD
	dbw 35, KAKUNA
	dbw 36, BUTTERFREE
	dbw 37, GRUBBIN
	dbw 38, PIKACHU
	; day
	dbw 34, CATERPIE
	dbw 34, WEEDLE
	dbw 35, METAPOD
	dbw 35, KAKUNA
	dbw 36, BEEDRILL
	dbw 37, SHROOMISH
	dbw 38, PIKACHU
	; nite
	dbw 34, VENONAT
	dbw 34, SPINARAK
	dbw 35, PARAS
	dbw 35, WEEDLE
	dbw 36, VENOMOTH
	dbw 37, JOLTIK
	dbw 38, ARIADOS

	map_id ROUTE_3
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 35, SPEAROW
	dbw 35, RATTATA
	dbw 36, EKANS
	dbw 36, SANDSHREW
	dbw 37, FEAROW
	dbw 37, ARBOK
	dbw 38, MANKEY
	; day
	dbw 35, SPEAROW
	dbw 35, RATTATA
	dbw 36, EKANS
	dbw 36, SANDSHREW
	dbw 37, FEAROW
	dbw 37, JIGGLYPUFF
	dbw 38, MANKEY
	; nite
	dbw 35, RATTATA
	dbw 35, ZUBAT
	dbw 36, EKANS
	dbw 36, MEOWTH
	dbw 37, RATICATE
	dbw 37, GOLBAT
	dbw 38, ARBOK

	map_id ROUTE_4
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 36, SPEAROW
	dbw 36, SANDSHREW
	dbw 37, GEODUDE
	dbw 37, EKANS
	dbw 38, FEAROW
	dbw 38, SANDSLASH
	dbw 39, CLEFAIRY
	; day
	dbw 36, SPEAROW
	dbw 36, SANDSHREW
	dbw 37, GEODUDE
	dbw 37, JIGGLYPUFF
	dbw 38, FEAROW
	dbw 38, SANDSLASH
	dbw 39, CLEFAIRY
	; nite
	dbw 36, RATTATA
	dbw 36, ZUBAT
	dbw 37, GEODUDE
	dbw 37, EKANS
	dbw 38, RATICATE
	dbw 38, GOLBAT
	dbw 39, CLEFAIRY

	map_id ROUTE_5
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 37, PIDGEY
	dbw 37, SNUBBULL
	dbw 38, ABRA
	dbw 38, MAREEP
	dbw 39, PIDGEOTTO
	dbw 39, GRANBULL
	dbw 40, KADABRA
	; day
	dbw 37, PIDGEY
	dbw 37, SNUBBULL
	dbw 38, ABRA
	dbw 38, JIGGLYPUFF
	dbw 39, PIDGEOTTO
	dbw 39, GRANBULL
	dbw 40, KADABRA
	; nite
	dbw 37, HOOTHOOT
	dbw 37, MEOWTH
	dbw 38, DROWZEE
	dbw 38, ABRA
	dbw 39, NOCTOWL
	dbw 39, HYPNO
	dbw 40, PERSIAN

	map_id ROUTE_6
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 38, MAGNEMITE
	dbw 38, SNUBBULL
	dbw 39, RATTATA
	dbw 39, VOLTORB
	dbw 40, MAGNETON
	dbw 40, GRANBULL
	dbw 41, ELEKID
	; day
	dbw 38, MAGNEMITE
	dbw 38, SNUBBULL
	dbw 39, JIGGLYPUFF
	dbw 39, VOLTORB
	dbw 40, MAGNETON
	dbw 40, GRANBULL
	dbw 41, ELECTABUZZ
	; nite
	dbw 38, MEOWTH
	dbw 38, DROWZEE
	dbw 39, MAGNEMITE
	dbw 39, RATICATE
	dbw 40, HYPNO
	dbw 40, PERSIAN
	dbw 41, ELECTABUZZ

	map_id ROUTE_7
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 39, RATTATA
	dbw 39, SPEAROW
	dbw 40, SNUBBULL
	dbw 40, ABRA
	dbw 41, RATICATE
	dbw 41, JIGGLYPUFF
	dbw 42, KADABRA
	; day
	dbw 39, RATTATA
	dbw 39, SPEAROW
	dbw 40, SNUBBULL
	dbw 40, MEOWTH
	dbw 41, RATICATE
	dbw 41, GRANBULL
	dbw 42, KADABRA
	; nite
	dbw 39, MEOWTH
	dbw 39, MURKROW
	dbw 40, HOUNDOUR
	dbw 40, DROWZEE
	dbw 41, PERSIAN
	dbw 41, HOUNDOOM
	dbw 42, HYPNO

	map_id ROUTE_8
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 39, PIDGEY
	dbw 39, SNUBBULL
	dbw 40, ABRA
	dbw 40, GROWLITHE
	dbw 41, PIDGEOTTO
	dbw 41, JIGGLYPUFF
	dbw 42, KADABRA
	; day
	dbw 39, PIDGEY
	dbw 39, GROWLITHE
	dbw 40, ABRA
	dbw 40, SNUBBULL
	dbw 41, PIDGEOTTO
	dbw 41, GRANBULL
	dbw 42, KADABRA
	; nite
	dbw 39, HOOTHOOT
	dbw 39, MEOWTH
	dbw 40, MURKROW
	dbw 40, DROWZEE
	dbw 41, NOCTOWL
	dbw 41, PERSIAN
	dbw 42, HOUNDOOM

	map_id ROUTE_9
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 40, SPEAROW
	dbw 40, RATTATA
	dbw 41, SANDSHREW
	dbw 41, GEODUDE
	dbw 42, FEAROW
	dbw 42, SANDSLASH
	dbw 43, RHYHORN
	; day
	dbw 40, SPEAROW
	dbw 40, RATTATA
	dbw 41, SANDSHREW
	dbw 41, DODUO
	dbw 42, FEAROW
	dbw 42, SANDSLASH
	dbw 43, DODRIO
	; nite
	dbw 40, RATTATA
	dbw 40, VENONAT
	dbw 41, ZUBAT
	dbw 41, GEODUDE
	dbw 42, RATICATE
	dbw 42, VENOMOTH
	dbw 43, GOLBAT

	map_id ROUTE_10_NORTH
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 40, VOLTORB
	dbw 40, SPEAROW
	dbw 41, MAGNEMITE
	dbw 41, SANDSHREW
	dbw 42, FEAROW
	dbw 42, MAGNETON
	dbw 43, ELECTABUZZ
	; day
	dbw 40, VOLTORB
	dbw 40, SPEAROW
	dbw 41, MAGNEMITE
	dbw 41, DODUO
	dbw 42, ELECTRODE
	dbw 42, MAGNETON
	dbw 43, ELECTABUZZ
	; nite
	dbw 40, VOLTORB
	dbw 40, ZUBAT
	dbw 41, MAGNEMITE
	dbw 41, VENONAT
	dbw 42, ELECTRODE
	dbw 42, GOLBAT
	dbw 43, ELECTABUZZ

	map_id ROUTE_11
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 38, PIDGEY
	dbw 38, HOPPIP
	dbw 39, RATTATA
	dbw 39, SANDSHREW
	dbw 40, PIDGEOTTO
	dbw 40, SKIPLOOM
	dbw 41, KANGASKHAN
	; day
	dbw 38, PIDGEY
	dbw 38, HOPPIP
	dbw 39, RATTATA
	dbw 39, DODUO
	dbw 40, PIDGEOTTO
	dbw 40, SKIPLOOM
	dbw 41, KANGASKHAN
	; nite
	dbw 38, HOOTHOOT
	dbw 38, MEOWTH
	dbw 39, DROWZEE
	dbw 39, RATTATA
	dbw 40, NOCTOWL
	dbw 40, HYPNO
	dbw 41, RATICATE

	map_id ROUTE_13
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 41, NIDORAN_M
	dbw 41, NIDORAN_F
	dbw 42, HOPPIP
	dbw 42, ODDISH
	dbw 43, NIDORINO
	dbw 43, SKIPLOOM
	dbw 44, JUMPLUFF
	; day
	dbw 41, NIDORAN_M
	dbw 41, NIDORAN_F
	dbw 42, HOPPIP
	dbw 42, SUNKERN
	dbw 43, NIDORINA
	dbw 43, SKIPLOOM
	dbw 44, JUMPLUFF
	; nite
	dbw 41, VENONAT
	dbw 41, ODDISH
	dbw 42, QUAGSIRE
	dbw 42, HOOTHOOT
	dbw 43, VENOMOTH
	dbw 43, GLOOM
	dbw 44, NOCTOWL

	map_id ROUTE_14
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 42, NIDORAN_M
	dbw 42, NIDORAN_F
	dbw 43, HOPPIP
	dbw 43, ODDISH
	dbw 44, NIDORINO
	dbw 44, SKIPLOOM
	dbw 45, JUMPLUFF
	; day
	dbw 42, NIDORINO
	dbw 42, NIDORINA
	dbw 43, SKIPLOOM
	dbw 43, SUNFLORA
	dbw 44, NIDOKING
	dbw 44, NIDOQUEEN
	dbw 45, JUMPLUFF
	; nite
	dbw 42, VENONAT
	dbw 42, GLOOM
	dbw 43, QUAGSIRE
	dbw 43, MURKROW
	dbw 44, VENOMOTH
	dbw 44, VILEPLUME
	dbw 45, NOCTOWL

	map_id ROUTE_15
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 42, NIDORAN_F
	dbw 42, NIDORAN_M
	dbw 43, PIDGEY
	dbw 43, HOPPIP
	dbw 44, NIDORINA
	dbw 44, PIDGEOTTO
	dbw 45, CHANSEY
	; day
	dbw 42, NIDORINA
	dbw 42, NIDORINO
	dbw 43, SKIPLOOM
	dbw 43, TANGELA
	dbw 44, NIDOQUEEN
	dbw 44, NIDOKING
	dbw 45, CHANSEY
	; nite
	dbw 42, VENONAT
	dbw 42, QUAGSIRE
	dbw 43, HOOTHOOT
	dbw 43, GLOOM
	dbw 44, VENOMOTH
	dbw 44, NOCTOWL
	dbw 45, CHANSEY

	map_id ROUTE_16
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, GRIMER
	dbw 43, FEAROW
	dbw 44, KOFFING
	dbw 44, VOLTORB
	dbw 45, GRIMER
	dbw 45, WEEZING
	dbw 46, MUK
	; day
	dbw 43, GRIMER
	dbw 43, FEAROW
	dbw 44, KOFFING
	dbw 44, SLUGMA
	dbw 45, MAGCARGO
	dbw 45, WEEZING
	dbw 46, MUK
	; nite
	dbw 43, GRIMER
	dbw 43, KOFFING
	dbw 44, MURKROW
	dbw 44, GRIMER
	dbw 45, WEEZING
	dbw 45, HOUNDOOM
	dbw 46, MUK

	map_id ROUTE_17
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 44, GRIMER
	dbw 44, FEAROW
	dbw 45, KOFFING
	dbw 45, SLUGMA
	dbw 46, WEEZING
	dbw 46, MAGCARGO
	dbw 47, MUK
	; day
	dbw 44, GRIMER
	dbw 44, DODUO
	dbw 45, KOFFING
	dbw 45, SEVIPER
	dbw 46, WEEZING
	dbw 46, MAGCARGO
	dbw 47, MUK
	; nite
	dbw 44, GRIMER
	dbw 44, KOFFING
	dbw 45, MURKROW
	dbw 45, HOUNDOUR
	dbw 46, WEEZING
	dbw 46, HOUNDOOM
	dbw 47, MUK

	map_id ROUTE_18
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 44, GRIMER
	dbw 44, FEAROW
	dbw 45, KOFFING
	dbw 45, DODUO
	dbw 46, WEEZING
	dbw 46, DODRIO
	dbw 47, MUK
	; day
	dbw 44, GRIMER
	dbw 44, FEAROW
	dbw 45, KOFFING
	dbw 45, ZANGOOSE
	dbw 46, WEEZING
	dbw 46, DODRIO
	dbw 47, MUK
	; nite
	dbw 44, GRIMER
	dbw 44, KOFFING
	dbw 45, MURKROW
	dbw 45, SEVIPER
	dbw 46, WEEZING
	dbw 46, HOUNDOOM
	dbw 47, MUK

	map_id ROUTE_21
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, TANGELA
	dbw 43, KRABBY
	dbw 44, PSYDUCK
	dbw 44, MARILL
	dbw 45, TANGELA
	dbw 45, AZUMARILL
	dbw 46, KINGLER
	; day
	dbw 43, TANGELA
	dbw 43, KRABBY
	dbw 44, PSYDUCK
	dbw 44, SLOWPOKE
	dbw 45, GOLDUCK
	dbw 45, MR__MIME
	dbw 46, KINGLER
	; nite
	dbw 43, TANGELA
	dbw 43, KRABBY
	dbw 44, QUAGSIRE
	dbw 44, SLOWPOKE
	dbw 45, GOLBAT
	dbw 45, KINGLER
	dbw 46, SLOWBRO

	map_id ROUTE_22
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 32, RATTATA
	dbw 32, SPEAROW
	dbw 33, MANKEY
	dbw 33, DODUO
	dbw 34, RATICATE
	dbw 34, FEAROW
	dbw 35, PONYTA
	; day
	dbw 32, SENTRET
	dbw 32, SPEAROW
	dbw 33, MANKEY
	dbw 33, PONYTA
	dbw 34, FURRET
	dbw 34, FEAROW
	dbw 35, PRIMEAPE
	; nite
	dbw 32, RATTATA
	dbw 32, ZUBAT
	dbw 33, MEOWTH
	dbw 33, HOUNDOUR
	dbw 34, RATICATE
	dbw 34, GOLBAT
	dbw 35, HOUNDOOM

	map_id ROUTE_24
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 36, CATERPIE
	dbw 36, BELLSPROUT
	dbw 37, ABRA
	dbw 37, ODDISH
	dbw 38, BUTTERFREE
	dbw 38, WEEPINBELL
	dbw 39, KADABRA
	; day
	dbw 36, CATERPIE
	dbw 36, BELLSPROUT
	dbw 37, ABRA
	dbw 37, SUNKERN
	dbw 38, BUTTERFREE
	dbw 38, WEEPINBELL
	dbw 39, SUNFLORA
	; nite
	dbw 36, VENONAT
	dbw 36, ODDISH
	dbw 37, BELLSPROUT
	dbw 37, ABRA
	dbw 38, GLOOM
	dbw 38, VENOMOTH
	dbw 39, WEEPINBELL

	map_id ROUTE_25
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 37, CATERPIE
	dbw 37, PIDGEY
	dbw 38, BELLSPROUT
	dbw 38, ODDISH
	dbw 39, BUTTERFREE
	dbw 39, PIDGEOTTO
	dbw 40, KADABRA
	; day
	dbw 37, CATERPIE
	dbw 37, PIDGEY
	dbw 38, BELLSPROUT
	dbw 38, SLOWPOKE
	dbw 39, BUTTERFREE
	dbw 39, PIDGEOTTO
	dbw 40, WEEPINBELL
	; nite
	dbw 37, ODDISH
	dbw 37, HOOTHOOT
	dbw 38, VENONAT
	dbw 38, ZUBAT
	dbw 39, GLOOM
	dbw 39, NOCTOWL
	dbw 40, VENOMOTH

	map_id ROUTE_26
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 30, DODUO
	dbw 30, SANDSHREW
	dbw 31, PONYTA
	dbw 31, SPEAROW
	dbw 32, SANDSLASH
	dbw 32, FEAROW
	dbw 34, DODRIO
	; day
	dbw 30, DODUO
	dbw 30, SANDSHREW
	dbw 31, PONYTA
	dbw 31, TAUROS
	dbw 32, SANDSLASH
	dbw 32, MILTANK
	dbw 34, DODRIO
	; nite
	dbw 30, QUAGSIRE
	dbw 30, NOCTOWL
	dbw 31, RATICATE
	dbw 31, ZUBAT
	dbw 32, GOLBAT
	dbw 32, MURKROW
	dbw 34, HOUNDOOM

	map_id ROUTE_27
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 30, DODUO
	dbw 30, RATTATA
	dbw 31, ARBOK
	dbw 31, SANDSHREW
	dbw 32, RATICATE
	dbw 32, SANDSLASH
	dbw 34, PONYTA
	; day
	dbw 30, DODUO
	dbw 30, EKANS
	dbw 31, ARBOK
	dbw 31, PONYTA
	dbw 32, SANDSLASH
	dbw 32, TAUROS
	dbw 34, DODRIO
	; nite
	dbw 30, QUAGSIRE
	dbw 30, ZUBAT
	dbw 31, NOCTOWL
	dbw 31, RATICATE
	dbw 32, GOLBAT
	dbw 32, ARBOK
	dbw 34, HOUNDOOM

	map_id ROUTE_28
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 45, TANGELA
	dbw 45, PONYTA
	dbw 46, ARBOK
	dbw 46, DODUO
	dbw 47, RAPIDASH
	dbw 48, DODRIO
	dbw 50, URSARING
	; day
	dbw 45, TANGELA
	dbw 45, PONYTA
	dbw 46, ARBOK
	dbw 46, TAUROS
	dbw 47, RAPIDASH
	dbw 48, DODRIO
	dbw 50, KANGASKHAN
	; nite
	dbw 45, GOLBAT
	dbw 45, QUAGSIRE
	dbw 46, NOCTOWL
	dbw 46, MURKROW
	dbw 47, CROBAT
	dbw 48, HOUNDOOM
	dbw 50, URSARING

	db -1 ; end
