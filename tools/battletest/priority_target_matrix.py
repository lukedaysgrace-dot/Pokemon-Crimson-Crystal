"""Expected targeting outcomes for status moves which have no checkhit."""


def generate_priority_target_tests():
    tests = []
    for reverse in (False, True):
        actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
        own = 'wEnemyMon' if reverse else 'wBattleMon'
        for move in ('MIMIC', 'MIRROR_MOVE', 'PSYCH_UP', 'PERISH_SONG', 'SWORDS_DANCE'):
            for source in ('NO_ABILITY', 'PRANKSTER', 'GALE_WINGS', 'MOLD_BREAKER', 'NEUTRALIZING_GAS'):
                for defense in ('NO_ABILITY', 'QUEENLY_MAJESTY', 'ARMOR_TAIL'):
                    for dark in (False, True):
                        boosted = source == 'PRANKSTER' or (source == 'GALE_WINGS' and move == 'MIRROR_MOVE')
                        foe_targeted = move not in ('PERISH_SONG', 'SWORDS_DANCE')
                        blocked = (move != 'SWORDS_DANCE' and boosted and defense != 'NO_ABILITY')
                        blocked |= foe_targeted and dark and source == 'PRANKSTER'
                        test = {
                            actor: dict(species='MEW', level=50, ability=source, moves=[move]),
                            target: dict(species='UMBREON' if dark else 'MEW', level=100,
                                         ability=defense, moves=['SPLASH']),
                            'rng': 'seeded', 'rng_value': 91, 'turns': 1,
                            'name': f'Priority target: {actor} {source} {move} versus {"Dark" if dark else "Psychic"} {defense}',
                        }
                        if move == 'MIMIC':
                            test['assert'] = [f"{actor}.moves[0] == '{'MIMIC' if blocked else 'SPLASH'}'",
                                              f'{actor}.pp[0] == 9']
                        elif move == 'PSYCH_UP':
                            test[target]['stages'] = {'atk': 2}
                            test['assert'] = [f'{actor}.stat_levels[0] == {7 if blocked else 9}']
                        elif move == 'MIRROR_MOVE':
                            test[actor]['moves'] = ['SPLASH', 'MIRROR_MOVE']
                            test[target]['moves'] = ['SWORDS_DANCE']
                            test['turns'] = 2
                            test['move_script'] = [1, 2] if not reverse else [1, 1]
                            test['setup_wram'] = {own + 'PP': [40, 0, 0, 0]}
                            test['turn_setup_wram'] = {1: {own + 'PP': [0, 20, 0, 0]}}
                            test['assert'] = [f'{actor}.stat_levels[0] == {7 if blocked else 9}',
                                              f'{actor}.pp[1] == 19']
                        elif move == 'PERISH_SONG':
                            test['assert'] = [f"wram('wPlayerPerishCount') == {0 if blocked else 3}",
                                              f"wram('wEnemyPerishCount') == {0 if blocked else 3}"]
                        else:
                            test['assert'] = [f'{actor}.stat_levels[0] == 9']
                        tests.append(test)
    return tests


if __name__ == '__main__':
    import sys
    import yaml
    yaml.safe_dump(generate_priority_target_tests(), sys.stdout, sort_keys=False)
