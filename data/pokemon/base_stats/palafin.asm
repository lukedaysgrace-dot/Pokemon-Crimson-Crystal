	db 0 ; species ID placeholder

	db 100, 130, 100,  90,  95,  75
	;   hp  atk  def  spd  sat  sdf

	db WATER, FIGHTING ; type
	db 45 ; catch rate
	db 180 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/palafin/front.dimensions"
	abilities_for PALAFIN, IRON_FIST, DEFIANT, SWIFT_SWIM
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_2, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, SWIFT, BULK_UP, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, ZEN_HEADBUTT, SURF, STRENGTH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
