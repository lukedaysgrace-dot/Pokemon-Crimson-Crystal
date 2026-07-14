icon_pals: MACRO
; normal, shiny
	dn PAL_ICON_\1, PAL_ICON_\2
ENDM

MonMenuIconPals:
; entries correspond to pokemon constants (species indexes)
; colors from Pokemon Crystal Legacy for the original 251
	;         normal, shiny
	icon_pals TEAL,   GREEN  ; BULBASAUR
	icon_pals TEAL,   GREEN  ; IVYSAUR
	icon_pals TEAL,   GREEN  ; VENUSAUR
	icon_pals RED,    BROWN  ; CHARMANDER
	icon_pals RED,    BROWN  ; CHARMELEON
	icon_pals RED,    PURPLE ; CHARIZARD
	icon_pals BLUE,   TEAL   ; SQUIRTLE
	icon_pals BLUE,   TEAL   ; WARTORTLE
	icon_pals BLUE,   TEAL   ; BLASTOISE
	icon_pals GREEN,  BROWN  ; CATERPIE
	icon_pals GREEN,  BROWN  ; METAPOD
	icon_pals BLUE,   PINK   ; BUTTERFREE
	icon_pals BROWN,  TEAL   ; WEEDLE
	icon_pals BROWN,  GREEN  ; KAKUNA
	icon_pals BROWN,  GREEN  ; BEEDRILL
	icon_pals BROWN,  RED    ; PIDGEY
	icon_pals BROWN,  GREEN  ; PIDGEOTTO
	icon_pals BROWN,  RED    ; PIDGEOT
	icon_pals PURPLE, GRAY   ; RATTATA
	icon_pals BROWN,  RED    ; RATICATE
	icon_pals RED,    TEAL   ; SPEAROW
	icon_pals BROWN,  GRAY   ; FEAROW
	icon_pals PURPLE, GRAY   ; EKANS
	icon_pals PURPLE, GRAY   ; ARBOK
	icon_pals BROWN,  RED    ; PIKACHU
	icon_pals BROWN,  GRAY   ; RAICHU
	icon_pals BROWN,  GRAY   ; SANDSHREW
	icon_pals BROWN,  RED    ; SANDSLASH
	icon_pals BLUE,   PURPLE ; NIDORAN_F
	icon_pals BLUE,   PURPLE ; NIDORINA
	icon_pals BLUE,   GRAY   ; NIDOQUEEN
	icon_pals PURPLE, BLUE   ; NIDORAN_M
	icon_pals PURPLE, BLUE   ; NIDORINO
	icon_pals PURPLE, BLUE   ; NIDOKING
	icon_pals PINK,   GREEN  ; CLEFAIRY
	icon_pals PINK,   GREEN  ; CLEFABLE
	icon_pals RED,    BROWN  ; VULPIX
	icon_pals BROWN,  GRAY   ; NINETALES
	icon_pals PINK,   PURPLE ; JIGGLYPUFF
	icon_pals PINK,   PURPLE ; WIGGLYTUFF
	icon_pals BLUE,   GREEN  ; ZUBAT
	icon_pals BLUE,   GREEN  ; GOLBAT
	icon_pals GREEN,  BROWN  ; ODDISH
	icon_pals RED,    BROWN  ; GLOOM
	icon_pals RED,    BROWN  ; VILEPLUME
	icon_pals RED,    BROWN  ; PARAS
	icon_pals RED,    BROWN  ; PARASECT
	icon_pals PURPLE, BLUE   ; VENONAT
	icon_pals PURPLE, BLUE   ; VENOMOTH
	icon_pals BROWN,  BLUE   ; DIGLETT
	icon_pals BROWN,  BLUE   ; DUGTRIO
	icon_pals BROWN,  PINK   ; MEOWTH
	icon_pals BROWN,  PINK   ; PERSIAN
	icon_pals BROWN,  BLUE   ; PSYDUCK
	icon_pals BLUE,   PURPLE ; GOLDUCK
	icon_pals BROWN,  TEAL   ; MANKEY
	icon_pals BROWN,  TEAL   ; PRIMEAPE
	icon_pals RED,    BROWN  ; GROWLITHE
	icon_pals RED,    BROWN  ; ARCANINE
	icon_pals BLUE,   TEAL   ; POLIWAG
	icon_pals BLUE,   TEAL   ; POLIWHIRL
	icon_pals BLUE,   TEAL   ; POLIWRATH
	icon_pals BROWN,  PINK   ; ABRA
	icon_pals BROWN,  PINK   ; KADABRA
	icon_pals BROWN,  PINK   ; ALAKAZAM
	icon_pals GRAY,   TEAL   ; MACHOP
	icon_pals GRAY,   BLUE   ; MACHOKE
	icon_pals GRAY,   TEAL   ; MACHAMP
	icon_pals GREEN,  BROWN  ; BELLSPROUT
	icon_pals GREEN,  BROWN  ; WEEPINBELL
	icon_pals GREEN,  BROWN  ; VICTREEBEL
	icon_pals BLUE,   PURPLE ; TENTACOOL
	icon_pals BLUE,   GREEN  ; TENTACRUEL
	icon_pals GRAY,   BROWN  ; GEODUDE
	icon_pals GRAY,   RED    ; GRAVELER
	icon_pals GRAY,   RED    ; GOLEM
	icon_pals RED,    GRAY   ; PONYTA
	icon_pals RED,    PURPLE ; RAPIDASH
	icon_pals PINK,   PURPLE ; SLOWPOKE
	icon_pals PINK,   PURPLE ; SLOWBRO
	icon_pals GRAY,   TEAL   ; MAGNEMITE
	icon_pals GRAY,   TEAL   ; MAGNETON
	icon_pals BROWN,  GRAY   ; FARFETCH_D
	icon_pals BROWN,  RED    ; DODUO
	icon_pals BROWN,  RED    ; DODRIO
	icon_pals BLUE,   GRAY   ; SEEL
	icon_pals BLUE,   GRAY   ; DEWGONG
	icon_pals PURPLE, GREEN  ; GRIMER
	icon_pals PURPLE, GREEN  ; MUK
	icon_pals PURPLE, BROWN  ; SHELLDER
	icon_pals PURPLE, BLUE   ; CLOYSTER
	icon_pals PURPLE, BLUE   ; GASTLY
	icon_pals PURPLE, BLUE   ; HAUNTER
	icon_pals PURPLE, BLUE   ; GENGAR
	icon_pals GRAY,   GREEN  ; ONIX
	icon_pals BROWN,  PINK   ; DROWZEE
	icon_pals BROWN,  PINK   ; HYPNO
	icon_pals RED,    BROWN  ; KRABBY
	icon_pals RED,    GRAY   ; KINGLER
	icon_pals RED,    BLUE   ; VOLTORB
	icon_pals RED,    BLUE   ; ELECTRODE
	icon_pals PINK,   GREEN  ; EXEGGCUTE
	icon_pals GREEN,  BROWN  ; EXEGGUTOR
	icon_pals BROWN,  TEAL   ; CUBONE
	icon_pals BROWN,  TEAL   ; MAROWAK
	icon_pals BROWN,  GREEN  ; HITMONLEE
	icon_pals BROWN,  BLUE   ; HITMONCHAN
	icon_pals PINK,   TEAL   ; LICKITUNG
	icon_pals PURPLE, BLUE   ; KOFFING
	icon_pals PURPLE, BLUE   ; WEEZING
	icon_pals GRAY,   TEAL   ; RHYHORN
	icon_pals GRAY,   TEAL   ; RHYDON
	icon_pals PINK,   TEAL   ; CHANSEY
	icon_pals TEAL,   GREEN  ; TANGELA
	icon_pals BROWN,  GRAY   ; KANGASKHAN
	icon_pals BLUE,   PINK   ; HORSEA
	icon_pals BLUE,   PURPLE ; SEADRA
	icon_pals RED,    BROWN  ; GOLDEEN
	icon_pals RED,    BROWN  ; SEAKING
	icon_pals BROWN,  BLUE   ; STARYU
	icon_pals PURPLE, BLUE   ; STARMIE
	icon_pals PINK,   GRAY   ; MR__MIME
	icon_pals GREEN,  TEAL   ; SCYTHER
	icon_pals PURPLE, PINK   ; JYNX
	icon_pals BROWN,  GREEN  ; ELECTABUZZ
	icon_pals RED,    PINK   ; MAGMAR
	icon_pals BROWN,  BLUE   ; PINSIR
	icon_pals BROWN,  TEAL   ; TAUROS
	icon_pals RED,    BROWN  ; MAGIKARP
	icon_pals BLUE,   RED    ; GYARADOS
	icon_pals BLUE,   PINK   ; LAPRAS
	icon_pals PURPLE, BLUE   ; DITTO
	icon_pals BROWN,  GRAY   ; EEVEE
	icon_pals BLUE,   PINK   ; VAPOREON
	icon_pals BROWN,  TEAL   ; JOLTEON
	icon_pals RED,    BROWN  ; FLAREON
	icon_pals BLUE,   TEAL   ; PORYGON
	icon_pals BLUE,   GRAY   ; OMANYTE
	icon_pals BLUE,   GREEN  ; OMASTAR
	icon_pals BROWN,  GRAY   ; KABUTO
	icon_pals BROWN,  TEAL   ; KABUTOPS
	icon_pals GRAY,   PURPLE ; AERODACTYL
	icon_pals GRAY,   BLUE   ; SNORLAX
	icon_pals BLUE,   GRAY   ; ARTICUNO
	icon_pals BROWN,  RED    ; ZAPDOS
	icon_pals RED,    RED    ; MOLTRES
	icon_pals BLUE,   GRAY   ; DRATINI
	icon_pals BLUE,   PINK   ; DRAGONAIR
	icon_pals BROWN,  TEAL   ; DRAGONITE
	icon_pals PURPLE, TEAL   ; MEWTWO
	icon_pals PINK,   BLUE   ; MEW
	icon_pals GREEN,  BROWN  ; CHIKORITA
	icon_pals GREEN,  BROWN  ; BAYLEEF
	icon_pals GREEN,  BROWN  ; MEGANIUM
	icon_pals RED,    PINK   ; CYNDAQUIL
	icon_pals RED,    PINK   ; QUILAVA
	icon_pals RED,    PINK   ; TYPHLOSION
	icon_pals BLUE,   TEAL   ; TOTODILE
	icon_pals BLUE,   TEAL   ; CROCONAW
	icon_pals BLUE,   TEAL   ; FERALIGATR
	icon_pals BROWN,  PINK   ; SENTRET
	icon_pals BROWN,  PINK   ; FURRET
	icon_pals BROWN,  PINK   ; HOOTHOOT
	icon_pals BROWN,  GREEN  ; NOCTOWL
	icon_pals RED,    BROWN  ; LEDYBA
	icon_pals RED,    BROWN  ; LEDIAN
	icon_pals GREEN,  PURPLE ; SPINARAK
	icon_pals RED,    PURPLE ; ARIADOS
	icon_pals PURPLE, PINK   ; CROBAT
	icon_pals BLUE,   TEAL   ; CHINCHOU
	icon_pals BLUE,   PURPLE ; LANTURN
	icon_pals BROWN,  RED    ; PICHU
	icon_pals PINK,   GREEN  ; CLEFFA
	icon_pals PINK,   PURPLE ; IGGLYBUFF
	icon_pals RED,    BLUE   ; TOGEPI
	icon_pals RED,    BLUE   ; TOGETIC
	icon_pals GREEN,  TEAL   ; NATU
	icon_pals GREEN,  TEAL   ; XATU
	icon_pals BROWN,  PINK   ; MAREEP
	icon_pals PINK,   PURPLE ; FLAAFFY
	icon_pals BROWN,  BLUE   ; AMPHAROS
	icon_pals GREEN,  RED    ; BELLOSSOM
	icon_pals BLUE,   GREEN  ; MARILL
	icon_pals BLUE,   BROWN  ; AZUMARILL
	icon_pals GREEN,  RED    ; SUDOWOODO
	icon_pals GREEN,  PURPLE ; POLITOED
	icon_pals RED,    GREEN  ; HOPPIP
	icon_pals GREEN,  PURPLE ; SKIPLOOM
	icon_pals BLUE,   PINK   ; JUMPLUFF
	icon_pals PURPLE, PINK   ; AIPOM
	icon_pals GREEN,  GREEN  ; SUNKERN
	icon_pals GREEN,  BROWN  ; SUNFLORA
	icon_pals RED,    BLUE   ; YANMA
	icon_pals BLUE,   PINK   ; WOOPER
	icon_pals BLUE,   PINK   ; QUAGSIRE
	icon_pals PINK,   GREEN  ; ESPEON
	icon_pals BROWN,  BLUE   ; UMBREON
	icon_pals BLUE,   PINK   ; MURKROW
	icon_pals PINK,   BLUE   ; SLOWKING
	icon_pals PURPLE, BROWN  ; MISDREAVUS
	icon_pals BROWN,  BLUE   ; UNOWN
	icon_pals BLUE,   PINK   ; WOBBUFFET
	icon_pals PURPLE, BLUE   ; GIRAFARIG
	icon_pals TEAL,   RED    ; PINECO
	icon_pals PINK,   BROWN  ; FORRETRESS
	icon_pals BLUE,   PINK   ; DUNSPARCE
	icon_pals PURPLE, GRAY   ; GLIGAR
	icon_pals GRAY,   BROWN  ; STEELIX
	icon_pals PINK,   BLUE   ; SNUBBULL
	icon_pals PINK,   GRAY   ; GRANBULL
	icon_pals BLUE,   PINK   ; QWILFISH
	icon_pals RED,    GREEN  ; SCIZOR
	icon_pals RED,    PURPLE ; SHUCKLE
	icon_pals BLUE,   PURPLE ; HERACROSS
	icon_pals RED,    PINK   ; SNEASEL
	icon_pals BROWN,  GREEN  ; TEDDIURSA
	icon_pals BROWN,  GREEN  ; URSARING
	icon_pals RED,    GRAY   ; SLUGMA
	icon_pals RED,    BLUE   ; MAGCARGO
	icon_pals BROWN,  BLUE   ; SWINUB
	icon_pals BROWN,  GREEN  ; PILOSWINE
	icon_pals PINK,   TEAL   ; CORSOLA
	icon_pals BLUE,   GRAY   ; REMORAID
	icon_pals RED,    BROWN  ; OCTILLERY
	icon_pals RED,    PINK   ; DELIBIRD
	icon_pals BLUE,   TEAL   ; MANTINE
	icon_pals RED,    GREEN  ; SKARMORY
	icon_pals RED,    BLUE   ; HOUNDOUR
	icon_pals RED,    BLUE   ; HOUNDOOM
	icon_pals BLUE,   PURPLE ; KINGDRA
	icon_pals BLUE,   TEAL   ; PHANPY
	icon_pals GRAY,   BROWN  ; DONPHAN
	icon_pals BLUE,   TEAL   ; PORYGON2
	icon_pals BROWN,  GREEN  ; STANTLER
	icon_pals BROWN,  GREEN  ; SMEARGLE
	icon_pals BROWN,  BLUE   ; TYROGUE
	icon_pals BROWN,  PURPLE ; HITMONTOP
	icon_pals PURPLE, PINK   ; SMOOCHUM
	icon_pals BROWN,  RED    ; ELEKID
	icon_pals RED,    BROWN  ; MAGBY
	icon_pals PINK,   BLUE   ; MILTANK
	icon_pals RED,    PINK   ; BLISSEY
	icon_pals BROWN,  RED    ; RAIKOU
	icon_pals RED,    BROWN  ; ENTEI
	icon_pals BLUE,   GRAY   ; SUICUNE
	icon_pals GREEN,  TEAL   ; LARVITAR
	icon_pals BLUE,   PURPLE ; PUPITAR
	icon_pals GREEN,  BROWN  ; TYRANITAR
	icon_pals BLUE,   TEAL   ; LUGIA
	icon_pals RED,    BROWN  ; HO_OH
	icon_pals GREEN,  PINK   ; CELEBI
; new species
	icon_pals BLUE,   PINK   ; HONCHKROW
	icon_pals PURPLE, PINK   ; AMBIPOM
	icon_pals GRAY,   GREEN  ; ANNIHILAPE
	icon_pals BLUE,   GREEN  ; BAGON
	icon_pals BLUE,   PINK   ; DRUNSPARCE
	icon_pals BROWN,  GREEN  ; ELECTIVIRE
	icon_pals PURPLE, BLUE   ; FARIGIRAF
	icon_pals GREEN,  BLUE   ; GARDEVOIR
	icon_pals BLUE,   TEAL   ; GLACEON
	icon_pals PURPLE, BLUE   ; GLISCOR
	icon_pals GREEN,  BLUE   ; KIRLIA
	icon_pals GREEN,  BROWN  ; LEAFEON
	icon_pals PINK,   TEAL   ; LICKILICKY
	icon_pals RED,    PINK   ; MAGMORTAR
	icon_pals GRAY,   TEAL   ; MAGNEZONE
	icon_pals BROWN,  BLUE   ; MAMOSWINE
	icon_pals PURPLE, PINK   ; MESMERIA
	icon_pals PURPLE, BROWN  ; MISMAGIUS
	icon_pals RED,    BLUE   ; PORYGON_Z
	icon_pals GREEN,  BLUE   ; RALTS
	icon_pals GRAY,   TEAL   ; RHYPERIOR
	icon_pals BLUE,   GREEN  ; SALAMENCE
	icon_pals PURPLE, RED    ; SCOLIPEDE
	icon_pals GRAY,   GREEN  ; SHELGON
	icon_pals TEAL,   GREEN  ; TANGROWTH
	icon_pals RED,    BLUE   ; TOGEKISS
	icon_pals BROWN,  RED    ; URSALUNA
	icon_pals PURPLE, RED    ; VENIPEDE
	icon_pals GRAY,   PINK   ; WEAVILE
	icon_pals PURPLE, RED    ; WHIRLIPEDE
	icon_pals BROWN,  GREEN  ; WYRDEER
	icon_pals GREEN,  BLUE   ; YANMEGA
	icon_pals PURPLE, PINK   ; LILEEP
	icon_pals GREEN,  PINK   ; CRADILY
	icon_pals GRAY,   BLUE   ; ARMALDO
	icon_pals TEAL,   GREEN  ; GOLETT
	icon_pals TEAL,   GREEN  ; GOLURK
	icon_pals GRAY,   RED    ; DUSKULL
	icon_pals GRAY,   RED    ; DUSCLOPS
	icon_pals GRAY,   RED    ; DUSKNOIR
	icon_pals GRAY,   RED    ; TIMBURR
	icon_pals GRAY,   RED    ; GURDURR
	icon_pals BROWN,  RED    ; CONKELDURR
	icon_pals RED,    BROWN  ; LARVESTA
	icon_pals RED,    BROWN  ; VOLCARONA
	icon_pals BLUE,   GREEN  ; DEINO
	icon_pals BLUE,   GREEN  ; ZWEILOUS
	icon_pals BLUE,   GREEN  ; HYDREIGON
	icon_pals TEAL,   RED    ; DREEPY
	icon_pals TEAL,   RED    ; DRAKLOAK
	icon_pals TEAL,   RED    ; DRAGAPULT
	icon_pals PINK,   GRAY   ; IMPIDIMP
	icon_pals PINK,   GRAY   ; MORGREM
	icon_pals PURPLE, GRAY   ; GRIMMSNARL
	icon_pals PINK,   GREEN  ; TINKATINK
	icon_pals PINK,   GREEN  ; TINKATUFF
	icon_pals PINK,   GRAY   ; TINKATON
	icon_pals GRAY,   BLUE   ; FRIGIBAX
	icon_pals BLUE,   GRAY   ; ARCTIBAX
	icon_pals BLUE,   GRAY   ; BAXCALIBUR
	icon_pals RED,    BLUE   ; CHARCADET
	icon_pals RED,    PURPLE ; ARMAROUGE
	icon_pals BLUE,   PURPLE ; CERULEDGE
	icon_pals PINK,   BLUE   ; SYLVEON
	icon_pals BLUE,   GRAY   ; ROOKIDEE
	icon_pals BLUE,   GRAY   ; CORVISQUIRE
	icon_pals BLUE,   RED    ; CORVIKNIGHT
	icon_pals BROWN , BLUE   ; ABOMASNOW
	icon_pals BLUE  , GREEN  ; ALTARIA
	icon_pals GRAY  , BLUE   ; ANORITH
	icon_pals GREEN , RED    ; APPLETUN
	icon_pals GREEN , RED    ; APPLIN
	icon_pals GRAY  , BLUE   ; ARCHALUDON
	icon_pals GREEN , RED    ; BRELOOM
	icon_pals BROWN , PINK   ; BUNEARY
	icon_pals RED   , BROWN  ; CAMERUPT
	icon_pals RED   , BROWN  ; CENTISKORCH
	icon_pals GREEN , BROWN ; CHARJABUG
	icon_pals BLUE  , PURPLE ; CROAGUNK
	icon_pals GREEN , RED    ; DIPPLIN
	icon_pals PURPLE, GRAY   ; DRIFBLIM
	icon_pals PURPLE, GRAY   ; DRIFLOON
	icon_pals BROWN , GRAY   ; DRILBUR
	icon_pals GRAY  , BLUE   ; DURALUDON
	icon_pals GREEN , BROWN ; ELECTRIKE
	icon_pals BROWN , GRAY   ; EXCADRILL
	icon_pals GREEN , RED    ; FLAPPLE
	icon_pals RED   , GRAY   ; FLETCHINDER
	icon_pals RED   , GRAY   ; FLETCHLING
	icon_pals GREEN , RED    ; FLYGON
	icon_pals BLUE  , RED    ; FROSLASS
	icon_pals GRAY  , BLUE   ; GOLISOPOD
	icon_pals GREEN , BROWN  ; GRUBBIN
	icon_pals PURPLE, GRAY   ; GRUMPIG
	icon_pals GREEN , RED    ; HYDRAPPLE
	icon_pals GRAY  , RED    ; KINGAMBIT
	icon_pals GREEN , BLUE   ; LOMBRE
	icon_pals BROWN , PINK   ; LOPUNNY
	icon_pals GREEN , BLUE   ; LOTAD
	icon_pals GREEN , BLUE   ; LUDICOLO
	icon_pals BROWN, BLUE   ; MANECTRIC
	icon_pals BROWN , RED    ; NUMEL
	icon_pals PURPLE, GRAY   ; OVERQWIL
	icon_pals BROWN, RED    ; SCRAFTY
	icon_pals BROWN, RED    ; SCRAGGY
	icon_pals BLUE  , GRAY   ; SEALEO
	icon_pals GREEN , BROWN  ; SHROOMISH
	icon_pals RED   , BROWN  ; SIZZLIPEDE
	icon_pals BLUE  , GRAY   ; SNORUNT
	icon_pals GREEN , BLUE   ; SNOVER
	icon_pals BLUE  , GRAY   ; SPHEAL
	icon_pals GRAY  , PINK   ; SPOINK
	icon_pals BLUE  , GRAY   ; SWABLU
	icon_pals RED   , GRAY   ; TALONFLAME
	icon_pals BLUE  , PURPLE ; TOXICROAK
	icon_pals BROWN , RED    ; TRAPINCH
	icon_pals BROWN , RED    ; URSALUNABM
	icon_pals GREEN , RED    ; VIBRAVA
	icon_pals BROWN, BLUE   ; VIKAVOLT
	icon_pals BLUE  , GRAY   ; WALREIN
	icon_pals GRAY  , BLUE   ; WIMPOD
	icon_pals BROWN,  GREEN  ; TEDDIURSABM
	icon_pals BROWN,  GREEN  ; URSARINGBM
	icon_pals GREEN,  GRAY   ; AXEW
	icon_pals GREEN,  GRAY   ; FRAXURE
	icon_pals GREEN,  GRAY   ; HAXORUS
	icon_pals GRAY,   BROWN  ; CRANIDOS
	icon_pals GRAY,   BROWN  ; RAMPARDOS
	icon_pals GRAY,   BLUE   ; SHIELDON
	icon_pals GRAY,   BLUE   ; BASTIODON
	icon_pals RED,    GRAY   ; PAWNIARD
	icon_pals RED,    GRAY   ; BISHARP
	icon_pals BLUE,   TEAL   ; CETODDLE
	icon_pals BLUE,   TEAL   ; CETITAN
	icon_pals BROWN,  BLUE   ; FEEBAS
	icon_pals BLUE,   PINK   ; MILOTIC
	icon_pals BROWN,  GRAY   ; MIMIKYU
	icon_pals GRAY,   PINK   ; CURSOLA
	icon_pals GREEN,  GRAY   ; GALLADE
	icon_pals BLUE,   PINK   ; MR__RIME
	icon_pals BROWN,  GREEN  ; SIRFETCH_D
	icon_pals BLUE,   GRAY   ; RIOLU
	icon_pals BLUE,   GRAY   ; LUCARIO
	icon_pals BROWN,  GRAY   ; TYRUNT
	icon_pals RED,    GRAY   ; TYRANTRUM
	icon_pals BLUE,   GRAY   ; AMAURA
	icon_pals BLUE,   GRAY   ; AURORUS
	icon_pals BLUE,   BROWN  ; MUNCHLAX
	icon_pals BROWN,  GREEN  ; ORSTRYX
	icon_pals GRAY  , GRAY   ; RATTATA_ALOLAN
	icon_pals BROWN , BROWN  ; RATICATE_ALOLAN
	icon_pals RED   , RED    ; RAICHU_ALOLAN
	icon_pals GRAY  , GRAY   ; SANDSHREW_ALOLAN
	icon_pals TEAL  , TEAL   ; SANDSLASH_ALOLAN
	icon_pals GRAY  , GRAY   ; VULPIX_ALOLAN
	icon_pals GRAY  , GRAY   ; NINETALES_ALOLAN
	icon_pals GRAY  , GRAY   ; DIGLETT_ALOLAN
	icon_pals GRAY  , GRAY   ; DUGTRIO_ALOLAN
	icon_pals GRAY  , GRAY   ; MEOWTH_ALOLAN
	icon_pals GRAY  , GRAY   ; PERSIAN_ALOLAN
	icon_pals GRAY  , GRAY   ; GEODUDE_ALOLAN
	icon_pals GRAY  , GRAY   ; GRAVELER_ALOLAN
	icon_pals GRAY  , GRAY   ; GOLEM_ALOLAN
	icon_pals GRAY  , GRAY   ; GRIMER_ALOLAN
	icon_pals GRAY  , GRAY   ; MUK_ALOLAN
	icon_pals GREEN , GREEN  ; EXEGGUTOR_ALOLAN
	icon_pals BROWN , BROWN  ; MAROWAK_ALOLAN
	icon_pals BROWN , BROWN  ; MEOWTH_GALARIAN
	icon_pals PINK  , PINK   ; PERRSERKER
	icon_pals BLUE  , BLUE   ; PONYTA_GALARIAN
	icon_pals BLUE  , BLUE   ; RAPIDASH_GALARIAN
	icon_pals PINK  , PINK   ; SLOWPOKE_GALARIAN
	icon_pals GRAY  , GRAY   ; SLOWBRO_GALARIAN
	icon_pals GRAY  , GRAY   ; WEEZING_GALARIAN
	icon_pals GRAY  , GRAY   ; SLOWKING_GALARIAN
	icon_pals GRAY  , GRAY   ; CORSOLA_GALARIAN
	icon_pals BROWN , BROWN  ; GROWLITHE_HISUIAN
	icon_pals GRAY  , GRAY   ; ARCANINE_HISUIAN
	icon_pals RED   , RED    ; VOLTORB_HISUIAN
	icon_pals RED   , RED    ; ELECTRODE_HISUIAN
	icon_pals PINK  , PINK   ; TYPHLOSION_HISUIAN
	icon_pals GRAY  , GRAY   ; SNEASEL_HISUIAN
	icon_pals GRAY  , GRAY   ; WOOPER_PALDEAN
	icon_pals BROWN , BROWN  ; CLODSIRE
	icon_pals GRAY  , GRAY   ; TAUROS_PALDEAN_FIRE
	icon_pals GRAY  , GRAY   ; TAUROS_PALDEAN_WATER
	icon_pals GRAY  , GRAY   ; SNEASLER
	icon_pals GREEN,  TEAL   ; WATU
	icon_pals GREEN,  BROWN   ; BOUNSWEET
	icon_pals GREEN,  BROWN   ; STEENEE
	icon_pals GREEN,  PURPLE   ; TSAREENA
	icon_pals GRAY,   BLUE   ; ARON
	icon_pals GRAY,   BLUE   ; LAIRON
	icon_pals GRAY,   BLUE   ; AGGRON
	icon_pals BROWN,  GREEN   ; KLEAVOR
	icon_pals BLUE,   PURPLE   ; GLIMMET
	icon_pals BLUE,   PURPLE   ; MAREANIE
	icon_pals BLUE,   PURPLE   ; TOXAPEX
	icon_pals GRAY,   RED   ; ZANGOOSE
	icon_pals PURPLE, GREEN   ; SEVIPER
	icon_pals BLUE,   PURPLE   ; GLIMMORA
	icon_pals TEAL, TEAL ; BULBASAUR_CLONE
	icon_pals TEAL, TEAL ; IVYSAUR_CLONE
	icon_pals TEAL, TEAL ; VENUSAUR_CLONE
	icon_pals RED, RED ; CHARMANDER_CLONE
	icon_pals RED, RED ; CHARMELEON_CLONE
	icon_pals RED, RED ; CHARIZARD_CLONE
	icon_pals BLUE, BLUE ; SQUIRTLE_CLONE
	icon_pals BLUE, BLUE ; WARTORTLE_CLONE
	icon_pals BLUE, BLUE ; BLASTOISE_CLONE
