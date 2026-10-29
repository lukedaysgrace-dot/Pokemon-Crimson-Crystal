; Shared by the Grav Apple, the Gigaton Hammer mallet and the Heat Crash comet.
; Param bits 0-6: hover height above the impact point (at most 88px).
; Param bit 7: streak straight in without the hover, and burst (vanish) on
; impact instead of resting on the target.
; The object eases in from 32px above its hover point, holds, lifts 4px as a
; wind-up, then accelerates (1px/frame^2, capped at 10px/frame) into the
; target. A resting object rebounds 4px, settles and vanishes 12 frames after impact.
BattleAnimFunction_HeavyDrop:
	call BattleAnim_AnonJumptable
.anon_dw
	dw .init
	dw .enter
	dw .hover
	dw .fall
	dw .rest

.init
	call BattleAnim_IncAnonJumptableIndex
	call .height
	add 32
	cpl
	inc a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.enter
; Move a quarter of the remaining distance each frame (at least 1px).
	call .height
	cpl
	inc a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	sub [hl]
	jr z, .hovering
	srl a
	srl a
	jr nz, .ease
	inc a
.ease
	add [hl]
	ld [hl], a
	ret

.hovering
	call BattleAnim_IncAnonJumptableIndex
	; a bursting object (comet) streaks straight in without holding
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	ret z
	jr .release

.hover
; Hold for 6 frames, lift 1px every other frame for 8, then let go.
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 14
	jr nc, .release
	cp 6
	ret c
	and 1
	ret nz
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	dec [hl]
	ret

.release
	call BattleAnim_IncAnonJumptableIndex
	ld hl, BATTLEANIMSTRUCT_10
	add hl, bc
	ld [hl], 1
	ret

.fall
	ld hl, BATTLEANIMSTRUCT_10
	add hl, bc
	ld a, [hl]
	cp 10
	jr nc, .velocity
	inc [hl]
.velocity
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	add d
	ld [hl], a
	bit 7, a
	ret nz
	; landed
	ld [hl], 0
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	bit 7, [hl]
	jp nz, DeinitBattleAnimation
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld [hl], 0
	jp BattleAnim_IncAnonJumptableIndex

.rest
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 12
	jp nc, DeinitBattleAnimation
	cp 8
	ret nc
	ld e, a
	ld d, 0
	ld hl, .rebound
	add hl, de
	ld a, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.rebound
	db -2, -3, -4, -4, -3, -2, -1, 0

.height
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	and $7f
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

; Fiery Dance / Heat Crash: a flame circles the user's feet on a flat ellipse
; (20px wide, 6px tall) while climbing 24px, then disappears after 48 frames.
; Param = starting angle.
BattleAnimFunction_FlameTwirl:
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 48
	jp nc, DeinitBattleAnimation
	srl a
	cpl
	inc a
	ld e, a
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	add 3
	ld [hl], a
	push af
	push de
	ld d, 6
	call BattleAnim_Sine
	pop de
	add e
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop af
	ld d, 20
	call BattleAnim_Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret
