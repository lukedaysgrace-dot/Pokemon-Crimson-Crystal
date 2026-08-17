	db 0 ; species ID placeholder

	db  45,  30,  15,  65,  95,  65
	;   hp  atk  def  spd  sat  sdf

	db ICE, PSYCHIC ; type
	db 45 ; catch rate
	db 61 ; base exp
	db ICE_BERRY, ICE_BERRY ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/smoochum/front.dimensions"
	abilities_for SMOOCHUM, OBLIVIOUS, FOREWARN, HYDRATION
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, CURSE, TOXIC, HIDDEN_POWER, SWEET_SCENT, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, ZEN_HEADBUTT, ICE_BEAM
	; end
