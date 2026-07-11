tilecoll: MACRO
; used in data/tilesets/*_collision.asm
	db COLL_\1, COLL_\2, COLL_\3, COLL_\4
ENDM


SECTION "Tileset Blockset 1", ROMX

TilesetEmpty1GFX::
	db $ff ; empty LZ stream

TilesetJohtoGFX0::
Tileset0GFX0::
INCBIN "gfx/tilesets/johto.vram0.2bpp.lz"

TilesetJohtoGFX1::
Tileset0GFX1::
INCBIN "gfx/tilesets/johto.vram1.2bpp.lz"

TilesetJohtoMeta::
Tileset0Meta::
INCBIN "data/tilesets/johto_metatiles.bin"

TilesetJohtoAttr::
Tileset0Attr::
INCBIN "data/tilesets/johto_attributes.bin"

TilesetJohtoColl::
Tileset0Coll::
INCLUDE "data/tilesets/johto_collision.asm"

TilesetJohtoModernGFX0::
INCBIN "gfx/tilesets/johto_modern.vram0.2bpp.lz"

TilesetJohtoModernGFX1::
INCBIN "gfx/tilesets/johto_modern.vram1.2bpp.lz"

TilesetJohtoModernMeta::
INCBIN "data/tilesets/johto_modern_metatiles.bin"

TilesetJohtoModernAttr::
INCBIN "data/tilesets/johto_modern_attributes.bin"

TilesetJohtoModernColl::
INCLUDE "data/tilesets/johto_modern_collision.asm"


SECTION "Tileset Blockset 2", ROMX

TilesetEmpty2GFX::
	db $ff ; empty LZ stream

TilesetKantoGFX0::
INCBIN "gfx/tilesets/kanto.vram0.2bpp.lz"

TilesetKantoMeta::
INCBIN "data/tilesets/kanto_metatiles.bin"

TilesetKantoAttr::
INCBIN "data/tilesets/kanto_attributes.bin"

TilesetKantoColl::
INCLUDE "data/tilesets/kanto_collision.asm"

TilesetBattleTowerOutsideGFX0::
INCBIN "gfx/tilesets/battle_tower_outside.vram0.2bpp.lz"

TilesetBattleTowerOutsideGFX1::
INCBIN "gfx/tilesets/battle_tower_outside.vram1.2bpp.lz"

TilesetBattleTowerOutsideMeta::
INCBIN "data/tilesets/battle_tower_outside_metatiles.bin"

TilesetBattleTowerOutsideAttr::
INCBIN "data/tilesets/battle_tower_outside_attributes.bin"

TilesetBattleTowerOutsideColl::
INCLUDE "data/tilesets/battle_tower_outside_collision.asm"


SECTION "Tileset Blockset 3", ROMX

TilesetEmpty3GFX::
	db $ff ; empty LZ stream

TilesetHouseGFX0::
INCBIN "gfx/tilesets/house.vram0.2bpp.lz"

TilesetHouseMeta::
INCBIN "data/tilesets/house_metatiles.bin"

TilesetHouseAttr::
INCBIN "data/tilesets/house_attributes.bin"

TilesetHouseColl::
INCLUDE "data/tilesets/house_collision.asm"

TilesetPlayersHouseGFX0::
INCBIN "gfx/tilesets/players_house.vram0.2bpp.lz"

TilesetPlayersHouseMeta::
INCBIN "data/tilesets/players_house_metatiles.bin"

TilesetPlayersHouseAttr::
INCBIN "data/tilesets/players_house_attributes.bin"

TilesetPlayersHouseColl::
INCLUDE "data/tilesets/players_house_collision.asm"

TilesetPokecenterGFX0::
INCBIN "gfx/tilesets/pokecenter.vram0.2bpp.lz"

TilesetPokecenterMeta::
INCBIN "data/tilesets/pokecenter_metatiles.bin"

TilesetPokecenterAttr::
INCBIN "data/tilesets/pokecenter_attributes.bin"

TilesetPokecenterColl::
INCLUDE "data/tilesets/pokecenter_collision.asm"

TilesetGateGFX0::
INCBIN "gfx/tilesets/gate.vram0.2bpp.lz"

TilesetGateMeta::
INCBIN "data/tilesets/gate_metatiles.bin"

TilesetGateAttr::
INCBIN "data/tilesets/gate_attributes.bin"

TilesetGateColl::
INCLUDE "data/tilesets/gate_collision.asm"


SECTION "Tileset Blockset 4", ROMX

TilesetEmpty4GFX::
	db $ff ; empty LZ stream

TilesetPortGFX0::
INCBIN "gfx/tilesets/port.vram0.2bpp.lz"

TilesetPortMeta::
INCBIN "data/tilesets/port_metatiles.bin"

TilesetPortAttr::
INCBIN "data/tilesets/port_attributes.bin"

TilesetPortColl::
INCLUDE "data/tilesets/port_collision.asm"

TilesetLabGFX0::
INCBIN "gfx/tilesets/lab.vram0.2bpp.lz"

TilesetLabGFX1::
INCBIN "gfx/tilesets/lab.vram1.2bpp.lz"

TilesetLabMeta::
INCBIN "data/tilesets/lab_metatiles.bin"

TilesetLabAttr::
INCBIN "data/tilesets/lab_attributes.bin"

TilesetLabColl::
INCLUDE "data/tilesets/lab_collision.asm"

TilesetFacilityGFX0::
INCBIN "gfx/tilesets/facility.vram0.2bpp.lz"

TilesetFacilityMeta::
INCBIN "data/tilesets/facility_metatiles.bin"

TilesetFacilityAttr::
INCBIN "data/tilesets/facility_attributes.bin"

TilesetFacilityColl::
INCLUDE "data/tilesets/facility_collision.asm"


SECTION "Tileset Blockset 5", ROMX

TilesetEmpty5GFX::
	db $ff ; empty LZ stream

TilesetMartGFX0::
INCBIN "gfx/tilesets/mart.vram0.2bpp.lz"

TilesetMartGFX1::
INCBIN "gfx/tilesets/mart.vram1.2bpp.lz"

TilesetMartMeta::
INCBIN "data/tilesets/mart_metatiles.bin"

TilesetMartAttr::
INCBIN "data/tilesets/mart_attributes.bin"

TilesetMartColl::
INCLUDE "data/tilesets/mart_collision.asm"

TilesetMansionGFX0::
INCBIN "gfx/tilesets/mansion.vram0.2bpp.lz"

TilesetMansionGFX1::
INCBIN "gfx/tilesets/mansion.vram1.2bpp.lz"

TilesetMansionMeta::
INCBIN "data/tilesets/mansion_metatiles.bin"

TilesetMansionAttr::
INCBIN "data/tilesets/mansion_attributes.bin"

TilesetMansionColl::
INCLUDE "data/tilesets/mansion_collision.asm"

TilesetGameCornerGFX0::
INCBIN "gfx/tilesets/game_corner.vram0.2bpp.lz"

TilesetGameCornerGFX1::
INCBIN "gfx/tilesets/game_corner.vram1.2bpp.lz"

TilesetGameCornerMeta::
INCBIN "data/tilesets/game_corner_metatiles.bin"

TilesetGameCornerAttr::
INCBIN "data/tilesets/game_corner_attributes.bin"

TilesetGameCornerColl::
INCLUDE "data/tilesets/game_corner_collision.asm"


SECTION "Tileset Blockset 6", ROMX

TilesetEmpty6GFX::
	db $ff ; empty LZ stream

TilesetEliteFourRoomGFX0::
INCBIN "gfx/tilesets/elite_four_room.vram0.2bpp.lz"

TilesetEliteFourRoomMeta::
INCBIN "data/tilesets/elite_four_room_metatiles.bin"

TilesetEliteFourRoomAttr::
INCBIN "data/tilesets/elite_four_room_attributes.bin"

TilesetEliteFourRoomColl::
INCLUDE "data/tilesets/elite_four_room_collision.asm"

TilesetTraditionalHouseGFX0::
INCBIN "gfx/tilesets/traditional_house.vram0.2bpp.lz"

TilesetTraditionalHouseMeta::
INCBIN "data/tilesets/traditional_house_metatiles.bin"

TilesetTraditionalHouseAttr::
INCBIN "data/tilesets/traditional_house_attributes.bin"

TilesetTraditionalHouseColl::
INCLUDE "data/tilesets/traditional_house_collision.asm"

TilesetTrainStationGFX0::
INCBIN "gfx/tilesets/train_station.vram0.2bpp.lz"

TilesetTrainStationGFX1::
INCBIN "gfx/tilesets/train_station.vram1.2bpp.lz"

TilesetTrainStationMeta::
INCBIN "data/tilesets/train_station_metatiles.bin"

TilesetTrainStationAttr::
INCBIN "data/tilesets/train_station_attributes.bin"

TilesetTrainStationColl::
INCLUDE "data/tilesets/train_station_collision.asm"

TilesetChampionsRoomGFX0::
INCBIN "gfx/tilesets/champions_room.vram0.2bpp.lz"

TilesetChampionsRoomGFX1::
INCBIN "gfx/tilesets/champions_room.vram1.2bpp.lz"

TilesetChampionsRoomMeta::
INCBIN "data/tilesets/champions_room_metatiles.bin"

TilesetChampionsRoomAttr::
INCBIN "data/tilesets/champions_room_attributes.bin"

TilesetChampionsRoomColl::
INCLUDE "data/tilesets/champions_room_collision.asm"


SECTION "Tileset Blockset 7", ROMX

TilesetEmpty7GFX::
	db $ff ; empty LZ stream

TilesetLighthouseGFX0::
INCBIN "gfx/tilesets/lighthouse.vram0.2bpp.lz"

TilesetLighthouseGFX1::
INCBIN "gfx/tilesets/lighthouse.vram1.2bpp.lz"

TilesetLighthouseMeta::
INCBIN "data/tilesets/lighthouse_metatiles.bin"

TilesetLighthouseAttr::
INCBIN "data/tilesets/lighthouse_attributes.bin"

TilesetLighthouseColl::
INCLUDE "data/tilesets/lighthouse_collision.asm"

TilesetPlayersRoomGFX0::
INCBIN "gfx/tilesets/players_room.vram0.2bpp.lz"

TilesetPlayersRoomMeta::
INCBIN "data/tilesets/players_room_metatiles.bin"

TilesetPlayersRoomAttr::
INCBIN "data/tilesets/players_room_attributes.bin"

TilesetPlayersRoomColl::
INCLUDE "data/tilesets/players_room_collision.asm"

TilesetPokeComCenterGFX0::
INCBIN "gfx/tilesets/poke_com_center.vram0.2bpp.lz"

TilesetPokeComCenterGFX1::
INCBIN "gfx/tilesets/poke_com_center.vram1.2bpp.lz"

TilesetPokeComCenterMeta::
INCBIN "data/tilesets/poke_com_center_metatiles.bin"

TilesetPokeComCenterAttr::
INCBIN "data/tilesets/poke_com_center_attributes.bin"

TilesetPokeComCenterColl::
INCLUDE "data/tilesets/pokecom_center_collision.asm"

TilesetBattleTowerGFX0::
INCBIN "gfx/tilesets/battle_tower.vram0.2bpp.lz"

TilesetBattleTowerGFX1::
INCBIN "gfx/tilesets/battle_tower.vram1.2bpp.lz"

TilesetBattleTowerMeta::
INCBIN "data/tilesets/battle_tower_metatiles.bin"

TilesetBattleTowerAttr::
INCBIN "data/tilesets/battle_tower_attributes.bin"

TilesetBattleTowerColl::
INCLUDE "data/tilesets/battle_tower_collision.asm"


SECTION "Tileset Blockset 8", ROMX

TilesetEmpty8GFX::
	db $ff ; empty LZ stream

TilesetTowerGFX0::
INCBIN "gfx/tilesets/tower.vram0.2bpp.lz"

TilesetTowerGFX1::
INCBIN "gfx/tilesets/tower.vram1.2bpp.lz"

TilesetTowerMeta::
INCBIN "data/tilesets/tower_metatiles.bin"

TilesetTowerAttr::
INCBIN "data/tilesets/tower_attributes.bin"

TilesetTowerColl::
INCLUDE "data/tilesets/tower_collision.asm"

TilesetCaveGFX0::
INCBIN "gfx/tilesets/cave.vram0.2bpp.lz"

TilesetCaveMeta::
INCBIN "data/tilesets/cave_metatiles.bin"

TilesetCaveAttr::
INCBIN "data/tilesets/cave_attributes.bin"

TilesetCaveColl::
INCLUDE "data/tilesets/cave_collision.asm"

TilesetParkGFX0::
INCBIN "gfx/tilesets/park.vram0.2bpp.lz"

TilesetParkGFX1::
INCBIN "gfx/tilesets/park.vram1.2bpp.lz"

TilesetParkMeta::
INCBIN "data/tilesets/park_metatiles.bin"

TilesetParkAttr::
INCBIN "data/tilesets/park_attributes.bin"

TilesetParkColl::
INCLUDE "data/tilesets/park_collision.asm"

TilesetRuinsOfAlphGFX0::
INCBIN "gfx/tilesets/ruins_of_alph.vram0.2bpp.lz"

TilesetRuinsOfAlphGFX1::
INCBIN "gfx/tilesets/ruins_of_alph.vram1.2bpp.lz"

TilesetRuinsOfAlphMeta::
INCBIN "data/tilesets/ruins_of_alph_metatiles.bin"

TilesetRuinsOfAlphAttr::
INCBIN "data/tilesets/ruins_of_alph_attributes.bin"

TilesetRuinsOfAlphColl::
INCLUDE "data/tilesets/ruins_of_alph_collision.asm"


SECTION "Tileset Blockset 9", ROMX

TilesetEmpty9GFX::
	db $ff ; empty LZ stream

TilesetRadioTowerGFX0::
INCBIN "gfx/tilesets/radio_tower.vram0.2bpp.lz"

TilesetRadioTowerGFX1::
INCBIN "gfx/tilesets/radio_tower.vram1.2bpp.lz"

TilesetRadioTowerMeta::
INCBIN "data/tilesets/radio_tower_metatiles.bin"

TilesetRadioTowerAttr::
INCBIN "data/tilesets/radio_tower_attributes.bin"

TilesetRadioTowerColl::
INCLUDE "data/tilesets/radio_tower_collision.asm"

TilesetUndergroundGFX0::
INCBIN "gfx/tilesets/underground.vram0.2bpp.lz"

TilesetUndergroundMeta::
INCBIN "data/tilesets/underground_metatiles.bin"

TilesetUndergroundAttr::
INCBIN "data/tilesets/underground_attributes.bin"

TilesetUndergroundColl::
INCLUDE "data/tilesets/underground_collision.asm"

TilesetIcePathGFX0::
INCBIN "gfx/tilesets/ice_path.vram0.2bpp.lz"

TilesetIcePathGFX1::
INCBIN "gfx/tilesets/ice_path.vram1.2bpp.lz"

TilesetIcePathMeta::
INCBIN "data/tilesets/ice_path_metatiles.bin"

TilesetIcePathAttr::
INCBIN "data/tilesets/ice_path_attributes.bin"

TilesetIcePathColl::
INCLUDE "data/tilesets/ice_path_collision.asm"

TilesetDarkCaveGFX0::
INCBIN "gfx/tilesets/dark_cave.vram0.2bpp.lz"

TilesetDarkCaveMeta::
INCBIN "data/tilesets/dark_cave_metatiles.bin"

TilesetDarkCaveAttr::
INCBIN "data/tilesets/dark_cave_attributes.bin"

TilesetDarkCaveColl::
INCLUDE "data/tilesets/cave_collision.asm"


SECTION "Tileset Blockset 10", ROMX

TilesetEmpty10GFX::
	db $ff ; empty LZ stream

TilesetForestGFX0::
INCBIN "gfx/tilesets/forest.vram0.2bpp.lz"

TilesetForestGFX1::
INCBIN "gfx/tilesets/forest.vram1.2bpp.lz"

TilesetForestMeta::
INCBIN "data/tilesets/forest_metatiles.bin"

TilesetForestAttr::
INCBIN "data/tilesets/forest_attributes.bin"

TilesetForestColl::
INCLUDE "data/tilesets/forest_collision.asm"

TilesetBetaWordRoomGFX0::
INCBIN "gfx/tilesets/beta_word_room.vram0.2bpp.lz"

TilesetBetaWordRoomGFX1::
INCBIN "gfx/tilesets/beta_word_room.vram1.2bpp.lz"

TilesetBetaWordRoomMeta::
INCBIN "data/tilesets/beta_word_room_metatiles.bin"

TilesetBetaWordRoomAttr::
INCBIN "data/tilesets/beta_word_room_attributes.bin"

TilesetBetaWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"

TilesetHoOhWordRoomGFX0::
INCBIN "gfx/tilesets/ho_oh_word_room.vram0.2bpp.lz"

TilesetHoOhWordRoomGFX1::
INCBIN "gfx/tilesets/ho_oh_word_room.vram1.2bpp.lz"

TilesetHoOhWordRoomMeta::
INCBIN "data/tilesets/ho_oh_word_room_metatiles.bin"

TilesetHoOhWordRoomAttr::
INCBIN "data/tilesets/ho_oh_word_room_attributes.bin"

TilesetHoOhWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"


SECTION "Tileset Blockset 11", ROMX

TilesetEmpty11GFX::
	db $ff ; empty LZ stream

TilesetKabutoWordRoomGFX0::
INCBIN "gfx/tilesets/kabuto_word_room.vram0.2bpp.lz"

TilesetKabutoWordRoomGFX1::
INCBIN "gfx/tilesets/kabuto_word_room.vram1.2bpp.lz"

TilesetKabutoWordRoomMeta::
INCBIN "data/tilesets/kabuto_word_room_metatiles.bin"

TilesetKabutoWordRoomAttr::
INCBIN "data/tilesets/kabuto_word_room_attributes.bin"

TilesetKabutoWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"

TilesetOmanyteWordRoomGFX0::
INCBIN "gfx/tilesets/omanyte_word_room.vram0.2bpp.lz"

TilesetOmanyteWordRoomGFX1::
INCBIN "gfx/tilesets/omanyte_word_room.vram1.2bpp.lz"

TilesetOmanyteWordRoomMeta::
INCBIN "data/tilesets/omanyte_word_room_metatiles.bin"

TilesetOmanyteWordRoomAttr::
INCBIN "data/tilesets/omanyte_word_room_attributes.bin"

TilesetOmanyteWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"

TilesetAerodactylWordRoomGFX0::
INCBIN "gfx/tilesets/aerodactyl_word_room.vram0.2bpp.lz"

TilesetAerodactylWordRoomGFX1::
INCBIN "gfx/tilesets/aerodactyl_word_room.vram1.2bpp.lz"

TilesetAerodactylWordRoomMeta::
INCBIN "data/tilesets/aerodactyl_word_room_metatiles.bin"

TilesetAerodactylWordRoomAttr::
INCBIN "data/tilesets/aerodactyl_word_room_attributes.bin"

TilesetAerodactylWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"


SECTION "Tileset Blockset 12", ROMX

TilesetEmpty12GFX::
	db $ff ; empty LZ stream

TilesetPolishedBattleFactoryAGFX0::
INCBIN "gfx/tilesets/polished_battle_factory_a.vram0.2bpp.lz"

TilesetPolishedBattleFactoryAGFX1::
INCBIN "gfx/tilesets/polished_battle_factory_a.vram1.2bpp.lz"

TilesetPolishedBattleFactoryAMeta::
INCBIN "data/tilesets/polished_battle_factory_a_metatiles.bin"

TilesetPolishedBattleFactoryAAttr::
INCBIN "data/tilesets/polished_battle_factory_a_attributes.bin"

TilesetPolishedBattleFactoryAColl::
INCLUDE "data/tilesets/polished_battle_factory_a_collision.asm"

TilesetPolishedBattleFactoryBGFX0::
INCBIN "gfx/tilesets/polished_battle_factory_b.vram0.2bpp.lz"

TilesetPolishedBattleFactoryBGFX1::
INCBIN "gfx/tilesets/polished_battle_factory_b.vram1.2bpp.lz"

TilesetPolishedBattleFactoryBMeta::
INCBIN "data/tilesets/polished_battle_factory_b_metatiles.bin"

TilesetPolishedBattleFactoryBAttr::
INCBIN "data/tilesets/polished_battle_factory_b_attributes.bin"

TilesetPolishedBattleFactoryBColl::
INCLUDE "data/tilesets/polished_battle_factory_b_collision.asm"

TilesetPolishedBattleTowerInsideGFX0::
INCBIN "gfx/tilesets/polished_battle_tower_inside.vram0.2bpp.lz"

TilesetPolishedBattleTowerInsideGFX1::
INCBIN "gfx/tilesets/polished_battle_tower_inside.vram1.2bpp.lz"

TilesetPolishedBattleTowerInsideMeta::
INCBIN "data/tilesets/polished_battle_tower_inside_metatiles.bin"

TilesetPolishedBattleTowerInsideAttr::
INCBIN "data/tilesets/polished_battle_tower_inside_attributes.bin"

TilesetPolishedBattleTowerInsideColl::
INCLUDE "data/tilesets/polished_battle_tower_inside_collision.asm"


SECTION "Tileset Blockset 13", ROMX

TilesetEmpty13GFX::
	db $ff ; empty LZ stream

TilesetPolishedBattleTowerOutsideGFX0::
INCBIN "gfx/tilesets/polished_battle_tower_outside.vram0.2bpp.lz"

TilesetPolishedBattleTowerOutsideGFX1::
INCBIN "gfx/tilesets/polished_battle_tower_outside.vram1.2bpp.lz"

TilesetPolishedBattleTowerOutsideMeta::
INCBIN "data/tilesets/polished_battle_tower_outside_metatiles.bin"

TilesetPolishedBattleTowerOutsideAttr::
INCBIN "data/tilesets/polished_battle_tower_outside_attributes.bin"

TilesetPolishedBattleTowerOutsideColl::
INCLUDE "data/tilesets/polished_battle_tower_outside_collision.asm"

TilesetPolishedCaveGFX0::
INCBIN "gfx/tilesets/polished_cave.vram0.2bpp.lz"

TilesetPolishedCaveGFX1::
INCBIN "gfx/tilesets/polished_cave.vram1.2bpp.lz"

TilesetPolishedCaveMeta::
INCBIN "data/tilesets/polished_cave_metatiles.bin"

TilesetPolishedCaveAttr::
INCBIN "data/tilesets/polished_cave_attributes.bin"

TilesetPolishedCaveColl::
INCLUDE "data/tilesets/polished_cave_collision.asm"


SECTION "Tileset Blockset 14", ROMX

TilesetEmpty14GFX::
	db $ff ; empty LZ stream

TilesetPolishedChampionsRoomGFX0::
INCBIN "gfx/tilesets/polished_champions_room.vram0.2bpp.lz"

TilesetPolishedChampionsRoomGFX1::
INCBIN "gfx/tilesets/polished_champions_room.vram1.2bpp.lz"

TilesetPolishedChampionsRoomMeta::
INCBIN "data/tilesets/polished_champions_room_metatiles.bin"

TilesetPolishedChampionsRoomAttr::
INCBIN "data/tilesets/polished_champions_room_attributes.bin"

TilesetPolishedChampionsRoomColl::
INCLUDE "data/tilesets/polished_champions_room_collision.asm"

TilesetPolishedHomeDecorStoreGFX0::
INCBIN "gfx/tilesets/polished_home_decor_store.vram0.2bpp.lz"

TilesetPolishedHomeDecorStoreGFX1::
INCBIN "gfx/tilesets/polished_home_decor_store.vram1.2bpp.lz"

TilesetPolishedHomeDecorStoreMeta::
INCBIN "data/tilesets/polished_home_decor_store_metatiles.bin"

TilesetPolishedHomeDecorStoreAttr::
INCBIN "data/tilesets/polished_home_decor_store_attributes.bin"

TilesetPolishedHomeDecorStoreColl::
INCLUDE "data/tilesets/polished_home_decor_store_collision.asm"

TilesetPolishedEcruteakShrineGFX0::
INCBIN "gfx/tilesets/polished_ecruteak_shrine.vram0.2bpp.lz"

TilesetPolishedEcruteakShrineGFX1::
INCBIN "gfx/tilesets/polished_ecruteak_shrine.vram1.2bpp.lz"

TilesetPolishedEcruteakShrineGFX2::
INCBIN "gfx/tilesets/polished_ecruteak_shrine.vram2.2bpp.lz"

TilesetPolishedEcruteakShrineMeta::
INCBIN "data/tilesets/polished_ecruteak_shrine_metatiles.bin"

TilesetPolishedEcruteakShrineAttr::
INCBIN "data/tilesets/polished_ecruteak_shrine_attributes.bin"

TilesetPolishedEcruteakShrineColl::
INCLUDE "data/tilesets/polished_ecruteak_shrine_collision.asm"


SECTION "Tileset Blockset 15", ROMX

TilesetEmpty15GFX::
	db $ff ; empty LZ stream

TilesetPolishedFacilityGFX0::
INCBIN "gfx/tilesets/polished_facility.vram0.2bpp.lz"

TilesetPolishedFacilityGFX1::
INCBIN "gfx/tilesets/polished_facility.vram1.2bpp.lz"

TilesetPolishedFacilityMeta::
INCBIN "data/tilesets/polished_facility_metatiles.bin"

TilesetPolishedFacilityAttr::
INCBIN "data/tilesets/polished_facility_attributes.bin"

TilesetPolishedFacilityColl::
INCLUDE "data/tilesets/polished_facility_collision.asm"

TilesetPolishedFarawayIslandGFX0::
INCBIN "gfx/tilesets/polished_faraway_island.vram0.2bpp.lz"

TilesetPolishedFarawayIslandGFX1::
INCBIN "gfx/tilesets/polished_faraway_island.vram1.2bpp.lz"

TilesetPolishedFarawayIslandMeta::
INCBIN "data/tilesets/polished_faraway_island_metatiles.bin"

TilesetPolishedFarawayIslandAttr::
INCBIN "data/tilesets/polished_faraway_island_attributes.bin"

TilesetPolishedFarawayIslandColl::
INCLUDE "data/tilesets/polished_faraway_island_collision.asm"


SECTION "Tileset Blockset 16", ROMX

TilesetEmpty16GFX::
	db $ff ; empty LZ stream

TilesetPolishedForestAGFX0::
INCBIN "gfx/tilesets/polished_forest_a.vram0.2bpp.lz"

TilesetPolishedForestAGFX1::
INCBIN "gfx/tilesets/polished_forest_a.vram1.2bpp.lz"

TilesetPolishedForestAMeta::
INCBIN "data/tilesets/polished_forest_a_metatiles.bin"

TilesetPolishedForestAAttr::
INCBIN "data/tilesets/polished_forest_a_attributes.bin"

TilesetPolishedForestAColl::
INCLUDE "data/tilesets/polished_forest_a_collision.asm"

TilesetPolishedGameCornerGFX0::
INCBIN "gfx/tilesets/polished_game_corner.vram0.2bpp.lz"

TilesetPolishedGameCornerGFX1::
INCBIN "gfx/tilesets/polished_game_corner.vram1.2bpp.lz"

TilesetPolishedGameCornerMeta::
INCBIN "data/tilesets/polished_game_corner_metatiles.bin"

TilesetPolishedGameCornerAttr::
INCBIN "data/tilesets/polished_game_corner_attributes.bin"

TilesetPolishedGameCornerColl::
INCLUDE "data/tilesets/polished_game_corner_collision.asm"


SECTION "Tileset Blockset 17", ROMX

TilesetEmpty17GFX::
	db $ff ; empty LZ stream

TilesetPolishedGateGFX0::
INCBIN "gfx/tilesets/polished_gate.vram0.2bpp.lz"

TilesetPolishedGateGFX1::
INCBIN "gfx/tilesets/polished_gate.vram1.2bpp.lz"

TilesetPolishedGateMeta::
INCBIN "data/tilesets/polished_gate_metatiles.bin"

TilesetPolishedGateAttr::
INCBIN "data/tilesets/polished_gate_attributes.bin"

TilesetPolishedGateColl::
INCLUDE "data/tilesets/polished_gate_collision.asm"


SECTION "Tileset Blockset 18", ROMX

TilesetEmpty18GFX::
	db $ff ; empty LZ stream

TilesetPolishedGymAGFX0::
INCBIN "gfx/tilesets/polished_gym_a.vram0.2bpp.lz"

TilesetPolishedGymAGFX1::
INCBIN "gfx/tilesets/polished_gym_a.vram1.2bpp.lz"

TilesetPolishedGymAGFX2::
INCBIN "gfx/tilesets/polished_gym_a.vram2.2bpp.lz"

TilesetPolishedGymAMeta::
INCBIN "data/tilesets/polished_gym_a_metatiles.bin"

TilesetPolishedGymAAttr::
INCBIN "data/tilesets/polished_gym_a_attributes.bin"

TilesetPolishedGymAColl::
INCLUDE "data/tilesets/polished_gym_a_collision.asm"


SECTION "Tileset Blockset 19", ROMX

TilesetEmpty19GFX::
	db $ff ; empty LZ stream

TilesetPolishedGymBGFX0::
INCBIN "gfx/tilesets/polished_gym_b.vram0.2bpp.lz"

TilesetPolishedGymBGFX1::
INCBIN "gfx/tilesets/polished_gym_b.vram1.2bpp.lz"

TilesetPolishedGymBGFX2::
INCBIN "gfx/tilesets/polished_gym_b.vram2.2bpp.lz"

TilesetPolishedGymBMeta::
INCBIN "data/tilesets/polished_gym_b_metatiles.bin"

TilesetPolishedGymBAttr::
INCBIN "data/tilesets/polished_gym_b_attributes.bin"

TilesetPolishedGymBColl::
INCLUDE "data/tilesets/polished_gym_b_collision.asm"

TilesetPolishedHiddenGrottoGFX0::
INCBIN "gfx/tilesets/polished_hidden_grotto.vram0.2bpp.lz"

TilesetPolishedHiddenGrottoMeta::
INCBIN "data/tilesets/polished_hidden_grotto_metatiles.bin"

TilesetPolishedHiddenGrottoAttr::
INCBIN "data/tilesets/polished_hidden_grotto_attributes.bin"

TilesetPolishedHiddenGrottoColl::
INCLUDE "data/tilesets/polished_hidden_grotto_collision.asm"


SECTION "Tileset Blockset 20", ROMX

TilesetEmpty20GFX::
	db $ff ; empty LZ stream

TilesetPolishedHideoutGFX0::
INCBIN "gfx/tilesets/polished_hideout.vram0.2bpp.lz"

TilesetPolishedHideoutGFX1::
INCBIN "gfx/tilesets/polished_hideout.vram1.2bpp.lz"

TilesetPolishedHideoutMeta::
INCBIN "data/tilesets/polished_hideout_metatiles.bin"

TilesetPolishedHideoutAttr::
INCBIN "data/tilesets/polished_hideout_attributes.bin"

TilesetPolishedHideoutColl::
INCLUDE "data/tilesets/polished_hideout_collision.asm"

TilesetPolishedHotelGFX0::
INCBIN "gfx/tilesets/polished_hotel.vram0.2bpp.lz"

TilesetPolishedHotelGFX1::
INCBIN "gfx/tilesets/polished_hotel.vram1.2bpp.lz"

TilesetPolishedHotelMeta::
INCBIN "data/tilesets/polished_hotel_metatiles.bin"

TilesetPolishedHotelAttr::
INCBIN "data/tilesets/polished_hotel_attributes.bin"

TilesetPolishedHotelColl::
INCLUDE "data/tilesets/polished_hotel_collision.asm"


SECTION "Tileset Blockset 21", ROMX

TilesetEmpty21GFX::
	db $ff ; empty LZ stream

TilesetPolishedIcePathGFX0::
INCBIN "gfx/tilesets/polished_ice_path.vram0.2bpp.lz"

TilesetPolishedIcePathGFX1::
INCBIN "gfx/tilesets/polished_ice_path.vram1.2bpp.lz"

TilesetPolishedIcePathMeta::
INCBIN "data/tilesets/polished_ice_path_metatiles.bin"

TilesetPolishedIcePathAttr::
INCBIN "data/tilesets/polished_ice_path_attributes.bin"

TilesetPolishedIcePathColl::
INCLUDE "data/tilesets/polished_ice_path_collision.asm"


SECTION "Tileset Blockset 22", ROMX

TilesetEmpty22GFX::
	db $ff ; empty LZ stream

TilesetPolishedIndigoPlateauGFX0::
INCBIN "gfx/tilesets/polished_indigo_plateau.vram0.2bpp.lz"

TilesetPolishedIndigoPlateauGFX1::
INCBIN "gfx/tilesets/polished_indigo_plateau.vram1.2bpp.lz"

TilesetPolishedIndigoPlateauMeta::
INCBIN "data/tilesets/polished_indigo_plateau_metatiles.bin"

TilesetPolishedIndigoPlateauAttr::
INCBIN "data/tilesets/polished_indigo_plateau_attributes.bin"

TilesetPolishedIndigoPlateauColl::
INCLUDE "data/tilesets/polished_indigo_plateau_collision.asm"


SECTION "Tileset Blockset 23", ROMX

TilesetEmpty23GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoAncientGFX0::
INCBIN "gfx/tilesets/polished_johto_ancient.vram0.2bpp.lz"

TilesetPolishedJohtoAncientGFX1::
INCBIN "gfx/tilesets/polished_johto_ancient.vram1.2bpp.lz"

TilesetPolishedJohtoAncientMeta::
INCBIN "data/tilesets/polished_johto_ancient_metatiles.bin"

TilesetPolishedJohtoAncientAttr::
INCBIN "data/tilesets/polished_johto_ancient_attributes.bin"

TilesetPolishedJohtoAncientColl::
INCLUDE "data/tilesets/polished_johto_ancient_collision.asm"


SECTION "Tileset Blockset 24", ROMX

TilesetEmpty24GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoCoastAGFX0::
INCBIN "gfx/tilesets/polished_johto_coast_a.vram0.2bpp.lz"

TilesetPolishedJohtoCoastAGFX1::
INCBIN "gfx/tilesets/polished_johto_coast_a.vram1.2bpp.lz"

TilesetPolishedJohtoCoastAGFX2::
INCBIN "gfx/tilesets/polished_johto_coast_a.vram2.2bpp.lz"

TilesetPolishedJohtoCoastAMeta::
INCBIN "data/tilesets/polished_johto_coast_a_metatiles.bin"

TilesetPolishedJohtoCoastAAttr::
INCBIN "data/tilesets/polished_johto_coast_a_attributes.bin"

TilesetPolishedJohtoCoastAColl::
INCLUDE "data/tilesets/polished_johto_coast_a_collision.asm"


SECTION "Tileset Blockset 25", ROMX

TilesetEmpty25GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoCoastBGFX0::
INCBIN "gfx/tilesets/polished_johto_coast_b.vram0.2bpp.lz"

TilesetPolishedJohtoCoastBGFX1::
INCBIN "gfx/tilesets/polished_johto_coast_b.vram1.2bpp.lz"

TilesetPolishedJohtoCoastBGFX2::
INCBIN "gfx/tilesets/polished_johto_coast_b.vram2.2bpp.lz"

TilesetPolishedJohtoCoastBMeta::
INCBIN "data/tilesets/polished_johto_coast_b_metatiles.bin"

TilesetPolishedJohtoCoastBAttr::
INCBIN "data/tilesets/polished_johto_coast_b_attributes.bin"

TilesetPolishedJohtoCoastBColl::
INCLUDE "data/tilesets/polished_johto_coast_b_collision.asm"


SECTION "Tileset Blockset 26", ROMX

TilesetEmpty26GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoHouseAGFX0::
INCBIN "gfx/tilesets/polished_johto_house_a.vram0.2bpp.lz"

TilesetPolishedJohtoHouseAGFX1::
INCBIN "gfx/tilesets/polished_johto_house_a.vram1.2bpp.lz"

TilesetPolishedJohtoHouseAMeta::
INCBIN "data/tilesets/polished_johto_house_a_metatiles.bin"

TilesetPolishedJohtoHouseAAttr::
INCBIN "data/tilesets/polished_johto_house_a_attributes.bin"

TilesetPolishedJohtoHouseAColl::
INCLUDE "data/tilesets/polished_johto_house_a_collision.asm"


SECTION "Tileset Blockset 27", ROMX

TilesetEmpty27GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoModernAGFX0::
INCBIN "gfx/tilesets/polished_johto_modern_a.vram0.2bpp.lz"

TilesetPolishedJohtoModernAGFX1::
INCBIN "gfx/tilesets/polished_johto_modern_a.vram1.2bpp.lz"

TilesetPolishedJohtoModernAGFX2::
INCBIN "gfx/tilesets/polished_johto_modern_a.vram2.2bpp.lz"

TilesetPolishedJohtoModernAMeta::
INCBIN "data/tilesets/polished_johto_modern_a_metatiles.bin"

TilesetPolishedJohtoModernAAttr::
INCBIN "data/tilesets/polished_johto_modern_a_attributes.bin"

TilesetPolishedJohtoModernAColl::
INCLUDE "data/tilesets/polished_johto_modern_a_collision.asm"


SECTION "Tileset Blockset 28", ROMX

TilesetEmpty28GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoOutlandsAGFX0::
INCBIN "gfx/tilesets/polished_johto_outlands_a.vram0.2bpp.lz"

TilesetPolishedJohtoOutlandsAGFX1::
INCBIN "gfx/tilesets/polished_johto_outlands_a.vram1.2bpp.lz"

TilesetPolishedJohtoOutlandsAMeta::
INCBIN "data/tilesets/polished_johto_outlands_a_metatiles.bin"

TilesetPolishedJohtoOutlandsAAttr::
INCBIN "data/tilesets/polished_johto_outlands_a_attributes.bin"

TilesetPolishedJohtoOutlandsAColl::
INCLUDE "data/tilesets/polished_johto_outlands_a_collision.asm"


SECTION "Tileset Blockset 29", ROMX

TilesetEmpty29GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoTraditionalAGFX0::
INCBIN "gfx/tilesets/polished_johto_traditional_a.vram0.2bpp.lz"

TilesetPolishedJohtoTraditionalAGFX1::
INCBIN "gfx/tilesets/polished_johto_traditional_a.vram1.2bpp.lz"

TilesetPolishedJohtoTraditionalAGFX2::
INCBIN "gfx/tilesets/polished_johto_traditional_a.vram2.2bpp.lz"

TilesetPolishedJohtoTraditionalAMeta::
INCBIN "data/tilesets/polished_johto_traditional_a_metatiles.bin"

TilesetPolishedJohtoTraditionalAAttr::
INCBIN "data/tilesets/polished_johto_traditional_a_attributes.bin"

TilesetPolishedJohtoTraditionalAColl::
INCLUDE "data/tilesets/polished_johto_traditional_a_collision.asm"


SECTION "Tileset Blockset 30", ROMX

TilesetEmpty30GFX::
	db $ff ; empty LZ stream

TilesetPolishedJohtoTraditionalBGFX0::
INCBIN "gfx/tilesets/polished_johto_traditional_b.vram0.2bpp.lz"

TilesetPolishedJohtoTraditionalBGFX1::
INCBIN "gfx/tilesets/polished_johto_traditional_b.vram1.2bpp.lz"

TilesetPolishedJohtoTraditionalBGFX2::
INCBIN "gfx/tilesets/polished_johto_traditional_b.vram2.2bpp.lz"

TilesetPolishedJohtoTraditionalBMeta::
INCBIN "data/tilesets/polished_johto_traditional_b_metatiles.bin"

TilesetPolishedJohtoTraditionalBAttr::
INCBIN "data/tilesets/polished_johto_traditional_b_attributes.bin"

TilesetPolishedJohtoTraditionalBColl::
INCLUDE "data/tilesets/polished_johto_traditional_b_collision.asm"


SECTION "Tileset Blockset 31", ROMX

TilesetEmpty31GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoAGFX0::
INCBIN "gfx/tilesets/polished_kanto_a.vram0.2bpp.lz"

TilesetPolishedKantoAGFX1::
INCBIN "gfx/tilesets/polished_kanto_a.vram1.2bpp.lz"

TilesetPolishedKantoAMeta::
INCBIN "data/tilesets/polished_kanto_a_metatiles.bin"

TilesetPolishedKantoAAttr::
INCBIN "data/tilesets/polished_kanto_a_attributes.bin"

TilesetPolishedKantoAColl::
INCLUDE "data/tilesets/polished_kanto_a_collision.asm"


SECTION "Tileset Blockset 32", ROMX

TilesetEmpty32GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoGymAGFX0::
INCBIN "gfx/tilesets/polished_kanto_gym_a.vram0.2bpp.lz"

TilesetPolishedKantoGymAGFX1::
INCBIN "gfx/tilesets/polished_kanto_gym_a.vram1.2bpp.lz"

TilesetPolishedKantoGymAMeta::
INCBIN "data/tilesets/polished_kanto_gym_a_metatiles.bin"

TilesetPolishedKantoGymAAttr::
INCBIN "data/tilesets/polished_kanto_gym_a_attributes.bin"

TilesetPolishedKantoGymAColl::
INCLUDE "data/tilesets/polished_kanto_gym_a_collision.asm"


SECTION "Tileset Blockset 33", ROMX

TilesetEmpty33GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoGymBGFX0::
INCBIN "gfx/tilesets/polished_kanto_gym_b.vram0.2bpp.lz"

TilesetPolishedKantoGymBGFX1::
INCBIN "gfx/tilesets/polished_kanto_gym_b.vram1.2bpp.lz"

TilesetPolishedKantoGymBMeta::
INCBIN "data/tilesets/polished_kanto_gym_b_metatiles.bin"

TilesetPolishedKantoGymBAttr::
INCBIN "data/tilesets/polished_kanto_gym_b_attributes.bin"

TilesetPolishedKantoGymBColl::
INCLUDE "data/tilesets/polished_kanto_gym_b_collision.asm"


SECTION "Tileset Blockset 34", ROMX

TilesetEmpty34GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoHouseAGFX0::
INCBIN "gfx/tilesets/polished_kanto_house_a.vram0.2bpp.lz"

TilesetPolishedKantoHouseAGFX1::
INCBIN "gfx/tilesets/polished_kanto_house_a.vram1.2bpp.lz"

TilesetPolishedKantoHouseAGFX2::
INCBIN "gfx/tilesets/polished_kanto_house_a.vram2.2bpp.lz"

TilesetPolishedKantoHouseAMeta::
INCBIN "data/tilesets/polished_kanto_house_a_metatiles.bin"

TilesetPolishedKantoHouseAAttr::
INCBIN "data/tilesets/polished_kanto_house_a_attributes.bin"

TilesetPolishedKantoHouseAColl::
INCLUDE "data/tilesets/polished_kanto_house_a_collision.asm"


SECTION "Tileset Blockset 35", ROMX

TilesetEmpty35GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoHouseBGFX0::
INCBIN "gfx/tilesets/polished_kanto_house_b.vram0.2bpp.lz"

TilesetPolishedKantoHouseBGFX1::
INCBIN "gfx/tilesets/polished_kanto_house_b.vram1.2bpp.lz"

TilesetPolishedKantoHouseBGFX2::
INCBIN "gfx/tilesets/polished_kanto_house_b.vram2.2bpp.lz"

TilesetPolishedKantoHouseBMeta::
INCBIN "data/tilesets/polished_kanto_house_b_metatiles.bin"

TilesetPolishedKantoHouseBAttr::
INCBIN "data/tilesets/polished_kanto_house_b_attributes.bin"

TilesetPolishedKantoHouseBColl::
INCLUDE "data/tilesets/polished_kanto_house_b_collision.asm"


SECTION "Tileset Blockset 36", ROMX

TilesetEmpty36GFX::
	db $ff ; empty LZ stream

TilesetPolishedKantoNorthGFX0::
INCBIN "gfx/tilesets/polished_kanto_north.vram0.2bpp.lz"

TilesetPolishedKantoNorthGFX1::
INCBIN "gfx/tilesets/polished_kanto_north.vram1.2bpp.lz"

TilesetPolishedKantoNorthMeta::
INCBIN "data/tilesets/polished_kanto_north_metatiles.bin"

TilesetPolishedKantoNorthAttr::
INCBIN "data/tilesets/polished_kanto_north_attributes.bin"

TilesetPolishedKantoNorthColl::
INCLUDE "data/tilesets/polished_kanto_north_collision.asm"

TilesetPolishedLabAGFX0::
INCBIN "gfx/tilesets/polished_lab_a.vram0.2bpp.lz"

TilesetPolishedLabAGFX1::
INCBIN "gfx/tilesets/polished_lab_a.vram1.2bpp.lz"

TilesetPolishedLabAMeta::
INCBIN "data/tilesets/polished_lab_a_metatiles.bin"

TilesetPolishedLabAAttr::
INCBIN "data/tilesets/polished_lab_a_attributes.bin"

TilesetPolishedLabAColl::
INCLUDE "data/tilesets/polished_lab_a_collision.asm"


SECTION "Tileset Blockset 37", ROMX

TilesetEmpty37GFX::
	db $ff ; empty LZ stream

TilesetPolishedLighthouseGFX0::
INCBIN "gfx/tilesets/polished_lighthouse.vram0.2bpp.lz"

TilesetPolishedLighthouseGFX1::
INCBIN "gfx/tilesets/polished_lighthouse.vram1.2bpp.lz"

TilesetPolishedLighthouseMeta::
INCBIN "data/tilesets/polished_lighthouse_metatiles.bin"

TilesetPolishedLighthouseAttr::
INCBIN "data/tilesets/polished_lighthouse_attributes.bin"

TilesetPolishedLighthouseColl::
INCLUDE "data/tilesets/polished_lighthouse_collision.asm"

TilesetPolishedMagnetTrainGFX0::
INCBIN "gfx/tilesets/polished_magnet_train.vram0.2bpp.lz"

TilesetPolishedMagnetTrainMeta::
INCBIN "data/tilesets/polished_magnet_train_metatiles.bin"

TilesetPolishedMagnetTrainAttr::
INCBIN "data/tilesets/polished_magnet_train_attributes.bin"

TilesetPolishedMagnetTrainColl::
INCLUDE "data/tilesets/polished_magnet_train_collision.asm"

TilesetPolishedCeladonMansionGFX0::
INCBIN "gfx/tilesets/polished_celadon_mansion.vram0.2bpp.lz"

TilesetPolishedCeladonMansionGFX1::
INCBIN "gfx/tilesets/polished_celadon_mansion.vram1.2bpp.lz"

TilesetPolishedCeladonMansionMeta::
INCBIN "data/tilesets/polished_celadon_mansion_metatiles.bin"

TilesetPolishedCeladonMansionAttr::
INCBIN "data/tilesets/polished_celadon_mansion_attributes.bin"

TilesetPolishedCeladonMansionColl::
INCLUDE "data/tilesets/polished_celadon_mansion_collision.asm"


SECTION "Tileset Blockset 38", ROMX

TilesetEmpty38GFX::
	db $ff ; empty LZ stream

TilesetPolishedMartGFX0::
INCBIN "gfx/tilesets/polished_mart.vram0.2bpp.lz"

TilesetPolishedMartGFX1::
INCBIN "gfx/tilesets/polished_mart.vram1.2bpp.lz"

TilesetPolishedMartMeta::
INCBIN "data/tilesets/polished_mart_metatiles.bin"

TilesetPolishedMartAttr::
INCBIN "data/tilesets/polished_mart_attributes.bin"

TilesetPolishedMartColl::
INCLUDE "data/tilesets/polished_mart_collision.asm"

TilesetPolishedMuseumAGFX0::
INCBIN "gfx/tilesets/polished_museum_a.vram0.2bpp.lz"

TilesetPolishedMuseumAGFX1::
INCBIN "gfx/tilesets/polished_museum_a.vram1.2bpp.lz"

TilesetPolishedMuseumAMeta::
INCBIN "data/tilesets/polished_museum_a_metatiles.bin"

TilesetPolishedMuseumAAttr::
INCBIN "data/tilesets/polished_museum_a_attributes.bin"

TilesetPolishedMuseumAColl::
INCLUDE "data/tilesets/polished_museum_a_collision.asm"


SECTION "Tileset Blockset 39", ROMX

TilesetEmpty39GFX::
	db $ff ; empty LZ stream

TilesetPolishedMuseumBGFX0::
INCBIN "gfx/tilesets/polished_museum_b.vram0.2bpp.lz"

TilesetPolishedMuseumBGFX1::
INCBIN "gfx/tilesets/polished_museum_b.vram1.2bpp.lz"

TilesetPolishedMuseumBMeta::
INCBIN "data/tilesets/polished_museum_b_metatiles.bin"

TilesetPolishedMuseumBAttr::
INCBIN "data/tilesets/polished_museum_b_attributes.bin"

TilesetPolishedMuseumBColl::
INCLUDE "data/tilesets/polished_museum_b_collision.asm"

TilesetPolishedParkGFX0::
INCBIN "gfx/tilesets/polished_park.vram0.2bpp.lz"

TilesetPolishedParkMeta::
INCBIN "data/tilesets/polished_park_metatiles.bin"

TilesetPolishedParkAttr::
INCBIN "data/tilesets/polished_park_attributes.bin"

TilesetPolishedParkColl::
INCLUDE "data/tilesets/polished_park_collision.asm"


SECTION "Tileset Blockset 40", ROMX

TilesetEmpty40GFX::
	db $ff ; empty LZ stream

TilesetPolishedPeaksGFX0::
INCBIN "gfx/tilesets/polished_peaks.vram0.2bpp.lz"

TilesetPolishedPeaksGFX1::
INCBIN "gfx/tilesets/polished_peaks.vram1.2bpp.lz"

TilesetPolishedPeaksMeta::
INCBIN "data/tilesets/polished_peaks_metatiles.bin"

TilesetPolishedPeaksAttr::
INCBIN "data/tilesets/polished_peaks_attributes.bin"

TilesetPolishedPeaksColl::
INCLUDE "data/tilesets/polished_peaks_collision.asm"

TilesetPolishedPokecenterGFX0::
INCBIN "gfx/tilesets/polished_pokecenter.vram0.2bpp.lz"

TilesetPolishedPokecenterGFX1::
INCBIN "gfx/tilesets/polished_pokecenter.vram1.2bpp.lz"

TilesetPolishedPokecenterMeta::
INCBIN "data/tilesets/polished_pokecenter_metatiles.bin"

TilesetPolishedPokecenterAttr::
INCBIN "data/tilesets/polished_pokecenter_attributes.bin"

TilesetPolishedPokecenterColl::
INCLUDE "data/tilesets/polished_pokecenter_collision.asm"


SECTION "Tileset Blockset 41", ROMX

TilesetEmpty41GFX::
	db $ff ; empty LZ stream

TilesetPolishedPokecomCenterAGFX0::
INCBIN "gfx/tilesets/polished_pokecom_center_a.vram0.2bpp.lz"

TilesetPolishedPokecomCenterAGFX1::
INCBIN "gfx/tilesets/polished_pokecom_center_a.vram1.2bpp.lz"

TilesetPolishedPokecomCenterAMeta::
INCBIN "data/tilesets/polished_pokecom_center_a_metatiles.bin"

TilesetPolishedPokecomCenterAAttr::
INCBIN "data/tilesets/polished_pokecom_center_a_attributes.bin"

TilesetPolishedPokecomCenterAColl::
INCLUDE "data/tilesets/polished_pokecom_center_a_collision.asm"

TilesetPolishedPokemonMansionGFX0::
INCBIN "gfx/tilesets/polished_pokemon_mansion.vram0.2bpp.lz"

TilesetPolishedPokemonMansionGFX1::
INCBIN "gfx/tilesets/polished_pokemon_mansion.vram1.2bpp.lz"

TilesetPolishedPokemonMansionMeta::
INCBIN "data/tilesets/polished_pokemon_mansion_metatiles.bin"

TilesetPolishedPokemonMansionAttr::
INCBIN "data/tilesets/polished_pokemon_mansion_attributes.bin"

TilesetPolishedPokemonMansionColl::
INCLUDE "data/tilesets/polished_pokemon_mansion_collision.asm"


SECTION "Tileset Blockset 42", ROMX

TilesetEmpty42GFX::
	db $ff ; empty LZ stream

TilesetPolishedPortGFX0::
INCBIN "gfx/tilesets/polished_port.vram0.2bpp.lz"

TilesetPolishedPortGFX1::
INCBIN "gfx/tilesets/polished_port.vram1.2bpp.lz"

TilesetPolishedPortMeta::
INCBIN "data/tilesets/polished_port_metatiles.bin"

TilesetPolishedPortAttr::
INCBIN "data/tilesets/polished_port_attributes.bin"

TilesetPolishedPortColl::
INCLUDE "data/tilesets/polished_port_collision.asm"

TilesetPolishedQuietCaveGFX0::
INCBIN "gfx/tilesets/polished_quiet_cave.vram0.2bpp.lz"

TilesetPolishedQuietCaveMeta::
INCBIN "data/tilesets/polished_quiet_cave_metatiles.bin"

TilesetPolishedQuietCaveAttr::
INCBIN "data/tilesets/polished_quiet_cave_attributes.bin"

TilesetPolishedQuietCaveColl::
INCLUDE "data/tilesets/polished_quiet_cave_collision.asm"

TilesetPolishedRadioTowerGFX0::
INCBIN "gfx/tilesets/polished_radio_tower.vram0.2bpp.lz"

TilesetPolishedRadioTowerGFX1::
INCBIN "gfx/tilesets/polished_radio_tower.vram1.2bpp.lz"

TilesetPolishedRadioTowerMeta::
INCBIN "data/tilesets/polished_radio_tower_metatiles.bin"

TilesetPolishedRadioTowerAttr::
INCBIN "data/tilesets/polished_radio_tower_attributes.bin"

TilesetPolishedRadioTowerColl::
INCLUDE "data/tilesets/polished_radio_tower_collision.asm"


SECTION "Tileset Blockset 43", ROMX

TilesetEmpty43GFX::
	db $ff ; empty LZ stream

TilesetPolishedRuinsOfAlphGFX0::
INCBIN "gfx/tilesets/polished_ruins_of_alph.vram0.2bpp.lz"

TilesetPolishedRuinsOfAlphGFX1::
INCBIN "gfx/tilesets/polished_ruins_of_alph.vram1.2bpp.lz"

TilesetPolishedRuinsOfAlphMeta::
INCBIN "data/tilesets/polished_ruins_of_alph_metatiles.bin"

TilesetPolishedRuinsOfAlphAttr::
INCBIN "data/tilesets/polished_ruins_of_alph_attributes.bin"

TilesetPolishedRuinsOfAlphColl::
INCLUDE "data/tilesets/polished_ruins_of_alph_collision.asm"

TilesetPolishedSafariZoneGFX0::
INCBIN "gfx/tilesets/polished_safari_zone.vram0.2bpp.lz"

TilesetPolishedSafariZoneMeta::
INCBIN "data/tilesets/polished_safari_zone_metatiles.bin"

TilesetPolishedSafariZoneAttr::
INCBIN "data/tilesets/polished_safari_zone_attributes.bin"

TilesetPolishedSafariZoneColl::
INCLUDE "data/tilesets/polished_safari_zone_collision.asm"


SECTION "Tileset Blockset 44", ROMX

TilesetEmpty44GFX::
	db $ff ; empty LZ stream

TilesetPolishedShamoutiIslandAGFX0::
INCBIN "gfx/tilesets/polished_shamouti_island_a.vram0.2bpp.lz"

TilesetPolishedShamoutiIslandAGFX1::
INCBIN "gfx/tilesets/polished_shamouti_island_a.vram1.2bpp.lz"

TilesetPolishedShamoutiIslandAMeta::
INCBIN "data/tilesets/polished_shamouti_island_a_metatiles.bin"

TilesetPolishedShamoutiIslandAAttr::
INCBIN "data/tilesets/polished_shamouti_island_a_attributes.bin"

TilesetPolishedShamoutiIslandAColl::
INCLUDE "data/tilesets/polished_shamouti_island_a_collision.asm"


SECTION "Tileset Blockset 45", ROMX

TilesetEmpty45GFX::
	db $ff ; empty LZ stream

TilesetPolishedShamoutiIslandBGFX0::
INCBIN "gfx/tilesets/polished_shamouti_island_b.vram0.2bpp.lz"

TilesetPolishedShamoutiIslandBGFX1::
INCBIN "gfx/tilesets/polished_shamouti_island_b.vram1.2bpp.lz"

TilesetPolishedShamoutiIslandBMeta::
INCBIN "data/tilesets/polished_shamouti_island_b_metatiles.bin"

TilesetPolishedShamoutiIslandBAttr::
INCBIN "data/tilesets/polished_shamouti_island_b_attributes.bin"

TilesetPolishedShamoutiIslandBColl::
INCLUDE "data/tilesets/polished_shamouti_island_b_collision.asm"


SECTION "Tileset Blockset 46", ROMX

TilesetEmpty46GFX::
	db $ff ; empty LZ stream

TilesetPolishedSnowtopMountainAGFX0::
INCBIN "gfx/tilesets/polished_snowtop_mountain_a.vram0.2bpp.lz"

TilesetPolishedSnowtopMountainAGFX1::
INCBIN "gfx/tilesets/polished_snowtop_mountain_a.vram1.2bpp.lz"

TilesetPolishedSnowtopMountainAMeta::
INCBIN "data/tilesets/polished_snowtop_mountain_a_metatiles.bin"

TilesetPolishedSnowtopMountainAAttr::
INCBIN "data/tilesets/polished_snowtop_mountain_a_attributes.bin"

TilesetPolishedSnowtopMountainAColl::
INCLUDE "data/tilesets/polished_snowtop_mountain_a_collision.asm"


SECTION "Tileset Blockset 47", ROMX

TilesetEmpty47GFX::
	db $ff ; empty LZ stream

TilesetPolishedSproutTowerAGFX0::
INCBIN "gfx/tilesets/polished_sprout_tower_a.vram0.2bpp.lz"

TilesetPolishedSproutTowerAGFX1::
INCBIN "gfx/tilesets/polished_sprout_tower_a.vram1.2bpp.lz"

TilesetPolishedSproutTowerAMeta::
INCBIN "data/tilesets/polished_sprout_tower_a_metatiles.bin"

TilesetPolishedSproutTowerAAttr::
INCBIN "data/tilesets/polished_sprout_tower_a_attributes.bin"

TilesetPolishedSproutTowerAColl::
INCLUDE "data/tilesets/polished_sprout_tower_a_collision.asm"


SECTION "Tileset Blockset 48", ROMX

TilesetEmpty48GFX::
	db $ff ; empty LZ stream

TilesetPolishedSproutTowerBGFX0::
INCBIN "gfx/tilesets/polished_sprout_tower_b.vram0.2bpp.lz"

TilesetPolishedSproutTowerBGFX1::
INCBIN "gfx/tilesets/polished_sprout_tower_b.vram1.2bpp.lz"

TilesetPolishedSproutTowerBMeta::
INCBIN "data/tilesets/polished_sprout_tower_b_metatiles.bin"

TilesetPolishedSproutTowerBAttr::
INCBIN "data/tilesets/polished_sprout_tower_b_attributes.bin"

TilesetPolishedSproutTowerBColl::
INCLUDE "data/tilesets/polished_sprout_tower_b_collision.asm"

TilesetPolishedTraditionalHouseGFX0::
INCBIN "gfx/tilesets/polished_traditional_house.vram0.2bpp.lz"

TilesetPolishedTraditionalHouseGFX1::
INCBIN "gfx/tilesets/polished_traditional_house.vram1.2bpp.lz"

TilesetPolishedTraditionalHouseMeta::
INCBIN "data/tilesets/polished_traditional_house_metatiles.bin"

TilesetPolishedTraditionalHouseAttr::
INCBIN "data/tilesets/polished_traditional_house_attributes.bin"

TilesetPolishedTraditionalHouseColl::
INCLUDE "data/tilesets/polished_traditional_house_collision.asm"


SECTION "Tileset Blockset 49", ROMX

TilesetEmpty49GFX::
	db $ff ; empty LZ stream

TilesetPolishedTunnelGFX0::
INCBIN "gfx/tilesets/polished_tunnel.vram0.2bpp.lz"

TilesetPolishedTunnelGFX1::
INCBIN "gfx/tilesets/polished_tunnel.vram1.2bpp.lz"

TilesetPolishedTunnelMeta::
INCBIN "data/tilesets/polished_tunnel_metatiles.bin"

TilesetPolishedTunnelAttr::
INCBIN "data/tilesets/polished_tunnel_attributes.bin"

TilesetPolishedTunnelColl::
INCLUDE "data/tilesets/polished_tunnel_collision.asm"

TilesetPolishedUndergroundGFX0::
INCBIN "gfx/tilesets/polished_underground.vram0.2bpp.lz"

TilesetPolishedUndergroundMeta::
INCBIN "data/tilesets/polished_underground_metatiles.bin"

TilesetPolishedUndergroundAttr::
INCBIN "data/tilesets/polished_underground_attributes.bin"

TilesetPolishedUndergroundColl::
INCLUDE "data/tilesets/polished_underground_collision.asm"

TilesetPolishedValenciaIslandGFX0::
INCBIN "gfx/tilesets/polished_valencia_island.vram0.2bpp.lz"

TilesetPolishedValenciaIslandMeta::
INCBIN "data/tilesets/polished_valencia_island_metatiles.bin"

TilesetPolishedValenciaIslandAttr::
INCBIN "data/tilesets/polished_valencia_island_attributes.bin"

TilesetPolishedValenciaIslandColl::
INCLUDE "data/tilesets/polished_valencia_island_collision.asm"
