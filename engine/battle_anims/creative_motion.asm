; Shared by the suspended apple, giant steel hammer and Heat Crash comet.
; Param = starting height. Hold for 12 frames, then accelerate to 8 px/frame.
BattleAnimFunction_HeavyDrop:
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	bit 7, [hl]
	ret nz
	ld a, [hl]
	inc [hl]
	and a
	jr nz, .step
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	xor a
	sub [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret
.step
	cp 12
	ret c
	ld hl, BATTLEANIMSTRUCT_10
	add hl, bc
	ld a, [hl]
	cp 8
	jr nc, .velocity
	inc a
	ld [hl], a
.velocity
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	add [hl]
	ld [hl], a
	ret nc
	ld [hl], 0
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld [hl], $80
	ret

; Six separately phased beetles open into a ring, orbit, then close in.
BattleAnimFunction_SwarmOrbit:
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 48
	jp nc, DeinitBattleAnimation
	cp 16
	jr c, .opening
	cp 32
	ld d, 24
	jr c, .angle
	ld d, a
	ld a, 56
	sub d
	ld d, a
	jr .angle
.opening
	add 8
	ld d, a
.angle
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	add 3
	ld [hl], a
	push af
	push de
	call BattleAnim_Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	call BattleAnim_Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret
