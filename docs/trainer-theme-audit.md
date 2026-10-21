# Crimson Crystal trainer theme review

**Implemented:** all 31 findings and both dialogue notes have been addressed. [See the applied changes](trainer-theme-fixes.md) and [current rosters](trainer-theme-coverage.md). The review below is the original pre-change snapshot; its old rosters describe the issues that were fixed.

Reviewed 20 October 2026 from the current local source.

**Scope:** all **594 fixed party records**, **1,819 Pokémon slots**, and **70 Battle Tower trainer identities**. Every rematch and starter branch was included. I compared actual species/type definitions, class, map placement, trainer dialogue and the relevant phone-personality text. The original rosters and recommendations below are retained as pre-change evidence.

**Verdict:** the specialist rosters are largely coherent. A separate type check across 25 specialist groups found only Brock's Steelix outside the nominal specialty, and I would keep it for geology/Onix continuity. Whitney's explicitly mixed Normal/Fairy theme was assessed separately. The most worthwhile changes concern missing personality/signature hooks and a small set of route trainers. Jugglers and Cosplayers would benefit most from clearer visual identities. Do not treat every unusual species as a mistake.

**Findings:** 4 strong story/setting conflicts, 10 recommended character-flavor improvements, 12 optional taste-based improvements, and 5 legacy/unplaced candidates. A finding can cover several rematch records; these are not counts of unique NPCs encountered in a playthrough. There are also two dialogue-only notes below.

**How to use the list:** A = explicit story/setting evidence; B = a stronger character concept, with reasonable alternatives; C = optional refinement, with the existing choice defensible; D = no direct map reference found, so lower priority. A Pokémon listed as a replacement slot can be perfectly valid for the broad class. Broad classes such as Cooltrainers, Schoolboys, Lasses and Pokéfans are not type specialists.

**Navigation:** [all 594 party checklists and all 70 Tower identities](trainer-theme-coverage.md). Levels below are existing levels, not requests to change difficulty. Alternatives are confirmed species in this game, but are theme suggestions rather than fully tested battle sets.

## Prioritized list

| # | Priority | Trainer | Pokémon/slots to reconsider | Main reason |
|---|---|---|---|---|
| [1](#finding-1) | A | Bird Keeper Jose — missing signature partner | Talonflame, Honchkrow | His Farfetch'd-centered phone personality has no Farfetch'd in any party. |
| [2](#finding-2) | A | Cooltrainer Beth — riding partner missing | Scyther, Mimikyu, Hitmontop | Her randomly named fast riding partner can be Mimikyu or Hitmontop. |
| [3](#finding-3) | A | Hiker Bailey — marine Pokémon in a mountain showcase | Corsola | Marine coral is out of place in an explicitly mountain-themed showcase. |
| [4](#finding-4) | A | Youngster Gordon — locally caught grass Pokémon claim | Numel | Numel does not match his grass-catching claim or the current local grass table. |
| [5](#finding-5) | B | Biker Glenn — speed boast versus slow partners | Galarian Slowking, Alolan Golem | Two slow, bulky partners undermine his explicit speed-battle boast. |
| [6](#finding-6) | B | Cosplayer Mimi — Pidgeot lacks a visible performance/costume hook | Pidgeot | An ordinary bird lacks the costume/performance hook supplied by Mr. Rime. |
| [7](#finding-7) | B | Cosplayer Pixie — neither Pokémon establishes the costume | Golduck, Tauros | No costume, disguise or named reference ties either partner to her character. |
| [8](#finding-8) | B | Cosplayer Noelle — disconnected costume partners | Exeggutor, Alolan Raichu, Glaceon | A tropical tree, surfer and ice fox need an explicit shared costume concept. |
| [9](#finding-9) | B | Juggler Irwin — electric animals obscure the juggling act | Elekid, Flaaffy, Electabuzz, Ampharos, Electivire | A trainer introducing ball dexterity has no ball-prop partner. |
| [10](#finding-10) | B | Juggler Fritz — team reads more like a Psychic/Tamer hybrid | Gorotora, Noctowl | Tiger/owl partners need an act; Electrode and Mr. Rime read more clearly. |
| [11](#finding-11) | B | Juggler Silas — Golduck is the weakest stage-act link | Golduck | Golduck is the weakest performance link beside a spinning star and fire prop. |
| [12](#finding-12) | B | Youngster Jimmy — slow occult king beside a runner | Galarian Slowking | A slow occult king is a weak personality match for a wind-fast runner. |
| [13](#finding-13) | B | Youngster Owen — team lacks ordinary route-kid identity | Toxapex, Mamoswine | Reef predator plus snow mammoth gives a generic route child no clear concept. |
| [14](#finding-14) | B | Youngster Jason — Steelix clashes with grass-catching story | Steelix | Underground steel serpent fits his grass-catching story less well than Tauros. |
| [15](#finding-15) | C | Youngster Mikey — unusually specialized starter pair | Drilbur, Golett | Digging/relic partners could use a stated excavation interest. |
| [16](#finding-16) | C | Youngster Ian — Numel needs a personal hook | Numel | Volcanic camel could use a stated personal/travel connection. |
| [17](#finding-17) | C | Youngster Warren — very mature pair without a character hook | Camerupt, Victreebel | Mature volcanic/carnivorous pair could use a personal hook; keep strong evolutions. |
| [18](#finding-18) | C | Scientist Ross — biology fits, radio engineering is less visible | Croagunk, Ariados | Venom biology works, but an artificial/electronic partner would show his radio research. |
| [19](#finding-19) | C | Burglar Eddie — Nidorina is a weak theft partner | Nidorina | Nidorina supplies poison without a clear theft or stealth role. |
| [20](#finding-20) | C | Lass Carrie — goblin versus cute-partner introduction | Impidimp | Goblin aesthetics are a less immediate match for cute-partner dialogue. |
| [21](#finding-21) | C | Lass Krise — Morgrem gives a darker tone than her cute presentation | Morgrem | A sinister goblin needs a personal-taste hook beside the cute presentation. |
| [22](#finding-22) | C | Teacher Hillary — haunted doll needs a subject/story | Banette | A haunted doll needs a school subject or story to explain the darker tone. |
| [23](#finding-23) | C | Teacher Shirley — haunted doll beside a protective caretaker | Banette | A haunted doll needs a subject/story beside a protective caretaker partner. |
| [24](#finding-24) | C | Pokémaniac Ethan — ordinary Raticate weakens collector flavor | Raticate | Ordinary Raticate does little to establish an unusual-species collector. |
| [25](#finding-25) | C | Picnicker Tiffany — Alolan Raticate versus fluffy pink signature theme | Alolan Raticate | Alolan Raticate is an aesthetic outlier beside her fluffy, dressed-up Clefairy. |
| [26](#finding-26) | C | Biker Charles — heroic armored knight is the weakest gang-flavor slot | Armarouge | A heroic knight is less immediate gang flavor than a sinister Fire enforcer. |
| [27](#finding-27) | D | Cosplayer Maya — legacy/rematch roster with no costume concept | Pidgeot, Weavile, Lickilicky | Legacy party has no stated costume reference and no direct map load found. |
| [28](#finding-28) | D | Legacy male Executive 1 — Tinkatuff softens the criminal theme | Tinkatuff | Unplaced party: playful fairy-smith is the weakest generic criminal hook. |
| [29](#finding-29) | D | Legacy male Executive 2 — Heracross lacks a criminal hook | Heracross | Unplaced party: forest beetle needs a criminal/enforcer role. |
| [30](#finding-30) | D | Legacy male Executive 3 — Farfetch'd is a comic pastoral outlier | Farfetch'd | Unplaced party: ordinary leek bird is an unexplained comic outlier. |
| [31](#finding-31) | D | Legacy female Executive 1 — several unexplained elegant/psychic choices | Alolan Ninetales, Noctowl, Mr. Mime | Unplaced party: ice beauty/owl/mime need an illusion or disguise concept. |

## Detailed recommendations

<a id="finding-1"></a>

### 1. [A] Bird Keeper Jose — missing signature partner

**Questionable slots:** Talonflame, Honchkrow.

Every current Pokémon is a legitimate bird. The mismatch is with Jose himself: his phone dialogue repeatedly names Farfetch'd, its stick, and its gift collecting, while all three rosters omit Farfetch'd. Talonflame/Honchkrow are replacement-slot candidates, not intrinsically wrong Bird Keeper picks.

**Current parties:**

- [JOSE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1744) — Route 27; map: Route27 — Talonflame 58, Honchkrow 58, Skarmory 58, Noctowl 58.
- [JOSE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1764) — Route 27; map: Route27 — Talonflame 45, Xatu 46, Corviknight 46, Honchkrow 46.
- [JOSE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1796) — Route 27; map: Route27 — Honchkrow 74, Delibird 74, Talonflame 74, Skarmory 74, Xatu 74.

**Suggested change:** Restore Farfetch'd in each tier: replace Talonflame in JOSE1 (Lv.58) and JOSE2 (Lv.45), and Honchkrow in JOSE3 (Lv.74). Keeping Farfetch'd in the final tier preserves the exact dialogue; Sirfetch'd is a stronger martial-bird alternative only if the named-species dialogue is updated. Also rewrite the randomly named 'stick aroma' line, or make it name Farfetch'd explicitly: adding one Farfetch'd does not prevent another team member being selected for that sentence.

**Alternative species:** Farfetch'd, Sirfetch'd.

**Character evidence:** [data/phone/text/jose_caller.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/jose_caller.asm:1); [data/phone/text/jose_overworld.asm:23](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/jose_overworld.asm:23); [engine/overworld/wildmons.asm:1083](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:1083).

<a id="finding-2"></a>

### 2. [A] Cooltrainer Beth — riding partner missing

**Questionable slots:** Scyther, Mimikyu, Hitmontop.

Beth's phone story describes riding her sweet, very fast Pokémon. Donphan and Mamoswine can support a riding theme; Mimikyu and Hitmontop especially do not, and Scyther is a weak conventional mount. Her mixed competitive team is otherwise valid for a Cooltrainer.

**Current parties:**

- [BETH1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2589) — Route 26; map: Route26 — Donphan 47, Scyther 47, Mimikyu 47, Hitmontop 47, Mamoswine 47.
- [BETH2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2643) — Route 26; map: Route26 — Donphan 58, Scyther 58, Mimikyu 58, Hitmontop 58, Mamoswine 58.
- [BETH3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2718) — Route 26; map: Route26 — Donphan 74, Scyther 74, Mimikyu 74, Hitmontop 74, Mamoswine 74.

**Suggested change:** Replace Mimikyu with Rapidash at Lv.47/58/74 across all three tiers, retaining the rest for variety. Use 'my RAPIDASH' explicitly in the riding call or replace that call with team-neutral text. The phone helper randomly chooses a Pokémon from the contact's base party, so a single new mount alone does not fix the dialogue.

**Alternative species:** Rapidash, Galarian Rapidash, Tauros.

**Character evidence:** [data/phone/text/beth_caller.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/beth_caller.asm:1); [data/phone/phone_contacts.asm:23](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/phone_contacts.asm:23); [engine/overworld/wildmons.asm:1083](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:1083).

<a id="finding-3"></a>

### 3. [A] Hiker Bailey — marine Pokémon in a mountain showcase

**Questionable slots:** Corsola.

Bailey explicitly introduces the power of mountain Pokémon. Corsola has Rock typing, but its coral-reef identity makes it the weakest environmental fit in a party otherwise built around rock, lava and ground-dwelling Pokémon. Rock typing alone does not make it a mountain animal.

**Current parties:**

- [BAILEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4475) — Route 46; map: Route46 — Hisuian Arcanine 44, Clodsire 44, Corsola 44, Golem 44, Magcargo 44.

**Suggested change:** Corsola Lv.44 → Rhydon Lv.44 is my first choice. Piloswine keeps a bulkier, cold-mountain identity; Sudowoodo preserves a smaller and more unusual Rock-type slot.

**Alternative species:** Rhydon, Piloswine, Graveler, Sudowoodo.

**Character evidence:** [maps/Route46.asm:152](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:152).

<a id="finding-4"></a>

### 4. [A] Youngster Gordon — locally caught grass Pokémon claim

**Questionable slots:** Numel.

Gordon says he found his Pokémon in the grass, but his only Pokémon is a volcanic camel. Route 32's current morning/day/night grass tables contain no Numel. This is a local-flavor conflict, not a rule that Youngsters cannot own Fire types.

**Current parties:**

- [GORDON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1241) — Route 32; map: Route32 — Numel 14.

**Suggested change:** Numel Lv.14 → Ekans Lv.14 best matches his grass-catching dialogue. Mareep or Sandshrew also appear in the current Route 32 tables. Alternatively keep Numel and give Gordon a line about traveling through a volcanic area.

**Alternative species:** Ekans, Mareep, Sandshrew.

**Character evidence:** [maps/Route32.asm:434](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:434); [data/wild/johto_grass.asm:1295](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/johto_grass.asm:1295).

<a id="finding-5"></a>

### 5. [B] Biker Glenn — speed boast versus slow partners

**Questionable slots:** Galarian Slowking, Alolan Golem.

He challenges the player to a speed battle and talks about torque. Galarian Slowking and Alolan Golem communicate bulk and slow power. They fit a rough Biker team broadly, but weaken this trainer's specific speed identity. Arcanine fits well.

**Current parties:**

- [GLENN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8554) — Route 17; map: Route17 — Galarian Slowking 59, Arcanine 60, Alolan Golem 60.

**Suggested change:** Slowking Lv.59 → Crobat Lv.59; Golem Lv.60 → Electrode Lv.60. Keep Arcanine. A one-slot change to Crobat is enough if you want Glenn to retain a heavy partner.

**Alternative species:** Crobat, Electrode, Rapidash, Jolteon.

**Character evidence:** [maps/Route17.asm:52](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:52).

<a id="finding-6"></a>

### 6. [B] Cosplayer Mimi — Pidgeot lacks a visible performance/costume hook

**Questionable slots:** Pidgeot.

Mr. Rime reads as a dressed-up performer. Pidgeot reads as an ordinary bird, and Mimi's generic costume dialogue never supplies a character reference that explains it. A bird costume could justify it; that reference is currently unstated.

**Current parties:**

- [COSPLAYER3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6911) — Route 3; map: Route3 — Pidgeot 51, Mr. Rime 51.

**Suggested change:** Pidgeot Lv.51 → Mimikyu Lv.51 gives her a costume creature beside a theatrical performer. Smeargle works as a costume artist, with a deliberately authored moveset.

**Alternative species:** Mimikyu, Smeargle, Ditto.

**Character evidence:** [maps/Route3.asm:70](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:70).

<a id="finding-7"></a>

### 7. [B] Cosplayer Pixie — neither Pokémon establishes the costume

**Questionable slots:** Golduck, Tauros.

Golduck and Tauros are a general battling pair. Neither conveys disguise, mimicry, costume making or performance without a named character reference. Her wig/convention dialogue supplies none. This is an unclear character concept rather than a type error.

**Current parties:**

- [COSPLAYER5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6931) — Route 4; map: Route4 — Golduck 51, Tauros 51.

**Suggested change:** For a clear costume theme, use Ditto + Mimikyu at Lv.51. For more variety from Daisy, use Smeargle + Sylveon and make her a costume designer with ribbons. Keeping Golduck/Tauros is defensible if her dialogue explicitly identifies the costume they represent.

**Alternative species:** Ditto, Mimikyu, Smeargle, Mr. Mime, Sylveon.

**Character evidence:** [maps/Route4.asm:143](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:143).

<a id="finding-8"></a>

### 8. [B] Cosplayer Noelle — disconnected costume partners

**Questionable slots:** Exeggutor, Alolan Raichu, Glaceon.

The team mixes a tropical tree, a surfing rodent and an ice fox, while her dialogue only says the costume is ready. There is no shared costume reference. Alolan Raichu and Glaceon can easily be mascot/winter-costume choices, so I would clarify those rather than assume they must go.

**Current parties:**

- [COSPLAYER6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6941) — Route 25 (Nugget Bridge 1); map: Route25 — Exeggutor 51, Alolan Raichu 52, Glaceon 52.

**Suggested change:** Minimal change: Exeggutor Lv.51 → Smeargle Lv.51, then describe Noelle making themed mascot costumes for Raichu and Glaceon. For a fully winter-themed performer, use Mr. Rime + Glaceon + Mimikyu. Write that concept into her dialogue.

**Alternative species:** Smeargle, Mimikyu, Mr. Rime, Sylveon.

**Character evidence:** [maps/Route25.asm:423](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:423).

<a id="finding-9"></a>

### 9. [B] Juggler Irwin — electric animals obscure the juggling act

**Questionable slots:** Elekid, Flaaffy, Electabuzz, Ampharos, Electivire.

Irwin specifically introduces ball dexterity. His electric humanoid/sheep lines do not communicate juggling as clearly as Voltorb or a hand-based performer. Ponyta/Rapidash can be circus animals and Wigglytuff a singer, so I would retain those. This is a sharper class identity, not a requirement that every Juggler use spherical Pokémon.

**Current parties:**

- [IRWIN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4826) — Route 35; map: Route35 — Elekid 21, Flaaffy 21, Galarian Ponyta 21.
- [IRWIN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4865) — Route 35 (rematch); no direct literal map reference found — Electabuzz 43, Ampharos 43, Galarian Rapidash 43.
- [IRWIN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4875) — Route 35 (rematch); no direct literal map reference found — Wigglytuff 52, Electivire 55, Ampharos 54, Galarian Rapidash 56.
- [IRWIN4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4891) — Route 35 (rematch); no direct literal map reference found — Electivire 58, Ampharos 58, Wigglytuff 58, Galarian Rapidash 63.

**Suggested change:** Replace the Elekid → Electabuzz → Electivire line with Voltorb → Electrode at the existing levels (21/43/55/58). Optionally replace Flaaffy/Ampharos with Aipom/Ambipom or Mr. Mime, but one consistent ball partner is sufficient. IRWIN2–4 have no direct literal map load; confirm their intended rematch use before editing those tiers.

**Alternative species:** Voltorb, Electrode, Mr. Mime, Aipom, Ambipom.

**Character evidence:** [maps/Route35.asm:31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:31).

<a id="finding-10"></a>

### 10. [B] Juggler Fritz — team reads more like a Psychic/Tamer hybrid

**Questionable slots:** Gorotora, Noctowl.

A tiger and an owl do not explain a juggling act by themselves. Espeon is reasonably defensible as a telekinetic stage partner. His current dialogue is about seasickness, so it supplies no circus act to connect the animals.

**Current parties:**

- [FRITZ](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4836) — Fast Ship B1F; map: FastShipB1F — Gorotora 56, Noctowl 56, Espeon 58.

**Suggested change:** Gorotora Lv.56 → Electrode Lv.56; Noctowl Lv.56 → Mr. Rime Lv.56. Keep Espeon, and give Fritz a short line about balancing his act on a rocking ship.

**Alternative species:** Electrode, Mr. Mime, Mr. Rime, Ambipom.

**Character evidence:** [maps/FastShipB1F.asm:117](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:117).

<a id="finding-11"></a>

### 11. [B] Juggler Silas — Golduck is the weakest stage-act link

**Questionable slots:** Golduck.

Starmie can read as a spinning star prop and Chandelure as a theatrical fire act. Golduck adds a third Psychic-capable battler but no equally clear performance hook. Golduck is actually Water/Psychic here; the issue is character flavor, not typing.

**Current parties:**

- [SILAS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4938) — Route 25 (Nugget Bridge 2); map: Route25 — Starmie 52, Golduck 52, Chandelure 53.

**Suggested change:** Golduck Lv.52 → Mr. Mime Lv.52. Keep Starmie and Chandelure for a recognizable psychic/fire stage act.

**Alternative species:** Mr. Mime, Mr. Rime, Ambipom, Electrode.

**Character evidence:** [maps/Route25.asm:434](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:434).

<a id="finding-12"></a>

### 12. [B] Youngster Jimmy — slow occult king beside a runner

**Questionable slots:** Galarian Slowking.

Jimmy boasts that he runs like the wind. Raticate fits an energetic route kid; a slow, sinister Galarian Slowking points toward a Psychic or occult trainer instead. Youngsters are generalists, so this is a personality recommendation.

**Current parties:**

- [JIMMY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1298) — Route 3; map: Route3 — Raticate 51, Galarian Slowking 51.

**Suggested change:** Galarian Slowking Lv.51 → Dodrio Lv.51 emphasizes running; Fearow preserves a familiar early-route evolution.

**Alternative species:** Fearow, Furret, Dodrio.

**Character evidence:** [maps/Route3.asm:37](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:37).

<a id="finding-13"></a>

### 13. [B] Youngster Owen — team lacks ordinary route-kid identity

**Questionable slots:** Toxapex, Mamoswine.

A reef predator plus an enormous snow mammoth forms a particularly disconnected pair for a generic shorts-wearing route child. There is no marine, ice, fossil or travel story in his dialogue. Neither is forbidden; the pair just needs a concept.

**Current parties:**

- [OWEN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1308) — Route 11; map: Route11 — Toxapex 60, Mamoswine 60.

**Suggested change:** At Lv.60, Sandslash + Tauros makes a convincing experienced route kid. If retaining a rare signature, keep Mamoswine and replace only Toxapex with Raticate or Sandslash.

**Alternative species:** Raticate, Sandslash, Nidoking, Tauros.

**Character evidence:** [maps/Route11.asm:14](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:14).

<a id="finding-14"></a>

### 14. [B] Youngster Jason — Steelix clashes with grass-catching story

**Questionable slots:** Steelix.

Jason talks about shorts in the grass and catching more Pokémon there. Dodrio fits that image; a massive underground steel serpent is a less natural partner without a mining/trading explanation. This is not an objection to his high level.

**Current parties:**

- [JASON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1318) — Route 11; map: Route11 — Steelix 60, Dodrio 60.

**Suggested change:** Steelix Lv.60 → Tauros Lv.60 retains physical power while making the roster read as grassland Pokémon. Raticate is the more classic Youngster option.

**Alternative species:** Raticate, Persian, Tauros, Furret.

**Character evidence:** [maps/Route11.asm:25](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route11.asm:25).

<a id="finding-15"></a>

### 15. [C] Youngster Mikey — unusually specialized starter pair

**Questionable slots:** Drilbur, Golett.

Both picks evoke digging/excavation, and Golett adds an ancient constructed guardian. This can be a good personal theme, but his generic novice dialogue does not establish it. Neither appears in Route 30's current grass table. A child can own traveled or traded Pokémon, so this is optional.

**Current parties:**

- [MIKEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1225) — Route 30; map: Route30 — Drilbur 5, Golett 6.

**Suggested change:** Minimal change: Golett Lv.6 → Pidgey Lv.6, retaining Drilbur as his unusual favorite. Alternatively keep both and let Mikey say he helps with excavations or likes digging Pokémon.

**Alternative species:** Sentret, Pidgey, Rattata, Mareep.

**Character evidence:** [maps/Route30.asm:188](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:188); [data/wild/johto_grass.asm:1241](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/johto_grass.asm:1241).

<a id="finding-16"></a>

### 16. [C] Youngster Ian — Numel needs a personal hook

**Questionable slots:** Numel.

Spinarak suits a local child; Numel adds the same volcanic-camel flavor as Gordon without explanation. Ian does not claim it was caught locally, so this is substantially weaker than Gordon's case.

**Current parties:**

- [IAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1257) — Route 34; map: Route34 — Spinarak 16, Numel 18.

**Suggested change:** Numel Lv.18 → Drowzee Lv.18 gives the class-best student an interesting clever partner; Rattata or Nidoran♂ gives a more ordinary child team. Keep Numel if distinctive personal favorites are the goal.

**Alternative species:** Drowzee, Nidoran♂, Rattata.

**Character evidence:** [maps/Route34.asm:400](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:400).

<a id="finding-17"></a>

### 17. [C] Youngster Warren — very mature pair without a character hook

**Questionable slots:** Camerupt, Victreebel.

A volcanic camel and a carnivorous plant look more like a traveling specialist's collection than a nervous ordinary child. There is no strict class violation; Kanto-level opponents should still have strong evolved Pokémon.

**Current parties:**

- [WARREN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1288) — Route 3; map: Route3 — Camerupt 50, Victreebel 51.

**Suggested change:** Replace Camerupt Lv.50 with Fearow Lv.50 and retain Victreebel as his unusual favorite. I would not replace both merely to make him weaker or younger-looking.

**Alternative species:** Fearow, Raticate, Arbok, Furret.

**Character evidence:** [maps/Route3.asm:26](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm:26).

<a id="finding-18"></a>

### 18. [C] Scientist Ross — biology fits, radio engineering is less visible

**Questionable slots:** Croagunk, Ariados.

These are coherent venom/biology subjects. His actual story, though, is Silph research and a radio signal that drives Pokémon mad. A wholly biological poison pair does less to communicate that engineering role than an electronic/artificial partner would. Keep them if Ross is meant to be the biological researcher on the project.

**Current parties:**

- [ROSS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1138) — Team Rocket Base B3F; map: TeamRocketBaseB3F — Croagunk 36, Ariados 36.

**Suggested change:** Ariados Lv.36 → Porygon2 Lv.36 makes the research angle clearer while retaining Croagunk as a test subject. Magneton is an alternative, although Mitch and Jed already use that line.

**Alternative species:** Magneton, Porygon2, Electrode.

**Character evidence:** [maps/TeamRocketBaseB3F.asm:158](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:158).

<a id="finding-19"></a>

### 19. [C] Burglar Eddie — Nidorina is a weak theft partner

**Questionable slots:** Nidorina.

Murkrow has a natural scavenger/thief identity. Nidorina contributes poison but no obvious stealth, stealing or loot-finding angle. Poison alone is not a Burglar identity. It remains a plausible personal guard Pokémon.

**Current parties:**

- [EDDIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4680) — Goldenrod Underground Switch Room Entrances; map: GoldenrodUndergroundSwitchRoomEntrances — Nidorina 38, Murkrow 38.

**Suggested change:** Nidorina Lv.38 → Sneasel Lv.38 for stealth and stealing. Meowth/Persian supports the money/loot angle, but Duncan already uses Persian, so Sneasel gives more variety.

**Alternative species:** Sneasel, Meowth, Persian.

**Character evidence:** [maps/GoldenrodUndergroundSwitchRoomEntrances.asm:245](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUndergroundSwitchRoomEntrances.asm:245).

<a id="finding-20"></a>

### 20. [C] Lass Carrie — goblin versus cute-partner introduction

**Questionable slots:** Impidimp.

The Fairy typing is explicitly welcome in this gym. The only concern is Carrie's emphasis on cute looks: a malicious-looking goblin is a less immediate match than a cute mammal or fairy. Mischievously cute is a valid interpretation, so this is low priority.

**Current parties:**

- [CARRIE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1864) — Goldenrod Gym; map: GoldenrodGym — Impidimp 20.

**Suggested change:** Impidimp Lv.20 → Jigglypuff Lv.20 gives her both cute appeal and Normal/Fairy typing. Keeping Impidimp with a line about his mischievous face is equally reasonable.

**Alternative species:** Cleffa, Jigglypuff, Buneary.

**Character evidence:** [maps/GoldenrodGym.asm:110](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:110); [maps/GoldenrodGym.asm:372](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:372).

<a id="finding-21"></a>

### 21. [C] Lass Krise — Morgrem gives a darker tone than her cute presentation

**Questionable slots:** Morgrem.

Krise calls attention to being cute, but her strongest visual partner is a sinister goblin. Tangela is odd-looking yet harmless enough to keep. Lasses are generalists, and a cute girl liking a creepy Pokémon can be intentional characterization.

**Current parties:**

- [KRISE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1879) — National Park; map: NationalPark — Morgrem 23, Tangela 24.

**Suggested change:** Morgrem Lv.23 → Steenee Lv.23 gives her an outdoorsy, cute plant pair. Togetic or Snubbull is a more familiar alternative. Keep Morgrem if you want a deliberate contrast in her tastes.

**Alternative species:** Togetic, Snubbull, Steenee.

**Character evidence:** [maps/NationalPark.asm:283](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:283).

<a id="finding-22"></a>

### 22. [C] Teacher Hillary — haunted doll needs a subject/story

**Questionable slots:** Banette.

Wyrdeer works as a composed, intelligent partner. An abandoned haunted doll gives a darker mood than her schoolyard/exercise dialogue establishes. A ghost-story teacher could absolutely own it; the current story just does not say that.

**Current parties:**

- [HILLARY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3277) — Route 15; map: Route15 — Wyrdeer 61, Banette 61.

**Suggested change:** Banette Lv.61 → Mr. Mime Lv.61 for classroom demonstration and performance, or Hypno for a stern Psychic teacher. A line about teaching ghost folklore would also justify keeping Banette.

**Alternative species:** Mr. Mime, Hypno, Chansey.

**Character evidence:** [maps/Route15.asm:27](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route15.asm:27).

<a id="finding-23"></a>

### 23. [C] Teacher Shirley — haunted doll beside a protective caretaker

**Questionable slots:** Banette.

Blissey reinforces the protective teacher guarding students on a field trip. Banette is a darker outlier unless she teaches folklore or uses a puppet for lessons. This is a tone choice, not a claim that Teachers must use cute or Psychic Pokémon.

**Current parties:**

- [SHIRLEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3287) — Fast Ship B1F; map: FastShipB1F — Blissey 57, Banette 59.

**Suggested change:** Banette Lv.59 → Xatu Lv.59 links the field trip toward Violet/the Ruins to a mysterious observing partner. Mr. Mime gives a more immediately recognizable classroom performer.

**Alternative species:** Mr. Mime, Xatu, Wyrdeer.

**Character evidence:** [maps/FastShipB1F.asm:172](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:172).

<a id="finding-24"></a>

### 24. [C] Pokémaniac Ethan — ordinary Raticate weakens collector flavor

**Questionable slots:** Raticate.

Farigiraf is a strong unusual collector's Pokémon. Ordinary Raticate is much less distinctive. Ethan discusses radio DJs rather than rare Pokémon, so this is only a class-flavor suggestion; there is no textual contradiction.

**Current parties:**

- [ETHAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2925) — Fast Ship Cabins / NNW / NNE / NE; map: FastShipCabins_NNW_NNE_NE — Raticate 59, Farigiraf 59.

**Suggested change:** Raticate Lv.59 → Lickilicky Lv.59 keeps a Normal-type slot and strengthens the unusual-species collector image.

**Alternative species:** Lickilicky, Dudunsparce, Porygon2.

**Character evidence:** [maps/FastShipCabins_NNW_NNE_NE.asm:38](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_NNW_NNE_NE.asm:38).

<a id="finding-25"></a>

### 25. [C] Picnicker Tiffany — Alolan Raticate versus fluffy pink signature theme

**Questionable slots:** Alolan Raticate.

Clefairy is correctly present in every tier. Alolan Raticate is simply a visually jarring companion to her repeated fluffy, cuddly, dressed-up Clefairy story. A beloved pet rat is still defensible, so this is a low-priority aesthetic choice.

**Current parties:**

- [TIFFANY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5465) — Route 43; map: Route43 — Alolan Raticate 35, Clefairy 35.

**Suggested change:** Alolan Raticate Lv.35 → Jigglypuff Lv.35. Chansey fits the later TIFFANY1 roster, while Jumpluff connects to TIFFANY2. Keep Clefairy unevolved if preserving her exact named-partner dialogue.

**Alternative species:** Jigglypuff, Chansey, Jumpluff.

**Character evidence:** [data/phone/text/tiffany_caller.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/tiffany_caller.asm:1); [data/phone/text/tiffany_overworld.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/tiffany_overworld.asm:1).

<a id="finding-26"></a>

### 26. [C] Biker Charles — heroic armored knight is the weakest gang-flavor slot

**Questionable slots:** Armarouge.

Galarian Weezing and Magmar clearly convey exhaust and fire. Armarouge's polished knight design reads differently from the reckless highway gang. Fire typing and cannon-like arms still offer a reasonable connection, so this is a very optional swap.

**Current parties:**

- [CHARLES](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8521) — Route 17; map: Route17 — Galarian Weezing 60, Magmar 60, Armarouge 60.

**Suggested change:** Armarouge Lv.60 → Ceruledge Lv.60 preserves an armored Fire-type but gives the gang a more sinister look. Keeping Armarouge is also coherent as a heavy engine/cannon motif.

**Alternative species:** Ceruledge, Houndoom, Magmortar.

**Character evidence:** [maps/Route17.asm:19](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route17.asm:19).

<a id="finding-27"></a>

### 27. [D] Cosplayer Maya — legacy/rematch roster with no costume concept

**Questionable slots:** Pidgeot, Weavile, Lickilicky.

This is the least connected Cosplayer roster visually: a bird, a clawed predator and a large tongue Pokémon. No direct map trainer/loadtrainer reference was found, despite the party comment calling it a Route 3/4 rematch.

**Current parties:**

- [COSPLAYER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6882) — Route 3, Route 4 (rematch); no direct literal map reference found — Pidgeot 69, Weavile 69, Lickilicky 70.

**Suggested change:** If reactivated, use Mr. Rime Lv.69 + Mimikyu Lv.69 + Ditto Lv.70, or define a specific costume reference that justifies the existing team. Resolve its encounter/rematch hookup first.

**Alternative species:** Mr. Rime, Mimikyu, Ditto, Smeargle.

<a id="finding-28"></a>

### 28. [D] Legacy male Executive 1 — Tinkatuff softens the criminal theme

**Questionable slots:** Tinkatuff.

The party is explicitly marked unplaced. Tinkatuff's playful fairy-smith appearance is the least immediate Rocket-executive fit. Skarmory/Machoke can serve as armored muscle, and Gloom/Murkrow fit well.

**Current parties:**

- [EXECUTIVEM_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5126) — Not placed on any map; no direct literal map reference found — Skarmory 31, Murkrow 31, Machoke 32, Gloom 32, Tinkatuff 33.

**Suggested change:** If reused, Tinkatuff Lv.33 → Pawniard Lv.33 gives the executive an armored enforcer without duplicating Murkrow.

**Alternative species:** Pawniard, Sneasel, Alolan Grimer.

<a id="finding-29"></a>

### 29. [D] Legacy male Executive 2 — Heracross lacks a criminal hook

**Questionable slots:** Heracross.

The party is explicitly marked unplaced. Heracross is more naturally a forest/physical-training Pokémon. Gurdurr can plausibly be hired muscle; Murkrow and Glimmet already support a sinister gang team.

**Current parties:**

- [EXECUTIVEM_2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5145) — Not placed on any map; no direct literal map reference found — Heracross 31, Gurdurr 31, Murkrow 31, Glimmet 32.

**Suggested change:** If reused, Heracross Lv.31 → Croagunk Lv.31. Retain Gurdurr if this executive directs physical labor or demolition.

**Alternative species:** Croagunk, Sneasel, Alolan Grimer.

<a id="finding-30"></a>

### 30. [D] Legacy male Executive 3 — Farfetch'd is a comic pastoral outlier

**Questionable slots:** Farfetch'd.

The party is explicitly marked unplaced. Ordinary Farfetch'd is a less natural criminal enforcer than the rest of this Dark/Poison-heavy lineup. A deliberately comic executive could make it work.

**Current parties:**

- [EXECUTIVEM_3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5161) — Not placed on any map; no direct literal map reference found — Murkrow 29, Scolipede 29, Farfetch'd 30, Sneasel 30, Clodsire 31.

**Suggested change:** If reused, Farfetch'd Lv.30 → Golbat Lv.30 or Alolan Persian Lv.30.

**Alternative species:** Golbat, Arbok, Alolan Persian.

<a id="finding-31"></a>

### 31. [D] Legacy female Executive 1 — several unexplained elegant/psychic choices

**Questionable slots:** Alolan Ninetales, Noctowl, Mr. Mime.

The party is explicitly marked unplaced. Alolan Ninetales, Noctowl and Mr. Mime have no stated criminal, disguise or occult role to explain them. They could fit a named ice/illusion executive; the generic unused entry does not establish that concept. Golurk and Alolan Raticate already fit intimidation/underworld flavor.

**Current parties:**

- [EXECUTIVEF_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5819) — Not placed on any map; no direct literal map reference found — Golurk 32, Alolan Raticate 32, Alolan Ninetales 33, Noctowl 33, Mr. Mime 33.

**Suggested change:** If reused as a generic Rocket executive, Alolan Ninetales Lv.33 → Houndoom; Noctowl Lv.33 → Murkrow; Mr. Mime Lv.33 → Hypno. Keep the original team instead if the character is rewritten as an illusion/disguise specialist.

**Alternative species:** Houndoom, Murkrow, Hypno.

## Dialogue-only consistency notes

**Joey:** his Rattata/Raticate identity remains intact, and Fearow, Nidoking and Snorlax are credible Youngster-team expansions. I would keep the Pokémon. His map dialogue was adjusted to allow adding friends, but the phone still says he chose his “one-and-only.” Reword that phone passage around his original partner rather than delete the extra teammates. See [data/phone/text/joey_caller.asm:33](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/joey_caller.asm:33) and [maps/Route30.asm:212](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:212).

**Bug Catcher Benny:** Trapinch is genuinely Bug/Ground in this game, so it fits his class and Azalea Gym. However, his speech promotes Bugs evolving young, while Trapinch is a slow-evolving example; both of his actual Pokémon are unevolved in this battle. I would keep Trapinch for variety and rewrite the line about how some Bugs grow slowly. If illustrating fast evolution is the goal, use Beedrill Lv.12 or Butterfree Lv.12 in its slot, retaining Pineco Lv.15. See [maps/AzaleaGym.asm:249](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm:249) and [data/trainers/parties.asm:3376](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3376).

## Apparent mismatches I would keep

| Trainer(s) / Pokémon | Why the current choice works |
|---|---|
| Whitney, Bridget and Victoria / Clefairy, Snubbull, Marill and Togetic | Goldenrod's guide explicitly describes Normal trainers **and a few fairies**. Fairy typing is intentional, not an accidental specialist violation. Victoria's Hoothoot also retains Normal typing. |
| Battle Girl Aya / Electivire | Electivire is **Electric/Fighting** in this source. All four Battle Girl parties meet their Fighting theme. |
| Bug Catchers Don and Benny / Trapinch | Trapinch is **Bug/Ground** here. Flygon/Vibrava are Bug/Dragon. The design issue for Benny is his evolution speech, not the species' Bug identity. |
| Psychics Fidel, Jared and Rodney / Noctowl; Medium Rebecca / Golduck | Noctowl is **Psychic/Flying** and Golduck **Water/Psychic**. These are actual Psychic specialist choices. |
| Dragon trainers / Dunsparce, Dudunsparce, Ampharos, Charizard and Altaria | They are respectively Normal/Dragon, Normal/Dragon, Electric/Dragon, Fire/Dragon and Dragon/Fairy. All qualify by this hack's actual types. |
| Cooltrainer Cody / Seadra and Aerodactyl | Cody explicitly says he has not been allowed to use Dragon types. His entire non-Dragon roster is intentional, and Aerodactyl retains a dragon-like ancient-beast silhouette. Giving him a Dragon would contradict that story. |
| Cooltrainer Cara / Gyarados and three Seadra | She also says she is waiting for permission to use Dragons. Water/Flying Gyarados and Water Seadra foreshadow a future dragon trainer without breaking that rule. |
| Brock / Steelix | It is Steel/Ground, so technically off the Rock type. It still fits geology, a stone/metal serpent and the evolved Onix identity. I would keep it. If you specifically want every slot to bear Rock typing, use Aggron, Bastiodon or Rhyperior at Lv.48. |
| Agatha / Arbok and Crobat | Poisonous snakes and bats suit her sinister original-team identity. She need not be treated as a strict six-Ghost specialist. If choosing that design, replace them with Banette/Dusknoir, but I would preserve her character roster. |
| Lorelei / Slowbro | It is Water/Psychic, but fits her established cold-water/sea-team identity alongside Dewgong, Cloyster and Lapras. A strict Ice-only version could use Jynx or Glaceon at Lv.86. Mesmeria is already Ice/Psychic here. |
| Ariana / Milotic and Octillery; Archer / Cloyster | Beauty, seduction, artillery and armored intimidation are reasonable executive character hooks. Milotic is Water/Fairy and Octillery Water/Fire, but Rocket leaders do not require uniform Dark/Poison typing. |
| Petrel / Ditto and Porygon line | An impersonator using transformation and artificial Pokémon has a clear concept. Do not remove Ditto simply because it is Normal. |
| Sailor Jeff / Hitmonchan; Hikers / Fighting Pokémon | Seafaring brawlers and physically rugged mountain trainers support Fighting partners. These are broader occupational themes, not strict Water/Rock mandates. |
| Hikers Anthony and others / Dunsparce or Dudunsparce | Burrowing cave Pokémon fit the terrain, even with this hack's Dragon secondary type. |
| Boarder Noel / Seel | Seel is pure Water, but is a cold-climate seal that evolves into an Ice type. It fits snow/ice flavor well. |
| Aroma Ladies / Tangela and Alolan Exeggutor | Vine foliage and a tropical tree fit gardening and plant collecting. They do not need to be floral Fairy types. |
| Sage Edmond / Hisuian Voltorb | This is Electric/Grass, so it belongs in Sprout Tower's plant theme. Ralts/Natu also fit meditation and spirituality for the other Sages. |
| Wise Trio / mixed elemental teams | Fire, electric and water partners evoke the tower/beast story, while Xatu, Noctowl and Slowking reinforce spiritual wisdom. A Sage is not automatically a Ghost specialist. |
| School Girls Heidi, Edna, Hope, Sharon and Debra / fossils, Ghosts, Porygon-Z, Smeargle and sea Pokémon | Their actual dialogue establishes fossil club, spooky stories, programming/luck, art club and marine study respectively. These are coherent personal subjects, not generic schoolchild mismatches. |
| Pokéfan Alex / Nidoking, Slowking and Kingambit | All three support his explicit regal/king theme. |
| Pokéfan Carter / Blastoise, Charizard and Venusaur | Fully evolved Kanto starters preserve the collector's three-starter identity, even though he names their basic forms in conversation. |
| Pokémaniac Issac / Furret | His specific hook is a freshly groomed Pokémon. Furret fits haircuts and companionship; rare-species policing would miss that context. |
| Juggler Horton / Electric animals | Vermilion Gym explicitly supplies the Electric specialist context. Electivire, Ampharos, Gorotora and Lanturn all meet it. Electrode could sharpen his juggling identity, but this is lower priority than the Jugglers listed above. |
| Jugglers Marco and Leon / Espeon, Clefable, Xatu, Galarian Rapidash and Wigglytuff | Magic, telekinetic tricks, circus animals and singing can form a coherent broader stage act. Leon's Rapidash is Fairy/Fire here; it does not need Psychic typing for this class. |
| Cosplayers Daisy and Pearl / Ditto, Mimikyu and Clefable | Daisy explicitly uses Ditto to achieve costume looks; Mimikyu is a costume creature. Pearl explicitly calls Clefable her dream cosplay partner. |
| Tamers / Tauros forms, Tyranitar, Snorlax, Dragonite, Persian, Kleavor and other beasts | Their actual stories emphasize unruly, fierce, big or ancient beasts. This supports varied creature types rather than one elemental type. |
| Officers / Growlithe/Arcanine, Noctowl, Granbull and Lucario | Patrol dogs, a night watcher and a disciplined fighter/detector form a coherent policing theme. |
| Silver, Crystal, Cal, Red, Blue and Green / mixed teams | These are individual generalists/collectors/rivals. Their source establishes no single-type mandate. Crystal changing a partner between stages is a continuity choice rather than automatic thematic failure. |

Typing evidence comes from the current [data/pokemon/base_stats.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats.asm) includes, rather than official-series memory. Goldenrod's explicit mixed-theme text: [maps/GoldenrodGym.asm:372](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:372). Cody/Cara's permissions: [maps/BlackthornGym2F.asm:60](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym2F.asm:60), [maps/DragonsDenB1F.asm:98](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:98).

## Battle Tower: possible mismatches come from the shared generator

The Tower has **70 trainer identities**, but they do not own 70 authored teams. The loader selects a trainer identity and then independently selects three Pokémon from the selected room's shared pool. There are **10 pools of 32 builds**, plus a reserved Mew for the seventh opponent in the Lv.100 room. Consequently a Bird Keeper can receive grounded Pokémon, a Bug Catcher non-Bugs, and a Fisher non-aquatic Pokémon. These are possible class-theme mismatches, not fixed rosters I can truthfully assign to those names.

Sources: [data/battle_tower/classes.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/battle_tower/classes.asm:1), [engine/events/battle_tower/load_trainer.asm:51](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/battle_tower/load_trainer.asm:51), [engine/events/battle_tower/load_trainer.asm:91](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/battle_tower/load_trainer.asm:91), [constants/battle_tower_constants.asm:4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/constants/battle_tower_constants.asm:4).

| Most affected Tower class | Trainer identities | Potential off-theme draws | If you want themed Tower teams |
|---|---|---|---|
| Fisher | Hanson, Hughes | Jolteon or Espeon | Use aquatic/fishable lines such as Kingdra, Octillery, Lanturn and Milotic. |
| Bird Keeper | Yates, Sells | Jolteon or Espeon | Use actual birds such as Skarmory, Talonflame, Noctowl, Honchkrow and Staraptor. |
| Bug Catcher | Smith, Tajiri | Jolteon or Espeon | Use Bugs such as Galvantula, Scizor, Heracross and the locally retyped Flygon line. |
| Swimmer M | Kaufman, Raine | Jolteon or Espeon | Use Water/aquatic partners such as Lanturn, Kingdra, Starmie and Milotic. |
| Swimmer F | Javier, Meyer, Dykstra | Jolteon or Espeon | Use Water/aquatic partners such as Lanturn, Kingdra, Starmie and Milotic. |
| Skier | Lancaster, Van Dyke | Jolteon or Espeon | Use Ice/cold-climate partners such as Jynx, Glaceon, Mamoswine and Walrein. |
| Boarder | Crawford, Rockwell | Jolteon or Espeon | Use Ice/cold-climate partners such as Weavile, Abomasnow, Cetitan and Walrein. |
| Firebreather | Hill, Wong | Jolteon or Espeon | Use Fire partners such as Houndoom, Chandelure, Magmortar and Arcanine. |
| Blackbelt | Yufune, Nguyen | Jolteon or Espeon | Use Fighting partners such as Hitmonchan, Machamp, Heracross and Lucario. |
| Psychic | Santiago, Easton | Jolteon | Use Psychic partners such as Espeon, Alakazam, Starmie and Noctowl. |
| Kimono Girl | Saito, Arita | any non-Eeveelution | Use Eeveelutions, ideally give each named dancer a signature evolution. |
| Guitarist | Masuda, Adams | generic non-musical, non-electric beasts | Use electric amplification or audible-performance partners; Jolteon/Electivire plus Wigglytuff is defensible. |
| Hiker | Alexander | unexplained sea/ornamental partners | Use rock, ground, cave or rugged Fighting partners. |
| Sailor | Newman | unexplained non-aquatic/non-brawler partners | Mix aquatic partners and Fighting brawlers. |
| Juggler | Fairfield | generic animals with no act | Give the pool ball props, mimics, telekinetic tricks or explicit stage performers. |

**Recommendation:** keep the Tower's competitive mixed-team format unless you specifically want occupational flavor there. If changing it, solve this at the generator/class-pool level instead of editing a supposed personal roster. The other Tower classes are broad enough that a mixed team is not inherently inconsistent. The coverage file lists every identity, including those broader classes.

## Practical editing order

1. Resolve Jose and Beth's phone/personality conflicts; choose whether to change a roster, dialogue, or both.
2. Replace Bailey's Corsola and Gordon's Numel, or rewrite the specific mountain/local-catching claims.
3. Give Cosplayers a named costume concept and Jugglers an identifiable act. A short dialogue change can justify some existing picks more effectively than homogenizing every roster.
4. Make the route-kid changes you agree with; retain unusual favorites where they add personality.
5. Leave C-tier and legacy candidates until the character concept is decided. Confirm rematch hookups for entries without direct map references.

Keep existing levels and party sizes as a starting point. A replacement species still needs its moves, held item and ability slot reviewed: the old set should not be blindly retained. Smeargle particularly needs a custom set, and Farfetch'd may need help to hold a high-level slot. I have not changed data or claimed these replacement battles were playtested.

## Coverage and limits

The companion checklist contains every fixed party, its full species/level roster, source line, actual direct map references, finding IDs and a class-level review rationale. It includes source entries whose comments say they are unplaced, as well as all three starter branches for Silver and Crystal. Shared class pointers (for example leader-rematch classes and Crystal variants) are not double-counted as new authored parties.

Absence of a literal map reference is not proof an entry is unreachable: scripts can choose a party dynamically or refer to it indirectly. Conversely, a location comment is not proof of current placement. For example, several former Route 25 entries remain in party data, while the actual present bridge uses Noelle, Dustin, Nadia, Paige and Silas. Viridian Forest Bug Catchers also retain Route 2 comments; the checklist shows their actual maps.

This review concerns authored trainer themes. It does not treat level, evolution legality, combat strength, or repeated species as thematic errors by themselves. It is based on source data, not a playthrough or an assertion that the existing compiled ROM exactly matches it.
