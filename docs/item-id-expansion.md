# Expanded item IDs

Crimson Crystal now has 275 named usable item/TM/HM entries. The 21 added
entries use true item indexes `$0101`–`$0110` and `$0118`–`$011c`; the old item indexes stay stable.
No Plates were added.

The implementation adapts the conversion-table approach from
[pokecrystal16's item branch](https://github.com/fellowship-of-the-roms/pokecrystal16/tree/595068e8313526491c43eecce964f94a35c69250).
It does not merge that experimental branch over Crimson's custom engine.

## Restored items and new stock

Speak to the regular clerk on each floor and choose **new stock**. Declining
opens the floor's original shop.

| Shop | New stock |
| --- | --- |
| Goldenrod Department Store 3F | TinyMushroom, Big Mushroom, Big Pearl, Polkadot Bow, Surf Mail, LiteBlueMail, PortraitMail |
| Goldenrod Department Store 4F | Lovely Mail, Morph Mail, BlueSky Mail, Music Mail, Mirage Mail, Silver Leaf, Gold Leaf |
| Celadon Department Store 3F | Normal Box, Gorgeous Box |
| Celadon Department Store 4F | Rare Bone, Balm Mushroom, Comet Shard, Big Nugget, Pearl String |

The first sixteen entries restore removed items. Normal/Gorgeous Box award
the silver/gold trophy decorations and are consumed. Polkadot Bow provides
the existing 10% Normal-type held boost. All ten Mail designs work, including
their original artwork and palette ordering.

Treasures can be sold at marts. The seven duplicate status Berries were
removed. Saves from the first expansion build resolve Pecha, Rawst, Aspear,
Chesto, Cheri, Persim and Lum to PSNCUREBERRY, Ice Berry, Burnt Berry,
Mint Berry, PRZCUREBERRY, Bitter Berry and MiracleBerry respectively.
Bag/PC stacks normalize on load without losing quantities; saved runtime
held slots and boxed item indexes resolve through the same compatibility
mapping. Their retired indexes `$0111`–`$0117` stay reserved forever, so no
remaining item changes its identity. Save format remains 5.

## Storage and compatibility

- Regular bag and PC rows store `[index high, index low, quantity]`. Removing
  or moving a stack copies a bounded number of bytes; `$ff` inside an index
  cannot accidentally terminate a copy.
- Legacy non-TM item IDs remain fixed. Mail has eight additional fixed byte
  tags so existing message/letter structures can retain their byte layout.
  Other expanded items get temporary runtime IDs, as species/moves already do.
- Bag and PC rows, map pickups, item script operands, marts, boxed held items,
  and the Gen-2 link index packet carry true item indexes. Stored inventories
  and boxes do not consume temporary ID slots. The collector retains active
  held items and menus; exhaustion returns failure instead of looping forever.
- Box records remain 57 bytes. A parallel high-byte array is covered by each
  record's checksum and follows the existing copy-on-write/snapshot lifecycle.
- Save format 5 validates and upgrades formats 3 and 4. The outer SRAM save
  ranges, party records, Pokédex, event flags, box records and metadata keep
  their addresses. Ninety unused saved padding bytes pay for the wider bag/PC.
  Primary and backup item tables have independent checksums/signatures. Legacy
  party/daycare held TMs are remapped before committing those tables, so they
  cannot turn into Mail. An in-progress copy is invalidated until its data and
  tables are committed; interrupted primary upgrades can fall back to backup.
- Both players need this ROM's updated link format. The packet encoder/decoder
  was tested with different runtime tables; a physical cable session was not
  part of this verification. Emulator save states and old save-editor profiles
  are not substitutes for an in-game format-3/4 save.

The existing `pokecrystal.sav` was backed up as
`pokecrystal.sav.before-item16-20261030.bak` and never modified. In a private
emulator comparison, both the original ROM and this ROM rejected that file's
format byte (`$ff`). No attempt was made to rewrite or repair it.

## Adding further items

Append a constant after `PEARL_STRING` and matching rows to the name,
description, attribute and effect tables. Names have at most 12 visible cells;
description lines have at most 18. Add acquisition through a word-based mart,
`giveitem`/`verbosegiveitem`, or an item-ball/hidden-item event. Reserve `$ffxx`
for sentinel indexes. Actual table-bank/ROM capacity still limits the catalogue.

New entries in this change use the regular Item pocket. Key/Ball pockets and
legacy wild/trainer/gift-Pokémon item data retain their compact byte format;
putting an expanded constant directly into those byte data fields is not
supported by this change. Existing content in those fields is unchanged.

## Validation

Release and debug ROMs were built. Private emulator tests cover:

- inventory boundary assertions per ROM, across all 275 usable entries;
- Over 1,000 expansion assertions per ROM, including v3/v4 migration, corrupt saves,
  names/descriptions, all new marts, sorting/merging, boxed held items, native
  trophy-box effects, divergent link tables and temporary-ID exhaustion;
- 6,686 battle regression cases, with no failures/errors/skips;
- separate real-turn tests of all seven retired held-Berry conversions,
  Klutz, and Polkadot Bow damage;
- PC storage/recovery, native consumable menus, Apricorn handoff/crafting/
  collection, item catalogue coverage, and source/layout audits.

The original expansion validation is recorded in
`reports/item-expansion/2026-10-30/validation.json`; the berry-removal checks
are recorded separately in `reports/item-expansion/2026-10-30/berry-removal.json`.

Reproduce the main checks in WSL with the project's virtual environment:

```sh
make -j4
make -j4 debug
.venv/bin/python tools/test_inventory_boundaries.py
.venv/bin/python tools/test_item_expansion.py
.venv/bin/python tools/test_item_expansion.py pokecrystal_debug.gbc
.venv/bin/python tools/battletest/item_expansion_checks.py
.venv/bin/python tools/battletest/runner.py --no-render --jobs 2 --item-matrix --reaction-matrix
.venv/bin/python tools/battletest/kurt_bulk_checks.py
.venv/bin/python tools/audit_save.py
.venv/bin/python tools/audit_game_data.py
```
