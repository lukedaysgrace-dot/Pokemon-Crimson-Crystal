# Item removals and Ditto powders — 2026-11-02

Removed Custap Berry, Salac Berry, Black Sludge, BrightPowder, Red Card,
Heavy-Duty Boots, Blunder Policy and Eject Button from the active catalog.
Names/descriptions/effects are inert placeholders; saved indexes are reserved
under `RETIRED_` constants. Removed BrightPowder from Koga, Janine and all
23 Battle Tower holders. Trainer slots now use no held item.

Wild Ditto is the sole source of Metal Powder (common 20% slot) and Quick
Powder (rare 5% slot), with the standard 75% no-item chance. The common bracket
is 20%, not 10%, in this engine. Existing Quick Powder mechanics are unchanged.

Quick Powder's index is above $ff. Base records now use padding bits 0/1 as
the high bits for their held-item indexes, with `LOW(QUICK_POWDER)` in Ditto's
second slot and padding bit 1 set. `_GetBaseData` converts both full indexes
into runtime IDs, preserving the 32-byte base record and existing save format.
Documentation recognizes the full item name rather than its low byte.

On load, retired Bag/PC stacks are removed and lists compacted without changing
surviving quantities/order. Party and daycare held items are cleared after the
saved item-conversion table loads. Boxed records validate their original checksum
before decoding retired items as no item. Primary and backup saves are covered;
save version stays 5. No real player save files were opened or modified.

Obsolete positive tests for the removed items were replaced by retirement/save
checks; tests for remaining modern held items and their controls remain.
The removed standalone Blunder Policy regression is recoverable from Git.
The unavailable-item list now contains ten items. Generated item guides and
website exports reflect the removals and Ditto's exclusive powder sources.

Validation:

- Both ROMs built successfully with RGBDS 0.5.2.
- New retirement tests: 3,109 checks per ROM, including all 502 base records,
  controlled native wild-item RNG branches, primary/backup loads, Bag/PC
  compaction, party/daycare cleanup and valid old boxed records.
- Existing item expansion/save regressions: 1,197 checks per ROM.
- Item catalog: nine tests pass, including exact remaining unavailable items
  and Ditto-only powder sources/rates.
- Quick Powder: 512 exact native Speed checks pass per ROM.
- Full static audit passed.
- All 3,665 battle cases, including every-move/effect/ability sweeps, passed
  without failures, errors or skips.
- Documentation regenerated: 501 Pokemon, 444 moves, 285 active items;
  zero validation warnings or unparsed rows.
- Simulator selection rejects all retired items; focused regression passed.
- `git diff --check` passed.

Reproduce with `make test-item-retirements`, `make test-inventory`, and
`make audit-static`. The general battle runner also covers remaining item tests.
