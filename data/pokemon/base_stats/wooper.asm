	db 0 ; species ID placeholder

	db  55,  55,  55,  15,  25,  25
	;   hp  atk  def  spd  sat  sdf

	db WATER, GROUND ; type
	db 255 ; catch rate
	db 42 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/wooper/front.dimensions"
	abilities_for WOOPER, DAMP, WATER_ABSORB, UNAWARE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, SANDSTORM, REST, ATTRACT, SURF, FLASH, WHIRLPOOL, ICE_BEAM
	; end
