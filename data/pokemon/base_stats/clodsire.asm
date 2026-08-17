	db 0 ; species ID placeholder

	db 130,  75,  60,  20,  65, 100
	;  hp  atk  def  spd  sat  sdf

	db POISON, GROUND ; type
	db 45 ; catch rate
	db 151 ; base exp
	db NO_ITEM, MINT_BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/clodsire/front.dimensions"
	abilities_for CLODSIRE, POISON_POINT, WATER_ABSORB, UNAWARE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_WATER_1, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, PROTECT, IRON_HEAD, EARTHQUAKE, RETURN, DIG, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, SANDSTORM, REST, ATTRACT, THIEF, ZEN_HEADBUTT, SURF, STRENGTH, FLASH, ICE_BEAM
	; end
