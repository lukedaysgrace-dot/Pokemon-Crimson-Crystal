	db 0 ; species ID placeholder

	db  80,  55,  50,  40,  55,  60
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, NORMAL ; type
	db 190 ; catch rate
	db 61 ; base exp
	db PRZCUREBERRY, MAGNET ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/kotora/front.dimensions"
	abilities_for KOTORA, VOLT_ABSORB, INTIMIDATE, MOXIE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, DIG, MUD_SLAP, SWAGGER, SWIFT, REST, ATTRACT, THIEF, THUNDERBOLT
	; end
