	db 0 ; species ID placeholder

	db  55,  70,  55,  85,  40,  55
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 72 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/aipom/front.dimensions"
	abilities_for AIPOM, RUN_AWAY, PICKUP, SKILL_LINK
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, FACADE, IRON_HEAD, THUNDER, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, CUT, STRENGTH, THUNDERBOLT
	; end
