// [QGVAR(setUnconscious), DFUNC(setUnconscious)] call CBA_fnc_addEventHandler;

if(!hasInterface) exitWith {};

if(GD_MOD_ACE_Enabled) then {
	["ace_unconscious", {
		params ["_unit", "_isUnconscious"]; 
		if (_unit == player && _isUnconscious) then {
			// remoteExec with 2nd parameter of '2' means run on server only.
			[player] remoteExec ["f_fnc_casualtyReceiver", 2];
		};
	}] call CBA_fnc_addEventHandler;

} else {
	// Written directly into farooq. (FAR_revive_funcs) line 110

};

// ["ace_unconscious", {
//     params ["_unit", "_status"];
//     if (local _unit) then {
//         if (_status) then {
//             _unit setVariable ["tf_voiceVolume", 0, true];
//             _unit setVariable ["tf_unable_to_use_radio", true, true];

//             _unit setVariable ["acre_sys_core_isDisabled", true, true];
//         } else {
//             _unit setVariable ["tf_voiceVolume", 1, true];
//             _unit setVariable ["tf_unable_to_use_radio", false, true];

//             _unit setVariable ["acre_sys_core_isDisabled", false, true];
//         };
//     };
// }] call CBA_fnc_addEventHandler;