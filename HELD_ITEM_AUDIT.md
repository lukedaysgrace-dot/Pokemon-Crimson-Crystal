# Held Item Audit — July 2026

Scope: all post-Crystal held items (Choice Band/Specs/Scarf, Assault Vest, Eviolite,
Focus Sash, Expert Belt, Rocky Helmet, Life Orb, Weakness Policy, Air Balloon,
Muscle Band, Wise Glasses, Loaded Dice), plus new items Flame Orb / Toxic Orb.

## Verified correct (no changes)

- **Choice Band / Specs** — x1.5 physical/special damage in `ApplyHeldItemDamageModifiers`;
  lock set on selection, cleared on switch-in (`NewBattleMonStatus` / `NewEnemyMonStatus`)
  and when the held item stops being a Choice item. Note: the boost is applied to final
  damage rather than the attack stat — same result within rounding.
- **Choice Scarf** — x1.5 speed in `CompareSpeedsWithAbilities` (compares by item ID,
  which is fine), shares the move lock. Respects Trick Room.
- **Assault Vest** — blocks status-move selection for the player, forces the AI onto a
  damaging move (Struggle fallback), x1.5 SpDef via `HeldDefenseBoost_Core` on special hits.
- **Eviolite** — x1.5 Def and SpDef, gated on the species having an evolution
  (first byte of its EvosAttacks data).
- **Focus Sash** — full-HP check, endures with 1 HP, consumed; correct priority order
  (Endure > Sturdy > Sash).
- **Expert Belt** — x1.2 only when `wTypeModifier` > neutral.
- **Muscle Band / Wise Glasses** — x1.1 physical/special.
- **Loaded Dice** — multi-hit rolls 4–5 (loop count 3–4); Triple Kick skips accuracy
  after the first kick. Matches modern behavior.
- **Rocky Helmet** — 1/6 max HP to contact attackers, skipped behind Substitute,
  skipped if attacker already fainted.
- **Life Orb** — x1.3 damage, 10% recoil, Magic Guard exempt, no recoil on a miss.

## Bugs found and fixed

1. **Choice lock soft-lock (player)** — if the locked move ran out of PP (or was
   disabled), every menu pick was rejected and the player was stuck. Now mirrors the
   enemy handler: an unusable locked move forces Struggle; if the locked move is gone
   entirely (e.g. overwritten), the lock re-arms on the newly picked move.
   (`CheckPlayerChoiceLock_Core.blocked`, abilities_engine.asm)
2. **Life Orb recoil per hit on multi-hit moves** — `RunContactAbilitiesHook` runs from
   every `checkfaint`, so a 5-hit move cost 50% max HP. Recoil now fires once: on the
   loop's final hit (counter == 1 with `SUBSTATUS_IN_LOOP` set) or on an early KO.
   (`LifeOrbRecoil`, abilities_engine.asm)
3. **Air Balloon popped through Substitute** — the pop now happens only when the holder
   itself is hit (moved behind the Substitute check in `RunPostDamageHeldItems`).
4. **Spikes hit ungrounded mons** — `SpikesDamage` only exempted Flying-types; it now
   also exempts Levitate and Air Balloon holders. Toxic Spikes already knew about
   Levitate; Air Balloon added there too, placed before the Poison-type absorb so a
   floating Poison-type doesn't soak the spikes. (core.asm, new_move_cores.asm)
5. **Weakness Policy / Air Balloon on a KO'd holder** — both could activate (boost
   text/pop message) after the holder fainted from the hit. Both now check
   `OppHasFainted` first.

## Known deviations left as-is (deliberate / cosmetic)

- Air Balloon has no "floats on air balloon" announcement on switch-in (cosmetic).
- Weakness Policy can trigger from each hit of a multi-hit SE move — harmless, since
  it's consumed on the first proc.
- Rocky Helmet chips the attacker even when the helmet holder faints (canon in Gen 5–6,
  changed in Gen 7+; pick your preference).
- Choice boost is a final-damage multiplier, not a stat multiplier (rounding-level).

## New items: Flame Orb ($B3) + Toxic Orb ($BE)

Repurposed the two dummy slots (was ITEM_B3 / ITEM_BE), so no item IDs shifted.
New held effects `HELD_FLAME_ORB` / `HELD_TOXIC_ORB` (93/94).

Behavior (`HandleStatusOrbs_Core` in effect_commands_core.asm — the Battle Effect
Overflow bank, since Battle Core was 1 byte from full — farcalled from
`HandleBetweenTurnEffects` after healing items, for both sides, serial-order aware):
- Skips if the holder fainted or already has a status.
- Flame Orb: no Fire-types; Water Veil / Thermal Exchange immune. Sets BRN, updates
  party struct, halves Attack (`ApplyBrnEffectOnAttack` with turn flipped), plays
  ANIM_BRN, prints "was burned by FLAME ORB!".
- Toxic Orb: no Poison-/Steel-types; Immunity / Pastel Veil immune. Sets PSN +
  `SUBSTATUS_TOXIC`, zeroes the toxic counter, ANIM_PSN, "was badly poisoned by TOXIC ORB!".
- Safeguard intentionally not checked (self-inflicted, canon).

Files touched: constants/item_constants.asm, constants/item_data_constants.asm,
data/items/names.asm, attributes.asm, descriptions.asm, catch_rate_items.asm,
data/text/battle.asm, engine/items/item_effects.asm (comment), engine/battle/core.asm
(call site), engine/battle/effect_commands_core.asm (routine body).

**Not yet obtainable** — no mart/itemball placement was added (per request).
Add e.g. `db FLAME_ORB` to a mart or an itemball event when ready.

## Recommended next items (ranked by fit with your existing hooks)

1. **Heavy-Duty Boots** — you have Spikes + Toxic Spikes; one held-effect check in the
   same two spots the Air Balloon fix touched. Big competitive value, trivial to add.
2. **Black Sludge** — clone of `HandleLeftovers`: heal 1/16 if Poison-type, else hurt 1/8.
3. **Shell Bell** — heal 1/8 of damage dealt; `RunPostDamageHeldItems` is the natural hook.
4. **Weather rocks (Heat/Damp/Smooth/Icy Rock)** — extend `wWeatherCount` 5→8 when the
   setter holds the matching rock; one check where weather moves set the counter.
5. **Light Clay** — same idea for Reflect/Light Screen durations (`HandleScreens` exists).
6. **Power Herb** — skip the charge turn; you already have charge-skip logic
   (`BattleSkipSunCharge_Core`) to pattern-match.
7. **Wide Lens** — x1.1 accuracy; slots into the accuracy-mod path next to BrightPowder.
8. **White Herb / Mental Herb** — one-shot cures for stat drops / Attract; consumed items
   already have `ConsumeHeldItem`.
9. Custom idea: a **frostbite orb** ("Icy Orb") mirroring Flame Orb, since your engine
   has frostbite — unique to the hack, pairs with SpAtk-based Guts-alikes.

## Build note

The Battle Core bank was already packed to within a couple of bytes of its 0x4000
limit before this work, so both new pieces live in the Battle Effect Overflow bank:
`HandleStatusOrbs_Core` and `CheckSpikesUngrounded_Core` (the latter also absorbed the
pre-existing Flying-type Spikes check, making the net Battle Core delta slightly
negative). Any future core.asm addition of more than a byte or two will overflow the
bank again — put new battle code in the overflow bank and `farcall` it.
