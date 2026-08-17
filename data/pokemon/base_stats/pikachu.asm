	db 0 ; species ID placeholder

	db  35,  55,  40,  90,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db ELECTRIC, ELECTRIC ; type
	db 190 ; catch rate
	db 112 ; base exp
	db NO_ITEM, BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/pikachu/front.dimensions"
	abilities_for PIKACHU, STATIC, LIGHTNING_ROD, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, STRENGTH, FLASH, THUNDERBOLT
	; end
