"""Generate the TM / held-item guide from the current ROM source.

Run independently without rebuilding sprite assets:
    python tools/generate_item_locations.py
"""
from collections import defaultdict
from pathlib import Path
import argparse
import json
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "crimson-crystal-docs"))

from generate_docs import Builder, disp, form_label, pretty_location


# These items check their identity rather than an ItemAttributes held effect.
IDENTITY_HELD = set("LUCKY_PUNCH EXP_SHARE LIGHT_BALL UP_GRADE BRICK_PIECE "
                    "THICK_CLUB LUCKY_EGG STICK EVERSTONE DRAGON_SCALE BERSERK_GENE".split())

# Player-facing requirements for scripted gifts. Item IDs and placements are
# extracted, never supplied by this table; unused notes fail validation.
GIFT_NOTES = {
    'AzaleaGym:TM_FURY_CUTTER': 'Bugsy; defeat him and collect the Hive Badge.',
    'BillsHouse:EVERSTONE': "Bill’s grandfather; show him Lickitung. House on Route 25.",
    'BlackthornCity:TWISTEDSPOON': 'Santos; Saturday.',
    'BlackthornGym1F:TM_DRAGON_CLAW': 'Clair; return after receiving the Rising Badge in Dragon’s Den.',
    'CeladonCafe:LEFTOVERS': 'Search the café trash can; one-time pickup.',
    'CeladonGameCornerPrizeRoom:TM_SWAGGER': 'TM prize counter; 1,500 coins and a Coin Case.',
    'CeladonGameCornerPrizeRoom:TM_PSYCHIC_M': 'TM prize counter; 3,500 coins and a Coin Case.',
    'CeladonGameCornerPrizeRoom:TM_HYPER_BEAM': 'TM prize counter; 7,500 coins and a Coin Case.',
    'CeladonGym:TM_ENERGY_BALL': 'Erika; defeat her and collect the Rainbow Badge.',
    'CeladonMansionRoofHouse:TM_CURSE': 'Listen to the man’s story at night.',
    'CharcoalKiln:CHARCOAL': 'Apprentice in Azalea Town; after receiving HM Cut from the Farfetch’d quest.',
    'CherrygroveCity:MYSTIC_WATER': 'Man on the offshore island; Surf to him.',
    'CianwoodCity:TM_WEATHER_BALL': 'Weather-loving old man; talk to him for a one-time gift.',
    'CianwoodGym:TM_DRAIN_PUNCH': 'Chuck; defeat him and collect the Storm Badge.',
    'DarkCaveBlackthornEntrance:BLACKGLASSES': 'Talk to the pharmacist in the Blackthorn-side chamber.',
    'DragonsDenB1F:TM_DRAGON_PULSE': 'Clair’s scene after passing the Dragon Shrine test.',
    'DragonsDenB1F:DRAGON_FANG': 'Ground pickup; reach the item ball using Surf and Whirlpool.',
    'EcruteakGym:TM_SHADOW_BALL': 'Morty; defeat him and collect the Fog Badge.',
    'ElmsLab:EVERSTONE': 'Professor Elm in New Bark Town; show him the hatched Togepi.',
    'FastShipCabins_SE_SSE_CaptainsCabin:METAL_COAT': 'Grandfather aboard the S.S. Aqua; find his granddaughter. The two script paths award the same one-time gift.',
    'FuchsiaGym:TM_TOXIC': 'Janine; defeat her and collect the Soul Badge.',
    'GoldenrodDeptStore5F:TM_RETURN': 'Sunday receptionist; first party Pokémon’s happiness must be at least 150. Shares the weekly gift flag with Facade.',
    'GoldenrodDeptStore5F:TM_FACADE': 'Sunday receptionist; first party Pokémon’s happiness must be below 50. Shares the weekly gift flag with Return; happiness 50–149 gives neither.',
    'GoldenrodGameCorner:TM_THUNDER': 'TM prize counter; 5,500 coins and a Coin Case.',
    'GoldenrodGameCorner:TM_BLIZZARD': 'TM prize counter; 5,500 coins and a Coin Case.',
    'GoldenrodGameCorner:TM_FIRE_BLAST': 'TM prize counter; 5,500 coins and a Coin Case.',
    'GoldenrodGym:TM_ATTRACT': 'Whitney; talk to her again after winning and collect the Plain Badge.',
    'GoldenrodUnderground:LOADED_DICE': 'Girl rescued from the thugs; complete her reward conversation after defeating them. She also gives the dice if you decline Riolu.',
    'GravekeepersHouse:SPELL_TAG': 'Gravekeeper in Silent Crypt; clean both gravestones before entering his house.',
    'IlexForest:TM_HEADBUTT': 'Headbutt tutor in the forest; accept his gift.',
    'LakeOfRage:BLACKBELT': 'Wesley; Wednesday.',
    'LakeOfRageHiddenPowerHouse:TM_HIDDEN_POWER': 'Man in the northwest house; reach the house through the forest route.',
    'MahoganyGym:TM_ICICLE_CRASH': 'Pryce; defeat him and collect the Glacier Badge.',
    'MrPokemonsHouse:EXP_SHARE': 'Mr. Pokémon on Route 30; exchange the Red Scale from the Lake of Rage Gyarados.',
    'MrPsychicsHouse:TM_ZEN_HEADBUTT': 'Mr. Psychic in Saffron City; talk to him.',
    'NationalPark:QUICK_CLAW': 'Teacher beside Persian; talk to her for a one-time gift.',
    'OlivineGym:TM_IRON_HEAD': 'Jasmine; defeat her after healing the lighthouse Ampharos.',
    'OlivineGym:METAL_COAT': 'Jasmine; additional gift after her Iron Head TM.',
    'PowerPlant:TM_ZAP_CANNON': 'Manager; return the stolen Machine Part.',
    'RadioTower1F:EXP_SHARE': 'Lucky Number Show second prize; last three or four trainer-ID digits match the drawn number (all five gives the first prize). One prize per week.',
    'RadioTower3F:TM_SUNNY_DAY': 'Woman on 3F; after clearing Team Rocket from the Radio Tower.',
    'RadioTower4F:PINK_BOW': 'DJ Mary; after clearing Team Rocket from the Radio Tower.',
    'Route25:SCOPE_LENS': 'Cooltrainer Kevin at the end of Nugget Bridge’s trainer gauntlet; reward before his battle.',
    'Route27SandstormHouse:TM_SANDSTORM': 'Woman in the house; first party Pokémon’s happiness must be at least 150.',
    'Route28SteelWingHouse:TM_STEEL_WING': 'Celebrity in the house; talk to her.',
    'Route29:PINK_BOW': 'Tuscany; Tuesday.',
    'Route31:TM_HONE_CLAWS': 'Sleepy mail recipient; deliver the accepted mail from the Route 35 gate’s Kenya quest.',
    'Route32:MIRACLE_SEED': 'Man near the Violet entrance; have the Zephyr Badge and receive the Togepi Egg from Elm’s aide.',
    'Route32:TM_ROAR': 'Talk to the Roar TM man; one-time gift.',
    'Route32:POISON_BARB': 'Frieda; Friday.',
    'Route34:SOFT_SAND': 'Cooltrainer Kate on the southern beach; speak again after defeating her. Surf to the beach.',
    'Route34IlexForestGate:TM_SWEET_SCENT': 'Teacher in the gate; talk to her.',
    'Route36:TM_ROCK_SMASH': 'Man near Sudowoodo; after clearing Sudowoodo.',
    'Route36:HARD_STONE': 'Arthur; Thursday.',
    'Route37:MAGNET': 'Sunny; Sunday.',
    'Route39Farmhouse:TM_WORK_UP': 'Female farmer; heal Moomoo the Miltank first.',
    'Route40:SHARP_BEAK': 'Monica; Monday.',
    'Route43:PINK_BOW': 'Picnicker Tiffany’s phone gift; register her number and return when she calls with a gift.',
    'Route43Gate:TM_SLUDGE_BOMB': 'Guard; available after clearing the Mahogany Rocket Hideout.',
    'Route5CleanseTagHouse:CLEANSE_TAG': 'Granny in the house; talk to her.',
    'SilphCo1F:UP_GRADE': 'Officer inside Silph Co. in Saffron City; talk to him.',
    'SlowpokeWellB2F:KINGS_ROCK': 'Man on B2F; reach him with Surf and Strength.',
    'ViridianCity:TM_NASTY_PLOT': 'Fisher in the southwest area; one-time gift.',
    'VioletGym:TM_MUD_SLAP': 'Falkner; defeat him and collect the Zephyr Badge.',
}

PICKUP_NOTES = {
    'BurnedTowerB1F': 'Basement item ball.',
    'DarkCaveBlackthornEntrance': 'Blackthorn-side chamber; Flash helps navigation.',
    'GoldenrodDeptStoreB1F': 'Basement item ball; access depends on the moving-box layout and the warehouse passage.',
    'GoldenrodUndergroundSwitchRoomEntrances': 'Item ball in the underground switch-room area.',
    'GoldenrodUndergroundWarehouse': 'Warehouse item ball reached during the Radio Tower rescue.',
    'IcePathB2FBlackthornSide': 'Item ball on the Blackthorn-side B2F.',
    'LakeOfRage': 'Northern shore item ball; approach through the Route 43 forest.',
    'MountMortar2FInside': 'Upper interior; Surf and Waterfall are needed to reach this floor.',
    'NationalPark': 'Outside the fence; enter through the gap in the fence.',
    'NationalParkBugContest': 'Same Dig pickup as the ordinary National Park map; shared event, not a second copy.',
    'Route27': 'Item ball beyond the whirlpool; Surf and Whirlpool.',
    'RuinsOfAlphHoOhItemRoom': 'Ho-Oh puzzle’s secret chamber; put Ho-Oh first in the party to open the passage.',
    'RuinsOfAlphOmanyteItemRoom': 'Omanyte puzzle’s secret chamber; have a Water Stone in the Bag or held by a party Pokémon at its inscription.',
    'SlowpokeWellB2F': 'B2F item ball; Surf and Strength.',
}


def generate(repo, builder=None):
    repo = Path(repo).resolve()
    b = builder or Builder(repo)
    order, names = b.species()
    b.tm_index = b.tm_table()
    mons = b.base_stats(order, names)
    wild = b.wild(set(mons))
    item_names = b.item_names()
    item_names['EXP_SHARE'] = 'Exp. Share'
    tm = {'TM_' + mv: (n, mv) for mv, n in b.tm_index.items() if n.startswith('TM')}
    move_names = {m['const']: m['name'] for m in b.moves()}
    attrs = {}
    current = None
    for line in (repo/'data/items/attributes.asm').read_text(encoding='utf-8').splitlines():
        if line == '; $ff':
            break  # padding records, not named items
        m = re.match(r'; (\w+)(?:\s*\(|\s*$)', line)
        if m:
            current = m[1]
        m = re.match(r'\s*item_attribute (.*)', line)
        if m:
            assert current and current not in attrs, (current, line)
            attrs[current] = [x.strip() for x in m[1].split(',')]
    held = {c for c, a in attrs.items() if a[1] != 'HELD_NONE' and 'BERRY' not in c} | IDENTITY_HELD
    held.discard('BERRY_JUICE')
    assert held <= attrs.keys()
    selected = set(tm) | held
    records = defaultdict(list)
    seen_notes = set()
    map_names = {m[1]: pretty_location(m[2]) for m in re.finditer(
        r'^\s*map_attributes\s+(\w+),\s*(\w+)', (repo/'data/maps/attributes.asm').read_text(), re.M)}
    map_names.update({'FastShipCabins_SE_SSE_CaptainsCabin': 'S.S. Aqua — southeast cabins / captain’s cabin',
                      'MrPsychicsHouse': 'Mr. Psychic’s House (Saffron City)',
                      'MrPokemonsHouse': 'Mr. Pokémon’s House (Route 30)',
                      'CharcoalKiln': 'Charcoal Kiln (Azalea Town)',
                      'BillsHouse': 'Bill’s House (Route 25)',
                      'RadioTower1F': 'Goldenrod Radio Tower 1F',
                      'RadioTower3F': 'Goldenrod Radio Tower 3F',
                      'RadioTower4F': 'Goldenrod Radio Tower 4F'})

    def mapname(stem):
        return map_names.get(stem, re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', stem))

    def add(item, location, method, details, source, line, **extra):
        assert item in selected, item
        row = dict(location=location, method=method, details=details,
                   source=source, line=line, **extra)
        if not any(all(old[k] == row[k] for k in ('location', 'method', 'details', 'source')) for old in records[item]):
            records[item].append(row)

    # Map events: retain source and exact zero-based map tile coordinates.
    maps = {p.stem: p for p in sorted((repo/'maps').glob('*.asm'))}
    trainer_refs = defaultdict(set)
    trainer_constants = (repo/'constants/trainer_constants.asm').read_text()
    classes = re.findall(r'^\s*trainerclass (\w+)', trainer_constants, re.M)
    groups = re.findall(r'^\s*dba (\w+)', (repo/'data/trainers/party_pointers.asm').read_text(), re.M)
    assert classes[0] == 'TRAINER_NONE' and len(classes) == len(groups) + 1
    class_groups = dict(zip(classes[1:], groups))
    class_names = re.findall(r'^\s*db "([^"]*)@"', (repo/'data/trainers/class_names.asm').read_text(), re.M)
    assert len(class_names) == len(groups)
    class_display = {c: n.replace('<PKMN>', 'Pokémon').replace('#', 'Poké').title()
                     for c, n in zip(classes[1:], class_names)}
    aliases = dict(re.findall(r'^(\w+) EQU (\w+)\s*$', trainer_constants, re.M))

    def canonical(const):
        while const in aliases:
            const = aliases[const]
        return const
    for stem, p in maps.items():
        raw = p.read_text(encoding='utf-8').splitlines()
        coords = defaultdict(list)
        for line in raw:
            if re.match(r'\s*(object_event|bg_event)\b', line):
                parts = line.split(';')[0].split(',')
                head = parts[0].split()
                label = parts[-2].strip() if head[0] == 'object_event' else parts[-1].strip()
                coords[label].append(f'({head[1]}, {parts[1].strip()})')
        label = ''
        for number, line in enumerate(raw, 1):
            m = re.match(r'([.\w]+):', line)
            if m:
                label = m[1]
            m = re.match(r'\s*(trainer|loadtrainer)\s+(\w+),\s*(\w+)', line)
            if m:
                assert m[2] in class_groups, m[0]
                trainer_refs[class_groups[m[2]], canonical(m[3])].add(stem)
            m = re.match(r'\s*(itemball|hiddenitem|giveitem|verbosegiveitem|loaditem)\s+(\w+)', line)
            if not m or m[2] not in selected:
                continue
            command, item = m.groups()
            key = stem + ':' + item
            if command in {'itemball', 'hiddenitem'}:
                method = 'Hidden pickup' if command == 'hiddenitem' else 'Ground pickup'
                details = PICKUP_NOTES.get(stem, 'Collect the item ball.' if command == 'itemball' else 'Search this map tile.')
            else:
                assert key in GIFT_NOTES, f'Unreviewed scripted source: {key} at {number}'
                seen_notes.add(key)
                details = GIFT_NOTES[key]
                method = 'Coin prize' if 'coins and a Coin Case' in details else 'Gift / reward'
                if item == 'DRAGON_FANG' or key == 'CeladonCafe:LEFTOVERS':
                    method = 'Ground pickup' if item == 'DRAGON_FANG' else 'Search trash can'
            xy = coords.get(label, [])
            if xy:
                details += ' Tile ' + ', '.join(xy) + '.'
            add(item, mapname(stem), method, details, p.relative_to(repo).as_posix(), number)
    assert seen_notes == GIFT_NOTES.keys(), sorted(GIFT_NOTES.keys() - seen_notes)

    # Standard shop inventories, including alternate TM stock.
    mart_constants = re.findall(r'^\s*const (MART_(?!TYPE_)\w+)', (repo/'constants/mart_constants.asm').read_text(), re.M)
    marts_file = repo/'data/items/marts.asm'
    mart_text = marts_file.read_text()
    mart_labels = re.findall(r'^\s*dw (Mart\w+)', mart_text, re.M)
    assert len(mart_constants) == len(mart_labels)
    for const, label in zip(mart_constants, mart_labels):
        block = re.search(r'^' + label + r':\n(.*?)(?=^\w+:|\Z)', mart_text, re.M | re.S)
        items = re.findall(r'^\s*db (\w+)\s*(?:;.*)?$', block[1], re.M)
        for stem, p in maps.items():
            for number, line in enumerate(p.read_text().splitlines(), 1):
                match = re.match(r'\s*pokemart (\w+),\s*' + const + r'\b', line)
                if not match:
                    continue
                for item in items:
                    if item not in selected:
                        continue
                    price_key = tm[item][0] if item in tm else item
                    price = int(attrs[price_key][0])
                    detail = 'Repeatable purchase.'
                    if match[1] == 'MARTTYPE_HELD_ITEMS':
                        price *= 10
                        detail = 'Grandma; choose Held Items after clearing the Rocket Hideout. Available every day and time; no Pryce requirement. Price includes the gear shop’s ×10 markup.'
                    elif item == 'TM_HEADBUTT':
                        detail = 'Stock appears after receiving Headbutt in Ilex Forest.'
                    elif item == 'TM_ROCK_SMASH':
                        detail = 'Stock appears after receiving Rock Smash on Route 36.'
                    detail += f' Cost: ₽{price:,}.'
                    # Alternate marts duplicate the same availability branch.
                    if not any(row['method'] == 'Shop' and row['location'] == mapname(stem) and row['details'] == detail for row in records[item]):
                        add(item, mapname(stem), 'Shop', detail, 'data/items/marts.asm', mart_text[:block.start()].count('\n') + 1,
                            map_source=p.relative_to(repo).as_posix(), map_line=number)

    # Dynamic rewards: the old tower random vitamin table is not called by
    # the current prize menu, so only the five selectable rewards belong here.
    tower_path = repo/'maps/BattleTower1F.asm'
    tower_text = tower_path.read_text()
    tower_block = tower_text.split('Script_GivePlayerHisPrize:', 1)[1].split('BattleTowerPrizeMenuHeader:', 1)[0]
    for match in re.finditer(r'^\s*setval (\w+)\s*$', tower_block, re.M):
        item = match[1]
        if item in held:
            number = tower_text.index(tower_block) + match.start()
            add(item, 'Battle Tower 1F', 'Battle Tower prize', 'Choose one item after completing a seven-win challenge; repeatable on subsequent completed challenges.',
                'maps/BattleTower1F.asm', tower_text[:number].count('\n') + 1)
    fish_path = repo/'engine/events/fishing_contest.asm'
    fish_text = fish_path.read_text()
    prizes = re.search(r'FishingContestPrizes:\n\s*db (.*)', fish_text)
    for place, item in enumerate(prizes[1].split(',')):
        item = item.strip()
        if item in held:
            add(item, 'Olivine Fishing Cove / gate', 'Fishing Contest prize',
                f'{place}nd place; Friday Fishing Contest. Return to the gate for judging.',
                'engine/events/fishing_contest.asm', fish_text[:prizes.start()].count('\n') + 2)

    # The Mystery Gift item table is a conditional hardware/link source.
    mg_path = repo/'data/items/mystery_gift_items.asm'
    for number, line in enumerate(mg_path.read_text().splitlines(), 1):
        match = re.match(r'\s*db (\w+)', line)
        if match and match[1] in held:
            add(match[1], 'Pokémon Center 2F delivery NPC', 'Mystery Gift',
                'Random Mystery Gift item pool. Unlock with Carrie on Goldenrod Department Store 5F on Game Boy Color, then use a compatible Mystery Gift infrared session. Requires external connectivity; not an ordinary overworld gift.',
                'data/items/mystery_gift_items.asm', number)

    # In-game trades carry their explicitly assigned item.
    trade_ids = re.findall(r'^\s*const (NPC_TRADE_\w+)', (repo/'constants/script_constants.asm').read_text(), re.M)
    if not trade_ids:
        for p in (repo/'constants').glob('*.asm'):
            trade_ids += re.findall(r'^\s*const (NPC_TRADE_\w+)', p.read_text(), re.M)
    trade_path = repo/'data/events/npc_trades.asm'
    trades = [(n, l.split(';')[0].split(',')) for n, l in enumerate(trade_path.read_text().splitlines(), 1) if re.match(r'\s*npctrade ', l)]
    assert len(trade_ids) == len(trades), (trade_ids, len(trades))
    for const, (number, fields) in zip(trade_ids, trades):
        item = fields[6].strip()
        if item not in held:
            continue
        requested, offered = fields[1].strip(), fields[2].strip()
        for stem, p in maps.items():
            if re.search(r'^\s*trade ' + const + r'\b', p.read_text(), re.M):
                gender = 'female ' if fields[-1].strip() == 'TRADE_GENDER_FEMALE' else ''
                add(item, mapname(stem), 'In-game trade',
                    f'Trade a {gender}{names[requested]} for {names[offered]}; take the item from the received Pokémon. One-time trade.',
                    'data/events/npc_trades.asm', number)

    # Expand wild holders onto actual encounter maps. A species appearing only
    # in base data does not imply a catchable source. The engine uses 20%/5%,
    # totaling 25% when both slots carry the same item (not a guaranteed item).
    wild_by_mon = defaultdict(list)
    normalize = lambda value: re.sub('[^a-z0-9]', '', value.lower())
    base_files = {normalize(p.stem): p for p in (repo/'data/pokemon/base_stats').glob('*.asm')}
    for encounter in wild:
        wild_by_mon[encounter['const']].append(encounter)
    for species, mon in mons.items():
        slots = mon['info'].get('items', [])
        base_path = base_files.get(normalize(species)) or base_files.get(normalize(mon['name']))
        for item in set(slots) & held:
            rate = sum((20, 5)[i] for i, slot in enumerate(slots) if slot == item)
            grouped = defaultdict(list)
            for encounter in wild_by_mon[species]:
                grouped[encounter['location'], encounter['method'], encounter.get('condition')].append(encounter)
            for (location, method, condition), encounters in sorted(grouped.items(), key=lambda pair: str(pair[0])):
                times = ', '.join(sorted({e['time'] for e in encounters}))
                levels = sorted({e['level'] for e in encounters})
                level = str(levels[0]) if len(levels) == 1 else f'{levels[0]}–{levels[-1]}'
                detail = f'{form_label(species, mon["name"])}; approx. {rate}% held-item chance. {method}; {times}; Lv. {level}.'
                if condition:
                    detail += ' Condition: ' + condition + '.'
                add(item, location, 'Wild Pokémon', detail, ', '.join(sorted({e['source'] for e in encounters})), 0,
                    species=species, held_chance=rate, held_source=base_path.relative_to(repo).as_posix())

    # Scripted wild encounters may force slot 1 (not the rare slot). Snorlax
    # therefore has guaranteed Leftovers; forced-slot-1 Mewtwo has NO_ITEM.
    for stem, p in maps.items():
        text = p.read_text()
        label_start = 0
        for number, line in enumerate(text.splitlines(), 1):
            if re.match(r'^\w+:', line):
                label_start = number
            match = re.match(r'\s*loadwildmon (\w+),\s*(\d+)', line)
            if not match or match[1] not in mons:
                continue
            species, level = match.groups()
            slots = mons[species]['info'].get('items', [])
            context = '\n'.join(text.splitlines()[label_start - 1:number])
            forced = 'BATTLETYPE_FORCEITEM' in context
            possible = {slots[0]} & held if forced else set(slots) & held
            for item in possible:
                rate = 100 if forced else sum((20, 5)[i] for i, slot in enumerate(slots) if slot == item)
                extra = ' Wake with the Poké Flute radio channel.' if species == 'SNORLAX' else ''
                add(item, mapname(stem), 'Static wild Pokémon',
                    f'{form_label(species, names[species])}, Lv. {level}; {rate}% held-item chance. Catch it or use Thief.' + extra,
                    p.relative_to(repo).as_posix(), number, species=species, held_chance=rate)

    # Permanent stealing sources in ordinary scripted trainer battles. Include
    # only parties referenced by a map script; tower and link teams are omitted.
    party_path = repo/'data/trainers/parties.asm'
    party_text = party_path.read_text()
    blocks = list(re.finditer(r'^\s*next_list_item[^\n]*', party_text, re.M))
    unused_parties = []
    for index, marker in enumerate(blocks):
        header = re.search(r'; (\w+) \((\d+)\) (\w+)(?: - (.*))?', marker[0])
        assert header, marker[0]
        trainer_class, party_number, trainer_id, comment_location = header.groups()
        start, end = marker.end(), blocks[index + 1].start() if index + 1 < len(blocks) else len(party_text)
        block = party_text[start:end]
        nameline = re.search(r'db "([^"]*)@",\s*(.*)', block)
        assert nameline, marker[0]
        trainer_name, kind = nameline.groups()
        if 'ITEM' not in kind:
            continue
        group = class_groups[trainer_class]
        locations = set(trainer_refs.get((group, trainer_id), set()))
        # The same party may be selected by a numeric trainer ID.
        locations |= trainer_refs.get((group, party_number), set())
        # TrainerHouse CAL2 loads an external Mystery Gift team, not this table.
        if trainer_class == 'CAL' and trainer_id == 'CAL2':
            locations = set()
        held_mons = list(re.finditer(r'^\s*db (\d+)\s*(?:;[^\n]*)?\n\s*dw (\w+)\s*(?:;[^\n]*)?\n\s*db (\w+)', block, re.M))
        for match in held_mons:
            level, species, item = match.groups()
            if item not in held:
                continue
            if not locations:
                unused_parties.append(f'{trainer_class}/{trainer_id}: {item}')
                continue
            number = party_text[:start + match.start()].count('\n') + 1
            for stem in sorted(locations):
                name = trainer_name.replace('<PKMN>', 'Pokémon').replace('#', 'Poké').title()
                theft = 'Use Trick before the balloon pops; ordinary damaging Thief hits pop it.' if item == 'AIR_BALLOON' else 'Use Thief or Trick before the item is consumed.'
                detail = f'{class_display[trainer_class]} {name}: {form_label(species, names[species])} Lv. {level}. Party {trainer_id}. {theft}'
                if trainer_id in {'FALKNER2', 'BUGSY2', 'WHITNEY2', 'MORTY2', 'CHUCK2', 'JASMINE2', 'PRYCE2', 'CLAIR2'}:
                    required = {'FALKNER2': 'Red', 'BUGSY2': 'Falkner’s rematch', 'WHITNEY2': 'Bugsy’s rematch', 'MORTY2': 'Whitney’s rematch',
                                'CHUCK2': 'Morty’s rematch', 'JASMINE2': 'Chuck’s rematch', 'PRYCE2': 'Jasmine’s rematch', 'CLAIR2': 'Pryce’s rematch'}
                    detail += f' One-time gym rematch after defeating {required[trainer_id]}.'
                elif trainer_id in {'WILL2', 'KOGA2', 'BRUNO2', 'KAREN2', 'LANCE2'}:
                    detail += ' Elite Four / Champion rematch team after defeating Clair’s rematch.'
                add(item, mapname(stem), 'Trainer item', detail, 'data/trainers/parties.asm', number,
                    trainer_class=trainer_class, trainer_id=trainer_id, species=species,
                    map_source=maps[stem].relative_to(repo).as_posix())

    # Every TM and held item remains visible, even when it has no obtainable
    # placement. Keep source links and machine-readable rows for later updates.
    result = []
    for item in sorted(selected, key=lambda c: (0, tm[c][0]) if c in tm else (1, item_names.get(c, disp(c)))):
        name = (tm[item][0] + ' — ' + move_names[tm[item][1]]) if item in tm else item_names.get(item, disp(item))
        sources = sorted(records[item], key=lambda row: (row['method'] == 'Trainer item', row['method'] == 'Wild Pokémon', row['location'], row['details']))
        result.append(dict(const=item, name=name, category='TM' if item in tm else 'Held item', sources=sources))
    counts = {'tms': len(tm), 'held_items': len(held), 'acquisition_rows': sum(len(r['sources']) for r in result),
              'no_sources': [r['name'] for r in result if not r['sources']]}
    payload = dict(counts=counts, items=result, audit={'unreferenced_trainer_party_items': unused_parties,
                   'encounter_parser_warnings': b.report['warnings'], 'encounter_parser_unparsed': b.report['unparsed']})
    render(repo, result, counts)
    print(json.dumps(counts, ensure_ascii=False))
    return payload


def render(out, items, counts):
    intro = (f'All {counts["tms"]} TMs and {counts["held_items"]} battle, training, species-specific, and held-evolution items, from the current Crimson Crystal source. '
             'Berries, Berry Juice, apricorns, medicines, balls, mail, key items, fossils, and ordinary use-on-Pokémon evolution items are excluded. '
             'Tile coordinates are (x, y), starting at zero in the named map. Ground items and most gifts are one-time unless stated otherwise.')
    how = ('Wild held-item rates are approximately 20% for slot 1 and 5% for slot 2; identical slots total 25%. '
           'These are the chance of the Pokémon holding the item, not its encounter rate. Catch the Pokémon or steal the item with Thief. '
           'Your Thief user must be holding no item. Trick can also take an item by swapping; using an empty-handed Pokémon gives up no item. Sticky Hold can prevent theft; consumable items must be taken before they activate. '
           'Use Trick for Air Balloon, which damaging hits pop before Thief can take it. Ordinary trainer Thief / Trick writes the item into your party permanently. Trainer rows identify the exact party variant; rematches and story variants require their normal progression or phone conditions. '
           'Battle Tower opponent gear and externally supplied link / Mystery Gift trainer teams are not fixed item locations. '
           'Pickup’s current table contains no items in this guide.')
    scope = ('Source coverage: map item balls, hidden items, scripted gifts, standard and rooftop marts, Game Corner prizes, '
             'Battle Tower prize menu, Fishing Contest prizes, in-game trades, Mystery Gift item pool, wild held-item tables joined to encounter maps, '
             'scripted wild encounters, and map-referenced trainer parties. An item with no source is explicitly marked; a base-stat holder without a wild encounter is not treated as a location.')
    md = ['# Crimson Crystal — TM and held-item locations', '', intro, '', how, '', scope, '',
          f'**Coverage:** {counts["tms"]} TMs; {counts["held_items"]} held items; {counts["acquisition_rows"]} acquisition entries.', '',
          '## Quick index', '', '| Item | Sources |', '| --- | --- |']
    for item in items:
        categories = ', '.join(sorted({r['method'] for r in item['sources']})) or 'No obtainable source found'
        md.append(f'| [{item["name"]}](#{item["const"].lower()}) | {categories} |')
    for item in items:
        anchor = item['const'].lower()
        md += ['', f'<a id="{anchor}"></a>', f'## {item["name"]}', '']
        if not item['sources']:
            md.append('No obtainable source found in the current source tables and map scripts.')
        else:
            md += ['| Location | How to obtain / conditions | Source |', '| --- | --- | --- |']
            for row in item['sources']:
                md.append(f'| {row["location"]} | **{row["method"]}** — {row["details"]} | {md_source(row)} |')
    md += ['', '## Updating the guide', '', 'Run `python tools/generate_item_locations.py` from the repository root. This standalone list is separate from the website.', '']
    (out/'ITEM_LOCATIONS.md').write_text('\n'.join(md), encoding='utf-8')


def md_source(row):
    sources = row['source'].split(', ')
    links = [f'[{s}]({s}' + (f'#L{row["line"]}' if row['line'] else '') + ')' for s in sources]
    if row.get('map_source'):
        links.append(f'[map script]({row["map_source"]}' + (f'#L{row["map_line"]}' if row.get('map_line') else '') + ')')
    if row.get('held_source'):
        links.append(f'[held slots]({row["held_source"]})')
    return '; '.join(links)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('repo', nargs='?', default=Path(__file__).resolve().parents[1])
    generate(parser.parse_args().repo)
