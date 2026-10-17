; Canonical stats and biology; historical Smogon + Lumi move compatibility.
	db 0 ; species ID placeholder

	db 100, 100, 100, 100, 100, 100
	;   hp  atk  def  spd  sat  sdf

	db STEEL, PSYCHIC ; type
	db 3 ; catch rate
	db 215 ; base exp (Gen III, fits the one-byte field)
	db STAR_PIECE, STAR_PIECE ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 120 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/jirachi/front.dimensions"
	abilities_for JIRACHI, SERENE_GRACE, NO_ABILITY, NO_ABILITY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset (Zap Cannon is a Luminescent tutor move)
	tmhm DRAIN_PUNCH, HEADBUTT, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, FACADE, IRON_HEAD, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, FLASH_CANNON, SANDSTORM, SWIFT, THUNDERPUNCH, REST, FIRE_PUNCH, ZEN_HEADBUTT, FLASH, THUNDERBOLT
	; end
