# Second trainer theme pass — Pokémon changes applied

Applied 20 October 2026 following the user's request for mon changes only.

**39 targeted Pokémon slots across 36 party records:** 32 species replacements and seven moveset-only changes. All 594 parties, 1,819 slots, levels, trainer names, classes and encounter references are retained. Denis and Eusine's rematch now use explicit moveset records so their advertised techniques are available; unaffected teammates retain their previous automatic moves.

No additional dialogue or engine code was changed. Earlier authorized changes remain intact. All 16 second-review findings with a roster/moveset solution are addressed. The three phone dialogue/code findings remain outside this pass.

[Second review, preserved as pre-change evidence](trainer-theme-audit-round2.md) · [Current complete roster checklist](trainer-theme-coverage.md) · [First-pass fixes](trainer-theme-fixes.md)

| Review finding | Trainer | Applied Pokémon change |
|---|---|---|
| 1 | Koga | Initial Crobat gets Hypnosis over Toxic. Rematch Crobat gets Hypnosis and Confuse Ray over U-turn and Roost, keeping both attacking STAB moves. Salazzle retains the original ability choices. |
| 2 | Bird Keeper Denis | Corvisquire gets Fly over Dual Wingbeat. Watu keeps its previous automatic moves as an explicit set. |
| 6 | Eusine | Rematch Hypno gets Hypnosis over Trick Room. Gengar gets Hypnosis over Toxic Spikes, directly supporting Dream Eater. The other three partners keep their previous moves. |
| 7 | Fisher Andre | Corsola → Gyarados, Lv.36, matching Lake of Rage fishing. |
| 8 | Fisher Henry | Chinchou → Tentacool and Remoraid → Qwilfish, both Lv.11, matching Route 32 fishing. |
| 9 | Cooltrainer Megan | Lickilicky → Yanma, Lv.47, beside Yanmega to demonstrate her evolution research. Uses Air Slash, Bug Buzz, AncientPower and Hypnosis. |
| 10 | Brock | Rampardos → Bastiodon, Lv.49, with Leftovers and Sturdy. Body Press, Power Gem, Toxic and Protect reinforce his defensive fossil theme. Aerodactyl remains as the varied offensive fossil. |
| 11 | School Girl Sharon | Altaria gets Sing over Dragon Dance, retaining Dual Wingbeat, Moonblast and Roost. |
| 12 | Whitney | Rematch Kangaskhan → Lopunny, Lv.78, continuing her original Buneary. Life Orb + Adaptability with Fake Out, Dizzy Punch, Drain Punch and Ice Punch. Dizzy Punch avoids relying on NPC Return's low base-happiness power. |
| 13 | Silver | All three starter branches replace the Gligar/Gliscor slot consistently: Zubat Lv.14 at Azalea; Golbat Lv.22 at Burned Tower; Golbat Lv.40 at the Underground; Golbat Lv.68 at Victory Road; Golbat Lv.49 at Mount Moon; Crobat Lv.82 at the Plateau. Later Golbat uses Eviolite; final Crobat uses Leftovers and Infiltrator. The friendship evolution appears at his completed character arc without changing dialogue. |
| 14 | Crystal | Every Cape branch retains Marowak Lv.69 instead of Ursaluna/Bloodmoon Ursaluna. Thick Club + Battle Armor; Bonemerang, Rock Slide, Fire Punch and Swords Dance. Earlier Cubone/Marowak partners remain unchanged. |
| 15 | Lorelei | Articuno → Glaceon, Lv.87, using the nonlegendary alternative because the requested scope excludes additional main-character dialogue. Leftovers + Refrigerate; Ice Beam, Hyper Voice, Shadow Ball and Protect. |
| 16 | Lorelei | Slowbro gets Ice Beam over Psychic, retaining Calm Mind, Surf and Slack Off. |
| 17 | Ariana | Rematch Octillery → Milotic, Lv.43, retaining the partner from her first fight. Competitive + Mystic Water; Scald, Moonblast, Recover and Hypnosis. Toxapex remains. |
| 18 | Archer | Both stored Cloyster slots → Krookodile, retaining Lv.44/42. Intimidate + BlackGlasses; Earthquake, Crunch, Rock Slide and Taunt. No new encounter was added for the stored unused variant. |
| 19 | Bird Keeper Perry | Corviknight → Talonflame, Lv.61, with Brave Bird, Flare Blitz, Agility and Roost. Honchkrow remains. |

## Excluded by the mon-only scope

- **Finding 3, Beverly:** hardcoded Snubbull/Granbull phone wording. Changing her party alone cannot make both existing names consistent.
- **Finding 4, Wilton/Kenji:** phone reader omits ability bytes. This requires an engine fix; changing their appropriate teams would conceal the parser defect.
- **Finding 5, rematch callers:** the phone helper selects names from fixed starting parties. This requires phone code or wording changes rather than substituting suitable Pokémon.

## Validation

The source audit passed: 594 trainer parties, 734 references, 104 trainer-class rows and 321 Battle Tower builds. Exact-scope comparison confirmed that only the listed Pokémon slots changed, apart from retaining automatic moves explicitly in Denis and Eusine records. All replacement authored moves are legal under the local level, TM, egg and tutor sources, and all explicit ability slots exist. The final release ROM build passed. Its native ReadTrainerParty loaded all 36 modified parties and passed 2,268 checks covering species, levels, held items, explicit abilities, moves and nonzero PP. Git diff whitespace checks passed.
