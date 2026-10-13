#!/usr/bin/env python3
"""Release-ROM capture modifier and HM ownership/badge/party boundaries.

Uses private in-memory SRAM and executes the native routines unchanged.
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
    events = _parse_constants(Path(ROOT) / 'constants/event_flags.asm')
    checks, failures = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)
            if len(failures) <= 20:
                print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    print('[Level Ball: strict level-ratio boundaries and rate saturation]', flush=True)
    for player, enemy in product((1, 24, 25, 26, 49, 50, 51, 99, 100), repeat=2):
        write('wBattleMonLevel', player)
        write('wEnemyMonLevel', enemy)
        multiplier = 8 if player // 4 > enemy else 4 if player // 2 > enemy else 2 if player > enemy else 1
        for rate in (1, 31, 32, 63, 64, 127, 128, 254, 255):
            result = h.call('LevelBallMultiplier', bc=rate << 8)
            check(result['b'] == min(255, rate * multiplier), f'Level Ball {player}/{enemy}, rate {rate}')

    print('[Moon Ball: evolution-item eligibility and every rate byte]', flush=True)
    for species, eligible in (('NIDORINA', True), ('NIDORINO', True), ('CLEFAIRY', True),
                              ('JIGGLYPUFF', True), ('EEVEE', False), ('PIKACHU', False)):
        write('wTempEnemyMonSpecies', h.species_id(con.species_index(species)))
        for rate in range(256):
            write('wCurItem', con.items['MOON_BALL'])
            result = h.call('MoonBallMultiplier', bc=rate << 8)
            check(result['b'] == min(255, rate * (4 if eligible else 1)), f'Moon Ball {species}, rate {rate}')
            check(h.rd(h.s('wCurItem')) == con.items['MOON_BALL'], 'Moon Ball changed the selected item')

    print('[Love Ball: stored genders, genderless species and every rate byte]', flush=True)
    write('wCurBattleMon', 0)
    for player, enemy, male, enemy_male in product(('PIKACHU', 'DITTO'), ('PIKACHU', 'DITTO'), (0, 1), (0, 1)):
        write('wTempBattleMonSpecies', h.species_id(con.species_index(player)))
        write('wTempEnemyMonSpecies', h.species_id(con.species_index(enemy)))
        write('wPartyMon1Unused', male << 6)
        write('wEnemyMonShinyGenderFlags', enemy_male << 6)
        eligible = player == enemy == 'PIKACHU' and male != enemy_male
        for rate in range(256):
            result = h.call('LoveBallMultiplier', bc=rate << 8)
            check(result['b'] == min(255, rate * (8 if eligible else 1)),
                  f'Love Ball {player}/{enemy}, genders {male}/{enemy_male}, rate {rate}')

    print('[HM gates: seven HMs, all badge masks, pocket/story ownership]', flush=True)
    capable = h.species_id(con.species_index('MEW'))
    incapable = h.species_id(con.species_index('MAGIKARP'))
    pocket_size = h.s('wTMsHMsEnd') - h.s('wTMsHMs')
    for move, badge, event in (('CUT', 1, 'EVENT_GOT_HM01_CUT'), ('FLY', 5, 'EVENT_GOT_HM02_FLY'),
                               ('SURF', 3, 'EVENT_GOT_HM03_SURF'), ('STRENGTH', 2, 'EVENT_GOT_HM04_STRENGTH'),
                               ('FLASH', 0, 'EVENT_GOT_HM05_FLASH'), ('WHIRLPOOL', 6, 'EVENT_GOT_HM06_WHIRLPOOL'),
                               ('WATERFALL', 7, 'EVENT_GOT_HM07_WATERFALL')):
        index = con.move_index(move)
        for ownership in ('none', 'pocket', 'story'):
            write('wTMsHMs', bytes([int(ownership == 'pocket')] * pocket_size))
            h.call('EventFlagAction', bc=int(ownership == 'story') << 8, de=events[event])
            write('wPartyCount', 1)
            write('wPartySpecies', [capable, 255])
            for badges in range(256):
                write('wJohtoBadges', badges)
                result = h.call('CheckFieldHMAllow', hl=index)
                expected = ownership != 'none' and bool(badges & (1 << badge))
                check((not result['c_flag']) == expected, f'{move}: ownership {ownership}, badges {badges:#x}')
            if ownership == 'none':
                continue
            write('wJohtoBadges', 255)
            for slot in range(6):
                write('wPartyCount', 6)
                write('wPartySpecies', [capable if i == slot else 253 for i in range(6)] + [255])
                result = h.call('CheckFieldHMAllow', hl=index)
                check(not result['c_flag'] and h.rd(h.s('wCurPartyMon')) == slot, f'{move}: eligible slot {slot}')
            for party in ([], [253], [incapable], [253, incapable, 253]):
                write('wPartyCount', len(party))
                write('wPartySpecies', party + [255])
                check(h.call('CheckFieldHMAllow', hl=index)['c_flag'], f'{move}: accepted incompatible party {party}')

    h.pyboy.stop(save=False)
    print(f'CAPTURE/FIELD GATES: {checks} checks, {len(failures)} failures; {h.calls} routine calls')
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
