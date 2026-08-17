	db 0 ; species ID placeholder

	db  80, 105,  65, 130,  60,  75
	;   hp  atk  def  spd  sat  sdf

	db ROCK, FLYING ; type
	db 45 ; catch rate
	db 180 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/aerodactyl/front.dimensions"
	abilities_for AERODACTYL, ROCK_HEAD, PRESSURE, STRONG_JAW
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, SWAGGER, SANDSTORM, FIRE_BLAST, SWIFT, DRAGON_DANCE, REST, ATTRACT, STEEL_WING, HONE_CLAWS, FLY, FLAMETHROWER
	; end
