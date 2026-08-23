	db 0 ; species ID placeholder

	db  75, 135,  70, 105, 100,  65
	;   hp  atk  def  spd  sat  sdf

	db ROCK, FLYING ; type
	db 45 ; catch rate
	db 177 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/archeops/front.dimensions"
	abilities_for ARCHEOPS, RECKLESS, WIND_RIDER, KEEN_EYE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, DRAGON_CLAW, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, KNOCK_OFF, SANDSTORM, SWIFT, REST, ATTRACT, THIEF, STEEL_WING, HONE_CLAWS, ZEN_HEADBUTT, FLY, STRENGTH
	; end
