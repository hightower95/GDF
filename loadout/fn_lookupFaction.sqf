// ====================================================================================
//
// Parameters:
//  _searchTerm 'string' 
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
	[["USMC", "US-Wood", "WEST_RHS", "WEST_RHS_WOOD"], "US-Wood"],
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


