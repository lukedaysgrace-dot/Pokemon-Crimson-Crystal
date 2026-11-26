; Beast Triad card clubs (maps/GoldenrodTriadLounge.asm, maps/CeladonTriadVault.asm).

; Pokemon cards come before the character cards that only their owners hold.
NUM_BEAST_POKEMON_CARDS EQU BEAST_CARD_BLUE - BEAST_CARD_ITEM_BASE

; Opponent tiers: wScriptVar for special BeastTriadTiered (see BeastTriadTierBands).
	const_def
	const BEAST_TRIAD_TIER_PEERS        ; 0: near peers of the player's own deck (Game Corner hosts)
	const BEAST_TRIAD_TIER_STANDARD     ; 1
	const BEAST_TRIAD_TIER_MID          ; 2
	const BEAST_TRIAD_TIER_GRAND_MASTER ; 3
NUM_BEAST_TRIAD_TIERS EQU const_value - 1
