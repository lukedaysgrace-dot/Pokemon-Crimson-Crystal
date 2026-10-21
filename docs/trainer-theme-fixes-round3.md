# Third trainer theme pass — fixes implemented

Applied 20 October 2026. **All six new findings are resolved**, covering **17 targeted Pokémon slots in 15 party records**. Two species were replaced; the other changes concern moves or abilities. All 594 party records, 1,819 Pokémon slots, levels, party sizes, names, trainer classes and encounter selections are retained.

No dialogue or engine code was changed in this pass. Earlier authorized changes remain intact. Stored JOE and NAOKO1 parties were updated without adding encounters. The three older phone-dialogue/code findings remain outside this pass.

[Third review, retained as historical evidence](trainer-theme-audit-round3.md) · [Current complete roster checklist](trainer-theme-coverage.md)

| Finding | Trainer | Implemented change |
|---|---|---|
| <a id="finding-1"></a>1 | [WAYNE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3559) | Venipede → Pineco Lv.18. Explicit Headbutt / Pin Missile / Rapid Spin / Protect. Sizzlipede retains its previous effective moves. |
| <a id="finding-2"></a>2 | Ten Dream Eater party records | All eleven affected Pokémon receive sleep support or a reliable replacement attack; detailed below. Every remaining Dream Eater user across all fixed teams now has its own selected sleep move. |
| <a id="finding-3"></a>3 | [BOARDER_SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6087) | Abomasnow gets Snow Warning, slot 1. Piloswine retains Oblivious and Weavile retains Pressure. Moves remain automatic and unchanged. |
| <a id="finding-4"></a>4 | [KELLY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2566) | Talonflame: Acrobatics → Roost. Rhydon: Double-Edge → Headbutt; Rock Slide → Rock Tomb; Reckless → Rock Head. Explicit abilities preserve Talonflame’s existing effective Flame Body, Sirfetch’d’s Super Luck and Togetic’s Serene Grace. |
| <a id="finding-5"></a>5 | [ADRIAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2469) | Ampharos: Power Gem → Bulldoze, retaining Galvanize. The team now has super-effective coverage against all eighteen ordinary single types. |
| <a id="finding-6"></a>6 | [RAYMOND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3640) | Seaking → Magikarp Lv.37, using its normal level-up moves. This deliberately makes his unsuccessful-angler battle easier, as described in the review. |

## Dream Eater corrections

| Party | Applied correction | Placement |
|---|---|---|
| [JOE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1430) | Exeggutor: Dream Eater → Psychic. | Stored; no direct map reference |
| [CHAD4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1611) | Espeon and Xatu: Dream Eater → Psychic on both. | Direct map reference |
| [JOSE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1752) | Noctowl: Future Sight → Hypnosis; retains Dream Eater, Hurricane and Roost. | Direct map reference |
| [FIDEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5250) | Noctowl: Psychic → Hypnosis; retains Dream Eater, Air Slash and Roost. | Direct map reference |
| [JARED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5332) | Noctowl: Psychic → Hypnosis; retains Dream Eater, Hurricane and Roost. | Direct map reference |
| [RODNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5345) | Noctowl: Psychic → Hypnosis; retains Dream Eater, Hurricane and Roost. | Direct map reference |
| [NAOKO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6260) | Espeon: Dream Eater → Psychic. | Stored; no direct map reference |
| [GRUNTF_7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7420) | Gengar: Dream Eater → Shadow Ball; retains Toxic Spikes. | Direct map reference |
| [GRUNTF_8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7433) | Gengar: Toxic Spikes → Hypnosis; retains Dream Eater. | Direct map reference |
| [GRUNTF_9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7443) | Gengar: Toxic Spikes → Hypnosis; retains Dream Eater. | Direct map reference |

## Record formats and preservation

Wayne and seven normal-format Dream Eater parties now use TRAINERTYPE_MOVES. All unaffected teammates have their previous effective automatic moves written explicitly. Spencer uses TRAINERTYPE_ABILITY, preserving automatic moves while specifying each partner’s ability. Kelly uses TRAINERTYPE_MOVES_ABILITY; an empty default second slot on Talonflame is materialized as its existing effective slot-1 Flame Body. Levels, items, and unrelated effective moves/abilities are unchanged.

## Validation

Exact-scope verification passed for all 594 parties and 1,819 slots, including preservation of all untargeted effective Pokémon data. Every changed authored move was checked against the local level-up, TM, egg and tutor sources; every explicit ability slot exists. A full fixed-team check confirms that every remaining Dream Eater user has its own sleep move. The trainer source audit passed: 594 parties, 734 references, 104 class rows and 321 Battle Tower builds. The release ROM rebuilt successfully. Its native ReadTrainerParty loaded all 15 modified parties and passed 541 checks of species, levels, held items, explicit abilities, exact moves and nonzero PP. Git diff checks passed, and the pre-existing non-party diff remained identical: no additional dialogue or engine changes.
