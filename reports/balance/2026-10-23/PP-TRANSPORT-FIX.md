# Depleted-player-PP defect found during the roster audit

The broad native-ROM sweep exposed a **debug transport defect**, rather than an
incorrect damage or ability implementation. The automated player could continue
requesting a normal move after every move slot had zero PP. That could produce
an artificial stall or change an eventual result.

## Reproduction

The first observed case used seed `20268942`, level 100, and the tactical policy
on both sides:

| Side | Pokémon | Ability | Item | Moves |
|---|---|---|---|---|
| Player | GENGAR | LEVITATE | LIFE_ORB | SLUDGE_BOMB, SHADOW_BALL, THUNDERBOLT, HYPER_BEAM |
| Enemy | URSALUNABM | BULLETPROOF | LEFTOVERS | BLOOD_MOON, CALM_MIND, MOONLIGHT, HYPER_BEAM |

The original run reached its 100-turn limit. After Gengar's four PP values
reached zero, its recorded player action remained a depleted ordinary move.
With the corrective guard, the same scenario finishes on turn 52 with the enemy
winning, and the player executes native Struggle.

A smaller regression injects zero PP into all four slots of a staged Mew
(`POUND`, `CONFUSION`, `SWIFT`, `FLAMETHROWER`) facing a Blissey with
`DEFENSE_CURL`. The old player transport requests Pound. The corrected transport
executes Struggle. This deliberately injected PP state belongs to a regression
fixture; ranking scenarios start with ordinary native base PP.

## Cause and correction

`ParsePlayerAction`'s debug-auto branch calls `DebugChoosePlayerMove` and bypasses
the ordinary move-selection menu. The debug selector does not perform the
menu's exhausted-PP fallback. The policy's fallback slot request therefore did
not reach the same selection outcome as the retail menu.

The balance transport now resolves Struggle's move ID through the ROM's
`GetMoveIDFromIndex` routine and supplies it at
`DebugChoosePlayerMove.move_ok` when all four native player PP values are zero.
The game still executes Struggle, its damage, recoil, targeting, and effects.
The guard leaves normal requests and native multi-turn lock handling intact.

The earlier integration assertion only required **either** side to use
Struggle. The enemy already did, so it concealed the broken player path. The
regression now requires Struggle from each side and separately checks the
four-slot player fixture.

## Audit evidence

The original battle records are preserved. Before publishing, the report scans
both completed and timed-out battles for the affected selection pattern and
uses explicitly versioned corrective replays for those scenarios. It also
replays six unaffected controls and requires their complete turn logs to match.
The original finalist shortlist remains unchanged.

See `transport-corrections.json` for exact scenarios, original and corrected
replay IDs, matching-prefix counts, corrected logs, control checks, and the
candidate source SHA-256. `engine-pre-pp-fix.py` and `engine-pp-candidate.py`
preserve the two transport sources used in that evidence. The ROM bytes and
choice policy are unchanged between the original and corrective records.

Relevant implementation and tests:

- `tools/battle-simulator/lab/engine.py`
- `tools/battle-simulator/tests/native_checks.py`
- `tools/battle-simulator/pp_transport_probe.py`
- `tools/battle-simulator/pp_corrections.py`

This finding does not establish that every other mechanic is bug-free. Native
outcomes are used for rankings; failures and unresolved battles remain visible.
