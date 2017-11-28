// F3 - Medical Systems ACE3 Advanced Medical System Converter
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
if !isServer exitWith {}; // Server only

waitUntil{!isNil "f_var_medical_level"};

if (f_var_medical_level == 0) exitWith {}; // ACE not running so don't do anything more!

// DECLARE VARIABLES AND FUNCTIONS
private ["_itemCargoList","_cntFAK","_cntMediKit"];
params["_unit"];

if (!alive _unit) exitWith {}; // Nothing to convert.

// ====================================================================================
// COUNT AMOUNT OF FAKS AND MEDIKITS

_itemCargoList = itemCargo _unit;
if (count _itemCargoList == 0) exitWith {}; // Nothing to convert.

_cntFAK = {_x == "FirstAidKit"} count _itemCargoList;
_cntMediKit = {_x == "MediKit"} count _itemCargoList;

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text format ["[F3] DEBUG (ace_medicGearConverter.sqf): Converting medical_level_%5 for %2 (%1 - F%3 M%4)",_unit, typeOf _unit, _cntFAK, _cntMediKit, f_var_medical_level]; };

// ====================================================================================
// REMOVE ALL VANILLA ITEMS

{
	if (_x == "FirstAidKit" || {_x == "MediKit"}) then {
		_itemCargoList = _itemCargoList - [_x];
		};
} forEach _itemCargoList;

clearItemCargoGlobal _unit;

{
	_unit addItemCargoGlobal [_x,1];
} forEach _itemCargoList;

// ====================================================================================
// ADD BACK ACE3 ITEMS FOR REMOVED VANILLA ITEMS

_unit addItemCargoGlobal ["ACE_fieldDressing", (_cntFAK * 5)];

// BASIC
if (f_var_medical_level == 1) exitWith {
	// Medic Specialist Equipment
	if (_unit getVariable ["ace_medical_medicclass", getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "attendant")] > 0) then { 
		_unit addItemCargoGlobal ["ACE_fieldDressing", 50];
		_unit addItemCargoGlobal ["ACE_morphine", 50];
		_unit addItemCargoGlobal ["ACE_epinephrine", 30];
		_unit addItemCargoGlobal ["ACE_bloodIV_250", 20];
		_unit addItemCargoGlobal ["ACE_bloodIV_500", 20];
		_unit addItemCargoGlobal ["ACE_bloodIV", 20];
	};
	
	// Fireteam sized cargo
	if (_cntFAK <= 25 && {_cntMediKit == 0}) then { 
		_unit addItemCargoGlobal ["ACE_fieldDressing", 20];
		_unit addItemCargoGlobal ["ACE_morphine", 20];
		_unit addItemCargoGlobal ["ACE_epinephrine", 5];
		_unit addItemCargoGlobal ["ACE_bloodIV", 4];
	};
	
	// Squad sized cargo
	if (_cntFAK <= 25 && {_cntMediKit == 1}) then { 
		// Add items for 1 medic
		_unit addItemCargoGlobal ["ACE_fieldDressing", 30];
		_unit addItemCargoGlobal ["ACE_morphine", 30];
		_unit addItemCargoGlobal ["ACE_epinephrine", 15];
		_unit addItemCargoGlobal ["ACE_bloodIV", 8];
	};
	
	// Platoon sized Cargo
	if (_cntFAK > 50 || {_cntMediKit > 1}) then { 
		// Add items for 4 medics
		_unit addItemCargoGlobal ["ACE_fieldDressing", 40];
		_unit addItemCargoGlobal ["ACE_morphine", 40];
		_unit addItemCargoGlobal ["ACE_epinephrine", 20];
		_unit addItemCargoGlobal ["ACE_bloodIV", 16];
	};
};

// ADVANCED
if (f_var_medical_level == 2) exitWith {	

	// Medic Specialist Equipment
	if (_unit getVariable ["ace_medical_medicclass", getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "attendant")] > 0) then 
	{
		_unit addItemCargoGlobal ["ACE_morphine", 20];
		_unit addItemCargoGlobal ["ACE_epinephrine", 20];
		_unit addItemCargoGlobal ["ACE_tourniquet", 10];
		_unit addItemCargoGlobal ["ACE_fieldDressing", 40];
		_unit addItemCargoGlobal ["ACE_elasticBandage", 40];
		_unit addItemCargoGlobal ["ACE_packingBandage", 30];
		_unit addItemCargoGlobal ["ACE_quikclot", 30];
		_unit addItemCargoGlobal ["ACE_bloodIV_250", 10];
		_unit addItemCargoGlobal ["ACE_bloodIV_500", 10];
		_unit addItemCargoGlobal ["ACE_bloodIV", 10];
		_unit addItemCargoGlobal ["ACE_plasmaIV_250", 10];
		_unit addItemCargoGlobal ["ACE_plasmaIV_500", 10];
		_unit addItemCargoGlobal ["ACE_plasmaIV", 10];
		_unit addItemCargoGlobal ["ACE_salineIV_250",10];
		_unit addItemCargoGlobal ["ACE_salineIV_500",10];
		_unit addItemCargoGlobal ["ACE_salineIV",10];
		if (ace_medical_uselocation_pak != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 12]; };
		if (ace_medical_uselocation_surgicalkit != 4 && ace_medical_enableadvancedwounds) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 16]; };
	};

	// FireTeam sized cargo
	if (_cntFAK <= 25 && {_cntMediKit == 0}) then {
		_unit addItemCargoGlobal ["ACE_morphine", 10];
		_unit addItemCargoGlobal ["ACE_epinephrine", 2];
		_unit addItemCargoGlobal ["ACE_tourniquet", 2];
		_unit addItemCargoGlobal ["ACE_fieldDressing", 20];
		_unit addItemCargoGlobal ["ACE_elasticBandage", 20];
		_unit addItemCargoGlobal ["ACE_packingBandage", 10];
		_unit addItemCargoGlobal ["ACE_quikclot", 10];
		_unit addItemCargoGlobal ["ACE_bloodIV_250", 2];
		_unit addItemCargoGlobal ["ACE_salineIV_500", 2];
		if (ace_medical_uselocation_pak != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 1]; };
		if (ace_medical_uselocation_surgicalkit != 4 && ace_medical_enableadvancedwounds) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 2]; };
	};

	// Squad sized cargo
	if (_cntFAK <= 25 && {_cntMediKit == 1}) then {
		// Add items for 1 medic
		_unit addItemCargoGlobal ["ACE_morphine", 15];
		_unit addItemCargoGlobal ["ACE_epinephrine", 4];
		_unit addItemCargoGlobal ["ACE_tourniquet", 4];
		_unit addItemCargoGlobal ["ACE_fieldDressing", 30];
		_unit addItemCargoGlobal ["ACE_elasticBandage", 30];
		_unit addItemCargoGlobal ["ACE_packingBandage", 15];
		_unit addItemCargoGlobal ["ACE_quikclot", 15];
		_unit addItemCargoGlobal ["ACE_bloodIV_250", 4];
		_unit addItemCargoGlobal ["ACE_salineIV_500", 4];
		if (ace_medical_uselocation_pak != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 2]; };
		if (ace_medical_uselocation_surgicalkit != 4 && ace_medical_enableadvancedwounds) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 4]; };
	};

	// Platoon sized Cargo
	if (_cntFAK > 50 || {_cntMediKit > 1}) then {
		// Add items for 4 medics
		_unit addItemCargoGlobal ["ACE_morphine", 20];
		_unit addItemCargoGlobal ["ACE_epinephrine", 8];
		_unit addItemCargoGlobal ["ACE_tourniquet", 8];
		_unit addItemCargoGlobal ["ACE_fieldDressing", 50];
		_unit addItemCargoGlobal ["ACE_elasticBandage", 50];
		_unit addItemCargoGlobal ["ACE_packingBandage", 30];
		_unit addItemCargoGlobal ["ACE_quikclot", 30];
		_unit addItemCargoGlobal ["ACE_bloodIV_250", 8];
		_unit addItemCargoGlobal ["ACE_salineIV_500",8];
		if (ace_medical_uselocation_pak != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 4]; };
		if (ace_medical_uselocation_surgicalkit != 4 && ace_medical_enableadvancedwounds) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 8]; };
	};
};