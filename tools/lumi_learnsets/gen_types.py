#!/usr/bin/env python3
"""
gen_types.py  --  Copy Pokemon Luminescent Platinum 3.0 (Re:Illuminated)
TYPES onto this ROM's Pokemon.

For every file in data/pokemon/base_stats/*.asm it rewrites the
    db TYPE1, TYPE2 ; type
line to match Luminescent's typing for that species/form. Everything else in
the file (stats, abilities, TM list, etc.) is left untouched.

Resolution (same idea as gen_learnsets.py):
  * Species / regional forms that exist in Luminescent -> Luminescent's types
    (from PersonalTable type1/type2, named via english_ss_typename.json).
  * Anything not in Luminescent (rare) -> PokeAPI types.
  * Fakemon (Watu, Orstryx, Mesmeria) -> left unchanged.
  * Bloodmoon (*_bm) forms reuse their base species' typing.

Usage (repo root, WSL):
    python3 tools/lumi_learnsets/gen_types.py --dry-run
    python3 tools/lumi_learnsets/gen_types.py
    python3 tools/lumi_learnsets/gen_types.py --no-net

Shares the download cache with gen_learnsets.py. Standard library only.
"""

import argparse
import glob
import json
import os
import re
import time
import urllib.request
import urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
CACHE = os.path.join(HERE, "cache")
os.makedirs(CACHE, exist_ok=True)

BASE_STATS_DIR = os.path.join(REPO, "data", "pokemon", "base_stats")
TYPE_CONSTANTS = os.path.join(REPO, "constants", "type_constants.asm")

LUMI_VER = "gamedata3.0"
LUMI_BASE = "https://raw.githubusercontent.com/TeamLumi/luminescent-team/main/__gamedata/" + LUMI_VER
POKEAPI = "https://pokeapi.co/api/v2"
NO_NET = False

# --------------------------------------------------------------------------
# Networking / cache (same behaviour as gen_learnsets.py)
# --------------------------------------------------------------------------
def fetch(url, cache_name):
    path = os.path.join(CACHE, cache_name)
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.loads(f.read())
    if NO_NET:
        raise RuntimeError(f"--no-net set but {cache_name} is not cached ({url})")
    last = None
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "SupremeSilver-type-gen"})
            with urllib.request.urlopen(req, timeout=30) as r:
                data = r.read().decode("utf-8")
            with open(path, "w", encoding="utf-8") as f:
                f.write(data)
            return json.loads(data)
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
            last = e
            time.sleep(1.5 * (attempt + 1))
    raise RuntimeError(f"Failed to fetch {url}: {last}")

def pokeapi(slug):
    slug = slug.lower()
    path = os.path.join(CACHE, f"pokeapi_{slug}.json")
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    if NO_NET:
        return None
    try:
        req = urllib.request.Request(f"{POKEAPI}/pokemon/{slug}",
                                     headers={"User-Agent": "SupremeSilver-type-gen"})
        with urllib.request.urlopen(req, timeout=30) as r:
            data = r.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        raise
    with open(path, "w", encoding="utf-8") as f:
        f.write(data)
    time.sleep(0.15)
    return json.loads(data)

# --------------------------------------------------------------------------
# Type name -> ROM type constant
# --------------------------------------------------------------------------
TYPE_MAP = {
    "normal": "NORMAL", "fighting": "FIGHTING", "flying": "FLYING",
    "poison": "POISON", "ground": "GROUND", "rock": "ROCK", "bug": "BUG",
    "ghost": "GHOST", "steel": "STEEL", "fire": "FIRE", "water": "WATER",
    "grass": "GRASS", "electric": "ELECTRIC", "psychic": "PSYCHIC",
    "ice": "ICE", "dragon": "DRAGON", "dark": "DARK", "fairy": "FAIRY",
}

def load_rom_types():
    types = set()
    with open(TYPE_CONSTANTS, "r", encoding="utf-8") as f:
        for line in f:
            m = re.match(r"\s*const\s+([A-Z0-9_]+)", line)
            if m:
                types.add(m.group(1))
    return types

# --------------------------------------------------------------------------
# Name / form helpers (same normalization rules as gen_learnsets.py)
# --------------------------------------------------------------------------
def norm_name(s):
    s = s.replace("♀", "f").replace("♂", "m")  # female / male signs
    return re.sub(r"[^a-z0-9]", "", s.lower())

LUMI_REGION_KEYWORDS = {
    "alola": "alola", "alolan": "alola", "galar": "galar", "galarian": "galar",
    "hisui": "hisui", "hisuian": "hisui", "paldea": "paldea", "paldean": "paldea",
}

def classify_region(form_name_str):
    low = form_name_str.lower()
    for kw, tag in LUMI_REGION_KEYWORDS.items():
        if kw in low:
            return tag
    return None

# base_stats filename suffix -> (lumi region tag, pokeapi form suffix)
FILE_REGION = [
    ("_paldean_fire",  ("paldea", "paldea-blaze-breed")),
    ("_paldean_water", ("paldea", "paldea-aqua-breed")),
    ("_paldean",       ("paldea", "paldea")),
    ("_alolan",        ("alola",  "alola")),
    ("_galarian",      ("galar",  "galar")),
    ("_hisuian",       ("hisui",  "hisui")),
]

LUMI_NAME_ALIAS = {"drunsparce": "dudunsparce"}

# Species whose typing must be LEFT ALONE (kept as they are in this ROM),
# even though Luminescent has different types for them.
EXCLUDE_TYPES = {
    "sirfetchd",          # keep Fighting/Flying (Luminescent has pure Fighting)
    "aron", "lairon", "aggron",  # keep the Aggron line as-is
}

# normalized base-species name -> PokeAPI slug (only when needed / fakemon=None)
SPECIAL_SLUG = {
    "nidoranf": "nidoran-f", "nidoranm": "nidoran-m", "mrmime": "mr-mime",
    "mrrime": "mr-rime", "mimejr": "mime-jr", "hooh": "ho-oh",
    "porygonz": "porygon-z", "typenull": "type-null", "sirfetchd": "sirfetchd",
    "farfetchd": "farfetchd", "drunsparce": "dudunsparce-two-segment",
    "orstryx": None, "watu": None, "mesmeria": None,
}

def parse_stem(stem):
    """base_stats filename stem -> (species_norm, tag, api_suffix, is_bm)."""
    s = stem
    if s.endswith("_clone"):
        s = s[:-6]
    for suf, (tag, api) in FILE_REGION:
        if s.endswith(suf):
            return norm_name(s[: -len(suf)].replace("_", "")), tag, api, False
    if s.endswith("_bm"):
        return norm_name(s[:-3].replace("_", "")), None, None, True
    return norm_name(s.replace("_", "")), None, None, False

# --------------------------------------------------------------------------
# Luminescent type data
# --------------------------------------------------------------------------
class LumiTypes:
    def __init__(self):
        self.type1 = {}          # dexId -> typeId
        self.type2 = {}          # dexId -> typeId
        self.typename = []       # typeId -> "Name"
        self.name_to_monsno = {} # normalized species name -> monsno
        self.form_map = {}       # monsno -> [dexId,...] (valid, in order)
        self.form_index = {}     # (monsno, region_tag) -> dexId

    def load(self):
        personal = fetch(f"{LUMI_BASE}/PersonalTable.json", "lumi_personal.json")
        monsname = fetch(f"{LUMI_BASE}/english_ss_monsname.json", "lumi_monsname.json")
        formname = fetch(f"{LUMI_BASE}/english_ss_zkn_form.json", "lumi_formname.json")
        tn = fetch(f"{LUMI_BASE}/english_ss_typename.json", "lumi_typename.json")

        self.typename = []
        for entry in tn["labelDataArray"]:
            wda = entry.get("wordDataArray") or []
            self.typename.append(wda[0]["str"] if wda else "")

        for monsno, entry in enumerate(monsname["labelDataArray"]):
            wda = entry.get("wordDataArray") or []
            if wda and wda[0].get("str"):
                self.name_to_monsno[norm_name(wda[0]["str"])] = monsno

        for p in personal["Personal"]:
            dexId = p["id"]
            self.type1[dexId] = p["type1"]
            self.type2[dexId] = p["type2"]
            if p.get("valid_flag", 1) == 1:
                self.form_map.setdefault(p["monsno"], []).append(dexId)

        for monsno, dexIds in self.form_map.items():
            for dexId in dexIds:
                fstr = ""
                if dexId < len(formname["labelDataArray"]):
                    wda = formname["labelDataArray"][dexId].get("wordDataArray") or []
                    if wda:
                        fstr = wda[0].get("str", "")
                tag = classify_region(fstr)
                if tag:
                    self.form_index[(monsno, tag)] = dexId

    def type_consts(self, dexId, rom_types, report):
        t1 = self.typename[self.type1[dexId]].lower() if self.type1.get(dexId) is not None else ""
        t2 = self.typename[self.type2[dexId]].lower() if self.type2.get(dexId) is not None else ""
        c1 = TYPE_MAP.get(t1)
        c2 = TYPE_MAP.get(t2)
        if not c1:
            report["bad_type"].add(t1 or "?")
            return None
        if not c2:
            c2 = c1
        for c in (c1, c2):
            if c not in rom_types:
                report["missing_type"].add(c)
                return None
        return (c1, c2)

# --------------------------------------------------------------------------
# Resolve one base_stats stem -> (source, (C1, C2)) or (None, None)
# --------------------------------------------------------------------------
def pokeapi_types(slug, rom_types, report):
    data = pokeapi(slug)
    if not data:
        return None
    slots = sorted(data["types"], key=lambda t: t["slot"])
    consts = []
    for t in slots:
        c = TYPE_MAP.get(t["type"]["name"].lower())
        if not c or c not in rom_types:
            report["missing_type"].add(t["type"]["name"])
            return None
        consts.append(c)
    if len(consts) == 1:
        consts.append(consts[0])
    return (consts[0], consts[1])

def resolve_types(stem, lumi, rom_types, report):
    species_norm, tag, api_suffix, is_bm = parse_stem(stem)
    if species_norm in EXCLUDE_TYPES:
        return (None, None)
    is_fakemon = (species_norm in SPECIAL_SLUG and SPECIAL_SLUG[species_norm] is None)
    if is_fakemon:
        return (None, None)

    lookup = LUMI_NAME_ALIAS.get(species_norm, species_norm)
    monsno = lumi.name_to_monsno.get(lookup)

    if monsno is not None:
        if tag is None:
            dexId = lumi.form_map.get(monsno, [monsno])[0]
            tc = lumi.type_consts(dexId, rom_types, report)
            if tc:
                return ("lumi", tc)
        else:
            dexId = lumi.form_index.get((monsno, tag))
            if dexId is not None:
                tc = lumi.type_consts(dexId, rom_types, report)
                if tc:
                    return ("lumi-form", tc)
            # form not in Luminescent -> PokeAPI
            base = SPECIAL_SLUG.get(species_norm) or species_norm
            tc = pokeapi_types(f"{base}-{api_suffix}", rom_types, report)
            if tc:
                return ("pokeapi", tc)
        return (None, None)

    # not in Luminescent -> PokeAPI
    base = SPECIAL_SLUG.get(species_norm)
    if species_norm in SPECIAL_SLUG and base is None:
        return (None, None)
    if base is None:
        base = species_norm
    slug = f"{base}-{api_suffix}" if tag else base
    tc = pokeapi_types(slug, rom_types, report)
    if tc:
        return ("pokeapi", tc)
    return (None, None)

# --------------------------------------------------------------------------
# Rewrite the "db T1, T2 ; type" line
# --------------------------------------------------------------------------
TYPE_LINE_RE = re.compile(r"^(\s*db\s+)([A-Z0-9_]+)\s*,\s*([A-Z0-9_]+)(\s*;\s*type.*)$")

def process_file(path, lumi, rom_types, report, dry_run):
    stem = os.path.splitext(os.path.basename(path))[0]
    with open(path, "r", encoding="utf-8") as f:
        lines = f.read().split("\n")

    idx = None
    for k, ln in enumerate(lines):
        if TYPE_LINE_RE.match(ln):
            idx = k
            break
    if idx is None:
        report["no_type_line"].append(stem)
        return

    source, tc = resolve_types(stem, lumi, rom_types, report)
    if tc is None:
        report["unchanged"].append(stem)
        return

    m = TYPE_LINE_RE.match(lines[idx])
    old = (m.group(2), m.group(3))
    new_line = f"{m.group(1)}{tc[0]}, {tc[1]}{m.group(4)}"
    if new_line != lines[idx]:
        report["changed"].append(f"{stem}: {old[0]}/{old[1]} -> {tc[0]}/{tc[1]}")
    else:
        report["same"] += 1
    report["sources"][source] = report["sources"].get(source, 0) + 1
    lines[idx] = new_line

    if not dry_run:
        with open(path, "w", encoding="utf-8") as f:
            f.write("\n".join(lines))

def main():
    global NO_NET
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--no-net", action="store_true")
    args = ap.parse_args()
    NO_NET = args.no_net

    rom_types = load_rom_types()
    print(f"Loaded {len(rom_types)} ROM type constants")
    print("Loading Luminescent 3.0 data...")
    lumi = LumiTypes()
    lumi.load()
    print(f"  {len(lumi.name_to_monsno)} species, {len(lumi.form_index)} regional forms, "
          f"{len(lumi.typename)} types")

    report = {"sources": {}, "changed": [], "same": 0, "unchanged": [],
              "no_type_line": [], "bad_type": set(), "missing_type": set()}

    files = sorted(glob.glob(os.path.join(BASE_STATS_DIR, "*.asm")))
    print(f"Processing {len(files)} base_stats files...")
    for path in files:
        process_file(path, lumi, rom_types, report, args.dry_run)

    print("\n==== SUMMARY ====")
    print(f"Type source: " + ", ".join(f"{k}={v}" for k, v in sorted(report["sources"].items())))
    print(f"Types changed: {len(report['changed'])}   already correct: {report['same']}")
    if report["unchanged"]:
        print(f"\nLeft unchanged (fakemon / no data) [{len(report['unchanged'])}]:")
        print("  " + ", ".join(report["unchanged"]))
    if report["no_type_line"]:
        print(f"\nNo 'db .. ; type' line found [{len(report['no_type_line'])}]:")
        print("  " + ", ".join(report["no_type_line"]))
    if report["bad_type"]:
        print(f"\nUnknown Lumi type names: {', '.join(sorted(report['bad_type']))}")
    if report["missing_type"]:
        print(f"\nTypes not in ROM: {', '.join(sorted(report['missing_type']))}")
    if report["changed"]:
        print(f"\nChanges ({len(report['changed'])}):")
        for c in report["changed"]:
            print("  " + c)
    print("\n(dry run - nothing written)" if args.dry_run else "\nDone. Rebuild to apply.")

if __name__ == "__main__":
    main()
