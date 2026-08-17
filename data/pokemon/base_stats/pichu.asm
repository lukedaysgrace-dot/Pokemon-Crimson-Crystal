	db 0 ; species ID placeholder

	db  20,  40,  15,  60,  35,  35
	;   hp  atk  def  spd  sat  sdf

	db ELECTRIC, ELECTRIC ; type
	db 190 ; catch rate
	db 41 ; base exp
	db NO_ITEM, BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/pichu/front.dimensions"
	abilities_for PICHU, STATIC, LIGHTNING_ROD, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, MUD_SLAP, SWAGGER, SWIFT, NASTY_PLOT, REST, ATTRACT, FLASH, THUNDERBOLT
	; end
