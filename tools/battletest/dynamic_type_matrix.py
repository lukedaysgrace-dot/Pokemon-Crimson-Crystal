"""Native outcomes for dynamic move types, on both sides of the battle.

Expectations use the type chart, rather than the resolver under test. Conversion2
uses a seeded RNG because a constant RNG can loop forever on a rejected type.
"""

import argparse
import re
import sys
from copy import deepcopy

import yaml

from symbols import ROOT


TYPES = dict(NORMAL=0, FIGHTING=1, FLYING=2, POISON=3, GROUND=4,
             ROCK=5, BUG=7, GHOST=8, STEEL=9, FIRE=20, WATER=21,
             GRASS=22, ELECTRIC=23, PSYCHIC=24, ICE=25, DRAGON=26,
             DARK=27, FAIRY=28)


def resistances():
    chart = {kind: set() for kind in TYPES}
    source = (ROOT / 'data/types/type_matchups.asm').read_text()
    for attack, defense, factor in re.findall(
            r'^\s*db\s+(\w+),\s*(\w+),\s*(\w+)', source, re.M):
        if attack in chart and factor in ('NOT_VERY_EFFECTIVE', 'NO_EFFECT'):
            chart[attack].add(TYPES[defense])
    return chart


def generate_dynamic_type_tests():
    tests = []
    chart = resistances()
    for reverse in (False, True):
        actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
        own, opposing = ('wEnemyMon', 'wBattleMon') if reverse else ('wBattleMon', 'wEnemyMon')
        for kind, value in TYPES.items():
            if kind == 'NORMAL':
                continue  # stored zero deliberately means the default Dark type
            for seed in (1, 2, 17, 91):
                test = {
                    'name': f'Dynamic type: {actor} Conversion2 versus {kind} Hidden Power seed {seed}',
                    actor: dict(species='PORYGON2', level=50, ability='NO_ABILITY', moves=['CONVERSION2']),
                    target: dict(species='ELECTRODE', level=50, ability='NO_ABILITY', moves=['HIDDEN_POWER']),
                    'setup_wram': {opposing + 'HiddenPowerType': value},
                    'rng': 'seeded', 'rng_value': seed, 'turns': 1,
                    'assert': [f"wram('{own}Type1') in {tuple(sorted(chart[kind]))!r}",
                               f"wram('{own}Type1') == wram('{own}Type2')",
                               f'{actor}.hp {"==" if kind == "GHOST" else "<"} {actor}.start_hp'],
                }
                tests.append(test)
        for weather, kind in (('sun', 'FIRE'), ('rain', 'WATER'),
                              ('sandstorm', 'ROCK'), ('hail', 'ICE')):
            for seed in (1, 2, 17, 91):
                tests.append({
                    'name': f'Dynamic type: {actor} Conversion2 versus {weather} Weather Ball seed {seed}',
                    actor: dict(species='PORYGON2', level=50, ability='NO_ABILITY', moves=['CONVERSION2']),
                    target: dict(species='ELECTRODE', level=50, ability='NO_ABILITY', moves=['WEATHER_BALL']),
                    'weather': weather, 'rng': 'seeded', 'rng_value': seed, 'turns': 1,
                    'assert': [f"wram('{own}Type1') in {tuple(sorted(chart[kind]))!r}",
                               f'{actor}.hp < {actor}.start_hp'],
                })
                history = deepcopy(tests[-1])
                history['name'] += ' after weather ends and opponent sleeps'
                history['turns'] = 2
                history['turn_setup_wram'] = {1: {'wBattleWeather': 0, opposing + 'Status': 3}}
                history['turn_assert'] = history['assert'][:1]
                tests.append(history)
        for ability, kind in (('GALVANIZE', 'ELECTRIC'), ('PIXILATE', 'FAIRY'),
                              ('REFRIGERATE', 'ICE'), ('AERILATE', 'FLYING')):
            for seed in (1, 2, 17, 91):
                tests.append({
                    'name': f'Dynamic type: {actor} Conversion2 versus {ability} Tackle seed {seed}',
                    actor: dict(species='PORYGON2', level=50, ability='NO_ABILITY', moves=['CONVERSION2']),
                    target: dict(species='ELECTRODE', level=50, ability=ability, moves=['TACKLE']),
                    'rng': 'seeded', 'rng_value': seed, 'turns': 1,
                    'assert': [f"wram('{own}Type1') in {tuple(sorted(chart[kind]))!r}",
                               f'{actor}.hp < {actor}.start_hp'],
                })
                history = deepcopy(tests[-1])
                history['name'] += ' after ability changes and opponent sleeps'
                history['turns'] = 2
                history['turn_setup_wram'] = {1: {
                    'wPlayerAbility' if reverse else 'wEnemyAbility': 0,
                    opposing + 'Status': 3}}
                history['turn_assert'] = history['assert'][:1]
                tests.append(history)
        for value in (0,) + tuple(v for v in TYPES.values() if v):
            for blocker in ('NO_ABILITY', 'QUEENLY_MAJESTY', 'ARMOR_TAIL', 'NEUTRALIZING_GAS'):
                attacking = dict(species='TALONFLAME', level=50, ability='GALE_WINGS', moves=['HIDDEN_POWER'])
                defending = dict(species='ELECTRODE', level=50, ability=blocker, moves=['SPLASH'])
                boosted = value == TYPES['FLYING'] and blocker != 'NEUTRALIZING_GAS'
                blocked = boosted and blocker in ('QUEENLY_MAJESTY', 'ARMOR_TAIL')
                tests.append({
                    'name': f'Dynamic type: {actor} Gale Wings HP {value} against {blocker}',
                    actor: attacking, target: defending,
                    'setup_wram': {own + 'HiddenPowerType': value,
                                   opposing + 'HiddenPowerType': 2 if value != 2 else 23},
                    'rng': 'forced_high', 'turns': 1,
                    'assert': [f"wram('wEnemyGoesFirst') == {int(reverse if boosted else not reverse)}",
                               f'{target}.hp {"==" if blocked else "<"} {target}.start_hp'],
                })
        for moves, strongest in ((['HIDDEN_POWER', 'ROCK_SLIDE'], 'ROCK SLIDE'),
                                  (['PSYBEAM', 'HIDDEN_POWER'], 'HIDDEN POWER'),
                                  (['SPLASH', 'PSYBEAM', 'HIDDEN_POWER', 'ROCK_SLIDE'], 'ROCK SLIDE'),
                                  (['SPLASH', 'POUND', 'PSYBEAM', 'HIDDEN_POWER'], 'HIDDEN POWER'),
                                  (['HIDDEN_POWER', 'COUNTER'], 'COUNTER'),
                                  (['HIDDEN_POWER', 'GUILLOTINE'], 'GUILLOTINE')):
            tests.append({
                'name': f'Dynamic type: {actor} Forewarn {moves}',
                actor: dict(species='JYNX', level=50, ability='FOREWARN', moves=['SPLASH']),
                target: dict(species='MEW', level=50, ability='NO_ABILITY', moves=moves),
                'rng': 'forced_high', 'turns': 0,
                'assert': [f'text_seen({strongest!r})'],
            })
    # Check real damage/absorption against controls, including nonmatching
    # types, both Hidden Power categories, suppression and Mold Breaker.
    absorbers = {'VOLT_ABSORB': ('ELECTRIC', 'heal'), 'WATER_ABSORB': ('WATER', 'heal'),
                 'LIGHTNING_ROD': ('ELECTRIC', 3), 'MOTOR_DRIVE': ('ELECTRIC', 2),
                 'STORM_DRAIN': ('WATER', 3), 'SAP_SIPPER': ('GRASS', 0),
                 'LEVITATE': ('GROUND', None), 'FLASH_FIRE': ('FIRE', 3)}
    for reverse in (False, True):
        actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
        own = 'wEnemyMon' if reverse else 'wBattleMon'
        structure = 'wEnemyMoveStruct' if reverse else 'wPlayerMoveStruct'
        for species, category in (('MEW', 1), ('MACHAMP', 0)):
            for kind, value in TYPES.items():
                if not value:
                    continue
                for source in ('NO_ABILITY', 'NEUTRALIZING_GAS', 'MOLD_BREAKER'):
                    control_id = f'hp_absorb_{actor}_{species}_{kind}_{source}'
                    base = {
                        actor: dict(species=species, level=30, ability=source, moves=['HIDDEN_POWER']),
                        target: dict(species='MEW', level=100, hp=50, ability='NO_ABILITY', moves=['SPLASH']),
                        'setup_wram': {own + 'HiddenPowerType': value},
                        'rng': 'forced_high', 'turns': 1,
                        'assert': [f'{target}.hp < {target}.start_hp',
                                   f"wram('{structure}Type') == {value}",
                                   f"wram('{structure}Power') == 70",
                                   f"wram('{structure}Category') == {category}"],
                    }
                    control = deepcopy(base)
                    control.update(name=f'Dynamic absorption: {control_id} control', id=control_id)
                    tests.append(control)
                    for ability, (immune_type, reaction) in absorbers.items():
                        test = deepcopy(base)
                        test[target]['ability'] = ability
                        test['name'] = f'Dynamic absorption: {control_id} versus {ability}'
                        if kind == immune_type and source == 'NO_ABILITY':
                            expected = (f'min({target}.maxhp, {target}.start_hp + {target}.maxhp // 4)'
                                        if reaction == 'heal' else f'{target}.start_hp')
                            stages = [7] * 7
                            if isinstance(reaction, int):
                                stages[reaction] = 8
                            test['assert'] = [f'{target}.hp == {expected}',
                                              f'{target}.stat_levels == {stages}']
                        else:
                            test['assert'] = [f"{target}.{field} == result('{control_id}')['{target}']['{field}']"
                                              for field in ('hp', 'status', 'stat_levels', 'pp')]
                        tests.append(test)
    return tests


if __name__ == '__main__':
    argparse.ArgumentParser(description=__doc__).parse_args()
    yaml.safe_dump(generate_dynamic_type_tests(), sys.stdout, sort_keys=False)
