# Crimson Crystal: special trainer parties

Current working-tree source: **97 main party records and 473 Pokemon**. The appendix adds **9 unused/external records and 35 Pokemon**. All story variants and rematches in these groups are included. Kimono Girls are omitted as requested.

Each row gives the Pokemon, level, actual ability name, held item, and its moves in party-data order. These are this hack's abilities and moves, which can differ from the official games. Abilities shown assume the game's abilities option is enabled. Empty move slots are omitted.

For records without custom moves, moves are calculated from the current species learnset at the listed level, using the game's FillMoves rules. Abilities use the explicit selection when present, otherwise the trainer class's fixed DVs, including the game's fallback for an empty ability selection.

For Rival and Crystal, **Chikorita / Cyndaquil / Totodile branch means that trainer's starter line**, not the player's starter. Every branch is listed separately. Rematch aliases that use the same party record are not duplicated.

## Contents

- [Johto Gym Leaders](#johto-gym-leaders) - 16 party records
- [Kanto Gym Leaders](#kanto-gym-leaders) - 8 party records
- [Elite Four and Champion](#elite-four-and-champion) - 10 party records
- [Rival](#rival) - 21 party records
- [Crystal](#crystal) - 15 party records
- [Lorelei, Agatha, Blue Cloak, Green, and Red](#lorelei-agatha-blue-cloak-green-and-red) - 6 party records
- [Other special trainers](#other-special-trainers) - 21 party records
- [Unused and external-party records](#unused-and-external-party-records) - 9 party records

## Trainer index

| Category | Trainers |
|---|---|
| [Johto Gym Leaders](#johto-gym-leaders) | Falkner, Bugsy, Whitney, Morty, Chuck, Jasmine, Pryce, Clair |
| [Kanto Gym Leaders](#kanto-gym-leaders) | Brock, Misty, Lt. Surge, Erika, Janine, Sabrina, Blaine, Blue |
| [Elite Four and Champion](#elite-four-and-champion) | Will, Koga, Bruno, Karen, Lance |
| [Rival](#rival) | Rival - main story, Rival - postgame |
| [Crystal](#crystal) | Crystal |
| [Lorelei, Agatha, Blue Cloak, Green, and Red](#lorelei-agatha-blue-cloak-green-and-red) | Lorelei, Agatha, Blue Cloak, Green, Red, Red (Pallet Town) |
| [Other special trainers](#other-special-trainers) | Eusine, Proton, Petrel, Ariana, Archer, Li, Kiyo, Lucky, Chopper, Gaku, Masa, Koji, Cal |
| [Unused and external-party records](#unused-and-external-party-records) | Executive, Kiyo, Cal |

## Johto Gym Leaders

### Falkner - Violet Gym - initial battle

Party record: `FALKNER1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:20).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hoothoot | 8 | Intimidate | Berry | Peck, Hypnosis, Confusion, Mud-Slap |
| Fletchling | 9 | Gale Wings | — | Peck, Quick Attack, Agility, Ember |
| Pidgeotto | 10 | Keen Eye | Berry | Gust, Quick Attack, Mud-Slap, Swift |

### Falkner - Violet Gym - rematch

Party record: `FALKNER2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:39).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Skarmory | 75 | Iron Barbs | Rocky Helmet | Stealth Rock, Spikes, Body Press, Brave Bird |
| Noctowl | 75 | Tinted Lens | Wise Glasses | Nasty Plot, Hurricane, Psychic, Moonblast |
| Archeops | 76 | Unnerve | Expert Belt | Head Smash, Dualwingbeat, Earthquake, U-Turn |
| Talonflame | 76 | Gale Wings | Life Orb | Brave Bird, Flare Blitz, Roost, Will-O-Wisp |
| Honchkrow | 77 | Moxie | Life Orb | Brave Bird, Sucker Punch, Night Slash, Foul Play |
| Pidgeot | 77 | No Guard | Life Orb | Hurricane, Hyper Voice, Hyper Beam, Roost |

### Bugsy - Azalea Gym - initial battle

Party record: `BUGSY1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:137).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Pineco | 14 | Sturdy | — | Bulldoze, Bug Bite, Spikes, Reflect |
| Joltik | 15 | Compound Eyes | — | Absorb, Struggle Bug, Thunder Wave, Agility |
| Scyther | 16 | Technician | Berry Juice | Fury Cutter, Quick Attack, Pursuit, Wing Attack |

### Bugsy - Azalea Gym - rematch

Party record: `BUGSY2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:156).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Forretress | 76 | Sturdy | Leftovers | Stealth Rock, Spikes, Gyro Ball, Body Press |
| Vikavolt | 76 | Levitate | Wise Glasses | Bug Buzz, Thunderbolt, Flash Cannon, Agility |
| Heracross | 77 | Skill Link | Life Orb | Pin Missile, Rock Blast, Close Combat, Knock Off |
| Golisopod | 77 | Battle Armor | Assault Vest | First Strike, Liquidation, Sucker Punch, Knock Off |
| Volcarona | 78 | Flame Body | Leftovers | Quiver Dance, Bug Buzz, Fiery Dance, Hurricane |
| Scizor | 78 | Technician | Life Orb | Swords Dance, Bullet Punch, Bug Bite, Knock Off |

### Whitney - Goldenrod Gym - initial battle

Party record: `WHITNEY1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Clefairy | 18 | Magic Guard | — | Fairy Wind, Fire Punch, Thunderpunch, Charm |
| Aipom | 19 | Skill Link | — | Fury Swipes, Ice Punch, Knock Off, Fake Out |
| Buneary | 19 | Adaptability | — | Quick Attack, Headbutt, Ice Punch, Double Kick |
| Miltank | 20 | Thick Fat | Miracleberry | Rollout, Attract, Stomp, Milk Drink |

### Whitney - Goldenrod Gym - rematch

Party record: `WHITNEY2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:100).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Blissey | 77 | Natural Cure | Leftovers | Softboiled, Seismic Toss, Toxic, Ice Beam |
| Ambipom | 77 | Technician | Life Orb | Fake Out, Body Slam, Low Kick, U-Turn |
| Lopunny | 78 | Adaptability | Life Orb | Fake Out, Dizzy Punch, Drain Punch, Ice Punch |
| Ursaluna | 78 | Guts | Flame Orb | Facade, Headlongrush, Close Combat, Crunch |
| Snorlax | 79 | Thick Fat | Leftovers | Curse, Body Slam, Earthquake, Slack Off |
| Miltank | 79 | Scrappy | Leftovers | Milk Drink, Body Slam, Earthquake, Play Rough |

### Morty - Ecruteak Gym - initial battle

Party record: `MORTY1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golett | 23 | Iron Fist | — | Shadow Punch, Ice Punch, Bulldoze, Low Sweep |
| Misdreavus | 24 | Levitate | — | Shadow Ball, Confuse Ray, Pain Split, Psybeam |
| Drifloon | 24 | Unburden | — | Night Shade, Will-O-Wisp, Shadow Ball, Air Cutter |
| Gengar | 25 | Levitate | Miracleberry | Shadow Ball, Sludge Bomb, Confuse Ray, Mean Look |

### Morty - Ecruteak Gym - rematch

Party record: `MORTY2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:217).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Mismagius | 78 | Prankster | Leftovers | Nasty Plot, Shadow Ball, Moonblast, Will-O-Wisp |
| Dusknoir | 78 | Iron Fist | Leftovers | Shadow Sneak, Pain Split, Thunderpunch, Fire Punch |
| Mimikyu | 79 | Disguise | Life Orb | Bulk Up, Phantomforce, Play Rough, Shadow Sneak |
| Chandelure | 79 | Levitate | Life Orb | Shadow Ball, Fire Blast, Psychic, Will-O-Wisp |
| Dragapult | 80 | Infiltrator | Life Orb | Dragon Dance, Dragon Darts, Phantomforce, Sucker Punch |
| Gengar | 80 | Levitate | Life Orb | Nasty Plot, Shadow Ball, Sludge Bomb, Thunderbolt |

### Chuck - Cianwood Gym - initial battle

Party record: `CHUCK1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:391).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hitmontop | 28 | Technician | — | Triple Kick, Triple Axel, Dig, Pursuit |
| Gurdurr | 28 | Guts | — | Rock Slide, Low Kick, Thunderpunch, Bulk Up |
| Breloom | 29 | Technician | — | Mach Punch, Bullet Seed, Headbutt, Drain Punch |
| Scraggy | 29 | Moxie | — | Brick Break, Crunch, Rock Slide, Headbutt |
| Poliwrath | 30 | Iron Fist | Blackbelt | Hypnosis, Mind Reader, Surf, Dynamicpunch |

### Chuck - Cianwood Gym - rematch

Party record: `CHUCK2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:420).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Machamp | 79 | No Guard | Muscle Band | Dynamicpunch, Knock Off, Ice Punch, Bullet Punch |
| Conkeldurr | 79 | Guts | Flame Orb | Facade, Hammer Arm, Stone Edge, Knock Off |
| Gallade | 80 | Sharpness | Life Orb | Swords Dance, Sacred Sword, Psycho Cut, Night Slash |
| Sirfetch'd | 80 | Scrappy | Life Orb | Swords Dance, Close Combat, Knock Off, Brave Bird |
| Annihilape | 81 | Defiant | Leftovers | Bulk Up, Rage Fist, Close Combat, Night Slash |
| Poliwrath | 81 | Iron Fist | Muscle Band | Dynamicpunch, Drain Punch, Ice Punch, Mach Punch |

### Jasmine - Olivine Gym - initial battle

Party record: `JASMINE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Skarmory | 31 | Iron Barbs | — | Steel Wing, Drill Peck, Pursuit, Whirlwind |
| Lairon | 31 | Rock Head | — | Double-Edge, Iron Tail, Rock Slide, Bulldoze |
| Magneton | 32 | Levitate | — | Volt Switch, Flash Cannon, Supersonic, Thunder Wave |
| Tinkatuff | 33 | Mold Breaker | — | Play Rough, Metal Claw, Rock Slide, Knock Off |
| Steelix | 34 | Sturdy | Quick Claw | Iron Tail, Bulldoze, Rock Slide, Crunch |

### Jasmine - Olivine Gym - rematch

Party record: `JASMINE2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:354).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Magnezone | 80 | Levitate | Wise Glasses | Thunderbolt, Flash Cannon, Thunder Wave, Signal Beam |
| Corvknight | 80 | Mirror Armor | Leftovers | Brave Bird, Body Press, Iron Defense, Roost |
| Excadrill | 81 | Mold Breaker | Life Orb | Swords Dance, Earthquake, Iron Head, Rock Slide |
| Lucario | 81 | Adaptability | Life Orb | Nasty Plot, Aura Sphere, Flash Cannon, Dragon Pulse |
| Tinkaton | 82 | Mold Breaker | Life Orb | Giga Hammer, Play Rough, Knock Off, Metal Claw |
| Steelix | 82 | Sturdy | Leftovers | Earthquake, Iron Head, Body Press, Crunch |

### Pryce - Mahogany Gym - initial battle

Party record: `PRYCE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:254).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Alolan Ninetales | 35 | Snow Warning | Icy Rock | Ice Beam, Dazzle Gleam, Confuse Ray, Icy Wind |
| Dewgong | 36 | Thick Fat | — | Surf, Ice Beam, Rest, Sleep Talk |
| Cetitan | 36 | Thick Fat | Leftovers | Ice Shard, Liquidation, Icicle Crash, Knock Off |
| Glaceon | 37 | Refrigerate | — | Freeze-Dry, Hyper Voice, Earth Power, Protect |
| Abomasnow | 37 | Thick Fat | — | Ice Beam, Giga Drain, Ice Shard, Rock Slide |
| Mamoswine | 38 | Thick Fat | Gold Berry | Earthquake, Icicle Crash, Rock Slide, Ice Shard |

### Pryce - Mahogany Gym - rematch

Party record: `PRYCE2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:288).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Alolan Ninetales | 81 | Snow Warning | Icy Rock | Blizzard, Moonblast, Freeze-Dry, Nasty Plot |
| Cloyster | 81 | Skill Link | Life Orb | Shell Smash, Icicle Spear, Rock Blast, Ice Shard |
| Glaceon | 82 | Slush Rush | Life Orb | Blizzard, Freeze-Dry, Earth Power, Mirror Coat |
| Weavile | 82 | Technician | Life Orb | Icicle Crash, Knock Off, Night Slash, Ice Shard |
| Lapras | 83 | Water Absorb | Assault Vest | Ice Beam, Surf, Thunderbolt, Dragon Pulse |
| Mamoswine | 83 | Thick Fat | Life Orb | Icicle Crash, Earthquake, Ice Shard, Superpower |

### Clair - Blackthorn Gym 1F - initial battle

Party record: `CLAIR1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:457).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Dragonair | 42 | Multiscale | — | Dragon Pulse, Thunder Wave, Ice Beam, Thunderbolt |
| Noivern | 43 | Wind Rider | — | Air Slash, Dragon Pulse, Dark Pulse, Agility |
| Flygon | 43 | Tinted Lens | — | Earthquake, Dragon Claw, Rock Slide, U-Turn |
| Altaria | 44 | Natural Cure | — | Dragon Claw, Earthquake, Body Slam, Dragon Dance |
| Tyrantrum | 44 | Strong Jaw | — | Rock Slide, Crunch, Fire Fang, Dragon Claw |
| Kingdra | 45 | Sniper | Scope Lens | Surf, Dragon Pulse, Ice Beam, Agility |

### Clair - Blackthorn Gym 1F - rematch

Party record: `CLAIR2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:491).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Altaria | 82 | Natural Cure | Leftovers | Dragon Pulse, Moonblast, Heat Wave, Will-O-Wisp |
| Noivern | 82 | Wind Rider | Life Orb | Hurricane, Dragon Pulse, Heat Wave, Roost |
| Archaludon | 83 | Stamina | Leftovers | Draco Meteor, Flash Cannon, Body Press, Dragon Tail |
| Haxorus | 83 | Mold Breaker | Life Orb | Dragon Dance, Dragon Claw, Iron Head, Superpower |
| Salamence | 84 | Aerilate | Life Orb | Dragon Dance, Double-Edge, Dragon Claw, Fire Fang |
| Kingdra | 84 | Swift Swim | Life Orb | Rain Dance, Hydro Pump, Draco Meteor, Ice Beam |


## Kanto Gym Leaders

### Brock - Pewter Gym

Party record: `BROCK1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Aerodactyl | 47 | Rock Head | Focus Sash | Stealth Rock, Stone Edge, Earthquake, Crunch |
| Cradily | 48 | Storm Drain | Leftovers | Giga Drain, Ancientpower, Toxic, Recover |
| Kabutops | 48 | Swift Swim | Leftovers | Rock Slide, Waterfall, X-Scissor, Swords Dance |
| Bastiodon | 49 | Sturdy | Leftovers | Body Press, Power Gem, Toxic, Protect |
| Armaldo | 49 | Tough Claws | Expert Belt | X-Scissor, Stone Edge, Earthquake, Swords Dance |
| Golem | 50 | Sturdy | Rocky Helmet | Stone Edge, Earthquake, Fire Punch, Explosion |

### Misty - Cerulean Gym

Party record: `MISTY1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1064).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Milotic | 51 | Marvel Scale | Leftovers | Scald, Ice Beam, Recover, Toxic |
| Walrein | 52 | Thick Fat | Leftovers | Surf, Ice Beam, Body Slam, Protect |
| Gyarados | 52 | Intimidate | Rocky Helmet | Waterfall, Crunch, Ice Fang, Dragon Dance |
| Azumarill | 53 | Huge Power | Muscle Band | Aqua Jet, Play Rough, Waterfall, Ice Punch |
| Lanturn | 53 | Volt Absorb | Leftovers | Surf, Thunderbolt, Ice Beam, Confuse Ray |
| Starmie | 54 | Natural Cure | Life Orb | Surf, Psychic, Thunderbolt, Recover |

### Lt. Surge - Vermilion Gym

Party record: `LT_SURGE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Magnezone | 55 | Levitate | Air Balloon | Thunderbolt, Flash Cannon, Volt Switch, Thunder Wave |
| Electivire | 56 | Iron Fist | Life Orb | Thunderpunch, Ice Punch, Fire Punch, Cross Chop |
| Vikavolt | 56 | Speed Boost | Leftovers | Thunderbolt, Bug Buzz, Energy Ball, Volt Switch |
| Jolteon | 57 | Volt Absorb | Life Orb | Thunderbolt, Shadow Ball, Hyper Voice, Thunder Wave |
| Ampharos | 57 | Mold Breaker | Leftovers | Thunderbolt, Dragon Pulse, Focus Blast, Thunder Wave |
| Raichu | 58 | Galvanize | Life Orb | Extremespeed, Hyper Voice, Surf, Nasty Plot |

### Erika - Celadon Gym

Party record: `ERIKA1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1184).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Ludicolo | 59 | Swift Swim | Leftovers | Rain Dance, Surf, Giga Drain, Ice Beam |
| Jumpluff | 60 | Infiltrator | Leftovers | Sleep Powder, Leech Seed, Giga Drain, Encore |
| Vileplume | 60 | Poison Puppeteer | Leftovers | Sludge Bomb, Giga Drain, Toxic, Synthesis |
| Victreebel | 61 | Poison Puppeteer | Life Orb | Power Whip, Sludge Bomb, Knock Off, Swords Dance |
| Exeggutor | 61 | Harvest | Gold Berry | Psychic, Giga Drain, Leech Seed, Substitute |
| Tsareena | 62 | Queenly Majesty | Life Orb | Power Whip, Triple Axel, Play Rough, Rapid Spin |

### Janine - Fuchsia Gym

Party record: `JANINE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2107).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Toxapex | 59 | Regenerator | Leftovers | Toxic Spikes, Scald, Recover, Bane Bunker |
| Weezing | 60 | Levitate | Leftovers | Sludge Bomb, Flamethrower, Will-O-Wisp, Pain Split |
| Seviper | 60 | Merciless | Life Orb | Gunk Shot, Crunch, Earthquake, Sucker Punch |
| Overqwil | 61 | Intimidate | Leftovers | Barb Barrage, Crunch, Aqua Tail, Swords Dance |
| Ariados | 61 | Merciless | Life Orb | Megahorn, Poison Jab, Sucker Punch, Toxic |
| Crobat | 62 | Merciless | Brightpowder | Cross Poison, Brave Bird, U-Turn, Roost |

### Sabrina - Saffron Gym

Party record: `SABRINA1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3344).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Mesmeria | 59 | Bad Dreams | Leftovers | Hypnosis, Psychic, Ice Beam, Dream Eater |
| Gardevoir | 60 | Pixilate | Life Orb | Hyper Voice, Psychic, Shadow Ball, Calm Mind |
| Farigiraf | 60 | Armor Tail | Leftovers | Psychic, Crunch, Hyper Voice, Calm Mind |
| Hypno | 61 | No Guard | Leftovers | Hypnosis, Dream Eater, Psychic, Shadow Ball |
| Wobbuffet | 61 | Shadow Tag | Leftovers | Counter, Mirror Coat, Safeguard, Destiny Bond |
| Alakazam | 62 | Magic Guard | Life Orb | Psychic, Shadow Ball, Focus Blast, Recover |

### Blaine - Seafoam Gym

Party record: `BLAINE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4679).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Ninetales | 63 | Drought | Charcoal | Flamethrower, Solarbeam, Will-O-Wisp, Nasty Plot |
| Arcanine | 64 | Intimidate | Life Orb | Flare Blitz, Extremespeed, Close Combat, Wild Charge |
| Armarouge | 64 | Mega Launcher | Wise Glasses | Armor Cannon, Psychic, Aura Sphere, Calm Mind |
| Torkoal | 65 | Drought | Leftovers | Flamethrower, Solarbeam, Earth Power, Body Press |
| Rapidash | 65 | Reckless | Life Orb | Flare Blitz, Double-Edge, Wild Charge, Megahorn |
| Magmortar | 66 | Flash Fire | Life Orb | Fire Blast, Thunderbolt, Focus Blast, Psychic |

### Blue - Viridian Gym

Party record: `BLUE1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6602).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Pidgeot | 66 | No Guard | Life Orb | Hurricane, Heat Wave, Air Slash, Roost |
| Rhyperior | 67 | Solid Rock | Leftovers | Earthquake, Stone Edge, Ice Punch, Megahorn |
| Gyarados | 67 | Moxie | Life Orb | Waterfall, Crunch, Earthquake, Dragon Dance |
| Arcanine | 68 | Intimidate | Expert Belt | Flare Blitz, Extremespeed, Crunch, Wild Charge |
| Scizor | 68 | Technician | Muscle Band | Bullet Punch, Bug Bite, U-Turn, Swords Dance |
| Electivire | 69 | Sheer Force | Life Orb | Wild Charge, Ice Punch, Fire Punch, Knock Off |


## Elite Four and Champion

### Will - Will's Room - initial battle

Party record: `WILL1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 67 | Magic Bounce | Leftovers | Psychic, Air Slash, Roost, Thunder Wave |
| Farigiraf | 68 | Armor Tail | Assault Vest | Psychic, Crunch, Hyper Voice, Thunderbolt |
| Gallade | 68 | Sharpness | Life Orb | Psycho Cut, Night Slash, Leaf Blade, Sacred Sword |
| Slowking | 69 | Regenerator | Leftovers | Surf, Psychic, Flamethrower, Slack Off |
| Grumpig | 69 | Thick Fat | Wise Glasses | Psychic, Shadow Ball, Calm Mind, Energy Ball |
| Wyrdeer | 70 | Intimidate | Muscle Band | Zen Headbutt, Double-Edge, Megahorn, Agility |

### Will - Will's Room - rematch

Party record: `WILL2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:564).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 83 | Magic Bounce | Leftovers | Calm Mind, Psychic, Air Slash, Roost |
| Farigiraf | 84 | Armor Tail | Assault Vest | Psychic, Hyper Voice, Crunch, Thunderbolt |
| Gallade | 84 | Sharpness | Life Orb | Swords Dance, Psycho Cut, Sacred Sword, Night Slash |
| Slowking | 85 | Regenerator | Leftovers | Calm Mind, Psychic, Surf, Slack Off |
| Grumpig | 85 | Thick Fat | Wise Glasses | Calm Mind, Psychic, Shadow Ball, Energy Ball |
| Espathra | 85 | Speed Boost | Leftovers | Calm Mind, Psychic, Dazzle Gleam, Shadow Ball |

### Koga - Koga's Room - initial battle

Party record: `KOGA1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Glimmora | 68 | Toxic Debris | Focus Sash | Toxic Spikes, Power Gem, Sludge Bomb, Earth Power |
| Alolan Muk | 69 | Poison Touch | Assault Vest | Gunk Shot, Knock Off, Crunch, Shadow Sneak |
| Scolipede | 69 | Speed Boost | Life Orb | Megahorn, Poison Jab, Rock Slide, Swords Dance |
| Tentacruel | 70 | Clear Body | Leftovers | Surf, Sludge Bomb, Ice Beam, Knock Off |
| Salazzle | 70 | Poison Puppeteer | Life Orb | Flamethrower, Sludge Bomb, Toxic, Nasty Plot |
| Crobat | 71 | Merciless | Brightpowder | Hypnosis, Cross Poison, Brave Bird, Roost |

### Koga - Koga's Room - rematch

Party record: `KOGA2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:919).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Glimmora | 83 | Toxic Debris | Focus Sash | Toxic Spikes, Stealth Rock, Sludge Bomb, Earth Power |
| Alolan Muk | 84 | Poison Touch | Assault Vest | Gunk Shot, Knock Off, Ice Punch, Shadow Sneak |
| Scolipede | 84 | Speed Boost | Life Orb | Swords Dance, Megahorn, Poison Jab, Rock Slide |
| Tentacruel | 85 | Clear Body | Leftovers | Scald, Sludge Bomb, Ice Beam, Knock Off |
| Salazzle | 85 | Corrosion | Life Orb | Nasty Plot, Fire Blast, Sludge Bomb, Toxic |
| Crobat | 85 | Infiltrator | Leftovers | Brave Bird, Cross Poison, Hypnosis, Confuse Ray |

### Bruno - Bruno's Room - initial battle

Party record: `BRUNO1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Conkeldurr | 69 | Iron Fist | Leftovers | Drain Punch, Mach Punch, Thunderpunch, Ice Punch |
| Hitmontop | 70 | Technician | Muscle Band | Triple Kick, Mach Punch, Pursuit, Close Combat |
| Lucario | 70 | Adaptability | Life Orb | Close Combat, Bullet Punch, Extremespeed, Swords Dance |
| Toxicroak | 71 | Dry Skin | Expert Belt | Poison Jab, Drain Punch, Sucker Punch, Ice Punch |
| Annihilape | 71 | Defiant | Leftovers | Rage Fist, Close Combat, Shadow Claw, Bulk Up |
| Machamp | 72 | No Guard | Blackbelt | Dynamicpunch, Cross Chop, Rock Slide, Fire Punch |

### Bruno - Bruno's Room - rematch

Party record: `BRUNO2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:778).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Conkeldurr | 84 | Guts | Flame Orb | Facade, Drain Punch, Mach Punch, Knock Off |
| Hitmontop | 85 | Technician | Muscle Band | Triple Kick, Close Combat, Mach Punch, Sucker Punch |
| Lucario | 85 | Adaptability | Life Orb | Swords Dance, Close Combat, Bullet Punch, Extremespeed |
| Toxicroak | 86 | Dry Skin | Life Orb | Swords Dance, Drain Punch, Poison Jab, Sucker Punch |
| Annihilape | 86 | Defiant | Leftovers | Bulk Up, Rage Fist, Drain Punch, Shadow Claw |
| Machamp | 86 | No Guard | Expert Belt | Dynamicpunch, Stone Edge, Ice Punch, Knock Off |

### Karen - Karen's Room - initial battle

Party record: `KAREN1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Umbreon | 69 | Synchronize | Leftovers | Foul Play, Toxic, Moonlight, Confuse Ray |
| Honchkrow | 70 | Moxie | Life Orb | Brave Bird, Sucker Punch, Night Slash, Heat Wave |
| Weavile | 70 | Technician | Life Orb | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| Grimmsnarl | 71 | Prankster | Leftovers | Spirit Break, Crunch, Thunder Wave, Bulk Up |
| Houndoom | 71 | Adaptability | Blackglasses | Flamethrower, Dark Pulse, Sludge Bomb, Nasty Plot |
| Kingambit | 72 | Supreme Overlord | Leftovers | Kowtowcleave, Sucker Punch, Iron Head, Swords Dance |

### Karen - Karen's Room - rematch

Party record: `KAREN2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:848).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Umbreon | 84 | Synchronize | Leftovers | Foul Play, Toxic, Moonlight, Confuse Ray |
| Honchkrow | 85 | Moxie | Life Orb | Brave Bird, Sucker Punch, Night Slash, Heat Wave |
| Weavile | 85 | Technician | Life Orb | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Grimmsnarl | 86 | Prankster | Leftovers | Bulk Up, Spirit Break, Crunch, Thunder Wave |
| Houndoom | 86 | Adaptability | Life Orb | Nasty Plot, Dark Pulse, Fire Blast, Sludge Bomb |
| Kingambit | 86 | Supreme Overlord | Leftovers | Swords Dance, Kowtowcleave, Sucker Punch, Iron Head |

### Lance - Lance's Room - initial battle

Party record: `LANCE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Haxorus | 70 | Mold Breaker | Life Orb | Outrage, Earthquake, Poison Jab, Dragon Dance |
| Archaludon | 71 | Stamina | Leftovers | Body Press, Flash Cannon, Dragon Pulse, Thunderbolt |
| Salamence | 71 | Aerilate | Life Orb | Double-Edge, Dragon Claw, Earthquake, Fire Blast |
| Dragapult | 72 | Infiltrator | Scope Lens | Dragon Darts, Shadow Ball, U-Turn, Thunderbolt |
| Baxcalibur | 72 | Thermal Exchange | Leftovers | Icicle Crash, Dragon Claw, Earthquake, Ice Shard |
| Dragonite | 73 | Multiscale | Gold Berry | Outrage, Extremespeed, Earthquake, Dragon Dance |

### Lance - Lance's Room - rematch

Party record: `LANCE2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:990).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hydreigon | 85 | Berserk | Life Orb | Nasty Plot, Draco Meteor, Heat Wave, Dark Pulse |
| Archaludon | 86 | Stamina | Leftovers | Body Press, Flash Cannon, Draco Meteor, Thunderbolt |
| Salamence | 86 | Aerilate | Life Orb | Dragon Dance, Double-Edge, Dragon Claw, Earthquake |
| Dragapult | 87 | Infiltrator | Life Orb | Dragon Darts, Flamethrower, Phantomforce, Sucker Punch |
| Baxcalibur | 87 | Thermal Exchange | Leftovers | Dragon Dance, Icicle Crash, Dragon Claw, Earthquake |
| Dragonite | 87 | Multiscale | Leftovers | Dragon Dance, Outrage, Extremespeed, Earthquake |


## Rival

### Rival - main story - Cherrygrove City - Chikorita branch

Party record: `RIVAL1_1_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7592).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Chikorita | 5 | Serene Grace | Berry | Tackle, Growl |

### Rival - main story - Cherrygrove City - Cyndaquil branch

Party record: `RIVAL1_1_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7601).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Cyndaquil | 5 | Adaptability | Berry | Tackle, Leer |

### Rival - main story - Cherrygrove City - Totodile branch

Party record: `RIVAL1_1_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7610).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Totodile | 5 | Sheer Force | Berry | Scratch, Leer |

### Rival - main story - Azalea Town - Chikorita branch

Party record: `RIVAL1_2_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7619).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Zubat | 14 | Inner Focus | — | Wing Attack, Bite, Astonish, Supersonic |
| Magnemite | 15 | Levitate | — | Thundershock, Sonicboom, Thunder Wave, Swift |
| Bayleef | 16 | Serene Grace | Berry | Razor Leaf, Tackle, Leech Seed, Reflect |

### Rival - main story - Azalea Town - Cyndaquil branch

Party record: `RIVAL1_2_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7638).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Zubat | 14 | Inner Focus | — | Wing Attack, Bite, Astonish, Supersonic |
| Magnemite | 15 | Levitate | — | Thundershock, Sonicboom, Thunder Wave, Swift |
| Quilava | 16 | Adaptability | Berry | Ember, Quick Attack, Smokescreen, Leer |

### Rival - main story - Azalea Town - Totodile branch

Party record: `RIVAL1_2_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7657).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Zubat | 14 | Inner Focus | — | Wing Attack, Bite, Astonish, Supersonic |
| Magnemite | 15 | Levitate | — | Thundershock, Sonicboom, Thunder Wave, Swift |
| Croconaw | 16 | Sheer Force | Berry | Water Gun, Bite, Rage, Leer |

### Rival - main story - Burned Tower 1F - Chikorita branch

Party record: `RIVAL1_3_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7676).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 22 | Inner Focus | — | Wing Attack, Bite, Poison Fang, Confuse Ray |
| Magnemite | 22 | Levitate | Magnet | Thundershock, Sonicboom, Thunder Wave, Swift |
| Slowpoke | 23 | Unaware | — | Confusion, Water Gun, Headbutt, Disable |
| Bayleef | 24 | Serene Grace | Berry | Giga Drain, Razor Leaf, Tackle, Leech Seed |

### Rival - main story - Burned Tower 1F - Cyndaquil branch

Party record: `RIVAL1_3_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7700).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 22 | Inner Focus | — | Wing Attack, Bite, Poison Fang, Confuse Ray |
| Magnemite | 22 | Levitate | Magnet | Thundershock, Sonicboom, Thunder Wave, Swift |
| Slowpoke | 23 | Unaware | — | Confusion, Water Gun, Headbutt, Disable |
| Quilava | 24 | Adaptability | Berry | Flame Wheel, Dig, Quick Attack, Smokescreen |

### Rival - main story - Burned Tower 1F - Totodile branch

Party record: `RIVAL1_3_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7724).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 22 | Inner Focus | — | Wing Attack, Bite, Poison Fang, Confuse Ray |
| Magnemite | 22 | Levitate | Magnet | Thundershock, Sonicboom, Thunder Wave, Swift |
| Galarian Slowpoke | 23 | Unaware | — | Confusion, Acid, Headbutt, Disable |
| Croconaw | 24 | Sheer Force | Berry | Bite, Ice Punch, Water Gun, Mud-Slap |

### Rival - main story - Goldenrod Underground Switch Room Entrances - Chikorita branch

Party record: `RIVAL1_4_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7748).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 40 | Inner Focus | Eviolite | Dualwingbeat, Poison Fang, Bite, Roost |
| Magnezone | 41 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 41 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 41 | Technician | Nevermeltice | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| Ceruledge | 41 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Meganium | 42 | Mega Sol | Miracle Seed | Giga Drain, Body Slam, Synthesis, Reflect |

### Rival - main story - Goldenrod Underground Switch Room Entrances - Cyndaquil branch

Party record: `RIVAL1_4_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7782).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 40 | Inner Focus | Eviolite | Dualwingbeat, Poison Fang, Bite, Roost |
| Magnezone | 41 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 41 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 41 | Technician | Nevermeltice | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| Gengar | 41 | Levitate | Spell Tag | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| Typhlosion | 42 | Adaptability | Charcoal | Flamethrower, Thunderpunch, Earth Power, Quick Attack |

### Rival - main story - Goldenrod Underground Switch Room Entrances - Totodile branch

Party record: `RIVAL1_4_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7816).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 40 | Inner Focus | Eviolite | Dualwingbeat, Poison Fang, Bite, Roost |
| Magnezone | 41 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Galarian Slowking | 41 | Unaware | Leftovers | Psychic, Sludge Bomb, Flamethrower, Slack Off |
| Weavile | 41 | Technician | Nevermeltice | Ice Shard, Faint Attack, Icicle Crash, Low Kick |
| Ceruledge | 41 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Feraligatr | 42 | Sheer Force | Mystic Water | Waterfall, Ice Punch, Crunch, Rock Slide |

### Rival - main story - Victory Road - Chikorita branch

Party record: `RIVAL1_5_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7850).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 68 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 69 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 69 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 69 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 69 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Meganium | 71 | Mega Sol | Miracle Seed | Energy Ball, Body Slam, Synthesis, Leech Seed |

### Rival - main story - Victory Road - Cyndaquil branch

Party record: `RIVAL1_5_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7884).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 68 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 69 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 69 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 69 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Gengar | 69 | Levitate | Spell Tag | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| Typhlosion | 71 | Adaptability | Charcoal | Flamethrower, Focus Blast, Earth Power, Thunderpunch |

### Rival - main story - Victory Road - Totodile branch

Party record: `RIVAL1_5_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7918).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 68 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 69 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Galarian Slowking | 69 | Unaware | Leftovers | Psychic, Sludge Bomb, Flamethrower, Slack Off |
| Weavile | 69 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 69 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Feraligatr | 71 | Sheer Force | Mystic Water | Waterfall, Ice Punch, Crunch, Rock Slide |

### Rival - postgame - Mount Moon - Chikorita branch

Party record: `RIVAL2_1_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7955).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 49 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 50 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 51 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 51 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 51 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Meganium | 53 | Mega Sol | Miracle Seed | Energy Ball, Body Slam, Synthesis, Leech Seed |

### Rival - postgame - Mount Moon - Cyndaquil branch

Party record: `RIVAL2_1_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7989).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 49 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 50 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 51 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 51 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Gengar | 51 | Levitate | Spell Tag | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| Typhlosion | 53 | Adaptability | Charcoal | Flamethrower, Focus Blast, Earth Power, Thunderpunch |

### Rival - postgame - Mount Moon - Totodile branch

Party record: `RIVAL2_1_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8023).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golbat | 49 | Inner Focus | Eviolite | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 50 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Galarian Slowking | 51 | Unaware | Leftovers | Psychic, Sludge Bomb, Flamethrower, Slack Off |
| Weavile | 51 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 51 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Feraligatr | 53 | Sheer Force | Mystic Water | Waterfall, Ice Punch, Crunch, Rock Slide |

### Rival - postgame - Indigo Plateau Pokémon Center 1F - Chikorita branch

Party record: `RIVAL2_2_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8057).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Crobat | 82 | Infiltrator | Leftovers | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 83 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 83 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 83 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 83 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Meganium | 85 | Mega Sol | Miracle Seed | Energy Ball, Moonblast, Synthesis, Leech Seed |

### Rival - postgame - Indigo Plateau Pokémon Center 1F - Cyndaquil branch

Party record: `RIVAL2_2_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8091).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Crobat | 82 | Infiltrator | Leftovers | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 83 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Slowking | 83 | Unaware | Leftovers | Surf, Psychic, Ice Beam, Slack Off |
| Weavile | 83 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Gengar | 83 | Levitate | Spell Tag | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| Typhlosion | 85 | Adaptability | Charcoal | Fire Blast, Focus Blast, Earth Power, Thunderpunch |

### Rival - postgame - Indigo Plateau Pokémon Center 1F - Totodile branch

Party record: `RIVAL2_2_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8125).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Crobat | 82 | Infiltrator | Leftovers | Brave Bird, Cross Poison, U-Turn, Roost |
| Magnezone | 83 | Levitate | Magnet | Thunderbolt, Flash Cannon, Tri Attack, Thunder Wave |
| Galarian Slowking | 83 | Unaware | Leftovers | Psychic, Sludge Bomb, Flamethrower, Slack Off |
| Weavile | 83 | Technician | Nevermeltice | Icicle Crash, Knock Off, Ice Shard, Low Kick |
| Ceruledge | 83 | Sharpness | Charcoal | Bitter Blade, Phantomforce, Psycho Cut, Shadow Sneak |
| Feraligatr | 85 | Sheer Force | Mystic Water | Liquidation, Ice Punch, Crunch, Dragon Dance |


## Crystal

### Crystal - Violet City - Chikorita branch

Party record: `CRYSTAL_1_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8164).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Chikorita | 10 | Serene Grace | Berry | Tackle, Growl, Razor Leaf, Reflect |
| Natu | 10 | Synchronize | — | Peck, Leer, Night Shade, Confusion |

### Crystal - Violet City - Cyndaquil branch

Party record: `CRYSTAL_1_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8178).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Cyndaquil | 10 | Adaptability | Berry | Tackle, Leer, Smokescreen, Ember |
| Natu | 10 | Synchronize | — | Peck, Leer, Night Shade, Confusion |

### Crystal - Violet City - Totodile branch

Party record: `CRYSTAL_1_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8192).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Totodile | 10 | Strong Jaw | Berry | Scratch, Leer, Rage, Water Gun |
| Natu | 10 | Synchronize | — | Peck, Leer, Night Shade, Confusion |

### Crystal - Ilex Forest - Chikorita branch

Party record: `CRYSTAL_2_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8206).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Natu | 16 | Synchronize | — | Confusion, Night Shade, Peck, Leer |
| Applin | 17 | Ripen | Berry Juice | Astonish, Withdraw, Rollout, Defense Curl |
| Cubone | 17 | Rock Head | Thick Club | Bone Club, Headbutt, Mud-Slap, Focus Energy |
| Bayleef | 20 | Serene Grace | Berry | Razor Leaf, Body Slam, Reflect, Synthesis |

### Crystal - Ilex Forest - Cyndaquil branch

Party record: `CRYSTAL_2_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8230).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Natu | 16 | Synchronize | — | Confusion, Night Shade, Peck, Leer |
| Applin | 17 | Ripen | Berry Juice | Astonish, Withdraw, Rollout, Defense Curl |
| Cubone | 17 | Rock Head | Thick Club | Bone Club, Headbutt, Mud-Slap, Focus Energy |
| Quilava | 20 | Adaptability | Berry | Flame Wheel, Quick Attack, Smokescreen, Dig |

### Crystal - Ilex Forest - Totodile branch

Party record: `CRYSTAL_2_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8254).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Natu | 16 | Synchronize | — | Confusion, Night Shade, Peck, Leer |
| Applin | 17 | Ripen | Berry Juice | Astonish, Withdraw, Rollout, Defense Curl |
| Cubone | 17 | Rock Head | Thick Club | Bone Club, Headbutt, Mud-Slap, Focus Energy |
| Croconaw | 20 | Strong Jaw | Berry | Water Gun, Bite, Headbutt, Rage |

### Crystal - Cianwood City - Chikorita branch

Party record: `CRYSTAL_3_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8278).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 30 | Synchronize | — | Psychic, Air Slash, Confuse Ray, Night Shade |
| Marowak | 32 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Headbutt |
| Dipplin | 31 | Supersweet Syrup | Berry | Dragon Pulse, Dragonbreath, Growth, Protect |
| Bayleef | 32 | Serene Grace | Miracle Seed | Razor Leaf, Body Slam, Synthesis, Reflect |

### Crystal - Cianwood City - Cyndaquil branch

Party record: `CRYSTAL_3_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8302).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 30 | Synchronize | — | Psychic, Air Slash, Confuse Ray, Night Shade |
| Marowak | 32 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Headbutt |
| Dipplin | 31 | Supersweet Syrup | Berry | Dragon Pulse, Dragonbreath, Growth, Protect |
| Quilava | 32 | Adaptability | Charcoal | Flame Wheel, Quick Attack, Dig, Smokescreen |

### Crystal - Cianwood City - Totodile branch

Party record: `CRYSTAL_3_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8326).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 30 | Synchronize | — | Psychic, Air Slash, Confuse Ray, Night Shade |
| Marowak | 32 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Headbutt |
| Dipplin | 31 | Supersweet Syrup | Berry | Dragon Pulse, Dragonbreath, Growth, Protect |
| Feraligatr | 32 | Strong Jaw | Mystic Water | Bite, Ice Punch, Water Gun, Headbutt |

### Crystal - Ice Path 1F - Chikorita branch

Party record: `CRYSTAL_4_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8350).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 41 | Magic Bounce | — | Psychic, Air Slash, Roost, Confuse Ray |
| Marowak | 42 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Iron Head |
| Hydrapple | 42 | Regenerator | Leftovers | Giga Drain, Dragon Pulse, Recover, Energy Ball |
| Pupitar | 42 | Shed Skin | — | Rock Slide, Crunch, Earthquake, Ancientpower |
| Meganium | 44 | Serene Grace | Miracle Seed | Giga Drain, Body Slam, Synthesis, Reflect |

### Crystal - Ice Path 1F - Cyndaquil branch

Party record: `CRYSTAL_4_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8379).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 41 | Magic Bounce | — | Psychic, Air Slash, Roost, Confuse Ray |
| Marowak | 42 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Iron Head |
| Flapple | 42 | Ripen | Miracle Seed | Dragon Dance, Grav Apple, Dragon Pulse, Acrobatics |
| Pupitar | 42 | Shed Skin | — | Rock Slide, Crunch, Earthquake, Ancientpower |
| Typhlosion | 44 | Adaptability | Charcoal | Flamethrower, Quick Attack, Dig, Smokescreen |

### Crystal - Ice Path 1F - Totodile branch

Party record: `CRYSTAL_4_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8408).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Xatu | 41 | Magic Bounce | — | Psychic, Air Slash, Roost, Confuse Ray |
| Marowak | 42 | Rock Head | Thick Club | Bonemerang, Swords Dance, Knock Off, Iron Head |
| Appletun | 42 | Ripen | Leftovers | Apple Acid, Dragon Pulse, Recover, Body Slam |
| Pupitar | 42 | Shed Skin | — | Rock Slide, Crunch, Earthquake, Ancientpower |
| Feraligatr | 44 | Strong Jaw | Mystic Water | Crunch, Ice Punch, Waterfall, Rock Slide |

### Crystal - Route 25 (Cerulean Cape) - Chikorita branch

Party record: `CRYSTAL_5_CHIKORITA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8437).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meganium | 70 | Serene Grace | Leftovers | Giga Drain, Body Slam, Synthesis, Leech Seed |
| Hydrapple | 68 | Regenerator | Leftovers | Energy Ball, Dragon Pulse, Recover, Substitute |
| Tyranitar | 69 | Sand Stream | Assault Vest | Crunch, Rock Slide, Earthquake, Ice Punch |
| Marowak | 69 | Battle Armor | Thick Club | Bonemerang, Rock Slide, Fire Punch, Swords Dance |
| Xatu | 68 | Magic Bounce | Leftovers | Psychic, Air Slash, Roost, Thunder Wave |
| Lanturn | 68 | Volt Absorb | Leftovers | Surf, Thunderbolt, Ice Beam, Confuse Ray |

### Crystal - Route 25 (Cerulean Cape) - Cyndaquil branch

Party record: `CRYSTAL_5_CYNDAQUIL`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8471).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Typhlosion | 70 | Adaptability | Charcoal | Flamethrower, Earth Power, Thunderpunch, Quick Attack |
| Flapple | 68 | Ripen | Life Orb | Dragon Dance, Grav Apple, Dragon Pulse, Acrobatics |
| Tyranitar | 69 | Sand Stream | Assault Vest | Crunch, Rock Slide, Earthquake, Ice Punch |
| Marowak | 69 | Battle Armor | Thick Club | Bonemerang, Rock Slide, Fire Punch, Swords Dance |
| Xatu | 68 | Magic Bounce | Leftovers | Psychic, Air Slash, Roost, Thunder Wave |
| Lanturn | 68 | Volt Absorb | Leftovers | Surf, Thunderbolt, Ice Beam, Confuse Ray |

### Crystal - Route 25 (Cerulean Cape) - Totodile branch

Party record: `CRYSTAL_5_TOTODILE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8505).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Feraligatr | 70 | Sheer Force | Mystic Water | Waterfall, Ice Punch, Crunch, Rock Slide |
| Appletun | 68 | Ripen | Leftovers | Apple Acid, Dragon Pulse, Recover, Body Slam |
| Tyranitar | 69 | Sand Stream | Assault Vest | Crunch, Rock Slide, Earthquake, Ice Punch |
| Marowak | 69 | Battle Armor | Thick Club | Bonemerang, Rock Slide, Fire Punch, Swords Dance |
| Xatu | 68 | Magic Bounce | Leftovers | Psychic, Air Slash, Roost, Thunder Wave |
| Volcarona | 68 | Flame Body | Leftovers | Quiver Dance, Fiery Dance, Bug Buzz, Giga Drain |


## Lorelei, Agatha, Blue Cloak, Green, and Red

### Lorelei - Silver Cave Outside

Party record: `LORELEI1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7161).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Dewgong | 85 | Thick Fat | Leftovers | Surf, Ice Beam, Rest, Sleep Talk |
| Cloyster | 86 | Skill Link | Life Orb | Shell Smash, Icicle Spear, Rock Blast, Ice Shard |
| Slowbro | 86 | Regenerator | Leftovers | Calm Mind, Surf, Ice Beam, Slack Off |
| Mesmeria | 87 | Synchronize | Wise Glasses | Nasty Plot, Ice Beam, Psychic, Lovely Kiss |
| Lapras | 87 | Water Absorb | Assault Vest | Ice Beam, Surf, Thunderbolt, Freeze-Dry |
| Glaceon | 87 | Refrigerate | Leftovers | Ice Beam, Hyper Voice, Shadow Ball, Protect |

### Agatha - Silver Cave Outside

Party record: `AGATHA1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7124).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Gengar | 85 | Levitate | Focus Sash | Shadow Ball, Sludge Bomb, Thunderbolt, Destiny Bond |
| Misdreavus | 86 | Prankster | Eviolite | Will-O-Wisp, Shadow Ball, Confuse Ray, Pain Split |
| Arbok | 86 | Intimidate | Leftovers | Gunk Shot, Crunch, Earthquake, Glare |
| Crobat | 87 | Infiltrator | Leftovers | Cross Poison, Brave Bird, U-Turn, Roost |
| Haunter | 87 | Levitate | Spell Tag | Hypnosis, Shadow Ball, Sludge Bomb, Dream Eater |
| Gengar | 87 | Levitate | Life Orb | Nasty Plot, Shadow Ball, Sludge Bomb, Focus Blast |

### Blue Cloak - Cinnabar Island

Party record: `BLUE_CLOAK1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7235).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Pidgeot | 82 | No Guard | Life Orb | Hurricane, Heat Wave, U-Turn, Roost |
| Scizor | 83 | Technician | Life Orb | Bullet Punch, X-Scissor, U-Turn, Swords Dance |
| Rhyperior | 83 | Sheer Force | Life Orb | Bulldoze, Rock Slide, Ice Punch, Thunderpunch |
| Exeggutor | 84 | Harvest | Gold Berry | Psychic, Giga Drain, Leech Seed, Substitute |
| Electivire | 84 | Sheer Force | Life Orb | Thunderpunch, Ice Punch, Fire Punch, Knock Off |
| Blastoise | 84 | Mega Launcher | Life Orb | Water Pulse, Aura Sphere, Dark Pulse, Dragon Pulse |

### Green - Route 20

Party record: `GREEN1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7272).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Wigglytuff | 80 | Magic Guard | Assault Vest | Hyper Voice, Dazzle Gleam, Thunderbolt, Ice Beam |
| Umbreon | 81 | Magic Guard | Leftovers | Foul Play, Toxic, Moonlight, Confuse Ray |
| Nidoqueen | 81 | Sheer Force | Life Orb | Earth Power, Sludge Bomb, Ice Beam, Flamethrower |
| Mesmeria | 82 | Bad Dreams | Life Orb | Hypnosis, Psychic, Ice Beam, Dream Eater |
| Lanturn | 82 | Volt Absorb | Assault Vest | Surf, Thunderbolt, Ice Beam, Signal Beam |
| Venusaur | 82 | Thick Fat | Leftovers | Giga Drain, Sludge Bomb, Sleep Powder, Synthesis |

### Red - Silver Cave Room 3

Party record: `RED1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6565).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Pikachu | 88 | Galvanize | Light Ball | Extremespeed, Hyper Voice, Surf, Iron Tail |
| Espeon | 89 | Magic Bounce | Twistedspoon | Psychic, Shadow Ball, Morning Sun, Calm Mind |
| Snorlax | 89 | Thick Fat | Leftovers | Curse, Body Slam, Earthquake, Rest |
| Venusaur | 90 | Chlorophyll | Miracle Seed | Giga Drain, Sludge Bomb, Sleep Powder, Synthesis |
| Charizard | 90 | Drought | Charcoal | Fire Blast, Solarbeam, Air Slash, Dragon Pulse |
| Blastoise | 90 | Drizzle | Mystic Water | Hydro Pump, Ice Beam, Aura Sphere, Earthquake |

### Red (Pallet Town) - Pallet Town

Party record: `RED2_1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7198).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Pikachu | 83 | Galvanize | Light Ball | Extremespeed, Hyper Voice, Surf, Play Rough |
| Snorlax | 84 | Thick Fat | Leftovers | Curse, Giga Impact, Earthquake, Rest |
| Espeon | 84 | Magic Bounce | Life Orb | Psychic, Shadow Ball, Dazzle Gleam, Signal Beam |
| Lapras | 85 | Water Absorb | Assault Vest | Freeze-Dry, Blizzard, Thunderbolt, Megahorn |
| Aerodactyl | 85 | Strong Jaw | Life Orb | Crunch, Thunder Fang, Sky Attack, Stone Edge |
| Charizard | 85 | Drought | Life Orb | Fire Blast, Solarbeam, Earthquake, Dragon Pulse |


## Other special trainers

### Eusine - Cianwood City

Party record: `EUSINE`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6681).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hypno | 33 | Insomnia | Twistedspoon | Psychic, Hypnosis, Dream Eater, Reflect |
| Haunter | 33 | Levitate | Spell Tag | Shadow Ball, Hypnosis, Confuse Ray, Sucker Punch |
| Electrode | 34 | Static | Magnet | Thunderbolt, Thunder Wave, Selfdestruct, Light Screen |

### Eusine - Ecruteak City

Party record: `EUSINE2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6700).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hypno | 38 | No Guard | — | Zen Headbutt, Trick, Psychic, Hypnosis |
| Gengar | 38 | Cursed Body | — | Shadow Ball, Sludge Bomb, Hypnosis, Dream Eater |
| Electrode | 39 | Static | — | Foul Play, Light Screen, Signal Beam, Thunderbolt |
| Noctowl | 39 | Insomnia | — | Dualwingbeat, Psychic, Heat Wave, Zen Headbutt |
| Espeon | 40 | Synchronize | — | Skill Swap, Aura Sphere, Signal Beam, Psychic |

### Proton - Slowpoke Well B1F

Party record: `PROTON1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6722).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Impidimp | 10 | Prankster | — | Fake Out, Bite, Taunt, Pixie Punch |
| Galarian Meowth | 11 | Tough Claws | — | Metal Claw, Scratch, Growl |
| Hisuian Sneasel | 13 | Technician | — | Rock Smash, Fury Swipes, Quick Attack, Focus Energy |

### Proton - Radio Tower 4F

Party record: `PROTON2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6741).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Grimmsnarl | 40 | Prankster | — | Spirit Break, Sucker Punch, Thunder Wave, Bulk Up |
| Perrserker | 40 | Steely Spirit | — | Iron Head, Bullet Punch, Seed Bomb, Brick Break |
| Zangoose | 41 | Sharpness | — | Slash, X-Scissor, Knock Off, Swords Dance |
| Sneasler | 42 | Technician | — | Mach Punch, Drain Punch, Poison Fang, X-Scissor |

### Petrel - Team Rocket Base B3F

Party record: `PETREL1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6768).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Alolan Grimer | 35 | Poison Touch | — | Poison Fang, Crunch, Knock Off, Shadow Sneak |
| Porygon2 | 36 | Download | — | Tri Attack, Psybeam, Foul Play, Recover |
| Banette | 36 | Prankster | — | Shadow Claw, Knock Off, Will-O-Wisp, Encore |
| Ditto | 36 | Imposter | — | Transform |

### Petrel - Radio Tower 5F

Party record: `PETREL_DIRECTOR1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6915).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Alolan Muk | 40 | Poison Puppeteer | — | Poison Jab, Knock Off, Shadow Sneak, Toxic |
| Porygon-Z | 40 | Adaptability | — | Tri Attack, Dark Pulse, Thunderbolt, Nasty Plot |
| Banette | 41 | Prankster | — | Shadow Claw, Knock Off, Will-O-Wisp, Encore |
| Ditto | 42 | Imposter | — | Transform |

### Ariana - Team Rocket Base B2F

Party record: `ARIANA1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6798).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Murkrow | 35 | Prankster | — | Drill Peck, Sucker Punch, Thunder Wave, Taunt |
| Salazzle | 35 | Corrosion | — | Incinerate, Venoshock, Toxic, Encore |
| Milotic | 36 | Competitive | — | Scald, Moonblast, Recover, Hypnosis |
| Weavile | 36 | Technician | — | Ice Punch, Night Slash, Ice Shard, Low Kick |

### Ariana - Radio Tower 5F

Party record: `ARIANA2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6822).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Honchkrow | 42 | Moxie | Sharp Beak | Brave Bird, Sucker Punch, Superpower, Roost |
| Salazzle | 42 | Corrosion | Charcoal | Flamethrower, Venoshock, Toxic, Nasty Plot |
| Milotic | 43 | Competitive | Mystic Water | Scald, Moonblast, Recover, Hypnosis |
| Toxapex | 43 | Regenerator | Leftovers | Scald, Surf, Toxic Spikes, Recover |
| Weavile | 43 | Technician | Muscle Band | Triple Axel, Night Slash, Ice Shard, Low Kick |

### Archer - Radio Tower 5F (rematch)

Party record: `ARCHER1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6854).

Placement note: no direct map-script reference was found for this record.

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Crobat | 43 | Merciless | Sharp Beak | Toxic, Cross Poison, Dualwingbeat, Roost |
| Dusknoir | 44 | Iron Fist | Leftovers | Shadow Punch, Ice Punch, Thunderpunch, Will-O-Wisp |
| Kingambit | 44 | Sharpness | Blackglasses | Iron Head, Night Slash, Brick Break, Slash |
| Krookodile | 44 | Intimidate | Blackglasses | Earthquake, Crunch, Rock Slide, Taunt |
| Houndoom | 44 | Adaptability | Charcoal | Flamethrower, Dark Pulse, Sucker Punch, Taunt |

### Archer - Radio Tower 5F

Party record: `ARCHER2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6883).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Crobat | 41 | Merciless | Sharp Beak | Toxic, Cross Poison, Dualwingbeat, Roost |
| Dusknoir | 41 | Iron Fist | Leftovers | Shadow Punch, Ice Punch, Thunderpunch, Will-O-Wisp |
| Kingambit | 42 | Sharpness | Blackglasses | Iron Head, Night Slash, Brick Break, Slash |
| Krookodile | 42 | Intimidate | Blackglasses | Earthquake, Crunch, Rock Slide, Taunt |
| Houndoom | 43 | Adaptability | Charcoal | Flamethrower, Dark Pulse, Sucker Punch, Taunt |

### Elder Li - Sprout Tower 3F

Party record: `LI`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8542).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Hoppip | 7 | Infiltrator | — | Absorb, Synthesis, Tackle, Tail Whip |
| Exeggcute | 8 | Harvest | Berry | Hypnosis, Absorb, Barrage, Reflect |
| Weepinbell | 9 | Poison Puppeteer | — | Poisonpowder, Vine Whip, Acid, Wrap |

### Karate King Kiyo - Fighting Dojo

Party record: `KARATE_KIYO`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8774).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Sirfetch'd | 67 | Super Luck | Stick | Close Combat, Brave Bird, Leaf Blade, Night Slash |
| Sneasler | 67 | Technician | Life Orb | Fake Out, Dire Claw, Close Combat, Ice Punch |
| Breloom | 68 | Technician | Focus Sash | Spore, Bullet Seed, Mach Punch, Rock Tomb |
| Scrafty | 68 | Intimidate | Leftovers | Dragon Dance, Drain Punch, Knock Off, Ice Punch |
| Hitmontop | 70 | Technician | Wide Lens | Triple Kick, Triple Axel, Mach Punch, Bullet Punch |

### Slot Maniac Lucky - Goldenrod Game Corner

Party record: `SLOT_MANIAC_LUCKY`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8808).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meowth | 16 | Technician | — | Pay Day, Fake Out, Fury Swipes, Bite |
| Aipom | 16 | Skill Link | — | Doubleslap, Scratch, Sand-Attack, Astonish |
| Dunsparce | 17 | Serene Grace | — | Headbutt, Glare, Rollout, Spite |

### Cueball Chopper - Route 16

Party record: `CHOPPER`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8737).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Weezing | 64 | Levitate | Rocky Helmet | Sludge Bomb, Flamethrower, Thunderbolt, Will-O-Wisp |
| Arbok | 64 | Intimidate | Leftovers | Gunk Shot, Earthquake, Crunch, Glare |
| Houndoom | 65 | Flash Fire | Life Orb | Dark Pulse, Flamethrower, Sludge Bomb, Nasty Plot |
| Krookodile | 65 | Intimidate | Expert Belt | Earthquake, Crunch, Stone Edge, Dragon Claw |
| Alolan Muk | 66 | Poison Touch | Leftovers | Poison Jab, Knock Off, Shadow Sneak, Fire Punch |
| Machamp | 67 | No Guard | Assault Vest | Dynamicpunch, Stone Edge, Ice Punch, Knock Off |

### Gaku - Wise Trios Room

Party record: `GAKU`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6023).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Arcanine | 47 | Flash Fire | — | Wild Charge, Play Rough, Flare Blitz, Heat Crash |
| Ninetales | 47 | Flash Fire | — | Dark Pulse, Dazzle Gleam, Heat Wave, Fire Blast |
| Xatu | 47 | Early Bird | — | Calm Mind, Future Sight, Trick, Trick Room |

### Masa - Wise Trios Room

Party record: `MASA`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6033).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Electrode | 47 | Static | — | Light Screen, Signal Beam, Thunderbolt, Explosion |
| Noctowl | 47 | Insomnia | — | Heat Wave, Skill Swap, Moonblast, Roost |
| Ampharos | 47 | Mold Breaker | — | Hyper Voice, Focus Blast, Dazzle Gleam, Cotton Guard |

### Koji - Wise Trios Room

Party record: `KOJI`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6043).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Lanturn | 47 | Water Absorb | — | Flail, Signal Beam, Thunderbolt, Tail Glow |
| Starmie | 47 | Analytic | — | Trick, Trick Room, Hydro Pump, Surf |
| Slowking | 47 | Unaware | — | Rain Dance, Future Sight, Liquidation, Trick Room |

### Cal - Trainer House B1F (highest level below 60)

Party record: `CAL3`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:635).

Selected when the highest level in the player's party is **below 60**.

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meganium | 50 | Mega Sol | Leftovers | Solarbeam, Weather Ball, Moonblast, Synthesis |
| Feraligatr | 50 | Strong Jaw | Life Orb | Dragon Dance, Liquidation, Crunch, Ice Fang |
| Typhlosion | 50 | Adaptability | Expert Belt | Flamethrower, Earth Power, Focus Blast, Shadow Ball |

### Cal - Trainer House B1F (highest level 60-69)

Party record: `CAL4`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:654).

Selected when the highest level in the player's party is **60-69**.

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meganium | 60 | Mega Sol | Leftovers | Solarbeam, Weather Ball, Moonblast, Synthesis |
| Feraligatr | 60 | Strong Jaw | Life Orb | Dragon Dance, Liquidation, Crunch, Ice Fang |
| Typhlosion | 60 | Adaptability | Expert Belt | Flamethrower, Earth Power, Focus Blast, Shadow Ball |
| Charizard | 60 | Drought | Heat Rock | Fire Blast, Dragon Pulse, Air Slash, Roost |

### Cal - Trainer House B1F (highest level 70-79)

Party record: `CAL5`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:678).

Selected when the highest level in the player's party is **70-79**.

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meganium | 70 | Mega Sol | Leftovers | Solarbeam, Weather Ball, Moonblast, Synthesis |
| Feraligatr | 70 | Strong Jaw | Life Orb | Dragon Dance, Liquidation, Crunch, Ice Fang |
| Typhlosion | 70 | Adaptability | Expert Belt | Flamethrower, Earth Power, Focus Blast, Shadow Ball |
| Charizard | 70 | Drought | Heat Rock | Fire Blast, Dragon Pulse, Air Slash, Roost |
| Venusaur | 70 | Thick Fat | Miracle Seed | Energy Ball, Sludge Bomb, Sleep Powder, Weather Ball |

### Cal - Trainer House B1F (highest level 80+)

Party record: `CAL6`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:707).

Selected when the highest level in the player's party is **80 or higher**.

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Meganium | 80 | Mega Sol | Leftovers | Solarbeam, Weather Ball, Moonblast, Synthesis |
| Feraligatr | 80 | Strong Jaw | Life Orb | Dragon Dance, Liquidation, Crunch, Ice Fang |
| Typhlosion | 80 | Adaptability | Expert Belt | Flamethrower, Earth Power, Focus Blast, Shadow Ball |
| Charizard | 80 | Drought | Heat Rock | Fire Blast, Dragon Pulse, Air Slash, Roost |
| Venusaur | 80 | Thick Fat | Miracle Seed | Energy Ball, Sludge Bomb, Sleep Powder, Weather Ball |
| Blastoise | 80 | Mega Launcher | Wise Glasses | Shell Smash, Water Pulse, Aura Sphere, Dark Pulse |


## Unused and external-party records

These are retained for completeness and are not additional fixed battles normally selected by the map scripts. **CAL2 is special: the engine loads its actual party from Mystery Gift save data instead of this source record**, so its row below is only the static placeholder, not a guaranteed encountered team.

### Rocket Executive M - Not placed on any map

Party record: `EXECUTIVEM_1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5191).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Skarmory | 31 | Sturdy | — | Drill Peck, Steel Wing, Wing Attack, Agility |
| Murkrow | 31 | Insomnia | — | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| Machoke | 32 | No Guard | — | Brick Break, Vital Throw, Strength, Work Up |
| Gloom | 32 | Poison Puppeteer | — | Sludge, Giga Drain, Mega Drain, Toxic |
| Pawniard | 33 | Inner Focus | — | Iron Head, Night Slash, Sucker Punch, Swords Dance |

### Rocket Executive M - Not placed on any map

Party record: `EXECUTIVEM_2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5210).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Croagunk | 31 | Dry Skin | — | Drain Punch, Poison Jab, Sucker Punch, Bulk Up |
| Gurdurr | 31 | Sheer Force | — | Brick Break, Low Sweep, Rock Slide, Bulk Up |
| Murkrow | 31 | Insomnia | — | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| Glimmet | 32 | Corrosion | — | Venoshock, Ancientpower, Rock Slide, Stealth Rock |

### Rocket Executive M - Not placed on any map

Party record: `EXECUTIVEM_3`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5226).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Murkrow | 29 | Insomnia | — | Drill Peck, Wing Attack, Sucker Punch, Dualwingbeat |
| Scolipede | 29 | Swarm | — | Bug Bite, Poison Fang, Venoshock, Protect |
| Golbat | 30 | Frisk | — | Wing Attack, Poison Fang, Bite, Confuse Ray |
| Sneasel | 30 | Inner Focus | — | Faint Attack, Crush Claw, Slash, Agility |
| Clodsire | 31 | Water Absorb | — | Poison Jab, Bulldoze, Body Slam, Toxic Spikes |

### Rocket Executive M - Not placed on any map

Party record: `EXECUTIVEM_4`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5245).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Misdreavus | 23 | Levitate | — | Hex, Drain Kiss, Psybeam, Confuse Ray |
| Koffing | 24 | Neutralizing Gas | — | Selfdestruct, Sludge, Tackle, Smog |
| Alolan Grimer | 24 | Gluttony | — | Bite, Poison Fang, Shadow Sneak, Curse |
| Drifloon | 24 | Unburden | — | Shadow Ball, Hex, Gust, Focus Energy |

### Rocket Executive F - Not placed on any map

Party record: `EXECUTIVEF_1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5902).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golurk | 32 | Clear Body | — | Shadow Punch, Mega Punch, Rock Tomb, Curse |
| Alolan Raticate | 32 | Guts | — | Crunch, Take Down, Hyper Fang, Swords Dance |
| Houndoom | 33 | Flash Fire | — | Flamethrower, Dark Pulse, Will-O-Wisp, Nasty Plot |
| Murkrow | 33 | Insomnia | — | Drill Peck, Faint Attack, Haze, Roost |
| Hypno | 33 | No Guard | — | Psybeam, Headbutt, Hypnosis, Disable |

### Rocket Executive F - Not placed on any map

Party record: `EXECUTIVEF_2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5921).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Golett | 24 | Klutz | — | Shadow Punch, Rock Tomb, Mud Shot, Curse |
| Salandit | 24 | Poison Puppeteer | — | Incinerate, Ember, Dragon Rage, Toxic |
| Wobbuffet | 25 | Shadow Tag | — | Counter, Mirror Coat, Amnesia, Encore |
| Zweilous | 25 | Hustle | — | Bite, Headbutt, Dragonbreath, Focus Energy |

### Kiyo - legacy Mt. Mortar team, no longer placed

Party record: `KIYO`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5089).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Croagunk | 32 | Dry Skin | — | Low Sweep, Brick Break, Venoshock, Low Kick |
| Gurdurr | 32 | Sheer Force | — | Low Sweep, Rock Slide, Low Kick, Bulk Up |

### Cal - unused static rematch record

Party record: `CAL1`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Flygon | 71 | Overcoat | Silverpowder | Earthquake, Dragon Claw, U-Turn, Rock Slide |
| Ursaluna | 71 | Bulletproof | Gold Berry | Headlongrush, Body Slam, Crunch, Close Combat |
| Poliwrath | 71 | Iron Fist | Berry | Waterfall, Close Combat, Ice Punch, Hypnosis |

### Cal - Mystery Gift static placeholder

Party record: `CAL2`. [Party source](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:617).

| Pokemon | Level | Ability | Held item | Moves |
|---|---:|---|---|---|
| Salazzle | 71 | Poison Puppeteer | Poison Barb | Venoshock, Incinerate, Ember, Toxic |
| Alolan Dugtrio | 71 | Technician | Gold Berry | Bulldoze, Metal Claw, Rock Slide, Sandstorm |
| Arbok | 71 | Shed Skin | Miracleberry | Crunch, Poison Fang, Ice Fang, Glare |

## Classes with no fixed parties

The Pokemon Professor and Hostess groups contain no party records. Battle Tower teams are generated from pools, so there is no single fixed party to list for each Battle Tower trainer.

## Source and resolution references

- [Trainer parties](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm)
- [Species ability definitions](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats)
- [Ability names](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/abilities/names.asm)
- [Ability lookup and fallback](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/home/abilities.asm:1)
- [Default trainer ability selection](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/move_mon.asm:254)
- [Trainer ability and move overrides; Cal party selection](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/read_trainer_party.asm)
- [Automatic move filling](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/evolve.asm:860)
