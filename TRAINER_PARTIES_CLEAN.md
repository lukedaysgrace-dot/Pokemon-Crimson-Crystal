# Crimson Crystal — Trainer Party Reference

Generated from the current game source. **572 fixed parties**, **1648 Pokémon**, and **83 party groups** are listed. Trainer classes stay together, and repeat fights/rematch tiers are grouped by trainer name.

This cleaned reference keeps the same trainer data while reducing repeated metadata and making battles easier to scan.

> [!IMPORTANT]
> Edit `data/trainers/parties.asm`, not this generated file. Rebuild this reference with
> `python tools/generate_trainer_party_reference.py`.

> [!NOTE]
> For parties labeled “automatic level-up moves,” the Moves column shows the exact set produced
> by `FillMoves` at that level. Abilities are resolved to their actual names; “class default”
> means the slot comes from that trainer class’s Attack DV. Battle Tower opponents are not
> included because they draw generated teams from pools rather than owning fixed parties in
> `data/trainers/parties.asm`.

## Trainer Index

| Trainer / class | Parties | Trainer / class | Parties | Trainer / class | Parties |
|---|---:|---|---:|---|---:|
| [Falkner](#falkner) | 2 | [Team Rocket Grunt M](#team-rocket-grunt-m) | 16 | [Pokéfan M](#pokfan-m) | 15 |
| [Whitney](#whitney) | 2 | [Gentleman](#gentleman) | 4 | [Kimono Girl](#kimono-girl) | 9 |
| [Bugsy](#bugsy) | 2 | [Skier](#skier) | 4 | [Twins](#twins) | 10 |
| [Morty](#morty) | 2 | [Teacher](#teacher) | 3 | [Pokéfan F](#pokfan-f) | 6 |
| [Pryce](#pryce) | 2 | [Sabrina](#sabrina) | 1 | [Red](#red) | 1 |
| [Jasmine](#jasmine) | 2 | [Bug Catcher](#bug-catcher) | 19 | [Blue](#blue) | 1 |
| [Chuck](#chuck) | 2 | [Fisher](#fisher) | 25 | [Officer](#officer) | 2 |
| [Clair](#clair) | 2 | [Swimmer M](#swimmer-m) | 13 | [Mystical Man](#mystical-man) | 2 |
| [Will](#will) | 2 | [Swimmer F](#swimmer-f) | 13 | [Proton](#proton) | 2 |
| [Cal](#cal) | 3 | [Sailor](#sailor) | 13 | [Petrel](#petrel) | 1 |
| [Bruno](#bruno) | 2 | [Super Nerd](#super-nerd) | 9 | [Ariana](#ariana) | 2 |
| [Karen](#karen) | 2 | [Guitarist](#guitarist) | 2 | [Archer](#archer) | 2 |
| [Koga](#koga) | 2 | [Hiker](#hiker) | 22 | [Petrel Director](#petrel-director) | 1 |
| [Champion](#champion) | 2 | [Biker](#biker) | 7 | [Hex Maniac](#hex-maniac) | 3 |
| [Brock](#brock) | 1 | [Blaine](#blaine) | 1 | [Cosplayer](#cosplayer) | 6 |
| [Misty](#misty) | 1 | [Burglar](#burglar) | 5 | [Ninja](#ninja) | 4 |
| [Lt Surge](#lt-surge) | 1 | [Firebreather](#firebreather) | 8 | [Agatha](#agatha) | 1 |
| [Scientist](#scientist) | 5 | [Juggler](#juggler) | 9 | [Lorelei](#lorelei) | 1 |
| [Erika](#erika) | 1 | [Blackbelt](#blackbelt) | 9 | [Red2](#red2) | 1 |
| [Youngster](#youngster) | 14 | [Team Rocket Executive M](#team-rocket-executive-m) | 4 | [Blue Cloak](#blue-cloak) | 1 |
| [Schoolboy](#schoolboy) | 24 | [Psychic](#psychic) | 12 | [Green](#green) | 1 |
| [Bird Keeper](#bird-keeper) | 19 | [Picnicker](#picnicker) | 19 | [Battle Girl](#battle-girl) | 2 |
| [Lass](#lass) | 18 | [Aroma Lady](#aroma-lady) | 8 | [Tamer](#tamer) | 3 |
| [Janine](#janine) | 1 | [Camper](#camper) | 16 | [Team Rocket Grunt F](#team-rocket-grunt-f) | 16 |
| [Cooltrainer M](#cooltrainer-m) | 20 | [Team Rocket Executive F](#team-rocket-executive-f) | 2 | [Rival — Main Story](#rival--main-story) | 15 |
| [Cooltrainer F](#cooltrainer-f) | 21 | [Sage](#sage) | 12 | [Rival — Postgame](#rival--postgame) | 6 |
| [Beauty](#beauty) | 6 | [Medium](#medium) | 5 | [Crystal](#crystal) | 15 |
| [Pokémaniac](#pokmaniac) | 15 | [Boarder](#boarder) | 6 |  |  |


## Falkner

> **Group:** `FalknerGroup` · **Battle IDs:** `FALKNER`, `FALKNER_REMATCH` · **2 parties**


### FALKNER1 — Violet Gym

**3 Pokémon, Lv. 8–10**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L20](data/trainers/parties.asm#L20) · Map: [VioletGym.asm:L21](maps/VioletGym.asm#L21)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoothoot** (`HOOTHOOT`) | 8 | Berry | Intimidate *(hidden)* | Peck, Hypnosis, Confusion, Mud-Slap |
| 2 | **Fletchling** (`FLETCHLING`) | 9 | — | Gale Wings *(hidden)* | Peck, Quick Attack, Agility, Ember |
| 3 | **Pidgeotto** (`PIDGEOTTO`) | 10 | Berry | Keen Eye *(slot 1)* | Gust, Quick Attack, Mud-Slap, Swift |

### FALKNER2 — Violet Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L39](data/trainers/parties.asm#L39) · Map: [VioletGym.asm:L59](maps/VioletGym.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Skarmory** (`SKARMORY`) | 75 | Rocky Helmet | Iron Barbs *(slot 1)* | Stealth Rock, Spikes, Body Press, Brave Bird |
| 2 | **Noctowl** (`NOCTOWL`) | 75 | Wise Glasses | Tinted Lens *(slot 1)* | Nasty Plot, Hurricane, Psychic, Moonblast |
| 3 | **Archeops** (`ARCHEOPS`) | 76 | Expert Belt | Unnerve *(slot 1)* | Head Smash, Dualwingbeat, Earthquake, U-Turn |
| 4 | **Talonflame** (`TALONFLAME`) | 76 | Life Orb | Gale Wings *(hidden)* | Brave Bird, Flare Blitz, Roost, Will-O-Wisp |
| 5 | **Honchkrow** (`HONCHKROW`) | 77 | Life Orb | Moxie *(hidden)* | Brave Bird, Sucker Punch, Night Slash, Foul Play |
| 6 | **Pidgeot** (`PIDGEOT`) | 77 | Life Orb | No Guard *(slot 1)* | Hurricane, Hyper Voice, Hyper Beam, Roost |


## Whitney

> **Group:** `WhitneyGroup` · **Battle IDs:** `WHITNEY`, `WHITNEY_REMATCH` · **2 parties**


### WHITNEY1 — Goldenrod Gym

**4 Pokémon, Lv. 18–20**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L76](data/trainers/parties.asm#L76) · Map: [GoldenrodGym.asm:L31](maps/GoldenrodGym.asm#L31)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clefairy** (`CLEFAIRY`) | 18 | — | Magic Guard *(slot 2)* | Fairy Wind, Fire Punch, Thunderpunch, Charm |
| 2 | **Teddiursa** (`TEDDIURSA`) | 19 | — | Quick Feet *(slot 2)* | Headbutt, Faint Attack, Metal Claw, Lick |
| 3 | **Buneary** (`BUNEARY`) | 19 | — | Limber *(hidden)* | Quick Attack, Headbutt, Ice Punch, Karate Chop |
| 4 | **Miltank** (`MILTANK`) | 20 | Miracleberry | Thick Fat *(slot 1)* | Rollout, Attract, Stomp, Milk Drink |

### WHITNEY2 — Goldenrod Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L100](data/trainers/parties.asm#L100) · Map: [GoldenrodGym.asm:L85](maps/GoldenrodGym.asm#L85)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Blissey** (`BLISSEY`) | 75 | Leftovers | Natural Cure *(slot 2)* | Softboiled, Seismic Toss, Toxic, Ice Beam |
| 2 | **Porygon-Z** (`PORYGON_Z`) | 75 | Life Orb | Adaptability *(slot 1)* | Nasty Plot, Tri Attack, Thunderbolt, Psychic |
| 3 | **Kangaskhan** (`KANGASKHAN`) | 76 | Muscle Band | Parental Bond *(hidden)* | Double-Edge, Earthquake, Sucker Punch, Crunch |
| 4 | **Ursaluna** (`URSALUNA`) | 76 | Flame Orb | Guts *(slot 1)* | Facade, Headlongrush, Close Combat, Crunch |
| 5 | **Snorlax** (`SNORLAX`) | 77 | Leftovers | Thick Fat *(slot 1)* | Curse, Body Slam, Earthquake, Slack Off |
| 6 | **Miltank** (`MILTANK`) | 77 | Leftovers | Scrappy *(slot 2)* | Milk Drink, Body Slam, Earthquake, Play Rough |


## Bugsy

> **Group:** `BugsyGroup` · **Battle IDs:** `BUGSY`, `BUGSY_REMATCH` · **2 parties**


### BUGSY1 — Azalea Gym

**3 Pokémon, Lv. 14–16**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L137](data/trainers/parties.asm#L137) · Map: [AzaleaGym.asm:L24](maps/AzaleaGym.asm#L24)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pineco** (`PINECO`) | 14 | — | Sturdy *(slot 1)* | Bulldoze, Bug Bite, Spikes, Reflect |
| 2 | **Joltik** (`JOLTIK`) | 15 | — | Compound Eyes *(slot 1)* | Thundershock, Struggle Bug, Thunder Wave, Agility |
| 3 | **Scyther** (`SCYTHER`) | 16 | Berry Juice | Technician *(slot 1)* | Bug Bite, Quick Attack, Pursuit, Wing Attack |

### BUGSY2 — Azalea Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L156](data/trainers/parties.asm#L156) · Map: [AzaleaGym.asm:L62](maps/AzaleaGym.asm#L62)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Forretress** (`FORRETRESS`) | 75 | Leftovers | Sturdy *(slot 1)* | Stealth Rock, Spikes, Gyro Ball, Body Press |
| 2 | **Vikavolt** (`VIKAVOLT`) | 75 | Wise Glasses | Levitate *(slot 1)* | Bug Buzz, Thunderbolt, Flash Cannon, Agility |
| 3 | **Heracross** (`HERACROSS`) | 76 | Life Orb | Skill Link *(slot 2)* | Pin Missile, Rock Blast, Close Combat, Knock Off |
| 4 | **Golisopod** (`GOLISOPOD`) | 76 | Assault Vest | Battle Armor *(slot 1)* | First Strike, Liquidation, Sucker Punch, Knock Off |
| 5 | **Volcarona** (`VOLCARONA`) | 77 | Leftovers | Flame Body *(slot 1)* | Quiver Dance, Bug Buzz, Fiery Dance, Hurricane |
| 6 | **Scizor** (`SCIZOR`) | 77 | Life Orb | Technician *(slot 1)* | Swords Dance, Bullet Punch, Bug Bite, Knock Off |


## Morty

> **Group:** `MortyGroup` · **Battle IDs:** `MORTY`, `MORTY_REMATCH` · **2 parties**


### MORTY1 — Ecruteak Gym

**4 Pokémon, Lv. 23–25**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L193](data/trainers/parties.asm#L193) · Map: [EcruteakGym.asm:L33](maps/EcruteakGym.asm#L33)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golett** (`GOLETT`) | 23 | — | Iron Fist *(slot 1)* | Shadow Punch, Ice Punch, Bulldoze, Low Sweep |
| 2 | **Misdreavus** (`MISDREAVUS`) | 24 | — | Levitate *(slot 1)* | Shadow Ball, Confuse Ray, Pain Split, Fairy Wind |
| 3 | **Drifloon** (`DRIFLOON`) | 24 | — | Unburden *(slot 2)* | Night Shade, Will-O-Wisp, Shadow Ball, Air Cutter |
| 4 | **Gengar** (`GENGAR`) | 25 | Miracleberry | Levitate *(slot 1)* | Shadow Ball, Sludge, Confuse Ray, Mean Look |

### MORTY2 — Ecruteak Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L217](data/trainers/parties.asm#L217) · Map: [EcruteakGym.asm:L74](maps/EcruteakGym.asm#L74)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mismagius** (`MISMAGIUS`) | 75 | Leftovers | Prankster *(hidden)* | Nasty Plot, Shadow Ball, Moonblast, Will-O-Wisp |
| 2 | **Dusknoir** (`DUSKNOIR`) | 75 | Leftovers | Iron Fist *(slot 1)* | Shadow Sneak, Pain Split, Thunderpunch, Fire Punch |
| 3 | **Mimikyu** (`MIMIKYU`) | 76 | Life Orb | Disguise *(slot 1)* | Bulk Up, Phantomforce, Play Rough, Shadow Sneak |
| 4 | **Chandelure** (`CHANDELURE`) | 76 | Life Orb | Levitate *(slot 2)* | Shadow Ball, Fire Blast, Psychic, Will-O-Wisp |
| 5 | **Dragapult** (`DRAGAPULT`) | 77 | Life Orb | Infiltrator *(slot 2)* | Dragon Dance, Dragon Darts, Phantomforce, Sucker Punch |
| 6 | **Gengar** (`GENGAR`) | 77 | Life Orb | Levitate *(slot 1)* | Nasty Plot, Shadow Ball, Sludge Bomb, Thunderbolt |


## Pryce

> **Group:** `PryceGroup` · **Battle IDs:** `PRYCE`, `PRYCE_REMATCH` · **2 parties**


### PRYCE1 — Mahogany Gym

**6 Pokémon, Lv. 35–38**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L254](data/trainers/parties.asm#L254) · Map: [MahoganyGym.asm:L24](maps/MahoganyGym.asm#L24)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ninetales** (`NINETALES_ALOLAN`) | 35 | Icy Rock | Snow Warning *(hidden)* | Ice Beam, Dazzle Gleam, Confuse Ray, Icy Wind |
| 2 | **Dewgong** (`DEWGONG`) | 36 | — | Thick Fat *(slot 1)* | Surf, Ice Beam, Rest, Sleep Talk |
| 3 | **Weavile** (`WEAVILE`) | 36 | Scope Lens | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Metal Claw |
| 4 | **Aurorus** (`AURORUS`) | 37 | — | Refrigerate *(slot 1)* | Swift, Hyper Voice, Ancientpower, Thunder Wave |
| 5 | **Abomasnow** (`ABOMASNOW`) | 37 | — | Thick Fat *(hidden)* | Ice Beam, Giga Drain, Ice Shard, Rock Slide |
| 6 | **Mamoswine** (`MAMOSWINE`) | 38 | Gold Berry | Thick Fat *(slot 1)* | Earthquake, Icicle Crash, Rock Slide, Ice Shard |

### PRYCE2 — Mahogany Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L288](data/trainers/parties.asm#L288) · Map: [MahoganyGym.asm:L63](maps/MahoganyGym.asm#L63)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ninetales** (`NINETALES_ALOLAN`) | 75 | Icy Rock | Snow Warning *(hidden)* | Blizzard, Moonblast, Freeze-Dry, Nasty Plot |
| 2 | **Cloyster** (`CLOYSTER`) | 75 | Life Orb | Skill Link *(slot 1)* | Shell Smash, Icicle Spear, Rock Blast, Ice Shard |
| 3 | **Glaceon** (`GLACEON`) | 76 | Life Orb | Slush Rush *(hidden)* | Blizzard, Freeze-Dry, Earth Power, Mirror Coat |
| 4 | **Weavile** (`WEAVILE`) | 76 | Life Orb | Technician *(slot 1)* | Icicle Crash, Knock Off, Night Slash, Ice Shard |
| 5 | **Lapras** (`LAPRAS`) | 77 | Assault Vest | Water Absorb *(slot 1)* | Ice Beam, Surf, Thunderbolt, Dragon Pulse |
| 6 | **Mamoswine** (`MAMOSWINE`) | 77 | Life Orb | Thick Fat *(slot 1)* | Icicle Crash, Earthquake, Ice Shard, Superpower |


## Jasmine

> **Group:** `JasmineGroup` · **Battle IDs:** `JASMINE`, `JASMINE_REMATCH` · **2 parties**


### JASMINE1 — Olivine Gym

**5 Pokémon, Lv. 32–34**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L325](data/trainers/parties.asm#L325) · Map: [OlivineGym.asm:L36](maps/OlivineGym.asm#L36)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corvknight** (`CORVIKNIGHT`) | 32 | — | Mirror Armor *(hidden)* | Steel Wing, Drill Peck, Pursuit, U-Turn |
| 2 | **Aggron** (`AGGRON`) | 33 | — | Rock Head *(slot 1)* | Double-Edge, Iron Tail, Rock Slide, Earthquake |
| 3 | **Bastiodon** (`BASTIODON`) | 33 | — | Filter *(hidden)* | Rock Slide, Iron Head, Take Down, Iron Defense |
| 4 | **Tinkaton** (`TINKATON`) | 34 | — | Mold Breaker *(slot 1)* | Play Rough, Iron Head, Rock Slide, Knock Off |
| 5 | **Steelix** (`STEELIX`) | 34 | Quick Claw | Sturdy *(slot 2)* | Iron Tail, Earthquake, Rock Slide, Crunch |

### JASMINE2 — Olivine Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L354](data/trainers/parties.asm#L354) · Map: [OlivineGym.asm:L83](maps/OlivineGym.asm#L83)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magnezone** (`MAGNEZONE`) | 75 | Wise Glasses | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Thunder Wave, Signal Beam |
| 2 | **Corvknight** (`CORVIKNIGHT`) | 75 | Leftovers | Mirror Armor *(hidden)* | Brave Bird, Body Press, Iron Defense, Roost |
| 3 | **Excadrill** (`EXCADRILL`) | 76 | Life Orb | Mold Breaker *(hidden)* | Swords Dance, Earthquake, Iron Head, Rock Slide |
| 4 | **Lucario** (`LUCARIO`) | 76 | Life Orb | Adaptability *(slot 1)* | Nasty Plot, Aura Sphere, Flash Cannon, Dragon Pulse |
| 5 | **Tinkaton** (`TINKATON`) | 77 | Life Orb | Mold Breaker *(slot 1)* | Giga Hammer, Play Rough, Knock Off, Iron Head |
| 6 | **Steelix** (`STEELIX`) | 77 | Leftovers | Sturdy *(slot 2)* | Earthquake, Iron Head, Body Press, Crunch |


## Chuck

> **Group:** `ChuckGroup` · **Battle IDs:** `CHUCK`, `CHUCK_REMATCH` · **2 parties**


### CHUCK1 — Cianwood Gym

**5 Pokémon, Lv. 28–30**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L391](data/trainers/parties.asm#L391) · Map: [CianwoodGym.asm:L41](maps/CianwoodGym.asm#L41)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hitmontop** (`HITMONTOP`) | 28 | — | Technician *(slot 1)* | Triple Kick, Triple Axel, Dig, Pursuit |
| 2 | **Gurdurr** (`GURDURR`) | 28 | — | Guts *(slot 1)* | Rock Slide, Low Kick, Thunderpunch, Bulk Up |
| 3 | **Breloom** (`BRELOOM`) | 29 | — | Technician *(slot 1)* | Mach Punch, Bullet Seed, Headbutt, Drain Punch |
| 4 | **Scrafty** (`SCRAFTY`) | 29 | — | Moxie *(slot 2)* | Brick Break, Crunch, Rock Slide, Headbutt |
| 5 | **Poliwrath** (`POLIWRATH`) | 30 | Blackbelt | Iron Fist *(slot 2)* | Hypnosis, Mind Reader, Surf, Dynamicpunch |

### CHUCK2 — Cianwood Gym

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L420](data/trainers/parties.asm#L420) · Map: [CianwoodGym.asm:L79](maps/CianwoodGym.asm#L79)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Machamp** (`MACHAMP`) | 75 | Muscle Band | No Guard *(slot 2)* | Dynamicpunch, Knock Off, Ice Punch, Bullet Punch |
| 2 | **Conkeldurr** (`CONKELDURR`) | 75 | Flame Orb | Guts *(slot 1)* | Facade, Hammer Arm, Stone Edge, Knock Off |
| 3 | **Gallade** (`GALLADE`) | 76 | Life Orb | Sharpness *(slot 2)* | Swords Dance, Sacred Sword, Psycho Cut, Night Slash |
| 4 | **Sirfetch'd** (`SIRFETCH_D`) | 76 | Life Orb | Scrappy *(hidden)* | Swords Dance, Close Combat, Knock Off, Brave Bird |
| 5 | **Annihilape** (`ANNIHILAPE`) | 77 | Leftovers | Defiant *(hidden)* | Bulk Up, Rage Fist, Close Combat, Night Slash |
| 6 | **Poliwrath** (`POLIWRATH`) | 77 | Muscle Band | Iron Fist *(slot 2)* | Dynamicpunch, Drain Punch, Ice Punch, Mach Punch |


## Clair

> **Group:** `ClairGroup` · **Battle IDs:** `CLAIR`, `CLAIR_REMATCH` · **2 parties**


### CLAIR1 — Blackthorn Gym 1F

**6 Pokémon, Lv. 42–45**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L457](data/trainers/parties.asm#L457) · Map: [BlackthornGym1F.asm:L40](maps/BlackthornGym1F.asm#L40)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dragonair** (`DRAGONAIR`) | 42 | — | Multiscale *(hidden)* | Dragon Pulse, Thunder Wave, Ice Beam, Thunderbolt |
| 2 | **Noivern** (`NOIVERN`) | 43 | — | Wind Rider *(slot 2)* | Air Slash, Dragon Pulse, Dark Pulse, Agility |
| 3 | **Flygon** (`FLYGON`) | 43 | — | Tinted Lens *(hidden)* | Earthquake, Dragon Claw, Rock Slide, U-Turn |
| 4 | **Altaria** (`ALTARIA`) | 44 | — | Natural Cure *(slot 2)* | Dragon Claw, Earthquake, Body Slam, Dragon Dance |
| 5 | **Tyrantrum** (`TYRANTRUM`) | 44 | — | Strong Jaw *(slot 1)* | Rock Slide, Crunch, Fire Fang, Dragon Dance |
| 6 | **Kingdra** (`KINGDRA`) | 45 | Scope Lens | Sniper *(slot 2)* | Surf, Dragon Pulse, Ice Beam, Agility |

### CLAIR2 — Blackthorn Gym 1F

**6 Pokémon, Lv. 75–77**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L491](data/trainers/parties.asm#L491) · Map: [BlackthornGym1F.asm:L97](maps/BlackthornGym1F.asm#L97)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Altaria** (`ALTARIA`) | 75 | Leftovers | Natural Cure *(slot 2)* | Dragon Pulse, Moonblast, Heat Wave, Will-O-Wisp |
| 2 | **Noivern** (`NOIVERN`) | 75 | Life Orb | Wind Rider *(slot 2)* | Hurricane, Dragon Pulse, Heat Wave, Roost |
| 3 | **Archaludon** (`ARCHALUDON`) | 76 | Leftovers | Stamina *(slot 1)* | Draco Meteor, Flash Cannon, Body Press, Dragon Tail |
| 4 | **Haxorus** (`HAXORUS`) | 76 | Life Orb | Mold Breaker *(slot 2)* | Dragon Dance, Dragon Claw, Iron Head, Superpower |
| 5 | **Salamence** (`SALAMENCE`) | 77 | Life Orb | Aerilate *(hidden)* | Dragon Dance, Double-Edge, Dragon Claw, Fire Fang |
| 6 | **Kingdra** (`KINGDRA`) | 77 | Life Orb | Swift Swim *(slot 1)* | Rain Dance, Hydro Pump, Draco Meteor, Ice Beam |


## Will

> **Group:** `WillGroup` · **Battle IDs:** `WILL`, `WILL_REMATCH` · **2 parties**


### WILL1 — Will's Room

**6 Pokémon, Lv. 49–52**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L530](data/trainers/parties.asm#L530) · Map: [WillsRoom.asm:L54](maps/WillsRoom.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 49 | Leftovers | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Thunder Wave |
| 2 | **Farigiraf** (`FARIGIRAF`) | 50 | Assault Vest | Armor Tail *(slot 1)* | Psychic, Crunch, Hyper Voice, Thunderbolt |
| 3 | **Gallade** (`GALLADE`) | 50 | Life Orb | Sharpness *(slot 2)* | Psycho Cut, Night Slash, Leaf Blade, Sacred Sword |
| 4 | **Slowking** (`SLOWKING`) | 51 | Leftovers | Regenerator *(hidden)* | Surf, Psychic, Flamethrower, Slack Off |
| 5 | **Grumpig** (`GRUMPIG`) | 51 | Wise Glasses | Thick Fat *(slot 1)* | Psychic, Shadow Ball, Calm Mind, Thunderbolt |
| 6 | **Wyrdeer** (`WYRDEER`) | 52 | Muscle Band | Intimidate *(slot 1)* | Zen Headbutt, Double-Edge, Megahorn, Agility |

### WILL2 — Will's Room

**6 Pokémon, Lv. 78–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L564](data/trainers/parties.asm#L564) · Map: [WillsRoom.asm:L57](maps/WillsRoom.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 78 | Leftovers | Magic Bounce *(hidden)* | Calm Mind, Psychic, Air Slash, Roost |
| 2 | **Farigiraf** (`FARIGIRAF`) | 79 | Assault Vest | Armor Tail *(slot 1)* | Psychic, Hyper Voice, Crunch, Thunderbolt |
| 3 | **Gallade** (`GALLADE`) | 79 | Life Orb | Sharpness *(slot 2)* | Swords Dance, Psycho Cut, Sacred Sword, Night Slash |
| 4 | **Slowking** (`SLOWKING`) | 80 | Leftovers | Regenerator *(hidden)* | Calm Mind, Psychic, Surf, Slack Off |
| 5 | **Grumpig** (`GRUMPIG`) | 80 | Wise Glasses | Thick Fat *(slot 1)* | Calm Mind, Psychic, Shadow Ball, Thunderbolt |
| 6 | **Espathra** (`ESPATHRA`) | 80 | Leftovers | Speed Boost *(hidden)* | Calm Mind, Psychic, Dazzle Gleam, Shadow Ball |


## Cal

> **Group:** `PKMNTrainerGroup` · **Battle IDs:** `CAL` · **3 parties**


### CAL1 — Trainer House B1F (rematch)

**3 Pokémon, Lv. 71**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L601](data/trainers/parties.asm#L601) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Trapinch** (`TRAPINCH`) | 71 | Silverpowder | Arena Trap *(slot 2, class default)* | Bug Bite, Faint Attack, Bite, Astonish |
| 2 | **Teddiursa** (`TEDDIURSA`) | 71 | Gold Berry | Quick Feet *(slot 2, class default)* | Scratch, Fury Swipes, Lick |
| 3 | **Poliwag** (`POLIWAG`) | 71 | Berry | Damp *(slot 2, class default)* | Pound, Water Gun, Bubble, Hypnosis |

### CAL2 — Trainer House B1F

**3 Pokémon, Lv. 71**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L617](data/trainers/parties.asm#L617) · Map: [TrainerHouseB1F.asm:L47](maps/TrainerHouseB1F.asm#L47)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Salandit** (`SALANDIT`) | 71 | Poison Barb | Poison Puppeteer *(slot 2, class default)* | Venoshock, Flame Wheel, Ember, Toxic |
| 2 | **Dugtrio** (`DUGTRIO_ALOLAN`) | 71 | Gold Berry | Technician *(slot 2, class default)* | Bulldoze, Metal Claw, Rock Slide, Sandstorm |
| 3 | **Arbok** (`ARBOK`) | 71 | Miracleberry | Shed Skin *(slot 2, class default)* | Crunch, Poison Fang, Ice Fang, Glare |

### CAL3 — Trainer House B1F

**6 Pokémon, Lv. 77**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L633](data/trainers/parties.asm#L633) · Map: [TrainerHouseB1F.asm:L54](maps/TrainerHouseB1F.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sudowoodo** (`SUDOWOODO`) | 77 | Expert Belt | Sturdy *(slot 2, class default)* | Stone Edge, Wood Hammer, Double-Edge, Stealth Rock |
| 2 | **Magcargo** (`MAGCARGO`) | 77 | Rocky Helmet | Flame Body *(slot 2, class default)* | Overheat, Flamethrower, Power Gem, Shell Smash |
| 3 | **Hypno** (`HYPNO`) | 77 | Expert Belt | No Guard *(slot 2, class default)* | Zen Headbutt, Psycho Cut, Drain Punch, Nasty Plot |
| 4 | **Typhlosion** (`TYPHLOSION`) | 77 | Life Orb | Blaze *(slot 2, class default)* | Overheat, Flamethrower, Earth Power, Heat Wave |
| 5 | **Golem** (`GOLEM_ALOLAN`) | 77 | Air Balloon | Sturdy *(slot 2, class default)* | Head Smash, Wild Charge, Stone Edge, Stealth Rock |
| 6 | **Venomoth** (`VENOMOTH`) | 77 | Choice Specs | Compound Eyes *(slot 2, class default)* | Bug Buzz, Signal Beam, Psychic, Quiver Dance |


## Bruno

> **Group:** `BrunoGroup` · **Battle IDs:** `BRUNO`, `BRUNO_REMATCH` · **2 parties**


### BRUNO1 — Bruno's Room

**6 Pokémon, Lv. 51–54**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L664](data/trainers/parties.asm#L664) · Map: [BrunosRoom.asm:L54](maps/BrunosRoom.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Conkeldurr** (`CONKELDURR`) | 51 | Leftovers | Iron Fist *(hidden)* | Drain Punch, Mach Punch, Thunderpunch, Ice Punch |
| 2 | **Hitmontop** (`HITMONTOP`) | 52 | Muscle Band | Technician *(slot 1)* | Triple Kick, Mach Punch, Pursuit, Close Combat |
| 3 | **Lucario** (`LUCARIO`) | 52 | Life Orb | Adaptability *(slot 1)* | Close Combat, Bullet Punch, Extremespeed, Swords Dance |
| 4 | **Toxicroak** (`TOXICROAK`) | 53 | Expert Belt | Dry Skin *(slot 2)* | Poison Jab, Drain Punch, Sucker Punch, Ice Punch |
| 5 | **Annihilape** (`ANNIHILAPE`) | 53 | Leftovers | Defiant *(hidden)* | Rage Fist, Close Combat, Shadow Claw, Bulk Up |
| 6 | **Machamp** (`MACHAMP`) | 54 | Blackbelt | No Guard *(slot 2)* | Dynamicpunch, Cross Chop, Rock Slide, Fire Punch |

### BRUNO2 — Bruno's Room

**6 Pokémon, Lv. 78–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L698](data/trainers/parties.asm#L698) · Map: [BrunosRoom.asm:L57](maps/BrunosRoom.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Conkeldurr** (`CONKELDURR`) | 78 | Flame Orb | Guts *(slot 1)* | Facade, Drain Punch, Mach Punch, Knock Off |
| 2 | **Hitmontop** (`HITMONTOP`) | 79 | Muscle Band | Technician *(slot 1)* | Triple Kick, Close Combat, Mach Punch, Sucker Punch |
| 3 | **Lucario** (`LUCARIO`) | 79 | Life Orb | Adaptability *(slot 1)* | Swords Dance, Close Combat, Bullet Punch, Extremespeed |
| 4 | **Toxicroak** (`TOXICROAK`) | 80 | Life Orb | Dry Skin *(slot 2)* | Swords Dance, Drain Punch, Poison Jab, Sucker Punch |
| 5 | **Annihilape** (`ANNIHILAPE`) | 80 | Leftovers | Defiant *(hidden)* | Bulk Up, Rage Fist, Drain Punch, Shadow Claw |
| 6 | **Machamp** (`MACHAMP`) | 80 | Expert Belt | No Guard *(slot 2)* | Dynamicpunch, Stone Edge, Ice Punch, Knock Off |


## Karen

> **Group:** `KarenGroup` · **Battle IDs:** `KAREN`, `KAREN_REMATCH` · **2 parties**


### KAREN1 — Karen's Room

**6 Pokémon, Lv. 52–55**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L735](data/trainers/parties.asm#L735) · Map: [KarensRoom.asm:L54](maps/KarensRoom.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Umbreon** (`UMBREON`) | 52 | Leftovers | Synchronize *(slot 1)* | Foul Play, Toxic, Moonlight, Confuse Ray |
| 2 | **Honchkrow** (`HONCHKROW`) | 53 | Life Orb | Moxie *(hidden)* | Brave Bird, Sucker Punch, Night Slash, Heat Wave |
| 3 | **Weavile** (`WEAVILE`) | 53 | Life Orb | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 4 | **Grimmsnarl** (`GRIMMSNARL`) | 54 | Leftovers | Prankster *(slot 1)* | Spirit Break, Crunch, Thunder Wave, Bulk Up |
| 5 | **Houndoom** (`HOUNDOOM`) | 54 | Blackglasses | Adaptability *(hidden)* | Flamethrower, Dark Pulse, Sludge Bomb, Nasty Plot |
| 6 | **Kingambit** (`KINGAMBIT`) | 55 | Leftovers | Supreme Overlord *(slot 2)* | Kowtowcleave, Sucker Punch, Iron Head, Swords Dance |

### KAREN2 — Karen's Room

**6 Pokémon, Lv. 78–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L769](data/trainers/parties.asm#L769) · Map: [KarensRoom.asm:L57](maps/KarensRoom.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Umbreon** (`UMBREON`) | 78 | Leftovers | Synchronize *(slot 1)* | Foul Play, Toxic, Moonlight, Confuse Ray |
| 2 | **Honchkrow** (`HONCHKROW`) | 79 | Life Orb | Moxie *(hidden)* | Brave Bird, Sucker Punch, Night Slash, Heat Wave |
| 3 | **Weavile** (`WEAVILE`) | 79 | Life Orb | Technician *(slot 1)* | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| 4 | **Grimmsnarl** (`GRIMMSNARL`) | 80 | Leftovers | Prankster *(slot 1)* | Bulk Up, Spirit Break, Crunch, Thunder Wave |
| 5 | **Houndoom** (`HOUNDOOM`) | 80 | Life Orb | Adaptability *(hidden)* | Nasty Plot, Dark Pulse, Fire Blast, Sludge Bomb |
| 6 | **Kingambit** (`KINGAMBIT`) | 80 | Leftovers | Supreme Overlord *(slot 2)* | Swords Dance, Kowtowcleave, Sucker Punch, Iron Head |


## Koga

> **Group:** `KogaGroup` · **Battle IDs:** `KOGA`, `KOGA_REMATCH` · **2 parties**


### KOGA1 — Koga's Room

**6 Pokémon, Lv. 50–53**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L806](data/trainers/parties.asm#L806) · Map: [KogasRoom.asm:L54](maps/KogasRoom.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Glimmora** (`GLIMMORA`) | 50 | Focus Sash | Toxic Debris *(slot 1)* | Toxic Spikes, Power Gem, Sludge Bomb, Earth Power |
| 2 | **Muk** (`MUK_ALOLAN`) | 51 | Assault Vest | Poison Touch *(slot 1)* | Gunk Shot, Knock Off, Crunch, Shadow Sneak |
| 3 | **Scolipede** (`SCOLIPEDE`) | 51 | Life Orb | Speed Boost *(hidden)* | Megahorn, Poison Jab, Rock Slide, Swords Dance |
| 4 | **Tentacruel** (`TENTACRUEL`) | 52 | Leftovers | Clear Body *(slot 1)* | Surf, Sludge Bomb, Ice Beam, Knock Off |
| 5 | **Salazzle** (`SALAZZLE`) | 52 | Life Orb | Poison Puppeteer *(slot 2)* | Flamethrower, Sludge Bomb, Toxic, Nasty Plot |
| 6 | **Crobat** (`CROBAT`) | 53 | Brightpowder | Merciless *(slot 1)* | Toxic, Cross Poison, Brave Bird, Roost |

### KOGA2 — Koga's Room

**6 Pokémon, Lv. 78–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L840](data/trainers/parties.asm#L840) · Map: [KogasRoom.asm:L57](maps/KogasRoom.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Glimmora** (`GLIMMORA`) | 78 | Focus Sash | Toxic Debris *(slot 1)* | Toxic Spikes, Stealth Rock, Sludge Bomb, Earth Power |
| 2 | **Muk** (`MUK_ALOLAN`) | 79 | Assault Vest | Poison Touch *(slot 1)* | Gunk Shot, Knock Off, Ice Punch, Shadow Sneak |
| 3 | **Scolipede** (`SCOLIPEDE`) | 79 | Life Orb | Speed Boost *(hidden)* | Swords Dance, Megahorn, Poison Jab, Rock Slide |
| 4 | **Tentacruel** (`TENTACRUEL`) | 80 | Leftovers | Clear Body *(slot 1)* | Scald, Sludge Bomb, Ice Beam, Knock Off |
| 5 | **Salazzle** (`SALAZZLE`) | 80 | Life Orb | Corrosion *(slot 1)* | Nasty Plot, Fire Blast, Sludge Bomb, Toxic |
| 6 | **Crobat** (`CROBAT`) | 80 | Leftovers | Infiltrator *(hidden)* | Brave Bird, Cross Poison, U-Turn, Roost |


## Champion

> **Group:** `ChampionGroup` · **Battle IDs:** `CHAMPION`, `CHAMPION_REMATCH` · **2 parties**


### LANCE — Lance's Room

**6 Pokémon, Lv. 54–57**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L877](data/trainers/parties.asm#L877) · Map: [LancesRoom.asm:L62](maps/LancesRoom.asm#L62)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Haxorus** (`HAXORUS`) | 54 | Life Orb | Mold Breaker *(slot 2)* | Outrage, Earthquake, Poison Jab, Dragon Dance |
| 2 | **Archaludon** (`ARCHALUDON`) | 55 | Leftovers | Stamina *(slot 1)* | Body Press, Flash Cannon, Dragon Pulse, Thunderbolt |
| 3 | **Salamence** (`SALAMENCE`) | 55 | Life Orb | Aerilate *(hidden)* | Double-Edge, Dragon Claw, Earthquake, Fire Blast |
| 4 | **Dragapult** (`DRAGAPULT`) | 56 | Scope Lens | Infiltrator *(slot 2)* | Dragon Darts, Shadow Ball, U-Turn, Thunderbolt |
| 5 | **Baxcalibur** (`BAXCALIBUR`) | 56 | Leftovers | Thermal Exchange *(slot 1)* | Icicle Crash, Dragon Claw, Earthquake, Ice Shard |
| 6 | **Dragonite** (`DRAGONITE`) | 57 | Gold Berry | Multiscale *(hidden)* | Outrage, Extremespeed, Earthquake, Dragon Dance |

### LANCE2 — Lance's Room

**6 Pokémon, Lv. 80–82**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L911](data/trainers/parties.asm#L911) · Map: [LancesRoom.asm:L65](maps/LancesRoom.asm#L65)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hydreigon** (`HYDREIGON`) | 80 | Life Orb | Berserk *(slot 2)* | Nasty Plot, Draco Meteor, Heat Wave, Dark Pulse |
| 2 | **Archaludon** (`ARCHALUDON`) | 81 | Leftovers | Stamina *(slot 1)* | Body Press, Flash Cannon, Draco Meteor, Thunderbolt |
| 3 | **Salamence** (`SALAMENCE`) | 81 | Life Orb | Aerilate *(hidden)* | Dragon Dance, Double-Edge, Dragon Claw, Earthquake |
| 4 | **Dragapult** (`DRAGAPULT`) | 82 | Life Orb | Infiltrator *(slot 2)* | Dragon Darts, Flamethrower, Phantomforce, Crunch |
| 5 | **Baxcalibur** (`BAXCALIBUR`) | 82 | Leftovers | Thermal Exchange *(slot 1)* | Dragon Dance, Icicle Crash, Dragon Claw, Earthquake |
| 6 | **Dragonite** (`DRAGONITE`) | 82 | Leftovers | Multiscale *(hidden)* | Dragon Dance, Outrage, Extremespeed, Earthquake |


## Brock

> **Group:** `BrockGroup` · **Battle IDs:** `BROCK` · **1 parties**

### Brock — Pewter Gym (`BROCK1`)

**6 Pokémon, Lv. 67–70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L948](data/trainers/parties.asm#L948) · Map: [PewterGym.asm:L20](maps/PewterGym.asm#L20)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Aerodactyl** (`AERODACTYL`) | 67 | Focus Sash | Rock Head *(slot 1)* | Stealth Rock, Head Smash, Earthquake, Crunch |
| 2 | **Cradily** (`CRADILY`) | 68 | Leftovers | Storm Drain *(slot 1)* | Giga Drain, Power Gem, Toxic, Recover |
| 3 | **Steelix** (`STEELIX`) | 68 | Leftovers | Sturdy *(slot 2)* | Earthquake, Iron Head, Body Press, Rock Slide |
| 4 | **Rampardos** (`RAMPARDOS`) | 69 | Muscle Band | Rock Head *(slot 1)* | Head Smash, Earthquake, Zen Headbutt, Crunch |
| 5 | **Armaldo** (`ARMALDO`) | 69 | Expert Belt | Tough Claws *(hidden)* | X-Scissor, Stone Edge, Earthquake, Swords Dance |
| 6 | **Golem** (`GOLEM`) | 70 | Rocky Helmet | Sturdy *(slot 2)* | Stone Edge, Earthquake, Fire Punch, Explosion |


## Misty

> **Group:** `MistyGroup` · **Battle IDs:** `MISTY` · **1 parties**

### Misty — Cerulean Gym (`MISTY1`)

**6 Pokémon, Lv. 60–63**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L985](data/trainers/parties.asm#L985) · Map: [CeruleanGym.asm:L68](maps/CeruleanGym.asm#L68)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Milotic** (`MILOTIC`) | 60 | Leftovers | Marvel Scale *(slot 1)* | Scald, Ice Beam, Recover, Toxic |
| 2 | **Walrein** (`WALREIN`) | 61 | Leftovers | Thick Fat *(slot 1)* | Surf, Ice Beam, Body Slam, Protect |
| 3 | **Gyarados** (`GYARADOS`) | 61 | Rocky Helmet | Intimidate *(slot 1)* | Waterfall, Crunch, Ice Fang, Dragon Dance |
| 4 | **Azumarill** (`AZUMARILL`) | 62 | Muscle Band | Huge Power *(slot 1)* | Aqua Jet, Play Rough, Waterfall, Ice Punch |
| 5 | **Lanturn** (`LANTURN`) | 62 | Leftovers | Volt Absorb *(slot 1)* | Surf, Thunderbolt, Ice Beam, Confuse Ray |
| 6 | **Starmie** (`STARMIE`) | 63 | Life Orb | Natural Cure *(slot 1)* | Surf, Psychic, Thunderbolt, Recover |


## Lt Surge

> **Group:** `LtSurgeGroup` · **Battle IDs:** `LT_SURGE` · **1 parties**

### Lt. Surge — Vermilion Gym (`LT_SURGE1`)

**6 Pokémon, Lv. 55–58**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L1022](data/trainers/parties.asm#L1022) · Map: [VermilionGym.asm:L22](maps/VermilionGym.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magnezone** (`MAGNEZONE`) | 55 | Air Balloon | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Volt Switch, Thunder Wave |
| 2 | **Electivire** (`ELECTIVIRE`) | 56 | Life Orb | Iron Fist *(hidden)* | Thunderpunch, Ice Punch, Fire Punch, Cross Chop |
| 3 | **Vikavolt** (`VIKAVOLT`) | 56 | Leftovers | Speed Boost *(hidden)* | Thunderbolt, Bug Buzz, Energy Ball, Volt Switch |
| 4 | **Jolteon** (`JOLTEON`) | 57 | Life Orb | Volt Absorb *(slot 1)* | Thunderbolt, Shadow Ball, Hyper Voice, Thunder Wave |
| 5 | **Ampharos** (`AMPHAROS`) | 57 | Leftovers | Mold Breaker *(slot 2)* | Thunderbolt, Dragon Pulse, Focus Blast, Thunder Wave |
| 6 | **Raichu** (`RAICHU`) | 58 | Life Orb | Galvanize *(hidden)* | Extremespeed, Hyper Voice, Surf, Nasty Plot |


## Scientist

> **Group:** `ScientistGroup` · **Battle IDs:** `SCIENTIST` · **5 parties**

### Ross — Team Rocket Base B3F (`ROSS`)

**2 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1059](data/trainers/parties.asm#L1059) · Map: [TeamRocketBaseB3F.asm:L157](maps/TeamRocketBaseB3F.asm#L157)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Croagunk** (`CROAGUNK`) | 36 | — | Dry Skin *(slot 2, class default)* | Brick Break, Drain Punch, Nasty Plot, Toxic |
| 2 | **Ariados** (`ARIADOS`) | 36 | — | Sniper *(slot 2, class default)* | Night Slash, Spider Web, Poison Jab, Signal Beam |

### Mitch — Team Rocket Base B3F (`MITCH`)

**1 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1067](data/trainers/parties.asm#L1067) · Map: [TeamRocketBaseB3F.asm:L168](maps/TeamRocketBaseB3F.asm#L168)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magneton** (`MAGNETON`) | 36 | — | Analytic *(slot 2, class default)* | Tri Attack, Flash Cannon, Iron Defense, Signal Beam |

### Jed — Team Rocket Base B1F (`JED`)

**2 Pokémon, Lv. 37**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L1073](data/trainers/parties.asm#L1073) · Map: [TeamRocketBaseB1F.asm:L482](maps/TeamRocketBaseB1F.asm#L482)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magneton** (`MAGNETON`) | 37 | — | Analytic *(slot 2)* | Flash Cannon, Iron Defense, Signal Beam, Screech |
| 2 | **Weezing** (`WEEZING`) | 37 | — | Neutralizing Gas *(slot 2)* | Haze, Gyro Ball, Sludge Bomb, Destiny Bond |

### Marc — Radio Tower 3F (`MARC`)

**1 Pokémon, Lv. 41**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L1083](data/trainers/parties.asm#L1083) · Map: [RadioTower3F.asm:L117](maps/RadioTower3F.asm#L117)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon** (`PORYGON`) | 41 | — | Download *(slot 2)* | Lock-On, Signal Beam, Thunderbolt, Trick Room |

### Rich — Radio Tower 4F (`RICH`)

**2 Pokémon, Lv. 40–41**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1090](data/trainers/parties.asm#L1090) · Map: [RadioTower4F.asm:L90](maps/RadioTower4F.asm#L90)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowbro** (`SLOWBRO_GALARIAN`) | 40 | — | Unaware *(slot 2, class default)* | Zen Headbutt, Psychic, Headbutt, Amnesia |
| 2 | **Weezing** (`WEEZING`) | 41 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Selfdestruct, Sludge, Toxic |


## Erika

> **Group:** `ErikaGroup` · **Battle IDs:** `ERIKA` · **1 parties**

### Erika — Celadon Gym (`ERIKA1`)

**6 Pokémon, Lv. 62–65**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L1103](data/trainers/parties.asm#L1103) · Map: [CeladonGym.asm:L23](maps/CeladonGym.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ludicolo** (`LUDICOLO`) | 62 | Leftovers | Swift Swim *(slot 1)* | Rain Dance, Surf, Giga Drain, Ice Beam |
| 2 | **Jumpluff** (`JUMPLUFF`) | 63 | Leftovers | Infiltrator *(hidden)* | Sleep Powder, Leech Seed, Giga Drain, Encore |
| 3 | **Vileplume** (`VILEPLUME`) | 63 | Leftovers | Poison Puppeteer *(slot 2)* | Sludge Bomb, Giga Drain, Toxic, Synthesis |
| 4 | **Victreebel** (`VICTREEBEL`) | 64 | Life Orb | Poison Puppeteer *(slot 2)* | Power Whip, Sludge Bomb, Knock Off, Swords Dance |
| 5 | **Exeggutor** (`EXEGGUTOR`) | 64 | Gold Berry | Harvest *(hidden)* | Psychic, Giga Drain, Leech Seed, Substitute |
| 6 | **Tsareena** (`TSAREENA`) | 65 | Life Orb | Queenly Majesty *(slot 1)* | Power Whip, Triple Axel, Play Rough, Swords Dance |


## Youngster

> **Group:** `YoungsterGroup` · **Battle IDs:** `YOUNGSTER` · **14 parties**


### JOEY1 — Route 30

**1 Pokémon, Lv. 6**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1140](data/trainers/parties.asm#L1140) · Map: [Route30.asm:L41](maps/Route30.asm#L41)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spinarak** (`SPINARAK`) | 6 | — | Sniper *(slot 2, class default)* | Poison Sting, Absorb, Fury Swipes, Constrict |

### JOEY2 — Route 30

**1 Pokémon, Lv. 24**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1186](data/trainers/parties.asm#L1186) · Map: [Route30.asm:L99](maps/Route30.asm#L99)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Girafarig** (`GIRAFARIG`) | 24 | — | Contrary *(slot 2, class default)* | Psybeam, Confusion, Stomp, Agility |

### JOEY3 — Route 30

**1 Pokémon, Lv. 29**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1193](data/trainers/parties.asm#L1193) · Map: [Route30.asm:L107](maps/Route30.asm#L107)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Nidorino** (`NIDORINO`) | 29 | — | Rivalry *(slot 2, class default)* | Poison Jab, Poison Fang, Horn Attack, Toxic Spikes |

### JOEY4 — Route 30

**1 Pokémon, Lv. 43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1240](data/trainers/parties.asm#L1240) · Map: [Route30.asm:L115](maps/Route30.asm#L115)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ursaring** (`URSARING`) | 43 | — | Quick Feet *(slot 2, class default)* | Earthquake, Crush Claw, Slash, Rest |

### JOEY5 — Route 30

**2 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1247](data/trainers/parties.asm#L1247) · Map: [Route30.asm:L123](maps/Route30.asm#L123)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Snorlax** (`SNORLAX`) | 54 | — | Immunity *(slot 2, class default)* | Giga Impact, Double-Edge, Superpower, Slack Off |
| 2 | **Fearow** (`FEAROW`) | 56 | — | Sniper *(slot 2, class default)* | Brave Bird, Double-Edge, Drill Peck, Roost |

### Mikey — Route 30 (`MIKEY`)

**2 Pokémon, Lv. 5–6**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1146](data/trainers/parties.asm#L1146) · Map: [Route30.asm:L188](maps/Route30.asm#L188)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Drilbur** (`DRILBUR`) | 5 | — | Sand Force *(slot 2, class default)* | Mud-Slap, Rapid Spin, Scratch |
| 2 | **Golett** (`GOLETT`) | 6 | — | Klutz *(slot 2, class default)* | Astonish, Mud-Slap, Defense Curl |

### Albert — Route 32 (`ALBERT`)

**2 Pokémon, Lv. 11**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1154](data/trainers/parties.asm#L1154) · Map: [Route32.asm:L420](maps/Route32.asm#L420)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Grubbin** (`GRUBBIN`) | 11 | — | Hustle *(slot 2, class default)* | Vicegrip, String Shot, Nuzzle, Bug Bite |
| 2 | **Aipom** (`AIPOM`) | 11 | — | Pickup *(slot 2, class default)* | Scratch, Sand-Attack, Astonish, Baton Pass |

### Gordon — Route 32 (`GORDON`)

**1 Pokémon, Lv. 14**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1162](data/trainers/parties.asm#L1162) · Map: [Route32.asm:L431](maps/Route32.asm#L431)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Numel** (`NUMEL`) | 14 | — | Drought *(slot 2, class default)* | Magnitude, Ember, Focus Energy, Bulldoze |

### Samuel — Route 34 (`SAMUEL`)

**3 Pokémon, Lv. 15–17**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1168](data/trainers/parties.asm#L1168) · Map: [Route34.asm:L383](maps/Route34.asm#L383)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sentret** (`SENTRET`) | 15 | — | Keen Eye *(slot 2, class default)* | Defense Curl, Quick Attack, Fury Swipes, Slam |
| 2 | **Pidgey** (`PIDGEY`) | 17 | — | Tangled Feet *(slot 2, class default)* | Gust, Quick Attack, Wing Attack, Swift |
| 3 | **Aipom** (`AIPOM`) | 17 | — | Pickup *(slot 2, class default)* | Sand-Attack, Astonish, Baton Pass, Fury Swipes |

### Ian — Route 34 (`IAN`)

**2 Pokémon, Lv. 16–18**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1178](data/trainers/parties.asm#L1178) · Map: [Route34.asm:L394](maps/Route34.asm#L394)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spinarak** (`SPINARAK`) | 16 | — | Sniper *(slot 2, class default)* | Bug Bite, Scary Face, Poison Fang, Night Shade |
| 2 | **Numel** (`NUMEL`) | 18 | — | Drought *(slot 2, class default)* | Bulldoze, Flame Wheel, Ancientpower, Mud Shot |

### Warren — Route 3 (`WARREN`)

**2 Pokémon, Lv. 69–70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1200](data/trainers/parties.asm#L1200) · Map: [Route3.asm:L26](maps/Route3.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Camerupt** (`CAMERUPT`) | 69 | — | Drought *(slot 2, class default)* | Overheat, Earthquake, Rock Slide, Strength |
| 2 | **Victreebel** (`VICTREEBEL`) | 70 | — | Poison Puppeteer *(slot 2, class default)* | Leaf Storm, Sludge Bomb, Sucker Punch, Slam |

### Jimmy — Route 3 (`JIMMY`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1210](data/trainers/parties.asm#L1210) · Map: [Route3.asm:L37](maps/Route3.asm#L37)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE`) | 69 | — | Guts *(slot 2, class default)* | Strength, Crunch, Iron Tail, Quick Attack |
| 2 | **Slowking** (`SLOWKING_GALARIAN`) | 69 | — | Unaware *(slot 2, class default)* | Sludge Bomb, Psychic, Fire Blast, Slack Off |

### Owen — Route 11 (`OWEN`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1220](data/trainers/parties.asm#L1220) · Map: [Route11.asm:L14](maps/Route11.asm#L14)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxapex** (`TOXAPEX`) | 58 | — | Limber *(slot 2, class default)* | Liquidation, Poison Jab, Body Press, Recover |
| 2 | **Mamoswine** (`MAMOSWINE`) | 58 | — | Oblivious *(slot 2, class default)* | Earthquake, Icicle Crash, Ice Shard, Ancientpower |

### Jason — Route 11 (`JASON`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1230](data/trainers/parties.asm#L1230) · Map: [Route11.asm:L25](maps/Route11.asm#L25)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Steelix** (`STEELIX`) | 58 | — | Sturdy *(slot 2, class default)* | Earthquake, Iron Tail, Stone Edge, Body Press |
| 2 | **Dodrio** (`DODRIO`) | 58 | — | Early Bird *(slot 2, class default)* | Brave Bird, Quick Attack, Drill Run, Hi Jump Kick |


## Schoolboy

> **Group:** `SchoolboyGroup` · **Battle IDs:** `SCHOOLBOY` · **24 parties**


### JACK1 — National Park

**2 Pokémon, Lv. 23–24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1260](data/trainers/parties.asm#L1260) · Map: [NationalPark.asm:L73](maps/NationalPark.asm#L73)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Teddiursa** (`TEDDIURSA`) | 23 | — | Quick Feet *(slot 2, class default)* | Faint Attack, Bulldoze, Metal Claw, Charm |
| 2 | **Buneary** (`BUNEARY`) | 24 | — | Klutz *(slot 2, class default)* | Endure, Quick Attack, Double Kick, Baton Pass |

### JACK2 — National Park

**2 Pokémon, Lv. 28–29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1376](data/trainers/parties.asm#L1376) · Map: [NationalPark.asm:L131](maps/NationalPark.asm#L131)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Doduo** (`DODUO`) | 28 | — | Early Bird *(slot 2, class default)* | Fury Attack, Wing Attack, Agility, Dualwingbeat |
| 2 | **Kotora** (`KOTORA`) | 29 | — | Intimidate *(slot 2, class default)* | Bite, Spark, Hyper Voice, Agility |

### JACK3 — National Park

**2 Pokémon, Lv. 40–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1384](data/trainers/parties.asm#L1384) · Map: [NationalPark.asm:L139](maps/NationalPark.asm#L139)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 40 | — | Rattled *(slot 2, class default)* | Dig, Glare, Double-Edge, Air Slash |
| 2 | **Stantler** (`STANTLER`) | 43 | — | Frisk *(slot 2, class default)* | Work Up, Zen Headbutt, Thrash, Lunge |

### JACK4 — National Park

**3 Pokémon, Lv. 53–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1432](data/trainers/parties.asm#L1432) · Map: [NationalPark.asm:L147](maps/NationalPark.asm#L147)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Girafarig** (`GIRAFARIG`) | 53 | — | Contrary *(slot 2, class default)* | Psycho Cut, Baton Pass, Hyper Voice, Nasty Plot |
| 2 | **Banette** (`BANETTE`) | 56 | — | Cursed Body *(slot 2, class default)* | Phantomforce, Nasty Plot, Destiny Bond, Trick |
| 3 | **Furret** (`FURRET`) | 56 | — | Fur Coat *(slot 2, class default)* | Baton Pass, Play Rough, Hyper Voice, Double-Edge |

### JACK5 — National Park

**3 Pokémon, Lv. 60–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1442](data/trainers/parties.asm#L1442) · Map: [NationalPark.asm:L155](maps/NationalPark.asm#L155)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Furret** (`FURRET`) | 60 | — | Fur Coat *(slot 2, class default)* | Extremespeed, Slam, Zen Headbutt, Rest |
| 2 | **Teddiursa** (`TEDDIURSA`) | 60 | — | Quick Feet *(slot 2, class default)* | Crush Claw, Slash, Cross Chop, Charm |
| 3 | **Stantler** (`STANTLER`) | 63 | — | Frisk *(slot 2, class default)* | Take Down, Stomp, Zen Headbutt, Calm Mind |

### Kipp — Route 15 (`KIPP`)

**2 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1268](data/trainers/parties.asm#L1268) · Map: [Route15.asm:L38](maps/Route15.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Furret** (`FURRET`) | 66 | — | Fur Coat *(slot 2, class default)* | Extremespeed, Play Rough, Strength, Sucker Punch |
| 2 | **Lopunny** (`LOPUNNY`) | 66 | — | Cute Charm *(slot 2, class default)* | Mega Kick, Hi Jump Kick, Quick Attack, Headbutt |


### ALAN1 — Route 36

**2 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1278](data/trainers/parties.asm#L1278) · Map: [Route36.asm:L170](maps/Route36.asm#L170)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sandshrew** (`SANDSHREW_ALOLAN`) | 24 | — | Tough Claws *(slot 2, class default)* | Fury Cutter, Swift, Hone Claws, Fury Swipes |
| 2 | **Smoochum** (`SMOOCHUM`) | 24 | — | Forewarn *(slot 2, class default)* | Sing, Icy Wind, Mean Look, Extrasensory |

### ALAN2 — Route 36

**2 Pokémon, Lv. 28–29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1392](data/trainers/parties.asm#L1392) · Map: [Route36.asm:L230](maps/Route36.asm#L230)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flaaffy** (`FLAAFFY`) | 28 | — | Fluffy *(slot 2, class default)* | Cotton Spore, Nuzzle, Confuse Ray, Take Down |
| 2 | **Kadabra** (`KADABRA`) | 29 | — | Synchronize *(slot 2, class default)* | Disable, Night Shade, Reflect, Light Screen |

### ALAN3 — Route 36

**4 Pokémon, Lv. 40–44**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1400](data/trainers/parties.asm#L1400) · Map: [Route36.asm:L238](maps/Route36.asm#L238)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon** (`PORYGON`) | 40 | — | Download *(slot 2, class default)* | Tri Attack, Psybeam, Thundershock, Recover |
| 2 | **Rhyhorn** (`RHYHORN`) | 41 | — | Reckless *(slot 2, class default)* | Bulldoze, Rock Tomb, Take Down, Stomp |
| 3 | **Wobbuffet** (`WOBBUFFET`) | 42 | — | Shadow Tag *(slot 2, class default)* | Counter, Mirror Coat, Amnesia, Encore |
| 4 | **Natu** (`NATU`) | 44 | — | Early Bird *(slot 2, class default)* | Psychic, Confusion, Night Shade, Confuse Ray |

### ALAN4 — Route 36

**4 Pokémon, Lv. 53–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1455](data/trainers/parties.asm#L1455) · Map: [Route36.asm:L246](maps/Route36.asm#L246)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flaaffy** (`FLAAFFY`) | 53 | — | Fluffy *(slot 2, class default)* | Light Screen, Dazzle Gleam, Heal Bell, Thunder |
| 2 | **Mawile** (`MAWILE`) | 53 | — | Intimidate *(slot 2, class default)* | Body Press, Iron Head, Play Rough, Swords Dance |
| 3 | **Sudowoodo** (`SUDOWOODO`) | 56 | — | Sturdy *(slot 2, class default)* | Sucker Punch, Double-Edge, Stone Edge, Wood Hammer |
| 4 | **Noctowl** (`NOCTOWL`) | 56 | — | Insomnia *(slot 2, class default)* | Moonblast, Roost, Dream Eater, Hurricane |

### ALAN5 — Route 36

**4 Pokémon, Lv. 60–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1467](data/trainers/parties.asm#L1467) · Map: [Route36.asm:L254](maps/Route36.asm#L254)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Bisharp** (`BISHARP`) | 60 | — | Inner Focus *(slot 2, class default)* | Night Slash, Foul Play, Sacred Sword, Iron Head |
| 2 | **Tauros** (`TAUROS`) | 62 | — | Anger Point *(slot 2, class default)* | Megahorn, Superpower, Outrage, Giga Impact |
| 3 | **Lanturn** (`LANTURN`) | 63 | — | Water Absorb *(slot 2, class default)* | Signal Beam, Thunderbolt, Take Down, Hydro Pump |
| 4 | **Corsola** (`CORSOLA`) | 63 | — | Natural Cure *(slot 2, class default)* | Rock Blast, Heal Bell, Mirror Coat, Flail |

### Johnny — Route 15 (`JOHNNY`)

**2 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1286](data/trainers/parties.asm#L1286) · Map: [Route15.asm:L60](maps/Route15.asm#L60)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE`) | 66 | — | Guts *(slot 2, class default)* | Strength, Crunch, Iron Tail, Quick Attack |
| 2 | **Fearow** (`FEAROW`) | 66 | — | Sniper *(slot 2, class default)* | Brave Bird, Facade, Steel Wing, Roost |

### Danny — Route 1 (`DANNY`)

**3 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1296](data/trainers/parties.asm#L1296) · Map: [Route1.asm:L12](maps/Route1.asm#L12)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Persian** (`PERSIAN`) | 69 | — | Limber *(slot 2, class default)* | Crush Claw, Thunderbolt, Power Gem, Shadow Ball |
| 2 | **Kangaskhan** (`KANGASKHAN`) | 69 | — | Inner Focus *(slot 2, class default)* | Body Slam, Earthquake, Ice Punch, Sucker Punch |
| 3 | **Chansey** (`CHANSEY`) | 69 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Fire Blast, Psychic |

### Tommy — Route 15 (`TOMMY`)

**2 Pokémon, Lv. 66–67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1309](data/trainers/parties.asm#L1309) · Map: [Route15.asm:L49](maps/Route15.asm#L49)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lopunny** (`LOPUNNY`) | 66 | — | Cute Charm *(slot 2, class default)* | Mega Kick, Hi Jump Kick, Quick Attack, Dizzy Punch |
| 2 | **Chansey** (`CHANSEY`) | 67 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Fire Blast, Psychic |

### Dudley — Route 25 (`DUDLEY`)

**2 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1319](data/trainers/parties.asm#L1319) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Zangoose** (`ZANGOOSE`) | 58 | — | Scrappy *(slot 2, class default)* | Crush Claw, Close Combat, Belly Drum, Double-Edge |
| 2 | **Shuckle** (`SHUCKLE`) | 58 | — | Gluttony *(slot 2, class default)* | Sweet Scent, Body Press, Earth Power, Stone Edge |

### Joe — Route 25 (`JOE`)

**2 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1327](data/trainers/parties.asm#L1327) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Exeggutor** (`EXEGGUTOR`) | 58 | — | Chlorophyll *(slot 2, class default)* | Wood Hammer, Energy Ball, Leaf Storm, Ancientpower |
| 2 | **Jynx** (`JYNX`) | 58 | — | Forewarn *(slot 2, class default)* | Body Slam, Perish Song, Blizzard, Nasty Plot |

### Billy — Route 15 (`BILLY`)

**3 Pokémon, Lv. 64–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1335](data/trainers/parties.asm#L1335) · Map: [Route15.asm:L71](maps/Route15.asm#L71)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Farigiraf** (`FARIGIRAF`) | 64 | — | Cud Chew *(slot 2, class default)* | Psychic, Stomp, Crunch, Psybeam |
| 2 | **Wigglytuff** (`WIGGLYTUFF`) | 64 | — | Competitive *(slot 2, class default)* | Hyper Voice, Drain Kiss, Fire Blast, Ice Beam |
| 3 | **Pidgeot** (`PIDGEOT`) | 66 | — | Tangled Feet *(slot 2, class default)* | Hurricane, Swift, Roost, Quick Attack |


### CHAD1 — Route 38

**2 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1348](data/trainers/parties.asm#L1348) · Map: [Route38.asm:L176](maps/Route38.asm#L176)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Voltorb** (`VOLTORB`) | 28 | — | Static *(slot 2, class default)* | Rollout, Spark, Swift, Selfdestruct |
| 2 | **Chinchou** (`CHINCHOU`) | 28 | — | Water Absorb *(slot 2, class default)* | Nuzzle, Spark, Confuse Ray, Bubblebeam |

### CHAD2 — Route 38

**2 Pokémon, Lv. 32–34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1416](data/trainers/parties.asm#L1416) · Map: [Route38.asm:L234](maps/Route38.asm#L234)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Perrserker** (`PERRSERKER`) | 32 | — | Tough Claws *(slot 2, class default)* | Night Slash, Seed Bomb, Brick Break, Crush Claw |
| 2 | **Natu** (`NATU`) | 34 | — | Early Bird *(slot 2, class default)* | Confusion, Confuse Ray, Psychic, Psycho Cut |

### CHAD3 — Route 38

**2 Pokémon, Lv. 41–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1424](data/trainers/parties.asm#L1424) · Map: [Route38.asm:L242](maps/Route38.asm#L242)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Eevee** (`EEVEE`) | 41 | — | Adaptability *(slot 2, class default)* | Take Down, Charm, Double-Edge, Heal Bell |
| 2 | **Elekid** (`ELEKID`) | 43 | — | Vital Spirit *(slot 2, class default)* | Cross Chop, Thunderbolt, Wild Charge, Close Combat |

### CHAD4 — Route 38

**2 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1479](data/trainers/parties.asm#L1479) · Map: [Route38.asm:L250](maps/Route38.asm#L250)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lickitung** (`LICKITUNG`) | 54 | — | Oblivious *(slot 2, class default)* | Body Slam, Thrash, Screech, Power Whip |
| 2 | **Xatu** (`XATU`) | 56 | — | Early Bird *(slot 2, class default)* | Roost, Psycho Cut, Future Sight, Hurricane |

### CHAD5 — Route 38

**2 Pokémon, Lv. 58–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1487](data/trainers/parties.asm#L1487) · Map: [Route38.asm:L258](maps/Route38.asm#L258)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Scizor** (`SCIZOR`) | 58 | — | Swarm *(slot 2, class default)* | Iron Head, X-Scissor, Bug Bite, Swords Dance |
| 2 | **Espeon** (`ESPEON`) | 63 | — | Synchronize *(slot 2, class default)* | Psychic, Extrasensory, Aura Sphere, Morning Sun |

### Nate — Fast Ship B1F (`NATE`)

**2 Pokémon, Lv. 56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1356](data/trainers/parties.asm#L1356) · Map: [FastShipB1F.asm:L183](maps/FastShipB1F.asm#L183)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon2** (`PORYGON2`) | 56 | — | Download *(slot 2, class default)* | Tri Attack, Ice Beam, Psychic, Recover |
| 2 | **Blissey** (`BLISSEY`) | 56 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Fire Blast, Softboiled |

### Ricky — Fast Ship B1F (`RICKY`)

**2 Pokémon, Lv. 56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1366](data/trainers/parties.asm#L1366) · Map: [FastShipB1F.asm:L194](maps/FastShipB1F.asm#L194)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon2** (`PORYGON2`) | 56 | — | Download *(slot 2, class default)* | Tri Attack, Ice Beam, Thunderbolt, Recover |
| 2 | **Chansey** (`CHANSEY`) | 56 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Flamethrower, Thunderbolt |


## Bird Keeper

> **Group:** `BirdKeeperGroup` · **Battle IDs:** `BIRD_KEEPER` · **19 parties**

### Rod — Violet Gym (`ROD`)

**2 Pokémon, Lv. 7**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1503](data/trainers/parties.asm#L1503) · Map: [VioletGym.asm:L84](maps/VioletGym.asm#L84)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fletchling** (`FLETCHLING`) | 7 | — | Big Pecks *(slot 2, class default)* | Growl, Peck, Quick Attack |
| 2 | **Natu** (`NATU`) | 7 | — | Early Bird *(slot 2, class default)* | Leer, Peck, Night Shade |

### Abe — Violet Gym (`ABE`)

**1 Pokémon, Lv. 9**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1511](data/trainers/parties.asm#L1511) · Map: [VioletGym.asm:L95](maps/VioletGym.asm#L95)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rookidee** (`ROOKIDEE`) | 9 | — | Unnerve *(slot 2, class default)* | Leer, Peck, Hone Claws |

### Bryan — Route 35 (`BRYAN`)

**3 Pokémon, Lv. 21–23**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1517](data/trainers/parties.asm#L1517) · Map: [Route35.asm:L20](maps/Route35.asm#L20)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spearow** (`SPEAROW`) | 21 | — | Sniper *(slot 2, class default)* | Aerial Ace, Wing Attack, Facade, Mirror Move |
| 2 | **Pidgeotto** (`PIDGEOTTO`) | 23 | — | Tangled Feet *(slot 2, class default)* | Quick Attack, Wing Attack, Swift, Twister |
| 3 | **Fletchindr** (`FLETCHINDER`) | 23 | — | Flame Body *(slot 2, class default)* | Quick Attack, Flame Charge, Flail, Acrobatics |

### Theo — Olivine Lighthouse 3F (`THEO`)

**1 Pokémon, Lv. 32**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1527](data/trainers/parties.asm#L1527) · Map: [OlivineLighthouse3F.asm:L13](maps/OlivineLighthouse3F.asm#L13)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Natu** (`NATU`) | 32 | — | Early Bird *(slot 2, class default)* | Confusion, Confuse Ray, Psychic, Psycho Cut |

### Toby — Route 38 (`TOBY`)

**2 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1533](data/trainers/parties.asm#L1533) · Map: [Route38.asm:L16](maps/Route38.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Natu** (`NATU`) | 28 | — | Early Bird *(slot 2, class default)* | Teleport, Confusion, Confuse Ray, Psychic |
| 2 | **Fletchindr** (`FLETCHINDER`) | 28 | — | Flame Body *(slot 2, class default)* | Quick Attack, Flame Charge, Flail, Acrobatics |

### Denis — Olivine Lighthouse 5F (`DENIS`)

**2 Pokémon, Lv. 34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1541](data/trainers/parties.asm#L1541) · Map: [OlivineLighthouse5F.asm:L14](maps/OlivineLighthouse5F.asm#L14)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Watu** (`WATU`) | 34 | — | Early Bird *(slot 2, class default)* | Psybeam, Future Sight, Air Slash, Psycho Cut |
| 2 | **Corvisquir** (`CORVISQUIRE`) | 34 | — | Unnerve *(slot 2, class default)* | Scary Face, Dualwingbeat, Defog, Drill Peck |


### VANCE1 — Route 44

**4 Pokémon, Lv. 40–41**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1549](data/trainers/parties.asm#L1549) · Map: [Route44.asm:L22](maps/Route44.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fletchindr** (`FLETCHINDER`) | 40 | — | Flame Body *(slot 2, class default)* | Agility, Dualwingbeat, Defog, Aerial Ace |
| 2 | **Noctowl** (`NOCTOWL`) | 40 | — | Insomnia *(slot 2, class default)* | Psychic, Defog, Dualwingbeat, Zen Headbutt |
| 3 | **Corvisquir** (`CORVISQUIRE`) | 40 | — | Unnerve *(slot 2, class default)* | Dualwingbeat, Defog, Drill Peck, Swagger |
| 4 | **Skarmory** (`SKARMORY`) | 41 | — | Sturdy *(slot 2, class default)* | Dualwingbeat, Stealth Rock, Iron Head, Air Slash |

### VANCE2 — Route 44

**4 Pokémon, Lv. 53–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1670](data/trainers/parties.asm#L1670) · Map: [Route44.asm:L72](maps/Route44.asm#L72)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Talonflame** (`TALONFLAME`) | 53 | — | Flame Body *(slot 2, class default)* | Dualwingbeat, Defog, Aerial Ace, Heat Wave |
| 2 | **Skarmory** (`SKARMORY`) | 54 | — | Sturdy *(slot 2, class default)* | Air Slash, Body Press, Counter, Brave Bird |
| 3 | **Murkrow** (`MURKROW`) | 55 | — | Insomnia *(slot 2, class default)* | Faint Attack, Dark Pulse, Foul Play, Brave Bird |
| 4 | **Dodrio** (`DODRIO`) | 56 | — | Early Bird *(slot 2, class default)* | Lunge, Thrash, Brave Bird, Hi Jump Kick |

### VANCE3 — Route 44

**4 Pokémon, Lv. 60–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1682](data/trainers/parties.asm#L1682) · Map: [Route44.asm:L80](maps/Route44.asm#L80)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Talonflame** (`TALONFLAME`) | 60 | — | Flame Body *(slot 2, class default)* | Defog, Aerial Ace, Heat Wave, Steel Wing |
| 2 | **Honchkrow** (`HONCHKROW`) | 62 | — | Insomnia *(slot 2, class default)* | Night Slash, Faint Attack, Dark Pulse, Brave Bird |
| 3 | **Pidgeot** (`PIDGEOT`) | 62 | — | Tangled Feet *(slot 2, class default)* | Hurricane, Aerial Ace, Mirror Move, Brave Bird |
| 4 | **Noctowl** (`NOCTOWL`) | 63 | — | Insomnia *(slot 2, class default)* | Moonblast, Roost, Dream Eater, Hurricane |

### Hank — Route 4 (`HANK`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1561](data/trainers/parties.asm#L1561) · Map: [Route4.asm:L15](maps/Route4.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Archeops** (`ARCHEOPS`) | 69 | — | Wind Rider *(slot 2, class default)* | Head Smash, Dualwingbeat, X-Scissor, Quick Attack |
| 2 | **Corvknight** (`CORVIKNIGHT`) | 69 | — | Unnerve *(slot 2, class default)* | Brave Bird, Iron Head, Body Press, Roost |

### Roy — Route 14 (`ROY`)

**2 Pokémon, Lv. 65**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1571](data/trainers/parties.asm#L1571) · Map: [Route14.asm:L32](maps/Route14.asm#L32)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Skarmory** (`SKARMORY`) | 65 | — | Sturdy *(slot 2, class default)* | Brave Bird, Iron Head, Body Press, Roost |
| 2 | **Noctowl** (`NOCTOWL`) | 65 | — | Insomnia *(slot 2, class default)* | Psychic, Hurricane, Moonblast, Roost |

### Boris — Route 18 (`BORIS`)

**3 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1581](data/trainers/parties.asm#L1581) · Map: [Route18.asm:L14](maps/Route18.asm#L14)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeot** (`PIDGEOT`) | 66 | — | Tangled Feet *(slot 2, class default)* | Hurricane, Hyper Voice, Roost, U-Turn |
| 2 | **Skarmory** (`SKARMORY`) | 66 | — | Sturdy *(slot 2, class default)* | Brave Bird, Iron Head, Body Press, Night Slash |
| 3 | **Honchkrow** (`HONCHKROW`) | 66 | — | Insomnia *(slot 2, class default)* | Foul Play, Brave Bird, Sucker Punch, Steel Wing |

### Bob — Route 18 (`BOB`)

**2 Pokémon, Lv. 67–68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1594](data/trainers/parties.asm#L1594) · Map: [Route18.asm:L25](maps/Route18.asm#L25)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dodrio** (`DODRIO`) | 67 | — | Early Bird *(slot 2, class default)* | Brave Bird, Quick Attack, Hi Jump Kick, Drill Run |
| 2 | **Noctowl** (`NOCTOWL`) | 68 | — | Insomnia *(slot 2, class default)* | Psychic, Hurricane, Moonblast, Roost |


### JOSE1 — Route 27

**4 Pokémon, Lv. 56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1604](data/trainers/parties.asm#L1604) · Map: [Route27.asm:L113](maps/Route27.asm#L113)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Talonflame** (`TALONFLAME`) | 56 | — | Flame Body *(slot 2, class default)* | Defog, Aerial Ace, Heat Wave, Steel Wing |
| 2 | **Honchkrow** (`HONCHKROW`) | 56 | — | Insomnia *(slot 2, class default)* | Night Slash, Faint Attack, Dark Pulse, Brave Bird |
| 3 | **Skarmory** (`SKARMORY`) | 56 | — | Sturdy *(slot 2, class default)* | Air Slash, Body Press, Counter, Brave Bird |
| 4 | **Noctowl** (`NOCTOWL`) | 56 | — | Insomnia *(slot 2, class default)* | Moonblast, Roost, Dream Eater, Hurricane |

### JOSE2 — Route 27

**4 Pokémon, Lv. 45–46**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1624](data/trainers/parties.asm#L1624) · Map: [Route27.asm:L61](maps/Route27.asm#L61)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fletchindr** (`FLETCHINDER`) | 45 | — | Flame Body *(slot 2, class default)* | Agility, Dualwingbeat, Defog, Aerial Ace |
| 2 | **Natu** (`NATU`) | 46 | — | Early Bird *(slot 2, class default)* | Confuse Ray, Psychic, Psycho Cut, Future Sight |
| 3 | **Corvisquir** (`CORVISQUIRE`) | 46 | — | Unnerve *(slot 2, class default)* | Defog, Drill Peck, Swagger, Brave Bird |
| 4 | **Murkrow** (`MURKROW`) | 46 | — | Insomnia *(slot 2, class default)* | Faint Attack, Dark Pulse, Foul Play, Brave Bird |

### JOSE3 — Route 27

**5 Pokémon, Lv. 63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1656](data/trainers/parties.asm#L1656) · Map: [Route27.asm:L121](maps/Route27.asm#L121)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Honchkrow** (`HONCHKROW`) | 63 | — | Insomnia *(slot 2, class default)* | Night Slash, Faint Attack, Dark Pulse, Brave Bird |
| 2 | **Delibird** (`DELIBIRD`) | 63 | — | Hustle *(slot 2, class default)* | Future Sight, Blizzard, Hurricane, Destiny Bond |
| 3 | **Talonflame** (`TALONFLAME`) | 63 | — | Flame Body *(slot 2, class default)* | Defog, Aerial Ace, Heat Wave, Steel Wing |
| 4 | **Skarmory** (`SKARMORY`) | 63 | — | Sturdy *(slot 2, class default)* | Air Slash, Body Press, Counter, Brave Bird |
| 5 | **Xatu** (`XATU`) | 63 | — | Early Bird *(slot 2, class default)* | Roost, Psycho Cut, Future Sight, Hurricane |

### Peter — Route 32 (`PETER`)

**2 Pokémon, Lv. 12**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1616](data/trainers/parties.asm#L1616) · Map: [Route32.asm:L442](maps/Route32.asm#L442)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spearow** (`SPEAROW`) | 12 | — | Sniper *(slot 2, class default)* | Leer, Fury Attack, Pursuit, Aerial Ace |
| 2 | **Hoothoot** (`HOOTHOOT`) | 12 | — | Insomnia *(slot 2, class default)* | Tackle, Foresight, Hypnosis, Confusion |

### Perry — Route 13 (`PERRY`)

**2 Pokémon, Lv. 65–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1636](data/trainers/parties.asm#L1636) · Map: [Route13.asm:L36](maps/Route13.asm#L36)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Honchkrow** (`HONCHKROW`) | 65 | — | Insomnia *(slot 2, class default)* | Foul Play, Brave Bird, Sucker Punch, Steel Wing |
| 2 | **Corvknight** (`CORVIKNIGHT`) | 66 | — | Unnerve *(slot 2, class default)* | Brave Bird, Iron Head, Body Press, Roost |

### Bret — Route 13 (`BRET`)

**2 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1646](data/trainers/parties.asm#L1646) · Map: [Route13.asm:L47](maps/Route13.asm#L47)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Honchkrow** (`HONCHKROW`) | 64 | — | Insomnia *(slot 2, class default)* | Foul Play, Brave Bird, Sucker Punch, Steel Wing |
| 2 | **Talonflame** (`TALONFLAME`) | 64 | — | Flame Body *(slot 2, class default)* | Brave Bird, Flare Blitz, U-Turn, Roost |


## Lass

> **Group:** `LassGroup` · **Battle IDs:** `LASS` · **18 parties**

### Carrie — Goldenrod Gym (`CARRIE`)

**1 Pokémon, Lv. 20**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1697](data/trainers/parties.asm#L1697) · Map: [GoldenrodGym.asm:L110](maps/GoldenrodGym.asm#L110)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Impidimp** (`IMPIDIMP`) | 20 | — | Frisk *(slot 2, class default)* | Bite, Low Sweep |

### Bridget — Goldenrod Gym (`BRIDGET`)

**2 Pokémon, Lv. 18**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1704](data/trainers/parties.asm#L1704) · Map: [GoldenrodGym.asm:L134](maps/GoldenrodGym.asm#L134)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Snubbull** (`SNUBBULL`) | 18 | — | Run Away *(slot 2, class default)* | Pixie Punch, Lick, Bite, Headbutt |
| 2 | **Marill** (`MARILL`) | 18 | — | Thick Fat *(slot 2, class default)* | Charm, Bubblebeam, Slam, Aqua Jet |

### Krise — National Park (`KRISE`)

**2 Pokémon, Lv. 23–24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1712](data/trainers/parties.asm#L1712) · Map: [NationalPark.asm:L280](maps/NationalPark.asm#L280)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Morgrem** (`MORGREM`) | 23 | — | Frisk *(slot 2, class default)* | Bite, Sucker Punch, Swagger, Low Sweep |
| 2 | **Tangela** (`TANGELA`) | 24 | — | Leaf Guard *(slot 2, class default)* | Poisonpowder, Bullet Seed, Mega Drain, Knock Off |


### CONNIE1 — Olivine Lighthouse 4F

**2 Pokémon, Lv. 31–32**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1720](data/trainers/parties.asm#L1720) · Map: [OlivineLighthouse4F.asm:L11](maps/OlivineLighthouse4F.asm#L11)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lombre** (`LOMBRE`) | 31 | — | Rain Dish *(slot 2, class default)* | Fury Swipes, Bubblebeam, Giga Drain, Leech Seed |
| 2 | **Remoraid** (`REMORAID`) | 32 | — | Sniper *(slot 2, class default)* | Bubblebeam, Focus Energy, Water Pulse, Ice Beam |

### CONNIE2 — Olivine Lighthouse 4F (rematch)

**1 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1779](data/trainers/parties.asm#L1779) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 43 | — | Water Absorb *(slot 2, class default)* | Signal Beam, Thunderbolt, Take Down, Hydro Pump |

### CONNIE3 — Olivine Lighthouse 4F (rematch)

**2 Pokémon, Lv. 55–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1785](data/trainers/parties.asm#L1785) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Remoraid** (`REMORAID`) | 55 | — | Sniper *(slot 2, class default)* | Flamethrower, Hydro Pump, Gunk Shot, Hyper Beam |
| 2 | **Chinchou** (`CHINCHOU`) | 56 | — | Water Absorb *(slot 2, class default)* | Signal Beam, Thunderbolt, Take Down, Hydro Pump |

### Laura — Route 25 (`LAURA`)

**3 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1728](data/trainers/parties.asm#L1728) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Nidoqueen** (`NIDOQUEEN`) | 58 | — | Mold Breaker *(slot 2, class default)* | Body Slam, Cross Poison, Drill Run, Crunch |
| 2 | **Jumpluff** (`JUMPLUFF`) | 58 | — | Leaf Guard *(slot 2, class default)* | Acrobatics, U-Turn, Energy Ball, Leaf Storm |
| 3 | **Rapidash** (`RAPIDASH_GALARIAN`) | 58 | — | Pastel Veil *(slot 2, class default)* | Play Rough, Take Down, Flare Blitz, Psychic |

### Shannon — Route 25 (`SHANNON`)

**3 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1738](data/trainers/parties.asm#L1738) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxicroak** (`TOXICROAK`) | 58 | — | Dry Skin *(slot 2, class default)* | Cross Chop, Superpower, Sludge Bomb, Gunk Shot |
| 2 | **Octillery** (`OCTILLERY`) | 58 | — | Sniper *(slot 2, class default)* | Flamethrower, Hydro Pump, Gunk Shot, Hyper Beam |
| 3 | **Victreebel** (`VICTREEBEL`) | 58 | — | Poison Puppeteer *(slot 2, class default)* | Sucker Punch, Knock Off, Leaf Storm, Slam |

### Michelle — Celadon Gym (`MICHELLE`)

**3 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1748](data/trainers/parties.asm#L1748) · Map: [CeladonGym.asm:L51](maps/CeladonGym.asm#L51)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vileplume** (`VILEPLUME`) | 64 | — | Poison Puppeteer *(slot 2, class default)* | Leaf Storm, Sludge Bomb, Earth Power, Growth |
| 2 | **Ludicolo** (`LUDICOLO`) | 64 | — | Rain Dish *(slot 2, class default)* | Leaf Storm, Surf, Zen Headbutt, Waterfall |
| 3 | **Jumpluff** (`JUMPLUFF`) | 64 | — | Leaf Guard *(slot 2, class default)* | Leaf Storm, Air Slash, Synthesis, U-Turn |


### DANA1 — Route 38

**2 Pokémon, Lv. 26–27**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1761](data/trainers/parties.asm#L1761) · Map: [Route38.asm:L38](maps/Route38.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Togetic** (`TOGETIC`) | 26 | — | Serene Grace *(slot 2, class default)* | Drain Kiss, Extrasensory, Ancientpower, Encore |
| 2 | **Misdreavus** (`MISDREAVUS`) | 27 | — | Levitate *(slot 2, class default)* | Shadow Ball, Hex, Drain Kiss, Confuse Ray |

### DANA2 — Route 38

**2 Pokémon, Lv. 34**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1793](data/trainers/parties.asm#L1793) · Map: [Route38.asm:L98](maps/Route38.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Staryu** (`STARYU`) | 34 | — | Analytic *(slot 2, class default)* | Bubblebeam, Water Pulse, Psybeam, Recover |
| 2 | **Chinchou** (`CHINCHOU`) | 34 | — | Water Absorb *(slot 2, class default)* | Bubblebeam, Spark, Water Gun, Thunder Wave |

### DANA3 — Route 38

**2 Pokémon, Lv. 43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1803](data/trainers/parties.asm#L1803) · Map: [Route38.asm:L106](maps/Route38.asm#L106)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weezing** (`WEEZING_GALARIAN`) | 43 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Sludge, Psybeam, Fairy Wind |
| 2 | **Breloom** (`BRELOOM`) | 43 | — | Poison Heal *(slot 2, class default)* | Seed Bomb, Brick Break, Drain Punch, Spore |

### DANA4 — Route 38

**2 Pokémon, Lv. 55–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1813](data/trainers/parties.asm#L1813) · Map: [Route38.asm:L114](maps/Route38.asm#L114)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Azumarill** (`AZUMARILL`) | 55 | — | Thick Fat *(slot 2, class default)* | Hydro Pump, Bubblebeam, Play Rough, Belly Drum |
| 2 | **Dewgong** (`DEWGONG`) | 56 | — | Swift Swim *(slot 2, class default)* | Icicle Crash, Aqua Tail, Ice Beam, Rest |

### DANA5 — Route 38

**2 Pokémon, Lv. 62–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1823](data/trainers/parties.asm#L1823) · Map: [Route38.asm:L122](maps/Route38.asm#L122)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Granbull** (`GRANBULL`) | 62 | — | Quick Feet *(slot 2, class default)* | Play Rough, Close Combat, Outrage, Work Up |
| 2 | **Altaria** (`ALTARIA`) | 63 | — | Natural Cure *(slot 2, class default)* | Brave Bird, Moonblast, Dragon Pulse, Dragon Dance |

### Ellen — Route 25 (`ELLEN`)

**2 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1771](data/trainers/parties.asm#L1771) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flapple** (`FLAPPLE`) | 58 | — | Gluttony *(slot 2, class default)* | Grav Apple, Fly, Wood Hammer, Leaf Storm |
| 2 | **Rapidash** (`RAPIDASH_GALARIAN`) | 58 | — | Pastel Veil *(slot 2, class default)* | Play Rough, Take Down, Flare Blitz, Psychic |

### Danielle — Olivine Gym (after Jasmine returns) (`DANIELLE`)

**3 Pokémon, Lv. 33–35**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1833](data/trainers/parties.asm#L1833) · Map: [OlivineGym.asm:L135](maps/OlivineGym.asm#L135)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lairon** (`LAIRON`) | 33 | — | Sturdy *(slot 2, class default)* | Rock Slide, Roar, Iron Head, Take Down |
| 2 | **Forretress** (`FORRETRESS`) | 34 | — | Sturdy *(slot 2, class default)* | Toxic Spikes, Gyro Ball, Iron Defense, Stealth Rock |
| 3 | **Skarmory** (`SKARMORY`) | 35 | — | Sturdy *(slot 2, class default)* | Slash, Night Slash, Defog, Dualwingbeat |

### Kathryn — Olivine Gym (after Jasmine returns) (`KATHRYN`)

**3 Pokémon, Lv. 34–35**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L1843](data/trainers/parties.asm#L1843) · Map: [OlivineGym.asm:L146](maps/OlivineGym.asm#L146)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magneton** (`MAGNETON`) | 34 | — | Analytic *(slot 2, class default)* | Spark, Light Screen, Tri Attack, Flash Cannon |
| 2 | **Skarmory** (`SKARMORY`) | 34 | — | Sturdy *(slot 2, class default)* | Slash, Night Slash, Defog, Dualwingbeat |
| 3 | **Forretress** (`FORRETRESS`) | 35 | — | Sturdy *(slot 2, class default)* | Toxic Spikes, Gyro Ball, Iron Defense, Stealth Rock |

### Paige — Route 25 (`PAIGE`)

**2 Pokémon, Lv. 58–59**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1853](data/trainers/parties.asm#L1853) · Map: [Route25.asm:L448](maps/Route25.asm#L448)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vaporeon** (`VAPOREON`) | 58 | — | Hydration *(slot 2, class default)* | Hydro Pump, Ice Beam, Shadow Ball, Acid Armor |
| 2 | **Dewgong** (`DEWGONG`) | 59 | — | Swift Swim *(slot 2, class default)* | Ice Beam, Surf, Megahorn, Aqua Jet |


## Janine

> **Group:** `JanineGroup` · **Battle IDs:** `JANINE` · **1 parties**

### Janine — Fuchsia Gym (`JANINE1`)

**6 Pokémon, Lv. 65–68**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L1866](data/trainers/parties.asm#L1866) · Map: [FuchsiaGym.asm:L24](maps/FuchsiaGym.asm#L24)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxapex** (`TOXAPEX`) | 65 | Leftovers | Regenerator *(hidden)* | Toxic Spikes, Scald, Recover, Bane Bunker |
| 2 | **Venomoth** (`VENOMOTH`) | 66 | Life Orb | Tinted Lens *(slot 1)* | Quiver Dance, Bug Buzz, Sludge Bomb, Sleep Powder |
| 3 | **Seviper** (`SEVIPER`) | 66 | Life Orb | Merciless *(hidden)* | Gunk Shot, Crunch, Earthquake, Sucker Punch |
| 4 | **Overqwil** (`OVERQWIL`) | 67 | Leftovers | Intimidate *(hidden)* | Barb Barrage, Crunch, Aqua Tail, Swords Dance |
| 5 | **Ariados** (`ARIADOS`) | 67 | Life Orb | Merciless *(hidden)* | Megahorn, Poison Jab, Sucker Punch, Toxic |
| 6 | **Crobat** (`CROBAT`) | 68 | Brightpowder | Merciless *(slot 1)* | Cross Poison, Brave Bird, U-Turn, Roost |


## Cooltrainer M

> **Group:** `CooltrainerMGroup` · **Battle IDs:** `COOLTRAINERM` · **20 parties**

### Nick — Union Cave B2F (`NICK`)

**3 Pokémon, Lv. 46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1903](data/trainers/parties.asm#L1903) · Map: [UnionCaveB2F.asm:L39](maps/UnionCaveB2F.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wartortle** (`WARTORTLE`) | 46 | — | Torrent *(slot 2, class default)* | Water Pulse, Water Gun, Bite, Protect |
| 2 | **Sneasel** (`SNEASEL_HISUIAN`) | 46 | — | Poison Touch *(slot 2, class default)* | Poison Jab, Poison Fang, Slash, Focus Energy |
| 3 | **Growlithe** (`GROWLITHE_HISUIAN`) | 46 | — | Flash Fire *(slot 2, class default)* | Rock Slide, Fire Fang, Flamethrower, Bite |

### Aaron — Lake of Rage (`AARON`)

**3 Pokémon, Lv. 36**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1916](data/trainers/parties.asm#L1916) · Map: [LakeOfRage.asm:L184](maps/LakeOfRage.asm#L184)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Croconaw** (`CROCONAW`) | 36 | — | Torrent *(slot 2, class default)* | Crunch, Bite, Ice Fang, Aqua Jet |
| 2 | **Poliwhirl** (`POLIWHIRL`) | 36 | — | Damp *(slot 2, class default)* | Body Slam, Low Sweep, Bubblebeam, Hypnosis |
| 3 | **Azumarill** (`AZUMARILL`) | 36 | — | Thick Fat *(slot 2, class default)* | Hydro Pump, Bubblebeam, Play Rough, Charm |

### Paul — Blackthorn Gym 1F (`PAUL`)

**4 Pokémon, Lv. 36–40**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1929](data/trainers/parties.asm#L1929) · Map: [BlackthornGym1F.asm:L110](maps/BlackthornGym1F.asm#L110)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dragonair** (`DRAGONAIR`) | 36 | — | Shed Skin *(slot 2, class default)* | Dragon Pulse, Aqua Tail, Slam, Thunder Wave |
| 2 | **Zweilous** (`ZWEILOUS`) | 40 | — | Hustle *(slot 2, class default)* | Crunch, Bite, Dragon Pulse, Focus Energy |
| 3 | **Dunsparce** (`DUNSPARCE`) | 40 | — | Rattled *(slot 2, class default)* | Double-Edge, Body Slam, Air Slash, Roost |
| 4 | **Drakloak** (`DRAKLOAK`) | 40 | — | Infiltrator *(slot 2, class default)* | Dragon Pulse, Dragon Tail, U-Turn, Agility |

### Cody — Blackthorn Gym 2F (`CODY`)

**4 Pokémon, Lv. 41–43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1945](data/trainers/parties.asm#L1945) · Map: [BlackthornGym2F.asm:L60](maps/BlackthornGym2F.asm#L60)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingdra** (`KINGDRA`) | 41 | — | Sniper *(slot 2, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |
| 2 | **Ampharos** (`AMPHAROS`) | 42 | — | Mold Breaker *(slot 2, class default)* | Dragon Pulse, Power Gem, Zap Cannon, Thunder Wave |
| 3 | **Hydrapple** (`HYDRAPPLE`) | 42 | — | Sheer Force *(slot 2, class default)* | Energy Ball, Dragon Pulse, Dragonbreath, Recover |
| 4 | **Exeggutor** (`EXEGGUTOR_ALOLAN`) | 43 | — | Harvest *(slot 2, class default)* | Seed Bomb, Zen Headbutt, Stomp, Synthesis |

### Mike — Blackthorn Gym 1F (`MIKE`)

**3 Pokémon, Lv. 42–43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1961](data/trainers/parties.asm#L1961) · Map: [BlackthornGym1F.asm:L121](maps/BlackthornGym1F.asm#L121)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dragonair** (`DRAGONAIR`) | 42 | — | Shed Skin *(slot 2, class default)* | Dragon Pulse, Dragon Tail, Aqua Tail, Dragon Dance |
| 2 | **Kingdra** (`KINGDRA`) | 42 | — | Sniper *(slot 2, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |
| 3 | **Charizard** (`CHARIZARD`) | 43 | — | Blaze *(slot 2, class default)* | Flamethrower, Dragonbreath, Dragon Claw, Air Slash |


### GAVEN1 — Route 26

**5 Pokémon, Lv. 56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1974](data/trainers/parties.asm#L1974) · Map: [Route26.asm:L78](maps/Route26.asm#L78)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sunflora** (`SUNFLORA`) | 56 | — | Solar Power *(slot 2, class default)* | Energy Ball, Wood Hammer, Pound, Morning Sun |
| 2 | **Umbreon** (`UMBREON`) | 56 | — | Inner Focus *(slot 2, class default)* | Foul Play, Crunch, Double-Edge, Moonlight |
| 3 | **Cloyster** (`CLOYSTER`) | 56 | — | Shell Armor *(slot 2, class default)* | Freeze-Dry, Aurora Beam, Bubblebeam, Protect |
| 4 | **Venomoth** (`VENOMOTH`) | 56 | — | Compound Eyes *(slot 2, class default)* | Bug Buzz, Signal Beam, Psychic, Quiver Dance |
| 5 | **Hitmontop** (`HITMONTOP`) | 56 | — | Intimidate *(slot 2, class default)* | Close Combat, Body Press, Sucker Punch, Agility |

### GAVEN2 — Route 26

**5 Pokémon, Lv. 63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L1993](data/trainers/parties.asm#L1993) · Map: [Route26.asm:L86](maps/Route26.asm#L86)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Electrode** (`ELECTRODE`) | 63 | — | Static *(slot 2, class default)* | Thunderbolt, Signal Beam, Spark, Light Screen |
| 2 | **Donphan** (`DONPHAN`) | 63 | — | Sturdy *(slot 2, class default)* | Earthquake, Giga Impact, Superpower, Charm |
| 3 | **Xatu** (`XATU`) | 63 | — | Early Bird *(slot 2, class default)* | Psychic, Air Slash, Future Sight, Roost |
| 4 | **Golem** (`GOLEM`) | 63 | — | Sturdy *(slot 2, class default)* | Earthquake, Stone Edge, Superpower, Stealth Rock |
| 5 | **Politoed** (`POLITOED`) | 63 | — | Damp *(slot 2, class default)* | Hydro Pump, Bubblebeam, Earth Power, Belly Drum |

### GAVEN3 — Route 26

**5 Pokémon, Lv. 47–49**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2044](data/trainers/parties.asm#L2044) · Map: [Route26.asm:L28](maps/Route26.asm#L28)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vaporeon** (`VAPOREON`) | 47 | — | Hydration *(slot 2, class default)* | Hydro Pump, Scald, Ice Beam, Acid Armor |
| 2 | **Miltank** (`MILTANK`) | 48 | — | Scrappy *(slot 2, class default)* | Body Slam, Headbutt, Play Rough, Milk Drink |
| 3 | **Muk** (`MUK`) | 48 | — | Sticky Hold *(slot 2, class default)* | Poison Jab, Cross Poison, Moonblast, Toxic |
| 4 | **Raichu** (`RAICHU_ALOLAN`) | 48 | — | Motor Drive *(slot 2, class default)* | Psychic, Spark, Thundershock, Nasty Plot |
| 5 | **Shuckle** (`SHUCKLE`) | 49 | — | Gluttony *(slot 2, class default)* | Rock Slide, Bug Bite, Rock Tomb, Stealth Rock |

### Ryan — Route 45 (`RYAN`)

**3 Pokémon, Lv. 42**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2012](data/trainers/parties.asm#L2012) · Map: [Route45.asm:L245](maps/Route45.asm#L245)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 42 | — | Hyper Cutter *(slot 2, class default)* | Earthquake, Drill Run, Wing Attack, Screech |
| 2 | **Rhydon** (`RHYDON`) | 42 | — | Reckless *(slot 2, class default)* | Double-Edge, Rock Slide, Bulldoze, Stealth Rock |
| 3 | **Conkeldurr** (`CONKELDURR`) | 42 | — | Sheer Force *(slot 2, class default)* | Brick Break, Low Sweep, Rock Slide, Bulk Up |

### Jake — Route 26 (`JAKE`)

**5 Pokémon, Lv. 48–50**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2025](data/trainers/parties.asm#L2025) · Map: [Route26.asm:L17](maps/Route26.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Miltank** (`MILTANK`) | 48 | — | Scrappy *(slot 2, class default)* | Body Slam, Headbutt, Play Rough, Milk Drink |
| 2 | **Umbreon** (`UMBREON`) | 48 | — | Inner Focus *(slot 2, class default)* | Foul Play, Crunch, Double-Edge, Moonlight |
| 3 | **Nidoking** (`NIDOKING`) | 48 | — | Mold Breaker *(slot 2, class default)* | Poison Jab, Drill Run, Cross Poison, Toxic Spikes |
| 4 | **Porygon2** (`PORYGON2`) | 48 | — | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Psychic, Recover |
| 5 | **Feraligatr** (`FERALIGATR`) | 50 | — | Torrent *(slot 2, class default)* | Aqua Tail, Crunch, Night Slash, Agility |

### Blake — Route 27 (`BLAKE`)

**4 Pokémon, Lv. 45–46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2063](data/trainers/parties.asm#L2063) · Map: [Route27.asm:L174](maps/Route27.asm#L174)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mantine** (`MANTINE`) | 45 | — | Water Absorb *(slot 2, class default)* | Air Slash, Bubblebeam, Water Pulse, Roost |
| 2 | **Slowking** (`SLOWKING`) | 45 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Future Sight, Nasty Plot |
| 3 | **Wyrdeer** (`WYRDEER`) | 46 | — | Frisk *(slot 2, class default)* | Thrash, Take Down, Zen Headbutt, Calm Mind |
| 4 | **Sealeo** (`SEALEO`) | 46 | — | Ice Body *(slot 2, class default)* | Ice Beam, Freeze-Dry, Water Pulse, Belly Drum |

### Brian — Route 27 (`BRIAN`)

**4 Pokémon, Lv. 46–48**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2079](data/trainers/parties.asm#L2079) · Map: [Route27.asm:L185](maps/Route27.asm#L185)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 46 | — | Early Bird *(slot 2, class default)* | Psychic, Air Slash, Future Sight, Roost |
| 2 | **Quagsire** (`QUAGSIRE`) | 47 | — | Water Absorb *(slot 2, class default)* | Earthquake, Aqua Tail, Body Slam, Amnesia |
| 3 | **Seaking** (`SEAKING`) | 48 | — | Water Absorb *(slot 2, class default)* | Water Pulse, Waterfall, Body Slam, Agility |
| 4 | **Corvknight** (`CORVIKNIGHT`) | 48 | — | Unnerve *(slot 2, class default)* | Drill Peck, Steel Wing, Body Press, Roost |

### Sean — Fast Ship Cabins / NNW / NNE / NE (`SEAN`)

**3 Pokémon, Lv. 55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2095](data/trainers/parties.asm#L2095) · Map: [FastShipCabins_NNW_NNE_NE.asm:L16](maps/FastShipCabins_NNW_NNE_NE.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Walrein** (`WALREIN`) | 55 | — | Ice Body *(slot 2, class default)* | Surf, Ice Beam, Blizzard, Water Pulse |
| 2 | **Gyarados** (`GYARADOS`) | 55 | — | Intimidate *(slot 2, class default)* | Waterfall, Aqua Tail, Outrage, Dragon Dance |
| 3 | **Blissey** (`BLISSEY`) | 55 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Double-Edge, Disarm Voice, Softboiled |

### Kevin — Route 25 (`KEVIN`)

**4 Pokémon, Lv. 58–60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2108](data/trainers/parties.asm#L2108) · Map: [Route25.asm:L499](maps/Route25.asm#L499)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seaking** (`SEAKING`) | 58 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Water Pulse, Megahorn, Agility |
| 2 | **Sandslash** (`SANDSLASH`) | 58 | — | Sand Force *(slot 2, class default)* | Earthquake, Drill Run, Poison Jab, Swords Dance |
| 3 | **Alakazam** (`ALAKAZAM`) | 59 | — | Synchronize *(slot 2, class default)* | Psychic, Future Sight, Focus Blast, Calm Mind |
| 4 | **Espeon** (`ESPEON`) | 60 | — | Synchronize *(slot 2, class default)* | Psychic, Extrasensory, Aura Sphere, Morning Sun |

### Allen — Route 44 (`ALLEN`)

**2 Pokémon, Lv. 39–41**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2124](data/trainers/parties.asm#L2124) · Map: [Route44.asm:L292](maps/Route44.asm#L292)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sandslash** (`SANDSLASH_ALOLAN`) | 39 | — | Tough Claws *(slot 2, class default)* | Iron Head, Crush Claw, Metal Claw, Hone Claws |
| 2 | **Dusknoir** (`DUSKNOIR`) | 41 | — | Prankster *(slot 2, class default)* | Shadow Punch, Shadow Ball, Thunderpunch, Will-O-Wisp |

### Darin — Dragon's Den B1F (`DARIN`)

**4 Pokémon, Lv. 46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2134](data/trainers/parties.asm#L2134) · Map: [DragonsDenB1F.asm:L85](maps/DragonsDenB1F.asm#L85)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ampharos** (`AMPHAROS`) | 46 | — | Mold Breaker *(slot 2, class default)* | Dragon Pulse, Power Gem, Zap Cannon, Thunder Wave |
| 2 | **Kingdra** (`KINGDRA`) | 46 | — | Sniper *(slot 2, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |
| 3 | **Exeggutor** (`EXEGGUTOR_ALOLAN`) | 46 | — | Harvest *(slot 2, class default)* | Seed Bomb, Zen Headbutt, Stomp, Synthesis |
| 4 | **Dipplin** (`DIPPLIN`) | 46 | — | Gluttony *(slot 2, class default)* | Energy Ball, Dragon Pulse, Dragonbreath, Recover |

### Larry — Viridian Gym (`LARRY2`)

**4 Pokémon, Lv. 70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L2150](data/trainers/parties.asm#L2150) · Map: [ViridianGym.asm:L45](maps/ViridianGym.asm#L45)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Scolipede** (`SCOLIPEDE`) | 70 | Life Orb | Speed Boost *(hidden)* | Megahorn, Poison Jab, Earthquake, Swords Dance |
| 2 | **Golisopod** (`GOLISOPOD`) | 70 | Assault Vest | Battle Armor *(slot 1)* | First Strike, Liquidation, Knock Off, Leech Life |
| 3 | **Salamence** (`SALAMENCE`) | 70 | Expert Belt | Moxie *(slot 2)* | Dragon Dance, Dragon Claw, Earthquake, Crunch |
| 4 | **Blastoise** (`BLASTOISE_CLONE`) | 70 | Assault Vest | --- *(slot 1)* | Water Pulse, Dark Pulse, Aura Sphere, Ice Beam |

### Snow — Viridian Gym (`SNOW`)

**4 Pokémon, Lv. 71**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L2174](data/trainers/parties.asm#L2174) · Map: [ViridianGym.asm:L56](maps/ViridianGym.asm#L56)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lapras** (`LAPRAS`) | 71 | Leftovers | Water Absorb *(slot 1)* | Surf, Freeze-Dry, Thunderbolt, Confuse Ray |
| 2 | **Mismagius** (`MISMAGIUS`) | 71 | Wise Glasses | Prankster *(hidden)* | Nasty Plot, Shadow Ball, Thunderbolt, Dazzle Gleam |
| 3 | **Gardevoir** (`GARDEVOIR`) | 71 | Expert Belt | Synchronize *(slot 1)* | Calm Mind, Psychic, Moonblast, Focus Blast |
| 4 | **Charizard** (`CHARIZARD_CLONE`) | 71 | Life Orb | --- *(slot 1)* | Fire Blast, Dragon Pulse, Earthquake, Roost |

### Cy — Viridian Gym (`CYANIDE`)

**4 Pokémon, Lv. 70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L2198](data/trainers/parties.asm#L2198) · Map: [ViridianGym.asm:L67](maps/ViridianGym.asm#L67)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingdra** (`KINGDRA`) | 70 | Wise Glasses | Sniper *(slot 2)* | Draco Meteor, Hydro Pump, Ice Beam, Flip Turn |
| 2 | **Tyranitar** (`TYRANITAR`) | 70 | Leftovers | Intimidate *(hidden)* | Dragon Dance, Stone Edge, Crunch, Earthquake |
| 3 | **Dragonite** (`DRAGONITE`) | 70 | Expert Belt | Multiscale *(hidden)* | Dragon Dance, Outrage, Extremespeed, Fire Punch |
| 4 | **Venusaur** (`VENUSAUR_CLONE`) | 70 | Leftovers | --- *(hidden)* | Sleep Powder, Giga Drain, Sludge Bomb, Earth Power |

### Chantz — Vermilion City (`CHANTZ`)

**4 Pokémon, Lv. 51–53**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L2222](data/trainers/parties.asm#L2222) · Map: [VermilionCity.asm:L100](maps/VermilionCity.asm#L100)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Persian** (`PERSIAN`) | 51 | Pink Bow | Technician *(slot 1)* | Fake Out, Slash, Play Rough, Screech |
| 2 | **Granbull** (`GRANBULL`) | 51 | — | Strong Jaw *(hidden)* | Play Rough, Crunch, Thunderpunch, Roar |
| 3 | **Kangaskhan** (`KANGASKHAN`) | 52 | Leftovers | Scrappy *(slot 1)* | Body Slam, Earthquake, Sucker Punch, Fake Out |
| 4 | **Ursaring** (`URSARING`) | 53 | Life Orb | Unnerve *(hidden)* | Body Slam, Crunch, Hammer Arm, Rest |


## Cooltrainer F

> **Group:** `CooltrainerFGroup` · **Battle IDs:** `COOLTRAINERF` · **21 parties**

### Gwen — Union Cave B2F (`GWEN`)

**4 Pokémon, Lv. 42–45**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2248](data/trainers/parties.asm#L2248) · Map: [UnionCaveB2F.asm:L50](maps/UnionCaveB2F.asm#L50)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Phanpy** (`PHANPY`) | 42 | — | Pickup *(slot 2, class default)* | Bulldoze, Headbutt, Slam, Mud Shot |
| 2 | **Whirlipede** (`WHIRLIPEDE`) | 43 | — | Swarm *(slot 2, class default)* | Bug Bite, Poison Fang, Rollout, Protect |
| 3 | **Onix** (`ONIX`) | 44 | — | Sturdy *(slot 2, class default)* | Rock Slide, Bulldoze, Rock Tomb, Curse |
| 4 | **Graveler** (`GRAVELER`) | 45 | — | Sturdy *(slot 2, class default)* | Rock Slide, Bulldoze, Rock Tomb, Sandstorm |

### Lois — Lake of Rage (`LOIS`)

**2 Pokémon, Lv. 36–37**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2264](data/trainers/parties.asm#L2264) · Map: [LakeOfRage.asm:L195](maps/LakeOfRage.asm#L195)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lombre** (`LOMBRE`) | 36 | — | Rain Dish *(slot 2, class default)* | Bubblebeam, Giga Drain, Mega Drain, Water Gun |
| 2 | **Slowpoke** (`SLOWPOKE`) | 37 | — | Unaware *(slot 2, class default)* | Aqua Tail, Zen Headbutt, Headbutt, Curse |

### Fran — Blackthorn Gym 2F (`FRAN`)

**3 Pokémon, Lv. 41**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2274](data/trainers/parties.asm#L2274) · Map: [BlackthornGym2F.asm:L71](maps/BlackthornGym2F.asm#L71)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingdra** (`KINGDRA`) | 41 | — | Sniper *(slot 2, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |
| 2 | **Appletun** (`APPLETUN`) | 41 | — | Gluttony *(slot 2, class default)* | Dragon Pulse, Mega Drain, Body Slam, Recover |
| 3 | **Arctibax** (`ARCTIBAX`) | 41 | — | Thermal Exchange *(slot 2, class default)* | Ice Fang, Dragon Tail, Take Down, Focus Energy |

### Lola — Blackthorn Gym 1F (`LOLA`)

**4 Pokémon, Lv. 41–42**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2287](data/trainers/parties.asm#L2287) · Map: [BlackthornGym1F.asm:L132](maps/BlackthornGym1F.asm#L132)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Shelgon** (`SHELGON`) | 41 | — | Battle Armor *(slot 2, class default)* | Dragon Claw, Crunch, Zen Headbutt, Dragon Dance |
| 2 | **Appletun** (`APPLETUN`) | 41 | — | Gluttony *(slot 2, class default)* | Dragon Pulse, Mega Drain, Body Slam, Recover |
| 3 | **Zweilous** (`ZWEILOUS`) | 42 | — | Hustle *(slot 2, class default)* | Foul Play, Crunch, Dragon Pulse, Focus Energy |
| 4 | **Charizard** (`CHARIZARD`) | 42 | — | Blaze *(slot 2, class default)* | Flamethrower, Dragonbreath, Dragon Claw, Air Slash |

### Kate — Route 34 (`KATE`)

**2 Pokémon, Lv. 18–20**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2303](data/trainers/parties.asm#L2303) · Map: [Route34.asm:L454](maps/Route34.asm#L454)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA_GALARIAN`) | 18 | — | Weak Armor *(slot 2, class default)* | Hex, Ancientpower, Rock Tomb, Recover |
| 2 | **Cetoddle** (`CETODDLE`) | 20 | — | Snow Cloak *(slot 2, class default)* | Avalanche, Take Down, Ice Shard, Rest |

### Irene — Route 34 (`IRENE`)

**2 Pokémon, Lv. 18–20**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2313](data/trainers/parties.asm#L2313) · Map: [Route34.asm:L416](maps/Route34.asm#L416)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slugma** (`SLUGMA`) | 18 | — | Flame Body *(slot 2, class default)* | Ancientpower, Ember, Rock Tomb, Will-O-Wisp |
| 2 | **Magby** (`MAGBY`) | 20 | — | Flash Fire *(slot 2, class default)* | Fire Punch, Flame Wheel, Faint Attack, Will-O-Wisp |

### Kelly — Route 45 (`KELLY`)

**4 Pokémon, Lv. 42–43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2323](data/trainers/parties.asm#L2323) · Map: [Route45.asm:L256](maps/Route45.asm#L256)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fletchindr** (`FLETCHINDER`) | 42 | — | Flame Body *(slot 2, class default)* | Aerial Ace, Acrobatics, Flame Charge, Agility |
| 2 | **Rhydon** (`RHYDON`) | 42 | — | Reckless *(slot 2, class default)* | Double-Edge, Rock Slide, Bulldoze, Stealth Rock |
| 3 | **Farfetch'd** (`FARFETCH_D`) | 42 | — | Keen Eye *(slot 2, class default)* | Leaf Blade, Aerial Ace, Poison Jab, Swords Dance |
| 4 | **Togetic** (`TOGETIC`) | 43 | — | Serene Grace *(slot 2, class default)* | Moonblast, Drain Kiss, Extrasensory, Nasty Plot |

### Joyce — Route 26 (`JOYCE`)

**5 Pokémon, Lv. 47–49**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2339](data/trainers/parties.asm#L2339) · Map: [Route26.asm:L121](maps/Route26.asm#L121)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Drifblim** (`DRIFBLIM`) | 47 | — | Unburden *(slot 2, class default)* | Shadow Ball, Air Slash, Hex, Amnesia |
| 2 | **Tauros** (`TAUROS`) | 48 | — | Anger Point *(slot 2, class default)* | Double-Edge, Raging Bull, Iron Head, Rest |
| 3 | **Gorotora** (`GOROTORA`) | 48 | — | Intimidate *(slot 2, class default)* | Thunder Fang, Spark, Hyper Voice, Thunder Wave |
| 4 | **Machamp** (`MACHAMP`) | 48 | — | No Guard *(slot 2, class default)* | Hammer Arm, Body Press, Strength, Bulk Up |
| 5 | **Crobat** (`CROBAT`) | 49 | — | Frisk *(slot 2, class default)* | Cross Poison, Wing Attack, Crunch, Toxic |


### BETH1 — Route 26

**5 Pokémon, Lv. 47**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2358](data/trainers/parties.asm#L2358) · Map: [Route26.asm:L132](maps/Route26.asm#L132)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon2** (`PORYGON2`) | 47 | — | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Psychic, Recover |
| 2 | **Victreebel** (`VICTREEBEL`) | 47 | — | Poison Puppeteer *(slot 2, class default)* | Leaf Blade, Poison Jab, Razor Leaf, Sleep Powder |
| 3 | **Vaporeon** (`VAPOREON`) | 47 | — | Hydration *(slot 2, class default)* | Hydro Pump, Scald, Ice Beam, Acid Armor |
| 4 | **Feraligatr** (`FERALIGATR`) | 47 | — | Torrent *(slot 2, class default)* | Aqua Tail, Crunch, Night Slash, Agility |
| 5 | **Hydrapple** (`HYDRAPPLE`) | 47 | — | Sheer Force *(slot 2, class default)* | Energy Ball, Dragon Pulse, Apple Acid, Recover |

### BETH2 — Route 26

**5 Pokémon, Lv. 56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2412](data/trainers/parties.asm#L2412) · Map: [Route26.asm:L182](maps/Route26.asm#L182)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raitora** (`RAITORA`) | 56 | — | Intimidate *(slot 2, class default)* | Thunder Fang, Spark, Hyper Voice, Thunder Wave |
| 2 | **Venusaur** (`VENUSAUR`) | 56 | — | Overgrow *(slot 2, class default)* | Sludge Bomb, Petal Dance, Power Whip, Sleep Powder |
| 3 | **Ursaluna** (`URSALUNA`) | 56 | — | Bulletproof *(slot 2, class default)* | Earthquake, Thrash, Crush Claw, Rest |
| 4 | **Muk** (`MUK_ALOLAN`) | 56 | — | Gluttony *(slot 2, class default)* | Gunk Shot, Crunch, Poison Jab, Toxic |
| 5 | **Shuckle** (`SHUCKLE`) | 56 | — | Gluttony *(slot 2, class default)* | Rock Slide, Bug Bite, Rock Tomb, Stealth Rock |

### BETH3 — Route 26

**5 Pokémon, Lv. 63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2487](data/trainers/parties.asm#L2487) · Map: [Route26.asm:L190](maps/Route26.asm#L190)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Donphan** (`DONPHAN`) | 63 | — | Sturdy *(slot 2, class default)* | Earthquake, Giga Impact, Superpower, Charm |
| 2 | **Scyther** (`SCYTHER`) | 63 | — | Swarm *(slot 2, class default)* | X-Scissor, Bug Bite, Wing Attack, Swords Dance |
| 3 | **Mimikyu** (`MIMIKYU`) | 63 | — | Disguise *(slot 2, class default)* | Shadow Claw, Foul Play, Phantomforce, Hone Claws |
| 4 | **Hitmontop** (`HITMONTOP`) | 63 | — | Intimidate *(slot 2, class default)* | Close Combat, Body Press, Sucker Punch, Agility |
| 5 | **Piloswine** (`PILOSWINE`) | 63 | — | Oblivious *(slot 2, class default)* | Earthquake, Icicle Crash, Ice Fang, Amnesia |


### REENA1 — Route 27

**5 Pokémon, Lv. 46–48**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2377](data/trainers/parties.asm#L2377) · Map: [Route27.asm:L196](maps/Route27.asm#L196)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pupitar** (`PUPITAR`) | 46 | — | Shed Skin *(slot 2, class default)* | Earthquake, Rock Slide, Outrage, Dragon Dance |
| 2 | **Miltank** (`MILTANK`) | 46 | — | Scrappy *(slot 2, class default)* | Body Slam, Headbutt, Zen Headbutt, Milk Drink |
| 3 | **Gligar** (`GLIGAR`) | 47 | — | Hyper Cutter *(slot 2, class default)* | Earthquake, Drill Run, Wing Attack, Swords Dance |
| 4 | **Togetic** (`TOGETIC`) | 47 | — | Serene Grace *(slot 2, class default)* | Moonblast, Drain Kiss, Extrasensory, Nasty Plot |
| 5 | **Furret** (`FURRET`) | 48 | — | Fur Coat *(slot 2, class default)* | Extremespeed, Slam, Play Rough, Rest |

### REENA2 — Route 27

**5 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2506](data/trainers/parties.asm#L2506) · Map: [Route27.asm:L246](maps/Route27.asm#L246)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Piloswine** (`PILOSWINE`) | 54 | — | Oblivious *(slot 2, class default)* | Earthquake, Icicle Crash, Ice Fang, Thrash |
| 2 | **Dugtrio** (`DUGTRIO`) | 54 | — | Arena Trap *(slot 2, class default)* | Earthquake, Drill Run, Night Slash, Sandstorm |
| 3 | **Lanturn** (`LANTURN`) | 55 | — | Water Absorb *(slot 2, class default)* | Thunderbolt, Bubblebeam, Signal Beam, Thunder Wave |
| 4 | **Honchkrow** (`HONCHKROW`) | 55 | — | Insomnia *(slot 2, class default)* | Foul Play, Night Slash, Wing Attack, Nasty Plot |
| 5 | **Crobat** (`CROBAT`) | 56 | — | Frisk *(slot 2, class default)* | Cross Poison, Wing Attack, Crunch, Toxic |

### REENA3 — Route 27

**5 Pokémon, Lv. 59–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2525](data/trainers/parties.asm#L2525) · Map: [Route27.asm:L254](maps/Route27.asm#L254)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Crobat** (`CROBAT`) | 59 | — | Frisk *(slot 2, class default)* | Cross Poison, Wing Attack, Crunch, Nasty Plot |
| 2 | **Slowbro** (`SLOWBRO`) | 60 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Future Sight, Amnesia |
| 3 | **Sandslash** (`SANDSLASH`) | 60 | — | Sand Force *(slot 2, class default)* | Earthquake, Drill Run, Poison Jab, Swords Dance |
| 4 | **Starmie** (`STARMIE`) | 62 | — | Analytic *(slot 2, class default)* | Psychic, Psybeam, Bubblebeam, Recover |
| 5 | **Golem** (`GOLEM`) | 63 | — | Sturdy *(slot 2, class default)* | Head Smash, Earthquake, Stone Edge, Stealth Rock |

### Megan — Route 27 (`MEGAN`)

**4 Pokémon, Lv. 47**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2396](data/trainers/parties.asm#L2396) · Map: [Route27.asm:L289](maps/Route27.asm#L289)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Yanmega** (`YANMEGA`) | 47 | — | Tinted Lens *(slot 2, class default)* | Signal Beam, Air Slash, U-Turn, Detect |
| 2 | **Walrein** (`WALREIN`) | 47 | — | Ice Body *(slot 2, class default)* | Ice Beam, Freeze-Dry, Water Pulse, Belly Drum |
| 3 | **Lickilicky** (`LICKILICKY`) | 47 | — | Oblivious *(slot 2, class default)* | Thrash, Body Slam, Zen Headbutt, Amnesia |
| 4 | **Feraligatr** (`FERALIGATR`) | 47 | — | Torrent *(slot 2, class default)* | Aqua Tail, Crunch, Night Slash, Agility |

### Carol — Fast Ship Cabins / NNW / NNE / NE (`CAROL`)

**3 Pokémon, Lv. 54–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2431](data/trainers/parties.asm#L2431) · Map: [FastShipCabins_NNW_NNE_NE.asm:L27](maps/FastShipCabins_NNW_NNE_NE.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lanturn** (`LANTURN`) | 54 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Thunderbolt, Bubblebeam, Thunder Wave |
| 2 | **Heracross** (`HERACROSS`) | 54 | — | Skill Link *(slot 2, class default)* | Superpower, Close Combat, Megahorn, Swords Dance |
| 3 | **Azumarill** (`AZUMARILL`) | 55 | — | Thick Fat *(slot 2, class default)* | Hydro Pump, Bubblebeam, Play Rough, Belly Drum |

### Quinn — Route 1 (`QUINN`)

**3 Pokémon, Lv. 70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2444](data/trainers/parties.asm#L2444) · Map: [Route1.asm:L23](maps/Route1.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Electivire** (`ELECTIVIRE`) | 70 | — | Sheer Force *(slot 2, class default)* | Close Combat, Wild Charge, Cross Chop, Thunder Wave |
| 2 | **Ledian** (`LEDIAN`) | 70 | — | Iron Fist *(slot 2, class default)* | Close Combat, Double-Edge, U-Turn, Quiver Dance |
| 3 | **Galvantula** (`GALVANTULA`) | 70 | — | Unnerve *(slot 2, class default)* | Bug Buzz, Thunder, Signal Beam, Thunder Wave |

### Emma — Union Cave B2F (`EMMA`)

**1 Pokémon, Lv. 46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2457](data/trainers/parties.asm#L2457) · Map: [UnionCaveB2F.asm:L61](maps/UnionCaveB2F.asm#L61)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pupitar** (`PUPITAR`) | 46 | — | Shed Skin *(slot 2, class default)* | Rock Slide, Thrash, Bulldoze, Screech |

### Cybil — Route 44 (`CYBIL`)

**3 Pokémon, Lv. 40–43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2464](data/trainers/parties.asm#L2464) · Map: [Route44.asm:L270](maps/Route44.asm#L270)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Primeape** (`PRIMEAPE`) | 40 | — | Anger Point *(slot 2, class default)* | Cross Chop, Brick Break, Skull Bash, Work Up |
| 2 | **Corsola** (`CORSOLA`) | 41 | — | Natural Cure *(slot 2, class default)* | Power Gem, Bubblebeam, Earth Power, Recover |
| 3 | **Scizor** (`SCIZOR`) | 43 | — | Swarm *(slot 2, class default)* | Iron Head, X-Scissor, Bug Bite, Work Up |

### Jenn — Route 34 (`JENN`)

**2 Pokémon, Lv. 18–20**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2477](data/trainers/parties.asm#L2477) · Map: [Route34.asm:L435](maps/Route34.asm#L435)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndour** (`HOUNDOUR`) | 18 | — | Flash Fire *(slot 2, class default)* | Fire Fang, Ember, Bite, Faint Attack |
| 2 | **Haunter** (`HAUNTER`) | 20 | — | Cursed Body *(slot 2, class default)* | Shadow Ball, Hex, Sucker Punch, Curse |

### Cara — Dragon's Den B1F (`CARA`)

**3 Pokémon, Lv. 44–46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2544](data/trainers/parties.asm#L2544) · Map: [DragonsDenB1F.asm:L96](maps/DragonsDenB1F.asm#L96)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 44 | — | Rattled *(slot 2, class default)* | Double-Edge, Body Slam, Air Slash, Roost |
| 2 | **Dragonair** (`DRAGONAIR`) | 45 | — | Shed Skin *(slot 2, class default)* | Dragon Pulse, Dragon Tail, Aqua Tail, Dragon Dance |
| 3 | **Dipplin** (`DIPPLIN`) | 46 | — | Gluttony *(slot 2, class default)* | Energy Ball, Dragon Pulse, Dragonbreath, Recover |


## Beauty

> **Group:** `BeautyGroup` · **Battle IDs:** `BEAUTY` · **6 parties**

### Victoria — Goldenrod Gym (`VICTORIA`)

**2 Pokémon, Lv. 17–19**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2560](data/trainers/parties.asm#L2560) · Map: [GoldenrodGym.asm:L145](maps/GoldenrodGym.asm#L145)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoothoot** (`HOOTHOOT`) | 17 | — | Tinted Lens *(slot 1, class default)* | Tackle, Foresight, Hypnosis, Confusion |
| 2 | **Togetic** (`TOGETIC`) | 19 | — | Super Luck *(slot 1, class default)* | Metronome, Sweet Kiss, Encore, Drain Kiss |

### Samantha — Goldenrod Gym (`SAMANTHA`)

**1 Pokémon, Lv. 20**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2568](data/trainers/parties.asm#L2568) · Map: [GoldenrodGym.asm:L156](maps/GoldenrodGym.asm#L156)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Meowth** (`MEOWTH`) | 20 | — | Technician *(slot 1, class default)* | Bite, Pay Day, Fury Swipes, Screech |

### Cassie — Fast Ship Cabins / SW / SSW / NW (`CASSIE`)

**2 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2575](data/trainers/parties.asm#L2575) · Map: [FastShipCabins_SW_SSW_NW.asm:L35](maps/FastShipCabins_SW_SSW_NW.asm#L35)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon2** (`PORYGON2`) | 54 | — | Trace *(slot 1, class default)* | Tri Attack, Ice Beam, Thunderbolt, Recover |
| 2 | **Milotic** (`MILOTIC`) | 56 | — | Marvel Scale *(slot 1, class default)* | Surf, Ice Beam, Recover, Hypnosis |

### Julia — Celadon Gym (`JULIA`)

**3 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2585](data/trainers/parties.asm#L2585) · Map: [CeladonGym.asm:L73](maps/CeladonGym.asm#L73)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Electrode** (`ELECTRODE_HISUIAN`) | 64 | — | Soundproof *(slot 1, class default)* | Thunderbolt, Energy Ball, Signal Beam, Thunder Wave |
| 2 | **Tsareena** (`TSAREENA`) | 64 | — | Queenly Majesty *(slot 1, class default)* | Power Whip, Brick Break, Strength, Iron Tail |
| 3 | **Vileplume** (`VILEPLUME`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Sludge Bomb, Earth Power, Growth |

### Valerie — Route 38 (`VALERIE`)

**2 Pokémon, Lv. 27–28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2598](data/trainers/parties.asm#L2598) · Map: [Route38.asm:L293](maps/Route38.asm#L293)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Togetic** (`TOGETIC`) | 27 | — | Super Luck *(slot 1, class default)* | Safeguard, Ancientpower, Softboiled, Baton Pass |
| 2 | **Ponyta** (`PONYTA_GALARIAN`) | 28 | — | Run Away *(slot 1, class default)* | Drain Kiss, Agility, Psybeam, Take Down |

### Olivia — Route 38 (`OLIVIA`)

**1 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2606](data/trainers/parties.asm#L2606) · Map: [Route38.asm:L304](maps/Route38.asm#L304)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Stantler** (`STANTLER`) | 28 | — | Intimidate *(slot 1, class default)* | Take Down, Calm Mind, Work Up, Zen Headbutt |


## Pokémaniac

> **Group:** `PokemaniacGroup` · **Battle IDs:** `POKEMANIAC` · **15 parties**

### Larry — Union Cave 1F (`LARRY`)

**1 Pokémon, Lv. 13**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2615](data/trainers/parties.asm#L2615) · Map: [UnionCave1F.asm:L18](maps/UnionCave1F.asm#L18)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wooper** (`WOOPER_PALDEAN`) | 13 | — | Water Absorb *(slot 2, class default)* | Toxic Spikes, Tackle, Slam, Poison Jab |

### Andrew — Union Cave B1F (`ANDREW`)

**2 Pokémon, Lv. 14–15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2621](data/trainers/parties.asm#L2621) · Map: [UnionCaveB1F.asm:L16](maps/UnionCaveB1F.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Geodude** (`GEODUDE_ALOLAN`) | 14 | — | Sturdy *(slot 2, class default)* | Spark, Rock Throw, Harden, Thunderpunch |
| 2 | **Phanpy** (`PHANPY`) | 15 | — | Pickup *(slot 2, class default)* | Mud-Slap, Headbutt, Rollout, Bulldoze |

### Calvin — Union Cave B1F (`CALVIN`)

**1 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2629](data/trainers/parties.asm#L2629) · Map: [UnionCaveB1F.asm:L27](maps/UnionCaveB1F.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Geodude** (`GEODUDE_ALOLAN`) | 15 | — | Sturdy *(slot 2, class default)* | Spark, Rock Throw, Harden, Thunderpunch |

### Shane — Route 42 (`SHANE`)

**2 Pokémon, Lv. 33**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2635](data/trainers/parties.asm#L2635) · Map: [Route42.asm:L223](maps/Route42.asm#L223)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 33 | — | Rattled *(slot 2, class default)* | Take Down, Dig, Glare, Double-Edge |
| 2 | **Phanpy** (`PHANPY`) | 33 | — | Pickup *(slot 2, class default)* | Take Down, Endure, Charm, Drill Run |

### Ben — Route 43 (`BEN`)

**2 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2643](data/trainers/parties.asm#L2643) · Map: [Route43.asm:L39](maps/Route43.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ursaring** (`URSARING`) | 37 | — | Quick Feet *(slot 2, class default)* | Crush Claw, Rest, Earthquake, Brick Break |
| 2 | **Girafarig** (`GIRAFARIG`) | 37 | — | Contrary *(slot 2, class default)* | Zen Headbutt, Crunch, Psychic, Psycho Cut |


### BRENT1 — Route 43

**2 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2651](data/trainers/parties.asm#L2651) · Map: [Route43.asm:L50](maps/Route43.asm#L50)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Furret** (`FURRET`) | 37 | — | Fur Coat *(slot 2, class default)* | Extremespeed, Amnesia, Reversal, Sucker Punch |
| 2 | **Munchlax** (`MUNCHLAX`) | 37 | — | Pickup *(slot 2, class default)* | Screech, Body Slam, Rollout, Zen Headbutt |

### BRENT2 — Route 43

**1 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2677](data/trainers/parties.asm#L2677) · Map: [Route43.asm:L104](maps/Route43.asm#L104)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Aipom** (`AIPOM`) | 38 | — | Pickup *(slot 2, class default)* | Swift, Screech, Bounce, Agility |

### BRENT3 — Route 43

**2 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2683](data/trainers/parties.asm#L2683) · Map: [Route43.asm:L112](maps/Route43.asm#L112)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ambipom** (`AMBIPOM`) | 54 | — | Pickup *(slot 2, class default)* | Scratch, Swift, Bounce, Agility |
| 2 | **Dunsparce** (`DUNSPARCE`) | 56 | — | Rattled *(slot 2, class default)* | Double-Edge, Body Slam, Air Slash, Roost |

### BRENT4 — Route 43

**2 Pokémon, Lv. 60–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2718](data/trainers/parties.asm#L2718) · Map: [Route43.asm:L120](maps/Route43.asm#L120)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Blissey** (`BLISSEY`) | 60 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Double-Edge, Disarm Voice, Softboiled |
| 2 | **Tauros** (`TAUROS`) | 63 | — | Anger Point *(slot 2, class default)* | Double-Edge, Raging Bull, Superpower, Rest |

### Ron — Route 43 (`RON`)

**2 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2659](data/trainers/parties.asm#L2659) · Map: [Route43.asm:L155](maps/Route43.asm#L155)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raitora** (`RAITORA`) | 37 | — | Intimidate *(slot 2, class default)* | Spark, Hyper Voice, Agility, Thunder Fang |
| 2 | **Ursaring** (`URSARING`) | 37 | — | Quick Feet *(slot 2, class default)* | Crush Claw, Rest, Earthquake, Brick Break |

### Ethan — Fast Ship Cabins / NNW / NNE / NE (`ETHAN`)

**2 Pokémon, Lv. 55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2667](data/trainers/parties.asm#L2667) · Map: [FastShipCabins_NNW_NNE_NE.asm:L38](maps/FastShipCabins_NNW_NNE_NE.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE`) | 55 | — | Guts *(slot 2, class default)* | Strength, Crunch, Iron Tail, Quick Attack |
| 2 | **Farigiraf** (`FARIGIRAF`) | 55 | — | Cud Chew *(slot 2, class default)* | Psychic, Stomp, Crunch, Psybeam |

### Issac — Goldenrod Underground (`ISSAC`)

**1 Pokémon, Lv. 19**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2693](data/trainers/parties.asm#L2693) · Map: [GoldenrodUnderground.asm:L141](maps/GoldenrodUnderground.asm#L141)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sentret** (`SENTRET`) | 19 | — | Keen Eye *(slot 2, class default)* | Slam, Quick Attack, Scratch, Fury Swipes |

### Donald — Goldenrod Underground (`DONALD`)

**2 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2700](data/trainers/parties.asm#L2700) · Map: [GoldenrodUnderground.asm:L152](maps/GoldenrodUnderground.asm#L152)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golett** (`GOLETT`) | 20 | — | Klutz *(slot 2, class default)* | Curse, Mud Shot, Night Shade, Rock Tomb |
| 2 | **Aipom** (`AIPOM`) | 20 | — | Pickup *(slot 2, class default)* | Sand-Attack, Astonish, Baton Pass, Fury Swipes |

### Zach — Route 44 (`ZACH`)

**3 Pokémon, Lv. 40–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2708](data/trainers/parties.asm#L2708) · Map: [Route44.asm:L281](maps/Route44.asm#L281)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gallade** (`GALLADE`) | 40 | — | Sharpness *(slot 2, class default)* | Brick Break, Psycho Cut, Close Combat, Circle Throw |
| 2 | **Graveler** (`GRAVELER`) | 41 | — | Sturdy *(slot 2, class default)* | Rock Polish, Earthquake, Stealth Rock, Rock Blast |
| 3 | **Grumpig** (`GRUMPIG`) | 43 | — | Own Tempo *(slot 2, class default)* | Rest, Snore, Sleep Talk, Psychic |

### Miller — Mount Mortar 1F Interior (`MILLER`)

**2 Pokémon, Lv. 30**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2728](data/trainers/parties.asm#L2728) · Map: [MountMortar1FInside.asm:L19](maps/MountMortar1FInside.asm#L19)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Geodude** (`GEODUDE`) | 30 | — | Sturdy *(slot 2, class default)* | Selfdestruct, Rock Slide, Rock Polish, Stealth Rock |
| 2 | **Swinub** (`SWINUB`) | 30 | — | Oblivious *(slot 2, class default)* | Mud Shot, Endure, Avalanche, Take Down |


## Team Rocket Grunt M

> **Group:** `GruntMGroup` · **Battle IDs:** `GRUNTM` · **16 parties**


### GRUNTM_2 — Slowpoke Well B1F

**3 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2739](data/trainers/parties.asm#L2739) · Map: [SlowpokeWellB1F.asm:L75](maps/SlowpokeWellB1F.asm#L75)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gastly** (`GASTLY`) | 15 | — | Cursed Body *(slot 2, class default)* | Hypnosis, Night Shade, Smog, Confuse Ray |
| 2 | **Grimer** (`GRIMER_ALOLAN`) | 15 | — | Gluttony *(slot 2, class default)* | Curse, Harden, Bite, Disable |
| 3 | **Croagunk** (`CROAGUNK`) | 15 | — | Dry Skin *(slot 2, class default)* | Astonish, Mud-Slap, Poison Sting |

### GRUNTM_4 — Radio Tower 2F

**2 Pokémon, Lv. 39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2749](data/trainers/parties.asm#L2749) · Map: [RadioTower2F.asm:L57](maps/RadioTower2F.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gloom** (`GLOOM`) | 39 | — | Poison Puppeteer *(slot 2, class default)* | Giga Drain, Toxic, Moonblast, Sludge Bomb |
| 2 | **Seviper** (`SEVIPER`) | 39 | — | Intimidate *(slot 2, class default)* | Poison Jab, Snarl, Crunch, Sludge Bomb |

### GRUNTM_6 — Radio Tower 2F

**2 Pokémon, Lv. 40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2757](data/trainers/parties.asm#L2757) · Map: [RadioTower2F.asm:L79](maps/RadioTower2F.asm#L79)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fearow** (`FEAROW`) | 40 | — | Sniper *(slot 2, class default)* | Drill Peck, Agility, Dualwingbeat, Focus Energy |
| 2 | **Weepinbell** (`WEEPINBELL`) | 40 | — | Poison Puppeteer *(slot 2, class default)* | Poison Jab, Seed Bomb, Knock Off, Slam |

### GRUNTM_7 — Radio Tower 3F

**3 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2765](data/trainers/parties.asm#L2765) · Map: [RadioTower3F.asm:L84](maps/RadioTower3F.asm#L84)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sneasel** (`SNEASEL`) | 38 | — | Inner Focus *(slot 2, class default)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |
| 2 | **Girafarig** (`GIRAFARIG`) | 38 | — | Contrary *(slot 2, class default)* | Zen Headbutt, Crunch, Psychic, Psycho Cut |
| 3 | **Ursaring** (`URSARING`) | 38 | — | Quick Feet *(slot 2, class default)* | Crush Claw, Rest, Earthquake, Brick Break |

### GRUNTM_10 — Radio Tower 4F

**3 Pokémon, Lv. 39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2775](data/trainers/parties.asm#L2775) · Map: [RadioTower4F.asm:L57](maps/RadioTower4F.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ursaring** (`URSARING`) | 39 | — | Quick Feet *(slot 2, class default)* | Rest, Earthquake, Brick Break, Crunch |
| 2 | **Slowbro** (`SLOWBRO_GALARIAN`) | 39 | — | Unaware *(slot 2, class default)* | Surf, Amnesia, Psychic, Sludge Bomb |
| 3 | **Raticate** (`RATICATE_ALOLAN`) | 39 | — | Guts *(slot 2, class default)* | Sucker Punch, Flame Wheel, Double-Edge, Reversal |

### GRUNTM_13 — Goldenrod Underground Switch Room Entrances

**2 Pokémon, Lv. 39–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2785](data/trainers/parties.asm#L2785) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L256](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L256)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Overqwil** (`OVERQWIL`) | 39 | — | Swift Swim *(slot 2, class default)* | Night Slash, Poison Jab, Snarl, Aqua Tail |
| 2 | **Pidgeot** (`PIDGEOT`) | 40 | — | Tangled Feet *(slot 2, class default)* | Dualwingbeat, Roost, Defog, Whirlwind |

### GRUNTM_14 — Goldenrod Underground Warehouse

**3 Pokémon, Lv. 38–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2793](data/trainers/parties.asm#L2793) · Map: [GoldenrodUndergroundWarehouse.asm:L48](maps/GoldenrodUndergroundWarehouse.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ariados** (`ARIADOS`) | 38 | — | Sniper *(slot 2, class default)* | Poison Jab, Signal Beam, Sucker Punch, Cross Poison |
| 2 | **Camerupt** (`CAMERUPT`) | 38 | — | Drought *(slot 2, class default)* | Curse, Take Down, Rock Slide, Flamethrower |
| 3 | **Steelix** (`STEELIX`) | 40 | — | Sturdy *(slot 2, class default)* | Iron Defense, Stealth Rock, Stone Edge, Double-Edge |

### GRUNTM_15 — Goldenrod Underground Warehouse

**5 Pokémon, Lv. 39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2803](data/trainers/parties.asm#L2803) · Map: [GoldenrodUndergroundWarehouse.asm:L59](maps/GoldenrodUndergroundWarehouse.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Piloswine** (`PILOSWINE`) | 39 | — | Oblivious *(slot 2, class default)* | Fury Attack, Earthquake, Freeze-Dry, Thrash |
| 2 | **Qwilfish** (`QWILFISH`) | 39 | — | Swift Swim *(slot 2, class default)* | Aqua Tail, Pin Missile, Cross Poison, Take Down |
| 3 | **Sneasel** (`SNEASEL`) | 39 | — | Inner Focus *(slot 2, class default)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |
| 4 | **Steelix** (`STEELIX`) | 39 | — | Sturdy *(slot 2, class default)* | Crunch, Iron Defense, Stealth Rock, Stone Edge |
| 5 | **Gligar** (`GLIGAR`) | 39 | — | Hyper Cutter *(slot 2, class default)* | Screech, X-Scissor, Drill Run, Earthquake |

### GRUNTM_18 — Team Rocket Base B2F

**3 Pokémon, Lv. 34–35**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2817](data/trainers/parties.asm#L2817) · Map: [TeamRocketBaseB2F.asm:L201](maps/TeamRocketBaseB2F.asm#L201)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Persian** (`PERSIAN_ALOLAN`) | 34 | — | Technician *(slot 2, class default)* | Power Gem, Crush Claw, Snarl, Hypnosis |
| 2 | **Houndour** (`HOUNDOUR`) | 34 | — | Flash Fire *(slot 2, class default)* | Snarl, Flamethrower, Sucker Punch, Dark Pulse |
| 3 | **Dusclops** (`DUSCLOPS`) | 35 | — | Prankster *(slot 2, class default)* | Shadow Ball, Shadow Punch, Hex, Confuse Ray |

### GRUNTM_20 — Team Rocket Base B1F

**2 Pokémon, Lv. 34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2827](data/trainers/parties.asm#L2827) · Map: [TeamRocketBaseB1F.asm:L239](maps/TeamRocketBaseB1F.asm#L239)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Oddish** (`ODDISH`) | 34 | — | Chlorophyll *(slot 2, class default)* | Giga Drain, Toxic, Moonblast, Sludge Bomb |
| 2 | **Seviper** (`SEVIPER`) | 34 | — | Intimidate *(slot 2, class default)* | Night Slash, Poison Jab, Snarl, Crunch |

### GRUNTM_21 — Team Rocket Base B1F

**3 Pokémon, Lv. 34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2835](data/trainers/parties.asm#L2835) · Map: [TeamRocketBaseB1F.asm:L252](maps/TeamRocketBaseB1F.asm#L252)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Drifloon** (`DRIFLOON`) | 34 | — | Unburden *(slot 2, class default)* | Defog, Air Slash, Destiny Bond, Hypnosis |
| 2 | **Sneasel** (`SNEASEL`) | 34 | — | Inner Focus *(slot 2, class default)* | Snarl, Slash, Screech, Freeze-Dry |
| 3 | **Glimmet** (`GLIMMET`) | 34 | — | Corrosion *(slot 2, class default)* | Rock Polish, Selfdestruct, Stealth Rock, Rock Slide |

### GRUNTM_25 — Goldenrod Underground Switch Room Entrances

**2 Pokémon, Lv. 39–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2845](data/trainers/parties.asm#L2845) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L223](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L223)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxicroak** (`TOXICROAK`) | 39 | — | Dry Skin *(slot 2, class default)* | Brick Break, Nasty Plot, Toxic, Sucker Punch |
| 2 | **Arbok** (`ARBOK`) | 40 | — | Shed Skin *(slot 2, class default)* | Leech Life, Sludge Bomb, Haze, Dragon Tail |

### GRUNTM_28 — Team Rocket Base B3F

**4 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2853](data/trainers/parties.asm#L2853) · Map: [TeamRocketBaseB3F.asm:L145](maps/TeamRocketBaseB3F.asm#L145)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Marowak** (`MAROWAK_ALOLAN`) | 36 | — | Lightning Rod *(slot 2, class default)* | Knock Off, Swords Dance, Bone Rush, Thrash |
| 2 | **Houndour** (`HOUNDOUR`) | 36 | — | Flash Fire *(slot 2, class default)* | Snarl, Flamethrower, Sucker Punch, Dark Pulse |
| 3 | **Scraggy** (`SCRAGGY`) | 36 | — | Moxie *(slot 2, class default)* | Scary Face, Brick Break, Snarl, Swagger |
| 4 | **Murkrow** (`MURKROW`) | 36 | — | Insomnia *(slot 2, class default)* | Snarl, Faint Attack, Dark Pulse, Foul Play |

### GRUNTM_31 — Route 24

**5 Pokémon, Lv. 59**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2865](data/trainers/parties.asm#L2865) · Map: [Route24.asm:L17](maps/Route24.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndoom** (`HOUNDOOM`) | 59 | — | Flash Fire *(slot 2, class default)* | Nasty Plot, Raging Fury, Heat Wave, Overheat |
| 2 | **Slowking** (`SLOWKING_GALARIAN`) | 59 | — | Unaware *(slot 2, class default)* | Future Sight, Eerie Spell, Trick Room, Slack Off |
| 3 | **Weavile** (`WEAVILE`) | 59 | — | Pressure *(slot 2, class default)* | Icicle Crash, Freeze-Dry, Foul Play, Dark Pulse |
| 4 | **Steelix** (`STEELIX`) | 59 | — | Sturdy *(slot 2, class default)* | Dragon Tail, Drill Run, Sandstorm, Body Press |
| 5 | **Muk** (`MUK`) | 59 | — | Sticky Hold *(slot 2, class default)* | Sludge Bomb, Acid Armor, Cross Poison, Gunk Shot |

### GRUNTM_GOLDENROD_RIOLU — Goldenrod Underground

**2 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2879](data/trainers/parties.asm#L2879) · Map: [GoldenrodUnderground.asm:L472](maps/GoldenrodUnderground.asm#L472)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mankey** (`MANKEY`) | 20 | — | Anger Point *(slot 2, class default)* | Karate Chop, Seismic Toss, Low Sweep, Swagger |
| 2 | **Koffing** (`KOFFING`) | 20 | — | Neutralizing Gas *(slot 2, class default)* | Smokescreen, Pain Split, Sludge, Selfdestruct |

### GRUNTM_GOLDENROD_RIOLU_LEADER — Goldenrod Underground

**3 Pokémon, Lv. 21–22**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2887](data/trainers/parties.asm#L2887) · Map: [GoldenrodUnderground.asm:L507](maps/GoldenrodUnderground.asm#L507)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndour** (`HOUNDOUR`) | 21 | — | Flash Fire *(slot 2, class default)* | Roar, Smog, Thunder Fang, Fire Fang |
| 2 | **Murkrow** (`MURKROW`) | 21 | — | Insomnia *(slot 2, class default)* | Gust, Haze, Wing Attack, Night Shade |
| 3 | **Scraggy** (`SCRAGGY`) | 22 | — | Moxie *(slot 2, class default)* | Sand-Attack, Facade, Low Sweep, Protect |


## Gentleman

> **Group:** `GentlemanGroup` · **Battle IDs:** `GENTLEMAN` · **4 parties**

### Preston — Olivine Lighthouse 3F (`PRESTON`)

**2 Pokémon, Lv. 31**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2900](data/trainers/parties.asm#L2900) · Map: [OlivineLighthouse3F.asm:L24](maps/OlivineLighthouse3F.asm#L24)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Growlithe** (`GROWLITHE`) | 31 | — | Flash Fire *(slot 2, class default)* | Flame Wheel, Agility, Flamethrower, Crunch |
| 2 | **Persian** (`PERSIAN`) | 31 | — | Limber *(slot 2, class default)* | Faint Attack, Night Slash, Slash, Power Gem |

### Edward — Fast Ship Cabins / NNW / NNE / NE (`EDWARD`)

**2 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2908](data/trainers/parties.asm#L2908) · Map: [FastShipCabins_NNW_NNE_NE.asm:L60](maps/FastShipCabins_NNW_NNE_NE.asm#L60)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Miltank** (`MILTANK`) | 54 | — | Scrappy *(slot 2, class default)* | Body Slam, Earthquake, Fire Punch, Milk Drink |
| 2 | **Blissey** (`BLISSEY`) | 56 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Fire Blast, Softboiled |

### Gregory — Vermilion Gym (`GREGORY`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2918](data/trainers/parties.asm#L2918) · Map: [VermilionGym.asm:L46](maps/VermilionGym.asm#L46)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raichu** (`RAICHU`) | 58 | — | Lightning Rod *(slot 2, class default)* | Thunderpunch, Spark, Iron Tail, Nasty Plot |
| 2 | **Electabuzz** (`ELECTABUZZ`) | 58 | — | Vital Spirit *(slot 2, class default)* | Thunderbolt, Thunder, Close Combat, Thunder Wave |

### Alfred — Olivine Lighthouse 2F (`ALFRED`)

**1 Pokémon, Lv. 34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2928](data/trainers/parties.asm#L2928) · Map: [OlivineLighthouse2F.asm:L11](maps/OlivineLighthouse2F.asm#L11)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ponyta** (`PONYTA_GALARIAN`) | 34 | — | Pastel Veil *(slot 2, class default)* | Agility, Psybeam, Take Down, Dazzle Gleam |


## Skier

> **Group:** `SkierGroup` · **Battle IDs:** `SKIER` · **4 parties**

### Roxanne — Mahogany Gym (`ROXANNE`)

**1 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2937](data/trainers/parties.asm#L2937) · Map: [MahoganyGym.asm:L88](maps/MahoganyGym.asm#L88)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Smoochum** (`SMOOCHUM`) | 38 | — | Forewarn *(slot 2, class default)* | Ice Punch, Ice Beam, Freeze-Dry, Psychic |

### Clarissa — Mahogany Gym (`CLARISSA`)

**1 Pokémon, Lv. 39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2943](data/trainers/parties.asm#L2943) · Map: [MahoganyGym.asm:L99](maps/MahoganyGym.asm#L99)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sneasel** (`SNEASEL`) | 39 | — | Inner Focus *(slot 2, class default)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |

### Bianca — Shiver Isle (`SKIER_BIANCA`)

**3 Pokémon, Lv. 44–46**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2949](data/trainers/parties.asm#L2949) · Map: [ShiverIsle.asm:L38](maps/ShiverIsle.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Snorunt** (`SNORUNT`) | 44 | — | Ice Body *(slot 2, class default)* | Crunch, Ice Beam, Protect, Hail |
| 2 | **Snover** (`SNOVER`) | 45 | — | Soundproof *(slot 2, class default)* | Mist, Icicle Crash, Blizzard, Wood Hammer |
| 3 | **Sneasel** (`SNEASEL`) | 46 | — | Inner Focus *(slot 2, class default)* | Hone Claws, Crunch, Foul Play, Dark Pulse |

### Heidi — Route 44 (`SKIER_HEIDI`)

**3 Pokémon, Lv. 40–42**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L2959](data/trainers/parties.asm#L2959) · Map: [Route44.asm:L314](maps/Route44.asm#L314)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vulpix** (`VULPIX_ALOLAN`) | 40 | — | Snow Cloak *(slot 2, class default)* | Dark Pulse, Hypnosis, Freeze-Dry, Mist |
| 2 | **Snover** (`SNOVER`) | 41 | — | Soundproof *(slot 2, class default)* | Seed Bomb, Freeze-Dry, Mist, Icicle Crash |
| 3 | **Piloswine** (`PILOSWINE`) | 42 | — | Oblivious *(slot 2, class default)* | Fury Attack, Earthquake, Freeze-Dry, Thrash |


## Teacher

> **Group:** `TeacherGroup` · **Battle IDs:** `TEACHER` · **3 parties**

### Colette — Route 15 (`COLETTE`)

**2 Pokémon, Lv. 65–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2972](data/trainers/parties.asm#L2972) · Map: [Route15.asm:L16](maps/Route15.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Bellossom** (`BELLOSSOM`) | 65 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Moonblast, Earth Power, Moonlight |
| 2 | **Wigglytuff** (`WIGGLYTUFF`) | 66 | — | Magic Guard *(slot 1, class default)* | Hyper Voice, Play Rough, Fire Blast, Ice Beam |

### Hillary — Route 15 (`HILLARY`)

**2 Pokémon, Lv. 67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2982](data/trainers/parties.asm#L2982) · Map: [Route15.asm:L27](maps/Route15.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wyrdeer** (`WYRDEER`) | 67 | — | Intimidate *(slot 1, class default)* | Zen Headbutt, Stomp, Megahorn, Bulldoze |
| 2 | **Banette** (`BANETTE`) | 67 | — | Frisk *(slot 1, class default)* | Phantomforce, Strength, Fire Punch, Shadow Sneak |

### Shirley — Fast Ship B1F (`SHIRLEY`)

**2 Pokémon, Lv. 53–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L2992](data/trainers/parties.asm#L2992) · Map: [FastShipB1F.asm:L172](maps/FastShipB1F.asm#L172)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Blissey** (`BLISSEY`) | 53 | — | Serene Grace *(slot 1, class default)* | Hyper Voice, Ice Beam, Fire Blast, Softboiled |
| 2 | **Banette** (`BANETTE`) | 55 | — | Frisk *(slot 1, class default)* | Phantomforce, Strength, Ice Punch, Sucker Punch |


## Sabrina

> **Group:** `SabrinaGroup` · **Battle IDs:** `SABRINA` · **1 parties**

### Sabrina — Saffron Gym (`SABRINA1`)

**6 Pokémon, Lv. 64–67**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3005](data/trainers/parties.asm#L3005) · Map: [SaffronGym.asm:L23](maps/SaffronGym.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mesmeria** (`MESMERIA`) | 64 | Leftovers | Bad Dreams *(hidden)* | Hypnosis, Psychic, Ice Beam, Dream Eater |
| 2 | **Gardevoir** (`GARDEVOIR`) | 65 | Life Orb | Pixilate *(hidden)* | Hyper Voice, Psychic, Shadow Ball, Calm Mind |
| 3 | **Farigiraf** (`FARIGIRAF`) | 65 | Leftovers | Armor Tail *(slot 1)* | Psychic, Crunch, Hyper Voice, Calm Mind |
| 4 | **Hypno** (`HYPNO`) | 66 | Leftovers | No Guard *(slot 2)* | Hypnosis, Dream Eater, Psychic, Shadow Ball |
| 5 | **Wobbuffet** (`WOBBUFFET`) | 66 | Leftovers | Shadow Tag *(slot 1)* | Counter, Mirror Coat, Safeguard, Destiny Bond |
| 6 | **Alakazam** (`ALAKAZAM`) | 67 | Life Orb | Magic Guard *(slot 1)* | Psychic, Shadow Ball, Focus Blast, Recover |


## Bug Catcher

> **Group:** `BugCatcherGroup` · **Battle IDs:** `BUG_CATCHER` · **19 parties**

### Don — Route 30 (`DON`)

**2 Pokémon, Lv. 5**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3042](data/trainers/parties.asm#L3042) · Map: [Route30.asm:L199](maps/Route30.asm#L199)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pineco** (`PINECO`) | 5 | — | Aftermath *(slot 2, class default)* | Tackle, Protect |
| 2 | **Trapinch** (`TRAPINCH`) | 5 | — | Arena Trap *(slot 2, class default)* | Sand-Attack, Bite, Bug Bite, Faint Attack |

### Rob — Route 2 (`ROB`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3050](data/trainers/parties.asm#L3050) · Map: [ViridianForest.asm:L17](maps/ViridianForest.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Galvantula** (`GALVANTULA`) | 69 | — | Unnerve *(slot 2, class default)* | Thunderbolt, Bug Buzz, Thunder Wave, Giga Drain |
| 2 | **Yanmega** (`YANMEGA`) | 69 | — | Tinted Lens *(slot 2, class default)* | Bug Buzz, Air Slash, Quick Attack, Ancientpower |

### Ed — Route 2 (`ED`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3060](data/trainers/parties.asm#L3060) · Map: [ViridianForest.asm:L28](maps/ViridianForest.asm#L28)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Parasect** (`PARASECT`) | 68 | — | Damp *(slot 2, class default)* | X-Scissor, Seed Bomb, Slash, Sludge Bomb |
| 2 | **Pinsir** (`PINSIR`) | 68 | — | Mold Breaker *(slot 2, class default)* | Megahorn, Close Combat, Strength, Quick Attack |
| 3 | **Yanmega** (`YANMEGA`) | 68 | — | Tinted Lens *(slot 2, class default)* | Bug Buzz, Air Slash, Quick Attack, Ancientpower |


### WADE1 — Route 31

**2 Pokémon, Lv. 6–7**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3073](data/trainers/parties.asm#L3073) · Map: [Route31.asm:L26](maps/Route31.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Venipede** (`VENIPEDE`) | 6 | — | Swarm *(slot 2, class default)* | Defense Curl, Poison Sting, Rollout |
| 2 | **Pineco** (`PINECO`) | 7 | — | Aftermath *(slot 2, class default)* | Tackle, Protect, Bug Bite |

### WADE2 — Route 31

**2 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3121](data/trainers/parties.asm#L3121) · Map: [Route31.asm:L86](maps/Route31.asm#L86)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sizzlipede** (`SIZZLIPEDE`) | 24 | — | White Smoke *(slot 2, class default)* | Bite, Flame Wheel, Bug Bite, Fire Fang |
| 2 | **Yanma** (`YANMA`) | 24 | — | Compound Eyes *(slot 2, class default)* | Wing Attack, Aerial Ace, Detect, Supersonic |

### WADE3 — Route 31

**3 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3129](data/trainers/parties.asm#L3129) · Map: [Route31.asm:L94](maps/Route31.asm#L94)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Venonat** (`VENONAT`) | 37 | — | Compound Eyes *(slot 2, class default)* | Bug Buzz, Zen Headbutt, Baton Pass, Psychic |
| 2 | **Yanma** (`YANMA`) | 37 | — | Compound Eyes *(slot 2, class default)* | Dualwingbeat, Ancientpower, Hypnosis, Signal Beam |
| 3 | **Whirlipede** (`WHIRLIPEDE`) | 37 | — | Swarm *(slot 2, class default)* | Venoshock, Take Down, Agility, Cross Poison |

### WADE4 — Route 31

**4 Pokémon, Lv. 41–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3167](data/trainers/parties.asm#L3167) · Map: [Route31.asm:L102](maps/Route31.asm#L102)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Forretress** (`FORRETRESS`) | 41 | — | Sturdy *(slot 2, class default)* | Toxic Spikes, Gyro Ball, Iron Defense, Stealth Rock |
| 2 | **Vibrava** (`VIBRAVA`) | 42 | — | Overcoat *(slot 2, class default)* | Dragonbreath, Earth Power, Sandstorm, Earthquake |
| 3 | **Ledian** (`LEDIAN`) | 42 | — | Iron Fist *(slot 2, class default)* | Agility, Signal Beam, Air Slash, Quiver Dance |
| 4 | **Shuckle** (`SHUCKLE`) | 43 | — | Gluttony *(slot 2, class default)* | Knock Off, Sweet Scent, Body Press, Earth Power |

### WADE5 — Route 31

**5 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3179](data/trainers/parties.asm#L3179) · Map: [Route31.asm:L110](maps/Route31.asm#L110)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Beedrill** (`BEEDRILL`) | 54 | — | Sniper *(slot 2, class default)* | Drill Run, Cross Poison, Outrage, Megahorn |
| 2 | **Forretress** (`FORRETRESS`) | 54 | — | Sturdy *(slot 2, class default)* | Stealth Rock, Explosion, Body Press, Double-Edge |
| 3 | **Heracross** (`HERACROSS`) | 55 | — | Skill Link *(slot 2, class default)* | Counter, Superpower, Swords Dance, Reversal |
| 4 | **Centiskorc** (`CENTISKORCH`) | 55 | — | White Smoke *(slot 2, class default)* | Crunch, Raging Fury, Heat Wave, Power Whip |
| 5 | **Galvantula** (`GALVANTULA`) | 56 | — | Unnerve *(slot 2, class default)* | Signal Beam, Volt Switch, Bug Buzz, Wild Charge |

### Benny — Azalea Gym (`BUG_CATCHER_BENNY`)

**2 Pokémon, Lv. 12–15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3081](data/trainers/parties.asm#L3081) · Map: [AzaleaGym.asm:L109](maps/AzaleaGym.asm#L109)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Trapinch** (`TRAPINCH`) | 12 | — | Arena Trap *(slot 2, class default)* | Bug Bite, Faint Attack, Mud-Slap, Bulldoze |
| 2 | **Pineco** (`PINECO`) | 15 | — | Aftermath *(slot 2, class default)* | Bug Bite, Selfdestruct, Rapid Spin, Pin Missile |

### Al — Azalea Gym (`AL`)

**2 Pokémon, Lv. 12–15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3089](data/trainers/parties.asm#L3089) · Map: [AzaleaGym.asm:L120](maps/AzaleaGym.asm#L120)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sizzlipede** (`SIZZLIPEDE`) | 12 | — | White Smoke *(slot 2, class default)* | Wrap, Struggle Bug, Bite, Flame Wheel |
| 2 | **Joltik** (`JOLTIK`) | 15 | — | Unnerve *(slot 2, class default)* | Spider Web, Thundershock, Nuzzle, Thunder Wave |

### Josh — Azalea Gym (`JOSH`)

**1 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3097](data/trainers/parties.asm#L3097) · Map: [AzaleaGym.asm:L131](maps/AzaleaGym.asm#L131)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ledyba** (`LEDYBA`) | 15 | — | Iron Fist *(slot 2, class default)* | Reflect, Safeguard, Mach Punch, Aerial Ace |


### ARNIE1 — Route 35

**2 Pokémon, Lv. 23**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3103](data/trainers/parties.asm#L3103) · Map: [Route35.asm:L130](maps/Route35.asm#L130)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spinarak** (`SPINARAK`) | 23 | — | Sniper *(slot 2, class default)* | Night Shade, Shadow Sneak, Leech Life, Night Slash |
| 2 | **Charjabug** (`CHARJABUG`) | 23 | — | Hustle *(slot 2, class default)* | Vicegrip, Nuzzle, Bite, Spark |

### ARNIE2 — Route 35

**2 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3149](data/trainers/parties.asm#L3149) · Map: [Route35.asm:L190](maps/Route35.asm#L190)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Venonat** (`VENONAT`) | 38 | — | Compound Eyes *(slot 2, class default)* | Bug Buzz, Zen Headbutt, Baton Pass, Psychic |
| 2 | **Yanma** (`YANMA`) | 38 | — | Compound Eyes *(slot 2, class default)* | Dualwingbeat, Ancientpower, Hypnosis, Signal Beam |

### ARNIE3 — Route 35

**3 Pokémon, Lv. 43–44**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3157](data/trainers/parties.asm#L3157) · Map: [Route35.asm:L198](maps/Route35.asm#L198)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vibrava** (`VIBRAVA`) | 43 | — | Overcoat *(slot 2, class default)* | Earth Power, Sandstorm, Earthquake, Bug Buzz |
| 2 | **Heracross** (`HERACROSS`) | 44 | — | Skill Link *(slot 2, class default)* | Circle Throw, Take Down, Hammer Arm, Close Combat |
| 3 | **Scizor** (`SCIZOR`) | 44 | — | Swarm *(slot 2, class default)* | Dualwingbeat, Iron Defense, Iron Head, Swords Dance |

### ARNIE4 — Route 35

**4 Pokémon, Lv. 55–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3193](data/trainers/parties.asm#L3193) · Map: [Route35.asm:L206](maps/Route35.asm#L206)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Galvantula** (`GALVANTULA`) | 55 | — | Unnerve *(slot 2, class default)* | Signal Beam, Volt Switch, Bug Buzz, Wild Charge |
| 2 | **Scyther** (`SCYTHER`) | 56 | — | Swarm *(slot 2, class default)* | Air Slash, Swords Dance, Baton Pass, Reversal |
| 3 | **Shuckle** (`SHUCKLE`) | 56 | — | Gluttony *(slot 2, class default)* | Sweet Scent, Body Press, Earth Power, Stone Edge |
| 4 | **Ariados** (`ARIADOS`) | 56 | — | Sniper *(slot 2, class default)* | Pin Missile, Agility, Psychic, Megahorn |

### ARNIE5 — Route 35

**4 Pokémon, Lv. 60–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3205](data/trainers/parties.asm#L3205) · Map: [Route35.asm:L214](maps/Route35.asm#L214)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ledian** (`LEDIAN`) | 60 | — | Iron Fist *(slot 2, class default)* | Quiver Dance, Bug Buzz, Close Combat, Double-Edge |
| 2 | **Pinsir** (`PINSIR`) | 60 | — | Mold Breaker *(slot 2, class default)* | Megahorn, Submission, Superpower, Guillotine |
| 3 | **Ariados** (`ARIADOS`) | 62 | — | Sniper *(slot 2, class default)* | Pin Missile, Agility, Psychic, Megahorn |
| 4 | **Heracross** (`HERACROSS`) | 63 | — | Skill Link *(slot 2, class default)* | Counter, Superpower, Swords Dance, Reversal |

### Ken — Fast Ship Cabins / SW / SSW / NW (`KEN`)

**2 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3111](data/trainers/parties.asm#L3111) · Map: [FastShipCabins_SW_SSW_NW.asm:L24](maps/FastShipCabins_SW_SSW_NW.asm#L24)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vikavolt** (`VIKAVOLT`) | 54 | — | Hustle *(slot 2, class default)* | Thunderbolt, Bug Buzz, Crunch, Signal Beam |
| 2 | **Ledian** (`LEDIAN`) | 56 | — | Iron Fist *(slot 2, class default)* | Close Combat, U-Turn, Roost, Mach Punch |

### Doug — Route 2 (`DOUG`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3139](data/trainers/parties.asm#L3139) · Map: [ViridianForest.asm:L39](maps/ViridianForest.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Beedrill** (`BEEDRILL`) | 69 | — | Sniper *(slot 2, class default)* | Megahorn, Poison Jab, Drill Peck, Drill Run |
| 2 | **Scolipede** (`SCOLIPEDE`) | 69 | — | Swarm *(slot 2, class default)* | Megahorn, Cross Poison, Bug Bite, Poison Fang |

### Wayne — Ilex Forest (`WAYNE`)

**2 Pokémon, Lv. 18**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3217](data/trainers/parties.asm#L3217) · Map: [IlexForest.asm:L451](maps/IlexForest.asm#L451)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sizzlipede** (`SIZZLIPEDE`) | 18 | — | White Smoke *(slot 2, class default)* | Struggle Bug, Bite, Flame Wheel, Bug Bite |
| 2 | **Venipede** (`VENIPEDE`) | 18 | — | Swarm *(slot 2, class default)* | Rollout, Protect, Poison Fang, Screech |


## Fisher

> **Group:** `FisherGroup` · **Battle IDs:** `FISHER` · **25 parties**

### Justin — Route 32 (`JUSTIN`)

**1 Pokémon, Lv. 11**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3228](data/trainers/parties.asm#L3228) · Map: [Route32.asm:L156](maps/Route32.asm#L156)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Goldeen** (`GOLDEEN`) | 11 | — | Water Veil *(slot 2, class default)* | Quick Attack, Supersonic, Horn Attack, Flail |


### RALPH1 — Route 32

**1 Pokémon, Lv. 12**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3234](data/trainers/parties.asm#L3234) · Map: [Route32.asm:L167](maps/Route32.asm#L167)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Marill** (`MARILL`) | 12 | — | Thick Fat *(slot 2, class default)* | Bubble, Charm, Bubblebeam, Slam |

### RALPH2 — Route 32

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3384](data/trainers/parties.asm#L3384) · Map: [Route32.asm:L227](maps/Route32.asm#L227)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Remoraid** (`REMORAID`) | 24 | — | Sniper *(slot 2, class default)* | Aurora Beam, Bubblebeam, Focus Energy, Water Pulse |

### RALPH3 — Route 32

**2 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3390](data/trainers/parties.asm#L3390) · Map: [Route32.asm:L235](maps/Route32.asm#L235)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mareanie** (`MAREANIE`) | 38 | — | Limber *(slot 2, class default)* | Pin Missile, Toxic Spikes, Liquidation, Cross Poison |
| 2 | **Chinchou** (`CHINCHOU`) | 38 | — | Water Absorb *(slot 2, class default)* | Flail, Signal Beam, Thunderbolt, Take Down |

### RALPH4 — Route 32

**3 Pokémon, Lv. 53–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3449](data/trainers/parties.asm#L3449) · Map: [Route32.asm:L243](maps/Route32.asm#L243)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Politoed** (`POLITOED`) | 53 | — | Damp *(slot 2, class default)* | Bubblebeam, Earth Power, Double-Edge, Belly Drum |
| 2 | **Corsola** (`CORSOLA`) | 53 | — | Natural Cure *(slot 2, class default)* | Power Gem, Bubblebeam, Earth Power, Recover |
| 3 | **Slowking** (`SLOWKING`) | 56 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Future Sight, Nasty Plot |

### RALPH5 — Route 32

**3 Pokémon, Lv. 59–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3462](data/trainers/parties.asm#L3462) · Map: [Route32.asm:L251](maps/Route32.asm#L251)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tentacruel** (`TENTACRUEL`) | 59 | — | Rain Dish *(slot 2, class default)* | Hydro Pump, Surf, Sludge Bomb, Toxic Spikes |
| 2 | **Lanturn** (`LANTURN`) | 59 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Thunderbolt, Bubblebeam, Thunder Wave |
| 3 | **Quagsire** (`QUAGSIRE`) | 63 | — | Water Absorb *(slot 2, class default)* | Earthquake, Aqua Tail, Body Slam, Toxic |

### Arnold — Route 21 (`ARNOLD`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3240](data/trainers/parties.asm#L3240) · Map: [Route21.asm:L34](maps/Route21.asm#L34)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingler** (`KINGLER`) | 69 | — | Tough Claws *(slot 2, class default)* | Liquidation, X-Scissor, Strength, Metal Claw |
| 2 | **Poliwrath** (`POLIWRATH`) | 69 | — | Iron Fist *(slot 2, class default)* | Waterfall, Brick Break, Earthquake, Mach Punch |

### Kyle — Route 12 (`KYLE`)

**3 Pokémon, Lv. 64**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3250](data/trainers/parties.asm#L3250) · Map: [Route12.asm:L15](maps/Route12.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxapex** (`TOXAPEX`) | 64 | — | Regenerator *(hidden)* | Liquidation, Poison Jab, Body Press, Recover |
| 2 | **Lapras** (`LAPRAS`) | 64 | — | Water Absorb *(slot 1)* | Hydro Pump, Ice Beam, Megahorn, Ice Shard |
| 3 | **Kingdra** (`KINGDRA`) | 64 | — | Sniper *(slot 2)* | Hydro Pump, Dragon Pulse, Ice Beam, Agility |

### Henry — Route 32 (`HENRY`)

**2 Pokémon, Lv. 11**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3266](data/trainers/parties.asm#L3266) · Map: [Route32.asm:L292](maps/Route32.asm#L292)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 11 | — | Water Absorb *(slot 2, class default)* | Bubble, Thunder Wave, Water Gun, Nuzzle |
| 2 | **Remoraid** (`REMORAID`) | 11 | — | Sniper *(slot 2, class default)* | Water Gun, Lock-On, Psybeam |

### Marvin — Route 43 (`MARVIN`)

**2 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3274](data/trainers/parties.asm#L3274) · Map: [Route43.asm:L166](maps/Route43.asm#L166)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sealeo** (`SEALEO`) | 36 | — | Ice Body *(slot 2, class default)* | Rest, Snore, Hail, Ice Beam |
| 2 | **Psyduck** (`PSYDUCK`) | 36 | — | Cloud Nine *(slot 2, class default)* | Hypnosis, Aqua Tail, Psychic, Psych Up |


### TULLY1 — Route 42

**1 Pokémon, Lv. 33**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3282](data/trainers/parties.asm#L3282) · Map: [Route42.asm:L97](maps/Route42.asm#L97)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lombre** (`LOMBRE`) | 33 | — | Rain Dish *(slot 2, class default)* | Bubblebeam, Giga Drain, Leech Seed, Knock Off |

### TULLY2 — Route 42

**1 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3398](data/trainers/parties.asm#L3398) · Map: [Route42.asm:L153](maps/Route42.asm#L153)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 38 | — | Water Absorb *(slot 2, class default)* | Flail, Signal Beam, Thunderbolt, Take Down |

### TULLY3 — Route 42

**3 Pokémon, Lv. 53–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3404](data/trainers/parties.asm#L3404) · Map: [Route42.asm:L161](maps/Route42.asm#L161)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Politoed** (`POLITOED`) | 53 | — | Damp *(slot 2, class default)* | Swagger, Bounce, Hydro Pump, Hyper Voice |
| 2 | **Ludicolo** (`LUDICOLO`) | 53 | — | Rain Dish *(slot 2, class default)* | Bubblebeam, Giga Drain, Knock Off, Wood Hammer |
| 3 | **Slowking** (`SLOWKING`) | 56 | — | Unaware *(slot 2, class default)* | Future Sight, Trick Room, Aura Sphere, Slack Off |

### TULLY4 — Route 42

**3 Pokémon, Lv. 59–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3475](data/trainers/parties.asm#L3475) · Map: [Route42.asm:L169](maps/Route42.asm#L169)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingdra** (`KINGDRA`) | 59 | — | Sniper *(slot 2, class default)* | Dragon Tail, Outrage, Hydro Pump, Hyper Beam |
| 2 | **Azumarill** (`AZUMARILL`) | 59 | — | Thick Fat *(slot 2, class default)* | Belly Drum, Double-Edge, Hydro Pump, Liquidation |
| 3 | **Octillery** (`OCTILLERY`) | 63 | — | Sniper *(slot 2, class default)* | Flamethrower, Hydro Pump, Gunk Shot, Hyper Beam |

### Andre — Lake of Rage (`ANDRE`)

**1 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3288](data/trainers/parties.asm#L3288) · Map: [LakeOfRage.asm:L162](maps/LakeOfRage.asm#L162)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 36 | — | Natural Cure *(slot 2, class default)* | Amnesia, Power Gem, Stealth Rock, Earth Power |

### Raymond — Lake of Rage (`RAYMOND`)

**1 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3294](data/trainers/parties.asm#L3294) · Map: [LakeOfRage.asm:L173](maps/LakeOfRage.asm#L173)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Goldeen** (`GOLDEEN`) | 37 | — | Water Veil *(slot 2, class default)* | Agility, Body Slam, Aqua Tail, Knock Off |


### WILTON1 — Route 44

**3 Pokémon, Lv. 39–41**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L3300](data/trainers/parties.asm#L3300) · Map: [Route44.asm:L164](maps/Route44.asm#L164)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Octillery** (`OCTILLERY`) | 39 | — | Suction Cups *(slot 1)* | Focus Energy, Octazooka, Ice Beam, Seed Bomb |
| 2 | **Mantine** (`MANTINE`) | 39 | — | Swift Swim *(slot 1)* | Air Slash, Defog, Dualwingbeat, Mirror Coat |
| 3 | **Seaking** (`SEAKING`) | 41 | — | Lightning Rod *(hidden)* | Agility, Body Slam, Aqua Tail, Knock Off |

### WILTON2 — Route 44

**3 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3414](data/trainers/parties.asm#L3414) · Map: [Route44.asm:L216](maps/Route44.asm#L216)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Octillery** (`OCTILLERY`) | 54 | — | Sniper *(slot 2, class default)* | Flamethrower, Hydro Pump, Gunk Shot, Hyper Beam |
| 2 | **Milotic** (`MILOTIC`) | 56 | — | Competitive *(slot 2, class default)* | Dragon Tail, Safeguard, Mirror Coat, Hydro Pump |
| 3 | **Cloyster** (`CLOYSTER`) | 56 | — | Shell Armor *(slot 2, class default)* | Freeze-Dry, Aurora Beam, Whirlpool, Rock Blast |

### WILTON3 — Route 44

**3 Pokémon, Lv. 60–63**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L3436](data/trainers/parties.asm#L3436) · Map: [Route44.asm:L224](maps/Route44.asm#L224)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seaking** (`SEAKING`) | 60 | — | Lightning Rod *(hidden)* | Knock Off, Megahorn, Hydro Pump, Horn Drill |
| 2 | **Mantine** (`MANTINE`) | 60 | — | Swift Swim *(slot 1)* | Defog, Dualwingbeat, Mirror Coat, Hydro Pump |
| 3 | **Walrein** (`WALREIN`) | 63 | — | Thick Fat *(slot 1)* | Body Press, Surf, Superpower, Blizzard |

### Edgar — Route 44 (`EDGAR`)

**3 Pokémon, Lv. 39–41**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3313](data/trainers/parties.asm#L3313) · Map: [Route44.asm:L259](maps/Route44.asm#L259)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Walrein** (`WALREIN`) | 39 | — | Ice Body *(slot 2, class default)* | Ice Beam, Aurora Beam, Water Pulse, Rest |
| 2 | **Quagsire** (`QUAGSIRE`) | 39 | — | Water Absorb *(slot 2, class default)* | Earthquake, Aqua Tail, Body Slam, Amnesia |
| 3 | **Kingler** (`KINGLER`) | 41 | — | Tough Claws *(slot 2, class default)* | Crabhammer, Knock Off, Stomp, Protect |

### Jonah — Fast Ship B1F (`JONAH`)

**4 Pokémon, Lv. 50–54**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3326](data/trainers/parties.asm#L3326) · Map: [FastShipB1F.asm:L139](maps/FastShipB1F.asm#L139)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Octillery** (`OCTILLERY`) | 50 | — | Sniper *(slot 2, class default)* | Hydro Pump, Gunk Shot, Ice Beam, Flamethrower |
| 2 | **Cloyster** (`CLOYSTER`) | 50 | — | Shell Armor *(slot 2, class default)* | Ice Beam, Surf, Ice Shard, Swift |
| 3 | **Milotic** (`MILOTIC`) | 54 | — | Competitive *(slot 2, class default)* | Hydro Pump, Moonblast, Ice Beam, Recover |
| 4 | **Ludicolo** (`LUDICOLO`) | 54 | — | Rain Dish *(slot 2, class default)* | Leaf Storm, Surf, Zen Headbutt, Energy Ball |

### Martin — Route 12 (`MARTIN`)

**2 Pokémon, Lv. 64–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3342](data/trainers/parties.asm#L3342) · Map: [Route12.asm:L26](maps/Route12.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Starmie** (`STARMIE`) | 64 | — | Analytic *(slot 2, class default)* | Surf, Psychic, Ice Beam, Recover |
| 2 | **Tentacruel** (`TENTACRUEL`) | 66 | — | Rain Dish *(slot 2, class default)* | Hydro Pump, Sludge Bomb, Ice Beam, Hex |

### Stephen — Route 12 (`STEPHEN`)

**4 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3352](data/trainers/parties.asm#L3352) · Map: [Route12.asm:L37](maps/Route12.asm#L37)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mantine** (`MANTINE`) | 64 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Air Slash, Ice Beam, Roost |
| 2 | **Politoed** (`POLITOED`) | 64 | — | Damp *(slot 2, class default)* | Hydro Pump, Earth Power, Ice Beam, Psychic |
| 3 | **Tentacruel** (`TENTACRUEL`) | 64 | — | Rain Dish *(slot 2, class default)* | Hydro Pump, Sludge Bomb, Ice Beam, Hex |
| 4 | **Toxapex** (`TOXAPEX`) | 64 | — | Limber *(slot 2, class default)* | Liquidation, Poison Jab, Body Press, Recover |

### Barney — Route 12 (`BARNEY`)

**3 Pokémon, Lv. 64**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3368](data/trainers/parties.asm#L3368) · Map: [Route12.asm:L48](maps/Route12.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingdra** (`KINGDRA`) | 64 | — | Sniper *(slot 2)* | Hydro Pump, Dragon Pulse, Ice Beam, Headbutt |
| 2 | **Kingler** (`KINGLER`) | 64 | — | Tough Claws *(slot 2)* | Liquidation, X-Scissor, Strength, Metal Claw |
| 3 | **Milotic** (`MILOTIC`) | 64 | — | Competitive *(slot 2)* | Hydro Pump, Moonblast, Ice Beam, Recover |

### Scott — Route 26 (`SCOTT`)

**4 Pokémon, Lv. 47–49**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3424](data/trainers/parties.asm#L3424) · Map: [Route26.asm:L236](maps/Route26.asm#L236)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golduck** (`GOLDUCK`) | 47 | — | Cloud Nine *(slot 2, class default)* | Psychic, Psych Up, Future Sight, Amnesia |
| 2 | **Poliwrath** (`POLIWRATH`) | 47 | — | Iron Fist *(slot 2, class default)* | Circle Throw, Low Kick, Dynamicpunch, Superpower |
| 3 | **Vaporeon** (`VAPOREON`) | 48 | — | Hydration *(slot 2, class default)* | Extrasensory, Acid Armor, Ice Beam, Hydro Pump |
| 4 | **Octillery** (`OCTILLERY`) | 49 | — | Sniper *(slot 2, class default)* | Seed Bomb, Flamethrower, Hydro Pump, Gunk Shot |


## Swimmer M

> **Group:** `SwimmerMGroup` · **Battle IDs:** `SWIMMERM` · **13 parties**

### Harold — Route 19 (`HAROLD`)

**2 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3488](data/trainers/parties.asm#L3488) · Map: [Route19.asm:L174](maps/Route19.asm#L174)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mantine** (`MANTINE`) | 68 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Air Slash, Ice Beam, Roost |
| 2 | **Walrein** (`WALREIN`) | 68 | — | Ice Body *(slot 2, class default)* | Ice Beam, Surf, Body Press, Crunch |

### Simon — Route 40 (`SIMON`)

**2 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3498](data/trainers/parties.asm#L3498) · Map: [Route40.asm:L55](maps/Route40.asm#L55)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Remoraid** (`REMORAID`) | 28 | — | Sniper *(slot 2, class default)* | Aurora Beam, Bubblebeam, Focus Energy, Water Pulse |
| 2 | **Shellder** (`SHELLDER`) | 28 | — | Shell Armor *(slot 2, class default)* | Clamp, Ice Shard, Aurora Beam, Whirlpool |

### Randall — Route 40 (`RANDALL`)

**2 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3506](data/trainers/parties.asm#L3506) · Map: [Route40.asm:L66](maps/Route40.asm#L66)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Goldeen** (`GOLDEEN`) | 28 | — | Water Veil *(slot 2, class default)* | Fury Attack, Waterfall, Agility, Body Slam |
| 2 | **Chinchou** (`CHINCHOU`) | 28 | — | Water Absorb *(slot 2, class default)* | Nuzzle, Spark, Confuse Ray, Bubblebeam |

### Charlie — Route 41 (`CHARLIE`)

**2 Pokémon, Lv. 29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3514](data/trainers/parties.asm#L3514) · Map: [Route41.asm:L113](maps/Route41.asm#L113)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lombre** (`LOMBRE`) | 29 | — | Rain Dish *(slot 2, class default)* | Bullet Seed, Fury Swipes, Bubblebeam, Giga Drain |
| 2 | **Krabby** (`KRABBY`) | 29 | — | Tough Claws *(slot 2, class default)* | Stomp, Crabhammer, Protect, Knock Off |

### George — Route 41 (`GEORGE`)

**3 Pokémon, Lv. 29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3522](data/trainers/parties.asm#L3522) · Map: [Route41.asm:L124](maps/Route41.asm#L124)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 29 | — | Water Absorb *(slot 2, class default)* | Nuzzle, Spark, Confuse Ray, Bubblebeam |
| 2 | **Tentacool** (`TENTACOOL`) | 29 | — | Rain Dish *(slot 2, class default)* | Mega Drain, Bubblebeam, Hex, Poison Jab |
| 3 | **Psyduck** (`PSYDUCK`) | 29 | — | Cloud Nine *(slot 2, class default)* | Disable, Zen Headbutt, Screech, Hypnosis |

### Berke — Route 41 (`BERKE`)

**1 Pokémon, Lv. 30**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3532](data/trainers/parties.asm#L3532) · Map: [Route41.asm:L135](maps/Route41.asm#L135)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seel** (`SEEL`) | 30 | — | Swift Swim *(slot 2, class default)* | Aurora Beam, Rest, Aqua Tail, Ice Beam |

### Kirk — Route 41 (`KIRK`)

**2 Pokémon, Lv. 27**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3538](data/trainers/parties.asm#L3538) · Map: [Route41.asm:L146](maps/Route41.asm#L146)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tentacool** (`TENTACOOL`) | 27 | — | Rain Dish *(slot 2, class default)* | Water Pulse, Wrap, Mega Drain, Bubblebeam |
| 2 | **Lombre** (`LOMBRE`) | 27 | — | Rain Dish *(slot 2, class default)* | Bullet Seed, Fury Swipes, Bubblebeam, Giga Drain |

### Mathew — Route 41 (`MATHEW`)

**2 Pokémon, Lv. 29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3546](data/trainers/parties.asm#L3546) · Map: [Route41.asm:L157](maps/Route41.asm#L157)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 29 | — | Natural Cure *(slot 2, class default)* | Rock Tomb, Spike Cannon, Bubblebeam, Amnesia |
| 2 | **Remoraid** (`REMORAID`) | 29 | — | Sniper *(slot 2, class default)* | Aurora Beam, Bubblebeam, Focus Energy, Water Pulse |

### Jerome — Route 19 (`JEROME`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3554](data/trainers/parties.asm#L3554) · Map: [Route19.asm:L185](maps/Route19.asm#L185)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxapex** (`TOXAPEX`) | 68 | — | Limber *(slot 2, class default)* | Liquidation, Poison Jab, Body Press, Recover |
| 2 | **Lanturn** (`LANTURN`) | 68 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Thunderbolt, Signal Beam, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 68 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Fire Blast, Slack Off |

### Tucker — Route 19 (`TUCKER`)

**2 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3567](data/trainers/parties.asm#L3567) · Map: [Route19.asm:L196](maps/Route19.asm#L196)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seaking** (`SEAKING`) | 68 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Ice Beam, Megahorn, Quick Attack |
| 2 | **Starmie** (`STARMIE`) | 68 | — | Analytic *(slot 2, class default)* | Surf, Psychic, Ice Beam, Recover |

### Cameron — Route 20 (`CAMERON`)

**2 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3577](data/trainers/parties.asm#L3577) · Map: [Route20.asm:L40](maps/Route20.asm#L40)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Cloyster** (`CLOYSTER`) | 68 | — | Shell Armor *(slot 2, class default)* | Ice Beam, Surf, Ice Shard, Swift |
| 2 | **Lanturn** (`LANTURN`) | 68 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Thunderbolt, Ice Beam, Thunder Wave |

### Seth — Route 21 (`SETH`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3587](data/trainers/parties.asm#L3587) · Map: [Route21.asm:L12](maps/Route21.asm#L12)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Poliwrath** (`POLIWRATH`) | 68 | — | Iron Fist *(slot 2, class default)* | Waterfall, Brick Break, Earthquake, Mach Punch |
| 2 | **Milotic** (`MILOTIC`) | 68 | — | Competitive *(slot 2, class default)* | Hydro Pump, Moonblast, Ice Beam, Recover |
| 3 | **Toxapex** (`TOXAPEX`) | 68 | — | Limber *(slot 2, class default)* | Liquidation, Poison Jab, Body Press, Recover |

### Parker — Cerulean Gym (`PARKER`)

**3 Pokémon, Lv. 60**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3600](data/trainers/parties.asm#L3600) · Map: [CeruleanGym.asm:L109](maps/CeruleanGym.asm#L109)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowbro** (`SLOWBRO`) | 60 | — | Regenerator *(hidden)* | Surf, Psychic, Flamethrower, Amnesia |
| 2 | **Octillery** (`OCTILLERY`) | 60 | — | Analytic *(hidden)* | Hydro Pump, Gunk Shot, Flamethrower, Ice Beam |
| 3 | **Gyarados** (`GYARADOS`) | 60 | — | Intimidate *(slot 1)* | Waterfall, Crunch, Ice Fang, Dragon Dance |


## Swimmer F

> **Group:** `SwimmerFGroup` · **Battle IDs:** `SWIMMERF` · **13 parties**

### Elaine — Route 40 (`ELAINE`)

**1 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3619](data/trainers/parties.asm#L3619) · Map: [Route40.asm:L33](maps/Route40.asm#L33)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mareanie** (`MAREANIE`) | 28 | — | Limber *(slot 2, class default)* | Bite, Venoshock, Recover, Pin Missile |

### Paula — Route 40 (`PAULA`)

**2 Pokémon, Lv. 28–29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3625](data/trainers/parties.asm#L3625) · Map: [Route40.asm:L44](maps/Route40.asm#L44)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tentacool** (`TENTACOOL`) | 28 | — | Rain Dish *(slot 2, class default)* | Mega Drain, Bubblebeam, Hex, Poison Jab |
| 2 | **Lombre** (`LOMBRE`) | 29 | — | Rain Dish *(slot 2, class default)* | Bullet Seed, Fury Swipes, Bubblebeam, Giga Drain |

### Kaylee — Route 41 (`KAYLEE`)

**3 Pokémon, Lv. 27**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3633](data/trainers/parties.asm#L3633) · Map: [Route41.asm:L58](maps/Route41.asm#L58)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 27 | — | Water Absorb *(slot 2, class default)* | Nuzzle, Spark, Confuse Ray, Bubblebeam |
| 2 | **Mareanie** (`MAREANIE`) | 27 | — | Limber *(slot 2, class default)* | Bite, Venoshock, Recover, Pin Missile |
| 3 | **Krabby** (`KRABBY`) | 27 | — | Tough Claws *(slot 2, class default)* | Metal Claw, Stomp, Crabhammer, Protect |

### Susie — Route 41 (`SUSIE`)

**2 Pokémon, Lv. 29–30**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3643](data/trainers/parties.asm#L3643) · Map: [Route41.asm:L69](maps/Route41.asm#L69)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 29 | — | Natural Cure *(slot 2, class default)* | Bubblebeam, Water Pulse, Ancientpower, Recover |
| 2 | **Shellder** (`SHELLDER`) | 30 | — | Shell Armor *(slot 2, class default)* | Bubblebeam, Aurora Beam, Ice Shard, Protect |

### Denise — Route 41 (`DENISE`)

**1 Pokémon, Lv. 30**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3653](data/trainers/parties.asm#L3653) · Map: [Route41.asm:L80](maps/Route41.asm#L80)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mareanie** (`MAREANIE`) | 30 | — | Limber *(slot 2, class default)* | Venoshock, Recover, Pin Missile, Toxic Spikes |

### Kara — Route 41 (`KARA`)

**2 Pokémon, Lv. 28–29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3659](data/trainers/parties.asm#L3659) · Map: [Route41.asm:L91](maps/Route41.asm#L91)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Staryu** (`STARYU`) | 28 | — | Analytic *(slot 2, class default)* | Gyro Ball, Psybeam, Minimize, Power Gem |
| 2 | **Lombre** (`LOMBRE`) | 29 | — | Rain Dish *(slot 2, class default)* | Bullet Seed, Fury Swipes, Bubblebeam, Giga Drain |

### Wendy — Route 41 (`WENDY`)

**2 Pokémon, Lv. 29–30**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3667](data/trainers/parties.asm#L3667) · Map: [Route41.asm:L102](maps/Route41.asm#L102)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lanturn** (`LANTURN`) | 29 | — | Water Absorb *(slot 2, class default)* | Bubblebeam, Spark, Water Gun, Thunder Wave |
| 2 | **Qwilfish** (`QWILFISH`) | 30 | — | Swift Swim *(slot 2, class default)* | Poison Jab, Aqua Jet, Water Gun, Toxic Spikes |

### Dawn — Route 19 (`DAWN`)

**2 Pokémon, Lv. 67–68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3677](data/trainers/parties.asm#L3677) · Map: [Route19.asm:L163](maps/Route19.asm#L163)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kingler** (`KINGLER`) | 67 | — | Tough Claws *(slot 2, class default)* | Liquidation, X-Scissor, Strength, Metal Claw |
| 2 | **Ludicolo** (`LUDICOLO`) | 68 | — | Rain Dish *(slot 2, class default)* | Leaf Storm, Surf, Zen Headbutt, Energy Ball |

### Nicole — Route 20 (`NICOLE`)

**2 Pokémon, Lv. 68**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3687](data/trainers/parties.asm#L3687) · Map: [Route20.asm:L18](maps/Route20.asm#L18)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Starmie** (`STARMIE`) | 68 | — | Regenerator *(hidden)* | Surf, Psychic, Ice Beam, Recover |
| 2 | **Octillery** (`OCTILLERY`) | 68 | — | Analytic *(hidden)* | Hydro Pump, Gunk Shot, Ice Beam, Flamethrower |

### Lori — Route 20 (`LORI`)

**2 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3699](data/trainers/parties.asm#L3699) · Map: [Route20.asm:L29](maps/Route20.asm#L29)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Walrein** (`WALREIN`) | 68 | — | Ice Body *(slot 2, class default)* | Ice Beam, Surf, Body Press, Crunch |
| 2 | **Milotic** (`MILOTIC`) | 68 | — | Competitive *(slot 2, class default)* | Hydro Pump, Moonblast, Ice Beam, Recover |

### Nikki — Route 21 (`NIKKI`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3709](data/trainers/parties.asm#L3709) · Map: [Route21.asm:L23](maps/Route21.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxapex** (`TOXAPEX`) | 68 | — | Limber *(slot 2, class default)* | Liquidation, Poison Jab, Body Press, Recover |
| 2 | **Gyarados** (`GYARADOS`) | 68 | — | Intimidate *(slot 2, class default)* | Waterfall, Crunch, Ice Fang, Strength |
| 3 | **Poliwrath** (`POLIWRATH`) | 68 | — | Iron Fist *(slot 2, class default)* | Waterfall, Brick Break, Earthquake, Mach Punch |

### Diana — Cerulean Gym (`DIANA`)

**3 Pokémon, Lv. 60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3722](data/trainers/parties.asm#L3722) · Map: [CeruleanGym.asm:L87](maps/CeruleanGym.asm#L87)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Milotic** (`MILOTIC`) | 60 | — | Competitive *(slot 2, class default)* | Hydro Pump, Moonblast, Ice Beam, Recover |
| 2 | **Politoed** (`POLITOED`) | 60 | — | Damp *(slot 2, class default)* | Hydro Pump, Earth Power, Ice Beam, Psychic |
| 3 | **Walrein** (`WALREIN`) | 60 | — | Ice Body *(slot 2, class default)* | Ice Beam, Surf, Body Press, Crunch |

### Briana — Cerulean Gym (`BRIANA`)

**3 Pokémon, Lv. 62**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L3735](data/trainers/parties.asm#L3735) · Map: [CeruleanGym.asm:L98](maps/CeruleanGym.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ludicolo** (`LUDICOLO`) | 62 | — | Swift Swim *(slot 1)* | Leaf Storm, Surf, Zen Headbutt, Waterfall |
| 2 | **Toxapex** (`TOXAPEX`) | 62 | — | Regenerator *(hidden)* | Liquidation, Poison Jab, Body Press, Recover |
| 3 | **Walrein** (`WALREIN`) | 62 | — | Thick Fat *(slot 1)* | Ice Beam, Surf, Body Press, Crunch |


## Sailor

> **Group:** `SailorGroup` · **Battle IDs:** `SAILOR` · **13 parties**

### Eugene — Route 39 (`EUGENE`)

**2 Pokémon, Lv. 25–27**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3754](data/trainers/parties.asm#L3754) · Map: [Route39.asm:L117](maps/Route39.asm#L117)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Marill** (`MARILL`) | 25 | — | Thick Fat *(slot 2, class default)* | Slam, Aqua Jet, Aqua Tail, Play Rough |
| 2 | **Remoraid** (`REMORAID`) | 27 | — | Sniper *(slot 2, class default)* | Aurora Beam, Bubblebeam, Focus Energy, Water Pulse |


### HUEY1 — Olivine Lighthouse 2F

**2 Pokémon, Lv. 32–34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3762](data/trainers/parties.asm#L3762) · Map: [OlivineLighthouse2F.asm:L22](maps/OlivineLighthouse2F.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 32 | — | Water Absorb *(slot 2, class default)* | Confuse Ray, Bubblebeam, Flail, Signal Beam |
| 2 | **Lombre** (`LOMBRE`) | 34 | — | Rain Dish *(slot 2, class default)* | Bubblebeam, Giga Drain, Leech Seed, Knock Off |

### HUEY2 — Olivine Lighthouse 2F

**2 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3846](data/trainers/parties.asm#L3846) · Map: [OlivineLighthouse2F.asm:L74](maps/OlivineLighthouse2F.asm#L74)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 43 | — | Natural Cure *(slot 2, class default)* | Earth Power, Endure, Rock Blast, Heal Bell |
| 2 | **Qwilfish** (`QWILFISH`) | 43 | — | Swift Swim *(slot 2, class default)* | Pin Missile, Cross Poison, Take Down, Destiny Bond |

### HUEY3 — Olivine Lighthouse 2F

**2 Pokémon, Lv. 56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3854](data/trainers/parties.asm#L3854) · Map: [OlivineLighthouse2F.asm:L82](maps/OlivineLighthouse2F.asm#L82)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mareanie** (`MAREANIE`) | 56 | — | Limber *(slot 2, class default)* | Cross Poison, Bane Bunker, Poison Jab, Toxic |
| 2 | **Remoraid** (`REMORAID`) | 56 | — | Sniper *(slot 2, class default)* | Flamethrower, Hydro Pump, Gunk Shot, Hyper Beam |

### HUEY4 — Olivine Lighthouse 2F

**2 Pokémon, Lv. 63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3862](data/trainers/parties.asm#L3862) · Map: [OlivineLighthouse2F.asm:L90](maps/OlivineLighthouse2F.asm#L90)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sealeo** (`SEALEO`) | 63 | — | Ice Body *(slot 2, class default)* | Aurora Beam, Water Pulse, Powder Snow, Rest |
| 2 | **Quagsire** (`QUAGSIRE`) | 63 | — | Water Absorb *(slot 2, class default)* | Aqua Tail, Body Slam, Slam, Amnesia |

### Terrell — Olivine Lighthouse 3F (`TERRELL`)

**1 Pokémon, Lv. 33**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3770](data/trainers/parties.asm#L3770) · Map: [OlivineLighthouse3F.asm:L35](maps/OlivineLighthouse3F.asm#L35)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seel** (`SEEL`) | 33 | — | Swift Swim *(slot 2, class default)* | Rest, Aqua Tail, Ice Beam, Take Down |

### Kent — Olivine Lighthouse 4F (`KENT`)

**2 Pokémon, Lv. 33**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3776](data/trainers/parties.asm#L3776) · Map: [OlivineLighthouse4F.asm:L22](maps/OlivineLighthouse4F.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chinchou** (`CHINCHOU`) | 33 | — | Water Absorb *(slot 2, class default)* | Bubblebeam, Flail, Signal Beam, Thunderbolt |
| 2 | **Remoraid** (`REMORAID`) | 33 | — | Sniper *(slot 2, class default)* | Focus Energy, Water Pulse, Ice Beam, Seed Bomb |

### Ernest — Olivine Lighthouse 5F (`ERNEST`)

**3 Pokémon, Lv. 32–34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3784](data/trainers/parties.asm#L3784) · Map: [OlivineLighthouse5F.asm:L25](maps/OlivineLighthouse5F.asm#L25)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Remoraid** (`REMORAID`) | 32 | — | Sniper *(slot 2, class default)* | Bubblebeam, Focus Energy, Water Pulse, Ice Beam |
| 2 | **Chinchou** (`CHINCHOU`) | 34 | — | Water Absorb *(slot 2, class default)* | Bubblebeam, Flail, Signal Beam, Thunderbolt |
| 3 | **Poliwhirl** (`POLIWHIRL`) | 34 | — | Damp *(slot 2, class default)* | Low Sweep, Body Slam, Low Kick, Belly Drum |

### Jeff — Fast Ship B1F (`JEFF`)

**2 Pokémon, Lv. 53**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3794](data/trainers/parties.asm#L3794) · Map: [FastShipB1F.asm:L95](maps/FastShipB1F.asm#L95)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Azumarill** (`AZUMARILL`) | 53 | — | Thick Fat *(slot 2, class default)* | Hydro Pump, Play Rough, Ice Beam, Aqua Jet |
| 2 | **Hitmonchan** (`HITMONCHAN`) | 53 | — | Keen Eye *(slot 2, class default)* | Close Combat, Ice Punch, Mach Punch, Bullet Punch |

### Garrett — Fast Ship B1F (`GARRETT`)

**2 Pokémon, Lv. 53–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3804](data/trainers/parties.asm#L3804) · Map: [FastShipB1F.asm:L128](maps/FastShipB1F.asm#L128)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Poliwrath** (`POLIWRATH`) | 53 | — | Iron Fist *(slot 2, class default)* | Waterfall, Close Combat, Ice Punch, Mach Punch |
| 2 | **Kingler** (`KINGLER`) | 55 | — | Tough Claws *(slot 2, class default)* | Liquidation, X-Scissor, Strength, Metal Claw |

### Kenneth — Fast Ship B1F (`KENNETH`)

**4 Pokémon, Lv. 54**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3814](data/trainers/parties.asm#L3814) · Map: [FastShipB1F.asm:L161](maps/FastShipB1F.asm#L161)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tentacruel** (`TENTACRUEL`) | 54 | — | Rain Dish *(slot 2, class default)* | Surf, Sludge Bomb, Ice Beam, Toxic |
| 2 | **Politoed** (`POLITOED`) | 54 | — | Damp *(slot 2, class default)* | Hydro Pump, Earth Power, Ice Beam, Psychic |
| 3 | **Azumarill** (`AZUMARILL`) | 54 | — | Thick Fat *(slot 2, class default)* | Liquidation, Play Rough, Ice Punch, Aqua Jet |
| 4 | **Lanturn** (`LANTURN`) | 54 | — | Water Absorb *(slot 2, class default)* | Surf, Thunderbolt, Ice Beam, Thunder Wave |

### Stanly — Fast Ship Cabins / NNW / NNE / NE (`STANLY`)

**3 Pokémon, Lv. 52–53**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3830](data/trainers/parties.asm#L3830) · Map: [FastShipCabins_NNW_NNE_NE.asm:L89](maps/FastShipCabins_NNW_NNE_NE.asm#L89)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Poliwrath** (`POLIWRATH`) | 52 | — | Iron Fist *(slot 2, class default)* | Low Kick, Dynamicpunch, Superpower, Belly Drum |
| 2 | **Golduck** (`GOLDUCK`) | 52 | — | Cloud Nine *(slot 2, class default)* | Psych Up, Future Sight, Amnesia, Cross Chop |
| 3 | **Lanturn** (`LANTURN`) | 53 | — | Water Absorb *(slot 2, class default)* | Signal Beam, Thunderbolt, Take Down, Hydro Pump |

### Harry — Route 38 (`HARRY`)

**1 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3840](data/trainers/parties.asm#L3840) · Map: [Route38.asm:L27](maps/Route38.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Poliwhirl** (`POLIWHIRL`) | 28 | — | Damp *(slot 2, class default)* | Bubblebeam, Low Sweep, Body Slam, Low Kick |


## Super Nerd

> **Group:** `SuperNerdGroup` · **Battle IDs:** `SUPER_NERD` · **9 parties**

### Stan — Ruins of Alph Outside (`STAN`)

**1 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3875](data/trainers/parties.asm#L3875) · Map: [RuinsOfAlphOutside.asm:L114](maps/RuinsOfAlphOutside.asm#L114)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowpoke** (`SLOWPOKE_GALARIAN`) | 20 | — | Unaware *(slot 2, class default)* | Disable, Headbutt, Confuse Ray, Water Pulse |

### Eric — Goldenrod Underground (`ERIC`)

**2 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3881](data/trainers/parties.asm#L3881) · Map: [GoldenrodUnderground.asm:L119](maps/GoldenrodUnderground.asm#L119)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magnemite** (`MAGNEMITE`) | 20 | — | Analytic *(slot 2, class default)* | Supersonic, Thunder Wave, Spark, Light Screen |
| 2 | **Voltorb** (`VOLTORB`) | 20 | — | Static *(slot 2, class default)* | Screech, Thundershock, Rollout, Spark |

### Sam — Route 8 (`SAM`)

**2 Pokémon, Lv. 63–64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3889](data/trainers/parties.asm#L3889) · Map: [Route8.asm:L48](maps/Route8.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Alakazam** (`ALAKAZAM`) | 63 | — | Synchronize *(slot 2, class default)* | Psychic, Focus Blast, Shadow Ball, Recover |
| 2 | **Jolteon** (`JOLTEON`) | 64 | — | Quick Feet *(slot 2, class default)* | Thunderbolt, Extrasensory, Shadow Ball, Quick Attack |

### Tom — Route 8 (`TOM`)

**3 Pokémon, Lv. 62**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3899](data/trainers/parties.asm#L3899) · Map: [Route8.asm:L59](maps/Route8.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hypno** (`HYPNO`) | 62 | — | No Guard *(slot 2, class default)* | Psychic, Fire Punch, Drain Punch, Ice Punch |
| 2 | **Arcanine** (`ARCANINE_HISUIAN`) | 62 | — | Flash Fire *(slot 2, class default)* | Extremespeed, Fire Blast, Rock Slide, Crunch |
| 3 | **Aggron** (`AGGRON`) | 62 | — | Sturdy *(slot 2, class default)* | Iron Head, Earthquake, Hammer Arm, Head Smash |

### Pat — Route 25 (`PAT`)

**3 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3912](data/trainers/parties.asm#L3912) · Map: [Route25.asm:L470](maps/Route25.asm#L470)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magnezone** (`MAGNEZONE`) | 58 | — | Analytic *(slot 2, class default)* | Thunderbolt, Flash Cannon, Signal Beam, Thunder Wave |
| 2 | **Porygon-Z** (`PORYGON_Z`) | 58 | — | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Psychic, Nasty Plot |
| 3 | **Glimmora** (`GLIMMORA`) | 58 | — | Corrosion *(slot 2, class default)* | Power Gem, Sludge Bomb, Earth Power, Stealth Rock |

### Shawn — Fast Ship Cabins / SE / SSE / Captain's Cabin (`SHAWN`)

**3 Pokémon, Lv. 53–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3925](data/trainers/parties.asm#L3925) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L208](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L208)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weezing** (`WEEZING`) | 53 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Flamethrower, Thunderbolt, Will-O-Wisp |
| 2 | **Electivire** (`ELECTIVIRE`) | 54 | — | Sheer Force *(slot 2, class default)* | Thunderpunch, Close Combat, Earthquake, Ice Punch |
| 3 | **Porygon2** (`PORYGON2`) | 55 | — | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Ice Beam, Recover |

### Teru — Goldenrod Underground (`TERU`)

**3 Pokémon, Lv. 19**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3938](data/trainers/parties.asm#L3938) · Map: [GoldenrodUnderground.asm:L130](maps/GoldenrodUnderground.asm#L130)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Spinarak** (`SPINARAK`) | 19 | — | Sniper *(slot 2, class default)* | Scary Face, Poison Fang, Night Shade, Shadow Sneak |
| 2 | **Glimmet** (`GLIMMET`) | 19 | — | Corrosion *(slot 2, class default)* | Rock Throw, Harden, Ancientpower, Mud Shot |
| 3 | **Ekans** (`EKANS`) | 19 | — | Shed Skin *(slot 2, class default)* | Bite, Acid, Glare, Poison Fang |

### Hugh — Mount Mortar 2F Interior (`HUGH`)

**1 Pokémon, Lv. 38**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3948](data/trainers/parties.asm#L3948) · Map: [MountMortar2FInside.asm:L16](maps/MountMortar2FInside.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magneton** (`MAGNETON`) | 38 | — | Analytic *(slot 2, class default)* | Thunderbolt, Flash Cannon, Thunder Wave, Tri Attack |

### Markus — Mount Mortar 1F Interior (`MARKUS`)

**1 Pokémon, Lv. 29**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3955](data/trainers/parties.asm#L3955) · Map: [MountMortar1FInside.asm:L30](maps/MountMortar1FInside.asm#L30)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magnemite** (`MAGNEMITE`) | 29 | — | Analytic *(slot 2, class default)* | Thunderbolt, Flash Cannon, Thunder Wave, Supersonic |


## Guitarist

> **Group:** `GuitaristGroup` · **Battle IDs:** `GUITARIST` · **2 parties**

### Clyde — Fast Ship Cabins / SW / SSW / NW (`CLYDE`)

**3 Pokémon, Lv. 52–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3965](data/trainers/parties.asm#L3965) · Map: [FastShipCabins_SW_SSW_NW.asm:L46](maps/FastShipCabins_SW_SSW_NW.asm#L46)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gorotora** (`GOROTORA`) | 52 | — | Intimidate *(slot 2, class default)* | Thunderbolt, Crunch, Extremespeed, Thunder Wave |
| 2 | **Electivire** (`ELECTIVIRE`) | 54 | — | Sheer Force *(slot 2, class default)* | Thunderpunch, Close Combat, Earthquake, Ice Punch |
| 3 | **Wigglytuff** (`WIGGLYTUFF`) | 56 | — | Competitive *(slot 2, class default)* | Hyper Voice, Moonblast, Fire Blast, Thunderbolt |

### Vincent — Vermilion Gym (`VINCENT`)

**4 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L3978](data/trainers/parties.asm#L3978) · Map: [VermilionGym.asm:L57](maps/VermilionGym.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Electabuzz** (`ELECTABUZZ`) | 58 | — | Vital Spirit *(slot 2, class default)* | Thunderbolt, Thunder, Close Combat, Thunder Wave |
| 2 | **Electrode** (`ELECTRODE`) | 58 | — | Static *(slot 2, class default)* | Thunderbolt, Thunder, Signal Beam, Light Screen |
| 3 | **Magneton** (`MAGNETON`) | 58 | — | Analytic *(slot 2, class default)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 4 | **Vikavolt** (`VIKAVOLT`) | 58 | — | Hustle *(slot 2, class default)* | Thunderbolt, Bug Buzz, Signal Beam, Agility |


## Hiker

> **Group:** `HikerGroup` · **Battle IDs:** `HIKER` · **22 parties**


### ANTHONY1 — Route 33

**2 Pokémon, Lv. 29**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L3997](data/trainers/parties.asm#L3997) · Map: [Route33.asm:L75](maps/Route33.asm#L75)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dugtrio** (`DUGTRIO_ALOLAN`) | 29 | — | Tangling Hair *(slot 1, class default)* | Dig, Sucker Punch, Tri Attack, Rock Slide |
| 2 | **Sandslash** (`SANDSLASH`) | 29 | — | Sand Veil *(slot 1, class default)* | Fury Swipes, Slash, Night Slash, Dig |

### ANTHONY2 — Route 33

**2 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4031](data/trainers/parties.asm#L4031) · Map: [Route33.asm:L15](maps/Route33.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Phanpy** (`PHANPY`) | 15 | — | Sand Veil *(slot 1, class default)* | Mud-Slap, Headbutt, Rollout, Bulldoze |
| 2 | **Swinub** (`SWINUB`) | 15 | — | Thick Fat *(slot 1, class default)* | Icy Wind, Mud-Slap, Powder Snow, Ice Shard |

### ANTHONY3 — Route 33

**3 Pokémon, Lv. 42–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4110](data/trainers/parties.asm#L4110) · Map: [Route33.asm:L83](maps/Route33.asm#L83)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 42 | — | Hustle *(slot 1, class default)* | Earth Power, Endure, Rock Blast, Heal Bell |
| 2 | **Sandslash** (`SANDSLASH`) | 43 | — | Sand Veil *(slot 1, class default)* | Gyro Ball, Poison Jab, Drill Run, Earthquake |
| 3 | **Ursaring** (`URSARING`) | 43 | — | Guts *(slot 1, class default)* | Crunch, Snore, Hammer Arm, Thrash |

### ANTHONY4 — Route 33

**3 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4208](data/trainers/parties.asm#L4208) · Map: [Route33.asm:L91](maps/Route33.asm#L91)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Glimmora** (`GLIMMORA`) | 54 | — | Toxic Debris *(slot 1, class default)* | Stealth Rock, Power Gem, Acid Armor, Head Smash |
| 2 | **Nidoking** (`NIDOKING`) | 54 | — | Poison Point *(slot 1, class default)* | Poison Jab, Cross Poison, Drill Run, Sucker Punch |
| 3 | **Gliscor** (`GLISCOR`) | 56 | — | Poison Heal *(slot 1, class default)* | Drill Run, Swords Dance, Crabhammer, Guillotine |

### ANTHONY5 — Route 33

**3 Pokémon, Lv. 60–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4218](data/trainers/parties.asm#L4218) · Map: [Route33.asm:L99](maps/Route33.asm#L99)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Quagsire** (`QUAGSIRE`) | 60 | — | Damp *(slot 1, class default)* | Earthquake, Aqua Tail, Body Slam, Toxic |
| 2 | **Golem** (`GOLEM_ALOLAN`) | 63 | — | Magnet Pull *(slot 1, class default)* | Stone Edge, Superpower, Double-Edge, Stealth Rock |
| 3 | **Rhyperior** (`RHYPERIOR`) | 63 | — | Solid Rock *(slot 1, class default)* | Earthquake, Superpower, Double-Edge, Stealth Rock |

### Russell — Union Cave 1F (`RUSSELL`)

**2 Pokémon, Lv. 11–12**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4005](data/trainers/parties.asm#L4005) · Map: [UnionCave1F.asm:L29](maps/UnionCave1F.asm#L29)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Numel** (`NUMEL`) | 11 | — | Oblivious *(slot 1, class default)* | Growl, Magnitude, Ember, Focus Energy |
| 2 | **Wooper** (`WOOPER`) | 12 | — | Damp *(slot 1, class default)* | Tail Whip, Water Gun, Slam |

### Phillip — Union Cave B1F (`PHILLIP`)

**3 Pokémon, Lv. 13–14**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4013](data/trainers/parties.asm#L4013) · Map: [UnionCaveB1F.asm:L38](maps/UnionCaveB1F.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 13 | — | Immunity *(slot 1, class default)* | Quick Attack, Fury Cutter, Knock Off, Wing Attack |
| 2 | **Phanpy** (`PHANPY`) | 13 | — | Sand Veil *(slot 1, class default)* | Mud-Slap, Headbutt, Rollout, Bulldoze |
| 3 | **Geodude** (`GEODUDE`) | 14 | — | Rock Head *(slot 1, class default)* | Magnitude, Rock Throw, Harden, Bulldoze |

### Leonard — Union Cave B1F (`LEONARD`)

**2 Pokémon, Lv. 13–15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4023](data/trainers/parties.asm#L4023) · Map: [UnionCaveB1F.asm:L49](maps/UnionCaveB1F.asm#L49)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Geodude** (`GEODUDE_ALOLAN`) | 13 | — | Magnet Pull *(slot 1, class default)* | Spark, Rock Throw, Harden, Thunderpunch |
| 2 | **Phanpy** (`PHANPY`) | 15 | — | Sand Veil *(slot 1, class default)* | Mud-Slap, Headbutt, Rollout, Bulldoze |

### Benjamin — Route 42 (`BENJAMIN`)

**2 Pokémon, Lv. 33**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4039](data/trainers/parties.asm#L4039) · Map: [Route42.asm:L234](maps/Route42.asm#L234)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Numel** (`NUMEL`) | 33 | — | Oblivious *(slot 1, class default)* | Amnesia, Earth Power, Curse, Take Down |
| 2 | **Sandshrew** (`SANDSHREW`) | 33 | — | Sand Veil *(slot 1, class default)* | Dig, Agility, Gyro Ball, Poison Jab |

### Erik — Route 45 (`ERIK`)

**3 Pokémon, Lv. 42–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4047](data/trainers/parties.asm#L4047) · Map: [Route45.asm:L126](maps/Route45.asm#L126)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Quagsire** (`QUAGSIRE`) | 42 | — | Damp *(slot 1, class default)* | Aqua Tail, Body Slam, Earthquake, Counter |
| 2 | **Graveler** (`GRAVELER`) | 42 | — | Rock Head *(slot 1, class default)* | Earthquake, Stealth Rock, Rock Blast, Explosion |
| 3 | **Machamp** (`MACHAMP`) | 43 | — | Guts *(slot 1, class default)* | Bulk Up, Circle Throw, Cross Chop, Hammer Arm |

### Michael — Route 45 (`MICHAEL`)

**3 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4057](data/trainers/parties.asm#L4057) · Map: [Route45.asm:L137](maps/Route45.asm#L137)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Heracross** (`HERACROSS`) | 43 | — | Guts *(slot 1, class default)* | Circle Throw, Take Down, Hammer Arm, Close Combat |
| 2 | **Excadrill** (`EXCADRILL`) | 43 | — | Sand Rush *(slot 1, class default)* | Sandstorm, Stealth Rock, Swords Dance, Drill Run |
| 3 | **Sirfetch'd** (`SIRFETCH_D`) | 43 | — | Steadfast *(slot 1, class default)* | Brick Break, False Swipe, Circle Throw, Brave Bird |


### PARRY1 — Route 45

**3 Pokémon, Lv. 53–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4067](data/trainers/parties.asm#L4067) · Map: [Route45.asm:L198](maps/Route45.asm#L198)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Corsola** (`CORSOLA`) | 53 | — | Hustle *(slot 1, class default)* | Power Gem, Bubblebeam, Earth Power, Recover |
| 2 | **Machamp** (`MACHAMP`) | 53 | — | Guts *(slot 1, class default)* | Brick Break, Vital Throw, Strength, Bulk Up |
| 3 | **Golurk** (`GOLURK`) | 56 | — | Iron Fist *(slot 1, class default)* | Hammer Arm, Shadow Punch, Shadow Ball, Curse |

### PARRY2 — Route 45

**3 Pokémon, Lv. 63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4185](data/trainers/parties.asm#L4185) · Map: [Route45.asm:L206](maps/Route45.asm#L206)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sudowoodo** (`SUDOWOODO`) | 63 | — | Rock Head *(slot 1, class default)* | Stone Edge, Double-Edge, Rock Slide, Stealth Rock |
| 2 | **Electivire** (`ELECTIVIRE`) | 63 | — | Motor Drive *(slot 1, class default)* | Wild Charge, Cross Chop, Thunderpunch, Thunder Wave |
| 3 | **Hitmonlee** (`HITMONLEE`) | 63 | — | Reckless *(slot 1, class default)* | Close Combat, Hi Jump Kick, Mega Kick, Focus Energy |

### PARRY3 — Route 45

**3 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4198](data/trainers/parties.asm#L4198) · Map: [Route45.asm:L148](maps/Route45.asm#L148)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gurdurr** (`GURDURR`) | 43 | — | Guts *(slot 1, class default)* | Brick Break, Dynamicpunch, Hammer Arm, Body Press |
| 2 | **Glimmora** (`GLIMMORA`) | 43 | — | Toxic Debris *(slot 1, class default)* | Rock Slide, Rock Polish, Stealth Rock, Power Gem |
| 3 | **Lucario** (`LUCARIO`) | 43 | — | Adaptability *(slot 1, class default)* | Thunderpunch, Ice Punch, Dragon Pulse, Circle Throw |

### Timothy — Route 45 (`TIMOTHY`)

**4 Pokémon, Lv. 43–44**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4080](data/trainers/parties.asm#L4080) · Map: [Route45.asm:L234](maps/Route45.asm#L234)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Glimmora** (`GLIMMORA`) | 43 | — | Toxic Debris *(slot 1, class default)* | Venoshock, Ancientpower, Rock Slide, Stealth Rock |
| 2 | **Graveler** (`GRAVELER`) | 43 | — | Rock Head *(slot 1, class default)* | Earthquake, Rock Slide, Bulldoze, Stealth Rock |
| 3 | **Camerupt** (`CAMERUPT`) | 43 | — | Solid Rock *(slot 1, class default)* | Flamethrower, Earth Power, Mud Shot, Amnesia |
| 4 | **Golurk** (`GOLURK`) | 44 | — | Iron Fist *(slot 1, class default)* | Shadow Punch, Shadow Ball, Mega Punch, Curse |

### Bailey — Route 46 (`BAILEY`)

**5 Pokémon, Lv. 44**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4096](data/trainers/parties.asm#L4096) · Map: [Route46.asm:L149](maps/Route46.asm#L149)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Growlithe** (`GROWLITHE_HISUIAN`) | 44 | — | Intimidate *(slot 1, class default)* | Crunch, Outrage, Double-Edge, Play Rough |
| 2 | **Clodsire** (`CLODSIRE`) | 44 | — | Poison Point *(slot 1, class default)* | Body Slam, Earthquake, Body Press, Megahorn |
| 3 | **Corsola** (`CORSOLA`) | 44 | — | Hustle *(slot 1, class default)* | Earth Power, Endure, Rock Blast, Heal Bell |
| 4 | **Golem** (`GOLEM`) | 44 | — | Rock Head *(slot 1, class default)* | Iron Defense, Explosion, Hammer Arm, Body Press |
| 5 | **Magcargo** (`MAGCARGO`) | 44 | — | Solid Rock *(slot 1, class default)* | Flamethrower, Stealth Rock, Power Gem, Body Slam |

### Tim — Route 9 (`TIM`)

**3 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4120](data/trainers/parties.asm#L4120) · Map: [Route9.asm:L61](maps/Route9.asm#L61)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Quagsire** (`QUAGSIRE`) | 58 | — | Damp *(slot 1, class default)* | Earthquake, Aqua Tail, Ice Punch, Recover |
| 2 | **Nidoking** (`NIDOKING`) | 58 | — | Poison Point *(slot 1, class default)* | Earthquake, Poison Jab, Megahorn, Sucker Punch |
| 3 | **Nidoqueen** (`NIDOQUEEN`) | 58 | — | Poison Point *(slot 1, class default)* | Earthquake, Poison Jab, Thunderbolt, Ice Punch |

### Noland — Fast Ship Cabins / NNW / NNE / NE (`NOLAND`)

**2 Pokémon, Lv. 54**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4133](data/trainers/parties.asm#L4133) · Map: [FastShipCabins_NNW_NNE_NE.asm:L49](maps/FastShipCabins_NNW_NNE_NE.asm#L49)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golem** (`GOLEM`) | 54 | — | Rock Head *(slot 1, class default)* | Rock Slide, Earthquake, Body Press, Explosion |
| 2 | **Poliwrath** (`POLIWRATH`) | 54 | — | Swift Swim *(slot 1, class default)* | Waterfall, Brick Break, Earthquake, Mach Punch |

### Sidney — Route 9 (`SIDNEY`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4143](data/trainers/parties.asm#L4143) · Map: [Route9.asm:L72](maps/Route9.asm#L72)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golem** (`GOLEM`) | 58 | — | Rock Head *(slot 1, class default)* | Earthquake, Head Smash, Hammer Arm, Iron Head |
| 2 | **Mamoswine** (`MAMOSWINE`) | 58 | — | Thick Fat *(slot 1, class default)* | Earthquake, Icicle Crash, Ice Shard, Ancientpower |

### Kenny — Route 13 (`KENNY`)

**4 Pokémon, Lv. 64–65**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4153](data/trainers/parties.asm#L4153) · Map: [Route13.asm:L58](maps/Route13.asm#L58)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Arcanine** (`ARCANINE_HISUIAN`) | 64 | — | Intimidate *(slot 1, class default)* | Extremespeed, Fire Blast, Rock Slide, Play Rough |
| 2 | **Heracross** (`HERACROSS`) | 64 | — | Guts *(slot 1, class default)* | Close Combat, Megahorn, Earthquake, Aerial Ace |
| 3 | **Hitmonchan** (`HITMONCHAN`) | 65 | — | Iron Fist *(slot 1, class default)* | Close Combat, Ice Punch, Mach Punch, Bullet Punch |
| 4 | **Steelix** (`STEELIX`) | 65 | — | Sand Force *(slot 1, class default)* | Earthquake, Iron Tail, Stone Edge, Body Press |

### Jim — Route 10 South (`JIM`)

**2 Pokémon, Lv. 58–60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4169](data/trainers/parties.asm#L4169) · Map: [Route10South.asm:L11](maps/Route10South.asm#L11)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clodsire** (`CLODSIRE`) | 58 | — | Poison Point *(slot 1, class default)* | Earthquake, Poison Jab, Megahorn, Recover |
| 2 | **Nidoqueen** (`NIDOQUEEN`) | 60 | — | Poison Point *(slot 1, class default)* | Earthquake, Poison Jab, Thunderbolt, Ice Punch |

### Daniel — Union Cave 1F (`DANIEL`)

**1 Pokémon, Lv. 14**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4179](data/trainers/parties.asm#L4179) · Map: [UnionCave1F.asm:L40](maps/UnionCave1F.asm#L40)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wooper** (`WOOPER_PALDEAN`) | 14 | — | Poison Point *(slot 1, class default)* | Toxic Spikes, Tackle, Slam, Poison Jab |


## Biker

> **Group:** `BikerGroup` · **Battle IDs:** `BIKER` · **7 parties**

### Dwayne — Route 8 (`DWAYNE`)

**4 Pokémon, Lv. 62–64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4234](data/trainers/parties.asm#L4234) · Map: [Route8.asm:L15](maps/Route8.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Toxicroak** (`TOXICROAK`) | 62 | — | Dry Skin *(slot 2, class default)* | Gunk Shot, Cross Chop, Strength, Sucker Punch |
| 2 | **Umbreon** (`UMBREON`) | 63 | — | Inner Focus *(slot 2, class default)* | Foul Play, Gunk Shot, Psychic, Moonlight |
| 3 | **Chandelure** (`CHANDELURE`) | 64 | — | Levitate *(slot 2, class default)* | Fire Blast, Shadow Ball, Psychic, Will-O-Wisp |
| 4 | **Arcanine** (`ARCANINE`) | 64 | — | Flash Fire *(slot 2, class default)* | Overheat, Close Combat, Extremespeed, Crunch |

### Harris — Route 8 (`HARRIS`)

**2 Pokémon, Lv. 60–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4250](data/trainers/parties.asm#L4250) · Map: [Route8.asm:L26](maps/Route8.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flareon** (`FLAREON`) | 60 | — | Guts *(slot 2, class default)* | Flare Blitz, Close Combat, Play Rough, Quick Attack |
| 2 | **Golem** (`GOLEM`) | 63 | — | Sturdy *(slot 2, class default)* | Earthquake, Head Smash, Hammer Arm, Iron Head |

### Zeke — Route 8 (`ZEKE`)

**2 Pokémon, Lv. 59–62**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4260](data/trainers/parties.asm#L4260) · Map: [Route8.asm:L37](maps/Route8.asm#L37)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golbat** (`GOLBAT`) | 59 | — | Frisk *(slot 2, class default)* | Brave Bird, Cross Poison, Crunch, Zen Headbutt |
| 2 | **Magmortar** (`MAGMORTAR`) | 62 | — | Flash Fire *(slot 2, class default)* | Overheat, Focus Blast, Will-O-Wisp, Thunderpunch |

### Charles — Route 17 (`CHARLES`)

**3 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4270](data/trainers/parties.asm#L4270) · Map: [Route17.asm:L19](maps/Route17.asm#L19)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weezing** (`WEEZING_GALARIAN`) | 66 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Strangesteam, Fire Blast, Thunderbolt |
| 2 | **Magmar** (`MAGMAR`) | 66 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Psychic, Aura Sphere, Will-O-Wisp |
| 3 | **Armarouge** (`ARMAROUGE`) | 66 | — | Weak Armor *(slot 2, class default)* | Armor Cannon, Flamethrower, Heat Wave, Will-O-Wisp |

### Riley — Route 17 (`RILEY`)

**2 Pokémon, Lv. 66–67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4283](data/trainers/parties.asm#L4283) · Map: [Route17.asm:L30](maps/Route17.asm#L30)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weezing** (`WEEZING`) | 66 | — | Neutralizing Gas *(slot 2, class default)* | Gunk Shot, Fire Blast, Thunderbolt, Dark Pulse |
| 2 | **Houndoom** (`HOUNDOOM`) | 67 | — | Flash Fire *(slot 2, class default)* | Overheat, Foul Play, Sludge Bomb, Sucker Punch |

### Joel — Route 17 (`JOEL`)

**2 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4293](data/trainers/parties.asm#L4293) · Map: [Route17.asm:L41](maps/Route17.asm#L41)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rapidash** (`RAPIDASH`) | 66 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Megahorn, Quick Attack, Iron Tail |
| 2 | **Ariados** (`ARIADOS`) | 66 | — | Sniper *(slot 2, class default)* | Megahorn, Poison Jab, Night Slash, Shadow Sneak |

### Glenn — Route 17 (`GLENN`)

**3 Pokémon, Lv. 65–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4303](data/trainers/parties.asm#L4303) · Map: [Route17.asm:L52](maps/Route17.asm#L52)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowking** (`SLOWKING_GALARIAN`) | 65 | — | Unaware *(slot 2, class default)* | Sludge Bomb, Psychic, Fire Blast, Slack Off |
| 2 | **Arcanine** (`ARCANINE`) | 66 | — | Flash Fire *(slot 2, class default)* | Fire Blast, Extremespeed, Crunch, Iron Tail |
| 3 | **Golem** (`GOLEM_ALOLAN`) | 66 | — | Sturdy *(slot 2, class default)* | Wild Charge, Head Smash, Hammer Arm, Earthquake |


## Blaine

> **Group:** `BlaineGroup` · **Battle IDs:** `BLAINE` · **1 parties**

### Blaine — Seafoam Gym (`BLAINE1`)

**6 Pokémon, Lv. 66–69**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L4319](data/trainers/parties.asm#L4319) · Map: [SeafoamGym.asm:L27](maps/SeafoamGym.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ninetales** (`NINETALES`) | 66 | Charcoal | Drought *(slot 1)* | Flamethrower, Solarbeam, Will-O-Wisp, Nasty Plot |
| 2 | **Arcanine** (`ARCANINE`) | 67 | Life Orb | Intimidate *(slot 1)* | Flare Blitz, Extremespeed, Close Combat, Wild Charge |
| 3 | **Armarouge** (`ARMAROUGE`) | 67 | Wise Glasses | Mega Launcher *(hidden)* | Armor Cannon, Psychic, Aura Sphere, Calm Mind |
| 4 | **Torkoal** (`TORKOAL`) | 68 | Leftovers | Drought *(slot 1)* | Flamethrower, Solarbeam, Earth Power, Body Press |
| 5 | **Rapidash** (`RAPIDASH`) | 68 | Life Orb | Reckless *(hidden)* | Flare Blitz, Double-Edge, Wild Charge, Megahorn |
| 6 | **Magmortar** (`MAGMORTAR`) | 69 | Life Orb | Flash Fire *(slot 2)* | Fire Blast, Thunderbolt, Focus Blast, Solarbeam |


## Burglar

> **Group:** `BurglarGroup` · **Battle IDs:** `BURGLAR` · **5 parties**

### Duncan — Goldenrod Underground Switch Room Entrances (`DUNCAN`)

**2 Pokémon, Lv. 38**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L4356](data/trainers/parties.asm#L4356) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L234](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L234)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sneasel** (`SNEASEL`) | 38 | — | Technician *(slot 1)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |
| 2 | **Persian** (`PERSIAN`) | 38 | — | Super Luck *(hidden)* | Power Gem, Crush Claw, Hypnosis, Nasty Plot |

### Eddie — Goldenrod Underground Switch Room Entrances (`EDDIE`)

**2 Pokémon, Lv. 38**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4366](data/trainers/parties.asm#L4366) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L245](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L245)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Nidorina** (`NIDORINA`) | 38 | — | Rivalry *(slot 2, class default)* | Poison Jab, Crunch, Poison Fang, Toxic Spikes |
| 2 | **Murkrow** (`MURKROW`) | 38 | — | Insomnia *(slot 2, class default)* | Drill Peck, Faint Attack, Wing Attack, Dark Pulse |

### Corey — Fast Ship Cabins / NNW / NNE / NE (`COREY`)

**4 Pokémon, Lv. 49–53**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4376](data/trainers/parties.asm#L4376) · Map: [FastShipCabins_NNW_NNE_NE.asm:L71](maps/FastShipCabins_NNW_NNE_NE.asm#L71)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Crobat** (`CROBAT`) | 49 | — | Frisk *(slot 2, class default)* | Brave Bird, Cross Poison, Crunch, Zen Headbutt |
| 2 | **Ninetales** (`NINETALES`) | 49 | — | Flash Fire *(slot 2, class default)* | Overheat, Dark Pulse, Extrasensory, Quick Attack |
| 3 | **Magcargo** (`MAGCARGO`) | 51 | — | Flame Body *(slot 2, class default)* | Overheat, Power Gem, Earth Power, Recover |
| 4 | **Houndoom** (`HOUNDOOM`) | 53 | — | Flash Fire *(slot 2, class default)* | Overheat, Foul Play, Sludge Bomb, Sucker Punch |

### Morton — Seafoam Gym (`MORTON`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4392](data/trainers/parties.asm#L4392) · Map: [SeafoamGym.asm:L68](maps/SeafoamGym.asm#L68)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magcargo** (`MAGCARGO`) | 68 | — | Flame Body *(slot 2, class default)* | Overheat, Power Gem, Earth Power, Amnesia |
| 2 | **Marowak** (`MAROWAK_ALOLAN`) | 68 | — | Lightning Rod *(slot 2, class default)* | Flare Blitz, Phantomforce, Earthquake, Swords Dance |
| 3 | **Ponyta** (`PONYTA`) | 68 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Iron Tail, Agility, Stomp |

### Vance — Seafoam Gym (`VANCE`)

**3 Pokémon, Lv. 68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4405](data/trainers/parties.asm#L4405) · Map: [SeafoamGym.asm:L79](maps/SeafoamGym.asm#L79)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Magmar** (`MAGMAR`) | 68 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Psychic, Aura Sphere, Will-O-Wisp |
| 2 | **Typhlosion** (`TYPHLOSION_HISUIAN`) | 68 | — | Berserk *(slot 2, class default)* | Fire Blast, Shadow Ball, Extrasensory, Calm Mind |
| 3 | **Flareon** (`FLAREON`) | 68 | — | Guts *(slot 2, class default)* | Flare Blitz, Close Combat, Play Rough, Quick Attack |


## Firebreather

> **Group:** `FirebreatherGroup` · **Battle IDs:** `FIREBREATHER` · **8 parties**

### Otis — Route 3 (`OTIS`)

**3 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4421](data/trainers/parties.asm#L4421) · Map: [Route3.asm:L15](maps/Route3.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Arcanine** (`ARCANINE`) | 69 | — | Flash Fire *(slot 2, class default)* | Fire Blast, Extremespeed, Crunch, Iron Tail |
| 2 | **Ceruledge** (`CERULEDGE`) | 69 | — | Weak Armor *(slot 2, class default)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 3 | **Magmar** (`MAGMAR`) | 69 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Psychic, Will-O-Wisp, Cross Chop |

### Burt — Route 3 (`BURT`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4434](data/trainers/parties.asm#L4434) · Map: [Route3.asm:L48](maps/Route3.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flareon** (`FLAREON`) | 69 | — | Guts *(slot 2, class default)* | Flare Blitz, Close Combat, Play Rough, Quick Attack |
| 2 | **Magcargo** (`MAGCARGO`) | 69 | — | Flame Body *(slot 2, class default)* | Overheat, Power Gem, Earth Power, Recover |

### Bill — Union Cave 1F (`BILL`)

**1 Pokémon, Lv. 14**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4444](data/trainers/parties.asm#L4444) · Map: [UnionCave1F.asm:L51](maps/UnionCave1F.asm#L51)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slugma** (`SLUGMA`) | 14 | — | Flame Body *(slot 2, class default)* | Smog, Rock Throw, Ember, Harden |

### Walt — Route 35 (`WALT`)

**2 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4450](data/trainers/parties.asm#L4450) · Map: [Route35.asm:L227](maps/Route35.asm#L227)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndour** (`HOUNDOUR`) | 20 | — | Flash Fire *(slot 2, class default)* | Roar, Smog, Thunder Fang, Fire Fang |
| 2 | **Slugma** (`SLUGMA`) | 20 | — | Flame Body *(slot 2, class default)* | Harden, Will-O-Wisp, Ancientpower, Rock Tomb |

### Ray — Union Cave 1F (`RAY`)

**1 Pokémon, Lv. 12**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4458](data/trainers/parties.asm#L4458) · Map: [UnionCave1F.asm:L62](maps/UnionCave1F.asm#L62)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vulpix** (`VULPIX`) | 12 | — | Flash Fire *(slot 2, class default)* | Roar, Quick Attack, Confuse Ray, Spite |

### Lyle — Fast Ship Cabins / SW / SSW / NW (`LYLE`)

**3 Pokémon, Lv. 53**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4464](data/trainers/parties.asm#L4464) · Map: [FastShipCabins_SW_SSW_NW.asm:L13](maps/FastShipCabins_SW_SSW_NW.asm#L13)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tauros** (`TAUROS_PALDEAN_FIRE`) | 53 | — | Anger Point *(slot 2, class default)* | Flare Blitz, Earthquake, Megahorn, Aqua Jet |
| 2 | **Chandelure** (`CHANDELURE`) | 53 | — | Levitate *(slot 2, class default)* | Fire Blast, Shadow Ball, Psychic, Will-O-Wisp |
| 3 | **Salazzle** (`SALAZZLE`) | 53 | — | Poison Puppeteer *(slot 2, class default)* | Overheat, Sludge Bomb, Dragon Pulse, Shadow Ball |

### Scorch — Seafoam Gym (`SCORCH`)

**4 Pokémon, Lv. 68–69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4477](data/trainers/parties.asm#L4477) · Map: [SeafoamGym.asm:L90](maps/SeafoamGym.asm#L90)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Armarouge** (`ARMAROUGE`) | 68 | — | Weak Armor *(slot 2, class default)* | Armor Cannon, Overheat, Flamethrower, Calm Mind |
| 2 | **Magmortar** (`MAGMORTAR`) | 68 | — | Flash Fire *(slot 2, class default)* | Overheat, Focus Blast, Will-O-Wisp, Thunderpunch |
| 3 | **Ninetales** (`NINETALES`) | 68 | — | Flash Fire *(slot 2, class default)* | Overheat, Moonblast, Dark Pulse, Nasty Plot |
| 4 | **Arcanine** (`ARCANINE`) | 69 | — | Flash Fire *(slot 2, class default)* | Overheat, Close Combat, Crunch, Agility |

### Blaze — Seafoam Gym (`TORCH`)

**4 Pokémon, Lv. 68–69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4493](data/trainers/parties.asm#L4493) · Map: [SeafoamGym.asm:L101](maps/SeafoamGym.asm#L101)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Torkoal** (`TORKOAL`) | 68 | — | White Smoke *(slot 2, class default)* | Overheat, Earthquake, Iron Head, Amnesia |
| 2 | **Talonflame** (`TALONFLAME`) | 68 | — | Flame Body *(slot 2, class default)* | Flare Blitz, Aerial Ace, Agility, Quick Attack |
| 3 | **Magmar** (`MAGMAR`) | 68 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Psychic, Will-O-Wisp, Cross Chop |
| 4 | **Rapidash** (`RAPIDASH`) | 69 | — | Flash Fire *(slot 2, class default)* | Flare Blitz, Megahorn, Agility, Quick Attack |


## Juggler

> **Group:** `JugglerGroup` · **Battle IDs:** `JUGGLER` · **9 parties**


### IRWIN1 — Route 35

**3 Pokémon, Lv. 21**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4512](data/trainers/parties.asm#L4512) · Map: [Route35.asm:L31](maps/Route35.asm#L31)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Abra** (`ABRA`) | 21 | — | Synchronize *(slot 2, class default)* | Teleport |
| 2 | **Magnemite** (`MAGNEMITE`) | 21 | — | Analytic *(slot 2, class default)* | Supersonic, Thunder Wave, Spark, Light Screen |
| 3 | **Litwick** (`LITWICK`) | 21 | — | Flame Body *(slot 2, class default)* | Confuse Ray, Night Shade, Will-O-Wisp, Flame Wheel |

### IRWIN2 — Route 35 (rematch)

**3 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4551](data/trainers/parties.asm#L4551) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Drifloon** (`DRIFLOON`) | 43 | — | Unburden *(slot 2, class default)* | Hypnosis, Baton Pass, Phantomforce, Hurricane |
| 2 | **Elekid** (`ELEKID`) | 43 | — | Vital Spirit *(slot 2, class default)* | Cross Chop, Thunderbolt, Wild Charge, Close Combat |
| 3 | **Spoink** (`SPOINK`) | 43 | — | Own Tempo *(slot 2, class default)* | Snore, Sleep Talk, Psychic, Future Sight |

### IRWIN3 — Route 35 (rematch)

**4 Pokémon, Lv. 52–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4561](data/trainers/parties.asm#L4561) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wobbuffet** (`WOBBUFFET`) | 52 | — | Shadow Tag *(slot 2, class default)* | Counter, Mirror Coat, Amnesia, Encore |
| 2 | **Tinkatuff** (`TINKATUFF`) | 54 | — | Own Tempo *(slot 2, class default)* | Metal Claw, Slam, Drain Kiss, Rock Smash |
| 3 | **Jynx** (`JYNX`) | 55 | — | Forewarn *(slot 2, class default)* | Extrasensory, Icy Wind, Confusion, Ice Punch |
| 4 | **Girafarig** (`GIRAFARIG`) | 56 | — | Contrary *(slot 2, class default)* | Psybeam, Confusion, Stomp, Agility |

### IRWIN4 — Route 35 (rematch)

**4 Pokémon, Lv. 58–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4577](data/trainers/parties.asm#L4577) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Elekid** (`ELEKID`) | 58 | — | Vital Spirit *(slot 2, class default)* | Thunderbolt, Wild Charge, Close Combat, Thunder |
| 2 | **Flaaffy** (`FLAAFFY`) | 58 | — | Fluffy *(slot 2, class default)* | Light Screen, Dazzle Gleam, Heal Bell, Thunder |
| 3 | **Jigglypuff** (`JIGGLYPUFF`) | 58 | — | Competitive *(slot 2, class default)* | Gyro Ball, Mimic, Double-Edge, Play Rough |
| 4 | **Ponyta** (`PONYTA_GALARIAN`) | 63 | — | Pastel Veil *(slot 2, class default)* | Flamethrower, Play Rough, Psychic, Flare Blitz |

### Fritz — Fast Ship B1F (`FRITZ`)

**3 Pokémon, Lv. 52–54**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4522](data/trainers/parties.asm#L4522) · Map: [FastShipB1F.asm:L117](maps/FastShipB1F.asm#L117)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gorotora** (`GOROTORA`) | 52 | — | Intimidate *(slot 2, class default)* | Extremespeed, Thunderbolt, Earthquake, Quick Attack |
| 2 | **Noctowl** (`NOCTOWL`) | 52 | — | Insomnia *(slot 2, class default)* | Psychic, Hurricane, Moonblast, Roost |
| 3 | **Espeon** (`ESPEON`) | 54 | — | Synchronize *(slot 2, class default)* | Psychic, Power Gem, Shadow Ball, Morning Sun |

### Horton — Vermilion Gym (`HORTON`)

**4 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4535](data/trainers/parties.asm#L4535) · Map: [VermilionGym.asm:L68](maps/VermilionGym.asm#L68)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Electivire** (`ELECTIVIRE`) | 58 | — | Sheer Force *(slot 2, class default)* | Close Combat, Wild Charge, Quick Attack, Thunder Wave |
| 2 | **Ampharos** (`AMPHAROS`) | 58 | — | Mold Breaker *(slot 2, class default)* | Thunderbolt, Dragon Pulse, Dazzle Gleam, Thunder Wave |
| 3 | **Gorotora** (`GOROTORA`) | 58 | — | Intimidate *(slot 2, class default)* | Extremespeed, Thunderbolt, Earthquake, Agility |
| 4 | **Lanturn** (`LANTURN`) | 58 | — | Water Absorb *(slot 2, class default)* | Hydro Pump, Thunderbolt, Signal Beam, Thunder Wave |

### Marco — Route 9 (`MARCO`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4589](data/trainers/parties.asm#L4589) · Map: [Route9.asm:L83](maps/Route9.asm#L83)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Espeon** (`ESPEON`) | 58 | — | Synchronize *(slot 2, class default)* | Psychic, Power Gem, Aura Sphere, Morning Sun |
| 2 | **Clefable** (`CLEFABLE`) | 58 | — | Magic Guard *(slot 2, class default)* | Moonblast, Fire Blast, Ice Beam, Moonlight |

### Leon — Route 9 (`LEON`)

**3 Pokémon, Lv. 58–60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4599](data/trainers/parties.asm#L4599) · Map: [Route9.asm:L94](maps/Route9.asm#L94)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 58 | — | Early Bird *(slot 2, class default)* | Psychic, Hurricane, Signal Beam, Roost |
| 2 | **Rapidash** (`RAPIDASH_GALARIAN`) | 58 | — | Pastel Veil *(slot 2, class default)* | Flare Blitz, Play Rough, Megahorn, Quick Attack |
| 3 | **Wigglytuff** (`WIGGLYTUFF`) | 60 | — | Competitive *(slot 2, class default)* | Hyper Voice, Drain Kiss, Fire Blast, Ice Beam |

### Silas — Route 25 (Nugget Bridge 2) (`SILAS`)

**3 Pokémon, Lv. 59–60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4612](data/trainers/parties.asm#L4612) · Map: [Route25.asm:L426](maps/Route25.asm#L426)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Starmie** (`STARMIE`) | 59 | — | Analytic *(slot 2, class default)* | Surf, Psychic, Thunderbolt, Recover |
| 2 | **Golduck** (`GOLDUCK`) | 59 | — | Cloud Nine *(slot 2, class default)* | Hydro Pump, Psychic, Ice Beam, Aqua Jet |
| 3 | **Chandelure** (`CHANDELURE`) | 60 | — | Levitate *(slot 2, class default)* | Fire Blast, Shadow Ball, Psychic, Will-O-Wisp |


## Blackbelt

> **Group:** `BlackbeltGroup` · **Battle IDs:** `BLACKBELT_T` · **9 parties**


### KENJI1 — Route 45 (rematch)

**4 Pokémon, Lv. 52–56**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L4628](data/trainers/parties.asm#L4628) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hitmonlee** (`HITMONLEE`) | 52 | — | Reckless *(slot 1)* | Close Combat, Hi Jump Kick, Sucker Punch, Superpower |
| 2 | **Hitmonchan** (`HITMONCHAN`) | 52 | — | Iron Fist *(slot 1)* | Drain Punch, Ice Punch, Thunderpunch, Bullet Punch |
| 3 | **Heracross** (`HERACROSS`) | 54 | — | Moxie *(hidden)* | Megahorn, Brick Break, Low Sweep, Work Up |
| 4 | **Hitmontop** (`HITMONTOP`) | 56 | — | Intimidate *(slot 2)* | Close Combat, Brick Break, Sucker Punch, Agility |

### KENJI2 — Route 45 (rematch)

**4 Pokémon, Lv. 58–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4655](data/trainers/parties.asm#L4655) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Primeape** (`PRIMEAPE`) | 58 | — | Anger Point *(slot 2, class default)* | Cross Chop, Brick Break, Skull Bash, Work Up |
| 2 | **Sneasel** (`SNEASEL_HISUIAN`) | 58 | — | Poison Touch *(slot 2, class default)* | Poison Jab, Drain Punch, Poison Fang, Screech |
| 3 | **Lucario** (`LUCARIO`) | 60 | — | Inner Focus *(slot 2, class default)* | Aura Sphere, Brick Break, Crunch, Calm Mind |
| 4 | **Scrafty** (`SCRAFTY`) | 63 | — | Moxie *(slot 2, class default)* | Brick Break, Low Sweep, Facade, Protect |

### KENJI3 — Route 45

**4 Pokémon, Lv. 39–43**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L4714](data/trainers/parties.asm#L4714) · Map: [Route45.asm:L22](maps/Route45.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Heracross** (`HERACROSS`) | 39 | — | Moxie *(hidden)* | Brick Break, Low Sweep, Bug Bite, Work Up |
| 2 | **Primeape** (`PRIMEAPE`) | 39 | — | Defiant *(hidden)* | Close Combat, Cross Chop, Night Slash, Ice Punch |
| 3 | **Hitmontop** (`HITMONTOP`) | 41 | — | Intimidate *(slot 2)* | Close Combat, Brick Break, Sucker Punch, Agility |
| 4 | **Gurdurr** (`GURDURR`) | 43 | — | Guts *(slot 1)* | Hammer Arm, Brick Break, Rock Slide, Bulk Up |

### Yoshi — Cianwood Gym (`YOSHI`)

**1 Pokémon, Lv. 30**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4648](data/trainers/parties.asm#L4648) · Map: [CianwoodGym.asm:L104](maps/CianwoodGym.asm#L104)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mankey** (`MANKEY`) | 30 | — | Anger Point *(slot 2, class default)* | Cross Chop, Brick Break, Skull Bash, Focus Energy |

### Lao — Cianwood Gym (`LAO`)

**1 Pokémon, Lv. 30**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4671](data/trainers/parties.asm#L4671) · Map: [CianwoodGym.asm:L115](maps/CianwoodGym.asm#L115)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hitmontop** (`HITMONTOP`) | 30 | — | Intimidate *(slot 2, class default)* | Low Sweep, Rolling Kick, Sucker Punch, Agility |

### Nob — Cianwood Gym (`NOB`)

**2 Pokémon, Lv. 28**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4678](data/trainers/parties.asm#L4678) · Map: [CianwoodGym.asm:L126](maps/CianwoodGym.asm#L126)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Machoke** (`MACHOKE`) | 28 | — | No Guard *(slot 2, class default)* | Vital Throw, Low Sweep, Strength, Work Up |
| 2 | **Breloom** (`BRELOOM`) | 28 | — | Poison Heal *(slot 2, class default)* | Seed Bomb, Low Sweep, Headbutt, Spore |

### Kiyo — Mount Mortar B1F (`KIYO`)

**2 Pokémon, Lv. 32**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4688](data/trainers/parties.asm#L4688) · Map: [MountMortarB1F.asm:L26](maps/MountMortarB1F.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Croagunk** (`CROAGUNK`) | 32 | — | Dry Skin *(slot 2, class default)* | Low Sweep, Force Palm, Venoshock, Low Kick |
| 2 | **Gurdurr** (`GURDURR`) | 32 | — | Sheer Force *(slot 2, class default)* | Low Sweep, Rock Slide, Low Kick, Bulk Up |

### Lung — Cianwood Gym (`LUNG`)

**3 Pokémon, Lv. 28**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L4698](data/trainers/parties.asm#L4698) · Map: [CianwoodGym.asm:L137](maps/CianwoodGym.asm#L137)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gurdurr** (`GURDURR`) | 28 | — | Guts *(slot 1)* | Low Sweep, Force Palm, Rock Slide, Bulk Up |
| 2 | **Hitmontop** (`HITMONTOP`) | 28 | — | Intimidate *(slot 2)* | Low Sweep, Rolling Kick, Sucker Punch, Agility |
| 3 | **Machoke** (`MACHOKE`) | 28 | — | Guts *(slot 1)* | Vital Throw, Low Sweep, Knock Off, Work Up |

### Wai — Fast Ship B1F (`WAI`)

**3 Pokémon, Lv. 52–56**  
*custom moves, explicit abilities*  
<sub>Source: [parties.asm:L4734](data/trainers/parties.asm#L4734) · Map: [FastShipB1F.asm:L150](maps/FastShipB1F.asm#L150)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hitmontop** (`HITMONTOP`) | 52 | — | Intimidate *(slot 2)* | Close Combat, Body Press, Sucker Punch, Agility |
| 2 | **Lucario** (`LUCARIO`) | 54 | — | Adaptability *(slot 1)* | Aura Sphere, Close Combat, Dragon Pulse, Calm Mind |
| 3 | **Hitmonlee** (`HITMONLEE`) | 56 | — | Reckless *(slot 1)* | Hi Jump Kick, Close Combat, Sucker Punch, Stone Edge |


## Team Rocket Executive M

> **Group:** `ExecutiveMGroup` · **Battle IDs:** `EXECUTIVEM` · **4 parties**


### EXECUTIVEM_1 — Not placed on any map

**5 Pokémon, Lv. 31–33**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4758](data/trainers/parties.asm#L4758) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Skarmory** (`SKARMORY`) | 31 | — | Sturdy *(slot 2, class default)* | Drill Peck, Steel Wing, Wing Attack, Agility |
| 2 | **Murkrow** (`MURKROW`) | 31 | — | Insomnia *(slot 2, class default)* | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| 3 | **Machoke** (`MACHOKE`) | 32 | — | No Guard *(slot 2, class default)* | Brick Break, Vital Throw, Strength, Work Up |
| 4 | **Gloom** (`GLOOM`) | 32 | — | Poison Puppeteer *(slot 2, class default)* | Sludge, Giga Drain, Mega Drain, Toxic |
| 5 | **Tinkatuff** (`TINKATUFF`) | 33 | — | Own Tempo *(slot 2, class default)* | Play Rough, Flash Cannon, Metal Claw, Iron Defense |

### EXECUTIVEM_2 — Not placed on any map

**4 Pokémon, Lv. 31–32**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4777](data/trainers/parties.asm#L4777) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Heracross** (`HERACROSS`) | 31 | — | Skill Link *(slot 2, class default)* | Brick Break, Low Sweep, Bug Bite, Work Up |
| 2 | **Gurdurr** (`GURDURR`) | 31 | — | Sheer Force *(slot 2, class default)* | Brick Break, Low Sweep, Rock Slide, Bulk Up |
| 3 | **Murkrow** (`MURKROW`) | 31 | — | Insomnia *(slot 2, class default)* | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| 4 | **Glimmet** (`GLIMMET`) | 32 | — | Corrosion *(slot 2, class default)* | Venoshock, Ancientpower, Rock Slide, Stealth Rock |

### EXECUTIVEM_3 — Not placed on any map

**5 Pokémon, Lv. 29–31**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4793](data/trainers/parties.asm#L4793) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Murkrow** (`MURKROW`) | 29 | — | Insomnia *(slot 2, class default)* | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| 2 | **Scolipede** (`SCOLIPEDE`) | 29 | — | Swarm *(slot 2, class default)* | Bug Bite, Poison Fang, Venoshock, Protect |
| 3 | **Farfetch'd** (`FARFETCH_D`) | 30 | — | Keen Eye *(slot 2, class default)* | Leaf Blade, Aerial Ace, Poison Jab, Swords Dance |
| 4 | **Sneasel** (`SNEASEL`) | 30 | — | Inner Focus *(slot 2, class default)* | Faint Attack, Crush Claw, Slash, Agility |
| 5 | **Clodsire** (`CLODSIRE`) | 31 | — | Water Absorb *(slot 2, class default)* | Poison Jab, Bulldoze, Body Slam, Toxic Spikes |

### EXECUTIVEM_4 — Not placed on any map

**4 Pokémon, Lv. 23–24**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4812](data/trainers/parties.asm#L4812) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Misdreavus** (`MISDREAVUS`) | 23 | — | Levitate *(slot 2, class default)* | Hex, Drain Kiss, Psybeam, Confuse Ray |
| 2 | **Koffing** (`KOFFING`) | 24 | — | Neutralizing Gas *(slot 2, class default)* | Selfdestruct, Sludge, Tackle, Smog |
| 3 | **Grimer** (`GRIMER_ALOLAN`) | 24 | — | Gluttony *(slot 2, class default)* | Bite, Poison Fang, Shadow Sneak, Curse |
| 4 | **Drifloon** (`DRIFLOON`) | 24 | — | Unburden *(slot 2, class default)* | Shadow Ball, Hex, Gust, Focus Energy |


## Psychic

> **Group:** `PsychicGroup` · **Battle IDs:** `PSYCHIC_T` · **12 parties**

### Nathan — Ruins of Alph Outside (`NATHAN`)

**1 Pokémon, Lv. 23**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4831](data/trainers/parties.asm#L4831) · Map: [RuinsOfAlphOutside.asm:L103](maps/RuinsOfAlphOutside.asm#L103)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Smoochum** (`SMOOCHUM`) | 23 | — | Forewarn *(slot 2, class default)* | Extrasensory, Icy Wind, Confusion, Powder Snow |

### Franklin — Saffron Gym (`FRANKLIN`)

**3 Pokémon, Lv. 64–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4838](data/trainers/parties.asm#L4838) · Map: [SaffronGym.asm:L59](maps/SaffronGym.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowbro** (`SLOWBRO_GALARIAN`) | 64 | — | Unaware *(slot 2, class default)* | Zen Headbutt, Shellsidearm, Sludge Bomb, Slack Off |
| 2 | **Hypno** (`HYPNO`) | 66 | — | No Guard *(slot 2, class default)* | Zen Headbutt, Psycho Cut, Drain Punch, Nasty Plot |
| 3 | **Exeggutor** (`EXEGGUTOR`) | 66 | — | Chlorophyll *(slot 2, class default)* | Leaf Storm, Energy Ball, Extrasensory, Synthesis |

### Herman — Route 11 (`HERMAN`)

**3 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4851](data/trainers/parties.asm#L4851) · Map: [Route11.asm:L36](maps/Route11.asm#L36)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Alakazam** (`ALAKAZAM`) | 58 | — | Synchronize *(slot 2, class default)* | Psychic, Future Sight, Focus Blast, Calm Mind |
| 2 | **Armarouge** (`ARMAROUGE`) | 58 | — | Weak Armor *(slot 2, class default)* | Armor Cannon, Flamethrower, Night Shade, Calm Mind |
| 3 | **Exeggutor** (`EXEGGUTOR`) | 58 | — | Chlorophyll *(slot 2, class default)* | Leaf Storm, Energy Ball, Extrasensory, Synthesis |

### Fidel — Route 11 (`FIDEL`)

**3 Pokémon, Lv. 54–58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4864](data/trainers/parties.asm#L4864) · Map: [Route11.asm:L47](maps/Route11.asm#L47)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Noctowl** (`NOCTOWL`) | 54 | — | Insomnia *(slot 2, class default)* | Dream Eater, Psychic, Air Slash, Roost |
| 2 | **Alakazam** (`ALAKAZAM`) | 56 | — | Synchronize *(slot 2, class default)* | Psychic, Future Sight, Aura Sphere, Calm Mind |
| 3 | **Dragapult** (`DRAGAPULT`) | 58 | — | Infiltrator *(slot 2, class default)* | Dragon Darts, Dragon Tail, Take Down, Dragon Dance |

### Greg — Route 37 (`GREG`)

**1 Pokémon, Lv. 25**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4877](data/trainers/parties.asm#L4877) · Map: [Route37.asm:L49](maps/Route37.asm#L49)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clefairy** (`CLEFAIRY`) | 25 | — | Magic Guard *(slot 2, class default)* | Drain Kiss, Disarm Voice, Pound, Encore |

### Norman — Route 39 (`NORMAN`)

**2 Pokémon, Lv. 27–28**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4884](data/trainers/parties.asm#L4884) · Map: [Route39.asm:L128](maps/Route39.asm#L128)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clefairy** (`CLEFAIRY`) | 27 | — | Magic Guard *(slot 2, class default)* | Drain Kiss, Disarm Voice, Body Slam, Encore |
| 2 | **Misdreavus** (`MISDREAVUS`) | 28 | — | Levitate *(slot 2, class default)* | Hex, Drain Kiss, Psybeam, Confuse Ray |

### Mark — Route 36 (`MARK`)

**3 Pokémon, Lv. 20–21**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4894](data/trainers/parties.asm#L4894) · Map: [Route36.asm:L308](maps/Route36.asm#L308)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kirlia** (`KIRLIA`) | 20 | — | Trace *(slot 2, class default)* | Psybeam, Drain Kiss, Confusion, Double Team |
| 2 | **Gastly** (`GASTLY`) | 20 | — | Cursed Body *(slot 2, class default)* | Hex, Night Shade, Smog, Curse |
| 3 | **Abra** (`ABRA`) | 21 | — | Synchronize *(slot 2, class default)* | Teleport |

### Phil — Route 44 (`PHIL`)

**3 Pokémon, Lv. 40**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4907](data/trainers/parties.asm#L4907) · Map: [Route44.asm:L153](maps/Route44.asm#L153)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ninetales** (`NINETALES`) | 40 | — | Flash Fire *(slot 2, class default)* | Hex, Ember, Faint Attack, Nasty Plot |
| 2 | **Wobbuffet** (`WOBBUFFET`) | 40 | — | Shadow Tag *(slot 2, class default)* | Counter, Mirror Coat, Amnesia, Encore |
| 3 | **Alakazam** (`ALAKAZAM`) | 40 | — | Synchronize *(slot 2, class default)* | Psybeam, Confusion, Night Shade, Recover |

### Richard — Route 26 (`RICHARD`)

**3 Pokémon, Lv. 48**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4920](data/trainers/parties.asm#L4920) · Map: [Route26.asm:L225](maps/Route26.asm#L225)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Altaria** (`ALTARIA`) | 48 | — | Natural Cure *(slot 2, class default)* | Moonblast, Dragon Pulse, Dragon Tail, Dragon Dance |
| 2 | **Togekiss** (`TOGEKISS`) | 48 | — | Serene Grace *(slot 2, class default)* | Air Slash, Drain Kiss, Tri Attack, Softboiled |
| 3 | **Mimikyu** (`MIMIKYU`) | 48 | — | Disguise *(slot 2, class default)* | Shadow Claw, Foul Play, Phantomforce, Hone Claws |

### Gilbert — Route 27 (`GILBERT`)

**3 Pokémon, Lv. 44–46**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4933](data/trainers/parties.asm#L4933) · Map: [Route27.asm:L50](maps/Route27.asm#L50)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Granbull** (`GRANBULL`) | 44 | — | Quick Feet *(slot 2, class default)* | Play Rough, Close Combat, Outrage, Work Up |
| 2 | **Wobbuffet** (`WOBBUFFET`) | 46 | — | Shadow Tag *(slot 2, class default)* | Counter, Mirror Coat, Amnesia, Encore |
| 3 | **Misdreavus** (`MISDREAVUS`) | 46 | — | Levitate *(slot 2, class default)* | Moonblast, Shadow Ball, Hex, Hypnosis |

### Jared — Saffron Gym (`JARED`)

**3 Pokémon, Lv. 65**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4946](data/trainers/parties.asm#L4946) · Map: [SaffronGym.asm:L81](maps/SaffronGym.asm#L81)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Noctowl** (`NOCTOWL`) | 65 | — | Insomnia *(slot 2, class default)* | Dream Eater, Psychic, Hurricane, Roost |
| 2 | **Exeggutor** (`EXEGGUTOR`) | 65 | — | Chlorophyll *(slot 2, class default)* | Leaf Storm, Energy Ball, Extrasensory, Synthesis |
| 3 | **Slowbro** (`SLOWBRO`) | 65 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Future Sight, Slack Off |

### Rodney — Fast Ship Cabins / SE / SSE / Captain's Cabin (`RODNEY`)

**3 Pokémon, Lv. 51–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4959](data/trainers/parties.asm#L4959) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L175](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L175)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gardevoir** (`GARDEVOIR`) | 51 | — | Trace *(slot 2, class default)* | Moonblast, Psychic, Dazzle Gleam, Calm Mind |
| 2 | **Granbull** (`GRANBULL`) | 51 | — | Quick Feet *(slot 2, class default)* | Play Rough, Double-Edge, Close Combat, Work Up |
| 3 | **Noctowl** (`NOCTOWL`) | 55 | — | Insomnia *(slot 2, class default)* | Dream Eater, Psychic, Hurricane, Roost |


## Picnicker

> **Group:** `PicnickerGroup` · **Battle IDs:** `PICNICKER` · **19 parties**


### LIZ1 — Route 32

**1 Pokémon, Lv. 13**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4975](data/trainers/parties.asm#L4975) · Map: [Route32.asm:L303](maps/Route32.asm#L303)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rattata** (`RATTATA_ALOLAN`) | 13 | — | Hustle *(slot 1, class default)* | Bite, Focus Energy, Aerial Ace, Pursuit |

### LIZ2 — Route 32

**2 Pokémon, Lv. 23–24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5026](data/trainers/parties.asm#L5026) · Map: [Route32.asm:L361](maps/Route32.asm#L361)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowpoke** (`SLOWPOKE`) | 23 | — | Oblivious *(slot 1, class default)* | Disable, Headbutt, Water Pulse, Zen Headbutt |
| 2 | **Togetic** (`TOGETIC`) | 24 | — | Super Luck *(slot 1, class default)* | Encore, Drain Kiss, Safeguard, Ancientpower |

### LIZ3 — Route 32

**3 Pokémon, Lv. 37–38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5034](data/trainers/parties.asm#L5034) · Map: [Route32.asm:L369](maps/Route32.asm#L369)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Staryu** (`STARYU`) | 37 | — | Natural Cure *(slot 1, class default)* | Power Gem, Psychic, Confuse Ray, Light Screen |
| 2 | **Yanma** (`YANMA`) | 37 | — | Speed Boost *(slot 1, class default)* | Dualwingbeat, Ancientpower, Hypnosis, Signal Beam |
| 3 | **Remoraid** (`REMORAID`) | 38 | — | Hustle *(slot 1, class default)* | Water Pulse, Ice Beam, Seed Bomb, Flamethrower |

### LIZ4 — Route 32

**3 Pokémon, Lv. 41–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5106](data/trainers/parties.asm#L5106) · Map: [Route32.asm:L377](maps/Route32.asm#L377)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Snubbull** (`SNUBBULL`) | 41 | — | Intimidate *(slot 1, class default)* | Crunch, Super Fang, Close Combat, Heal Bell |
| 2 | **Morgrem** (`MORGREM`) | 43 | — | Prankster *(slot 1, class default)* | Snarl, Foul Play, Dark Pulse, Nasty Plot |
| 3 | **Octillery** (`OCTILLERY`) | 43 | — | Suction Cups *(slot 1, class default)* | Octazooka, Ice Beam, Seed Bomb, Flamethrower |

### LIZ5 — Route 32

**3 Pokémon, Lv. 53–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5116](data/trainers/parties.asm#L5116) · Map: [Route32.asm:L385](maps/Route32.asm#L385)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Bellossom** (`BELLOSSOM`) | 53 | — | Chlorophyll *(slot 1, class default)* | Petal Dance, Moonblast, Earth Power, Toxic |
| 2 | **Flapple** (`FLAPPLE`) | 55 | — | Ripen *(slot 1, class default)* | Grav Apple, Dragon Pulse, Wing Attack, Dragon Dance |
| 3 | **Ledian** (`LEDIAN`) | 56 | — | Technician *(slot 1, class default)* | Close Combat, Double-Edge, U-Turn, Quiver Dance |


### GINA1 — Route 34

**2 Pokémon, Lv. 18**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4981](data/trainers/parties.asm#L4981) · Map: [Route34.asm:L214](maps/Route34.asm#L214)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rattata** (`RATTATA`) | 18 | — | Hustle *(slot 1, class default)* | Focus Energy, Pursuit, Take Down, Hyper Fang |
| 2 | **Meowth** (`MEOWTH`) | 18 | — | Technician *(slot 1, class default)* | Bite, Fury Swipes, Screech, Pay Day |

### GINA2 — Route 34

**3 Pokémon, Lv. 35–37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5004](data/trainers/parties.asm#L5004) · Map: [Route34.asm:L274](maps/Route34.asm#L274)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Aipom** (`AIPOM`) | 35 | — | Run Away *(slot 1, class default)* | Swift, Screech, Bounce, Agility |
| 2 | **Snubbull** (`SNUBBULL`) | 35 | — | Intimidate *(slot 1, class default)* | Work Up, Play Rough, Crunch, Super Fang |
| 3 | **Quagsire** (`QUAGSIRE`) | 37 | — | Damp *(slot 1, class default)* | Amnesia, Aqua Tail, Body Slam, Earthquake |

### GINA3 — Route 34

**3 Pokémon, Lv. 42–43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5044](data/trainers/parties.asm#L5044) · Map: [Route34.asm:L282](maps/Route34.asm#L282)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE_ALOLAN`) | 42 | — | Hustle *(slot 1, class default)* | Sucker Punch, Flame Wheel, Double-Edge, Reversal |
| 2 | **Scizor** (`SCIZOR`) | 43 | — | Technician *(slot 1, class default)* | Dualwingbeat, Iron Defense, Iron Head, Swords Dance |
| 3 | **Sunflora** (`SUNFLORA`) | 43 | — | Chlorophyll *(slot 1, class default)* | Leech Seed, Razor Leaf, Giga Drain, Morning Sun |

### GINA4 — Route 34

**3 Pokémon, Lv. 53–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5129](data/trainers/parties.asm#L5129) · Map: [Route34.asm:L290](maps/Route34.asm#L290)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Miltank** (`MILTANK`) | 53 | — | Thick Fat *(slot 1, class default)* | Play Rough, Heal Bell, Charm, Double-Edge |
| 2 | **Scizor** (`SCIZOR`) | 53 | — | Technician *(slot 1, class default)* | Iron Head, Swords Dance, Baton Pass, Reversal |
| 3 | **Kangaskhan** (`KANGASKHAN`) | 56 | — | Scrappy *(slot 1, class default)* | Sucker Punch, Double-Edge, Superpower, Reversal |

### GINA5 — Route 34

**3 Pokémon, Lv. 59–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5139](data/trainers/parties.asm#L5139) · Map: [Route34.asm:L298](maps/Route34.asm#L298)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Granbull** (`GRANBULL`) | 59 | — | Intimidate *(slot 1, class default)* | Play Rough, Close Combat, Outrage, Work Up |
| 2 | **Mismagius** (`MISMAGIUS`) | 59 | — | Levitate *(slot 1, class default)* | Shadow Ball, Hex, Drain Kiss, Confuse Ray |
| 3 | **Politoed** (`POLITOED`) | 63 | — | Drizzle *(slot 1, class default)* | Hydro Pump, Bubblebeam, Earth Power, Belly Drum |

### Brooke — Route 35 (`BROOKE`)

**1 Pokémon, Lv. 23**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L4989](data/trainers/parties.asm#L4989) · Map: [Route35.asm:L108](maps/Route35.asm#L108)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weepinbell** (`WEEPINBELL`) | 23 | — | Chlorophyll *(slot 1, class default)* | Vine Whip, Sleep Powder, Acid, Growth |

### Cindy — Not placed on any map (`CINDY`)

**2 Pokémon, Lv. 52–55**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L4996](data/trainers/parties.asm#L4996) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Forretress** (`FORRETRESS`) | 52 | — | Sturdy *(slot 1, class default)* | Stealth Rock, Explosion, Body Press, Double-Edge |
| 2 | **Yanmega** (`YANMEGA`) | 55 | — | Speed Boost *(slot 1, class default)* | U-Turn, Signal Beam, Screech, Bug Buzz |


### ERIN1 — Route 46

**4 Pokémon, Lv. 42–44**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5014](data/trainers/parties.asm#L5014) · Map: [Route46.asm:L26](maps/Route46.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ambipom** (`AMBIPOM`) | 42 | — | Technician *(slot 1, class default)* | Swift, Screech, Agility, Bounce |
| 2 | **Girafarig** (`GIRAFARIG`) | 42 | — | Inner Focus *(slot 1, class default)* | Psychic, Psycho Cut, Baton Pass, Hyper Voice |
| 3 | **Dunsparce** (`DUNSPARCE`) | 44 | — | Serene Grace *(slot 1, class default)* | Double-Edge, Air Slash, Endure, Flail |
| 4 | **Dodrio** (`DODRIO`) | 44 | — | Reckless *(slot 1, class default)* | Jump Kick, Swords Dance, Drill Run, Lunge |

### ERIN2 — Route 46

**4 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5071](data/trainers/parties.asm#L5071) · Map: [Route46.asm:L76](maps/Route46.asm#L76)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 54 | — | Serene Grace *(slot 1, class default)* | Air Slash, Endure, Flail, Outrage |
| 2 | **Ursaring** (`URSARING`) | 54 | — | Guts *(slot 1, class default)* | Hammer Arm, Thrash, Superpower, Play Rough |
| 3 | **Raitora** (`RAITORA`) | 56 | — | Volt Absorb *(slot 1, class default)* | Thunderbolt, Play Rough, Thunder, Mean Look |
| 4 | **Furret** (`FURRET`) | 56 | — | Scrappy *(slot 1, class default)* | Baton Pass, Play Rough, Hyper Voice, Double-Edge |

### ERIN3 — Route 46

**4 Pokémon, Lv. 58–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5090](data/trainers/parties.asm#L5090) · Map: [Route46.asm:L84](maps/Route46.asm#L84)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lickitung** (`LICKITUNG`) | 58 | — | Own Tempo *(slot 1, class default)* | Stomp, Slam, Zen Headbutt, Amnesia |
| 2 | **Ursaring** (`URSARING`) | 60 | — | Guts *(slot 1, class default)* | Earthquake, Crush Claw, Slash, Rest |
| 3 | **Furret** (`FURRET`) | 63 | — | Scrappy *(slot 1, class default)* | Extremespeed, Slam, Zen Headbutt, Rest |
| 4 | **Lopunny** (`LOPUNNY`) | 63 | — | Scrappy *(slot 1, class default)* | Mega Kick, Brick Break, Dizzy Punch, Agility |


### TIFFANY1 — Route 43

**2 Pokémon, Lv. 43**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5054](data/trainers/parties.asm#L5054) · Map: [Route43.asm:L235](maps/Route43.asm#L235)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chansey** (`CHANSEY`) | 43 | — | Serene Grace *(slot 1, class default)* | Hyper Voice, Double-Edge, Disarm Voice, Softboiled |
| 2 | **Bellossom** (`BELLOSSOM`) | 43 | — | Chlorophyll *(slot 1, class default)* | Petal Dance, Moonblast, Earth Power, Toxic |

### TIFFANY2 — Route 43

**1 Pokémon, Lv. 56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5064](data/trainers/parties.asm#L5064) · Map: [Route43.asm:L243](maps/Route43.asm#L243)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Jumpluff** (`JUMPLUFF`) | 56 | — | Chlorophyll *(slot 1, class default)* | Air Slash, Giga Drain, Mega Drain, Sleep Powder |

### TIFFANY3 — Route 43

**1 Pokémon, Lv. 35**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5083](data/trainers/parties.asm#L5083) · Map: [Route43.asm:L177](maps/Route43.asm#L177)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE_ALOLAN`) | 35 | — | Hustle *(slot 1, class default)* | Crunch, Take Down, Hyper Fang, Swords Dance |

### TIFFANY4 — Route 43

**2 Pokémon, Lv. 62–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5152](data/trainers/parties.asm#L5152) · Map: [Route43.asm:L251](maps/Route43.asm#L251)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Bellossom** (`BELLOSSOM`) | 62 | — | Chlorophyll *(slot 1, class default)* | Wood Hammer, Petal Dance, Moonblast, Toxic |
| 2 | **Miltank** (`MILTANK`) | 63 | — | Thick Fat *(slot 1, class default)* | Body Slam, Headbutt, Play Rough, Milk Drink |


## Aroma Lady

> **Group:** `AromaLadyGroup` · **Battle IDs:** `AROMA_LADY` · **8 parties**

### Kim — Route 35 (`KIM`)

**1 Pokémon, Lv. 23**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5165](data/trainers/parties.asm#L5165) · Map: [Route35.asm:L119](maps/Route35.asm#L119)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Oddish** (`ODDISH`) | 23 | — | Chlorophyll *(slot 1, class default)* | Mega Drain, Bullet Seed, Sludge, Moonlight |

### Hope — Route 4 (`HOPE`)

**2 Pokémon, Lv. 69–70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5171](data/trainers/parties.asm#L5171) · Map: [Route4.asm:L26](maps/Route4.asm#L26)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Leafeon** (`LEAFEON`) | 69 | — | Leaf Guard *(slot 1, class default)* | Leaf Blade, X-Scissor, Swords Dance, Quick Attack |
| 2 | **Venusaur** (`VENUSAUR`) | 70 | — | Chlorophyll *(slot 1, class default)* | Petal Dance, Sludge Bomb, Earthquake, Synthesis |

### Sharon — Route 4 (`SHARON`)

**2 Pokémon, Lv. 69–70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5181](data/trainers/parties.asm#L5181) · Map: [Route4.asm:L37](maps/Route4.asm#L37)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Breloom** (`BRELOOM`) | 69 | — | Technician *(slot 1, class default)* | Seed Bomb, Mach Punch, Spore, Swords Dance |
| 2 | **Abomasnow** (`ABOMASNOW`) | 70 | — | Snow Warning *(slot 1, class default)* | Wood Hammer, Ice Beam, Earthquake, Light Screen |

### Debra — Fast Ship B1F (`DEBRA`)

**2 Pokémon, Lv. 51–53**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5191](data/trainers/parties.asm#L5191) · Map: [FastShipB1F.asm:L106](maps/FastShipB1F.asm#L106)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ludicolo** (`LUDICOLO`) | 51 | — | Swift Swim *(slot 1, class default)* | Giga Drain, Hydro Pump, Ice Beam, Rain Dance |
| 2 | **Meganium** (`MEGANIUM`) | 53 | — | Serene Grace *(slot 1, class default)* | Petal Dance, Body Slam, Synthesis, Light Screen |

### Heidi — Route 9 (`HEIDI`)

**2 Pokémon, Lv. 58–59**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5201](data/trainers/parties.asm#L5201) · Map: [Route9.asm:L28](maps/Route9.asm#L28)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sunflora** (`SUNFLORA`) | 58 | — | Chlorophyll *(slot 1, class default)* | Solarbeam, Sunny Day, Earth Power, Giga Drain |
| 2 | **Victreebel** (`VICTREEBEL`) | 59 | — | Chlorophyll *(slot 1, class default)* | Leaf Blade, Sludge Bomb, Sleep Powder, Growth |

### Edna — Route 9 (`EDNA`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5211](data/trainers/parties.asm#L5211) · Map: [Route9.asm:L50](maps/Route9.asm#L50)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Jumpluff** (`JUMPLUFF`) | 58 | — | Chlorophyll *(slot 1, class default)* | Giga Drain, Air Slash, Sleep Powder, U-Turn |
| 2 | **Bellossom** (`BELLOSSOM`) | 58 | — | Chlorophyll *(slot 1, class default)* | Petal Dance, Moonblast, Sunny Day, Moonlight |

### Tanya — Celadon Gym (`TANYA`)

**3 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5221](data/trainers/parties.asm#L5221) · Map: [CeladonGym.asm:L62](maps/CeladonGym.asm#L62)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vileplume** (`VILEPLUME`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Sludge Bomb, Earth Power, Growth |
| 2 | **Jumpluff** (`JUMPLUFF`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Air Slash, Synthesis, U-Turn |
| 3 | **Tangrowth** (`TANGROWTH`) | 64 | — | Chlorophyll *(slot 1, class default)* | Power Whip, Ancientpower, Growth, Slam |

### Nadia — Route 25 (Nugget Bridge 3) (`NADIA`)

**2 Pokémon, Lv. 59–60**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5234](data/trainers/parties.asm#L5234) · Map: [Route25.asm:L437](maps/Route25.asm#L437)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Exeggutor** (`EXEGGUTOR`) | 59 | — | Chlorophyll *(slot 1, class default)* | Psychic, Wood Hammer, Sleep Powder, Light Screen |
| 2 | **Bellossom** (`BELLOSSOM`) | 60 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Moonblast, Earth Power, Moonlight |


## Camper

> **Group:** `CamperGroup` · **Battle IDs:** `CAMPER` · **16 parties**

### Roland — Route 32 (`ROLAND`)

**1 Pokémon, Lv. 13**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5247](data/trainers/parties.asm#L5247) · Map: [Route32.asm:L145](maps/Route32.asm#L145)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kotora** (`KOTORA`) | 13 | — | Intimidate *(slot 2, class default)* | Thunder Wave, Nuzzle, Quick Attack, Scary Face |


### TODD1 — Route 34

**1 Pokémon, Lv. 19**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5253](data/trainers/parties.asm#L5253) · Map: [Route34.asm:L89](maps/Route34.asm#L89)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Shroomish** (`SHROOMISH`) | 19 | — | Poison Heal *(slot 2, class default)* | Headbutt, Stun Spore, Spore, Poisonpowder |

### TODD2 — Route 34

**3 Pokémon, Lv. 31–34**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5324](data/trainers/parties.asm#L5324) · Map: [Route34.asm:L149](maps/Route34.asm#L149)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Voltorb** (`VOLTORB_HISUIAN`) | 31 | — | Static *(slot 2, class default)* | Spark, Energy Ball, Selfdestruct, Thunderbolt |
| 2 | **Snover** (`SNOVER`) | 33 | — | Soundproof *(slot 2, class default)* | Ice Shard, Leech Seed, Avalanche, Seed Bomb |
| 3 | **Magby** (`MAGBY`) | 34 | — | Flash Fire *(slot 2, class default)* | Confuse Ray, Scary Face, Sunny Day, Cross Chop |

### TODD3 — Route 34

**3 Pokémon, Lv. 43–44**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5334](data/trainers/parties.asm#L5334) · Map: [Route34.asm:L157](maps/Route34.asm#L157)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Teddiursa** (`TEDDIURSA`) | 43 | — | Quick Feet *(slot 2, class default)* | Crunch, Snore, Thrash, Play Rough |
| 2 | **Vibrava** (`VIBRAVA`) | 43 | — | Overcoat *(slot 2, class default)* | Earth Power, Sandstorm, Earthquake, Bug Buzz |
| 3 | **Furret** (`FURRET`) | 44 | — | Fur Coat *(slot 2, class default)* | Reversal, Sucker Punch, Baton Pass, Play Rough |

### TODD4 — Route 34

**4 Pokémon, Lv. 55–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5365](data/trainers/parties.asm#L5365) · Map: [Route34.asm:L165](maps/Route34.asm#L165)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 55 | — | Rattled *(slot 2, class default)* | Air Slash, Endure, Flail, Outrage |
| 2 | **Bellossom** (`BELLOSSOM`) | 55 | — | Own Tempo *(slot 2, class default)* | Earth Power, Petal Dance, Wood Hammer, Leaf Storm |
| 3 | **Shuckle** (`SHUCKLE`) | 56 | — | Gluttony *(slot 2, class default)* | Sweet Scent, Body Press, Earth Power, Stone Edge |
| 4 | **Furret** (`FURRET`) | 56 | — | Fur Coat *(slot 2, class default)* | Baton Pass, Play Rough, Hyper Voice, Double-Edge |

### TODD5 — Route 34

**4 Pokémon, Lv. 62–63**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5377](data/trainers/parties.asm#L5377) · Map: [Route34.asm:L173](maps/Route34.asm#L173)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clodsire** (`CLODSIRE`) | 62 | — | Water Absorb *(slot 2, class default)* | Toxic, Mist, Haze, Recover |
| 2 | **Marowak** (`MAROWAK_ALOLAN`) | 62 | — | Lightning Rod *(slot 2, class default)* | Iron Head, Belly Drum, Flare Blitz, Earthquake |
| 3 | **Piloswine** (`PILOSWINE`) | 63 | — | Oblivious *(slot 2, class default)* | Thrash, Icicle Crash, Amnesia, Blizzard |
| 4 | **Kangaskhan** (`KANGASKHAN`) | 63 | — | Inner Focus *(slot 2, class default)* | Sucker Punch, Double-Edge, Superpower, Reversal |

### Ivan — Route 35 (`IVAN`)

**2 Pokémon, Lv. 21**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5259](data/trainers/parties.asm#L5259) · Map: [Route35.asm:L86](maps/Route35.asm#L86)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rattata** (`RATTATA`) | 21 | — | Guts *(slot 2, class default)* | Focus Energy, Pursuit, Take Down, Hyper Fang |
| 2 | **Phanpy** (`PHANPY`) | 21 | — | Pickup *(slot 2, class default)* | Rollout, Bulldoze, Flail, Mud Shot |

### Elliot — Route 35 (`ELLIOT`)

**2 Pokémon, Lv. 21**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5267](data/trainers/parties.asm#L5267) · Map: [Route35.asm:L97](maps/Route35.asm#L97)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ledyba** (`LEDYBA`) | 21 | — | Iron Fist *(slot 2, class default)* | Mach Punch, Aerial Ace, Roost, U-Turn |
| 2 | **Munchlax** (`MUNCHLAX`) | 21 | — | Pickup *(slot 2, class default)* | Lick, Bite, Screech, Body Slam |

### Barry — Not placed on any map (`BARRY`)

**2 Pokémon, Lv. 52–55**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5275](data/trainers/parties.asm#L5275) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Rapidash** (`RAPIDASH`) | 52 | — | Flash Fire *(slot 2, class default)* | Double-Edge, Raging Fury, Heat Wave, Fire Blast |
| 2 | **Donphan** (`DONPHAN`) | 55 | — | Sturdy *(slot 2, class default)* | Drill Run, Giga Impact, Superpower, Play Rough |

### Lloyd — Route 25 (`LLOYD`)

**2 Pokémon, Lv. 58**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5283](data/trainers/parties.asm#L5283) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE`) | 58 | — | Guts *(slot 2, class default)* | Sucker Punch, Flame Wheel, Double-Edge, Reversal |
| 2 | **Arcanine** (`ARCANINE_HISUIAN`) | 58 | — | Flash Fire *(slot 2, class default)* | Double-Edge, Raging Fury, Play Rough, Heat Wave |

### Dean — Route 9 (`DEAN`)

**2 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5291](data/trainers/parties.asm#L5291) · Map: [Route9.asm:L17](maps/Route9.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tauros** (`TAUROS`) | 58 | — | Anger Point *(slot 2, class default)* | Raging Bull, Earthquake, Megahorn, Ice Beam |
| 2 | **Furret** (`FURRET`) | 58 | — | Fur Coat *(slot 2, class default)* | Extremespeed, Play Rough, Thunderpunch, Quick Attack |

### Sid — Route 9 (`SID`)

**3 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5301](data/trainers/parties.asm#L5301) · Map: [Route9.asm:L39](maps/Route9.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Steelix** (`STEELIX`) | 58 | — | Sturdy *(slot 2, class default)* | Earthquake, Iron Tail, Body Press, Ice Fang |
| 2 | **Ambipom** (`AMBIPOM`) | 58 | — | Pickup *(slot 2, class default)* | Dizzy Punch, Seed Bomb, Low Sweep, Shadow Claw |
| 3 | **Pidgeot** (`PIDGEOT`) | 58 | — | Tangled Feet *(slot 2, class default)* | Hurricane, Swift, Roost, Quick Attack |

### Ted — Route 46 (`TED`)

**3 Pokémon, Lv. 44**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5314](data/trainers/parties.asm#L5314) · Map: [Route46.asm:L15](maps/Route46.asm#L15)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Marowak** (`MAROWAK`) | 44 | — | Battle Armor *(slot 2, class default)* | Swords Dance, Bone Rush, Thrash, Drill Run |
| 2 | **Lampent** (`LAMPENT`) | 44 | — | Levitate *(slot 2, class default)* | Curse, Fire Blast, Phantomforce, Heat Wave |
| 3 | **Ursaring** (`URSARING`) | 44 | — | Quick Feet *(slot 2, class default)* | Crunch, Snore, Hammer Arm, Thrash |

### Jerry — Pewter Gym (`JERRY`)

**3 Pokémon, Lv. 69–70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5344](data/trainers/parties.asm#L5344) · Map: [PewterGym.asm:L42](maps/PewterGym.asm#L42)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golem** (`GOLEM`) | 69 | — | Sturdy *(slot 2, class default)* | Earthquake, Head Smash, Hammer Arm, Rock Polish |
| 2 | **Rhyperior** (`RHYPERIOR`) | 70 | — | Reckless *(slot 2, class default)* | Earthquake, Head Smash, Megahorn, Rock Polish |
| 3 | **Sudowoodo** (`SUDOWOODO`) | 70 | — | Sturdy *(slot 2, class default)* | Stone Edge, Earthquake, Wood Hammer, Rock Polish |

### Spencer — Route 43 (`SPENCER`)

**2 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5357](data/trainers/parties.asm#L5357) · Map: [Route43.asm:L28](maps/Route43.asm#L28)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Skiploom** (`SKIPLOOM`) | 36 | — | Leaf Guard *(slot 2, class default)* | Bounce, Air Slash, Acrobatics, U-Turn |
| 2 | **Sunflora** (`SUNFLORA`) | 36 | — | Solar Power *(slot 2, class default)* | Bullet Seed, Leech Seed, Razor Leaf, Giga Drain |

### Quentin — Route 45 (`QUENTIN`)

**4 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5389](data/trainers/parties.asm#L5389) · Map: [Route45.asm:L275](maps/Route45.asm#L275)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Excadrill** (`EXCADRILL`) | 43 | — | Sturdy *(slot 2, class default)* | Sandstorm, Stealth Rock, Swords Dance, Drill Run |
| 2 | **Golem** (`GOLEM`) | 43 | — | Sturdy *(slot 2, class default)* | Stealth Rock, Iron Defense, Explosion, Hammer Arm |
| 3 | **Piloswine** (`PILOSWINE`) | 43 | — | Oblivious *(slot 2, class default)* | Earthquake, Freeze-Dry, Thrash, Icicle Crash |
| 4 | **Marowak** (`MAROWAK`) | 43 | — | Battle Armor *(slot 2, class default)* | Swords Dance, Bone Rush, Thrash, Drill Run |


## Team Rocket Executive F

> **Group:** `ExecutiveFGroup` · **Battle IDs:** `EXECUTIVEF` · **2 parties**


### EXECUTIVEF_1 — Not placed on any map

**5 Pokémon, Lv. 32–33**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5404](data/trainers/parties.asm#L5404) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golurk** (`GOLURK`) | 32 | — | Klutz *(slot 2, class default)* | Shadow Punch, Mega Punch, Rock Tomb, Curse |
| 2 | **Raticate** (`RATICATE_ALOLAN`) | 32 | — | Guts *(slot 2, class default)* | Crunch, Take Down, Hyper Fang, Swords Dance |
| 3 | **Ninetales** (`NINETALES_ALOLAN`) | 33 | — | Snow Cloak *(slot 2, class default)* | Blizzard, Dazzle Gleam, Aurora Beam, Confuse Ray |
| 4 | **Noctowl** (`NOCTOWL`) | 33 | — | Insomnia *(slot 2, class default)* | Psychic, Extrasensory, Air Slash, Reflect |
| 5 | **Mr. Mime** (`MR__MIME`) | 33 | — | Filter *(slot 2, class default)* | Psychic, Dazzle Gleam, Psybeam, Substitute |

### EXECUTIVEF_2 — Not placed on any map

**4 Pokémon, Lv. 24–25**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5423](data/trainers/parties.asm#L5423) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golett** (`GOLETT`) | 24 | — | Klutz *(slot 2, class default)* | Shadow Punch, Rock Tomb, Mud Shot, Curse |
| 2 | **Salandit** (`SALANDIT`) | 24 | — | Poison Puppeteer *(slot 2, class default)* | Flame Wheel, Ember, Dragon Rage, Toxic |
| 3 | **Wobbuffet** (`WOBBUFFET`) | 25 | — | Shadow Tag *(slot 2, class default)* | Counter, Mirror Coat, Amnesia, Encore |
| 4 | **Zweilous** (`ZWEILOUS`) | 25 | — | Hustle *(slot 2, class default)* | Bite, Headbutt, Dragonbreath, Focus Energy |


## Sage

> **Group:** `SageGroup` · **Battle IDs:** `SAGE` · **12 parties**

### Chow — Sprout Tower 1F (`CHOW`)

**3 Pokémon, Lv. 6**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L5442](data/trainers/parties.asm#L5442) · Map: [SproutTower1F.asm:L27](maps/SproutTower1F.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sunkern** (`SUNKERN`) | 6 | — | Chlorophyll *(slot 1)* | Growth, Tackle, Absorb |
| 2 | **Bellsprout** (`BELLSPROUT`) | 6 | — | Chlorophyll *(slot 1)* | Vine Whip, Growth, Acid |
| 3 | **Natu** (`NATU`) | 6 | — | Magic Bounce *(hidden)* | Leer, Peck, Night Shade |

### Nico — Sprout Tower 2F (`NICO`)

**3 Pokémon, Lv. 6–7**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L5455](data/trainers/parties.asm#L5455) · Map: [SproutTower2F.asm:L12](maps/SproutTower2F.asm#L12)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoppip** (`HOPPIP`) | 6 | — | Chlorophyll *(slot 1)* | Absorb, Splash, Tackle, Synthesis |
| 2 | **Sunkern** (`SUNKERN`) | 6 | — | Chlorophyll *(slot 1)* | Growth, Tackle, Absorb |
| 3 | **Natu** (`NATU`) | 7 | — | Magic Bounce *(hidden)* | Leer, Peck, Night Shade |

### Jin — Sprout Tower 3F (`JIN`)

**1 Pokémon, Lv. 6**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5468](data/trainers/parties.asm#L5468) · Map: [SproutTower3F.asm:L94](maps/SproutTower3F.asm#L94)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoppip** (`HOPPIP`) | 6 | — | Leaf Guard *(slot 2, class default)* | Absorb, Splash, Tackle, Synthesis |

### Troy — Sprout Tower 3F (`TROY`)

**2 Pokémon, Lv. 7**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L5474](data/trainers/parties.asm#L5474) · Map: [SproutTower3F.asm:L105](maps/SproutTower3F.asm#L105)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sunkern** (`SUNKERN`) | 7 | — | Chlorophyll *(slot 1)* | Growth, Tackle, Absorb |
| 2 | **Ralts** (`RALTS`) | 7 | — | Synchronize *(slot 1)* | Teleport, Confusion, Double Team, Disarm Voice |

### Jeffrey — Ecruteak Gym (`JEFFREY`)

**3 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5484](data/trainers/parties.asm#L5484) · Map: [EcruteakGym.asm:L115](maps/EcruteakGym.asm#L115)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gastly** (`GASTLY`) | 24 | — | Cursed Body *(slot 2, class default)* | Confuse Ray, Hex, Curse, Sucker Punch |
| 2 | **Misdreavus** (`MISDREAVUS`) | 24 | — | Levitate *(slot 2, class default)* | Psybeam, Confuse Ray, Drain Kiss, Pain Split |
| 3 | **Corsola** (`CORSOLA_GALARIAN`) | 24 | — | Weak Armor *(slot 2, class default)* | Spite, Hex, Rock Tomb, Spike Cannon |

### Ping — Ecruteak Gym (`PING`)

**1 Pokémon, Lv. 25**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5494](data/trainers/parties.asm#L5494) · Map: [EcruteakGym.asm:L126](maps/EcruteakGym.asm#L126)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Misdreavus** (`MISDREAVUS`) | 25 | — | Levitate *(slot 2, class default)* | Confuse Ray, Drain Kiss, Pain Split, Shadow Ball |

### Edmond — Sprout Tower 2F (`EDMOND`)

**3 Pokémon, Lv. 6**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L5500](data/trainers/parties.asm#L5500) · Map: [SproutTower2F.asm:L23](maps/SproutTower2F.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Voltorb** (`VOLTORB_HISUIAN`) | 6 | — | Soundproof *(slot 1)* | Thundershock, Absorb, Swift, Tackle |
| 2 | **Exeggcute** (`EXEGGCUTE`) | 6 | — | Chlorophyll *(slot 1)* | Hypnosis, Absorb, Barrage |
| 3 | **Natu** (`NATU`) | 6 | — | Magic Bounce *(hidden)* | Leer, Peck, Night Shade |

### Neal — Sprout Tower 3F (`NEAL`)

**1 Pokémon, Lv. 6**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5513](data/trainers/parties.asm#L5513) · Map: [SproutTower3F.asm:L116](maps/SproutTower3F.asm#L116)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ralts** (`RALTS`) | 6 | — | Trace *(slot 2, class default)* | Growl, Teleport, Confusion, Double Team |

### Li — Sprout Tower 3F (`LI`)

**3 Pokémon, Lv. 7–9**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5519](data/trainers/parties.asm#L5519) · Map: [SproutTower3F.asm:L73](maps/SproutTower3F.asm#L73)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoppip** (`HOPPIP`) | 7 | — | Leaf Guard *(slot 2, class default)* | Splash, Tackle, Synthesis, Tail Whip |
| 2 | **Flittle** (`FLITTLE`) | 8 | — | Keen Eye *(slot 2, class default)* | Growl, Confusion, Charm |
| 3 | **Exeggcute** (`EXEGGCUTE`) | 9 | — | Chlorophyll *(slot 2, class default)* | Hypnosis, Absorb, Barrage, Reflect |

### Gaku — Wise Trios Room (`GAKU`)

**3 Pokémon, Lv. 47**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5529](data/trainers/parties.asm#L5529) · Map: [WiseTriosRoom.asm:L70](maps/WiseTriosRoom.asm#L70)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 47 | — | Rattled *(slot 2, class default)* | Double-Edge, Air Slash, Endure, Flail |
| 2 | **Ampharos** (`AMPHAROS`) | 47 | — | Mold Breaker *(slot 2, class default)* | Take Down, Dragon Pulse, Power Gem, Thunderbolt |
| 3 | **Dipplin** (`DIPPLIN`) | 47 | — | Gluttony *(slot 2, class default)* | Recover, Energy Ball, Substitute, Apple Acid |

### Masa — Wise Trios Room (`MASA`)

**3 Pokémon, Lv. 47**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5539](data/trainers/parties.asm#L5539) · Map: [WiseTriosRoom.asm:L80](maps/WiseTriosRoom.asm#L80)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vibrava** (`VIBRAVA`) | 47 | — | Overcoat *(slot 2, class default)* | Earth Power, Sandstorm, Earthquake, Bug Buzz |
| 2 | **Dunsparce** (`DUNSPARCE`) | 47 | — | Rattled *(slot 2, class default)* | Double-Edge, Air Slash, Endure, Flail |
| 3 | **Ampharos** (`AMPHAROS`) | 47 | — | Mold Breaker *(slot 2, class default)* | Take Down, Dragon Pulse, Power Gem, Thunderbolt |

### Koji — Wise Trios Room (`KOJI`)

**3 Pokémon, Lv. 47**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5549](data/trainers/parties.asm#L5549) · Map: [WiseTriosRoom.asm:L90](maps/WiseTriosRoom.asm#L90)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ampharos** (`AMPHAROS`) | 47 | — | Mold Breaker *(slot 2, class default)* | Take Down, Dragon Pulse, Power Gem, Thunderbolt |
| 2 | **Altaria** (`ALTARIA`) | 47 | — | Natural Cure *(slot 2, class default)* | Scale Shot, Dragon Pulse, Dragon Tail, Perish Song |
| 3 | **Dunsparce** (`DUNSPARCE`) | 47 | — | Rattled *(slot 2, class default)* | Double-Edge, Air Slash, Endure, Flail |


## Medium

> **Group:** `MediumGroup` · **Battle IDs:** `MEDIUM` · **5 parties**

### Martha — Ecruteak Gym (`MARTHA`)

**2 Pokémon, Lv. 23**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5562](data/trainers/parties.asm#L5562) · Map: [EcruteakGym.asm:L137](maps/EcruteakGym.asm#L137)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Duskull** (`DUSKULL`) | 23 | — | Frisk *(slot 2, class default)* | Astonish, Foresight, Shadow Sneak, Will-O-Wisp |
| 2 | **Shuppet** (`SHUPPET`) | 23 | — | Cursed Body *(slot 2, class default)* | Curse, Spite, Will-O-Wisp, Shadow Sneak |

### Grace — Ecruteak Gym (`GRACE`)

**2 Pokémon, Lv. 23**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5570](data/trainers/parties.asm#L5570) · Map: [EcruteakGym.asm:L148](maps/EcruteakGym.asm#L148)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gastly** (`GASTLY`) | 23 | — | Cursed Body *(slot 2, class default)* | Confuse Ray, Hex, Curse, Sucker Punch |
| 2 | **Shuppet** (`SHUPPET`) | 23 | — | Cursed Body *(slot 2, class default)* | Curse, Spite, Will-O-Wisp, Shadow Sneak |

### Bethany — Silent Crypt (`BETHANY`)

**3 Pokémon, Lv. 22–24**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L5578](data/trainers/parties.asm#L5578) · Map: [SilentCrypt.asm:L39](maps/SilentCrypt.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Duskull** (`DUSKULL`) | 22 | — | Levitate *(slot 1)* | Astonish, Foresight, Shadow Sneak, Will-O-Wisp |
| 2 | **Shuppet** (`SHUPPET`) | 23 | — | Prankster *(hidden)* | Curse, Spite, Will-O-Wisp, Shadow Sneak |
| 3 | **Misdreavus** (`MISDREAVUS`) | 24 | — | Levitate *(slot 2)* | Psybeam, Confuse Ray, Drain Kiss, Pain Split |

### Rebecca — Saffron Gym (`REBECCA`)

**3 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5591](data/trainers/parties.asm#L5591) · Map: [SaffronGym.asm:L48](maps/SaffronGym.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Espathra** (`ESPATHRA`) | 66 | — | Frisk *(slot 2, class default)* | Psychic, Shadow Ball, Hyper Voice, Agility |
| 2 | **Golduck** (`GOLDUCK`) | 66 | — | Cloud Nine *(slot 2, class default)* | Hydro Pump, Psychic, Ice Beam, Amnesia |
| 3 | **Alakazam** (`ALAKAZAM`) | 66 | — | Synchronize *(slot 2, class default)* | Psychic, Focus Blast, Shadow Ball, Calm Mind |

### Doris — Saffron Gym (`DORIS`)

**3 Pokémon, Lv. 65–66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5604](data/trainers/parties.asm#L5604) · Map: [SaffronGym.asm:L70](maps/SaffronGym.asm#L70)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Slowbro** (`SLOWBRO`) | 65 | — | Unaware *(slot 2, class default)* | Surf, Psychic, Fire Blast, Amnesia |
| 2 | **Exeggutor** (`EXEGGUTOR`) | 65 | — | Chlorophyll *(slot 2, class default)* | Leaf Storm, Psychic, Sludge Bomb, Synthesis |
| 3 | **Hypno** (`HYPNO`) | 66 | — | No Guard *(slot 2, class default)* | Psychic, Fire Punch, Shadow Ball, Nasty Plot |


## Boarder

> **Group:** `BoarderGroup` · **Battle IDs:** `BOARDER` · **6 parties**

### Ronald — Mahogany Gym (`RONALD`)

**2 Pokémon, Lv. 37–38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5620](data/trainers/parties.asm#L5620) · Map: [MahoganyGym.asm:L110](maps/MahoganyGym.asm#L110)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Delibird** (`DELIBIRD`) | 37 | — | Hustle *(slot 2, class default)* | Dualwingbeat, Hail, Freeze-Dry, Ice Beam |
| 2 | **Smoochum** (`SMOOCHUM`) | 38 | — | Forewarn *(slot 2, class default)* | Ice Punch, Ice Beam, Freeze-Dry, Psychic |

### Brad — Mahogany Gym (`BRAD`)

**2 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5628](data/trainers/parties.asm#L5628) · Map: [MahoganyGym.asm:L121](maps/MahoganyGym.asm#L121)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Jynx** (`JYNX`) | 38 | — | Forewarn *(slot 2, class default)* | Extrasensory, Ice Beam, Psychic, Freeze-Dry |
| 2 | **Snorunt** (`SNORUNT`) | 38 | — | Ice Body *(slot 2, class default)* | Avalanche, Crunch, Ice Beam, Protect |

### Douglas — Mahogany Gym (`DOUGLAS`)

**3 Pokémon, Lv. 37–38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5636](data/trainers/parties.asm#L5636) · Map: [MahoganyGym.asm:L132](maps/MahoganyGym.asm#L132)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Delibird** (`DELIBIRD`) | 37 | — | Hustle *(slot 2, class default)* | Dualwingbeat, Hail, Freeze-Dry, Ice Beam |
| 2 | **Jynx** (`JYNX`) | 37 | — | Forewarn *(slot 2, class default)* | Sing, Extrasensory, Ice Beam, Psychic |
| 3 | **Snorunt** (`SNORUNT`) | 38 | — | Ice Body *(slot 2, class default)* | Avalanche, Crunch, Ice Beam, Protect |

### Aidan — Shiver Isle (`BOARDER_AIDAN`)

**2 Pokémon, Lv. 43–45**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5646](data/trainers/parties.asm#L5646) · Map: [ShiverIsle.asm:L16](maps/ShiverIsle.asm#L16)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Swinub** (`SWINUB`) | 43 | — | Oblivious *(slot 2, class default)* | Earthquake, Flail, Icicle Crash, Amnesia |
| 2 | **Sneasel** (`SNEASEL`) | 45 | — | Inner Focus *(slot 2, class default)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |

### Noel — Shiver Isle (`BOARDER_NOEL`)

**3 Pokémon, Lv. 43–45**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5654](data/trainers/parties.asm#L5654) · Map: [ShiverIsle.asm:L27](maps/ShiverIsle.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Cetoddle** (`CETODDLE`) | 43 | — | Snow Cloak *(slot 2, class default)* | Avalanche, Freeze-Dry, Body Slam, Amnesia |
| 2 | **Swinub** (`SWINUB`) | 44 | — | Oblivious *(slot 2, class default)* | Earthquake, Flail, Icicle Crash, Amnesia |
| 3 | **Seel** (`SEEL`) | 45 | — | Swift Swim *(slot 2, class default)* | Take Down, Safeguard, Hail, Megahorn |

### Spencer — Route 44 (`BOARDER_SPENCER`)

**3 Pokémon, Lv. 40–41**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5664](data/trainers/parties.asm#L5664) · Map: [Route44.asm:L303](maps/Route44.asm#L303)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Abomasnow** (`ABOMASNOW`) | 40 | — | Soundproof *(slot 2, class default)* | Avalanche, Seed Bomb, Mist, Freeze-Dry |
| 2 | **Piloswine** (`PILOSWINE`) | 41 | — | Oblivious *(slot 2, class default)* | Fury Attack, Earthquake, Freeze-Dry, Thrash |
| 3 | **Sneasel** (`SNEASEL`) | 41 | — | Inner Focus *(slot 2, class default)* | Freeze-Dry, Hone Claws, Crunch, Foul Play |


## Pokéfan M

> **Group:** `PokefanMGroup` · **Battle IDs:** `POKEFANM` · **15 parties**

### William — National Park (`WILLIAM`)

**1 Pokémon, Lv. 22**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5677](data/trainers/parties.asm#L5677) · Map: [NationalPark.asm:L190](maps/NationalPark.asm#L190)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoothoot** (`HOOTHOOT`) | 22 | — | Insomnia *(slot 2, class default)* | Foresight, Hypnosis, Confusion, Extrasensory |


### DEREK1 — Route 39

**2 Pokémon, Lv. 27**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5683](data/trainers/parties.asm#L5683) · Map: [Route39.asm:L27](maps/Route39.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 27 | — | Lightning Rod *(slot 2, class default)* | Spark, Double Team, Slam, Thunderbolt |
| 2 | **Snubbull** (`SNUBBULL`) | 27 | — | Run Away *(slot 2, class default)* | Headbutt, Roar, Work Up, Play Rough |

### DEREK2 — Route 39 (rematch)

**2 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5766](data/trainers/parties.asm#L5766) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 43 | — | Lightning Rod *(slot 2, class default)* | Agility, Wild Charge, Light Screen, Thunder |
| 2 | **Chinchou** (`CHINCHOU`) | 43 | — | Water Absorb *(slot 2, class default)* | Signal Beam, Thunderbolt, Take Down, Hydro Pump |

### DEREK3 — Route 39 (rematch)

**2 Pokémon, Lv. 56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5774](data/trainers/parties.asm#L5774) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 56 | — | Lightning Rod *(slot 2, class default)* | Wild Charge, Light Screen, Thunder, Volt Tackle |
| 2 | **Electabuzz** (`ELECTABUZZ`) | 56 | — | Vital Spirit *(slot 2, class default)* | Thunderbolt, Wild Charge, Close Combat, Thunder |

### Robert — Route 10 South (`ROBERT`)

**2 Pokémon, Lv. 62–64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5691](data/trainers/parties.asm#L5691) · Map: [Route10South.asm:L22](maps/Route10South.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Steelix** (`STEELIX`) | 62 | — | Sturdy *(slot 2, class default)* | Earthquake, Iron Tail, Ice Fang, Body Press |
| 2 | **Excadrill** (`EXCADRILL`) | 64 | — | Sturdy *(slot 2, class default)* | Earthquake, Iron Head, Rock Slide, Strength |

### Joshua — Route 13 (`JOSHUA`)

**3 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5701](data/trainers/parties.asm#L5701) · Map: [Route13.asm:L25](maps/Route13.asm#L25)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 66 | — | Lightning Rod *(slot 2, class default)* | Volt Tackle, Thunderbolt, Iron Tail, Quick Attack |
| 2 | **Raichu** (`RAICHU`) | 66 | — | Lightning Rod *(slot 2, class default)* | Thunderpunch, Wild Charge, Iron Tail, Nasty Plot |
| 3 | **Raichu** (`RAICHU_ALOLAN`) | 66 | — | Motor Drive *(slot 2, class default)* | Thunderbolt, Psychic, Surf, Nasty Plot |

### Carter — Route 14 (`CARTER`)

**3 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5714](data/trainers/parties.asm#L5714) · Map: [Route14.asm:L21](maps/Route14.asm#L21)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lickilicky** (`LICKILICKY`) | 66 | — | Oblivious *(slot 2, class default)* | Body Slam, Power Whip, Zen Headbutt, Stomp |
| 2 | **Dodrio** (`DODRIO`) | 66 | — | Early Bird *(slot 2, class default)* | Brave Bird, Quick Attack, Drill Run, Hi Jump Kick |
| 3 | **Tauros** (`TAUROS`) | 66 | — | Anger Point *(slot 2, class default)* | Raging Bull, Earthquake, Megahorn, Iron Head |

### Trevor — Route 14 (`TREVOR`)

**2 Pokémon, Lv. 66**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5727](data/trainers/parties.asm#L5727) · Map: [Route14.asm:L43](maps/Route14.asm#L43)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon2** (`PORYGON2`) | 66 | — | Download *(slot 2, class default)* | Tri Attack, Ice Beam, Psychic, Recover |
| 2 | **Persian** (`PERSIAN`) | 66 | — | Limber *(slot 2, class default)* | Crush Claw, Thunderbolt, Play Rough, Iron Tail |

### Brandon — Route 34 (`BRANDON`)

**1 Pokémon, Lv. 19**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5737](data/trainers/parties.asm#L5737) · Map: [Route34.asm:L405](maps/Route34.asm#L405)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Diglett** (`DIGLETT`) | 19 | — | Arena Trap *(slot 2, class default)* | Bulldoze, Magnitude, Mud Shot, Dig |

### Jeremy — Fast Ship Cabins / SE / SSE / Captain's Cabin (`JEREMY`)

**3 Pokémon, Lv. 54–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5743](data/trainers/parties.asm#L5743) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L186](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L186)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chansey** (`CHANSEY`) | 54 | — | Natural Cure *(slot 2, class default)* | Hyper Voice, Ice Beam, Fire Blast, Psychic |
| 2 | **Banette** (`BANETTE`) | 54 | — | Cursed Body *(slot 2, class default)* | Phantomforce, Strength, Ice Punch, Sucker Punch |
| 3 | **Porygon2** (`PORYGON2`) | 56 | — | Download *(slot 2, class default)* | Tri Attack, Ice Beam, Thunderbolt, Recover |

### Colin — Fast Ship Cabins / SE / SSE / Captain's Cabin (`COLIN`)

**2 Pokémon, Lv. 51–53**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5756](data/trainers/parties.asm#L5756) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L142](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L142)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Raticate** (`RATICATE_ALOLAN`) | 51 | — | Guts *(slot 2, class default)* | Strength, Crunch, Iron Tail, Sucker Punch |
| 2 | **Porygon-Z** (`PORYGON_Z`) | 53 | — | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Signal Beam, Recover |

### Alex — Route 13 (`ALEX`)

**3 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5782](data/trainers/parties.asm#L5782) · Map: [Route13.asm:L14](maps/Route13.asm#L14)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Miltank** (`MILTANK`) | 64 | — | Scrappy *(slot 2, class default)* | Body Slam, Earthquake, Play Rough, Milk Drink |
| 2 | **Porygon2** (`PORYGON2`) | 64 | — | Download *(slot 2, class default)* | Tri Attack, Ice Beam, Thunderbolt, Recover |
| 3 | **Gorotora** (`GOROTORA`) | 64 | — | Intimidate *(slot 2, class default)* | Extremespeed, Thunderbolt, Earthquake, Quick Attack |

### Rex — Route 6 (`REX`)

**2 Pokémon, Lv. 57–58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5795](data/trainers/parties.asm#L5795) · Map: [Route6.asm:L12](maps/Route6.asm#L12)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Persian** (`PERSIAN`) | 57 | — | Limber *(slot 2, class default)* | Crush Claw, Thunderbolt, Power Gem, Shadow Ball |
| 2 | **Raticate** (`RATICATE`) | 58 | — | Guts *(slot 2, class default)* | Strength, Crunch, Iron Tail, Quick Attack |

### Allan — Route 6 (`ALLAN`)

**2 Pokémon, Lv. 56–58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5805](data/trainers/parties.asm#L5805) · Map: [Route6.asm:L23](maps/Route6.asm#L23)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Snorlax** (`SNORLAX`) | 56 | — | Immunity *(slot 2, class default)* | Body Slam, Earthquake, Ice Punch, Slack Off |
| 2 | **Electrode** (`ELECTRODE`) | 58 | — | Static *(slot 2, class default)* | Thunderbolt, Signal Beam, Swift, Thunder |

### Dustin — Route 25 (`DUSTIN`)

**3 Pokémon, Lv. 58**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5815](data/trainers/parties.asm#L5815) · Map: [Route25.asm:L459](maps/Route25.asm#L459)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Azumarill** (`AZUMARILL`) | 58 | — | Thick Fat *(slot 2, class default)* | Hydro Pump, Play Rough, Ice Beam, Aqua Jet |
| 2 | **Ampharos** (`AMPHAROS`) | 58 | — | Mold Breaker *(slot 2, class default)* | Thunderbolt, Dragon Pulse, Power Gem, Thunder Wave |
| 3 | **Donphan** (`DONPHAN`) | 58 | — | Sturdy *(slot 2, class default)* | Earthquake, Play Rough, Body Press, Ice Shard |


## Kimono Girl

> **Group:** `KimonoGirlGroup` · **Battle IDs:** `KIMONO_GIRL` · **9 parties**


### NAOKO1 — Dance Theatre (rematch)

**3 Pokémon, Lv. 54–56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5831](data/trainers/parties.asm#L5831) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wobbuffet** (`WOBBUFFET`) | 54 | — | Shadow Tag *(slot 1, class default)* | Amnesia, Encore, Charm, Splash |
| 2 | **Kirlia** (`KIRLIA`) | 56 | — | Synchronize *(slot 1, class default)* | Moonblast, Charm, Dream Eater, Future Sight |
| 3 | **Slugma** (`SLUGMA`) | 56 | — | Magma Armor *(slot 1, class default)* | Flamethrower, Power Gem, Body Slam, Recover |

### NAOKO2 — Dance Theatre

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5841](data/trainers/parties.asm#L5841) · Map: [DanceTheatre.asm:L21](maps/DanceTheatre.asm#L21)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Flareon** (`FLAREON`) | 24 | — | Flash Fire *(slot 1, class default)* | Smog, Fire Fang, Fire Spin, Flame Wheel |

### Sayo — Dance Theatre (`SAYO`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5847](data/trainers/parties.asm#L5847) · Map: [DanceTheatre.asm:L32](maps/DanceTheatre.asm#L32)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Espeon** (`ESPEON`) | 24 | — | Synchronize *(slot 1, class default)* | Psych Up, Psybeam, Swift, Future Sight |

### Zuki — Dance Theatre (`ZUKI`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5853](data/trainers/parties.asm#L5853) · Map: [DanceTheatre.asm:L43](maps/DanceTheatre.asm#L43)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Umbreon** (`UMBREON`) | 24 | — | Synchronize *(slot 1, class default)* | Quick Attack, Mean Look, Faint Attack, Confuse Ray |

### Kuni — Dance Theatre (`KUNI`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5859](data/trainers/parties.asm#L5859) · Map: [DanceTheatre.asm:L54](maps/DanceTheatre.asm#L54)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vaporeon** (`VAPOREON`) | 24 | — | Water Absorb *(slot 1, class default)* | Quick Attack, Haze, Water Pulse, Aurora Beam |

### Miki — Dance Theatre (`MIKI`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5865](data/trainers/parties.asm#L5865) · Map: [DanceTheatre.asm:L65](maps/DanceTheatre.asm#L65)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Jolteon** (`JOLTEON`) | 24 | — | Volt Absorb *(slot 1, class default)* | Nuzzle, Thunder Wave, Double Kick, Thunder Fang |

### Fuyu — Dance Theatre (`FUYU`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5871](data/trainers/parties.asm#L5871) · Map: [DanceTheatre.asm:L76](maps/DanceTheatre.asm#L76)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Glaceon** (`GLACEON`) | 24 | — | Snow Cloak *(slot 1, class default)* | Mirror Coat, Icy Wind, Ice Shard, Ice Fang |

### Hana — Dance Theatre (`HANA`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5877](data/trainers/parties.asm#L5877) · Map: [DanceTheatre.asm:L87](maps/DanceTheatre.asm#L87)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Leafeon** (`LEAFEON`) | 24 | — | Leaf Guard *(slot 1, class default)* | Quick Attack, Synthesis, Razor Leaf, Leech Seed |

### Yumi — Dance Theatre (`YUMI`)

**1 Pokémon, Lv. 24**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5883](data/trainers/parties.asm#L5883) · Map: [DanceTheatre.asm:L98](maps/DanceTheatre.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sylveon** (`SYLVEON`) | 24 | — | Cute Charm *(slot 1, class default)* | Psych Up, Drain Kiss, Swift, Sweet Kiss |


## Twins

> **Group:** `TwinsGroup` · **Battle IDs:** `TWINS` · **10 parties**


### AMYANDMAY1 — Azalea Gym

**2 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5892](data/trainers/parties.asm#L5892) · Map: [AzaleaGym.asm:L87](maps/AzaleaGym.asm#L87)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pineco** (`PINECO`) | 15 | — | Sturdy *(slot 1, class default)* | Bug Bite, Selfdestruct, Rapid Spin, Pin Missile |
| 2 | **Spinarak** (`SPINARAK`) | 15 | — | Insomnia *(slot 1, class default)* | Bug Bite, Scary Face, Poison Fang, Night Shade |

### AMYANDMAY2 — Azalea Gym

**2 Pokémon, Lv. 15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L5920](data/trainers/parties.asm#L5920) · Map: [AzaleaGym.asm:L98](maps/AzaleaGym.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Paras** (`PARAS`) | 15 | — | Effect Spore *(slot 1, class default)* | Poisonpowder, Bullet Seed, Bug Bite, Venoshock |
| 2 | **Pineco** (`PINECO`) | 15 | — | Sturdy *(slot 1, class default)* | Bug Bite, Selfdestruct, Rapid Spin, Pin Missile |


### ANNANDANNE1 — Route 37

**2 Pokémon, Lv. 25**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5900](data/trainers/parties.asm#L5900) · Map: [Route37.asm:L27](maps/Route37.asm#L27)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ledyba** (`LEDYBA`) | 25 | — | Technician *(slot 1, class default)* | Bug Bite, Aerial Ace, Mach Punch, Roost |
| 2 | **Sentret** (`SENTRET`) | 25 | — | Run Away *(slot 1, class default)* | Slam, Quick Attack, Rest, Scratch |

### ANNANDANNE2 — Route 37

**2 Pokémon, Lv. 25**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5910](data/trainers/parties.asm#L5910) · Map: [Route37.asm:L38](maps/Route37.asm#L38)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Kotora** (`KOTORA`) | 25 | — | Volt Absorb *(slot 1, class default)* | Volt Tackle, Bite, Quick Attack, Slack Off |
| 2 | **Snubbull** (`SNUBBULL`) | 25 | — | Intimidate *(slot 1, class default)* | Headbutt, Ice Fang, Fire Fang, Charm |


### JOANDZOE1 — Celadon Gym

**2 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5928](data/trainers/parties.asm#L5928) · Map: [CeladonGym.asm:L84](maps/CeladonGym.asm#L84)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Jumpluff** (`JUMPLUFF`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Air Slash, Synthesis, U-Turn |
| 2 | **Parasect** (`PARASECT`) | 64 | — | Effect Spore *(slot 1, class default)* | X-Scissor, Seed Bomb, Slash, Growth |

### JOANDZOE2 — Celadon Gym

**2 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5938](data/trainers/parties.asm#L5938) · Map: [CeladonGym.asm:L95](maps/CeladonGym.asm#L95)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Victreebel** (`VICTREEBEL`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Sludge Bomb, Growth, Sucker Punch |
| 2 | **Exeggutor** (`EXEGGUTOR`) | 64 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Psychic, Sludge Bomb, Synthesis |


### MEGANDPEG1 — Fast Ship Cabins / SE / SSE / Captain's Cabin

**2 Pokémon, Lv. 55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5948](data/trainers/parties.asm#L5948) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L153](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L153)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Lopunny** (`LOPUNNY`) | 55 | — | Scrappy *(slot 1, class default)* | Mega Kick, Hi Jump Kick, Quick Attack, Dizzy Punch |
| 2 | **Zangoose** (`ZANGOOSE`) | 55 | — | Immunity *(slot 1, class default)* | Strength, Close Combat, Ice Punch, Quick Attack |

### MEGANDPEG2 — Fast Ship Cabins / SE / SSE / Captain's Cabin

**2 Pokémon, Lv. 55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5958](data/trainers/parties.asm#L5958) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L164](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L164)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Furret** (`FURRET`) | 55 | — | Scrappy *(slot 1, class default)* | Extremespeed, Play Rough, Thunderpunch, Quick Attack |
| 2 | **Porygon2** (`PORYGON2`) | 55 | — | Trace *(slot 1, class default)* | Tri Attack, Ice Beam, Psychic, Recover |


### LEAANDPIA1 — Dragon's Den B1F

**4 Pokémon, Lv. 46–47**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5968](data/trainers/parties.asm#L5968) · Map: [DragonsDenB1F.asm:L107](maps/DragonsDenB1F.asm#L107)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dunsparce** (`DUNSPARCE`) | 46 | — | Serene Grace *(slot 1, class default)* | Double-Edge, Body Slam, Air Slash, Roost |
| 2 | **Appletun** (`APPLETUN`) | 46 | — | Ripen *(slot 1, class default)* | Dragon Pulse, Mega Drain, Body Slam, Recover |
| 3 | **Ampharos** (`AMPHAROS`) | 47 | — | Static *(slot 1, class default)* | Dragon Pulse, Power Gem, Zap Cannon, Thunder Wave |
| 4 | **Kingdra** (`KINGDRA`) | 47 | — | Swift Swim *(slot 1, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |

### LEAANDPIA2 — Dragon's Den B1F (rematch)

**4 Pokémon, Lv. 55–56**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L5984](data/trainers/parties.asm#L5984) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ampharos** (`AMPHAROS`) | 55 | — | Static *(slot 1, class default)* | Dragon Pulse, Power Gem, Zap Cannon, Thunder Wave |
| 2 | **Exeggutor** (`EXEGGUTOR_ALOLAN`) | 55 | — | Frisk *(slot 1, class default)* | Seed Bomb, Zen Headbutt, Stomp, Sleep Powder |
| 3 | **Kingdra** (`KINGDRA`) | 56 | — | Swift Swim *(slot 1, class default)* | Dragon Pulse, Bubblebeam, Water Pulse, Agility |
| 4 | **Dunsparce** (`DUNSPARCE`) | 56 | — | Serene Grace *(slot 1, class default)* | Double-Edge, Body Slam, Air Slash, Roost |


## Pokéfan F

> **Group:** `PokefanFGroup` · **Battle IDs:** `POKEFANF` · **6 parties**


### BEVERLY1 — National Park

**1 Pokémon, Lv. 22**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6003](data/trainers/parties.asm#L6003) · Map: [NationalPark.asm:L201](maps/NationalPark.asm#L201)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeotto** (`PIDGEOTTO`) | 22 | — | Keen Eye *(slot 1, class default)* | Quick Attack, Wing Attack, Swift, Twister |

### BEVERLY2 — National Park (rematch)

**1 Pokémon, Lv. 43**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6015](data/trainers/parties.asm#L6015) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hoothoot** (`HOOTHOOT`) | 43 | — | Tinted Lens *(slot 1, class default)* | Zen Headbutt, Moonblast, Roost, Dream Eater |

### BEVERLY3 — National Park (rematch)

**1 Pokémon, Lv. 56**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6021](data/trainers/parties.asm#L6021) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Porygon** (`PORYGON`) | 56 | — | Trace *(slot 1, class default)* | Psychic, Zap Cannon, Hyper Beam, Double-Edge |

### Ruth — Route 39 (`RUTH`)

**1 Pokémon, Lv. 28**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6009](data/trainers/parties.asm#L6009) · Map: [Route39.asm:L106](maps/Route39.asm#L106)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Elekid** (`ELEKID`) | 28 | — | Static *(slot 1, class default)* | Nuzzle, Thunder Wave, Thunderpunch, Light Screen |

### Georgia — Fast Ship Cabins / SE / SSE / Captain's Cabin (`GEORGIA`)

**5 Pokémon, Lv. 53–55**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6027](data/trainers/parties.asm#L6027) · Map: [FastShipCabins_SE_SSE_CaptainsCabin.asm:L197](maps/FastShipCabins_SE_SSE_CaptainsCabin.asm#L197)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Zangoose** (`ZANGOOSE`) | 53 | — | Immunity *(slot 1, class default)* | Strength, Close Combat, Ice Punch, Quick Attack |
| 2 | **Fearow** (`FEAROW`) | 53 | — | Keen Eye *(slot 1, class default)* | Brave Bird, Facade, Steel Wing, Roost |
| 3 | **Miltank** (`MILTANK`) | 53 | — | Thick Fat *(slot 1, class default)* | Body Slam, Earthquake, Fire Punch, Milk Drink |
| 4 | **Porygon2** (`PORYGON2`) | 53 | — | Trace *(slot 1, class default)* | Tri Attack, Ice Beam, Psychic, Recover |
| 5 | **Snorlax** (`SNORLAX`) | 55 | — | Thick Fat *(slot 1, class default)* | Body Slam, Earthquake, Hammer Arm, Slack Off |

### Jaime — Route 39 (`JAIME`)

**1 Pokémon, Lv. 25**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6046](data/trainers/parties.asm#L6046) · Map: [Route39.asm:L149](maps/Route39.asm#L149)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Fletchling** (`FLETCHLING`) | 25 | — | Big Pecks *(slot 1, class default)* | Ember, Flail, Acrobatics, Agility |


## Red

> **Group:** `RedGroup` · **Battle IDs:** `RED` · **1 parties**

###  — Silver Cave Room 3 (`RED1`)

**6 Pokémon, Lv. 71–73**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6055](data/trainers/parties.asm#L6055) · Map: [SilverCaveRoom3.asm:L17](maps/SilverCaveRoom3.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 71 | Light Ball | Galvanize *(hidden)* | Extremespeed, Hyper Voice, Surf, Iron Tail |
| 2 | **Espeon** (`ESPEON`) | 72 | Twistedspoon | Magic Bounce *(hidden)* | Psychic, Shadow Ball, Morning Sun, Calm Mind |
| 3 | **Snorlax** (`SNORLAX`) | 72 | Leftovers | Thick Fat *(slot 1)* | Curse, Body Slam, Earthquake, Rest |
| 4 | **Venusaur** (`VENUSAUR`) | 73 | Miracle Seed | Chlorophyll *(slot 1)* | Giga Drain, Sludge Bomb, Sleep Powder, Synthesis |
| 5 | **Charizard** (`CHARIZARD`) | 73 | Charcoal | Drought *(hidden)* | Fire Blast, Solarbeam, Air Slash, Dragon Pulse |
| 6 | **Blastoise** (`BLASTOISE`) | 73 | Mystic Water | Drizzle *(hidden)* | Hydro Pump, Ice Beam, Aura Sphere, Earthquake |


## Blue

> **Group:** `BlueGroup` · **Battle IDs:** `BLUE` · **1 parties**

###  — Viridian Gym (`BLUE1`)

**6 Pokémon, Lv. 68–71**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6092](data/trainers/parties.asm#L6092) · Map: [ViridianGym.asm:L22](maps/ViridianGym.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeot** (`PIDGEOT`) | 68 | Life Orb | No Guard *(slot 1)* | Hurricane, Heat Wave, Signal Beam, Roost |
| 2 | **Rhyperior** (`RHYPERIOR`) | 69 | Leftovers | Solid Rock *(slot 1)* | Earthquake, Stone Edge, Ice Punch, Megahorn |
| 3 | **Gyarados** (`GYARADOS`) | 69 | Life Orb | Moxie *(hidden)* | Waterfall, Crunch, Earthquake, Dragon Dance |
| 4 | **Arcanine** (`ARCANINE`) | 70 | Expert Belt | Intimidate *(slot 1)* | Flare Blitz, Extremespeed, Crunch, Wild Charge |
| 5 | **Scizor** (`SCIZOR`) | 70 | Muscle Band | Technician *(slot 1)* | Bullet Punch, Bug Bite, U-Turn, Swords Dance |
| 6 | **Electivire** (`ELECTIVIRE`) | 71 | Life Orb | Sheer Force *(slot 2)* | Wild Charge, Ice Punch, Fire Punch, Crunch |


## Officer

> **Group:** `OfficerGroup` · **Battle IDs:** `OFFICER` · **2 parties**

### Keith — Route 34 (`KEITH`)

**1 Pokémon, Lv. 20**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6129](data/trainers/parties.asm#L6129) · Map: [Route34.asm:L363](maps/Route34.asm#L363)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Growlithe** (`GROWLITHE`) | 20 | — | Flash Fire *(slot 2, class default)* | Bite, Ember, Fire Fang, Reversal |

### Dirk — Route 35 (`DIRK`)

**2 Pokémon, Lv. 21**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6135](data/trainers/parties.asm#L6135) · Map: [Route35.asm:L249](maps/Route35.asm#L249)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Growlithe** (`GROWLITHE`) | 21 | — | Flash Fire *(slot 2, class default)* | Ember, Fire Fang, Reversal, Take Down |
| 2 | **Hoothoot** (`HOOTHOOT`) | 21 | — | Insomnia *(slot 2, class default)* | Foresight, Hypnosis, Confusion, Extrasensory |


## Mystical Man

> **Group:** `MysticalmanGroup` · **Battle IDs:** `MYSTICALMAN` · **2 parties**


### EUSINE — Cianwood City

**3 Pokémon, Lv. 33–34**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6147](data/trainers/parties.asm#L6147) · Map: [CianwoodCity.asm:L75](maps/CianwoodCity.asm#L75)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hypno** (`HYPNO`) | 33 | Twistedspoon | Insomnia *(slot 1)* | Psychic, Hypnosis, Dream Eater, Reflect |
| 2 | **Haunter** (`HAUNTER`) | 33 | Spell Tag | Levitate *(slot 1)* | Shadow Ball, Hypnosis, Confuse Ray, Sucker Punch |
| 3 | **Electrode** (`ELECTRODE`) | 34 | Magnet | Static *(slot 2)* | Thunderbolt, Thunder Wave, Selfdestruct, Light Screen |

### EUSINE2 — Ecruteak City

**5 Pokémon, Lv. 38–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6166](data/trainers/parties.asm#L6166) · Map: [EcruteakCity.asm:L52](maps/EcruteakCity.asm#L52)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hypno** (`HYPNO`) | 38 | — | No Guard *(slot 2, class default)* | Mind Reader, Psych Up, Zen Headbutt, Psychic |
| 2 | **Haunter** (`HAUNTER`) | 38 | — | Cursed Body *(slot 2, class default)* | Shadow Punch, Shadow Ball, Sludge Bomb, Dream Eater |
| 3 | **Electrode** (`ELECTRODE`) | 39 | — | Static *(slot 2, class default)* | Selfdestruct, Light Screen, Signal Beam, Thunderbolt |
| 4 | **Noctowl** (`NOCTOWL`) | 39 | — | Insomnia *(slot 2, class default)* | Psychic, Defog, Dualwingbeat, Zen Headbutt |
| 5 | **Espeon** (`ESPEON`) | 40 | — | Synchronize *(slot 2, class default)* | Psychic, Aura Sphere, Signal Beam, Psycho Cut |


## Proton

> **Group:** `ProtonGroup` · **Battle IDs:** `PROTON` · **2 parties**


### PROTON1 — Slowpoke Well B1F

**3 Pokémon, Lv. 10–13**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6183](data/trainers/parties.asm#L6183) · Map: [SlowpokeWellB1F.asm:L32](maps/SlowpokeWellB1F.asm#L32)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Croagunk** (`CROAGUNK`) | 10 | Poison Barb | Dry Skin *(slot 2, class default)* | Astonish, Poison Sting, Mud-Slap |
| 2 | **Spinarak** (`SPINARAK`) | 11 | Gold Berry | Sniper *(slot 2, class default)* | Bug Bite, Infestation, Poison Sting, Fury Swipes |
| 3 | **Salandit** (`SALANDIT`) | 13 | Poison Barb | Poison Puppeteer *(slot 2, class default)* | Ember, Scratch, Smog, Poison Gas |

### PROTON2 — Radio Tower 4F

**4 Pokémon, Lv. 40–42**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6199](data/trainers/parties.asm#L6199) · Map: [RadioTower4F.asm:L68](maps/RadioTower4F.asm#L68)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndoom** (`HOUNDOOM`) | 40 | Quick Claw | Flash Fire *(slot 2, class default)* | Flamethrower, Dark Pulse, Snarl, Crunch |
| 2 | **Umbreon** (`UMBREON`) | 40 | Leftovers | Inner Focus *(slot 2, class default)* | Crunch, Double-Edge, Gunk Shot, Moonlight |
| 3 | **Sneasel** (`SNEASEL`) | 41 | Eviolite | Inner Focus *(slot 2, class default)* | Foul Play, Crunch, Crush Claw, Hone Claws |
| 4 | **Ariados** (`ARIADOS`) | 42 | Leftovers | Sniper *(slot 2, class default)* | Poison Jab, Cross Poison, Bug Bite, Swords Dance |


## Petrel

> **Group:** `PetrelGroup` · **Battle IDs:** `PETREL` · **1 parties**

### Petrel — Team Rocket Base B3F (`PETREL1`)

**4 Pokémon, Lv. 35–36**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6222](data/trainers/parties.asm#L6222) · Map: [TeamRocketBaseB3F.asm:L109](maps/TeamRocketBaseB3F.asm#L109)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Arbok** (`ARBOK`) | 35 | Leftovers | Shed Skin *(slot 2, class default)* | Crunch, Poison Fang, Ice Fang, Glare |
| 2 | **Haunter** (`HAUNTER`) | 36 | Quick Claw | Cursed Body *(slot 2, class default)* | Shadow Ball, Hex, Sucker Punch, Curse |
| 3 | **Murkrow** (`MURKROW`) | 36 | Miracleberry | Insomnia *(slot 2, class default)* | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| 4 | **Houndour** (`HOUNDOUR`) | 36 | Blackglasses | Flash Fire *(slot 2, class default)* | Snarl, Crunch, Fire Fang, Ember |


## Ariana

> **Group:** `ArianaGroup` · **Battle IDs:** `ARIANA` · **2 parties**


### ARIANA1 — Team Rocket Base B2F

**4 Pokémon, Lv. 35–36**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6248](data/trainers/parties.asm#L6248) · Map: [TeamRocketBaseB2F.asm:L98](maps/TeamRocketBaseB2F.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Houndour** (`HOUNDOUR`) | 35 | Miracleberry | Flash Fire *(slot 2, class default)* | Snarl, Crunch, Fire Fang, Ember |
| 2 | **Deino** (`DEINO`) | 35 | Leftovers | Hustle *(slot 2, class default)* | Bite, Headbutt, Slam, Focus Energy |
| 3 | **Ariados** (`ARIADOS`) | 36 | Quick Claw | Sniper *(slot 2, class default)* | Bug Bite, Poison Fang, Night Slash, Swords Dance |
| 4 | **Murkrow** (`MURKROW`) | 36 | Miracleberry | Insomnia *(slot 2, class default)* | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |

### ARIANA2 — Radio Tower 5F

**5 Pokémon, Lv. 42–43**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6268](data/trainers/parties.asm#L6268) · Map: [RadioTower5F.asm:L69](maps/RadioTower5F.asm#L69)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Overqwil** (`OVERQWIL`) | 42 | Expert Belt | Swift Swim *(slot 2, class default)* | Poison Jab, Night Slash, Bite, Toxic Spikes |
| 2 | **Houndoom** (`HOUNDOOM`) | 42 | Scope Lens | Flash Fire *(slot 2, class default)* | Flamethrower, Dark Pulse, Snarl, Crunch |
| 3 | **Nidorina** (`NIDORINA`) | 43 | Eviolite | Rivalry *(slot 2, class default)* | Poison Jab, Crunch, Poison Fang, Toxic Spikes |
| 4 | **Sneasel** (`SNEASEL`) | 43 | Muscle Band | Inner Focus *(slot 2, class default)* | Foul Play, Crunch, Crush Claw, Hone Claws |
| 5 | **Ariados** (`ARIADOS`) | 43 | Silverpowder | Sniper *(slot 2, class default)* | Poison Jab, Cross Poison, Bug Bite, Swords Dance |


## Archer

> **Group:** `ArcherGroup` · **Battle IDs:** `ARCHER` · **2 parties**


### ARCHER1 — Radio Tower 5F (rematch)

**4 Pokémon, Lv. 43–44**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6295](data/trainers/parties.asm#L6295) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sneasel** (`SNEASEL_HISUIAN`) | 43 | Miracleberry | Poison Touch *(slot 2, class default)* | Poison Jab, Drain Punch, Poison Fang, Focus Energy |
| 2 | **Grimer** (`GRIMER_ALOLAN`) | 44 | Miracleberry | Gluttony *(slot 2, class default)* | Knock Off, Bite, Poison Fang, Toxic |
| 3 | **Deino** (`DEINO`) | 44 | Scope Lens | Hustle *(slot 2, class default)* | Bite, Headbutt, Slam, Focus Energy |
| 4 | **Houndour** (`HOUNDOUR`) | 44 | Miracleberry | Flash Fire *(slot 2, class default)* | Snarl, Crunch, Fire Fang, Ember |

### ARCHER2 — Radio Tower 5F

**5 Pokémon, Lv. 41–43**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6315](data/trainers/parties.asm#L6315) · Map: [RadioTower5F.asm:L89](maps/RadioTower5F.asm#L89)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Zweilous** (`ZWEILOUS`) | 41 | Expert Belt | Hustle *(slot 2, class default)* | Crunch, Bite, Headbutt, Focus Energy |
| 2 | **Murkrow** (`MURKROW`) | 41 | Eviolite | Insomnia *(slot 2, class default)* | Foul Play, Drill Peck, Faint Attack, Wing Attack |
| 3 | **Weezing** (`WEEZING`) | 42 | Poison Barb | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Selfdestruct, Sludge, Toxic |
| 4 | **Weavile** (`WEAVILE`) | 42 | Expert Belt | Pressure *(slot 2, class default)* | Icicle Crash, Night Slash, Faint Attack, Nasty Plot |
| 5 | **Haunter** (`HAUNTER`) | 43 | Leftovers | Cursed Body *(slot 2, class default)* | Sludge Bomb, Shadow Ball, Dream Eater, Curse |


## Petrel Director

> **Group:** `PetrelDirectorGroup` · **Battle IDs:** `PETREL_DIRECTOR` · **1 parties**

### Petrel — Radio Tower 5F (`PETREL_DIRECTOR1`)

**5 Pokémon, Lv. 40–42**  
*held items, custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6342](data/trainers/parties.asm#L6342) · Map: [RadioTower5F.asm:L40](maps/RadioTower5F.asm#L40)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Bisharp** (`BISHARP`) | 40 | Miracleberry | Inner Focus *(slot 2, class default)* | Brick Break, Metal Claw, Slash, Low Sweep |
| 2 | **Umbreon** (`UMBREON`) | 40 | Miracleberry | Inner Focus *(slot 2, class default)* | Crunch, Double-Edge, Faint Attack, Moonlight |
| 3 | **Stantler** (`STANTLER`) | 41 | Scope Lens | Frisk *(slot 2, class default)* | Thrash, Take Down, Zen Headbutt, Calm Mind |
| 4 | **Sneasel** (`SNEASEL`) | 41 | Blackglasses | Inner Focus *(slot 2, class default)* | Crunch, Faint Attack, Crush Claw, Hone Claws |
| 5 | **Porygon2** (`PORYGON2`) | 42 | Quick Claw | Download *(slot 2, class default)* | Tri Attack, Thunderbolt, Psybeam, Recover |


## Hex Maniac

> **Group:** `HexManiacGroup` · **Battle IDs:** `HEX_MANIAC` · **3 parties**

### Winnie — Burned Tower 1F (`WINNIE`)

**4 Pokémon, Lv. 22–24**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L6369](data/trainers/parties.asm#L6369) · Map: [BurnedTower1F.asm:L128](maps/BurnedTower1F.asm#L128)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Shuppet** (`SHUPPET`) | 22 | — | Prankster *(hidden)* | Curse, Spite, Will-O-Wisp, Shadow Sneak |
| 2 | **Duskull** (`DUSKULL`) | 23 | — | Levitate *(slot 1)* | Astonish, Foresight, Shadow Sneak, Will-O-Wisp |
| 3 | **Gastly** (`GASTLY`) | 23 | — | Levitate *(slot 1)* | Confuse Ray, Hex, Curse, Sucker Punch |
| 4 | **Misdreavus** (`MISDREAVUS`) | 24 | — | Levitate *(slot 2)* | Psybeam, Confuse Ray, Drain Kiss, Pain Split |

### Odessa — Silent Crypt (`ODESSA`)

**3 Pokémon, Lv. 21–22**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L6385](data/trainers/parties.asm#L6385) · Map: [SilentCrypt.asm:L17](maps/SilentCrypt.asm#L17)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Duskull** (`DUSKULL`) | 21 | — | Levitate *(slot 1)* | Disable, Astonish, Foresight, Shadow Sneak |
| 2 | **Shuppet** (`SHUPPET`) | 22 | — | Prankster *(hidden)* | Curse, Spite, Will-O-Wisp, Shadow Sneak |
| 3 | **Drifloon** (`DRIFLOON`) | 22 | — | Aftermath *(slot 1)* | Minimize, Gust, Focus Energy, Hex |

### Lilith — Silent Crypt (`LILITH`)

**3 Pokémon, Lv. 21–23**  
*automatic level-up moves, explicit abilities*  
<sub>Source: [parties.asm:L6398](data/trainers/parties.asm#L6398) · Map: [SilentCrypt.asm:L28](maps/SilentCrypt.asm#L28)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gastly** (`GASTLY`) | 21 | — | Levitate *(slot 1)* | Smog, Confuse Ray, Hex, Curse |
| 2 | **Shuppet** (`SHUPPET`) | 21 | — | Prankster *(hidden)* | Night Shade, Curse, Spite, Will-O-Wisp |
| 3 | **Misdreavus** (`MISDREAVUS`) | 23 | — | Levitate *(slot 2)* | Psybeam, Confuse Ray, Drain Kiss, Pain Split |


## Cosplayer

> **Group:** `CosplayerGroup` · **Battle IDs:** `COSPLAYER` · **6 parties**

### Maya — Route 3, Route 4 (rematch) (`COSPLAYER1`)

**3 Pokémon, Lv. 69–70**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6414](data/trainers/parties.asm#L6414) · Map: no direct reference found</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeotto** (`PIDGEOTTO`) | 69 | — | Keen Eye *(slot 1, class default)* | Hurricane, Aerial Ace, Mirror Move, Brave Bird |
| 2 | **Sneasel** (`SNEASEL`) | 69 | — | Technician *(slot 1, class default)* | Hone Claws, Crunch, Foul Play, Dark Pulse |
| 3 | **Lickitung** (`LICKITUNG`) | 70 | — | Own Tempo *(slot 1, class default)* | Thrash, Screech, Power Whip, Belly Drum |

### Daisy — Route 3 (`COSPLAYER2`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6424](data/trainers/parties.asm#L6424) · Map: [Route3.asm:L59](maps/Route3.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ditto** (`DITTO`) | 69 | — | Imposter *(slot 1, class default)* | Transform |
| 2 | **Mimikyu** (`MIMIKYU`) | 69 | — | Disguise *(slot 1, class default)* | Shadow Claw, Play Rough, Phantomforce, Hone Claws |

### Mimi — Route 3 (`COSPLAYER3`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6434](data/trainers/parties.asm#L6434) · Map: [Route3.asm:L70](maps/Route3.asm#L70)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeot** (`PIDGEOT`) | 69 | — | No Guard *(slot 1, class default)* | Hurricane, Swift, Roost, Quick Attack |
| 2 | **Mr. Rime** (`MR__RIME`) | 69 | — | Tangled Feet *(slot 1, class default)* | Ice Beam, Psychic, Shadow Ball, Sucker Punch |

### Pearl — Route 4 (`COSPLAYER4`)

**2 Pokémon, Lv. 69–70**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6444](data/trainers/parties.asm#L6444) · Map: [Route4.asm:L48](maps/Route4.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Clefable** (`CLEFABLE`) | 69 | — | Cute Charm *(slot 1, class default)* | Moonblast, Fire Blast, Ice Beam, Moonlight |
| 2 | **Mimikyu** (`MIMIKYU`) | 70 | — | Disguise *(slot 1, class default)* | Shadow Claw, Play Rough, Phantomforce, Hone Claws |

### Pixie — Route 4 (`COSPLAYER5`)

**2 Pokémon, Lv. 69**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6454](data/trainers/parties.asm#L6454) · Map: [Route4.asm:L59](maps/Route4.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Golduck** (`GOLDUCK`) | 69 | — | Hydration *(slot 1, class default)* | Hydro Pump, Psychic, Ice Beam, Aqua Jet |
| 2 | **Tauros** (`TAUROS`) | 69 | — | Intimidate *(slot 1, class default)* | Raging Bull, Earthquake, Megahorn, Iron Head |

### Noelle — Route 25 (Nugget Bridge 1) (`COSPLAYER6`)

**3 Pokémon, Lv. 58–59**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6464](data/trainers/parties.asm#L6464) · Map: [Route25.asm:L415](maps/Route25.asm#L415)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Exeggutor** (`EXEGGUTOR`) | 58 | — | Chlorophyll *(slot 1, class default)* | Leaf Storm, Psychic, Sludge Bomb, Synthesis |
| 2 | **Raichu** (`RAICHU_ALOLAN`) | 59 | — | Lightning Rod *(slot 1, class default)* | Thunderbolt, Psychic, Surf, Quick Attack |
| 3 | **Glaceon** (`GLACEON`) | 59 | — | Snow Cloak *(slot 1, class default)* | Ice Beam, Earth Power, Extrasensory, Ice Shard |


## Ninja

> **Group:** `NinjaGroup` · **Battle IDs:** `NINJA` · **4 parties**

### Kane — Fuchsia Gym (`NINJA1`)

**3 Pokémon, Lv. 66–67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6480](data/trainers/parties.asm#L6480) · Map: [FuchsiaGym.asm:L76](maps/FuchsiaGym.asm#L76)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Arbok** (`ARBOK`) | 66 | — | Shed Skin *(slot 2, class default)* | Gunk Shot, Sludge Bomb, Crunch, Glare |
| 2 | **Golbat** (`GOLBAT`) | 67 | — | Frisk *(slot 2, class default)* | Brave Bird, Cross Poison, Wing Attack, Nasty Plot |
| 3 | **Tentacruel** (`TENTACRUEL`) | 67 | — | Rain Dish *(slot 2, class default)* | Hydro Pump, Surf, Sludge Bomb, Toxic Spikes |

### Shiro — Fuchsia Gym (`NINJA2`)

**3 Pokémon, Lv. 67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6493](data/trainers/parties.asm#L6493) · Map: [FuchsiaGym.asm:L110](maps/FuchsiaGym.asm#L110)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Vileplume** (`VILEPLUME`) | 67 | — | Poison Puppeteer *(slot 2, class default)* | Leaf Storm, Earth Power, Giga Drain, Toxic |
| 2 | **Golbat** (`GOLBAT`) | 67 | — | Frisk *(slot 2, class default)* | Brave Bird, Cross Poison, Wing Attack, Nasty Plot |
| 3 | **Muk** (`MUK_ALOLAN`) | 67 | — | Gluttony *(slot 2, class default)* | Gunk Shot, Crunch, Poison Jab, Toxic |

### Kaede — Fuchsia Gym (`NINJA3`)

**3 Pokémon, Lv. 66–68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6506](data/trainers/parties.asm#L6506) · Map: [FuchsiaGym.asm:L144](maps/FuchsiaGym.asm#L144)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Nidoqueen** (`NIDOQUEEN`) | 66 | — | Mold Breaker *(slot 2, class default)* | Poison Jab, Drill Run, Cross Poison, Toxic Spikes |
| 2 | **Muk** (`MUK`) | 67 | — | Sticky Hold *(slot 2, class default)* | Gunk Shot, Poison Jab, Moonblast, Toxic |
| 3 | **Crobat** (`CROBAT`) | 68 | — | Frisk *(slot 2, class default)* | Brave Bird, Cross Poison, Wing Attack, Nasty Plot |

### Ryu — Fuchsia Gym (`NINJA4`)

**3 Pokémon, Lv. 66–68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6519](data/trainers/parties.asm#L6519) · Map: [FuchsiaGym.asm:L178](maps/FuchsiaGym.asm#L178)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Venomoth** (`VENOMOTH`) | 66 | — | Compound Eyes *(slot 2, class default)* | Bug Buzz, Signal Beam, Psychic, Quiver Dance |
| 2 | **Muk** (`MUK`) | 67 | — | Sticky Hold *(slot 2, class default)* | Gunk Shot, Poison Jab, Moonblast, Toxic |
| 3 | **Seviper** (`SEVIPER`) | 68 | — | Intimidate *(slot 2, class default)* | Gunk Shot, Foul Play, Crunch, Swords Dance |


## Agatha

> **Group:** `AgathaGroup` · **Battle IDs:** `AGATHA` · **1 parties**

### Agatha — Silver Cave Outside (`AGATHA1`)

**6 Pokémon, Lv. 77–79**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6535](data/trainers/parties.asm#L6535) · Map: [SilverCaveOutside.asm:L34](maps/SilverCaveOutside.asm#L34)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gengar** (`GENGAR`) | 77 | Focus Sash | Levitate *(slot 1)* | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| 2 | **Misdreavus** (`MISDREAVUS`) | 78 | Eviolite | Prankster *(hidden)* | Will-O-Wisp, Shadow Ball, Confuse Ray, Pain Split |
| 3 | **Arbok** (`ARBOK`) | 78 | Leftovers | Intimidate *(slot 1)* | Gunk Shot, Crunch, Earthquake, Glare |
| 4 | **Crobat** (`CROBAT`) | 79 | Leftovers | Infiltrator *(hidden)* | Cross Poison, Brave Bird, U-Turn, Roost |
| 5 | **Haunter** (`HAUNTER`) | 79 | Spell Tag | Levitate *(slot 1)* | Hypnosis, Shadow Ball, Sludge Bomb, Dream Eater |
| 6 | **Gengar** (`GENGAR`) | 79 | Life Orb | Levitate *(slot 1)* | Nasty Plot, Shadow Ball, Sludge Bomb, Focus Blast |


## Lorelei

> **Group:** `LoreleiGroup` · **Battle IDs:** `LORELEI` · **1 parties**

### Lorelei — Silver Cave Outside (`LORELEI1`)

**6 Pokémon, Lv. 77–79**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6572](data/trainers/parties.asm#L6572) · Map: [SilverCaveOutside.asm:L70](maps/SilverCaveOutside.asm#L70)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Dewgong** (`DEWGONG`) | 77 | Leftovers | Thick Fat *(slot 1)* | Surf, Ice Beam, Rest, Sleep Talk |
| 2 | **Cloyster** (`CLOYSTER`) | 78 | Life Orb | Skill Link *(slot 1)* | Shell Smash, Icicle Spear, Rock Blast, Ice Shard |
| 3 | **Slowbro** (`SLOWBRO`) | 78 | Leftovers | Regenerator *(hidden)* | Calm Mind, Surf, Psychic, Slack Off |
| 4 | **Jynx** (`JYNX`) | 79 | Wise Glasses | Oblivious *(slot 1)* | Nasty Plot, Ice Beam, Psychic, Lovely Kiss |
| 5 | **Lapras** (`LAPRAS`) | 79 | Assault Vest | Water Absorb *(slot 1)* | Ice Beam, Surf, Thunderbolt, Freeze-Dry |
| 6 | **Articuno** (`ARTICUNO`) | 79 | Leftovers | Pressure *(slot 1)* | Ice Beam, Hurricane, Freeze-Dry, Roost |


## Red2

> **Group:** `Red2Group` · **Battle IDs:** `RED2` · **1 parties**

###  — Pallet Town (`RED2_1`)

**6 Pokémon, Lv. 83–85**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6609](data/trainers/parties.asm#L6609) · Map: [PalletTown.asm:L43](maps/PalletTown.asm#L43)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pikachu** (`PIKACHU`) | 83 | Light Ball | Galvanize *(hidden)* | Extremespeed, Hyper Voice, Surf, Nasty Plot |
| 2 | **Snorlax** (`SNORLAX`) | 84 | Leftovers | Thick Fat *(slot 1)* | Curse, Body Slam, Earthquake, Rest |
| 3 | **Espeon** (`ESPEON`) | 84 | Life Orb | Magic Bounce *(hidden)* | Psychic, Shadow Ball, Dazzle Gleam, Calm Mind |
| 4 | **Lapras** (`LAPRAS`) | 85 | Assault Vest | Water Absorb *(slot 1)* | Freeze-Dry, Ice Beam, Thunderbolt, Body Slam |
| 5 | **Victreebel** (`VICTREEBEL`) | 85 | Life Orb | Poison Puppeteer *(slot 2)* | Power Whip, Sludge Bomb, Sucker Punch, Swords Dance |
| 6 | **Charizard** (`CHARIZARD`) | 85 | Life Orb | Drought *(hidden)* | Fire Blast, Solarbeam, Air Slash, Dragon Pulse |


## Blue Cloak

> **Group:** `BlueCloakGroup` · **Battle IDs:** `BLUE_CLOAK` · **1 parties**

###  — Cinnabar Island (`BLUE_CLOAK1`)

**6 Pokémon, Lv. 82–84**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6646](data/trainers/parties.asm#L6646) · Map: [CinnabarIsland.asm:L47](maps/CinnabarIsland.asm#L47)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Pidgeot** (`PIDGEOT`) | 82 | Life Orb | No Guard *(slot 1)* | Hurricane, Heat Wave, U-Turn, Roost |
| 2 | **Scizor** (`SCIZOR`) | 83 | Life Orb | Technician *(slot 1)* | Bullet Punch, X-Scissor, U-Turn, Swords Dance |
| 3 | **Rhyperior** (`RHYPERIOR`) | 83 | Life Orb | Sheer Force *(hidden)* | Bulldoze, Rock Slide, Ice Punch, Thunderpunch |
| 4 | **Exeggutor** (`EXEGGUTOR`) | 84 | Gold Berry | Harvest *(hidden)* | Psychic, Giga Drain, Leech Seed, Substitute |
| 5 | **Electivire** (`ELECTIVIRE`) | 84 | Life Orb | Sheer Force *(slot 2)* | Thunderpunch, Ice Punch, Fire Punch, Crunch |
| 6 | **Blastoise** (`BLASTOISE`) | 84 | Life Orb | Mega Launcher *(slot 1)* | Water Pulse, Aura Sphere, Dark Pulse, Dragon Pulse |


## Green

> **Group:** `GreenGroup` · **Battle IDs:** `GREEN` · **1 parties**

###  — Route 20 (`GREEN1`)

**6 Pokémon, Lv. 80–82**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6683](data/trainers/parties.asm#L6683) · Map: [Route20.asm:L59](maps/Route20.asm#L59)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Wigglytuff** (`WIGGLYTUFF`) | 80 | Life Orb | Magic Guard *(slot 1)* | Hyper Voice, Dazzle Gleam, Thunderbolt, Ice Beam |
| 2 | **Umbreon** (`UMBREON`) | 81 | Leftovers | Synchronize *(slot 1)* | Foul Play, Toxic, Moonlight, Pursuit |
| 3 | **Nidoqueen** (`NIDOQUEEN`) | 81 | Life Orb | Sheer Force *(hidden)* | Earth Power, Sludge Bomb, Ice Beam, Flamethrower |
| 4 | **Mesmeria** (`MESMERIA`) | 82 | Leftovers | Bad Dreams *(hidden)* | Hypnosis, Psychic, Ice Beam, Dream Eater |
| 5 | **Lanturn** (`LANTURN`) | 82 | Assault Vest | Volt Absorb *(slot 1)* | Surf, Thunderbolt, Ice Beam, Flash Cannon |
| 6 | **Venusaur** (`VENUSAUR`) | 82 | Leftovers | Thick Fat *(hidden)* | Giga Drain, Sludge Bomb, Sleep Powder, Synthesis |


## Battle Girl

> **Group:** `BattleGirlGroup` · **Battle IDs:** `BATTLE_GIRL` · **2 parties**

### Miho — Route 7 (`BATTLE_GIRL1`)

**3 Pokémon, Lv. 59–63**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6720](data/trainers/parties.asm#L6720) · Map: [Route7.asm:L11](maps/Route7.asm#L11)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Sneasler** (`SNEASLER`) | 59 | — | Poison Touch *(slot 2, class default)* | Close Combat, Dire Claw, Poison Jab, Swords Dance |
| 2 | **Annihilape** (`ANNIHILAPE`) | 62 | — | Inner Focus *(slot 2, class default)* | Superpower, Close Combat, Foul Play, Work Up |
| 3 | **Hitmontop** (`HITMONTOP`) | 63 | — | Intimidate *(slot 2, class default)* | Close Combat, Body Press, Sucker Punch, Agility |

### Aya — Route 7 (`BATTLE_GIRL2`)

**3 Pokémon, Lv. 64**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6733](data/trainers/parties.asm#L6733) · Map: [Route7.asm:L22](maps/Route7.asm#L22)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Hitmonlee** (`HITMONLEE`) | 64 | — | Limber *(slot 2, class default)* | Superpower, Close Combat, Double-Edge, Focus Energy |
| 2 | **Electivire** (`ELECTIVIRE`) | 64 | — | Sheer Force *(slot 2, class default)* | Close Combat, Wild Charge, Giga Impact, Thunder Wave |
| 3 | **Lucario** (`LUCARIO`) | 64 | — | Inner Focus *(slot 2, class default)* | Aura Sphere, Close Combat, Dragon Pulse, Calm Mind |


## Tamer

> **Group:** `TamerGroup` · **Battle IDs:** `TAMER` · **3 parties**

### Cole — Route 18 (`TAMER1`)

**3 Pokémon, Lv. 67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6749](data/trainers/parties.asm#L6749) · Map: [Route18.asm:L36](maps/Route18.asm#L36)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tyranitar** (`TYRANITAR`) | 67 | — | Sand Stream *(slot 2, class default)* | Foul Play, Stone Edge, Superpower, Dragon Dance |
| 2 | **Snorlax** (`SNORLAX`) | 67 | — | Immunity *(slot 2, class default)* | Giga Impact, Double-Edge, Superpower, Slack Off |
| 3 | **Dragonite** (`DRAGONITE`) | 67 | — | Shed Skin *(slot 2, class default)* | Outrage, Wing Attack, Extremespeed, Dragon Dance |

### Jax — Route 18 (`TAMER2`)

**3 Pokémon, Lv. 66–67**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6762](data/trainers/parties.asm#L6762) · Map: [Route18.asm:L47](maps/Route18.asm#L47)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tauros** (`TAUROS`) | 66 | — | Anger Point *(slot 2, class default)* | Raging Bull, Double-Edge, Earthquake, Iron Head |
| 2 | **Tauros** (`TAUROS_PALDEAN_FIRE`) | 67 | — | Anger Point *(slot 2, class default)* | Raging Bull, Flare Blitz, Close Combat, Earthquake |
| 3 | **Tauros** (`TAUROS_PALDEAN_WATER`) | 67 | — | Anger Point *(slot 2, class default)* | Raging Bull, Liquidation, Close Combat, Aqua Jet |

### Rigby — Route 18 (`TAMER3`)

**3 Pokémon, Lv. 66–68**  
*custom moves, class-default abilities*  
<sub>Source: [parties.asm:L6775](data/trainers/parties.asm#L6775) · Map: [Route18.asm:L58](maps/Route18.asm#L58)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Tauros** (`TAUROS`) | 66 | — | Anger Point *(slot 2, class default)* | Giga Impact, Double-Edge, Superpower, Rest |
| 2 | **Kleavor** (`KLEAVOR`) | 67 | — | Sheer Force *(slot 2, class default)* | X-Scissor, Rock Slide, Sacred Sword, Swords Dance |
| 3 | **Persian** (`PERSIAN`) | 68 | — | Limber *(slot 2, class default)* | Double-Edge, Crush Claw, Play Rough, Nasty Plot |


## Team Rocket Grunt F

> **Group:** `GruntFGroup` · **Battle IDs:** `GRUNTF` · **16 parties**


### GRUNTF_1 — Slowpoke Well B1F

**2 Pokémon, Lv. 13–15**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6793](data/trainers/parties.asm#L6793) · Map: [SlowpokeWellB1F.asm:L86](maps/SlowpokeWellB1F.asm#L86)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Zubat** (`ZUBAT`) | 13 | — | Frisk *(slot 2, class default)* | Astonish, Bite, Wing Attack, Poison Fang |
| 2 | **Ekans** (`EKANS`) | 15 | — | Shed Skin *(slot 2, class default)* | Poison Sting, Bite, Acid, Glare |

### GRUNTF_2 — Radio Tower 2F

**2 Pokémon, Lv. 41**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6801](data/trainers/parties.asm#L6801) · Map: [RadioTower2F.asm:L90](maps/RadioTower2F.asm#L90)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Stantler** (`STANTLER`) | 41 | — | Frisk *(slot 2, class default)* | Calm Mind, Work Up, Zen Headbutt, Thrash |
| 2 | **Seviper** (`SEVIPER`) | 41 | — | Intimidate *(slot 2, class default)* | Haze, Cross Poison, Dragon Tail, Foul Play |

### GRUNTF_3 — Goldenrod Underground Switch Room Entrances

**4 Pokémon, Lv. 38–39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6809](data/trainers/parties.asm#L6809) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L267](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L267)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Aipom** (`AIPOM`) | 38 | — | Pickup *(slot 2, class default)* | Swift, Screech, Bounce, Agility |
| 2 | **Dunsparce** (`DUNSPARCE`) | 38 | — | Rattled *(slot 2, class default)* | Dig, Glare, Double-Edge, Air Slash |
| 3 | **Stantler** (`STANTLER`) | 38 | — | Frisk *(slot 2, class default)* | Calm Mind, Work Up, Zen Headbutt, Thrash |
| 4 | **Houndoom** (`HOUNDOOM`) | 39 | — | Flash Fire *(slot 2, class default)* | Snarl, Flamethrower, Sucker Punch, Dark Pulse |

### GRUNTF_4 — Radio Tower 4F

**4 Pokémon, Lv. 39–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6821](data/trainers/parties.asm#L6821) · Map: [RadioTower4F.asm:L79](maps/RadioTower4F.asm#L79)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weezing** (`WEEZING_GALARIAN`) | 39 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Destiny Bond, Toxic, Dark Pulse |
| 2 | **Murkrow** (`MURKROW`) | 40 | — | Insomnia *(slot 2, class default)* | Faint Attack, Dark Pulse, Foul Play, Brave Bird |
| 3 | **Nidorina** (`NIDORINA`) | 40 | — | Rivalry *(slot 2, class default)* | Bite, Toxic Spikes, Poison Jab, Crunch |
| 4 | **Persian** (`PERSIAN`) | 40 | — | Limber *(slot 2, class default)* | Power Gem, Crush Claw, Hypnosis, Nasty Plot |

### GRUNTF_5 — Team Rocket Base B3F

**2 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6833](data/trainers/parties.asm#L6833) · Map: [TeamRocketBaseB3F.asm:L133](maps/TeamRocketBaseB3F.asm#L133)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Qwilfish** (`QWILFISH`) | 36 | — | Swift Swim *(slot 2, class default)* | Toxic Spikes, Poison Jab, Aqua Tail, Pin Missile |
| 2 | **Misdreavus** (`MISDREAVUS`) | 36 | — | Levitate *(slot 2, class default)* | Perish Song, Power Gem, Moonblast, Foul Play |

### GRUNTF_6 — Radio Tower 1F

**3 Pokémon, Lv. 40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6840](data/trainers/parties.asm#L6840) · Map: [RadioTower1F.asm:L187](maps/RadioTower1F.asm#L187)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Salazzle** (`SALAZZLE`) | 40 | — | Poison Puppeteer *(slot 2, class default)* | Fire Spin, Nasty Plot, Poison Fang, Cross Poison |
| 2 | **Scolipede** (`SCOLIPEDE`) | 40 | — | Swarm *(slot 2, class default)* | Venoshock, Take Down, Agility, Toxic |
| 3 | **Ariados** (`ARIADOS`) | 40 | — | Sniper *(slot 2, class default)* | Poison Jab, Signal Beam, Sucker Punch, Cross Poison |

### GRUNTF_7 — Radio Tower 2F

**3 Pokémon, Lv. 40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6850](data/trainers/parties.asm#L6850) · Map: [RadioTower2F.asm:L68](maps/RadioTower2F.asm#L68)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gengar** (`GENGAR`) | 40 | — | Cursed Body *(slot 2, class default)* | Shadow Punch, Shadow Ball, Sludge Bomb, Dream Eater |
| 2 | **Qwilfish** (`QWILFISH`) | 40 | — | Swift Swim *(slot 2, class default)* | Aqua Tail, Pin Missile, Cross Poison, Take Down |
| 3 | **Lickitung** (`LICKITUNG`) | 40 | — | Oblivious *(slot 2, class default)* | Slam, Rollout, Zen Headbutt, Body Slam |

### GRUNTF_8 — Radio Tower 3F

**2 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6860](data/trainers/parties.asm#L6860) · Map: [RadioTower3F.asm:L95](maps/RadioTower3F.asm#L95)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gengar** (`GENGAR`) | 38 | — | Cursed Body *(slot 2, class default)* | Shadow Punch, Shadow Ball, Sludge Bomb, Dream Eater |
| 2 | **Weezing** (`WEEZING`) | 38 | — | Neutralizing Gas *(slot 2, class default)* | Sludge Bomb, Destiny Bond, Toxic, Dark Pulse |

### GRUNTF_9 — Radio Tower 3F

**2 Pokémon, Lv. 39**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6868](data/trainers/parties.asm#L6868) · Map: [RadioTower3F.asm:L106](maps/RadioTower3F.asm#L106)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Ariados** (`ARIADOS`) | 39 | — | Sniper *(slot 2, class default)* | Poison Jab, Signal Beam, Sucker Punch, Cross Poison |
| 2 | **Gengar** (`GENGAR`) | 39 | — | Cursed Body *(slot 2, class default)* | Shadow Punch, Shadow Ball, Sludge Bomb, Dream Eater |

### GRUNTF_10 — Goldenrod Underground Switch Room Entrances

**2 Pokémon, Lv. 39–40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6876](data/trainers/parties.asm#L6876) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L212](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L212)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Scrafty** (`SCRAFTY`) | 39 | — | Moxie *(slot 2, class default)* | Brick Break, Snarl, Swagger, Circle Throw |
| 2 | **Piloswine** (`PILOSWINE`) | 40 | — | Oblivious *(slot 2, class default)* | Fury Attack, Earthquake, Freeze-Dry, Thrash |

### GRUNTF_11 — Team Rocket Base B1F

**1 Pokémon, Lv. 37**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6884](data/trainers/parties.asm#L6884) · Map: [TeamRocketBaseB1F.asm:L493](maps/TeamRocketBaseB1F.asm#L493)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Weepinbell** (`WEEPINBELL`) | 37 | — | Poison Puppeteer *(slot 2, class default)* | Leech Life, Poison Jab, Seed Bomb, Knock Off |

### GRUNTF_12 — Team Rocket Base B2F

**1 Pokémon, Lv. 36**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6890](data/trainers/parties.asm#L6890) · Map: [TeamRocketBaseB2F.asm:L190](maps/TeamRocketBaseB2F.asm#L190)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Misdreavus** (`MISDREAVUS`) | 36 | — | Levitate *(slot 2, class default)* | Perish Song, Power Gem, Moonblast, Foul Play |

### GRUNTF_13 — Team Rocket Base B2F

**1 Pokémon, Lv. 38**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6896](data/trainers/parties.asm#L6896) · Map: [TeamRocketBaseB2F.asm:L212](maps/TeamRocketBaseB2F.asm#L212)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Seviper** (`SEVIPER`) | 38 | — | Intimidate *(slot 2, class default)* | Poison Jab, Snarl, Crunch, Sludge Bomb |

### GRUNTF_14 — Goldenrod Underground Warehouse

**1 Pokémon, Lv. 40**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6902](data/trainers/parties.asm#L6902) · Map: [GoldenrodUndergroundWarehouse.asm:L37](maps/GoldenrodUndergroundWarehouse.asm#L37)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Qwilfish** (`QWILFISH`) | 40 | — | Swift Swim *(slot 2, class default)* | Aqua Tail, Pin Missile, Cross Poison, Take Down |

### GRUNTF_15 — Slowpoke Well B1F

**2 Pokémon, Lv. 13**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6908](data/trainers/parties.asm#L6908) · Map: [SlowpokeWellB1F.asm:L21](maps/SlowpokeWellB1F.asm#L21)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Mareanie** (`MAREANIE`) | 13 | — | Limber *(slot 2, class default)* | Peck, Poison Sting, Bite |
| 2 | **Weedle** (`WEEDLE`) | 13 | — | Shield Dust *(slot 2, class default)* | String Shot, Poison Sting, Bug Bite |

### GRUNTF_GOLDENROD_RIOLU — Goldenrod Underground

**2 Pokémon, Lv. 21**  
*automatic level-up moves, class-default abilities*  
<sub>Source: [parties.asm:L6916](data/trainers/parties.asm#L6916) · Map: [GoldenrodUnderground.asm:L486](maps/GoldenrodUnderground.asm#L486)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Croagunk** (`CROAGUNK`) | 21 | — | Dry Skin *(slot 2, class default)* | Faint Attack, Low Kick, Low Sweep, Venoshock |
| 2 | **Grimer** (`GRIMER`) | 21 | — | Sticky Hold *(slot 2, class default)* | Disable, Sludge, Smog, Minimize |


## Rival — Main Story

> **Group:** `Rival1Group` · **Battle IDs:** `RIVAL1` · **15 parties**


### RIVAL1_1_CHIKORITA — Cherrygrove City

**1 Pokémon, Lv. 5**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6932](data/trainers/parties.asm#L6932) · Map: [CherrygroveCity.asm:L150](maps/CherrygroveCity.asm#L150)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chikorita** (`CHIKORITA`) | 5 | Berry | Serene Grace *(slot 1)* | Tackle, Growl |

### RIVAL1_1_CYNDAQUIL — Cherrygrove City

**1 Pokémon, Lv. 5**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6941](data/trainers/parties.asm#L6941) · Map: [CherrygroveCity.asm:L161](maps/CherrygroveCity.asm#L161)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Cyndaquil** (`CYNDAQUIL`) | 5 | Berry | Adaptability *(slot 1)* | Tackle, Leer |

### RIVAL1_1_TOTODILE — Cherrygrove City

**1 Pokémon, Lv. 5**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6950](data/trainers/parties.asm#L6950) · Map: [CherrygroveCity.asm:L139](maps/CherrygroveCity.asm#L139)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Totodile** (`TOTODILE`) | 5 | Berry | Sheer Force *(hidden)* | Scratch, Leer |

### RIVAL1_2_CHIKORITA — Azalea Town

**3 Pokémon, Lv. 14–16**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6959](data/trainers/parties.asm#L6959) · Map: [AzaleaTown.asm:L82](maps/AzaleaTown.asm#L82)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 14 | — | Immunity *(slot 1)* | Quick Attack, Sand-Attack, Wing Attack, Bulldoze |
| 2 | **Magnemite** (`MAGNEMITE`) | 15 | — | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Bayleef** (`BAYLEEF`) | 16 | Berry | Serene Grace *(slot 1)* | Razor Leaf, Tackle, Leech Seed, Reflect |

### RIVAL1_2_CYNDAQUIL — Azalea Town

**3 Pokémon, Lv. 14–16**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6978](data/trainers/parties.asm#L6978) · Map: [AzaleaTown.asm:L91](maps/AzaleaTown.asm#L91)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 14 | — | Immunity *(slot 1)* | Quick Attack, Sand-Attack, Wing Attack, Bulldoze |
| 2 | **Magnemite** (`MAGNEMITE`) | 15 | — | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Quilava** (`QUILAVA`) | 16 | Berry | Adaptability *(slot 1)* | Ember, Quick Attack, Smokescreen, Leer |

### RIVAL1_2_TOTODILE — Azalea Town

**3 Pokémon, Lv. 14–16**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L6997](data/trainers/parties.asm#L6997) · Map: [AzaleaTown.asm:L73](maps/AzaleaTown.asm#L73)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 14 | — | Immunity *(slot 1)* | Quick Attack, Sand-Attack, Wing Attack, Bulldoze |
| 2 | **Magnemite** (`MAGNEMITE`) | 15 | — | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Croconaw** (`CROCONAW`) | 16 | Berry | Sheer Force *(hidden)* | Water Gun, Bite, Rage, Leer |

### RIVAL1_3_CHIKORITA — Burned Tower 1F

**4 Pokémon, Lv. 22–24**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7016](data/trainers/parties.asm#L7016) · Map: [BurnedTower1F.asm:L83](maps/BurnedTower1F.asm#L83)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 22 | — | Immunity *(slot 1)* | Wing Attack, Bulldoze, Quick Attack, Sand-Attack |
| 2 | **Magnemite** (`MAGNEMITE`) | 22 | Magnet | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Slowpoke** (`SLOWPOKE`) | 23 | — | Unaware *(slot 2)* | Confusion, Water Gun, Headbutt, Disable |
| 4 | **Bayleef** (`BAYLEEF`) | 24 | Berry | Serene Grace *(slot 1)* | Mega Drain, Razor Leaf, Tackle, Leech Seed |

### RIVAL1_3_CYNDAQUIL — Burned Tower 1F

**4 Pokémon, Lv. 22–24**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7040](data/trainers/parties.asm#L7040) · Map: [BurnedTower1F.asm:L92](maps/BurnedTower1F.asm#L92)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 22 | — | Immunity *(slot 1)* | Wing Attack, Bulldoze, Quick Attack, Sand-Attack |
| 2 | **Magnemite** (`MAGNEMITE`) | 22 | Magnet | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Slowpoke** (`SLOWPOKE`) | 23 | — | Unaware *(slot 2)* | Confusion, Water Gun, Headbutt, Disable |
| 4 | **Quilava** (`QUILAVA`) | 24 | Berry | Adaptability *(slot 1)* | Flame Wheel, Dig, Quick Attack, Smokescreen |

### RIVAL1_3_TOTODILE — Burned Tower 1F

**4 Pokémon, Lv. 22–24**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7064](data/trainers/parties.asm#L7064) · Map: [BurnedTower1F.asm:L74](maps/BurnedTower1F.asm#L74)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gligar** (`GLIGAR`) | 22 | — | Immunity *(slot 1)* | Wing Attack, Bulldoze, Quick Attack, Sand-Attack |
| 2 | **Magnemite** (`MAGNEMITE`) | 22 | Magnet | Levitate *(hidden)* | Thundershock, Sonicboom, Thunder Wave, Swift |
| 3 | **Slowpoke** (`SLOWPOKE_GALARIAN`) | 23 | — | Unaware *(slot 2)* | Confusion, Acid, Headbutt, Disable |
| 4 | **Croconaw** (`CROCONAW`) | 24 | Berry | Sheer Force *(hidden)* | Bite, Ice Punch, Water Gun, Mud-Slap |

### RIVAL1_4_CHIKORITA — Goldenrod Underground Switch Room Entrances

**6 Pokémon, Lv. 40–42**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7088](data/trainers/parties.asm#L7088) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L188](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L188)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 40 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 41 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 41 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 41 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 41 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Meganium** (`MEGANIUM`) | 42 | Miracle Seed | Mega Sol *(slot 2)* | Giga Drain, Body Slam, Synthesis, Reflect |

### RIVAL1_4_CYNDAQUIL — Goldenrod Underground Switch Room Entrances

**6 Pokémon, Lv. 40–42**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7122](data/trainers/parties.asm#L7122) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L197](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L197)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 40 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 41 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 41 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 41 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Gengar** (`GENGAR`) | 41 | Spell Tag | Levitate *(slot 1)* | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| 6 | **Typhlosion** (`TYPHLOSION`) | 42 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Thunderpunch, Earth Power, Quick Attack |

### RIVAL1_4_TOTODILE — Goldenrod Underground Switch Room Entrances

**6 Pokémon, Lv. 40–42**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7156](data/trainers/parties.asm#L7156) · Map: [GoldenrodUndergroundSwitchRoomEntrances.asm:L179](maps/GoldenrodUndergroundSwitchRoomEntrances.asm#L179)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 40 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 41 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING_GALARIAN`) | 41 | Leftovers | Unaware *(slot 2)* | Psychic, Sludge Bomb, Flamethrower, Recover |
| 4 | **Weavile** (`WEAVILE`) | 41 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 41 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Feraligatr** (`FERALIGATR`) | 42 | Mystic Water | Sheer Force *(hidden)* | Waterfall, Ice Punch, Crunch, Rock Slide |

### RIVAL1_5_CHIKORITA — Victory Road

**6 Pokémon, Lv. 48–51**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7190](data/trainers/parties.asm#L7190) · Map: [VictoryRoad.asm:L78](maps/VictoryRoad.asm#L78)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 48 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 49 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 49 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 49 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 49 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Meganium** (`MEGANIUM`) | 51 | Miracle Seed | Mega Sol *(slot 2)* | Giga Drain, Body Slam, Synthesis, Reflect |

### RIVAL1_5_CYNDAQUIL — Victory Road

**6 Pokémon, Lv. 48–51**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7224](data/trainers/parties.asm#L7224) · Map: [VictoryRoad.asm:L87](maps/VictoryRoad.asm#L87)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 48 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 49 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 49 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 49 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Gengar** (`GENGAR`) | 49 | Spell Tag | Levitate *(slot 1)* | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| 6 | **Typhlosion** (`TYPHLOSION`) | 51 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Thunderpunch, Earth Power, Quick Attack |

### RIVAL1_5_TOTODILE — Victory Road

**6 Pokémon, Lv. 48–51**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7258](data/trainers/parties.asm#L7258) · Map: [VictoryRoad.asm:L69](maps/VictoryRoad.asm#L69)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 48 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 49 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING_GALARIAN`) | 49 | Leftovers | Unaware *(slot 2)* | Psychic, Sludge Bomb, Flamethrower, Recover |
| 4 | **Weavile** (`WEAVILE`) | 49 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 49 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Feraligatr** (`FERALIGATR`) | 51 | Mystic Water | Sheer Force *(hidden)* | Waterfall, Ice Punch, Crunch, Rock Slide |


## Rival — Postgame

> **Group:** `Rival2Group` · **Battle IDs:** `RIVAL2`, `RIVAL3` · **6 parties**


### RIVAL2_1_CHIKORITA — Mount Moon

**6 Pokémon, Lv. 65–69**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7295](data/trainers/parties.asm#L7295) · Map: [MountMoon.asm:L48](maps/MountMoon.asm#L48)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 65 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 66 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 67 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 67 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 67 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Meganium** (`MEGANIUM`) | 69 | Miracle Seed | Mega Sol *(slot 2)* | Giga Drain, Body Slam, Synthesis, Reflect |

### RIVAL2_1_CYNDAQUIL — Mount Moon

**6 Pokémon, Lv. 65–69**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7329](data/trainers/parties.asm#L7329) · Map: [MountMoon.asm:L57](maps/MountMoon.asm#L57)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 65 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 66 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 67 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 67 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Gengar** (`GENGAR`) | 67 | Spell Tag | Levitate *(slot 1)* | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| 6 | **Typhlosion** (`TYPHLOSION`) | 69 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Thunderpunch, Earth Power, Quick Attack |

### RIVAL2_1_TOTODILE — Mount Moon

**6 Pokémon, Lv. 65–69**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7363](data/trainers/parties.asm#L7363) · Map: [MountMoon.asm:L39](maps/MountMoon.asm#L39)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 65 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 66 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING_GALARIAN`) | 67 | Leftovers | Unaware *(slot 2)* | Psychic, Sludge Bomb, Flamethrower, Recover |
| 4 | **Weavile** (`WEAVILE`) | 67 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 67 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Feraligatr** (`FERALIGATR`) | 69 | Mystic Water | Sheer Force *(hidden)* | Waterfall, Ice Punch, Crunch, Rock Slide |

### RIVAL2_2_CHIKORITA — Indigo Plateau Pokémon Center 1F

**6 Pokémon, Lv. 77–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7397](data/trainers/parties.asm#L7397) · Map: [IndigoPlateauPokecenter1F.asm:L107](maps/IndigoPlateauPokecenter1F.asm#L107)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 77 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 78 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 78 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 78 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 78 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Meganium** (`MEGANIUM`) | 80 | Miracle Seed | Mega Sol *(slot 2)* | Giga Drain, Body Slam, Synthesis, Reflect |

### RIVAL2_2_CYNDAQUIL — Indigo Plateau Pokémon Center 1F

**6 Pokémon, Lv. 77–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7431](data/trainers/parties.asm#L7431) · Map: [IndigoPlateauPokecenter1F.asm:L116](maps/IndigoPlateauPokecenter1F.asm#L116)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 77 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 78 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING`) | 78 | Leftovers | Unaware *(slot 2)* | Surf, Psychic, Ice Beam, Recover |
| 4 | **Weavile** (`WEAVILE`) | 78 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Gengar** (`GENGAR`) | 78 | Spell Tag | Levitate *(slot 1)* | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| 6 | **Typhlosion** (`TYPHLOSION`) | 80 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Thunderpunch, Earth Power, Quick Attack |

### RIVAL2_2_TOTODILE — Indigo Plateau Pokémon Center 1F

**6 Pokémon, Lv. 77–80**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7465](data/trainers/parties.asm#L7465) · Map: [IndigoPlateauPokecenter1F.asm:L98](maps/IndigoPlateauPokecenter1F.asm#L98)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Gliscor** (`GLISCOR`) | 77 | Toxic Orb | Poison Heal *(slot 1)* | Earthquake, Aerial Ace, X-Scissor, Roost |
| 2 | **Magnezone** (`MAGNEZONE`) | 78 | Magnet | Levitate *(hidden)* | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| 3 | **Slowking** (`SLOWKING_GALARIAN`) | 78 | Leftovers | Unaware *(slot 2)* | Psychic, Sludge Bomb, Flamethrower, Recover |
| 4 | **Weavile** (`WEAVILE`) | 78 | Nevermeltice | Technician *(slot 1)* | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| 5 | **Ceruledge** (`CERULEDGE`) | 78 | Charcoal | Sharpness *(hidden)* | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| 6 | **Feraligatr** (`FERALIGATR`) | 80 | Mystic Water | Sheer Force *(hidden)* | Waterfall, Ice Punch, Crunch, Rock Slide |


## Crystal

> **Group:** `CrystalGroup` · **Battle IDs:** `CRYSTAL`, `CRYSTAL2`, `CRYSTAL3` · **15 parties**


### CRYSTAL_1_CHIKORITA — Violet City

**2 Pokémon, Lv. 10**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7504](data/trainers/parties.asm#L7504) · Map: [VioletCity.asm:L74](maps/VioletCity.asm#L74)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Chikorita** (`CHIKORITA`) | 10 | Berry | Serene Grace *(slot 1)* | Tackle, Growl, Razor Leaf, Reflect |
| 2 | **Natu** (`NATU`) | 10 | — | Synchronize *(slot 1)* | Peck, Leer, Night Shade, Confusion |

### CRYSTAL_1_CYNDAQUIL — Violet City

**2 Pokémon, Lv. 10**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7518](data/trainers/parties.asm#L7518) · Map: [VioletCity.asm:L78](maps/VioletCity.asm#L78)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Cyndaquil** (`CYNDAQUIL`) | 10 | Berry | Adaptability *(slot 1)* | Tackle, Leer, Smokescreen, Ember |
| 2 | **Natu** (`NATU`) | 10 | — | Synchronize *(slot 1)* | Peck, Leer, Night Shade, Confusion |

### CRYSTAL_1_TOTODILE — Violet City

**2 Pokémon, Lv. 10**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7532](data/trainers/parties.asm#L7532) · Map: [VioletCity.asm:L82](maps/VioletCity.asm#L82)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Totodile** (`TOTODILE`) | 10 | Berry | Strong Jaw *(slot 1)* | Scratch, Leer, Rage, Water Gun |
| 2 | **Natu** (`NATU`) | 10 | — | Synchronize *(slot 1)* | Peck, Leer, Night Shade, Confusion |

### CRYSTAL_2_CHIKORITA — Ilex Forest

**4 Pokémon, Lv. 16–20**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7546](data/trainers/parties.asm#L7546) · Map: [IlexForest.asm:L421](maps/IlexForest.asm#L421)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Natu** (`NATU`) | 16 | — | Synchronize *(slot 1)* | Confusion, Night Shade, Peck, Leer |
| 2 | **Applin** (`APPLIN`) | 17 | Berry Juice | Ripen *(slot 1)* | Astonish, Withdraw, Dragonbreath, Growth |
| 3 | **Cubone** (`CUBONE`) | 17 | Thick Club | Rock Head *(slot 1)* | Bone Club, Headbutt, Mud Shot, Focus Energy |
| 4 | **Bayleef** (`BAYLEEF`) | 20 | Berry | Serene Grace *(slot 1)* | Razor Leaf, Body Slam, Reflect, Synthesis |

### CRYSTAL_2_CYNDAQUIL — Ilex Forest

**4 Pokémon, Lv. 16–20**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7570](data/trainers/parties.asm#L7570) · Map: [IlexForest.asm:L425](maps/IlexForest.asm#L425)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Natu** (`NATU`) | 16 | — | Synchronize *(slot 1)* | Confusion, Night Shade, Peck, Leer |
| 2 | **Applin** (`APPLIN`) | 17 | Berry Juice | Ripen *(slot 1)* | Astonish, Withdraw, Dragonbreath, Growth |
| 3 | **Cubone** (`CUBONE`) | 17 | Thick Club | Rock Head *(slot 1)* | Bone Club, Headbutt, Mud Shot, Focus Energy |
| 4 | **Quilava** (`QUILAVA`) | 20 | Berry | Adaptability *(slot 1)* | Flame Wheel, Quick Attack, Smokescreen, Dig |

### CRYSTAL_2_TOTODILE — Ilex Forest

**4 Pokémon, Lv. 16–20**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7594](data/trainers/parties.asm#L7594) · Map: [IlexForest.asm:L429](maps/IlexForest.asm#L429)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Natu** (`NATU`) | 16 | — | Synchronize *(slot 1)* | Confusion, Night Shade, Peck, Leer |
| 2 | **Applin** (`APPLIN`) | 17 | Berry Juice | Ripen *(slot 1)* | Astonish, Withdraw, Dragonbreath, Growth |
| 3 | **Cubone** (`CUBONE`) | 17 | Thick Club | Rock Head *(slot 1)* | Bone Club, Headbutt, Mud Shot, Focus Energy |
| 4 | **Croconaw** (`CROCONAW`) | 20 | Berry | Strong Jaw *(slot 1)* | Water Gun, Bite, Headbutt, Rage |

### CRYSTAL_3_CHIKORITA — Cianwood City

**4 Pokémon, Lv. 30–32**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7618](data/trainers/parties.asm#L7618) · Map: [CianwoodCity.asm:L132](maps/CianwoodCity.asm#L132)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 30 | — | Synchronize *(slot 1)* | Psychic, Air Slash, Confuse Ray, Night Shade |
| 2 | **Marowak** (`MAROWAK`) | 32 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Headbutt |
| 3 | **Dipplin** (`DIPPLIN`) | 31 | Berry | Supersweet Syrup *(slot 1)* | Dragon Pulse, Dragonbreath, Growth, Protect |
| 4 | **Bayleef** (`BAYLEEF`) | 32 | Miracle Seed | Serene Grace *(slot 1)* | Razor Leaf, Body Slam, Synthesis, Reflect |

### CRYSTAL_3_CYNDAQUIL — Cianwood City

**4 Pokémon, Lv. 30–32**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7642](data/trainers/parties.asm#L7642) · Map: [CianwoodCity.asm:L136](maps/CianwoodCity.asm#L136)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 30 | — | Synchronize *(slot 1)* | Psychic, Air Slash, Confuse Ray, Night Shade |
| 2 | **Marowak** (`MAROWAK`) | 32 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Headbutt |
| 3 | **Dipplin** (`DIPPLIN`) | 31 | Berry | Supersweet Syrup *(slot 1)* | Dragon Pulse, Dragonbreath, Growth, Protect |
| 4 | **Quilava** (`QUILAVA`) | 32 | Charcoal | Adaptability *(slot 1)* | Flame Wheel, Quick Attack, Dig, Smokescreen |

### CRYSTAL_3_TOTODILE — Cianwood City

**4 Pokémon, Lv. 30–32**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7666](data/trainers/parties.asm#L7666) · Map: [CianwoodCity.asm:L140](maps/CianwoodCity.asm#L140)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 30 | — | Synchronize *(slot 1)* | Psychic, Air Slash, Confuse Ray, Night Shade |
| 2 | **Marowak** (`MAROWAK`) | 32 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Headbutt |
| 3 | **Dipplin** (`DIPPLIN`) | 31 | Berry | Supersweet Syrup *(slot 1)* | Dragon Pulse, Dragonbreath, Growth, Protect |
| 4 | **Croconaw** (`CROCONAW`) | 32 | Mystic Water | Strong Jaw *(slot 1)* | Bite, Ice Punch, Water Gun, Headbutt |

### CRYSTAL_4_CHIKORITA — Ice Path 1F

**5 Pokémon, Lv. 41–44**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7690](data/trainers/parties.asm#L7690) · Map: [IcePath1F.asm:L52](maps/IcePath1F.asm#L52)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 41 | — | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Confuse Ray |
| 2 | **Marowak** (`MAROWAK`) | 42 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Iron Head |
| 3 | **Hydrapple** (`HYDRAPPLE`) | 42 | Leftovers | Regenerator *(slot 1)* | Apple Acid, Dragon Pulse, Recover, Energy Ball |
| 4 | **Pupitar** (`PUPITAR`) | 42 | — | Shed Skin *(slot 1)* | Rock Slide, Crunch, Earthquake, Ancientpower |
| 5 | **Meganium** (`MEGANIUM`) | 44 | Miracle Seed | Serene Grace *(slot 1)* | Giga Drain, Body Slam, Synthesis, Reflect |

### CRYSTAL_4_CYNDAQUIL — Ice Path 1F

**5 Pokémon, Lv. 41–44**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7719](data/trainers/parties.asm#L7719) · Map: [IcePath1F.asm:L56](maps/IcePath1F.asm#L56)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 41 | — | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Confuse Ray |
| 2 | **Marowak** (`MAROWAK`) | 42 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Iron Head |
| 3 | **Flapple** (`FLAPPLE`) | 42 | Miracle Seed | Ripen *(slot 1)* | Dragon Dance, Grav Apple, Dragon Pulse, Acrobatics |
| 4 | **Pupitar** (`PUPITAR`) | 42 | — | Shed Skin *(slot 1)* | Rock Slide, Crunch, Earthquake, Ancientpower |
| 5 | **Typhlosion** (`TYPHLOSION`) | 44 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Quick Attack, Dig, Smokescreen |

### CRYSTAL_4_TOTODILE — Ice Path 1F

**5 Pokémon, Lv. 41–44**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7748](data/trainers/parties.asm#L7748) · Map: [IcePath1F.asm:L60](maps/IcePath1F.asm#L60)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Xatu** (`XATU`) | 41 | — | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Confuse Ray |
| 2 | **Marowak** (`MAROWAK`) | 42 | Thick Club | Rock Head *(slot 1)* | Bonemerang, Swords Dance, Knock Off, Iron Head |
| 3 | **Appletun** (`APPLETUN`) | 42 | Leftovers | Ripen *(slot 1)* | Apple Acid, Dragon Pulse, Recover, Body Slam |
| 4 | **Pupitar** (`PUPITAR`) | 42 | — | Shed Skin *(slot 1)* | Rock Slide, Crunch, Earthquake, Ancientpower |
| 5 | **Feraligatr** (`FERALIGATR`) | 44 | Mystic Water | Strong Jaw *(slot 1)* | Crunch, Ice Punch, Waterfall, Rock Slide |

### CRYSTAL_5_CHIKORITA — Route 25 (Cerulean Cape)

**6 Pokémon, Lv. 68–70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7777](data/trainers/parties.asm#L7777) · Map: [Route25.asm:L254](maps/Route25.asm#L254)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Meganium** (`MEGANIUM`) | 70 | Leftovers | Serene Grace *(slot 1)* | Giga Drain, Body Slam, Synthesis, Leech Seed |
| 2 | **Hydrapple** (`HYDRAPPLE`) | 68 | Leftovers | Regenerator *(slot 1)* | Apple Acid, Dragon Pulse, Recover, Substitute |
| 3 | **Tyranitar** (`TYRANITAR`) | 69 | Assault Vest | Sand Stream *(slot 1)* | Crunch, Rock Slide, Earthquake, Ice Punch |
| 4 | **Ursaluna** (`URSALUNA`) | 69 | Flame Orb | Guts *(slot 1)* | Facade, Headlongrush, Close Combat, Crunch |
| 5 | **Xatu** (`XATU`) | 68 | Leftovers | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Thunder Wave |
| 6 | **Lanturn** (`LANTURN`) | 68 | Leftovers | Volt Absorb *(slot 1)* | Surf, Thunderbolt, Ice Beam, Confuse Ray |

### CRYSTAL_5_CYNDAQUIL — Route 25 (Cerulean Cape)

**6 Pokémon, Lv. 68–70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7811](data/trainers/parties.asm#L7811) · Map: [Route25.asm:L258](maps/Route25.asm#L258)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Typhlosion** (`TYPHLOSION`) | 70 | Charcoal | Adaptability *(slot 1)* | Flamethrower, Earth Power, Thunderpunch, Quick Attack |
| 2 | **Flapple** (`FLAPPLE`) | 68 | Life Orb | Ripen *(slot 1)* | Dragon Dance, Grav Apple, Scale Shot, Acrobatics |
| 3 | **Tyranitar** (`TYRANITAR`) | 69 | Assault Vest | Sand Stream *(slot 1)* | Crunch, Rock Slide, Earthquake, Ice Punch |
| 4 | **Ursaluna** (`URSALUNA`) | 69 | Flame Orb | Guts *(slot 1)* | Facade, Headlongrush, Close Combat, Crunch |
| 5 | **Xatu** (`XATU`) | 68 | Leftovers | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Thunder Wave |
| 6 | **Lanturn** (`LANTURN`) | 68 | Leftovers | Volt Absorb *(slot 1)* | Surf, Thunderbolt, Ice Beam, Confuse Ray |

### CRYSTAL_5_TOTODILE — Route 25 (Cerulean Cape)

**6 Pokémon, Lv. 68–70**  
*held items, custom moves, explicit abilities*  
<sub>Source: [parties.asm:L7845](data/trainers/parties.asm#L7845) · Map: [Route25.asm:L262](maps/Route25.asm#L262)</sub>

| # | Pokémon | Level | Held item | Ability | Moves |
|---:|---|---:|---|---|---|
| 1 | **Feraligatr** (`FERALIGATR`) | 70 | Mystic Water | Sheer Force *(hidden)* | Waterfall, Ice Punch, Crunch, Rock Slide |
| 2 | **Appletun** (`APPLETUN`) | 68 | Leftovers | Ripen *(slot 1)* | Apple Acid, Dragon Pulse, Recover, Body Slam |
| 3 | **Tyranitar** (`TYRANITAR`) | 69 | Assault Vest | Sand Stream *(slot 1)* | Crunch, Rock Slide, Earthquake, Ice Punch |
| 4 | **Ursaluna** (`URSALUNABM`) | 69 | Leftovers | Guts *(slot 1)* | Calm Mind, Earth Power, Hyper Voice, Body Slam |
| 5 | **Xatu** (`XATU`) | 68 | Leftovers | Magic Bounce *(hidden)* | Psychic, Air Slash, Roost, Thunder Wave |
| 6 | **Volcarona** (`VOLCARONA`) | 68 | Leftovers | Flame Body *(slot 1)* | Quiver Dance, Fiery Dance, Bug Buzz, Giga Drain |
