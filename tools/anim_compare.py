import re, sys, os
CC='Pokemon-Crimson-Crystal'; PC='polishedcrystal-master'
ROOT='/sessions/bold-gracious-lovelace/mnt'

def rd(p): return open(os.path.join(ROOT,p),encoding='utf-8',errors='replace').read()

def strip_comment(l):
    out=[]
    for ch in l:
        if ch==';': break
        out.append(ch)
    return ''.join(out).rstrip()


def norm_attr(a):
    a=a.strip()
    parts=[x.strip() for x in a.split('|')]
    out=set()
    for x in parts:
        x=x.replace('B_OAM_','OAM_').replace('OAM_X_FLIP','XF').replace('OAM_XFLIP','XF').replace('X_FLIP','XF')
        x=x.replace('OAM_Y_FLIP','YF').replace('OAM_YFLIP','YF').replace('Y_FLIP','YF')
        if x in ('$0','0','$00',''): continue
        out.add(x)
    return frozenset(out)

def norm_dsprite(t):
    t=list(t)
    if len(t)>=6: t[5]=norm_attr(t[5])
    if len(t)>=7: t[5]=t[5]|norm_attr(t[6]); t=t[:6]
    return tuple(t)

def parse_num(s):
    s=s.strip()
    try:
        if s.startswith('$'): return int(s[1:],16)
        if s.startswith('%'): return int(s[1:],2)
        if re.fullmatch(r'-?\d+', s): return int(s)
    except: pass
    return s  # symbolic

def parse_scripts(files):
    scripts={}; cur=None; order=[]
    for f in files:
        for raw in rd(f).splitlines():
            l=strip_comment(raw)
            if not l.strip(): continue
            m=re.match(r'^(\w+):+\s*$', l)
            if m:
                cur=m.group(1); scripts[cur]=[]; order.append(cur); continue
            m=re.match(r'^(\.\w+):?\s*$', l)
            if m and cur:
                scripts[cur].append(('LBL', m.group(1))); continue
            m=re.match(r'^\s+(\w+)\s*(.*)$', l)
            if m and cur:
                cmd=m.group(1); rest=m.group(2).strip()
                if cmd in ('db','dw','dn','ENDM','MACRO','endc','endr','shift','rept') or cmd.startswith('if'): continue
                args=[a.strip() for a in rest.split(',')] if rest else []
                scripts[cur].append((cmd,args))
    return scripts, order

def const_list(repo, prefix):
    txt=rd(f'{repo}/constants/battle_anim_constants.asm')
    return re.findall(rf'\tconst ({prefix}_\w+)', txt)

def parse_objects(repo):
    txt=rd(f'{repo}/data/battle_anims/objects.asm')
    rows=[]
    for l in txt.splitlines():
        s=strip_comment(l)
        m=re.match(r'^\s+battleanimobj\s+(.*)$', s)
        if m: rows.append([a.strip() for a in m.group(1).split(',')])
    return rows

def parse_framesets(repo):
    txt=rd(f'{repo}/data/battle_anims/framesets.asm')
    order=[]; bodies={}; cur=None
    for l in txt.splitlines():
        s=strip_comment(l)
        m=re.match(r'^(\.\w+):', s)
        if m: cur=m.group(1); bodies[cur]=[]; continue
        m=re.match(r'^\s+dw (\.\w+)', s)
        if m and cur is None: order.append(m.group(1)); continue
        if cur:
            m=re.match(r'^\s+(\w+)\s*(.*)$', s)
            if m and m.group(1) not in ('dw','db'):
                args=[a.strip() for a in m.group(2).split(',')] if m.group(2).strip() else []
                bodies[cur].append((m.group(1),args))
    return order, bodies

def parse_oam(repo):
    txt=rd(f'{repo}/data/battle_anims/oam.asm')
    entries=[]; datalbl={}; cur=None
    for l in txt.splitlines():
        s=strip_comment(l)
        m=re.match(r'^\s+(?:dbbw|battleanimoam)\s+(.*)$', s)
        if m:
            a=[x.strip() for x in m.group(1).split(',')]
            entries.append((parse_num(a[0]), parse_num(a[1]), a[2]))
            continue
        m=re.match(r'^(\.\w+):', s)
        if m: cur=m.group(1); datalbl[cur]=[]; continue
        m=re.match(r'^\s+(dsprite|dbsprite)\s+(.*)$', s)
        if m and cur:
            kind=m.group(1)
            t=[x.strip() for x in m.group(2).split(',')]
            if kind=='dbsprite' and len(t)>=6:
                t=[t[1],t[3],t[0],t[2]]+t[4:]
            datalbl[cur].append(norm_dsprite(tuple(t)))
    return entries, datalbl

def parse_gfx(repo):
    if repo==CC:
        txt=rd(f'{repo}/data/battle_anims/object_gfx.asm')
        rows=re.findall(r'^\s+anim_obj_gfx\s+(\d+),\s*(\w+)', txt, re.M)
        inc=rd(f'{repo}/gfx/battle_anims.asm')
    else:
        txt=rd(f'{repo}/data/battle_anims/object_gfx.asm')
        rows=[(a,b or '') for a,b in re.findall(r'^\s+battleanimgfx\s+(\d+)(?:,\s*(\w+))?', txt, re.M)]
        inc=rd(f'{repo}/gfx/misc.asm')
    incmap=dict(re.findall(r'^(\w+)::?\s+INCBIN "([^"]+)"', inc, re.M))
    out=[]
    for tiles,lbl in rows:
        png=incmap.get(lbl,'')
        png=re.sub(r'\.2bpp\.lzp?$','',png).split('/')[-1]
        out.append((int(tiles), lbl or 'NULL', png))
    return out

def png_hash(repo, base):
    import hashlib
    from PIL import Image
    p=os.path.join(ROOT,repo,'gfx/battle_anims',base+'.png')
    if not os.path.exists(p): return 'MISSING:'+base
    im=Image.open(p).convert('L')
    return hashlib.md5(im.tobytes()).hexdigest()[:10]

class Repo:
    def __init__(s, name, scriptfiles, ptrfile):
        s.name=name
        s.scripts,s.order=parse_scripts(scriptfiles)
        s.obj_names=const_list(name,'ANIM_OBJ')
        s.objs=parse_objects(name)
        s.fs_names=const_list(name,'BATTLEANIMFRAMESET')
        s.fs_order, s.fs_bodies = parse_framesets(name)
        s.oamset_names=const_list(name,'BATTLEANIMOAMSET')
        s.oam_entries, s.oam_data = parse_oam(name)
        s.gfx_names=const_list(name,'ANIM_GFX')
        s.gfx=parse_gfx(name)
        s.func_names=const_list(name,'BATTLEANIMFUNC')
        s.bg_names=const_list(name,'ANIM_BG')
        txt=rd(ptrfile)
        part=txt.split('BattleAnimations::',1)[1]
        ptrs=[]; skip=False
        for l in part.splitlines():
            ls=l.strip()
            if ls.startswith('if '): skip=False; continue
            if ls.startswith('else'): skip=True; continue
            if ls.startswith('endc'): skip=False; continue
            if skip: continue
            m=re.match(r'^\s+(?:banim|fardw)\s+(\w+)', l)
            if m: ptrs.append(m.group(1))
        s.ptrs=ptrs
        s.pngcache={}
    def png(s, base):
        if base not in s.pngcache: s.pngcache[base]=png_hash(s.name, base)
        return s.pngcache[base]
    def resolve_frameset(s, fsname):
        try: i=s.fs_names.index(fsname)
        except ValueError: return 'BADFS:'+fsname
        body=s.fs_bodies.get(s.fs_order[i], []) if i<len(s.fs_order) else None
        if body is None: return 'NOENTRY:'+fsname
        out=[]
        for cmd,args in body:
            cmdn={'oamframe':'frame','battleoamframe':'frame','oamdelanim':'del','battleoamdelete':'del',
                  'oamdowait':'wait','battleoamwait':'wait','oamrestart':'restart','battleoamrestart':'restart',
                  'oamendanim':'end','battleoamend':'end'}.get(cmd,cmd)
            if cmdn=='frame':
                oamname=args[0]
                try: oi=s.oamset_names.index(oamname)
                except ValueError: out.append(('frame','BADOAM:'+oamname)); continue
                vt,ln,dl=s.oam_entries[oi]
                flips=frozenset().union(*[norm_attr(a) for a in args[2:]]) if len(args)>2 else frozenset()
                out.append(('frame', vt, tuple(s.oam_data.get(dl,[])), parse_num(args[1]), flips))
            else:
                out.append((cmdn, tuple(parse_num(a) for a in args)))
        return tuple(out)
    def resolve_obj(s, objname):
        try: i=s.obj_names.index(objname)
        except ValueError: return 'BADOBJ:'+objname
        flags,yfix,fs,func,pal,gfx = s.objs[i]
        try:
            gi=s.gfx_names.index(gfx)+1; g=s.gfx[gi]
            png=g[2] if g[2] else ('pokeball' if 'POKE_BALL' in gfx else '')
            gsig=(g[0], s.png(png) if png else 'null', png)
        except ValueError: gsig=('BADGFX',gfx)
        fn=func.replace('BATTLEANIMFUNC_','')
        fixup={'SPRIAL_DESCENT':'SPIRAL_DESCENT','MOON_RISE':'MOON'}
        if re.fullmatch(r'[0-9A-F]{2}', fn): fsig=('idx', int(fn,16))
        else: fsig=('name', fixup.get(fn,fn))
        flags=flags.replace('PRIORITY','OAM_PRIO').replace('X_FLIP','OAM_XFLIP').replace('Y_FLIP','OAM_YFLIP').replace('OAM_OAM','OAM_')
        flags='|'.join(sorted(x.strip() for x in flags.split('|')))
        return (flags, parse_num(yfix), s.resolve_frameset(fs), fsig, pal, gsig, objname)

cc=Repo(CC, [f'{CC}/data/moves/animations.asm',f'{CC}/data/moves/animations2.asm',f'{CC}/data/moves/animations3.asm',f'{CC}/data/moves/animations4.asm'], f'{CC}/data/moves/animations.asm')
pc=Repo(PC, [f'{PC}/data/moves/animations.asm'], f'{PC}/data/moves/animation_pointers.asm')

def moves(repo):
    txt=rd(f'{repo}/constants/move_constants.asm')
    val=0; out={}
    for l in txt.splitlines():
        l=strip_comment(l).strip()
        m=re.match(r'const_def\s*(\$?\w+)?', l)
        if m and l.startswith('const_def'):
            val=parse_num(m.group(1)) if m.group(1) else 0
            if not isinstance(val,int): val=0
            continue
        m=re.match(r'const_next\s+(\$?\w+)', l)
        if m: val=parse_num(m.group(1)); continue
        m=re.match(r'const_skip\s*(\d+)?', l)
        if m and l.startswith('const_skip'): val+=int(m.group(1) or 1); continue
        m=re.match(r'const\s+(\w+)$', l)
        if m: out[m.group(1)]=val; val+=1
    return out
ccm=moves(CC); pcm=moves(PC)

CMDMAP={'anim_if_param_equal':'anim_jumpif','anim_if_param_and':'anim_jumpand','anim_if_var_equal':'anim_jumpvar','anim_keepsprites':'anim_clearsprites'}

VERIFIED_FUNC={70:'CURSE',71:'PERISH_SONG',72:'RAPID_SPIN',74:'RAIN_SANDSTORM',77:'ANCIENT_POWER',78:'ROCK_SMASH'}
def func_equiv(a,b):
    if a[0]=='idx' and b[0]=='name' and VERIFIED_FUNC.get(a[1])==b[1]: return True
    if b[0]=='idx':
        bname=pc.func_names[b[1]].replace('BATTLEANIMFUNC_','')
    else: bname=b[1]
    if a[0]=='idx':
        return a[1]<len(pc.func_names) and pc.func_names[a[1]].replace('BATTLEANIMFUNC_','')==bname
    return a[1]==bname

def norm_script(repo, label, calls=None):
    if calls is None: calls=[]
    if label not in repo.scripts: return None
    body=list(repo.scripts[label])
    # fallthrough into subsequent labels until terminator
    li=repo.order.index(label)
    def terminated(b):
        for it in reversed(b):
            if it[0]=='LBL': continue
            return it[0] in ('anim_ret','anim_jump')
        return False
    while not terminated(body) and li+1<len(repo.order):
        li+=1
        body.append(('LBL','.ft_'+repo.order[li]))
        body.extend(repo.scripts[repo.order[li]])
    out=[]; lblidx={}; n=0
    for it in body:
        if it[0]=='LBL': lblidx[it[1]]=n
        else: n+=1
    lblidx={}; n=0
    for it in body:
        if it[0]=='LBL': lblidx[it[1]]=n
        else: n+=1
    for it in body:
        if it[0]=='LBL': continue
        cmd,args=it
        cmd=CMDMAP.get(cmd,cmd)
        if cmd=='anim_obj':
            if len(args)>4:
                args=[args[0], str(parse_num(args[1])*8+parse_num(args[2])), str(parse_num(args[3])*8+parse_num(args[4])), args[5]]
            na=[('OBJ',repo.resolve_obj(args[0]),args[0]), parse_num(args[1]), parse_num(args[2]), parse_num(args[3])]
        else:
            na=[]
            for a in args:
                if a.startswith('.') and a in lblidx: na.append(('L',lblidx[a]))
                elif re.match(r'^BattleAnim', a): na.append(re.sub(r'(_PC[34P]?|_B)(?=$|\.)','',a))
                else: na.append(parse_num(a))
        if cmd in ('anim_call','anim_jump') and args and not args[0].startswith('.'):
            tgt=args[0]
            if '.' not in tgt and tgt in repo.scripts: calls.append((tgt, re.sub(r'(_PC[34P]?|_B)$','',tgt)))
        out.append((cmd,tuple(na)))
    return out

def cmp_stream(sa, sb):
    diffs=[]
    if sa is None: return ['CC script missing']
    if sb is None: return ['PC script missing']
    for i,(a,b) in enumerate(zip(sa,sb)):
        if a[0]!=b[0]:
            diffs.append(f'@{i}: cmd {a[0]}{a[1]} vs {b[0]}{b[1]}'); break
        if a[0]=='anim_obj':
            (ta,oa,na_),(tb,ob,nb_)=a[1][0],b[1][0]
            if a[1][1:]!=b[1][1:]:
                diffs.append(f'@{i}: anim_obj coords/param {a[1][1:]} vs {b[1][1:]} ({na_} vs {nb_})')
            if isinstance(oa,str) or isinstance(ob,str):
                if oa!=ob: diffs.append(f'@{i}: obj resolve {oa} vs {ob}')
                continue
            if oa[0]!=ob[0] or oa[1]!=ob[1]: diffs.append(f'@{i}: obj flags/yfix {oa[:2]} vs {ob[:2]} ({na_} vs {nb_})')
            if oa[2]!=ob[2]:
                fa,fb=oa[2],ob[2]
                if isinstance(fa,str) or isinstance(fb,str):
                    diffs.append(f'@{i}: obj FRAMESET {fa if isinstance(fa,str) else "ok"} vs {fb if isinstance(fb,str) else "ok"} ({na_} vs {nb_})')
                else:
                    det=''
                    for k,(x,y) in enumerate(zip(fa,fb)):
                        if x!=y: det=f'frame{k}: {x!r} vs {y!r}'; break
                    else: det=f'len {len(fa)} vs {len(fb)}'
                    diffs.append(f'@{i}: obj FRAMESET ({na_} vs {nb_}) {det}')
            if not func_equiv(oa[3],ob[3]): diffs.append(f'@{i}: obj FUNC {oa[3]} vs {ob[3]} ({na_} vs {nb_})')
            if oa[4]!=ob[4]: diffs.append(f'@{i}: obj pal {oa[4]} vs {ob[4]} ({na_} vs {nb_})')
            if oa[5][:2]!=ob[5][:2]: diffs.append(f'@{i}: obj GFX {oa[5]} vs {ob[5]} ({na_} vs {nb_})')
        elif a[0]=='anim_bgeffect':
            if a[1][1:]!=b[1][1:]: diffs.append(f'@{i}: bgeffect args {a[1]} vs {b[1]}')
            elif a[1][0]!=b[1][0]: diffs.append(f'@{i}: BGPAIR {a[1][0]} | {b[1][0]}')
        else:
            if a[1]!=b[1]: diffs.append(f'@{i}: {a[0]} args {a[1]} vs {b[1]}')
    if len(sa)!=len(sb): diffs.append(f'length {len(sa)} vs {len(sb)}')
    return diffs

common=[m for m in ccm if m in pcm]
report={}
compared=0
seen=set()
def compare_pair(name, cl, pl):
    global compared
    if (cl,pl) in seen: return
    seen.add((cl,pl))
    compared+=1
    ccalls=[]; pcalls=[]
    d=cmp_stream(norm_script(cc,cl,ccalls), norm_script(pc,pl,pcalls))
    if d: report[name]=(cl,pl,d)
    # pair up sub targets by normalized name
    pmap={n:raw for raw,n in pcalls}
    for raw,n in ccalls:
        if n in pmap:
            compare_pair(f'{name}>{n}', raw, pmap[n])
for mv in common:
    ci=ccm[mv]; pi=pcm[mv]
    if ci>=len(cc.ptrs) or pi>=len(pc.ptrs): continue
    compare_pair(mv, cc.ptrs[ci], pc.ptrs[pi])

import json
print(f"moves compared: {compared}, differing: {len(report)}")
with open(os.path.join(ROOT,'outputs','anim_report.txt'),'w') as f:
    for mv,(cl,pl,d) in report.items():
        f.write(f"\n== {mv}  ({cl} vs {pl})\n")
        for x in d: f.write(f"    {x}\n")
print("report written")
