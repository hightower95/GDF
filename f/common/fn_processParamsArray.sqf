// F3 - Process ParamsArray
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

if (isNil "f_var_setParams") then {
	if (isNil "paramsArray") then {
		{
			_paramName = (configName _x);
			_paramValue = (getNumber (missionConfigFile >> "Params" >> _paramName >> "default"));
			//diag_log text format["[F3] INFO (fn_processParamsArray.sqf): paramsArray (defaults) parsing %1 (%2).",_paramName,_paramValue];
			_paramCode = (getText (missionConfigFile >> "Params" >> _paramName >> "code"));
			_code = format[_paramCode, _paramValue];
			try {
				call compile _code;
			} catch {
				diag_log text format["[F3] ERROR (fn_processParamsArray.sqf): Error compiling code in %1.",_paramName];
			};
			missionNamespace setVariable [_paramName,_paramValue];
			publicVariable _paramName;
		} forEach ("true" configClasses (missionConfigFile >> "Params"));
	} else {
		{
			_paramName =(configName ((missionConfigFile >> "Params") select _forEachIndex));
			//diag_log text format["[F3] INFO (fn_processParamsArray.sqf): paramsArray parsing %1 (%2).",_paramName,_x];
			_paramCode = (getText (missionConfigFile >> "Params" >> _paramName >> "code"));
			_code = format[_paramCode, _x];
			try {
				call compile _code;
			} catch {
				diag_log text format["[F3] ERROR (fn_processParamsArray.sqf): Error compiling code in %1.",_paramName];
			};
			missionNamespace setVariable [_paramName,_x];
			publicVariable _paramName;
		} forEach paramsArray;
	};
	
	// Set SP Debug
	if (!isMultiplayer) then {f_param_debugMode = 1};

	[] call f_fnc_initAdmins;
	
	// In-built casualty counter.
	f_var_casualtyCount_west = 0; publicVariable "f_var_casualtyCount_west";
	f_var_casualtyCount_east = 0; publicVariable "f_var_casualtyCount_east";
	f_var_casualtyCount_indp = 0; publicVariable "f_var_casualtyCount_indp";
	f_var_casualtyCount_civ = 0; publicVariable "f_var_casualtyCount_civ";
	f_var_missionissues = "";
	
	f_var_setParams = true; publicVariable "f_var_setParams";	
	
	if (f_param_debugMode == 1) then { diag_log text format["[F3] DEBUG (fn_processParamsArray.sqf): f_var_setParams: %1",f_var_setParams]; };
};