BattleCommand_Spikes:
; spikes
; Modern Spikes: up to three layers (entry damage 1/8, 1/6, 1/4 of max
; HP - see SpikesLayerDamage_Core). SCREENS_SPIKES stays set as the
; "any spikes present" boolean so existing readers keep working.

	ld hl, wEnemyScreens
	ld de, wEnemySpikesLayers
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wPlayerScreens
	ld de, wPlayerSpikesLayers
.got_side

; Fails at three layers.

	ld a, [de]
	cp 3
	jr nc, .failed

	inc a
	ld [de], a
	set SCREENS_SPIKES, [hl]

	call AnimateCurrentMove

	ld hl, SpikesText
	jp StdBattleTextbox

.failed
	jp FailMove
