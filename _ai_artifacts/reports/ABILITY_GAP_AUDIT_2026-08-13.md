# Ability Gap Audit — Crimson Crystal

Generated 2026-08-13. Source: `data/pokemon/base_stats/*.asm` (481 mons),
`constants/ability_constants.asm` (151 constants incl. `NO_ABILITY`).

Cross-referenced every mon's three ability slots against its canonical
Gen 3–9 ability set. Three tiers below:

- **Tier A** — bugs and free fixes. The canonical ability already exists
  in the game; the mon just isn't assigned it. Pure data edits.
- **Tier B** — empty slots whose canonical filler is NOT in the game.
  These are the abilities worth adding, ranked by how many slots each
  would fill.
- **Tier C** — empty slots that are correct (canonically single-ability
  mons). No action.

---

## Tier A — free fixes (ability already in the ROM)

### A1. Outright bugs

| Mon | Current | Problem | Fix |
|---|---|---|---|
| `HAPPINY` | `NATURAL_CURE, SERENE_GRACE, NATURAL_CURE` | **Natural Cure listed twice** — hidden slot is a wasted duplicate | Hidden → `FRISK` or `IMMUNITY` |
| `FINIZEN` | `WATER_VEIL, WATER_VEIL, SWIFT_SWIM` | **Water Veil listed twice** in slots 1 and 2 | Slot 2 → `SWIFT_SWIM`, hidden → something else |
| `WYNAUT` | `SHADOW_TAG, SHADOW_TAG, SHADOW_TAG` | All three slots identical | Keep slot 1, free the other two |
| `RHYPERIOR` + `RYPHERIOR` | identical stat blocks | **Two files, misspelled duplicate species** — check `pokemon_constants.asm` and the dex order for a phantom entry | Delete `rypherior.asm` if unreferenced |

### A2. Broken evolution lines — the mon lost an ability its pre-evo has

| Mon | Current | Missing | Note |
|---|---|---|---|
| `VENUSAUR` | `CHLOROPHYLL, THICK_FAT, —` | **`OVERGROW`** | Bulbasaur and Ivysaur are both `CHLOROPHYLL, OVERGROW, EFFECT_SPORE`. Venusaur is the only stage without its own starter ability. |
| `VOLTORB` | `SOUNDPROOF, AFTERMATH, —` | **`STATIC`** | Hisuian Voltorb/Electrode are correctly `SOUNDPROOF, STATIC, AFTERMATH`. Kanto forms just never got Static. |
| `ELECTRODE` | `SOUNDPROOF, AFTERMATH, —` | **`STATIC`** | Same as above. |
| `MR__MIME` | `FILTER, TECHNICIAN, —` | **`SOUNDPROOF`** | Mime Jr. is correctly `SOUNDPROOF, FILTER, TECHNICIAN`. The evolution loses one. |
| `GRUMPIG` | `THICK_FAT, PRANKSTER, —` | **`OWN_TEMPO`** | Spoink has `THICK_FAT, OWN_TEMPO`. Grumpig drops it. |
| `TAUROS_PALDEAN_FIRE` | `INTIMIDATE, RECKLESS, —` | **`ANGER_POINT`** | Base Tauros is `INTIMIDATE, ANGER_POINT, SHEER_FORCE`. |
| `TAUROS_PALDEAN_WATER` | `INTIMIDATE, RECKLESS, —` | **`ANGER_POINT`** | Same. |
| `GLIMMORA` | `TOXIC_DEBRIS, —, —` | **`MERCILESS`** | Glimmet has `TOXIC_DEBRIS, —, MERCILESS`. Evolution has two empty slots. |

### A3. Canonical ability exists in-game, mon simply lacks it

| Mon | Current | Add | Canonical role |
|---|---|---|---|
| `URSALUNABM` | `GUTS, BULLETPROOF, —` | **`MINDS_EYE`** | This is Bloodmoon Ursaluna's signature ability, and `MINDS_EYE` is one of your five orphan constants. Direct match. |
| `JYNX` | `DRY_SKIN, —, —` | **`OBLIVIOUS`** | Canonical slot 1 |
| `SMOOCHUM` | `HYDRATION, —, —` | **`OBLIVIOUS`** | Canonical slot 1 |
| `LICKITUNG` | `OBLIVIOUS, —, CLOUD_NINE` | **`OWN_TEMPO`** | Canonical slot 1 |
| `LICKILICKY` | `OBLIVIOUS, —, CLOUD_NINE` | **`OWN_TEMPO`** | Canonical slot 1 |
| `WOOPER` | `WATER_ABSORB, —, —` | **`DAMP`** | Canonical slot 1 |
| `QUAGSIRE` | `WATER_ABSORB, —, —` | **`DAMP`** | Canonical slot 1 |
| `DITTO` | `IMPOSTER, —, —` | **`LIMBER`** | Canonical slot 1 (Imposter is the hidden) |
| `SNEASEL` | `TECHNICIAN, INNER_FOCUS, —` | **`KEEN_EYE`** | Canonical slot 2 |
| `LARVITAR` | `GUTS, —, INTIMIDATE` | **`SAND_VEIL`** | Canonical hidden |
| `JOLTEON` | `VOLT_ABSORB, —, COMPETITIVE` | **`QUICK_FEET`** | Canonical hidden; Flareon already has it |
| `RATTATA_ALOLAN` | `HUSTLE, GUTS, —` | **`THICK_FAT`** | Canonical hidden |
| `RATICATE_ALOLAN` | `HUSTLE, GUTS, —` | **`THICK_FAT`** | Canonical hidden |
| `GALLADE` | `STEADFAST, SHARPNESS, INNER_FOCUS` | **`JUSTIFIED`** | Canonical hidden; slots are full, so only if you want the swap |

**Tier A total: ~25 edits, zero engine work.** These alone close a
meaningful chunk of the 205 empty slots and fix four data bugs.

---

## Tier B — abilities worth adding, ranked by slots filled

Each row is an ability not currently in the ROM, with the mons whose
canonical set it belongs to. Ranked by coverage-per-implementation-cost.

### B1. `GLUTTONY` — ~14 slots. Cheap.
Eats a held Berry at 1/2 HP instead of 1/4.
> `BELLSPROUT`, `WEEPINBELL`, `VICTREEBEL`, `SNORLAX`, `MUNCHLAX`,
> `GRIMER_ALOLAN`, `MUK_ALOLAN`, `SHUCKLE`, `SPOINK`, `GRUMPIG`,
> `APPLIN`, `FLAPPLE`, `APPLETUN`, `DIPPLIN`

Notably this is the single best fix for the Apple family, which is your
most ability-starved line in the game (Applin has 2 empty slots, Dipplin
has all 3). It also opens your held-berry subsystem to abilities for the
first time — currently **zero** abilities in the game interact with
Berries.

### B2. `RUN_AWAY` — ~13 slots. Trivially cheap.
Guaranteed escape from wild battles (Gen 8+: also ignores trapping).
> `SENTRET`, `AIPOM`, `SNUBBULL`, `BUNEARY`, `EEVEE`, `DODUO`, `DODRIO`,
> `ODDISH`, `DUNSPARCE`, `DRUNSPARCE`, `PONYTA_GALARIAN`,
> `RAPIDASH_GALARIAN`, `VENONAT`

Low competitive value, but it's the highest slot-count filler in the
game and costs almost nothing. Good "flavor filler" so early-route mons
stop sharing identical two-ability sets.

### B3. `INFILTRATOR` — ~9 slots. Moderate, high competitive value.
Bypasses Reflect/Light Screen/Safeguard/Substitute.
> `ZUBAT`, `GOLBAT`, `CROBAT`, `DREEPY`, `DRAKLOAK`, `DRAGAPULT`,
> `HOPPIP`, `SKIPLOOM`, `JUMPLUFF`

Best value pick in this tier — real competitive weight, no equivalent in
your current set, and it fills the entire Dreepy line's empty slot 2.

### B4. `LEAF_GUARD` — ~8 slots. Cheap.
Blocks status in harsh sunlight.
> `HOPPIP`, `SKIPLOOM`, `JUMPLUFF`, `LEAFEON`, `TANGELA`, `TANGROWTH`,
> `BOUNSWEET`, `STEENEE`

Fixes `LEAFEON`, currently the only Eeveelution with **one** ability
while all seven others have three.

### B5. `EARLY_BIRD` — ~6 slots. Trivial.
> `NATU`, `XATU`, `WATU`, `DODUO`, `DODRIO`, `SUNKERN`, `SUNFLORA`

Fills slot 2 for the whole Natu family (including your custom `WATU`).

### B6. `ANTICIPATION` — ~5 slots. Moderate.
> `CROAGUNK`, `TOXICROAK`, `EEVEE`, `PONYTA_GALARIAN`, `RAPIDASH_GALARIAN`

### B7. `UNAWARE` — ~5 slots. Moderate cost, high design value.
> `QUAGSIRE`, `WOOPER`, `WOOPER_PALDEAN`, `CLODSIRE`, `CLEFABLE`

Flagged in the earlier review as your biggest missing archetype — nothing
in the game ignores stat stages. Canon puts it exactly on the Wooper
family, so implementation and distribution arrive together.

### B8. `STENCH` — ~5 slots. Trivial.
> `GRIMER`, `MUK`, `GLOOM`, `KOFFING`, `WEEZING`

Fixes the Grimer line, which currently has **two empty slots on all four
forms**.

### B9. `SHIELD_DUST` — 4 slots. Cheap.
> `CATERPIE`, `METAPOD`, `WEEDLE`, `KAKUNA`

The four early bugs are the emptiest common mons in the game.

### B10. `HARVEST` — 4 slots. Moderate.
> `EXEGGCUTE`, `EXEGGUTOR`, `EXEGGUTOR_ALOLAN`, `APPLETUN`

### B11. `CORROSION` — ~4 slots. Moderate, high flavor value.
> `SALANDIT`, `SALAZZLE`, `GLIMMORA`, (`GLIMMET`)

`SALANDIT`/`SALAZZLE` currently have `POISON_TOUCH, OBLIVIOUS, MERCILESS`
— they are missing their own signature ability. Pairs naturally with
`MERCILESS` and the orphan `POISON_PUPPETEER` constant.

### B12. `HEAVY_METAL` — 4 slots. Trivial.
> `ARON`, `LAIRON`, `AGGRON`, `DURALUDON`

### B13. Smaller but clean fits (3 slots each, all cheap)
| Ability | Mons |
|---|---|
| `DOWNLOAD` | `PORYGON`, `PORYGON2`, `PORYGON_Z` — all three have an empty slot 2 |
| `SUCTION_CUPS` | `OCTILLERY`, `LILEEP`, `CRADILY` |
| `STICKY_HOLD` | `GRIMER`, `MUK`, `DIPPLIN` |
| `TELEPATHY` | `RALTS`, `KIRLIA`, `WOBBUFFET` |
| `HEALER` | `CHANSEY`, `BLISSEY`, `BELLOSSOM` |
| `UNBURDEN` | `HITMONLEE`, `DRIFLOON`, `DRIFBLIM` |
| `KLUTZ` | `BUNEARY`, `GOLETT`, `GOLURK` |
| `RIPEN` | `APPLIN`, `FLAPPLE`, `APPLETUN` |
| `PICKPOCKET` | `SNEASEL`, `WEAVILE`, `IMPIDIMP`, `MORGREM`, `TINKATINK` line |

### B14. Signature-only (1–2 slots, skip unless you want the mon accurate)
| Ability | Mons | Verdict |
|---|---|---|
| `WIMP_OUT` / `EMERGENCY_EXIT` | `WIMPOD`, `GOLISOPOD` | Both currently have 2 empty slots |
| `SURGE_SURFER` | `RAICHU_ALOLAN` | 2 empty slots; currently has non-canonical `STATIC` |
| `DEFEATIST` | `ARCHEN`, `ARCHEOPS` | You already redesigned these — skip |
| `CUD_CHEW` | `FARIGIRAF`, `TAUROS_PALDEAN` | |
| `SUPERSWEET_SYRUP` | `DIPPLIN` | The only reason Dipplin is fully blank |
| `BATTERY` | `CHARJABUG` | Doubles-only — skip |
| `LIGHT_METAL` / `STALWART` | `DURALUDON` | |

---

## Tier C — correctly empty, no action needed

These have empty slots because they're canonically single-ability mons:

`HYDREIGON`, `DEINO`, `ZWEILOUS`, `CELEBI`, `MEW`, `UNOWN`, `MIMIKYU`,
`CHARCADET`, `HO_OH`, `LUGIA`, `MEWTWO`, `GYARADOS`, `PUPITAR`,
`TYRANITAR`, `MAGIKARP`, `SYLVEON`, `ESPEON`, `NATU`/`XATU` (hidden ok),
`MISDREAVUS`, `MISMAGIUS`, `FORRETRESS`, `SHUCKLE`, `CROBAT` line
(hidden), `SNORLAX`, `MUNCHLAX`, `CLEFAIRY` line, `AGGRON` line,
`HITMONLEE`, `RALTS`/`KIRLIA`, `AMPHAROS`/`MAREEP`/`FLAAFFY`,
`SUNKERN`/`SUNFLORA` (hidden), `SNORUNT`, `REMORAID`, `SMEARGLE`,
`WEAVILE`, `KOFFING`/`WEEZING`, `TINKATINK` line, `IMPIDIMP`/`MORGREM`,
`DUNSPARCE` line, `CLODSIRE`, `CHANSEY`/`BLISSEY`, `VENONAT`,
`SLOWPOKE_GALARIAN` line, `VULPIX_ALOLAN`/`NINETALES_ALOLAN`,
`EXEGGUTOR_ALOLAN`, `FRIGIBAX` line, `LARVESTA`/`VOLCARONA`,
`FLETCHLING` line, `CORSOLA_GALARIAN`/`CURSOLA`, `MARILL` line.

---

## Recommended order of work

1. **Tier A** (~25 data edits, no engine work) — fixes 4 real bugs and
   4 broken evolution lines, and finally gives `MINDS_EYE` a home.
2. **`GLUTTONY` + `RUN_AWAY`** — ~27 slots for two cheap abilities.
   Between them they rescue the Apple family and the early-route mons.
3. **`INFILTRATOR` + `UNAWARE`** — the two with real competitive weight
   whose canonical distribution lands where you have holes anyway.
4. **`LEAF_GUARD`, `STENCH`, `SHIELD_DUST`, `EARLY_BIRD`** — cheap
   flavor filler for another ~23 slots.
5. Everything else as ROM budget allows.

Steps 1–4 would take the empty-slot count from **205 down to roughly
110**, using 8 new abilities.

## Also outstanding

Four orphan constants still have no home after Tier A:
`BERSERK`, `MEGA_SOL`, `POISON_PUPPETEER`, `WIND_RIDER`.
All four are implemented per `ABILITY_PORT_PLAN.md`. Suggested homes:

- `BERSERK` — `DRAMPA`/`FRIGIBAX` line, or any bulky special attacker
- `POISON_PUPPETEER` — pairs with `MERCILESS` on `SALANDIT`/`SALAZZLE`
  or the `GLIMMET` line
- `WIND_RIDER` — `FLETCHLING`/`TALONFLAME` line, `NOIBAT`/`NOIVERN`
- `MEGA_SOL` — appears to be a custom ability awaiting its custom mon
