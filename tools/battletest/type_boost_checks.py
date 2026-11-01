#!/usr/bin/env python3
"""Check exact 1.2x type-item math in native turns, on both battle sides."""

from runner import Harness
from symbols import STATE_WAIT, STATE_DONE


# Explicit fixtures keep coverage independent of the table being tested.
CASES = [
    ('PINK_BOW', 'TACKLE'),
    ('BLACKBELT', 'BRICK_BREAK'),
    ('SHARP_BEAK', 'WING_ATTACK'),
    ('POISON_BARB', 'SLUDGE_BOMB'),
    ('SOFT_SAND', 'EARTHQUAKE'),
    ('HARD_STONE', 'ROCK_SLIDE'),
    ('SILVERPOWDER', 'BUG_BITE'),
    ('SPELL_TAG', 'SHADOW_BALL'),
    ('CHARCOAL', 'FLAMETHROWER'),
    ('MYSTIC_WATER', 'SURF'),
    ('MIRACLE_SEED', 'ENERGY_BALL'),
    ('MAGNET', 'THUNDERBOLT'),
    ('TWISTEDSPOON', 'PSYCHIC_M'),
    ('NEVERMELTICE', 'ICE_BEAM'),
    ('DRAGON_FANG', 'DRAGON_PULSE'),
    ('BLACKGLASSES', 'DARK_PULSE'),
    ('METAL_COAT', 'FLASH_CANNON'),
    ('POLKADOT_BOW', 'PIXIE_PUNCH'),
]


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    active_side = 0
    products = []
    turns = 0

    def after_item(_):
        m = h.battle.mem
        if m.read('hBattleTurn') == active_side:
            products.append(int.from_bytes(m.read_bytes('hProduct', 4), 'big'))

    h.pb.hook_register(*h.sym['ConfusionDamageCalc.DoneItem'], after_item, None)

    def damage(side, move, item='NO_ITEM', ability='NO_ABILITY'):
        nonlocal active_side, turns
        h.load_fixture()
        active_side = side
        products.clear()
        attacker = dict(species='MEW', level=100, ability=ability, item=item, moves=[move])
        defender = dict(species='MEW', level=100, ability='NO_ABILITY', moves=['SPLASH'])
        state = h.run_battle(dict(player=defender if side else attacker,
                                  enemy=attacker if side else defender,
                                  rng='forced_low', turns=1))
        assert state in (STATE_WAIT, STATE_DONE), (item, move, state)
        # Interrupts can run a hook twice at the same instruction.
        assert products and len(set(products)) == 1, (item, move, products)
        turns += 1
        return products[0]

    try:
        for side in (0, 1):
            for item, move in CASES:
                baseline = damage(side, move)
                boosted = damage(side, move, item)
                suppressed = damage(side, move, item, 'KLUTZ')
                assert baseline > 0
                assert boosted == baseline * 120 // 100, (side, item, baseline, boosted)
                assert suppressed == baseline, (side, item, 'Klutz', baseline, suppressed)
                print(f'PASS side={side} {item}: {baseline} -> {boosted}; Klutz={suppressed}', flush=True)
            for item, move in [('POLKADOT_BOW', 'TACKLE'), ('PINK_BOW', 'PIXIE_PUNCH')]:
                assert damage(side, move, item) == damage(side, move), (side, item, 'wrong type')
        print(f'TYPE BOOST ITEMS PASSED: all 18 types, both sides, {turns} native turns', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
