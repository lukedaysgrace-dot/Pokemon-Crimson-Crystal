BeastTriadStartMatch:
	ld hl, wBeastTriadDeck
	ld de, wBTDeck
	ld bc, 2 * BT_HAND_SIZE
	call CopyBytes
	ld hl, wBTBoard
	ld bc, BT_CELLS
	ld a, -1
	call ByteFill
	ld hl, wBTOwners
	ld bc, BT_CELLS
	ld a, -1
	call ByteFill
	ld hl, wBTUsed
	ld bc, BT_DECK_SIZE
	xor a
	call ByteFill
	xor a
	ld [wBTHandCursor], a
	ld [wBTMoves], a
	ld a, 4
	ld [wBTBoardCursor], a
	ld a, BT_HAND_SIZE
	ld [wBTPlayerHand], a
	ld [wBTFoeHand], a
	ld [wBTPlayerScore], a
	ld a, -1
	ld [wBTReward + 1], a
	ld [wBTLost + 1], a
	call BeastTriadDealFoe
	call BeastTriadLoadMatchArt
	call BeastTriadLoadTypeMods
	xor a
	ld [wBTArtPatch], a
	ld [wBTTypeShown], a
	call Random
	and 1
	ld [wBTTurn], a
	ld a, BT_HAND
	ld [wBTMode], a
	ret

BeastTriadDealFoe:
	; Each foe card is a near peer of the player's card in the same slot.
	ld de, wBTDeck + BT_HAND_SIZE * 2
	xor a
.deal:
	push af
	push de
	call BeastTriadDeckCard
	rept 4
		add hl, hl
	endr
	ld de, BeastTriadPeers
	add hl, de
	call Random
	and 7
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, BANK(BeastTriadPeers)
	call GetFarHalfword
	pop de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	pop af
	inc a
	cp BT_HAND_SIZE
	jr c, .deal
	; Named characters always bring their own card.
	ld a, [wBTFoeCard + 1]
	cp -1
	ret z
	ld a, BT_HAND_SIZE
	call RandomRange
	add BT_HAND_SIZE
	add a
	ld e, a
	ld d, 0
	ld hl, wBTDeck
	add hl, de
	ld a, [wBTFoeCard]
	ld [hli], a
	ld a, [wBTFoeCard + 1]
	ld [hl], a
	ret

BeastTriadDeckCard:
	; A: position in the two hands. Returns HL: catalogue index.
	add a
	ld e, a
	ld d, 0
	ld hl, wBTDeck
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

BeastTriadGetRecord:
	; HL: catalogue index. Returns HL: 4 ranks, 10 name tiles, far art pointer.
	ld d, h
	ld e, l
	rept 4
		add hl, hl
	endr
	add hl, de
	ld de, BeastTriadCatalog
	add hl, de
	ret

BeastTriadBoardCell:
	ld c, a
	ld b, 0
	ld hl, wBTBoard
	add hl, bc
	ld a, [hl]
	ret

BeastTriadRank:
	; A: deck index; C: edge (north, east, south, west).
	add a
	add a
	add c
	ld e, a
	ld d, 0
	ld hl, wBTRanks
	add hl, de
	ld a, [hl]
	ret

BeastTriadFoeTurn:
	ld c, 10
	call DelayFrames
	ld a, -1
	ld [wBTBestScore], a
	xor a
	ld [wBTCommit], a
	ld a, BT_FOE
	ld [wBTProbeOwner], a
	ld a, BT_HAND_SIZE
	ld [wBTLoopCard], a
.card:
	ld a, [wBTLoopCard]
	ld c, a
	ld b, 0
	ld hl, wBTUsed
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .next_card
	ld a, c
	ld [wBTProbeCard], a
	xor a
	ld [wBTLoopCell], a
.cell:
	ld a, [wBTLoopCell]
	ld [wBTProbeCell], a
	call BeastTriadBoardCell
	cp -1
	jr nz, .next_cell
	call BeastTriadCompareNeighbors
	ld a, [wBTCaptures]
	add a
	add a
	ld b, a
	ld a, [wBTProbeCell]
	ld e, a
	ld d, 0
	ld hl, .position_score
	add hl, de
	ld a, [hl]
	add b
	ld b, a
	ld a, [wBTBestScore]
	cp -1
	jr z, .new_best
	cp b
	jr c, .new_best
	jr nz, .next_cell
	call Random
	and 3
	jr nz, .next_cell
.new_best:
	ld a, b
	ld [wBTBestScore], a
	ld a, [wBTProbeCell]
	ld [wBTBestCell], a
	ld a, [wBTProbeCard]
	ld [wBTBestCard], a
.next_cell:
	ld hl, wBTLoopCell
	inc [hl]
	ld a, [hl]
	cp BT_CELLS
	jr c, .cell
.next_card:
	ld hl, wBTLoopCard
	inc [hl]
	ld a, [hl]
	cp BT_DECK_SIZE
	jr c, .card
	ld a, [wBTBestCell]
	ld [wBTProbeCell], a
	ld a, [wBTBestCard]
	ld [wBTProbeCard], a
	call BeastTriadPlace
	jp BeastTriadAfterMove
.position_score:
	db 2, 1, 2, 1, 0, 1, 2, 1, 2

BeastTriadPlace:
	ld hl, wBTCapturedCells
	ld bc, BT_CELLS
	xor a
	call ByteFill
	ld hl, wBTEdgeBonus
	ld bc, 4
	xor a
	call ByteFill
	ld [wBTBattled], a
	ld a, [wBTProbeCell]
	call BeastTriadBoardCell
	ld a, [wBTProbeCard]
	ld [hl], a
	ld e, a
	ld d, 0
	ld hl, wBTUsed
	add hl, de
	ld [hl], 1
	ld hl, wBTOwners
	add hl, bc
	ld a, [wBTProbeOwner]
	ld [hl], a
	ld hl, wBTPlayerHand
	and a
	jr z, .hand
	inc hl ; wBTFoeHand
.hand:
	dec [hl]
	ld hl, wBTMoves
	inc [hl]
	ld a, 1
	ld [wBTCommit], a
	call BeastTriadCompareNeighbors
	jp BeastTriadScore

BeastTriadCompareNeighbors:
	xor a
	ld [wBTCaptures], a
	ld [wBTDirection], a
.edge:
	ld a, [wBTProbeCell]
	add a
	add a
	ld hl, wBTDirection
	add [hl]
	ld e, a
	ld d, 0
	ld hl, BeastTriadNeighbors
	add hl, de
	ld a, [hl]
	cp -1
	jp z, .next
	ld [wBTNeighbor], a
	call BeastTriadBoardCell
	cp -1
	jp z, .next
	ld e, a
	ld hl, wBTOwners
	add hl, bc
	ld a, [wBTProbeOwner]
	cp [hl]
	jp z, .next
	ld a, e
	ld [wBTDefenderCard], a
	ld a, [wBTDirection]
	add 2
	and 3
	ld c, a
	ld a, e
	call BeastTriadRank
	ld b, a
	ld a, [wBTDirection]
	ld c, a
	ld a, [wBTProbeCard]
	call BeastTriadRank
	; A type matchup adds or takes one from the attacking edge only.
	push bc
	ld c, a
	ld a, [wBTProbeCard]
	ld e, a
	add a
	add a
	add e
	add a
	ld e, a
	ld a, [wBTDefenderCard]
	add e
	ld e, a
	ld d, 0
	ld hl, wBTTypeMods
	add hl, de
	ld a, [hl]
	ld e, a
	add c
	ld c, a
	ld a, [wBTCommit]
	and a
	jr z, .no_record
	ld a, 1
	ld [wBTBattled], a
	ld a, [wBTDirection]
	push de
	ld e, a
	ld d, 0
	ld hl, wBTEdgeBonus
	add hl, de
	pop de
	ld [hl], e
.no_record:
	ld a, c
	pop bc
	cp b
	jp c, .next
	jp z, .next
	ld hl, wBTCaptures
	inc [hl]
	ld a, [wBTCommit]
	and a
	jp z, .next
	ld a, [wBTNeighbor]
	ld e, a
	ld d, 0
	ld hl, wBTOwners
	add hl, de
	ld a, [wBTProbeOwner]
	ld [hl], a
	ld hl, wBTCapturedCells
	add hl, de
	ld [hl], 1
.next:
	ld hl, wBTDirection
	inc [hl]
	ld a, [hl]
	cp 4
	jp c, .edge
	ret

BeastTriadScore:
	ld a, [wBTPlayerHand]
	ld c, a
	ld hl, wBTOwners
	ld b, BT_CELLS
.owner:
	ld a, [hli]
	and a
	jr nz, .next
	inc c
.next:
	dec b
	jr nz, .owner
	ld a, c
	ld [wBTPlayerScore], a
	ret

BeastTriadAfterMove:
	call BeastTriadAnimatePlacement
	ld a, [wBTMoves]
	cp BT_CELLS
	jr z, .finished
	ld hl, wBTTurn
	ld a, [hl]
	xor 1
	ld [hl], a
	ld a, BT_HAND
	ld [wBTMode], a
	ret
.finished:
	xor a
	ld [wBTPickCursor], a
	ld a, [wBTPlayerScore]
	cp 5
	jr c, .lost
	jr z, .draw
	ld a, BT_PICK
	ld [wBTMode], a
	ld de, MUSIC_BEAST_TRIAD_VICTORY
	jp PlayMusic
.draw:
	ld a, BT_RESULT
	ld [wBTMode], a
	ld de, MUSIC_BEAST_TRIAD_DRAW
	jp PlayMusic
.lost:
	ld a, BT_RESULT
	ld [wBTMode], a
	ld de, MUSIC_BEAST_TRIAD_LOSS
	call PlayMusic
	jp BeastTriadFoeTakesCard

BeastTriadAnimatePlacement:
	ld de, SFX_PLACE_PUZZLE_PIECE_DOWN
	call PlaySFX
	call BeastTriadShowMatchup
	ld a, [wBTCaptures]
	and a
	jp z, BeastTriadEndMatchup
	; Turn each captured card over: its old face, its back, then the new
	; owner's face with one soft flash before it settles.
	ld a, BT_ANIM
	ld [wBTMode], a
	ld a, BT_FLIP_FACE
	ld c, 10
	call .frame
	ld de, SFX_BEAST_TRIAD_FLIP
	call WaitPlaySFX
	ld a, BT_FLIP_BACK
	ld c, 8
	call .frame
	ld a, [wBTProbeOwner]
	and a
	ld de, SFX_BEAST_TRIAD_CAPTURE
	jr z, .reveal_sound
	ld de, SFX_BEAST_TRIAD_CAPTURED
.reveal_sound:
	call WaitPlaySFX
	ld a, BT_FLIP_REVEAL
	ld c, 12
	call .frame
	ld a, BT_FLIP_SETTLE
	ld c, 10
	call .frame
	xor a
	ld [wBTAnimPhase], a
	jp BeastTriadEndMatchup

.frame:
	ld [wBTAnimPhase], a
	push bc
	call BeastTriadRender
	pop bc
	jp DelayFrames

BeastTriadShowMatchup:
	; If the placed card's type changed any edge it attacked with, redraw its
	; ranks with the new values, light it up and name the matchup. A neutral
	; attack just gets the usual battle hit.
	ld hl, wBTEdgeBonus
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	jr nz, .matchup
	ld a, [wBTBattled]
	and a
	ret z
	ld de, SFX_DAMAGE
	jp WaitPlaySFX
.matchup:
	ld a, [wBTProbeCard]
	push af
	call BeastTriadCopyCardArt
	xor a
	ld [wBTBadgeEdge], a
.edge:
	ld a, [wBTBadgeEdge]
	ld e, a
	ld d, 0
	ld hl, wBTEdgeBonus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
	ld b, a
	ld a, [wBTProbeCard]
	ld c, e
	call BeastTriadRank
	add b
	call BeastTriadDrawBadge
.next:
	ld hl, wBTBadgeEdge
	inc [hl]
	ld a, [hl]
	cp 4
	jr c, .edge
	pop af
	inc a
	ld [wBTArtPatch], a
	ld [wBTTypeShown], a
	ld a, BT_ANIM
	ld [wBTMode], a
	ld a, BT_FLIP_TYPE
	ld [wBTAnimPhase], a
	call BeastTriadRender
	call BeastTriadMatchupText
	ld de, SFX_SUPER_EFFECTIVE
	ld a, l
	cp LOW(BeastTriadWeakText)
	jr nz, .sound
	ld de, SFX_NOT_VERY_EFFECTIVE
.sound:
	call WaitPlaySFX
	ld c, 45
	call DelayFrames
	xor a
	ld [wBTAnimPhase], a
	ret

BeastTriadEndMatchup:
	; After the attack the card shows its printed ranks again.
	ld a, [wBTTypeShown]
	and a
	ret z
	dec a
	push af
	call BeastTriadCopyCardArt
	pop af
	inc a
	ld [wBTArtPatch], a
	xor a
	ld [wBTTypeShown], a
	ret

BeastTriadCopyCardArt:
	; A: art slot. Copy its card's printed art to wBTArtBuffer.
	call BeastTriadDeckCard
	call BeastTriadGetRecord
	ld de, 14
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	ld de, wBTArtBuffer
	ld bc, BT_CARD_TILES * 16
	jp FarCopyBytes

BeastTriadDrawBadge:
	; A: new rank (0-11) for edge wBTBadgeEdge. Draw it as a dark badge
	; with a light digit over the printed one in wBTArtBuffer.
	ld c, a
	add a
	add a
	add c
	ld e, a
	ld d, 0
	ld hl, BeastTriadBadgeGlyphs
	add hl, de
	push hl
	ld a, [wBTBadgeEdge]
	add a
	ld e, a
	ld hl, BeastTriadRankPositions
	add hl, de
	ld a, [hli]
	ld d, a
	ld e, [hl]
	; D, E: the glyph's top left. Fill a 5x7 box around it.
	dec d
	dec e
	ld b, 7
.box_row:
	push de
	ld c, 5
.box:
	push bc
	ld c, 3
	call BeastTriadPlotPixel
	pop bc
	inc d
	dec c
	jr nz, .box
	pop de
	inc e
	dec b
	jr nz, .box_row
	; E is now the glyph's bottom + 2. Back to its top left.
	ld a, e
	sub 6
	ld e, a
	inc d
	pop hl
	ld b, 5
.glyph_row:
	ld a, [hli]
	push hl
	push de
	ld c, 3
.glyph:
	bit 2, a
	jr z, .skip
	push af
	push bc
	ld c, 0
	call BeastTriadPlotPixel
	pop bc
	pop af
.skip:
	add a
	inc d
	dec c
	jr nz, .glyph
	pop de
	pop hl
	inc e
	dec b
	jr nz, .glyph_row
	ret

BeastTriadPlotPixel:
	; D: x, E: y on the 24x32 card, C: color 0 or 3. Preserves DE.
	push de
	ld a, e
	and %11111000
	rrca
	rrca
	rrca
	ld b, a
	add a
	add b
	ld b, a
	ld a, d
	rrca
	rrca
	rrca
	and %00011111
	add b
	swap a
	ld b, a
	ld a, e
	and 7
	add a
	add b
	ld l, a
	ld h, 0
	ld a, d
	and 7
	inc a
	ld d, a
	ld a, $80
.shift:
	dec d
	jr z, .mask
	rrca
	jr .shift
.mask:
	ld b, a
	push bc
	ld bc, wBTArtBuffer
	add hl, bc
	pop bc
	ld a, c
	and a
	jr z, .clear
	ld a, [hl]
	or b
	ld [hli], a
	ld a, [hl]
	or b
	ld [hl], a
	pop de
	ret
.clear:
	ld a, b
	cpl
	ld b, a
	ld a, [hl]
	and b
	ld [hli], a
	ld a, [hl]
	and b
	ld [hl], a
	pop de
	ret

BeastTriadLoadTypeMods:
	; Look up each card's primary type against every other card's in the
	; game's own type chart: super effective +1, otherwise weaker -1.
	ld hl, wBTTypeMods
	ld bc, 10 * 10
	xor a
	call ByteFill
	ld hl, TypeMatchups
.entry:
	ld a, BANK(TypeMatchups)
	call GetFarByte
	inc hl
	cp -1
	ret z
	cp -2
	jr z, .entry
	ld [wBTTypeAttacker], a
	ld a, BANK(TypeMatchups)
	call GetFarByte
	inc hl
	ld [wBTTypeDefender], a
	ld a, BANK(TypeMatchups)
	call GetFarByte
	inc hl
	cp EFFECTIVE
	jr z, .entry
	ld a, 1
	jr nc, .mod
	ld a, -1
.mod:
	ld [wBTTypeMod], a
	push hl
	ld b, 0
.attacker:
	ld a, b
	call .type
	ld hl, wBTTypeAttacker
	cp [hl]
	jr nz, .next_attacker
	ld c, 0
.defender:
	ld a, c
	call .type
	ld hl, wBTTypeDefender
	cp [hl]
	jr nz, .next_defender
	ld a, b
	add a
	add a
	add b
	add a
	add c
	ld e, a
	ld d, 0
	ld hl, wBTTypeMods
	add hl, de
	ld a, [wBTTypeMod]
	ld [hl], a
.next_defender:
	inc c
	ld a, c
	cp BT_DECK_SIZE
	jr c, .defender
.next_attacker:
	inc b
	ld a, b
	cp BT_DECK_SIZE
	jr c, .attacker
	pop hl
	jr .entry

.type:
	ld e, a
	ld d, 0
	ld hl, wBTTypes
	add hl, de
	ld a, [hl]
	ret

BeastTriadNeighbors:
	db -1,  1,  3, -1
	db -1,  2,  4,  0
	db -1, -1,  5,  1
	db  0,  4,  6, -1
	db  1,  5,  7,  3
	db  2, -1,  8,  4
	db  3,  7, -1, -1
	db  4,  8, -1,  6
	db  5, -1, -1,  7
