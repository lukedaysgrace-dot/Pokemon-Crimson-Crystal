# Kurt's full Apricorn batches

Selecting an Apricorn color gives Kurt every Apricorn of that kind across all
stacks in the Items pocket. There is no quantity prompt. Other colors stay in
the Bag. The menu shows the full total, including four-digit batches.

Kurt walks to the workbench after the handoff and stays busy for the current
visit. Leave the house and return: he is back in his usual spot with the crafted
Balls. The GS Ball investigation retains its separate daily timer.

Collection fills available Ball stacks and pocket slots. Any Balls that do not
fit remain owed; talk to Kurt again after making space. A pending batch prevents
a new handoff until collection is complete.

## Save compatibility

The existing color events and quantity byte remain at their original offsets.
Two previously unused saved bytes hold a batch marker and the high quantity
byte, allowing up to the full Items pocket capacity (3,960 Apricorns). Unmarked
legacy batches use their original one-byte count. Save format and region sizes
are unchanged.

## Validation

Run `make test-kurt-bulk` after building both ROMs. The checks cover every color,
multiple stacks, quantity boundaries through 3,960, stable Bag compaction,
partial/full pocket collection, legacy batches, and an ordinary save/load.
Native emulator cases exercise cancellation, all three approach sides, the
workbench walk, busy dialogue, real door exit/re-entry, and all seven rewards.
Screenshots are written under `.tmpbuild/kurt-bulk/` for each ROM.

The GS Ball quest, overworld state, linked save layout, and ROM resources also
pass their existing regression checks.
