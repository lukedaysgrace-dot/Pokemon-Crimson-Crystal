"""Produce a current-source roster review with separately labeled focused results."""
import csv
import json
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
PREVIOUS = ROOT / 'reports/balance/2026-10-27-stat-buffs'
OLD = ROOT / 'reports/balance/2026-10-24-no-items'
data = json.loads((OUT / 'source-data.json').read_text())
verification = json.loads((OUT / 'verification.json').read_text())
focused = json.loads((OUT / 'focused-results.json').read_text())
checks = json.loads((OUT / 'focused-verification.json').read_text())
assert checks['status'] == 'passed'
with (PREVIOUS / 'full-roster-review.csv').open() as f:
    previous = list(csv.DictReader(f))
by_species = defaultdict(list)
for result in focused:
    by_species[result['species']].append(result)
best_results = {name: sorted(results, key=lambda r: (-r['score'], r['ability'], r['label']))[0]
                for name, results in by_species.items()}


def comparison(name):
    best = best_results[name]
    baseline = next(r for r in by_species[name] if r['ability'] == best['ability'] and r['label'] == 'historical-selected-set')
    return f"{name}: {best['score']:.1%} versus {baseline['score']:.1%} for the same-ability historical moveset; {best['ability']}, {best['moves']}"

overrides = {
    'HITMONLEE': ('Requested redistribution applied; hold', 'Attack 130 / Sp. Def 100, unchanged 485 BST. Reckless power and physical frailty are intentional; do not stack more offense before full-roster retesting.'),
    'HITMONTOP': ('Requested redistribution applied; hold', 'Attack 105 / Sp. Def 100, unchanged 485 BST. Keep Intimidate, Technician, priority and removal roles distinct from Hitmonlee.'),
    'HITMONCHAN': ('Requested redistribution applied; hold', 'Attack 115 / Sp. Def 100, unchanged 485 BST. Fresh punch/priority comparisons replace the previous conditional Attack-buff suggestion.'),
    'PERSIAN': ('Requested buff applied; coverage candidate', 'Attack 100 with 115 Speed. The tested physical/special alternatives remained weak on the panel. If it still needs help, consider optional Low Kick coverage (currently absent), rather than another Attack/Speed buff.'),
    'PERSIAN_ALOLAN': ('Requested buff applied; hold', 'HP 70 / Sp. Atk 100 with 115 Speed. Fur Coat and Prankster add significant role value; do not also buff Speed or physical Defense.'),
    'PERRSERKER': ('Requested buff applied; hold', 'Sp. Def 95 complements 85 HP / 100 Defense. Tough Claws and Steely Spirit already support its offense; retain 50 Speed.'),
    'PINSIR': ('Conditional Speed-buff candidate', 'Speed 85 -> 95 remains a modest experiment if its physical breaker role needs help. Keep 125 Attack; do not add another damage multiplier at the same time.'),
    'EXEGGUTOR_ALOLAN': ('Conditional bulk-buff candidate', 'Consider Sp. Def 75 -> 85 only after the fresh Rock Head sets and Harvest team role. Retain 45 Speed and the Ice weakness.'),
    'HYPNO': ('Focused role tested; hold', 'Fresh sleep/setup options checked. Put the earlier Sp. Atk-buff suggestion on hold while evaluating its existing disruption/team role.'),
    'BRELOOM': ('Focused coherent sets tested; hold', 'Fresh Spore/Bullet Seed/Mach Punch/Drain Punch and sleep/setup sets checked under all abilities. Do not increase 130 Attack from the old F-tier placing.'),
    'GALLADE': ('Focused Sharpness sets tested; hold', 'Fresh Sacred Sword/Psycho Cut sets checked under every ability. Retain 125 Attack; broader matchups are needed before a stat buff.'),
    'CLOYSTER': ('Focused Skill Link sets tested; hold', 'Fresh Shell Smash/Icicle Spear/Rock Blast combinations checked. Do not add Attack or Speed from the old Shell Armor placement.'),
    'POLIWRATH': ('Secondary Attack-buff candidate', 'A modest Attack 95 -> 105 could help its physical role if Iron Fist/Drain Punch/Mach Punch sets remain weak. This species was source-reviewed, not included in the new 12-species battle panel.'),
    'BANETTE': ('Secondary bulk-buff candidate', 'HP 64 -> 74 is a possible small experiment if frailty remains a problem. Lower priority: Ghost/Normal immunities and Prankster require team-role checks first.'),
}
rows = []
for old in previous:
    name = old['species']
    record = data['species'][name]
    row = dict(old)
    row.update({'current_' + key: value for key, value in record['stats'].items()})
    row['current_bst'] = sum(record['stats'].values())
    row['review_action'], row['reason'] = overrides.get(name, (old['review_action'], old['reason']))
    own = sorted(by_species.get(name, []), key=lambda r: (-r['score'], r['ability'], r['label']))
    best = own[0] if own else None
    baseline = next((r for r in own if best and r['ability'] == best['ability'] and r['label'] == 'historical-selected-set'), None)
    row.update({'focused_best_score': best['score'] if best else '', 'focused_best_ability': best['ability'] if best else '',
                'focused_best_moves': best['moves'] if best else '', 'focused_best_opening': best['opener'] if best else '',
                'focused_same_ability_baseline': baseline['score'] if baseline else '',
                'focused_games_per_build': 32 if best else '', 'focused_unresolved': best['unresolved'] if best else ''})
    rows.append(row)
assert len(rows) == len({r['species'] for r in rows}) == 231
assert sum(len({a for a in data['species'][r['species']]['abilities'] if a != 'NO_ABILITY'}) for r in rows) == 664
with (OUT / 'full-roster-review.csv').open('w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)

lines = ['# Roster review after the Hitmon and Meowth-family changes', '',
         'October 27, 2026. Internal development report; off the public website.', '',
         '**All 231 previously eligible Pokémon/forms and 664 legal ability combinations were reviewed again.** '
         'Current source stats, legal moves, abilities, old league matchups and per-ability/moveset results were considered. '
         'Starter families and unevolved stages remain excluded. A new focused comparison adds 3,456 real-ROM battles '
         'for 12 selected species, 108 builds, all their legal abilities, 16 opponents and both battle orientations.', '',
         'The old 148,562-battle tier list remains historical October 24 evidence. Fresh focused scores below use the '
         'updated ROM and a small shared panel; they are not new league win rates or an updated tier list. '
         'They do not isolate the causal effect of a stat buff because this is not a paired pre-change/post-change ROM experiment.', '',
         '## Applied this turn', '', '| Pokémon | Changes | New BST |', '|---|---|---:|']
labels = {'hp': 'HP', 'attack': 'Attack', 'defense': 'Defense', 'speed': 'Speed', 'sp_attack': 'Sp. Atk', 'sp_defense': 'Sp. Def'}
for name in ('HITMONLEE', 'HITMONTOP', 'HITMONCHAN', 'PERSIAN', 'PERSIAN_ALOLAN', 'PERRSERKER'):
    change = verification['changes'][name]
    fields = [f"{label} {a} → {b}" for (key, label), a, b in zip(labels.items(), change['before'], change['after']) if a != b]
    lines.append(f"| {name} | {'; '.join(fields)} | {change['bst_after']} |")
lines += ['', 'The three Hitmons each remain at 485 BST. The earlier Zangoose, Ariados, Ludicolo and Venomoth buffs are retained. '
          'Only the six requested species stat records changed from this turn’s saved source-data baseline. Regular and debug builds '
          'passed compiled checks for all 498 species, all 442 moves and weights; source/documentation metadata checks passed.', '',
          '## Fresh focused comparisons', '',
          'Each row shows the best of the tested sets/abilities on the 16-opponent panel (32 games). '
          'The baseline column reruns the historical selected moveset with that same ability under the same updated ROM, '
          'opponents and seeds. It is not the old league score. Multiple builds were compared, so these selected maxima can '
          'overfit this panel. Two orientations share a seed; they are not 32 independent random trials. '
          'Openers consume actual turns, without free boosts or status. All sides held NO_ITEM. Friendship matches the '
          'historical audit: 0 for Frustration-only builds, otherwise 255, checked in initial native states. '
          'Tied abilities are displayed deterministically; the displayed label does not prove causal superiority.', '',
          '| Pokémon | Best focused score | Same-ability baseline | Ability | Best tested moves |', '|---|---:|---:|---|---|']
for name in by_species:
    own = sorted(by_species[name], key=lambda r: (-r['score'], r['ability'], r['label']))
    best = own[0]
    baseline = next(r for r in own if r['ability'] == best['ability'] and r['label'] == 'historical-selected-set')
    lines.append(f"| {name} | {best['score']:.1%} | {baseline['score']:.1%} | {best['ability']} | {best['moves']} |")
lines += ['', 'See [all 108 focused builds](focused-results.csv), `focused-plan.json` and `focused-verification.json` '
          'for exact openers, versions, counts and verification. Unresolved battles are recorded separately with score bounds. '
          'An early scheduling draft used four repetitions; a later initialization draft used incorrect Frustration friendship. '
          'The final run explicitly uses one repetition and correct friendship on both sides. Only 2,520 exact '
          'scenario/provenance matches were retained from the initialization draft; 936 affected cases were rerun. '
          'Other draft results are excluded (`focused-import.json`).', '',
          '## What the fresh build checks changed', '',
          'These are current-ROM build/strategy comparisons, not stat-buff effects or new roster tiers:', '',
          '- ' + comparison('BRELOOM'), '- ' + comparison('GALLADE'), '- ' + comparison('CLOYSTER'),
          '- ' + comparison('PERSIAN_ALOLAN'), '- ' + comparison('HYPNO'), '- ' + comparison('EXEGGUTOR_ALOLAN'), '',
          'Hold further Alolan Persian buffs and put Hypno’s earlier proposed Special Attack increase lower on the list. '
          'Evaluate Breloom, Gallade and Cloyster using coherent ability/moveset combinations before assigning more stats. '
          'Alolan Exeggutor remains a conditional durability candidate, with the caveat that the panel contains strong Ice '
          'opponents and omits Harvest team/item play.', '',
          '## Further changes to consider', '',
          'Further changes are proposals only. Preserve different power bands and weaknesses; do not chase 50% solo wins for every Pokémon.', '',
          '- **Pinsir:** Speed 85 → 95 remains a possible small experiment; keep 125 Attack and its frailty. '
          'The new setup/priority checks should inform whether this is necessary; avoid stacking a damage-ability buff.',
          '- **Alolan Exeggutor:** Special Defense 75 → 85 is conditional on its remaining weakness after coherent Rock Head sets '
          'and actual Harvest team play. Preserve 45 Speed and its severe Ice weakness.',
          '- **Persian:** If the new 100 Attack still leaves it struggling, consider adding **Low Kick** as optional coverage '
          'instead of more stats. It currently lacks the move; this could give a focused answer to Rock/Steel opponents. '
          'This learnset change has not been applied or tested.',
          '- **Poliwrath:** Attack 95 → 105 is a secondary candidate to reinforce its physical role. '
          'Its Iron Fist punches and Water Absorb/rain role need targeted testing; no fresh battles for it are claimed here.',
          '- **Banette:** HP 64 → 74 is a lower-priority option if frailty remains a problem. Its Ghost/Normal immunities, '
          '125 Attack and Prankster warrant team testing before more bulk.', '',
          'Do not immediately buff the Hitmons or Meowth-family members again after these changes. '
          'Breloom, Gallade and Cloyster now have fresh coherent-set comparisons; their old low ranks alone do not justify more stats. '
          'Likewise, preserve the intended utility of Blissey, Xatu, Smeargle, Ditto, Regenerator, hazards and weather teams.', '',
          '## Nerf watch', '',
          '- **Bloodmoon Ursaluna:** If its old 76.7% result exceeds its intended rare/endgame power, test removing Counter first. '
          'Keep its special-attacker identity; do not cut stats, coverage and Berserk together.',
          '- **Wobbuffet:** Its old 90.2% is a real outlier, but moveset-aware retaliation selection and no switching strongly favor it. '
          'Only consider HP 190 → 175 after human/team play confirms excess strength; retain Counter/Mirror Coat.',
          '- **Kangaskhan:** Review Parental Bond with fixed-damage moves if it proves oppressive. '
          'An Attack cut would not address fixed damage. No new independent probe of that interaction is claimed here.', '',
          'No blanket nerf to legendaries, high-end dragons, Sturdy, Filter, Sharpness or weight formulas is supported. '
          'Fresh full HP and a solo battle format are favorable conditions for some builds.', '',
          '## Full roster decisions', '',
          'Stats: **HP / Attack / Defense / Speed / Special Attack / Special Defense**. Old scores are pre-buff league scores. '
          'The detailed CSV includes each Pokémon’s abilities, old selected set, validation alternatives, focused results where available and rationale.', '',
          '| Pokémon | Old league score | Current stats | Decision |', '|---|---:|---|---|']
for row in rows:
    stats = [row['current_' + key] for key in labels]
    lines.append(f"| {row['species']} | {float(row['old_no_item_score']):.1%} | {' / '.join(map(str, stats))} | {row['review_action']} |")
(OUT / 'REVIEW.md').write_text('\n'.join(lines) + '\n')
receipt = {'reviewed_species': 231, 'reviewed_ability_combinations': 664,
           'historical_league_battles': 148562, 'fresh_focused_battles': 3456, 'fresh_species': 12,
           'current_data_sha256': data['data_sha256'], 'categories': dict(Counter(r['review_action'] for r in rows)),
           'further_changes': 'proposals only; six requested stat changes applied'}
(OUT / 'roster-review.json').write_text(json.dumps(receipt, indent=2))
print(json.dumps(receipt))
