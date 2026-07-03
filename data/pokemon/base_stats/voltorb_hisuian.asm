	db 0 ; species ID placeholder

	db  40,  30,  50, 100,  55,  55
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, GRASS ; type
	db 190 ; catch rate
	db 103 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/voltorb_hisuian/front.dimensions"
	abilities_for VOLTORB_HISUIAN, SOUNDPROOF, STATIC, AFTERMATH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, PROTECT, RAIN_DANCE, GIGA_DRAIN, SOLARBEAM, THUNDERBOLT, THUNDER, RETURN, DOUBLE_TEAM, SWIFT, REST, THIEF, FLASH, ENDURE, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER, ZAP_CANNON
	; end
