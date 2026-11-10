"""Native controls for inherited priority and Prankster on called moves."""
from copy import deepcopy
from exhaustive_battle_audit import mirror


def generate_called_move_tests():
    tests = []
    moves = ('TACKLE', 'PECK', 'MEGA_DRAIN', 'QUICK_ATTACK', 'HIDDEN_POWER', 'GROWL',
             'PSYCH_UP', 'PERISH_SONG', 'MEAN_LOOK', 'NIGHTMARE', 'TRANSFORM')
    defenses = [('MEW', ability) for ability in
                ('NO_ABILITY', 'QUEENLY_MAJESTY', 'ARMOR_TAIL', 'NEUTRALIZING_GAS')]
    defenses.append(('UMBREON', 'NO_ABILITY'))
    for source in ('NO_ABILITY', 'PRANKSTER', 'GALE_WINGS', 'TRIAGE'):
        for called in moves:
            for species, defense in defenses:
                boosted = source == 'PRANKSTER' and defense != 'NEUTRALIZING_GAS'
                blocked = boosted and defense in ('QUEENLY_MAJESTY', 'ARMOR_TAIL')
                blocked |= boosted and species == 'UMBREON' and called != 'PERISH_SONG'
                test = {
                    'player': dict(species='TALONFLAME' if source == 'GALE_WINGS' else 'MEW',
                                   level=50, ability=source, status_byte=3, moves=['SLEEP_TALK', called]),
                    'enemy': dict(species=species, level=100, ability=defense, moves=['SPLASH']),
                    'setup_wram': {'wBattleMonPP': [10, 0, 0, 0], 'wBattleMonHiddenPowerType': 2},
                    'move_script': [1], 'rng': 'seeded', 'rng_value': 91, 'turns': 1,
                    'assert': ["wram('wEnemyGoesFirst') == " + str(0 if boosted else 1)],
                }
                if called == 'PSYCH_UP':
                    test['enemy']['stages'] = {'atk': 2}
                    test['assert'].append(f'player.stat_levels[0] == {7 if blocked else 9}')
                elif called == 'PERISH_SONG':
                    test['assert'] += [f"wram('wPlayerPerishCount') == {0 if blocked else 3}",
                                       f"wram('wEnemyPerishCount') == {0 if blocked else 3}"]
                elif called == 'MEAN_LOOK':
                    test['assert'].append(f'(enemy.substatus[4] & 128) {"==" if blocked else "!="} 0')
                elif called == 'NIGHTMARE':
                    test['enemy']['status_byte'] = 3
                    test['assert'].append(f'(enemy.substatus[0] & 1) {"==" if blocked else "!="} 0')
                elif called == 'TRANSFORM':
                    test['assert'] += [f"player.moves[0] == '{'SLEEP_TALK' if blocked else 'SPLASH'}'",
                                       f'player.pp[0] == {9 if blocked else 5}']
                elif called == 'GROWL':
                    test['assert'].append(f'enemy.stat_levels[0] == {7 if blocked else 6}')
                else:
                    test['assert'].append(f'enemy.hp {"==" if blocked else "<"} enemy.start_hp')
                if called != 'TRANSFORM':
                    test['assert'].append('player.pp[0] == 9')
                for reverse in (False, True):
                    case = mirror(test) if reverse else deepcopy(test)
                    case['name'] = f'Called action: {"enemy" if reverse else "player"} {source} Sleep Talk {called} versus {species}/{defense}'
                    tests.append(case)
    return tests


if __name__ == '__main__':
    import sys
    import yaml
    yaml.safe_dump(generate_called_move_tests(), sys.stdout, sort_keys=False)
