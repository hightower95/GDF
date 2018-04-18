//https://github.com/acemod/ACE3/blob/master/tools/cba/addons/main/script_macros_common.hpp
//role -> map(item_names to faction_classes) -> palette -> global filters -> final loadout

/*
LOADOUT = [
    PRIMARY_WEAPON,
    LAUNCHER,
    SECONDARY_WEAPON,
	UNIFORM,
	CHEST_RIG,
	BACKPACK
	HELMET,
	GLASSES,
	BINOS,
	ANCILLIARIES,
]
PRIMARY_WEAPON = [
	RIFLE,
	SILENCER,
	LASER,
	OPTIC,
	MAGAZINE,
	SECONDARY_MAG,
	BIPOD,
	MAIN_MAG,
	ALT_MAG
]
*/
#define DEBUG_LOADOUTS true

#ifdef DEBUG_LOADOUTS
	#define LOADOUT_ITEM(name) ([name, []])
	#define LOADOUT_ITEM(name, contents) ([name, contents])
	#define GET_ITEM(item) (item select 1)
#else
	#define LOADOUT_ITEM(name) []
	#define LOADOUT_ITEM(name, contents) contents
	#define GET_ITEM(item) item 
#endif

// Weapon Items
#define WEAPON_TYPE LOADOUT_ITEM('weapon')
#define MUZZLE LOADOUT_ITEM('muzzle')
#define SIDE_RAIL LOADOUT_ITEM('siderail')
#define OPTICS LOADOUT_ITEM('optic')
#define MAG LOADOUT_ITEM('magazine')
#define MAG_2 LOADOUT_ITEM('secondary magazine')
#define BIPOD LOADOUT_ITEM('bipod')

#define WEAPON_STRUCTURE [1, 2, 3]



#define EMPTY_WEAPON_ITEM(type) LOADOUT_ITEM('weapon_'+type, WEAPON_STRUCTURE)
//#define EMPTY_WEAPON_ITEM(type) [type, [WEAPON_TYPE, MUZZLE, SIDE_RAIL, OPTICS]]
/*
["primary",[
		["weapon",[]],
		["muzzle",[]],
		["side rail",[]],
		["optic",[]]
	],
"secondary",[["weapon",[]],["muzzle",[]],["side rail",[]],["optic",[]]]]
*/
//#define EMPTY_WEAPON_ITEM(type) LOADOUT_ITEM('weapon_'+type) + WEAPON_TYPE
//["weapon_primary",[],"weapon",[],"weapon_secondary",[],"weapon",[]]
#define PRIMARY_WEAPON EMPTY_WEAPON_ITEM('primary')
#define LAUNCHER_WEAPON EMPTY_WEAPON_ITEM('launcher')
#define SECONDARY_WEAPON EMPTY_WEAPON_ITEM('secondary')

#define BASE_LOADOUT []
#define EMPTY_LOADOUT BASE_LOADOUT + PRIMARY_WEAPON

#define test_loadout [["WPN","P_OPT"], "SIL", "LASER", "OPTIC", "MAG", "SEC_MAG", "BIPOD", "MAIN_MAG", "ALT_MAG"]
#define test2 [1,2,3]

/*
#define base_index 0
#define weapon_classname_index (base_index + 0)
#define weapon_silence_index (base_index + 1)
#define weapon_laser_index (base_index + 2)
#define weapon_optic_index (base_index + 3)
#define weapon_magazine_index (base_index + 4)
#define weapon_secondary_magazine_index (base_index + 5)
#define weapon_bipod_index (base_index + 6)
#define weapon_main_magazine_index (base_index + 7)
#define weapon_alternate_magazine_index (base_index + 8)
#undef base_index

#define PRIMARY_WEAPON_INDEX 0
#define OPTIC 1

#define getLoadoutAspect(loadout, index) loadout select index
#define getPrimaryWeapon(loadout) getLoadoutAspect(loadout, PRIMARY_WEAPON_INDEX)
#define getOptics(loadout) getPrimaryWeapon(loadout) select OPTIC 

*/