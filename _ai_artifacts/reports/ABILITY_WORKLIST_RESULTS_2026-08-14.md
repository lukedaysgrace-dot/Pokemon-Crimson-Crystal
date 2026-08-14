# Ability Worklist — Applied (2026-08-14 session)

Everything below is from `ABILITY_WORKLIST_2026-08-13.md`, applied per
Lucas's instructions. **`make` builds clean with rgbds 0.5.2** (verified in
this session; the shipped `pokecrystal.gbc` is the fresh build). Emulator
smoke test: boots, new game works, a wild battle starts and runs with the
expanded 174-ability tables (wild ability roll verified in memory).

## What was applied

### Part 1 — all 24 slot edits
All duplicate-slot bugs (Happiny/Finizen/Wynaut), broken evolution lines
(Venusaur, Voltorb, Electrode, Mr. Mime, Grumpig, both Paldean Tauros,
Glimmora), and the missing-canonical fixes (Ursaluna BM gets MIND'S EYE,
Jynx, Smoochum, Lickitung, Lickilicky, Wooper, Quagsire, Sneasel,
Larvitar, Jolteon, both Alolan rats). Per your call: **Gallade hidden →
JUSTIFIED applied, Ditto left as-is** (Imposter only).
`rypherior.asm` was verified unreferenced (no constant, no dex entry, not
in the build) and deleted.

### Part 2 — 23 new abilities implemented + assigned
- **Tier 1:** Gluttony, Run Away, Infiltrator, Leaf Guard
- **Tier 2:** Early Bird, Unaware, Stench, Anticipation, Pickpocket,
  Shield Dust, Corrosion, Harvest, Heavy Metal
- **Tier 3:** Download, Suction Cups, Sticky Hold, Unburden, Klutz,
  Ripen, Cud Chew, Forewarn
- **Tier 4:** Supersweet Syrup, Light Metal

`NUM_ABILITIES` is now **174** (was 151). Constants, names, descriptions
and flags tables all extended in matching order (174 rows each).

### Excluded (your calls + the sheet's skip list)
Defeatist, Wimp Out, Emergency Exit, Healer, Telepathy, Plus, Power of
Alchemy (doubles-only/ally effects), Battery, Friend Guard, Surge Surfer
(terrain), **Stalwart** (its only effect is ignoring move redirection,
which never happens in singles — so Duraludon got Light Metal + Heavy
Metal, keeping Steadfast as its hidden), Moody, and everything on the
sheet's skip list.

## How each ability works in this engine

- **Gluttony** — HP Berries in this engine already trigger below 1/2 max
  HP (Gen 2 behavior), so "1/2 instead of 1/4" would have been a no-op.
  Gluttony holders instead eat below **3/4** max HP — same spirit, eats
  earlier than everyone else.
- **Ripen** — doubles the HP restored by held Berries.
- **Run Away** — guaranteed escape from wild battles; bypasses trapping
  abilities, Mean Look and wrap (Gen 8 behavior). Banner + "Got away
  safely!".
- **Infiltrator** — attacker ignores Reflect/Light Screen (damage calc),
  Safeguard (both check paths), and Substitute (damage + secondary
  effects go through). All hook sites share the same helpers.
- **Leaf Guard** — blocks slp/par/psn/brn/frz in sun; wired into the
  existing status-prevention lists with a sun gate.
- **Early Bird** — sleep counter ticks twice per turn (both sides'
  CheckTurn paths).
- **Unaware** — both directions in the damage cores: an Unaware attacker
  ignores the defender's Def/SpD stages (screens still apply); an
  Unaware defender makes the attacker use unboosted Atk/SpA. Also added
  to the evasion-ignore list (treated like Keen Eye: ignores raised
  evasion). Known edge: vs Psystrike the unboost uses SpD instead of Def.
- **Stench** — 10% flinch on any damaging hit; silent; doesn't stack
  with flinch-chance moves; Inner Focus blocks it.
- **Anticipation** — on entry, scans the foe's moves (OHKO effect or
  super-effective vs the holder's typing) and shudders.
- **Forewarn** — on entry, reveals the foe's highest-power move
  (first move if it only has status moves).
- **Pickpocket** — on contact, steals the attacker's item if the holder
  has none; respects Sticky Hold, mail, and Thief's link-battle rules;
  triggers Unburden bookkeeping.
- **Shield Dust** — defender-side suppression in the shared
  effect-chance path (also cancels 100% secondaries, canon).
- **Corrosion** — the Poison/Steel typing immunity check now lets a
  Corrosion attacker poison anyway (single choke point, all three
  poison paths).
- **Harvest** — end of turn, 50% (100% in sun) to restore the holder's
  eaten Berry (HP + status-heal berries), battle + party struct.
- **Download** — entry: compares the foe's raw Def vs SpD, raises Atk
  or SpA (ties → SpA).
- **Suction Cups** — blocks Roar/Whirlwind (forceswitch), with banner +
  "anchors itself!" text.
- **Sticky Hold** — blocks Thief, Knock Off and Pickpocket (Mold
  Breaker pierces it, canon).
- **Unburden** — doubles effective Speed (turn order) once the holder's
  item has been consumed or stolen/knocked off, while it holds nothing;
  resets on switch-out.
- **Klutz** — the holder's held item reports no effect through the
  central item getters (covers berries, healing items, Choice/Scarf,
  King's Rock, etc.); the item stays visible/stealable.
- **Cud Chew** — eats its HP Berry a second time at the end of the next
  turn (banner + heal).
- **Supersweet Syrup** — entry: lowers the foe's evasion (Intimidate
  pattern). Note: canon is once per battle; here it procs on every
  entry like Intimidate.
- **Heavy Metal / Light Metal** — data-only flavor: this engine has no
  weight mechanics (Low Kick/Heat Crash are fixed-power here).

## Assignment notes / deviations from the sheet

- **Grumpig** — Part 1 filled its last slot with PRANKSTER, so the
  sheet's Gluttony had nowhere to go. Spoink got Gluttony as hidden;
  Grumpig kept Thick Fat/Own Tempo/Prankster.
- **Sneasel** — Part 1 filled its hidden with KEEN_EYE, so no room for
  Pickpocket (Weavile got it).
- **Paldean Tauros (fire/water)** — full after Part 1 (Intimidate/Anger
  Point/Reckless); Cud Chew went to Farigiraf only.
- **Appletun** — restored to canon Ripen/Gluttony/Thick Fat, so the
  sheet's Harvest mention no longer applies (its old slot-1 Harvest
  placeholder is gone; Exeggutor line + Alolan carry Harvest).
- Canon sets were restored where the sheet wanted multiple abilities on
  one mon (flavor substitutes replaced): Applin line, Buneary
  (Run Away/Klutz/Limber), Eevee (Run Away/Adaptability/Anticipation),
  Doduo/Dodrio (Run Away/Early Bird/Tangled Feet), Galarian Ponyta line
  (Run Away/Pastel Veil/Anticipation), Leafeon (Leaf Guard/—/
  Chlorophyll), Salandit line (Corrosion replaces Poison Touch),
  Duraludon (Light Metal/Heavy Metal/Steadfast), Grimer/Muk
  (Stench/Sticky Hold/Poison Touch).

## Engine/bank bookkeeping

- New WRAM: 4 bytes in WRAM bank 2 (`wPlayer/wEnemyItemStateFlags`,
  `wPlayer/wEnemyConsumedItem`) — consumed/lost item tracking for
  Gluttony/Harvest/Cud Chew/Unburden/Pickpocket. WRAM0 is full; access
  goes through rSVBK-safe helpers in abilities_engine. Cleared at battle
  start and on each side's switch-in.
- Effect Commands bank: net NEGATIVE (relocated CheckIfTargetIsPoisonType,
  SafeCheckSafeguard, CheckSubstituteOpp, GetUserItem/GetOpponentItem
  bodies into the Abilities Engine bank) — 14 bytes free after all hooks.
- Battle Core: 119 bytes free. Abilities Engine section grew ~1.5 KB
  (floating section, plenty of room). Two `jr → jp` conversions in the
  damage cores for range.
- `ConsumeHeldItem` now records what was eaten (single choke point).
- Thief and Knock Off gained Sticky Hold gates + Unburden bookkeeping.

## Still orphaned / for a future session

`BERSERK`, `POISON_PUPPETEER`, `WIND_RIDER`, `MEGA_SOL` remain
unassigned (the sheet only *suggests* homes — say the word and they're
one-line edits). The AI has no awareness of the 23 new abilities (same
as previous batches). Empty ability slots are now roughly 60, down from
205.

## Suggested test checklist

- Wild battles: Porygon (Download banner + Atk/SpA raise), Jynx
  (Forewarn reveals a move), Croagunk (Anticipation shudder vs a mon
  with a super-effective move), Dipplin (Supersweet Syrup evasion drop).
- Give a mon a BERRY: normal mon eats below 1/2; Gluttony (Shuckle)
  below 3/4; Ripen (Applin) heals 20 not 10; Cud Chew (Farigiraf) heals
  again next turn; Harvest (Exeggutor) may regrow it; Unburden
  (Hitmonlee) outspeeds after eating; Klutz (Golett) never eats it.
- Thief/Knock Off vs Grimer (Sticky Hold blocks, banner); contact hit
  on itemless Weavile (Pickpocket steals).
- Sleep a Doduo (wakes in half the turns); Roar at Octillery (fails,
  "anchors itself!"); flee from anything with Sentret (always escapes).
- Reflect up, hit with Zubat (Infiltrator ignores it); Substitute up,
  hit with Dreepy (damage goes through).
- Growl spam vs Quagsire/Clodsire (Unaware ignores your Atk drops when
  it attacks... i.e. its own damage taken ignores your boosts —
  Swords Dance vs Unaware is the cleaner test).
- Sunny Day + try to burn Tangela (Leaf Guard blocks); Salandit Toxic
  vs a Steel-type (poisons through, Corrosion).
