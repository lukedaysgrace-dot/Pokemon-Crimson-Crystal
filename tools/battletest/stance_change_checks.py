#!/usr/bin/env python3
"""Compare live form changes with ordinary native form/stat controls on both sides."""
import json

from runner import Harness, ROOT, apply_wram_setup
from symbols import STATE_WAIT


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    m = h.battle.mem
    checks = 0
    results = []
    observations = []
    pending = None

    def actor(which):
        return h.battle.enemy if which else h.battle.player

    def identity(which):
        mon = actor(which)
        party = 'wOTPartyMon1' if which else 'wPartyMon1'
        return {'hp': mon.hp, 'maxhp': mon.maxhp, 'status': mon.status,
                'stages': mon.stat_levels, 'ability': mon.ability, 'substatus': mon.substatus,
                'party': list(m.read_bytes(party, 50))}

    def before(_):
        nonlocal pending
        pending = identity(m.read('hBattleTurn'))

    def after(_):
        if pending is not None:
            observations.append((pending, identity(m.read('hBattleTurn'))))

    h.pb.hook_register(*h.sym['RecalculateStanceStats'], before, None)
    h.pb.hook_register(*h.sym['PresentStanceChange'], after, None)

    def check(value, message):
        nonlocal checks
        checks += 1
        assert value, message

    def stage(side, config, species='AEGISLASH', live=False):
        h.load_fixture()
        m.write('wOptions', 0xc1)
        holder = dict(config, species=species,
                      ability='STANCE_CHANGE' if live else 'NO_ABILITY',
                      moves=['IRON_HEAD', 'KINGS_SHIELD', 'SPLASH'] if live else ['PSYCH_UP'])
        holder.setdefault('level', 50)
        other = {'species': 'MEW', 'level': 100, 'moves': ['SPLASH'], 'stages': {'def': 6}}
        if not live:
            other['stages'] = dict(config.get('stages', {}))
        test = {'player': holder if side == 0 else other,
                'enemy': other if side == 0 else holder, 'rng': 'forced_high', 'turns': 0,
                'move_script': [1, 2, 3, 1, 2] if live and side == 0 else [1]*5}
        check(h.run_battle(test) == STATE_WAIT, 'native battle staging')

    def advance(turn):
        m.write('wDebugTurnTarget', turn)
        m.write('wDebugControl', 1)
        for frame in range(12000):
            if frame % 8 == 0:
                h.pb.button('a', 2)
            h.tick(1)
            if h.state() == STATE_WAIT and h.battle.turns_done == turn:
                return
        raise AssertionError(('turn timeout', h.control_state()))

    mixed = {'atk': 2, 'def': -1, 'spd': 3, 'satk': -2, 'sdef': 1, 'acc': -2, 'eva': 2}
    cases = [
        ('neutral and Focus Energy/Mist', {'dvs': 0xffff, 'substatus': ['FOCUS_ENERGY', 'MIST']}),
        ('mixed boosts and drops', {'dvs': 0x1a3d, 'stages': mixed}),
        ('burn', {'dvs': 0xa37c, 'stages': mixed, 'status_byte': 16}),
        ('paralysis', {'dvs': 0x7e92, 'stages': mixed, 'status_byte': 64}),
        ('frostbite', {'dvs': 0x12f5, 'stages': mixed, 'status_byte': 32}),
        ('stage limits', {'dvs': 0xa37c, 'stages': {'atk': 6, 'def': -6, 'spd': -6,
                         'satk': -6, 'sdef': 6, 'acc': -6, 'eva': 6}}),
        ('capped boosted stats', {'level': 100, 'dvs': 0xffff,
                                'stages': {'atk': 6, 'def': 6, 'spd': 6, 'satk': 6, 'sdef': 6}}),
    ]
    try:
        for side in (0, 1):
            for label, config in cases:
                controls = {}
                for form in ('AEGISLASH', 'AEGISLASH_BLADE'):
                    stage(side, config, species=form)
                    # Debug statuses are installed after entry's calculation.
                    # Native Psych Up copies the exact requested stages from
                    # the control opponent, then recalculates ordinary stats
                    # with burn/paralysis/frostbite. No stance code runs here.
                    advance(1)
                    controls[form] = dict(actor(side).stats)
                stage(side, config, live=True)
                original = identity(side)
                expected_stages = list(original['stages'])
                observations.clear()
                for turn, move in enumerate(['IRON_HEAD', 'KINGS_SHIELD', 'SPLASH', 'IRON_HEAD', 'KINGS_SHIELD'], 1):
                    if side == 1:
                        apply_wram_setup(h.battle, {'wEnemyMonMoves': {'move': move}})
                    advance(turn)
                    mon = actor(side)
                    blade = turn in (1, 4)
                    expected = controls['AEGISLASH_BLADE' if blade else 'AEGISLASH']
                    check(mon.stats == expected, (side, label, turn, 'all five form stats', mon.stats, expected))
                    check(mon.stat_levels == expected_stages, (side, label, turn, 'all seven stat stages'))
                    check(mon.maxhp == original['maxhp'], (side, label, turn, 'maximum HP'))
                    check(mon.status == original['status'], (side, label, turn, 'persistent status'))
                    check(m.read('wEnemyBladeForm' if side else 'wPlayerBladeForm') == int(blade), (side, label, turn, 'form'))
                    check(mon.species == 'AEGISLASH', (side, label, turn, 'real species'))
                check(len(observations) >= 4, (side, label, 'four observed native transitions'))
                for previous, current in observations:
                    check(previous == current, (side, label, 'form recalculation changed HP/status/stages/party', previous, current))
                results.append({'side': 'opponent' if side else 'player', 'case': label,
                                'controls': controls, 'stages': expected_stages, 'transitions': len(observations)})
                print('PASS', side, label, flush=True)
        out = ROOT / '_artifacts/roster'
        out.mkdir(parents=True, exist_ok=True)
        (out/'stance-stat-checks.json').write_text(json.dumps({'checks': checks, 'cases': results}, indent=2)+'\n')
        print(f'STANCE STAT CHECKS PASSED: {checks} native checks; both sides, all stats/stages, varied DVs, status and saved data', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
