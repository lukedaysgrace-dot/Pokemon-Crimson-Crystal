	db 0 ; species ID placeholder

	db  70, 117, 123,  50,  80,  60
	;   hp  atk  def  spd  sat  sdf

	db WATER, ROCK ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/carracosta/front.dimensions"
	abilities_for CARRACOSTA, STURDY, SHEER_FORCE, SWIFT_SWIM
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SANDSTORM, REST, ATTRACT, ZEN_HEADBUTT, SURF, STRENGTH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
