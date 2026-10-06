"""Three- and four-way multi-hit interactions with explicit outcome checks."""

from copy import deepcopy

from long_sweep import INVARIANTS
from interaction_sweep import generate_interaction_tests
from outcome_matrix import base, move_records


def generate_complex_matrix():
    records = {move['name']: move for move in move_records()}
    tests = []
    for source, moves, hits in (
            ('PARENTAL_BOND', ('TACKLE', 'WATER_GUN', 'BULLDOZE'), 2),
            ('SKILL_LINK', ('FURY_ATTACK', 'BULLET_SEED', 'ROCK_BLAST', 'PIN_MISSILE'), 5)):
        for name in moves:
            move = records[name]
            for reverse in (False, True):
                actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
                prefix = 'wPlayer' if reverse else 'wEnemy'
                for ability in ('NO_ABILITY', 'STAMINA', 'WEAK_ARMOR', 'RIPEN', 'CONTRARY', 'KLUTZ'):
                    for held in ('NO_ITEM', 'BERRY', 'WEAK_POLICY', 'ROCKY_HELMET'):
                        for source_item in ('NO_ITEM', 'LIFE_ORB', 'CHOICE_SPECS'):
                            test = base(move, source, ability, reverse)
                            test[actor].update(item=source_item)
                            test[target].update(species='OMASTAR', item=held)
                            if held == 'BERRY':
                                # Cross the threshold during the attack, after
                                # post-entry ability overrides are installed.
                                test[target]['hp'] = 51
                            test['rng'] = 'forced_high'
                            test['name'] = f'Complex multi: {actor} {source}/{source_item} {name} versus {ability}/{held}'
                            test['_file'] = '<generated complex interaction matrix>'
                            test['assert'] += [f'{actor}.hp > 0', f'{target}.hp > 0',
                                               f"wram('{prefix}RageFistHits') == {hits}"]
                            stages = [7] * 7
                            factor = -1 if ability == 'CONTRARY' else 1
                            if ability == 'STAMINA':
                                stages[1] += hits
                            if ability == 'WEAK_ARMOR' and move['category'] == 'PHYSICAL':
                                stages[1] -= hits
                                stages[2] += 2 * hits
                            if name == 'BULLDOZE':
                                stages[2] -= factor * hits
                            effective = ability != 'KLUTZ'
                            super_effective = name in ('BULLDOZE', 'BULLET_SEED')
                            if held == 'WEAK_POLICY' and effective and super_effective:
                                stages[0] += 2 * factor
                                stages[3] += 2 * factor
                            stages = [min(13, max(1, stage)) for stage in stages]
                            test['assert'].append(f'{target}.stat_levels == {stages}')
                            consumed = effective and (held == 'BERRY' or (held == 'WEAK_POLICY' and super_effective))
                            test['assert'].append(f"{target}.item == '{'NO_ITEM' if consumed else held}'")
                            helmet = effective and held == 'ROCKY_HELMET' and name in ('TACKLE', 'FURY_ATTACK')
                            loss = f'{hits} * ({actor}.maxhp // 6)' if helmet else '0'
                            if source_item == 'LIFE_ORB':
                                loss += f' + max(1, {actor}.maxhp // 10)'
                            test['assert'].append(f'{actor}.start_hp - {actor}.hp == {loss}')
                            tests.append(test)

    # A different seed and longer scripts add combinations absent from the
    # original stress sweep. Every completed turn checks state boundaries.
    for test in generate_interaction_tests(512, seed=0xC11B4, extended=True):
        test = deepcopy(test)
        test['name'] = test['name'].replace('Interaction stress', 'Complex mixed:')
        test['turns'] = 12
        script = test['move_script']
        test['move_script'] = (script * (12 // len(script) + 1))[:12]
        test['snapshot'] = True
        test['assert'] = list(INVARIANTS)
        test['turn_assert'] = list(INVARIANTS)
        test['_file'] = '<generated complex interaction matrix>'
        tests.append(test)
    return tests
