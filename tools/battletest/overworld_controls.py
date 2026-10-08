"""Button-only navigation helpers; WRAM/ROM access is observation only."""

from collections import deque
import re

from ui_checks import tile_text
from symbols import ROOT, _parse_constants


class Controls:
    def __init__(self, harness):
        self.h = harness
        self.frames = 0
        self.types = _parse_constants(ROOT / 'constants/type_constants.asm')
        self.move_info = {}
        for line in (ROOT / 'data/moves/moves.asm').read_text().splitlines():
            match = re.match(r'\s*move\s+([^;]+);\s*(\w+)', line)
            if match:
                fields = [field.strip() for field in match[1].split(',')]
                self.move_info[match[2]] = (int(fields[1]), self.types[fields[2]], fields[3])
        self.matchups = {}
        species_text = (ROOT / 'constants/pokemon_constants.asm').read_text().split('const_def 1', 1)[1].split('NUM_POKEMON', 1)[0]
        species = [name for name in re.findall(r'^\s*const\s+(\w+)', species_text, re.MULTILINE) if name != 'EGG']
        includes = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', (ROOT / 'data/pokemon/base_stats.asm').read_text())
        self.species_types = {}
        for name, filename in zip(species, includes):
            for first, second in re.findall(r'^\s*db\s+(\w+),\s*(\w+)\s*;\s*type', (ROOT / filename).read_text(), re.MULTILINE):
                self.species_types[name] = {self.types[first], self.types[second]}
        multipliers = {'NO_EFFECT': 0, 'NOT_VERY_EFFECTIVE': .5, 'SUPER_EFFECTIVE': 2}
        for attack, defend, effect in re.findall(r'^\s*db\s+(\w+),\s*(\w+),\s*(\w+)',
                (ROOT / 'data/types/type_matchups.asm').read_text(), re.MULTILINE):
            if effect in multipliers:
                self.matchups[self.types[attack], self.types[defend]] = multipliers[effect]

    def move_score(self, name):
        power, kind, category = self.move_info.get(name, (0, 0, ''))
        if name == 'MAGNITUDE':
            power = 71  # Average of the native magnitude distribution.
        if not power:
            return 0
        if kind in self.enemy_immune_types():
            return 0
        player_types = set(self.m.read_bytes('wBattleMonType1', 2))
        enemy_types = set(self.m.read_bytes('wEnemyMonType1', 2))
        score = power * (1.5 if kind in player_types else 1)
        weather = self.m.read('wBattleWeather')
        if not weather & 0x80:
            if weather & 7 == 1:
                score *= .5 if kind == self.types['FIRE'] else 1.5 if kind == self.types['WATER'] else 1
            elif weather & 7 == 2:
                score *= 1.5 if kind == self.types['FIRE'] else .5 if kind == self.types['WATER'] else 1
        for target in enemy_types:
            score *= self.matchups.get((kind, target), 1)
        stat = 'SpclAtk' if category == 'CATEGORIZE_SPECIAL' else 'Attack'
        defense = 'SpclDef' if category == 'CATEGORIZE_SPECIAL' else 'Defense'
        score *= self.m.read_u16_be('wBattleMon' + stat) / max(1, self.m.read_u16_be('wEnemyMon' + defense))
        return score

    def enemy_immune_types(self):
        ability = self.h.con.abilities_by_id.get(self.m.read('wEnemyAbility'), '')
        immune = {'LEVITATE': 'GROUND', 'FLASH_FIRE': 'FIRE', 'VOLT_ABSORB': 'ELECTRIC',
                  'MOTOR_DRIVE': 'ELECTRIC', 'LIGHTNING_ROD': 'ELECTRIC', 'WATER_ABSORB': 'WATER',
                  'DRY_SKIN': 'WATER', 'STORM_DRAIN': 'WATER', 'SAP_SIPPER': 'GRASS'}
        return {self.types[immune[ability]]} if ability in immune else set()

    def party_score(self, slot):
        """Compare observed party members against the current opponent."""
        prefix = f'wPartyMon{slot + 1}'
        hp = self.m.read_u16_be(prefix + 'HP')
        if not hp or self.m.read('wPartySpecies', slot) == 253:
            return 0
        name = self.h.con.species_by_index.get(self.m.species_index_of(self.m.read(prefix + 'Species')), '')
        player_types = self.species_types.get(name, set())
        enemy_types = set(self.m.read_bytes('wEnemyMonType1', 2))
        weather = self.m.read('wBattleWeather')

        def strength(move, source_types, target_types, attacker, defender):
            power, kind, category = self.move_info.get(move, (0, 0, ''))
            if move == 'MAGNITUDE':
                power = 71
            if not power:
                return 0
            if attacker != 'wEnemyMon' and kind in self.enemy_immune_types():
                return 0
            score = power * (1.5 if kind in source_types else 1)
            for target in target_types:
                score *= self.matchups.get((kind, target), 1)
            if not weather & 0x80:
                if weather & 7 == 1:
                    score *= .5 if kind == self.types['FIRE'] else 1.5 if kind == self.types['WATER'] else 1
                elif weather & 7 == 2:
                    score *= 1.5 if kind == self.types['FIRE'] else .5 if kind == self.types['WATER'] else 1
            stat = 'SpclAtk' if category == 'CATEGORIZE_SPECIAL' else 'Attack'
            defense = 'SpclDef' if category == 'CATEGORIZE_SPECIAL' else 'Defense'
            return score * self.m.read_u16_be(attacker + stat) / max(1, self.m.read_u16_be(defender + defense))

        active = slot == self.m.read('wCurBattleMon')
        attacker = 'wBattleMon' if active else prefix
        own_names = [self.h.con.moves_by_index.get(self.m.move_index_of(value), '') for value in self.m.read_bytes(prefix + 'Moves', 4)]
        own_pp = self.m.read_bytes(prefix + 'PP', 4)
        offense = max((strength(move, player_types, enemy_types, attacker, 'wEnemyMon')
                       for move, pp in zip(own_names, own_pp) if pp & 63), default=0)
        enemy_names = [self.h.con.moves_by_index.get(self.m.move_index_of(value), '') for value in self.m.read_bytes('wEnemyMonMoves', 4)]
        danger = max((strength(move, enemy_types, player_types, 'wEnemyMon', attacker) for move in enemy_names), default=0)
        incoming = (self.m.read('wEnemyMonLevel') * 2 / 5 + 2) * danger / 50 + 2
        if not active:
            hp -= incoming  # Switching spends a turn; prefer members that survive it.
        if active:
            offense *= min(1, self.m.read('wPlayerAccLevel') / 7)
        status = self.m.read(prefix + 'Status')
        if status & 7:
            offense *= .35
        return offense * max(0, hp) / max(1, incoming)

    def switch_party(self, slot):
        self.press('up', hold=4, wait=24)
        self.press('right', hold=4, wait=24)
        self.press('a', hold=4, wait=100)
        for _ in range(8):
            if self.m.read('wMenuCursorY') == slot + 1:
                break
            self.press('down', hold=4, wait=24)
        self.press('a', hold=4, wait=80)
        self.press('a', hold=4, wait=120)

    def learn_move_input(self, text):
        """Keep attacks and HM travel moves when the normal forget menu opens."""
        if 'forgotten' not in text or 'Which move should' not in text:
            return False
        prefix = f'wPartyMon{self.m.read("wCurPartyMon") + 1}'
        names = [self.h.con.moves_by_index.get(self.m.move_index_of(value), '')
                 for value in self.m.read_bytes(prefix + 'Moves', 4)]
        if sum(name.replace('_', ' ') in text for name in names if name and name != 'NO_MOVE') < 2:
            return False
        hms = {'CUT', 'FLY', 'SURF', 'STRENGTH', 'FLASH', 'WHIRLPOOL', 'WATERFALL'}
        utility = {'THUNDER_WAVE': 35, 'NUZZLE': 35, 'SLEEP_POWDER': 35, 'SPORE': 35, 'ROOST': 35, 'RECOVER': 35}
        def value(name):
            if name in hms:
                return 10000
            return utility.get(name, self.move_info.get(name, (0, 0, ''))[0])
        candidate = min(range(4), key=lambda i: value(names[i]))
        new = self.h.con.moves_by_index.get(self.m.move_index_of(self.m.read('wPutativeTMHMMove')), '')
        if value(new) < value(names[candidate]):
            self.press('b', hold=4, wait=80)
        elif self.m.read('wMenuCursorY') != candidate + 1:
            self.press('down', hold=4, wait=24)
        else:
            self.press('a', hold=4, wait=40)
        return True

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

    def permits_step(self, current, nxt, button):
        """Observe the same directional wall edges as GetMovementPermissions."""
        edges = ({'down'}, {'up'}, {'left'}, {'right'},
                 {'down', 'right'}, {'up', 'right'},
                 {'down', 'left'}, {'up', 'left'})
        target_edges = ({'right'}, {'left'}, {'up'}, {'down'},
                        {'down', 'right'}, {'down', 'left'},
                        {'up', 'right'}, {'up', 'left'})
        source, target = self.collision(*current), self.collision(*nxt)
        opposite = {'up': 'down', 'down': 'up', 'left': 'right', 'right': 'left'}
        if source >> 4 in (0xB, 0xC) and button in edges[source & 7]:
            return False
        if target >> 4 in (0xB, 0xC) and opposite[button] in target_edges[target & 7]:
            return False
        return self.passable(target)

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
                if not self.permits_step(current, nxt, button):
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
            if (self.position() == goal or self.map_id() != origin
                    or self.m.read('wBattleMode') or self.m.read('wScriptMode')):
                return
            previous = self.position()
            steps = self.path(goal, avoid)
            # A short tap prevents two-tile overshoots through fast movement.
            # A turn-only tap is retried using the same observed path.
            self.press(steps[0], hold=4, wait=36)
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

    def heal_in_battle(self):
        """Use a naturally held bag potion through PACK and the party menu."""
        if self.m.read('wStatusFlags2') & 8:
            # Hard mode permits only Ball-pocket items in the battle pack.
            return False
        healing = {'POTION', 'SUPER_POTION', 'HYPER_POTION', 'MAX_POTION', 'FULL_RESTORE'}
        inventory = [self.h.con.items_by_id.get(self.m.read('wItems', i * 2), '')
                     for i in range(self.m.read('wNumItems'))]
        available = [i for i, name in enumerate(inventory) if name in healing]
        if not available:
            return False
        target = available[0]
        self.press('up', hold=4, wait=24)
        self.press('left', hold=4, wait=24)
        self.press('down', hold=4, wait=24)
        self.press('a', hold=4, wait=100)
        for _ in range(8):
            if self.m.read('wCurPocket') == 0:
                break
            self.press('left', hold=4, wait=60)
        for _ in range(80):
            cursor = self.m.read('wMenuScrollPosition') + self.m.read('wMenuCursorY') - 1
            if cursor == target:
                break
            self.press('up' if cursor > target else 'down', hold=4, wait=24)
        self.press('a', hold=4, wait=80)
        self.press('a', hold=4, wait=100)
        slot = self.m.read('wCurBattleMon') + 1
        for _ in range(8):
            if self.m.read('wMenuCursorY') == slot:
                break
            self.press('down', hold=4, wait=24)
        self.press('a', hold=4, wait=120)
        return True

    def battle(self, limit=36000, partial=False):
        """Select usable damaging moves and surviving replacements through menus."""
        initial = self.frames
        started = bool(self.m.read('wBattleMode'))
        switched_for = set()
        paralysis_attempts = {}
        while self.frames - initial < limit:
            text = tile_text(self.h)
            names = [self.h.con.moves_by_index.get(self.m.move_index_of(v), '')
                     for v in self.m.read_bytes('wBattleMonMoves', 4)]
            move_menu = 'TYPE' in text or sum(name.replace('_', ' ') in text
                for name in names if name and name != 'NO_MOVE') >= 2
            if started and not self.m.read('wBattleMode'):
                self.wait(120)
                return
            if self.m.read('wBattleMode'):
                started = True
            if self.learn_move_input(text):
                continue
            if 'FIGHT' in text and 'PACK' in text:
                if self.m.read_u16_be('wBattleMonHP') * 2 <= self.m.read_u16_be('wBattleMonMaxHP') and self.heal_in_battle():
                    continue
                current = self.m.read('wCurBattleMon')
                enemy = self.m.read('wEnemyMonSpecies')
                best = max(range(self.m.read('wPartyCount')), key=self.party_score)
                pp = self.m.read_bytes('wBattleMonPP', 4)
                damage = max((self.move_score(name) for name, remaining in zip(names, pp) if remaining & 63), default=0)
                lethal = (self.m.read('wBattleMonLevel') * 2 / 5 + 2) * damage / 50 + 2 >= self.m.read_u16_be('wEnemyMonHP')
                if (not lethal and best != current and enemy not in switched_for
                        and self.party_score(best) > self.party_score(current) * 1.75):
                    switched_for.add(enemy)
                    self.switch_party(best)
                    continue
                self.press('up', hold=4, wait=8)
                self.press('left', hold=4, wait=8)
                self.press('a', hold=4, wait=20)
            elif 'CANCEL' in text and 'FNT' in text:
                alive = [slot for slot in range(self.m.read('wPartyCount'))
                         if self.m.read_u16_be(f'wPartyMon{slot + 1}HP') and self.m.read('wPartySpecies', slot) != 253]
                if not alive:
                    self.press('b', hold=4, wait=20)
                    continue
                slot = max(alive, key=self.party_score)
                if self.m.read('wMenuCursorY') != slot + 1:
                    self.press('down', hold=4, wait=20)
                else:
                    self.press('a', hold=4, wait=20)
            elif move_menu:
                pp = list(self.m.read_bytes('wBattleMonPP', 4))
                ids = list(self.m.read_bytes('wBattleMonMoves', 4))
                disabled = self.m.read('wDisabledMove') if self.m.read('wPlayerDisableCount') else 0
                locked = self.m.read('wPlayerChoiceLockedMove')
                usable = [i for i, value in enumerate(names)
                          if value and value != 'NO_MOVE' and pp[i] & 63
                          and ids[i] != disabled and (not locked or ids[i] == locked)]
                move = max(usable, key=lambda i: self.move_score(names[i])) if usable else 0
                priority = {'QUICK_ATTACK', 'MACH_PUNCH', 'AQUA_JET', 'BULLET_PUNCH', 'ICE_SHARD', 'SHADOW_SNEAK', 'EXTREMESPEED'}
                finishers = [i for i in usable if names[i] in priority and self.move_score(names[i]) > 0
                            and (self.m.read('wBattleMonLevel') * 2 / 5 + 2) * self.move_score(names[i]) / 50 + 2 >= self.m.read_u16_be('wEnemyMonHP')]
                if finishers:
                    move = max(finishers, key=lambda i: self.move_score(names[i]))
                electric_targets = set(self.m.read_bytes('wEnemyMonType1', 2))
                ability = self.h.con.abilities_by_id.get(self.m.read('wEnemyAbility'), '')
                target = (self.m.read('wEnemyMonSpecies'), self.m.read('wEnemyMonLevel'))
                expected = (self.m.read('wBattleMonLevel') * 2 / 5 + 2) * self.move_score(names[move]) / 50 + 2
                if (not self.m.read('wEnemyMonStatus') and expected < self.m.read_u16_be('wEnemyMonHP')
                        and self.types['ELECTRIC'] not in electric_targets
                        and self.types['GROUND'] not in electric_targets
                        and ability != 'LIMBER'
                        and self.types['ELECTRIC'] not in self.enemy_immune_types()
                        and paralysis_attempts.get(target, 0) < 2):
                    paralysis = [i for i in usable if names[i] in ('THUNDER_WAVE', 'NUZZLE')]
                    if paralysis:
                        move = paralysis[0]
                cursor = self.m.read('wMenuCursorY') - 1
                if cursor != move:
                    self.press('down', hold=4, wait=12)
                else:
                    if names[move] in ('THUNDER_WAVE', 'NUZZLE'):
                        paralysis_attempts[target] = paralysis_attempts.get(target, 0) + 1
                    self.press('a', hold=4, wait=20)
            else:
                self.press('a', hold=4, wait=20)
        if not partial:
            raise RuntimeError('Battle frame ceiling reached: ' + tile_text(self.h))
