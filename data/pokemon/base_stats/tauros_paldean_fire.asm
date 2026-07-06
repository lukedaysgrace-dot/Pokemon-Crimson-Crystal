	db 0 ; species ID placeholder

	db  75, 110, 105, 100,  30,  70
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, FIRE ; type
	db 45 ; catch rate
	db 211 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tauros_paldean_fire/front.dimensions"
	abilities_for TAUROS_PALDEAN_FIRE, INTIMIDATE, ANGER_POINT, NO_ABILITY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, SOLARBEAM, IRON_TAIL, EARTHQUAKE, RETURN, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, FIRE_BLAST, REST, ATTRACT, STRENGTH, ENDURE, HEADBUTT, SLEEP_TALK, SWAGGER
	; end
