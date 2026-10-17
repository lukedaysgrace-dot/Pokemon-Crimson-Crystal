"""Build the website's complete item catalog from ROM acquisition sources."""
from collections import defaultdict
from pathlib import Path
import re
import sys
import html

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from generate_item_locations import generate, render as render_guide, PICKUP_NOTES
from generate_docs import form_label, pretty_location


NOTES = {
    'BERRY_JUICE': 'After reaching Goldenrod, a party Shuckle holding a Berry can turn it into Berry Juice after battle (approximately a 1-in-16 check).',
    'BICYCLE': 'Choose either the Bicycle or Skateboard at the Goldenrod Bike Shop. The other ride cannot be claimed on the same save.',
    'SKATEBOARD': 'Choose either the Skateboard or Bicycle at the Goldenrod Bike Shop. The other ride cannot be claimed on the same save.',
    'ABILITY_CAP': 'Elm gives this after you return the Mystery Egg, provided abilities are enabled for the save.',
    'PARK_BALL': 'Receive 20 balls for each Bug-Catching Contest.',
    'SAFARI_BALL': 'Thirty balls are supplied for a paid Safari Game. Remaining balls are taken back when the game ends.',
}

GIFT_DETAILS = {
    'HM_CUT': 'Complete the Farfetch’d quest in Ilex Forest.',
    'HM_FLY': 'Speak to Chuck’s wife outside Cianwood Gym after defeating Chuck.',
    'HM_SURF': 'Defeat all five Kimono Girls, then speak to the man in the Dance Theatre.',
    'HM_STRENGTH': 'Speak to the sailor in Olivine Café.',
    'HM_FLASH': 'Defeat Elder Li at the top of Sprout Tower.',
    'HM_WHIRLPOOL': 'Lance’s reward after shutting down the Rocket Hideout generator.',
    'OLD_ROD': 'Speak to the fisherman inside the Route 32 Pokémon Center.',
    'GOOD_ROD': 'Speak to the fisherman in the Olivine Good Rod House.',
    'SUPER_ROD': 'Speak to the fisherman in the Route 12 Super Rod House.',
    'BICYCLE': NOTES['BICYCLE'], 'SKATEBOARD': NOTES['SKATEBOARD'],
    'ABILITY_CAP': NOTES['ABILITY_CAP'],
    'SECRETPOTION': 'Ask the Cianwood pharmacist for medicine for the lighthouse Ampharos.',
    'S_S_TICKET': 'Professor Elm’s story gift; follow the post-Surge travel quest.',
    'MYSTERY_EGG': 'Mr. Pokémon on Route 30; take the Egg back to Elm.',
    'CLEAR_BELL': 'Radio Tower director; rescue him and defeat Archer.',
    'SILVER_WING': 'Speak to the old man in Pewter City.',
    'RAINBOW_WING': 'Speak to the sage in Tin Tower 1F when the upper tower opens.',
    'CARD_KEY': 'Rescue the director in the Goldenrod Underground Warehouse.',
    'BASEMENT_KEY': 'Defeat the impostor director in Radio Tower 5F.',
    'LOST_ITEM': 'Speak to the Poké Fan beside Copycat’s Poké Doll in Vermilion’s Pokémon Fan Club.',
    'PASS': 'Return Copycat’s lost Poké Doll to her in Saffron City.',
    'SQUIRTBOTTLE': 'Goldenrod Flower Shop; defeat Whitney and speak to the flower-shop sisters.',
    'BLUE_CARD': 'Speak to Buena on Goldenrod Radio Tower 2F about her password show.',
    'RELIC_CLOCK': 'Search the hidden tile in Ilex Forest; one-time discovery.',
    'GS_BALL': 'Follow Bill’s GS Ball event and Kurt’s investigation in Azalea Town.',
    'RED_SCALE': 'Defeat or catch the red Gyarados at the Lake of Rage.',
    'ELEMENTAL_SPHERE': 'Lugia’s chamber; follow the legendary encounter story. Used for the Route 19 event.',
}


def build_catalog(builder, write_guide=False):
    repo = builder.r
    guide = generate(repo, builder=builder, write=False)
    if write_guide: render_guide(repo, guide['items'], guide['counts'])
    result = {i['const']: i for i in guide['items']}
    names = builder.item_names()
    # Every named non-TM item, followed by the seven HMs. TMs are in the guide.
    hm = {'HM_' + move: number for move, number in builder.tm_index.items() if number.startswith('HM')}
    move_names = {move['const']: move['name'] for move in builder.moves()}
    attrs = {}
    current = None
    for line in (repo / 'data/items/attributes.asm').read_text(encoding='utf-8').splitlines():
        if line == '; $ff': break
        match = re.match(r'; (\w+)(?:\s*\(|\s*$)', line)
        if match: current = match[1]
        match = re.match(r'\s*item_attribute (.*)', line)
        if match: attrs[current] = [part.strip() for part in match[1].split(',')]

    def category(item):
        if item in hm: return 'HM'
        if 'FOSSIL' in item or item == 'OLD_AMBER': return 'Fossil'
        if item.endswith('STONE') or item in {'TART_APPLE', 'SWEET_APPLE', 'SYRUPY_APPLE'}: return 'Evolution item'
        if 'APRICORN' in item: return 'Apricorn'
        if 'BERRY' in item and item != 'BERRY_JUICE': return 'Berry'
        if item.endswith('_BALL'): return 'Ball'
        if attrs[item][4] == 'KEY_ITEM': return 'Key item'
        if attrs[item][5] == 'ITEMMENU_PARTY' or attrs[item][6] == 'ITEMMENU_PARTY': return 'Medicine / training'
        return 'Other item'

    for item in list(names) + list(hm):
        if item not in result:
            name = names.get(item) or hm[item] + ' — ' + move_names[item[3:]]
            result[item] = dict(const=item, name=name, category=category(item), sources=[])
    extra = result.keys() - {item['const'] for item in guide['items']}

    # The description pointer table uses the same IDs/order as ItemNames.
    desc_text = (repo / 'data/items/descriptions.asm').read_text(encoding='utf-8')
    pointers = re.findall(r'^\s*dw (\w+)', desc_text, re.M)
    for index, item in enumerate(names):
        label = pointers[index]
        block = re.search(r'^' + label + r':\n(.*?)(?=^\w+:|\Z)', desc_text, re.M | re.S)
        words = re.findall(r'"([^"]*)"', block[1]) if block else []
        description = ' '.join(words).replace('- ', '').replace('@', '').replace('#MON', 'Pokémon').replace('<PKMN>', 'Pokémon')
        result[item]['description'] = description

    map_names = {m[1]: pretty_location(m[2]) for m in re.finditer(
        r'^\s*map_attributes\s+(\w+),\s*(\w+)', (repo/'data/maps/attributes.asm').read_text(encoding='utf-8'), re.M)}
    maps = {p.stem: p.read_text(encoding='utf-8') for p in sorted((repo/'maps').glob('*.asm'))}

    def location(stem):
        return map_names.get(stem, re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', stem))

    def add(item, loc, method, details, source, line=0):
        if item not in extra: return
        row = dict(location=loc, method=method, details=details, source=source, line=line)
        if row not in result[item]['sources']: result[item]['sources'].append(row)

    for stem, text in maps.items():
        coords = defaultdict(list)
        label = ''
        for line in text.splitlines():
            parts = line.split(';')[0].split(',')
            if re.match(r'\s*(object_event|bg_event)\b', line):
                key = parts[-2].strip() if 'object_event' in parts[0] else parts[-1].strip()
                coords[key].append(f'({parts[0].split()[-1]}, {parts[1].strip()})')
        for number, line in enumerate(text.splitlines(), 1):
            match = re.match(r'([.\w]+):', line)
            if match: label = match[1]
            match = re.match(r'\s*(itemball|hiddenitem|giveitem|verbosegiveitem|loaditem)\s+(\w+)', line)
            if not match or match[2] not in extra: continue
            command, item = match.groups()
            # This is a failed-exchange refund, never a fresh acquisition.
            if stem == 'GoldenrodPokecenter1F' and item == 'EON_MAIL': continue
            method = {'itemball': 'Ground pickup', 'hiddenitem': 'Hidden pickup'}.get(command, 'Gift / reward')
            if command in {'itemball', 'hiddenitem'}:
                detail = PICKUP_NOTES.get(stem, 'Search this tile.' if command == 'hiddenitem' else 'Collect the item ball.')
            elif item.endswith('_FOSSIL') or item == 'OLD_AMBER':
                detail = 'Inspect the crumbling wall in this word room, then collect the exposed fossil.'
            else:
                detail = GIFT_DETAILS.get(item, 'Complete the local conversation or event to receive this item.')
            if coords[label] and not all(tile in detail for tile in coords[label]):
                detail += ' Tile ' + ', '.join(coords[label]) + '.'
            add(item, location(stem), method, detail, f'maps/{stem}.asm', number)
        for match in re.finditer(r'^\s*givepoke\s+\w+,\s*\d+,\s*(\w+)', text, re.M):
            add(match[1], location(stem), 'Gift Pokémon', 'Take the held item from the gift Pokémon.', f'maps/{stem}.asm', text[:match.start()].count('\n')+1)

    # Standard marts: only inventories actually used by a map are sources.
    mart_text = (repo/'data/items/marts.asm').read_text(encoding='utf-8')
    constants = re.findall(r'^\s*const (MART_(?!TYPE_)\w+)', (repo/'constants/mart_constants.asm').read_text(encoding='utf-8'), re.M)
    labels = re.findall(r'^\s*dw (Mart\w+)', mart_text, re.M)
    assert len(constants) == len(labels)
    for const, label in zip(constants, labels):
        block = re.search(r'^' + label + r':\n(.*?)(?=^\w+:|\Z)', mart_text, re.M|re.S)
        for stem, text in maps.items():
            if not re.search(r'^\s*pokemart \w+,\s*' + const + r'\b', text, re.M): continue
            for item in re.findall(r'^\s*db (\w+)\s*(?:;.*)?$', block[1], re.M):
                if item not in extra: continue
                price = int(attrs[item][0])
                detail = f'Repeatable purchase. Cost: ₽{price:,}.'
                if const == 'MART_MAHOGANY_1': detail += ' Available before helping Lance.'
                add(item, location(stem), 'Shop', detail, 'data/items/marts.asm', mart_text[:block.start()].count('\n')+1)

    # Fruit trees are matched by constant, never inferred from nearby routes.
    fruit_consts = []
    for path in (repo/'constants').glob('*.asm'):
        fruit_consts += re.findall(r'^\s*const (FRUITTREE_\w+)', path.read_text(encoding='utf-8'), re.M)
    fruits = re.findall(r'^\s*db (\w+)', (repo/'data/items/fruit_trees.asm').read_text(encoding='utf-8'), re.M)
    assert len(fruit_consts) == len(fruits)
    for index, (const, item) in enumerate(zip(fruit_consts, fruits)):
        for stem, text in maps.items():
            if re.search(r'^\s*fruittree ' + const + r'\b', text, re.M):
                add(item, location(stem), 'Fruit tree', 'Harvest the tree; replenishes daily.', 'data/items/fruit_trees.asm', index+3)

    order, species_names = builder.species()
    mons = builder.base_stats(order, species_names)
    wild = builder.wild(set(mons))
    holders = defaultdict(list)
    for encounter in wild: holders[encounter['const']].append(encounter)
    for species, mon in mons.items():
        slots = mon['info'].get('items', [])
        for item in set(slots) & extra:
            rate = sum((20, 5)[i] for i, slot in enumerate(slots) if slot == item)
            grouped = defaultdict(list)
            for encounter in holders[species]:
                grouped[encounter['location'], encounter['method'], encounter.get('condition')].append(encounter)
            for (loc, method, condition), entries in grouped.items():
                times = ', '.join(sorted({e['time'] for e in entries}))
                detail = f'{form_label(species, mon["name"])}; approx. {rate}% held-item chance. {method}; {times}.'
                if condition: detail += ' Condition: ' + condition + '.'
                add(item, loc, 'Wild Pokémon', detail, ', '.join(sorted({e['source'] for e in entries})))
    for stem, text in maps.items():
        for block in re.split(r'(?=^\w+:)', text, flags=re.M):
            for match in re.finditer(r'^\s*loadwildmon (\w+),\s*(\d+)', block, re.M):
                species, level = match.groups()
                if species not in mons: continue
                slots = mons[species]['info'].get('items', [])
                forced = 'BATTLETYPE_FORCEITEM' in block[:match.start()]
                possible = {slots[0]} if forced else set(slots)
                for item in possible & extra:
                    rate = 100 if forced else sum((20, 5)[i] for i, slot in enumerate(slots) if slot == item)
                    add(item, location(stem), 'Static wild Pokémon', f'{form_label(species, species_names[species])}, Lv. {level}; {rate}% held-item chance. ', f'maps/{stem}.asm')

    # Hardware/link rewards remain separate from ordinary single-player sources.
    path = repo/'data/items/mystery_gift_items.asm'
    for number, line in enumerate(path.read_text(encoding='utf-8').splitlines(), 1):
        match = re.match(r'\s*db (\w+)', line)
        if match: add(match[1], 'Pokémon Center 2F delivery NPC', 'Mystery Gift', 'Random Mystery Gift pool; unlock with Carrie on Goldenrod Department Store 5F on Game Boy Color, then use a compatible infrared session.', path.relative_to(repo).as_posix(), number)

    # Fixed trade gifts, joined to the map's trade command.
    trade_consts = []
    for path in (repo/'constants').glob('*.asm'):
        trade_consts += re.findall(r'^\s*const (NPC_TRADE_\w+)', path.read_text(encoding='utf-8'), re.M)
    path = repo/'data/events/npc_trades.asm'
    trades = [(n, l.split(';')[0].split(',')) for n,l in enumerate(path.read_text(encoding='utf-8').splitlines(),1) if re.match(r'\s*npctrade ',l)]
    assert len(trade_consts) == len(trades)
    for const, (number, fields) in zip(trade_consts, trades):
        for stem, text in maps.items():
            if re.search(r'^\s*trade ' + const + r'\b',text,re.M):
                detail = f'Trade {species_names[fields[1].strip()]} for {species_names[fields[2].strip()]}; take the held item from the received Pokémon.'
                add(fields[6].strip(), location(stem), 'In-game trade', detail, 'data/events/npc_trades.asm', number)

    for number, line in enumerate((repo/'data/items/apricorn_balls.asm').read_text(encoding='utf-8').splitlines(),1):
        match = re.match(r'\s*db (\w+),\s*(\w+)',line)
        if match: add(match[2], 'Kurt’s House (Azalea Town)', 'Apricorn crafting', f'Give Kurt {names[match[1]]}; collect the finished balls the next day. Repeatable.', 'data/items/apricorn_balls.asm',number)
    for filename, loc, method, detail in (
        ('buena_prizes.asm', 'Goldenrod Radio Tower 2F', 'Buena prize', 'Redeem Blue Card points from Buena’s Password show.'),
        ('rooftop_sale.asm', 'Goldenrod Department Store Roof', 'Rooftop sale', 'Repeatable purchase while the rooftop sale is running; stock differs before and after entering the Hall of Fame.'),
        ('bargain_shop.asm', 'Goldenrod Underground', 'Bargain shop', 'Monday morning bargain merchant; limited daily stock.'),
    ):
        for number, line in enumerate((repo/'data/items'/filename).read_text(encoding='utf-8').splitlines(),1):
            match = re.match(r'\s*dbw? (\w+),\s*(\d+)', line)
            if match:
                suffix = f' Cost: {match[2]} points.' if method == 'Buena prize' else f' Cost: ₽{int(match[2]):,}.'
                add(match[1], loc, method, detail + suffix, 'data/items/' + filename, number)
    for number, line in enumerate((repo/'data/items/mom_phone.asm').read_text(encoding='utf-8').splitlines(),1):
        match = re.match(r'\s*momitem\s+(\d+),\s*(\d+),\s*MOM_ITEM,\s*(\w+)', line)
        if match: add(match[3], 'Player’s House', 'Mom’s savings', 'Let Mom save money; she may buy this item. Collect purchases from the PC item storage.', 'data/items/mom_phone.asm', number)
    fish_text = (repo/'engine/events/fishing_contest.asm').read_text(encoding='utf-8')
    prize_line = re.search(r'FishingContestPrizes:\n\s*db (.*)', fish_text)
    places = ('Consolation', 'First place', 'Second place', 'Third place')
    for place, item in enumerate(prize_line[1].split(',')):
        add(item.strip(), 'Olivine Fishing Cove / gate', 'Fishing Contest prize', places[place] + '; Friday Fishing Contest. Return to the gate for judging.', 'engine/events/fishing_contest.asm', fish_text[:prize_line.start()].count('\n')+2)
    ability_text = (repo/'engine/battle/abilities_engine.asm').read_text(encoding='utf-8')
    pickup = re.search(r'GetRandomPickupItem:.*?^\.items\n(.*?)(?=^\w+:)', ability_text, re.M|re.S)
    for item in re.findall(r'^\s*db (\w+)', pickup[1], re.M):
        add(item, 'After battle', 'Pickup ability', 'An empty-handed party Pokémon with Pickup may find this after battle when abilities are enabled.', 'engine/battle/abilities_engine.asm')
    add('GOLD_BERRY', 'After battle', 'Honey Gather ability', 'An empty-handed Pokémon with Honey Gather may produce a Gold Berry after battle when abilities are enabled.', 'engine/battle/abilities_engine.asm')
    add('BERRY_JUICE', 'Party Shuckle', 'Berry conversion', NOTES['BERRY_JUICE'], 'engine/events/pokerus/pokerus.asm',119)
    add('PARK_BALL', 'National Park Bug-Catching Contest', 'Activity allowance', NOTES['PARK_BALL'], 'engine/events/bug_contest/contest.asm',1)
    add('SAFARI_BALL', 'Safari Zone', 'Activity allowance', NOTES['SAFARI_BALL'], 'engine/events/safari_zone.asm',5)

    for item in result.values():
        methods = {s['method'] for s in item['sources']}
        if not methods: availability = 'No source found'
        elif methods <= {'Activity allowance'}: availability = 'Activity only'
        elif methods <= {'Mystery Gift'}: availability = 'Mystery Gift only'
        elif methods <= {'Trainer item', 'Mystery Gift'}: availability = 'Trainer theft only'
        elif methods <= {'Wild Pokémon', 'Static wild Pokémon', 'Trainer item', 'Mystery Gift'}: availability = 'Held-item hunting'
        else: availability = 'World sources'
        item['availability'] = availability
        item['notes'] = NOTES.get(item['const'], '')
        item.setdefault('description', '')
        item['sources'].sort(key=lambda s: (s['method'] in {'Trainer item', 'Wild Pokémon', 'Mystery Gift'}, s['location'], s['method'], s['details']))
        for source in item['sources']:
            for path in source['source'].split(', '):
                assert (repo/path).is_file(), path
    items = sorted(result.values(), key=lambda i: (i['category'] not in {'TM','HM'}, i['category'], i['name']))
    counts = dict(total=len(items), tms=guide['counts']['tms'], hms=len(hm), held_items=guide['counts']['held_items'],
                  acquisition_rows=sum(len(i['sources']) for i in items), no_sources=[i['const'] for i in items if not i['sources']])
    builder.report['item_summary'] = counts
    return dict(counts=counts, items=items)


def render_catalog(payload):
    """Searchable, deep-linkable cards; full sources work without JavaScript."""
    escape = html.escape
    availability_labels = {
        'World sources': 'Exploration & shops',
        'Held-item hunting': 'Wild held items',
        'Trainer theft only': 'Trainer held items',
        'Mystery Gift only': 'Mystery Gift',
        'Activity only': 'Contest / Safari',
        'No source found': 'Unavailable',
    }
    cards = []
    for item in payload['items']:
        rows = []
        for source in item['sources']:
            rows.append(f'<li><b>{escape(source["location"])}</b> <span class="item-method">{escape(source["method"])}</span>'
                        f'<p>{escape(source["details"])}</p></li>')
        note = f'<p class="item-note">{escape(item["notes"])}</p>' if item['notes'] and not any(item['notes'] == s['details'] for s in item['sources']) else ''
        description = f'<p class="item-description">{escape(item["description"])}</p>' if item['description'] else ''
        status = '' if item['availability'] == 'World sources' else f'<span class="item-status">{escape(availability_labels[item["availability"]])}</span>'
        words = ' '.join([item['name'], item['const'], item['category'], item['availability'], item['description'], item['notes']] +
                         [s['location'] + ' ' + s['method'] + ' ' + s['details'] for s in item['sources']]).lower()
        cards.append(f'<details class="item-card" id="{item["const"].lower()}" data-item data-category="{escape(item["category"])}" '
                     f'data-availability="{escape(item["availability"])}" data-search="{escape(words, quote=True)}">'
                     f'<summary><span class="item-name">{escape(item["name"])}</span><span class="item-kind">{escape(item["category"])}</span>'
                     f'{status}</summary>'
                     f'<div class="item-body">{description}{note}<h3>Where to find it</h3><ul class="item-sources">'
                     f'{"".join(rows) or "<li>Unavailable.</li>"}</ul></div></details>')
    categories = sorted({i['category'] for i in payload['items']})
    statuses = sorted({i['availability'] for i in payload['items']})
    def options(values, labels=None):
        return ''.join(f'<option value="{escape(value, quote=True)}">{escape((labels or {}).get(value,value))}</option>' for value in values)
    count = payload['counts']
    return (f'<section class="head"><p class="eyebrow">ITEM LOCATIONS</p><h1>Items</h1>'
            '<p>Find every item, TM and HM in Crimson Crystal. Search by item, Pokémon, place or acquisition method.</p></section>'
            f'<section class="counts"><div><b>{count["total"]}</b> Items</div><div><b>{count["tms"]} / {count["hms"]}</b> TMs / HMs</div>'
            f'<div><b>{count["held_items"]}</b> Held items</div></section>'
            '<details class="panel"><summary>Wild held items and stealing</summary>'
            '<p>Catch the Pokémon or use Thief with an empty-handed Pokémon. Trick swaps held items. '
            'You keep items stolen from ordinary trainers, but not Battle Tower opponents. '
            'Use Trick to take Air Balloon before a damaging hit pops it.</p></details>'
            '<div class="toolbar item-toolbar"><input id="itemSearch" type="search" aria-label="Search items" placeholder="Search item, Pokémon or location">'
            f'<select id="itemCategory" aria-label="Item category"><option value="">Every category</option>{options(categories)}</select>'
            f'<select id="itemAvailability" aria-label="Item availability"><option value="">Every source type</option>{options(statuses,availability_labels)}</select></div>'
            f'<p id="itemCount" class="rules-note" aria-live="polite">Showing {count["total"]} of {count["total"]} items</p>'
            f'<div class="item-list">{"".join(cards)}</div><p id="itemEmpty" class="panel" hidden>No items match these filters.</p>')
