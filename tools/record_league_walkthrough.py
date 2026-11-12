#!/usr/bin/env python3
"""Record a continuous lobby-to-Champion tour with native SameBoy audio.

Only a private new game's location, badges and showcase party are staged.
An optional party refresh occurs before a resumed chapter starts recording.
All recorded movement and battles use ordinary buttons. No player saves,
game-code patches, forced KOs or memory edits while a chapter is recording.
Run in the existing Linux/WSL emulator environment.
"""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import wave

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from sameboy_session import Session, NativeMemory
from overworld_controls import Controls
from safari_ui_checks import map_ids
from symbols import _parse_constants
from ui_checks import tile_text
import imageio_ffmpeg

FPS = 4194304 / 70224
KEYS = dict(right=1, left=2, up=4, down=8, a=16, b=32, select=64, start=128)
ROOMS = [('KOGAS_ROOM', 'KOGAS', 'KOGA'), ('BRUNOS_ROOM', 'BRUNOS', 'BRUNO'),
         ('KARENS_ROOM', 'KARENS', 'KAREN'), ('LORELEIS_ROOM', 'LORELEIS', 'LORELEI'),
         ('LANCES_ROOM', 'LANCES', 'LANCE')]


class TourControls(Controls):
    def __init__(self, harness):
        super().__init__(harness)
        self.failed_heals = set()
        self.in_heal = False

    def heal_in_battle(self):
        # Leave room to attack after a heal: repeatedly healing below half HP
        # can feed an Umbreon's Leftovers forever when Foul Play deals >50%.
        if self.m.read_u16_be('wBattleMonHP') * 4 > self.m.read_u16_be('wBattleMonMaxHP'):
            return False
        self.in_heal = True
        try:
            return self._heal_in_battle()
        finally:
            self.in_heal = False

    def _heal_in_battle(self):
        # Remember the actor before PACK temporarily reuses menu state.
        slot = self.m.read('wCurBattleMon') + 1
        state = (slot, self.m.read_u16_be('wBattleMonHP'))
        if state in self.failed_heals:
            return False
        self.press('up', hold=4, wait=24)
        self.press('left', hold=4, wait=24)
        self.press('down', hold=4, wait=24)
        self.press('a', hold=4, wait=100)
        for _ in range(8):
            if self.m.read('wCurPocket') == 0: break
            self.press('left', hold=4, wait=60)
        self.press('a', hold=4, wait=80)
        self.press('a', hold=4, wait=100)
        for _ in range(12):
            if 'Use on which' in tile_text(self.h): break
            self.press('a', hold=2, wait=30)
        for _ in range(8):
            if self.m.read('wMenuCursorY') == slot: break
            self.press('down', hold=4, wait=24)
        self.press('a', hold=4, wait=120)
        failed = False
        # Always leave the party/item menus. A successful heal's message can
        # still be active after 120 frames; blind A presses would select the
        # now-full Pokemon again instead of returning to the fight.
        for _ in range(20):
            text = tile_text(self.h)
            if 'FIGHT' in text and 'PACK' in text: break
            if 'effect' in text and 'won' in text:
                self.failed_heals.add(state)
                failed = True
            self.press('b', hold=4, wait=40)
        return not failed


class Movie:
    def __init__(self, session, path):
        self.s, self.path, self.frames = session, path, 0
        self.ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        self.silent, self.wav = path.with_suffix('.silent.mp4'), path.with_suffix('.wav')
        self.process = subprocess.Popen([self.ffmpeg, '-y', '-loglevel', 'error',
            '-f', 'rawvideo', '-pixel_format', 'rgb24', '-video_size', '640x576',
            '-framerate', str(FPS / 2), '-i', '-', '-an', '-c:v', 'libx264',
            '-threads', '2', '-preset', 'veryfast', '-crf', '17', '-pix_fmt', 'yuv420p',
            str(self.silent)], stdin=subprocess.PIPE)
        self.audio = wave.open(str(self.wav), 'wb')
        self.audio.setnchannels(2)
        self.audio.setsampwidth(2)
        self.audio.setframerate(48000)

    def append(self):
        if self.frames % 2 == 0:
            self.process.stdin.write(self.s.image().resize((640, 576), Image.Resampling.NEAREST).tobytes())
        self.audio.writeframesraw(self.s.sound)
        self.frames += 1

    def finish(self):
        self.process.stdin.close()
        assert self.process.wait() == 0, 'Video encoder failed'
        self.audio.close()
        subprocess.run([self.ffmpeg, '-y', '-loglevel', 'error', '-i', str(self.silent),
            '-i', str(self.wav), '-c:v', 'copy', '-c:a', 'aac', '-b:a', '192k',
            '-t', str(self.frames / FPS), '-movflags', '+faststart', str(self.path)], check=True)
        subprocess.run([self.ffmpeg, '-v', 'error', '-i', str(self.path),
            '-map', '0:v:0', '-map', '0:a:0', '-f', 'null', '-'], check=True)
        print('VIDEO', self.path.name, round(self.frames / FPS, 1), 'seconds', flush=True)
        self.silent.unlink()
        self.wav.unlink()
        return dict(file=self.path.name, frames=self.frames, seconds=self.frames / FPS)


class Tour(Session):
    def __init__(self, rom, out):
        super().__init__(rom)
        self.out, self.movie, self.frames, self.buttons = out, None, 0, []
        self.pb = self  # Controls' observation-only PyBoy-compatible memory surface.
        self.rom_data = rom.read_bytes()
        raw = self.memory

        class Memory(NativeMemory):
            def __getitem__(memory, key):
                if isinstance(key, tuple) and key[1] < 0x8000:
                    bank, address = key
                    return self.rom_data[(bank * 0x4000 if address >= 0x4000 else 0) + address % 0x4000]
                return raw[key]

        self.memory = Memory(self)
        self.c, self.m = TourControls(self), self.battle.mem
        self.maps = map_ids()
        self.events = _parse_constants(ROOT / 'constants/event_flags.asm')
        self.lib.cry_register.argtypes = [C.c_void_p, C.c_uint, C.c_uint, C.c_uint]
        self.lib.cry_register.restype = C.c_uint
        self.lib.cry_resume.argtypes = [C.c_void_p]
        self.enemies, self.last_enemy, self.battle_entries = [], None, []

    def reg(self, name, value=None):
        return self.lib.cry_register(self.gb, ['PC', 'SP', 'AF', 'BC', 'DE', 'HL'].index(name),
                                     value or 0, value is not None)

    def invoke(self, label, **registers):
        assert self.movie is None, 'Fixture changes are forbidden during recording'
        for name, value in registers.items(): self.reg(name, value)
        bank, address = self.sym[label]
        result = self.lib.cry_invoke(self.gb, bank, address, self.sym.addr('hROMBank'), registers.get('DE', 0))
        assert result >= 0, f'{label} did not return: {-result:04x}'
        return self.reg('AF') >> 8

    def begin(self, label):
        assert self.movie is None
        bank, address = self.sym[label]
        if bank:
            self.memory[0x2000] = bank
            self.m.write('hROMBank', bank)
        self.memory[0xff70] = 1
        self.memory[0xc0ec:0xc0ee] = [0xf0, 0xc0]
        self.memory[0xc0f0:0xc0f3] = [0xfb, 0x18, 0xfe]
        self.reg('SP', 0xc0ec)
        self.reg('PC', address)
        self.lib.cry_resume(self.gb)

    def tick(self, count=1, keys=0):
        for _ in range(count):
            super().tick(keys)
            if self.movie:
                self.movie.append()
                if self.m.read('wBattleMode'):
                    enemy = (self.m.read('wCurOTMon'), self.m.species_index_of(self.m.read('wEnemyMonSpecies')))
                    if enemy != self.last_enemy and enemy[1] in self.con.species_by_index:
                        self.enemies.append(dict(frame=self.frames, slot=enemy[0],
                            species=self.con.species_by_index[enemy[1]], level=self.m.read('wEnemyMonLevel')))
                        self.last_enemy = enemy
                else:
                    self.last_enemy = None
            self.frames += 1
            if self.movie and self.frames % 600 == 0:
                self.image().save(self.out / 'live.png')
                (self.out / 'live.json').write_text(json.dumps(dict(
                    frame=self.frames, text=tile_text(self), in_heal=self.c.in_heal,
                    buttons=self.buttons[-12:], pc=self.reg('PC'), bank=self.m.read('hROMBank'))))
                print('PROGRESS', self.frames, self.c.position(),
                      self.m.read('wCurBattleMon'), self.m.read_u16_be('wBattleMonHP'),
                      self.m.read('wEnemyMonSpecies'), self.m.read_u16_be('wEnemyMonHP'), flush=True)

    def press(self, button, hold=4, wait=36):
        if self.movie and self.m.read('wBattleMode') and not self.c.in_heal:
            text = tile_text(self)
            if ('Use on which' in text or ('effect' in text and 'won' in text)
                    or ('RESTORE' in text and 'CANCEL' in text)):
                button = 'b'
        if self.movie: self.buttons.append([self.frames, button, hold, wait])
        self.tick(hold, KEYS[button])
        self.tick(wait)

    def event(self, name):
        bit = self.events[name]
        return bool(self.m.read('wEventFlags', bit // 8) & (1 << (bit % 8)))

    def until(self, predicate, limit=12000, dialogue=False):
        start = self.frames
        while self.frames - start < limit:
            if predicate(): return
            if dialogue: self.press('a', hold=2, wait=100)
            else: self.tick(10)
        self.image().save(self.out / 'failure.png')
        raise RuntimeError(f'Timed out: {self.c.map_id()} {self.c.position()}\n{tile_text(self)}')

    def go(self, target):
        self.c.go(target)
        assert self.c.position() == target, f'Walk stopped at {self.c.position()}, expected {target}'

    def setup(self):
        cache = self.out / ('private-lobby-' + hashlib.sha256(self.rom_data).hexdigest()[:12] + '.state')
        if cache.exists():
            self.load(cache.read_bytes())
            return json.loads((self.out / 'private-party.json').read_text())
        # Session.bootstrap uses single-frame key masks; call the base implementation
        # directly while booting, since Tour.tick uses a frame-count interface.
        original_tick = self.tick
        self.tick = lambda keys=0: Session.tick(self, keys)
        self.bootstrap()
        self.tick = original_tick
        self.m.write('wOptions', 0x41)  # Fast text, animations on, SET battle style.
        self.m.write('wGameplayRules', 0)
        self.m.write('wJohtoBadges', 255)
        self.m.write('wKantoBadges', 255)
        self.m.write_bytes('wPlayerName', [0x86, 0x8e, 0x8b, 0x83] + [0x50] * 7)
        self.m.write('wPartyCount', 0)
        party = [
            ('MEWTWO', ['PSYCHIC_M', 'ICE_BEAM', 'THUNDERBOLT', 'AURA_SPHERE']),
            ('TYRANITAR', ['CRUNCH', 'ROCK_SLIDE', 'EARTHQUAKE', 'FIRE_PUNCH']),
            ('DRAGONITE', ['DRAGON_CLAW', 'FLY', 'EARTHQUAKE', 'FIRE_PUNCH']),
            ('SCIZOR', ['BULLET_PUNCH', 'X_SCISSOR', 'IRON_HEAD', 'SWORDS_DANCE']),
            ('STARMIE', ['SURF', 'PSYCHIC_M', 'ICE_BEAM', 'THUNDERBOLT']),
            ('ARCANINE', ['FLAMETHROWER', 'CRUNCH', 'EXTREMESPEED', 'CLOSE_COMBAT']),
        ]
        for slot, (name, moves) in enumerate(party, 1):
            ident = self.invoke('GetPokemonIDFromIndex', HL=self.con.species_index(name))
            self.m.write('wMonType', 0)
            self.m.write('wCurPartySpecies', ident)
            self.m.write('wCurPartyLevel', 100)
            self.invoke('TryAddMonToParty')
            ids = [self.invoke('GetMoveIDFromIndex', HL=self.con.moves[move]) for move in moves]
            self.m.write_bytes(f'wPartyMon{slot}Moves', ids)
        self.invoke('HealParty')
        assert self.m.read('wPartyCount') == 6
        # Supplies are ordinary bag items used by the input controller when needed.
        items = _parse_constants(ROOT / 'constants/item_constants.asm')
        self.m.write('wNumItems', 1)
        index = items['FULL_RESTORE']
        self.m.write_bytes('wItems', [index >> 8, index & 255, 99, 255])
        group, number = self.maps['INDIGO_PLATEAU_POKECENTER_1F']
        for name, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                                wXCoord=14, wYCoord=10, hMapEntryMethod=0xf1).items():
            self.m.write(name, value)
        self.invoke('EnterMap')
        self.m.write('hOAMUpdate', 0)
        self.begin('OverworldLoop.loop')
        self.tick(120)
        assert self.c.map_id() == self.maps['INDIGO_PLATEAU_POKECENTER_1F']
        self.image().save(self.out / '00-lobby.png')
        cache.write_bytes(bytes(self.save()))
        (self.out / 'private-party.json').write_text(json.dumps(party))
        return party


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal_debug.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/league-walkthrough')
    parser.add_argument('--resume-from', choices=[r[2] for r in ROOMS],
                        help='Continue from this private room checkpoint, retaining earlier completed clips')
    parser.add_argument('--refresh-party', action='store_true',
                        help='Restore the private party before the resumed chapter begins recording')
    args = parser.parse_args()
    if args.refresh_party and not args.resume_from:
        parser.error('--refresh-party requires --resume-from')
    args.output.mkdir(parents=True, exist_ok=True)
    s = Tour(args.rom, args.output)
    results, chapters = [], []
    try:
        first = next((i for i, r in enumerate(ROOMS, 1) if r[2] == args.resume_from), 1)
        if args.resume_from:
            s.load((args.output / f'private-{first:02d}-{args.resume_from.lower()}.state').read_bytes())
            party = json.loads((args.output / 'private-party.json').read_text())
            results = json.loads((args.output / 'progress.json').read_text())[:first-1]
            for r in results:
                chapters.append(dict(title=r['trainer'], frame=sum(
                    x['frames'] for x in results[:len(chapters)])))
            s.frames = sum(r['frames'] for r in results)
            if (args.output / 'inputs.json').exists():
                s.buttons = json.loads((args.output / 'inputs.json').read_text())
        else:
            party = s.setup()
        refreshes = []
        if args.refresh_party:
            # Run the native healer in disposable setup state, then copy only
            # its party result onto the exact checkpoint. Preserve the original
            # CPU/interrupt/map/audio state and all story progress.
            checkpoint = bytes(s.save())
            s.invoke('HealParty')
            length = (s.sym.addr('wPartyMon2') - s.sym.addr('wPartyMon1')) * s.m.read('wPartyCount')
            healed = s.m.read_bytes('wPartyMons', length)
            s.load(checkpoint)
            s.m.write_bytes('wPartyMons', healed)
            refreshes.append(dict(before=args.resume_from, hp_status_pp_restored=True,
                                  timing='before chapter recording'))
        print('Private party and lobby ready', flush=True)
        for i, (room, prefix, trainer) in enumerate(ROOMS, 1):
            if i < first: continue
            (args.output / f'private-{i:02d}-{trainer.lower()}.state').write_bytes(bytes(s.save()))
            s.movie = Movie(s, args.output / f'{i:02d}-{trainer.lower()}.mp4')
            start = s.frames
            chapters.append(dict(title=trainer, frame=sum(r['frames'] for r in results)))
            if i == 1:
                s.tick(180)
                s.c.go((14, 3))
            s.until(lambda: s.c.map_id() == s.maps[room] and s.event(f'EVENT_{prefix}_ROOM_ENTRANCE_CLOSED')
                    and not s.m.read('wScriptMode'))
            print('ENTER', trainer, s.c.position(), flush=True)
            s.tick(210)
            s.image().save(args.output / f'{i:02d}-{trainer.lower()}-entrance.png')
            # Stop at several heights and both sides so the scrolling camera
            # reveals the room and gives its ambient animation time to play.
            y0 = 19 if trainer == 'LANCE' else 13
            for point in [(3, y0), (6, y0), (5, 11), (4, 9), (6, 8)]:
                try:
                    s.c.path(point)
                except RuntimeError:
                    continue
                s.go(point)
                s.tick(120)
            if trainer == 'LANCE':
                s.go((4, 6))
                s.tick(240)
                s.image().save(args.output / f'{i:02d}-{trainer.lower()}-room.png')
                s.c.go((4, 5))  # Native approach trigger.
            else:
                s.go((4, 4))
                s.tick(210)
                s.image().save(args.output / f'{i:02d}-{trainer.lower()}-room.png')
                s.go((5, 8))
                s.press('up', hold=4, wait=40)
                s.tick(120)
                s.press('a', hold=2, wait=100)
            s.until(lambda: bool(s.m.read('wBattleMode')), limit=18000, dialogue=True)
            print('BATTLE', trainer, flush=True)
            battle_start = s.frames
            enemy_start = len(s.enemies)
            s.c.failed_heals.clear()
            s.c.battle(limit=90000)
            flag = 'EVENT_BEAT_CHAMPION_LANCE' if trainer == 'LANCE' else f'EVENT_BEAT_ELITE_4_{trainer}'
            s.until(lambda: s.event(flag), limit=2000, dialogue=True)
            if trainer == 'LANCE':
                s.until(lambda: s.c.map_id() == s.maps['HALL_OF_FAME'], limit=30000, dialogue=True)
                s.tick(120)
            else:
                s.until(lambda: s.event(f'EVENT_{prefix}_ROOM_EXIT_OPEN') and not s.m.read('wScriptMode'),
                        dialogue=True)
                s.tick(180)
            assert s.event(flag), trainer + ' was not defeated'
            print('DEFEATED', trainer, flush=True)
            s.image().save(args.output / f'{i:02d}-{trainer.lower()}-victory.png')
            if trainer != 'LANCE':
                s.go((4, 4))
                s.tick(150)
                s.c.go((4, 2))
                s.until(lambda: s.c.map_id() != s.maps[room])
            record = s.movie.finish()
            s.movie = None
            record.update(trainer=trainer, defeated=True, battle_seconds=(s.frames-battle_start)/FPS,
                          enemies=s.enemies[enemy_start:])
            results.append(record)
            (args.output / 'progress.json').write_text(json.dumps(results, indent=2))
            (args.output / 'inputs.json').write_text(json.dumps(s.buttons))
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        playlist = args.output / 'concat.txt'
        playlist.write_text(''.join(f"file '{r['file']}'\n" for r in results))
        metadata = args.output / 'chapters.txt'
        total_frames = sum(r['frames'] for r in results)
        metadata.write_text(';FFMETADATA1\n' + ''.join(
            f"[CHAPTER]\nTIMEBASE=1/1000\nSTART={round(ch['frame']/FPS*1000)}\n"
            f"END={round((chapters[j+1]['frame'] if j+1<len(chapters) else total_frames)/FPS*1000)}\n"
            f"title={ch['title']}\n" for j, ch in enumerate(chapters)))
        target = args.output / 'elite-four-full-walkthrough.mp4'
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-f', 'concat', '-safe', '0',
            '-i', str(playlist), '-i', str(metadata), '-map_metadata', '1', '-c', 'copy',
            '-movflags', '+faststart', str(target)], check=True)
        subprocess.run([ffmpeg, '-v', 'error', '-i', str(target), '-f', 'null', '-'], check=True)
        report = dict(rom=args.rom.name, sha256=hashlib.sha256(args.rom.read_bytes()).hexdigest(),
                      emulator='SameBoy', native_game_audio=True, buttons_only_during_recording=True,
                      party=party, party_refreshes=refreshes, chapters=chapters, battles=results, seconds=total_frames/FPS)
        (args.output / 'results.json').write_text(json.dumps(report, indent=2))
        (args.output / 'inputs.json').write_text(json.dumps(s.buttons))
        print('COMPLETE', target, round(total_frames/FPS, 1), 'seconds', flush=True)
    except Exception:
        (args.output / 'private-failure.state').write_bytes(bytes(s.save()))
        s.image().save(args.output / 'failure.png')
        (args.output / 'failure.txt').write_text(tile_text(s))
        if s.movie:
            s.movie.finish()
            s.movie = None
        raise
    finally:
        s.close()


if __name__ == '__main__':
    main()
