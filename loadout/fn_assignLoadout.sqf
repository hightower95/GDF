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
params ["_unit", ["_role", "rifleman"], ["_faction", nil], ["_modifiers", []]];

_unitClass = typeOf _unit;

// If no role is provided - autodetect. If one is provided, check it is valid
_roleProvided = !isNil _role;
if(!_roleProvided) then {
	_role = [_unit] call loadout_fnc_autoDetectRole;
} else {
	_roleIsValid = [_role] call loadout_fnc_validateRole;
	if(!_roleIsValid) then {
		_role = [_unit] call loadout_fnc_autoDetectRole;
	};
};

// If no faction is provided - autodetect. If one is provided, check it is valid
_factionProvided = !isNil _faction;
if(!_factionProvided) then {
	// Faction could be specified within mission
	_faction = [_unit] call loadout_fnc_autoDetectFaction;
} else {
	_factionIsValid = [_faction] call loadout_fnc_validateFaction;
	if(!_factionIsValid) then {
		_faction = [_unit] call loadout_fnc_autoDetectFaction;
	};
};

// _faction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");

_equipment = [_role, _faction, _modifiers] call loadout_fnc_getEquipment;

_equipment params ["_helmet", "_fatigues", "_vest", "_backpack", "_items"];

// somehow:

_weaponOptions
_opticOptions
_magazineCount
_smokeCount

_basicMedicalStuff = [];

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
