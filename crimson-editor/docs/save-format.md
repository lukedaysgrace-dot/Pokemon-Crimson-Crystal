# Save format

The source of truth is §4 of [the repository implementation plan](../../CRIMSON_EDITOR_IMPLEMENTATION_PLAN.md),
plus the source and `.sym` of the build in each generated bundle. See also
[PC storage](../../docs/pc_storage_design.md).

- Eight 8-KiB SRAM banks, plus a preserved optional RTC trailer (0–64 bytes).
- Main and backup saves each have a game-data checksum and move-table checksum.
  Update the move checksum first because its field is inside the game checksum.
- Normal loading uses main game data with backup box metadata. If main validates
  and the backup phase is interrupted, use active box metadata. If main is invalid,
  use the valid backup and backup metadata. With neither valid, refuse export.
- Runtime party IDs resolve through the save's LE16 conversion-table entries.
  Box records store true indexes. New IDs allocate a free entry without eviction.
- Party structs, boxed records, names, counts, pool boundaries, constants and
  field offsets come from generated symbols/constants rather than fixed addresses.
- Box-record checksums are weighted byte sums. Corrupt records are shown as Bad
  Eggs and cannot be silently repaired by an unrelated edit.
- Stored shiny/male flags, ability slots, explicit Hidden Power types, integer
  growth/stat formulas and per-save gameplay rules follow Crimson semantics.

Both physical copies and both box snapshots are synchronized on edited export;
the backup-phase flag is cleared. Unchanged clean saves return their original
bytes. Unknown entities fail validation and remain inspectable.
