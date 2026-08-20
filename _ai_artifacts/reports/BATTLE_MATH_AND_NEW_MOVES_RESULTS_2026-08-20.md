# Results — Battle Math Pack + New Status/Hazard Moves

**Implements:** `BATTLE_MATH_AND_MOVE_GAPS_SPEC_2026-08-19.md`
**Base commit:** `71b0669` ("ai better knowledge of new abilities")
**Completed:** 2026-08-20. Both work packages landed; Magic Coat skipped on
Luke's instruction, BM9 deferred on Luke's instruction.

**Final state: `make` and `make debug` clean (zero new warnings).
Full suite + `--all-moves --all-effects` sweep: 1010 passed, 0 failed,
3 errored — all three are the pre-existing emulator flakes (see
"Emulator flakes demystified" below). `audit_moves` / `audit_trainers` /
`audit_game_data` report exactly the baseline findings, nothing new.**

New test suites: `tools/battletest/tests/50-battle-math.yaml` (21 cases)
and `51-new-status-moves.yaml` (22 cases), all green.

---

## Part 1 — Battle Math Pack (all landed)

- **BM1** Crits deal ×1.5 (was ×2). `effect_commands.asm .CriticalMultiplier`
  now computes `damage + (damage >> 1)` with the $ffff cap.
- **BM2** Gen 7+ crit table chosen (Luke's call): 11/32/128/255 per 256 for
  stages 0/1/2/3+. Stage 3+ is 255/256, not a true guarantee — accepted
  deliberately to keep the table a pure data change (documented in the file).
- **BM3** Sleep lasts 1–3 turns. The roll is `swap a / and %11` (reject 0),
  NOT plain `and %11`: the harness's forced RNG values ($14/$B4) have low
  bits %00 and would spin a plain `and %11` reroll loop forever — see the
  rng contract comment in `tools/battletest/state.py`. The Battle Tower's
  special shorter roll was removed (meaningless at 1–3).
- **BM4** Paralysis halves Speed (was quartered): one `srl a / rr b` pair
  deleted per side in `ApplyPrzEffectOnSpeed`.
- **BM5** Toxic persists across switches, counter resets (Route A):
  per-slot bitfields `wPlayerToxicSlots`/`wEnemyToxicSlots`, set at every
  `set SUBSTATUS_TOXIC` site, cleared at every cure site, restored (guarded
  by the party PSN bit, stale bits dropped) by `ToxicRestore*_Core` at the
  tail of `NewBattleMonStatus`/`NewEnemyMonStatus`. Baton Pass no longer
  passes the toxic substatus (modern rule); a badly-poisoned mon that comes
  in via Baton Pass is downgraded until its next regular switch-in, when its
  slot bit re-arms it — noted as a small deviation.
- **BM6** HP berries fire immediately after damage, hooked at the tail of
  `BattleCommand_CheckFaint` (present in EVERY damaging move script, unlike
  kingsrock — followed the same reasoning that moved contact abilities
  there). Multi-hit moves eat between hits. The end-of-turn
  `HandleHealingItems` call still covers chip damage; item consumption is
  the double-eat guard.
- **BM7** Encore = exactly 3 encored turns (counter written as 4;
  `HandleEncore` decrements at the end of the Encore turn too). Disable =
  4 turns (low nibble written as 4; slot packing untouched).
- **BM8** Protect works behind the user's own Substitute (bail deleted) and
  thirds per consecutive use via a lookup table (255/85/28/9/3/1, clamped).
- **BM9** (per-side crit stat-stage rule) **deferred** per Luke.

### Bonus bug fix (found by the BM2 tests)
`.CheckCritical` passed the CriticalHitMoves *table address* as the search
value to `IsInHalfwordArray` (which takes the value in `bc`), so **high-crit
moves never actually received their +2 stage**. Fixed; Slash-class moves
now crit at the proper stage.

### WRAM
The spec's reclaim plan was stale: `wUnusedMapBuffer` is now the ability
text staging buffer (`wBattleDynamicNameBuffer`, longest name 17 bytes) and
WRAM0 sections are pinned by `pokecrystal.link` with alignment, so
cross-section reclaims gain nothing. Instead all 16 new bytes live INSIDE
the `wBattle`..`wBattleEnd` union member (the 480-byte box-save buffer
sizes the union, battle state was ~316 bytes — plenty of headroom), so they
cost zero WRAM and are auto-cleared by the battle-start ByteFill:
`wPlayerToxicSlots`, `wEnemyToxicSlots`, `wPlayerTauntCount`,
`wEnemyTauntCount`, `wPlayerYawnCount`, `wEnemyYawnCount`,
`wPlayerSpikesLayers`, `wEnemySpikesLayers`, `wPlayerWishCount`,
`wEnemyWishCount`, `wPlayerWishHP` (dw), `wEnemyWishHP` (dw).

---

## Part 2 — New moves (all landed except Magic Coat)

New moves appended after LUMINA_CRASH: **TORMENT, TAUNT, YAWN, WISH,
STICKY_WEB** (constants, names, move rows, descriptions, animations,
effect scripts + pointers, battle commands `torment`..`stickyweb`
($cf–$d3), command pointers, texts, AI scoring). Command bodies live in
the Battle Effect Overflow bank (`new_move_cores.asm`); Battle Core only
gained ~20 bytes of farcalls (it has ~46 free in debug builds — the
binding constraint for future work).

- **Torment** (Dark, status, 100 acc, 15 PP): `SUBSTATUS_TORMENTED` (new
  SubStatus2 bit 1), no counter — the switch-out substatus wipe clears it.
  Enforced (a) at action time via `CheckTauntTormentCantMove_Core` in both
  CheckTurn paths, (b) at enemy move choice via the extended
  `HandleEnemyHeldMoveLocks_Core` (re-picks another usable move via new
  `FindEnemyMoveNotB`, else Struggle), (c) at the player menu via
  `CheckPlayerMoveRestrictions_Core` (see below). Fails vs Substitute.
- **Taunt** (Dark, status, 100 acc, 20 PP): counter-only (no substatus
  bit), written as 4 → exactly 3 taunted turns, Encore-style. Blocks
  status-move selection (menu + AI re-pick + action-time check), respects
  Oblivious (Gen 6+ canon) and Substitute. `PlayerMustStruggleExtra_Core`
  makes the player Struggle when Taunt/Torment forbid everything with PP.
  Wear-off message at end of turn.
- **Yawn** (Normal, status, 100 acc, 10 PP): 2-turn countdown; sleep is
  applied by the end-of-turn handler using the same swap-roll as BM3 and
  re-checks status/Safeguard/AbilityPreventsSleep at resolution. Fails up
  front vs statused targets, drowsy targets, Substitute, Safeguard,
  sleep-preventing abilities. Countdown cleared on switch-out.
- **Wish** (Normal, status, 10 PP): Future Sight-shaped side state
  (count + stored HP), stores **half the user's max HP at use time**,
  heals the slot's occupant at the end of the NEXT turn, survives
  switching (deliberately NOT cleared by NewBattleMonStatus), fails while
  one is pending.
- **Sticky Web** (Bug, status, 20 PP): `SCREENS_STICKY_WEB` = old
  SCREENS_UNUSED bit 1 (the last free screens bit, spent as the spec
  directed). Entry hook chained after Toxic Spikes in the overflow bank;
  reuses `CheckSpikesUngrounded_Core` for the Flying/Levitate/Air Balloon
  exemption; lowers Speed via the Intimidate-style `AbilityStatDown`
  machinery (turn flipped around it), so Mist/Clear Body-type protections
  apply for free. Cleared by Rapid Spin and Defog; added to
  `SCREENS_HAZARDS_MASK` (all four consumers audited — AI scoring wants
  the web included; Defog now also zeroes both layer counters).
- **Spikes layers** (1→3): `wPlayerSpikesLayers`/`wEnemySpikesLayers`;
  `SCREENS_SPIKES` stays as the "any spikes" boolean so every existing
  reader still works. Setter increments and fails at 3. Entry damage
  1/8 → 1/6 → 1/4 max HP (`SpikesLayerDamage_Core`; the 1/6 is
  floor(floor(max/2)/3) == floor(max/6)). Rapid Spin/Defog zero the count.
  `AI_Smart_Spikes` now dismisses at 3 layers.
- **AI:** `AI_Smart_Torment/Taunt/Yawn/Wish/StickyWeb` added (dismiss when
  redundant; Taunt encouraged early; Wish encouraged when hurt). A taunted
  AI's status picks are swapped to damaging moves by the lock handler, so
  it can never visibly stall. (A deeper "bail out of status-move scoring
  layers while taunted" pass was not needed for correctness and was left
  undone — noted as possible polish.)
- **Learnsets** (to keep `audit_moves` clean): Slowpoke 1 Yawn; Murkrow 26
  Taunt, 28 Torment; Togepi 18 Wish; Spinarak 25 / Ariados 1 Sticky Web.
  All additive level-up entries; no TMs touched.
- **Animations:** reused in-repo animations as the spec recommends —
  Swagger (Torment, Taunt), Sweet Kiss (Yawn), Morning Sun (Wish),
  Spider Web (Sticky Web). Pokeorange (in Luke's folders) has real
  BattleAnim_Torment/Taunt/Wish/Yawn scripts in its `animations_2.asm`
  that could be ported later (Polished Crystal does not have these moves).
  No new OAM/frameset data, so the frameset-index-256 rule is untouched.
- **Magic Coat: not added** (Luke's instruction). For the record, the
  spec's audit question stands unanswered — no Magic Bounce audit was done.

### Second bonus bug fix (found by the Taunt AI test)
`EnemyMoveIsStatus` clobbers `hl` (via `GetMoveAttribute`), and
`FindFirstEnemyDamagingMove` called it mid-loop with `hl` holding the move
list pointer — any status move sitting in an earlier slot than the first
damaging move corrupted the scan. Pre-existing (reachable from the Assault
Vest AI path); fixed with push/pop, ditto in the new `FindEnemyMoveNotB`.

---

## Emulator flakes demystified (important for future sessions)

The long-standing *"Klutz suppresses Smoke Ball escape"* error — and the
*"Neutralizing Gas suppresses Run Away"* error that joined it after this
work — are **PyBoy emulation-mode artifacts, not ROM bugs**: the ROM
crash-reboots (the "Game Boy Color only" screen) during the tester's
escape flow **only in PyBoy's fast mode**. Register any hook
(`pb.hook_register`) — which switches PyBoy to its slower, more accurate
stepping mode — and the exact same test **passes**. Which of the two
escape tests crashes is sensitive to data layout, which is why the second
one flipped after five moves were appended. `EFFECT_CONVERSION2`'s sweep
timeout is also pre-existing (reproduces on the clean base commit).
A future session could pin these down in PyBoy itself (suspect: double
speed / KEY1 handling differences between modes) or make the runner
retry escape tests in hooked mode.

Also for future sessions: **stock PyBoy needs the MBC30 patch** from
`tools/battletest/README.md` (banks ≥ $80 are silently masked otherwise
and the ROM crash-loops at NEW GAME under the emulator — the game itself
is fine). `_ai_artifacts/rgbds-0.5.2-linux.tar` is a known-good toolchain;
the `rgbds/` binaries in-repo are git-mangled (segfault) and the `.xz`
there is corrupt.

## Deliberately not done / deferred

- BM9 per-side crit stat-stage rule (Luke chose to defer).
- Magic Coat and the Magic Bounce coverage audit (Luke: skip).
- Porting pokeorange's real Torment/Taunt/Wish/Yawn animations.
- Battle Tower parties/trainer data untouched (per spec's "what NOT to do").
- Yawn plays no dedicated drowsy animation at resolution (text + status
  only; the sleep anim plays via AbilityStatusAnim).
- `tools/battletest/effect_sweep.py` expected-count bumped 197 → 202 with
  semantic scenarios for the five new effects.
