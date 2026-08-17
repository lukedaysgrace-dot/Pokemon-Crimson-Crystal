	db 0 ; species ID placeholder

	db  65,  80,  80,  58,  59,  63
	;   hp  atk  def  spd  sat  sdf

	db WATER, DARK ; type
	db 45 ; catch rate
	db 142 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/croconaw/front.dimensions"
	abilities_for CROCONAW, STRONG_JAW, TORRENT, SHEER_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_WATER_1 ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, DRAGON_CLAW, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, DRAGON_DANCE, REST, ATTRACT, BUG_BITE, HONE_CLAWS, CUT, FLY, SURF, STRENGTH, FLASH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
