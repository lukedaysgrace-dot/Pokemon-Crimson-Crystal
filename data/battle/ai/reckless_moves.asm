; AI_AGGRESSIVE does not discourage these moves
; even if a stronger one is available.

RecklessMoves:
	db EFFECT_SELFDESTRUCT
	db EFFECT_RAMPAGE
	db EFFECT_MULTI_HIT
	db EFFECT_DOUBLE_HIT
	db EFFECT_SCALE_SHOT
	db -1 ; end
