TILE_WIDTH EQU 8 ; pixels

; ability slideout banner (see engine/battle/ability_gfx.asm)
SLIDEOUT_WIDTH EQU 16 ; tiles
SLIDEOUT_START_TILE EQU $c0 ; VRAM bank 1; enemy $c0-$df, player $e0-$ff
LEN_1BPP_TILE EQU 1 * TILE_WIDTH ; bytes
LEN_2BPP_TILE EQU 2 * TILE_WIDTH ; bytes

NUM_PAL_COLORS EQU 4
PAL_COLOR_SIZE EQU 2
PALETTE_SIZE EQU NUM_PAL_COLORS * PAL_COLOR_SIZE

PALRGB_WHITE EQUS "palred 31 + palgreen 31 + palblue 31" ; $7fff

; smooth palette fade modes (hPalFadeMode; see engine/gfx/fade.asm)
PALFADE_WHICH      EQU %11 ; which palettes to fade
PALFADE_FLASH_F    EQU 2
PALFADE_PARTIAL_F  EQU 3
PALFADE_TO_BLACK_F EQU 4
PALFADE_TO_WHITE_F EQU 5

PALFADE_BOTH     EQU %00 ; fade BG and OBJ palettes
PALFADE_BG       EQU %01 ; fade BG palettes only
PALFADE_OBJ      EQU %10 ; fade OBJ palettes only
PALFADE_FLASH    EQU 1 << PALFADE_FLASH_F    ; fade to black, then back
PALFADE_PARTIAL  EQU 1 << PALFADE_PARTIAL_F
PALFADE_TO_BLACK EQU 1 << PALFADE_TO_BLACK_F ; fade to black (keep wBGPals1)
PALFADE_TO_WHITE EQU 1 << PALFADE_TO_WHITE_F ; fade to white (keep wBGPals1)

SCREEN_WIDTH  EQU 20 ; tiles
SCREEN_HEIGHT EQU 18 ; tiles
SCREEN_WIDTH_PX  EQU SCREEN_WIDTH  * TILE_WIDTH ; pixels
SCREEN_HEIGHT_PX EQU SCREEN_HEIGHT * TILE_WIDTH ; pixels

BG_MAP_WIDTH  EQU 32 ; tiles
BG_MAP_HEIGHT EQU 32 ; tiles

METATILE_WIDTH EQU 4 ; tiles
SCREEN_META_WIDTH EQU 6 ; metatiles
SCREEN_META_HEIGHT EQU 5 ; metatiles
SURROUNDING_WIDTH  EQU SCREEN_META_WIDTH * METATILE_WIDTH ; tiles
SURROUNDING_HEIGHT EQU SCREEN_META_HEIGHT * METATILE_WIDTH ; tiles

HP_BAR_LENGTH  EQU 6 ; tiles
EXP_BAR_LENGTH EQU 8 ; tiles
HP_BAR_LENGTH_PX  EQU HP_BAR_LENGTH  * TILE_WIDTH ; pixels
EXP_BAR_LENGTH_PX EQU EXP_BAR_LENGTH * TILE_WIDTH ; pixels

; GetHPPal return values (see home.asm)
HP_GREEN  EQU 0
HP_YELLOW EQU 1
HP_RED    EQU 2

; sprite_oam_struct members (see macros/wram.asm)
	const_def
	const SPRITEOAMSTRUCT_YCOORD     ; 0
	const SPRITEOAMSTRUCT_XCOORD     ; 1
	const SPRITEOAMSTRUCT_TILE_ID    ; 2
	const SPRITEOAMSTRUCT_ATTRIBUTES ; 3
SPRITEOAMSTRUCT_LENGTH EQU const_value
NUM_SPRITE_OAM_STRUCTS EQU 40 ; see wVirtualOAM

SPRITE_GFX_LIST_CAPACITY EQU 32 ; see wUsedSprites

MAP_NAME_FONT_TILE_START EQU $dc
MAP_NAME_FONT_NUM_TILES  EQU 36

; Overworld trainer portraits (see engine/events/trainer_portraits.asm)
PORTRAIT_WIDTH        EQU 7 ; tiles
PORTRAIT_HEIGHT       EQU 7 ; tiles
PORTRAIT_NUM_TILES    EQU PORTRAIT_WIDTH * PORTRAIT_HEIGHT
PORTRAIT_MAX_MOUTH    EQU 8 ; tiles that may change between the two frames
PORTRAIT_HEADER_SIZE  EQU 1 + 2 * 2 + PORTRAIT_MAX_MOUTH ; count, 2 colors, cells
; The portrait sits flush against the right edge of the screen, directly on
; top of the speech textbox, so it can never cover the NPC being spoken to (who
; is always beside, above or below the player). Its frame is drawn into the
; portrait's own outer pixels by tools/trainer_portrait.py, so the frame hugs
; the picture and takes no extra tiles.
PORTRAIT_X            EQU SCREEN_WIDTH - PORTRAIT_WIDTH ; 13
PORTRAIT_Y            EQU (SCREEN_HEIGHT - 6) - PORTRAIT_HEIGHT ; 5 (TEXTBOX_Y is 12)
PORTRAIT_FRAME_X      EQU PORTRAIT_X
PORTRAIT_FRAME_Y      EQU PORTRAIT_Y
PORTRAIT_FRAME_SIZE   EQU PORTRAIT_WIDTH
; Tiles live in VRAM bank 1 just below the weather tiles. That is the top of
; the table bank-1 NPCs keep their walking frames in; those are restored when
; the portrait goes away (only the sprites that actually overlap are touched).
PORTRAIT_VTILE        EQU WEATHER_TILE - (PORTRAIT_NUM_TILES + PORTRAIT_MAX_MOUTH) ; $bb
PORTRAIT_TALK_FRAMES  EQU 8 ; mouth keeps moving this long after the last letter
PORTRAIT_MOUTH_FRAMES EQU 6 ; frames per mouth open/closed step

; Trainer portrait ids (see TrainerPortraitPointers)
	const_def 1
	const PORTRAIT_AGATHA      ; 01
	const PORTRAIT_ARCHER      ; 02
	const PORTRAIT_ARIANA      ; 03
	const PORTRAIT_BILL        ; 04
	const PORTRAIT_BLAINE      ; 05
	const PORTRAIT_BLUE        ; 06
	const PORTRAIT_BROCK       ; 07
	const PORTRAIT_BRUNO       ; 08
	const PORTRAIT_BUGSY       ; 09
	const PORTRAIT_CHUCK       ; 0a
	const PORTRAIT_CLAIR       ; 0b
	const PORTRAIT_ELM         ; 0c
	const PORTRAIT_ERIKA       ; 0d
	const PORTRAIT_EUSINE      ; 0e
	const PORTRAIT_GREEN       ; 0f
	const PORTRAIT_JANINE      ; 10
	const PORTRAIT_JASMINE     ; 11
	const PORTRAIT_KAREN       ; 12
	const PORTRAIT_KIMONO_GIRL ; 13
	const PORTRAIT_KOGA        ; 14
	const PORTRAIT_LANCE       ; 15
	const PORTRAIT_LORELEI     ; 16
	const PORTRAIT_MISTY       ; 17
	const PORTRAIT_MORTY       ; 18
	const PORTRAIT_OAK         ; 19
	const PORTRAIT_PRYCE       ; 1a
	const PORTRAIT_RED         ; 1b
	const PORTRAIT_SABRINA     ; 1c
	const PORTRAIT_SILVER      ; 1d
	const PORTRAIT_SURGE       ; 1e
	const PORTRAIT_WHITNEY     ; 1f
	const PORTRAIT_WILL        ; 20
NUM_TRAINER_PORTRAITS EQU const_value - 1

; PokeAnims indexes (see engine/gfx/pic_animation.asm)
	const_def
	const ANIM_MON_SLOW
	const ANIM_MON_NORMAL
	const ANIM_MON_MENU
	const ANIM_MON_TRADE
	const ANIM_MON_EVOLVE
	const ANIM_MON_HATCH
	const ANIM_MON_HOF
	const ANIM_MON_EGG1
	const ANIM_MON_EGG2
