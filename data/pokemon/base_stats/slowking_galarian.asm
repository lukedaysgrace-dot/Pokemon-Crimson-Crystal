	db 0 ; species ID placeholder

	db  95,  65,  80,  30, 110, 110
	;  hp  atk  def  spd  sat  sdf

	db POISON, PSYCHIC ; type
	db 70 ; catch rate
	db 164 ; base exp
	db NO_ITEM, KINGS_ROCK ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/slowking_galarian/front.dimensions"
	abilities_for SLOWKING_GALARIAN, OWN_TEMPO, NO_ABILITY, REGENERATOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MONSTER, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_TAIL, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, SLUDGE_BOMB, FIRE_BLAST, SWIFT, REST, ATTRACT, FLASH, SURF, STRENGTH, WHIRLPOOL, WATERFALL, DREAM_EATER, ENDURE, HEADBUTT, ICE_PUNCH, ICY_WIND, SLEEP_TALK, SWAGGER, ZAP_CANNON
	; end
