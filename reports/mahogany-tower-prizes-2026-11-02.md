# Mahogany supplies and Battle Tower prizes — 2026-11-02

Mahogany's post-hideout grandmother now opens a single standard mart with the
original Crystal stock: RageCandyBar, Great Ball, Super Potion, Hyper Potion,
Antidote, Parlyz Heal, Super Repel, Revive and Flower Mail. Added White Herb,
Power Herb and Throat Spray at 1,000 each. All twelve items are repeatable,
unlimited purchases; the three additions also support the standard quantity
limit of 99. The existing hideout-cleared callback still controls her presence,
including older saves. No held-item markup applies to this standard shop.

The former eleven battle items are selectable Battle Tower prizes:

- Eviolite, Rocky Helmet, Air Balloon, Muscle Band, Wise Glasses, Expert Belt.
- Flame Orb, Toxic Orb, Assault Vest, Life Orb, Wide Lens.

These join Choice Band, Choice Specs, Choice Scarf, Focus Sash and Weakness
Policy. Three menu pages expose all sixteen options. A completed seven-win
challenge awards one selected item; further completed challenges award more.
The shared give-prize path preserves the existing cancel/full-Bag behavior.
Existing world rewards for these items are retained; their Mahogany sale is
removed. The unused old mart ID remains reserved with empty stock.

Purchase bookkeeping now records sold-out bits only for the bargain shop.
Its one-byte bitmap must not receive writes from ordinary shops with more
than eight rows. Ordinary and held-item purchases leave it and adjacent bytes
unchanged; the bargain shop's three limited-stock bits still work normally.

Validation completed:

- Both ROMs built successfully with RGBDS 0.5.2.
- 1,285 native item/mart/save checks passed per ROM, including all twelve
  stock entries and BCD prices, repeat purchases, 1/2/33/99-unit subtotals,
  save compatibility and bargain flag boundaries.
- Eleven catalog tests passed, including three exclusive Mahogany shop routes
  priced at 1,000 and Battle Tower routes for all eleven transferred items.
- Full `make audit-static` passed.
- Native Tower UI: 98 checks passed with no failures, including a real seven-win
  streak, all sixteen prize choices, canceling on all three pages, full-Bag
  recovery, Save/fresh Continue, and no duplicate reward after a saved claim.
- All three captured prize menus were visually inspected; names/navigation fit.
- Documentation regenerated with zero validation warnings/unparsed rows.
- `git diff --check` passed.

Native prize UI validation uses `tools/battletest/tower_ui_checks.py`; captures
and results are under `.tmpbuild/tower-ui/`.
The control driver waits for prize-menu teardown before pressing A again, so
it cannot accidentally reopen the receptionist after a successful claim.
The fresh-Continue text observer also initializes its ordered-text list.
