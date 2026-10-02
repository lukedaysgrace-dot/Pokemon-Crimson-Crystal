	db 0 ; species ID placeholder

	db  60,  60,  60, 105, 105, 105
	;  hp  atk  def  spd  sat  sdf

	db GHOST, FAIRY ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mismagius/front.dimensions"
	abilities_for MISMAGIUS, LEVITATE, NO_ABILITY, PRANKSTER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, POWER_GEM, FLASH, THUNDERBOLT
	; end
