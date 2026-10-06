#!/usr/bin/env python3
"""Load the real fishing cove and inspect visitor/contest sprite allocation."""

import re
import sys
from pathlib import Path

from runner import Harness
from symbols import ROOT
sys.path.insert(0, str(ROOT))
from tools.audit_trainer_sprites import sprite_metadata


def native_call(h, symbol):
    pb, m = h.pb, h.battle.mem
    bank, address = h.sym[symbol]
    if bank:
        pb.memory[0x2000] = bank
        m.write('hROMBank', bank)
    pb.memory[0xFF70] = 1
    pb.memory[0xC0EC:0xC0EE] = [0xF0, 0xC0]
    pb.memory[0xC0F0:0xC0F3] = [0xFB, 0x18, 0xFE]
    pb.memory[0xC0F6:0xC0FA] = [0xFB, 0xC3, address & 255, address >> 8]
    pb.register_file.SP, pb.register_file.PC = 0xC0EC, 0xC0F6
    for _ in range(1800):
        h.tick(4)
        if pb.register_file.PC in (0xC0F1, 0xC0F3):
            return
    raise RuntimeError(f'{symbol} did not return: {h.where()}')


def main():
    h = Harness()
    h.ensure_fixture()
    ids, _ = sprite_metadata()
    contest = (ROOT / 'engine/events/fishing_contest.asm').read_text()
    table = contest.split('FishingContestantSprites:\n', 1)[1].split('FishingCoveVisitorRoster:', 1)[0]
    candidate_sprites = [ids[name] for name in re.findall(r'\bdb\s+(SPRITE_\w+),', table)]
    regular_roster = [11, 12, 13, 14, 11]
    output = Path('.venv/cove-ui')
    output.mkdir(parents=True, exist_ok=True)
    checks = failed = views = 0
    # Derive map IDs from the same declarations used to build the ROM.
    group = number = 0
    for line in (ROOT / 'constants/map_constants.asm').read_text().splitlines():
        if re.match(r'\s+newgroup\b', line):
            group += 1
            number = 0
        match = re.match(r'\s+map_const\s+(\w+),', line)
        if match:
            number += 1
            if match[1] == 'OLIVINE_FISHING_COVE':
                break
    rosters = [('visitors', None), ('contest-mixed', [0, 6, 7, 8, 9]),
               ('contest-fishers', [0, 1, 2, 3, 4])]
    for label, roster in rosters:
        for x, y in ((32, 4), (5, 28), (35, 17), (12, 7)):
            h.load_fixture()
            m = h.battle.mem
            m.write('hDebugActive', 0)
            m.write('wDebugState', 0)
            m.write('wDefaultSpawnpoint', 255)  # SPAWN_N_A (-1)
            m.write('wMapGroup', group)
            m.write('wMapNumber', number)
            m.write('wXCoord', x)
            m.write('wYCoord', y)
            m.write('wStatusFlags2', (1 << 2) | (1 << 5) if roster else 0)
            if roster:
                m.write_bytes('wFishingContestRoster', roster)
            m.write('hMapEntryMethod', 0xF1)
            native_call(h, 'EnterMap')
            h.tick(60)
            raw = m.read_bytes('wUsedSprites', 64)
            used = {raw[i]: raw[i + 1] for i in range(0, 64, 2) if raw[i]}
            errors = []
            checks += 1
            if m.read('wMapGroup') != group or m.read('wMapNumber') != number:
                errors.append('map entry did not reach the fishing cove')
            for slot, candidate in enumerate(roster if roster is not None else regular_roster, 4):
                checks += 1
                if m.read(f'wMap{slot}ObjectSprite') != candidate_sprites[candidate]:
                    errors.append(f'object {slot} does not match the selected visitor/contest roster')
            for slot in range(1, 12):
                sprite = m.read(f'wMap{slot}ObjectSprite')
                checks += 1
                if sprite not in used:
                    errors.append(f'object {slot} sprite {sprite} missing from actual VRAM allocation')
            checks += 1
            if not roster and not {ids['SPRITE_COOLTRAINER_F'], ids['SPRITE_COOLTRAINER_M'], ids['SPRITE_TEACHER']} <= set(used):
                errors.append('regular visitor sprites missing')
            views += 1
            name = f'{label}-{x}-{y}'
            h.pb.screen.image.save(str(output / f'{name}.png'))
            if errors:
                failed += 1
                print(f'FAIL COVE {name}: {errors}', flush=True)
            else:
                print(f'PASS COVE {name}: {len(used)} allocated sprites', flush=True)
    h.pb.stop(save=False)
    print(f'{views} cove views, {checks} allocation checks, {failed} failures')
    return int(bool(failed))


if __name__ == '__main__':
    raise SystemExit(main())
