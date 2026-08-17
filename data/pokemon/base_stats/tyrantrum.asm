	db 0 ; species ID placeholder

	db  82, 121, 119,  71,  69,  59
	;  hp  atk  def  spd  sat  sdf

	db ROCK, DRAGON ; type
	db 45 ; catch rate
	db 182 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tyrantrum/front.dimensions"
	abilities_for TYRANTRUM, STRONG_JAW, RECKLESS, ROCK_HEAD
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, SANDSTORM, DRAGON_DANCE, REST, ATTRACT, HONE_CLAWS, ZEN_HEADBUTT, STRENGTH
	; end
