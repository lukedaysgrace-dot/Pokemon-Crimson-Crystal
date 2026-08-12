	db 0 ; species ID placeholder

	db 100,   5,   5,  30,  15,  65
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 130 ; catch rate
	db 255 ; base exp
	db HARD_STONE, LUCKY_EGG ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/happiny/front.dimensions"
	abilities_for HAPPINY, NATURAL_CURE, SERENE_GRACE, NATURAL_CURE
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, ROLLOUT, TOXIC, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, ICY_WIND, PROTECT, RAIN_DANCE, ENDURE, SOLARBEAM, RETURN, PSYCHIC_M, SHADOW_BALL, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, FIRE_BLAST, DEFENSE_CURL, DREAM_EATER, REST, ATTRACT, FLASH, FLAMETHROWER, ICE_BEAM
	; end
