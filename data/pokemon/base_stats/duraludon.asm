	db 0 ; species ID placeholder

	db  70,  95, 115,  85, 120,  50
	;  hp  atk  def  spd  sat  sdf

	db STEEL, DRAGON ; type
	db 45 ; catch rate
	db 187 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/duraludon/front.dimensions"
	abilities_for DURALUDON, CLEAR_BODY, STAMINA, STEADFAST
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm ROCK_SMASH, DRAGON_PULSE, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, THUNDER, FLASH_CANNON, REST, ATTRACT, HONE_CLAWS, NIGHT_SLASH, THUNDERBOLT, ROAR, ROCK_TOMB, SOLARBEAM
	; end
