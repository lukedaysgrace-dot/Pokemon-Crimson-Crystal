	db 0 ; species ID placeholder

	db  60,  27, 168,  30,  77, 138
	;  hp  atk  def  spd  sat  sdf

	db ROCK, STEEL ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/bastiodon/front.dimensions"
	abilities_for BASTIODON, STURDY, SOUNDPROOF, FILTER
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, FACADE, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, FLASH_CANNON, SANDSTORM, REST, ATTRACT, POWER_GEM, STRENGTH
	; end
