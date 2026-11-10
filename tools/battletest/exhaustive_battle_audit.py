#!/usr/bin/env python3
"""All-move native battles with every ability, plus per-move effect outcomes.

The Cartesian pass explicitly reports execution/invariant coverage. It does not
claim that an uneventful battle proves an ability's activation condition. The
semantic pass complements it with prepared effect-specific outcomes.
"""

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from copy import deepcopy
import json
import io
from pathlib import Path
import re
import subprocess
import sys
import time

import yaml

from effect_sweep import _configure
from outcome_matrix import move_records
from symbols import ROOT


INVARIANTS = ["0 <= player.hp <= player.maxhp", "0 <= enemy.hp <= enemy.maxhp",
              "wram('wInAbility') == 0"] + [
    f"1 <= {side}.stat_levels[{i}] <= 13"
    for side in ('player', 'enemy') for i in range(7)]


def mirror(test):
    """Exchange the battlers and side-specific assertion symbols."""
    test = deepcopy(test)
    for a, b in (('player', 'enemy'), ('player2', 'enemy2'), ('player_screens', 'enemy_screens')):
        x, y = test.pop(a, None), test.pop(b, None)
        if x is not None:
            test[b] = x
        if y is not None:
            test[a] = y
    pairs = {'player': 'enemy', 'enemy': 'player', 'wPlayer': 'wEnemy',
             'wEnemy': 'wPlayer', 'wBattleMon': 'wEnemyMon', 'wEnemyMon': 'wBattleMon'}

    def exchange(value):
        value = value.replace("wram('wEnemyGoesFirst')", '(1 - __ORDER__)')
        value = re.sub(r'wBattleMon|wEnemyMon|wPlayer|wEnemy|\bplayer\b|\benemy\b',
                       lambda match: pairs[match[0]], value)
        return value.replace('__ORDER__', "wram('wEnemyGoesFirst')")

    test['assert'] = [exchange(expr) for expr in test['assert']]
    if 'setup_wram' in test:
        test['setup_wram'] = {exchange(k): v for k, v in test['setup_wram'].items()}
    return test


def semantic_tests():
    tests = []
    for move in move_records():
        test = _configure(move['effect'], move['name'], move['power'])
        # A neutral Mew permits every attacking type to connect. Individual
        # effects above retain their explicitly prepared target species.
        if test['enemy']['species'] == 'LUGIA':
            test['enemy']['species'] = 'MEW'
        if move['name'] == 'DRAGON_RAGE':
            test['assert'] = ['enemy.start_hp - enemy.hp == 40']
        if move['effect'] == 'EFFECT_CONVERSION':
            test['player']['moves'].append('WATER_GUN')
            test['rng'] = 'seeded'
            test['rng_value'] = 91
            test['setup_wram'] = {'wBattleMonPP': [30, 0, 0, 0]}
            test['assert'] = ["wram('wBattleMonType1') in (0, 21)",
                              "wram('wBattleMonType1') == wram('wBattleMonType2')"]
        if move['effect'] in ('EFFECT_SPEED_DOWN_2', 'EFFECT_ACCURACY_DOWN', 'EFFECT_EVASION_DOWN'):
            stage, expected = {'EFFECT_SPEED_DOWN_2': (2, 5), 'EFFECT_ACCURACY_DOWN': (5, 6),
                               'EFFECT_EVASION_DOWN': (6, 6)}[move['effect']]
            test['assert'] = [f'enemy.stat_levels[{stage}] == {expected}']
        if move['effect'] == 'EFFECT_CURSE':
            test['assert'] = ['player.stat_levels == [8, 8, 6, 7, 7, 7, 7]']
        if move['effect'] == 'EFFECT_RESET_STATS':
            test['player']['stages'] = {'atk': 3, 'def': -2}
            test['enemy']['stages'] = {'satk': 2, 'eva': -1}
            test['assert'] = ['player.stat_levels == [7] * 7', 'enemy.stat_levels == [7] * 7']
        if move['effect'] == 'EFFECT_PSYCH_UP':
            test['enemy']['stages'] = {'atk': 2, 'def': -1, 'satk': 3}
            test['assert'] = ['player.stat_levels == enemy.stat_levels',
                              'player.stat_levels == [9, 6, 7, 10, 7, 7, 7]']
        if move['effect'] in ('EFFECT_MIMIC', 'EFFECT_MIRROR_MOVE'):
            test['enemy']['moves'] = ['WATER_GUN']
            test['assert'] = (["player.moves[0] == 'WATER_GUN'", 'player.pp[0] == player.start_pp[0] - 1']
                              if move['effect'] == 'EFFECT_MIMIC' else ['enemy.hp < enemy.start_hp'])
        if move['effect'] == 'EFFECT_SPITE':
            test['assert'] = ['enemy.pp[0] <= enemy.start_pp[0] - 3']
        if move['effect'] == 'EFFECT_HEAL_BELL':
            test['player']['status_byte'] = 16
            test['assert'] = ['player.status == 0']
        if move['effect'] == 'EFFECT_TRANSFORM':
            test['enemy']['species'] = 'SNORLAX'
            test['assert'] = ["player.species == 'SNORLAX'", "player.moves[0] == 'SPLASH'", 'player.pp[0] == 5']
        if move['effect'] == 'EFFECT_SKILL_SWAP':
            test['player']['ability'] = 'SYNCHRONIZE'
            test['enemy']['ability'] = 'OWN_TEMPO'
            test['assert'] = ["player.ability == 'OWN_TEMPO'", "enemy.ability == 'SYNCHRONIZE'"]
        if move['effect'] == 'EFFECT_SLEEP_TALK':
            test['player']['moves'].append('TACKLE')
            test['player']['status_byte'] = 3
            test['rng'] = 'seeded'
            test['rng_value'] = 91
            test['setup_wram'] = {'wBattleMonPP': [10, 0, 0, 0]}
            test['assert'] = ['enemy.hp < enemy.start_hp']
        if move['effect'] == 'EFFECT_SWAGGER':
            test['assert'] = ['enemy.stat_levels[0] == 9', '(enemy.substatus[2] & 128) != 0']
        if move['effect'] == 'EFFECT_BANEFUL_BUNKER':
            test['enemy']['moves'] = ['TACKLE']
            test['assert'] = ['player.hp == player.start_hp', '(enemy.status & 8) != 0']
        if move['effect'] == 'EFFECT_DEFOG':
            test['enemy_screens'] = 17
            test['setup_wram'] = {'wEnemySpikesLayers': 1}
            test['assert'] = ['(enemy.screens & 17) == 0', "wram('wEnemySpikesLayers') == 0",
                              'enemy.stat_levels[6] == 6']
        for reverse in (False, True):
            case = mirror(test) if reverse else deepcopy(test)
            case['name'] = f"All-move semantic: {'enemy' if reverse else 'player'} {move['name']}"
            case['assert'] += INVARIANTS
            tests.append(case)
    return tests


def checkpoint_worker(args):
    """Reuse native pre-turn setup, then play each combination normally.

    Only initial ability fixture bytes change between runs, exactly as in
    DebugApplyPostEntry. No move/ability engine routines are called directly.
    The CPU executes selection, ordering, move effects and cleanup normally.
    """
    from runner import Harness, FRAME_CEILING_BATTLE
    from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR
    h = Harness(render=False, short_delays=True, rom_path=args.rom)
    h.ensure_fixture()
    con = h.con
    abilities = args.abilities or [name for _, name in sorted(con.abilities_by_id.items())
                                   if name != 'NUM_ABILITIES']
    failures = []
    count = 0
    start = time.monotonic()
    records = move_records()[args.worker::args.jobs]
    if args.moves:
        records = [move for move in records if move['name'] in args.moves]
    for move in records:
        for reverse in (False, True):
            actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
            h.load_fixture()
            spec = {
                actor: dict(species='MEW', level=50, ability='NO_ABILITY', moves=[move['name']]),
                target: dict(species='SNORLAX', level=100, ability='NO_ABILITY', moves=['SPLASH']),
                'player2': dict(species='MEW', level=50, ability='NO_ABILITY', moves=['SPLASH']),
                'enemy2': dict(species='SNORLAX', level=100, ability='NO_ABILITY', moves=['SPLASH']),
                'enemy_class': 'FALKNER', 'rng': 'seeded', 'rng_value': 91, 'turns': 0,
            }
            if h.run_battle(spec) != STATE_WAIT:
                raise RuntimeError(f"could not prepare {actor} {move['name']}")
            # Battle scenes off and the existing instant-letter flag used by
            # menus. This skips presentation delay, never text commands or
            # mechanical routines. The regular suite retains normal timing.
            options = h.battle.mem.read('wOptions')
            h.battle.mem.write('wOptions', (options & ~7) | 0x91)
            checkpoint = io.BytesIO()
            h.pb.save_state(checkpoint)
            for role in ('attacker', 'defender'):
                for ability in abilities:
                    name = f"{actor} {move['name']} {ability} {role}"
                    checkpoint.seek(0)
                    h.pb.load_state(checkpoint)
                    h.text_context = None
                    h.text_overflows = []
                    h.battle.textbox_contexts.clear()
                    h.battle.textbox_order.clear()
                    memory = h.battle.mem
                    holder = actor if role == 'attacker' else target
                    memory.write('wPlayerAbility' if holder == 'player' else 'wEnemyAbility',
                                 con.ability_id(ability))
                    turns = 2 if move['effect'] in ('EFFECT_FLY', 'EFFECT_BOUNCE', 'EFFECT_SKULL_BASH',
                                                   'EFFECT_SKY_ATTACK', 'EFFECT_SOLARBEAM') else 1
                    memory.write('wDebugTurnTarget', turns)
                    memory.write('wDebugControl', 1)
                    st = None
                    for _ in range(0, FRAME_CEILING_BATTLE, 4):
                        st = h.state()
                        if st == STATE_DONE or st == STATE_ERROR or (st == STATE_WAIT and h.battle.turns_done >= turns):
                            break
                        h.pb.button('a', 2)
                        h.tick(4)
                    else:
                        st = None
                    count += 1
                    bad = []
                    if st not in (STATE_WAIT, STATE_DONE):
                        bad.append(f'bad battle completion state {st}; {h.where()}')
                    for side in (h.battle.player, h.battle.enemy):
                        if not 0 <= side.hp <= side.maxhp:
                            bad.append(f'HP {side.hp}/{side.maxhp}')
                        if not all(1 <= stage <= 13 for stage in side.stat_levels):
                            bad.append(f'stages {side.stat_levels}')
                    if memory.read('wInAbility'):
                        bad.append('ability recursion state leaked')
                    bad.extend(h.text_overflows)
                    if bad:
                        failures.append(dict(name=name, failures=bad))
                        print('FAIL ' + json.dumps(failures[-1]), flush=True)
            print(f"{move['name']} {actor}: {count} completed, {len(failures)} failures", flush=True)
            progress = dict(worker=args.worker, cases=count, failed=len(failures),
                            last_case=f"{move['name']} {actor}", complete=False,
                            seconds=round(time.monotonic() - start, 1),
                            rom_sha256=h.rom_sha256)
            (args.output / f'cartesian-progress-{args.worker}.json').write_text(json.dumps(progress, indent=2))
    result = dict(worker=args.worker, cases=count, failed=len(failures), failures=failures,
                  seconds=round(time.monotonic() - start, 1),
                  rom_md5_prefix=h.rom_key(), rom_sha256=h.rom_sha256)
    (args.output / f'cartesian-worker-{args.worker}.json').write_text(json.dumps(result, indent=2))
    print(json.dumps({key: value for key, value in result.items() if key != 'failures'}), flush=True)
    h.pb.stop(save=False)
    return bool(failures)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mode', choices=('semantic', 'cartesian'), required=True)
    parser.add_argument('--rom', type=Path, help='debug ROM to execute, with a matching .sym file')
    parser.add_argument('--jobs', type=int, default=8)
    parser.add_argument('--output', type=Path, default=ROOT / '.tmpbuild/exhaustive-battles')
    parser.add_argument('--abilities', nargs='*')
    parser.add_argument('--moves', nargs='*', help='limit the Cartesian pass to named moves')
    parser.add_argument('--worker', type=int, help=argparse.SUPPRESS)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    if args.worker is not None:
        return checkpoint_worker(args)
    # Bootstrap once before independent workers access the fixture cache.
    from runner import Harness
    h = Harness(render=False, rom_path=args.rom)
    h.ensure_fixture()
    h.pb.stop(save=False)
    if args.mode == 'cartesian':
        workers = []
        for index in range(args.jobs):
            log = (args.output / f'cartesian-worker-{index}.log').open('w')
            command = [sys.executable, '-u', __file__, '--mode', 'cartesian', '--jobs', str(args.jobs),
                       '--worker', str(index), '--output', str(args.output)]
            if args.abilities:
                command += ['--abilities', *args.abilities]
            if args.moves:
                command += ['--moves', *args.moves]
            if args.rom:
                command += ['--rom', str(args.rom)]
            workers.append((subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT), log))
        codes = []
        for process, log in workers:
            codes.append(process.wait())
            log.close()
        results = [json.loads((args.output / f'cartesian-worker-{index}.json').read_text())
                   for index in range(args.jobs)
                   if (args.output / f'cartesian-worker-{index}.json').exists()]
        (args.output / 'cartesian-results.json').write_text(json.dumps(results, indent=2))
        print(f"{sum(result['cases'] for result in results)} native battles; "
              f"{sum(result['failed'] for result in results)} failures; {len(results)}/{args.jobs} workers completed", flush=True)
        return bool(any(codes) or len(results) != args.jobs)
    groups = ['semantic']

    def run(group):
        tests = semantic_tests()
        path = args.output / f'{args.mode}-{group}.yaml'
        path.write_text(yaml.dump(tests, Dumper=getattr(yaml, 'CSafeDumper', yaml.SafeDumper), sort_keys=False))
        log = path.with_suffix('.log')
        start = time.monotonic()
        with log.open('w') as output:
            command = [sys.executable, '-u', str(ROOT / 'tools/battletest/runner.py'),
                       '--no-render', '--instant-text', '--jobs', str(args.jobs), str(path)]
            if args.rom:
                command += ['--rom', str(args.rom)]
            result = subprocess.run(command,
                                    stdout=output, stderr=subprocess.STDOUT)
        content = log.read_text()
        counts = re.findall(r'^(\d+) passed, (\d+) failed, (\d+) errored, (\d+) skipped (?:in|across) ', content, re.M)
        return dict(group=group, cases=len(tests), code=result.returncode,
                    counts=list(map(int, counts[-1])) if counts else None,
                    seconds=round(time.monotonic() - start, 1), log=str(log))

    results = []
    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        pending = [executor.submit(run, group) for group in groups]
        for future in as_completed(pending):
            result = future.result()
            results.append(result)
            print(json.dumps(result), flush=True)
            (args.output / f'{args.mode}-results.json').write_text(json.dumps(results, indent=2))
    failed = [result for result in results if result['code'] or not result['counts']]
    print(f"{sum(result['cases'] for result in results)} native battles; {len(failed)} failing groups", flush=True)
    return bool(failed)


if __name__ == '__main__':
    sys.exit(main())
