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
	abilities_for HAPPINY, SERENE_GRACE, NATURAL_CURE, NO_ABILITY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, ROCK_TOMB, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, SOLARBEAM, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, FIRE_BLAST, REST, ATTRACT, ZEN_HEADBUTT, FLASH, FLAMETHROWER, ICE_BEAM
	; end
