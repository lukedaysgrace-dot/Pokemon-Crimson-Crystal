	db 0 ; species ID placeholder

	db  40,  45,  35,  90,  40,  40
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 255 ; catch rate
	db 58 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/meowth/front.dimensions"
	abilities_for MEOWTH, TECHNICIAN, PICKUP, SUPER_LUCK
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, FACADE, IRON_HEAD, THUNDER, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, POWER_GEM, THUNDERBOLT
	; end
