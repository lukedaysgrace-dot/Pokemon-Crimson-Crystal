_GetItemName::
; Get item name for wNamedObjectIndexBuffer.

	push hl
	push bc
	ld a, [wNamedObjectIndexBuffer]

	call CompareItemWithTM01
	jr nc, .TM

	ldh a, [hROMBank]
	push af
	ld a, [wNamedObjectIndexBuffer]
	call GetValidItemIndexFromID
	ld b, h
	ld c, l
	dec bc
	ld a, BANK(ItemNames)
	rst Bankswitch
	ld hl, ItemNames
	call GetNthString16
	ld de, wStringBuffer1
	ld bc, ITEM_NAME_LENGTH
	call CopyBytes
	pop af
	rst Bankswitch
	jr .Copied
.TM:
	call _GetTMHMName
.Copied:
	ld de, wStringBuffer1
	pop bc
	pop hl
	ret

_GetTMHMName::
; Get TM/HM name for item wNamedObjectIndexBuffer.

	push hl
	push de
	push bc
	ld a, [wNamedObjectIndexBuffer]
	push af

; TM/HM prefix
	call CompareItemWithHM01
	push af
	jr c, .TM

	ld hl, .HMText
	ld bc, .HMTextEnd - .HMText
	jr .asm_34a1

.TM:
	ld hl, .TMText
	ld bc, .TMTextEnd - .TMText

.asm_34a1
	ld de, wStringBuffer1
	call CopyBytes

; TM/HM number
	push de
	ld a, [wNamedObjectIndexBuffer]
	ld c, a
	callfar GetTMHMNumber
	pop de

; HM numbers follow the last TM, but are displayed starting from 1
	pop af
	ld a, c
	jr c, .asm_34b9
	sub NUM_TMS
.asm_34b9

; Divide and mod by 10 to get the top and bottom digits respectively
	ld b, "0"
.mod10
	sub 10
	jr c, .asm_34c2
	inc b
	jr .mod10
.asm_34c2
	add 10

	push af
	ld a, b
	ld [de], a
	inc de
	pop af

	ld b, "0"
	add b
	ld [de], a

; End the string
	inc de
	ld a, "@"
	ld [de], a

	pop af
	ld [wNamedObjectIndexBuffer], a
	pop bc
	pop de
	pop hl
	ret

.TMText:
	db "TM"
.TMTextEnd:
	db "@"

.HMText:
	db "HM"
.HMTextEnd:
	db "@"

