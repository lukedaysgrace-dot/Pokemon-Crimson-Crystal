	db 0 ; species ID placeholder

	db  44,  75,  35,  45,  63,  33
	;   hp  atk  def  spd  sat  sdf

	db GHOST, GHOST ; type
	db 225 ; catch rate
	db 59 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/shuppet/front.dimensions"
	abilities_for SHUPPET, FRISK, CURSED_BODY, PRANKSTER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, WILL_O_WISP, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, KNOCK_OFF, NASTY_PLOT, REST, ATTRACT, THIEF
	; end
