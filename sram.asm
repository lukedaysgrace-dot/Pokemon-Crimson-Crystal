SECTION "Scratch", SRAM

UNION ; a000
sScratch:: ds $600 ; a000
; a600

NEXTU ; a000
sEnemyFrontPicTileCount:: db ; a000
sPaddedEnemyFrontPic:: ds 7 * 7 tiles ; a001
; a311

NEXTU ; a000
; Legacy box layout, overlaying scratch space.
; The real storage system is the PokeDB (see "PokeDB bank" sections).
; This only exists so that unreachable legacy code (mobile, etc.) that
; still references the old active-box layout continues to assemble.
sBox:: box sBox

; More legacy aliases (all overlapping; only referenced by dead code).
sBox1::
sBox2::
sBox3::
sBox4::
sBox5::
sBox6::
sBox7::
sBox8::
sBox9::
sBox10::
sBox11::
sBox12::
sBox13::
sBox14::
sBox1PokemonIndexes::
sBox2PokemonIndexes::
sBox3PokemonIndexes::
sBox4PokemonIndexes::
sBox5PokemonIndexes::
sBox6PokemonIndexes::
sBox7PokemonIndexes::
sBox8PokemonIndexes::
sBox9PokemonIndexes::
sBox10PokemonIndexes::
sBox11PokemonIndexes::
sBox12PokemonIndexes::
sBox13PokemonIndexes::
sBox14PokemonIndexes:: ds 2 * MONS_PER_BOX

sBox1End::
sBox2End::
sBox3End::
sBox4End::
sBox5End::
sBox6End::
sBox7End::
sBox8End::
sBox9End::
sBox10End::
sBox11End::
sBox12End::
sBox13End::
sBox14End::

ENDU ; a600

SECTION "SRAM Bank 0", SRAM

; a600
sPartyMail::
sPartyMon1Mail:: mailmsg sPartyMon1Mail
sPartyMon2Mail:: mailmsg sPartyMon2Mail
sPartyMon3Mail:: mailmsg sPartyMon3Mail
sPartyMon4Mail:: mailmsg sPartyMon4Mail
sPartyMon5Mail:: mailmsg sPartyMon5Mail
sPartyMon6Mail:: mailmsg sPartyMon6Mail

; a71a
sPartyMailBackup::
sPartyMon1MailBackup:: mailmsg sPartyMon1MailBackup
sPartyMon2MailBackup:: mailmsg sPartyMon2MailBackup
sPartyMon3MailBackup:: mailmsg sPartyMon3MailBackup
sPartyMon4MailBackup:: mailmsg sPartyMon4MailBackup
sPartyMon5MailBackup:: mailmsg sPartyMon5MailBackup
sPartyMon6MailBackup:: mailmsg sPartyMon6MailBackup

; a834
sMailboxCount:: db
sMailbox::
sMailbox1::  mailmsg sMailbox1
sMailbox2::  mailmsg sMailbox2
sMailbox3::  mailmsg sMailbox3
sMailbox4::  mailmsg sMailbox4
sMailbox5::  mailmsg sMailbox5
sMailbox6::  mailmsg sMailbox6
sMailbox7::  mailmsg sMailbox7
sMailbox8::  mailmsg sMailbox8
sMailbox9::  mailmsg sMailbox9
sMailbox10:: mailmsg sMailbox10

; aa0b
sMailboxCountBackup:: db
sMailboxBackup::
sMailbox1Backup::  mailmsg sMailbox1Backup
sMailbox2Backup::  mailmsg sMailbox2Backup
sMailbox3Backup::  mailmsg sMailbox3Backup
sMailbox4Backup::  mailmsg sMailbox4Backup
sMailbox5Backup::  mailmsg sMailbox5Backup
sMailbox6Backup::  mailmsg sMailbox6Backup
sMailbox7Backup::  mailmsg sMailbox7Backup
sMailbox8Backup::  mailmsg sMailbox8Backup
sMailbox9Backup::  mailmsg sMailbox9Backup
sMailbox10Backup:: mailmsg sMailbox10Backup

; abe2
sMysteryGiftItem:: db
sMysteryGiftUnlocked:: db
sBackupMysteryGiftItem:: db
sNumDailyMysteryGiftPartnerIDs:: db
sDailyMysteryGiftPartnerIDs:: ds 5 * 2 ; maximum 5 per day, 2 bytes per ID
sMysteryGiftDecorationsReceived:: flag_array NUM_NON_TROPHY_DECOS
	ds 4
sMysteryGiftTimer:: db
sMysteryGiftTimerStartDay:: db
	ds 1
sMysteryGiftTrainerHouseFlag:: db
sMysteryGiftPartnerName:: ds NAME_LENGTH
s0_ac09:: ds 1
sMysteryGiftTrainer:: ds (1 + 1 + NUM_MOVES) * PARTY_LENGTH + 2 ; ac0a
sBackupMysteryGiftItemEnd::

	ds $30

sRTCStatusFlags:: ds 8
sLuckyNumberDay:: db
sLuckyIDNumber::  dw

SECTION "Saved 16-bit conversion tables", SRAM
; the Pokémon index table isn't stored here to improve save data packing
sMoveIndexTable:: ds wMoveIndexTableEnd - wMoveIndexTable
sBackupMoveIndexTable:: ds wMoveIndexTableEnd - wMoveIndexTable

SECTION "Backup Save", SRAM

sBackupOptions:: ds wOptionsEnd - wOptions

sBackupCheckValue1:: db ; loaded with SAVE_CHECK_VALUE_1, used to check save corruption

sBackupSaveData::

sBackupGameData:: ; b209
sBackupPlayerData::  ds wPlayerDataEnd - wPlayerData
sBackupCurMapData::  ds wCurMapDataEnd - wCurMapData
sBackupPokemonData:: ds wPokemonDataEnd - wPokemonData
sBackupGameDataEnd::

sBackupPokemonIndexTable:: ds wPokemonIndexTableEnd - wPokemonIndexTable

sBackupConversionTableChecksum:: dw

sBackupSaveDataEnd::

; bd85
	ds $88
; bf0d

sBackupChecksum:: dw

sBackupCheckValue2:: db ; loaded with SAVE_CHECK_VALUE_2, used to check save corruption

sStackTop:: dw


SECTION "Save", SRAM

sOptions:: ds wOptionsEnd - wOptions

sCheckValue1:: db ; loaded with SAVE_CHECK_VALUE_1, used to check save corruption

sSaveData::

sGameData:: ; a009
sPlayerData::  ds wPlayerDataEnd - wPlayerData
sCurMapData::  ds wCurMapDataEnd - wCurMapData
sPokemonData:: ds wPokemonDataEnd - wPokemonData
sGameDataEnd::

sPokemonIndexTable:: ds wPokemonIndexTableEnd - wPokemonIndexTable

sConversionTableChecksum:: dw

sSaveDataEnd::

; ab85
	ds $88
; ad0d

sChecksum:: dw

sCheckValue2:: db ; loaded with SAVE_CHECK_VALUE_2, used to check save corruption


SECTION "Box metadata", SRAM

; Storage system box metadata: per-box entry lists, database-copy bits,
; box names and themes. The mons themselves live in the PokeDB sections.
sNewBox1::  newbox sNewBox1
sNewBox2::  newbox sNewBox2
sNewBox3::  newbox sNewBox3
sNewBox4::  newbox sNewBox4
sNewBox5::  newbox sNewBox5
sNewBox6::  newbox sNewBox6
sNewBox7::  newbox sNewBox7
sNewBox8::  newbox sNewBox8
sNewBox9::  newbox sNewBox9
sNewBox10:: newbox sNewBox10
sNewBox11:: newbox sNewBox11
sNewBox12:: newbox sNewBox12
sNewBox13:: newbox sNewBox13
sNewBox14:: newbox sNewBox14
sNewBox15:: newbox sNewBox15
sNewBox16:: newbox sNewBox16
sNewBox17:: newbox sNewBox17
sNewBox18:: newbox sNewBox18
sNewBox19:: newbox sNewBox19
sNewBox20:: newbox sNewBox20
sNewBoxEnd::

sBackupNewBox1::  newbox sBackupNewBox1
sBackupNewBox2::  newbox sBackupNewBox2
sBackupNewBox3::  newbox sBackupNewBox3
sBackupNewBox4::  newbox sBackupNewBox4
sBackupNewBox5::  newbox sBackupNewBox5
sBackupNewBox6::  newbox sBackupNewBox6
sBackupNewBox7::  newbox sBackupNewBox7
sBackupNewBox8::  newbox sBackupNewBox8
sBackupNewBox9::  newbox sBackupNewBox9
sBackupNewBox10:: newbox sBackupNewBox10
sBackupNewBox11:: newbox sBackupNewBox11
sBackupNewBox12:: newbox sBackupNewBox12
sBackupNewBox13:: newbox sBackupNewBox13
sBackupNewBox14:: newbox sBackupNewBox14
sBackupNewBox15:: newbox sBackupNewBox15
sBackupNewBox16:: newbox sBackupNewBox16
sBackupNewBox17:: newbox sBackupNewBox17
sBackupNewBox18:: newbox sBackupNewBox18
sBackupNewBox19:: newbox sBackupNewBox19
sBackupNewBox20:: newbox sBackupNewBox20
sBackupNewBoxEnd::


SECTION "Link Battle Data", SRAM

sLinkBattleResults:: ds $c

sLinkBattleStats::
sLinkBattleWins::   dw ; b260
sLinkBattleLosses:: dw ; b262
sLinkBattleDraws::  dw ; b264

sLinkBattleRecord::
sLinkBattleRecord1:: link_battle_record sLinkBattleRecord1
sLinkBattleRecord2:: link_battle_record sLinkBattleRecord2
sLinkBattleRecord3:: link_battle_record sLinkBattleRecord3
sLinkBattleRecord4:: link_battle_record sLinkBattleRecord4
sLinkBattleRecord5:: link_battle_record sLinkBattleRecord5
sLinkBattleStatsEnd::


SECTION "SRAM Hall of Fame", SRAM

sHallOfFame:: ; b2c0
sHallOfFame01:: hall_of_fame sHallOfFame01
sHallOfFame02:: hall_of_fame sHallOfFame02
sHallOfFame03:: hall_of_fame sHallOfFame03
sHallOfFame04:: hall_of_fame sHallOfFame04
sHallOfFame05:: hall_of_fame sHallOfFame05
sHallOfFame06:: hall_of_fame sHallOfFame06
sHallOfFame07:: hall_of_fame sHallOfFame07
sHallOfFame08:: hall_of_fame sHallOfFame08
sHallOfFame09:: hall_of_fame sHallOfFame09
sHallOfFame10:: hall_of_fame sHallOfFame10
sHallOfFame11:: hall_of_fame sHallOfFame11
sHallOfFame12:: hall_of_fame sHallOfFame12
sHallOfFame13:: hall_of_fame sHallOfFame13
sHallOfFame14:: hall_of_fame sHallOfFame14
sHallOfFame15:: hall_of_fame sHallOfFame15
sHallOfFame16:: hall_of_fame sHallOfFame16
sHallOfFame17:: hall_of_fame sHallOfFame17
sHallOfFame18:: hall_of_fame sHallOfFame18
sHallOfFame19:: hall_of_fame sHallOfFame19
sHallOfFame20:: hall_of_fame sHallOfFame20
sHallOfFame21:: hall_of_fame sHallOfFame21
sHallOfFame22:: hall_of_fame sHallOfFame22
sHallOfFame23:: hall_of_fame sHallOfFame23
sHallOfFame24:: hall_of_fame sHallOfFame24
sHallOfFame25:: hall_of_fame sHallOfFame25
sHallOfFame26:: hall_of_fame sHallOfFame26
sHallOfFame27:: hall_of_fame sHallOfFame27
sHallOfFame28:: hall_of_fame sHallOfFame28
sHallOfFame29:: hall_of_fame sHallOfFame29
sHallOfFame30:: hall_of_fame sHallOfFame30
sHallOfFameEnd::


SECTION "SRAM Crystal Data", SRAM

sMobileEventIndex:: db ; bf0e

sCrystalData:: ds wCrystalDataEnd - wCrystalData

sMobileEventIndexBackup:: db ; bf16


SECTION "SRAM Battle Tower", SRAM

; Battle Tower data must be in SRAM because you can save and leave between battles
sBattleTowerChallengeState::
; 0: normal
; 2: battle tower
	db

sBattleTower:: ; bf18
sNrOfBeatenBattleTowerTrainers:: db
sBTChoiceOfLevelGroup:: db
; Battle Tower trainers are saved here, so nobody appears more than once
sBTTrainers:: ds BATTLETOWER_STREAK_LENGTH ; bf1a
sBattleTowerSaveFileFlags:: db
sBattleTowerReward:: db

; team of previous trainer
sBTMonOfTrainers:: ; bf23
sBTMonPrevTrainer1:: dw
sBTMonPrevTrainer2:: dw
sBTMonPrevTrainer3:: dw
; team of preprevious trainer
sBTMonPrevPrevTrainer1:: dw
sBTMonPrevPrevTrainer2:: dw
sBTMonPrevPrevTrainer3:: dw


SECTION "PokeDB bank 1A", SRAM, BANK [2]

sBoxMons1A:: pokedb sBoxMons1A, MONDB_ENTRIES_A


SECTION "PokeDB bank 2A", SRAM, BANK [3]

sBoxMons2A:: pokedb sBoxMons2A, MONDB_ENTRIES_A


SECTION "PokeDB bank 1B", SRAM

sBoxMons1B:: pokedb sBoxMons1B, MONDB_ENTRIES_B


SECTION "PokeDB bank 1C", SRAM

sBoxMons1C:: pokedb sBoxMons1C, MONDB_ENTRIES_C


SECTION "PokeDB bank 2B", SRAM

sBoxMons2B:: pokedb sBoxMons2B, MONDB_ENTRIES_B


SECTION "PokeDB bank 2C", SRAM

sBoxMons2C:: pokedb sBoxMons2C, MONDB_ENTRIES_C

SECTION "SRAM Mobile 1", SRAM

	ds $13

s4_a013:: ds 36 ; a013

SECTION "SRAM Mobile 2", SRAM

	ds 1 ; former location for sMobileEventIndex, moved to 1:BE3C in English

sTrainerRankings:: ; a001
sTrainerRankingGameTimeHOF:: ds 4
sTrainerRankingStepCountHOF:: ds 4
sTrainerRankingHealingsHOF:: ds 4
sTrainerRankingBattlesHOF:: ds 3
sTrainerRankingStepCount:: ds 4
sTrainerRankingBattleTowerWins:: ds 4
sTrainerRankingTMsHMsTaught:: ds 3
sTrainerRankingBattles:: ds 3
sTrainerRankingWildBattles:: ds 3
sTrainerRankingTrainerBattles:: ds 3
sTrainerRankingUnused1:: ds 3
sTrainerRankingHOFEntries:: ds 3
sTrainerRankingWildMonsCaught:: ds 3
sTrainerRankingHookedEncounters:: ds 3
sTrainerRankingEggsHatched:: ds 3
sTrainerRankingMonsEvolved:: ds 3
sTrainerRankingFruitPicked:: ds 3
sTrainerRankingHealings:: ds 3
sTrainerRankingMysteryGift:: ds 3
sTrainerRankingTrades:: ds 3
sTrainerRankingFly:: ds 3
sTrainerRankingSurf:: ds 3
sTrainerRankingWaterfall:: ds 3
sTrainerRankingWhiteOuts:: ds 3
sTrainerRankingLuckyNumberShow:: ds 3
sTrainerRankingPhoneCalls:: ds 3
sTrainerRankingUnused2:: ds 3
sTrainerRankingLinkBattles:: ds 3
sTrainerRankingSplash:: ds 3
sTrainerRankingTreeEncounters:: ds 3
sTrainerRankingUnused3:: ds 3
sTrainerRankingColosseumWins:: ds 3
sTrainerRankingColosseumLosses:: ds 3
sTrainerRankingColosseumDraws:: ds 3
sTrainerRankingSelfdestruct:: ds 3
sTrainerRankingCurrentSlotsStreak:: ds 2
sTrainerRankingLongestSlotsStreak:: ds 2
sTrainerRankingTotalSlotsPayouts:: ds 4
sTrainerRankingTotalBattlePayouts:: ds 4
sTrainerRankingLongestMagikarp:: ds 2
sTrainerRankingShortestMagikarp:: ds 2
sTrainerRankingBugContestScore:: ds 2
sTrainerRankingsChecksum:: ds 2
sTrainerRankingsEnd:: ; a083

	ds 1 ; Former location for sMobileEventIndexBackup, moved to 1:BE44 in English

sTrainerRankingsBackup:: ds sTrainerRankingsEnd - sTrainerRankings ; a084

	ds $6fa

s5_a800:: db ; a800

	ds $24

s5_a825:: db ; a825
s5_a826:: db ; a826

	ds $6d

s5_a894:: ds NAME_LENGTH_JAPANESE ; a894

	ds $2

s5_a89c:: ds 22 ; a89c
s5_a8b2:: ds 150 ; a8b2

s5_a948:: ds 246 ; a948

	ds $3

s5_aa41:: ds 4 ; aa41

	ds $2

s5_aa47:: db ; aa47
s5_aa48:: db ; aa48

	ds $2

sMobileLoginPassword:: ds MOBILE_LOGIN_PASSWORD_LENGTH ; aa4b

	ds $1

s5_aa5d:: ds MOBILE_LOGIN_PASSWORD_LENGTH ; aa5d

	ds $1d

s5_aa8b:: db ; aa8b
s5_aa8c:: db ; aa8c
s5_aa8d:: db ; aa8d
s5_aa8e:: ds 7 * $cc ; aa8e

	ds $1

s5_b023:: ds 105 ; b023
s5_b08c:: ds 4 ; b08c

	ds $269

s5_b2f9:: db ; b2f9
s5_b2fa:: db ; b2fa
s5_b2fb:: db ; b2fb

	ds $b49

s5_be45:: db ; be45
s5_be46:: db ; be46
