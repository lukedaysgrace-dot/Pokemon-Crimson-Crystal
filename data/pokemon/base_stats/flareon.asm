	db 0 ; species ID placeholder

	db 110, 130,  60,  95,  65,  65
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 184 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/flareon/front.dimensions"
	abilities_for FLAREON, FLASH_FIRE, GUTS, QUICK_FEET
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, RAIN_DANCE, WILL_O_WISP, FACADE, IRON_HEAD, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, FIRE_BLAST, SWIFT, REST, ATTRACT, FLAMETHROWER
	; end
