# Fishing contest and new-game rules — 2026-10-07

The additional integration pass found and corrected a fishing-calendar bug.
The fishing and gameplay-rules checks pass on the rebuilt release/debug ROMs.
The longer progression playthrough was set aside at the user's request.

## Correction: Fridays after the first week

`wCurDay` contains the accumulated calendar day. Friday is day 5 in the first
week, day 12 in the second, day 19 in the third, and so on. The gate script
already used `VAR_WEEKDAY`, which reduces the day modulo seven. However,
`FishingContestAccess` and `FishingContestCheckDay` compared raw `wCurDay`
directly with `FRIDAY`.

On the following Friday, the gate offered entry, but the overworld immediately
ended the newly entered contest. Fishing access also rejected that Friday.
Both routines now call the existing `GetWeekday` helper before comparing.

The same expanded backend suite produces **187 failures on the pre-fix ROM**
and **2,159 checks with zero failures on the repaired ROM**. It checks access
and day expiry across all 256 possible calendar-byte values, plus ordinary
A-button fishing on later Fridays. The native RTC integration also verifies
that the first Friday's participation flag clears and a contest can be entered
and completed on calendar day 12.

## Validation

| Check | Result |
| --- | --- |
| Fishing backend/script/calendar regressions, release ROM | 2,159 checks, zero failures |
| Native fishing menus, capture, judging, storage, Save/Continue, and RTC, debug ROM | 133 checks, zero failures |
| Contest judging text | 22 checks, zero failures |
| All eight new-game rules combinations | 232 checks, zero failures |
| Save layout/recovery audit | 185 checks, passed |
| Linked resources/audio audit | 4,675 checks, passed |
| Release and debug builds | Passed |
| Python compilation and `git diff --check` | Passed |

Release MD5: `bbf68a6a31f413c4539e40ebecf2247e`.
Debug MD5: `7ce158457adaa001c250bebaded380fa`.
Reference commit before this work: `7b65f60b`.

### Fishing integration coverage

The initial private fixture stages Friday, a valid party, and the gate
location. Subsequent entry/casting/battle/judging sequences use ordinary
buttons and actual script, dialogue, menu, sound-wait, and map code.
Presentation and time-event routines are not stubbed.

The pass covers refusing entry, refusing the first-mon selection, one-mon
entry, egg/fainted-lead refusal, entering with other party members held,
declining early finish, accepting early finish, same-day re-entry refusal,
and next-Friday re-entry. It casts at the water without a carried or
registered rod, catches fish with the native Lure Ball menu, checks the real
ball-cost counter, judges the catch, verifies the placement award reaches
the appropriate inventory pocket, and returns the held party unchanged.

A six-mon fixture verifies that judging returns every held Pokemon and
sends the actual catch into PokeDB. A full item-pocket fixture verifies that
the guard keeps a Water Stone prize, native Save/fresh boot/Continue retains
the pending prize and full bag, and a subsequent claim succeeds after room
is made. Fixture fields for the egg, fainted lead, six-mon party, full bag,
and pending-prize edge cases are explicitly staged.

Clock checks accelerate the emulator RTC epoch, then let the ROM read its
clock registers and process ordinary overworld events. They cover 20-minute
expiry, Friday 23:58 to Saturday 00:00 before the timer expires, Saturday
entry refusal, and a seven-day advance to the following Friday. No clock
case writes `wCurDay` or patches the timer/daily-event routines.

Stock PyBoy's MBC3 masks ROM banks to seven bits and cannot write this game's
upper SRAM banks. Its usual MBC5 test surrogate also removes RTC support.
`prepare_mbc30.py` therefore builds an isolated emulator copy with eight-bit
ROM banking and SRAM banks 4–7 enabled. It leaves the installed emulator and
ROM untouched. These are emulator integration checks; physical-hardware RTC
and audible playback quality are not covered.

### New-game rules coverage

Every combination of Original/Enhanced types, Original/Enhanced stats, and
abilities On/Off is selected through the actual New Game menus at Normal
difficulty. Each starts with an empty party, saves through the start menu,
boots a new emulator from private cartridge SRAM, chooses Continue, and
checks the saved rules.

Each continued save then receives staged level-ready Ledyba, Pidgeotto, and
a reserve. The real evolution routine and animation produce Ledian and
Pidgeot. Assertions check species, permanent personality, selected base
stats, independently calculated evolved stats, Ledian's selected typing,
and ability enable/disable behavior. Actual party/PokeDB deposit and
withdrawal check personality and recalculated stats. A final native
SaveGameData/TryLoadSaveFile round trip checks the selected rules and exact
party data after evolution and storage.

This verifies the selected rule paths with representative changed species.
It is not an evolution sweep of every species or natural leveling campaign.

## Repeating the checks

Use WSL with PyBoy/PyYAML/Pillow and the repository's configured RGBDS.
The optional RTC adapter additionally needs Cython, setuptools, and a C
compiler in the same Python environment.

```sh
make -j8 debug all
make test-gameplay-rules BATTLE_TEST_PYTHON=.venv/bin/python
make test-fishing BATTLE_TEST_PYTHON=.venv/bin/python
```

Both targets are explicit so the ordinary battle suite does not acquire a
new compiler dependency. Temporary logs, captures, and the private emulator
copy are under `.tmpbuild/`. The player's ROM/save sidecars are not loaded
or modified by these tests.

The deferred progression checkpoint covers fresh-game setup, the mother and
Pokegear sequence, Elm's starter/mission/Potion, the Route 29 connection and
a native wild-battle blackout returning home with healed HP/PP. It does not
cover the rival, Elder, gym rewards, or Rocket progression. Its private
checkpoint and input journal are in `.tmpbuild/story-playthrough/` and were
recorded on the pre-fix debug ROM.
