/*
 * Author: hightower
 * Removes TFAR jamming from an object
 * https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API:-Variables
 https://docs.google.com/spreadsheets/d/1nvaJhI2O1_YNDk-Q4tnPhzabsCG2r9zV3XqKVovzNtk/edit#gid=0
 *
 * Arguments:
 * 0: The object to removing jamming effect from <OBJECT> 
 * Return Value:
 * Nothing
 *
 * Example:
 * [object] call f_fnc_removeTFARJammer
 * [this] call f_fnc_removeTFARJammer
 *
 * Public: Yes
*/

params ["_object"];

// Debug printing
_debug_log = {
	if(!(missionNamespace getVariable ["f_TFAR_Jammer_debug", false])) exitWith {}; 
	_text = format ["Client: %1, MissionTime: %2 ServerTime: %3 removeTFARJammer.sqf, %4", name player, time, serverTime, _this select 0]; 
	_text remoteExecCall ["BIS_fnc_log", 2]; // log to server
};

// 1. Check it is actually a jammer
_isJammer = _object getVariable ["isTFARJammer", false];

if(!_isJammer) exitWith {
	["object is not a jamer"] call _debug_log;
};
_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];

// 2. Remove Jammer
[format ["Pre-removal active jammers: %1", count _jammers]] call _debug_log;
_jammers = _jammers - [_object];

missionNamespace setVariable ["f_TFAR_Jammers", _jammers];
[format ["Completed. active jammers: %1", count _jammers]] call _debug_log;

// 3. Clean up markers
_object setVariable ["isTFARJammer", nil];

// These variables are set even if markers are turned off
// Doesnt matter if it exists or not.
if(!isNil {_object getVariable "jammer_area_marker"}) then {
	_mkr_area = _object getVariable "jammer_area_marker";
	deleteMarkerLocal _mkr_area;
};

if(!isNil {_object getVariable "jammer_point_marker"}) then {
	_mkr_point = _object getVariable "jammer_point_marker";
	deleteMarkerLocal _mkr_point;
};