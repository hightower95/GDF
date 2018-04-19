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
	#define _newLoadoutItem(x) [x, []]
	#define _newLoadoutCollection(x,y) [x, y]
	#define GET_ITEM(x) (x select 1)
#else
	#define _newLoadoutItem(x) []
	#define _newLoadoutCollection(x,y) y
	#define GET_ITEM(x) x 
#endif

#define _newLoadout(x,y) [x, y]

/* *** SECTION: Loadout collection definitions *** */

/* 1, 2 & 3 WEAPON */
// Items
#define WEAPON_CLASS _newLoadoutItem('class')
#define WEAPON_MAG _newLoadoutItem('magazine')
#define WEAPON_MAG_ALT _newLoadoutItem('alt magazine')
#define WEAPON_META [WEAPON_CLASS, WEAPON_MAG, WEAPON_MAG_ALT]

#define WEAPON_TYPE _newLoadoutCollection('weapon', WEAPON_META)
#define MUZZLE _newLoadoutItem('muzzle')
#define SIDE_RAIL _newLoadoutItem('siderail')
#define OPTICS _newLoadoutItem('optic')
#define MAG _newLoadoutItem('magazine (loaded)')
#define MAG_2 _newLoadoutItem('secondary magazine (loaded)')
#define BIPOD _newLoadoutItem('bipod')
// Collection
#define WEAPON_STRUCTURE [WEAPON_TYPE, MUZZLE, SIDE_RAIL, OPTICS, MAG, MAG_2, BIPOD]
#define EMPTY_WEAPON_COLLECTION(x) _newLoadoutCollection('weapon_'+x, WEAPON_STRUCTURE)

#define PRIMARY_WEAPON EMPTY_WEAPON_COLLECTION('primary')
#define LAUNCHER_WEAPON EMPTY_WEAPON_COLLECTION('launcher')
#define SECONDARY_WEAPON EMPTY_WEAPON_COLLECTION('secondary')

/* 4 Uniform, 5 Chest Rig,6 Backpack */
// Collection
// uniforms etc are really simple. They have a 'type' and 'contents'
#define EMPTY_CONTAINER_COLLECTION(x) [_newLoadoutItem(x+'_class'), _newLoadoutItem(x+'_contents')]

#define UNIFORM EMPTY_CONTAINER_COLLECTION('uniform')
#define CHEST_RIG EMPTY_CONTAINER_COLLECTION('chest rig')
#define BACKPACK EMPTY_CONTAINER_COLLECTION('backpack')

/* 7 Helmet */
#define HELMET _newLoadoutItem('helmet')

/* 8 Glasses */
#define GLASSES _newLoadoutItem('glasses')

/* 9 Binos */
#define BINOS EMPTY_WEAPON_COLLECTION('binos')

/* 10 Anicilliaries */
// items
#define MAP _newLoadoutItem('map')
#define GPS _newLoadoutItem('gps')
#define RADIO _newLoadoutItem('radio')
#define COMPASS _newLoadoutItem('compass')
#define WATCH _newLoadoutItem('watch')
#define NVGS _newLoadoutItem('nvgs')
// collection
#define ANCILLIARY_STRUCTURE [MAP, GPS, RADIO, COMPASS, WATCH, NVGS]
#define ANCILLIARIES _newLoadoutCollection('ancilliaries', ANCILLIARY_STRUCTURE) 

#define LOADOUT_STRUCTURE [PRIMARY_WEAPON, LAUNCHER_WEAPON, SECONDARY_WEAPON, UNIFORM, CHEST_RIG, BACKPACK, HELMET, GLASSES, ANCILLIARIES]
#define EMPTY_LOADOUT _newLoadoutCollection('loadout', LOADOUT_STRUCTURE)
#define newLoadout(name) _newLoadout(name, LOADOUT_STRUCTURE)

// Collection Accessors
#define PRIMARY_WEAPON_INDEX 0

#define OPTICS_INDEX 4

// Level 0
#define getPrimaryWeapon(loadout) (loadout select PRIMARY_WEAPON_INDEX)
#define setPrimaryWeapon(loadout, weapon) (loadout set[PRIMARY_WEAPON_INDEX, weapon])
#define getOpticOptions(weapon) (weapon select OPTICS_INDEX)
#define setOpticOptions(weapon, options) (weapon set [OPTICS_INDEX, options])
#define addOpticOption(weapon, option) (setOpticOptions(weapon, getOpticOptions(weapon) pushBack option))

/*
#define getLauncher(loadout) (loadout select 1)
#define getSecondaryWeapon(loadout) (loadout select 0)
#define getUniform(loadout) (loadout select 0)
#define getChestRig(loadout) (loadout select 0)
#define getBackpack(loadout) (loadout select 0)
#define getHelmet(loadout) (loadout select 0)
#define getFacewear(loadout) (loadout select 0)
#define getAncilliaries(loadout) (loadout select 0)
*/


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