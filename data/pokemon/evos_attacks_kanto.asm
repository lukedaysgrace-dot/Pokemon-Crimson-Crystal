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
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 7, LEECH_SEED
	dbw 10, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 20, RAZOR_LEAF
	dbw 21, TAKE_DOWN
	dbw 25, SWEET_SCENT
	dbw 32, GROWTH
	dbw 39, SYNTHESIS
	dbw 46, SOLARBEAM
	db 0 ; no more level-up moves

IvysaurEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, VENUSAUR
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, LEECH_SEED
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 7, LEECH_SEED
	dbw 10, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 22, RAZOR_LEAF
	dbw 25, TAKE_DOWN
	dbw 29, SWEET_SCENT
	dbw 38, GROWTH
	dbw 47, SYNTHESIS
	dbw 55, SOLARBEAM
	db 0 ; no more level-up moves

VenusaurEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, LEECH_SEED
	dbw 1, PETAL_DANCE
	dbw 1, TACKLE
	dbw 1, VINE_WHIP
	dbw 4, GROWL
	dbw 7, LEECH_SEED
	dbw 10, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 22, RAZOR_LEAF
	dbw 25, TAKE_DOWN
	dbw 29, SWEET_SCENT
	dbw 41, GROWTH
	dbw 53, SYNTHESIS
	dbw 55, SOLARBEAM
	db 0 ; no more level-up moves

CharmanderEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, CHARMELEON
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 7, EMBER
	dbw 12, DRAGONBREATH
	dbw 13, SMOKESCREEN
	dbw 17, FIRE_FANG
	dbw 19, RAGE
	dbw 25, SCARY_FACE
	dbw 31, FLAMETHROWER
	dbw 37, SLASH
	dbw 43, DRAGON_RAGE
	dbw 49, FIRE_SPIN
	db 0 ; no more level-up moves

CharmeleonEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, CHARIZARD
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 7, EMBER
	dbw 12, DRAGONBREATH
	dbw 13, SMOKESCREEN
	dbw 19, FIRE_FANG
	dbw 20, RAGE
	dbw 27, SCARY_FACE
	dbw 34, FLAMETHROWER
	dbw 41, SLASH
	dbw 48, DRAGON_RAGE
	dbw 55, FIRE_SPIN
	db 0 ; no more level-up moves

CharizardEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DRAGON_CLAW
	dbw 1, EMBER
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 1, SMOKESCREEN
	dbw 7, EMBER
	dbw 12, DRAGONBREATH
	dbw 13, SMOKESCREEN
	dbw 19, FIRE_FANG
	dbw 20, RAGE
	dbw 27, SCARY_FACE
	dbw 34, FLAMETHROWER
	dbw 36, WING_ATTACK
	dbw 44, SLASH
	dbw 54, DRAGON_RAGE
	dbw 64, FIRE_SPIN
	db 0 ; no more level-up moves

SquirtleEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, WARTORTLE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, TAIL_WHIP
	dbw 7, BUBBLE
	dbw 10, WITHDRAW
	dbw 13, WATER_GUN
	dbw 18, BITE
	dbw 23, RAPID_SPIN
	dbw 28, PROTECT
	dbw 33, RAIN_DANCE
	dbw 40, SKULL_BASH
	dbw 47, HYDRO_PUMP
	db 0 ; no more level-up moves

WartortleEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, BLASTOISE
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 4, TAIL_WHIP
	dbw 7, BUBBLE
	dbw 10, WITHDRAW
	dbw 13, WATER_GUN
	dbw 19, BITE
	dbw 25, RAPID_SPIN
	dbw 31, PROTECT
	dbw 37, RAIN_DANCE
	dbw 45, SKULL_BASH
	dbw 53, HYDRO_PUMP
	db 0 ; no more level-up moves

BlastoiseEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, WITHDRAW
	dbw 4, TAIL_WHIP
	dbw 7, BUBBLE
	dbw 10, WITHDRAW
	dbw 13, WATER_GUN
	dbw 19, BITE
	dbw 25, RAPID_SPIN
	dbw 31, PROTECT
	dbw 42, RAIN_DANCE
	dbw 55, SKULL_BASH
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

CaterpieEvosAttacks:
	dbbw EVOLVE_LEVEL, 7, METAPOD
	db 0 ; no more evolutions
	dbw 1, STRING_SHOT
	dbw 1, TACKLE
	dbw 9, BUG_BITE
	db 0 ; no more level-up moves

MetapodEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, BUTTERFREE
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 7, HARDEN
	db 0 ; no more level-up moves

ButterfreeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, CONFUSION
	dbw 1, HARDEN
	dbw 1, STRING_SHOT
	dbw 1, TACKLE
	dbw 10, CONFUSION
	dbw 13, POISONPOWDER
	dbw 14, STUN_SPORE
	dbw 15, SLEEP_POWDER
	dbw 18, SUPERSONIC
	dbw 23, WHIRLWIND
	dbw 24, AIR_SLASH
	dbw 28, GUST
	dbw 32, BUG_BUZZ
	dbw 34, PSYBEAM
	dbw 40, SAFEGUARD
	db 0 ; no more level-up moves

WeedleEvosAttacks:
	dbbw EVOLVE_LEVEL, 7, KAKUNA
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 9, BUG_BITE
	db 0 ; no more level-up moves

KakunaEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, BEEDRILL
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 7, HARDEN
	db 0 ; no more level-up moves

BeedrillEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUG_BITE
	dbw 1, FURY_ATTACK
	dbw 1, HARDEN
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 10, FURY_ATTACK
	dbw 11, FURY_CUTTER
	dbw 15, FOCUS_ENERGY
	dbw 20, TWINEEDLE
	dbw 23, VENOSHOCK
	dbw 25, RAGE
	dbw 30, PURSUIT
	dbw 35, PIN_MISSILE
	dbw 35, POISON_JAB
	dbw 40, AGILITY
	db 0 ; no more level-up moves

PidgeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, PIDGEOTTO
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 5, SAND_ATTACK
	dbw 9, GUST
	dbw 15, QUICK_ATTACK
	dbw 21, TWISTER
	dbw 21, WHIRLWIND
	dbw 29, WING_ATTACK
	dbw 37, AGILITY
	dbw 42, AIR_SLASH
	dbw 47, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeottoEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, PIDGEOT
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, SAND_ATTACK
	dbw 1, TACKLE
	dbw 5, SAND_ATTACK
	dbw 9, GUST
	dbw 15, QUICK_ATTACK
	dbw 22, TWISTER
	dbw 23, WHIRLWIND
	dbw 33, WING_ATTACK
	dbw 42, AIR_SLASH
	dbw 43, AGILITY
	dbw 55, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeotEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, QUICK_ATTACK
	dbw 1, SAND_ATTACK
	dbw 1, TACKLE
	dbw 5, SAND_ATTACK
	dbw 9, GUST
	dbw 15, QUICK_ATTACK
	dbw 22, TWISTER
	dbw 23, WHIRLWIND
	dbw 33, WING_ATTACK
	dbw 42, AIR_SLASH
	dbw 46, AGILITY
	dbw 61, MIRROR_MOVE
	db 0 ; no more level-up moves

RattataEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, RATICATE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, QUICK_ATTACK
	dbw 10, BITE
	dbw 13, HYPER_FANG
	dbw 16, TAKE_DOWN
	dbw 20, FOCUS_ENERGY
	dbw 22, CRUNCH
	dbw 25, SUCKER_PUNCH
	dbw 27, PURSUIT
	dbw 31, DOUBLE_EDGE
	dbw 34, SUPER_FANG
	db 0 ; no more level-up moves

RaticateEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, QUICK_ATTACK
	dbw 1, SWORDS_DANCE
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, QUICK_ATTACK
	dbw 10, BITE
	dbw 13, HYPER_FANG
	dbw 16, TAKE_DOWN
	dbw 20, SCARY_FACE
	dbw 24, CRUNCH
	dbw 29, SUCKER_PUNCH
	dbw 30, PURSUIT
	dbw 39, DOUBLE_EDGE
	dbw 40, SUPER_FANG
	db 0 ; no more level-up moves

SpearowEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, FEAROW
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, PECK
	dbw 7, LEER
	dbw 13, FURY_ATTACK
	dbw 18, WING_ATTACK
	dbw 22, TAKE_DOWN
	dbw 25, PURSUIT
	dbw 29, FOCUS_ENERGY
	dbw 31, MIRROR_MOVE
	dbw 37, DRILL_PECK
	dbw 43, AGILITY
	db 0 ; no more level-up moves

FearowEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FURY_ATTACK
	dbw 1, GROWL
	dbw 1, LEER
	dbw 1, PECK
	dbw 7, LEER
	dbw 13, FURY_ATTACK
	dbw 18, WING_ATTACK
	dbw 23, TAKE_DOWN
	dbw 26, PURSUIT
	dbw 32, FOCUS_ENERGY
	dbw 32, MIRROR_MOVE
	dbw 40, DRILL_PECK
	dbw 47, AGILITY
	db 0 ; no more level-up moves

EkansEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, ARBOK
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, WRAP
	dbw 9, POISON_STING
	dbw 15, BITE
	dbw 23, GLARE
	dbw 29, SCREECH
	dbw 33, SLUDGE_BOMB
	dbw 37, ACID
	dbw 43, HAZE
	db 0 ; no more level-up moves

ArbokEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, FIRE_FANG
	dbw 1, ICE_FANG
	dbw 1, LEER
	dbw 1, POISON_STING
	dbw 1, THUNDER_FANG
	dbw 1, WRAP
	dbw 9, POISON_STING
	dbw 15, BITE
	dbw 25, GLARE
	dbw 33, SCREECH
	dbw 39, SLUDGE_BOMB
	dbw 43, ACID
	dbw 51, HAZE
	db 0 ; no more level-up moves

PikachuEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, RAICHU
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, GROWL
	dbw 1, SWEET_KISS
	dbw 1, THUNDERSHOCK
	dbw 6, TAIL_WHIP
	dbw 8, THUNDER_WAVE
	dbw 11, QUICK_ATTACK
	dbw 15, DOUBLE_TEAM
	dbw 20, SLAM
	dbw 20, SPARK
	dbw 26, THUNDERBOLT
	dbw 28, IRON_TAIL
	dbw 33, AGILITY
	dbw 41, THUNDER
	dbw 50, LIGHT_SCREEN
	db 0 ; no more level-up moves

RaichuEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, QUICK_ATTACK
	dbw 1, THUNDERSHOCK
	dbw 1, THUNDER_WAVE
	dbw 8, THUNDER_WAVE
	dbw 11, QUICK_ATTACK
	dbw 20, SPARK
	dbw 26, THUNDERBOLT
	dbw 28, IRON_TAIL
	dbw 33, AGILITY
	dbw 41, THUNDER
	dbw 50, LIGHT_SCREEN
	db 0 ; no more level-up moves

SandshrewEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, SANDSLASH
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 6, DEFENSE_CURL
	dbw 9, ROLLOUT
	dbw 11, SAND_ATTACK
	dbw 12, FURY_CUTTER
	dbw 15, RAPID_SPIN
	dbw 17, POISON_STING
	dbw 23, SLASH
	dbw 27, AGILITY
	dbw 30, SWIFT
	dbw 33, DIG
	dbw 37, FURY_SWIPES
	dbw 39, SWORDS_DANCE
	dbw 45, EARTHQUAKE
	dbw 45, SANDSTORM
	db 0 ; no more level-up moves

SandslashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, SAND_ATTACK
	dbw 1, SCRATCH
	dbw 6, DEFENSE_CURL
	dbw 9, ROLLOUT
	dbw 11, SAND_ATTACK
	dbw 12, FURY_CUTTER
	dbw 15, RAPID_SPIN
	dbw 17, POISON_STING
	dbw 24, SLASH
	dbw 33, SWIFT
	dbw 41, DIG
	dbw 42, FURY_SWIPES
	dbw 50, SWORDS_DANCE
	dbw 50, EARTHQUAKE
	dbw 52, SANDSTORM
	db 0 ; no more level-up moves

NidoranFEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINA
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 8, SCRATCH
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, TAIL_WHIP
	dbw 30, BITE
	dbw 38, FURY_SWIPES
	dbw 40, TOXIC
	dbw 44, CRUNCH
	db 0 ; no more level-up moves

NidorinaEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, NIDOQUEEN
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 8, SCRATCH
	dbw 12, DOUBLE_KICK
	dbw 19, POISON_STING
	dbw 27, TAIL_WHIP
	dbw 36, BITE
	dbw 44, CRUNCH
	dbw 46, FURY_SWIPES
	dbw 50, TOXIC
	db 0 ; no more level-up moves

NidoqueenEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, DOUBLE_KICK
	dbw 1, POISON_STING
	dbw 23, BODY_SLAM
	dbw 32, BITE
	dbw 38, SLUDGE_BOMB
	dbw 42, EARTHQUAKE
	dbw 44, CRUNCH
	dbw 50, TOXIC
	db 0 ; no more level-up moves

NidoranMEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINO
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, TACKLE
	dbw 5, PECK
	dbw 8, HORN_ATTACK
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, FOCUS_ENERGY
	dbw 30, FURY_ATTACK
	dbw 38, HORN_DRILL
	dbw 40, TOXIC
	dbw 42, POISON_JAB
	db 0 ; no more level-up moves

NidorinoEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, NIDOKING
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, TACKLE
	dbw 8, HORN_ATTACK
	dbw 12, DOUBLE_KICK
	dbw 19, POISON_STING
	dbw 27, FOCUS_ENERGY
	dbw 36, FURY_ATTACK
	dbw 42, POISON_JAB
	dbw 46, HORN_DRILL
	dbw 50, TOXIC
	db 0 ; no more level-up moves

NidokingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DOUBLE_KICK
	dbw 1, HORN_ATTACK
	dbw 1, POISON_STING
	dbw 23, THRASH
	dbw 32, POISON_JAB
	dbw 38, MEGAHORN
	dbw 42, EARTHQUAKE
	dbw 46, HORN_DRILL
	dbw 50, TOXIC
	db 0 ; no more level-up moves

ClefairyEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, CLEFABLE
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DISARMING_VOICE
	dbw 1, GROWL
	dbw 1, POUND
	dbw 1, SPLASH
	dbw 1, SWEET_KISS
	dbw 4, ENCORE
	dbw 8, SING
	dbw 13, DOUBLESLAP
	dbw 19, MINIMIZE
	dbw 26, DEFENSE_CURL
	dbw 34, METRONOME
	dbw 43, MOONLIGHT
	dbw 44, MOONBLAST
	dbw 53, LIGHT_SCREEN
	db 0 ; no more level-up moves

ClefableEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DISARMING_VOICE
	dbw 1, POUND
	dbw 1, SING
	dbw 13, DOUBLESLAP
	dbw 19, MINIMIZE
	dbw 26, DEFENSE_CURL
	dbw 34, METRONOME
	dbw 43, MOONLIGHT
	dbw 44, MOONBLAST
	dbw 53, LIGHT_SCREEN
	db 0 ; no more level-up moves

VulpixEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, NINETALES
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, TAIL_WHIP
	dbw 4, DISABLE
	dbw 7, QUICK_ATTACK
	dbw 12, SPITE
	dbw 13, ROAR
	dbw 19, CONFUSE_RAY
	dbw 25, SAFEGUARD
	dbw 31, FLAMETHROWER
	dbw 37, FIRE_SPIN
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

NinetalesEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSE_RAY
	dbw 1, EMBER
	dbw 1, QUICK_ATTACK
	dbw 7, QUICK_ATTACK
	dbw 12, SPITE
	dbw 13, ROAR
	dbw 19, CONFUSE_RAY
	dbw 25, SAFEGUARD
	dbw 31, FLAMETHROWER
	dbw 37, FIRE_SPIN
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

JigglypuffEvosAttacks:
	dbbw EVOLVE_ITEM, MOON_STONE, WIGGLYTUFF
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DISARMING_VOICE
	dbw 1, SING
	dbw 1, SWEET_KISS
	dbw 4, DEFENSE_CURL
	dbw 9, POUND
	dbw 14, DISABLE
	dbw 19, ROLLOUT
	dbw 24, DOUBLESLAP
	dbw 28, MIMIC
	dbw 29, REST
	dbw 34, BODY_SLAM
	dbw 39, DOUBLE_EDGE
	db 0 ; no more level-up moves

WigglytuffEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DISARMING_VOICE
	dbw 1, POUND
	dbw 1, SING
	dbw 14, DISABLE
	dbw 19, ROLLOUT
	dbw 24, DOUBLESLAP
	dbw 28, MIMIC
	dbw 29, REST
	dbw 34, BODY_SLAM
	dbw 39, DOUBLE_EDGE
	dbw 42, PLAY_ROUGH
	db 0 ; no more level-up moves

ZubatEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, GOLBAT
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, LEECH_LIFE
	dbw 6, SUPERSONIC
	dbw 12, BITE
	dbw 15, POISON_FANG
	dbw 19, CONFUSE_RAY
	dbw 27, WING_ATTACK
	dbw 36, MEAN_LOOK
	dbw 40, VENOSHOCK
	dbw 42, AIR_SLASH
	dbw 46, HAZE
	db 0 ; no more level-up moves

GolbatEvosAttacks:
	dbbw EVOLVE_HAPPINESS, TR_ANYTIME, CROBAT
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, LEECH_LIFE
	dbw 1, SCREECH
	dbw 1, SUPERSONIC
	dbw 6, SUPERSONIC
	dbw 12, BITE
	dbw 15, POISON_FANG
	dbw 19, CONFUSE_RAY
	dbw 30, WING_ATTACK
	dbw 42, MEAN_LOOK
	dbw 42, AIR_SLASH
	dbw 48, VENOSHOCK
	dbw 55, HAZE
	db 0 ; no more level-up moves

OddishEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, GLOOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, GROWTH
	dbw 7, SWEET_SCENT
	dbw 12, MEGA_DRAIN
	dbw 14, POISONPOWDER
	dbw 16, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 20, GIGA_DRAIN
	dbw 23, ACID
	dbw 24, TOXIC
	dbw 28, MOONBLAST
	dbw 32, MOONLIGHT
	dbw 39, PETAL_DANCE
	db 0 ; no more level-up moves

GloomEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, VILEPLUME
	dbbw EVOLVE_ITEM, SUN_STONE, BELLOSSOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, GROWTH
	dbw 1, POISONPOWDER
	dbw 1, SWEET_SCENT
	dbw 7, SWEET_SCENT
	dbw 12, MEGA_DRAIN
	dbw 14, POISONPOWDER
	dbw 16, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 20, GIGA_DRAIN
	dbw 24, ACID
	dbw 26, TOXIC
	dbw 32, MOONBLAST
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	db 0 ; no more level-up moves

VileplumeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, ACID
	dbw 1, SLEEP_POWDER
	dbw 12, MEGA_DRAIN
	dbw 18, SLEEP_POWDER
	dbw 20, GIGA_DRAIN
	dbw 24, ACID
	dbw 26, TOXIC
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	dbw 55, SOLARBEAM
	db 0 ; no more level-up moves

ParasEvosAttacks:
	dbbw EVOLVE_LEVEL, 24, PARASECT
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 7, STUN_SPORE
	dbw 11, ABSORB
	dbw 13, POISONPOWDER
	dbw 17, FURY_CUTTER
	dbw 19, LEECH_LIFE
	dbw 25, SPORE
	dbw 31, SLASH
	dbw 37, GROWTH
	dbw 42, GIGA_DRAIN
	dbw 42, X_SCISSOR
	db 0 ; no more level-up moves

ParasectEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, POISONPOWDER
	dbw 1, SCRATCH
	dbw 1, STUN_SPORE
	dbw 7, STUN_SPORE
	dbw 13, POISONPOWDER
	dbw 17, FURY_CUTTER
	dbw 19, LEECH_LIFE
	dbw 28, SPORE
	dbw 37, SLASH
	dbw 42, GIGA_DRAIN
	dbw 42, X_SCISSOR
	dbw 46, GROWTH
	db 0 ; no more level-up moves

VenonatEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, VENOMOTH
	db 0 ; no more evolutions
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 1, TACKLE
	dbw 9, SUPERSONIC
	dbw 17, CONFUSION
	dbw 20, POISONPOWDER
	dbw 25, BUG_BUZZ
	dbw 25, LEECH_LIFE
	dbw 28, STUN_SPORE
	dbw 33, PSYBEAM
	dbw 36, SLEEP_POWDER
	dbw 41, POISON_FANG
	dbw 41, PSYCHIC_M
	db 0 ; no more level-up moves

VenomothEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 1, SUPERSONIC
	dbw 1, TACKLE
	dbw 9, SUPERSONIC
	dbw 17, CONFUSION
	dbw 20, POISONPOWDER
	dbw 25, BUG_BUZZ
	dbw 25, LEECH_LIFE
	dbw 28, STUN_SPORE
	dbw 31, GUST
	dbw 36, PSYBEAM
	dbw 42, SLEEP_POWDER
	dbw 47, POISON_FANG
	dbw 48, PSYCHIC_M
	db 0 ; no more level-up moves

DiglettEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, DUGTRIO
	db 0 ; no more evolutions
	dbw 1, DIG
	dbw 5, GROWL
	dbw 9, MAGNITUDE
	dbw 12, MUD_SLAP
	dbw 17, DIG
	dbw 20, SUCKER_PUNCH
	dbw 25, SAND_ATTACK
	dbw 28, SANDSTORM
	dbw 33, SLASH
	dbw 41, EARTHQUAKE
	dbw 49, FISSURE
	db 0 ; no more level-up moves

DugtrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, MAGNITUDE
	dbw 1, SCRATCH
	dbw 1, TRI_ATTACK
	dbw 5, GROWL
	dbw 9, MAGNITUDE
	dbw 12, MUD_SLAP
	dbw 17, DIG
	dbw 20, SUCKER_PUNCH
	dbw 25, SAND_ATTACK
	dbw 30, SANDSTORM
	dbw 37, SLASH
	dbw 49, EARTHQUAKE
	dbw 61, FISSURE
	db 0 ; no more level-up moves

MeowthEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PERSIAN
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 11, BITE
	dbw 20, PAY_DAY
	dbw 28, FAINT_ATTACK
	dbw 35, SCREECH
	dbw 41, FURY_SWIPES
	dbw 42, PLAY_ROUGH
	dbw 46, SLASH
	db 0 ; no more level-up moves

PersianEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, GROWL
	dbw 1, SCRATCH
	dbw 11, BITE
	dbw 20, PAY_DAY
	dbw 29, FAINT_ATTACK
	dbw 38, SCREECH
	dbw 42, PLAY_ROUGH
	dbw 46, FURY_SWIPES
	dbw 53, SLASH
	db 0 ; no more level-up moves

PsyduckEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, GOLDUCK
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 3, WATER_GUN
	dbw 5, TAIL_WHIP
	dbw 10, DISABLE
	dbw 16, CONFUSION
	dbw 23, SCREECH
	dbw 31, PSYCH_UP
	dbw 34, AMNESIA
	dbw 40, FURY_SWIPES
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

GolduckEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AQUA_JET
	dbw 1, CONFUSION
	dbw 1, DISABLE
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 1, WATER_GUN
	dbw 5, TAIL_WHIP
	dbw 10, DISABLE
	dbw 16, CONFUSION
	dbw 23, SCREECH
	dbw 31, PSYCH_UP
	dbw 36, AMNESIA
	dbw 44, FURY_SWIPES
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

MankeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PRIMEAPE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, SCRATCH
	dbw 9, LOW_KICK
	dbw 15, KARATE_CHOP
	dbw 17, SWAGGER
	dbw 21, FURY_SWIPES
	dbw 27, FOCUS_ENERGY
	dbw 33, SEISMIC_TOSS
	dbw 39, CROSS_CHOP
	dbw 44, OUTRAGE
	dbw 45, SCREECH
	dbw 51, THRASH
	db 0 ; no more level-up moves

PrimeapeEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, ANNIHILAPE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 1, RAGE
	dbw 1, SCRATCH
	dbw 9, LOW_KICK
	dbw 15, KARATE_CHOP
	dbw 17, SWAGGER
	dbw 21, FURY_SWIPES
	dbw 27, FOCUS_ENERGY
	dbw 28, RAGE
	dbw 36, SEISMIC_TOSS
	dbw 45, CROSS_CHOP
	dbw 53, OUTRAGE
	dbw 54, SCREECH
	dbw 63, THRASH
	db 0 ; no more level-up moves

GrowlitheEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, ARCANINE
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, ROAR
	dbw 9, EMBER
	dbw 18, LEER
	dbw 24, FIRE_FANG
	dbw 26, TAKE_DOWN
	dbw 32, CRUNCH
	dbw 34, FLAME_WHEEL
	dbw 42, AGILITY
	dbw 42, PLAY_ROUGH
	dbw 45, FLAMETHROWER
	dbw 52, REVERSAL
	db 0 ; no more level-up moves

ArcanineEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, EMBER
	dbw 1, ROAR
	dbw 24, FIRE_FANG
	dbw 32, CRUNCH
	dbw 34, FLAME_WHEEL
	dbw 42, AGILITY
	dbw 42, PLAY_ROUGH
	dbw 45, FLAMETHROWER
	dbw 50, EXTREMESPEED
	db 0 ; no more level-up moves

PoliwagEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, POLIWHIRL
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 6, POUND
	dbw 7, HYPNOSIS
	dbw 13, WATER_GUN
	dbw 18, BUBBLEBEAM
	dbw 19, DOUBLESLAP
	dbw 25, RAIN_DANCE
	dbw 31, BODY_SLAM
	dbw 37, BELLY_DRUM
	dbw 43, HYDRO_PUMP
	dbw 54, DOUBLE_EDGE
	db 0 ; no more level-up moves

PoliwhirlEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, POLIWRATH
	dbbw EVOLVE_TRADE, KINGS_ROCK, POLITOED
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, HYPNOSIS
	dbw 1, POUND
	dbw 1, WATER_GUN
	dbw 7, HYPNOSIS
	dbw 13, WATER_GUN
	dbw 18, BUBBLEBEAM
	dbw 19, DOUBLESLAP
	dbw 27, RAIN_DANCE
	dbw 35, BODY_SLAM
	dbw 43, BELLY_DRUM
	dbw 51, HYDRO_PUMP
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

PoliwrathEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, SUBMISSION
	dbw 1, WATER_GUN
	dbw 18, BUBBLEBEAM
	dbw 27, RAIN_DANCE
	dbw 35, BODY_SLAM
	dbw 35, SUBMISSION
	dbw 42, SURF
	dbw 43, BELLY_DRUM
	dbw 51, MIND_READER
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

AbraEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, KADABRA
	db 0 ; no more evolutions
	dbw 1, TELEPORT
	db 0 ; no more level-up moves

KadabraEvosAttacks:
	dbbw EVOLVE_TRADE, -1, ALAKAZAM
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, KINESIS
	dbw 1, TELEPORT
	dbw 16, CONFUSION
	dbw 18, DISABLE
	dbw 21, PSYBEAM
	dbw 26, RECOVER
	dbw 31, FUTURE_SIGHT
	dbw 38, PSYCHIC_M
	dbw 45, REFLECT
	db 0 ; no more level-up moves

AlakazamEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, KINESIS
	dbw 1, TELEPORT
	dbw 16, CONFUSION
	dbw 18, DISABLE
	dbw 21, PSYBEAM
	dbw 26, RECOVER
	dbw 31, FUTURE_SIGHT
	dbw 38, PSYCHIC_M
	dbw 45, REFLECT
	db 0 ; no more level-up moves

MachopEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MACHOKE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 7, FOCUS_ENERGY
	dbw 13, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 29, STRENGTH
	dbw 31, VITAL_THROW
	dbw 37, CROSS_CHOP
	dbw 43, SCARY_FACE
	dbw 44, DYNAMICPUNCH
	dbw 49, SUBMISSION
	dbw 52, DOUBLE_EDGE
	db 0 ; no more level-up moves

MachokeEvosAttacks:
	dbbw EVOLVE_TRADE, -1, MACHAMP
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 8, FOCUS_ENERGY
	dbw 15, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 31, STRENGTH
	dbw 34, VITAL_THROW
	dbw 43, CROSS_CHOP
	dbw 52, SCARY_FACE
	dbw 54, DYNAMICPUNCH
	dbw 61, SUBMISSION
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

MachampEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 8, FOCUS_ENERGY
	dbw 15, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 31, STRENGTH
	dbw 34, VITAL_THROW
	dbw 43, CROSS_CHOP
	dbw 52, SCARY_FACE
	dbw 54, DYNAMICPUNCH
	dbw 61, SUBMISSION
	dbw 66, DOUBLE_EDGE
	db 0 ; no more level-up moves

BellsproutEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, WEEPINBELL
	db 0 ; no more evolutions
	dbw 1, VINE_WHIP
	dbw 6, GROWTH
	dbw 11, WRAP
	dbw 15, SLEEP_POWDER
	dbw 17, POISONPOWDER
	dbw 19, STUN_SPORE
	dbw 23, ACID
	dbw 30, SWEET_SCENT
	dbw 37, RAZOR_LEAF
	dbw 41, POISON_JAB
	dbw 45, SLAM
	db 0 ; no more level-up moves

WeepinbellEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, VICTREEBEL
	db 0 ; no more evolutions
	dbw 1, GROWTH
	dbw 1, VINE_WHIP
	dbw 1, WRAP
	dbw 6, GROWTH
	dbw 11, WRAP
	dbw 15, SLEEP_POWDER
	dbw 17, POISONPOWDER
	dbw 19, STUN_SPORE
	dbw 24, ACID
	dbw 33, SWEET_SCENT
	dbw 42, RAZOR_LEAF
	dbw 42, POISON_JAB
	dbw 54, SLAM
	db 0 ; no more level-up moves

VictreebelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, RAZOR_LEAF
	dbw 1, SLEEP_POWDER
	dbw 1, VINE_WHIP
	dbw 19, STUN_SPORE
	dbw 24, ACID
	dbw 33, SWEET_SCENT
	dbw 37, RAZOR_LEAF
	dbw 42, LEAF_BLADE
	dbw 42, POISON_JAB
	dbw 45, SLUDGE_BOMB
	dbw 55, SOLARBEAM
	db 0 ; no more level-up moves

TentacoolEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, TENTACRUEL
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, WATER_GUN
	dbw 6, SUPERSONIC
	dbw 12, CONSTRICT
	dbw 19, ACID
	dbw 25, BUBBLEBEAM
	dbw 30, WRAP
	dbw 32, ACID_ARMOR
	dbw 36, BARRIER
	dbw 36, POISON_JAB
	dbw 40, SURF
	dbw 43, SCREECH
	dbw 49, HYDRO_PUMP
	db 0 ; no more level-up moves

TentacruelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 1, POISON_STING
	dbw 1, SUPERSONIC
	dbw 1, WATER_GUN
	dbw 6, SUPERSONIC
	dbw 12, CONSTRICT
	dbw 19, ACID
	dbw 25, BUBBLEBEAM
	dbw 30, WRAP
	dbw 34, ACID_ARMOR
	dbw 38, BARRIER
	dbw 40, POISON_JAB
	dbw 42, SURF
	dbw 47, SCREECH
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

GeodudeEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, GRAVELER
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 6, DEFENSE_CURL
	dbw 11, ROCK_THROW
	dbw 16, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 26, HARDEN
	dbw 31, ROLLOUT
	dbw 36, EARTHQUAKE
	dbw 40, DOUBLE_EDGE
	dbw 41, EXPLOSION
	dbw 42, STONE_EDGE
	db 0 ; no more level-up moves

GravelerEvosAttacks:
	dbbw EVOLVE_TRADE, -1, GOLEM
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, ROCK_THROW
	dbw 1, TACKLE
	dbw 6, DEFENSE_CURL
	dbw 11, ROCK_THROW
	dbw 16, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 27, HARDEN
	dbw 34, ROLLOUT
	dbw 41, EARTHQUAKE
	dbw 48, EXPLOSION
	dbw 48, STONE_EDGE
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

GolemEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DEFENSE_CURL
	dbw 1, MAGNITUDE
	dbw 1, ROCK_THROW
	dbw 1, TACKLE
	dbw 6, DEFENSE_CURL
	dbw 11, ROCK_THROW
	dbw 16, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 27, HARDEN
	dbw 34, ROLLOUT
	dbw 41, EARTHQUAKE
	dbw 48, EXPLOSION
	dbw 48, STONE_EDGE
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

PonytaEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, RAPIDASH
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 8, TAIL_WHIP
	dbw 13, EMBER
	dbw 19, STOMP
	dbw 25, FLAME_WHEEL
	dbw 26, FIRE_SPIN
	dbw 34, TAKE_DOWN
	dbw 43, AGILITY
	dbw 53, FIRE_BLAST
	db 0 ; no more level-up moves

RapidashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, GROWL
	dbw 1, MEGAHORN
	dbw 1, POISON_JAB
	dbw 1, QUICK_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 4, GROWL
	dbw 8, TAIL_WHIP
	dbw 13, EMBER
	dbw 19, STOMP
	dbw 25, FLAME_WHEEL
	dbw 26, FIRE_SPIN
	dbw 34, TAKE_DOWN
	dbw 40, FURY_ATTACK
	dbw 47, AGILITY
	dbw 55, FIRE_BLAST
	db 0 ; no more level-up moves

SlowpokeEvosAttacks:
	dbbw EVOLVE_LEVEL, 37, SLOWBRO
	dbbw EVOLVE_TRADE, KINGS_ROCK, SLOWKING
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 6, GROWL
	dbw 15, WATER_GUN
	dbw 20, CONFUSION
	dbw 29, DISABLE
	dbw 30, SURF
	dbw 34, HEADBUTT
	dbw 39, PSYCH_UP
	dbw 42, RAIN_DANCE
	dbw 43, AMNESIA
	dbw 48, PSYCHIC_M
	db 0 ; no more level-up moves

SlowbroEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 1, WATER_GUN
	dbw 6, GROWL
	dbw 15, WATER_GUN
	dbw 20, CONFUSION
	dbw 29, DISABLE
	dbw 30, SURF
	dbw 34, HEADBUTT
	dbw 37, WITHDRAW
	dbw 41, PSYCH_UP
	dbw 46, AMNESIA
	dbw 46, RAIN_DANCE
	dbw 48, PSYCHIC_M
	db 0 ; no more level-up moves

MagnemiteEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, MAGNETON
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 6, THUNDERSHOCK
	dbw 11, SUPERSONIC
	dbw 16, SONICBOOM
	dbw 20, SPARK
	dbw 21, THUNDER_WAVE
	dbw 27, LOCK_ON
	dbw 33, SWIFT
	dbw 39, SCREECH
	dbw 44, LIGHT_SCREEN
	dbw 45, ZAP_CANNON
	db 0 ; no more level-up moves

MagnetonEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, MAGNEZONE
	db 0 ; no more evolutions
	dbw 1, SONICBOOM
	dbw 1, SUPERSONIC
	dbw 1, TACKLE
	dbw 1, THUNDERSHOCK
	dbw 6, THUNDERSHOCK
	dbw 11, SUPERSONIC
	dbw 16, SONICBOOM
	dbw 20, SPARK
	dbw 21, THUNDER_WAVE
	dbw 27, LOCK_ON
	dbw 35, TRI_ATTACK
	dbw 43, SCREECH
	dbw 52, LIGHT_SCREEN
	dbw 53, ZAP_CANNON
	db 0 ; no more level-up moves

FarfetchDEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, SIRFETCH_D
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 7, SAND_ATTACK
	dbw 10, FURY_CUTTER
	dbw 13, LEER
	dbw 15, CUT
	dbw 19, FURY_ATTACK
	dbw 25, SWORDS_DANCE
	dbw 31, AGILITY
	dbw 37, SLASH
	dbw 42, AIR_SLASH
	dbw 42, LEAF_BLADE
	dbw 44, FALSE_SWIPE
	db 0 ; no more level-up moves

DoduoEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, DODRIO
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, PECK
	dbw 5, QUICK_ATTACK
	dbw 9, PURSUIT
	dbw 13, FURY_ATTACK
	dbw 21, TRI_ATTACK
	dbw 25, RAGE
	dbw 33, DRILL_PECK
	dbw 33, SWORDS_DANCE
	dbw 37, AGILITY
	dbw 43, THRASH
	db 0 ; no more level-up moves

DodrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FURY_ATTACK
	dbw 1, GROWL
	dbw 1, PECK
	dbw 1, PURSUIT
	dbw 1, QUICK_ATTACK
	dbw 9, PURSUIT
	dbw 13, FURY_ATTACK
	dbw 21, TRI_ATTACK
	dbw 25, RAGE
	dbw 34, SWORDS_DANCE
	dbw 38, DRILL_PECK
	dbw 47, AGILITY
	dbw 50, THRASH
	db 0 ; no more level-up moves

SeelEvosAttacks:
	dbbw EVOLVE_LEVEL, 34, DEWGONG
	db 0 ; no more evolutions
	dbw 1, HEADBUTT
	dbw 5, GROWL
	dbw 7, CHARM
	dbw 11, ICY_WIND
	dbw 13, ENCORE
	dbw 16, AURORA_BEAM
	dbw 17, ICE_SHARD
	dbw 21, REST
	dbw 31, AQUA_JET
	dbw 32, TAKE_DOWN
	dbw 37, ICE_BEAM
	dbw 48, SAFEGUARD
	db 0 ; no more level-up moves

DewgongEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AURORA_BEAM
	dbw 1, GROWL
	dbw 1, HEADBUTT
	dbw 1, ICY_WIND
	dbw 5, GROWL
	dbw 13, ENCORE
	dbw 16, AURORA_BEAM
	dbw 17, ICE_SHARD
	dbw 21, REST
	dbw 31, AQUA_JET
	dbw 32, TAKE_DOWN
	dbw 43, ICE_BEAM
	dbw 60, SAFEGUARD
	db 0 ; no more level-up moves

GrimerEvosAttacks:
	dbbw EVOLVE_LEVEL, 38, MUK
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 5, HARDEN
	dbw 7, MUD_SLAP
	dbw 10, DISABLE
	dbw 16, SLUDGE
	dbw 23, MINIMIZE
	dbw 26, TOXIC
	dbw 31, SCREECH
	dbw 40, ACID_ARMOR
	dbw 42, SLUDGE_BOMB
	db 0 ; no more level-up moves

MukEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, MUD_SLAP
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 23, MINIMIZE
	dbw 26, TOXIC
	dbw 31, SCREECH
	dbw 33, HARDEN
	dbw 37, DISABLE
	dbw 42, SLUDGE_BOMB
	dbw 45, ACID_ARMOR
	dbw 45, SLUDGE
	db 0 ; no more level-up moves

ShellderEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, CLOYSTER
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, WATER_GUN
	dbw 1, WITHDRAW
	dbw 8, ICE_SHARD
	dbw 9, SUPERSONIC
	dbw 16, WHIRLPOOL
	dbw 17, AURORA_BEAM
	dbw 25, PROTECT
	dbw 33, LEER
	dbw 41, CLAMP
	dbw 43, ICE_BEAM
	dbw 48, HYDRO_PUMP
	db 0 ; no more level-up moves

CloysterEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ICE_SHARD
	dbw 1, WATER_GUN
	dbw 1, WITHDRAW
	dbw 16, WHIRLPOOL
	dbw 17, AURORA_BEAM
	dbw 23, SELFDESTRUCT
	dbw 25, PROTECT
	dbw 29, ROLLOUT
	dbw 33, SPIKES
	dbw 34, LIGHT_SCREEN
	dbw 40, SWIFT
	dbw 41, SPIKE_CANNON
	dbw 43, ICE_BEAM
	dbw 44, EXPLOSION
	dbw 48, MIRROR_COAT
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

GastlyEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, HAUNTER
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 8, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 28, CONFUSE_RAY
	dbw 32, SUCKER_PUNCH
	dbw 33, DREAM_EATER
	dbw 36, DARK_PULSE
	dbw 36, DESTINY_BOND
	dbw 40, SHADOW_BALL
	db 0 ; no more level-up moves

HaunterEvosAttacks:
	dbbw EVOLVE_TRADE, -1, GENGAR
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 1, SPITE
	dbw 8, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 31, CONFUSE_RAY
	dbw 36, SUCKER_PUNCH
	dbw 39, DREAM_EATER
	dbw 42, DARK_PULSE
	dbw 45, SHADOW_BALL
	dbw 48, DESTINY_BOND
	db 0 ; no more level-up moves

GengarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 1, PERISH_SONG
	dbw 1, SHADOW_PUNCH
	dbw 1, SPITE
	dbw 8, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 31, CONFUSE_RAY
	dbw 36, SUCKER_PUNCH
	dbw 39, DREAM_EATER
	dbw 42, DARK_PULSE
	dbw 45, SHADOW_BALL
	dbw 48, DESTINY_BOND
	db 0 ; no more level-up moves

OnixEvosAttacks:
	dbbw EVOLVE_TRADE, METAL_COAT, STEELIX
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, TACKLE
	dbw 10, BIND
	dbw 12, DRAGONBREATH
	dbw 14, ROCK_THROW
	dbw 16, CURSE
	dbw 20, ROCK_SLIDE
	dbw 23, HARDEN
	dbw 27, RAGE
	dbw 36, SANDSTORM
	dbw 40, SLAM
	dbw 44, DIG
	dbw 48, IRON_TAIL
	dbw 48, STONE_EDGE
	dbw 56, DOUBLE_EDGE
	db 0 ; no more level-up moves

DrowzeeEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, HYPNO
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, POUND
	dbw 10, DISABLE
	dbw 18, CONFUSION
	dbw 21, PSYBEAM
	dbw 25, HEADBUTT
	dbw 31, POISON_GAS
	dbw 33, SWAGGER
	dbw 36, MEDITATE
	dbw 40, PSYCHIC_M
	dbw 43, PSYCH_UP
	dbw 45, FUTURE_SIGHT
	db 0 ; no more level-up moves

HypnoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, DISABLE
	dbw 1, HYPNOSIS
	dbw 1, POUND
	dbw 10, DISABLE
	dbw 18, CONFUSION
	dbw 21, PSYBEAM
	dbw 25, HEADBUTT
	dbw 33, POISON_GAS
	dbw 37, SWAGGER
	dbw 40, MEDITATE
	dbw 48, PSYCHIC_M
	dbw 55, PSYCH_UP
	dbw 60, FUTURE_SIGHT
	db 0 ; no more level-up moves

KrabbyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, KINGLER
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, WATER_GUN
	dbw 5, LEER
	dbw 8, METAL_CLAW
	dbw 12, VICEGRIP
	dbw 16, HARDEN
	dbw 20, BUBBLEBEAM
	dbw 23, STOMP
	dbw 27, GUILLOTINE
	dbw 29, FLAIL
	dbw 34, PROTECT
	dbw 36, SLAM
	dbw 40, SWORDS_DANCE
	dbw 41, CRABHAMMER
	db 0 ; no more level-up moves

KinglerEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, LEER
	dbw 1, METAL_CLAW
	dbw 1, VICEGRIP
	dbw 1, WATER_GUN
	dbw 5, LEER
	dbw 12, VICEGRIP
	dbw 16, HARDEN
	dbw 20, BUBBLEBEAM
	dbw 23, STOMP
	dbw 27, GUILLOTINE
	dbw 31, FLAIL
	dbw 38, PROTECT
	dbw 42, SLAM
	dbw 48, SWORDS_DANCE
	dbw 49, CRABHAMMER
	db 0 ; no more level-up moves

VoltorbEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, ELECTRODE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, THUNDERSHOCK
	dbw 9, SCREECH
	dbw 9, SPARK
	dbw 17, SONICBOOM
	dbw 23, SELFDESTRUCT
	dbw 29, ROLLOUT
	dbw 33, LIGHT_SCREEN
	dbw 37, SWIFT
	dbw 39, EXPLOSION
	dbw 41, MIRROR_COAT
	db 0 ; no more level-up moves

ElectrodeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, SELFDESTRUCT
	dbw 1, SONICBOOM
	dbw 1, TACKLE
	dbw 1, THUNDERSHOCK
	dbw 9, SCREECH
	dbw 9, SPARK
	dbw 17, SONICBOOM
	dbw 23, SELFDESTRUCT
	dbw 29, ROLLOUT
	dbw 34, LIGHT_SCREEN
	dbw 40, SWIFT
	dbw 44, EXPLOSION
	dbw 48, MIRROR_COAT
	db 0 ; no more level-up moves

ExeggcuteEvosAttacks:
	dbbw EVOLVE_ITEM, LEAF_STONE, EXEGGUTOR
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, BARRAGE
	dbw 1, HYPNOSIS
	dbw 7, REFLECT
	dbw 13, LEECH_SEED
	dbw 15, MEGA_DRAIN
	dbw 19, CONFUSION
	dbw 25, STUN_SPORE
	dbw 25, SYNTHESIS
	dbw 31, POISONPOWDER
	dbw 35, GIGA_DRAIN
	dbw 37, SLEEP_POWDER
	dbw 43, SOLARBEAM
	db 0 ; no more level-up moves

ExeggutorEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BARRAGE
	dbw 1, CONFUSION
	dbw 1, HYPNOSIS
	dbw 13, LEECH_SEED
	dbw 19, STOMP
	dbw 25, SYNTHESIS
	dbw 31, EGG_BOMB
	dbw 35, GIGA_DRAIN
	dbw 43, SOLARBEAM
	dbw 48, PSYCHIC_M
	db 0 ; no more level-up moves

CuboneEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MAROWAK
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, MUD_SLAP
	dbw 5, TAIL_WHIP
	dbw 9, BONE_CLUB
	dbw 13, HEADBUTT
	dbw 17, LEER
	dbw 21, FOCUS_ENERGY
	dbw 25, BONEMERANG
	dbw 29, RAGE
	dbw 33, FALSE_SWIPE
	dbw 37, THRASH
	dbw 41, BONE_RUSH
	dbw 48, DOUBLE_EDGE
	db 0 ; no more level-up moves

MarowakEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BONE_CLUB
	dbw 1, GROWL
	dbw 1, HEADBUTT
	dbw 1, MUD_SLAP
	dbw 1, TAIL_WHIP
	dbw 5, TAIL_WHIP
	dbw 9, BONE_CLUB
	dbw 13, HEADBUTT
	dbw 17, LEER
	dbw 21, FOCUS_ENERGY
	dbw 25, BONEMERANG
	dbw 32, RAGE
	dbw 39, FALSE_SWIPE
	dbw 46, THRASH
	dbw 53, BONE_RUSH
	dbw 60, DOUBLE_EDGE
	db 0 ; no more level-up moves

HitmonleeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DOUBLE_KICK
	dbw 1, TACKLE
	dbw 6, MEDITATE
	dbw 8, LOW_KICK
	dbw 11, ROLLING_KICK
	dbw 16, JUMP_KICK
	dbw 16, SUCKER_PUNCH
	dbw 21, FOCUS_ENERGY
	dbw 26, HI_JUMP_KICK
	dbw 31, MIND_READER
	dbw 36, FORESIGHT
	dbw 41, ENDURE
	dbw 46, MEGA_KICK
	dbw 51, REVERSAL
	db 0 ; no more level-up moves

HitmonchanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 1, FOCUS_ENERGY
	dbw 1, TACKLE
	dbw 7, AGILITY
	dbw 13, PURSUIT
	dbw 16, BULLET_PUNCH
	dbw 26, FIRE_PUNCH
	dbw 26, ICE_PUNCH
	dbw 26, THUNDERPUNCH
	dbw 32, MACH_PUNCH
	dbw 38, MEGA_PUNCH
	dbw 44, DETECT
	dbw 50, COUNTER
	db 0 ; no more level-up moves

LickitungEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, LICKILICKY
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 6, ROLLOUT
	dbw 7, SUPERSONIC
	dbw 13, DEFENSE_CURL
	dbw 19, STOMP
	dbw 25, WRAP
	dbw 31, DISABLE
	dbw 37, SLAM
	dbw 43, SCREECH
	dbw 60, BELLY_DRUM
	db 0 ; no more level-up moves

KoffingEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, WEEZING
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, TACKLE
	dbw 9, SMOG
	dbw 17, SELFDESTRUCT
	dbw 21, SLUDGE
	dbw 25, SMOKESCREEN
	dbw 32, SLUDGE_BOMB
	dbw 33, HAZE
	dbw 36, TOXIC
	dbw 41, EXPLOSION
	dbw 45, DESTINY_BOND
	db 0 ; no more level-up moves

WeezingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, SELFDESTRUCT
	dbw 1, SMOG
	dbw 1, TACKLE
	dbw 9, SMOG
	dbw 17, SELFDESTRUCT
	dbw 21, SLUDGE
	dbw 25, SMOKESCREEN
	dbw 32, SLUDGE_BOMB
	dbw 33, HAZE
	dbw 38, TOXIC
	dbw 44, EXPLOSION
	dbw 51, DESTINY_BOND
	db 0 ; no more level-up moves

RhyhornEvosAttacks:
	dbbw EVOLVE_LEVEL, 42, RHYDON
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 13, STOMP
	dbw 19, FURY_ATTACK
	dbw 31, SCARY_FACE
	dbw 37, HORN_DRILL
	dbw 48, STONE_EDGE
	dbw 49, TAKE_DOWN
	dbw 50, EARTHQUAKE
	dbw 55, MEGAHORN
	db 0 ; no more level-up moves

RhydonEvosAttacks:
	dbbw EVOLVE_TRADE, METAL_COAT, RHYPERIOR
	db 0 ; no more evolutions
	dbw 1, FURY_ATTACK
	dbw 1, HORN_ATTACK
	dbw 1, STOMP
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 13, STOMP
	dbw 19, FURY_ATTACK
	dbw 31, SCARY_FACE
	dbw 37, HORN_DRILL
	dbw 48, STONE_EDGE
	dbw 50, EARTHQUAKE
	dbw 54, TAKE_DOWN
	dbw 61, MEGAHORN
	db 0 ; no more level-up moves

ChanseyEvosAttacks:
	dbbw EVOLVE_HAPPINESS, TR_ANYTIME, BLISSEY
	db 0 ; no more evolutions
	dbw 1, CHARM
	dbw 1, DISARMING_VOICE
	dbw 1, POUND
	dbw 1, SWEET_KISS
	dbw 5, GROWL
	dbw 9, TAIL_WHIP
	dbw 13, SOFTBOILED
	dbw 17, DOUBLESLAP
	dbw 23, MINIMIZE
	dbw 24, TAKE_DOWN
	dbw 29, SING
	dbw 35, EGG_BOMB
	dbw 41, DEFENSE_CURL
	dbw 49, LIGHT_SCREEN
	dbw 57, DOUBLE_EDGE
	db 0 ; no more level-up moves

TangelaEvosAttacks:
	dbbw EVOLVE_LEVEL, 45, TANGROWTH
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 4, SLEEP_POWDER
	dbw 10, ABSORB
	dbw 13, POISONPOWDER
	dbw 19, VINE_WHIP
	dbw 24, ANCIENTPOWER
	dbw 25, BIND
	dbw 31, MEGA_DRAIN
	dbw 32, GIGA_DRAIN
	dbw 34, STUN_SPORE
	dbw 40, SLAM
	dbw 46, GROWTH
	db 0 ; no more level-up moves

KangaskhanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 1, POUND
	dbw 4, GROWL
	dbw 7, LEER
	dbw 13, BITE
	dbw 16, STOMP
	dbw 19, TAIL_WHIP
	dbw 20, FOCUS_ENERGY
	dbw 24, HEADBUTT
	dbw 25, MEGA_PUNCH
	dbw 28, SUCKER_PUNCH
	dbw 31, RAGE
	dbw 36, CRUNCH
	dbw 37, ENDURE
	dbw 43, DIZZY_PUNCH
	dbw 48, OUTRAGE
	dbw 49, REVERSAL
	db 0 ; no more level-up moves

HorseaEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, SEADRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 8, SMOKESCREEN
	dbw 15, FOCUS_ENERGY
	dbw 15, LEER
	dbw 20, DRAGONBREATH
	dbw 22, WATER_GUN
	dbw 25, BUBBLEBEAM
	dbw 29, TWISTER
	dbw 36, AGILITY
	dbw 43, HYDRO_PUMP
	dbw 55, RAIN_DANCE
	db 0 ; no more level-up moves

SeadraEvosAttacks:
	dbbw EVOLVE_TRADE, DRAGON_SCALE, KINGDRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, LEER
	dbw 1, SMOKESCREEN
	dbw 1, WATER_GUN
	dbw 8, SMOKESCREEN
	dbw 15, FOCUS_ENERGY
	dbw 15, LEER
	dbw 20, DRAGONBREATH
	dbw 22, WATER_GUN
	dbw 25, BUBBLEBEAM
	dbw 29, TWISTER
	dbw 40, AGILITY
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
	dbw 1, TAIL_WHIP
	dbw 10, SUPERSONIC
	dbw 15, HORN_ATTACK
	dbw 24, FLAIL
	dbw 29, FURY_ATTACK
	dbw 38, WATERFALL
	dbw 43, HORN_DRILL
	dbw 45, MEGAHORN
	dbw 52, AGILITY
	db 0 ; no more level-up moves

SeakingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, TAIL_WHIP
	dbw 1, TAIL_WHIP
	dbw 10, SUPERSONIC
	dbw 15, HORN_ATTACK
	dbw 24, FLAIL
	dbw 29, FURY_ATTACK
	dbw 41, WATERFALL
	dbw 49, HORN_DRILL
	dbw 51, MEGAHORN
	dbw 61, AGILITY
	db 0 ; no more level-up moves

StaryuEvosAttacks:
	dbbw EVOLVE_ITEM, WATER_STONE, STARMIE
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, TACKLE
	dbw 7, WATER_GUN
	dbw 8, CONFUSE_RAY
	dbw 13, RAPID_SPIN
	dbw 19, RECOVER
	dbw 24, PSYBEAM
	dbw 25, SWIFT
	dbw 31, BUBBLEBEAM
	dbw 37, MINIMIZE
	dbw 40, PSYCHIC_M
	dbw 42, SURF
	dbw 43, LIGHT_SCREEN
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

StarmieEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, RAPID_SPIN
	dbw 1, TACKLE
	dbw 1, WATER_GUN
	dbw 19, RECOVER
	dbw 24, PSYBEAM
	dbw 25, SWIFT
	dbw 31, BUBBLEBEAM
	dbw 37, CONFUSE_RAY
	dbw 40, PSYCHIC_M
	dbw 42, SURF
	dbw 43, LIGHT_SCREEN
	dbw 50, HYDRO_PUMP
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
	dbw 1, POUND
	dbw 6, CONFUSION
	dbw 11, SUBSTITUTE
	dbw 16, MEDITATE
	dbw 20, PROTECT
	dbw 21, DOUBLESLAP
	dbw 26, LIGHT_SCREEN
	dbw 26, REFLECT
	dbw 31, ENCORE
	dbw 32, MIMIC
	dbw 36, PSYBEAM
	dbw 40, SUCKER_PUNCH
	dbw 41, BATON_PASS
	dbw 44, DAZZLING_GLEAM
	dbw 46, SAFEGUARD
	dbw 48, PSYCHIC_M
	db 0 ; no more level-up moves

ScytherEvosAttacks:
	dbbw EVOLVE_TRADE, METAL_COAT, SCIZOR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, QUICK_ATTACK
	dbw 4, FURY_CUTTER
	dbw 6, FOCUS_ENERGY
	dbw 12, PURSUIT
	dbw 18, FALSE_SWIPE
	dbw 24, AGILITY
	dbw 30, WING_ATTACK
	dbw 36, AIR_SLASH
	dbw 36, SLASH
	dbw 40, X_SCISSOR
	dbw 42, SWORDS_DANCE
	dbw 48, DOUBLE_TEAM
	db 0 ; no more level-up moves

JynxEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 1, LOVELY_KISS
	dbw 1, POUND
	dbw 1, POWDER_SNOW
	dbw 1, SWEET_KISS
	dbw 9, LOVELY_KISS
	dbw 12, CONFUSION
	dbw 13, POWDER_SNOW
	dbw 20, SING
	dbw 21, DOUBLESLAP
	dbw 25, ICE_PUNCH
	dbw 34, PSYCHIC_M
	dbw 35, MEAN_LOOK
	dbw 41, BODY_SLAM
	dbw 51, PERISH_SONG
	dbw 55, BLIZZARD
	db 0 ; no more level-up moves

ElectabuzzEvosAttacks:
	dbbw EVOLVE_ITEM, THUNDERSTONE, ELECTIVIRE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, QUICK_ATTACK
	dbw 1, THUNDERPUNCH
	dbw 1, THUNDERSHOCK
	dbw 9, THUNDERPUNCH
	dbw 17, LIGHT_SCREEN
	dbw 20, THUNDER_WAVE
	dbw 25, SWIFT
	dbw 36, SCREECH
	dbw 40, LOW_KICK
	dbw 42, THUNDERBOLT
	dbw 55, THUNDER
	db 0 ; no more level-up moves

MagmarEvosAttacks:
	dbbw EVOLVE_ITEM, FIRE_STONE, MAGMORTAR
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, FIRE_PUNCH
	dbw 1, LEER
	dbw 1, SMOG
	dbw 7, LEER
	dbw 13, SMOG
	dbw 16, FLAME_WHEEL
	dbw 19, FIRE_PUNCH
	dbw 24, SCARY_FACE
	dbw 25, SMOKESCREEN
	dbw 33, SUNNY_DAY
	dbw 40, LOW_KICK
	dbw 41, FLAMETHROWER
	dbw 49, CONFUSE_RAY
	dbw 55, FIRE_BLAST
	dbw 64, HYPER_BEAM
	db 0 ; no more level-up moves

PinsirEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, VICEGRIP
	dbw 7, FOCUS_ENERGY
	dbw 13, BIND
	dbw 16, BUG_BITE
	dbw 19, SEISMIC_TOSS
	dbw 25, HARDEN
	dbw 28, VITAL_THROW
	dbw 31, GUILLOTINE
	dbw 32, X_SCISSOR
	dbw 36, STRENGTH
	dbw 37, SUBMISSION
	dbw 43, SWORDS_DANCE
	db 0 ; no more level-up moves

TaurosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, TAIL_WHIP
	dbw 8, RAGE
	dbw 13, HORN_ATTACK
	dbw 19, SCARY_FACE
	dbw 26, PURSUIT
	dbw 34, REST
	dbw 43, THRASH
	dbw 45, SWAGGER
	dbw 53, TAKE_DOWN
	dbw 55, DOUBLE_EDGE
	db 0 ; no more level-up moves

MagikarpEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, GYARADOS
	db 0 ; no more evolutions
	dbw 1, SPLASH
	dbw 15, TACKLE
	dbw 30, FLAIL
	db 0 ; no more level-up moves

GyaradosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FLAIL
	dbw 1, SPLASH
	dbw 1, TACKLE
	dbw 1, THRASH
	dbw 4, WHIRLPOOL
	dbw 8, ICE_FANG
	dbw 16, SCARY_FACE
	dbw 20, BITE
	dbw 21, WATERFALL
	dbw 24, CRUNCH
	dbw 25, DRAGON_RAGE
	dbw 30, LEER
	dbw 35, TWISTER
	dbw 40, HYDRO_PUMP
	dbw 45, RAIN_DANCE
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

LaprasEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, SING
	dbw 1, WATER_GUN
	dbw 8, MIST
	dbw 15, BODY_SLAM
	dbw 20, ICE_SHARD
	dbw 22, CONFUSE_RAY
	dbw 29, PERISH_SONG
	dbw 36, ICE_BEAM
	dbw 43, RAIN_DANCE
	dbw 50, SAFEGUARD
	dbw 55, HYDRO_PUMP
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
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 16, GROWL
	dbw 20, SWIFT
	dbw 23, QUICK_ATTACK
	dbw 30, BITE
	dbw 36, BATON_PASS
	dbw 42, TAKE_DOWN
	dbw 45, CHARM
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

VaporeonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BATON_PASS
	dbw 1, CHARM
	dbw 1, DOUBLE_EDGE
	dbw 1, GROWL
	dbw 1, SWIFT
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, TAKE_DOWN
	dbw 8, SAND_ATTACK
	dbw 16, WATER_GUN
	dbw 23, QUICK_ATTACK
	dbw 30, BITE
	dbw 36, AURORA_BEAM
	dbw 42, HAZE
	dbw 47, ACID_ARMOR
	dbw 52, HYDRO_PUMP
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
	dbw 8, SAND_ATTACK
	dbw 16, THUNDERSHOCK
	dbw 23, QUICK_ATTACK
	dbw 30, DOUBLE_KICK
	dbw 30, THUNDER_FANG
	dbw 36, PIN_MISSILE
	dbw 42, THUNDER_WAVE
	dbw 47, AGILITY
	dbw 52, THUNDER
	db 0 ; no more level-up moves

FlareonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BATON_PASS
	dbw 1, CHARM
	dbw 1, DOUBLE_EDGE
	dbw 1, GROWL
	dbw 1, SWIFT
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, TAKE_DOWN
	dbw 8, SAND_ATTACK
	dbw 16, EMBER
	dbw 23, QUICK_ATTACK
	dbw 30, BITE
	dbw 30, FIRE_FANG
	dbw 36, FIRE_SPIN
	dbw 42, SMOG
	dbw 45, SCARY_FACE
	dbw 45, FLAMETHROWER
	dbw 47, LEER
	db 0 ; no more level-up moves

PorygonEvosAttacks:
	dbbw EVOLVE_TRADE, UP_GRADE, PORYGON2
	db 0 ; no more evolutions
	dbw 1, CONVERSION
	dbw 1, CONVERSION2
	dbw 1, TACKLE
	dbw 9, AGILITY
	dbw 12, PSYBEAM
	dbw 15, THUNDERSHOCK
	dbw 20, RECOVER
	dbw 24, SHARPEN
	dbw 32, LOCK_ON
	dbw 36, TRI_ATTACK
	dbw 44, ZAP_CANNON
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

OmanyteEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, OMASTAR
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, CONSTRICT
	dbw 1, WITHDRAW
	dbw 5, ROLLOUT
	dbw 10, SAND_ATTACK
	dbw 13, BITE
	dbw 19, WATER_GUN
	dbw 31, LEER
	dbw 37, PROTECT
	dbw 42, SURF
	dbw 49, ANCIENTPOWER
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

OmastarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BIND
	dbw 1, BITE
	dbw 1, CONSTRICT
	dbw 1, CRUNCH
	dbw 1, ROLLOUT
	dbw 1, SAND_ATTACK
	dbw 1, WITHDRAW
	dbw 13, BITE
	dbw 19, WATER_GUN
	dbw 31, LEER
	dbw 37, PROTECT
	dbw 40, SPIKE_CANNON
	dbw 42, SURF
	dbw 54, ANCIENTPOWER
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

KabutoEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, KABUTOPS
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, SCRATCH
	dbw 10, ABSORB
	dbw 15, AQUA_JET
	dbw 19, LEER
	dbw 28, SAND_ATTACK
	dbw 37, ENDURE
	dbw 41, PROTECT
	dbw 45, LEECH_LIFE
	dbw 46, MEGA_DRAIN
	dbw 48, STONE_EDGE
	dbw 55, ANCIENTPOWER
	db 0 ; no more level-up moves

KabutopsEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, HARDEN
	dbw 1, SCRATCH
	dbw 10, ABSORB
	dbw 15, AQUA_JET
	dbw 19, LEER
	dbw 28, SAND_ATTACK
	dbw 37, ENDURE
	dbw 40, SLASH
	dbw 43, PROTECT
	dbw 48, STONE_EDGE
	dbw 49, LEECH_LIFE
	dbw 51, MEGA_DRAIN
	dbw 65, ANCIENTPOWER
	db 0 ; no more level-up moves

AerodactylEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WING_ATTACK
	dbw 8, AGILITY
	dbw 15, BITE
	dbw 20, ROCK_SLIDE
	dbw 22, SUPERSONIC
	dbw 25, ROAR
	dbw 29, ANCIENTPOWER
	dbw 30, CRUNCH
	dbw 36, SCARY_FACE
	dbw 43, TAKE_DOWN
	dbw 45, STONE_EDGE
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

SnorlaxEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FLAIL
	dbw 1, LICK
	dbw 1, METRONOME
	dbw 1, SCREECH
	dbw 1, TACKLE
	dbw 8, AMNESIA
	dbw 15, DEFENSE_CURL
	dbw 16, BITE
	dbw 20, SLEEP_TALK
	dbw 22, BELLY_DRUM
	dbw 24, CRUNCH
	dbw 29, HEADBUTT
	dbw 36, REST
	dbw 36, SNORE
	dbw 43, BODY_SLAM
	dbw 50, ROLLOUT
	dbw 57, HYPER_BEAM
	db 0 ; no more level-up moves

ArticunoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, POWDER_SNOW
	dbw 13, MIST
	dbw 15, ICE_SHARD
	dbw 25, AGILITY
	dbw 25, ANCIENTPOWER
	dbw 37, MIND_READER
	dbw 43, ICE_BEAM
	dbw 55, BLIZZARD
	dbw 60, HAZE
	dbw 61, REFLECT
	db 0 ; no more level-up moves

ZapdosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, THUNDERSHOCK
	dbw 13, THUNDER_WAVE
	dbw 25, AGILITY
	dbw 25, ANCIENTPOWER
	dbw 37, DETECT
	dbw 49, DRILL_PECK
	dbw 50, RAIN_DANCE
	dbw 55, THUNDER
	dbw 61, LIGHT_SCREEN
	dbw 70, ZAP_CANNON
	db 0 ; no more level-up moves

MoltresEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, GUST
	dbw 1, LEER
	dbw 1, WING_ATTACK
	dbw 13, FIRE_SPIN
	dbw 25, AGILITY
	dbw 25, ANCIENTPOWER
	dbw 35, AIR_SLASH
	dbw 37, ENDURE
	dbw 45, FLAMETHROWER
	dbw 50, SUNNY_DAY
	dbw 61, SAFEGUARD
	dbw 73, SKY_ATTACK
	db 0 ; no more level-up moves

DratiniEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, DRAGONAIR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, WRAP
	dbw 8, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 36, AGILITY
	dbw 43, SAFEGUARD
	dbw 45, RAIN_DANCE
	dbw 50, OUTRAGE
	dbw 57, HYPER_BEAM
	db 0 ; no more level-up moves

DragonairEvosAttacks:
	dbbw EVOLVE_LEVEL, 55, DRAGONITE
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, THUNDER_WAVE
	dbw 1, TWISTER
	dbw 1, WRAP
	dbw 8, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 38, AGILITY
	dbw 47, SAFEGUARD
	dbw 53, RAIN_DANCE
	dbw 56, OUTRAGE
	dbw 65, HYPER_BEAM
	db 0 ; no more level-up moves

DragoniteEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EXTREMESPEED
	dbw 1, FIRE_PUNCH
	dbw 1, LEER
	dbw 1, THUNDER_WAVE
	dbw 1, TWISTER
	dbw 1, WRAP
	dbw 8, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 38, AGILITY
	dbw 47, SAFEGUARD
	dbw 53, RAIN_DANCE
	dbw 55, WING_ATTACK
	dbw 61, OUTRAGE
	dbw 75, HYPER_BEAM
	db 0 ; no more level-up moves

MewtwoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, DISABLE
	dbw 8, ANCIENTPOWER
	dbw 11, BARRIER
	dbw 22, SWIFT
	dbw 33, PSYCH_UP
	dbw 44, FUTURE_SIGHT
	dbw 48, PSYCHIC_M
	dbw 55, MIST
	dbw 77, AMNESIA
	dbw 88, RECOVER
	dbw 99, SAFEGUARD
	db 0 ; no more level-up moves

MewEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 10, AMNESIA
	dbw 10, TRANSFORM
	dbw 20, BATON_PASS
	dbw 20, MEGA_PUNCH
	dbw 30, METRONOME
	dbw 40, PSYCHIC_M
	dbw 50, ANCIENTPOWER
	db 0 ; no more level-up moves
