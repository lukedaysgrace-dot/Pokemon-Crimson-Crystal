	db 0 ; species ID placeholder

	db  70, 110,  70,  90, 115,  70
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, STEEL ; type
	db 45 ; catch rate
	db 184 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/lucario/front.dimensions"
	abilities_for LUCARIO, ADAPTABILITY, INNER_FOCUS, JUSTIFIED
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, FLASH_CANNON, SWIFT, BULK_UP, NASTY_PLOT, REST, ATTRACT, HONE_CLAWS, ZEN_HEADBUTT, STRENGTH
	; end
