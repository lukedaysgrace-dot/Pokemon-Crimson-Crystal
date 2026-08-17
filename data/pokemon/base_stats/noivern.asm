	db 0 ; species ID placeholder

	db  85,  60,  80, 123, 107,  80
	;   hp  atk  def  spd  sat  sdf

	db FLYING, DRAGON ; type
	db 45 ; catch rate
	db 187 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 21 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/noivern/front.dimensions"
	abilities_for NOIVERN, FRISK, WIND_RIDER, SOUNDPROOF
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm ROAR, TOXIC, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, SOLARBEAM, DRAGON_CLAW, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, SWIFT, DRAGON_DANCE, REST, ATTRACT, THIEF, STEEL_WING, HONE_CLAWS, FLY, FLASH
	; end
