	db 0 ; species ID placeholder

	db  45,  85,  70,  60,  40,  40
	;  hp  atk  def  spd  sat  sdf

	db DARK, STEEL ; type
	db 120 ; catch rate
	db 68 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/pawniard/front.dimensions"
	abilities_for PAWNIARD, DEFIANT, INNER_FOCUS, PRESSURE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DIG, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, THIEF, CUT, STRENGTH
	; end
