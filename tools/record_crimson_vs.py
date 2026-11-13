#!/usr/bin/env python3
"""Record the native Lance matchup, and verify VS frames/portrait uploads.

Uses a private New Game; only buttons are used after recording begins.
No player save is opened. SameBoy supplies the unmodified video and game audio.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from PIL import Image, ImageDraw
import imageio_ffmpeg

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from record_league_walkthrough import Tour, Movie, FPS
from ui_checks import tile_text
from symbols import _parse_constants
from vs_intro.build import vs_letters,CRYSTAL_OUTER,IMPACT_SHAKE

CHARMAP={ch:int(value,16) for ch,value in re.findall(r'charmap "([^"\n]+)",\s*\$([0-9a-fA-F]+)',
                                                    (ROOT/'charmap.asm').read_text())}
SFX=_parse_constants(ROOT/'constants/sfx_constants.asm')
MUSIC=_parse_constants(ROOT/'constants/music_constants.asm')
VS_MASK=vs_letters()
WHITE_VS=[(x,y) for y in range(144) for x in range(160) if VS_MASK.getpixel((x,y))]
CRYSTAL_MASK=Image.new('1',(160,144))
ImageDraw.Draw(CRYSTAL_MASK).polygon(CRYSTAL_OUTER,fill=1)
CRYSTAL_PIXELS=[(x,y) for y in range(144) for x in range(160) if CRYSTAL_MASK.getpixel((x,y))]


def check_vs_scene(session,raw,image):
    """Verify full picture mirroring and every solid-white letter pixel."""
    old_vbk=session.memory[0xff4f]&1
    session.memory[0xff4f]=1
    attrs=bytes(session.memory[0x9800:0x9a40])
    session.memory[0xff4f]=old_vbk
    for x in range(7):
        for y in range(7):
            left=(5+y)*32+x
            right=(5+y)*32+13+x
            assert raw[left]==(6-x)*7+y and attrs[left]&0x20,('mirrored player',x,y)
            assert raw[right]==49+x*7+y and not attrs[right]&0x20,('opponent direction',x,y)
    for x,y in WHITE_VS:
        assert image.getpixel((x,y))==(255,255,255),('VS must be white',x,y,image.getpixel((x,y)))


def game_name(value):
    return bytes(CHARMAP[ch] for ch in value)+b'\x50'


def contrast(shot):
    return sum(high-low for low,high in shot.getextrema())


def rgb5(data):
    return [(word&31,(word>>5)&31,(word>>10)&31)
            for word in (int.from_bytes(data[i:i+2],'little') for i in range(0,len(data),2))]


def rom_bytes(session,bank,address,count):
    offset=bank*0x4000+address%0x4000
    return session.rom_data[offset:offset+count]


def check_name(session,raw,value,start):
    font=(ROOT/'gfx/battle_vs/font.bin').read_bytes()
    encoded=game_name(value)[:-1]
    for i,ch in enumerate(encoded):
        tile=raw[448+start+i]
        assert tile==0x62+start+i,('name tile',value,i)
        expected=font[(ch-128)*16:(ch-127)*16] if ch>=128 else bytes(16)
        assert bytes(session.memory[0x9000+tile*16:0x9010+tile*16])==expected,('name glyph',value,i)


def signature(raw):
    # Native names occupy row 14; all other map bytes must match exactly.
    return raw[:448] + raw[480:]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT/'pokecrystal_debug.gbc')
    parser.add_argument('--output', type=Path, default=ROOT/'_artifacts/vs-intro/native')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((ROOT/'gfx/battle_vs/manifest.json').read_text())
    for row in manifest['frames']:
        assert tuple(row['crystal_offset'])==IMPACT_SHAKE.get(row['frame'],(0,0)),('shake timing',row)
    gfx_size = manifest['frame_bytes']-1152
    maps, frames = {}, {}
    for frame in manifest['frames']:
        raw=(ROOT/f'gfx/battle_vs/frame{frame["frame"]:02d}.bin').read_bytes()
        frames[frame['frame']]=raw
        maps.setdefault(signature(raw[gfx_size:gfx_size+576]),[]).append(frame['frame'])
    s=Tour(args.rom,args.output)
    seen=[]
    captures={}
    animation=[]
    portraits=[]
    fades=[]
    border_frames=[]
    border_masks=set()
    sliding_pictures=set()
    try:
        s.setup()
        base=bytes(s.save())
        # Exercise the actual selection routine across bosses and ordinary classes.
        classes=s.con.trainer_classes
        music_cases={'FALKNER':'MUSIC_JOHTO_GYM_LEADER_BATTLE',
                     'MISTY':'MUSIC_KANTO_GYM_LEADER_BATTLE',
                     'CHAMPION':'MUSIC_CHAMPION_BATTLE',
                     'RIVAL1':'MUSIC_RIVAL_BATTLE',
                     'PROTON':'MUSIC_ROCKET_EXECUTIVE_BATTLE',
                     'CRYSTAL':'MUSIC_CRYSTAL_BATTLE'}
        for trainer,theme in music_cases.items():
            s.load(base)
            s.m.write('wOtherTrainerClass',classes[trainer])
            s.m.write('wOtherTrainerID',1)
            s.invoke('PlayBattleMusic')
            assert int.from_bytes(s.m.read_bytes('wChannel1MusicID',2),'little')==MUSIC[theme],trainer
        s.load(base)
        positive=['FALKNER','CLAIR','KOGA','LORELEI','CHAMPION','CHAMPION_REMATCH',
                  'FALKNER_REMATCH','RED','RED2','BLUE','RIVAL1','RIVAL2','RIVAL3',
                  'PROTON','PETREL','ARIANA','ARCHER','CRYSTAL3']
        negative=['TRAINER_NONE','YOUNGSTER','GRUNTM','SCIENTIST','CAL','HOSTESS']
        for name in positive+negative:
            s.m.write('wOtherTrainerClass',classes[name])
            s.invoke('CrimsonVSIsBoss')
            carry=bool(s.reg('AF')&0x10)
            assert carry == (name in positive),(name,carry)
        for gender,player,trainer in [(0,'gold','FALKNER'),(1,'lyra','WHITNEY'),
                                       (2,'indigo','CLAIR'),(3,'mint','CHAMPION')]:
            s.load(base)
            s.m.write('wPlayerGender',gender)
            s.m.write('wPlayerSpriteSetupFlags',0)
            s.m.write('wOtherTrainerClass',classes[trainer])
            s.invoke('DisableLCD')
            s.invoke('CrimsonVSLoadPictures')
            s.memory[0xff4f]=1
            actual=bytes(s.memory[0x9000:0x9310])
            assert actual==(ROOT/f'gfx/player/{player}.2bpp').read_bytes(),player
            actual=bytes(s.memory[0x9310:0x9620])
            path={'CHAMPION':'champion','CLAIR':'clair','WHITNEY':'whitney','FALKNER':'falkner'}[trainer]
            assert actual==(ROOT/f'gfx/trainers/{path}.2bpp').read_bytes(),trainer
            # Compare with the game's canonical palette lookups, independently
            # of this interstitial. Deliberately poison the farcall A overlay.
            s.invoke('GetPlayerOrMonPalettePointer',AF=0)
            expected=rom_bytes(s,s.sym['PlayerPalette'][0],s.reg('HL'),4)
            s.invoke('GetTrainerPalettePointer',AF=classes[trainer]<<8)
            expected_enemy=rom_bytes(s,s.sym['TrainerPalettes'][0],s.reg('HL'),4)
            s.m.write('hFarCallReturnA',0x39)
            s.invoke('CrimsonVSLoadPalettes')
            assert s.m.read_bytes('wBGPals1',4,34)==expected,('player palette',player)
            assert s.m.read_bytes('wBGPals1',4,42)==expected_enemy,('opponent palette',trainer)
            assert s.m.read_bytes('wBGPals2',4,34)==expected,('active player palette',player)
            # Verify arbitrary saved names with lowercase, digits and punctuation.
            name=['Gold','Lyra','aB12!?','Mint'][gender]
            s.m.write_bytes('wPlayerName',game_name(name))
            s.m.write('wOtherTrainerID',1)
            s.invoke('CrimsonVSPrepareNames')
            raw=s.m.read_bytes('wTileMap',20,340)
            s.memory[0xff4f]=1
            check_name(s,bytes(448)+raw,name,(7-len(name))//2)
            s.memory[0xff4f]=0
            # The longest supported opponent name must remain inside column 19.
            s.m.write('wOtherTrainerClass',classes['RIVAL1'])
            s.m.write_bytes('wRivalName',game_name('RIVAL-1234'))
            s.invoke('CrimsonVSPrepareNames')
            raw=s.m.read_bytes('wTileMap',20,340)
            s.memory[0xff4f]=1
            check_name(s,bytes(448)+raw,'RIVAL-1234',10)
            s.memory[0xff4f]=0
            # Record the complete native intro for each playable character too.
            s.load(base)
            name=['Gold','Lyra','Indigo','Mint'][gender]
            s.m.write('wPlayerGender',gender)
            s.m.write('wPlayerSpriteSetupFlags',0)
            s.m.write('wOtherTrainerClass',classes[trainer])
            s.m.write('wOtherTrainerID',1)
            s.m.write_bytes('wPlayerName',game_name(name))
            s.m.write('hMapAnims',0)
            s.begin('CrimsonVSIntro')
            best=None
            checked=False
            for _ in range(290):
                s.tick()
                old_vbk=s.memory[0xff4f]&1
                s.memory[0xff4f]=0
                shown=bytes(s.memory[0x9800:0x9a40])
                final_frame=False
                if signature(shown)==signature(frames[25][gfx_size:gfx_size+576]):
                    s.memory[0xff4f]=1
                    bank=(s.memory[0x9800]&8)>>3
                    s.memory[0xff4f]=bank
                    final_frame=bytes(s.memory[0x8800:0x8800+gfx_size])==frames[25][:gfx_size]
                s.memory[0xff4f]=old_vbk
                if final_frame:
                    image=s.image()
                    if not checked:
                        check_vs_scene(s,shown,image)
                        checked=True
                    if best is None or contrast(image)>=contrast(best):best=image
                if s.reg('PC')==0xc0f1:break
            assert best is not None and checked,('native character preview',player)
            portraits.append((player,best))
            best.resize((640,576),Image.Resampling.NEAREST).save(args.output/f'player-{player}.png')
        for disabled in ['options','ordinary','link','tower']:
            s.load(base)
            s.m.write('wOtherTrainerClass',classes['CHAMPION'])
            if disabled=='options':s.m.write('wOptions',0xc1)
            if disabled=='ordinary':s.m.write('wOtherTrainerClass',classes['YOUNGSTER'])
            if disabled=='link':s.m.write('wLinkMode',1)
            if disabled=='tower':s.m.write('wInBattleTowerBattle',1)
            s.invoke('DisableLCD')
            s.memory[0xff4f]=0
            before=bytes(s.memory[0x8800:0x8f00])
            s.invoke('CrimsonVSIntro')
            assert before==bytes(s.memory[0x8800:0x8f00]),disabled
        s.load(base)
        demo_name='Luke'
        s.m.write_bytes('wPlayerName',game_name(demo_name))
        s.m.write('wOtherTrainerClass',0)
        group,number=s.maps['LANCES_ROOM']
        for name,value in dict(wDefaultSpawnpoint=255,wMapGroup=group,wMapNumber=number,
                               wXCoord=4,wYCoord=23,hMapEntryMethod=0xf1).items(): s.m.write(name,value)
        s.invoke('EnterMap')
        s.m.write('hOAMUpdate',0)
        s.begin('OverworldLoop.loop')
        original=s.tick
        start=None
        end=None
        last=None
        music_started=None

        def preview_frame(image):
            # Keep the complete reveal through send-out without retaining
            # thousands of enlarged frames in memory. GIF is native 2x / 30fps.
            if (s.frames-start)%2==0:
                animation.append(image.resize((320,288),Image.Resampling.NEAREST))

        def tick(count=1,keys=0):
            nonlocal start,end,last,music_started
            for _ in range(count):
                original(1,keys)
                if s.m.read('hLCDCPointer')==0x43:
                    assert s.m.read_bytes('wLYOverrides',1,95)==b'\0','textbox split must start at entry 95'
                    scene=s.image()
                    box=scene.crop((0,96,160,144)).convert('L')
                    mask=bytes(1 if value<128 else 0 for value in box.getdata())
                    if any(mask):
                        border_frames.append(s.frames)
                        border_masks.add(mask)
                    sliding_pictures.add(scene.crop((0,0,160,56)).tobytes())
                song=int.from_bytes(s.m.read_bytes('wChannel1MusicID',2),'little')
                if song==MUSIC['MUSIC_CHAMPION_BATTLE'] and music_started is None:music_started=s.frames
                if start is not None:
                    assert song==MUSIC['MUSIC_CHAMPION_BATTLE'],'battle music must continue through the reveal and entrance'
                if s.memory[0xff4f] & 1:
                    if start is not None:preview_frame(s.image())
                    continue
                raw=bytes(s.memory[0x9800:0x9a40])
                candidates=maps.get(signature(raw),[])
                frame=None
                if candidates:
                    s.memory[0xff4f]=1
                    attrs=bytes(s.memory[0x9800:0x9a40])
                    bank_flag=attrs[0]&8
                    s.memory[0xff4f]=bank_flag>>3
                    graphics=bytes(s.memory[0x8800:0x8800+gfx_size])
                    s.memory[0xff4f]=0
                    frame=next((k for k in candidates if frames[k][:gfx_size]==graphics),None)
                if frame is not None:
                    if start is None: start=s.frames
                    end=s.frames
                    shot=s.image()
                    preview_frame(shot)
                    # The white exit fade retains the last map for one frame.
                    if frame not in captures or contrast(shot)>=contrast(captures[frame]):captures[frame]=shot
                    if frame!=last:
                        seen.append((s.frames,frame))
                        expected=bytes(a if a&8 else a|bank_flag for a in frames[frame][gfx_size+576:])
                        assert attrs==expected,('attributes',frame)
                        if frame==25:check_vs_scene(s,raw,shot)
                        if frame in (4,12):
                            expected_sound=SFX['SFX_CRIMSON_VS_FORM' if frame==4 else 'SFX_CRIMSON_VS_LOCK']
                            assert s.m.read('wCurSFX')==expected_sound,('sound cue',frame)
                    last=frame
                    if frame==25:
                        # Portrait bytes are the actual source sprites, in bank 1.
                        s.memory[0xff4f]=1
                        player=bytes(s.memory[0x9000:0x9310])
                        opponent=bytes(s.memory[0x9310:0x9620])
                        assert player==(ROOT/'gfx/player/gold.2bpp').read_bytes()
                        assert opponent==(ROOT/'gfx/trainers/champion.2bpp').read_bytes()
                        check_name(s,raw,demo_name,(7-len(demo_name))//2)
                        check_name(s,raw,'LANCE',14)
                        s.memory[0xff4f]=0
                        palette=s.m.read_bytes('wBGPals2',64)
                        if not fades or fades[-1]!=palette:fades.append(palette)
                elif start is not None:preview_frame(s.image())
        s.tick=tick
        movie_start=s.frames
        s.movie=Movie(s,args.output/'lance-vs-battle.mp4')
        s.until(lambda:s.event('EVENT_LANCES_ROOM_ENTRANCE_CLOSED') and not s.m.read('wScriptMode'))
        s.tick(30)
        s.c.go((4,5))
        s.until(lambda:'FIGHT' in tile_text(s),limit=18000,dialogue=True)
        s.tick(90) # Hold after the fully revealed opponent and native Fight menu.
        record=s.movie.finish();s.movie=None
        assert [k for _,k in seen]==list(range(26)),seen
        assert len(animation)>70,'The reveal must animate at native frame timing'
        assert len(border_frames)>=60,('textbox slide observations',len(border_frames))
        assert len(border_masks)==1,('textbox frame moved during trainer slide',len(border_masks))
        assert len(sliding_pictures)>20,'pinning the frame must preserve trainer motion'
        gem=lambda image:tuple(image.getpixel(point) for point in CRYSTAL_PIXELS)
        assert len({gem(captures[k]) for k in IMPACT_SHAKE})>1,'crystal must shake on assembly'
        assert len({gem(captures[k]) for k in range(16,26)})==1,'crystal must stay still after its short shake'
        assert music_started is not None and music_started<start,('music starts before reveal',music_started,start)
        assert len(fades)>=12,('smooth fade steps',len(fades))
        for before,after in zip(fades,fades[1:]):
            assert all(y>=x for a,b in zip(rgb5(before),rgb5(after)) for x,y in zip(a,b)),'fade must be monotonic'
        assert all(color==(31,31,31) for color in rgb5(fades[-1])),'fade must meet the native white battle entrance'
        captures[25].resize((640,576),Image.Resampling.NEAREST).save(args.output/'finished.png')
        animation[0].save(args.output/'crimson-vs.gif',save_all=True,append_images=animation[1:],
                          duration=[round((i+1)*200/FPS)*10-round(i*200/FPS)*10
                                    for i in range(len(animation))],loop=0,optimize=False)
        sheet=Image.new('RGB',(640*4,576*2))
        for i,k in enumerate([2,5,8,10,12,16,21,25]):
            shot=captures[k].resize((640,576),Image.Resampling.NEAREST)
            sheet.paste(shot,(i%4*640,i//4*576))
        sheet.save(args.output/'formation-sheet.png')
        character_sheet=Image.new('RGB',(640*2,576*2))
        for i,(_,image) in enumerate(portraits):
            character_sheet.paste(image.resize((640,576),Image.Resampling.NEAREST),(i%2*640,i//2*576))
        character_sheet.save(args.output/'all-players.png')
        subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(),'-y','-loglevel','error',
                        '-ss',str(max(0,(start-movie_start-2)/FPS)),
                        '-i',str(args.output/'lance-vs-battle.mp4'),
                        '-c:v','libx264','-crf','17',
                        '-c:a','aac','-movflags','+faststart',str(args.output/'vs-reveal.mp4')],check=True)
        result=dict(rom=args.rom.name,sha256=hashlib.sha256(args.rom.read_bytes()).hexdigest(),
                    native_game_audio=True,buttons_only_during_recording=True,
                    selected_classes=positive,excluded_classes=negative,frames=seen,
                    all_four_player_portraits=True,disabled_paths=['options','ordinary','link','tower'],
                    all_players_mirrored_only_in_vs=True,complete_V_and_S_pure_white=True,
                    canonical_player_and_enemy_palettes=True,custom_name_case_and_symbols=True,
                    smooth_fade_steps=len(fades),formation_and_lock_sounds=True,
                    trainer_theme_selection=music_cases,music_starts_before_reveal=music_started,
                    music_continues_through_battle_entry=True,
                    both_portraits_match_source=True,reached_fight_menu=True,
                    preview_runs_through_opponent_sendout=True,final_hold_frames=90,
                    pinned_textbox_frames=len(border_frames),distinct_textbox_shapes=len(border_masks),
                    trainer_slide_preserved=True,
                    crystal_impact_shake=True,crystal_settled_after_frame=16,
                    movie_start=movie_start,sequence_start=start,sequence_end=end,video=record)
        (args.output/'results.json').write_text(json.dumps(result,indent=2)+'\n')
        print('PASS: all 26 VS frames, exact trainer portraits, boss selection and native battle handoff',flush=True)
        for stale in ['failure.png','failure.txt']:
            (args.output/stale).unlink(missing_ok=True)
    except Exception:
        s.image().save(args.output/'failure.png')
        (args.output/'failure.txt').write_text(tile_text(s))
        if s.movie: s.movie.finish()
        raise
    finally:
        s.close()


if __name__=='__main__':main()
