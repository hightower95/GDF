// ====================================================================================
// Function designed to be used to equip a unit. Place inside a units init field
// The loadout will be attached to a mission variable to be reassigned on respawn.
// Parameters:
//  _unit 'Object' The unit being equiped (typically 'this')
//  _role 'String' <optional default='rifleman'> The role of the unit. A full list can be found in "loadout/roles.hpp".
//						If no role is given, this will be guessed at - unless disabled in "config/loadout_options.hpp"
//  _faction 'String' <optional default=nil> The faction of a unit. If left nil this will 
//						be derived from one of several places - a mission variable (f_var_faction),
//						or from the units configuration. If using a standard unit like RHS-US Army W
//						this will work nicely. If using a random mod this may fail, and default to
//						a vanilla faction such as 'NATO'.
//  _modifiers 'String' <optional default= []> This is a list of all modifiers. A full list can be found in
// 						"loadout/role_modifiers.hpp". This allows a little more prescriptiveness
//						- "no-night-vision", "fire-team-lead", "mg-assistant". This will do little in then
//						initial release of this script
// ====================================================================================
// Examples:
// US Desert Gear for machine gunner:
// [this, "machine-gunner", "US-Desert"] call loadout_fnc_assignLoadout;
// Russian Woodland gear for a squad lead:
// [this, "squad-lead", "USSR-woodland"] call loadout_fnc_assignLoadout;
// A sniper in the faction 'LOP_AA'
// [this, "sniper", "LOP_AA"] call loadout_fnc_assignLoadout;
// Auto-detect role, auto-detect faction:
// [this] call loadout_fnc_assignLoadout; or:
// [this, nil, nil] call loadout_fnc_assignLoadout;
// Auto-detect role, US-Woodland gear.
// [this, nil, "US-Woodland"] call loadout_fnc_assignLoadout;

// Hopefully:
// [this, nil, nil, ["fire-team-lead","no-night-vision","mg-assistant","spotter","at-assitant","at"]] call loadout_fnc_assignLoadout;
// ====================================================================================
// params ["_unit", ["_role", "rifleman"], ["_faction", nil], ["_modifiers", []]];
// waitUntil {(!isNull (findDisplay 46))};
// waitUntil {alive player};
waitUntil {!isNull player};

_bandage = "ACE_fieldDressing";
_morphine = "ACE_morphine";
_epi = "ACE_epinephrine";
_blood250 = "ACE_bloodIV_250";
_blood500 = "ACE_bloodIV_500";
_blood1000 = "ACE_bloodIV_1000";
_earplugs = "ACE_earplugs";

player removeItems _bandage; 
player removeItems _morphine; 
player removeItems _epi; 
player removeItems _earplugs; 

_medical_loadout = [
	[_bandage, 10, {true}],
	[_bandage, 40, {player getUnitTrait "Medic"}],
	[_morphine, 4, {true}],
	[_morphine, 25, {player getUnitTrait "Medic"}],
	[_epi, 1, {true}],
	[_epi, 20, {player getUnitTrait "Medic"}],
	[_blood250, 1, {true}],
	[_blood1000, 4, {player getUnitTrait "Medic"}]
];

player addItem _earplugs;

if (leader group player == player) then {
	player removeItem "ItemGPS";
	player addItem "ItemGPS";
	player assignItem "ItemGPS";	
};

{
	_x params ["_className", "_quantity", "_test"];
	if([] call _test) then {
		for "_i" from 0 to (_quantity-1) do {
			player addItem _className;
		};
	};

} forEach _medical_loadout;

//["rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhsusf_mag_17Rnd_9x19_FMJ","rhsusf_mag_17Rnd_9x19_FMJ","rhs_mag_an_m8hc","rhs_mag_mk84","rhs_mag_m67","rhs_mag_m67","Chemlight_red","Chemlight_red","Chemlight_red","Chemlight_red"]
_mag = primaryWeaponMagazine player select 0; 
_playerMags = magazines player; 
_magCount = {_x == _mag} count _playerMags;

_minimum_mags = 9;
if(player getUnitTrait "Medic") then {
	_minimum_mags = 7;
};

if(_magCount < _minimum_mags) then {
	_mags_required = (_minimum_mags - _magCount);
	for "_i" from 0 to (_mags_required-1) do {
		player addMagazine _mag;
	};
};

// ["rhs_mag_30Rnd_556x45_M855_Stanag","rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red","rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Green","rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Yellow","rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Orange","rhs_mag_30Rnd_556x45_M855A1_Stanag","rhs_mag_30Rnd_556x45_M855A1_Stanag_No_Tracer","rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red","rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Green","rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Yellow","rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Orange","rhs_mag_30Rnd_556x45_Mk318_Stanag","rhs_mag_30Rnd_556x45_Mk262_Stanag","rhs_mag_30Rnd_556x45_M200_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Yellow"]

// _unitClass = typeOf _unit;

// // If no role is provided - autodetect. If one is provided, check it is valid
// _roleProvided = !isNil _role;
// if(!_roleProvided) then {
// 	_role = [_unit] call loadout_fnc_autoDetectRole;
// } else {
// 	_roleIsValid = [_role] call loadout_fnc_validateRole;
// 	if(!_roleIsValid) then {
// 		_role = [_unit] call loadout_fnc_autoDetectRole;
// 	};
// };

// // If no faction is provided - autodetect. If one is provided, check it is valid
// _factionProvided = !isNil _faction;
// if(!_factionProvided) then {
// 	// Faction could be specified within mission
// 	_faction = [_unit] call loadout_fnc_autoDetectFaction;
// } else {
// 	_factionIsValid = [_faction] call loadout_fnc_validateFaction;
// 	if(!_factionIsValid) then {
// 		_faction = [_unit] call loadout_fnc_autoDetectFaction;
// 	};
// };

// // _faction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");

// _equipment = [_role, _faction, _modifiers] call loadout_fnc_getEquipment;

// _equipment params ["_helmet", "_fatigues", "_vest", "_backpack", "_items"];

// somehow:

// _weaponOptions
// _opticOptions
// _magazineCount
// _smokeCount

// _basicMedicalStuff = [];

// What I think I want to get to is a set of functions exposed in the briefing.
// You can change the sight there or even weapon system and it does something like 
// [player, player_role, affected_roles, previous, next] call BIS_fnc_MP - to the server.
// The server then sends:
// [affected_role, previous, next] call BIS_fnc_MP (loadout_fnc_loadoutUpdateReceiver)
// I guess this means anyone could broadcast an update to anyone.
// The server may need to alter vehicles.

// configProperties unitClassName 
// 'dlc'
// 'faction'
// 'hiddenSelections[]'
// 'hiddenSelections[]'
// items - 'linkedItems[]'
// magazines - 'magazines[]'
// 'uniformClass'
// 
// 'displayName'

// 'author'

// 'weapons'

// 'side'

// configfile >> "CfgVehicles" >> "rhsusf_army_ucp_rifleman_101st" >> "hiddenSelectionsTextures"

// CBA_fnc_addItem
// CBA_fnc_addItemCargo

// addItemCargo