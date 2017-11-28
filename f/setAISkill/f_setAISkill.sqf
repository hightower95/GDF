// F3 - AI Skill Selector
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// RUN THE SCRIPT ONLY SERVER SIDE

if !(isServer) exitWith {};

// ====================================================================================

// WAIT FOR THE MISSION TO BEGIN
// By waiting a few seconds into the mission the server is giving time to settle and it assures that the component catches AI created during init

sleep 30;

// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_units","_superSkill","_highSkill","_mediumSkill","_lowSkill"];

// ====================================================================================

// DEFINE SKILL LEVELS
// These values define the total skill level as set by the parameter

_superSkill = 1.20;
_highSkill = 1.0;
_mediumSkill = 0.8;
_lowSkill = 0.6;

// This are the minimal skills a soldier set to _superSkill would have. For all other skill levels the values are rounded using the numbers above.
// These are recommended levels to avoid "laser" AI snipers. Change them accordingly if you are finding the AI to be too inaccurate or are using AI mods.

f_var_skillSet = [
	0.4,		// aimingAccuracy
	0.6,		// aimingShake
	0.6,		// aimingSpeed
	0.85,		// spotDistance
	0.7,		// spotTime
	1.8,		// courage
	2,			// reloadSpeed
	2,			// commanding
	1.6			// general
];

// The final skill will within +/- this range
f_var_skillRandom = 0.15;

// ====================================================================================

// BROADCAST PUBLIC VARIABLES
// Make the relevant global variables known to all clients

{publicVariable _x} forEach ["f_var_skillRandom","f_var_skillSet"];

// ====================================================================================

// SET UP SKILL Levels
// As the params can only set full numbers, we interpret each of them to set the correct value

f_var_skillAll =
switch (f_param_AISkill) do
{
// Super
	case 0:
	{
		 _superSkill;
	};
// High
	case 1:
	{
		 _highSkill;
	};
// Medium
	case 2:
	{
		_mediumSkill;
	};
// Low
	case 3:
	{
		_lowSkill;
	};
// Default
	default {
		99;
	};
};
publicVariable "f_var_skillAll";

// ====================================================================================

// SET KEY VARIABLES
// If an array of units was passed, the skill change will apply only to the units in the array

_units = if (count _this > 0) then [{_this},{allUnits}];

// ====================================================================================

// SET SKILL LEVELS FOR ALL AI
// AI Skill for all AIs is set using side levels (see above).
// By using the BI function BIS_fnc_MP we ensure that AI is set to the correct level for all connected clients, including the server

{
	private ["_skill","_skillarray"];
	_skill = 0;
	_skillArray = [];

    if !(_x getVariable ["f_setAISkill",false]) then {
		// We change the value of skill to the appropriate one depending on the unit's side
		_skill = f_var_skillAll;

		// If skill is 99 it is not configured in the params and the unit will be ignored
		if (_skill == 99) exitWith {
			_x setVariable ["f_setAISkill",true];
		};

		for "_i" from 0 to 8 do {
			_skilllevel = (f_var_skillSet select _i) * _skill;
			_skillArray pushBack (_skilllevel + random f_var_skillRandom - random f_var_skillRandom);
		};

		// Call the function to set the skills for the unit
		[_x,_skillArray] call f_fnc_setAISkill;
		
		//if (f_param_debugMode == 1) then { diag_log text format ["[F3] DEBUG (f\setAISkill\f_setAISkill.sqf): setting skill %1 for %2",_skillArray, typeOf _x]; };
		
     };
} forEach _units;