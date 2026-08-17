	db 0 ; species ID placeholder

	db 150,  80,  54,  80,  90,  54
	;  hp  atk  def  spd  sat  sdf

	db GHOST, FLYING ; type
	db 60 ; catch rate
	db 174 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/drifblim/front.dimensions"
	abilities_for DRIFBLIM, AFTERMATH, UNBURDEN, GUTS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, WILL_O_WISP, FACADE, RETURN, SWAGGER, KNOCK_OFF, REST, ATTRACT, STEEL_WING, FLY
	; end
