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

_debug_log = {
	if(!(missionNamespace getVariable ["f_TFAR_Jammer_debug", false])) exitWith {}; 

	_text = format ["Client: %1, MissionTime: %2 ServerTime: %3 removeTFARJammer.sqf, %4", name player, time, serverTime, _this select 0]; 
	if (profileName == "Hightower" && !isServer) then {
		_text call BIS_fnc_log;
	} else {
		_hightowers = allPlayers select {name _x == "Hightower"};
		if(count _hightowers == 1) then {
			_hightower = _hightowers select 0;
			if(!isNull _hightower) then {
				_text remoteExecCall ["BIS_fnc_log", owner _hightower];
			};
		};
	};
	_text remoteExecCall ["BIS_fnc_log", 2];
};

_isJammer = _object getVariable ["isTFARJammer", false];

if(!_isJammer) exitWith {
	["object is not a jamer"] call _debug_log;
};
_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];

[format ["Pre-removal active jammers: %1", count _jammers]] call _debug_log;
_jammers = _jammers - [_object];

missionNamespace setVariable ["f_TFAR_Jammers", _jammers];
[format ["Completed. active jammers: %1", count _jammers]] call _debug_log;

_marker = _object getVariable "marker";
if(!isNil _marker) then {
	deleteMarkerLocal _marker;
};

_object setVariable ["isTFARJammer", nil];
