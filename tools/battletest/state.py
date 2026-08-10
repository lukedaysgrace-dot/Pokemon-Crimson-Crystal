"""WRAM access for the battle test harness.

Everything goes through the debug-build .sym file. Species and moves live
in memory as 8-bit runtime IDs; the 16-bit truth is in the WRAMX bank-2
conversion tables (engine/16/), which this module reads to translate.
"""

from symbols import Symbols, Constants, STATE_MENU, parse_substatus_bits

DEBUG_BANK = 2  # WRAMX bank of wDebug* and the 16-bit conversion tables
DEBUG_TEXT_RAM_LOG_ENTRIES = 16
DEBUG_TEXT_RAM_ENTRY_SIZE = 20

# request block field offsets (dbg_* in engine/debug/battle_tester.asm)
DBG_SPECIES = 0
DBG_LEVEL = 2
DBG_ABILSLOT = 3
DBG_ABILOVERRIDE = 4
DBG_ITEM = 5
DBG_MOVES = 6
DBG_DVS = 14
DBG_HPPCT = 16
DBG_STATUS = 17
DBG_STATLEVELS = 18
DBG_SUBSTATUS = 25  # 5 bytes, ORed into SubStatus1-5 post-entry
DBG_SIZE = 30

SUBSTATUS_BITS = parse_substatus_bits()


class Memory:
    def __init__(self, pyboy, symbols: Symbols):
        self.pb = pyboy
        self.sym = symbols

    def _resolve(self, name):
        bank, addr = self.sym[name]
        return bank, addr

    def read(self, name, offset=0):
        bank, addr = self._resolve(name)
        return self._read_addr(bank, addr + offset)

    def _read_addr(self, bank, addr):
        if 0xD000 <= addr < 0xE000 and bank:
            return self.pb.memory[bank, addr]
        return self.pb.memory[addr]

    def _write_addr(self, bank, addr, value):
        if 0xD000 <= addr < 0xE000 and bank:
            self.pb.memory[bank, addr] = value
        else:
            self.pb.memory[addr] = value

    def write(self, name, value, offset=0):
        bank, addr = self._resolve(name)
        self._write_addr(bank, addr + offset, value)

    def read_bytes(self, name, length, offset=0):
        bank, addr = self._resolve(name)
        return bytes(self._read_addr(bank, addr + offset + i) for i in range(length))

    def write_bytes(self, name, data, offset=0):
        bank, addr = self._resolve(name)
        for i, b in enumerate(data):
            self._write_addr(bank, addr + offset + i, b)

    def read_u16_be(self, name, offset=0):
        hi, lo = self.read_bytes(name, 2, offset)
        return (hi << 8) | lo

    # --- 16-bit conversion tables ---

    def _table_entry(self, table_sym, runtime_id):
        """Mirror ___conversion_table_load: page-aligned table, entry at
        page_base + id*2, little endian."""
        if runtime_id == 0:
            return 0
        if runtime_id >= 0xFD:  # reserved (egg etc.)
            return 0xFF00 | runtime_id
        bank, addr = self.sym[table_sym]
        base = addr & 0xFF00
        lo = self._read_addr(DEBUG_BANK, base + runtime_id * 2)
        hi = self._read_addr(DEBUG_BANK, base + runtime_id * 2 + 1)
        return (hi << 8) | lo

    def species_index_of(self, runtime_id):
        return self._table_entry("wPokemonIndexTable", runtime_id)

    def move_index_of(self, runtime_id):
        return self._table_entry("wMoveIndexTable", runtime_id)


class Side:
    """Accessors for one battler (player / enemy)."""

    def __init__(self, mem: Memory, con: Constants, prefix, ability_sym,
                 statlv_sym, screens_sym, substatus_syms):
        self.mem = mem
        self.con = con
        self.p = prefix  # "wBattleMon" or "wEnemyMon"
        self.ability_sym = ability_sym
        self.statlv_sym = statlv_sym
        self.screens_sym = screens_sym
        self.substatus_syms = substatus_syms

    @property
    def species(self):
        rid = self.mem.read(self.p + "Species")
        idx = self.mem.species_index_of(rid)
        return self.con.species_by_index.get(idx, f"IDX_{idx}")

    @property
    def level(self):
        return self.mem.read(self.p + "Level")

    @property
    def hp(self):
        return self.mem.read_u16_be(self.p + "HP")

    @property
    def maxhp(self):
        return self.mem.read_u16_be(self.p + "MaxHP")

    @property
    def status(self):
        return self.mem.read(self.p + "Status")

    @property
    def item(self):
        iid = self.mem.read(self.p + "Item")
        return self.con.items_by_id.get(iid, f"ITEM_{iid}")

    @property
    def ability(self):
        aid = self.mem.read(self.ability_sym)
        return self.con.abilities_by_id.get(aid, f"ABILITY_{aid}")

    @property
    def moves(self):
        out = []
        for i in range(4):
            rid = self.mem.read(self.p + "Moves", i)
            if rid == 0:
                out.append(None)
                continue
            idx = self.mem.move_index_of(rid)
            out.append(self.con.moves_by_index.get(idx, f"MOVE_{idx}"))
        return out

    @property
    def pp(self):
        return [self.mem.read(self.p + "PP", i) & 0x3F for i in range(4)]

    @property
    def stats(self):
        # attack, defense, speed, spcatk, spcdef (big endian words)
        base = self.p + "Attack"
        names = ["Attack", "Defense", "Speed", "SpclAtk", "SpclDef"]
        return {n.lower(): self.mem.read_u16_be(self.p + n) for n in names}

    @property
    def stat_levels(self):
        # atk, def, spd, satk, sdef, acc, eva (7 = neutral)
        return list(self.mem.read_bytes(self.statlv_sym, 7))

    @property
    def screens(self):
        return self.mem.read(self.screens_sym)

    @property
    def substatus(self):
        return [self.mem.read(s) for s in self.substatus_syms]


class Battle:
    """The object test assertions evaluate against."""

    def __init__(self, pyboy, symbols=None, constants=None):
        self.sym = symbols or Symbols()
        self.con = constants or Constants()
        self.mem = Memory(pyboy, self.sym)
        self.player = Side(
            self.mem, self.con, "wBattleMon", "wPlayerAbility",
            "wPlayerStatLevels", "wPlayerScreens",
            [f"wPlayerSubStatus{i}" for i in range(1, 6)])
        self.enemy = Side(
            self.mem, self.con, "wEnemyMon", "wEnemyAbility",
            "wEnemyStatLevels", "wEnemyScreens",
            [f"wEnemySubStatus{i}" for i in range(1, 6)])

    @property
    def weather(self):
        return self.mem.read("wBattleWeather") & 0x07

    @property
    def state(self):
        return self.mem.read("wDebugState")

    @property
    def turns_done(self):
        return self.mem.read("wDebugTurnsDone")

    @staticmethod
    def _encode_text(value):
        """Encode the English battle-name subset of the Gen 2 charmap."""
        punctuation = {
            " ": 0x7F, "(": 0x9A, ")": 0x9B, ":": 0x9C,
            ";": 0x9D, "[": 0x9E, "]": 0x9F, "+": 0xC0,
            "'": 0xE0, "-": 0xE3, "?": 0xE6, "!": 0xE7,
            ".": 0xE8, "&": 0xE9, "/": 0xF3, ",": 0xF4,
        }
        out = bytearray()
        for char in value:
            if "A" <= char <= "Z":
                out.append(0x80 + ord(char) - ord("A"))
            elif "a" <= char <= "z":
                out.append(0xA0 + ord(char) - ord("a"))
            elif "0" <= char <= "9":
                out.append(0xF6 + ord(char) - ord("0"))
            elif char in punctuation:
                out.append(punctuation[char])
            else:
                raise ValueError(f"unsupported game-text character {char!r}")
        out.append(0x50)  # "@" terminator
        return bytes(out)

    @property
    def rendered_ram_texts(self):
        """Raw text_ram strings captured at the instant they were rendered."""
        count = min(self.mem.read("wDebugTextRamCount"),
                    DEBUG_TEXT_RAM_LOG_ENTRIES)
        strings = []
        for entry in range(count):
            raw = self.mem.read_bytes(
                "wDebugTextRamLog", DEBUG_TEXT_RAM_ENTRY_SIZE,
                entry * DEBUG_TEXT_RAM_ENTRY_SIZE)
            end = raw.find(b"\x50")
            strings.append(raw if end < 0 else raw[:end + 1])
        return strings

    def text_seen(self, value):
        return self._encode_text(value) in self.rendered_ram_texts

    def buffer_is(self, symbol, value, max_length=24):
        """Compare an @-terminated in-game string buffer by symbol name."""
        raw = self.mem.read_bytes(symbol, max_length)
        end = raw.find(b"\x50")
        actual = raw if end < 0 else raw[:end + 1]
        return actual == self._encode_text(value)


class Request:
    """Builds and writes the request block from a test spec dict."""

    def __init__(self, battle: Battle):
        self.b = battle
        self.mem = battle.mem
        self.con = battle.con

    def _side_bytes(self, spec):
        blk = bytearray(DBG_SIZE)
        if spec is None:
            return blk
        idx = self.con.species_index(spec["species"])
        blk[DBG_SPECIES] = idx & 0xFF
        blk[DBG_SPECIES + 1] = idx >> 8
        blk[DBG_LEVEL] = spec.get("level", 50)
        blk[DBG_ABILSLOT] = {1: 0, 2: 1, "hidden": 2}.get(spec.get("ability_slot", 1), 0)
        if "ability" in spec:
            # Prefer the species' legal slot so entry hooks (Intimidate,
            # Drizzle, Trace...) run with the requested ability. Fall back to
            # a post-entry override for illegal species/ability pairs.
            slot = self.con.ability_slot_of(spec["species"], spec["ability"])
            if slot is not None and "ability_slot" not in spec:
                blk[DBG_ABILSLOT] = slot
            else:
                blk[DBG_ABILOVERRIDE] = self.con.ability_id(spec["ability"])
        if "item" in spec:
            blk[DBG_ITEM] = self.con.item_id(spec["item"])
        moves = spec.get("moves") or []
        for i, mv in enumerate(moves[:4]):
            mi = self.con.move_index(mv)
            blk[DBG_MOVES + 2 * i] = mi & 0xFF
            blk[DBG_MOVES + 2 * i + 1] = mi >> 8
        dvs = spec.get("dvs", 0xFFFF)
        blk[DBG_DVS] = dvs & 0xFF
        blk[DBG_DVS + 1] = dvs >> 8
        blk[DBG_HPPCT] = spec.get("hp", 100)
        blk[DBG_STATUS] = spec.get("status_byte", 0)
        stages = spec.get("stages")
        if stages:
            # dict like {atk: +1, spd: -2}; 7 = neutral
            order = ["atk", "def", "spd", "satk", "sdef", "acc", "eva"]
            for i, key in enumerate(order):
                blk[DBG_STATLEVELS + i] = 7 + stages.get(key, 0)
        for name in spec.get("substatus", []):
            # list of SUBSTATUS_* names (without the prefix), e.g. [MIST, TOXIC];
            # applied post-entry to the active mon (player1/enemy only)
            byte, bit = SUBSTATUS_BITS[name.upper().replace(" ", "_")]
            blk[DBG_SUBSTATUS + byte] |= 1 << bit
        return blk

    def write(self, test):
        m = self.mem
        rng_mode = {"off": 0, "forced": 1, "forced_low": 1, "forced_high": 1,
                    "seeded": 2}[test.get("rng", "seeded")]
        rng_value = test.get("rng_value")
        if rng_value is None:
            # forced_low $14: below every effect chance (procs; no crit), and
            # exits the engine's reroll loops: &3==0 picks enemy move slot 1,
            # &7!=0 ends sleep rolls, swap&3!=0 ends tri-status rolls.
            # forced_high $B4: above every effect chance, same loop guarantees.
            # Multi-hit count rolls need &3!=0 -> use seeded mode for those.
            rng_value = {"forced_low": 0x14, "forced_high": 0xB4}.get(test.get("rng"), 0x14)

        m.write("wDebugBattleFlags", 1)  # auto
        m.write("wDebugControl", 0)
        m.write("wDebugSwitchBlocked", 0)
        # Permit effect-only runs against a pre-capture debug ROM while source
        # changes are being rebuilt. Post-battle tests require the new symbol.
        if "wDebugResultParty1Item" in m.sym.by_name:
            m.write("wDebugResultParty1Item", 0)
        m.write("wDebugTurnTarget", test.get("turns", 1))
        m.write("wDebugTurnsDone", 0)
        m.write("wDebugRNGModeReq", rng_mode)
        m.write("wDebugRNGValueReq", rng_value)
        weather = test.get("weather")
        m.write("wDebugWeather", 0xFF if weather is None else
                {"none": 0, "rain": 1, "sun": 2, "sandstorm": 3, "hail": 4}[weather])
        m.write("wDebugPScreens", test.get("player_screens", 0))
        m.write("wDebugEScreens", test.get("enemy_screens", 0))

        script = test.get("move_script") or []
        for i in range(8):
            action = script[i] if i < len(script) else 0
            if isinstance(action, str) and action.lower().startswith("switch:"):
                slot = int(action.split(":", 1)[1])
                if not 1 <= slot <= 4:
                    raise ValueError(f"switch slot must be 1..4, got {slot}")
                action = 0x80 | (slot - 1)
            m.write("wDebugMoveScript", action, i)

        m.write_bytes("wDebugPlayer1", self._side_bytes(test.get("player")))
        m.write_bytes("wDebugPlayer2", self._side_bytes(test.get("player2")))
        m.write_bytes("wDebugEnemy", self._side_bytes(test.get("enemy")))
        # enemy2 present = trainer battle (2-mon enemy party, AI can switch)
        m.write_bytes("wDebugEnemy2", self._side_bytes(test.get("enemy2")))

        m.write("wDebugMagic", 0xCC)  # last: arms the request
