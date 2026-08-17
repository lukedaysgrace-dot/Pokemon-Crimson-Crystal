	db 0 ; species ID placeholder

	db  90,  95,  66,  62,  45,  65
	;  hp  atk  def  spd  sat  sdf

	db DRAGON, ICE ; type
	db 25 ; catch rate
	db 148 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/arctibax/front.dimensions"
	abilities_for ARCTIBAX, THERMAL_EXCHANGE, NO_ABILITY, ICE_BODY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_DRAGON, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, DRAGON_PULSE, HIDDEN_POWER, ICICLE_CRASH, PROTECT, FACADE, DRAGON_CLAW, RETURN, SWAGGER, REST, ATTRACT
	; end
