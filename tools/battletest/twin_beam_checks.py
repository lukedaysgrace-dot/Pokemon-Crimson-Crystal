#!/usr/bin/env python3
"""Exercise independent Twin Beam rolls, damage timing and both beam phases."""

import json
from itertools import product

from PIL import Image

from mae_animation_checks import capture, stage
from october_animation_checks import AnimationAudit
from probability_checks import call
from runner import Harness, ROOT
from symbols import STATE_DONE, STATE_WAIT, _parse_constants


def main():
    output = ROOT / '.tmpbuild/twin-beam'
    output.mkdir(parents=True, exist_ok=True)
    h = Harness()
    h.ensure_fixture()
    effects = _parse_constants(ROOT / 'constants/move_effect_constants.asm')
    effect = effects['EFFECT_SP_DEF_DOWN_DOUBLE_HIT']
    active = None
    rolls, hits, phases = [], [], []

    def is_twin_beam():
        m = h.battle.mem
        side = m.read('hBattleTurn')
        struct = 'wEnemyMoveStruct' if side else 'wPlayerMoveStruct'
        return active is not None and side == active[0] and m.read(struct, 1) == effect

    def roll_secondary(_):
        if is_twin_beam():
            value = active[1][len(rolls)]
            rolls.append(value)
            h.battle.mem.write('hDebugRNGValue', value)

    def before_animation(_):
        if is_twin_beam():
            # All other RNG calls retain the ordinary forced-high control.
            h.battle.mem.write('hDebugRNGValue', 0xb4)

    def before_damage(_):
        if is_twin_beam():
            m = h.battle.mem
            target = h.battle.player if active[0] else h.battle.enemy
            hits.append({'damage': m.read_u16_be('wCurDamage'),
                         'target_sp_def_stage': target.stat_levels[4],
                         'base_power': m.read('wDamageCalcBasePower')})

    def play_animation(_):
        m = h.battle.mem
        if active is not None and int.from_bytes(m.read_bytes('wFXAnimID', 2), 'little') == h.con.moves['TWIN_BEAM']:
            phases.append(m.read('wKickCounter'))

    h.pb.hook_register(*h.sym['BattleCommand_EffectChance_Core'], roll_secondary, None)
    h.pb.hook_register(*h.sym['BattleCommand_MoveAnimNoSub'], before_animation, None)
    h.pb.hook_register(*h.sym['BattleCommand_ApplyDamage_'], before_damage, None)
    h.pb.hook_register(*h.sym['PlaySelectedFXAnim'], play_animation, None)
    results, knockouts = [], []
    try:
        # 10%, like Psychic, is encoded as 25/256. Boundary rolls prove each hit samples its
        # own chance; all four success/failure combinations must be reachable.
        for side, pair in product((0, 1), product((24, 25), repeat=2)):
            h.load_fixture()
            h.battle.mem.write('wOptions', 0x41)
            user = {'species': 'MEW', 'level': 50, 'ability': 'NO_ABILITY', 'moves': ['TWIN_BEAM']}
            target = {'species': 'SNORLAX', 'level': 100, 'ability': 'NO_ABILITY', 'moves': ['SPLASH']}
            assert h.run_battle({'player': target if side else user,
                                 'enemy': user if side else target,
                                 'rng': 'forced_high', 'turns': 0}) == STATE_WAIT
            rolls.clear()
            hits.clear()
            phases.clear()
            active = (side, pair)
            m = h.battle.mem
            m.write('wDebugTurnTarget', 1)
            m.write('wDebugControl', 1)
            for frame in range(10000):
                if frame % 6 == 0:
                    h.pb.button('a', 2)
                h.tick(1)
                if h.state() == STATE_WAIT and h.battle.turns_done == 1:
                    break
            else:
                raise AssertionError(('battle timeout', side, pair, h.control_state()))
            active = None
            defender = h.battle.player if side else h.battle.enemy
            assert rolls == list(pair), (side, pair, rolls)
            assert len(hits) == 2 and all(hit['base_power'] == 45 for hit in hits), hits
            assert [hit['target_sp_def_stage'] for hit in hits] == [7, 7 - int(pair[0] < 25)], hits
            assert defender.stat_levels[4] == 7 - sum(roll < 25 for roll in pair), (pair, defender.stat_levels)
            assert phases == [0, 1], (side, pair, phases)
            if pair[0] < 25:
                assert hits[1]['damage'] > hits[0]['damage'], hits
            else:
                assert hits[1]['damage'] == hits[0]['damage'], hits
            results.append({'side': side, 'rolls': list(pair), 'hits': list(hits), 'animation_phases': list(phases)})
            print('PASS independent rolls / damage timing / animation phases', side, pair, flush=True)

        # Enumerate every RNG byte through the actual chance routine with
        # Twin Beam's real move data, including Serene Grace and suppression.
        probability = []
        for side in (0, 1):
            # Reuse the move structures populated by the last native battle.
            m.write('hBattleTurn', side)
            # The other side's Splash struct is replaced by Twin Beam's data.
            src = 'wEnemyMoveStruct'
            dst = 'wEnemyMoveStruct' if side else 'wPlayerMoveStruct'
            m.write_bytes(dst, m.read_bytes(src, 8))
            for user_ability, target_ability, count in (
                    ('NO_ABILITY', 'NO_ABILITY', 25), ('SERENE_GRACE', 'NO_ABILITY', 50),
                    ('SHEER_FORCE', 'NO_ABILITY', 0), ('NO_ABILITY', 'SHIELD_DUST', 0)):
                m.write('wPlayerAbility', h.con.ability_id(target_ability if side else user_ability))
                m.write('wEnemyAbility', h.con.ability_id(user_ability if side else target_ability))
                successes = 0
                for value in range(256):
                    m.write('hDebugRNGValue', value)
                    call(h, 'BattleCommand_EffectChance_Core')
                    passed = m.read('wEffectFailed') == 0
                    assert passed == (value < count), (side, user_ability, target_ability, value)
                    successes += passed
                assert successes == count
                probability.append({'side': side, 'user': user_ability, 'target': target_ability, 'successes_of_256': successes})
                print('PASS chance threshold', probability[-1], flush=True)

        # Fainting clears Rage Fist's counter, so observe the actual damage
        # routine to prove that a first-hit KO never executes a second hit.
        for side in (0, 1):
            h.load_fixture()
            h.battle.mem.write('wOptions', 0x41)
            user = {'species': 'MEW', 'level': 100, 'ability': 'NO_ABILITY', 'moves': ['TWIN_BEAM']}
            target = {'species': 'MAGIKARP', 'level': 5, 'ability': 'NO_ABILITY', 'moves': ['SPLASH']}
            assert h.run_battle({'player': target if side else user, 'enemy': user if side else target,
                                 'rng': 'forced_high', 'turns': 0}) == STATE_WAIT
            rolls.clear()
            hits.clear()
            phases.clear()
            active = (side, (25, 25))
            m.write('wDebugTurnTarget', 1)
            m.write('wDebugControl', 1)
            for frame in range(10000):
                if frame % 6 == 0:
                    h.pb.button('a', 2)
                h.tick(1)
                if h.state() in (STATE_WAIT, STATE_DONE) and h.battle.turns_done == 1:
                    break
            else:
                raise AssertionError(('KO timeout', side, h.control_state()))
            active = None
            defender = h.battle.player if side else h.battle.enemy
            assert defender.hp == 0 and len(hits) == 1 and phases == [0], (side, hits, phases)
            knockouts.append({'side': side, 'damage_hits': len(hits), 'animation_phases': list(phases)})
            print('PASS first-hit KO stops damage and animation', side, flush=True)
    finally:
        h.pb.stop(save=False)

    # Render both phases from both sides and audit the real object graphics,
    # tiles, palettes and cleanup, rather than only checking changed pixels.
    h, fixture = stage(ROOT / 'pokecrystal_debug.gbc')
    audit = AnimationAudit(h, ROOT / 'pokecrystal_debug.gbc')
    visuals = []
    try:
        for side, param in product((0, 1), repeat=2):
            audit.current = f'TWIN_BEAM/{side}/{param}'
            audit.spawns.clear()
            frames, _, check = capture(h, fixture, 'TWIN_BEAM', side, param=param, observer=audit.observe)
            assert not audit.errors, audit.errors
            beams = [spawn for spawn in audit.spawns if spawn['object'] in ('ANIM_OBJ_LEER', 'ANIM_OBJ_LEER_TIP')]
            assert len(beams) == 5, beams
            assert [(spawn['x'], spawn['y']) for spawn in beams] == (
                [(64, 80), (80, 72), (96, 64), (112, 56), (122, 50)] if param else
                [(72, 84), (88, 76), (104, 68), (120, 60), (130, 54)]), beams
            assert check['final_frame_changed_pixels'] == 0, check
            shot = Image.new('RGB', (960, 288))
            for cell, index in enumerate((len(frames)//3, len(frames)//2, len(frames)*2//3)):
                shot.paste(Image.fromarray(frames[index]).resize((320, 288), Image.Resampling.NEAREST), (cell*320, 0))
            shot.save(output / f'animation-{side}-{param}.png')
            visuals.append(check)
            print('PASS rendered animation', side, param, flush=True)
    finally:
        h.pb.stop(save=False)
    (output / 'checks.json').write_text(json.dumps({'independent_hits': results, 'first_hit_knockouts': knockouts, 'probabilities': probability,
                                                   'visuals': visuals}, indent=2) + '\n')


if __name__ == '__main__':
    main()
