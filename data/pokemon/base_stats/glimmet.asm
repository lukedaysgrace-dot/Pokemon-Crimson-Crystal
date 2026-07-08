	db 0 ; species ID placeholder

	db  48,  35,  42,  60, 105,  60
	;   hp  atk  def  spd  sat  sdf

	db ROCK, POISON ; type
	db 70 ; catch rate
	db 70 ; base exp
	db NO_ITEM, POISON_BARB ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/glimmet/front.dimensions"
	abilities_for GLIMMET, POISON_POINT, NO_ABILITY, MERCILESS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm TOXIC, ROCK_SMASH, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SANDSTORM, SLUDGE_BOMB, REST, ATTRACT
	; end
