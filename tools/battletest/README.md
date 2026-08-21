# Battle test harness

Automated battle testing for Crimson Crystal. The debug ROM
(`make debug` → `pokecrystal_debug.gbc`) contains an in-ROM battle tester;
this directory drives it headlessly with PyBoy and asserts on WRAM.

## Quick start

```bash
make debug          # build pokecrystal_debug.gbc (release ROM untouched)
make test           # run every YAML case in tools/battletest/tests/
make test-all       # YAML assertions + every effect + execute every move
python3 tools/battletest/runner.py --interactions 128 -k "Interaction stress"
python3 tools/battletest/runner.py tests/00-smoke.yaml -k levitate -v
```

Requires: `pip install pyboy pyyaml` — **with the MBC30 patch** (see below).

First run bootstraps a fresh save into the DEBUG start-menu entry
(~1 minute) and caches it as a save state in `fixtures/`, keyed on the ROM
hash. Every test after that costs ~0.4s.

`make test-all` adds a generated smoke battle for every real move constant and
a behavioral scenario for every distinct `EFFECT_*` routine. The former catches
conversion-table gaps, rejected requests, crashes, and hangs; the latter and
the YAML cases assert damage, status, stat stages, switching, weather, priority,
post-battle effects, and move/ability interactions.

`--interactions N` adds a deterministic generated sweep that mixes random
species, four-move sets, abilities, held items, status, weather, trainer AI,
benches, knockouts, and voluntary switches. It is intended as a broader
state-transition/crash sweep after the exhaustive single-move checks.

## PyBoy MBC30 patch (required)

Stock PyBoy masks MBC3 ROM banks to 7 bits, so banks ≥ $80 (where the
tester and Pokémon names live) silently map to bank-$0F garbage. Patch
`pyboy/core/cartridge/mbc3.py`, in `setitem`:

```python
elif 0x2000 <= address < 0x4000:
    if self.external_rom_count > 128:
        value &= 0b11111111          # MBC30: 8-bit bank select
    else:
        value &= 0b01111111
```

then `pip install .` from the PyBoy source tree. (Upstreaming this to
PyBoy is worth a PR.)

## Writing a test

```yaml
- name: Levitate blocks Earthquake
  player: { species: GENGAR,  level: 50, ability: LEVITATE, moves: [LICK] }
  enemy:  { species: MACHAMP, level: 50, moves: [EARTHQUAKE] }
  rng: forced_low
  turns: 1
  assert:
    - player.hp == player.maxhp
```

Side fields: `species` (constant name), `level`, `ability` (auto-resolves
to the species' legal slot so entry hooks fire; falls back to a post-entry
override for illegal pairs; `NO_ABILITY` explicitly forces none),
`ability_slot` (1/2/hidden), `item`, `moves`
(up to 4; omit to keep the level-up learnset), `dvs` (16-bit, default
$FFFF), `hp` (percent), `status_byte`, `stages` (`{atk: -1, spd: +2}`,
applied after entry abilities), `substatus` (list of SUBSTATUS_* names
without the prefix, e.g. `[MIST, TOXIC]` - ORed into the active mon's
SubStatus1-5 after entry; player1/enemy only). `player2` adds a second
party mon. `enemy2` makes it a TRAINER battle with a 2-mon enemy party
(vs a SCHOOLBOY shell - SWITCH_OFTEN AI, no items - so the AI will
actually use its bench; wild-mode rules like never-switching don't apply).
`enemy_class` (a `trainerclass` constant, e.g. `FALKNER`) swaps that shell
for another class, so its AI flags apply - FALKNER carries AI_SMART,
AI_ABILITIES and AI_ELITE, which is how `48-ai-new-abilities.yaml` tests
move scoring. The party is still replaced from the request.

Test fields: `turns` (pause for assertions after N turns), `rng`
(`forced_low` / `forced_high` / `seeded` / `off`), `rng_value`, `weather`,
`player_screens` / `enemy_screens` (raw screens byte, ORed in post-entry),
`move_script` (player move slot per turn, e.g. `[1, 2, 1]`), `setup_wram`
(post-entry raw symbol/value fixtures), `skip`.
Use `switch:N` in that list for a voluntary switch to one-based party slot
N (for example, `["switch:2"]`); normal trapping and switch-out hooks run.
Use `run` to attempt to flee through the normal battle escape path.

Assertions are Python expressions over: `player` / `enemy` (`.hp`,
`.maxhp`, `.status`, `.item`, `.ability`, `.species`, `.moves`, `.pp`,
`.stats['attack'|'defense'|'speed'|'spclatk'|'spcldef']`, `.stat_levels`
(7 = neutral), `.screens`, `.substatus`), plus `weather` (0-4),
`weather_raw` (the full wBattleWeather byte - bit 7 = Cloud Nine
suppression), `turns_done`, and `wram('wAnySymbol')` for any byte the
sym file knows (e.g. `wram('wEnemyGoesFirst') == 0` = player moved first,
`wram('wPlayerRageFistHits')`). `wram16('wAnyBigEndianWord')` reads a
two-byte battle or party value such as `wPartyMon1HP`.
`player.start_hp` etc. give the pre-turn-1 snapshot (after entry
abilities, before any move).
`ability_seen('ANTICIPATION')` checks the debug-only semantic trace of
ability banners that were actually presented; `text_seen('NAME')` checks
dynamic `text_ram` strings rendered by battle text.
`enemy_move()` names the move the AI picked on the last turn (wCurEnemyMove).

For paired control cases, give an earlier case an `id:` and read its retained
result with `result('id')`. For example, an ability damage case can assert
`enemy.start_hp - enemy.hp > result('control')['enemy']['damage']`. Retained
side data includes `damage`, `healing`, HP, status, item, ability, species,
moves, PP, stats, stat levels, screens, and substatus.
The top-level retained result also includes `weather`, `turns_done`, and the
seeded stream's `rng_count`, which can expose an unintended extra RNG roll,
plus `text_ram_count` for paired entry-message checks.

Auto-mode notes: a fainted player mon auto-switches to the next fit party
slot (no menu), which also covers Baton Pass and U-turn - so multi-mon
flows run unattended. Wild enemies never flee in tester battles (Quagsire
and everything else in the flee tables would otherwise end forced-RNG
tests on turn 1). The optional Shift-mode prompt and map trainer win/loss
text are skipped because generated tests have no interactive response or
map-script text pointers. If a battle times out, the error names the code the ROM
is spinning in (PC sampled and symbolized) - it is almost always one of
the BattleRandom reroll loops; switch that test to seeded mode.

## RNG modes

- `forced_low` (value $14): every chance-based effect procs, no crits,
  damage pinned to the maximum roll → assert exact numbers.
- `forced_high` (value $B4): nothing procs, moves still hit → isolates
  the no-proc path.
- The trainer AI's scoring rolls (AI_50_50, AI_80_20, the `cp N percent`
  chances) and its move tie-break go through `BattleRandom` (2026-08-19;
  identical to `Random` outside link battles), so forced modes pin AI move
  choice too: the smart branches are always taken under `forced_high`
  (always skipped under `forced_low`), and a tie is always broken in favour
  of the LOWEST move slot (`& 3 == 0`). A tie that does not include slot 1
  hangs the pick loop, so build AI cases around slot 1.
- `seeded`: deterministic PRNG stream from `rng_value` → same battle every
  run; use for multi-hit counts, Metronome, and anything with a
  pick-random-until-valid loop (those hang under a fixed forced value).

The forced defaults were chosen against the engine's reroll loops (enemy
move slot needs `&3==0`, sleep turns need `&7!=0`, tri-status needs
`swap&3!=0`); override with `rng_value` only if you know the loop budget.

## How it works (ROM side)

`engine/debug/battle_tester.asm` (bank $8F, `DEBUG_BATTLE` builds only).
The harness writes a request block in WRAMX bank 2 (`wDebugMagic`...)
describing both sides by true 16-bit species/move indexes, then sets the
magic byte. The in-ROM debug menu poll loop consumes it, builds the party
through `TryAddMonToParty`, stages a wild battle, and rebuilds the wild
mon from the request inside `InitEnemyWildmon` — before entry abilities,
so overridden abilities fire like real ones. `wDebugState` milestones
($01 menu, $02 init, $03 ready, $04 turn target reached, $05 done) are the
sync protocol; never frame-count. In auto mode the battle menu is skipped
and player moves come from `wDebugMoveScript`.

The player's real party and pokédex flags are backed up before the battle
and restored afterwards.
