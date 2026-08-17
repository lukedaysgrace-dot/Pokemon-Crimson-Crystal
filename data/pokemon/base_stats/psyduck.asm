	db 0 ; species ID placeholder

	db  50,  52,  48,  55,  65,  50
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 190 ; catch rate
	db 64 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/psyduck/front.dimensions"
	abilities_for PSYDUCK, DAMP, CLOUD_NINE, SWIFT_SWIM
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, HONE_CLAWS, ZEN_HEADBUTT, SURF, STRENGTH, FLASH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
