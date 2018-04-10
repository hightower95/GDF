/*
 * Author: hightower
 * Turns an object into a TFAR jammer. When the object is destroyed or removeTFARJammer is called, the 
 * jamming effect is stopped.
 * https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API:-Variables
 https://docs.google.com/spreadsheets/d/1nvaJhI2O1_YNDk-Q4tnPhzabsCG2r9zV3XqKVovzNtk/edit#gid=0
 *
 * Arguments:
 * 0: The object which will become a jammer <OBJECT> 
 * 1: Ramge of the jammer <NUM> (default: infinite)
 * Return Value:
 * Nothing
 *
 * Example:
 * [this, 5000] call f_fnc_addTFARJammer
 * [this] call f_fnc_addTFARJammer
 *
 * Public: Yes
*/

params ["_jammer_object", ["_range",-1]];

if(!hasInterface) exitWith {};

if (isNull _jammer_object) exitWith {
	diag_log "addTFARJammer.sqf: Jammer object none";
	systemChat "addTFARJammer.sqf: Jammer object none";
};

_debug = missionNamespace getVariable ["f_TFAR_Jammer_debug", false];

// Min interference is the interference at the 'max range' of the antenna. TFAR default is 1.0
_min_interference = missionNamespace getVariable ["jammer_min_interference", 3.5];

// Strength is fixed. It is fixed because in order to achieve the min interference given that the interference rolls of 1/R^2
_strength = _min_interference / exp(-2);
// Strength (S),
_jammer_params = [_strength, _min_interference];

/*Attach jammer variables to object*/
_jammer_object setVariable ["isTFARJammer", true];
_jammer_object setVariable ["jammer_range", _range];
_jammer_object setVariable ["jammer_active", true];
_jammer_object setVariable ["jammer_params", _jammer_params];
_jammer_object setVariable ["jammer_markers_visible", (missionNamespace getVariable ["f_TFAR_Jammer_markers_visible", false])];
_jammer_object setVariable ["jammer_area_marker", format["mkr_jmr_area_%1%2%3", (position _jammer_object) select 0, (position _jammer_object) select 1, (position _jammer_object) select 2]];
_jammer_object setVariable ["jammer_point_marker", format["mkr_jmr_centre_%1%2%3", (position _jammer_object) select 0, (position _jammer_object) select 1, (position _jammer_object) select 2]];

// Fired if zeus deletes the object
_jammer_object addEventHandler ["deleted", {[_this select 0] call f_fnc_removeTFARJammer;}];
_jammer_object addEventHandler ["killed", {[_this select 0] call f_fnc_removeTFARJammer;}];
_jammer_object addEventHandler ["HandleDamage", {
	if((damage (_this select 0)) == 1) then {
		[_this select 0] call f_fnc_removeTFARJammer;
	};
}];

// Add jammer to existing jammers
_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];
// _jammer_count = count _jammers;
_jammers = _jammers + [_jammer_object];
missionNamespace setVariable ["f_TFAR_Jammers", _jammers];
_nil = [] execVM "f\tfar\f_startJammerHandler.sqf";