#!/usr/bin/env python3
"""Native ball throws/send-outs, exact RGB5 colors and cleanup on both ROMs.

Only private New Game/emulator state is used. Summary/PC coverage lives in
tools/test_summary_ui.py; both tests share the independent requested receipt.
"""
import io
import json

from PIL import Image, ImageDraw

from gameplay_rules_checks import new_game
from probability_checks import call
from runner import Harness, ROOT
from save_menu_checks import begin_native_call
from ui_checks import tile_text, wait


REFERENCE = json.loads((ROOT / 'tools/testdata/ball_palettes.json').read_text())['colors']
OUT = ROOT / '_artifacts/ball-palettes'


def palette_bytes(pair):
    return b''.join((r | g << 5 | b << 10).to_bytes(2, 'little')
                    for r, g, b in ([31, 31, 31], *pair, [0, 0, 0]))


def run(rom):
    h = Harness(rom_path=rom)
    pb, m = h.pb, h.battle.mem
    out = OUT / rom.stem
    out.mkdir(parents=True, exist_ok=True)
    checks = 0
    events = []
    current = None
    captures = []

    def check(ok, label):
        nonlocal checks
        checks += 1
        if not ok:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(label)

    def read_palette(name):
        return bytes(m.read_bytes(name, 8, 5 * 8))

    def loaded(_):
        if current is None:
            return
        name, expected = current
        for buffer in ('wOBPals1', 'wOBPals2'):
            check(read_palette(buffer) == expected, f'{name}: exact {buffer} during native ball animation')
        events.append(name)

    try:
        new_game(h, 0)
        for key, value in dict(wPartyCount=0, wMonType=0, wBattleMode=0, wOptions=0x41).items():
            m.write(key, value)
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('MEW'))
        m.write('wCurPartySpecies', sid)
        m.write('wCurPartyLevel', 50)
        call(h, 'TryAddMonToParty')
        m.write('wPartyMon1Personality', m.read('wPartyMon1Personality') & ~0x60)
        sid = call(h, 'GetPokemonIDFromIndex', HL=h.con.species_index('SNORLAX'))
        for key, value in dict(wTempWildMonSpecies=sid, wCurPartyLevel=50,
                               wOtherTrainerClass=0, wBattleType=0, wBattleMode=0,
                               hCurWeather=0).items():
            m.write(key, value)
        begin_native_call(h, 'StartBattle')
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        fixture = io.BytesIO()
        pb.save_state(fixture)
        pb.hook_register(*h.sym['GetBallAnimPal.done'], loaded, None)
        raw = (ROOT / 'gfx/battle_anims/pokeball.2bpp').read_bytes()
        ball_tiles = {raw[i:i + 16] for i in range(0, len(raw), 16)} - {bytes(16)}
        green = palette_bytes([[12, 25, 1], [5, 14, 0]])

        def animate(name, animation, param, side=0, disabled=False):
            nonlocal current
            fixture.seek(0)
            pb.load_state(fixture)
            expected = palette_bytes(REFERENCE[name])
            current = (name, expected)
            events.clear()
            m.write('wCurItem', h.con.item_id(name))
            m.write('hBattleTurn', side)
            m.write('wBattleAnimParam', param)
            m.write('wWildMon', 1)
            m.write('wNumHits', 0)
            m.write('wBuffer2', 0)
            m.write('wOptions', 0xc1 if disabled else 0x41)
            anim = h.con.moves[animation] & 0xffff
            m.write_bytes('wFXAnimID', [anim & 255, anim >> 8])
            before = {key: bytes(m.read_bytes(key, 64)) for key in ('wOBPals1', 'wOBPals2')}
            begin_native_call(h, 'PlayBattleAnim')
            pb.memory[0xc0f0] = 0xf3
            visible = 0
            captured = False
            for elapsed in range(1200):
                pb.tick(1, True)
                found = False
                if events:
                    for i in range(40):
                        y, x, tile, attr = pb.memory[0xfe00 + 4*i:0xfe04 + 4*i]
                        if not (0 < x < 168 and 0 < y < 160 and attr & 7 == 5):
                            continue
                        art = bytes(pb.memory[(attr >> 3) & 1, 0x8000 + tile*16:0x8010 + tile*16])
                        if art in ball_tiles:
                            found = True
                            break
                if found and pb.memory[0xff41] & 3 != 3:
                    old_index = pb.memory[0xff6a]
                    actual = bytearray()
                    for i in range(8):
                        pb.memory[0xff6a] = 5 * 8 + i
                        actual.append(pb.memory[0xff6b])
                    pb.memory[0xff6a] = old_index
                    check(actual == expected, f'{name}: hardware OBJ palette with ball visible ({animation})')
                    visible += 1
                    # OAM can be committed after the current scanline rendered.
                    # Wait for several complete visible frames for the preview.
                    if (not captured and visible >= 8 and animation == 'ANIM_THROW_POKE_BALL'
                            and param and name not in {entry[0] for entry in captures}):
                        image = pb.screen.image.convert('RGB')
                        image.save(out / (name.lower() + '-throw.png'))
                        captures.append((name, image))
                        captured = True
                if pb.register_file.PC in (0xc0f1, 0xc0f3):
                    break
            else:
                raise AssertionError(f'{name}: {animation} timed out')
            # Throws still play when the normal move-animation option is off.
            check(bool(events), f'{name}: native animation selected the ball palette ({animation}, side {side})')
            check(visible > 0, f'{name}: ball reached hardware OAM with exact colors ({animation}, side {side})')
            call(h, 'RestoreBallOBPal')
            for key in before:
                check(read_palette(key) == green, f'{name}: restores normal green OBJ slot after {animation}')
                after = bytes(m.read_bytes(key, 64))
                check(after[:40] + after[48:] == before[key][:40] + before[key][48:],
                      f'{name}: other OBJ palettes unchanged after {animation}')
            current = None

        for name in REFERENCE:
            item = h.con.item_id(name)
            param = item if name in ('MASTER_BALL', 'ULTRA_BALL', 'GREAT_BALL') else h.con.item_id('POKE_BALL')
            animate(name, 'ANIM_THROW_POKE_BALL', param)
            animate(name, 'ANIM_SEND_OUT_MON', 0)
        # Trainer-blocked balls, animations-off throws, and both send-out sides.
        for name in ('MASTER_BALL', 'PARK_BALL', 'FRIEND_BALL'):
            animate(name, 'ANIM_THROW_POKE_BALL', 0)
            animate(name, 'ANIM_THROW_POKE_BALL', h.con.item_id('POKE_BALL'), disabled=True)
            animate(name, 'ANIM_SEND_OUT_MON', 0, side=1)

        # Unknown runtime items must never run past the table or inherit a tint.
        for item in (0, 0xff, h.con.item_id('POTION')):
            call(h, 'GetBallPalette', C=item)
            pointer = pb.register_file.HL
            bank = h.sym.bank('BallColors')
            check(bytes(pb.memory[bank, pointer:pointer + 8]) == palette_bytes(REFERENCE['POKE_BALL']),
                  f'unknown runtime item {item}: Poke Ball fallback')
        (out / 'results.json').write_text(json.dumps({'checks': checks, 'balls': list(REFERENCE)}, indent=2) + '\n')
        print(f'{rom.name}: {checks} native ball palette checks passed', flush=True)
        return captures
    finally:
        pb.stop(save=False)


def preview(captures):
    # Decode the real native throw frameset (two left tiles mirrored right).
    raw = (ROOT / 'gfx/battle_anims/pokeball.2bpp').read_bytes()
    info_art = (ROOT / 'gfx/sprites/poke_ball.2bpp').read_bytes()
    sheet = Image.new('RGB', (880, 800), '#f4f6f9')
    draw = ImageDraw.Draw(sheet)
    from PIL import ImageFont
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
    heading = ImageFont.truetype(font_path, 25)
    label_font = ImageFont.truetype(font_path, 17)
    small = ImageFont.truetype(font_path, 13)
    draw.text((22, 18), 'Crimson Crystal - finished ball colors', fill='#1e2837', font=heading)
    draw.text((24, 54), 'Battle sprite / INFO stats-screen sprite | actual ROM artwork and RGB5 colors', fill='#555f6e', font=small)
    for i, (name, pair) in enumerate(REFERENCE.items()):
        x, y = 20 + (i % 4)*215, 88 + (i // 4)*170
        draw.rectangle((x, y, x + 199, y + 157), fill='white')
        colors = [tuple(round(c*255/31) for c in rgb) for rgb in ([31, 31, 31], *pair, [0, 0, 0])]
        for source, sx, scale in ((raw, x + 9, 5), (info_art, x + 111, 5)):
            sprite = Image.new('RGB', (16, 16), 'white')
            for py in range(16):
                for px in range(16):
                    if source is raw:
                        tile, tx = py//8, px if px < 8 else 15-px
                    else:
                        tile, tx = (py//8)*2 + px//8, px % 8
                    offset = tile*16 + (py % 8)*2
                    shade = (source[offset] >> (7-tx) & 1) | (source[offset+1] >> (7-tx) & 1)*2
                    sprite.putpixel((px, py), colors[shade])
            sheet.paste(sprite.resize((16*scale, 16*scale), Image.Resampling.NEAREST), (sx, y + 8))
        label = name.replace('_', ' ').title().replace('Poke Ball', 'Poké Ball')
        draw.text((x + 100, y + 102), label, fill='#1e2837', font=label_font, anchor='mt')
        note = ('Kept original' if name in ('MASTER_BALL', 'HEAVY_BALL', 'SAFARI_BALL') else
                'Yellow top / white bottom' if name == 'PARK_BALL' else 'Exact Coral colors')
        draw.text((x + 100, y + 133), note, fill='#555f6e', font=small, anchor='mt')
    sheet.save(OUT / 'finished-ball-colors.png')
    contact = Image.new('RGB', (4*320, 4*310), '#f4f6f9')
    draw = ImageDraw.Draw(contact)
    for i, (name, image) in enumerate(captures):
        x, y = (i % 4)*320, (i // 4)*310
        draw.text((x + 8, y + 4), name.replace('_', ' ').title(), fill='#1e2837', font=label_font)
        contact.paste(image.resize((320, 288), Image.Resampling.NEAREST), (x, y + 22))
    contact.save(OUT / 'native-battle-throws.png')


if __name__ == '__main__':
    for name in ('pokecrystal', 'pokecrystal_debug'):
        captures = run(ROOT / (name + '.gbc'))
        if name == 'pokecrystal':
            preview(captures)
