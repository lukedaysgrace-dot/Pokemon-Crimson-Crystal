; Same ROM bank as PokemonCries. The public home wrapper preserves registers.
PlaySpeciesCry::
	call LoadSpeciesCry
	farcall _PlayCry
	ret

LoadSpeciesCry::
	ld hl, PokemonCries
rept 6
	add hl, de
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch + 1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength + 1], a
	ret
