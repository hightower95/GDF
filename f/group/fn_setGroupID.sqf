// F3 - Set Group IDs
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
// This is crap because it only runs at the beginning of the mission ?
//   this should run more than once and allow renaming of groups on the fly.

if !isServer exitWith {};

// INCLUDE GROUP LIST
private ["_grpBLU", "_grpOPF", "_grpIND"];
_grpBLU = []; _grpOPF = []; _grpIND = [];
// #include "..\..\mission\groups.hpp";

// Local function to name group ID or wait until it is created
_f_fnc_setGroupID = { 
	private["_obj"];
	params["_grp","_name"];

	_obj = missionNamespace getVariable [_grp,grpNull];

	if (isNull _obj) then {
		waitUntil { sleep 15; _obj = missionNamespace getVariable [_grp,grpNull]; count (units _obj) > 0; };
	};

	_obj setGroupIdGlobal [_name];
};

// SET GROUP IDS
// Execute setGroupID Function for all factions
{_x spawn _f_fnc_setGroupID} forEach (_grpBLU + _grpOPF + _grpIND);

f_var_setGroupsIDs = true;
publicVariable "f_var_setGroupsIDs";
if (f_param_debugMode == 1) then { diag_log text "[F3] DEBUG (fn_setGroupIDs.sqf): Completed."; };	// DEBUG