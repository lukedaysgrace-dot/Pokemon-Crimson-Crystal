#!/usr/bin/env python3
"""Compiled Route 9 NPC visibility, graphics allocation and facing sequence.

Uses private emulator state and skips text presentation, retaining native
map loading, object allocation, badge event checks and facing commands.
"""
from pathlib import Path

from audit_trainer_sprites import sprite_metadata
from battletest.symbols import _parse_constants
from pc_harness import Harness, ROOT
from test_overworld_state import patches


def main():
    root = Path(ROOT)
    h = Harness(rom=str(root / 'pokecrystal.gbc'), sym=str(root / 'pokecrystal.sym'))
    h.boot()
    events = _parse_constants(root / 'constants/event_flags.asm')
    fields = _parse_constants(root / 'constants/map_object_constants.asm')
    sprites, _ = sprite_metadata()
    checks, failures = 0, []

    def check(ok, message):
        nonlocal checks
        checks += 1
        if not ok:
            failures.append(message)
            print('FAIL:', message, flush=True)

    def write(name, value):
        h.wr(h.s(name), value)

    def event(complete):
        h.call('EventFlagAction', bc=int(complete) << 8, de=events['EVENT_BEAT_MISTY'])

    def load(x=49, y=17):
        write('wMapGroup', 7)  # Cerulean group
        write('wMapNumber', 13)  # Route 9
        write('wXCoord', x)
        write('wYCoord', y)
        h.call('LoadMapAttributes')
        h.call('LoadObjectMasks')
        write('wObjectStructs', bytes(13 * 40))
        player = h.s('wPlayerObject')
        h.wr(player + fields['MAPOBJECT_OBJECT_STRUCT_ID'], 0)
        h.wr(player + fields['MAPOBJECT_X_COORD'], x + 4)
        h.wr(player + fields['MAPOBJECT_Y_COORD'], y + 4)
        obj = h.s('wObjectStructs')
        h.wr(obj + fields['OBJECT_SPRITE'], sprites['SPRITE_GOLD'])
        h.wr(obj + fields['OBJECT_MAP_OBJECT_INDEX'], 0)
        for name in ('OBJECT_MAP_X', 'OBJECT_NEXT_MAP_X'):
            h.wr(obj + fields[name], x + 4)
        for name in ('OBJECT_MAP_Y', 'OBJECT_NEXT_MAP_Y'):
            h.wr(obj + fields[name], y + 4)
        write('wUsedSprites', bytes(64))
        h.call('GetPlayerSprite')
        h.call('AddMapSprites')
        h.call('LoadAndSortSprites')
        h.call('InitializeVisibleSprites')

    def live(index):
        slot = h.rd(h.s(f'wMap{index}Object') + fields['MAPOBJECT_OBJECT_STRUCT_ID'])
        if slot >= 13:
            raise RuntimeError(f'NPC {index} was not allocated (slot {slot})')
        return h.s('wObjectStructs') + slot * 40

    texts = []

    def record(_):
        obj = live(10)
        texts.append(((h.reg.B, h.reg.HL), h.rd(obj + fields['OBJECT_FACING']) & 12))

    def script(name, talked):
        texts.clear()
        bank, addr = h.sym[name]
        write('hLastTalked', talked)
        write('wScriptBank', bank)
        h.wr16(h.s('wScriptPos'), addr)
        write('wScriptStackSize', 0)
        write('wScriptMode', 1)
        for _ in range(100):
            h.call('RunScriptCommand')
            if h.rd(h.s('wScriptMode')) == 0:
                return list(texts)
        raise RuntimeError(f'{name}: script did not finish')

    presentation = {name: b'\xc9' for name in (
        'Script_opentext', 'Script_closetext', 'Script_waitbutton',
        'Script_buttonsound', 'MapTextbox', '_UpdateSprites')}
    try:
        with patches(h, presentation):
            for complete in (False, True, False):
                event(complete)
                load()
                for index, x, sprite in ((9, 48, 'SPRITE_GAMBLER_ASLEEP'), (10, 49, 'SPRITE_COOLTRAINER_M')):
                    check(bool(h.rd(h.s('wObjectMasks') + index)) == complete,
                          f'NPC {index} visibility with Misty beaten={complete}')
                    base = h.s(f'wMap{index}Object')
                    check(h.rd(base + fields['MAPOBJECT_X_COORD']) == x + 4
                          and h.rd(base + fields['MAPOBJECT_Y_COORD']) == 20,
                          f'NPC {index} placed at wrong tile')
                    check(h.rd(base + fields['MAPOBJECT_SPRITE']) == sprites[sprite],
                          f'NPC {index} uses wrong sprite')
                used = h.rd(h.s('wUsedSprites'), 64)
                assigned = {used[i]: used[i + 1] for i in range(0, 64, 2) if used[i]}
                for sprite in ('SPRITE_GAMBLER_ASLEEP', 'SPRITE_COOLTRAINER_M'):
                    check(sprites[sprite] in assigned, f'{sprite} missing from native VRAM allocation')

            bank, addr = h.sym['MapTextbox']
            h.pyboy.hook_register(bank, addr, record, None)
            try:
                for x, y, facing in ((49, 17, 0), (49, 15, 4), (50, 16, 12)):
                    load(x, y)
                    said = script('Route9ImpatientCooltrainerScript', 10)
                    check(said == [(h.sym['Route9CooltrainerMoveItText'], 8),
                                   (h.sym['Route9CooltrainerOldCootText'], facing)],
                          f'Cooltrainer dialogue/facing at player {(x, y)}: {said}')
                said = script('Route9SleepingGamblerScript', 9)
                check([text for text, _ in said] == [h.sym['Route9SleepingGamblerText']],
                      'sleeping gambler has wrong dialogue')
            finally:
                h.pyboy.hook_deregister(bank, addr)
        print(f'ROUTE 9 BLOCKERS: {checks} checks; {len(failures)} failures', flush=True)
        return bool(failures)
    finally:
        h.pyboy.stop(save=False)


if __name__ == '__main__':
    raise SystemExit(main())
