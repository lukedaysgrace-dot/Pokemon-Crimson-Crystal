"""Private SameBoy session for real game video/audio and banked test memory."""
import ctypes as C
from pathlib import Path

from record_sampled_cries import prepare
from symbols import Symbols, Constants
from state import Battle


class NativeMemory:
    def __init__(self, session):
        self.session = session

    def __getitem__(self, key):
        s = self.session
        if isinstance(key, tuple):
            bank, address = key
            old = s.lib.cry_read(s.gb, 0xff70)
            s.lib.cry_write(s.gb, 0xff70, bank)
            value = s.lib.cry_read(s.gb, address)
            s.lib.cry_write(s.gb, 0xff70, old)
            return value
        if isinstance(key, slice):
            return [s.lib.cry_read(s.gb, i) for i in range(key.start, key.stop)]
        return s.lib.cry_read(s.gb, key)

    def __setitem__(self, key, value):
        s = self.session
        if isinstance(key, tuple):
            bank, address = key
            old = s.lib.cry_read(s.gb, 0xff70)
            s.lib.cry_write(s.gb, 0xff70, bank)
            s.lib.cry_write(s.gb, address, value)
            s.lib.cry_write(s.gb, 0xff70, old)
        elif isinstance(key, slice):
            for i, byte in zip(range(key.start, key.stop), value):
                s.lib.cry_write(s.gb, i, byte)
        else:
            s.lib.cry_write(s.gb, key, value)


class Session:
    def __init__(self, rom):
        self.sym, self.con = Symbols(Path(rom).with_suffix('.sym')), Constants()
        self.lib = C.CDLL(str(prepare()))
        signatures = {
            'cry_new': ([C.c_char_p], C.c_void_p),
            'cry_invoke': ([C.c_void_p, C.c_uint, C.c_uint, C.c_uint, C.c_uint], C.c_int),
            'cry_read': ([C.c_void_p, C.c_uint], C.c_uint),
            'cry_write': ([C.c_void_p, C.c_uint, C.c_uint], None),
            'cry_video': ([C.c_void_p], None), 'cry_frame': ([C.c_void_p, C.c_uint], C.c_int),
            'cry_pixels': ([C.c_void_p], C.c_void_p), 'cry_pcm': ([C.c_void_p], C.c_void_p),
            'cry_state_size': ([C.c_void_p], C.c_size_t),
            'cry_save': ([C.c_void_p, C.c_void_p], None),
            'cry_load': ([C.c_void_p, C.c_void_p, C.c_size_t], C.c_int),
            'cry_free': ([C.c_void_p], None),
        }
        for name, (args, result) in signatures.items():
            getattr(self.lib, name).argtypes = args
            getattr(self.lib, name).restype = result
        self.gb = self.lib.cry_new(str(Path(rom).resolve()).encode())
        assert self.gb
        self.lib.cry_video(self.gb)
        self.memory = NativeMemory(self)
        self.battle = Battle(self, self.sym, self.con)
        self.sound = b''

    def tick(self, keys=0):
        count = self.lib.cry_frame(self.gb, keys)
        self.sound = C.string_at(self.lib.cry_pcm(self.gb), count*4)

    def image(self):
        from PIL import Image
        return Image.frombytes('RGBA', (160, 144), C.string_at(self.lib.cry_pixels(self.gb), 160*144*4)).convert('RGB')

    def save(self):
        data = C.create_string_buffer(self.lib.cry_state_size(self.gb))
        self.lib.cry_save(self.gb, data)
        return data

    def load(self, data):
        if isinstance(data, bytes):
            data = C.create_string_buffer(data, len(data))
        assert self.lib.cry_load(self.gb, data, len(data)) == 0

    def bootstrap(self):
        from ui_checks import tile_text
        m = self.battle.mem

        def press(key, hold=4, wait=20):
            for _ in range(hold): self.tick(key)
            for _ in range(wait): self.tick()

        for iteration in range(800):
            if (m.read('wMapGroup'), m.read('wMapNumber'), m.read('wMapStatus')) == (24, 7, 2):
                for _ in range(120): self.tick()
                break
            text = tile_text(self)
            if 'Original' in text and 'Enhanced' in text:
                if m.read('wMenuCursorY') != 2: press(8)
                press(16)
            else:
                if iteration % 12 == 11: press(128, 4, 12)
                press(16)
        else:
            raise RuntimeError('SameBoy New Game did not finish')
        assert m.read('wGameplayRules') == 0
        for _ in range(80):
            if m.read('wDebugState') == 1: return
            press(32, 4, 10)
            press(128, 4, 14)
            for _ in range(12):
                if m.read('wMenuSelection') == 9: break
                press(8, 4, 16)
            press(16, 4, 40)
            for _ in range(120): self.tick()
        raise RuntimeError('SameBoy Debug menu did not open')

    def close(self):
        self.lib.cry_free(self.gb)
