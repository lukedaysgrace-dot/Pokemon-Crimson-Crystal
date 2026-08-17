	db 0 ; species ID placeholder

	db  48,  61,  40,  50,  61,  40
	;  hp  atk  def  spd  sat  sdf

	db POISON, FIGHTING ; type
	db 140 ; catch rate
	db 60 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/croagunk/front.dimensions"
	abilities_for CROAGUNK, ANTICIPATION, DRY_SKIN, POISON_TOUCH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, WORK_UP, PROTECT, FACADE, RETURN, SWAGGER, KNOCK_OFF, BULK_UP, NASTY_PLOT, REST, ATTRACT, STRENGTH
	; end
