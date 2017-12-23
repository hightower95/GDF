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
//  _searchTerm 'string' The unit that a faction is needed for (typically 'this')
//
// Returns:
// Faction <string> or nil if no faction found
// ====================================================================================
// Examples:
//  _factionName = [_searchTerm] call loadout_fnc_lookupFaction;
// ====================================================================================

params ["_searchTerm"];
_foundFaction = false;
_factionName = nil;

GD_FACTIONS = [
	//[ [Aliases] ,  Faction Useful Name],
	[["USMC", "US-Wood"], "US-Wood"],
	[["US-Army-D", "US-Desert"], "US-Desert"]
];

// Lets assume the factions table is already in lower case.
_searchTerm = toLower(_searchTerm);
{
	_factionList = _x select 0;
	
	if(_factionList find _searchTerm != -1) exitWith {
		_factionName = _x select 1;
	};		

} forEach GD_FACTIONS;

_factionName;


