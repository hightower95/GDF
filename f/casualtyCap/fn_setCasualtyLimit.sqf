// Used to activate a casualty limit

/*

Params: 
	Side = The side the limit will be active on
	Limit = Max number of casualties
	from_now = OPTIONAL should the limit be current casualty + limit, default is true
*/

if(!isServer) exitWith {};

#include "definitions.hpp";
hint "received";
missionNamespace setVariable ["received", "received", true];

params ["_side", "_limit", ["_from_now", true]];
// _side = _this select 0;
// _limit = _this select 1;
// _from_now = true;

_count_variable = format["%1_%2", _CASUALITY_COUNT_VAR_PREFIX, _side];
_limit_variable = format["%1_%2", _CASUALITY_LIMIT_VAR_PREFIX, _side];

if(_from_now) then {
	_limit = (missionNamespace getVariable [_count_variable, 0]) + _limit;
};

missionNamespace setVariable [_limit_variable, _limit, true];

[_side] call f_fnc_checkCasualtyLimit;