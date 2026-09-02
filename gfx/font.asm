Font:
INCBIN "gfx/font/font.1bpp"

FontBattleExtra:
INCBIN "gfx/font/font_battle_extra.2bpp"

Frames:
; 8 tiles per frame: "┌" "─" "┐" "│" "└" "┘" "┃" "━"
; (Polished Crystal frame set; ┃/━ are the distinct right/bottom edges)
INCBIN "gfx/frames/1.1bpp"
INCBIN "gfx/frames/2.1bpp"
INCBIN "gfx/frames/3.1bpp"
INCBIN "gfx/frames/4.1bpp"
INCBIN "gfx/frames/5.1bpp"
INCBIN "gfx/frames/6.1bpp"
INCBIN "gfx/frames/7.1bpp"
INCBIN "gfx/frames/8.1bpp"
INCBIN "gfx/frames/9.1bpp"
INCBIN "gfx/frames/10.1bpp"
INCBIN "gfx/frames/11.1bpp"
INCBIN "gfx/frames/12.1bpp"
INCBIN "gfx/frames/13.1bpp"
INCBIN "gfx/frames/14.1bpp"
INCBIN "gfx/frames/15.1bpp"
INCBIN "gfx/frames/16.1bpp"
INCBIN "gfx/frames/17.1bpp"
INCBIN "gfx/frames/18.1bpp"
INCBIN "gfx/frames/19.1bpp"
INCBIN "gfx/frames/20.1bpp"

TypeIconGFX::
; 4 tiles (1bpp) per type, indexed by type constant; drawn as white text
; on a colorbox filled with the type's color (color 3 of the move info pal).
INCBIN "gfx/battle/types.1bpp"

SummaryTypeIconGFX::
; Same pills as TypeIconGFX, but 2bpp so the rounded padding around the box
; can take the summary screen's panel color instead of white:
;   color 0 = padding (panel fill), color 1 = lettering (white),
;   color 3 = pill body (the type color).
; 4 tiles per type, indexed by type constant.
INCBIN "gfx/stats/type_icons.2bpp"

CategoryIconGFX::
; 2 tiles (2bpp) per move category (physical/special/status).
INCBIN "gfx/battle/categories.2bpp"

; Various misc graphics here.

StatsScreenPageTilesGFX:
INCBIN "gfx/stats/stats_tiles.2bpp"

EnemyHPBarBorderGFX:
INCBIN "gfx/battle/enemy_hp_bar_border.1bpp"

HPExpBarBorderGFX:
INCBIN "gfx/battle/hp_exp_bar_border.1bpp"

ExpBarGFX::
INCBIN "gfx/battle/expbar.2bpp"

TownMapGFX:
INCBIN "gfx/pokegear/town_map.2bpp.lz"

UnusedWeekdayKanjiGFX: ; unused kanji
INCBIN "gfx/font/unused_weekday_kanji.2bpp"

UnusedBoldFontGFX: ; unused bold letters + unown chars
INCBIN "gfx/font/unused_bold_font.1bpp"

TextboxSpaceGFX:
INCBIN "gfx/frames/space.1bpp"

UnusedUpArrowGFX: ; unused up arrow + whitespace
INCBIN "gfx/font/unused_up_arrow.1bpp"

MobilePhoneTilesGFX:
INCBIN "gfx/mobile/phone_tiles.2bpp"

MapEntryFrameGFX:
INCBIN "gfx/frames/map_entry_sign.2bpp"
