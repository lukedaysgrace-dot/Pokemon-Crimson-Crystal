_BugContestJudging:
	call ContestScore
	farcall StubbedTrainerRankings_BugContestScore
	call BugContest_JudgeContestants
	ld a, [wBugContestThirdPlaceWinnerID]
	call LoadContestantName
	ld a, [wBugContestThirdPlaceMon]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, BugContest_ThirdPlaceText
	call PrintText
	ld a, [wBugContestSecondPlaceWinnerID]
	call LoadContestantName
	ld a, [wBugContestSecondPlaceMon]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, BugContest_SecondPlaceText
	call PrintText
	ld a, [wBugContestFirstPlaceWinnerID]
	call LoadContestantName
	ld a, [wBugContestFirstPlaceMon]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, BugContest_FirstPlaceText
	call PrintText
	jp BugContest_GetPlayersResult

BugContest_FirstPlaceText:
	text_far ContestJudging_FirstPlaceText
	text_asm
	ld de, SFX_1ST_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, BugContest_FirstPlaceScoreText
	ret

BugContest_FirstPlaceScoreText:
	; The winning score was @  points!
	text_far ContestJudging_FirstPlaceScoreText
	text_end

BugContest_SecondPlaceText:
	; Placing second was @ , who caught a @ !@ @
	text_far ContestJudging_SecondPlaceText
	text_asm
	ld de, SFX_2ND_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, BugContest_SecondPlaceScoreText
	ret

BugContest_SecondPlaceScoreText:
	; The score was @  points!
	text_far ContestJudging_SecondPlaceScoreText
	text_end

BugContest_ThirdPlaceText:
	; Placing third was @ , who caught a @ !@ @
	text_far ContestJudging_ThirdPlaceText
	text_asm
	ld de, SFX_3RD_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, BugContest_ThirdPlaceScoreText
	ret

BugContest_ThirdPlaceScoreText:
	; The score was @  points!
	text_far ContestJudging_ThirdPlaceScoreText
	text_end

LoadContestantName:
; If a = 1, get your name.
	dec a ; BUG_CONTEST_PLAYER
	jr z, .player
; Find the pointer for the trainer class of the Bug Catching Contestant whose ID is in a.
	ld c, a
	ld b, 0
	ld hl, BugContestantPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
; Copy the Trainer Class to c.
	ld a, [hli]
	ld c, a
; Save hl and bc for later.
	push hl
	push bc
; Get the Trainer Class name and copy it into wBugContestWinnerName.
	callfar GetTrainerClassName
	ld hl, wStringBuffer1
	ld de, wBugContestWinnerName
	ld bc, TRAINER_CLASS_NAME_LENGTH
	call CopyBytes
	ld hl, wBugContestWinnerName
; Delete the trailing terminator and replace it with a space.
.next
	ld a, [hli]
	cp "@"
	jr nz, .next
	dec hl
	ld [hl], " "
	inc hl
	ld d, h
	ld e, l
; Restore the Trainer Class ID and Trainer ID pointer.  Save de for later.
	pop bc
	pop hl
	push de
; Get the name of the trainer with class c and ID b.
	ld a, [hl]
	ld b, a
	callfar GetTrainerName
; Append the name to wBugContestWinnerName.
	ld hl, wStringBuffer1
	pop de
	ld bc, NAME_LENGTH - 1
	jp CopyBytes

.player
	ld hl, wPlayerName
	ld de, wBugContestWinnerName
	ld bc, NAME_LENGTH
	jp CopyBytes

INCLUDE "data/events/bug_contest_winners.asm"

BugContest_GetPlayersResult:
	ld hl, wBugContestThirdPlaceWinnerID
	ld de, - BUG_CONTESTANT_SIZE
	ld b, 3 ; 3rd, 2nd, or 1st
.loop
	ld a, [hl]
	cp BUG_CONTEST_PLAYER
	jr z, .done
	add hl, de
	dec b
	jr nz, .loop

.done
	ret

BugContest_JudgeContestants:
	call ClearContestResults
	call ComputeAIContestantScores
	ld hl, wBugContestTempWinnerID
	ld a, BUG_CONTEST_PLAYER
	ld [hli], a
	ld a, [wContestMon]
	ld [hli], a
	ldh a, [hProduct]
	ld [hli], a
	ldh a, [hProduct + 1]
	ld [hl], a
	call DetermineContestWinners
	ret

ClearContestResults:
	ld hl, wBugContestResults
	ld b, wBugContestWinnersEnd - wBugContestResults
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

DetermineContestWinners:
	ld de, wBugContestTempScore
	ld hl, wBugContestFirstPlaceScore
	ld c, 2
	call CompareBytes
	jr c, .not_first_place
	ld hl, wBugContestSecondPlaceWinnerID
	ld de, wBugContestThirdPlaceWinnerID
	ld bc, BUG_CONTESTANT_SIZE
	call CopyBytes
	ld hl, wBugContestFirstPlaceWinnerID
	ld de, wBugContestSecondPlaceWinnerID
	ld bc, BUG_CONTESTANT_SIZE
	call CopyBytes
	ld hl, wBugContestFirstPlaceWinnerID
	call CopyTempContestant
	jr .done

.not_first_place
	ld de, wBugContestTempScore
	ld hl, wBugContestSecondPlaceScore
	ld c, 2
	call CompareBytes
	jr c, .not_second_place
	ld hl, wBugContestSecondPlaceWinnerID
	ld de, wBugContestThirdPlaceWinnerID
	ld bc, BUG_CONTESTANT_SIZE
	call CopyBytes
	ld hl, wBugContestSecondPlaceWinnerID
	call CopyTempContestant
	jr .done

.not_second_place
	ld de, wBugContestTempScore
	ld hl, wBugContestThirdPlaceScore
	ld c, 2
	call CompareBytes
	jr c, .done
	ld hl, wBugContestThirdPlaceWinnerID
	call CopyTempContestant

.done
	ret

CopyTempContestant:
; Could've just called CopyBytes.
	ld de, wBugContestTempWinnerID
rept BUG_CONTESTANT_SIZE + -1
	ld a, [de]
	inc de
	ld [hli], a
endr
	ld a, [de]
	inc de
	ld [hl], a
	ret

ComputeAIContestantScores:
	ld e, 0
.loop
	push de
	call CheckBugContestContestantFlag
	pop de
	jr nz, .done
	ld a, e
	inc a
	inc a
	ld [wBugContestTempWinnerID], a
	dec a
	ld c, a
	ld b, 0
	ld hl, BugContestantPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
.loop2
	; 0, 1, or 2 for 1st, 2nd, or 3rd
	call Random
	and 3
	cp 3
	jr z, .loop2
	add a, a
	add a, a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call GetPokemonIDFromIndex
	pop hl
	inc hl
	ld [wBugContestTempMon], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; randomly perturb score
	call Random
	and %111
	ld c, a
	ld b, 0
	add hl, bc
	ld a, h
	ld [wBugContestTempScore], a
	ld a, l
	ld [wBugContestTempScore + 1], a
	push de
	call DetermineContestWinners
	pop de

.done
	inc e
	ld a, e
	cp NUM_BUG_CONTESTANTS
	jr nz, .loop
	ret

ContestScore:
; Determine the player's score in the Bug Catching Contest.
;
;   score = species value    (ContestMonScoreValues, 40-145)
;         + level * 3        (21-54 at contest levels)
;         + condition bonus  (0-60, scaled by remaining HP)
;         + park balls left * 2
;
; Nothing here reads stats or DVs. Every caught mon gets perfect DVs
; (see .copywildmonDVs in engine/pokemon/move_mon.asm), so any stat-derived
; term is the same constant for every catch and can't tell them apart.
;
; Result is stored big endian in hProduct for BugContest_JudgeContestants.

	ld hl, 0

	ld a, [wContestMonSpecies]
	and a
	jr z, .store ; nothing was caught

	; Species value.
	call GetPokemonIndexFromID
	ld d, h
	ld e, l
	call .SpeciesValue
	ld l, a
	ld h, 0

	; Level * 3.
	ld a, [wContestMonLevel]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc

	; Park Balls left * 2. Rewards catching cleanly instead of spamming.
	ld a, [wParkBallsRemaining]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc

	; Condition bonus. Rewards catching it without beating it half to death.
	push hl
	call .ConditionBonus
	ld c, a
	ld b, 0
	pop hl
	add hl, bc

.store
	ld a, h
	ldh [hProduct], a
	ld a, l
	ldh [hProduct + 1], a
	ret

.SpeciesValue:
; in: de = 16-bit species index
; out: a = that species' contest value
	ld hl, ContestMonScoreValues
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .default ; a zero index terminates the table
	ld a, [hli]
	push af
	ld a, c
	cp e
	jr nz, .next
	ld a, b
	cp d
	jr z, .found
.next
	pop af
	jr .loop

.found
	pop af
	ret

.default
	ld a, [hl]
	ret

.ConditionBonus:
; out: a = 0-60, scaled by the fraction of HP the caught mon has left
	ld a, [wContestMonMaxHP + 1]
	and a
	ret z ; never divide by zero

	ld b, a ; divisor, preserved across Multiply

	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wContestMonHP + 1]
	ldh [hMultiplicand + 2], a
	ld a, 60
	ldh [hMultiplier], a
	call Multiply

	; hProduct and hDividend are the same four bytes, so the product is
	; already in place as the dividend.
	ld a, b
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 3]
	ret

ContestMonScoreValues:
; What each mon in the contest pool is worth to the judges.
; Rarity and prestige, deliberately not base stats.
	dw CATERPIE
	db  40
	dw WEEDLE
	db  40
	dw METAPOD
	db  55
	dw KAKUNA
	db  55
	dw PARAS
	db  70
	dw VENONAT
	db  70
	dw BUTTERFREE
	db 100
	dw BEEDRILL
	db 100
	dw SHUCKLE
	db 110
	dw VENOMOTH
	db 115
	dw SCYTHER
	db 130
	dw PINSIR
	db 130
	dw HERACROSS
	db 145
	dw 0 ; end
	db  70 ; value for anything not listed above
