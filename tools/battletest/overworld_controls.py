"""Button-only navigation helpers; WRAM/ROM access is observation only."""

from collections import deque

from ui_checks import tile_text


class Controls:
    def __init__(self, harness):
        self.h = harness
        self.frames = 0

    @property
    def m(self):
        return self.h.battle.mem

    def press(self, button, hold=12, wait=36):
        self.h.press(button, hold=hold, wait=wait)
        self.frames += hold + wait

    def wait(self, frames):
        self.h.tick(frames)
        self.frames += frames

    def position(self):
        return self.m.read('wXCoord'), self.m.read('wYCoord')

    def map_id(self):
        return self.m.read('wMapGroup'), self.m.read('wMapNumber')

    def collision(self, x, y):
        stride = self.m.read('wMapWidth') + 6
        block = self.m.read('wOverworldMapBlocks', (y // 2 + 3) * stride + x // 2 + 3)
        if not block:
            block = self.m.read('wMapBorderBlock')
        bank = self.m.read('wTilesetCollisionBank')
        ptr = int.from_bytes(self.m.read_bytes('wTilesetCollisionAddress', 2), 'little')
        return self.h.pb.memory[bank, ptr + block * 4 + (y & 1) * 2 + (x & 1)]

    def objects(self):
        result = []
        for slot in range(1, 13):
            data = self.m.read_bytes('wObjectStructs', 40, slot * 40)
            if data[0]:
                result.append(dict(slot=slot, map_object=data[1], sprite=data[0],
                                   position=[data[0x12] - 4, data[0x13] - 4],
                                   next=[data[0x10] - 4, data[0x11] - 4]))
        return result

    def grid(self):
        width, height = self.m.read('wMapWidth') * 2, self.m.read('wMapHeight') * 2
        occupied = {tuple(o['position']) for o in self.objects()}
        rows = []
        for y in range(height):
            row = ''
            for x in range(width):
                c = self.collision(x, y)
                row += ('@' if (x, y) == self.position() else 'N' if (x, y) in occupied else
                        '#' if not self.passable(c) else 'W' if c >> 4 == 7 else
                        'g' if c in (0x14, 0x18) else '.')
            rows.append(row)
        return rows

    def passable(self, collision):
        bank, addr = self.h.sym['TileCollisionTable']
        return (self.h.pb.memory[bank, addr + collision] & 15) == 0

    def path(self, goal, avoid=()):
        start = self.position()
        blocked = set(map(tuple, avoid))
        for obj in self.objects():
            blocked.add(tuple(obj['position']))
            blocked.add(tuple(obj['next']))
        width, height = self.m.read('wMapWidth') * 2, self.m.read('wMapHeight') * 2
        todo, parents = deque([start]), {start: None}
        directions = ((0, -1, 'up'), (-1, 0, 'left'), (1, 0, 'right'), (0, 1, 'down'))
        while todo:
            current = todo.popleft()
            if current == goal:
                steps = []
                while parents[current] is not None:
                    previous, button = parents[current]
                    steps.append(button)
                    current = previous
                return steps[::-1]
            for dx, dy, button in directions:
                nxt = (current[0] + dx, current[1] + dy)
                x, y = nxt
                if not (0 <= x < width and 0 <= y < height) or nxt in parents or nxt in blocked:
                    continue
                c = self.collision(x, y)
                if not self.passable(c) or c >> 4 in (0xA, 0xB, 0xC):
                    continue
                if c >> 4 == 7 and nxt != goal:
                    continue
                parents[nxt] = current, button
                todo.append(nxt)
        raise RuntimeError(f'No walkable path from {start} to {goal}')

    def go(self, goal, limit=400, avoid=()):
        goal = tuple(goal)
        origin = self.map_id()
        stalled = 0
        for _ in range(limit):
            if self.position() == goal or self.map_id() != origin or self.m.read('wBattleMode'):
                return
            previous = self.position()
            steps = self.path(goal, avoid)
            self.press(steps[0])
            if previous == self.position():
                stalled += 1
                if stalled >= 4:
                    return
            else:
                stalled = 0
        raise RuntimeError('Walking frame ceiling reached')

    def mash(self, count=100):
        for _ in range(count):
            self.press('a', hold=4, wait=20)

    def battle(self, limit=36000):
        """Prefer the starter's damaging moves through the normal battle menu."""
        initial = self.frames
        started = bool(self.m.read('wBattleMode'))
        while self.frames - initial < limit:
            text = tile_text(self.h)
            if started and not self.m.read('wBattleMode'):
                self.wait(120)
                return
            if self.m.read('wBattleMode'):
                started = True
            if 'FIGHT' in text and 'PACK' in text:
                self.press('up', hold=4, wait=8)
                self.press('left', hold=4, wait=8)
                self.press('a', hold=4, wait=20)
            elif 'TYPE' in text:
                pp = list(self.m.read_bytes('wBattleMonPP', 4))
                names = [self.h.con.moves_by_index.get(self.m.move_index_of(v), '')
                         for v in self.m.read_bytes('wBattleMonMoves', 4)]
                priority = ('FLAMETHROWER', 'FLAME_WHEEL', 'EMBER', 'QUICK_ATTACK', 'TACKLE')
                move = next((i for name in priority for i, value in enumerate(names)
                             if value == name and pp[i] & 63),
                            next((i for i, p in enumerate(pp) if p & 63), 0))
                cursor = self.m.read('wMenuCursorY') - 1
                if cursor != move:
                    self.press('down', hold=4, wait=12)
                else:
                    self.press('a', hold=4, wait=20)
            else:
                self.press('a', hold=4, wait=20)
        raise RuntimeError('Battle frame ceiling reached: ' + tile_text(self.h))
