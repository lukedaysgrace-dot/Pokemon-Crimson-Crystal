	db 0 ; species ID placeholder

	db  59,  63,  80,  58,  65,  80
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 45 ; catch rate
	db 142 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/wartortle/front.dimensions"
	abilities_for WARTORTLE, RAIN_DISH, TORRENT, DRIZZLE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, REST, ATTRACT, ZEN_HEADBUTT, SURF, STRENGTH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
