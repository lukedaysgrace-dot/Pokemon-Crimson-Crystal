	db 0 ; species ID placeholder

	db  60,  95,  55, 110,  95,  80
	;   hp  atk  def  spd  sat  sdf

	db ELECTRIC, ELECTRIC ; type
	db 75 ; catch rate
	db 243 ; base exp
	db NO_ITEM, BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raichu/front.dimensions"
	abilities_for RAICHU, STATIC, LIGHTNING_ROD, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, STRENGTH, FLASH, THUNDERBOLT
	; end
