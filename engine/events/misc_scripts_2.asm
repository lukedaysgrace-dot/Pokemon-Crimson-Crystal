RepelWoreOffScript::
	opentext
	callasm .CheckForAnotherRepel
	iffalse .no_more
	writetext .use_another_text
	yesorno
	iffalse .finish
	callasm .UseAnotherRepel
	playsound SFX_FULL_HEAL
	waitsfx
	sjump .finish

.no_more
	writetext .text
	waitbutton

.finish
	closetext
	end

.CheckForAnotherRepel:
	xor a
	ld [wScriptVar], a
	ld a, [wLastRepelUsed]
	cp REPEL
	jr z, .check
	cp SUPER_REPEL
	jr z, .check
	cp MAX_REPEL
	ret nz
.check
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	ret nc
	ld a, TRUE
	ld [wScriptVar], a
	ret

.UseAnotherRepel:
	ld a, [wLastRepelUsed]
	ld [wCurItem], a
	ld b, 100
	cp REPEL
	jr z, .set_effect
	ld b, 200
	cp SUPER_REPEL
	jr z, .set_effect
	ld b, 250
.set_effect
	ld a, b
	ld [wRepelEffect], a
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, wNumItems
	call TossItem
	ret

.text
	; REPEL's effect wore off.
	text_far _RepelWoreOffText
	text_end

.use_another_text
	text_far _UseAnotherRepelText
	text_end

HiddenItemScript::
	opentext
	readmem wHiddenItemID
	getitemname STRING_BUFFER_3, USE_SCRIPT_VAR
	writetext .found_text
	giveitem ITEM_FROM_MEM
	iffalse .bag_full
	callasm SetMemEvent
	specialsound
	itemnotify
	sjump .finish

.bag_full
	buttonsound
	writetext .no_room_text
	waitbutton

.finish
	closetext
	end

.found_text
	; found @ !
	text_far _PlayerFoundItemText
	text_end

.no_room_text
	; But   has no space left…
	text_far _ButNoSpaceText
	text_end

SetMemEvent:
	ld hl, wHiddenItemEvent
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld b, SET_FLAG
	call EventFlagAction
	ret
