	db 0 ; species ID placeholder

	db 110, 130,  80,  80,  70,  60
	;  hp  atk  def  spd  sat  sdf

	db ICE, GROUND ; type
	db 50 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mamoswine/front.dimensions"
	abilities_for MAMOSWINE, THICK_FAT, OBLIVIOUS, QUICK_FEET
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, ICICLE_CRASH, PROTECT, RAIN_DANCE, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, KNOCK_OFF, SANDSTORM, REST, ATTRACT, STRENGTH, ICE_BEAM
	; end
