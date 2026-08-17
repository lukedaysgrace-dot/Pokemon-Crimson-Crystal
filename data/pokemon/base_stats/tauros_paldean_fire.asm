	db 0 ; species ID placeholder

	db  75, 115, 110, 100,  40,  80
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, FIRE ; type
	db 45 ; catch rate
	db 172 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F0 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/tauros_paldean_fire/front.dimensions"
	abilities_for TAUROS_PALDEAN_FIRE, INTIMIDATE, ANGER_POINT, RECKLESS
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, WILL_O_WISP, SOLARBEAM, IRON_HEAD, EARTHQUAKE, RETURN, SWAGGER, FIRE_BLAST, BULK_UP, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH, FLAMETHROWER
	; end
