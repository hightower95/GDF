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
#define test_loadout [["WPN","P_OPT"], "SIL", "LASER", "OPTIC", "MAG", "SEC_MAG", "BIPOD", "MAIN_MAG", "ALT_MAG"]

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

#define PRIMARY_WEAPON 0
#define OPTIC 1

#define OPTIC_EXAMPLE __EXEC(name="OPTIC"; index=4)
#define OPTIC_FURTHER (OPTIC_EXAMPLE getVariable "name")

#define getLoadoutAspect(loadout, index) loadout select index
#define getPrimaryWeapon(loadout) getLoadoutAspect(loadout, PRIMARY_WEAPON)
#define getOptics(loadout) getPrimaryWeapon(loadout) select OPTIC 