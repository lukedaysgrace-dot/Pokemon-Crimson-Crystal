; Modern main-game base stats used by the Original gameplay-rules option.
; BaseData order is HP, Attack, Defense, Speed, Sp. Atk, Sp. Def.
; Complete official-species baseline: later BaseData buffs cannot leak here.
; Reference: https://play.pokemonshowdown.com/data/pokedex.json (2026-10-04).
; Custom species retain BaseData; clone starters use their parent stats.
; Palafin uses its base form; Hero form is not implemented in this game.

OriginalPokemonStats:
	dw ABOMASNOW
	db  90,  92,  75,  60,  92,  85
	dw ABRA
	db  25,  20,  15,  90, 105,  55
	dw AERODACTYL
	db  80, 105,  65, 130,  60,  75
	dw AGGRON
	db  70, 110, 180,  50,  60,  60
	dw AIPOM
	db  55,  70,  55,  85,  40,  55
	dw ALAKAZAM
	db  55,  50,  45, 120, 135,  95
	dw ALTARIA
	db  75,  70,  90,  80,  70, 105
	dw AMAURA
	db  77,  59,  50,  46,  67,  63
	dw AMBIPOM
	db  75, 100,  66, 115,  60,  66
	dw AMPHAROS
	db  90,  75,  85,  55, 115,  90
	dw ANNIHILAPE
	db 110, 115,  80,  90,  50,  90
	dw ANORITH
	db  45,  95,  50,  75,  40,  50
	dw APPLETUN
	db 110,  85,  80,  30, 100,  80
	dw APPLIN
	db  40,  40,  80,  20,  40,  40
	dw ARBOK
	db  60,  95,  69,  80,  65,  79
	dw ARCANINE
	db  90, 110,  80,  95, 100,  80
	dw ARCANINE_HISUIAN
	db  95, 115,  80,  90,  95,  80
	dw ARCHALUDON
	db  90, 105, 130,  85, 125,  65
	dw ARCHEN
	db  55, 112,  45,  70,  74,  45
	dw ARCHEOPS
	db  75, 140,  65, 110, 112,  65
	dw ARCTIBAX
	db  90,  95,  66,  62,  45,  65
	dw ARIADOS
	db  70,  90,  70,  40,  60,  70
	dw ARMALDO
	db  75, 125, 100,  45,  70,  80
	dw ARMAROUGE
	db  85,  60, 100,  75, 125,  80
	dw ARON
	db  50,  70, 100,  30,  40,  40
	dw ARTICUNO
	db  90,  85, 100,  85,  95, 125
	dw AURORUS
	db 123,  77,  72,  58,  99,  92
	dw AXEW
	db  46,  87,  60,  57,  30,  40
	dw AZUMARILL
	db 100,  50,  80,  50,  60,  80
	dw AZURILL
	db  50,  20,  40,  20,  20,  40
	dw BAGON
	db  45,  75,  60,  50,  40,  30
	dw BANETTE
	db  64, 115,  65,  65,  83,  63
	dw BASTIODON
	db  60,  52, 168,  30,  47, 138
	dw BAXCALIBUR
	db 115, 145,  92,  87,  75,  86
	dw BAYLEEF
	db  60,  62,  80,  60,  63,  80
	dw BEEDRILL
	db  65,  90,  40,  75,  45,  80
	dw BELLOSSOM
	db  75,  80,  95,  50,  90, 100
	dw BELLSPROUT
	db  50,  75,  35,  40,  70,  30
	dw BISHARP
	db  65, 125, 100,  70,  60,  70
	dw BLASTOISE
	db  79,  83, 100,  78,  85, 105
	dw BLASTOISE_CLONE
	db  79,  83, 100,  78,  85, 105
	dw BLISSEY
	db 255,  10,  10,  55,  75, 135
	dw BONSLY
	db  50,  80,  95,  10,  10,  45
	dw BOUNSWEET
	db  42,  30,  38,  32,  30,  38
	dw BRELOOM
	db  60, 130,  80,  70,  60,  60
	dw BULBASAUR
	db  45,  49,  49,  45,  65,  65
	dw BULBASAUR_CLONE
	db  45,  49,  49,  45,  65,  65
	dw BUNEARY
	db  55,  66,  44,  85,  44,  56
	dw BUTTERFREE
	db  60,  45,  50,  70,  90,  80
	dw CAMERUPT
	db  70, 100,  70,  40, 105,  75
	dw CARRACOSTA
	db  74, 108, 133,  32,  83,  65
	dw CATERPIE
	db  45,  30,  35,  45,  20,  20
	dw CELEBI
	db 100, 100, 100, 100, 100, 100
	dw CENTISKORCH
	db 100, 115,  65,  65,  90,  90
	dw CERULEDGE
	db  75, 125,  80,  85,  60, 100
	dw CETITAN
	db 170, 113,  65,  73,  45,  55
	dw CETODDLE
	db 108,  68,  45,  43,  30,  40
	dw CHANDELURE
	db  60,  55,  90,  80, 145,  90
	dw CHANSEY
	db 250,   5,   5,  50,  35, 105
	dw CHARCADET
	db  40,  50,  40,  35,  50,  40
	dw CHARIZARD
	db  78,  84,  78, 100, 109,  85
	dw CHARIZARD_CLONE
	db  78,  84,  78, 100, 109,  85
	dw CHARJABUG
	db  57,  82,  95,  36,  55,  75
	dw CHARMANDER
	db  39,  52,  43,  65,  60,  50
	dw CHARMANDER_CLONE
	db  39,  52,  43,  65,  60,  50
	dw CHARMELEON
	db  58,  64,  58,  80,  80,  65
	dw CHARMELEON_CLONE
	db  58,  64,  58,  80,  80,  65
	dw CHIKORITA
	db  45,  49,  65,  45,  49,  65
	dw CHINCHOU
	db  75,  38,  38,  67,  56,  56
	dw CLEFABLE
	db  95,  70,  73,  60,  95,  90
	dw CLEFAIRY
	db  70,  45,  48,  35,  60,  65
	dw CLEFFA
	db  50,  25,  28,  15,  45,  55
	dw CLODSIRE
	db 130,  75,  60,  20,  45, 100
	dw CLOYSTER
	db  50,  95, 180,  70,  85,  45
	dw CONKELDURR
	db 105, 140,  95,  45,  55,  65
	dw CORSOLA
	db  65,  55,  95,  35,  65,  95
	dw CORSOLA_GALARIAN
	db  60,  55, 100,  30,  65, 100
	dw CORVIKNIGHT
	db  98,  87, 105,  67,  53,  85
	dw CORVISQUIRE
	db  68,  67,  55,  77,  43,  55
	dw CRADILY
	db  86,  81,  97,  43,  81, 107
	dw CRANIDOS
	db  67, 125,  40,  58,  30,  30
	dw CROAGUNK
	db  48,  61,  40,  50,  61,  40
	dw CROBAT
	db  85,  90,  80, 130,  70,  80
	dw CROCONAW
	db  65,  80,  80,  58,  59,  63
	dw CUBONE
	db  50,  50,  95,  35,  40,  50
	dw CURSOLA
	db  60,  95,  50,  30, 145, 130
	dw CYNDAQUIL
	db  39,  52,  43,  65,  60,  50
	dw DEINO
	db  52,  65,  50,  38,  45,  50
	dw DELIBIRD
	db  45,  55,  45,  75,  65,  45
	dw DEWGONG
	db  90,  70,  80,  70,  70,  95
	dw DIGLETT
	db  10,  55,  25,  95,  35,  45
	dw DIGLETT_ALOLAN
	db  10,  55,  30,  90,  35,  45
	dw DIPPLIN
	db  80,  80, 110,  40,  95,  80
	dw DITTO
	db  48,  48,  48,  48,  48,  48
	dw DODRIO
	db  60, 110,  70, 110,  60,  60
	dw DODUO
	db  35,  85,  45,  75,  35,  35
	dw DONPHAN
	db  90, 120, 120,  50,  60,  60
	dw DRAGAPULT
	db  88, 120,  75, 142, 100,  75
	dw DRAGONAIR
	db  61,  84,  65,  70,  70,  70
	dw DRAGONITE
	db  91, 134,  95,  80, 100, 100
	dw DRAKLOAK
	db  68,  80,  50, 102,  60,  50
	dw DRATINI
	db  41,  64,  45,  50,  50,  50
	dw DREEPY
	db  28,  60,  30,  82,  40,  30
	dw DRIFBLIM
	db 150,  80,  44,  80,  90,  54
	dw DRIFLOON
	db  90,  50,  34,  70,  60,  44
	dw DRILBUR
	db  60,  85,  40,  68,  30,  45
	dw DROWZEE
	db  60,  48,  45,  42,  43,  90
	dw DUDUNSPARCE
	db 125, 100,  80,  55,  85,  75
	dw DUGTRIO
	db  35, 100,  50, 120,  50,  70
	dw DUGTRIO_ALOLAN
	db  35, 100,  60, 110,  50,  70
	dw DUNSPARCE
	db 100,  70,  70,  45,  65,  65
	dw DURALUDON
	db  70,  95, 115,  85, 120,  50
	dw DUSCLOPS
	db  40,  70, 130,  25,  60, 130
	dw DUSKNOIR
	db  45, 100, 135,  45,  65, 135
	dw DUSKULL
	db  20,  40,  90,  25,  30,  90
	dw EEVEE
	db  55,  55,  50,  55,  45,  65
	dw EKANS
	db  35,  60,  44,  55,  40,  54
	dw ELECTABUZZ
	db  65,  83,  57, 105,  95,  85
	dw ELECTIVIRE
	db  75, 123,  67,  95,  95,  85
	dw ELECTRODE
	db  60,  50,  70, 150,  80,  80
	dw ELECTRODE_HISUIAN
	db  60,  50,  70, 150,  80,  80
	dw ELEKID
	db  45,  63,  37,  95,  65,  55
	dw ENTEI
	db 115, 115,  85, 100,  90,  75
	dw ESPATHRA
	db  95,  60,  60, 105, 101,  60
	dw ESPEON
	db  65,  65,  60, 110, 130,  95
	dw EXCADRILL
	db 110, 135,  60,  88,  50,  65
	dw EXEGGCUTE
	db  60,  40,  80,  40,  60,  45
	dw EXEGGUTOR
	db  95,  95,  85,  55, 125,  75
	dw EXEGGUTOR_ALOLAN
	db  95, 105,  85,  45, 125,  75
	dw FARFETCH_D
	db  52,  90,  55,  60,  58,  62
	dw FARIGIRAF
	db 120,  90,  70,  60, 110,  70
	dw FEAROW
	db  65,  90,  65, 100,  61,  61
	dw FEEBAS
	db  20,  15,  20,  80,  10,  55
	dw FERALIGATR
	db  85, 105, 100,  78,  79,  83
	dw FINIZEN
	db  70,  45,  40,  75,  45,  40
	dw FLAAFFY
	db  70,  55,  55,  45,  80,  60
	dw FLAPPLE
	db  70, 110,  80,  70,  95,  60
	dw FLAREON
	db  65, 130,  60,  65,  95, 110
	dw FLETCHINDER
	db  62,  73,  55,  84,  56,  52
	dw FLETCHLING
	db  45,  50,  43,  62,  40,  38
	dw FLITTLE
	db  30,  35,  30,  75,  55,  30
	dw FLYGON
	db  80, 100,  80, 100,  80,  80
	dw FORRETRESS
	db  75,  90, 140,  40,  60,  60
	dw FRAXURE
	db  66, 117,  70,  67,  40,  50
	dw FRIGIBAX
	db  65,  75,  45,  55,  35,  45
	dw FROSLASS
	db  70,  80,  70, 110,  80,  70
	dw FURRET
	db  85,  76,  64,  90,  45,  55
	dw GALLADE
	db  68, 125,  65,  80,  65, 115
	dw GALVANTULA
	db  70,  77,  60, 108,  97,  60
	dw GARDEVOIR
	db  68,  65,  65,  80, 125, 115
	dw GASTLY
	db  30,  35,  30,  80, 100,  35
	dw GENGAR
	db  60,  65,  60, 110, 130,  75
	dw GEODUDE
	db  40,  80, 100,  20,  30,  30
	dw GEODUDE_ALOLAN
	db  40,  80, 100,  20,  30,  30
	dw GIRAFARIG
	db  70,  80,  65,  85,  90,  65
	dw GLACEON
	db  65,  60, 110,  65, 130,  95
	dw GLIGAR
	db  65,  75, 105,  85,  35,  65
	dw GLIMMET
	db  48,  35,  42,  60, 105,  60
	dw GLIMMORA
	db  83,  55,  90,  86, 130,  81
	dw GLISCOR
	db  75,  95, 125,  95,  45,  75
	dw GLOOM
	db  60,  65,  70,  40,  85,  75
	dw GOLBAT
	db  75,  80,  70,  90,  65,  75
	dw GOLDEEN
	db  45,  67,  60,  63,  35,  50
	dw GOLDUCK
	db  80,  82,  78,  85,  95,  80
	dw GOLEM
	db  80, 120, 130,  45,  55,  65
	dw GOLEM_ALOLAN
	db  80, 120, 130,  45,  55,  65
	dw GOLETT
	db  59,  74,  50,  35,  35,  50
	dw GOLISOPOD
	db  75, 125, 140,  40,  60,  90
	dw GOLURK
	db  89, 124,  80,  55,  55,  80
	dw GRANBULL
	db  90, 120,  75,  45,  60,  60
	dw GRAVELER
	db  55,  95, 115,  35,  45,  45
	dw GRAVELER_ALOLAN
	db  55,  95, 115,  35,  45,  45
	dw GRIMER
	db  80,  80,  50,  25,  40,  50
	dw GRIMER_ALOLAN
	db  80,  80,  50,  25,  40,  50
	dw GRIMMSNARL
	db  95, 120,  65,  60,  95,  75
	dw GROWLITHE
	db  55,  70,  45,  60,  70,  50
	dw GROWLITHE_HISUIAN
	db  60,  75,  45,  55,  65,  50
	dw GRUBBIN
	db  47,  62,  45,  46,  55,  45
	dw GRUMPIG
	db  80,  45,  65,  80,  90, 110
	dw GURDURR
	db  85, 105,  85,  40,  40,  50
	dw GYARADOS
	db  95, 125,  79,  81,  60, 100
	dw HAPPINY
	db 100,   5,   5,  30,  15,  65
	dw HAUNTER
	db  45,  50,  45,  95, 115,  55
	dw HAXORUS
	db  76, 147,  90,  97,  60,  70
	dw HERACROSS
	db  80, 125,  75,  85,  40,  95
	dw HITMONCHAN
	db  50, 105,  79,  76,  35, 110
	dw HITMONLEE
	db  50, 120,  53,  87,  35, 110
	dw HITMONTOP
	db  50,  95,  95,  70,  35, 110
	dw HONCHKROW
	db 100, 125,  52,  71, 105,  52
	dw HOOTHOOT
	db  60,  30,  30,  50,  36,  56
	dw HOPPIP
	db  35,  35,  40,  50,  35,  55
	dw HORSEA
	db  30,  40,  70,  60,  70,  25
	dw HOUNDOOM
	db  75,  90,  50,  95, 110,  80
	dw HOUNDOUR
	db  45,  60,  30,  65,  80,  50
	dw HO_OH
	db 106, 130,  90,  90, 110, 154
	dw HYDRAPPLE
	db 106,  80, 110,  44, 120,  80
	dw HYDREIGON
	db  92, 105,  90,  98, 125,  90
	dw HYPNO
	db  85,  73,  70,  67,  73, 115
	dw IGGLYBUFF
	db  90,  30,  15,  15,  40,  20
	dw IMPIDIMP
	db  45,  45,  30,  50,  55,  40
	dw IVYSAUR
	db  60,  62,  63,  60,  80,  80
	dw IVYSAUR_CLONE
	db  60,  62,  63,  60,  80,  80
	dw JIGGLYPUFF
	db 115,  45,  20,  20,  45,  25
	dw JOLTEON
	db  65,  65,  60, 130, 110,  95
	dw JOLTIK
	db  50,  47,  50,  65,  57,  50
	dw JUMPLUFF
	db  75,  55,  70, 110,  55,  95
	dw JYNX
	db  65,  50,  35,  95, 115,  95
	dw KABUTO
	db  30,  80,  90,  55,  55,  45
	dw KABUTOPS
	db  60, 115, 105,  80,  65,  70
	dw KADABRA
	db  40,  35,  30, 105, 120,  70
	dw KAKUNA
	db  45,  25,  50,  35,  25,  25
	dw KANGASKHAN
	db 105,  95,  80,  90,  40,  80
	dw KINGAMBIT
	db 100, 135, 120,  50,  60,  85
	dw KINGDRA
	db  75,  95,  95,  85,  95,  95
	dw KINGLER
	db  55, 130, 115,  75,  50,  50
	dw KIRLIA
	db  38,  35,  35,  50,  65,  55
	dw KLEAVOR
	db  70, 135,  95,  85,  45,  70
	dw KOFFING
	db  40,  65,  95,  35,  60,  45
	dw KRABBY
	db  30, 105,  90,  50,  25,  25
	dw KROKOROK
	db  60,  82,  45,  74,  45,  45
	dw KROOKODILE
	db  95, 117,  80,  92,  65,  70
	dw LAIRON
	db  60,  90, 140,  40,  50,  50
	dw LAMPENT
	db  60,  40,  60,  55,  95,  60
	dw LANTURN
	db 125,  58,  58,  67,  76,  76
	dw LAPRAS
	db 130,  85,  80,  60,  85,  95
	dw LARVESTA
	db  55,  85,  55,  60,  50,  55
	dw LARVITAR
	db  50,  64,  50,  41,  45,  50
	dw LEAFEON
	db  65, 110, 130,  95,  60,  65
	dw LEDIAN
	db  55,  35,  50,  85,  55, 110
	dw LEDYBA
	db  40,  20,  30,  55,  40,  80
	dw LICKILICKY
	db 110,  85,  95,  50,  80,  95
	dw LICKITUNG
	db  90,  55,  75,  30,  60,  75
	dw LILEEP
	db  66,  41,  77,  23,  61,  87
	dw LITWICK
	db  50,  30,  55,  20,  65,  55
	dw LOMBRE
	db  60,  50,  50,  50,  60,  70
	dw LOPUNNY
	db  65,  76,  84, 105,  54,  96
	dw LOTAD
	db  40,  30,  30,  30,  40,  50
	dw LUCARIO
	db  70, 110,  70,  90, 115,  70
	dw LUDICOLO
	db  80,  70,  70,  70,  90, 100
	dw LUGIA
	db 106,  90, 130, 110,  90, 154
	dw MACHAMP
	db  90, 130,  80,  55,  65,  85
	dw MACHOKE
	db  80, 100,  70,  45,  50,  60
	dw MACHOP
	db  70,  80,  50,  35,  35,  35
	dw MAGBY
	db  45,  75,  37,  83,  70,  55
	dw MAGCARGO
	db  60,  50, 120,  30,  90,  80
	dw MAGIKARP
	db  20,  10,  55,  80,  15,  20
	dw MAGMAR
	db  65,  95,  57,  93, 100,  85
	dw MAGMORTAR
	db  75,  95,  67,  83, 125,  95
	dw MAGNEMITE
	db  25,  35,  70,  45,  95,  55
	dw MAGNETON
	db  50,  60,  95,  70, 120,  70
	dw MAGNEZONE
	db  70,  70, 115,  60, 130,  90
	dw MAMOSWINE
	db 110, 130,  80,  80,  70,  60
	dw MANKEY
	db  40,  80,  35,  70,  35,  45
	dw MANTINE
	db  85,  40,  70,  70,  80, 140
	dw MANTYKE
	db  45,  20,  50,  50,  60, 120
	dw MAREANIE
	db  50,  53,  62,  45,  43,  52
	dw MAREEP
	db  55,  40,  40,  35,  65,  45
	dw MARILL
	db  70,  20,  50,  40,  20,  50
	dw MAROWAK
	db  60,  80, 110,  45,  50,  80
	dw MAROWAK_ALOLAN
	db  60,  80, 110,  45,  50,  80
	dw MAWILE
	db  50,  85,  85,  50,  55,  55
	dw MEGANIUM
	db  80,  82, 100,  80,  83, 100
	dw MEOWTH
	db  40,  45,  35,  90,  40,  40
	dw MEOWTH_ALOLAN
	db  40,  35,  35,  90,  50,  40
	dw MEOWTH_GALARIAN
	db  50,  65,  55,  40,  40,  40
	dw METAPOD
	db  50,  20,  55,  30,  25,  25
	dw MEW
	db 100, 100, 100, 100, 100, 100
	dw MEWTWO
	db 106, 110,  90, 130, 154,  90
	dw MILOTIC
	db  95,  60,  79,  81, 100, 125
	dw MILTANK
	db  95,  80, 105, 100,  40,  70
	dw MIME_JR_
	db  20,  25,  45,  60,  70,  90
	dw MIMIKYU
	db  55,  90,  80,  96,  50, 105
	dw MISDREAVUS
	db  60,  60,  60,  85,  85,  85
	dw MISMAGIUS
	db  60,  60,  60, 105, 105, 105
	dw MOLTRES
	db  90, 100,  90,  90, 125,  85
	dw MORGREM
	db  65,  60,  45,  70,  75,  55
	dw MR__MIME
	db  40,  45,  65,  90, 100, 120
	dw MR__RIME
	db  80,  85,  75,  70, 110, 100
	dw MUK
	db 105, 105,  75,  50,  65, 100
	dw MUK_ALOLAN
	db 105, 105,  75,  50,  65, 100
	dw MUNCHLAX
	db 135,  85,  40,   5,  40,  85
	dw MURKROW
	db  60,  85,  42,  91,  85,  42
	dw NATU
	db  40,  50,  45,  70,  70,  45
	dw NIDOKING
	db  81, 102,  77,  85,  85,  75
	dw NIDOQUEEN
	db  90,  92,  87,  76,  75,  85
	dw NIDORAN_F
	db  55,  47,  52,  41,  40,  40
	dw NIDORAN_M
	db  46,  57,  40,  50,  40,  40
	dw NIDORINA
	db  70,  62,  67,  56,  55,  55
	dw NIDORINO
	db  61,  72,  57,  65,  55,  55
	dw NINETALES
	db  73,  76,  75, 100,  81, 100
	dw NINETALES_ALOLAN
	db  73,  67,  75, 109,  81, 100
	dw NOCTOWL
	db 100,  50,  50,  70,  86,  96
	dw NOIBAT
	db  40,  30,  35,  55,  45,  40
	dw NOIVERN
	db  85,  70,  80, 123,  97,  80
	dw NUMEL
	db  60,  60,  40,  35,  65,  45
	dw OCTILLERY
	db  75, 105,  75,  45, 105,  75
	dw ODDISH
	db  45,  50,  55,  30,  75,  65
	dw OMANYTE
	db  35,  40, 100,  35,  90,  55
	dw OMASTAR
	db  70,  60, 125,  55, 115,  70
	dw ONIX
	db  35,  45, 160,  70,  30,  45
	dw OVERQWIL
	db  85, 115,  95,  85,  65,  65
	dw PALAFIN
	db 100,  70,  72, 100,  53,  62
	dw PARAS
	db  35,  70,  55,  25,  45,  55
	dw PARASECT
	db  60,  95,  80,  30,  60,  80
	dw PAWNIARD
	db  45,  85,  70,  60,  40,  40
	dw PERRSERKER
	db  70, 110, 100,  50,  50,  60
	dw PERSIAN
	db  65,  70,  60, 115,  65,  65
	dw PERSIAN_ALOLAN
	db  65,  60,  60, 115,  75,  65
	dw PHANPY
	db  90,  60,  60,  40,  40,  40
	dw PICHU
	db  20,  40,  15,  60,  35,  35
	dw PIDGEOT
	db  83,  80,  75, 101,  70,  70
	dw PIDGEOTTO
	db  63,  60,  55,  71,  50,  50
	dw PIDGEY
	db  40,  45,  40,  56,  35,  35
	dw PIKACHU
	db  35,  55,  40,  90,  50,  50
	dw PILOSWINE
	db 100, 100,  80,  50,  60,  60
	dw PINECO
	db  50,  65,  90,  15,  35,  35
	dw PINSIR
	db  65, 125, 100,  85,  55,  70
	dw POLITOED
	db  90,  75,  75,  70,  90, 100
	dw POLIWAG
	db  40,  50,  40,  90,  40,  40
	dw POLIWHIRL
	db  65,  65,  65,  90,  50,  50
	dw POLIWRATH
	db  90,  95,  95,  70,  70,  90
	dw PONYTA
	db  50,  85,  55,  90,  65,  65
	dw PONYTA_GALARIAN
	db  50,  85,  55,  90,  65,  65
	dw PORYGON
	db  65,  60,  70,  40,  85,  75
	dw PORYGON2
	db  85,  80,  90,  60, 105,  95
	dw PORYGON_Z
	db  85,  80,  70,  90, 135,  75
	dw PRIMEAPE
	db  65, 105,  60,  95,  60,  70
	dw PSYDUCK
	db  50,  52,  48,  55,  65,  50
	dw PUPITAR
	db  70,  84,  70,  51,  65,  70
	dw QUAGSIRE
	db  95,  85,  85,  35,  65,  65
	dw QUILAVA
	db  58,  64,  58,  80,  80,  65
	dw QWILFISH
	db  65,  95,  85,  85,  55,  55
	dw RAICHU
	db  60,  90,  55, 110,  90,  80
	dw RAICHU_ALOLAN
	db  60,  85,  50, 110,  95,  85
	dw RAIKOU
	db  90,  85,  75, 115, 115, 100
	dw RALTS
	db  28,  25,  25,  40,  45,  35
	dw RAMPARDOS
	db  97, 165,  60,  58,  65,  50
	dw RAPIDASH
	db  65, 100,  70, 105,  80,  80
	dw RAPIDASH_GALARIAN
	db  65, 100,  70, 105,  80,  80
	dw RATICATE
	db  55,  81,  60,  97,  50,  70
	dw RATICATE_ALOLAN
	db  75,  71,  70,  77,  40,  80
	dw RATTATA
	db  30,  56,  35,  72,  25,  35
	dw RATTATA_ALOLAN
	db  30,  56,  35,  72,  25,  35
	dw REMORAID
	db  35,  65,  35,  65,  65,  35
	dw RHYDON
	db 105, 130, 120,  40,  45,  45
	dw RHYHORN
	db  80,  85,  95,  25,  30,  30
	dw RHYPERIOR
	db 115, 140, 130,  40,  55,  55
	dw RIOLU
	db  40,  70,  40,  60,  35,  40
	dw ROOKIDEE
	db  38,  47,  35,  57,  33,  35
	dw SALAMENCE
	db  95, 135,  80, 100, 110,  80
	dw SALANDIT
	db  48,  44,  40,  77,  71,  40
	dw SALAZZLE
	db  68,  64,  60, 117, 111,  60
	dw SANDILE
	db  50,  72,  35,  65,  35,  35
	dw SANDSHREW
	db  50,  75,  85,  40,  20,  30
	dw SANDSHREW_ALOLAN
	db  50,  75,  90,  40,  10,  35
	dw SANDSLASH
	db  75, 100, 110,  65,  45,  55
	dw SANDSLASH_ALOLAN
	db  75, 100, 120,  65,  25,  65
	dw SCIZOR
	db  70, 130, 100,  65,  55,  80
	dw SCOLIPEDE
	db  60, 100,  89, 112,  55,  69
	dw SCRAFTY
	db  65,  90, 115,  58,  45, 115
	dw SCRAGGY
	db  50,  75,  70,  48,  35,  70
	dw SCYTHER
	db  70, 110,  80, 105,  55,  80
	dw SEADRA
	db  55,  65,  95,  85,  95,  45
	dw SEAKING
	db  80,  92,  65,  68,  65,  80
	dw SEALEO
	db  90,  60,  70,  45,  75,  70
	dw SEEL
	db  65,  45,  55,  45,  45,  70
	dw SENTRET
	db  35,  46,  34,  20,  35,  45
	dw SEVIPER
	db  73, 100,  60,  65, 100,  60
	dw SHELGON
	db  65,  95, 100,  50,  60,  50
	dw SHELLDER
	db  30,  65, 100,  40,  45,  25
	dw SHIELDON
	db  30,  42, 118,  30,  42,  88
	dw SHROOMISH
	db  60,  40,  60,  35,  40,  60
	dw SHUCKLE
	db  20,  10, 230,   5,  10, 230
	dw SHUPPET
	db  44,  75,  35,  45,  63,  33
	dw SIRFETCH_D
	db  62, 135,  95,  65,  68,  82
	dw SIZZLIPEDE
	db  50,  65,  45,  45,  50,  50
	dw SKARMORY
	db  65,  80, 140,  70,  40,  70
	dw SKIPLOOM
	db  55,  45,  50,  80,  45,  65
	dw SLOWBRO
	db  95,  75, 110,  30, 100,  80
	dw SLOWBRO_GALARIAN
	db  95, 100,  95,  30, 100,  70
	dw SLOWKING
	db  95,  75,  80,  30, 100, 110
	dw SLOWKING_GALARIAN
	db  95,  65,  80,  30, 110, 110
	dw SLOWPOKE
	db  90,  65,  65,  15,  40,  40
	dw SLOWPOKE_GALARIAN
	db  90,  65,  65,  15,  40,  40
	dw SLUGMA
	db  40,  40,  40,  20,  70,  40
	dw SMEARGLE
	db  55,  20,  35,  75,  20,  45
	dw SMOOCHUM
	db  45,  30,  15,  65,  85,  65
	dw SNEASEL
	db  55,  95,  55, 115,  35,  75
	dw SNEASEL_HISUIAN
	db  55,  95,  55, 115,  35,  75
	dw SNEASLER
	db  80, 130,  60, 120,  40,  80
	dw SNORLAX
	db 160, 110,  65,  30,  65, 110
	dw SNORUNT
	db  50,  50,  50,  50,  50,  50
	dw SNOVER
	db  60,  62,  50,  40,  62,  60
	dw SNUBBULL
	db  60,  80,  50,  30,  40,  40
	dw SPEAROW
	db  40,  60,  30,  70,  31,  31
	dw SPHEAL
	db  70,  40,  50,  25,  55,  50
	dw SPINARAK
	db  40,  60,  40,  30,  40,  40
	dw SPOINK
	db  60,  25,  35,  60,  70,  80
	dw SQUIRTLE
	db  44,  48,  65,  43,  50,  64
	dw SQUIRTLE_CLONE
	db  44,  48,  65,  43,  50,  64
	dw STANTLER
	db  73,  95,  62,  85,  85,  65
	dw STARAPTOR
	db  85, 120,  70, 100,  50,  60
	dw STARAVIA
	db  55,  75,  50,  80,  40,  40
	dw STARLY
	db  40,  55,  30,  60,  30,  30
	dw STARMIE
	db  60,  75,  85, 115, 100,  85
	dw STARYU
	db  30,  45,  55,  85,  70,  55
	dw STEELIX
	db  75,  85, 200,  30,  55,  65
	dw STEENEE
	db  52,  40,  48,  62,  40,  48
	dw SUDOWOODO
	db  70, 100, 115,  30,  30,  65
	dw SUICUNE
	db 100,  75, 115,  85,  90, 115
	dw SUNFLORA
	db  75,  75,  55,  30, 105,  85
	dw SUNKERN
	db  30,  30,  30,  30,  30,  30
	dw SWABLU
	db  45,  40,  60,  50,  40,  75
	dw SWINUB
	db  50,  50,  40,  50,  30,  30
	dw SYLVEON
	db  95,  65,  65,  60, 110, 130
	dw TALONFLAME
	db  78,  81,  71, 126,  74,  69
	dw TANGELA
	db  65,  55, 115,  60, 100,  40
	dw TANGROWTH
	db 100, 100, 125,  50, 110,  50
	dw TAUROS
	db  75, 100,  95, 110,  40,  70
	dw TAUROS_PALDEAN_FIRE
	db  75, 110, 105, 100,  30,  70
	dw TAUROS_PALDEAN_WATER
	db  75, 110, 105, 100,  30,  70
	dw TEDDIURSA
	db  60,  80,  50,  40,  50,  50
	dw TENTACOOL
	db  40,  40,  35,  70,  50, 100
	dw TENTACRUEL
	db  80,  70,  65, 100,  80, 120
	dw TIMBURR
	db  75,  80,  55,  35,  25,  35
	dw TINKATINK
	db  50,  45,  45,  58,  35,  64
	dw TINKATON
	db  85,  75,  77,  94,  70, 105
	dw TINKATUFF
	db  65,  55,  55,  78,  45,  82
	dw TIRTOUGA
	db  54,  78, 103,  22,  53,  45
	dw TOGEKISS
	db  85,  50,  95,  80, 120, 115
	dw TOGEPI
	db  35,  20,  65,  20,  40,  65
	dw TOGETIC
	db  55,  40,  85,  40,  80, 105
	dw TORKOAL
	db  70,  85, 140,  20,  85,  70
	dw TOTODILE
	db  50,  65,  64,  43,  44,  48
	dw TOXAPEX
	db  50,  63, 152,  35,  53, 142
	dw TOXICROAK
	db  83, 106,  65,  85,  86,  65
	dw TRAPINCH
	db  45, 100,  45,  10,  45,  45
	dw TSAREENA
	db  72, 120,  98,  72,  50,  98
	dw TYPHLOSION
	db  78,  84,  78, 100, 109,  85
	dw TYPHLOSION_HISUIAN
	db  73,  84,  78,  95, 119,  85
	dw TYRANITAR
	db 100, 134, 110,  61,  95, 100
	dw TYRANTRUM
	db  82, 121, 119,  71,  69,  59
	dw TYROGUE
	db  35,  35,  35,  35,  35,  35
	dw TYRUNT
	db  58,  89,  77,  48,  45,  45
	dw UMBREON
	db  95,  65, 110,  65,  60, 130
	dw UNOWN
	db  48,  72,  48,  48,  72,  48
	dw URSALUNA
	db 130, 140, 105,  50,  45,  80
	dw URSALUNABM
	db 113,  70, 120,  52, 135,  65
	dw URSARING
	db  90, 130,  75,  55,  75,  75
	dw VAPOREON
	db 130,  65,  60,  65, 110,  95
	dw VENIPEDE
	db  30,  45,  59,  57,  30,  39
	dw VENOMOTH
	db  70,  65,  60,  90,  90,  75
	dw VENONAT
	db  60,  55,  50,  45,  40,  55
	dw VENUSAUR
	db  80,  82,  83,  80, 100, 100
	dw VENUSAUR_CLONE
	db  80,  82,  83,  80, 100, 100
	dw VIBRAVA
	db  50,  70,  50,  70,  50,  50
	dw VICTREEBEL
	db  80, 105,  65,  70, 100,  70
	dw VIKAVOLT
	db  77,  70,  90,  43, 145,  75
	dw VILEPLUME
	db  75,  80,  85,  50, 110,  90
	dw VOLCARONA
	db  85,  60,  65, 100, 135, 105
	dw VOLTORB
	db  40,  30,  50, 100,  55,  55
	dw VOLTORB_HISUIAN
	db  40,  30,  50, 100,  55,  55
	dw VULPIX
	db  38,  41,  40,  65,  50,  65
	dw VULPIX_ALOLAN
	db  38,  41,  40,  65,  50,  65
	dw WALREIN
	db 110,  80,  90,  65,  95,  90
	dw WARTORTLE
	db  59,  63,  80,  58,  65,  80
	dw WARTORTLE_CLONE
	db  59,  63,  80,  58,  65,  80
	dw WEAVILE
	db  70, 120,  65, 125,  45,  85
	dw WEEDLE
	db  40,  35,  30,  50,  20,  20
	dw WEEPINBELL
	db  65,  90,  50,  55,  85,  45
	dw WEEZING
	db  65,  90, 120,  60,  85,  70
	dw WEEZING_GALARIAN
	db  65,  90, 120,  60,  85,  70
	dw WHIRLIPEDE
	db  40,  55,  99,  47,  40,  79
	dw WIGGLYTUFF
	db 140,  70,  45,  45,  85,  50
	dw WIMPOD
	db  25,  35,  40,  80,  20,  30
	dw WOBBUFFET
	db 190,  33,  58,  33,  33,  58
	dw WOOPER
	db  55,  45,  45,  15,  25,  25
	dw WOOPER_PALDEAN
	db  55,  45,  45,  15,  25,  25
	dw WYNAUT
	db  95,  23,  48,  23,  23,  48
	dw WYRDEER
	db 103, 105,  72,  65, 105,  75
	dw XATU
	db  65,  75,  70,  95,  95,  70
	dw YANMA
	db  65,  65,  45,  95,  75,  45
	dw YANMEGA
	db  86,  76,  86,  95, 116,  56
	dw ZANGOOSE
	db  73, 115,  60,  90,  60,  60
	dw ZAPDOS
	db  90,  90,  85, 100, 125,  90
	dw ZUBAT
	db  40,  45,  35,  55,  30,  40
	dw ZWEILOUS
	db  72,  85,  70,  58,  65,  70
	dw 0
