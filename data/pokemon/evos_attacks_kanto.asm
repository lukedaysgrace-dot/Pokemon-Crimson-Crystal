SECTION "Evolutions and Attacks 1", ROMX

EvosAttacksPointers1::
	dw BulbasaurEvosAttacks
	dw IvysaurEvosAttacks
	dw VenusaurEvosAttacks
	dw CharmanderEvosAttacks
	dw CharmeleonEvosAttacks
	dw CharizardEvosAttacks
	dw SquirtleEvosAttacks
	dw WartortleEvosAttacks
	dw BlastoiseEvosAttacks
	dw CaterpieEvosAttacks
	dw MetapodEvosAttacks
	dw ButterfreeEvosAttacks
	dw WeedleEvosAttacks
	dw KakunaEvosAttacks
	dw BeedrillEvosAttacks
	dw PidgeyEvosAttacks
	dw PidgeottoEvosAttacks
	dw PidgeotEvosAttacks
	dw RattataEvosAttacks
	dw RaticateEvosAttacks
	dw SpearowEvosAttacks
	dw FearowEvosAttacks
	dw EkansEvosAttacks
	dw ArbokEvosAttacks
	dw PikachuEvosAttacks
	dw RaichuEvosAttacks
	dw SandshrewEvosAttacks
	dw SandslashEvosAttacks
	dw NidoranFEvosAttacks
	dw NidorinaEvosAttacks
	dw NidoqueenEvosAttacks
	dw NidoranMEvosAttacks
	dw NidorinoEvosAttacks
	dw NidokingEvosAttacks
	dw ClefairyEvosAttacks
	dw ClefableEvosAttacks
	dw VulpixEvosAttacks
	dw NinetalesEvosAttacks
	dw JigglypuffEvosAttacks
	dw WigglytuffEvosAttacks
	dw ZubatEvosAttacks
	dw GolbatEvosAttacks
	dw OddishEvosAttacks
	dw GloomEvosAttacks
	dw VileplumeEvosAttacks
	dw ParasEvosAttacks
	dw ParasectEvosAttacks
	dw VenonatEvosAttacks
	dw VenomothEvosAttacks
	dw DiglettEvosAttacks
	dw DugtrioEvosAttacks
	dw MeowthEvosAttacks
	dw PersianEvosAttacks
	dw PsyduckEvosAttacks
	dw GolduckEvosAttacks
	dw MankeyEvosAttacks
	dw PrimeapeEvosAttacks
	dw GrowlitheEvosAttacks
	dw ArcanineEvosAttacks
	dw PoliwagEvosAttacks
	dw PoliwhirlEvosAttacks
	dw PoliwrathEvosAttacks
	dw AbraEvosAttacks
	dw KadabraEvosAttacks
	dw AlakazamEvosAttacks
	dw MachopEvosAttacks
	dw MachokeEvosAttacks
	dw MachampEvosAttacks
	dw BellsproutEvosAttacks
	dw WeepinbellEvosAttacks
	dw VictreebelEvosAttacks
	dw TentacoolEvosAttacks
	dw TentacruelEvosAttacks
	dw GeodudeEvosAttacks
	dw GravelerEvosAttacks
	dw GolemEvosAttacks
	dw PonytaEvosAttacks
	dw RapidashEvosAttacks
	dw SlowpokeEvosAttacks
	dw SlowbroEvosAttacks
	dw MagnemiteEvosAttacks
	dw MagnetonEvosAttacks
	dw FarfetchDEvosAttacks
	dw DoduoEvosAttacks
	dw DodrioEvosAttacks
	dw SeelEvosAttacks
	dw DewgongEvosAttacks
	dw GrimerEvosAttacks
	dw MukEvosAttacks
	dw ShellderEvosAttacks
	dw CloysterEvosAttacks
	dw GastlyEvosAttacks
	dw HaunterEvosAttacks
	dw GengarEvosAttacks
	dw OnixEvosAttacks
	dw DrowzeeEvosAttacks
	dw HypnoEvosAttacks
	dw KrabbyEvosAttacks
	dw KinglerEvosAttacks
	dw VoltorbEvosAttacks
	dw ElectrodeEvosAttacks
	dw ExeggcuteEvosAttacks
	dw ExeggutorEvosAttacks
	dw CuboneEvosAttacks
	dw MarowakEvosAttacks
	dw HitmonleeEvosAttacks
	dw HitmonchanEvosAttacks
	dw LickitungEvosAttacks
	dw KoffingEvosAttacks
	dw WeezingEvosAttacks
	dw RhyhornEvosAttacks
	dw RhydonEvosAttacks
	dw ChanseyEvosAttacks
	dw TangelaEvosAttacks
	dw KangaskhanEvosAttacks
	dw HorseaEvosAttacks
	dw SeadraEvosAttacks

BulbasaurEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, IVYSAUR
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 5, VINE_WHIP
	dbw 8, LEECH_SEED
	dbw 11, RAZOR_LEAF
	dbw 14, POISONPOWDER
	dbw 14, SLEEP_POWDER
	dbw 17, SLUDGE
	dbw 18, VENOSHOCK
	dbw 20, TAKE_DOWN
	dbw 23, SWEET_SCENT
	dbw 26, SLUDGE_BOMB
	dbw 29, GROWTH
	dbw 30, RAZOR_WIND
	dbw 33, POWER_WHIP
	dbw 35, DOUBLE_EDGE
	dbw 36, SOLARBEAM
	dbw 38, SYNTHESIS
	dbw 41, SEED_BOMB
	db 0 ; no more level-up moves

IvysaurEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, VENUSAUR
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 5, VINE_WHIP
	dbw 8, LEECH_SEED
	dbw 11, RAZOR_LEAF
	dbw 14, POISONPOWDER
	dbw 14, SLEEP_POWDER
	dbw 18, SLUDGE
	dbw 20, SEED_BOMB
	dbw 22, TAKE_DOWN
	dbw 24, VENOSHOCK
	dbw 26, SWEET_SCENT
	dbw 30, SLUDGE_BOMB
	dbw 34, GROWTH
	dbw 42, DOUBLE_EDGE
	dbw 45, POWER_WHIP
	dbw 46, SYNTHESIS
	dbw 50, SOLARBEAM
	db 0 ; no more level-up moves

VenusaurEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EARTH_POWER
	dbw 1, GROWL
	dbw 1, POWER_WHIP
	dbw 1, TACKLE
	dbw 1, PETAL_BLIZZARD
	dbw 5, VINE_WHIP
	dbw 8, LEECH_SEED
	dbw 11, RAZOR_LEAF
	dbw 14, POISONPOWDER
	dbw 14, SLEEP_POWDER
	dbw 18, SLUDGE
	dbw 20, SEED_BOMB
	dbw 22, TAKE_DOWN
	dbw 24, VENOSHOCK
	dbw 26, SWEET_SCENT
	dbw 28, GIGA_DRAIN
	dbw 30, SLUDGE_BOMB
	dbw 30, SWORDS_DANCE
	dbw 32, PETAL_DANCE
	dbw 35, GROWTH
	dbw 42, POISON_JAB
	dbw 45, DOUBLE_EDGE
	dbw 50, SYNTHESIS
	dbw 55, SOLARBEAM
	dbw 62, LEAF_STORM
	db 0 ; no more level-up moves

CharmanderEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, CHARMELEON
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 5, EMBER
	dbw 8, SMOKESCREEN
	dbw 11, METAL_CLAW
	dbw 12, DRAGONBREATH
	dbw 14, BITE
	dbw 16, DRAGON_RAGE
	dbw 17, INCINERATE
	dbw 19, RAGE
	dbw 20, FIRE_FANG
	dbw 23, SLASH
	dbw 26, FLAMETHROWER
	dbw 29, SCARY_FACE
	dbw 32, CRUNCH
	dbw 35, DRAGON_PULSE
	dbw 38, FIRE_SPIN
	dbw 41, BELLY_DRUM
	dbw 42, HEAT_WAVE
	dbw 44, FLARE_BLITZ
	dbw 56, OVERHEAT
	db 0 ; no more level-up moves

CharmeleonEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, CHARIZARD
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 5, EMBER
	dbw 8, SMOKESCREEN
	dbw 11, METAL_CLAW
	dbw 14, BITE
	dbw 16, DRAGONBREATH
	dbw 17, DRAGON_RAGE
	dbw 19, INCINERATE
	dbw 20, RAGE
	dbw 22, FIRE_FANG
	dbw 26, SLASH
	dbw 30, FLAMETHROWER
	dbw 34, SCARY_FACE
	dbw 38, CRUNCH
	dbw 42, DRAGON_PULSE
	dbw 44, HEAT_WAVE
	dbw 46, FIRE_SPIN
	dbw 50, BELLY_DRUM
	dbw 54, FLARE_BLITZ
	dbw 56, OVERHEAT
	db 0 ; no more level-up moves

CharizardEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DRAGON_CLAW
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 1, SHADOW_CLAW
	dbw 1, WING_ATTACK
	dbw 5, EMBER
	dbw 8, SMOKESCREEN
	dbw 11, METAL_CLAW
	dbw 14, BITE
	dbw 16, DRAGONBREATH
	dbw 17, DRAGON_RAGE
	dbw 19, INCINERATE
	dbw 20, RAGE
	dbw 22, FIRE_FANG
	dbw 26, SLASH
	dbw 30, FLAMETHROWER
	dbw 34, SCARY_FACE
	dbw 36, AIR_SLASH
	dbw 36, ROOST
	dbw 39, CRUNCH
	dbw 40, FOCUS_BLAST
	dbw 42, HEAT_CRASH
	dbw 44, DRAGON_PULSE
	dbw 44, DRAGON_TAIL
	dbw 49, FIRE_SPIN
	dbw 54, BELLY_DRUM
	dbw 55, HEAT_WAVE
	dbw 59, FLARE_BLITZ
	dbw 62, OVERHEAT
	db 0 ; no more level-up moves

SquirtleEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, WARTORTLE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 5, WATER_GUN
	dbw 8, WITHDRAW
	dbw 11, BUBBLE
	dbw 14, BITE
	dbw 17, RAPID_SPIN
	dbw 20, WATER_PULSE
	dbw 23, PROTECT
	dbw 30, IRON_DEFENSE
	dbw 32, SKULL_BASH
	dbw 35, AQUA_TAIL
	dbw 36, SHELL_SMASH
	dbw 38, RAIN_DANCE
	dbw 41, HYDRO_PUMP
	dbw 42, SCALD
	dbw 44, LIQUIDATION
	dbw 44, WATER_SPOUT
	db 0 ; no more level-up moves

WartortleEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, BLASTOISE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 5, WATER_GUN
	dbw 8, WITHDRAW
	dbw 11, BUBBLE
	dbw 14, BITE
	dbw 18, RAPID_SPIN
	dbw 22, WATER_PULSE
	dbw 26, PROTECT
	dbw 36, SHELL_SMASH
	dbw 38, SKULL_BASH
	dbw 40, IRON_DEFENSE
	dbw 42, AQUA_TAIL
	dbw 44, SCALD
	dbw 46, RAIN_DANCE
	dbw 48, LIQUIDATION
	dbw 50, HYDRO_PUMP
	dbw 54, WATER_SPOUT
	db 0 ; no more level-up moves

BlastoiseEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FLASH_CANNON
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 5, WATER_GUN
	dbw 8, WITHDRAW
	dbw 11, BUBBLE
	dbw 14, BITE
	dbw 18, RAPID_SPIN
	dbw 20, BULLDOZE
	dbw 22, WATER_PULSE
	dbw 24, DRAGON_TAIL
	dbw 26, PROTECT
	dbw 28, IRON_DEFENSE
	dbw 32, BODY_PRESS
	dbw 36, AURA_SPHERE
	dbw 36, SHELL_SMASH
	dbw 39, SKULL_BASH
	dbw 42, SCALD
	dbw 44, AQUA_TAIL
	dbw 46, LIQUIDATION
	dbw 49, RAIN_DANCE
	dbw 50, IRON_TAIL
	dbw 54, HYDRO_PUMP
	dbw 59, WATER_SPOUT
	db 0 ; no more level-up moves

CaterpieEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, METAPOD
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, STRING_SHOT
	dbw 1, TACKLE
	db 0 ; no more level-up moves

MetapodEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, BUTTERFREE
	db 0 ; no more evolutions
	dbw 7, HARDEN
	dbw 18, BUG_BITE
	db 0 ; no more level-up moves

ButterfreeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, HARDEN
	dbw 1, STRING_SHOT
	dbw 1, TACKLE
	dbw 10, GUST
	dbw 11, CONFUSION
	dbw 13, POISONPOWDER
	dbw 13, SLEEP_POWDER
	dbw 13, STUN_SPORE
	dbw 18, INFESTATION
	dbw 19, PSYBEAM
	dbw 21, SUPERSONIC
	dbw 23, AIR_SLASH
	dbw 25, SAFEGUARD
	dbw 28, BUG_BUZZ
	dbw 30, U_TURN
	dbw 34, DEFOG
	dbw 36, SIGNAL_BEAM
	dbw 36, ROOST
	dbw 37, WHIRLWIND
	dbw 42, QUIVER_DANCE
	dbw 43, TELEPORT
	dbw 45, HURRICANE
	db 0 ; no more level-up moves

WeedleEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, KAKUNA
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	db 0 ; no more level-up moves

KakunaEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, BEEDRILL
	db 0 ; no more evolutions
	dbw 7, HARDEN
	dbw 18, BUG_BITE
	db 0 ; no more level-up moves

BeedrillEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, HARDEN
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 1, TWINEEDLE
	dbw 10, FURY_ATTACK
	dbw 11, FURY_CUTTER
	dbw 14, RAGE
	dbw 15, TOXIC_SPIKES
	dbw 17, PIN_MISSILE
	dbw 17, PURSUIT
	dbw 21, FOCUS_ENERGY
	dbw 23, POISON_JAB
	dbw 28, X_SCISSOR
	dbw 30, DUALWINGBEAT
	dbw 30, U_TURN
	dbw 30, SWORDS_DANCE
	dbw 34, DRILL_PECK
	dbw 37, AGILITY
	dbw 38, DRILL_RUN
	dbw 40, CROSS_POISON
	dbw 43, OUTRAGE
	dbw 45, MEGAHORN
	db 0 ; no more level-up moves

PidgeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, PIDGEOTTO
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, SAND_ATTACK
	dbw 1, TACKLE
	dbw 6, QUICK_ATTACK
	dbw 9, WING_ATTACK
	dbw 12, SWIFT
	dbw 21, TWISTER
	dbw 24, AIR_SLASH
	dbw 27, AGILITY
	dbw 27, RAZOR_WIND
	dbw 30, ROOST
	dbw 34, WHIRLWIND
	dbw 42, HURRICANE
	dbw 44, HEAT_WAVE
	dbw 45, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeottoEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, PIDGEOT
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, SAND_ATTACK
	dbw 1, TACKLE
	dbw 6, QUICK_ATTACK
	dbw 9, WING_ATTACK
	dbw 12, SWIFT
	dbw 22, TWISTER
	dbw 27, AIR_SLASH
	dbw 31, AGILITY
	dbw 31, RAZOR_WIND
	dbw 35, ROOST
	dbw 39, WHIRLWIND
	dbw 42, HEAT_WAVE
	dbw 47, HURRICANE
	dbw 52, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeotEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, SAND_ATTACK
	dbw 1, TACKLE
	dbw 6, QUICK_ATTACK
	dbw 9, WING_ATTACK
	dbw 12, SWIFT
	dbw 22, TWISTER
	dbw 27, AIR_SLASH
	dbw 30, U_TURN
	dbw 31, AGILITY
	dbw 31, RAZOR_WIND
	dbw 35, ROOST
	dbw 36, HEAT_WAVE
	dbw 40, WHIRLWIND
	dbw 44, HYPER_VOICE
	dbw 50, HURRICANE
	dbw 56, MIRROR_MOVE
	db 0 ; no more level-up moves

RattataEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, RATICATE
	db 0 ; no more evolutions
	dbw 1, QUICK_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, BITE
	dbw 10, FOCUS_ENERGY
	dbw 13, PURSUIT
	dbw 16, HYPER_FANG
	dbw 16, TAKE_DOWN
	dbw 22, SUPER_FANG
	dbw 25, CRUNCH
	dbw 28, SUCKER_PUNCH
	dbw 31, FLAME_WHEEL
	dbw 34, DOUBLE_EDGE
	dbw 37, REVERSAL
	dbw 42, BODY_SLAM
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

RaticateEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, QUICK_ATTACK
	dbw 1, SWORDS_DANCE
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, BITE
	dbw 10, FOCUS_ENERGY
	dbw 13, PURSUIT
	dbw 16, HYPER_FANG
	dbw 16, TAKE_DOWN
	dbw 20, SCARY_FACE
	dbw 23, SUPER_FANG
	dbw 26, WORK_UP
	dbw 27, CRUNCH
	dbw 30, U_TURN
	dbw 31, SUCKER_PUNCH
	dbw 35, FLAME_WHEEL
	dbw 39, DOUBLE_EDGE
	dbw 42, BODY_SLAM
	dbw 43, REVERSAL
	dbw 56, GIGA_IMPACT
	dbw 58, SKULL_BASH
	db 0 ; no more level-up moves

SpearowEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, FEAROW
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, LEER
	dbw 1, PECK
	dbw 8, FURY_ATTACK
	dbw 8, PURSUIT
	dbw 11, AERIAL_ACE
	dbw 15, WING_ATTACK
	dbw 18, FACADE
	dbw 18, MIRROR_MOVE
	dbw 22, TAKE_DOWN
	dbw 25, DRILL_PECK
	dbw 28, AGILITY
	dbw 28, DUALWINGBEAT
	dbw 34, FOCUS_ENERGY
	dbw 36, DEFOG
	dbw 37, ROOST
	dbw 43, DOUBLE_EDGE
	dbw 46, BRAVE_BIRD
	db 0 ; no more level-up moves

FearowEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, PURSUIT
	dbw 10, FURY_ATTACK
	dbw 11, AERIAL_ACE
	dbw 15, WING_ATTACK
	dbw 18, FACADE
	dbw 18, MIRROR_MOVE
	dbw 23, TAKE_DOWN
	dbw 27, DRILL_PECK
	dbw 30, U_TURN
	dbw 31, AGILITY
	dbw 32, DUALWINGBEAT
	dbw 34, DRILL_RUN
	dbw 36, DEFOG
	dbw 39, FOCUS_ENERGY
	dbw 43, ROOST
	dbw 51, DOUBLE_EDGE
	dbw 55, BRAVE_BIRD
	dbw 56, GIGA_IMPACT
	db 0 ; no more level-up moves

EkansEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, ARBOK
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, WRAP
	dbw 4, POISON_STING
	dbw 7, BITE
	dbw 10, ACID
	dbw 13, GLARE
	dbw 16, POISON_FANG
	dbw 18, VENOSHOCK
	dbw 22, SCREECH
	dbw 28, POISON_JAB
	dbw 28, POISON_TAIL
	dbw 31, LEECH_LIFE
	dbw 34, HAZE
	dbw 37, SUCKER_PUNCH
	dbw 38, TOXIC_SPIKES
	dbw 40, GUNK_SHOT
	dbw 42, AQUA_TAIL
	db 0 ; no more level-up moves

ArbokEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FIRE_FANG
	dbw 1, ICE_FANG
	dbw 1, LEER
	dbw 1, THUNDER_FANG
	dbw 1, WRAP
	dbw 4, POISON_STING
	dbw 7, BITE
	dbw 10, ACID
	dbw 13, GLARE
	dbw 16, POISON_FANG
	dbw 22, CRUNCH
	dbw 23, SCREECH
	dbw 24, TOXIC_SPIKES
	dbw 28, POISON_JAB
	dbw 31, POISON_TAIL
	dbw 34, ROCK_SLIDE
	dbw 35, LEECH_LIFE
	dbw 39, HAZE
	dbw 40, DRAGON_TAIL
	dbw 42, AQUA_TAIL
	dbw 43, SUCKER_PUNCH
	dbw 47, GUNK_SHOT
	db 0 ; no more level-up moves

PikachuEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, RAICHU
	dbbw EVOLVE_ITEM, SUN_STONE, RAICHU_ALOLAN
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, GROWL
	dbw 1, NASTY_PLOT
	dbw 1, SWEET_KISS
	dbw 1, TAIL_WHIP
	dbw 1, THUNDERSHOCK
	dbw 4, QUICK_ATTACK
	dbw 7, THUNDER_WAVE
	dbw 8, NUZZLE
	dbw 11, DOUBLE_KICK
	dbw 19, SPARK
	dbw 21, DOUBLE_TEAM
	dbw 23, SLAM
	dbw 26, THUNDERBOLT
	dbw 28, IRON_TAIL
	dbw 29, AGILITY
	dbw 30, SIGNAL_BEAM
	dbw 31, DISCHARGE
	dbw 33, WILD_CHARGE
	dbw 36, LIGHT_SCREEN
	dbw 38, VOLT_SWITCH
	dbw 39, THUNDER
	db 0 ; no more level-up moves

RaichuEvosAttacks:
	dbbw EVOLVE_ITEM, DUSK_STONE, GOROCHU
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, GROWL
	dbw 1, IRON_TAIL
	dbw 1, NASTY_PLOT
	dbw 1, SWEET_KISS
	dbw 1, TAIL_WHIP
	dbw 1, THUNDERPUNCH
	dbw 1, THUNDERSHOCK
	dbw 4, QUICK_ATTACK
	dbw 7, THUNDER_WAVE
	dbw 8, NUZZLE
	dbw 11, DOUBLE_KICK
	dbw 19, SPARK
	dbw 21, DOUBLE_TEAM
	dbw 23, SLAM
	dbw 26, THUNDERBOLT
	dbw 28, SIGNAL_BEAM
	dbw 29, AGILITY
	dbw 30, VOLT_SWITCH
	dbw 33, WILD_CHARGE
	dbw 36, LIGHT_SCREEN
	dbw 39, THUNDER
	dbw 40, FOCUS_BLAST
	dbw 60, DISCHARGE
	db 0 ; no more level-up moves

SandshrewEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, SANDSLASH
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, POISON_STING
	dbw 1, SAND_ATTACK
	dbw 1, SCRATCH
	dbw 7, ROLLOUT
	dbw 9, BULLDOZE
	dbw 11, RAPID_SPIN
	dbw 13, FURY_CUTTER
	dbw 14, MAGNITUDE
	dbw 15, SWIFT
	dbw 16, MUD_SHOT
	dbw 21, FURY_SWIPES
	dbw 24, SLASH
	dbw 27, AGILITY
	dbw 27, DIG
	dbw 30, GYRO_BALL
	dbw 33, POISON_JAB
	dbw 36, EARTHQUAKE
	dbw 38, SPIKES
	dbw 39, SWORDS_DANCE
	dbw 40, STEALTH_ROCK
	dbw 42, SANDSTORM
	dbw 45, FISSURE
	db 0 ; no more level-up moves

SandslashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AGILITY
	dbw 1, DEFENSE_CURL
	dbw 1, POISON_STING
	dbw 1, SAND_ATTACK
	dbw 1, SCRATCH
	dbw 7, ROLLOUT
	dbw 9, BULLDOZE
	dbw 11, RAPID_SPIN
	dbw 13, FURY_CUTTER
	dbw 14, MAGNITUDE
	dbw 15, SWIFT
	dbw 18, MUD_SHOT
	dbw 21, FURY_SWIPES
	dbw 24, STEALTH_ROCK
	dbw 25, SLASH
	dbw 29, DIG
	dbw 31, DRILL_RUN
	dbw 32, CRUSH_CLAW
	dbw 33, GYRO_BALL
	dbw 34, SPIKES
	dbw 37, POISON_JAB
	dbw 40, STONE_EDGE
	dbw 41, EARTHQUAKE
	dbw 45, SWORDS_DANCE
	dbw 49, SANDSTORM
	dbw 53, FISSURE
	db 0 ; no more level-up moves

NidoranFEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINA
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, POISON_STING
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 6, FURY_SWIPES
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, BITE
	dbw 18, VENOSHOCK
	dbw 21, TOXIC_SPIKES
	dbw 24, POISON_JAB
	dbw 30, CRUNCH
	dbw 33, POISON_TAIL
	dbw 39, SUPER_FANG
	dbw 40, TOXIC
	dbw 55, EARTH_POWER
	db 0 ; no more level-up moves

NidorinaEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, NIDOQUEEN
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, POISON_STING
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 6, FURY_SWIPES
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, BITE
	dbw 18, VENOSHOCK
	dbw 23, TOXIC_SPIKES
	dbw 27, POISON_JAB
	dbw 35, CRUNCH
	dbw 39, POISON_TAIL
	dbw 43, EARTH_POWER
	dbw 47, SUPER_FANG
	dbw 50, TOXIC
	db 0 ; no more level-up moves

NidoqueenEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, POISON_STING
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 1, SUPERPOWER
	dbw 6, FURY_SWIPES
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, BITE
	dbw 18, BULLDOZE
	dbw 20, DRAGON_TAIL
	dbw 22, VENOSHOCK
	dbw 23, TOXIC_SPIKES
	dbw 27, POISON_JAB
	dbw 29, SPIKES
	dbw 34, STEALTH_ROCK
	dbw 35, CRUNCH
	dbw 38, BODY_PRESS
	dbw 39, BODY_SLAM
	dbw 44, DRILL_RUN
	dbw 46, AQUA_TAIL
	dbw 50, EARTHQUAKE
	dbw 54, TOXIC
	dbw 56, POISON_TAIL
	dbw 58, EARTH_POWER
	dbw 62, SUPER_FANG
	db 0 ; no more level-up moves

NidoranMEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINO
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, POISON_STING
	dbw 6, FURY_ATTACK
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, HORN_ATTACK
	dbw 18, VENOSHOCK
	dbw 21, TOXIC_SPIKES
	dbw 24, POISON_JAB
	dbw 30, SUCKER_PUNCH
	dbw 33, POISON_TAIL
	dbw 40, TOXIC
	dbw 45, HORN_DRILL
	dbw 55, EARTH_POWER
	db 0 ; no more level-up moves

NidorinoEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, NIDOKING
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, POISON_STING
	dbw 6, FURY_ATTACK
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, HORN_ATTACK
	dbw 18, VENOSHOCK
	dbw 23, TOXIC_SPIKES
	dbw 27, POISON_JAB
	dbw 35, SUCKER_PUNCH
	dbw 39, POISON_TAIL
	dbw 43, EARTH_POWER
	dbw 50, TOXIC
	dbw 58, HORN_DRILL
	db 0 ; no more level-up moves

NidokingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, MEGAHORN
	dbw 1, PECK
	dbw 1, POISON_STING
	dbw 6, FURY_ATTACK
	dbw 9, DOUBLE_KICK
	dbw 12, POISON_FANG
	dbw 15, HORN_ATTACK
	dbw 18, BULLDOZE
	dbw 20, VENOSHOCK
	dbw 23, TOXIC_SPIKES
	dbw 26, BRICK_BREAK
	dbw 27, POISON_JAB
	dbw 29, THRASH
	dbw 34, STEALTH_ROCK
	dbw 35, SUCKER_PUNCH
	dbw 44, DRILL_RUN
	dbw 50, EARTHQUAKE
	dbw 54, TOXIC
	dbw 56, SUPERPOWER
	dbw 56, POISON_TAIL
	dbw 58, EARTH_POWER
	dbw 60, OUTRAGE
	db 0 ; no more level-up moves

ClefairyEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, CLEFABLE
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, GROWL
	dbw 1, POUND
	dbw 1, SPLASH
	dbw 1, SWEET_KISS
	dbw 1, TELEPORT
	dbw 4, ENCORE
	dbw 5, FAIRY_WIND
	dbw 7, SING
	dbw 9, DISARMING_VOICE
	dbw 10, DOUBLESLAP
	dbw 11, DEFENSE_CURL
	dbw 15, DRAINING_KISS
	dbw 19, BODY_SLAM
	dbw 21, MINIMIZE
	dbw 23, METRONOME
	dbw 25, COSMIC_POWER
	dbw 29, MOONBLAST
	dbw 31, MOONLIGHT
	dbw 35, METEOR_MASH
	dbw 36, CALM_MIND
	dbw 42, PLAY_ROUGH
	dbw 44, DAZZLING_GLEAM
	db 0 ; no more level-up moves

ClefableEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, GROWL
	dbw 1, POUND
	dbw 1, SPLASH
	dbw 1, SWEET_KISS
	dbw 1, TELEPORT
	dbw 1, DISARMING_VOICE
	dbw 4, ENCORE
	dbw 5, FAIRY_WIND
	dbw 7, SING
	dbw 10, DOUBLESLAP
	dbw 11, DEFENSE_CURL
	dbw 15, DRAINING_KISS
	dbw 19, BODY_SLAM
	dbw 20, THUNDER_WAVE
	dbw 21, MINIMIZE
	dbw 23, METRONOME
	dbw 24, STEALTH_ROCK
	dbw 29, MOONBLAST
	dbw 31, MOONLIGHT
	dbw 36, CALM_MIND
	dbw 42, PLAY_ROUGH
	dbw 44, DAZZLING_GLEAM
	dbw 44, COSMIC_POWER
	dbw 59, SOFTBOILED
	dbw 64, METEOR_MASH
	db 0 ; no more level-up moves

VulpixEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, NINETALES
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, TAIL_WHIP
	dbw 4, DISABLE
	dbw 4, ROAR
	dbw 7, QUICK_ATTACK
	dbw 11, CONFUSE_RAY
	dbw 12, SPITE
	dbw 13, FIRE_SPIN
	dbw 17, WILL_O_WISP
	dbw 19, INCINERATE
	dbw 22, FLAMETHROWER
	dbw 23, EXTRASENSORY
	dbw 23, FAINT_ATTACK
	dbw 26, HEX
	dbw 27, SAFEGUARD
	dbw 31, DARK_PULSE
	dbw 33, HYPNOSIS
	dbw 39, HEAT_WAVE
	dbw 45, FIRE_BLAST
	dbw 56, OVERHEAT
	db 0 ; no more level-up moves

NinetalesEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, NASTY_PLOT
	dbw 1, TAIL_WHIP
	dbw 3, DISABLE
	dbw 3, ROAR
	dbw 7, QUICK_ATTACK
	dbw 11, CONFUSE_RAY
	dbw 12, SPITE
	dbw 13, FIRE_SPIN
	dbw 17, WILL_O_WISP
	dbw 19, INCINERATE
	dbw 22, FLAMETHROWER
	dbw 23, EXTRASENSORY
	dbw 23, FAINT_ATTACK
	dbw 24, ENCORE
	dbw 27, SAFEGUARD
	dbw 30, CALM_MIND
	dbw 31, DARK_PULSE
	dbw 32, DAZZLING_GLEAM
	dbw 39, HEAT_WAVE
	dbw 45, FIRE_BLAST
	dbw 55, OVERHEAT
	dbw 60, MOONBLAST
	db 0 ; no more level-up moves

JigglypuffEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, WIGGLYTUFF
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DEFENSE_CURL
	dbw 1, SING
	dbw 1, SWEET_KISS
	dbw 4, POUND
	dbw 7, PIXIE_PUNCH
	dbw 9, DISARMING_VOICE
	dbw 13, DISABLE
	dbw 15, DRAINING_KISS
	dbw 17, DOUBLESLAP
	dbw 17, ROLLOUT
	dbw 19, BODY_SLAM
	dbw 25, HYPER_VOICE
	dbw 26, BOUNCE
	dbw 27, REST
	dbw 29, MOONBLAST
	dbw 30, CALM_MIND
	dbw 31, GYRO_BALL
	dbw 33, MIMIC
	dbw 35, DOUBLE_EDGE
	dbw 40, PLAY_ROUGH
	dbw 42, TAKE_DOWN
	dbw 44, DAZZLING_GLEAM
	dbw 46, TRI_ATTACK
	dbw 56, SELFDESTRUCT
	dbw 58, SKULL_BASH
	db 0 ; no more level-up moves

WigglytuffEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DEFENSE_CURL
	dbw 1, POUND
	dbw 1, SING
	dbw 1, SWEET_KISS
	dbw 1, PIXIE_PUNCH
	dbw 9, DISARMING_VOICE
	dbw 13, DISABLE
	dbw 15, DRAINING_KISS
	dbw 17, DOUBLESLAP
	dbw 17, ROLLOUT
	dbw 19, BODY_SLAM
	dbw 20, THUNDER_WAVE
	dbw 20, REFLECT
	dbw 20, LIGHT_SCREEN
	dbw 25, HYPER_VOICE
	dbw 27, REST
	dbw 29, MOONBLAST
	dbw 30, CALM_MIND
	dbw 33, MIMIC
	dbw 44, DAZZLING_GLEAM
	dbw 46, TRI_ATTACK
	dbw 58, SELFDESTRUCT
	db 0 ; no more level-up moves

ZubatEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, GOLBAT
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, ASTONISH
	dbw 1, SUPERSONIC
	dbw 7, BITE
	dbw 10, WING_ATTACK
	dbw 13, POISON_FANG
	dbw 15, CONFUSE_RAY
	dbw 19, MEAN_LOOK
	dbw 22, LEECH_LIFE
	dbw 25, SWIFT
	dbw 25, AIR_CUTTER
	dbw 28, HYPNOSIS
	dbw 30, ACROBATICS
	dbw 30, GIGA_DRAIN
	dbw 31, AIR_SLASH
	dbw 34, HAZE
	dbw 36, ROOST
	dbw 37, ZEN_HEADBUTT
	dbw 40, VENOSHOCK
	dbw 42, HEAT_WAVE
	dbw 43, BRAVE_BIRD
	db 0 ; no more level-up moves

GolbatEvosAttacks:
	dbbw EVOLVE_HAPPINESS, TR_ANYTIME, CROBAT
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, ASTONISH
	dbw 1, SCREECH
	dbw 1, SUPERSONIC
	dbw 7, BITE
	dbw 10, WING_ATTACK
	dbw 13, POISON_FANG
	dbw 15, CONFUSE_RAY
	dbw 19, MEAN_LOOK
	dbw 22, CRUNCH
	dbw 23, LEECH_LIFE
	dbw 27, SWIFT
	dbw 27, AIR_CUTTER
	dbw 30, CROSS_POISON
	dbw 30, DUALWINGBEAT
	dbw 31, HYPNOSIS
	dbw 33, ACROBATICS
	dbw 34, ROOST
	dbw 35, AIR_SLASH
	dbw 39, HAZE
	dbw 42, HEAT_WAVE
	dbw 43, ZEN_HEADBUTT
	dbw 48, VENOSHOCK
	dbw 51, BRAVE_BIRD
	db 0 ; no more level-up moves

OddishEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, GLOOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, GROWTH
	dbw 4, ACID
	dbw 7, SWEET_SCENT
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, BULLET_SEED
	dbw 13, MEGA_DRAIN
	dbw 18, MAGICAL_LEAF
	dbw 19, SLUDGE
	dbw 20, VENOSHOCK
	dbw 22, MOONLIGHT
	dbw 25, GIGA_DRAIN
	dbw 28, TOXIC
	dbw 31, MOONBLAST
	dbw 34, SLUDGE_BOMB
	dbw 40, PETAL_DANCE
	dbw 56, LEAF_STORM
	db 0 ; no more level-up moves

GloomEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, VILEPLUME
	dbbw EVOLVE_ITEM, SUN_STONE, BELLOSSOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, GROWTH
	dbw 4, ACID
	dbw 7, SWEET_SCENT
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, MEGA_DRAIN
	dbw 15, BULLET_SEED
	dbw 18, MAGICAL_LEAF
	dbw 19, SLUDGE
	dbw 20, VENOSHOCK
	dbw 23, MOONLIGHT
	dbw 27, GIGA_DRAIN
	dbw 31, TOXIC
	dbw 35, MOONBLAST
	dbw 39, SLUDGE_BOMB
	dbw 42, SEED_BOMB
	dbw 47, PETAL_DANCE
	dbw 49, PETAL_BLIZZARD
	dbw 56, LEAF_STORM
	db 0 ; no more level-up moves

VileplumeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, GROWTH
	dbw 1, TOXIC
	dbw 1, PETAL_BLIZZARD
	dbw 4, ACID
	dbw 7, SWEET_SCENT
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, MEGA_DRAIN
	dbw 15, BULLET_SEED
	dbw 18, MAGICAL_LEAF
	dbw 20, VENOSHOCK
	dbw 23, MOONLIGHT
	dbw 27, GIGA_DRAIN
	dbw 35, MOONBLAST
	dbw 39, SLUDGE_BOMB
	dbw 47, EARTH_POWER
	dbw 47, PETAL_DANCE
	dbw 55, LEAF_STORM
	dbw 67, SOLARBEAM
	db 0 ; no more level-up moves

ParasEvosAttacks:
	dbbw EVOLVE_LEVEL, 24, PARASECT
	db 0 ; no more evolutions
	dbw 1, FURY_CUTTER
	dbw 1, SCRATCH
	dbw 7, ABSORB
	dbw 10, POISONPOWDER
	dbw 10, STUN_SPORE
	dbw 12, BULLET_SEED
	dbw 13, BUG_BITE
	dbw 15, VENOSHOCK
	dbw 19, SPORE
	dbw 22, SLASH
	dbw 25, LEECH_LIFE
	dbw 28, GROWTH
	dbw 30, SWORDS_DANCE
	dbw 31, SEED_BOMB
	dbw 37, KNOCK_OFF
	dbw 46, X_SCISSOR
	db 0 ; no more level-up moves

ParasectEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FURY_CUTTER
	dbw 1, LEECH_SEED
	dbw 1, SCRATCH
	dbw 1, CROSS_POISON
	dbw 7, ABSORB
	dbw 10, POISONPOWDER
	dbw 10, STUN_SPORE
	dbw 12, BULLET_SEED
	dbw 13, BUG_BITE
	dbw 15, VENOSHOCK
	dbw 19, SPORE
	dbw 22, SLASH
	dbw 26, LEECH_LIFE
	dbw 30, GROWTH
	dbw 30, SWORDS_DANCE
	dbw 34, SEED_BOMB
	dbw 36, SYNTHESIS
	dbw 42, KNOCK_OFF
	dbw 50, X_SCISSOR
	db 0 ; no more level-up moves

VenonatEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, VENOMOTH
	db 0 ; no more evolutions
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 1, STRUGGLE_BUG
	dbw 1, TACKLE
	dbw 7, SUPERSONIC
	dbw 10, BUG_BITE
	dbw 13, CONFUSION
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 15, STUN_SPORE
	dbw 17, PSYBEAM
	dbw 18, INFESTATION
	dbw 21, POISON_FANG
	dbw 24, LEECH_LIFE
	dbw 25, BUG_BUZZ
	dbw 25, MEGA_DRAIN
	dbw 25, SIGNAL_BEAM
	dbw 27, ZEN_HEADBUTT
	dbw 30, SKILL_SWAP
	dbw 33, BATON_PASS
	dbw 39, MORNING_SUN
	dbw 47, PSYCHIC_M
	db 0 ; no more level-up moves

VenomothEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AIR_SLASH
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 1, STRUGGLE_BUG
	dbw 1, TACKLE
	dbw 1, WHIRLWIND
	dbw 7, SUPERSONIC
	dbw 10, BUG_BITE
	dbw 13, CONFUSION
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 15, STUN_SPORE
	dbw 17, PSYBEAM
	dbw 18, INFESTATION
	dbw 25, MEGA_DRAIN
	dbw 30, U_TURN
	dbw 31, GUST
	dbw 34, BATON_PASS
	dbw 38, SIGNAL_BEAM
	dbw 38, PSYCHIC_M
	dbw 42, MORNING_SUN
	dbw 42, QUIVER_DANCE
	dbw 46, BUG_BUZZ
	db 0 ; no more level-up moves

DiglettEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, DUGTRIO
	db 0 ; no more evolutions
	dbw 1, MUD_SLAP
	dbw 1, SAND_ATTACK
	dbw 1, SCRATCH
	dbw 4, GROWL
	dbw 7, ASTONISH
	dbw 10, BULLDOZE
	dbw 13, MAGNITUDE
	dbw 16, MUD_SHOT
	dbw 19, DIG
	dbw 21, FURY_SWIPES
	dbw 22, SUCKER_PUNCH
	dbw 28, ROCK_SLIDE
	dbw 28, SANDSTORM
	dbw 34, SLASH
	dbw 36, STEALTH_ROCK
	dbw 37, EARTHQUAKE
	dbw 43, FISSURE
	db 0 ; no more level-up moves

DugtrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, MUD_SLAP
	dbw 1, NIGHT_SLASH
	dbw 1, SAND_ATTACK
	dbw 1, SCRATCH
	dbw 4, GROWL
	dbw 7, ASTONISH
	dbw 10, BULLDOZE
	dbw 13, MAGNITUDE
	dbw 18, MUD_SHOT
	dbw 19, DIG
	dbw 21, FURY_SWIPES
	dbw 22, SUCKER_PUNCH
	dbw 24, STEALTH_ROCK
	dbw 29, ROCK_SLIDE
	dbw 30, SANDSTORM
	dbw 32, SWORDS_DANCE
	dbw 37, SLASH
	dbw 40, STONE_EDGE
	dbw 41, EARTHQUAKE
	dbw 49, FISSURE
	db 0 ; no more level-up moves

MeowthEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PERSIAN
	db 0 ; no more evolutions
	dbw 1, FAKE_OUT
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 6, BITE
	dbw 12, FURY_SWIPES
	dbw 15, SCREECH
	dbw 18, PAY_DAY
	dbw 20, SLASH
	dbw 20, TAUNT
	dbw 21, FAINT_ATTACK
	dbw 33, HYPNOSIS
	dbw 36, NASTY_PLOT
	dbw 39, PLAY_ROUGH
	dbw 42, HYPER_VOICE
	dbw 44, TAKE_DOWN
	dbw 46, BODY_SLAM
	dbw 48, DOUBLE_EDGE
	dbw 49, NIGHT_SLASH
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

PersianEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FAKE_OUT
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 6, BITE
	dbw 12, FURY_SWIPES
	dbw 12, PAY_DAY
	dbw 15, SCREECH
	dbw 18, SWIFT
	dbw 20, SLASH
	dbw 21, FAINT_ATTACK
	dbw 24, TAUNT
	dbw 28, POWER_GEM
	dbw 30, U_TURN
	dbw 34, HYPNOSIS
	dbw 36, HYPER_VOICE
	dbw 38, NASTY_PLOT
	dbw 42, PLAY_ROUGH
	dbw 44, TAKE_DOWN
	dbw 46, BODY_SLAM
	dbw 54, DOUBLE_EDGE
	dbw 56, GIGA_IMPACT
	dbw 58, SKULL_BASH
	dbw 61, NIGHT_SLASH
	db 0 ; no more level-up moves

PsyduckEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, GOLDUCK
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 6, WATER_GUN
	dbw 9, CONFUSION
	dbw 12, FURY_SWIPES
	dbw 15, WATER_PULSE
	dbw 18, DISABLE
	dbw 20, FLIP_TURN
	dbw 21, ZEN_HEADBUTT
	dbw 24, SCREECH
	dbw 27, HYPNOSIS
	dbw 30, AQUA_TAIL
	dbw 36, PSYCH_UP
	dbw 39, FUTURE_SIGHT
	dbw 42, AMNESIA
	dbw 44, SCALD
	dbw 45, CROSS_CHOP
	dbw 46, LIQUIDATION
	dbw 48, HYDRO_PUMP
	db 0 ; no more level-up moves

GolduckEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AQUA_JET
	dbw 1, BUBBLE
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 1, TELEPORT
	dbw 6, WATER_GUN
	dbw 9, CONFUSION
	dbw 12, FURY_SWIPES
	dbw 15, WATER_PULSE
	dbw 18, DISABLE
	dbw 21, ZEN_HEADBUTT
	dbw 24, SCREECH
	dbw 26, SIGNAL_BEAM
	dbw 27, HYPNOSIS
	dbw 30, AQUA_TAIL
	dbw 30, FLIP_TURN
	dbw 32, SCALD
	dbw 34, PSYCHIC_M
	dbw 36, CALM_MIND
	dbw 38, PSYCH_UP
	dbw 40, SKILL_SWAP
	dbw 42, FUTURE_SIGHT
	dbw 44, LIQUIDATION
	dbw 46, AMNESIA
	dbw 50, CROSS_CHOP
	dbw 54, HYDRO_PUMP
	db 0 ; no more level-up moves

MankeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PRIMEAPE
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 1, SCRATCH
	dbw 5, FURY_SWIPES
	dbw 8, MUD_SLAP
	dbw 12, PURSUIT
	dbw 13, KARATE_CHOP
	dbw 17, SEISMIC_TOSS
	dbw 18, LOW_SWEEP
	dbw 20, SWAGGER
	dbw 26, BRICK_BREAK
	dbw 29, SKULL_BASH
	dbw 30, CROSS_CHOP
	dbw 35, CLOSE_COMBAT
	dbw 38, THRASH
	dbw 41, U_TURN
	dbw 42, SUBMISSION
	dbw 44, SCREECH
	dbw 47, OUTRAGE
	db 0 ; no more level-up moves

PrimeapeEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, ANNIHILAPE
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 1, SCRATCH
	dbw 1, RAGE
	dbw 5, FURY_SWIPES
	dbw 8, MUD_SLAP
	dbw 12, PURSUIT
	dbw 13, KARATE_CHOP
	dbw 15, SEISMIC_TOSS
	dbw 17, SWAGGER
	dbw 20, LOW_SWEEP
	dbw 23, FIRE_PUNCH
	dbw 23, ICE_PUNCH
	dbw 23, THUNDERPUNCH
	dbw 26, WORK_UP
	dbw 30, BRICK_BREAK
	dbw 30, SKULL_BASH
	dbw 32, CROSS_CHOP
	dbw 35, RAGE_FIST
	dbw 38, CLOSE_COMBAT
	dbw 42, THRASH
	dbw 44, SUBMISSION
	dbw 46, U_TURN
	dbw 50, SCREECH
	dbw 54, OUTRAGE
	db 0 ; no more level-up moves

GrowlitheEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, ARCANINE
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, LEER
	dbw 1, ROAR
	dbw 7, EMBER
	dbw 15, FIRE_FANG
	dbw 18, REVERSAL
	dbw 21, TAKE_DOWN
	dbw 23, FLAME_WHEEL
	dbw 25, AGILITY
	dbw 26, INCINERATE
	dbw 28, FLAMETHROWER
	dbw 31, CRUNCH
	dbw 33, OUTRAGE
	dbw 38, PLAY_ROUGH
	dbw 41, FLARE_BLITZ
	dbw 41, HEAT_WAVE
	dbw 56, OVERHEAT
	db 0 ; no more level-up moves

ArcanineEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, EXTREMESPEED
	dbw 1, LEER
	dbw 1, ROAR
	dbw 1, THUNDER_FANG
	dbw 5, EMBER
	dbw 15, FIRE_FANG
	dbw 15, FLAME_WHEEL
	dbw 18, REVERSAL
	dbw 21, TAKE_DOWN
	dbw 25, AGILITY
	dbw 26, INCINERATE
	dbw 28, FLAMETHROWER
	dbw 31, CRUNCH
	dbw 33, OUTRAGE
	dbw 36, WILD_CHARGE
	dbw 38, PLAY_ROUGH
	dbw 41, FLARE_BLITZ
	dbw 42, HEAT_CRASH
	dbw 48, RAGING_FURY
	dbw 52, HEAT_WAVE
	dbw 60, CLOSE_COMBAT
	dbw 60, OVERHEAT
	db 0 ; no more level-up moves

PoliwagEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, POLIWHIRL
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, POUND
	dbw 6, HYPNOSIS
	dbw 9, WATER_GUN
	dbw 12, MUD_SHOT
	dbw 15, DOUBLESLAP
	dbw 15, RAIN_DANCE
	dbw 18, BUBBLEBEAM
	dbw 24, BODY_SLAM
	dbw 27, LOW_KICK
	dbw 30, BELLY_DRUM
	dbw 30, MIND_READER
	dbw 36, EARTH_POWER
	dbw 39, HYDRO_PUMP
	dbw 42, SCALD
	dbw 44, LIQUIDATION
	dbw 54, DOUBLE_EDGE
	db 0 ; no more level-up moves

PoliwhirlEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, POLIWRATH
	dbbw EVOLVE_ITEM, KINGS_ROCK, POLITOED
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, POUND
	dbw 1, MUD_SHOT
	dbw 6, HYPNOSIS
	dbw 9, WATER_GUN
	dbw 15, DOUBLESLAP
	dbw 15, RAIN_DANCE
	dbw 18, BUBBLEBEAM
	dbw 20, LOW_SWEEP
	dbw 24, BODY_SLAM
	dbw 28, LOW_KICK
	dbw 32, BELLY_DRUM
	dbw 40, EARTH_POWER
	dbw 42, SCALD
	dbw 44, HYDRO_PUMP
	dbw 46, LIQUIDATION
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

PoliwrathEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, POUND
	dbw 1, SUBMISSION
	dbw 1, MIND_READER
	dbw 1, MUD_SHOT
	dbw 1, VACUUM_WAVE
	dbw 6, HYPNOSIS
	dbw 9, WATER_GUN
	dbw 15, DOUBLESLAP
	dbw 15, RAIN_DANCE
	dbw 18, BUBBLEBEAM
	dbw 20, LOW_SWEEP
	dbw 24, BODY_SLAM
	dbw 26, MACH_PUNCH
	dbw 28, LOW_KICK
	dbw 31, ICE_PUNCH
	dbw 32, BELLY_DRUM
	dbw 34, BRICK_BREAK
	dbw 34, LIQUIDATION
	dbw 38, CIRCLE_THROW
	dbw 40, EARTH_POWER
	dbw 42, SCALD
	dbw 44, HYDRO_PUMP
	dbw 46, DYNAMICPUNCH
	dbw 46, SUPERPOWER
	dbw 56, FOCUS_BLAST
	dbw 66, DOUBLE_EDGE
	dbw 71, CLOSE_COMBAT
	db 0 ; no more level-up moves

AbraEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, KADABRA
	db 0 ; no more evolutions
	dbw 1, TELEPORT
	dbw 26, SIGNAL_BEAM
	dbw 30, SKILL_SWAP
	dbw 32, CALM_MIND
	dbw 34, TRICK
	dbw 36, TRICK_ROOM
	dbw 50, DREAM_EATER
	db 0 ; no more level-up moves

KadabraEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, ALAKAZAM
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, FLASH
	dbw 1, KINESIS
	dbw 1, TELEPORT
	dbw 16, PSYBEAM
	dbw 19, DISABLE
	dbw 22, NIGHT_SHADE
	dbw 26, SIGNAL_BEAM
	dbw 28, REFLECT
	dbw 30, PSYSHOCK
	dbw 34, RECOVER
	dbw 37, PSYCHIC_M
	dbw 38, TRICK_ROOM
	dbw 43, FUTURE_SIGHT
	dbw 46, SUBSTITUTE
	dbw 49, TRICK
	dbw 50, CALM_MIND
	dbw 52, DREAM_EATER
	db 0 ; no more level-up moves

AlakazamEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, FLASH
	dbw 1, KINESIS
	dbw 1, TELEPORT
	dbw 16, PSYBEAM
	dbw 19, DISABLE
	dbw 22, NIGHT_SHADE
	dbw 24, TAUNT
	dbw 26, SIGNAL_BEAM
	dbw 28, REFLECT
	dbw 30, PSYSHOCK
	dbw 34, RECOVER
	dbw 34, DAZZLING_GLEAM
	dbw 36, TRICK_ROOM
	dbw 37, PSYCHIC_M
	dbw 40, CALM_MIND
	dbw 43, FUTURE_SIGHT
	dbw 46, SUBSTITUTE
	dbw 49, TRICK
	dbw 50, DREAM_EATER
	dbw 52, AURA_SPHERE
	dbw 55, FOCUS_BLAST
	db 0 ; no more level-up moves

MachopEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MACHOKE
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 4, KARATE_CHOP
	dbw 10, FORESIGHT
	dbw 15, SEISMIC_TOSS
	dbw 18, LOW_SWEEP
	dbw 20, KNOCK_OFF
	dbw 23, VITAL_THROW
	dbw 25, BRICK_BREAK
	dbw 26, STRENGTH
	dbw 32, COUNTER
	dbw 33, SUBMISSION
	dbw 35, BULK_UP
	dbw 38, CROSS_CHOP
	dbw 41, SCARY_FACE
	dbw 44, DYNAMICPUNCH
	dbw 47, CLOSE_COMBAT
	dbw 52, DOUBLE_EDGE
	dbw 56, SUPERPOWER
	db 0 ; no more level-up moves

MachokeEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, MACHAMP
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 4, KARATE_CHOP
	dbw 10, FORESIGHT
	dbw 15, SEISMIC_TOSS
	dbw 20, KNOCK_OFF
	dbw 20, LOW_SWEEP
	dbw 23, VITAL_THROW
	dbw 26, STRENGTH
	dbw 26, WORK_UP
	dbw 29, BRICK_BREAK
	dbw 34, COUNTER
	dbw 37, SUBMISSION
	dbw 38, BULK_UP
	dbw 42, CROSS_CHOP
	dbw 46, SCARY_FACE
	dbw 50, DYNAMICPUNCH
	dbw 54, CLOSE_COMBAT
	dbw 56, SUPERPOWER
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

MachampEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BULLET_PUNCH
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 4, KARATE_CHOP
	dbw 10, FORESIGHT
	dbw 15, SEISMIC_TOSS
	dbw 20, KNOCK_OFF
	dbw 20, LOW_SWEEP
	dbw 23, VITAL_THROW
	dbw 26, STRENGTH
	dbw 28, WORK_UP
	dbw 33, BRICK_BREAK
	dbw 34, COUNTER
	dbw 37, SUBMISSION
	dbw 38, BULK_UP
	dbw 40, STONE_EDGE
	dbw 42, CROSS_CHOP
	dbw 46, SCARY_FACE
	dbw 50, DYNAMICPUNCH
	dbw 50, SUPERPOWER
	dbw 54, CLOSE_COMBAT
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

BellsproutEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, WEEPINBELL
	db 0 ; no more evolutions
	dbw 1, ACID
	dbw 1, GROWTH
	dbw 1, VINE_WHIP
	dbw 7, WRAP
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, BULLET_SEED
	dbw 13, RAZOR_LEAF
	dbw 16, SWEET_SCENT
	dbw 18, VENOSHOCK
	dbw 22, LEECH_LIFE
	dbw 25, POISON_JAB
	dbw 28, SEED_BOMB
	dbw 31, KNOCK_OFF
	dbw 34, SLAM
	dbw 40, POWER_WHIP
	dbw 56, LEAF_STORM
	db 0 ; no more level-up moves

WeepinbellEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, VICTREEBEL
	db 0 ; no more evolutions
	dbw 1, ACID
	dbw 1, GROWTH
	dbw 1, VINE_WHIP
	dbw 7, WRAP
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, RAZOR_LEAF
	dbw 15, BULLET_SEED
	dbw 16, SWEET_SCENT
	dbw 18, VENOSHOCK
	dbw 23, LEECH_LIFE
	dbw 27, POISON_JAB
	dbw 31, SEED_BOMB
	dbw 35, KNOCK_OFF
	dbw 39, SLAM
	dbw 47, POWER_WHIP
	dbw 56, LEAF_STORM
	db 0 ; no more level-up moves

VictreebelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ACID
	dbw 1, GROWTH
	dbw 1, VINE_WHIP
	dbw 7, WRAP
	dbw 10, POISONPOWDER
	dbw 10, SLEEP_POWDER
	dbw 10, STUN_SPORE
	dbw 13, RAZOR_LEAF
	dbw 15, BULLET_SEED
	dbw 16, SWEET_SCENT
	dbw 18, VENOSHOCK
	dbw 23, LEECH_LIFE
	dbw 27, POISON_JAB
	dbw 28, GIGA_DRAIN
	dbw 31, SEED_BOMB
	dbw 35, KNOCK_OFF
	dbw 39, SLAM
	dbw 42, LEAF_BLADE
	dbw 47, POWER_WHIP
	dbw 52, SUCKER_PUNCH
	dbw 55, LEAF_STORM
	db 0 ; no more level-up moves

TentacoolEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, TENTACRUEL
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, SUPERSONIC
	dbw 1, WATER_GUN
	dbw 4, CONSTRICT
	dbw 7, ACID
	dbw 10, TOXIC_SPIKES
	dbw 13, WATER_PULSE
	dbw 16, WRAP
	dbw 18, FLIP_TURN
	dbw 19, MEGA_DRAIN
	dbw 20, VENOSHOCK
	dbw 22, BUBBLEBEAM
	dbw 26, CROSS_POISON
	dbw 28, HEX
	dbw 28, POISON_JAB
	dbw 31, BARRIER
	dbw 32, ACID_ARMOR
	dbw 34, SLUDGE_BOMB
	dbw 37, SCREECH
	dbw 40, GIGA_DRAIN
	dbw 40, SURF
	dbw 42, SCALD
	dbw 43, HYDRO_PUMP
	dbw 44, LIQUIDATION
	dbw 56, GUNK_SHOT
	db 0 ; no more level-up moves

TentacruelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, SUPERSONIC
	dbw 1, WATER_GUN
	dbw 4, CONSTRICT
	dbw 7, ACID
	dbw 10, TOXIC_SPIKES
	dbw 13, WATER_PULSE
	dbw 16, WRAP
	dbw 18, VENOSHOCK
	dbw 19, MEGA_DRAIN
	dbw 22, BUBBLEBEAM
	dbw 28, HEX
	dbw 28, POISON_JAB
	dbw 30, FLIP_TURN
	dbw 32, SCALD
	dbw 34, ACID_ARMOR
	dbw 36, BARRIER
	dbw 36, SLUDGE_BOMB
	dbw 38, KNOCK_OFF
	dbw 40, CROSS_POISON
	dbw 40, SCREECH
	dbw 42, LIQUIDATION
	dbw 44, GIGA_DRAIN
	dbw 46, SURF
	dbw 48, HYDRO_PUMP
	dbw 56, GUNK_SHOT
	db 0 ; no more level-up moves

GeodudeEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, GRAVELER
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, TACKLE
	dbw 4, SANDSTORM
	dbw 7, MAGNITUDE
	dbw 10, ROCK_THROW
	dbw 12, HARDEN
	dbw 13, BULLDOZE
	dbw 16, MUD_SHOT
	dbw 16, ROLLOUT
	dbw 18, ROCK_TOMB
	dbw 22, SELFDESTRUCT
	dbw 25, ROCK_POLISH
	dbw 25, ROCK_SLIDE
	dbw 30, STEALTH_ROCK
	dbw 30, MEGA_PUNCH
	dbw 30, DYNAMICPUNCH
	dbw 31, EARTHQUAKE
	dbw 34, ROCK_BLAST
	dbw 37, EXPLOSION
	dbw 40, DOUBLE_EDGE
	dbw 43, STONE_EDGE
	db 0 ; no more level-up moves

GravelerEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, GOLEM
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, TACKLE
	dbw 4, SANDSTORM
	dbw 7, MAGNITUDE
	dbw 10, ROCK_THROW
	dbw 12, HARDEN
	dbw 13, BULLDOZE
	dbw 16, ROLLOUT
	dbw 18, MUD_SHOT
	dbw 20, ROCK_TOMB
	dbw 22, SELFDESTRUCT
	dbw 25, GYRO_BALL
	dbw 26, ROCK_SLIDE
	dbw 28, ROCK_POLISH
	dbw 34, EARTHQUAKE
	dbw 34, STEALTH_ROCK
	dbw 38, ROCK_BLAST
	dbw 40, BODY_PRESS
	dbw 42, EXPLOSION
	dbw 46, DOUBLE_EDGE
	dbw 50, STONE_EDGE
	db 0 ; no more level-up moves

GolemEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, FIRE_PUNCH
	dbw 1, IRON_HEAD
	dbw 1, TACKLE
	dbw 1, THUNDERPUNCH
	dbw 4, SANDSTORM
	dbw 7, MAGNITUDE
	dbw 10, ROCK_THROW
	dbw 12, HARDEN
	dbw 13, BULLDOZE
	dbw 16, ROLLOUT
	dbw 18, MUD_SHOT
	dbw 20, ROCK_TOMB
	dbw 22, SELFDESTRUCT
	dbw 25, GYRO_BALL
	dbw 26, ROCK_SLIDE
	dbw 32, ROCK_POLISH
	dbw 34, EARTHQUAKE
	dbw 38, ROCK_BLAST
	dbw 38, STEALTH_ROCK
	dbw 40, SUPERPOWER
	dbw 42, EXPLOSION
	dbw 44, BODY_PRESS
	dbw 46, DOUBLE_EDGE
	dbw 50, STONE_EDGE
	dbw 60, HEAVY_SLAM
	db 0 ; no more level-up moves

PonytaEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, RAPIDASH
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, EMBER
	dbw 10, STOMP
	dbw 13, DOUBLE_KICK
	dbw 15, FLAME_CHARGE
	dbw 16, FLAME_WHEEL
	dbw 19, TAKE_DOWN
	dbw 22, FIRE_SPIN
	dbw 24, INCINERATE
	dbw 25, AGILITY
	dbw 28, HYPNOSIS
	dbw 31, LOW_KICK
	dbw 34, FLARE_BLITZ
	dbw 37, DOUBLE_EDGE
	dbw 42, HEAT_WAVE
	dbw 45, BOUNCE
	dbw 46, FIRE_BLAST
	dbw 56, OVERHEAT
	db 0 ; no more level-up moves

RapidashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, MEGAHORN
	dbw 1, POISON_JAB
	dbw 1, QUICK_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, EMBER
	dbw 10, STOMP
	dbw 13, DOUBLE_KICK
	dbw 15, FLAME_CHARGE
	dbw 16, FLAME_WHEEL
	dbw 19, TAKE_DOWN
	dbw 22, FIRE_SPIN
	dbw 24, INCINERATE
	dbw 25, AGILITY
	dbw 28, HYPNOSIS
	dbw 30, SWORDS_DANCE
	dbw 31, LOW_KICK
	dbw 34, FLARE_BLITZ
	dbw 35, FURY_ATTACK
	dbw 36, WILD_CHARGE
	dbw 38, DOUBLE_EDGE
	dbw 45, BOUNCE
	dbw 48, HEAT_WAVE
	dbw 50, FIRE_BLAST
	dbw 55, OVERHEAT
	db 0 ; no more level-up moves

SlowpokeEvosAttacks:
	dbbw EVOLVE_LEVEL, 37, SLOWBRO
	dbbw EVOLVE_ITEM, KINGS_ROCK, SLOWKING
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 1, TELEPORT
	dbw 1, YAWN
	dbw 4, GROWL
	dbw 7, WATER_GUN
	dbw 10, CONFUSION
	dbw 13, DISABLE
	dbw 16, HEADBUTT
	dbw 19, WATER_PULSE
	dbw 22, ZEN_HEADBUTT
	dbw 25, AQUA_TAIL
	dbw 30, SURF
	dbw 31, AMNESIA
	dbw 34, PSYCHIC_M
	dbw 36, SKILL_SWAP
	dbw 37, RAIN_DANCE
	dbw 38, TRICK
	dbw 40, PSYCH_UP
	dbw 42, LIQUIDATION
	dbw 43, FUTURE_SIGHT
	dbw 46, TRICK_ROOM
	dbw 49, SLACK_OFF
	db 0 ; no more level-up moves

SlowbroEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 1, TELEPORT
	dbw 4, GROWL
	dbw 7, WATER_GUN
	dbw 9, YAWN
	dbw 10, CONFUSION
	dbw 13, DISABLE
	dbw 16, HEADBUTT
	dbw 18, PSYBEAM
	dbw 19, WATER_PULSE
	dbw 22, ZEN_HEADBUTT
	dbw 25, AQUA_TAIL
	dbw 26, SIGNAL_BEAM
	dbw 30, SURF
	dbw 30, CALM_MIND
	dbw 31, AMNESIA
	dbw 32, SCALD
	dbw 32, BODY_PRESS
	dbw 33, WITHDRAW
	dbw 34, SKILL_SWAP
	dbw 35, PSYCHIC_M
	dbw 36, TRICK
	dbw 39, RAIN_DANCE
	dbw 42, LIQUIDATION
	dbw 43, PSYCH_UP
	dbw 47, FUTURE_SIGHT
	dbw 50, DREAM_EATER
	dbw 51, TRICK_ROOM
	dbw 55, SLACK_OFF
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

MagnemiteEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, MAGNETON
	db 0 ; no more evolutions
	dbw 1, SUPERSONIC
	dbw 1, TACKLE
	dbw 1, THUNDERSHOCK
	dbw 4, THUNDER_WAVE
	dbw 10, SPARK
	dbw 16, LIGHT_SCREEN
	dbw 17, SONICBOOM
	dbw 22, VOLT_SWITCH
	dbw 26, SIGNAL_BEAM
	dbw 28, DISCHARGE
	dbw 30, EXPLOSION
	dbw 31, FLASH_CANNON
	dbw 34, SCREECH
	dbw 37, THUNDERBOLT
	dbw 40, LOCK_ON
	dbw 49, ZAP_CANNON
	db 0 ; no more level-up moves

MagnetonEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, MAGNEZONE
	db 0 ; no more evolutions
	dbw 1, SUPERSONIC
	dbw 1, TACKLE
	dbw 1, THUNDERSHOCK
	dbw 4, THUNDER_WAVE
	dbw 10, SPARK
	dbw 16, LIGHT_SCREEN
	dbw 17, SONICBOOM
	dbw 22, VOLT_SWITCH
	dbw 28, DISCHARGE
	dbw 30, TRI_ATTACK
	dbw 33, FLASH_CANNON
	dbw 36, IRON_DEFENSE
	dbw 36, SIGNAL_BEAM
	dbw 37, SCREECH
	dbw 41, THUNDERBOLT
	dbw 45, LOCK_ON
	dbw 57, ZAP_CANNON
	db 0 ; no more level-up moves

FarfetchDEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, SIRFETCH_D
	db 0 ; no more evolutions
	dbw 1, FURY_CUTTER
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, SAND_ATTACK
	dbw 7, FURY_ATTACK
	dbw 10, AERIAL_ACE
	dbw 13, KNOCK_OFF
	dbw 15, CUT
	dbw 16, AGILITY
	dbw 16, SWORDS_DANCE
	dbw 22, NIGHT_SLASH
	dbw 22, SLASH
	dbw 28, LEAF_BLADE
	dbw 30, DUALWINGBEAT
	dbw 31, POISON_JAB
	dbw 36, DEFOG
	dbw 37, FALSE_SWIPE
	dbw 37, ACROBATICS
	dbw 42, TAKE_DOWN
	dbw 43, BRAVE_BIRD
	dbw 44, BODY_SLAM
	dbw 46, DOUBLE_EDGE
	dbw 49, CLOSE_COMBAT
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

DoduoEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, DODRIO
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, PECK
	dbw 1, QUICK_ATTACK
	dbw 8, LEER
	dbw 8, RAGE
	dbw 9, FURY_ATTACK
	dbw 15, WING_ATTACK
	dbw 15, PURSUIT
	dbw 21, AGILITY
	dbw 24, TAKE_DOWN
	dbw 30, DRILL_PECK
	dbw 33, JUMP_KICK
	dbw 34, ROOST
	dbw 36, SWORDS_DANCE
	dbw 39, LUNGE
	dbw 42, BODY_SLAM
	dbw 45, THRASH
	dbw 48, BRAVE_BIRD
	dbw 56, DOUBLE_EDGE
	dbw 58, SKULL_BASH
	db 0 ; no more level-up moves

DodrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, PECK
	dbw 1, QUICK_ATTACK
	dbw 1, TRI_ATTACK
	dbw 1, RAGE
	dbw 8, LEER
	dbw 9, FURY_ATTACK
	dbw 15, WING_ATTACK
	dbw 15, PURSUIT
	dbw 21, AGILITY
	dbw 24, TAUNT
	dbw 26, TAKE_DOWN
	dbw 30, DRILL_PECK
	dbw 34, JUMP_KICK
	dbw 36, ROOST
	dbw 40, DRILL_RUN
	dbw 40, SWORDS_DANCE
	dbw 42, BODY_SLAM
	dbw 43, LUNGE
	dbw 50, THRASH
	dbw 54, BRAVE_BIRD
	dbw 54, HI_JUMP_KICK
	dbw 56, DOUBLE_EDGE
	dbw 58, GIGA_IMPACT
	dbw 60, SKULL_BASH
	db 0 ; no more level-up moves

SeelEvosAttacks:
	dbbw EVOLVE_LEVEL, 34, DEWGONG
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, HEADBUTT
	dbw 1, ICICLE_SPEAR
	dbw 7, CHARM
	dbw 7, WATER_GUN
	dbw 9, ICY_WIND
	dbw 11, ENCORE
	dbw 13, AQUA_JET
	dbw 15, ICE_SHARD
	dbw 17, BUBBLEBEAM
	dbw 18, AURORA_BEAM
	dbw 20, FLIP_TURN
	dbw 21, REST
	dbw 25, AQUA_TAIL
	dbw 28, ICE_BEAM
	dbw 31, TAKE_DOWN
	dbw 35, SAFEGUARD
	dbw 41, HAIL
	dbw 43, MEGAHORN
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

DewgongEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, HEADBUTT
	dbw 1, ICICLE_SPEAR
	dbw 1, WATER_GUN
	dbw 1, SIGNAL_BEAM
	dbw 7, BUBBLEBEAM
	dbw 9, ICY_WIND
	dbw 11, ENCORE
	dbw 13, AQUA_JET
	dbw 15, ICE_SHARD
	dbw 18, AURORA_BEAM
	dbw 20, HAZE
	dbw 21, REST
	dbw 22, AVALANCHE
	dbw 25, AQUA_TAIL
	dbw 28, ICE_BEAM
	dbw 30, FLIP_TURN
	dbw 31, TAKE_DOWN
	dbw 35, SAFEGUARD
	dbw 42, LIQUIDATION
	dbw 45, HAIL
	dbw 49, MEGAHORN
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

GrimerEvosAttacks:
	dbbw EVOLVE_LEVEL, 38, MUK
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 4, HARDEN
	dbw 7, MUD_SLAP
	dbw 10, DISABLE
	dbw 13, SLUDGE
	dbw 18, SMOG
	dbw 18, MUD_SHOT
	dbw 19, MINIMIZE
	dbw 22, SHADOW_SNEAK
	dbw 26, TOXIC
	dbw 28, POISON_JAB
	dbw 30, SCARY_FACE
	dbw 34, SCREECH
	dbw 40, ACID_ARMOR
	dbw 43, GUNK_SHOT
	db 0 ; no more level-up moves

MukEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, MOONBLAST
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 4, HARDEN
	dbw 7, MUD_SLAP
	dbw 10, DISABLE
	dbw 13, SLUDGE
	dbw 18, SMOG
	dbw 18, MUD_SHOT
	dbw 19, MINIMIZE
	dbw 22, SHADOW_SNEAK
	dbw 24, TOXIC_SPIKES
	dbw 24, TAUNT
	dbw 26, TOXIC
	dbw 28, POISON_JAB
	dbw 34, SCREECH
	dbw 42, ACID_ARMOR
	dbw 46, GUNK_SHOT
	db 0 ; no more level-up moves

ShellderEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, CLOYSTER
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, WITHDRAW
	dbw 4, WATER_GUN
	dbw 7, SUPERSONIC
	dbw 13, PROTECT
	dbw 15, ICICLE_SPEAR
	dbw 17, LEER
	dbw 19, BUBBLEBEAM
	dbw 22, CLAMP
	dbw 23, ICE_SHARD
	dbw 25, AURORA_BEAM
	dbw 27, WHIRLPOOL
	dbw 30, AVALANCHE
	dbw 33, ICE_BEAM
	dbw 36, IRON_DEFENSE
	dbw 37, HYDRO_PUMP
	dbw 42, LIQUIDATION
	dbw 44, SHELL_SMASH
	db 0 ; no more level-up moves

CloysterEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ICICLE_CRASH
	dbw 1, ICICLE_SPEAR
	dbw 1, SPIKE_CANNON
	dbw 1, TACKLE
	dbw 1, TWINEEDLE
	dbw 1, WITHDRAW
	dbw 1, IRON_DEFENSE
	dbw 4, WATER_GUN
	dbw 7, SUPERSONIC
	dbw 13, PROTECT
	dbw 17, LEER
	dbw 18, BUBBLEBEAM
	dbw 18, TOXIC_SPIKES
	dbw 22, CLAMP
	dbw 23, ICE_SHARD
	dbw 25, AURORA_BEAM
	dbw 27, WHIRLPOOL
	dbw 28, SPIKES
	dbw 33, ICE_BEAM
	dbw 34, LIQUIDATION
	dbw 37, HYDRO_PUMP
	dbw 38, PIN_MISSILE
	dbw 44, SHELL_SMASH
	dbw 48, ROCK_BLAST
	db 0 ; no more level-up moves

GastlyEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, HAUNTER
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 1, MEAN_LOOK
	dbw 1, POISON_GAS
	dbw 1, SPITE
	dbw 4, HYPNOSIS
	dbw 7, NIGHT_SHADE
	dbw 10, SMOG
	dbw 12, HEX
	dbw 13, CONFUSE_RAY
	dbw 18, VENOSHOCK
	dbw 19, CURSE
	dbw 22, SUCKER_PUNCH
	dbw 25, SHADOW_BALL
	dbw 30, NIGHTMARE
	dbw 30, SCARY_FACE
	dbw 31, SLUDGE_BOMB
	dbw 34, DREAM_EATER
	dbw 36, TRICK
	dbw 37, DARK_PULSE
	dbw 40, TRICK_ROOM
	dbw 43, DESTINY_BOND
	db 0 ; no more level-up moves

HaunterEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, GENGAR
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 1, MEAN_LOOK
	dbw 1, POISON_GAS
	dbw 1, SPITE
	dbw 4, HYPNOSIS
	dbw 7, NIGHT_SHADE
	dbw 10, SMOG
	dbw 12, HEX
	dbw 13, CONFUSE_RAY
	dbw 18, VENOSHOCK
	dbw 19, CURSE
	dbw 22, SUCKER_PUNCH
	dbw 26, SHADOW_BALL
	dbw 34, SLUDGE_BOMB
	dbw 36, TOXIC_SPIKES
	dbw 38, DREAM_EATER
	dbw 40, TRICK
	dbw 42, DARK_PULSE
	dbw 44, TRICK_ROOM
	dbw 50, DESTINY_BOND
	dbw 61, NIGHTMARE
	db 0 ; no more level-up moves

GengarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 1, MEAN_LOOK
	dbw 1, PERISH_SONG
	dbw 1, POISON_GAS
	dbw 1, SPITE
	dbw 4, HYPNOSIS
	dbw 7, NIGHT_SHADE
	dbw 10, SMOG
	dbw 12, HEX
	dbw 13, CONFUSE_RAY
	dbw 18, VENOSHOCK
	dbw 19, CURSE
	dbw 22, SUCKER_PUNCH
	dbw 24, TAUNT
	dbw 24, ENCORE
	dbw 26, SHADOW_BALL
	dbw 34, SLUDGE_BOMB
	dbw 36, TOXIC_SPIKES
	dbw 38, DREAM_EATER
	dbw 40, FOCUS_BLAST
	dbw 42, DARK_PULSE
	dbw 44, TRICK
	dbw 48, TRICK_ROOM
	dbw 50, DESTINY_BOND
	dbw 54, AURA_SPHERE
	dbw 61, NIGHTMARE
	db 0 ; no more level-up moves

OnixEvosAttacks:
	dbbw EVOLVE_ITEM, METAL_COAT, STEELIX
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, HARDEN
	dbw 1, TACKLE
	dbw 4, CURSE
	dbw 7, ROCK_THROW
	dbw 10, BULLDOZE
	dbw 13, RAGE
	dbw 18, ROCK_TOMB
	dbw 19, DRAGONBREATH
	dbw 20, GYRO_BALL
	dbw 22, DIG
	dbw 25, ROCK_SLIDE
	dbw 28, ROCK_POLISH
	dbw 28, SLAM
	dbw 31, SCREECH
	dbw 32, STEALTH_ROCK
	dbw 36, DRILL_RUN
	dbw 37, STONE_EDGE
	dbw 38, DRAGON_TAIL
	dbw 40, BODY_PRESS
	dbw 40, DOUBLE_EDGE
	dbw 43, SANDSTORM
	dbw 48, IRON_TAIL
	db 0 ; no more level-up moves

DrowzeeEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, HYPNO
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, POUND
	dbw 6, DISABLE
	dbw 9, CONFUSION
	dbw 12, HEADBUTT
	dbw 15, POISON_GAS
	dbw 18, PSYBEAM
	dbw 21, MEDITATE
	dbw 26, SIGNAL_BEAM
	dbw 29, MIND_READER
	dbw 30, PSYCH_UP
	dbw 30, SKILL_SWAP
	dbw 32, CALM_MIND
	dbw 33, SWAGGER
	dbw 33, ZEN_HEADBUTT
	dbw 34, TRICK
	dbw 36, PSYCHIC_M
	dbw 38, TRICK_ROOM
	dbw 39, DYNAMICPUNCH
	dbw 41, NASTY_PLOT
	dbw 42, DRAIN_PUNCH
	dbw 50, DREAM_EATER
	dbw 51, FUTURE_SIGHT
	dbw 57, PSYSHOCK
	db 0 ; no more level-up moves

HypnoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DREAM_EATER
	dbw 1, HYPNOSIS
	dbw 1, POUND
	dbw 1, SWAGGER
	dbw 1, NIGHTMARE
	dbw 6, DISABLE
	dbw 9, CONFUSION
	dbw 12, HEADBUTT
	dbw 15, POISON_GAS
	dbw 18, PSYBEAM
	dbw 20, THUNDER_WAVE
	dbw 20, REFLECT
	dbw 21, MEDITATE
	dbw 24, ENCORE
	dbw 26, SIGNAL_BEAM
	dbw 29, MIND_READER
	dbw 30, PSYCH_UP
	dbw 32, CALM_MIND
	dbw 33, ZEN_HEADBUTT
	dbw 34, TRICK
	dbw 36, PSYCHIC_M
	dbw 38, TRICK_ROOM
	dbw 39, DYNAMICPUNCH
	dbw 41, NASTY_PLOT
	dbw 42, DRAIN_PUNCH
	dbw 51, FUTURE_SIGHT
	dbw 54, ZAP_CANNON
	dbw 57, PSYSHOCK
	db 0 ; no more level-up moves

KrabbyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, KINGLER
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, HARDEN
	dbw 1, WATER_GUN
	dbw 5, VICEGRIP
	dbw 8, LEER
	dbw 12, MUD_SHOT
	dbw 14, BUBBLEBEAM
	dbw 17, METAL_CLAW
	dbw 20, STOMP
	dbw 26, PROTECT
	dbw 28, CRABHAMMER
	dbw 29, KNOCK_OFF
	dbw 30, HAMMER_ARM
	dbw 32, GUILLOTINE
	dbw 35, SLAM
	dbw 38, X_SCISSOR
	dbw 40, SWORDS_DANCE
	dbw 41, AGILITY
	dbw 42, LIQUIDATION
	dbw 44, FLAIL
	db 0 ; no more level-up moves

KinglerEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, HARDEN
	dbw 1, WATER_GUN
	dbw 1, HAMMER_ARM
	dbw 5, VICEGRIP
	dbw 8, LEER
	dbw 12, MUD_SHOT
	dbw 14, BUBBLEBEAM
	dbw 17, METAL_CLAW
	dbw 20, STOMP
	dbw 26, PROTECT
	dbw 28, CRABHAMMER
	dbw 30, KNOCK_OFF
	dbw 34, GUILLOTINE
	dbw 34, ROCK_SLIDE
	dbw 38, SLAM
	dbw 42, X_SCISSOR
	dbw 46, AGILITY
	dbw 48, SWORDS_DANCE
	dbw 50, FLAIL
	dbw 54, LIQUIDATION
	db 0 ; no more level-up moves

VoltorbEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, ELECTRODE
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, TACKLE
	dbw 9, THUNDERSHOCK
	dbw 12, ROLLOUT
	dbw 15, SPARK
	dbw 15, SONICBOOM
	dbw 21, SWIFT
	dbw 24, SELFDESTRUCT
	dbw 26, SIGNAL_BEAM
	dbw 27, VOLT_SWITCH
	dbw 27, DISCHARGE
	dbw 30, LIGHT_SCREEN
	dbw 30, AGILITY
	dbw 30, RECYCLE
	dbw 36, THUNDERBOLT
	dbw 39, EXPLOSION
	dbw 45, MIRROR_COAT
	dbw 48, THUNDER
	db 0 ; no more level-up moves

ElectrodeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, TACKLE
	dbw 1, SONICBOOM
	dbw 9, THUNDERSHOCK
	dbw 12, ROLLOUT
	dbw 15, SPARK
	dbw 21, SWIFT
	dbw 24, SELFDESTRUCT
	dbw 24, TAUNT
	dbw 27, VOLT_SWITCH
	dbw 27, DISCHARGE
	dbw 28, FOUL_PLAY
	dbw 31, LIGHT_SCREEN
	dbw 36, SIGNAL_BEAM
	dbw 39, THUNDERBOLT
	dbw 43, EXPLOSION
	dbw 51, MIRROR_COAT
	dbw 55, THUNDER
	db 0 ; no more level-up moves

ExeggcuteEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, EXEGGUTOR
	dbbw EVOLVE_ITEM, SUN_STONE, EXEGGUTOR_ALOLAN
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, BARRAGE
	dbw 1, HYPNOSIS
	dbw 7, REFLECT
	dbw 13, CONFUSION
	dbw 14, BULLET_SEED
	dbw 15, MEGA_DRAIN
	dbw 17, LEECH_SEED
	dbw 18, PSYBEAM
	dbw 19, POISONPOWDER
	dbw 19, SLEEP_POWDER
	dbw 19, STUN_SPORE
	dbw 23, EXTRASENSORY
	dbw 25, ENERGY_BALL
	dbw 25, SYNTHESIS
	dbw 29, ANCIENTPOWER
	dbw 30, SKILL_SWAP
	dbw 33, PSYCHIC_M
	dbw 34, TRICK
	dbw 35, GIGA_DRAIN
	dbw 36, TRICK_ROOM
	dbw 37, SOLARBEAM
	dbw 50, DREAM_EATER
	db 0 ; no more level-up moves

ExeggutorEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, BARRAGE
	dbw 1, HYPNOSIS
	dbw 1, SEED_BOMB
	dbw 1, GROWTH
	dbw 1, BULLET_SEED
	dbw 1, PSYSHOCK
	dbw 7, REFLECT
	dbw 12, CONFUSION
	dbw 15, MEGA_DRAIN
	dbw 17, LEECH_SEED
	dbw 17, STOMP
	dbw 18, PSYBEAM
	dbw 19, POISONPOWDER
	dbw 19, SLEEP_POWDER
	dbw 19, STUN_SPORE
	dbw 23, EXTRASENSORY
	dbw 25, ENERGY_BALL
	dbw 25, SYNTHESIS
	dbw 26, PSYCHO_CUT
	dbw 27, EGG_BOMB
	dbw 29, ANCIENTPOWER
	dbw 30, CALM_MIND
	dbw 33, PSYCHIC_M
	dbw 34, TRICK
	dbw 35, GIGA_DRAIN
	dbw 36, TRICK_ROOM
	dbw 37, SOLARBEAM
	dbw 44, LEAF_STORM
	dbw 50, WOOD_HAMMER
	dbw 52, DREAM_EATER
	dbw 56, POWER_WHIP
	dbw 58, FUTURE_SIGHT
	db 0 ; no more level-up moves

CuboneEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MAROWAK_ALOLAN ; only inside the Burned Tower (see engine/pokemon/evolve.asm)
	dbbw EVOLVE_LEVEL, 28, MAROWAK
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, MUD_SLAP
	dbw 1, SING
	dbw 1, TAIL_WHIP
	dbw 4, HEADBUTT
	dbw 7, BONE_CLUB
	dbw 10, LEER
	dbw 13, FOCUS_ENERGY
	dbw 18, BULLDOZE
	dbw 19, BONEMERANG
	dbw 22, FALSE_SWIPE
	dbw 23, RAGE
	dbw 25, KNOCK_OFF
	dbw 28, BONE_RUSH
	dbw 30, DETECT
	dbw 31, THRASH
	dbw 36, STEALTH_ROCK
	dbw 40, IRON_HEAD
	dbw 43, BELLY_DRUM
	dbw 46, DOUBLE_EDGE
	dbw 49, EARTHQUAKE
	db 0 ; no more level-up moves

MarowakEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, MUD_SLAP
	dbw 1, SING
	dbw 1, TAIL_WHIP
	dbw 4, HEADBUTT
	dbw 7, BONE_CLUB
	dbw 10, LEER
	dbw 13, FOCUS_ENERGY
	dbw 19, BONEMERANG
	dbw 20, BULLDOZE
	dbw 22, FALSE_SWIPE
	dbw 23, RAGE
	dbw 24, STEALTH_ROCK
	dbw 25, KNOCK_OFF
	dbw 29, BONE_RUSH
	dbw 33, THRASH
	dbw 40, STONE_EDGE
	dbw 45, IRON_HEAD
	dbw 49, BELLY_DRUM
	dbw 53, DOUBLE_EDGE
	dbw 57, EARTHQUAKE
	db 0 ; no more level-up moves

HitmonleeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LOW_KICK
	dbw 1, ROLLING_KICK
	dbw 1, TACKLE
	dbw 1, MACH_PUNCH
	dbw 1, FAKE_OUT
	dbw 5, MEDITATE
	dbw 16, SUCKER_PUNCH
	dbw 20, DOUBLE_KICK
	dbw 20, LOW_SWEEP
	dbw 29, JUMP_KICK
	dbw 30, BRICK_BREAK
	dbw 33, ENDURE
	dbw 35, CLOSE_COMBAT
	dbw 37, FORESIGHT
	dbw 39, MEGA_KICK
	dbw 40, STONE_EDGE
	dbw 41, HI_JUMP_KICK
	dbw 41, MIND_READER
	dbw 42, SUBMISSION
	dbw 43, BLAZE_KICK
	dbw 45, REVERSAL
	dbw 46, SUPERPOWER
	dbw 47, DOUBLE_EDGE
	db 0 ; no more level-up moves

HitmonchanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 1, DRAIN_PUNCH
	dbw 1, FOCUS_ENERGY
	dbw 1, MACH_PUNCH
	dbw 1, TACKLE
	dbw 1, FAKE_OUT
	dbw 1, PURSUIT
	dbw 18, LOW_KICK
	dbw 20, LOW_SWEEP
	dbw 21, AGILITY
	dbw 25, DIZZY_PUNCH
	dbw 27, BULLET_PUNCH
	dbw 29, FIRE_PUNCH
	dbw 29, ICE_PUNCH
	dbw 29, THUNDERPUNCH
	dbw 30, BRICK_BREAK
	dbw 33, DETECT
	dbw 35, CLOSE_COMBAT
	dbw 37, COUNTER
	dbw 39, MEGA_PUNCH
	dbw 40, STONE_EDGE
	dbw 41, VACUUM_WAVE
	dbw 41, SKY_UPPERCUT
	dbw 42, SUBMISSION
	dbw 47, REVERSAL
	db 0 ; no more level-up moves

LickitungEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, LICKILICKY
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 4, SUPERSONIC
	dbw 7, DEFENSE_CURL
	dbw 10, WRAP
	dbw 12, STOMP
	dbw 13, DISABLE
	dbw 19, KNOCK_OFF
	dbw 22, AMNESIA
	dbw 25, SLAM
	dbw 33, ROLLOUT
	dbw 34, ZEN_HEADBUTT
	dbw 37, BODY_SLAM
	dbw 42, TAKE_DOWN
	dbw 43, THRASH
	dbw 46, SCREECH
	dbw 52, POWER_WHIP
	dbw 56, GIGA_IMPACT
	dbw 58, DOUBLE_EDGE
	dbw 60, BELLY_DRUM
	dbw 62, SKULL_BASH
	db 0 ; no more level-up moves

KoffingEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, WEEZING_GALARIAN ; only when it knows Fairy Wind (see engine/pokemon/evolve.asm)
	dbbw EVOLVE_LEVEL, 35, WEEZING
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, TACKLE
	dbw 4, SMOG
	dbw 7, SMOKESCREEN
	dbw 12, SLUDGE
	dbw 13, PAIN_SPLIT
	dbw 18, VENOSHOCK
	dbw 19, SELFDESTRUCT
	dbw 22, HAZE
	dbw 25, GYRO_BALL
	dbw 28, SLUDGE_BOMB
	dbw 31, LAVA_PLUME
	dbw 34, DESTINY_BOND
	dbw 36, TOXIC
	dbw 37, DARK_PULSE
	dbw 40, GUNK_SHOT
	dbw 43, EXPLOSION
	db 0 ; no more level-up moves

WeezingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, TACKLE
	dbw 1, HEAT_WAVE
	dbw 4, SMOG
	dbw 7, SMOKESCREEN
	dbw 12, SLUDGE
	dbw 13, PAIN_SPLIT
	dbw 18, VENOSHOCK
	dbw 19, SELFDESTRUCT
	dbw 22, HAZE
	dbw 24, TAUNT
	dbw 25, GYRO_BALL
	dbw 28, SLUDGE_BOMB
	dbw 31, LAVA_PLUME
	dbw 34, DESTINY_BOND
	dbw 38, DARK_PULSE
	dbw 38, TOXIC
	dbw 42, GUNK_SHOT
	dbw 46, EXPLOSION
	db 0 ; no more level-up moves

RhyhornEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, RHYDON
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 4, FURY_ATTACK
	dbw 7, SCARY_FACE
	dbw 10, BULLDOZE
	dbw 13, STOMP
	dbw 16, ROCK_BLAST
	dbw 18, MUD_SHOT
	dbw 20, ROCK_TOMB
	dbw 22, TAKE_DOWN
	dbw 28, CRUNCH
	dbw 30, ROCK_POLISH
	dbw 31, ROCK_SLIDE
	dbw 32, STEALTH_ROCK
	dbw 34, DOUBLE_EDGE
	dbw 35, DRILL_RUN
	dbw 37, MEGAHORN
	dbw 38, BODY_PRESS
	dbw 40, EARTHQUAKE
	dbw 42, AQUA_TAIL
	dbw 50, STONE_EDGE
	dbw 60, HORN_DRILL
	db 0 ; no more level-up moves

RhydonEvosAttacks:
	dbbw EVOLVE_LEVEL, 45, RHYPERIOR
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, THUNDER_FANG
	dbw 1, HAMMER_ARM
	dbw 4, FURY_ATTACK
	dbw 7, SCARY_FACE
	dbw 10, BULLDOZE
	dbw 13, STOMP
	dbw 16, ROCK_BLAST
	dbw 18, DRAGON_TAIL
	dbw 20, MUD_SHOT
	dbw 22, ROCK_TOMB
	dbw 22, TAKE_DOWN
	dbw 26, BRICK_BREAK
	dbw 28, CRUNCH
	dbw 30, SWORDS_DANCE
	dbw 31, ROCK_SLIDE
	dbw 32, BODY_PRESS
	dbw 34, DOUBLE_EDGE
	dbw 34, ROCK_POLISH
	dbw 36, STEALTH_ROCK
	dbw 38, MEGAHORN
	dbw 40, IRON_DEFENSE
	dbw 42, EARTHQUAKE
	dbw 44, DRILL_RUN
	dbw 46, AQUA_TAIL
	dbw 54, STONE_EDGE
	dbw 68, HORN_DRILL
	db 0 ; no more level-up moves

ChanseyEvosAttacks:
	dbbw EVOLVE_HAPPINESS, TR_ANYTIME, BLISSEY
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DEFENSE_CURL
	dbw 1, DISARMING_VOICE
	dbw 1, GROWL
	dbw 1, POUND
	dbw 1, SWEET_KISS
	dbw 4, TAIL_WHIP
	dbw 12, DOUBLESLAP
	dbw 13, SOFTBOILED
	dbw 19, MINIMIZE
	dbw 20, THUNDER_WAVE
	dbw 22, HYPER_VOICE
	dbw 24, STEALTH_ROCK
	dbw 25, SING
	dbw 31, SEISMIC_TOSS
	dbw 37, LIGHT_SCREEN
	dbw 42, TRI_ATTACK
	dbw 43, COUNTER
	db 0 ; no more level-up moves

TangelaEvosAttacks:
	dbbw EVOLVE_LEVEL, 45, TANGROWTH
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, CONSTRICT
	dbw 7, VINE_WHIP
	dbw 8, GROWTH
	dbw 10, BIND
	dbw 13, POISONPOWDER
	dbw 13, SLEEP_POWDER
	dbw 13, STUN_SPORE
	dbw 14, BULLET_SEED
	dbw 16, MEGA_DRAIN
	dbw 20, GIGA_DRAIN
	dbw 22, KNOCK_OFF
	dbw 34, ANCIENTPOWER
	db 0 ; no more level-up moves

KangaskhanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 1, LEER
	dbw 1, POUND
	dbw 4, GROWL
	dbw 7, TAIL_WHIP
	dbw 8, FAKE_OUT
	dbw 10, BITE
	dbw 16, STOMP
	dbw 18, LOW_KICK
	dbw 19, FOCUS_ENERGY
	dbw 22, MEGA_PUNCH
	dbw 22, RAGE
	dbw 24, HEADBUTT
	dbw 28, CRUNCH
	dbw 28, WORK_UP
	dbw 30, CIRCLE_THROW
	dbw 31, BODY_SLAM
	dbw 32, CRUSH_CLAW
	dbw 34, BRICK_BREAK
	dbw 34, DIZZY_PUNCH
	dbw 34, ENDURE
	dbw 34, ROCK_SLIDE
	dbw 37, OUTRAGE
	dbw 42, TAKE_DOWN
	dbw 43, SUCKER_PUNCH
	dbw 44, AQUA_TAIL
	dbw 46, DOUBLE_EDGE
	dbw 49, REVERSAL
	dbw 56, GIGA_IMPACT
	dbw 58, SKULL_BASH
	db 0 ; no more level-up moves

HorseaEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, SEADRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, LEER
	dbw 1, SMOKESCREEN
	dbw 7, WATER_GUN
	dbw 10, FOCUS_ENERGY
	dbw 10, TWISTER
	dbw 13, DRAGONBREATH
	dbw 16, AURORA_BEAM
	dbw 19, BUBBLEBEAM
	dbw 25, OCTAZOOKA
	dbw 28, AGILITY
	dbw 34, DRAGON_PULSE
	dbw 34, SCALE_SHOT
	dbw 35, WATER_PULSE
	dbw 40, DRAGON_DANCE
	dbw 42, SCALD
	dbw 43, OUTRAGE
	dbw 46, HYDRO_PUMP
	dbw 55, RAIN_DANCE
	db 0 ; no more level-up moves

SeadraEvosAttacks:
	dbbw EVOLVE_ITEM, DRAGON_SCALE, KINGDRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, LEER
	dbw 1, SMOKESCREEN
	dbw 1, TWISTER
	dbw 7, WATER_GUN
	dbw 10, FOCUS_ENERGY
	dbw 13, DRAGONBREATH
	dbw 16, AURORA_BEAM
	dbw 19, BUBBLEBEAM
	dbw 25, OCTAZOOKA
	dbw 28, AGILITY
	dbw 35, DRAGON_PULSE
	dbw 37, WATER_PULSE
	dbw 38, SCALE_SHOT
	dbw 42, SCALD
	dbw 51, HYDRO_PUMP
	dbw 65, RAIN_DANCE
	db 0 ; no more level-up moves

SECTION "Evolutions and Attacks 1C", ROMX

EvosAttacksPointers1C::
	dw GoldeenEvosAttacks
	dw SeakingEvosAttacks
	dw StaryuEvosAttacks
	dw StarmieEvosAttacks

GoldeenEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, SEAKING
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, QUICK_ATTACK
	dbw 1, TAIL_WHIP
	dbw 4, SUPERSONIC
	dbw 7, HORN_ATTACK
	dbw 10, FLAIL
	dbw 13, WATER_PULSE
	dbw 18, FLIP_TURN
	dbw 19, FURY_ATTACK
	dbw 22, WATERFALL
	dbw 25, AGILITY
	dbw 28, BODY_SLAM
	dbw 30, MUD_SHOT
	dbw 30, SKULL_BASH
	dbw 31, AQUA_TAIL
	dbw 34, KNOCK_OFF
	dbw 42, SCALD
	dbw 43, HYDRO_PUMP
	dbw 43, MEGAHORN
	dbw 50, HORN_DRILL
	db 0 ; no more level-up moves

SeakingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, QUICK_ATTACK
	dbw 1, TAIL_WHIP
	dbw 1, POISON_JAB
	dbw 4, SUPERSONIC
	dbw 7, HORN_ATTACK
	dbw 10, FLAIL
	dbw 13, WATER_PULSE
	dbw 19, FURY_ATTACK
	dbw 22, WATERFALL
	dbw 25, AGILITY
	dbw 28, BODY_SLAM
	dbw 30, FLIP_TURN
	dbw 31, AQUA_TAIL
	dbw 32, SCALD
	dbw 35, KNOCK_OFF
	dbw 43, HYDRO_PUMP
	dbw 47, MEGAHORN
	dbw 58, HORN_DRILL
	db 0 ; no more level-up moves

StaryuEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, STARMIE
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, TACKLE
	dbw 1, WATER_GUN
	dbw 4, RAPID_SPIN
	dbw 11, RECOVER
	dbw 13, SWIFT
	dbw 13, PSYWAVE
	dbw 15, WATER_PULSE
	dbw 21, BUBBLEBEAM
	dbw 23, GYRO_BALL
	dbw 24, PSYBEAM
	dbw 25, MINIMIZE
	dbw 27, POWER_GEM
	dbw 33, CONFUSE_RAY
	dbw 35, LIGHT_SCREEN
	dbw 37, COSMIC_POWER
	dbw 40, PSYCHIC_M
	dbw 41, HYDRO_PUMP
	dbw 42, SCALD
	dbw 44, SURF
	db 0 ; no more level-up moves

StarmieEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, TACKLE
	dbw 4, RAPID_SPIN
	dbw 4, WATER_GUN
	dbw 11, RECOVER
	dbw 13, SWIFT
	dbw 15, WATER_PULSE
	dbw 21, BUBBLEBEAM
	dbw 23, GYRO_BALL
	dbw 24, PSYBEAM
	dbw 25, MINIMIZE
	dbw 26, SIGNAL_BEAM
	dbw 27, POWER_GEM
	dbw 28, PSYCHO_CUT
	dbw 30, FLIP_TURN
	dbw 31, PSYCHIC_M
	dbw 32, SCALD
	dbw 33, CONFUSE_RAY
	dbw 34, SKILL_SWAP
	dbw 35, LIGHT_SCREEN
	dbw 36, TRICK
	dbw 38, TRICK_ROOM
	dbw 41, HYDRO_PUMP
	dbw 44, SURF
	dbw 50, DREAM_EATER
	dbw 64, COSMIC_POWER
	db 0 ; no more level-up moves

SECTION "Evolutions and Attacks 1B", ROMX

EvosAttacksPointers1B::
	dw MrMimeEvosAttacks
	dw ScytherEvosAttacks
	dw JynxEvosAttacks
	dw ElectabuzzEvosAttacks
	dw MagmarEvosAttacks
	dw PinsirEvosAttacks
	dw TaurosEvosAttacks
	dw MagikarpEvosAttacks
	dw GyaradosEvosAttacks
	dw LaprasEvosAttacks
	dw DittoEvosAttacks
	dw EeveeEvosAttacks
	dw VaporeonEvosAttacks
	dw JolteonEvosAttacks
	dw FlareonEvosAttacks
	dw PorygonEvosAttacks
	dw OmanyteEvosAttacks
	dw OmastarEvosAttacks
	dw KabutoEvosAttacks
	dw KabutopsEvosAttacks
	dw AerodactylEvosAttacks
	dw SnorlaxEvosAttacks
	dw ArticunoEvosAttacks
	dw ZapdosEvosAttacks
	dw MoltresEvosAttacks
	dw DratiniEvosAttacks
	dw DragonairEvosAttacks
	dw DragoniteEvosAttacks
	dw MewtwoEvosAttacks
	dw MewEvosAttacks

MrMimeEvosAttacks:
	dbbw EVOLVE_LEVEL, 42, MR__RIME
	db 0 ; no more evolutions
	dbw 1, BARRIER
	dbw 1, CONFUSION
	dbw 1, POUND
	dbw 1, MAGICAL_LEAF
	dbw 8, MEDITATE
	dbw 9, DOUBLESLAP
	dbw 15, ENCORE
	dbw 15, PSYWAVE
	dbw 18, MIMIC
	dbw 20, PROTECT
	dbw 21, PSYBEAM
	dbw 24, LIGHT_SCREEN
	dbw 24, REFLECT
	dbw 24, RECYCLE
	dbw 26, SIGNAL_BEAM
	dbw 27, DAZZLING_GLEAM
	dbw 30, SUBSTITUTE
	dbw 33, PSYCHIC_M
	dbw 34, TRICK_ROOM
	dbw 36, TRICK
	dbw 39, CALM_MIND
	dbw 40, SUCKER_PUNCH
	dbw 45, BATON_PASS
	dbw 48, SAFEGUARD
	dbw 50, DREAM_EATER
	db 0 ; no more level-up moves

ScytherEvosAttacks:
	dbbw EVOLVE_ITEM, METAL_COAT, SCIZOR
	dbbw EVOLVE_ITEM, HARD_STONE, KLEAVOR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, QUICK_ATTACK
	dbw 1, VACUUM_WAVE
	dbw 4, FOCUS_ENERGY
	dbw 9, PURSUIT
	dbw 10, FALSE_SWIPE
	dbw 13, FURY_CUTTER
	dbw 16, AGILITY
	dbw 19, WING_ATTACK
	dbw 22, NIGHT_SLASH
	dbw 22, SLASH
	dbw 30, X_SCISSOR
	dbw 30, U_TURN
	dbw 31, DOUBLE_TEAM
	dbw 32, DUALWINGBEAT
	dbw 36, ROOST
	dbw 43, SWORDS_DANCE
	dbw 46, BATON_PASS
	dbw 49, REVERSAL
	db 0 ; no more level-up moves

JynxEvosAttacks:
	dbbw EVOLVE_LEVEL, 45, MESMERIA
	db 0 ; no more evolutions
	dbw 1, DRAINING_KISS
	dbw 1, LICK
	dbw 1, LOVELY_KISS
	dbw 1, POUND
	dbw 1, POWDER_SNOW
	dbw 1, SWEET_KISS
	dbw 12, CONFUSION
	dbw 15, DOUBLESLAP
	dbw 15, ICY_WIND
	dbw 18, MEAN_LOOK
	dbw 20, SING
	dbw 21, EXTRASENSORY
	dbw 24, ENCORE
	dbw 26, SIGNAL_BEAM
	dbw 31, ICE_BEAM
	dbw 34, PSYCHIC_M
	dbw 36, SKILL_SWAP
	dbw 38, FREEZE_DRY
	dbw 40, FOCUS_BLAST
	dbw 42, TRICK
	dbw 44, TRICK_ROOM
	dbw 47, PERISH_SONG
	dbw 50, DREAM_EATER
	dbw 51, BLIZZARD
	dbw 55, CALM_MIND
	dbw 56, FUTURE_SIGHT
	dbw 59, PSYSHOCK
	db 0 ; no more level-up moves

ElectabuzzEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, ELECTIVIRE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, MACH_PUNCH
	dbw 1, QUICK_ATTACK
	dbw 1, THUNDERSHOCK
	dbw 7, LOW_KICK
	dbw 10, SWIFT
	dbw 16, THUNDER_WAVE
	dbw 19, THUNDERPUNCH
	dbw 22, LIGHT_SCREEN
	dbw 26, SIGNAL_BEAM
	dbw 28, DISCHARGE
	dbw 30, VOLT_SWITCH
	dbw 33, SCREECH
	dbw 37, CROSS_CHOP
	dbw 40, FOCUS_BLAST
	dbw 41, THUNDERBOLT
	dbw 45, WILD_CHARGE
	dbw 49, CLOSE_COMBAT
	dbw 53, THUNDER
	dbw 64, GIGA_IMPACT
	db 0 ; no more level-up moves

MagmarEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, MAGMORTAR
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, LEER
	dbw 1, SMOG
	dbw 7, SMOKESCREEN
	dbw 12, FAINT_ATTACK
	dbw 13, FIRE_SPIN
	dbw 16, FLAME_WHEEL
	dbw 16, WILL_O_WISP
	dbw 19, FIRE_PUNCH
	dbw 22, CONFUSE_RAY
	dbw 24, SCARY_FACE
	dbw 28, INCINERATE
	dbw 28, LAVA_PLUME
	dbw 33, FLAMETHROWER
	dbw 33, SUNNY_DAY
	dbw 37, CROSS_CHOP
	dbw 40, LOW_KICK
	dbw 42, HEAT_CRASH
	dbw 44, BELLY_DRUM
	dbw 45, FLARE_BLITZ
	dbw 48, HEAT_WAVE
	dbw 49, AURA_SPHERE
	dbw 53, FIRE_BLAST
	dbw 56, OVERHEAT
	dbw 64, HYPER_BEAM
	db 0 ; no more level-up moves

PinsirEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, FOCUS_ENERGY
	dbw 1, VICEGRIP
	dbw 4, HARDEN
	dbw 7, SEISMIC_TOSS
	dbw 10, QUICK_ATTACK
	dbw 13, BUG_BITE
	dbw 19, VITAL_THROW
	dbw 26, BRICK_BREAK
	dbw 28, X_SCISSOR
	dbw 31, KNOCK_OFF
	dbw 34, SWORDS_DANCE
	dbw 36, STRENGTH
	dbw 37, CLOSE_COMBAT
	dbw 40, THRASH
	dbw 40, STONE_EDGE
	dbw 43, MEGAHORN
	dbw 44, SUBMISSION
	dbw 49, GUILLOTINE
	dbw 52, SUPERPOWER
	dbw 56, OUTRAGE
	db 0 ; no more level-up moves

TaurosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 4, SCARY_FACE
	dbw 5, RAGE
	dbw 7, HORN_ATTACK
	dbw 13, STOMP
	dbw 15, PURSUIT
	dbw 16, REST
	dbw 19, BULLDOZE
	dbw 25, TAKE_DOWN
	dbw 28, WORK_UP
	dbw 28, ZEN_HEADBUTT
	dbw 30, REVERSAL
	dbw 30, ENDURE
	dbw 30, ROCK_SLIDE
	dbw 31, BODY_SLAM
	dbw 34, SWAGGER
	dbw 36, WILD_CHARGE
	dbw 37, THRASH
	dbw 40, IRON_HEAD
	dbw 40, CLOSE_COMBAT
	dbw 43, DOUBLE_EDGE
	dbw 44, RAGING_BULL
	dbw 46, MEGAHORN
	dbw 49, OUTRAGE
	dbw 52, GIGA_IMPACT
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

MagikarpEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, GYARADOS
	db 0 ; no more evolutions
	dbw 1, FLAIL
	dbw 1, SPLASH
	dbw 1, TACKLE
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

GyaradosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, FLAIL
	dbw 1, LEER
	dbw 1, SPLASH
	dbw 1, TACKLE
	dbw 1, THRASH
	dbw 1, TWISTER
	dbw 4, WHIRLPOOL
	dbw 20, BITE
	dbw 21, WATERFALL
	dbw 24, TAUNT
	dbw 26, ICE_FANG
	dbw 29, AQUA_TAIL
	dbw 30, BOUNCE
	dbw 32, SCARY_FACE
	dbw 35, CRUNCH
	dbw 36, DRAGON_RAGE
	dbw 38, DRAGON_DANCE
	dbw 41, OUTRAGE
	dbw 42, SCALE_SHOT
	dbw 44, DRAGON_TAIL
	dbw 47, RAIN_DANCE
	db 0 ; no more level-up moves

LaprasEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SING
	dbw 1, WATER_GUN
	dbw 4, MIST
	dbw 7, CONFUSE_RAY
	dbw 10, ICE_SHARD
	dbw 13, WATER_PULSE
	dbw 16, BODY_SLAM
	dbw 19, RAIN_DANCE
	dbw 22, PERISH_SONG
	dbw 24, HEAL_BELL
	dbw 25, ICE_BEAM
	dbw 28, BUBBLEBEAM
	dbw 31, AVALANCHE
	dbw 32, BODY_PRESS
	dbw 34, DRAGON_PULSE
	dbw 40, FREEZE_DRY
	dbw 40, FUTURE_SIGHT
	dbw 42, AQUA_TAIL
	dbw 43, SAFEGUARD
	dbw 46, LIQUIDATION
	dbw 49, MEGAHORN
	dbw 52, HYDRO_PUMP
	db 0 ; no more level-up moves

DittoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TRANSFORM
	db 0 ; no more level-up moves

EeveeEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, JOLTEON
	dbbw EVOLVE_ITEM, WATER_STONE, VAPOREON
	dbbw EVOLVE_ITEM, FIRE_STONE, FLAREON
	dbbw EVOLVE_HAPPINESS, TR_MORNDAY, ESPEON
	dbbw EVOLVE_HAPPINESS, TR_NITE, UMBREON
	dbbw EVOLVE_ITEM, SUN_STONE, SYLVEON
	dbbw EVOLVE_ITEM, LEAF_STONE, LEAFEON
	dbbw EVOLVE_ITEM, ICE_STONE, GLACEON
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, SAND_ATTACK
	dbw 10, QUICK_ATTACK
	dbw 13, BATON_PASS
	dbw 16, SWIFT
	dbw 25, TAKE_DOWN
	dbw 31, CHARM
	dbw 34, DOUBLE_EDGE
	dbw 42, HYPER_VOICE
	dbw 44, BODY_SLAM
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

VaporeonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BATON_PASS
	dbw 1, BITE
	dbw 1, CHARM
	dbw 1, DOUBLE_EDGE
	dbw 1, GROWL
	dbw 1, SWIFT
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, TAKE_DOWN
	dbw 1, WATER_GUN
	dbw 7, SAND_ATTACK
	dbw 10, QUICK_ATTACK
	dbw 13, HAZE
	dbw 16, WATER_PULSE
	dbw 19, AURORA_BEAM
	dbw 25, SCALD
	dbw 28, EXTRASENSORY
	dbw 30, FLIP_TURN
	dbw 30, CALM_MIND
	dbw 31, ACID_ARMOR
	dbw 37, ICE_BEAM
	dbw 43, HYDRO_PUMP
	db 0 ; no more level-up moves

JolteonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BATON_PASS
	dbw 1, BITE
	dbw 1, CHARM
	dbw 1, DOUBLE_EDGE
	dbw 1, GROWL
	dbw 1, SWIFT
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, TAKE_DOWN
	dbw 1, THUNDERSHOCK
	dbw 7, SAND_ATTACK
	dbw 10, QUICK_ATTACK
	dbw 13, THUNDER_WAVE
	dbw 19, DOUBLE_KICK
	dbw 20, LIGHT_SCREEN
	dbw 25, VOLT_SWITCH
	dbw 25, DISCHARGE
	dbw 26, SIGNAL_BEAM
	dbw 28, EXTRASENSORY
	dbw 30, CALM_MIND
	dbw 31, AGILITY
	dbw 34, THUNDERBOLT
	dbw 43, THUNDER
	db 0 ; no more level-up moves

FlareonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BATON_PASS
	dbw 1, BITE
	dbw 1, CHARM
	dbw 1, DOUBLE_EDGE
	dbw 1, EMBER
	dbw 1, GROWL
	dbw 1, SWIFT
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, TAKE_DOWN
	dbw 7, SAND_ATTACK
	dbw 10, QUICK_ATTACK
	dbw 13, SMOG
	dbw 16, FIRE_FANG
	dbw 19, FIRE_SPIN
	dbw 22, FLAME_WHEEL
	dbw 28, PLAY_ROUGH
	dbw 31, SCARY_FACE
	dbw 40, FLARE_BLITZ
	dbw 44, CLOSE_COMBAT
	dbw 47, LEER
	dbw 48, SUPERPOWER
	db 0 ; no more level-up moves

PorygonEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, PORYGON2
	db 0 ; no more evolutions
	dbw 1, CONVERSION
	dbw 1, CONVERSION2
	dbw 1, TACKLE
	dbw 4, SHARPEN
	dbw 7, PSYBEAM
	dbw 10, AGILITY
	dbw 13, RECOVER
	dbw 15, THUNDERSHOCK
	dbw 19, BARRIER
	dbw 20, TRI_ATTACK
	dbw 22, RECYCLE
	dbw 28, DISCHARGE
	dbw 31, LOCK_ON
	dbw 36, SIGNAL_BEAM
	dbw 37, THUNDERBOLT
	dbw 40, TRICK_ROOM
	dbw 46, ZAP_CANNON
	dbw 49, HYPER_BEAM
	db 0 ; no more level-up moves

OmanyteEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, OMASTAR
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, CONSTRICT
	dbw 1, WATER_GUN
	dbw 4, WITHDRAW
	dbw 7, LEER
	dbw 10, BITE
	dbw 10, SAND_ATTACK
	dbw 13, ROLLOUT
	dbw 19, AURORA_BEAM
	dbw 20, ROCK_TOMB
	dbw 22, BUBBLEBEAM
	dbw 25, ANCIENTPOWER
	dbw 25, MUD_SHOT
	dbw 28, PROTECT
	dbw 30, ROCK_POLISH
	dbw 32, STEALTH_ROCK
	dbw 34, EARTH_POWER
	dbw 36, IRON_DEFENSE
	dbw 40, POWER_GEM
	dbw 42, SCALD
	dbw 46, HYDRO_PUMP
	dbw 50, SURF
	dbw 55, SHELL_SMASH
	db 0 ; no more level-up moves

OmastarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, CONSTRICT
	dbw 1, CRUNCH
	dbw 1, KNOCK_OFF
	dbw 1, SAND_ATTACK
	dbw 1, SPIKE_CANNON
	dbw 1, WATER_GUN
	dbw 4, WITHDRAW
	dbw 7, LEER
	dbw 10, BITE
	dbw 13, ROLLOUT
	dbw 19, AURORA_BEAM
	dbw 22, BUBBLEBEAM
	dbw 22, ROCK_TOMB
	dbw 25, ANCIENTPOWER
	dbw 25, MUD_SHOT
	dbw 28, PROTECT
	dbw 30, ROCK_POLISH
	dbw 32, SCALD
	dbw 34, IRON_DEFENSE
	dbw 36, EARTH_POWER
	dbw 36, STEALTH_ROCK
	dbw 44, POWER_GEM
	dbw 52, HYDRO_PUMP
	dbw 56, SURF
	dbw 63, SHELL_SMASH
	db 0 ; no more level-up moves

KabutoEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, KABUTOPS
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, LEER
	dbw 1, SCRATCH
	dbw 7, ABSORB
	dbw 10, AQUA_JET
	dbw 13, ROLLOUT
	dbw 19, ROCK_SLIDE
	dbw 20, ROCK_TOMB
	dbw 22, SAND_ATTACK
	dbw 25, MUD_SHOT
	dbw 28, ENDURE
	dbw 30, ROCK_POLISH
	dbw 31, WATERFALL
	dbw 32, STEALTH_ROCK
	dbw 34, KNOCK_OFF
	dbw 36, IRON_DEFENSE
	dbw 38, ROCK_BLAST
	dbw 41, PROTECT
	dbw 46, LEECH_LIFE
	dbw 50, LIQUIDATION
	dbw 60, STONE_EDGE
	db 0 ; no more level-up moves

KabutopsEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, LEER
	dbw 1, SCRATCH
	dbw 7, ABSORB
	dbw 10, AQUA_JET
	dbw 13, ROLLOUT
	dbw 19, ROCK_SLIDE
	dbw 22, ROCK_TOMB
	dbw 22, SAND_ATTACK
	dbw 25, MUD_SHOT
	dbw 28, ENDURE
	dbw 30, NIGHT_SLASH
	dbw 30, SLASH
	dbw 30, SWORDS_DANCE
	dbw 30, FLIP_TURN
	dbw 32, WATERFALL
	dbw 34, IRON_DEFENSE
	dbw 36, KNOCK_OFF
	dbw 36, STEALTH_ROCK
	dbw 38, ROCK_BLAST
	dbw 42, ROCK_POLISH
	dbw 43, PROTECT
	dbw 44, AQUA_TAIL
	dbw 52, LEECH_LIFE
	dbw 56, LIQUIDATION
	dbw 60, STONE_EDGE
	db 0 ; no more level-up moves

AerodactylEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, FIRE_FANG
	dbw 1, ICE_FANG
	dbw 1, SCARY_FACE
	dbw 1, SUPERSONIC
	dbw 1, THUNDER_FANG
	dbw 9, ROAR
	dbw 13, AGILITY
	dbw 17, WING_ATTACK
	dbw 18, BULLDOZE
	dbw 22, ROCK_TOMB
	dbw 24, TAUNT
	dbw 25, CRUNCH
	dbw 29, ROCK_SLIDE
	dbw 33, TAKE_DOWN
	dbw 34, ROCK_POLISH
	dbw 36, DUALWINGBEAT
	dbw 36, STEALTH_ROCK
	dbw 37, DRAGON_CLAW
	dbw 38, ROCK_BLAST
	dbw 40, DEFOG
	dbw 41, IRON_HEAD
	dbw 45, EARTHQUAKE
	dbw 49, STONE_EDGE
	dbw 53, BRAVE_BIRD
	dbw 61, GIGA_IMPACT
	dbw 65, SKY_ATTACK
	db 0 ; no more level-up moves

SnorlaxEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, DEFENSE_CURL
	dbw 1, FLAIL
	dbw 1, METRONOME
	dbw 1, SCREECH
	dbw 1, TACKLE
	dbw 9, AMNESIA
	dbw 12, LICK
	dbw 12, YAWN
	dbw 15, RECYCLE
	dbw 16, BITE
	dbw 21, BODY_SLAM
	dbw 24, REST
	dbw 24, SNORE
	dbw 26, SLEEP_TALK
	dbw 30, ROLLOUT
	dbw 30, WORK_UP
	dbw 32, BODY_PRESS
	dbw 32, HEAVY_SLAM
	dbw 33, ZEN_HEADBUTT
	dbw 36, CRUNCH
	dbw 42, BELLY_DRUM
	dbw 44, HAMMER_ARM
	dbw 45, DOUBLE_EDGE
	dbw 46, TAKE_DOWN
	dbw 48, SLACK_OFF
	dbw 51, GIGA_IMPACT
	dbw 56, SKULL_BASH
	db 0 ; no more level-up moves

ArticunoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, ICE_SHARD
	dbw 1, MIST
	dbw 1, POWDER_SNOW
	dbw 6, MIND_READER
	dbw 10, ANCIENTPOWER
	dbw 14, AGILITY
	dbw 18, ICY_WIND
	dbw 20, AVALANCHE
	dbw 22, REFLECT
	dbw 24, DEFOG
	dbw 26, HAIL
	dbw 28, AIR_SLASH
	dbw 30, U_TURN
	dbw 34, ICE_BEAM
	dbw 38, BLIZZARD
	dbw 40, DUALWINGBEAT
	dbw 42, ROOST
	dbw 44, FREEZE_DRY
	dbw 46, HURRICANE
	dbw 56, BRAVE_BIRD
	dbw 58, SKY_ATTACK
	dbw 60, HAZE
	db 0 ; no more level-up moves

ZapdosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DETECT
	dbw 1, PECK
	dbw 1, THUNDERSHOCK
	dbw 1, THUNDER_WAVE
	dbw 10, ANCIENTPOWER
	dbw 18, AGILITY
	dbw 22, DISCHARGE
	dbw 26, RAIN_DANCE
	dbw 28, SIGNAL_BEAM
	dbw 30, VOLT_SWITCH
	dbw 34, DRILL_PECK
	dbw 36, HEAT_WAVE
	dbw 38, THUNDER
	dbw 40, DUALWINGBEAT
	dbw 42, ROOST
	dbw 44, HURRICANE
	dbw 46, LIGHT_SCREEN
	dbw 48, DEFOG
	dbw 50, WILD_CHARGE
	dbw 54, ZAP_CANNON
	dbw 56, BRAVE_BIRD
	dbw 58, SKY_ATTACK
	db 0 ; no more level-up moves

MoltresEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AGILITY
	dbw 1, EMBER
	dbw 1, FIRE_SPIN
	dbw 1, GUST
	dbw 1, LEER
	dbw 1, WING_ATTACK
	dbw 6, ENDURE
	dbw 10, ANCIENTPOWER
	dbw 14, FLAMETHROWER
	dbw 18, SAFEGUARD
	dbw 22, AIR_SLASH
	dbw 26, SUNNY_DAY
	dbw 30, U_TURN
	dbw 30, INCINERATE
	dbw 34, SOLARBEAM
	dbw 36, DEFOG
	dbw 38, SKY_ATTACK
	dbw 40, DUALWINGBEAT
	dbw 42, ROOST
	dbw 46, HURRICANE
	dbw 50, ENERGY_BALL
	dbw 55, HEAT_WAVE
	dbw 56, BRAVE_BIRD
	dbw 58, FLARE_BLITZ
	dbw 62, OVERHEAT
	db 0 ; no more level-up moves

DratiniEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, DRAGONAIR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, WRAP
	dbw 5, TWISTER
	dbw 7, THUNDER_WAVE
	dbw 10, DRAGONBREATH
	dbw 13, AQUA_JET
	dbw 15, DRAGON_RAGE
	dbw 19, SLAM
	dbw 22, AGILITY
	dbw 25, DRAGON_PULSE
	dbw 28, AQUA_TAIL
	dbw 28, DRAGON_TAIL
	dbw 31, SAFEGUARD
	dbw 34, SCALE_SHOT
	dbw 37, DRAGON_DANCE
	dbw 40, EXTREMESPEED
	dbw 42, OUTRAGE
	dbw 45, RAIN_DANCE
	dbw 46, HYPER_BEAM
	dbw 56, DRACO_METEOR
	db 0 ; no more level-up moves

DragonairEvosAttacks:
	dbbw EVOLVE_LEVEL, 45, DRAGONITE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, TWISTER
	dbw 1, WRAP
	dbw 7, THUNDER_WAVE
	dbw 10, DRAGONBREATH
	dbw 13, AQUA_JET
	dbw 15, DRAGON_RAGE
	dbw 19, SLAM
	dbw 22, AGILITY
	dbw 25, DRAGON_PULSE
	dbw 28, AQUA_TAIL
	dbw 28, DRAGON_TAIL
	dbw 32, SAFEGUARD
	dbw 38, SCALE_SHOT
	dbw 40, DRAGON_DANCE
	dbw 42, OUTRAGE
	dbw 44, EXTREMESPEED
	dbw 52, HYPER_BEAM
	dbw 53, RAIN_DANCE
	dbw 56, DRACO_METEOR
	db 0 ; no more level-up moves

DragoniteEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FIRE_PUNCH
	dbw 1, LEER
	dbw 1, ROOST
	dbw 1, THUNDERPUNCH
	dbw 1, TWISTER
	dbw 1, WRAP
	dbw 7, THUNDER_WAVE
	dbw 10, DRAGONBREATH
	dbw 13, AQUA_JET
	dbw 15, DRAGON_RAGE
	dbw 19, SLAM
	dbw 22, AGILITY
	dbw 24, ENCORE
	dbw 25, DRAGON_PULSE
	dbw 26, AIR_SLASH
	dbw 28, AQUA_TAIL
	dbw 28, DRAGON_TAIL
	dbw 32, SAFEGUARD
	dbw 34, DEFOG
	dbw 38, BODY_PRESS
	dbw 40, DRAGON_DANCE
	dbw 40, DUALWINGBEAT
	dbw 42, OUTRAGE
	dbw 42, SCALE_SHOT
	dbw 44, EXTREMESPEED
	dbw 52, HYPER_BEAM
	dbw 53, RAIN_DANCE
	dbw 55, HEAT_WAVE
	dbw 55, WING_ATTACK
	dbw 60, HURRICANE
	dbw 70, DRACO_METEOR
	db 0 ; no more level-up moves

MewtwoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, DISABLE
	dbw 1, SAFEGUARD
	dbw 1, TELEPORT
	dbw 1, PSYWAVE
	dbw 6, SWIFT
	dbw 8, ANCIENTPOWER
	dbw 10, FUTURE_SIGHT
	dbw 14, PSYCH_UP
	dbw 18, PSYBEAM
	dbw 24, TAUNT
	dbw 30, RECOVER
	dbw 30, CALM_MIND
	dbw 34, AMNESIA
	dbw 36, SKILL_SWAP
	dbw 38, PSYCHIC_M
	dbw 40, TRICK
	dbw 42, MIST
	dbw 44, TRICK_ROOM
	dbw 46, BARRIER
	dbw 46, SIGNAL_BEAM
	dbw 50, AURA_SPHERE
	dbw 50, PSYCHO_CUT
	dbw 52, DREAM_EATER
	dbw 72, PSYSTRIKE
	db 0 ; no more level-up moves

MewEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, TRANSFORM
	dbw 6, MEGA_PUNCH
	dbw 10, METRONOME
	dbw 18, PSYBEAM
	dbw 22, BATON_PASS
	dbw 24, STEALTH_ROCK
	dbw 26, AMNESIA
	dbw 28, SIGNAL_BEAM
	dbw 30, CALM_MIND
	dbw 30, SWORDS_DANCE
	dbw 30, U_TURN
	dbw 32, PSYCHO_CUT
	dbw 34, ANCIENTPOWER
	dbw 36, SKILL_SWAP
	dbw 38, PSYCHIC_M
	dbw 40, TRICK
	dbw 42, NASTY_PLOT
	dbw 44, BARRIER
	dbw 46, HYPNOSIS
	dbw 48, TRICK_ROOM
	dbw 50, AURA_SPHERE
	dbw 52, DREAM_EATER
	dbw 56, FUTURE_SIGHT
	db 0 ; no more level-up moves
