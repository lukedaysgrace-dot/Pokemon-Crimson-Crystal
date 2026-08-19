# Trainer AI × the 2026-08-14 ability batch — 2026-08-19 session

The 21 battle-relevant abilities from the `ABILITY_WORKLIST` batch
(Gluttony, Run Away, Infiltrator, Leaf Guard, Early Bird, Unaware,
Stench, Anticipation, Pickpocket, Shield Dust, Corrosion, Harvest,
Download, Suction Cups, Sticky Hold, Unburden, Klutz, Ripen, Cud Chew,
Forewarn, Supersweet Syrup) are now factored into trainer move scoring,
the same way the earlier abilities were. Heavy/Light Metal stay
data-only (no weight mechanics in this engine).

**Build verified with rgbds 0.5.2, release + debug. Battle tester:
353/353 green** — the full pre-existing suite plus the new
`48-ai-new-abilities.yaml` (37 cases, every rule below with a paired
control). One pre-existing, unrelated red: "Klutz suppresses Smoke Ball
escape" times out during fixture boot on this checkout even at the
previous commit (emulator-side flake, not a scoring regression).

## What the AI now knows

All player-ability reads go through `GetOppIgnorableAbility`, so Mold
Breaker piercing and Neutralizing Gas suppression are respected
automatically; "our" ability reads use `GetEnemyAbilityEffective`.

### AI_Basic / AI_Smart_* (every AI_SMART class)
- **Infiltrator (ours)**: Safeguard's "already active" dismissal is
  skipped — our status moves ignore the player's Safeguard anyway.
- **Infiltrator (player's)**: Reflect, Light Screen, Substitute and
  Safeguard are dismissed — the player attacks straight through them.
- **Unaware (ours)**: Haze-style reset is only worth using for the
  player's Speed/accuracy/evasion boosts; Atk/Def/SpA/SpD boosts are
  ignored both ways already.
- **Shield Dust (player's)**: Icy Wind loses its Speed-drop bonus;
  Fake Out loses its flinch bonus (Inner Focus also checked there).
- **Corrosion (ours)**: Toxic/poison moves are no longer dismissed
  against Poison- or Steel-typed players (both the AI_Status layer and
  the AI_Types immunity dismissal).
- **Sticky Hold (player's)**: Knock Off loses its held-item bonus.
- **Unburden (player's)**: Knock Off is discouraged — stripping the
  item doubles their Speed.
- **Gluttony/Ripen/Harvest/Cud Chew (player's)**: Knock Off gets an
  extra nudge when the player is actually holding a Berry (checked via
  `GetItemHeldEffect` = HELD_BERRY).
- **Suction Cups (player's)**: Circle Throw/Dragon Tail lose their
  hazard-phazing bonus.

### AI_Abilities layer (AI_ABILITIES classes)
- **Suction Cups (player's)**: Roar/Whirlwind are dismissed outright
  (+30).
- **Infiltrator (ours)**: the "Substitute blocks status" discouragement
  is skipped.
- **Klutz (player's)**: a held Rocky Helmet stops deterring our contact
  moves.
- **Pickpocket (player's)**: contact moves are mildly discouraged when
  the player is empty-handed and we hold an item (they'd steal it);
  no fear when either side's hands make the steal impossible.

### AI_Elite layer (boss trainers)
- **Early Bird (player's)**: sleep moves are discouraged (+2), not
  dismissed — half-length sleep is still sleep.
- **Leaf Guard** was already elite-checked (sun gate) from the batch
  implementation; unchanged.
- **Unaware (player's)**: pure Atk/Def/SpA/SpD/evasion setup (Swords
  Dance, Bulk Up, Calm Mind, Curse as a non-Ghost, Belly Drum,
  Minimize, ...) is dismissed; mixed boosts that also raise Speed
  (Dragon Dance, Shell Smash, Quiver Dance) are only discouraged (+3),
  and pure Speed/accuracy raises (Agility, Hone Claws' accuracy is
  Atk+acc so it's dismissed) are untouched.
- **Klutz (player's)**: a full-HP Focus Sash no longer denies our KOs
  (`AIElitePlayerDeniesKO`) — OHKO moves, Explosion and the universal
  KO layer all go straight through a Klutz'd Sash. Sturdy is now
  checked via the effective ability (Mold Breaker pierces it), and it
  is checked before the item, matching the engine's endure order.

### No AI change (by design)
- **Run Away, Stench, Anticipation, Forewarn, Download, Supersweet
  Syrup**: escape/entry effects with no per-turn move-choice
  consequence the AI could exploit. (Wild mons don't run the scoring
  layers, and the entry effects already fired by the time moves are
  scored.)
- **Leaf Guard, Corrosion vs elite status moves** were already handled
  when the abilities landed; this session's work is the layers that
  had no awareness.

## Engine fixes that fell out

- **`AIGetPlayerAbilityEffective` (new helper, and the `_b` wrappers
  everywhere)**: three pre-existing call sites in AI_Abilities
  (`Damp`, `Magic Bounce`, the contact-ability check) farcalled
  `GetPlayerAbilityEffective` directly. `ReturnFarCall` only preserves
  the *flags* through the bank restore — `a` comes back as the saved
  `c` — so all three were comparing garbage and the checks silently
  never fired. They now route through the `_b` wrappers like the elite
  layer always did. (Found because the new Infiltrator/Klutz checks
  built the same way failed their paired controls in the tester.)
- **AI move tie-break no longer re-rolls**: `AIChooseMove`'s final
  pick looped `Random & 3` until it hit a candidate, which spins
  forever under the battle tester's forced-RNG modes whenever slot 1
  was not a candidate. It now counts the candidates and picks the
  n-th with a single roll — same uniform distribution, no reroll loop.
- **AI percent-rolls now use `BattleRandom`**: every `call Random` in
  the AI scoring/item layers (AI_50_50, AI_80_20, `cp N percent`
  gates) became `call BattleRandom`. Outside link battles that resolves
  to the identical hardware RNG, but it makes AI choice controllable by
  the tester's forced/seeded modes (and would keep link-AI in sync if
  that ever mattered).

## Battle tester upgrades (tools/battletest)

- **`enemy_class:`** test field — trainer battles can name a real
  trainer class (e.g. `FALKNER`) instead of the SCHOOLBOY shell, so
  AI_SMART/AI_ABILITIES/AI_ELITE scoring actually runs. New WRAM byte
  `wDebugEnemyClass` (0 = SCHOOLBOY as before); parties are still
  replaced from the request.
- **`enemy_move()`** assertion helper — the move the AI picked last
  turn (`wCurEnemyMove`, converted through the move-index table).
- Trainer-class constants parsed from `trainer_constants.asm`
  (`Constants.trainer_classes`).
- `48-ai-new-abilities.yaml`: 37 paired control/behavior cases. Every
  player mon carries `substatus: [CANT_RUN]` so the switch heuristics
  never preempt the move choice being tested; ties are built around
  slot 1 (forced RNG breaks ties toward the lowest slot).

## Bank bookkeeping

"Enemy Trainers" grew to $2897; the linker paired it with "Ability
Descriptions" ($1735) in bank $0e, leaving $34 bytes free there — tight
but floating sections relocate automatically, so the next growth just
moves a section to another bank. Nothing was displaced this session.
