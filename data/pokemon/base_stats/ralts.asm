	db 0 ; species ID placeholder

	db  28,  25,  25,  40,  65,  55
	;  hp  atk  def  spd  sat  sdf

	db PSYCHIC, FAIRY ; type
	db 235 ; catch rate
	db 40 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ralts/front.dimensions"
	abilities_for RALTS, SYNCHRONIZE, TRACE, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, ENERGY_BALL, WILL_O_WISP, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, KNOCK_OFF, REST, ATTRACT, ZEN_HEADBUTT, FLASH, THUNDERBOLT
	; end
