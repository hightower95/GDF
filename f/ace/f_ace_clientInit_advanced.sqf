// F3 - ACE Advanced Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text format ["[F3] DEBUG (ACEadvanced_clientInit.sqf): Running for %1.",player]; };

// Wait for gear assignation to take place
waitUntil{(player getVariable ["f_var_assignGear_done", false])};

private "_typeofUnit";

_typeofUnit = player getVariable "f_var_assignGear";

// Remove pre-assigned medical items
{player removeItems _x} forEach ["FirstAidKit","Medikit","ACE_tourniquet","ACE_fieldDressing","ACE_morphine","ACE_epinephrine","ACE_packingBandage","ACE_salineIV_250"];

// Add basic items to all units
{player addItem "ACE_CableTie"} forEach [1,2,3,4];
{player addItem "ACE_fieldDressing"} forEach [1,2,3,4,5,6,7,8];
{player addItem "ACE_elasticBandage"} forEach [1,2,3,4,5,6,7,8];
{player addItem "ACE_morphine"} forEach [1,2];
player addItem "ACE_epinephrine";
player addItem "ACE_tourniquet";

player setVariable ["ACE_hasEarPlugsIn", true, true];
player removeItem "ACE_EarPlugs";

if (vehicle player == player) then {
	[player, currentWeapon player, currentMuzzle player] call ACE_SafeMode_fnc_lockSafety;
};

if (_typeofUnit == "m") then {
	player setVariable ["ACE_IsMedic",1];
	(unitBackpack player) addItemCargoGlobal ["ACE_tourniquet", 4];
	(unitBackpack player) addItemCargoGlobal ["ACE_quikclot", 15];
	(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_elasticBandage", 30];
	(unitBackpack player) addItemCargoGlobal ["ACE_packingBandage", 15];
	(unitBackpack player) addItemCargoGlobal ["ACE_morphine", 20];
	(unitBackpack player) addItemCargoGlobal ["ACE_epinephrine", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_salineIV_500", 6];
	if (ace_medical_uselocation_pak != 4) then { (unitBackpack player) addItemCargoGlobal ["ACE_personalAidKit", 2]; };
	if (ace_medical_uselocation_surgicalkit != 4 && ace_medical_enableadvancedwounds) then { (unitBackpack player) addItemCargoGlobal ["ACE_surgicalKit", 1]; };
};

if (_typeofUnit in ["co","dc"] || "ACE_Vector" in (items player + assignedItems player)) then {
	player addItem "ACE_microDAGR";
};

if (_typeofUnit in ["vc","vd","vg","pp","pc"]) then {
	player setVariable ["ACE_IsEngineer",1];
};

if (_typeofUnit == "eng") then {
	player setVariable ["ACE_IsEngineer",1];
	player addItem "ACE_clacker";
	player addItem "ACE_M26_Clacker";
	player addItem "ACE_wirecutter";
	player addItem "ACE_EntrenchingTool";
};

if (_typeofUnit == "engm") then {	
	player setVariable ["ACE_isEOD",1];
	player addItem "ACE_DefusalKit";
	player addItem "ACE_wirecutter";
	player addItem "ACE_EntrenchingTool";
	player addWeapon "ACE_VMH3";
};

if (_typeofUnit in ["sn","sp"]) then {
	player addItem "ACE_ATragMX";
	player addItem "ACE_Kestrel4500";
	player addItem "ACE_RangeCard";
};

if (_typeofUnit in ["ar","mmgg"] && playerSide == west) then {
	player addItem "ACE_SpareBarrel";
};

if (_typeofUnit in ["mtrg","mtrag"]) then {
	player addItem "ACE_RangeTable_82mm";
	player addItem "ACE_MapTools";
	player addItem "ACE_RangeCard";
};

player setVariable ["f_var_ACEclientInitDone",true];

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text format ["[F3] DEBUG (ACEadvanced_clientInit.sqf): Completed for %1.",player]; };
