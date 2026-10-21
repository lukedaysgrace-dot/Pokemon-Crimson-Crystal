# Trainer theme review — complete coverage

Updated after implementation on 20 October 2026. [Applied fixes](trainer-theme-fixes.md) · [Original review](trainer-theme-audit.md).

**594 authored fixed party records / 1,819 slots**, followed by **all 70 Battle Tower identities**. Every fixed row lists its entire species/level roster. “Keep” means no worthwhile additional theme change identified under the stated rubric; it is not a battle-balance verdict. All 31 original findings are resolved; links identify the applied changes. Source rosters and map references below reflect the implementation.

Locations include party comments and actual direct map references. “No direct map ref” does not prove an entry is unreachable. Dynamic class aliases and rematch lookups are not counted as new authored rosters.

## Falkner — 2 parties

Bird identity; regional/evolved birds accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [FALKNER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:20) | FALKNER | Violet Gym; [VioletGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:21) | Hoothoot 8, Fletchling 9, Pidgeotto 10 | Keep |
| [FALKNER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:39) | FALKNER | Violet Gym; [VioletGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:59) | Skarmory 75, Noctowl 75, Archeops 76, Talonflame 76, Honchkrow 77, Pidgeot 77 | Keep |

## Whitney — 2 parties

Normal companions plus explicitly allowed Fairy partners; rematch retains Normal types.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) | WHITNEY | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:31) | Clefairy 18, Aipom 19, Buneary 19, Miltank 20 | Keep |
| [WHITNEY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:100) | WHITNEY | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:85) | Blissey 77, Ambipom 77, Lopunny 78, Ursaluna 78, Snorlax 79, Miltank 79 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Bugsy — 2 parties

Bug specialist, including dual types.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BUGSY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:137) | BUGSY | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:24) | Pineco 14, Joltik 15, Scyther 16 | Keep |
| [BUGSY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:156) | BUGSY | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:62) | Forretress 76, Vikavolt 76, Heracross 77, Golisopod 77, Volcarona 78, Scizor 78 | Keep |

## Morty — 2 parties

Ghost specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193) | MORTY | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:33) | Golett 23, Misdreavus 24, Drifloon 24, Gengar 25 | Keep |
| [MORTY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:217) | MORTY | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:74) | Mismagius 78, Dusknoir 78, Mimikyu 79, Chandelure 79, Dragapult 80, Gengar 80 | Keep |

## Pryce — 2 parties

Ice specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [PRYCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:254) | PRYCE | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:24) | Alolan Ninetales 35, Dewgong 36, Cetitan 36, Glaceon 37, Abomasnow 37, Mamoswine 38 | Keep |
| [PRYCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:288) | PRYCE | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:63) | Alolan Ninetales 81, Cloyster 81, Glaceon 82, Weavile 82, Lapras 83, Mamoswine 83 | Keep |

## Jasmine — 2 parties

Steel specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [JASMINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325) | JASMINE | Olivine Gym; [OlivineGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm:39) | Skarmory 31, Lairon 31, Magneton 32, Tinkatuff 33, Steelix 34 | Keep |
| [JASMINE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:354) | JASMINE | Olivine Gym; [OlivineGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm:86) | Magnezone 80, Corviknight 80, Excadrill 81, Lucario 81, Tinkaton 82, Steelix 82 | Keep |

## Chuck — 2 parties

Fighting specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CHUCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:391) | CHUCK | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:41) | Hitmontop 28, Gurdurr 28, Breloom 29, Scraggy 29, Poliwrath 30 | Keep |
| [CHUCK2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:420) | CHUCK | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:79) | Machamp 79, Conkeldurr 79, Gallade 80, Sirfetch'd 80, Annihilape 81, Poliwrath 81 | Keep |

## Clair — 2 parties

Dragon specialist using actual hack typings.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CLAIR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:457) | CLAIR | Blackthorn Gym 1F; [BlackthornGym1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:40) | Dragonair 42, Noivern 43, Flygon 43, Altaria 44, Tyrantrum 44, Kingdra 45 | Keep |
| [CLAIR2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:491) | CLAIR | Blackthorn Gym 1F; [BlackthornGym1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:98) | Altaria 82, Noivern 82, Archaludon 83, Haxorus 83, Salamence 84, Kingdra 84 | Keep |

## Will — 2 parties

Psychic specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530) | WILL | Will's Room; [WillsRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WillsRoom.asm:54) | Xatu 67, Farigiraf 68, Gallade 68, Slowking 69, Grumpig 69, Wyrdeer 70 | Keep |
| [WILL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:564) | WILL | Will's Room; [WillsRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WillsRoom.asm:57) | Xatu 83, Farigiraf 84, Gallade 84, Slowking 85, Grumpig 85, Espathra 85 | Keep |

## Cal — 6 parties

Generalist training opponent; starter-theme scaling and link/custom branches considered.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CAL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601) | CAL | Trainer House B1F (rematch); no direct map ref | Flygon 71, Ursaluna 71, Poliwrath 71 | Keep |
| [CAL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:617) | CAL | Trainer House B1F; [TrainerHouseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TrainerHouseB1F.asm:47) | Salazzle 71, Alolan Dugtrio 71, Arbok 71 | Keep |
| [CAL3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:635) | CAL | Trainer House B1F (highest level below 60); [TrainerHouseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TrainerHouseB1F.asm:54) | Meganium 50, Feraligatr 50, Typhlosion 50 | Keep |
| [CAL4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:654) | CAL | Trainer House B1F (highest level 60-69); no direct map ref | Meganium 60, Feraligatr 60, Typhlosion 60, Charizard 60 | Keep |
| [CAL5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:678) | CAL | Trainer House B1F (highest level 70-79); no direct map ref | Meganium 70, Feraligatr 70, Typhlosion 70, Charizard 70, Venusaur 70 | Keep |
| [CAL6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:707) | CAL | Trainer House B1F (highest level 80+); no direct map ref | Meganium 80, Feraligatr 80, Typhlosion 80, Charizard 80, Venusaur 80, Blastoise 80 | Keep |

## Bruno — 2 parties

Fighting specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BRUNO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744) | BRUNO | Bruno's Room; [BrunosRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BrunosRoom.asm:54) | Conkeldurr 69, Hitmontop 70, Lucario 70, Toxicroak 71, Annihilape 71, Machamp 72 | Keep |
| [BRUNO2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:778) | BRUNO | Bruno's Room; [BrunosRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BrunosRoom.asm:57) | Conkeldurr 84, Hitmontop 85, Lucario 85, Toxicroak 86, Annihilape 86, Machamp 86 | Keep |

## Karen — 2 parties

Dark specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KAREN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814) | KAREN | Karen's Room; [KarensRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/KarensRoom.asm:54) | Umbreon 69, Honchkrow 70, Weavile 70, Grimmsnarl 71, Houndoom 71, Kingambit 72 | Keep |
| [KAREN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:848) | KAREN | Karen's Room; [KarensRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/KarensRoom.asm:57) | Umbreon 84, Honchkrow 85, Weavile 85, Grimmsnarl 86, Houndoom 86, Kingambit 86 | Keep |

## Koga — 2 parties

Poison specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885) | KOGA | Koga's Room; [KogasRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/KogasRoom.asm:54) | Glimmora 68, Alolan Muk 69, Scolipede 69, Tentacruel 70, Salazzle 70, Crobat 71 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [KOGA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:919) | KOGA | Koga's Room; [KogasRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/KogasRoom.asm:57) | Glimmora 83, Alolan Muk 84, Scolipede 84, Tentacruel 85, Salazzle 85, Crobat 85 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Champion — 2 parties

Dragon champion.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956) | LANCE | Lance's Room; [LancesRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm:62) | Haxorus 70, Archaludon 71, Salamence 71, Dragapult 72, Baxcalibur 72, Dragonite 73 | Keep |
| [LANCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:990) | LANCE | Lance's Room; [LancesRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm:65) | Hydreigon 85, Archaludon 86, Salamence 86, Dragapult 87, Baxcalibur 87, Dragonite 87 | Keep |

## Brock — 1 parties

Rock/geology and evolved Onix identity; Steelix accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) | BROCK | Pewter Gym; [PewterGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PewterGym.asm:20) | Aerodactyl 47, Cradily 48, Steelix 48, Bastiodon 49, Armaldo 49, Golem 50 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Misty — 1 parties

Water specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [MISTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1064) | MISTY | Cerulean Gym; [CeruleanGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:68) | Milotic 51, Walrein 52, Gyarados 52, Azumarill 53, Lanturn 53, Starmie 54 | Keep |

## Lt Surge — 1 parties

Electric specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LT_SURGE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101) | LT.SURGE | Vermilion Gym; [VermilionGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:22) | Magnezone 55, Electivire 56, Vikavolt 56, Jolteon 57, Ampharos 57, Raichu 58 | Keep |

## Scientist — 5 parties

Technology, artificial Pokémon, chemicals or biological research.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) | ROSS | Team Rocket Base B3F; [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:158) | Croagunk 36, Porygon2 36 | [Resolved 18](trainer-theme-fixes.md#finding-18); [Fourth-pass moves](trainer-theme-fixes-round4.md); [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [MITCH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1148) | MITCH | Team Rocket Base B3F; [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:169) | Magneton 36 | Keep |
| [JED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1154) | JED | Team Rocket Base B1F; [TeamRocketBaseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB1F.asm:482) | Magneton 37, Weezing 37 | Keep |
| [MARC](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1164) | MARC | Radio Tower 3F; [RadioTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower3F.asm:117) | Porygon2 41 | Keep |
| [RICH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1171) | RICH | Radio Tower 4F; [RadioTower4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower4F.asm:90) | Galarian Slowbro 40, Weezing 41 | Keep |

## Erika — 1 parties

Grass/botanical specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1184) | ERIKA | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:23) | Ludicolo 59, Jumpluff 60, Vileplume 60, Victreebel 61, Exeggutor 61, Tsareena 62 | Keep |

## Youngster — 14 parties

Generalist route children; unusual favorites allowed; check explicit personal/local claims.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [JOEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1221) | JOEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:41) | Rattata 6 | Keep; phone wording fixed |
| [MIKEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1227) | MIKEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:188) | Drilbur 5, Pidgey 6 | [Resolved 15](trainer-theme-fixes.md#finding-15) |
| [ALBERT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1235) | ALBERT | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:423) | Grubbin 11, Aipom 11 | Keep |
| [GORDON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1243) | GORDON | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:434) | Ekans 14 | [Resolved 4](trainer-theme-fixes.md#finding-4) |
| [SAMUEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1249) | SAMUEL | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:389) | Sentret 15, Pidgey 17, Aipom 17 | Keep |
| [IAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1259) | IAN | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:400) | Spinarak 16, Drowzee 18 | [Resolved 16](trainer-theme-fixes.md#finding-16) |
| [JOEY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1267) | JOEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:99) | Raticate 24, Fearow 22 | Keep; phone wording fixed |
| [JOEY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1277) | JOEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:107) | Raticate 29, Fearow 27, Nidorino 28 | Keep; phone wording fixed |
| [WARREN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1290) | WARREN | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:26) | Fearow 50, Victreebel 51 | [Resolved 17](trainer-theme-fixes.md#finding-17) |
| [JIMMY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1300) | JIMMY | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:37) | Raticate 51, Dodrio 51 | [Resolved 12](trainer-theme-fixes.md#finding-12) |
| [OWEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1310) | OWEN | Route 11; [Route11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:14) | Sandslash 60, Tauros 60 | [Resolved 13](trainer-theme-fixes.md#finding-13) |
| [JASON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1320) | JASON | Route 11; [Route11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:25) | Tauros 60, Dodrio 60 | [Resolved 14](trainer-theme-fixes.md#finding-14) |
| [JOEY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1330) | JOEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:115) | Raticate 43, Fearow 41, Nidoking 42, Snorlax 41 | Keep; phone wording fixed |
| [JOEY5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1346) | JOEY | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:123) | Raticate 74, Fearow 74, Nidoking 73, Snorlax 72 | Keep; phone wording fixed |

## Schoolboy — 24 parties

Generalist students; study, intelligence, technology or ordinary companions all plausible.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [JACK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1365) | JACK | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:73) | Teddiursa 23, Furret 24 | Keep |
| [KIPP](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1373) | KIPP | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:38) | Furret 60, Lopunny 60 | Keep |
| [ALAN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1383) | ALAN | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:170) | Pawniard 24, Chinchou 24 | Keep |
| [JOHNNY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1391) | JOHNNY | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:60) | Raticate 60, Fearow 60 | Keep |
| [DANNY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1401) | DANNY | Route 1; [Route1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route1.asm:12) | Persian 63, Kangaskhan 63, Chansey 63 | Keep |
| [TOMMY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1414) | TOMMY | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:49) | Lopunny 60, Chansey 61 | Keep |
| [DUDLEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1424) | DUDLEY | Route 25; no direct map ref | Zangoose 52, Shuckle 52 | Keep |
| [JOE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1432) | JOE | Route 25; no direct map ref | Exeggutor 52, Mesmeria 52 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [BILLY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1442) | BILLY | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:71) | Farigiraf 58, Wigglytuff 58, Pidgeot 60 | Keep |
| [CHAD1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1455) | CHAD | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:180) | Eevee 28, Voltorb 28 | Keep |
| [NATE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1463) | NATE | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:183) | Porygon2 59, Blissey 59 | Keep |
| [RICKY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1473) | RICKY | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:194) | Porygon2 59, Chansey 59 | Keep |
| [JACK2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1483) | JACK | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:134) | Teddiursa 28, Furret 29, Stantler 28 | Keep |
| [JACK3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1493) | JACK | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:142) | Ursaring 41, Furret 42, Wyrdeer 43 | Keep |
| [ALAN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1503) | ALAN | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:233) | Pawniard 28, Lanturn 29, Corsola 28 | Keep |
| [ALAN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1513) | ALAN | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:241) | Bisharp 39, Lanturn 44, Corsola 42, Tauros 41 | Keep |
| [CHAD2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1529) | CHAD | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:241) | Eevee 33, Electrode 32, Scyther 34 | Keep |
| [CHAD3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1539) | CHAD | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:249) | Espeon 43, Electrode 41, Scyther 42 | Keep |
| [JACK4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1549) | JACK | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:150) | Ursaluna 74, Furret 73, Wyrdeer 74, Farigiraf 71 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [JACK5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1565) | JACK | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:158) | Furret 74, Ursaluna 74, Wyrdeer 77, Farigiraf 74 | Keep |
| [ALAN4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1581) | ALAN | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:249) | Kingambit 74, Lanturn 74, Corsola 71, Tauros 71 | Keep |
| [ALAN5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1593) | ALAN | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:257) | Kingambit 74, Tauros 76, Lanturn 77, Corsola 77 | Keep |
| [CHAD4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1617) | CHAD | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:257) | Espeon 74, Electrode 72, Scizor 73, Xatu 72 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [CHAD5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1633) | CHAD | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:265) | Scizor 72, Espeon 77, Electrode 74, Xatu 74 | Keep |

## Bird Keeper — 19 parties

Birds and bird-like fossil species; check Jose's signature dialogue.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ROD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1655) | ROD | Violet Gym; [VioletGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:84) | Fletchling 7, Natu 7 | Keep |
| [ABE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1663) | ABE | Violet Gym; [VioletGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:95) | Rookidee 9 | Keep |
| [BRYAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1669) | BRYAN | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:20) | Fearow 21, Pidgeotto 23, Fletchinder 23 | Keep |
| [THEO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1679) | THEO | Olivine Lighthouse 3F; [OlivineLighthouse3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse3F.asm:14) | Watu 32 | Keep |
| [TOBY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1685) | TOBY | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:17) | Watu 28, Fletchinder 28 | Keep |
| [DENIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1693) | DENIS | Olivine Lighthouse 5F; [OlivineLighthouse5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse5F.asm:15) | Watu 34, Corvisquire 34 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [VANCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1703) | VANCE | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:22) | Talonflame 40, Noctowl 40, Corviknight 40, Skarmory 41 | Keep |
| [HANK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1715) | HANK | Route 4; [Route4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:99) | Archeops 51, Corviknight 51 | Keep |
| [ROY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1725) | ROY | Route 14; [Route14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route14.asm:32) | Skarmory 60, Noctowl 60 | Keep |
| [BORIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1735) | BORIS | Route 18; [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:14) | Pidgeot 60, Skarmory 60, Honchkrow 60 | Keep |
| [BOB](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1748) | BOB | Route 18; [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:25) | Dodrio 60, Noctowl 61 | Keep |
| [JOSE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1758) | JOSE | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:113) | Farfetch'd 58, Honchkrow 58, Skarmory 58, Noctowl 58 | [Resolved 1](trainer-theme-fixes.md#finding-1); [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [PETER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1774) | PETER | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:445) | Spearow 12, Hoothoot 12 | Keep |
| [JOSE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1782) | JOSE | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:61) | Farfetch'd 45, Xatu 46, Corviknight 46, Honchkrow 46 | [Resolved 1](trainer-theme-fixes.md#finding-1) |
| [PERRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1794) | PERRY | Route 13; [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:36) | Honchkrow 60, Talonflame 61 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [BRET](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1804) | BRET | Route 13; [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:47) | Honchkrow 59, Talonflame 59 | Keep |
| [JOSE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1814) | JOSE | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:121) | Farfetch'd 74, Delibird 74, Talonflame 74, Skarmory 74, Xatu 74 | [Resolved 1](trainer-theme-fixes.md#finding-1) |
| [VANCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1843) | VANCE | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:75) | Talonflame 71, Skarmory 72, Honchkrow 73, Dodrio 74 | Keep |
| [VANCE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1855) | VANCE | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:83) | Talonflame 74, Honchkrow 76, Pidgeot 76, Noctowl 77 | Keep |

## Lass — 19 parties

Generalists; personal cute/outdoor themes; gym placement can impose Steel or Grass identity.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CARRIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1882) | CARRIE | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:110) | Jigglypuff 20 | [Resolved 20](trainer-theme-fixes.md#finding-20) |
| [BRIDGET](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1889) | BRIDGET | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:134) | Snubbull 18, Marill 18 | Keep |
| [KRISE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1897) | KRISE | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:283) | Steenee 23, Tangela 24 | [Resolved 21](trainer-theme-fixes.md#finding-21) |
| [CONNIE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1905) | CONNIE | Olivine Lighthouse 4F; [OlivineLighthouse4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse4F.asm:12) | Lombre 31, Octillery 32 | Keep |
| [LAURA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1913) | LAURA | Route 25; no direct map ref | Nidoqueen 53, Jumpluff 53, Galarian Rapidash 53 | Keep |
| [SHANNON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1923) | SHANNON | Route 25; no direct map ref | Toxicroak 53, Octillery 53, Victreebel 53 | Keep |
| [MICHELLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1933) | MICHELLE | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:53) | Vileplume 61, Ludicolo 61, Jumpluff 61 | Keep |
| [DANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1946) | DANA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:39) | Swablu 26, Togetic 27 | Keep |
| [ELLEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1956) | ELLEN | Route 25; no direct map ref | Flapple 52, Galarian Rapidash 52 | Keep |
| [CONNIE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1964) | CONNIE | Olivine Lighthouse 4F (rematch); no direct map ref | Ludicolo 42, Octillery 43, Lanturn 43 | Keep |
| [CONNIE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1974) | CONNIE | Olivine Lighthouse 4F (rematch); no direct map ref | Ludicolo 55, Octillery 55, Lanturn 56 | Keep |
| [DANA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1984) | DANA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:102) | Swablu 33, Togetic 34, Azumarill 33 | Keep |
| [DANA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1997) | DANA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:110) | Altaria 43, Togetic 42, Azumarill 42, Granbull 41 | Keep |
| [DANA4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2013) | DANA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:118) | Altaria 74, Togetic 72, Azumarill 73, Granbull 72 | Keep |
| [DANA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2029) | DANA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:126) | Granbull 76, Altaria 77, Azumarill 75, Togekiss 75 | Keep |
| [DANIELLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2045) | DANIELLE | Olivine Gym (after Jasmine returns); [OlivineGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm:138) | Lairon 31, Forretress 31, Skarmory 31 | Keep |
| [KATHRYN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2055) | KATHRYN | Olivine Gym (after Jasmine returns); [OlivineGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm:149) | Magneton 31, Skarmory 31, Forretress 31 | Keep |
| [PAIGE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2065) | PAIGE | Route 25; [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:456) | Vaporeon 51, Dewgong 52 | Keep |
| [ELISE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2075) | ELISE | Olivine Gym (after Jasmine returns); [OlivineGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm:160) | Perrserker 31, Mawile 31, Bisharp 31, Alolan Dugtrio 31 | Keep |

## Janine — 1 parties

Poison/ninja specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [JANINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2098) | JANINE | Fuchsia Gym; [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:24) | Toxapex 59, Venomoth 60, Seviper 60, Overqwil 61, Ariados 61, Crobat 62 | Keep |

## Cooltrainer M — 21 parties

Mixed skilled teams; Dragon Gym/Den permission dialogue overrides strict-type assumptions.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [NICK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2135) | NICK | Union Cave B2F; [UnionCaveB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB2F.asm:39) | Blastoise 46, Sneasler 46, Hisuian Arcanine 46 | Keep |
| [AARON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2148) | AARON | Lake of Rage; [LakeOfRage](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:186) | Feraligatr 36, Poliwhirl 36, Azumarill 36 | Keep |
| [PAUL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2161) | PAUL | Blackthorn Gym 1F; [BlackthornGym1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:123) | Dragonair 36, Zweilous 40, Dunsparce 40, Drakloak 40 | Keep |
| [CODY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2177) | CODY | Blackthorn Gym 2F; [BlackthornGym2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym2F.asm:60) | Seadra 41, Aerodactyl 42, Seadra 43 | Keep |
| [MIKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2190) | MIKE | Blackthorn Gym 1F; [BlackthornGym1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:134) | Dragonair 42, Kingdra 42, Charizard 43 | Keep |
| [GAVEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2203) | GAVEN | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:78) | Electrode 58, Donphan 58, Xatu 58, Golem 58, Politoed 58 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [GAVEN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2222) | GAVEN | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:86) | Electrode 74, Donphan 74, Xatu 74, Golem 74, Politoed 74 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [RYAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2241) | RYAN | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:262) | Gligar 42, Rhydon 42, Conkeldurr 42 | Keep |
| [JAKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2254) | JAKE | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:17) | Miltank 47, Umbreon 47, Nidoking 47, Porygon2 47, Feraligatr 49 | Keep |
| [GAVEN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2273) | GAVEN | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:28) | Electrode 46, Donphan 47, Xatu 47, Golem 47, Politoed 48 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [BLAKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2292) | BLAKE | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:174) | Mantine 45, Slowking 45, Wyrdeer 46, Walrein 46 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [BRIAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2308) | BRIAN | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:185) | Xatu 46, Quagsire 47, Seaking 48, Corviknight 48 | Keep |
| [SEAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2324) | SEAN | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:16) | Walrein 59, Gyarados 59, Blissey 59 | Keep |
| [KEVIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2337) | KEVIN | Route 25; [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:513) | Seaking 52, Sandslash 52, Alakazam 53, Espeon 54 | Keep |
| [ALLEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2353) | ALLEN | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:298) | Alolan Sandslash 39, Dusknoir 41 | Keep |
| [DARIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2363) | DARIN | Dragon's Den B1F; [DragonsDenB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:87) | Ampharos 46, Kingdra 46, Alolan Exeggutor 46, Dipplin 46 | Keep |
| [LARRY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2379) | LARRY | Viridian Gym; [ViridianGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:71) | Scolipede 67, Golisopod 67, Salamence 67, Blastoise Clone 67 | Keep |
| [SNOW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2403) | SNOW | Viridian Gym; [ViridianGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:82) | Lapras 68, Mismagius 68, Gardevoir 68, Charizard Clone 68 | Keep |
| [CYANIDE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2427) | CY | Viridian Gym; [ViridianGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:93) | Kingdra 67, Tyranitar 67, Dragonite 67, Venusaur Clone 67 | Keep |
| [CHANTZ](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2451) | CHANTZ | Vermilion City; [VermilionCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:113) | Persian 51, Granbull 51, Kangaskhan 52, Ursaluna 53 | Keep |
| [ADRIAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2475) | ADRIAN | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:136) | Scizor 67, Kingdra 68, Ampharos 69, Alakazam 70 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |

## Cooltrainer F — 22 parties

Mixed skilled teams; gym/Den placement and individual dialogue considered.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [GWEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2497) | GWEN | Union Cave B2F; [UnionCaveB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB2F.asm:50) | Donphan 42, Scolipede 43, Onix 44, Golem 45 | Keep |
| [LOIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2513) | LOIS | Lake of Rage; [LakeOfRage](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:197) | Lombre 36, Slowpoke 37 | Keep |
| [FRAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2523) | FRAN | Blackthorn Gym 2F; [BlackthornGym2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym2F.asm:71) | Kingdra 41, Appletun 41, Arctibax 41 | Keep |
| [LOLA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2536) | LOLA | Blackthorn Gym 1F; [BlackthornGym1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:145) | Shelgon 41, Appletun 41, Zweilous 42, Charizard 42 | Keep |
| [KATE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2552) | KATE | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:460) | Galarian Corsola 18, Cetoddle 20 | Keep |
| [IRENE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2562) | IRENE | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:422) | Slugma 18, Magby 20 | Keep |
| [KELLY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2572) | KELLY | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:273) | Talonflame 42, Rhydon 42, Sirfetch'd 42, Togetic 43 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [JOYCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2592) | JOYCE | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:121) | Drifblim 46, Tauros 47, Gorotora 47, Machamp 47, Crobat 48 | Keep |
| [BETH1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2611) | BETH | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:132) | Donphan 47, Scyther 47, Rapidash 47, Hitmontop 47, Mamoswine 47 | [Resolved 2](trainer-theme-fixes.md#finding-2) |
| [REENA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2630) | REENA | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:196) | Crobat 46, Slowbro 46, Sandslash 47, Starmie 47, Golem 48 | Keep |
| [MEGAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2649) | MEGAN | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:289) | Yanmega 47, Walrein 47, Yanma 47, Feraligatr 47 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md); [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [BETH2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2665) | BETH | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:182) | Donphan 58, Scyther 58, Rapidash 58, Hitmontop 58, Mamoswine 58 | [Resolved 2](trainer-theme-fixes.md#finding-2) |
| [CAROL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2684) | CAROL | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:27) | Lanturn 58, Heracross 58, Azumarill 59 | Keep |
| [QUINN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2697) | QUINN | Route 1; [Route1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route1.asm:23) | Electivire 64, Ledian 64, Galvantula 64 | Keep |
| [EMMA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2710) | EMMA | Union Cave B2F; [UnionCaveB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB2F.asm:61) | Tyranitar 46 | Keep |
| [CYBIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2717) | CYBIL | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:276) | Primeape 40, Corsola 41, Scizor 43 | Keep |
| [JENN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2730) | JENN | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:441) | Houndour 18, Haunter 20 | Keep |
| [BETH3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2740) | BETH | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:190) | Donphan 74, Scyther 74, Rapidash 74, Hitmontop 74, Mamoswine 74 | [Resolved 2](trainer-theme-fixes.md#finding-2) |
| [REENA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2759) | REENA | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:246) | Crobat 56, Slowbro 56, Sandslash 57, Starmie 57, Golem 58 | Keep |
| [REENA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2778) | REENA | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:254) | Crobat 70, Slowbro 71, Sandslash 71, Starmie 73, Golem 74 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [CARA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2797) | CARA | Dragon's Den B1F; [DragonsDenB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:98) | Gyarados 45, Seadra 44, Seadra 44, Seadra 46 | Keep |
| [SELENE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2813) | SELENE | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:143) | Crobat 67, Mamoswine 68, Espeon 69, Milotic 70 | Keep |

## Beauty — 6 parties

Companion/elegant Pokémon, with explicit local Gym themes where applicable.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [VICTORIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2836) | VICTORIA | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:145) | Hoothoot 17, Togetic 19 | Keep |
| [SAMANTHA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2844) | SAMANTHA | Goldenrod Gym; [GoldenrodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:156) | Meowth 20 | Keep |
| [CASSIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2851) | CASSIE | Fast Ship Cabins / SW / SSW / NW; [FastShipCabins_SW_SSW_NW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SW_SSW_NW.asm:35) | Porygon2 57, Milotic 59 | Keep |
| [JULIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2861) | JULIA | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:75) | Hisuian Electrode 61, Tsareena 61, Vileplume 61 | Keep |
| [VALERIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2874) | VALERIE | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:300) | Togetic 27, Galarian Ponyta 28 | Keep |
| [OLIVIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2882) | OLIVIA | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:311) | Stantler 28 | Keep |

## Pokémaniac — 15 parties

Unusual collections, regional variants or individual grooming/collector hooks.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LARRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2891) | LARRY | Union Cave 1F; [UnionCave1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCave1F.asm:18) | Wooper Paldean 13 | Keep |
| [ANDREW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2897) | ANDREW | Union Cave B1F; [UnionCaveB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB1F.asm:16) | Alolan Geodude 14, Phanpy 15 | Keep |
| [CALVIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2905) | CALVIN | Union Cave B1F; [UnionCaveB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB1F.asm:27) | Alolan Geodude 15 | Keep |
| [SHANE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2911) | SHANE | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:226) | Nidorino 33, Donphan 33 | Keep |
| [BEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2919) | BEN | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:41) | Ursaring 37, Farigiraf 37 | Keep |
| [BRENT1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2927) | BRENT | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:52) | Ambipom 36, Dunsparce 37, Munchlax 36 | Keep |
| [RON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2937) | RON | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:160) | Raitora 37, Ursaring 37, Nidoking 37 | Keep |
| [ETHAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2947) | ETHAN | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:38) | Lickilicky 59, Farigiraf 59 | [Resolved 24](trainer-theme-fixes.md#finding-24) |
| [BRENT2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2957) | BRENT | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:109) | Ambipom 38, Dunsparce 38, Munchlax 37 | Keep |
| [BRENT3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2967) | BRENT | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:117) | Ambipom 72, Dudunsparce 74, Snorlax 72, Chansey 72 | Keep |
| [ISSAC](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2983) | ISSAC | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:141) | Furret 19 | Keep |
| [DONALD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2990) | DONALD | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:152) | Golett 20, Aipom 20 | Keep |
| [ZACH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2998) | ZACH | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:287) | Gallade 40, Golem 41, Grumpig 43 | Keep |
| [BRENT4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3008) | BRENT | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:125) | Ambipom 74, Dudunsparce 75, Snorlax 75, Blissey 74, Tauros 77 | Keep |
| [MILLER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3027) | MILLER | Mount Mortar 1F Interior; [MountMortar1FInside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMortar1FInside.asm:19) | Graveler 30, Swinub 30 | Keep |

## Team Rocket Grunt M — 18 parties

Criminal, poison, dark, sinister or rough physical partners; no strict type requirement.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [GRUNTM_2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3038) | GRUNT | Slowpoke Well B1F; [SlowpokeWellB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm:75) | Gastly 15, Alolan Grimer 15, Croagunk 15 | Keep |
| [GRUNTM_4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3048) | GRUNT | Radio Tower 2F; [RadioTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower2F.asm:57) | Gloom 39, Seviper 39 | Keep |
| [GRUNTM_6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3056) | GRUNT | Radio Tower 2F; [RadioTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower2F.asm:79) | Golbat 40, Weepinbell 40 | Keep |
| [GRUNTM_7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3064) | GRUNT | Radio Tower 3F; [RadioTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower3F.asm:84) | Weavile 38, Weezing 38, Alolan Raticate 38 | Keep |
| [GRUNTM_10](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3074) | GRUNT | Radio Tower 4F; [RadioTower4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower4F.asm:57) | Alolan Muk 39, Galarian Slowbro 39, Alolan Raticate 39 | Keep |
| [GRUNTM_13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3084) | GRUNT | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:256) | Overqwil 39, Honchkrow 40 | Keep |
| [GRUNTM_14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3092) | GRUNT | Goldenrod Underground Warehouse; [GoldenrodUndergroundWarehouse](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundWarehouse.asm:48) | Ariados 38, Houndoom 38, Muk 40 | Keep |
| [GRUNTM_15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3102) | GRUNT | Goldenrod Underground Warehouse; [GoldenrodUndergroundWarehouse](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundWarehouse.asm:59) | Arbok 39, Overqwil 39, Weavile 39, Houndoom 39, Golbat 39 | Keep |
| [GRUNTM_18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3116) | GRUNT | Team Rocket Base B2F; [TeamRocketBaseB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB2F.asm:201) | Alolan Persian 34, Houndoom 34, Dusclops 35 | Keep |
| [GRUNTM_20](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3126) | GRUNT | Team Rocket Base B1F; [TeamRocketBaseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB1F.asm:239) | Gloom 34, Seviper 34 | Keep |
| [GRUNTM_21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3134) | GRUNT | Team Rocket Base B1F; [TeamRocketBaseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB1F.asm:252) | Drifblim 34, Sneasel 34, Glimmet 34 | Keep |
| [GRUNTM_25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3144) | GRUNT | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:223) | Toxicroak 39, Arbok 40 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [GRUNTM_28](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3154) | GRUNT | Team Rocket Base B3F; [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:146) | Alolan Marowak 36, Houndoom 36, Scraggy 36, Murkrow 36 | Keep |
| [GRUNTM_31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3166) | GRUNT | Route 24; [Route24](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route24.asm:17) | Houndoom 53, Galarian Slowking 53, Weavile 53, Crobat 53, Muk 53 | Keep |
| [GRUNTM_GOLDENROD_RIOLU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3180) | GRUNT | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:472) | Mankey 20, Koffing 20 | Keep |
| [GRUNTM_GOLDENROD_RIOLU_LEADER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3188) | GRUNT | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:507) | Houndour 21, Murkrow 21, Scraggy 22 | Keep |
| [GRUNTM_ROUTE43_TOLL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3198) | GRUNT | Route 43 Gate; [Route43Gate](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43Gate.asm:117) | Alolan Raticate 34, Koffing 34 | Keep |
| [GRUNTM_ROUTE43_TOLL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3206) | GRUNT | Route 43 Gate; [Route43Gate](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43Gate.asm:126) | Golbat 34, Alolan Grimer 34, Alolan Persian 35 | Keep |

## Gentleman — 4 parties

Refined companions and pets; Vermilion Gym imposes Electric theme.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [PRESTON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3219) | PRESTON | Olivine Lighthouse 3F; [OlivineLighthouse3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse3F.asm:25) | Growlithe 31, Persian 31 | Keep |
| [EDWARD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3227) | EDWARD | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:60) | Miltank 57, Blissey 59 | Keep |
| [GREGORY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3237) | GREGORY | Vermilion Gym; [VermilionGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:50) | Raichu 57, Electabuzz 57 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [ALFRED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3247) | ALFRED | Olivine Lighthouse 2F; [OlivineLighthouse2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:11) | Galarian Ponyta 34 | Keep |

## Skier — 4 parties

Ice/snow species.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ROXANNE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3256) | ROXANNE | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:88) | Jynx 38 | Keep |
| [CLARISSA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3262) | CLARISSA | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:99) | Weavile 39 | Keep |
| [SKIER_BIANCA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3268) | BIANCA | Shiver Isle; [ShiverIsle](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ShiverIsle.asm:38) | Froslass 44, Abomasnow 45, Weavile 46 | Keep |
| [SKIER_HEIDI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3278) | HEIDI | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:320) | Alolan Ninetales 40, Abomasnow 41, Piloswine 42 | Keep |

## Teacher — 3 parties

School/caretaker/intelligent partners; darker choices are optional character refinements.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [COLETTE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3291) | COLETTE | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:16) | Bellossom 59, Wigglytuff 60 | Keep |
| [HILLARY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3301) | HILLARY | Route 15; [Route15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:27) | Wyrdeer 61, Mr. Mime 61 | [Resolved 22](trainer-theme-fixes.md#finding-22) |
| [SHIRLEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3311) | SHIRLEY | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:172) | Blissey 57, Xatu 59 | [Resolved 23](trainer-theme-fixes.md#finding-23) |

## Sabrina — 1 parties

Psychic specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [SABRINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3324) | SABRINA | Saffron Gym; [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:23) | Mesmeria 59, Gardevoir 60, Farigiraf 60, Hypno 61, Wobbuffet 61, Alakazam 62 | Keep |

## Bug Catcher — 19 parties

Bug species using local typings, including Trapinch.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [DON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3361) | DON | Route 30; [Route30](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:199) | Pineco 5, Trapinch 5 | Keep |
| [ROB](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3369) | ROB | Route 2; [ViridianForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm:17) | Galvantula 49, Yanmega 49 | Keep |
| [ED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3379) | ED | Route 2; [ViridianForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm:28) | Parasect 48, Pinsir 48, Yanmega 48 | Keep |
| [WADE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3392) | WADE | Route 31; [Route31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:26) | Weedle 6, Pineco 7 | Keep |
| [BUG_CATCHER_BENNY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3400) | BENNY | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:109) | Trapinch 12, Pineco 15 | Keep; growth dialogue fixed |
| [AL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3408) | AL | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:120) | Sizzlipede 12, Joltik 15 | Keep |
| [JOSH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3416) | JOSH | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:131) | Ledian 16 | Keep |
| [ARNIE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3422) | ARNIE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:130) | Ariados 23, Venonat 23, Ledian 22 | Keep |
| [KEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3432) | KEN | Fast Ship Cabins / SW / SSW / NW; [FastShipCabins_SW_SSW_NW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SW_SSW_NW.asm:24) | Vikavolt 57, Ledian 59 | Keep |
| [WADE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3442) | WADE | Route 31; [Route31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:86) | Beedrill 24, Pineco 23, Sizzlipede 24 | Keep |
| [WADE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3452) | WADE | Route 31; [Route31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:94) | Beedrill 37, Forretress 37, Centiskorch 37, Galvantula 36 | Keep |
| [DOUG](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3464) | DOUG | Route 2; [ViridianForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm:39) | Beedrill 49, Scolipede 49 | Keep |
| [ARNIE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3474) | ARNIE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:193) | Ariados 37, Venomoth 38, Ledian 37 | Keep |
| [ARNIE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3484) | ARNIE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:201) | Ariados 43, Venomoth 44, Ledian 43, Heracross 44 | Keep |
| [WADE4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3496) | WADE | Route 31; [Route31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:102) | Beedrill 42, Forretress 43, Centiskorch 42, Galvantula 42, Heracross 43 | Keep |
| [WADE5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3510) | WADE | Route 31; [Route31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:110) | Beedrill 72, Forretress 72, Heracross 73, Centiskorch 73, Galvantula 74 | Keep |
| [ARNIE4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3524) | ARNIE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:209) | Ariados 74, Venomoth 73, Ledian 73, Heracross 74, Pinsir 73 | Keep |
| [ARNIE5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3538) | ARNIE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:217) | Ledian 74, Pinsir 74, Ariados 76, Heracross 77, Venomoth 75 | Keep |
| [WAYNE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3567) | WAYNE | Ilex Forest; [IlexForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:451) | Sizzlipede 18, Pineco 18 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |

## Fisher — 25 parties

Aquatic/fishing partners; freshwater and sea collections both allowed.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [JUSTIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3580) | JUSTIN | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:156) | Goldeen 11 | Keep |
| [RALPH1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3586) | RALPH | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:167) | Wooper 12 | Keep |
| [ARNOLD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3592) | ARNOLD | Route 21; [Route21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route21.asm:34) | Kingler 65, Poliwrath 65 | Keep |
| [KYLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3602) | KYLE | Route 12; [Route12](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route12.asm:38) | Toxapex 59, Lapras 59, Kingdra 59 | Keep |
| [HENRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3618) | HENRY | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:295) | Tentacool 11, Qwilfish 11 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [MARVIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3626) | MARVIN | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:171) | Sealeo 36, Golduck 36 | Keep |
| [TULLY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3634) | TULLY | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:97) | Seadra 32, Octillery 33 | Keep |
| [ANDRE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3642) | ANDRE | Lake of Rage; [LakeOfRage](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:164) | Gyarados 36 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RAYMOND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3648) | RAYMOND | Lake of Rage; [LakeOfRage](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:175) | Magikarp 37 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [WILTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3654) | WILTON | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:167) | Octillery 39, Mantine 39, Seaking 41 | Keep |
| [EDGAR](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3667) | EDGAR | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:265) | Walrein 39, Quagsire 39, Kingler 41 | Keep |
| [JONAH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3680) | JONAH | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:139) | Octillery 54, Cloyster 54, Milotic 58, Ludicolo 58 | Keep |
| [MARTIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3696) | MARTIN | Route 12; [Route12](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route12.asm:49) | Starmie 59, Tentacruel 61 | Keep |
| [STEPHEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3706) | STEPHEN | Route 12; [Route12](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route12.asm:60) | Mantine 59, Politoed 59, Tentacruel 59, Toxapex 59 | Keep |
| [BARNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3722) | BARNEY | Route 12; [Route12](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route12.asm:71) | Kingdra 59, Kingler 59, Milotic 59 | Keep |
| [RALPH2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3738) | RALPH | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:230) | Quagsire 24, Chinchou 23 | Keep |
| [RALPH3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3746) | RALPH | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:238) | Quagsire 38, Lanturn 38, Tentacruel 37 | Keep |
| [TULLY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3756) | TULLY | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:156) | Seadra 37, Octillery 38, Azumarill 37 | Keep |
| [TULLY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3766) | TULLY | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:164) | Kingdra 74, Octillery 73, Azumarill 72, Ludicolo 71 | Keep |
| [WILTON2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3778) | WILTON | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:222) | Octillery 72, Mantine 73, Seaking 73, Walrein 74 | Keep |
| [SCOTT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3790) | SCOTT | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:236) | Golduck 46, Poliwrath 46, Vaporeon 47, Octillery 48 | Keep |
| [WILTON3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3802) | WILTON | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:230) | Seaking 74, Mantine 74, Walrein 77, Octillery 75 | Keep |
| [RALPH4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3818) | RALPH | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:246) | Quagsire 74, Lanturn 72, Tentacruel 72, Corsola 71 | Keep |
| [RALPH5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3834) | RALPH | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:254) | Tentacruel 73, Lanturn 73, Quagsire 77, Corsola 74 | Keep |
| [TULLY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3850) | TULLY | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:172) | Kingdra 73, Azumarill 73, Octillery 77, Ludicolo 74 | Keep |

## Swimmer M — 13 parties

Water/aquatic partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [HAROLD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3877) | HAROLD | Route 19; [Route19](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:174) | Mantine 65, Walrein 65 | Keep |
| [SIMON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3887) | SIMON | Route 40; [Route40](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route40.asm:55) | Octillery 28, Shellder 28 | Keep |
| [RANDALL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3895) | RANDALL | Route 40; [Route40](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route40.asm:66) | Goldeen 28, Lanturn 28 | Keep |
| [CHARLIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3903) | CHARLIE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:113) | Lombre 29, Kingler 29 | Keep |
| [GEORGE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3911) | GEORGE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:124) | Lanturn 29, Tentacool 29, Psyduck 29 | Keep |
| [BERKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3921) | BERKE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:135) | Seel 30 | Keep |
| [KIRK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3927) | KIRK | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:146) | Tentacool 27, Lombre 27 | Keep |
| [MATHEW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3935) | MATHEW | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:157) | Corsola 29, Octillery 29 | Keep |
| [JEROME](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3943) | JEROME | Route 19; [Route19](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:185) | Toxapex 65, Lanturn 65, Slowking 65 | Keep |
| [TUCKER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3956) | TUCKER | Route 19; [Route19](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:196) | Seaking 65, Starmie 65 | Keep |
| [CAMERON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3966) | CAMERON | Route 20; [Route20](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:35) | Cloyster 65, Lanturn 65 | Keep |
| [SETH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3976) | SETH | Route 21; [Route21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route21.asm:12) | Poliwrath 64, Milotic 64, Toxapex 64 | Keep |
| [PARKER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3989) | PARKER | Cerulean Gym; [CeruleanGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:109) | Slowbro 51, Octillery 51, Gyarados 51 | Keep |

## Swimmer F — 13 parties

Water/aquatic partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ELAINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4008) | ELAINE | Route 40; [Route40](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route40.asm:33) | Mareanie 28 | Keep |
| [PAULA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4014) | PAULA | Route 40; [Route40](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route40.asm:44) | Tentacool 28, Lombre 29 | Keep |
| [KAYLEE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4022) | KAYLEE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:58) | Chinchou 27, Mareanie 27, Krabby 27 | Keep |
| [SUSIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4032) | SUSIE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:69) | Corsola 29, Shellder 30 | Keep |
| [DENISE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4042) | DENISE | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:80) | Mareanie 30 | Keep |
| [KARA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4048) | KARA | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:91) | Staryu 28, Lombre 29 | Keep |
| [WENDY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4056) | WENDY | Route 41; [Route41](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm:102) | Lanturn 29, Qwilfish 30 | Keep |
| [DAWN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4066) | DAWN | Route 19; [Route19](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:163) | Kingler 64, Ludicolo 65 | Keep |
| [NICOLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4076) | NICOLE | Route 20; [Route20](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:13) | Starmie 65, Octillery 65 | Keep |
| [LORI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4088) | LORI | Route 20; [Route20](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:24) | Walrein 65, Milotic 65 | Keep |
| [NIKKI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4098) | NIKKI | Route 21; [Route21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route21.asm:23) | Toxapex 64, Gyarados 64, Poliwrath 64 | Keep |
| [DIANA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4111) | DIANA | Cerulean Gym; [CeruleanGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:87) | Milotic 51, Politoed 51, Walrein 51 | Keep |
| [BRIANA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4124) | BRIANA | Cerulean Gym; [CeruleanGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:98) | Ludicolo 53, Toxapex 53, Walrein 53 | Keep |

## Sailor — 13 parties

Aquatic partners and Fighting brawlers.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [EUGENE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4143) | EUGENE | Route 39; [Route39](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39.asm:117) | Azumarill 25, Octillery 27 | Keep |
| [HUEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4151) | HUEY | Olivine Lighthouse 2F; [OlivineLighthouse2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:22) | Sealeo 32, Poliwhirl 34 | Keep |
| [TERRELL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4159) | TERRELL | Olivine Lighthouse 3F; [OlivineLighthouse3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse3F.asm:36) | Seel 33 | Keep |
| [KENT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4165) | KENT | Olivine Lighthouse 4F; [OlivineLighthouse4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse4F.asm:23) | Lanturn 33, Octillery 33 | Keep |
| [ERNEST](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4173) | ERNEST | Olivine Lighthouse 5F; [OlivineLighthouse5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse5F.asm:26) | Octillery 32, Lanturn 34, Poliwhirl 34 | Keep |
| [JEFF](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4183) | JEFF | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:95) | Azumarill 58, Hitmonchan 58 | Keep |
| [GARRETT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4193) | GARRETT | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:128) | Poliwrath 57, Kingler 59 | Keep |
| [KENNETH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4203) | KENNETH | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:161) | Tentacruel 58, Politoed 58, Azumarill 58, Lanturn 58 | Keep |
| [STANLY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4219) | STANLY | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:89) | Poliwrath 52, Golduck 52, Lanturn 53 | Keep |
| [HARRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4229) | HARRY | Route 38; no direct map ref | Poliwhirl 28 | Keep |
| [HUEY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4235) | HUEY | Olivine Lighthouse 2F; [OlivineLighthouse2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:77) | Walrein 42, Poliwrath 43, Quagsire 41 | Keep |
| [HUEY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4245) | HUEY | Olivine Lighthouse 2F; [OlivineLighthouse2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:85) | Walrein 74, Poliwrath 73, Quagsire 73 | Keep |
| [HUEY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4255) | HUEY | Olivine Lighthouse 2F; [OlivineLighthouse2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:93) | Walrein 77, Quagsire 77, Poliwrath 75 | Keep |

## Super Nerd — 9 parties

Technology, science, psychic study or biological type expertise; Teru's team shares Poison.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [STAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4271) | STAN | Ruins of Alph Outside; [RuinsOfAlphOutside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphOutside.asm:114) | Galarian Slowpoke 20 | Keep |
| [ERIC](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4277) | ERIC | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:119) | Magnemite 20, Voltorb 20 | Keep |
| [SAM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4285) | SAM | Route 8; [Route8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route8.asm:48) | Magnezone 60, Jolteon 61 | Keep |
| [TOM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4295) | TOM | Route 8; [Route8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route8.asm:59) | Hypno 59, Electrode 59, Weezing 59 | Keep |
| [PAT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4308) | PAT | Route 25; [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:478) | Magnezone 51, Porygon-Z 51, Glimmora 51 | Keep |
| [SHAWN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4321) | SHAWN | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:208) | Weezing 57, Electivire 58, Porygon2 59 | Keep |
| [TERU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4334) | TERU | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:130) | Spinarak 19, Glimmet 19, Ekans 19 | Keep |
| [HUGH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4344) | HUGH | Mount Mortar 2F Interior; [MountMortar2FInside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMortar2FInside.asm:16) | Magneton 38 | Keep |
| [MARKUS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4351) | MARKUS | Mount Mortar 1F Interior; [MountMortar1FInside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMortar1FInside.asm:30) | Magnemite 29 | Keep |

## Guitarist — 2 parties

Electric amplification and/or singing; Wigglytuff is a valid sound partner.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CLYDE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4361) | CLYDE | Fast Ship Cabins / SW / SSW / NW; [FastShipCabins_SW_SSW_NW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SW_SSW_NW.asm:46) | Gorotora 55, Electivire 57, Wigglytuff 59 | Keep |
| [VINCENT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4374) | VINCENT | Vermilion Gym; [VermilionGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:61) | Electabuzz 57, Electrode 57, Magneton 57, Vikavolt 57 | Keep |

## Hiker — 22 parties

Rock, ground, caves, mountains and rugged physical partners; check Bailey's explicit mountain claim.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ANTHONY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4393) | ANTHONY | Route 33; [Route33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:91) | Swinub 28, Sandslash 28, Dunsparce 29, Donphan 29 | Keep |
| [RUSSELL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4405) | RUSSELL | Union Cave 1F; [UnionCave1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCave1F.asm:29) | Numel 11, Wooper 12 | Keep |
| [PHILLIP](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4413) | PHILLIP | Union Cave B1F; [UnionCaveB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB1F.asm:38) | Gligar 13, Phanpy 13, Geodude 14 | Keep |
| [LEONARD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4423) | LEONARD | Union Cave B1F; [UnionCaveB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCaveB1F.asm:49) | Alolan Geodude 13, Phanpy 15 | Keep |
| [ANTHONY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4431) | ANTHONY | Route 33; [Route33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:15) | Phanpy 15, Swinub 15, Dunsparce 16 | Keep |
| [BENJAMIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4441) | BENJAMIN | Route 42; [Route42](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:237) | Numel 33, Sandslash 33 | Keep |
| [ERIK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4449) | ERIK | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:140) | Quagsire 42, Golem 42, Machamp 43 | Keep |
| [MICHAEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4459) | MICHAEL | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:151) | Donphan 43, Excadrill 43, Golem 43 | Keep |
| [PARRY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4469) | PARRY | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:215) | Sudowoodo 71, Rhyperior 74, Hitmonlee 71, Machamp 72 | Keep |
| [TIMOTHY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4485) | TIMOTHY | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:251) | Glimmora 43, Golem 43, Camerupt 43, Golurk 44 | Keep |
| [BAILEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4501) | BAILEY | Route 46; [Route46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:152) | Hisuian Arcanine 44, Clodsire 44, Rhydon 44, Golem 44, Magcargo 44 | [Resolved 3](trainer-theme-fixes.md#finding-3) |
| [ANTHONY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4515) | ANTHONY | Route 33; [Route33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:99) | Piloswine 42, Sandslash 42, Rhydon 42, Dudunsparce 43, Donphan 43 | Keep |
| [TIM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4529) | TIM | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:63) | Quagsire 55, Nidoking 55, Nidoqueen 55 | Keep |
| [NOLAND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4542) | NOLAND | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:49) | Golem 58, Poliwrath 58 | Keep |
| [SIDNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4552) | SIDNEY | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:74) | Golem 55, Mamoswine 55 | Keep |
| [KENNY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4562) | KENNY | Route 13; [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:58) | Hisuian Arcanine 59, Heracross 59, Hitmonchan 60, Steelix 60 | Keep |
| [JIM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4578) | JIM | Route 10 South; [Route10South](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route10South.asm:11) | Clodsire 54, Nidoqueen 56 | Keep |
| [DANIEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4588) | DANIEL | Union Cave 1F; [UnionCave1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCave1F.asm:40) | Wooper Paldean 14 | Keep |
| [PARRY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4594) | PARRY | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:223) | Sudowoodo 77, Rhyperior 77, Hitmonlee 77, Machamp 75 | Keep |
| [PARRY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4610) | PARRY | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:162) | Sudowoodo 43, Rhydon 43, Hitmonlee 43 | Keep |
| [ANTHONY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4620) | ANTHONY | Route 33; [Route33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:107) | Sandslash 72, Mamoswine 73, Dudunsparce 73, Rhyperior 74, Donphan 74 | Keep |
| [ANTHONY5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4634) | ANTHONY | Route 33; [Route33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:115) | Sandslash 74, Gliscor 75, Mamoswine 76, Dudunsparce 76, Rhyperior 77, Donphan 77 | Keep |

## Blaine — 1 parties

Fire specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BLAINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4659) | BLAINE | Seafoam Gym; [SeafoamGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:27) | Ninetales 63, Arcanine 64, Armarouge 64, Torkoal 65, Rapidash 65, Magmortar 66 | Keep |

## Burglar — 5 parties

Theft/stealth/loot, with Fire specialist requirements inside Seafoam Gym.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [DUNCAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4696) | DUNCAN | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:234) | Weavile 38, Persian 38 | Keep |
| [EDDIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4706) | EDDIE | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:245) | Sneasel 38, Murkrow 38 | [Resolved 19](trainer-theme-fixes.md#finding-19) |
| [COREY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4716) | COREY | Fast Ship Cabins / NNW / NNE / NE; [FastShipCabins_NNW_NNE_NE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:71) | Crobat 54, Ninetales 54, Magcargo 56, Houndoom 58 | Keep |
| [MORTON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4732) | MORTON | Seafoam Gym; [SeafoamGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:68) | Magcargo 64, Alolan Marowak 64, Rapidash 64 | Keep |
| [VANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4745) | VANCE | Seafoam Gym; [SeafoamGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:79) | Magmar 64, Hisuian Typhlosion 64, Flareon 64 | Keep |

## Firebreather — 8 parties

Fire specialist/showman.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [OTIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4761) | OTIS | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:15) | Arcanine 51, Ceruledge 51, Magmar 51 | Keep |
| [BURT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4774) | BURT | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:48) | Flareon 51, Magcargo 51 | Keep |
| [BILL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4784) | BILL | Union Cave 1F; [UnionCave1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCave1F.asm:51) | Slugma 14 | Keep |
| [WALT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4790) | WALT | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:230) | Houndour 20, Slugma 20 | Keep |
| [RAY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4798) | RAY | Union Cave 1F; [UnionCave1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/UnionCave1F.asm:62) | Vulpix 12 | Keep |
| [LYLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4804) | LYLE | Fast Ship Cabins / SW / SSW / NW; [FastShipCabins_SW_SSW_NW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SW_SSW_NW.asm:13) | Tauros Paldean Fire 58, Chandelure 58, Salazzle 58 | Keep |
| [SCORCH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4817) | IGNIS | Seafoam Gym; [SeafoamGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:90) | Armarouge 64, Magmortar 64, Ninetales 64, Arcanine 65 | Keep |
| [TORCH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4833) | BLAZE | Seafoam Gym; [SeafoamGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:101) | Torkoal 64, Talonflame 64, Magmar 64, Rapidash 65 | Keep |

## Juggler — 9 parties

Balls, dexterity, telekinetic props or wider circus/performance acts; Electric Gym context accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [IRWIN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4852) | IRWIN | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:31) | Voltorb 21, Aipom 21, Galarian Ponyta 21 | [Resolved 9](trainer-theme-fixes.md#finding-9) |
| [FRITZ](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4862) | FRITZ | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:117) | Electrode 56, Mr. Rime 56, Espeon 58 | [Resolved 10](trainer-theme-fixes.md#finding-10) |
| [HORTON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4875) | HORTON | Vermilion Gym; [VermilionGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:72) | Electivire 57, Ampharos 57, Gorotora 57, Lanturn 57 | Keep |
| [IRWIN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4891) | IRWIN | Route 35 (rematch); no direct map ref | Electrode 43, Ambipom 43, Galarian Rapidash 43 | [Resolved 9](trainer-theme-fixes.md#finding-9) |
| [IRWIN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4901) | IRWIN | Route 35 (rematch); no direct map ref | Wigglytuff 52, Electrode 55, Ambipom 54, Galarian Rapidash 56 | [Resolved 9](trainer-theme-fixes.md#finding-9) |
| [IRWIN4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4917) | IRWIN | Route 35 (rematch); no direct map ref | Electrode 58, Ambipom 58, Wigglytuff 58, Galarian Rapidash 63 | [Resolved 9](trainer-theme-fixes.md#finding-9) |
| [MARCO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4941) | MARCO | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:85) | Espeon 55, Clefable 55 | Keep |
| [LEON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4951) | LEON | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:96) | Xatu 54, Galarian Rapidash 54, Wigglytuff 56 | Keep |
| [SILAS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4964) | SILAS | Route 25 (Nugget Bridge 2); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:434) | Starmie 52, Mr. Mime 52, Chandelure 53 | [Resolved 11](trainer-theme-fixes.md#finding-11) |

## Blackbelt — 11 parties

Fighting specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KENJI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4983) | KENJI | Route 45 (rematch); no direct map ref | Annihilape 54, Hitmontop 56, Heracross 52, Conkeldurr 54, Lucario 52 | Keep |
| [YOSHI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5007) | YOSHI | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:104) | Primeape 30 | Keep |
| [KENJI2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5014) | KENJI | Route 45 (rematch); no direct map ref | Annihilape 60, Hitmontop 61, Heracross 60, Conkeldurr 61, Lucario 63 | Keep |
| [LAO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5033) | LAO | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:115) | Hitmontop 30 | Keep |
| [NOB](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5040) | NOB | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:126) | Machoke 28, Breloom 28 | Keep |
| [KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5050) | KIYO | legacy Mt. Mortar team, no longer placed; no direct map ref | Croagunk 32, Gurdurr 32 | Keep |
| [LUNG](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5060) | LUNG | Cianwood Gym; [CianwoodGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:137) | Gurdurr 28, Hitmontop 28, Machoke 28 | Keep |
| [KENJI3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5076) | KENJI | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:36) | Heracross 39, Primeape 39, Hitmontop 41, Conkeldurr 43 | Keep |
| [WAI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5096) | WAI | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:150) | Hitmontop 55, Lucario 57, Hitmonlee 59 | Keep |
| [DOJO_RIKU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5112) | RIKU | Fighting Dojo; [FightingDojo](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FightingDojo.asm:51) | Primeape 61, Breloom 62, Hitmonlee 63 | Keep |
| [DOJO_MASARU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5128) | MASARU | Fighting Dojo; [FightingDojo](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FightingDojo.asm:57) | Poliwrath 62, Heracross 62, Hitmonchan 63 | Keep |

## Team Rocket Executive M — 4 parties

Legacy Rocket executive identity; no direct map placement found.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [EXECUTIVEM_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5152) | EXECUTIVE | Not placed on any map; no direct map ref | Skarmory 31, Murkrow 31, Machoke 32, Gloom 32, Pawniard 33 | [Resolved 28](trainer-theme-fixes.md#finding-28) |
| [EXECUTIVEM_2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5171) | EXECUTIVE | Not placed on any map; no direct map ref | Croagunk 31, Gurdurr 31, Murkrow 31, Glimmet 32 | [Resolved 29](trainer-theme-fixes.md#finding-29) |
| [EXECUTIVEM_3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5187) | EXECUTIVE | Not placed on any map; no direct map ref | Murkrow 29, Scolipede 29, Golbat 30, Sneasel 30, Clodsire 31 | [Resolved 30](trainer-theme-fixes.md#finding-30) |
| [EXECUTIVEM_4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5206) | EXECUTIVE | Not placed on any map; no direct map ref | Misdreavus 23, Koffing 24, Alolan Grimer 24, Drifloon 24 | Keep |

## Psychic — 12 parties

Actual Psychic types, including retyped Noctowl and Golduck where used.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [NATHAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5225) | NATHAN | Ruins of Alph Outside; [RuinsOfAlphOutside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphOutside.asm:103) | Smoochum 23 | Keep |
| [FRANKLIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5232) | FRANKLIN | Saffron Gym; [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:59) | Galarian Slowbro 59, Hypno 61, Exeggutor 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [HERMAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5245) | HERMAN | Route 11; [Route11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:36) | Alakazam 60, Armarouge 60, Exeggutor 60 | Keep |
| [FIDEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5258) | FIDEL | Route 11; [Route11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:47) | Noctowl 56, Alakazam 58, Espathra 60 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [GREG](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5271) | GREG | Route 37; [Route37](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route37.asm:49) | Drowzee 25 | Keep |
| [NORMAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5278) | NORMAN | Route 39; [Route39](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39.asm:128) | Spoink 27, Slowpoke 28 | Keep |
| [MARK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5288) | MARK | Route 36; [Route36](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:311) | Kirlia 20, Natu 20, Kadabra 21 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [PHIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5301) | PHIL | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:156) | Hypno 40, Wobbuffet 40, Alakazam 40 | Keep |
| [RICHARD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5314) | RICHARD | Route 26; [Route26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:225) | Espeon 47, Gardevoir 47, Xatu 47 | Keep |
| [GILBERT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5327) | GILBERT | Route 27; [Route27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:50) | Farigiraf 44, Wobbuffet 46, Starmie 46 | Keep |
| [JARED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5340) | JARED | Saffron Gym; [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:81) | Noctowl 60, Exeggutor 60, Slowbro 60 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [RODNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5353) | RODNEY | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:175) | Gardevoir 55, Mr. Rime 55, Noctowl 59 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |

## Picnicker — 19 parties

Generalist outdoor/pet companions; named-signature phone partners checked.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LIZ1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5369) | LIZ | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:306) | Oddish 12, Ledyba 13 | Keep |
| [GINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5377) | GINA | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:217) | Snubbull 18, Poliwag 18 | Keep |
| [BROOKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5385) | BROOKE | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:108) | Weepinbell 23 | Keep |
| [CINDY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5392) | CINDY | Not placed on any map; no direct map ref | Forretress 52, Yanmega 55 | Keep |
| [GINA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5400) | GINA | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:280) | Granbull 35, Poliwhirl 35, Misdreavus 37 | Keep |
| [ERIN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5410) | ERIN | Route 46; [Route46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:26) | Ambipom 42, Farigiraf 42, Dudunsparce 44, Dodrio 44 | Keep |
| [LIZ2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5422) | LIZ | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:364) | Gloom 23, Ledian 24, Applin 21 | Keep |
| [LIZ3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5432) | LIZ | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:372) | Bellossom 37, Ledian 38, Flapple 37, Togetic 36 | Keep |
| [GINA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5444) | GINA | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:288) | Granbull 42, Politoed 43, Misdreavus 42, Miltank 42 | Keep |
| [TIFFANY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5456) | TIFFANY | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:243) | Chansey 43, Bellossom 43, Clefairy 43 | Keep |
| [TIFFANY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5469) | TIFFANY | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:251) | Jumpluff 74, Clefairy 74 | Keep |
| [ERIN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5479) | ERIN | Route 46; [Route46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:79) | Dudunsparce 72, Ursaluna 72, Gorotora 74, Furret 74 | Keep |
| [TIFFANY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5491) | TIFFANY | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:182) | Jigglypuff 35, Clefairy 35 | [Resolved 25](trainer-theme-fixes.md#finding-25) |
| [ERIN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5501) | ERIN | Route 46; [Route46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:87) | Lickilicky 72, Ursaluna 74, Furret 77, Lopunny 77 | Keep |
| [LIZ4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5517) | LIZ | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:380) | Bellossom 43, Ledian 43, Flapple 42, Togetic 41 | Keep |
| [LIZ5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5529) | LIZ | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:388) | Bellossom 71, Flapple 73, Ledian 74, Togekiss 72 | Keep |
| [GINA4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5545) | GINA | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:296) | Granbull 71, Politoed 74, Mismagius 72, Miltank 71 | Keep |
| [GINA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5557) | GINA | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:304) | Granbull 73, Mismagius 73, Politoed 77, Miltank 74 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [TIFFANY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5573) | TIFFANY | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:259) | Bellossom 76, Miltank 77, Clefairy 77 | Keep |

## School Girl — 8 parties

Individual school subjects: psychic expressions, programming/luck, art, sea study, fossils, ghosts, botany or team design.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KIM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5589) | KIM | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:119) | Kirlia 23 | Keep |
| [HOPE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5596) | HOPE | Route 4; [Route4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:110) | Porygon-Z 51, Togekiss 52 | Keep |
| [SHARON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5606) | SHARON | Route 4; [Route4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:121) | Smeargle 51, Altaria 52 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [DEBRA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5616) | DEBRA | Fast Ship B1F; [FastShipB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:106) | Lanturn 56, Milotic 58 | Keep |
| [HEIDI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5626) | HEIDI | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:30) | Cradily 55, Armaldo 56 | Keep |
| [EDNA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5636) | EDNA | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:52) | Froslass 55, Mismagius 55 | Keep |
| [TANYA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5646) | TANYA | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:64) | Leafeon 61, Breloom 61, Abomasnow 61 | Keep |
| [NADIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5659) | NADIA | Route 25 (Nugget Bridge 3); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:445) | Tinkaton 52, Sylveon 53 | Keep |

## Camper — 16 parties

Generalist outdoor/terrain companions; Pewter Gym Rock specialty respected.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ROLAND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5672) | ROLAND | Route 32; [Route32](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:145) | Kotora 13 | Keep |
| [TODD1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5678) | TODD | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:89) | Wooper Paldean 19, Cubone 18 | Keep |
| [IVAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5686) | IVAN | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:86) | Raticate 21, Phanpy 21 | Keep |
| [ELLIOT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5694) | ELLIOT | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:97) | Ledian 21, Munchlax 21 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [BARRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5704) | BARRY | Not placed on any map; no direct map ref | Rapidash 52, Donphan 55 | Keep |
| [LLOYD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5712) | LLOYD | Route 25; no direct map ref | Raticate 53, Hisuian Arcanine 53 | Keep |
| [DEAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5720) | DEAN | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:19) | Tauros 55, Furret 55 | Keep |
| [SID](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5730) | SID | Route 9; [Route9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:41) | Steelix 55, Ambipom 55, Pidgeot 55 | Keep |
| [TED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5743) | TED | Route 46; [Route46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:15) | Marowak 44, Lampent 44, Ursaluna 44 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [TODD2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5756) | TODD | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:152) | Swinub 31, Clodsire 33, Alolan Marowak 34 | Keep |
| [TODD3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5766) | TODD | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:160) | Clodsire 43, Alolan Marowak 44, Piloswine 43, Kangaskhan 42 | Keep |
| [JERRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5778) | JERRY | Pewter Gym; [PewterGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PewterGym.asm:42) | Golem 48, Rhyperior 49, Sudowoodo 49 | Keep |
| [SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5791) | SPENCER | Route 43; [Route43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:30) | Jumpluff 36, Sunflora 36 | Keep |
| [TODD4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5799) | TODD | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:168) | Clodsire 73, Alolan Marowak 74, Mamoswine 74, Kangaskhan 73 | Keep |
| [TODD5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5811) | TODD | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:176) | Clodsire 76, Alolan Marowak 76, Mamoswine 77, Kangaskhan 77 | Keep |
| [QUENTIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5835) | QUENTIN | Route 45; [Route45](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:292) | Excadrill 43, Golem 43, Piloswine 43, Marowak 43 | Keep |

## Team Rocket Executive F — 2 parties

Legacy Rocket executive identity; no direct map placement found; Wobbuffet is a defensible Rocket nod.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [EXECUTIVEF_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5850) | EXECUTIVE | Not placed on any map; no direct map ref | Golurk 32, Alolan Raticate 32, Houndoom 33, Murkrow 33, Hypno 33 | [Resolved 31](trainer-theme-fixes.md#finding-31) |
| [EXECUTIVEF_2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5869) | EXECUTIVE | Not placed on any map; no direct map ref | Golett 24, Salandit 24, Wobbuffet 25, Zweilous 25 | Keep |

## Sage — 11 parties

Plants, meditation, spiritual wisdom or tower/beast elements, according to location.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CHOW](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5888) | CHOW | Sprout Tower 1F; [SproutTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower1F.asm:27) | Sunkern 6, Bellsprout 6, Natu 6 | Keep |
| [NICO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5901) | NICO | Sprout Tower 2F; [SproutTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower2F.asm:12) | Hoppip 6, Sunkern 6, Natu 7 | Keep |
| [JIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5914) | JIN | Sprout Tower 3F; [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:94) | Hoppip 6 | Keep |
| [TROY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5920) | TROY | Sprout Tower 3F; [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:105) | Sunkern 7, Ralts 7 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [JEFFREY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5932) | JEFFREY | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:115) | Gastly 24, Misdreavus 24, Galarian Corsola 24 | Keep |
| [PING](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5942) | PING | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:126) | Misdreavus 25 | Keep |
| [EDMOND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5948) | EDMOND | Sprout Tower 2F; [SproutTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower2F.asm:23) | Hisuian Voltorb 6, Exeggcute 6, Natu 6 | Keep |
| [NEAL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5961) | NEAL | Sprout Tower 3F; [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:116) | Ralts 6 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [GAKU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5968) | GAKU | Wise Trios Room; [WiseTriosRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WiseTriosRoom.asm:70) | Arcanine 47, Ninetales 47, Xatu 47 | Keep |
| [MASA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5978) | MASA | Wise Trios Room; [WiseTriosRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WiseTriosRoom.asm:80) | Electrode 47, Noctowl 47, Ampharos 47 | Keep |
| [KOJI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5988) | KOJI | Wise Trios Room; [WiseTriosRoom](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WiseTriosRoom.asm:90) | Lanturn 47, Starmie 47, Slowking 47 | Keep |

## Medium — 5 parties

Ghost/spirit partners, or Psychic specialist partners in Saffron Gym.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [MARTHA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6001) | MARTHA | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:137) | Duskull 23, Shuppet 23 | Keep |
| [GRACE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6009) | GRACE | Ecruteak Gym; [EcruteakGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:148) | Gastly 23, Shuppet 23 | Keep |
| [BETHANY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6017) | BETHANY | Silent Crypt; [SilentCrypt](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilentCrypt.asm:39) | Duskull 22, Shuppet 23, Misdreavus 24 | Keep |
| [REBECCA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6030) | REBECCA | Saffron Gym; [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:48) | Espathra 61, Golduck 61, Alakazam 61 | Keep |
| [DORIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6043) | DORIS | Saffron Gym; [SaffronGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:70) | Slowbro 60, Exeggutor 60, Hypno 61 | Keep |

## Boarder — 6 parties

Ice and cold-climate species, including Seel as a polar seal.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [RONALD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6059) | RONALD | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:110) | Delibird 37, Jynx 38 | Keep |
| [BRAD](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6067) | BRAD | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:121) | Jynx 38, Froslass 38 | Keep |
| [DOUGLAS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6075) | DOUGLAS | Mahogany Gym; [MahoganyGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm:132) | Delibird 37, Jynx 37, Froslass 38 | Keep |
| [BOARDER_AIDAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6085) | AIDAN | Shiver Isle; [ShiverIsle](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ShiverIsle.asm:16) | Piloswine 43, Weavile 45 | Keep |
| [BOARDER_NOEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6093) | NOEL | Shiver Isle; [ShiverIsle](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ShiverIsle.asm:27) | Cetoddle 43, Swinub 44, Seel 45 | Keep |
| [BOARDER_SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6103) | SPENCER | Route 44; [Route44](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:309) | Abomasnow 40, Piloswine 41, Weavile 41 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md); [Fourth-pass moves](trainer-theme-fixes-round4.md) |

## Pokéfan M — 15 parties

Broad personal favorites; royal theme, Pikachu family, starter collection or grooming hooks checked.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [WILLIAM](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6122) | WILLIAM | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:193) | Noctowl 22 | Keep |
| [DEREK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6128) | DEREK | Route 39; [Route39](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39.asm:27) | Pikachu 27, Granbull 27 | Keep |
| [ROBERT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6136) | ROBERT | Route 10 South; [Route10South](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route10South.asm:22) | Clefable 55, Wigglytuff 57 | Keep |
| [JOSHUA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6146) | JOSHUA | Route 13; [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:25) | Pikachu 61, Raichu 61, Alolan Raichu 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [CARTER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6159) | CARTER | Route 14; [Route14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route14.asm:21) | Blastoise 61, Charizard 61, Venusaur 61 | Keep |
| [TREVOR](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6172) | TREVOR | Route 14; [Route14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route14.asm:43) | Porygon2 61, Persian 61, Golduck 61 | Keep |
| [BRANDON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6185) | BRANDON | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:411) | Diglett 19 | Keep |
| [JEREMY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6191) | JEREMY | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:186) | Chansey 57, Milotic 57, Porygon2 59 | Keep |
| [COLIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6204) | COLIN | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:142) | Alolan Raticate 56, Porygon-Z 58 | Keep |
| [DEREK2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6214) | DEREK | Route 39 (rematch); no direct map ref | Pikachu 43, Lanturn 43 | Keep |
| [DEREK3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6222) | DEREK | Route 39 (rematch); no direct map ref | Pikachu 56, Electabuzz 56 | Keep |
| [ALEX](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6230) | ALEX | Route 13; [Route13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:14) | Nidoking 59, Slowking 59, Kingambit 59 | Keep |
| [REX](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6243) | REX | Route 6; [Route6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route6.asm:12) | Persian 55, Donphan 56 | Keep |
| [ALLAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6253) | ALLAN | Route 6; [Route6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route6.asm:23) | Snorlax 54, Electrode 56 | Keep |
| [DUSTIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6263) | DUSTIN | Route 25; [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:467) | Azumarill 51, Ampharos 51, Donphan 51 | Keep |

## Kimono Girl — 9 parties

Eeveelutions, including later generations.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [NAOKO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6279) | NAOKO | Dance Theatre (rematch); no direct map ref | Espeon 54, Sylveon 56, Flareon 56 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [NAOKO2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6292) | NAOKO | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:21) | Flareon 24 | Keep |
| [SAYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6298) | SAYO | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:32) | Espeon 24 | Keep |
| [ZUKI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6304) | ZUKI | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:43) | Umbreon 24 | Keep |
| [KUNI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6310) | KUNI | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:54) | Vaporeon 24 | Keep |
| [MIKI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6316) | MIKI | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:65) | Jolteon 24 | Keep |
| [FUYU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6322) | FUYU | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:76) | Glaceon 24 | Keep |
| [HANA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6328) | HANA | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:87) | Leafeon 24 | Keep |
| [YUMI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6334) | YUMI | Dance Theatre; [DanceTheatre](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:98) | Sylveon 24 | Keep |

## Twins — 10 parties

Generalist paired partners; Bug/Grass/Dragon Gym and Den themes respected.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [AMYANDMAY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6343) | AMY & MAY | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:87) | Pineco 15, Spinarak 15 | Keep |
| [ANNANDANNE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6351) | ANN & ANNE | Route 37; [Route37](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route37.asm:27) | Ledian 25, Furret 25 | Keep |
| [ANNANDANNE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6361) | ANN & ANNE | Route 37; [Route37](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route37.asm:38) | Kotora 25, Granbull 25 | Keep |
| [AMYANDMAY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6371) | AMY & MAY | Azalea Gym; [AzaleaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:98) | Paras 15, Pineco 15 | Keep |
| [JOANDZOE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6379) | JO & ZOE | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:86) | Jumpluff 61, Parasect 61 | Keep; [Fifth-pass moves](trainer-theme-fixes-round5.md) |
| [JOANDZOE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6389) | JO & ZOE | Celadon Gym; [CeladonGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:97) | Victreebel 61, Exeggutor 61 | Keep |
| [MEGANDPEG1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6399) | MEG & PEG | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:153) | Lopunny 59, Zangoose 59 | Keep |
| [MEGANDPEG2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6409) | MEG & PEG | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:164) | Furret 59, Porygon2 59 | Keep |
| [LEAANDPIA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6419) | LEA & PIA | Dragon's Den B1F; [DragonsDenB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:109) | Dudunsparce 46, Appletun 46, Ampharos 47, Kingdra 47 | Keep |
| [LEAANDPIA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6435) | LEA & PIA | Dragon's Den B1F (rematch); no direct map ref | Ampharos 55, Alolan Exeggutor 55, Kingdra 56, Dudunsparce 56 | Keep |

## Pokéfan F — 6 parties

Broad beloved companions/babies; named Snubbull line retained.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BEVERLY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6454) | BEVERLY | National Park; [NationalPark](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:204) | Snubbull 22 | Keep |
| [RUTH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6460) | RUTH | Route 39; [Route39](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39.asm:106) | Elekid 28 | Keep |
| [BEVERLY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6466) | BEVERLY | National Park (rematch); no direct map ref | Granbull 43 | Keep |
| [BEVERLY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6472) | BEVERLY | National Park (rematch); no direct map ref | Granbull 56 | Keep |
| [GEORGIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6478) | GEORGIA | Fast Ship Cabins / SE / SSE / Captain's Cabin; [FastShipCabins_SE_SSE_CaptainsCabin](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:197) | Zangoose 57, Fearow 57, Miltank 57, Porygon2 57, Snorlax 59 | Keep |
| [JAIME](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6497) | JAIME | Route 39; [Route39](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39.asm:149) | Fletchinder 25, Meowth 25 | Keep |

## Red — 1 parties

Individual generalist with recognizable signature companions/starters.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6508) | (unnamed) | Silver Cave Room 3; [SilverCaveRoom3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveRoom3.asm:17) | Pikachu 88, Espeon 89, Snorlax 89, Venusaur 90, Charizard 90, Blastoise 90 | Keep |

## Blue — 1 parties

Individual generalist/varied champion-level team.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6545) | (unnamed) | Viridian Gym; [ViridianGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:42) | Pidgeot 66, Rhyperior 67, Gyarados 67, Arcanine 68, Scizor 68, Electivire 69 | Keep |

## Officer — 3 parties

Patrol dogs, night watcher and disciplined fighter/detector.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KEITH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6582) | KEITH | Route 34; [Route34](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:369) | Growlithe 20 | Keep |
| [DIRK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6588) | DIRK | Route 35; [Route35](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:252) | Growlithe 21, Noctowl 21 | Keep |
| [CELADON_HAYES](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6596) | HAYES | Celadon City; [CeladonCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonCity.asm:134) | Arcanine 66, Granbull 66, Noctowl 67, Lucario 68 | Keep |

## Mystical Man — 2 parties

Hypnosis, spiritual pursuit and Eusine's individual established mixed team.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6624) | EUSINE | Cianwood City; [CianwoodCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:76) | Hypno 33, Haunter 33, Electrode 34 | Keep |
| [EUSINE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6643) | EUSINE | Ecruteak City; [EcruteakCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakCity.asm:55) | Hypno 38, Gengar 38, Electrode 39, Noctowl 39, Espeon 40 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Proton — 2 parties

Cruel/mischievous, sharp-clawed enforcers; no strict poison mandate.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [PROTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6665) | PROTON | Slowpoke Well B1F; [SlowpokeWellB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm:32) | Impidimp 10, Galarian Meowth 11, Hisuian Sneasel 13 | Keep |
| [PROTON2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6684) | PROTON | Radio Tower 4F; [RadioTower4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower4F.asm:68) | Grimmsnarl 40, Perrserker 40, Zangoose 41, Sneasler 42 | Keep |

## Petrel — 1 parties

Disguise/impersonation plus artificial and sinister partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [PETREL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6711) | PETREL | Team Rocket Base B3F; [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:110) | Alolan Grimer 35, Porygon2 36, Banette 36, Ditto 36 | Keep |

## Ariana — 2 parties

Sinister elegance, seduction, poison and intimidation; Milotic/Octillery accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6741) | ARIANA | Team Rocket Base B2F; [TeamRocketBaseB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB2F.asm:98) | Murkrow 35, Salazzle 35, Milotic 36, Weavile 36 | Keep |
| [ARIANA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6765) | ARIANA | Radio Tower 5F; [RadioTower5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:81) | Honchkrow 42, Salazzle 42, Milotic 43, Toxapex 43, Weavile 43 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Archer — 2 parties

Intimidating executive team with signature Houndoom.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6797) | ARCHER | Radio Tower 5F (rematch); no direct map ref | Crobat 43, Dusknoir 44, Kingambit 44, Krookodile 44, Houndoom 44 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [ARCHER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6826) | ARCHER | Radio Tower 5F; [RadioTower5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:101) | Crobat 41, Dusknoir 41, Kingambit 42, Krookodile 42, Houndoom 43 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Petrel Director — 1 parties

Disguise/impersonation plus artificial and sinister partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [PETREL_DIRECTOR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6858) | PETREL | Radio Tower 5F; [RadioTower5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:52) | Alolan Muk 40, Porygon-Z 40, Banette 41, Ditto 42 | Keep |

## Hex Maniac — 3 parties

Ghost/spooky specialist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [WINNIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6885) | WINNIE | Burned Tower 1F; [BurnedTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTower1F.asm:128) | Shuppet 22, Duskull 23, Gastly 23, Misdreavus 24 | Keep |
| [ODESSA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6901) | ODESSA | Silent Crypt; [SilentCrypt](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilentCrypt.asm:17) | Duskull 21, Shuppet 22, Drifloon 22 | Keep |
| [LILITH](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6914) | LILITH | Silent Crypt; [SilentCrypt](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilentCrypt.asm:28) | Gastly 21, Shuppet 21, Misdreavus 23 | Keep |

## Cosplayer — 6 parties

Disguise, costume, mimicry, performance or a stated costume partner/reference.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [COSPLAYER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6930) | MAYA | Route 3, Route 4 (rematch); no direct map ref | Mr. Rime 69, Mimikyu 69, Ditto 70 | [Resolved 27](trainer-theme-fixes.md#finding-27) |
| [COSPLAYER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6949) | DAISY | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:59) | Ditto 51, Mimikyu 51 | Keep |
| [COSPLAYER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6959) | MIMI | Route 3; [Route3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:70) | Mimikyu 51, Mr. Rime 51 | [Resolved 6](trainer-theme-fixes.md#finding-6) |
| [COSPLAYER4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6969) | PEARL | Route 4; [Route4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:132) | Clefable 51, Mimikyu 52 | Keep |
| [COSPLAYER5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6979) | PIXIE | Route 4; [Route4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:143) | Smeargle 51, Sylveon 51 | [Resolved 7](trainer-theme-fixes.md#finding-7) |
| [COSPLAYER6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6989) | NOELLE | Route 25 (Nugget Bridge 1); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:423) | Smeargle 51, Alolan Raichu 52, Glaceon 52 | [Resolved 8](trainer-theme-fixes.md#finding-8) |

## Ninja — 4 parties

Poison, stealth and ninja-style partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [NINJA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7005) | KANE | Fuchsia Gym; [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:76) | Arbok 60, Golbat 61, Tentacruel 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [NINJA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7018) | SHIRO | Fuchsia Gym; [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:110) | Vileplume 61, Golbat 61, Alolan Muk 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [NINJA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7031) | KAEDE | Fuchsia Gym; [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:144) | Nidoqueen 59, Muk 60, Crobat 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [NINJA4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7044) | RYU | Fuchsia Gym; [FuchsiaGym](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FuchsiaGym.asm:178) | Venomoth 59, Muk 60, Seviper 61 | Keep |

## Agatha — 1 parties

Ghost/Poison sinister classic character identity; snakes and bats accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [AGATHA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7060) | AGATHA | Silver Cave Outside; [SilverCaveOutside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:34) | Gengar 85, Misdreavus 86, Arbok 86, Crobat 87, Haunter 87, Gengar 87 | Keep |

## Lorelei — 1 parties

Ice/cold-water identity, including classic Slowbro.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7097) | LORELEI | Silver Cave Outside; [SilverCaveOutside](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:70) | Dewgong 85, Cloyster 86, Slowbro 86, Mesmeria 87, Lapras 87, Glaceon 87 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Red2 — 1 parties

Individual generalist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [RED2_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7134) | (unnamed) | Pallet Town; [PalletTown](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PalletTown.asm:43) | Pikachu 83, Snorlax 84, Espeon 84, Lapras 85, Aerodactyl 85, Charizard 85 | Keep |

## Blue Cloak — 1 parties

Individual generalist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BLUE_CLOAK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7171) | (unnamed) | Cinnabar Island; [CinnabarIsland](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CinnabarIsland.asm:57) | Pidgeot 82, Scizor 83, Rhyperior 83, Exeggutor 84, Electivire 84, Blastoise 84 | Keep |

## Green — 1 parties

Individual generalist.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7208) | (unnamed) | Route 20; [Route20](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:54) | Wigglytuff 80, Umbreon 81, Nidoqueen 81, Mesmeria 82, Lanturn 82, Venusaur 82 | Keep |

## Battle Girl — 4 parties

Fighting specialist, including locally Electric/Fighting Electivire.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [BATTLE_GIRL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7245) | MIHO | Route 7; [Route7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route7.asm:11) | Sneasler 56, Annihilape 59, Hitmontop 60 | Keep |
| [BATTLE_GIRL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7258) | AYA | Route 7; [Route7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route7.asm:22) | Hitmonlee 61, Electivire 61, Lucario 61 | Keep |
| [KIRA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7271) | KIRA | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:122) | Hitmonlee 68, Breloom 69, Lucario 70 | Keep |
| [MINA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7287) | MINA | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:129) | Heracross 68, Toxicroak 69, Hitmontop 70 | Keep |

## Tamer — 5 parties

Fierce/unruly/large or ancient beasts, according to individual dialogue.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [TAMER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7306) | COLE | Route 18; [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:36) | Tyranitar 60, Snorlax 60, Dragonite 60 | Keep |
| [TAMER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7319) | JAX | Route 18; [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:47) | Tauros 59, Tauros Paldean Fire 60, Tauros Paldean Water 60 | Keep |
| [TAMER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7332) | RIGBY | Route 18; [Route18](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm:58) | Tauros 59, Kleavor 60, Persian 61 | Keep; [Fourth-pass moves](trainer-theme-fixes-round4.md) |
| [DEVIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7345) | DEVIN | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:108) | Arcanine 68, Ursaluna 69, Gyarados 70 | Keep |
| [ROLF](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7361) | ROLF | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:115) | Rhyperior 68, Nidoking 69, Aerodactyl 70 | Keep |

## Team Rocket Grunt F — 16 parties

Criminal, poison, dark, sinister or rough physical partners; no strict type requirement.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [GRUNTF_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7382) | GRUNT | Slowpoke Well B1F; [SlowpokeWellB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm:86) | Zubat 13, Ekans 15 | Keep |
| [GRUNTF_2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7390) | GRUNT | Radio Tower 2F; [RadioTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower2F.asm:90) | Alolan Persian 41, Seviper 41 | Keep |
| [GRUNTF_3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7398) | GRUNT | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:267) | Alolan Raticate 38, Golbat 38, Seviper 38, Houndoom 39 | Keep |
| [GRUNTF_4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7410) | GRUNT | Radio Tower 4F; [RadioTower4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower4F.asm:79) | Galarian Weezing 39, Murkrow 40, Nidorina 40, Persian 40 | Keep |
| [GRUNTF_5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7422) | GRUNT | Team Rocket Base B3F; [TeamRocketBaseB3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:134) | Qwilfish 36, Misdreavus 36 | Keep |
| [GRUNTF_6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7429) | GRUNT | Radio Tower 1F; [RadioTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower1F.asm:187) | Salazzle 40, Scolipede 40, Ariados 40 | Keep |
| [GRUNTF_7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7439) | GRUNT | Radio Tower 2F; [RadioTower2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower2F.asm:68) | Gengar 40, Overqwil 40, Arbok 40 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [GRUNTF_8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7452) | GRUNT | Radio Tower 3F; [RadioTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower3F.asm:95) | Gengar 38, Weezing 38 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [GRUNTF_9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7462) | GRUNT | Radio Tower 3F; [RadioTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower3F.asm:106) | Ariados 39, Gengar 39 | Keep; [Third-pass fixes](trainer-theme-fixes-round3.md) |
| [GRUNTF_10](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7472) | GRUNT | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:212) | Scrafty 39, Salazzle 40 | Keep |
| [GRUNTF_11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7480) | GRUNT | Team Rocket Base B1F; [TeamRocketBaseB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB1F.asm:493) | Weepinbell 37 | Keep |
| [GRUNTF_12](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7486) | GRUNT | Team Rocket Base B2F; [TeamRocketBaseB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB2F.asm:190) | Misdreavus 36 | Keep |
| [GRUNTF_13](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7492) | GRUNT | Team Rocket Base B2F; [TeamRocketBaseB2F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB2F.asm:212) | Seviper 38 | Keep |
| [GRUNTF_14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7498) | GRUNT | Goldenrod Underground Warehouse; [GoldenrodUndergroundWarehouse](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundWarehouse.asm:37) | Overqwil 40 | Keep |
| [GRUNTF_15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7504) | GRUNT | Slowpoke Well B1F; [SlowpokeWellB1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm:21) | Mareanie 13, Kakuna 13 | Keep |
| [GRUNTF_GOLDENROD_RIOLU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7512) | GRUNT | Goldenrod Underground; [GoldenrodUnderground](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:486) | Croagunk 21, Grimer 21 | Keep |

## Rival — Main Story — 15 parties

Individual mixed rival team, preserving each starter branch and evolution progression.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [RIVAL1_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7528) | ? | Cherrygrove City; [CherrygroveCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CherrygroveCity.asm:150) | Chikorita 5 | Keep |
| [RIVAL1_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7537) | ? | Cherrygrove City; [CherrygroveCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CherrygroveCity.asm:161) | Cyndaquil 5 | Keep |
| [RIVAL1_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7546) | ? | Cherrygrove City; [CherrygroveCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CherrygroveCity.asm:139) | Totodile 5 | Keep |
| [RIVAL1_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7555) | ? | Azalea Town; [AzaleaTown](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaTown.asm:82) | Zubat 14, Magnemite 15, Bayleef 16 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7574) | ? | Azalea Town; [AzaleaTown](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaTown.asm:91) | Zubat 14, Magnemite 15, Quilava 16 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7593) | ? | Azalea Town; [AzaleaTown](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaTown.asm:73) | Zubat 14, Magnemite 15, Croconaw 16 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_3_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7612) | ? | Burned Tower 1F; [BurnedTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTower1F.asm:83) | Golbat 22, Magnemite 22, Slowpoke 23, Bayleef 24 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_3_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7636) | ? | Burned Tower 1F; [BurnedTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTower1F.asm:92) | Golbat 22, Magnemite 22, Slowpoke 23, Quilava 24 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_3_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7660) | ? | Burned Tower 1F; [BurnedTower1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTower1F.asm:74) | Golbat 22, Magnemite 22, Galarian Slowpoke 23, Croconaw 24 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7684) | ? | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:188) | Golbat 40, Magnezone 41, Slowking 41, Weavile 41, Ceruledge 41, Meganium 42 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7718) | ? | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:197) | Golbat 40, Magnezone 41, Slowking 41, Weavile 41, Gengar 41, Typhlosion 42 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7752) | ? | Goldenrod Underground Switch Room Entrances; [GoldenrodUndergroundSwitchRoomEntrances](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:179) | Golbat 40, Magnezone 41, Galarian Slowking 41, Weavile 41, Ceruledge 41, Feraligatr 42 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7786) | ? | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:84) | Golbat 68, Magnezone 69, Slowking 69, Weavile 69, Ceruledge 69, Meganium 71 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7820) | ? | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:93) | Golbat 68, Magnezone 69, Slowking 69, Weavile 69, Gengar 69, Typhlosion 71 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL1_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7854) | ? | Victory Road; [VictoryRoad](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:75) | Golbat 68, Magnezone 69, Galarian Slowking 69, Weavile 69, Ceruledge 69, Feraligatr 71 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Rival — Postgame — 6 parties

Individual mixed rival team, preserving each starter branch and evolution progression.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [RIVAL2_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7891) | ? | Mount Moon; [MountMoon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMoon.asm:48) | Golbat 49, Magnezone 50, Slowking 51, Weavile 51, Ceruledge 51, Meganium 53 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL2_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7925) | ? | Mount Moon; [MountMoon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMoon.asm:57) | Golbat 49, Magnezone 50, Slowking 51, Weavile 51, Gengar 51, Typhlosion 53 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL2_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7959) | ? | Mount Moon; [MountMoon](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMoon.asm:39) | Golbat 49, Magnezone 50, Galarian Slowking 51, Weavile 51, Ceruledge 51, Feraligatr 53 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL2_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7993) | ? | Indigo Plateau Pokémon Center 1F; [IndigoPlateauPokecenter1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:107) | Crobat 82, Magnezone 83, Slowking 83, Weavile 83, Ceruledge 83, Meganium 85 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL2_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8027) | ? | Indigo Plateau Pokémon Center 1F; [IndigoPlateauPokecenter1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:116) | Crobat 82, Magnezone 83, Slowking 83, Weavile 83, Gengar 83, Typhlosion 85 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [RIVAL2_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8061) | ? | Indigo Plateau Pokémon Center 1F; [IndigoPlateauPokecenter1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:98) | Crobat 82, Magnezone 83, Galarian Slowking 83, Weavile 83, Ceruledge 83, Feraligatr 85 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Crystal — 15 parties

Collector/generalist with evolving and changing partners, across all starter branches.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CRYSTAL_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8100) | CRYSTAL | Violet City; [VioletCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletCity.asm:74) | Chikorita 10, Natu 10 | Keep |
| [CRYSTAL_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8114) | CRYSTAL | Violet City; [VioletCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletCity.asm:78) | Cyndaquil 10, Natu 10 | Keep |
| [CRYSTAL_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8128) | CRYSTAL | Violet City; [VioletCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletCity.asm:82) | Totodile 10, Natu 10 | Keep |
| [CRYSTAL_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8142) | CRYSTAL | Ilex Forest; [IlexForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:421) | Natu 16, Applin 17, Cubone 17, Bayleef 20 | Keep |
| [CRYSTAL_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8166) | CRYSTAL | Ilex Forest; [IlexForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:425) | Natu 16, Applin 17, Cubone 17, Quilava 20 | Keep |
| [CRYSTAL_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8190) | CRYSTAL | Ilex Forest; [IlexForest](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:429) | Natu 16, Applin 17, Cubone 17, Croconaw 20 | Keep |
| [CRYSTAL_3_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8214) | CRYSTAL | Cianwood City; [CianwoodCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:133) | Xatu 30, Marowak 32, Dipplin 31, Bayleef 32 | Keep |
| [CRYSTAL_3_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8238) | CRYSTAL | Cianwood City; [CianwoodCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:137) | Xatu 30, Marowak 32, Dipplin 31, Quilava 32 | Keep |
| [CRYSTAL_3_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8262) | CRYSTAL | Cianwood City; [CianwoodCity](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:141) | Xatu 30, Marowak 32, Dipplin 31, Feraligatr 32 | Keep |
| [CRYSTAL_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8286) | CRYSTAL | Ice Path 1F; [IcePath1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:52) | Xatu 41, Marowak 42, Hydrapple 42, Pupitar 42, Meganium 44 | Keep |
| [CRYSTAL_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8315) | CRYSTAL | Ice Path 1F; [IcePath1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:56) | Xatu 41, Marowak 42, Flapple 42, Pupitar 42, Typhlosion 44 | Keep |
| [CRYSTAL_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8344) | CRYSTAL | Ice Path 1F; [IcePath1F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:60) | Xatu 41, Marowak 42, Appletun 42, Pupitar 42, Feraligatr 44 | Keep |
| [CRYSTAL_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8373) | CRYSTAL | Route 25 (Cerulean Cape); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:255) | Meganium 70, Hydrapple 68, Tyranitar 69, Marowak 69, Xatu 68, Lanturn 68 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [CRYSTAL_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8407) | CRYSTAL | Route 25 (Cerulean Cape); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:259) | Typhlosion 70, Flapple 68, Tyranitar 69, Marowak 69, Xatu 68, Lanturn 68 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |
| [CRYSTAL_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8441) | CRYSTAL | Route 25 (Cerulean Cape); [Route25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:263) | Feraligatr 70, Appletun 68, Tyranitar 69, Marowak 69, Xatu 68, Volcarona 68 | Keep; [Second-pass mon changes](trainer-theme-fixes-round2.md) |

## Elder — 1 parties

Sprout Tower plant/meditation identity.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [LI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8478) | LI | Sprout Tower 3F; [SproutTower3F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SproutTower3F.asm:73) | Hoppip 7, Exeggcute 8, Weepinbell 9 | Keep |

## Aroma Lady — 3 parties

Plants, flowers, gardening and herbs; foliage/tree partners accepted.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [ROSIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8500) | ROSIE | Olivine Lighthouse 5F; [OlivineLighthouse5F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse5F.asm:37) | Ivysaur 31, Bayleef 32, Sunflora 33, Bellossom 34 | Keep |
| [DAHLIA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8512) | DAHLIA | Olivine Lighthouse 4F; [OlivineLighthouse4F](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse4F.asm:34) | Tangela 32, Jumpluff 33, Alolan Exeggutor 34 | Keep |
| [JUNIPER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8522) | JUNIPER | Route 38; [Route38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:28) | Skiploom 26, Gloom 27, Steenee 27, Weepinbell 28 | Keep |

## Biker — 9 parties

Exhaust, fire, poison, intimidation or road power; individual speed claims checked.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [DWAYNE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8540) | DWAYNE | Route 8; [Route8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route8.asm:15) | Toxicroak 59, Umbreon 60, Chandelure 61, Arcanine 61 | Keep |
| [HARRIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8556) | HARRIS | Route 8; [Route8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route8.asm:26) | Flareon 57, Golem 60 | Keep |
| [ZEKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8566) | ZEKE | Route 8; [Route8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route8.asm:37) | Golbat 56, Magmortar 59 | Keep |
| [CHARLES](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8576) | CHARLES | Route 17; [Route17](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:19) | Galarian Weezing 60, Magmar 60, Ceruledge 60 | [Resolved 26](trainer-theme-fixes.md#finding-26) |
| [RILEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8589) | RILEY | Route 17; [Route17](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:30) | Weezing 60, Houndoom 61 | Keep |
| [JOEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8599) | JOEL | Route 17; [Route17](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:41) | Rapidash 60, Ariados 60 | Keep |
| [GLENN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8609) | GLENN | Route 17; [Route17](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:52) | Crobat 59, Arcanine 60, Electrode 60 | [Resolved 5](trainer-theme-fixes.md#finding-5) |
| [ROUTE16_AXLE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8622) | AXLE | Route 16; [Route16](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route16.asm:28) | Weezing 60, Houndoom 61, Crobat 61, Alolan Golem 62 | Keep |
| [ROUTE16_RUSTY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8646) | RUSTY | Route 16; [Route16](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route16.asm:34) | Arbok 60, Magmortar 61, Muk 61, Scrafty 62 | Keep |

## Cueball — 1 parties

Bike-gang boss with poison, dark, muscle and intimidating partners.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [CHOPPER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8673) | CHOPPER | Route 16; [Route16](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route16.asm:40) | Weezing 64, Arbok 64, Houndoom 65, Krookodile 65, Alolan Muk 66, Machamp 67 | Keep |

## Karate King — 1 parties

Fighting dojo master.

| Party / source | Trainer | Location/comment | Full roster (species level) | Review |
|---|---|---|---|---|
| [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8710) | KIYO | Fighting Dojo; [FightingDojo](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FightingDojo.asm:32) | Sirfetch'd 67, Sneasler 67, Breloom 68, Scrafty 68, Hitmontop 70 | Keep |

## All 70 Battle Tower identities

All use the shared room-based random generator. No fixed personal roster can be assigned. “Class theme possible” means off-theme generated combinations are possible, not that a particular battle has been observed.

| # | Identity | Class | Review |
|---|---|---|---|
| 1 | HANSON | Fisher | Class-theme mismatch possible; see shared-pool discussion |
| 2 | SAWYER | Pokémaniac | Broad class; mixed pool is defensible |
| 3 | MASUDA | Guitarist | Class-theme mismatch possible; see shared-pool discussion |
| 4 | NICKEL | Scientist | Broad class; mixed pool is defensible |
| 5 | OLSON | Pokéfan M | Broad class; mixed pool is defensible |
| 6 | ZABOROWSKI | Lass | Broad class; mixed pool is defensible |
| 7 | WRIGHT | Youngster | Broad class; mixed pool is defensible |
| 8 | ALEXANDER | Hiker | Class-theme mismatch possible; see shared-pool discussion |
| 9 | KAWAKAMI | Teacher | Broad class; mixed pool is defensible |
| 10 | BICKETT | Pokéfan M | Broad class; mixed pool is defensible |
| 11 | SAITO | Kimono Girl | Class-theme mismatch possible; see shared-pool discussion |
| 12 | CRAWFORD | Boarder | Class-theme mismatch possible; see shared-pool discussion |
| 13 | DIAZ | Picnicker | Broad class; mixed pool is defensible |
| 14 | ERICKSON | Biker | Broad class; mixed pool is defensible |
| 15 | FAIRFIELD | Juggler | Class-theme mismatch possible; see shared-pool discussion |
| 16 | HUNTER | Pokéfan F | Broad class; mixed pool is defensible |
| 17 | HILL | Firebreather | Class-theme mismatch possible; see shared-pool discussion |
| 18 | JAVIER | Swimmer F | Class-theme mismatch possible; see shared-pool discussion |
| 19 | KAUFMAN | Swimmer M | Class-theme mismatch possible; see shared-pool discussion |
| 20 | LANCASTER | Skier | Class-theme mismatch possible; see shared-pool discussion |
| 21 | McMAHILL | Camper | Broad class; mixed pool is defensible |
| 22 | OBRIEN | Gentleman | Broad class; mixed pool is defensible |
| 23 | FROST | Beauty | Broad class; mixed pool is defensible |
| 24 | MORSE | Super Nerd | Broad class; mixed pool is defensible |
| 25 | YUFUNE | Blackbelt | Class-theme mismatch possible; see shared-pool discussion |
| 26 | RAJAN | Cooltrainer F | Broad class; mixed pool is defensible |
| 27 | RODRIGUEZ | Officer | Broad class; mixed pool is defensible |
| 28 | SANTIAGO | Psychic | Class-theme mismatch possible; see shared-pool discussion |
| 29 | STOCK | Pokéfan M | Broad class; mixed pool is defensible |
| 30 | THURMAN | Scientist | Broad class; mixed pool is defensible |
| 31 | VALENTINO | Beauty | Broad class; mixed pool is defensible |
| 32 | WAGNER | Camper | Broad class; mixed pool is defensible |
| 33 | YATES | Bird Keeper | Class-theme mismatch possible; see shared-pool discussion |
| 34 | ANDREWS | Picnicker | Broad class; mixed pool is defensible |
| 35 | BAHN | Pokémaniac | Broad class; mixed pool is defensible |
| 36 | MORI | Scientist | Broad class; mixed pool is defensible |
| 37 | BUCKMAN | Sage | Broad class; mixed pool is defensible |
| 38 | COBB | Schoolboy | Broad class; mixed pool is defensible |
| 39 | HUGHES | Fisher | Class-theme mismatch possible; see shared-pool discussion |
| 40 | ARITA | Kimono Girl | Class-theme mismatch possible; see shared-pool discussion |
| 41 | EASTON | Psychic | Class-theme mismatch possible; see shared-pool discussion |
| 42 | FREEMAN | Camper | Broad class; mixed pool is defensible |
| 43 | GIESE | Lass | Broad class; mixed pool is defensible |
| 44 | HATCHER | Gentleman | Broad class; mixed pool is defensible |
| 45 | JACKSON | Pokéfan F | Broad class; mixed pool is defensible |
| 46 | KAHN | Pokémaniac | Broad class; mixed pool is defensible |
| 47 | LEONG | Youngster | Broad class; mixed pool is defensible |
| 48 | MARINO | Teacher | Broad class; mixed pool is defensible |
| 49 | NEWMAN | Sailor | Class-theme mismatch possible; see shared-pool discussion |
| 50 | NGUYEN | Blackbelt | Class-theme mismatch possible; see shared-pool discussion |
| 51 | OGDEN | Super Nerd | Broad class; mixed pool is defensible |
| 52 | PARK | Cooltrainer F | Broad class; mixed pool is defensible |
| 53 | RAINE | Swimmer M | Class-theme mismatch possible; see shared-pool discussion |
| 54 | SELLS | Bird Keeper | Class-theme mismatch possible; see shared-pool discussion |
| 55 | ROCKWELL | Boarder | Class-theme mismatch possible; see shared-pool discussion |
| 56 | THORNTON | Lass | Broad class; mixed pool is defensible |
| 57 | TURNER | Officer | Broad class; mixed pool is defensible |
| 58 | VAN DYKE | Skier | Class-theme mismatch possible; see shared-pool discussion |
| 59 | WALKER | Schoolboy | Broad class; mixed pool is defensible |
| 60 | MEYER | Swimmer F | Class-theme mismatch possible; see shared-pool discussion |
| 61 | JOHNSON | Youngster | Broad class; mixed pool is defensible |
| 62 | ADAMS | Guitarist | Class-theme mismatch possible; see shared-pool discussion |
| 63 | SMITH | Bug Catcher | Class-theme mismatch possible; see shared-pool discussion |
| 64 | TAJIRI | Bug Catcher | Class-theme mismatch possible; see shared-pool discussion |
| 65 | BAKER | Pokémaniac | Broad class; mixed pool is defensible |
| 66 | COLLINS | Scientist | Broad class; mixed pool is defensible |
| 67 | SMART | Super Nerd | Broad class; mixed pool is defensible |
| 68 | DYKSTRA | Swimmer F | Class-theme mismatch possible; see shared-pool discussion |
| 69 | EATON | Biker | Broad class; mixed pool is defensible |
| 70 | WONG | Firebreather | Class-theme mismatch possible; see shared-pool discussion |

**No missing fixed groups:** every populated party group has a review rubric above. Empty groups have no roster to review. The 70 Tower names are additional identities, not additional fixed parties.
