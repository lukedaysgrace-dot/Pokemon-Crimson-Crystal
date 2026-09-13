# Trainer classes by map area

Current working-tree audit of every compiled map in `data/maps/scripts.asm`.

## Scope and counting rules

- Counts are distinct fixed trainer encounters, not party variants. Phone rematches and leader/Elite Four rematches do not add another trainer.
- Standard `trainer` declarations and one-time scripted `loadtrainer` encounters are included. The Team Rocket Base B1F security system counts as 10 Rocket Grunt M encounters because five cameras can each summon two grunts.
- Male and female class IDs are separate classes (for example, Cooltrainer M and Cooltrainer F). Each Twins object/party is one trainer entry, so a pair contributes 2 Twins.
- Special character-only classes are excluded: Gym Leaders, Elite Four, Champion, rivals, Crystal/player counterparts, Red/Blue/Green, Eusine/Mysticalman, named Rocket executives, Cal, and their alternate/rematch classes.
- Battle Tower opponents are generated from a roster rather than placed as fixed map trainers, so they are outside these map-placement counts.

**Coverage:** 399 compiled map areas; 97 areas with eligible trainers; 302 areas with none after exclusions; 394 eligible trainer encounters across 44 classes.

## Areas with eligible trainers

| Map area | Class counts | Total |
|---|---|---:|
| `AzaleaGym` | Bug Catcher: 3; Twins: 2 | 5 |
| `BlackthornGym1F` | Cooltrainer F: 1; Cooltrainer M: 2 | 3 |
| `BlackthornGym2F` | Cooltrainer F: 1; Cooltrainer M: 1 | 2 |
| `BurnedTower1F` | Hex Maniac: 1 | 1 |
| `CeladonGym` | Beauty: 1; Lass: 1; School Girl: 1; Twins: 2 | 5 |
| `CeruleanGym` | Swimmer F: 2; Swimmer M: 1 | 3 |
| `CianwoodGym` | Blackbelt: 4 | 4 |
| `DanceTheatre` | Kimono Girl: 8 | 8 |
| `DragonsDenB1F` | Cooltrainer F: 1; Cooltrainer M: 1; Twins: 2 | 4 |
| `EcruteakGym` | Medium: 2; Sage: 2 | 4 |
| `FastShipB1F` | Blackbelt: 1; Fisher: 1; Juggler: 1; Sailor: 3; School Girl: 1; Schoolboy: 2; Teacher: 1 | 10 |
| `FastShipCabins_NNW_NNE_NE` | Burglar: 1; Cooltrainer F: 1; Cooltrainer M: 1; Gentleman: 1; Hiker: 1; Pokemaniac: 1; Sailor: 1 | 7 |
| `FastShipCabins_SE_SSE_CaptainsCabin` | Pokefan F: 1; Pokefan M: 2; Psychic: 1; Super Nerd: 1; Twins: 2 | 7 |
| `FastShipCabins_SW_SSW_NW` | Beauty: 1; Bug Catcher: 1; Firebreather: 1; Guitarist: 1 | 4 |
| `FuchsiaGym` | Ninja: 4 | 4 |
| `GoldenrodGym` | Beauty: 2; Lass: 2 | 4 |
| `GoldenrodUnderground` | Pokemaniac: 2; Rocket Grunt F: 1; Rocket Grunt M: 2; Super Nerd: 2 | 7 |
| `GoldenrodUndergroundSwitchRoomEntrances` | Burglar: 2; Rocket Grunt F: 2; Rocket Grunt M: 2 | 6 |
| `GoldenrodUndergroundWarehouse` | Rocket Grunt F: 1; Rocket Grunt M: 2 | 3 |
| `IlexForest` | Bug Catcher: 1 | 1 |
| `LakeOfRage` | Cooltrainer F: 1; Cooltrainer M: 1; Fisher: 2 | 4 |
| `MahoganyGym` | Boarder: 3; Skier: 2 | 5 |
| `MountMortar1FInside` | Pokemaniac: 1; Super Nerd: 1 | 2 |
| `MountMortar2FInside` | Super Nerd: 1 | 1 |
| `MountMortarB1F` | Blackbelt: 1 | 1 |
| `NationalPark` | Lass: 1; Pokefan F: 1; Pokefan M: 1; Schoolboy: 1 | 4 |
| `OlivineGym` | Lass: 2 | 2 |
| `OlivineLighthouse2F` | Gentleman: 1; Sailor: 1 | 2 |
| `OlivineLighthouse3F` | Bird Keeper: 1; Gentleman: 1; Sailor: 1 | 3 |
| `OlivineLighthouse4F` | Lass: 1; Sailor: 1 | 2 |
| `OlivineLighthouse5F` | Bird Keeper: 1; Sailor: 1 | 2 |
| `PewterGym` | Camper: 1 | 1 |
| `RadioTower1F` | Rocket Grunt F: 1 | 1 |
| `RadioTower2F` | Rocket Grunt F: 2; Rocket Grunt M: 2 | 4 |
| `RadioTower3F` | Rocket Grunt F: 2; Rocket Grunt M: 1; Scientist: 1 | 4 |
| `RadioTower4F` | Rocket Grunt F: 1; Rocket Grunt M: 1; Scientist: 1 | 3 |
| `Route1` | Cooltrainer F: 1; Schoolboy: 1 | 2 |
| `Route10South` | Hiker: 1; Pokefan M: 1 | 2 |
| `Route11` | Psychic: 2; Youngster: 2 | 4 |
| `Route12` | Fisher: 4 | 4 |
| `Route13` | Bird Keeper: 2; Hiker: 1; Pokefan M: 2 | 5 |
| `Route14` | Bird Keeper: 1; Pokefan M: 2 | 3 |
| `Route15` | Schoolboy: 4; Teacher: 2 | 6 |
| `Route17` | Biker: 4 | 4 |
| `Route18` | Bird Keeper: 2; Tamer: 3 | 5 |
| `Route19` | Swimmer F: 1; Swimmer M: 3 | 4 |
| `Route20` | Swimmer F: 2; Swimmer M: 1 | 3 |
| `Route21` | Fisher: 1; Swimmer F: 1; Swimmer M: 1 | 3 |
| `Route24` | Rocket Grunt M: 1 | 1 |
| `Route25` | Cooltrainer M: 1; Cosplayer: 1; Juggler: 1; Lass: 1; Pokefan M: 1; School Girl: 1; Super Nerd: 1 | 7 |
| `Route26` | Cooltrainer F: 2; Cooltrainer M: 2; Fisher: 1; Psychic: 1 | 6 |
| `Route27` | Bird Keeper: 1; Cooltrainer F: 2; Cooltrainer M: 2; Psychic: 1 | 6 |
| `Route3` | Cosplayer: 2; Firebreather: 2; Youngster: 2 | 6 |
| `Route30` | Bug Catcher: 1; Youngster: 2 | 3 |
| `Route31` | Bug Catcher: 1 | 1 |
| `Route32` | Bird Keeper: 1; Camper: 1; Fisher: 3; Picnicker: 1; Youngster: 2 | 8 |
| `Route33` | Hiker: 1 | 1 |
| `Route34` | Camper: 1; Cooltrainer F: 3; Officer: 1; Picnicker: 1; Pokefan M: 1; Youngster: 2 | 9 |
| `Route35` | Bird Keeper: 1; Bug Catcher: 1; Camper: 2; Firebreather: 1; Juggler: 1; Officer: 1; Picnicker: 1; School Girl: 1 | 9 |
| `Route36` | Psychic: 1; Schoolboy: 1 | 2 |
| `Route37` | Psychic: 1; Twins: 2 | 3 |
| `Route38` | Beauty: 2; Bird Keeper: 1; Lass: 1; Sailor: 1; Schoolboy: 1 | 6 |
| `Route39` | Pokefan F: 2; Pokefan M: 1; Psychic: 1; Sailor: 1 | 5 |
| `Route4` | Bird Keeper: 1; Cosplayer: 2; School Girl: 2 | 5 |
| `Route40` | Swimmer F: 2; Swimmer M: 2 | 4 |
| `Route41` | Swimmer F: 5; Swimmer M: 5 | 10 |
| `Route42` | Fisher: 1; Hiker: 1; Pokemaniac: 1 | 3 |
| `Route43` | Camper: 1; Fisher: 1; Picnicker: 1; Pokemaniac: 3 | 6 |
| `Route44` | Bird Keeper: 1; Boarder: 1; Cooltrainer F: 1; Cooltrainer M: 1; Fisher: 2; Pokemaniac: 1; Psychic: 1; Skier: 1 | 9 |
| `Route45` | Blackbelt: 1; Camper: 1; Cooltrainer F: 1; Cooltrainer M: 1; Hiker: 4 | 8 |
| `Route46` | Camper: 1; Hiker: 1; Picnicker: 1 | 3 |
| `Route6` | Pokefan M: 2 | 2 |
| `Route7` | Battle Girl: 2 | 2 |
| `Route8` | Biker: 3; Super Nerd: 2 | 5 |
| `Route9` | Camper: 2; Hiker: 2; Juggler: 2; School Girl: 2 | 8 |
| `RuinsOfAlphOutside` | Psychic: 1; Super Nerd: 1 | 2 |
| `SaffronGym` | Medium: 2; Psychic: 2 | 4 |
| `SeafoamGym` | Burglar: 2; Firebreather: 2 | 4 |
| `ShiverIsle` | Boarder: 2; Skier: 1 | 3 |
| `SilentCrypt` | Hex Maniac: 2; Medium: 1 | 3 |
| `SlowpokeWellB1F` | Rocket Grunt F: 2; Rocket Grunt M: 1 | 3 |
| `SproutTower1F` | Sage: 1 | 1 |
| `SproutTower2F` | Sage: 2 | 2 |
| `SproutTower3F` | Sage: 4 | 4 |
| `TeamRocketBaseB1F` | Rocket Grunt F: 1; Rocket Grunt M: 10; Scientist: 1 | 12 |
| `TeamRocketBaseB2F` | Rocket Grunt F: 2; Rocket Grunt M: 1 | 3 |
| `TeamRocketBaseB3F` | Rocket Grunt F: 1; Rocket Grunt M: 1; Scientist: 2 | 4 |
| `UnionCave1F` | Firebreather: 2; Hiker: 2; Pokemaniac: 1 | 5 |
| `UnionCaveB1F` | Hiker: 2; Pokemaniac: 2 | 4 |
| `UnionCaveB2F` | Cooltrainer F: 2; Cooltrainer M: 1 | 3 |
| `VermilionCity` | Cooltrainer M: 1 | 1 |
| `VermilionGym` | Gentleman: 1; Guitarist: 1; Juggler: 1 | 3 |
| `VictoryRoad` | Battle Girl: 2; Cooltrainer F: 1; Cooltrainer M: 1; Tamer: 2 | 6 |
| `VioletGym` | Bird Keeper: 2 | 2 |
| `ViridianForest` | Bug Catcher: 3 | 3 |
| `ViridianGym` | Cooltrainer M: 3 | 3 |
| `WiseTriosRoom` | Sage: 3 | 3 |

## Areas with no eligible fixed trainers

These areas have 0 qualifying trainers after the exclusions above.

- `AzaleaMart`, `AzaleaPokecenter1F`, `AzaleaTown`, `BattleTower1F`, `BattleTowerBattleRoom`, `BattleTowerElevator`, `BattleTowerHallway`, `BattleTowerOutside`
- `BillsBrothersHouse`, `BillsFamilysHouse`, `BillsHouse`, `BlackthornCity`, `BlackthornDragonSpeechHouse`, `BlackthornEmysHouse`, `BlackthornMart`, `BlackthornPokecenter1F`
- `BluesHouse`, `BrunosRoom`, `BurnedTowerB1F`, `CeladonCafe`, `CeladonCity`, `CeladonDeptStore1F`, `CeladonDeptStore2F`, `CeladonDeptStore3F`
- `CeladonDeptStore4F`, `CeladonDeptStore5F`, `CeladonDeptStore6F`, `CeladonDeptStoreElevator`, `CeladonGameCorner`, `CeladonGameCornerPrizeRoom`, `CeladonMansion1F`, `CeladonMansion2F`
- `CeladonMansion3F`, `CeladonMansionRoof`, `CeladonMansionRoofHouse`, `CeladonPokecenter1F`, `CeladonPokecenter2FBeta`, `CeruleanCity`, `CeruleanGymBadgeSpeechHouse`, `CeruleanMart`
- `CeruleanPokecenter1F`, `CeruleanPokecenter2FBeta`, `CeruleanPoliceStation`, `CeruleanTradeSpeechHouse`, `CharcoalKiln`, `CherrygroveCity`, `CherrygroveEvolutionSpeechHouse`, `CherrygroveGymSpeechHouse`
- `CherrygroveMart`, `CherrygrovePokecenter1F`, `CianwoodCity`, `CianwoodLugiaSpeechHouse`, `CianwoodPharmacy`, `CianwoodPhotoStudio`, `CianwoodPokecenter1F`, `CinnabarIsland`
- `CinnabarPokecenter1F`, `CinnabarPokecenter2FBeta`, `Colosseum`, `CopycatsHouse1F`, `CopycatsHouse2F`, `DarkCaveBlackthornEntrance`, `DarkCaveVioletEntrance`, `DayCare`
- `DayOfWeekSiblingsHouse`, `DiglettsCave`, `DragonsDen1F`, `DragonShrine`, `EarlsPokemonAcademy`, `EcruteakCity`, `EcruteakItemfinderHouse`, `EcruteakLugiaSpeechHouse`
- `EcruteakMart`, `EcruteakPokecenter1F`, `EcruteakTinTowerEntrance`, `ElmsHouse`, `ElmsLab`, `FastShip1F`, `FightingDojo`, `FireIsland`
- `FuchsiaCity`, `FuchsiaMart`, `FuchsiaPokecenter1F`, `FuchsiaPokecenter2FBeta`, `GoldenrodBikeShop`, `GoldenrodCity`, `GoldenrodDeptStore1F`, `GoldenrodDeptStore2F`
- `GoldenrodDeptStore3F`, `GoldenrodDeptStore4F`, `GoldenrodDeptStore5F`, `GoldenrodDeptStore6F`, `GoldenrodDeptStoreB1F`, `GoldenrodDeptStoreElevator`, `GoldenrodDeptStoreRoof`, `GoldenrodFlowerShop`
- `GoldenrodGameCorner`, `GoldenrodHappinessRater`, `GoldenrodMagnetTrainStation`, `GoldenrodNameRater`, `GoldenrodPokecenter1F`, `GoldenrodPPSpeechHouse`, `GravekeepersHouse`, `GuideGentsHouse`
- `HallOfFame`, `IceIsland`, `IcePath1F`, `IcePathB1F`, `IcePathB2FBlackthornSide`, `IcePathB2FMahoganySide`, `IcePathB3F`, `IlexForestAzaleaGate`
- `IndigoPlateauPokecenter1F`, `KarensRoom`, `KogasRoom`, `KurtsHouse`, `LakeOfRageHiddenPowerHouse`, `LakeOfRageMagikarpHouse`, `LancesRoom`, `LavenderMart`
- `LavenderNameRater`, `LavenderPokecenter1F`, `LavenderPokecenter2FBeta`, `LavenderSpeechHouse`, `LavenderTown`, `LavRadioTower1F`, `MahoganyMart1F`, `MahoganyPokecenter1F`
- `MahoganyRedGyaradosSpeechHouse`, `MahoganyTown`, `ManiasHouse`, `MobileBattleRoom`, `MobileTradeRoom`, `MountMoon`, `MountMoonGiftShop`, `MountMoonSquare`
- `MountMortar1FOutside`, `MoveDeletersHouse`, `MrFujisHouse`, `MrPokemonsHouse`, `MrPsychicsHouse`, `NationalParkBugContest`, `NewBarkTown`, `OaksLab`
- `OlivineCafe`, `OlivineCity`, `OlivineGoodRodHouse`, `OlivineHouseBeta`, `OlivineLighthouse1F`, `OlivineLighthouse6F`, `OlivineMart`, `OlivinePokecenter1F`
- `OlivinePort`, `OlivinePortPassage`, `OlivinePunishmentSpeechHouse`, `OlivineTimsHouse`, `PalletTown`, `PewterCity`, `PewterMart`, `PewterNidoranSpeechHouse`
- `PewterPokecenter1F`, `PewterPokecenter2FBeta`, `PewterSnoozeSpeechHouse`, `PlayersHouse1F`, `PlayersHouse2F`, `PlayersNeighborsHouse`, `Pokecenter2F`, `PokecomCenterAdminOfficeMobile`
- `PokemonFanClub`, `PokeSeersHouse`, `PowerPlant`, `RadioTower5F`, `RedsHouse1F`, `RedsHouse2F`, `RockTunnel1F`, `RockTunnelB1F`
- `Route10North`, `Route10Pokecenter1F`, `Route10Pokecenter2FBeta`, `Route12SuperRodHouse`, `Route15FuchsiaGate`, `Route16`, `Route16FuchsiaSpeechHouse`, `Route16Gate`
- `Route17Route18Gate`, `Route19FuchsiaGate`, `Route2`, `Route22`, `Route23`, `Route26HealHouse`, `Route27SandstormHouse`, `Route28`
- `Route28SteelWingHouse`, `Route29`, `Route29Route46Gate`, `Route2Gate`, `Route2NuggetHouse`, `Route30BerryHouse`, `Route31VioletGate`, `Route32Pokecenter1F`
- `Route32RuinsOfAlphGate`, `Route34IlexForestGate`, `Route35GoldenrodGate`, `Route35NationalParkGate`, `Route36NationalParkGate`, `Route36RuinsOfAlphGate`, `Route38EcruteakGate`, `Route39Barn`
- `Route39Farmhouse`, `Route40BattleTowerGate`, `Route42EcruteakGate`, `Route43Gate`, `Route43MahoganyGate`, `Route5`, `Route5CleanseTagHouse`, `Route5SaffronGate`
- `Route5UndergroundPathEntrance`, `Route6SaffronGate`, `Route6UndergroundPathEntrance`, `Route7SaffronGate`, `Route8SaffronGate`, `RuinsOfAlphAerodactylChamber`, `RuinsOfAlphAerodactylItemRoom`, `RuinsOfAlphAerodactylWordRoom`
- `RuinsOfAlphHoOhChamber`, `RuinsOfAlphHoOhItemRoom`, `RuinsOfAlphHoOhWordRoom`, `RuinsOfAlphInnerChamber`, `RuinsOfAlphKabutoChamber`, `RuinsOfAlphKabutoItemRoom`, `RuinsOfAlphKabutoWordRoom`, `RuinsOfAlphOmanyteChamber`
- `RuinsOfAlphOmanyteItemRoom`, `RuinsOfAlphOmanyteWordRoom`, `RuinsOfAlphResearchCenter`, `SafariZone`, `SafariZoneBeta`, `SafariZoneFuchsiaGateBeta`, `SafariZoneLobby`, `SafariZoneMainOffice`
- `SafariZoneWardensHome`, `SaffronCity`, `SaffronMagnetTrainStation`, `SaffronMart`, `SaffronPokecenter1F`, `SaffronPokecenter2FBeta`, `SilphCo1F`, `SilverCaveItemRooms`
- `SilverCaveOutside`, `SilverCavePokecenter1F`, `SilverCaveRoom1`, `SilverCaveRoom2`, `SilverCaveRoom3`, `SlowpokeWellB2F`, `SoulHouse`, `ThunderIsland`
- `TimeCapsule`, `TinTower1F`, `TinTower2F`, `TinTower3F`, `TinTower4F`, `TinTower5F`, `TinTower6F`, `TinTower7F`
- `TinTower8F`, `TinTower9F`, `TinTowerRoof`, `TohjoFalls`, `TradeCenter`, `TrainerHouse1F`, `TrainerHouseB1F`, `UndergroundPath`
- `VermilionDiglettsCaveSpeechHouse`, `VermilionFishingSpeechHouse`, `VermilionMagnetTrainSpeechHouse`, `VermilionMart`, `VermilionPokecenter1F`, `VermilionPokecenter2FBeta`, `VermilionPort`, `VermilionPortPassage`
- `VictoryRoadGate`, `VioletCity`, `VioletKylesHouse`, `VioletMart`, `VioletNicknameSpeechHouse`, `VioletPokecenter1F`, `ViridianCity`, `ViridianForestNorthGate`
- `ViridianForestSouthGate`, `ViridianMart`, `ViridianNicknameSpeechHouse`, `ViridianPokecenter1F`, `ViridianPokecenter2FBeta`, `WhirlIslandB1F`, `WhirlIslandB2F`, `WhirlIslandCave`
- `WhirlIslandLugiaChamber`, `WhirlIslandNE`, `WhirlIslandNW`, `WhirlIslandSE`, `WhirlIslandSW`, `WillsRoom`

## Overall trainer-class ranking (most to least)

| Rank | Trainer class | Count |
|---:|---|---:|
| 1 | Rocket Grunt M | 24 |
| 2 | Cooltrainer M | 19 |
| 3 | Cooltrainer F | 18 |
| 4 | Fisher | 16 |
| 5 | Hiker | 16 |
| 6 | Rocket Grunt F | 16 |
| 7 | Bird Keeper | 15 |
| 8 | Pokefan M | 13 |
| 9 | Swimmer F | 13 |
| 10 | Swimmer M | 13 |
| 11 | Pokemaniac | 12 |
| 12 | Psychic | 12 |
| 13 | Sage | 12 |
| 14 | Bug Catcher | 11 |
| 15 | Camper | 10 |
| 16 | Sailor | 10 |
| 17 | Schoolboy | 10 |
| 18 | Twins | 10 |
| 19 | Youngster | 10 |
| 20 | Lass | 9 |
| 21 | Super Nerd | 9 |
| 22 | Firebreather | 8 |
| 23 | Kimono Girl | 8 |
| 24 | School Girl | 8 |
| 25 | Biker | 7 |
| 26 | Blackbelt | 7 |
| 27 | Beauty | 6 |
| 28 | Boarder | 6 |
| 29 | Juggler | 6 |
| 30 | Burglar | 5 |
| 31 | Cosplayer | 5 |
| 32 | Medium | 5 |
| 33 | Picnicker | 5 |
| 34 | Scientist | 5 |
| 35 | Tamer | 5 |
| 36 | Battle Girl | 4 |
| 37 | Gentleman | 4 |
| 38 | Ninja | 4 |
| 39 | Pokefan F | 4 |
| 40 | Skier | 4 |
| 41 | Hex Maniac | 3 |
| 42 | Teacher | 3 |
| 43 | Guitarist | 2 |
| 44 | Officer | 2 |
