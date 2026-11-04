"""Check catalog coverage and acquisition cases that simple token scans misread."""
import sys
import unittest
from pathlib import Path
from html.parser import HTMLParser

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'crimson-crystal-docs'))
from generate_docs import Builder
from item_catalog import build_catalog, render_catalog


class ItemCatalogTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.builder = Builder(ROOT)
        cls.catalog = build_catalog(cls.builder)
        cls.items = {i['const']: i for i in cls.catalog['items']}

    def test_every_named_item_tm_and_hm_is_present(self):
        expected = set(self.builder.item_names()) | {
            ('HM_' if number.startswith('HM') else 'TM_') + move
            for move, number in self.builder.tm_table().items()
            if number.startswith(('TM', 'HM'))
        }
        self.assertEqual(set(self.items), expected)
        self.assertEqual(set(self.catalog['counts']['no_sources']), {
            'BIG_ROOT', 'CLEAR_AMULET', 'COVERT_CLOAK', 'LIGHT_CLAY',
            'METRONOME_ITEM', 'PUNCHING_GLOVE', 'SAFETY_GOGGLES'})
        self.assertEqual(sum(i['category'] == 'TM' for i in self.items.values()), 54)
        self.assertEqual(sum(i['category'] == 'HM' for i in self.items.values()), 7)

    def test_eon_mail_refund_is_not_a_fresh_source(self):
        item = self.items['EON_MAIL']
        self.assertEqual(item['availability'], 'Mystery Gift only')
        self.assertEqual({s['method'] for s in item['sources']}, {'Mystery Gift'})
        self.assertNotIn('maps/GoldenrodPokecenter1F.asm', {s['source'] for s in item['sources']})

    def test_exp_relay_is_elms_six_badge_gift(self):
        item = self.items['EXP_RELAY']
        self.assertEqual(item['category'], 'Key item')
        self.assertEqual({s['source'] for s in item['sources']}, {'maps/ElmsLab.asm'})
        self.assertIn('six total badges', item['notes'])
        self.assertIn('65,535', item['notes'])
        self.assertIn('Stat EXP', item['description'])

    def test_special_balls_are_not_bag_pickups(self):
        for const in ('PARK_BALL', 'SAFARI_BALL'):
            with self.subTest(item=const):
                self.assertEqual(self.items[const]['availability'], 'Activity only')
                self.assertEqual({s['method'] for s in self.items[const]['sources']}, {'Activity allowance'})

    def test_current_world_rewards_replace_stale_guide_entries(self):
        for const, source in (('MUSCLE_BAND', 'maps/OlivinePort.asm'),
                              ('EXPERT_BELT', 'maps/Route34.asm'),
                              ('SOFT_SAND', 'maps/Route38.asm')):
            with self.subTest(item=const):
                self.assertIn(source, {s['source'] for s in self.items[const]['sources']})
        self.assertNotIn('maps/Route34.asm', {s['source'] for s in self.items['SOFT_SAND']['sources']})

    def test_removed_items_are_not_in_the_catalog(self):
        for item in ('CUSTAP_BERRY', 'SALAC_BERRY', 'BLACK_SLUDGE', 'BRIGHTPOWDER',
                     'RED_CARD', 'HEAVY_DUTY_BOOTS', 'BLUNDER_POLICY', 'EJECT_BUTTON'):
            self.assertNotIn(item, self.items)
        self.assertFalse(any(item.startswith('RETIRED_') for item in self.items))

    def test_ditto_is_the_only_powder_source(self):
        for item, rate in (('METAL_POWDER', 20), ('QUICK_POWDER', 5)):
            sources = self.items[item]['sources']
            self.assertTrue(sources)
            self.assertEqual({s['method'] for s in sources}, {'Wild Pokémon'})
            self.assertTrue(all('Ditto' in s['details'] and f'{rate}%' in s['details']
                                for s in sources), sources)

    def test_conversion_and_forced_static_held_item_sources(self):
        self.assertEqual({s['method'] for s in self.items['BERRY_JUICE']['sources']}, {'Berry conversion'})
        ash = self.items['SACRED_ASH']['sources']
        self.assertEqual(len(ash), 1)
        self.assertEqual(ash[0]['source'], 'maps/TinTowerRoof.asm')
        self.assertIn('100% held-item chance', ash[0]['details'])

    def test_mahogany_consumables_are_repeatable_and_1000(self):
        for item in ('WHITE_HERB', 'POWER_HERB', 'THROAT_SPRAY'):
            sources = self.items[item]['sources']
            self.assertEqual(len(sources), 1, item)
            source = sources[0]
            self.assertEqual(source['method'], 'Shop')
            self.assertEqual(source['map_source'], 'maps/MahoganyMart1F.asm')
            self.assertIn('Rocket Hideout', source['details'])
            self.assertIn('unlimited stock', source['details'])
            self.assertIn('₽1,000', source['details'])

    def test_former_mahogany_gear_is_a_tower_prize(self):
        for item in ('EVIOLITE', 'ROCKY_HELMET', 'AIR_BALLOON', 'MUSCLE_BAND',
                     'WISE_GLASSES', 'EXPERT_BELT', 'FLAME_ORB', 'TOXIC_ORB',
                     'ASSAULT_VEST', 'LIFE_ORB', 'WIDE_LENS'):
            sources = self.items[item]['sources']
            self.assertTrue(any(s['method'] == 'Battle Tower prize' for s in sources), item)
            self.assertFalse(any(s.get('map_source') == 'maps/MahoganyMart1F.asm'
                                 for s in sources), item)

    def test_weather_rocks_list_chamber_requirement(self):
        for const in ('DAMP_ROCK', 'HEAT_ROCK', 'SMOOTH_ROCK', 'ICY_ROCK'):
            with self.subTest(item=const):
                item = self.items[const]
                self.assertTrue(any(s['source'] == 'maps/RuinsOfAlphHoOhItemRoom.asm' and 'Ho-Oh' in s['details'] for s in item['sources']))

    def test_render_has_unique_anchors_and_resolved_internal_links(self):
        class Links(HTMLParser):
            def __init__(self):
                super().__init__()
                self.ids = []
                self.hashes = []
                self.cards = 0
            def handle_starttag(self, tag, attrs):
                attrs = dict(attrs)
                if 'id' in attrs: self.ids.append(attrs['id'])
                if attrs.get('href', '').startswith('#'): self.hashes.append(attrs['href'][1:])
                if 'data-item' in attrs: self.cards += 1
        parser = Links()
        parser.feed(render_catalog(self.catalog))
        self.assertEqual(len(parser.ids), len(set(parser.ids)))
        self.assertEqual(parser.cards, len(self.items))
        self.assertTrue(set(parser.hashes) <= set(parser.ids))
        self.assertTrue({i.lower() for i in self.items} <= set(parser.ids))


if __name__ == '__main__':
    unittest.main()
