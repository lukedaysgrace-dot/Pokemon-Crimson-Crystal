	db 0 ; species ID placeholder

	db  45,  50,  45,  95, 115,  55
	;   hp  atk  def  spd  sat  sdf

	db GHOST, POISON ; type
	db 90 ; catch rate
	db 142 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/haunter/front.dimensions"
	abilities_for HAUNTER, LEVITATE, CURSED_BODY, MERCILESS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, ENERGY_BALL, WILL_O_WISP, FACADE, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, KNOCK_OFF, NASTY_PLOT, REST, ATTRACT, THIEF, THUNDERBOLT
	; end
