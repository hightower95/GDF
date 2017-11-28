// F3 - Multiplayer Ending Controller
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
params ["_ending",["_state",true]];

// SERVER DELAY
// If this script is executing on the server a small delay is used.

if isServer then {
	sleep 3;
// DEBUG
	if (f_param_debugMode == 1) then {
		diag_log text "[F3] DEBUG (f_fnc_mpEndReciever): This is the server.";
	};
};

// DEBUG
if (f_param_debugMode == 1) then {
	diag_log text format ["[F3] DEBUG (f_fnc_mpEndReciever): _ending = %1, _state = %2",_ending,_state];
};

_config_ending_to_find = format ["end_%1",_ending];
_config_ending = nil;

if(!isNull(missionConfigFile >> "CfgDebriefing" >> _config_ending_to_find)) then {
	_config_ending = missionConfigFile >> "CfgDebriefing" >> _config_ending_to_find;
} else {
// This is why default ending should not be removed from endings.hpp
	_config_ending = missionConfigFile >> "CfgDebriefing" >> "End_default";
};

// This code block does the following:
// If the mission ending title property = "Mission Complete", the mission is succeeded, else it is failed.
// any issues- looking at (config/endings.hpp)
_title = getText(_config_ending >> "title");
_state = ((_title) find "Complete") > -1;


// Using the ending we just found call the BIS function with it.
_ending = format ["end_%1",_ending];
[_ending,_state] spawn BIS_fnc_endMission;

// EXIT THE SPECTATOR SCRIPT IF IS OPEN
if (!isNull findDisplay 7810) then {closeDialog 0};