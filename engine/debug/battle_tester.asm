; Battle tester (debug builds only; assembled when DEBUG_BATTLE is defined).
;
; Three consumers, one mechanism:
;   1. A DEBUG entry on the start menu opens an editor for both sides of a
;      wild battle: species, level, ability, item, moves, DVs, HP, status.
;   2. The Python harness (tools/battletest/) writes the same request block
;      (wDebugMagic..wDebugEnemy, WRAMX bank 2) directly and drives the game
;      through it with no button input at all.
;   3. In auto mode (DEBUGFLAG_AUTO) the battle plays itself: the battle menu
;      is skipped and player moves come from wDebugMoveScript. The engine
;      pauses at wDebugTurnTarget so the harness can read WRAM and assert.
;
; The request describes mons by their true 16-bit species/move indexes; this
; module converts them to the 8-bit runtime IDs (engine/16/) and builds mons
; through the engine's own init paths (TryAddMonToParty, LoadEnemyMon), so
; every derived stat is derived by the same code the real game uses.
;
; State machine (wDebugState):
;   $00 IDLE   not in tester
;   $01 MENU   debug menu open, awaiting a request (fixture point)
;   $02 INIT   request consumed, battle initialising
;   $03 READY  both mons in, entry abilities done, overrides applied
;   $04 WAIT   requested turn count complete - assertion point
;   $05 DONE   battle over, party restored
;   $FF ERROR  request rejected

DEBUGSTATE_IDLE  EQU $00
DEBUGSTATE_MENU  EQU $01
DEBUGSTATE_INIT  EQU $02
DEBUGSTATE_READY EQU $03
DEBUGSTATE_WAIT  EQU $04
DEBUGSTATE_DONE  EQU $05
DEBUGSTATE_ERROR EQU $FF

DEBUGFLAG_AUTO EQU 0 ; bit of wDebugBattleFlags

; wDebugControl commands (written by the harness while state is WAIT)
DEBUGCTL_CONTINUE EQU 1 ; raised wDebugTurnTarget; run more turns
DEBUGCTL_END      EQU 2 ; end the battle now

; Offsets into a per-side request block (wDebugPlayer1/2, wDebugEnemy)
dbg_SPECIES      EQU  0 ; dw, 16-bit index; 0 = slot unused (player 2 only)
dbg_LEVEL        EQU  2
dbg_ABILSLOT     EQU  3 ; 0 = slot 1, 1 = slot 2, 2 = hidden
dbg_ABILOVERRIDE EQU  4 ; 0 = none, else ability constant forced post-entry
dbg_ITEM         EQU  5
dbg_MOVES        EQU  6 ; 4 x dw, 16-bit indexes; all zero = keep learnset
dbg_DVS          EQU 14 ; dw
dbg_HPPCT        EQU 16 ; 1-100; 0 = 100
dbg_STATUS       EQU 17 ; raw status byte
dbg_STATLEVELS   EQU 18 ; ds 7; [0] = 0 -> no stat stage override
dbg_SUBSTATUS    EQU 25 ; ds 5; ORed into w{Player,Enemy}SubStatus1-5
                        ; post-entry (player1/enemy only; player2's field
                        ; is ignored - substatus belongs to the active mon)
dbg_SIZE         EQU 30

DEBUG_WRAM_BANK EQU 2

SECTION "Debug Battle Tester", ROMX, BANK[$8F]

; ==============================================================
; Small helpers for the banked request block
; ==============================================================

DebugOpenWRAM:
; Switch to the debug WRAM bank. Restore with DebugCloseWRAM.
	push af
	ldh a, [rSVBK]
	ldh [hDebugSVBK], a
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	pop af
	ret

DebugCloseWRAM:
	push af
	ldh a, [hDebugSVBK]
	ldh [rSVBK], a
	pop af
	ret

DebugPeek:
; a = [hl] from the debug bank; current WRAM bank and all other
; registers preserved.
	push bc
	ldh a, [rSVBK]
	ld b, a
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	ld c, [hl]
	ld a, b
	ldh [rSVBK], a
	ld a, c
	pop bc
	ret

DebugPoke:
; [hl] = a in the debug bank; current WRAM bank and all other
; registers preserved.
	push bc
	ld c, a
	ldh a, [rSVBK]
	ld b, a
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	ld [hl], c
	ld a, b
	ldh [rSVBK], a
	ld a, c
	pop bc
	ret

DebugGetState:
; a = wDebugState; any WRAM bank. Clobbers c, hl.
	ld hl, wDebugState
	jr DebugPeek

DebugSetState:
; wDebugState = a; any WRAM bank. Clobbers c, hl.
	ld hl, wDebugState
	jr DebugPoke

DebugCopyFromRequest:
; Copy c bytes from the debug bank [hl] to [de] in WRAM bank 1 / WRAM0.
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	ld a, [hli]
	ld b, a
	ld a, 1
	ldh [rSVBK], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, DebugCopyFromRequest
	ret

DebugCopyToRequest:
; Copy c bytes from [hl] (WRAM bank 1 / WRAM0) to [de] in the debug bank.
	ld a, 1
	ldh [rSVBK], a
	ld a, [hli]
	ld b, a
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, DebugCopyToRequest
	ld a, 1
	ldh [rSVBK], a
	ret

; ==============================================================
; The battle script, queued by the start menu / poll loop
; ==============================================================

DebugBattleScript::
	callasm DebugBattleSetup
	startbattle
	callasm DebugBattleTeardown
	reloadmapafterbattle
	end

; ==============================================================
; Setup: consume the request, build the party, stage the wild mon
; ==============================================================

DebugBattleSetup::
	call DebugOpenWRAM

	; consume the magic byte
	xor a
	ld [wDebugMagic], a
	ld a, DEBUGSTATE_INIT
	ld [wDebugState], a
	xor a
	ld [wDebugTurnsDone], a
	ld [wDebugControl], a

	; hot flags to HRAM
	ld a, [wDebugBattleFlags]
	bit DEBUGFLAG_AUTO, a
	ld a, 0
	jr z, .not_auto
	inc a
.not_auto
	ldh [hDebugActive], a
	ld a, [wDebugRNGModeReq]
	ldh [hDebugRNGMode], a
	ld a, [wDebugRNGValueReq]
	ldh [hDebugRNGValue], a
	call DebugCloseWRAM

	; deterministic PRNG stream for seeded mode
	ldh a, [hDebugRNGMode]
	cp 2
	jr nz, .no_seed
	xor a
	ld [wLinkBattleRNCount], a
	ld a, 1
	ldh [rSVBK], a
	ldh a, [hDebugRNGValue]
	ld hl, wLinkBattleRNs
	ld c, 10
.seed_loop
	ld [hli], a
	add 23
	dec c
	jr nz, .seed_loop
.no_seed

	call DebugBackupParty

	; build the player's party from the request
	xor a
	ld [wPartyCount], a
	ld [wMonType], a ; PARTYMON
	ld hl, wPartyMon1Species ; not strictly needed; TryAddMonToParty appends
	ld de, wDebugPlayer1
	ld b, 0 ; party slot 0
	call DebugBuildPartyMon

	ld hl, wDebugPlayer2
	call DebugPeek ; species low byte
	ld b, a
	inc hl
	call DebugPeek
	or b
	jr z, .one_mon
	xor a
	ld [wMonType], a
	ld de, wDebugPlayer2
	ld b, 1
	call DebugBuildPartyMon
.one_mon

	; enemy2 set -> trainer battle; else stage a wild encounter
	ld hl, wDebugEnemy2 + dbg_SPECIES
	call DebugPeek
	ld b, a
	inc hl
	call DebugPeek
	or b
	jr z, .wild
	; any existing class/ID works; the read party is replaced from the
	; request by DebugModifyOTParty (hooked after ReadTrainerParty).
	; SCHOOLBOY: SWITCH_OFTEN AI, no items - the AI will actually use
	; its second mon, which is the point of trainer mode.
	ld a, SCHOOLBOY
	ld [wOtherTrainerClass], a
	ld a, 1
	ld [wOtherTrainerID], a
	ld a, BATTLETYPE_NORMAL
	ld [wBattleType], a
	ret

.wild
	ld hl, wDebugEnemy + dbg_SPECIES
	call DebugPeek
	ld e, a
	inc hl
	call DebugPeek
	ld d, a
	ld l, e
	ld h, d
	call GetPokemonIDFromIndex
	ld [wTempWildMonSpecies], a
	ld [wCurPartySpecies], a
	ld hl, wDebugEnemy + dbg_LEVEL
	call DebugPeek
	ld [wCurPartyLevel], a
	xor a
	ld [wOtherTrainerClass], a
	ld a, BATTLETYPE_NORMAL
	ld [wBattleType], a
	ret

DebugReqPtr:
; c = offset into the request block -> hl = pointer (debug bank)
	ldh a, [hDebugNum]
	ld l, a
	ldh a, [hDebugNum + 1]
	ld h, a
	ld b, 0
	add hl, bc
	ret

DebugReqByte:
; c = offset -> a = request byte. Clobbers b, hl.
	call DebugReqPtr
	jp DebugPeek

DebugBasePtr:
; bc = offset into the party struct -> hl = pointer (WRAM bank 1)
	ldh a, [hDebugPtr]
	ld l, a
	ldh a, [hDebugPtr + 1]
	ld h, a
	add hl, bc
	ret

DebugBuildPartyMon:
; de = request block (debug bank), b = target party slot (must equal
; current wPartyCount). Builds the mon with the engine's own code, then
; applies the request's overrides and re-derives stats.
	; stash the request base
	ld a, e
	ldh [hDebugNum], a
	ld a, d
	ldh [hDebugNum + 1], a
	push bc

	; species and level drive TryAddMonToParty
	ld c, dbg_SPECIES
	call DebugReqPtr
	call DebugPeek
	ld e, a
	inc hl
	call DebugPeek
	ld h, a
	ld l, e
	call GetPokemonIDFromIndex
	ld [wCurPartySpecies], a
	ld c, dbg_LEVEL
	call DebugReqByte
	ld [wCurPartyLevel], a
	; wMonType is set by the caller: PARTYMON or OTPARTYMON
	predef TryAddMonToParty

	; stash the party struct base for slot b
	pop bc
	ld a, [wMonType]
	and a
	ld hl, wPartyMon1Species
	jr z, .got_base
	ld hl, wOTPartyMon1Species
.got_base
	ld a, b
	call GetPartyLocation
	ld a, l
	ldh [hDebugPtr], a
	ld a, h
	ldh [hDebugPtr + 1], a

	; --- item ---
	ld c, dbg_ITEM
	call DebugReqByte
	ld e, a
	ld bc, MON_ITEM
	call DebugBasePtr
	ld [hl], e

	; --- moves (all four zero = keep the learnset) ---
	ld c, dbg_MOVES
	call DebugReqPtr
	ld b, 8
	xor a
	ld e, a
.chk
	call DebugPeek
	or e
	ld e, a
	inc hl
	dec b
	jr nz, .chk
	and a
	jr z, .moves_done
	ld d, 0
.move_loop
	; d = move slot 0-3
	ld a, d
	add a
	add dbg_MOVES
	ld c, a
	call DebugReqPtr
	call DebugPeek
	ld e, a
	inc hl
	call DebugPeek
	ld h, a
	ld l, e
	or e
	jr z, .no_move
	push de
	call GetMoveIDFromIndex
	pop de
	jr .store_move
.no_move
	xor a
.store_move
	push af
	ld a, d
	add MON_MOVES
	ld c, a
	ld b, 0
	call DebugBasePtr
	pop af
	ld [hl], a
	inc d
	ld a, d
	cp NUM_MOVES
	jr c, .move_loop
	; refill PP from the new moves
	ld bc, MON_MOVES
	call DebugBasePtr
	push hl
	ld bc, MON_PP
	call DebugBasePtr
	ld e, l
	ld d, h
	pop hl
	predef FillPP
.moves_done

	; --- DVs ---
	ld c, dbg_DVS
	call DebugReqPtr
	call DebugPeek
	ld e, a
	inc hl
	call DebugPeek
	ld d, a
	ld bc, MON_DVS
	call DebugBasePtr
	ld [hl], e
	inc hl
	ld [hl], d

	; --- personality (ability slot), preserving the caught ball ---
	ld c, dbg_ABILSLOT
	call DebugReqByte
	and 3
	inc a ; 1, 2, 3
	swap a ; $10, $20, $30
	add a  ; $20, $40, $60
	and ABILITY_MASK
	ld e, a
	ld bc, MON_PERSONALITY
	call DebugBasePtr
	ld a, [hl]
	and CAUGHT_BALL_MASK
	or e
	ld [hl], a

	; --- status ---
	ld c, dbg_STATUS
	call DebugReqByte
	ld e, a
	ld bc, MON_STATUS
	call DebugBasePtr
	ld [hl], e

	; --- re-derive stats from the new DVs ---
	ld bc, 0 ; MON_SPECIES
	call DebugBasePtr
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ld bc, MON_LEVEL
	call DebugBasePtr
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld bc, MON_MAXHP
	call DebugBasePtr
	ld e, l
	ld d, h
	ld bc, MON_STAT_EXP - 1
	call DebugBasePtr
	ld b, TRUE
	predef CalcMonStats

	; --- HP percentage of the fresh max ---
	ld bc, MON_MAXHP
	call DebugBasePtr
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, c
	push bc
	ld c, dbg_HPPCT
	call DebugReqByte
	pop bc
	call DebugHPFromPercent ; bc = maxhp, a = pct -> bc = hp
	push bc
	ld bc, MON_HP
	call DebugBasePtr
	pop bc
	ld a, b
	ld [hli], a
	ld [hl], c
	ret

DebugHPFromPercent:
; bc = max HP (big endian b=high), a = percent (0 or >100 -> 100)
; returns bc = HP (big endian)
	and a
	jr z, .full
	cp 100
	jr c, .scale
.full
	ret
.scale
	; hMultiplicand(3) = maxhp, hMultiplier = pct
	push af
	xor a
	ldh [hMultiplicand + 0], a
	ld a, b
	ldh [hMultiplicand + 1], a
	ld a, c
	ldh [hMultiplicand + 2], a
	pop af
	ldh [hMultiplier], a
	call Multiply
	ld a, 100
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 2]
	ld b, a
	ldh a, [hQuotient + 3]
	ld c, a
	; never drop to 0 HP from a nonzero percent
	or b
	ret nz
	ld c, 1
	ret

; ==============================================================
; Trainer-mode OT party (hooked from InitEnemyTrainer, after
; ReadTrainerParty and before the first enemy send-out)
; ==============================================================

DebugModifyOTParty::
; Replace the trainer's read party with the request's enemy mons. The
; send-out then flows through the engine's own LoadEnemyMon, so entry
; abilities, status and items behave exactly as a real trainer's would.
	call DebugGetState
	cp DEBUGSTATE_INIT
	ret nz
	ld hl, wDebugEnemy2 + dbg_SPECIES
	call DebugPeek
	ld b, a
	inc hl
	call DebugPeek
	or b
	ret z ; wild-mode request that stumbled into a trainer: leave it be

	xor a
	ld [wOTPartyCount], a
	ld a, OTPARTYMON
	ld [wMonType], a
	ld de, wDebugEnemy
	ld b, 0
	call DebugBuildPartyMon
	ld a, OTPARTYMON
	ld [wMonType], a
	ld de, wDebugEnemy2
	ld b, 1
	call DebugBuildPartyMon
	xor a
	ld [wMonType], a
	ret

; ==============================================================
; Wild mon overrides (hooked from InitEnemyWildmon, pre entry abilities)
; ==============================================================

DebugModifyWildMon::
	call DebugGetState
	cp DEBUGSTATE_INIT
	ret nz

	ld de, wDebugEnemy

	; item
	ld hl, dbg_ITEM
	add hl, de
	call DebugPeek
	ld [wEnemyMonItem], a

	; DVs
	ld hl, dbg_DVS
	add hl, de
	call DebugPeek
	ld [wEnemyMonDVs], a
	inc hl
	call DebugPeek
	ld [wEnemyMonDVs + 1], a

	; moves (all-zero = keep learnset)
	ld hl, dbg_MOVES
	add hl, de
	ld b, 8
	xor a
.chk
	push af
	call DebugPeek
	ld c, a
	pop af
	or c
	inc hl
	dec b
	jr nz, .chk
	and a
	jr z, .moves_done
	ld hl, dbg_MOVES
	add hl, de
	ld bc, wEnemyMonMoves
	push de
	ld e, 4
.move_loop
	push bc
	call DebugPeek
	ld b, a
	inc hl
	call DebugPeek
	ld c, a
	inc hl
	ld a, c
	or b
	jr z, .no_move
	push hl
	ld l, b
	ld h, c
	call GetMoveIDFromIndex
	pop hl
	jr .store
.no_move
	xor a
.store
	pop bc
	ld [bc], a
	inc bc
	dec e
	jr nz, .move_loop
	pop de
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	push de
	predef FillPP
	pop de
	ld de, wDebugEnemy
.moves_done

	; keep the Sketch/Mimic-visible copies in sync
	ld hl, wEnemyMonMoves
	ld de, wWildMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	ld hl, wEnemyMonPP
	ld de, wWildMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	ld de, wDebugEnemy

	; personality / ability
	ld hl, dbg_ABILSLOT
	add hl, de
	call DebugPeek
	and 3
	inc a
	swap a
	add a
	and ABILITY_MASK
	ld [wEnemyMonPersonality], a
	call SetEnemyAbility

	; status
	ld hl, dbg_STATUS
	add hl, de
	call DebugPeek
	ld [wEnemyMonStatus], a

	; stats from the new DVs
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wEnemyMonLevel]
	ld [wCurPartyLevel], a
	ld de, wEnemyMonMaxHP
	ld hl, wEnemyMonDVs - (MON_DVS - MON_STAT_EXP + 1)
	ld b, FALSE
	predef CalcMonStats

	; HP percentage
	ld a, [wEnemyMonMaxHP]
	ld b, a
	ld a, [wEnemyMonMaxHP + 1]
	ld c, a
	ld de, wDebugEnemy
	ld hl, dbg_HPPCT
	add hl, de
	call DebugPeek
	call DebugHPFromPercent
	ld a, b
	ld [wEnemyMonHP], a
	ld a, c
	ld [wEnemyMonHP + 1], a

	; refresh the unmodified-stats mirror the engine keeps
	ld hl, wEnemyMonStats
	ld de, wEnemyStats
	ld bc, wEnemyMonStatsEnd - wEnemyMonStats
	call CopyBytes
	farcall ApplyStatusEffectOnEnemyStats
	ret

; ==============================================================
; Per-turn hook (BattleTurn loop top)
; ==============================================================

DebugBattleTurnHook::
	call DebugGetState
	cp DEBUGSTATE_INIT
	jr z, .first_turn
	cp DEBUGSTATE_READY
	jr z, .ready
	and a ; clear carry
	ret

.first_turn
	call DebugApplyPostEntry
	ld a, DEBUGSTATE_READY
	call DebugSetState
.ready
	ldh a, [hDebugActive]
	and a
	ret z ; hand mode: nothing else to do (carry clear)

	; auto mode: pause when the requested turn count is reached
.check_turns
	ld hl, wDebugTurnsDone
	call DebugPeek
	ld b, a
	ld hl, wDebugTurnTarget
	call DebugPeek
	cp b
	jr z, .wait
	jr c, .wait ; done >= target
	; run another turn
	ld a, b
	inc a
	ld hl, wDebugTurnsDone
	call DebugPoke
	and a
	ret

.wait
	ld a, DEBUGSTATE_WAIT
	call DebugSetState
.wait_loop
	call DelayFrame
	ld hl, wDebugControl
	call DebugPeek
	and a
	jr z, .wait_loop
	push af
	xor a
	ld hl, wDebugControl
	call DebugPoke
	pop af
	cp DEBUGCTL_END
	jr z, .end_battle
	; continue: harness raised wDebugTurnTarget
	ld a, DEBUGSTATE_READY
	call DebugSetState
	jr .check_turns

.end_battle
	ld a, 1
	ld [wBattleEnded], a
	ld a, DRAW
	ld [wBattleResult], a
	scf
	ret

DebugApplyPostEntry:
; Runs once, after switch-in and entry abilities: stat stages, weather,
; screens, ability overrides. Only fields the request explicitly set.
	; player stat stages
	ld hl, wDebugPlayer1 + dbg_STATLEVELS
	call DebugPeek
	and a
	jr z, .no_p_stages
	ld hl, wDebugPlayer1 + dbg_STATLEVELS
	ld de, wPlayerStatLevels
	ld c, NUM_LEVEL_STATS
	call DebugCopyFromRequest
.no_p_stages
	ld hl, wDebugEnemy + dbg_STATLEVELS
	call DebugPeek
	and a
	jr z, .no_e_stages
	ld hl, wDebugEnemy + dbg_STATLEVELS
	ld de, wEnemyStatLevels
	ld c, NUM_LEVEL_STATS
	call DebugCopyFromRequest
.no_e_stages

	; weather
	ld hl, wDebugWeather
	call DebugPeek
	cp $ff
	jr z, .no_weather
	ld [wBattleWeather], a
	and a
	jr z, .no_weather
	ld a, $ff
	ld [wWeatherCount], a
.no_weather

	; screens
	ld hl, wDebugPScreens
	call DebugPeek
	and a
	jr z, .no_p_screens
	ld b, a
	ld a, [wPlayerScreens]
	or b
	ld [wPlayerScreens], a
	ld a, 5
	ld [wPlayerLightScreenCount], a
	ld [wPlayerReflectCount], a
.no_p_screens
	ld hl, wDebugEScreens
	call DebugPeek
	and a
	jr z, .no_e_screens
	ld b, a
	ld a, [wEnemyScreens]
	or b
	ld [wEnemyScreens], a
	ld a, 5
	ld [wEnemyLightScreenCount], a
	ld [wEnemyReflectCount], a
.no_e_screens

	; substatus masks (Mist, Toxic, Substitute...) - ORed in, like screens
	ld hl, wDebugPlayer1 + dbg_SUBSTATUS
	ld de, wPlayerSubStatus1
	call DebugApplySubstatus
	ld hl, wDebugEnemy + dbg_SUBSTATUS
	ld de, wEnemySubStatus1
	call DebugApplySubstatus

	; ability overrides (for testing an ability on a species that can't
	; legally have it; entry abilities will already have run as the real
	; ability, so prefer legal slots when that matters)
	ld hl, wDebugPlayer1 + dbg_ABILOVERRIDE
	call DebugPeek
	and a
	jr z, .no_p_abil
	ld [wPlayerAbility], a
.no_p_abil
	ld hl, wDebugEnemy + dbg_ABILOVERRIDE
	call DebugPeek
	and a
	jr z, .no_e_abil
	ld [wEnemyAbility], a
.no_e_abil
	ret

DebugApplySubstatus:
; OR 5 request bytes at hl (debug bank) into the 5 substatus bytes at de.
	ld c, 5
.loop
	call DebugPeek
	inc hl
	ld b, a
	ld a, [de]
	or b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

; ==============================================================
; Auto-mode party pick (hooked from PickPartyMonInBattle)
; ==============================================================

DebugPickPartyMon::
; Replaces the in-battle party menu in auto mode: pick the first party
; slot that is fit to fight and not already out, without any UI. Covers
; the post-faint forced switch, Baton Pass and U-turn. Returns nc
; ("a choice was made"; the interactive menu's cancel path is carry).
	ld a, [wPartyCount]
	ld c, a
	ld b, 0 ; slot under consideration
.loop
	ld a, [wCurBattleMon]
	cp b
	jr z, .next ; already out (or just fainted in this slot)
	push bc
	ld a, b
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	jr nz, .found
.next
	inc b
	dec c
	jr nz, .loop
	ld b, 0 ; no fit mon (callers should have checked); fall back to 0
.found
	ld a, b
	ld [wCurPartyMon], a
	and a
	ret

; ==============================================================
; Auto-mode player move choice (hooked from ParsePlayerAction)
; ==============================================================

DebugChoosePlayerMove::
	; turn index = wDebugTurnsDone - 1 (hook already counted this turn)
	ld hl, wDebugTurnsDone
	call DebugPeek
	and a
	jr z, .first
	dec a
.first
	cp 8
	jr c, .in_range
	ld a, 7
.in_range
	ld e, a
	ld d, 0
	ld hl, wDebugMoveScript
	add hl, de
	call DebugPeek
	and a
	jr nz, .have_slot
	inc a ; default slot 1
.have_slot
	dec a
	and 3
	ld [wCurMoveNum], a
	ld e, a
	ld d, 0
	ld hl, wBattleMonMoves
	add hl, de
	ld a, [hl]
	and a
	jr nz, .have_move
	ld a, [wBattleMonMoves] ; empty slot: fall back to slot 1
	push af
	xor a
	ld [wCurMoveNum], a
	pop af
.have_move
	ld [wCurPlayerMove], a
	ret

; ==============================================================
; Teardown: restore the real party, drop the modes
; ==============================================================

DebugBattleTeardown::
	xor a
	ldh [hDebugActive], a
	ldh [hDebugRNGMode], a
	call DebugRestoreParty
	ld a, DEBUGSTATE_DONE
	call DebugSetState
	ret

DebugBackupParty:
; Party structs, names and dex flags: wPartyCount..wEndPokedexSeen
; (WRAM bank 1) -> wDebugPartyBackup (debug bank).
	ld hl, wDebugPartyBackedUp
	call DebugPeek
	and a
	ret nz ; already backed up
	ld a, 1
	ld hl, wDebugPartyBackedUp
	call DebugPoke
	ld hl, wPartyCount
	ld de, wDebugPartyBackup
	ld bc, wEndPokedexSeen - wPartyCount
.loop
	ld a, 1
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, 1
	ldh [rSVBK], a
	ret

DebugRestoreParty:
	ld hl, wDebugPartyBackedUp
	call DebugPeek
	and a
	ret z
	xor a
	ld hl, wDebugPartyBackedUp
	call DebugPoke
	ld hl, wDebugPartyBackup
	ld de, wPartyCount
	ld bc, wEndPokedexSeen - wPartyCount
.loop
	ld a, DEBUG_WRAM_BANK
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, 1
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

; ==============================================================
; The debug menu (start menu -> DEBUG)
; ==============================================================

DebugBattleTesterUI::
; Returns carry to launch the battle, nc to close the menu.
	call DebugOpenWRAM
	ld a, $ee ; entry marker (diagnostics)
	ld [wDebugMenuStep], a
	call DebugCloseWRAM
	call DebugInitDefaults
	ld a, DEBUGSTATE_MENU
	call DebugSetState
	call ClearBGPalettes
	call ClearTileMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetPalettes
	xor a
	ld hl, wDebugMenuRow
	call DebugPoke
	call DebugMenuRedraw
.loop
	call JoyTextDelay
	call DelayFrame

	; harness request?
	ld hl, wDebugMagic
	call DebugPeek
	cp $cc
	jr z, .launch

	ldh a, [hJoyPressed]
	bit B_BUTTON_F, a
	jr nz, .exit
	bit START_F, a
	jr nz, .launch
	bit SELECT_F, a
	jr nz, .next_page
	ldh a, [hJoyLast]
	and D_UP | D_DOWN | D_LEFT | D_RIGHT | A_BUTTON
	jr z, .loop
	call DebugMenuInput
	call DebugMenuRedraw
	jr .loop

.next_page
	ld hl, wDebugMenuPage
	call DebugPeek
	inc a
	cp 3
	jr c, .page_ok
	xor a
.page_ok
	ld hl, wDebugMenuPage
	call DebugPoke
	xor a
	ld hl, wDebugMenuRow
	call DebugPoke
	call DebugMenuRedraw
	jr .loop

.exit
	ld a, DEBUGSTATE_IDLE
	call DebugSetState
	and a
	ret

.launch
	scf
	ret

DebugInitDefaults:
; First open: sensible defaults, no overrides.
	ld hl, wDebugMenuStep
	call DebugPeek
	cp $a5
	ret z
	ld a, $a5
	ld hl, wDebugMenuStep
	call DebugPoke

	call DebugOpenWRAM
	; zero the whole control + request area
	ld hl, wDebugMagic
	ld bc, wDebugPartyBackedUp - wDebugMagic
.zero
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .zero

	ld a, $ff
	ld [wDebugWeather], a
	ld a, 3
	ld [wDebugTurnTarget], a

	ld hl, wDebugPlayer1
	call .default_side
	ld hl, wDebugEnemy
	call .default_side
	call DebugCloseWRAM
	ret

.default_side
	push hl
	ld a, 1 ; species index 1
	ld [hl], a
	pop hl
	push hl
	ld de, dbg_LEVEL
	add hl, de
	ld a, 50
	ld [hl], a
	pop hl
	push hl
	ld de, dbg_DVS
	add hl, de
	ld a, $ff
	ld [hli], a
	ld [hl], a
	pop hl
	push hl
	ld de, dbg_HPPCT
	add hl, de
	ld a, 100
	ld [hl], a
	pop hl
	ret

; ---- menu drawing ----

DebugMenuRedraw:
	call ClearTileMap
	ld hl, wDebugMenuPage
	call DebugPeek
	and a
	jr z, .player
	cp 1
	jr z, .enemy
	; options page
	hlcoord 1, 0
	ld de, DebugStrOptions
	call PlaceString
	call DebugDrawOptionsPage
	jr .cursor
.player
	hlcoord 1, 0
	ld de, DebugStrPlayer
	call PlaceString
	ld de, wDebugPlayer1
	call DebugDrawMonPage
	jr .cursor
.enemy
	hlcoord 1, 0
	ld de, DebugStrEnemy
	call PlaceString
	ld de, wDebugEnemy
	call DebugDrawMonPage
.cursor
	; cursor: column 0 of the selected row
	ld hl, wDebugMenuRow
	call DebugPeek
	inc a
	ld hl, wTileMap
	ld de, SCREEN_WIDTH
.mul
	and a
	jr z, .at_row
	add hl, de
	dec a
	jr .mul
.at_row
	ld [hl], "▶"
	; footer: name of the selected value
	call DebugDrawDetail
	call WaitBGMap
	ret

DebugDrawMonPage:
; de = block base. Rows 0-11 at screen rows 1-12.
	push de
	hlcoord 1, 1
	ld de, DebugStrMonLabels
	call PlaceString
	pop de
	; values
	ld c, 0
.row_loop
	push bc
	push de
	call DebugGetRowSpec ; hl = value ptr, b = flags
	call DebugPrintRowValue
	pop de
	pop bc
	inc c
	ld a, c
	cp 12
	jr c, .row_loop
	ret

DebugDrawOptionsPage:
	hlcoord 1, 1
	ld de, DebugStrOptLabels
	call PlaceString
	; weather value
	ld hl, wDebugWeather
	call DebugPeek
	hlcoord 14, 1
	cp $ff
	jr nz, .weather_num
	ld de, DebugStrOff
	call PlaceString
	jr .rng
.weather_num
	call DebugPrintByteA
.rng
	ld hl, wDebugRNGModeReq
	call DebugPeek
	hlcoord 14, 2
	call DebugPrintByteA
	ld hl, wDebugRNGValueReq
	call DebugPeek
	hlcoord 14, 3
	call DebugPrintByteA
	ld hl, wDebugTurnTarget
	call DebugPeek
	hlcoord 14, 4
	call DebugPrintByteA
	ret

DebugPrintByteA:
; print byte in a at hl as 3 digits
	ldh [hDebugNum], a
	ld de, hDebugNum
	lb bc, 1, 3
	call PrintNum
	ret

DebugPrintWord:
; print word (big endian in hDebugNum) at hl as 5 digits
	ld de, hDebugNum
	lb bc, 2, 5
	call PrintNum
	ret

DebugGetRowSpec:
; c = row (0-11), de = block base
; out: hl = value address (debug bank), b = 1 if 16-bit else 0
	ld b, 0
	ld a, c
	and a
	jr nz, .not_species
	ld l, e
	ld h, d
	ld b, 1
	ret
.not_species
	cp 1
	jr nz, .not_level
	ld hl, dbg_LEVEL
	add hl, de
	ret
.not_level
	cp 2
	jr nz, .not_slot
	ld hl, dbg_ABILSLOT
	add hl, de
	ret
.not_slot
	cp 3
	jr nz, .not_ovr
	ld hl, dbg_ABILOVERRIDE
	add hl, de
	ret
.not_ovr
	cp 4
	jr nz, .not_item
	ld hl, dbg_ITEM
	add hl, de
	ret
.not_item
	cp 9
	jr nc, .not_move
	; rows 5-8: moves
	sub 5
	add a
	ld l, a
	ld h, 0
	ld a, dbg_MOVES
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	add hl, de
	ld b, 1
	ret
.not_move
	cp 9
	jr nz, .not_dvs
	ld hl, dbg_DVS
	add hl, de
	ld b, 1
	ret
.not_dvs
	cp 10
	jr nz, .not_hp
	ld hl, dbg_HPPCT
	add hl, de
	ret
.not_hp
	ld hl, dbg_STATUS
	add hl, de
	ret

DebugPrintRowValue:
; hl = value ptr (debug bank), b = 16-bit flag, c = row
	; read the value into hDebugNum (big endian) first, while hl is live
	push bc
	call DebugPeek ; low byte (clobbers c)
	ldh [hDebugNum + 1], a
	pop bc
	push bc
	ld a, b
	and a
	jr z, .byte
	inc hl
	call DebugPeek ; high byte
	jr .have_high
.byte
	xor a
.have_high
	ldh [hDebugNum], a
	pop bc
	; coord: row c+1, col 14
	ld a, c
	inc a
	call DebugCoordCol14
	ld a, b
	and a
	jr nz, .print_word
	; print the low byte only, 3 digits
	ldh a, [hDebugNum + 1]
	jp DebugPrintByteA
.print_word
	jp DebugPrintWord

DebugCoordCol14:
; a = screen row -> hl = tilemap addr at column 14
	ld hl, wTileMap + 14
	ld de, SCREEN_WIDTH
.loop
	and a
	ret z
	add hl, de
	dec a
	jr .loop

DebugDrawDetail:
; Footer (rows 14-16): name for the selected row's value.
	ld hl, wDebugMenuPage
	call DebugPeek
	cp 2
	ret z ; no names on the options page
	and a
	ld de, wDebugPlayer1
	jr z, .have_block
	ld de, wDebugEnemy
.have_block
	ld hl, wDebugMenuRow
	call DebugPeek
	ld c, a
	and a
	jr z, .species_name
	cp 4
	jr z, .item_name
	cp 5
	jr c, .none
	cp 9
	jr c, .move_name
.none
	ret

.species_name
	; 16-bit index -> name
	ld l, e
	ld h, d
	call DebugPeek
	ld c, a
	inc hl
	call DebugPeek
	ld b, a
	push bc
	pop hl
	call DebugSpeciesNameByIndex
	hlcoord 1, 14
	ld de, wStringBuffer1
	call PlaceString
	ret

.item_name
	ld hl, dbg_ITEM
	add hl, de
	call DebugPeek
	and a
	ret z
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	hlcoord 1, 14
	ld de, wStringBuffer1
	call PlaceString
	ret

.move_name
	ld a, c
	sub 5
	add a
	ld l, a
	ld h, 0
	ld c, dbg_MOVES
	ld b, 0
	add hl, bc
	add hl, de
	call DebugPeek
	ld c, a
	inc hl
	call DebugPeek
	ld b, a
	ld a, b
	or c
	ret z
	push bc
	pop hl
	call DebugMoveNameByIndex
	hlcoord 1, 14
	ld de, wStringBuffer1
	call PlaceString
	ret

DebugSpeciesNameByIndex:
; hl = 16-bit species index -> wStringBuffer1 (10 chars + @)
	ld a, l
	or h
	jr z, .bad
	; offset = (index - 1) * 10
	dec hl
	push hl
	add hl, hl ; x2
	add hl, hl ; x4
	pop de
	add hl, de ; x5
	add hl, hl ; x10
	ld de, PokemonNames
	add hl, de
	ld a, BANK(PokemonNames)
	ld de, wStringBuffer1
	ld bc, 10
	call FarCopyBytes
	ld a, "@"
	ld [wStringBuffer1 + 10], a
	ret
.bad
	ld a, "@"
	ld [wStringBuffer1], a
	ret

DebugMoveNameByIndex:
; hl = 16-bit move index -> wStringBuffer1
	ld a, l
	or h
	jr z, .bad
	dec hl
	ld c, l
	ld b, h
	ldh a, [hROMBank]
	push af
	ld a, BANK(MoveNames)
	rst Bankswitch
	ld hl, MoveNames
	call GetNthString16
	ld de, wStringBuffer1
	ld bc, MOVE_NAME_LENGTH
	call CopyBytes
	pop af
	rst Bankswitch
	ret
.bad
	ld a, "@"
	ld [wStringBuffer1], a
	ret

; ---- menu input ----

DebugMenuInput:
	ldh a, [hJoyLast]
	bit D_UP_F, a
	jr nz, .up
	bit D_DOWN_F, a
	jr nz, .down
	bit D_LEFT_F, a
	jr nz, .dec1
	bit D_RIGHT_F, a
	jr nz, .inc1
	bit A_BUTTON_F, a
	jr nz, .inc10
	ret

.up
	ld hl, wDebugMenuRow
	call DebugPeek
	and a
	ret z
	dec a
	ld hl, wDebugMenuRow
	call DebugPoke
	ret

.down
	call DebugMenuMaxRow
	ld b, a
	ld hl, wDebugMenuRow
	call DebugPeek
	cp b
	ret nc
	inc a
	ld hl, wDebugMenuRow
	call DebugPoke
	ret

.dec1
	ld de, -1
	jr DebugMenuAdjust
.inc1
	ld de, 1
	jr DebugMenuAdjust
.inc10
	ld de, 10
	jr DebugMenuAdjust

DebugMenuMaxRow:
	ld hl, wDebugMenuPage
	call DebugPeek
	cp 2
	ld a, 11
	ret nz
	ld a, 3
	ret

DebugMenuAdjust:
; de = signed delta
	ld hl, wDebugMenuPage
	call DebugPeek
	cp 2
	jp z, DebugAdjustOption
	and a
	push de
	ld de, wDebugPlayer1
	jr z, .have_block
	ld de, wDebugEnemy
.have_block
	ld hl, wDebugMenuRow
	call DebugPeek
	ld c, a
	call DebugGetRowSpec ; hl = ptr, b = word flag
	pop de
	ld a, b
	and a
	jr nz, .word

	; byte field with per-row clamps
	push hl
	call DebugPeek
	add e ; delta low byte is enough for bytes
	pop hl
	push hl
	push af
	call DebugByteRowMax
	ld b, a
	pop af
	cp b
	jr c, .store_byte
	; wrapped below 0 or above max
	bit 7, e
	jr nz, .to_max
	xor a
	jr .store_byte
.to_max
	ld a, b
.store_byte
	pop hl
	call DebugPoke
	ret

.word
	push hl
	call DebugPeek
	ld c, a
	inc hl
	call DebugPeek
	ld h, a
	ld l, c ; hl = value
	add hl, de
	; clamp: species 1..NUM_POKEMON, moves 0..NUM_ATTACKS, dvs 0..$ffff
	; (cheap: just mask into range by checking high bound)
	ld c, l
	ld b, h
	pop hl
	push hl
	call DebugWordRowMax ; de = max
	ld a, b
	cp d
	jr c, .word_ok
	jr nz, .word_clamp
	ld a, c
	cp e
	jr c, .word_ok
	jr z, .word_ok
.word_clamp
	; over max: wrap to 0 (or 1 for species)
	ld bc, 0
.word_ok
	pop hl
	push hl
	ld a, c
	call DebugPoke
	pop hl
	inc hl
	ld a, b
	call DebugPoke
	ret

DebugByteRowMax:
; c = row -> a = max value for byte rows
	ld a, c
	cp 1
	jr nz, .not_level
	ld a, 100
	ret
.not_level
	cp 2
	jr nz, .not_slot
	ld a, 2
	ret
.not_slot
	cp 3
	jr nz, .not_ovr
	ld a, NUM_ABILITIES
	ret
.not_ovr
	cp 10
	jr nz, .not_hp
	ld a, 100
	ret
.not_hp
	cp 11
	jr nz, .not_status
	ld a, $ff
	ret
.not_status
	ld a, $ff ; item
	ret

DebugWordRowMax:
; c = row -> de = max
	ld a, c
	and a
	jr nz, .not_species
	ld de, NUM_POKEMON
	ret
.not_species
	cp 9
	jr nz, .not_dvs
	ld de, $ffff
	ret
.not_dvs
	ld de, NUM_ATTACKS
	ret

DebugAdjustOption:
	ld hl, wDebugMenuRow
	call DebugPeek
	and a
	jr z, .weather
	cp 1
	jr z, .rngmode
	cp 2
	jr z, .rngval
	; turns
	ld hl, wDebugTurnTarget
	call DebugPeek
	add e
	ld hl, wDebugTurnTarget
	call DebugPoke
	ret
.weather
	ld hl, wDebugWeather
	call DebugPeek
	add e
	cp 5
	jr c, .weather_ok
	ld a, $ff ; off
.weather_ok
	ld hl, wDebugWeather
	call DebugPoke
	ret
.rngmode
	ld hl, wDebugRNGModeReq
	call DebugPeek
	add e
	cp 3
	jr c, .rng_ok
	xor a
.rng_ok
	ld hl, wDebugRNGModeReq
	call DebugPoke
	ret
.rngval
	ld hl, wDebugRNGValueReq
	call DebugPeek
	add e
	ld hl, wDebugRNGValueReq
	call DebugPoke
	ret

; ---- strings ----

DebugStrPlayer:
	db "DEBUG:PLAYER@"
DebugStrEnemy:
	db "DEBUG:ENEMY@"
DebugStrOptions:
	db "DEBUG:OPTIONS@"
DebugStrOff:
	db "OFF@"

DebugStrMonLabels:
	db "SPECIES<LF>"
	db "LEVEL<LF>"
	db "ABIL SLOT<LF>"
	db "ABIL OVR<LF>"
	db "ITEM<LF>"
	db "MOVE1<LF>"
	db "MOVE2<LF>"
	db "MOVE3<LF>"
	db "MOVE4<LF>"
	db "DVS<LF>"
	db "HP PCT<LF>"
	db "STATUS@"

DebugStrOptLabels:
	db "WEATHER<LF>"
	db "RNG MODE<LF>"
	db "RNG VALUE<LF>"
	db "TURNS@"
