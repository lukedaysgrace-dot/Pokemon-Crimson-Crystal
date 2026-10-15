# Architecture and scope

`src/extractors` is a Node-only source/ROM extractor. It interprets RGBDS constants,
derives layout profiles from linked symbols, verifies base stats, abilities,
types, moves, item pockets and TM tables against the ROM, and reads compiled
indirect learnset/evolution tables. Unknown consumed expressions fail with source
locations. Source identifiers are the identity keys; display names may collide.
Normal/shiny first-frame PNGs are local and shared by a hash of their content.

`src/lib/save` contains pure TypeScript modules with no Svelte dependency. Models
retain original raw bytes. Writers operate on a copy, encode changed entities,
mirror both save copies/tables/snapshots, fix checksums in dependency order and
reparse before returning. Clean no-op exports are byte-identical. Unmodeled bytes
and RTC trailers are retained. Table allocation never evicts live IDs.

`src/lib/components/MonEditor.svelte` and `src/routes/+page.svelte` implement the
client-only UI. Validation errors disable download and warnings require review.
Party mail can be preserved or initialized as a blank message. Daycare editing
uses initialized slots, including pending egg names; occupancy is managed in-game.
Migration explicitly requires a valid target save and retains target world state.

GitHub Actions builds RGBDS 0.5.2 from source and release/debug ROMs, verifies the
layout lock, runs unit/browser/emulator tests, and produces the static site as an
artifact. The data updater makes a review PR in this same repository; no cross-repo
dispatch secret is needed. Hosting activation is left to the repository owner;
the existing `docs/` website is not replaced.

Current boundaries: static first-frame sprites, no animated GIF generation; hex
inspection/diffs rather than arbitrary raw-byte writes; mail starts blank rather
than offering a freeform message composer; warp editing and automatic test-team
generation are not exposed. Unknown old layouts are read-only until their exact
source/ROM/symbol profile is extracted. The currently present `pokecrystal.sav`
does not validate against either included profile and is deliberately not edited.

One real pre-fix fixture contains `ELEMENTAL_SPHERE` in the Items pocket although
both ROM builds declare it a Key Item. Its checksums validate; the editor correctly
reports the pocket error. The regression test moves that stack to Key Items before
export. The earlier elemental-sphere fixture passes an unchanged byte-identical
round trip. These facts refine the plan's assumption that both fixtures have no
semantic errors.
