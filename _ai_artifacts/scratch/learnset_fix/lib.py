import re, os, collections
R = os.environ.get('REPO', '.')
def P(p): return os.path.join(R, p)
def rd(p): return open(P(p), encoding='utf-8').read()
def wr(p, s): open(P(p), 'w', encoding='utf-8', newline='\n').write(s)

# species order
order = []; inm = False
for l in rd('constants/pokemon_constants.asm').splitlines():
    l = l.split(';')[0].strip()
    if l.startswith('const_def 1') and not inm: inm = True; continue
    if inm and l.startswith('NUM_POKEMON'): break
    m = re.match(r'const\s+(\w+)', l)
    if inm and m: order.append(m.group(1))
order = [c for c in order if c != 'EGG']
assert len(order) == 495, len(order)

# valid moves
MOVES = set()
for l in rd('constants/move_constants.asm').splitlines():
    m = re.match(r'\s*const\s+(\w+)', l)
    if m: MOVES.add(m.group(1))
TMS = []
for l in rd('constants/item_constants.asm').splitlines():
    m = re.match(r'\s*add_(tm|hm|mt)\s+(\w+)', l)
    if m: TMS.append(m.group(2))
TMSET = set(TMS)

# base stats files
BS = {}
incs = re.findall(r'INCLUDE\s+"(data/pokemon/base_stats/[^"]+)"', rd('data/pokemon/base_stats.asm'))
assert len(incs) == 495, len(incs)
for c, f in zip(order, incs): BS[c] = f

def read_bs(c):
    s = rd(BS[c])
    m = re.search(r'^(\s*tmhm)([^\n]*)$', s, re.M)
    tms = [x.strip() for x in m.group(2).split(',') if x.strip()] if m else []
    g = re.search(r'db\s+(GENDER_\w+)', s).group(1)
    eg = re.search(r'dn\s+(EGG_\w+)\s*,\s*(EGG_\w+)', s)
    st = re.search(r'db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\n\s*;\s*hp', s)
    ty = re.search(r'db\s+(\w+)\s*,\s*(\w+)\s*;\s*type', s)
    return dict(tms=tms, gender=g, egg=(eg.group(1), eg.group(2)), stats=tuple(int(x) for x in st.groups()), types=(ty.group(1), ty.group(2)))

def write_tms(c, tms):
    s = rd(BS[c])
    ordered = [x for x in TMS if x in set(tms)]
    new = '\ttmhm ' + ', '.join(ordered) if ordered else '\ttmhm'
    s2, n = re.subn(r'^\s*tmhm[^\n]*$', new, s, count=1, flags=re.M)
    assert n == 1, c
    wr(BS[c], s2)

# evos/attacks
EVO_FILES = ['data/pokemon/evos_attacks_kanto.asm', 'data/pokemon/evos_attacks_johto.asm', 'data/pokemon/evos_attacks_clones.asm']
TABLE_ORDER = ['EvosAttacksPointers1', 'EvosAttacksPointers1C', 'EvosAttacksPointers1B', 'EvosAttacksPointers2', 'EvosAttacksPointers2D', 'EvosAttacksPointers2E', 'EvosAttacksPointers2B', 'EvosAttacksPointers2C']
def evo_labels():
    tables = {}
    for f in EVO_FILES:
        lines = rd(f).splitlines()
        cur = None
        for l in lines:
            m = re.match(r'^(EvosAttacksPointers\w*)::?', l)
            if m: cur = m.group(1); tables[cur] = []; continue
            if cur:
                m = re.match(r'\s*dw\s+(\w+)', l)
                if m: tables[cur].append(m.group(1))
                elif l.strip() == '' or l.strip().startswith(';'): 
                    if tables[cur] and l.strip()=='' : cur = None
                else: cur = None
    seq = []
    for t in TABLE_ORDER: seq += tables[t]
    assert len(seq) == 495, (len(seq), {k: len(v) for k, v in tables.items()})
    return dict(zip(order, seq))
LABEL = evo_labels()

class Evo:
    def __init__(self):
        self.files = {f: rd(f).split('\n') for f in EVO_FILES}
        self.loc = {}
        for f, lines in self.files.items():
            for i, l in enumerate(lines):
                m = re.match(r'^(\w+EvosAttacks):', l)
                if m: self.loc[m.group(1)] = (f, i)
    def block(self, c):
        f, i = self.loc[LABEL[c]]; lines = self.files[f]
        j = i + 1
        while not re.match(r'\s*db 0', lines[j]): j += 1
        s = j + 1; e = s
        while not re.match(r'\s*db 0', lines[e]): e += 1
        return f, s, e
    def get(self, c):
        f, s, e = self.block(c)
        out = []
        for l in self.files[f][s:e]:
            m = re.match(r'\s*dbw\s+(\d+)\s*,\s*(\w+)', l)
            if m: out.append((int(m.group(1)), m.group(2)))
        return out
    def set(self, c, ls):
        for lv, mv in ls: assert mv in MOVES, (c, mv)
        ls = sorted(ls, key=lambda x: x[0])  # stable
        f, s, e = self.block(c)
        self.files[f][s:e] = [f'\tdbw {lv}, {mv}' for lv, mv in ls]
        # relocate following labels
        self.loc = {}
        for ff, lines in self.files.items():
            for i, l in enumerate(lines):
                m = re.match(r'^(\w+EvosAttacks):', l)
                if m: self.loc[m.group(1)] = (ff, i)
    def evos(self, c):
        f, i = self.loc[LABEL[c]]; lines = self.files[f]; out = []
        j = i + 1
        while not re.match(r'\s*db 0', lines[j]):
            m = re.match(r'\s*db+w\s+(EVOLVE_\w+)\s*,\s*(.*)$', lines[j])
            if m:
                parts = [x.strip() for x in m.group(2).split(';')[0].split(',')]
                out.append((m.group(1), parts[:-1], parts[-1]))
            j += 1
        return out
    def save(self):
        for f, lines in self.files.items(): wr(f, '\n'.join(lines))
