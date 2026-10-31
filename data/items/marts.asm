Marts:
; entries correspond to MART_* constants
	dw MartCherrygrove
	dw MartCherrygroveDex
	dw MartViolet
	dw MartAzalea
	dw MartCianwood
	dw MartGoldenrod2F1
	dw MartGoldenrod2F2
	dw MartGoldenrod3F
	dw MartGoldenrod4F
	dw MartGoldenrod5F1
	dw MartGoldenrod5F2
	dw MartGoldenrod5F3
	dw MartGoldenrod5F4
	dw MartOlivine
	dw MartEcruteak
	dw MartMahogany1
	dw MartMahogany2
	dw MartBlackthorn
	dw MartViridian
	dw MartPewter
	dw MartCerulean
	dw MartLavender
	dw MartVermilion
	dw MartCeladon2F1
	dw MartCeladon2F2
	dw MartCeladon3F
	dw MartCeladon4F
	dw MartCeladon5F1
	dw MartCeladon5F2
	dw MartFuchsia
	dw MartSaffron
	dw MartMtMoon
	dw MartIndigoPlateau
	dw MartUnderground
	dw MartMahoganyHeldItems
	dw MartExpanded0
	dw MartExpanded1
	dw MartExpanded2
	dw MartExpanded3
	dw MartBattleItems0
	dw MartBattleItems1
	dw MartBattleItems2

.End

MartCherrygrove:
	db 4 ; # items
	dw POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw -1 ; end

MartCherrygroveDex:
	db 5 ; # items
	dw POKE_BALL
	dw POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw -1 ; end

MartViolet:
	db 10 ; # items
	dw POKE_BALL
	dw POTION
	dw ESCAPE_ROPE
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw X_DEFEND
	dw X_ATTACK
	dw X_SPEED
	dw FLOWER_MAIL
	dw -1 ; end

MartAzalea:
	db 9 ; # items
	dw CHARCOAL
	dw POKE_BALL
	dw POTION
	dw SUPER_POTION
	dw ESCAPE_ROPE
	dw REPEL
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw FLOWER_MAIL
	dw -1 ; end

MartCianwood:
	db 5 ; # items
	dw POTION
	dw SUPER_POTION
	dw HYPER_POTION
	dw FULL_HEAL
	dw REVIVE
	dw -1 ; end

MartGoldenrod2F1:
	db 7 ; # items
	dw POTION
	dw SUPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL
	dw -1 ; end

MartGoldenrod2F2:
	db 8 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ESCAPE_ROPE
	dw REPEL
	dw REVIVE
	dw FULL_HEAL
	dw POKE_DOLL
	dw FLOWER_MAIL
	dw -1 ; end

MartGoldenrod3F:
	db 7 ; # items
	dw X_SPEED
	dw X_SPECIAL
	dw X_DEFEND
	dw X_ATTACK
	dw DIRE_HIT
	dw GUARD_SPEC
	dw X_ACCURACY
	dw -1 ; end

MartGoldenrod4F:
	db 6 ; # items
	dw PROTEIN
	dw IRON
	dw CARBOS
	dw CALCIUM
	dw HP_UP
	dw DUSK_STONE
	dw -1 ; end

MartGoldenrod5F1:
	db 3 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw -1 ; end

MartGoldenrod5F2:
	db 4 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_HEADBUTT
	dw -1 ; end

MartGoldenrod5F3:
	db 4 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_ROCK_SMASH
	dw -1 ; end

MartGoldenrod5F4:
	db 5 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_HEADBUTT
	dw TM_ROCK_SMASH
	dw -1 ; end

MartOlivine:
	db 8 ; # items
	dw GREAT_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw ICE_HEAL
	dw SUPER_REPEL
	dw -1 ; end

MartEcruteak:
	db 10 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw POTION
	dw SUPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL
	dw REVIVE
	dw -1 ; end

MartMahogany1:
	db 3 ; # items
	dw SLOWPOKETAIL
	dw POKE_BALL
	dw POTION
	dw -1 ; end

MartMahogany2:
	db 9 ; # items
	dw RAGECANDYBAR
	dw GREAT_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw SUPER_REPEL
	dw REVIVE
	dw FLOWER_MAIL
	dw -1 ; end

MartBlackthorn:
	db 9 ; # items
	dw GREAT_BALL
	dw ULTRA_BALL
	dw HYPER_POTION
	dw MAX_POTION
	dw FULL_HEAL
	dw REVIVE
	dw MAX_REPEL
	dw X_DEFEND
	dw X_ATTACK
	dw -1 ; end

MartViridian:
	db 9 ; # items
	dw ULTRA_BALL
	dw HYPER_POTION
	dw FULL_HEAL
	dw REVIVE
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw FLOWER_MAIL
	dw -1 ; end

MartPewter:
	db 7 ; # items
	dw GREAT_BALL
	dw SUPER_POTION
	dw SUPER_REPEL
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw -1 ; end

MartCerulean:
	db 8 ; # items
	dw GREAT_BALL
	dw ULTRA_BALL
	dw SUPER_POTION
	dw SUPER_REPEL
	dw FULL_HEAL
	dw X_DEFEND
	dw X_ATTACK
	dw DIRE_HIT
	dw -1 ; end

MartLavender:
	db 8 ; # items
	dw GREAT_BALL
	dw POTION
	dw SUPER_POTION
	dw MAX_REPEL
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw -1 ; end

MartVermilion:
	db 7 ; # items
	dw ULTRA_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw REVIVE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw -1 ; end

MartCeladon2F1:
	db 7 ; # items
	dw POTION
	dw SUPER_POTION
	dw HYPER_POTION
	dw MAX_POTION
	dw REVIVE
	dw SUPER_REPEL
	dw MAX_REPEL
	dw -1 ; end

MartCeladon2F2:
	db 10 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ULTRA_BALL
	dw ESCAPE_ROPE
	dw FULL_HEAL
	dw ANTIDOTE
	dw BURN_HEAL
	dw ICE_HEAL
	dw AWAKENING
	dw PARLYZ_HEAL
	dw -1 ; end

MartCeladon3F:
	db 5 ; # items
	dw TM_HIDDEN_POWER
	dw TM_SUNNY_DAY
	dw TM_PROTECT
	dw TM_RAIN_DANCE
	dw TM_SANDSTORM
	dw -1 ; end

MartCeladon4F:
	db 1 ; # items
	dw POKE_DOLL
	dw -1 ; end

MartCeladon5F1:
	db 5 ; # items
	dw HP_UP
	dw PROTEIN
	dw IRON
	dw CARBOS
	dw CALCIUM
	dw -1 ; end

MartCeladon5F2:
	db 7 ; # items
	dw X_ACCURACY
	dw GUARD_SPEC
	dw DIRE_HIT
	dw X_ATTACK
	dw X_DEFEND
	dw X_SPEED
	dw X_SPECIAL
	dw -1 ; end

MartFuchsia:
	db 7 ; # items
	dw GREAT_BALL
	dw ULTRA_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw FULL_HEAL
	dw MAX_REPEL
	dw FLOWER_MAIL
	dw -1 ; end

MartSaffron:
	db 8 ; # items
	dw GREAT_BALL
	dw ULTRA_BALL
	dw HYPER_POTION
	dw MAX_POTION
	dw FULL_HEAL
	dw X_ATTACK
	dw X_DEFEND
	dw FLOWER_MAIL
	dw -1 ; end

MartMtMoon:
	db 5 ; # items
	dw POKE_DOLL
	dw FRESH_WATER
	dw SODA_POP
	dw LEMONADE
	dw REPEL
	dw -1 ; end

MartIndigoPlateau:
	db 7 ; # items
	dw ULTRA_BALL
	dw MAX_REPEL
	dw HYPER_POTION
	dw MAX_POTION
	dw FULL_RESTORE
	dw REVIVE
	dw FULL_HEAL
	dw -1 ; end

MartUnderground:
	db 4 ; # items
	dw ENERGYPOWDER
	dw ENERGY_ROOT
	dw HEAL_POWDER
	dw REVIVAL_HERB
	dw -1 ; end

MartMahoganyHeldItems:
	db 12 ; # items
	dw EVIOLITE
	dw ROCKY_HELMET
	dw AIR_BALLOON
	dw MUSCLE_BAND
	dw WISE_GLASSES
	dw EXPERT_BELT
	dw FLAME_ORB
	dw TOXIC_ORB
	dw ASSAULT_VEST
	dw LIFE_ORB
	dw WIDE_LENS
	dw BRIGHTPOWDER
	dw -1 ; end

DefaultMart:
	db 2 ; # items
	dw POKE_BALL
	dw POTION
	dw -1 ; end

MartExpanded0:
	db 7
	dw TINYMUSHROOM
	dw BIG_MUSHROOM
	dw BIG_PEARL
	dw POLKADOT_BOW
	dw SURF_MAIL
	dw LITEBLUEMAIL
	dw PORTRAITMAIL
	dw -1

MartExpanded1:
	db 7
	dw LOVELY_MAIL
	dw MORPH_MAIL
	dw BLUESKY_MAIL
	dw MUSIC_MAIL
	dw MIRAGE_MAIL
	dw SILVER_LEAF
	dw GOLD_LEAF
	dw -1

MartExpanded2:
	db 2
	dw NORMAL_BOX
	dw GORGEOUS_BOX
	dw -1

MartExpanded3:
	db 5
	dw RARE_BONE
	dw BALM_MUSHROOM
	dw COMET_SHARD
	dw BIG_NUGGET
	dw PEARL_STRING
	dw -1

MartBattleItems0:
	db 7
	dw COVERT_CLOAK
	dw CLEAR_AMULET
	dw METRONOME_ITEM
	dw HEAVY_DUTY_BOOTS
	dw RED_CARD
	dw EJECT_BUTTON
	dw POWER_HERB
	dw -1

MartBattleItems1:
	db 7
	dw WHITE_HERB
	dw BLACK_SLUDGE
	dw LIGHT_CLAY
	dw THROAT_SPRAY
	dw PUNCHING_GLOVE
	dw QUICK_POWDER
	dw SAFETY_GOGGLES
	dw -1

MartBattleItems2:
	db 5
	dw BIG_ROOT
	dw BLUNDER_POLICY
	dw GOLD_BERRY
	dw CUSTAP_BERRY
	dw SALAC_BERRY
	dw -1
