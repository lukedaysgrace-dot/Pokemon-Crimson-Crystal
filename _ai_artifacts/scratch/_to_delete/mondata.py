import re, json, collections

def load(root='.'):
    species=[]
    for line in open(root+'/constants/pokemon_constants.asm'):
        if line.startswith('; Unown forms'): break
        m=re.match(r'\s*const\s+([A-Z_0-9]+)',line)
        if m: species.append(m.group(1))
    IDX={s:i+1 for i,s in enumerate(species)}
    inc=[re.match(r'INCLUDE "data/pokemon/base_stats/(\w+)\.asm"',l).group(1)
         for l in open(root+'/data/pokemon/base_stats.asm',encoding='utf-8')
         if l.startswith('INCLUDE "data/pokemon/base_stats/')]
    meta={}
    for sp,fn in zip(species,inc):
        t=open(root+'/data/pokemon/base_stats/%s.asm'%fn,encoding='utf-8').read()
        st=[int(x) for x in re.search(r'db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)',t).groups()]
        ty=re.search(r'db (\w+), (\w+) ; type',t).groups()
        meta[sp]={'bst':sum(st),'hp':st[0],'atk':st[1],'def':st[2],'spe':st[3],'sat':st[4],'sdf':st[5],
                  'types':list(dict.fromkeys(ty))}
    # label <-> species
    GROUPS=[]
    for l in open(root+'/data/pokemon/evos_attacks.asm',encoding='utf-8'):
        m=re.match(r'\s*indirect_entries\s+([A-Z_0-9]+),\s*(EvosAttacksPointers\w*)',l)
        if m: GROUPS.append((m.group(1),m.group(2)))
    files=[root+'/data/pokemon/evos_attacks_kanto.asm',root+'/data/pokemon/evos_attacks_johto.asm',
           root+'/data/pokemon/evos_attacks_clones.asm']
    listing={}
    for f in files:
        cur=None
        for line in open(f,encoding='utf-8'):
            m=re.match(r'(EvosAttacksPointers\w*)::',line)
            if m: cur=m.group(1); listing.setdefault(cur,[]); continue
            if cur:
                m=re.match(r'\s*dw\s+(\w+EvosAttacks)\s*$',line)
                if m: listing[cur].append(m.group(1))
                elif line.strip() and not line.strip().startswith(';'): cur=None
    lab2sp={}; lo=1
    for maxn,ptr in GROUPS:
        hi=len(species) if maxn=='NUM_POKEMON' else IDX[maxn]
        for k,sp in enumerate(species[lo-1:hi]): lab2sp[listing[ptr][k]]=sp
        lo=hi+1
    # evolutions + learnsets
    evo=collections.defaultdict(list); learn=collections.defaultdict(list)
    for f in files:
        lab=None; phase=0
        for line in open(f,encoding='utf-8'):
            m=re.match(r'^(\w+EvosAttacks):',line)
            if m: lab=m.group(1); phase=0; continue
            if lab is None: continue
            s=line.strip()
            if s.startswith('db 0'): phase+=1; continue
            if phase==0:
                m=re.match(r'dbbw (EVOLVE_\w+), ([A-Z_0-9]+), ([A-Z_0-9]+)',s)
                if m: evo[lab2sp[lab]].append((m.group(1),m.group(2),m.group(3)))
                m=re.match(r'dbbbw (EVOLVE_STAT), (\d+), (\w+), ([A-Z_0-9]+)',s)
                if m: evo[lab2sp[lab]].append((m.group(1),m.group(2),m.group(4)))
            elif phase==1:
                m=re.match(r'dbw (\d+), ([A-Z_0-9]+)',s)
                if m: learn[lab2sp[lab]].append((int(m.group(1)),m.group(2)))
    # moves
    moves={}
    names=[]
    for line in open(root+'/constants/move_constants.asm'):
        m=re.match(r'\s*const\s+([A-Z_0-9]+)',line)
        if m and not m.group(1).startswith(('ANIM_','BATTLEANIM_')): names.append(m.group(1))
    for line in open(root+'/data/moves/moves.asm',encoding='utf-8'):
        m=re.match(r'\s*move ([A-Z_0-9]+),\s*(\d+),\s*([A-Z_0-9]+),\s*(CATEGORIZE_[A-Z]+),\s*(\d+),\s*(\d+),\s*(\d+);([A-Z_0-9]+)',line)
        if m:
            moves[m.group(8)]={'effect':m.group(1),'power':int(m.group(2)),'type':m.group(3),
                               'cat':m.group(4).replace('CATEGORIZE_',''),'acc':int(m.group(5)),
                               'pp':int(m.group(6)),'chance':int(m.group(7))}
    # min level a species can exist at (via level evolutions)
    pre={}
    for a,lst in evo.items():
        for meth,par,b in lst: pre.setdefault(b,[]).append((a,meth,par))
    minlv={}
    def calc(sp,seen=()):
        if sp in minlv: return minlv[sp]
        if sp in seen: return 5
        if sp not in pre: minlv[sp]=5; return 5
        best=100
        for a,meth,par in pre[sp]:
            base=calc(a,seen+(sp,))
            if meth in ('EVOLVE_LEVEL','EVOLVE_LEVEL_MALE','EVOLVE_LEVEL_FEMALE'):
                best=min(best,max(base+1,int(par)))
            elif meth=='EVOLVE_STAT': best=min(best,max(base+1,int(par)))
            else: best=min(best,max(base+8,18))
        minlv[sp]=best; return best
    for sp in species: calc(sp)
    evolves_at={}
    for sp,lst in evo.items():
        lv=[int(p) for m_,p,_ in lst if m_ in ('EVOLVE_LEVEL','EVOLVE_LEVEL_MALE','EVOLVE_LEVEL_FEMALE','EVOLVE_STAT')]
        if lv: evolves_at[sp]=min(lv)
    return dict(species=species, IDX=IDX, meta=meta, evo=dict(evo), learn=dict(learn),
                moves=moves, minlv=minlv, evolves_at=evolves_at, has_evo=set(evo),
                lab2sp=lab2sp, sp2lab={v:k for k,v in lab2sp.items()})
