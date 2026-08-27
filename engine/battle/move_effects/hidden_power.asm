BattleCommand_HiddenPower:
; hiddenpower

	ld a, [wAttackMissed]
	and a
	ret nz
	; picks the category from the user's current stats, then damagestats
	farcall HiddenPowerDamage
	ret
