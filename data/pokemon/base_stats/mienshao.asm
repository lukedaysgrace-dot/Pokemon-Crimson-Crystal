	db 0 ; species ID placeholder

	db 65, 125, 60, 115, 85, 60
	;  hp  atk  def  spd  sat  sdf

	db FIGHTING, FAIRY ; type (Enhanced; Original is pure Fighting)
	db 45 ; catch rate
	db 179 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mienshao/front.dimensions"
	abilities_for MIENSHAO, SERENE_GRACE, REGENERATOR, RECKLESS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_HUMANSHAPE ; egg groups (Field / Human-Like)

	; Historical compatibility plus requested Crimson Iron Head / Zen Headbutt coverage.
	tmhm DRAIN_PUNCH, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, DIG, SWAGGER, KNOCK_OFF, SWIFT, BULK_UP, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH
	; end
