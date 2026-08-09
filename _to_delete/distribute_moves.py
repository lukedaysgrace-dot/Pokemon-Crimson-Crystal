#!/usr/bin/env python3
"""Give the 58 orphaned moves level-up learnsets, following mainline distribution.

Also splits "Evolutions and Attacks 2" so the added data fits in a 16 KiB section.
Idempotent. Usage: distribute_moves.py <repo root>
"""
import io, os, re, sys, collections

ROOT = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else '.')
os.chdir(ROOT)

def read(p):
    with io.open(p, encoding='utf-8', newline='') as f: return f.read()
def write(p, t):
    with io.open(p, 'w', encoding='utf-8', newline='') as f: f.write(t)
def nl_of(t): return '\r\n' if '\r\n' in t else '\n'

# ---------------------------------------------------------------- the table
# move -> [(SPECIES, level), ...]   levels follow mainline learnsets where the
# move is a level-up move there; TM-only moves are given to canonical TM users
# at a level that fits this game's pacing.
DIST = {
'OVERHEAT': [('CHARIZARD',62),('CHARIZARD_CLONE',62),('TYPHLOSION',62),('TYPHLOSION_HISUIAN',62),
    ('NINETALES',55),('ARCANINE',60),('ARCANINE_HISUIAN',60),('MAGCARGO',54),('CAMERUPT',58),
    ('TORKOAL',55),('MAGMORTAR',58),('CHANDELURE',62),('CENTISKORCH',58),('SALAZZLE',55),
    ('VOLCARONA',62),('ARMAROUGE',58),('TAUROS_PALDEAN_FIRE',55),('HOUNDOOM',58),('RAPIDASH',55),
    ('FLAREON',58),('MOLTRES',62)],
'LEAF_STORM': [('VENUSAUR',62),('VENUSAUR_CLONE',62),('MEGANIUM',62),('VILEPLUME',55),('BELLOSSOM',55),
    ('VICTREEBEL',55),('TANGROWTH',58),('SUNFLORA',50),('JUMPLUFF',50),('LUDICOLO',55),('TSAREENA',55),
    ('APPLETUN',58),('FLAPPLE',58),('HYDRAPPLE',62),('ABOMASNOW',58),('CRADILY',55),('BRELOOM',52),
    ('LEAFEON',58),('DIPPLIN',50),('EXEGGUTOR',55)],
'IRON_DEFENSE': [('FORRETRESS',34),('STEELIX',36),('SCIZOR',34),('SKARMORY',33),('MAGNETON',36),
    ('MAGNEZONE',40),('AGGRON',40),('LAIRON',34),('ARON',28),('BASTIODON',40),('SHIELDON',30),
    ('CORVIKNIGHT',36),('DURALUDON',38),('ARCHALUDON',42),('PERRSERKER',34),('KLEAVOR',32),
    ('GOLEM',40),('ONIX',30),('SHUCKLE',25),('TIRTOUGA',32),('CARRACOSTA',38),('BISHARP',38),
    ('KINGAMBIT',44),('MAWILE',32),('PINECO',25),('TINKATUFF',32),('TINKATON',38),('GOLEM_ALOLAN',40)],
'ROCK_POLISH': [('GEODUDE',25),('GRAVELER',28),('GOLEM',32),('GEODUDE_ALOLAN',25),('GRAVELER_ALOLAN',28),
    ('GOLEM_ALOLAN',32),('ONIX',28),('STEELIX',32),('RHYHORN',30),('RHYDON',34),('RHYPERIOR',38),
    ('SUDOWOODO',30),('CRANIDOS',28),('RAMPARDOS',34),('SHIELDON',28),('BASTIODON',34),('ARCHEN',30),
    ('ARCHEOPS',36),('TIRTOUGA',30),('CARRACOSTA',36),('GLIMMET',28),('GLIMMORA',34),('KLEAVOR',30),
    ('AERODACTYL',34),('MAGCARGO',30)],
'WOOD_HAMMER': [('SUDOWOODO',46),('VICTREEBEL',50),('TANGROWTH',52),('TSAREENA',50),('ABOMASNOW',52),
    ('CRADILY',50),('BRELOOM',46),('MEGANIUM',55),('LUDICOLO',50),('APPLETUN',52),('FLAPPLE',52),
    ('HYDRAPPLE',56),('SNOVER',44),('EXEGGUTOR',50),('BELLOSSOM',48),('SUNFLORA',46),('VENUSAUR',55),
    ('VENUSAUR_CLONE',55),('EXEGGUTOR_ALOLAN',50)],
'HEAD_SMASH': [('CRANIDOS',43),('RAMPARDOS',47),('AGGRON',55),('GOLEM',52),('RHYPERIOR',55),
    ('CARRACOSTA',52),('ARCHEOPS',52),('TYRANTRUM',54),('BASTIODON',52),('GLIMMORA',48),
    ('GOLEM_ALOLAN',52)],
'DRILL_RUN': [('DRILBUR',32),('EXCADRILL',40),('DODRIO',40),('DODUO',36),('SANDSLASH',40),
    ('SANDSHREW',34),('SANDSLASH_ALOLAN',40),('RHYDON',44),('RHYPERIOR',46),('NIDOKING',44),
    ('NIDOQUEEN',44),('BEEDRILL',38),('DUGTRIO',38),('DONPHAN',42),('STEELIX',42),('ONIX',36),
    ('CUBONE',34),('MAROWAK',38),('MAROWAK_ALOLAN',38),('PHANPY',32),('GLIGAR',36),('GLISCOR',42),
    ('DUGTRIO_ALOLAN',38)],
'PSYCHO_CUT': [('KADABRA',36),('ALAKAZAM',38),('GALLADE',36),('MEWTWO',50),('ESPEON',40),('XATU',38),
    ('WATU',34),('NATU',30),('MR__MIME',36),('MR__RIME',40),('FARIGIRAF',40),('GIRAFARIG',36),
    ('MESMERIA',38),('SLOWKING',42),('SLOWKING_GALARIAN',42),('HYPNO',40),('CERULEDGE',38)],
'SACRED_SWORD': [('SIRFETCH_D',46),('GALLADE',44),('LUCARIO',46),('BISHARP',46),('KINGAMBIT',52),
    ('KLEAVOR',44)],
'BRICK_BREAK': [('MACHOP',25),('MACHOKE',29),('MACHAMP',33),('HITMONLEE',30),('HITMONCHAN',30),
    ('HITMONTOP',30),('MANKEY',26),('PRIMEAPE',30),('ANNIHILAPE',34),('POLIWRATH',34),('HERACROSS',32),
    ('LUCARIO',32),('RIOLU',28),('TOXICROAK',32),('CROAGUNK',28),('SCRAFTY',32),('SCRAGGY',28),
    ('CONKELDURR',36),('GURDURR',32),('TIMBURR',28),('BRELOOM',30),('GALLADE',32),('SIRFETCH_D',34),
    ('PERRSERKER',32),('URSARING',36),('URSALUNA',40),('TAUROS',34),('KANGASKHAN',34),('GRIMMSNARL',36),
    ('PALAFIN',30),('GOLISOPOD',34),('TSAREENA',32),('BISHARP',34),('KINGAMBIT',38),('LOPUNNY',32),
    ('SNEASLER',32),('URSARINGBM',36),('URSALUNABM',40),('TYROGUE',24)],
'HEAT_WAVE': [('CHARIZARD',55),('CHARIZARD_CLONE',55),('NINETALES',50),('ARCANINE',52),
    ('ARCANINE_HISUIAN',52),('RAPIDASH',48),('MAGMAR',48),('MAGMORTAR',52),('MOLTRES',55),
    ('HOUNDOOM',50),('TYPHLOSION',55),('TYPHLOSION_HISUIAN',55),('CAMERUPT',50),('TORKOAL',48),
    ('CHANDELURE',52),('LAMPENT',44),('CENTISKORCH',50),('SALAZZLE',48),('VOLCARONA',52),
    ('TALONFLAME',46),('NOIVERN',48),('DRAGONITE',55),('HYDREIGON',55),('ARMAROUGE',50),
    ('CERULEDGE',50),('MAGCARGO',46),('ALTARIA',48),('TAUROS_PALDEAN_FIRE',48),('SIZZLIPEDE',44)],
'SNARL': [('HOUNDOUR',28),('HOUNDOOM',32),('UMBREON',34),('MURKROW',30),('HONCHKROW',36),('SNEASEL',30),
    ('WEAVILE',36),('SNEASEL_HISUIAN',30),('SNEASLER',36),('SCRAGGY',30),('SCRAFTY',34),('PAWNIARD',30),
    ('BISHARP',34),('KINGAMBIT',40),('DEINO',30),('ZWEILOUS',36),('HYDREIGON',42),('IMPIDIMP',28),
    ('MORGREM',32),('GRIMMSNARL',36),('MEOWTH_ALOLAN',28),('PERSIAN_ALOLAN',32),('ANNIHILAPE',36),
    ('OVERQWIL',34),('TYRANITAR',40),('MIMIKYU',34),('SEVIPER',32)],
'NUZZLE': [('PICHU',5),('PIKACHU',8),('RAICHU',8),('RAICHU_ALOLAN',8),('JOLTIK',8),('GALVANTULA',8),
    ('KOTORA',8),('RAITORA',8),('GOROTORA',8),('ELEKID',10),('MAREEP',8),('FLAAFFY',10),('AMPHAROS',10),
    ('CHINCHOU',10),('LANTURN',10),('JOLTEON',10),('CHARJABUG',10),('GRUBBIN',8),('VIKAVOLT',10)],
'BULLET_SEED': [('BELLSPROUT',13),('WEEPINBELL',15),('VICTREEBEL',15),('SHROOMISH',12),('BRELOOM',15),
    ('SUNKERN',13),('SUNFLORA',15),('HOPPIP',13),('SKIPLOOM',15),('JUMPLUFF',15),('BOUNSWEET',12),
    ('STEENEE',15),('TSAREENA',15),('LOTAD',13),('LOMBRE',15),('LUDICOLO',15),('SNOVER',14),
    ('ABOMASNOW',14),('LILEEP',14),('CRADILY',16),('EXEGGCUTE',14),('CHIKORITA',13),('BAYLEEF',15),
    ('MEGANIUM',15),('ODDISH',13),('GLOOM',15),('VILEPLUME',15),('BELLOSSOM',15),('TANGELA',14),
    ('TANGROWTH',14),('PARAS',12),('PARASECT',12)],
'DUALWINGBEAT': [('PIDGEOTTO',30),('PIDGEOT',34),('SPEAROW',28),('FEAROW',32),('NOCTOWL',34),
    ('GOLBAT',30),('CROBAT',34),('SCYTHER',32),('SCIZOR',34),('KLEAVOR',34),('TALONFLAME',34),
    ('FLETCHINDER',30),('CORVISQUIRE',30),('CORVIKNIGHT',36),('NOIBAT',30),('NOIVERN',36),
    ('SKARMORY',34),('ARCHEN',30),('ARCHEOPS',36),('MURKROW',30),('HONCHKROW',34),('DODUO',28),
    ('DODRIO',32),('SWABLU',28),('ALTARIA',34),('YANMA',30),('YANMEGA',34),('DRAGONITE',40),
    ('XATU',32),('DELIBIRD',30),('GLIGAR',30),('GLISCOR',36),('VOLCARONA',38),('LEDIAN',30),
    ('BUTTERFREE',30),('BEEDRILL',30),('MANTINE',32),('TOGETIC',32),('TOGEKISS',36),('FARFETCH_D',30),
    ('ROOKIDEE',26),('DREEPY',30),('DRAKLOAK',34),('DRAGAPULT',38),('SALAMENCE',40),('AERODACTYL',36),
    ('MOLTRES',40),('ARTICUNO',40),('ZAPDOS',40),('LUGIA',44),('HO_OH',44),('DRIFBLIM',32)],
'ROCK_TOMB': [('GEODUDE',18),('GRAVELER',20),('GOLEM',20),('GEODUDE_ALOLAN',18),('GRAVELER_ALOLAN',20),
    ('GOLEM_ALOLAN',20),('ONIX',18),('STEELIX',22),('RHYHORN',20),('RHYDON',22),('RHYPERIOR',24),
    ('SUDOWOODO',20),('SHUCKLE',18),('OMANYTE',20),('OMASTAR',22),('KABUTO',20),('KABUTOPS',22),
    ('AERODACTYL',22),('LARVITAR',20),('PUPITAR',22),('TYRANITAR',24),('CRANIDOS',20),('RAMPARDOS',22),
    ('SHIELDON',20),('BASTIODON',22),('ARCHEN',20),('ARCHEOPS',22),('TIRTOUGA',20),('CARRACOSTA',22),
    ('GLIMMET',20),('GLIMMORA',22),('MAGCARGO',20),('SLUGMA',18),('CORSOLA',20),('CORSOLA_GALARIAN',20),
    ('CURSOLA',22),('GOLETT',20),('GOLURK',22),('KLEAVOR',22),('TYRUNT',20),('TYRANTRUM',22),
    ('AMAURA',20),('AURORUS',22),('DRILBUR',20),('EXCADRILL',22),('ANORITH',20),('ARMALDO',22),
    ('LILEEP',20),('CRADILY',22)],
'LOW_SWEEP': [('MACHOP',18),('MACHOKE',20),('MACHAMP',20),('MANKEY',18),('PRIMEAPE',20),
    ('ANNIHILAPE',22),('HITMONLEE',20),('HITMONTOP',20),('HITMONCHAN',20),('TYROGUE',16),
    ('POLIWHIRL',20),('POLIWRATH',22),('HERACROSS',20),('RIOLU',18),('LUCARIO',20),('CROAGUNK',18),
    ('TOXICROAK',20),('SCRAGGY',18),('SCRAFTY',20),('TIMBURR',18),('GURDURR',20),('CONKELDURR',22),
    ('BRELOOM',20),('GALLADE',20),('SIRFETCH_D',22),('GRIMMSNARL',22),('MORGREM',20),('IMPIDIMP',18),
    ('PALAFIN',22),('GOLISOPOD',22),('TSAREENA',20),('PERRSERKER',20),('SNEASLER',20),('KLEAVOR',20),
    ('LOPUNNY',20),('PAWNIARD',18),('BISHARP',20)],
'MUD_SHOT': [('WOOPER',16),('QUAGSIRE',18),('WOOPER_PALDEAN',16),('CLODSIRE',20),('GEODUDE',16),
    ('GRAVELER',18),('GOLEM',18),('DIGLETT',16),('DUGTRIO',18),('SANDSHREW',16),('SANDSLASH',18),
    ('RHYHORN',18),('RHYDON',20),('RHYPERIOR',22),('PHANPY',16),('DONPHAN',18),('SWINUB',16),
    ('PILOSWINE',18),('MAMOSWINE',20),('GLIGAR',18),('GLISCOR',20),('TRAPINCH',16),('VIBRAVA',18),
    ('FLYGON',20),('DRILBUR',16),('EXCADRILL',18),('GOLETT',18),('GOLURK',20),('LARVITAR',18),
    ('PUPITAR',20),('TYRANITAR',22),('ONIX',16),('STEELIX',18),('CUBONE',16),('MAROWAK',18),
    ('NUMEL',16),('CAMERUPT',18),('GLIMMET',18),('GLIMMORA',20),('MAROWAK_ALOLAN',18)],
'CROSS_POISON': [('BEEDRILL',40),('GOLBAT',38),('CROBAT',42),('SEVIPER',40),('QWILFISH',38),
    ('OVERQWIL',42),('VENIPEDE',32),('WHIRLIPEDE',36),('SCOLIPEDE',42),('ARIADOS',38),('TOXICROAK',40),
    ('MAREANIE',36),('TOXAPEX',42),('SALAZZLE',40),('NIDOKING',42),('NIDOQUEEN',42),('TENTACRUEL',40),
    ('MUK',42),('MUK_ALOLAN',42),('SNEASLER',42),('DRUNSPARCE',40)],
'SIGNAL_BEAM': [('VENOMOTH',38),('BUTTERFREE',36),('LEDIAN',36),('ARIADOS',36),('YANMA',36),
    ('YANMEGA',40),('VOLCARONA',42),('LARVESTA',36),('JOLTIK',34),('GALVANTULA',38),('CHARJABUG',36),
    ('VIKAVOLT',40),('GRUBBIN',32),('PORYGON',36),('PORYGON2',40),('PORYGON_Z',42),('MAGNETON',36),
    ('MAGNEZONE',40),('ELECTRODE',36),('ELECTRODE_HISUIAN',36),('LANTURN',36),('CHINCHOU',32),
    ('XATU',36),('ESPEON',38),('MESMERIA',38),('MEWTWO',46),('ARMALDO',38)],
'SCALE_SHOT': [('DRATINI',34),('DRAGONAIR',38),('DRAGONITE',42),('BAGON',36),('SHELGON',40),
    ('SALAMENCE',44),('AXEW',34),('FRAXURE',38),('HAXORUS',42),('DEINO',36),('ZWEILOUS',40),
    ('HYDREIGON',44),('TYRUNT',36),('TYRANTRUM',40),('FRIGIBAX',34),('ARCTIBAX',38),('BAXCALIBUR',42),
    ('DREEPY',34),('DRAKLOAK',38),('DRAGAPULT',42),('ALTARIA',40),('KINGDRA',42),('SEADRA',38),
    ('HORSEA',34),('GYARADOS',42),('DURALUDON',40),('ARCHALUDON',44),('NOIBAT',34),('NOIVERN',40),
    ('DRUNSPARCE',40),('FLAPPLE',40),('APPLETUN',40),('HYDRAPPLE',44)],
'PHANTOMFORCE': [('GASTLY',38),('HAUNTER',42),('GENGAR',46),('MISDREAVUS',42),('MISMAGIUS',46),
    ('DUSKULL',40),('DUSCLOPS',44),('DUSKNOIR',48),('SHUPPET',38),('BANETTE',44),('DRIFLOON',40),
    ('DRIFBLIM',44),('GOLETT',42),('GOLURK',46),('MIMIKYU',44),('CURSOLA',44),('CORSOLA_GALARIAN',40),
    ('DREEPY',40),('DRAKLOAK',44),('DRAGAPULT',48),('LITWICK',38),('LAMPENT',42),('CHANDELURE',46),
    ('CERULEDGE',44),('FROSLASS',44),('ANNIHILAPE',44),('TYPHLOSION_HISUIAN',46),('MAROWAK_ALOLAN',44)],
'HEADLONGRUSH': [('URSALUNA',55),('URSALUNABM',55)],
'SHADOW_BONE': [('MAROWAK_ALOLAN',42)],
'DIRE_CLAW': [('SNEASLER',50)],
'BARB_BARRAGE': [('OVERQWIL',50)],
'INFERNAL_PARADE': [('TYPHLOSION_HISUIAN',50)],
'KOWTOW_CLEAVE': [('KINGAMBIT',50)],
'ARMOR_CANNON': [('ARMAROUGE',54)],
'SHELLSIDEARM': [('SLOWBRO_GALARIAN',48)],
'GLAIVE_RUSH': [('BAXCALIBUR',55)],
'DRAGON_DARTS': [('DRAGAPULT',54)],
'APPLE_ACID': [('APPLETUN',44),('DIPPLIN',44),('HYDRAPPLE',44)],
'GRAV_APPLE': [('FLAPPLE',44)],
'PSYSHIELD': [('WYRDEER',50)],
'RAGING_FURY': [('ARCANINE',48),('ARCANINE_HISUIAN',48),('RAPIDASH',46),('CHARIZARD',50),
    ('MAGMORTAR',48),('HOUNDOOM',46),('TYPHLOSION_HISUIAN',48),('CAMERUPT',46),
    ('TAUROS_PALDEAN_FIRE',46),('CENTISKORCH',46)],
'STRANGESTEAM': [('WEEZING_GALARIAN',46)],
'EERIE_SPELL': [('SLOWKING_GALARIAN',48)],
'BANEFUL_BUNKER': [('MAREANIE',40),('TOXAPEX',44)],
'RAGING_BULL': [('TAUROS',44),('TAUROS_PALDEAN_FIRE',44),('TAUROS_PALDEAN_WATER',44)],
'FICKLE_BEAM': [('HYDRAPPLE',50)],
'STONE_AXE': [('KLEAVOR',50)],
'QUIVER_DANCE': [('VOLCARONA',50),('LARVESTA',50),('VENOMOTH',42),('BUTTERFREE',42),('LEDIAN',40)],
'STEALTH_ROCK': [('GEODUDE',30),('GRAVELER',34),('GOLEM',38),('GEODUDE_ALOLAN',30),
    ('GRAVELER_ALOLAN',34),('GOLEM_ALOLAN',38),('ONIX',32),('STEELIX',36),('RHYHORN',32),('RHYDON',36),
    ('RHYPERIOR',40),('SUDOWOODO',34),('SHUCKLE',30),('OMANYTE',32),('OMASTAR',36),('KABUTO',32),
    ('KABUTOPS',36),('AERODACTYL',36),('LARVITAR',32),('PUPITAR',36),('TYRANITAR',40),('CRANIDOS',32),
    ('RAMPARDOS',36),('SHIELDON',32),('BASTIODON',36),('ARCHEN',32),('ARCHEOPS',36),('TIRTOUGA',32),
    ('CARRACOSTA',36),('GLIMMET',32),('GLIMMORA',36),('MAGCARGO',34),('CORSOLA',32),('CURSOLA',36),
    ('SKARMORY',36),('FORRETRESS',34),('TYRUNT',32),('TYRANTRUM',36),('AMAURA',32),('AURORUS',36),
    ('ANORITH',32),('ARMALDO',36),('LILEEP',32),('CRADILY',36),('KLEAVOR',36),('ARON',30),('LAIRON',34),
    ('AGGRON',38),('DRILBUR',30),('EXCADRILL',34)],
'DEFOG': [('PIDGEOTTO',32),('PIDGEOT',36),('NOCTOWL',34),('CROBAT',36),('SKARMORY',34),('MANTINE',32),
    ('TOGETIC',34),('TOGEKISS',38),('XATU',34),('ALTARIA',36),('CORVISQUIRE',32),('CORVIKNIGHT',38),
    ('ROOKIDEE',28),('FLETCHINDER',32),('TALONFLAME',36),('NOIBAT',32),('NOIVERN',38),('GLISCOR',36),
    ('DRIFLOON',30),('DRIFBLIM',34),('YANMEGA',34),('DELIBIRD',30),('HONCHKROW',34),('ARCHEOPS',36),
    ('SWABLU',30),('DRAKLOAK',36),('DRAGAPULT',40)],
'BODY_PRESS': [('STEELIX',44),('FORRETRESS',42),('SKARMORY',42),('AGGRON',46),('LAIRON',40),
    ('ARON',34),('BASTIODON',44),('SHUCKLE',40),('GOLEM',44),('GOLEM_ALOLAN',44),('RHYPERIOR',46),
    ('ONIX',40),('MAGNEZONE',44),('CORVIKNIGHT',44),('DURALUDON',44),('ARCHALUDON',48),
    ('CONKELDURR',44),('GURDURR',40),('MACHAMP',44),('HITMONTOP',40),('TOXAPEX',42),('CARRACOSTA',44),
    ('CLODSIRE',42),('MAWILE',40),('TINKATON',44),('KINGAMBIT',48),('PERRSERKER',40),('GOLURK',44),
    ('CETITAN',44),('WALREIN',44),('DONPHAN',42)],
'WORK_UP': [('RATICATE',26),('FURRET',26),('TAUROS',28),('KANGASKHAN',28),('SNORLAX',30),
    ('URSARING',30),('URSALUNA',34),('MILTANK',28),('STANTLER',26),('WYRDEER',30),('PRIMEAPE',26),
    ('ANNIHILAPE',30),('MACHOKE',26),('MACHAMP',28),('HERACROSS',28),('SCYTHER',26),('SCIZOR',28),
    ('GRANBULL',28),('SNUBBULL',24),('LOPUNNY',26),('DRUNSPARCE',26),('DUNSPARCE',24),('CETODDLE',26),
    ('CETITAN',30),('ZANGOOSE',26),('PALAFIN',28),('TEDDIURSABM',26),('URSARINGBM',30),
    ('URSALUNABM',34),('RATICATE_ALOLAN',26)],
'SUPERPOWER': [('MACHAMP',50),('CONKELDURR',50),('HERACROSS',48),('SNORLAX',50),('URSARING',46),
    ('URSALUNA',50),('KANGASKHAN',46),('TAUROS',46),('RHYPERIOR',50),('GOLEM',48),('AGGRON',50),
    ('TYRANITAR',50),('SALAMENCE',50),('HAXORUS',50),('KINGLER',46),('DRUNSPARCE',46),('SCOLIPEDE',46),
    ('GOLISOPOD',48),('TOXICROAK',44),('SCRAFTY',46),('PRIMEAPE',46),('ANNIHILAPE',50),
    ('HITMONLEE',46),('POLIWRATH',46),('GURDURR',46),('CETITAN',48),('WALREIN',48),('GRIMMSNARL',48),
    ('PALAFIN',48),('ARCHALUDON',50),('KINGAMBIT',52),('PERRSERKER',44),('SIRFETCH_D',46),
    ('MAMOSWINE',48),('DONPHAN',46),('EXCADRILL',46),('BASTIODON',48),('CARRACOSTA',48),('PINSIR',46),
    ('URSARINGBM',46),('URSALUNABM',50),('GOLEM_ALOLAN',48)],
'FIERY_DANCE': [('VOLCARONA',54),('LARVESTA',54)],
'FOUL_PLAY': [('UMBREON',40),('SNEASEL',38),('WEAVILE',42),('SNEASEL_HISUIAN',38),('SNEASLER',44),
    ('MURKROW',36),('HONCHKROW',40),('HOUNDOOM',40),('TYRANITAR',44),('SCRAFTY',40),('BISHARP',42),
    ('KINGAMBIT',46),('ZWEILOUS',42),('HYDREIGON',46),('MISDREAVUS',36),('MISMAGIUS',40),
    ('BANETTE',40),('IMPIDIMP',34),('MORGREM',38),('GRIMMSNARL',42),('MEOWTH_ALOLAN',34),
    ('PERSIAN_ALOLAN',38),('OVERQWIL',42),('ANNIHILAPE',42),('CURSOLA',40),('MIMIKYU',40),
    ('SEVIPER',40),('DRUNSPARCE',38)],
'RAGE_FIST': [('MANKEY',35),('PRIMEAPE',35),('ANNIHILAPE',35)],
'CRUSH_CLAW': [('ZANGOOSE',34),('SANDSLASH',32),('SANDSLASH_ALOLAN',32),('PERSIAN',32),
    ('PERSIAN_ALOLAN',32),('ARCANINE',34),('ARCANINE_HISUIAN',34),('WEAVILE',34),('SNEASEL',30),
    ('SNEASLER',34),('KANGASKHAN',32),('TAUROS',32),('URSARING',34),('URSALUNA',38),('MEOWTH',28),
    ('MEOWTH_ALOLAN',28),('MEOWTH_GALARIAN',28),('PERRSERKER',32),('URSARINGBM',34),('URSALUNABM',38),
    ('TEDDIURSA',28),('TEDDIURSABM',28)],
'FORCE_PALM': [('RIOLU',24),('LUCARIO',26),('MACHOP',22),('MACHOKE',24),('MACHAMP',24),('TIMBURR',24),
    ('GURDURR',26),('CONKELDURR',26),('CROAGUNK',24),('TOXICROAK',26),('HITMONCHAN',26),('GALLADE',26),
    ('PALAFIN',26),('SIRFETCH_D',26),('GRIMMSNARL',26)],
'HAMMER_ARM': [('MACHAMP',42),('CONKELDURR',42),('GURDURR',38),('TIMBURR',34),('HITMONCHAN',40),
    ('HERACROSS',40),('GOLEM',42),('RHYPERIOR',44),('AGGRON',44),('SNORLAX',44),('URSARING',42),
    ('URSALUNA',46),('TINKATON',42),('TINKATUFF',38),('MAWILE',38),('GRIMMSNARL',42),('KINGAMBIT',44),
    ('ARCHALUDON',44),('DURALUDON',40),('GOLURK',42),('CETITAN',42),('PALAFIN',42),('URSARINGBM',42),
    ('URSALUNABM',46),('GOLEM_ALOLAN',42)],
'CIRCLE_THROW': [('HITMONTOP',38),('HITMONLEE',38),('MACHOKE',36),('MACHAMP',38),('POLIWRATH',38),
    ('HERACROSS',36),('SCRAFTY',36),('GALLADE',38),('SIRFETCH_D',38),('GRIMMSNARL',38),('LUCARIO',38),
    ('TSAREENA',36),('PALAFIN',38),('ANNIHILAPE',38)],
'FREEZE_DRY': [('LAPRAS',40),('DEWGONG',38),('CLOYSTER',40),('WALREIN',42),('SEALEO',38),('SPHEAL',34),
    ('GLACEON',40),('FROSLASS',40),('ABOMASNOW',40),('SNOVER',34),('AURORUS',40),('AMAURA',34),
    ('CETITAN',40),('CETODDLE',34),('DELIBIRD',34),('MAMOSWINE',40),('PILOSWINE',36),('ARTICUNO',44),
    ('JYNX',38),('SMOOCHUM',32),('ARCTIBAX',38),('BAXCALIBUR',42),('FRIGIBAX',34),
    ('NINETALES_ALOLAN',40),('VULPIX_ALOLAN',34),('SANDSLASH_ALOLAN',38),('WEAVILE',38),('SNEASEL',34)],
'BOUNCE': [('HOPPIP',26),('SKIPLOOM',28),('JUMPLUFF',30),('AIPOM',28),('AMBIPOM',32),('BUNEARY',28),
    ('LOPUNNY',32),('SPOINK',26),('GRUMPIG',30),('IGGLYBUFF',24),('JIGGLYPUFF',26),('WIGGLYTUFF',30),
    ('MARILL',26),('AZUMARILL',30),('TOGETIC',30),('TOGEKISS',34),('DELIBIRD',28),('GLIGAR',30),
    ('GLISCOR',34),('DRIFLOON',28),('DRIFBLIM',32),('MANTINE',30),('SWABLU',28),('ALTARIA',32),
    ('DODRIO',30),('SUDOWOODO',28),('POLITOED',30)],
'DRAGON_TAIL': [('DRATINI',36),('DRAGONAIR',40),('DRAGONITE',44),('BAGON',38),('SHELGON',42),
    ('SALAMENCE',46),('AXEW',36),('FRAXURE',40),('HAXORUS',44),('DEINO',38),('ZWEILOUS',42),
    ('HYDREIGON',46),('TYRUNT',38),('TYRANTRUM',42),('FRIGIBAX',36),('ARCTIBAX',40),('BAXCALIBUR',44),
    ('DREEPY',36),('DRAKLOAK',40),('DRAGAPULT',44),('KINGDRA',44),('SEADRA',40),('HORSEA',36),
    ('GYARADOS',44),('ALTARIA',42),('CHARIZARD',44),('CHARIZARD_CLONE',44),('ARCHALUDON',46),
    ('DURALUDON',42),('NOIBAT',36),('NOIVERN',42),('DRUNSPARCE',42),('STEELIX',42),('ONIX',38),
    ('MILOTIC',42),('FERALIGATR',44),('TYRANITAR',44),('SEVIPER',40),('EKANS',36),('ARBOK',40)],
}

# ---------------------------------------------------------------- validation
species_order = []
for line in read('constants/pokemon_constants.asm').split('\n'):
    if line.startswith('; Unown forms'): break
    m = re.match(r'\s*const\s+([A-Z_0-9]+)', line)
    if m: species_order.append(m.group(1))
SPECIES = {s: i + 1 for i, s in enumerate(species_order)}
MOVES = set()
for line in read('constants/move_constants.asm').split('\n'):
    m = re.match(r'\s*const\s+([A-Z_0-9]+)', line)
    if m: MOVES.add(m.group(1))

errs = []
for mv, lst in DIST.items():
    if mv not in MOVES: errs.append('unknown move ' + mv)
    for sp, lv in lst:
        if sp not in SPECIES: errs.append('unknown species %s (for %s)' % (sp, mv))
        if not 1 <= lv <= 100: errs.append('bad level %s %s %s' % (mv, sp, lv))
if errs:
    for e in errs[:40]: print('ERROR:', e)
    raise SystemExit('aborting: %d validation errors' % len(errs))

# ---------------------------------------------------------------- section split
JF = 'data/pokemon/evos_attacks_johto.asm'
txt = read(JF); nl = nl_of(txt)
if 'SECTION "Evolutions and Attacks 2E"' not in txt:
    lines = txt.split(nl)
    def find(pred, start=0):
        for i in range(start, len(lines)):
            if pred(lines[i]): return i
        raise SystemExit('split: anchor not found')
    i_2e_list = find(lambda l: l.startswith('EvosAttacksPointers2E::'))
    # the 2E pointer list runs until the first blank line followed by a block label
    i_2e_end = i_2e_list + 1
    while lines[i_2e_end].strip().startswith('dw '): i_2e_end += 1
    ptr2e = lines[i_2e_list:i_2e_end]
    i_honch = find(lambda l: l.startswith('HonchkrowEvosAttacks:'))
    i_lairon = find(lambda l: l.startswith('LaironEvosAttacks:'))
    # strip the trailing comment lines that introduced the 2E list
    head = lines[:i_2e_list]
    while head and head[-1].strip() == '': head.pop()
    if head and head[-1].startswith('; CHARMANDER_CLONE'): pass
    tail_comment = []
    j = i_2e_end
    while j < len(lines) and lines[j].strip() == '': j += 1
    blocks_2e = lines[i_honch:i_lairon]
    while blocks_2e and blocks_2e[-1].strip() == '': blocks_2e.pop()
    johto_blocks = lines[j:i_honch]
    rest = lines[i_lairon:]
    new = (head + [''] + johto_blocks + rest + ['', '',
           'SECTION "Evolutions and Attacks 2E", ROMX', '',
           '; This pointer block must stay in the same bank as the data it points to.']
           + ptr2e + [''] + blocks_2e + [''])
    write(JF, nl.join(new))
    print('split: moved EvosAttacksPointers2E + %d lines of data into a new section'
          % len(blocks_2e))
else:
    print('split: already done')

# ---------------------------------------------------------------- species -> label
GROUPS = []
for line in read('data/pokemon/evos_attacks.asm').split('\n'):
    m = re.match(r'\s*indirect_entries\s+([A-Z_0-9]+),\s*(EvosAttacksPointers\w*)', line)
    if m: GROUPS.append((m.group(1), m.group(2)))

FILES = ['data/pokemon/evos_attacks_kanto.asm', 'data/pokemon/evos_attacks_johto.asm',
         'data/pokemon/evos_attacks_clones.asm']
alltext = {f: read(f) for f in FILES}
listing = {}
for f, t in alltext.items():
    cur = None
    for line in t.split('\n'):
        m = re.match(r'(EvosAttacksPointers\w*)::', line)
        if m: cur = m.group(1); listing.setdefault(cur, [])
        elif cur is not None:
            m = re.match(r'\s*dw\s+(\w+EvosAttacks)\s*$', line)
            if m: listing[cur].append(m.group(1))
            elif line.strip() and not line.strip().startswith(';'): cur = None

label_of = {}
lo = 1
for maxname, ptr in GROUPS:
    hi = len(species_order) if maxname == 'NUM_POKEMON' else SPECIES[maxname]
    labels = listing.get(ptr, [])
    span = hi - lo + 1
    if len(labels) != span:
        raise SystemExit('group %s: %d labels for %d species' % (ptr, len(labels), span))
    for k, sp in enumerate(species_order[lo - 1:hi]): label_of[sp] = labels[k]
    lo = hi + 1

# ---------------------------------------------------------------- insertion
by_label = collections.defaultdict(list)
for mv, lst in DIST.items():
    for sp, lv in lst: by_label[label_of[sp]].append((lv, mv))

added = skipped = 0
for f in FILES:
    t = alltext[f] if 'SECTION "Evolutions and Attacks 2E"' not in alltext[f] else read(f)
    t = read(f)
    n = nl_of(t)
    lines = t.split(n)
    out = []
    i = 0
    while i < len(lines):
        line = lines[i]
        m = re.match(r'^(\w+EvosAttacks):\s*$', line)
        if not m or m.group(1) not in by_label:
            out.append(line); i += 1; continue
        label = m.group(1)
        out.append(line); i += 1
        # evolution section, ends at the first "db 0"
        while not lines[i].strip().startswith('db 0'):
            out.append(lines[i]); i += 1
        out.append(lines[i]); i += 1          # db 0 ; no more evolutions
        moves = []
        while not lines[i].strip().startswith('db 0'):
            mm = re.match(r'\s*dbw\s+(\d+),\s*([A-Z_0-9]+)', lines[i])
            if mm: moves.append((int(mm.group(1)), mm.group(2)))
            i += 1
        have = {mv for _, mv in moves}
        for lv, mv in sorted(by_label[label]):
            if mv in have: skipped += 1; continue
            moves.append((lv, mv)); added += 1
        moves.sort(key=lambda x: x[0])
        for lv, mv in moves: out.append('\tdbw %d, %s' % (lv, mv))
        out.append(lines[i]); i += 1          # db 0 ; no more level-up moves
    write(f, n.join(out))

print('added %d level-up entries (%d already present)' % (added, skipped))
print('moves distributed: %d   species touched: %d' % (len(DIST), len(by_label)))
