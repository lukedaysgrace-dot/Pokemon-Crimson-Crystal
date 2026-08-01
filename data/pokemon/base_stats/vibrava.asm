	db 0 ; species ID placeholder

	db  60,  85,  55,  70,  85,  55
	;  hp  atk  def  spd  sat  sdf

	db BUG, DRAGON ; type
	db 120 ; catch rate
	db 119 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/vibrava/front.dimensions"
	abilities_for VIBRAVA, COMPOUND_EYES, OVERCOAT, TINTED_LENS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_BUG, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, EARTHQUAKE, DIG, SANDSTORM, ROCK_SMASH, STRENGTH
	; end
