	db 0 ; species ID placeholder

	db  60,  60,  85,  30, 145, 130
	;  hp  atk  def  spd  sat  sdf

	db GHOST, GHOST ; type
	db 30 ; catch rate
	db 179 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/cursola/front.dimensions"
	abilities_for CURSOLA, WEAK_ARMOR, NO_ABILITY, PERISH_BODY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, EARTHQUAKE, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, SANDSTORM, REST, ATTRACT, POWER_GEM, SURF, STRENGTH, WHIRLPOOL, ICE_BEAM
	; end
