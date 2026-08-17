	db 0 ; species ID placeholder

	db  30,  35,  30,  75,  55,  30
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 120 ; catch rate
	db 51 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/flittle/front.dimensions"
	abilities_for FLITTLE, FRISK, KEEN_EYE, SPEED_BOOST
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, SWIFT, REST, ATTRACT, THIEF, ZEN_HEADBUTT
	; end
