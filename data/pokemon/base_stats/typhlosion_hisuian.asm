	db 0 ; species ID placeholder

	db  73,  84,  78,  95, 119,  85
	;  hp  atk  def  spd  sat  sdf

	db FIRE, GHOST ; type
	db 45 ; catch rate
	db 209 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/typhlosion_hisuian/front.dimensions"
	abilities_for TYPHLOSION_HISUIAN, BLAZE, BLAZE, FRISK
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, SOLARBEAM, IRON_TAIL, RETURN, SHADOW_BALL, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, FIRE_BLAST, SWIFT, REST, ATTRACT, CUT, STRENGTH, DEFENSE_CURL, ENDURE, FIRE_PUNCH, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER, THUNDERPUNCH
	; end
