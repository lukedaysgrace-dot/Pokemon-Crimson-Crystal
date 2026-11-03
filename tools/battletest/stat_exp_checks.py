#!/usr/bin/env python3
"""Native battle Stat EXP awards and deferred stat refresh, on both ROMs.

Uses private PyBoy cartridges; no player save files are accessed. Routine
cases start from a real battle menu and execute the unmodified award/exit
paths, with ordinary A-button input for EXP/level-up text. Full wild battles
also verify entry, KO, exit and the next battle's loaded stats.
"""
import io
import json
import math
from pathlib import Path
import sys

from gameplay_rules_checks import new_game
from probability_checks import call
from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from symbols import _parse_constants
from ui_checks import tile_text


def words(values):
    return b''.join(v.to_bytes(2, 'big') for v in values)


def unpack(data):
    return [int.from_bytes(data[i:i + 2], 'big') for i in range(0, len(data), 2)]


def run(rom):
    h = Harness(rom_path=rom, render=False)
    m = h.battle.mem
    checks = 0
    cases = []
    calculations = []
    battle_menus = []
    out = ROOT / '_artifacts/stat-exp' / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    hard_bit = _parse_constants(ROOT / 'constants/wram_constants.asm')['STATUSFLAGS2_HARD_MODE_F']

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            raise AssertionError(f'{rom.name}: {label}; PC={h.where()}\n{tile_text(h)}')

    def hook(symbol, callback):
        h.pb.hook_register(*h.sym[symbol], callback, None)

    def completed():
        return h.pb.register_file.PC in (0xC0F1, 0xC0F3)

    def execute(symbol):
        begin_native_call(h, symbol)
        h.pb.memory[0xC0F0] = 0xF3
        for frame in range(12000):
            if completed():
                h.pb.button_release('a')
                return
            if frame % 12 == 0:
                h.pb.button('a', 2)
            h.tick()
        raise AssertionError(f'{symbol} did not return: {h.where()}; {tile_text(h)}')

    def exp_at(slot, level):
        m.write('wCurSpecies', m.read(f'wPartyMon{slot + 1}Species'))
        call(h, 'GetBaseData')
        call(h, 'CalcExpAtLevel', D=level)
        return int.from_bytes(m.read_bytes('hQuotient', 4)[1:], 'big')

    def recalc(slot):
        p = f'wPartyMon{slot + 1}'
        m.write('wCurPartyMon', slot)
        m.write('wCurSpecies', m.read(p + 'Species'))
        m.write('wCurPartyLevel', m.read(p + 'Level'))
        call(h, 'GetBaseData')
        call(h, 'UpdateStatsAfterItem')

    def stats(slot):
        return unpack(m.read_bytes(f'wPartyMon{slot + 1}MaxHP', 12))

    def stat_exp(slot):
        return unpack(m.read_bytes(f'wPartyMon{slot + 1}StatExp', 10))

    def hp(slot):
        return m.read_u16_be(f'wPartyMon{slot + 1}HP')

    def expected(slot):
        p = f'wPartyMon{slot + 1}'
        m.write('wCurSpecies', m.read(p + 'Species'))
        call(h, 'GetBaseData')
        bases = m.read_bytes('wBaseStats', 6)
        a, b = m.read_bytes(p + 'DVs', 2)
        dvs = [((a >> 4 & 1) << 3) | ((a & 1) << 2) | ((b >> 4 & 1) << 1) | (b & 1),
               a >> 4, a & 15, b >> 4, b & 15, b & 15]
        result = []
        for i, base in enumerate(bases):
            value = stat_exp(slot)[min(i, 4)]
            root = min(255, math.isqrt(value) + (math.isqrt(value) ** 2 < value))
            level = m.read(p + 'Level')
            result.append(min(999, ((base + dvs[i]) * 2 + root // 4) * level // 100
                              + (level + 10 if i == 0 else 5)))
        return result

    def start_wild():
        battle_menus.clear()
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MAGIKARP'))
        m.write('wTempWildMonSpecies', sid)
        m.write('wCurPartySpecies', sid)
        m.write('wCurPartyLevel', 5)
        m.write('wOtherTrainerClass', 0)
        m.write('wBattleType', 0)
        begin_native_call(h, 'StartBattle')
        h.pb.memory[0xC0F0] = 0xF3
        for _ in range(4000):
            if battle_menus and 'FIGHT' in tile_text(h):
                h.tick(60)
                return
            h.pb.button('a', 2)
            h.tick(4)
        raise AssertionError('wild menu did not open: ' + h.where())

    try:
        hook('BattleMenu', lambda _: battle_menus.append(True))
        new_game(h, 0)
        # Build a legal six-mon party with the real constructor, on either ROM.
        m.write('wPartyCount', 0)
        m.write('wMonType', 0)
        m.write('wBattleMode', 0)
        move = call(h, 'GetMoveIDFromIndex', HL=h.con.move_index('AERIAL_ACE'))
        for slot, species in enumerate(('MEW', 'MIENSHAO', 'AEGISLASH', 'ZOROARK', 'HIPPOWDON', 'SHUCKLE')):
            index = h.con.species_index(species)
            sid = call(h, 'GetPokemonIDFromIndex', HL=index)
            m.write('wCurPartySpecies', sid)
            m.write('wCurPartyLevel', 50)
            call(h, 'TryAddMonToParty')
            m.write_bytes(f'wPartyMon{slot + 1}Moves', [move, 0, 0, 0])
            m.write_bytes(f'wPartyMon{slot + 1}PP', [20, 0, 0, 0])
            m.write_bytes(f'wPartyMon{slot + 1}DVs', [0x96, 0x3a])
            m.write_bytes(f'wPartyMon{slot + 1}StatExp', words([1521] * 5))
            m.write(f'wPartyMon{slot + 1}PokerusStatus', 0)
            recalc(slot)
            m.write_bytes(f'wPartyMon{slot + 1}HP', words([stats(slot)[0] - 7]))
        m.write('wOptions', 0xc1)  # FAST, animations off, SET
        m.write('wDebugFlags', 0)
        start_wild()
        baseline = io.BytesIO()
        h.pb.save_state(baseline)
        hook('CalcMonStats', lambda _: calculations.append(m.read('wCurPartyMon')))

        def configure(level=50, hard=False, values=None, count=6, mode=0):
            baseline.seek(0)
            h.pb.load_state(baseline)
            m.write('wPartyCount', count)
            m.write('wGameplayRules', mode << 1)
            flags = m.read('wStatusFlags2') & ~(1 << hard_bit)
            m.write('wStatusFlags2', flags | ((1 << hard_bit) if hard else 0))
            m.write_bytes('wBadges', [0, 0])
            for slot in range(count):
                p = f'wPartyMon{slot + 1}'
                m.write(p + 'Level', level)
                m.write_bytes(p + 'Exp', exp_at(slot, level).to_bytes(3, 'big'))
                m.write_bytes(p + 'StatExp', words(values or [1521] * 5))
                m.write(p + 'Status', 0)
                m.write(p + 'PokerusStatus', 0)
                m.write(p + 'Item', 0)
                recalc(slot)
                m.write_bytes(p + 'HP', words([stats(slot)[0] - 7]))
            m.write('wCurPartyMon', 0)
            m.write('wCurBattleMon', 0)
            m.write('wTempBattleMonSpecies', m.read('wPartyMon1Species'))
            call(h, 'InitBattleMon')
            m.write('wPendingStatExpRecalcs', 0)
            m.write('wLinkMode', 0)
            m.write('wInBattleTowerBattle', 0)
            m.write('wBattleMode', 1)
            m.write('wEnemyMonLevel', 1)
            m.write('wEnemyMonBaseExp', 70)  # 10 regular EXP before sharing
            m.write_bytes('wEnemyMonBaseStats', [100, 120, 140, 160, 180])
            calculations.clear()

        def award(mask=1, shares=False):
            # A new opponent reloads these before each KO; division is in-place.
            m.write_bytes('wEnemyMonBaseStats', [100, 120, 140, 160, 180])
            m.write('wBattleParticipantsNotFainted', mask)
            m.write('wBattleParticipantsIncludingFainted', mask)
            # The ordinary KO handler performs both passes, including EXP Share.
            execute('UpdateBattleStateAndExperienceAfterEnemyFaint' if shares else 'GiveExperiencePoints')

        def finish(result=1):
            # LOSE/DRAW skip unrelated evolution/ability UI in routine cases.
            m.write('wBattleResult', result)
            execute('ExitBattle')

        for name, level, hard in (('no-level-up', 50, False), ('hard-cap', 10, True),
                                  ('level-100', 100, False), ('above-hard-cap', 50, True)):
            configure(level, hard)
            before = stats(0)
            original_mon = m.read_bytes('wPartyMon1', 50)
            old_exp = m.read_bytes('wPartyMon1Exp', 3)
            battle_stats = m.read_bytes('wBattleMonMaxHP', 12)
            award()
            check(stat_exp(0) == [1621, 1641, 1661, 1681, 1701], name + ': exact five-word award')
            check(stats(0) == before and m.read_bytes('wBattleMonMaxHP', 12) == battle_stats,
                  name + ': no mid-battle refresh')
            check(m.read('wPendingStatExpRecalcs') == 1 and not calculations, name + ': refresh pending')
            check(m.read('wPartyMon1Level') == level, name + ': level unchanged')
            if hard or level == 100:
                check(m.read_bytes('wPartyMon1Exp', 3) == old_exp, name + ': regular EXP blocked')
                check(m.read('wLevelCap') == (10 if hard else 100), name + ': level cap intact')
            else:
                check(int.from_bytes(m.read_bytes('wPartyMon1Exp', 3), 'big') == int.from_bytes(old_exp, 'big') + 10,
                      name + ': regular EXP unchanged')
            finish()
            check(stats(0) == expected(0) and stats(0) != before, name + ': formula reflected after battle')
            check(stats(0)[0] - hp(0) == 7, name + ': damage deficit preserved')
            check(m.read('wPendingStatExpRecalcs') == 0, name + ': pending cleared')
            check(set(calculations) == {0}, name + ': only recipient calculated')
            updated_mon = m.read_bytes('wPartyMon1', 50)
            check(all(a == b for i, (a, b) in enumerate(zip(original_mon, updated_mon))
                      if i not in {*range(8, 21), *range(36, 50)}),
                  name + ': DVs, moves, ability slot, status, level and unrelated fields unchanged')
            cases.append(name)

        configure()
        before = [stats(i) for i in range(6)]
        award(0b101011)
        check(m.read('wPendingStatExpRecalcs') == 0b101011, 'multiple participants: all tracked')
        finish()
        for slot in range(6):
            eligible = bool(0b101011 & (1 << slot))
            check(stats(slot) == (expected(slot) if eligible else before[slot]), f'multiple participants: slot {slot}')
            check(stats(slot)[0] - hp(slot) == 7, f'multiple participants: HP slot {slot}')
        check(set(calculations) == {0, 1, 3, 5}, 'multiple participants: no extra calculations')
        cases.append('multiple-participants')

        # Native switch entry adds each participant to the existing mask.
        configure()
        m.write('wBattleParticipantsNotFainted', 0)
        m.write('wBattleParticipantsIncludingFainted', 0)
        for slot in (0, 2, 4):
            m.write('wCurBattleMon', slot)
            call(h, 'AddBattleParticipant')
        check(m.read('wBattleParticipantsNotFainted') == 0b010101, 'switches register all participants')
        m.write('wCurBattleMon', 0)
        award(0b010101)
        award(0b000100)  # another KO after most participants switch out
        check(m.read('wPendingStatExpRecalcs') == 0b010101, 'later KO retains earlier recipients')
        finish()
        check(set(calculations) == {0, 2, 4}, 'switches: all recipients refreshed')
        check(stat_exp(2) == [1654, 1681, 1707, 1734, 1761], 'repeated KO: exact divided/cumulative award')
        check(stats(2) == expected(2), 'repeated KO: latest Stat EXP applied')
        cases.append('switching-and-repeated-awards')

        configure()
        m.write_bytes('wPartyMon2HP', words([0]))
        initial = m.read_bytes('wPartyMon2', 50)
        award(0b11)
        check(stat_exp(1) == [1521] * 5 and m.read('wPendingStatExpRecalcs') == 1,
              'fainted at KO excluded from awards')
        finish()
        check(m.read_bytes('wPartyMon2', 50) == initial, 'ineligible fainted mon untouched')
        cases.append('fainted-ineligible')

        for result in (0, 1, 2):
            configure()
            award()
            # A recipient can faint later in the battle, including on a loss.
            m.write_bytes('wPartyMon1HP', words([0]))
            finish(result)
            check(stats(0) == expected(0) and hp(0) == 0, f'fainted recipient: result {result}, no revival')
        cases.append('recipient-faints-before-exit-win-loss-draw')

        for values, pokerus in (([65500, 65534, 65535, 65400, 0], False), ([1521] * 5, True)):
            configure(values=values)
            m.write('wPartyMon1PokerusStatus', 0x23 if pokerus else 0)
            award()
            reward = [v * (2 if pokerus else 1) for v in (100, 120, 140, 160, 180)]
            check(stat_exp(0) == [min(65535, a + b) for a, b in zip(values, reward)], 'saturation/Pokerus unchanged')
            finish()
            check(stats(0) == expected(0) and stats(0)[0] - hp(0) == 7, 'saturation/Pokerus formula and HP')
        cases.extend(['stat-exp-saturation', 'pokerus'])

        # Exercise the real KO dispatcher, not a simulated EXP Share mask.
        for capped in (False, True):
            configure(level=100 if capped else 50)
            m.write('wPartyMon2Item', h.con.item_id('EXP_SHARE'))
            m.write('wPartyMon3Item', h.con.item_id('EXP_SHARE'))
            m.write_bytes('wPartyMon3HP', words([0]))  # fainted holder excluded
            m.write_bytes('wEnemyMonHP', words([0]))
            award(shares=True)
            check(stat_exp(0) == [1571, 1581, 1591, 1601, 1611], 'EXP Share: participant half')
            check(stat_exp(1) == [1571, 1581, 1591, 1601, 1611], 'EXP Share: nonparticipant holder half')
            check(stat_exp(2) == [1521] * 5, 'EXP Share: fainted holder ineligible')
            check(m.read('wPendingStatExpRecalcs') == 3, 'EXP Share: both recipients pending')
            finish()
            for slot in (0, 1):
                check(stats(slot) == expected(slot) and stats(slot)[0] - hp(slot) == 7,
                      f'EXP Share: level {100 if capped else 50}, slot {slot}')
        cases.append('exp-share-with-level-100-and-fainted-holder')

        configure(level=48)
        m.write_bytes('wPartyMon1Exp', (exp_at(0, 49) - 1).to_bytes(3, 'big'))
        award()
        check(m.read('wPartyMon1Level') == 49 and stats(0) == expected(0), 'normal level-up applies new Stat EXP')
        check(m.read('wPendingStatExpRecalcs') == 0 and bool(calculations), 'level-up clears pending refresh')
        after_level = m.read_bytes('wPartyMon1', 50)
        calculations.clear()
        finish()
        check(not calculations and m.read_bytes('wPartyMon1', 50) == after_level, 'no redundant post-level refresh')
        cases.append('normal-level-up-no-redundant-refresh')

        configure(level=48)
        m.write_bytes('wPartyMon1Exp', (exp_at(0, 49) - 1).to_bytes(3, 'big'))
        award()
        award()  # later award after the level-up still needs the exit refresh
        check(m.read('wPendingStatExpRecalcs') == 1, 'later award re-marks leveled mon')
        calculations.clear()
        finish()
        check(set(calculations) == {0} and stats(0) == expected(0), 'later award after level-up applied')
        cases.append('level-up-then-later-award')

        configure(level=48)
        m.write('wPartyMon1Item', h.con.item_id('EXP_SHARE'))
        m.write_bytes('wPartyMon1Exp', (exp_at(0, 49) - 1).to_bytes(3, 'big'))
        m.write_bytes('wEnemyMonHP', words([0]))
        award(shares=True)
        check(m.read('wPartyMon1Level') == 49 and m.read('wPendingStatExpRecalcs') == 1,
              'EXP Share second pass re-marks first-pass level-up')
        check(stat_exp(0) == [1621, 1641, 1661, 1681, 1701], 'participating EXP Share holder receives both halves')
        calculations.clear()
        finish()
        check(set(calculations) == {0} and stats(0) == expected(0), 'EXP Share after level-up refreshed once')
        check(stats(0)[0] - hp(0) == 7, 'EXP Share level-up preserves damage')
        cases.append('exp-share-second-pass-after-level-up')

        configure(level=9, hard=True)
        m.write_bytes('wPartyMon1Exp', (exp_at(0, 10) - 1).to_bytes(3, 'big'))
        m.write('wEnemyMonBaseExp', 255)
        m.write('wEnemyMonLevel', 100)
        award()
        check(m.read('wPartyMon1Level') == 10 and int.from_bytes(m.read_bytes('wPartyMon1Exp', 3), 'big') == exp_at(0, 10),
              'crossing Hard cap clamps regular EXP and level exactly')
        award()
        finish()
        check(m.read('wPartyMon1Level') == 10 and stats(0) == expected(0), 'post-cap Stat EXP refreshed without bypass')
        cases.append('level-up-to-hard-cap')

        for mode in (0, 1):
            configure(mode=mode)
            m.write_bytes('wPlayerStatLevels', [13, 1, 12, 2, 11, 3, 10])
            m.write_bytes('wBattleMonAttack', [3, 231] * 5)
            m.write('wPartyMon1Status', 0x10)  # burn must not enter stored Attack
            award(0b111111)
            finish()
            for slot in range(6):
                check(stats(slot) == expected(slot), f'stat mode {mode}: unmodified party formula slot {slot}')
            check(m.read('wPartyMon1Status') == 0x10, 'stored status unchanged')
        cases.append('both-stat-modes-and-no-battle-modifier-leak')

        for excluded in ('wLinkMode', 'wInBattleTowerBattle'):
            configure()
            m.write(excluded, 1)
            before = m.read_bytes('wPartyMons', 6 * 50)
            award(0b111111)
            check(m.read_bytes('wPartyMons', 6 * 50) == before and m.read('wPendingStatExpRecalcs') == 0,
                  excluded + ': no award or pending refresh')
        cases.append('link-and-tower-exclusions')

        for current in ('full', 'one', 'fainted'):
            configure()
            m.write_bytes('wPartyMon1HP', words([stats(0)[0] if current == 'full' else 1]))
            deficit = stats(0)[0] - hp(0)
            award()
            if current == 'fainted':
                m.write_bytes('wPartyMon1HP', words([0]))
            finish()
            check(hp(0) == (0 if current == 'fainted' else stats(0)[0] - deficit), current + ': HP preserved')
        cases.append('full-and-one-hp-and-zero-hp')

        # Sweep the entire legal level range, with zero regular EXP to isolate
        # the no-level path even at level 1. Stat EXP is awarded normally.
        for level in range(1, 101):
            configure(level=level, count=1)
            m.write('wEnemyMonBaseExp', 0)
            award()
            check(not calculations, f'level sweep {level}: no mid-battle recalculation')
            finish()
            check(stats(0) == expected(0) and stats(0)[0] - hp(0) == 7,
                  f'level sweep {level}: formula and HP deficit')
            check(m.read('wPartyMon1Level') == level, f'level sweep {level}: level unchanged')
        cases.append('all-levels-1-through-100')

        # Full native wild battles: no award/exit routine is called by the test.
        # Use a threshold that crosses even on Magikarp's small natural yield.
        for level, hard in ((50, False), (10, True), (100, False)):
            configure(level, hard, values=[1521] * 5)
            m.write('wBattleMode', 0)
            m.write_bytes('wPartyMon1StatExp', words([1521] * 5))
            recalc(0)
            m.write_bytes('wPartyMon1HP', words([stats(0)[0] - 7]))
            calculations.clear()
            start_wild()
            before = stats(0)
            old_hp = hp(0)
            natural_reward = list(m.read_bytes('wEnemyMonBaseStats', 5))
            # At native FIGHT, mash selects Aerial Ace and completes the KO.
            for frame in range(12000):
                if completed():
                    break
                if frame % 12 == 0:
                    h.pb.button('a', 2)
                h.tick()
            else:
                raise AssertionError('native wild battle did not finish: ' + h.where())
            check(stat_exp(0) == [1521 + v for v in natural_reward],
                  f'native level {level}: exact natural award {stat_exp(0)}, reward {natural_reward}')
            check(stats(0) == expected(0) and stats(0) != before, f'native level {level}: automatic exit refresh')
            check(stats(0)[0] - hp(0) >= before[0] - old_hp, f'native level {level}: no damage healed')
            check(m.read('wPartyMon1Level') == level, f'native level {level}: no unintended level change')
            stored = m.read_bytes('wPartyMon1MaxHP', 12)
            # Open the personal summary and navigate to its stats page using
            # normal input. Party summaries copy stored stats without a recalc.
            m.write('wCurPartyMon', 0)
            m.write('wMonType', 0)
            begin_native_call(h, 'StatsScreenInit')
            h.pb.memory[0xC0F0] = 0xF3
            h.tick(240)
            h.press('right', hold=4, wait=120)
            check('Attack' in tile_text(h), f'native level {level}: personal stats page opened')
            check(m.read_bytes('wTempMonMaxHP', 12) == stored, f'native level {level}: summary uses refreshed stats')
            # Blue page rows are Attack, Defense, Sp. Atk, Sp. Def, Speed.
            for row, value in zip(range(4, 9), [stats(0)[i] for i in (1, 2, 4, 5, 3)]):
                digits = m.read_bytes('wTileMap', 3, row * 20 + 16)
                displayed = ''.join(str(v - 0xf6) if 0xf6 <= v <= 0xff else ' ' for v in digits).strip()
                check(displayed == str(value), f'native level {level}: summary row {row} displays {value}')
            h.pb.tick(1, True)
            h.pb.screen.image.save(out / f'personal-stats-level-{level}.png')
            h.press('b', hold=4, wait=120)
            check(completed(), f'native level {level}: summary closed normally')
            start_wild()
            check(m.read_bytes('wBattleMonMaxHP', 12) == stored, f'native level {level}: next battle loads refreshed stats')
            cases.append(f'native-wild-and-subsequent-entry-level-{level}')

        result = dict(rom=rom.name, checks=checks, cases=cases, failures=0)
        (out / 'results.json').write_text(json.dumps(result, indent=2) + '\n')
        print(json.dumps(result), flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    for rom in [Path(p) for p in sys.argv[1:]] or [ROOT / 'pokecrystal.gbc', ROOT / 'pokecrystal_debug.gbc']:
        run(rom)
