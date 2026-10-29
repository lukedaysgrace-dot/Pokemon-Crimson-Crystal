SweetScentFromMenu:
	ld hl, .SweetScent
	call QueueScript
	ld a, $1
	ld [wFieldMoveSucceeded], a
	ret

.SweetScent:
	reloadmappart
	special UpdateTimePals
	callasm GetPartyNick
	writetext UnknownText_0x50726
	waitbutton
	callasm Route31TryWimpodSweetScent
	iffalse .NormalEncounter
	closetext
	end

.NormalEncounter:
	callasm SweetScentEncounter
	iffalse SweetScentNothing
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue .BugCatchingContest
	checkflag ENGINE_SAFARI_ZONE
	iftrue .SafariZone
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

.BugCatchingContest:
	farsjump BugCatchingContestBattleScript

.SafariZone:
	farsjump SafariZoneBattleScript

SweetScentNothing:
	writetext UnknownText_0x5072b
	waitbutton
	closetext
	end

Route31TryWimpodSweetScent:
; On Route 31, using the move leaves a scent until the map is reloaded.
; The proximity scripts consume it instead of starting a random grass battle.
	xor a
	ld [wScriptVar], a
	ld a, [wMapGroup]
	cp GROUP_ROUTE_31
	ret nz
	ld a, [wMapNumber]
	cp MAP_ROUTE_31
	ret nz
	ld de, EVENT_ROUTE_31_WIMPOD_FINISHED
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret nz
	ld de, EVENT_ROUTE_31_WIMPOD_HIDDEN
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret nz
	ld de, EVENT_ROUTE_31_WIMPOD_SWEET_SCENT
	ld b, SET_FLAG
	call EventFlagAction
	ld a, 1
	ld [wScriptVar], a
	ret

SweetScentEncounter:
	ld a, [wStatusFlags2]
	bit STATUSFLAGS2_FISHING_CONTEST_F, a
	jr nz, .no_battle
	farcall CanUseSweetScent
	jr nc, .no_battle
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_BUG_CONTEST_TIMER_F, [hl]
	jr nz, .not_in_bug_contest
	farcall GetMapEncounterRate
	ld a, b
	and a
	jr z, .no_battle
	farcall ChooseWildEncounter
	jr nz, .no_battle
	jr .start_battle

.not_in_bug_contest
	farcall ChooseWildEncounter_BugContest

.start_battle
	ld a, $1
	ld [wScriptVar], a
	ret

.no_battle
	xor a
	ld [wScriptVar], a
	ld [wBattleType], a
	ret

UnknownText_0x50726:
	; used SWEET SCENT!
	text_far UnknownText_0x1c0b03
	text_end

UnknownText_0x5072b:
	; Looks like there's nothing here…
	text_far UnknownText_0x1c0b1a
	text_end
