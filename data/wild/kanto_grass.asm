; Kanto Pokémon in grass
; Main campaign: enter overland through Route 22 after Johto, then collect
; Kanto's badges before Victory Road and the Elite Four.
; Kanto encounters sit below their local route trainers, but close enough that
; a newly caught Pokemon can join the team without dozens of dead levels.
; Route 26/27 bridge Johto and Kanto; Route 28 is late postgame.
; Slot rates are 30/30/20/10/5/4/1 percent, so slots 6 and 7 are the rare ones.
; Evolved forms never appear below the level at which they would have evolved.
; Scyther, Pinsir and Heracross are Bug Contest exclusives.
; Ice types are Shiver Isle / Ice Path / the Safari Zone's ice area only, plus
; Walrein in SILVER_CAVE_ROOM_2's water.
; Ghost types are Silent Crypt only, with one deliberate exception: Galarian
; Corsola on the Whirl Islands' night tables. It is bleached dead coral -
; "areas oceans once covered" - so it belongs on a tide line, not inland.
;
; GIFT / EVENT POKEMON APPEAR IN NO WILD TABLE:
;   Lapras (Union Cave B2F event), Finizen (Route 41 event),
;   Palafin, Riolu (Goldenrod Underground girl), Eevee, Tyrogue (Kiyo),
;   Shuckle (Shuckie), Togepi (Elm's aide egg), Feebas (Goldenrod salesman),
;   and the six starters.
; Dratini is a gift too (Dragon's Den elder) but stays wild in DRAGONS_DEN_B1F
;   only - not Blackthorn, not the Safari rods, not Route 45.
; Farfetch'd is a 1% morning-only slot in ILEX_FOREST and nowhere else.

KantoGrassWildMons:

	map_id DIGLETTS_CAVE
	db 4 percent, 2 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	dbw 53, DIGLETT
	dbw 53, GEODUDE
	dbw 54, DIGLETT
	dbw 54, ONIX
	dbw 55, DUGTRIO
	dbw 55, DRILBUR
	dbw 57, EXCADRILL
	; day
	dbw 53, DIGLETT
	dbw 53, SANDSHREW
	dbw 54, DIGLETT
	dbw 54, GEODUDE
	dbw 55, DUGTRIO
	dbw 55, TRAPINCH
	dbw 57, SANDSLASH
	; nite
	dbw 53, DIGLETT
	dbw 53, ZUBAT
	dbw 54, DIGLETT
	dbw 54, GOLBAT
	dbw 55, DUGTRIO
	dbw 55, PAWNIARD
	dbw 57, EXCADRILL

	map_id MOUNT_MOON
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 47, GEODUDE
	dbw 47, ZUBAT
	dbw 48, PARAS
	dbw 48, SANDSHREW
	dbw 49, CLEFAIRY
	dbw 50, GRAVELER
	dbw 51, ONIX
	; day
	dbw 47, GEODUDE
	dbw 47, SANDSHREW
	dbw 48, PARASECT
	dbw 48, GEODUDE
	dbw 49, CLEFAIRY
	dbw 50, GRAVELER
	dbw 51, GLIMMET
	; nite
	dbw 47, ZUBAT
	dbw 47, GEODUDE
	dbw 48, GOLBAT
	dbw 48, CLEFAIRY
	dbw 49, CLEFAIRY
	dbw 50, GRAVELER
	dbw 51, MAWILE

	map_id ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 52, GEODUDE
	dbw 52, ZUBAT
	dbw 53, CUBONE
	dbw 53, MACHOP
	dbw 54, ONIX
	dbw 54, GRAVELER
	dbw 55, MACHOKE
	; day
	dbw 52, GEODUDE
	dbw 52, CUBONE
	dbw 53, ONIX
	dbw 53, MACHOP
	dbw 54, GRAVELER
	dbw 54, MAROWAK
	dbw 55, RHYHORN
	; nite
	dbw 52, ZUBAT
	dbw 52, GEODUDE
	dbw 53, GOLBAT
	dbw 53, CUBONE
	dbw 54, ONIX
	dbw 54, GRAVELER
	dbw 55, MAROWAK

	map_id ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 53, GEODUDE
	dbw 53, MACHOP
	dbw 54, ONIX
	dbw 54, CUBONE
	dbw 55, GRAVELER
	dbw 55, RHYHORN
	dbw 56, MACHOKE
	; day
	dbw 53, GEODUDE
	dbw 53, CUBONE
	dbw 54, MACHOP
	dbw 54, ONIX
	dbw 55, GRAVELER
	dbw 55, MAROWAK
	dbw 56, RHYDON
	; nite
	dbw 53, ZUBAT
	dbw 53, GEODUDE
	dbw 54, GOLBAT
	dbw 54, ONIX
	dbw 55, GRAVELER
	dbw 55, MAROWAK
	dbw 56, GURDURR

	map_id VICTORY_ROAD
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 63, GEODUDE
	dbw 64, ONIX
	dbw 65, MACHOP
	dbw 65, GRAVELER
	dbw 66, RHYHORN
	dbw 67, MACHOKE
	dbw 69, SANDSLASH
	; day
	dbw 63, GEODUDE
	dbw 64, ONIX
	dbw 65, SANDSLASH
	dbw 65, GRAVELER
	dbw 66, RHYHORN
	dbw 67, MACHOKE
	dbw 69, RHYDON
	; nite
	dbw 63, ZUBAT
	dbw 64, GEODUDE
	dbw 65, GOLBAT
	dbw 65, GRAVELER
	dbw 66, ONIX
	dbw 67, CROBAT
	dbw 69, DONPHAN

	map_id TOHJO_FALLS
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, ZUBAT
	dbw 43, SLOWPOKE
	dbw 44, PSYDUCK
	dbw 44, MARILL
	dbw 45, GOLBAT
	dbw 45, AZUMARILL
	dbw 46, QUAGSIRE
	; day
	dbw 43, SLOWPOKE
	dbw 43, PSYDUCK
	dbw 44, MARILL
	dbw 44, ZUBAT
	dbw 45, QUAGSIRE
	dbw 45, AZUMARILL
	dbw 46, GOLDUCK
	; nite
	dbw 43, ZUBAT
	dbw 43, SLOWPOKE
	dbw 44, GOLBAT
	dbw 44, WOOPER
	dbw 45, QUAGSIRE
	dbw 45, CROBAT
	dbw 46, CROAGUNK

	map_id ROUTE_1
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, PIDGEY
	dbw 43, SENTRET
	dbw 44, RATTATA
	dbw 44, HOPPIP
	dbw 46, FURRET
	dbw 46, PIDGEOTTO
	dbw 47, BUNEARY
	; day
	dbw 43, PIDGEY
	dbw 43, SENTRET
	dbw 44, RATTATA
	dbw 44, LOTAD
	dbw 46, FURRET
	dbw 46, PIDGEOTTO
	dbw 47, MILTANK
	; nite
	dbw 43, HOOTHOOT
	dbw 43, RATTATA
	dbw 44, SPINARAK
	dbw 44, MEOWTH
	dbw 46, RATICATE
	dbw 46, NOCTOWL
	dbw 47, PERSIAN

	map_id ROUTE_2
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, CATERPIE
	dbw 43, LEDYBA
	dbw 44, PIDGEY
	dbw 44, METAPOD
	dbw 46, BUTTERFREE
	dbw 46, LEDIAN
	dbw 47, PIKACHU
	; day
	dbw 43, CATERPIE
	dbw 43, PIDGEY
	dbw 44, ODDISH
	dbw 44, METAPOD
	dbw 46, BUTTERFREE
	dbw 46, PIDGEOTTO
	dbw 47, PIKACHU
	; nite
	dbw 43, HOOTHOOT
	dbw 43, SPINARAK
	dbw 44, VENONAT
	dbw 44, ODDISH
	dbw 46, ARIADOS
	dbw 46, NOCTOWL
	dbw 47, GLOOM

	map_id VIRIDIAN_FOREST
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, CATERPIE
	dbw 43, WEEDLE
	dbw 44, METAPOD
	dbw 44, KAKUNA
	dbw 45, BUTTERFREE
	dbw 46, GRUBBIN
	dbw 47, PIKACHU
	; day
	dbw 43, CATERPIE
	dbw 43, WEEDLE
	dbw 44, METAPOD
	dbw 44, KAKUNA
	dbw 45, BEEDRILL
	dbw 46, SHROOMISH
	dbw 47, PIKACHU
	; nite
	dbw 43, VENONAT
	dbw 43, SPINARAK
	dbw 44, PARAS
	dbw 44, WEEDLE
	dbw 45, VENOMOTH
	dbw 46, JOLTIK
	dbw 47, ARIADOS

	map_id ROUTE_3
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 47, SPEAROW
	dbw 47, RATTATA
	dbw 48, EKANS
	dbw 48, SANDSHREW
	dbw 49, FEAROW
	dbw 49, ARBOK
	dbw 50, MANKEY
	; day
	dbw 47, SPEAROW
	dbw 47, RATTATA
	dbw 48, EKANS
	dbw 48, SANDSHREW
	dbw 49, FEAROW
	dbw 49, JIGGLYPUFF
	dbw 50, MANKEY
	; nite
	dbw 47, RATTATA
	dbw 47, ZUBAT
	dbw 48, EKANS
	dbw 48, MEOWTH
	dbw 49, RATICATE
	dbw 49, GOLBAT
	dbw 50, ARBOK

	map_id ROUTE_4
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 48, SPEAROW
	dbw 48, SANDSHREW
	dbw 49, GEODUDE
	dbw 49, EKANS
	dbw 50, FEAROW
	dbw 50, SANDSLASH
	dbw 51, CLEFAIRY
	; day
	dbw 48, SPEAROW
	dbw 48, SANDSHREW
	dbw 49, GEODUDE
	dbw 49, JIGGLYPUFF
	dbw 50, FEAROW
	dbw 50, SANDSLASH
	dbw 51, CLEFAIRY
	; nite
	dbw 48, RATTATA
	dbw 48, ZUBAT
	dbw 49, GEODUDE
	dbw 49, EKANS
	dbw 50, RATICATE
	dbw 50, GOLBAT
	dbw 51, CLEFAIRY

	map_id ROUTE_5
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 51, PIDGEY
	dbw 51, SNUBBULL
	dbw 52, ABRA
	dbw 52, MAREEP
	dbw 53, PIDGEOTTO
	dbw 53, GRANBULL
	dbw 54, KADABRA
	; day
	dbw 51, PIDGEY
	dbw 51, SNUBBULL
	dbw 52, ABRA
	dbw 52, JIGGLYPUFF
	dbw 53, PIDGEOTTO
	dbw 53, GRANBULL
	dbw 54, KADABRA
	; nite
	dbw 51, HOOTHOOT
	dbw 51, MEOWTH
	dbw 52, DROWZEE
	dbw 52, ABRA
	dbw 53, NOCTOWL
	dbw 53, HYPNO
	dbw 54, PERSIAN

	map_id ROUTE_6
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 51, MAGNEMITE
	dbw 51, SNUBBULL
	dbw 52, RATTATA
	dbw 52, VOLTORB
	dbw 53, MAGNETON
	dbw 53, GRANBULL
	dbw 54, ELEKID
	; day
	dbw 51, MAGNEMITE
	dbw 51, SNUBBULL
	dbw 52, JIGGLYPUFF
	dbw 52, VOLTORB
	dbw 53, MAGNETON
	dbw 53, GRANBULL
	dbw 54, ELECTABUZZ
	; nite
	dbw 51, MEOWTH
	dbw 51, DROWZEE
	dbw 52, MAGNEMITE
	dbw 52, RATICATE
	dbw 53, HYPNO
	dbw 53, PERSIAN
	dbw 54, ELECTABUZZ

	map_id ROUTE_7
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, RATTATA
	dbw 56, SPEAROW
	dbw 57, SNUBBULL
	dbw 57, ABRA
	dbw 58, RATICATE
	dbw 58, JIGGLYPUFF
	dbw 59, KADABRA
	; day
	dbw 56, RATTATA
	dbw 56, SPEAROW
	dbw 57, SNUBBULL
	dbw 57, MEOWTH
	dbw 58, RATICATE
	dbw 58, GRANBULL
	dbw 59, KADABRA
	; nite
	dbw 56, MEOWTH
	dbw 56, MURKROW
	dbw 57, HOUNDOUR
	dbw 57, DROWZEE
	dbw 58, PERSIAN
	dbw 58, HOUNDOOM
	dbw 59, HYPNO

	map_id ROUTE_8
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, PIDGEY
	dbw 56, SNUBBULL
	dbw 57, ABRA
	dbw 57, GROWLITHE
	dbw 58, PIDGEOTTO
	dbw 58, JIGGLYPUFF
	dbw 59, KADABRA
	; day
	dbw 56, PIDGEY
	dbw 56, GROWLITHE
	dbw 57, ABRA
	dbw 57, SNUBBULL
	dbw 58, PIDGEOTTO
	dbw 58, GRANBULL
	dbw 59, KADABRA
	; nite
	dbw 56, HOOTHOOT
	dbw 56, MEOWTH
	dbw 57, MURKROW
	dbw 57, DROWZEE
	dbw 58, NOCTOWL
	dbw 58, PERSIAN
	dbw 59, HOUNDOOM

	map_id ROUTE_9
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 51, SPEAROW
	dbw 51, RATTATA
	dbw 52, SANDSHREW
	dbw 52, GEODUDE
	dbw 53, FEAROW
	dbw 53, SANDSLASH
	dbw 54, RHYHORN
	; day
	dbw 51, SPEAROW
	dbw 51, RATTATA
	dbw 52, SANDSHREW
	dbw 52, DODUO
	dbw 53, FEAROW
	dbw 53, SANDSLASH
	dbw 54, DODRIO
	; nite
	dbw 51, RATTATA
	dbw 51, VENONAT
	dbw 52, ZUBAT
	dbw 52, GEODUDE
	dbw 53, RATICATE
	dbw 53, VENOMOTH
	dbw 54, GOLBAT

	map_id ROUTE_10_NORTH
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 52, VOLTORB
	dbw 52, SPEAROW
	dbw 53, MAGNEMITE
	dbw 53, SANDSHREW
	dbw 54, FEAROW
	dbw 54, MAGNETON
	dbw 55, ELECTABUZZ
	; day
	dbw 52, VOLTORB
	dbw 52, SPEAROW
	dbw 53, MAGNEMITE
	dbw 53, DODUO
	dbw 54, ELECTRODE
	dbw 54, MAGNETON
	dbw 55, ELECTABUZZ
	; nite
	dbw 52, VOLTORB
	dbw 52, ZUBAT
	dbw 53, MAGNEMITE
	dbw 53, VENONAT
	dbw 54, ELECTRODE
	dbw 54, GOLBAT
	dbw 55, ELECTABUZZ

	map_id ROUTE_11
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 55, PIDGEY
	dbw 55, HOPPIP
	dbw 56, RATTATA
	dbw 56, SANDSHREW
	dbw 57, PIDGEOTTO
	dbw 57, SKIPLOOM
	dbw 58, SANDSLASH
	; day
	dbw 55, PIDGEY
	dbw 55, HOPPIP
	dbw 56, RATTATA
	dbw 56, DODUO
	dbw 57, PIDGEOTTO
	dbw 57, SKIPLOOM
	dbw 58, DODRIO
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
	dbw 56, NIDORAN_M
	dbw 56, NIDORAN_F
	dbw 57, HOPPIP
	dbw 57, ODDISH
	dbw 58, NIDORINO
	dbw 58, SKIPLOOM
	dbw 59, JUMPLUFF
	; day
	dbw 56, NIDORAN_M
	dbw 56, NIDORAN_F
	dbw 57, HOPPIP
	dbw 57, SUNKERN
	dbw 58, NIDORINA
	dbw 58, SKIPLOOM
	dbw 59, JUMPLUFF
	; nite
	dbw 56, VENONAT
	dbw 56, ODDISH
	dbw 57, QUAGSIRE
	dbw 57, HOOTHOOT
	dbw 58, VENOMOTH
	dbw 58, GLOOM
	dbw 59, NOCTOWL

	map_id ROUTE_14
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, NIDORAN_M
	dbw 56, NIDORAN_F
	dbw 57, HOPPIP
	dbw 57, ODDISH
	dbw 58, NIDORINO
	dbw 58, SKIPLOOM
	dbw 59, JUMPLUFF
	; day
	dbw 56, NIDORINO
	dbw 56, NIDORINA
	dbw 57, SKIPLOOM
	dbw 57, SUNFLORA
	dbw 58, NIDOKING
	dbw 58, NIDOQUEEN
	dbw 59, JUMPLUFF
	; nite
	dbw 56, VENONAT
	dbw 56, GLOOM
	dbw 57, QUAGSIRE
	dbw 57, MURKROW
	dbw 58, VENOMOTH
	dbw 58, VILEPLUME
	dbw 59, NOCTOWL

	map_id ROUTE_15
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 57, NIDORAN_F
	dbw 57, NIDORAN_M
	dbw 58, PIDGEY
	dbw 58, HOPPIP
	dbw 59, NIDORINA
	dbw 59, PIDGEOTTO
	dbw 60, NIDOQUEEN
	; day
	dbw 57, NIDORINA
	dbw 57, NIDORINO
	dbw 58, SKIPLOOM
	dbw 58, TANGELA
	dbw 59, NIDOQUEEN
	dbw 59, NIDOKING
	dbw 60, PIDGEOT
	; nite
	dbw 57, VENONAT
	dbw 57, QUAGSIRE
	dbw 58, HOOTHOOT
	dbw 58, GLOOM
	dbw 59, VENOMOTH
	dbw 59, NOCTOWL
	dbw 60, NIDOKING

	map_id ROUTE_16
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 56, GRIMER
	dbw 56, FEAROW
	dbw 57, KOFFING
	dbw 57, VOLTORB
	dbw 58, GRIMER
	dbw 58, WEEZING
	dbw 59, MUK
	; day
	dbw 56, GRIMER
	dbw 56, FEAROW
	dbw 57, KOFFING
	dbw 57, SLUGMA
	dbw 58, MAGCARGO
	dbw 58, WEEZING
	dbw 59, MUK
	; nite
	dbw 56, GRIMER
	dbw 56, KOFFING
	dbw 57, MURKROW
	dbw 57, GRIMER
	dbw 58, WEEZING
	dbw 58, HOUNDOOM
	dbw 59, MUK

	map_id ROUTE_17
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 57, GRIMER
	dbw 57, FEAROW
	dbw 58, KOFFING
	dbw 58, SLUGMA
	dbw 59, WEEZING
	dbw 59, MAGCARGO
	dbw 60, MUK
	; day
	dbw 57, GRIMER
	dbw 57, DODUO
	dbw 58, KOFFING
	dbw 58, SEVIPER
	dbw 59, WEEZING
	dbw 59, MAGCARGO
	dbw 60, MUK
	; nite
	dbw 57, GRIMER
	dbw 57, KOFFING
	dbw 58, MURKROW
	dbw 58, HOUNDOUR
	dbw 59, WEEZING
	dbw 59, HOUNDOOM
	dbw 60, MUK

	map_id ROUTE_18
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 57, GRIMER
	dbw 57, FEAROW
	dbw 58, KOFFING
	dbw 58, DODUO
	dbw 59, WEEZING
	dbw 59, DODRIO
	dbw 60, MUK
	; day
	dbw 57, GRIMER
	dbw 57, FEAROW
	dbw 58, KOFFING
	dbw 58, ZANGOOSE
	dbw 59, WEEZING
	dbw 59, DODRIO
	dbw 60, MUK
	; nite
	dbw 57, GRIMER
	dbw 57, KOFFING
	dbw 58, MURKROW
	dbw 58, SEVIPER
	dbw 59, WEEZING
	dbw 59, HOUNDOOM
	dbw 60, MUK

	map_id ROUTE_21
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	dbw 60, TANGELA
	dbw 60, KRABBY
	dbw 61, PSYDUCK
	dbw 61, MARILL
	dbw 63, TANGELA
	dbw 63, AZUMARILL
	dbw 64, KINGLER
	; day
	dbw 60, TANGELA
	dbw 60, KRABBY
	dbw 61, PSYDUCK
	dbw 61, SLOWPOKE
	dbw 63, GOLDUCK
	dbw 63, MR__MIME
	dbw 64, KINGLER
	; nite
	dbw 60, TANGELA
	dbw 60, KRABBY
	dbw 61, QUAGSIRE
	dbw 61, SLOWPOKE
	dbw 63, GOLBAT
	dbw 63, KINGLER
	dbw 64, SLOWBRO

	map_id ROUTE_22
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, RATTATA
	dbw 43, SPEAROW
	dbw 44, MANKEY
	dbw 44, DODUO
	dbw 46, RATICATE
	dbw 46, FEAROW
	dbw 47, PONYTA
	; day
	dbw 43, SENTRET
	dbw 43, SPEAROW
	dbw 44, MANKEY
	dbw 44, PONYTA
	dbw 46, FURRET
	dbw 46, FEAROW
	dbw 47, PRIMEAPE
	; nite
	dbw 43, RATTATA
	dbw 43, ZUBAT
	dbw 44, MEOWTH
	dbw 44, HOUNDOUR
	dbw 46, RATICATE
	dbw 46, GOLBAT
	dbw 47, HOUNDOOM

	map_id ROUTE_24
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 48, CATERPIE
	dbw 48, BELLSPROUT
	dbw 49, ABRA
	dbw 49, ODDISH
	dbw 50, BUTTERFREE
	dbw 50, WEEPINBELL
	dbw 51, KADABRA
	; day
	dbw 48, CATERPIE
	dbw 48, BELLSPROUT
	dbw 49, ABRA
	dbw 49, SUNKERN
	dbw 50, BUTTERFREE
	dbw 50, WEEPINBELL
	dbw 51, SUNFLORA
	; nite
	dbw 48, VENONAT
	dbw 48, ODDISH
	dbw 49, BELLSPROUT
	dbw 49, ABRA
	dbw 50, GLOOM
	dbw 50, VENOMOTH
	dbw 51, WEEPINBELL

	map_id ROUTE_25
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 48, CATERPIE
	dbw 48, PIDGEY
	dbw 49, BELLSPROUT
	dbw 49, ODDISH
	dbw 50, BUTTERFREE
	dbw 50, PIDGEOTTO
	dbw 51, KADABRA
	; day
	dbw 48, CATERPIE
	dbw 48, PIDGEY
	dbw 49, BELLSPROUT
	dbw 49, SLOWPOKE
	dbw 50, BUTTERFREE
	dbw 50, PIDGEOTTO
	dbw 51, WEEPINBELL
	; nite
	dbw 48, ODDISH
	dbw 48, HOOTHOOT
	dbw 49, VENONAT
	dbw 49, ZUBAT
	dbw 50, GLOOM
	dbw 50, NOCTOWL
	dbw 51, VENOMOTH

	map_id ROUTE_26
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, DODUO
	dbw 43, SANDSHREW
	dbw 44, PONYTA
	dbw 44, SPEAROW
	dbw 45, SANDSLASH
	dbw 45, FEAROW
	dbw 47, DODRIO
	; day
	dbw 43, DODUO
	dbw 43, SANDSHREW
	dbw 44, PONYTA
	dbw 44, RAPIDASH
	dbw 45, SANDSLASH
	dbw 45, MILTANK
	dbw 47, DODRIO
	; nite
	dbw 43, QUAGSIRE
	dbw 43, NOCTOWL
	dbw 44, RATICATE
	dbw 44, ZUBAT
	dbw 45, GOLBAT
	dbw 45, MURKROW
	dbw 47, HOUNDOOM

	map_id ROUTE_27
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 43, DODUO
	dbw 43, RATTATA
	dbw 44, ARBOK
	dbw 44, SANDSHREW
	dbw 45, RATICATE
	dbw 45, SANDSLASH
	dbw 47, PONYTA
	; day
	dbw 43, DODUO
	dbw 43, EKANS
	dbw 44, ARBOK
	dbw 44, PONYTA
	dbw 45, SANDSLASH
	dbw 45, FEAROW
	dbw 47, DODRIO
	; nite
	dbw 43, QUAGSIRE
	dbw 43, ZUBAT
	dbw 44, NOCTOWL
	dbw 44, RATICATE
	dbw 45, GOLBAT
	dbw 45, ARBOK
	dbw 47, HOUNDOOM

	map_id ROUTE_28
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	dbw 78, TANGELA
	dbw 78, PONYTA
	dbw 79, ARBOK
	dbw 79, DODUO
	dbw 80, RAPIDASH
	dbw 80, DODRIO
	dbw 82, URSARING
	; day
	dbw 78, TANGELA
	dbw 78, PONYTA
	dbw 79, ARBOK
	dbw 79, MILTANK
	dbw 80, RAPIDASH
	dbw 80, DODRIO
	dbw 82, URSARING
	; nite
	dbw 78, GOLBAT
	dbw 78, QUAGSIRE
	dbw 79, NOCTOWL
	dbw 79, MURKROW
	dbw 80, CROBAT
	dbw 80, HOUNDOOM
	dbw 82, URSARING

	db -1 ; end
