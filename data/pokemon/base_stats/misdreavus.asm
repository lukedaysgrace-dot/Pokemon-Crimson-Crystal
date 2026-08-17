	db 0 ; species ID placeholder

	db  60,  60,  60,  85,  85,  85
	;   hp  atk  def  spd  sat  sdf

	db GHOST, FAIRY ; type
	db 45 ; catch rate
	db 87 ; base exp
	db NO_ITEM, SPELL_TAG ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/misdreavus/front.dimensions"
	abilities_for MISDREAVUS, LEVITATE, NO_ABILITY, PRANKSTER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, POWER_GEM, FLASH, THUNDERBOLT
	; end
