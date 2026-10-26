# Boss teams and combat context

All values are extracted from this source snapshot. “Cap” follows the declared itinerary; alternate gym orders use badge count, not leader identity. Raw predicates below are the script’s checks, including non-battle gift/retry branches; they are evidence to inspect, not a generated logical conjunction.

## Bugsy

Map `AzaleaGym`; class `BUGSY`; party `Bugsy:1`; ace 16; itinerary cap 16. [maps/AzaleaGym.asm:24](../../../maps/AzaleaGym.asm#L24).

Falkner and aide egg; Union Cave; well clearance for gym


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| PINECO | 14 | 58 | 232 | 50/65/90/15/35/35 | 290 | NO_ITEM | STURDY | BULLDOZE, BUG_BITE, SPIKES, REFLECT | 6400 |
| JOLTIK | 15 | 64 | 274 | 50/47/50/65/57/50 | 319 | NO_ITEM | COMPOUND_EYES | THUNDERSHOCK, STRUGGLE_BUG, THUNDER_WAVE, AGILITY | 6400 |
| SCYTHER | 16 | 100 | 456 | 70/110/80/105/55/80 | 500 | BERRY_JUICE | TECHNICIAN | FURY_CUTTER, QUICK_ATTACK, PURSUIT, WING_ATTACK | 6400 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_BUGSY` — [maps/AzaleaGym.asm:18](../../../maps/AzaleaGym.asm#L18)
- `readvar VAR_BADGES` — [maps/AzaleaGym.asm:33](../../../maps/AzaleaGym.asm#L33)
- `checkevent EVENT_GOT_TM49_FURY_CUTTER` — [maps/AzaleaGym.asm:36](../../../maps/AzaleaGym.asm#L36)
- `checkevent EVENT_BEAT_BUGSY_REMATCH` — [maps/AzaleaGym.asm:53](../../../maps/AzaleaGym.asm#L53)
- `checkevent EVENT_BEAT_FALKNER_REMATCH` — [maps/AzaleaGym.asm:55](../../../maps/AzaleaGym.asm#L55)

## Bugsy rematch

Map `AzaleaGym`; class `BUGSY_REMATCH`; party `Bugsy:2`; ace 78; itinerary cap 100. [maps/AzaleaGym.asm:62](../../../maps/AzaleaGym.asm#L62).

Falkner and aide egg; Union Cave; well clearance for gym


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| FORRETRESS | 76 | 163 | 3538 | 75/90/140/40/60/60 | 465 | LEFTOVERS | STURDY | STEALTH_ROCK, SPIKES, GYRO_BALL, BODY_PRESS | 43264 |
| VIKAVOLT | 76 | 225 | 4884 | 77/70/90/43/145/75 | 500 | WISE_GLASSES | LEVITATE | BUG_BUZZ, THUNDERBOLT, FLASH_CANNON, AGILITY | 43264 |
| HERACROSS | 77 | 175 | 3850 | 80/125/75/85/40/95 | 500 | LIFE_ORB | SKILL_LINK | PIN_MISSILE, ROCK_BLAST, CLOSE_COMBAT, KNOCK_OFF | 43264 |
| GOLISOPOD | 77 | 186 | 4092 | 75/125/140/40/60/90 | 530 | ASSAULT_VEST | BATTLE_ARMOR | FIRST_IMPRESSION, LIQUIDATION, SUCKER_PUNCH, KNOCK_OFF | 43264 |
| VOLCARONA | 78 | 248 | 5526 | 85/60/65/100/135/105 | 550 | LEFTOVERS | FLAME_BODY | QUIVER_DANCE, BUG_BUZZ, FIERY_DANCE, HURRICANE | 43264 |
| SCIZOR | 78 | 175 | 3900 | 70/130/100/65/55/80 | 500 | LIFE_ORB | TECHNICIAN | SWORDS_DANCE, BULLET_PUNCH, BUG_BITE, KNOCK_OFF | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_BUGSY` — [maps/AzaleaGym.asm:18](../../../maps/AzaleaGym.asm#L18)
- `readvar VAR_BADGES` — [maps/AzaleaGym.asm:33](../../../maps/AzaleaGym.asm#L33)
- `checkevent EVENT_GOT_TM49_FURY_CUTTER` — [maps/AzaleaGym.asm:36](../../../maps/AzaleaGym.asm#L36)
- `checkevent EVENT_BEAT_BUGSY_REMATCH` — [maps/AzaleaGym.asm:53](../../../maps/AzaleaGym.asm#L53)
- `checkevent EVENT_BEAT_FALKNER_REMATCH` — [maps/AzaleaGym.asm:55](../../../maps/AzaleaGym.asm#L55)

## ? (AzaleaTown)

Map `AzaleaTown`; class `RIVAL1`; party `Rival1:6`; ace 16; itinerary cap 20. [maps/AzaleaTown.asm:84](../../../maps/AzaleaTown.asm#L84).

Falkner and aide egg; Union Cave; well clearance for gym


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| ZUBAT | 14 | 49 | 196 | 40/45/35/55/30/40 | 245 | NO_ITEM | INNER_FOCUS | WING_ATTACK, BITE, ASTONISH, SUPERSONIC | 26896 |
| MAGNEMITE | 15 | 65 | 278 | 25/35/70/45/95/55 | 325 | NO_ITEM | LEVITATE | THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT | 26896 |
| CROCONAW | 16 | 142 | 648 | 65/80/80/58/59/63 | 405 | BERRY | SHEER_FORCE | WATER_GUN, BITE, RAGE, LEER | 26896 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/AzaleaTown.asm:74](../../../maps/AzaleaTown.asm#L74)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/AzaleaTown.asm:76](../../../maps/AzaleaTown.asm#L76)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/AzaleaTown.asm:78](../../../maps/AzaleaTown.asm#L78)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/AzaleaTown.asm:80](../../../maps/AzaleaTown.asm#L80)
- `setscene SCENE_AZALEATOWN_NOTHING` — [maps/AzaleaTown.asm:118](../../../maps/AzaleaTown.asm#L118)

## Clair

Map `BlackthornGym1F`; class `CLAIR`; party `Clair:1`; ace 45; itinerary cap 45. [maps/BlackthornGym1F.asm:40](../../../maps/BlackthornGym1F.asm#L40).

Blackthorn entrance NPC stays until Radio Tower is cleared; city itself can be reached earlier


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| DRAGONAIR | 42 | 147 | 1764 | 61/84/65/70/70/70 | 420 | NO_ITEM | MULTISCALE | DRAGON_PULSE, THUNDER_WAVE, ICE_BEAM, THUNDERBOLT | 18496 |
| NOIVERN | 43 | 187 | 2296 | 85/60/80/123/107/80 | 535 | NO_ITEM | WIND_RIDER | AIR_SLASH, DRAGON_PULSE, DARK_PULSE, AGILITY | 18496 |
| FLYGON | 43 | 255 | 3132 | 80/115/85/100/95/85 | 560 | NO_ITEM | TINTED_LENS | EARTHQUAKE, DRAGON_CLAW, ROCK_SLIDE, U_TURN | 18496 |
| ALTARIA | 44 | 172 | 2162 | 75/90/90/80/90/105 | 530 | NO_ITEM | NATURAL_CURE | DRAGON_CLAW, EARTHQUAKE, BODY_SLAM, DRAGON_DANCE | 18496 |
| TYRANTRUM | 44 | 182 | 2288 | 82/121/119/71/69/59 | 521 | NO_ITEM | STRONG_JAW | ROCK_SLIDE, CRUNCH, FIRE_FANG, DRAGON_CLAW | 18496 |
| KINGDRA | 45 | 255 | 3278 | 75/95/95/85/95/95 | 540 | SCOPE_LENS | SNIPER | SURF, DRAGON_PULSE, ICE_BEAM, AGILITY | 18496 |


Script predicates / event evidence:

- `checkflag ENGINE_RISINGBADGE` — [maps/BlackthornGym1F.asm:32](../../../maps/BlackthornGym1F.asm#L32)
- `checkevent EVENT_BEAT_CLAIR` — [maps/BlackthornGym1F.asm:34](../../../maps/BlackthornGym1F.asm#L34)
- `checkevent EVENT_GOT_TM24_DRAGON_CLAW` — [maps/BlackthornGym1F.asm:66](../../../maps/BlackthornGym1F.asm#L66)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/BlackthornGym1F.asm:89](../../../maps/BlackthornGym1F.asm#L89)
- `checkevent EVENT_BEAT_PRYCE_REMATCH` — [maps/BlackthornGym1F.asm:91](../../../maps/BlackthornGym1F.asm#L91)
- `checkevent EVENT_OPENED_MT_SILVER` — [maps/BlackthornGym1F.asm:102](../../../maps/BlackthornGym1F.asm#L102)
- `checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` — [maps/BlackthornGym1F.asm:104](../../../maps/BlackthornGym1F.asm#L104)
- `readvar VAR_BADGES` — [maps/BlackthornGym1F.asm:111](../../../maps/BlackthornGym1F.asm#L111)

## Clair rematch

Map `BlackthornGym1F`; class `CLAIR_REMATCH`; party `Clair:2`; ace 84; itinerary cap 100. [maps/BlackthornGym1F.asm:98](../../../maps/BlackthornGym1F.asm#L98).

Blackthorn entrance NPC stays until Radio Tower is cleared; city itself can be reached earlier


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| ALTARIA | 82 | 172 | 4028 | 75/90/90/80/90/105 | 530 | LEFTOVERS | NATURAL_CURE | DRAGON_PULSE, MOONBLAST, HEAT_WAVE, WILL_O_WISP | 44944 |
| NOIVERN | 82 | 187 | 4380 | 85/60/80/123/107/80 | 535 | LIFE_ORB | WIND_RIDER | HURRICANE, DRAGON_PULSE, HEAT_WAVE, ROOST | 44944 |
| ARCHALUDON | 83 | 255 | 6046 | 90/105/130/85/125/65 | 600 | LEFTOVERS | STAMINA | DRACO_METEOR, FLASH_CANNON, BODY_PRESS, DRAGON_TAIL | 44944 |
| HAXORUS | 83 | 243 | 5762 | 76/147/90/97/60/70 | 540 | LIFE_ORB | MOLD_BREAKER | DRAGON_DANCE, DRAGON_CLAW, IRON_HEAD, SUPERPOWER | 44944 |
| SALAMENCE | 84 | 255 | 6120 | 95/135/80/100/110/80 | 600 | LIFE_ORB | AERILATE | DRAGON_DANCE, DOUBLE_EDGE, DRAGON_CLAW, FIRE_FANG | 44944 |
| KINGDRA | 84 | 255 | 6120 | 75/95/95/85/95/95 | 540 | LIFE_ORB | SWIFT_SWIM | RAIN_DANCE, HYDRO_PUMP, DRACO_METEOR, ICE_BEAM | 44944 |


Script predicates / event evidence:

- `checkflag ENGINE_RISINGBADGE` — [maps/BlackthornGym1F.asm:32](../../../maps/BlackthornGym1F.asm#L32)
- `checkevent EVENT_BEAT_CLAIR` — [maps/BlackthornGym1F.asm:34](../../../maps/BlackthornGym1F.asm#L34)
- `checkevent EVENT_GOT_TM24_DRAGON_CLAW` — [maps/BlackthornGym1F.asm:66](../../../maps/BlackthornGym1F.asm#L66)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/BlackthornGym1F.asm:89](../../../maps/BlackthornGym1F.asm#L89)
- `checkevent EVENT_BEAT_PRYCE_REMATCH` — [maps/BlackthornGym1F.asm:91](../../../maps/BlackthornGym1F.asm#L91)
- `checkevent EVENT_OPENED_MT_SILVER` — [maps/BlackthornGym1F.asm:102](../../../maps/BlackthornGym1F.asm#L102)
- `checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` — [maps/BlackthornGym1F.asm:104](../../../maps/BlackthornGym1F.asm#L104)
- `readvar VAR_BADGES` — [maps/BlackthornGym1F.asm:111](../../../maps/BlackthornGym1F.asm#L111)

## Bruno

Map `BrunosRoom`; class `BRUNO`; party `Bruno:1`; ace 72; itinerary cap 100. [maps/BrunosRoom.asm:54](../../../maps/BrunosRoom.asm#L54).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CONKELDURR | 69 | 227 | 4474 | 105/140/95/45/55/65 | 505 | LEFTOVERS | IRON_FIST | DRAIN_PUNCH, MACH_PUNCH, THUNDERPUNCH, ICE_PUNCH | 24336 |
| HITMONTOP | 70 | 159 | 3180 | 70/95/95/80/35/110 | 485 | MUSCLE_BAND | TECHNICIAN | TRIPLE_KICK, MACH_PUNCH, PURSUIT, CLOSE_COMBAT | 24336 |
| LUCARIO | 70 | 184 | 3680 | 70/110/70/90/115/70 | 525 | LIFE_ORB | ADAPTABILITY | CLOSE_COMBAT, BULLET_PUNCH, EXTREMESPEED, SWORDS_DANCE | 24336 |
| TOXICROAK | 71 | 172 | 3488 | 83/106/65/98/86/65 | 503 | EXPERT_BELT | DRY_SKIN | POISON_JAB, DRAIN_PUNCH, SUCKER_PUNCH, ICE_PUNCH | 24336 |
| ANNIHILAPE | 71 | 255 | 5172 | 110/115/80/95/60/75 | 535 | LEFTOVERS | DEFIANT | RAGE_FIST, CLOSE_COMBAT, SHADOW_CLAW, BULK_UP | 24336 |
| MACHAMP | 72 | 253 | 5204 | 90/130/80/55/65/85 | 505 | BLACKBELT | NO_GUARD | DYNAMICPUNCH, CROSS_CHOP, ROCK_SLIDE, FIRE_PUNCH | 24336 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_BRUNO` — [maps/BrunosRoom.asm:46](../../../maps/BrunosRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/BrunosRoom.asm:52](../../../maps/BrunosRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/BrunosRoom.asm:67](../../../maps/BrunosRoom.asm#L67)

## Bruno rematch

Map `BrunosRoom`; class `BRUNO_REMATCH`; party `Bruno:2`; ace 86; itinerary cap 100. [maps/BrunosRoom.asm:57](../../../maps/BrunosRoom.asm#L57).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CONKELDURR | 84 | 227 | 5448 | 105/140/95/45/55/65 | 505 | FLAME_ORB | GUTS | FACADE, DRAIN_PUNCH, MACH_PUNCH, KNOCK_OFF | 46656 |
| HITMONTOP | 85 | 159 | 3860 | 70/95/95/80/35/110 | 485 | MUSCLE_BAND | TECHNICIAN | TRIPLE_KICK, CLOSE_COMBAT, MACH_PUNCH, SUCKER_PUNCH | 46656 |
| LUCARIO | 85 | 184 | 4468 | 70/110/70/90/115/70 | 525 | LIFE_ORB | ADAPTABILITY | SWORDS_DANCE, CLOSE_COMBAT, BULLET_PUNCH, EXTREMESPEED | 46656 |
| TOXICROAK | 86 | 172 | 4226 | 83/106/65/98/86/65 | 503 | LIFE_ORB | DRY_SKIN | SWORDS_DANCE, DRAIN_PUNCH, POISON_JAB, SUCKER_PUNCH | 46656 |
| ANNIHILAPE | 86 | 255 | 6264 | 110/115/80/95/60/75 | 535 | LEFTOVERS | DEFIANT | BULK_UP, RAGE_FIST, DRAIN_PUNCH, SHADOW_CLAW | 46656 |
| MACHAMP | 86 | 253 | 6216 | 90/130/80/55/65/85 | 505 | EXPERT_BELT | NO_GUARD | DYNAMICPUNCH, STONE_EDGE, ICE_PUNCH, KNOCK_OFF | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_BRUNO` — [maps/BrunosRoom.asm:46](../../../maps/BrunosRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/BrunosRoom.asm:52](../../../maps/BrunosRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/BrunosRoom.asm:67](../../../maps/BrunosRoom.asm#L67)

## ? (BurnedTower1F)

Map `BurnedTower1F`; class `RIVAL1`; party `Rival1:9`; ace 24; itinerary cap 25. [maps/BurnedTower1F.asm:74](../../../maps/BurnedTower1F.asm#L74).

Ecruteak; Silver and beast release unlock gym


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GOLBAT | 22 | 159 | 998 | 75/80/70/90/65/75 | 455 | NO_ITEM | INNER_FOCUS | WING_ATTACK, BITE, POISON_FANG, CONFUSE_RAY | 26896 |
| MAGNEMITE | 22 | 65 | 408 | 25/35/70/45/95/55 | 325 | MAGNET | LEVITATE | THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT | 26896 |
| SLOWPOKE_GALARIAN | 23 | 63 | 414 | 90/65/65/15/40/40 | 315 | NO_ITEM | UNAWARE | CONFUSION, ACID, HEADBUTT, DISABLE | 26896 |
| CROCONAW | 24 | 142 | 972 | 65/80/80/58/59/63 | 405 | BERRY | SHEER_FORCE | BITE, ICE_PUNCH, WATER_GUN, MUD_SLAP | 26896 |


Script predicates / event evidence:

- `special FadeOutMusic` — [maps/BurnedTower1F.asm:53](../../../maps/BurnedTower1F.asm#L53)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/BurnedTower1F.asm:64](../../../maps/BurnedTower1F.asm#L64)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/BurnedTower1F.asm:66](../../../maps/BurnedTower1F.asm#L66)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/BurnedTower1F.asm:68](../../../maps/BurnedTower1F.asm#L68)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/BurnedTower1F.asm:70](../../../maps/BurnedTower1F.asm#L70)
- `setscene SCENE_BURNEDTOWER1F_NOTHING` — [maps/BurnedTower1F.asm:104](../../../maps/BurnedTower1F.asm#L104)
- `special FadeOutMusic` — [maps/BurnedTower1F.asm:106](../../../maps/BurnedTower1F.asm#L106)
- `changeblock 10, 8, $25` — [maps/BurnedTower1F.asm:112](../../../maps/BurnedTower1F.asm#L112)

## Erika

Map `CeladonGym`; class `ERIKA`; party `Erika:1`; ace 62; itinerary cap 62. [maps/CeladonGym.asm:23](../../../maps/CeladonGym.asm#L23).

Saffron/Route7


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| LUDICOLO | 59 | 240 | 4044 | 80/70/70/70/90/100 | 480 | LEFTOVERS | SWIFT_SWIM | RAIN_DANCE, SURF, GIGA_DRAIN, ICE_BEAM | 38416 |
| JUMPLUFF | 60 | 230 | 3942 | 75/55/70/110/85/95 | 490 | LEFTOVERS | INFILTRATOR | SLEEP_POWDER, LEECH_SEED, GIGA_DRAIN, ENCORE | 38416 |
| VILEPLUME | 60 | 245 | 4200 | 75/80/85/50/110/90 | 490 | LEFTOVERS | POISON_PUPPETEER | SLUDGE_BOMB, GIGA_DRAIN, TOXIC, SYNTHESIS | 38416 |
| VICTREEBEL | 61 | 245 | 4270 | 80/105/65/70/100/70 | 490 | LIFE_ORB | POISON_PUPPETEER | POWER_WHIP, SLUDGE_BOMB, KNOCK_OFF, SWORDS_DANCE | 38416 |
| EXEGGUTOR | 61 | 186 | 3240 | 95/95/85/55/125/75 | 530 | GOLD_BERRY | HARVEST | PSYCHIC_M, GIGA_DRAIN, LEECH_SEED, SUBSTITUTE | 38416 |
| TSAREENA | 62 | 230 | 4074 | 72/120/98/72/50/98 | 510 | LIFE_ORB | QUEENLY_MAJESTY | POWER_WHIP, TRIPLE_AXEL, PLAY_ROUGH, SWORDS_DANCE | 38416 |


Script predicates / event evidence:

- `checkflag ENGINE_RAINBOWBADGE` — [maps/CeladonGym.asm:17](../../../maps/CeladonGym.asm#L17)
- `checkevent EVENT_GOT_TM19_ENERGY_BALL` — [maps/CeladonGym.asm:39](../../../maps/CeladonGym.asm#L39)

## Misty

Map `CeruleanGym`; class `MISTY`; party `Misty:1`; ace 54; itinerary cap 54. [maps/CeruleanGym.asm:68](../../../maps/CeruleanGym.asm#L68).

Mt Moon/Route4; power investigation, Route25 date for Misty


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MILOTIC | 51 | 189 | 2754 | 95/60/79/81/100/125 | 540 | LEFTOVERS | MARVEL_SCALE | SCALD, ICE_BEAM, RECOVER, TOXIC | 40000 |
| WALREIN | 52 | 255 | 3788 | 110/80/90/65/95/90 | 530 | LEFTOVERS | THICK_FAT | SURF, ICE_BEAM, BODY_SLAM, PROTECT | 40000 |
| GYARADOS | 52 | 189 | 2808 | 95/125/79/81/60/100 | 540 | ROCKY_HELMET | INTIMIDATE | WATERFALL, CRUNCH, ICE_FANG, DRAGON_DANCE | 40000 |
| AZUMARILL | 53 | 210 | 3180 | 110/50/80/50/80/80 | 450 | MUSCLE_BAND | HUGE_POWER | AQUA_JET, PLAY_ROUGH, WATERFALL, ICE_PUNCH | 40000 |
| LANTURN | 53 | 161 | 2438 | 125/58/70/67/96/76 | 492 | LEFTOVERS | VOLT_ABSORB | SURF, THUNDERBOLT, ICE_BEAM, CONFUSE_RAY | 40000 |
| STARMIE | 54 | 182 | 2808 | 60/75/85/115/100/85 | 520 | LIFE_ORB | NATURAL_CURE | SURF, PSYCHIC_M, THUNDERBOLT, RECOVER | 40000 |


Script predicates / event evidence:

- `checkflag ENGINE_CASCADEBADGE` — [maps/CeruleanGym.asm:62](../../../maps/CeruleanGym.asm#L62)

## ? (CherrygroveCity)

Map `CherrygroveCity`; class `RIVAL1`; party `Rival1:3`; ace 5; itinerary cap 10. [maps/CherrygroveCity.asm:139](../../../maps/CherrygroveCity.asm#L139).

Elm errand; Silver on return


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| TOTODILE | 5 | 63 | 90 | 50/65/64/43/44/48 | 314 | BERRY | SHEER_FORCE | SCRATCH, LEER, NO_MOVE, NO_MOVE | 26896 |


Script predicates / event evidence:

- `special FadeOutMusic` — [maps/CherrygroveCity.asm:119](../../../maps/CherrygroveCity.asm#L119)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/CherrygroveCity.asm:129](../../../maps/CherrygroveCity.asm#L129)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/CherrygroveCity.asm:131](../../../maps/CherrygroveCity.asm#L131)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/CherrygroveCity.asm:133](../../../maps/CherrygroveCity.asm#L133)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/CherrygroveCity.asm:135](../../../maps/CherrygroveCity.asm#L135)
- `readvar VAR_YCOORD` — [maps/CherrygroveCity.asm:185](../../../maps/CherrygroveCity.asm#L185)
- `setscene SCENE_CHERRYGROVECITY_NOTHING` — [maps/CherrygroveCity.asm:197](../../../maps/CherrygroveCity.asm#L197)
- `special HealParty` — [maps/CherrygroveCity.asm:198](../../../maps/CherrygroveCity.asm#L198)

## EUSINE (CianwoodCity)

Map `CianwoodCity`; class `MYSTICALMAN`; party `Mysticalman:1`; ace 34; itinerary cap 30. [maps/CianwoodCity.asm:76](../../../maps/CianwoodCity.asm#L76).

Morty + all 8 Kimono Girls for Surf; Routes40-41


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HYPNO | 33 | 169 | 1592 | 85/73/70/67/73/115 | 483 | TWISTEDSPOON | INSOMNIA | PSYCHIC_M, HYPNOSIS, DREAM_EATER, REFLECT | 7056 |
| HAUNTER | 33 | 142 | 1338 | 45/50/45/95/115/55 | 405 | SPELL_TAG | LEVITATE | SHADOW_BALL, HYPNOSIS, CONFUSE_RAY, SUCKER_PUNCH | 7056 |
| ELECTRODE | 34 | 172 | 1670 | 60/50/70/150/90/80 | 500 | MAGNET | STATIC | THUNDERBOLT, THUNDER_WAVE, SELFDESTRUCT, LIGHT_SCREEN | 7056 |


Script predicates / event evidence:

- `setscene SCENE_CIANWOODCITY_NOTHING` — [maps/CianwoodCity.asm:61](../../../maps/CianwoodCity.asm#L61)
- `setmapscene ROUTE_42, SCENE_ROUTE42_SUICUNE` — [maps/CianwoodCity.asm:63](../../../maps/CianwoodCity.asm#L63)
- `checkevent EVENT_FOUGHT_EUSINE` — [maps/CianwoodCity.asm:64](../../../maps/CianwoodCity.asm#L64)
- `special FadeOutMusic` — [maps/CianwoodCity.asm:88](../../../maps/CianwoodCity.asm#L88)

## CRYSTAL (CianwoodCity)

Map `CianwoodCity`; class `CRYSTAL`; party `Crystal:7`; ace 32; itinerary cap 30. [maps/CianwoodCity.asm:133](../../../maps/CianwoodCity.asm#L133).

Morty + all 8 Kimono Girls for Surf; Routes40-41


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| XATU | 30 | 165 | 1414 | 80/75/70/95/95/70 | 485 | NO_ITEM | SYNCHRONIZE | PSYCHIC_M, AIR_SLASH, CONFUSE_RAY, NIGHT_SHADE | 7744 |
| MAROWAK | 32 | 149 | 1362 | 60/80/110/45/50/80 | 425 | THICK_CLUB | ROCK_HEAD | BONEMERANG, SWORDS_DANCE, KNOCK_OFF, HEADBUTT | 7744 |
| DIPPLIN | 31 | 170 | 1504 | 80/80/110/40/95/80 | 485 | BERRY | SUPERSWEET_SYRUP | DRAGON_PULSE, DRAGONBREATH, GROWTH, PROTECT | 7744 |
| BAYLEEF | 32 | 142 | 1298 | 60/62/80/60/63/80 | 405 | MIRACLE_SEED | SERENE_GRACE | RAZOR_LEAF, BODY_SLAM, SYNTHESIS, REFLECT | 7744 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/CianwoodCity.asm:125](../../../maps/CianwoodCity.asm#L125)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/CianwoodCity.asm:127](../../../maps/CianwoodCity.asm#L127)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/CianwoodCity.asm:129](../../../maps/CianwoodCity.asm#L129)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/CianwoodCity.asm:131](../../../maps/CianwoodCity.asm#L131)
- `readvar VAR_XCOORD` — [maps/CianwoodCity.asm:155](../../../maps/CianwoodCity.asm#L155)

## Chuck

Map `CianwoodGym`; class `CHUCK`; party `Chuck:1`; ace 30; itinerary cap 30. [maps/CianwoodGym.asm:41](../../../maps/CianwoodGym.asm#L41).

Morty + all 8 Kimono Girls for Surf; Routes40-41


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HITMONTOP | 28 | 159 | 1272 | 70/95/95/80/35/110 | 485 | NO_ITEM | TECHNICIAN | TRIPLE_KICK, TRIPLE_AXEL, DIG, PURSUIT | 7744 |
| GURDURR | 28 | 142 | 1136 | 85/105/85/40/40/50 | 405 | NO_ITEM | GUTS | ROCK_SLIDE, LOW_KICK, THUNDERPUNCH, BULK_UP | 7744 |
| BRELOOM | 29 | 161 | 1334 | 60/130/80/70/60/60 | 460 | NO_ITEM | TECHNICIAN | MACH_PUNCH, BULLET_SEED, HEADBUTT, DRAIN_PUNCH | 7744 |
| SCRAGGY | 29 | 70 | 580 | 50/75/70/48/35/70 | 348 | NO_ITEM | MOXIE | BRICK_BREAK, CRUNCH, ROCK_SLIDE, HEADBUTT | 7744 |
| POLIWRATH | 30 | 255 | 2184 | 90/95/95/70/70/90 | 510 | BLACKBELT | IRON_FIST | HYPNOSIS, MIND_READER, SURF, DYNAMICPUNCH | 7744 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CHUCK` — [maps/CianwoodGym.asm:20](../../../maps/CianwoodGym.asm#L20)
- `readvar VAR_BADGES` — [maps/CianwoodGym.asm:50](../../../maps/CianwoodGym.asm#L50)
- `checkevent EVENT_GOT_TM01_DRAIN_PUNCH` — [maps/CianwoodGym.asm:53](../../../maps/CianwoodGym.asm#L53)
- `checkevent EVENT_BEAT_CHUCK_REMATCH` — [maps/CianwoodGym.asm:70](../../../maps/CianwoodGym.asm#L70)
- `checkevent EVENT_BEAT_MORTY_REMATCH` — [maps/CianwoodGym.asm:72](../../../maps/CianwoodGym.asm#L72)

## Chuck rematch

Map `CianwoodGym`; class `CHUCK_REMATCH`; party `Chuck:2`; ace 81; itinerary cap 100. [maps/CianwoodGym.asm:79](../../../maps/CianwoodGym.asm#L79).

Morty + all 8 Kimono Girls for Surf; Routes40-41


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MACHAMP | 79 | 253 | 5710 | 90/130/80/55/65/85 | 505 | MUSCLE_BAND | NO_GUARD | DYNAMICPUNCH, KNOCK_OFF, ICE_PUNCH, BULLET_PUNCH | 44944 |
| CONKELDURR | 79 | 227 | 5122 | 105/140/95/45/55/65 | 505 | FLAME_ORB | GUTS | FACADE, HAMMER_ARM, STONE_EDGE, KNOCK_OFF | 44944 |
| GALLADE | 80 | 255 | 5828 | 68/125/65/80/65/115 | 518 | LIFE_ORB | SHARPNESS | SWORDS_DANCE, SACRED_SWORD, PSYCHO_CUT, NIGHT_SLASH | 44944 |
| SIRFETCH_D | 80 | 177 | 4044 | 62/135/95/65/60/90 | 507 | LIFE_ORB | SCRAPPY | SWORDS_DANCE, CLOSE_COMBAT, KNOCK_OFF, BRAVE_BIRD | 44944 |
| ANNIHILAPE | 81 | 255 | 5900 | 110/115/80/95/60/75 | 535 | LEFTOVERS | DEFIANT | BULK_UP, RAGE_FIST, CLOSE_COMBAT, NIGHT_SLASH | 44944 |
| POLIWRATH | 81 | 255 | 5900 | 90/95/95/70/70/90 | 510 | MUSCLE_BAND | IRON_FIST | DYNAMICPUNCH, DRAIN_PUNCH, ICE_PUNCH, MACH_PUNCH | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CHUCK` — [maps/CianwoodGym.asm:20](../../../maps/CianwoodGym.asm#L20)
- `readvar VAR_BADGES` — [maps/CianwoodGym.asm:50](../../../maps/CianwoodGym.asm#L50)
- `checkevent EVENT_GOT_TM01_DRAIN_PUNCH` — [maps/CianwoodGym.asm:53](../../../maps/CianwoodGym.asm#L53)
- `checkevent EVENT_BEAT_CHUCK_REMATCH` — [maps/CianwoodGym.asm:70](../../../maps/CianwoodGym.asm#L70)
- `checkevent EVENT_BEAT_MORTY_REMATCH` — [maps/CianwoodGym.asm:72](../../../maps/CianwoodGym.asm#L72)

## Blue Cloak

Map `CinnabarIsland`; class `BLUE_CLOAK`; party `BlueCloak:1`; ace 84; itinerary cap 100. [maps/CinnabarIsland.asm:57](../../../maps/CinnabarIsland.asm#L57).

same six Kanto badges; Surf south routes


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| PIDGEOT | 82 | 240 | 5622 | 83/60/70/101/115/70 | 499 | LIFE_ORB | NO_GUARD | HURRICANE, HEAT_WAVE, U_TURN, ROOST | 46656 |
| SCIZOR | 83 | 175 | 4150 | 70/130/100/65/55/80 | 500 | LIFE_ORB | TECHNICIAN | BULLET_PUNCH, X_SCISSOR, U_TURN, SWORDS_DANCE | 46656 |
| RHYPERIOR | 83 | 255 | 6046 | 115/140/130/40/55/55 | 535 | LIFE_ORB | SHEER_FORCE | BULLDOZE, ROCK_SLIDE, ICE_PUNCH, THUNDERPUNCH | 46656 |
| EXEGGUTOR | 84 | 186 | 4464 | 95/95/85/55/125/75 | 530 | GOLD_BERRY | HARVEST | PSYCHIC_M, GIGA_DRAIN, LEECH_SEED, SUBSTITUTE | 46656 |
| ELECTIVIRE | 84 | 255 | 6120 | 75/123/67/95/95/85 | 540 | LIFE_ORB | SHEER_FORCE | THUNDERPUNCH, ICE_PUNCH, FIRE_PUNCH, CRUNCH | 46656 |
| BLASTOISE | 84 | 255 | 6120 | 79/83/100/78/90/105 | 535 | LIFE_ORB | MEGA_LAUNCHER | WATER_PULSE, AURA_SPHERE, DARK_PULSE, DRAGON_PULSE | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_BLUE_CLOAK` — [maps/CinnabarIsland.asm:51](../../../maps/CinnabarIsland.asm#L51)

## EUSINE (EcruteakCity)

Map `EcruteakCity`; class `MYSTICALMAN`; party `Mysticalman:2`; ace 40; itinerary cap 45. [maps/EcruteakCity.asm:55](../../../maps/EcruteakCity.asm#L55).

Whitney, Floria and Squirtbottle/Sudowoodo; Burned Tower for Morty; 8 Kimono Girls for Surf


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HYPNO | 38 | 169 | 1834 | 85/73/70/67/73/115 | 483 | NO_ITEM | generated by trainer engine | ZEN_HEADBUTT, TRICK, PSYCHIC_M, HYPNOSIS | 7056 |
| GENGAR | 38 | 250 | 2714 | 60/65/60/110/130/75 | 500 | NO_ITEM | generated by trainer engine | SHADOW_BALL, SLUDGE_BOMB, HYPNOSIS, DREAM_EATER | 7056 |
| ELECTRODE | 39 | 172 | 1916 | 60/50/70/150/90/80 | 500 | NO_ITEM | generated by trainer engine | FOUL_PLAY, LIGHT_SCREEN, SIGNAL_BEAM, THUNDERBOLT | 7056 |
| NOCTOWL | 39 | 158 | 1760 | 100/40/60/60/106/116 | 482 | NO_ITEM | generated by trainer engine | DUALWINGBEAT, PSYCHIC_M, HEAT_WAVE, ZEN_HEADBUTT | 7056 |
| ESPEON | 40 | 184 | 2102 | 65/65/60/110/130/95 | 525 | NO_ITEM | generated by trainer engine | SKILL_SWAP, AURA_SPHERE, SIGNAL_BEAM, PSYCHO_CUT | 7056 |


Script predicates / event evidence:

- `checkevent EVENT_FOUGHT_SUICUNE` — [maps/EcruteakCity.asm:38](../../../maps/EcruteakCity.asm#L38)
- `checkevent EVENT_BEAT_EUSINE_IN_ECRUTEAK_CITY` — [maps/EcruteakCity.asm:40](../../../maps/EcruteakCity.asm#L40)
- `special FadeOutMusic` — [maps/EcruteakCity.asm:45](../../../maps/EcruteakCity.asm#L45)

## Morty

Map `EcruteakGym`; class `MORTY`; party `Morty:1`; ace 25; itinerary cap 25. [maps/EcruteakGym.asm:33](../../../maps/EcruteakGym.asm#L33).

Whitney, Floria and Squirtbottle/Sudowoodo; Burned Tower for Morty; 8 Kimono Girls for Surf


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GOLETT | 23 | 61 | 400 | 59/74/50/40/40/40 | 303 | NO_ITEM | IRON_FIST | SHADOW_PUNCH, ICE_PUNCH, BULLDOZE, LOW_SWEEP | 6400 |
| MISDREAVUS | 24 | 87 | 596 | 60/60/60/85/85/85 | 435 | NO_ITEM | LEVITATE | SHADOW_BALL, CONFUSE_RAY, PAIN_SPLIT, FAIRY_WIND | 6400 |
| DRIFLOON | 24 | 70 | 480 | 90/50/34/70/60/44 | 348 | NO_ITEM | UNBURDEN | NIGHT_SHADE, WILL_O_WISP, SHADOW_BALL, AIR_CUTTER | 6400 |
| GENGAR | 25 | 250 | 1784 | 60/65/60/110/130/75 | 500 | MIRACLEBERRY | LEVITATE | SHADOW_BALL, SLUDGE, CONFUSE_RAY, MEAN_LOOK | 6400 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_MORTY` — [maps/EcruteakGym.asm:27](../../../maps/EcruteakGym.asm#L27)
- `readvar VAR_BADGES` — [maps/EcruteakGym.asm:42](../../../maps/EcruteakGym.asm#L42)
- `setmapscene ECRUTEAK_TIN_TOWER_ENTRANCE, SCENE_FINISHED` — [maps/EcruteakGym.asm:44](../../../maps/EcruteakGym.asm#L44)
- `checkevent EVENT_GOT_TM30_SHADOW_BALL` — [maps/EcruteakGym.asm:48](../../../maps/EcruteakGym.asm#L48)
- `checkevent EVENT_BEAT_MORTY_REMATCH` — [maps/EcruteakGym.asm:65](../../../maps/EcruteakGym.asm#L65)
- `checkevent EVENT_BEAT_WHITNEY_REMATCH` — [maps/EcruteakGym.asm:67](../../../maps/EcruteakGym.asm#L67)

## Morty rematch

Map `EcruteakGym`; class `MORTY_REMATCH`; party `Morty:2`; ace 80; itinerary cap 100. [maps/EcruteakGym.asm:74](../../../maps/EcruteakGym.asm#L74).

Whitney, Floria and Squirtbottle/Sudowoodo; Burned Tower for Morty; 8 Kimono Girls for Surf


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MISMAGIUS | 78 | 173 | 3854 | 60/60/60/105/105/105 | 495 | LEFTOVERS | PRANKSTER | NASTY_PLOT, SHADOW_BALL, MOONBLAST, WILL_O_WISP | 44944 |
| DUSKNOIR | 78 | 255 | 5682 | 60/100/135/45/65/135 | 540 | LEFTOVERS | IRON_FIST | SHADOW_SNEAK, PAIN_SPLIT, THUNDERPUNCH, FIRE_PUNCH | 44944 |
| MIMIKYU | 79 | 167 | 3768 | 55/100/80/96/50/105 | 486 | LIFE_ORB | DISGUISE | BULK_UP, PHANTOMFORCE, PLAY_ROUGH, SHADOW_SNEAK | 44944 |
| CHANDELURE | 79 | 234 | 5280 | 60/55/90/80/145/90 | 520 | LIFE_ORB | LEVITATE | SHADOW_BALL, FIRE_BLAST, PSYCHIC_M, WILL_O_WISP | 44944 |
| DRAGAPULT | 80 | 255 | 5828 | 88/120/75/142/100/75 | 600 | LIFE_ORB | INFILTRATOR | DRAGON_DANCE, DRAGON_DARTS, PHANTOMFORCE, SUCKER_PUNCH | 44944 |
| GENGAR | 80 | 250 | 5714 | 60/65/60/110/130/75 | 500 | LIFE_ORB | LEVITATE | NASTY_PLOT, SHADOW_BALL, SLUDGE_BOMB, THUNDERBOLT | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_MORTY` — [maps/EcruteakGym.asm:27](../../../maps/EcruteakGym.asm#L27)
- `readvar VAR_BADGES` — [maps/EcruteakGym.asm:42](../../../maps/EcruteakGym.asm#L42)
- `setmapscene ECRUTEAK_TIN_TOWER_ENTRANCE, SCENE_FINISHED` — [maps/EcruteakGym.asm:44](../../../maps/EcruteakGym.asm#L44)
- `checkevent EVENT_GOT_TM30_SHADOW_BALL` — [maps/EcruteakGym.asm:48](../../../maps/EcruteakGym.asm#L48)
- `checkevent EVENT_BEAT_MORTY_REMATCH` — [maps/EcruteakGym.asm:65](../../../maps/EcruteakGym.asm#L65)
- `checkevent EVENT_BEAT_WHITNEY_REMATCH` — [maps/EcruteakGym.asm:67](../../../maps/EcruteakGym.asm#L67)

## KIYO (FightingDojo)

Map `FightingDojo`; class `KARATE_KING`; party `KarateKing:1`; ace 70; itinerary cap 62. [maps/FightingDojo.asm:32](../../../maps/FightingDojo.asm#L32).

Saffron access; Kiyo has no visibility event or progress gate (object flag -1)


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| SIRFETCH_D | 67 | 177 | 3388 | 62/135/95/65/60/90 | 507 | STICK | SUPER_LUCK | CLOSE_COMBAT, BRAVE_BIRD, LEAF_BLADE, NIGHT_SLASH | 10000 |
| SNEASLER | 67 | 179 | 3426 | 80/130/60/120/40/80 | 510 | LIFE_ORB | TECHNICIAN | FAKE_OUT, DIRE_CLAW, CLOSE_COMBAT, TRIPLE_AXEL | 10000 |
| BRELOOM | 68 | 161 | 3128 | 60/130/80/70/60/60 | 460 | FOCUS_SASH | TECHNICIAN | SPORE, BULLET_SEED, MACH_PUNCH, ROCK_TOMB | 10000 |
| SCRAFTY | 68 | 171 | 3322 | 77/90/115/58/45/115 | 500 | LEFTOVERS | INTIMIDATE | DRAGON_DANCE, DRAIN_PUNCH, KNOCK_OFF, ICE_PUNCH | 10000 |
| HITMONTOP | 70 | 159 | 3180 | 70/95/95/80/35/110 | 485 | WIDE_LENS | TECHNICIAN | TRIPLE_KICK, TRIPLE_AXEL, MACH_PUNCH, BULLET_PUNCH | 10000 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_CHOICE_BAND_FROM_KIYO` — [maps/FightingDojo.asm:24](../../../maps/FightingDojo.asm#L24)
- `checkevent EVENT_BEAT_DOJO_KIYO` — [maps/FightingDojo.asm:26](../../../maps/FightingDojo.asm#L26)

## Janine

Map `FuchsiaGym`; class `JANINE`; party `Janine:1`; ace 62; itinerary cap 62. [maps/FuchsiaGym.asm:24](../../../maps/FuchsiaGym.asm#L24).

Routes12-15 or Cycling Road; Snorlax/Bicycle alternate paths


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| TOXAPEX | 59 | 173 | 2916 | 50/63/152/35/53/142 | 495 | LEFTOVERS | REGENERATOR | TOXIC_SPIKES, SCALD, RECOVER, BANEFUL_BUNKER | 40000 |
| VENOMOTH | 60 | 158 | 2708 | 70/55/60/90/100/75 | 450 | LIFE_ORB | TINTED_LENS | QUIVER_DANCE, BUG_BUZZ, SLUDGE_BOMB, SLEEP_POWDER | 40000 |
| SEVIPER | 60 | 160 | 2742 | 75/115/60/90/90/60 | 490 | LIFE_ORB | MERCILESS | GUNK_SHOT, CRUNCH, EARTHQUAKE, SUCKER_PUNCH | 40000 |
| OVERQWIL | 61 | 88 | 1532 | 85/115/95/85/65/65 | 510 | LEFTOVERS | INTIMIDATE | BARB_BARRAGE, CRUNCH, AQUA_TAIL, SWORDS_DANCE | 40000 |
| ARIADOS | 61 | 140 | 2440 | 80/110/75/80/50/70 | 465 | LIFE_ORB | MERCILESS | MEGAHORN, POISON_JAB, SUCKER_PUNCH, TOXIC | 40000 |
| CROBAT | 62 | 255 | 4516 | 85/90/80/130/70/80 | 535 | BRIGHTPOWDER | MERCILESS | CROSS_POISON, BRAVE_BIRD, U_TURN, ROOST | 40000 |


Script predicates / event evidence:

- `checkflag ENGINE_SOULBADGE` — [maps/FuchsiaGym.asm:15](../../../maps/FuchsiaGym.asm#L15)
- `special RefreshSprites` — [maps/FuchsiaGym.asm:36](../../../maps/FuchsiaGym.asm#L36)
- `checkevent EVENT_GOT_TM06_TOXIC` — [maps/FuchsiaGym.asm:47](../../../maps/FuchsiaGym.asm#L47)

## Whitney

Map `GoldenrodGym`; class `WHITNEY`; party `Whitney:1`; ace 20; itinerary cap 20. [maps/GoldenrodGym.asm:31](../../../maps/GoldenrodGym.asm#L31).

Cut through Ilex Forest


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CLEFAIRY | 18 | 113 | 580 | 70/45/48/35/60/65 | 323 | NO_ITEM | MAGIC_GUARD | FAIRY_WIND, FIRE_PUNCH, THUNDERPUNCH, CHARM | 6400 |
| AIPOM | 19 | 72 | 390 | 55/70/55/85/40/55 | 360 | NO_ITEM | SKILL_LINK | FURY_SWIPES, ICE_PUNCH, KNOCK_OFF, FAKE_OUT | 6400 |
| BUNEARY | 19 | 70 | 380 | 55/66/44/85/44/56 | 350 | NO_ITEM | LIMBER | QUICK_ATTACK, HEADBUTT, ICE_PUNCH, KARATE_CHOP | 6400 |
| MILTANK | 20 | 172 | 982 | 95/80/105/100/40/70 | 490 | MIRACLEBERRY | THICK_FAT | ROLLOUT, ATTRACT, STOMP, MILK_DRINK | 6400 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_WHITNEY` — [maps/GoldenrodGym.asm:24](../../../maps/GoldenrodGym.asm#L24)
- `setscene SCENE_GOLDENRODGYM_WHITNEY_STOPS_CRYING` — [maps/GoldenrodGym.asm:36](../../../maps/GoldenrodGym.asm#L36)
- `checkevent EVENT_MADE_WHITNEY_CRY` — [maps/GoldenrodGym.asm:43](../../../maps/GoldenrodGym.asm#L43)
- `checkevent EVENT_GOT_TM45_ATTRACT` — [maps/GoldenrodGym.asm:51](../../../maps/GoldenrodGym.asm#L51)
- `checkflag ENGINE_PLAINBADGE` — [maps/GoldenrodGym.asm:53](../../../maps/GoldenrodGym.asm#L53)
- `readvar VAR_BADGES` — [maps/GoldenrodGym.asm:62](../../../maps/GoldenrodGym.asm#L62)
- `checkevent EVENT_BEAT_WHITNEY_REMATCH` — [maps/GoldenrodGym.asm:76](../../../maps/GoldenrodGym.asm#L76)
- `checkevent EVENT_BEAT_BUGSY_REMATCH` — [maps/GoldenrodGym.asm:78](../../../maps/GoldenrodGym.asm#L78)

## Whitney rematch

Map `GoldenrodGym`; class `WHITNEY_REMATCH`; party `Whitney:2`; ace 79; itinerary cap 100. [maps/GoldenrodGym.asm:85](../../../maps/GoldenrodGym.asm#L85).

Cut through Ilex Forest


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| BLISSEY | 77 | 255 | 5610 | 255/10/10/55/75/135 | 540 | LEFTOVERS | NATURAL_CURE | SOFTBOILED, SEISMIC_TOSS, TOXIC, ICE_BEAM | 43264 |
| AMBIPOM | 77 | 169 | 3718 | 75/100/66/115/90/66 | 512 | LIFE_ORB | TECHNICIAN | FAKE_OUT, BODY_SLAM, LOW_KICK, U_TURN | 43264 |
| LOPUNNY | 78 | 168 | 3744 | 65/106/84/105/44/96 | 500 | LIFE_ORB | ADAPTABILITY | FAKE_OUT, DIZZY_PUNCH, DRAIN_PUNCH, ICE_PUNCH | 43264 |
| URSALUNA | 78 | 175 | 3900 | 130/140/105/50/45/80 | 550 | FLAME_ORB | GUTS | FACADE, HEADLONGRUSH, CLOSE_COMBAT, CRUNCH | 43264 |
| SNORLAX | 79 | 189 | 4266 | 160/110/65/30/65/110 | 540 | LEFTOVERS | THICK_FAT | CURSE, BODY_SLAM, EARTHQUAKE, SLACK_OFF | 43264 |
| MILTANK | 79 | 172 | 3882 | 95/80/105/100/40/70 | 490 | LEFTOVERS | SCRAPPY | MILK_DRINK, BODY_SLAM, EARTHQUAKE, PLAY_ROUGH | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_WHITNEY` — [maps/GoldenrodGym.asm:24](../../../maps/GoldenrodGym.asm#L24)
- `setscene SCENE_GOLDENRODGYM_WHITNEY_STOPS_CRYING` — [maps/GoldenrodGym.asm:36](../../../maps/GoldenrodGym.asm#L36)
- `checkevent EVENT_MADE_WHITNEY_CRY` — [maps/GoldenrodGym.asm:43](../../../maps/GoldenrodGym.asm#L43)
- `checkevent EVENT_GOT_TM45_ATTRACT` — [maps/GoldenrodGym.asm:51](../../../maps/GoldenrodGym.asm#L51)
- `checkflag ENGINE_PLAINBADGE` — [maps/GoldenrodGym.asm:53](../../../maps/GoldenrodGym.asm#L53)
- `readvar VAR_BADGES` — [maps/GoldenrodGym.asm:62](../../../maps/GoldenrodGym.asm#L62)
- `checkevent EVENT_BEAT_WHITNEY_REMATCH` — [maps/GoldenrodGym.asm:76](../../../maps/GoldenrodGym.asm#L76)
- `checkevent EVENT_BEAT_BUGSY_REMATCH` — [maps/GoldenrodGym.asm:78](../../../maps/GoldenrodGym.asm#L78)

## ? (GoldenrodUndergroundSwitchRoomEntrances)

Map `GoldenrodUndergroundSwitchRoomEntrances`; class `RIVAL1`; party `Rival1:12`; ace 42; itinerary cap 45. [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:179](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L179).

Radio Tower fake director gives Basement Key; underground rescue


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GOLBAT | 40 | 159 | 1816 | 75/80/70/90/65/75 | 455 | EVIOLITE | INNER_FOCUS | DUALWINGBEAT, POISON_FANG, BITE, ROOST | 26896 |
| MAGNEZONE | 41 | 255 | 2986 | 70/70/115/60/130/90 | 535 | MAGNET | LEVITATE | THUNDERBOLT, FLASH_CANNON, TRI_ATTACK, THUNDER_WAVE | 26896 |
| SLOWKING_GALARIAN | 41 | 172 | 2014 | 95/65/80/30/110/110 | 490 | LEFTOVERS | UNAWARE | PSYCHIC_M, SLUDGE_BOMB, FLAMETHROWER, RECOVER | 26896 |
| WEAVILE | 41 | 179 | 2096 | 70/120/65/125/45/85 | 510 | NEVERMELTICE | TECHNICIAN | ICE_SHARD, FAINT_ATTACK, ICICLE_CRASH, LOW_KICK | 26896 |
| CERULEDGE | 41 | 255 | 2986 | 75/125/80/85/60/100 | 525 | CHARCOAL | SHARPNESS | BITTER_BLADE, PHANTOMFORCE, PSYCHO_CUT, SHADOW_SNEAK | 26896 |
| FERALIGATR | 42 | 255 | 3060 | 85/110/100/78/79/83 | 535 | MYSTIC_WATER | SHEER_FORCE | WATERFALL, ICE_PUNCH, CRUNCH, ROCK_SLIDE | 26896 |


Script predicates / event evidence:

- `checkevent EVENT_RIVAL_BURNED_TOWER` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:158](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L158)
- `setmapscene BURNED_TOWER_1F, SCENE_BURNEDTOWER1F_RIVAL_BATTLE` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:161](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L161)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:169](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L169)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:171](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L171)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:173](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L173)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:175](../../../maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L175)

## CRYSTAL (IcePath1F)

Map `IcePath1F`; class `CRYSTAL2`; party `Crystal:10`; ace 44; itinerary cap 45. [maps/IcePath1F.asm:52](../../../maps/IcePath1F.asm#L52).

Rocket Hideout clears east road; Waterfall field use needs Clair


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| XATU | 41 | 165 | 1932 | 80/75/70/95/95/70 | 485 | NO_ITEM | MAGIC_BOUNCE | PSYCHIC_M, AIR_SLASH, ROOST, CONFUSE_RAY | 18496 |
| MAROWAK | 42 | 149 | 1788 | 60/80/110/45/50/80 | 425 | THICK_CLUB | ROCK_HEAD | BONEMERANG, SWORDS_DANCE, KNOCK_OFF, IRON_HEAD | 18496 |
| HYDRAPPLE | 42 | 255 | 3060 | 106/70/90/66/130/80 | 542 | LEFTOVERS | REGENERATOR | APPLE_ACID, DRAGON_PULSE, RECOVER, ENERGY_BALL | 18496 |
| PUPITAR | 42 | 144 | 1728 | 70/84/70/51/65/70 | 410 | NO_ITEM | SHED_SKIN | ROCK_SLIDE, CRUNCH, EARTHQUAKE, ANCIENTPOWER | 18496 |
| MEGANIUM | 44 | 255 | 3204 | 80/82/100/80/93/100 | 535 | MIRACLE_SEED | SERENE_GRACE | GIGA_DRAIN, BODY_SLAM, SYNTHESIS, REFLECT | 18496 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CRYSTAL_ICE_PATH` — [maps/IcePath1F.asm:32](../../../maps/IcePath1F.asm#L32)
- `special FadeOutMusic` — [maps/IcePath1F.asm:36](../../../maps/IcePath1F.asm#L36)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/IcePath1F.asm:44](../../../maps/IcePath1F.asm#L44)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/IcePath1F.asm:46](../../../maps/IcePath1F.asm#L46)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/IcePath1F.asm:48](../../../maps/IcePath1F.asm#L48)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/IcePath1F.asm:50](../../../maps/IcePath1F.asm#L50)

## CRYSTAL (IlexForest)

Map `IlexForest`; class `CRYSTAL`; party `Crystal:4`; ace 20; itinerary cap 20. [maps/IlexForest.asm:421](../../../maps/IlexForest.asm#L421).

Azalea rival; Bugsy for Cut at north exit


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| NATU | 16 | 64 | 292 | 40/50/45/70/70/45 | 320 | NO_ITEM | SYNCHRONIZE | CONFUSION, NIGHT_SHADE, PECK, LEER | 7744 |
| APPLIN | 17 | 52 | 252 | 40/40/80/20/40/40 | 260 | BERRY_JUICE | RIPEN | ASTONISH, WITHDRAW, DRAGONBREATH, GROWTH | 7744 |
| CUBONE | 17 | 64 | 310 | 50/50/95/35/40/50 | 320 | THICK_CLUB | ROCK_HEAD | BONE_CLUB, HEADBUTT, MUD_SHOT, FOCUS_ENERGY | 7744 |
| BAYLEEF | 20 | 142 | 810 | 60/62/80/60/63/80 | 405 | BERRY | SERENE_GRACE | RAZOR_LEAF, BODY_SLAM, REFLECT, SYNTHESIS | 7744 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CRYSTAL_VIOLET_CITY` — [maps/IlexForest.asm:399](../../../maps/IlexForest.asm#L399)
- `checkevent EVENT_BEAT_CRYSTAL_ILEX_FOREST` — [maps/IlexForest.asm:401](../../../maps/IlexForest.asm#L401)
- `special FadeOutMusic` — [maps/IlexForest.asm:403](../../../maps/IlexForest.asm#L403)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/IlexForest.asm:413](../../../maps/IlexForest.asm#L413)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/IlexForest.asm:415](../../../maps/IlexForest.asm#L415)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/IlexForest.asm:417](../../../maps/IlexForest.asm#L417)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/IlexForest.asm:419](../../../maps/IlexForest.asm#L419)

## Silver Plateau

Map `IndigoPlateauPokecenter1F`; class `RIVAL3`; party `Rival2:6`; ace 85; itinerary cap 100. [maps/IndigoPlateauPokecenter1F.asm:98](../../../maps/IndigoPlateauPokecenter1F.asm#L98).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CROBAT | 82 | 255 | 5974 | 85/90/80/130/70/80 | 535 | LEFTOVERS | INFILTRATOR | BRAVE_BIRD, CROSS_POISON, U_TURN, ROOST | 44944 |
| MAGNEZONE | 83 | 255 | 6046 | 70/70/115/60/130/90 | 535 | MAGNET | LEVITATE | THUNDERBOLT, FLASH_CANNON, TRI_ATTACK, THUNDER_WAVE | 44944 |
| SLOWKING_GALARIAN | 83 | 172 | 4078 | 95/65/80/30/110/110 | 490 | LEFTOVERS | UNAWARE | PSYCHIC_M, SLUDGE_BOMB, FLAMETHROWER, RECOVER | 44944 |
| WEAVILE | 83 | 179 | 4244 | 70/120/65/125/45/85 | 510 | NEVERMELTICE | TECHNICIAN | ICE_SHARD, FAINT_ATTACK, ICICLE_CRASH, LOW_KICK | 44944 |
| CERULEDGE | 83 | 255 | 6046 | 75/125/80/85/60/100 | 525 | CHARCOAL | SHARPNESS | BITTER_BLADE, PHANTOMFORCE, PSYCHO_CUT, SHADOW_SNEAK | 44944 |
| FERALIGATR | 85 | 255 | 6192 | 85/110/100/78/79/83 | 535 | MYSTIC_WATER | SHEER_FORCE | WATERFALL, ICE_PUNCH, CRUNCH, ROCK_SLIDE | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/IndigoPlateauPokecenter1F.asm:87](../../../maps/IndigoPlateauPokecenter1F.asm#L87)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/IndigoPlateauPokecenter1F.asm:89](../../../maps/IndigoPlateauPokecenter1F.asm#L89)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/IndigoPlateauPokecenter1F.asm:91](../../../maps/IndigoPlateauPokecenter1F.asm#L91)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/IndigoPlateauPokecenter1F.asm:93](../../../maps/IndigoPlateauPokecenter1F.asm#L93)

## Karen

Map `KarensRoom`; class `KAREN`; party `Karen:1`; ace 72; itinerary cap 100. [maps/KarensRoom.asm:54](../../../maps/KarensRoom.asm#L54).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| UMBREON | 69 | 184 | 3626 | 95/65/110/65/60/130 | 525 | LEFTOVERS | SYNCHRONIZE | FOUL_PLAY, TOXIC, MOONLIGHT, CONFUSE_RAY | 24336 |
| HONCHKROW | 70 | 177 | 3540 | 100/125/52/71/115/52 | 515 | LIFE_ORB | MOXIE | BRAVE_BIRD, SUCKER_PUNCH, NIGHT_SLASH, HEAT_WAVE | 24336 |
| WEAVILE | 70 | 179 | 3580 | 70/120/65/125/45/85 | 510 | LIFE_ORB | TECHNICIAN | ICE_SHARD, FAINT_ATTACK, ICICLE_CRASH, LOW_KICK | 24336 |
| GRIMMSNARL | 71 | 255 | 5172 | 95/120/75/60/75/85 | 510 | LEFTOVERS | PRANKSTER | SPIRIT_BREAK, CRUNCH, THUNDER_WAVE, BULK_UP | 24336 |
| HOUNDOOM | 71 | 175 | 3550 | 75/100/50/95/110/80 | 510 | BLACKGLASSES | ADAPTABILITY | FLAMETHROWER, DARK_PULSE, SLUDGE_BOMB, NASTY_PLOT | 24336 |
| KINGAMBIT | 72 | 255 | 5244 | 100/135/120/50/60/85 | 550 | LEFTOVERS | SUPREME_OVERLORD | KOWTOW_CLEAVE, SUCKER_PUNCH, IRON_HEAD, SWORDS_DANCE | 24336 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_KAREN` — [maps/KarensRoom.asm:46](../../../maps/KarensRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/KarensRoom.asm:52](../../../maps/KarensRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/KarensRoom.asm:67](../../../maps/KarensRoom.asm#L67)

## Karen rematch

Map `KarensRoom`; class `KAREN_REMATCH`; party `Karen:2`; ace 86; itinerary cap 100. [maps/KarensRoom.asm:57](../../../maps/KarensRoom.asm#L57).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| UMBREON | 84 | 184 | 4416 | 95/65/110/65/60/130 | 525 | LEFTOVERS | SYNCHRONIZE | FOUL_PLAY, TOXIC, MOONLIGHT, CONFUSE_RAY | 46656 |
| HONCHKROW | 85 | 177 | 4298 | 100/125/52/71/115/52 | 515 | LIFE_ORB | MOXIE | BRAVE_BIRD, SUCKER_PUNCH, NIGHT_SLASH, HEAT_WAVE | 46656 |
| WEAVILE | 85 | 179 | 4346 | 70/120/65/125/45/85 | 510 | LIFE_ORB | TECHNICIAN | ICICLE_CRASH, KNOCK_OFF, ICE_SHARD, LOW_KICK | 46656 |
| GRIMMSNARL | 86 | 255 | 6264 | 95/120/75/60/75/85 | 510 | LEFTOVERS | PRANKSTER | BULK_UP, SPIRIT_BREAK, CRUNCH, THUNDER_WAVE | 46656 |
| HOUNDOOM | 86 | 175 | 4300 | 75/100/50/95/110/80 | 510 | LIFE_ORB | ADAPTABILITY | NASTY_PLOT, DARK_PULSE, FIRE_BLAST, SLUDGE_BOMB | 46656 |
| KINGAMBIT | 86 | 255 | 6264 | 100/135/120/50/60/85 | 550 | LEFTOVERS | SUPREME_OVERLORD | SWORDS_DANCE, KOWTOW_CLEAVE, SUCKER_PUNCH, IRON_HEAD | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_KAREN` — [maps/KarensRoom.asm:46](../../../maps/KarensRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/KarensRoom.asm:52](../../../maps/KarensRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/KarensRoom.asm:67](../../../maps/KarensRoom.asm#L67)

## Koga

Map `KogasRoom`; class `KOGA`; party `Koga:1`; ace 71; itinerary cap 100. [maps/KogasRoom.asm:54](../../../maps/KogasRoom.asm#L54).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GLIMMORA | 68 | 184 | 3574 | 83/55/90/86/130/81 | 525 | FOCUS_SASH | TOXIC_DEBRIS | TOXIC_SPIKES, POWER_GEM, SLUDGE_BOMB, EARTH_POWER | 24336 |
| MUK_ALOLAN | 69 | 175 | 3450 | 105/105/75/50/65/100 | 500 | ASSAULT_VEST | POISON_TOUCH | GUNK_SHOT, KNOCK_OFF, CRUNCH, SHADOW_SNEAK | 24336 |
| SCOLIPEDE | 69 | 218 | 4296 | 60/110/89/112/55/69 | 495 | LIFE_ORB | SPEED_BOOST | MEGAHORN, POISON_JAB, ROCK_SLIDE, SWORDS_DANCE | 24336 |
| TENTACRUEL | 70 | 180 | 3600 | 80/70/65/100/80/120 | 515 | LEFTOVERS | CLEAR_BODY | SURF, SLUDGE_BOMB, ICE_BEAM, KNOCK_OFF | 24336 |
| SALAZZLE | 70 | 168 | 3360 | 68/64/60/117/116/60 | 485 | LIFE_ORB | POISON_PUPPETEER | FLAMETHROWER, SLUDGE_BOMB, TOXIC, NASTY_PLOT | 24336 |
| CROBAT | 71 | 255 | 5172 | 85/90/80/130/70/80 | 535 | BRIGHTPOWDER | MERCILESS | HYPNOSIS, CROSS_POISON, BRAVE_BIRD, ROOST | 24336 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_KOGA` — [maps/KogasRoom.asm:46](../../../maps/KogasRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/KogasRoom.asm:52](../../../maps/KogasRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/KogasRoom.asm:67](../../../maps/KogasRoom.asm#L67)

## Koga rematch

Map `KogasRoom`; class `KOGA_REMATCH`; party `Koga:2`; ace 85; itinerary cap 100. [maps/KogasRoom.asm:57](../../../maps/KogasRoom.asm#L57).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GLIMMORA | 83 | 184 | 4362 | 83/55/90/86/130/81 | 525 | FOCUS_SASH | TOXIC_DEBRIS | TOXIC_SPIKES, STEALTH_ROCK, SLUDGE_BOMB, EARTH_POWER | 46656 |
| MUK_ALOLAN | 84 | 175 | 4200 | 105/105/75/50/65/100 | 500 | ASSAULT_VEST | POISON_TOUCH | GUNK_SHOT, KNOCK_OFF, ICE_PUNCH, SHADOW_SNEAK | 46656 |
| SCOLIPEDE | 84 | 218 | 5232 | 60/110/89/112/55/69 | 495 | LIFE_ORB | SPEED_BOOST | SWORDS_DANCE, MEGAHORN, POISON_JAB, ROCK_SLIDE | 46656 |
| TENTACRUEL | 85 | 180 | 4370 | 80/70/65/100/80/120 | 515 | LEFTOVERS | CLEAR_BODY | SCALD, SLUDGE_BOMB, ICE_BEAM, KNOCK_OFF | 46656 |
| SALAZZLE | 85 | 168 | 4080 | 68/64/60/117/116/60 | 485 | LIFE_ORB | CORROSION | NASTY_PLOT, FIRE_BLAST, SLUDGE_BOMB, TOXIC | 46656 |
| CROBAT | 85 | 255 | 6192 | 85/90/80/130/70/80 | 535 | LEFTOVERS | INFILTRATOR | BRAVE_BIRD, CROSS_POISON, HYPNOSIS, CONFUSE_RAY | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_KOGA` — [maps/KogasRoom.asm:46](../../../maps/KogasRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/KogasRoom.asm:52](../../../maps/KogasRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/KogasRoom.asm:67](../../../maps/KogasRoom.asm#L67)

## Lance

Map `LancesRoom`; class `CHAMPION`; party `Champion:1`; ace 73; itinerary cap 100. [maps/LancesRoom.asm:62](../../../maps/LancesRoom.asm#L62).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HAXORUS | 70 | 243 | 4860 | 76/147/90/97/60/70 | 540 | LIFE_ORB | MOLD_BREAKER | OUTRAGE, EARTHQUAKE, POISON_JAB, DRAGON_DANCE | 24336 |
| ARCHALUDON | 71 | 255 | 5172 | 90/105/130/85/125/65 | 600 | LEFTOVERS | STAMINA | BODY_PRESS, FLASH_CANNON, DRAGON_PULSE, THUNDERBOLT | 24336 |
| SALAMENCE | 71 | 255 | 5172 | 95/135/80/100/110/80 | 600 | LIFE_ORB | AERILATE | DOUBLE_EDGE, DRAGON_CLAW, EARTHQUAKE, FIRE_BLAST | 24336 |
| DRAGAPULT | 72 | 255 | 5244 | 88/120/75/142/100/75 | 600 | SCOPE_LENS | INFILTRATOR | DRAGON_DARTS, SHADOW_BALL, U_TURN, THUNDERBOLT | 24336 |
| BAXCALIBUR | 72 | 255 | 5244 | 115/145/92/87/75/86 | 600 | LEFTOVERS | THERMAL_EXCHANGE | ICICLE_CRASH, DRAGON_CLAW, EARTHQUAKE, ICE_SHARD | 24336 |
| DRAGONITE | 73 | 255 | 5318 | 91/134/95/80/100/100 | 600 | GOLD_BERRY | MULTISCALE | OUTRAGE, EXTREMESPEED, EARTHQUAKE, DRAGON_DANCE | 24336 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/LancesRoom.asm:60](../../../maps/LancesRoom.asm#L60)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/LancesRoom.asm:71](../../../maps/LancesRoom.asm#L71)
- `checkevent EVENT_OPENED_MT_SILVER` — [maps/LancesRoom.asm:75](../../../maps/LancesRoom.asm#L75)
- `checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` — [maps/LancesRoom.asm:77](../../../maps/LancesRoom.asm#L77)
- `changeblock 4, 0, $0b` — [maps/LancesRoom.asm:94](../../../maps/LancesRoom.asm#L94)
- `special FadeOutPalettes` — [maps/LancesRoom.asm:150](../../../maps/LancesRoom.asm#L150)

## Lance rematch

Map `LancesRoom`; class `CHAMPION_REMATCH`; party `Champion:2`; ace 87; itinerary cap 100. [maps/LancesRoom.asm:65](../../../maps/LancesRoom.asm#L65).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HYDREIGON | 85 | 255 | 6192 | 92/105/90/98/125/90 | 600 | LIFE_ORB | BERSERK | NASTY_PLOT, DRACO_METEOR, HEAT_WAVE, DARK_PULSE | 46656 |
| ARCHALUDON | 86 | 255 | 6264 | 90/105/130/85/125/65 | 600 | LEFTOVERS | STAMINA | BODY_PRESS, FLASH_CANNON, DRACO_METEOR, THUNDERBOLT | 46656 |
| SALAMENCE | 86 | 255 | 6264 | 95/135/80/100/110/80 | 600 | LIFE_ORB | AERILATE | DRAGON_DANCE, DOUBLE_EDGE, DRAGON_CLAW, EARTHQUAKE | 46656 |
| DRAGAPULT | 87 | 255 | 6338 | 88/120/75/142/100/75 | 600 | LIFE_ORB | INFILTRATOR | DRAGON_DARTS, FLAMETHROWER, PHANTOMFORCE, CRUNCH | 46656 |
| BAXCALIBUR | 87 | 255 | 6338 | 115/145/92/87/75/86 | 600 | LEFTOVERS | THERMAL_EXCHANGE | DRAGON_DANCE, ICICLE_CRASH, DRAGON_CLAW, EARTHQUAKE | 46656 |
| DRAGONITE | 87 | 255 | 6338 | 91/134/95/80/100/100 | 600 | LEFTOVERS | MULTISCALE | DRAGON_DANCE, OUTRAGE, EXTREMESPEED, EARTHQUAKE | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/LancesRoom.asm:60](../../../maps/LancesRoom.asm#L60)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/LancesRoom.asm:71](../../../maps/LancesRoom.asm#L71)
- `checkevent EVENT_OPENED_MT_SILVER` — [maps/LancesRoom.asm:75](../../../maps/LancesRoom.asm#L75)
- `checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` — [maps/LancesRoom.asm:77](../../../maps/LancesRoom.asm#L77)
- `changeblock 4, 0, $0b` — [maps/LancesRoom.asm:94](../../../maps/LancesRoom.asm#L94)
- `special FadeOutPalettes` — [maps/LancesRoom.asm:150](../../../maps/LancesRoom.asm#L150)

## Pryce

Map `MahoganyGym`; class `PRYCE`; party `Pryce:1`; ace 38; itinerary cap 38. [maps/MahoganyGym.asm:24](../../../maps/MahoganyGym.asm#L24).

Route42 fisherman checks Jasmine; Rocket Hideout story


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| NINETALES_ALOLAN | 35 | 177 | 1770 | 73/67/75/109/81/100 | 505 | ICY_ROCK | SNOW_WARNING | ICE_BEAM, DAZZLING_GLEAM, CONFUSE_RAY, ICY_WIND | 14400 |
| DEWGONG | 36 | 166 | 1706 | 110/80/80/80/80/95 | 525 | NO_ITEM | THICK_FAT | SURF, FREEZE_DRY, REST, SLEEP_TALK | 14400 |
| CETITAN | 36 | 182 | 1872 | 170/113/65/73/45/55 | 521 | LEFTOVERS | THICK_FAT | ICE_SHARD, LIQUIDATION, ICICLE_CRASH, KNOCK_OFF | 14400 |
| GLACEON | 37 | 184 | 1944 | 65/60/110/95/130/65 | 525 | NO_ITEM | REFRIGERATE | FREEZE_DRY, HYPER_VOICE, EARTH_POWER, PROTECT | 14400 |
| ABOMASNOW | 37 | 173 | 1828 | 90/92/75/60/92/85 | 494 | NO_ITEM | THICK_FAT | ICE_BEAM, GIGA_DRAIN, ICE_SHARD, ROCK_SLIDE | 14400 |
| MAMOSWINE | 38 | 255 | 2768 | 110/130/80/80/70/60 | 530 | GOLD_BERRY | THICK_FAT | EARTHQUAKE, ICICLE_CRASH, ROCK_SLIDE, ICE_SHARD | 14400 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_PRYCE` — [maps/MahoganyGym.asm:18](../../../maps/MahoganyGym.asm#L18)
- `readvar VAR_BADGES` — [maps/MahoganyGym.asm:33](../../../maps/MahoganyGym.asm#L33)
- `checkevent EVENT_GOT_TM16_ICICLE_CRASH` — [maps/MahoganyGym.asm:36](../../../maps/MahoganyGym.asm#L36)

## Pryce rematch

Map `MahoganyGym`; class `PRYCE_REMATCH`; party `Pryce:2`; ace 83; itinerary cap 100. [maps/MahoganyGym.asm:63](../../../maps/MahoganyGym.asm#L63).

Route42 fisherman checks Jasmine; Rocket Hideout story


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| NINETALES_ALOLAN | 81 | 177 | 4096 | 73/67/75/109/81/100 | 505 | ICY_ROCK | SNOW_WARNING | BLIZZARD, MOONBLAST, FREEZE_DRY, NASTY_PLOT | 44944 |
| CLOYSTER | 81 | 184 | 4258 | 50/95/180/70/85/45 | 525 | LIFE_ORB | SKILL_LINK | SHELL_SMASH, ICICLE_SPEAR, ROCK_BLAST, ICE_SHARD | 44944 |
| GLACEON | 82 | 184 | 4310 | 65/60/110/95/130/65 | 525 | LIFE_ORB | SLUSH_RUSH | BLIZZARD, FREEZE_DRY, EARTH_POWER, MIRROR_COAT | 44944 |
| WEAVILE | 82 | 179 | 4192 | 70/120/65/125/45/85 | 510 | LIFE_ORB | TECHNICIAN | ICICLE_CRASH, KNOCK_OFF, NIGHT_SLASH, ICE_SHARD | 44944 |
| LAPRAS | 83 | 187 | 4434 | 130/85/80/60/85/95 | 535 | ASSAULT_VEST | WATER_ABSORB | ICE_BEAM, SURF, THUNDERBOLT, DRAGON_PULSE | 44944 |
| MAMOSWINE | 83 | 255 | 6046 | 110/130/80/80/70/60 | 530 | LIFE_ORB | THICK_FAT | ICICLE_CRASH, EARTHQUAKE, ICE_SHARD, SUPERPOWER | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_PRYCE_REMATCH` — [maps/MahoganyGym.asm:54](../../../maps/MahoganyGym.asm#L54)
- `checkevent EVENT_BEAT_JASMINE_REMATCH` — [maps/MahoganyGym.asm:56](../../../maps/MahoganyGym.asm#L56)

## ? (MountMoon)

Map `MountMoon`; class `RIVAL2`; party `Rival2:3`; ace 53; itinerary cap 54. [maps/MountMoon.asm:39](../../../maps/MountMoon.asm#L39).

Route3 east from Pewter; Brock not checked in map script


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GOLBAT | 49 | 159 | 2226 | 75/80/70/90/65/75 | 455 | EVIOLITE | INNER_FOCUS | BRAVE_BIRD, CROSS_POISON, U_TURN, ROOST | 40000 |
| MAGNEZONE | 50 | 255 | 3642 | 70/70/115/60/130/90 | 535 | MAGNET | LEVITATE | THUNDERBOLT, FLASH_CANNON, TRI_ATTACK, THUNDER_WAVE | 40000 |
| SLOWKING_GALARIAN | 51 | 172 | 2506 | 95/65/80/30/110/110 | 490 | LEFTOVERS | UNAWARE | PSYCHIC_M, SLUDGE_BOMB, FLAMETHROWER, RECOVER | 40000 |
| WEAVILE | 51 | 179 | 2608 | 70/120/65/125/45/85 | 510 | NEVERMELTICE | TECHNICIAN | ICE_SHARD, FAINT_ATTACK, ICICLE_CRASH, LOW_KICK | 40000 |
| CERULEDGE | 51 | 255 | 3714 | 75/125/80/85/60/100 | 525 | CHARCOAL | SHARPNESS | BITTER_BLADE, PHANTOMFORCE, PSYCHO_CUT, SHADOW_SNEAK | 40000 |
| FERALIGATR | 53 | 255 | 3860 | 85/110/100/78/79/83 | 535 | MYSTIC_WATER | SHEER_FORCE | WATERFALL, ICE_PUNCH, CRUNCH, ROCK_SLIDE | 40000 |


Script predicates / event evidence:

- `special FadeOutMusic` — [maps/MountMoon.asm:21](../../../maps/MountMoon.asm#L21)
- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/MountMoon.asm:29](../../../maps/MountMoon.asm#L29)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/MountMoon.asm:31](../../../maps/MountMoon.asm#L31)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/MountMoon.asm:33](../../../maps/MountMoon.asm#L33)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/MountMoon.asm:35](../../../maps/MountMoon.asm#L35)
- `setscene SCENE_FINISHED` — [maps/MountMoon.asm:71](../../../maps/MountMoon.asm#L71)

## Jasmine

Map `OlivineGym`; class `JASMINE`; party `Jasmine:1`; ace 34; itinerary cap 34. [maps/OlivineGym.asm:39](../../../maps/OlivineGym.asm#L39).

Routes38-39; accessible before Morty; pharmacy Surf trip for Jasmine


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| SKARMORY | 31 | 163 | 1442 | 85/90/140/70/40/70 | 495 | NO_ITEM | IRON_BARBS | STEEL_WING, DRILL_PECK, PURSUIT, U_TURN | 11664 |
| LAIRON | 31 | 151 | 1336 | 60/90/140/40/50/50 | 430 | NO_ITEM | ROCK_HEAD | DOUBLE_EDGE, IRON_TAIL, ROCK_SLIDE, BULLDOZE | 11664 |
| MAGNETON | 32 | 163 | 1490 | 50/60/95/70/120/70 | 465 | NO_ITEM | LEVITATE | VOLT_SWITCH, FLASH_CANNON, SUPERSONIC, THUNDER_WAVE | 11664 |
| TINKATUFF | 33 | 133 | 1254 | 65/55/55/78/45/82 | 380 | NO_ITEM | MOLD_BREAKER | PLAY_ROUGH, IRON_HEAD, ROCK_SLIDE, KNOCK_OFF | 11664 |
| STEELIX | 34 | 179 | 1738 | 75/105/200/30/45/65 | 520 | QUICK_CLAW | STURDY | IRON_TAIL, BULLDOZE, ROCK_SLIDE, CRUNCH | 11664 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_JASMINE` — [maps/OlivineGym.asm:33](../../../maps/OlivineGym.asm#L33)
- `readvar VAR_BADGES` — [maps/OlivineGym.asm:48](../../../maps/OlivineGym.asm#L48)
- `checkevent EVENT_GOT_TM23_IRON_HEAD` — [maps/OlivineGym.asm:51](../../../maps/OlivineGym.asm#L51)
- `checkevent EVENT_GOT_METAL_COAT_FROM_JASMINE` — [maps/OlivineGym.asm:61](../../../maps/OlivineGym.asm#L61)
- `checkevent EVENT_GOT_METAL_COAT_FROM_JASMINE` — [maps/OlivineGym.asm:75](../../../maps/OlivineGym.asm#L75)
- `checkevent EVENT_BEAT_JASMINE_REMATCH` — [maps/OlivineGym.asm:77](../../../maps/OlivineGym.asm#L77)
- `checkevent EVENT_BEAT_CHUCK_REMATCH` — [maps/OlivineGym.asm:79](../../../maps/OlivineGym.asm#L79)

## Jasmine rematch

Map `OlivineGym`; class `JASMINE_REMATCH`; party `Jasmine:2`; ace 82; itinerary cap 100. [maps/OlivineGym.asm:86](../../../maps/OlivineGym.asm#L86).

Routes38-39; accessible before Morty; pharmacy Surf trip for Jasmine


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MAGNEZONE | 80 | 255 | 5828 | 70/70/115/60/130/90 | 535 | WISE_GLASSES | LEVITATE | THUNDERBOLT, FLASH_CANNON, THUNDER_WAVE, SIGNAL_BEAM | 44944 |
| CORVIKNIGHT | 80 | 248 | 5668 | 98/87/105/67/53/85 | 495 | LEFTOVERS | MIRROR_ARMOR | BRAVE_BIRD, BODY_PRESS, IRON_DEFENSE, ROOST | 44944 |
| EXCADRILL | 81 | 178 | 4118 | 110/135/60/88/50/65 | 508 | LIFE_ORB | MOLD_BREAKER | SWORDS_DANCE, EARTHQUAKE, IRON_HEAD, ROCK_SLIDE | 44944 |
| LUCARIO | 81 | 184 | 4258 | 70/110/70/90/115/70 | 525 | LIFE_ORB | ADAPTABILITY | NASTY_PLOT, AURA_SPHERE, FLASH_CANNON, DRAGON_PULSE | 44944 |
| TINKATON | 82 | 253 | 5926 | 85/75/77/94/70/105 | 506 | LIFE_ORB | MOLD_BREAKER | GIGA_HAMMER, PLAY_ROUGH, KNOCK_OFF, IRON_HEAD | 44944 |
| STEELIX | 82 | 179 | 4192 | 75/105/200/30/45/65 | 520 | LEFTOVERS | STURDY | EARTHQUAKE, IRON_HEAD, BODY_PRESS, CRUNCH | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_JASMINE` — [maps/OlivineGym.asm:33](../../../maps/OlivineGym.asm#L33)
- `readvar VAR_BADGES` — [maps/OlivineGym.asm:48](../../../maps/OlivineGym.asm#L48)
- `checkevent EVENT_GOT_TM23_IRON_HEAD` — [maps/OlivineGym.asm:51](../../../maps/OlivineGym.asm#L51)
- `checkevent EVENT_GOT_METAL_COAT_FROM_JASMINE` — [maps/OlivineGym.asm:61](../../../maps/OlivineGym.asm#L61)
- `checkevent EVENT_GOT_METAL_COAT_FROM_JASMINE` — [maps/OlivineGym.asm:75](../../../maps/OlivineGym.asm#L75)
- `checkevent EVENT_BEAT_JASMINE_REMATCH` — [maps/OlivineGym.asm:77](../../../maps/OlivineGym.asm#L77)
- `checkevent EVENT_BEAT_CHUCK_REMATCH` — [maps/OlivineGym.asm:79](../../../maps/OlivineGym.asm#L79)

## Red Pallet

Map `PalletTown`; class `RED2`; party `Red2:1`; ace 85; itinerary cap 100. [maps/PalletTown.asm:43](../../../maps/PalletTown.asm#L43).

southern Viridian road needs Brock/Misty/Surge/Erika/Janine/Sabrina


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| PIKACHU | 83 | 112 | 2656 | 35/65/40/90/60/50 | 340 | LIGHT_BALL | GALVANIZE | EXTREMESPEED, HYPER_VOICE, SURF, PLAY_ROUGH | 46656 |
| SNORLAX | 84 | 189 | 4536 | 160/110/65/30/65/110 | 540 | LEFTOVERS | THICK_FAT | CURSE, GIGA_IMPACT, EARTHQUAKE, REST | 46656 |
| ESPEON | 84 | 184 | 4416 | 65/65/60/110/130/95 | 525 | LIFE_ORB | MAGIC_BOUNCE | PSYCHIC_M, SHADOW_BALL, DAZZLING_GLEAM, SIGNAL_BEAM | 46656 |
| LAPRAS | 85 | 187 | 4540 | 130/85/80/60/85/95 | 535 | ASSAULT_VEST | WATER_ABSORB | FREEZE_DRY, BLIZZARD, THUNDERBOLT, MEGAHORN | 46656 |
| AERODACTYL | 85 | 180 | 4370 | 80/105/65/130/60/75 | 515 | LIFE_ORB | STRONG_JAW | CRUNCH, THUNDER_FANG, SKY_ATTACK, STONE_EDGE | 46656 |
| CHARIZARD | 85 | 255 | 6192 | 78/84/78/100/110/85 | 535 | LIFE_ORB | DROUGHT | FIRE_BLAST, SOLARBEAM, EARTHQUAKE, DRACO_METEOR | 46656 |


Script predicates / event evidence:

- `special FadeOutMusic` — [maps/PalletTown.asm:36](../../../maps/PalletTown.asm#L36)
- `special FadeOutMusic` — [maps/PalletTown.asm:47](../../../maps/PalletTown.asm#L47)
- `special FadeBlackQuickly` — [maps/PalletTown.asm:52](../../../maps/PalletTown.asm#L52)
- `special ReloadSpritesNoPalettes` — [maps/PalletTown.asm:53](../../../maps/PalletTown.asm#L53)
- `special FadeInQuickly` — [maps/PalletTown.asm:57](../../../maps/PalletTown.asm#L57)
- `special HealParty` — [maps/PalletTown.asm:59](../../../maps/PalletTown.asm#L59)

## Brock

Map `PewterGym`; class `BROCK`; party `Brock:1`; ace 50; itinerary cap 50. [maps/PewterGym.asm:20](../../../maps/PewterGym.asm#L20).

Route2/forest


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| AERODACTYL | 47 | 180 | 2416 | 80/105/65/130/60/75 | 515 | FOCUS_SASH | ROCK_HEAD | STEALTH_ROCK, HEAD_SMASH, EARTHQUAKE, CRUNCH | 41616 |
| CRADILY | 48 | 173 | 2372 | 86/81/97/43/86/107 | 500 | LEFTOVERS | STORM_DRAIN | GIGA_DRAIN, POWER_GEM, TOXIC, RECOVER | 41616 |
| STEELIX | 48 | 179 | 2454 | 75/105/200/30/45/65 | 520 | LEFTOVERS | STURDY | EARTHQUAKE, IRON_HEAD, BODY_PRESS, ROCK_SLIDE | 41616 |
| BASTIODON | 49 | 173 | 2422 | 75/27/168/30/77/138 | 515 | LEFTOVERS | STURDY | BODY_PRESS, POWER_GEM, TOXIC, PROTECT | 41616 |
| ARMALDO | 49 | 173 | 2422 | 75/125/100/50/70/80 | 500 | EXPERT_BELT | TOUGH_CLAWS | X_SCISSOR, STONE_EDGE, EARTHQUAKE, SWORDS_DANCE | 41616 |
| GOLEM | 50 | 248 | 3542 | 80/120/130/45/55/65 | 495 | ROCKY_HELMET | STURDY | STONE_EDGE, EARTHQUAKE, FIRE_PUNCH, EXPLOSION | 41616 |


Script predicates / event evidence:

- `checkflag ENGINE_BOULDERBADGE` — [maps/PewterGym.asm:14](../../../maps/PewterGym.asm#L14)

## PROTON (RadioTower4F)

Map `RadioTower4F`; class `PROTON`; party `Proton:2`; ace 42; itinerary cap 45. [maps/RadioTower4F.asm:68](../../../maps/RadioTower4F.asm#L68).

7 badges activates Rocket takeover; Basement and Card Keys


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GRIMMSNARL | 40 | 255 | 2914 | 95/120/75/60/75/85 | 510 | NO_ITEM | PRANKSTER | SPIRIT_BREAK, SUCKER_PUNCH, THUNDER_WAVE, BULK_UP | 14400 |
| PERRSERKER | 40 | 154 | 1760 | 85/110/100/50/50/80 | 475 | NO_ITEM | STEELY_SPIRIT | IRON_HEAD, BULLET_PUNCH, SEED_BOMB, BRICK_BREAK | 14400 |
| ZANGOOSE | 41 | 160 | 1874 | 75/115/60/100/60/60 | 470 | NO_ITEM | SHARPNESS | SLASH, X_SCISSOR, KNOCK_OFF, SWORDS_DANCE | 14400 |
| SNEASLER | 42 | 179 | 2148 | 80/130/60/120/40/80 | 510 | NO_ITEM | TECHNICIAN | MACH_PUNCH, DRAIN_PUNCH, POISON_FANG, X_SCISSOR | 14400 |

## PETREL (RadioTower5F)

Map `RadioTower5F`; class `PETREL_DIRECTOR`; party `PetrelDirector:1`; ace 42; itinerary cap 45. [maps/RadioTower5F.asm:52](../../../maps/RadioTower5F.asm#L52).

7 badges activates Rocket takeover; Basement and Card Keys


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MUK_ALOLAN | 40 | 175 | 2000 | 105/105/75/50/65/100 | 500 | NO_ITEM | POISON_PUPPETEER | POISON_JAB, KNOCK_OFF, SHADOW_SNEAK, TOXIC | 13456 |
| PORYGON_Z | 40 | 255 | 2914 | 85/76/70/99/135/70 | 535 | NO_ITEM | ADAPTABILITY | TRI_ATTACK, DARK_PULSE, THUNDERBOLT, NASTY_PLOT | 13456 |
| BANETTE | 41 | 159 | 1862 | 64/125/65/70/93/63 | 480 | NO_ITEM | PRANKSTER | SHADOW_CLAW, KNOCK_OFF, WILL_O_WISP, ENCORE | 13456 |
| DITTO | 42 | 101 | 1212 | 48/48/48/48/48/48 | 288 | NO_ITEM | IMPOSTER | TRANSFORM, NO_MOVE, NO_MOVE, NO_MOVE | 13456 |


Script predicates / event evidence:

- `setscene SCENE_RADIOTOWER5F_ROCKET_BOSS` — [maps/RadioTower5F.asm:60](../../../maps/RadioTower5F.asm#L60)

## ARIANA (RadioTower5F)

Map `RadioTower5F`; class `ARIANA`; party `Ariana:2`; ace 43; itinerary cap 45. [maps/RadioTower5F.asm:81](../../../maps/RadioTower5F.asm#L81).

7 badges activates Rocket takeover; Basement and Card Keys


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HONCHKROW | 42 | 177 | 2124 | 100/125/52/71/115/52 | 515 | SHARP_BEAK | MOXIE | BRAVE_BIRD, SUCKER_PUNCH, SUPERPOWER, ROOST | 15376 |
| SALAZZLE | 42 | 168 | 2016 | 68/64/60/117/116/60 | 485 | CHARCOAL | CORROSION | FLAMETHROWER, VENOSHOCK, TOXIC, NASTY_PLOT | 15376 |
| MILOTIC | 43 | 189 | 2322 | 95/60/79/81/100/125 | 540 | MYSTIC_WATER | COMPETITIVE | SCALD, MOONBLAST, RECOVER, HYPNOSIS | 15376 |
| TOXAPEX | 43 | 173 | 2124 | 50/63/152/35/53/142 | 495 | LEFTOVERS | REGENERATOR | SCALD, BODY_PRESS, TOXIC_SPIKES, RECOVER | 15376 |
| WEAVILE | 43 | 179 | 2198 | 70/120/65/125/45/85 | 510 | MUSCLE_BAND | TECHNICIAN | TRIPLE_AXEL, NIGHT_SLASH, ICE_SHARD, LOW_KICK | 15376 |

## ARCHER (RadioTower5F)

Map `RadioTower5F`; class `ARCHER`; party `Archer:2`; ace 43; itinerary cap 45. [maps/RadioTower5F.asm:101](../../../maps/RadioTower5F.asm#L101).

7 badges activates Rocket takeover; Basement and Card Keys


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CROBAT | 41 | 255 | 2986 | 85/90/80/130/70/80 | 535 | SHARP_BEAK | MERCILESS | TOXIC, POISON_JAB, DUALWINGBEAT, ROOST | 15376 |
| DUSKNOIR | 41 | 255 | 2986 | 60/100/135/45/65/135 | 540 | LEFTOVERS | IRON_FIST | SHADOW_PUNCH, ICE_PUNCH, THUNDERPUNCH, WILL_O_WISP | 15376 |
| KINGAMBIT | 42 | 255 | 3060 | 100/135/120/50/60/85 | 550 | BLACKGLASSES | SHARPNESS | IRON_HEAD, NIGHT_SLASH, BRICK_BREAK, SLASH | 15376 |
| KROOKODILE | 42 | 234 | 2808 | 95/117/80/92/65/70 | 519 | BLACKGLASSES | INTIMIDATE | EARTHQUAKE, CRUNCH, ROCK_SLIDE, TAUNT | 15376 |
| HOUNDOOM | 43 | 175 | 2150 | 75/100/50/95/110/80 | 510 | CHARCOAL | ADAPTABILITY | FLAMETHROWER, DARK_PULSE, SUCKER_PUNCH, TAUNT | 15376 |


Script predicates / event evidence:

- `special FadeBlackQuickly` — [maps/RadioTower5F.asm:108](../../../maps/RadioTower5F.asm#L108)
- `special ReloadSpritesNoPalettes` — [maps/RadioTower5F.asm:109](../../../maps/RadioTower5F.asm#L109)
- `special FadeInQuickly` — [maps/RadioTower5F.asm:115](../../../maps/RadioTower5F.asm#L115)
- `special PlayMapMusic` — [maps/RadioTower5F.asm:128](../../../maps/RadioTower5F.asm#L128)
- `setscene SCENE_RADIOTOWER5F_NOTHING` — [maps/RadioTower5F.asm:141](../../../maps/RadioTower5F.asm#L141)
- `setmapscene ECRUTEAK_TIN_TOWER_ENTRANCE, SCENE_DEFAULT` — [maps/RadioTower5F.asm:142](../../../maps/RadioTower5F.asm#L142)

## Green

Map `Route20`; class `GREEN`; party `Green:1`; ace 82; itinerary cap 100. [maps/Route20.asm:54](../../../maps/Route20.asm#L54).

Route 20; links in map_edges.csv; script conditions in access_conditions.csv


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| WIGGLYTUFF | 80 | 218 | 4982 | 115/60/75/55/88/80 | 473 | ASSAULT_VEST | MAGIC_GUARD | HYPER_VOICE, DAZZLING_GLEAM, THUNDERBOLT, ICE_BEAM | 46656 |
| UMBREON | 81 | 184 | 4258 | 95/65/110/65/60/130 | 525 | LEFTOVERS | MAGIC_GUARD | FOUL_PLAY, TOXIC, MOONLIGHT, CONFUSE_RAY | 46656 |
| NIDOQUEEN | 81 | 253 | 5854 | 90/92/87/81/75/85 | 510 | LIFE_ORB | SHEER_FORCE | EARTH_POWER, SLUDGE_BOMB, ICE_BEAM, FLAMETHROWER | 46656 |
| MESMERIA | 82 | 190 | 4450 | 75/50/45/105/135/105 | 515 | LIFE_ORB | BAD_DREAMS | HYPNOSIS, PSYCHIC_M, ICE_BEAM, DREAM_EATER | 46656 |
| LANTURN | 82 | 161 | 3772 | 125/58/70/67/96/76 | 492 | ASSAULT_VEST | VOLT_ABSORB | SURF, THUNDERBOLT, ICE_BEAM, FLASH_CANNON | 46656 |
| VENUSAUR | 82 | 255 | 5974 | 80/82/83/80/110/100 | 535 | LEFTOVERS | THICK_FAT | GIGA_DRAIN, SLUDGE_BOMB, SLEEP_POWDER, SYNTHESIS | 46656 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_GREEN` — [maps/Route20.asm:48](../../../maps/Route20.asm#L48)

## Crystal Cape

Map `Route25`; class `CRYSTAL3`; party `Crystal:13`; ace 70; itinerary cap 100. [maps/Route25.asm:255](../../../maps/Route25.asm#L255).

Route 25; links in map_edges.csv; script conditions in access_conditions.csv


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MEGANIUM | 70 | 255 | 5100 | 80/82/100/80/93/100 | 535 | LEFTOVERS | SERENE_GRACE | GIGA_DRAIN, BODY_SLAM, SYNTHESIS, LEECH_SEED | 43264 |
| HYDRAPPLE | 68 | 255 | 4954 | 106/70/90/66/130/80 | 542 | LEFTOVERS | REGENERATOR | APPLE_ACID, DRAGON_PULSE, RECOVER, SUBSTITUTE | 43264 |
| TYRANITAR | 69 | 255 | 5026 | 100/134/110/61/95/100 | 600 | ASSAULT_VEST | SAND_STREAM | CRUNCH, ROCK_SLIDE, EARTHQUAKE, ICE_PUNCH | 43264 |
| MAROWAK | 69 | 149 | 2936 | 60/80/110/45/50/80 | 425 | THICK_CLUB | BATTLE_ARMOR | BONEMERANG, ROCK_SLIDE, FIRE_PUNCH, SWORDS_DANCE | 43264 |
| XATU | 68 | 165 | 3204 | 80/75/70/95/95/70 | 485 | LEFTOVERS | MAGIC_BOUNCE | PSYCHIC_M, AIR_SLASH, ROOST, THUNDER_WAVE | 43264 |
| LANTURN | 68 | 161 | 3128 | 125/58/70/67/96/76 | 492 | LEFTOVERS | VOLT_ABSORB | SURF, THUNDERBOLT, ICE_BEAM, CONFUSE_RAY | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/Route25.asm:247](../../../maps/Route25.asm#L247)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/Route25.asm:249](../../../maps/Route25.asm#L249)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/Route25.asm:251](../../../maps/Route25.asm#L251)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/Route25.asm:253](../../../maps/Route25.asm#L253)
- `farscall QueueOakMtSilverCallScript` — [maps/Route25.asm:271](../../../maps/Route25.asm#L271)
- `checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE` — [maps/Route25.asm:277](../../../maps/Route25.asm#L277)

## Sabrina

Map `SaffronGym`; class `SABRINA`; party `Sabrina:1`; ace 62; itinerary cap 62. [maps/SaffronGym.asm:23](../../../maps/SaffronGym.asm#L23).

Route5; road blocker requires Misty + Machine Part


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MESMERIA | 59 | 190 | 3202 | 75/50/45/105/135/105 | 515 | LEFTOVERS | BAD_DREAMS | HYPNOSIS, PSYCHIC_M, ICE_BEAM, DREAM_EATER | 41616 |
| GARDEVOIR | 60 | 255 | 4370 | 68/65/65/80/125/115 | 518 | LIFE_ORB | PIXILATE | HYPER_VOICE, PSYCHIC_M, SHADOW_BALL, CALM_MIND | 41616 |
| FARIGIRAF | 60 | 255 | 4370 | 120/90/70/85/110/70 | 545 | LEFTOVERS | ARMOR_TAIL | PSYCHIC_M, CRUNCH, HYPER_VOICE, CALM_MIND | 41616 |
| HYPNO | 61 | 169 | 2944 | 85/73/70/67/73/115 | 483 | LEFTOVERS | NO_GUARD | HYPNOSIS, DREAM_EATER, PSYCHIC_M, SHADOW_BALL | 41616 |
| WOBBUFFET | 61 | 142 | 2474 | 190/33/58/33/33/58 | 405 | LEFTOVERS | SHADOW_TAG | COUNTER, MIRROR_COAT, SAFEGUARD, DESTINY_BOND | 41616 |
| ALAKAZAM | 62 | 250 | 4428 | 55/50/45/120/135/95 | 500 | LIFE_ORB | MAGIC_GUARD | PSYCHIC_M, SHADOW_BALL, FOCUS_BLAST, RECOVER | 41616 |


Script predicates / event evidence:

- `checkflag ENGINE_MARSHBADGE` — [maps/SaffronGym.asm:17](../../../maps/SaffronGym.asm#L17)

## Blaine

Map `SeafoamGym`; class `BLAINE`; party `Blaine:1`; ace 66; itinerary cap 66. [maps/SeafoamGym.asm:27](../../../maps/SeafoamGym.asm#L27).

Route20; Blaine gym


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| NINETALES | 63 | 177 | 3186 | 73/67/75/109/81/100 | 505 | CHARCOAL | DROUGHT | FLAMETHROWER, SOLARBEAM, WILL_O_WISP, NASTY_PLOT | 41616 |
| ARCANINE | 64 | 194 | 3546 | 90/110/80/95/100/80 | 555 | LIFE_ORB | INTIMIDATE | FLARE_BLITZ, EXTREMESPEED, CLOSE_COMBAT, WILD_CHARGE | 41616 |
| ARMAROUGE | 64 | 255 | 4662 | 85/60/100/75/125/80 | 525 | WISE_GLASSES | MEGA_LAUNCHER | ARMOR_CANNON, PSYCHIC_M, AURA_SPHERE, CALM_MIND | 41616 |
| TORKOAL | 65 | 165 | 3064 | 70/85/140/20/85/70 | 470 | LEFTOVERS | DROUGHT | FLAMETHROWER, SOLARBEAM, EARTH_POWER, BODY_PRESS | 41616 |
| RAPIDASH | 65 | 175 | 3250 | 65/105/70/115/80/80 | 515 | LIFE_ORB | RECKLESS | FLARE_BLITZ, DOUBLE_EDGE, WILD_CHARGE, MEGAHORN | 41616 |
| MAGMORTAR | 66 | 255 | 4808 | 75/95/67/83/125/95 | 540 | LIFE_ORB | FLASH_FIRE | FIRE_BLAST, THUNDERBOLT, FOCUS_BLAST, SOLARBEAM | 41616 |


Script predicates / event evidence:

- `checkflag ENGINE_VOLCANOBADGE` — [maps/SeafoamGym.asm:21](../../../maps/SeafoamGym.asm#L21)

## Agatha

Map `SilverCaveOutside`; class `AGATHA`; party `Agatha:1`; ace 87; itinerary cap 100. [maps/SilverCaveOutside.asm:34](../../../maps/SilverCaveOutside.asm#L34).

Oak opens region after first League + Johto rematches + Cape Crystal; cave floors additionally after Agatha and Lorelei


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GENGAR | 85 | 250 | 6070 | 60/65/60/110/130/75 | 500 | FOCUS_SASH | LEVITATE | SHADOW_BALL, SLUDGE_BOMB, THUNDERBOLT, DESTINY_BOND | 43264 |
| MISDREAVUS | 86 | 87 | 2136 | 60/60/60/85/85/85 | 435 | EVIOLITE | PRANKSTER | WILL_O_WISP, SHADOW_BALL, CONFUSE_RAY, PAIN_SPLIT | 43264 |
| ARBOK | 86 | 157 | 3856 | 70/110/75/80/55/80 | 470 | LEFTOVERS | INTIMIDATE | GUNK_SHOT, CRUNCH, EARTHQUAKE, GLARE | 43264 |
| CROBAT | 87 | 255 | 6338 | 85/90/80/130/70/80 | 535 | LEFTOVERS | INFILTRATOR | CROSS_POISON, BRAVE_BIRD, U_TURN, ROOST | 43264 |
| HAUNTER | 87 | 142 | 3528 | 45/50/45/95/115/55 | 405 | SPELL_TAG | LEVITATE | HYPNOSIS, SHADOW_BALL, SLUDGE_BOMB, DREAM_EATER | 43264 |
| GENGAR | 87 | 250 | 6214 | 60/65/60/110/130/75 | 500 | LIFE_ORB | LEVITATE | NASTY_PLOT, SHADOW_BALL, SLUDGE_BOMB, FOCUS_BLAST | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_AGATHA` — [maps/SilverCaveOutside.asm:24](../../../maps/SilverCaveOutside.asm#L24)
- `checkevent EVENT_BEAT_LORELEI` — [maps/SilverCaveOutside.asm:48](../../../maps/SilverCaveOutside.asm#L48)
- `special FadeBlackQuickly` — [maps/SilverCaveOutside.asm:56](../../../maps/SilverCaveOutside.asm#L56)
- `special ReloadSpritesNoPalettes` — [maps/SilverCaveOutside.asm:57](../../../maps/SilverCaveOutside.asm#L57)
- `special StubbedTrainerRankings_Healings` — [maps/SilverCaveOutside.asm:58](../../../maps/SilverCaveOutside.asm#L58)
- `special HealParty` — [maps/SilverCaveOutside.asm:60](../../../maps/SilverCaveOutside.asm#L60)
- `special FadeInQuickly` — [maps/SilverCaveOutside.asm:62](../../../maps/SilverCaveOutside.asm#L62)
- `special RestartMapMusic` — [maps/SilverCaveOutside.asm:63](../../../maps/SilverCaveOutside.asm#L63)
- `setscene SCENE_FINISHED` — [maps/SilverCaveOutside.asm:83](../../../maps/SilverCaveOutside.asm#L83)

## Lorelei

Map `SilverCaveOutside`; class `LORELEI`; party `Lorelei:1`; ace 87; itinerary cap 100. [maps/SilverCaveOutside.asm:70](../../../maps/SilverCaveOutside.asm#L70).

Oak opens region after first League + Johto rematches + Cape Crystal; cave floors additionally after Agatha and Lorelei


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| DEWGONG | 85 | 166 | 4030 | 110/80/80/80/80/95 | 525 | LEFTOVERS | THICK_FAT | SURF, ICE_BEAM, REST, SLEEP_TALK | 43264 |
| CLOYSTER | 86 | 184 | 4520 | 50/95/180/70/85/45 | 525 | LIFE_ORB | SKILL_LINK | SHELL_SMASH, ICICLE_SPEAR, ROCK_BLAST, ICE_SHARD | 43264 |
| SLOWBRO | 86 | 172 | 4226 | 95/75/110/30/100/80 | 490 | LEFTOVERS | REGENERATOR | CALM_MIND, SURF, ICE_BEAM, SLACK_OFF | 43264 |
| MESMERIA | 87 | 190 | 4722 | 75/50/45/105/135/105 | 515 | WISE_GLASSES | SYNCHRONIZE | NASTY_PLOT, ICE_BEAM, PSYCHIC_M, LOVELY_KISS | 43264 |
| LAPRAS | 87 | 187 | 4648 | 130/85/80/60/85/95 | 535 | ASSAULT_VEST | WATER_ABSORB | ICE_BEAM, SURF, THUNDERBOLT, FREEZE_DRY | 43264 |
| GLACEON | 87 | 184 | 4572 | 65/60/110/95/130/65 | 525 | LEFTOVERS | REFRIGERATE | ICE_BEAM, HYPER_VOICE, SHADOW_BALL, PROTECT | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_AGATHA` — [maps/SilverCaveOutside.asm:24](../../../maps/SilverCaveOutside.asm#L24)
- `checkevent EVENT_BEAT_LORELEI` — [maps/SilverCaveOutside.asm:48](../../../maps/SilverCaveOutside.asm#L48)
- `special FadeBlackQuickly` — [maps/SilverCaveOutside.asm:56](../../../maps/SilverCaveOutside.asm#L56)
- `special ReloadSpritesNoPalettes` — [maps/SilverCaveOutside.asm:57](../../../maps/SilverCaveOutside.asm#L57)
- `special StubbedTrainerRankings_Healings` — [maps/SilverCaveOutside.asm:58](../../../maps/SilverCaveOutside.asm#L58)
- `special HealParty` — [maps/SilverCaveOutside.asm:60](../../../maps/SilverCaveOutside.asm#L60)
- `special FadeInQuickly` — [maps/SilverCaveOutside.asm:62](../../../maps/SilverCaveOutside.asm#L62)
- `special RestartMapMusic` — [maps/SilverCaveOutside.asm:63](../../../maps/SilverCaveOutside.asm#L63)
- `setscene SCENE_FINISHED` — [maps/SilverCaveOutside.asm:83](../../../maps/SilverCaveOutside.asm#L83)

## Red Mt Silver

Map `SilverCaveRoom3`; class `RED`; party `Red:1`; ace 90; itinerary cap 100. [maps/SilverCaveRoom3.asm:17](../../../maps/SilverCaveRoom3.asm#L17).

Oak opens region after first League + Johto rematches + Cape Crystal; cave floors additionally after Agatha and Lorelei


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| PIKACHU | 88 | 112 | 2816 | 35/65/40/90/60/50 | 340 | LIGHT_BALL | GALVANIZE | EXTREMESPEED, HYPER_VOICE, SURF, IRON_TAIL | 43264 |
| ESPEON | 89 | 184 | 4678 | 65/65/60/110/130/95 | 525 | TWISTEDSPOON | MAGIC_BOUNCE | PSYCHIC_M, SHADOW_BALL, MORNING_SUN, CALM_MIND | 43264 |
| SNORLAX | 89 | 189 | 4806 | 160/110/65/30/65/110 | 540 | LEFTOVERS | THICK_FAT | CURSE, BODY_SLAM, EARTHQUAKE, REST | 43264 |
| VENUSAUR | 90 | 255 | 6556 | 80/82/83/80/110/100 | 535 | MIRACLE_SEED | CHLOROPHYLL | GIGA_DRAIN, SLUDGE_BOMB, SLEEP_POWDER, SYNTHESIS | 43264 |
| CHARIZARD | 90 | 255 | 6556 | 78/84/78/100/110/85 | 535 | CHARCOAL | DROUGHT | FIRE_BLAST, SOLARBEAM, AIR_SLASH, DRAGON_PULSE | 43264 |
| BLASTOISE | 90 | 255 | 6556 | 79/83/100/78/90/105 | 535 | MYSTIC_WATER | DRIZZLE | HYDRO_PUMP, ICE_BEAM, AURA_SPHERE, EARTHQUAKE | 43264 |


Script predicates / event evidence:

- `special FadeOutMusic` — [maps/SilverCaveRoom3.asm:10](../../../maps/SilverCaveRoom3.asm#L10)
- `special FadeOutMusic` — [maps/SilverCaveRoom3.asm:21](../../../maps/SilverCaveRoom3.asm#L21)
- `special FadeBlackQuickly` — [maps/SilverCaveRoom3.asm:26](../../../maps/SilverCaveRoom3.asm#L26)
- `special ReloadSpritesNoPalettes` — [maps/SilverCaveRoom3.asm:27](../../../maps/SilverCaveRoom3.asm#L27)
- `special FadeInQuickly` — [maps/SilverCaveRoom3.asm:31](../../../maps/SilverCaveRoom3.asm#L31)
- `special HealParty` — [maps/SilverCaveRoom3.asm:33](../../../maps/SilverCaveRoom3.asm#L33)

## PROTON (SlowpokeWellB1F)

Map `SlowpokeWellB1F`; class `PROTON`; party `Proton:1`; ace 13; itinerary cap 16. [maps/SlowpokeWellB1F.asm:32](../../../maps/SlowpokeWellB1F.asm#L32).

Kurt opens well; B2 needs Surf/Strength


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| IMPIDIMP | 10 | 53 | 150 | 45/55/30/50/45/40 | 265 | NO_ITEM | PRANKSTER | FAKE_OUT, BITE, SWEET_KISS, PIXIE_PUNCH | 14400 |
| MEOWTH_GALARIAN | 11 | 58 | 182 | 50/65/55/40/40/40 | 290 | NO_ITEM | TOUGH_CLAWS | METAL_CLAW, SCRATCH, GROWL, NO_MOVE | 14400 |
| SNEASEL_HISUIAN | 13 | 86 | 318 | 55/95/55/115/35/75 | 430 | NO_ITEM | TECHNICIAN | ROCK_SMASH, FURY_SWIPES, QUICK_ATTACK, FOCUS_ENERGY | 14400 |


Script predicates / event evidence:

- `special FadeBlackQuickly` — [maps/SlowpokeWellB1F.asm:39](../../../maps/SlowpokeWellB1F.asm#L39)
- `special ReloadSpritesNoPalettes` — [maps/SlowpokeWellB1F.asm:40](../../../maps/SlowpokeWellB1F.asm#L40)
- `special FadeInQuickly` — [maps/SlowpokeWellB1F.asm:46](../../../maps/SlowpokeWellB1F.asm#L46)
- `setmapscene AZALEA_TOWN, SCENE_AZALEATOWN_RIVAL_BATTLE` — [maps/SlowpokeWellB1F.asm:58](../../../maps/SlowpokeWellB1F.asm#L58)
- `special FadeOutPalettes` — [maps/SlowpokeWellB1F.asm:68](../../../maps/SlowpokeWellB1F.asm#L68)
- `special HealParty` — [maps/SlowpokeWellB1F.asm:69](../../../maps/SlowpokeWellB1F.asm#L69)

## LI (SproutTower3F)

Map `SproutTower3F`; class `ELDER`; party `Elder:1`; ace 9; itinerary cap 10. [maps/SproutTower3F.asm:73](../../../maps/SproutTower3F.asm#L73).

Violet; Flash reward, not required for Falkner


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HOPPIP | 7 | 50 | 100 | 35/35/40/50/45/55 | 260 | NO_ITEM | INFILTRATOR | ABSORB, SYNTHESIS, TACKLE, TAIL_WHIP | 0 |
| EXEGGCUTE | 8 | 65 | 148 | 60/40/80/40/60/45 | 325 | BERRY | HARVEST | HYPNOSIS, ABSORB, BARRAGE, REFLECT | 0 |
| WEEPINBELL | 9 | 137 | 352 | 65/90/50/55/85/45 | 390 | NO_ITEM | POISON_PUPPETEER | POISONPOWDER, VINE_WHIP, ACID, WRAP | 0 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_HM05_FLASH` — [maps/SproutTower3F.asm:67](../../../maps/SproutTower3F.asm#L67)

## ARIANA (TeamRocketBaseB2F)

Map `TeamRocketBaseB2F`; class `ARIANA`; party `Ariana:1`; ace 36; itinerary cap 38. [maps/TeamRocketBaseB2F.asm:98](../../../maps/TeamRocketBaseB2F.asm#L98).

Lake of Rage Gyarados, Lance and hideout/passwords; map42 passage model assumes Jasmine


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MURKROW | 35 | 81 | 810 | 60/85/42/91/85/42 | 405 | NO_ITEM | PRANKSTER | DRILL_PECK, SUCKER_PUNCH, THUNDER_WAVE, TAUNT | 15376 |
| SALAZZLE | 35 | 168 | 1680 | 68/64/60/117/116/60 | 485 | NO_ITEM | CORROSION | INCINERATE, VENOSHOCK, TOXIC, ENCORE | 15376 |
| MILOTIC | 36 | 189 | 1944 | 95/60/79/81/100/125 | 540 | NO_ITEM | COMPETITIVE | SCALD, MOONBLAST, RECOVER, HYPNOSIS | 15376 |
| WEAVILE | 36 | 179 | 1840 | 70/120/65/125/45/85 | 510 | NO_ITEM | TECHNICIAN | ICE_FANG, NIGHT_SLASH, ICE_SHARD, LOW_KICK | 15376 |


Script predicates / event evidence:

- `special FadeBlackQuickly` — [maps/TeamRocketBaseB2F.asm:110](../../../maps/TeamRocketBaseB2F.asm#L110)
- `special ReloadSpritesNoPalettes` — [maps/TeamRocketBaseB2F.asm:111](../../../maps/TeamRocketBaseB2F.asm#L111)
- `special FadeInQuickly` — [maps/TeamRocketBaseB2F.asm:118](../../../maps/TeamRocketBaseB2F.asm#L118)
- `setscene SCENE_TEAMROCKETBASEB2F_ELECTRODES` — [maps/TeamRocketBaseB2F.asm:119](../../../maps/TeamRocketBaseB2F.asm#L119)

## PETREL (TeamRocketBaseB3F)

Map `TeamRocketBaseB3F`; class `PETREL`; party `Petrel:1`; ace 36; itinerary cap 38. [maps/TeamRocketBaseB3F.asm:110](../../../maps/TeamRocketBaseB3F.asm#L110).

Lake of Rage Gyarados, Lance and hideout/passwords; map42 passage model assumes Jasmine


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GRIMER_ALOLAN | 35 | 65 | 650 | 80/80/50/25/40/50 | 325 | NO_ITEM | POISON_TOUCH | POISON_FANG, CRUNCH, KNOCK_OFF, SHADOW_SNEAK | 12544 |
| PORYGON2 | 36 | 180 | 1850 | 85/80/90/60/105/95 | 515 | NO_ITEM | DOWNLOAD | TRI_ATTACK, PSYBEAM, FOUL_PLAY, RECOVER | 12544 |
| BANETTE | 36 | 159 | 1634 | 64/125/65/70/93/63 | 480 | NO_ITEM | PRANKSTER | SHADOW_CLAW, KNOCK_OFF, WILL_O_WISP, ENCORE | 12544 |
| DITTO | 36 | 101 | 1038 | 48/48/48/48/48/48 | 288 | NO_ITEM | IMPOSTER | TRANSFORM, NO_MOVE, NO_MOVE, NO_MOVE | 12544 |


Script predicates / event evidence:

- `setscene SCENE_TEAMROCKETBASEB3F_NOTHING` — [maps/TeamRocketBaseB3F.asm:122](../../../maps/TeamRocketBaseB3F.asm#L122)

## Surge

Map `VermilionGym`; class `LT_SURGE`; party `LtSurge:1`; ace 58; itinerary cap 58. [maps/VermilionGym.asm:22](../../../maps/VermilionGym.asm#L22).

Misty + returned Machine Part opens Route5/6


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| MAGNEZONE | 55 | 255 | 4006 | 70/70/115/60/130/90 | 535 | AIR_BALLOON | LEVITATE | THUNDERBOLT, FLASH_CANNON, VOLT_SWITCH, THUNDER_WAVE | 36864 |
| ELECTIVIRE | 56 | 255 | 4080 | 75/123/67/95/95/85 | 540 | LIFE_ORB | IRON_FIST | THUNDERPUNCH, ICE_PUNCH, FIRE_PUNCH, CROSS_CHOP | 36864 |
| VIKAVOLT | 56 | 225 | 3600 | 77/70/90/43/145/75 | 500 | LEFTOVERS | SPEED_BOOST | THUNDERBOLT, BUG_BUZZ, ENERGY_BALL, VOLT_SWITCH | 36864 |
| JOLTEON | 57 | 184 | 2996 | 65/65/60/130/110/95 | 525 | LIFE_ORB | VOLT_ABSORB | THUNDERBOLT, SHADOW_BALL, HYPER_VOICE, THUNDER_WAVE | 36864 |
| AMPHAROS | 57 | 255 | 4152 | 90/75/85/55/115/90 | 510 | LEFTOVERS | MOLD_BREAKER | THUNDERBOLT, DRAGON_PULSE, FOCUS_BLAST, THUNDER_WAVE | 36864 |
| RAICHU | 58 | 243 | 4026 | 60/95/55/110/95/80 | 495 | LIFE_ORB | GALVANIZE | EXTREMESPEED, HYPER_VOICE, SURF, NASTY_PLOT | 36864 |


Script predicates / event evidence:

- `checkflag ENGINE_THUNDERBADGE` — [maps/VermilionGym.asm:16](../../../maps/VermilionGym.asm#L16)
- `checkevent EVENT_GOT_SS_TICKET_FROM_ELM` — [maps/VermilionGym.asm:37](../../../maps/VermilionGym.asm#L37)

## ? (VictoryRoad)

Map `VictoryRoad`; class `RIVAL1`; party `Rival1:15`; ace 71; itinerary cap 100. [maps/VictoryRoad.asm:75](../../../maps/VictoryRoad.asm#L75).

16 badges; VictoryRoadGate guards


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| GOLBAT | 68 | 159 | 3088 | 75/80/70/90/65/75 | 455 | EVIOLITE | INNER_FOCUS | BRAVE_BIRD, CROSS_POISON, U_TURN, ROOST | 26896 |
| MAGNEZONE | 69 | 255 | 5026 | 70/70/115/60/130/90 | 535 | MAGNET | LEVITATE | THUNDERBOLT, FLASH_CANNON, TRI_ATTACK, THUNDER_WAVE | 26896 |
| SLOWKING_GALARIAN | 69 | 172 | 3390 | 95/65/80/30/110/110 | 490 | LEFTOVERS | UNAWARE | PSYCHIC_M, SLUDGE_BOMB, FLAMETHROWER, RECOVER | 26896 |
| WEAVILE | 69 | 179 | 3528 | 70/120/65/125/45/85 | 510 | NEVERMELTICE | TECHNICIAN | ICE_SHARD, FAINT_ATTACK, ICICLE_CRASH, LOW_KICK | 26896 |
| CERULEDGE | 69 | 255 | 5026 | 75/125/80/85/60/100 | 525 | CHARCOAL | SHARPNESS | BITTER_BLADE, PHANTOMFORCE, PSYCHO_CUT, SHADOW_SNEAK | 26896 |
| FERALIGATR | 71 | 255 | 5172 | 85/110/100/78/79/83 | 535 | MYSTIC_WATER | SHEER_FORCE | WATERFALL, ICE_PUNCH, CRUNCH, ROCK_SLIDE | 26896 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/VictoryRoad.asm:65](../../../maps/VictoryRoad.asm#L65)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/VictoryRoad.asm:67](../../../maps/VictoryRoad.asm#L67)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/VictoryRoad.asm:69](../../../maps/VictoryRoad.asm#L69)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/VictoryRoad.asm:71](../../../maps/VictoryRoad.asm#L71)

## CRYSTAL (VioletCity)

Map `VioletCity`; class `CRYSTAL`; party `Crystal:1`; ace 10; itinerary cap 10. [maps/VioletCity.asm:74](../../../maps/VioletCity.asm#L74).

Routes 30-31


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| CHIKORITA | 10 | 64 | 182 | 45/49/65/45/49/65 | 318 | BERRY | SERENE_GRACE | TACKLE, GROWL, RAZOR_LEAF, REFLECT | 7744 |
| NATU | 10 | 64 | 182 | 40/50/45/70/70/45 | 320 | NO_ITEM | SYNCHRONIZE | PECK, LEER, NIGHT_SHADE, CONFUSION | 7744 |


Script predicates / event evidence:

- `checkevent EVENT_GOT_TOTODILE_FROM_ELM` — [maps/VioletCity.asm:66](../../../maps/VioletCity.asm#L66)
- `checkevent EVENT_GOT_SQUIRTLE_FROM_ELM` — [maps/VioletCity.asm:68](../../../maps/VioletCity.asm#L68)
- `checkevent EVENT_GOT_CHIKORITA_FROM_ELM` — [maps/VioletCity.asm:70](../../../maps/VioletCity.asm#L70)
- `checkevent EVENT_GOT_BULBASAUR_FROM_ELM` — [maps/VioletCity.asm:72](../../../maps/VioletCity.asm#L72)
- `setscene SCENE_FINISHED` — [maps/VioletCity.asm:106](../../../maps/VioletCity.asm#L106)

## Falkner

Map `VioletGym`; class `FALKNER`; party `Falkner:1`; ace 10; itinerary cap 10. [maps/VioletGym.asm:21](../../../maps/VioletGym.asm#L21).

Routes 30-31


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| HOOTHOOT | 8 | 52 | 118 | 60/30/30/50/36/56 | 262 | BERRY | INTIMIDATE | PECK, HYPNOSIS, CONFUSION, MUD_SLAP | 6400 |
| FLETCHLING | 9 | 56 | 144 | 45/50/43/62/40/38 | 278 | NO_ITEM | GALE_WINGS | PECK, QUICK_ATTACK, AGILITY, EMBER | 6400 |
| PIDGEOTTO | 10 | 122 | 348 | 63/50/50/71/65/50 | 349 | BERRY | KEEN_EYE | GUST, QUICK_ATTACK, MUD_SLAP, SWIFT | 6400 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_FALKNER` — [maps/VioletGym.asm:15](../../../maps/VioletGym.asm#L15)
- `readvar VAR_BADGES` — [maps/VioletGym.asm:30](../../../maps/VioletGym.asm#L30)
- `checkevent EVENT_GOT_TM31_MUD_SLAP` — [maps/VioletGym.asm:33](../../../maps/VioletGym.asm#L33)
- `setmapscene ELMS_LAB, SCENE_ELMSLAB_NOTHING` — [maps/VioletGym.asm:37](../../../maps/VioletGym.asm#L37)
- `checkevent EVENT_BEAT_FALKNER_REMATCH` — [maps/VioletGym.asm:50](../../../maps/VioletGym.asm#L50)
- `checkevent EVENT_BEAT_ELITE_FOUR` — [maps/VioletGym.asm:52](../../../maps/VioletGym.asm#L52)

## Falkner rematch

Map `VioletGym`; class `FALKNER_REMATCH`; party `Falkner:2`; ace 77; itinerary cap 100. [maps/VioletGym.asm:59](../../../maps/VioletGym.asm#L59).

Routes 30-31


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| SKARMORY | 75 | 163 | 3492 | 85/90/140/70/40/70 | 495 | ROCKY_HELMET | IRON_BARBS | STEALTH_ROCK, SPIKES, BODY_PRESS, BRAVE_BIRD | 43264 |
| NOCTOWL | 75 | 158 | 3384 | 100/40/60/60/106/116 | 482 | WISE_GLASSES | TINTED_LENS | NASTY_PLOT, HURRICANE, PSYCHIC_M, MOONBLAST | 43264 |
| ARCHEOPS | 76 | 177 | 3842 | 75/135/70/105/100/65 | 550 | EXPERT_BELT | UNNERVE | HEAD_SMASH, DUALWINGBEAT, EARTHQUAKE, U_TURN | 43264 |
| TALONFLAME | 76 | 175 | 3800 | 78/81/71/126/74/69 | 499 | LIFE_ORB | GALE_WINGS | BRAVE_BIRD, FLARE_BLITZ, ROOST, WILL_O_WISP | 43264 |
| HONCHKROW | 77 | 177 | 3894 | 100/125/52/71/115/52 | 515 | LIFE_ORB | MOXIE | BRAVE_BIRD, SUCKER_PUNCH, NIGHT_SLASH, FOUL_PLAY | 43264 |
| PIDGEOT | 77 | 240 | 5280 | 83/60/70/101/115/70 | 499 | LIFE_ORB | NO_GUARD | HURRICANE, HYPER_VOICE, HYPER_BEAM, ROOST | 43264 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_FALKNER` — [maps/VioletGym.asm:15](../../../maps/VioletGym.asm#L15)
- `readvar VAR_BADGES` — [maps/VioletGym.asm:30](../../../maps/VioletGym.asm#L30)
- `checkevent EVENT_GOT_TM31_MUD_SLAP` — [maps/VioletGym.asm:33](../../../maps/VioletGym.asm#L33)
- `setmapscene ELMS_LAB, SCENE_ELMSLAB_NOTHING` — [maps/VioletGym.asm:37](../../../maps/VioletGym.asm#L37)
- `checkevent EVENT_BEAT_FALKNER_REMATCH` — [maps/VioletGym.asm:50](../../../maps/VioletGym.asm#L50)
- `checkevent EVENT_BEAT_ELITE_FOUR` — [maps/VioletGym.asm:52](../../../maps/VioletGym.asm#L52)

## Blue

Map `ViridianGym`; class `BLUE`; party `Blue:1`; ace 69; itinerary cap 69. [maps/ViridianGym.asm:42](../../../maps/ViridianGym.asm#L42).

Blue AND all 3 gym trainers share EVENT_VIRIDIAN_GYM_BLUE; 15 badges via UpdateBlueReturnScript


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| PIDGEOT | 66 | 240 | 4524 | 83/60/70/101/115/70 | 499 | LIFE_ORB | NO_GUARD | HURRICANE, HEAT_WAVE, SIGNAL_BEAM, ROOST | 41616 |
| RHYPERIOR | 67 | 255 | 4880 | 115/140/130/40/55/55 | 535 | LEFTOVERS | SOLID_ROCK | EARTHQUAKE, STONE_EDGE, ICE_PUNCH, MEGAHORN | 41616 |
| GYARADOS | 67 | 189 | 3618 | 95/125/79/81/60/100 | 540 | LIFE_ORB | MOXIE | WATERFALL, CRUNCH, EARTHQUAKE, DRAGON_DANCE | 41616 |
| ARCANINE | 68 | 194 | 3768 | 90/110/80/95/100/80 | 555 | EXPERT_BELT | INTIMIDATE | FLARE_BLITZ, EXTREMESPEED, CRUNCH, WILD_CHARGE | 41616 |
| SCIZOR | 68 | 175 | 3400 | 70/130/100/65/55/80 | 500 | MUSCLE_BAND | TECHNICIAN | BULLET_PUNCH, BUG_BITE, U_TURN, SWORDS_DANCE | 41616 |
| ELECTIVIRE | 69 | 255 | 5026 | 75/123/67/95/95/85 | 540 | LIFE_ORB | SHEER_FORCE | WILD_CHARGE, ICE_PUNCH, FIRE_PUNCH, CRUNCH | 41616 |


Script predicates / event evidence:

- `checkflag ENGINE_EARTHBADGE` — [maps/ViridianGym.asm:21](../../../maps/ViridianGym.asm#L21)
- `farscall CheckBlueBadgeAccessScript` — [maps/ViridianGym.asm:23](../../../maps/ViridianGym.asm#L23)
- `checkflag ENGINE_PLAYER_IS_FEMALE` — [maps/ViridianGym.asm:32](../../../maps/ViridianGym.asm#L32)
- `checkevent EVENT_BEAT_ELITE_FOUR` — [maps/ViridianGym.asm:53](../../../maps/ViridianGym.asm#L53)

## Will

Map `WillsRoom`; class `WILL`; party `Will:1`; ace 70; itinerary cap 100. [maps/WillsRoom.asm:54](../../../maps/WillsRoom.asm#L54).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| XATU | 67 | 165 | 3158 | 80/75/70/95/95/70 | 485 | LEFTOVERS | MAGIC_BOUNCE | PSYCHIC_M, AIR_SLASH, ROOST, THUNDER_WAVE | 24336 |
| FARIGIRAF | 68 | 255 | 4954 | 120/90/70/85/110/70 | 545 | ASSAULT_VEST | ARMOR_TAIL | PSYCHIC_M, CRUNCH, HYPER_VOICE, THUNDERBOLT | 24336 |
| GALLADE | 68 | 255 | 4954 | 68/125/65/80/65/115 | 518 | LIFE_ORB | SHARPNESS | PSYCHO_CUT, NIGHT_SLASH, LEAF_BLADE, SACRED_SWORD | 24336 |
| SLOWKING | 69 | 172 | 3390 | 95/75/80/30/100/110 | 490 | LEFTOVERS | REGENERATOR | SURF, PSYCHIC_M, FLAMETHROWER, SLACK_OFF | 24336 |
| GRUMPIG | 69 | 165 | 3252 | 80/45/75/80/100/110 | 490 | WISE_GLASSES | THICK_FAT | PSYCHIC_M, SHADOW_BALL, CALM_MIND, THUNDERBOLT | 24336 |
| WYRDEER | 70 | 163 | 3260 | 103/105/72/95/75/75 | 525 | MUSCLE_BAND | INTIMIDATE | ZEN_HEADBUTT, DOUBLE_EDGE, MEGAHORN, AGILITY | 24336 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_WILL` — [maps/WillsRoom.asm:46](../../../maps/WillsRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/WillsRoom.asm:52](../../../maps/WillsRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/WillsRoom.asm:67](../../../maps/WillsRoom.asm#L67)

## Will rematch

Map `WillsRoom`; class `WILL_REMATCH`; party `Will:2`; ace 85; itinerary cap 100. [maps/WillsRoom.asm:57](../../../maps/WillsRoom.asm#L57).

16 badges; first League; rematch additionally Clair rematch


| Pokémon | Level | Base EXP | Hard solo EXP | Custom stats HP/Atk/Def/Spe/SpA/SpD | BST | Item | Ability | Moves | Hard stat EXP |
|---|---|---|---|---|---|---|---|---|---|
| XATU | 83 | 165 | 3912 | 80/75/70/95/95/70 | 485 | LEFTOVERS | MAGIC_BOUNCE | CALM_MIND, PSYCHIC_M, AIR_SLASH, ROOST | 44944 |
| FARIGIRAF | 84 | 255 | 6120 | 120/90/70/85/110/70 | 545 | ASSAULT_VEST | ARMOR_TAIL | PSYCHIC_M, HYPER_VOICE, CRUNCH, THUNDERBOLT | 44944 |
| GALLADE | 84 | 255 | 6120 | 68/125/65/80/65/115 | 518 | LIFE_ORB | SHARPNESS | SWORDS_DANCE, PSYCHO_CUT, SACRED_SWORD, NIGHT_SLASH | 44944 |
| SLOWKING | 85 | 172 | 4176 | 95/75/80/30/100/110 | 490 | LEFTOVERS | REGENERATOR | CALM_MIND, PSYCHIC_M, SURF, SLACK_OFF | 44944 |
| GRUMPIG | 85 | 165 | 4006 | 80/45/75/80/100/110 | 490 | WISE_GLASSES | THICK_FAT | CALM_MIND, PSYCHIC_M, SHADOW_BALL, THUNDERBOLT | 44944 |
| ESPATHRA | 85 | 168 | 4080 | 95/60/60/105/101/60 | 481 | LEFTOVERS | SPEED_BOOST | CALM_MIND, PSYCHIC_M, DAZZLING_GLEAM, SHADOW_BALL | 44944 |


Script predicates / event evidence:

- `checkevent EVENT_BEAT_ELITE_4_WILL` — [maps/WillsRoom.asm:46](../../../maps/WillsRoom.asm#L46)
- `checkevent EVENT_BEAT_CLAIR_REMATCH` — [maps/WillsRoom.asm:52](../../../maps/WillsRoom.asm#L52)
- `changeblock 4, 2, $16` — [maps/WillsRoom.asm:67](../../../maps/WillsRoom.asm#L67)
