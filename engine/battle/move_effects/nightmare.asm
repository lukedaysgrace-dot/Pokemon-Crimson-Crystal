BattleCommand_Nightmare:
; nightmare

; Nightmare has no checkhit command, but Protect and Baneful Bunker
; still block it. A sleeping target can use either through Sleep Talk.
; Reuse the shared guard so King's Shield still allows status moves.

	call BattleCommand_CheckHit.Protect
	jr nz, .failed

; Can't hit an absent opponent.

	call CheckHiddenOpponent
	jr nz, .failed

; Can't hit a substitute.

	call CheckSubstituteOpp
	jr nz, .failed

; Only works on a sleeping opponent.

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and SLP
	jr z, .failed

; Bail if the opponent is already having a nightmare.

	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_NIGHTMARE, [hl]
	jr nz, .failed

; Otherwise give the opponent a nightmare.

	set SUBSTATUS_NIGHTMARE, [hl]
	call AnimateCurrentMove
	ld hl, StartedNightmareText
	jp StdBattleTextbox

.failed
	call AnimateFailedMove
	jp PrintButItFailed
