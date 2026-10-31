# Unplaced items (no player source yet)

These items are fully implemented (name, description, held effect, battle logic)
but currently have **no way for the player to get them**. The Oct 30 battle-item
batch was pulled from the Goldenrod 3F/4F and Celadon 4F "new battle items"
clerk menus; Brightpowder was pulled from the Mahogany held-item shop.

| # | Constant | In-game name | Effect (description) | Price |
| --- | --- | --- | --- | --- |
| 1 | BRIGHTPOWDER | Brightpowder | Lowers the foe's accuracy. | ₽10 |
| 2 | COVERT_CLOAK | Covert Cloak | Blocks extra move effects. | ₽4,000 |
| 3 | CLEAR_AMULET | Clear Amulet | Prevents a foe's stat drops. | ₽4,000 |
| 4 | METRONOME_ITEM | Metronome | Repeat a move to boost it. | ₽4,000 |
| 5 | HEAVY_DUTY_BOOTS | Heavy-Duty Boots | Avoids all entry hazards. | ₽4,000 |
| 6 | RED_CARD | Red Card | Hit by a move, ejects foe. | ₽2,000 |
| 7 | EJECT_BUTTON | Eject Button | Hit by a move, switches. | ₽2,000 |
| 8 | POWER_HERB | Power Herb | Skips charging a move once. | ₽2,000 |
| 9 | WHITE_HERB | White Herb | Restores lowered stats once. | ₽2,000 |
| 10 | BLACK_SLUDGE | Black Sludge | Poison types heal; others are hurt. | ₽4,000 |
| 11 | LIGHT_CLAY | Light Clay | Screens last eight turns. | ₽4,000 |
| 12 | THROAT_SPRAY | Throat Spray | Sound moves raise Sp. Atk. | ₽2,000 |
| 13 | PUNCHING_GLOVE | Punching Glove | Boosts punches; no contact. | ₽4,000 |
| 14 | QUICK_POWDER | Quick Powder | Doubles Ditto's Speed. | ₽4,000 |
| 15 | SAFETY_GOGGLES | Safety Goggles | Blocks powders and weather. | ₽4,000 |
| 16 | BIG_ROOT | Big Root | Boosts HP drained from a foe. | ₽4,000 |
| 17 | BLUNDER_POLICY | Blunder Policy | A miss sharply raises Speed. | ₽2,000 |
| 18 | CUSTAP_BERRY | Custap Berry | Move first once at low HP. | ₽100 |
| 19 | SALAC_BERRY | Salac Berry | Raises Speed once at low HP. | ₽100 |

Notes
- Brightpowder is still held by trainers (Janine's and Koga's Crobat), so Thief
  is the only way a player could get it, and only if stolen items stay with the player.
- Gold Berry was also in the removed Celadon battle-item menu, but it is still
  available elsewhere (Ruins of Alph item room, NPC trade, wild Furret/Alolan Exeggutor).
- To place these, use `itemball` / `hiddenitem` / `verbosegiveitem` in map scripts,
  wild held items in `data/pokemon/base_stats/`, or a new mart list in
  `data/items/marts.asm`, then rerun `python tools/generate_item_locations.py`.
