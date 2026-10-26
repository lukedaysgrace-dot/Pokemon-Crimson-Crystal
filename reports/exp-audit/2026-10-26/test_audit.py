"""Meaningful regression checks for extraction, integer arithmetic and routing."""
import copy
import json
import math
import unittest
from collections import defaultdict
from model import *

class FormulaTests(unittest.TestCase):
    def test_native_receipt(self):
        result=json.loads((HERE/'native_verification.json').read_text())
        self.assertGreaterEqual(result['check_count'],2280)
        self.assertEqual(result['failures'],[])

    def test_known_thresholds(self):
        self.assertEqual(exp_at(100,'GROWTH_FAST'),800000)
        self.assertEqual(exp_at(100,'GROWTH_MEDIUM_FAST'),1000000)
        self.assertEqual(exp_at(100,'GROWTH_MEDIUM_SLOW'),1059860)
        self.assertEqual(exp_at(100,'GROWTH_SLOW'),1250000)
        for g in GROWTH:
            self.assertEqual(exp_at(1,g),0)
            for lv in range(2,101):
                self.assertGreater(exp_at(lv,g),exp_at(lv-1,g))
                self.assertEqual(level_of(exp_at(lv,g),g),lv)
                self.assertEqual(level_of(exp_at(lv,g)-1,g),lv-1)

    def test_order_of_operations(self):
        self.assertEqual(exp_award(127,50,3),600)
        self.assertNotEqual(exp_award(127,50,3),exp_award(127,50)//3)
        self.assertEqual(exp_award(127,50,2,share=True),442)
        self.assertEqual(exp_award(127,50,1,share=True),900)
        self.assertEqual(exp_award(127,50,trainer=False),907)
        self.assertEqual(exp_award(127,50,hard=False),1360)
        self.assertEqual(exp_award(127,50,traded=True,lucky=True),4080)
        self.assertEqual(exp_award(255,100),7284)

    def test_cap_clipping_discard_and_no_restore(self):
        m=party_new(dict(species='RATTATA',level=9))
        m['exp']=exp_at(10,m['growth'])-1
        earned,wasted,nominal=give([m],dict(base_exp=127,level=50),10,'lowest',0)
        self.assertEqual(earned,1)
        self.assertEqual(m['exp'],exp_at(10,m['growth']))
        self.assertEqual(wasted,nominal-1)
        earned,_,_=give([m],dict(base_exp=127,level=50),10,'lowest',0)
        self.assertEqual(earned,0)
        self.assertEqual(level_of(m['exp'],m['growth']),10)
        # Raising the cap does not restore the discarded award.
        self.assertEqual(m['exp'],exp_at(10,m['growth']))

    def test_capped_participant_does_not_steal_exp(self):
        t=[party_new(dict(species='RATTATA',level=l)) for l in [10,5]]
        earned,lost,_=give(t,dict(base_exp=64,level=5),10,'all_participants',0)
        self.assertEqual(earned,exp_award(64,5))
        self.assertEqual(lost,0)

    def test_all_capped_counts_loss_once(self):
        t=[party_new(dict(species='RATTATA',level=10)) for _ in range(6)]
        earned,lost,_=give(t,dict(base_exp=64,level=5),10,'all_participants',0)
        self.assertEqual(earned,0);self.assertEqual(lost,exp_award(64,5))

    def test_share_holder_and_participant_passes(self):
        t=[party_new(dict(species='RATTATA',level=40)) for _ in range(2)]
        gained,lost,_=give(t,dict(base_exp=127,level=10),62,'exp_share',0,True)
        self.assertEqual(gained,2*exp_award(127,10,share=True))
        self.assertEqual(lost,0)
        self.assertEqual(t[0]['earned'],t[1]['earned'])

class CoverageTests(unittest.TestCase):
    def test_every_species_party_reference_resolves(self):
        self.assertEqual(len(SP),498);self.assertEqual(len(PARTIES),595)
        for p in PARTIES.values():
            self.assertTrue(p['mons'])
            self.assertTrue(all(m['species'] in SP for m in p['mons']))
        self.assertEqual(len(DATA['maps']),406)
        for r in DATA['references']:self.assertIn(r['party_key'],PARTIES)
        self.assertFalse([e for e in EVENTS if e['stage']>=99])

    def test_wild_probabilities_and_surf_runtime(self):
        tables=defaultdict(float)
        for w in DATA['wild']:tables[w['table_label'],w['map'],w['time']]+=w['probability']
        self.assertTrue(all(abs(v-1)<1e-9 for v in tables.values()))
        fish=defaultdict(float)
        for w in DATA['fish']:fish[w['group'],w['method'],w['time']]+=w['probability_conditional_on_bite']
        self.assertTrue(all(abs(v-1)<1e-9 for v in fish.values()))
        self.assertAlmostEqual(sum(p for _,p in SURF_OFFSETS),1)

    def test_surf_access_before_morty(self):
        self.assertEqual(wild_distribution('CherrygroveCity',False),[])
        self.assertEqual(wild_distribution('RuinsOfAlphOutside',False),[])
        r=simulate(6,'completionist','equal_rotation')
        for z in r['zones']:
            if z['stage']<=3 and not any(w['map']==z['map'] and w['method']=='grass' for w in DATA['wild']):
                self.assertEqual(z['wild_earned'],0,z['map'])
        for row in r['checkpoints']:
            if row['badges']<4:self.assertTrue(wild_distribution(row['wild_map'],False))

    def test_no_double_counting(self):
        ids=[e['event_id'] for e in EVENTS]
        self.assertEqual(len(ids),len(set(ids)))
        self.assertEqual(sum(e['primary'] for e in EVENTS),42)
        self.assertEqual(sum(e['event_id'].startswith('camera') for e in EVENTS),10)
        self.assertEqual(sum(w['event_id'].startswith('floor_trap') for w in STATIC_EVENTS),22)
        for mp in ['CherrygroveCity','AzaleaTown','VioletCity','IcePath1F','MountMoon']:
            self.assertEqual(len([e for e in EVENTS if e['map']==mp and PARTIES[e['party_key']]['group'] in ['Rival1','Rival2','Crystal']]),1)
        twins=[e for e in EVENTS if e['event_id']=='EVENT_BEAT_TWINS_LEA_AND_PIA']
        self.assertEqual(len(twins),1)
        for style in PLAYSTYLES:
            result=simulate(6,style,'equal_rotation')
            ledger=[e['event_id'] for e in result['events']]
            self.assertEqual(len(ledger),len(set(ledger)))
            self.assertFalse(set(ledger)-set(ids))

    def test_delayed_recruitment_and_fresh_catches(self):
        r=simulate(6,'typical','equal_rotation')
        rows={x['milestone']:x for x in r['checkpoints'] if x['primary']}
        self.assertEqual(rows['Falkner']['party_size'],3)
        self.assertEqual(rows['Bugsy']['party_size'],4)
        self.assertEqual(rows['Whitney']['party_size'],5)
        self.assertEqual(rows['Morty']['party_size'],6)
        self.assertEqual(party_levels([party_new(dict(species='RATTATA',level=30))]),[30])

    def test_optional_repeatable_xp_never_awarded(self):
        r=simulate(6,'completionist','lowest')
        self.assertFalse(any(e['map']=='TrainerHouseB1F' for e in r['events']))
        self.assertFalse(any(e['party_key'].startswith('CAL:') for e in r['events']))

    def test_object_presence_and_ship_flags(self):
        self.assertFalse(any(e['trainer_id']=='STAN' and e['map']=='RuinsOfAlphOutside' for e in EVENTS))
        self.assertEqual(len(UNUSED_REFERENCES),1)
        first=[e for e in EVENTS if e['map'].startswith('FastShip')]
        self.assertEqual(len(first),8)
        self.assertTrue(any(e['trainer_id']=='STANLY' for e in first))
        self.assertFalse(any(e['trainer_id']=='GARRETT' for e in first))
        self.assertTrue(all(e['stage']>=4 for e in EVENTS if e['map']=='Route34' and e['trainer_id'] in ['IRENE','JENN','KATE']))

    def test_source_caps_and_permitted_order(self):
        self.assertEqual([cap_for(i) for i in range(17)],[10,16,20,25,30,34,38,45,50,54,58,62,62,62,66,69,100])
        bad=GYMS.copy();bad[5],bad[6]=bad[6],bad[5]
        with self.assertRaises(AssertionError):gym_order(bad)
        self.assertEqual(MAP_PLAN['ViridianGym']['stage'],15)
        self.assertEqual(MAP_PLAN['ViridianGym']['earliest_stage'],15)

    def test_boss_reward_not_used_to_reach_it(self):
        r=simulate(1,'minimal','equal_rotation')
        first=next(x for x in r['checkpoints'] if x['milestone']=='Falkner')
        # Falkner is absent from the non-primary battle ledger before him.
        ledger=[x for x in r['events'] if x['stage']==0]
        self.assertNotIn('Falkner:1',[x['party_key'] for x in ledger])
        self.assertEqual(first['segment_solo_available'],sum(PARTIES[x['party_key']]['solo_hard_exp'] for x in ledger))

    def test_late_routes_follow_flags(self):
        r=simulate(6,'typical','equal_rotation',skip_e4_rematch=True)
        names={x['milestone'] for x in r['checkpoints']}
        self.assertIn('Red Mt Silver',names);self.assertNotIn('Green',names);self.assertNotIn('Lance rematch',names)
        r=simulate(6,'typical','equal_rotation',early_cape=True)
        p=[x for x in r['checkpoints'] if x['primary']]
        names=[x['milestone'] for x in p]
        self.assertLess(names.index('Erika'),names.index('Crystal Cape'))
        self.assertEqual(len(names),len(set(names)))
        self.assertEqual(next(x['hard_cap'] for x in p if x['milestone']=='Crystal Cape'),62)

    def test_shared_corridors_and_clair_shrine(self):
        order=GYMS.copy();order[8],order[9]=order[9],order[8]
        r=simulate(6,'typical','equal_rotation',order=order)
        first=next(x for x in r['checkpoints'] if x['primary'] and x['stage']==8)
        self.assertEqual(first['milestone'],'Misty');self.assertEqual(first['badges'],8)
        self.assertTrue(any(e['stage']==8 and e['map']=='Route26' for e in r['events']))
        self.assertTrue(all(e['cap']==45 for e in r['events'] if e['map']=='DragonsDenB1F'))
        order=GYMS[:4]+['Jasmine','Chuck','Pryce']+GYMS[7:]
        r=simulate(6,'completionist','equal_rotation',order=order)
        self.assertTrue(all(e['stage']==4 for e in r['events'] if 'Lighthouse' in e['map']))
        self.assertTrue(all(e['stage']>=36 for e in r['events'] if e['map']=='SilverCaveOutside'))

    def test_story_boss_order(self):
        r=simulate(6,'completionist','equal_rotation')
        es=r['events'];idx=lambda key:next(i for i,e in enumerate(es) if e['party_key']==key)
        self.assertLess(idx('PetrelDirector:1'),idx('Rival1:12'))
        self.assertLess(idx('Rival1:12'),idx('Archer:2'))
        self.assertTrue(all(i<idx('Proton:1') for i,e in enumerate(es) if e['map']=='SlowpokeWellB1F' and e['party_key']!='Proton:1'))
        self.assertTrue(all(i<idx('Petrel:1') for i,e in enumerate(es) if e['map']=='TeamRocketBaseB3F' and e['party_key']!='Petrel:1'))

    def test_lighthouse_medicine_gate_and_default_timing(self):
        self.assertEqual(MAP_PLAN['OlivineLighthouse2F']['stage'],5)
        self.assertEqual(MAP_PLAN['OlivineLighthouse2F']['earliest_stage'],4)
        r=simulate(6,'completionist','equal_rotation')
        lighthouse=[e for e in r['events'] if e['map'].startswith('OlivineLighthouse')]
        self.assertEqual(len(lighthouse),11)
        self.assertTrue(all(e['stage']==5 and e['cap']==34 for e in lighthouse))
        self.assertEqual(sum(PARTIES[e['party_key']]['solo_hard_exp'] for e in lighthouse),30804)
        # The Cianwood trip is required, not Chuck's badge. Test the legal
        # medicine-return-before-Chuck alternative without claiming it is default.
        r=simulate(6,'completionist','equal_rotation',proposed={'event_stage_overrides':{e['event_id']:4 for e in EVENTS if e['map'].startswith('OlivineLighthouse')}})
        es=r['events'];first=next(i for i,e in enumerate(es) if e['map'].startswith('OlivineLighthouse'))
        self.assertTrue(any(e['map']=='CianwoodCity' for e in es[:first]))
        city=read('maps/OlivineCity.asm')
        self.assertIn('coord_event 28, 28, -1, OlivineCityJasmineSceneLeft',city)
        self.assertIn('checkitem SECRETPOTION',city)
        self.assertIn('setevent EVENT_JASMINE_RECEIVED_SECRETPOTION',city)
        order=GYMS[:4]+['Jasmine','Chuck','Pryce']+GYMS[7:]
        r=simulate(6,'completionist','equal_rotation',order=order,early_explore=True)
        self.assertTrue(all(e['stage']==4 for e in r['events'] if e['map'].startswith('OlivineLighthouse')))

if __name__=='__main__':unittest.main(verbosity=2)
