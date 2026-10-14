Fish:
; Using a fishing rod.
; Fish for monsters with rod e in encounter group d.
; Return monster e at level d.

	push af
	push bc
	push hl

	ld b, e
	call GetFishGroupIndex
	push de ; group index, for the level scaling below

	ld hl, FishGroups
rept FISHGROUP_DATA_LENGTH
	add hl, de
endr
	call .Fish

	pop bc ; c = group index
	ld a, d
	and a
	jr z, .done ; no bite
	ld a, c
	cp FISHGROUP_SAFARI - 1
	jr nc, .kanto
	call ScaleJohtoFishLevel
	jr .done
.kanto
	cp FISHGROUP_OCEAN_KANTO - 1
	jr c, .done
	cp FISHGROUP_SILVER_CAVE - 1
	call c, ScaleKantoFishLevel

.done
	pop hl
	pop bc
	pop af
	ret

.Fish:
; Fish for monsters with rod b from encounter data in FishGroup at hl.
; Return monster e at level d.

	call Random
	cp [hl]
	ld de, 0
	ret nc

	; Get encounter data by rod:
	; 0: Old
	; 1: Good
	; 2: Super
	inc hl
	ld e, b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Compare the encounter chance to select a Pokemon.
	call Random
.loop
	cp [hl]
	jr z, .ok
	jr c, .ok
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop
.ok
	inc hl

.load
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetPokemonIDFromIndex
	ld d, a
	and a
	ret nz

	; Species 0 reads from a time-based encounter table.
	; The level byte is repurposed as the index for the new table.
	ld hl, TimeFishGroups
rept 6
	add hl, de
endr

	ld a, [wTimeOfDay]
	maskbits NUM_DAYTIMES
	cp NITE_F
	jr c, .load
	inc hl
	inc hl
	jr .ok

ScaleJohtoFishLevel:
; The shared Johto rod groups list fixed levels (Old 10 / Good 20 / Super 40).
; Scale them with progress: level = max(listed, listed / 2 + 4 * Johto badges).
; This never lowers a level, so no evolved form drops below its evolution level.
; Kanto has its own badge curve; Safari, Silver Cave and Ice stay fixed.
; In: d = species, e = level. Out: e = scaled level (d preserved).
	push de
	ld hl, wJohtoBadges
	ld b, 1
	call CountSetBits
	pop de
	add a
	add a
	ld b, a ; 4 * badges
	ld a, e
	srl a
	add b
	cp e
	ret c
	ld e, a
	ret

ScaleKantoFishLevel:
; Shared Kanto groups begin below Brock and follow the local gym tiers.
; Erika, Janine and Sabrina share the same offset in any order.
; In: d = species, e = listed level. Out: e = scaled level (d preserved).
	push de
	ld hl, wKantoBadges
	ld b, 1
	call CountSetBits
	ld e, a
	ld d, 0
	ld hl, KantoFishLevelOffsets
	add hl, de
	ld b, [hl]
	pop de
	ld a, e
	add b
	ld e, a
	ret

KantoFishLevelOffsets:
	db 0, 4, 8, 12, 12, 12, 16, 19, 23
	assert @ - KantoFishLevelOffsets == NUM_KANTO_BADGES + 1

GetFishGroupIndex:
; Return the index of fishgroup d in de.

	push hl
	ld hl, wDailyFlags1
	bit DAILYFLAGS1_FISH_SWARM_F, [hl]
	pop hl
	jr z, .done

	ld a, d
	cp FISHGROUP_QWILFISH
	jr z, .qwilfish
	cp FISHGROUP_REMORAID
	jr z, .remoraid

.done
	dec d
	ld e, d
	ld d, 0
	ret

.qwilfish
	ld a, [wFishingSwarmFlag]
	cp FISHSWARM_QWILFISH
	jr nz, .done
	ld d, FISHGROUP_QWILFISH_SWARM
	jr .done

.remoraid
	ld a, [wFishingSwarmFlag]
	cp FISHSWARM_REMORAID
	jr nz, .done
	ld d, FISHGROUP_REMORAID_SWARM
	jr .done

INCLUDE "data/wild/fish.asm"
