	db 0 ; species ID placeholder

	db  45,  50,  43,  62,  40,  38
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, FLYING ; type
	db 255 ; catch rate
	db 56 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/fletchling/front.dimensions"
	abilities_for FLETCHLING, BIG_PECKS, NO_ABILITY, GALE_WINGS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, WORK_UP, PROTECT, WILL_O_WISP, FACADE, RETURN, SWAGGER, REST, ATTRACT, STEEL_WING, FLY
	; end
