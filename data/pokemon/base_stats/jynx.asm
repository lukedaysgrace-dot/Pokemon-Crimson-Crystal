	db 0 ; species ID placeholder

	db  75,  40,  35,  95, 125,  95
	;   hp  atk  def  spd  sat  sdf

	db ICE, PSYCHIC ; type
	db 45 ; catch rate
	db 159 ; base exp
	db ICE_BERRY, ICE_BERRY ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/jynx/front.dimensions"
	abilities_for JYNX, OBLIVIOUS, FOREWARN, DRY_SKIN
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SWEET_SCENT, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, ZEN_HEADBUTT, ICE_BEAM
	; end
