# Crimson Crystal — QoL & Feature Ideas (August 2026)

Audit basis: `github.com/lukedaysgrace-dot/Pokemon-Crimson-Crystal` @ `989565f`. Everything below was
checked against source; each item is marked PRESENT / ABSENT with file:line evidence so nothing here
duplicates work you've already done.

## Where the project actually stands

Already done, and done well: physical/special split (`data/moves/moves.asm:3-11`), 414 moves / 217
effects, 151 abilities with hidden-ability slots and an ability-flag system, ~194 items including the
full modern held-item suite (Life Orb, Choice trio, Eviolite, Focus Sash, Assault Vest, Rocky Helmet,
Air Balloon, Loaded Dice), Fairy type, entry hazards incl. Stealth Rock + Toxic Spikes layers,
pivot moves with switch-out abilities, priority table with Prankster/Gale Wings/Triage, weather with
suppression, Polished-Crystal move info box, 4-page stats screen with ability + met data + friendship,
move reminder + egg move tutor, field-HM-without-the-move-slot system, Pokégear fly, skateboard,
repel re-prompt, hard mode with badge-gated level caps, 60fps, smooth fades, a debug battle tester
harness, and an audit tool suite in `tools/`.

That's a more complete engine than most finished hacks. The gaps below are what's left.

---

## Tier 0 — Do these BEFORE writing trainer teams

These change data formats or balance. Doing them after you've written 700 parties means redoing work.

### 1. Trainer Pokémon can't have a chosen ability — this is the big one

`engine/battle/core.asm:6653-6675` pulls a trainer mon's ability from `wOTPartyMon1Personality`, and
`engine/battle/read_trainer_party.asm` never writes that byte. Personality stays 0, so **every trainer
Pokémon in the game silently gets its slot-1 ability.**

You built 151 abilities and are about to write hundreds of teams around them. Right now you cannot
give a Gyarados Moxie, a Blissey Natural Cure, or any leader's ace a slot-2 or hidden ability. Every
"clever" team you write gets flattened to ability 1.

Fix: add an ability-slot byte to the party format. Cleanest is a new
`TRAINERTYPE_ITEM_MOVES_ABILITY` (or a `TRAINERTYPE_ABILITY` bit) parsed in `read_trainer_party.asm`
that writes `ABILITY_1`/`ABILITY_2`/`HIDDEN_ABILITY` into the OT mon's personality byte. Existing
party entries keep working unchanged; you only opt in where it matters (leaders, E4, rivals). Ballpark
a day's work, and it makes every hour you spend on trainer teams count for more.

### 2. Wild hidden abilities are unreachable

`core.asm:6664-6672` rolls wild ability as a 50/50 between slot 1 and slot 2 — `HIDDEN_ABILITY` is
never rolled. The only way a player ever sees one is the ABILITY CAP key item
(`abilities_engine.asm:4320`), which cycles 1 → 2 → hidden.

If that's intentional (hidden abilities as an ABILITY CAP reward), fine — but say so in-game, because
right now nothing tells the player. If not, a small roll (say 1/64, or a flat chance on Safari/Park
Ball catches, or post-Hall-of-Fame) gives the dex some late-game texture for ~15 lines of code.

### 3. Type chart is still Gen 5 in two cells

`data/types/type_matchups.asm:99` has `GHOST → STEEL` not-very-effective and `:108` has
`DARK → STEEL` not-very-effective. Both became neutral in Gen 6, and you've already gone Gen 6 with
Fairy. Two-line fix, but it changes how every Steel-type trainer mon plays — so do it before you tune
teams, not after.

### 4. The AI is completely blind to abilities and held items

Zero occurrences of `abil` or `HELD_` in `engine/battle/ai/scoring.asm`, `move.asm`, `switch.asm`, or
`redundant.asm`. The AI will click Earthquake into Levitate, Flamethrower into Flash Fire, and
Thunderbolt into Volt Absorb. It doesn't know a Choice item locks it, doesn't respect Focus Sash, and
doesn't know Rocky Helmet punishes contact.

This is the single highest-value change on the list, because it multiplies the value of every trainer
team you're about to write. You don't need a full rewrite — a minimal veto layer gets 80% of it:

- Score a move to zero if the target's ability nullifies it (Levitate, Flash Fire, Water/Volt Absorb,
  Dry Skin, Sap Sipper, Lightning Rod, Storm Drain, Motor Drive, Bulletproof, Soundproof).
- Discourage contact moves into Rocky Helmet / Iron Barbs / Rough Skin / Static / Flame Body.
- Discourage status moves into Magic Bounce / Substitute-behind targets.
- Track Choice lock so the AI stops trying to switch moves.

Slot it in as a new `AI_Abilities` layer after `AI_Basic` and give it to the trainer classes that
deserve it via `TRNATTR_AI_MOVE_WEIGHTS` — that way route trainers stay dumb and leaders feel sharp.

### 5. AI_Smart covers 83 of 217 move effects

Everything you added from Gen 4-9 has no AI entry: Stealth Rock, Toxic Spikes, Defog, U-turn / Volt
Switch / Flip Turn, Shell Smash, Nasty Plot, Trick Room, Knock Off, Body Press, Foul Play,
Freeze-Dry. The AI treats them as generic damage or generic status.

If you're going to give Falkner's Skarmory Spikes (you already do —
`data/trainers/parties.asm`, FALKNER2), the AI should know to set them on turn 1 and not on turn 5.
Even 15-20 new `dbw EFFECT_` entries for the effects you actually distribute to leaders would be a
visible difficulty jump. Pair this with #4 and the endgame feels like a different game.

---

## Tier 1 — Cheap QoL with outsized felt impact

### 6. Running shoes / hold-B to run

ABSENT — `engine/overworld/player_movement.asm` has no B-button check; speed selection is bike/
skateboard only (`:280-297`, `:721-725`), and both are gated to outdoor/CAVE/GATE
(`engine/events/overworld.asm:1760-1768`, `:1901-1913`).

This is the number one thing players notice in a Gen 2 hack. It's also small: reuse `STEP_BIKE`
timing on a B-held check, allow it indoors. Consider also letting the skateboard work indoors — the
gate is the same environment check, and it's your signature item.

### 7. Instant text speed

`constants/wram_constants.asm:37-39` has FAST/MED/SLOW as delay 1/3/5. A delay-0 "INSTANT" entry is a
handful of lines in `engine/menus/options_menu.asm:170-186`. For a hack people will replay, this is
free goodwill.

### 8. Reusable TMs

`engine/items/tmhm.asm:155` calls `ConsumeTM`; `:526-545` decrements the count. With 50 TMs and a
510-mon dex, consumable TMs mean players hoard them and never use them — which quietly wastes the
whole movepool you built. Deleting the `ConsumeTM` call (keeping HM behavior, which is already
exempted at `:150-151`) is nearly a one-line change and materially changes how players engage with
team building. High confidence this is the best effort-to-payoff ratio on the list.

### 9. Bag pockets are still 40 / 12 / 25

`constants/item_data_constants.asm:43-46`: `MAX_ITEMS 40`, `MAX_BALLS 12`, `MAX_KEY_ITEMS 25`. You've
added ~60 items over vanilla including apricorn balls, orbs, and a growing key-item set (skateboard,
ability cap). Bumping these needs an SRAM layout check but is otherwise mechanical. Item sorting
(`Sort` appears nowhere in `engine/`) is a nice second step.

### 10. Only one item can be registered to SELECT

`engine/overworld/select_menu.asm:1-172`, single slot `wRegisteredItem` (`wram.asm:2646-2647`). With
bike + skateboard + itemfinder + repel all competing, a 2-4 slot ring (SELECT cycles, or
SELECT-hold opens a small picker) is a real improvement and is self-contained.

### 11. Heal from the party menu

Party submenu is vanilla (`constants/menu_constants.asm:44-71`): STATS / SWITCH / ITEM / CANCEL /
MOVE / MAIL. Adding a HEAL action that uses the best applicable item saves a lot of menu diving.
Lower priority than the above, but cheap.

---

## Tier 2 — Depth that's cheap given what you already built

### 12. Gym Leader rematches exist but aren't repeatable or discoverable

You built 9 rematch flags (`constants/event_flags.asm:277-285`) and rematch parties across 16 maps
(`maps/VioletGym.asm:50-63` etc.), gated on `EVENT_BEAT_BLUE`. But they're **one-time in-gym
challenges with no phone hook** — the vanilla daily rematch scheduler (`wDailyRematchFlags`,
`wram.asm:2866`) only serves ordinary trainers.

The hard part (the teams) is done. Wiring leaders into the phone rematch system so they call you and
the fight repeats daily turns a one-off into your whole postgame. Best value-per-hour in Tier 2.

### 13. Weather-extender items and Heavy-Duty Boots

Weather is hardcoded to 5 turns (`engine/battle/move_effects/rain_dance.asm:5-6`) and Damp/Heat/
Smooth/Icy Rock aren't present. Heavy-Duty Boots is also absent — and you have three hazard types.
Adding four rocks plus Boots is ~5 item entries and small effect hooks, and it gives you real levers
for building distinct leader teams. Also missing: any Gen 3+ berry (Sitrus etc.) and Black Sludge.

### 14. Surface DVs on the stats screen

You have a 4-page stats screen with room and DVs are already read for Hidden Power
(`engine/pokemon/stats_screen.asm:752-758`). A judge-style readout (or raw DV bars) on the orange
page is a small addition players love. Note the Gen 2 DV structure means SpAtk and SpDef share one
DV despite you having split them — worth a line of documentation somewhere.

### 15. Options menu doesn't reflect the game you've built

`engine/menus/options_menu.asm:57-96` is fully vanilla: 7 options + Cancel. Hard mode is only
settable at new game (`engine/menus/init_gender.asm:90-100`). Worth considering: INSTANT text, a run
toggle, and either surfacing difficulty or at least a way to check which mode you're in mid-run.

---

## Tier 3 — Tooling to make the remaining work faster

You already have `tools/audit_trainers.py` and `tools/audit_game_data.py`, plus the battle tester
harness. Two extensions would pay for themselves given 7,500 lines of parties left to tune:

### 16. Moveset legality + level-cap linting in `audit_trainers.py`

The current version validates references, class tables, and Battle Tower data. Add: every move on a
trainer mon is actually learnable by that species at that level (level-up / TM / egg / tutor), the
ability slot is valid for the species (once #1 lands), levels respect the hard-mode cap for that
badge count (`HardModeLevelCaps`, `engine/pokemon/experience.asm:41-90`), and held items aren't
duplicated within a party or given to mons that can't use them. This catches the exact class of bug
that's invisible until someone plays the fight.

### 17. Wild encounter coverage report

A script over `data/wild/*.asm` that emits: every species, whether it's obtainable at all, where, at
what levels, plus a per-route type distribution and level curve. With ~510 species this is the only
way to avoid shipping with 40 unobtainable mons or a route where everything is Normal-type. Turns
encounter tables from guesswork into filling gaps in a table.

### 18. Point the battle tester at leader teams

You built a 74/74-green harness. Once #1 and #4 land, running each gym leader team through it against
a plausible player party would catch soft-locks and ability interactions before a human ever plays it.

---

## Tier 4 — Release polish

### 19. README.md is empty (1 byte)

For a project this size that's the first thing anyone sees. A feature list, screenshots, a changelog,
and credits (the Polished Crystal / pokeorange / Luminescent ports especially) matter for how the
hack lands. You have material for it already in `_ai_artifacts/reports/`.

### 20. Repo weight

`_to_delete/` is 78 MB and partly tracked (20 files), `pokemon stuff i need/` is 6.3 MB, plus
`need animated sprites/` and `new front sprites lazarus/`. A cleanup pass before you tag a release
makes the repo clonable and the history legible.

---

## The expensive ones — probably say no

- **Natures**: the personality byte is fully allocated (ability slot bits 5-6, caught ball bits 0-4,
  `constants/pokemon_data_constants.asm:41-48`). You'd need a new mon-struct byte, which touches
  save format, PC boxes, trading, and every party routine. Not worth it this late.
- **Modern EVs/IVs**: `macros/wram.asm:13-19` is vanilla stat exp (2-byte per stat) and 4-bit DVs.
  Same save-format problem. Stat exp works fine for a single-player hack.
- **Double battles**: no battle-type slot exists (`constants/battle_constants.asm:94-106`) and
  targeting is 1v1 throughout. Weeks of work.
- **Terrain**: not present anywhere. Fine to skip — you have weather, and terrain without doubles
  adds less than it costs.

---

## If you only do five things

1. Trainer ability slots (#1) — unblocks everything you're about to write.
2. AI ability/item awareness (#4) — makes every team you write matter.
3. Reusable TMs (#8) — one line, huge change in how players engage.
4. Running shoes (#6) — the thing players notice first.
5. Gym leader phone rematches (#12) — turns finished content into a postgame.

Items 1, 4, and 5 are the ones that specifically make your remaining trainer-team work pay off, which
is why they lead. 3 and 6 are nearly free.
