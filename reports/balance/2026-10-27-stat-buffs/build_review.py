"""Reproduce the internal source/data review; does not run battles or edit game data."""
import csv
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
OLD = ROOT / 'reports/balance/2026-10-24-no-items'
data = json.loads((OUT / 'source-data.json').read_text())
ranking = json.loads((OLD / 'tier-list.json').read_text())
verification = json.loads((OUT / 'verification.json').read_text())
ability_rows = {}
with (OLD / 'ability-best-builds.csv').open() as f:
    for row in csv.DictReader(f):
        ability_rows.setdefault(row['species'], []).append(row)

notes = {}


def mark(names, action, reason):
    for name in names.split():
        notes[name] = (action, reason)


mark('PERSIAN', 'Buff candidate', 'Try Attack 90 -> 100; retain 115 Speed/frailty. Compare Technician/Fake Out and special sets.')
mark('PINSIR', 'Buff candidate', 'Try Speed 85 -> 95; retain 125 Attack/65 HP. Do not stack a damage-ability buff in the same pass.')
mark('EXEGGUTOR_ALOLAN', 'Conditional buff candidate', 'Sp. Def 75 -> 85 if Rock Head/Wood Hammer and Harvest team sets still struggle. Keep 45 Speed/Ice weakness.')
mark('HITMONCHAN', 'Retest; secondary buff', 'Selected Iron Fist without a punching attack. Test Drain Punch/Mach Punch/elemental punches; only then consider Attack 105 -> 115.')
mark('HYPNO', 'Retest; secondary buff', 'Already No Guard/Hypnosis/Wish/Nasty Plot. Test that role first; only then consider Sp. Atk 73 -> 85.')
mark('WOBBUFFET', 'Nerf watch; format check', 'Moveset-aware Counter/Mirror Coat policy favors it. Test human/team play; preserve its defining moves. HP 190 -> 175 only if dominance is confirmed.')
mark('URSALUNABM', 'Conditional learnset nerf', 'If above intended rare/endgame power, test removing Counter. Keep its special-attacker identity; avoid simultaneous stat/coverage/ability cuts.')
mark('KANGASKHAN', 'Interaction watch', '69.1% alone is not excessive. Review Parental Bond/fixed damage in team play; Attack changes do not fix fixed damage.')
mark('BRELOOM', 'Targeted set retest', 'Test Technician Spore/Bullet Seed/Mach Punch/Drain Punch together before buffing 130 Attack.')
mark('GALLADE', 'Targeted set retest', 'Selected Steadfast set lacked Fighting STAB. Test Sharpness/Sacred Sword/Psycho Cut with useful coverage or priority.')
mark('CLOYSTER', 'Targeted set retest', 'Test Shell Smash + Skill Link + Icicle Spear/Rock Blast together, rather than buffing from the selected Shell Armor RestTalk score.')
mark('LUDICOLO', 'Requested buff applied; rain retest', 'Attack now 90, matching Special Attack. Compare physical/mixed and special rain roles; the historical score used 70 Attack.')
mark('VENOMOTH', 'Requested buff applied; setup retest', 'Special Attack now 115. Compare Quiver Dance/Tinted Lens and Compound Eyes/Sleep Powder before further buffs.')
mark('ZANGOOSE', 'Requested buff applied; hold', 'Attack now 125, Speed 110. Retest Sharpness/Scrappy builds before adding coverage or more stats.')
mark('ARIADOS', 'Requested buff applied; hold', 'Speed now 100 with 110 Attack. Retest offense and Sticky Web before changing abilities or bulk.')
mark('SMEARGLE', 'Team-role retest; no stat buff', 'Sketch/Spore/hazards/Baton Pass are understated in a lone duel; raising stats can break support.')
mark('DITTO', 'Role retest; no stat buff', 'Imposter copying/revenge role depends on opposing boosts, HP and speed ties; no general stat buff.')
mark('BLISSEY', 'Keep specialist identity', 'Special wall/team support; retain its intentional physical Defense weakness.')
mark('XATU ESPEON', 'Support/set retest', 'Magic Bounce/support needs meaningful hazards and switching before a stat buff.')
mark('MUK TANGROWTH CORSOLA TOXAPEX SLOWBRO SLOWKING SLOWKING_GALARIAN HYDRAPPLE STARMIE CURSOLA', 'Team-role retest', 'Regenerator/pivot/support value needs a continuing team battle; preserve intended weaknesses.')
mark('TREVENANT EXEGGUTOR', 'Item/weather-role retest', 'Harvest/sustain role loses opportunities without items; evaluate intended conditions before more power or Speed.')
mark('MAROWAK MAROWAK_ALOLAN', 'Item/role retest', 'Itemless result omits Thick Club; avoid Attack buffs that become excessive with existing items.')
mark('BANETTE', 'Support/set retest', 'Already Ghost/Normal, 125 Attack, Prankster and multiple immunities; test utility role before adding bulk.')
mark('SALAZZLE VICTREEBEL', 'Status/weather-role retest', 'Deliberate Corrosion/Poison Puppeteer or sun/status builds before more stats.')
mark('WEAVILE SCOLIPEDE AMBIPOM LUCARIO', 'Ability/set retest', 'Priority, multi-hit, setup or category/ability synergy needs a coherent set check before stat boosts.')
mark('MACHAMP', 'Ability/set retest', 'Compare No Guard/Dynamic Punch and Guts under their intended conditions, rather than buffing base Attack.')
mark('AZUMARILL MAWILE', 'Keep damage multiplier in view', 'Huge Power already supplies substantial offense; evaluate coherent STAB/priority builds before adding Attack.')
mark('KINGAMBIT SCRAFTY GYARADOS', 'Team-sweeper retest', 'Supreme Overlord/Moxie needs a continuing team battle to establish sweeping strength.')
mark('SHUCKLE FORRETRESS SKARMORY CORVIKNIGHT', 'Keep defensive/support role', 'Hazards/removal/Body Press and defensive utility need team evaluation, not blanket solo-score buffs.')
mark('BEEDRILL DELIBIRD LEDIAN RATICATE RATICATE_ALOLAN FURRET BUTTERFREE NOCTOWL FEAROW', 'Hold intended power band', 'Already improved or has an early-game/support role; need not match legendary/pseudo-legendary duel strength.')
mark('UNOWN', 'Hold custom niche', 'Already 108 Special Attack, 85 Speed and expanded moves; no need to become a top-end sweeper.')
mark('GRANBULL RAMPARDOS', 'Preserve slow-powerful identity', 'High damage/low Speed is intentional; avoid making every attacker fast.')
mark('WEEZING WEEZING_GALARIAN TENTACRUEL', 'Support/defensive retest', 'Suppression/status/removal are team contributions not priced adequately by a lone duel.')
mark('CLEFABLE UMBREON', 'Support/set retest', 'Recovery/status/defensive utility merits role testing before stronger existing tools.')
mark('HITMONTOP', 'Support/set retest', 'Intimidate/priority/removal needs intended support evaluation before stat changes.')
mark('POLIWRATH', 'Ability/set retest', 'Test Iron Fist Drain Punch/Mach Punch and rain/Water Absorb roles before more stats.')
mark('GOLDUCK', 'Weather/set retest', 'Compare special attacking, Nasty Plot and rain/weather-control roles before adding power.')
mark('MEWTWO LUGIA HO_OH JIRACHI ZAPDOS RAIKOU SUICUNE MEW MOLTRES ENTEI ARTICUNO CELEBI', 'Hold intended exceptional strength', 'Legendary/mythical power and utility justify a different band; no blanket changes from solo scores.')
mark('ARCHALUDON BAXCALIBUR DRAGONITE DRAGAPULT SALAMENCE HYDREIGON TYRANITAR', 'Hold intended high-end strength', 'High-end stat budget is intentional; fresh full HP favors some abilities. No broad nerf supported.')
mark('AGGRON BASTIODON STEELIX RHYPERIOR', 'Hold successful defensive identity', 'Mitigation/Body Press/weight coverage works; preserve Speed/matchup weaknesses instead of global mechanic nerfs.')

weather = {'SWIFT_SWIM', 'RAIN_DISH', 'HYDRATION', 'CHLOROPHYLL', 'SOLAR_POWER', 'SAND_RUSH', 'SAND_FORCE', 'SLUSH_RUSH', 'HARVEST'}
self_weather = {'DRIZZLE', 'DROUGHT', 'SAND_STREAM', 'SNOW_WARNING'}
rows = []
for old in ranking:
    name = old['species']
    species = data['species'][name]
    legal = [a for a in species['abilities'] if a != 'NO_ABILITY']
    action, reason = notes.get(name, ('', ''))
    if not action:
        if weather.intersection(legal) and not self_weather.intersection(legal):
            action, reason = 'Weather-role retest', 'Evaluate relevant weather/support; neutral solo results alone do not justify stat changes.'
        elif old['score'] < .4:
            action, reason = 'Retest before any buff', 'No isolated cause established; recheck selected build, abilities and intended role before changing stats or coverage.'
        else:
            action, reason = 'Hold current baseline', 'No clear targeted imbalance; preserve role, intended power band and exploitable weaknesses.'
    rows.append({'species': name, 'old_rank': old['rank'], 'old_tier': old['tier'], 'old_no_item_score': old['score'],
                 **{'current_' + key: value for key, value in species['stats'].items()},
                 'current_bst': sum(species['stats'].values()), 'types': '/'.join(species['types']),
                 'legal_abilities': ' / '.join(legal), 'old_selected_ability': old['ability'], 'old_selected_moves': old['moves'],
                 'validation_best_per_ability': ' ; '.join(r['ability'] + ':' + str(round(float(r['score']) * 100, 1)) + '%' for r in ability_rows[name]),
                 'review_action': action, 'reason': reason})

assert len(rows) == len({r['species'] for r in rows}) == 231
assert sum(len([a for a in data['species'][r['species']]['abilities'] if a != 'NO_ABILITY']) for r in rows) == 664
with (OUT / 'full-roster-review.csv').open('w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
receipt = {'reviewed_species': 231, 'reviewed_ability_combinations': 664, 'reference_battles': 148562,
           'new_battles_in_this_review': 0, 'current_data_sha256': data['data_sha256'],
           'applied_changes': verification['changes'], 'categories': dict(Counter(r['review_action'] for r in rows)),
           'status': 'review completed; further changes are proposals only'}
(OUT / 'roster-review.json').write_text(json.dumps(receipt, indent=2))
path = OUT / 'REVIEW.md'
intro = path.read_text().split('<!-- roster-table -->')[0]
lines = ['<!-- roster-table -->', '', '## All 231 roster decisions', '',
         'Current stats: **HP / Attack / Defense / Speed / Special Attack / Special Defense**. Scores are historical pre-buff results.', '',
         '| Pokémon | Old score | Current base stats | Review decision |', '|---|---:|---|---|']
for row in rows:
    stats = [row['current_' + key] for key in ('hp', 'attack', 'defense', 'speed', 'sp_attack', 'sp_defense')]
    lines.append(f"| {row['species']} | {row['old_no_item_score']:.1%} | {' / '.join(map(str, stats))} | {row['review_action']} |")
path.write_text(intro + '\n'.join(lines) + '\n')
print(json.dumps(receipt))
