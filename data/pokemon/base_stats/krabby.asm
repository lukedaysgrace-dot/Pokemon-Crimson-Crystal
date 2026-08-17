	db 0 ; species ID placeholder

	db  30, 105,  90,  50,  25,  25
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 225 ; catch rate
	db 65 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/krabby/front.dimensions"
	abilities_for KRABBY, HYPER_CUTTER, TOUGH_CLAWS, SHEER_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_3, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, REST, ATTRACT, THIEF, BUG_BITE, HONE_CLAWS, NIGHT_SLASH, CUT, SURF, STRENGTH, WHIRLPOOL, ICE_BEAM
	; end
