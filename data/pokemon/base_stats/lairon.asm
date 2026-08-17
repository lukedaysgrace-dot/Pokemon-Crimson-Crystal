	db 0 ; species ID placeholder

	db  60,  90, 140,  40,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db STEEL, STEEL ; type
	db 90 ; catch rate
	db 151 ; base exp
	db NO_ITEM, HARD_STONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/lairon/front.dimensions"
	abilities_for LAIRON, ROCK_HEAD, STURDY, IRON_BARBS
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, PROTECT, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, REST, ATTRACT, HONE_CLAWS, STRENGTH
	; end
