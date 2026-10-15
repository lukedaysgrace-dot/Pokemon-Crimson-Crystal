# Crimson PC storage

The storage backend is implemented by `engine/pc/storage.asm` and
`engine/pc/storage_codec.asm`. The editor's generated layout reads all addresses
from the matching linked `.sym`; the following sizes describe the current format.

There are 25 logical boxes with 20 slots. Each box has 33 bytes: 20 entry numbers,
three LSB-first pool-selection bytes, a nine-byte padded name (eight editable
characters), and one theme byte. Zero is an empty slot. Entries 1–254 select a
record in pool 1 or 2. Both pools have sections A (143 records) and B (111 records),
each in its own SRAM bank. Section C currently has zero entries.

A record is 57 bytes: LE16 species index, held item, four low move bytes, BE16
OT ID, BE24 experience, five BE16 Stat Exp values, two DV bytes, four packed
move-high/PP-Up bytes, happiness, packed Pokérus/male/shiny, two caught bytes,
level, personality, egg/Hidden-Power flags, ten nickname bytes, ten OT bytes,
and an LE16 checksum. Offsets are declared by `SAVEMON_*` constants. The checksum
is `0x7f + sum(record[i] * (55-i), i=0..54)`, modulo 65536. A mismatch becomes
a Bad Egg. Current PP, HP, status and stats are reconstructed on withdrawal.

Two snapshots of box metadata are saved. The backup snapshot normally wins on
load. When the main save validates and `sWritingBackup` is one, the active
snapshot is copied to backup first. If main is corrupt, a valid backup save and
backup snapshot win. Runtime writes use copy-on-write and never overwrite a
record referenced by either snapshot. The offline editor reserves both snapshots
when allocating and mirrors the final metadata. Orphaned records are preserved.

Party IDs are runtime bytes translated through per-save species/move tables;
box indexes are true indexes. Never write an index directly to a party ID field.
The complete specification is in `CRIMSON_EDITOR_IMPLEMENTATION_PLAN.md`, §4.
