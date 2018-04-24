
#include "common.hpp"

waitUntil {!isNull player};

SAMPLE_LOADOUT = newLoadout('test');
SAMPLE_LOADOUT2 = newLoadout('bravo'); 
SAMPLE_LOADOUT3 = newLoadout('charlie'); 
WEAPON = getPrimaryWeapon(SAMPLE_LOADOUT);
_options = ["aco_red", "aco_green"];
setOpticsOptions(WEAPON, _options);
MY_OPTICS = getOpticsOptions(WEAPON);
setPrimaryWeapon(SAMPLE_LOADOUT2, WEAPON);

WEAPONX = getPrimaryWeapon(SAMPLE_LOADOUT2);
// MY_OPTICS = getOpticsOptions(WEAPON2);

_options2 = ["lrps"];
MY_OPTICS2 = getOpticsOptions(WEAPONX);
setOpticsOptions(WEAPONX, _options2);


// sample loadout 
REAL_LOADOUT = newLoadout('rifleman');
_primary_weapon = PRIMARY_WEAPON;

_light_rifle = ["srifle_GM6_F", "5Rnd_127x108_Mag", "5Rnd_127x108_APDS_Mag"];
_med_rifle = ["mx", "6.5", "6.5tracer"];
_rifles = [_light_rifle, _med_rifle];
_muzzle = ["muzzle_snds_B"];
_side_rail = ["light", "laser light", "acc_pointer_IR"];
_optics = ["aco_red", "aco_green"];
_bipod = ["bipod"];
_backpack = ["B_Carryall_ocamo"];

setWeaponOptions(_primary_weapon, _rifles);
setOpticsOptions(_primary_weapon, _optics);
setMuzzleOptions(_primary_weapon, _muzzle);
setSideRailOptions(_primary_weapon, _side_rail);
setBipodOptions(_primary_weapon, _bipod;)


setPrimaryWeapon(REAL_LOADOUT, _primary_weapon);
setBackpackOptions(REAL_LOADOUT, _backpack);

squashPalette = {
	params["_loadoutPalette"];
};


doEquip = {
	params["_unit", "_loadout"];
};

systemChat "loadout script ran";
// TEST_2 = test2;

// BASE_LOADOUT + PRIMARY_WEAPON
// [] + EMPTY_WEAPON_ITEM('primary')
// [] + LOADOUT_ITEM('weapon_'+'primary', [WEAPON_STRUCTURE])
// [] + LOADOUT_ITEM('weapon_'+'primary', [LOADOUT_ITEM('weapon'), 2, 3])


// #define LOADOUT_ITEM(name) [name, []]
// #define LOADOUT_ITEM(name, contents) [name, contents]

// [] + ['weapon_'+'primary', [['weapon',[]], 2, 3]]
