# Battle Tower frontend and release cartridge integration — 2026-10-07

This pass covers options 4 and 5 from the earlier testing list. It adds
repeatable frontend, sound-enabled release-ROM, and two-console cable checks.
The Tower, audio/RTC, and link checks found no additional game defect.

Reference commit: `0eb82884` (the preceding fishing-calendar correction).
Release ROM tested: MD5 `bbf68a6a31f413c4539e40ebecf2247e`.
Debug ROM tested: MD5 `7ce158457adaa001c250bebaded380fa`.

## Battle Tower frontend

**72 checks, zero failures.** Private New Game fixtures stage the lobby,
party, and Hall of Fame flag. The winning parties have explicitly boosted
stats; native battle/menu/script/save code still determines every outcome.
Hooks observe execution without replacing routines.

Coverage includes:

- Registration cancellation and the pre-Hall-of-Fame L10–L40 restriction.
- Every L10–L100 choice entering its actual elevator, hallway, and battle room.
- Refusal for fewer than three Pokemon, duplicate species, duplicate held
  items, eggs, and an overlevel party.
- Quitting after a win, losing and retrying, and restoring the original party.
- Saving/suspending after a win, native reset/Continue, and resuming the next
  opponent with the saved level choice.
- A full seven-battle winning streak, party restoration, and canceling the
  prize selection without losing the pending reward.
- All five selectable prizes, a full bag preserving the prize, and claiming
  it after making room.
- Native Save, a fresh emulator boot/Continue, exactly one retained prize,
  and no second award from the receptionist.
- Textbox bounds throughout the full streak.

Run with `make test-tower-ui BATTLE_TEST_PYTHON=.venv/bin/python`.
Captures and JSON results are under `.tmpbuild/tower-ui/`.

## Release sound and cartridge clock

**1,517 checks, zero failures**, with sound enabled on the unmodified release
ROM. All **495 playable species** run through native `PlayCry` and `WaitSFX`.
Each cry emits nonzero audio, returns, and releases every cry channel.
The pass also checks map music and save, item, and building-exit effects.

WAV recordings cover the seven recently changed cries: Exeggutor, Alolan
Exeggutor, Espeon, Leafeon, Glaceon, Sylveon, and Porygon-Z. The recordings
and results are under `.tmpbuild/release-audio-rtc/`. These are signal and
termination checks; subjective sound quality still needs human listening.

Clock fixtures initialize the real cartridge-clock path at 23:59:58 on days
5, 12, 19, 138, and 139, advance the emulator RTC, and let release `UpdateTime`
derive midnight/day/weekday rollover. The hardware counter's 140-day wrap
preserves the starting weekday offset. A seven-day jump reaches day 19/Friday
at noon.
The native save and private RTC sidecar survive a fresh release boot/Continue
with the correct calendar. No calendar field is patched to simulate rollover.

Run with `make test-release-av BATTLE_TEST_PYTHON=.venv/bin/python`.
The existing private MBC30 adapter supplies eight-bit ROM banking, SRAM
banks 4–7, and an accelerated cartridge RTC. Its old RTC implementation also
needed corrected signs and time units when writing clock registers; six
independent register-write/persistence probes verify that private adapter.
This is emulator verification,
not a physical cartridge clock test.

## Link trade and battle

**63 checks, zero failures.** A complete native trade verifies species, moves,
trainer ownership, nickname, held item, experience, DVs, stats, PP, and the
two untraded party members on both consoles. Cancellation and room exit work,
and a fresh boot/Continue retains the exchanged parties. A complete three-on-three
linked battle reaches matching win/loss results, handles fainted replacements,
exits normally, and preserves both parties after another fresh boot/Continue.

Two release ROMs boot separate private saves with distinct trainers, species
and moves above index 255, held items, and different party rosters. The cable
runner drives reception and console menus with buttons. Link, RNG, trade,
and battle routines are not stubbed. Comparisons use true species/move
indexes, because runtime byte IDs can differ between cartridges.

The stock shared-memory serial device in the isolated PyBoy 2.8.1 installation
completed transfers without either console driving the clock. That behavior
invalidates Crystal's role negotiation. A private serial adapter supplies
clock-gated bit exchange; the installed emulator and game ROMs are unchanged.
Eight transport checks cover external/external inactivity, master/slave byte
exchange in both directions, and an unconnected receiver reading all ones.
Idle synchronization is coarser than transfer synchronization, so this is a
functional cable model rather than cycle-accurate hardware certification.

The full session results are recorded in `.tmpbuild/link-session/results.json`.
See `tools/battletest/README.md` for the isolated emulator preparation and
`make test-link-session` command.

## Repository checks and scope

The ordinary harness smoke suite passes all eight cases after adding optional
release-ROM/sound/cable constructor parameters. Python compilation, Makefile
target expansion, and `git diff --check` pass. The earlier release/debug build
also passed. These checks use temporary cartridge saves; the player's existing
RAM/RTC sidecars are untouched.

The changes in this pass are test infrastructure and documentation. The ROM
hashes above identify the binaries actually tested. Unrelated working-tree
files were left intact.
