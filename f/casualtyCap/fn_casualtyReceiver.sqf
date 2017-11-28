if(!isServer) exitWith {};

#include "definitions.hpp";

_player = _this select 0;
_side = side _player;

_count_variable = format["%1_%2", _CASUALITY_COUNT_VAR_PREFIX, _side];

_currentCount = missionNamespace getVariable [_count_variable, 0];

missionNamespace setVariable [_count_variable, _currentCount + 1];
publicVariable _count_variable;

_marker_name = format ["respawn_%1", _side];
_marker_name setMarkerText format["Casualties: %1",(_currentCount+1)];

/* This script runs on the server. When someone goes unconscious they tell the server
 to make use of this in a mission simply add a trigger with condition:
	missionNamespace getVariable [_count_variable, 0] > <INSERT NUMBER>
	where _count_variable = "CasualtyLimit_WEST" or "CasualtyLimit_GUER" etc...
Into the 'on activation' box insert:
	["casualties",'f_fnc_mpEnd',false] spawn BIS_fnc_MP;

 Alternatively, you may consider no activation text, and use the trigger to activate a 'fallback' objective.
*/


// if (_casualty_limit > -1 && _currentCount > _casualty_limit) then {
// 		["casualties",'f_fnc_mpEnd',false] spawn BIS_fnc_MP;
// };