// F3 - Multiplayer Ending Controller
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// SERVER CHECK
// Make sure that the script is only run on the server
if (!isServer || time < 10) exitWith {
	diag_log text "[F3] WARNING (f_fnc_mpEnd): Tried to trigger ending before mission started, ignoring.";
};

// SET ENDING & BROADCAST
// The desired ending # is taken from the arguments passed to this script.
// Using BIS_fnc_MP the function mpEndReceiver is being spawned on all clients (and server),
// with the passed ending # as parameter
	
if (isNil "f_var_EndingTriggered") then {
	_this remoteExec ["f_fnc_mpEndReceiver",0];
};

f_var_EndingTriggered = true;