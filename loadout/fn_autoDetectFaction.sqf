// ====================================================================================
// Detect the faction of a unit. This is slightly guess work.
// Sources:
// 1. Check the configFile >> unit classname >> faction
// 2. 
// 3. The units side
// Other config properties that might help:
// 'dlc' - Except for the base game. Some mods use this well
// 'hiddenSelections[]' - Uniforms can tell you more sometimes
// items - 'linkedItems[]'
// magazines - 'magazines[]'
// 'uniformClass'
// 'displayName'
// 'author'
// 'weapons'
// 'side'

// Parameters:
//  _unit 'Object' The unit that a faction is needed for (typically 'this')
//
// Returns:
// Faction <string> or nil if no faction found
// ====================================================================================
// Examples:
//  _faction = []
// ====================================================================================

params ["_unit"];

// Include faction list

_faction = getText (configFile >> "CfgVehicles" >> _unitClass >> "faction");
_factionName = [_faction] call loadout_fnc_lookupFaction; // todo - maybe change to config_fnc_lookupFaction

if(isNil _factionName) then {
	_generatedfactionName = nil;

	_side = side _unit;

	_rhs_check = {false;};

	switch(_side) do {
		case west : {_rhs_check = f_fnc_detectRHS_US};
		case east : {_rhs_check = f_fnc_detectRHS_USSR};
		case independent : {_rhs_check = f_fnc_detectRHS_GREF};
		case civilian : {};
	};

	if([] call _rhs_check) then {
		_generatedfactionName = format["%1_%2", _side, "RHS"];
	} else {
		_generatedfactionName = str _side;
	};

	_factionName = [_generatedfactionName] call loadout_fnc_lookupFaction;
};



_factionName;