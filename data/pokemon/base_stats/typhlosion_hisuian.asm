	db 0 ; species ID placeholder

	db  73,  84,  78,  95, 120,  85
	;  hp  atk  def  spd  sat  sdf

	db FIRE, GHOST ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/typhlosion_hisuian/front.dimensions"
	abilities_for TYPHLOSION_HISUIAN, CURSED_BODY, BERSERK, FLASH_FIRE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, SOLARBEAM, IRON_HEAD, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, FIRE_BLAST, SWIFT, THUNDERPUNCH, REST, ATTRACT, FIRE_PUNCH, BUG_BITE, ZEN_HEADBUTT, CUT, STRENGTH, FLAMETHROWER
	; end
