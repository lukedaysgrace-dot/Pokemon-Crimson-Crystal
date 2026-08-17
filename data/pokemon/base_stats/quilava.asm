	db 0 ; species ID placeholder

	db  58,  64,  58,  80,  80,  65
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 142 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/quilava/front.dimensions"
	abilities_for QUILAVA, ADAPTABILITY, BLAZE, FLASH_FIRE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, WILL_O_WISP, FACADE, IRON_HEAD, RETURN, DIG, MUD_SLAP, SWAGGER, FIRE_BLAST, SWIFT, REST, ATTRACT, BUG_BITE, ZEN_HEADBUTT, CUT, STRENGTH, FLAMETHROWER
	; end
