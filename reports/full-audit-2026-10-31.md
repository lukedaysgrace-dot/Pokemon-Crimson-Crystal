# Crimson Crystal audit — 2026-10-31

Scope: every Pokémon front/back/menu-icon/overworld-icon graphic (decoded from the
built `.2bpp` files with the real `front.gbcpal` palettes, i.e. what the ROM shows),
shiny palettes, and all 35,794 text strings (spell-check + line-width + grammar
patterns), with a manual read of the ~5,500 lines that differ from vanilla pokecrystal.
The repo's own audits (`audit_game_data`, `audit_mon_icons`, `audit_trainers`,
`audit_map_sprites`, `audit_trainer_sprites`, `audit_npc_walking`) all pass.

Visual evidence is in `reports/sprite-audit-2026-10-31/`:
`sheet_01..10.png` (every species: front, back, menu icon, shiny front, all in
in-game colors), `zoom_icons.png`, `zoom_flagged.png`, `overworld_icon_check.png`.

---

## 1. Sprites — real bugs

| # | Mon | Problem | Fix |
|---|-----|---------|-----|
| 1 | **Scyther** | `gfx/pokemon/scyther/back.png` is **96×96** (2304-byte 2bpp). Backpics must be 48×48 — in battle it will show as garbage. Came in with commit `bbcf9aa4` (Aug 2). It's a clean 2× upscale. | Resize to 48×48, nearest-neighbor. |
| 2 | **Frigibax** | `back.png` is **40×40** (25 tiles) since it was added. Engine expects 6×6 tiles → scrambled back sprite. | Pad/redraw to 48×48. |
| 3 | **Aron, Lairon, Aggron, Bastiodon** (menu icons) | Their main body color `(248,152,80)` compiles to **index 0 = transparent**, and the outline is drawn in a mid color, so the party/PC icon is a see-through ghost outline. Cause: the PNGs contain a near-black `(0,0,1)` plus real transparency, which throws off rgbgfx's color order. | Re-save as 4-color indexed PNG: white/transparent, light, dark, black. |
| 4 | **54 overworld icons** (`gfx/icons/`) | Same `(0,0,1)` problem: outline compiles to index 2 (colored, not black) and orange areas become transparent. Affected: aerodactyl, azumarill, bastiodon, bayleef, bellossom, blastoise, blissey, caterpie, cleffa, corsola, dragonair, dragonite, forretress, hitmonlee, hitmontop, ho_oh, hoothoot, horsea, igglybuff, kabutops, kingdra, larvitar, mantine, mareep, meganium, miltank, misdreavus, pichu, piloswine, pineco, pinsir, ponyta, pupitar, quagsire, qwilfish, rapidash, sandslash, scizor, scyther, seadra, shuckle, skarmory, slowking, smoochum, snubbull, stantler, tangela, typhlosion, tyrogue, umbreon, ursaring, victreebel, wobbuffet, xatu. Seen anywhere a species is a map sprite (Day-Care, map Pokémon). | Same re-index as #3. |
| 5 | **Squirtle (clone)** | Shares `SquirtleMenuIcon`, but its `front.png` palette order is reversed vs Squirtle (slot 1 = blue, slot 2 = tan). Icon shows a **brown/tan Squirtle with blue shell**. | Swap the two middle colors' order in `squirtle_clone/front.png` (and back), or give it its own icon. |
| 6 | **Shelgon** (menu icon) | Shell drawn in the dark slot → **red shell** (red is only for eyes/feet on the front). | Swap light/dark gray in the icon. |
| 7 | **Lucario** (menu icon) | Body uses slot 2 → **yellow Lucario** with blue accents. | Swap light/dark in the icon. |
| 8 | **Bulbasaur + Bulbasaur (clone)** (menu icon) | Bulb drawn in slot 2 → **red bulb** (slot 2 is the eye/mouth red). | Redraw bulb in slot 1 (green) + black. |
| 9 | **Gallade** | `data/menu_icon_pointers.asm:277` points at `GardevoirMenuIcon` — no Gallade icon exists. | Add `gfx/menu_icons/gallade.png`. |
| 10 | **Dusknoir shiny** | `gfx/pokemon/dusknoir/shiny.pal`: `RGB 32, 24, 01`. Max is 31; 32 overflows into green, so the shiny shows **(0, 25, 1) green** instead of gold. | Change to `RGB 31, 24, 01`. |
| 11 | **Ursaluna (Bloodmoon) shiny** | `shiny.pal` is identical to the normal palette — shiny looks the same as normal. | Give it real shiny colors. |
| 12 | **Golbat** front + back, **Chikorita** back | PNG is newer than the built `.2bpp`/`.gbcpal` — the current ROM still has the old art (Golbat's old/new pixels don't line up at all). | Just rebuild (`make`). |

Front vs back color matching: after the repo's earlier back-color fix pass, **no
back sprite has swapped or off-palette colors** (all 497 checked; Finizen/Palafin use
their intentional back palettes).

Possible (judgement calls): Cetitan's icon is mostly pink while the front is mostly
white; Phantump's icon reads greener than the front. Several shiny palettes reverse
light/dark order (Spearow, Bellossom, Dipplin, Hydrapple, Ursaring-BM, Hisuian
Sneasel) — looked fine on the sheets, just flagging.

Housekeeping: ~90 unused PNGs in `gfx/menu_icons/` with no `.2bpp` (old class icons,
Unown letters, `mr_mime`/`mrmime`, etc.). Harmless.

---

## 2. Dialogue / text

The text is in good shape — no spelling errors in normal words, no hyphenation
breaks that join into a misspelling, and no dialogue lines over 18 characters.
What I found:

### Typos / grammar
| File:line | Current | Suggested |
|---|---|---|
| `data/pokemon/dex_entries/lucario.asm:10` | "lets it strike / great precision." | "…strike with / great precision." (re-wrap) |
| `data/pokemon/dex_entries/raticate_alolan.asm:8-9` | "most nutritious / delicious fare." | "most nutritious, / delicious fare." |
| `data/pokemon/dex_entries/rookidee.asm:10` | "tough and bolder." | "tougher, bolder." |
| `data/pokemon/dex_entries/trevenant.asm:10` | "forest POKEMON." | "forest #MON." (missing é) |
| `data/pokemon/dex_entries/seviper.asm` | "It has a long rivalry with ZANGOOSE nearby and attacks." | e.g. "It has a long rivalry with ZANGOOSE and attacks it on sight." |
| `engine/events/move_deleter.asm:493-496` | "Which #MON / would you like // to make remember / a move?" | "Which #MON / should remember / a move?" |
| `data/text/common_2.asm:1028-1030` | "This Fishing / Competition winner / is" | "This Fishing / Contest's winner / is" (everything else says "Contest") |
| `data/abilities/descriptions.asm:825` | "Bypass evasion and" | "Bypasses evasion and" (matches the other entries) |
| `data/items/descriptions.asm:1195` | "others hurt.(HOLD)" | "others hurt. (HOLD)" |
| `maps/FuchsiaGym.asm:356` | "A true ninja never reveals his face." | Fine if that trainer is male; if it's meant to be Janine, "her". |

### Line width (dex entries, 18 chars max)
- `data/pokemon/dex_entries/dugtrio_alolan.asm:6` — "it's not very fast," (19)
- `data/pokemon/dex_entries/rapidash_galarian.asm:6` — "RAPIDASH's horn can" (19)

### Placeholder Pokédex entries (52)
These still say "…was newly added to the #DEX. Its data can be expanded as the hack
develops.": abomasnow, altaria, anorith, appletun, applin, archaludon, breloom,
buneary, camerupt, centiskorch, charjabug, croagunk, dipplin, drifblim, drifloon,
drilbur, duraludon, excadrill, flapple, fletchinder, fletchling, flygon, froslass,
golisopod, grubbin, grumpig, hydrapple, kingambit, lombre, lopunny, lotad, ludicolo,
numel, overqwil, scrafty, scraggy, sealeo, shroomish, sizzlipede, snorunt, snover,
spheal, spoink, swablu, talonflame, toxicroak, trapinch, ursalunabm, vibrava,
vikavolt, walrein, wimpod.

### Consistency nits (optional)
- `maps/Route45.asm:590, 613, 673` use `...` (three periods); the rest of the game uses `…`.
- Ability descriptions use mixed case (`Speed`, `Sp.Atk`, `Fire`) while items/moves use
  caps (`SPEED`, `SPCL.ATK`); `descriptions.asm:965` uses caps "STEEL and POISON".
- "Eggs" vs "EGGS" in `engine/pc/bills_pc_ui.asm` (3535 vs 3673).
- "Apricorn" (electrode_hisuian dex) vs "APRICORNS" elsewhere; "Shell-der" in
  slowking_galarian dex vs "SHELLDER".
- Mild language: `maps/RadioTower4F.asm:191` "Damn it!" and
  `maps/SlowpokeWellB1F.asm:260` "a damn". Fine if intended.
