# Trainer theme fixes — implemented

Applied 20 October 2026.

**All 31 review findings and both dialogue-only notes are resolved.** This changes **50 Pokémon slots across 38 party records** and **13 dialogue blocks in nine files**. All **594 party records**, **1,819 slots**, levels, team sizes and trainer formats are preserved. Five legacy/unplaced findings were updated in stored data without adding encounters.

Every replacement with custom moves has a species-appropriate set checked against this game's level, TM, egg and tutor sources; Smeargle uses authored Sketch sets. Held items and explicit abilities were adjusted where needed. The accepted designs from the original review remain, including the mixed-team Battle Tower generator, Goldenrod's Fairy allowance, Brock's Steelix and Cody/Cara's intentionally non-Dragon teams.

[Current complete trainer checklist](trainer-theme-coverage.md) · [Original pre-change review](trainer-theme-audit.md)

| Finding | Trainer | Implemented substitutions | Additional resolution |
|---|---|---|---|
| <a id="finding-1"></a>1 | Bird Keeper Jose | Talonflame → Farfetch'd; Honchkrow → Farfetch'd | All three tiers retain Farfetch'd; the final set uses Stick + Super Luck. Stick-aroma dialogue names Farfetch'd explicitly. |
| <a id="finding-2"></a>2 | Cooltrainer Beth | Mimikyu → Rapidash | All three tiers gain Rapidash; the riding call explicitly names Rapidash, allowing the other partners to remain varied. |
| <a id="finding-3"></a>3 | Hiker Bailey | Corsola → Rhydon | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-4"></a>4 | Youngster Gordon | Numel → Ekans | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-5"></a>5 | Biker Glenn | Galarian Slowking → Crobat; Alolan Golem → Electrode | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-6"></a>6 | Cosplayer Mimi | Pidgeot → Mimikyu | Dialogue now explains Mimikyu as a costume partner and Mr. Rime as a posing coach. |
| <a id="finding-7"></a>7 | Cosplayer Pixie | Golduck → Smeargle; Tauros → Sylveon | Uses the costume-designer option: Smeargle and ribbon-themed Sylveon, with matching dialogue. |
| <a id="finding-8"></a>8 | Cosplayer Noelle | Exeggutor → Smeargle | Smeargle sketches mascot outfits; the dialogue explicitly explains surfer Raichu and winter Glaceon costumes. |
| <a id="finding-9"></a>9 | Juggler Irwin | Elekid → Voltorb; Flaaffy → Aipom; Electabuzz → Electrode; Ampharos → Ambipom; Electivire → Electrode | Both mismatching evolution lines were replaced across all four stored tiers; the horse and singer remain circus partners. |
| <a id="finding-10"></a>10 | Juggler Fritz | Gorotora → Electrode; Noctowl → Mr. Rime | Dialogue now describes balancing Electrode and Mr. Rime losing his footing aboard the ship. |
| <a id="finding-11"></a>11 | Juggler Silas | Golduck → Mr. Mime | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-12"></a>12 | Youngster Jimmy | Galarian Slowking → Dodrio | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-13"></a>13 | Youngster Owen | Toxapex → Sandslash; Mamoswine → Tauros | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-14"></a>14 | Youngster Jason | Steelix → Tauros | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-15"></a>15 | Youngster Mikey | Golett → Pidgey | Retains Drilbur as a distinct favorite; dialogue establishes garden digging and training with Pidgey. |
| <a id="finding-16"></a>16 | Youngster Ian | Numel → Drowzee | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-17"></a>17 | Youngster Warren | Camerupt → Fearow | Retains Victreebel as a garden-raised favorite and explains Warren's nervousness. |
| <a id="finding-18"></a>18 | Scientist Ross | Ariados → Porygon2 | Retains Croagunk as a biological research subject beside artificial Porygon2. |
| <a id="finding-19"></a>19 | Burglar Eddie | Nidorina → Sneasel | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-20"></a>20 | Lass Carrie | Impidimp → Jigglypuff | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-21"></a>21 | Lass Krise | Morgrem → Steenee | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-22"></a>22 | Teacher Hillary | Banette → Mr. Mime | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-23"></a>23 | Teacher Shirley | Banette → Xatu | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-24"></a>24 | Pokémaniac Ethan | Raticate → Lickilicky | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-25"></a>25 | Picnicker Tiffany | Alolan Raticate → Jigglypuff | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-26"></a>26 | Biker Charles | Armarouge → Ceruledge | New species gets suitable moves; original levels and party size retained. |
| <a id="finding-27"></a>27 | Cosplayer Maya | Pidgeot → Mr. Rime; Weavile → Mimikyu; Lickilicky → Ditto | Stored legacy team uses a performer, costume Pokémon and transformer; no new encounter or rematch was added. |
| <a id="finding-28"></a>28 | Legacy male Executive 1 | Tinkatuff → Pawniard | Stored unplaced roster updated without adding an encounter. |
| <a id="finding-29"></a>29 | Legacy male Executive 2 | Heracross → Croagunk | Stored unplaced roster updated without adding an encounter. |
| <a id="finding-30"></a>30 | Legacy male Executive 3 | Farfetch'd → Golbat | Stored unplaced roster updated without adding an encounter. |
| <a id="finding-31"></a>31 | Legacy female Executive 1 | Alolan Ninetales → Houndoom; Noctowl → Murkrow; Mr. Mime → Hypno | All three unexplained slots were replaced in the stored unplaced roster. |

**Dialogue-only fixes:** Joey now talks about training his original partner and helping the whole team grow. Benny now explains that Trapinch and Pineco need patience to grow, retaining both Bug-type partners.

**Validation:** release ROM build passed. The rebuilt ROM's native `ReadTrainerParty` loaded all 38 changed party records and passed **1,326 checks** for species, levels, items, explicit ability slots, moves and nonzero PP. The trainer source audit passed (594 parties, 734 references, 104 class rows, 321 Tower builds); all 29,136 source text lines passed the 18-cell width audit. Replacement custom moves were checked against this game's own movepools, and all replacement explicit abilities exist. The full-source comparison confirmed that only the 50 approved slots changed and that all other party data, levels, sizes and formats remain intact.

**Existing broader-check failures:** the full game-data audit reports the same 38 Cerulean Cave/tileset/warp errors when the original HEAD versions of the changed files are substituted. The portrait suite passes nine tests and fails an existing Crystal Cape assertion that expects five far-text labels where the original HEAD already has six. These pre-existing issues were not introduced by the trainer changes.
