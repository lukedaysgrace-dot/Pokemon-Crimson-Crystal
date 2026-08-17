	db 0 ; species ID placeholder

	db 115,  85,  65,  70,  85,  80
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, NORMAL ; type
	db 45 ; catch rate
	db 179 ; base exp
	db PRZCUREBERRY, MAGNET ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raitora/front.dimensions"
	abilities_for RAITORA, VOLT_ABSORB, INTIMIDATE, MOXIE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, SWIFT, REST, ATTRACT, THIEF, STRENGTH, THUNDERBOLT
	; end
