# Fifth trainer theme pass — fixes implemented

Applied 20 October 2026. **All four recommended issue groups are resolved**, affecting **13 Pokémon slots across 12 party records**. There are sixteen changed move fields, including the three previously empty Kadabra slots. All **594 parties / 1,819 Pokémon**, species, levels, held items, effective abilities, names, classes, IDs, party sizes and encounter selections are preserved.

The game's move definitions, player learnsets, dialogue and engine code are unchanged. Earlier authorized changes remain intact. The review's rejected candidates, authored NPC/player move-access observations and older phone findings were not recommended as new fixes and remain separately documented.

[Consolidated fifth review, retained as historical evidence](trainer-theme-audit-round5.md) · [Complete current roster checklist](trainer-theme-coverage.md)

| Party / trainer | Pokémon | Applied correction | Current selected moves |
|---|---|---|---|
| [GAVEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2203) — GAVEN | Politoed 58 | Belly Drum → **Ice Beam**. | Hydro Pump / Bubblebeam / Earth Power / Ice Beam |
| [GAVEN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2222) — GAVEN | Politoed 74 | Belly Drum → **Ice Beam**. | Hydro Pump / Bubblebeam / Earth Power / Ice Beam |
| [GAVEN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2273) — GAVEN | Politoed 48 | Belly Drum → **Ice Beam**. | Hydro Pump / Bubblebeam / Earth Power / Ice Beam |
| [GINA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5557) — GINA | Politoed 77 | Belly Drum → **Ice Beam**. | Hydro Pump / Bubblebeam / Earth Power / Ice Beam |
| [BLAKE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2292) — BLAKE | Walrein 46 | Belly Drum → **Body Slam**. | Ice Beam / Freeze Dry / Water Pulse / Body Slam |
| [MEGAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2649) — MEGAN | Walrein 47 | Belly Drum → **Body Slam**. | Ice Beam / Freeze Dry / Water Pulse / Body Slam |
| [JOANDZOE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6379) — JO & ZOE | Parasect 61 | Growth → **Swords Dance**. | X Scissor / Seed Bomb / Slash / Swords Dance |
| [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) — ROSS | Porygon2 36 | Recycle → **Recover**. | Recover / Foul Play / Discharge / Lock On |
| [ELLIOT](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5694) — ELLIOT | Munchlax 21 | Recycle → **Defense Curl**. | Defense Curl / Bite / Screech / Body Slam |
| [MARK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5288) — MARK | Natu 20 | Teleport → **Reflect**. | Peck / Night Shade / Confusion / Reflect |
| [MARK](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5288) — MARK | Kadabra 21 | Teleport-only set → complete Psychic/support set. | Psybeam / Disable / Kinesis / Reflect |
| [TROY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5920) — TROY | Ralts 7 | Teleport → **Reflect**. | Growl / Reflect / Double Team / Disarming Voice |
| [NEAL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5961) — NEAL | Ralts 6 | Teleport → **Flash**. | Confusion / Growl / Flash / Double Team |

## Preserved behavior and record formats

Elliot and Neal now use TRAINERTYPE_MOVES. Elliot's Ledian keeps its exact previous Safeguard / Mach Punch / Aerial Ace / Roost set. Troy now uses TRAINERTYPE_MOVES_ABILITY: Sunkern retains its previous Absorb / Growth / Tackle set and Chlorophyll; Ralts retains Synchronize. His Sunkern's fourth NO_MOVE slot remains empty. The other nine modified party records already had explicit moves and retain their formats.

Gina's Politoed retains Drizzle. Spencer's earlier Snow Warning and all other prior untargeted corrections remain intact. Jo & Zoe's other Victreebel set keeps Growth because it has special attacks. Functional Belly Drum sets elsewhere remain as authored. Mark's Kadabra now has useful actions immediately instead of only an escape move that fails in trainer battles; Neal's Flash supports his existing dialogue about light.

## Verification

- Exact-scope comparison passed across **594 parties / 1,819 Pokémon**: only the thirteen approved effective sets changed, with sixteen differing move fields. All untargeted effective data was preserved.
- Every proposed move passed the local level/TM/egg/tutor and pre-evolution access check.
- `python3 tools/audit_trainer_movesets.py`: **0 errors, 0 dependency/design warnings**, checking all 594 records and **7,233 occupied move slots**.
- `python3 tools/audit_trainers.py`: passed **594 parties, 734 references, 104 class rows and 321 Battle Tower builds**.
- The release ROM rebuilt successfully. Its native ReadTrainerParty loaded every one of the **593 source-backed fixed parties**, passing **24,158 species/level/item/ability/move/PP checks**, including all twelve modified records. CAL2 remains the documented Mystery Gift SRAM exception; its stored placeholder is source-checked.
- The pre-existing non-party game files and the reusable audit tool remained byte-identical. Git whitespace checks passed.

These checks verify source data and native party loading; they do not claim a full playthrough of every encounter.
