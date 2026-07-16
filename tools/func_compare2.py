import re
import importlib.util, io, contextlib
spec=importlib.util.spec_from_file_location('ac','outputs/anim_compare.py')
m=importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()): spec.loader.exec_module(m)
cc,pc=m.cc,m.pc
cct=open('Pokemon-Crimson-Crystal/engine/battle_anims/functions.asm').read()
pct=open('polishedcrystal-master/engine/battle_anims/functions.asm').read()
def jt(txt):
    part=txt.split('.Jumptable:',1)[1]
    out=[]
    for l in part.splitlines():
        mm=re.match(r'\s+dw (\w+)', l)
        if mm: out.append(mm.group(1))
        elif out and l.strip() and not l.strip().startswith(';'): break
    return out
ccjt=jt(cct); pcjt=jt(pct)
def get_routines(txt):
    labels=[(mm.start(),mm.group(1)) for mm in re.finditer(r'^(\w[\w.]*):', txt, re.M)]
    out={}; order=[]
    for i,(pos,name) in enumerate(labels):
        end=labels[i+1][0] if i+1<len(labels) else len(txt)
        out[name]=txt[pos:end]; order.append(name)
    return out,order
ccr,ccorder=get_routines(cct); pcr,pcorder=get_routines(pct)

def flatten(rmap, order, name, depth=0, seen=None):
    "inline fallthrough + unconditional JMP to top-level labels + anon_dw dw targets"
    if seen is None: seen=set()
    if name not in rmap or name in seen or depth>6: return []
    seen.add(name)
    lines=[]
    body=rmap[name]
    raw=[l.split(';')[0].rstrip() for l in body.splitlines()]
    raw=[l for l in raw if l.strip()]
    i=0; terminated=False
    dw_targets=[]
    for l in raw:
        s=l.strip()
        if s.endswith(':') :
            lines.append('L:'); continue
        mm=re.match(r'dw (\w+)$', s)
        if mm and mm.group(1) in rmap:
            dw_targets.append(mm.group(1)); lines.append('DW'); continue
        if mm: lines.append('DW'); continue
        mm=re.match(r'(?:jp|jr|jmp)\s+(\w+)$', s)
        if mm and mm.group(1) in rmap and not mm.group(1).startswith('BattleAnim_'):
            lines.append('TAIL'); lines+=flatten(rmap,order,mm.group(1),depth+1,seen); terminated=True; continue
        lines.append(s)
    # fallthrough
    code=[x for x in lines if x not in ('L:','DW')]
    if code and not re.match(r'(ret$|jp |jr [^,]+$|jmp |TAIL)', code[-1]):
        idx=order.index(name)
        if idx+1<len(order):
            lines.append('FT'); lines+=flatten(rmap,order,order[idx+1],depth+1,seen)
    for t in dw_targets:
        lines.append('DWT'); lines+=flatten(rmap,order,t,depth+1,seen)
    return lines

def norm(lines):
    out=[]
    for l in lines:
        l=l.strip()
        l=l.replace('BATTLEANIMSTRUCT_0F','V1').replace('BATTLEANIMSTRUCT_VAR1','V1')
        l=l.replace('BATTLEANIMSTRUCT_10','V2').replace('BATTLEANIMSTRUCT_VAR2','V2')
        l=l.replace('BATTLEANIMSTRUCT_ANON_JT_INDEX','JTI').replace('BATTLEANIMSTRUCT_JUMPTABLE_INDEX','JTI')
        l=re.sub(r'(?:call|farcall)\s+(?:BattleAnim_)?Sine$','SINE',l)
        l=re.sub(r'(?:call|farcall)\s+(?:BattleAnim_)?Cosine$','COS',l)
        l=re.sub(r'(?:call|jp|jr|jmp)\s+(?:Far)?DeinitBattleAnimation$','DEINIT',l)
        l=re.sub(r'(?:call|farcall)\s+(?:Far)?ReinitBattleAnimFrameset$','REINIT',l)
        l=re.sub(r'call BattleAnim_ScatterHorizontal$','SCATTER',l)
        l=re.sub(r'call Functioncd557$','SCATTER',l)
        l=re.sub(r'\bhPushOAM\b','-$80',l)
        l=re.sub(r'\bjmp\b','jp',l)
        l=re.sub(r'(jp|jr)\s+(c|nc|z|nz),\s*\.?\w+', r'J\2', l)
        l=re.sub(r'(jp|jr)\s+\.\w+','JMPL',l)
        l=re.sub(r'call BattleAnim_(AnonJumptable|IncAnonJumptableIndex)', r'\1', l)
        out.append(l)
    # drop 'ret' after DEINIT
    fin=[]
    for x in out:
        if x=='ret' and fin and fin[-1]=='DEINIT': continue
        fin.append(x)
    return fin

pairs={}
for name in set(cc.obj_names)&set(pc.obj_names):
    crow=cc.objs[cc.obj_names.index(name)]; prow=pc.objs[pc.obj_names.index(name)]
    ci=cc.func_names.index(crow[3]); pi=pc.func_names.index(prow[3])
    pairs.setdefault((ccjt[ci],pcjt[pi]),[]).append(name)
print(len(pairs),'unique func pairs')
bad=[]
for (cl,pl),objs in sorted(pairs.items()):
    a=norm(flatten(ccr,ccorder,cl)); b=norm(flatten(pcr,pcorder,pl))
    d=sum(1 for x,y in zip(a,b) if x!=y)+abs(len(a)-len(b))
    if d: bad.append((d,cl,pl,len(a),len(b),objs[:4]))
for d,cl,pl,la,lb,objs in sorted(bad,reverse=True):
    print(f'd={d:3d}  {cl} ({la})  vs  {pl} ({lb})  e.g. {objs}')
