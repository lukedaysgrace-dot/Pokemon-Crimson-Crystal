	db 0 ; species ID placeholder

	db  60, 115, 105,  80,  65,  70
	;   hp  atk  def  spd  sat  sdf

	db ROCK, WATER ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/kabutops/front.dimensions"
	abilities_for KABUTOPS, SWIFT_SWIM, BATTLE_ARMOR, SHARPNESS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, FACADE, RETURN, SWAGGER, KNOCK_OFF, SANDSTORM, REST, ATTRACT, THIEF, BUG_BITE, HONE_CLAWS, NIGHT_SLASH, CUT, SURF, WHIRLPOOL, ICE_BEAM
	; end
