#!/usr/bin/env python3
"""Native entry abilities must not inherit a previous action's context."""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from symbols import STATE_WAIT


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    try:
        for reverse in (False, True):
            h.load_fixture()
            memory = h.battle.mem
            for side in ('Player', 'Enemy'):
                memory.write(f'w{side}ActionMove', 1)
                memory.write(f'w{side}ActionAbility', h.con.ability_id('PRANKSTER'))
            actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
            test = {
                actor: dict(species='DITTO', level=50, ability='IMPOSTER', moves=['SPLASH']),
                target: dict(species='TSAREENA', level=100, ability='QUEENLY_MAJESTY', moves=['SPLASH']),
                'rng': 'forced_high', 'turns': 0,
            }
            assert h.run_battle(test) == STATE_WAIT
            battler = h.battle.enemy if reverse else h.battle.player
            assert battler.species == 'TSAREENA', (actor, battler.species)
            assert battler.ability == 'QUEENLY_MAJESTY', (actor, battler.ability)
            for side in ('Player', 'Enemy'):
                assert memory.read(f'w{side}ActionMove') == 0
                assert memory.read(f'w{side}ActionAbility') == 0
        print('ACTION CONTEXT: both native Imposter entries clear stale selected-action state')
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
