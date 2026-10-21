# Fourth trainer theme pass — fixes implemented

Applied 20 October 2026. **All thirteen approved move substitutions are complete**: the twelve ineffective setup sets and Ted's optional Snore replacement. Exactly one effective move changes in each of thirteen party records. All **594 parties / 1,819 Pokémon slots**, species, levels, items, effective abilities, party sizes, names, classes, IDs and encounter selections are preserved.

No dialogue, engine code or player-facing species learnset changed. Previous authorized changes remain intact. The older phone issues were excluded from this round's findings and remain separately documented.

[Fourth review, retained as historical evidence](trainer-theme-audit-round4.md) · [Current complete roster checklist](trainer-theme-coverage.md)

| Trainer / party | Pokémon | Applied change | Current selected moves |
|---|---|---|---|
| Ross — [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) | Croagunk 36 | Nasty Plot → **Sludge Bomb** | Acid Armor / Drain Punch / Sludge Bomb / Toxic |
| Jack — [JACK4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1549) | Farigiraf 71 | Nasty Plot → **Psychic** | Calm Mind / Psychic / Double-Edge / Giga Impact |
| Reena — [REENA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2778) | Crobat 70 | Nasty Plot → **Roost** | Cross Poison / Wing Attack / Crunch / Roost |
| Grunt — [GRUNTM_25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3144) | Toxicroak 39 | Nasty Plot → **Sludge Bomb** | Brick Break / Sludge Bomb / Toxic / Sucker Punch |
| Gregory — [GREGORY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3237) | Raichu 57 | Spark → **Thunderbolt** | ThunderPunch / Thunderbolt / Iron Tail / Nasty Plot |
| Franklin — [FRANKLIN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5232) | Hypno 61 | Psycho Cut → **Psychic** | Zen Headbutt / Psychic / Drain Punch / Nasty Plot |
| Ted — [TED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5741) | Ursaluna 44 | Snore → **Body Slam** | Brick Break / Body Slam / Crunch / Body Press |
| Spencer — [BOARDER_SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6098) | Abomasnow 40 | Swords Dance → **Blizzard** | Giga Drain / Blizzard / Mist / Freeze Dry |
| Joshua — [JOSHUA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6141) | Raichu 61 | Wild Charge → **Thunderbolt** | ThunderPunch / Thunderbolt / Iron Tail / Nasty Plot |
| Kane — [NINJA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7000) | Golbat 61 | Nasty Plot → **Confuse Ray** | Brave Bird / Cross Poison / Wing Attack / Confuse Ray |
| Shiro — [NINJA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7013) | Golbat 61 | Nasty Plot → **Confuse Ray** | Brave Bird / Cross Poison / Wing Attack / Confuse Ray |
| Kaede — [NINJA3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7026) | Crobat 61 | Nasty Plot → **Confuse Ray** | Brave Bird / Cross Poison / Wing Attack / Confuse Ray |
| Rigby — [TAMER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7327) | Persian 61 | Nasty Plot → **Hone Claws** | Double-Edge / Crush Claw / Play Rough / Hone Claws |

## Format changes and preservation

Ross, JACK4, GRUNTM_25 and Ted now use TRAINERTYPE_MOVES. Their unaffected teammates retain the exact previous automatic moves, now authored explicitly. Spencer now uses TRAINERTYPE_MOVES_ABILITY; Abomasnow retains Snow Warning, Piloswine retains Oblivious and Weavile retains Pressure, with both teammates' prior moves preserved. The other eight records already had explicit moves and retain their formats.

Gregory, Franklin and Joshua keep Nasty Plot and now have a special attack to boost. Jack retains Calm Mind and now has Psychic to benefit from it. Spencer's Blizzard supports his existing weather theme. Reena gains recovery; the three Fuchsia ninjas gain confusion; Rigby's Hone Claws supports his physical attacks and accuracy. Ted gains reliable physical Normal offense instead of depending on enemy-induced sleep.

## Validation

- Exact-scope comparison passed for all **594 parties / 1,819 slots**: exactly thirteen one-move substitutions, with all untargeted effective data preserved.
- All thirteen replacement moves passed local learnset/TM/egg/tutor access checks. Prior Snow Warning and Dream Eater sleep-support fixes remain intact.
- Fresh full-roster checks found no remaining Nasty Plot without special offense, Swords Dance without physical offense, or unsupported Snore candidate. The only automatic flag is the previously reviewed, intentional Imposter/Choice Scarf Ditto combination.
- Trainer audit passed: **594 parties, 734 references, 104 class rows, 321 Battle Tower builds**.
- The release ROM rebuilt successfully. Its native **ReadTrainerParty** loaded all **13 modified parties**, passing **520 checks** for species, levels, held items, explicit and class-default ability slots, exact moves and nonzero PP.
- Pre-existing non-party game files remained byte-identical, and Git whitespace checks passed. This is data/native-reader verification, not a full playthrough of every encounter.
