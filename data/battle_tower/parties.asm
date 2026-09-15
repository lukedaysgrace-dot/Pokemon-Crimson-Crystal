; Ten independently banked groups of 32 builds. The compact btmon records use
; placeholder PP and battle stats; the loader fills PP, forces perfect DVs,
; and recalculates stats before battle.
; Each 66-byte source record is NICKNAMED_MON_STRUCT_LENGTH + 5: species and
; moves are 16-bit here, and the loader converts them to the party struct's
; 8-bit fields. Keep Personality and the Hidden Power type between Level and Status.

MACRO btmon
	dw \1
	db \2
	dw \3, \4, \5, \6
	dw 0 ; OT ID
	dt 0 ; Exp is unused in the Battle Tower
	rept 5
		bigdw \8 ; Stat exp
	endr
	dn 15, 15, 15, 15 ; perfect DVs
	db 0, 0, 0, 0 ; PP is filled at runtime
	db 255 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db \7 ; Level
	db \9 ; Personality / ability slot
	db HIDDEN_POWER_DEFAULT_TYPE
	db 0, 0 ; Status
	rept 7
		bigdw 0 ; HP and stats are calculated at runtime
	endr
	db "@@@@@@@@@@@" ; replaced with the species name
ENDM

SECTION "Battle Tower Mons L10", ROMX

BattleTowerMons1:

	dw JOLTEON
	db MIRACLEBERRY
	dw THUNDERBOLT, HYPER_BEAM, SHADOW_BALL, ROAR

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 40000
	bigdw 35000
	bigdw 40000
	dn 13, 13, 11, 13 ; DVs
	db 15, 5, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 41 ; HP
	bigdw 41 ; Max HP
	bigdw 25 ; Atk
	bigdw 24 ; Def
	bigdw 37 ; Spd
	bigdw 34 ; SAtk
	bigdw 31 ; SDef
	db "SANDA-SU@@@"

	dw ESPEON
	db LEFTOVERS
	dw MUD_SLAP, PSYCHIC_M, PSYCH_UP, TOXIC

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 50000
	bigdw 35000
	bigdw 40000
	bigdw 40000
	dn 14, 13, 15, 11 ; DVs
	db 10, 10, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 39 ; HP
	bigdw 39 ; Max HP
	bigdw 26 ; Atk
	bigdw 24 ; Def
	bigdw 35 ; Spd
	bigdw 38 ; SAtk
	bigdw 31 ; SDef
	db "E-HUi@@@@@@"

	dw UMBREON
	db GOLD_BERRY
	dw SHADOW_BALL, IRON_TAIL, PSYCH_UP, TOXIC

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 45000
	bigdw 50000
	bigdw 40000
	dn 13, 11, 14, 15 ; DVs
	db 15, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 46 ; HP
	bigdw 46 ; Max HP
	bigdw 25 ; Atk
	bigdw 34 ; Def
	bigdw 26 ; Spd
	bigdw 25 ; SAtk
	bigdw 39 ; SDef
	db "BURAtuKI-@@"

	dw WOBBUFFET
	db FOCUS_BAND
	dw COUNTER, MIRROR_COAT, SAFEGUARD, DESTINY_BOND

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 7, 15, 13, 7 ; DVs
	db 20, 20, 25, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 66 ; HP
	bigdw 66 ; Max HP
	bigdw 18 ; Atk
	bigdw 25 ; Def
	bigdw 19 ; Spd
	bigdw 18 ; SAtk
	bigdw 23 ; SDef
	db "SO-NANSU@@@"

	dw KANGASKHAN
	db MIRACLEBERRY
	dw REVERSAL, HYPER_BEAM, EARTHQUAKE, ATTRACT

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 30000
	bigdw 40000
	bigdw 30000
	bigdw 30000
	dn 14, 15, 12, 15 ; DVs
	db 15, 5, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 47 ; HP
	bigdw 47 ; Max HP
	bigdw 31 ; Atk
	bigdw 29 ; Def
	bigdw 29 ; Spd
	bigdw 20 ; SAtk
	bigdw 28 ; SDef
	db "GARU-RA@@@@"

	dw CORSOLA
	db SCOPE_LENS
	dw SURF, PSYCHIC_M, RECOVER, ANCIENTPOWER

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 30000
	bigdw 33300
	bigdw 30000
	bigdw 30000
	dn 15, 14, 15, 13 ; DVs
	db 15, 10, 20, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 40 ; HP
	bigdw 40 ; Max HP
	bigdw 21 ; Atk
	bigdw 35 ; Def
	bigdw 19 ; Spd
	bigdw 29 ; SAtk
	bigdw 34 ; SDef
	db "SANI-GO@@@@"

	dw MILTANK
	db GOLD_BERRY
	dw BLIZZARD, EARTHQUAKE, HYPER_BEAM, TOXIC

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 35000
	dn 11, 11, 13, 15 ; DVs
	db 5, 10, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 46 ; HP
	bigdw 46 ; Max HP
	bigdw 27 ; Atk
	bigdw 32 ; Def
	bigdw 31 ; Spd
	bigdw 20 ; SAtk
	bigdw 26 ; SDef
	db "MIRUTANKU@@"

	dw AERODACTYL
	db LEFTOVERS
	dw HYPER_BEAM, SUPERSONIC, EARTHQUAKE, BITE

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 13, 11, 15, 11 ; DVs
	db 5, 20, 10, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 43 ; HP
	bigdw 43 ; Max HP
	bigdw 32 ; Atk
	bigdw 24 ; Def
	bigdw 38 ; Spd
	bigdw 23 ; SAtk
	bigdw 26 ; SDef
	db "PUTERA@@@@@"

	dw LAPRAS
	db MIRACLEBERRY
	dw BLIZZARD, SURF, THUNDERBOLT, PSYCHIC_M

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 15, 13, 14, 11 ; DVs
	db 5, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 52 ; HP
	bigdw 52 ; Max HP
	bigdw 29 ; Atk
	bigdw 27 ; Def
	bigdw 24 ; Spd
	bigdw 28 ; SAtk
	bigdw 30 ; SDef
	db "RAPURASU@@@"

	dw SNEASEL
	db GOLD_BERRY
	dw SLASH, FAINT_ATTACK, SURF, BLIZZARD

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 35000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 15, 11, 11, 15 ; DVs
	db 20, 20, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 38 ; HP
	bigdw 38 ; Max HP
	bigdw 31 ; Atk
	bigdw 22 ; Def
	bigdw 34 ; Spd
	bigdw 19 ; SAtk
	bigdw 27 ; SDef
	db "NIyu-RA@@@@"

	dw PORYGON2
	db BRIGHTPOWDER
	dw PSYCHIC_M, BLIZZARD, HYPER_BEAM, TRI_ATTACK

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 40000
	bigdw 30000
	bigdw 30000
	dn 15, 11, 13, 14 ; DVs
	db 10, 5, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 44 ; HP
	bigdw 44 ; Max HP
	bigdw 28 ; Atk
	bigdw 30 ; Def
	bigdw 23 ; Spd
	bigdw 33 ; SAtk
	bigdw 31 ; SDef
	db "PORIGON2@@@"

	dw MISDREAVUS
	db FOCUS_BAND
	dw PERISH_SONG, MEAN_LOOK, PAIN_SPLIT, SHADOW_BALL

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 14, 15, 13, 15 ; DVs
	db 5, 5, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 37 ; HP
	bigdw 37 ; Max HP
	bigdw 24 ; Atk
	bigdw 24 ; Def
	bigdw 28 ; Spd
	bigdw 29 ; SAtk
	bigdw 29 ; SDef
	db "MUUMA@@@@@@"

	dw HOUNDOUR
	db GOLD_BERRY
	dw FAINT_ATTACK, SOLARBEAM, ROAR, SUNNY_DAY

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 33000
	bigdw 30000
	dn 15, 13, 15, 14 ; DVs
	db 20, 10, 20, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 36 ; HP
	bigdw 36 ; Max HP
	bigdw 24 ; Atk
	bigdw 17 ; Def
	bigdw 25 ; Spd
	bigdw 28 ; SAtk
	bigdw 22 ; SDef
	db "DERUBIRU@@@"

	dw GIRAFARIG
	db KINGS_ROCK
	dw PSYBEAM, MUD_SLAP, SHADOW_BALL, AGILITY

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 14, 13, 15, 13 ; DVs
	db 20, 10, 15, 30 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 39 ; HP
	bigdw 39 ; Max HP
	bigdw 28 ; Atk
	bigdw 24 ; Def
	bigdw 29 ; Spd
	bigdw 29 ; SAtk
	bigdw 24 ; SDef
	db "KIRINRIKI@@"

	dw BLISSEY
	db QUICK_CLAW
	dw HEADBUTT, SOLARBEAM, ROLLOUT, STRENGTH

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 32000
	bigdw 40000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 13, 15, 12, 14 ; DVs
	db 15, 10, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 77 ; HP
	bigdw 77 ; Max HP
	bigdw 14 ; Atk
	bigdw 14 ; Def
	bigdw 22 ; Spd
	bigdw 27 ; SAtk
	bigdw 39 ; SDef
	db "HAPINASU@@@"

	dw SNORLAX
	db MIRACLEBERRY
	dw HEADBUTT, PROTECT, SNORE, SURF

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 14, 15, 15, 7 ; DVs
	db 15, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 57 ; HP
	bigdw 57 ; Max HP
	bigdw 34 ; Atk
	bigdw 25 ; Def
	bigdw 18 ; Spd
	bigdw 23 ; SAtk
	bigdw 32 ; SDef
	db "KABIGON@@@@"

	dw EXEGGUTOR
	db KINGS_ROCK
	dw TOXIC, GIGA_DRAIN, THIEF, CONFUSION

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 15, 14, 15, 14 ; DVs
	db 10, 5, 10, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 45 ; HP
	bigdw 45 ; Max HP
	bigdw 31 ; Atk
	bigdw 29 ; Def
	bigdw 23 ; Spd
	bigdw 37 ; SAtk
	bigdw 27 ; SDef
	db "NAtuSI-@@@@"

	dw HERACROSS
	db GOLD_BERRY
	dw REVERSAL, ENDURE, COUNTER, ROCK_SMASH

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 15, 7, 15, 7 ; DVs
	db 15, 10, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 43 ; HP
	bigdw 43 ; Max HP
	bigdw 37 ; Atk
	bigdw 25 ; Def
	bigdw 29 ; Spd
	bigdw 18 ; SAtk
	bigdw 29 ; SDef
	db "HERAKUROSU@"

	dw UNOWN
	db BERRY
	dw HIDDEN_POWER, 0, 0, 0

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 15, 15, 15, 15 ; DVs
	db 15, 0, 0, 0 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 38 ; HP
	bigdw 38 ; Max HP
	bigdw 33 ; Atk
	bigdw 23 ; Def
	bigdw 27 ; Spd
	bigdw 33 ; SAtk
	bigdw 23 ; SDef
	db "ANNO-N@@@@@"

	dw TAUROS
	db KINGS_ROCK
	dw HEADBUTT, SWAGGER, TAIL_WHIP, ICY_WIND

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 5, 5, 7 ; DVs
	db 15, 15, 30, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 40 ; HP
	bigdw 40 ; Max HP
	bigdw 30 ; Atk
	bigdw 29 ; Def
	bigdw 32 ; Spd
	bigdw 24 ; SAtk
	bigdw 24 ; SDef
	db "KENTAROSU@@"

	dw MR__MIME
	db QUICK_CLAW
	dw TOXIC, PSYCH_UP, FIRE_PUNCH, HEADBUTT

	dw 0 ; OT ID
	dt 1000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 3, 6, 7 ; DVs
	db 10, 10, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 10 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 36 ; HP
	bigdw 36 ; Max HP
	bigdw 17 ; Atk
	bigdw 22 ; Def
	bigdw 29 ; Spd
	bigdw 32 ; SAtk
	bigdw 34 ; SDef
	db "BARIYA-DO@@"


	btmon HONCHKROW, SCOPE_LENS, WING_ATTACK, FAINT_ATTACK, CONFUSE_RAY, HAZE, 10, 30000, ABILITY_1
	btmon AMBIPOM, KINGS_ROCK, HEADBUTT, SWIFT, THUNDER_WAVE, BATON_PASS, 10, 30000, ABILITY_1
	btmon FARIGIRAF, MIRACLEBERRY, PSYBEAM, STOMP, AGILITY, LIGHT_SCREEN, 10, 30000, ABILITY_1
	btmon LEAFEON, GOLD_BERRY, RAZOR_LEAF, QUICK_ATTACK, SAND_ATTACK, SYNTHESIS, 10, 30000, ABILITY_1
	btmon LOPUNNY, QUICK_CLAW, HEADBUTT, ICE_PUNCH, ATTRACT, AGILITY, 10, 30000, ABILITY_1
	btmon CRADILY, LEFTOVERS, GIGA_DRAIN, ANCIENTPOWER, RECOVER, TOXIC, 10, 30000, ABILITY_1
	btmon ARMALDO, FOCUS_BAND, ROCK_SLIDE, SLASH, FURY_CUTTER, PROTECT, 10, 30000, ABILITY_1
	btmon ALTARIA, BRIGHTPOWDER, DRAGONBREATH, FLY, SING, SAFEGUARD, 10, 30000, ABILITY_1
	btmon BRELOOM, MINT_BERRY, MACH_PUNCH, GIGA_DRAIN, STUN_SPORE, REST, 10, 30000, ABILITY_1
	btmon GRUMPIG, BERRY_JUICE, PSYBEAM, CONFUSE_RAY, LIGHT_SCREEN, HEADBUTT, 10, 30000, ABILITY_1
	btmon CARRACOSTA, MYSTIC_WATER, SURF, ROCK_SLIDE, WITHDRAW, PROTECT, 10, 30000, ABILITY_1

ASSERT @ - BattleTowerMons1 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L20", ROMX

BattleTowerMons2:

	dw UMBREON
	db LEFTOVERS
	dw PROTECT, TOXIC, MUD_SLAP, ATTRACT

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 12, 15, 11, 12 ; DVs
	db 10, 10, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 81 ; HP
	bigdw 81 ; Max HP
	bigdw 47 ; Atk
	bigdw 66 ; Def
	bigdw 46 ; Spd
	bigdw 45 ; SAtk
	bigdw 73 ; SDef
	db "BURAtuKI-@@"

	dw STARMIE
	db GOLD_BERRY
	dw RECOVER, PSYCHIC_M, SURF, PSYCH_UP

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 13, 11, 13, 11 ; DVs
	db 20, 10, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 71 ; HP
	bigdw 71 ; Max HP
	bigdw 51 ; Atk
	bigdw 54 ; Def
	bigdw 67 ; Spd
	bigdw 60 ; SAtk
	bigdw 54 ; SDef
	db "SUTA-MI-@@@"

	dw GYARADOS
	db MIRACLEBERRY
	dw HYPER_BEAM, DRAGON_RAGE, THUNDERBOLT, FIRE_BLAST

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 10, 15, 13 ; DVs
	db 5, 10, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 83 ; HP
	bigdw 83 ; Max HP
	bigdw 72 ; Atk
	bigdw 51 ; Def
	bigdw 54 ; Spd
	bigdw 45 ; SAtk
	bigdw 61 ; SDef
	db "GIyaRADOSU@"

	dw STEELIX
	db GOLD_BERRY
	dw ROAR, IRON_TAIL, SWAGGER, EARTHQUAKE

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	dn 15, 15, 15, 15 ; DVs
	db 20, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 77 ; HP
	bigdw 77 ; Max HP
	bigdw 63 ; Atk
	bigdw 102 ; Def
	bigdw 31 ; Spd
	bigdw 40 ; SAtk
	bigdw 48 ; SDef
	db "HAGANE-RU@@"

	dw ALAKAZAM
	db BERRY_JUICE
	dw PSYCHIC_M, PSYCH_UP, TOXIC, THUNDERPUNCH

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	bigdw 40000
	dn 15, 13, 14, 15 ; DVs
	db 10, 10, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 68 ; HP
	bigdw 68 ; Max HP
	bigdw 42 ; Atk
	bigdw 36 ; Def
	bigdw 69 ; Spd
	bigdw 75 ; SAtk
	bigdw 59 ; SDef
	db "HU-DEiN@@@@"

	dw ARCANINE
	db BRIGHTPOWDER
	dw FLAMETHROWER, ROAR, HYPER_BEAM, IRON_TAIL

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 35000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 11, 15, 11 ; DVs
	db 15, 20, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 81 ; HP
	bigdw 81 ; Max HP
	bigdw 64 ; Atk
	bigdw 52 ; Def
	bigdw 60 ; Spd
	bigdw 60 ; SAtk
	bigdw 52 ; SDef
	db "UINDEi@@@@@"

	dw HERACROSS
	db FOCUS_BAND
	dw ENDURE, REVERSAL, MEGAHORN, EARTHQUAKE

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 30000
	bigdw 45000
	bigdw 30000
	bigdw 45000
	dn 13, 15, 13, 14 ; DVs
	db 10, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 78 ; HP
	bigdw 78 ; Max HP
	bigdw 68 ; Atk
	bigdw 51 ; Def
	bigdw 52 ; Spd
	bigdw 37 ; SAtk
	bigdw 59 ; SDef
	db "HERAKUROSU@"

	dw EXEGGUTOR
	db LEFTOVERS
	dw HYPER_BEAM, PSYCHIC_M, TOXIC, DREAM_EATER

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 15, 13, 14, 11 ; DVs
	db 5, 10, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 83 ; HP
	bigdw 83 ; Max HP
	bigdw 60 ; Atk
	bigdw 55 ; Def
	bigdw 43 ; Spd
	bigdw 70 ; SAtk
	bigdw 50 ; SDef
	db "NAtuSI-@@@@"

	dw AERODACTYL
	db GOLD_BERRY
	dw REST, HYPER_BEAM, EARTHQUAKE, DRAGON_RAGE

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 15, 11, 11, 11 ; DVs
	db 10, 5, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 78 ; HP
	bigdw 78 ; Max HP
	bigdw 64 ; Atk
	bigdw 45 ; Def
	bigdw 72 ; Spd
	bigdw 44 ; SAtk
	bigdw 50 ; SDef
	db "PUTERA@@@@@"

	dw BLISSEY
	db BRIGHTPOWDER
	dw PSYCHIC_M, SUBMISSION, SOFTBOILED, COUNTER

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 30000
	bigdw 50000
	dn 11, 13, 15, 14 ; DVs
	db 10, 25, 10, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 148 ; HP
	bigdw 148 ; Max HP
	bigdw 24 ; Atk
	bigdw 22 ; Def
	bigdw 41 ; Spd
	bigdw 51 ; SAtk
	bigdw 75 ; SDef
	db "HAPINASU@@@"

	dw LAPRAS
	db GOLD_BERRY
	dw PSYCHIC_M, THUNDERBOLT, BLIZZARD, CONFUSE_RAY

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 30000
	bigdw 40000
	bigdw 55000
	bigdw 30000
	dn 15, 14, 13, 7 ; DVs
	db 10, 15, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 98 ; HP
	bigdw 98 ; Max HP
	bigdw 53 ; Atk
	bigdw 52 ; Def
	bigdw 45 ; Spd
	bigdw 50 ; SAtk
	bigdw 54 ; SDef
	db "RAPURASU@@@"

	dw PIKACHU
	db LIGHT_BALL
	dw THUNDERBOLT, THUNDER_WAVE, STRENGTH, TOXIC

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 15, 12, 15, 14 ; DVs
	db 15, 20, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 58 ; HP
	bigdw 58 ; Max HP
	bigdw 44 ; Atk
	bigdw 36 ; Def
	bigdw 58 ; Spd
	bigdw 41 ; SAtk
	bigdw 41 ; SDef
	db "PIKATIyuU@@"

	dw SCIZOR
	db FOCUS_BAND
	dw STEEL_WING, SLASH, TOXIC, SANDSTORM

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 45000
	bigdw 40000
	bigdw 45000
	bigdw 50000
	dn 15, 13, 15, 14 ; DVs
	db 25, 20, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 73 ; HP
	bigdw 73 ; Max HP
	bigdw 73 ; Atk
	bigdw 60 ; Def
	bigdw 47 ; Spd
	bigdw 43 ; SAtk
	bigdw 53 ; SDef
	db "HAtuSAMU@@@"

	dw HITMONCHAN
	db GOLD_BERRY
	dw THUNDERPUNCH, ICE_PUNCH, FIRE_PUNCH, MEGA_PUNCH

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 35000
	bigdw 50000
	bigdw 30000
	dn 15, 11, 15, 13 ; DVs
	db 15, 15, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 67 ; HP
	bigdw 67 ; Max HP
	bigdw 63 ; Atk
	bigdw 50 ; Def
	bigdw 52 ; Spd
	bigdw 32 ; SAtk
	bigdw 62 ; SDef
	db "EBIWARA-@@@"

	dw TAUROS
	db BRIGHTPOWDER
	dw THUNDERBOLT, EARTHQUAKE, HYPER_BEAM, BLIZZARD

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 30000
	bigdw 30000
	dn 15, 11, 14, 15 ; DVs
	db 15, 10, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 76 ; HP
	bigdw 76 ; Max HP
	bigdw 61 ; Atk
	bigdw 58 ; Def
	bigdw 63 ; Spd
	bigdw 47 ; SAtk
	bigdw 47 ; SDef
	db "KENTAROSU@@"

	dw AZUMARILL
	db MYSTIC_WATER
	dw SURF, BLIZZARD, ATTRACT, RAIN_DANCE

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 14, 13, 15, 7 ; DVs
	db 15, 5, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 86 ; HP
	bigdw 86 ; Max HP
	bigdw 40 ; Atk
	bigdw 52 ; Def
	bigdw 41 ; Spd
	bigdw 49 ; SAtk
	bigdw 49 ; SDef
	db "MARIRURI@@@"

	dw MILTANK
	db KINGS_ROCK
	dw EARTHQUAKE, THUNDER, ATTRACT, SURF

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 13, 15, 15, 14 ; DVs
	db 10, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 83 ; HP
	bigdw 83 ; Max HP
	bigdw 52 ; Atk
	bigdw 63 ; Def
	bigdw 61 ; Spd
	bigdw 36 ; SAtk
	bigdw 48 ; SDef
	db "MIRUTANKU@@"

	dw WIGGLYTUFF
	db GOLD_BERRY
	dw HYPER_BEAM, BLIZZARD, FIRE_BLAST, ATTRACT

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 12, 7, 15, 14 ; DVs
	db 5, 5, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 98 ; HP
	bigdw 98 ; Max HP
	bigdw 51 ; Atk
	bigdw 39 ; Def
	bigdw 43 ; Spd
	bigdw 58 ; SAtk
	bigdw 44 ; SDef
	db "PUKURIN@@@@"

	dw DRUNSPARCE
	db PINK_BOW
	dw PSYCHIC_M, SWAGGER, PSYCH_UP, HEADBUTT

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 12, 7, 7, 7 ; DVs
	db 10, 15, 10, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 97 ; HP
	bigdw 97 ; Max HP
	bigdw 50 ; Atk
	bigdw 38 ; Def
	bigdw 38 ; Spd
	bigdw 54 ; SAtk
	bigdw 40 ; SDef
	db "PUKURIN@@@@"

	dw NIDOKING
	db BERRY
	dw BLIZZARD, EARTHQUAKE, SURF, THUNDERPUNCH

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 5, 6, 4, 6 ; DVs
	db 5, 10, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 74 ; HP
	bigdw 74 ; Max HP
	bigdw 56 ; Atk
	bigdw 46 ; Def
	bigdw 49 ; Spd
	bigdw 52 ; SAtk
	bigdw 46 ; SDef
	db "NIDOKINGU@@"

	dw QUAGSIRE
	db QUICK_CLAW
	dw AMNESIA, EARTHQUAKE, SURF, RAIN_DANCE

	dw 0 ; OT ID
	dt 8000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 5, 5, 4, 7 ; DVs
	db 20, 10, 15, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 20 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 81 ; HP
	bigdw 81 ; Max HP
	bigdw 53 ; Atk
	bigdw 53 ; Def
	bigdw 29 ; Spd
	bigdw 42 ; SAtk
	bigdw 42 ; SDef
	db "NUO-@@@@@@@"


	btmon GARDEVOIR, TWISTEDSPOON, PSYCHIC_M, THUNDERBOLT, HYPNOSIS, REFLECT, 20, 35000, ABILITY_1
	btmon GALLADE, BLACKBELT, ZEN_HEADBUTT, DRAIN_PUNCH, SWORDS_DANCE, SHADOW_CLAW, 20, 35000, ABILITY_1
	btmon GLACEON, NEVERMELTICE, ICE_BEAM, BITE, MIRROR_COAT, HAIL, 20, 35000, ABILITY_1
	btmon MISMAGIUS, SPELL_TAG, SHADOW_BALL, PSYBEAM, PAIN_SPLIT, PERISH_SONG, 20, 35000, ABILITY_1
	btmon TANGROWTH, MIRACLE_SEED, GIGA_DRAIN, VINE_WHIP, SLEEP_POWDER, SYNTHESIS, 20, 35000, ABILITY_1
	btmon TOGEKISS, SHARP_BEAK, AIR_SLASH, DAZZLING_GLEAM, THUNDER_WAVE, ROOST, 20, 35000, ABILITY_1
	btmon YANMEGA, SILVERPOWDER, BUG_BUZZ, WING_ATTACK, ANCIENTPOWER, DETECT, 20, 35000, ABILITY_1
	btmon DUSCLOPS, EVIOLITE, NIGHT_SHADE, WILL_O_WISP, PAIN_SPLIT, PROTECT, 20, 35000, ABILITY_1
	btmon CAMERUPT, SOFT_SAND, FLAMETHROWER, MAGNITUDE, ROCK_SLIDE, AMNESIA, 20, 35000, ABILITY_1
	btmon FLYGON, DRAGON_FANG, DRAGONBREATH, DIG, CRUNCH, SANDSTORM, 20, 35000, ABILITY_1
	btmon WALREIN, LEFTOVERS, SURF, ICE_BEAM, REST, ROAR, 20, 35000, ABILITY_1

ASSERT @ - BattleTowerMons2 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L30", ROMX

BattleTowerMons3:

	dw JOLTEON
	db MIRACLEBERRY
	dw THUNDERBOLT, THUNDER_WAVE, ROAR, MUD_SLAP

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	dn 13, 11, 14, 13 ; DVs
	db 15, 20, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 103 ; HP
	bigdw 103 ; Max HP
	bigdw 68 ; Atk
	bigdw 64 ; Def
	bigdw 108 ; Spd
	bigdw 96 ; SAtk
	bigdw 87 ; SDef
	db "SANDA-SU@@@"

	dw POLIWRATH
	db BRIGHTPOWDER
	dw DOUBLE_TEAM, SURF, FISSURE, SUBMISSION

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 55000
	bigdw 55000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 15, 11 ; DVs
	db 15, 15, 5, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 119 ; HP
	bigdw 119 ; Max HP
	bigdw 87 ; Atk
	bigdw 87 ; Def
	bigdw 73 ; Spd
	bigdw 70 ; SAtk
	bigdw 82 ; SDef
	db "NIyoROBON@@"

	dw STARMIE
	db LEFTOVERS
	dw THUNDER_WAVE, PSYCHIC_M, RECOVER, SURF

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 15, 15, 15 ; DVs
	db 20, 10, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 101 ; HP
	bigdw 101 ; Max HP
	bigdw 75 ; Atk
	bigdw 81 ; Def
	bigdw 99 ; Spd
	bigdw 90 ; SAtk
	bigdw 81 ; SDef
	db "SUTA-MI-@@@"

	dw JYNX
	db GOLD_BERRY
	dw BLIZZARD, LOVELY_KISS, DREAM_EATER, ATTRACT

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	dn 15, 11, 14, 14 ; DVs
	db 5, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 109 ; HP
	bigdw 109 ; Max HP
	bigdw 54 ; Atk
	bigdw 49 ; Def
	bigdw 83 ; Spd
	bigdw 105 ; SAtk
	bigdw 87 ; SDef
	db "RU-ZIyuRA@@"

	dw DUGTRIO
	db KINGS_ROCK
	dw EARTHQUAKE, SLUDGE_BOMB, SLASH, MUD_SLAP

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	bigdw 50000
	dn 14, 15, 15, 15 ; DVs
	db 10, 10, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 82 ; HP
	bigdw 82 ; Max HP
	bigdw 90 ; Atk
	bigdw 56 ; Def
	bigdw 102 ; Spd
	bigdw 60 ; SAtk
	bigdw 72 ; SDef
	db "DAGUTORIO@@"

	dw BELLOSSOM
	db BRIGHTPOWDER
	dw GIGA_DRAIN, SUNNY_DAY, SOLARBEAM, DOUBLE_TEAM

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 15, 13, 11 ; DVs
	db 5, 5, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 109 ; HP
	bigdw 109 ; Max HP
	bigdw 76 ; Atk
	bigdw 87 ; Def
	bigdw 66 ; Spd
	bigdw 88 ; SAtk
	bigdw 88 ; SDef
	db "KIREIHANA@@"

	dw BLISSEY
	db LEFTOVERS
	dw TOXIC, REFLECT, SOFTBOILED, PROTECT

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 30000
	bigdw 45000
	bigdw 30000
	bigdw 45000
	dn 15, 11, 14, 13 ; DVs
	db 10, 20, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 217 ; HP
	bigdw 217 ; Max HP
	bigdw 32 ; Atk
	bigdw 33 ; Def
	bigdw 59 ; Spd
	bigdw 73 ; SAtk
	bigdw 109 ; SDef
	db "HAPINASU@@@"

	dw HOUNDOOM
	db CHARCOAL
	dw FLAMETHROWER, CRUNCH, SHADOW_BALL, DREAM_EATER

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 15, 13, 14, 13 ; DVs
	db 15, 15, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 108 ; HP
	bigdw 108 ; Max HP
	bigdw 90 ; Atk
	bigdw 59 ; Def
	bigdw 86 ; Spd
	bigdw 94 ; SAtk
	bigdw 76 ; SDef
	db "HERUGA-@@@@"

	dw MACHAMP
	db MIRACLEBERRY
	dw CROSS_CHOP, ICE_PUNCH, EARTHQUAKE, FIRE_BLAST

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 15, 13, 11, 14 ; DVs
	db 5, 15, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 118 ; HP
	bigdw 118 ; Max HP
	bigdw 108 ; Atk
	bigdw 75 ; Def
	bigdw 61 ; Spd
	bigdw 68 ; SAtk
	bigdw 80 ; SDef
	db "KAIRIKI-@@@"

	dw CROBAT
	db GOLD_BERRY
	dw ATTRACT, CONFUSE_RAY, TOXIC, WING_ATTACK

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 30000
	bigdw 50000
	dn 14, 15, 13, 12 ; DVs
	db 15, 10, 10, 35 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 111 ; HP
	bigdw 111 ; Max HP
	bigdw 84 ; Atk
	bigdw 74 ; Def
	bigdw 103 ; Spd
	bigdw 71 ; SAtk
	bigdw 77 ; SDef
	db "KUROBAtuTO@"

	dw PORYGON2
	db BRIGHTPOWDER
	dw PSYCHIC_M, RECOVER, HYPER_BEAM, TRI_ATTACK

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 30000
	bigdw 40000
	bigdw 55000
	bigdw 30000
	dn 13, 15, 13, 11 ; DVs
	db 10, 20, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 117 ; HP
	bigdw 117 ; Max HP
	bigdw 73 ; Atk
	bigdw 83 ; Def
	bigdw 66 ; Spd
	bigdw 87 ; SAtk
	bigdw 81 ; SDef
	db "PORIGON2@@@"

	dw MAROWAK
	db THICK_CLUB
	dw EARTHQUAKE, RETURN, HYPER_BEAM, BONEMERANG

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 30000
	dn 13, 13, 14, 11 ; DVs
	db 10, 20, 5, 10 ; PP
	db 255 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 99 ; HP
	bigdw 99 ; Max HP
	bigdw 77 ; Atk
	bigdw 94 ; Def
	bigdw 57 ; Spd
	bigdw 54 ; SAtk
	bigdw 72 ; SDef
	db "GARAGARA@@@"

	dw ELECTRODE
	db BRIGHTPOWDER
	dw LIGHT_SCREEN, THUNDERBOLT, PROTECT, THUNDER

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 45000
	bigdw 40000
	bigdw 45000
	bigdw 50000
	dn 11, 13, 14, 15 ; DVs
	db 30, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 98 ; HP
	bigdw 98 ; Max HP
	bigdw 57 ; Atk
	bigdw 69 ; Def
	bigdw 119 ; Spd
	bigdw 78 ; SAtk
	bigdw 78 ; SDef
	db "MARUMAIN@@@"

	dw LAPRAS
	db LEFTOVERS
	dw RAIN_DANCE, WATER_GUN, ICY_WIND, STRENGTH

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 35000
	bigdw 50000
	bigdw 30000
	dn 15, 13, 14, 11 ; DVs
	db 5, 25, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 142 ; HP
	bigdw 142 ; Max HP
	bigdw 80 ; Atk
	bigdw 74 ; Def
	bigdw 66 ; Spd
	bigdw 75 ; SAtk
	bigdw 81 ; SDef
	db "RAPURASU@@@"

	dw LANTURN
	db GOLD_BERRY
	dw RAIN_DANCE, THUNDER, SURF, FLAIL

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 30000
	bigdw 30000
	dn 13, 13, 14, 11 ; DVs
	db 5, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 139 ; HP
	bigdw 139 ; Max HP
	bigdw 62 ; Atk
	bigdw 71 ; Def
	bigdw 66 ; Spd
	bigdw 76 ; SAtk
	bigdw 70 ; SDef
	db "RANTA-N@@@@"

	dw ESPEON
	db MIRACLEBERRY
	dw CONFUSION, SWIFT, TOXIC, PSYCH_UP

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 14, 15, 15, 7 ; DVs
	db 25, 20, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 99 ; HP
	bigdw 99 ; Max HP
	bigdw 69 ; Atk
	bigdw 66 ; Def
	bigdw 96 ; Spd
	bigdw 104 ; SAtk
	bigdw 83 ; SDef
	db "E-HUi@@@@@@"

	dw TENTACRUEL
	db KINGS_ROCK
	dw WRAP, TOXIC, SLUDGE_BOMB, BUBBLEBEAM

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 47000
	bigdw 45000
	dn 15, 14, 15, 14 ; DVs
	db 20, 10, 10, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 110 ; HP
	bigdw 110 ; Max HP
	bigdw 71 ; Atk
	bigdw 69 ; Def
	bigdw 90 ; Spd
	bigdw 77 ; SAtk
	bigdw 101 ; SDef
	db "DOKUKURAGE@"

	dw GENGAR
	db GOLD_BERRY
	dw THIEF, LICK, NIGHT_SHADE, GIGA_DRAIN

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 7, 15, 7 ; DVs
	db 10, 30, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 101 ; HP
	bigdw 101 ; Max HP
	bigdw 68 ; Atk
	bigdw 62 ; Def
	bigdw 96 ; Spd
	bigdw 104 ; SAtk
	bigdw 71 ; SDef
	db "GENGA-@@@@@"

	dw URSARING
	db GOLD_BERRY
	dw HEADBUTT, PROTECT, ROAR, LEER

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 7, 4, 5 ; DVs
	db 15, 10, 20, 30 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 114 ; HP
	bigdw 114 ; Max HP
	bigdw 100 ; Atk
	bigdw 67 ; Def
	bigdw 53 ; Spd
	bigdw 65 ; SAtk
	bigdw 65 ; SDef
	db "RINGUMA@@@@"

	dw FEAROW
	db BRIGHTPOWDER
	dw MIRROR_MOVE, PURSUIT, PECK, SWIFT

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 7, 7, 7 ; DVs
	db 20, 20, 35, 20 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 96 ; HP
	bigdw 96 ; Max HP
	bigdw 87 ; Atk
	bigdw 61 ; Def
	bigdw 82 ; Spd
	bigdw 58 ; SAtk
	bigdw 58 ; SDef
	db "ONIDORIRU@@"

	dw PRIMEAPE
	db MIRACLEBERRY
	dw LOW_KICK, KARATE_CHOP, REVERSAL, FOCUS_ENERGY

	dw 0 ; OT ID
	dt 27000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 7, 6, 7 ; DVs
	db 20, 25, 15, 30 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 30 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 99 ; HP
	bigdw 99 ; Max HP
	bigdw 85 ; Atk
	bigdw 58 ; Def
	bigdw 84 ; Spd
	bigdw 58 ; SAtk
	bigdw 58 ; SDef
	db "OKORIZARU@@"


	btmon ELECTIVIRE, EXPERT_BELT, WILD_CHARGE, ICE_PUNCH, CROSS_CHOP, EARTHQUAKE, 30, 40000, ABILITY_1
	btmon MAGMORTAR, WISE_GLASSES, FLAMETHROWER, THUNDERBOLT, PSYCHIC_M, CONFUSE_RAY, 30, 40000, ABILITY_1
	btmon MAGNEZONE, LEFTOVERS, THUNDERBOLT, FLASH_CANNON, THUNDER_WAVE, LIGHT_SCREEN, 30, 40000, ABILITY_1
	btmon MAMOSWINE, NEVERMELTICE, ICICLE_CRASH, EARTHQUAKE, ICE_SHARD, ROCK_SLIDE, 30, 40000, ABILITY_1
	btmon PORYGON_Z, PINK_BOW, TRI_ATTACK, PSYCHIC_M, ICE_BEAM, AGILITY, 30, 40000, ABILITY_1
	btmon RHYPERIOR, HARD_STONE, EARTHQUAKE, ROCK_SLIDE, MEGAHORN, ROAR, 30, 40000, ABILITY_1
	btmon WEAVILE, SCOPE_LENS, NIGHT_SLASH, ICE_PUNCH, QUICK_ATTACK, SWORDS_DANCE, 30, 40000, ABILITY_1
	btmon SCOLIPEDE, KINGS_ROCK, X_SCISSOR, SLUDGE_BOMB, AGILITY, BATON_PASS, 30, 40000, ABILITY_1
	btmon GOLURK, SOFT_SAND, EARTHQUAKE, SHADOW_PUNCH, DYNAMICPUNCH, ROCK_SLIDE, 30, 40000, ABILITY_1
	btmon CONKELDURR, BLACKBELT, DRAIN_PUNCH, MACH_PUNCH, ROCK_SLIDE, BULK_UP, 30, 40000, ABILITY_1
	btmon DRIFBLIM, BRIGHTPOWDER, SHADOW_BALL, THUNDERBOLT, MINIMIZE, BATON_PASS, 30, 40000, ABILITY_1

ASSERT @ - BattleTowerMons3 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L40", ROMX

BattleTowerMons4:

	dw TAUROS
	db GOLD_BERRY
	dw RETURN, HYPER_BEAM, EARTHQUAKE, IRON_TAIL

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 15, 14 ; DVs
	db 20, 5, 10, 15 ; PP
	db 255 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 143 ; HP
	bigdw 143 ; Max HP
	bigdw 119 ; Atk
	bigdw 113 ; Def
	bigdw 127 ; Spd
	bigdw 94 ; SAtk
	bigdw 94 ; SDef
	db "KENTAROSU@@"

	dw KINGDRA
	db LEFTOVERS
	dw SURF, DRAGONBREATH, HYPER_BEAM, BLIZZARD

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 14, 15 ; DVs
	db 15, 20, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 142 ; HP
	bigdw 142 ; Max HP
	bigdw 115 ; Atk
	bigdw 113 ; Def
	bigdw 106 ; Spd
	bigdw 115 ; SAtk
	bigdw 115 ; SDef
	db "KINGUDORA@@"

	dw SNORLAX
	db QUICK_CLAW
	dw ATTRACT, BODY_SLAM, PSYCH_UP, EARTHQUAKE

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 14, 13, 13, 13 ; DVs
	db 15, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 206 ; HP
	bigdw 206 ; Max HP
	bigdw 126 ; Atk
	bigdw 89 ; Def
	bigdw 61 ; Spd
	bigdw 89 ; SAtk
	bigdw 125 ; SDef
	db "KABIGON@@@@"

	dw LAPRAS
	db LEFTOVERS
	dw THUNDERBOLT, ICE_BEAM, CONFUSE_RAY, SURF

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 14, 11 ; DVs
	db 15, 10, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 186 ; HP
	bigdw 186 ; Max HP
	bigdw 107 ; Atk
	bigdw 101 ; Def
	bigdw 86 ; Spd
	bigdw 104 ; SAtk
	bigdw 112 ; SDef
	db "RAPURASU@@@"

	dw STEELIX
	db GOLD_BERRY
	dw SANDSTORM, IRON_TAIL, EARTHQUAKE, TOXIC

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 14, 15, 13, 11 ; DVs
	db 10, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 138 ; HP
	bigdw 138 ; Max HP
	bigdw 122 ; Atk
	bigdw 199 ; Def
	bigdw 61 ; Spd
	bigdw 72 ; SAtk
	bigdw 88 ; SDef
	db "HAGANE-RU@@"

	dw ALAKAZAM
	db KINGS_ROCK
	dw PSYCHIC_M, THUNDERPUNCH, RECOVER, FIRE_PUNCH

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 14, 15 ; DVs
	db 10, 15, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 126 ; HP
	bigdw 126 ; Max HP
	bigdw 76 ; Atk
	bigdw 73 ; Def
	bigdw 135 ; Spd
	bigdw 147 ; SAtk
	bigdw 115 ; SDef
	db "HU-DEiN@@@@"

	dw STARMIE
	db LEFTOVERS
	dw BLIZZARD, THUNDERBOLT, SURF, PSYCHIC_M

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	dn 15, 13, 11, 14 ; DVs
	db 5, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 131 ; HP
	bigdw 131 ; Max HP
	bigdw 99 ; Atk
	bigdw 104 ; Def
	bigdw 128 ; Spd
	bigdw 117 ; SAtk
	bigdw 105 ; SDef
	db "SUTA-MI-@@@"

	dw WOBBUFFET
	db GOLD_BERRY
	dw COUNTER, MIRROR_COAT, SAFEGUARD, DESTINY_BOND

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 11, 15, 14, 7 ; DVs
	db 20, 20, 25, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 233 ; HP
	bigdw 233 ; Max HP
	bigdw 62 ; Atk
	bigdw 85 ; Def
	bigdw 65 ; Spd
	bigdw 59 ; SAtk
	bigdw 79 ; SDef
	db "SO-NANSU@@@"

	dw GOLEM
	db FOCUS_BAND
	dw EXPLOSION, EARTHQUAKE, MEGA_PUNCH, ROCK_SLIDE

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 13, 13, 14, 13 ; DVs
	db 5, 10, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 145 ; HP
	bigdw 145 ; Max HP
	bigdw 133 ; Atk
	bigdw 139 ; Def
	bigdw 74 ; Spd
	bigdw 80 ; SAtk
	bigdw 88 ; SDef
	db "GORO-NIya@@"

	dw SCIZOR
	db SCOPE_LENS
	dw SLASH, STEEL_WING, PURSUIT, HYPER_BEAM

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	dn 11, 13, 15, 14 ; DVs
	db 20, 25, 20, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 139 ; HP
	bigdw 139 ; Max HP
	bigdw 140 ; Atk
	bigdw 117 ; Def
	bigdw 89 ; Spd
	bigdw 82 ; SAtk
	bigdw 102 ; SDef
	db "HAtuSAMU@@@"

	dw DUGTRIO
	db KINGS_ROCK
	dw EARTHQUAKE, HYPER_BEAM, SLUDGE_BOMB, MUD_SLAP

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 11, 11 ; DVs
	db 10, 5, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 108 ; HP
	bigdw 108 ; Max HP
	bigdw 119 ; Atk
	bigdw 78 ; Def
	bigdw 132 ; Spd
	bigdw 76 ; SAtk
	bigdw 92 ; SDef
	db "DAGUTORIO@@"

	dw SLOWBRO
	db MIRACLEBERRY
	dw SURF, PSYCHIC_M, EARTHQUAKE, BLIZZARD

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 11, 15, 12, 15 ; DVs
	db 15, 10, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 157 ; HP
	bigdw 157 ; Max HP
	bigdw 96 ; Atk
	bigdw 126 ; Def
	bigdw 61 ; Spd
	bigdw 119 ; SAtk
	bigdw 103 ; SDef
	db "YADORAN@@@@"

	dw PORYGON2
	db NO_ITEM
	dw CONVERSION2, CONVERSION, PSYBEAM, THIEF

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 11, 12, 14, 15 ; DVs
	db 30, 30, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 147 ; HP
	bigdw 147 ; Max HP
	bigdw 99 ; Atk
	bigdw 109 ; Def
	bigdw 86 ; Spd
	bigdw 123 ; SAtk
	bigdw 115 ; SDef
	db "PORIGON2@@@"

	dw ARCANINE
	db CHARCOAL
	dw FLAME_WHEEL, LEER, BODY_SLAM, ROAR

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 11, 11 ; DVs
	db 25, 30, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 153 ; HP
	bigdw 153 ; Max HP
	bigdw 127 ; Atk
	bigdw 102 ; Def
	bigdw 112 ; Spd
	bigdw 116 ; SAtk
	bigdw 100 ; SDef
	db "UINDEi@@@@@"

	dw FORRETRESS
	db LEFTOVERS
	dw RAPID_SPIN, PROTECT, TOXIC, SANDSTORM

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 10, 7, 15 ; DVs
	db 40, 10, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 141 ; HP
	bigdw 141 ; Max HP
	bigdw 111 ; Atk
	bigdw 147 ; Def
	bigdw 65 ; Spd
	bigdw 87 ; SAtk
	bigdw 87 ; SDef
	db "HUoRETOSU@@"

	dw OMASTAR
	db GOLD_BERRY
	dw CURSE, WATER_GUN, ANCIENTPOWER, ROCK_SMASH

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 14, 15, 15, 7 ; DVs
	db 10, 25, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 134 ; HP
	bigdw 134 ; Max HP
	bigdw 86 ; Atk
	bigdw 139 ; Def
	bigdw 83 ; Spd
	bigdw 125 ; SAtk
	bigdw 89 ; SDef
	db "OMUSUTA-@@@"

	dw CHARIZARD
	db KINGS_ROCK
	dw FIRE_SPIN, DRAGON_RAGE, FLY, SLASH

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 14 ; DVs
	db 15, 10, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 142 ; HP
	bigdw 142 ; Max HP
	bigdw 106 ; Atk
	bigdw 101 ; Def
	bigdw 119 ; Spd
	bigdw 126 ; SAtk
	bigdw 106 ; SDef
	db "RIZA-DON@@@"

	dw EXEGGUTOR
	db BRIGHTPOWDER
	dw EGG_BOMB, STOMP, PSYCH_UP, CONFUSION

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 7, 14, 7 ; DVs
	db 10, 20, 10, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 158 ; HP
	bigdw 158 ; Max HP
	bigdw 115 ; Atk
	bigdw 101 ; Def
	bigdw 82 ; Spd
	bigdw 133 ; SAtk
	bigdw 93 ; SDef
	db "NAtuSI-@@@@"

	dw HYPNO
	db BRIGHTPOWDER
	dw CONFUSION, THUNDERPUNCH, HEADBUTT, DISABLE

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 7, 7, 10 ; DVs
	db 25, 15, 15, 20 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 146 ; HP
	bigdw 146 ; Max HP
	bigdw 86 ; Atk
	bigdw 83 ; Def
	bigdw 81 ; Spd
	bigdw 88 ; SAtk
	bigdw 122 ; SDef
	db "SURI-PA-@@@"

	dw MUK
	db QUICK_CLAW
	dw SCREECH, TOXIC, SLUDGE, HARDEN

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 5, 6, 11 ; DVs
	db 40, 10, 20, 30 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 161 ; HP
	bigdw 161 ; Max HP
	bigdw 111 ; Atk
	bigdw 86 ; Def
	bigdw 67 ; Spd
	bigdw 83 ; SAtk
	bigdw 111 ; SDef
	db "BETOBETON@@"

	dw ELECTABUZZ
	db KINGS_ROCK
	dw LIGHT_SCREEN, THUNDERPUNCH, SWIFT, SNORE

	dw 0 ; OT ID
	dt 64000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 5, 7, 7 ; DVs
	db 30, 15, 20, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 40 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 124 ; HP
	bigdw 124 ; Max HP
	bigdw 93 ; Atk
	bigdw 71 ; Def
	bigdw 111 ; Spd
	bigdw 103 ; SAtk
	bigdw 95 ; SDef
	db "EREBU-@@@@@"


	btmon VOLCARONA, FOCUS_BAND, BUG_BUZZ, FLAMETHROWER, GIGA_DRAIN, QUIVER_DANCE, 40, 45000, ABILITY_1
	btmon HYDREIGON, DRAGON_FANG, DARK_PULSE, DRAGON_PULSE, FLAMETHROWER, SURF, 40, 45000, ABILITY_1
	btmon DRAGAPULT, SPELL_TAG, DRAGON_CLAW, SHADOW_CLAW, U_TURN, QUICK_ATTACK, 40, 45000, ABILITY_1
	btmon GRIMMSNARL, LEFTOVERS, SPIRIT_BREAK, SUCKER_PUNCH, THUNDER_WAVE, LIGHT_SCREEN, 40, 45000, ABILITY_1
	btmon TINKATON, KINGS_ROCK, PLAY_ROUGH, IRON_HEAD, KNOCK_OFF, THUNDER_WAVE, 40, 45000, ABILITY_1
	btmon BAXCALIBUR, NEVERMELTICE, ICICLE_CRASH, DRAGON_CLAW, EARTHQUAKE, DRAGON_DANCE, 40, 45000, ABILITY_1
	btmon ARMAROUGE, TWISTEDSPOON, FLAMETHROWER, PSYCHIC_M, AURA_SPHERE, CALM_MIND, 40, 45000, ABILITY_1
	btmon CERULEDGE, CHARCOAL, FLARE_BLITZ, SHADOW_CLAW, CLOSE_COMBAT, SWORDS_DANCE, 40, 45000, ABILITY_1
	btmon CORVIKNIGHT, ROCKY_HELMET, BRAVE_BIRD, IRON_HEAD, ROOST, BULK_UP, 40, 45000, ABILITY_1
	btmon HYDRAPPLE, MIRACLE_SEED, GIGA_DRAIN, DRAGON_PULSE, EARTH_POWER, SLUDGE_BOMB, 40, 45000, ABILITY_1
	btmon ARCHALUDON, METAL_COAT, FLASH_CANNON, DRAGON_PULSE, THUNDERBOLT, ROAR, 40, 45000, ABILITY_1

ASSERT @ - BattleTowerMons4 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L50", ROMX

BattleTowerMons5:

	dw KINGDRA
	db GOLD_BERRY
	dw SURF, HYPER_BEAM, BLIZZARD, DRAGONBREATH

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 55000
	bigdw 60000
	bigdw 50000
	bigdw 55000
	dn 13, 13, 15, 15 ; DVs
	db 15, 5, 5, 20 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 179 ; HP
	bigdw 179 ; Max HP
	bigdw 142 ; Atk
	bigdw 143 ; Def
	bigdw 133 ; Spd
	bigdw 144 ; SAtk
	bigdw 144 ; SDef
	db "KINGUDORA@@"

	dw HOUNDOOM
	db MIRACLEBERRY
	dw REST, CRUNCH, DREAM_EATER, FLAMETHROWER

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	dn 13, 13, 15, 12 ; DVs
	db 10, 15, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 178 ; HP
	bigdw 178 ; Max HP
	bigdw 146 ; Atk
	bigdw 98 ; Def
	bigdw 145 ; Spd
	bigdw 157 ; SAtk
	bigdw 127 ; SDef
	db "HERUGA-@@@@"

	dw SHUCKLE
	db LEFTOVERS
	dw SANDSTORM, REST, TOXIC, WRAP

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 55000
	dn 15, 13, 12, 15 ; DVs
	db 10, 10, 10, 20 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 123 ; HP
	bigdw 123 ; Max HP
	bigdw 60 ; Atk
	bigdw 278 ; Def
	bigdw 52 ; Spd
	bigdw 59 ; SAtk
	bigdw 279 ; SDef
	db "TUBOTUBO@@@"

	dw SNORLAX
	db LEFTOVERS
	dw HYPER_BEAM, EARTHQUAKE, SURF, PSYCH_UP

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 55000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	dn 15, 13, 14, 15 ; DVs
	db 5, 10, 15, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 263 ; HP
	bigdw 263 ; Max HP
	bigdw 159 ; Atk
	bigdw 112 ; Def
	bigdw 79 ; Spd
	bigdw 114 ; SAtk
	bigdw 159 ; SDef
	db "KABIGON@@@@"

	dw LAPRAS
	db GOLD_BERRY
	dw THUNDERBOLT, SURF, CONFUSE_RAY, BLIZZARD

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 60000
	bigdw 60000
	bigdw 55000
	bigdw 60000
	dn 13, 13, 13, 13 ; DVs
	db 15, 15, 10, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 234 ; HP
	bigdw 234 ; Max HP
	bigdw 133 ; Atk
	bigdw 128 ; Def
	bigdw 107 ; Spd
	bigdw 133 ; SAtk
	bigdw 143 ; SDef
	db "RAPURASU@@@"

	dw JOLTEON
	db KINGS_ROCK
	dw THUNDERBOLT, THUNDER_WAVE, SHADOW_BALL, HIDDEN_POWER

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 60000
	bigdw 57000
	bigdw 55000
	bigdw 55000
	dn 14, 13, 15, 15 ; DVs
	db 15, 20, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 161 ; HP
	bigdw 161 ; Max HP
	bigdw 114 ; Atk
	bigdw 107 ; Def
	bigdw 179 ; Spd
	bigdw 159 ; SAtk
	bigdw 144 ; SDef
	db "SANDA-SU@@@"

	dw SCIZOR
	db LEFTOVERS
	dw HYPER_BEAM, SLASH, AGILITY, METAL_CLAW

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 13, 15, 14, 13 ; DVs
	db 5, 20, 30, 35 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 169 ; HP
	bigdw 169 ; Max HP
	bigdw 176 ; Atk
	bigdw 145 ; Def
	bigdw 112 ; Spd
	bigdw 99 ; SAtk
	bigdw 124 ; SDef
	db "HAtuSAMU@@@"

	dw SLOWKING
	db MINT_BERRY
	dw REST, SURF, PSYCHIC_M, AMNESIA

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 13, 15, 13, 14 ; DVs
	db 10, 15, 10, 20 ; PP
	db 15 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 197 ; HP
	bigdw 197 ; Max HP
	bigdw 118 ; Atk
	bigdw 126 ; Def
	bigdw 76 ; Spd
	bigdw 147 ; SAtk
	bigdw 157 ; SDef
	db "YADOKINGU@@"

	dw MACHAMP
	db GOLD_BERRY
	dw CROSS_CHOP, EARTHQUAKE, FIRE_BLAST, THUNDERPUNCH

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 44000
	dn 15, 15, 14, 12 ; DVs
	db 5, 10, 5, 15 ; PP
	db 13 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 187 ; HP
	bigdw 187 ; Max HP
	bigdw 176 ; Atk
	bigdw 128 ; Def
	bigdw 99 ; Spd
	bigdw 108 ; SAtk
	bigdw 128 ; SDef
	db "KAIRIKI-@@@"

	dw STARMIE
	db SCOPE_LENS
	dw THUNDER_WAVE, RECOVER, THUNDERBOLT, SURF

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 44000
	bigdw 40000
	bigdw 45000
	bigdw 40000
	dn 15, 15, 15, 15 ; DVs
	db 20, 20, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 161 ; HP
	bigdw 161 ; Max HP
	bigdw 121 ; Atk
	bigdw 130 ; Def
	bigdw 161 ; Spd
	bigdw 145 ; SAtk
	bigdw 130 ; SDef
	db "SUTA-MI-@@@"

	dw DUGTRIO
	db KINGS_ROCK
	dw EARTHQUAKE, SLASH, HYPER_BEAM, SLUDGE_BOMB

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	dn 15, 7, 15, 14 ; DVs
	db 10, 20, 5, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 135 ; HP
	bigdw 135 ; Max HP
	bigdw 145 ; Atk
	bigdw 90 ; Def
	bigdw 166 ; Spd
	bigdw 97 ; SAtk
	bigdw 117 ; SDef
	db "DAGUTORIO@@"

	dw ELECTRODE
	db MIRACLEBERRY
	dw THUNDERBOLT, EXPLOSION, MIRROR_COAT, REST

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 54000
	bigdw 40000
	bigdw 50000
	dn 7, 13, 15, 14 ; DVs
	db 15, 5, 20, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 162 ; HP
	bigdw 162 ; Max HP
	bigdw 88 ; Atk
	bigdw 117 ; Def
	bigdw 195 ; Spd
	bigdw 127 ; SAtk
	bigdw 127 ; SDef
	db "MARUMAIN@@@"

	dw AERODACTYL
	db KINGS_ROCK
	dw HYPER_BEAM, EARTHQUAKE, FIRE_BLAST, IRON_TAIL

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 15, 13, 13, 13 ; DVs
	db 5, 10, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 181 ; HP
	bigdw 181 ; Max HP
	bigdw 153 ; Atk
	bigdw 111 ; Def
	bigdw 174 ; Spd
	bigdw 104 ; SAtk
	bigdw 119 ; SDef
	db "PUTERA@@@@@"

	dw CROBAT
	db LEFTOVERS
	dw CONFUSE_RAY, ATTRACT, HYPER_BEAM, TOXIC

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 40000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	dn 14, 15, 15, 15 ; DVs
	db 10, 15, 5, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 178 ; HP
	bigdw 178 ; Max HP
	bigdw 134 ; Atk
	bigdw 128 ; Def
	bigdw 175 ; Spd
	bigdw 118 ; SAtk
	bigdw 128 ; SDef
	db "KUROBAtuTO@"

	dw TOGEKISS
	db MIRACLEBERRY
	dw AIR_SLASH, DAZZLING_GLEAM, THUNDER_WAVE, ROOST

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 40000
	bigdw 50000
	dn 15, 13, 13, 14 ; DVs
	db 20, 15, 20, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 190 ; HP
	bigdw 190 ; Max HP
	bigdw 138 ; Atk
	bigdw 129 ; Def
	bigdw 143 ; Spd
	bigdw 172 ; SAtk
	bigdw 137 ; SDef
	db "SANDA-@@@@@"

	dw SKARMORY
	db GOLD_BERRY
	dw SANDSTORM, FLY, STEEL_WING, TOXIC

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 40000
	dn 13, 7, 14, 13 ; DVs
	db 10, 15, 25, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 184 ; HP
	bigdw 184 ; Max HP
	bigdw 136 ; Atk
	bigdw 180 ; Def
	bigdw 117 ; Spd
	bigdw 83 ; SAtk
	bigdw 113 ; SDef
	db "EA-MUDO@@@@"

	dw FORRETRESS
	db LEFTOVERS
	dw SANDSTORM, TOXIC, EXPLOSION, SWAGGER

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 45000
	bigdw 40000
	dn 12, 15, 13, 13 ; DVs
	db 10, 10, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 170 ; HP
	bigdw 170 ; Max HP
	bigdw 135 ; Atk
	bigdw 189 ; Def
	bigdw 84 ; Spd
	bigdw 103 ; SAtk
	bigdw 103 ; SDef
	db "HUoRETOSU@@"

	dw STEELIX
	db MIRACLEBERRY
	dw SANDSTORM, IRON_TAIL, REST, EARTHQUAKE

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 40000
	bigdw 45000
	dn 13, 13, 13, 13 ; DVs
	db 10, 15, 10, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 176 ; HP
	bigdw 176 ; Max HP
	bigdw 151 ; Atk
	bigdw 246 ; Def
	bigdw 73 ; Spd
	bigdw 89 ; SAtk
	bigdw 109 ; SDef
	db "HAGANE-RU@@"

	dw GIRAFARIG
	db SCOPE_LENS
	dw DREAM_EATER, CRUNCH, PSYCHIC_M, EARTHQUAKE

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 4, 5, 5, 6 ; DVs
	db 15, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 161 ; HP
	bigdw 161 ; Max HP
	bigdw 114 ; Atk
	bigdw 100 ; Def
	bigdw 120 ; Spd
	bigdw 126 ; SAtk
	bigdw 101 ; SDef
	db "KIRINRIKI@@"

	dw GYARADOS
	db MIRACLEBERRY
	dw HYPER_BEAM, SURF, RAIN_DANCE, ZAP_CANNON

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 7, 5, 6, 5 ; DVs
	db 5, 15, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 193 ; HP
	bigdw 193 ; Max HP
	bigdw 162 ; Atk
	bigdw 114 ; Def
	bigdw 117 ; Spd
	bigdw 95 ; SAtk
	bigdw 135 ; SDef
	db "GIyaRADOSU@"

	dw GLACEON
	db GOLD_BERRY
	dw BLIZZARD, SHADOW_BALL, MIRROR_COAT, HAIL

	dw 0 ; OT ID
	dt 125000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	bigdw 40000
	dn 4, 5, 5, 6 ; DVs
	db 5, 5, 20, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 50 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 181 ; HP
	bigdw 181 ; Max HP
	bigdw 109 ; Atk
	bigdw 135 ; Def
	bigdw 130 ; Spd
	bigdw 131 ; SAtk
	bigdw 161 ; SDef
	db "HURI-ZA-@@@"


	btmon ABOMASNOW, NEVERMELTICE, BLIZZARD, GIGA_DRAIN, EARTHQUAKE, LEECH_SEED, 50, 50000, ABILITY_1
	btmon APPLETUN, LEFTOVERS, ENERGY_BALL, DRAGON_PULSE, RECOVER, TOXIC, 50, 50000, ABILITY_1
	btmon FLAPPLE, MIRACLE_SEED, LEAF_BLADE, DRAGON_CLAW, FLY, DRAGON_DANCE, 50, 50000, ABILITY_1
	btmon CENTISKORCH, CHARCOAL, FLAMETHROWER, X_SCISSOR, CRUNCH, SUNNY_DAY, 50, 50000, ABILITY_1
	btmon VIKAVOLT, MAGNET, THUNDERBOLT, BUG_BUZZ, ENERGY_BALL, AGILITY, 50, 50000, ABILITY_1
	btmon TOXICROAK, BLACKBELT, DRAIN_PUNCH, SLUDGE_BOMB, SUCKER_PUNCH, BULK_UP, 50, 50000, ABILITY_1
	btmon EXCADRILL, SOFT_SAND, EARTHQUAKE, IRON_HEAD, ROCK_SLIDE, SWORDS_DANCE, 50, 50000, ABILITY_1
	btmon TALONFLAME, SHARP_BEAK, BRAVE_BIRD, FLARE_BLITZ, ROOST, U_TURN, 50, 50000, ABILITY_1
	btmon FROSLASS, BRIGHTPOWDER, ICE_BEAM, SHADOW_BALL, THUNDER_WAVE, DESTINY_BOND, 50, 50000, ABILITY_1
	btmon GOLISOPOD, FOCUS_SASH, LIQUIDATION, X_SCISSOR, SUCKER_PUNCH, BRICK_BREAK, 50, 50000, ABILITY_1
	btmon BISHARP, SCOPE_LENS, IRON_HEAD, NIGHT_SLASH, SUCKER_PUNCH, SWORDS_DANCE, 50, 50000, ABILITY_1

ASSERT @ - BattleTowerMons5 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L60", ROMX

BattleTowerMons6:

	dw KINGDRA
	db LEFTOVERS
	dw DRAGONBREATH, SURF, HYPER_BEAM, BLIZZARD

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 55000
	bigdw 50000
	bigdw 60000
	bigdw 60000
	dn 13, 13, 15, 14 ; DVs
	db 20, 15, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 211 ; HP
	bigdw 211 ; Max HP
	bigdw 169 ; Atk
	bigdw 168 ; Def
	bigdw 161 ; Spd
	bigdw 172 ; SAtk
	bigdw 172 ; SDef
	db "KINGUDORA@@"

	dw TYRANITAR
	db GOLD_BERRY
	dw CRUNCH, EARTHQUAKE, ROCK_SLIDE, HYPER_BEAM

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 60000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	dn 15, 13, 14, 13 ; DVs
	db 15, 10, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 240 ; HP
	bigdw 240 ; Max HP
	bigdw 220 ; Atk
	bigdw 187 ; Def
	bigdw 131 ; Spd
	bigdw 169 ; SAtk
	bigdw 175 ; SDef
	db "BANGIRASU@@"

	dw HOUNDOOM
	db MIRACLEBERRY
	dw FLAMETHROWER, CRUNCH, DREAM_EATER, REST

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 55000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	dn 15, 11, 14, 15 ; DVs
	db 15, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 212 ; HP
	bigdw 212 ; Max HP
	bigdw 177 ; Atk
	bigdw 113 ; Def
	bigdw 172 ; Spd
	bigdw 189 ; SAtk
	bigdw 153 ; SDef
	db "HERUGA-@@@@"

	dw PORYGON2
	db LEFTOVERS
	dw BLIZZARD, RECOVER, TOXIC, PSYCHIC_M

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	dn 13, 13, 13, 14 ; DVs
	db 5, 20, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 223 ; HP
	bigdw 223 ; Max HP
	bigdw 150 ; Atk
	bigdw 162 ; Def
	bigdw 126 ; Spd
	bigdw 182 ; SAtk
	bigdw 170 ; SDef
	db "PORIGON2@@@"

	dw MACHAMP
	db QUICK_CLAW
	dw FIRE_PUNCH, CROSS_CHOP, THUNDERPUNCH, EARTHQUAKE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 14, 15 ; DVs
	db 15, 5, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 227 ; HP
	bigdw 227 ; Max HP
	bigdw 212 ; Atk
	bigdw 148 ; Def
	bigdw 121 ; Spd
	bigdw 134 ; SAtk
	bigdw 158 ; SDef
	db "KAIRIKI-@@@"

	dw MAGNEZONE
	db MINT_BERRY
	dw REST, FLASH_CANNON, THUNDERBOLT, THUNDER_WAVE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 15, 13 ; DVs
	db 10, 20, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 229 ; HP
	bigdw 229 ; Max HP
	bigdw 160 ; Atk
	bigdw 156 ; Def
	bigdw 177 ; Spd
	bigdw 204 ; SAtk
	bigdw 162 ; SDef
	db "SANDA-@@@@@"

	dw WOBBUFFET
	db GOLD_BERRY
	dw COUNTER, MIRROR_COAT, DESTINY_BOND, SAFEGUARD

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	dn 15, 13, 14, 13 ; DVs
	db 20, 20, 5, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 347 ; HP
	bigdw 347 ; Max HP
	bigdw 96 ; Atk
	bigdw 122 ; Def
	bigdw 95 ; Spd
	bigdw 92 ; SAtk
	bigdw 122 ; SDef
	db "SO-NANSU@@@"

	dw AERODACTYL
	db LEFTOVERS
	dw HYPER_BEAM, SUPERSONIC, EARTHQUAKE, BITE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 15, 13, 13, 13 ; DVs
	db 5, 20, 10, 25 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 215 ; HP
	bigdw 215 ; Max HP
	bigdw 182 ; Atk
	bigdw 132 ; Def
	bigdw 208 ; Spd
	bigdw 124 ; SAtk
	bigdw 142 ; SDef
	db "PUTERA@@@@@"

	dw DRAGONITE
	db MIRACLEBERRY
	dw HYPER_BEAM, ICY_WIND, THUNDERBOLT, SURF

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 13, 13, 15, 13 ; DVs
	db 5, 15, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 229 ; HP
	bigdw 229 ; Max HP
	bigdw 215 ; Atk
	bigdw 164 ; Def
	bigdw 152 ; Spd
	bigdw 172 ; SAtk
	bigdw 172 ; SDef
	db "KAIRIyu-@@@"

	dw UMBREON
	db GOLD_BERRY
	dw MUD_SLAP, MOONLIGHT, PSYCHIC_M, FAINT_ATTACK

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 14, 15 ; DVs
	db 10, 5, 10, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 233 ; HP
	bigdw 233 ; Max HP
	bigdw 134 ; Atk
	bigdw 186 ; Def
	bigdw 133 ; Spd
	bigdw 128 ; SAtk
	bigdw 212 ; SDef
	db "BURAtuKI-@@"

	dw ARCANINE
	db CHARCOAL
	dw FLAMETHROWER, CRUNCH, EXTREMESPEED, IRON_TAIL

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 40000
	bigdw 55000
	bigdw 50000
	dn 15, 13, 14, 13 ; DVs
	db 15, 15, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 228 ; HP
	bigdw 228 ; Max HP
	bigdw 188 ; Atk
	bigdw 146 ; Def
	bigdw 170 ; Spd
	bigdw 174 ; SAtk
	bigdw 150 ; SDef
	db "UINDEi@@@@@"

	dw SKARMORY
	db MIRACLEBERRY
	dw STEEL_WING, FLY, TOXIC, PROTECT

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 15, 11, 14, 11 ; DVs
	db 25, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 221 ; HP
	bigdw 221 ; Max HP
	bigdw 164 ; Atk
	bigdw 218 ; Def
	bigdw 139 ; Spd
	bigdw 99 ; SAtk
	bigdw 135 ; SDef
	db "EA-MUDO@@@@"

	dw BLISSEY
	db LEFTOVERS
	dw SOFTBOILED, TOXIC, PROTECT, PSYCHIC_M

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	dn 15, 11, 12, 13 ; DVs
	db 10, 10, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 425 ; HP
	bigdw 425 ; Max HP
	bigdw 66 ; Atk
	bigdw 63 ; Def
	bigdw 117 ; Spd
	bigdw 144 ; SAtk
	bigdw 216 ; SDef
	db "HAPINASU@@@"

	dw SNORLAX
	db PINK_BOW
	dw ROCK_SLIDE, SURF, BODY_SLAM, EARTHQUAKE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 10, 15, 12 ; DVs
	db 10, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 307 ; HP
	bigdw 307 ; Max HP
	bigdw 186 ; Atk
	bigdw 128 ; Def
	bigdw 92 ; Spd
	bigdw 131 ; SAtk
	bigdw 185 ; SDef
	db "KABIGON@@@@"

	dw HERACROSS
	db FOCUS_BAND
	dw REVERSAL, MEGAHORN, EARTHQUAKE, COUNTER

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 13, 15, 14, 13 ; DVs
	db 15, 10, 10, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 215 ; HP
	bigdw 215 ; Max HP
	bigdw 200 ; Atk
	bigdw 146 ; Def
	bigdw 157 ; Spd
	bigdw 102 ; SAtk
	bigdw 168 ; SDef
	db "HERAKUROSU@"

	dw JYNX
	db MIRACLEBERRY
	dw BLIZZARD, PSYCHIC_M, SHADOW_BALL, ICY_WIND

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 15, 14, 11 ; DVs
	db 5, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 209 ; HP
	bigdw 209 ; Max HP
	bigdw 104 ; Atk
	bigdw 98 ; Def
	bigdw 169 ; Spd
	bigdw 201 ; SAtk
	bigdw 165 ; SDef
	db "RU-ZIyuRA@@"

	dw BLASTOISE
	db GOLD_BERRY
	dw SURF, EARTHQUAKE, RAPID_SPIN, BLIZZARD

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 14 ; DVs
	db 15, 10, 40, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 210 ; HP
	bigdw 210 ; Max HP
	bigdw 156 ; Atk
	bigdw 175 ; Def
	bigdw 150 ; Spd
	bigdw 163 ; SAtk
	bigdw 181 ; SDef
	db "KAMEtuKUSU@"

	dw RHYDON
	db QUICK_CLAW
	dw EARTHQUAKE, SURF, IRON_TAIL, ROCK_SLIDE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 11, 15, 10 ; DVs
	db 10, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 246 ; HP
	bigdw 246 ; Max HP
	bigdw 212 ; Atk
	bigdw 195 ; Def
	bigdw 104 ; Spd
	bigdw 104 ; SAtk
	bigdw 104 ; SDef
	db "SAIDON@@@@@"

	dw SANDSLASH
	db SCOPE_LENS
	dw EARTHQUAKE, SLASH, HYPER_BEAM, SNORE

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 11, 7, 6, 7 ; DVs
	db 10, 20, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 201 ; HP
	bigdw 201 ; Max HP
	bigdw 164 ; Atk
	bigdw 171 ; Def
	bigdw 116 ; Spd
	bigdw 93 ; SAtk
	bigdw 105 ; SDef
	db "SANDOPAN@@@"

	dw PARASECT
	db GOLD_BERRY
	dw SPORE, GIGA_DRAIN, HYPER_BEAM, SLUDGE_BOMB

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 6, 5, 15 ; DVs
	db 15, 5, 5, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 183 ; HP
	bigdw 183 ; Max HP
	bigdw 176 ; Atk
	bigdw 158 ; Def
	bigdw 72 ; Spd
	bigdw 114 ; SAtk
	bigdw 156 ; SDef
	db "PARASEKUTO@"

	dw GOLEM
	db BRIGHTPOWDER
	dw EXPLOSION, EARTHQUAKE, FIRE_PUNCH, FRUSTRATION

	dw 0 ; OT ID
	dt 216000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 6, 5, 7 ; DVs
	db 5, 10, 15, 20 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 60 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 205 ; HP
	bigdw 205 ; Max HP
	bigdw 183 ; Atk
	bigdw 194 ; Def
	bigdw 90 ; Spd
	bigdw 105 ; SAtk
	bigdw 117 ; SDef
	db "GORO-NIya@@"


	btmon KINGAMBIT, LEFTOVERS, IRON_HEAD, NIGHT_SLASH, SUCKER_PUNCH, SWORDS_DANCE, 60, 50000, ABILITY_1
	btmon LUDICOLO, MIRACLE_SEED, SURF, GIGA_DRAIN, ICE_BEAM, RAIN_DANCE, 60, 50000, ABILITY_1
	btmon OVERQWIL, POISON_BARB, SLUDGE_BOMB, LIQUIDATION, SPIKES, DESTINY_BOND, 60, 50000, ABILITY_1
	btmon SCRAFTY, BLACKBELT, DRAIN_PUNCH, CRUNCH, ROCK_SLIDE, BULK_UP, 60, 50000, ABILITY_1
	btmon WALREIN, NEVERMELTICE, SURF, ICE_BEAM, REST, SLEEP_TALK, 60, 50000, ABILITY_1
	btmon HAXORUS, DRAGON_FANG, DRAGON_CLAW, EARTHQUAKE, X_SCISSOR, DRAGON_DANCE, 60, 50000, ABILITY_1
	btmon RAMPARDOS, HARD_STONE, HEAD_SMASH, EARTHQUAKE, ZEN_HEADBUTT, ROCK_SLIDE, 60, 50000, ABILITY_1
	btmon BASTIODON, METAL_COAT, IRON_HEAD, ROCK_SLIDE, TOXIC, IRON_DEFENSE, 60, 50000, ABILITY_1
	btmon CETITAN, QUICK_CLAW, ICICLE_CRASH, EARTHQUAKE, ICE_SHARD, BELLY_DRUM, 60, 50000, ABILITY_1
	btmon MILOTIC, MYSTIC_WATER, SURF, ICE_BEAM, RECOVER, TOXIC, 60, 50000, ABILITY_1
	btmon MIMIKYU, SPELL_TAG, PLAY_ROUGH, SHADOW_CLAW, SHADOW_SNEAK, SWORDS_DANCE, 60, 50000, ABILITY_1

ASSERT @ - BattleTowerMons6 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L70", ROMX

BattleTowerMons7:

	dw JOLTEON
	db MIRACLEBERRY
	dw THUNDERBOLT, HYPER_BEAM, SHADOW_BALL, ROAR

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 56000
	bigdw 55000
	bigdw 50000
	bigdw 60000
	dn 15, 11, 14, 15 ; DVs
	db 15, 5, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 231 ; HP
	bigdw 231 ; Max HP
	bigdw 158 ; Atk
	bigdw 145 ; Def
	bigdw 245 ; Spd
	bigdw 222 ; SAtk
	bigdw 201 ; SDef
	db "SANDA-SU@@@"

	dw VAPOREON
	db LEFTOVERS
	dw BLIZZARD, SHADOW_BALL, SURF, MUD_SLAP

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 60000
	bigdw 60000
	bigdw 50000
	dn 11, 15, 14, 15 ; DVs
	db 5, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 319 ; HP
	bigdw 319 ; Max HP
	bigdw 150 ; Atk
	bigdw 152 ; Def
	bigdw 158 ; Spd
	bigdw 219 ; SAtk
	bigdw 198 ; SDef
	db "SIyaWA-ZU@@"

	dw UMBREON
	db GOLD_BERRY
	dw FAINT_ATTACK, MOONLIGHT, PSYCH_UP, TOXIC

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 54000
	bigdw 60000
	bigdw 55000
	bigdw 50000
	bigdw 58000
	dn 13, 13, 13, 13 ; DVs
	db 20, 5, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 274 ; HP
	bigdw 274 ; Max HP
	bigdw 156 ; Atk
	bigdw 217 ; Def
	bigdw 153 ; Spd
	bigdw 149 ; SAtk
	bigdw 247 ; SDef
	db "BURAtuKI-@@"

	dw BLISSEY
	db GOLD_BERRY
	dw COUNTER, SOFTBOILED, SHADOW_BALL, THUNDERBOLT

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 55000
	bigdw 55000
	bigdw 58000
	bigdw 50000
	dn 13, 15, 14, 13 ; DVs
	db 20, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 495 ; HP
	bigdw 495 ; Max HP
	bigdw 77 ; Atk
	bigdw 80 ; Def
	bigdw 143 ; Spd
	bigdw 167 ; SAtk
	bigdw 251 ; SDef
	db "HAPINASU@@@"

	dw SNORLAX
	db LEFTOVERS
	dw ROCK_SLIDE, EARTHQUAKE, BLIZZARD, SHADOW_BALL

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 13, 13 ; DVs
	db 10, 10, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 365 ; HP
	bigdw 365 ; Max HP
	bigdw 217 ; Atk
	bigdw 156 ; Def
	bigdw 105 ; Spd
	bigdw 153 ; SAtk
	bigdw 216 ; SDef
	db "KABIGON@@@@"

	dw HOUNDOOM
	db KINGS_ROCK
	dw CRUNCH, FLAMETHROWER, FAINT_ATTACK, ROAR

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 58000
	bigdw 50000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	dn 13, 13, 12, 13 ; DVs
	db 15, 15, 20, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 245 ; HP
	bigdw 245 ; Max HP
	bigdw 202 ; Atk
	bigdw 133 ; Def
	bigdw 197 ; Spd
	bigdw 217 ; SAtk
	bigdw 175 ; SDef
	db "HERUGA-@@@@"

	dw TYRANITAR
	db LEFTOVERS
	dw EARTHQUAKE, CRUNCH, ROCK_SLIDE, HYPER_BEAM

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	dn 13, 11, 13, 15 ; DVs
	db 10, 15, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 280 ; HP
	bigdw 280 ; Max HP
	bigdw 247 ; Atk
	bigdw 211 ; Def
	bigdw 147 ; Spd
	bigdw 196 ; SAtk
	bigdw 203 ; SDef
	db "BANGIRASU@@"

	dw ELECTIVIRE
	db GOLD_BERRY
	dw WILD_CHARGE, ICE_PUNCH, CROSS_CHOP, EARTHQUAKE

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 13, 11, 13, 15 ; DVs
	db 15, 20, 20, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 264 ; HP
	bigdw 264 ; Max HP
	bigdw 188 ; Atk
	bigdw 178 ; Def
	bigdw 200 ; Spd
	bigdw 238 ; SAtk
	bigdw 189 ; SDef
	db "SANDA-@@@@@"

	dw EXEGGUTOR
	db MIRACLEBERRY
	dw REST, EXPLOSION, PSYCHIC_M, GIGA_DRAIN

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 45000
	dn 13, 13, 14, 13 ; DVs
	db 10, 5, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 268 ; HP
	bigdw 268 ; Max HP
	bigdw 195 ; Atk
	bigdw 177 ; Def
	bigdw 140 ; Spd
	bigdw 235 ; SAtk
	bigdw 165 ; SDef
	db "NAtuSI-@@@@"

	dw WYRDEER
	db GOLD_BERRY
	dw PSYCHIC_M, SHADOW_BALL, EARTHQUAKE, HYPNOSIS

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	bigdw 50000
	dn 15, 13, 14, 11 ; DVs
	db 5, 20, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 270 ; HP
	bigdw 270 ; Max HP
	bigdw 156 ; Atk
	bigdw 214 ; Def
	bigdw 152 ; Spd
	bigdw 143 ; SAtk
	bigdw 241 ; SDef
	db "BURAtuKI-@@"

	dw GYARADOS
	db BRIGHTPOWDER
	dw SURF, THUNDERBOLT, HYPER_BEAM, ROAR

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 11, 14, 15 ; DVs
	db 15, 15, 5, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 271 ; HP
	bigdw 271 ; Max HP
	bigdw 235 ; Atk
	bigdw 170 ; Def
	bigdw 178 ; Spd
	bigdw 149 ; SAtk
	bigdw 205 ; SDef
	db "GIyaRADOSU@"

	dw QUAGSIRE
	db MIRACLEBERRY
	dw EARTHQUAKE, SURF, SLUDGE_BOMB, IRON_TAIL

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 13, 14, 13, 13 ; DVs
	db 10, 15, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 267 ; HP
	bigdw 267 ; Max HP
	bigdw 195 ; Atk
	bigdw 194 ; Def
	bigdw 111 ; Spd
	bigdw 153 ; SAtk
	bigdw 153 ; SDef
	db "NUO-@@@@@@@"

	dw URSARING
	db SCOPE_LENS
	dw SLASH, EARTHQUAKE, HYPER_BEAM, THUNDERPUNCH

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	dn 15, 13, 14, 13 ; DVs
	db 20, 10, 5, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 263 ; HP
	bigdw 263 ; Max HP
	bigdw 245 ; Atk
	bigdw 167 ; Def
	bigdw 138 ; Spd
	bigdw 167 ; SAtk
	bigdw 167 ; SDef
	db "RINGUMA@@@@"

	dw MR__MIME
	db KINGS_ROCK
	dw REFLECT, FIRE_PUNCH, PSYCHIC_M, ENCORE

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 11, 13, 15, 11 ; DVs
	db 20, 15, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 210 ; HP
	bigdw 210 ; Max HP
	bigdw 106 ; Atk
	bigdw 151 ; Def
	bigdw 198 ; Spd
	bigdw 213 ; SAtk
	bigdw 227 ; SDef
	db "BARIYA-DO@@"

	dw PRIMEAPE
	db QUICK_CLAW
	dw CROSS_CHOP, ICE_PUNCH, THUNDERPUNCH, ROCK_SLIDE

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 11, 13, 14, 15 ; DVs
	db 5, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 228 ; HP
	bigdw 228 ; Max HP
	bigdw 202 ; Atk
	bigdw 146 ; Def
	bigdw 210 ; Spd
	bigdw 149 ; SAtk
	bigdw 149 ; SDef
	db "OKORIZARU@@"

	dw GIRAFARIG
	db GOLD_BERRY
	dw AGILITY, BATON_PASS, CRUNCH, EARTHQUAKE

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 13 ; DVs
	db 30, 40, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 232 ; HP
	bigdw 232 ; Max HP
	bigdw 177 ; Atk
	bigdw 154 ; Def
	bigdw 184 ; Spd
	bigdw 188 ; SAtk
	bigdw 153 ; SDef
	db "KIRINRIKI@@"

	dw HITMONLEE
	db FOCUS_BAND
	dw REVERSAL, ENDURE, BODY_SLAM, MEGA_KICK

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 14 ; DVs
	db 15, 10, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 203 ; HP
	bigdw 203 ; Max HP
	bigdw 233 ; Atk
	bigdw 138 ; Def
	bigdw 187 ; Spd
	bigdw 112 ; SAtk
	bigdw 217 ; SDef
	db "SAWAMURA-@@"

	dw HERACROSS
	db BRIGHTPOWDER
	dw REVERSAL, ENDURE, MEGAHORN, EARTHQUAKE

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 7, 15, 7 ; DVs
	db 15, 10, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 252 ; HP
	bigdw 252 ; Max HP
	bigdw 240 ; Atk
	bigdw 159 ; Def
	bigdw 184 ; Spd
	bigdw 110 ; SAtk
	bigdw 187 ; SDef
	db "HERAKUROSU@"

	dw VENUSAUR
	db BRIGHTPOWDER
	dw SUNNY_DAY, SOLARBEAM, SYNTHESIS, HYPER_BEAM

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 6, 4, 4 ; DVs
	db 5, 10, 5, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 233 ; HP
	bigdw 233 ; Max HP
	bigdw 159 ; Atk
	bigdw 159 ; Def
	bigdw 152 ; Spd
	bigdw 194 ; SAtk
	bigdw 180 ; SDef
	db "HUSIGIBANA@"

	dw CHARIZARD
	db SCOPE_LENS
	dw SLASH, EARTHQUAKE, HYPER_BEAM, FLAMETHROWER

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 5, 6, 4, 4 ; DVs
	db 20, 10, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 230 ; HP
	bigdw 230 ; Max HP
	bigdw 159 ; Atk
	bigdw 152 ; Def
	bigdw 180 ; Spd
	bigdw 194 ; SAtk
	bigdw 159 ; SDef
	db "RIZA-DON@@@"

	dw BLASTOISE
	db QUICK_CLAW
	dw HYDRO_PUMP, ICE_PUNCH, HYPER_BEAM, IRON_TAIL

	dw 0 ; OT ID
	dt 343000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 6, 6, 4 ; DVs
	db 5, 15, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 70 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 231 ; HP
	bigdw 231 ; Max HP
	bigdw 161 ; Atk
	bigdw 183 ; Def
	bigdw 152 ; Spd
	bigdw 166 ; SAtk
	bigdw 187 ; SDef
	db "KAMEtuKUSU@"


	btmon CURSOLA, CHOICE_SPECS, SHADOW_BALL, EARTH_POWER, POWER_GEM, ICE_BEAM, 70, 55000, ABILITY_1
	btmon MR__RIME, WISE_GLASSES, PSYCHIC_M, ICE_BEAM, THUNDERBOLT, CALM_MIND, 70, 55000, ABILITY_1
	btmon SIRFETCH_D, CHOICE_BAND, CLOSE_COMBAT, LEAF_BLADE, BRAVE_BIRD, KNOCK_OFF, 70, 55000, ABILITY_1
	btmon LUCARIO, LIFE_ORB, AURA_SPHERE, FLASH_CANNON, DARK_PULSE, NASTY_PLOT, 70, 55000, ABILITY_1
	btmon TYRANTRUM, MUSCLE_BAND, HEAD_SMASH, DRAGON_CLAW, EARTHQUAKE, CRUNCH, 70, 55000, ABILITY_1
	btmon AURORUS, WEAK_POLICY, ICE_BEAM, POWER_GEM, THUNDERBOLT, THUNDER_WAVE, 70, 55000, ABILITY_1
	btmon TORKOAL, LEFTOVERS, FLAMETHROWER, EARTH_POWER, WILL_O_WISP, PROTECT, 70, 55000, ABILITY_1
	btmon RATICATE_ALOLAN, FOCUS_SASH, CRUNCH, DOUBLE_EDGE, SUCKER_PUNCH, SWORDS_DANCE, 70, 55000, ABILITY_1
	btmon RAICHU_ALOLAN, EXPERT_BELT, THUNDERBOLT, PSYCHIC_M, SURF, VOLT_SWITCH, 70, 55000, ABILITY_1
	btmon NINETALES_ALOLAN, NEVERMELTICE, ICE_BEAM, DAZZLING_GLEAM, REFLECT, HAIL, 70, 55000, ABILITY_1
	btmon MUK_ALOLAN, ASSAULT_VEST, SLUDGE_BOMB, CRUNCH, FIRE_PUNCH, ICE_PUNCH, 70, 55000, ABILITY_1

ASSERT @ - BattleTowerMons7 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L80", ROMX

BattleTowerMons8:

	dw JOLTEON
	db MIRACLEBERRY
	dw THUNDER_WAVE, THUNDERBOLT, IRON_TAIL, ROAR

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	bigdw 55000
	dn 15, 13, 14, 11 ; DVs
	db 20, 15, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 263 ; HP
	bigdw 263 ; Max HP
	bigdw 179 ; Atk
	bigdw 170 ; Def
	bigdw 281 ; Spd
	bigdw 245 ; SAtk
	bigdw 221 ; SDef
	db "SANDA-SU@@@"

	dw SNORLAX
	db LEFTOVERS
	dw REST, BELLY_DRUM, SNORE, EARTHQUAKE

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 55000
	bigdw 50000
	bigdw 55500
	bigdw 60000
	dn 13, 11, 14, 13 ; DVs
	db 10, 10, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 415 ; HP
	bigdw 415 ; Max HP
	bigdw 248 ; Atk
	bigdw 171 ; Def
	bigdw 122 ; Spd
	bigdw 178 ; SAtk
	bigdw 250 ; SDef
	db "KABIGON@@@@"

	dw HOUNDOOM
	db MINT_BERRY
	dw REST, CRUNCH, FLAMETHROWER, SUNNY_DAY

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 55000
	bigdw 55000
	bigdw 55000
	dn 15, 13, 13, 11 ; DVs
	db 10, 15, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 280 ; HP
	bigdw 280 ; Max HP
	bigdw 233 ; Atk
	bigdw 152 ; Def
	bigdw 224 ; Spd
	bigdw 245 ; SAtk
	bigdw 197 ; SDef
	db "HERUGA-@@@@"

	dw TAUROS
	db GOLD_BERRY
	dw EARTHQUAKE, BODY_SLAM, IRON_TAIL, HYPER_BEAM

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	dn 15, 13, 13, 14 ; DVs
	db 10, 15, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 277 ; HP
	bigdw 277 ; Max HP
	bigdw 233 ; Atk
	bigdw 222 ; Def
	bigdw 236 ; Spd
	bigdw 184 ; SAtk
	bigdw 184 ; SDef
	db "KENTAROSU@@"

	dw LAPRAS
	db MINT_BERRY
	dw REST, SURF, CONFUSE_RAY, PSYCHIC_M

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 15, 13, 11 ; DVs
	db 10, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 366 ; HP
	bigdw 366 ; Max HP
	bigdw 206 ; Atk
	bigdw 201 ; Def
	bigdw 168 ; Spd
	bigdw 203 ; SAtk
	bigdw 219 ; SDef
	db "RAPURASU@@@"

	dw TYRANITAR
	db MIRACLEBERRY
	dw REST, CRUNCH, EARTHQUAKE, ROCK_SLIDE

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 15, 13, 11 ; DVs
	db 10, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 318 ; HP
	bigdw 318 ; Max HP
	bigdw 286 ; Atk
	bigdw 249 ; Def
	bigdw 169 ; Spd
	bigdw 219 ; SAtk
	bigdw 227 ; SDef
	db "BANGIRASU@@"

	dw GENGAR
	db NO_ITEM
	dw THUNDERBOLT, SHADOW_BALL, CONFUSE_RAY, THIEF

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 55000
	bigdw 50000
	dn 13, 14, 13, 13 ; DVs
	db 15, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 248 ; HP
	bigdw 248 ; Max HP
	bigdw 174 ; Atk
	bigdw 165 ; Def
	bigdw 248 ; Spd
	bigdw 278 ; SAtk
	bigdw 190 ; SDef
	db "GENGA-@@@@@"

	dw FORRETRESS
	db LEFTOVERS
	dw EXPLOSION, TOXIC, SOLARBEAM, SWAGGER

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	dn 15, 13, 14, 13 ; DVs
	db 5, 10, 10, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 273 ; HP
	bigdw 273 ; Max HP
	bigdw 217 ; Atk
	bigdw 294 ; Def
	bigdw 133 ; Spd
	bigdw 166 ; SAtk
	bigdw 166 ; SDef
	db "HUoRETOSU@@"

	dw KINGDRA
	db MINT_BERRY
	dw REST, SURF, BLIZZARD, DRAGONBREATH

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 40000
	bigdw 55000
	bigdw 50000
	dn 15, 11, 14, 13 ; DVs
	db 10, 15, 5, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 273 ; HP
	bigdw 273 ; Max HP
	bigdw 225 ; Atk
	bigdw 214 ; Def
	bigdw 209 ; Spd
	bigdw 222 ; SAtk
	bigdw 222 ; SDef
	db "KINGUDORA@@"

	dw DRAGONITE
	db GOLD_BERRY
	dw THUNDER_WAVE, SURF, THUNDERBOLT, OUTRAGE

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	dn 13, 13, 13, 13 ; DVs
	db 20, 15, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 304 ; HP
	bigdw 304 ; Max HP
	bigdw 285 ; Atk
	bigdw 222 ; Def
	bigdw 198 ; Spd
	bigdw 228 ; SAtk
	bigdw 228 ; SDef
	db "KAIRIyu-@@@"

	dw PORYGON2
	db LEFTOVERS
	dw PSYCHIC_M, RECOVER, HYPER_BEAM, TRI_ATTACK

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 40000
	bigdw 55000
	bigdw 50000
	dn 13, 15, 14, 13 ; DVs
	db 10, 20, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 293 ; HP
	bigdw 293 ; Max HP
	bigdw 198 ; Atk
	bigdw 213 ; Def
	bigdw 169 ; Spd
	bigdw 238 ; SAtk
	bigdw 222 ; SDef
	db "PORIGON2@@@"

	dw JYNX
	db QUICK_CLAW
	dw LOVELY_KISS, BLIZZARD, DREAM_EATER, PSYCHIC_M

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	dn 13, 15, 13, 15 ; DVs
	db 10, 5, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 280 ; HP
	bigdw 280 ; Max HP
	bigdw 134 ; Atk
	bigdw 127 ; Def
	bigdw 222 ; Spd
	bigdw 273 ; SAtk
	bigdw 225 ; SDef
	db "RU-ZIyuRA@@"

	dw MANTINE
	db GOLD_BERRY
	dw SURF, CONFUSE_RAY, BLIZZARD, WING_ATTACK

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 40000
	bigdw 45000
	bigdw 40000
	bigdw 45000
	bigdw 50000
	dn 13, 15, 13, 12 ; DVs
	db 15, 10, 5, 35 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 288 ; HP
	bigdw 288 ; Max HP
	bigdw 132 ; Atk
	bigdw 181 ; Def
	bigdw 180 ; Spd
	bigdw 213 ; SAtk
	bigdw 293 ; SDef
	db "MANTAIN@@@@"

	dw SKARMORY
	db QUICK_CLAW
	dw STEEL_WING, FLY, MUD_SLAP, TOXIC

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 35000
	bigdw 50000
	bigdw 50000
	dn 13, 13, 14, 15 ; DVs
	db 25, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 291 ; HP
	bigdw 291 ; Max HP
	bigdw 212 ; Atk
	bigdw 287 ; Def
	bigdw 184 ; Spd
	bigdw 137 ; SAtk
	bigdw 185 ; SDef
	db "EA-MUDO@@@@"

	dw TALONFLAME
	db CHARCOAL
	dw FLARE_BLITZ, BRAVE_BIRD, STEEL_WING, ROOST

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	dn 13, 13, 15, 14 ; DVs
	db 15, 5, 25, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 301 ; HP
	bigdw 301 ; Max HP
	bigdw 225 ; Atk
	bigdw 214 ; Def
	bigdw 213 ; Spd
	bigdw 272 ; SAtk
	bigdw 208 ; SDef
	db "HUaIYA-@@@@"

	dw AERODACTYL
	db MIRACLEBERRY
	dw HYPER_BEAM, REST, EARTHQUAKE, ROAR

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	dn 15, 15, 14, 13 ; DVs
	db 5, 10, 10, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 283 ; HP
	bigdw 283 ; Max HP
	bigdw 237 ; Atk
	bigdw 177 ; Def
	bigdw 275 ; Spd
	bigdw 166 ; SAtk
	bigdw 190 ; SDef
	db "PUTERA@@@@@"

	dw ELECTRODE
	db KINGS_ROCK
	dw THUNDERBOLT, EXPLOSION, MIRROR_COAT, TOXIC

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 40000
	bigdw 40000
	bigdw 50000
	dn 15, 15, 14, 15 ; DVs
	db 15, 5, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 251 ; HP
	bigdw 251 ; Max HP
	bigdw 153 ; Atk
	bigdw 181 ; Def
	bigdw 307 ; Spd
	bigdw 201 ; SAtk
	bigdw 201 ; SDef
	db "MARUMAIN@@@"

	dw DUGTRIO
	db SCOPE_LENS
	dw SLASH, EARTHQUAKE, THIEF, MUD_SLAP

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 40000
	dn 15, 13, 13, 13 ; DVs
	db 20, 10, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 214 ; HP
	bigdw 214 ; Max HP
	bigdw 233 ; Atk
	bigdw 145 ; Def
	bigdw 262 ; Spd
	bigdw 145 ; SAtk
	bigdw 177 ; SDef
	db "DAGUTORIO@@"

	dw VICTREEBEL
	db QUICK_CLAW
	dw GIGA_DRAIN, SLUDGE_BOMB, HYPER_BEAM, TOXIC

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 5, 6, 5 ; DVs
	db 5, 10, 5, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 260 ; HP
	bigdw 260 ; Max HP
	bigdw 217 ; Atk
	bigdw 151 ; Def
	bigdw 161 ; Spd
	bigdw 207 ; SAtk
	bigdw 159 ; SDef
	db "UTUBOtuTO@@"

	dw PINSIR
	db GOLD_BERRY
	dw HYPER_BEAM, SUBMISSION, STRENGTH, TOXIC

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 4, 6, 4 ; DVs
	db 5, 25, 15, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 241 ; HP
	bigdw 241 ; Max HP
	bigdw 250 ; Atk
	bigdw 205 ; Def
	bigdw 185 ; Spd
	bigdw 133 ; SAtk
	bigdw 157 ; SDef
	db "KAIROSU@@@@"

	dw GRANBULL
	db BRIGHTPOWDER
	dw ROAR, SHADOW_BALL, HYPER_BEAM, THUNDERPUNCH

	dw 0 ; OT ID
	dt 512000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 6, 5, 7 ; DVs
	db 20, 15, 5, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 80 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 286 ; HP
	bigdw 286 ; Max HP
	bigdw 242 ; Atk
	bigdw 169 ; Def
	bigdw 119 ; Spd
	bigdw 146 ; SAtk
	bigdw 170 ; SDef
	db "GURANBURU@@"


	btmon MAROWAK_ALOLAN, THICK_CLUB, FLARE_BLITZ, SHADOW_CLAW, EARTHQUAKE, SWORDS_DANCE, 80, 55000, ABILITY_1
	btmon PERRSERKER, CHOICE_BAND, IRON_HEAD, CLOSE_COMBAT, CRUNCH, U_TURN, 80, 55000, ABILITY_1
	btmon RAPIDASH_GALARIAN, LIFE_ORB, PLAY_ROUGH, ZEN_HEADBUTT, MEGAHORN, AGILITY, 80, 55000, ABILITY_1
	btmon SLOWBRO_GALARIAN, QUICK_CLAW, PSYCHIC_M, SLUDGE_BOMB, FLAMETHROWER, SLACK_OFF, 80, 55000, ABILITY_1
	btmon SLOWKING_GALARIAN, ASSAULT_VEST, PSYCHIC_M, SLUDGE_BOMB, ICE_BEAM, FLAMETHROWER, 80, 55000, ABILITY_1
	btmon WEEZING_GALARIAN, ROCKY_HELMET, SLUDGE_BOMB, DAZZLING_GLEAM, WILL_O_WISP, PAIN_SPLIT, 80, 55000, ABILITY_1
	btmon ARCANINE_HISUIAN, MUSCLE_BAND, FLARE_BLITZ, ROCK_SLIDE, EXTREMESPEED, CRUNCH, 80, 55000, ABILITY_1
	btmon ELECTRODE_HISUIAN, CHOICE_SPECS, THUNDERBOLT, ENERGY_BALL, VOLT_SWITCH, EXPLOSION, 80, 55000, ABILITY_1
	btmon TYPHLOSION_HISUIAN, WISE_GLASSES, FLAMETHROWER, SHADOW_BALL, EARTH_POWER, WILL_O_WISP, 80, 55000, ABILITY_1
	btmon SNEASLER, FOCUS_SASH, CLOSE_COMBAT, POISON_JAB, NIGHT_SLASH, SWORDS_DANCE, 80, 55000, ABILITY_1
	btmon CLODSIRE, LEFTOVERS, EARTHQUAKE, SLUDGE_BOMB, RECOVER, TOXIC, 80, 55000, ABILITY_1

ASSERT @ - BattleTowerMons8 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L90", ROMX

BattleTowerMons9:

	dw UMBREON
	db KINGS_ROCK
	dw FAINT_ATTACK, MUD_SLAP, MOONLIGHT, CONFUSE_RAY

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 55000
	bigdw 60000
	bigdw 55000
	dn 15, 13, 14, 13 ; DVs
	db 20, 10, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 349 ; HP
	bigdw 349 ; Max HP
	bigdw 203 ; Atk
	bigdw 278 ; Def
	bigdw 202 ; Spd
	bigdw 188 ; SAtk
	bigdw 314 ; SDef
	db "BURAtuKI-@@"

	dw DRAGONITE
	db QUICK_CLAW
	dw FIRE_BLAST, HYPER_BEAM, OUTRAGE, BLIZZARD

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 65000
	bigdw 50000
	bigdw 56000
	bigdw 60000
	bigdw 60000
	dn 15, 13, 14, 13 ; DVs
	db 5, 5, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 343 ; HP
	bigdw 343 ; Max HP
	bigdw 323 ; Atk
	bigdw 252 ; Def
	bigdw 229 ; Spd
	bigdw 263 ; SAtk
	bigdw 263 ; SDef
	db "KAIRIyu-@@@"

	dw STARMIE
	db LEFTOVERS
	dw RECOVER, THUNDERBOLT, SURF, PSYCHIC_M

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 55000
	bigdw 60000
	dn 13, 15, 13, 13 ; DVs
	db 20, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 289 ; HP
	bigdw 289 ; Max HP
	bigdw 218 ; Atk
	bigdw 239 ; Def
	bigdw 287 ; Spd
	bigdw 263 ; SAtk
	bigdw 236 ; SDef
	db "SUTA-MI-@@@"

	dw CLOYSTER
	db LEFTOVERS
	dw EXPLOSION, BLIZZARD, SURF, ICY_WIND

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 13, 11, 13, 15 ; DVs
	db 5, 5, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 267 ; HP
	bigdw 267 ; Max HP
	bigdw 249 ; Atk
	bigdw 399 ; Def
	bigdw 204 ; Spd
	bigdw 235 ; SAtk
	bigdw 163 ; SDef
	db "PARUSIeN@@@"

	dw CROBAT
	db GOLD_BERRY
	dw WING_ATTACK, HAZE, HYPER_BEAM, GIGA_DRAIN

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 12, 15 ; DVs
	db 35, 30, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 326 ; HP
	bigdw 326 ; Max HP
	bigdw 244 ; Atk
	bigdw 222 ; Def
	bigdw 311 ; Spd
	bigdw 208 ; SAtk
	bigdw 226 ; SDef
	db "KUROBAtuTO@"

	dw PORYGON2
	db QUICK_CLAW
	dw TOXIC, PSYCHIC_M, RECOVER, PROTECT

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 15, 13, 14, 13 ; DVs
	db 10, 10, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 326 ; HP
	bigdw 326 ; Max HP
	bigdw 223 ; Atk
	bigdw 240 ; Def
	bigdw 190 ; Spd
	bigdw 267 ; SAtk
	bigdw 249 ; SDef
	db "PORIGON2@@@"

	dw KINGDRA
	db LEFTOVERS
	dw DRAGONBREATH, SURF, HYPER_BEAM, BLIZZARD

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 45000
	dn 13, 15, 13, 14 ; DVs
	db 20, 15, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 310 ; HP
	bigdw 310 ; Max HP
	bigdw 249 ; Atk
	bigdw 255 ; Def
	bigdw 231 ; Spd
	bigdw 248 ; SAtk
	bigdw 248 ; SDef
	db "KINGUDORA@@"

	dw TYRANITAR
	db QUICK_CLAW
	dw HYPER_BEAM, CRUNCH, EARTHQUAKE, ROCK_SLIDE

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 45000
	bigdw 50000
	dn 13, 15, 13, 14 ; DVs
	db 5, 15, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 355 ; HP
	bigdw 355 ; Max HP
	bigdw 321 ; Atk
	bigdw 280 ; Def
	bigdw 185 ; Spd
	bigdw 251 ; SAtk
	bigdw 260 ; SDef
	db "BANGIRASU@@"

	dw LAPRAS
	db MINT_BERRY
	dw REST, SURF, THUNDERBOLT, PSYCHIC_M

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	dn 11, 13, 14, 15 ; DVs
	db 10, 15, 15, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 405 ; HP
	bigdw 405 ; Max HP
	bigdw 228 ; Atk
	bigdw 222 ; Def
	bigdw 188 ; Spd
	bigdw 237 ; SAtk
	bigdw 255 ; SDef
	db "RAPURASU@@@"

	dw ESPEON
	db GOLD_BERRY
	dw PSYCHIC_M, SHADOW_BALL, SUNNY_DAY, MORNING_SUN

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 15, 14 ; DVs
	db 10, 15, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 294 ; HP
	bigdw 294 ; Max HP
	bigdw 195 ; Atk
	bigdw 186 ; Def
	bigdw 282 ; Spd
	bigdw 314 ; SAtk
	bigdw 251 ; SDef
	db "E-HUi@@@@@@"

	dw MACHAMP
	db QUICK_CLAW
	dw CROSS_CHOP, VITAL_THROW, FIRE_BLAST, EARTHQUAKE

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 55000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 14, 13 ; DVs
	db 5, 10, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 337 ; HP
	bigdw 337 ; Max HP
	bigdw 314 ; Atk
	bigdw 222 ; Def
	bigdw 181 ; Spd
	bigdw 195 ; SAtk
	bigdw 231 ; SDef
	db "KAIRIKI-@@@"

	dw SNORLAX
	db MIRACLEBERRY
	dw FIRE_BLAST, SURF, EARTHQUAKE, HYPER_BEAM

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 13 ; DVs
	db 5, 15, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 455 ; HP
	bigdw 455 ; Max HP
	bigdw 280 ; Atk
	bigdw 199 ; Def
	bigdw 136 ; Spd
	bigdw 195 ; SAtk
	bigdw 276 ; SDef
	db "KABIGON@@@@"

	dw ARCANINE
	db MINT_BERRY
	dw SUNNY_DAY, FLAMETHROWER, EXTREMESPEED, REST

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 45000
	bigdw 55000
	dn 13, 15, 13, 14 ; DVs
	db 5, 15, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 337 ; HP
	bigdw 337 ; Max HP
	bigdw 274 ; Atk
	bigdw 226 ; Def
	bigdw 247 ; Spd
	bigdw 262 ; SAtk
	bigdw 226 ; SDef
	db "UINDEi@@@@@"

	dw BLISSEY
	db LEFTOVERS
	dw SOLARBEAM, SUNNY_DAY, SOFTBOILED, FIRE_BLAST

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 11, 13, 15, 14 ; DVs
	db 10, 5, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 634 ; HP
	bigdw 634 ; Max HP
	bigdw 90 ; Atk
	bigdw 96 ; Def
	bigdw 181 ; Spd
	bigdw 215 ; SAtk
	bigdw 323 ; SDef
	db "HAPINASU@@@"

	dw HOUNDOOM
	db BRIGHTPOWDER
	dw FLAMETHROWER, CRUNCH, SUNNY_DAY, SOLARBEAM

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 13, 11, 15, 14 ; DVs
	db 15, 15, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 310 ; HP
	bigdw 310 ; Max HP
	bigdw 253 ; Atk
	bigdw 165 ; Def
	bigdw 253 ; Spd
	bigdw 278 ; SAtk
	bigdw 224 ; SDef
	db "HERUGA-@@@@"

	dw SKARMORY
	db QUICK_CLAW
	dw SANDSTORM, STEEL_WING, TOXIC, RETURN

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 14, 15, 15, 7 ; DVs
	db 10, 25, 10, 20 ; PP
	db 255 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 316 ; HP
	bigdw 316 ; Max HP
	bigdw 242 ; Atk
	bigdw 334 ; Def
	bigdw 208 ; Spd
	bigdw 140 ; SAtk
	bigdw 194 ; SDef
	db "EA-MUDO@@@@"

	dw SHUCKLE
	db LEFTOVERS
	dw TOXIC, WRAP, PROTECT, ENCORE

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 14 ; DVs
	db 10, 20, 10, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 204 ; HP
	bigdw 204 ; Max HP
	bigdw 100 ; Atk
	bigdw 494 ; Def
	bigdw 91 ; Spd
	bigdw 98 ; SAtk
	bigdw 494 ; SDef
	db "TUBOTUBO@@@"

	dw FLAREON
	db MINT_BERRY
	dw HYPER_BEAM, FLAMETHROWER, SHADOW_BALL, ROAR

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 7, 15, 7 ; DVs
	db 5, 15, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 375 ; HP
	bigdw 375 ; Max HP
	bigdw 316 ; Atk
	bigdw 176 ; Def
	bigdw 253 ; Spd
	bigdw 185 ; SAtk
	bigdw 185 ; SDef
	db "BU-SUTA-@@@"

	dw MILTANK
	db LEFTOVERS
	dw MILK_DRINK, EARTHQUAKE, ATTRACT, BODY_SLAM

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 4, 7, 5, 7 ; DVs
	db 10, 10, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 322 ; HP
	bigdw 322 ; Max HP
	bigdw 194 ; Atk
	bigdw 245 ; Def
	bigdw 232 ; Spd
	bigdw 128 ; SAtk
	bigdw 182 ; SDef
	db "MIRUTANKU@@"

	dw TAUROS
	db PINK_BOW
	dw THUNDERBOLT, HYPER_BEAM, ATTRACT, EARTHQUAKE

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 5, 7, 6 ; DVs
	db 15, 5, 15, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 284 ; HP
	bigdw 284 ; Max HP
	bigdw 234 ; Atk
	bigdw 223 ; Def
	bigdw 254 ; Spd
	bigdw 180 ; SAtk
	bigdw 180 ; SDef
	db "KENTAROSU@@"

	dw MUK
	db QUICK_CLAW
	dw TOXIC, SLUDGE_BOMB, ATTRACT, GIGA_DRAIN

	dw 0 ; OT ID
	dt 729000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 5, 4, 4, 4 ; DVs
	db 10, 10, 15, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 90 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 342 ; HP
	bigdw 342 ; Max HP
	bigdw 241 ; Atk
	bigdw 185 ; Def
	bigdw 140 ; Spd
	bigdw 167 ; SAtk
	bigdw 230 ; SDef
	db "BETOBETON@@"


	btmon TAUROS_PALDEAN_FIRE, CHOICE_BAND, CLOSE_COMBAT, FLARE_BLITZ, EARTHQUAKE, ROCK_SLIDE, 90, 60000, ABILITY_1
	btmon TAUROS_PALDEAN_WATER, CHOICE_SCARF, CLOSE_COMBAT, LIQUIDATION, EARTHQUAKE, ZEN_HEADBUTT, 90, 60000, ABILITY_1
	btmon TSAREENA, LIFE_ORB, LEAF_BLADE, PLAY_ROUGH, CLOSE_COMBAT, SYNTHESIS, 90, 60000, ABILITY_1
	btmon AGGRON, WEAK_POLICY, IRON_HEAD, HEAD_SMASH, EARTHQUAKE, ROCK_SLIDE, 90, 60000, ABILITY_1
	btmon KLEAVOR, SCOPE_LENS, X_SCISSOR, ROCK_SLIDE, NIGHT_SLASH, SWORDS_DANCE, 90, 60000, ABILITY_1
	btmon GLIMMORA, FOCUS_SASH, POWER_GEM, SLUDGE_BOMB, EARTH_POWER, TOXIC_SPIKES, 90, 60000, ABILITY_1
	btmon TOXAPEX, LEFTOVERS, SCALD, SLUDGE_BOMB, RECOVER, TOXIC, 90, 60000, ABILITY_1
	btmon ZANGOOSE, TOXIC_ORB, DOUBLE_EDGE, CLOSE_COMBAT, SHADOW_CLAW, SWORDS_DANCE, 90, 60000, ABILITY_1
	btmon SEVIPER, EXPERT_BELT, SLUDGE_BOMB, EARTHQUAKE, FLAMETHROWER, GIGA_DRAIN, 90, 60000, ABILITY_1
	btmon BANETTE, SPELL_TAG, SHADOW_CLAW, SUCKER_PUNCH, WILL_O_WISP, DESTINY_BOND, 90, 60000, ABILITY_1
	btmon ARCHEOPS, CHOICE_BAND, BRAVE_BIRD, ROCK_SLIDE, EARTHQUAKE, U_TURN, 90, 60000, ABILITY_1

ASSERT @ - BattleTowerMons9 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

SECTION "Battle Tower Mons L100", ROMX

BattleTowerMons10:

	dw HOUNDOOM
	db MINT_BERRY
	dw CRUNCH, FLAMETHROWER, ROAR, REST

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	dn 15, 13, 14, 13 ; DVs
	db 15, 15, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 347 ; HP
	bigdw 347 ; Max HP
	bigdw 296 ; Atk
	bigdw 192 ; Def
	bigdw 284 ; Spd
	bigdw 312 ; SAtk
	bigdw 252 ; SDef
	db "HERUGA-@@@@"

	dw MACHAMP
	db QUICK_CLAW
	dw CROSS_CHOP, EARTHQUAKE, HYPER_BEAM, VITAL_THROW

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	dn 15, 13, 14, 15 ; DVs
	db 5, 10, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 377 ; HP
	bigdw 377 ; Max HP
	bigdw 356 ; Atk
	bigdw 252 ; Def
	bigdw 204 ; Spd
	bigdw 226 ; SAtk
	bigdw 266 ; SDef
	db "KAIRIKI-@@@"

	dw KINGDRA
	db LEFTOVERS
	dw SURF, DRAGONBREATH, REST, TOXIC

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	bigdw 60000
	dn 13, 15, 15, 14 ; DVs
	db 15, 20, 10, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 349 ; HP
	bigdw 349 ; Max HP
	bigdw 282 ; Atk
	bigdw 286 ; Def
	bigdw 266 ; Spd
	bigdw 284 ; SAtk
	bigdw 284 ; SDef
	db "KINGUDORA@@"

	dw JOLTEON
	db BRIGHTPOWDER
	dw THUNDERBOLT, ROAR, THUNDER_WAVE, IRON_TAIL

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 30000
	bigdw 50000
	dn 15, 13, 15, 14 ; DVs
	db 15, 20, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 324 ; HP
	bigdw 324 ; Max HP
	bigdw 221 ; Atk
	bigdw 207 ; Def
	bigdw 338 ; Spd
	bigdw 309 ; SAtk
	bigdw 279 ; SDef
	db "SANDA-SU@@@"

	dw TAUROS
	db KINGS_ROCK
	dw HYPER_BEAM, EARTHQUAKE, IRON_TAIL, THUNDERBOLT

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 13, 14, 15 ; DVs
	db 5, 10, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 342 ; HP
	bigdw 342 ; Max HP
	bigdw 291 ; Atk
	bigdw 277 ; Def
	bigdw 309 ; Spd
	bigdw 231 ; SAtk
	bigdw 231 ; SDef
	db "KENTAROSU@@"

	dw ARCANINE
	db LEFTOVERS
	dw FLAMETHROWER, EXTREMESPEED, IRON_TAIL, HYPER_BEAM

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 13, 13, 14, 15 ; DVs
	db 15, 5, 15, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 374 ; HP
	bigdw 374 ; Max HP
	bigdw 307 ; Atk
	bigdw 247 ; Def
	bigdw 281 ; Spd
	bigdw 291 ; SAtk
	bigdw 251 ; SDef
	db "UINDEi@@@@@"

	dw CHARIZARD
	db SCOPE_LENS
	dw FLAMETHROWER, EARTHQUAKE, SLASH, FLY

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 55000
	bigdw 55000
	dn 15, 14, 13, 15 ; DVs
	db 15, 10, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 344 ; HP
	bigdw 344 ; Max HP
	bigdw 259 ; Atk
	bigdw 247 ; Def
	bigdw 289 ; Spd
	bigdw 313 ; SAtk
	bigdw 263 ; SDef
	db "RIZA-DON@@@"

	dw ELECTRODE
	db BRIGHTPOWDER
	dw THUNDER_WAVE, THUNDERBOLT, EXPLOSION, MIRROR_COAT

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	bigdw 45000
	dn 15, 11, 14, 15 ; DVs
	db 20, 15, 5, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 309 ; HP
	bigdw 309 ; Max HP
	bigdw 191 ; Atk
	bigdw 223 ; Def
	bigdw 386 ; Spd
	bigdw 248 ; SAtk
	bigdw 248 ; SDef
	db "MARUMAIN@@@"

	dw RHYDON
	db MIRACLEBERRY
	dw SURF, EARTHQUAKE, HYPER_BEAM, ROCK_SLIDE

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 45000
	dn 15, 13, 14, 15 ; DVs
	db 15, 10, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 404 ; HP
	bigdw 404 ; Max HP
	bigdw 351 ; Atk
	bigdw 329 ; Def
	bigdw 169 ; Spd
	bigdw 178 ; SAtk
	bigdw 178 ; SDef
	db "SAIDON@@@@@"

	dw STEELIX
	db LEFTOVERS
	dw EARTHQUAKE, HYPER_BEAM, SWAGGER, CRUNCH

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 60000
	bigdw 50000
	dn 15, 13, 13, 14 ; DVs
	db 10, 5, 15, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 344 ; HP
	bigdw 344 ; Max HP
	bigdw 301 ; Atk
	bigdw 489 ; Def
	bigdw 152 ; Spd
	bigdw 179 ; SAtk
	bigdw 219 ; SDef
	db "HAGANE-RU@@"

	dw FEAROW
	db KINGS_ROCK
	dw DRILL_PECK, STEEL_WING, HYPER_BEAM, MUD_SLAP

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 55000
	bigdw 50000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	dn 15, 13, 12, 15 ; DVs
	db 20, 25, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 324 ; HP
	bigdw 324 ; Max HP
	bigdw 311 ; Atk
	bigdw 217 ; Def
	bigdw 287 ; Spd
	bigdw 213 ; SAtk
	bigdw 213 ; SDef
	db "ONIDORIRU@@"

	dw MISDREAVUS
	db FOCUS_BAND
	dw PERISH_SONG, MEAN_LOOK, PAIN_SPLIT, SHADOW_BALL

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 45000
	bigdw 50000
	bigdw 55000
	bigdw 50000
	bigdw 55000
	dn 11, 13, 14, 15 ; DVs
	db 5, 5, 20, 15 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 309 ; HP
	bigdw 309 ; Max HP
	bigdw 203 ; Atk
	bigdw 209 ; Def
	bigdw 259 ; Spd
	bigdw 263 ; SAtk
	bigdw 263 ; SDef
	db "MUUMA@@@@@@"

	dw SNEASEL
	db SCOPE_LENS
	dw SLASH, BLIZZARD, DREAM_EATER, FAINT_ATTACK

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 48000
	bigdw 45000
	bigdw 50000
	dn 15, 13, 14, 15 ; DVs
	db 20, 5, 15, 20 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 302 ; HP
	bigdw 302 ; Max HP
	bigdw 281 ; Atk
	bigdw 196 ; Def
	bigdw 316 ; Spd
	bigdw 161 ; SAtk
	bigdw 241 ; SDef
	db "NIyu-RA@@@@"

	dw SCIZOR
	db QUICK_CLAW
	dw STEEL_WING, HYPER_BEAM, SLASH, TOXIC

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 45000
	dn 15, 11, 15, 14 ; DVs
	db 25, 5, 20, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 334 ; HP
	bigdw 334 ; Max HP
	bigdw 351 ; Atk
	bigdw 283 ; Def
	bigdw 221 ; Spd
	bigdw 196 ; SAtk
	bigdw 246 ; SDef
	db "HAtuSAMU@@@"

	dw BLISSEY
	db LEFTOVERS
	dw THUNDERBOLT, BLIZZARD, FIRE_BLAST, SOFTBOILED

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 40000
	bigdw 50000
	bigdw 30000
	bigdw 30000
	dn 13, 13, 15, 14 ; DVs
	db 15, 5, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 704 ; HP
	bigdw 704 ; Max HP
	bigdw 101 ; Atk
	bigdw 107 ; Def
	bigdw 188 ; Spd
	bigdw 226 ; SAtk
	bigdw 346 ; SDef
	db "HAPINASU@@@"

	dw PILOSWINE
	db MINT_BERRY
	dw REST, BLIZZARD, HYPER_BEAM, EARTHQUAKE

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 7 ; DVs
	db 10, 5, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 388 ; HP
	bigdw 388 ; Max HP
	bigdw 291 ; Atk
	bigdw 249 ; Def
	bigdw 191 ; Spd
	bigdw 195 ; SAtk
	bigdw 195 ; SDef
	db "INOMU-@@@@@"

	dw EXEGGUTOR
	db QUICK_CLAW
	dw PSYCHIC_M, TOXIC, EXPLOSION, GIGA_DRAIN

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 14, 15, 14 ; DVs
	db 10, 10, 5, 5 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 376 ; HP
	bigdw 376 ; Max HP
	bigdw 281 ; Atk
	bigdw 259 ; Def
	bigdw 201 ; Spd
	bigdw 339 ; SAtk
	bigdw 239 ; SDef
	db "NAtuSI-@@@@"

	dw OMASTAR
	db LEFTOVERS
	dw SURF, ANCIENTPOWER, BLIZZARD, TOXIC

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	bigdw 50000
	dn 15, 11, 14, 7 ; DVs
	db 15, 5, 5, 10 ; PP
	db 100 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 332 ; HP
	bigdw 332 ; Max HP
	bigdw 211 ; Atk
	bigdw 333 ; Def
	bigdw 199 ; Spd
	bigdw 305 ; SAtk
	bigdw 215 ; SDef
	db "OMUSUTA-@@@"

	dw GOLEM
	db BRIGHTPOWDER
	dw EXPLOSION, EARTHQUAKE, ROCK_SLIDE, FIRE_BLAST

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 4, 4, 6 ; DVs
	db 5, 10, 10, 5 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 329 ; HP
	bigdw 329 ; Max HP
	bigdw 302 ; Atk
	bigdw 316 ; Def
	bigdw 146 ; Spd
	bigdw 170 ; SAtk
	bigdw 190 ; SDef
	db "GORO-NIya@@"

	dw HITMONCHAN
	db FOCUS_BAND
	dw COUNTER, FIRE_PUNCH, THUNDERPUNCH, ICE_PUNCH

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 6, 7, 7, 6 ; DVs
	db 20, 15, 15, 15 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_1 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 265 ; HP
	bigdw 265 ; Max HP
	bigdw 270 ; Atk
	bigdw 220 ; Def
	bigdw 214 ; Spd
	bigdw 130 ; SAtk
	bigdw 280 ; SDef
	db "EBIWARA-@@@"

	dw LANTURN
	db QUICK_CLAW
	dw SURF, RAIN_DANCE, ZAP_CANNON, CONFUSE_RAY

	dw 0 ; OT ID
	dt 1000000 ; Exp
	; Stat exp
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	bigdw 30000
	dn 7, 6, 5, 7 ; DVs
	db 15, 5, 5, 10 ; PP
	db 0 ; Happiness
	db 0, 0, 0 ; Pokerus, Caught data
	db 100 ; Level
	db ABILITY_2 ; Personality
	db HIDDEN_POWER_DEFAULT_TYPE ; Hidden Power type
	db 0, 0 ; Status
	bigdw 425 ; HP
	bigdw 425 ; Max HP
	bigdw 178 ; Atk
	bigdw 200 ; Def
	bigdw 192 ; Spd
	bigdw 234 ; SAtk
	bigdw 214 ; SDef
	db "RANTA-N@@@@"

	btmon CHANDELURE, CHOICE_SPECS, SHADOW_BALL, FLAMETHROWER, ENERGY_BALL, PSYCHIC_M, 100, 60000, ABILITY_1
	btmon GALVANTULA, FOCUS_SASH, THUNDERBOLT, BUG_BUZZ, ENERGY_BALL, THUNDER_WAVE, 100, 60000, ABILITY_1
	btmon MAWILE, LIFE_ORB, PLAY_ROUGH, IRON_HEAD, SUCKER_PUNCH, SWORDS_DANCE, 100, 60000, ABILITY_1
	btmon NOIVERN, CHOICE_SPECS, DRACO_METEOR, AIR_SLASH, FLAMETHROWER, U_TURN, 100, 60000, ABILITY_1
	btmon SALAZZLE, FOCUS_SASH, FLAMETHROWER, SLUDGE_BOMB, NASTY_PLOT, WILL_O_WISP, 100, 60000, ABILITY_1
	btmon ESPATHRA, LEFTOVERS, PSYCHIC_M, DAZZLING_GLEAM, CALM_MIND, ROOST, 100, 60000, ABILITY_1
	btmon PALAFIN, CHOICE_BAND, LIQUIDATION, CLOSE_COMBAT, ICE_PUNCH, FLIP_TURN, 100, 60000, ABILITY_1
	btmon STARAPTOR, CHOICE_SCARF, BRAVE_BIRD, CLOSE_COMBAT, DOUBLE_EDGE, U_TURN, 100, 60000, ABILITY_1
	btmon KROOKODILE, EXPERT_BELT, EARTHQUAKE, CRUNCH, ROCK_SLIDE, DRAGON_CLAW, 100, 60000, ABILITY_1
	btmon DUSKNOIR, ASSAULT_VEST, SHADOW_PUNCH, ICE_PUNCH, FIRE_PUNCH, EARTHQUAKE, 100, 60000, ABILITY_1
	btmon AGGRON, WEAK_POLICY, HEAD_SMASH, IRON_HEAD, EARTHQUAKE, ROCK_SLIDE, 100, 60000, ABILITY_1

ASSERT @ - BattleTowerMons10 == BATTLETOWER_NUM_UNIQUE_MON * (NICKNAMED_MON_STRUCT_LENGTH + 5)

; Reserved for the seventh opponent in the L100 room; never sampled normally.
BattleTowerMew:
	btmon MEW, LEFTOVERS, PSYCHIC_M, AURA_SPHERE, ICE_BEAM, SOFTBOILED, 100, 65535, ABILITY_1
BattleTowerMewEnd:
ASSERT BattleTowerMewEnd - BattleTowerMew == NICKNAMED_MON_STRUCT_LENGTH + 5
