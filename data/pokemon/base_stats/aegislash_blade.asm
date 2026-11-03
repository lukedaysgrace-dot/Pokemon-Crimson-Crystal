	db 0 ; species ID placeholder

	db 60, 140, 50, 60, 140, 50
	;  hp  atk  def  spd  sat  sdf

	db STEEL, GHOST ; type
	db 45 ; catch rate
	db 250 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/aegislash_blade/front.dimensions"
	abilities_for AEGISLASH_BLADE, STANCE_CHANGE, STANCE_CHANGE, STANCE_CHANGE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, SHADOW_BALL, SWAGGER, FLASH_CANNON, REST, ATTRACT, FURY_CUTTER, NIGHT_SLASH, CUT
	; end
