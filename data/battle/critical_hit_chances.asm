CriticalHitChances:
; Modern (Gen 7+) critical hit rates.
; Roll is `BattleRandom < value` => probability = value/256.
; BattleCommand_Critical handles stage 3+ as a guarantee before rolling.
	db  11 ;  0  ; ~1/24
	db  32 ; +1  ; 1/8
	db 128 ; +2  ; 1/2
	db 255 ; +3  ; always (handled by BattleCommand_Critical)
	db 255 ; +4
	db 255 ; +5
	db 255 ; +6
