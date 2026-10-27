"""Internal no-item build comparisons; separate from the historical roster league."""
from collections import Counter, defaultdict
from concurrent.futures import FIRST_COMPLETED, ProcessPoolExecutor, wait
import argparse
import csv
import json
import multiprocessing
from pathlib import Path
import time

from lab.data import ROOT, PROJECT, canonical, digest, extract, provenance, validate_build
from lab.engine import RomEngine
from lab.store import Store, execute_worker, init_worker

OUT = PROJECT / 'output/focused-review-20261027'
DEST = ROOT / 'reports/balance/2026-10-27-stat-redistribution'
DB = Path('/tmp/crimson-focused-review-20261027.sqlite')
PANEL = ['MEWTWO', 'ARTICUNO', 'MACHAMP', 'SKARMORY', 'NINETALES_ALOLAN', 'BLISSEY',
         'TENTACRUEL', 'LANTURN', 'PARASECT', 'MAGCARGO', 'LEDIAN', 'DELIBIRD', 'UNOWN',
         'CERULEDGE', 'HERACROSS', 'DRAGAPULT']
# Two deliberately constructed alternatives per subject. Openings consume real turns.
ALTERNATIVES = {
    'HITMONLEE': [('reckless-coverage', ['HI_JUMP_KICK', 'KNOCK_OFF', 'STONE_EDGE', 'SUCKER_PUNCH'], []),
                 ('priority-coverage', ['CLOSE_COMBAT', 'KNOCK_OFF', 'MACH_PUNCH', 'STONE_EDGE'], [])],
    'HITMONTOP': [('technician-attacks', ['MACH_PUNCH', 'TRIPLE_KICK', 'ROCK_SLIDE', 'AERIAL_ACE'], []),
                 ('priority-coverage', ['CLOSE_COMBAT', 'MACH_PUNCH', 'STONE_EDGE', 'SUCKER_PUNCH'], [])],
    'HITMONCHAN': [('punch-coverage', ['MACH_PUNCH', 'DRAIN_PUNCH', 'ICE_PUNCH', 'THUNDERPUNCH'], []),
                  ('fakeout-punches', ['FAKE_OUT', 'DRAIN_PUNCH', 'ICE_PUNCH', 'MACH_PUNCH'], [1])],
    'PERSIAN': [('fakeout-physical', ['FAKE_OUT', 'FRUSTRATION', 'KNOCK_OFF', 'U_TURN'], [1]),
                ('special-setup', ['NASTY_PLOT', 'HYPER_VOICE', 'THUNDERBOLT', 'POWER_GEM'], [1])],
    'PERSIAN_ALOLAN': [('special-setup', ['NASTY_PLOT', 'DARK_PULSE', 'THUNDERBOLT', 'POWER_GEM'], [1]),
                       ('furcoat-resttalk', ['REST', 'SLEEP_TALK', 'DARK_PULSE', 'THUNDERBOLT'], [])],
    'PERRSERKER': [('steel-priority', ['IRON_HEAD', 'CLOSE_COMBAT', 'BULLET_PUNCH', 'SEED_BOMB'], []),
                   ('physical-setup', ['SWORDS_DANCE', 'IRON_HEAD', 'CLOSE_COMBAT', 'BULLET_PUNCH'], [1])],
    'BRELOOM': [('spore-technician', ['SPORE', 'BULLET_SEED', 'MACH_PUNCH', 'DRAIN_PUNCH'], [1]),
                ('spore-setup', ['SPORE', 'SWORDS_DANCE', 'BULLET_SEED', 'MACH_PUNCH'], [1, 2])],
    'GALLADE': [('sharpness-priority', ['SACRED_SWORD', 'PSYCHO_CUT', 'LEAF_BLADE', 'SHADOW_SNEAK'], []),
                ('sharpness-setup', ['SWORDS_DANCE', 'SACRED_SWORD', 'PSYCHO_CUT', 'NIGHT_SLASH'], [1])],
    'CLOYSTER': [('smash-skilllink', ['SHELL_SMASH', 'ICICLE_SPEAR', 'ROCK_BLAST', 'LIQUIDATION'], [1]),
                 ('smash-priority', ['SHELL_SMASH', 'ICICLE_SPEAR', 'ROCK_BLAST', 'ICE_SHARD'], [1])],
    'PINSIR': [('priority-coverage', ['MEGAHORN', 'CLOSE_COMBAT', 'STONE_EDGE', 'QUICK_ATTACK'], []),
               ('physical-setup', ['SWORDS_DANCE', 'MEGAHORN', 'CLOSE_COMBAT', 'QUICK_ATTACK'], [1])],
    'HYPNO': [('sleep-setup', ['HYPNOSIS', 'NASTY_PLOT', 'PSYCHIC_M', 'FOCUS_BLAST'], [1, 2]),
              ('sleep-recovery', ['HYPNOSIS', 'PSYCHIC_M', 'SHADOW_BALL', 'WISH'], [1])],
    'EXEGGUTOR_ALOLAN': [('rockhead-coverage', ['WOOD_HAMMER', 'DRAGON_HAMMER', 'EARTHQUAKE', 'FLAMETHROWER'], []),
                         ('rockhead-recovery', ['WOOD_HAMMER', 'DRAGON_HAMMER', 'MOONLIGHT', 'EARTHQUAKE'], [])],
}


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, indent=2))
    for attempt in range(61):
        try:
            temporary.replace(path)
            return
        except PermissionError:
            if attempt == 60:
                raise
            time.sleep(.5)


def prepare(data):
    ranking = json.loads((ROOT / 'reports/balance/2026-10-24-no-items/tier-list.json').read_text())
    prior = {r['species']: r for r in ranking}
    candidates = []
    for species, alternatives in ALTERNATIVES.items():
        old = prior[species]
        moves = old['moves'].split(' / ')
        opener = [moves.index(m) + 1 for m in old['opening'].split(' / ') if m]
        portfolio = [('historical-selected-set', moves, opener)] + alternatives
        for ability in dict.fromkeys(data['species'][species]['abilities']):
            if ability == 'NO_ABILITY':
                continue
            for label, moves, opener in portfolio:
                build = validate_build(data, {'species': species, 'ability': ability, 'moves': moves, 'item': 'NO_ITEM',
                                             'happiness': 0 if 'FRUSTRATION' in moves and 'RETURN' not in moves else 255})
                candidate = {'label': label, 'build': build, 'opener': opener}
                candidate['id'] = digest(canonical(candidate).encode())[:20]
                candidates.append(candidate)
    opponents = []
    for species in PANEL:
        old = prior[species]
        moves = old['moves'].split(' / ')
        opponents.append({'build': validate_build(data, {'species': species, 'ability': old['ability'], 'moves': moves, 'item': 'NO_ITEM',
                                                        'happiness': 0 if 'FRUSTRATION' in moves and 'RETURN' not in moves else 255}),
                          'opener': [moves.index(m) + 1 for m in old['opening'].split(' / ') if m]})
    scenarios = []
    for candidate in candidates:
        for index, opponent in enumerate(opponents):
            for swap in (False, True):
                player, enemy = (opponent, candidate) if swap else (candidate, opponent)
                side = 'enemy' if swap else 'player'
                scenarios.append({'name': f"focused subject={candidate['id']};side={side};opponent={index}",
                                  'player': player['build'], 'enemy': enemy['build'], 'seed': 20261027 + index*7919,
                                  'max_turns': 120, 'policies': ['tactical', 'tactical'],
                                  'scripts': {s: c['opener'] for s, c in [('player', player), ('enemy', enemy)] if c['opener']}})
    for scenario in scenarios:
        for side in ('player', 'enemy'):
            build = scenario[side]
            assert build['happiness'] == (0 if 'FRUSTRATION' in build['moves'] and 'RETURN' not in build['moves'] else 255)
    return candidates, scenarios


def publish(store, run, candidates, plan):
    groups = {c['id']: {'candidate': c, 'wins': 0, 'losses': 0, 'draws': 0, 'unresolved': 0, 'games': 0} for c in candidates}
    items, statuses = Counter(), Counter()
    for record in store.results(run):
        spec, result = record['spec'], record['result']
        if result is None or result['status'] == 'error' or result['failures']:
            raise ValueError('Do not publish incomplete or failed native comparisons')
        status = spec['name'].split(';side=')[1].split(';')[0]
        key = spec['name'].split('subject=')[1].split(';')[0]
        group = groups[key]
        group['games'] += 1
        statuses[result['status']] += 1
        winner = result['winner']
        field = 'unresolved' if winner == 'unresolved' else 'draws' if winner == 'draw' else 'wins' if winner == status else 'losses'
        group[field] += 1
        for state in result['log']:
            for side in ('player', 'enemy'):
                items[state[side]['item']] += 1
    assert set(items) == {'NO_ITEM'}, items
    rows = []
    for group in groups.values():
        c, b = group['candidate'], group['candidate']['build']
        assert group['games'] == 32
        points = group['wins'] + .5*group['draws']
        rows.append({'species': b['species'], 'ability': b['ability'], 'label': c['label'],
                     'moves': ' / '.join(b['moves']), 'opener': canonical(c['opener']),
                     **{k: group[k] for k in ('wins', 'losses', 'draws', 'unresolved', 'games')},
                     'score': points/32, 'score_upper': (points+group['unresolved'])/32, 'id': c['id']})
    rows.sort(key=lambda r: (r['species'], -r['score'], r['ability'], r['label']))
    save(DEST/'focused-results.json', rows)
    with (DEST/'focused-results.csv').open('w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
    save(DEST/'focused-receipt.json', {'plan': plan, 'run': run, 'counts': dict(statuses),
                                     'native_items': dict(items), 'builds': len(rows),
                                     'battles': sum(statuses.values()), 'format': '32 games per build, 16 opponents, both sides; not a roster tier list'})
    best = {}
    for row in rows:
        best.setdefault(row['species'], row)
    print(canonical({'done': True, 'counts': statuses, 'best': best}), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--plan', action='store_true')
    parser.add_argument('--jobs', type=int, default=8)
    args = parser.parse_args()
    data = extract()
    candidates, scenarios = prepare(data)
    plan = {'source': provenance(), 'driver_sha256': digest(Path(__file__).read_bytes()), 'data_sha256': data['data_sha256'],
            'species': list(ALTERNATIVES), 'panel': PANEL, 'builds': len(candidates), 'battles': len(scenarios),
            'rule': 'Enhanced, level 100, perfect DVs, zero stat experience, base PP, full HP, NO_ITEM; friendship 0 for Frustration-only builds, otherwise 255'}
    existing = OUT/'plan.json'
    if existing.exists() and json.loads(existing.read_text()) != plan:
        raise ValueError('Focused review source or plan changed; do not mix versions')
    save(existing, plan); save(OUT/'candidates.json', candidates)
    if args.plan:
        print(canonical({k: v for k, v in plan.items() if k != 'source'}), flush=True)
        return
    store = Store(DB)
    try:
        run = store.create(data, {'name': 'October 27 focused no-item balance review', 'mode': 'scenarios', 'scenarios': scenarios, 'repetitions': 1})
        assert store.db.execute('SELECT COUNT(*) FROM battles WHERE run_id=?', (run,)).fetchone()[0] == plan['battles']
        RomEngine(data).close()  # Warm the matching native fixture once before workers.
        pending_rows = iter(store.db.execute("SELECT id,spec FROM battles WHERE run_id=? AND status='pending' ORDER BY rowid", (run,)).fetchall())
        completed = store.db.execute("SELECT COUNT(*) FROM battles WHERE run_id=? AND status!='pending'", (run,)).fetchone()[0]
        last_report = 0
        with ProcessPoolExecutor(max_workers=args.jobs, mp_context=multiprocessing.get_context('spawn'), initializer=init_worker, initargs=(data, None)) as pool:
            futures, exhausted = {}, False
            while futures or not exhausted:
                while not exhausted and len(futures) < args.jobs*2:
                    row = next(pending_rows, None)
                    if row is None:
                        exhausted = True
                        break
                    futures[pool.submit(execute_worker, json.loads(row['spec']))] = row['id']
                if not futures:
                    break
                ready, _ = wait(futures, timeout=1, return_when=FIRST_COMPLETED)
                for future in ready:
                    key = futures.pop(future); result = future.result(); store.save(run, key, result); completed += 1
                    if result['status'] == 'error' or result['failures']:
                        save(OUT/'failure.json', {'battle': key, 'result': result})
                        raise RuntimeError('Native failure; see focused output/failure.json')
                now = time.monotonic()
                if now-last_report >= 20 or completed == len(scenarios):
                    p = {'run': run, 'completed': completed, 'total': len(scenarios)}
                    save(OUT/'progress.json', p); print(canonical(p), flush=True); last_report = now
        publish(store, run, candidates, plan)
    finally:
        store.db.execute('PRAGMA wal_checkpoint(TRUNCATE)')
        store.close()


if __name__ == '__main__':
    main()
