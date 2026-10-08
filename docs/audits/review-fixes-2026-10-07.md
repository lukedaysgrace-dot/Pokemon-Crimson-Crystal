# Review fixes after the third ability pass — 2026-10-07

An independent review of `7b65f60b`, `0eb82884`, and `febe655b` checked the
ability changes against the Pokémon Showdown simulator itself (npm
`pokemon-showdown`, Gen 9 custom game). The scenarios were run there, not
only read from source. It found three battle defects and one weather defect.
Every other correction in the third pass matched the simulator.

## Corrections

| Area | Defect | Fix |
| --- | --- | --- |
| U-turn KO | Life Orb recoil, Moxie and Pickpocket moved to the move-end hook in the third pass. A KOing U-turn pivoted inside `checkfaint` first, so the *incoming* mon paid the recoil or gained Moxie. The U-turn user paid nothing. | `BattleCommand_CheckFaint.u_turn_ko` runs `RunAfterMoveAbilities_Core` before the pivot, the same as the non-KO path. If recoil faints the user, the pivot is skipped. |
| Technician / Barb Barrage | The third pass treated Barb Barrage against a poisoned target as 120 power for Technician. In Showdown, Technician (`onBasePowerPriority` 30) runs before Barb Barrage's own `onBasePower` doubling, so it still boosts. Simulator result: 181–214 damage with Technician vs 121–143 without. | Removed the `.barb_barrage` branch from `TechnicianBoostsCurrentHit` and inverted the regression in `80-ability-review-regressions.yaml`. |
| Knock Off | A Knock Off user that fainted from Rocky Helmet or Iron Barbs still removed the target's item. Showdown removes nothing. This predates the third pass, which fixed the same case for Thief only. | `BattleKnockOff_Core` returns when the user has fainted. A target KO still loses its item. |
| Azalea rain | `CheckAzaleaWeather` tested `wCurDay & 1`. `wCurDay` accumulates, so the Sunday/Tuesday/Thursday/Saturday schedule inverted every other week. This is the same class of defect as the fishing-calendar bug. | Calls `GetWeekday` first. |

## Validation

- `82-review-fixes-2026-10-07.yaml`: 13 cases (10 fixes, 3 controls).
  - All 10 fix cases fail on the pre-fix debug ROM (`7ce158457adaa001c250bebaded380fa`), and the controls pass.
  - All 13 pass on the fixed ROM.
  - The cases cover a Life Orb user, an incoming Life Orb holder, Moxie on both sides of the switch, recoil fainting the user, a Parental Bond first-hit KO, Knock Off against Rocky Helmet (both sides) and Iron Barbs, and the surviving-user and target-KO controls.
- The inverted Technician/Barb Barrage regression fails before the fix and passes after it.
- `tools/test_azalea_weather.py` (`make test-weather`) runs 768 routine-level checks: all 256 calendar bytes × two Azalea maps and one outside map. It reports 252 failures before the fix and 0 after.
- Fixed ROMs: release `d4aaa09743996d476917b9d7a2457cf0`, debug `7797118a79530624bc9384200c10a4fa` (built with RGBDS 0.5.2).
- Full battle suite (Codex's complete command, all matrices, `--interactions 1024`) on the fixed debug ROM: **20,747 of 20,748 passed**.
  - The one failure was the generated "Reflection matrix: ATTRACT Prankster Dark" case. It fails identically on the pre-fix ROM.
  - The case assumed `dvs: 0` makes Umbreon female, but gender is a stored creation flag. `reflection_matrix.py` now pins `wEnemyMonShinyGenderFlags` instead.
  - After that, all 1,503 permanent YAML cases plus the 84-case reflection matrix pass: 1,587 of 1,587.
- `make audit-static` passes: game data, ability text, moves, learnsets, trainers, save layout, linked resources/audio, and overworld icons.
- Fishing backend: 2,159 checks with zero failures. Contest judging text: 22 checks with zero failures.

## Not changed

`EnsureDailyWeather` keys the daily roll as `wCurDay | $B0`. Days differing only in bits 4, 5 or 7 (for example, 16 days apart) share a key, so the weather is not rerolled if the player returns exactly then. The impact is small, and changing the key format affects saved data, so it is left as is.
