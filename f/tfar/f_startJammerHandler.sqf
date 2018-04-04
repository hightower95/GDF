/*
 * Author: hightower
 * Runs the jammer code. Works out what the TFAR settings for the player should be and applies them.
 * To prevent multiple loops being created, this file also acts as ringmaster for the jammer loop.
 * https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API:-Variables
 https://docs.google.com/spreadsheets/d/1nvaJhI2O1_YNDk-Q4tnPhzabsCG2r9zV3XqKVovzNtk/edit#gid=0
 *
 * Arguments:
 * Nothing
 * Return Value:
 * Nothing
 *
 * Example:
 * [] execVM "f\tfar\f_startJammerHandler.sqf"
 *
 * Public: Yes
*/

_jammer_handler = missionNamespace getVariable ["jammer_handler", objNull];
_start_jammer_handler = true;
// Check if there is a jammer handler already, and if its completed
if(!isNull _jammer_handler) then {
	if(!(scriptDone _jammer_handler)) then {
		_start_jammer_handler = false;
		_text = format["%1 addTFARJammer: Jammer Watcher not spawned as its already running", time];
		_text call BIS_fnc_log;
		_hightowers = allPlayers select {name _x =="Hightower"};
		if(count _hightowers == 1) then {
			_hightower = _hightowers select 0;
			if(!isNull _hightower) then {
				_text remoteExecCall ["BIS_fnc_log", owner _hightower];
			};
		};
	}; 
};
if(!_start_jammer_handler) exitWith {};

_jammer_loop_handler = {
	_running = true;
	_debug = missionNamespace getVariable ["f_TFAR_Jammer_debug", false];
	_debug_log = {
		if(!(missionNamespace getVariable ["f_TFAR_Jammer_debug", false])) exitWith {}; 

		_text = format ["%1::MiTime: %2, SeTime: %3, addTFARJammer.sqf:: %4", profileName, time, serverTime, _this select 0]; 
		// This is just a nifty thing to send Hightower the logs
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
		
		// Log to server
		_text remoteExecCall ["BIS_fnc_log", 2];
	};

	if(_debug) then {
		systemChat "Jammer loop handler started";
	};

	while{_running} do {		
		// 1. Find the active jammers
		_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];
		// If there are no jammers this is the last iteration
		if(count _jammers == 0) then {
			["No jammers left"] call _debug_log;
			_running = false;
		};

		_activeJammers = _jammers select {_x getVariable ["jammer_active", false]};

		if(count _activeJammers == 0) then {
			["No Active Jammers"] call _debug_log;
		};

		// 2. Find the closest active jammer to the player.
		_closest_jammer = objNull;
		{
			_jammer = _x;
			_jammer_range = _jammer getVariable "jammer_range";
			
			// '-1' is infinite range - so this jammer dominates.
			if (_jammer_range == -1) exitWith {
				_closest_jammer = _jammer;
			};

			// Check if we've found a jammer already.
			if (_closest_jammer != objNull) then {
				// Check if the current jammer is closer than the previous jammer
				_distance = player distance2D _jammer;
				if (_distance < (player distance2D _closest_jammer)) then {
					_closest_jammer = _jammer;
				};
			} else {
				// We've found no jammers previously, so this one is the closest by default
				_closest_jammer = _jammer;
			};
		
		} forEach _activeJammers;

		{
			_jammer = _x;
			if(!(_jammer getVariable "f_TFAR_Jammer_markers_visible")) exitWith {};
			_mkr_area = _jammer getVariable "jammer_area_marker";
			_range = _jammer getVariable "jammer_range";
			// Doesnt matter if it exists or not.
			deleteMarkerLocal _mkr_area;
			// Mark Area
			_mkr_area = createmarkerLocal [_mkr_area, position _jammer];
			_mkr_area setMarkerShape "ELLIPSE";
			_mkr_area setMarkerSize [_range, _range];
			_mkr_area setMarkerBrush "SOLID";
			_mkr_area setMarkerAlpha 0.3;

			// Mark position
			_mkr_point = _jammer getVariable "jammer_point_marker";
			_strength = (_jammer getVariable "jammer_params") select 0;
			deleteMarkerLocal _mkr_point;
			_mkr_point = createmarkerLocal [_mkr_point, position _jammer];
			_mkr_point setMarkerShape "ICON";
			_mkr_point setMarkerType "mil_dot";
			_text = format ["S:%1", _strength];
			_mkr_point setMarkerText _text;
		} forEach _activeJammers;
		
		[format["Closest Jammer: %1", _closest_jammer]] call _debug_log;
		// 3. Calculate interference
		_interference = 1.0;
		
		if(!isNull _closest_jammer) then {
			_distance = player distance _closest_jammer;
			_jammer_range = _closest_jammer getVariable "jammer_range";

			if(_jammer_range < 0 or _distance <= _jammer_range) then {
				_jammer_params = _closest_jammer getVariable "jammer_params";
				_jammer_params params ["_strength", "_K"];
				[format["Effective Jammer Detected: strength: %1, distance: %2, range: %3",_strength, _distance, _jammer_range]] call _debug_log;
				_dist = (_distance MIN _jammer_range)/_jammer_range;
				// Interference is inversely proportional to distance squared.
				_interference = _strength * (exp (-2*_dist));

			};
		};
		[format["Interference set at: %1", _interference]] call _debug_log;
		// 4. Apply interference
		// Increase the distance radios perceive between this player and a transmitting player 
		player setVariable ["tf_receivingDistanceMultiplicator", _interference];
		// Reduce the distance a player is able to send
		player setVariable ["tf_sendingDistanceMultiplicator", (1/_interference)];

		if(_debug) then {
			deleteMarkerLocal "InterferenceMarker";
			//Position Marker
			_debugMarker2 = createMarkerLocal ["InterferenceMarker", position player];
			_debugMarker2 setMarkerShape "ICON";
			_debugMarker2 setMarkerType "mil_triangle";
			if(!isNull _closest_jammer) then {
				_debugMarker2 setMarkerColor "ColorRed";
				_debugMarker2 setMarkerDir (player getDir _closest_jammer);
			};
			_debugMarker2 setMarkerText format ["%1", _interference];
		};

		// 5. Wait before running again.
		// This is needed because the player or the jammer will move
		sleep 1;
	};
	// clear up
	missionNamespace setVariable ["jammer_handler", nil];
	["Watcher completed"] call _debug_log;
};

if (_start_jammer_handler) then {
	_jammer_handler = [] spawn _jammer_loop_handler;		
	// Start jammer watcher script. Runs until no active jammers
	missionNamespace setVariable ["jammer_handler", _jammer_handler];
};


