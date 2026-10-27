# Roster balance review — October 27, 2026

Reviewed all **231 final-stage/single-stage Pokémon/forms and 664 legal ability
combinations** from the completed no-item audit against their current stats,
available moves, selected builds and ability alternatives. Starter families and
unevolved stages remain outside this roster, matching the original request.

The 148,562 battles describe the pinned October 24 build. **No new battles or
post-buff win rates are claimed.** Recommendations below are design judgments
and proposed experiments, not measured effects of those changes. Pokémon do not
all need 50% wins, and legendary/late-game strength is intentional.

## Applied changes

| Pokémon | Change | New stat(s) | New BST |
|---|---|---|---:|
| Zangoose | Attack +10; Speed +10 | Attack 125; Speed 110 | 490 |
| Ariados | Speed +20 | Speed 100 | 485 |
| Ludicolo | Attack +20 | Attack 90 | 500 |
| Venomoth | Special Attack +15, confirmed by Luke | Special Attack 115 | 465 |

Regular and debug ROMs rebuilt successfully. Both compiled tables match all
498 species, 442 moves and dex weights, with no newer unbuilt assembly.
Balance-change metadata validates against source. Original-rule stat overrides
were not edited. See `verification.json`. This review stays off the website.

## Additional buffs to consider

| Pokémon | Old solo score | First experiment | Reason and limits |
|---|---:|---|---|
| Persian | 31.1% | Attack 90 → 100 | Modest damage increase preserves its fast, fragile identity. Compare Technician/Fake Out and special sets before judging the result. |
| Pinsir | 36.1% | Speed 85 → 95 | Retains 125 Attack and 65 HP while improving its physical attacker role. Do not also add more Attack or Tough Claws in the same pass. |
| Alolan Exeggutor | 30.9% | Special Defense 75 → 85, conditional | Retains 45 Speed and severe Ice weakness. Lower confidence: first check Rock Head/Wood Hammer and Harvest team sets. |

Secondary possibilities: **Hitmonchan Attack 105 → 115**, only after testing an
actual Iron Fist punching set; **Hypno Special Attack 73 → 85**, only if its
existing No Guard/Hypnosis/Wish/Nasty Plot options still struggle. Those are less
certain than Persian/Pinsir. Do not stack additional buffs on the four Pokémon
already changed before measuring their new performance.

## Nerfs and interactions to investigate

- **Bloodmoon Ursaluna, 76.7%:** If this exceeds its intended rare/endgame power,
  test removing **Counter** first. The selected Counter/Blood Moon/Earth Power/
  Moonblast set answers both damage categories unusually well. Preserve its
  special-attacker identity; do not simultaneously cut stats, coverage and
  Berserk. Its intended power level may justify leaving it alone.
- **Wobbuffet, 90.2%:** Highest investigation priority, not an immediate nerf.
  Moveset-aware Counter/Mirror Coat selection strongly favors it. Shadow Tag
  was not tested in a real switching game. If human/team play confirms excessive
  dominance, **HP 190 → 175** is a possible first experiment; retain its defining
  retaliation moves.
- **Kangaskhan, 69.1%:** Watch **Parental Bond + fixed damage**, rather than
  automatically lowering Attack. The source quarters ordinary second-hit damage
  while retaining fixed-damage commands. If this proves oppressive, adjust that
  interaction or move access; an Attack nerf would not address fixed damage.
  This review did not run a new independent native probe for that interaction.

No global nerf to Sturdy, Filter, Sharpness, RestTalk or weight-based moves is
justified by these scores. Fresh full HP favors some abilities. Mewtwo, Lugia,
Ho-Oh, the legendary birds/beasts, Jirachi and high-end dragons are allowed to be
stronger than ordinary early-game Pokémon.

## Retest these roles before changing more stats

- **Breloom:** Technician with **Spore / Bullet Seed / Mach Punch / Drain Punch**
  as one coherent legal set. The screen contained component moves, but the
  finalists did not establish this combination's ceiling. Already has 130 Attack.
- **Gallade:** Sharpness with Sacred Sword/Psycho Cut plus useful coverage or
  priority. The chosen Steadfast set lacked Fighting STAB.
- **Cloyster:** Shell Smash + Skill Link + Icicle Spear/Rock Blast together.
  Separately screened setup and multi-hit portfolios do not establish that
  combination's performance.
- **Ludicolo:** Old league results used 70 Attack and no guaranteed rain support.
  It now has 90 Attack and 90 Special Attack; compare physical/mixed and special
  rain sets.
- **Venomoth:** New 115 Special Attack with Quiver Dance/Tinted Lens may already
  be substantial. Compound Eyes/Sleep Powder is a different role; hold further buffs.
- **Blissey, Xatu, Smeargle, Ditto, Regenerator users and hazard/removal users:**
  Solo scores understate support, pivoting and revenge roles. Preserve weaknesses
  instead of making all of them duelists.
- **Marowak, Harvest/berry users and other item-dependent options:** The audit
  intentionally excluded items. Avoid stat buffs that become excessive with
  their existing items.
- **Moxie/Supreme Overlord and weather attackers:** Their intended conditions
  need continuing team battles and real weather support.

## Evidence and complete roster

- [Original findings](../2026-10-24-no-items/FINDINGS.md) and the original
  ability/moveset CSVs are retained unchanged.
- [Detailed review of all 231 Pokémon](full-roster-review.csv): current stats,
  legal abilities, old selected moves, per-ability validation scores and reasons.
- `roster-review.json`: coverage, current data hash and category counts.
- `verification.json`: applied changes, compiled checks and new ROM hashes.

Only the four requested buffs were applied. All other suggestions remain proposals.

<!-- roster-table -->

## All 231 roster decisions

Current stats: **HP / Attack / Defense / Speed / Special Attack / Special Defense**. Scores are historical pre-buff results.

| Pokémon | Old score | Current base stats | Review decision |
|---|---:|---|---|
| WOBBUFFET | 90.2% | 190 / 33 / 58 / 33 / 33 / 58 | Nerf watch; format check |
| MEWTWO | 82.2% | 106 / 110 / 90 / 130 / 154 / 90 | Hold intended exceptional strength |
| LUGIA | 77.6% | 106 / 90 / 130 / 110 / 90 / 154 | Hold intended exceptional strength |
| URSALUNABM | 76.7% | 113 / 70 / 120 / 52 / 135 / 65 | Conditional learnset nerf |
| ARCHALUDON | 76.1% | 90 / 105 / 130 / 85 / 125 / 65 | Hold intended high-end strength |
| JIRACHI | 75.0% | 100 / 100 / 100 / 100 / 100 / 100 | Hold intended exceptional strength |
| ZAPDOS | 75.0% | 90 / 90 / 85 / 100 / 125 / 90 | Hold intended exceptional strength |
| HO_OH | 73.7% | 106 / 130 / 90 / 90 / 110 / 154 | Hold intended exceptional strength |
| RAIKOU | 71.3% | 90 / 85 / 75 / 115 / 115 / 100 | Hold intended exceptional strength |
| BAXCALIBUR | 71.1% | 115 / 145 / 92 / 87 / 75 / 86 | Hold intended high-end strength |
| SUICUNE | 71.1% | 100 / 75 / 115 / 85 / 90 / 115 | Hold intended exceptional strength |
| EXCADRILL | 70.9% | 110 / 135 / 60 / 88 / 50 / 65 | Weather-role retest |
| DRAGONITE | 70.2% | 91 / 134 / 95 / 80 / 100 / 100 | Hold intended high-end strength |
| AGGRON | 69.3% | 80 / 110 / 180 / 50 / 60 / 60 | Hold successful defensive identity |
| DRAGAPULT | 69.1% | 88 / 120 / 75 / 142 / 100 / 75 | Hold intended high-end strength |
| KANGASKHAN | 69.1% | 105 / 95 / 80 / 90 / 40 / 80 | Interaction watch |
| BASTIODON | 68.7% | 75 / 27 / 168 / 30 / 77 / 138 | Hold successful defensive identity |
| CARRACOSTA | 68.0% | 70 / 117 / 123 / 50 / 80 / 60 | Weather-role retest |
| GOROTORA | 67.6% | 120 / 95 / 65 / 80 / 95 / 80 | Hold current baseline |
| MILOTIC | 67.4% | 95 / 60 / 79 / 81 / 100 / 125 | Hold current baseline |
| HAXORUS | 67.0% | 76 / 147 / 90 / 97 / 60 / 70 | Hold current baseline |
| URSALUNA | 67.0% | 130 / 140 / 105 / 50 / 45 / 80 | Hold current baseline |
| MIMIKYU | 66.5% | 55 / 100 / 80 / 96 / 50 / 105 | Hold current baseline |
| DEWGONG | 65.9% | 110 / 80 / 80 / 80 / 80 / 95 | Hold current baseline |
| GRIMMSNARL | 65.4% | 95 / 120 / 75 / 60 / 75 / 85 | Hold current baseline |
| MESMERIA | 65.4% | 75 / 50 / 45 / 105 / 135 / 105 | Hold current baseline |
| MEW | 65.4% | 100 / 100 / 100 / 100 / 100 / 100 | Hold intended exceptional strength |
| MOLTRES | 64.6% | 90 / 100 / 90 / 90 / 125 / 85 | Hold intended exceptional strength |
| DUSKNOIR | 64.1% | 60 / 100 / 135 / 45 / 65 / 135 | Hold current baseline |
| ENTEI | 64.1% | 115 / 115 / 85 / 100 / 90 / 75 | Hold intended exceptional strength |
| KLEAVOR | 63.7% | 70 / 135 / 95 / 85 / 45 / 70 | Hold current baseline |
| TOGEKISS | 63.7% | 85 / 50 / 95 / 80 / 120 / 115 | Hold current baseline |
| STEELIX | 63.5% | 75 / 105 / 200 / 30 / 45 / 65 | Hold successful defensive identity |
| MAGNEZONE | 63.3% | 70 / 70 / 115 / 60 / 130 / 90 | Hold current baseline |
| PORYGON_Z | 63.3% | 85 / 76 / 70 / 99 / 135 / 70 | Hold current baseline |
| RHYPERIOR | 62.4% | 115 / 140 / 130 / 40 / 55 / 55 | Hold successful defensive identity |
| ARCANINE_HISUIAN | 62.2% | 95 / 120 / 85 / 90 / 80 / 85 | Hold current baseline |
| HYDREIGON | 62.0% | 92 / 105 / 90 / 98 / 125 / 90 | Hold intended high-end strength |
| ARMAROUGE | 61.1% | 85 / 60 / 100 / 75 / 125 / 80 | Hold current baseline |
| GLISCOR | 61.1% | 75 / 95 / 125 / 95 / 45 / 75 | Hold current baseline |
| TAUROS_PALDEAN_FIRE | 61.1% | 75 / 115 / 110 / 100 / 40 / 80 | Hold current baseline |
| VOLCARONA | 60.9% | 85 / 60 / 65 / 100 / 135 / 105 | Hold current baseline |
| ARTICUNO | 60.0% | 90 / 75 / 100 / 95 / 95 / 125 | Hold intended exceptional strength |
| PIDGEOT | 60.0% | 83 / 60 / 70 / 101 / 115 / 70 | Hold current baseline |
| SALAMENCE | 59.3% | 95 / 135 / 80 / 100 / 110 / 80 | Hold intended high-end strength |
| GOLISOPOD | 59.1% | 75 / 125 / 140 / 40 / 60 / 90 | Hold current baseline |
| GRUMPIG | 59.1% | 80 / 45 / 75 / 80 / 100 / 110 | Hold current baseline |
| TYRANITAR | 59.1% | 100 / 134 / 110 / 61 / 95 / 100 | Hold intended high-end strength |
| SNORLAX | 58.9% | 160 / 110 / 65 / 30 / 65 / 110 | Hold current baseline |
| SUDOWOODO | 58.9% | 90 / 115 / 125 / 30 / 30 / 75 | Hold current baseline |
| GOLEM_ALOLAN | 58.7% | 80 / 120 / 130 / 45 / 55 / 65 | Hold current baseline |
| LANTURN | 58.7% | 125 / 58 / 70 / 67 / 96 / 76 | Weather-role retest |
| TAUROS | 58.7% | 75 / 100 / 95 / 110 / 70 / 70 | Hold current baseline |
| ARCANINE | 58.3% | 90 / 110 / 80 / 95 / 100 / 80 | Hold current baseline |
| KINGDRA | 58.3% | 75 / 95 / 95 / 85 / 95 / 95 | Weather-role retest |
| CORVIKNIGHT | 58.0% | 98 / 87 / 105 / 67 / 53 / 85 | Keep defensive/support role |
| GLIMMORA | 58.0% | 83 / 55 / 90 / 86 / 130 / 81 | Hold current baseline |
| ANNIHILAPE | 57.6% | 110 / 115 / 80 / 95 / 60 / 75 | Hold current baseline |
| DUDUNSPARCE | 57.6% | 125 / 110 / 85 / 55 / 85 / 80 | Hold current baseline |
| FURRET | 57.4% | 95 / 85 / 65 / 105 / 45 / 70 | Hold intended power band |
| GYARADOS | 57.4% | 95 / 125 / 79 / 81 / 60 / 100 | Team-sweeper retest |
| FORRETRESS | 57.2% | 75 / 90 / 140 / 40 / 60 / 60 | Keep defensive/support role |
| AURORUS | 57.0% | 123 / 77 / 72 / 58 / 99 / 92 | Hold current baseline |
| SKARMORY | 57.0% | 85 / 90 / 140 / 70 / 40 / 70 | Keep defensive/support role |
| ARMALDO | 56.7% | 75 / 125 / 100 / 50 / 70 / 80 | Weather-role retest |
| AERODACTYL | 56.5% | 80 / 105 / 65 / 130 / 60 / 75 | Hold current baseline |
| TAUROS_PALDEAN_WATER | 56.5% | 75 / 115 / 110 / 100 / 40 / 80 | Hold current baseline |
| STARAPTOR | 56.3% | 85 / 120 / 70 / 100 / 50 / 60 | Hold current baseline |
| NINETALES_ALOLAN | 56.1% | 73 / 67 / 75 / 109 / 81 / 100 | Hold current baseline |
| SUNFLORA | 55.7% | 85 / 55 / 85 / 30 / 125 / 95 | Hold current baseline |
| WYRDEER | 55.7% | 103 / 105 / 72 / 95 / 75 / 75 | Hold current baseline |
| GOLEM | 55.4% | 80 / 120 / 130 / 45 / 55 / 65 | Weather-role retest |
| PARASECT | 55.4% | 85 / 115 / 100 / 30 / 55 / 90 | Hold current baseline |
| ARCHEOPS | 55.0% | 75 / 135 / 70 / 105 / 100 / 65 | Hold current baseline |
| DONPHAN | 55.0% | 90 / 120 / 120 / 50 / 60 / 60 | Hold current baseline |
| ELECTIVIRE | 54.8% | 75 / 123 / 67 / 95 / 95 / 85 | Hold current baseline |
| TINKATON | 54.6% | 85 / 75 / 77 / 94 / 70 / 105 | Hold current baseline |
| FROSLASS | 54.3% | 70 / 70 / 70 / 110 / 110 / 70 | Hold current baseline |
| AMPHAROS | 54.1% | 90 / 75 / 85 / 55 / 115 / 90 | Hold current baseline |
| SNEASLER | 54.1% | 80 / 130 / 60 / 120 / 40 / 80 | Hold current baseline |
| CETITAN | 53.9% | 170 / 113 / 65 / 73 / 45 / 55 | Weather-role retest |
| VAPOREON | 53.9% | 130 / 65 / 60 / 65 / 110 / 95 | Weather-role retest |
| GOLURK | 53.7% | 94 / 124 / 90 / 87 / 55 / 55 | Hold current baseline |
| MILTANK | 53.7% | 95 / 80 / 105 / 100 / 40 / 70 | Hold current baseline |
| VIKAVOLT | 53.7% | 77 / 70 / 90 / 43 / 145 / 75 | Hold current baseline |
| MISMAGIUS | 53.3% | 60 / 60 / 60 / 105 / 105 / 105 | Hold current baseline |
| CHANDELURE | 52.8% | 60 / 55 / 90 / 80 / 145 / 90 | Hold current baseline |
| CENTISKORCH | 52.6% | 100 / 115 / 90 / 65 / 65 / 90 | Hold current baseline |
| FLAPPLE | 52.4% | 70 / 135 / 80 / 100 / 95 / 60 | Hold current baseline |
| LOPUNNY | 52.4% | 65 / 106 / 84 / 105 / 44 / 96 | Hold current baseline |
| JOLTEON | 52.2% | 65 / 65 / 60 / 130 / 110 / 95 | Hold current baseline |
| SCIZOR | 52.2% | 70 / 130 / 100 / 65 / 55 / 80 | Hold current baseline |
| CERULEDGE | 52.0% | 75 / 125 / 80 / 85 / 60 / 100 | Hold current baseline |
| HITMONLEE | 52.0% | 65 / 120 / 63 / 92 / 35 / 110 | Hold current baseline |
| NOIVERN | 52.0% | 85 / 60 / 80 / 123 / 107 / 80 | Hold current baseline |
| SLOWBRO | 52.0% | 95 / 75 / 110 / 30 / 100 / 80 | Team-role retest |
| NIDOQUEEN | 51.5% | 90 / 92 / 87 / 81 / 75 / 85 | Hold current baseline |
| CAMERUPT | 51.3% | 80 / 100 / 70 / 40 / 105 / 75 | Hold current baseline |
| FLYGON | 51.3% | 80 / 115 / 85 / 100 / 95 / 85 | Hold current baseline |
| GOROCHU | 51.3% | 70 / 100 / 65 / 115 / 100 / 100 | Hold current baseline |
| GENGAR | 51.1% | 60 / 65 / 60 / 110 / 130 / 75 | Hold current baseline |
| NIDOKING | 51.1% | 81 / 102 / 77 / 85 / 90 / 75 | Hold current baseline |
| MAMOSWINE | 50.9% | 110 / 130 / 80 / 80 / 70 / 60 | Hold current baseline |
| SCRAFTY | 50.7% | 77 / 90 / 115 / 58 / 45 / 115 | Team-sweeper retest |
| GLACEON | 50.4% | 65 / 60 / 110 / 95 / 130 / 65 | Weather-role retest |
| KINGLER | 50.2% | 65 / 130 / 115 / 75 / 50 / 55 | Hold current baseline |
| ABOMASNOW | 50.0% | 90 / 92 / 75 / 60 / 92 / 85 | Hold current baseline |
| PALAFIN | 50.0% | 90 / 120 / 100 / 90 / 85 / 75 | Weather-role retest |
| DODRIO | 49.8% | 70 / 110 / 70 / 110 / 60 / 60 | Hold current baseline |
| MAWILE | 49.8% | 60 / 60 / 95 / 50 / 55 / 85 | Keep damage multiplier in view |
| WALREIN | 49.6% | 110 / 80 / 90 / 65 / 95 / 90 | Weather-role retest |
| WEAVILE | 49.6% | 70 / 120 / 65 / 125 / 45 / 85 | Ability/set retest |
| CLODSIRE | 49.3% | 130 / 75 / 60 / 20 / 65 / 100 | Hold current baseline |
| GARDEVOIR | 49.3% | 68 / 65 / 65 / 80 / 125 / 115 | Hold current baseline |
| KINGAMBIT | 49.3% | 100 / 135 / 120 / 50 / 60 / 85 | Team-sweeper retest |
| MANTINE | 49.3% | 85 / 40 / 70 / 70 / 90 / 140 | Weather-role retest |
| STARMIE | 49.3% | 60 / 75 / 85 / 115 / 100 / 85 | Team-role retest |
| SYLVEON | 49.3% | 95 / 65 / 65 / 60 / 110 / 130 | Hold current baseline |
| CROBAT | 49.1% | 85 / 90 / 80 / 130 / 70 / 80 | Hold current baseline |
| CURSOLA | 49.1% | 60 / 60 / 85 / 30 / 145 / 130 | Team-role retest |
| LICKILICKY | 48.9% | 110 / 100 / 95 / 50 / 80 / 95 | Hold current baseline |
| TYRANTRUM | 48.9% | 82 / 121 / 119 / 71 / 69 / 59 | Hold current baseline |
| HYDRAPPLE | 48.7% | 106 / 70 / 90 / 66 / 130 / 80 | Team-role retest |
| RAPIDASH | 48.5% | 65 / 105 / 70 / 115 / 80 / 80 | Hold current baseline |
| CELEBI | 48.0% | 100 / 100 / 100 / 100 / 100 / 100 | Hold intended exceptional strength |
| GALVANTULA | 48.0% | 70 / 77 / 60 / 108 / 107 / 60 | Hold current baseline |
| ELECTRODE | 47.8% | 60 / 50 / 70 / 150 / 90 / 80 | Hold current baseline |
| MR__RIME | 47.8% | 80 / 65 / 75 / 100 / 110 / 100 | Hold current baseline |
| SANDSLASH | 47.8% | 85 / 100 / 110 / 65 / 45 / 65 | Weather-role retest |
| MUK_ALOLAN | 47.6% | 105 / 105 / 75 / 50 / 65 / 100 | Hold current baseline |
| APPLETUN | 47.2% | 110 / 85 / 110 / 35 / 100 / 100 | Hold current baseline |
| KROOKODILE | 47.2% | 95 / 117 / 80 / 92 / 65 / 70 | Hold current baseline |
| POLITOED | 47.2% | 90 / 75 / 75 / 70 / 90 / 100 | Hold current baseline |
| ALTARIA | 47.0% | 75 / 90 / 90 / 80 / 90 / 105 | Hold current baseline |
| FLAREON | 47.0% | 110 / 130 / 60 / 95 / 65 / 65 | Hold current baseline |
| RAMPARDOS | 47.0% | 97 / 155 / 90 / 33 / 35 / 90 | Preserve slow-powerful identity |
| AZUMARILL | 46.7% | 110 / 50 / 80 / 50 / 80 / 80 | Keep damage multiplier in view |
| HONCHKROW | 46.7% | 100 / 125 / 52 / 71 / 115 / 52 | Hold current baseline |
| SLOWKING_GALARIAN | 46.5% | 95 / 65 / 80 / 30 / 110 / 110 | Team-role retest |
| MAROWAK_ALOLAN | 46.3% | 60 / 80 / 110 / 45 / 50 / 80 | Item/role retest |
| DRIFBLIM | 46.1% | 150 / 80 / 54 / 80 / 90 / 54 | Hold current baseline |
| PERSIAN_ALOLAN | 46.1% | 65 / 70 / 60 / 115 / 90 / 65 | Hold current baseline |
| FEAROW | 45.9% | 65 / 110 / 65 / 115 / 61 / 61 | Hold intended power band |
| LUCARIO | 45.9% | 70 / 110 / 70 / 90 / 115 / 70 | Ability/set retest |
| RAPIDASH_GALARIAN | 45.9% | 65 / 105 / 70 / 115 / 80 / 80 | Hold current baseline |
| TOXAPEX | 45.9% | 50 / 63 / 152 / 35 / 53 / 142 | Team-role retest |
| OVERQWIL | 45.7% | 85 / 115 / 95 / 85 / 65 / 65 | Weather-role retest |
| HOUNDOOM | 45.4% | 75 / 100 / 50 / 95 / 110 / 80 | Hold current baseline |
| LEAFEON | 45.4% | 65 / 110 / 130 / 95 / 60 / 65 | Weather-role retest |
| OMASTAR | 45.4% | 70 / 60 / 125 / 55 / 115 / 70 | Weather-role retest |
| BUTTERFREE | 44.8% | 60 / 45 / 45 / 90 / 110 / 100 | Hold intended power band |
| CONKELDURR | 44.8% | 105 / 140 / 95 / 45 / 55 / 65 | Hold current baseline |
| MAGMORTAR | 44.8% | 75 / 95 / 67 / 83 / 125 / 95 | Hold current baseline |
| MAGCARGO | 44.6% | 75 / 50 / 150 / 30 / 110 / 100 | Hold current baseline |
| NINETALES | 44.6% | 73 / 67 / 75 / 109 / 81 / 100 | Hold current baseline |
| BELLOSSOM | 44.3% | 75 / 80 / 95 / 60 / 100 / 100 | Weather-role retest |
| HITMONTOP | 44.3% | 70 / 95 / 95 / 80 / 35 / 110 | Support/set retest |
| ESPEON | 44.1% | 65 / 65 / 60 / 110 / 130 / 95 | Support/set retest |
| YANMEGA | 43.9% | 86 / 76 / 86 / 95 / 116 / 76 | Hold current baseline |
| SIRFETCH_D | 43.7% | 62 / 135 / 95 / 65 / 60 / 90 | Hold current baseline |
| PERRSERKER | 43.5% | 85 / 110 / 100 / 50 / 50 / 80 | Hold current baseline |
| OCTILLERY | 43.3% | 85 / 110 / 95 / 45 / 110 / 85 | Hold current baseline |
| SLOWKING | 43.3% | 95 / 75 / 80 / 30 / 100 / 110 | Team-role retest |
| MACHAMP | 43.0% | 90 / 130 / 80 / 55 / 65 / 85 | Ability/set retest |
| NOCTOWL | 43.0% | 100 / 40 / 60 / 60 / 106 / 116 | Hold intended power band |
| TALONFLAME | 42.8% | 78 / 81 / 71 / 126 / 74 / 69 | Hold current baseline |
| SEAKING | 42.6% | 85 / 75 / 80 / 78 / 102 / 75 | Weather-role retest |
| SLOWBRO_GALARIAN | 42.6% | 95 / 100 / 95 / 30 / 100 / 70 | Hold current baseline |
| HERACROSS | 42.4% | 80 / 125 / 75 / 85 / 40 / 95 | Hold current baseline |
| TSAREENA | 42.4% | 72 / 120 / 98 / 72 / 50 / 98 | Hold current baseline |
| FARIGIRAF | 42.2% | 120 / 90 / 70 / 85 / 110 / 70 | Hold current baseline |
| TORKOAL | 42.2% | 70 / 85 / 140 / 20 / 85 / 70 | Hold current baseline |
| LAPRAS | 42.0% | 130 / 85 / 80 / 60 / 85 / 95 | Weather-role retest |
| RAICHU_ALOLAN | 42.0% | 60 / 85 / 50 / 110 / 105 / 85 | Hold current baseline |
| CRADILY | 41.7% | 86 / 81 / 97 / 43 / 86 / 107 | Hold current baseline |
| RATICATE | 41.7% | 65 / 97 / 70 / 113 / 45 / 70 | Hold intended power band |
| ARBOK | 41.5% | 70 / 110 / 75 / 80 / 55 / 80 | Hold current baseline |
| JUMPLUFF | 41.5% | 75 / 55 / 70 / 110 / 85 / 95 | Weather-role retest |
| LEDIAN | 41.3% | 80 / 105 / 70 / 95 / 35 / 110 | Hold intended power band |
| SEVIPER | 41.3% | 75 / 115 / 60 / 90 / 90 / 60 | Hold current baseline |
| TENTACRUEL | 41.3% | 80 / 70 / 65 / 100 / 80 / 120 | Support/defensive retest |
| UMBREON | 41.3% | 95 / 65 / 110 / 65 / 60 / 130 | Support/set retest |
| SANDSLASH_ALOLAN | 40.9% | 85 / 100 / 120 / 65 / 25 / 70 | Weather-role retest |
| KABUTOPS | 40.7% | 60 / 115 / 105 / 80 / 65 / 70 | Weather-role retest |
| UNOWN | 40.7% | 84 / 58 / 69 / 85 / 108 / 69 | Hold custom niche |
| ALAKAZAM | 40.4% | 55 / 50 / 45 / 120 / 135 / 95 | Hold current baseline |
| GOLDUCK | 40.4% | 80 / 82 / 78 / 85 / 95 / 80 | Weather/set retest |
| SCOLIPEDE | 40.4% | 60 / 110 / 89 / 112 / 55 / 69 | Ability/set retest |
| QUAGSIRE | 40.0% | 95 / 95 / 95 / 35 / 65 / 65 | Hold current baseline |
| GRANBULL | 39.8% | 90 / 120 / 85 / 45 / 60 / 80 | Preserve slow-powerful identity |
| WIGGLYTUFF | 39.8% | 115 / 60 / 75 / 55 / 88 / 80 | Retest before any buff |
| VILEPLUME | 39.3% | 75 / 80 / 85 / 50 / 110 / 90 | Weather-role retest |
| GALLADE | 39.1% | 68 / 125 / 65 / 80 / 65 / 115 | Targeted set retest |
| POLIWRATH | 39.1% | 90 / 95 / 95 / 70 / 70 / 90 | Ability/set retest |
| DELIBIRD | 38.9% | 60 / 85 / 50 / 110 / 110 / 50 | Hold intended power band |
| BEEDRILL | 38.7% | 65 / 115 / 40 / 95 / 40 / 95 | Hold intended power band |
| CORSOLA | 38.3% | 65 / 45 / 115 / 35 / 90 / 115 | Team-role retest |
| EXEGGUTOR | 38.0% | 95 / 95 / 85 / 55 / 125 / 75 | Item/weather-role retest |
| WEEZING_GALARIAN | 38.0% | 65 / 80 / 120 / 60 / 95 / 70 | Support/defensive retest |
| HITMONCHAN | 37.8% | 75 / 105 / 79 / 81 / 35 / 110 | Retest; secondary buff |
| ELECTRODE_HISUIAN | 36.7% | 60 / 50 / 70 / 150 / 90 / 80 | Retest before any buff |
| RATICATE_ALOLAN | 36.7% | 80 / 88 / 80 / 82 / 40 / 90 | Hold intended power band |
| TREVENANT | 36.7% | 90 / 110 / 95 / 56 / 65 / 84 | Item/weather-role retest |
| CLOYSTER | 36.5% | 50 / 95 / 180 / 70 / 85 / 45 | Targeted set retest |
| AMBIPOM | 36.1% | 75 / 100 / 66 / 115 / 90 / 66 | Ability/set retest |
| CLEFABLE | 36.1% | 92 / 70 / 73 / 60 / 95 / 90 | Support/set retest |
| PINSIR | 36.1% | 65 / 125 / 100 / 85 / 55 / 70 | Buff candidate |
| DUGTRIO_ALOLAN | 35.9% | 60 / 100 / 60 / 110 / 50 / 70 | Weather-role retest |
| ESPATHRA | 35.9% | 95 / 60 / 60 / 105 / 101 / 60 | Retest before any buff |
| TOXICROAK | 35.9% | 83 / 106 / 65 / 98 / 86 / 65 | Retest before any buff |
| HYPNO | 35.7% | 85 / 73 / 70 / 67 / 73 / 115 | Retest; secondary buff |
| MAROWAK | 35.2% | 60 / 80 / 110 / 45 / 50 / 80 | Item/role retest |
| SALAZZLE | 33.9% | 68 / 64 / 60 / 117 / 116 / 60 | Status/weather-role retest |
| TANGROWTH | 33.9% | 100 / 100 / 125 / 50 / 110 / 50 | Team-role retest |
| VICTREEBEL | 33.5% | 80 / 105 / 65 / 70 / 100 / 70 | Status/weather-role retest |
| WEEZING | 33.3% | 65 / 90 / 120 / 60 / 85 / 70 | Support/defensive retest |
| BANETTE | 33.0% | 64 / 125 / 65 / 70 / 93 / 63 | Support/set retest |
| SHUCKLE | 32.6% | 20 / 10 / 230 / 5 / 10 / 230 | Keep defensive/support role |
| MUK | 31.5% | 105 / 105 / 75 / 50 / 65 / 100 | Team-role retest |
| PERSIAN | 31.1% | 70 / 90 / 60 / 115 / 80 / 65 | Buff candidate |
| EXEGGUTOR_ALOLAN | 30.9% | 95 / 125 / 85 / 45 / 105 / 75 | Conditional buff candidate |
| BLISSEY | 30.2% | 255 / 10 / 10 / 55 / 75 / 135 | Keep specialist identity |
| DUGTRIO | 30.2% | 60 / 100 / 50 / 120 / 50 / 70 | Weather-role retest |
| ARIADOS | 29.6% | 80 / 110 / 75 / 100 / 50 / 70 | Requested buff applied; hold |
| XATU | 27.8% | 80 / 75 / 70 / 95 / 95 / 70 | Support/set retest |
| DITTO | 27.0% | 48 / 48 / 48 / 48 / 48 / 48 | Role retest; no stat buff |
| VENOMOTH | 26.3% | 70 / 55 / 60 / 90 / 115 / 75 | Requested buff applied; setup retest |
| ZANGOOSE | 25.9% | 75 / 125 / 60 / 110 / 60 / 60 | Requested buff applied; hold |
| BRELOOM | 22.6% | 60 / 130 / 80 / 70 / 60 / 60 | Targeted set retest |
| LUDICOLO | 17.0% | 80 / 90 / 70 / 70 / 90 / 100 | Requested buff applied; rain retest |
| SMEARGLE | 12.6% | 55 / 20 / 35 / 75 / 20 / 45 | Team-role retest; no stat buff |
