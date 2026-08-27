; Bill's PC / storage system constants (see docs/pc_storage_design.md)

; Box themes (see data/pc/theme_names.asm and gfx/pc/themes.pal)
	const_def
	const THEME_STANDARD
	const THEME_PRO
	const THEME_MOBILE
	const THEME_CLASSIC
	const THEME_BLISS
	const THEME_CONTRAST
	const THEME_NATURE
	const THEME_HEART
	const THEME_SOUL
	const THEME_TRUTH
	const THEME_IDEALS
	const THEME_LIGHT
	const THEME_DARKNESS
	const THEME_MATTE
	const THEME_MATRIX
	const THEME_NORMAL
	const THEME_FIGHTING
	const THEME_FLYING
	const THEME_POISON
	const THEME_GROUND
	const THEME_ROCK
	const THEME_BUG
	const THEME_GHOST
	const THEME_STEEL
	const THEME_FIRE
	const THEME_WATER
	const THEME_GRASS
	const THEME_ELECTRIC
	const THEME_PSYCHIC
	const THEME_ICE
	const THEME_DRAGON
	const THEME_DARK
	const THEME_FAIRY
NUM_BILLS_PC_THEMES EQU const_value

; BillsPC_CanReleaseMon results
	const_def
	const RELEASE_OK
	const RELEASE_LAST_HEALTHY
	const RELEASE_EGG
	const RELEASE_HM ; reserved: Polished defines it but never returns it; neither do we
	const RELEASE_EMPTY

; SwapStorageBoxSlots results
	const_def
	const PCSWAP_OK
	const PCSWAP_SAVE_REQUIRED
	const PCSWAP_PARTY_FULL
	const PCSWAP_BOX_FULL
	const PCSWAP_LAST_HEALTHY
	const PCSWAP_HOLDING_MAIL
; extensions used by BillsPC_SwapStorage for items
	const PCSWAP_CANT_STORE_MAIL
	const PCSWAP_EGGS_CANT_HOLD
	const PCSWAP_CANT_POCKET_MAIL
	const PCSWAP_PACK_FULL

; AddTempMonToStorage / NewStorageBoxPointer results (a)
	const_def
	const PCSTORE_CUR_BOX       ; placed in the current box
	const PCSTORE_OTHER_BOX     ; current box full; placed in another box (wCurBox switched)
	const PCSTORE_FULL          ; every logical slot is full
	const PCSTORE_SAVE_REQUIRED ; logical room exists but the database is full until a save

; Cursor modes
	const_def
	const PC_MENU_MODE ; 0, red
	const PC_SWAP_MODE ; 1, blue
	const PC_ITEM_MODE ; 2, green
NUM_PC_MODES EQU const_value

; Held item icon categories (gfx/pc/held_item_icons.png)
	const_def
	const HELDTYPE_ITEM       ; 0
	const HELDTYPE_INERT_ITEM ; 1
	const HELDTYPE_MAIL       ; 2
	const HELDTYPE_BERRY      ; 3
NUM_HELD_ITEM_TYPES EQU const_value

; Sprite animation parameters
PCANIM_STATIC      EQU  0 ; holding something: no bop
PCANIM_ANIMATE     EQU 90 ; baseline
PCANIM_PICKUP      EQU 91 ; picking up / placing
PCANIM_PICKUP_NEXT EQU 98 ; cursor at the bottom, ready for pickup
PCANIM_QUICKFRAMES EQU  9

; Object palettes used by the PC
	const_def 1
	const PAL_PC_CURSOR_MODE1
	const PAL_PC_CURSOR_MODE2
	const PAL_PC_MINI_ICON
	const PAL_PC_PACK
	const PAL_PC_QUICK
	const PAL_PC_SHADOW

; Save file format
SAVE_FORMAT_VERSION EQU 2 ; 2: per-Pokémon HiddenPowerType byte in box_struct; bump whenever sram.asm / saved WRAM layout changes
