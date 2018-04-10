#include "..\..\config\modConfig\tfar.hpp";



if (!isNil "CBA_settings_fnc_set") then {
	// TFAR (Server Setting) - Whether long range radios are automatically added
	if(config_tfar_give_lr_radios_by_default) then {
		["TF_no_auto_long_range_radio", false] call CBA_settings_fnc_set;
	} else {
		["TF_no_auto_long_range_radio", true] call CBA_settings_fnc_set;
	};

	// TFAR (Server Setting) - If we give radios to regular soldiers
	if(config_tfar_give_sr_radios_to_all) then {
		["TF_give_personal_radio_to_regular_soldier", true, true] call CBA_settings_fnc_set;
	} else {
		["TF_give_personal_radio_to_regular_soldier", true, false] call CBA_settings_fnc_set;
	};	

	// TFAR - Should a side use the same frequencies?
	["TF_same_sw_frequencies_for_side", true, true] call CBA_settings_fnc_set;
	["TF_same_lr_frequencies_for_side", true, true] call CBA_settings_fnc_set;
	["TF_same_dd_frequencies_for_side", true, true] call CBA_settings_fnc_set;

	// TFAR - Automatically give DAGR to solider. 
	["tf_give_microdagr_to_soldier", false, true] call CBA_settings_fnc_set;
};


[] spawn {
	waitUntil { uiSleep 0.5; player call TFAR_fnc_haveSwRadio; };
	_sw_radio_settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
	_sw_radio_settings set [2, radio_frequencies_sr];
	[(call TFAR_fnc_activeSwRadio), _sw_radio_settings] call TFAR_fnc_setSwSettings;
};

if(isNil {missionNamespace getVariable "f_TFAR_Jammer_debug"}) then {
	if(isServer && hasInterface) then {
		// Debug puts a triangle on the player showing the interference value
		missionNamespace setVariable ["f_TFAR_Jammer_debug", true];
	} else {
		missionNamespace setVariable ["f_TFAR_Jammer_debug", false];	
	};
};
if(isNil {missionNamespace getVariable "f_TFAR_Jammer_markers_visible"}) then {
	missionNamespace setVariable ["f_TFAR_Jammer_markers_visible", true];
};


