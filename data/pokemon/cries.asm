mon_cry: MACRO
; index, pitch, length
	dw \1, \2, \3
ENDM

PokemonCries::
; entries correspond to constants/pokemon_constants.asm
	mon_cry CRY_BULBASAUR,   $080,  $081 ; BULBASAUR
	mon_cry CRY_BULBASAUR,   $020,  $100 ; IVYSAUR
	mon_cry CRY_BULBASAUR,   $000,  $140 ; VENUSAUR
	mon_cry CRY_CHARMANDER,  $060,  $0c0 ; CHARMANDER
	mon_cry CRY_CHARMANDER,  $020,  $0c0 ; CHARMELEON
	mon_cry CRY_CHARMANDER,  $000,  $100 ; CHARIZARD
	mon_cry CRY_SQUIRTLE,    $060,  $0c0 ; SQUIRTLE
	mon_cry CRY_SQUIRTLE,    $020,  $0c0 ; WARTORTLE
	mon_cry CRY_BLASTOISE,   $000,  $100 ; BLASTOISE
	mon_cry CRY_CATERPIE,    $080,  $0a0 ; CATERPIE
	mon_cry CRY_METAPOD,     $0cc,  $081 ; METAPOD
	mon_cry CRY_CATERPIE,    $077,  $0c0 ; BUTTERFREE
	mon_cry CRY_WEEDLE,      $0ee,  $081 ; WEEDLE
	mon_cry CRY_BLASTOISE,   $0ff,  $081 ; KAKUNA
	mon_cry CRY_BLASTOISE,   $060,  $100 ; BEEDRILL
	mon_cry CRY_PIDGEY,      $0df,  $084 ; PIDGEY
	mon_cry CRY_PIDGEOTTO,   $028,  $140 ; PIDGEOTTO
	mon_cry CRY_PIDGEOTTO,   $011,  $17f ; PIDGEOT
	mon_cry CRY_RATTATA,     $000,  $100 ; RATTATA
	mon_cry CRY_RATTATA,     $020,  $17f ; RATICATE
	mon_cry CRY_SPEAROW,     $000,  $100 ; SPEAROW
	mon_cry CRY_FEAROW,      $040,  $120 ; FEAROW
	mon_cry CRY_EKANS,       $012,  $0c0 ; EKANS
	mon_cry CRY_EKANS,       $0e0,  $090 ; ARBOK
	mon_cry CRY_BULBASAUR,   $0ee,  $081 ; PIKACHU
	mon_cry CRY_RAICHU,      $0ee,  $088 ; RAICHU
	mon_cry CRY_NIDORAN_M,   $020,  $0c0 ; SANDSHREW
	mon_cry CRY_NIDORAN_M,   $0ff,  $17f ; SANDSLASH
	mon_cry CRY_NIDORAN_F,   $000,  $100 ; NIDORAN_F
	mon_cry CRY_NIDORAN_F,   $02c,  $160 ; NIDORINA
	mon_cry CRY_NIDOQUEEN,   $000,  $100 ; NIDOQUEEN
	mon_cry CRY_NIDORAN_M,   $000,  $100 ; NIDORAN_M
	mon_cry CRY_NIDORAN_M,   $02c,  $140 ; NIDORINO
	mon_cry CRY_RAICHU,      $000,  $100 ; NIDOKING
	mon_cry CRY_CLEFAIRY,    $0cc,  $081 ; CLEFAIRY
	mon_cry CRY_CLEFAIRY,    $0aa,  $0a0 ; CLEFABLE
	mon_cry CRY_VULPIX,      $04f,  $090 ; VULPIX
	mon_cry CRY_VULPIX,      $088,  $0e0 ; NINETALES
	mon_cry CRY_PIDGEY,      $0ff,  $0b5 ; JIGGLYPUFF
	mon_cry CRY_PIDGEY,      $068,  $0e0 ; WIGGLYTUFF
	mon_cry CRY_SQUIRTLE,    $0e0,  $100 ; ZUBAT
	mon_cry CRY_SQUIRTLE,    $0fa,  $100 ; GOLBAT
	mon_cry CRY_ODDISH,      $0dd,  $081 ; ODDISH
	mon_cry CRY_ODDISH,      $0aa,  $0c0 ; GLOOM
	mon_cry CRY_VILEPLUME,   $022,  $17f ; VILEPLUME
	mon_cry CRY_PARAS,       $020,  $160 ; PARAS
	mon_cry CRY_PARAS,       $042,  $17f ; PARASECT
	mon_cry CRY_VENONAT,     $044,  $0c0 ; VENONAT
	mon_cry CRY_VENONAT,     $029,  $100 ; VENOMOTH
	mon_cry CRY_DIGLETT,     $0aa,  $081 ; DIGLETT
	mon_cry CRY_DIGLETT,     $02a,  $090 ; DUGTRIO
	mon_cry CRY_CLEFAIRY,    $077,  $090 ; MEOWTH
	mon_cry CRY_CLEFAIRY,    $099,  $17f ; PERSIAN
	mon_cry CRY_PSYDUCK,     $020,  $0e0 ; PSYDUCK
	mon_cry CRY_PSYDUCK,     $0ff,  $0c0 ; GOLDUCK
	mon_cry CRY_NIDOQUEEN,   $0dd,  $0e0 ; MANKEY
	mon_cry CRY_NIDOQUEEN,   $0af,  $0c0 ; PRIMEAPE
	mon_cry CRY_GROWLITHE,   $020,  $0c0 ; GROWLITHE
	mon_cry CRY_WEEDLE,      $000,  $100 ; ARCANINE
	mon_cry CRY_PIDGEY,      $0ff,  $17f ; POLIWAG
	mon_cry CRY_PIDGEY,      $077,  $0e0 ; POLIWHIRL
	mon_cry CRY_PIDGEY,      $000,  $17f ; POLIWRATH
	mon_cry CRY_METAPOD,     $0c0,  $081 ; ABRA
	mon_cry CRY_METAPOD,     $0a8,  $140 ; KADABRA
	mon_cry CRY_METAPOD,     $098,  $17f ; ALAKAZAM
	mon_cry CRY_GROWLITHE,   $0ee,  $081 ; MACHOP
	mon_cry CRY_GROWLITHE,   $048,  $0e0 ; MACHOKE
	mon_cry CRY_GROWLITHE,   $008,  $140 ; MACHAMP
	mon_cry CRY_PSYDUCK,     $055,  $081 ; BELLSPROUT
	mon_cry CRY_WEEPINBELL,  $044,  $0a0 ; WEEPINBELL
	mon_cry CRY_WEEPINBELL,  $066,  $14c ; VICTREEBEL
	mon_cry CRY_VENONAT,     $000,  $100 ; TENTACOOL
	mon_cry CRY_VENONAT,     $0ee,  $17f ; TENTACRUEL
	mon_cry CRY_VULPIX,      $0f0,  $090 ; GEODUDE
	mon_cry CRY_VULPIX,      $000,  $100 ; GRAVELER
	mon_cry CRY_GOLEM,       $0e0,  $0c0 ; GOLEM
	mon_cry CRY_WEEPINBELL,  $000,  $100 ; PONYTA
	mon_cry CRY_WEEPINBELL,  $020,  $140 ; RAPIDASH
	mon_cry CRY_SLOWPOKE,    $000,  $100 ; SLOWPOKE
	mon_cry CRY_GROWLITHE,   $000,  $100 ; SLOWBRO
	mon_cry CRY_METAPOD,     $080,  $0e0 ; MAGNEMITE
	mon_cry CRY_METAPOD,     $020,  $140 ; MAGNETON
	mon_cry CRY_SPEAROW,     $0dd,  $081 ; FARFETCH_D
	mon_cry CRY_DIGLETT,     $0bb,  $081 ; DODUO
	mon_cry CRY_DIGLETT,     $099,  $0a0 ; DODRIO
	mon_cry CRY_SEEL,        $088,  $140 ; SEEL
	mon_cry CRY_SEEL,        $023,  $17f ; DEWGONG
	mon_cry CRY_GRIMER,      $000,  $100 ; GRIMER
	mon_cry CRY_MUK,         $0ef,  $17f ; MUK
	mon_cry CRY_FEAROW,      $000,  $100 ; SHELLDER
	mon_cry CRY_FEAROW,      $06f,  $160 ; CLOYSTER
	mon_cry CRY_METAPOD,     $000,  $100 ; GASTLY
	mon_cry CRY_METAPOD,     $030,  $0c0 ; HAUNTER
	mon_cry CRY_MUK,         $000,  $17f ; GENGAR
	mon_cry CRY_EKANS,       $0ff,  $140 ; ONIX
	mon_cry CRY_EXEGGUTOR,   $088,  $0a0 ; DROWZEE
	mon_cry CRY_EXEGGUTOR,   $0ee,  $0c0 ; HYPNO
	mon_cry CRY_KRABBY,      $020,  $160 ; KRABBY
	mon_cry CRY_KRABBY,      $0ee,  $160 ; KINGLER
	mon_cry CRY_VOLTORB,     $0ed,  $100 ; VOLTORB
	mon_cry CRY_VOLTORB,     $0a8,  $110 ; ELECTRODE
	mon_cry CRY_DIGLETT,     $000,  $100 ; EXEGGCUTE
	mon_cry CRY_EXEGGUTOR,   $000,  $100 ; EXEGGUTOR
	mon_cry CRY_CLEFAIRY,    $000,  $100 ; CUBONE
	mon_cry CRY_ODDISH,      $04f,  $0e0 ; MAROWAK
	mon_cry CRY_GOLEM,       $080,  $140 ; HITMONLEE
	mon_cry CRY_SEEL,        $0ee,  $140 ; HITMONCHAN
	mon_cry CRY_SEEL,        $000,  $100 ; LICKITUNG
	mon_cry CRY_GOLEM,       $0e6,  $15d ; KOFFING
	mon_cry CRY_GOLEM,       $0ff,  $17f ; WEEZING
	mon_cry CRY_CHARMANDER,  $000,  $100 ; RHYHORN
	mon_cry CRY_RHYDON,      $000,  $100 ; RHYDON
	mon_cry CRY_PIDGEOTTO,   $00a,  $140 ; CHANSEY
	mon_cry CRY_GOLEM,       $000,  $100 ; TANGELA
	mon_cry CRY_KANGASKHAN,  $000,  $100 ; KANGASKHAN
	mon_cry CRY_CLEFAIRY,    $099,  $090 ; HORSEA
	mon_cry CRY_CLEFAIRY,    $03c,  $081 ; SEADRA
	mon_cry CRY_CATERPIE,    $080,  $0c0 ; GOLDEEN
	mon_cry CRY_CATERPIE,    $010,  $17f ; SEAKING
	mon_cry CRY_PARAS,       $002,  $0a0 ; STARYU
	mon_cry CRY_PARAS,       $000,  $100 ; STARMIE
	mon_cry CRY_KRABBY,      $008,  $0c0 ; MR__MIME
	mon_cry CRY_CATERPIE,    $000,  $100 ; SCYTHER
	mon_cry CRY_DROWZEE,     $0ff,  $17f ; JYNX
	mon_cry CRY_VOLTORB,     $08f,  $17f ; ELECTABUZZ
	mon_cry CRY_CHARMANDER,  $0ff,  $0b0 ; MAGMAR
	mon_cry CRY_PIDGEOTTO,   $000,  $100 ; PINSIR
	mon_cry CRY_SQUIRTLE,    $011,  $0c0 ; TAUROS
	mon_cry CRY_EKANS,       $080,  $080 ; MAGIKARP
	mon_cry CRY_EKANS,       $000,  $100 ; GYARADOS
	mon_cry CRY_LAPRAS,      $000,  $100 ; LAPRAS
	mon_cry CRY_PIDGEY,      $0ff,  $17f ; DITTO
	mon_cry CRY_VENONAT,     $088,  $0e0 ; EEVEE
	mon_cry CRY_VENONAT,     $0aa,  $17f ; VAPOREON
	mon_cry CRY_VENONAT,     $03d,  $100 ; JOLTEON
	mon_cry CRY_VENONAT,     $010,  $0a0 ; FLAREON
	mon_cry CRY_WEEPINBELL,  $0aa,  $17f ; PORYGON
	mon_cry CRY_GROWLITHE,   $0f0,  $081 ; OMANYTE
	mon_cry CRY_GROWLITHE,   $0ff,  $0c0 ; OMASTAR
	mon_cry CRY_CATERPIE,    $0bb,  $0c0 ; KABUTO
	mon_cry CRY_FEAROW,      $0ee,  $081 ; KABUTOPS
	mon_cry CRY_VILEPLUME,   $020,  $170 ; AERODACTYL
	mon_cry CRY_GRIMER,      $055,  $081 ; SNORLAX
	mon_cry CRY_RAICHU,      $080,  $0c0 ; ARTICUNO
	mon_cry CRY_FEAROW,      $0ff,  $100 ; ZAPDOS
	mon_cry CRY_RAICHU,      $0f8,  $0c0 ; MOLTRES
	mon_cry CRY_BULBASAUR,   $060,  $0c0 ; DRATINI
	mon_cry CRY_BULBASAUR,   $040,  $100 ; DRAGONAIR
	mon_cry CRY_BULBASAUR,   $03c,  $140 ; DRAGONITE
	mon_cry CRY_PARAS,       $099,  $17f ; MEWTWO
	mon_cry CRY_PARAS,       $0ee,  $17f ; MEW
	mon_cry CRY_CHIKORITA,  -$010,  $0b0 ; CHIKORITA
	mon_cry CRY_CHIKORITA,  -$022,  $120 ; BAYLEEF
	mon_cry CRY_CHIKORITA,  -$0b7,  $200 ; MEGANIUM
	mon_cry CRY_CYNDAQUIL,   $347,  $080 ; CYNDAQUIL
	mon_cry CRY_CYNDAQUIL,   $321,  $120 ; QUILAVA
	mon_cry CRY_TYPHLOSION,  $f00,  $0d4 ; TYPHLOSION
	mon_cry CRY_TOTODILE,    $46c,  $0e8 ; TOTODILE
	mon_cry CRY_TOTODILE,    $440,  $110 ; CROCONAW
	mon_cry CRY_TOTODILE,    $3fc,  $180 ; FERALIGATR
	mon_cry CRY_SENTRET,     $08a,  $0b8 ; SENTRET
	mon_cry CRY_SENTRET,     $06b,  $102 ; FURRET
	mon_cry CRY_HOOTHOOT,    $091,  $0d8 ; HOOTHOOT
	mon_cry CRY_HOOTHOOT,    $000,  $1a0 ; NOCTOWL
	mon_cry CRY_LEDYBA,      $000,  $0de ; LEDYBA
	mon_cry CRY_LEDYBA,     -$096,  $138 ; LEDIAN
	mon_cry CRY_SPINARAK,    $011,  $200 ; SPINARAK
	mon_cry CRY_SPINARAK,   -$0ae,  $1e2 ; ARIADOS
	mon_cry CRY_SQUIRTLE,   -$010,  $140 ; CROBAT
	mon_cry CRY_CYNDAQUIL,   $3c9,  $140 ; CHINCHOU
	mon_cry CRY_CYNDAQUIL,   $2d0,  $110 ; LANTURN
	mon_cry CRY_PICHU,       $000,  $140 ; PICHU
	mon_cry CRY_CLEFFA,      $061,  $091 ; CLEFFA
	mon_cry CRY_CHIKORITA,   $0e8,  $0e8 ; IGGLYBUFF
	mon_cry CRY_TOGEPI,      $010,  $100 ; TOGEPI
	mon_cry CRY_TOGETIC,     $03b,  $038 ; TOGETIC
	mon_cry CRY_NATU,       -$067,  $100 ; NATU
	mon_cry CRY_NATU,       -$0a7,  $168 ; XATU
	mon_cry CRY_MAREEP,      $022,  $0d8 ; MAREEP
	mon_cry CRY_MAREEP,     -$007,  $180 ; FLAAFFY
	mon_cry CRY_AMPHAROS,   -$07c,  $0e8 ; AMPHAROS
	mon_cry CRY_CLEFFA,      $084,  $150 ; BELLOSSOM
	mon_cry CRY_MARILL,      $11b,  $120 ; MARILL
	mon_cry CRY_MARILL,      $0b6,  $180 ; AZUMARILL
	mon_cry CRY_CLEFFA,      $f40,  $180 ; SUDOWOODO
	mon_cry CRY_CLEFFA,     -$2a3,  $1c8 ; POLITOED
	mon_cry CRY_CLEFFA,      $03b,  $0c8 ; HOPPIP
	mon_cry CRY_CLEFFA,      $027,  $138 ; SKIPLOOM
	mon_cry CRY_CLEFFA,      $000,  $180 ; JUMPLUFF
	mon_cry CRY_AIPOM,      -$051,  $0e8 ; AIPOM
	mon_cry CRY_MARILL,      $12b,  $0b8 ; SUNKERN
	mon_cry CRY_SUNFLORA,   -$020,  $180 ; SUNFLORA
	mon_cry CRY_TOTODILE,    $031,  $0c8 ; YANMA
	mon_cry CRY_WOOPER,      $093,  $0af ; WOOPER
	mon_cry CRY_WOOPER,     -$0c6,  $140 ; QUAGSIRE
	mon_cry CRY_ESPEON,      $0a2,  $140 ; ESPEON
	mon_cry CRY_VENONAT,    -$0e9,  $0f0 ; UMBREON
	mon_cry CRY_MARILL,     -$01f,  $180 ; MURKROW
	mon_cry CRY_SLOWKING,    $104,  $200 ; SLOWKING
	mon_cry CRY_HOOTHOOT,    $130,  $0e8 ; MISDREAVUS
	mon_cry CRY_HOOTHOOT,    $162,  $100 ; UNOWN
	mon_cry CRY_AMPHAROS,    $27b,  $144 ; WOBBUFFET
	mon_cry CRY_GIRAFARIG,   $041,  $200 ; GIRAFARIG
	mon_cry CRY_SLOWKING,    $080,  $100 ; PINECO
	mon_cry CRY_SLOWKING,    $000,  $180 ; FORRETRESS
	mon_cry CRY_DUNSPARCE,   $1c4,  $100 ; DUNSPARCE
	mon_cry CRY_GLIGAR,     -$102,  $100 ; GLIGAR
	mon_cry CRY_TYPHLOSION,  $0ef,  $0f7 ; STEELIX
	mon_cry CRY_DUNSPARCE,   $112,  $0e8 ; SNUBBULL
	mon_cry CRY_DUNSPARCE,   $000,  $180 ; GRANBULL
	mon_cry CRY_SLOWKING,    $160,  $0e0 ; QWILFISH
	mon_cry CRY_AMPHAROS,    $000,  $160 ; SCIZOR
	mon_cry CRY_DUNSPARCE,   $290,  $0a8 ; SHUCKLE
	mon_cry CRY_AMPHAROS,    $035,  $0e0 ; HERACROSS
	mon_cry CRY_WOOPER,      $053,  $0af ; SNEASEL
	mon_cry CRY_TEDDIURSA,   $7a2,  $06e ; TEDDIURSA
	mon_cry CRY_TEDDIURSA,   $640,  $0d8 ; URSARING
	mon_cry CRY_SLUGMA,     -$1d8,  $140 ; SLUGMA
	mon_cry CRY_MAGCARGO,   -$20d,  $1c0 ; MAGCARGO
	mon_cry CRY_CYNDAQUIL,   $1fe,  $140 ; SWINUB
	mon_cry CRY_MAGCARGO,   -$109,  $100 ; PILOSWINE
	mon_cry CRY_MAGCARGO,    $0a1,  $0e8 ; CORSOLA
	mon_cry CRY_SUNFLORA,    $00d,  $100 ; REMORAID
	mon_cry CRY_TOTODILE,    $000,  $180 ; OCTILLERY
	mon_cry CRY_TEDDIURSA,   $002,  $06a ; DELIBIRD
	mon_cry CRY_MANTINE,    -$0be,  $0f0 ; MANTINE
	mon_cry CRY_AMPHAROS,    $8a9,  $180 ; SKARMORY
	mon_cry CRY_CYNDAQUIL,   $039,  $140 ; HOUNDOUR
	mon_cry CRY_TOTODILE,   -$10a,  $100 ; HOUNDOOM
	mon_cry CRY_SLUGMA,      $2fb,  $100 ; KINGDRA
	mon_cry CRY_SENTRET,     $048,  $230 ; PHANPY
	mon_cry CRY_DONPHAN,     $000,  $1a0 ; DONPHAN
	mon_cry CRY_GIRAFARIG,   $073,  $240 ; PORYGON2
	mon_cry CRY_ESPEON,     -$160,  $180 ; STANTLER
	mon_cry CRY_PICHU,      -$21a,  $1f0 ; SMEARGLE
	mon_cry CRY_AIPOM,       $02c,  $108 ; TYROGUE
	mon_cry CRY_SLUGMA,      $000,  $100 ; HITMONTOP
	mon_cry CRY_MARILL,      $068,  $100 ; SMOOCHUM
	mon_cry CRY_SUNFLORA,   -$2d8,  $0b4 ; ELEKID
	mon_cry CRY_TEDDIURSA,   $176,  $03a ; MAGBY
	mon_cry CRY_GLIGAR,     -$1cd,  $1a0 ; MILTANK
	mon_cry CRY_SLOWKING,    $293,  $140 ; BLISSEY
	mon_cry CRY_RAIKOU,      $22e,  $120 ; RAIKOU
	mon_cry CRY_ENTEI,       $000,  $1a0 ; ENTEI
	mon_cry CRY_MAGCARGO,    $000,  $180 ; SUICUNE
	mon_cry CRY_RAIKOU,      $05f,  $0d0 ; LARVITAR
	mon_cry CRY_SPINARAK,   -$1db,  $150 ; PUPITAR
	mon_cry CRY_RAIKOU,     -$100,  $180 ; TYRANITAR
	mon_cry CRY_TYPHLOSION,  $000,  $100 ; LUGIA
	mon_cry CRY_AIPOM,       $000,  $180 ; HO_OH
	mon_cry CRY_ENTEI,       $14a,  $111 ; CELEBI
	mon_cry CRY_CHARMANDER,  $060,  $0c0 ; CHARMANDER_CLONE
	mon_cry CRY_CHARMANDER,  $020,  $0c0 ; CHARMELEON_CLONE
	mon_cry CRY_CHARMANDER,  $000,  $100 ; CHARIZARD_CLONE
	mon_cry CRY_SQUIRTLE,    $060,  $0c0 ; SQUIRTLE_CLONE
	mon_cry CRY_SQUIRTLE,    $020,  $0c0 ; WARTORTLE_CLONE
	mon_cry CRY_BLASTOISE,   $000,  $100 ; BLASTOISE_CLONE
	mon_cry CRY_BULBASAUR,   $080,  $081 ; BULBASAUR_CLONE
	mon_cry CRY_BULBASAUR,   $020,  $100 ; IVYSAUR_CLONE
	mon_cry CRY_BULBASAUR,   $000,  $140 ; VENUSAUR_CLONE
	mon_cry $8000 | 78, 0, $100 ; HONCHKROW (sampled)
	mon_cry $8000 | 2, 0, $100 ; AMBIPOM (sampled)
	mon_cry $8000 | 3, 0, $100 ; ANNIHILAPE (sampled)
	mon_cry $8000 | 15, 0, $100 ; BAGON (sampled)
	mon_cry $8000 | 133, 0, $100 ; SHELGON (sampled)
	mon_cry $8000 | 125, 0, $100 ; SALAMENCE (sampled)
	mon_cry $8000 | 41, 0, $100 ; DUDUNSPARCE (sampled)
	mon_cry $8000 | 47, 0, $100 ; ELECTIVIRE (sampled)
	mon_cry $8000 | 50, 0, $100 ; FARIGIRAF (sampled)
	mon_cry CRY_RALTS,       $060,  $040 ; RALTS
	mon_cry CRY_KIRLIA,      $060,  $080 ; KIRLIA
	mon_cry $8000 | 59, 0, $100 ; GARDEVOIR (sampled)
	mon_cry CRY_GALLADE,     $020,  $130 ; GALLADE
	mon_cry CRY_GLACEON,     $038,  $24c ; GLACEON
	mon_cry CRY_LEAFEON,     $038,  $20c ; LEAFEON
	mon_cry CRY_SYLVEON,     $000,  $298 ; SYLVEON
	mon_cry $8000 | 63, 0, $100 ; GLISCOR (sampled)
	mon_cry $8000 | 88, 0, $100 ; LICKILICKY (sampled)
	mon_cry $8000 | 91, 0, $100 ; MAGMORTAR (sampled)
	mon_cry $8000 | 92, 0, $100 ; MAGNEZONE (sampled)
	mon_cry $8000 | 93, 0, $100 ; MAMOSWINE (sampled)
	mon_cry CRY_RALTS,      -$0a0,  $190 ; MESMERIA
	mon_cry $8000 | 103, 0, $100 ; MISMAGIUS (sampled)
	mon_cry CRY_PORYGONZ,    $000,  $180 ; PORYGON_Z
	mon_cry $8000 | 121, 0, $100 ; RHYPERIOR (sampled)
	mon_cry CRY_VENIPEDE,    $096,  $180 ; VENIPEDE
	mon_cry CRY_WHIRLIPEDE,  $096,  $180 ; WHIRLIPEDE
	mon_cry CRY_SCOLIPEDE,   $000,  $1c9 ; SCOLIPEDE
	mon_cry $8000 | 148, 0, $100 ; TANGROWTH (sampled)
	mon_cry $8000 | 155, 0, $100 ; TOGEKISS (sampled)
	mon_cry $8000 | 164, 0, $100 ; URSALUNA (sampled)
	mon_cry $8000 | 170, 0, $100 ; WEAVILE (sampled)
	mon_cry $8000 | 175, 0, $100 ; WYRDEER (sampled)
	mon_cry $8000 | 176, 0, $100 ; YANMEGA (sampled)
	mon_cry $8000 | 89, 0, $100 ; LILEEP (sampled)
	mon_cry $8000 | 33, 0, $100 ; CRADILY (sampled)
	mon_cry $8000 | 4, 0, $100 ; ANORITH (sampled)
	mon_cry $8000 | 10, 0, $100 ; ARMALDO (sampled)
	mon_cry $8000 | 65, 0, $100 ; GOLETT (sampled)
	mon_cry $8000 | 67, 0, $100 ; GOLURK (sampled)
	mon_cry $8000 | 46, 0, $100 ; DUSKULL (sampled)
	mon_cry $8000 | 44, 0, $100 ; DUSCLOPS (sampled)
	mon_cry $8000 | 45, 0, $100 ; DUSKNOIR (sampled)
	mon_cry $8000 | 151, 0, $100 ; TIMBURR (sampled)
	mon_cry $8000 | 73, 0, $100 ; GURDURR (sampled)
	mon_cry $8000 | 29, 0, $100 ; CONKELDURR (sampled)
	mon_cry CRY_LARVESTA,    $000,  $148 ; LARVESTA
	mon_cry CRY_VOLCARONA,   $0c3,  $100 ; VOLCARONA
	mon_cry $8000 | 37, 0, $100 ; DEINO (sampled)
	mon_cry $8000 | 180, 0, $100 ; ZWEILOUS (sampled)
	mon_cry $8000 | 81, 0, $100 ; HYDREIGON (sampled)
	mon_cry CRY_DREEPY,      $080,  $0a4 ; DREEPY
	mon_cry CRY_DRAKLOAK,    $03d,  $108 ; DRAKLOAK
	mon_cry CRY_DRAGAPULT,   $080,  $108 ; DRAGAPULT
	mon_cry $8000 | 82, 0, $100 ; IMPIDIMP (sampled)
	mon_cry $8000 | 104, 0, $100 ; MORGREM (sampled)
	mon_cry $8000 | 70, 0, $100 ; GRIMMSNARL (sampled)
	mon_cry $8000 | 152, 0, $100 ; TINKATINK (sampled)
	mon_cry $8000 | 154, 0, $100 ; TINKATUFF (sampled)
	mon_cry $8000 | 153, 0, $100 ; TINKATON (sampled)
	mon_cry $8000 | 58, 0, $100 ; FRIGIBAX (sampled)
	mon_cry $8000 | 9, 0, $100 ; ARCTIBAX (sampled)
	mon_cry $8000 | 18, 0, $100 ; BAXCALIBUR (sampled)
	mon_cry $8000 | 26, 0, $100 ; CHARCADET (sampled)
	mon_cry $8000 | 11, 0, $100 ; ARMAROUGE (sampled)
	mon_cry $8000 | 23, 0, $100 ; CERULEDGE (sampled)
	mon_cry $8000 | 123, 0, $100 ; ROOKIDEE (sampled)
	mon_cry $8000 | 32, 0, $100 ; CORVISQUIRE (sampled)
	mon_cry $8000 | 31, 0, $100 ; CORVIKNIGHT (sampled)
	mon_cry CRY_SNOVER,      $0aa,  $080 ; SNOVER
	mon_cry CRY_ABOMASNOW,   $0ff,  $0c0 ; ABOMASNOW
	mon_cry CRY_SWABLU,      $0f0,  $080 ; SWABLU
	mon_cry CRY_ALTARIA,     $0ff,  $100 ; ALTARIA
	mon_cry $8000 | 6, 0, $100 ; APPLIN (sampled)
	mon_cry $8000 | 39, 0, $100 ; DIPPLIN (sampled)
	mon_cry $8000 | 5, 0, $100 ; APPLETUN (sampled)
	mon_cry $8000 | 53, 0, $100 ; FLAPPLE (sampled)
	mon_cry $8000 | 80, 0, $100 ; HYDRAPPLE (sampled)
	mon_cry $8000 | 43, 0, $100 ; DURALUDON (sampled)
	mon_cry $8000 | 8, 0, $100 ; ARCHALUDON (sampled)
	mon_cry CRY_SHROOMISH,   $0ff,  $070 ; SHROOMISH
	mon_cry CRY_BRELOOM,     $050,  $116 ; BRELOOM
	mon_cry CRY_BUNEARY,     $000,  $0a4 ; BUNEARY
	mon_cry CRY_LOPUNNY,     $000,  $100 ; LOPUNNY
	mon_cry CRY_NUMEL,       $000,  $080 ; NUMEL
	mon_cry CRY_CAMERUPT,    $000,  $180 ; CAMERUPT
	mon_cry $8000 | 138, 0, $100 ; SIZZLIPEDE (sampled)
	mon_cry $8000 | 22, 0, $100 ; CENTISKORCH (sampled)
	mon_cry $8000 | 72, 0, $100 ; GRUBBIN (sampled)
	mon_cry $8000 | 27, 0, $100 ; CHARJABUG (sampled)
	mon_cry $8000 | 167, 0, $100 ; VIKAVOLT (sampled)
	mon_cry $8000 | 35, 0, $100 ; CROAGUNK (sampled)
	mon_cry $8000 | 158, 0, $100 ; TOXICROAK (sampled)
	mon_cry CRY_DRIFLOON,    $000,  $100 ; DRIFLOON
	mon_cry CRY_DRIFBLIM,    $0ff,  $0ec ; DRIFBLIM
	mon_cry CRY_DRILBUR,     $0ff,  $0c8 ; DRILBUR
	mon_cry CRY_EXCADRILL,   $058,  $108 ; EXCADRILL
	mon_cry CRY_PICHU,       $f60,  $200 ; KOTORA
	mon_cry CRY_RAIKOU,      $db3,  $168 ; RAITORA
	mon_cry CRY_RAIKOU,      $cb3,  $201 ; GOROTORA
	mon_cry $8000 | 55, 0, $100 ; FLETCHLING (sampled)
	mon_cry $8000 | 54, 0, $100 ; FLETCHINDER (sampled)
	mon_cry $8000 | 147, 0, $100 ; TALONFLAME (sampled)
	mon_cry $8000 | 159, 0, $100 ; TRAPINCH (sampled)
	mon_cry $8000 | 166, 0, $100 ; VIBRAVA (sampled)
	mon_cry $8000 | 56, 0, $100 ; FLYGON (sampled)
	mon_cry CRY_SNORUNT,     $064,  $0d0 ; SNORUNT
	mon_cry CRY_FROSLASS,    $08f,  $180 ; FROSLASS
	mon_cry $8000 | 172, 0, $100 ; WIMPOD (sampled)
	mon_cry $8000 | 66, 0, $100 ; GOLISOPOD (sampled)
	mon_cry CRY_VULPIX, $080, $0b0 ; ZORUA
	mon_cry CRY_VILEPLUME, $030, $140 ; ZOROARK
	mon_cry $8000 | 112, 0, $100 ; PAWNIARD (sampled)
	mon_cry $8000 | 19, 0, $100 ; BISHARP (sampled)
	mon_cry $8000 | 84, 0, $100 ; KINGAMBIT (sampled)
	mon_cry $8000 | 131, 0, $100 ; SEEDOT (sampled)
	mon_cry $8000 | 109, 0, $100 ; NUZLEAF (sampled)
	mon_cry $8000 | 135, 0, $100 ; SHIFTRY (sampled)
	mon_cry CRY_SLOWKING,    $000,  $100 ; OVERQWIL
	mon_cry CRY_SCRAGGY,     $0df,  $0c0 ; SCRAGGY
	mon_cry CRY_SCRAFTY,     $061,  $12c ; SCRAFTY
	mon_cry $8000 | 79, 0, $100 ; HONEDGE (sampled)
	mon_cry $8000 | 40, 0, $100 ; DOUBLADE (sampled)
	mon_cry $8000 | 0, 0, $100 ; AEGISLASH (sampled)
	mon_cry CRY_TEDDIURSA,   $7a2,  $06e ; TEDDIURSABM
	mon_cry CRY_TEDDIURSA,   $640,  $0d8 ; URSARINGBM
	mon_cry $8000 | 165, 0, $100 ; URSALUNABM (sampled)
	mon_cry $8000 | 13, 0, $100 ; AXEW (sampled)
	mon_cry $8000 | 57, 0, $100 ; FRAXURE (sampled)
	mon_cry $8000 | 75, 0, $100 ; HAXORUS (sampled)
	mon_cry $8000 | 34, 0, $100 ; CRANIDOS (sampled)
	mon_cry $8000 | 117, 0, $100 ; RAMPARDOS (sampled)
	mon_cry $8000 | 134, 0, $100 ; SHIELDON (sampled)
	mon_cry $8000 | 17, 0, $100 ; BASTIODON (sampled)
	mon_cry $8000 | 25, 0, $100 ; CETODDLE (sampled)
	mon_cry $8000 | 24, 0, $100 ; CETITAN (sampled)
	mon_cry $8000 | 51, 0, $100 ; FEEBAS (sampled)
	mon_cry $8000 | 100, 0, $100 ; MILOTIC (sampled)
	mon_cry $8000 | 102, 0, $100 ; MIMIKYU (sampled)
	mon_cry CRY_MAGCARGO,    $0a1,  $0e8 ; CORSOLA_GALARIAN
	mon_cry CRY_MAGCARGO,   -$044,  $1c0 ; CURSOLA
	mon_cry CRY_KRABBY,      $008,  $0c0 ; MR__RIME
	mon_cry CRY_SPEAROW,     $088,  $0a0 ; SIRFETCH_D
	mon_cry $8000 | 122, 0, $100 ; RIOLU (sampled)
	mon_cry $8000 | 90, 0, $100 ; LUCARIO (sampled)
	mon_cry $8000 | 163, 0, $100 ; TYRUNT (sampled)
	mon_cry $8000 | 162, 0, $100 ; TYRANTRUM (sampled)
	mon_cry $8000 | 1, 0, $100 ; AMAURA (sampled)
	mon_cry $8000 | 12, 0, $100 ; AURORUS (sampled)
	mon_cry $8000 | 107, 0, $100 ; MUNCHLAX (sampled)
	mon_cry $8000 | 156, 0, $100 ; TORKOAL (sampled)
	mon_cry CRY_RATTATA,     $000,  $100 ; RATTATA_ALOLAN
	mon_cry CRY_RATTATA,     $020,  $17f ; RATICATE_ALOLAN
	mon_cry CRY_RAICHU,      $0ee,  $088 ; RAICHU_ALOLAN
	mon_cry CRY_NIDORAN_M,   $020,  $0c0 ; SANDSHREW_ALOLAN
	mon_cry CRY_NIDORAN_M,   $0ff,  $17f ; SANDSLASH_ALOLAN
	mon_cry CRY_VULPIX,      $04f,  $090 ; VULPIX_ALOLAN
	mon_cry CRY_VULPIX,      $088,  $0e0 ; NINETALES_ALOLAN
	mon_cry CRY_DIGLETT,     $0aa,  $081 ; DIGLETT_ALOLAN
	mon_cry CRY_DIGLETT,     $02a,  $090 ; DUGTRIO_ALOLAN
	mon_cry CRY_CLEFAIRY,    $077,  $090 ; MEOWTH_ALOLAN
	mon_cry CRY_CLEFAIRY,    $099,  $17f ; PERSIAN_ALOLAN
	mon_cry CRY_VULPIX,      $0f0,  $090 ; GEODUDE_ALOLAN
	mon_cry CRY_VULPIX,      $000,  $100 ; GRAVELER_ALOLAN
	mon_cry CRY_GOLEM,       $0e0,  $0c0 ; GOLEM_ALOLAN
	mon_cry CRY_GRIMER,      $000,  $100 ; GRIMER_ALOLAN
	mon_cry CRY_MUK,         $0ef,  $17f ; MUK_ALOLAN
	mon_cry CRY_DROWZEE,     $000,  $100 ; EXEGGUTOR_ALOLAN
	mon_cry CRY_ODDISH,      $04f,  $0e0 ; MAROWAK_ALOLAN
	mon_cry CRY_CLEFAIRY,    $077,  $090 ; MEOWTH_GALARIAN
	mon_cry CRY_CLEFAIRY,    $099,  $17f ; PERRSERKER
	mon_cry CRY_WEEPINBELL,  $000,  $100 ; PONYTA_GALARIAN
	mon_cry CRY_WEEPINBELL,  $020,  $140 ; RAPIDASH_GALARIAN
	mon_cry CRY_SLOWPOKE,    $000,  $100 ; SLOWPOKE_GALARIAN
	mon_cry CRY_GROWLITHE,   $000,  $100 ; SLOWBRO_GALARIAN
	mon_cry CRY_SLOWKING,    $104,  $200 ; SLOWKING_GALARIAN
	mon_cry CRY_GOLEM,       $0ff,  $17f ; WEEZING_GALARIAN
	mon_cry CRY_GROWLITHE,   $020,  $0c0 ; GROWLITHE_HISUIAN
	mon_cry CRY_WEEDLE,      $000,  $100 ; ARCANINE_HISUIAN
	mon_cry CRY_VOLTORB,     $0ed,  $100 ; VOLTORB_HISUIAN
	mon_cry CRY_VOLTORB,     $0a8,  $110 ; ELECTRODE_HISUIAN
	mon_cry CRY_TYPHLOSION,  $f00,  $0d4 ; TYPHLOSION_HISUIAN
	mon_cry CRY_WOOPER,      $053,  $0af ; SNEASEL_HISUIAN
	mon_cry CRY_SNEASLER,    $000,  $100 ; SNEASLER
	mon_cry CRY_WOOPER,      $093,  $0af ; WOOPER_PALDEAN
	mon_cry CRY_WOOPER,     -$0c6,  $140 ; CLODSIRE
	mon_cry CRY_SQUIRTLE,    $011,  $0c0 ; TAUROS_PALDEAN_FIRE
	mon_cry CRY_SQUIRTLE,    $011,  $0c0 ; TAUROS_PALDEAN_WATER
	mon_cry CRY_NATU,       -$087,  $130 ; WATU
	mon_cry $8000 | 21, 0, $100 ; BOUNSWEET (sampled)
	mon_cry $8000 | 146, 0, $100 ; STEENEE (sampled)
	mon_cry $8000 | 160, 0, $100 ; TSAREENA (sampled)
	mon_cry CRY_ARON,        $03c,  $070 ; ARON
	mon_cry CRY_LAIRON,      $01e,  $070 ; LAIRON
	mon_cry CRY_AGGRON,      $000,  $100 ; AGGRON
	mon_cry $8000 | 85, 0, $100 ; KLEAVOR (sampled)
	mon_cry $8000 | 61, 0, $100 ; GLIMMET (sampled)
	mon_cry $8000 | 62, 0, $100 ; GLIMMORA (sampled)
	mon_cry $8000 | 95, 0, $100 ; MAREANIE (sampled)
	mon_cry $8000 | 157, 0, $100 ; TOXAPEX (sampled)
	mon_cry $8000 | 177, 0, $100 ; ZANGOOSE (sampled)
	mon_cry $8000 | 132, 0, $100 ; SEVIPER (sampled)
	mon_cry $8000 | 136, 0, $100 ; SHUPPET (sampled)
	mon_cry $8000 | 16, 0, $100 ; BANETTE (sampled)
	mon_cry CRY_ARCHEN,         206,   204 ; ARCHEN
	mon_cry CRY_ARCHEOPS,       188,   140 ; ARCHEOPS
	mon_cry CRY_TIRTOUGA,       192,   204 ; TIRTOUGA
	mon_cry CRY_CARRACOSTA,      35,   204 ; CARRACOSTA
	mon_cry CRY_LITWICK,     $000,  $100 ; LITWICK
	mon_cry CRY_LAMPENT,     $000,  $180 ; LAMPENT
	mon_cry CRY_CHANDELURE,  $0ff,  $180 ; CHANDELURE
	mon_cry CRY_JOLTIK,      $000,  $100 ; JOLTIK
	mon_cry CRY_GALVANTULA,  $000,  $0dc ; GALVANTULA
	mon_cry $8000 | 97, 0, $100 ; MAWILE (sampled)
	mon_cry CRY_NOIBAT,      $0a7,  $084 ; NOIBAT
	mon_cry CRY_NOIVERN,     $04a,  $084 ; NOIVERN
	mon_cry $8000 | 126, 0, $100 ; SALANDIT (sampled)
	mon_cry $8000 | 127, 0, $100 ; SALAZZLE (sampled)
	mon_cry $8000 | 124, 0, $100 ; SABLEYE (sampled)
	mon_cry $8000 | 0, 0, $100 ; AEGISLASH_BLADE (sampled)
	mon_cry $8000 | 52, 0, $100 ; FINIZEN (sampled)
	mon_cry $8000 | 111, 0, $100 ; PALAFIN (sampled)
	mon_cry $8000 | 14, 0, $100 ; AZURILL (sampled)
	mon_cry $8000 | 174, 0, $100 ; WYNAUT (sampled)
	mon_cry $8000 | 20, 0, $100 ; BONSLY (sampled)
	mon_cry $8000 | 101, 0, $100 ; MIME_JR_ (sampled)
	mon_cry $8000 | 74, 0, $100 ; HAPPINY (sampled)
	mon_cry $8000 | 94, 0, $100 ; MANTYKE (sampled)
	mon_cry $8000 | 145, 0, $100 ; STARLY (sampled)
	mon_cry $8000 | 144, 0, $100 ; STARAVIA (sampled)
	mon_cry $8000 | 143, 0, $100 ; STARAPTOR (sampled)
	mon_cry $8000 | 128, 0, $100 ; SANDILE (sampled)
	mon_cry $8000 | 86, 0, $100 ; KROKOROK (sampled)
	mon_cry $8000 | 87, 0, $100 ; KROOKODILE (sampled)
	mon_cry CRY_RAICHU,      $0e0,  $17f ; GOROCHU (Rage Blue length $ff + $80)
	mon_cry $8000 | 83, 0, $100 ; JIRACHI (sampled)
	mon_cry CRY_PHANTUMP, 119, 220 ; PHANTUMP (Polished Coral)
	mon_cry CRY_TREVENANT, 0, 220 ; TREVENANT (Polished Coral)
	mon_cry CRY_MIENFOO, 0, 220 ; MIENFOO (Polished Coral)
	mon_cry CRY_MIENSHAO, 0, 220 ; MIENSHAO (Polished Coral)
	mon_cry $8000 | 76, 0, $100 ; HIPPOPOTAS (sampled)
	mon_cry $8000 | 77, 0, $100 ; HIPPOWDON (sampled)
	mon_cry $8000 | 177, 0, $100 ; ZANGOOSE_SCARRED (sampled)
