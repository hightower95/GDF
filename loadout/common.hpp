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
	#define getItems(x) (x select 1)
	#define getItemsByIndex(x, index) ((getItems(x)) select index)
	#define getItemOptions(x, index) (getItems((getItemsByIndex(x, index))))
	#define unpackLoadoutItems(x) (x)

	#define setItem(x, value) (x set[1, value])
	#define setItemOptions(x, index, options) (setItem((getItemsByIndex(x, index)), options))
#else
	#define _newLoadoutItem(x) []
	#define _newLoadoutCollection(x,y) y
	#define getItems(x) x 
	#define getItemsByIndex(x, index) (x select index)
	#define getItemOptions(x, index) (getItems((getItemsByIndex(x, index))))
	#define unpackLoadoutItems(x) (x select 1)

	//#define setItem(x, value) (x = value)
	#define setItemOptions(x, index, options) (x set[index, options])
#endif

#define _newLoadout(x,y) [x, y]

/* *** SECTION: Loadout collection definitions *** */
#define setCollectionItem(loadout, index, collection) (setItemOptions(unpackLoadoutItems(loadout), index, getItems(collection)))
#define getCollectionItem(loadout, index) (getItemsByIndex(unpackLoadoutItems(loadout, index))

/* 1, 2 & 3 WEAPON */
#define PRIMARY_WEAPON_INDEX 0 // Position in 'LOADOUT'
#define LAUNCHER_WEAPON_INDEX 1
#define SECONDARY_WEAPON_INDEX 2
#define getPrimaryWeapon(loadout) getCollectionItem(loadout, PRIMARY_WEAPON_INDEX)
#define setPrimaryWeapon(loadout, w) setCollectionItem(loadout, PRIMARY_WEAPON_INDEX, w)
#define getLauncher(loadout) getCollectionItem(loadout, LAUNCHER_WEAPON_INDEX)
#define setLauncher(loadout, w) setCollectionItem(loadout, LAUNCHER_WEAPON_INDEX, w)
#define getSecondaryWeapon(loadout) getCollectionItem(loadout, SECONDARY_WEAPON_INDEX)
#define setSecondaryWeapon(loadout, w) setCollectionItem(loadout, SECONDARY_WEAPON_INDEX, w)
// Weapon has Weapon Meta, to associate the magazines with the weapon class.
#define WEAPON_CLASS_INDEX 0 // Position in 'WEAPON_META WEAPON LOADOUT'
#define WEAPON_CLASS _newLoadoutItem('class')
#define WEAPON_MAG_INDEX 1
#define WEAPON_MAG _newLoadoutItem('magazine')
#define WEAPON_MAG_ALT_INDEX 2
#define WEAPON_MAG_ALT _newLoadoutItem('alt magazine')
#define WEAPON_META [WEAPON_CLASS, WEAPON_MAG, WEAPON_MAG_ALT]

#define WEAPON_TYPE _newLoadoutCollection('weapon', WEAPON_META)
#define WEAPON_TYPE_INDEX 0 // Position in 'WEAPON LOADOUT'
#define newWeaponOption(_class, _mag_options, _tracer_options) [_class, _mag_options, _tracer_options];
#define setWeaponOptions(w, options) setItemOptions(w, WEAPON_TYPE_INDEX, options) // Think this is going to be an issue?
#define getWeaponOptions(w) getItemOptions(w, WEAPON_TYPE_INDEX)

#define MUZZLE_ITEM _newLoadoutItem('muzzle')
#define MUZZLE_INDEX 1
#define getMuzzleOptions(w) getItemOptions(w, MUZZLE_INDEX)
#define setMuzzleOptions(w, options) setItemOptions(w, MUZZLE_INDEX, options)

#define SIDE_RAIL_ITEM _newLoadoutItem('siderail')
#define SIDE_RAIL_INDEX 2
#define getSideRailOptions(w) getItemOptions(w, SIDE_RAIL_INDEX)
#define setSideRailOptions(w, options) setItemOptions(w, SIDE_RAIL_INDEX, options)

#define OPTICS_ITEM _newLoadoutItem('optic')
#define OPTICS_INDEX 3
#define getOpticsOptions(w) getItemOptions(w, OPTICS_INDEX)
#define setOpticsOptions(w, options) setItemOptions(w, OPTICS_INDEX, options)

#define MAG_ITEM _newLoadoutItem('magazine (loaded)')
#define MAG_INDEX 4
#define getLoadedMagazineOptions(w) getItemOptions(w, MAG_INDEX)
#define setLoadedMagazineOptions(w, options) setItemOptions(w, MAG_INDEX, options)

#define MAG_2_ITEM _newLoadoutItem('secondary magazine (loaded)')
#define MAG_2_INDEX 5
#define getLoadedMagazine2Options(w) getItemOptions(w, MAG_2_INDEX)
#define setLoadedMagazine2Options(w, options) setItemOptions(w, MAG_2_INDEX, options)

#define BIPOD_ITEM _newLoadoutItem('bipod')
#define BIPOD_INDEX 6
#define getBipodOptions(w) getItemOptions(w, BIPOD_INDEX)
#define setBipodOptions(w, options) setItemOptions(w, BIPOD_INDEX, options)

// Collection
#define WEAPON_STRUCTURE [WEAPON_TYPE, MUZZLE_ITEM, SIDE_RAIL_ITEM, OPTICS_ITEM, MAG_ITEM, MAG_2_ITEM, BIPOD_ITEM]
#define EMPTY_WEAPON_COLLECTION(x) _newLoadoutCollection('weapon_'+x, WEAPON_STRUCTURE)

#define PRIMARY_WEAPON EMPTY_WEAPON_COLLECTION('primary')
#define LAUNCHER_WEAPON EMPTY_WEAPON_COLLECTION('launcher')
#define SECONDARY_WEAPON EMPTY_WEAPON_COLLECTION('secondary')

/* 4 Uniform, 5 Chest Rig,6 Backpack */
// Collection
// uniforms etc are really simple. They have a 'type' and 'contents'
#define EMPTY_CONTAINER_COLLECTION(x) [_newLoadoutItem(x+'_class'), _newLoadoutItem(x+'_contents')]

#define UNIFORM_ITEM EMPTY_CONTAINER_COLLECTION('uniform')
#define UNIFORM_INDEX 4
#define getUniform(loadout) getCollectionItem(loadout, UNIFORM_INDEX)
#define setUniform(loadout, w) setCollectionItem(loadout, UNIFORM_INDEX, w)

#define CHEST_RIG_ITEM EMPTY_CONTAINER_COLLECTION('chest rig')
#define CHEST_RIG_INDEX 5
#define getChestRig(loadout) getCollectionItem(loadout, CHEST_RIG_INDEX)
#define setChestRig(loadout, w) setCollectionItem(loadout, CHEST_RIG_INDEX, w)

#define BACKPACK_ITEM EMPTY_CONTAINER_COLLECTION('backpack')
#define BACKPACK_INDEX 6
#define getBackpackOptions(loadout) getCollectionItem(loadout, BACKPACK_INDEX)
#define setBackpackOptions(loadout, w) setCollectionItem(loadout, BACKPACK_INDEX, w)


/* 7 Helmet */
#define HELMET_ITEM _newLoadoutItem('helmet')

/* 8 Glasses */
#define GLASSES_ITEM _newLoadoutItem('glasses')

/* 9 Binos */
#define BINOS_ITEM EMPTY_WEAPON_COLLECTION('binos')

/* 10 Anicilliaries */
// items
#define MAP_ITEM _newLoadoutItem('map')
#define GPS_ITEM _newLoadoutItem('gps')
#define RADIO_ITEM _newLoadoutItem('radio')
#define COMPASS_ITEM _newLoadoutItem('compass')
#define WATCH_ITEM _newLoadoutItem('watch')
#define NVGS_ITEM _newLoadoutItem('nvgs')
// collection
#define ANCILLIARY_STRUCTURE [MAP_ITEM, GPS_ITEM, RADIO_ITEM, COMPASS_ITEM, WATCH_ITEM, NVGS_ITEM]
#define ANCILLIARIES _newLoadoutCollection('ancilliaries', ANCILLIARY_STRUCTURE) 

#define LOADOUT_STRUCTURE [PRIMARY_WEAPON, LAUNCHER_WEAPON, SECONDARY_WEAPON, UNIFORM_ITEM, CHEST_RIG_ITEM, BACKPACK_ITEM, HELMET_ITEM, GLASSES_ITEM, ANCILLIARIES]
#define EMPTY_LOADOUT _newLoadoutCollection('loadout', LOADOUT_STRUCTURE)
#define newLoadout(name) _newLoadout(name, LOADOUT_STRUCTURE)
#define getLoadoutCollections(loadout) (loadout select 1) // Loadout structure is [NAME, [COLLECTIONS]]. 
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