# Luminescent 3.0 (Re:Illuminated) port into Crimson Crystal

Source: `TeamLumi/luminescent-team` → `__gamedata/gamedata3.0/PersonalTable.json`

Fields copied: base stats, both types, catch rate, base exp, all three ability slots.

Stats copied positionally — Lumi's field order (`basic_hp, atk, def, agi, spatk, spdef`) already matches your `hp atk def spd sat sdf` layout. No reordering.


## Summary

| Field | Files changed |
|---|---|
| Base stats | 38 |
| Typing | 5 |
| Abilities | 126 |
| Catch rate | 62 |
| Base exp | 363 |

459 of 471 base_stats files matched a Lumi entry; 409 files were modified.


## Typing changes (5)

| Pokémon | Before | After |
|---|---|---|
| aggron | STEEL, ROCK | STEEL, STEEL |
| aron | STEEL, ROCK | STEEL, STEEL |
| banette | GHOST, GHOST | GHOST, NORMAL |
| lairon | STEEL, ROCK | STEEL, STEEL |
| sirfetch_d | FIGHTING, FLYING | FIGHTING, FIGHTING |

> `banette` becoming Ghost/Normal is genuine in the 3.0 table (type1=Ghost, type2=Normal), not a mono-type artifact — worth eyeballing if it surprises you.


## Base stat changes (38)

| Pokémon | Before (hp atk def spd sat sdf) | After |
|---|---|---|
| ampharos | 90, 75, 85, 65, 115, 90 | 90, 75, 85, 55, 115, 90 |
| annihilape | 110, 115, 80, 90, 50, 90 | 110, 115, 80, 95, 60, 75 |
| appletun | 110, 85, 110, 35, 100, 100 | 110, 65, 85, 30, 110, 85 |
| arcanine_hisuian | 95, 120, 85, 90, 95, 85 | 95, 120, 85, 90, 80, 85 |
| banette | 64, 115, 65, 65, 83, 63 | 64, 125, 65, 70, 93, 63 |
| carracosta | 74, 108, 133, 32, 83, 65 | 70, 117, 123, 50, 80, 60 |
| centiskorch | 100, 115, 65, 65, 90, 90 | 100, 115, 90, 65, 65, 90 |
| clodsire | 130, 75, 60, 20, 45, 100 | 130, 75, 60, 20, 65, 100 |
| dipplin | 70, 70, 90, 40, 75, 60 | 80, 80, 110, 40, 95, 80 |
| drunsparce | 125, 100, 80, 55, 85, 75 | 125, 110, 85, 55, 85, 80 |
| dunsparce | 105, 95, 95, 45, 55, 55 | 105, 95, 75, 45, 55, 55 |
| farigiraf | 120, 90, 70, 60, 110, 70 | 120, 90, 70, 85, 110, 70 |
| flapple | 70, 135, 80, 100, 95, 60 | 70, 110, 80, 85, 65, 75 |
| flygon | 90, 110, 85, 100, 130, 85 | 90, 115, 85, 110, 115, 85 |
| galvantula | 70, 77, 60, 108, 97, 60 | 70, 77, 60, 108, 107, 60 |
| gardevoir | 68, 65, 65, 105, 125, 90 | 68, 65, 65, 80, 125, 115 |
| golett | 59, 74, 50, 35, 35, 50 | 59, 74, 50, 40, 40, 40 |
| golurk | 89, 124, 80, 55, 55, 80 | 94, 124, 90, 87, 55, 55 |
| grimmsnarl | 95, 120, 65, 60, 95, 75 | 95, 120, 75, 60, 75, 85 |
| hydrapple | 106, 70, 90, 66, 130, 80 | 106, 80, 110, 44, 120, 80 |
| lopunny | 65, 106, 84, 105, 54, 96 | 65, 106, 84, 105, 44, 96 |
| mawile | 50, 85, 85, 50, 55, 55 | 60, 95, 115, 50, 55, 85 |
| mimikyu | 55, 90, 80, 96, 50, 105 | 55, 100, 80, 96, 50, 105 |
| noivern | 85, 70, 80, 123, 97, 80 | 85, 60, 80, 123, 107, 80 |
| rapidash | 65, 100, 70, 105, 80, 80 | 65, 105, 70, 115, 80, 80 |
| rapidash_galarian | 65, 90, 70, 105, 90, 80 | 65, 105, 70, 115, 80, 80 |
| salandit | 48, 44, 40, 77, 71, 40 | 48, 44, 40, 77, 76, 40 |
| salazzle | 68, 64, 60, 117, 111, 60 | 68, 64, 60, 117, 116, 60 |
| scolipede | 60, 100, 89, 112, 55, 69 | 60, 110, 89, 112, 55, 69 |
| scrafty | 65, 90, 115, 58, 45, 115 | 77, 90, 115, 58, 45, 115 |
| skarmory | 65, 80, 140, 70, 40, 70 | 85, 90, 140, 70, 40, 70 |
| tauros_paldean_fire | 75, 110, 105, 100, 30, 70 | 75, 115, 110, 100, 40, 80 |
| tauros_paldean_water | 75, 110, 105, 100, 30, 70 | 75, 115, 110, 100, 40, 80 |
| tinkaton | 85, 85, 77, 94, 70, 105 | 85, 75, 77, 94, 70, 105 |
| tsareena | 72, 120, 98, 72, 50, 98 | 77, 120, 98, 77, 50, 98 |
| unown | 54, 108, 54, 64, 108, 54 | 54, 108, 54, 54, 108, 54 |
| vibrava | 60, 80, 55, 70, 90, 55 | 60, 85, 55, 70, 85, 55 |
| wooper_paldean | 55, 45, 45, 15, 25, 25 | 55, 55, 55, 15, 25, 25 |

## Ability changes (126)

| Pokémon | Before | After |
|---|---|---|
| aggron | STURDY, ROCK_HEAD, NO_ABILITY | ROCK_HEAD, STURDY, NO_ABILITY |
| aipom | PICKUP, PICKUP, SKILL_LINK | PICKUP, NO_ABILITY, SKILL_LINK |
| amaura | REFRIGERATE, REFRIGERATE, SNOW_WARNING | REFRIGERATE, SOLID_ROCK, SNOW_WARNING |
| ampharos | STATIC, MOLD_BREAKER, MOLD_BREAKER | STATIC, MOLD_BREAKER, NO_ABILITY |
| appletun | THICK_FAT, TRIAGE, REGENERATOR | THICK_FAT, TRIAGE, NO_ABILITY |
| applin | BULLETPROOF, NO_ABILITY, BULLETPROOF | BULLETPROOF, NO_ABILITY, NO_ABILITY |
| arcanine_hisuian | INTIMIDATE, ROCK_HEAD, DEFIANT | INTIMIDATE, FLASH_FIRE, ROCK_HEAD |
| arctibax | THERMAL_EXCHANGE, THERMAL_EXCHANGE, ICE_BODY | THERMAL_EXCHANGE, NO_ABILITY, ICE_BODY |
| aron | STURDY, ROCK_HEAD, NO_ABILITY | ROCK_HEAD, STURDY, NO_ABILITY |
| aurorus | REFRIGERATE, REFRIGERATE, SNOW_WARNING | REFRIGERATE, SOLID_ROCK, SNOW_WARNING |
| banette | INSOMNIA, FRISK, CURSED_BODY | FRISK, CURSED_BODY, PRANKSTER |
| baxcalibur | THERMAL_EXCHANGE, THERMAL_EXCHANGE, ICE_BODY | THERMAL_EXCHANGE, NO_ABILITY, ICE_BODY |
| bellossom | CHLOROPHYLL, OWN_TEMPO, CHLOROPHYLL | CHLOROPHYLL, OWN_TEMPO, NO_ABILITY |
| bisharp | DEFIANT, INNER_FOCUS, PRESSURE | DEFIANT, INNER_FOCUS, SHARPNESS |
| blissey | SERENE_GRACE, NATURAL_CURE, NATURAL_CURE | SERENE_GRACE, NATURAL_CURE, NO_ABILITY |
| carracosta | SOLID_ROCK, STURDY, SWIFT_SWIM | STURDY, SHEER_FORCE, SWIFT_SWIM |
| celebi | NATURAL_CURE, NATURAL_CURE, NATURAL_CURE | NATURAL_CURE, NO_ABILITY, NO_ABILITY |
| chandelure | FLASH_FIRE, FLAME_BODY, CURSED_BODY | FLASH_FIRE, LEVITATE, CURSED_BODY |
| chansey | SERENE_GRACE, NATURAL_CURE, NATURAL_CURE | SERENE_GRACE, NATURAL_CURE, NO_ABILITY |
| charcadet | FLASH_FIRE, FLASH_FIRE, FLAME_BODY | FLASH_FIRE, NO_ABILITY, FLAME_BODY |
| charjabug | STATIC, NO_ABILITY, NO_ABILITY | STATIC, HUSTLE, NO_ABILITY |
| clefairy | CUTE_CHARM, MAGIC_GUARD, CUTE_CHARM | CUTE_CHARM, MAGIC_GUARD, NO_ABILITY |
| cleffa | CUTE_CHARM, MAGIC_GUARD, CUTE_CHARM | CUTE_CHARM, MAGIC_GUARD, NO_ABILITY |
| corsola_galarian | WEAK_ARMOR, WEAK_ARMOR, CURSED_BODY | WEAK_ARMOR, NO_ABILITY, CURSED_BODY |
| cradily | STORM_DRAIN, STAMINA, REGENERATOR | STORM_DRAIN, NO_ABILITY, REGENERATOR |
| cursola | WEAK_ARMOR, WEAK_ARMOR, PERISH_BODY | WEAK_ARMOR, NO_ABILITY, PERISH_BODY |
| deino | HUSTLE, HUSTLE, HUSTLE | HUSTLE, NO_ABILITY, NO_ABILITY |
| ditto | IMPOSTER, IMPOSTER, IMPOSTER | IMPOSTER, NO_ABILITY, NO_ABILITY |
| drifblim | AFTERMATH, AFTERMATH, GUTS | AFTERMATH, NO_ABILITY, GUTS |
| drifloon | AFTERMATH, AFTERMATH, GUTS | AFTERMATH, NO_ABILITY, GUTS |
| drunsparce | SERENE_GRACE, NO_ABILITY, RATTLED | SERENE_GRACE, RATTLED, NO_ABILITY |
| dunsparce | SERENE_GRACE, RATTLED, RATTLED | SERENE_GRACE, RATTLED, NO_ABILITY |
| eevee | ADAPTABILITY, ADAPTABILITY, CLOUD_NINE | ADAPTABILITY, NO_ABILITY, CLOUD_NINE |
| electrode | SOUNDPROOF, AFTERMATH, AFTERMATH | SOUNDPROOF, AFTERMATH, NO_ABILITY |
| espeon | SYNCHRONIZE, SYNCHRONIZE, MAGIC_BOUNCE | SYNCHRONIZE, NO_ABILITY, MAGIC_BOUNCE |
| excadrill | SAND_RUSH, SAND_FORCE, MOLD_BREAKER | SAND_RUSH, STURDY, MOLD_BREAKER |
| farigiraf | ARMOR_TAIL, ARMOR_TAIL, SAP_SIPPER | ARMOR_TAIL, NO_ABILITY, SAP_SIPPER |
| flaaffy | STATIC, FLUFFY, STATIC | STATIC, FLUFFY, NO_ABILITY |
| fletchinder | FLAME_BODY, FLAME_BODY, GALE_WINGS | FLAME_BODY, NO_ABILITY, GALE_WINGS |
| fletchling | BIG_PECKS, BIG_PECKS, GALE_WINGS | BIG_PECKS, NO_ABILITY, GALE_WINGS |
| flygon | COMPOUND_EYES, LEVITATE, OVERCOAT | COMPOUND_EYES, OVERCOAT, TINTED_LENS |
| forretress | STURDY, STURDY, OVERCOAT | STURDY, NO_ABILITY, OVERCOAT |
| frigibax | THERMAL_EXCHANGE, THERMAL_EXCHANGE, ICE_BODY | THERMAL_EXCHANGE, NO_ABILITY, ICE_BODY |
| gallade | STEADFAST, JUSTIFIED, INNER_FOCUS | STEADFAST, SHARPNESS, INNER_FOCUS |
| glimmet | POISON_POINT, NO_ABILITY, MERCILESS | TOXIC_DEBRIS, NO_ABILITY, MERCILESS |
| glimmora | TOXIC_DEBRIS, TOXIC_DEBRIS, TOXIC_DEBRIS | TOXIC_DEBRIS, NO_ABILITY, NO_ABILITY |
| grimer | POISON_TOUCH, NO_ABILITY, POISON_TOUCH | POISON_TOUCH, NO_ABILITY, NO_ABILITY |
| grimmsnarl | PRANKSTER, INTIMIDATE, TOUGH_CLAWS | PRANKSTER, FRISK, TOUGH_CLAWS |
| growlithe_hisuian | INTIMIDATE, ROCK_HEAD, JUSTIFIED | INTIMIDATE, FLASH_FIRE, ROCK_HEAD |
| grubbin | SWARM, SWARM, SWARM | SWARM, HUSTLE, HYPER_CUTTER |
| gyarados | INTIMIDATE, INTIMIDATE, MOXIE | INTIMIDATE, NO_ABILITY, MOXIE |
| ho_oh | PRESSURE, PRESSURE, REGENERATOR | PRESSURE, NO_ABILITY, REGENERATOR |
| hydreigon | LEVITATE, LEVITATE, LEVITATE | LEVITATE, NO_ABILITY, NO_ABILITY |
| jolteon | VOLT_ABSORB, VOLT_ABSORB, COMPETITIVE | VOLT_ABSORB, NO_ABILITY, COMPETITIVE |
| jynx | DRY_SKIN, NO_ABILITY, DRY_SKIN | DRY_SKIN, NO_ABILITY, NO_ABILITY |
| kabutops | SWIFT_SWIM, BATTLE_ARMOR, WEAK_ARMOR | SWIFT_SWIM, BATTLE_ARMOR, SHARPNESS |
| kakuna | SHED_SKIN, SHED_SKIN, SHED_SKIN | SHED_SKIN, NO_ABILITY, NO_ABILITY |
| kingambit | DEFIANT, SUPREME_OVERLORD, PRESSURE | DEFIANT, SUPREME_OVERLORD, SHARPNESS |
| lairon | STURDY, ROCK_HEAD, NO_ABILITY | ROCK_HEAD, STURDY, NO_ABILITY |
| lampent | FLASH_FIRE, FLAME_BODY, CURSED_BODY | FLASH_FIRE, LEVITATE, CURSED_BODY |
| larvesta | FLAME_BODY, FLAME_BODY, SWARM | FLAME_BODY, NO_ABILITY, SWARM |
| larvitar | GUTS, GUTS, INTIMIDATE | GUTS, NO_ABILITY, INTIMIDATE |
| leafeon | CHLOROPHYLL, CHLOROPHYLL, NO_ABILITY | CHLOROPHYLL, NO_ABILITY, NO_ABILITY |
| lileep | STORM_DRAIN, STORM_DRAIN, REGENERATOR | STORM_DRAIN, NO_ABILITY, REGENERATOR |
| lugia | PRESSURE, PRESSURE, MULTISCALE | PRESSURE, NO_ABILITY, MULTISCALE |
| magikarp | SWIFT_SWIM, SWIFT_SWIM, RATTLED | SWIFT_SWIM, NO_ABILITY, RATTLED |
| magnezone | MAGNET_PULL, STURDY, ANALYTIC | MAGNET_PULL, LEVITATE, ANALYTIC |
| mareep | STATIC, FLUFFY, STATIC | STATIC, FLUFFY, NO_ABILITY |
| mawile | HYPER_CUTTER, INTIMIDATE, SHEER_FORCE | HUGE_POWER, INTIMIDATE, SHEER_FORCE |
| meganium | SERENE_GRACE, MEGA_SOL, TRIAGE | SERENE_GRACE, OVERGROW, TRIAGE |
| meowth_galarian | BATTLE_ARMOR, TOUGH_CLAWS, STEELY_SPIRIT | PICKUP, TOUGH_CLAWS, UNNERVE |
| metapod | SHED_SKIN, SHED_SKIN, SHED_SKIN | SHED_SKIN, NO_ABILITY, NO_ABILITY |
| mew | SYNCHRONIZE, SYNCHRONIZE, TRACE | SYNCHRONIZE, NO_ABILITY, TRACE |
| mewtwo | PRESSURE, PRESSURE, UNNERVE | PRESSURE, NO_ABILITY, UNNERVE |
| mimikyu | DISGUISE, DISGUISE, DISGUISE | DISGUISE, NO_ABILITY, NO_ABILITY |
| misdreavus | LEVITATE, LEVITATE, PRANKSTER | LEVITATE, NO_ABILITY, PRANKSTER |
| mismagius | LEVITATE, LEVITATE, PRANKSTER | LEVITATE, NO_ABILITY, PRANKSTER |
| mr__mime | FILTER, TECHNICIAN, TECHNICIAN | FILTER, TECHNICIAN, NO_ABILITY |
| muk | POISON_TOUCH, NO_ABILITY, POISON_TOUCH | POISON_TOUCH, NO_ABILITY, NO_ABILITY |
| ninetales_alolan | SNOW_CLOAK, SNOW_CLOAK, SNOW_WARNING | SNOW_CLOAK, NO_ABILITY, SNOW_WARNING |
| octillery | SNIPER, SNIPER, NO_ABILITY | SNIPER, NO_ABILITY, NO_ABILITY |
| pawniard | DEFIANT, INNER_FOCUS, PRESSURE | DEFIANT, INNER_FOCUS, SHARPNESS |
| ponyta_galarian | PASTEL_VEIL, PASTEL_VEIL, MAGIC_GUARD | PASTEL_VEIL, NO_ABILITY, MAGIC_GUARD |
| pupitar | SHED_SKIN, SHED_SKIN, INTIMIDATE | SHED_SKIN, NO_ABILITY, INTIMIDATE |
| quagsire | WATER_ABSORB, WATER_ABSORB, NO_ABILITY | WATER_ABSORB, NO_ABILITY, NO_ABILITY |
| raichu_alolan | STATIC, STATIC, MOTOR_DRIVE | STATIC, NO_ABILITY, NO_ABILITY |
| rapidash_galarian | PASTEL_VEIL, PASTEL_VEIL, MAGIC_GUARD | PASTEL_VEIL, NO_ABILITY, MAGIC_GUARD |
| raticate_alolan | HUSTLE, GUTS, HUSTLE | HUSTLE, GUTS, NO_ABILITY |
| rattata | FRISK, TRACE, TECHNICIAN | HUSTLE, GUTS, TECHNICIAN |
| rattata_alolan | HUSTLE, GUTS, HUSTLE | HUSTLE, GUTS, NO_ABILITY |
| salandit | POISON_TOUCH, NO_ABILITY, OBLIVIOUS | POISON_TOUCH, OBLIVIOUS, MERCILESS |
| salazzle | POISON_TOUCH, NO_ABILITY, OBLIVIOUS | POISON_TOUCH, OBLIVIOUS, MERCILESS |
| scyther | TECHNICIAN, SHARPNESS, HYPER_CUTTER | TECHNICIAN, SWARM, HYPER_CUTTER |
| sentret | KEEN_EYE, KEEN_EYE, FRISK | KEEN_EYE, NO_ABILITY, FRISK |
| seviper | SHED_SKIN, NO_ABILITY, MERCILESS | SHED_SKIN, INTIMIDATE, MERCILESS |
| shuppet | INSOMNIA, FRISK, CURSED_BODY | FRISK, CURSED_BODY, PRANKSTER |
| skarmory | KEEN_EYE, STURDY, MIRROR_ARMOR | IRON_BARBS, STURDY, SHARPNESS |
| slowking_galarian | OWN_TEMPO, OWN_TEMPO, REGENERATOR | OWN_TEMPO, NO_ABILITY, REGENERATOR |
| slowpoke_galarian | OWN_TEMPO, OWN_TEMPO, REGENERATOR | OWN_TEMPO, NO_ABILITY, REGENERATOR |
| smoochum | HYDRATION, NO_ABILITY, HYDRATION | HYDRATION, NO_ABILITY, NO_ABILITY |
| sneasler | MERCILESS, POISON_TOUCH, TECHNICIAN | PRESSURE, POISON_TOUCH, TECHNICIAN |
| sylveon | CUTE_CHARM, CUTE_CHARM, PIXILATE | CUTE_CHARM, NO_ABILITY, PIXILATE |
| talonflame | FLAME_BODY, FLAME_BODY, GALE_WINGS | FLAME_BODY, NO_ABILITY, GALE_WINGS |
| tauros_paldean_fire | INTIMIDATE, ANGER_POINT, NO_ABILITY | INTIMIDATE, RECKLESS, NO_ABILITY |
| tauros_paldean_water | INTIMIDATE, ANGER_POINT, NO_ABILITY | INTIMIDATE, RECKLESS, NO_ABILITY |
| tirtouga | SOLID_ROCK, STURDY, SWIFT_SWIM | STURDY, SHEER_FORCE, SWIFT_SWIM |
| torkoal | WHITE_SMOKE, DROUGHT, SHELL_ARMOR | DROUGHT, WHITE_SMOKE, SHELL_ARMOR |
| tsareena | QUEENLY_MAJESTY, MOXIE, OBLIVIOUS | QUEENLY_MAJESTY, NO_ABILITY, OBLIVIOUS |
| tyranitar | SAND_STREAM, SAND_STREAM, INTIMIDATE | SAND_STREAM, NO_ABILITY, INTIMIDATE |
| tyrantrum | STRONG_JAW, STRONG_JAW, ROCK_HEAD | STRONG_JAW, RECKLESS, ROCK_HEAD |
| tyrunt | STRONG_JAW, STRONG_JAW, STURDY | STRONG_JAW, RECKLESS, STURDY |
| umbreon | SYNCHRONIZE, INNER_FOCUS, REGENERATOR | SYNCHRONIZE, INNER_FOCUS, IMMUNITY |
| unown | LEVITATE, LEVITATE, LEVITATE | LEVITATE, NO_ABILITY, NO_ABILITY |
| ursalunabm | MINDS_EYE, NO_ABILITY, NO_ABILITY | GUTS, BULLETPROOF, NO_ABILITY |
| venusaur | CHLOROPHYLL, THICK_FAT, THICK_FAT | CHLOROPHYLL, THICK_FAT, NO_ABILITY |
| vibrava | COMPOUND_EYES, LEVITATE, OVERCOAT | COMPOUND_EYES, OVERCOAT, TINTED_LENS |
| vikavolt | LEVITATE, LEVITATE, LEVITATE | LEVITATE, HUSTLE, SPEED_BOOST |
| vileplume | CHLOROPHYLL, EFFECT_SPORE, EFFECT_SPORE | CHLOROPHYLL, EFFECT_SPORE, NO_ABILITY |
| volcarona | FLAME_BODY, FLAME_BODY, SWARM | FLAME_BODY, NO_ABILITY, SWARM |
| voltorb | SOUNDPROOF, AFTERMATH, AFTERMATH | SOUNDPROOF, AFTERMATH, NO_ABILITY |
| vulpix_alolan | SNOW_CLOAK, SNOW_CLOAK, SNOW_WARNING | SNOW_CLOAK, NO_ABILITY, SNOW_WARNING |
| weedle | POISON_POINT, NO_ABILITY, POISON_POINT | POISON_POINT, NO_ABILITY, NO_ABILITY |
| wobbuffet | SHADOW_TAG, SHADOW_TAG, SHADOW_TAG | SHADOW_TAG, NO_ABILITY, NO_ABILITY |
| wooper | WATER_ABSORB, WATER_ABSORB, NO_ABILITY | WATER_ABSORB, NO_ABILITY, NO_ABILITY |
| zangoose | IMMUNITY, GUTS, TOUGH_CLAWS | IMMUNITY, SCRAPPY, TOUGH_CLAWS |
| zweilous | HUSTLE, HUSTLE, HUSTLE | HUSTLE, NO_ABILITY, NO_ABILITY |

## Catch rate changes (62)

| Pokémon | Before | After |
|---|---|---|
| abomasnow | 45 | 60 |
| applin | 45 | 255 |
| archaludon | 45 | 10 |
| arctibax | 45 | 25 |
| articuno | 3 | 40 |
| baxcalibur | 45 | 10 |
| breloom | 45 | 90 |
| buneary | 45 | 190 |
| camerupt | 45 | 150 |
| celebi | 45 | 25 |
| centiskorch | 45 | 75 |
| charcadet | 25 | 90 |
| charjabug | 45 | 120 |
| clodsire | 90 | 45 |
| croagunk | 45 | 140 |
| drifblim | 45 | 60 |
| drifloon | 45 | 125 |
| drilbur | 45 | 120 |
| entei | 3 | 40 |
| excadrill | 45 | 60 |
| fletchinder | 45 | 120 |
| fletchling | 45 | 255 |
| froslass | 45 | 75 |
| glimmora | 45 | 25 |
| grubbin | 45 | 255 |
| grumpig | 45 | 60 |
| ho_oh | 3 | 40 |
| hydrapple | 45 | 10 |
| kingambit | 45 | 25 |
| lombre | 45 | 120 |
| lopunny | 45 | 60 |
| lotad | 45 | 255 |
| lugia | 3 | 40 |
| mew | 45 | 25 |
| mewtwo | 3 | 40 |
| moltres | 3 | 40 |
| numel | 45 | 255 |
| raikou | 3 | 40 |
| raticate | 90 | 130 |
| raticate_alolan | 90 | 130 |
| rookidee | 200 | 255 |
| scrafty | 45 | 90 |
| scraggy | 45 | 180 |
| sealeo | 45 | 120 |
| shroomish | 45 | 255 |
| sizzlipede | 45 | 190 |
| sneasler | 60 | 45 |
| snorunt | 45 | 190 |
| snover | 45 | 120 |
| spheal | 45 | 255 |
| spoink | 45 | 255 |
| suicune | 3 | 40 |
| swablu | 45 | 255 |
| toxicroak | 45 | 75 |
| trapinch | 45 | 255 |
| unown | 225 | 255 |
| ursaluna | 75 | 60 |
| ursalunabm | 45 | 60 |
| vibrava | 45 | 120 |
| wimpod | 45 | 90 |
| wyrdeer | 135 | 45 |
| zapdos | 3 | 40 |

## Caveats

### Base exp capped at 255 (49 Pokémon)

Your `db ... ; base exp` field is one byte; Lumi uses Gen 8 values that exceed 255. These were clamped:

| Pokémon | Lumi value | Written |
|---|---|---|
| aggron | 265 | 255 |
| annihilape | 268 | 255 |
| archaludon | 265 | 255 |
| armarouge | 263 | 255 |
| articuno | 290 | 255 |
| baxcalibur | 300 | 255 |
| blastoise | 265 | 255 |
| blissey | 635 | 255 |
| celebi | 300 | 255 |
| ceruledge | 263 | 255 |
| chansey | 395 | 255 |
| charizard | 267 | 255 |
| crobat | 268 | 255 |
| dipplin | 265 | 255 |
| dragapult | 300 | 255 |
| dragonite | 300 | 255 |
| dusknoir | 263 | 255 |
| electivire | 270 | 255 |
| entei | 290 | 255 |
| farigiraf | 260 | 255 |
| feraligatr | 265 | 255 |
| flygon | 260 | 255 |
| gallade | 259 | 255 |
| gardevoir | 259 | 255 |
| ho_oh | 340 | 255 |
| hydreigon | 270 | 255 |
| kingambit | 275 | 255 |
| kingdra | 270 | 255 |
| lugia | 340 | 255 |
| magmortar | 270 | 255 |
| magnezone | 268 | 255 |
| mamoswine | 265 | 255 |
| meganium | 263 | 255 |
| mew | 300 | 255 |
| mewtwo | 340 | 255 |
| moltres | 290 | 255 |
| porygon_z | 268 | 255 |
| raikou | 290 | 255 |
| rhyperior | 268 | 255 |
| rypherior | 268 | 255 |
| salamence | 300 | 255 |
| suicune | 290 | 255 |
| togekiss | 273 | 255 |
| typhlosion | 267 | 255 |
| typhlosion_hisuian | 267 | 255 |
| tyranitar | 300 | 255 |
| venusaur | 263 | 255 |
| walrein | 265 | 255 |
| zapdos | 290 | 255 |

### Abilities that don't exist in your hack (55 distinct)

Where Lumi assigns one of these, the slot was left at your current value rather than blanked:


Gluttony (17), Run Away (16), Infiltrator (15), Leaf Guard (10), Pickpocket (8), Corrosion (7), Unburden (7), Download (6), Grassy Surge (6), Stench (6), Telepathy (6), Battery (5), Ripen (5), Unaware (5), Early Bird (4), Heavy Metal (4), Misty Surge (4), Moody (4), Sticky Hold (4), Aroma Veil (3), Cud Chew (3), Emergency Exit (3), Harvest (3), Quick Draw (3), Simple (3), Steelworker (3), Sweet Veil (3), Anticipation (2), Ball Fetch (2), Dazzling (2), Defeatist (2), Electric Surge (2), Flare Boost (2), Forewarn (2), Friend Guard (2), Gooey (2), Healer (2), Liquid Ooze (2), Power of Alchemy (2), Psychic Surge (2), Shield Dust (2), Stalwart (2), Suction Cups (2), Supersweet Syrup (2), Wimp Out (2), Cotton Down (1), Curious Medicine (1), Dancer (1), Grass Pelt (1), Light Metal (1), Long Reach (1), Mind's Eye (1), Sand Spit (1), Surge Surfer (1), Toxic Boost (1)



### Skipped — no Luminescent counterpart (8)

`charmeleon_clone`, `gorotora`, `kotora`, `mesmeria`, `raitora`, `teddiursabm`, `ursaringbm`, `watu`


`charmeleon_clone` was skipped deliberately as an internal duplicate entry.


### Convention translation

BDSP marks an empty ability slot by repeating slot 1. Those were written as `NO_ABILITY` to match your files, rather than copied literally (which would have produced entries like `OBLIVIOUS, OBLIVIOUS`).


### Pre-existing issue found

`data/pokemon/base_stats/rypherior.asm` is an orphan: byte-identical to `rhyperior.asm`, has no `RYPHERIOR` species constant, and is never `INCLUDE`d by `base_stats.asm`. It predates this change and is safe to delete.


### Cosmetic only

`chansey` and `shuckle` show a diff because zero-padded values (`05`) were normalised to `5`. Numerically identical.
