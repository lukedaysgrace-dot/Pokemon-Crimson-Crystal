	db 0 ; species ID placeholder

	db  60,  85,  50, 110, 105,  85
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, PSYCHIC ; type
	db 75 ; catch rate
	db 218 ; base exp
	db BERRY, LIGHT_BALL ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raichu_alolan/front.dimensions"
	abilities_for RAICHU_ALOLAN, STATIC, NO_ABILITY, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_HEAD, THUNDER, RETURN, DIG, SWAGGER, KNOCK_OFF, SWIFT, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, SURF, STRENGTH, FLASH, THUNDERBOLT
	; end
