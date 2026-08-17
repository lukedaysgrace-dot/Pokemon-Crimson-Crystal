	db 0 ; species ID placeholder

	db  60,  95, 115,  50,  55,  85
	;   hp  atk  def  spd  sat  sdf

	db STEEL, FAIRY ; type
	db 45 ; catch rate
	db 133 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mawile/front.dimensions"
	abilities_for MAWILE, HUGE_POWER, INTIMIDATE, SHEER_FORCE
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, FLASH_CANNON, THUNDERPUNCH, REST, ATTRACT, THIEF, STEEL_WING, FIRE_PUNCH, CUT, STRENGTH
	; end
