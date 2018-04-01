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
_min_interference = missionNamespace getVariable ["jammer_min_interference", 5];
// Strength of the jammer antenna. Calculations assume this is not variable - instead they calculate the interference for the closest jammer because this is less computationally expensive. (More than 1 jammer in a mission is a bit special)
_strength = missionNamespace getVariable ["jammer_strength", 1000];
// Strength (S), min/Strength (m/S). Compute in advance
_jammer_params = [_strength, _min_interference/_strength];

/*Attach jammer variables to object*/
_jammer_object setVariable ["isTFARJammer", true];
_jammer_object setVariable ["jammer_range", _range];
_jammer_object setVariable ["jammer_active", true];
_jammer_object setVariable ["jammer_params", _jammer_params];

_jammer_object addEventHandler ["killed", {[_this select 0] call f_fnc_removeTFARJammer;}];

if(_debug) then {
	// Mark Area
	_jammer_marker = createmarkerLocal [format["JAMMER_DebugMarker_%1", name _jammer_object], position _jammer_object];
	_jammer_marker setMarkerShape "ELLIPSE";
	_jammer_marker setMarkerSize [_range, _range];
	_jammer_marker setMarkerBrush "SOLID";
	_jammer_marker setMarkerAlpha 0.3;
	_jammer_object setVariable ["marker", _jammer_marker];

	// Mark position
	_debugMarker2 = createmarkerLocal ["JAMMER_DebugMarker2", position _jammer_object];
	_debugMarker2 setMarkerShape "ICON";
	_debugMarker2 setMarkerType "mil_dot";
	_text = format ["S:%1", _strength];
	_debugMarker2 setMarkerText _text;
	"addTFARJammer: Markers Initialized" call BIS_fnc_log;
	systemChat "Jammer: Marker Initialized";
};

// Add jammer to existing jammers
_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];
// _jammer_count = count _jammers;
_jammers = _jammers + [_jammer_object];
missionNamespace setVariable ["f_TFAR_Jammers", _jammers];

_nil = [] execVM "f\tfar\f_startJammerHandler.sqf";