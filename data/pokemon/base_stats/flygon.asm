	db 0 ; species ID placeholder

	db  90, 115,  85, 110, 115,  85
	;  hp  atk  def  spd  sat  sdf

	db BUG, DRAGON ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/flygon/front.dimensions"
	abilities_for FLYGON, COMPOUND_EYES, OVERCOAT, TINTED_LENS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_BUG, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, PROTECT, FACADE, DRAGON_CLAW, EARTHQUAKE, RETURN, DIG, SWAGGER, SANDSTORM, DRAGON_DANCE, REST, ATTRACT, HONE_CLAWS, STRENGTH
	; end
