	db 0 ; species ID placeholder

	db  40,  30,  35,  55,  45,  40
	;   hp  atk  def  spd  sat  sdf

	db FLYING, DRAGON ; type
	db 190 ; catch rate
	db 49 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 21 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/noibat/front.dimensions"
	abilities_for NOIBAT, FRISK, WIND_RIDER, SOUNDPROOF
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm TOXIC, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, PROTECT, FACADE, DRAGON_CLAW, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, SWIFT, REST, ATTRACT, THIEF, STEEL_WING, FLY, FLASH
	; end
