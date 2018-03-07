if(!isServer) exitWith {};

#include "definitions.hpp";

params ["_side"];

_count_variable = format["%1_%2", _CASUALITY_COUNT_VAR_PREFIX, _side];
_limit_variable = format["%1_%2", _CASUALITY_LIMIT_VAR_PREFIX, _side];

_currentCount = missionNamespace getVariable [_count_variable, -1];
_currentLimit = missionNamespace getVariable [_limit_variable, -1];

if(_currentCount == -1) exitWith {

};

if(_currentLimit == -1) exitWith {

};

if(_currentCount > _currentLimit) then {
	_signal_variable = format["%1_cas_cap_state", _side];
	missionNamespace setVariable [_signal_variable, true, true];
};