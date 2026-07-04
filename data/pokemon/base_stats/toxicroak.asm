	db 0 ; species ID placeholder

	db  83, 106,  65,  85,  86,  65
	;  hp  atk  def  spd  sat  sdf

	db POISON, FIGHTING ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/toxicroak/front.dimensions"
	abilities_for TOXICROAK, DRY_SKIN, ANTICIPATION, POISON_TOUCH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, DYNAMICPUNCH, ROCK_SMASH, STRENGTH
	; end
