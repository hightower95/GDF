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

if isNil _jammer_object exitWith {
	diag_log "addTFARJammer.sqf: Jammer object none";
};

_debug = missionNamespace getVariable ["f_TFAR_Jammer_debug", false];

// Min interference is the interference at the 'max range' of the antenna. TFAR default is 1.0
_min_interference = 5;
// Strength of the jammer antenna. Calculations assume this is not variable - instead they calculate the interference for the closest jammer because this is less computationally expensive. (More than 1 jammer in a mission is a bit special)
_strength = 1000;
// Strength (S), min/Strength (m/S). Compute in advance
_jammer_params = [_strength, _min_interference / _strength];

/*Attach jammer variables to object*/
_jammer_object setVariable ["isTFARJammer", true];
_jammer_object setVariable ["jammer_range", _range];
_jammer_object setVariable ["jammer_active", true];
_jammer_object setVariable ["jammer_params", _jammer_params];

_jammer_object addEventHandler ["killed", {[_this select 0] call f_fnc_removeTFARJammer;}];

if(_debug) then {
	// Mark Area
	_jammer_marker = createmarker ["JAMMER_DebugMarker", position _jammer_object];
	_debugMarker setMarkerShape "ELLIPSE";
	_debugMarker setMarkerSize [_range, _range];

	// Mark position
	_debugMarker2 = createmarker ["JAMMER_DebugMarker2", position _jammer_object];
	_debugMarker2 setMarkerShape "ICON";
	_debugMarker2 setMarkerType "mil_dot";
	_text = format ["S:%1", _strength];
	_debugMarker2 setMarkerText _text;
	["addTFARJammer: Markers Initialized"] call BIS_fnc_log;
	systemChat "Marker Initialized";
};

// Add jammer to existing jammers
_jammers = missionNamespace getVariable ["f_TFAR_Jammers", []];
_jammer_count = count _jammers;
_jammers = _jammers + _jammer_object;
missionNamespace setVariable ["f_TFAR_Jammers", _jammers, true];

// If there are already jammers existing we can assume the script for jammers is already running
if(_jammer_count > 0) exitWith {
	diag_log "addTFARJammer: Watcher not spawned as TFAR jammer count > 0";
};

// Start jammer watcher script. Runs until no active jammers
_jammer_handler = [] spawn {
	_running = true;
	_debug = missionNamespace getVariable ["f_TFAR_Jammer_debug", false];
	_debug_log = {
		if(!(missionNamespace getVariable ["f_TFAR_Jammer_debug", false])) exitWith {}; 

		_text = format ["Client: %1, MissionTime: %2 ServerTime: %3 addTFARJammer.sqf, %2", name player, time, serverTime, _this select 0]; 
		if (name player == "Hightower") then {
			_text call BIS_fnc_log;
		};
		[_text] remoteExecCall ["BIS_fnc_log", 2];
	};
	
	while(_running) do {		
		// 1. Find the active jammers
		_jammers = missionNamespace getVariable ["f_TFAR_Jammers", _jammers, []];
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
			_jammer_range = _jammer getVariable ["jammer_range"];
			
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
		
		// 3. Calculate interference
		_interference = 1.0;
		
		if(_closest_jammer != objNull) then {
			_distance = player distance _closest_jammer;
			_jammer_range = _closest_jammer getVariable ["jammer_range"];

			[format["distance %1, range %2", _distance, _jammer_range]] call _debug_log;
			if(_jammer_range < 0 or _distance <= _jammer_range) then {
				_jammer_params = _closest_jammer getVariable ["jammer_params"];
				_jammer_params params ["_strength", "_K"];
				/* Formula Derivation:
				=STRENGTH * exp ( -SCALAR*(MIN(DISTANCE, RANGE)/RANGE)*(LN(MIN_INTER / STRENGTH)/-SCALAR))
				=S*exp(-a*D/R*ln(m/S)/-a)
				=S*exp(D/R*ln(m/S))
				=S*exp(ln(m/s ^ D/R))
				=S*(m/s)^(D/R)
				=S*(K^(D/R))
				where S=Strength, m=Min Interference, D=Player to jammer distance, R=Jammer range
				*/
				_Dist = MIN(_distance, _jammer_range);
				
				// This is an exponential decrease. (Its not physically accurate but is more understandable to a mission maker - as it forces an accepted minimum interference at the edge of the jammer range)
				_interference = _strength * (_K ^ (_Dist / _jammer_range));

			};
		};
		[format["Interference set at: %1", _interference]] call _debug_log;
		// 4. Apply interference
		// Increase the distance radios perceive between this player and a transmitting player 
		player setVariable ["tf_receivingDistanceMultiplicator", _interference];
		// Reduce the distance a player is able to send
		player setVariable ["tf_sendingDistanceMultiplicator", (1/_interference)];

		if(_debug) {
			deleteMarker "InterferenceMarker";
			//Position Marker
			_debugMarker2 = createmarker ["InterferenceMarker", position player];
			_debugMarker2 setMarkerShape "ICON";
			_debugMarker2 setMarkerType "mil_triangle";
			_debugMarker2 setMarkerColor "ColorRed";
			_debugMarker2 setMarkerText format ["%1", _interference];
		};

		// 5. Wait before running again.
		// This is needed because the player or the jammer will move
		sleep 1;
	};

	["Watcher completed"] call _debug_log;
};

missionNamespace setVariable ["jammer_handler", _jammer_handler];