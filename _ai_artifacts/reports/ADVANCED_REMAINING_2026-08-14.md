# What's Left That's Actually "Advanced" — 2026-08-14

Audit basis: working tree at `357bb5e` ("elite ai put in for special trainers"),
clean, matches origin. Three parallel deep passes over the battle engine, the AI /
trainer data, and the overworld / content systems. Everything below was checked
against source with file:line evidence — nothing here is a repeat of something you
already shipped.

---

## Bottom line

You are **past the point where more advanced features are the bottleneck.** The
engine is now genuinely ahead of most finished Gen-2 hacks: 172 abilities all with
real hooks (no data-only stubs left — I checked all 172), 414 moves, elite AI tier,
Frostbite instead of Freeze, ability-aware switching, modern multi-hit, Sturdy,
Mold Breaker, Neutralizing Gas.

There are exactly **four** things left that genuinely need a strong model, and one
of them is a now-or-never structural decision. Everything else on the list is
either a one-line fix or grind work that a cheaper model (or you, by hand) can do
after Fable 5 is gone.

So: mostly call it good — but not before you do the four.

---

## First: three things that are outright wrong (fix regardless, ~1 hour total)

**1. Shiny rate is 10%.**
`constants/pokemon_data_constants.asm:126` — `SHINY_PROBABILITY EQU 10 percent`.
That's a debug value. One in ten wild Pokémon is shiny right now. Your shiny system
is otherwise excellent (real flag byte at `MON_SHINY_FLAG`, decoupled from DVs,
trainer mons correctly shiny-locked) — the rate just never got turned back down.
One constant.

**2. The Pokédex AREA map lies about Raikou and Suicune.**
`maps/BurnedTowerB1F.asm:91` still runs `special InitRoamMons`, which writes
Raikou→Route 42 and Suicune→Route 37 into the roam structs. You disabled roam
*battles* (`engine/overworld/wildmons.asm:592-594`) and made them statics
(Lake of Rage, Tohjo Falls), but `Pokedex_GetArea` still reads those structs. A
player checking AREA gets sent to the wrong route. Delete one line.

**3. Lunge is a priority move.**
`data/moves/moves.asm:305` gives Lunge `EFFECT_PRIORITY_HIT`. It isn't a priority
move in any generation. Same table: Extreme Speed is +1 instead of +2
(`moves.asm:265`), and Trick Room is priority −1 instead of −7
(`data/moves/effects_priorities.asm:12`).

---

## The real gap isn't a feature — it's that the data never caught up

This is worth saying plainly because it changes how you should spend the remaining
weeks.

| | |
|---|---|
| Trainer parties total | 620 (1,722 mon slots) |
| **Using the ability byte you built** | **0 (0.0%)** |
| `TRAINERTYPE_NORMAL` — no items, no moves | 386 (62%) |
| Parties with custom movesets | 202 (33%) |
| Parties with a held item | 168 (27%) |
| Trainer classes carrying AI bag items | 18 of 84 |
| X-items in the entire game | 1 (a Dire Hit on Janine) |

You shipped `TRAINERTYPE_ABILITY` on 2026-08-13 and it works — the Battle Tower
already uses it correctly (`data/battle_tower/parties.asm:26`). But **not one of
the 620 main-game parties has an ability byte.** So `AI_Elite` is reasoning
carefully about *your* ability while its own mon rolls a default.

And five parties that carry the full `AI_ELITE` stack are raw `TRAINERTYPE_NORMAL`
— level 70-80 bosses with default level-up movesets and no items:
Agatha (`parties.asm:7343`), Lorelei (`:7362`), Red2 (`:7381`),
Blue Cloak (`:7400`), Green (`:7419`). Rival1's first six parties too
(`:393-431`).

**This is the single highest-value work left in the project, and it does not need
an advanced model.** It needs someone to write good teams. Mentioning it here so
you don't spend the Fable 5 window on it.

---

## Tier A — the four things worth spending the strong model on

### A1. Item ID space is nearly exhausted — decide now or never

`constants/item_constants.asm:200-213`: only **`ITEM_C3` and `ITEM_FA` are free**
before the TM block starts at $C2. Realistically ~6 usable IDs left (some
reclaimable from the four unused Gen-2 berries).

Currently **absent**: Heavy-Duty Boots, all four weather rocks, Light Clay, every
modern berry (Sitrus etc. — you only have the five Gen-2 ones), Black Sludge,
Shell Bell, Big Root, Safety Goggles, Eject Button, Red Card, White/Power/Mental
Herb, Wide Lens, Grip Claw, Covert Cloak, Utility Umbrella, Throat Spray.

You have three hazard types and no Heavy-Duty Boots; you have weather and no
rocks to extend it. Those are real team-building levers you're missing.

Two paths, and the choice is basically permanent:

- **Cheap:** pick ~6 (HDB, the four rocks, Black Sludge or Sitrus) and stop
  forever. Each is a small hook — the rocks are one setter (`rain_dance.asm:5-6`,
  5→8 turns), HDB is the two spots the Air Balloon spikes fix already touched,
  Black Sludge clones `HandleLeftovers`.
- **Structural:** widen item IDs. Touches the pack, marts, save format, mail,
  every `db ITEM_` site. This is exactly the kind of wide, correctness-critical
  refactor worth a strong model — and it's not something you'd want to attempt
  later with a weaker one.

**My read: do the cheap path, unless you know you want 20+ modern items.** Six
well-chosen items buy most of the design value.

### A2. Battle math is still on Gen 2/3 numbers in six places

These are individually small but they're cross-cutting, correctness-critical, and
your 841-case harness can verify all of them — the ideal strong-model batch.

| | Current | Modern | Evidence |
|---|---|---|---|
| Paralysis speed | **25%** (two `srl/rr` pairs) | 50% | `core.asm:6901-6942` |
| Sleep duration | 2-7 counter (1-6 missed turns) | 1-3 | `effect_commands.asm:3710-3720` |
| Crit multiplier | **×2** | ×1.5 | `effect_commands.asm:3206-3227` |
| Crit stage table | 7/12.5/25/33/50% | 1/24, 1/8, 1/2, 1/1 | `data/battle/critical_hit_chances.asm` |
| Toxic on switch-out | **downgrades to normal poison** | stays badly-poisoned, counter resets | `core.asm:4297-4308` |
| Berry timing | end-of-turn only | fires post-damage | `core.asm:4487-4528` |

Plus: Encore is 3-6 turns (canon 3), Disable is 1-7 (canon 4), Protect halves its
success rate per use instead of thirding it and wrongly fails behind a Substitute
(`move_effects/protect.asm:31-52`), and crits use the Gen 1/2 both-sides
stage-ignore rule instead of the modern per-side one
(`effect_commands_core.asm:2536-2585`).

Also note **Dire Claw already uses the modern 1-3 sleep roll**
(`effect_commands_core.asm:332-337`) while everything else uses 2-7 — the two
paths disagree today.

Paralysis at 25% and crits at ×2 in particular are silently making your whole
difficulty curve swingier than you think.

### A3. AI item usage — the last big AI hole

`engine/battle/ai/items.asm` is essentially untouched vanilla, and it's structurally
hobbled:

- **`.IsHighestLevel` gate** (`items.asm:250-279`) — the AI refuses to use any item
  unless the active mon is the party's highest level. On a level-tied gym team,
  effectively one mon can ever be healed.
- **Pure HP thresholds, zero damage prediction** (`items.asm:354-388`).
  `AIDamageCalc` exists at `scoring.asm:3143` and is never called from items.asm —
  so the AI heals into a KO constantly.
- **X-items fire on turn 0 or never** (`items.asm:496-520`), with no check of
  whether the stat is relevant, already boosted, or whether it outspeeds.
- **Status heals have no relevance test** — it'll burn a full heal on a burn on a
  special attacker.
- **Item table is Gen-2 only** — 13 items, no Revive, no berries.
- **Hard mode disables AI items entirely** (`items.asm:158-163`). Your hardest
  mode gives the AI *less*. Worth confirming that's deliberate.
- **Battle Tower disables them too** (`items.asm:165-168`) — tower bosses never heal.

An `AI_EliteItems` gate that drops the highest-level check, calls `AIDamageCalc`
against the player's revealed moves before healing, and scores X-items against its
own attacking split would be the largest felt difficulty jump left in the game.
Every primitive it needs already exists in the right bank.

### A4. AI is blind to the 23 abilities you just added, and to hazards

Two concrete holes:

**Hazard-blind switching.** `engine/battle/ai/switch.asm` contains *zero*
references to Spikes / Toxic Spikes / Stealth Rock / screens. The AI will pivot a
4× Rock-weak mon into its own Stealth Rock over and over, and Roar/Whirlwind
(`scoring.asm:966`) gets no hazard-pressure bonus even though the offensive-side
handlers for setting hazards exist.

**New abilities have no AI reasoning.** Of the 23 shipped on 08-14, only Leaf Guard
and Corrosion are known to the AI. Missing, roughly in value order:

- **Suction Cups** — `AI_Smart_ForceSwitch` still Roars into it
- **Sticky Hold** — Knock Off is still *encouraged* into it (`scoring.asm:1718`)
- **Shield Dust** — every secondary-effect handler still values the secondary
- **Unaware** — AI keeps stacking Swords Dance into an Unaware wall
- **Infiltrator** — `AI_Abilities` still discourages status moves behind a
  Substitute even when the AI mon has Infiltrator (`scoring.asm:3866`)
- **Anticipation / Forewarn** — no use at all, and these are precisely
  "AI legally gets extra information" abilities, which fits your elite tier
- Bench-mon abilities (Intimidate, Regenerator, Sturdy) never affect post-KO
  switch-in choice (`switch.asm:916`)

Also a small real bug worth folding in: `FindEnemyMonsWithASuperEffectiveMove`
(`switch.asm:628-731`) doesn't reset `e` per bench mon, so the neutral-coverage
candidate set over-fills — and that now feeds `AIPickPostKOSwitchIn`, so it's
affecting boss post-KO replacements, not just the old path.

---

## Tier B — advanced, defensible, but I'd only do these if A is done

- **Move priority as a real struct byte.** Priority is currently derived from the
  move *effect* via a 13-entry table (`core.asm:905-940`). That's why Extreme Speed
  is wrong and why Sucker Punch has no fail-if-target-isn't-attacking condition.
  A real `MOVE_PRIORITY` byte is 414 rows plus every `GetMoveData` consumer —
  clean strong-model work, but the individual fixes in A-tier get you 80% of it.
- **Taunt / Torment / Yawn / Magic Coat / Wish.** All absent. `SubStatus2` bits
  1-7 and two `SubStatus5` bits are free, so these are cheap-ish — but each needs
  a counter byte in WRAM bank 2 (WRAM0 is full).
- **Sticky Web + Spikes layers.** Spikes is one layer only
  (`move_effects/spikes.asm:13-18`). `SCREENS_UNUSED` is the one free bit — enough
  for Sticky Web *or* a second Spikes layer, not both, without new WRAM.
- **Protean / Libero.** The notable competitive ability omissions. Needs a
  once-per-switch-in flag; free `SubStatus2` bits cover it.
- **Terrains.** Absent entirely. Honestly: in a singles-only game, terrain adds
  less than it costs. I'd skip it, same as your earlier doc concluded.

---

## Call it good on these

- **Natures, modern EVs/IVs** — party struct is full, save-format break. Correctly
  ruled out before; still correct.
- **Mega Evolution / Z-moves / Dynamax / Tera** — structural, weeks each.
- **Double battles** — `hBattleTurn` is a 1-bit player/enemy flag used everywhere.
  Full engine rewrite.
- **Follower Pokémon** — your own `OUTDOOR_SPRITE_VRAM_AUDIT.md` already explains
  why. Decline.
- **More abilities.** All 172 have real hooks. The only meaningful omissions are
  Protean/Libero; everything else left is doubles-only or flavor.
- **DV display on the stats screen.** Moot — see the note below.

---

## Two things you should write down before you forget them

**Every player mon has perfect DVs.** `engine/pokemon/move_mon.asm:210-212` and
`:283-291` force `$FF/$FF` for PARTYMON. Consequences: (a) a DV readout would show
15/15/15/15 for everything, so drop that idea; (b) **Hidden Power is a single fixed
type and power for every player mon in the game** — which makes the Hidden Power
guy at Lake of Rage load-bearing, and he should probably be signposted; (c) the 50
lines of DV inheritance in `engine/events/daycare.asm:711-762` are dead code,
overwritten three instructions later at `:787`.

**Doc drift:** `ABILITY_WORKLIST_RESULTS_2026-08-14.md` says `NUM_ABILITIES` is 174
with Heavy Metal and Light Metal added. It's 172 and neither constant exists — the
two flavor-only abilities were dropped. All four parallel tables are correctly
aligned at 172 rows, and Duraludon has canon Clear Body / Stamina / Steadfast, so
nothing is broken. Just fix the doc.

---

## Suggested use of the remaining Fable 5 weeks

1. **The three bugs** (shiny rate, roam AREA, Lunge/Extreme Speed priority) — an hour.
2. **A2 battle math pack** — one focused session, harness-verified. Biggest
   correctness win per hour in the project.
3. **A3 elite item AI** — biggest *felt* difficulty win.
4. **A1 item decision** — pick the six items, or commit to widening IDs. Don't
   leave this undecided; it gets much more expensive later.
5. **A4 AI ability + hazard awareness** — finishes the elite tier properly.

That's a realistic two weeks and it leaves the project in a state where everything
remaining is data work you can do at your own pace: 620 trainer parties, ability
bytes on the ones that matter, and the five naked boss teams.

### Cheap non-advanced wins to hand to a lesser model afterward

Running shoes / B-to-run (still absent), INSTANT text speed, hard-mode readout on
the trainer card, bag pocket sizes, SELECT item ring, party-menu HEAL, move
reminder moved out of Blackthorn, Safari Zone interior (the map, tables and gating
exist — it has zero objects in it), gym leader phone rematches, Shiny Charm as a
dex-completion reward, and the empty `README.md`.

Also worth knowing: your dex is **513 of 514 species obtainable**. The only one
that isn't is Mew. That's a remarkable result and belongs in the README.
