	db 0 ; species ID placeholder

	db  70, 110, 180,  50,  60,  60
	;   hp  atk  def  spd  sat  sdf

	db STEEL, STEEL ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, HARD_STONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/aggron/front.dimensions"
	abilities_for AGGRON, ROCK_HEAD, STURDY, IRON_BARBS
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, FLASH_CANNON, SANDSTORM, FIRE_BLAST, REST, ATTRACT, HONE_CLAWS, STRENGTH
	; end
