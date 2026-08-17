	db 0 ; species ID placeholder

	db  58,  89,  77,  48,  45,  45
	;  hp  atk  def  spd  sat  sdf

	db ROCK, DRAGON ; type
	db 45 ; catch rate
	db 72 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tyrunt/front.dimensions"
	abilities_for TYRUNT, STRONG_JAW, RECKLESS, STURDY
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, SANDSTORM, DRAGON_DANCE, REST, ATTRACT, HONE_CLAWS, ZEN_HEADBUTT, STRENGTH
	; end
