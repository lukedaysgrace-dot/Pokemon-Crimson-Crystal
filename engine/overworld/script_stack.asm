PushScriptStack::
; Save the current script context if the five-entry return stack has room.
; Return carry on success, or no carry if the requested call was rejected.
	ld hl, wScriptStackSize
	ld a, [hl]
	cp 5
	ret nc

	push de
	inc [hl]
	ld e, a
	ld d, 0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	pop de

	ld a, [wScriptBank]
	ld [hli], a
	ld a, [wScriptPos]
	ld [hli], a
	ld a, [wScriptPos + 1]
	ld [hl], a
	scf
	ret
