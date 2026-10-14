#!/usr/bin/env python3
"""Verify badges cannot alter battle stats or typed damage in the release ROM.

Runs native battle entry, stat refresh, Baton Pass status fixups, burned
Attack reconstruction and the combined weather/STAB/type-damage command.
Cartridge state is private; no player save is loaded or written.
"""
from itertools import product
from pathlib import Path
import sys

from pc_harness import Harness, ROOT
from battletest.symbols import Constants, _parse_constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(rom=str(rom), sym=str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    types = _parse_constants(Path(ROOT) / 'constants/type_constants.asm')
    effects = _parse_constants(Path(ROOT) / 'constants/move_effect_constants.asm')
    checks, failures = 0, []

    def write(name, value):
        h.wr(h.s(name), value)

    def be(name, value):
        write(name, value.to_bytes(2, 'big'))

    def stats():
        return tuple(int.from_bytes(h.rd(h.s('wBattleMonAttack') + i * 2, 2), 'big')
                     for i in range(5))

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)
            print('FAIL:', message, flush=True)

    masks = [(0, 0)] + [(1 << bit, 0) for bit in range(8)] + [
        (0, 1 << bit) for bit in range(8)] + [(255, 0), (0, 255), (255, 255)]
    raw = (160, 240, 320, 400, 480)
    write('wPartyCount', 1)
    write('wCurBattleMon', 0)
    write('wCurPartyMon', 0)
    write('wBattleMode', 1)
    write('wPartyMon1Species', con.species_index('MEW'))
    write('wPartyMon1Level', 50)
    be('wPartyMon1HP', 500)
    be('wPartyMon1MaxHP', 500)
    for name, value in zip(('Attack', 'Defense', 'Speed', 'SpclAtk', 'SpclDef'), raw):
        be('wPartyMon1' + name, value)
    print('[battle entry, stage refresh and Baton Pass preserve stats without badge bonuses]', flush=True)
    for status, mode in product((0, 16, 64, 32), ((0, 0), (1, 0), (0, 1))):
        baseline = None
        for johto, kanto in masks:
            write('wJohtoBadges', johto)
            write('wKantoBadges', kanto)
            write('wLinkMode', mode[0])
            write('wInBattleTowerBattle', mode[1])
            write('wPartyMon1Status', status)
            h.call('InitBattleMon')
            write('wPlayerAbility', con.ability_id('NO_ABILITY'))
            initial = stats()
            expected = list(raw)
            if status == 16:
                expected[0] //= 2
            elif status == 64:
                expected[2] //= 2
            elif status == 32:
                expected[3] //= 2
            check(initial == tuple(expected), f'entry {status, mode, johto, kanto}: {initial}')
            write('wPlayerAtkLevel', [9, 7, 5, 11, 3])
            write('hBattleTurn', 0)
            h.call('CalcPlayerStats')
            refreshed = stats()
            if baseline is None:
                baseline = refreshed
            check(refreshed == baseline, f'stat refresh {status, mode, johto, kanto}: {refreshed}')
            # Baton Pass rebuilds raw stats with the incoming stages, then
            # restores the incoming mon's normal status penalties.
            write('wApplyStatLevelMultipliersToEnemy', 0)
            h.call('ApplyStatLevelMultiplierOnAllStats')
            h.call('PassedBattleMonFixups_Core')
            check(stats() == baseline, f'Baton Pass {status, mode, johto, kanto}: {stats()}')

    print('[burned Attack reconstruction retains stages and the normal stat cap]', flush=True)
    for stage, raw_attack in product(range(1, 14), (1, 7, 161, 800, 999)):
        baseline = None
        for johto, kanto in masks:
            write('wJohtoBadges', johto)
            write('wKantoBadges', kanto)
            write('wLinkMode', 0)
            write('wInBattleTowerBattle', 0)
            be('wPlayerAttack', raw_attack)
            write('wPlayerAtkLevel', stage)
            result = h.call('RebuildUnburnedAttack_Core', hl=h.s('wBattleMonAttack'))['hl']
            if baseline is None:
                baseline = result
            check(result == baseline and 1 <= result <= 999,
                  f'rebuilt Attack {stage, raw_attack, johto, kanto}: {result}')

    print('[every real move type: weather, STAB and effectiveness are badge-independent]', flush=True)
    real_types = ('NORMAL FIGHTING FLYING POISON GROUND ROCK BUG GHOST STEEL '
                  'FIRE WATER GRASS ELECTRIC PSYCHIC ICE DRAGON DARK FAIRY').split()
    for turn, weather, stab, type_name in product((0, 1), (0, 1), (False, True), real_types):
        baseline = None
        for johto, kanto in masks:
            write('wJohtoBadges', johto)
            write('wKantoBadges', kanto)
            write('wBattleWeather', weather)
            write('hBattleTurn', turn)
            write('wCriticalHit', 0)
            write('wAttackMissed', 0)
            write('wTypeModifier', 10)
            write('wPlayerAbility', con.ability_id('NO_ABILITY'))
            write('wEnemyAbility', con.ability_id('NO_ABILITY'))
            write('wBattleMonItem', 0)
            write('wEnemyMonItem', 0)
            attacker, defender = ('wEnemy', 'wBattle') if turn else ('wBattle', 'wEnemy')
            write(attacker + 'MonType1', [types[type_name] if stab else types['BIRD']] * 2)
            write(defender + 'MonType1', [types['NORMAL']] * 2)
            move = 'wEnemyMoveStruct' if turn else 'wPlayerMoveStruct'
            write(move + 'Animation', con.move_index('TACKLE'))
            write(move + 'Type', types[type_name])
            write(move + 'Effect', effects['EFFECT_NORMAL_HIT'])
            be('wCurDamage', 160)
            h.call('BattleCommand_Stab')
            damage = int.from_bytes(h.rd(h.s('wCurDamage'), 2), 'big')
            if baseline is None:
                baseline = damage
            check(damage == baseline, f'typed damage {turn, weather, stab, type_name, johto, kanto}: {damage}')
            if type_name == 'NORMAL' and weather == 0:
                check(damage == (240 if stab else 160), f'ordinary STAB changed: {damage}')

    h.pyboy.stop(save=False)
    print(f'BADGE BONUS REMOVAL: {checks} checks; {len(failures)} failures', flush=True)
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
