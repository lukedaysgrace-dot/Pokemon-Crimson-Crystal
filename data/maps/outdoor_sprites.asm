; Valid sprite IDs for each map group.
; Maps with environment ROUTE or TOWN can only use these sprites.

OutdoorSprites:
; entries correspond to map groups
	dw OlivineGroupSprites
	dw MahoganyGroupSprites
	dw DungeonsGroupSprites
	dw EcruteakGroupSprites
	dw BlackthornGroupSprites
	dw CinnabarGroupSprites
	dw CeruleanGroupSprites
	dw AzaleaGroupSprites
	dw LakeOfRageGroupSprites
	dw VioletGroupSprites
	dw GoldenrodGroupSprites
	dw VermilionGroupSprites
	dw PalletGroupSprites
	dw PewterGroupSprites
	dw FastShipGroupSprites
	dw IndigoGroupSprites
	dw FuchsiaGroupSprites
	dw LavenderGroupSprites
	dw SilverGroupSprites
	dw CableClubGroupSprites
	dw CeladonGroupSprites
	dw CianwoodGroupSprites
	dw ViridianGroupSprites
	dw NewBarkGroupSprites
	dw SaffronGroupSprites
	dw CherrygroveGroupSprites

PalletGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_RED
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

ViridianGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_FIREBREATHER_NEW
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

PewterGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_COSPLAYER ; was SPRITE_SILVER_TROPHY (unused filler) - for Route 3 Cosplayers
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_FIREBREATHER_NEW
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

CinnabarGroupSprites:
; VRAM budget notes (see ArrangeUsedSprites in engine/overworld/overworld.asm
; and _ai_artifacts/reports/OUTDOOR_SPRITE_VRAM_AUDIT.md). This group used to
; pack VRAM bank 0 to
; exactly 128/128 - byte for byte the state CeruleanGroupSprites was in before
; it started rendering NPCs as the player.
; - NURSE and OLD_LINK_RECEPTIONIST removed: both are only used by Pokecenter
;   1F maps, which are indoor and load their own sprites via AddIndoorSprites.
;   Frees 24 tiles, so bank 0 now sits at 104/128.
; - Walkers reordered. Only Routes 19/20/21 and Cinnabar Island are outdoor in
;   this group, and their only NPCs are swimmers/fishers - which were dead last
;   in the list, so their step frames landed in bank 0's font-shared table.
;   Every swimmer here is SPRITEMOVEDATA_SPINRANDOM_FAST, i.e. animating
;   nonstop, so they were the worst possible occupants of that bank.
	db SPRITE_SUICUNE
	db SPRITE_SWIMMER_GIRL ; Routes 19/20/21 trainers (spin constantly)
	db SPRITE_SWIMMER_GUY ; Routes 19/20/21 trainers (spin constantly)
	db SPRITE_FISHER ; Route 19 walker, Route 21 trainer
	db SPRITE_BLUE_CLOAK ; Cinnabar Island
	db SPRITE_GREEN ; Route 20
	db SPRITE_BLUE ; Cinnabar Island (spinner)
	db SPRITE_TEACHER
	db SPRITE_YOUNGSTER
	; --- walkers below here land in VRAM bank 0 (font-shared step frames) ---
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_POKEDEX
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_NONE ; free slot (was SPRITE_NURSE; indoor maps self-load)
	db SPRITE_NONE ; free slot (was SPRITE_OLD_LINK_RECEPTIONIST)

CeruleanGroupSprites:
; VRAM budget notes (see ArrangeUsedSprites in engine/overworld/overworld.asm):
; - Walking sprites are packed FIRST-COME after the player + Suicune into VRAM
;   bank 1 (holds player + Suicune + 7 more walkers). Walkers that overflow into
;   bank 0 have their step frames in the region shared with the overworld font,
;   so they can flicker letters while stepping during textboxes/map-name signs.
; - Order walkers by how much they actually WALK on screen: Cerulean City
;   wanderers and Route 9 trainers first; standing/spinning NPCs later.
; - NURSE and OLD_LINK_RECEPTIONIST were removed: indoor maps load their own
;   sprites (AddIndoorSprites) and no outdoor map in this group uses them.
;   Keeping them overflowed bank 0 and made NPCs render with player tiles.
	db SPRITE_SUICUNE
	db SPRITE_COOLTRAINER_M ; Cerulean City wanderer (also Route 25)
	db SPRITE_SUPER_NERD ; Cerulean City wanderer (also Route 25)
	db SPRITE_FISHER ; Cerulean City walker
	db SPRITE_YOUNGSTER ; Cerulean City spinner
	db SPRITE_PICNICKER_NEW ; Route 9/4/25 trainers
	db SPRITE_CAMPER_NEW ; Route 9 trainers
	db SPRITE_JUGGLER_NEW ; Route 9/25 trainers
	; --- walkers below here land in VRAM bank 0 (font-shared step frames) ---
	db SPRITE_HIKER ; Route 9 (standing trainers; only walk when engaging)
	db SPRITE_COOLTRAINER_F ; Cerulean City (standing; never steps)
	db SPRITE_COSPLAYER ; Route 4/25
	db SPRITE_BIRD_KEEPER_NEW ; Route 4
	db SPRITE_LASS ; Route 25
	db SPRITE_COOLTRAINER_M_NEW ; Route 25
	db SPRITE_ROCKET ; Route 24
	db SPRITE_MISTY ; Route 25
	db SPRITE_POKEFAN_M ; Route 25
	db SPRITE_POKEDEX
	db SPRITE_POKE_BALL
	db SPRITE_SLOWBRO_NPC
	db SPRITE_NONE ; free slot (was SPRITE_NURSE; indoor maps self-load)
	db SPRITE_NONE ; free slot (was SPRITE_OLD_LINK_RECEPTIONIST)
	db SPRITE_NONE ; unused filler; Big Snorlax did not fit this group's VRAM

SaffronGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_HIKER
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_PICNICKER_NEW
	db SPRITE_CAMPER_NEW
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_SLOWBRO_NPC
	db SPRITE_COOLTRAINER_M
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_MISTY
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE

CeladonGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_BATTLE_GIRL ; was SPRITE_SILVER_TROPHY (unused filler) - for Route 7 Battle Girls
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_POLIWRATH_NPC
	db SPRITE_TEACHER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_BIKER
	db SPRITE_SILVER
	db SPRITE_BLUE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

LavenderGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_HIKER
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

VermilionGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_PSYCHIC
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

FuchsiaGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_TAMER ; was SPRITE_SILVER_TROPHY (unused filler) - for Route 18 Tamers
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_HIKER
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_SUPER_NERD
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_TEACHER

IndigoGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_BUENA
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER

NewBarkGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_PSYCHIC
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_GRAMPS
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

CherrygroveGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_PIDGEY
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_RATTATA_UP
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

SilverGroupSprites:
; VRAM budget notes (see ArrangeUsedSprites in engine/overworld/overworld.asm
; and _ai_artifacts/reports/OUTDOOR_SPRITE_VRAM_AUDIT.md). Like
; CinnabarGroupSprites, this group used
; to pack VRAM bank 0 to exactly 128/128 - the pre-fix Cerulean state.
; - NURSE and OLD_LINK_RECEPTIONIST removed: both are only used by Pokecenter
;   1F maps, which are indoor and load their own sprites via AddIndoorSprites.
;   Frees 24 tiles, so bank 0 now sits at 104/128.
; - No reorder needed: Route 28 has no object events and Silver Cave Outside
;   only uses AGATHA and LORELEI, which are already first among the walkers and
;   so keep VRAM bank 1. (Both are SPRITEMOVEDATA_STANDING_DOWN anyway.)
	db SPRITE_SUICUNE
	db SPRITE_AGATHA ; Silver Cave Outside
	db SPRITE_LORELEI ; Silver Cave Outside
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NONE ; free slot (was SPRITE_NURSE; indoor maps self-load)
	db SPRITE_NONE ; free slot (was SPRITE_OLD_LINK_RECEPTIONIST)
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

VioletGroupSprites:
	db SPRITE_ENTEI_NPC
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_GRAMPS
	db SPRITE_CRYSTAL
	db SPRITE_NONE
	db SPRITE_PSYCHIC
	db SPRITE_NONE
	db SPRITE_TWIN
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_CAMPER_NEW
	db SPRITE_PICNICKER_NEW
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_FIREBREATHER_NEW
	db SPRITE_JUGGLER_NEW
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

EcruteakGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

AzaleaGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_HIKER
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_KURT_OUTSIDE
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_TEACHER
	db SPRITE_AZALEA_ROCKET
	db SPRITE_LASS
	db SPRITE_SILVER
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE

GoldenrodGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_DAY_CARE_MON_1
	db SPRITE_POKE_BALL
	db SPRITE_DAY_CARE_MON_2
	db SPRITE_COOLTRAINER_F
	db SPRITE_NONE
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_CAMPER_NEW
	db SPRITE_PICNICKER_NEW
	db SPRITE_ROCKET
	db SPRITE_LASS
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE

CianwoodGroupSprites:
; VRAM budget notes (see ArrangeUsedSprites in engine/overworld/overworld.asm
; and _ai_artifacts/reports/OUTDOOR_SPRITE_VRAM_AUDIT.md).
; Only four maps in this group are outdoor (ROUTE/TOWN) and so use this list:
; Route 40, Route 41, Cianwood City, Battle Tower Outside. Everything else in
; the group is INDOOR/CAVE/GATE and self-loads via AddIndoorSprites - including
; Ice Island, which pulls SKIER_NEW/SNOWBOARDER_NEW without being listed here.
; Eleven entries were dead weight for those four maps and are now SPRITE_NONE,
; taking bank 0 from 116/128 to 24/128. Room for ~8 more 12-tile sprites.
	db SPRITE_NONE ; free slot (was SPRITE_SUICUNE; the Cianwood City beast cameo uses SPRITE_ENTEI)
	db SPRITE_NONE ; free slot (was SPRITE_SILVER_TROPHY; player's-room decor, indoor only)
	db SPRITE_NONE ; free slot (was SPRITE_FAMICOM; player's-room decor, indoor only)
	db SPRITE_NONE ; free slot (was SPRITE_POKEDEX; player's-room decor, indoor only)
	db SPRITE_NONE ; free slot (was SPRITE_WILL; unused by any map in this group)
	db SPRITE_NONE ; free slot (was SPRITE_KAREN; unused by any map in this group)
	db SPRITE_NONE ; free slot (was SPRITE_NURSE; Cianwood Pokecenter 1F is indoor, self-loads)
	db SPRITE_NONE ; free slot (was SPRITE_OLD_LINK_RECEPTIONIST; indoor only)
	db SPRITE_STANDING_YOUNGSTER ; Cianwood City, Route 40, Battle Tower Outside
	db SPRITE_NONE ; free slot (was SPRITE_BIG_ONIX; not on any outdoor map in this group)
	db SPRITE_NONE ; free slot (was SPRITE_SUDOWOODO; not on any outdoor map in this group)
	db SPRITE_NONE ; free slot (was SPRITE_BIG_SNORLAX; not on any outdoor map in this group)
	db SPRITE_OLIVINE_RIVAL ; Route 40/41 swimmer trainers
	db SPRITE_POKEFAN_M ; Cianwood City walker, Route 40
	db SPRITE_LASS ; Cianwood City walker, Route 40, Battle Tower Outside
	db SPRITE_BUENA ; Route 40 (Monica), Battle Tower Outside (wanders)
	db SPRITE_SWIMMER_GIRL ; Route 40/41 trainers
	db SPRITE_ENTEI ; Cianwood City beast cameo
	db SPRITE_SAILOR ; Battle Tower Outside walker
	db SPRITE_POKEFAN_F ; Cianwood City walker (Chuck's wife)
	db SPRITE_MYSTICALMAN ; Cianwood City (Eusine; standing)
	db SPRITE_CRYSTAL_SURF ; Cianwood City (standing)
	db SPRITE_ROCK ; Cianwood City, Route 40 smashable rocks

OlivineGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_PSYCHIC
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BUENA
	db SPRITE_MILTANK
	db SPRITE_SWIMMER_GUY
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK

LakeOfRageGroupSprites:
	db SPRITE_RAIKOU ; was SPRITE_SUICUNE (roaming cameo, no longer used here)
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LANCE
	db SPRITE_GRAMPS
	db SPRITE_POKEMANIAC_NEW
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_PICNICKER_NEW
	db SPRITE_CAMPER_NEW
	db SPRITE_GYARADOS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

MahoganyGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_SKIER_NEW ; was SPRITE_WILL (unused filler) - for Route 44 Skier
	db SPRITE_HIKER
	db SPRITE_NURSE
	db SPRITE_SNOWBOARDER_NEW ; was SPRITE_OLD_LINK_RECEPTIONIST (unused filler) - for Route 44 Boarder
	db SPRITE_ENTEI
	db SPRITE_LANCE
	db SPRITE_SUDOWOODO
	db SPRITE_DRAGON
	db SPRITE_GRAMPS
	db SPRITE_PSYCHIC
	db SPRITE_LASS
	db SPRITE_POKEMANIAC_NEW
	db SPRITE_BIRD_KEEPER_NEW
	db SPRITE_POKEFAN_M
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

BlackthornGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_HIKER
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_COOLTRAINER_F
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_BLACK_BELT
	db SPRITE_CAMPER_NEW
	db SPRITE_COOLTRAINER_M_NEW
	db SPRITE_POKEFAN_M
	db SPRITE_PICNICKER_NEW
	db SPRITE_COOLTRAINER_F_NEW
	db SPRITE_SUPER_NERD
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

DungeonsGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_PSYCHIC
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_GAMEBOY_KID
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_POKEFAN_F
	db SPRITE_TEACHER
	db SPRITE_YOUNGSTER
	db SPRITE_PERSIAN
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_FISHER
	db SPRITE_SCIENTIST
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER

FastShipGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_FISHING_GURU
	db SPRITE_GENTLEMAN
	db SPRITE_SUPER_NERD
	db SPRITE_HO_OH
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_CLEFAIRY
	db SPRITE_POKE_BALL
	db SPRITE_ROCK

CableClubGroupSprites:
	db SPRITE_OAK
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FAIRY
	db SPRITE_SILVER
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
