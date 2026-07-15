#!/usr/bin/env python3
"""
gen_learnsets.py  --  Rebuild Supreme Silver level-up learnsets to match
Pokemon Luminescent Platinum 3.0 (Re:Illuminated).

WHAT IT DOES
------------
For every `*EvosAttacks:` block in
    data/pokemon/evos_attacks_kanto.asm
    data/pokemon/evos_attacks_johto.asm
    data/pokemon/evos_attacks_clones.asm
it KEEPS the evolution lines untouched and REPLACES only the level-up moves
(the `dbw level, MOVE` lines) with a learnset built from one of three sources,
in priority order:

  1. LUMINESCENT 3.0  -- for any species/form that exists in Luminescent
     (all Gen 1-4 base forms + the regional forms Luminescent added).
     Uses their WazaOboeTable exactly.

  2. POKEAPI (canonical) -- for species/forms NOT in Luminescent
     (Gen 5-9 lines, evolved regional-only mons, etc.). Uses the level-up
     learnset from the most recent mainline game that mon appears in.

  3. MANUAL OVERRIDES -- for true fakemon that exist in neither
     (see FAKEMON_OVERRIDES below). Anything still unresolved is LEFT
     UNCHANGED and reported at the end.

In every case, moves that do not exist in this ROM's move list
(constants/move_constants.asm) are dropped -- "with the moves I have
available", as requested.

USAGE
-----
    cd <repo root>
    python3 tools/lumi_learnsets/gen_learnsets.py            # write changes
    python3 tools/lumi_learnsets/gen_learnsets.py --dry-run  # report only
    python3 tools/lumi_learnsets/gen_learnsets.py --no-net   # use only cached data

Requires internet on the first run (downloads Luminescent JSON + PokeAPI data
into tools/lumi_learnsets/cache/). Re-runs are offline-friendly.

Python 3.8+. Standard library only.
"""

import argparse
import json
import os
import re
import sys
import time
import urllib.request
import urllib.error

# --------------------------------------------------------------------------
# Paths
# --------------------------------------------------------------------------
HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
CACHE = os.path.join(HERE, "cache")
os.makedirs(CACHE, exist_ok=True)

ASM_FILES = [
    os.path.join(REPO, "data", "pokemon", "evos_attacks_kanto.asm"),
    os.path.join(REPO, "data", "pokemon", "evos_attacks_johto.asm"),
    os.path.join(REPO, "data", "pokemon", "evos_attacks_clones.asm"),
]
MOVE_CONSTANTS = os.path.join(REPO, "constants", "move_constants.asm")

LUMI_VER = "gamedata3.0"   # Re:Illuminated
LUMI_BASE = "https://raw.githubusercontent.com/TeamLumi/luminescent-team/main/__gamedata/" + LUMI_VER
LUMI_FILES = {
    "wazaoboe":  "WazaOboeTable.json",
    "moveenum":  "moveEnum.json",
    "personal":  "PersonalTable.json",
    "monsname":  "english_ss_monsname.json",
    "formname":  "english_ss_zkn_form.json",
}

POKEAPI = "https://pokeapi.co/api/v2"
# Which games' level-up learnsets to prefer for non-Luminescent mons.
VERSION_GROUP_PRIORITY = [
    "scarlet-violet",
    "sword-shield",
    "brilliant-diamond-and-shining-pearl",
    "legends-arceus",
    "sun-moon",
    "ultra-sun-ultra-moon",
    "omega-ruby-alpha-sapphire",
    "x-y",
    "black-2-white-2",
    "black-white",
    "platinum",
    "heartgold-soulsilver",
    "diamond-pearl",
]

# --------------------------------------------------------------------------
# Networking / cache
# --------------------------------------------------------------------------
NO_NET = False
INCLUDE_CANONICAL = False

def fetch(url, cache_name, is_json=True, retries=3):
    path = os.path.join(CACHE, cache_name)
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            data = f.read()
        return json.loads(data) if is_json else data
    if NO_NET:
        raise RuntimeError(f"--no-net set but {cache_name} is not cached ({url})")
    last = None
    for attempt in range(retries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "SupremeSilver-learnset-gen"})
            with urllib.request.urlopen(req, timeout=30) as r:
                data = r.read().decode("utf-8")
            with open(path, "w", encoding="utf-8") as f:
                f.write(data)
            return json.loads(data) if is_json else data
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
            last = e
            time.sleep(1.5 * (attempt + 1))
    raise RuntimeError(f"Failed to fetch {url}: {last}")

def pokeapi(slug):
    """Return the /pokemon/{slug} JSON, or None on 404."""
    slug = slug.lower()
    path = os.path.join(CACHE, f"pokeapi_{slug}.json")
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    if NO_NET:
        return None
    try:
        req = urllib.request.Request(f"{POKEAPI}/pokemon/{slug}",
                                     headers={"User-Agent": "SupremeSilver-learnset-gen"})
        with urllib.request.urlopen(req, timeout=30) as r:
            data = r.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        raise
    with open(path, "w", encoding="utf-8") as f:
        f.write(data)
    time.sleep(0.15)  # be polite to PokeAPI
    return json.loads(data)

# --------------------------------------------------------------------------
# Move-name normalization + map to this ROM's MOVE constants
# --------------------------------------------------------------------------
def norm_move(name):
    """Canonical key: lowercase, drop everything but a-z0-9."""
    return re.sub(r"[^a-z0-9]", "", name.lower())

# normalized standard move name  ->  this ROM's MOVE constant.
# Built from constants/move_constants.asm; only moves that exist in the ROM
# are listed, so anything not here is automatically dropped.
MOVE_MAP = {
    "pound": "POUND", "karatechop": "KARATE_CHOP", "doubleslap": "DOUBLESLAP",
    "cometpunch": "COMET_PUNCH", "megapunch": "MEGA_PUNCH", "payday": "PAY_DAY",
    "firepunch": "FIRE_PUNCH", "icepunch": "ICE_PUNCH", "thunderpunch": "THUNDERPUNCH",
    "scratch": "SCRATCH", "visegrip": "VICEGRIP", "vicegrip": "VICEGRIP",
    "guillotine": "GUILLOTINE", "razorwind": "RAZOR_WIND", "swordsdance": "SWORDS_DANCE",
    "cut": "CUT", "gust": "GUST", "wingattack": "WING_ATTACK", "whirlwind": "WHIRLWIND",
    "fly": "FLY", "bind": "BIND", "slam": "SLAM", "vinewhip": "VINE_WHIP",
    "stomp": "STOMP", "doublekick": "DOUBLE_KICK", "megakick": "MEGA_KICK",
    "jumpkick": "JUMP_KICK", "rollingkick": "ROLLING_KICK", "sandattack": "SAND_ATTACK",
    "headbutt": "HEADBUTT", "hornattack": "HORN_ATTACK", "furyattack": "FURY_ATTACK",
    "horndrill": "HORN_DRILL", "tackle": "TACKLE", "bodyslam": "BODY_SLAM",
    "wrap": "WRAP", "takedown": "TAKE_DOWN", "thrash": "THRASH", "doubleedge": "DOUBLE_EDGE",
    "tailwhip": "TAIL_WHIP", "poisonsting": "POISON_STING", "twineedle": "TWINEEDLE",
    "pinmissile": "PIN_MISSILE", "leer": "LEER", "bite": "BITE", "growl": "GROWL",
    "roar": "ROAR", "sing": "SING", "supersonic": "SUPERSONIC", "sonicboom": "SONICBOOM",
    "disable": "DISABLE", "acid": "ACID", "ember": "EMBER", "flamethrower": "FLAMETHROWER",
    "mist": "MIST", "watergun": "WATER_GUN", "hydropump": "HYDRO_PUMP", "surf": "SURF",
    "icebeam": "ICE_BEAM", "blizzard": "BLIZZARD", "psybeam": "PSYBEAM",
    "bubblebeam": "BUBBLEBEAM", "aurorabeam": "AURORA_BEAM", "hyperbeam": "HYPER_BEAM",
    "peck": "PECK", "drillpeck": "DRILL_PECK", "submission": "SUBMISSION",
    "lowkick": "LOW_KICK", "counter": "COUNTER", "seismictoss": "SEISMIC_TOSS",
    "strength": "STRENGTH", "absorb": "ABSORB", "megadrain": "MEGA_DRAIN",
    "leechseed": "LEECH_SEED", "growth": "GROWTH", "razorleaf": "RAZOR_LEAF",
    "solarbeam": "SOLARBEAM", "poisonpowder": "POISONPOWDER", "stunspore": "STUN_SPORE",
    "sleeppowder": "SLEEP_POWDER", "petaldance": "PETAL_DANCE", "stringshot": "STRING_SHOT",
    "dragonrage": "DRAGON_RAGE", "firespin": "FIRE_SPIN", "thundershock": "THUNDERSHOCK",
    "thunderbolt": "THUNDERBOLT", "thunderwave": "THUNDER_WAVE", "thunder": "THUNDER",
    "rockthrow": "ROCK_THROW", "earthquake": "EARTHQUAKE", "fissure": "FISSURE",
    "dig": "DIG", "toxic": "TOXIC", "confusion": "CONFUSION", "psychic": "PSYCHIC_M",
    "hypnosis": "HYPNOSIS", "meditate": "MEDITATE", "agility": "AGILITY",
    "quickattack": "QUICK_ATTACK", "rage": "RAGE", "teleport": "TELEPORT",
    "nightshade": "NIGHT_SHADE", "mimic": "MIMIC", "screech": "SCREECH",
    "doubleteam": "DOUBLE_TEAM", "recover": "RECOVER", "harden": "HARDEN",
    "minimize": "MINIMIZE", "smokescreen": "SMOKESCREEN", "confuseray": "CONFUSE_RAY",
    "withdraw": "WITHDRAW", "defensecurl": "DEFENSE_CURL", "barrier": "BARRIER",
    "lightscreen": "LIGHT_SCREEN", "haze": "HAZE", "reflect": "REFLECT",
    "focusenergy": "FOCUS_ENERGY", "bide": "BIDE", "metronome": "METRONOME",
    "mirrormove": "MIRROR_MOVE", "selfdestruct": "SELFDESTRUCT", "eggbomb": "EGG_BOMB",
    "lick": "LICK", "smog": "SMOG", "sludge": "SLUDGE", "boneclub": "BONE_CLUB",
    "fireblast": "FIRE_BLAST", "waterfall": "WATERFALL", "clamp": "CLAMP", "swift": "SWIFT",
    "skullbash": "SKULL_BASH", "spikecannon": "SPIKE_CANNON", "constrict": "CONSTRICT",
    "amnesia": "AMNESIA", "kinesis": "KINESIS", "softboiled": "SOFTBOILED",
    "highjumpkick": "HI_JUMP_KICK", "glare": "GLARE", "dreameater": "DREAM_EATER",
    "poisongas": "POISON_GAS", "barrage": "BARRAGE", "leechlife": "LEECH_LIFE",
    "lovelykiss": "LOVELY_KISS", "skyattack": "SKY_ATTACK", "transform": "TRANSFORM",
    "bubble": "BUBBLE", "dizzypunch": "DIZZY_PUNCH", "spore": "SPORE", "flash": "FLASH",
    "psywave": "PSYWAVE", "splash": "SPLASH", "acidarmor": "ACID_ARMOR",
    "crabhammer": "CRABHAMMER", "explosion": "EXPLOSION", "furyswipes": "FURY_SWIPES",
    "bonemerang": "BONEMERANG", "rest": "REST", "rockslide": "ROCK_SLIDE",
    "hyperfang": "HYPER_FANG", "sharpen": "SHARPEN", "conversion": "CONVERSION",
    "triattack": "TRI_ATTACK", "superfang": "SUPER_FANG", "slash": "SLASH",
    "substitute": "SUBSTITUTE", "sketch": "SKETCH", "triplekick": "TRIPLE_KICK",
    "thief": "THIEF", "spiderweb": "SPIDER_WEB", "mindreader": "MIND_READER",
    "nightmare": "NIGHTMARE", "flamewheel": "FLAME_WHEEL", "snore": "SNORE",
    "curse": "CURSE", "flail": "FLAIL", "conversion2": "CONVERSION2",
    "aeroblast": "AEROBLAST", "cottonspore": "COTTON_SPORE", "reversal": "REVERSAL",
    "spite": "SPITE", "powdersnow": "POWDER_SNOW", "protect": "PROTECT",
    "machpunch": "MACH_PUNCH", "scaryface": "SCARY_FACE", "feintattack": "FAINT_ATTACK",
    "sweetkiss": "SWEET_KISS", "bellydrum": "BELLY_DRUM", "sludgebomb": "SLUDGE_BOMB",
    "mudslap": "MUD_SLAP", "octazooka": "OCTAZOOKA", "spikes": "SPIKES",
    "zapcannon": "ZAP_CANNON", "foresight": "FORESIGHT", "destinybond": "DESTINY_BOND",
    "perishsong": "PERISH_SONG", "icywind": "ICY_WIND", "detect": "DETECT",
    "bonerush": "BONE_RUSH", "lockon": "LOCK_ON", "outrage": "OUTRAGE",
    "sandstorm": "SANDSTORM", "gigadrain": "GIGA_DRAIN", "endure": "ENDURE",
    "charm": "CHARM", "rollout": "ROLLOUT", "falseswipe": "FALSE_SWIPE",
    "swagger": "SWAGGER", "milkdrink": "MILK_DRINK", "spark": "SPARK",
    "furycutter": "FURY_CUTTER", "steelwing": "STEEL_WING", "meanlook": "MEAN_LOOK",
    "attract": "ATTRACT", "sleeptalk": "SLEEP_TALK", "healbell": "HEAL_BELL",
    "return": "RETURN", "present": "PRESENT", "frustration": "FRUSTRATION",
    "safeguard": "SAFEGUARD", "painsplit": "PAIN_SPLIT", "sacredfire": "SACRED_FIRE",
    "magnitude": "MAGNITUDE", "dynamicpunch": "DYNAMICPUNCH", "megahorn": "MEGAHORN",
    "dragonbreath": "DRAGONBREATH", "batonpass": "BATON_PASS", "encore": "ENCORE",
    "pursuit": "PURSUIT", "rapidspin": "RAPID_SPIN", "sweetscent": "SWEET_SCENT",
    "irontail": "IRON_TAIL", "metalclaw": "METAL_CLAW", "vitalthrow": "VITAL_THROW",
    "morningsun": "MORNING_SUN", "synthesis": "SYNTHESIS", "moonlight": "MOONLIGHT",
    "hiddenpower": "HIDDEN_POWER", "crosschop": "CROSS_CHOP", "twister": "TWISTER",
    "raindance": "RAIN_DANCE", "sunnyday": "SUNNY_DAY", "crunch": "CRUNCH",
    "mirrorcoat": "MIRROR_COAT", "psychup": "PSYCH_UP", "extremespeed": "EXTREMESPEED",
    "psychicm": "PSYCHIC_M", "gigahammer": "GIGA_HAMMER",
    "gigatonhammer": "GIGA_HAMMER",
    "ancientpower": "ANCIENTPOWER", "shadowball": "SHADOW_BALL", "futuresight": "FUTURE_SIGHT",
    "rocksmash": "ROCK_SMASH", "whirlpool": "WHIRLPOOL", "beatup": "BEAT_UP",
    "dazzlinggleam": "DAZZLING_GLEAM", "disarmingvoice": "DISARMING_VOICE",
    "drainingkiss": "DRAINING_KISS", "playrough": "PLAY_ROUGH", "spiritbreak": "SPIRIT_BREAK",
    "fairywind": "FAIRY_WIND", "suckerpunch": "SUCKER_PUNCH", "darkpulse": "DARK_PULSE",
    "firefang": "FIRE_FANG", "icefang": "ICE_FANG", "thunderfang": "THUNDER_FANG",
    "aquajet": "AQUA_JET", "wildcharge": "WILD_CHARGE", "bitterblade": "BITTER_BLADE",
    "heatcrash": "HEAT_CRASH", "iceshard": "ICE_SHARD", "tripleaxel": "TRIPLE_AXEL",
    "iciclecrash": "ICICLE_CRASH", "strugglebug": "STRUGGLE_BUG", "infestation": "INFESTATION",
    "bugbuzz": "BUG_BUZZ", "accelerock": "ACCELROCK", "stoneedge": "STONE_EDGE",
    "airslash": "AIR_SLASH", "poisonfang": "POISON_FANG", "venoshock": "VENOSHOCK",
    "hail": "HAIL", "leafblade": "LEAF_BLADE", "shadowsneak": "SHADOW_SNEAK",
    "shadowpunch": "SHADOW_PUNCH", "shadowclaw": "SHADOW_CLAW", "poisonjab": "POISON_JAB",
    "lunge": "LUNGE", "bugbite": "BUG_BITE", "xscissor": "X_SCISSOR", "uturn": "U_TURN",
    "dragonclaw": "DRAGON_CLAW", "dracometeor": "DRACO_METEOR", "moonblast": "MOONBLAST",
    "bloodmoon": "BLOOD_MOON", "bulletpunch": "BULLET_PUNCH", "drainpunch": "DRAIN_PUNCH",
    "solarblade": "SOLAR_BLADE", "closecombat": "CLOSE_COMBAT", "acrobatics": "ACROBATICS",
    "aerialace": "AERIAL_ACE", "aquatail": "AQUA_TAIL", "astonish": "ASTONISH",
    "aurasphere": "AURA_SPHERE", "avalanche": "AVALANCHE", "bravebird": "BRAVE_BIRD",
    "bulkup": "BULK_UP", "bulldoze": "BULLDOZE", "calmmind": "CALM_MIND",
    "dragondance": "DRAGON_DANCE", "dragonpulse": "DRAGON_PULSE", "earthpower": "EARTH_POWER",
    "energyball": "ENERGY_BALL", "extrasensory": "EXTRASENSORY", "facade": "FACADE",
    "flamecharge": "FLAME_CHARGE", "flareblitz": "FLARE_BLITZ", "flashcannon": "FLASH_CANNON",
    "focusblast": "FOCUS_BLAST", "gigaimpact": "GIGA_IMPACT", "gunkshot": "GUNK_SHOT",
    "gyroball": "GYRO_BALL", "hex": "HEX", "honeclaws": "HONE_CLAWS", "hurricane": "HURRICANE",
    "hypervoice": "HYPER_VOICE", "iciclespear": "ICICLE_SPEAR", "ironhead": "IRON_HEAD",
    "knockoff": "KNOCK_OFF", "nastyplot": "NASTY_PLOT", "nightslash": "NIGHT_SLASH",
    "powergem": "POWER_GEM", "powerwhip": "POWER_WHIP", "psystrike": "PSYSTRIKE",
    "rockblast": "ROCK_BLAST", "roost": "ROOST", "scald": "SCALD", "seedbomb": "SEED_BOMB",
    "shellsmash": "SHELL_SMASH", "skillswap": "SKILL_SWAP", "toxicspikes": "TOXIC_SPIKES",
    "trick": "TRICK", "trickroom": "TRICK_ROOM", "voltswitch": "VOLT_SWITCH",
    "waterpulse": "WATER_PULSE", "willowisp": "WILL_O_WISP", "zenheadbutt": "ZEN_HEADBUTT",
    "tropkick": "TROP_KICK", "mortalspin": "MORTAL_SPIN", "firstimpression": "FIRST_IMPRESSION",
    "liquidation": "LIQUIDATION",
}

# --------------------------------------------------------------------------
# Region-form handling
# --------------------------------------------------------------------------
# SS label suffix -> (region tag used to match Luminescent form names,
#                     PokeAPI form-slug suffix)
REGION_SUFFIXES = [
    ("PaldeanFire",  ("paldea", "paldea-blaze-breed")),
    ("PaldeanWater", ("paldea", "paldea-aqua-breed")),
    ("Paldean",      ("paldea", "paldea")),
    ("Alolan",       ("alola",  "alola")),
    ("Galarian",     ("galar",  "galar")),
    ("Hisuian",      ("hisui",  "hisui")),
]

# Luminescent form-name keyword -> region tag
LUMI_REGION_KEYWORDS = {
    "alola": "alola", "alolan": "alola",
    "galar": "galar", "galarian": "galar",
    "hisui": "hisui", "hisuian": "hisui",
    "paldea": "paldea", "paldean": "paldea",
}

# SS label (normalized) -> Luminescent species name (normalized), when they differ
LUMI_NAME_ALIAS = {
    "drunsparce": "dudunsparce",
}

# Label base -> explicit PokeAPI slug (when normalization is not enough)
SPECIAL_SLUG = {
    "nidoranf": "nidoran-f", "nidoranm": "nidoran-m",
    "mrmime": "mr-mime", "mrrime": "mr-rime", "mimejr": "mime-jr",
    "hooh": "ho-oh", "porygonz": "porygon-z", "typenull": "type-null",
    "farfetchd": "farfetchd", "sirfetchd": "sirfetchd",
    "jangmoo": "jangmo-o", "hakamoo": "hakamo-o", "kommoo": "kommo-o",
    "tapukoko": "tapu-koko", "wochien": "wo-chien",
    # aliases for SS-specific labels
    "drunsparce": "dudunsparce-two-segment",  # PokeAPI fallback if not in Lumi
    "orstryx": None,   # fakemon
    "watu": None,      # fakemon
    "mesmeria": None,  # fakemon
}

# Bloodmoon / custom form label -> PokeAPI slug (or None -> override/unchanged)
SPECIAL_FORM_LABEL = {
    "ursalunabm": "ursaluna-bloodmoon",
    "teddiursabm": "teddiursa",
    "ursaringbm": "ursaring",
}

# Fakemon manual learnsets: normalized label -> [(level, "MOVE_CONST"), ...]
# Authored from each mon's type/stats (see data/pokemon/base_stats/*.asm).
# Any fakemon NOT listed here is left with its existing learnset and reported.
FAKEMON_OVERRIDES = {
    # Watu -- Psychic/Flying, frail Natu-like basic
    "watu": [
        (1, "PECK"), (1, "LEER"), (4, "NIGHT_SHADE"), (8, "QUICK_ATTACK"),
        (12, "CONFUSION"), (16, "WING_ATTACK"), (20, "LIGHT_SCREEN"), (20, "REFLECT"),
        (24, "PSYBEAM"), (28, "FUTURE_SIGHT"), (32, "AIR_SLASH"), (36, "PSYCHIC_M"),
        (40, "ROOST"), (44, "EXTRASENSORY"),
    ],
    # Orstryx -- Psychic/Flying, bulky special legendary (Magic Bounce)
    "orstryx": [
        (1, "PECK"), (1, "CONFUSION"), (1, "LEER"), (7, "GUST"), (14, "PSYBEAM"),
        (21, "LIGHT_SCREEN"), (21, "REFLECT"), (28, "AIR_SLASH"), (35, "ANCIENTPOWER"),
        (42, "EXTRASENSORY"), (49, "ROOST"), (56, "PSYCHIC_M"), (63, "HURRICANE"),
        (70, "FUTURE_SIGHT"), (77, "SKY_ATTACK"),
    ],
    # Mesmeria -- Ice/Psychic, special sweeper / mesmerist
    "mesmeria": [
        (1, "POWDER_SNOW"), (1, "CONFUSION"), (1, "LEER"), (5, "HYPNOSIS"),
        (9, "ICY_WIND"), (13, "PSYBEAM"), (17, "AURORA_BEAM"), (21, "DREAM_EATER"),
        (25, "PSYCH_UP"), (29, "EXTRASENSORY"), (33, "ICE_BEAM"), (37, "PSYCHIC_M"),
        (41, "CALM_MIND"), (45, "BLIZZARD"), (49, "FUTURE_SIGHT"),
    ],
}

# Intentional Supreme Silver additions layered on top of source learnsets.
# These remain stable when the generator is re-run.
PROJECT_ADDITIONS = {
    # Legacy/custom moves omitted from current-generation level-up data.
    "spinarak": [(29, "SPIDER_WEB")],
    "ariados": [(32, "SPIDER_WEB")],
    "snubbull": [(7, "PIXIE_PUNCH")],
    "granbull": [(1, "PIXIE_PUNCH")],
    "camerupt": [(52, "HEAT_CRASH")],
    "centiskorch": [(56, "HEAT_CRASH")],
    "alakazam": [(55, "FOCUS_BLAST")],
    "gardevoir": [(55, "FOCUS_BLAST")],
    "magmortar": [(58, "FOCUS_BLAST")],
    "kingdra": [(65, "DRACO_METEOR")],
    "flygon": [(65, "DRACO_METEOR")],
    "salamence": [(70, "DRACO_METEOR")],
    "dragonite": [(70, "DRACO_METEOR")],
    "hydreigon": [(70, "DRACO_METEOR")],
    "dragapult": [(70, "DRACO_METEOR")],
    "archaludon": [(70, "DRACO_METEOR")],
    "xatu": [(38, "ROOST")],
    "unown": [(30, "PSYCHIC_M")],
    "tinkaton": [(42, "IRON_HEAD"), (48, "GIGA_HAMMER")],
    "corviknight": [(42, "ROOST")],
}

# --------------------------------------------------------------------------
# Load ROM move constants (for validation)
# --------------------------------------------------------------------------
def load_rom_moves():
    moves = set()
    with open(MOVE_CONSTANTS, "r", encoding="utf-8") as f:
        for line in f:
            if line.strip().startswith("NUM_ATTACKS"):
                break
            m = re.match(r"\s*const\s+([A-Z0-9_]+)", line)
            if m:
                moves.add(m.group(1))
    moves.discard("NO_MOVE")
    return moves

# --------------------------------------------------------------------------
# Luminescent data
# --------------------------------------------------------------------------
class Lumi:
    def __init__(self):
        self.wazaoboe = {}      # dexId -> [lvl, moveid, ...]
        self.moveenum = []      # moveid -> "Move Name"
        self.monsno_of = {}     # dexId -> monsno
        self.name_to_monsno = {}  # normalized species name -> monsno
        self.form_index = {}    # (monsno, region_tag) -> dexId
        self.form_map = {}      # monsno -> [dexId for form 0,1,2,...]

    def load(self):
        waza = fetch(f"{LUMI_BASE}/{LUMI_FILES['wazaoboe']}", "lumi_wazaoboe.json")
        for e in waza["WazaOboe"]:
            self.wazaoboe[e["id"]] = e.get("ar", [])
        self.moveenum = fetch(f"{LUMI_BASE}/{LUMI_FILES['moveenum']}", "lumi_moveenum.json")
        personal = fetch(f"{LUMI_BASE}/{LUMI_FILES['personal']}", "lumi_personal.json")
        monsname = fetch(f"{LUMI_BASE}/{LUMI_FILES['monsname']}", "lumi_monsname.json")
        formname = fetch(f"{LUMI_BASE}/{LUMI_FILES['formname']}", "lumi_formname.json")

        # species name (index = monsno) -> monsno
        for monsno, entry in enumerate(monsname["labelDataArray"]):
            wda = entry.get("wordDataArray") or []
            if wda and wda[0].get("str"):
                self.name_to_monsno[norm_name(wda[0]["str"])] = monsno

        # per-dexId monsno + build form map (order of appearance per monsno)
        for p in personal["Personal"]:
            dexId = p["id"]
            monsno = p["monsno"]
            self.monsno_of[dexId] = monsno
            if p.get("valid_flag", 1) == 1:
                self.form_map.setdefault(monsno, []).append(dexId)

        # region tag per form via the form-name file
        for monsno, dexIds in self.form_map.items():
            for dexId in dexIds:
                fn_entry = None
                if dexId < len(formname["labelDataArray"]):
                    fn_entry = formname["labelDataArray"][dexId]
                fstr = ""
                if fn_entry:
                    wda = fn_entry.get("wordDataArray") or []
                    if wda:
                        fstr = wda[0].get("str", "")
                tag = classify_region(fstr)
                if tag:
                    self.form_index[(monsno, tag)] = dexId

    def learnset_by_dexid(self, dexId):
        ar = self.wazaoboe.get(dexId, [])
        out = []
        for i in range(0, len(ar) - 1, 2):
            lvl, mid = ar[i], ar[i + 1]
            if 0 <= mid < len(self.moveenum):
                out.append((lvl, self.moveenum[mid]))
        return out

def norm_name(s):
    s = s.replace("♀", "f").replace("♂", "m")  # ♀ ♂
    return re.sub(r"[^a-z0-9]", "", s.lower())

def classify_region(form_name_str):
    low = form_name_str.lower()
    for kw, tag in LUMI_REGION_KEYWORDS.items():
        if kw in low:
            return tag
    return None

# --------------------------------------------------------------------------
# PokeAPI level-up learnset
# --------------------------------------------------------------------------
def pokeapi_learnset(slug, prefer_hisui=False):
    data = pokeapi(slug)
    if not data:
        return None
    prio = list(VERSION_GROUP_PRIORITY)
    if prefer_hisui:
        prio = ["legends-arceus"] + [v for v in prio if v != "legends-arceus"]
    # collect level-up moves per version group
    by_vg = {}
    for mv in data["moves"]:
        name = mv["move"]["name"]
        for d in mv["version_group_details"]:
            if d["move_learn_method"]["name"] != "level-up":
                continue
            vg = d["version_group"]["name"]
            by_vg.setdefault(vg, []).append((d["level_learned_at"], name))
    for vg in prio:
        if by_vg.get(vg):
            return by_vg[vg]
    # fall back to any version group that has data
    for vg, lst in by_vg.items():
        if lst:
            return lst
    return None

# --------------------------------------------------------------------------
# Resolve one species/form label -> list of (level, "MOVE_CONST")
# --------------------------------------------------------------------------
def split_region(base):
    """Return (species_base, region_tag, pokeapi_suffix) for a label base."""
    for suffix, (tag, api) in REGION_SUFFIXES:
        if base.endswith(suffix) and base != suffix:
            return base[: -len(suffix)], tag, api
    return base, None, None

def moves_to_consts(pairs, rom_moves, report):
    """pairs: [(level, name)] -> [(level, CONST)] filtered + sorted."""
    out = []
    for lvl, name in pairs:
        key = norm_move(name)
        const = MOVE_MAP.get(key)
        if const is None:
            report["unmapped_moves"].add(name)
            continue
        if const not in rom_moves:
            report["missing_consts"].add(const)
            continue
        out.append((max(1, int(lvl)), const))
    # stable sort by level, preserve original order within a level
    out.sort(key=lambda x: x[0])
    return out

def consts_direct(pairs, rom_moves, report):
    """Overrides are already ROM MOVE constants: validate + sort, no mapping."""
    out = []
    for lvl, const in pairs:
        if const not in rom_moves:
            report["missing_consts"].add(const)
            continue
        out.append((max(1, int(lvl)), const))
    out.sort(key=lambda x: x[0])
    return out

def slug_for(species_norm, api_suffix, tag):
    """Return a PokeAPI slug, or None if this is a marked fakemon."""
    if species_norm in SPECIAL_SLUG:
        base = SPECIAL_SLUG[species_norm]
        if base is None:
            return None
    else:
        base = species_norm
    return f"{base}-{api_suffix}" if tag else base

def resolve_base_learnset(label_base, lumi, rom_moves, report):
    """label_base: e.g. 'Charizard', 'RaichuAlolan', 'Ursalunabm'.
    Returns (source_str, [(level, CONST), ...]) or (None, None) to leave as-is.
    Priority: custom-form label -> override -> Luminescent -> PokeAPI."""
    low = norm_name(label_base)

    # 1) explicit custom form labels (bloodmoon etc.)
    if low in SPECIAL_FORM_LABEL:
        slug = SPECIAL_FORM_LABEL[low]
        if slug:
            ls = pokeapi_learnset(slug, prefer_hisui=("hisui" in slug))
            if ls:
                return ("pokeapi:" + slug, moves_to_consts(ls, rom_moves, report))
        if low in FAKEMON_OVERRIDES:
            return ("override", consts_direct(FAKEMON_OVERRIDES[low], rom_moves, report))
        return (None, None)

    # 2) fakemon override (by full label)
    if low in FAKEMON_OVERRIDES:
        return ("override", consts_direct(FAKEMON_OVERRIDES[low], rom_moves, report))

    species, tag, api_suffix = split_region(label_base)
    species_norm = norm_name(species)
    is_fakemon = (species_norm in SPECIAL_SLUG and SPECIAL_SLUG[species_norm] is None)
    # some SS labels are spelled differently than Luminescent (e.g. Drunsparce)
    lumi_lookup = LUMI_NAME_ALIAS.get(species_norm, species_norm)
    monsno = lumi.name_to_monsno.get(lumi_lookup)

    # 3) species exists in Luminescent -> prefer Luminescent data
    if monsno is not None and not is_fakemon:
        if tag is None:
            dexId = lumi.form_map.get(monsno, [monsno])[0]
            ls = lumi.learnset_by_dexid(dexId)
            if ls:
                return ("lumi", moves_to_consts(ls, rom_moves, report))
        else:
            dexId = lumi.form_index.get((monsno, tag))
            if dexId is not None:
                ls = lumi.learnset_by_dexid(dexId)
                if ls:
                    return ("lumi-form", moves_to_consts(ls, rom_moves, report))
        # in Lumi but no (or empty) learnset for this form -> PokeAPI
        slug = slug_for(species_norm, api_suffix, tag)
        if slug:
            ls = pokeapi_learnset(slug, prefer_hisui=(tag == "hisui"))
            if ls:
                return ("pokeapi:" + slug, moves_to_consts(ls, rom_moves, report))
        return (None, None)

    # 4) not in Luminescent -> PokeAPI (or fakemon -> leave unchanged)
    slug = slug_for(species_norm, api_suffix, tag)
    if slug is None:
        return (None, None)
    ls = pokeapi_learnset(slug, prefer_hisui=(tag == "hisui"))
    if ls:
        return ("pokeapi:" + slug, moves_to_consts(ls, rom_moves, report))
    return (None, None)

def canonical_learnset(label_base, rom_moves, report):
    """Newest available canonical level-up learnset for audit/union mode."""
    low = norm_name(label_base)
    if low in FAKEMON_OVERRIDES:
        return []

    if low in SPECIAL_FORM_LABEL:
        slug = SPECIAL_FORM_LABEL[low]
        if not slug:
            return []
        ls = pokeapi_learnset(slug, prefer_hisui=("hisui" in slug))
        return moves_to_consts(ls or [], rom_moves, report)

    species, tag, api_suffix = split_region(label_base)
    species_norm = norm_name(species)
    slug = slug_for(species_norm, api_suffix, tag)
    if not slug:
        return []
    ls = pokeapi_learnset(slug, prefer_hisui=(tag == "hisui"))
    return moves_to_consts(ls or [], rom_moves, report)

def merge_missing_moves(primary, additions):
    """Add only move constants absent from primary; retain source levels."""
    out = []
    seen_rows = set()
    for row in primary or []:
        if row not in seen_rows:
            out.append(row)
            seen_rows.add(row)
    present = {const for _, const in out}
    for lvl, const in additions:
        if const in present:
            continue
        out.append((lvl, const))
        present.add(const)
    out.sort(key=lambda x: x[0])
    return out

def resolve_learnset(label_base, lumi, rom_moves, report):
    source, learn = resolve_base_learnset(label_base, lumi, rom_moves, report)
    merged = list(learn or [])

    if INCLUDE_CANONICAL:
        before = len(merged)
        merged = merge_missing_moves(
            merged, canonical_learnset(label_base, rom_moves, report)
        )
        if len(merged) != before:
            source = (source or "canonical") + "+canonical"

    additions = PROJECT_ADDITIONS.get(norm_name(label_base), [])
    if additions:
        before = len(merged)
        # Project rows are exact placements, so keep them even when the same
        # move also has a level-1 reminder entry in canonical data.
        for row in consts_direct(additions, rom_moves, report):
            if row not in merged:
                merged.append(row)
        merged.sort(key=lambda x: x[0])
        if len(merged) != before:
            source = (source or "project") + "+project"

    return (source, merged or None)

# --------------------------------------------------------------------------
# ASM parsing / rewriting
# --------------------------------------------------------------------------
LABEL_RE = re.compile(r"^([A-Za-z0-9_]+)EvosAttacks:\s*$")

def process_file(path, lumi, rom_moves, report, dry_run):
    with open(path, "r", encoding="utf-8") as f:
        lines = f.read().split("\n")

    out = []
    i = 0
    n = len(lines)
    while i < n:
        m = LABEL_RE.match(lines[i])
        if not m:
            out.append(lines[i])
            i += 1
            continue

        label = m.group(1)  # without 'EvosAttacks'
        block_start = i
        out.append(lines[i])  # label line
        i += 1

        # copy evolution lines up to & including first "db 0" (no more evolutions)
        evo_done = False
        while i < n:
            out.append(lines[i])
            if re.match(r"\s*db\s+0\b", lines[i]):
                i += 1
                evo_done = True
                break
            i += 1
        if not evo_done:
            report["parse_errors"].append(f"{os.path.basename(path)}:{block_start+1} {label}")
            continue

        # capture the ORIGINAL learnset lines (dbw ...) until "db 0" (level-up end)
        orig_learn = []
        while i < n and not re.match(r"\s*db\s+0\b", lines[i]):
            orig_learn.append(lines[i])
            i += 1
        closing = lines[i] if i < n else None  # the second "db 0"

        base = label[:-5] if label.endswith("Clone") else label  # strip trailing 'Clone'
        source, learn = resolve_learnset(base, lumi, rom_moves, report)

        if not learn:  # None (no data) or empty after filtering -> keep original
            report["unchanged"].append(label)
            out.extend(orig_learn)  # keep the existing learnset verbatim
        else:
            key = source.split(":")[0]
            report["sources"][key] = report["sources"].get(key, 0) + 1
            for lvl, const in learn:
                out.append(f"\tdbw {lvl}, {const}")

        # closing "db 0 ; no more level-up moves"
        if closing is not None:
            out.append(closing)
            i += 1

    new_text = "\n".join(out)
    if not dry_run:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_text)
    return

# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------
def main():
    global NO_NET, INCLUDE_CANONICAL
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="report only, do not write")
    ap.add_argument("--no-net", action="store_true", help="use only cached data")
    ap.add_argument("--canonical-union", action="store_true",
                    help="add missing moves from the newest canonical level-up learnset")
    args = ap.parse_args()
    NO_NET = args.no_net
    INCLUDE_CANONICAL = args.canonical_union

    print("Loading ROM move constants...")
    rom_moves = load_rom_moves()
    print(f"  {len(rom_moves)} moves available in this ROM")

    print("Loading Luminescent 3.0 data (downloads on first run)...")
    lumi = Lumi()
    lumi.load()
    print(f"  {len(lumi.wazaoboe)} Luminescent learnset entries, "
          f"{len(lumi.name_to_monsno)} species, {len(lumi.form_index)} regional forms")

    report = {
        "sources": {}, "unchanged": [], "unmapped_moves": set(),
        "missing_consts": set(), "parse_errors": [],
    }

    for path in ASM_FILES:
        if not os.path.exists(path):
            print(f"  WARNING: missing {path}")
            continue
        print(f"Processing {os.path.relpath(path, REPO)} ...")
        process_file(path, lumi, rom_moves, report, args.dry_run)

    print("\n==== SUMMARY ====")
    print("Learnset sources:")
    for k, v in sorted(report["sources"].items()):
        print(f"  {k:14s} {v}")
    if report["unchanged"]:
        print(f"\nLeft UNCHANGED (no Lumi/PokeAPI/override data) [{len(report['unchanged'])}]:")
        print("  " + ", ".join(report["unchanged"]))
    if report["unmapped_moves"]:
        print(f"\nMoves with no ROM equivalent (dropped) [{len(report['unmapped_moves'])}]:")
        print("  " + ", ".join(sorted(report["unmapped_moves"])))
    if report["missing_consts"]:
        print(f"\nMapped constants NOT found in move_constants.asm (check!):")
        print("  " + ", ".join(sorted(report["missing_consts"])))
    if report["parse_errors"]:
        print(f"\nParse errors:")
        for e in report["parse_errors"]:
            print("  " + e)
    if args.dry_run:
        print("\n(dry run - no files written)")
    else:
        print("\nDone. Rebuild the ROM to apply.")

if __name__ == "__main__":
    main()
