//https://github.com/acemod/ACE3/blob/master/tools/cba/addons/main/script_macros_common.hpp
//role -> map(item_names to faction_classes) -> palette -> global filters -> final loadout

/*
This file creates the data structure for a 'loadout palette'. The palette structure is in the structure of the array
created by the command 'getUnitLoadout'. Every item can be swapped out.

This code is used to produce and interact with the intended loadout structure:
LOADOUT = [
    1. PRIMARY_WEAPON, -> Each entry here is called a 'loadout collection'
    2. LAUNCHER,
    3. SECONDARY_WEAPON,
	4. UNIFORM,
	5. CHEST_RIG,
	6. BACKPACK
	7. HELMET,
	8. GLASSES,
	9. BINOS,
	10. ANCILLIARIES,
]
Where each Loadout 'item' will have a set of items beneath it, for instance:
PRIMARY_WEAPON = [
	RIFLE, -> Each entry here is called a 'loadout item'
	SILENCER,
	LASER,
	OPTIC,
	MAGAZINE,
	SECONDARY_MAG,
	BIPOD,
	MAIN_MAG,
	ALT_MAG
]
Each item has has a set of options.
Rifle = [
	"classname", (option 1)
	"classname" (option 2)
]

The structure above can then be used by other scripts to apply it to a person.
*/
#define DEBUG_LOADOUTS true

#ifdef DEBUG_LOADOUTS
	#define LOADOUT_ITEM(x) [x, []]
	#define LOADOUT_COLLECTION(x,y) [x, y]
	#define GET_ITEM(x) (x select 1)
#else
	#define LOADOUT_ITEM(x) []
	#define LOADOUT_COLLECTION(x,y) y
	#define GET_ITEM(x) x 
#endif

/* *** SECTION: Loadout collection definitions *** */

/* 1, 2 & 3 WEAPON */
// Items
#define WEAPON_TYPE LOADOUT_ITEM('weapon')
#define MUZZLE LOADOUT_ITEM('muzzle')
#define SIDE_RAIL LOADOUT_ITEM('siderail')
#define OPTICS LOADOUT_ITEM('optic')
#define MAG LOADOUT_ITEM('magazine')
#define MAG_2 LOADOUT_ITEM('secondary magazine')
#define BIPOD LOADOUT_ITEM('bipod')
// Collection
#define WEAPON_STRUCTURE [WEAPON_TYPE, MUZZLE, SIDE_RAIL, OPTICS, MAG, MAG_2, BIPOD]
#define EMPTY_WEAPON_COLLECTION(x) LOADOUT_COLLECTION('weapon_'+x, WEAPON_STRUCTURE)

#define PRIMARY_WEAPON EMPTY_WEAPON_COLLECTION('primary')
#define LAUNCHER_WEAPON EMPTY_WEAPON_COLLECTION('launcher')
#define SECONDARY_WEAPON EMPTY_WEAPON_COLLECTION('secondary')

/* 4 Uniform, 5 Chest Rig,6 Backpack */
// Collection
// uniforms etc are really simple. They have a 'type' and 'contents'
#define EMPTY_CONTAINER_COLLECTION(x) [LOADOUT_ITEM(x+'_type'), LOADOUT_ITEM(x+'_contents')]

#define UNIFORM EMPTY_CONTAINER_COLLECTION('uniform')
#define CHEST_RIG EMPTY_CONTAINER_COLLECTION('chest rig')
#define BACKPACK EMPTY_CONTAINER_COLLECTION('backpack')

/* 7 Helmet */
#define HELMET LOADOUT_ITEM('helmet')

/* 8 Glasses */
#define GLASSES LOADOUT_ITEM('glasses')

/* 9 Binos */
#define BINOS EMPTY_WEAPON_COLLECTION('binos')

/* 10 Anicilliaries */
// items
#define MAP LOADOUT_ITEM('map')
#define GPS LOADOUT_ITEM('gps')
#define RADIO LOADOUT_ITEM('radio')
#define COMPASS LOADOUT_ITEM('compass')
#define WATCH LOADOUT_ITEM('watch')
#define NVGS LOADOUT_ITEM('nvgs')
// collection
#define ANCILLIARY_STRUCTURE [MAP, GPS, RADIO, COMPASS, WATCH, NVGS]
#define ANCILLIARIES LOADOUT_COLLECTION('ancilliaries', ANCILLIARY_STRUCTURE) 

#define LOADOUT_STRUCTURE [PRIMARY_WEAPON, LAUNCHER_WEAPON, SECONDARY_WEAPON, UNIFORM, CHEST_RIG, BACKPACK, HELMET, GLASSES, ANCILLIARIES]
#define EMPTY_LOADOUT LOADOUT_COLLECTION('loadout', LOADOUT_STRUCTURE)
#define newLoadout(name) LOADOUT_COLLECTION(name, LOADOUT_STRUCTURE)

/* Not needed yet:
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