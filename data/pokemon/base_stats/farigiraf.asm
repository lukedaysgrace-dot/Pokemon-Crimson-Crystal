	db 0 ; species ID placeholder

	db 120,  90,  70,  85, 110,  70
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, PSYCHIC ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/farigiraf/front.dimensions"
	abilities_for FARIGIRAF, ARMOR_TAIL, CUD_CHEW, SAP_SIPPER
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, THUNDER, EARTHQUAKE, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, ZEN_HEADBUTT, STRENGTH, FLASH, THUNDERBOLT
	; end
