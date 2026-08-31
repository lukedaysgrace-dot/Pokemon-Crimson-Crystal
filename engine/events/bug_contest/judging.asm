_BugContestJudging:
	call ContestScore
	ldh a, [hProduct]
	ld [wBugContestPlayerScore], a
	ldh a, [hProduct + 1]
	ld [wBugContestPlayerScore + 1], a
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
	call BugContest_PrintPlayerScore
	jp BugContest_GetPlayersResult

BugContest_PrintPlayerScore:
; Coming fourth used to tell you nothing at all. Say what the judges gave you.
	ld a, [wContestMon]
	and a
	ret z ; caught nothing, so there is nothing to score
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, BugContest_PlayerScoreText
	jp PrintText

BugContest_PlayerScoreText:
	; Your @  scored @  points!
	text_far ContestJudging_PlayerScoreText
	text_end

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
	; ContestScore saved this before the ranking and AI calls.  Do not depend
	; on those calls preserving the shared multiply/divide scratch registers.
	ld a, [wBugContestPlayerScore]
	ld [hli], a
	ld a, [wBugContestPlayerScore + 1]
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
	; Randomly perturb the score. Widened from 0-7 to 0-15 for the 250-point
	; scale: at 0-7 the field bunched up so tightly that a 175 almost never
	; won and a 180 almost always did. Now the same catch can go either way.
	call Random
	and %1111
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
;   score = rarity            (0-70,  how hard the species is to run into)
;         + level percentile  (0-150, how big it is for its own species)
;         + clean catch bonus (0-30,  Park Balls spent on the mon you kept)
;
; The maximum is 250, so a perfect CATERPIE (180) beats a runty HERACROSS.
; Rarity is a head start, not a verdict.
;
; Nothing here reads stats, DVs or HP. Every caught mon gets perfect DVs (see
; .copywildmonDVs in engine/pokemon/move_mon.asm), so any stat-derived term is
; the same constant for every catch. HP is left out on purpose: BUTTERFREE,
; BEEDRILL, SCYTHER, PINSIR and HERACROSS all have a base catch rate of 45, so
; paying the player for a full-HP catch would only fine them for weakening the
; one mon they had no choice but to weaken, and then fine them again on the
; clean catch bonus for the balls it cost.
;
; Result is stored big endian in hProduct for BugContest_JudgeContestants.

	ld bc, 0 ; running score

	ld a, [wContestMonSpecies]
	and a
	jr z, .store ; nothing was caught

	call GetContestMonScoreData ; hl = rarity, min level, max level

	; Rarity.
	ld a, [hli]
	ld c, a

	; Level percentile. This runs Multiply and Divide, which write through
	; hProduct, so nothing may be stored there until it returns.
	push bc
	ld a, [wContestMonLevel]
	call ComputeContestLevelPercent
	pop bc
	add c
	ld c, a
	jr nc, .no_carry
	inc b
.no_carry

	; Clean catch bonus.
	push bc
	ld a, [wContestMonBallsUsed]
	call ContestCleanCatchBonus
	pop bc
	add c
	ld c, a
	jr nc, .store
	inc b

.store
	ld a, b
	ldh [hProduct], a
	ld a, c
	ldh [hProduct + 1], a
	ret

GetContestMonLevelPercent::
; Same number ContestScore grades on, for the caught-mon comparison screen.
; in:  b = species id, c = level
; out: a = 0-150
	ld a, b
	call GetContestMonScoreData
	inc hl ; skip past the rarity
	ld a, c
	; fallthrough

ComputeContestLevelPercent:
; in:  a  = the mon's level
;      hl = pointer to its species' min level, followed by its max level
; out: a  = 0-150, how well grown it is for its species
	ld b, a
	ld a, [hli]
	ld c, a ; min level
	ld a, [hl]
	ld d, a ; max level

	; Clamp into the species' range, in case a mon turns up off-table.
	ld a, b
	cp c
	jr nc, .not_below
	ld a, c
.not_below
	cp d
	jr c, .in_range
	jr z, .in_range
	ld a, d
.in_range

	sub c
	ld e, a ; e = level - min

	ld a, d
	sub c
	ret z ; a single-level species would divide by zero; call it a runt
	ld b, a ; b = max - min, preserved across Multiply

	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, e
	ldh [hMultiplicand + 2], a
	ld a, 150
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

ContestCleanCatchBonus:
; Rewards setting the catch up well. Deliberately looser than one ball or
; nothing, because the mons worth catching have a base catch rate of 45.
; in:  a = Park Balls thrown at the mon the player kept
; out: a = 0-30
	cp 3
	jr c, .clean ; 1-2 balls (0 should not happen, but it counts as clean)
	cp 6
	jr c, .good  ; 3-5 balls
	cp 10
	jr c, .fair  ; 6-9 balls
	xor a
	ret

.clean
	ld a, 30
	ret

.good
	ld a, 20
	ret

.fair
	ld a, 10
	ret

GetContestMonScoreData:
; in:  a  = species id
; out: hl = that species' rarity, min level and max level
	call GetPokemonIndexFromID
	ld d, h
	ld e, l
	ld hl, ContestMonScoreData
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .default ; a zero index terminates the table
	ld a, c
	cp e
	jr nz, .next
	ld a, b
	cp d
	ret z
.next
	inc hl
	inc hl
	inc hl
	jr .loop

.default
	ret

ContestMonScoreData:
; What each mon in the contest pool is worth to the judges, and the level range
; it can turn up at. Rarity tracks how often ContestMons actually rolls it, and
; is deliberately not base stats. The level ranges MUST match ContestMons in
; data/wild/bug_contest_mons.asm or the percentile will not reach 150.
	;   rarity, min, max
	dw CATERPIE
	db      0,   7, 18
	dw WEEDLE
	db      0,   7, 18
	dw METAPOD
	db     25,   9, 18
	dw KAKUNA
	db     25,   9, 18
	dw PARAS
	db     25,  10, 18
	dw VENONAT
	db     25,  10, 18
	dw BUTTERFREE
	db     50,  11, 18
	dw BEEDRILL
	db     50,  11, 18
	dw YANMA
	db     55,  11, 18
	dw SCYTHER
	db     60,  12, 18
	dw PINSIR
	db     60,  12, 18
	dw HERACROSS
	db     70,  12, 18
	dw 0 ; end
	db     25,   5, 20 ; anything not listed above
