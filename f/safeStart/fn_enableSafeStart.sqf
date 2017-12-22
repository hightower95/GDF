// F3 - Safe Start
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
//	This script inits the Mission Timer and the Safe Start, has the server setup the publicVariable
//      while the client waits, sets units invincibility and displays hints, then disables it.

//Setup the variables
// todo: move this parameter into a configuration file
waitUntil{!isNil "gd_param_safeStart"};
gd_param_safeStart = true;
if(gd_param_safeStart) then {
	if(time < 60) then { // If JIP - dont worry about safe start
		f_param_safe_start = 1; // 1 minute
	}; 	
} else {
	f_param_safe_start = 0;
};

// BEGIN SAFE-START LOOP
// If a value was set for the mission-timer, begin the safe-start loop and turn on invincibility

if (f_param_safe_start > 0) then {
	// The server will handle the loop and notifications
	if isServer then {
		[] execVM "f\safeStart\f_safeStartLoop.sqf";
	};

	// Enable invincibility for players
	if hasInterface then {
		[true] call f_fnc_safety;
	};
};