	db 0 ; species ID placeholder

	db  65,  95,  95,  95,  45,  65
	;   hp  atk  def  spd  sat  sdf

	db WATER, POISON ; type
	db 45 ; catch rate
	db 88 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/qwilfish/front.dimensions"
	abilities_for QWILFISH, POISON_POINT, SWIFT_SWIM, INTIMIDATE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_2, EGG_WATER_2 ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, RETURN, SWAGGER, SLUDGE_BOMB, SWIFT, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
