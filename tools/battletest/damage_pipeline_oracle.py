"""Independent integer model for the declared full-turn damage cases.

Inputs are the fixture's raw stats, stages and authored move/matchup data.
No native damage, selected stat, critical flag or modifier result is an
oracle input. This preserves Crimson's rounding and damage-based boosts;
it is deliberately not a modern-generation damage calculator.
"""
from fractions import Fraction


STAGE = (25, 28, 33, 40, 50, 66, 100, 150, 200, 250, 300, 350, 400)
# power, type, physical/special, contact, punch, STAB on the declared actor
MATCHUPS = {
    'neutral': ('MEW', 'MEW', 'TACKLE', 40, 'NORMAL', 0, True, False, False, (1,)),
    'fire-contact': ('CHARIZARD', 'SCIZOR', 'FIRE_PUNCH', 75, 'FIRE', 0, True, True, True, (2, 2)),
    'fire-special': ('CHARIZARD', 'SCIZOR', 'FLAMETHROWER', 95, 'FIRE', 1, False, False, True, (2, 2)),
    'water-contact': ('GYARADOS', 'MAGCARGO', 'WATERFALL', 85, 'WATER', 0, True, False, True, (2, 2)),
    'water-special': ('BLASTOISE', 'MAGCARGO', 'SURF', 95, 'WATER', 1, False, False, True, (2, 2)),
    'electric': ('AMPHAROS', 'GYARADOS', 'THUNDERBOLT', 95, 'ELECTRIC', 1, False, False, True, (2, 2)),
    'ice': ('LAPRAS', 'DRAGONITE', 'ICE_BEAM', 95, 'ICE', 1, False, False, True, (2, 2)),
    'quarter': ('CHARIZARD', 'KINGDRA', 'FLAMETHROWER', 95, 'FIRE', 1, False, False, True, (Fraction(1, 2), Fraction(1, 2))),
    'psychic': ('MEW', 'MEW', 'PSYCHIC_M', 90, 'PSYCHIC', 1, False, False, True, (Fraction(1, 2),)),
    'ground-immunity': ('AMPHAROS', 'HIPPOWDON', 'THUNDERBOLT', 95, 'ELECTRIC', 1, False, False, True, (0,)),
    'ghost-immunity': ('MEW', 'GENGAR', 'TACKLE', 40, 'NORMAL', 0, True, False, False, (0,)),
    'dark-immunity': ('MEW', 'TYRANITAR', 'PSYCHIC_M', 90, 'PSYCHIC', 1, False, False, True, (0,)),
    'rock-sand': ('BLASTOISE', 'SHUCKLE', 'SURF', 95, 'WATER', 1, False, False, True, (2,)),
    'ice-hail': ('MEW', 'GLACEON', 'TACKLE', 40, 'NORMAL', 0, True, False, False, (1,)),
    'eviolite': ('MEW', 'SEEDOT', 'TACKLE', 40, 'NORMAL', 0, True, False, False, (1,)),
    'eviolite-special': ('MEW', 'SEEDOT', 'PSYCHIC_M', 90, 'PSYCHIC', 1, False, False, True, (1,)),
    'psyshock': ('MEW', 'MEW', 'PSYSHOCK', 80, 'PSYCHIC', 1, False, False, True, (Fraction(1, 2),)),
    'weak-water': ('MEW', 'KINGDRA', 'SURF', 95, 'WATER', 1, False, False, False, (Fraction(1, 2), Fraction(1, 2))),
}


def staged(raw, stage, status=False):
    value = max(1, min(999, raw * STAGE[stage + 6] // 100))
    return max(1, value // 2) if status else value


def scaled(value, numerator, denominator=1, minimum=0):
    return min(65535, max(minimum, value * numerator // denominator))


def calculate(case, raw_actor, raw_target, roll=255):
    """Return independently expected command-boundary values for one hit."""
    _, _, move, power, kind, category, contact, punch, stab, matchups = MATCHUPS[case['matchup']]
    actor = case['ability']
    defender = case['defender_ability']
    if actor == 'NEUTRALIZING_GAS' or defender == 'NEUTRALIZING_GAS':
        actor = defender = 'NO_ABILITY'
    elif actor == 'MOLD_BREAKER':
        defender = 'NO_ABILITY'
    item = 'NO_ITEM' if actor == 'KLUTZ' else case['item']
    target_item = 'NO_ITEM' if defender == 'KLUTZ' else case['defender_item']
    critical = case['critical'] and defender not in ('BATTLE_ARMOR', 'SHELL_ARMOR')
    defense_category = 0 if move == 'PSYSHOCK' else category
    ai, di = (0 if category == 0 else 3), (1 if defense_category == 0 else 4)
    offense_stage, defense_stage = case['offense_stage'], case['defense_stage']
    if (critical and offense_stage < 0) or defender == 'UNAWARE':
        offense_stage = 0
    if (critical and defense_stage > 0) or actor == 'UNAWARE':
        defense_stage = 0
    status_cut = (category == 0 and case['burn']) or (category == 1 and case.get('frostbite', False))
    attack = staged(raw_actor[ai], offense_stage, status_cut)
    defense = staged(raw_target[di], defense_stage)
    screen_mask = 16 if defense_category == 0 else 8
    if case['screens'] & screen_mask and not critical and actor != 'INFILTRATOR':
        defense *= 2
    if case['matchup'] == 'rock-sand' and case['weather'] == 'sandstorm':
        defense = defense * 3 // 2
    if case['matchup'] == 'ice-hail' and case['weather'] == 'hail':
        defense = defense * 3 // 2
    if target_item == 'EVIOLITE' and case['matchup'].startswith('eviolite'):
        defense = defense * 3 // 2
    if target_item == 'ASSAULT_VEST' and defense_category == 1:
        defense = defense * 3 // 2
    # Gen II jointly rescales the chosen stats in powers of four, with
    # nonzero floors, until both fit the byte-sized ordinary formula.
    while max(attack, defense) > 255:
        attack, defense = max(1, attack // 4), max(1, defense // 4)
    base = ((2 * case['level'] // 5 + 2) * power * attack // defense) // 50
    if (item, kind) in (('CHARCOAL', 'FIRE'), ('MYSTIC_WATER', 'WATER')):
        base = base * 120 // 100
    base = min(997, base) + 2
    if case.get('glaive_rush'):
        base = scaled(base, 2)
    value = base
    weather = case['weather']
    if (weather, kind) in (('rain', 'WATER'), ('sun', 'FIRE')):
        value = scaled(value, 3, 2, 1)
    elif (weather, kind) in (('rain', 'FIRE'), ('sun', 'WATER')):
        value = scaled(value, 1, 2, 1)
    if critical:
        value = scaled(value, 3, 2)
    if stab:
        value = scaled(value, 3, 2)
    effective = Fraction(1)
    for multiplier in matchups:
        multiplier = Fraction(multiplier)
        effective *= multiplier
        value = scaled(value, multiplier.numerator, multiplier.denominator, int(bool(value and multiplier)))
    if not effective:
        return dict(attack=attack, defense=defense, power=power, category=category,
                    critical=int(critical), base=base, modifiers=0, final=0)

    # The project intentionally applies these boosts to damage, after +2,
    # weather, critical damage and STAB/type effectiveness.
    if item == 'METRONOME_ITEM':
        value = scaled(value, 200, 100, 1)
    elif item == 'PUNCHING_GLOVE' and punch:
        value = scaled(value, 110, 100, 1)
    if item == 'CHOICE_BAND' and category == 0 or item == 'CHOICE_SPECS' and category == 1:
        value = scaled(value, 150, 100, 1)
    elif item == 'EXPERT_BELT' and effective > 1:
        value = scaled(value, 120, 100, 1)
    elif item == 'LIFE_ORB':
        value = scaled(value, 130, 100, 1)
    elif item == 'MUSCLE_BAND' and category == 0 or item == 'WISE_GLASSES' and category == 1:
        value = scaled(value, 110, 100, 1)
    if actor == 'HUGE_POWER' and category == 0:
        value = scaled(value, 2)
    elif actor == 'GUTS' and category == 0 and (case['burn'] or case.get('frostbite')):
        if case['burn']:
            value = scaled(value, 2)
        value = scaled(value, 3, 2)
    elif actor == 'HUSTLE' and category == 0:
        value = scaled(value, 3, 2)
    elif actor == 'TECHNICIAN' and power <= 60:
        value = scaled(value, 3, 2)
    elif actor == 'TINTED_LENS' and effective < 1:
        value = scaled(value, 2)
    elif actor == 'SOLAR_POWER' and category == 1 and weather == 'sun':
        value = scaled(value, 3, 2)
    elif actor == 'TOUGH_CLAWS' and contact and not (item == 'PUNCHING_GLOVE' and punch):
        value = scaled(value, 130, 100, 1)
    elif actor == 'IRON_FIST' and punch:
        value = scaled(value, 120, 100, 1)
    elif actor == 'SHEER_FORCE' and move in ('FIRE_PUNCH', 'FLAMETHROWER', 'WATERFALL', 'THUNDERBOLT', 'ICE_BEAM', 'PSYCHIC_M'):
        value = scaled(value, 130, 100, 1)
    elif actor == 'SNIPER' and critical:
        value = scaled(value, 3, 2)
    elif actor == 'ADAPTABILITY' and stab:
        value = scaled(value, 133, 100, 1)
    elif actor == 'MEGA_SOL' and weather != 'sun':
        if kind == 'FIRE':
            if weather == 'rain':
                value = scaled(value, 2)
            value = scaled(value, 3, 2)
        elif kind == 'WATER':
            value = scaled(value, 33, 100, 1) if weather == 'rain' else scaled(value, 1, 2, 1)
    if defender == 'THICK_FAT' and kind in ('FIRE', 'ICE') or defender == 'MULTISCALE':
        value = scaled(value, 1, 2, 1)
    elif defender == 'FUR_COAT' and defense_category == 0:
        value = scaled(value, 1, 2, 1)
    elif defender == 'MARVEL_SCALE' and defense_category == 0 and case.get('defender_status'):
        value = scaled(value, 2, 3, 1)
    elif defender in ('FILTER', 'SOLID_ROCK') and effective > 1:
        value = scaled(value, 1, 2, 1) if effective >= 4 else max(1, value - value // 4)
    elif defender == 'DRY_SKIN' and kind == 'FIRE':
        value = scaled(value, 5, 4)
    elif defender == 'FLUFFY':
        if contact and not (item == 'PUNCHING_GLOVE' and punch):
            value = scaled(value, 1, 2, 1)
        if kind == 'FIRE':
            value = scaled(value, 2)
    return dict(attack=attack, defense=defense, power=power, category=category,
                critical=int(critical), base=base, modifiers=value,
                final=value * roll // 255 if value >= 2 else value)
