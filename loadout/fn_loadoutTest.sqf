
#include "common.hpp"

waitUntil {!isNull player};

SAMPLE_LOADOUT = newLoadout('test');
SAMPLE_LOADOUT2 = newLoadout('bravo'); 
SAMPLE_LOADOUT3 = newLoadout('charlie'); 
WEAPON = getPrimaryWeapon(SAMPLE_LOADOUT);
_options = ["aco_red", "aco_green"];
setOpticsOptions((WEAPON), _options);
MY_OPTICS = getOpticsOptions(WEAPON);

systemChat "loadout script ran";
// TEST_2 = test2;

// BASE_LOADOUT + PRIMARY_WEAPON
// [] + EMPTY_WEAPON_ITEM('primary')
// [] + LOADOUT_ITEM('weapon_'+'primary', [WEAPON_STRUCTURE])
// [] + LOADOUT_ITEM('weapon_'+'primary', [LOADOUT_ITEM('weapon'), 2, 3])


// #define LOADOUT_ITEM(name) [name, []]
// #define LOADOUT_ITEM(name, contents) [name, contents]

// [] + ['weapon_'+'primary', [['weapon',[]], 2, 3]]
