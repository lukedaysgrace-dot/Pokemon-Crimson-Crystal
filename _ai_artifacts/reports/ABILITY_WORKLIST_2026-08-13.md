# Ability Worklist — Crimson Crystal

Prepared 2026-08-13. **Nothing has been changed in the repo.** This is
the queue for the next session.

Two parts:

- **Part 1** — slot fixes using abilities *already in the ROM*. Pure data
  edits to `data/pokemon/base_stats/*.asm`. Exact replacement lines given.
- **Part 2** — the abilities that still need to be implemented, with who
  receives each one.

---

# PART 1 — Ready to apply (no engine work)

26 line edits. Every ability referenced here already exists in
`constants/ability_constants.asm`.

## 1a. Duplicate-slot bugs

**`happiny.asm`** — Natural Cure appears in slots 1 and 3
```
- abilities_for HAPPINY, NATURAL_CURE, SERENE_GRACE, NATURAL_CURE
+ abilities_for HAPPINY, SERENE_GRACE, NATURAL_CURE, NO_ABILITY
```
Now matches Chansey/Blissey slot order exactly. Hidden waits for `HEALER`.

**`finizen.asm`** — Water Veil appears in slots 1 and 2
```
- abilities_for FINIZEN, WATER_VEIL, WATER_VEIL, SWIFT_SWIM
+ abilities_for FINIZEN, WATER_VEIL, SWIFT_SWIM, NO_ABILITY
```
*Alternative:* `WATER_VEIL, IRON_FIST, SWIFT_SWIM` if you want it to
foreshadow Palafin.

**`wynaut.asm`** — Shadow Tag in all three slots
```
- abilities_for WYNAUT, SHADOW_TAG, SHADOW_TAG, SHADOW_TAG
+ abilities_for WYNAUT, SHADOW_TAG, NO_ABILITY, NO_ABILITY
```
Now matches Wobbuffet. Hidden waits for `TELEPATHY`.

**`rypherior.asm`** — not an ability edit. This file is a byte-identical
duplicate of `rhyperior.asm` with a misspelled name. Check
`constants/pokemon_constants.asm`, `dex_order_new.asm`, and
`dex_order_alpha.asm` for a phantom entry before deleting.

## 1b. Evolution lines that lost an ability

**`venusaur.asm`** — only starter final stage without its own starter ability
```
- abilities_for VENUSAUR, CHLOROPHYLL, THICK_FAT, NO_ABILITY
+ abilities_for VENUSAUR, CHLOROPHYLL, OVERGROW, THICK_FAT
```

**`voltorb.asm`** — Hisuian form already has Static; Kanto form never got it
```
- abilities_for VOLTORB, SOUNDPROOF, AFTERMATH, NO_ABILITY
+ abilities_for VOLTORB, SOUNDPROOF, STATIC, AFTERMATH
```

**`electrode.asm`**
```
- abilities_for ELECTRODE, SOUNDPROOF, AFTERMATH, NO_ABILITY
+ abilities_for ELECTRODE, SOUNDPROOF, STATIC, AFTERMATH
```

**`mr__mime.asm`** — Mime Jr. has Soundproof, Mr. Mime loses it
```
- abilities_for MR__MIME, FILTER, TECHNICIAN, NO_ABILITY
+ abilities_for MR__MIME, SOUNDPROOF, FILTER, TECHNICIAN
```

**`grumpig.asm`** — Spoink has Own Tempo, Grumpig drops it
```
- abilities_for GRUMPIG, THICK_FAT, PRANKSTER, NO_ABILITY
+ abilities_for GRUMPIG, THICK_FAT, OWN_TEMPO, PRANKSTER
```

**`tauros_paldean_fire.asm`** — base Tauros has Anger Point
```
- abilities_for TAUROS_PALDEAN_FIRE, INTIMIDATE, RECKLESS, NO_ABILITY
+ abilities_for TAUROS_PALDEAN_FIRE, INTIMIDATE, ANGER_POINT, RECKLESS
```

**`tauros_paldean_water.asm`**
```
- abilities_for TAUROS_PALDEAN_WATER, INTIMIDATE, RECKLESS, NO_ABILITY
+ abilities_for TAUROS_PALDEAN_WATER, INTIMIDATE, ANGER_POINT, RECKLESS
```

**`glimmora.asm`** — Glimmet has Merciless, its evolution has 2 empty slots
```
- abilities_for GLIMMORA, TOXIC_DEBRIS, NO_ABILITY, NO_ABILITY
+ abilities_for GLIMMORA, TOXIC_DEBRIS, NO_ABILITY, MERCILESS
```
Slot 2 waits for `CORROSION`.

## 1c. Missing a canonical ability that's already in the ROM

**`ursalunabm.asm`** — gives the orphan `MINDS_EYE` constant its home
```
- abilities_for URSALUNABM, GUTS, BULLETPROOF, NO_ABILITY
+ abilities_for URSALUNABM, GUTS, BULLETPROOF, MINDS_EYE
```
*Faithful alternative:* Bloodmoon Ursaluna canonically has **only**
Mind's Eye. `MINDS_EYE, NO_ABILITY, NO_ABILITY` if you want it accurate —
your call, since that removes Guts from a signature mon.

**`jynx.asm`**
```
- abilities_for JYNX, DRY_SKIN, NO_ABILITY, NO_ABILITY
+ abilities_for JYNX, OBLIVIOUS, NO_ABILITY, DRY_SKIN
```
Slot 2 waits for `FOREWARN`.

**`smoochum.asm`**
```
- abilities_for SMOOCHUM, HYDRATION, NO_ABILITY, NO_ABILITY
+ abilities_for SMOOCHUM, OBLIVIOUS, NO_ABILITY, HYDRATION
```
Slot 2 waits for `FOREWARN`.

**`lickitung.asm`**
```
- abilities_for LICKITUNG, OBLIVIOUS, NO_ABILITY, CLOUD_NINE
+ abilities_for LICKITUNG, OWN_TEMPO, OBLIVIOUS, CLOUD_NINE
```

**`lickilicky.asm`**
```
- abilities_for LICKILICKY, OBLIVIOUS, NO_ABILITY, CLOUD_NINE
+ abilities_for LICKILICKY, OWN_TEMPO, OBLIVIOUS, CLOUD_NINE
```

**`wooper.asm`**
```
- abilities_for WOOPER, WATER_ABSORB, NO_ABILITY, NO_ABILITY
+ abilities_for WOOPER, DAMP, WATER_ABSORB, NO_ABILITY
```
Hidden waits for `UNAWARE`.

**`quagsire.asm`**
```
- abilities_for QUAGSIRE, WATER_ABSORB, NO_ABILITY, NO_ABILITY
+ abilities_for QUAGSIRE, DAMP, WATER_ABSORB, NO_ABILITY
```
Hidden waits for `UNAWARE`.

**`sneasel.asm`**
```
- abilities_for SNEASEL, TECHNICIAN, INNER_FOCUS, NO_ABILITY
+ abilities_for SNEASEL, TECHNICIAN, INNER_FOCUS, KEEN_EYE
```

**`larvitar.asm`**
```
- abilities_for LARVITAR, GUTS, NO_ABILITY, INTIMIDATE
+ abilities_for LARVITAR, GUTS, SAND_VEIL, INTIMIDATE
```

**`jolteon.asm`**
```
- abilities_for JOLTEON, VOLT_ABSORB, NO_ABILITY, COMPETITIVE
+ abilities_for JOLTEON, VOLT_ABSORB, QUICK_FEET, COMPETITIVE
```

**`rattata_alolan.asm`**
```
- abilities_for RATTATA_ALOLAN, HUSTLE, GUTS, NO_ABILITY
+ abilities_for RATTATA_ALOLAN, HUSTLE, GUTS, THICK_FAT
```

**`raticate_alolan.asm`**
```
- abilities_for RATICATE_ALOLAN, HUSTLE, GUTS, NO_ABILITY
+ abilities_for RATICATE_ALOLAN, HUSTLE, GUTS, THICK_FAT
```

## 1d. Flagged — your call, not applied by default

**`ditto.asm`** — canonically Limber slot 1, Imposter hidden
```
  abilities_for DITTO, IMPOSTER, NO_ABILITY, NO_ABILITY
```
Making it canon (`LIMBER, NO_ABILITY, IMPOSTER`) means most wild Ditto
roll Limber instead of Imposter, which changes how the mon plays. Say the
word either way.

**`gallade.asm`** — canonical hidden is `JUSTIFIED`, currently `INNER_FOCUS`
```
  abilities_for GALLADE, STEADFAST, SHARPNESS, INNER_FOCUS
```
Slots are full, so this is a swap rather than a fill.

## Part 1 result

Fixes 4 data bugs and 8 broken evolution lines, gives `MINDS_EYE` a home,
and fills **19 empty slots** — 205 down to 186 — with zero engine work.

---

# PART 2 — Abilities to implement

Ordered by slots-filled per unit of work. Every mon listed is one whose
canonical set includes that ability and who currently has an empty slot
waiting for it.

## Tier 1 — do these first

### ☐ `GLUTTONY` — 14 slots · cheap
Eats a held Berry at 1/2 HP instead of 1/4.
> `BELLSPROUT` `WEEPINBELL` `VICTREEBEL` `SNORLAX` `MUNCHLAX`
> `GRIMER_ALOLAN` `MUK_ALOLAN` `SHUCKLE` `SPOINK` `GRUMPIG` `APPLIN`
> `FLAPPLE` `APPLETUN` `DIPPLIN`

Rescues the Apple family (Applin has 2 empty slots, Dipplin has all 3).
Also the first ability in the game to touch held Berries at all.

### ☐ `RUN_AWAY` — 13 slots · trivial
Guaranteed escape from wild battles; Gen 8+ also ignores trapping.
> `SENTRET` `AIPOM` `SNUBBULL` `BUNEARY` `EEVEE` `DODUO` `DODRIO`
> `ODDISH` `DUNSPARCE` `DRUNSPARCE` `PONYTA_GALARIAN`
> `RAPIDASH_GALARIAN` `VENONAT`

Low competitive value, highest slot count, near-zero cost.

### ☐ `INFILTRATOR` — 9 slots · moderate · **best competitive value**
Ignores Reflect / Light Screen / Safeguard / Substitute.
> `ZUBAT` `GOLBAT` `CROBAT` `DREEPY` `DRAKLOAK` `DRAGAPULT` `HOPPIP`
> `SKIPLOOM` `JUMPLUFF`

Fills the entire Dreepy line's empty slot 2.

### ☐ `LEAF_GUARD` — 8 slots · cheap
Blocks status in harsh sunlight.
> `HOPPIP` `SKIPLOOM` `JUMPLUFF` `LEAFEON` `TANGELA` `TANGROWTH`
> `BOUNSWEET` `STEENEE`

Fixes `LEAFEON`, currently the only Eeveelution with one ability while
the other seven have three.

## Tier 2 — good value

### ☐ `EARLY_BIRD` — 7 slots · trivial
Wakes from sleep in half the turns.
> `NATU` `XATU` `WATU` `DODUO` `DODRIO` `SUNKERN` `SUNFLORA`

### ☐ `UNAWARE` — 5 slots · moderate · **biggest missing archetype**
Ignores the opponent's stat stages. Nothing in the game does this today.
> `QUAGSIRE` `WOOPER` `WOOPER_PALDEAN` `CLODSIRE` `CLEFABLE`

### ☐ `STENCH` — 5 slots · trivial
10% flinch on damaging moves.
> `GRIMER` `MUK` `GLOOM` `KOFFING` `WEEZING`

Fixes the Grimer line — all four forms currently have 2 empty slots.

### ☐ `ANTICIPATION` — 5 slots · moderate
Shudders on switch-in vs super-effective / OHKO moves.
> `CROAGUNK` `TOXICROAK` `EEVEE` `PONYTA_GALARIAN` `RAPIDASH_GALARIAN`

### ☐ `PICKPOCKET` — 5 slots · moderate
Steals the attacker's item on contact.
> `SNEASEL` `WEAVILE` `IMPIDIMP` `MORGREM` `TINKATINK` line

### ☐ `SHIELD_DUST` — 4 slots · cheap
Blocks secondary effects. You already gate secondaries for Sheer Force,
so the hook exists.
> `CATERPIE` `METAPOD` `WEEDLE` `KAKUNA`

### ☐ `CORROSION` — 4 slots · moderate
Can poison Steel and Poison types.
> `SALANDIT` `SALAZZLE` `GLIMMET` `GLIMMORA`

Salandit and Salazzle are currently missing their own signature ability.
Pairs with `MERCILESS` and the orphan `POISON_PUPPETEER` constant.

### ☐ `HARVEST` — 4 slots · moderate
> `EXEGGCUTE` `EXEGGUTOR` `EXEGGUTOR_ALOLAN` `APPLETUN`

### ☐ `HEAVY_METAL` — 4 slots · trivial
> `ARON` `LAIRON` `AGGRON` `DURALUDON`

## Tier 3 — clean 3-slot fits, all cheap

| ☐ | Ability | Mons |
|---|---|---|
| ☐ | `DOWNLOAD` | `PORYGON` `PORYGON2` `PORYGON_Z` — all three have empty slot 2 |
| ☐ | `SUCTION_CUPS` | `OCTILLERY` `LILEEP` `CRADILY` |
| ☐ | `STICKY_HOLD` | `GRIMER` `MUK` `DIPPLIN` |
| ☐ | `TELEPATHY` | `RALTS` `KIRLIA` `WOBBUFFET` |
| ☐ | `HEALER` | `CHANSEY` `BLISSEY` `HAPPINY` `BELLOSSOM` |
| ☐ | `UNBURDEN` | `HITMONLEE` `DRIFLOON` `DRIFBLIM` |
| ☐ | `KLUTZ` | `BUNEARY` `GOLETT` `GOLURK` |
| ☐ | `RIPEN` | `APPLIN` `FLAPPLE` `APPLETUN` |
| ☐ | `CUD_CHEW` | `FARIGIRAF` `TAUROS_PALDEAN_FIRE` `TAUROS_PALDEAN_WATER` |
| ☐ | `PLUS` | `MAREEP` `FLAAFFY` `AMPHAROS` |
| ☐ | `FOREWARN` | `JYNX` `SMOOCHUM` |
| ☐ | `POWER_OF_ALCHEMY` | `GRIMER_ALOLAN` `MUK_ALOLAN` |

## Tier 4 — signature abilities, 1–2 mons each

| ☐ | Ability | Mon | Note |
|---|---|---|---|
| ☐ | `WIMP_OUT` | `WIMPOD` | 2 empty slots |
| ☐ | `EMERGENCY_EXIT` | `GOLISOPOD` | 2 empty slots |
| ☐ | `SURGE_SURFER` | `RAICHU_ALOLAN` | 2 empty slots; currently has non-canonical `STATIC` |
| ☐ | `SUPERSWEET_SYRUP` | `DIPPLIN` | The reason Dipplin is fully blank |
| ☐ | `LIGHT_METAL` / `STALWART` | `DURALUDON` | |
| ☐ | `DEFEATIST` | `ARCHEN` `ARCHEOPS` | You already redesigned these — probably skip |
| ☐ | `MOODY` | `OCTILLERY` `REMORAID` `SNORUNT` `SMEARGLE` | Banned in most formats — probably skip |
| ☐ | `BATTERY` | `CHARJABUG` | Doubles-only — skip |
| ☐ | `FRIEND_GUARD` | `HAPPINY` | Doubles-only — skip |

## Tier 5 — design-space additions (no canonical distribution)

These aren't about matching canon. They're the archetypes the game can't
currently express, from the first pass.

### ☐ Type-boost abilities — 1.5× on one type · **near-free**
`STEELY_SPIRIT` already runs as a self-boost at
`engine/battle/abilities_engine.asm:1938`. Each of these is a `cp` plus a
type check in a chain that already exists.
> ☐ `TRANSISTOR` (Electric) · ☐ `DRAGONS_MAW` (Dragon) ·
> ☐ `ROCKY_PAYLOAD` (Rock) · ☐ `PUNK_ROCK` (sound) ·
> ☐ `STEELWORKER` (Steel)

Best cost-to-identity ratio available, and ideal filler for the ~108
empty slot-2s.

### ☐ Drawback abilities — the game currently has **zero**
Lets you give a mon a scary statline and charge for it, instead of
shaving stats.
> ☐ `TRUANT` · ☐ `SLOW_START` · ☐ `STALL` · ☐ `KLUTZ` (also Tier 3)

### ☐ `SIMPLE` — doubles stat changes · **near-free**
Shares the stat-change hook `CONTRARY` already uses.

### ☐ Cheap defensive levers with no equivalent in the set
> ☐ `LIQUID_OOZE` (punishes drain) · ☐ `SHIELD_DUST` (also Tier 2)

### ☐ Aliases — one table row each, no new logic
> ☐ `ROUGH_SKIN` → identical to existing `IRON_BARBS`
> ☐ `GOOEY` → identical to existing `TANGLING_HAIR`

## Skip list

Confirmed not worth it: `ILLUSION` (sprite/name spoofing is enormous),
`PROTEAN`/`LIBERO`, terrain setters (`ELECTRIC_SURGE` et al), auras
(`DARK_AURA`, `FAIRY_AURA`), `PROTOSYNTHESIS`/`QUARK_DRIVE`, all
Tera-related, and anything doubles-only (`BATTERY`, `POWER_SPOT`,
`FRIEND_GUARD`, `HEALER`'s doubles half, `COSTAR`).

Already covered by an existing ability — don't add: `HEATPROOF`
(≈`THICK_FAT`), `ANTICIPATION`/`FOREWARN` overlap with `FRISK`,
`EARLY_BIRD` overlaps `INSOMNIA`/`VITAL_SPIRIT`.

---

# Build notes for next session

- `NUM_ABILITIES` is currently **151** (150 real + `NO_ABILITY`).
- Each new ability needs a row in **all** of: `constants/ability_constants.asm`,
  `data/abilities/names.asm`, `data/abilities/descriptions.asm`, and the
  flags table (currently 148 rows, in const order) noted in
  `ABILITY_PORT_PLAN.md`.
- `ABILITY_PORT_PLAN.md` session 8 flags the Effect Commands bank as tight
  (~10 bytes spare after the Scrappy/Mind's Eye hook). Check the link map
  before adding anything that needs a new hook site; prefer Tier 5's
  type-boosters and aliases, which reuse existing chains.
- Tier 1 + Tier 2 is **13 new abilities** and would take empty slots from
  205 down to roughly **90**.

## Still-orphaned constants after Part 1

`MINDS_EYE` gets `URSALUNABM` in Part 1. These three remain unassigned
despite being implemented:

- `BERSERK` — suggest the `FRIGIBAX` line, or any bulky special attacker
- `POISON_PUPPETEER` — pairs with `MERCILESS` on `SALANDIT`/`SALAZZLE`
  or the `GLIMMET` line
- `WIND_RIDER` — suggest `FLETCHLING`/`TALONFLAME` line, or
  `NOIBAT`/`NOIVERN`
- `MEGA_SOL` — appears to be a custom ability awaiting its custom mon
