
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

_light_rifle = ["mx", "6.5", "6.5tracer"];
_muzzle = ["muzzle"];
_side_rail = ["light", "laser light", "laser"];
_optics = ["aco_red", "aco_green"];
_mag = _light_rifle select 1;
_bipod = ["bipod"];

setOpticsOptions(_primary_weapon, _optics);

setPrimaryWeapon(REAL_LOADOUT, _primary_weapon);




systemChat "loadout script ran";
// TEST_2 = test2;

// BASE_LOADOUT + PRIMARY_WEAPON
// [] + EMPTY_WEAPON_ITEM('primary')
// [] + LOADOUT_ITEM('weapon_'+'primary', [WEAPON_STRUCTURE])
// [] + LOADOUT_ITEM('weapon_'+'primary', [LOADOUT_ITEM('weapon'), 2, 3])


// #define LOADOUT_ITEM(name) [name, []]
// #define LOADOUT_ITEM(name, contents) [name, contents]

// [] + ['weapon_'+'primary', [['weapon',[]], 2, 3]]
