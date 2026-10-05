Script_AbortBugContest:
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .finish
	checkflag ENGINE_FISHING_CONTEST
	iftrue .fishing
	setflag ENGINE_DAILY_BUG_CONTEST
	special ContestReturnMons
.finish
	end
.fishing
	checkevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	iffalse .no_party
	special ContestReturnMons
.no_party
	clearevent EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	setflag ENGINE_DAILY_FISHING_CONTEST
	clearflag ENGINE_FISHING_CONTEST
	clearflag ENGINE_BUG_CONTEST_TIMER
	loadmem wParkBallsRemaining, 0
	end

FindItemInBallScript::
	callasm .TryReceiveItem
	iffalse .no_room
	disappear LAST_TALKED
	opentext
	writetext .text_found
	playsound SFX_ITEM
	pause 60
	itemnotify
	closetext
	end

.no_room
	opentext
	writetext .text_found
	waitbutton
	writetext .text_bag_full
	waitbutton
	closetext
	end

.text_found
	; found @ !
	text_far UnknownText_0x1c0a1c
	text_end

.text_bag_full
	; But   can't carry any more items.
	text_far UnknownText_0x1c0a2c
	text_end

.TryReceiveItem:
	xor a
	ld [wScriptVar], a
	ld a, [wItemBallItemID]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, wStringBuffer3
	call CopyName2
	ld a, [wItemBallItemID]
	ld [wCurItem], a
	ld a, [wItemBallQuantity]
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	ret nc
	ld a, $1
	ld [wScriptVar], a
	ret
