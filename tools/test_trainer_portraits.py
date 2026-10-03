#!/usr/bin/env python3
"""Audit overworld portrait speaker coverage without an emulator.

Run after changing maps, sprites or the speaker generator. Actual drawing,
animation and shared-message handoffs are covered by the emulator capture
manifest under _ai_artifacts/videos/portraits-2026-10-03.
"""
import glob
import re
import unittest
from pathlib import Path
import trainer_portrait_texts as portraits

ROOT = Path(portraits.ROOT)


class PortraitCoverage(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        portraits.load_variable_sprites()
        cls.sprites, cls.names = portraits.load_portraits()
        cls.maps = {Path(p).stem: portraits.MapFile(p, cls.sprites)
                    for p in glob.glob(str(ROOT / 'maps/*.asm'))}
        cls.uses = {}
        for mf in cls.maps.values():
            if mf.has_portrait_character():
                portraits.walk_map(mf, lambda mf, label, speaker, entry, *args:
                    cls.uses.setdefault((mf.name, label), []).append((speaker, entry)))

    def decisions(self, mapname, label):
        mf = self.maps[mapname]
        return {portraits.decide(mf, label, speaker, self.names)[0]
                for speaker, _ in self.uses[mapname, label]}

    def test_all_portrait_assets_have_dialogue(self):
        used = set()
        for mapname, label in self.uses:
            for decision in self.decisions(mapname, label):
                if decision[0] == 'portrait':
                    used.add(decision[1])
        self.assertEqual(used, self.names)
        self.assertEqual({p.stem.upper() for p in (ROOT / 'gfx/trainer_portraits').glob('*.portrait')}, self.names)

    def test_no_ambiguous_speakers(self):
        conflicts = [(mn, lb) for mn, lb in self.uses if len(self.decisions(mn, lb)) != 1]
        self.assertEqual(conflicts, [])

    def test_portrait_graphics_match_their_numeric_ids(self):
        constants = re.findall(r'^\s*const PORTRAIT_(\w+)',
                              (ROOT / 'constants/gfx_constants.asm').read_text(), re.M)
        source = (ROOT / 'engine/events/trainer_portraits.asm').read_text()
        pointers = source.split('TrainerPortraitPointers:', 1)[1].split('assert', 1)[0]
        names = re.findall(r'dba TrainerPortrait(\w+)GFX', pointers)
        self.assertEqual([name.upper() for name in names],
                         [name.replace('_', '') for name in constants])

    def test_every_local_dialogue_command_is_reachable(self):
        # Both blocks are unused text: Wooster's script is not an object event,
        # and CianwoodCityUnusedText is behind an unused script entry.
        unused = {('AzaleaTown', 'WoosterText'), ('CianwoodCity', 'CianwoodCityUnusedText')}
        missed = set()
        for mf in self.maps.values():
            if not mf.has_portrait_character():
                continue
            for i, line in enumerate(mf.lines):
                m = re.match(r'\s*(writetext|jumptext|jumptextfaceplayer|farwritetext|farjumptext)\s+(.+)', line)
                if m:
                    label = mf.resolve(m[2].split(',')[-1].strip(), mf.scope_of_line[i])
                    if label in mf.labels and (mf.name, label) not in self.uses:
                        missed.add((mf.name, label))
        self.assertEqual(missed, unused)

    def test_named_story_handoffs(self):
        required = {
            ('TeamRocketBaseB2F', 'UnknownText_0x6d2ad'): 'ARIANA',
            ('TeamRocketBaseB2F', 'UnknownText_0x6d2c3'): 'ARIANA',
            ('TeamRocketBaseB2F', 'UnknownText_0x6d38c'): 'LANCE',
            ('DragonShrine', 'DragonShrineSpeechlessText'): 'CLAIR',
            ('OlivineLighthouse6F', 'JasmineAmphyHangOnText'): 'JASMINE',
            ('BurnedTower1F', 'BurnedTowerSilver_AfterText1'): 'SILVER',
            ('BurnedTower1F', 'BurnedTowerSilver_AfterText2'): 'SILVER',
            ('LancesRoom', 'UnknownText_0x18121b'): 'OAK',
        }
        for key, speaker in required.items():
            with self.subTest(text=key):
                self.assertEqual(self.decisions(*key), {('portrait', speaker)})

    def test_other_people_and_narration_have_no_portrait(self):
        required = {
            'AzaleaTown': ['AzaleaTownRocket1Text', 'AzaleaTownRocket2Text'],
            'FuchsiaGym': ['LassAliceBeforeText', 'LassAliceAfterText', 'LassLindaBeforeText',
                           'LassLindaAfterText', 'PicnickerCindyBeforeText', 'PicnickerCindyAfterText',
                           'CamperBarryBeforeText', 'CamperBarryAfterText'],
            'FuchsiaPokecenter1F': ['FuchsiaPokecenter1FJanineImpersonatorText1',
                                   'FuchsiaPokecenter1FJanineImpersonatorText2'],
            'MrPokemonsHouse': ['MrPokemonIntroText5', 'MrPokemonText_ImDependingOnYou',
                                'MrPokemonsHouse_MrPokemonHealText', 'MrPokemonsHouse_GetDexText'],
            'SproutTower3F': ['SproutTowerElderLecturesRivalText'],
            'GoldenrodGym': ['BridgetWhitneyCriesText'],
            'DragonShrine': ['DragonShrineMustIInformLanceText', 'DragonShrineElderScoldsClairText',
                             'DragonShrinePlayerReceivedRisingBadgeText'],
            'LancesRoom': ['UnknownText_0x1811dd', 'UnknownText_0x18134b', 'UnknownText_0x1813c5'],
        }
        for mn in ['Route40', 'Route41']:
            required[mn] = [lb for mapname, lb in self.uses if mapname == mn and lb.startswith('Swimmerm')]
        for mapname, labels in required.items():
            for label in labels:
                with self.subTest(map=mapname, text=label):
                    self.assertEqual(self.decisions(mapname, label), {('none',)})

    def test_silver_variable_objects_are_specific(self):
        for mapname, label, obj in [
            ('AzaleaTown', 'AzaleaTownRivalBeforeText', 'AZALEATOWN_SILVER'),
            ('AzaleaTown', 'AzaleaTownRivalAfterText', 'AZALEATOWN_SILVER'),
            ('OlivineCity', 'OlivineCityRivalText', 'OLIVINECITY_OLIVINE_RIVAL'),
        ]:
            self.assertEqual(self.decisions(mapname, label), {('object', obj)})


if __name__ == '__main__':
    unittest.main()
