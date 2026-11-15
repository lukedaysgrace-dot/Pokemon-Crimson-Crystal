; ==== Elite tactics (AI_ELITE trainers only) ==============================
; Gym leaders, the Elite Four, rivals, Red/Blue/Green, Rocket admins, Battle
; Tower trainers and the other AI_ELITE classes read the board the way a
; strong human player does:
; - who moves first (true speed via AICompareSpeed, and move priority);
; - what each of their attacks does (the real damage formula);
; - what the player's Pokemon will probably hit back with.
;
; "Fair genius" knowledge only. The player's threat is built from:
; - the moves its active mon has already used (wPlayerUsedMoves), and
; - one guessed same-type attack for each of its types that no revealed
;   attack already covers: an ordinary hit whose power scales with the
;   player's level, physical or special by its higher attacking stat.
; It NEVER reads unrevealed moves, the player's bench, or this turn's
; pending action. (AIChooseMove runs before the player picks; the switch
; decision runs after, but reads only the same board state.)
;
; Callers:
; - AIChooseMove's universal layer -> AI_UniversalLayer -> AI_EliteTactics
; - AI_SwitchOrTryItem (items.asm) -> AIEliteSwitchOrItem
; - AIPickPostKOSwitchIn (switch.asm) -> AIElitePickBestBench
; Scoring rolls for elite trainers go through AIScoringRandom.

; wAIEliteFlags bits
	const_def
	const ELITE_ENEMY_FASTER_F   ; our active mon outspeeds the player's
	const ELITE_PLAYER_KOS_F     ; the player's best predicted hit KOs us
	const ELITE_PLAYER_2HKOS_F   ; ...or does at least half our HP
	const ELITE_PLAYER_PRIO_KO_F ; a revealed priority attack KOs us
	const ELITE_WE_KO_FIRST_F    ; a usable move of ours KOs before they act

; wAIEliteMoveInfo bits (one byte per enemy move slot)
	const_def
	const ELITE_MOVE_DAMAGING_F
	const ELITE_MOVE_KO_F        ; KOs even on a low damage roll
	const ELITE_MOVE_FIRST_F     ; beats normal and revealed damaging priorities
	const ELITE_MOVE_PRIORITY_F  ; positive priority bracket
	const ELITE_MOVE_USABLE_F    ; selectable, and no other layer objects to it

ELITE_MOVE_KO_FIRST_MASK EQU 1 << ELITE_MOVE_KO_F | 1 << ELITE_MOVE_FIRST_F | 1 << ELITE_MOVE_USABLE_F
ELITE_MOVE_PRIO_HIT_MASK EQU 1 << ELITE_MOVE_PRIORITY_F | 1 << ELITE_MOVE_DAMAGING_F | 1 << ELITE_MOVE_USABLE_F
ELITE_MOVE_LIVE_HIT_MASK EQU 1 << ELITE_MOVE_DAMAGING_F | 1 << ELITE_MOVE_USABLE_F

; A move another layer has discouraged (AIDiscourageMove adds 10 to the
; base 20) is never pushed back up by these tactics.
ELITE_USABLE_SCORE EQU 30

; Neutral bench score (see AIEliteBenchScore).
ELITE_BENCH_BASE EQU 64

	assert wAIEliteScratchEnd <= wBTTempOTSprite, "Elite AI scratch must stay clear of the Battle Tower sprite slot"

AIScoringRandom:
; Elite trainers don't gamble on their read of the board: every scoring roll
; comes back as the midpoint, so each "cp N percent" test takes the branch
; that is more likely by design. Everyone else rolls exactly as before.
	ld a, [wEnemyTrainerAIFlags + 1]
	bit AI_ELITE_F - 8, a
	jp z, BattleRandom
	ld a, $80
	ret

; ==== Move selection =======================================================

AI_UniversalLayer:
; Final move-scoring layer for every trainer (see AIChooseMove). Everyone
; gets the universal damage layer; elite trainers then apply their tactics.
	call AI_SmartDamageKO
	call AIEliteCheck
	ret nc
	; fallthrough

AI_EliteTactics:
	ld b, 1 ; wBuffer1 holds this turn's live scores
	call AIEliteAssess

; 1. A sure KO that lands before the player can act ends the exchange:
;    take it, with the most reliable such move.
	call AIEliteBestKOFirstMove
	jp c, AIEliteMakeMoveBest

; 2. About to be KOed before our normal moves resolve: only positive
;    priority still gets a hit in.
	call AIEliteDoomed
	jr nc, .per_move
	ld hl, wBuffer1
	ld de, wAIEliteMoveInfo
	ld c, NUM_MOVES
.priority_loop
	ld a, [de]
	and ELITE_MOVE_PRIO_HIT_MASK
	cp ELITE_MOVE_PRIO_HIT_MASK
	jr nz, .next_priority
	dec [hl]
	dec [hl]
	dec [hl]
.next_priority
	inc hl
	inc de
	dec c
	jr nz, .priority_loop

.per_move
; 3. Per-move judgement: setup, stat drops, hits into a Substitute.
	call AIEliteSubstituteBreakerExists
	sbc a ; $ff if some move breaks the player's Substitute, else 0
	ld e, a
	ld hl, wBuffer1
	ld b, 0 ; move slot
.checkmove
	ld a, b
	cp NUM_MOVES
	ret z
	call AIEliteSlotMove
	and a
	ret z
	ld c, a
	ld a, [hl]
	cp 50
	jr nc, .next
	ld a, c
	call AIGetEnemyMove ; preserves bc, de, hl

	call AIEliteIsSetupMove
	jr nc, .not_setup
	call AIEliteScoreSetup
	jr .next

.not_setup
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	call AI_Elite.IsStatDown
	jr nc, .not_stat_down
; Lowering a stat is wasted when one of us is about to go down.
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr z, .next
	inc [hl]
	inc [hl]
	jr .next

.not_stat_down
	ld a, e
	and a
	call nz, AIEliteScoreIntoSubstitute
.next
	inc hl
	inc b
	jr .checkmove

AIEliteSlotMove:
; a = the move in enemy slot b. Preserves bc, de, hl.
	push hl
	push bc
	ld c, b
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret

AIEliteScoreSetup:
; hl = score of a setup move (wEnemyMoveStruct loaded). Preserves bc, de, hl.
; Boost only when the player can't punish it: setting up into a KO or a
; 2HKO just hands the player free damage.
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr z, .survives
	ld a, [hl]
	add 4
	ld [hl], a
	ret
.survives
	ld a, [wAIEliteFlags]
	bit ELITE_PLAYER_2HKOS_F, a
	jr z, .safe
	inc [hl]
	inc [hl]
	ret
.safe
; Safe to boost. Stop stacking once already well boosted: start attacking.
	push hl
	push bc
	ld hl, wEnemyStatLevels
	ld c, NUM_LEVEL_STATS_BOOSTED
	ld b, 0
.max_level
	ld a, [hli]
	cp b
	jr c, .not_higher
	ld b, a
.not_higher
	dec c
	jr nz, .max_level
	ld a, b
	pop bc
	pop hl
	cp BASE_STAT_LEVEL + 4
	jr nc, .overboosted
	cp BASE_STAT_LEVEL + 2
	ret nc
	dec [hl]
	dec [hl]
	ret
.overboosted
	inc [hl]
	inc [hl]
	ret

; Atk, Def, Spd, SAtk, SDef stages (accuracy/evasion don't count here)
NUM_LEVEL_STATS_BOOSTED EQU 5

AIEliteScoreIntoSubstitute:
; hl = score of slot b (wEnemyMoveStruct loaded). The player hides behind a
; Substitute that another of our moves would break: don't plink at it.
; Preserves bc, de, hl.
	push hl
	push bc
	push de
	ld c, b
	ld b, 0
	ld hl, wAIEliteMoveInfo
	add hl, bc
	bit ELITE_MOVE_DAMAGING_F, [hl]
	jr z, .keep
	ld hl, wAIEliteMoveDmg
	add hl, bc
	add hl, bc
	call AIEliteDmgBreaksSub
	jr c, .keep
	; sound moves and Infiltrator go straight through it
	ld a, 1
	ldh [hBattleTurn], a
	farcall UserMoveBypassesSubstitute_Core
	jr c, .keep
	pop de
	pop bc
	pop hl
	inc [hl]
	ret
.keep
	pop de
	pop bc
	pop hl
	ret

AIEliteSubstituteBreakerExists:
; carry if the player is behind a Substitute and a usable damaging move of
; ours would break it in one hit.
	ld a, [wPlayerSubStatus4]
	and 1 << SUBSTATUS_SUBSTITUTE
	ret z ; nc
	ld de, wAIEliteMoveInfo
	ld hl, wAIEliteMoveDmg
	ld c, NUM_MOVES
.loop
	ld a, [de]
	and ELITE_MOVE_LIVE_HIT_MASK
	cp ELITE_MOVE_LIVE_HIT_MASK
	jr nz, .next
	call AIEliteDmgBreaksSub
	ret c
.next
	inc de
	inc hl
	inc hl
	dec c
	jr nz, .loop
	and a
	ret

AIEliteDmgBreaksSub:
; carry if the big-endian damage at hl is at least the player's Substitute
; HP. Preserves bc, de, hl.
	ld a, [hl]
	and a
	jr nz, .yes
	push hl
	inc hl
	ld a, [wPlayerSubstituteHP]
	and a
	jr z, .yes_pop
	dec a
	cp [hl] ; carry if SubHP - 1 < damage
	pop hl
	ret
.yes_pop
	pop hl
.yes
	scf
	ret

AIEliteIsSetupMove:
; carry if wEnemyMoveStruct raises our own stats (Substitute excluded; it
; is judged by the other layers). Adds Belly Drum and a non-Ghost Curse.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_SUBSTITUTE
	jr z, .no
	cp EFFECT_BELLY_DRUM
	jr z, .yes
	cp EFFECT_CURSE
	jp nz, AI_Elite.IsSetupMove
	ld a, [wEnemyMonType1]
	cp GHOST
	jr z, .no
	ld a, [wEnemyMonType2]
	cp GHOST
	jr z, .no
.yes
	scf
	ret
.no
	and a
	ret

AIEliteDoomed:
; carry if the player's predicted hit lands (and KOs) before any of our
; normal-priority moves resolve.
	ld a, [wAIEliteFlags]
	bit ELITE_PLAYER_PRIO_KO_F, a
	jr nz, .yes
	bit ELITE_PLAYER_KOS_F, a
	jr z, .no
	bit ELITE_ENEMY_FASTER_F, a
	jr nz, .no
.yes
	scf
	ret
.no
	and a
	ret

AIEliteBestKOFirstMove:
; Among usable moves that KO before the player acts, pick the most
; accurate one (ties: the hardest hitter). Two-turn moves, delayed hits and
; self-KO moves never qualify (see .NoCleanKOEffects).
; Out: carry and c = slot if found.
	ld a, [wAIEliteFlags]
	and 1 << ELITE_WE_KO_FIRST_F
	ret z ; nc
	ld b, 0 ; slot
	ld c, $ff ; best slot
	ld d, 0 ; best accuracy
.loop
	ld a, b
	cp NUM_MOVES
	jr z, .done
	push bc
	ld c, b
	ld b, 0
	ld hl, wAIEliteMoveInfo
	add hl, bc
	pop bc
	ld a, [hl]
	and ELITE_MOVE_KO_FIRST_MASK
	cp ELITE_MOVE_KO_FIRST_MASK
	jr nz, .next
	call AIEliteSlotMove
	call AIGetEnemyMove
	ld a, c
	inc a
	jr z, .take ; first candidate
	ld a, [wEnemyMoveStruct + MOVE_ACC]
	cp d
	jr c, .next ; less accurate
	jr nz, .take ; more accurate
	; equally accurate: keep the harder hitter
	call .DamageAbove
	jr nc, .next
.take
	ld a, [wEnemyMoveStruct + MOVE_ACC]
	ld d, a
	ld c, b
.next
	inc b
	jr .loop
.done
	ld a, c
	cp $ff
	ret z ; nc
	scf
	ret

.DamageAbove:
; carry if slot b's predicted damage is above slot c's. Preserves bc, de.
	push de
	push bc
	ld c, b
	call .SlotDamage
	pop bc
	push bc
	push de
	call .SlotDamage ; slot c
	pop hl ; hl = slot b's damage, de = slot c's
	ld a, e
	sub l
	ld a, d
	sbc h ; carry if slot c's < slot b's
	pop bc
	pop de
	ret

.SlotDamage:
; in: c = slot. out: de = its predicted damage. Preserves bc.
	push bc
	ld b, 0
	ld hl, wAIEliteMoveDmg
	add hl, bc
	add hl, bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop bc
	ret

AIEliteMakeMoveBest:
; c = slot. Give it a score strictly below every other real move's, so the
; final pick is not left to the tiebreak. Scores never drop below 1 (a 0
; would wrap in AIChooseMove's decrement loop).
	ld hl, wBuffer1
	ld de, wEnemyMonMoves
	ld b, NUM_MOVES
	ld a, $ff
.min_loop
	push af
	ld a, [de]
	and a
	jr z, .min_done
	pop af
	cp [hl]
	jr c, .min_next
	ld a, [hl]
.min_next
	inc hl
	inc de
	dec b
	jr nz, .min_loop
	push af
.min_done
	pop af
; a = lowest score of any real move
	sub 2
	jr c, .floor
	jr nz, .store
.floor
	ld a, 1
.store
	ld b, 0
	ld hl, wBuffer1
	add hl, bc
	ld [hl], a
; Nudge every other move up by one so that a floor of 1 stays unique.
	ld hl, wBuffer1
	ld de, wEnemyMonMoves
	ld b, 0
.bump_loop
	ld a, [de]
	and a
	ret z
	ld a, b
	cp c
	jr z, .bump_next
	inc [hl]
.bump_next
	inc hl
	inc de
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .bump_loop
	ret

; ==== Switching ============================================================

AIEliteSwitchOrItem:
; AI_SwitchOrTryItem's switch decision for elite trainers. Switches are
; deliberate, never a dice roll; otherwise fall through to item use.
	call CheckAbleToSwitch
	call AIEliteDecideSwitch
	jp nc, DontSwitch
	ld a, [wEnemySwitchMonParam]
	and $f
	inc a
	ld [wEnemySwitchMonIndex], a
	jp AI_TrySwitch

AIEliteDecideSwitch:
; Called right after CheckAbleToSwitch filled wEnemySwitchMonParam
; (high nibble: how strong the reason is; low nibble: party index).
; Out: carry = switch to party index (wEnemySwitchMonParam & $f).
; The enemy's chosen move is already loaded for this turn, so its move
; struct is preserved around the assessment.
; Perish Song's last count always leaves when anything can come in.
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_PERISH, a
	jr z, .no_perish
	ld a, [wEnemyPerishCount]
	cp 1
	jr nz, .no_perish
	ld a, [wEnemySwitchMonParam]
	and $f0
	ret z ; nc
	scf
	ret

.no_perish
	ld hl, wEnemyMoveStruct + MOVE_LENGTH
	ld c, MOVE_LENGTH / 2
.save_struct
	dec hl
	ld e, [hl]
	dec hl
	ld d, [hl]
	push de
	dec c
	jr nz, .save_struct
	ld b, 0 ; usability comes from PP / Disable / Choice
	call AIEliteAssess
	call .Decide
	ld b, 0
	jr nc, .restore
	inc b
.restore
	ld hl, wEnemyMoveStruct
	ld c, MOVE_LENGTH / 2
.restore_struct
	pop de
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	dec c
	jr nz, .restore_struct
	ld a, b
	and a
	ret z ; nc
	scf
	ret

.Decide:
	ld a, [wAIEliteFlags]
; A clean KO beats any switch.
	bit ELITE_WE_KO_FIRST_F, a
	jr nz, .stay
; Sack a mon that falls next turn anyway at a quarter HP or less: its KO
; hands the next one a free entrance.
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr z, .not_doomed_low
	call AICheckEnemyQuarterHP ; carry if above a quarter
	jr nc, .stay
.not_doomed_low
	ld a, [wEnemySwitchMonParam]
	and $f0
	cp $20
	jr nc, .switch ; strong reasons from CheckAbleToSwitch
	and a
	jr z, .threat_switch
; A mild reason is only worth the switch-in's free hit when we're in danger.
	jp .InDanger

.threat_switch
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr z, .stay
; Preserve a healthy mon by bringing in something that walls the hit.
	call AICheckEnemyHalfHP ; carry if above half
	jr nc, .stay
	call AIEliteFindThreatSwitchTarget
	jr nc, .stay
	or $20
	ld [wEnemySwitchMonParam], a
.switch
	scf
	ret
.stay
	and a
	ret

.InDanger:
; carry if this mon is KOed next turn, or 2HKOed by a faster player.
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_KOS_F | 1 << ELITE_PLAYER_PRIO_KO_F
	jr nz, .switch
	ld a, [wAIEliteFlags]
	and 1 << ELITE_PLAYER_2HKOS_F | 1 << ELITE_ENEMY_FASTER_F
	cp 1 << ELITE_PLAYER_2HKOS_F
	jr z, .switch
	jr .stay

; ==== Board assessment =====================================================

AIEliteAssess:
; Fill wAIEliteFlags, wAIEliteMoveInfo, wAIEliteMoveDmg and the player's
; threat (wAIElitePlayerDmg, wAIElitePlayerPrioDmg, wAIEliteThreatType,
; wAIEliteThreatTypes) for the current matchup.
; in: b = 1 if wBuffer1 holds live move scores (move selection), 0 if not
;     (switch decision: usability comes from PP, Disable and Choice).
; Preserves hBattleTurn. Clobbers all registers.
	ld a, b
	ld [wAIEliteMode], a
	ldh a, [hBattleTurn]
	push af
	xor a
	ld [wAIEliteFlags], a
	call AIElitePredictPlayerThreat
	ld a, 1
	ldh [hBattleTurn], a
	call AICompareSpeed
	jr nc, .not_faster
	ld hl, wAIEliteFlags
	set ELITE_ENEMY_FASTER_F, [hl]
.not_faster
	call AIEliteSetThreatFlags
	ld c, 0
.slot_loop
	push bc
	call AIEliteAssessSlot
	pop bc
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .slot_loop
	pop af
	ldh [hBattleTurn], a
	ret

AIEliteSetThreatFlags:
	ld hl, wAIElitePlayerDmg
	call AIEliteDmgKOsUs
	jr nc, .no_ko
	ld hl, wAIEliteFlags
	set ELITE_PLAYER_KOS_F, [hl]
.no_ko
	ld hl, wAIElitePlayerPrioDmg
	call AIEliteDmgKOsUs
	jr nc, .no_prio_ko
	ld hl, wAIEliteFlags
	set ELITE_PLAYER_PRIO_KO_F, [hl]
.no_prio_ko
; two hits: 2 * damage >= our current HP
	ld a, [wAIElitePlayerDmg]
	ld d, a
	ld a, [wAIElitePlayerDmg + 1]
	ld e, a
	or d
	ret z
	sla e
	rl d
	jr c, .two_hit
	ld a, [wEnemyMonHP + 1]
	ld c, a
	ld a, [wEnemyMonHP]
	ld b, a
	ld a, e
	sub c
	ld a, d
	sbc b
	ret c
.two_hit
	ld hl, wAIEliteFlags
	set ELITE_PLAYER_2HKOS_F, [hl]
	ret

AIEliteDmgKOsUs:
; carry if the big-endian damage at hl reaches our active mon's HP, and
; neither a full-HP Sturdy nor a full-HP Focus Sash denies the KO.
	ld a, [hli]
	ld d, a
	ld e, [hl]
	or e
	ret z ; nc
	ld a, [wEnemyMonHP + 1]
	ld c, a
	ld a, [wEnemyMonHP]
	ld b, a
	ld a, e
	sub c
	ld a, d
	sbc b ; carry if damage < HP
	ccf
	ret nc
	call AICheckEnemyMaxHP
	jr nc, .ko
	ld a, [wPlayerAbility]
	cp MOLD_BREAKER
	jr z, .sash
	call AIGetEnemyAbility
	cp STURDY
	jr z, .denied
.sash
	ld a, [wEnemyMonItem]
	cp FOCUS_SASH
	jr nz, .ko
	call AIGetEnemyAbility
	cp KLUTZ
	jr z, .ko
.denied
	and a
	ret
.ko
	scf
	ret

AIEliteAssessSlot:
; c = slot. Writes wAIEliteMoveInfo[c] and wAIEliteMoveDmg[c]: damage
; (real formula, max roll), a KO on a low roll, whether it beats normal and
; known player priorities, and usability.
	ld b, 0
	ld hl, wAIEliteMoveDmg
	add hl, bc
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wAIEliteMoveInfo
	add hl, bc
	ld [hl], a
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	and a
	ret z
	push bc
	call AIGetEnemyMove
	pop bc
	call .Usable
	jr nc, .not_usable
	ld hl, wAIEliteMoveInfo
	add hl, bc
	set ELITE_MOVE_USABLE_F, [hl]
.not_usable
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_OHKO
	ret z
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	ret z
	ld hl, wAIEliteMoveInfo
	add hl, bc
	set ELITE_MOVE_DAMAGING_F, [hl]
	push bc
	call AIDamageCalc
	pop bc
	ld hl, wAIEliteMoveDmg
	add hl, bc
	add hl, bc
	ld a, [wCurDamage]
	ld [hli], a
	ld d, a
	ld a, [wCurDamage + 1]
	ld [hl], a
	ld e, a
; Compare effective priority with normal attacks and revealed damaging
; moves. A faster Quick Attack or a higher bracket can beat our priority.
	push de
	push bc
	ld a, [wEnemyMoveStruct + MOVE_ANIM]
	ld e, 1 ; enemy owner; never the player's pending action
	call AIEliteMovePriority
	pop bc
	pop de
	ld hl, wAIEliteMoveInfo
	add hl, bc
	cp BASE_PRIORITY + 1
	jr c, .not_priority
	set ELITE_MOVE_PRIORITY_F, [hl]
.not_priority
	push bc
	ld b, a
	ld a, [wAIElitePlayerPriority]
	cp b ; carry if our move has the higher priority
	pop bc
	jr c, .first
	jr nz, .got_order
	ld a, [wAIEliteFlags]
	bit ELITE_ENEMY_FASTER_F, a
	jr z, .got_order ; speed ties are not a guaranteed first strike
.first
	set ELITE_MOVE_FIRST_F, [hl]
.got_order
; Moves that don't hit this turn, or that sacrifice the user, are never
; counted as a clean first-strike KO.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	push hl
	push bc
	push de
	ld hl, .NoCleanKOEffects
	ld de, 1
	call IsInArray
	pop de
	pop bc
	pop hl
	ret c
; A KO even on a low damage roll, unless Sash/Sturdy denies it.
	call AIEliteLowRollKOs
	ret nc
	call AIElitePlayerDeniesKO
	ret c
	set ELITE_MOVE_KO_F, [hl]
	ld a, [hl]
	and 1 << ELITE_MOVE_FIRST_F | 1 << ELITE_MOVE_USABLE_F
	cp 1 << ELITE_MOVE_FIRST_F | 1 << ELITE_MOVE_USABLE_F
	ret nz
	ld hl, wAIEliteFlags
	set ELITE_WE_KO_FIRST_F, [hl]
	ret

.NoCleanKOEffects:
	db EFFECT_SELFDESTRUCT
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SKULL_BASH
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db EFFECT_BOUNCE
	db EFFECT_FUTURE_SIGHT
	db EFFECT_BIDE
	db -1 ; end

.Usable:
; carry if slot c can be chosen this turn (hBattleTurn = enemy).
; Apply the same restrictions in both assessment modes. Preserves bc.
	call .from_state
	ret nc
	ld a, [wAIEliteMode]
	and a
	jr z, .yes
	ld hl, wBuffer1
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp ELITE_USABLE_SCORE
	ret ; carry if below the threshold
.from_state
	ld hl, wEnemyMonPP
	ld b, 0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ret z ; nc
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [wEnemyDisabledMove]
	and a
	jr z, .not_disabled
	cp [hl]
	jr z, .no
.not_disabled
	ld a, [wEnemyChoiceLockedMove]
	and a
	jr z, .restrictions
	cp [hl]
	jr nz, .no
.restrictions
; Shared with native selection: cooldown, Taunt, Torment and effective
; Assault Vest. Speculation must not establish a lock or change the pick.
	push bc
	push hl
	ld b, [hl]
	farcall EnemyMoveMeetsRestrictions
	pop hl
	pop bc
	ret
.no
	and a
	ret
.yes
	scf
	ret

AIEliteMovePriority:
; a = known move id, e = owner (0 player, 1 enemy). Return its effective
; priority in a, preserving bc/de/hl and the live turn/move state. Use the
; same pure adjustment as native ordering, including Gale Wings/Triage.
	push bc
	push de
	push hl
	ld b, a
	push bc
	push de
	ld e, a
	farcall GetMovePriority_e
	ld a, e
	pop de
	ld d, a
	pop bc
	ld a, e
	and a
	jr z, .player
	call AIGetEnemyAbility
	jr .adjust
.player
	call AIGetPlayerAbilityEffective
.adjust
	ld c, a
	farcall AbilityCompareMovePriority.Adjust
	ld a, d
	pop hl
	pop de
	pop bc
	ret

AIEliteLowRollKOs:
; carry if ~13/16 of the damage in de (a low roll) reaches the player's HP.
; Preserves bc, de, hl.
	push hl
	push de
	ld h, d
	ld l, e
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l ; hl = damage / 8
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	srl h
	rr l ; hl = damage / 16
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a ; de = 13/16 of damage
	ld a, [wBattleMonHP + 1]
	ld l, a
	ld a, [wBattleMonHP]
	ld h, a
	ld a, e
	sub l
	ld a, d
	sbc h ; carry if 13/16 damage < HP
	ccf
	pop de
	pop hl
	ret

; ==== The player's threat ("fair genius") ==================================

AIElitePredictPlayerThreat:
; Fill wAIElitePlayerDmg / wAIElitePlayerPrioDmg with the strongest hit the
; player is known (or guessed) to have against our active mon, its type in
; wAIEliteThreatType, and every known/guessed damaging type in
; wAIEliteThreatTypes. The player's real move state is restored afterwards.
	xor a
	ld hl, wAIElitePlayerDmg
	ld [hli], a
	ld [hli], a
	ld hl, wAIElitePlayerPrioDmg
	ld [hli], a
	ld [hl], a
	ld a, BASE_PRIORITY
	ld [wAIElitePlayerPriority], a
	xor a
	dec a
	ld [wAIEliteThreatType], a
	ld [wAIEliteThreatTypes], a

	ld hl, wPlayerMoveStruct
	ld de, wAIEliteSavedMove
	ld bc, MOVE_LENGTH
	call CopyBytes
	ld a, [wCurPlayerMove]
	push af
	ld a, [wCurDamage]
	push af
	ld a, [wCurDamage + 1]
	push af
	ld a, [wCriticalHit]
	push af
	ld a, [wTypeModifier]
	push af
	ld a, [wTypeMatchup]
	push af
	ld a, [wBattleAnimParam]
	push af

; A Choice-locked player can only repeat its locked move.
	ld a, [wPlayerChoiceLockedMove]
	and a
	jr z, .revealed
	call .TryRevealedMove
	jr .restore

.revealed
	ld hl, wPlayerUsedMoves
	ld b, NUM_MOVES
.revealed_loop
	ld a, [hli]
	and a
	jr z, .guesses
	push hl
	push bc
	call .TryRevealedMove
	pop bc
	pop hl
	dec b
	jr nz, .revealed_loop

.guesses
	ld a, [wBattleMonType1]
	call .TryGuess
	ld a, [wBattleMonType2]
	ld b, a
	ld a, [wBattleMonType1]
	cp b
	jr z, .restore
	ld a, b
	call .TryGuess

.restore
	pop af
	ld [wBattleAnimParam], a
	pop af
	ld [wTypeMatchup], a
	pop af
	ld [wTypeModifier], a
	pop af
	ld [wCriticalHit], a
	pop af
	ld [wCurDamage + 1], a
	pop af
	ld [wCurDamage], a
	pop af
	ld [wCurPlayerMove], a
	ld hl, wAIEliteSavedMove
	ld de, wPlayerMoveStruct
	ld bc, MOVE_LENGTH
	jp CopyBytes

.TryRevealedMove:
; a = a move the player has already used.
	ld [wCurPlayerMove], a
	call AIEliteLoadPlayerKnownMove
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	ld hl, ConstantDamageEffects
	ld de, 1
	call IsInArray
	jr c, .predict
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_OHKO
	ret z
	ld a, [wPlayerMoveStruct + MOVE_POWER]
	cp 2
	jr nc, .predict
	and a
	ret z ; status
; Supported variable-power moves have a one-power table placeholder.
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	ld hl, .VariablePowerEffects
	ld de, 1
	call IsInArray
	ret nc
.predict
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	call AIEliteAddThreatType
	call AIElitePlayerMoveDamage ; de = damage
	push de
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	ld e, 0 ; revealed player's move, not its pending choice
	call AIEliteMovePriority
	pop de
	cp BASE_PRIORITY + 1
	jr c, .keep_strongest
	ld b, a
	ld a, d
	or e
	jr z, .keep_strongest ; an immune hit does not threaten a first strike
	ld a, [wAIElitePlayerPriority]
	cp b
	jr nc, .got_priority
	ld a, b
	ld [wAIElitePlayerPriority], a
.got_priority
	ld hl, wAIElitePlayerPrioDmg
	call AIEliteKeepMax
.keep_strongest
	ld hl, wAIElitePlayerDmg
	call AIEliteKeepMax
	ret nc
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	ld [wAIEliteThreatType], a
	ret

.VariablePowerEffects:
	db EFFECT_RETURN
	db EFFECT_FRUSTRATION
	db EFFECT_REVERSAL
	db EFFECT_LOW_KICK
	db EFFECT_HEAVY_SLAM
	db EFFECT_GYRO_BALL
	db -1

.TryGuess:
; a = one of the player's types. Unless a revealed attack already covers it,
; assume an ordinary same-type hit, as any player would expect.
	call AIEliteIsRealType
	ret nc
	ld b, a
	ld hl, wAIEliteThreatTypes
.covered
	ld a, [hli]
	cp $ff
	jr z, .build
	cp b
	ret z
	jr .covered
.build
	xor a
	ld [wCurPlayerMove], a
	ld hl, wPlayerMoveStruct
	ld [hli], a ; MOVE_ANIM: no particular move
	ld a, EFFECT_NORMAL_HIT
	ld [hli], a
	call AIEliteGuessPower
	ld [hli], a
	ld a, b
	ld [hli], a
	call AIEliteGuessPlayerCategory
	ld [hli], a
	ld a, 100 percent
	ld [hli], a
	ld a, 1
	ld [hli], a ; PP
	xor a
	ld [hl], a ; effect chance
	ld a, b
	call AIEliteAddThreatType
	call AIElitePlayerMoveDamage
	ld hl, wAIElitePlayerDmg
	call AIEliteKeepMax
	ret nc
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	ld [wAIEliteThreatType], a
	ret

AIEliteBuildThreatTypes:
; Fill only wAIEliteThreatTypes (no damage prediction): the damaging types
; the player has shown, plus its own types as guessed attacks.
	ld hl, wPlayerMoveStruct
	ld de, wAIEliteSavedMove
	ld bc, MOVE_LENGTH
	call CopyBytes
	ldh a, [hBattleTurn]
	push af
	ld a, [wBattleAnimParam]
	push af
	ld a, $ff
	ld [wAIEliteThreatTypes], a
	ld a, [wPlayerChoiceLockedMove]
	and a
	jr z, .revealed
	call AIEliteLoadPlayerKnownMove
	jr z, .done
	call AIEliteAddThreatType
	jr .done
.revealed
	ld hl, wPlayerUsedMoves
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	and a
	jr z, .guesses
	push hl
	push bc
	call AIEliteLoadPlayerKnownMove
	call nz, AIEliteAddThreatType
	pop bc
	pop hl
	dec b
	jr nz, .loop
.guesses
	ld a, [wBattleMonType1]
	call AIEliteIsRealType
	call c, AIEliteAddThreatType
	ld a, [wBattleMonType2]
	call AIEliteIsRealType
	call c, AIEliteAddThreatType
.done
	pop af
	ld [wBattleAnimParam], a
	pop af
	ldh [hBattleTurn], a
	ld hl, wAIEliteSavedMove
	ld de, wPlayerMoveStruct
	ld bc, MOVE_LENGTH
	jp CopyBytes

AIEliteLoadPlayerKnownMove:
; Load known move a with the player's actual weather, type conversion and
; Hidden Power settings. Return its type in a, nz for a damaging move.
; Both callers save/restore the player's live move struct and animation
; parameter; this loader neither reads nor changes an unrevealed move slot.
	ld de, wPlayerMoveStruct
	call GetMoveData
	xor a
	ldh [hBattleTurn], a
	farcall WeatherBallUpdateMoveStruct
	farcall AbilityConvertMoveType
	farcall HiddenPowerUpdateMoveStruct
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	ld b, a
	ld a, [wPlayerMoveStruct + MOVE_POWER]
	and a
	ld a, b
	ret

AIEliteIsRealType:
; carry if a is a real battle type (not Bird, an unused slot or out of
; range). Preserves all registers but f.
	cp BIRD
	jr z, .no
	cp UNUSED_TYPES
	jr c, .yes
	cp UNUSED_TYPES_END
	jr c, .no
	cp TYPES_END
	ret ; carry if below TYPES_END
.yes
	scf
	ret
.no
	and a
	ret

AIEliteAddThreatType:
; Append type a to wAIEliteThreatTypes unless it is already listed.
; Clobbers bc, hl.
	ld b, a
	ld c, NUM_MOVES + 2 ; room before the terminator
	ld hl, wAIEliteThreatTypes
.loop
	ld a, [hl]
	cp $ff
	jr z, .append
	cp b
	ret z
	inc hl
	dec c
	jr nz, .loop
	ret ; full (4 revealed + 2 guessed types always fit)
.append
	ld a, b
	ld [hli], a
	ld [hl], $ff
	ret

AIEliteGuessPower:
; Power of a guessed attack, by the player's level: early-game mons don't
; carry 90-power moves yet. Preserves bc, de, hl.
	ld a, [wBattleMonLevel]
	cp 20
	jr c, .weak
	cp 35
	jr c, .medium
	cp 50
	jr c, .strong
	ld a, 90
	ret
.weak
	ld a, 50
	ret
.medium
	ld a, 70
	ret
.strong
	ld a, 80
	ret

AIEliteGuessPlayerCategory:
; Physical if the player's Attack is at least its Sp. Atk, else special.
; Preserves bc, de, hl.
	push bc
	ld a, [wBattleMonSpclAtk + 1]
	ld c, a
	ld a, [wBattleMonSpclAtk]
	ld b, a
	ld a, [wBattleMonAttack + 1]
	sub c
	ld a, [wBattleMonAttack]
	sbc b ; carry if Attack < Sp. Atk
	pop bc
	ld a, CATEGORIZE_PHYSICAL
	ret nc
	ld a, CATEGORIZE_SPECIAL
	ret

AIEliteKeepMax:
; hl = big-endian word; de = damage. If de is larger, store it and return
; carry. Preserves de.
	inc hl
	ld a, [hld]
	sub e
	ld a, [hl]
	sbc d ; carry if stored < de
	ret nc
	ld a, d
	ld [hli], a
	ld [hl], e
	scf
	ret

AIElitePlayerMoveDamage:
; Predict the damage of wPlayerMoveStruct against our active mon with the
; live damage pipeline (max roll, no critical hit), exactly as AIDamageCalc
; does for our own moves. Out: de = damage. Leaves hBattleTurn = player.
	ld a, [wAttackMissed]
	push af
	ld a, [wEffectFailed]
	push af
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wCriticalHit], a
	ldh [hBattleTurn], a ; the player attacks
	inc a
	ld [wAIDamagePrediction], a
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	ld hl, ConstantDamageEffects
	ld de, 1
	call IsInArray
	jr nc, .formula
	callfar BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	jr z, .immune
	callfar BattleCommand_ConstantDamage
	callfar DirectDamageDisguise_Core
	jr .done
.immune
	callfar ResetDamage
	jr .done
.formula
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_REVERSAL
	jr z, .reversal
	callfar AIPredictVariableMoveCategory_Core
	callfar PlayerAttackDamage
	callfar AIPredictVariableMovePower_Core
	callfar BattleCommand_DamageCalc
	callfar BattleCommand_Stab
	callfar AIPredictVariableMoveDamage_Core
	jr .done
.reversal
; The live Flail/Reversal command derives power from this owner's HP,
; loads its stats and applies the formula, restoring the table placeholder.
	callfar BattleCommand_ConstantDamage
	callfar BattleCommand_Stab
.done
	xor a
	ld [wAIDamagePrediction], a
	pop af
	ld [wEffectFailed], a
	pop af
	ld [wAttackMissed], a
	ld a, [wCurDamage]
	ld d, a
	ld a, [wCurDamage + 1]
	ld e, a
	ret

; ==== Bench evaluation =====================================================

AIEliteFindThreatSwitchTarget:
; carry and a = party index of the best healthy bench mon (half HP or more)
; that resists or is immune to the player's strongest predicted hit and is
; weak to none of the types the player is known or guessed to carry.
	ld a, [wAIEliteThreatType]
	cp $ff
	jr z, .none
	call FindAliveEnemyMons ; c = candidates; carry if none
	jr c, .none
	call FindEnemyMonsThatSurviveOwnHazards
	ld b, 1 << (PARTY_LENGTH - 1)
	ld d, 0 ; party index
	ld e, 0 ; best score so far (0 = none)
.loop
	ld a, b
	and c
	jr z, .next
	call AIEliteBenchHalfHP
	jr nc, .next
	call AIEliteBenchBaseData
	ld a, [wAIEliteThreatType]
	call AIEliteBenchTakes
	cp EFFECTIVE
	jr nc, .next
	call AIEliteBenchWeakToThreats
	jr c, .next
	call AIEliteBenchScore
	cp e
	jr c, .next
	jr z, .next
	ld e, a
	ld a, d
	ld [wAIEliteBest], a
.next
	inc d
	srl b
	jr nz, .loop
	ld a, e
	and a
	jr z, .none
	ld a, [wAIEliteBest]
	scf
	ret
.none
	and a
	ret

AIElitePickBestBench:
; After our mon faints: carry and a = party index of the best replacement
; against the player's active mon (see AIEliteBenchScore).
	call AIEliteBuildThreatTypes
	call FindAliveEnemyMons ; c = candidates; carry if none
	jr c, .none
	ld b, 1 << (PARTY_LENGTH - 1)
	ld d, 0
	ld e, 0
.loop
	ld a, b
	and c
	jr z, .next
	call AIEliteBenchBaseData
	call AIEliteBenchScore
	cp e
	jr c, .next
	jr z, .next
	ld e, a
	ld a, d
	ld [wAIEliteBest], a
.next
	inc d
	srl b
	jr nz, .loop
	ld a, e
	and a
	jr z, .none
	ld a, [wAIEliteBest]
	scf
	ret
.none
	and a
	ret

AIEliteBenchBaseData:
; Load base data (wBaseType) for OT party mon d. Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld hl, wOTPartySpecies
	ld c, d
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	pop bc
	pop de
	pop hl
	ret

AIEliteBenchHalfHP:
; carry if OT party mon d has at least half its max HP. Preserves bc, de, hl.
	push hl
	push bc
	call AIEliteBenchStruct
	ld bc, MON_HP
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a ; bc = HP, hl = MaxHP
	sla c
	rl b
	jr c, .yes
	call AIEliteBCBelowHL
	ccf
	jr .done
.yes
	scf
.done
	pop bc
	pop hl
	ret

AIEliteBenchStruct:
; hl = OT party mon d's struct. Preserves bc, de.
	push bc
	ld hl, wOTPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, d
	call AddNTimes
	pop bc
	ret

AIEliteBCBelowHL:
; carry if bc < the big-endian word at hl. Preserves bc, de, hl.
	inc hl
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
	ret

AIEliteBenchTakes:
; a = attacking type, d = OT party index (wBaseType loaded).
; Out: a = matchup against that mon (0 if its ability nullifies the type).
; Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld c, a
	push bc
	farcall AIPartyIndexAbilityNullifiesTypeFar ; c = type, d = index
	pop bc
	jr c, .immune
	ld a, c
	ld hl, wBaseType
	call AISwitch_CheckTypeMatchup
	ld a, [wTypeMatchup]
	jr .done
.immune
	xor a
.done
	pop bc
	pop de
	pop hl
	ret

AIEliteBenchWeakToThreats:
; carry if any type in wAIEliteThreatTypes hits OT party mon d super
; effectively (wBaseType loaded). Preserves bc, de, hl.
	push hl
	ld hl, wAIEliteThreatTypes
.loop
	ld a, [hli]
	cp $ff
	jr z, .no
	call AIEliteBenchTakes
	cp EFFECTIVE + 1
	jr c, .loop
	pop hl
	scf
	ret
.no
	pop hl
	and a
	ret

AIEliteBenchScore:
; Score OT party mon d against the player's active mon (wBaseType loaded).
; Out: a = score (ELITE_BENCH_BASE = neutral; higher is better).
; - Defense: each damaging type the player is known or guessed to carry:
;   immune +3, resists +2, neutral 0, weak -3, 4x weak -5.
; - Offense: its best damaging move into the player's typing:
;   super effective +3, neutral +1, nothing better than resisted -2.
; - Outspeeds the player +2.
; - Half HP or more +1; a quarter or less -2.
; - Arrives crippled by our side's hazards -3.
; Preserves bc, de, hl.
	push hl
	push de
	push bc
	ld e, ELITE_BENCH_BASE

; Defense
	ld hl, wAIEliteThreatTypes
.def_loop
	ld a, [hli]
	cp $ff
	jr z, .offense
	call AIEliteBenchTakes
	and a
	jr z, .def_immune
	cp EFFECTIVE
	jr c, .def_resist
	jr z, .def_loop
	cp SUPER_EFFECTIVE * 2
	jr nc, .def_quad
	ld a, e
	sub 3
	ld e, a
	jr .def_loop
.def_quad
	ld a, e
	sub 5
	ld e, a
	jr .def_loop
.def_immune
	inc e
.def_resist
	inc e
	inc e
	jr .def_loop

.offense
	push de
	call AIEliteBenchStruct
	push hl
	ld bc, MON_HIDDEN_POWER_TYPE
	add hl, bc
	ld c, [hl] ; its own Hidden Power type
	pop hl
	push hl
	ld de, MON_MOVES
	add hl, de
	ld b, NUM_MOVES
	ld d, 0 ; best matchup (0 = nothing that lands)
.off_loop
	ld a, [hli]
	and a
	jr z, .off_done
	push hl
	call GetMoveTypeIfDamaging ; c = Hidden Power type
	jr z, .off_next
	call AIPlayerAbilityNullifiesType
	jr c, .off_next
	ld hl, wBattleMonType1
	call AISwitch_CheckTypeMatchup
	ld a, [wTypeMatchup]
	cp d
	jr c, .off_next
	ld d, a
.off_next
	pop hl
	dec b
	jr nz, .off_loop
.off_done
	ld a, d
	pop hl ; party struct
	pop de ; d = party index, e = score
	cp EFFECTIVE + 1
	jr nc, .off_super
	cp EFFECTIVE
	jr z, .off_neutral
	dec e
	dec e
	jr .speed
.off_super
	inc e
	inc e
.off_neutral
	inc e

.speed
	push hl
	ld bc, MON_SPD
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = its Speed
	ld a, [wBattleMonSpeed + 1]
	sub c
	ld a, [wBattleMonSpeed]
	sbc b ; carry if the player is slower
	jr nc, .not_faster
	inc e
	inc e
.not_faster
	pop hl

; HP
	push hl
	ld bc, MON_HP
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a ; bc = HP, hl = MaxHP
	sla c
	rl b
	jr c, .healthy
	call AIEliteBCBelowHL
	jr nc, .healthy
	sla c
	rl b
	jr c, .hp_done
	call AIEliteBCBelowHL
	jr nc, .hp_done
	dec e ; a quarter or less
	dec e
	jr .hp_done
.healthy
	inc e
.hp_done
	pop hl

; Hazards on our side of the field
	call FindEnemyMonsThatSurviveOwnHazards.Crippled ; d = index, wBaseType
	jr nc, .done
	ld a, e
	sub 3
	ld e, a
.done
	ld a, e
	pop bc
	pop de
	pop hl
	ret
