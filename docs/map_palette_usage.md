# Map overworld OBJ palette availability

Generated from `maps/*.asm`, `constants/sprite_constants.asm`, and 
`data/sprites/sprites.asm` by `tools/report_map_palettes.py`.

The eight hardware OBJ palette slots are **red, blue, green, brown, purple, silver, tree, and rock**. In this project, the old pink slot is the purple slot. The Dance Theatre locally turns its rock slot into pink; it is marked `pink* (rock slot)` below.

- **Used by objects** includes explicit object palettes and sprite defaults.
- **Object-unused** is a literal static-map result. It does not guarantee that an engine effect will never use the slot.
- **Best candidates** removes red, blue, and purple (possible player palettes) and silver (shadows, emotes, weather, and other temporary effects).
- Before reusing **tree**, check for grass/tree effects. Before reusing **rock**, check for rocks, Strength boulders, and boulder dust.
- A map-specific replacement changes the slot's color for every object or effect using that slot on that map.

Maps listed: **396**.

| Map | Objects | Used by objects | Object-unused | Best candidates |
|---|---:|---|---|---|
| AzaleaGym | 7 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| AzaleaMart | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| AzaleaPokecenter1F | 4 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| AzaleaTown | 12 | red, blue, green, brown, purple, tree | silver, rock | rock |
| BattleTower1F | 5 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| BattleTowerBattleRoom | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BattleTowerElevator | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BattleTowerHallway | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BattleTowerOutside | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| BillsBrothersHouse | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BillsFamilysHouse | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| BillsHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BlackthornCity | 9 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| BlackthornDragonSpeechHouse | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| BlackthornEmysHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| BlackthornGym1F | 5 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BlackthornGym2F | 8 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| BlackthornMart | 3 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| BlackthornPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| BluesHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| BrunosRoom | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| BurnedTower1F | 6 | red, blue, brown, purple, rock | green, silver, tree | green, tree |
| BurnedTowerB1F | 9 | red, blue, brown, silver, rock | green, purple, tree | green, tree |
| CeladonCafe | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| CeladonCity | 9 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| CeladonDeptStore1F | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonDeptStore2F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonDeptStore3F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonDeptStore4F | 3 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonDeptStore5F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonDeptStore6F | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeladonDeptStoreElevator | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeladonGameCorner | 9 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonGameCornerPrizeRoom | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonGym | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonMansion1F | 4 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| CeladonMansion2F | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeladonMansion3F | 4 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeladonMansionRoof | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeladonMansionRoofHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonPokecenter1F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeladonPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeruleanCity | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeruleanGym | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| CeruleanGymBadgeSpeechHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| CeruleanMart | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| CeruleanPokecenter1F | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CeruleanPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CeruleanPoliceStation | 3 | blue, green, brown | red, purple, silver, tree, rock | tree, rock |
| CeruleanTradeSpeechHouse | 4 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| CharcoalKiln | 3 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| CherrygroveCity | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| CherrygroveEvolutionSpeechHouse | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| CherrygroveGymSpeechHouse | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| CherrygroveMart | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CherrygrovePokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CianwoodCity | 12 | red, blue, green, brown, rock | purple, silver, tree | tree |
| CianwoodGym | 9 | brown, rock | red, blue, green, purple, silver, tree | green, tree |
| CianwoodLugiaSpeechHouse | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CianwoodPharmacy | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CianwoodPhotoStudio | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CianwoodPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| CinnabarIsland | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CinnabarPokecenter1F | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| CinnabarPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Colosseum | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| CopycatsHouse1F | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| CopycatsHouse2F | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| DanceTheatre | 12 | red, blue, green, brown, purple, pink* (rock slot) | silver, tree | tree |
| DarkCaveBlackthornEntrance | 3 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| DarkCaveVioletEntrance | 8 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| DayCare | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| DayOfWeekSiblingsHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| DiglettsCave | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| DragonsDen1F | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| DragonsDenB1F | 9 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| DragonShrine | 4 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| EarlsPokemonAcademy | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| EcruteakCity | 7 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| EcruteakGym | 7 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| EcruteakItemfinderHouse | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| EcruteakLugiaSpeechHouse | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| EcruteakMart | 3 | green, brown | red, blue, purple, silver, tree, rock | tree, rock |
| EcruteakPokecenter1F | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| EcruteakTinTowerEntrance | 4 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| ElmsHouse | 2 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| ElmsLab | 9 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| FastShip1F | 4 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| FastShipB1F | 12 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| FastShipCabins_NNW_NNE_NE | 7 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| FastShipCabins_SE_SSE_CaptainsCabin | 11 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| FastShipCabins_SW_SSW_NW | 4 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| FightingDojo | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| FuchsiaCity | 4 | red, green, brown, tree | blue, purple, silver, rock | rock |
| FuchsiaGym | 6 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| FuchsiaMart | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| FuchsiaPokecenter1F | 4 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| FuchsiaPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodBikeShop | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodCity | 15 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodDeptStore1F | 4 | blue, green, brown | red, purple, silver, tree, rock | tree, rock |
| GoldenrodDeptStore2F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodDeptStore3F | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodDeptStore4F | 4 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodDeptStore5F | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodDeptStore6F | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodDeptStoreB1F | 9 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodDeptStoreElevator | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodDeptStoreRoof | 10 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodFlowerShop | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodGameCorner | 12 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodGym | 6 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodHappinessRater | 3 | blue, green, brown | red, purple, silver, tree, rock | tree, rock |
| GoldenrodMagnetTrainStation | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodNameRater | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| GoldenrodPokecenter1F | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodPPSpeechHouse | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| GoldenrodUnderground | 13 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodUndergroundSwitchRoomEntrances | 11 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| GoldenrodUndergroundWarehouse | 7 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| GravekeepersHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| GuideGentsHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| HallOfFame | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| IceIsland | 4 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| IcePath1F | 4 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| IcePathB1F | 5 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| IcePathB2FBlackthornSide | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| IcePathB2FMahoganySide | 6 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| IcePathB3F | 2 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| IlexForest | 15 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| IlexForestAzaleaGate | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| IndigoPlateauPokecenter1F | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| KarensRoom | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| KogasRoom | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| KurtsHouse | 5 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| LakeOfRage | 13 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| LakeOfRageHiddenPowerHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| LakeOfRageMagikarpHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| LancesRoom | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| LavenderMart | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| LavenderNameRater | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| LavenderPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| LavenderPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| LavenderSpeechHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| LavenderTown | 4 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| LavRadioTower1F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| MahoganyGym | 7 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| MahoganyMart1F | 5 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| MahoganyPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| MahoganyRedGyaradosSpeechHouse | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| MahoganyTown | 6 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| ManiasHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| MobileBattleRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| MobileTradeRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| MountMoon | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| MountMoonGiftShop | 4 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| MountMoonSquare | 3 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| MountMortar1FInside | 10 | red, blue, brown, rock | green, purple, silver, tree | green, tree |
| MountMortar1FOutside | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| MountMortar2FInside | 7 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| MountMortarB1F | 7 | red, brown, rock | blue, green, purple, silver, tree | green, tree |
| MoveDeletersHouse | 3 | blue, brown, purple | red, green, silver, tree, rock | green, tree, rock |
| MrFujisHouse | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| MrPokemonsHouse | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| MrPsychicsHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| NationalPark | 14 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| NationalParkBugContest | 12 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| NewBarkTown | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| OaksLab | 4 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| OlivineCafe | 3 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineCity | 4 | red, blue, green, brown, purple | silver, tree, rock | tree, rock |
| OlivineGoodRodHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| OlivineGym | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineHouseBeta | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineLighthouse1F | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| OlivineLighthouse2F | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineLighthouse3F | 4 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineLighthouse4F | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineLighthouse5F | 5 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivineLighthouse6F | 4 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| OlivineMart | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| OlivinePokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| OlivinePort | 7 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| OlivinePortPassage | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| OlivinePunishmentSpeechHouse | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| OlivineTimsHouse | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| PalletTown | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| PewterCity | 5 | red, blue, green, tree | brown, purple, silver, rock | brown, rock |
| PewterGym | 3 | blue, green, brown | red, purple, silver, tree, rock | tree, rock |
| PewterMart | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| PewterNidoranSpeechHouse | 2 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| PewterPokecenter1F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| PewterPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| PewterSnoozeSpeechHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| PlayersHouse1F | 5 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| PlayersHouse2F | 4 | red, blue, green, brown, purple | silver, tree, rock | tree, rock |
| PlayersNeighborsHouse | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Pokecenter2F | 4 | blue, green | red, brown, purple, silver, tree, rock | brown, tree, rock |
| PokecomCenterAdminOfficeMobile | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| PokemonFanClub | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| PokeSeersHouse | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| PowerPlant | 7 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| RadioTower1F | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| RadioTower2F | 11 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| RadioTower3F | 7 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| RadioTower4F | 7 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| RadioTower5F | 5 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RedsHouse1F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RedsHouse2F | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RockTunnel1F | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RockTunnelB1F | 3 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route1 | 3 | red, blue, tree | green, brown, purple, silver, rock | green, brown, rock |
| Route10North | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route10Pokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route10Pokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route10South | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| Route11 | 5 | blue, tree | red, green, brown, purple, silver, rock | green, brown, rock |
| Route12 | 6 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route12SuperRodHouse | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route13 | 5 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| Route14 | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route15 | 7 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route15FuchsiaGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route16 | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route16FuchsiaSpeechHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route16Gate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route17 | 4 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| Route17Route18Gate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route18 | 5 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route19 | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route19FuchsiaGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route2 | 5 | red, tree | blue, green, brown, purple, silver, rock | green, brown, rock |
| Route20 | 4 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route21 | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route22 | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route23 | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| Route24 | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| Route25 | 12 | red, blue, green, brown, purple | silver, tree, rock | tree, rock |
| Route26 | 8 | red, blue, green, tree | brown, purple, silver, rock | brown, rock |
| Route26HealHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route27 | 9 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route27SandstormHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| Route28 | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route28SteelWingHouse | 2 | green, brown | red, blue, purple, silver, tree, rock | tree, rock |
| Route29 | 8 | red, blue, green, tree | brown, purple, silver, rock | brown, rock |
| Route29Route46Gate | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route2Gate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route2NuggetHouse | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route3 | 6 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route30 | 11 | red, blue, brown, purple, tree | green, silver, rock | green, rock |
| Route30BerryHouse | 1 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |
| Route31 | 7 | red, blue, brown, tree | green, purple, silver, rock | green, rock |
| Route31VioletGate | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route32 | 14 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route32Pokecenter1F | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route32RuinsOfAlphGate | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| Route33 | 3 | blue, brown, tree | red, green, purple, silver, rock | green, rock |
| Route34 | 13 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| Route34IlexForestGate | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route35 | 11 | red, blue, green, brown, tree | purple, silver, rock | rock |
| Route35GoldenrodGate | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route35NationalParkGate | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route36 | 9 | red, blue, green, brown, purple, tree | silver, rock | rock |
| Route36NationalParkGate | 12 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| Route36RuinsOfAlphGate | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| Route37 | 7 | red, blue, tree | green, brown, purple, silver, rock | green, brown, rock |
| Route38 | 7 | blue, tree | red, green, brown, purple, silver, rock | green, brown, rock |
| Route38EcruteakGate | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route39 | 10 | red, blue, tree | green, brown, purple, silver, rock | green, brown, rock |
| Route39Barn | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route39Farmhouse | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| Route4 | 6 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route40 | 12 | red, blue, green, brown, rock | purple, silver, tree | tree |
| Route40BattleTowerGate | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route41 | 11 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| Route42 | 10 | red, blue, green, brown, tree | purple, silver, rock | rock |
| Route42EcruteakGate | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route43 | 8 | red, blue, green, tree | brown, purple, silver, rock | brown, rock |
| Route43Gate | 3 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| Route43MahoganyGate | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route44 | 13 | red, blue, green, tree | brown, purple, silver, rock | brown, rock |
| Route45 | 13 | red, green, brown, tree | blue, purple, silver, rock | rock |
| Route46 | 6 | red, green, brown, tree | blue, purple, silver, rock | rock |
| Route5 | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route5CleanseTagHouse | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| Route5SaffronGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route5UndergroundPathEntrance | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| Route6 | 3 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| Route6SaffronGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route6UndergroundPathEntrance | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route7 | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route7SaffronGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route8 | 6 | red, blue, green, brown, tree | purple, silver, rock | rock |
| Route8SaffronGate | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| Route9 | 8 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| RuinsOfAlphAerodactylChamber | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphAerodactylItemRoom | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphAerodactylWordRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphHoOhChamber | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphHoOhItemRoom | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphHoOhWordRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphInnerChamber | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| RuinsOfAlphKabutoChamber | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphKabutoItemRoom | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphKabutoWordRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphOmanyteChamber | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphOmanyteItemRoom | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphOmanyteWordRoom | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| RuinsOfAlphOutside | 5 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| RuinsOfAlphResearchCenter | 3 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SafariZone | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SafariZoneBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SafariZoneFuchsiaGateBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SafariZoneLobby | 8 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| SafariZoneMainOffice | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SafariZoneWardensHome | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| SaffronCity | 8 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| SaffronGym | 6 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| SaffronMagnetTrainStation | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| SaffronMart | 3 | green, brown | red, blue, purple, silver, tree, rock | tree, rock |
| SaffronPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| SaffronPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SeafoamGym | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| SilentCrypt | 4 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| SilphCo1F | 2 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SilverCaveItemRooms | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SilverCaveOutside | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| SilverCavePokecenter1F | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| SilverCaveRoom1 | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SilverCaveRoom2 | 4 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SilverCaveRoom3 | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SlowpokeWellB1F | 9 | red, green, brown, rock | blue, purple, silver, tree | tree |
| SlowpokeWellB2F | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SoulHouse | 4 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SproutTower1F | 6 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| SproutTower2F | 3 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| SproutTower3F | 7 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TeamRocketBaseB1F | 6 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| TeamRocketBaseB2F | 14 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| TeamRocketBaseB3F | 14 | red, blue, brown, purple | green, silver, tree, rock | green, tree, rock |
| TimeCapsule | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower1F | 10 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| TinTower2F | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower3F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower4F | 3 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower5F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower6F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower7F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower8F | 3 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTower9F | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TinTowerRoof | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TohjoFalls | 2 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TradeCenter | 2 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| TrainerHouse1F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| TrainerHouseB1F | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| UndergroundPath | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| UnionCave1F | 9 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| UnionCaveB1F | 7 | red, blue, brown, rock | green, purple, silver, tree | green, tree |
| UnionCaveB2F | 6 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VermilionCity | 6 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| VermilionDiglettsCaveSpeechHouse | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VermilionFishingSpeechHouse | 1 | green | red, blue, brown, purple, silver, tree, rock | brown, tree, rock |
| VermilionGym | 5 | red, blue, brown | green, purple, silver, tree, rock | green, tree, rock |
| VermilionMagnetTrainSpeechHouse | 2 | green, brown | red, blue, purple, silver, tree, rock | tree, rock |
| VermilionMart | 3 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| VermilionPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| VermilionPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VermilionPort | 3 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VermilionPortPassage | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VictoryRoad | 6 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VictoryRoadGate | 3 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| VioletCity | 9 | red, blue, green, brown, tree | purple, silver, rock | rock |
| VioletGym | 4 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| VioletKylesHouse | 2 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| VioletMart | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| VioletNicknameSpeechHouse | 3 | red, green, brown | blue, purple, silver, tree, rock | tree, rock |
| VioletPokecenter1F | 5 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| ViridianCity | 4 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| ViridianForest | 8 | red, brown | blue, green, purple, silver, tree, rock | green, tree, rock |
| ViridianForestNorthGate | 2 | blue, brown | red, green, purple, silver, tree, rock | green, tree, rock |
| ViridianForestSouthGate | 2 | red, green | blue, brown, purple, silver, tree, rock | brown, tree, rock |
| ViridianGym | 5 | red, blue | green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| ViridianMart | 3 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| ViridianNicknameSpeechHouse | 4 | red, blue, green, brown | purple, silver, tree, rock | tree, rock |
| ViridianPokecenter1F | 4 | red, blue, green | brown, purple, silver, tree, rock | brown, tree, rock |
| ViridianPokecenter2FBeta | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandB1F | 6 | red, rock | blue, green, brown, purple, silver, tree | green, brown, tree |
| WhirlIslandB2F | 3 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandCave | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandLugiaChamber | 1 | blue | red, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandNE | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandNW | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandSE | 0 | (none) | red, blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WhirlIslandSW | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WillsRoom | 1 | red | blue, green, brown, purple, silver, tree, rock | green, brown, tree, rock |
| WiseTriosRoom | 6 | brown | red, blue, green, purple, silver, tree, rock | green, tree, rock |

## Conservative dynamic-sprite entries

For these maps, one or more zero-override sprite identifiers could not be resolved as a fixed normal NPC sprite. The report conservatively marks red, blue, green, brown, and purple as used for those entries.

- `AzaleaTown`: `SPRITE_AZALEA_ROCKET`
- `OlivineCity`: `SPRITE_OLIVINE_RIVAL`
- `PlayersHouse2F`: `SPRITE_BIG_DOLL`, `SPRITE_CONSOLE`, `SPRITE_DOLL_1`, `SPRITE_DOLL_2`
- `Route36`: `SPRITE_WEIRD_TREE`
