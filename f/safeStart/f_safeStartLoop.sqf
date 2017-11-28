// F3 - Safe Start, Server Loop
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
//=====================================================================================

// Run the loop only on the server
if !isServer exitWith {};

// Redundant sleep to give everything a second to settle
sleep 2;

while {f_param_safe_start > 0} do {

	// Broadcast remaining time to players
	["SafeStart",[format["Time Remaining: %1 min",f_param_safe_start]]] remoteExec ["bis_fnc_showNotification",0];

	uiSleep 60; // Sleep 60 seconds

	// If mission timer has been terminated by admin briefing, simply exit
	if (f_param_safe_start < 0) exitWith {};

	// Reduce the mission timer by one
	f_param_safe_start = f_param_safe_start - 1;
	publicVariable "f_param_safe_start";
};

//Once the mission timer has reached 0, disable the safeties
if (f_param_safe_start == 0) then {
		// Broadcast message to players
		["SafeStartMissionStarting",["Mission starting now!"]] remoteExec ["bis_fnc_showNotification",0];

		// Remotely execute script to disable safety for all selectable units
		[false] remoteExec ["f_fnc_safety",0];
};