	db 0 ; species ID placeholder

	db  55, 100,  45,  10,  45,  45
	;  hp  atk  def  spd  sat  sdf

	db BUG, GROUND ; type
	db 255 ; catch rate
	db 58 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/trapinch/front.dimensions"
	abilities_for TRAPINCH, HYPER_CUTTER, ARENA_TRAP, SHEER_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_BUG, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, SWAGGER, SANDSTORM, REST, ATTRACT, STRENGTH
	; end
