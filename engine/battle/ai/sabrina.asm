; ==== Sabrina's psychic AI (Sabrina only) =================================
; Sabrina reads minds. She keeps every elite tactic (elite_tactics.asm) but
; drops its "fair genius" limits:
; - She knows all four moves of the player's active Pokemon, not just the
;   ones it has used, and every damaging type they carry. (The AI already
;   sees the player's real abilities for every trainer.)
; - She waits until the player has committed to the turn, then reads that
;   choice before picking her own move:
;   * the exact move the player chose: its real damage, priority, type and
;     category; or
;   * that no hit is coming this turn: a switch, an item, a recharge turn,
;     the charging turn of a two-turn move, or Future Sight.
; - When the player switches, she sees the incoming Pokemon before she picks,
;   and Pursuit (if she has it) catches the one that leaves.
; - She plays the moves a true read makes decisive - Counter into a physical
;   hit, Mirror Coat into a special one, Destiny Bond into a hit that KOs her
;   after she moves, Safeguard ahead of a status move, Protect when a KO would
;   land before she acts - and drops them when the read says they would fail.
; - She switches to a Pokemon that walls the exact hit she has read.
;
; Hooks:
; - ParsePlayerAction (core.asm) -> AISabrinaMindRead, right before
;   ParseEnemyAction, so move order, Choice locks and the Protect / Fury
;   Cutter / Rage counters all follow her final pick.
; - PlayerSwitch (core.asm) -> AISabrinaReadsSwitch, then after the switch-in
;   AISabrinaMindRead and ParseEnemyAction.
; - AIElitePredictPlayerThreat, AIEliteBuildThreatTypes -> psychic threat.
; - AIEliteAssess, AIEliteDoomed -> no-hit-this-turn adjustments.
; - AI_UniversalLayer -> AI_SabrinaPsychicLayer.
; - AIEliteSwitchOrItem, AIEliteDecideSwitch -> read-aware switching.
;
; wAISabrinaRead holds SABRINA_READ_ATTACK or SABRINA_READ_IDLE only during
; one of her decisions (it shares the credits-only scratch with the elite
; AI). AISabrinaRead turns anything else into SABRINA_READ_MOVESET.

AISabrinaCheck:
; carry if the opponent is Sabrina in an ordinary trainer battle.
; Preserves all registers but a.
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .no
	ld a, [wLinkMode]
	and a
	jr nz, .no
	ld a, [wInBattleTowerBattle]
	bit 0, a
	jr nz, .no
	ld a, [wOtherTrainerClass]
	cp SABRINA
	jr nz, .no
	scf
	ret
.no
	and a
	ret

AISabrinaRead:
; a = SABRINA_READ_* for the current AI decision. Preserves bc, de, hl.
	call AISabrinaCheck
	ld a, SABRINA_READ_NONE
	ret nc
	ld a, [wAISabrinaRead]
	cp SABRINA_READ_ATTACK
	ret z
	cp SABRINA_READ_IDLE
	ret z
	ld a, SABRINA_READ_MOVESET
	ret

AISabrinaReadAction:
; a = SABRINA_READ_ATTACK if the player's committed action is a move that
; can hit this turn, else SABRINA_READ_IDLE. Preserves bc, de, hl.
	ld a, [wPlayerIsSwitching]
	and a
	jr nz, .idle
	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	jr nz, .idle
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_RECHARGE, a
	jr nz, .idle
	ld a, [wCurPlayerMove]
	and a
	jr z, .idle
	inc a
	jr z, .idle ; $ff: no move this turn
; A charged two-turn move fires now; otherwise its first turn, like Future
; Sight, deals nothing yet.
	ld a, [wPlayerSubStatus3]
	bit SUBSTATUS_CHARGED, a
	jr nz, .attack
	push hl
	push de
	push bc
	ld a, [wCurPlayerMove]
	ld l, a
	ld a, MOVE_EFFECT
	call GetMoveAttribute
	cp EFFECT_SOLARBEAM
	jr z, .solarbeam
	ld hl, .NoHitThisTurn
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl
	jr c, .idle
.attack
	ld a, SABRINA_READ_ATTACK
	ret
.solarbeam
	pop bc
	pop de
	pop hl
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jr z, .attack
.idle
	ld a, SABRINA_READ_IDLE
	ret

.NoHitThisTurn:
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SKULL_BASH
	db EFFECT_FLY
	db EFFECT_BOUNCE
	db EFFECT_FUTURE_SIGHT
	db -1 ; end

; ==== Entry points from the battle engine =================================

AISabrinaMindRead:
; The player has committed to this turn's action and the enemy's choice is
; about to be parsed: Sabrina reads the action and picks her move again.
; ParseEnemyAction then applies Encore, Struggle and lock-ins over any pick.
	call AISabrinaCheck
	ret nc
	call AISabrinaReadAction
	ld [wAISabrinaRead], a
	farcall AIChooseMove
	xor a
	ld [wAISabrinaRead], a
	ret

AISabrinaReadsSwitch:
; The player is switching out. carry: Sabrina picks her move only once the
; incoming Pokemon is out (PlayerSwitch then calls AISabrinaMindRead and
; parses her action). No carry: parse as usual, before the switch - always
; for anyone else, and for Sabrina when she is locked into a move, or when
; she holds Pursuit: she sees the switch coming and selects it here.
	call AISabrinaCheck
	ret nc
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_RECHARGE, a
	jr nz, .now
	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE | 1 << SUBSTATUS_BIDE
	jr nz, .now
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_ROLLOUT, a
	jr nz, .now
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_ENCORED, a
	jr nz, .now
	ld a, EFFECT_PURSUIT
	call AISabrinaFindUsableEffect
	jr nc, .wait
	ld a, c
	ld [wCurEnemyMoveNum], a
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	ld [wCurEnemyMove], a
.now
	and a
	ret
.wait
	scf
	ret

AISabrinaBeginRead:
; Before an elite switch decision: Sabrina has read the committed action.
	call AISabrinaCheck
	ld a, 0
	jr nc, .store
	call AISabrinaReadAction
.store
	ld [wAISabrinaRead], a
	ret

; ==== The player's threat, read ===========================================

AISabrinaPredictThreat:
; AIElitePredictPlayerThreat for Sabrina (its state is saved and restored
; around this call).
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .moveset
; She knows the move the player just chose: that is the hit.
	ld a, [wCurPlayerMove]
	call AIElitePredictPlayerThreat.TryRevealedMove
; Every damaging type the player carries still counts for her switch-ins.
	jp AISabrinaAddMovesetTypes

.moveset
; No action to read (or none that hits now): she still knows all four moves.
	ld a, [wPlayerChoiceLockedMove]
	and a
	jp nz, AIElitePredictPlayerThreat.TryRevealedMove
	ld hl, wBattleMonMoves
	ld de, wBattleMonPP
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	and a
	ret z
	ld c, a
	ld a, [de]
	and PP_MASK
	jr z, .next
	ld a, [wDisabledMove]
	cp c
	jr z, .next
	ld a, c
	push hl
	push de
	push bc
	call AIElitePredictPlayerThreat.TryRevealedMove
	pop bc
	pop de
	pop hl
.next
	inc de
	dec b
	jr nz, .loop
	ret

AISabrinaAddMovesetTypes:
; Add the type of each damaging move of the player's active mon to
; wAIEliteThreatTypes. The caller saves and restores the player's move
; struct, wBattleAnimParam and hBattleTurn.
	ld hl, wBattleMonMoves
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push bc
	call AIEliteLoadPlayerKnownMove
	call nz, AIEliteAddThreatType
	pop bc
	pop hl
	dec b
	jr nz, .loop
	ret

AISabrinaIdleTurn:
; Called by AIEliteAssess once the threat flags are set. When Sabrina knows
; no hit comes this turn, nothing lands before she acts: every hit of hers
; counts as striking first, and no priority attack threatens her now. The
; full-moveset threat (next turn's) still shapes setup and switching.
	call AISabrinaRead
	cp SABRINA_READ_IDLE
	ret nz
	ld hl, wAIEliteFlags
	res ELITE_PLAYER_PRIO_KO_F, [hl]
	xor a
	ld [wAIElitePlayerPriority], a
	ret

AISabrinaLoadReadMove:
; d = effect and e = category of the move the player committed to, with its
; live type and category (Weather Ball, "-ate" abilities, Hidden Power).
; Preserves bc, hl, hBattleTurn and the player's move struct.
	push hl
	push bc
	ldh a, [hBattleTurn]
	push af
	ld a, [wBattleAnimParam]
	push af
	ld hl, wPlayerMoveStruct
	ld de, wAIEliteSavedMove
	ld bc, MOVE_LENGTH
	call CopyBytes
	ld a, [wCurPlayerMove]
	call AIEliteLoadPlayerKnownMove
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	ld b, a
	ld a, [wPlayerMoveStruct + MOVE_CATEGORY]
	ld c, a
	push bc
	ld hl, wAIEliteSavedMove
	ld de, wPlayerMoveStruct
	ld bc, MOVE_LENGTH
	call CopyBytes
	pop de
	pop af
	ld [wBattleAnimParam], a
	pop af
	ldh [hBattleTurn], a
	pop bc
	pop hl
	ret

AISabrinaBeatsReadMove:
; carry if a normal-priority move of ours resolves before the move the
; player committed to. Preserves bc, de, hl.
	push de
	ld a, [wCurPlayerMove]
	ld e, 0 ; the player's
	call AIEliteMovePriority
	pop de
	cp BASE_PRIORITY
	jr c, .yes
	ret nz ; the player's move has priority
	ld a, [wAIEliteFlags]
	bit ELITE_ENEMY_FASTER_F, a
	ret z ; speed ties are not a sure first move
.yes
	scf
	ret

; ==== The reads ===========================================================
; Each returns carry and c = the slot of the move the read makes decisive.

AISabrinaReflectRead:
; Counter into a physical hit, Mirror Coat into a special one: the read hit
; lands on her (no Substitute in the way), she survives it, the reflected
; type can touch the player, and twice the hit beats her best attack.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .no
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .no
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr nz, .no
	ld a, [wAIElitePlayerDmg]
	ld b, a
	ld a, [wAIElitePlayerDmg + 1]
	or b
	jr z, .no ; no damage: a status move, or an immune hit
	call AISabrinaLoadReadMove ; e = category
	ld a, e
	ld b, EFFECT_COUNTER
	cp CATEGORIZE_PHYSICAL
	jr z, .find
	ld b, EFFECT_MIRROR_COAT
	cp CATEGORIZE_SPECIAL
	jr nz, .no
.find
	ld a, b
	call AISabrinaFindUsableEffect ; loads the found move's struct
	ret nc
; Ghosts take no Counter, Dark types no Mirror Coat.
	ld a, [wEnemyMoveStruct + MOVE_TYPE]
	ld hl, wBattleMonType1
	call AISwitch_CheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z ; nc
	jp AISabrinaReflectWorthIt
.no
	and a
	ret

AISabrinaReflectWorthIt:
; carry if twice the read hit's damage is at least what any usable direct
; attack of ours (Counter and Mirror Coat aside) deals. Preserves bc.
	push bc
	ld a, [wAIElitePlayerDmg]
	ld d, a
	ld a, [wAIElitePlayerDmg + 1]
	ld e, a
	sla e
	rl d
	jr c, .yes
	ld c, 0
.loop
	ld a, c
	cp NUM_MOVES
	jr z, .yes
	ld b, 0
	ld hl, wAIEliteMoveInfo
	add hl, bc
	ld a, [hl]
	and ELITE_MOVE_LIVE_HIT_MASK
	cp ELITE_MOVE_LIVE_HIT_MASK
	jr nz, .next
	call AISabrinaSlotIsReflector
	jr c, .next
	ld hl, wAIEliteMoveDmg
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, e
	sub l
	ld a, d
	sbc h ; carry if twice the hit < this attack
	jr c, .no
.next
	inc c
	jr .loop
.yes
	pop bc
	scf
	ret
.no
	pop bc
	and a
	ret

AISabrinaSlotIsReflector:
; carry if our move in slot c is Counter or Mirror Coat. Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld l, [hl]
	ld a, MOVE_EFFECT
	call GetMoveAttribute
	pop bc
	pop de
	pop hl
	cp EFFECT_COUNTER
	jr z, .yes
	cp EFFECT_MIRROR_COAT
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

AISabrinaDestinyBondRead:
; Destiny Bond when the read hit KOs her and her Destiny Bond goes up first:
; the player's Pokemon goes down with hers.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .no
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr z, .no
	call AISabrinaBeatsReadMove
	ret nc
	ld a, EFFECT_DESTINY_BOND
	jp AISabrinaFindUsableEffect
.no
	and a
	ret

AISabrinaSafeguardRead:
; Safeguard when the player has chosen a status move against her and her
; Safeguard goes up first.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .no
	ld a, [wEnemyScreens]
	bit SCREENS_SAFEGUARD, a
	jr nz, .no
	ld a, [wEnemyMonStatus]
	and a
	jr nz, .no
; Magic Bounce sends it back anyway, unless Mold Breaker gets through.
	call AIGetEnemyAbility
	cp MAGIC_BOUNCE
	jr nz, .not_bounced
	ld a, [wPlayerAbility]
	cp MOLD_BREAKER
	jr nz, .no
.not_bounced
	call AISabrinaLoadReadMove ; d = effect
	ld a, d
	ld hl, .StatusEffects
	ld de, 1
	call IsInArray
	jr nc, .no
	call AISabrinaBeatsReadMove
	ret nc
	ld a, EFFECT_SAFEGUARD
	jp AISabrinaFindUsableEffect
.no
	and a
	ret

.StatusEffects:
	db EFFECT_SLEEP
	db EFFECT_TOXIC
	db EFFECT_POISON
	db EFFECT_PARALYZE
	db EFFECT_BURN
	db EFFECT_CONFUSE
	db EFFECT_SWAGGER
	db EFFECT_YAWN
	db -1 ; end

AISabrinaProtectRead:
; Protect (or Baneful Bunker, or Endure) when the read hit would KO her before
; she can act: blocking it at least buys her a turn.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .no
	ld a, [wEnemyProtectCount]
	and a
	jr nz, .no ; a repeat would probably fail
	call AIEliteDoomed
	ret nc
	ld a, EFFECT_PROTECT
	call AISabrinaFindUsableEffect
	ret c
	ld a, EFFECT_BANEFUL_BUNKER
	call AISabrinaFindUsableEffect
	ret c
	ld a, EFFECT_ENDURE
	jp AISabrinaFindUsableEffect
.no
	and a
	ret

AISabrinaKeyRead:
; carry and c = the slot of the move Sabrina's read makes decisive, best
; first. Used by both her move choice and her switch decision.
	call AISabrinaReflectRead
	ret c
	call AISabrinaDestinyBondRead
	ret c
	jp AISabrinaSafeguardRead

AISabrinaHeavyHitRead:
; carry if Sabrina has read a hit that takes half her HP or more and she is
; losing that exchange (her switch decision then looks for a Pokemon that
; walls it): the hit lands before she acts, or no hit of hers takes half the
; player's HP back.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr nz, .no
	ld a, [wAIEliteFlags]
	bit ELITE_PLAYER_2HKOS_F, a
	jr z, .no
	bit ELITE_ENEMY_FASTER_F, a
	jr z, .yes
	ld hl, wAIEliteMoveInfo
	ld de, wAIEliteMoveDmg
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	and ELITE_MOVE_LIVE_HIT_MASK
	cp ELITE_MOVE_LIVE_HIT_MASK
	jr nz, .next
	push hl
	ld a, [de]
	ld h, a
	inc de
	ld a, [de]
	dec de
	ld l, a
	add hl, hl ; twice this hit
	jr c, .winning
	ld a, [wBattleMonHP + 1]
	sub l
	ld a, [wBattleMonHP]
	sbc h ; carry if the player's HP < twice this hit
	jr c, .winning
	pop hl
.next
	inc de
	inc de
	dec c
	jr nz, .loop
.yes
	scf
	ret
.winning
	pop hl
.no
	and a
	ret

AISabrinaFindUsableEffect:
; a = move effect. carry and c = slot of a move of ours with that effect that
; can be selected this turn (PP, Disable, Choice, Taunt and the other
; restrictions, and no target-side failure); wEnemyMoveStruct holds it.
; Preserves hBattleTurn.
	ld e, a
	ldh a, [hBattleTurn]
	push af
	ld a, 1
	ldh [hBattleTurn], a
	ld c, 0
.loop
	ld a, c
	cp NUM_MOVES
	jr z, .none
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	and a
	jr z, .none
	call AIGetEnemyMove ; preserves bc, de, hl
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp e
	jr nz, .next
	push de
	call AIEliteAssessSlot.from_state ; carry if usable; preserves bc
	pop de
	jr c, .found
.next
	inc c
	jr .loop
.none
	pop af
	ldh [hBattleTurn], a
	and a
	ret
.found
	pop af
	ldh [hBattleTurn], a
	scf
	ret

; ==== Move selection ======================================================

AI_SabrinaPsychicLayer:
; Last move-scoring layer, after the elite tactics. Only while Sabrina has
; read the player's committed action.
	call AISabrinaRead
	cp SABRINA_READ_ATTACK
	jr z, .read
	cp SABRINA_READ_IDLE
	ret nz
.read
; A sure first-strike KO, already taken by the elite tactics, beats any read.
	ld a, [wAIEliteFlags]
	bit ELITE_WE_KO_FIRST_F, a
	ret nz
	call AISabrinaDropWastedMoves
	call AISabrinaKeyRead
	jp c, AIEliteMakeMoveBest
	call AISabrinaProtectRead
	jp c, AIEliteMakeMoveBest
	ret

AISabrinaDropWastedMoves:
; The read says these fail, so each gets +10 (as AIDiscourageMove):
; - Counter / Mirror Coat, unless it is the one the read makes decisive;
; - Destiny Bond, unless the read makes it decisive;
; - Protect, Detect, Baneful Bunker and Endure when no hit is coming.
	call AISabrinaReflectRead
	jr c, .got_reflect
	ld c, $ff
.got_reflect
	ld a, c
	push af
	call AISabrinaDestinyBondRead
	jr c, .got_bond
	ld c, $ff
.got_bond
	pop af
	ld d, a ; d = decisive reflector slot ($ff = none)
	ld e, c ; e = decisive Destiny Bond slot ($ff = none)
	ld c, 0
.loop
	ld a, c
	cp NUM_MOVES
	ret z
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	and a
	ret z
	call AIGetEnemyMove ; preserves bc, de, hl
	ld hl, wBuffer1
	add hl, bc
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_COUNTER
	jr z, .reflector
	cp EFFECT_MIRROR_COAT
	jr z, .reflector
	cp EFFECT_DESTINY_BOND
	jr z, .bond
	cp EFFECT_PROTECT
	jr z, .shield
	cp EFFECT_BANEFUL_BUNKER
	jr z, .shield
	cp EFFECT_ENDURE
	jr z, .shield
	jr .next
.reflector
	ld a, c
	cp d
	jr z, .next
	jr .discourage
.bond
	ld a, c
	cp e
	jr z, .next
	jr .discourage
.shield
	call AISabrinaRead
	cp SABRINA_READ_IDLE
	jr nz, .next
.discourage
	ld a, [hl]
	add 10
	ld [hl], a
.next
	inc c
	jr .loop
