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
	jr z, .preferred
	cp SUPER_REPEL
	jr z, .preferred
	cp MAX_REPEL
	jr nz, .fallback
.preferred
	call .CheckRepel
	ret c
.fallback
	ld a, MAX_REPEL
	call .CheckRepel
	ret c
	ld a, SUPER_REPEL
	call .CheckRepel
	ret c
	ld a, REPEL
.CheckRepel:
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	ret nc
	farcall GetBagItemQuantity
	ld a, b
	ld [wStringBuffer4], a
	ld a, c
	ld [wStringBuffer4 + 1], a
	ld a, [wCurItem]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, wStringBuffer3
	call CopyName2
	ld a, TRUE
	ld [wScriptVar], a
	scf
	ret

.UseAnotherRepel:
	ld a, [wCurItem]
	ld [wLastRepelUsed], a
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
	closetext
	; Only a successful Mt. Moon Square Moon Stone pickup can call the star.
	readmem wHiddenItemID
	ifnotequal MOON_STONE, .done
	readvar VAR_MAPGROUP
	ifnotequal GROUP_MOUNT_MOON_SQUARE, .done
	readvar VAR_MAPNUMBER
	ifnotequal MAP_MOUNT_MOON_SQUARE, .done
	farsjump MountMoonSquareWishingStarCrash
.done:
	end

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
