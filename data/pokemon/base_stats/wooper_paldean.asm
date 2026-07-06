	db 0 ; species ID placeholder

	db  55,  45,  45,  15,  25,  25
	;  hp  atk  def  spd  sat  sdf

	db POISON, GROUND ; type
	db 255 ; catch rate
	db 52 ; base exp
	db NO_ITEM, MINT_BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/wooper_paldean/front.dimensions"
	abilities_for WOOPER_PALDEAN, POISON_POINT, WATER_ABSORB, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, ICE_BEAM, BLIZZARD, PROTECT, IRON_TAIL, EARTHQUAKE, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, SLUDGE_BOMB, SANDSTORM, REST, ATTRACT, FLASH, SURF, DEFENSE_CURL, ENDURE, HEADBUTT, ICE_PUNCH, ICY_WIND, ROLLOUT, SLEEP_TALK, SWAGGER
	; end
