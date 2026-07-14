BattleCommand_PerishSong:
; perishsong
; The ability-aware implementation lives in its own bank so the Effect
; Commands bank retains enough space for the command table and move cores.
	farcall BattlePerishSong_Core
	ret
