	db 0 ; species ID placeholder

	db  65,  80,  60, 115,  80,  65
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 90 ; catch rate
	db 154 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/persian/front.dimensions"
	abilities_for PERSIAN, TECHNICIAN, LIMBER, SUPER_LUCK
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, THUNDER, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, POWER_GEM, THUNDERBOLT
	; end
