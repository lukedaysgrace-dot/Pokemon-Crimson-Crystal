; Generic daily overcast areas. Adjacent maps intentionally share one roll.
; Only areas in WeatherAreaPointers can be selected for the daily 4+4 pool.

WeatherAreaPointers:
	; Johto
	dw WeatherArea_NewBark
	dw WeatherArea_Cherrygrove
	dw WeatherArea_Violet
	dw WeatherArea_Goldenrod
	dw WeatherArea_NationalPark
	dw WeatherArea_EcruteakEast
	dw WeatherArea_EcruteakWest
	dw WeatherArea_OlivineCoast
	dw WeatherArea_Cianwood
	dw WeatherArea_TohjoFalls
	dw WeatherArea_Blackthorn
WeatherAreaPointersJohtoEnd:
	; Kanto
	dw WeatherArea_Pallet
	dw WeatherArea_Viridian
	dw WeatherArea_Pewter
	dw WeatherArea_Cerulean
	dw WeatherArea_Saffron
	dw WeatherArea_Vermilion
	dw WeatherArea_Celadon
	dw WeatherArea_Lavender
	dw WeatherArea_Fuchsia
	dw WeatherArea_CyclingRoad
	dw WeatherArea_Cinnabar
	dw WeatherArea_Indigo
WeatherAreaPointersEnd:

NUM_JOHTO_WEATHER_AREAS EQU (WeatherAreaPointersJohtoEnd - WeatherAreaPointers) / 2
NUM_KANTO_WEATHER_AREAS EQU (WeatherAreaPointersEnd - WeatherAreaPointersJohtoEnd) / 2

WeatherArea_NewBark:
	map_id NEW_BARK_TOWN
	map_id ROUTE_29
	db -1
WeatherArea_Cherrygrove:
	map_id CHERRYGROVE_CITY
	map_id ROUTE_30
	map_id ROUTE_31
	db -1
WeatherArea_Violet:
	map_id VIOLET_CITY
	map_id ROUTE_32
	db -1
WeatherArea_Goldenrod:
	map_id GOLDENROD_CITY
	map_id ROUTE_34
	db -1
WeatherArea_NationalPark:
	map_id ROUTE_35
	map_id NATIONAL_PARK
	map_id NATIONAL_PARK_BUG_CONTEST
	db -1
WeatherArea_EcruteakEast:
	map_id ROUTE_36
	map_id ROUTE_37
	map_id ECRUTEAK_CITY
	db -1
WeatherArea_EcruteakWest:
	map_id ROUTE_38
	map_id ROUTE_39
	db -1
WeatherArea_OlivineCoast:
	map_id OLIVINE_CITY
	map_id OLIVINE_PORT
	map_id ROUTE_40
	map_id BATTLE_TOWER_OUTSIDE
	db -1
WeatherArea_Cianwood:
	map_id ROUTE_41
	map_id CIANWOOD_CITY
	db -1
WeatherArea_TohjoFalls:
	map_id ROUTE_26
	map_id ROUTE_27
	db -1
WeatherArea_Blackthorn:
	map_id BLACKTHORN_CITY
	db -1

WeatherArea_Pallet:
	map_id PALLET_TOWN
	map_id ROUTE_1
	db -1
WeatherArea_Viridian:
	map_id VIRIDIAN_CITY
	map_id ROUTE_2
	db -1
WeatherArea_Pewter:
	map_id PEWTER_CITY
	map_id ROUTE_3
	map_id MOUNT_MOON_SQUARE
	db -1
WeatherArea_Cerulean:
	map_id CERULEAN_CITY
	map_id ROUTE_4
	map_id ROUTE_9
	map_id ROUTE_10_NORTH
	map_id ROUTE_24
	map_id ROUTE_25
	db -1
WeatherArea_Saffron:
	map_id SAFFRON_CITY
	map_id ROUTE_5
	map_id ROUTE_6
	db -1
WeatherArea_Vermilion:
	map_id VERMILION_CITY
	map_id VERMILION_PORT
	map_id ROUTE_11
	db -1
WeatherArea_Celadon:
	map_id CELADON_CITY
	map_id ROUTE_7
	map_id ROUTE_16
	db -1
WeatherArea_Lavender:
	map_id LAVENDER_TOWN
	map_id ROUTE_8
	map_id ROUTE_10_SOUTH
	map_id ROUTE_12
	db -1
WeatherArea_Fuchsia:
	map_id FUCHSIA_CITY
	map_id ROUTE_13
	map_id ROUTE_14
	map_id ROUTE_15
	map_id ROUTE_18
	db -1
WeatherArea_CyclingRoad:
	map_id ROUTE_17
	db -1
WeatherArea_Cinnabar:
	map_id CINNABAR_ISLAND
	map_id ROUTE_19
	map_id ROUTE_20
	map_id ROUTE_21
	db -1
WeatherArea_Indigo:
	map_id ROUTE_22
	map_id ROUTE_23
	db -1

; Scripted and climate-specific groups are deliberately outside the generic
; picker. Their conditions are handled before the eight daily area selections.
CherrygroveWeatherMaps:
	map_id CHERRYGROVE_CITY
	db -1
AzaleaWeatherMaps:
	map_id AZALEA_TOWN
	map_id ROUTE_33
	db -1
LakeOfRageWeatherMaps:
	map_id LAKE_OF_RAGE
	map_id ROUTE_43
	db -1
MahoganySnowMaps:
	map_id ROUTE_42
	map_id MAHOGANY_TOWN
	map_id ROUTE_44
	db -1
SilverCaveSnowMaps:
	map_id ROUTE_28
	map_id SILVER_CAVE_OUTSIDE
	db -1
Route45SandMaps:
	map_id ROUTE_45
	map_id ROUTE_46
	db -1
RuinsSandMaps:
	map_id RUINS_OF_ALPH_OUTSIDE
	db -1
