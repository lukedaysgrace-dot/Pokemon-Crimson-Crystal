TIME_GROUP EQU 0 ; use the nth TimeFishGroups entry

fishgroup: MACRO
; chance, old rod, good rod, super rod
	dbwww \1, \2, \3, \4
ENDM

FishGroups:
; entries correspond to FISHGROUP_* constants
	fishgroup 50 percent + 1, .Shore_Old,            .Shore_Good,            .Shore_Super
	fishgroup 50 percent + 1, .Ocean_Old,            .Ocean_Good,            .Ocean_Super
	fishgroup 50 percent + 1, .Lake_Old,             .Lake_Good,             .Lake_Super
	fishgroup 50 percent + 1, .Pond_Old,             .Pond_Good,             .Pond_Super
	fishgroup 50 percent + 1, .Dratini_Old,          .Dratini_Good,          .Dratini_Super
	fishgroup 50 percent + 1, .Qwilfish_Swarm_Old,   .Qwilfish_Swarm_Good,   .Qwilfish_Swarm_Super
	fishgroup 50 percent + 1, .Remoraid_Swarm_Old,   .Remoraid_Swarm_Good,   .Remoraid_Swarm_Super
	fishgroup 50 percent + 1, .Gyarados_Old,         .Gyarados_Good,         .Gyarados_Super
	fishgroup 50 percent + 1, .Dratini_2_Old,        .Dratini_2_Good,        .Dratini_2_Super
	fishgroup 50 percent + 1, .WhirlIslands_Old,     .WhirlIslands_Good,     .WhirlIslands_Super
	fishgroup 50 percent + 1, .Qwilfish_Old,         .Qwilfish_Good,         .Qwilfish_Super
	fishgroup 50 percent + 1, .Remoraid_Old,         .Remoraid_Good,         .Remoraid_Super
	fishgroup 50 percent + 1, .Qwilfish_NoSwarm_Old, .Qwilfish_NoSwarm_Good, .Qwilfish_NoSwarm_Super
	fishgroup 50 percent + 1, .Safari_Old,           .Safari_Good,           .Safari_Super
	fishgroup 50 percent + 1, .Ocean_Kanto_Old,      .Ocean_Kanto_Good,      .Ocean_Kanto_Super
	fishgroup 50 percent + 1, .Lake_Kanto_Old,       .Lake_Kanto_Good,       .Lake_Kanto_Super
	fishgroup 50 percent + 1, .Pond_Kanto_Old,       .Pond_Kanto_Good,       .Pond_Kanto_Super
	fishgroup 50 percent + 1, .SilverCave_Old,       .SilverCave_Good,       .SilverCave_Super
	fishgroup 50 percent + 1, .Ice_Old,              .Ice_Good,              .Ice_Super

.Shore_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, KRABBY
.Shore_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, KRABBY
	dbbw  90 percent + 1, 20, KRABBY
	dbbw 100 percent,      0, TIME_GROUP
.Shore_Super:
	dbbw  40 percent,     40, KRABBY
	dbbw  70 percent,      1, TIME_GROUP
	dbbw  90 percent + 1, 40, KRABBY
	dbbw 100 percent,     40, KINGLER

.Ocean_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, TENTACOOL
.Ocean_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, TENTACOOL
	dbbw  90 percent + 1, 20, CHINCHOU
	dbbw 100 percent,      2, TIME_GROUP
.Ocean_Super:
	dbbw  40 percent,     40, CHINCHOU
	dbbw  70 percent,      3, TIME_GROUP
	dbbw  90 percent + 1, 40, TENTACRUEL
	dbbw 100 percent,     40, LANTURN

.Lake_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, GOLDEEN
.Lake_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, GOLDEEN
	dbbw  90 percent + 1, 20, GOLDEEN
	dbbw 100 percent,      4, TIME_GROUP
.Lake_Super:
	dbbw  40 percent,     40, GOLDEEN
	dbbw  70 percent,      5, TIME_GROUP
	dbbw  90 percent + 1, 40, SEAKING
	dbbw 100 percent,     40, GYARADOS

.Pond_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, POLIWAG
.Pond_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, POLIWAG
	dbbw  90 percent + 1, 20, POLIWAG
	dbbw 100 percent,      6, TIME_GROUP
.Pond_Super:
	dbbw  40 percent,     40, POLIWAG
	dbbw  70 percent,      7, TIME_GROUP
	dbbw  90 percent + 1, 40, POLIWHIRL
	dbbw 100 percent,     40, POLIWRATH

.Dratini_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, MAGIKARP
.Dratini_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, MAGIKARP
	dbbw  90 percent + 1, 20, MAGIKARP
	dbbw 100 percent,      8, TIME_GROUP
.Dratini_Super:
	dbbw  40 percent,     40, MAGIKARP
	dbbw  70 percent,      9, TIME_GROUP
	dbbw  90 percent + 1, 40, MAGIKARP
	dbbw 100 percent,     40, DRAGONAIR

.Qwilfish_Swarm_Old:
	dbbw  70 percent + 1,  5, MAGIKARP
	dbbw  85 percent + 1,  5, MAGIKARP
	dbbw 100 percent,      5, QWILFISH
.Qwilfish_Swarm_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, QWILFISH
	dbbw  90 percent + 1, 20, QWILFISH
	dbbw 100 percent,     10, TIME_GROUP
.Qwilfish_Swarm_Super:
	dbbw  40 percent,     40, QWILFISH
	dbbw  70 percent,     11, TIME_GROUP
	dbbw  90 percent + 1, 40, QWILFISH
	dbbw 100 percent,     40, QWILFISH

.Remoraid_Swarm_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, REMORAID
.Remoraid_Swarm_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, REMORAID
	dbbw  90 percent + 1, 20, REMORAID
	dbbw 100 percent,     12, TIME_GROUP
.Remoraid_Swarm_Super:
	dbbw  40 percent,     40, REMORAID
	dbbw  70 percent,     13, TIME_GROUP
	dbbw  90 percent + 1, 40, REMORAID
	dbbw 100 percent,     40, REMORAID

.Gyarados_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, MAGIKARP
.Gyarados_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, MAGIKARP
	dbbw  90 percent + 1, 20, MAGIKARP
	dbbw 100 percent,     14, TIME_GROUP
.Gyarados_Super:
	dbbw  40 percent,     40, MAGIKARP
	dbbw  70 percent,     15, TIME_GROUP
	dbbw  90 percent + 1, 40, MAGIKARP
	dbbw 100 percent,     40, MAGIKARP

; UNUSED. Dratini is a gift (EVENT_GOT_DRATINI) and is wild in Dragon's Den
; only, so Route 45 moved to FISHGROUP_LAKE. The constant is kept so no
; existing FISHGROUP_* index shifts; the table no longer yields dragons.
.Dratini_2_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, MAGIKARP
.Dratini_2_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, MAGIKARP
	dbbw  90 percent + 1, 20, MAGIKARP
	dbbw 100 percent,     20, MAGIKARP
.Dratini_2_Super:
	dbbw  40 percent,     40, MAGIKARP
	dbbw  70 percent,     40, MAGIKARP
	dbbw  90 percent + 1, 40, MAGIKARP
	dbbw 100 percent,     40, GYARADOS

.WhirlIslands_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, KRABBY
.WhirlIslands_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, KRABBY
	dbbw  90 percent + 1, 20, KRABBY
	dbbw 100 percent,     18, TIME_GROUP
.WhirlIslands_Super:
	dbbw  40 percent,     40, KRABBY
	dbbw  70 percent,     19, TIME_GROUP
	dbbw  90 percent + 1, 40, SEADRA
	dbbw 100 percent,     40, KINGDRA

.Qwilfish_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, TENTACOOL
	dbbw 100 percent,     10, QWILFISH
.Qwilfish_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, TENTACOOL
	dbbw  90 percent + 1, 20, QWILFISH
	dbbw 100 percent,     20, TIME_GROUP
.Qwilfish_Super:
	dbbw  40 percent,     40, TENTACOOL
	dbbw  70 percent,     21, TIME_GROUP
	dbbw  90 percent + 1, 40, QWILFISH
	dbbw 100 percent,     40, OVERQWIL

; Same water, no Qwilfish swarm running: Qwilfish drops to the rarest slot
; and Tentacruel fills the common ones.
.Qwilfish_NoSwarm_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, MAGIKARP
	dbbw 100 percent,     10, TENTACOOL
.Qwilfish_NoSwarm_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, TENTACOOL
	dbbw  90 percent + 1, 20, TENTACOOL
	dbbw 100 percent,     20, TIME_GROUP
.Qwilfish_NoSwarm_Super:
	dbbw  40 percent,     40, TENTACOOL
	dbbw  70 percent,     21, TIME_GROUP
	dbbw  90 percent + 1, 40, TENTACRUEL
	dbbw 100 percent,     40, QWILFISH

.Remoraid_Old:
	dbbw  70 percent + 1, 10, MAGIKARP
	dbbw  85 percent + 1, 10, POLIWAG
	dbbw 100 percent,     10, REMORAID
.Remoraid_Good:
	dbbw  35 percent,     20, MAGIKARP
	dbbw  70 percent,     20, POLIWAG
	dbbw  90 percent + 1, 20, REMORAID
	dbbw 100 percent,     12, TIME_GROUP
.Remoraid_Super:
	dbbw  40 percent,     40, REMORAID
	dbbw  70 percent,     13, TIME_GROUP
	dbbw  90 percent + 1, 40, REMORAID
	dbbw 100 percent,     40, OCTILLERY

; Safari Zone rods. Everything here is a base form, so the area's low level
; band never produces an evolution below its own evolution level. Paldean
; Wooper, Galarian Slowpoke and Galarian Corsola moved to land tables - all
; three are land dwellers in their home games and cannot be fished up.
.Safari_Old:
	dbbw  40 percent,      8, QWILFISH
	dbbw  72 percent,      8, GOLDEEN
	dbbw  88 percent,      9, WIMPOD
	dbbw 100 percent,      9, MAREANIE
.Safari_Good:
	dbbw  30 percent,      9, QWILFISH
	dbbw  55 percent,      9, GOLDEEN
	dbbw  70 percent,     10, WIMPOD
	dbbw  82 percent,     10, KABUTO
	dbbw  92 percent,     10, OMANYTE
	dbbw  97 percent,     11, ANORITH
	dbbw 100 percent,     11, MANTYKE
.Safari_Super:
	dbbw  25 percent,     11, QWILFISH
	dbbw  45 percent,     11, GOLDEEN
	dbbw  62 percent,     11, TIRTOUGA
	dbbw  78 percent,     11, LILEEP
	dbbw  90 percent,     12, MANTYKE
	dbbw 100 percent,     12, ANORITH

; Kanto and Silver Cave run 28-48 levels above the shared Old 10 / Good 20 /
; Super 40 band, so they get their own scaled groups instead of dragging
; Johto's rods up with them.
.Ocean_Kanto_Old:
	dbbw  70 percent + 1, 40, MAGIKARP
	dbbw  85 percent + 1, 40, TENTACOOL
	dbbw 100 percent,     45, KRABBY
.Ocean_Kanto_Good:
	dbbw  35 percent,     55, MAGIKARP
	dbbw  70 percent,     55, TENTACOOL
	dbbw  90 percent + 1, 58, CHINCHOU
	dbbw 100 percent,     58, SHELLDER
.Ocean_Kanto_Super:
	dbbw  40 percent,     70, TENTACOOL
	dbbw  70 percent,     72, CHINCHOU
	dbbw  90 percent + 1, 74, TENTACRUEL
	dbbw 100 percent,     75, LANTURN

.Lake_Kanto_Old:
	dbbw  70 percent + 1, 40, MAGIKARP
	dbbw  85 percent + 1, 40, GOLDEEN
	dbbw 100 percent,     45, POLIWAG
.Lake_Kanto_Good:
	dbbw  35 percent,     55, MAGIKARP
	dbbw  70 percent,     55, GOLDEEN
	dbbw  90 percent + 1, 58, SEAKING
	dbbw 100 percent,     58, GYARADOS
.Lake_Kanto_Super:
	dbbw  40 percent,     68, GOLDEEN
	dbbw  70 percent,     70, SEAKING
	dbbw  90 percent + 1, 72, POLIWHIRL
	dbbw 100 percent,     72, GYARADOS

.Pond_Kanto_Old:
	dbbw  70 percent + 1, 40, MAGIKARP
	dbbw  85 percent + 1, 40, POLIWAG
	dbbw 100 percent,     45, PSYDUCK
.Pond_Kanto_Good:
	dbbw  35 percent,     55, MAGIKARP
	dbbw  70 percent,     55, POLIWAG
	dbbw  90 percent + 1, 58, POLIWHIRL
	dbbw 100 percent,     58, GOLDUCK
.Pond_Kanto_Super:
	dbbw  40 percent,     68, POLIWHIRL
	dbbw  70 percent,     70, GOLDUCK
	dbbw  90 percent + 1, 72, GYARADOS
	dbbw 100 percent,     72, POLIWRATH

.SilverCave_Old:
	dbbw  70 percent + 1, 50, MAGIKARP
	dbbw  85 percent + 1, 50, GOLDEEN
	dbbw 100 percent,     55, POLIWAG
.SilverCave_Good:
	dbbw  35 percent,     62, MAGIKARP
	dbbw  70 percent,     62, SEAKING
	dbbw  90 percent + 1, 65, POLIWHIRL
	dbbw 100 percent,     66, GYARADOS
.SilverCave_Super:
	dbbw  40 percent,     72, SEAKING
	dbbw  70 percent,     73, POLIWRATH
	dbbw  90 percent + 1, 75, GYARADOS
	dbbw 100 percent,     76, DRAGONAIR

; Ice Path, Shiver Isle and Ice Island. These were on FISHGROUP_DRATINI,
; which fished Dratini and Dragonair out of a glacier.
.Ice_Old:
	dbbw  70 percent + 1, 25, MAGIKARP
	dbbw  85 percent + 1, 25, SEEL
	dbbw 100 percent,     28, SPHEAL
.Ice_Good:
	dbbw  35 percent,     33, MAGIKARP
	dbbw  70 percent,     33, SEEL
	dbbw  90 percent + 1, 36, SPHEAL
	dbbw 100 percent,     36, DEWGONG
.Ice_Super:
	dbbw  40 percent,     40, SEEL
	dbbw  70 percent,     42, SEALEO
	dbbw  90 percent + 1, 44, DEWGONG
	dbbw 100 percent,     45, WALREIN

TimeFishGroups:
	;     day             nite
	dbwbw 20, CORSOLA,    20, STARYU     ; 0
	dbwbw 40, CORSOLA,    40, STARYU     ; 1
	dbwbw 20, SHELLDER,   20, SHELLDER   ; 2
	dbwbw 40, SHELLDER,   40, SHELLDER   ; 3
	dbwbw 20, GOLDEEN,    20, GOLDEEN    ; 4
	dbwbw 40, GOLDEEN,    40, GOLDEEN    ; 5
	dbwbw 20, POLIWAG,    20, POLIWAG    ; 6
	dbwbw 40, POLIWAG,    40, POLIWAG    ; 7
	dbwbw 20, DRATINI,    20, DRATINI    ; 8
	dbwbw 40, DRATINI,    40, DRATINI    ; 9
	dbwbw 20, QWILFISH,   20, QWILFISH   ; 10
	dbwbw 40, QWILFISH,   40, QWILFISH   ; 11
	dbwbw 20, REMORAID,   20, REMORAID   ; 12
	dbwbw 40, REMORAID,   40, REMORAID   ; 13
	dbwbw 20, GYARADOS,   20, GYARADOS   ; 14
	dbwbw 40, GYARADOS,   40, GYARADOS   ; 15
	dbwbw 20, MAGIKARP,   20, MAGIKARP   ; 16 - unused (was DRATINI, for .Dratini_2)
	dbwbw 40, MAGIKARP,   40, MAGIKARP   ; 17 - unused (was DRATINI, for .Dratini_2)
	dbwbw 20, HORSEA,     20, HORSEA     ; 18
	dbwbw 40, HORSEA,     40, HORSEA     ; 19
	dbwbw 20, TENTACOOL,  20, TENTACOOL  ; 20
	dbwbw 40, TENTACOOL,  40, TENTACOOL  ; 21
