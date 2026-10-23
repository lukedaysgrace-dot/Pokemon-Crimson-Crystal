#!/usr/bin/env python3
"""Check the battle engine's weight for every species against official data.

Runs the compiled GetSpeciesWeightHG routine natively for every species slot
and compares its hectogram result with tools/testdata/species_weights.json
(official PokeAPI weights). It then evaluates the Low Kick / Grass Knot and
Heavy Slam / Heat Crash power formulas from those native weights and checks
them against an independent Python copy of Showdown's basePowerCallback
code. Uses a private emulator fixture; no save is read or modified.
"""
import argparse
import json
from pathlib import Path

from runner import Harness, ROOT
from symbols import STATE_WAIT

REFERENCE = ROOT / 'tools/testdata/species_weights.json'
STUB = 0xC0F6
RETURN = 0xC0F0


def showdown_low_kick(target_hg):
    # data/moves.ts lowkick / grassknot basePowerCallback
    for threshold, power in ((2000, 120), (1000, 100), (500, 80), (250, 60), (100, 40)):
        if target_hg >= threshold:
            return power
    return 20


def showdown_heavy_slam(user_hg, target_hg):
    # data/moves.ts heavyslam / heatcrash basePowerCallback
    for factor, power in ((5, 120), (4, 100), (3, 80), (2, 60)):
        if user_hg >= target_hg * factor:
            return power
    return 40


def call_native(h, code, bank):
    """Run a short RAM stub that ends in ret, with ROMX `bank` mapped."""
    pb, m = h.pb, h.battle.mem
    pb.memory[0x2000] = bank
    m.write('hROMBank', bank)
    pb.memory[0xFF70] = 1
    pb.memory[0xC0EC:0xC0EE] = [RETURN & 255, RETURN >> 8]
    pb.memory[RETURN:RETURN + 3] = [0xF3, 0x18, 0xFE]  # di; jr @ (keeps VBlank out of the sample)
    pb.memory[STUB:STUB + len(code)] = code
    pb.register_file.SP, pb.register_file.PC = 0xC0EC, STUB
    for _ in range(600):
        pb.tick(1, False)
        if pb.register_file.PC in (RETURN + 1, RETURN + 3):
            return pb.register_file
    raise AssertionError(f'native call timed out at {pb.register_file.PC:#06x}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal_debug.gbc')
    args = parser.parse_args()
    reference = json.loads(REFERENCE.read_text(encoding='utf-8'))['species']
    h = Harness(rom_path=args.rom, render=False)
    h.ensure_fixture()
    h.load_fixture()
    assert h.run_battle({
        'player': {'species': 'MEW', 'level': 50, 'moves': ['SPLASH']},
        'enemy': {'species': 'SNORLAX', 'level': 50, 'moves': ['SPLASH']},
        'rng': 'forced_high', 'turns': 0,
    }) == STATE_WAIT
    m = h.battle.mem
    # Reuse the two runtime species IDs already allocated for this battle and
    # point them at any species by editing their conversion-table entries
    # (page base + 2 * ID, little endian) in private emulator memory.
    player_id, enemy_id = m.read('wBattleMonSpecies'), m.read('wEnemyMonSpecies')
    assert player_id and enemy_id and player_id != enemy_id

    def assign(runtime_id, name):
        index = h.con.species_index(name)
        m.write_bytes('wPokemonIndexTable', [index & 255, index >> 8], offset=2 * runtime_id)
        assert m.species_index_of(runtime_id) == index

    bank, weight = h.sym['GetSpeciesWeightHG']
    turn = h.sym['hBattleTurn'][1]
    low_bank, low_kick = h.sym['BattleLowKickPower_Core']
    _, heavy_slam = h.sym['BattleHeavySlamPower_Core']
    assert low_bank == bank
    expected_hg, failures = {}, []
    for name, info in reference.items():
        expected = info['weight_hg']
        if expected is None:  # custom species: the dex's own weight, converted
            expected = max(1, (info['dex_lbs_x10'] * 29727 + 32768) >> 16)
        expected_hg[name] = expected
        assign(player_id, name)
        regs = call_native(h, [0xF3, 0x3E, player_id,               # di; ld a, id
                               0xCD, weight & 255, weight >> 8, 0xC9], bank)
        if regs.HL != expected:
            failures.append(f'{name}: engine {regs.HL} hg, expected {expected} hg')
    names = list(reference)

    def native_power(routine, user, target, side):
        # side 0: the player attacks; side 1: the enemy attacks.
        assign(player_id if side == 0 else enemy_id, user)
        assign(enemy_id if side == 0 else player_id, target)
        return call_native(h, [0xF3, 0x3E, side, 0xE0, turn & 255,  # ldh [hBattleTurn], side
                               0xCD, routine & 255, routine >> 8, 0xC9], bank).D

    # Low Kick / Grass Knot against every species; Heavy Slam / Heat Crash for
    # every pair on (or one hectogram either side of) a 2x/3x/4x/5x boundary,
    # plus a deterministic spread of other pairs. Both sides alternate.
    checked = 0
    for i, target in enumerate(names):
        side = i & 1
        got = native_power(low_kick, names[(i * 7) % len(names)], target, side)
        expected = showdown_low_kick(expected_hg[target])
        checked += 1
        if got != expected:
            failures.append(f'Low Kick vs {target} (side {side}): {got}, expected {expected}')
    selected = []
    for a, user in enumerate(names):
        for b, target in enumerate(names):
            u, t = expected_hg[user], expected_hg[target]
            ratio_edge = any(abs(u - t * k) <= 1 for k in (2, 3, 4, 5))
            if ratio_edge or (a * 31 + b * 17) % 97 == 0:
                selected.append((user, target))
    for n, (user, target) in enumerate(selected):
        side = n & 1
        got = native_power(heavy_slam, user, target, side)
        expected = showdown_heavy_slam(expected_hg[user], expected_hg[target])
        checked += 1
        if got != expected:
            failures.append(f'Heavy Slam {user} -> {target} (side {side}): {got}, expected {expected}')
    for line in failures:
        print('FAIL', line)
    print(f'{len(expected_hg)} species weights and {checked} native power results checked; '
          f'{len(failures)} mismatches')
    raise SystemExit(1 if failures else 0)


if __name__ == '__main__':
    main()
