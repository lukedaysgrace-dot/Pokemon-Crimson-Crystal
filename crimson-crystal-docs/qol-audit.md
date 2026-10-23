# Quality-of-life audit

Source review: October 15, 2026. Covers battle/audio, breeding, training,
movement/field actions, inventory, storage, menus, information, and daily systems.
This is a source survey with targeted compiled-ROM regressions, rather than a
full campaign playthrough. Recommendations below are proposals, not implemented
features.

## Implemented and verified

| Area | Result |
| --- | --- |
| Red-HP alarm | Retains the existing three-cycle limit. Fixed SFX consuming unheard cycles: the alarm now pauses while another effect plays. Continued red HP cannot restart it after its allowance is used. Healing out of red resets the tone phase and budget; fainting and battle cleanup clear it. |
| Producing eggs | Compatible deposited parents produce an egg after 64 counted Day-Care steps. Removed the random initial wait and compatibility-dependent success rolls. Species, gender, egg-group, and Ditto compatibility rules still apply. Pending eggs stop further production. |
| Existing breeding countdowns | Zero and values above 64 are repaired to a 64-step countdown when walking resumes. Existing shorter countdowns are kept. |
| Hatching | Egg cycles advance every 16 counted steps instead of 256: sixteen times faster. Applies to existing eggs and gift eggs as well as newly bred eggs. Magikarp: up to 80 steps; Eevee: up to 560. The position in the shared cycle can shorten the first interval. |
| Multiple eggs | Every egg advances before the hatch event starts. A ready egg no longer holds later eggs back, and zero counters cannot underflow to 255. |
| Flexible Repel renewal | Keeps the previous type when available; otherwise offers Max Repel, Super Repel, then Repel. Shows the offered name and total bag count. Accepting consumes one and remembers its type; declining changes nothing. |
| Repeat-use consumables | Field healing/status items, revives, vitamins, PP items and Rare Candies return to the party picker after consumption while more remain. The picker shows the item and remaining total across stacks. Cancel, no effect and exhaustion return to the Bag. Battle turns and Hard caps are preserved. |
| Pre-evolution Move Reminder | Eligible level-up moves come from the current species and its actual ancestor chain, up to its current level. Known moves, duplicates, future moves and sibling branches are excluded. The existing successful-lesson fee remains ¥1,000. |
| Published guide | Individual species hatch-time estimates now read the cycle length from the source constant. Added the alarm and breeding changes to the game-updates directory. |

"Counted steps" follows the existing overworld dispatcher: link rooms and steps
intercepted by phone calls, Repel expiry or Safari events do not advance these
systems. A hatch event also takes priority over that step's Day-Care update.
The ordinary friendship, poison, parent-EXP, and bicycle counters retain their
existing schedules. These changes add no save fields or save-layout migration.

## Already present — keep these

| Feature | Evidence / useful detail |
| --- | --- |
| Reusable TMs | [TM/HM use](../engine/items/tmhm.asm). |
| HMs without occupying a moveslot | [Field HM checks](../engine/events/field_hm_interaction.asm): own the HM, earn its badge, and carry a compatible Pokémon. Party compatibility is still required. |
| Fly from the Pokegear map | [Map input](../engine/pokegear/pokegear.asm): A already calls FieldHMPokegearTryFly. Improve its discoverability if needed rather than adding a second Fly action. |
| Solo evolution routes | [Evolution data](../data/pokemon/evos_attacks_kanto.asm): examples include level-36 Kadabra/Machoke/Graveler/Haunter and directly using Metal Coat or Dragon Scale. Do not add a redundant trade substitute. |
| Reusable ability changer | Elm's reusable Ability Cap freely cycles available Ability 1, Ability 2 and Ability 3 slots; the abilities-off choice intentionally disables it. [Item effects](../engine/items/item_effects.asm). |
| Perfect-DV acquisition | Most caught, gifted, and hatched Pokémon get perfect DVs; wild Unown/Magikarp have intentional exceptions. [Pokémon creation](../engine/pokemon/move_mon.asm). |
| Move Reminder and egg/family tutor | [Blackthorn](../maps/MoveDeletersHouse.asm): ¥1,000 level-up reminder and ¥5,000 egg/family lessons. |
| Goldenrod utility tutor | [PP speech house](../maps/GoldenrodPPSpeechHouse.asm): several useful support moves for ¥1,000. |
| Modern move inheritance | [Breeding](../engine/pokemon/breeding.asm): either parent can pass listed egg moves; Ditto does not supply moves. |
| Repeat Repel prompt | [Repel scripts](../engine/events/misc_scripts_2.asm): offers another of the same kind. |
| Expanded graphical storage | [PC interface](../engine/pc/bills_pc_ui.asm), [backend](../engine/pc/storage.asm): 25 boxes / 500 slots, held-item handling, themes, party access, and overflow into another box. |
| Larger bag and manual item reordering | [Capacity constants](../constants/item_data_constants.asm), [pack](../engine/items/pack.asm): 40 item stacks, 12 Ball stacks; SELECT reordering already exists. |
| Useful summary information | [Summary](../engine/pokemon/stats_screen.asm): ability/slot and description, move information, Hidden Power details and friendship information. |
| Detailed battle move information | [Battle move box](../engine/battle/move_info_box.asm) already shows power, accuracy, category, type and PP; it also handles Hidden Power's computed values. |
| Clock correction item | Relic Clock already provides an in-game clock reset path. Do not add a second correction system. [Item effects](../engine/items/item_effects.asm). |
| Improved Apricorn harvest | Three Apricorns per tree. [Fruit trees](../engine/events/fruit_trees.asm). |
| Faster overworld scheduling | [Overworld loop](../engine/overworld/events.asm) avoids waiting for a second VBlank when a busy frame already crossed its boundary. |

## Highest-value additions

These are the next changes I would prioritize. Each row describes a gap in the
reviewed implementation or an improvement to an existing feature.

| Priority | Recommendation | Current friction / implementation direction |
| --- | --- | --- |
| 1 | Hold B to run, plus an autorun toggle | [Movement](../engine/overworld/player_movement.asm) has walking/bike/skate states but no ordinary B-button run path. Keep ledges, forced movement, ice and surfing behavior intact; running indoors should work. |
| 1 | Prevent walking-poison fainting | [Poison steps](../engine/events/poisonstep.asm) still remove the last HP and can white out the party. Stop at 1 HP and cure poison there, with one short notice. Keep battle poison untouched. This is a proposed rule change, not part of this patch. |
| 1 | Earlier Move Reminder access | The current reminder is in Blackthorn. Add an accessible Goldenrod service, or a reusable menu service unlocked there, while keeping the existing tutor. Preserve level eligibility and payment only on successful lessons. |
| 1 | FAST by default and an instant-text choice | [Defaults](../data/default_options.asm) still select MED; [Options](../engine/menus/options_menu.asm) offers FAST/MID/SLOW. Add instant text without removing required button prompts or speeding scripted animations. |
| 1 | Quick Ball shortcut / last-used Ball | [Battle menu](../engine/battle/core.asm) still routes Ball use through BAG. A dedicated shortcut should open the Ball pocket or reuse a chosen Ball, with visible quantity and normal invalid-battle checks. Avoid silently throwing an expensive Ball. |
| 1 | Bag sorting and favorites | Existing SELECT swapping is manual. Add stable name/type sorting and favorite registered items; preserve quantities, 16-bit item IDs, Key Items and pocket cursors. |
| 1 | PC search/filter and free-space display | The graphical PC is already substantial; extend it with species/name/type filters and capacity indicators before attempting bulk operations. Keep filtered slots mapped to their actual box positions. |
| 1 | Put evolution requirements and learnsets in the Pokédex | The public guide knows custom methods; the in-game Dex retains its conventional entry/AREA/search flow. Show the actual source-driven evolution item/level/time/move and upcoming level-up moves. This matters with such a large custom roster. |

## Further worthwhile QoL

| Priority | Recommendation | Scope and tradeoff |
| --- | --- | --- |
| 2 | Day-Care egg-ready notification | Route 34 currently uses the man's outside position/callback as the signal. Add a short notification or optional phone message, plus a clear "64 steps" explanation when depositing compatible parents. Avoid repeating an alert for the same egg. |
| 2 | Show remaining hatch steps in the egg summary | Existing summary text uses broad hatch-cycle bands. Show a range or "up to N counted steps" because the first shared interval can be partial. |
| 2 | Prevent Day-Care moveset replacement | [Retrieval](../engine/pokemon/move_mon.asm) calls FillMoves after gaining levels. Preserve the deposited moveset or make learning elective so a breeding donor does not lose a carefully chosen move. |
| 2 | Optional Flame Body / Magma Armor hatch bonus | These abilities have battle implementations but no bonus in DoEggStep. A party-wide, non-stacking 2× bonus would fit; honor the abilities-off choice. The new base hatching speed already makes this optional. |
| 2 | Rename any owned party Pokémon from its summary | The Name Rater still rejects traded Pokémon and requires a trip to his house. A summary action can remove that travel and ownership restriction while keeping eggs excluded. |
| 2 | Direct held-item swaps | Extend current item management with give-and-swap in one interaction and clear confirmation of the displaced item; retain Mail and bag-full checks. |
| 2 | Optional team EXP sharing / catch-up training | Current EXP Share is a held-item system. A toggleable team mode or paid level-cap training service would reduce replacement-team grinding. This needs an EXP-economy decision and tests against Hard caps, fainted mons and eggs. |
| 2 | Show the current Hard Mode cap in common menus | The cap schedule exists in source, but a player should see the current cap before buying or using training items, and know why EXP is blocked. |
| 2 | Faster repeated Pokémon Center visits | Shorter repeat dialogue and an optional fast healing presentation; keep first visits, story scenes, healing sound and save-sensitive logic intact. |
| 2 | Quick Save action | Reuse the existing save routine with one intentional action and a completion notice. Keep New Game / overwrite protection and backup/checksum handling. An autosave system would need a separate design. |
| 2 | Optional phone chatter filter | Keep story-critical calls, but let players mute ordinary calls without deleting contacts. The [contact limit](../constants/phone_constants.asm) is only ten; expanding it requires checking saved-data layout. |
| 2 | Mark ready rematches and pending rewards | Put rematch availability, gifts and missed reward claims in a concise phone/status menu so players do not repeatedly call or revisit NPCs to check. |
| 3 | Wild encounter checklist | Extend AREA with actual time/method, caught markers and discovered encounters. Include fishing, Headbutt, Rock Smash and new regions rather than exposing only grass/Surf information. |
| 3 | Optional move-effectiveness hints | Extend the existing detailed battle move box with an effectiveness hint using the game's typing mode. Avoid revealing unknown enemy abilities. Power, accuracy, category, type and PP already exist. |
| 3 | Fast presentation presets | Separate move-animation choices from entry/send-out, weather, ability-banner and EXP pacing. Keep required telegraphs readable and support the existing battle-scene toggle. |
| 3 | Multiple registered key items | [SELECT](../engine/overworld/select_menu.asm) currently uses one registered item. Add a compact favorites picker for bike, rods, Itemfinder and useful key items. Fly from the Pokegear map already exists. |
| 3 | Friendship training service | Perfect DVs already remove one grind; friendship evolutions still use ordinary walking increments. Offer an accessible grooming/training path rather than silently increasing every Pokémon's friendship or altering Return/Frustration balance. |
| 3 | Stat-experience catch-up and reset service | This game uses Gen 2 stat experience, not modern EVs/natures. Offer clear per-stat information and optional training/reset services using the actual formula; do not add misleading modern EV labels. |
| 3 | Breeding / PC batch actions | Multiple-egg collection or multi-select storage operations are useful later, after search and reliable single-operation UX. Egg collection must keep party-full checks and prepare each offspring independently. Release actions need explicit confirmation. |

## Suggested order

Start with running, poison safety, earlier reminder access, instant text and
quick Ball access. Then add bag sorting, PC filtering and in-game evolution
information. Treat team EXP, candy availability, friendship acceleration and
stat-experience services as separate balance choices, particularly for Hard
Mode. Ability capsules, reusable TMs, offline evolutions, HM moveslot relief,
repeat Repels and expanded storage already exist and should not be duplicated.

## Verification

- Both release and debug ROMs build with RGBDS 0.5.2.
- `tools/test_qol.py` passes 1,660 checks per ROM, including tone-trigger counts,
  SFX-channel interference, red-HP persistence, healing/faint resets, all parent
  compatibility classes, old countdown repair, incompatible parents, all six egg
  slots, zero counters and 560 native CountStep calls to hatch an Eevee egg.
- Native CountStep checks stub unrelated phone, Safari, Day-Care, poison, bike
  and friendship services in private emulator memory; the dispatcher and egg
  stepping execute the compiled ROM. This is not an end-to-end field UI test.
- Existing Day-Care ability tests: 21 passed, 0 failed.
- Existing breeding move tests: 5,834 checks passed, covering 965 family egg
  moves inherited from both parent slots.
- Existing HP/item update suite: 40 item scenarios and 24 faint-update battles,
  352 total checks, 0 failures.
- Reproduce with `make test-qol BATTLE_TEST_PYTHON=.venv/bin/python` in WSL.
- Follow-up checks: `make test-qol-followups BATTLE_TEST_PYTHON=.venv/bin/python`.
  Both ROMs pass 8,826 routine checks and 40 native menu checks each (17,732 total).
  The follow-up ROM suite checks all Repel availability/preference combinations,
  all 495 species at five levels, known-move exclusion, scratch bounds, stack
  totals and real healing/inventory changes. Native menu tests use button input
  for healing, cancellation, vitamins, PP Ups, Rare Candies and the Hard cap.
  Direct routine tests replace unrelated presentation/target picking in private
  memory; the separate menu tests run those menus normally.
- Regenerate the immediate-ancestor table after editing evolution rows with
  `python tools/generate_pre_evolutions.py`; normal builds also refresh it when
  its inputs change. `--check` verifies it matches source.
- Tests use private emulator memory and do not read or alter player saves.
