	db 0 ; species ID placeholder

	db  62, 135,  95,  65,  60,  90
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 177 ; base exp
	db NO_ITEM, STICK ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sirfetch_d/front.dimensions"
	abilities_for SIRFETCH_D, STEADFAST, SUPER_LUCK, SCRAPPY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, REST, ATTRACT, THIEF, STEEL_WING, CUT, FLY, STRENGTH
	; end
